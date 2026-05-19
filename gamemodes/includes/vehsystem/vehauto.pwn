#include <YSI\y_hooks>

#define VEHICLE_PARAMS_TOG	10030

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	new vehicleid = GetPlayerVehicleID(playerid);

	szMiscArray[0] = 0;

	if((newkeys & KEY_YES) && vehicleid != INVALID_VEHICLE_ID && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		//if(!AC_KeySpamCheck(playerid)) return 1;
		new engine,lights,alarm,doors,bonnet,boot,objective;
		if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510 || DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && GetVehicleModel(vehicleid) == 592) return SendClientMessageEx(playerid,COLOR_WHITE,"Lenh nay khong the su dung len chiec xe nay.");
		if(WheelClamp{vehicleid}) return SendClientMessageEx(playerid,COLOR_WHITE,"(( This vehicle has a wheel camp on its front tire, you will not be able to drive away with it. ))");

		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		if(engine == VEHICLE_PARAMS_ON)
		{
			SetVehicleEngine(vehicleid, playerid);
			format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s van chia khoa vao o va dong co dung lai.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else if((engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET))
		{
			if (GetPVarInt(playerid, "Refueling")) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay khi dang do xang.");
			// if(!Vehicle_LockCheck(playerid, vehicleid)) return 1;
			format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s van chia khoa vao o va dong co khoi dong.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SendClientMessageEx(playerid, COLOR_WHITE, "Dong co dang khoi dong, vui long cho...");
			SetTimerEx("SetVehicleEngine", 1000, 0, "dd",  vehicleid, playerid);
			RemoveVehicleFromMeter(vehicleid);
		}
		
	}
	if((newkeys & KEY_LOOK_BEHIND) && vehicleid != INVALID_VEHICLE_ID && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		
		if(!IsAPlane(vehicleid)) {
			ShowVehicleMenu(playerid, vehicleid);
		}
		
	}
	return 1;
}

stock Vehicle_LockCheck(playerid, iVehID) {

	new v;
	foreach(new i: Player) {
		v = GetPlayerVehicle(i, iVehID);
		if(v != -1) {
			if(IsABike(iVehID)) {
				if(PlayerVehicleInfo[i][v][pvLocked] == 1 && PlayerVehicleInfo[i][v][pvLock] > 0 && PlayerVehicleInfo[i][v][pvLocksLeft] > 0) {
					SendClientMessageEx(playerid, COLOR_WHITE, "This bike is currently locked.");
					return 0;
				}
			}
		}
	}
	return 1;	
}

ShowVehicleMenu(playerid, vehicleid) {
	
	szMiscArray[0] = 0;

	new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	format(szMiscArray, sizeof(szMiscArray), "Loai\tTrang thai\n\
		Thac day an toan hoac mu bao hiem\t%s\n\
		Den xe\t%s\n\
		Mui xe\t%s\n\
		Cop xe\t%s",
		((Seatbelt[playerid] == 0) ? ("Tat") : ("Bat")),
		((lights == VEHICLE_PARAMS_OFF) ? ("Tat") : ("Bat")),
		((bonnet == VEHICLE_PARAMS_OFF) ? ("Dong") : ("Mo")),
		((boot == VEHICLE_PARAMS_OFF) ? ("Dong") : ("Mo"))
	);

	ShowPlayerDialogEx(playerid, VEHICLE_PARAMS_TOG, DIALOG_STYLE_TABLIST_HEADERS, "Cai dat phuong tien", szMiscArray, "Chon", "Huy");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;

	switch(dialogid) {

		case VEHICLE_PARAMS_TOG: {

			if(!response) return 1;

			new vehicleid = GetPlayerVehicleID(playerid);

			switch(listitem) {
				case 0: {
					if(IsABike(vehicleid)) {
						callcmd::hm(playerid, "");
					}
					else callcmd::sb(playerid, ""); 
				}
				case 1: SetVehicleLights(vehicleid, playerid);// lights
				case 2: SetVehicleHood(vehicleid, playerid);// bonnet
				case 3: SetVehicleTrunk(vehicleid, playerid);// boot
			}	
		}
	}
	return 0;
}
