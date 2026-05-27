/*
 * ============================================================
 *   robbery.inc – He thong cuop ATM va cua hang 24/7
 * ============================================================
 *
 *  Flow:
 *    1. Player dung sat ATM/Biz va dung lenh /robatm hoac /robbiz
 *    2. Can co >= 2 cops online, co Picklock trong tui, va chua trong cooldown.
 *    3. Pha khoa 10 giay (frozen), sau do bat dau 1 phut gom tien.
 *    4. Sau 10 giay: bao dong phat qua radio den toan bo LEA (khu vuc).
 *    5. Sau 1 phut: tra thuong Dirty Money ngau nhien, bao dong tao thoat, dang log.
 *    6. Cooldown ca nhan 15 phut, cooldown tung ATM/Biz 30 phut.
 *
 *  Rewards (Dirty Money):
 *    ATM : $35,000 – $70,000
 *    Biz : $60,000 – $110,000
 *
 * ============================================================
 */


/* ── Constants ────────────────────────────────────────────── */
#define ROB_CRACK_TIME          10          // giay pha khoa
#define ROB_COLLECT_TIME        60          // 1 phut gom tien (giay)
#define ROB_RANGE_CHECK_TIME    5           // giay kiem tra khoang cach
#define ROB_KEEP_RANGE          8.0         // khoang cach toi da khi gom tien
#define ROB_PLAYER_COOLDOWN     900         // 15 phut cooldown ca nhan
#define ROB_TARGET_COOLDOWN     1800        // 30 phut cooldown muc tieu
#define ROB_MIN_COPS            2           // so cop toi thieu online

#define ROB_ATM_MIN             35000       // thuong ATM min
#define ROB_ATM_MAX             70000       // thuong ATM max
#define ROB_BIZ_MIN             60000       // thuong Biz min
#define ROB_BIZ_MAX             110000      // thuong Biz max

#define ROB_MAX_WANTED          6           // cap wanted toi da game

// Loai muc tieu
#define ROB_TYPE_ATM            1
#define ROB_TYPE_BIZ            2

// Trang thai
#define ROB_STATE_NONE          0
#define ROB_STATE_CRACKING      1
#define ROB_STATE_COLLECTING    2

// Item dung de pha khoa (Picklock – item ID 53 trong inventory system)
#define ITEM_PICKLOCK           53

/* ── Per-player state ─────────────────────────────────────── */
enum eRobState {
    rob_iState,         // ROB_STATE_*
    rob_iType,          // ROB_TYPE_ATM / ROB_TYPE_BIZ
    rob_iTargetID,      // ATMPoint index hoac Businesses[] index
    rob_iTimer,         // timer ID cho crack/collect
    rob_iRangeTimer,    // timer kiem tra player con dung gan target khong
    rob_iPlayerCD,      // timestamp het cooldown ca nhan
    rob_iInt,           // interior luc bat dau cuop
    rob_iVW,            // virtual world luc bat dau cuop
}
new arrRobState[MAX_PLAYERS][eRobState];

/* ── Per-target cooldown ──────────────────────────────────── */
new g_iATMCooldown[43];     // unix timestamp het CD
new g_iBizCooldown[MAX_BUSINESSES];
new g_iATMRobber[43];       // player dang cuop target, INVALID_PLAYER_ID neu trong
new g_iBizRobber[MAX_BUSINESSES];
new Text3D:g_iATMLabel[43]; // 3D text tren ATM khi dang cooldown

/* ── Forwards ─────────────────────────────────────────────── */
forward Rob_OnCrackDone(playerid);
forward Rob_OnCollectDone(playerid);
forward Rob_OnRangeCheck(playerid);

new bool:g_bRobberyInit;

static Rob_Init()
{
    if (g_bRobberyInit) return 1;

    for (new i = 0; i < sizeof(ATMPoint); i++) {
        g_iATMRobber[i] = INVALID_PLAYER_ID;
        g_iATMLabel[i] = Text3D:INVALID_3DTEXT_ID;
    }
    for (new i = 0; i < MAX_BUSINESSES; i++) g_iBizRobber[i] = INVALID_PLAYER_ID;
    g_bRobberyInit = true;
    return 1;
}

/* ── Helper: dem so cop online ────────────────────────────── */
stock Rob_CountCops() {
    new iCount;
    foreach (new i : Player) {
        if (gPlayerLogged{i} && IsACop(i)) iCount++;
    }
    return iCount;
}

/* ── Helper: tim slot chua item trong tui ─────────────────── */
stock Rob_FindItemSlot(playerid, itemid) {
    for (new i = 0; i < MAX_PLAYER_CB_ITEM; i++) {
        if (CharacterInfo[playerid][0][cb_ItemID][i] == itemid &&
            CharacterInfo[playerid][0][cb_ItemAmount][i] >= 1)
            return i;
    }
    return -1;
}

stock Rob_HasToolForATM(playerid) {
    if (Rob_FindItemSlot(playerid, ITEM_PICKLOCK) >= 0) return ITEM_PICKLOCK;
    return 0;
}

stock Rob_RemoveTool(playerid, itemid) {
    new iSlot = Rob_FindItemSlot(playerid, itemid);
    if (iSlot >= 0) {
        CharacterInfo[playerid][0][cb_ItemAmount][iSlot]--;
        if (CharacterInfo[playerid][0][cb_ItemAmount][iSlot] <= 0)
            RemovePlayerItem(playerid, iSlot);
    }
}

/* ── Helper: lay vi tri ATM ──────────────────────────────── */
stock Rob_GetATMPos(atmid, &Float:x, &Float:y, &Float:z) {
    Streamer_GetFloatData(STREAMER_TYPE_AREA, ATMPoint[atmid], E_STREAMER_X, x);
    Streamer_GetFloatData(STREAMER_TYPE_AREA, ATMPoint[atmid], E_STREAMER_Y, y);
    Streamer_GetFloatData(STREAMER_TYPE_AREA, ATMPoint[atmid], E_STREAMER_Z, z);
}

stock Rob_IsValidATM(atmid) {
    return (0 <= atmid < sizeof(ATMPoint) && IsValidDynamicArea(STREAMER_TAG_AREA:ATMPoint[atmid]));
}

/* ── Helper: tim ATM gan nhat ─────────────────────────────── */
stock Rob_FindNearestATM(playerid) {
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    new best = -1;
    new Float:bestDist = 999999.0;
    for (new i = 0; i < sizeof(ATMPoint); i++) {
        if (!Rob_IsValidATM(i)) continue;
        new Float:ax, Float:ay, Float:az;
        Rob_GetATMPos(i, ax, ay, az);
        new Float:d = floatsqroot((px-ax)*(px-ax)+(py-ay)*(py-ay)+(pz-az)*(pz-az));
        if (d < bestDist) { bestDist = d; best = i; }
    }
    if (bestDist <= 5.0) return best;
    return -1;
}

/* ── Helper: tim Biz 24/7 gan nhat ───────────────────────── */
stock Rob_FindNearestBiz247(playerid) {
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    new best = -1;
    new Float:bestDist = 999999.0;
    for (new i = 0; i < MAX_BUSINESSES; i++) {
        if (Businesses[i][bType] != BUSINESS_TYPE_STORE) continue;
        if (Businesses[i][bExtPos][0] == 0.0 && Businesses[i][bExtPos][1] == 0.0 && Businesses[i][bExtPos][2] == 0.0) continue;
        new Float:d = GetPlayerDistanceFromPoint(playerid,
            Businesses[i][bExtPos][0],
            Businesses[i][bExtPos][1],
            Businesses[i][bExtPos][2]);
        if (d < bestDist) { bestDist = d; best = i; }
    }
    if (bestDist <= 5.0) return best;
    return -1;
}

/* ── Helper: phat bao dong den LEA (khi bat dau cuop) ─────── */
static Rob_Alarm(iType, iTargetID) {
    new szAlert[256], zone[MAX_ZONE_NAME];

    if (iType == ROB_TYPE_ATM) {
        new Float:ax, Float:ay, Float:az;
        Rob_GetATMPos(iTargetID, ax, ay, az);
        Get3DZone(ax, ay, az, zone, sizeof(zone));
        format(szAlert, sizeof(szAlert),
            "{FF0000}** BAO DONG {FFFFFF}: Phat hien nguoi dang cuop ATM tai {FFFF00}%s{FFFFFF}. Dung {FFFF00}/gpsatm{FFFFFF} de danh dau!",
            zone);
    } else {
        Get3DZone(Businesses[iTargetID][bExtPos][0], Businesses[iTargetID][bExtPos][1], Businesses[iTargetID][bExtPos][2], zone, sizeof(zone));
        format(szAlert, sizeof(szAlert),
            "{FF0000}** BAO DONG {FFFFFF}: Phat hien nguoi dang cuop cua hang {FFFF00}\"%s\"{FFFFFF} tai {FFFF00}%s{FFFFFF}. Dung {FFFF00}/gpsbiz{FFFFFF} de danh dau!",
            Businesses[iTargetID][bName], zone);
    }

    SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTRED, szAlert);
}

/* ── Helper: bao dong tao thoat ───────────────────────────── */
static Rob_EscapeNotify(iType, iTargetID) {
    new szAlert[256], zone[MAX_ZONE_NAME];

    if (iType == ROB_TYPE_ATM) {
        new Float:ax, Float:ay, Float:az;
        Rob_GetATMPos(iTargetID, ax, ay, az);
        Get3DZone(ax, ay, az, zone, sizeof(zone));
        format(szAlert, sizeof(szAlert),
            "{FF0000}** BAO DONG {FFFFFF}: Doi tuong cuop ATM tai {FFFF00}%s{FFFFFF} da tao thoat khoi hien truong!",
            zone);
    } else {
        Get3DZone(Businesses[iTargetID][bExtPos][0], Businesses[iTargetID][bExtPos][1], Businesses[iTargetID][bExtPos][2], zone, sizeof(zone));
        format(szAlert, sizeof(szAlert),
            "{FF0000}** BAO DONG {FFFFFF}: Doi tuong cuop cua hang {FFFF00}\"%s\"{FFFFFF} tai {FFFF00}%s{FFFFFF} da tao thoat khoi hien truong!",
            Businesses[iTargetID][bName], zone);
    }

    SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTRED, szAlert);
}

/* ── Helper: hien/hide 3D text tren ATM khi cooldown ──────── */
static Rob_ShowATMCooldownLabel(atmid) {
    if (!Rob_IsValidATM(atmid)) return;
    if (g_iATMLabel[atmid] != Text3D:INVALID_3DTEXT_ID) return;

    new Float:x, Float:y, Float:z;
    Rob_GetATMPos(atmid, x, y, z);
    new iLeft = g_iATMCooldown[atmid] - gettime();
    new str[128];
    format(str, sizeof(str), "{FF0000}ATM bi cuop gan day!\n{FFFF00}Kha dung lai sau: %d phut", (iLeft / 60) + 1);
    g_iATMLabel[atmid] = CreateDynamic3DTextLabel(str, COLOR_RED, x, y, z + 1.5, 15.0, .testlos = 1, .streamdistance = 15.0);
}

static Rob_HideATMCooldownLabel(atmid) {
    if (g_iATMLabel[atmid] != Text3D:INVALID_3DTEXT_ID) {
        DestroyDynamic3DTextLabel(g_iATMLabel[atmid]);
        g_iATMLabel[atmid] = Text3D:INVALID_3DTEXT_ID;
    }
}

/* ── Helper: kiem tra target busy ─────────────────────────── */
static Rob_IsTargetBusy(iType, iTargetID) {
    if (iType == ROB_TYPE_ATM) {
        if (!Rob_IsValidATM(iTargetID)) return 1;
        return (g_iATMRobber[iTargetID] != INVALID_PLAYER_ID);
    }

    if (iTargetID < 0 || iTargetID >= MAX_BUSINESSES || Businesses[iTargetID][bType] != BUSINESS_TYPE_STORE) return 1;
    return (g_iBizRobber[iTargetID] != INVALID_PLAYER_ID);
}

static Rob_SetTargetRobber(iType, iTargetID, playerid) {
    if (iType == ROB_TYPE_ATM && Rob_IsValidATM(iTargetID)) g_iATMRobber[iTargetID] = playerid;
    else if (iType == ROB_TYPE_BIZ && 0 <= iTargetID < MAX_BUSINESSES) g_iBizRobber[iTargetID] = playerid;
}

static Rob_ClearTargetRobber(playerid) {
    new iType = arrRobState[playerid][rob_iType],
        iTargetID = arrRobState[playerid][rob_iTargetID];

    if (iType == ROB_TYPE_ATM && Rob_IsValidATM(iTargetID) && g_iATMRobber[iTargetID] == playerid) {
        g_iATMRobber[iTargetID] = INVALID_PLAYER_ID;
    }
    else if (iType == ROB_TYPE_BIZ && 0 <= iTargetID < MAX_BUSINESSES && g_iBizRobber[iTargetID] == playerid) {
        g_iBizRobber[iTargetID] = INVALID_PLAYER_ID;
    }
}

static Rob_IsPlayerNearTarget(playerid) {
    if (GetPlayerInterior(playerid) != arrRobState[playerid][rob_iInt]) return 0;
    if (GetPlayerVirtualWorld(playerid) != arrRobState[playerid][rob_iVW]) return 0;

    new iTargetID = arrRobState[playerid][rob_iTargetID];
    if (arrRobState[playerid][rob_iType] == ROB_TYPE_ATM) {
        if (!Rob_IsValidATM(iTargetID)) return 0;

        new Float:x, Float:y, Float:z;
        Rob_GetATMPos(iTargetID, x, y, z);
        return IsPlayerInRangeOfPoint(playerid, ROB_KEEP_RANGE, x, y, z);
    }

    if (iTargetID < 0 || iTargetID >= MAX_BUSINESSES || Businesses[iTargetID][bType] != BUSINESS_TYPE_STORE) return 0;
    return IsPlayerInRangeOfPoint(playerid, ROB_KEEP_RANGE,
        Businesses[iTargetID][bExtPos][0],
        Businesses[iTargetID][bExtPos][1],
        Businesses[iTargetID][bExtPos][2]);
}

/* ── Helper: reset state player ──────────────────────────── */
static Rob_ResetState(playerid) {
    if (arrRobState[playerid][rob_iTimer] > 0) {
        KillTimer(arrRobState[playerid][rob_iTimer]);
        arrRobState[playerid][rob_iTimer] = 0;
    }
    if (arrRobState[playerid][rob_iRangeTimer] > 0) {
        KillTimer(arrRobState[playerid][rob_iRangeTimer]);
        arrRobState[playerid][rob_iRangeTimer] = 0;
    }
    Rob_ClearTargetRobber(playerid);
    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);
    arrRobState[playerid][rob_iState]    = ROB_STATE_NONE;
    arrRobState[playerid][rob_iType]     = 0;
    arrRobState[playerid][rob_iTargetID] = -1;
    arrRobState[playerid][rob_iInt]      = 0;
    arrRobState[playerid][rob_iVW]       = 0;
}

/* ── Timer: cap nhat / xoa 3D text ATM cooldown ──────────── */
task Rob_CooldownUpdate[60000]() {
    new now = gettime();
    for (new i = 0; i < sizeof(ATMPoint); i++) {
        if (g_iATMCooldown[i] > 0) {
            if (now >= g_iATMCooldown[i]) {
                g_iATMCooldown[i] = 0;
                Rob_HideATMCooldownLabel(i);
            } else {
                new iLeft = g_iATMCooldown[i] - now;
                if (g_iATMLabel[i] != Text3D:INVALID_3DTEXT_ID) {
                    new str[128];
                    format(str, sizeof(str), "{FF0000}ATM bi cuop gan day!\n{FFFF00}Kha dung lai sau: %d phut", (iLeft / 60) + 1);
                    UpdateDynamic3DTextLabelText(g_iATMLabel[i], COLOR_RED, str);
                }
            }
        }
    }
}

/* ── Callbacks ────────────────────────────────────────────── */
public Rob_OnCrackDone(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    if (arrRobState[playerid][rob_iState] != ROB_STATE_CRACKING) return 1;

    if (!Rob_IsPlayerNearTarget(playerid)) {
        SendClientMessageEx(playerid, COLOR_RED,
            "{FF0000}[CUOP]{FFFFFF}: Ban da roi khoi muc tieu. Hanh dong cuop bi huy.");
        Rob_ResetState(playerid);
        return 1;
    }

    arrRobState[playerid][rob_iTimer] = 0;

    arrRobState[playerid][rob_iState] = ROB_STATE_COLLECTING;

    SendClientMessageEx(playerid, COLOR_GREEN,
        "{FFFF00}[CUOP]{FFFFFF}: Ban da pha khoa thanh cong! {00FF00}Dang gom tien (1 phut){FFFFFF}...");

    Rob_Alarm(arrRobState[playerid][rob_iType],
        arrRobState[playerid][rob_iTargetID]);

    new iTargetID = arrRobState[playerid][rob_iTargetID];
    if (arrRobState[playerid][rob_iType] == ROB_TYPE_ATM) {
        g_iATMCooldown[iTargetID] = gettime() + ROB_TARGET_COOLDOWN;
        Rob_ShowATMCooldownLabel(iTargetID);
    } else {
        g_iBizCooldown[iTargetID] = gettime() + ROB_TARGET_COOLDOWN;
    }

    arrRobState[playerid][rob_iTimer] = SetTimerEx("Rob_OnCollectDone",
        ROB_COLLECT_TIME * 1000, false, "i", playerid);
    arrRobState[playerid][rob_iRangeTimer] = SetTimerEx("Rob_OnRangeCheck",
        ROB_RANGE_CHECK_TIME * 1000, true, "i", playerid);

    return 1;
}

public Rob_OnRangeCheck(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    if (arrRobState[playerid][rob_iState] == ROB_STATE_NONE) return 1;

    if (!Rob_IsPlayerNearTarget(playerid)) {
        SendClientMessageEx(playerid, COLOR_RED,
            "{FF0000}[CUOP]{FFFFFF}: Ban da di qua xa muc tieu. Hanh dong cuop bi huy.");
        Rob_ResetState(playerid);
    }
    return 1;
}

public Rob_OnCollectDone(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    if (arrRobState[playerid][rob_iState] != ROB_STATE_COLLECTING) return 1;

    if (!Rob_IsPlayerNearTarget(playerid)) {
        SendClientMessageEx(playerid, COLOR_RED,
            "{FF0000}[CUOP]{FFFFFF}: Ban da roi khoi muc tieu. Hanh dong cuop bi huy.");
        Rob_ResetState(playerid);
        return 1;
    }

    arrRobState[playerid][rob_iTimer] = 0;
    if (arrRobState[playerid][rob_iRangeTimer] > 0) {
        KillTimer(arrRobState[playerid][rob_iRangeTimer]);
        arrRobState[playerid][rob_iRangeTimer] = 0;
    }

    new iRobType  = arrRobState[playerid][rob_iType];
    new iTargetID = arrRobState[playerid][rob_iTargetID];

    // Tinh toan phan thuong
    new iMin, iMax;
    if (iRobType == ROB_TYPE_ATM) {
        iMin = ROB_ATM_MIN; iMax = ROB_ATM_MAX;
    } else {
        iMin = ROB_BIZ_MIN; iMax = ROB_BIZ_MAX;
    }
    new iReward = iMin + random(iMax - iMin + 1);

    PlayerInfo[playerid][pDirtyMoney] += iReward;

    // Set cooldown ca nhan
    arrRobState[playerid][rob_iPlayerCD] = gettime() + ROB_PLAYER_COOLDOWN;

    // Thong bao cho player
    new szMsg[192];
    format(szMsg, sizeof(szMsg),
        "{FFFF00}[CUOP]{FFFFFF}: Cuop thanh cong! Ban nhan duoc {C4A656}$%s tien ban{FFFFFF}.",
        number_format(iReward));
    SendClientMessageEx(playerid, COLOR_GREEN, szMsg);

    // Bao dong tao thoat den LEA
    Rob_EscapeNotify(iRobType, iTargetID);

    // Log
    new szName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, szName, sizeof(szName));
    new szLog[256];
    if (iRobType == ROB_TYPE_ATM) {
        format(szLog, sizeof(szLog), "[ROBBERY] %s (ID:%d) da cuop ATM[%d] duoc $%d dirty money.",
            szName, playerid, iTargetID, iReward);
    } else {
        format(szLog, sizeof(szLog), "[ROBBERY] %s (ID:%d) da cuop Biz[%d] '%s' duoc $%d dirty money.",
            szName, playerid, iTargetID, Businesses[iTargetID][bName], iReward);
    }
    Log("logs/robbery.log", szLog);

    OnPlayerStatsUpdate(playerid);

    Rob_ResetState(playerid);
    return 1;
}

/* ── Xu ly khi player disconnect / chet ──────────────────── */
hook OnPlayerDisconnect(playerid, reason) {
    Rob_ResetState(playerid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (arrRobState[playerid][rob_iState] != ROB_STATE_NONE) {
        SendClientMessageEx(playerid, COLOR_RED,
            "{FF0000}[CUOP]{FFFFFF}: Ban da chet! Hanh dong cuop bi huy.");
        Rob_ResetState(playerid);
    }
    return 1;
}

/* ── CMD: /robatm ─────────────────────────────────────────── */
CMD:robatm(playerid, params[]) {
    Rob_Init();

    if (arrRobState[playerid][rob_iState] != ROB_STATE_NONE)
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Ban dang trong qua trinh cuop roi.");

    if (IsACop(playerid))
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Canh sat khong the thuc hien cuop.");

    if (Rob_CountCops() < ROB_MIN_COPS)
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Can co it nhat 2 canh sat online.");

    if (gettime() < arrRobState[playerid][rob_iPlayerCD]) {
        new iLeft = arrRobState[playerid][rob_iPlayerCD] - gettime();
        new szMsg[96];
        format(szMsg, sizeof(szMsg), "{FF0000}[CUOP]{FFFFFF}: Cooldown ca nhan con %d phut %d giay.",
            iLeft / 60, iLeft % 60);
        return SendClientMessageEx(playerid, COLOR_RED, szMsg);
    }

    new iATM = Rob_FindNearestATM(playerid);
    if (iATM == -1)
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Ban khong dung gan ATM nao (trong vong 5m).");

    if (Rob_IsTargetBusy(ROB_TYPE_ATM, iATM))
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: ATM nay dang bi nguoi khac cuop.");

    if (gettime() < g_iATMCooldown[iATM]) {
        new iLeft = g_iATMCooldown[iATM] - gettime();
        new szMsg[96];
        format(szMsg, sizeof(szMsg), "{FF0000}[CUOP]{FFFFFF}: ATM nay vua bi cuop. Cho them %d phut %d giay.",
            iLeft / 60, iLeft % 60);
        return SendClientMessageEx(playerid, COLOR_RED, szMsg);
    }

    new iTool = Rob_HasToolForATM(playerid);
    if (!iTool)
        return SendClientMessageEx(playerid, COLOR_RED,
            "{FF0000}[CUOP]{FFFFFF}: Ban can {FFFF00}Picklock (khoa mo){FFFFFF} de pha khoa ATM.");

    Rob_RemoveTool(playerid, iTool);
    arrRobState[playerid][rob_iState]    = ROB_STATE_CRACKING;
    arrRobState[playerid][rob_iType]     = ROB_TYPE_ATM;
    arrRobState[playerid][rob_iTargetID] = iATM;
    arrRobState[playerid][rob_iInt]      = GetPlayerInterior(playerid);
    arrRobState[playerid][rob_iVW]       = GetPlayerVirtualWorld(playerid);
    Rob_SetTargetRobber(ROB_TYPE_ATM, iATM, playerid);

    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 1, 10000, 1);

    SendClientMessageEx(playerid, COLOR_YELLOW,
        "{FFFF00}[CUOP]{FFFFFF}: Dang pha khoa ATM... {FF8800}Dung di chuyen! (10 giay){FFFFFF}");

    arrRobState[playerid][rob_iTimer] = SetTimerEx("Rob_OnCrackDone",
        ROB_CRACK_TIME * 1000, false, "i", playerid);

    return 1;
}

/* ── CMD: /robbiz ──────────────────────────────────────────── */
CMD:robbiz(playerid, params[]) {
    Rob_Init();

    if (arrRobState[playerid][rob_iState] != ROB_STATE_NONE)
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Ban dang trong qua trinh cuop roi.");

    if (IsACop(playerid))
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Canh sat khong the thuc hien cuop.");

    if (Rob_CountCops() < ROB_MIN_COPS)
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Can co it nhat 2 canh sat online.");

    if (gettime() < arrRobState[playerid][rob_iPlayerCD]) {
        new iLeft = arrRobState[playerid][rob_iPlayerCD] - gettime();
        new szMsg[96];
        format(szMsg, sizeof(szMsg), "{FF0000}[CUOP]{FFFFFF}: Cooldown ca nhan con %d phut %d giay.",
            iLeft / 60, iLeft % 60);
        return SendClientMessageEx(playerid, COLOR_RED, szMsg);
    }

    new iBiz = Rob_FindNearestBiz247(playerid);
    if (iBiz == -1)
        return SendClientMessageEx(playerid, COLOR_RED,
            "{FF0000}[CUOP]{FFFFFF}: Ban khong dung gan cua hang 24/7 nao (trong vong 5m).");

    if (Rob_IsTargetBusy(ROB_TYPE_BIZ, iBiz))
        return SendClientMessageEx(playerid, COLOR_RED, "{FF0000}[CUOP]{FFFFFF}: Cua hang nay dang bi nguoi khac cuop.");

    if (gettime() < g_iBizCooldown[iBiz]) {
        new iLeft = g_iBizCooldown[iBiz] - gettime();
        new szMsg[128];
        format(szMsg, sizeof(szMsg), "{FF0000}[CUOP]{FFFFFF}: Cua hang '%s' vua bi cuop. Cho them %d phut %d giay.",
            Businesses[iBiz][bName], iLeft / 60, iLeft % 60);
        return SendClientMessageEx(playerid, COLOR_RED, szMsg);
    }

    new iTool = Rob_HasToolForATM(playerid);
    if (!iTool)
        return SendClientMessageEx(playerid, COLOR_RED,
            "{FF0000}[CUOP]{FFFFFF}: Ban can {FFFF00}Picklock (khoa mo){FFFFFF} de pha khoa cua hang.");

    Rob_RemoveTool(playerid, iTool);
    arrRobState[playerid][rob_iState]    = ROB_STATE_CRACKING;
    arrRobState[playerid][rob_iType]     = ROB_TYPE_BIZ;
    arrRobState[playerid][rob_iTargetID] = iBiz;
    arrRobState[playerid][rob_iInt]      = GetPlayerInterior(playerid);
    arrRobState[playerid][rob_iVW]       = GetPlayerVirtualWorld(playerid);
    Rob_SetTargetRobber(ROB_TYPE_BIZ, iBiz, playerid);

    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 1, 10000, 1);

    new szMsg[128];
    format(szMsg, sizeof(szMsg),
        "{FFFF00}[CUOP]{FFFFFF}: Dang pha khoa {FFFF00}%s{FFFFFF}... {FF8800}Dung di chuyen! (10 giay){FFFFFF}",
        Businesses[iBiz][bName]);
    SendClientMessageEx(playerid, COLOR_YELLOW, szMsg);

    arrRobState[playerid][rob_iTimer] = SetTimerEx("Rob_OnCrackDone",
        ROB_CRACK_TIME * 1000, false, "i", playerid);

    return 1;
}

/* ── CMD: /cancelrob ──────────────────────────────────────── */
CMD:cancelrob(playerid, params[]) {
    if (arrRobState[playerid][rob_iState] == ROB_STATE_NONE)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dang thuc hien cuop gi ca.");

    SendClientMessageEx(playerid, COLOR_YELLOW,
        "{FFFF00}[CUOP]{FFFFFF}: Ban da huy hanh dong cuop.");
    Rob_ResetState(playerid);
    return 1;
}

/* ── CMD: /gpsatm – police tim ATM bi cuop ────────────────── */
CMD:gpsatm(playerid, params[]) {
    Rob_Init();

    if (!IsACop(playerid))
        return SendClientMessageEx(playerid, COLOR_GRAD1, "Chi canh sat moi co the su dung lenh nay.");

    new iFoundPlayer = INVALID_PLAYER_ID;
    foreach (new i : Player) {
        if (arrRobState[i][rob_iState] != ROB_STATE_NONE &&
            arrRobState[i][rob_iType] == ROB_TYPE_ATM) {
            iFoundPlayer = i;
            break;
        }
    }

    if (iFoundPlayer != INVALID_PLAYER_ID) {
        new iATM = arrRobState[iFoundPlayer][rob_iTargetID];
        new Float:ax, Float:ay, Float:az;
        Rob_GetATMPos(iATM, ax, ay, az);
        SetPlayerCheckpoint(playerid, ax, ay, az, 3.0);
        new szMsg[160];
        format(szMsg, sizeof(szMsg),
            "{FFFF00}[GPS]{FFFFFF}: Da danh dau checkpoint vi tri ATM dang bi cuop.");
        return SendClientMessageEx(playerid, COLOR_YELLOW, szMsg);
    }

    return SendClientMessageEx(playerid, COLOR_GREY,
        "Hien tai khong co ATM nao dang bi cuop.");
}

/* ── CMD: /gpsbiz – police tim biz dang bi cuop ───────────── */
CMD:gpsbiz(playerid, params[]) {
    Rob_Init();

    if (!IsACop(playerid))
        return SendClientMessageEx(playerid, COLOR_GRAD1, "Chi canh sat moi co the su dung lenh nay.");

    new iBizID;

    if (sscanf(params, "i", iBizID)) {
        new iFoundPlayer = INVALID_PLAYER_ID;
        foreach (new i : Player) {
            if (arrRobState[i][rob_iState] != ROB_STATE_NONE &&
                arrRobState[i][rob_iType] == ROB_TYPE_BIZ) {
                iFoundPlayer = i;
                break;
            }
        }
        if (iFoundPlayer == INVALID_PLAYER_ID)
            return SendClientMessageEx(playerid, COLOR_GREY,
                "Hien tai khong co biz nao dang bi cuop. Cu phap: /gpsbiz [bizid]");
        iBizID = arrRobState[iFoundPlayer][rob_iTargetID];
    }

    if (iBizID < 0 || iBizID >= MAX_BUSINESSES || Businesses[iBizID][bType] == 0)
        return SendClientMessageEx(playerid, COLOR_RED, "Biz ID khong hop le.");

    new Float:bx = Businesses[iBizID][bExtPos][0],
        Float:by = Businesses[iBizID][bExtPos][1],
        Float:bz = Businesses[iBizID][bExtPos][2];

    SetPlayerCheckpoint(playerid, bx, by, bz, 3.0);

    new szMsg[192];
    format(szMsg, sizeof(szMsg),
        "{FFFF00}[GPS]{FFFFFF}: Da danh dau checkpoint cua hang \"%s\".",
        Businesses[iBizID][bName]);
    return SendClientMessageEx(playerid, COLOR_YELLOW, szMsg);
}
