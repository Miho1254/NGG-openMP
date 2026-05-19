new Float:water_places[20][4] =
{
	{30.0,			2313.0,		-1417.0,	23.0},
	{15.0,			1280.0,		-773.0,		1083.0},
	{25.0,			2583.0,		2385.0,		15.0},
	{20.0,			225.0,		-1187.0,	74.0},
	{50.0,			1973.0,		-1198.0,	17.0},
	{180.0,			1937.0, 	1589.0,		9.0},
	{55.0,			2142.0,		1285.0, 	8.0},
	{45.0,			2150.0,		1132.0,		8.0},
	{55.0,			2089.0,		1915.0,		10.0},
	{32.0,			2531.0,		1567.0,		9.0},
	{21.0,			2582.0,		2385.0,		17.0},
	{33.0,			1768.0,		2853.0,		10.0},
	{47.0,			-2721.0,	-466.0,		4.0},
	{210.0,			-671.0,		-1898.0,	6.0},
	{45.0,			1240.0,		-2381.0,	9.0},
	{50.0,			1969.0,		-1200.0,	18.0},
	{10.0,			513.0,		-1105.0,	79.0},
	{20.0,			193.0,		-1230.0,	77.0},
	{30.0,			1094.0,		-672.0,		113.0},
	{20.0,			1278.0,		-805.0,		87.0}
};


/*
	Distance between 2 points in 3D space
*/
stock Float:Distance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
	return floatsqroot((((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))+((z1-z2)*(z1-z2))));

/*
	Distance between 2 points in 2D space
*/
stock Float:Distance2D(Float:x1, Float:y1, Float:x2, Float:y2)
	return floatsqroot( ((x1-x2)*(x1-x2)) + ((y1-y2)*(y1-y2)) );

	
stock IsPlayerInWater(playerid)
{
	new
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

	if(z < 44.0)
	{
		if(Distance(x, y, z, -965.0, 2438.0, 42.0) <= 700.0)
			return 1;
	}

	if(z < 1.9)
		return !(Distance(x, y, z, 618.4129, 863.3164, 1.0839) < 200.0);

	for(new i; i < sizeof(water_places); i++)
	{
		if(Distance2D(x, y, water_places[i][1], water_places[i][2]) <= water_places[i][0])
		{
			if(z < water_places[i][3])
				return 1;
		}
	}

	return 0;
}


SwimFlyCheck(playerid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
        return 0;

    if(GetPVarType(playerid, "Injured") || PlayerInfo[playerid][pHospital])
    {
        return 0;
    }

    new
        animlib[32],
        animname[32];

    GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));

    if(isnull(animlib))
        return 0;
    if(!strcmp(animlib, "PARACHUTE") && (!strcmp(animname, "FALL_SKYDIVE") || !strcmp(animname, "FALL_SKYDIVE_ACCEL")))
    {
        new weapon, ammo;
        GetPlayerWeaponData(playerid, 11, weapon, ammo);
        if( weapon != WEAPON_PARACHUTE && PlayerInfo[playerid][pAdmin] < 1)
        {
            new msg[256];
            format(msg,sizeof(msg),"{AA3333}GTN-Warning{FFFF00}: %s (%d) bi tu dong kick khoi may chu. Ly do: Surfly.",GetPlayerNameEx(playerid), playerid);
            ABroadCast(COLOR_YELLOW, msg, 2);
            Log("logs/hack.log", msg);
            KickEx(playerid);
            DeletePVar(playerid, "FlyHack");
        }
    }
    if(!strcmp(animlib, "SWIM"))
    {
        new
            Float:x,
            Float:y,
            Float:z;

        GetPlayerPos(playerid, x, y, z);

        if(x == 0.0 && y == 0.0 && z == 0.0)
            return 0;

        if(!IsPlayerInWater(playerid))
        {
            new msg[256];
            format(msg,sizeof(msg),"{AA3333}GTN-Warning{FFFF00}: %s (%d) bi kick khoi may chu. Ly do: Fly.",GetPlayerNameEx(playerid), playerid);
            ABroadCast(COLOR_YELLOW, msg, 2);
            Log("logs/hack.log", msg);
            KickEx(playerid);
        }
    }

    return 1;
}


stock ExecuteNOPAction(playerid)
{
	new string[128];
	new newcar = GetPlayerVehicleID(playerid);
	if(NOPTrigger[playerid] >= MAX_NOP_WARNINGS) { return 1; }
	NOPTrigger[playerid]++;
	RemovePlayerFromVehicle(playerid);
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPos(playerid, X, Y, Z+2);
	defer NOPCheck(playerid);
	if(NOPTrigger[playerid] > 1)
	{
		new sec = (NOPTrigger[playerid] * 5000)/1000-1;
		format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) may be NOP hacking - restricted vehicle (model %d) for %d seconds.", GetPlayerNameEx(playerid), playerid, GetVehicleModel(newcar),sec);
		ABroadCast(COLOR_YELLOW, string, 2);
	}
	return 1;
}

stock ExecuteHackerAction( playerid, weaponid )
{
	if(!gPlayerLogged{playerid}) { return 1; }
	if(PlayerInfo[playerid][pTut] == 0) { return 1; }
	if(playerTabbed[playerid] >= 1) { return 1; }
	if(GetPVarType(playerid, "IsInArena")) { return 1; }

	new String[ 128 ], WeaponName[ 128 ];
	GetWeaponName( weaponid, WeaponName, sizeof( WeaponName ) );

	format( String, sizeof( String ), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) co the dang Hack Vu Khi (%s).", GetPlayerNameEx(playerid), playerid, WeaponName );
	ABroadCast( COLOR_YELLOW, String, 2 );
	format(String, sizeof(String), "%s(%d) (ID %d) may possibly be weapon hacking (%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerid, WeaponName);
	Log("logs/hack.log", String);
	Kick(playerid);
	return 1;
}

forward sobeitCheck(playerid);
public sobeitCheck(playerid)
{
	if(GetPVarInt(playerid, "JailDelay") == 0)
	{
	    if(PlayerInfo[playerid][pJailTime] > 0)
		{
	        SetTimerEx("sobeitCheck", 1000, 0, "i", playerid);
	        SetPVarInt(playerid, "JailDelay", 1);
	        return 1;
	    }
	}

	DeletePVar(playerid, "JailDelay");
    if(IsPlayerFrozen[playerid] == 1)
	{
        new Float:hX, Float:hY, Float:hZ, Float:pX, Float:pY, Float:pZ, Float:cX, Float:cY, Float:cZ, Float:cX1, Float:cY1, Float:cZ1;
        GetPlayerCameraFrontVector(playerid, cX1, cY1, cZ1);
		GetPlayerPos(playerid, cX, cY, cZ);
        hX = GetPVarFloat(playerid, "FrontVectorX");
        hY = GetPVarFloat(playerid, "FrontVectorY");
        hZ = GetPVarFloat(playerid, "FrontVectorZ");
        pX = GetPVarFloat(playerid, "PlayerPositionX");
        pY = GetPVarFloat(playerid, "PlayerPositionY");
        pZ = GetPVarFloat(playerid, "PlayerPositionZ");

        if(pX != cX && pY != cY && pZ != cZ && hX != cX1 && hY != cY1 && hZ != cZ1)
        {
            SendClientMessageEx(playerid, COLOR_RED, "You have failed the player account check, please relog and try again!");
            IsPlayerFrozen[playerid] = 0;
            DeletePVar(playerid,"FrontVectorX");
            DeletePVar(playerid,"FrontVectorY");
            DeletePVar(playerid,"FrontVectorZ");
            DeletePVar(playerid,"PlayerPositionX");
            DeletePVar(playerid,"PlayerPositionY");
            DeletePVar(playerid,"PlayerPositionZ");
            SetTimerEx("KickEx", 1000, 0, "i", playerid);
            return 1;
        }
	}

	new Float:aX, Float:aY, Float:aZ, szString[128];
	GetPlayerCameraFrontVector(playerid, aX, aY, aZ);
	#pragma unused aX
	#pragma unused aY

	if(aZ < -0.7)
	{
		new IP[32];
		GetPlayerIp(playerid, IP, sizeof(IP));
		TogglePlayerControllable(playerid, true);

	 	if(PlayerInfo[playerid][pSMod] == 1 || PlayerInfo[playerid][pAdmin] == 1)
 		{
 		    mysql_format(MainPipeline, szString, sizeof(szString), "SELECT `Username` FROM `accounts` WHERE `AdminLevel` > 1 AND `Disabled` = 0 AND `IP` = '%s'", GetPlayerIpEx(playerid));
 		    mysql_tquery(MainPipeline, szString, "CheckAccounts", "i", playerid);
       	}
		else {
		    mysql_format(MainPipeline, szString, sizeof(szString), "INSERT INTO `sobeitkicks` (sqlID, Kicks) VALUES (%d, 1) ON DUPLICATE KEY UPDATE Kicks = Kicks + 1", GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, szString, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

			SendClientMessageEx(playerid, COLOR_RED, "The hacking tool 's0beit' is not allowed on this server, please uninstall it.");
   			format(szString, sizeof(szString), "%s(%d) (IP: %s) has logged into the server with s0beit installed.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), IP);
   			Log("logs/sobeit.log", szString);
   			IsPlayerFrozen[playerid] = 0;
    		SetTimerEx("KickEx", 1000, 0, "i", playerid);
     	}

	}
	
	if(playerTabbed[playerid] > 2) { SendClientMessageEx(playerid, COLOR_RED, "You have failed the account check, please relog."), SetTimerEx("KickEx", 1000, 0, "i", playerid); }

	if(PlayerInfo[playerid][pVW] > 0 || PlayerInfo[playerid][pInt] > 0) HideNoticeGUIFrame(playerid);
	sobeitCheckvar[playerid] = 1;
	sobeitCheckIsDone[playerid] = 1;
	IsPlayerFrozen[playerid] = 0;
	TogglePlayerControllable(playerid, true);
 	return 1;
}

//Dom - Adjusted to account for latest rapid fire exploits - Rothschild. 
ptask Anti_Rapidfire[1000](i)
{
	new weaponid = GetPlayerWeapon(i);
	if(((weaponid == 24 || weaponid == 25 || weaponid == 26) && PlayerShots[i] > 10) || ((weaponid == 34) && PlayerSniperShots[i] > 10)) // Updated to a higher value due to high rate of false positives.
	{
		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (%d): %d shots in 1 second -- Weapon ID: %d", GetPlayerNameEx(i), i, GetPVarInt(i, "pSQLID"), PlayerShots[i], weaponid);
		Log("logs/rapid.log", szMiscArray);

		SetPVarInt(i, "MaxRFWarn", GetPVarInt(i, "MaxRFWarn")+1);
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) may be rapidfire hacking. %d/%d warnings", GetPlayerNameEx(i), i, GetPVarInt(i, "MaxRFWarn"), MAX_RF_WARNS);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);
		if(GetPVarInt(i, "MaxRFWarn") >= MAX_RF_WARNS)
		{
			if(GetPVarType(i, "Autoban")) return 1;
			SetPVarInt(i, "Autoban", 1); 
			DeletePVar(i, "MaxRFWarn");
			CreateBan(INVALID_PLAYER_ID, PlayerInfo[i][pId], i, PlayerInfo[i][pIP], "Anti-Cheat: RapidFire Hacking", 180);
			TotalAutoBan++;
		}
	} 
	PlayerShots[i] = 0;
	PlayerSniperShots[i] = 0;
	return 1;
}

ptask Anti_Invisibility[5000](i)
{
	if(GetPlayerState(i) == PLAYER_STATE_SPECTATING && Spectating[i] == INVALID_PLAYER_ID && PlayerInfo[i][pAdmin] < 2)
	{
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) is using Invisibility CLEOs.", GetPlayerNameEx(i), i);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);
	}
}

ptask Anti_RapidKill[5000](i)
{
	if(PlayerKills[i] >= 5 && PlayerInfo[i][pAdmin] < 2)
	{
		CreateBan(INVALID_PLAYER_ID, PlayerInfo[i][pId], i, PlayerInfo[i][pIP], "Anti-Cheat: Ghost Hacking", 180);
	}
	PlayerKills[i] = 0;
	return 1;
}

forward LoginCheckEx(i);
public LoginCheckEx(i)
{
	new Float: pos[3], string[128];
	if(gPlayerLogged{i} == 0 && IsPlayerConnected(i))
	{
		/* INFORMATION REGARDING COORDS
			1093.000000 | -2036.000000 | 90.000000 // Start view of beach (Sometimes triggers via delay)
			0.000000 | 0.000000 | 0.000000 // Default location normally triggered first if above doesn't
			50.000000 | 50.000000 | 50.000000 // 2-3 timer check your at these coords unsure why you move to all 50.
		*/
		GetPlayerPos(i, pos[0], pos[1], pos[2]);
		if((pos[0] != 1093.000000 && pos[0] != 0.000000 && pos[0] != 50.000000) && (pos[1] != -2036.000000 && pos[1] != 0.000000 && pos[1] != 50.000000) && (pos[2] != 90.000000 && pos[2] != 0.000000 && pos[2] != 50.000000))
		{
			format(string, sizeof(string), "%s(%d) [%s] has moved from the login screen position.", GetPlayerNameEx(i), GetPlayerSQLId(i), GetPlayerIpEx(i));
			Log("logs/security.log", string);
			SendClientMessage(i, COLOR_WHITE, "SERVER: Ban da di chuyen trong khi dang o man hinh dang nhap!");
			ShowPlayerDialogEx(i, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
			SetTimerEx("KickEx", 1000, 0, "i", i);
		}
		SetTimerEx("LoginCheckEx", 5000, 0, "i", i);
	}
	return true;
}

stock CheckServerAd(szInput[]) {

	new
		iCount,
		iPeriod,
		iPos,
		iChar,
		iColon;

	while((iChar = szInput[iPos++])) {
		if('0' <= iChar <= '9') iCount++;
		else if(iChar == '.') iPeriod++;
		else if(iChar == ':') iColon++;
	}
	if(iCount >= 7 && iPeriod >= 3 && iColon >= 1) {
		return 1;
	}

	return 0;
}

CMD:hackwarnings(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return 1;
	new Float: health,
		Float: rhealth,
		Float: armor,
		Float: rarmor;
	
	szMiscArray[0] = 0;

	foreach(new i : Player)
	{
		if(playerTabbed[i] != 0) continue;
		GetPlayerHealth(i, health);
		GetHealth(i, rhealth);
		GetPlayerArmour(i, armor);
		GetArmour(i, rarmor);
		if(health > rhealth)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s (ID: %i, Level: %d) - Health - Recorded: %f - Current: %f", GetPlayerNameEx(i), i, PlayerInfo[i][pLevel], rhealth, health);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
		}
		if(armor > rarmor)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s (ID: %i, Level: %d) - Armor - Recorded: %f - Current: %f", GetPlayerNameEx(i), i, PlayerInfo[i][pLevel], rarmor, armor);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
		}
	}
	return 1;
}