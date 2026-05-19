#include <YSI\y_hooks>
new Text:TDE_NGUDAN[7];
new TimeThuLuoi[MAX_PLAYERS];
new BaoTriNguDan = 0;
hook OnGameModeInit()
{

	TDE_NGUDAN[0] = TextDrawCreate(493.000000, 366.089050, "box");
	TextDrawLetterSize(TDE_NGUDAN[0], 0.000000, 2.449998);
	TextDrawTextSize(TDE_NGUDAN[0], 633.000000, 0.000000);
	TextDrawAlignment(TDE_NGUDAN[0], 1);
	TextDrawColor(TDE_NGUDAN[0], -1);
	TextDrawUseBox(TDE_NGUDAN[0], 1);
	TextDrawBoxColor(TDE_NGUDAN[0], 255);
	TextDrawSetShadow(TDE_NGUDAN[0], 0);
	TextDrawSetOutline(TDE_NGUDAN[0], 0);
	TextDrawBackgroundColor(TDE_NGUDAN[0], 255);
	TextDrawFont(TDE_NGUDAN[0], 1);
	TextDrawSetProportional(TDE_NGUDAN[0], 1);
	TextDrawSetShadow(TDE_NGUDAN[0], 0);

	TDE_NGUDAN[1] = TextDrawCreate(320.000000, 390.000000, "Ban da bat dau ~y~tha luoi~w~.~n~Vui long cho vai phut...");
	TextDrawLetterSize(TDE_NGUDAN[1], 0.251998, 1.580088);
	TextDrawAlignment(TDE_NGUDAN[1], 2);
	TextDrawColor(TDE_NGUDAN[1], -1);
	TextDrawSetShadow(TDE_NGUDAN[1], 0);
	TextDrawSetOutline(TDE_NGUDAN[1], 1);
	TextDrawBackgroundColor(TDE_NGUDAN[1], 255);
	TextDrawFont(TDE_NGUDAN[1], 1);
	TextDrawSetProportional(TDE_NGUDAN[1], 1);
	TextDrawSetShadow(TDE_NGUDAN[1], 0);

	TDE_NGUDAN[2] = TextDrawCreate(320.000000, 416.601013, "Hay di theo diem ~r~danh dau~w~ tren ban do");
	TextDrawLetterSize(TDE_NGUDAN[2], 0.283598, 1.346132);
	TextDrawAlignment(TDE_NGUDAN[2], 2);
	TextDrawColor(TDE_NGUDAN[2], -1);
	TextDrawSetShadow(TDE_NGUDAN[2], 0);
	TextDrawSetOutline(TDE_NGUDAN[2], 1);
	TextDrawBackgroundColor(TDE_NGUDAN[2], 255);
	TextDrawFont(TDE_NGUDAN[2], 1);
	TextDrawSetProportional(TDE_NGUDAN[2], 1);
	TextDrawSetShadow(TDE_NGUDAN[2], 0);

	TDE_NGUDAN[3] = TextDrawCreate(320.000000, 400.000000, "Ban da ~r~danh dau~w~ vi tri danh bat thuy san tren ban do");
	TextDrawLetterSize(TDE_NGUDAN[3], 0.283598, 1.346132);
	TextDrawAlignment(TDE_NGUDAN[3], 2);
	TextDrawColor(TDE_NGUDAN[3], -1);
	TextDrawSetShadow(TDE_NGUDAN[3], 0);
	TextDrawSetOutline(TDE_NGUDAN[3], 1);
	TextDrawBackgroundColor(TDE_NGUDAN[3], 255);
	TextDrawFont(TDE_NGUDAN[3], 1);
	TextDrawSetProportional(TDE_NGUDAN[3], 1);
	TextDrawSetShadow(TDE_NGUDAN[3], 0);

	TDE_NGUDAN[4] = TextDrawCreate(320.000000, 400.000000, "Chao mung ban den voi cong viec ~y~Ngu Dan~w~.~n~Su dung lenh ~y~/ngudan~w~ de chon khu vuc danh bat.");
	TextDrawLetterSize(TDE_NGUDAN[4], 0.283598, 1.346132);
	TextDrawAlignment(TDE_NGUDAN[4], 2);
	TextDrawColor(TDE_NGUDAN[4], -1);
	TextDrawSetShadow(TDE_NGUDAN[4], 0);
	TextDrawSetOutline(TDE_NGUDAN[4], 1);
	TextDrawBackgroundColor(TDE_NGUDAN[4], 255);
	TextDrawFont(TDE_NGUDAN[4], 1);
	TextDrawSetProportional(TDE_NGUDAN[4], 1);
	TextDrawSetShadow(TDE_NGUDAN[4], 0);

	TDE_NGUDAN[5] = TextDrawCreate(320.000000, 390.000000, "Ban da bat dau ~r~thu luoi~w~.~n~Vui long cho vai giay...");
	TextDrawLetterSize(TDE_NGUDAN[5], 0.251998, 1.580088);
	TextDrawAlignment(TDE_NGUDAN[5], 2);
	TextDrawColor(TDE_NGUDAN[5], -1);
	TextDrawSetShadow(TDE_NGUDAN[5], 0);
	TextDrawSetOutline(TDE_NGUDAN[5], 1);
	TextDrawBackgroundColor(TDE_NGUDAN[5], 255);
	TextDrawFont(TDE_NGUDAN[5], 1);
	TextDrawSetProportional(TDE_NGUDAN[5], 1);
	TextDrawSetShadow(TDE_NGUDAN[5], 0);

	TDE_NGUDAN[6] = TextDrawCreate(320.000000, 390.000000, "Ban da den ~y~dia diem~w~ danh bat thuy san.~n~Hay su dung lenh ~y~/thaluoi~w~ de bat dau tha luoi.");
	TextDrawLetterSize(TDE_NGUDAN[6], 0.251998, 1.580088);
	TextDrawAlignment(TDE_NGUDAN[6], 2);
	TextDrawColor(TDE_NGUDAN[6], -1);
	TextDrawSetShadow(TDE_NGUDAN[6], 0);
	TextDrawSetOutline(TDE_NGUDAN[6], 1);
	TextDrawBackgroundColor(TDE_NGUDAN[6], 255);
	TextDrawFont(TDE_NGUDAN[6], 1);
	TextDrawSetProportional(TDE_NGUDAN[6], 1);
	TextDrawSetShadow(TDE_NGUDAN[6], 0);

}
CMD:ngudan(playerid, params[])
{
	if(BaoTriNguDan == 1) return SendClientMessageEx(playerid, -1, " {C4A656}[NGU DAN]{FFFFFF} Cong viec Ngu Dan hien dang duoc bao tri.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, -1709.1864,	1430.0531,	-2.0515))
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong o khu vuc ben cang, hay quay ve lai vi tri ban dau de bat dau cong viec.");
	}	
	if(GetPVarInt(playerid, "JobNguDanCheck") == 1)
 	{
 		return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da chon mot vi tri tha luoi roi. Hay (/huyngudan) de huy vi tri hien tai.");
		 
 	}
 	new vehicleid = GetPlayerVehicleID(playerid);	
	if(IsThuyenNguDan(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		ShowPlayerDialog(playerid, DIALOG_NGUDAN, DIALOG_STYLE_LIST, "Chon khu vuc danh bat thuy san", "Khu Vuc 1\tSan Fierro\nKhu Vuc 2\tSan Fierro\nKhu Vuc 3\tSan Fierro\nKhu Vuc 4\tSan Fierro", "Chon", "Quay Lai");		
	}
	else return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban Khong Co O Tren Phuong Tien Danh Bat.");
	return 1;
}

CMD:thaluoi(playerid, params[])
{
	if(GetPVarInt(playerid, "SetThaLuoi") == 0)//OnPlayerEnterCheckpoint
 	{
 		return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong dung tai noi tha luoi.");
 	}
 	if(GetPVarInt(playerid, "JobNguDanCheck") == 0)
 	{
 		return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong the lam dieu nay ngay bay gio.");
 	}	
 	new vehicleid = GetPlayerVehicleID(playerid);	
	if(IsThuyenNguDan(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetPVarInt(playerid, "SetThaLuoi", 0);
		SetTimerEx("LoadJobNguDan", 600000, false, "i", playerid);//600000 = 10p
		TimeThuLuoi[playerid] = gettime()+600;
 		SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da bat dau tha luoi, vui long cho vai phut...");
 		//textdraw
 		SetTimerEx("HideTDENguDan", 600000, false, "i", playerid);
 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[1]);
	}
	else return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong co o tren phuong tien danh bat.");
	return 1;
}

CMD:thuluoi(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50.0, -1709.1864,	1430.0531,	-2.0515))
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong o khu vuc danh bat thuy san.");
	}	
	if(gettime() < TimeThuLuoi[playerid])
	{
		new string[128];
		format(string, sizeof(string), "{C4A656}[NGU DAN]{FFFFFF} Con {C4A656}%d{FFFFFF} giay nua moi co the thu luoi.", TimeThuLuoi[playerid]-gettime());
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		return 1;
	}
	if(GetPVarInt(playerid, "IFThaLuoi") == 0)
 	{
 		return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban chua the thu luoi duoc.");
 	}
 	if(GetPVarInt(playerid, "DangThuLuoi") == 1)
 	{
 		return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban dang thu luoi..");
 	}
 	new vehicleid = GetPlayerVehicleID(playerid);	
	if(IsThuyenNguDan(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetPVarInt(playerid, "DangThuLuoi", 1);
		SetTimerEx("HideTDENguDan", 29000, false, "i", playerid);
		TextDrawShowForPlayer(playerid, TDE_NGUDAN[5]);
		SetTimerEx("FreezeThuLuoi", 30000, false, "i", playerid);
		TogglePlayerControllable(playerid, 0);
		SendClientMessageEx(playerid, COLOR_WHITE, "[NGU DAN] Ban dang thu luoi, vui long doi...");

	}
	else return SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban khong co o tren thuyen danh bat thuy san.");
	return 1;
}

stock IsThuyenNguDan(carid)
{
	for(new v = 0; v < sizeof(NguDanVehicles); v++) 
	{
	    if(carid == NguDanVehicles[v]) return 1;
	}
	return 0;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarInt(playerid, "JobNguDanCheck") == 1)
 	{
	 	DisablePlayerCheckpoint(playerid);
	 	SetTimerEx("HideTDENguDan", 2000, false, "i", playerid);
		TextDrawShowForPlayer(playerid, TDE_NGUDAN[6]);
	 	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da den dia diem danh bat thuy san.");
	 	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Su dung lenh ({C4A656}/thaluoi{FFFFFF}) de bat dau tha luoi.");
	 	SetPVarInt(playerid, "SetThaLuoi", 1);	
 	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_NGUDAN)
    {
		if(response)
   		{
        	if(listitem == 0)
	        {
	        	SetPlayerCheckpoint(playerid, -2256.0278,1957.6537,-0.7859, 20);
	        	SetPVarInt(playerid, "JobNguDanCheck", 1);
	        	SetTimerEx("HideTDENguDan", 8000, false, "i", playerid);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[2]);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[3]);
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da thiet lap thanh cong vi tri danh bat");
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Bay gio ban can chay duoc checkpoint tren radar de tien hanh danh bat");
			}
			if(listitem == 1)
	        {
	        	SetTimerEx("HideTDENguDan", 8000, false, "i", playerid);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[2]);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[3]);
	        	SetPlayerCheckpoint(playerid, -2442.3542,1697.4408,-0.7506, 20);
	        	SetPVarInt(playerid, "JobNguDanCheck", 1);
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da thiet lap thanh cong vi tri danh bat");
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Bay gio ban can chay duoc checkpoint tren radar de tien hanh danh bat");
			}
			if(listitem == 2)
	        {
	        	SetTimerEx("HideTDENguDan", 8000, false, "i", playerid);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[2]);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[3]);
	        	SetPlayerCheckpoint(playerid, -1090.9705,601.9323,-0.5750, 20);
	        	SetPVarInt(playerid, "JobNguDanCheck", 1);
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da thiet lap thanh cong vi tri danh bat");
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Bay gio ban can chay duoc checkpoint tren radar de tien hanh danh bat");
			}
			if(listitem == 3)
	        {
	        	SetTimerEx("HideTDENguDan", 8000, false, "i", playerid);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[2]);
		 		TextDrawShowForPlayer(playerid, TDE_NGUDAN[3]);
	        	SetPlayerCheckpoint(playerid, -1060.4594,126.4771,-0.6570, 20);
	        	SetPVarInt(playerid, "JobNguDanCheck", 1);
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da thiet lap thanh cong vi tri danh bat");
	        	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Bay gio ban can chay duoc checkpoint tren radar de tien hanh danh bat");
			}

	  	}
	}  	
	return 1;
}
forward FreezeThuLuoi(playerid);
public FreezeThuLuoi(playerid)
{
	SetPVarInt(playerid, "DangThuLuoi", 0);
	TogglePlayerControllable(playerid, 1);
	GivePlayerCash(playerid, 50000);
	SetPVarInt(playerid, "IFThaLuoi", 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da thu luoi duoc 1 me ca tri gia {33AA33}$50.000{FFFFFF}.");	
	return 1;
}
forward LoadJobNguDan(playerid);
public LoadJobNguDan(playerid)
{
	if(GetPVarInt(playerid, "JobNguDanCheck") == 1)
 	{
 		SetPVarInt(playerid, "IFThaLuoi", 1);
		SetPVarInt(playerid, "JobNguDanCheck", 0);
		SendClientMessageEx(playerid, COLOR_WHITE, "{C4A656}[NGU DAN]{FFFFFF} Ban da tha luoi xong va da bat du so ca, bay gio hay thu luoi ({C4A656}/thuluoi){FFFFFF}.");
	}	
	return 1;
}
forward HideTDENguDan(playerid);
public HideTDENguDan(playerid)
{
	for (new i = 0; i < sizeof(TDE_NGUDAN); i++) {
	    TextDrawHideForPlayer(playerid, TDE_NGUDAN[i]);
	}
	return 1;
}

CMD:tgngudan(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"__________Cong viec Ngu Dan___________");
    SendClientMessageEx(playerid, COLOR_GRAD3,"/ngudan - Chon khu vuc danh bat thuy san.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"/thaluoi - Tha luoi (Bat dau danh bat thuy san).");
    SendClientMessageEx(playerid, COLOR_GRAD3,"/thuluoi - Thu luoi (Hoan thanh danh bat thuy san).");
    SendClientMessageEx(playerid, COLOR_GRAD3,"/huyngudan - Huy bo qua trinh lam viec.");
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);	
    if(IsThuyenNguDan(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
    	SetTimerEx("HideTDENguDan", 3000, false, "i", playerid);
		TextDrawShowForPlayer(playerid, TDE_NGUDAN[4]);
        SendClientMessageEx(playerid, COLOR_WHITE,"{C4A656}[NGU DAN]{FFFFFF} Day la chiec thuyen de danh bat thuy san.");
		SendClientMessageEx(playerid, COLOR_WHITE,"{C4A656}[NGU DAN]{FFFFFF} Hay su dung lenh ({C4A656}/ngudan{FFFFFF}) de chon khu vuc danh bat.");
        SendClientMessageEx(playerid, COLOR_WHITE,"{C4A656}[NGU DAN]{FFFFFF} Neu khong biet lenh hay ({C4A656}/tgngudan{FFFFFF}) de xem lenh cong viec.");
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	SetPVarInt(playerid, "IFThaLuoi", 0);
	SetPVarInt(playerid, "JobNguDanCheck", 0);
	SetPVarInt(playerid, "SetThaLuoi", 0);
	TimeThuLuoi[playerid] = 0;
}
CMD:huyngudan(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"[NGU DAN] Ban da huy bo qua trinh lam viec Ngu Dan thanh cong.");
    SetPVarInt(playerid, "IFThaLuoi", 0);
	SetPVarInt(playerid, "JobNguDanCheck", 0);
	SetPVarInt(playerid, "SetThaLuoi", 0);
	TimeThuLuoi[playerid] = 0;
	DisablePlayerCheckpoint(playerid);
	SetPVarInt(playerid, "DangThuLuoi", 0);
    return 1;
}


CMD:baotringudan(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 5)
	{
		if(BaoTriNguDan == 0)
		{
			BaoTriNguDan = 1;
			SendClientMessageEx(playerid, COLOR_RED,"Ban da bao tri cong viec Ngu Dan.");
		}
		else if(BaoTriNguDan == 1)
		{
			BaoTriNguDan = 0;
			SendClientMessageEx(playerid, COLOR_GREEN,"Ban da ngung bao tri cong viec Ngu Dan");
		}
	}
	return 1;
}
