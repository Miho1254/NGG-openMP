#if defined _modules_hunger_system_included
    #endinput
#endif

#define _modules_hunger_system_included

#include <YSI\y_hooks>

new PlayerText:FoodIconTD[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:FoodValTD[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:WaterIconTD[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:WaterValTD[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

hook OnPlayerConnect(playerid)
{
    // Food Icon (Burger)
    FoodIconTD[playerid] = CreatePlayerTextDraw(playerid, 548.000000, 10.000000, "hud:radar_burger");
    PlayerTextDrawFont(playerid, FoodIconTD[playerid], 4);
    PlayerTextDrawTextSize(playerid, FoodIconTD[playerid], 11.000000, 11.000000);
    PlayerTextDrawColor(playerid, FoodIconTD[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, FoodIconTD[playerid], 255);
    
    // Food Value (%)
    FoodValTD[playerid] = CreatePlayerTextDraw(playerid, 562.000000, 11.000000, "100%");
    PlayerTextDrawFont(playerid, FoodValTD[playerid], 1);
    PlayerTextDrawLetterSize(playerid, FoodValTD[playerid], 0.220000, 0.900000);
    PlayerTextDrawColor(playerid, FoodValTD[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, FoodValTD[playerid], 255);
    PlayerTextDrawSetOutline(playerid, FoodValTD[playerid], 1);
    PlayerTextDrawSetProportional(playerid, FoodValTD[playerid], 1);

    // Water Icon (Beverage)
    WaterIconTD[playerid] = CreatePlayerTextDraw(playerid, 548.000000, 22.000000, "hud:radar_bar");
    PlayerTextDrawFont(playerid, WaterIconTD[playerid], 4);
    PlayerTextDrawTextSize(playerid, WaterIconTD[playerid], 11.000000, 11.000000);
    PlayerTextDrawColor(playerid, WaterIconTD[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, WaterIconTD[playerid], 255);

    // Water Value (%)
    WaterValTD[playerid] = CreatePlayerTextDraw(playerid, 562.000000, 23.000000, "100%");
    PlayerTextDrawFont(playerid, WaterValTD[playerid], 1);
    PlayerTextDrawLetterSize(playerid, WaterValTD[playerid], 0.220000, 0.900000);
    PlayerTextDrawColor(playerid, WaterValTD[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, WaterValTD[playerid], 255);
    PlayerTextDrawSetOutline(playerid, WaterValTD[playerid], 1);
    PlayerTextDrawSetProportional(playerid, WaterValTD[playerid], 1);

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    FoodIconTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    FoodValTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    WaterIconTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    WaterValTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

Function: Setup_Hunger(playerid)
{
    PlayerTextDrawShow(playerid, FoodIconTD[playerid]);
    PlayerTextDrawShow(playerid, FoodValTD[playerid]);
    PlayerTextDrawShow(playerid, WaterIconTD[playerid]);
    PlayerTextDrawShow(playerid, WaterValTD[playerid]);
    Update_Hunger(playerid);
    return 1;
}

Function: Update_Hunger(playerid)
{
    new string[16];
    format(string, sizeof(string), "%d%%", PlayerData[playerid][pc_FoodBar]);
    PlayerTextDrawSetString(playerid, FoodValTD[playerid], string);

    format(string, sizeof(string), "%d%%", PlayerData[playerid][pc_WaterBar]);
    PlayerTextDrawSetString(playerid, WaterValTD[playerid], string);
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

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        if(PlayerData[playerid][pc_FoodBar] < 20)
        {
            if(((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE)) || ((newkeys & KEY_JUMP) && !(oldkeys & KEY_JUMP)))
            {
                if(random(100) < 15) // 15% rate of tripping
                {
                    ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0, 1);
                    SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Ban kiet suc vi qua doi nen da bi truot chan nga.");
                }
            }
        }
    }
    return 1;
}