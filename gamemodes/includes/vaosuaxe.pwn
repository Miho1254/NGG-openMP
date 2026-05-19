CMD:vaosuaxe(playerid, params[])
{
    if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(IsPlayerInRangeOfPoint(playerid,3.0,719.9662,-468.6009,16.3437)) // Dillimore
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, 719.7043,-457.5698,16.0412);
		        SetVehicleZAngle(tmpcar, 90.0373);
		        SetPVarInt(playerid, "Timesuaxe", 7);
                SetTimerEx("Suaxe", 700, 0, "d", playerid);
			}
        	else if(IsPlayerInRangeOfPoint(playerid,3.0, -1420.5582,2594.9541,55.4328)) // El Quebrados
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, -1420.4346,2584.7598,55.5484);
		        SetVehicleZAngle(tmpcar, -180);
		        SetPVarInt(playerid, "Timesuaxe1", 7);
                SetTimerEx("Suaxe1", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,-100.1556,1105.5221,19.4479)) // El Quebrados
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, -100.2423,1117.6725,19.4460);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe2", 7);
                SetTimerEx("Suaxe2", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,2075.0317,-1831.4559,13.2558)) // Idlewood
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, 2065.5454,-1831.5261,13.2525);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe3", 7);
                SetTimerEx("Suaxe3", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,-2425.7310,1034.0850,50.0952)) // Juniper Hollow
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, -2425.5430,1020.4201,50.1033);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe4", 7);
                SetTimerEx("Suaxe4", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,1964.6683,2162.5764,10.5248)) // Redsands East
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, 1976.1389,2162.7754,10.7751);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe5", 7);
                SetTimerEx("Suaxe5", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,488.7706,-1731.1174,10.8716)) // Verona Beach
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, 487.4275,-1741.3657,10.8369);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe6", 7);
                SetTimerEx("Suaxe6", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,1024.8564,-1032.8954,31.5517)) // Temple
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, 1025.1204,-1024.2568,31.8064);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe7", 7);
                SetTimerEx("Suaxe7", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,2393.8074,1479.3846,10.4438)) // Royal Casino
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, 2393.8076,1490.4835,10.5309);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe8", 7);
                SetTimerEx("Suaxe8", 700, 0, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid,3.0,-1904.7286,273.0300,40.7482)) // Doherty
			{
                new tmpcar = GetPlayerVehicleID(playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[!] Dang tien hanh sua xe, ban vui long cho.");
				SetVehiclePos(tmpcar, -1904.6141,283.8888,40.7517);
		        SetVehicleZAngle(tmpcar, 180);
		        SetPVarInt(playerid, "Timesuaxe9", 7);
                SetTimerEx("Suaxe9", 700, 0, "d", playerid);
			}
 	    }
	    else return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong o tren xe.");
	}
	return 1;
}
forward Suaxe(playerid, playervehicleid);
public Suaxe(playerid, playervehicleid)
{
    SetPVarInt(playerid, "Timesuaxe", GetPVarInt(playerid, "Timesuaxe")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe") > 0) SetTimerEx("Suaxe", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, 719.9662,-468.6009,16.3437);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe");
	}
}
forward Suaxe1(playerid);
public Suaxe1(playerid)
{
    SetPVarInt(playerid, "Timesuaxe1", GetPVarInt(playerid, "Timesuaxe1")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe1"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe1") > 0) SetTimerEx("Suaxe1", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe1") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, -100.1556,1105.5221,19.4479);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe1");
    }
}
forward Suaxe2(playerid);
public Suaxe2(playerid)
{
    SetPVarInt(playerid, "Timesuaxe2", GetPVarInt(playerid, "Timesuaxe2")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe2"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe2") > 0) SetTimerEx("Suaxe2", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe2") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, 719.9662,-468.6009,16.3437);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe2");
    }
}
forward Suaxe3(playerid);
public Suaxe3(playerid)
{
    SetPVarInt(playerid, "Timesuaxe3", GetPVarInt(playerid, "Timesuaxe3")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe4"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe3") > 0) SetTimerEx("Suaxe3", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe3") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, 2075.0317,-1831.4559,13.2558);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe3");
    }
}
forward Suaxe4(playerid);
public Suaxe4(playerid)
{
    SetPVarInt(playerid, "Timesuaxe4", GetPVarInt(playerid, "Timesuaxe4")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe4"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe4") > 0) SetTimerEx("Suaxe4", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe4") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, -2425.7310,1034.0850,50.0952);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe4");
    }
}
forward Suaxe5(playerid);
public Suaxe5(playerid)
{
    SetPVarInt(playerid, "Timesuaxe5", GetPVarInt(playerid, "Timesuaxe5")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe5"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe5") > 0) SetTimerEx("Suaxe5", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe5") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, 1964.6683,2162.5764,10.5248);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe5");
    }
}
forward Suaxe6(playerid);
public Suaxe6(playerid)
{
    SetPVarInt(playerid, "Timesuaxe6", GetPVarInt(playerid, "Timesuaxe6")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe6") > 0) SetTimerEx("Suaxe6", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe6") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, 488.7706,-1731.1174,10.8716);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe6");
    }
}
forward Suaxe7(playerid);
public Suaxe7(playerid)
{
    SetPVarInt(playerid, "Timesuaxe7", GetPVarInt(playerid, "Timesuaxe7")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe7"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe7") > 0) SetTimerEx("Suaxe7", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe7") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, 1024.8564,-1032.8954,31.5517);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe7");
    }
}
forward Suaxe8(playerid);
public Suaxe8(playerid)
{
    SetPVarInt(playerid, "Timesuaxe8", GetPVarInt(playerid, "Timesuaxe8")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe8"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe8") > 0) SetTimerEx("Suaxe8", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe8") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, 1024.8564,-1032.8954,31.5517);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe8");
    }
}
forward Suaxe9(playerid);
public Suaxe9(playerid)
{
    SetPVarInt(playerid, "Timesuaxe9", GetPVarInt(playerid, "Timesuaxe9")-1);
    new string[128];
    format(string, sizeof(string), "%d giay", GetPVarInt(playerid, "Timesuaxe"));
    GameTextForPlayer(playerid, string, 1100, 3);

    if(GetPVarInt(playerid, "Timesuaxe9") > 0) SetTimerEx("Suaxe9", 700, 0, "d", playerid);

    if(GetPVarInt(playerid, "Timesuaxe9") <= 0)
    {
        new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar, -1904.7286,273.0300,40.7482);
		SetVehicleZAngle(tmpcar, 180.0373);
		format(string, sizeof(string), "~y~Bao duong xong");
		GivePlayerCash(playerid, -2000);
		SendClientMessage(playerid, COLOR_GREEN, "[!] Da sua xe xong, chi phi: $2,000!");
		GameTextForPlayer(playerid, string, 5000, 3);
		SetVehicleHealth(tmpcar, 1000.0);
		Vehicle_Armor(tmpcar);
		DeletePVar(playerid, "Timesuaxe9");
    }
}
