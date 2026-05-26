#if defined _modules_blackmarket_included
    #endinput
#endif
#define _modules_blackmarket_included

#include <YSI\y_hooks>

// =============================================================================
// CONSTANTS
// =============================================================================
#define BLACKMARKET_NPC_SKIN    73
#define BLACKMARKET_NPC_X       -1110.5009
#define BLACKMARKET_NPC_Y       -1685.7577
#define BLACKMARKET_NPC_Z       76.3739
#define BLACKMARKET_NPC_A       250.3844
#define BLACKMARKET_RATE        0.8     // 80% - nhan $0.8 cash moi $1 tien ban

// =============================================================================
// STATE
// =============================================================================
new Actor:BlackMarketNPC = Actor:INVALID_ACTOR_ID;
new Text3D:BlackMarketLabel;
new ForcedBlackMarketStatus = -1; // -1 = auto, 1 = force open, 0 = force closed
new last_market_status = 0;       // 0 = closed, 1 = open
new last_checked_day = -1;

// =============================================================================
// HELPERS
// =============================================================================
stock IsBlackMarketOpen()
{
    if(ForcedBlackMarketStatus == 1) return 1;
    if(ForcedBlackMarketStatus == 0) return 0;

    new year, month, day;
    getdate(year, month, day);
    new day_num = day + (month * 31) + (year * 372);
    new chance = (day_num * 13 + 7) % 10;
    if(chance < 3) return 1;
    return 0;
}

stock UpdateBlackMarketStatus(bool:startup = false)
{
    new current_status = IsBlackMarketOpen();
    
    if(current_status == 1)
    {
        if(BlackMarketNPC == Actor:INVALID_ACTOR_ID || !IsValidActor(BlackMarketNPC))
        {
            BlackMarketNPC = CreateActor(BLACKMARKET_NPC_SKIN, BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z, BLACKMARKET_NPC_A);
        }
        UpdateDynamic3DTextLabelText(BlackMarketLabel, COLOR_YELLOW, "{FF6347}Koon 8 ngon' - Black Market\n{FFFFFF}/blackmarket");
        
        if(last_market_status == 0 && !startup)
        {
            SendClientMessageToAllEx(COLOR_YELLOW, "{C4A656}[BLACK MARKET]{FFFFFF} Koon 8 ngon' da xuat hien tai Black Market va dang thu mua tien ban! go /blackmarket de kiem tra.");
        }
    }
    else
    {
        if(BlackMarketNPC != Actor:INVALID_ACTOR_ID && IsValidActor(BlackMarketNPC))
        {
            DestroyActor(BlackMarketNPC);
            BlackMarketNPC = Actor:INVALID_ACTOR_ID;
        }
        UpdateDynamic3DTextLabelText(BlackMarketLabel, COLOR_YELLOW, "{FF6347}Koon 8 ngon' - Black Market\n{FFFFFF}Koon 8 ngon' da di Ngu Hanh Son, xin quay lai sau....");
    }
    
    last_market_status = current_status;
}

// =============================================================================
// INITIALIZATION
// =============================================================================
hook OnGameModeInit()
{
    BlackMarketNPC = Actor:INVALID_ACTOR_ID;
    BlackMarketLabel = CreateDynamic3DTextLabel("{FF6347}Koon 8 ngon' - Black Market\n{FFFFFF}Koon 8 ngon' da di Ngu Hanh Son, xin quay lai sau....", COLOR_YELLOW, BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z + 1.0, 10.0);
    
    new year, month, day;
    getdate(year, month, day);
    last_checked_day = day;
    
    UpdateBlackMarketStatus(true);
    printf("[BlackMarket] Loaded: NPC Koon 8 ngon' status initialized");
    return 1;
}

task UpdateBlackMarketTimer[600000]()
{
    new year, month, day;
    getdate(year, month, day);
    if(day != last_checked_day)
    {
        last_checked_day = day;
        ForcedBlackMarketStatus = -1; // Reset forced status at midnight
    }
    UpdateBlackMarketStatus();
}

// =============================================================================
// COMMANDS
// =============================================================================
CMD:blackmarket(playerid, params[])
{
    if(!IsBlackMarketOpen())
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Koon 8 ngon' hien dang di Ngu Hanh Son, xin quay lai sau....");
    }

    if(!IsPlayerInRangeOfPoint(playerid, 8.0, BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z))
    {
        return SendClientMessageEx(playerid, COLOR_YELLOW, "Koon 8 ngon' dang co mat tai Black Market! Hay den gap ong ta de giao dich.");
    }

    if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerTied[playerid] != 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay bay gio!");

    new dirtyMoney = PlayerInfo[playerid][pDirtyMoney];
    new szDialog[512];

    format(szDialog, sizeof(szDialog),
        "{FFFFFF}Chao mung den voi {FF6347}Black Market{FFFFFF}.\n\n\
        Tien ban hien co: {F5CB42}$%s{FFFFFF}\n\
        Ti le quy doi: {F5CB42}%.0f%%{FFFFFF} ($1 tien ban = $%.2f cash)\n\n\
        Nhap so tien ban muon doi:",
        number_format(dirtyMoney),
        BLACKMARKET_RATE * 100,
        BLACKMARKET_RATE);

    ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET, DIALOG_STYLE_INPUT, "Koon 8 ngon' - Black Market", szDialog, "Doi", "Huy");
    return 1;
}

CMD:forcek8n(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co quyen su dung lenh nay!");

    new status;
    if(sscanf(params, "d", status))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /forcek8n [status] (1: Mo/Trieu hoi, 0: Dong/Tat, -1: Tu dong theo thuat toan)");
        return 1;
    }

    if(status < -1 || status > 1)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Status phai tu -1 den 1!");
        return 1;
    }

    ForcedBlackMarketStatus = status;
    UpdateBlackMarketStatus();

    new szMsg[128];
    if(status == 1)
    {
        format(szMsg, sizeof(szMsg), "Admin %s da cuong che trieu hoi Koon 8 ngon' (Mo Black Market).", GetPlayerNameEx(playerid));
        ABroadCast(COLOR_YELLOW, szMsg, 4);
    }
    else if(status == 0)
    {
        format(szMsg, sizeof(szMsg), "Admin %s da cuong che an Koon 8 ngon' (Dong Black Market).", GetPlayerNameEx(playerid));
        ABroadCast(COLOR_YELLOW, szMsg, 4);
    }
    else
    {
        format(szMsg, sizeof(szMsg), "Admin %s da reset trang thai Koon 8 ngon' ve tu dong theo thuat toan.", GetPlayerNameEx(playerid));
        ABroadCast(COLOR_YELLOW, szMsg, 4);
    }
    return 1;
}

// =============================================================================
// DIALOG CALLBACK
// =============================================================================
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BLACKMARKET)
    {
        if(!response) return 1;

        if(!IsBlackMarketOpen())
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Black Market hien dang dong cua!");
            return 1;
        }

        new amount = strval(inputtext);
        if(amount < 1)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "So luong khong hop le!");
            return 1;
        }

        if(amount > PlayerInfo[playerid][pDirtyMoney])
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien ban!");
            return 1;
        }

        if(!IsPlayerInRangeOfPoint(playerid, 8.0, BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z))
            return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan Black Market!");

        // Tính tiền nhận được
        new cashReceived = floatround(amount * BLACKMARKET_RATE, floatround_floor);

        // Trừ tiền bẩn, cộng tiền cash
        PlayerInfo[playerid][pDirtyMoney] -= amount;
        GivePlayerCash(playerid, cashReceived);

        new szMsg[128];
        format(szMsg, sizeof(szMsg), "{C4A656}[BLACK MARKET]{FFFFFF} Ban da doi $%s tien ban thanh {33AA33}$%s{FFFFFF} cash.", number_format(amount), number_format(cashReceived));
        SendClientMessageEx(playerid, COLOR_WHITE, szMsg);

        format(szMsg, sizeof(szMsg), "{C4A656}[BLACK MARKET]{FFFFFF} Tien ban con lai: {F5CB42}$%s{FFFFFF}.", number_format(PlayerInfo[playerid][pDirtyMoney]));
        SendClientMessageEx(playerid, COLOR_WHITE, szMsg);

        // Log
        new logStr[256], year, month, day, hour, minute, second;
        getdate(year, month, day);
        gettime(hour, minute, second);
        format(logStr, sizeof(logStr), "[%04d-%02d-%02d %02d:%02d:%02d] %s doi $%s tien ban thanh $%s cash (con lai $%s tien ban)",
            year, month, day, hour, minute, second, GetPlayerNameEx(playerid), number_format(amount), number_format(cashReceived), number_format(PlayerInfo[playerid][pDirtyMoney]));
        Log("logs/BlackMarket.log", logStr);
    }
    return 0;
}
