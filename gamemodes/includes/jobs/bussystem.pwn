#include <YSI\y_hooks>

#define BUS_MAX_STOPS           21
#define BUS_FREEZE_TIME         5
#define BUS_LEAVE_TIMEOUT       30
#define BUS_BASE_PAY            3000
#define BUS_SAFE_BONUS          1500
#define BUS_HEALTH_THRESHOLD    800.0
#define BUS_TIP_CHANCE          8
#define BUS_TIP_MIN             20
#define BUS_TIP_MAX             80

#define BUS_VEHICLE_MODEL       431

new BusVehicles[8];
new Text3D:BusStopLabel[BUS_MAX_STOPS];

new bool:BusOnRoute[MAX_PLAYERS];
new BusStopIndex[MAX_PLAYERS];
new BusFreezeCount[MAX_PLAYERS];
new BusLeaveCount[MAX_PLAYERS];
new BusLoopCount[MAX_PLAYERS];
new BusTotalTips[MAX_PLAYERS];

new const Float:BusStops[BUS_MAX_STOPS][3] = {
    {-1710.0544, 1332.0048, 7.0468},
    {-2216.4758, 1339.1011, 7.0391},
    {-2612.4548, 1328.7556, 7.0391},
    {-2812.6580, 889.0310, 43.9063},
    {-2409.7886, 804.0561, 35.0313},
    {-2160.8662, 804.5095, 67.7715},
    {-2011.4353, 768.0104, 45.2969},
    {-2010.5522, 580.4526, 35.0156},
    {-2289.9426, 572.7697, 35.0156},
    {-2629.2959, 572.7416, 14.4609},
    {-2702.3477, 426.7726, 4.1797},
    {-2602.3909, 401.2941, 11.6663},
    {-2452.8137, 558.8687, 22.1036},
    {-2283.2654, 559.2503, 35.0156},
    {-2010.4056, 277.8952, 33.1947},
    {-1824.9193, -121.0745, 5.4975},
    {-1806.0878, 197.8516, 14.9609},
    {-1560.5638, 491.2933, 7.0313},
    {-1521.4893, 916.9844, 7.0391},
    {-1579.4520, 1173.3695, 7.0468},
    {-1632.0118, 1254.3646, 7.0468}
};

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

new const BusNPCChats[][] = {
    "Hanh khach [NPC]: Bac tai cho xin ban nhac remix di, buon ngu qua!",
    "Hanh khach [NPC]: Chay tu tu thoi ma oi, vang mat cai rang gia cua toi roi!",
    "Hanh khach [NPC]: Cho chau xuong o nga tu nay luon chu oi! (Mac du khong co tram)",
    "Hanh khach [NPC]: Xe bus gi ma hoi mui ranh nuoc vay troi...",
    "Hanh khach [NPC]: Bac tai nhac to len xiu duoc khong? Toi dang nghe goi dien cho vo!",
    "Hanh khach [NPC]: Troi mai cai thanh pho Los Santos nay dao nay cuop boc nhieu qua...",
    "Hanh khach [NPC]: Eh eh nha tui o khoang nay, cho xuong di mai oi! (Khong co ben)",
    "Hanh khach [NPC]: Bac tai di cham cham thoi, tui say xe qua... uon uon!",
    "Hanh khach [NPC]: Hom nay troi dep qua ha, di xe buyt la tuyet nhat!",
    "Hanh khach [NPC]: Oi giua trua nang qua, may lanh xe buyt co khong bac tai?",
    "Hanh khach [NPC]: Bac tai co biet tram nay gan cho khong?",
    "Hanh khach [NPC]: Tui nghe noi thanh pho sap co duong moi, co that khong?",
    "Hanh khach [NPC]: Xin chao! Toi la khach hang moi day! Lan dau di xe buyt o day!",
    "Hanh khach [NPC]: Bac tai oi, xe nay chay em ghe! Nhu dang ngu tren giuong vay!",
    "Hanh khach [NPC]: Oi troi oi, cai ghe nay dinh qua! Ai do lam gi day?",
    "Hanh khach [NPC]: Bac tai ơi, xe nay co WiFi khong? Toi can check Facebook!",
    "Hanh khach [NPC]: Tui di xe buyt 3 gio dong ho roi ma chua den noi...",
    "Hanh khach [NPC]: Bac tai co the cho tui xuong cho duong khong? Tui muon di bo!",
    "Hanh khach [NPC]: Oi khong! Tui de tren xe do! Quay lai di bac tai!",
    "Hanh khach [NPC]: Xe bus nay lai nhanh vay? Toi tho qua!",
    "Hanh khach [NPC]: Bac tai, bao nhieu tien mot ve? Toi khong co tien le...",
    "Hanh khach [NPC]: Tui nghe noi xe buyt nay bi nga bo roi, co that khong?",
    "Hanh khach [NPC]: Oi, cai cua so nay mo duoc khong? Nong qua!",
    "Hanh khach [NPC]: Bac tai, cho tui nghe dien thoai cua ban duoc khong? Pin tui het roi!",
    "Hanh khach [NPC]: Xe bus gi ma khong co may lanh, hoi nhu lo nuong!",
    "Hanh khach [NPC]: Tui thay co nguoi dang chay theo xe bus! La gom gi day?",
    "Hanh khach [NPC]: Bac tai, tui de cai tui xach o ben truoc, co ai lay khong?",
    "Hanh khach [NPC]: Oi, cai duong nay xau qua! Xe nay nhay len nhay xuong nhu ngua!",
    "Hanh khach [NPC]: Tui di xe buyt vi khong co tien mua xang. That buon!",
    "Hanh khach [NPC]: Bac tai, co phai ban dang lai xe bang mot tay khong?",
    "Hanh khach [NPC]: Xe bus nay chay cham hon ba tui di bo!",
    "Hanh khach [NPC]: Tui nghi tui len sai xe... Cai nay di dau vay?",
    "Hanh khach [NPC]: Bac tai, ban co biet lai xe khong? Xe nhay lung tung qua!",
    "Hanh khach [NPC]: Oi, ai do hat karaoke o phia sau xe! Hay qua!",
    "Hanh khach [NPC]: Tui di xe buyt vi vo tui lay xe hoi roi. Cuoc doi!",
    "Hanh khach [NPC]: Bac tai, ban co the di nhanh hon duoc khong? Tui tre lam viec roi!",
    "Hanh khach [NPC]: Xe nay hoi mui gi vay? Ai mang ca kho len xe day?",
    "Hanh khach [NPC]: Tui thay co canh sat dang ngoi o phia truoc! Co gi khong vay?",
    "Hanh khach [NPC]: Bac tai, cai dong ho cua ban bi lech roi! 7 gio ma kim chi 3 gio!",
    "Hanh khach [NPC]: Xe bus nay khong co day an toan! Toi nguy hiem qua!",
    "Hanh khach [NPC]: Tui nghi tui bi say xe... Co ai co bao nilon khong?",
    "Hanh khach [NPC]: Bac tai, ban co the dung lai cho tui mua com trua duoc khong?",
    "Hanh khach [NPC]: Oi, cai may bay dang bay tren dau! Chiem kenh qua!",
    "Hanh khach [NPC]: Tui di xe buyt de ngam canh. That la romantic!",
    "Hanh khach [NPC]: Bac tai, ban co biet bai hat 'Chiec xe buyt' khong?",
    "Hanh khach [NPC]: Xe nay lai qua lai! Toi dang doc bao ma khong tap trung duoc!",
    "Hanh khach [NPC]: Tui nghi cai dong co xe sap chay roi! Nghe la lam!",
    "Hanh khach [NPC]: Bac tai, ban co the lai xe bang hai tay duoc khong?",
    "Hanh khach [NPC]: Oi, cai banh xe nghe nhu dang keu... co gi sai khong?",
    "Hanh khach [NPC]: Tui de con meo o nha, no se buon lam neu tui ve tre!",
    "Hanh khach [NPC]: Bac tai, ban co the tat cai dieu hoa duoc khong? Lanh qua!",
    "Hanh khach [NPC]: Xe bus nay co phai la xe dua khong? Chay nhanh vay!",
    "Hanh khach [NPC]: Tui nghi tui len sai tuyen... Nha tui o phia ben kia thanh pho!",
    "Hanh khach [NPC]: Bac tai, ban co the mo cua so duoc khong? Tui muon tho khi troi!",
    "Hanh khach [NPC]: Oi, cai am thanh nghe nhu xe sap vo tung noi vay!",
    "Hanh khach [NPC]: Tui di xe buyt vi toi tui bi mat. Cam on bac tai!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui di vong them 1 tram duoc khong?",
    "Hanh khach [NPC]: Xe nay hoi mui thuoc la! Ai do hut thuoc trong xe day?",
    "Hanh khach [NPC]: Tui nghi cai he thong phanh cua xe khong on... Co ai biet khong?",
    "Hanh khach [NPC]: Bac tai, ban co the dung lai cho tui chup anh duoc khong?",
    "Hanh khach [NPC]: Oi, cai duong nay dep qua! Nhu dang di du lich vay!",
    "Hanh khach [NPC]: Tui di xe buyt vi tui muon gap ban. That la tinh co!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui muon cai mu duoc khong? Nang qua!",
    "Hanh khach [NPC]: Xe bus nay co phai la xe cua khong gian khong? Moi qua!",
    "Hanh khach [NPC]: Tui nghi cai lop xe bi non... Xe nhay len nhay xuong!",
    "Hanh khach [NPC]: Bac tai, ban co the tat cai nhac duoc khong? Tui dang can ngu!",
    "Hanh khach [NPC]: Oi, cai den truoc xe bi loi roi! Khong thay gi ca!",
    "Hanh khach [NPC]: Tui di xe buyt vi tui muon song cham. Cuoc doi qua bon bon!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui ngua ghe duoc khong? Lung tui dau!",
    "Hanh khach [NPC]: Xe nay lai qua lai! Toi dang danh son mong tay ma bi lem!",
    "Hanh khach [NPC]: Tui nghi cai thanh xe bi lung... Nghe keu coi coi vay!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui xuong day di bo duoc khong? Met qua!",
    "Hanh khach [NPC]: Oi, cai ngoi nay nong qua! Ai do vua ngoi len day!",
    "Hanh khach [NPC]: Tui di xe buyt vi tui muon nghe nhac. Nhung khong co nhac!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui muon cai dien thoai duoc khong?",
    "Hanh khach [NPC]: Xe bus nay co phai la xe cua sieu nhan khong? Nhanh qua!",
    "Hanh khach [NPC]: Tui nghi cai he thong dieu hoa bi hong... Nong qua!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui di them 1 vong nua duoc khong?",
    "Hanh khach [NPC]: Oi, cai banh xe nghe nhu dang keu... co gi sai khong?",
    "Hanh khach [NPC]: Tui de con cho o nha, no se buon lam neu tui ve tre!",
    "Hanh khach [NPC]: Bac tai, ban co the tat cai dieu hoa duoc khong? Lanh qua!",
    "Hanh khach [NPC]: Xe bus nay co phai la xe dua khong? Chay nhanh vay!",
    "Hanh khach [NPC]: Tui nghi tui len sai tuyen... Nha tui o phia ben kia thanh pho!",
    "Hanh khach [NPC]: Bac tai, ban co the mo cua so duoc khong? Tui muon tho khi troi!",
    "Hanh khach [NPC]: Oi, cai am thanh nghe nhu xe sap vo tung noi vay!",
    "Hanh khach [NPC]: Tui di xe buyt vi toi tui bi mat. Cam on bac tai!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui di vong them 1 tram duoc khong?",
    "Hanh khach [NPC]: Xe nay hoi mui thuoc la! Ai do hut thuoc trong xe day?",
    "Hanh khach [NPC]: Tui nghi cai he thong phanh cua xe khong on... Co ai biet khong?",
    "Hanh khach [NPC]: Bac tai, ban co the dung lai cho tui chup anh duoc khong?",
    "Hanh khach [NPC]: Oi, cai duong nay dep qua! Nhu dang di du lich vay!",
    "Hanh khach [NPC]: Tui di xe buyt vi tui muon gap ban. That la tinh co!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui muon cai mu duoc khong? Nang qua!",
    "Hanh khach [NPC]: Xe bus nay co phai la xe cua khong gian khong? Moi qua!",
    "Hanh khach [NPC]: Tui nghi cai lop xe bi non... Xe nhay len nhay xuong!",
    "Hanh khach [NPC]: Bac tai, ban co the tat cai nhac duoc khong? Tui dang can ngu!",
    "Hanh khach [NPC]: Oi, cai den truoc xe bi loi roi! Khong thay gi ca!",
    "Hanh khach [NPC]: Tui di xe buyt vi tui muon song cham. Cuoc doi qua bon bon!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui ngua ghe duoc khong? Lung tui dau!",
    "Hanh khach [NPC]: Xe nay lai qua lai! Toi dang danh son mong tay ma bi lem!",
    "Hanh khach [NPC]: Tui nghi cai thanh xe bi lung... Nghe keu coi coi vay!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui xuong day di bo duoc khong? Met qua!",
    "Hanh khach [NPC]: Oi, cai ngoi nay nong qua! Ai do vua ngoi len day!",
    "Hanh khach [NPC]: Tui di xe buyt vi tui muon nghe nhac. Nhung khong co nhac!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui muon cai dien thoai duoc khong?",
    "Hanh khach [NPC]: Xe bus nay co phai la xe cua sieu nhan khong? Nhanh qua!",
    "Hanh khach [NPC]: Tui nghi cai he thong dieu hoa bi hong... Nong qua!",
    "Hanh khach [NPC]: Bac tai, ban co the cho tui di them 1 vong nua duoc khong?"
};

hook OnGameModeInit()
{
    for(new i = 0; i < 8; i++) {
        BusVehicles[i] = AddStaticVehicleEx(BUS_VEHICLE_MODEL,
            BusSpawnPos[i][0], BusSpawnPos[i][1], BusSpawnPos[i][2], BusSpawnPos[i][3],
            -1, -1, 300);
    }

    for(new i = 0; i < BUS_MAX_STOPS; i++) {
        new labelMsg[128];
        format(labelMsg, sizeof(labelMsg), "{FFFF00}Ben Xe Buyt {FFFFFF}Tram %d", i + 1);
        BusStopLabel[i] = CreateDynamic3DTextLabel(labelMsg, COLOR_YELLOW,
            BusStops[i][0], BusStops[i][1], BusStops[i][2] + 1.5,
            20.0, .testlos = 1, .streamdistance = 20.0);
    }

    CreateDynamic3DTextLabel("{FFFF00}Ben Xe Buyt\n{FFFFFF}Su dung {FFFF00}/busrun {FFFFFF}de bat dau tuyen duong", COLOR_YELLOW,
        -1710.0544, 1332.0048, 7.0468 + 1.5,
        30.0, .testlos = 1, .streamdistance = 30.0);

    return 1;
}

hook OnPlayerConnect(playerid)
{
    BusOnRoute[playerid] = false;
    BusStopIndex[playerid] = 0;
    BusFreezeCount[playerid] = 0;
    BusLeaveCount[playerid] = 0;
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
    if(BusStopIndex[playerid] >= BUS_MAX_STOPS) return 1;

    TogglePlayerControllable(playerid, false);
    GameTextForPlayer(playerid, "~w~Khach dang len xe...~n~~y~5", 1000, 4);
    BusFreezeCount[playerid] = BUS_FREEZE_TIME;

    if(random(100) < 30) {
        new chatIdx = random(sizeof(BusNPCChats));
        new chatMsg[128];
        format(chatMsg, sizeof(chatMsg), "{808080}[Hanh khach] %s", BusNPCChats[chatIdx]);
        SendClientMessageEx(playerid, COLOR_GREY, chatMsg);
    }

    if(random(100) < BUS_TIP_CHANCE) {
        new tipAmount = BUS_TIP_MIN + random(BUS_TIP_MAX - BUS_TIP_MIN);
        new tipMsg[128];
        format(tipMsg, sizeof(tipMsg), "* Mot hanh khach lam rot cai vi / dong ho tri gia $%d tren ghe!", tipAmount);
        SendClientMessageEx(playerid, COLOR_GREEN, tipMsg);
        GivePlayerCash(playerid, tipAmount);
        BusTotalTips[playerid] += tipAmount;
    }

    SetTimerEx("Bus_FreezeCountdown", 1000, false, "i", playerid);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_DRIVER && BusOnRoute[playerid]) {
        if(!IsPlayerInAnyVehicle(playerid) || !IsAnBus(GetPlayerVehicleID(playerid))) {
            Bus_StartLeaveTimer(playerid);
        }
    }

    if(newstate == PLAYER_STATE_DRIVER && BusOnRoute[playerid]) {
        if(IsAnBus(GetPlayerVehicleID(playerid))) {
            if(BusLeaveCount[playerid] > 0) {
                BusLeaveCount[playerid] = 0;
                SendClientMessageEx(playerid, COLOR_GREEN, "Ban da tro lai xe bus! Tiep tuc tuyen duong.");
            }
        }
    }
    return 1;
}

forward Bus_FreezeCountdown(playerid);
public Bus_FreezeCountdown(playerid)
{
    if(!BusOnRoute[playerid]) return;
    if(BusFreezeCount[playerid] <= 0) {
        TogglePlayerControllable(playerid, true);
        BusStopIndex[playerid]++;

        if(BusStopIndex[playerid] >= BUS_MAX_STOPS) {
            Bus_CompleteLoop(playerid);
        } else {
            Bus_SetNextCheckpoint(playerid);
            new msg[64];
            format(msg, sizeof(msg), "~g~Di den tram %d/%d", BusStopIndex[playerid] + 1, BUS_MAX_STOPS);
            GameTextForPlayer(playerid, msg, 2000, 4);
        }
        return;
    }

    new countdownMsg[64];
    format(countdownMsg, sizeof(countdownMsg), "~w~Khach dang len xe...~n~~y~%d", BusFreezeCount[playerid]);
    GameTextForPlayer(playerid, countdownMsg, 1000, 4);
    BusFreezeCount[playerid]--;
    SetTimerEx("Bus_FreezeCountdown", 1000, false, "i", playerid);
}

forward Bus_LeaveCheck(playerid);
public Bus_LeaveCheck(playerid)
{
    if(!BusOnRoute[playerid]) return;
    if(BusLeaveCount[playerid] <= 0) {
        Bus_FailJob(playerid);
        return;
    }

    if(!IsPlayerInAnyVehicle(playerid) || !IsAnBus(GetPlayerVehicleID(playerid))) {
        new msg[64];
        format(msg, sizeof(msg), "~r~Hay tro lai xe bus! Con %d giay", BusLeaveCount[playerid]);
        GameTextForPlayer(playerid, msg, 1500, 4);
        BusLeaveCount[playerid]--;
        SetTimerEx("Bus_LeaveCheck", 1000, false, "i", playerid);
    }
}

CMD:busrun(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != 26 && PlayerInfo[playerid][pJob2] != 26 && PlayerInfo[playerid][pJob3] != 26) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la tai xe bus!");
    }

    if(BusOnRoute[playerid]) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang chay tuyen roi!");
    }

    if(!IsPlayerInAnyVehicle(playerid) || !IsAnBus(GetPlayerVehicleID(playerid))) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban can ngoi tren xe bus de bat dau!");
    }

    if(CheckPointCheck(playerid)) callcmd::killcheckpoint(playerid, params);

    BusOnRoute[playerid] = true;
    BusStopIndex[playerid] = 0;
    BusLoopCount[playerid] = 0;
    BusTotalTips[playerid] = 0;

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

    new payment = BUS_BASE_PAY;
    new Float:health;
    GetVehicleHealth(GetPlayerVehicleID(playerid), health);

    new bonusMsg[128];
    if(health >= BUS_HEALTH_THRESHOLD) {
        payment += BUS_SAFE_BONUS;
        format(bonusMsg, sizeof(bonusMsg), "+ Thuong lai xe an toan: $%s (HP: %.0f)", number_format(BUS_SAFE_BONUS), health);
    } else {
        format(bonusMsg, sizeof(bonusMsg), "Khong du dieu kien thuong an toan (HP: %.0f < %.0f)", health, BUS_HEALTH_THRESHOLD);
    }

    new skillBonus = 0;
    new level = GetJobLevel(playerid, 26);
    if(level >= 2) skillBonus = 200;
    if(level >= 3) skillBonus = 500;
    if(level >= 4) skillBonus = 800;
    if(level >= 5) skillBonus = 1200;
    payment += skillBonus;

    GivePlayerCash(playerid, payment);

    if(PlayerInfo[playerid][pDoubleEXP] > 0) {
        PlayerInfo[playerid][pBusSkill] += 2;
        SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da dat 2 diem ki nang bus (Double EXP).");
    } else {
        PlayerInfo[playerid][pBusSkill] += 1;
    }

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
    BusLeaveCount[playerid] = BUS_LEAVE_TIMEOUT;
    SendClientMessageEx(playerid, COLOR_RED, "Ban da roi khoi xe bus! Hay tro lai trong 30 giay hoac chuyen se bi huy.");
    SetTimerEx("Bus_LeaveCheck", 1000, false, "i", playerid);
}

stock Bus_ResetJob(playerid)
{
    BusOnRoute[playerid] = false;
    BusStopIndex[playerid] = 0;
    BusFreezeCount[playerid] = 0;
    BusLeaveCount[playerid] = 0;
    BusLoopCount[playerid] = 0;
    BusTotalTips[playerid] = 0;
}

stock Bus_IsPlayerOnRoute(playerid)
{
    return BusOnRoute[playerid];
}
