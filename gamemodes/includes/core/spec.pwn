#include <YSI\y_hooks>


#define SPECTATE_TYPE_PLAYER 0
#define SPECTATE_TYPE_VEHICLE 1



new const Float:VEHICLE_TOP_SPEEDS[] =
{
	157.0, 147.0, 186.0, 110.0, 133.0, 164.0, 110.0, 148.0, 100.0, 158.0, 129.0, 221.0, 168.0, 110.0, 105.0, 192.0, 154.0, 270.0, 115.0, 149.0,
	145.0, 154.0, 140.0, 99.0,  135.0, 270.0, 173.0, 165.0, 157.0, 201.0, 190.0, 130.0, 94.0,  110.0, 167.0, 0.0,   149.0, 158.0, 142.0, 168.0,
	136.0, 145.0, 139.0, 126.0, 110.0, 164.0, 270.0, 270.0, 111.0, 0.0,   0.0,   193.0, 270.0, 60.0,  135.0, 157.0, 106.0, 95.0,  157.0, 136.0,
	270.0, 160.0, 111.0, 142.0, 145.0, 145.0, 147.0, 140.0, 144.0, 270.0, 157.0, 110.0, 190.0, 190.0, 149.0, 173.0, 270.0, 186.0, 117.0, 140.0,
	184.0, 73.0,  156.0, 122.0, 190.0, 99.0,  64.0,  270.0, 270.0, 139.0, 157.0, 149.0, 140.0, 270.0, 214.0, 176.0, 162.0, 270.0, 108.0, 123.0,
	140.0, 145.0, 216.0, 216.0, 173.0, 140.0, 179.0, 166.0, 108.0, 79.0,  101.0, 270.0,	270.0, 270.0, 120.0, 142.0, 157.0, 157.0, 164.0, 270.0,
	270.0, 160.0, 176.0, 151.0, 130.0, 160.0, 158.0, 149.0, 176.0, 149.0, 60.0,  70.0,  110.0, 167.0, 168.0, 158.0, 173.0, 0.0,   0.0,   270.0,
	149.0, 203.0, 164.0, 151.0, 150.0, 147.0, 149.0, 142.0, 270.0, 153.0, 145.0, 157.0, 121.0, 270.0, 144.0, 158.0, 113.0, 113.0, 156.0, 178.0,
	169.0, 154.0, 178.0, 270.0, 145.0, 165.0, 160.0, 173.0, 146.0, 0.0,   0.0,   93.0,  60.0,  110.0, 60.0,  158.0, 158.0, 270.0, 130.0, 158.0,
	153.0, 151.0, 136.0, 85.0,  0.0,   153.0, 142.0, 165.0, 108.0, 162.0, 0.0,   0.0,   270.0, 270.0, 130.0, 190.0, 175.0, 175.0, 175.0, 158.0,
	151.0, 110.0, 169.0, 171.0, 148.0, 152.0, 0.0,   0.0,   0.0,   108.0, 0.0,   0.0
};


new Iterator:SpectatePlayers<MAX_PLAYERS>;

new Text:playerInfoFrameTD[6];
new Text:playerInfoTD[7];
new Text:vehicleInfoFrameTD[2];
new Text:vehicleInfoTD[4];

new PlayerText:playerInfoPTD[MAX_PLAYERS][9];
new PlayerText:vehicleInfoPTD[MAX_PLAYERS][5];

new spectateID[MAX_PLAYERS];
new spectateType[MAX_PLAYERS];

new playerVirtualWorld[MAX_PLAYERS];

//new oldPlayerVirtualWorld[MAX_PLAYERS];
//new oldPlayerInterior[MAX_PLAYERS];
//new Float:oldPlayerPosition[MAX_PLAYERS][4];





stock CreatePlayerTXDSpec(playerid) {


	playerInfoPTD[playerid][0] = CreatePlayerTextDraw(playerid, 501.000000, 176.933319, "IC");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][0], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][0], 0);

	playerInfoPTD[playerid][1] = CreatePlayerTextDraw(playerid, 614.000000, 181.288879, "(13)");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][1], 0.284500, 1.207999);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][1], 0);

	playerInfoPTD[playerid][2] = CreatePlayerTextDraw(playerid, 500.000000, 193.111114, "HEALTH");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][2], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][2], 0);

	playerInfoPTD[playerid][3] = CreatePlayerTextDraw(playerid, 500.000000, 204.711822, "ARMOUR");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][3], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][3], 0);

	playerInfoPTD[playerid][4] = CreatePlayerTextDraw(playerid, 500.000000, 216.412536, "WEAPON");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][4], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][4], 0);

	playerInfoPTD[playerid][5] = CreatePlayerTextDraw(playerid, 500.000000, 227.813232, "MONEY");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][5], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][5], 0);
	
	playerInfoPTD[playerid][7] = CreatePlayerTextDraw(playerid, 500.000000, 251.714691, "IP");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][7], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][7], 0);

    playerInfoPTD[playerid][8] = CreatePlayerTextDraw(playerid, 499.500000, 264.159149, "HOUR");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][8], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][8], 0);

	playerInfoPTD[playerid][6] = CreatePlayerTextDraw(playerid, 500.000000, 239.613952, "SPEED");
	PlayerTextDrawLetterSize(playerid, playerInfoPTD[playerid][6], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, playerInfoPTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, playerInfoPTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, playerInfoPTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, playerInfoPTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, playerInfoPTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, playerInfoPTD[playerid][6], 0);

//veh
	vehicleInfoPTD[playerid][0] = CreatePlayerTextDraw(playerid, 501.000000, 284.837890, "VEH");
	PlayerTextDrawLetterSize(playerid, vehicleInfoPTD[playerid][0], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, vehicleInfoPTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, vehicleInfoPTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, vehicleInfoPTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleInfoPTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, vehicleInfoPTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, vehicleInfoPTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][0], 0);

	vehicleInfoPTD[playerid][1] = CreatePlayerTextDraw(playerid, 604.500000, 276.488891, "");
	PlayerTextDrawLetterSize(playerid, vehicleInfoPTD[playerid][1], 0.294999, 1.083556);
	PlayerTextDrawAlignment(playerid, vehicleInfoPTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, vehicleInfoPTD[playerid][1], -1061109505);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, vehicleInfoPTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleInfoPTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, vehicleInfoPTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, vehicleInfoPTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][1], 0);

	vehicleInfoPTD[playerid][2] = CreatePlayerTextDraw(playerid, 569.000000, 299.149017, "HEALTH");
	PlayerTextDrawLetterSize(playerid, vehicleInfoPTD[playerid][2], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, vehicleInfoPTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, vehicleInfoPTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, vehicleInfoPTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleInfoPTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, vehicleInfoPTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, vehicleInfoPTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][2], 0);

	vehicleInfoPTD[playerid][3] = CreatePlayerTextDraw(playerid, 501.500000, 299.149017, "SPEED");
	PlayerTextDrawLetterSize(playerid, vehicleInfoPTD[playerid][3], 0.345500, 1.015111);
	PlayerTextDrawAlignment(playerid, vehicleInfoPTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, vehicleInfoPTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, vehicleInfoPTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleInfoPTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, vehicleInfoPTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, vehicleInfoPTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][3], 0);

	vehicleInfoPTD[playerid][4] = CreatePlayerTextDraw(playerid, 499.000000, 309.466735, "Max_120");
	PlayerTextDrawLetterSize(playerid, vehicleInfoPTD[playerid][4], 0.229999, 0.654222);
	PlayerTextDrawAlignment(playerid, vehicleInfoPTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, vehicleInfoPTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, vehicleInfoPTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleInfoPTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, vehicleInfoPTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, vehicleInfoPTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, vehicleInfoPTD[playerid][4], 0);
}

Float:GetSpeed(Float:vx, Float:vy, Float:vz) { // units: KM/H
    return floatsqroot(floatpower(vx, 2.0) + floatpower(vy, 2.0) + floatpower(vz, 2.0)) * 180.0;
}

GetVehicleModelName(modelid, dest[], maxlength) {
	return format(dest, maxlength, VehicleName[modelid - 400]);
}

Float:GetVehicleModelTopSpeed(modelid) {
	return VEHICLE_TOP_SPEEDS[modelid - 400];
}

FormatNumber(number) {
	new numOfPeriods = 0;
	new tmp = number;
	new ret[32];

	while(tmp > 1000) {
		tmp = floatround(tmp / 1000, floatround_floor);
		++numOfPeriods;
	}

	valstr(ret, number);

	new slen = strlen(ret);
	for(new i = 1; i != (numOfPeriods + 1); ++i) {
		strins(ret, ",", (slen - 3 * i));
	}

	return ret;
}

ShowPlayerInfo(playerid, giveplayerid) {
	TextDrawSetPreviewModel(playerInfoTD[1], GetPlayerSkin(giveplayerid));

	new name[MAX_PLAYER_NAME];
	GetPlayerName(giveplayerid, name, MAX_PLAYER_NAME);
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][0], name);
	PlayerTextDrawColor(playerid, playerInfoPTD[playerid][0], ((GetPlayerColor(giveplayerid) & ~0xFF) | 0xFF));

	new string[128];
	format(string, sizeof(string), "[%i]", giveplayerid);
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][1], string);

	
	
	format(string, sizeof(string), "HOUR: ~w~%d - Level: ~w~%d", PlayerInfo[giveplayerid][pConnectHours], PlayerInfo[giveplayerid][pLevel]);
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][8], string);

	for (new i = 0; i < sizeof(playerInfoPTD[]); i++) {
	    PlayerTextDrawShow(playerid, playerInfoPTD[playerid][i]);
	}

	for (new i = 0; i < sizeof(playerInfoFrameTD); i++) {
	    TextDrawShowForPlayer(playerid, playerInfoFrameTD[i]);
	}

	for (new i = 0; i < sizeof(playerInfoTD); i++) {
	    TextDrawShowForPlayer(playerid, playerInfoTD[i]);
	}
	
	for (new i = 0; i < sizeof(TDE_SPEC); i++) {
	    TextDrawShowForPlayer(playerid, TDE_SPEC[i]);
	}
}

HidePlayerInfo(playerid) {
	for (new i = 0; i < sizeof(playerInfoPTD[]); i++) {
	    PlayerTextDrawHide(playerid, playerInfoPTD[playerid][i]);
	}

	for (new i = 0; i < sizeof(playerInfoFrameTD); i++) {
	    TextDrawHideForPlayer(playerid, playerInfoFrameTD[i]);
	}

	for (new i = 0; i < sizeof(playerInfoTD); i++) {
	    TextDrawHideForPlayer(playerid, playerInfoTD[i]);
	}
	for (new i = 0; i < sizeof(TDE_SPEC); i++) {
	    TextDrawHideForPlayer(playerid, TDE_SPEC[i]);
	}
}

UpdatePlayerInfo(playerid, giveplayerid) {
	new Float:armour;
	new Float:health;
	new string[128];
	


	GetPlayerHealth(giveplayerid, health);
	format(string, sizeof(string), "HEALTH: ~r~%i", floatround(health));
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][2], string);

	GetPlayerArmour(giveplayerid, armour);
	format(string, sizeof(string), "ARMOUR: ~w~%i", floatround(armour));
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][3], string);

	new playerip[32];
	GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
	format(string, sizeof(string), "IP:~y~%s~w~ - ~y~%d", playerip, GetPlayerPing(giveplayerid));
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][7], string);
	
	if (GetPlayerWeapon(giveplayerid) == 0) {
	    string = "WEAPON: ~g~Trong";
	}
	else {
		GetWeaponName(GetPlayerWeapon(giveplayerid), string, sizeof(string));
		format(string, sizeof(string), "WEAPON: ~b~%s", string); //GetPlayerAmmo(giveplayerid) ammo vu khi
	}
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][4], string);

    format(string, sizeof(string), "MONEY: ~b~$~w~%s", FormatNumber(GetPlayerMoney(giveplayerid)));
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][5], string);
	
	new Float:vx, Float:vy, Float:vz;
	GetPlayerVelocity(giveplayerid, vx, vy, vz);
	format(string, sizeof(string), "SPEED: %0.1f Velocity", (GetSpeed(vx, vy, vz) / 1.609344));
	PlayerTextDrawSetString(playerid, playerInfoPTD[playerid][6], string);

}

ShowVehicleInfo(playerid, vehicleid) {
	new modelid = GetVehicleModel(vehicleid);
	TextDrawSetPreviewModel(vehicleInfoTD[1], modelid);

	new string[128];
    GetVehicleModelName(modelid, string, sizeof(string));
	PlayerTextDrawSetString(playerid, vehicleInfoPTD[playerid][0], string);

	format(string, sizeof(string), "[ID:%i]SPEED: %0.1f km/h", modelid, GetVehicleModelTopSpeed(modelid));
	PlayerTextDrawSetString(playerid, vehicleInfoPTD[playerid][4], string);

	for (new i = 0; i < sizeof(vehicleInfoPTD[]); i++) {
	    PlayerTextDrawShow(playerid, vehicleInfoPTD[playerid][i]);
	}

	for (new i = 0; i < sizeof(vehicleInfoFrameTD); i++) {
	    TextDrawShowForPlayer(playerid, vehicleInfoFrameTD[i]);
	}

	for (new i = 0; i < sizeof(vehicleInfoTD); i++) {
	    TextDrawShowForPlayer(playerid, vehicleInfoTD[i]);
	}
}

HideVehicleInfo(playerid) {
	for (new i = 0; i < sizeof(vehicleInfoPTD[]); i++) {
	    PlayerTextDrawHide(playerid, vehicleInfoPTD[playerid][i]);
	}

	for (new i = 0; i < sizeof(vehicleInfoFrameTD); i++) {
	    TextDrawHideForPlayer(playerid, vehicleInfoFrameTD[i]);
	}

	for (new i = 0; i < sizeof(vehicleInfoTD); i++) {
	    TextDrawHideForPlayer(playerid, vehicleInfoTD[i]);
	}
}

UpdateVehicleInfo(playerid, vehicleid) {
	new Float:amount;
	GetVehicleHealth(vehicleid, amount);

	new string[128];
	format(string, sizeof(string), "HP:~r~%i", floatround(amount));
	PlayerTextDrawSetString(playerid, vehicleInfoPTD[playerid][2], string);

	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(vehicleid, vx, vy, vz);
	format(string, sizeof(string), "KM/H:~w~%0.1f", GetSpeed(vx, vy, vz));
	PlayerTextDrawSetString(playerid, vehicleInfoPTD[playerid][3], string);
}


GetPreviousPlayer(current) {
	new prev = INVALID_PLAYER_ID;

	if (Iter_Count(SpectatePlayers) > 1) {
		if (Iter_Contains(SpectatePlayers, current)) {
			prev = Iter_Prev(SpectatePlayers, current);

			if (prev == Iter_Begin(SpectatePlayers)) {
			    prev = Iter_Last(SpectatePlayers);
			}
		}
	}

	return prev;
}

StartSpectate(playerid, giveplayerid) {
	
	TogglePlayerSpectating(playerid, 1);
	//Spectating[playerid] = 1;
    SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));

	new vehicleid = GetPlayerVehicleID(giveplayerid);
	if (vehicleid != 0) {
		PlayerSpectateVehicle(playerid, vehicleid, SPECTATE_MODE_NORMAL);
		ShowPlayerInfo(playerid, giveplayerid);
		ShowVehicleInfo(playerid, vehicleid);
	}
	else {
	    PlayerSpectatePlayer(playerid, giveplayerid, SPECTATE_MODE_NORMAL);
		ShowPlayerInfo(playerid, giveplayerid);
		HideVehicleInfo(playerid);
	}

    spectateID[playerid] = giveplayerid;
    spectateType[playerid] = (vehicleid != 0) ? SPECTATE_TYPE_VEHICLE : SPECTATE_TYPE_PLAYER;

	return 1;
}

StopSpectate(playerid) {
	TogglePlayerSpectating(playerid, 0);

    HidePlayerInfo(playerid);
    HideVehicleInfo(playerid);

	spectateID[playerid] = INVALID_PLAYER_ID;

	return CancelSelectTextDraw(playerid);
}

hook OnFilterScriptInit() {

    
	return 1;
}

hook OnFilterScriptExit() {
	for (new i = 0; i < sizeof(playerInfoFrameTD); i++) {
	    TextDrawDestroy(playerInfoFrameTD[i]);
	}

	for (new i = 0; i < sizeof(playerInfoTD); i++) {
	    TextDrawDestroy(playerInfoTD[i]);
	}

	for (new i = 0; i < sizeof(vehicleInfoFrameTD); i++) {
	    TextDrawDestroy(vehicleInfoFrameTD[i]);
	}

	for (new i = 0; i < sizeof(vehicleInfoTD); i++) {
	    TextDrawDestroy(vehicleInfoTD[i]);
	}
	for (new i = 0; i < sizeof(TDE_SPEC); i++) {
	    TextDrawDestroy(TDE_SPEC[i]);
	}

	return 1;
}

hook OnPlayerConnect(playerid) {
    spectateID[playerid] = INVALID_PLAYER_ID;

    CreatePlayerTXDSpec(playerid);

	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
	    new vehicleid = GetPlayerVehicleID(playerid);

	    foreach (new i : Player) {
			if (spectateID[i] == playerid) {
    			PlayerSpectateVehicle(i, vehicleid, SPECTATE_MODE_NORMAL);

				ShowVehicleInfo(i, vehicleid);
    			spectateType[i] = SPECTATE_TYPE_VEHICLE;
			}
		}
	}
	else if (newstate == PLAYER_STATE_ONFOOT) {
	    foreach (new i : Player) {
			if (spectateID[i] == playerid) {
    			PlayerSpectatePlayer(i, playerid, SPECTATE_MODE_NORMAL);

				HideVehicleInfo(i);
    			spectateType[i] = SPECTATE_TYPE_PLAYER;
			}
		}
	}
	else if (newstate == PLAYER_STATE_SPECTATING) {
        new prev = GetPreviousPlayer(playerid);

        if (prev == INVALID_PLAYER_ID) {
		    foreach (new i : Player) {
				if (spectateID[i] == playerid) {
					StopSpectate(i);
				}
			}
		}
		else {
		    foreach (new i : Player) {
				if (spectateID[i] == playerid) {
					StartSpectate(i, prev);
				}
			}
		}

    	Iter_Remove(SpectatePlayers, playerid);
	}

	return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	foreach (new i : Player) {
		if (spectateID[i] == playerid) {
			SetPlayerInterior(i, newinteriorid);
  		}
	}

 	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    new prev = GetPreviousPlayer(playerid);

    if (prev == INVALID_PLAYER_ID) {
	    foreach (new i : Player) {
			if (spectateID[i] == playerid) {
				StopSpectate(i);
			}
		}
	}
	else {
	    foreach (new i : Player) {
			if (spectateID[i] == playerid) {
				StartSpectate(i, prev);
			}
		}
	}

   	Iter_Remove(SpectatePlayers, playerid);

	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

    new Float:cx, Float:cy, Float:cz;
	GetPlayerCameraPos(playerid, cx, cy, cz);

	cz += !GetPlayerInterior(playerid) ? 5.0 : 0.5;

	foreach (new i : Player) {
		if (spectateID[i] == playerid) {
			SetPlayerCameraPos(i, cx, cy, cz);
			SetPlayerCameraLookAt(i, x, y, z);
		}
	}

	Iter_Remove(SpectatePlayers, playerid);

	return 1;
}

hook OnPlayerSpawn(playerid) {
	Iter_Add(SpectatePlayers, playerid);

	foreach (new i : Player) {
		if (spectateID[i] == playerid) {
			StartSpectate(i, playerid);
		}
	}

	return 1;
}


hook OnPlayerUpdate(playerid) {
	new worldid = GetPlayerVirtualWorld(playerid);
	if (playerVirtualWorld[playerid] != worldid) {
        playerVirtualWorld[playerid] = worldid;

		foreach (new i : Player) {
			if (spectateID[i] == playerid) {
				SetPlayerVirtualWorld(i, worldid);
	  		}
		}
	}

	foreach (new i : Player) {
	    if (spectateID[i] == playerid) {
			UpdatePlayerInfo(i, playerid);

			if (spectateType[i] == SPECTATE_TYPE_VEHICLE) {
				UpdateVehicleInfo(i, GetPlayerVehicleID(playerid));
			}
		}
	}

	return 1;
}

CMD:spec(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pPWSpec] < 1 && PlayerInfo[playerid][pHelper] < 3 && !GetPVarType(playerid, "pWatchdogWatching"))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay.");
		return 1;
	}
	if(strcmp(params, "off", true) == 0)
	{
		if(Spectating[playerid] > 0 && PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 2 && Spectating[playerid] > 0)
		{
		    if(GetPVarType(playerid, "pWatchdogWatching"))
			{
			    SendClientMessage(playerid, COLOR_WHITE, "You have stopped DM Watching.");
				DeletePVar(playerid, "pWatchdogWatching");
			}
			GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
			Spectating[playerid] = 0;
			Spectate[playerid] = INVALID_PLAYER_ID;
			SetPVarInt(playerid, "SpecOff", 1 );
			TogglePlayerSpectating(playerid, false);
			SetCameraBehindPlayer(playerid);
			StopSpectate(playerid);
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You're not spectating anyone.");
			return 1;
		}
	}

	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /spec (playerid/off)");
	if(IsPlayerConnected(giveplayerid))
	{
	    if((PlayerInfo[playerid][pHelper] >= 3 && !(2 <= PlayerInfo[giveplayerid][pHelper] <= 4)) && !GetPVarType(playerid, "pWatchdogWatching"))
	    {
	        SendClientMessageEx(playerid, COLOR_GREY, "You can only spectate other advisors");
			return 1;
		}
		if(GetPVarType(playerid, "pWatchdogWatching") && (GetPVarInt(playerid, "pWatchdogWatching") != giveplayerid))
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "You can only spectate the person you are DM Watching.");
			return 1;
		}
		if(PlayerInfo[giveplayerid][pAdmin] == 99999 && !GetPVarType(giveplayerid, "EASpecable")) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot spectate this person.");
		if(PlayerInfo[playerid][pAdmin] >= 4 && Spectate[giveplayerid] != INVALID_PLAYER_ID && Spectating[giveplayerid] == 1)
		{
			new string[128];
			format(string, sizeof(string), "Admin %s is speccing %s", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(Spectate[giveplayerid]));
			SendClientMessageEx(playerid, COLOR_GREEN, string);
			return 1;
		}
		SpectatePlayer(playerid, giveplayerid);
		StartSpectate(playerid, giveplayerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Target is not available.");
	}
	return 1;
}
