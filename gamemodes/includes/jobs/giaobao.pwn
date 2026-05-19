
#include <YSI\y_hooks>

//new LayBao[MAX_PLAYERS];
new SoToBao[MAX_PLAYERS];
new NhanTienGiaoBao[MAX_PLAYERS];
new Text:TDE_GIAOBAO[4];
new PlayerText:PTD_GIAOBAO[MAX_PLAYERS][1];
new BaoTriGiaoBao = 0;

new Float:ToaDoGiaoBao[][4] =
{
    {-1472.1180, 2595.9885, 55.8359, 4.0},
	{-1420.7626, 2640.9766, 55.6875, 4.0},
	{-1450.6735, 2676.2922, 55.8359, 4.0},
	{-1519.3423, 2556.3833, 55.7450, 4.0},
	{-1273.1416, 2703.9551, 50.0625, 4.0},
	{-1656.7195, 2542.8247, 85.1876, 4.0},
	{-1551.0439, 2650.9546, 55.8359, 4.0},
	{-1596.5254, 2676.4380, 55.0852, 4.0}
};
CMD:baotrigiaobao(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 5)
	{
	    new string[128];
		if(BaoTriGiaoBao == 0)
		{
			BaoTriGiaoBao = 1;
			format(string, sizeof(string), "[GIAO BAO] Job Giao bao da duoc dong boi Admin %s.",GetPlayerNameEx(playerid));
	        SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		}
		else if(BaoTriGiaoBao == 1)
		{
			BaoTriGiaoBao = 0;
			format(string, sizeof(string), "[GIAO BAO] Job Giao bao da duoc mo boi Admin %s.",GetPlayerNameEx(playerid));
	        SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		}
	}
	return 1;
}
CMD:laybao(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(BaoTriGiaoBao == 1) return SendClientMessageEx(playerid, -1, " Cong Viec Dang Duoc Bao Tri");
	if(GetVehicleModel(vehicleid) != 510 || GetVehicleModel(vehicleid) != 509 || GetVehicleModel(vehicleid) != 481)
	{
		return SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban phai ngoi tren xe dap de tien hanh lay bao");
	}
	if(SoToBao[playerid] >= 1)
	{
		return SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban da lay bao roi.");
	}	
  	if(IsPlayerInRangeOfPoint(playerid, 20.0, -1941.356689, 2385.538574, 49.695312))
    {
        SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban da lay bao va (/giaobao) de bat dau cong viec.");
 		SoToBao[playerid] = 5;
		TextDrawShowForPlayer(playerid, TDE_GIAOBAO[3]);
		SetTimerEx("HiDeTDEGiaoBao", 2000, false, "i", playerid);
    } 
    else 
    {
      SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban khong o dia diem lay bao.");
    }
    return 1;
}

CMD:giaobao(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(BaoTriGiaoBao == 1) return SendClientMessageEx(playerid, -1, "Cong viec dang duoc bao tri.");
	if(GetVehicleModel(vehicleid) != 510 || GetVehicleModel(vehicleid) != 509 || GetVehicleModel(vehicleid) != 481)
	{
		return SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban phai ngoi tren xe dap moi co the bat dau giao bao.");
	}
  	if(SoToBao[playerid] > 0)
    {
    	SetTimerEx("TimeGiaoBao", 2000, false, "i", playerid);
        SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Dang tim kiem vi tri giao, vui long doi.");
		//
		TextDrawShowForPlayer(playerid, TDE_GIAOBAO[0]);
    } 
    else 
    {
      SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban chua lay bao.");
    }
    return 1;
}
forward TimeGiaoBao(playerid);
public TimeGiaoBao(playerid)
{
	new rand = random(sizeof(ToaDoGiaoBao));
	SetTimerEx("HiDeTDEGiaoBao", 1, false, "i", playerid);
    SetPlayerCheckpoint(playerid, ToaDoGiaoBao[rand][0], ToaDoGiaoBao[rand][1], ToaDoGiaoBao[rand][2], ToaDoGiaoBao[rand][3]);
	SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Hay chay den dia diem tren ban do de giao bao.");
	TextDrawShowForPlayer(playerid, TDE_GIAOBAO[1]);
	SetTimerEx("HiDeTDEGiaoBao", 5000, false, "i", playerid);

	return 1;
}
hook OnPlayerEnterCheckpoint(playerid)
{
	if(SoToBao[playerid] > 0 && NhanTienGiaoBao[playerid] != 5)
	{
	    new string[128];
	    new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) != 510 || GetVehicleModel(vehicleid) != 509 || GetVehicleModel(vehicleid) != 481)
		{
			return SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban phai ngoi tren xe dap de tien hanh giao bao.");
		}
		SoToBao[playerid] -= 1;
		SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban da giao bao thanh cong.");
		format(string,sizeof(string),"{C4A656}[GIAO BAO]{FFFFFF} So bao con lai (%d/5)",SoToBao[playerid]);
		SendClientMessage(playerid, -1, string);

		format(string, sizeof(string), "Tien do ~Y~giao bao ~r~%d/5", SoToBao[playerid]);
		PlayerTextDrawSetString(playerid, PTD_GIAOBAO[playerid][0], string);
		PlayerTextDrawShow(playerid, PTD_GIAOBAO[playerid][0]);

		SetPVarInt(playerid, "CheckGiaoXongBao", 1);
		NhanTienGiaoBao[playerid] += 1;
		DisablePlayerCheckpoint(playerid);
	}
	if(NhanTienGiaoBao[playerid] >= 5 && SoToBao[playerid] == 0 && GetPVarInt(playerid,"CheckUpdateHetBao") == 1)
 	{
 	    new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) != 510 || GetVehicleModel(vehicleid) != 509 || GetVehicleModel(vehicleid) != 481)
		{
			return SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban phai ngoi tren xe dap de tien hanh lay bao.");
		}
 		SetPVarInt(playerid, "CheckGiaoXongBao", 0);
 		SetPVarInt(playerid, "CheckUpdateHetBao", 0);
 		SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Ban da giao bao thanh cong va nhan duoc $20.000.");
 		PlayerTextDrawHide(playerid, PTD_GIAOBAO[playerid][0]);
		//
		TextDrawShowForPlayer(playerid, TDE_GIAOBAO[2]);
		SetTimerEx("HiDeTDEGiaoBao", 2000, false, "i", playerid);
 		GivePlayerCash(playerid, 20000);
 		DisablePlayerCheckpoint(playerid);
 		NhanTienGiaoBao[playerid] = 0;
 	}	
	return 1;
}
hook OnPlayerDeath(playerid, killerid, reason)
{
	SoToBao[playerid] = 0;
	SetPVarInt(playerid, "CheckGiaoXongBao", 0);
	SetPVarInt(playerid, "CheckUpdateHetBao", 0);

	return 1;
}
hook OnPlayerConnect(playerid)
{
	SoToBao[playerid] = 0;
	NhanTienGiaoBao[playerid] = 0;
	TaoTDEGiaoBao(playerid);
	return 1;
}
hook OnPlayerUpdate(playerid)
{
    if(NhanTienGiaoBao[playerid] >= 5 && SoToBao[playerid] == 0 && GetPVarInt(playerid,"ThongBaoVeLayTienGiaoBao") == 0)
 	{
		PlayerTextDrawHide(playerid, PTD_GIAOBAO[playerid][0]);
 		SetPlayerCheckpoint(playerid, -1941.356689, 2385.538574, 49.695312, 7.0);
 		SetPVarInt(playerid, "CheckUpdateHetBao", 1);
 		SetPVarInt(playerid, "ThongBaoVeLayTienGiaoBao", 1);
 		SendClientMessage(playerid, -1, "{C4A656}[GIAO BAO]{FFFFFF} Bay gio ban can quay tro ve dia diem lay bao de nhan tien.");
 	}
	return 1;
}
hook OnGameModeInit()
{
	TDE_GIAOBAO[0] = TextDrawCreate(414.799926, 428.933441, "dang tim kiem ~r~vi tri~w~ giao bao...");
	TextDrawLetterSize(TDE_GIAOBAO[0], 0.288399, 1.291377);
	TextDrawAlignment(TDE_GIAOBAO[0], 3);
	TextDrawColor(TDE_GIAOBAO[0], -1);
	TextDrawSetShadow(TDE_GIAOBAO[0], 0);
	TextDrawSetOutline(TDE_GIAOBAO[0], 0);
	TextDrawBackgroundColor(TDE_GIAOBAO[0], 255);
	TextDrawFont(TDE_GIAOBAO[0], 2);
	TextDrawSetProportional(TDE_GIAOBAO[0], 1);
	TextDrawSetShadow(TDE_GIAOBAO[0], 0);

	TDE_GIAOBAO[1] = TextDrawCreate(420.799957, 430.426788, "~r~ vi tri~w~ giao bao nam tren mini map!");
	TextDrawLetterSize(TDE_GIAOBAO[1], 0.288399, 1.291377);
	TextDrawAlignment(TDE_GIAOBAO[1], 3);
	TextDrawColor(TDE_GIAOBAO[1], -1);
	TextDrawSetShadow(TDE_GIAOBAO[1], 0);
	TextDrawSetOutline(TDE_GIAOBAO[1], 0);
	TextDrawBackgroundColor(TDE_GIAOBAO[1], 255);
	TextDrawFont(TDE_GIAOBAO[1], 2);
	TextDrawSetProportional(TDE_GIAOBAO[1], 1);
	TextDrawSetShadow(TDE_GIAOBAO[1], 0);

	TDE_GIAOBAO[2] = TextDrawCreate(416.000061, 420.471130, "Ban da hoan tat cong viec ~y~giao bao");
	TextDrawLetterSize(TDE_GIAOBAO[2], 0.257200, 1.609955);
	TextDrawAlignment(TDE_GIAOBAO[2], 3);
	TextDrawColor(TDE_GIAOBAO[2], -1);
	TextDrawSetShadow(TDE_GIAOBAO[2], 0);
	TextDrawSetOutline(TDE_GIAOBAO[2], 0);
	TextDrawBackgroundColor(TDE_GIAOBAO[2], 255);
	TextDrawFont(TDE_GIAOBAO[2], 2);
	TextDrawSetProportional(TDE_GIAOBAO[2], 1);
	TextDrawSetShadow(TDE_GIAOBAO[2], 0);

	TDE_GIAOBAO[3] = TextDrawCreate(420.248931, 425.083404, "Lay bao ~y~thanh cong~w~!");
	TextDrawLetterSize(TDE_GIAOBAO[3], 0.400000, 1.600000);
	TextDrawAlignment(TDE_GIAOBAO[3], 3);
	TextDrawColor(TDE_GIAOBAO[3], -1);
	TextDrawSetShadow(TDE_GIAOBAO[3], 0);
	TextDrawSetOutline(TDE_GIAOBAO[3], 0);
	TextDrawBackgroundColor(TDE_GIAOBAO[3], 255);
	TextDrawFont(TDE_GIAOBAO[3], 2);
	TextDrawSetProportional(TDE_GIAOBAO[3], 1);
	TextDrawSetShadow(TDE_GIAOBAO[3], 0);
}	
forward HiDeTDEGiaoBao(playerid);
public HiDeTDEGiaoBao(playerid)
{
	for (new i = 0; i < sizeof(TDE_GIAOBAO); i++) {
	    TextDrawHideForPlayer(playerid, TDE_GIAOBAO[i]);
	}
	return 1;
}
stock TaoTDEGiaoBao(playerid) 
{
	PTD_GIAOBAO[playerid][0] = CreatePlayerTextDraw(playerid, 428.213867, 420.416778, "Tien do ~Y~giao bao ~r~4/5");
	PlayerTextDrawLetterSize(playerid, PTD_GIAOBAO[playerid][0], 0.441698, 1.699167);
	PlayerTextDrawAlignment(playerid, PTD_GIAOBAO[playerid][0], 3);
	PlayerTextDrawColor(playerid, PTD_GIAOBAO[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, PTD_GIAOBAO[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, PTD_GIAOBAO[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, PTD_GIAOBAO[playerid][0], 255);
	PlayerTextDrawFont(playerid, PTD_GIAOBAO[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, PTD_GIAOBAO[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PTD_GIAOBAO[playerid][0], 0);
}	
