#if defined _modules_useitemgain_included
    #endinput
#endif

#define _modules_useitemgain_included

#include <YSI_Coding\y_hooks>

#define MAX_ITEM_GAIN 4

enum usg_Info
{
    usg_ItemID[MAX_ITEM_GAIN],
    usg_ItemTimer[MAX_ITEM_GAIN]
};
new UseItemGain[MAX_PLAYERS][usg_Info];

new usg_TimerTerminator[MAX_PLAYERS][MAX_ITEM_GAIN];
new usg_TimerUse[MAX_PLAYERS][MAX_ITEM_GAIN];

new PlayerText: PTD_ItemGain[MAX_PLAYERS][8];

Function: CPTD_ItemGain(playerid)
{
    PTD_ItemGain[playerid][0] = CreatePlayerTextDraw(playerid, 111.000, 423.000, "mdl-2002:item_gatacetamol");
    PlayerTextDrawTextSize(playerid, PTD_ItemGain[playerid][0], 18.000, 21.000);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][0], 1);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][0], -12254977);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][0], 255);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][0], 1);

    PTD_ItemGain[playerid][1] = CreatePlayerTextDraw(playerid, 131.000, 423.000, "mdl-2002:item_gatacetamol");
    PlayerTextDrawTextSize(playerid, PTD_ItemGain[playerid][1], 18.000, 21.000);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][1], 1);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][1], -12254977);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][1], 255);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][1], 1);

    PTD_ItemGain[playerid][2] = CreatePlayerTextDraw(playerid, 151.000, 423.000, "mdl-2002:item_gatacetamol");
    PlayerTextDrawTextSize(playerid, PTD_ItemGain[playerid][2], 18.000, 21.000);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][2], 1);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][2], -12254977);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][2], 255);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][2], 1);

    PTD_ItemGain[playerid][3] = CreatePlayerTextDraw(playerid, 171.000, 423.000, "mdl-2002:item_gatacetamol");
    PlayerTextDrawTextSize(playerid, PTD_ItemGain[playerid][3], 18.000, 21.000);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][3], 1);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][3], -12254977);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][3], 0);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][3], 255);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][3], 4);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][3], 1);

    PTD_ItemGain[playerid][4] = CreatePlayerTextDraw(playerid, 120.000, 430.000, "15s");
    PlayerTextDrawLetterSize(playerid, PTD_ItemGain[playerid][4], 0.170, 0.799);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][4], 2);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][4], 1);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][4], 150);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][4], 1);

    PTD_ItemGain[playerid][5] = CreatePlayerTextDraw(playerid, 140.000, 430.000, "15s");
    PlayerTextDrawLetterSize(playerid, PTD_ItemGain[playerid][5], 0.170, 0.799);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][5], 2);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][5], -1);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][5], 1);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][5], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][5], 150);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][5], 1);

    PTD_ItemGain[playerid][6] = CreatePlayerTextDraw(playerid, 160.000, 430.000, "15s");
    PlayerTextDrawLetterSize(playerid, PTD_ItemGain[playerid][6], 0.170, 0.799);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][6], 2);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][6], -1);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][6], 1);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][6], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][6], 150);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][6], 1);

    PTD_ItemGain[playerid][7] = CreatePlayerTextDraw(playerid, 180.000, 430.000, "15s");
    PlayerTextDrawLetterSize(playerid, PTD_ItemGain[playerid][7], 0.170, 0.799);
    PlayerTextDrawAlignment(playerid, PTD_ItemGain[playerid][7], 2);
    PlayerTextDrawColor(playerid, PTD_ItemGain[playerid][7], -1);
    PlayerTextDrawSetShadow(playerid, PTD_ItemGain[playerid][7], 1);
    PlayerTextDrawSetOutline(playerid, PTD_ItemGain[playerid][7], 0);
    PlayerTextDrawBackgroundColor(playerid, PTD_ItemGain[playerid][7], 150);
    PlayerTextDrawFont(playerid, PTD_ItemGain[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, PTD_ItemGain[playerid][7], 1);

    return 1;
}

Function: ItemGain(playerid, action)
{
    new i, str[64];
    new count = 0;
    switch(action)
    {
        case 1:
        {
            for(i = 0 ; i < MAX_ITEM_GAIN ; i++)
            {
                if(UseItemGain[playerid][usg_ItemID][i] == GetPVarInt(playerid, "usg_ItemIDs"))
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Khong the su dung cung luc nhieu vat pham nhu vay.");
                    DeletePVar(playerid, "usg_ItemIDs");
                    DeletePVar(playerid, "usg_ItemTimers");
                    return 1;
                }
                if(UseItemGain[playerid][usg_ItemID][i] == 0)
                {
                    new item = GetPVarInt(playerid, "usg_ItemIDs");
                    new time = GetPVarInt(playerid, "usg_ItemTimers");
                    UseItemGain[playerid][usg_ItemID][i] = item;
                    UseItemGain[playerid][usg_ItemTimer][i] = time;
                    SetPVarInt(playerid, "usg_ItemIndexs", i);
                    ItemGain(playerid, 2);
                    break;
                }
            }
        }
        case 2:
        {
            new item = GetPVarInt(playerid, "usg_ItemIDs");
            new time = GetPVarInt(playerid, "usg_ItemTimers");
            new index = GetPVarInt(playerid, "usg_ItemIndexs");
            for(i = 0 ; i < 8 ; i++)
            {
                if(PTD_ItemGain[playerid][i] == PlayerText:INVALID_TEXT_DRAW)
                    count++;
            }
            if(count == 8) CPTD_ItemGain(playerid);
            format(str, sizeof(str), "%s", GetItemMDL(item));
            PlayerTextDrawSetString(playerid, PTD_ItemGain[playerid][index], str);
            format(str, sizeof(str), "%d", time);
            PlayerTextDrawSetString(playerid, PTD_ItemGain[playerid][index + 4], str);
            PlayerTextDrawShow(playerid, PTD_ItemGain[playerid][index]);
            PlayerTextDrawShow(playerid, PTD_ItemGain[playerid][index + 4]);
            format(str, sizeof(str), "usg_IndexID%d", index);
            usg_TimerTerminator[playerid][index] = SetTimerEx(str, 1000, true, "i", playerid);
            format(str, sizeof(str), "usg_TimerUse%d", index);
            switch(item)
            {
                case 11:
                {
                    usg_TimerUse[playerid][index] = SetTimerEx(str, 4000, true, "i", playerid);
                }
            }
        }
    }
    return 1;
}

//========================== Index 0
Function: usg_IndexID0(playerid)
{
    new str[64];
    if(UseItemGain[playerid][usg_ItemTimer][0] != 0)
    {
        UseItemGain[playerid][usg_ItemTimer][0]--;
        format(str, sizeof(str), "%d", UseItemGain[playerid][usg_ItemTimer][0]);
        PlayerTextDrawSetString(playerid, PTD_ItemGain[playerid][0 + 4], str);
        return 1;
    }
    UseItemGain[playerid][usg_ItemID][0] = 0;
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][0]);
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][0 + 4]);
    KillTimer(usg_TimerTerminator[playerid][0]);
    return 1;
}

Function: usg_TimerUse0(playerid)
{
    new str[65];
    new hrand;
    new Float:health;
    if(UseItemGain[playerid][usg_ItemID][0] != 0)
    {
        switch(UseItemGain[playerid][usg_ItemID][0])
        {
            case 11:
            {
                hrand = random(21);
                GetHealth(playerid, health);
                if(health + hrand <= 100.0)
                {
                    SetHealth(playerid, health + hrand);
                    format(str, sizeof(str), "[{D92B3D}HOI PHUC{FFFFFF}]: Hoi phuc +%d HP.", hrand);
                    SendClientMessageEx(playerid, COLOR_WHITE, str);
                }
            }
        }
        return 1;
    }
    KillTimer(usg_TimerUse[playerid][0]);
    return 1;
}
//=========================== Index 1
Function: usg_IndexID1(playerid)
{
    new str[64];
    if(UseItemGain[playerid][usg_ItemTimer][1] != 0)
    {
        UseItemGain[playerid][usg_ItemTimer][1]--;
        format(str, sizeof(str), "%d", UseItemGain[playerid][usg_ItemTimer][1]);
        PlayerTextDrawSetString(playerid, PTD_ItemGain[playerid][1 + 4], str);
        return 1;
    }
    UseItemGain[playerid][usg_ItemID][1] = 0;
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][1]);
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][1 + 4]);
    KillTimer(usg_TimerTerminator[playerid][1]);
    return 1;
}

Function: usg_TimerUse1(playerid)
{
    new str[65];
    new hrand;
    new Float:health;
    if(UseItemGain[playerid][usg_ItemID][1] != 0)
    {
        switch(UseItemGain[playerid][usg_ItemID][1])
        {
            case 11:
            {
                hrand = random(21);
                GetHealth(playerid, health);
                if(health + hrand <= 100.0)
                {
                    SetHealth(playerid, health + hrand);
                    format(str, sizeof(str), "[{D92B3D}HOI PHUC{FFFFFF}]: Hoi phuc +%d HP.", hrand);
                    SendClientMessageEx(playerid, COLOR_WHITE, str);
                }
            }
        }
        return 1;
    }
    KillTimer(usg_TimerUse[playerid][1]);
    return 1;
}
//============================ Index 2
Function: usg_IndexID2(playerid)
{
    new str[64];
    if(UseItemGain[playerid][usg_ItemTimer][2] != 0)
    {
        UseItemGain[playerid][usg_ItemTimer][2]--;
        format(str, sizeof(str), "%d", UseItemGain[playerid][usg_ItemTimer][2]);
        PlayerTextDrawSetString(playerid, PTD_ItemGain[playerid][2 + 4], str);
        return 1;
    }
    UseItemGain[playerid][usg_ItemID][2] = 0;
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][2]);
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][2 + 4]);
    KillTimer(usg_TimerTerminator[playerid][2]);
    return 1;
}

Function: usg_TimerUse2(playerid)
{
    new str[65];
    new hrand;
    new Float:health;
    if(UseItemGain[playerid][usg_ItemID][2] != 0)
    {
        switch(UseItemGain[playerid][usg_ItemID][2])
        {
            case 11:
            {
                hrand = random(21);
                GetHealth(playerid, health);
                if(health + hrand <= 100.0)
                {
                    SetHealth(playerid, health + hrand);
                    format(str, sizeof(str), "[{D92B3D}HOI PHUC{FFFFFF}]: Hoi phuc +%d HP.", hrand);
                    SendClientMessageEx(playerid, COLOR_WHITE, str);
                }
            }
        }
        return 1;
    }
    KillTimer(usg_TimerUse[playerid][2]);
    return 1;
}
//============================ Index 3
Function: usg_IndexID3(playerid)
{
    new str[64];
    if(UseItemGain[playerid][usg_ItemTimer][3] != 0)
    {
        UseItemGain[playerid][usg_ItemTimer][3]--;
        format(str, sizeof(str), "%d", UseItemGain[playerid][usg_ItemTimer][3]);
        PlayerTextDrawSetString(playerid, PTD_ItemGain[playerid][3 + 4], str);
        return 1;
    }
    UseItemGain[playerid][usg_ItemID][3] = 0;
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][3]);
    PlayerTextDrawHide(playerid, PTD_ItemGain[playerid][3 + 4]);
    KillTimer(usg_TimerTerminator[playerid][3]);
    return 1;
}

Function: usg_TimerUse3(playerid)
{
    new str[65];
    new hrand;
    new Float:health;
    if(UseItemGain[playerid][usg_ItemID][3] != 0)
    {
        switch(UseItemGain[playerid][usg_ItemID][3])
        {
            case 11:
            {
                hrand = random(21);
                GetHealth(playerid, health);
                if(health + hrand <= 100.0)
                {
                    SetHealth(playerid, health + hrand);
                    format(str, sizeof(str), "[{D92B3D}HOI PHUC{FFFFFF}]: Hoi phuc +%d HP.", hrand);
                    SendClientMessageEx(playerid, COLOR_WHITE, str);
                }
            }
        }
        return 1;
    }
    KillTimer(usg_TimerUse[playerid][3]);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    new i;
    for(i = 0 ; i < MAX_ITEM_GAIN ; i++)
    {
        UseItemGain[playerid][usg_ItemID][i] = 0;
        UseItemGain[playerid][usg_ItemTimer][i] = 0;
        usg_TimerUse[playerid][i] = 0;
    }
    for(i = 0 ; i < 8 ; i++)
    {
        PTD_ItemGain[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
    }
    SetPVarInt(playerid, "usg_ItemIDs", 0);
    SetPVarInt(playerid, "usg_ItemTimers", 0);
    SetPVarInt(playerid, "usg_ItemIndexs", 0);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    new i, z;
    for(i = 0 ; i < MAX_ITEM_GAIN ; i++)
    {
        UseItemGain[playerid][usg_ItemID][i] = 0;
        UseItemGain[playerid][usg_ItemTimer][i] = 0;
        usg_TimerUse[playerid][i] = 0;
    }
    for(z = 0 ; z < 8 ; z++)
    {
        PlayerTextDrawDestroy(playerid, PTD_ItemGain[playerid][i]);
    }
    DeletePVar(playerid, "usg_ItemIDs");
    DeletePVar(playerid, "usg_ItemTimers");
    DeletePVar(playerid, "usg_ItemIndexs");
    return 1;
}