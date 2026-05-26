#if defined _modules_inventory_included
    #endinput
#endif

#define _modules_inventory_included

#include <YSI\y_hooks>

#define MAX_INTERFACE 2
#define MAX_PLAYER_CB_ITEM 84
#define MAX_SERIAL_LENGTH 36

// Shared variables used by inventory + guide + event systems
// Declared here since inventory.inc is included first
new Guide_ReadPost[MAX_PLAYERS];
new GuideTimer[MAX_PLAYERS];
new TaskFarm_Show[MAX_PLAYERS];
new Event_Show[1][MAX_PLAYERS];

stock IsPlayerUsingSampMobile(playerid) {
    #pragma unused playerid
    return 0;
}

stock SendAdminMessage(level, const message[]) {
    #pragma unused level
    new tmp[256];
    format(tmp, sizeof(tmp), "%s", message);
    ABroadCast(COLOR_YELLOW, tmp, 2);
    return 1;
}

stock Inventory_Update_Hunger(playerid) {
    #pragma unused playerid
    return 1;
}

stock Inventory_CheckRedZoneData(playerid) {
    #pragma unused playerid
    return 0;
}

forward Inventory_ShowBDKBTimer(playerid);
public Inventory_ShowBDKBTimer(playerid) {
    #pragma unused playerid
    return 1;
}

forward Inventory_AutoSave();
public Inventory_AutoSave()
{
    foreach(new i : Player)
    {
        if(gPlayerLogged{i})
        {
            Inventory_SaveData(i);
            SavePlayerAccountic(i);
        }
    }
    return 1;
}

hook OnGameModeInit()
{
    SetTimer("Inventory_AutoSave", 300000, true); // 5 minutes
    return 1;
}

enum cb_Info // character inventory info
{
    Float:cb_Weight,
    cb_ItemLock[MAX_PLAYER_CB_ITEM],
    cb_ItemID[MAX_PLAYER_CB_ITEM],
    Float:cb_ItemWeight[MAX_PLAYER_CB_ITEM],
    cb_ItemDurability[MAX_PLAYER_CB_ITEM],
    cb_ItemAmount[MAX_PLAYER_CB_ITEM]
};
new CharacterInfo[MAX_PLAYERS][MAX_INTERFACE][cb_Info];

new cb_ItemSerial[MAX_PLAYERS][MAX_INTERFACE][MAX_PLAYER_CB_ITEM][MAX_SERIAL_LENGTH];

new Inventory_Character[MAX_PLAYERS];
new Inventory_Timer[MAX_PLAYERS];

stock Inventory_IsLAWWeapon(playerid, weaponid)
{
    for(new i = 0; i < 7; i++)
    {
        new itemid = CharacterInfo[playerid][1][cb_ItemID][i];
        if(itemid >= 44 && itemid <= 48 && GetIDWeapon(itemid) == weaponid)
            return 1;
    }
    return 0;
}

stock Inventory_GetItemName(playerid, weaponid)
{
    new name[32];
    for(new i = 0; i < 7; i++)
    {
        new itemid = CharacterInfo[playerid][1][cb_ItemID][i];
        if(GetIDWeapon(itemid) == weaponid)
        {
            format(name, sizeof(name), "%s", Inventory_ListItems[itemid - 1]);
            return name;
        }
    }
    GetWeaponNameEx(weaponid, name, sizeof(name));
    return name;
}

new Inventory_ListItems[][] =
{
    "Camera","Minigun","Khoang san bac","Khoang san niken","Khoang san vang","Khoang san Cu (Dong)","Khoang san Crom","May dao thuong","May dao VIP",
    "Coin Exchange (gp -> coin)", "Medkit", "Thuoc gatacetamol", "Phieu mo rong tui do", "The GP Bonus 30%", "The EXP Bonus 10%", "The EXP Bonus 20%",
    "The EXP Bonus 30%", "Hom trang phuc Event Vietnam Capsule mua 1", "Hom xe Event Vietnam Capsule mua 1", "Hom Toy Event Vietnam Capsule mua 1",
    "Jerry can (100 lit)", "Jerry can (200 lit)", "SD-Pistol", "Colt-9mm", "Deagle", "Shotgun", "Sawn-Off", "Spas-12", "Uzi", "Mp5", "AK", "M4",
    "Tec9", "Rifle", "Sniper", "Da tho", "Ca thu", "Ca ngu", "Ca noc", "Ruou & thuoc la", "Hop dan tich hop", "Combo GFC", "Ban do kho bau","M4 LAW",
    "AK LAW", "Deagle LAW", "9mm LAW", "MP5 LAW", "Sword Katana", "Gay Bong Chay",
    "Can sa nguyen chat", "Tui zip can sa", "Picklock"
};

new PlayerText: GTASA_Inventory[MAX_PLAYERS][2][62];

// non stection
stock Float:GetItemWeight(item)
{
    switch(item)
    {
        case 1: // camera
        {
            return 1.0;
        }
        case 2: // minigun
        {
            return 15.0;
        }
        case 3 .. 7: // khoáng sản
        {
            return 4.0;
        }
        case 8 .. 9: // máy khai thác
        {
            return 10.0;
        }
        case 10: // thẻ mở slot kho đồ
        {
            return 0.2;
        }
        case 11: // medkit
        {
            return 1.2;
        }
        case 12 .. 17: // thẻ phiếu thuốc
        {
            return 0.4;
        }
        case 18 .. 20: // box
        {
            return 1.5;
        }
        case 21 .. 22:
        {
            return 10.0;
        }
        case 23 .. 25:
        {
            return 3.0;
        }
        case 26 .. 35:
        {
            return 4.0;
        }
        case 36:
        {
            return 4.0;
        }
        case 37 .. 39:
        {
            return 1.2;
        }
        case 40:
        {
            return 0.4;
        }
        case 41: // Hop dan
        {
            return 2.0;
        }
        case 42:
        {
            return 0.4;
        }
        case 43:
        {
            return 0.0;
        }
        case 44, 45, 48: // m4, ak, mp5 law
        {
            return 4.0;
        }
        case 46, 47: // deagle, 9mm
        {
            return 3.0;
        }
        case 49:
        {
            return 2.1;
        }
        case 50:
        {
            return 2.1;
        }
        case 51: // Can sa nguyen chat
        {
            return 0.8;
        }
        case 52: // Tui zip can sa
        {
            return 0.4;
        }
        case 53: // Picklock
        {
            return 0.5;
        }
    }
    return 0.0;
}

Function: CPTD_Inventory(playerid)
{
    GTASA_Inventory[playerid][0][0] = CreatePlayerTextDraw(playerid, 470.000, 134.000, "mdl-2002:bg_main");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][0], 164.000, 274.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][0], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][0], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][0], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][0], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][0], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][0], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][0], 1);

    GTASA_Inventory[playerid][0][1] = CreatePlayerTextDraw(playerid, 307.000, 134.000, "mdl-2002:bg_character");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][1], 164.000, 209.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][1], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][1], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][1], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][1], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][1], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][1], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][1], 1);

    GTASA_Inventory[playerid][0][2] = CreatePlayerTextDraw(playerid, 617.000, 143.000, "mdl-2002:btn_cancel");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][2], 10.000, 11.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][2], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][2], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][2], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][2], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][2], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][2], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][2], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][2], 1);

    GTASA_Inventory[playerid][0][3] = CreatePlayerTextDraw(playerid, 573.000, 372.000, "mdl-2002:btn_select");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][3], 53.000, 13.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][3], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][3], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][3], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][3], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][3], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][3], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][3], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][3], 1);

    GTASA_Inventory[playerid][0][4] = CreatePlayerTextDraw(playerid, 573.000, 387.000, "mdl-2002:btn_character");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][4], 53.000, 13.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][4], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][4], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][4], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][4], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][4], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][4], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][4], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][4], 1);

    GTASA_Inventory[playerid][0][5] = CreatePlayerTextDraw(playerid, 440.000, 309.000, "_");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][5], 27.000, 21.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][5], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][5], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][5], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][5], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][5], 0);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][5], 5);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][5], 0);
    PlayerTextDrawSetPreviewModel(playerid, GTASA_Inventory[playerid][0][5], 27);
    PlayerTextDrawSetPreviewRot(playerid, GTASA_Inventory[playerid][0][5], -28.000, 0.000, 0.000, 1.000);
    PlayerTextDrawSetPreviewVehCol(playerid, GTASA_Inventory[playerid][0][5], 0, 0);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][5], 1);

    GTASA_Inventory[playerid][0][6] = CreatePlayerTextDraw(playerid, 316.000, 170.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][6], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][6], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][6], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][6], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][6], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][6], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][6], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][6], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][6], 1);

    GTASA_Inventory[playerid][0][7] = CreatePlayerTextDraw(playerid, 316.000, 201.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][7], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][7], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][7], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][7], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][7], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][7], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][7], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][7], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][7], 1);

    GTASA_Inventory[playerid][0][8] = CreatePlayerTextDraw(playerid, 316.000, 232.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][8], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][8], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][8], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][8], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][8], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][8], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][8], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][8], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][8], 1);

    GTASA_Inventory[playerid][0][9] = CreatePlayerTextDraw(playerid, 316.000, 262.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][9], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][9], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][9], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][9], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][9], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][9], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][9], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][9], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][9], 1);

    GTASA_Inventory[playerid][0][10] = CreatePlayerTextDraw(playerid, 439.000, 170.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][10], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][10], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][10], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][10], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][10], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][10], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][10], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][10], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][10], 1);

    GTASA_Inventory[playerid][0][11] = CreatePlayerTextDraw(playerid, 439.000, 201.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][11], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][11], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][11], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][11], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][11], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][11], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][11], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][11], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][11], 1);

    GTASA_Inventory[playerid][0][12] = CreatePlayerTextDraw(playerid, 439.000, 232.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][12], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][12], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][12], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][12], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][12], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][12], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][12], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][12], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][12], 1);

    GTASA_Inventory[playerid][0][13] = CreatePlayerTextDraw(playerid, 479.000, 166.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][13], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][13], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][13], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][13], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][13], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][13], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][13], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][13], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][13], 1);

    GTASA_Inventory[playerid][0][14] = CreatePlayerTextDraw(playerid, 504.000, 166.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][14], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][14], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][14], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][14], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][14], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][14], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][14], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][14], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][14], 1);

    GTASA_Inventory[playerid][0][15] = CreatePlayerTextDraw(playerid, 529.000, 166.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][15], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][15], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][15], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][15], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][15], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][15], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][15], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][15], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][15], 1);

    GTASA_Inventory[playerid][0][16] = CreatePlayerTextDraw(playerid, 554.000, 166.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][16], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][16], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][16], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][16], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][16], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][16], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][16], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][16], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][16], 1);

    GTASA_Inventory[playerid][0][17] = CreatePlayerTextDraw(playerid, 578.000, 166.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][17], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][17], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][17], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][17], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][17], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][17], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][17], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][17], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][17], 1);

    GTASA_Inventory[playerid][0][18] = CreatePlayerTextDraw(playerid, 603.000, 166.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][18], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][18], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][18], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][18], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][18], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][18], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][18], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][18], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][18], 1);

    GTASA_Inventory[playerid][0][19] = CreatePlayerTextDraw(playerid, 479.000, 194.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][19], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][19], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][19], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][19], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][19], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][19], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][19], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][19], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][19], 1);

    GTASA_Inventory[playerid][0][20] = CreatePlayerTextDraw(playerid, 504.000, 194.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][20], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][20], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][20], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][20], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][20], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][20], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][20], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][20], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][20], 1);

    GTASA_Inventory[playerid][0][21] = CreatePlayerTextDraw(playerid, 529.000, 194.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][21], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][21], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][21], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][21], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][21], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][21], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][21], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][21], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][21], 1);

    GTASA_Inventory[playerid][0][22] = CreatePlayerTextDraw(playerid, 554.000, 194.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][22], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][22], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][22], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][22], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][22], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][22], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][22], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][22], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][22], 1);

    GTASA_Inventory[playerid][0][23] = CreatePlayerTextDraw(playerid, 578.000, 194.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][23], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][23], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][23], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][23], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][23], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][23], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][23], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][23], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][23], 1);

    GTASA_Inventory[playerid][0][24] = CreatePlayerTextDraw(playerid, 603.000, 194.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][24], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][24], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][24], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][24], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][24], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][24], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][24], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][24], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][24], 1);

    GTASA_Inventory[playerid][0][25] = CreatePlayerTextDraw(playerid, 479.000, 222.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][25], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][25], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][25], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][25], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][25], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][25], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][25], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][25], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][25], 1);

    GTASA_Inventory[playerid][0][26] = CreatePlayerTextDraw(playerid, 504.000, 222.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][26], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][26], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][26], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][26], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][26], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][26], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][26], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][26], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][26], 1);

    GTASA_Inventory[playerid][0][27] = CreatePlayerTextDraw(playerid, 529.000, 222.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][27], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][27], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][27], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][27], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][27], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][27], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][27], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][27], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][27], 1);

    GTASA_Inventory[playerid][0][28] = CreatePlayerTextDraw(playerid, 554.000, 222.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][28], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][28], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][28], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][28], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][28], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][28], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][28], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][28], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][28], 1);

    GTASA_Inventory[playerid][0][29] = CreatePlayerTextDraw(playerid, 578.000, 222.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][29], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][29], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][29], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][29], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][29], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][29], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][29], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][29], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][29], 1);

    GTASA_Inventory[playerid][0][30] = CreatePlayerTextDraw(playerid, 603.000, 222.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][30], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][30], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][30], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][30], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][30], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][30], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][30], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][30], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][30], 1);

    GTASA_Inventory[playerid][0][31] = CreatePlayerTextDraw(playerid, 479.000, 251.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][31], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][31], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][31], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][31], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][31], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][31], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][31], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][31], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][31], 1);

    GTASA_Inventory[playerid][0][32] = CreatePlayerTextDraw(playerid, 504.000, 251.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][32], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][32], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][32], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][32], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][32], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][32], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][32], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][32], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][32], 1);

    GTASA_Inventory[playerid][0][33] = CreatePlayerTextDraw(playerid, 529.000, 251.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][33], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][33], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][33], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][33], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][33], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][33], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][33], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][33], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][33], 1);

    GTASA_Inventory[playerid][0][34] = CreatePlayerTextDraw(playerid, 554.000, 251.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][34], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][34], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][34], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][34], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][34], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][34], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][34], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][34], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][34], 1);

    GTASA_Inventory[playerid][0][35] = CreatePlayerTextDraw(playerid, 578.000, 251.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][35], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][35], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][35], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][35], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][35], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][35], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][35], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][35], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][35], 1);

    GTASA_Inventory[playerid][0][36] = CreatePlayerTextDraw(playerid, 603.000, 251.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][36], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][36], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][36], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][36], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][36], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][36], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][36], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][36], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][36], 1);

    GTASA_Inventory[playerid][0][37] = CreatePlayerTextDraw(playerid, 479.000, 280.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][37], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][37], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][37], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][37], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][37], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][37], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][37], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][37], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][37], 1);

    GTASA_Inventory[playerid][0][38] = CreatePlayerTextDraw(playerid, 504.000, 280.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][38], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][38], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][38], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][38], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][38], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][38], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][38], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][38], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][38], 1);

    GTASA_Inventory[playerid][0][39] = CreatePlayerTextDraw(playerid, 529.000, 280.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][39], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][39], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][39], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][39], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][39], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][39], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][39], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][39], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][39], 1);

    GTASA_Inventory[playerid][0][40] = CreatePlayerTextDraw(playerid, 554.000, 280.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][40], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][40], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][40], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][40], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][40], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][40], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][40], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][40], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][40], 1);

    GTASA_Inventory[playerid][0][41] = CreatePlayerTextDraw(playerid, 578.000, 280.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][41], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][41], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][41], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][41], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][41], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][41], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][41], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][41], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][41], 1);

    GTASA_Inventory[playerid][0][42] = CreatePlayerTextDraw(playerid, 603.000, 280.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][42], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][42], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][42], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][42], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][42], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][42], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][42], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][42], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][42], 1);

    GTASA_Inventory[playerid][0][43] = CreatePlayerTextDraw(playerid, 479.000, 308.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][43], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][43], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][43], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][43], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][43], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][43], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][43], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][43], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][43], 1);

    GTASA_Inventory[playerid][0][44] = CreatePlayerTextDraw(playerid, 504.000, 308.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][44], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][44], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][44], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][44], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][44], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][44], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][44], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][44], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][44], 1);

    GTASA_Inventory[playerid][0][45] = CreatePlayerTextDraw(playerid, 529.000, 308.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][45], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][45], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][45], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][45], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][45], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][45], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][45], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][45], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][45], 1);

    GTASA_Inventory[playerid][0][46] = CreatePlayerTextDraw(playerid, 554.000, 308.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][46], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][46], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][46], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][46], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][46], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][46], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][46], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][46], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][46], 1);

    GTASA_Inventory[playerid][0][47] = CreatePlayerTextDraw(playerid, 578.000, 308.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][47], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][47], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][47], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][47], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][47], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][47], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][47], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][47], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][47], 1);

    GTASA_Inventory[playerid][0][48] = CreatePlayerTextDraw(playerid, 603.000, 308.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][48], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][48], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][48], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][48], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][48], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][48], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][48], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][48], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][48], 1);

    GTASA_Inventory[playerid][0][49] = CreatePlayerTextDraw(playerid, 479.000, 336.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][49], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][49], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][49], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][49], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][49], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][49], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][49], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][49], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][49], 1);

    GTASA_Inventory[playerid][0][50] = CreatePlayerTextDraw(playerid, 504.000, 336.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][50], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][50], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][50], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][50], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][50], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][50], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][50], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][50], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][50], 1);

    GTASA_Inventory[playerid][0][51] = CreatePlayerTextDraw(playerid, 529.000, 336.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][51], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][51], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][51], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][51], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][51], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][51], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][51], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][51], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][51], 1);

    GTASA_Inventory[playerid][0][52] = CreatePlayerTextDraw(playerid, 554.000, 336.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][52], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][52], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][52], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][52], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][52], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][52], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][52], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][52], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][52], 1);

    GTASA_Inventory[playerid][0][53] = CreatePlayerTextDraw(playerid, 578.000, 336.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][53], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][53], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][53], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][53], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][53], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][53], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][53], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][53], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][53], 1);

    GTASA_Inventory[playerid][0][54] = CreatePlayerTextDraw(playerid, 603.000, 336.000, "mdl-2002:item_lock");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][54], 22.000, 25.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][54], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][54], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][54], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][54], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][54], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][54], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][54], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][54], 1);

    GTASA_Inventory[playerid][0][55] = CreatePlayerTextDraw(playerid, 368.000, 307.000, "mdl-2002:item_progress_colweight");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][55], 67.000, 7.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][55], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][55], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][55], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][55], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][55], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][55], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][55], 1);

    GTASA_Inventory[playerid][0][56] = CreatePlayerTextDraw(playerid, 368.000, 323.000, "mdl-2002:item_progress_coladventure");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][56], 67.000, 7.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][56], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][56], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][56], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][56], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][56], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][56], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][56], 1);

    GTASA_Inventory[playerid][0][57] = CreatePlayerTextDraw(playerid, 491.000, 374.000, "999,999,999");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][0][57], 0.140, 0.898);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][57], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][57], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][57], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][57], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][57], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][57], 1);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][57], 1);

    GTASA_Inventory[playerid][0][58] = CreatePlayerTextDraw(playerid, 491.000, 388.000, "999,999,999");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][0][58], 0.140, 0.898);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][58], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][58], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][58], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][58], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][58], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][58], 1);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][58], 1);

    GTASA_Inventory[playerid][0][59] = CreatePlayerTextDraw(playerid, 540.000, 364.000, "LD_BEAT:left");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][59], 6.000, 6.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][59], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][59], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][59], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][59], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][59], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][59], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][59], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][59], 1);

    GTASA_Inventory[playerid][0][60] = CreatePlayerTextDraw(playerid, 559.000, 364.000, "LD_BEAT:right");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][60], 6.000, 6.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][60], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][60], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][60], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][60], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][60], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][60], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][60], 1);
    PlayerTextDrawSetSelectable(playerid, GTASA_Inventory[playerid][0][60], 1);

    GTASA_Inventory[playerid][0][61] = CreatePlayerTextDraw(playerid, 553.000, 363.000, "1/2");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][0][61], 0.150, 0.799);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][0][61], 2);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][0][61], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][0][61], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][0][61], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][0][61], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][0][61], 3);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][0][61], 1);
    
    return 1;
}

Function: CPTD_InventoryInfo(playerid)
{
    new i;
    new Float:x[MAX_PLAYER_TD_INVENTORYINFO];
    new Float:y[MAX_PLAYER_TD_INVENTORYINFO];
    for(i = 0 ; i < MAX_PLAYER_TD_INVENTORYINFO ; i++)
    {
        PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][i]);
        GTASA_Inventory[playerid][1][i] = PlayerText:INVALID_TEXT_DRAW;
    }
    switch(Inventory_Character[playerid])
    {
        case 1:
        {
            x[0] = 147.000;
            y[0] = 133.000;
            //
            x[1] = 194.000;
            y[1] = 174.000;
            //
            x[2] = 194.000;
            y[2] = 188.000;
            //
            x[3] = 193.000;
            y[3] = 145.000;
            //
            x[4] = 194.000;
            y[4] = 159.000;
            //
            x[5] = 193.000;
            y[5] = 203.000;
            //
            x[6] = 202.000;
            y[6] = 218.000;
            //
            x[7] = 163.000;
            y[7] = 250.000;
        }
        default:
        {
            x[0] = 306.000;
            y[0] = 133.000;
            //
            x[1] = 353.000;
            y[1] = 174.000;
            //
            x[2] = 353.000;
            y[2] = 188.000;
            //
            x[3] = 349.000;
            y[3] = 145.000;
            //
            x[4] = 353.000;
            y[4] = 159.000;
            //
            x[5] = 352.000;
            y[5] = 203.000;
            //
            x[6] = 361.000;
            y[6] = 218.000;
            //
            x[7] = 322.000;
            y[7] = 250.000;
        }
    }

    // item_info
    GTASA_Inventory[playerid][1][0] = CreatePlayerTextDraw(playerid, x[0], y[0], "mdl-2002:item_info");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][1][0], 164.000, 167.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][0], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][0], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][0], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][0], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][0], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][0], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][0], 1);

    // item_progress_colplus 1
    GTASA_Inventory[playerid][1][1] = CreatePlayerTextDraw(playerid, x[1], y[1], "mdl-2002:item_progress_colplus");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][1][1], 61.000, 7.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][1], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][1], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][1], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][1], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][1], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][1], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][1], 1);

    // item_progress_colplus 2
    GTASA_Inventory[playerid][1][2] = CreatePlayerTextDraw(playerid, x[2], y[2], "mdl-2002:item_progress_colplus");
    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][1][2], 61.000, 7.000);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][2], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][2], -1);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][2], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][2], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][2], 255);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][2], 4);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][2], 1);

    // ITEM_NULL
    GTASA_Inventory[playerid][1][3] = CreatePlayerTextDraw(playerid, x[3], y[3], "ITEM_NULL");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][1][3], 0.140, 0.898);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][3], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][3], -1061109505);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][3], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][3], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][3], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][3], 2);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][3], 1);

    // A5WE5WD4ARE2
    GTASA_Inventory[playerid][1][4] = CreatePlayerTextDraw(playerid, x[4], y[4], "NULL");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][1][4], 0.140, 0.898);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][4], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][4], -1061109505);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][4], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][4], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][4], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][4], 2);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][4], 1);

    // 100/200
    GTASA_Inventory[playerid][1][5] = CreatePlayerTextDraw(playerid, x[5], y[5], "100/200");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][1][5], 0.140, 0.898);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][5], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][5], -1061109505);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][5], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][5], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][5], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][5], 2);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][5], 1);

    // 100/200
    GTASA_Inventory[playerid][1][6] = CreatePlayerTextDraw(playerid, x[6], y[6], "50/200");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][1][6], 0.140, 0.898);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][6], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][6], -1061109505);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][6], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][6], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][6], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][6], 2);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][6], 1);

    // mô tả item
    GTASA_Inventory[playerid][1][7] = CreatePlayerTextDraw(playerid, x[7], y[7], "Khong ro item nay la gi nhung nguoi so huu no chac chan~n~rat dep trai");
    PlayerTextDrawLetterSize(playerid, GTASA_Inventory[playerid][1][7], 0.140, 0.898);
    PlayerTextDrawAlignment(playerid, GTASA_Inventory[playerid][1][7], 1);
    PlayerTextDrawColor(playerid, GTASA_Inventory[playerid][1][7], -626712321);
    PlayerTextDrawSetShadow(playerid, GTASA_Inventory[playerid][1][7], 0);
    PlayerTextDrawSetOutline(playerid, GTASA_Inventory[playerid][1][7], 0);
    PlayerTextDrawBackgroundColor(playerid, GTASA_Inventory[playerid][1][7], 150);
    PlayerTextDrawFont(playerid, GTASA_Inventory[playerid][1][7], 1);
    PlayerTextDrawSetProportional(playerid, GTASA_Inventory[playerid][1][7], 1);

    return 1;
}

Function: Inventory_Action(playerid, action)
{
    new i, z;
    new str[256];
    
    switch(action)
    {
        case -1:
        {
            SetPVarInt(playerid, "Inventory_SelectItem", -1);
            SetPVarInt(playerid, "Inventory_SelectTarget", 0);
            SetPVarInt(playerid, "CheckDialogInventory", 0);
        }
        case 0:
        {
            if(GetPVarInt(playerid, "TimeRefreshInventory") != 0) 
                return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban can doi 3 giay de tiep tuc thao tac moi.");

            for(i = 0 ; i < MAX_PLAYER_TD_INVENTORY ; i++)
            {
                if(i < MAX_PLAYER_TD_INVENTORYINFO)
                {
                    if(GTASA_Inventory[playerid][0][i] != PlayerText:INVALID_TEXT_DRAW || 
                       GTASA_Inventory[playerid][1][i] != PlayerText:INVALID_TEXT_DRAW || 
                       Inventory_Show[playerid] != 0)
                        return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban can /closeinv de dong tui.");
                }

                if(GTASA_Inventory[playerid][0][i] != PlayerText:INVALID_TEXT_DRAW || 
                   Inventory_Show[playerid] != 0)
                    return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban can /closeinv de dong tui.");
            }

            Inventory_Character[playerid] = 0;
            CPTD_Inventory(playerid);
            CPTD_InventoryInfo(playerid);

            for(i = 0 ; i < MAX_PLAYER_TD_INVENTORY ; i++)
            {
                PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][0][i]);
                if(i < MAX_PLAYER_TD_INVENTORYINFO) 
                    PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][i]);
            }

            SelectTextDraw(playerid, 0xFF422485);
            format(str, sizeof(str), "%s", number_format(PlayerData[playerid][pc_GP]));
            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][57], str);
            format(str, sizeof(str), "%s", number_format(PlayerData[playerid][pc_Coin]));
            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][58], str);
            if(CharacterInfo[playerid][0][cb_Weight] == 45.0) CharacterInfo[playerid][0][cb_Weight] = 60.0;
            for(i = 11 ; i < 13 ; i++)
            {
                if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
                {
                    CharacterInfo[playerid][0][cb_ItemLock][i] = 0;
                }
            }
            Inventory_Action(playerid, 1);
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban da mo 'TUI DO' thanh cong.");
            Guide_ReadPost[playerid] = 1;
            SetPVarInt(playerid, "TimeRefreshInventory", 3);
            SetPVarInt(playerid, "AdminYourSelf", 0);
            SetPVarInt(playerid, "Inventory_SelectItem", -1);
            SetPVarInt(playerid, "Inventory_SelectTarget", 0);
            SetPVarInt(playerid, "Exchange_Coin_Request", 0);
            SetPVarInt(playerid, "Inventory_GraftingItem", 0);
            SetPVarInt(playerid, "CheckDialogInventory", 0);
            PlayAnimEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);
            Inventory_Timer[playerid] = SetTimerEx("InventoryTimer_", 1000, true, "i", playerid);
            Inventory_Show[playerid] = 1;
            return 1;
        }

        case 1:
        {
            new hide[] = {0, 1, 2, 3, 4, 5, 6, 7, 1, 5, 6, 7, 8, 9, 10, 11, 12, 55, 56};
            for(i = 0 ; i < sizeof(hide) ; i++)
            {
                if(i < MAX_PLAYER_TD_INVENTORYINFO)
                    PlayerTextDrawHide(playerid, GTASA_Inventory[playerid][1][hide[i]]);
                if(i >= MAX_PLAYER_TD_INVENTORYINFO)
                    PlayerTextDrawHide(playerid, GTASA_Inventory[playerid][0][hide[i]]);
            }


            for(i = 0 ; i < MAX_INTERFACE ; i++)
            {
                for(z = 0 ; z < 42 ; z++)
                {
                    if(i == 0)
                    {
                        if(CharacterInfo[playerid][i][cb_ItemLock][z] == 1) 
                            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 13], "mdl-2002:item_lock");
                        if(CharacterInfo[playerid][i][cb_ItemLock][z] == 0 && CharacterInfo[playerid][i][cb_ItemID][z] == INVALID_OBJECT_ID) 
                            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 13], "mdl-2002:item_null");
                        if(CharacterInfo[playerid][i][cb_ItemLock][z] == 0 && CharacterInfo[playerid][i][cb_ItemID][z] != INVALID_OBJECT_ID)
                        {
                            format(str, sizeof(str), "%s", GetItemMDL(CharacterInfo[playerid][i][cb_ItemID][z]));
                            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 13], str);
                        }
                    }
                    else
                    {
                        if(z < 7)
                        {
                            if(CharacterInfo[playerid][i][cb_ItemLock][z] == 1) 
                                PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 6], "mdl-2002:item_lock");
                            if(CharacterInfo[playerid][i][cb_ItemLock][z] == 0 && CharacterInfo[playerid][i][cb_ItemID][z] == INVALID_OBJECT_ID) 
                                PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 6], "mdl-2002:item_null");
                            if(CharacterInfo[playerid][i][cb_ItemLock][z] == 0 && CharacterInfo[playerid][i][cb_ItemID][z] != INVALID_OBJECT_ID)
                            {
                                format(str, sizeof(str), "%s", GetItemMDL(CharacterInfo[playerid][i][cb_ItemID][z]));
                                PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 6], str);
                            }
                        }
                        else break;
                    }
                }
            }
            return 1; // <-- Thêm dòng này
        }

        case 2:
        {
            new artist[] = {1, 5, 6, 7, 8, 9, 10, 11, 12, 55, 56};
            new Float:weight;
            new Float:exp;
            new Float:progress_size;

            switch(Inventory_Character[playerid])
            {
                case 1:
                {
                    for(i = 0 ; i < sizeof(artist) ; i++) 
                        PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][0][artist[i]]);
                    for(i = 0 ; i < MAX_INTERFACE ; i++)
                    {
                        for(z = 0 ; z < MAX_PLAYER_CB_ITEM ; z++)
                        {
                            if(i == 0)
                            {
                                weight += CharacterInfo[playerid][i][cb_ItemWeight][z];
                            }
                            else
                            {
                                if(z > 6) break;
                                weight += CharacterInfo[playerid][i][cb_ItemWeight][z];
                            }
                        }
                    }

                    if(CharacterInfo[playerid][0][cb_Weight] > 0.0)
                        progress_size = (weight / CharacterInfo[playerid][0][cb_Weight]) * 67.0;
                    else
                        progress_size = 1.0;

                    PlayerTextDrawSetPreviewModel(playerid, GTASA_Inventory[playerid][0][5], PlayerInfo[playerid][pModel]);
                    PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][0][55], progress_size, 7.000);
                    PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][0][5]);
                    PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][0][55]);
                }

                default:
                {
                    for(i = 0 ; i < sizeof(artist) ; i++) 
                        PlayerTextDrawHide(playerid, GTASA_Inventory[playerid][0][artist[i]]);
                }
            }
            return 1; // <-- Thêm dòng này
        }

        case 3:
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    format(str, sizeof(str), "- Su dung\n- {FF0000}Xoa bo\n- Phan tach\n- Ghep lai");
                    if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 21 || CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 22)
                        strcat(str, "\n- Tieu thu nhien lieu\n");
                    if(PlayerInfo[playerid][pAdmin] > 1337) strcat(str, "\n- Admin Panel\n");
                }
            }
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    format(str, sizeof(str), "- Mang len nguoi\n- Go xuong\n- {FF0000}Xoa bo");
                    if(PlayerInfo[playerid][pAdmin] > 1337) strcat(str, "\n- Admin Panel\n");
                }
            }
            if(!isnull(str))
            {
                //CancelSelectTextDraw(playerid);
                Dialog_Show(playerid, DIALOG_INVENTORY_ACTION, DIALOG_STYLE_LIST, "Thao tac", str, "Chon", "Huy");
                SetPVarInt(playerid, "CheckDialogInventory", 1);
            }
            return 1; // <-- Thêm dòng này
        }
        case 4:
        {
            new index = GetPVarInt(playerid, "Inventory_SelectItem");
            new target = GetPVarInt(playerid, "Inventory_SelectTarget");
            new Float:weight;
            new Float:durability;
            if(index == -1) return 1;
            CPTD_InventoryInfo(playerid);
            PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][0]);
            format(str, sizeof(str), "%s", GetItemName(CharacterInfo[playerid][target][cb_ItemID][index]));
            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][1][3], str);
            PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][3]);
            if(GetIDWeapon(CharacterInfo[playerid][target][cb_ItemID][index]))
            {
                format(str, sizeof(str), "%d/%d", CharacterInfo[playerid][target][cb_ItemAmount][index], GetAmmoWeaponLimit(CharacterInfo[playerid][target][cb_ItemID][index]));
                PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][1][6], str);
                PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][6]);
            }
            else
            {
                format(str, sizeof(str), "%d/%d", CharacterInfo[playerid][target][cb_ItemAmount][index], GetAmountItemLimit(CharacterInfo[playerid][target][cb_ItemID][index]));
                PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][1][5], str);
                PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][5]);
                
            }
            format(str, sizeof(str), "%s", GetItemInfo(CharacterInfo[playerid][target][cb_ItemID][index]));
            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][1][7], str);
            PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][7]);

            weight = (CharacterInfo[playerid][target][cb_ItemWeight][index] / GetItemWeight(CharacterInfo[playerid][target][cb_ItemID][index])) * 61.0;
            if(weight <= 1.0) weight = 1.0;
            durability = (float(CharacterInfo[playerid][target][cb_ItemDurability][index]) / 100.0) * 61.0;
            PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][1][1], weight, 7.000); // trong luong
            PlayerTextDrawTextSize(playerid, GTASA_Inventory[playerid][1][2], durability, 7.000); // durability
            PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][1]);
            PlayerTextDrawShow(playerid, GTASA_Inventory[playerid][1][2]);
        }
    }
    return 1;
}

Function: Inventory_SetPost(playerid, post)
{
    new i, z;
    new str[84];
    switch(post)
    {
        case 1:
        {
            for(z = 0 ; z < 42 ; z++)
            {
                if(i == 0)
                {
                    if(CharacterInfo[playerid][0][cb_ItemLock][z] == 1) PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 13], "mdl-2002:item_lock");
                    if(CharacterInfo[playerid][0][cb_ItemLock][z] == 0) PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 13], "mdl-2002:item_null");
                    if(CharacterInfo[playerid][0][cb_ItemLock][z] == 0 && CharacterInfo[playerid][0][cb_ItemID][z] != INVALID_OBJECT_ID)
                    {
                        format(str, sizeof(str), "%s", GetItemMDL(CharacterInfo[playerid][0][cb_ItemID][z]));
                        PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z + 13], str);
                    }
                }
            }
            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][61], "1/2");
        }
        case 2:
        {
            for(z = 42 ; z < MAX_PLAYER_CB_ITEM ; z++)
            {
                if(CharacterInfo[playerid][0][cb_ItemLock][z] == 1) PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z - 29], "mdl-2002:item_lock");
                if(CharacterInfo[playerid][0][cb_ItemLock][z] == 0) PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z - 29], "mdl-2002:item_null");
                if(CharacterInfo[playerid][0][cb_ItemLock][z] == 0 && CharacterInfo[playerid][0][cb_ItemID][z] != INVALID_OBJECT_ID)
                {
                    format(str, sizeof(str), "%s", GetItemMDL(CharacterInfo[playerid][0][cb_ItemID][z]));
                    PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][z - 29], str);
                }
            }
            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][61], "2/2");
        }
        default:
        {
            Guide_ReadPost[playerid]--;
        }
    }
    return 1;
}

Function: InventoryTimer_(playerid)
{
    if(GetPVarInt(playerid, "TimeRefreshInventory") != 0) return SetPVarInt(playerid, "TimeRefreshInventory", GetPVarInt(playerid, "TimeRefreshInventory") - 1);
    KillTimer(Inventory_Timer[playerid]);
    return 1;
}

Function: TakeAmmoDeathPlayer(playerid)
{
    // Sync ammo from equip [1] back to bag [0] before clearing
    for(new i = 0; i < 7; i++)
    {
        if(CharacterInfo[playerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
        {
            new itemid = CharacterInfo[playerid][1][cb_ItemID][i];
            new currentAmmo = CharacterInfo[playerid][1][cb_ItemAmount][i];
            for(new k = 0; k < MAX_PLAYER_CB_ITEM; k++)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][k] == itemid)
                {
                    CharacterInfo[playerid][0][cb_ItemAmount][k] = currentAmmo;
                    CharacterInfo[playerid][0][cb_ItemWeight][k] = GetItemWeight(itemid);
                    break;
                }
            }
        }
        CharacterInfo[playerid][1][cb_ItemID][i] = INVALID_OBJECT_ID;
        CharacterInfo[playerid][1][cb_ItemWeight][i] = 0.0;
        CharacterInfo[playerid][1][cb_ItemDurability][i] = 0;
        CharacterInfo[playerid][1][cb_ItemAmount][i] = 0;
    }
    ResetPlayerWeapons(playerid);
    return 1;
}

stock ClearEquippedWeaponsOnDeath(playerid)
{
    if(GetPVarType(playerid, "IsInArena") || GetPVarInt(playerid, "EventToken") >= 1 || HungerPlayerInfo[playerid][hgInEvent] == 1)
    {
        return 1;
    }
    for(new i = 0; i < 7; i++)
    {
        new itemid = CharacterInfo[playerid][1][cb_ItemID][i];
        if(itemid != INVALID_OBJECT_ID)
        {
            if((itemid >= 23 && itemid <= 35) || (itemid >= 44 && itemid <= 48))
            {
                CharacterInfo[playerid][1][cb_ItemID][i] = INVALID_OBJECT_ID;
                CharacterInfo[playerid][1][cb_ItemWeight][i] = 0.0;
                CharacterInfo[playerid][1][cb_ItemDurability][i] = 0;
                CharacterInfo[playerid][1][cb_ItemAmount][i] = 0;
            }
        }
    }
    return 1;
}

Function: Inventory_SetPlayerWeapons(playerid)
{
	if(HungerPlayerInfo[playerid][hgInEvent] == 1) { return 1;}
    if(GetPVarType(playerid, "IsInArena")) return 1;
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 12; s++)
	{
		if(PlayerInfo[playerid][pGuns][s] > 0 && PlayerInfo[playerid][pAGuns][s] == 0)
		{
			if(zombieevent) GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][s]);
			else
            {
                for(new z = 0 ; z < 7 ; z++)
                {
                    if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][z]) == PlayerInfo[playerid][pGuns][s])
                    {
                        GivePlayerValidWeaponEx(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][z]), CharacterInfo[playerid][1][cb_ItemAmount][z]);
                    }
                }
            }
		}
	}
	return 1;
}

Function: Inventory_SetPlayerWeaponsEx(playerid)
{
	if(GetPVarType(playerid, "IsInArena")) return 1;
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 12; s++)
	{
		if(PlayerInfo[playerid][pGuns][s] > 0)
		{
			if(zombieevent) GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][s]);
			else
            {
                for(new z = 0 ; z < 7 ; z++)
                {
                    if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][z]) == PlayerInfo[playerid][pGuns][s])
                    {
                        GivePlayerValidWeaponEx(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][z]), CharacterInfo[playerid][1][cb_ItemAmount][z]);
                    }
                }
            }
		}
	}
	SetPlayerArmedWeapon(playerid, GetPVarInt(playerid, "LastWeapon"));
    return 1;
}

stock GivePlayerValidWeaponEx(playerid, weaponid, ammo)
{
    SetPlayerAmmo(playerid, weaponid, 0);
    switch(weaponid)
    {
        case 5, 8:
        {
            PlayerInfo[playerid][pGuns][ 1 ] = weaponid;
            GivePlayerWeapon(playerid, weaponid, ammo);
        }
        case 22 .. 24:
        {
            PlayerInfo[playerid][pGuns][ 2 ] = weaponid;
            GivePlayerWeapon(playerid, weaponid, ammo);
        }
        case 25 .. 27:
        {
            PlayerInfo[playerid][pGuns][ 3 ] = weaponid;
            GivePlayerWeapon(playerid, weaponid, ammo);
        }
        case 28, 29, 32:
        {
            PlayerInfo[playerid][pGuns][ 4 ] = weaponid;
            GivePlayerWeapon(playerid, weaponid, ammo);
        }
        case 30 .. 31:
        {
            PlayerInfo[playerid][pGuns][ 5 ] = weaponid;
            GivePlayerWeapon(playerid, weaponid, ammo);
        }
        case 33 .. 34:
        {
            PlayerInfo[playerid][pGuns][ 6 ] = weaponid;
            GivePlayerWeapon(playerid, weaponid, ammo);
        }
    }
    return 1;
}

stock GivePlayerEA(playerid, amount)
{
    PlayerData[playerid][pc_EA] += amount;
    return 1;
}

stock GivePlayerGP(playerid, amount)
{
    PlayerData[playerid][pc_GP] += amount;
    return 1;
}

stock SetPlayerItem(playerid, id, amount, &succes)
{
    // Kiểm tra tính hợp lệ cơ bản của vật phẩm
    if (id <= 0 || amount <= 0) 
    {
        // Có thể thêm log hoặc thông báo lỗi nếu cần
        return 0;
    }
    
    new j, k, slot = -1, stack = 0;
    new Float:new_weight;
    
    // 1. --- KIỂM TRA CÂN NẶNG TỔNG VÀ TÌM SLOT MỚI ---
    // (Lấy logic từ phần 2 của GivePlayerItem)
    
    // Tính tổng trọng lượng hiện tại (Logic Cân nặng Cố định theo Slot)
    new Float:Weight = 0.0;
    
    // Tính trọng lượng túi đồ chính (Index 0)
    for (j = 0; j < MAX_PLAYER_CB_ITEM; j++)
    {
        if (CharacterInfo[playerid][0][cb_ItemID][j] > 0) 
        {
            // Cộng CÂN NẶNG CỐ ĐỊNH CỦA SLOT
            Weight += CharacterInfo[playerid][0][cb_ItemWeight][j];
        }
    }
    
    // Tính trọng lượng túi đồ phụ/đặc biệt (Index > 0)
    for (j = 1; j < MAX_INTERFACE; j++) 
    {
        // Duyệt qua 7 slot đầu tiên
        for (k = 0; k <= 6; k++) 
        {
            if (CharacterInfo[playerid][j][cb_ItemID][k] > 0)
            {
                Weight += CharacterInfo[playerid][j][cb_ItemWeight][k];
            }
        }
    }
    
    // Lấy cân nặng cố định của Slot mới
    new_weight = GetItemWeight(id); 
    
    // Kiểm tra quá tải: Tổng trọng lượng (hiện tại + slot mới) > giới hạn
    if (Weight + new_weight > CharacterInfo[playerid][0][cb_Weight])
    {
        return SendClientMessageEx(playerid, COLOR_LIGHTRED, "[*] Khong the them vat pham vi da qua gioi han can nang.");
    }
    
    // Tìm Slot trống trong túi đồ chính [0]
    // Sử dụng Inventory_CountSlot (giả định hàm này tìm và gán 'slot' trống)
    Inventory_CountSlot(playerid, stack, slot); 

    if (slot == -1) 
    {
        return SendClientMessageEx(playerid, COLOR_LIGHTRED, "[*] Khong con slot trong de them vat pham.");
    }
    
    // 2. --- THIẾT LẬP VẬT PHẨM VÀO SLOT MỚI ---
    
    // Thiết lập vào slot trống
    CharacterInfo[playerid][0][cb_ItemID][slot] = id;
    CharacterInfo[playerid][0][cb_ItemAmount][slot] = amount;
    
    // Gán cân nặng cố định cho Slot mới
    CharacterInfo[playerid][0][cb_ItemWeight][slot] = new_weight; 
    
    // Gán độ bền mặc định (hoặc dùng hàm GetItemDurability)
    CharacterInfo[playerid][0][cb_ItemDurability][slot] = 100;

    succes = 1;
    
    // Thêm thông báo nếu cần (ví dụ: SetPlayerItem(id, 1, 1) -> nhận 1 ID)
    // SendClientMessageEx(playerid, COLOR_GREEN, "[*] Ban da nhan duoc vat pham moi.");
    
    return 1;
}

stock GivePlayerItem(playerid, id, amount)
{ 
    new i, j, k, slot = -1, stack = 0;
    new Float:new_weight;
    
    // 1. --- LOGIC CỘNG DỒN (STACKING) VÀ CẬP NHẬT 'amount' ---
    // Duyệt qua các slot để cộng dồn vào các stack hiện có
    for (i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        // Kiểm tra cùng ItemID và slot chưa đầy
        if (CharacterInfo[playerid][0][cb_ItemID][i] == id)
        {
            new current_amount = CharacterInfo[playerid][0][cb_ItemAmount][i];
            new limit = GetAmountItemLimit(id); // Lấy giới hạn stack của vật phẩm
            
            if (current_amount < limit)
            {
                new space = limit - current_amount;
                new amount_to_add = min(amount, space); // Số lượng có thể thêm vào slot này
                
                CharacterInfo[playerid][0][cb_ItemAmount][i] += amount_to_add;
                amount -= amount_to_add; // Cập nhật số lượng còn lại cần thêm
                
                // Nếu 'amount' đã về 0, nghĩa là đã thêm hết, kết thúc hàm
                if (amount == 0) return 1; 
            }
        }
    }
    
    // 2. --- KIỂM TRA CÂN NẶNG TỔNG VÀ TÌM SLOT MỚI ---
    if (amount > 0)
    {
        // Tính tổng trọng lượng hiện tại (Logic Cân nặng Cố định theo Slot)
        new Float:Weight = 0.0;
        
        // Tính trọng lượng túi đồ chính (Index 0)
        for (j = 0; j < MAX_PLAYER_CB_ITEM; j++)
        {
            if (CharacterInfo[playerid][0][cb_ItemID][j] > 0) 
            {
                // Cộng CÂN NẶNG CỐ ĐỊNH CỦA SLOT
                Weight += CharacterInfo[playerid][0][cb_ItemWeight][j];
            }
        }
        
        // Tính trọng lượng túi đồ phụ/đặc biệt (Index > 0)
        for (j = 1; j < MAX_INTERFACE; j++) 
        {
            // Duyệt qua 7 slot đầu tiên (dựa trên logic 'if(z > 6) break;' trong code gốc)
            for (k = 0; k <= 6; k++) 
            {
                if (CharacterInfo[playerid][j][cb_ItemID][k] > 0)
                {
                    Weight += CharacterInfo[playerid][j][cb_ItemWeight][k];
                }
            }
        }
        
        // Lấy cân nặng cố định của Slot mới
        new_weight = GetItemWeight(id); 
        
        // Kiểm tra quá tải: Tổng trọng lượng (hiện tại + slot mới) > giới hạn
        if (Weight + new_weight > CharacterInfo[playerid][0][cb_Weight])
        {
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "[*] Khong the them vat pham vi da qua gioi han can nang.");
            return 0;
        }
        
        // Tìm Slot trống trong túi đồ chính [0]
        Inventory_CountSlot(playerid, stack, slot); 

        if (slot == -1) 
        {
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "[*] Khong con slot trong de them vat pham.");
            return 0;
        }
        
        // 3. --- THÊM VẬT PHẨM VÀO SLOT MỚI ---
        
        // Thêm vào slot trống
        CharacterInfo[playerid][0][cb_ItemID][slot] = id;
        CharacterInfo[playerid][0][cb_ItemAmount][slot] = amount;
        
        // Gán cân nặng cố định cho Slot mới
        CharacterInfo[playerid][0][cb_ItemWeight][slot] = new_weight; 
        
        // Giả định độ bền mặc định là 100 (hoặc bạn có thể sử dụng hàm GetItemDurability)
        CharacterInfo[playerid][0][cb_ItemDurability][slot] = 100;
        
        // Notification
        new str[128];
        format(str, sizeof(str), "[{FFB561}BALO{FFFFFF}]: Ban nhan duoc {F5CB42}%s {FFFFFF}(x%d).", Inventory_ListItems[id - 1], amount);
        SendClientMessageEx(playerid, COLOR_WHITE, str);
        
        return 1;
    }

    return 0;
}

stock RemovePlayerItem(playerid, index)
{
    CharacterInfo[playerid][0][cb_ItemID][index] = INVALID_OBJECT_ID;
    CharacterInfo[playerid][0][cb_ItemWeight][index] = 0.0;
    CharacterInfo[playerid][0][cb_ItemDurability][index] = 0;
    CharacterInfo[playerid][0][cb_ItemAmount][index] = 0;
    return 1;
}

stock Inventory_AddItem(source, targetid = -1, id, stack)
{
    if(id < 1) return 1;
    new slot = -1;
    new amount;
    new Float:weight;
    new i, z;
    for(i = 0 ; i < MAX_INTERFACE ; i++)
    {
        for(z = 0 ; z < MAX_PLAYER_CB_ITEM ; z++)
        {
            if(i == 0)
            {
                if(CharacterInfo[source][i][cb_ItemLock][z] == 0 && CharacterInfo[source][i][cb_ItemID][z] !=  INVALID_OBJECT_ID)
                {
                    weight += CharacterInfo[source][i][cb_ItemWeight][z];
                }
            }
            else
            {
                if(z > 6) break;
                if(CharacterInfo[source][i][cb_ItemLock][z] == 0 && CharacterInfo[source][i][cb_ItemID][z] != INVALID_OBJECT_ID)
                {
                    weight += CharacterInfo[source][i][cb_ItemWeight][z];
                }
            }
        }
        
    }
    Inventory_CountSlot(source, stack, slot);
    if(slot != -1)
    {

        if(CharacterInfo[source][stack][cb_ItemWeight][slot] + GetItemWeight(id) + weight > CharacterInfo[source][0][cb_Weight])
        {
            SendClientMessageEx(targetid, COLOR_LIGHTRED, "Khong du cho trong trong kho do de chua them.");
            return 1;
        }

        CharacterInfo[source][stack][cb_ItemID][slot] = id;
        CharacterInfo[source][stack][cb_ItemWeight][slot] = GetItemWeight(id);
        CharacterInfo[source][stack][cb_ItemDurability][slot] = 100;

        if(GetIDWeapon(id))
        {
            CharacterInfo[source][stack][cb_ItemAmount][slot] = GetAmmoWeaponLimit(id);
            amount = CharacterInfo[source][stack][cb_ItemAmount][slot];
        }
        else
        {
            CharacterInfo[source][stack][cb_ItemAmount][slot] = GetAmountItemLimit(id);
            amount = CharacterInfo[source][stack][cb_ItemAmount][slot];
        }

        if(targetid == -1)
        {
            new str[256];
            format(str, sizeof(str), "{AA3333}AdmWarning{FFFF00}: %s da nhan duoc vat pham %s (%d) tu System.", GetPlayerNameEx(source), GetItemName(id), amount);
            ABroadCast(COLOR_YELLOW, str, 2);
            format(str, sizeof(str), "** Ban da nhan duoc vat pham %s (%d) tu System.", GetItemName(id), amount);
            SendClientMessage(source, COLOR_YELLOW, str);
            if(Inventory_Show[source] != 0) 
            {

                Inventory_SetPost(source, Guide_ReadPost[source]);
            }
        }
        if(targetid != -1)
        {
            new str[256];
            format(str, sizeof(str), "{AA3333}AdmWarning{FFFF00}: %s da nhan duoc vat pham %s (%d) tu %s.", GetPlayerNameEx(source), GetItemName(id), amount, GetPlayerNameEx(targetid));
            ABroadCast(COLOR_YELLOW, str, 2);
            format(str, sizeof(str), "** Ban da nhan duoc vat pham %s (%d) tu %s.", GetItemName(id), amount, GetPlayerNameEx(targetid));
            SendClientMessage(source, COLOR_YELLOW, str);
            if(Inventory_Show[source] != 0) 
            {
                Inventory_SetPost(source, Guide_ReadPost[source]);
            }
        }
    }
    else
    {
        if(targetid != -1)
        {
            SendClientMessageEx(targetid, COLOR_LIGHTRED, "Khong du slot de them vat pham!");
        }
    }
    return 1;
}

stock Inventory_CountSlot(playerid, stack, &slot)
{
    for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
    {
        if(CharacterInfo[playerid][stack][cb_ItemLock][i] == 0 && CharacterInfo[playerid][stack][cb_ItemID][i] == INVALID_OBJECT_ID)
        {
            slot = i;
            return 1;
        }
    }
    slot = -1;
    return -1;
}

stock GetItemInfo(item)
{
    new string[126];
    switch(item)
    {
        case 1: string = "Vat pham may anh dung de chup hinh~n~thuong duoc cac phong vien~n~SANews ua chuong.";
        case 2: string = "Khau 6 nong voi suc cong pha khung khiep co the tao nen nhung con dia chan.~n~Chi co BQT moi duoc phep su dung vat pham nay!";
        case 3 .. 7: string = "Nguyen lieu che tao.";
        case 8: string = "May dung de khai thac khoang san co muc tieu thu nhien~n~lieu cao so voi may khai thac VIP.";
        case 9: string = "May khai thac VIP voi muc tieu thu nhien lieu it hon~n~so voi may thuong.";
        case 10: string = "Dung de chuyen doi tu GP sang Coin.";
        case 11: string = "Dung cu hoi mau.";
        case 12: string = "Vat pham giup tang suc khoe hieu suat lam viec.";
        case 13: string = "Gia tang them 1 o chua trong tui do cua ban.";
        case 14 .. 17: string = "Bonus theo ti le duoc dinh san.";
        case 18: string = "Vat pham mo ra trang phuc dac biet tu su kien~n~Vietnam Capsule mua 1.";
        case 19: string = "Vat pham mo ra xe tuy chon tu su kien~n~Vietnam Capsule mua 1.";
        case 20: string = "Vat pham mo ra toy tuy chon tu su kien~n~Vietnam Capsule mua 1.";
        case 21: string = "Can xang voi dung tich 100 lit.";
        case 22: string = "Can xang voi dung tich 200 lit.";
        case 23 .. 35: string = "Chua co mo ta ve vat pham nay.";
        case 36: string = "Nguyen lieu da tho.";
        case 37 .. 39: string = "Hai san thu hoach tu vung bien SF/LS.";
        case 40: string = "Ruou va thuoc la thu hoach tu job alcohol, co the ban~n~lai cho nha hang.";
        case 41: string = "Hop dan tich hop nhieu loai dan co the nap vao cac vu khi khac nhau.";
        case 42: string = "Combo GFC - Bap nuoc an uong tien loi.";
        case 43: string = "Ban do kho bau, dung de tim kiem kho bau tren toan bo ban do.";
        case 44 .. 48: string = "Vu khi LAW Faction";
        case 49: string = "Thanh kiem voi sat thuong lon";
        case 50: string = "Gay bong chay cua cac tuyen thu";
    }
    return string;
}

stock GetAmountItemLimit(item)
{
    switch(item)
    {
        case 3 .. 7: return 250;
        case 10 .. 20: return 1;
        case 21: return 100;
        case 22: return 200;
        case 36: return 250;
        case 37 .. 39: return 60;
        case 40: return 60;
        case 41: return 1200;
        case 42: return 1;
        case 43: return 1;
        case 51: return 50;  // Can sa nguyen chat
        case 52: return 100; // Tui zip can sa
        case 53: return 5;   // Picklock
    }
    return 0;
}

stock GetAmmoWeaponLimit(item)
{
    switch(item)
    {
        case 1: return 1; // camera
        case 2: return 999999; // minigun
        case 8 .. 9: return 100; // flame
        case 23 .. 25: return 29;
        case 26 .. 28: return 60;
        case 29 .. 30: return 120;
        case 31 .. 32: return 199;
        case 33: return 120;
        case 34 .. 35: return 60;
        case 44 .. 45: return 199; // m4 va ak law
        case 46 .. 47: return 29; // deagle va 9mm law
        case 48: return 120; // mp5 law
        case 49: return 1;
        case 50: return 1;
    }
    return 0;
}

stock GetIDWeapon(item)
{
    switch(item)
    {
        case 1: return 43;
        case 2: return 38;
        case 8: return -1000; // máy thường
        case 9: return -1001; // máy vip
        case 23: return 22;
        case 24: return 23;
        case 25: return 24;
        case 26: return 25;
        case 27: return 26;
        case 28: return 27;
        case 29: return 28; // uzi
        case 30: return 29; // mp5
        case 31: return 30;
        case 32: return 31;
        case 33: return 32;
        case 34: return 33;
        case 35: return 34;
        case 44: return 31;
        case 45: return 30;
        case 46: return 24;
        case 47: return 22;
        case 48: return 29;
        case 49: return 8;
        case 50: return 5;
    }
    return 0;
}

stock GetWeaponType(item)
{
    switch(item)
    {
        case 23 .. 25: return 1; // pistol
        case 26 .. 28: return 2; // shotgun, sawn-off, spas-12
        case 29 .. 30: return 3; // mp5, uzi
        case 31 .. 32: return 4; // ak, m4
        case 33: return 3; // tec9
        case 34 .. 35: return 5; // rifle - sniper
        case 44 .. 45: return 4; // m4, ak law
        case 46 .. 47: return 1; // deagle, 9mm law
        case 48: return 3; // mp5 law
        case 49, 50: return 6;
    }
    return 0;
}

stock GetItemMDL(item)
{
    new string[85];
    switch(item)
    {
        case 1: string = "mdl-2002:item_camera";
        case 2: string = "mdl-2002:item_minigun";
        case 3: string = "mdl-2002:item_kssilver";
        case 4: string = "mdl-2002:item_ksniken";
        case 5: string = "mdl-2002:item_ksgold";
        case 6: string = "mdl-2002:item_kscu";
        case 7: string = "mdl-2002:item_kscrom";
        case 8: string = "mdl-2002:item_flamednormal";
        case 9: string = "mdl-2002:item_flamedvip";
        case 10: string = "mdl-2002:item_coinexchange";
        case 11: string = "mdl-2002:item_medkit";
        case 12: string = "mdl-2002:item_gatacetamol";
        case 13: string = "mdl-2002:item_slotcard";
        case 14: string = "mdl-2002:item_gp_bonus_30";
        case 15: string = "mdl-2002:item_exp_bonus_10";
        case 16: string = "mdl-2002:item_exp_bonus_20";
        case 17: string = "mdl-2002:item_exp_bonus_30";
        case 18: string = "mdl-2002:item_box";
        case 19: string = "mdl-2002:item_box";
        case 20: string = "mdl-2002:item_box";
        case 21: string = "mdl-2002:item_jerrycan";
        case 22: string = "mdl-2002:item_jerrycan";
        case 23: string = "mdl-2002:item_sdpistol";
        case 24: string = "mdl-2002:item_colt45";
        case 25: string = "mdl-2002:item_deagle";
        case 26: string = "mdl-2002:item_shotgun";
        case 27: string = "mdl-2002:item_sawnoff";
        case 28: string = "mdl-2002:item_spas12";
        case 29: string = "mdl-2002:item_uzi";
        case 30: string = "mdl-2002:item_mp5";
        case 31: string = "mdl-2002:item_ak";
        case 32: string = "mdl-2002:item_m4";
        case 33: string = "mdl-2002:item_tec9";
        case 34: string = "mdl-2002:item_rifle";
        case 35: string = "mdl-2002:item_sniper";
        case 36: string = "mdl-2002:item_datho";
        case 37: string = "mdl-2002:item_cathu";
        case 38: string = "mdl-2002:item_cangu";
        case 39: string = "mdl-2002:item_canoc";
        case 40: string = "mdl-2002:item_ruouthuocla";
        case 41: string = "mdl-2002:item_ammo-box";
        case 42: string = "mdl-2002:item_combo-gfc";
        case 43: string = "mdl-2006:bandokhobau";
        case 44: string = "mdl-2002:item_m4law";
        case 45: string = "mdl-2002:item_aklaw";
        case 46: string = "mdl-2002:item_deaglelaw";
        case 47: string = "mdl-2002:item_9mmlaw";
        case 48: string = "mdl-2002:item_mp5law";
        case 49: string = "mdl-2002:item_swordkatana";
        case 50: string = "mdl-2002:item_baseballbat";
        case 51: string = "mdl-2002:item_kssilver"; // TODO: thay bang texture can sa thoi
        case 52: string = "mdl-2002:item_medkit";   // TODO: thay bang texture tui zip
    }
    return string;
}

stock GetItemName(item)
{
    new string[85];
    switch(item)
    {
        case 1:
        {
            string = "Camera";
        }
        case 2:
        {
            string = "Minigun";
        }
        case 3:
        {
            string = "Khoang san Bac";
        }
        case 4:
        {
            string = "Khoang san Niken";
        }
        case 5:
        {
            string = "Khoang san Vang";
        }
        case 6:
        {
            string = "Khoang san CU (dong)";
        }
        case 7:
        {
            string = "Khoang san Crom";
        }
        case 8:
        {
            string = "May khai thac";
        }
        case 9:
        {
            string = "May khai thac VIP";
        }
        case 10:
        {
            string = "Coin Exchange (GP -> Coin)";
        }
        case 11:
        {
            string = "Medkit";
        }
        case 12:
        {
            string = "Gatacetamol (thuoc tang hieu suat lam viec)";
        }
        case 13:
        {
            string = "Phieu mo rong slot tui do";
        }
        case 14:
        {
            string = "GP Bonus 30%";
        }
        case 15:
        {
            string = "EXP Bonus 10%";
        }
        case 16:
        {
            string = "EXP Bonus 20%";
        }
        case 17:
        {
            string = "EXP Bonus 30%";
        }
        case 18:
        {
            string = "Costume Box (Vietnam Capsule Season 1)";
        }
        case 19:
        {
            string = "Vehicle Box (Vietnam Capsule Season 1)";
        }
        case 20:
        {
            string = "Toy Box (Vietnam Capsule Season 1)";
        }
        case 21:
        {
            string = "Jerry can (dung tich 100)";
        }
        case 22:
        {
            string = "Jerry can (dung tich 200)";
        }
        case 23:
        {
            string = "SD-Pistol";
        }
        case 24:
        {
            string = "Colt-9mm";
        }
        case 25:
        {
            string = "Deagle";
        }
        case 26:
        {
            string = "Shotgun";
        }
        case 27:
        {
            string = "Sawn-Off";
        }
        case 28:
        {
            string = "Spas-12";
        }
        case 29:
        {
            string = "Uzi";
        }
        case 30:
        {
            string = "MP5";
        }
        case 31:
        {
            string = "AK";
        }
        case 32:
        {
            string = "M4";
        }
        case 33:
        {
            string = "Tec9";
        }
        case 34:
        {
            string = "Rifle";
        }
        case 35:
        {
            string = "Sniper";
        }
        case 36:
        {
            string = "Da tho";
        }
        case 37:
        {
            string = "Ca thu";
        }
        case 38:
        {
            string = "Ca ngu";
        }
        case 39:
        {
            string = "Ca noc";
        }
        case 40:
        {
            string = "Ruou va thuoc la (job nguoi giao ruou)";
        }
        case 41:
        {
            string = "Hop dan (Ammo Box Transformer)";
        }
        case 42:
        {
            string = "Combo GFC (Ga Ran - KTC - Nuoc)";
        }
        case 43:
        {
            string = "Ban do kho bau";
        }
        case 44:
        {
            string = "M4 LAW";
        }
        case 45:
        {
            string = "AK LAW";
        }
        case 46:
        {
            string = "Deagle LAW";
        }
        case 47:
        {
            string = "9mm LAW";
        }
        case 48:
        {
            string = "MP5 LAW";
        }
        case 49:
        {
            string = "Sword Katana";
        }
        case 50:
        {
            string = "Gay Bong Chay";
        }
        case 51:
        {
            string = "Can sa nguyen chat";
        }
        case 52:
        {
            string = "Tui zip can sa";
        }
    }
    return string;
}

stock Inventory_SaveData(playerid)
{
    new i, z;
    new str[30];
    new sqlid = PlayerInfo[playerid][pId];
    if(sqlid <= 0) return 0;

    Inventory_SavePlayerFloat(sqlid, "Weight", CharacterInfo[playerid][0][cb_Weight]);
    Inventory_SavePlayerFloat(sqlid, "Weight2", CharacterInfo[playerid][1][cb_Weight]);
    for(i = 0 ; i < MAX_INTERFACE ; i++)
    {
        for(z = 0 ; z < MAX_PLAYER_CB_ITEM ; z++)
        {
            if(i == 0)
            {
                format(str, sizeof(str), "ItemLock%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemLock][z]);
                format(str, sizeof(str), "ItemID%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemID][z]);
                format(str, sizeof(str), "ItemWeight%d", z);
                Inventory_SavePlayerFloat(sqlid, str, CharacterInfo[playerid][i][cb_ItemWeight][z]);
                format(str, sizeof(str), "ItemDurability%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemDurability][z]);
                format(str, sizeof(str), "ItemAmount%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemAmount][z]);
            }
            else
            {
                if(z > 6) break;
                format(str, sizeof(str), "Item2Lock%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemLock][z]);
                format(str, sizeof(str), "Item2ID%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemID][z]);
                format(str, sizeof(str), "Item2Weight%d", z);
                Inventory_SavePlayerFloat(sqlid, str, CharacterInfo[playerid][i][cb_ItemWeight][z]);
                format(str, sizeof(str), "Item2Durability%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemDurability][z]);
                format(str, sizeof(str), "Item2Amount%d", z);
                Inventory_SavePlayerInt(sqlid, str, CharacterInfo[playerid][i][cb_ItemAmount][z]);
            }
        }
    }
    return 1;
}

stock Inventory_SavePlayerInt(sqlId, const fieldname[], arg)
{
    new string[128];
    mysql_format(MainPipeline, string, sizeof(string), "UPDATE `inventory` SET `%s` = %d WHERE `SQLId` = %d", fieldname, arg, sqlId);
    mysql_tquery(MainPipeline, string);
    return 1;
}

stock Inventory_SavePlayerFloat(sqlId, const fieldname[], Float:arg)
{
    new string[128];
    mysql_format(MainPipeline, string, sizeof(string), "UPDATE `inventory` SET `%s` = '%.2f' WHERE `SQLId` = %d", fieldname, arg, sqlId);
    mysql_tquery(MainPipeline, string);
    return 1;
}

Function: Inventory_CallData(playerid)
{
    new string[128];
    mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `inventory` WHERE `SQLId` = %d", GetPlayerSQLId(playerid));
    mysql_tquery(MainPipeline, string, "Inventory_GetData", "i", playerid);
    return 1;
}

Function: Inventory_GetData(playerid)
{
    new rows;
    new i = 0;
    new z, g;
    new str[30];
    cache_get_row_count(rows);
    if(rows > 0)
    {
        while(i < rows)
        {
            cache_get_value_name_float(i, "Weight", CharacterInfo[playerid][0][cb_Weight]);
            cache_get_value_name_float(i, "Weight2", CharacterInfo[playerid][1][cb_Weight]);
            
            for(g = 0 ; g < MAX_INTERFACE ; g++)
            {
                for(z = 0 ; z < MAX_PLAYER_CB_ITEM ; z++)
                {
                    if(g == 0)
                    {
                        format(str, sizeof(str), "ItemLock%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemLock][z]);
                        format(str, sizeof(str), "ItemID%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemID][z]);
                        format(str, sizeof(str), "ItemWeight%d", z);
                        cache_get_value_name_float(i, str, CharacterInfo[playerid][g][cb_ItemWeight][z]);
                        format(str, sizeof(str), "ItemDurability%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemDurability][z]);
                        format(str, sizeof(str), "ItemAmount%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemAmount][z]);
                    }
                    else
                    {
                        if(z > 6) break;
                        format(str, sizeof(str), "Item2Lock%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemLock][z]);
                        format(str, sizeof(str), "Item2ID%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemID][z]);
                        format(str, sizeof(str), "Item2Weight%d", z);
                        cache_get_value_name_float(i, str, CharacterInfo[playerid][g][cb_ItemWeight][z]);
                        
                        format(str, sizeof(str), "Item2Durability%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemDurability][z]);
                        
                        format(str, sizeof(str), "Item2Amount%d", z);
                        cache_get_value_name_int(i, str, CharacterInfo[playerid][g][cb_ItemAmount][z]);
                    }
                }
            }
            i++;
        }
    }
    else
    {
        new string[128];
        mysql_format(MainPipeline, string, sizeof(string), "INSERT IGNORE INTO `inventory` (`SQLId`) VALUES (%d)", GetPlayerSQLId(playerid));
        mysql_tquery(MainPipeline, string);

        CharacterInfo[playerid][0][cb_Weight] = 60.0;
        CharacterInfo[playerid][1][cb_Weight] = CharacterInfo[playerid][0][cb_Weight] / 2;
        for(i = 0 ; i < MAX_INTERFACE ; i++)
        {
            for(z = 0 ; z < MAX_PLAYER_CB_ITEM ; z++)
            {
                if(i == 0)
                {
                    if(z < 13) CharacterInfo[playerid][i][cb_ItemLock][z] = 0;
                    if(z >= 13) CharacterInfo[playerid][i][cb_ItemLock][z] = 1;
                    CharacterInfo[playerid][i][cb_ItemID][z] = INVALID_OBJECT_ID;
                    CharacterInfo[playerid][i][cb_ItemWeight][z] = 0.0;
                    CharacterInfo[playerid][i][cb_ItemDurability][z] = 0;
                    CharacterInfo[playerid][i][cb_ItemAmount][z] = 0;
                }
                else
                {
                    if(z > 6) break;
                    CharacterInfo[playerid][i][cb_ItemLock][z] = 0;
                    CharacterInfo[playerid][i][cb_ItemID][z] = INVALID_OBJECT_ID;
                    CharacterInfo[playerid][i][cb_ItemWeight][z] = 0.0;
                    CharacterInfo[playerid][i][cb_ItemDurability][z] = 0;
                    CharacterInfo[playerid][i][cb_ItemAmount][z] = 0;
                }
            }
        }

        Inventory_SaveData(playerid);
    }
}

Dialog:DIALOG_INVMOBILE_CHOICE(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strcmp(inputtext, "Tui do custom (PC - TextDraw)", true) == 0)
        {
            Inventory_Action(playerid, 0);
        }
        else if(strcmp(inputtext, "Tui do mobile (Dialog)", true) == 0)
        {
            return callcmd::balomobile(playerid, "");
        }
        else if(strcmp(inputtext, "Danh sach vat pham so huu", true) == 0)
        {
            new szStr[4096];
            format(szStr, sizeof(szStr), "Ten vat pham\tSo luong\tSo KG\tDo ben\n");
            for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
            {
                if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
                    format(szStr, sizeof(szStr), "%sDang bi khoa\t\t\t\n", szStr);
                else if(CharacterInfo[playerid][0][cb_ItemID][i] == INVALID_OBJECT_ID)
                    format(szStr, sizeof(szStr), "%s--/--/--\t\t\t\n", szStr);
                else
                {
                    format(szStr, sizeof(szStr), "%s%s\t%d\t%.2f\t%d\n", szStr, Inventory_ListItems[CharacterInfo[playerid][0][cb_ItemID][i] - 1], CharacterInfo[playerid][0][cb_ItemAmount][i], CharacterInfo[playerid][0][cb_ItemWeight][i], CharacterInfo[playerid][0][cb_ItemDurability][i]);
                }
            }
            Dialog_Show(playerid, DIALOG_LIST_ITEMINV, DIALOG_STYLE_TABLIST_HEADERS, "Vat pham trong tui do", szStr, "Chon", "Dong tui");
        }
        else if(strcmp(inputtext, "Danh sach trang bi dang mang", true) == 0)
        {
            new szStr[4096];
            format(szStr, sizeof(szStr), "Ten vat pham\tSo luong\tSo KG\tDo ben\n");
            for(new i = 0 ; i < 7 ; i++)
            {
                if(CharacterInfo[playerid][1][cb_ItemLock][i] == 1)
                    format(szStr, sizeof(szStr), "%sDang bi khoa\t\t\t\n", szStr);
                else if(CharacterInfo[playerid][1][cb_ItemID][i] == INVALID_OBJECT_ID)
                    format(szStr, sizeof(szStr), "%s--/--/--\t\t\t\n", szStr);
                else
                {
                    format(szStr, sizeof(szStr), "%s%s\t%d\t%.2f\t%d\n", szStr, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1], CharacterInfo[playerid][1][cb_ItemAmount][i], CharacterInfo[playerid][1][cb_ItemWeight][i], CharacterInfo[playerid][1][cb_ItemDurability][i]);
                }
            }
            Dialog_Show(playerid, DIALOG_LIST_ITEMINV2, DIALOG_STYLE_TABLIST_HEADERS, "Vat pham trong tui do", szStr, "Chon", "Dong tui");
        }
    }
    else
    {
        return 1;
    }
    return 1;
}

Dialog:DIALOG_LIST_ITEMINV(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[256];

        SetPVarInt(playerid, "Inventory_SelectItem", listitem);
        SetPVarInt(playerid, "Inventory_SelectTarget", 0);

        if(GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][listitem]))
        {
            format(str, sizeof(str), "- Su dung\n- {FF0000}Xoa bo\n"); // <-- vũ khí thì trang bị và xoá bỏ
        }
        else
        {
            format(str, sizeof(str), "- Su dung\n- {FF0000}Xoa bo\n"); // <-- vật phẩm bình thường thì sử dụng và xoá bỏ
        }
        
        Dialog_Show(playerid, DIALOG_INVENTORY_AMB, DIALOG_STYLE_LIST, "Inventory Action - Mobile", str, "Chon", "Huy");
    }
    else
    {
        Inventory_Action(playerid, -1);
    }
    return 1;
}

Dialog:DIALOG_LIST_ITEMINV2(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[256];

        SetPVarInt(playerid, "Inventory_SelectItem", listitem);
        SetPVarInt(playerid, "Inventory_SelectTarget", 1);

        if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][listitem]))
        {
            format(str, sizeof(str), "- Mang len nguoi\n- {FF0000}Go xuong\n"); //
        }
        else
        {
            Inventory_Action(playerid, -1);
        }
        
        Dialog_Show(playerid, DIALOG_INVENTORY_AMB, DIALOG_STYLE_LIST, "Inventory Action - Mobile", str, "Chon", "Huy");
    }
    else
    {
        Inventory_Action(playerid, -1);
    }
    return 1;
}

Dialog:DIALOG_INVENTORY_AMB(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        // Đã loại bỏ biến z không còn sử dụng do xóa vòng lặp TextDraw
        new str[356], i;
        if(strcmp(inputtext, "- Su dung", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    if(GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]))
                    {
                        new weaponid = GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                        new weapontype = GetWeaponType(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                        for(i = 0 ; i < 7 ; i++)
                        {
                            if(CharacterInfo[playerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
                            {
                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == weaponid)
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                    return 1;
                                }
                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == -1001 && weaponid == -1000 || GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == -1000 && weaponid == -1001)
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                    return 1;
                                }
                                if(GetWeaponType(CharacterInfo[playerid][1][cb_ItemID][i]) == weapontype)
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                    return 1;
                                }
                            }
                        }
                        for(i = 0 ; i < 7 ; i++)
                        {
                            if(CharacterInfo[playerid][1][cb_ItemLock][i] == 0 && CharacterInfo[playerid][1][cb_ItemID][i] == INVALID_OBJECT_ID)
                            {
                                CharacterInfo[playerid][1][cb_ItemID][i] = CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")];
                                CharacterInfo[playerid][1][cb_ItemWeight][i] = CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")];
                                CharacterInfo[playerid][1][cb_ItemDurability][i] = CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")];
                                CharacterInfo[playerid][1][cb_ItemAmount][i] = CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];

                                CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                                CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                                CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                                // Đã xóa PlayerTextDrawSetString
                                // Đã xóa Inventory_SetPost
                                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban da mang mot trang bi len nguoi.");

                                // Đã xóa vòng lặp TextDrawDestroy
                                
                                GivePlayerValidWeaponEx(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]), CharacterInfo[playerid][1][cb_ItemAmount][i]);

                                SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                SetPVarInt(playerid, "Inventory_SelectTarget", 0);

                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                        }
                    }
                    else
                    {
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 41) // hop dan
                        {
                            new string[560];
                            format(string, sizeof(string), "Slot\tVu khi\tSo dan\n");
                            for(i = 0 ; i < 7 ; i++)
                            {
                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]))
                                {
                                    if(CharacterInfo[playerid][1][cb_ItemID][i] == 8 || CharacterInfo[playerid][1][cb_ItemID][i] == 9)
                                    {
                                        format(string, sizeof(string), "%s%d\tMay khai thac\t{FF0000}Khong the nap\n", string, i + 1);
                                    }
                                    else
                                    {
                                        if(CharacterInfo[playerid][1][cb_ItemAmount][i] >= GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][i]))
                                            format(string, sizeof(string), "%s%d\t%s\t{2D9410}Da day dan\n", string, i + 1, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1]);
                                        else
                                        {
                                            format(string, sizeof(string), "%s%d\t%s\t%d/%d\n", string, i + 1, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1], CharacterInfo[playerid][1][cb_ItemAmount][i], GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][i]));
                                        }
                                    }
                                }
                                if(CharacterInfo[playerid][1][cb_ItemID][i] == INVALID_OBJECT_ID)
                                    format(string, sizeof(string), "%s%d\t--\t--/--\n", string, i + 1);
                            }
                            return Dialog_Show(playerid, DIALOG_AMMOBOX_WPChoice, DIALOG_STYLE_TABLIST_HEADERS, "Nap dan vu khi", string, "Nap", "Huy");
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 10) // item coin
                        {
                            new string[456];
                            SetPVarInt(playerid, "Exchange_Coin_Request", 1);
                            format(string, sizeof(string), "Ban dang su dung vat pham {FF0000}'CHUYEN DOI GP SANG COIN'{FFFFFF}\n\
                            So GP ban hien dang co: {62FF00}%d{FFFFFF}.\n\n\
                            Bang quy doi:\n\
                            \t1 coin\t1,000 GP\n\
                            \t10 coin\t10,000 GP\n\
                            \t100 coin\t100,000 GP\n\
                            \t1000 coin\t1,000,000 GP\n\n\
                            Hay nhan 'Dong Y' neu nhu ban muon chuyen doi hoac 'Huy' neu khong muon chuyen doi",
                            PlayerData[playerid][pc_GP]);
                            return Dialog_Show(playerid, DG_EXCHANGE_COIN, DIALOG_STYLE_MSGBOX, "Coin Exchange", string, "Dong Y", "Huy");
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 11) // medkit
                        {
                            SetPVarInt(playerid, "usg_ItemIDs", 11);
                            SetPVarInt(playerid, "usg_ItemTimers", 15);
                            ItemGain(playerid, 1);
                            SetPVarInt(playerid, "CheckDialogInventory", 0);
                            return 1;
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 43)
                        {
                            callcmd::closeinv(playerid, "");
                            defer ShowBDKBTimer(playerid);
                            return 1;
                        }
                        new fishmanlist[] = {37, 38, 39};
                        for(i = 0 ; i < sizeof(fishmanlist) ; i++)
                        {
                            if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == fishmanlist[i])
                            {
                                if(IsAtRestaurant(playerid))
                                {
                                    format(str, sizeof(str), "Hay nhap so hai san ban muon ban:\n\n\
                                    (Ban hien dang co {FFB561}%d {FFFFFF}hai san trong kho.)",
                                    CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
                                    Dialog_Show(playerid, DG_PASS_FISH, DIALOG_STYLE_INPUT, "Ban hai san", str, "Chon", "Huy");
                                }
                                else
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban khong o nha hang (Quan an).");
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                }
                            }
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 42)
                        {
                            if(PlayerData[playerid][pc_FoodBar] < 90 || PlayerData[playerid][pc_WaterBar] < 90)
                            {
                                PlayerData[playerid][pc_FoodBar] = 100;
                                PlayerData[playerid][pc_WaterBar] = 100;
                                Inventory_Update_Hunger(playerid);
                                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban da tieu thu mot luong lon thuc an tu combo GFC.");
                            }
                            else SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Nhan vat hien tai rat no, khong the tiep tuc an.");
                            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]--;
                            if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] <= 0)
                                RemovePlayerItem(playerid, GetPVarInt(playerid, "Inventory_SelectItem"));
                            SetPVarInt(playerid, "CheckDialogInventory", 0);
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 21 || CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 22)
                        {
                            new selected_slot = GetPVarInt(playerid, "Inventory_SelectItem");
                            new
                                iBusinessID,
                                iPumpID;
                            
                            // Tìm trạm xăng gần nhất
                            GetClosestGasPump(playerid, iBusinessID, iPumpID);

                            // --- KIỂM TRA ĐIỀU KIỆN ---
                            if(zombieevent)
                            {
                                SendClientMessageEx(playerid, -1, "Ban khong the su dung lenh do xang khi Event Zombie dang dien ra!");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                            if (iBusinessID == INVALID_BUSINESS_ID)
                            {
                                SendClientMessageEx(playerid, COLOR_RED, "Ban khong dung tai tram xang.");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                            if (Businesses[iBusinessID][GasPumpGallons][iPumpID] <= 0.0)
                            {
                                SendClientMessageEx(playerid, COLOR_RED, "Tram nay hien da het xang.");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }

                            new item_id = CharacterInfo[playerid][0][cb_ItemID][selected_slot];
                            new current_amount = CharacterInfo[playerid][0][cb_ItemAmount][selected_slot];
                            
                            // --- XÁC ĐỊNH GIỚI HẠN MAX_LIMIT DỰA TRÊN ITEM ID (21=100, 22=200) ---
                            new max_limit = 0;
                            if (item_id == 21) // Can xăng 100L
                            {
                                max_limit = 100;
                            }
                            else if (item_id == 22) // Can xăng 200L
                            {
                                max_limit = 200;
                            }

                            if(current_amount >= max_limit)
                            {
                                SendClientMessageEx(playerid, COLOR_RED, "Can xang nay hien da day, khong the tiep tuc nap.");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }

                            // --- LOGIC TÍNH TOÁN LƯỢNG MUA (Tối ưu theo Tiền) ---
                            
                            new
                                max_fill_space = max_limit - current_amount,
                                player_cash = GetPlayerCash(playerid),
                                cost_per_gallon = 1250;
                                
                            new
                                max_buy_amount_by_cash = player_cash / cost_per_gallon; // 2. Giới hạn mua bằng tiền
                                
                            new Float:available_pump_fuel = Businesses[iBusinessID][GasPumpGallons][iPumpID]; // 3. Giới hạn xăng còn lại trong trạm

                            // Tính toán lượng xăng thực tế sẽ mua: Chọn giá trị nhỏ nhất trong 3 giới hạn
                            new amount_to_buy = min(max_fill_space, max_buy_amount_by_cash);
                            amount_to_buy = min(amount_to_buy, floatround(available_pump_fuel)); 

                            if (amount_to_buy <= 0)
                            {
                                if (max_buy_amount_by_cash == 0)
                                {
                                    SendClientMessageEx(playerid, COLOR_RED, "Ban khong co du tien de mua bat ky luong xang nao.");
                                }
                                else
                                {
                                    SendClientMessageEx(playerid, COLOR_RED, "Khong the nap them xang.");
                                }
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                            
                            new total_cost = amount_to_buy * cost_per_gallon;
                            
                            // --- THỰC HIỆN GIAO DỊCH VÀ CẬP NHẬT TRẠNG THÁI ---
                            
                            // 1. Trừ tiền, trừ xăng trạm, cộng xăng vào Can
                            GivePlayerCash(playerid, -total_cost);
                            Businesses[iBusinessID][GasPumpGallons][iPumpID] -= float(amount_to_buy);
                            CharacterInfo[playerid][0][cb_ItemAmount][selected_slot] += amount_to_buy;
                            
                            // 2. CẬP NHẬT CÂN NẶNG
                            if (CharacterInfo[playerid][0][cb_ItemAmount][selected_slot] == 0)
                            {
                                CharacterInfo[playerid][0][cb_ItemWeight][selected_slot] = 0.0;
                            }
                            else 
                            {
                                // Lấy cân nặng cố định của Can Xăng 
                                CharacterInfo[playerid][0][cb_ItemWeight][selected_slot] = GetItemWeight(item_id); 
                            }
                            
                            // 3. Thông báo kết quả
                            new string[144];
                            format(string, sizeof(string), "[{FFB561}TRAM XANG{FFFFFF}]: Ban da mua %i don vi xang voi gia $%d. Can xang hien co %i/%i don vi.", 
                                amount_to_buy, total_cost, CharacterInfo[playerid][0][cb_ItemAmount][selected_slot], max_limit);
                            SendClientMessageEx(playerid, COLOR_WHITE, string);
                            
                            format(string, sizeof(string), "* %s nap xang vao can xang cua ho.", GetPlayerNameEx(playerid));
                            ProxChatBubble(playerid, string);

                            // Dọn dẹp PVar
                            SetPVarInt(playerid, "CheckDialogInventory", 0);
                            return 1;
                        }

                    }
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Mang len nguoi", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    GivePlayerValidWeaponEx(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]), CharacterInfo[playerid][1][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da trang bi vu khi len nguoi.");

                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);

                    // Đã xóa vòng lặp PlayerTextDrawDestroy
                }
                SetPVarInt(playerid, "CheckDialogInventory", 0);
            }
        }
        if(strcmp(inputtext, "- Go xuong", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    new
                        index = -1,
                        stack = 0;
                    Inventory_CountSlot(playerid, stack, index);
                    if(index != -1)
                    {

                        new weaponid = GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                        
                        for(i = 0 ; i < 12 ; i++)
                        {
                            if(weaponid == PlayerInfo[playerid][pGuns][i])
                            {
                                PlayerInfo[playerid][pGuns][i] = 0;
                                SetPlayerWeaponsEx(playerid);
                                break;
                            }
                        }

                        CharacterInfo[playerid][stack][cb_ItemID][index] = CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")];
                        CharacterInfo[playerid][stack][cb_ItemWeight][index] = CharacterInfo[playerid][1][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")];
                        CharacterInfo[playerid][stack][cb_ItemDurability][index] = CharacterInfo[playerid][1][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")];
                        CharacterInfo[playerid][stack][cb_ItemAmount][index] = CharacterInfo[playerid][1][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];
                        
                        CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                        CharacterInfo[playerid][1][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                        CharacterInfo[playerid][1][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                        CharacterInfo[playerid][1][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                        // Đã xóa PlayerTextDrawSetString (kiểm tra Inventory_Character)
                        // Đã xóa Inventory_SetPost

                        SetPVarInt(playerid, "Inventory_SelectItem", -1);
                        SetPVarInt(playerid, "Inventory_SelectTarget", 0);

                        // Đã xóa vòng lặp PlayerTextDrawDestroy

                        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da go trang bi xuong.");

                        SetPVarInt(playerid, "CheckDialogInventory", 0);
                    }
                    else
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Hay dam bao con du cho trong tui do de thao trang bi xuong.");
                        SetPVarInt(playerid, "CheckDialogInventory", 0);
                    }
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Xoa bo", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    format(str, sizeof(str), "{FFFFFF}Ban co chac muon xoa bo vat pham {FF0000}%s {FFFFFF}khong?\nVat pham da xoa bo se khong the phuc hoi", GetItemName(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]));
                    Dialog_Show(playerid, DG_INVENTORY_DELETE_ITEM, DIALOG_STYLE_MSGBOX, "Thong tin vat pham", str, "Xac nhan", "Huy");
                }
            }
            else
            {
                if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban can go trang bi xuong truoc khi thuc hien thao tac xoa vat pham.");
                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Phan tach", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                Dialog_Show(playerid, DIALOG_SPLIT_ITEM, DIALOG_STYLE_INPUT, "Phan tach vat pham", "Ban muon tach ra thanh bao nhieu o?:", "Tach", "Huy");
            }
        }
        // Đã xóa hoàn toàn phần if(strcmp(inputtext, "- Ghep lai", true) == 0)
        
        if(strcmp(inputtext, "- Tieu thu nhien lieu", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] <= 0)
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong con du so luong de su dung.");
                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                    return 1;
                }
                new closestcar = GetClosestCar(playerid);
                new Float:hrand = 0.0;
                new string[124];
                if(IsPlayerInRangeOfVehicle(playerid, closestcar, 5.0))
                {
                    if(VehicleFuel[closestcar] >= 100.0)
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Chiec xe nay da du nhien lieu, khong the nap them.");
                        SetPVarInt(playerid, "CheckDialogInventory", 0);
                        return 1;
                    }
                    VehicleFuel[closestcar] = VehicleFuel[closestcar] + float(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
                    if(VehicleFuel[closestcar] > 100.0)
                    {
                        hrand = VehicleFuel[closestcar] - 100.0;
                        VehicleFuel[closestcar] -= hrand;
                        CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = floatround(hrand);
                    }
                    else
                    {
                        CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                    }
                    if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] == 0)
                    {
                        CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                    }
                    format(string, sizeof(string), "* %s da do xang tu can xang cua ho vao xe.", GetPlayerNameEx(playerid));
                    ProxChatBubble(playerid, string);
                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                    return 1;
                }
                else
                {
                    Inventory_CheckRedZoneData(playerid);
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Admin Panel", true) == 0)
        {
            format(str, sizeof(str), "- Give Items (yourself)\n- Give Items (for player)\n- Check (player)\n- Remove All Items (for player)");
            Dialog_Show(playerid, DIALOG_INVENTORY_ACTION, DIALOG_STYLE_LIST, "Admin Panel", str, "Chon", "Huy");
            return 1;
        }
        if(strcmp(inputtext, "- Give Items (yourself)", true) == 0)
        {
            new string[1024];
            SetPVarInt(playerid, "AdminYourSelf", 1);
            for(i = 0 ; i < sizeof(Inventory_ListItems) ; i++)
            {
                format(string, sizeof(string), "%s\n(%d) %s", string, i, Inventory_ListItems[i]);
            }
            Dialog_Show(playerid, DG_INVENTORY_GIVE_ITEM, DIALOG_STYLE_LIST, "List of Items", string, "Chon", "Huy");
            return 1;
        }
    }
    else
    {
        SetPVarInt(playerid, "CheckDialogInventory", 0);
        return 1;
    }
    return 1;
}

Dialog:DIALOG_INVENTORY_ACTION(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[356], i, z;
        if(strcmp(inputtext, "- Su dung", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    if(GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]))
                    {
                        new weaponid = GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                        new weapontype = GetWeaponType(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                        for(i = 0 ; i < 7 ; i++)
                        {
                            if(CharacterInfo[playerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
                            {
                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == weaponid)
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                    return 1;
                                }
                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == -1001 && weaponid == -1000 || GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == -1000 && weaponid == -1001)
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                    return 1;
                                }
                                if(GetWeaponType(CharacterInfo[playerid][1][cb_ItemID][i]) == weapontype)
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                    return 1;
                                }
                            }
                        }
                        for(i = 0 ; i < 7 ; i++)
                        {
                            if(CharacterInfo[playerid][1][cb_ItemLock][i] == 0 && CharacterInfo[playerid][1][cb_ItemID][i] == INVALID_OBJECT_ID)
                            {
                                CharacterInfo[playerid][1][cb_ItemID][i] = CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")];
                                CharacterInfo[playerid][1][cb_ItemWeight][i] = CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")];
                                CharacterInfo[playerid][1][cb_ItemDurability][i] = CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")];
                                CharacterInfo[playerid][1][cb_ItemAmount][i] = CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];

                                CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                                CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                                CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                                format(str, sizeof(str), "%s", GetItemMDL(CharacterInfo[playerid][1][cb_ItemID][i]));
                                PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][i + 6], str);
                                    
                                Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
                                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban da mang mot trang bi len nguoi.");

                                for(z = 0 ; z < MAX_PLAYER_TD_INVENTORYINFO ; z++)
                                {
                                    PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][z]);
                                }

                                GivePlayerValidWeaponEx(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]), CharacterInfo[playerid][1][cb_ItemAmount][i]);

                                SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                SetPVarInt(playerid, "Inventory_SelectTarget", 0);

                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                        }
                    }
                    else
                    {
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 41) // hop dan
                        {
                            new string[560];
                            format(string, sizeof(string), "Slot\tVu khi\tSo dan\n");
                            for(i = 0 ; i < 7 ; i++)
                            {
                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]))
                                {
                                    if(CharacterInfo[playerid][1][cb_ItemID][i] == 8 || CharacterInfo[playerid][1][cb_ItemID][i] == 9)
                                    {
                                        format(string, sizeof(string), "%s%d\tMay khai thac\t{FF0000}Khong the nap\n", string, i + 1);
                                    }
                                    else
                                    {
                                        if(CharacterInfo[playerid][1][cb_ItemAmount][i] >= GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][i]))
                                            format(string, sizeof(string), "%s%d\t%s\t{2D9410}Da day dan\n", string, i + 1, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1]);
                                        else
                                        {
                                            format(string, sizeof(string), "%s%d\t%s\t%d/%d\n", string, i + 1, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1], CharacterInfo[playerid][1][cb_ItemAmount][i], GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][i]));
                                        }
                                    }
                                }
                                if(CharacterInfo[playerid][1][cb_ItemID][i] == INVALID_OBJECT_ID)
                                    format(string, sizeof(string), "%s%d\t--\t--/--\n", string, i + 1);
                            }
                            return Dialog_Show(playerid, DIALOG_AMMOBOX_WPChoice, DIALOG_STYLE_TABLIST_HEADERS, "Nap dan vu khi", string, "Nap", "Huy");
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 10) // item coin
                        {
                            new string[456];
                            SetPVarInt(playerid, "Exchange_Coin_Request", 1);
                            format(string, sizeof(string), "Ban dang su dung vat pham {FF0000}'CHUYEN DOI GP SANG COIN'{FFFFFF}\n\
                            So GP ban hien dang co: {62FF00}%d{FFFFFF}.\n\n\
                            Bang quy doi:\n\
                            \t1 coin\t1,000 GP\n\
                            \t10 coin\t10,000 GP\n\
                            \t100 coin\t100,000 GP\n\
                            \t1000 coin\t1,000,000 GP\n\n\
                            Hay nhan 'Dong Y' neu nhu ban muon chuyen doi hoac 'Huy' neu khong muon chuyen doi",
                            PlayerData[playerid][pc_GP]);
                            return Dialog_Show(playerid, DG_EXCHANGE_COIN, DIALOG_STYLE_MSGBOX, "Coin Exchange", string, "Dong Y", "Huy");
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 11) // medkit
                        {
                            SetPVarInt(playerid, "usg_ItemIDs", 11);
                            SetPVarInt(playerid, "usg_ItemTimers", 15);
                            ItemGain(playerid, 1);
                            SetPVarInt(playerid, "CheckDialogInventory", 0);
                            return 1;
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 43)
                        {
                            callcmd::closeinv(playerid, "");
                            defer ShowBDKBTimer(playerid);
                            return 1;
                        }
                        new fishmanlist[] = {37, 38, 39};
                        for(i = 0 ; i < sizeof(fishmanlist) ; i++)
                        {
                            if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == fishmanlist[i])
                            {
                                if(IsAtRestaurant(playerid))
                                {
                                    format(str, sizeof(str), "Hay nhap so hai san ban muon ban:\n\n\
                                    (Ban hien dang co {FFB561}%d {FFFFFF}hai san trong kho.)",
                                    CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
                                    Dialog_Show(playerid, DG_PASS_FISH, DIALOG_STYLE_INPUT, "Ban hai san", str, "Chon", "Huy");
                                }
                                else
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban khong o nha hang (Quan an).");
                                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                                }
                            }
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 42)
                        {
                            if(PlayerData[playerid][pc_FoodBar] < 90 || PlayerData[playerid][pc_WaterBar] < 90)
                            {
                                PlayerData[playerid][pc_FoodBar] = 100;
                                PlayerData[playerid][pc_WaterBar] = 100;
                                Inventory_Update_Hunger(playerid);
                                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban da tieu thu mot luong lon thuc an tu combo GFC.");
                            }
                            else SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Nhan vat hien tai rat no, khong the tiep tuc an.");
                            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]--;
                            if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] <= 0)
                                RemovePlayerItem(playerid, GetPVarInt(playerid, "Inventory_SelectItem"));
                            SetPVarInt(playerid, "CheckDialogInventory", 0);
                        }
                        if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 21 || CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 22)
                        {
                            new selected_slot = GetPVarInt(playerid, "Inventory_SelectItem");
                            new
                                iBusinessID,
                                iPumpID;
                            
                            // Tìm trạm xăng gần nhất
                            GetClosestGasPump(playerid, iBusinessID, iPumpID);

                            // --- KIỂM TRA ĐIỀU KIỆN ---
                            if(zombieevent)
                            {
                                SendClientMessageEx(playerid, -1, "Ban khong the su dung lenh do xang khi Event Zombie dang dien ra!");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                            if (iBusinessID == INVALID_BUSINESS_ID || Businesses[iBusinessID][bStatus] == 0)
                            {
                                SendClientMessageEx(playerid, COLOR_RED, "Ban khong dung tai tram xang hoac tram xang nay hien dang dong.");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                            if (Businesses[iBusinessID][GasPumpGallons][iPumpID] <= 0.0)
                            {
                                SendClientMessageEx(playerid, COLOR_RED, "Tram nay hien da het xang.");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }

                            new item_id = CharacterInfo[playerid][0][cb_ItemID][selected_slot];
                            new current_amount = CharacterInfo[playerid][0][cb_ItemAmount][selected_slot];
                            
                            // --- XÁC ĐỊNH GIỚI HẠN MAX_LIMIT DỰA TRÊN ITEM ID (21=100, 22=200) ---
                            new max_limit = 0;
                            if (item_id == 21) // Can xăng 100L
                            {
                                max_limit = 100;
                            }
                            else if (item_id == 22) // Can xăng 200L
                            {
                                max_limit = 200;
                            }

                            if(current_amount >= max_limit)
                            {
                                SendClientMessageEx(playerid, COLOR_RED, "Can xang nay hien da day, khong the tiep tuc nap.");
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }

                            // --- LOGIC TÍNH TOÁN LƯỢNG MUA (Tối ưu theo Tiền) ---
                            
                            new
                                max_fill_space = max_limit - current_amount,    // 1. Giới hạn dung lượng Can còn lại
                                player_cash = GetPlayerCash(playerid),          // Tiền người chơi
                                cost_per_gallon = 1250;                         // Giá 1 đơn vị xăng
                                
                            new
                                max_buy_amount_by_cash = player_cash / cost_per_gallon; // 2. Giới hạn mua bằng tiền
                                
                            new Float:available_pump_fuel = Businesses[iBusinessID][GasPumpGallons][iPumpID]; // 3. Giới hạn xăng còn lại trong trạm

                            // Tính toán lượng xăng thực tế sẽ mua: Chọn giá trị nhỏ nhất trong 3 giới hạn
                            new amount_to_buy = min(max_fill_space, max_buy_amount_by_cash);
                            amount_to_buy = min(amount_to_buy, floatround(available_pump_fuel)); 

                            if (amount_to_buy <= 0)
                            {
                                if (max_buy_amount_by_cash == 0)
                                {
                                    SendClientMessageEx(playerid, COLOR_RED, "Ban khong co du tien de mua bat ky luong xang nao.");
                                }
                                else
                                {
                                    SendClientMessageEx(playerid, COLOR_RED, "Khong the nap them xang.");
                                }
                                SetPVarInt(playerid, "CheckDialogInventory", 0);
                                return 1;
                            }
                            
                            new total_cost = amount_to_buy * cost_per_gallon;
                            
                            // --- THỰC HIỆN GIAO DỊCH VÀ CẬP NHẬT TRẠNG THÁI ---
                            
                            // 1. Trừ tiền, trừ xăng trạm, cộng xăng vào Can
                            GivePlayerCash(playerid, -total_cost);
                            Businesses[iBusinessID][GasPumpGallons][iPumpID] -= float(amount_to_buy);
                            CharacterInfo[playerid][0][cb_ItemAmount][selected_slot] += amount_to_buy;
                            
                            // 2. CẬP NHẬT CÂN NẶNG (Can rỗng = 0.0)
                            if (CharacterInfo[playerid][0][cb_ItemAmount][selected_slot] == 0)
                            {
                                CharacterInfo[playerid][0][cb_ItemWeight][selected_slot] = 0.0;
                            }
                            else 
                            {
                                // Lấy cân nặng cố định của Can Xăng (ví dụ: 5.0kg hoặc 10.0kg)
                                CharacterInfo[playerid][0][cb_ItemWeight][selected_slot] = GetItemWeight(item_id); 
                            }
                            
                            // 3. Thông báo kết quả
                            new string[144];
                            format(string, sizeof(string), "[{FFB561}TRAM XANG{FFFFFF}]: Ban da mua %i don vi xang voi gia $%d. Can xang hien co %i/%i don vi.", 
                                amount_to_buy, total_cost, CharacterInfo[playerid][0][cb_ItemAmount][selected_slot], max_limit);
                            SendClientMessageEx(playerid, COLOR_WHITE, string);
                            
                            format(string, sizeof(string), "* %s nap xang vao can xang cua ho.", GetPlayerNameEx(playerid));
                            ProxChatBubble(playerid, string);

                            // Dọn dẹp PVar
                            SetPVarInt(playerid, "CheckDialogInventory", 0);
                            return 1;
                        }

                    }
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Mang len nguoi", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    GivePlayerValidWeaponEx(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]), CharacterInfo[playerid][1][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da trang bi vu khi len nguoi.");

                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);

                    for(i = 0 ; i < MAX_PLAYER_TD_INVENTORYINFO ; i++)
                        PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][i]);
                }
                SetPVarInt(playerid, "CheckDialogInventory", 0);
            }
        }
        if(strcmp(inputtext, "- Go xuong", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    new
                        index = -1,
                        stack = 0;
                    Inventory_CountSlot(playerid, stack, index);
                    if(index != -1)
                    {

                        new weaponid = GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                        
                        for(i = 0 ; i < 12 ; i++)
                        {
                            if(weaponid == PlayerInfo[playerid][pGuns][i])
                            {
                                PlayerInfo[playerid][pGuns][i] = 0;
                                SetPlayerWeaponsEx(playerid);
                                break;
                            }
                        }

                        CharacterInfo[playerid][stack][cb_ItemID][index] = CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")];
                        CharacterInfo[playerid][stack][cb_ItemWeight][index] = CharacterInfo[playerid][1][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")];
                        CharacterInfo[playerid][stack][cb_ItemDurability][index] = CharacterInfo[playerid][1][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")];
                        CharacterInfo[playerid][stack][cb_ItemAmount][index] = CharacterInfo[playerid][1][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];
                        
                        CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                        CharacterInfo[playerid][1][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                        CharacterInfo[playerid][1][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                        CharacterInfo[playerid][1][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                        if(Inventory_Character[playerid]) PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][GetPVarInt(playerid, "Inventory_SelectItem") + 6], "mdl-2002:item_null");
                        Inventory_SetPost(playerid, Guide_ReadPost[playerid]);

                        SetPVarInt(playerid, "Inventory_SelectItem", -1);
                        SetPVarInt(playerid, "Inventory_SelectTarget", 0);

                        for(i = 0 ; i < MAX_PLAYER_TD_INVENTORYINFO ; i++)
                            PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][i]);

                        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da go trang bi xuong.");

                        SetPVarInt(playerid, "CheckDialogInventory", 0);
                    }
                    else
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Hay dam bao con du cho trong trong tui do de thao trang bi xuong.");
                        SetPVarInt(playerid, "CheckDialogInventory", 0);
                    }
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Xoa bo", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    format(str, sizeof(str), "{FFFFFF}Ban co chac muon xoa bo vat pham {FF0000}%s {FFFFFF}khong?\nVat pham da xoa bo se khong the phuc hoi", GetItemName(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]));
                    Dialog_Show(playerid, DG_INVENTORY_DELETE_ITEM, DIALOG_STYLE_MSGBOX, "Thong tin vat pham", str, "Xac nhan", "Huy");
                }
            }
            else
            {
                if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && CharacterInfo[playerid][1][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban can go trang bi xuong truoc khi thuc hien thao tac xoa vat pham.");
                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Phan tach", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                Dialog_Show(playerid, DIALOG_SPLIT_ITEM, DIALOG_STYLE_INPUT, "Phan tach vat pham", "Ban muon tach ra thanh bao nhieu o?:", "Tach", "Huy");
            }
        }
        if(strcmp(inputtext, "- Ghep lai", true) == 0)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Hay chon mot vat pham cung loai co so luong nho hon de tien hanh ghep lai.");
            SetPVarInt(playerid, "Inventory_GraftingItem", 1);
            SetPVarInt(playerid, "CheckDialogInventory", 0);
            return 1;
        }
        if(strcmp(inputtext, "- Tieu thu nhien lieu", true) == 0)
        {
            if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
            {
                if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] <= 0)
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong con du so luong de su dung.");
                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                    return 1;
                }
                new closestcar = GetClosestCar(playerid);
                new Float:hrand = 0.0;
                new string[124];
                if(IsPlayerInRangeOfVehicle(playerid, closestcar, 5.0))
                {
                    if(VehicleFuel[closestcar] >= 100.0)
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Chiec xe nay da du nhien lieu, khong the nap them.");
                        SetPVarInt(playerid, "CheckDialogInventory", 0);
                        return 1;
                    }
                    VehicleFuel[closestcar] = VehicleFuel[closestcar] + float(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
                    if(VehicleFuel[closestcar] > 100.0)
                    {
                        hrand = VehicleFuel[closestcar] - 100.0;
                        VehicleFuel[closestcar] -= hrand;
                        CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = floatround(hrand);
                    }
                    else
                    {
                        CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                    }
                    if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] == 0)
                    {
                        CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                    }
                    format(string, sizeof(string), "* %s da do xang tu can xang cua ho vao xe.", GetPlayerNameEx(playerid));
                    ProxChatBubble(playerid, string);
                    SetPVarInt(playerid, "CheckDialogInventory", 0);
                    return 1;
                }
                else
                {
                    Inventory_CheckRedZoneData(playerid);
                }
            }
            return 1;
        }
        if(strcmp(inputtext, "- Admin Panel", true) == 0)
        {
            format(str, sizeof(str), "- Give Items (yourself)\n- Give Items (for player)\n- Check (player)\n- Remove All Items (for player)");
            Dialog_Show(playerid, DIALOG_INVENTORY_ACTION, DIALOG_STYLE_LIST, "Admin Panel", str, "Chon", "Huy");
            return 1;
        }
        if(strcmp(inputtext, "- Give Items (yourself)", true) == 0)
        {
            new string[1024];
            SetPVarInt(playerid, "AdminYourSelf", 1);
            for(i = 0 ; i < sizeof(Inventory_ListItems) ; i++)
            {
                format(string, sizeof(string), "%s\n(%d) %s", string, i, Inventory_ListItems[i]);
            }
            Dialog_Show(playerid, DG_INVENTORY_GIVE_ITEM, DIALOG_STYLE_LIST, "List of Items", string, "Chon", "Huy");
            return 1;
        }
        if(GetPVarInt(playerid, "BaloDialogOpen") == 1)
        {
            return Balo_ShowMain(playerid);
        }
    }
    else
    {
        SetPVarInt(playerid, "CheckDialogInventory", 0);
        if(GetPVarInt(playerid, "BaloDialogOpen") == 1)
        {
            return Balo_ShowMain(playerid);
        }
        return 1;
    }
    return 1;
}

Dialog:DIALOG_SPLIT_ITEM(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
        {
            if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_SPLIT_ITEM, DIALOG_STYLE_INPUT, "Phan tach vat pham", "Khong duoc bo trong\nBan muon tach ra thanh bao nhieu o?:", "Tach", "Huy");
            if(!IsNumeric(inputtext)) return Dialog_Show(playerid, DIALOG_SPLIT_ITEM, DIALOG_STYLE_INPUT, "Phan tach vat pham", "Chi duoc nhap so\nBan muon tach ra thanh bao nhieu o?:", "Tach", "Huy");
            if(GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]))
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tach vat pham la vu khi.");
                Inventory_Action(playerid, -1);
                return 1;
            }
            new
                count = 0,
                split_slot = strval(inputtext);
            new i;
            for(i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
            {
                if(CharacterInfo[playerid][0][cb_ItemLock][i] == 0 && CharacterInfo[playerid][0][cb_ItemID][i] == INVALID_OBJECT_ID)
                    count++;
            }
            if(count < split_slot) return Dialog_Show(playerid, DIALOG_SPLIT_ITEM, DIALOG_STYLE_INPUT, "Phan tach vat pham", "Khong du o de tach\nBan muon tach ra thanh bao nhieu o?:", "Tach", "Huy");
            else
            {
                new amount = CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];
                new split_amount = amount % split_slot;
                if(split_amount != 0)
                {
                    return Dialog_Show(playerid, DIALOG_SPLIT_ITEM, DIALOG_STYLE_INPUT, "Phan tach vat pham", "So luong phan tach khong hop le\nBan muon tach ra thanh bao nhieu o?:", "Tach", "Huy");
                }
                else
                {
                    split_amount = amount / split_slot;
                    count = 0;
                    for(i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
                    {
                        if(CharacterInfo[playerid][0][cb_ItemLock][i] == 0 && CharacterInfo[playerid][0][cb_ItemID][i] == INVALID_OBJECT_ID)
                        {
                            CharacterInfo[playerid][0][cb_ItemID][i] = CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")];
                            CharacterInfo[playerid][0][cb_ItemWeight][i] = CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")];
                            CharacterInfo[playerid][0][cb_ItemDurability][i] = CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")];
                            CharacterInfo[playerid][0][cb_ItemAmount][i] = split_amount;
                            count++;
                        }
                        if(count == split_slot) break;
                    }
                    CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                    CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                    CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                    CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da phan tach vat pham sang cac o moi.");

                    PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // am thanh ghep

                    Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
                    Inventory_Action(playerid, -1); // clear var
                }
            }
        }
    }
    return 1;
}

Dialog:DG_INVENTORY_DELETE_ITEM(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != -1)
        {
            if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] == 43)
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the xoa vat pham nay.");
                Inventory_Action(playerid, -1);
                return 1;
            }
            if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
            {
                CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
                SetPVarInt(playerid, "Inventory_SelectItem", -1);
                SetPVarInt(playerid, "Inventory_SelectTarget", 0);

                SetPVarInt(playerid, "CheckDialogInventory", 0);

                PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // am thanh ghep

                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da xoa bo mot vat pham khoi tui do.");
            }
        }
    }
    else
    {
        SetPVarInt(playerid, "CheckDialogInventory", 0);
        return 1;
    }
    return 1;
}

Dialog:DG_INVENTORY_GIVE_ITEM(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(GetPVarInt(playerid, "AdminYourSelf") == 1)
        {
            Inventory_AddItem(playerid, playerid, listitem + 1, 0);
            SetPVarInt(playerid, "AdminYourSelf", 0);
            SetPVarInt(playerid, "CheckDialogInventory", 0);
            PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // am thanh ghep
            if(GetPVarInt(playerid, "BaloDialogOpen") == 1) return Balo_ShowMain(playerid);
        }
    }
    else
    {
        SetPVarInt(playerid, "CheckDialogInventory", 0);
        if(GetPVarInt(playerid, "BaloDialogOpen") == 1) return Balo_ShowMain(playerid);
        return 1;
    }
    return 1;
}

Dialog:DG_PASS_FISH(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[356];
        if(isnull(inputtext))
        {
            format(str, sizeof(str), "Khong duoc phep bo trong\n\nHay nhap so hai san ban muon ban:\n\n\
            (Ban hien dang co {FFB561}%d {FFFFFF}hai san trong kho.)",
            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
            return Dialog_Show(playerid, DG_PASS_FISH, DIALOG_STYLE_INPUT, "Ban hai san", str, "Chon", "Huy");
        }
        if(!IsNumeric(inputtext))
        {
            format(str, sizeof(str), "Vui long chi nhap vao so\n\nHay nhap so hai san ban muon ban:\n\n\
            (Ban hien dang co {FFB561}%d {FFFFFF}hai san trong kho.)",
            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
            return Dialog_Show(playerid, DG_PASS_FISH, DIALOG_STYLE_INPUT, "Ban hai san", str, "Chon", "Huy");
        }
        if(strval(inputtext) > CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")])
        {
            format(str, sizeof(str), "Ban khong co nhieu hai san den the!\n\nHay nhap so hai san ban muon ban:\n\n\
            (Ban hien dang co {FFB561}%d {FFFFFF}hai san trong kho.)",
            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")]);
            return Dialog_Show(playerid, DG_PASS_FISH, DIALOG_STYLE_INPUT, "Ban hai san", str, "Chon", "Huy");
        }
        //===================================
        new listprice[] = {2000, 3000, 4000};
        new randlist = random(sizeof(listprice));
        format(str, sizeof(str), "[{FFB561}NHA HANG{FFFFFF}]: Ban da ban lai %d %s cho nha hang va nhan duoc $%s", strval(inputtext), Inventory_ListItems[CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] - 1], number_format(listprice[randlist] * strval(inputtext)));
        SendClientMessageEx(playerid, COLOR_WHITE, str);

        CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] -= strval(inputtext);
        GivePlayerCash(playerid, listprice[randlist] * strval(inputtext));

        if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] <= 0)
        {
            CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
            CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
            CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
        }

        PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // am thanh ghep

        Inventory_Action(playerid, -1); // clear var
    }
    else
    {
        SetPVarInt(playerid, "CheckDialogInventory", 0);
        return 1;
    }
    return 1;
}

Dialog:DG_EXCHANGE_COIN(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(GetPVarInt(playerid, "Exchange_Coin_Request") == 1)
        {
            SetPVarInt(playerid, "Exchange_Coin_Request", 2);
            return Dialog_Show(playerid, DG_EXCHANGE_COIN, DIALOG_STYLE_INPUT, "Coin Exchange", "Hay nhap so coin ban muon doi (theo bang gia da xem):", "Doi", "Huy");
        }
        else
        {
            if(PlayerData[playerid][pc_GP] <= 0)
            {
                SetPVarInt(playerid, "Exchange_Coin_Request", 0);
                SendClientMessageEx(playerid, COLOR_GRAD3, "Chuyen doi that bai do ban khong du GP trong nguoi.");
                if(GetPVarInt(playerid, "BaloDialogOpen") == 1) return Balo_ShowMain(playerid);
                return 1;
            }
            if(isnull(inputtext))
            {
                return Dialog_Show(playerid, DG_EXCHANGE_COIN, DIALOG_STYLE_INPUT, "Coin Exchange", "Khong duoc phep bo trong\nHay nhap so coin ban muon doi (theo bang gia da xem):", "Doi", "Huy");
            }
            if(PlayerData[playerid][pc_GP] < strval(inputtext) * 1000)
            {
                SetPVarInt(playerid, "Exchange_Coin_Request", 0);
                SendClientMessageEx(playerid, COLOR_GRAD3, "Chuyen doi that bai do ban khong du GP trong nguoi.");
                if(GetPVarInt(playerid, "BaloDialogOpen") == 1) return Balo_ShowMain(playerid);
                return 1;
            }
            new str[156];
            PlayerData[playerid][pc_Coin] += strval(inputtext);
            PlayerData[playerid][pc_GP] -= strval(inputtext) * 1000;
            SetPVarInt(playerid, "Exchange_Coin_Request", 0);
            //SetPVarInt(playerid, "CheckDialogInventory", 0);
            Inventory_Action(playerid, -1);
            PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // am thanh ghep
            format(str, sizeof(str), "[{FFB561}COIN EXCHANGE{FFFFFF}]: Ban da chuyen doi %d GP sang %d Coin thanh cong.", strval(inputtext) * 1000, strval(inputtext));
            SendClientMessageEx(playerid, COLOR_WHITE, str);
            if(GetPVarInt(playerid, "BaloDialogOpen") == 1) return Balo_ShowMain(playerid);
            return 1;
        }
    }
    else
    {
        SetPVarInt(playerid, "Exchange_Coin_Request", 0);
        SetPVarInt(playerid, "CheckDialogInventory", 0);
        if(GetPVarInt(playerid, "BaloDialogOpen") == 1) return Balo_ShowMain(playerid);
    }
    return 1;
}

Dialog:DIALOG_AMMOBOX_WPChoice(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(CharacterInfo[playerid][1][cb_ItemID][listitem] == 8 || CharacterInfo[playerid][1][cb_ItemID][listitem] == 9)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong the nap dan doi voi vat pham nay.");
            return Balo_ShowMain(playerid);
        }
        if(CharacterInfo[playerid][1][cb_ItemID][listitem] == INVALID_OBJECT_ID)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Slot trong, khong co vu khi de nap.");
            return Balo_ShowMain(playerid);
        }
        if(CharacterInfo[playerid][1][cb_ItemAmount][listitem] >= GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][listitem]))
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Vu khi nay da day dan khong the tiep tuc nap.");
            return Balo_ShowMain(playerid);
        }
        new ammoSlot = GetPVarInt(playerid, "Inventory_SelectItem");
        if(CharacterInfo[playerid][0][cb_ItemAmount][ammoSlot] <= 0)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban khong the nap dan vi khong con du so dan trong hop.");
            return Balo_ShowMain(playerid);
        }

        new amount = CharacterInfo[playerid][0][cb_ItemAmount][ammoSlot];
        new maxAmmo = GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][listitem]);
        new currentAmmo = CharacterInfo[playerid][1][cb_ItemAmount][listitem];
        new needed = maxAmmo - currentAmmo;

        if(amount > needed) amount = needed;

        CharacterInfo[playerid][1][cb_ItemAmount][listitem] += amount;
        CharacterInfo[playerid][0][cb_ItemAmount][ammoSlot] -= amount;

        if(CharacterInfo[playerid][0][cb_ItemAmount][ammoSlot] <= 0)
        {
            CharacterInfo[playerid][0][cb_ItemID][ammoSlot] = INVALID_OBJECT_ID;
            CharacterInfo[playerid][0][cb_ItemWeight][ammoSlot] = 0.0;
            CharacterInfo[playerid][0][cb_ItemDurability][ammoSlot] = 0;
            CharacterInfo[playerid][0][cb_ItemAmount][ammoSlot] = 0;
        }

        SetPlayerAmmo(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][listitem]), CharacterInfo[playerid][1][cb_ItemAmount][listitem]);

        new str[128];
        format(str, sizeof(str), "[{FFB561}BALO{FFFFFF}]: Ban da nap %d dan cho %s. (%d/%d)",
            amount,
            Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][listitem] - 1],
            CharacterInfo[playerid][1][cb_ItemAmount][listitem],
            maxAmmo);
        SendClientMessageEx(playerid, COLOR_WHITE, str);

        PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);
    }
    return Balo_ShowMain(playerid);
}

CMD:giftplayeritem(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        if(PlayerInfo[playerid][pAdmin] >= 1338)
        {
            new
                id, amount;
            if(sscanf(params, "ud", id, amount))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giftplayeritem [playerid] [so luong]");
            }
            else if(gPlayerLogged{id})
            {
                if(amount < 0) return SendClientMessageEx(playerid, COLOR_GRAD3, "Wrong amount!");
                else
                {
                    SetPVarInt(playerid, "ItemIniAmountAdmin", amount);
                    SetPVarInt(playerid, "ItemIniIDAdmin", id);
                    new str[1024], headers[64];
                    format(headers, sizeof(headers), "THEM VAT PHAM CHO %s", GetPlayerNameExt(id));
                    for(new i = 0 ; i < sizeof(Inventory_ListItems) ; i++)
                    {
                        format(str, sizeof(str), "%s%s\n", str, Inventory_ListItems[i]);
                    }
                    Dialog_Show(playerid, DIALOG_AGPITEM, DIALOG_STYLE_LIST, headers, str, "Add", "Huy");
                }
            }
            else return SendClientMessageEx(playerid, COLOR_GRAD3, "Nguoi choi nay chua dang nhap!");
        }
    }
    return 1;
}

Dialog:DIALOG_AGPITEM(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        SetPVarInt(playerid, "ItemIniIDItemAdmin", listitem + 1);
        new str[256];
        format(str, sizeof(str), "{FFFFFF}Ban co chac muon cho %s:\n\
        Vat pham: %s\tSo luong: %d\nKhong?",
        GetPlayerNameExt(GetPVarInt(playerid, "ItemIniIDAdmin")), Inventory_ListItems[listitem], GetPVarInt(playerid, "ItemIniAmountAdmin"));
        Dialog_Show(playerid,DIALOG_AGPITEM2, DIALOG_STYLE_MSGBOX, "Canh Bao", str, "Dong Y", "Thoat");
    }
    else
    {
        DeletePVar(playerid, "ItemIniAmountAdmin");
        DeletePVar(playerid, "ItemIniIDAdmin");
        DeletePVar(playerid, "ItemIniIDItemAdmin");
    }
    return 1;
}

Dialog:DIALOG_AGPITEM2(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(IsPlayerConnected(GetPVarInt(playerid, "ItemIniIDAdmin")))
        {
            new year, month, day;
            getdate(year, month, day);
            new success = -1;
            new str[456];
            SetPlayerItem(GetPVarInt(playerid, "ItemIniIDAdmin"), GetPVarInt(playerid, "ItemIniIDItemAdmin"), GetPVarInt(playerid, "ItemIniAmountAdmin"), success);
            if(success == -1)
            {
                format(str, sizeof(str), "[%04d:%d:%d] BQT ***%s*** đã thất bại trong việc refund lại vật phẩm %s cho người chơi ***%s***.", year, month, day, GetPlayerNameEx(playerid), Inventory_ListItems[GetPVarInt(playerid, "ItemIniIDItemAdmin") - 1], GetPlayerNameEx(GetPVarInt(playerid, "ItemIniIDAdmin")));
            }
            else
            {
                format(str, sizeof(str), "[%04d:%d:%d] BQT ***%s*** đã thành công trong việc refund lại vật phẩm %s (Số lượng: %d) cho người chơi ***%s***.", year, month, day, GetPlayerNameEx(playerid), Inventory_ListItems[GetPVarInt(playerid, "ItemIniIDItemAdmin") - 1], GetPVarInt(playerid, "ItemIniAmountAdmin"), GetPlayerNameEx(GetPVarInt(playerid, "ItemIniIDAdmin")));
            }
            SendAdminMessage(1, str);
            DeletePVar(playerid, "ItemIniAmountAdmin");
            DeletePVar(playerid, "ItemIniIDAdmin");
            DeletePVar(playerid, "ItemIniIDItemAdmin");
        }
        else
        {

            SendClientMessageEx(playerid, COLOR_GRAD3, "Nguoi choi nay khong co mat trong may chu!");
            
            DeletePVar(playerid, "ItemIniAmountAdmin");
            DeletePVar(playerid, "ItemIniIDAdmin");
            DeletePVar(playerid, "ItemIniIDItemAdmin");
        }
    }
    else
    {
        DeletePVar(playerid, "ItemIniAmountAdmin");
        DeletePVar(playerid, "ItemIniIDAdmin");
        DeletePVar(playerid, "ItemIniIDItemAdmin");
    }
    return 1;
}

CMD:balo(playerid, params[])
{
	if(gPlayerLogged{playerid})
    {
        new i;
        if(GetPVarInt(playerid, "EventToken"))
            return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the lam dieu nay ngay bay gio khi event dang dien ra.");
        if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen"))
            return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay bay gio!");
        
        if(CharacterInfo[playerid][0][cb_Weight] == 45.0) CharacterInfo[playerid][0][cb_Weight] = 60.0;
        for(i = 11 ; i < 13 ; i++)
        {
            if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
                CharacterInfo[playerid][0][cb_ItemLock][i] = 0;
        }

        Balo_ShowMain(playerid);
	}
	return 1;
}

stock Balo_ShowMain(playerid)
{
    SetPVarInt(playerid, "BaloDialogOpen", 1);
    new title[128], szStr[4096], count;
    new Float:totalWeight;

    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] != INVALID_OBJECT_ID)
            totalWeight += CharacterInfo[playerid][0][cb_ItemWeight][i];
    }

    format(title, sizeof(title), "BALO {FFFFFF}| %s {FFFFFF}| {F5CB42}%.1f{FFFFFF}/{F5CB42}%.1f{FFFFFF} kg | {FFFFFF}Items: {F5CB42}%d {FFFFFF}| {57FF57}$%s",
        GetPlayerNameEx(playerid), totalWeight, CharacterInfo[playerid][0][cb_Weight], count, number_format(GetPlayerCash(playerid)));

    format(szStr, sizeof(szStr), "#\tVat pham\tSL\tKG\tTrang bi\n");

    // Find last used slot to determine display range
    new lastUsed = 12; // Minimum show 13 slots (default unlocked)
    for(new i = MAX_PLAYER_CB_ITEM - 1; i >= 0; i--)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] != INVALID_OBJECT_ID || CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
        {
            lastUsed = i;
            break;
        }
    }
    // Show at least 13 slots, or up to last used + 3 empty
    new showSlots = (lastUsed + 3 > 12) ? lastUsed + 3 : 12;
    if(showSlots >= MAX_PLAYER_CB_ITEM) showSlots = MAX_PLAYER_CB_ITEM - 1;

    for(new i = 0; i <= showSlots; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
            format(szStr, sizeof(szStr), "%s{666666}%d\t{666666}--- Khoa ---\t\t\t\n", szStr, i + 1);
        else if(CharacterInfo[playerid][0][cb_ItemID][i] == INVALID_OBJECT_ID)
            format(szStr, sizeof(szStr), "%s{444444}%d\t{444444}Trong\t\t\t\n", szStr, i + 1);
        else
        {
            count++;
            new itemid = CharacterInfo[playerid][0][cb_ItemID][i];
            new color[8], equipStr[24];

            if(GetIDWeapon(itemid))
            {
                color = "FF6347";
                // Check if this weapon is equipped in tab [1]
                if(Balo_IsItemEquipped(playerid, itemid))
                    equipStr = "{57FF57}Dang mang";
                else
                    equipStr = "{888888}---";
            }
            else
            {
                color = "FFFFFF";
                equipStr = "{888888}---";
            }

            format(szStr, sizeof(szStr), "%s{F5CB42}%d\t{%s}%s\t{FFFFFF}%d\t{FFFFFF}%.1f\t%s\n",
                szStr, i + 1, color,
                Inventory_ListItems[itemid - 1],
                CharacterInfo[playerid][0][cb_ItemAmount][i],
                CharacterInfo[playerid][0][cb_ItemWeight][i],
                equipStr);
        }
    }

    if(count == 0)
        format(szStr, sizeof(szStr), "%s\n{888888}Balo trong. Mua do tai cua hang hoac nhat tu ground.", szStr);

    // Show equipped weapons section
    new equipCount = 0;
    for(new i = 0; i < 7; i++)
    {
        if(CharacterInfo[playerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
        {
            equipCount++;
            break;
        }
    }
    if(equipCount > 0)
    {
        SetPVarInt(playerid, "Balo_EquipOffset", showSlots + 3); // +3 for empty line + header + header row in TABLIST_HEADERS
        format(szStr, sizeof(szStr), "%s\n{FFB561}--- VU KHI DANG TRANG BI ---\n", szStr);
        for(new i = 0; i < 7; i++)
        {
            if(CharacterInfo[playerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
            {
                new eqItemid = CharacterInfo[playerid][1][cb_ItemID][i];
                format(szStr, sizeof(szStr), "%s{F5CB42}%d\t{FF6347}%s\t{FFFFFF}%d\t{FFFFFF}%.1f\t{57FF57}Dang mang\n",
                    szStr, i + 1,
                    Inventory_ListItems[eqItemid - 1],
                    CharacterInfo[playerid][1][cb_ItemAmount][i],
                    CharacterInfo[playerid][1][cb_ItemWeight][i]);
            }
            else
            {
                format(szStr, sizeof(szStr), "%s{F5CB42}%d\t{444444}Trong\t\t\t\n", szStr, i + 1);
            }
        }
    }
    else
    {
        SetPVarInt(playerid, "Balo_EquipOffset", 0);
    }

    Dialog_Show(playerid, DIALOG_BALO_MAIN, DIALOG_STYLE_TABLIST_HEADERS, title, szStr, "Thao tac", "Dong");
    return 1;
}

stock Balo_IsItemEquipped(playerid, itemid)
{
    for(new i = 0; i < 7; i++)
    {
        if(CharacterInfo[playerid][1][cb_ItemID][i] == itemid)
            return 1;
    }
    return 0;
}

stock Balo_IsUsable(itemid)
{
    // Usable items: consumables, boxes, ammo, jerry can, etc.
    if(itemid >= 10 && itemid <= 22) return 1;  // Coin exchange, medkit, gatacetamol, slot card, bonus cards, boxes, jerry can
    if(itemid == 41) return 1;                   // Ammo box
    if(itemid == 42) return 1;                   // Combo GFC
    if(itemid == 43) return 1;                   // Treasure map
    return 0;                                    // Weapons, materials, fish = not usable directly
}

CMD:balomobile(playerid, params[])
{
    return callcmd::balo(playerid, params);
}

CMD:lucsoatbalo(playerid, params[])
{
    if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Canh sat!");
    if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerTied[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay ngay bay gio!");

    new giveplayerid;
    if(sscanf(params, "u", giveplayerid))
        return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /lucsoatbalo [player]");

    if(!IsPlayerConnected(giveplayerid))
        return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");

    if(giveplayerid == playerid)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the luc soat balo cua chinh minh!");

    if(!ProxDetectorS(8.0, playerid, giveplayerid))
        return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");

    if(PlayerInfo[giveplayerid][pAdmin] >= 2 && !PlayerInfo[giveplayerid][pTogReports])
        return SendClientMessageEx(playerid, COLOR_GREY, "Khong the luc soat nguoi nay.");

    new szStr[4096], title[128], count;
    new Float:totalWeight;

    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[giveplayerid][0][cb_ItemID][i] != INVALID_OBJECT_ID)
            totalWeight += CharacterInfo[giveplayerid][0][cb_ItemWeight][i];
    }

    format(title, sizeof(title), "BALO cua %s | %.1f/%.1f kg | Items: %d",
        GetPlayerNameEx(giveplayerid), totalWeight, CharacterInfo[giveplayerid][0][cb_Weight], count);

    format(szStr, sizeof(szStr), "#\tVat pham\tSL\tKG\tTrang bi\n");

    new lastUsed = 12;
    for(new i = MAX_PLAYER_CB_ITEM - 1; i >= 0; i--)
    {
        if(CharacterInfo[giveplayerid][0][cb_ItemID][i] != INVALID_OBJECT_ID || CharacterInfo[giveplayerid][0][cb_ItemLock][i] == 1)
        {
            lastUsed = i;
            break;
        }
    }
    new showSlots = (lastUsed + 3 > 12) ? lastUsed + 3 : 12;
    if(showSlots >= MAX_PLAYER_CB_ITEM) showSlots = MAX_PLAYER_CB_ITEM - 1;

    for(new i = 0; i <= showSlots; i++)
    {
        if(CharacterInfo[giveplayerid][0][cb_ItemLock][i] == 1)
            format(szStr, sizeof(szStr), "%s{666666}%d\t{666666}--- Khoa ---\t\t\t\n", szStr, i + 1);
        else if(CharacterInfo[giveplayerid][0][cb_ItemID][i] == INVALID_OBJECT_ID)
            format(szStr, sizeof(szStr), "%s{444444}%d\t{444444}Trong\t\t\t\n", szStr, i + 1);
        else
        {
            count++;
            new itemid = CharacterInfo[giveplayerid][0][cb_ItemID][i];
            new color[8], equipStr[24];

            if(GetIDWeapon(itemid))
            {
                color = "FF6347";
                if(Balo_IsItemEquipped(giveplayerid, itemid))
                    equipStr = "{57FF57}Dang mang";
                else
                    equipStr = "{888888}---";
            }
            else
            {
                color = "FFFFFF";
                equipStr = "{888888}---";
            }

            format(szStr, sizeof(szStr), "%s{F5CB42}%d\t{%s}%s\t{FFFFFF}%d\t{FFFFFF}%.1f\t%s\n",
                szStr, i + 1, color,
                Inventory_ListItems[itemid - 1],
                CharacterInfo[giveplayerid][0][cb_ItemAmount][i],
                CharacterInfo[giveplayerid][0][cb_ItemWeight][i],
                equipStr);
        }
    }

    if(count == 0)
        format(szStr, sizeof(szStr), "%s\n{888888}Balo trong.", szStr);

    new equipCount = 0;
    for(new i = 0; i < 7; i++)
    {
        if(CharacterInfo[giveplayerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
        {
            equipCount++;
            break;
        }
    }
    if(equipCount > 0)
    {
        format(szStr, sizeof(szStr), "%s\n{FFB561}--- VU KHI DANG TRANG BI ---\n", szStr);
        for(new i = 0; i < 7; i++)
        {
            if(CharacterInfo[giveplayerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
            {
                new eqItemid = CharacterInfo[giveplayerid][1][cb_ItemID][i];
                format(szStr, sizeof(szStr), "%s{F5CB42}%d\t{FF6347}%s\t{FFFFFF}%d\t{FFFFFF}%.1f\t{57FF57}Dang mang\n",
                    szStr, i + 1,
                    Inventory_ListItems[eqItemid - 1],
                    CharacterInfo[giveplayerid][1][cb_ItemAmount][i],
                    CharacterInfo[giveplayerid][1][cb_ItemWeight][i]);
            }
            else
            {
                format(szStr, sizeof(szStr), "%s{F5CB42}%d\t{444444}Trong\t\t\t\n", szStr, i + 1);
            }
        }
    }

    format(title, sizeof(title), "BALO cua %s | %.1f/%.1f kg | Items: %d",
        GetPlayerNameEx(giveplayerid), totalWeight, CharacterInfo[giveplayerid][0][cb_Weight], count);

    format(szStr, sizeof(szStr), "%s\n\n{FF6347}* Chi xem, khong the thao tac.", szStr);

    format(szMiscArray, sizeof(szMiscArray), "* %s dang luc soat balo cua %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
    ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

    Dialog_Show(playerid, DIALOG_LUCSOATBALO, DIALOG_STYLE_TABLIST_HEADERS, title, szStr, "Dong", "");
    return 1;
}

Dialog:DIALOG_LUCSOATBALO(playerid, response, listitem, inputtext[])
{
    return 1;
}

stock IsIllegalItem(itemid)
{
    switch(itemid)
    {
        case 2: return 1;       // Minigun
        case 23 .. 35: return 1; // SD-Pistol, Colt-9mm, Deagle, Shotgun, Sawn-Off, Spas-12, Uzi, Mp5, AK, M4, Tec9, Rifle, Sniper
        case 41: return 1;       // Hop dan tich hop
        case 44 .. 48: return 1; // M4 LAW, AK LAW, Deagle LAW, 9mm LAW, MP5 LAW
        case 49: return 1;       // Sword Katana
        case 50: return 1;       // Gay Bong Chay
        case 51: return 1;       // Can sa nguyen chat
        case 52: return 1;       // Tui zip can sa
    }
    return 0;
}

CMD:takebalo(playerid, params[])
{
    if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Canh sat!");
    if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerTied[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay ngay bay gio!");

    new giveplayerid;
    if(sscanf(params, "u", giveplayerid))
        return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /takebalo [player]");

    if(!IsPlayerConnected(giveplayerid))
        return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");

    if(giveplayerid == playerid)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lay do tu balo cua chinh minh!");

    if(!ProxDetectorS(8.0, playerid, giveplayerid))
        return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");

    if(PlayerInfo[giveplayerid][pAdmin] >= 2 && !PlayerInfo[giveplayerid][pTogReports])
        return SendClientMessageEx(playerid, COLOR_GREY, "Khong the lay do tu balo cua nguoi nay.");

    new szStr[2048], title[128], count;
    new illegalSlots[MAX_PLAYER_CB_ITEM], illegalCount;

    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[giveplayerid][0][cb_ItemID][i] != INVALID_OBJECT_ID)
        {
            new itemid = CharacterInfo[giveplayerid][0][cb_ItemID][i];
            if(IsIllegalItem(itemid))
            {
                illegalSlots[illegalCount] = i;
                illegalCount++;
            }
        }
    }

    if(illegalCount == 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Khong co vat pham bat hop phap nao trong balo cua nguoi nay.");

    format(title, sizeof(title), "Take balo: %s | Vat pham bat hop phap", GetPlayerNameEx(giveplayerid));
    format(szStr, sizeof(szStr), "#\tVat pham\tSL\tKG\n");

    for(new i = 0; i < illegalCount; i++)
    {
        new slot = illegalSlots[i];
        new itemid = CharacterInfo[giveplayerid][0][cb_ItemID][slot];
        format(szStr, sizeof(szStr), "%s{F5CB42}%d\t{FF6347}%s\t{FFFFFF}%d\t{FFFFFF}%.1f\n",
            szStr, i + 1,
            Inventory_ListItems[itemid - 1],
            CharacterInfo[giveplayerid][0][cb_ItemAmount][slot],
            CharacterInfo[giveplayerid][0][cb_ItemWeight][slot]);
    }

    SetPVarInt(playerid, "TakeBalo_Target", giveplayerid);
    SetPVarInt(playerid, "TakeBalo_Count", illegalCount);

    for(new i = 0; i < illegalCount; i++)
    {
        new key[24];
        format(key, sizeof(key), "TakeBalo_Slot%d", i);
        SetPVarInt(playerid, key, illegalSlots[i]);
    }

    format(szMiscArray, sizeof(szMiscArray), "* %s dang kiem tra balo cua %s de tim vat pham bat hop phap.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
    ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

    Dialog_Show(playerid, DIALOG_TAKEBALO, DIALOG_STYLE_TABLIST_HEADERS, title, szStr, "Take", "Dong");
    return 1;
}

Dialog:DIALOG_TAKEBALO(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    new giveplayerid = GetPVarInt(playerid, "TakeBalo_Target");
    new illegalCount = GetPVarInt(playerid, "TakeBalo_Count");

    if(!IsPlayerConnected(giveplayerid))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi da thoat.");
        return 1;
    }

    if(listitem < 0 || listitem >= illegalCount)
        return 1;

    new key[24];
    format(key, sizeof(key), "TakeBalo_Slot%d", listitem);
    new slot = GetPVarInt(playerid, key);
    new itemid = CharacterInfo[giveplayerid][0][cb_ItemID][slot];
    new amount = CharacterInfo[giveplayerid][0][cb_ItemAmount][slot];

    if(itemid == INVALID_OBJECT_ID)
        return SendClientMessageEx(playerid, COLOR_GREY, "Vat pham nay khong con ton tai.");

    new itemName[64];
    format(itemName, sizeof(itemName), "%s", Inventory_ListItems[itemid - 1]);

    CharacterInfo[giveplayerid][0][cb_ItemID][slot] = INVALID_OBJECT_ID;
    CharacterInfo[giveplayerid][0][cb_ItemAmount][slot] = 0;
    CharacterInfo[giveplayerid][0][cb_ItemWeight][slot] = 0.0;
    CharacterInfo[giveplayerid][0][cb_ItemDurability][slot] = 0;

    format(szMiscArray, sizeof(szMiscArray), "[{FFB561}BALO{FFFFFF}]: Ban da thu giu {FF6347}%s {FFFFFF}(x%d) tu balo cua %s.", itemName, amount, GetPlayerNameEx(giveplayerid));
    SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

    format(szMiscArray, sizeof(szMiscArray), "[{FFB561}BALO{FFFFFF}]: Canh sat %s da thu giu %s (x%d) tu balo cua ban.", GetPlayerNameEx(playerid), itemName, amount);
    SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

    format(szMiscArray, sizeof(szMiscArray), "* %s da thu giu mot vat pham tu balo cua %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
    ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

    new logStr[256], year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour, minute, second);
    format(logStr, sizeof(logStr), "[%04d-%02d-%02d %02d:%02d:%02d] %s (LAW) da thu giu %s (x%d) tu balo cua %s",
        year, month, day, hour, minute, second, GetPlayerNameEx(playerid), itemName, amount, GetPlayerNameEx(giveplayerid));
    Log("logs/TakeBalo.log", logStr);

    return 1;
}

CMD:closeinv(playerid, params[])
{
    DeletePVar(playerid, "Inventory_SelectItem");
    DeletePVar(playerid, "Inventory_SelectTarget");
    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da dong balo.");
    return 1;
}

CMD:use(playerid, params[])
{
    if(!gPlayerLogged{playerid}) return 1;

    new itemid;
    if(sscanf(params, "d", itemid))
        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /use [item_id] — VD: /use 11 (medkit), /use 42 (combo GFC)");

    if(!Balo_IsUsable(itemid))
        return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Vat pham nay khong the su dung truc tiep.");

    // Find item in balo
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] == itemid)
        {
            SetPVarInt(playerid, "Inventory_SelectItem", i);
            SetPVarInt(playerid, "Inventory_SelectTarget", 0);
            Balo_UseItem(playerid, 0, i, itemid);
            return 1;
        }
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong tim thay vat pham nay trong balo.");
    return 1;
}

Dialog:DIALOG_BALO_MAIN(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        DeletePVar(playerid, "BaloDialogOpen");
        return 1;
    }
    if(listitem < 0) return 1;

    new slot = listitem;
    new equipOffset = GetPVarInt(playerid, "Balo_EquipOffset");

    // Check if click is in equipped section
    if(equipOffset > 0 && slot >= equipOffset && slot < equipOffset + 7)
    {
        new equipSlot = slot - equipOffset;
        if(equipSlot < 0 || equipSlot >= 7) return Balo_ShowMain(playerid);

        if(CharacterInfo[playerid][1][cb_ItemID][equipSlot] == INVALID_OBJECT_ID)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Slot trang bi trong.");
            return Balo_ShowMain(playerid);
        }

        new itemid = CharacterInfo[playerid][1][cb_ItemID][equipSlot];
        new title[128], str[256];
        format(title, sizeof(title), "Trang bi: {F5CB42}%s {FFFFFF}| SL: %d", Inventory_ListItems[itemid - 1], CharacterInfo[playerid][1][cb_ItemAmount][equipSlot]);
        format(str, sizeof(str), "{FFFFFF}Xem thong tin\n{FFB561}Thao trang bi");

        SetPVarInt(playerid, "Inventory_SelectItem", equipSlot);
        SetPVarInt(playerid, "Inventory_SelectTarget", 1);
        Dialog_Show(playerid, DIALOG_BALO_ACTION, DIALOG_STYLE_LIST, title, str, "Chon", "Quay lai");
        return 1;
    }

    if(slot < 0 || slot >= MAX_PLAYER_CB_ITEM) return 1;

    if(CharacterInfo[playerid][0][cb_ItemLock][slot] == 1)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Slot nay bi khoa.");
        return Balo_ShowMain(playerid);
    }
    if(CharacterInfo[playerid][0][cb_ItemID][slot] == INVALID_OBJECT_ID)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Slot trong.");
        return Balo_ShowMain(playerid);
    }

    SetPVarInt(playerid, "Inventory_SelectItem", slot);
    SetPVarInt(playerid, "Inventory_SelectTarget", 0);

    new itemid = CharacterInfo[playerid][0][cb_ItemID][slot];
    new title[128], str[512];

    format(title, sizeof(title), "Thao tac: {F5CB42}%s {FFFFFF}| SL: %d", Inventory_ListItems[itemid - 1], CharacterInfo[playerid][0][cb_ItemAmount][slot]);

    // Only show "Su dung" for usable items
    if(Balo_IsUsable(itemid))
        format(str, sizeof(str), "{57FF57}Su dung vat pham\n");

    format(str, sizeof(str), "%s{FFFFFF}Xem thong tin\n", str);

    if(GetIDWeapon(itemid))
    {
        if(Balo_IsItemEquipped(playerid, itemid))
            format(str, sizeof(str), "%s{FFB561}Thao trang bi\n", str);
        else
            format(str, sizeof(str), "%s{FFB561}Trang bi len nguoi\n", str);
    }
    else if(CharacterInfo[playerid][0][cb_ItemAmount][slot] > 1)
        format(str, sizeof(str), "%s{FFB561}Phan tach so luong\n", str);

    format(str, sizeof(str), "%s{FF6347}Vut bo vat pham\n", str);

    if(!GetIDWeapon(itemid) && itemid < 44)
        format(str, sizeof(str), "%s{00BFFF}Chuyen cho nguoi choi\n", str);

    if(itemid == 21 || itemid == 22)
        format(str, sizeof(str), "%s{00BFFF}Tieu thu nhien lieu\n", str);

    if(PlayerInfo[playerid][pAdmin] > 1337)
        format(str, sizeof(str), "%s{888888}Admin Panel\n", str);

    Dialog_Show(playerid, DIALOG_BALO_ACTION, DIALOG_STYLE_LIST, title, str, "Chon", "Quay lai");
    return 1;
}

Dialog:DIALOG_BALO_ACTION(playerid, response, listitem, inputtext[])
{
    if(!response)
        return Balo_ShowMain(playerid);

    new slot = GetPVarInt(playerid, "Inventory_SelectItem");
    new target = GetPVarInt(playerid, "Inventory_SelectTarget");
    if(slot < 0) return Balo_ShowMain(playerid);

    new itemid;
    if(target == 0) itemid = CharacterInfo[playerid][0][cb_ItemID][slot];
    else itemid = CharacterInfo[playerid][1][cb_ItemID][slot];

    if(itemid == INVALID_OBJECT_ID)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Vat pham khong ton tai.");
        return Balo_ShowMain(playerid);
    }

    if(strfind(inputtext, "Su dung vat pham", true) != -1)
    {
        SetPVarInt(playerid, "Inventory_SelectItem", slot);
        SetPVarInt(playerid, "Inventory_SelectTarget", target);
        Balo_UseItem(playerid, target, slot, itemid);
    }
    else if(strfind(inputtext, "Xem thong tin", true) != -1)
    {
        Balo_ShowInfo(playerid, target, slot, itemid);
    }
    else if(strfind(inputtext, "Trang bi len nguoi", true) != -1)
    {
        Balo_EquipWeapon(playerid, slot);
    }
    else if(strfind(inputtext, "Thao trang bi", true) != -1)
    {
        Balo_UnequipWeapon(playerid, itemid);
    }
    else if(strfind(inputtext, "Phan tach so luong", true) != -1)
    {
        new title[128];
        format(title, sizeof(title), "Phan tach: {F5CB42}%s {FFFFFF}(SL: %d)", Inventory_ListItems[itemid - 1], CharacterInfo[playerid][0][cb_ItemAmount][slot]);
        Dialog_Show(playerid, DIALOG_BALO_SPLIT, DIALOG_STYLE_INPUT, title, "{FFFFFF}Nhap so luong muon phan tach:", "Phan tach", "Huy");
    }
    else if(strfind(inputtext, "Vut bo vat pham", true) != -1)
    {
        new title[128];
        format(title, sizeof(title), "Xac nhan vut: {F5CB42}%s", Inventory_ListItems[itemid - 1]);
        new str[256];
        format(str, sizeof(str), "{FFFFFF}Ban co chac chan muon vut {FF6347}%s {FFFFFF}(%d)?\n\n{FF0000}Han dong nay khong the hoan tac!", Inventory_ListItems[itemid - 1], CharacterInfo[playerid][0][cb_ItemAmount][slot]);
        Dialog_Show(playerid, DIALOG_BALO_DROP, DIALOG_STYLE_MSGBOX, title, str, "Vut", "Huy");
    }
    else if(strfind(inputtext, "Tieu thu nhien lieu", true) != -1)
    {
        Balo_ConsumeFuel(playerid, slot, itemid);
    }
    else if(strfind(inputtext, "Chuyen cho nguoi choi", true) != -1)
    {
        Balo_GiveToPlayer(playerid, slot, itemid);
    }
    else if(strfind(inputtext, "Admin Panel", true) != -1)
    {
        if(PlayerInfo[playerid][pAdmin] > 1337)
        {
            SetPVarInt(playerid, "Inventory_SelectItem", slot);
            SetPVarInt(playerid, "Inventory_SelectTarget", target);
            new str[128];
            format(str, sizeof(str), "- {FF0000}Xoa bo\n- Admin: Them so luong\n- Admin: Xem chi tiet");
            Dialog_Show(playerid, DIALOG_INVENTORY_ACTION, DIALOG_STYLE_LIST, "Admin Panel", str, "Chon", "Huy");
        }
    }
    return 1;
}

stock Balo_ShowInfo(playerid, target, slot, itemid)
{
    new title[128], str[512];
    format(title, sizeof(title), "Thong tin: {F5CB42}%s", Inventory_ListItems[itemid - 1]);

    new typeStr[32];
    if(GetIDWeapon(itemid)) typeStr = "Vu khi";
    else if(itemid >= 3 && itemid <= 7) typeStr = "Khoang san";
    else if(itemid >= 37 && itemid <= 39) typeStr = "Hai san";
    else if(itemid == 41) typeStr = "Hop dan";
    else if(itemid >= 18 && itemid <= 20) typeStr = "Hop do";
    else typeStr = "Vat pham";

    format(str, sizeof(str), "{F5CB42}Ten: {FFFFFF}%s\n", Inventory_ListItems[itemid - 1]);
    format(str, sizeof(str), "%s{F5CB42}Loai: {FFFFFF}%s\n", str, typeStr);
    format(str, sizeof(str), "%s{F5CB42}So luong: {FFFFFF}%d", str, CharacterInfo[playerid][target][cb_ItemAmount][slot]);

    if(GetIDWeapon(itemid))
        format(str, sizeof(str), "%s/{FFFFFF}%d (dan)\n", str, GetAmmoWeaponLimit(itemid));
    else
        format(str, sizeof(str), "%s/{FFFFFF}%d (toi da)\n", str, GetAmountItemLimit(itemid));

    format(str, sizeof(str), "%s{F5CB42}Trong luong: {FFFFFF}%.2f kg\n", str, CharacterInfo[playerid][target][cb_ItemWeight][slot]);
    format(str, sizeof(str), "%s{F5CB42}Do ben: {FFFFFF}%d/100\n\n", str, CharacterInfo[playerid][target][cb_ItemDurability][slot]);
    format(str, sizeof(str), "%s{AAAAAA}%s", str, GetItemInfo(itemid));

    Dialog_Show(playerid, DIALOG_BALO_INFO, DIALOG_STYLE_MSGBOX, title, str, "Quay lai", "Dong");
    return 1;
}

Dialog:DIALOG_BALO_INFO(playerid, response, listitem, inputtext[])
{
    #pragma unused listitem, inputtext
    if(response)
        return Balo_ShowMain(playerid);
    DeletePVar(playerid, "BaloDialogOpen");
    return 1;
}

Dialog:DIALOG_BALO_DROP(playerid, response, listitem, inputtext[])
{
    #pragma unused listitem, inputtext
    if(!response)
        return Balo_ShowMain(playerid);

    new slot = GetPVarInt(playerid, "Inventory_SelectItem");
    if(slot < 0 || slot >= MAX_PLAYER_CB_ITEM) return Balo_ShowMain(playerid);

    if(CharacterInfo[playerid][0][cb_ItemID][slot] == INVALID_OBJECT_ID)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Slot trong.");
        return Balo_ShowMain(playerid);
    }

    new itemid = CharacterInfo[playerid][0][cb_ItemID][slot];
    new amount = CharacterInfo[playerid][0][cb_ItemAmount][slot];

    // Check if it's a LAW weapon
    if(itemid >= 44 && itemid <= 48)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong the vut vu khi LAW. Vu khi LAW chi co the thao trang bi.");
        return Balo_ShowMain(playerid);
    }

    RemovePlayerItem(playerid, slot);
    ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);

    new str[128];
    format(str, sizeof(str), "[{FFB561}BALO{FFFFFF}]: Ban da vut %s (x%d).", Inventory_ListItems[itemid - 1], amount);
    SendClientMessageEx(playerid, COLOR_WHITE, str);

    return Balo_ShowMain(playerid);
}

Dialog:DIALOG_BALO_SPLIT(playerid, response, listitem, inputtext[])
{
    #pragma unused listitem
    if(!response)
        return Balo_ShowMain(playerid);

    new slot = GetPVarInt(playerid, "Inventory_SelectItem");
    if(slot < 0 || slot >= MAX_PLAYER_CB_ITEM) return Balo_ShowMain(playerid);

    new itemid = CharacterInfo[playerid][0][cb_ItemID][slot];
    if(itemid == INVALID_OBJECT_ID)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Slot trong.");
        return Balo_ShowMain(playerid);
    }

    new amount = strval(inputtext);
    if(amount <= 0 || amount >= CharacterInfo[playerid][0][cb_ItemAmount][slot])
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: So luong khong hop le.");
        return Balo_ShowMain(playerid);
    }

    // Find empty slot for split items
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemLock][i] == 0 && CharacterInfo[playerid][0][cb_ItemID][i] == INVALID_OBJECT_ID)
        {
            CharacterInfo[playerid][0][cb_ItemID][i] = itemid;
            CharacterInfo[playerid][0][cb_ItemAmount][i] = amount;
            CharacterInfo[playerid][0][cb_ItemWeight][i] = GetItemWeight(itemid);
            CharacterInfo[playerid][0][cb_ItemDurability][i] = CharacterInfo[playerid][0][cb_ItemDurability][slot];

            CharacterInfo[playerid][0][cb_ItemAmount][slot] -= amount;
            CharacterInfo[playerid][0][cb_ItemWeight][slot] = GetItemWeight(itemid);

            new str[128];
            format(str, sizeof(str), "[{FFB561}BALO{FFFFFF}]: Da phan tach %d %s sang slot %d.", amount, Inventory_ListItems[itemid - 1], i + 1);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
            return Balo_ShowMain(playerid);
        }
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong con slot trong de phan tach.");
    return Balo_ShowMain(playerid);
}

stock Balo_EquipWeapon(playerid, slot)
{
    if(slot < 0 || slot >= MAX_PLAYER_CB_ITEM) return 1;

    new itemid = CharacterInfo[playerid][0][cb_ItemID][slot];
    if(itemid == INVALID_OBJECT_ID || !GetIDWeapon(itemid))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Vat pham nay khong phai vu khi.");
        return Balo_ShowMain(playerid);
    }

    new weaponid = GetIDWeapon(itemid);
    new weapontype = GetWeaponType(itemid);

    // Check if already have same weapon type equipped
    // Exception: LAW weapons (44-48) can be equipped alongside normal weapons of same type
    new bool:isNewLAW = (itemid >= 44 && itemid <= 48);
    for(new i = 0; i < 7; i++)
    {
        if(CharacterInfo[playerid][1][cb_ItemID][i] != INVALID_OBJECT_ID)
        {
            if(CharacterInfo[playerid][1][cb_ItemID][i] == itemid)
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da mang vu khi nay roi.");
                return Balo_ShowMain(playerid);
            }
            new bool:isEquippedLAW = (CharacterInfo[playerid][1][cb_ItemID][i] >= 44 && CharacterInfo[playerid][1][cb_ItemID][i] <= 48);
            // Allow LAW + normal of same type, but block same type otherwise
            if(GetWeaponType(CharacterInfo[playerid][1][cb_ItemID][i]) == weapontype && !(isNewLAW || isEquippedLAW))
            {
                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da mang vu khi cung loai.");
                return Balo_ShowMain(playerid);
            }
        }
    }

    // Find empty equip slot
    for(new i = 0; i < 7; i++)
    {
        if(CharacterInfo[playerid][1][cb_ItemLock][i] == 0 && CharacterInfo[playerid][1][cb_ItemID][i] == INVALID_OBJECT_ID)
        {
            CharacterInfo[playerid][1][cb_ItemID][i] = CharacterInfo[playerid][0][cb_ItemID][slot];
            CharacterInfo[playerid][1][cb_ItemWeight][i] = CharacterInfo[playerid][0][cb_ItemWeight][slot];
            CharacterInfo[playerid][1][cb_ItemDurability][i] = CharacterInfo[playerid][0][cb_ItemDurability][slot];
            CharacterInfo[playerid][1][cb_ItemAmount][i] = CharacterInfo[playerid][0][cb_ItemAmount][slot];

            // Item stays in bag - don't remove from tab [0]

            GivePlayerValidWeaponEx(playerid, weaponid, CharacterInfo[playerid][1][cb_ItemAmount][i]);
            SetPlayerAmmo(playerid, weaponid, CharacterInfo[playerid][1][cb_ItemAmount][i]);

            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da trang bi vu khi.");
            return Balo_ShowMain(playerid);
        }
    }

    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong con slot trang bi trong.");
    return Balo_ShowMain(playerid);
}

stock Balo_UnequipWeapon(playerid, itemid)
{
    for(new i = 0; i < 7; i++)
    {
        if(CharacterInfo[playerid][1][cb_ItemID][i] == itemid)
        {
            // Sync ammo from equip [1] back to bag [0]
            new currentAmmo = CharacterInfo[playerid][1][cb_ItemAmount][i];
            for(new k = 0; k < MAX_PLAYER_CB_ITEM; k++)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][k] == itemid)
                {
                    CharacterInfo[playerid][0][cb_ItemAmount][k] = currentAmmo;
                    CharacterInfo[playerid][0][cb_ItemWeight][k] = GetItemWeight(itemid);
                    break;
                }
            }

            CharacterInfo[playerid][1][cb_ItemID][i] = INVALID_OBJECT_ID;
            CharacterInfo[playerid][1][cb_ItemWeight][i] = 0.0;
            CharacterInfo[playerid][1][cb_ItemDurability][i] = 0;
            CharacterInfo[playerid][1][cb_ItemAmount][i] = 0;

            // Remove SA-MP weapon
            new weaponid = GetIDWeapon(itemid);
            if(weaponid > 0) ResetPlayerWeapons(playerid);

            // Re-equip remaining weapons from tab [1]
            for(new j = 0; j < 7; j++)
            {
                if(CharacterInfo[playerid][1][cb_ItemID][j] != INVALID_OBJECT_ID)
                {
                    new wid = GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][j]);
                    if(wid > 0) GivePlayerValidWeaponEx(playerid, wid, CharacterInfo[playerid][1][cb_ItemAmount][j]);
                }
            }

            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da thao trang bi vu khi.");
            return Balo_ShowMain(playerid);
        }
    }
    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong tim thay vu khi dang trang bi.");
    return Balo_ShowMain(playerid);
}

stock Balo_UseItem(playerid, target, slot, itemid)
{
    #pragma unused target
    new isAdmin = (PlayerInfo[playerid][pAdmin] > 1337);
    // Medkit
    if(itemid == 11)
    {
        SetPVarInt(playerid, "usg_ItemIDs", 11);
        SetPVarInt(playerid, "usg_ItemTimers", 15);
        ItemGain(playerid, 1);
        DeletePVar(playerid, "BaloDialogOpen");
        return 1;
    }
    // Gatacetamol
    if(itemid == 12)
    {
        SetPVarInt(playerid, "usg_ItemIDs", 12);
        SetPVarInt(playerid, "usg_ItemTimers", 15);
        ItemGain(playerid, 1);
        DeletePVar(playerid, "BaloDialogOpen");
        return 1;
    }
    // Coin Exchange
    if(itemid == 10)
    {
        new string[456];
        SetPVarInt(playerid, "Exchange_Coin_Request", 1);
        format(string, sizeof(string), "Ban dang su dung vat pham {FF0000}'CHUYEN DOI GP SANG COIN'{FFFFFF}\n\
        So GP ban hien dang co: {62FF00}%d{FFFFFF}.\n\n\
        Bang quy doi:\n\
        \t1 coin\t1,000 GP\n\
        \t10 coin\t10,000 GP\n\
        \t100 coin\t100,000 GP\n\
        \t1000 coin\t1,000,000 GP\n\n\
        Hay nhan 'Dong Y' neu nhu ban muon chuyen doi hoac 'Huy' neu khong muon chuyen doi",
        PlayerData[playerid][pc_GP]);
        return Dialog_Show(playerid, DG_EXCHANGE_COIN, DIALOG_STYLE_MSGBOX, "Coin Exchange", string, "Dong Y", "Huy");
    }
    // Ammo Box
    if(itemid == 41)
    {
        // Check if any weapons equipped
        new hasWeapon = 0;
        for(new i = 0; i < 7; i++)
        {
            if(CharacterInfo[playerid][1][cb_ItemID][i] != INVALID_OBJECT_ID && GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]))
            {
                hasWeapon = 1;
                break;
            }
        }
        if(!hasWeapon)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong co vu khi nao dang trang bi. Hay trang bi vu khi truoc khi nap dan.");
            return Balo_ShowMain(playerid);
        }
        new string[560];
        format(string, sizeof(string), "Slot\tVu khi\tSo dan\n");
        for(new i = 0; i < 7; i++)
        {
            if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]))
            {
                if(CharacterInfo[playerid][1][cb_ItemID][i] == 8 || CharacterInfo[playerid][1][cb_ItemID][i] == 9)
                    format(string, sizeof(string), "%s%d\tMay khai thac\t{FF0000}Khong the nap\n", string, i + 1);
                else if(CharacterInfo[playerid][1][cb_ItemAmount][i] >= GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][i]))
                    format(string, sizeof(string), "%s%d\t%s\t{2D9410}Da day dan\n", string, i + 1, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1]);
                else
                    format(string, sizeof(string), "%s%d\t%s\t%d/%d\n", string, i + 1, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1], CharacterInfo[playerid][1][cb_ItemAmount][i], GetAmmoWeaponLimit(CharacterInfo[playerid][1][cb_ItemID][i]));
            }
            if(CharacterInfo[playerid][1][cb_ItemID][i] == INVALID_OBJECT_ID)
                format(string, sizeof(string), "%s%d\t--\t--/--\n", string, i + 1);
        }
        return Dialog_Show(playerid, DIALOG_AMMOBOX_WPChoice, DIALOG_STYLE_TABLIST_HEADERS, "Nap dan vu khi", string, "Nap", "Huy");
    }
    // Combo GFC
    if(itemid == 42)
    {
        PlayerData[playerid][pc_FoodBar] = 100;
        PlayerData[playerid][pc_WaterBar] = 100;
        Update_Hunger(playerid);
        if(!isAdmin) {
            CharacterInfo[playerid][0][cb_ItemAmount][slot]--;
            if(CharacterInfo[playerid][0][cb_ItemAmount][slot] <= 0)
                RemovePlayerItem(playerid, slot);
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da an Combo GFC. Thuc an va nuoc day.");
        return Balo_ShowMain(playerid);
    }
    // Treasure Map
    if(itemid == 43)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban dang xem ban do kho bau...");
        DeletePVar(playerid, "BaloDialogOpen");
        defer ShowBDKBTimer(playerid);
        return 1;
    }
    // Jerry Can - show vehicle list
    if(itemid == 21 || itemid == 22)
    {
        return Balo_ConsumeFuel(playerid, slot, itemid);
    }
    // Slot Card
    if(itemid == 13)
    {
        // Find first locked slot and unlock it
        for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
        {
            if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
            {
                CharacterInfo[playerid][0][cb_ItemLock][i] = 0;
                if(!isAdmin) {
                    CharacterInfo[playerid][0][cb_ItemAmount][slot]--;
                    if(CharacterInfo[playerid][0][cb_ItemAmount][slot] <= 0)
                        RemovePlayerItem(playerid, slot);
                }
                SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da mo khoa them 1 slot balo.");
                return Balo_ShowMain(playerid);
            }
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong con slot bi khoa nao.");
        return Balo_ShowMain(playerid);
    }
    // Bonus Cards
    if(itemid >= 14 && itemid <= 17)
    {
        if(!isAdmin) {
            CharacterInfo[playerid][0][cb_ItemAmount][slot]--;
            if(CharacterInfo[playerid][0][cb_ItemAmount][slot] <= 0)
                RemovePlayerItem(playerid, slot);
        }
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban da su dung the bonus.");
        return Balo_ShowMain(playerid);
    }
    // Default: can't use
    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Vat pham nay khong the su dung truc tiep.");
    return Balo_ShowMain(playerid);
}

stock Balo_GiveToPlayer(playerid, slot, itemid)
{
    new title[128];
    format(title, sizeof(title), "Chuyen: {F5CB42}%s {FFFFFF}(SL: %d)", Inventory_ListItems[itemid - 1], CharacterInfo[playerid][0][cb_ItemAmount][slot]);
    Dialog_Show(playerid, DIALOG_BALO_GIVE, DIALOG_STYLE_INPUT, title, "{FFFFFF}Nhap ID nguoi choi can chuyen:", "Chuyen", "Huy");
    return 1;
}

Dialog:DIALOG_BALO_GIVE(playerid, response, listitem, inputtext[])
{
    #pragma unused listitem
    if(!response)
        return Balo_ShowMain(playerid);

    new slot = GetPVarInt(playerid, "Inventory_SelectItem");
    if(slot < 0 || slot >= MAX_PLAYER_CB_ITEM) return Balo_ShowMain(playerid);

    new itemid = CharacterInfo[playerid][0][cb_ItemID][slot];
    if(itemid == INVALID_OBJECT_ID)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Vat pham khong ton tai.");
        return Balo_ShowMain(playerid);
    }

    new targetid = strval(inputtext);
    if(targetid == playerid)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Khong the chuyen cho chinh minh.");
        return Balo_ShowMain(playerid);
    }
    if(!IsPlayerConnected(targetid) || !gPlayerLogged{targetid})
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]:Nguoi choi khong ton tai hoac chua dang nhap.");
        return Balo_ShowMain(playerid);
    }
    if(!ProxDetectorS(5.0, playerid, targetid))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]:Nguoi choi qua xa.");
        return Balo_ShowMain(playerid);
    }

    new amount = CharacterInfo[playerid][0][cb_ItemAmount][slot];
    new success = GivePlayerItem(targetid, itemid, amount);

    if(success)
    {
        RemovePlayerItem(playerid, slot);

        new str[128];
        format(str, sizeof(str), "[{FFB561}BALO{FFFFFF}]: Ban da chuyen %s (x%d) cho %s.", Inventory_ListItems[itemid - 1], amount, GetPlayerNameEx(targetid));
        SendClientMessageEx(playerid, COLOR_WHITE, str);

        format(str, sizeof(str), "[{FFB561}BALO{FFFFFF}]: Ban nhan duoc %s (x%d) tu %s.", Inventory_ListItems[itemid - 1], amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(targetid, COLOR_WHITE, str);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]:Nguoi choi khong con slot trong hoac qua nang.");
    }

    return Balo_ShowMain(playerid);
}

stock Balo_ConsumeFuel(playerid, slot, itemid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == 0)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Ban can ngoi trong xe de do xang.");
        return Balo_ShowMain(playerid);
    }

    new currentAmount = CharacterInfo[playerid][0][cb_ItemAmount][slot];
    if(currentAmount <= 0)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Bin xang trong.");
        return Balo_ShowMain(playerid);
    }

    new Float:currentFuel = VehicleFuel[vehicleid];
    new Float:maxFuel = 100.0;
    new Float:needed = maxFuel - currentFuel;

    if(needed <= 0)
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}BALO{FFFFFF}]: Xe da day xang.");
        return Balo_ShowMain(playerid);
    }

    new Float:toAdd = (float(currentAmount) < needed) ? float(currentAmount) : needed;
    VehicleFuel[vehicleid] = currentFuel + toAdd;

    if(VehicleFuel[vehicleid] > 100.0)
    {
        new Float:excess = VehicleFuel[vehicleid] - 100.0;
        VehicleFuel[vehicleid] = 100.0;
        toAdd -= excess;
    }

    CharacterInfo[playerid][0][cb_ItemAmount][slot] -= floatround(toAdd);
    if(CharacterInfo[playerid][0][cb_ItemAmount][slot] <= 0)
        RemovePlayerItem(playerid, slot);

    new str[128];
    format(str, sizeof(str), "[{FFB561}BALO{FFFFFF}]: Ban da do %.0f lit xang vao xe.", toAdd);
    SendClientMessageEx(playerid, COLOR_WHITE, str);

    return Balo_ShowMain(playerid);
}

CMD:gtasa_givemyitem(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        if(PlayerInfo[playerid][pAdmin] > 1337)
        {
            new str[1024], i;
            SetPVarInt(playerid, "AdminYourSelf", 1);
            for(i = 0 ; i < sizeof(Inventory_ListItems) ; i++)
            {
                format(str, sizeof(str), "%s\n(%d) %s", str, i, Inventory_ListItems[i]);
            }
            Dialog_Show(playerid, DG_INVENTORY_GIVE_ITEM, DIALOG_STYLE_LIST, "List of Items", str, "Chon", "Huy");
        }
    }
    return 1;
}

timer ShowBDKBTimer[2000](playerid)
{
    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban dang xem ban do kho bau, hay nhan ESC hoac click nut X de tat neu nhu khong muon xem nua.");
    // PTD_BDKB requires famed-mission.inc - stubbed out
    // for(new i = 0 ; i < 6 ; i++)
    // {
    //     PlayerTextDrawShow(playerid, PTD_BDKB[playerid][i]);
    // }
    SelectTextDraw(playerid, 0xFF422485);
    // ShowBDKB[playerid] = 1;
    return 1;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    new i;
    if(playerid != INVALID_PLAYER_ID)
    {
        if(weaponid > 0)
        {
            for(i = 0 ; i < 7 ; i++)
			{
				if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == weaponid)
				{
					if(CharacterInfo[playerid][1][cb_ItemAmount][i] > 0)
					{
						CharacterInfo[playerid][1][cb_ItemAmount][i]--;
						SetPlayerAmmo(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]), CharacterInfo[playerid][1][cb_ItemAmount][i]);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Vu khi cua ban da het dan.");
					}
				}
			}
        }
    }
    return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
    new i, z;
    new str[35];
    if(GetPVarInt(playerid, "CheckDialogInventory") == 1) return 1;
    if(playertextid == GTASA_Inventory[playerid][0][59])
    {
        if(GTASA_Inventory[playerid][0][59] != PlayerText:INVALID_TEXT_DRAW)
        {
            if(Guide_ReadPost[playerid] == 0 || Guide_ReadPost[playerid] == 1) return 1;
            Guide_ReadPost[playerid]--;
            Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
        }
    }
    if(playertextid == GTASA_Inventory[playerid][0][60])
    {
        if(GTASA_Inventory[playerid][0][60] != PlayerText:INVALID_TEXT_DRAW)
        {
            Guide_ReadPost[playerid]++;
            Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
        }  
    }
    if(playertextid == GTASA_Inventory[playerid][0][4])
    {
        if(GTASA_Inventory[playerid][0][4] != PlayerText:INVALID_TEXT_DRAW)
        {
            switch(Inventory_Character[playerid])
            {
                case 1:
                {
                    Inventory_Character[playerid] = 0;
                }
                default:
                {
                    Inventory_Character[playerid] = 1;
                }
            }
            Inventory_Action(playerid, 2);
        }
    }
    if(playertextid == GTASA_Inventory[playerid][0][2])
    {
        callcmd::closeinv(playerid, "");
    }
    if(playertextid == GTASA_Inventory[playerid][0][3])
    {
        Inventory_Action(playerid, 3);
    }
    for(i = 6 ; i < 55 ; i++)
    {
        if(i == 6) PlayerPlaySound(playerid, 14405, 0.0, 0.0, 0.0);
        if(i <= 12)
        {
            if(playertextid == GTASA_Inventory[playerid][0][i])
            {
                if(GTASA_Inventory[playerid][0][i] != PlayerText:INVALID_TEXT_DRAW)
                {
                    if(GetPVarInt(playerid, "TimeRefreshInventory") == 3) break;
                    if(GetPVarInt(playerid, "Inventory_SelectItem") == -1)
                    {
                        SetPVarInt(playerid, "Inventory_SelectTarget", 1);
                        if(CharacterInfo[playerid][1][cb_ItemLock][i - 6] == 0 && CharacterInfo[playerid][1][cb_ItemID][i - 6] != INVALID_OBJECT_ID)
                        {
                            SetPVarInt(playerid, "Inventory_SelectItem", i - 6);
                            Inventory_Action(playerid, 4);
                            return 1;
                        }
                        if(CharacterInfo[playerid][1][cb_ItemLock][i - 6] == 1 || CharacterInfo[playerid][1][cb_ItemID][i - 6] == INVALID_OBJECT_ID)
                        {
                            for(z = 0 ; z < MAX_PLAYER_TD_INVENTORYINFO ; z++)
                            {
                                PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][z]);
                            }
                            return 1;
                        }
                    }
                    if(GetPVarInt(playerid, "Inventory_SelectItem") != -1)
                    {
                        switch(GetPVarInt(playerid, "Inventory_SelectTarget"))
                        {
                            case 0:
                            {
                                if(CharacterInfo[playerid][0][cb_ItemLock][GetPVarInt(playerid, "Inventory_SelectItem")] == 0 && CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                                {
                                    if(GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]))
                                    {
                                        new weaponid = GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                                        new weapontype = GetWeaponType(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                                        for(z = 0 ; z < 7 ; z++)
                                        {
                                            if(CharacterInfo[playerid][1][cb_ItemID][z] != INVALID_OBJECT_ID)
                                            {
                                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][z]) == weaponid) // <-- Sau này add thêm cơ chế kiểm tra súng cùng loại (smg <=> smg ,...)
                                                {
                                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                                    return 1;
                                                }
                                                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][z]) == -1001 && weaponid == -1000 || GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][z]) == -1000 && weaponid == -1001)
                                                {
                                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                                    return 1;
                                                }
                                                if(GetWeaponType(CharacterInfo[playerid][1][cb_ItemID][z]) == weapontype)
                                                {
                                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the tiep tuc mang them vu khi nay nua.");
                                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                                    return 1;
                                                }
                                            }
                                        }
                                        if(CharacterInfo[playerid][1][cb_ItemLock][i - 6] == 0 && CharacterInfo[playerid][1][cb_ItemID][i - 6] == INVALID_OBJECT_ID)
                                        {
                                            CharacterInfo[playerid][1][cb_ItemID][i - 6] = CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")];
                                            CharacterInfo[playerid][1][cb_ItemWeight][i - 6] = CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")];
                                            CharacterInfo[playerid][1][cb_ItemDurability][i - 6] = CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")];
                                            CharacterInfo[playerid][1][cb_ItemAmount][i - 6] = CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];

                                            CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                                            CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                                            CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                                            format(str, sizeof(str), "%s", GetItemMDL(CharacterInfo[playerid][1][cb_ItemID][i - 6]));
                                            PlayerTextDrawSetString(playerid, GTASA_Inventory[playerid][0][i], str);
                                            Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
                                            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban da mang mot trang bi len nguoi.");

                                            GivePlayerValidWeaponEx(playerid, GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i - 6]), CharacterInfo[playerid][1][cb_ItemAmount][i - 6]);

                                            return 1;
                                        }
                                        if(CharacterInfo[playerid][1][cb_ItemLock][i - 6] == 0 && CharacterInfo[playerid][1][cb_ItemID][i - 6] != INVALID_OBJECT_ID)
                                        {
                                            Inventory_Action(playerid, 4);
                                            SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                            SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                            return 1;
                                        }
                                    }
                                    else
                                    {
                                        SetPVarInt(playerid, "Inventory_SelectTarget", 1);
                                        SetPVarInt(playerid, "Inventory_SelectItem", i-6);
                                        Inventory_Action(playerid, 4);
                                        return 1;
                                    }
                                }
                            }
                            case 1:
                            {
                                SetPVarInt(playerid, "Inventory_SelectTarget", 1);
                                if(CharacterInfo[playerid][1][cb_ItemLock][i - 6] == 0 && CharacterInfo[playerid][1][cb_ItemID][i - 6] != INVALID_OBJECT_ID)
                                {
                                    if(GetPVarInt(playerid, "Inventory_SelectTarget") == 1 && GetPVarInt(playerid, "Inventory_SelectItem") == i - 6)
                                    {
                                        for(z = 0 ; z < MAX_PLAYER_TD_INVENTORYINFO ; z++)
                                        {
                                            PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][z]);
                                        }
                                        SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                        SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                        return 1;
                                    }
                                    SetPVarInt(playerid, "Inventory_SelectItem", i - 6);
                                    Inventory_Action(playerid, 4);
                                    return 1;
                                }
                                if(CharacterInfo[playerid][1][cb_ItemLock][i - 6] == 1 || CharacterInfo[playerid][1][cb_ItemID][i - 6] == INVALID_OBJECT_ID)
                                {
                                    for(z = 0 ; z < MAX_PLAYER_TD_INVENTORYINFO ; z++)
                                    {
                                        PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][z]);
                                    }
                                    SetPVarInt(playerid, "Inventory_SelectItem", -1);
                                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                                    return 1;
                                }
                            }
                        }
                    }
                }
            }
        }
        if(i > 12)
        {
            if(playertextid == GTASA_Inventory[playerid][0][i])
            {
                if(GTASA_Inventory[playerid][0][i] != PlayerText:INVALID_TEXT_DRAW)
                {
                    new index;
                    switch(Guide_ReadPost[playerid])
                    {
                        case 1:
                        {
                            index = i - 13;
                            //printf("i - 13 = %d", i - 13);
                        }
                        case 2:
                        {
                            index = i + 29;
                            //printf("i + 29 = %d", i + 29);
                        }
                    }
                    SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                    if(CharacterInfo[playerid][0][cb_ItemLock][index] == 0 && CharacterInfo[playerid][0][cb_ItemID][index] != INVALID_OBJECT_ID)
                    {
                        if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") != index && GetPVarInt(playerid, "Inventory_GraftingItem") != 0)
                        {
                            if(CharacterInfo[playerid][0][cb_ItemID][index] == CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")])
                            {
                                if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] > 0 && GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]) == 0)
                                {
                                    if(CharacterInfo[playerid][0][cb_ItemAmount][index] == GetAmountItemLimit(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]))
                                    {
                                        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Vat pham nay khong con cho chua de ghep...");
                                        SetPVarInt(playerid, "Inventory_GraftingItem", 0);
                                        SetPVarInt(playerid, "Inventory_SelectItem", index);
                                    }
                                    else
                                    {
                                        CharacterInfo[playerid][0][cb_ItemAmount][index] += CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];
                                        if(CharacterInfo[playerid][0][cb_ItemAmount][index] > GetAmountItemLimit(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]))
                                        {
                                            new new_value = CharacterInfo[playerid][0][cb_ItemAmount][index] - GetAmountItemLimit(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")]);
                                            CharacterInfo[playerid][0][cb_ItemAmount][index] -= new_value;
                                            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] -= new_value;
                                            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da ghep vat pham thanh cong...");
                                            SetPVarInt(playerid, "Inventory_GraftingItem", 0);
                                            if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] <= 0)
                                            {
                                                CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                                                CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                                                CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                                CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                            }
                                        }
                                        else
                                        {
                                            CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Da ghep vat pham thanh cong...");
                                            SetPVarInt(playerid, "Inventory_GraftingItem", 0);
                                            if(CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] <= 0)
                                            {
                                                CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                                                CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                                                CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                                CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                            }
                                        }
                                    }
                                    Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
                                    SetPVarInt(playerid, "Inventory_SelectItem", index);
                                    PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0); // am thanh ghep
                                }
                                else
                                {
                                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Loi xay ra trong qua trinh ghep...");
                                    SetPVarInt(playerid, "Inventory_GraftingItem", 0);
                                    SetPVarInt(playerid, "Inventory_SelectItem", index);
                                }
                            }
                        }
                        if(GetPVarInt(playerid, "Inventory_SelectTarget") == 0 && GetPVarInt(playerid, "Inventory_SelectItem") == index)
                        {
                            for(z = 0 ; z < MAX_PLAYER_TD_INVENTORYINFO ; z++)
                            {
                                PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][z]);
                            }
                            SetPVarInt(playerid, "Inventory_SelectItem", -1);
                            SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                            return 1;
                        }
                        SetPVarInt(playerid, "Inventory_SelectItem", index);
                        Inventory_Action(playerid, 4);
                        //print("Da hien");
                    }
                    if(CharacterInfo[playerid][0][cb_ItemLock][index] == 0 && CharacterInfo[playerid][0][cb_ItemID][index] == INVALID_OBJECT_ID)
                    {
                        switch(GetPVarInt(playerid, "Inventory_SelectTarget"))
                        {
                            case 0:
                            {
                                if(GetPVarInt(playerid, "Inventory_SelectItem") != -1)
                                {
                                    if(CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] != INVALID_OBJECT_ID)
                                    {
                                        CharacterInfo[playerid][0][cb_ItemID][index] = CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")];
                                        CharacterInfo[playerid][0][cb_ItemWeight][index] = CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")];
                                        CharacterInfo[playerid][0][cb_ItemDurability][index] = CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")];
                                        CharacterInfo[playerid][0][cb_ItemAmount][index] = CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")];

                                        CharacterInfo[playerid][0][cb_ItemID][GetPVarInt(playerid, "Inventory_SelectItem")] = INVALID_OBJECT_ID;
                                        CharacterInfo[playerid][0][cb_ItemWeight][GetPVarInt(playerid, "Inventory_SelectItem")] = 0.0;
                                        CharacterInfo[playerid][0][cb_ItemDurability][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;
                                        CharacterInfo[playerid][0][cb_ItemAmount][GetPVarInt(playerid, "Inventory_SelectItem")] = 0;

                                        SetPVarInt(playerid, "Inventory_SelectItem", index);
                                        Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
                                        Inventory_Action(playerid, 4);
                                    }
                                }
                            }
                        }
                    } 
                    if(CharacterInfo[playerid][0][cb_ItemLock][index] == 1 || CharacterInfo[playerid][0][cb_ItemID][index] == INVALID_OBJECT_ID)
                    {
                        if(GetPVarInt(playerid, "Inventory_SelectItem") == -1)
                        {
                            for(z = 0 ; z < MAX_PLAYER_TD_INVENTORYINFO ; z++)
                            {
                                PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][1][z]);
                            }
                            SetPVarInt(playerid, "Inventory_SelectItem", -1);
                            SetPVarInt(playerid, "Inventory_SelectTarget", 0);
                            //print("Da xoa");
                        }
                    }
                }
            }
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0 ; i < MAX_PLAYER_TD_INVENTORY ; i++)
    {
        PlayerTextDrawDestroy(playerid, GTASA_Inventory[playerid][0][i]);
        GTASA_Inventory[playerid][0][i] = PlayerText:INVALID_TEXT_DRAW;
        if(i < MAX_PLAYER_TD_INVENTORYINFO) GTASA_Inventory[playerid][1][i] = PlayerText:INVALID_TEXT_DRAW;
        DeletePVar(playerid, "TimeRefreshInventory");
        DeletePVar(playerid, "AdminYourSelf");
        DeletePVar(playerid, "Inventory_SelectItem");
        DeletePVar(playerid, "Inventory_SelectTarget");
        DeletePVar(playerid, "Exchange_Coin_Request");
        DeletePVar(playerid, "Inventory_GraftingItem");
        DeletePVar(playerid, "CheckDialogInventory");
        KillTimer(Inventory_Timer[playerid]);
        Inventory_Character[playerid] = 0;
        Inventory_Show[playerid] = 0;
    }
    if(gPlayerLogged{playerid} || PlayerInfo[playerid][pId] > 0)
    {
        Inventory_SaveData(playerid);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (PRESSED(KEY_ANALOG_LEFT))
    {
        new weaponid = GetPlayerWeapon(playerid);
        
        if (weaponid <= 0 || weaponid == 41 || weaponid == 42 || weaponid == 43) return 1;

        new item_slot = -1;
        new i, z;
        
        for (i = 0; i < 7; i++)
        {
            if (GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == weaponid)
            {
                item_slot = i;
                break;
            }
        }
        
        if (item_slot == -1) return 1;

        new item_id = CharacterInfo[playerid][1][cb_ItemID][item_slot];
        new max_ammo_limit = GetAmmoWeaponLimit(item_id);
        new current_ammo = CharacterInfo[playerid][1][cb_ItemAmount][item_slot];
        
        new ammo_needed = max_ammo_limit - current_ammo;
        
        if (ammo_needed <= 0) 
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Vu khi cua ban da day!");
            return 1;
        }

        new total_available_ammo = 0;
        
        for (z = 0; z < MAX_PLAYER_CB_ITEM; z++)
        {
            if (CharacterInfo[playerid][0][cb_ItemID][z] == 41 && CharacterInfo[playerid][0][cb_ItemAmount][z] > 0)
            {
                total_available_ammo += CharacterInfo[playerid][0][cb_ItemAmount][z];
            }
        }
        
        if (total_available_ammo == 0) 
        {
            SendClientMessageEx(playerid, COLOR_GREEN, "** Ban khong co hop dan nao de nap.");
            return 1;
        }

        new ammo_to_add = min(ammo_needed, total_available_ammo);
        
        CharacterInfo[playerid][1][cb_ItemAmount][item_slot] += ammo_to_add;
        SetPlayerAmmo(playerid, weaponid, CharacterInfo[playerid][1][cb_ItemAmount][item_slot]);
        
        new ammo_to_remove = ammo_to_add; 

        for (z = 0; z < MAX_PLAYER_CB_ITEM; z++)
        {
            if (ammo_to_remove <= 0) break;

            if (CharacterInfo[playerid][0][cb_ItemID][z] == 41 && CharacterInfo[playerid][0][cb_ItemAmount][z] > 0)
            {
                new current_box_amount = CharacterInfo[playerid][0][cb_ItemAmount][z];
                
                if (current_box_amount >= ammo_to_remove)
                {
                    CharacterInfo[playerid][0][cb_ItemAmount][z] -= ammo_to_remove;
                    ammo_to_remove = 0;
                }
                else
                {
                    ammo_to_remove -= current_box_amount;
                    CharacterInfo[playerid][0][cb_ItemAmount][z] = 0;
                }
                
                if (CharacterInfo[playerid][0][cb_ItemAmount][z] <= 0)
                {
                    CharacterInfo[playerid][0][cb_ItemID][z] = INVALID_OBJECT_ID;
                    CharacterInfo[playerid][0][cb_ItemWeight][z] = 0.0;
                    CharacterInfo[playerid][0][cb_ItemDurability][z] = 0;
                    CharacterInfo[playerid][0][cb_ItemAmount][z] = 0;
                }
            }
        }
        
        new str[124];
        format(str, sizeof(str), "[{FFB561}TUI DO{FFFFFF}]: Ban da nap them %d vien dan cho %s.", ammo_to_add, Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][item_slot] - 1]);
        SendClientMessageEx(playerid, COLOR_WHITE, str);
    }

    // Hotkey H (KEY_CTRL_BACK) to open balo
    if(PRESSED(KEY_CTRL_BACK))
    {
        if(GetPVarInt(playerid, "BaloDialogOpen") == 1) return 1;

        if(gPlayerLogged{playerid} && !GetPVarType(playerid, "PlayerCuffed") && GetPVarInt(playerid, "pBagged") < 1 && !GetPVarType(playerid, "Injured") && !GetPVarType(playerid, "IsFrozen"))
        {
            if(Inventory_Show[playerid] == 0)
            {
                callcmd::balo(playerid, "");
            }
        }
    }

    return 1;
}

hook OnPlayerConnect(playerid)
{
    new i, z;
    for(i = 0 ; i < MAX_PLAYER_TD_INVENTORY ; i++)
    {
        GTASA_Inventory[playerid][0][i] = PlayerText:INVALID_TEXT_DRAW;
        if(i < MAX_PLAYER_TD_INVENTORYINFO) GTASA_Inventory[playerid][1][i] = PlayerText:INVALID_TEXT_DRAW;
        SetPVarInt(playerid, "TimeRefreshInventory", 0);
        SetPVarInt(playerid, "AdminYourSelf", 0);
        SetPVarInt(playerid, "Inventory_SelectItem", -1);
        SetPVarInt(playerid, "Inventory_SelectTarget", 0);
        SetPVarInt(playerid, "Exchange_Coin_Request", 0);
        SetPVarInt(playerid, "Inventory_GraftingItem", 0);
        SetPVarInt(playerid, "CheckDialogInventory", 0);
        KillTimer(Inventory_Timer[playerid]);
        Inventory_Character[playerid] = 0;
        Inventory_Show[playerid] = 0;
    }
    for(i = 0 ; i < MAX_INTERFACE ; i++)
    {
        CharacterInfo[playerid][i][cb_Weight] = 0.0;
        for(z = 0 ; z < MAX_PLAYER_CB_ITEM ; z++)
        {
            if(i == 1 && z > 6) break;
            CharacterInfo[playerid][i][cb_ItemLock][z] = 1;
            CharacterInfo[playerid][i][cb_ItemID][z] = INVALID_OBJECT_ID;
            CharacterInfo[playerid][i][cb_ItemWeight][z] = 0.0;
            CharacterInfo[playerid][i][cb_ItemDurability][z] = 0;
            CharacterInfo[playerid][i][cb_ItemAmount][z] = 0;
            strcpy(cb_ItemSerial[playerid][i][z], "0", 0);
        }
    }
    // ShowBDKB[playerid] = 0;
    return 1;
}