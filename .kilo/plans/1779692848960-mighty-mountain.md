# Plan: Job Tai Xe Bus - Bus Driver Job System

## Overview
Tao he thong job tai xe xe buyt (Bus Driver) cho server SA-MP. Day la job Tier 1 (simple) theo guideline - fixed route loop, checkpoint-based, khong can dynamic economy hay faction interaction.

## Design Summary

**Job ID:** 26 (unused, gap between job 25 - Garbage va MAX_JOBTYPES=31)

**State Machine (Simple):**
```
NONE → DRIVING → STOPPING (5s freeze) → DRIVING → ... → COMPLETED → COOLDOWN
                ↘ LEFT_VEHICLE (30s cancel) → FAILED
```

**Route:** 21 checkpoints fixed loop quanh San Fierro, bat dau/ket thuc tai ben xe (-1710, 1332).

**Reward:** Base pay per loop + safe driver bonus (vehicle HP > 800) + random tip drops.

**Anti-Exploit:** Speed limit, leave-vehicle timeout (30s), no teleport check needed (Tier 1).

---

## Files to Modify

### 1. NEW: `gamemodes/includes/jobs/bussystem.pwn`
File chinh chua toan bo logic job bus.

**Structure:**

```
#include <YSI\y_hooks>

// ===== CONSTANTS =====
#define BUS_MAX_STOPS           21
#define BUS_FREEZE_TIME         5       // giay freeze tai moi tram
#define BUS_LEAVE_TIMEOUT       30      // giay roi xe truoc khi huy chuyen
#define BUS_BASE_PAY            3000    // luong co ban 1 vong
#define BUS_SAFE_BONUS          1500    // thuong lai xe an toan
#define BUS_HEALTH_THRESHOLD    800.0   // nguong HP de nhan thuong
#define BUS_TIP_CHANCE          8       // 8% co hoi nhan tip
#define BUS_TIP_MIN             20
#define BUS_TIP_MAX             80
#define BUS_MAX_SPEED           80.0    // km/h gioi han toc do

// Bus vehicles (model 431 = Bus, 437 = Coach)
#define BUS_VEHICLE_MODEL       431
#define BUS_DEPOT_X             -1655.2467
#define BUS_DEPOT_Y             1315.2148
#define BUS_DEPOT_Z             7.0391
#define BUS_DEPOT_ANGLE         135.5355

// ===== VARIABLES =====
new BusVehicles[8];                     // 8 xe bus tai ben
new Text3D:BusStopLabel[BUS_MAX_STOPS]; // 3D label tai moi tram dung
new bool:BusOnRoute[MAX_PLAYERS];       // player dang chay tuyen
new BusStopIndex[MAX_PLAYERS];          // tram hien tai (0-20)
new BusFreezeTimer[MAX_PLAYERS];        // timer freeze
new BusLeaveTimer[MAX_PLAYERS];         // timer roi xe
new BusStartHealth[MAX_PLAYERS];        // HP xe luc bat dau
new BusLoopCount[MAX_PLAYERS];          // so vong da chay
new BusTotalTips[MAX_PLAYERS];          // tong tip nhan duoc

// ===== CHECKPOINT DATA =====
// 21 tram dung quanh San Fierro
new const Float:BusStops[BUS_MAX_STOPS][3] = {
    {-1710.0544, 1332.0048, 7.0468},   // Tram 1 - Ben xe
    {-2216.4758, 1339.1011, 7.0391},   // Tram 2
    {-2612.4548, 1328.7556, 7.0391},   // Tram 3
    {-2812.6580, 889.0310, 43.9063},   // Tram 4
    {-2409.7886, 804.0561, 35.0313},   // Tram 5
    {-2160.8662, 804.5095, 67.7715},   // Tram 6
    {-2011.4353, 768.0104, 45.2969},   // Tram 7
    {-2010.5522, 580.4526, 35.0156},   // Tram 8
    {-2289.9426, 572.7697, 35.0156},   // Tram 9
    {-2629.2959, 572.7416, 14.4609},   // Tram 10
    {-2702.3477, 426.7726, 4.1797},    // Tram 11
    {-2602.3909, 401.2941, 11.6663},   // Tram 12
    {-2452.8137, 558.8687, 22.1036},   // Tram 13
    {-2283.2654, 559.2503, 35.0156},   // Tram 14
    {-2010.4056, 277.8952, 33.1947},   // Tram 15
    {-1824.9193, -121.0745, 5.4975},   // Tram 16
    {-1806.0878, 197.8516, 14.9609},   // Tram 17
    {-1560.5638, 491.2933, 7.0313},    // Tram 18
    {-1521.4893, 916.9844, 7.0391},    // Tram 19
    {-1579.4520, 1173.3695, 7.0468},   // Tram 20
    {-1632.0118, 1254.3646, 7.0468}    // Tram 21 - Ve ben xe
};

// Bus spawn positions tai ben xe (8 vi tri)
new const Float:BusSpawnPos[8][4] = {
    {-1655.2467, 1315.2148, 7.0391, 135.5355},
    {-1651.6892, 1311.5261, 7.0326, 134.7752},
    {-1648.0549, 1307.8115, 7.0308, 143.3406},
    {-1644.6403, 1303.8441, 7.0288, 144.9923},
    {-1641.3740, 1300.6317, 7.0288, 148.3596},
    {-1637.5903, 1297.0999, 7.0346, 144.6664},
    {-1634.2915, 1293.1744, 7.0391, 142.8198},
    {-1631.0381, 1289.6903, 7.0391, 144.6664}
};

// NPC chat messages (random)
new const BusNPCChats[][] = {
    "Bac tai nhac to len xiu duoc khong?",
    "Troi mai cai thanh pho Los Santos nay dao nay cuop boc nhieu qua...",
    "Eh eh nha tui o khoang nay, cho xuong di mai oi!",
    "Bac tai di cham cham thoi, tui say xe qua...",
    "Hom nay troi dep qua ha, di xe buyt la tuyet nhat!",
    "Oi giua trua nang qua, may lanh xe buyt co khong?",
    "Bac tai co biet tram nay gan cho khong?",
    "Tui nghe noi thanh pho sap co duong moi, co that khong?",
    "Xin chao! Toi la khach hang moi day!",
    "Bac tai oi, xe nay chay em ghe!"
};

// ===== HOOKS =====

hook OnGameModeInit()
{
    // Spawn 8 xe bus tai ben xe
    for(new i = 0; i < 8; i++) {
        BusVehicles[i] = AddStaticVehicleEx(BUS_VEHICLE_MODEL,
            BusSpawnPos[i][0], BusSpawnPos[i][1], BusSpawnPos[i][2], BusSpawnPos[i][3],
            -1, -1, 300);  // respawn 300s (5 phut)
    }
    
    // Tao 3D text label tai moi tram dung
    for(new i = 0; i < BUS_MAX_STOPS; i++) {
        new labelMsg[128];
        format(labelMsg, sizeof(labelMsg), "{FFFF00}Ben Xe Buyt {FFFFFF}Tram %d\n{FFFF00}Nhan {FFFFFF}~k~~CONVERSATION_YES~ {FFFF00}de do xe tai day", i + 1);
        BusStopLabel[i] = CreateDynamic3DTextLabel(labelMsg, COLOR_YELLOW,
            BusStops[i][0], BusStops[i][1], BusStops[i][2] + 1.5,
            20.0, .testlos = 1, .streamdistance = 20.0);
    }
    
    // 3D text label tai ben xe (depot)
    CreateDynamic3DTextLabel("{FFFF00}Ben Xe Buyt\n{FFFFFF}Su dung {FFFF00}/busrun {FFFFFF}de bat dau tuyen duong", COLOR_YELLOW,
        -1710.0544, 1332.0048, 7.0468 + 1.5,
        30.0, .testlos = 1, .streamdistance = 30.0);
    
    return 1;
}

hook OnPlayerConnect(playerid)
{
    BusOnRoute[playerid] = false;
    BusStopIndex[playerid] = 0;
    BusFreezeTimer[playerid] = 0;
    BusLeaveTimer[playerid] = 0;
    BusStartHealth[playerid] = 0.0;
    BusLoopCount[playerid] = 0;
    BusTotalTips[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    Bus_ResetJob(playerid);
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(!BusOnRoute[playerid]) return 1;
    if(!IsPlayerInAnyVehicle(playerid)) return 1;
    if(!IsAnBus(GetPlayerVehicleID(playerid))) return 1;

    // Kiem tra xem co dung tram dung khong
    if(BusStopIndex[playerid] < BUS_MAX_STOPS) {
        // Freeze xe 5 giay
        TogglePlayerControllable(playerid, false);
        new stopIdx = BusStopIndex[playerid];
        
        // GameText countdown
        GameTextForPlayer(playerid, "~w~Khach dang len xe...~n~~y~5", 1000, 4);
        BusFreezeTimer[playerid] = BUS_FREEZE_TIME;
        
        // Random NPC chat (30% chance)
        if(random(100) < 30) {
            new chatIdx = random(sizeof(BusNPCChats));
            new chatMsg[128];
            format(chatMsg, sizeof(chatMsg), "{808080}[Hanh khach] %s", BusNPCChats[chatIdx]);
            SendClientMessageEx(playerid, COLOR_GREY, chatMsg);
        }
        
        // Random tip drop (8% chance)
        if(random(100) < BUS_TIP_CHANCE) {
            new tipAmount = BUS_TIP_MIN + random(BUS_TIP_MAX - BUS_TIP_MIN);
            new tipMsg[128];
            format(tipMsg, sizeof(tipMsg), "* Mot hanh khach lam rot cai vi / dong ho tri gia $%d tren ghe!", tipAmount);
            SendClientMessageEx(playerid, COLOR_GREEN, tipMsg);
            GivePlayerCash(playerid, tipAmount);
            BusTotalTips[playerid] += tipAmount;
        }
        
        // Bat dau timer freeze countdown
        SetTimerEx("Bus_FreezeCountdown", 1000, false, "i", playerid);
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    // Player roi khoi xe bus khi dang chay tuyen
    if(oldstate == PLAYER_STATE_DRIVER && BusOnRoute[playerid]) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsAnBus(vehicleid)) {
            // Da roi khoi xe bus
            Bus_StartLeaveTimer(playerid);
        }
    }
    
    // Player lai xe bus lai
    if(newstate == PLAYER_STATE_DRIVER && BusOnRoute[playerid]) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(IsAnBus(vehicleid)) {
            // Huy timer roi xe
            if(BusLeaveTimer[playerid] > 0) {
                BusLeaveTimer[playerid] = 0;
                KillTimer(BusLeaveTimer[playerid]);
                SendClientMessageEx(playerid, COLOR_GREEN, "Ban da tro lai xe bus! Tiep tuc tuyen duong.");
            }
        }
    }
    return 1;
}

// ===== TIMERS =====

forward Bus_FreezeCountdown(playerid);
public Bus_FreezeCountdown(playerid)
{
    if(!BusOnRoute[playerid]) return;
    if(BusFreezeTimer[playerid] <= 0) {
        // Het thoi gian freeze, cho phep di tiep
        TogglePlayerControllable(playerid, true);
        BusStopIndex[playerid]++;
        
        if(BusStopIndex[playerid] >= BUS_MAX_STOPS) {
            // Hoan thanh 1 vong
            Bus_CompleteLoop(playerid);
        } else {
            // Dat checkpoint tiep theo
            Bus_SetNextCheckpoint(playerid);
            new msg[64];
            format(msg, sizeof(msg), "~g~Di den tram %d/%d", BusStopIndex[playerid] + 1, BUS_MAX_STOPS);
            GameTextForPlayer(playerid, msg, 2000, 4);
        }
        return;
    }
    
    // Countdown
    new countdownMsg[64];
    format(countdownMsg, sizeof(countdownMsg), "~w~Khach dang len xe...~n~~y~%d", BusFreezeTimer[playerid]);
    GameTextForPlayer(playerid, countdownMsg, 1000, 4);
    BusFreezeTimer[playerid]--;
    SetTimerEx("Bus_FreezeCountdown", 1000, false, "i", playerid);
}

forward Bus_LeaveCheck(playerid);
public Bus_LeaveCheck(playerid)
{
    if(!BusOnRoute[playerid]) return;
    if(BusLeaveTimer[playerid] <= 0) {
        // Huy chuyen - that bai
        Bus_FailJob(playerid);
        return;
    }
    
    if(!IsPlayerInAnyVehicle(playerid) || !IsAnBus(GetPlayerVehicleID(playerid))) {
        // Van chua tro lai xe
        new msg[64];
        format(msg, sizeof(msg), "~r~Hay tro lai xe bus! Con %d giay", BusLeaveTimer[playerid]);
        GameTextForPlayer(playerid, msg, 1500, 4);
        BusLeaveTimer[playerid]--;
        SetTimerEx("Bus_LeaveCheck", 1000, false, "i", playerid);
    }
    // Neu da tro lai xe, timer se duoc huy trong OnPlayerStateChange
}

// ===== COMMANDS =====

CMD:busrun(playerid, params[])
{
    // Kiem tra job
    if(PlayerInfo[playerid][pJob] != 26 && PlayerInfo[playerid][pJob2] != 26 && PlayerInfo[playerid][pJob3] != 26) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la tai xe bus!");
    }
    
    // Kiem tra da dang chay tuyen chua
    if(BusOnRoute[playerid]) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang chay tuyen roi!");
    }
    
    // Kiem tra dang ngoi tren xe bus
    if(!IsPlayerInAnyVehicle(playerid) || !IsAnBus(GetPlayerVehicleID(playerid))) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban can ngoi tren xe bus de bat dau!");
    }
    
    // Kiem tra checkpoint hien co
    if(CheckPointCheck(playerid)) {
        callcmd::killcheckpoint(playerid, params);
    }
    
    // Bat dau chuyen
    BusOnRoute[playerid] = true;
    BusStopIndex[playerid] = 0;
    BusLoopCount[playerid] = 0;
    BusTotalTips[playerid] = 0;
    
    // Luu HP xe luc bat dau
    new Float:health;
    GetVehicleHealth(GetPlayerVehicleID(playerid), health);
    BusStartHealth[playerid] = health;
    
    // Dat checkpoint dau tien
    Bus_SetNextCheckpoint(playerid);
    
    SendClientMessageEx(playerid, COLOR_YELLOW, "=== TUYEN XE BUYT ===");
    SendClientMessageEx(playerid, COLOR_WHITE, "Ban da bat dau tuyen xe buyt. Hay theo cac diem danh dau tren ban do.");
    SendClientMessageEx(playerid, COLOR_WHITE, "Co 21 tram dung. Cham vao tram de don/khach.");
    SendClientMessageEx(playerid, COLOR_WHITE, "Su dung /huybus de huy chuyen.");
    GameTextForPlayer(playerid, "~g~Bat dau tuyen xe buyt!~n~Di den tram dau tien", 3000, 4);
    
    return 1;
}

CMD:huybus(playerid, params[])
{
    if(!BusOnRoute[playerid]) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dang chay tuyen xe buyt!");
    }
    
    Bus_ResetJob(playerid);
    DisablePlayerCheckpoint(playerid);
    TogglePlayerControllable(playerid, true);
    
    SendClientMessageEx(playerid, COLOR_RED, "Ban da huy chuyen xe buyt. Khong co tien thuong.");
    GameTextForPlayer(playerid, "~r~Da huy chuyen", 3000, 4);
    return 1;
}

// ===== STOCK FUNCTIONS =====

stock Bus_SetNextCheckpoint(playerid)
{
    if(BusStopIndex[playerid] < BUS_MAX_STOPS) {
        new idx = BusStopIndex[playerid];
        SetPlayerCheckpoint(playerid, BusStops[idx][0], BusStops[idx][1], BusStops[idx][2], 5.0);
    }
}

stock Bus_CompleteLoop(playerid)
{
    BusLoopCount[playerid]++;
    
    // Tinh tien thuong
    new payment = BUS_BASE_PAY;
    
    // Kiem tra HP xe de tinh thuong an toan
    new Float:health;
    GetVehicleHealth(GetPlayerVehicleID(playerid), health);
    
    new bonusMsg[128];
    if(health >= BUS_HEALTH_THRESHOLD) {
        payment += BUS_SAFE_BONUS;
        format(bonusMsg, sizeof(bonusMsg), "+ Thuong lai xe an toan: $%s (HP: %.0f)", number_format(BUS_SAFE_BONUS), health);
    } else {
        format(bonusMsg, sizeof(bonusMsg), "~r~Khong du dieu kien thuong an toan (HP: %.0f < %.0f)", health, BUS_HEALTH_THRESHOLD);
    }
    
    // Skill bonus (level cao = bonus nhe)
    new skillBonus = 0;
    new level = GetJobLevel(playerid, 26);
    if(level >= 2) skillBonus = 200;
    if(level >= 3) skillBonus = 500;
    if(level >= 4) skillBonus = 800;
    if(level >= 5) skillBonus = 1200;
    payment += skillBonus;
    
    // Tra tien
    GivePlayerCash(playerid, payment);
    
    // Tang skill
    if(PlayerInfo[playerid][pDoubleEXP] > 0) {
        PlayerInfo[playerid][pBusSkill] += 2;
        SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da dat 2 diem ki nang bus (Double EXP).");
    } else {
        PlayerInfo[playerid][pBusSkill] += 1;
    }
    
    // Thong bao
    SendClientMessageEx(playerid, COLOR_GREEN, "=== HOAN THANH TUYEN XE BUYT ===");
    new payMsg[128];
    format(payMsg, sizeof(payMsg), "Luong co ban: $%s", number_format(BUS_BASE_PAY));
    SendClientMessageEx(playerid, COLOR_WHITE, payMsg);
    SendClientMessageEx(playerid, COLOR_WHITE, bonusMsg);
    if(skillBonus > 0) {
        format(payMsg, sizeof(payMsg), "Bonus ky nang (Level %d): $%s", level, number_format(skillBonus));
        SendClientMessageEx(playerid, COLOR_WHITE, payMsg);
    }
    if(BusTotalTips[playerid] > 0) {
        format(payMsg, sizeof(payMsg), "Tong tip: $%s", number_format(BusTotalTips[playerid]));
        SendClientMessageEx(playerid, COLOR_WHITE, payMsg);
    }
    format(payMsg, sizeof(payMsg), "Tong cong: $%s", number_format(payment));
    SendClientMessageEx(playerid, COLOR_YELLOW, payMsg);
    
    // Reset de chay vong moi
    BusStopIndex[playerid] = 0;
    Bus_SetNextCheckpoint(playerid);
    
    new loopMsg[64];
    format(loopMsg, sizeof(loopMsg), "~g~Vong %d hoan thanh!~n~Bat dau vong moi...", BusLoopCount[playerid]);
    GameTextForPlayer(playerid, loopMsg, 3000, 4);
}

stock Bus_FailJob(playerid)
{
    SendClientMessageEx(playerid, COLOR_RED, "Chuyen xe buyt da bi huy vi ban roi khoi xe qua lau!");
    GameTextForPlayer(playerid, "~r~That bai!", 3000, 4);
    Bus_ResetJob(playerid);
    DisablePlayerCheckpoint(playerid);
    TogglePlayerControllable(playerid, true);
}

stock Bus_StartLeaveTimer(playerid)
{
    BusLeaveTimer[playerid] = BUS_LEAVE_TIMEOUT;
    SendClientMessageEx(playerid, COLOR_RED, "Ban da roi khoi xe bus! Hay tro lai trong 30 giay hoac chuyen se bi huy.");
    SetTimerEx("Bus_LeaveCheck", 1000, false, "i", playerid);
}

stock Bus_ResetJob(playerid)
{
    BusOnRoute[playerid] = false;
    BusStopIndex[playerid] = 0;
    BusFreezeTimer[playerid] = 0;
    BusLeaveTimer[playerid] = 0;
    BusStartHealth[playerid] = 0.0;
    BusLoopCount[playerid] = 0;
    BusTotalTips[playerid] = 0;
}

stock Bus_IsPlayerOnRoute(playerid)
{
    return BusOnRoute[playerid];
}
```

**Key mechanics:**
- `/busrun` - Bat dau chuyen (can ngoi tren xe bus, can job 26)
- `/huybus` - Huy chuyen
- Checkpoint flow: 21 tram, freeze 5s moi tram, countdown GameText
- NPC chat: 30% chance moi tram, gray color, chi driver thay
- Tip drop: 8% chance, $20-80
- Safe driver bonus: $1500 neu HP >= 800
- Skill bonus: tang theo level (0/200/500/800/1200)
- Leave vehicle: 30s timeout → fail
- Loop: sau 21 tram → nhan tien → reset → tram 0 (cho phep chay lien tuc)

---

### 2. MODIFY: `gamemodes/includes/enums.pwn`
**Line ~1291** (sau `pGarbageSkill`):
```pawn
pGarbageSkill,
pBusSkill,          // ADD THIS
```

---

### 3. MODIFY: `gamemodes/includes/defines.pwn`
**Line ~85** (sau `#define TYPE_DELIVERVEHICLE 16`):
```pawn
#define 		TYPE_DELIVERVEHICLE			16
#define 		TYPE_BUSFREEZE				17    // ADD THIS
```

---

### 4. MODIFY: `gamemodes/includes/mysql.pwn`

**Load section (~line 633, sau GarbageSkill):**
```pawn
cache_get_value_name_int(row,  "GarbageSkill", PlayerInfo[extraid][pGarbageSkill]);
cache_get_value_name_int(row,  "BusSkill", PlayerInfo[extraid][pBusSkill]);    // ADD
```

**Save section (~line 2481, sau GarbageSkill):**
```pawn
SavePlayerInteger(query, GetPlayerSQLId(playerid), "GarbageSkill", PlayerInfo[playerid][pGarbageSkill]);
SavePlayerInteger(query, GetPlayerSQLId(playerid), "BusSkill", PlayerInfo[playerid][pBusSkill]);    // ADD
```

---

### 5. MODIFY: `gamemodes/includes/jobs/jobcore.pwn`

**GetJobLevel function (~line 174, sau case 25 garbage):**
```pawn
case 25: { ... }  // existing garbage
case 26:    // ADD: Bus Driver
{
    new skilllevel = PlayerInfo[playerid][pBusSkill];
    if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
    else if(skilllevel >= 50 && skilllevel < 150) jlevel = 2;
    else if(skilllevel >= 150 && skilllevel < 300) jlevel = 3;
    else if(skilllevel >= 300 && skilllevel < 500) jlevel = 4;
    else if(skilllevel >= 500) jlevel = 5;
}
```

**Job help dialog (~line 245, sau case 13 garbage):**
```pawn
case 14: // Bus Driver
{
    ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Tai Xe Bus",
        "Thong tin:\nCong viec nay ban se lai xe bus cho khach quanh thanh pho San Fierro.\nBan se duoc tra tien sau moi vong tuyen duong.\n\nLenh:\n/busrun - Bat dau chuyen\n/huybus - Huy chuyen\n\nLuu y: Ngoi tren xe bus va su dung lenh.",
        "Ok", "");
}
```

---

### 6. MODIFY: `gamemodes/NGRP.pwn`

**Line ~383 (sau `#include "./includes/jobs/ngudan.pwn"`):**
```pawn
#include "./includes/jobs/bussystem.pwn"    // ADD: Bus Driver Job
```

---

### 7. MODIFY: `gamemodes/includes/vehsystem/vehiclecore.pwn`

**IsAnBus function (line 200) - khong can sua, da co model 431 va 437.**

**OnPlayerStateChange (callbacks.pwn ~line 4896) - them check job 26 de cho phep lai bus:**
```pawn
else if(IsAnTaxi(vehicleid) || IsAnBus(vehicleid))
{
    if(PlayerInfo[playerid][pJob] == 17 || ... || PlayerInfo[playerid][pJob] == 26 || PlayerInfo[playerid][pJob2] == 26 || PlayerInfo[playerid][pJob3] == 26)
    { }
    else { ... remove ... }
}
```

---

### 8. MODIFY: `gamemodes/includes/callbacks.pwn`

**OnPlayerDisconnect (~line 1558, reset bus vars):**
```pawn
BusCallTime[playerid]=0;
Bus_ResetJob(playerid);    // ADD
```

---

### 9. MODIFY: `gamemodes/includes/variables.pwn`

**Line ~633 (sau BusAccepted):**
```pawn
new BusDrivers = 0;
new BusCallTime[MAX_PLAYERS];
new BusAccepted[MAX_PLAYERS];
// Bus job variables moved to bussystem.pwn
```

---

### 10. MySQL Migration

Them cot `BusSkill` vao bang `accounts`:
```sql
ALTER TABLE `accounts` ADD COLUMN `BusSkill` INT DEFAULT 0;
```

---

## Implementation Order

1. `enums.pwn` - them `pBusSkill`
2. `defines.pwn` - them timer type
3. `mysql.pwn` - load/save BusSkill
4. `jobcore.pwn` - GetJobLevel + help dialog
5. `bussystem.pwn` - tao file moi
6. `NGRP.pwn` - include file moi
7. `callbacks.pwn` - reset on disconnect + cho phep lai bus
8. MySQL migration - ALTER TABLE

---

## Economy Balance

| Item | Amount |
|------|--------|
| Base pay per loop (21 tram) | $3,000 |
| Safe driver bonus (HP >= 800) | $1,500 |
| Random tip per stop (8% chance) | $20-80 |
| Skill bonus (Level 5) | $1,200 |
| **Max per loop (lucky)** | ~$5,700 + tips |
| **Min per loop** | $3,000 |
| Thoi gian 1 vong (uoc tinh) | ~8-12 phut |
| **Effective rate** | ~$25k-42k/gio |

So voi garbage ($10k-20k per run, ~5 phut) thi bus it loi nhuan hon 1 chut nhung de hon va stress-free.

---

## Anti-Exploit (Tier 1 - Minimal)

- **Leave vehicle timeout:** 30s → huy chuyen, mat tien
- **Speed limit:** Khong can implement server-side (SA-MP khong co native speed limit). Thay vao do: checkpoint 5s freeze la counter du cho speed.
- **Checkpoint spam:** Khong the vi checkpoint advance chi xay ra sau freeze timer
- **Disconnect:** Bus_ResetJob() on disconnect - mat tien, phai bat dau lai
- **Macro:** Khong can anti-macro vi gameplay la driving, khong the macro duoc

---

## Questions / Decisions

1. **Job ID 26** - Co conflict voi job nao khong? (Da kiem tra, 26 la unused)
2. **Bus spawn vehicles** - Dung `AddStaticVehicleEx` nhu garbage system, respawn 300s
3. **Multi-route** - Hien tai chi co 1 route. Co the mo rong them route sau nay bang cach them `BusRoute` array va cho player chon route
4. **Passenger system hien co** - Bus faction system (TransportDuty==2) giu nguyen, khong anh huong. Job bus nay la standalone.
