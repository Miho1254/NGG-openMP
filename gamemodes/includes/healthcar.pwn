#include <YSI\y_hooks>
CMD:nangcapxe(playerid, params[])
{
	new vstring[1024], icount = GetPlayerVehicleSlots(playerid);
	for(new i, iModelID; i < icount; i++)
	{
		if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
		{
			format(vstring, sizeof(vstring), "%s\n%s", vstring, VehicleName[iModelID]);
		}
		else strcat(vstring, "\n--");
	}
	return ShowPlayerDialog(playerid, NCH, DIALOG_STYLE_LIST, "Tang do ben cho xe", vstring, "Xac nhan", "Huy");
}
CMD:sethealthcar(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 5)
    {
        new string[128], giveplayerid, health;
        if(sscanf(params, "ud", giveplayerid, health)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /sethealthcar [player] [health]");
        if(health < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the set health it hon 1.");
        for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
        {
            if(IsPlayerInVehicle(giveplayerid, PlayerVehicleInfo[giveplayerid][i][pvId]))
            {
                PlayerVehicleInfo[giveplayerid][i][pvHealthcar] = health;
                format(string, sizeof(string), "Ban da set mau xe xe cho %s,Health: %d.",GetPlayerNameEx(giveplayerid),health);
                return SendClientMessageEx(playerid, COLOR_GREEN, string);
            }
        }
    }    
    else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay.");     
    return 1;
}    
