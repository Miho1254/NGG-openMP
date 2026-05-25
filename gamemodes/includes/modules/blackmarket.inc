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
new Actor:BlackMarketNPC;
new Text3D:BlackMarketLabel;

// =============================================================================
// INITIALIZATION
// =============================================================================
hook OnGameModeInit()
{
    BlackMarketNPC = CreateActor(BLACKMARKET_NPC_SKIN, BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z, BLACKMARKET_NPC_A);
    BlackMarketLabel = CreateDynamic3DTextLabel("{FF6347}Koon 8 ngon' - Black Market\n{FFFFFF}/blackmarket", COLOR_YELLOW, BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z + 1.0, 10.0);
    printf("[BlackMarket] Loaded: NPC Koon 8 ngon' at %.1f, %.1f, %.1f", BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z);
    return 1;
}

// =============================================================================
// COMMAND: /blackmarket
// =============================================================================
CMD:blackmarket(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, BLACKMARKET_NPC_X, BLACKMARKET_NPC_Y, BLACKMARKET_NPC_Z))
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan Black Market!");

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

// =============================================================================
// DIALOG CALLBACK
// =============================================================================
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BLACKMARKET)
    {
        if(!response) return 1;

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
