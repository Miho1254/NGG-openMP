#include <YSI\y_hooks>
new BaoTriNhanXe = 0;

CMD:duatuibobcat(playerid, params[])
{
	if(BaoTriNhanXe == 1) return SendClientMessageEx(playerid, -1, " Lenh Dang Bao Tri!");
	if(!vehicleCountCheck(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "Ban khong con slot chua xe.");
	if(!vehicleSpawnCountCheck(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "Vui long cat xe de su dung lenh nay.");
	if(PlayerInfo[playerid][pDuaTuiXe] == 0)
	{
	    if(PlayerInfo[playerid][pLevel] >= 3)
	    {
			new Float: arr_fPlayerPos[4];
	    	GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
			GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
			CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), 422, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			//422 = Veh Bobcat
			PlayerInfo[playerid][pDuaTuiXe] += 1;
			SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da nhan duoc phuong tien Bobcat tu Su Kien!");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong du dieu kien nhan qua su kien");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da nhan duoc phuong tien nay roi");
	return 1;
}

CMD:baotrinhanxe(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 5)
	{
		if(BaoTriNhanXe == 0)
		{
			BaoTriNhanXe = 1;
			SendClientMessageEx(playerid, COLOR_RED,"Ban da bao tri /duatuibobcat.");
		}
		else if(BaoTriNhanXe == 1)
		{
			BaoTriNhanXe = 0;
			SendClientMessageEx(playerid, COLOR_GREEN,"Ban da ngung bao tri /duatuibobcat");
		}
	}
	return 1;
}