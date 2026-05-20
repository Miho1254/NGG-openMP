#if defined _modules_adventures_included
    #endinput
#endif

#define _modules_adventures_included

#include <YSI\y_hooks>

new PlayerBar:EABar[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    EABar[playerid] = CreatePlayerProgressBar(playerid, -1.000000, 446.000000, 644.000000, 700.200012, 1224671487, 100000000.0000, BAR_DIRECTION_RIGHT); // 100m exp
    return 1;
}

Function: Setup_Adventures(playerid)
{
    ShowPlayerProgressBar(playerid, EABar[playerid]);
    Update_Adventures(playerid);
    return 1;
}

Function: Update_Adventures(playerid)
{
    SetPlayerProgressBarValue(playerid, EABar[playerid], float(PlayerData[playerid][pc_EA]));
    return 1;
}