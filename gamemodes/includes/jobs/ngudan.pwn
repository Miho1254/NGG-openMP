#include <YSI\y_hooks>

// =============================================================================
// CONSTANTS
// =============================================================================
#define FISH_ITEM_THU           37      // Cá thu (Tuna)
#define FISH_ITEM_NGU           38      // Cá ngu (Mackerel)
#define FISH_ITEM_NOC           39      // Cá noc (Pufferfish)
#define FISH_COUNTDOWN_TIME     60      // 60 giây chờ lưới
#define FISH_NPC_SKIN           50      // Skin NPC thu mua
#define FISH_NPC_X              -1734.1169
#define FISH_NPC_Y              1461.6493
#define FISH_NPC_Z              7.1875
#define FISH_NPC_A              267.3743
#define FISH_BASE_X             -1709.1864
#define FISH_BASE_Y             1430.0531
#define FISH_BASE_Z             -2.0515

// Giá/kg cho từng loại cá
#define FISH_PRICE_THU          1500    // $/kg - Cá thu
#define FISH_PRICE_NGU          2500    // $/kg - Cá ngu
#define FISH_PRICE_NOC          5000    // $/kg - Cá noc

// Ngưỡng "cá khủng" để broadcast server
#define FISH_BIG_THU            8       // kg
#define FISH_BIG_NGU            5       // kg
#define FISH_BIG_NOC            3       // kg

#define DIALOG_NGUDAN_SELL      8038

// =============================================================================
// VÙNG ĐÁNH CÁ (4 bãi cá trên biển SF)
// =============================================================================
new Float:FishingZones[4][3] = {
    {-2256.0278, 1957.6537, -0.7859},
    {-2442.3542, 1697.4408, -0.7506},
    {-1090.9705, 601.9323, -0.5750},
    {-1060.4594, 126.4771, -0.6570}
};

// =============================================================================
// STATE
// =============================================================================
new BaoTriNguDan = 0;
new Actor:FishingNPC;
new Text3D:FishingNPCLabel;
new PlayerText:FishingCountdownTD[MAX_PLAYERS];
new FishingCountdownTimer[MAX_PLAYERS];
new FishingCountdownLeft[MAX_PLAYERS];

// =============================================================================
// INITIALIZATION
// =============================================================================
hook OnGameModeInit()
{
    FishingNPC = CreateActor(FISH_NPC_SKIN, FISH_NPC_X, FISH_NPC_Y, FISH_NPC_Z, FISH_NPC_A);
    FishingNPCLabel = CreateDynamic3DTextLabel("{FF6347}Shark Hung - Thu mua ca\n{FFFFFF}/banca_ngudan", COLOR_YELLOW, FISH_NPC_X, FISH_NPC_Y, FISH_NPC_Z + 1.0, 10.0);
    printf("[NguDan] Loaded: 4 fishing zones, 1 NPC buyer.");
    return 1;
}

hook OnPlayerConnect(playerid)
{
    FishingCountdownTD[playerid] = CreatePlayerTextDraw(playerid, 320.0, 380.0, "~g~Tha luoi: ~w~60 giay");
    PlayerTextDrawLetterSize(playerid, FishingCountdownTD[playerid], 0.3, 1.5);
    PlayerTextDrawAlignment(playerid, FishingCountdownTD[playerid], 2);
    PlayerTextDrawColor(playerid, FishingCountdownTD[playerid], -1);
    PlayerTextDrawSetShadow(playerid, FishingCountdownTD[playerid], 1);
    PlayerTextDrawSetOutline(playerid, FishingCountdownTD[playerid], 0);
    PlayerTextDrawFont(playerid, FishingCountdownTD[playerid], 1);
    PlayerTextDrawSetProportional(playerid, FishingCountdownTD[playerid], 1);
    FishingCountdownLeft[playerid] = 0;
    FishingCountdownTimer[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    NguDan_ResetState(playerid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    NguDan_ResetState(playerid);
    return 1;
}

// =============================================================================
// HELPER
// =============================================================================
stock IsThuyenNguDan(carid)
{
    for(new v = 0; v < sizeof(NguDanVehicles); v++)
    {
        if(carid == NguDanVehicles[v]) return 1;
    }
    return 0;
}

stock NguDan_ResetState(playerid)
{
    if(FishingCountdownTimer[playerid])
    {
        KillTimer(FishingCountdownTimer[playerid]);
        FishingCountdownTimer[playerid] = 0;
    }
    FishingCountdownLeft[playerid] = 0;
    PlayerTextDrawHide(playerid, FishingCountdownTD[playerid]);
    DeletePVar(playerid, "NguDan_Zone");
    DeletePVar(playerid, "NguDan_AtZone");
    DeletePVar(playerid, "NguDan_Caught");
    DeletePVar(playerid, "NguDan_Countdown");
    DisablePlayerCheckpoint(playerid);
}

stock NguDan_GetFishName(itemid)
{
    new name[32];
    switch(itemid)
    {
        case FISH_ITEM_THU: name = "Ca thu";
        case FISH_ITEM_NGU: name = "Ca ngu";
        case FISH_ITEM_NOC: name = "Ca noc";
    }
    return name;
}

stock NguDan_GetFishPrice(itemid)
{
    switch(itemid)
    {
        case FISH_ITEM_THU: return FISH_PRICE_THU;
        case FISH_ITEM_NGU: return FISH_PRICE_NGU;
        case FISH_ITEM_NOC: return FISH_PRICE_NOC;
    }
    return 0;
}

// =============================================================================
// COUNTDOWN TIMER
// =============================================================================
forward NguDan_CountdownTick(playerid);
public NguDan_CountdownTick(playerid)
{
    if(FishingCountdownLeft[playerid] <= 0)
    {
        KillTimer(FishingCountdownTimer[playerid]);
        FishingCountdownTimer[playerid] = 0;
        FishingCountdownLeft[playerid] = 0;
        PlayerTextDrawHide(playerid, FishingCountdownTD[playerid]);

        SetPVarInt(playerid, "NguDan_Caught", 1);
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "{C4A656}[NGU DAN]{FFFFFF} Luoi da bat du ca! Hay su dung ({C4A656}/thuluoi{FFFFFF}) de thu luoi.");
        return 1;
    }

    FishingCountdownLeft[playerid]--;
    new tdStr[64];
    format(tdStr, sizeof(tdStr), "~g~Tha luoi: ~w~%d giay", FishingCountdownLeft[playerid]);
    PlayerTextDrawSetString(playerid, FishingCountdownTD[playerid], tdStr);
    PlayerTextDrawShow(playerid, FishingCountdownTD[playerid]);
    return 1;
}

// =============================================================================
// COMMAND: /ngudan
// =============================================================================
CMD:ngudan(playerid, params[])
{
    if(BaoTriNguDan == 1) return SendClientMessageEx(playerid, -1, "{C4A656}[NGU DAN]{FFFFFF} Cong viec Ngu Dan hien dang duoc bao tri.");
    if(!IsPlayerInRangeOfPoint(playerid, 30.0, FISH_BASE_X, FISH_BASE_Y, FISH_BASE_Z))
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong o khu vuc ben cang.");
    if(GetPVarInt(playerid, "NguDan_Zone") != 0)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da chon vi tri roi. Dung /huyngudan de huy.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsThuyenNguDan(vehicleid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban phai ngoi tren thuyen danh bat.");

    ShowPlayerDialog(playerid, DIALOG_NGUDAN, DIALOG_STYLE_LIST, "Chon khu vuc danh bat",
        "Khu Vuc 1\tSan Fierro\nKhu Vuc 2\tSan Fierro\nKhu Vuc 3\tSan Fierro\nKhu Vuc 4\tSan Fierro", "Chon", "Quay Lai");
    return 1;
}

// =============================================================================
// DIALOG: Chọn bãi cá
// =============================================================================
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_NGUDAN)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem > 3) return 1;

        new zone = listitem;
        SetPVarInt(playerid, "NguDan_Zone", zone + 1);
        SetPlayerCheckpoint(playerid, FishingZones[zone][0], FishingZones[zone][1], FishingZones[zone][2], 20.0);

        SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Da danh dau Khu Vuc %d tren ban do. Hay lai toi do.", zone + 1);
        SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DEN]{FFFFFF} Khi den noi, su dung ({C4A656}/thaluoi{FFFFFF}) de tha luoi.");
        return 1;
    }

    if(dialogid == DIALOG_NGUDAN_SELL)
    {
        if(!response) return 1;

        new fishItem = GetPVarInt(playerid, "NguDan_SellItem");
        if(fishItem == 0) return 1;

        new amount = strval(inputtext);
        if(amount < 1)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "So luong khong hop le!");
            return 1;
        }

        new itemCount = 0;
        for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
        {
            if(CharacterInfo[playerid][0][cb_ItemID][i] == fishItem)
                itemCount += CharacterInfo[playerid][0][cb_ItemAmount][i];
        }

        if(amount > itemCount)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du ca!");
            return 1;
        }

        if(!IsPlayerInRangeOfPoint(playerid, 8.0, FISH_NPC_X, FISH_NPC_Y, FISH_NPC_Z))
            return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan NPC thu mua ca!");

        // Xóa cá khỏi balo
        new remaining = amount;
        for(new i = 0; i < MAX_PLAYER_CB_ITEM && remaining > 0; i++)
        {
            if(CharacterInfo[playerid][0][cb_ItemID][i] == fishItem)
            {
                if(CharacterInfo[playerid][0][cb_ItemAmount][i] >= remaining)
                {
                    CharacterInfo[playerid][0][cb_ItemAmount][i] -= remaining;
                    if(CharacterInfo[playerid][0][cb_ItemAmount][i] == 0)
                    {
                        CharacterInfo[playerid][0][cb_ItemID][i] = INVALID_OBJECT_ID;
                        CharacterInfo[playerid][0][cb_ItemWeight][i] = 0.0;
                        CharacterInfo[playerid][0][cb_ItemDurability][i] = 0;
                    }
                    remaining = 0;
                }
                else
                {
                    remaining -= CharacterInfo[playerid][0][cb_ItemAmount][i];
                    CharacterInfo[playerid][0][cb_ItemID][i] = INVALID_OBJECT_ID;
                    CharacterInfo[playerid][0][cb_ItemAmount][i] = 0;
                    CharacterInfo[playerid][0][cb_ItemWeight][i] = 0.0;
                    CharacterInfo[playerid][0][cb_ItemDurability][i] = 0;
                }
            }
        }

        // Tính tiền
        new pricePerKg = NguDan_GetFishPrice(fishItem);
        new totalMoney = amount * pricePerKg;
        GivePlayerCash(playerid, totalMoney);

        new szMsg[128];
        format(szMsg, sizeof(szMsg), "{C4A656}[NGU DAN]{FFFFFF} Ban da ban %d kg %s va nhan duoc {33AA33}$%s{FFFFFF}.", amount, NguDan_GetFishName(fishItem), number_format(totalMoney));
        SendClientMessageEx(playerid, COLOR_WHITE, szMsg);

        // Log
        new logStr[256], year, month, day, hour, minute, second;
        getdate(year, month, day);
        gettime(hour, minute, second);
        format(logStr, sizeof(logStr), "[%04d-%02d-%02d %02d:%02d:%02d] %s da ban %d kg %s, nhan $%s",
            year, month, day, hour, minute, second, GetPlayerNameEx(playerid), amount, NguDan_GetFishName(fishItem), number_format(totalMoney));
        Log("logs/Fishing.log", logStr);

        DeletePVar(playerid, "NguDan_SellItem");
        return 1;
    }
    return 0;
}

// =============================================================================
// CHECKPOINT: Đến bãi cá
// =============================================================================
hook OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "NguDan_Zone") > 0 && GetPVarInt(playerid, "NguDan_AtZone") == 0)
    {
        DisablePlayerCheckpoint(playerid);
        SetPVarInt(playerid, "NguDan_AtZone", 1);
        SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da den dia diem danh bat!");
        SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Su dung ({C4A656}/thaluoi{FFFFFF}) de tha luoi.");
    }
    return 1;
}

// =============================================================================
// COMMAND: /thaluoi
// =============================================================================
CMD:thaluoi(playerid, params[])
{
    if(GetPVarInt(playerid, "NguDan_AtZone") == 0)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban chua den dia diem danh bat.");
    if(GetPVarInt(playerid, "NguDan_Countdown") == 1)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban dang tha luoi roi!");
    if(GetPVarInt(playerid, "NguDan_Caught") == 1)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Luoi da bat du ca! Dung /thuluoi.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsThuyenNguDan(vehicleid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban phai ngoi tren thuyen danh bat.");

    // Bắt đầu countdown 60 giây
    SetPVarInt(playerid, "NguDan_Countdown", 1);
    FishingCountdownLeft[playerid] = FISH_COUNTDOWN_TIME;

    new tdStr[64];
    format(tdStr, sizeof(tdStr), "~g~Tha luoi: ~w~%d giay", FishingCountdownLeft[playerid]);
    PlayerTextDrawSetString(playerid, FishingCountdownTD[playerid], tdStr);
    PlayerTextDrawShow(playerid, FishingCountdownTD[playerid]);

    FishingCountdownTimer[playerid] = SetTimerEx("NguDan_CountdownTick", 1000, true, "i", playerid);

    SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da tha luoi, vui long cho 60 giay...");
    return 1;
}

// =============================================================================
// COMMAND: /thuluoi
// =============================================================================
CMD:thuluoi(playerid, params[])
{
    if(GetPVarInt(playerid, "NguDan_Caught") == 0)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Luoi chua bat du ca hay ban chua tha luoi.");
    if(GetPVarInt(playerid, "NguDan_AtZone") == 0)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong o khu vuc danh bat.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsThuyenNguDan(vehicleid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban phai ngoi tren thuyen danh bat.");

    // Random loại cá: 60% thu, 30% ngu, 10% noc
    new fishItem, fishWeight;
    new rand = random(100);

    if(rand < 60) // 60% - Cá thu
    {
        fishItem = FISH_ITEM_THU;
        fishWeight = 3 + random(8); // 3-10 kg
    }
    else if(rand < 90) // 30% - Cá ngu
    {
        fishItem = FISH_ITEM_NGU;
        fishWeight = 2 + random(5); // 2-6 kg
    }
    else // 10% - Cá noc
    {
        fishItem = FISH_ITEM_NOC;
        fishWeight = 1 + random(4); // 1-4 kg
    }

    // Thêm cá vào balo
    GivePlayerItem(playerid, fishItem, fishWeight);

    new szMsg[128];
    format(szMsg, sizeof(szMsg), "{C4A656}[NGU DAN]{FFFFFF} Ban da thu luoi duoc {F5CB42}%d kg %s{FFFFFF}!", fishWeight, NguDan_GetFishName(fishItem));
    SendClientMessageEx(playerid, COLOR_WHITE, szMsg);

    // Kiểm tra cá khủng → broadcast server
    new bool:isBig = false;
    switch(fishItem)
    {
        case FISH_ITEM_THU: if(fishWeight >= FISH_BIG_THU) isBig = true;
        case FISH_ITEM_NGU: if(fishWeight >= FISH_BIG_NGU) isBig = true;
        case FISH_ITEM_NOC: if(fishWeight >= FISH_BIG_NOC) isBig = true;
    }

    if(isBig)
    {
        new bigMsg[128];
        format(bigMsg, sizeof(bigMsg), "{FF6347}[CAU CA] {FFFFFF}%s vua bat du con %s {F5CB42}%d kg{FFFFFF}! That la khung!", GetPlayerNameEx(playerid), NguDan_GetFishName(fishItem), fishWeight);
        SendClientMessageToAll(-1, bigMsg);
    }

    // Reset trạng thái cho chuyến mới
    NguDan_ResetState(playerid);
    return 1;
}

// =============================================================================
// COMMAND: /huyngudan
// =============================================================================
CMD:huyngudan(playerid, params[])
{
    NguDan_ResetState(playerid);
    SendClientMessageEx(playerid, COLOR_GREEN, "{C4A656}[NGU DAN]{FFFFFF} Ban da huy bo qua trinh lam viec.");
    return 1;
}

// =============================================================================
// COMMAND: /banca_ngudan (bán cá cho NPC)
// =============================================================================
CMD:banca_ngudan(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, FISH_NPC_X, FISH_NPC_Y, FISH_NPC_Z))
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan NPC thu mua ca!");

    // Kiểm tra có cá trong balo không
    new hasThu, hasNgu, hasNoc;
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        new itemid = CharacterInfo[playerid][0][cb_ItemID][i];
        if(itemid == FISH_ITEM_THU) hasThu += CharacterInfo[playerid][0][cb_ItemAmount][i];
        if(itemid == FISH_ITEM_NGU) hasNgu += CharacterInfo[playerid][0][cb_ItemAmount][i];
        if(itemid == FISH_ITEM_NOC) hasNoc += CharacterInfo[playerid][0][cb_ItemAmount][i];
    }

    if(hasThu == 0 && hasNgu == 0 && hasNoc == 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co ca nao de ban!");

    new szDialog[512];
    strcat(szDialog, "Loai ca\tSo kg\tGia/kg\tTong\n");
    if(hasThu > 0) format(szDialog, sizeof(szDialog), "%s{FFFFFF}Ca thu\t%d kg\t$%s\t$%s\n", szDialog, hasThu, number_format(FISH_PRICE_THU), number_format(hasThu * FISH_PRICE_THU));
    if(hasNgu > 0) format(szDialog, sizeof(szDialog), "%s{FFFFFF}Ca ngu\t%d kg\t$%s\t$%s\n", szDialog, hasNgu, number_format(FISH_PRICE_NGU), number_format(hasNgu * FISH_PRICE_NGU));
    if(hasNoc > 0) format(szDialog, sizeof(szDialog), "%s{FFFFFF}Ca noc\t%d kg\t$%s\t$%s\n", szDialog, hasNoc, number_format(FISH_PRICE_NOC), number_format(hasNoc * FISH_PRICE_NOC));

    ShowPlayerDialog(playerid, DIALOG_NGUDAN_SELL, DIALOG_STYLE_TABLIST_HEADERS, "Shark Hung - Thu mua ca", szDialog, "Ban", "Huy");
    return 1;
}

// =============================================================================
// COMMAND: /tgngudan
// =============================================================================
CMD:tgngudan(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN, "__________Cong viec Ngu Dan___________");
    SendClientMessageEx(playerid, COLOR_GRAD3, "/ngudan - Chon khu vuc danh bat thuy san.");
    SendClientMessageEx(playerid, COLOR_GRAD3, "/thaluoi - Tha luoi (cho 60 giay).");
    SendClientMessageEx(playerid, COLOR_GRAD3, "/thuluoi - Thu luoi (nhan ca vao balo).");
    SendClientMessageEx(playerid, COLOR_GRAD3, "/banca_ngudan - Ban ca cho NPC Shark Hung.");
    SendClientMessageEx(playerid, COLOR_GRAD3, "/huyngudan - Huy bo qua trinh lam viec.");
    SendClientMessageEx(playerid, COLOR_GRAD3, "Gia ca: Thu $1,500/kg | Ngu $2,500/kg | Noc $5,000/kg");
    return 1;
}

// =============================================================================
// COMMAND: /baotringudan (Admin)
// =============================================================================
CMD:baotringudan(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 5)
    {
        if(BaoTriNguDan == 0)
        {
            BaoTriNguDan = 1;
            SendClientMessageEx(playerid, COLOR_RED, "Ban da bao tri cong viec Ngu Dan.");
        }
        else
        {
            BaoTriNguDan = 0;
            SendClientMessageEx(playerid, COLOR_GREEN, "Ban da ngung bao tri cong viec Ngu Dan.");
        }
    }
    return 1;
}

// =============================================================================
// VEHICLE ENTER HINT
// =============================================================================
hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(IsThuyenNguDan(vehicleid))
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Day la thuyen danh bat. Su dung ({C4A656}/ngudan{FFFFFF}) de chon khu vuc.");
        }
    }
    return 1;
}
