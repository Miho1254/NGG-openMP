/*
	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/
						Speedo System
				SAW Community, LLC
	(created by SAW Community Development Team)

	* Copyright (c) 2016, SAW Community, LLC
	*
	* All rights reserved.
	*
	* Redistribution and use in source and binary forms, with or without modification,
	* are not permitted in any case.
	*
	*
	* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

stock UpdateVehicleHUDForPlayer(p, fuel, speed)
{
	if (PlayerInfo[p][pSpeedo] == 0 || _vhudVisible[p] == 0) return;

	new str[128], vehicleid = GetPlayerVehicleID(p);
	if (vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) return;

	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	// Update speed text: Speedometr_PTD[p][10]
	format(str, sizeof(str), "%d", speed);
	PlayerTextDrawSetString(p, Speedometr_PTD[p][10], str);
	PlayerTextDrawShow(p, Speedometr_PTD[p][10]);

	// Update fuel text: Speedometr_PTD[p][18]
	format(str, sizeof(str), "FUEL: %d L", fuel);
	PlayerTextDrawSetString(p, Speedometr_PTD[p][18], str);
	PlayerTextDrawShow(p, Speedometr_PTD[p][18]);

	// Update vehicle name: Speedometr_PTD[p][1]
	PlayerTextDrawSetString(p, Speedometr_PTD[p][1], GetVehicleName(vehicleid));
	PlayerTextDrawShow(p, Speedometr_PTD[p][1]);

	// Update engine status: Speedometr_PTD[p][13] (default color: 0x949498FF)
	if (engine == VEHICLE_PARAMS_ON) {
		PlayerTextDrawColor(p, Speedometr_PTD[p][13], 0x42f56bFF); // Green
	} else {
		PlayerTextDrawColor(p, Speedometr_PTD[p][13], 0x949498FF); // Gray
	}
	PlayerTextDrawShow(p, Speedometr_PTD[p][13]);

	// Update lock status: Speedometr_PTD[p][14] (default color: 0xFF4228FF)
	if (doors == VEHICLE_PARAMS_ON) {
		PlayerTextDrawColor(p, Speedometr_PTD[p][14], 0xFF4228FF); // Red (Locked)
	} else {
		PlayerTextDrawColor(p, Speedometr_PTD[p][14], 0x42f56bFF); // Green (Unlocked)
	}
	PlayerTextDrawShow(p, Speedometr_PTD[p][14]);

	// Update light status: Speedometr_PTD[p][12] (default color: 0x949498FF)
	if (lights == VEHICLE_PARAMS_ON) {
		PlayerTextDrawColor(p, Speedometr_PTD[p][12], 0xf5ee42FF); // Yellow
	} else {
		PlayerTextDrawColor(p, Speedometr_PTD[p][12], 0x949498FF); // Gray
	}
	PlayerTextDrawShow(p, Speedometr_PTD[p][12]);
}

stock ShowVehicleHUDForPlayer(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if (vehicleid != INVALID_VEHICLE_ID) {
		PlayerTextDrawSetString(playerid, Speedometr_PTD[playerid][1], GetVehicleName(vehicleid));
	}
	for(new i = 0; i < 24; i++) {
		PlayerTextDrawShow(playerid, Speedometr_PTD[playerid][i]);
	}
	_vhudVisible[playerid] = 1;
}

stock HideVehicleHUDForPlayer(playerid)
{
	for(new i = 0; i < 24; i++) {
		PlayerTextDrawHide(playerid, Speedometr_PTD[playerid][i]);
	}
	_vhudVisible[playerid] = 0;
}

/*CMD:speedo(playerid, params[]) {
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
		SendClientMessageEx(playerid, COLOR_GREY, "You're not driving chiec xe.");
	}
	else if(!PlayerInfo[playerid][pSpeedo]) {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled your speedometer.");
		PlayerInfo[playerid][pSpeedo] = 1;
		if(!FindTimePoints[playerid] && arr_Engine{GetPlayerVehicleID(playerid)} != 0) {
			new
				szSpeed[42];
			format(szSpeed, sizeof(szSpeed),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%.0f MPH", player_get_speed(playerid));
			GameTextForPlayer(playerid, szSpeed, 1500, 3);
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled your speedometer.");
		PlayerInfo[playerid][pSpeedo] = 0;
		if(!FindTimePoints[playerid] && arr_Engine{GetPlayerVehicleID(playerid)} != 0) GameTextForPlayer(playerid, " ", 1500, 3);
	}
	return 1;
} // old speedometer */
// CMD:speedopos removed since custom PTD layout is static.

CMD:speedo(playerid, params[])
{
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER )
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dieu khien chiec xe nao ca.");
	}
	else if (!PlayerInfo[playerid][pSpeedo])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban da bat dong ho toc do.");
		PlayerInfo[playerid][pSpeedo] = 1;
		ShowVehicleHUDForPlayer(playerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban da tat dong ho toc do.");
		PlayerInfo[playerid][pSpeedo] = 0;
		HideVehicleHUDForPlayer(playerid);
	}

	return 1;
} // new speedometer
