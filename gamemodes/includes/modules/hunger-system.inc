#if defined _modules_hunger_system_included
    #endinput
#endif

#define _modules_hunger_system_included

#include <YSI\y_hooks>

new PlayerBar:FoodBar[MAX_PLAYERS];
new PlayerBar:WaterBar[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    FoodBar[playerid] = CreatePlayerProgressBar(playerid, 548.000000, 10.000000, 58.000000, 3.699999, 616825087, 100.0000, BAR_DIRECTION_RIGHT);
    WaterBar[playerid] = CreatePlayerProgressBar(playerid, 548.000000, 23.000000, 58.000000, 3.699999, 230096895, 100.0000, BAR_DIRECTION_RIGHT);

    return 1;
}

Function: Setup_Hunger(playerid)
{
    ShowPlayerProgressBar(playerid, FoodBar[playerid]);
    ShowPlayerProgressBar(playerid, WaterBar[playerid]);
    Update_Hunger(playerid);
    return 1;
}

Function: Update_Hunger(playerid)
{
    SetPlayerProgressBarValue(playerid, FoodBar[playerid], float(PlayerData[playerid][pc_FoodBar]));
    SetPlayerProgressBarValue(playerid, WaterBar[playerid], float(PlayerData[playerid][pc_WaterBar]));
    return 1;
}

ptask TakenHunger[180000](playerid)
{
    if(PlayerData[playerid][pc_FoodBar] > 0)
    {
        PlayerData[playerid][pc_FoodBar] -= random(3);
        if(PlayerData[playerid][pc_FoodBar] < 0)
            PlayerData[playerid][pc_FoodBar] = 0;
    }
    else
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Nhan vat cua ban hien dang rat doi, hay mau an uong de tang the luc lam viec.");
    if(PlayerData[playerid][pc_WaterBar] > 0)
    {
        PlayerData[playerid][pc_WaterBar] -= random(5);
        if(PlayerData[playerid][pc_WaterBar] < 0)
            PlayerData[playerid][pc_WaterBar] = 0;
    }
    else
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Nhan vat cua ban hien dang rat khat, hay mau an uong de tang the luc lam viec.");
    Update_Hunger(playerid);
    return 1;
}