/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[CALLBACKS.PWN]--------------------------------


 * Copyright (c) 2016, GTA.Network, LLC
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

 //====================[Official SA:MP/Streamer Callbacks]============================

enum E_VENDING_MACHINE {
		      e_Model,
		      e_Interior,
		Float:e_PosX,
		Float:e_PosY,
		Float:e_PosZ,
		Float:e_RotX,
		Float:e_RotY,
		Float:e_RotZ,
		Float:e_FrontX,
		Float:e_FrontY
	};
static const Float:sc_VendingMachines[][E_VENDING_MACHINE] = {
	{955, 0, -862.82, 1536.60, 21.98, 0.00, 0.00, 180.00, -862.84, 1537.60},
	{956, 0, 2271.72, -76.46, 25.96, 0.00, 0.00, 0.00, 2271.72, -77.46},
	{955, 0, 1277.83, 372.51, 18.95, 0.00, 0.00, 64.00, 1278.73, 372.07},
	{956, 0, 662.42, -552.16, 15.71, 0.00, 0.00, 180.00, 662.41, -551.16},
	{955, 0, 201.01, -107.61, 0.89, 0.00, 0.00, 270.00, 200.01, -107.63},
	{955, 0, -253.74, 2597.95, 62.24, 0.00, 0.00, 90.00, -252.74, 2597.95},
	{956, 0, -253.74, 2599.75, 62.24, 0.00, 0.00, 90.00, -252.74, 2599.75},
	{956, 0, -76.03, 1227.99, 19.12, 0.00, 0.00, 90.00, -75.03, 1227.99},
	{955, 0, -14.70, 1175.35, 18.95, 0.00, 0.00, 180.00, -14.72, 1176.35},
	{1977, 7, 316.87, -140.35, 998.58, 0.00, 0.00, 270.00, 315.87, -140.36},
	{1775, 17, 373.82, -178.14, 1000.73, 0.00, 0.00, 0.00, 373.82, -179.14},
	{1776, 17, 379.03, -178.88, 1000.73, 0.00, 0.00, 270.00, 378.03, -178.90},
	{1775, 17, 495.96, -24.32, 1000.73, 0.00, 0.00, 180.00, 495.95, -23.32},
	{1776, 17, 500.56, -1.36, 1000.73, 0.00, 0.00, 0.00, 500.56, -2.36},
	{1775, 17, 501.82, -1.42, 1000.73, 0.00, 0.00, 0.00, 501.82, -2.42},
	{956, 0, -1455.11, 2591.66, 55.23, 0.00, 0.00, 180.00, -1455.13, 2592.66},
	{955, 0, 2352.17, -1357.15, 23.77, 0.00, 0.00, 90.00, 2353.17, -1357.15},
	{955, 0, 2325.97, -1645.13, 14.21, 0.00, 0.00, 0.00, 2325.97, -1646.13},
	{956, 0, 2139.51, -1161.48, 23.35, 0.00, 0.00, 87.00, 2140.51, -1161.53},
	{956, 0, 2153.23, -1016.14, 62.23, 0.00, 0.00, 127.00, 2154.03, -1015.54},
	{955, 0, 1928.73, -1772.44, 12.94, 0.00, 0.00, 90.00, 1929.73, -1772.44},
	{1776, 1, 2222.36, 1602.64, 1000.06, 0.00, 0.00, 90.00, 2223.36, 1602.64},
	{1775, 1, 2222.20, 1606.77, 1000.05, 0.00, 0.00, 90.00, 2223.20, 1606.77},
	{1775, 1, 2155.90, 1606.77, 1000.05, 0.00, 0.00, 90.00, 2156.90, 1606.77},
	{1775, 1, 2209.90, 1607.19, 1000.05, 0.00, 0.00, 270.00, 2208.90, 1607.17},
	{1776, 1, 2155.84, 1607.87, 1000.06, 0.00, 0.00, 90.00, 2156.84, 1607.87},
	{1776, 1, 2202.45, 1617.00, 1000.06, 0.00, 0.00, 180.00, 2202.43, 1618.00},
	{1776, 1, 2209.24, 1621.21, 1000.06, 0.00, 0.00, 0.00, 2209.24, 1620.21},
	{1776, 3, 330.67, 178.50, 1020.07, 0.00, 0.00, 0.00, 330.67, 177.50},
	{1776, 3, 331.92, 178.50, 1020.07, 0.00, 0.00, 0.00, 331.92, 177.50},
	{1776, 3, 350.90, 206.08, 1008.47, 0.00, 0.00, 90.00, 351.90, 206.08},
	{1776, 3, 361.56, 158.61, 1008.47, 0.00, 0.00, 180.00, 361.54, 159.61},
	{1776, 3, 371.59, 178.45, 1020.07, 0.00, 0.00, 0.00, 371.59, 177.45},
	{1776, 3, 374.89, 188.97, 1008.47, 0.00, 0.00, 0.00, 374.89, 187.97},
	{1775, 2, 2576.70, -1284.43, 1061.09, 0.00, 0.00, 270.00, 2575.70, -1284.44},
	{1775, 15, 2225.20, -1153.42, 1025.90, 0.00, 0.00, 270.00, 2224.20, -1153.43},
	{955, 0, 1154.72, -1460.89, 15.15, 0.00, 0.00, 270.00, 1153.72, -1460.90},
	{956, 0, 2480.85, -1959.27, 12.96, 0.00, 0.00, 180.00, 2480.84, -1958.27},
	{955, 0, 2060.11, -1897.64, 12.92, 0.00, 0.00, 0.00, 2060.11, -1898.64},
	{955, 0, 1729.78, -1943.04, 12.94, 0.00, 0.00, 0.00, 1729.78, -1944.04},
	{956, 0, 1634.10, -2237.53, 12.89, 0.00, 0.00, 0.00, 1634.10, -2238.53},
	{955, 0, 1789.21, -1369.26, 15.16, 0.00, 0.00, 270.00, 1788.21, -1369.28},
	{956, 0, -2229.18, 286.41, 34.70, 0.00, 0.00, 180.00, -2229.20, 287.41},
	{955, 256, -1980.78, 142.66, 27.07, 0.00, 0.00, 270.00, -1981.78, 142.64},
	{955, 256, -2118.96, -423.64, 34.72, 0.00, 0.00, 255.00, -2119.93, -423.40},
	{955, 256, -2118.61, -422.41, 34.72, 0.00, 0.00, 255.00, -2119.58, -422.17},
	{955, 256, -2097.27, -398.33, 34.72, 0.00, 0.00, 180.00, -2097.29, -397.33},
	{955, 256, -2092.08, -490.05, 34.72, 0.00, 0.00, 0.00, -2092.08, -491.05},
	{955, 256, -2063.27, -490.05, 34.72, 0.00, 0.00, 0.00, -2063.27, -491.05},
	{955, 256, -2005.64, -490.05, 34.72, 0.00, 0.00, 0.00, -2005.64, -491.05},
	{955, 256, -2034.46, -490.05, 34.72, 0.00, 0.00, 0.00, -2034.46, -491.05},
	{955, 256, -2068.56, -398.33, 34.72, 0.00, 0.00, 180.00, -2068.58, -397.33},
	{955, 256, -2039.85, -398.33, 34.72, 0.00, 0.00, 180.00, -2039.86, -397.33},
	{955, 256, -2011.14, -398.33, 34.72, 0.00, 0.00, 180.00, -2011.15, -397.33},
	{955, 2048, -1350.11, 492.28, 10.58, 0.00, 0.00, 90.00, -1349.11, 492.28},
	{956, 2048, -1350.11, 493.85, 10.58, 0.00, 0.00, 90.00, -1349.11, 493.85},
	{955, 0, 2319.99, 2532.85, 10.21, 0.00, 0.00, 0.00, 2319.99, 2531.85},
	{956, 0, 2845.72, 1295.04, 10.78, 0.00, 0.00, 0.00, 2845.72, 1294.04},
	{955, 0, 2503.14, 1243.69, 10.21, 0.00, 0.00, 180.00, 2503.12, 1244.69},
	{956, 0, 2647.69, 1129.66, 10.21, 0.00, 0.00, 0.00, 2647.69, 1128.66},
	{1209, 0, -2420.21, 984.57, 44.29, 0.00, 0.00, 90.00, -2419.21, 984.57},
	{1302, 0, -2420.17, 985.94, 44.29, 0.00, 0.00, 90.00, -2419.17, 985.94},
	{955, 0, 2085.77, 2071.35, 10.45, 0.00, 0.00, 90.00, 2086.77, 2071.35},
	{956, 0, 1398.84, 2222.60, 10.42, 0.00, 0.00, 180.00, 1398.82, 2223.60},
	{956, 0, 1659.46, 1722.85, 10.21, 0.00, 0.00, 0.00, 1659.46, 1721.85},
	{955, 0, 1520.14, 1055.26, 10.00, 0.00, 0.00, 270.00, 1519.14, 1055.24},
	{1775, 6, -19.03, -57.83, 1003.63, 0.00, 0.00, 180.00, -19.05, -56.83},
	{1775, 18, -16.11, -91.64, 1003.63, 0.00, 0.00, 180.00, -16.13, -90.64},
	{1775, 16, -15.10, -140.22, 1003.63, 0.00, 0.00, 180.00, -15.11, -139.22},
	{1775, 17, -32.44, -186.69, 1003.63, 0.00, 0.00, 180.00, -32.46, -185.69},
	{1775, 16, -35.72, -140.22, 1003.63, 0.00, 0.00, 180.00, -35.74, -139.22},
	{1776, 6, -36.14, -57.87, 1003.63, 0.00, 0.00, 180.00, -36.16, -56.87},
	{1776, 18, -17.54, -91.71, 1003.63, 0.00, 0.00, 180.00, -17.56, -90.71},
	{1776, 16, -16.53, -140.29, 1003.63, 0.00, 0.00, 180.00, -16.54, -139.29},
	{1776, 17, -33.87, -186.76, 1003.63, 0.00, 0.00, 180.00, -33.89, -185.76},
	{1775, 6, -19.03, -57.83, 1003.63, 0.00, 0.00, 180.00, -19.05, -56.83},
	{1776, 6, -36.14, -57.87, 1003.63, 0.00, 0.00, 180.00, -36.16, -56.87},
	{1775, 18, -16.11, -91.64, 1003.63, 0.00, 0.00, 180.00, -16.13, -90.64},
	{1776, 18, -17.54, -91.71, 1003.63, 0.00, 0.00, 180.00, -17.56, -90.71},
	{1776, 16, -16.53, -140.29, 1003.63, 0.00, 0.00, 180.00, -16.54, -139.29},
	{1775, 16, -15.10, -140.22, 1003.63, 0.00, 0.00, 180.00, -15.11, -139.22},
	{1776, 17, -33.87, -186.76, 1003.63, 0.00, 0.00, 180.00, -33.89, -185.76},
	{1775, 17, -32.44, -186.69, 1003.63, 0.00, 0.00, 180.00, -32.46, -185.69},
	{1775, 16, -35.72, -140.22, 1003.63, 0.00, 0.00, 180.00, -35.74, -139.22}
};


RemoveVendingMachines(playerid)
{
	// Remove 24/7 machines
	RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 20000.0); // CJ_EXT_SPRUNK
	RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 20000.0); // CJ_EXT_CANDY
	RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 20000.0); // vendmach
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 20000.0); // vendmachfd
	RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 20000.0); // CJ_SPRUNK1
	RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 20000.0); // CJ_CANDYVENDOR
	RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 20000.0); // vendin3

	// Make sure they're all gone..
	for (new i = 0; i < sizeof(sc_VendingMachines); i++) {
		RemoveBuildingForPlayer(
			playerid,
			sc_VendingMachines[i][e_Model],
			sc_VendingMachines[i][e_PosX],
			sc_VendingMachines[i][e_PosY],
			sc_VendingMachines[i][e_PosZ],
			1.0
		);
	}
	
	return 1;
}


public OnVehicleSpawn(vehicleid) {
	new Float:X, Float:Y, Float:Z;
	new Float:XB, Float:YB, Float:ZB;
	if(DynVeh[vehicleid] != -1)
	{
	    DynVeh_Spawn(DynVeh[vehicleid]);
	}
    TruckContents{vehicleid} = 0;
	Vehicle_ResetData(vehicleid);
	new
		v;


	foreach(new i: Player)
	{
		if((v = GetPlayerVehicle(i, vehicleid)) != -1) {
			DestroyVehicle(vehicleid);

			new
				iVehicleID = CreateVehicle(PlayerVehicleInfo[i][v][pvModelId], PlayerVehicleInfo[i][v][pvPosX], PlayerVehicleInfo[i][v][pvPosY], PlayerVehicleInfo[i][v][pvPosZ], PlayerVehicleInfo[i][v][pvPosAngle],PlayerVehicleInfo[i][v][pvColor1], PlayerVehicleInfo[i][v][pvColor2], -1);

			SetVehicleVirtualWorld(iVehicleID, PlayerVehicleInfo[i][v][pvVW]);
			LinkVehicleToInterior(iVehicleID, PlayerVehicleInfo[i][v][pvInt]);

			switch(GetVehicleModel(iVehicleID)) {
				case 519, 553, 508: {
					iVehEnterAreaID[iVehicleID] = CreateDynamicSphere(PlayerVehicleInfo[i][v][pvPosX]+3.5, PlayerVehicleInfo[i][v][pvPosY], PlayerVehicleInfo[i][v][pvPosZ], 4, GetVehicleVirtualWorld(iVehicleID));
					AttachDynamicAreaToVehicle(iVehEnterAreaID[iVehicleID], iVehicleID);
					Streamer_SetIntData(STREAMER_TYPE_AREA, iVehEnterAreaID[iVehicleID], E_STREAMER_EXTRA_ID, iVehicleID);
				}
			}

			PlayerVehicleInfo[i][v][pvId] = iVehicleID;

			Vehicle_ResetData(iVehicleID);
			if(!isnull(PlayerVehicleInfo[i][v][pvPlate])) {
				SetVehicleNumberPlate(iVehicleID, PlayerVehicleInfo[i][v][pvPlate]);
			}
			if(PlayerVehicleInfo[i][v][pvLocked] == 1) LockPlayerVehicle(i, iVehicleID, PlayerVehicleInfo[i][v][pvLock]);
			ChangeVehiclePaintjob(iVehicleID, PlayerVehicleInfo[i][v][pvPaintJob]);
			ChangeVehicleColor(iVehicleID, PlayerVehicleInfo[i][v][pvColor1], PlayerVehicleInfo[i][v][pvColor2]);
			for(new m = 0; m < MAX_MODS; m++)
			{
				if (PlayerVehicleInfo[i][v][pvMods][m] >= 1000 && PlayerVehicleInfo[i][v][pvMods][m] <= 1193)
				{
					if (InvalidModCheck(PlayerVehicleInfo[i][v][pvModelId], PlayerVehicleInfo[i][v][pvMods][m]))
					{
						AddVehicleComponent(iVehicleID, PlayerVehicleInfo[i][v][pvMods][m]);
					}
					else
					{
						PlayerVehicleInfo[i][v][pvMods][m] = 0;
					}
				}
			}
			new zyear, zmonth, zday;
			getdate(zyear, zmonth, zday);
			if(zombieevent || (zmonth == 10 && zday == 31) || (zmonth == 11 && zday == 1)) SetVehicleHealth(iVehicleID, PlayerVehicleInfo[i][v][pvHealth]);
			new string[128];
			format(string, sizeof(string), " %s da duoc dua den dia diem dau xe cua ban.", GetVehicleName(iVehicleID));
			SendClientMessageEx(i, COLOR_GRAD1, string);
		}
	}
	// Make sure no one is in the vehicle window if plane.
	foreach(new i: Player)
	{
		if(InsidePlane[i] == vehicleid)
		{
			TogglePlayerSpectating(i, 0);
			GetVehiclePos(InsidePlane[i], X, Y, Z);
			SetPlayerPos(i, X-4, Y-2.3, Z);
			GetVehiclePos(InsidePlane[i], XB, YB, ZB);
			if(ZB > 50.0)
			{
				PlayerInfo[i][pAGuns][GetWeaponSlot(46)] = 46;
				GivePlayerValidWeapon(i, 46);
			}
			PlayerInfo[i][pVW] = 0;
			SetPlayerVirtualWorld(i, 0);
			PlayerInfo[i][pInt] = 0;
			SetPlayerInterior(i, 0);
			InsidePlane[i] = INVALID_VEHICLE_ID;
			SendClientMessageEx(i, COLOR_WHITE, "May bay da bi hu , ban khong the di vao trong duoc!");
		}
	}
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
    for(new i = 0; i < sizeof(IsRim); i++)
	{
		if(IsRim[i] == componentid)
		{
		    if(!legalRims(playerid, componentid, vehicleid))
		    {
				if(HackingMods[playerid] < 3)
				{
					new szMessage[128];
					format(szMessage, sizeof(szMessage), "{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) may be hacking vehicle mods (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), playerid, partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
					ABroadCast(COLOR_YELLOW, szMessage, 2);
					format(szMessage, sizeof(szMessage), "%s(%d) may be hacking vehicle mods (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
					Log("logs/hack.log", szMessage);
					HackingMods[playerid]++;
					return 0;
				}
				else if(HackingMods[playerid] == 3)
				{
					CreateBan(INVALID_PLAYER_ID, PlayerInfo[playerid][pId], playerid, PlayerInfo[playerid][pIP], "Hacking Vehicle Mods", 180);
					HackingMods[playerid] = 0;
					Kick(playerid);
					TotalAutoBan++;
					return 0;
				}
		    }
		}
	}
	if(!(1 <= GetPlayerInterior(playerid) <= 3) && !GetPVarType(playerid, "unMod")) {
		new
			szMessage[128];

		if(HackingMods[playerid] < 3)
		{
			format(szMessage, sizeof(szMessage), "{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) may be hacking vehicle mods (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), playerid, partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
			ABroadCast(COLOR_YELLOW, szMessage, 2);
			format(szMessage, sizeof(szMessage), "%s(%d) may be hacking vehicle mods (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
			Log("logs/hack.log", szMessage);
			HackingMods[playerid]++;
			return 0;
		}
		else if(HackingMods[playerid] == 3)
		{
			CreateBan(INVALID_PLAYER_ID, PlayerInfo[playerid][pId], playerid, PlayerInfo[playerid][pIP], "Hacking Vehicle Mods", 180);
			HackingMods[playerid] = 0;
			Kick(playerid);
			TotalAutoBan++;
			return 0;
		}
	}
	if(GetPVarType(playerid, "unMod")) DeletePVar(playerid, "unMod");
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
    if(objectid != gFerrisWheel) return 0;

    defer RotateWheel();
    return 1;
}

public OnDynamicObjectMoved(objectid)
{
	new Float:x, Float:y, Float:z;
	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
		if(objectid == Obj_FloorDoors[i][0])
		{
		    GetDynamicObjectPos(Obj_FloorDoors[i][0], x, y, z);

		    if(x < X_DOOR_L_OPENED - 0.5)   // Some floor doors have shut, move the elevator to next floor in queue:
		    {
				Elevator_MoveToFloor(ElevatorQueue[0]);
				RemoveFirstQueueFloor();
			}
		}
	}

	if(objectid == Obj_Elevator)   // The elevator reached the specified floor.
	{
		if(ElevatorFloor != -1) {
			
			KillTimer(ElevatorBoostTimer);  // Kills the timer, in case the elevator reached the floor before boost.

			FloorRequestedBy[ElevatorFloor] = INVALID_PLAYER_ID;

			Elevator_OpenDoors();
			Floor_OpenDoors(ElevatorFloor);

			GetDynamicObjectPos(Obj_Elevator, x, y, z);
			Label_Elevator	= CreateDynamic3DTextLabel("Press '~k~~GROUP_CONTROL_BWD~' to use elevator", COLOR_YELLOW, 1784.9822, -1302.0426, z - 0.9, 4.0);

			ElevatorState 	= ELEVATOR_STATE_WAITING;
			SetTimer("Elevator_TurnToIdle", ELEVATOR_WAIT_TIME, 0);
		}
	}

	if (objectid == BikeParkourObjects[0]) // container
	{
		switch (BikeParkourObjectStage[0])
		{
			case 0:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2847.5302734, -2231.2675781, 99.0883789, 0.5, 0.0, 0.0, 179.7253418); // to end
				++BikeParkourObjectStage[0];
			}

			case 1:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2848.1015625, -2238.1552734, 99.0883789, 0.5, 0.0000000, 0.0000000, 90.0000000); // to middle
				BikeParkourObjectStage[0] = 2;
			}

			case 2:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2848.1015625, -2243.1552734, 99.0883789, 0.5, 0.0, 0.0, 90.0000000); // to beginning
				BikeParkourObjectStage[0] = 3;
			}

			case 3:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2848.1015625, -2238.1552734, 99.0883789, 0.5, 0.0, 0.0, 90.0000000); // to middle
				BikeParkourObjectStage[0] = 0;
			}
		}
	}
}

/*
public OnPlayerEnterDynArea(playerid, areaid)
{
	if(areaid == NGGShop)
	{
		SetPlayerArmedWeapon(playerid, 0);
	}
	foreach(new i: Player)
	{
		if(GetPVarType(i, "pBoomBoxArea"))
		{
			if(areaid == GetPVarInt(i, "pBoomBoxArea"))
			{
				new station[256];
				GetPVarString(i, "pBoomBoxStation", station, sizeof(station));
				if(!isnull(station))
				{
					PlayAudioStreamForPlayerEx(playerid, station, GetPVarFloat(i, "pBoomBoxX"), GetPVarFloat(i, "pBoomBoxY"), GetPVarFloat(i, "pBoomBoxZ"), 30.0, 1);
				}
				return 1;
			}
		}
	}
	if(areaid == audiourlid)
	{
	    PlayAudioStreamForPlayerEx(playerid, audiourlurl, audiourlparams[0], audiourlparams[1], audiourlparams[2], audiourlparams[3], 1);
	}
	return 1;
}

public OnPlayerLeaveDynArea(playerid, areaid)
{
	foreach(new i: Player)
	{
		if(GetPVarType(i, "pBoomBoxArea"))
		{
			if(areaid == GetPVarInt(i, "pBoomBoxArea"))
			{
				StopAudioStreamForPlayerEx(playerid);
				return 1;
			}
		}
	}
	if(areaid == audiourlid)
	{
		StopAudioStreamForPlayerEx(playerid);
	}
	if(areaid == NGGShop && GetPVarInt(playerid, "ShopTP") == 1)
	{
		if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0)
			return DeletePVar(playerid, "ShopTP");
		RemovePlayerFromVehicle(playerid);
		Player_StreamPrep(playerid, GetPVarFloat(playerid, "tmpX"), GetPVarFloat(playerid, "tmpY"), GetPVarFloat(playerid, "tmpZ"), 2500);
		SetPlayerInterior(playerid, GetPVarInt(playerid, "tmpInt"));
		SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "tmpVW"));
		DeletePVar(playerid, "tmpX");
		DeletePVar(playerid, "tmpY");
		DeletePVar(playerid, "tmpZ");
		DeletePVar(playerid, "tmpInt");
		DeletePVar(playerid, "tmpVW");
		DeletePVar(playerid, "ShopTP");
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Thanks for visiting our shop, come back soon!");
	}
	return 1;
}
*/

public OnPlayerUpdate(playerid)
{
	// Do not put heavy cpu checks in here. Use the 1 second timer.
	new Float:health = GetHealth(playerid, health);
	if(health <= 0)
	{
		OnPlayerDeath(playerid, INVALID_PLAYER_ID, 0);
	}
	if(playerTabbed[playerid] >= 1)
	{
		playerTabbed[playerid] = 0;
	}
	playerSeconds[playerid] = gettime();

	new pCurWeap = GetPlayerWeapon(playerid);
    if(pCurWeap != pCurrentWeapon{playerid}) {
        OnPlayerChangeWeapon(playerid, pCurWeap);
		pCurrentWeapon{playerid} = pCurWeap;
    }

    /*
    switch(pCurWeap) {
    	case 9, 16, 17, 18, 35, 36, 37, 38: {
    		if(PlayerInfo[playerid][pGuns][GetWeaponSlot(pCurWeap)] != pCurWeap) {

    			if(GetPVarType(playerid, "IsInArena") || GetPVarType(playerid, "EventToken")) return 1;

				GetWeaponName(pCurWeap, szMiscArray, sizeof(szMiscArray));
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s da duoc cho themself a client-sided weapon (%s). It was removed from the player.", GetPlayerNameEx(playerid), szMiscArray);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: Client weapon detected. Admins were notified: refrain from doing it again.");
				SetPlayerWeaponsEx(playerid);
			}
    	}
    }*/

    new drunknew = GetPlayerDrunkLevel(playerid);
    if(drunknew < 100) { // go back up, keep cycling.
        SetPlayerDrunkLevel(playerid, 2000);
    }
    else {

        if(pDrunkLevelLast[playerid] != drunknew) {

            new wfps = pDrunkLevelLast[playerid] - drunknew;

            if ((wfps > 0) && (wfps < 200))
                pFPS[playerid] = wfps;

            pDrunkLevelLast[playerid] = drunknew;
        }
    }

	if(inSafeZone{playerid} && GetPlayerWeapon(playerid) != 0 && GetPlayerWeapon(playerid) != -1 && pTazer{playerid} != 1) {
		SetPlayerArmedWeapon(playerid, 0);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
		if(GetPlayerWeapon(playerid) != 28 && GetPlayerWeapon(playerid) != 29)
		{
			SetPlayerArmedWeapon(playerid, 0);
		}
	}
    if(acstruct[playerid][checkmaptp] == 1 && PlayerInfo[playerid][pAdmin] < 2) //blah
	{
	    new Float:dis = GetPlayerDistanceFromPoint(playerid, acstruct[playerid][maptp][0], acstruct[playerid][maptp][1], acstruct[playerid][maptp][2]);
	    if(dis < 5.0)
	    {
			new Float:disd = GetPlayerDistanceFromPoint(playerid, acstruct[playerid][LastOnFootPosition][0], acstruct[playerid][LastOnFootPosition][1], acstruct[playerid][LastOnFootPosition][2]);
			if(disd > 25.0)
			{
		        new srelay[256], Float:X, Float:Y, Float:Z;
		        GetPlayerPos(playerid, X, Y, Z);
				format(srelay, sizeof(srelay), "[mapteleport] %s(%d) (%0.2f, %0.2f, %0.2f -> %0.2f, %0.2f, %0.2f [%0.2f, %0.2f, %0.2f]) (%f, %f)", GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), \
				acstruct[playerid][LastOnFootPosition][0], acstruct[playerid][LastOnFootPosition][1], acstruct[playerid][LastOnFootPosition][2], \
				X, Y, Z, acstruct[playerid][maptp][0], acstruct[playerid][maptp][1], acstruct[playerid][maptp][2], disd, dis);
				format(srelay, sizeof(srelay), "%s  (%d) (%d)", srelay, GetPlayerState(playerid), (GetTickCount()-acstruct[playerid][maptplastclick]));
				Log("logs/hack.log", srelay);

	            CreateBan(INVALID_PLAYER_ID, PlayerInfo[playerid][pId], playerid, PlayerInfo[playerid][pIP], "TP Hacking", 180);
				TotalAutoBan++;
			}
		}
	    acstruct[playerid][checkmaptp] = 0;
	}
	GetPlayerPos(playerid, acstruct[playerid][LastOnFootPosition][0], acstruct[playerid][LastOnFootPosition][1], acstruct[playerid][LastOnFootPosition][2]);

	new newkeys,
		updown,
		leftright;

    GetPlayerKeys(playerid, newkeys, updown, leftright); // playervar for phone.

	// night vision and thermal goggle fixes added by Dom
	if(GetPlayerWeapon(playerid) == 44 || GetPlayerWeapon(playerid) == 45) {

		if((newkeys & KEY_FIRE) && (!IsPlayerInAnyVehicle(playerid))) return 0;
	}
	if(updown == KEY_UP) {

		if(Bit_State(arrPlayerBits[playerid], phone_bitState)) {
			new iPMenuItem = GetPVarInt(playerid, "PMenuItem");
			if(iPMenuItem != 0) {
				SetPVarInt(playerid, "PMenuItem", iPMenuItem-1);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem-1], 0x22222266);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem], 0xFFFFFF00);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem-1]);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem-1]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
			}
		}
	}
	if(updown == KEY_DOWN) {

		if(Bit_State(arrPlayerBits[playerid], phone_bitState)) {
			new iPMenuItem = GetPVarInt(playerid, "PMenuItem");
			if(iPMenuItem < 9) { // max menu item
				SetPVarInt(playerid, "PMenuItem", GetPVarInt(playerid, "PMenuItem")+1);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem+1], 0x22222266);
				PlayerTextDrawBoxColor(playerid, phone_PTextDraw[playerid][12 + iPMenuItem], 0xFFFFFF00);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem+1]);
				PlayerTextDrawHide(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem+1]);
				PlayerTextDrawShow(playerid, phone_PTextDraw[playerid][12 + iPMenuItem]);
			}
		}
	}
	return 1;
}


public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid,
                                   Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,
                                   Float:fRotX, Float:fRotY, Float:fRotZ,
                                   Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
	    if(fOffsetX > 1.4)
		{
			fOffsetX = 1.4;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum X Offset exeeded, damped to maximum");
		}
	    if(fOffsetY > 1.4) {
			fOffsetY = 1.4;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum Y Offset exeeded, damped to maximum");
		}
	    if(fOffsetZ > 1.4) {
			fOffsetZ = 1.4;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum Z Offset exeeded, damped to maximum");
		}
	    if(fOffsetX < -1.4) {
			fOffsetX = -1.4;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum X Offset exeeded, damped to maximum");
		}
	    if(fOffsetY < -1.4) {
			fOffsetY = -1.4;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum Y Offset exeeded, damped to maximum");
		}
	    if(fOffsetZ < -1.4) {
			fOffsetZ = -1.4;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum Z Offset exeeded, damped to maximum");
		}
	    if(fScaleX > 1.5) {
			fScaleX = 1.5;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum X Scale exeeded, damped to maximum");
		}
	    if(fScaleY > 1.5) {
			fScaleY = 1.5;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum Y Scale exeeded, damped to maximum");
		}
		if(fScaleZ > 1.5) {
			fScaleZ = 1.5;
			SendClientMessage(playerid, COLOR_WHITE, "Maximum Z Scale exeeded, damped to maximum");
		}
		if(GetPVarType(playerid, "EditGToy")) {

			PlayerInfo[playerid][pGroupToy][0] = fOffsetX;
			PlayerInfo[playerid][pGroupToy][1] = fOffsetY;
			PlayerInfo[playerid][pGroupToy][2] = fOffsetZ;
			PlayerInfo[playerid][pGroupToy][3] = fRotX;
			PlayerInfo[playerid][pGroupToy][4] = fRotY;
			PlayerInfo[playerid][pGroupToy][5] = fRotZ;
			PlayerInfo[playerid][pGroupToy][6] = fScaleX;
			PlayerInfo[playerid][pGroupToy][7] = fScaleY;
			PlayerInfo[playerid][pGroupToy][8] = fScaleZ;
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerAttachedObject(playerid, 9, arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupToyID], PlayerInfo[playerid][pGroupToyBone],
				PlayerInfo[playerid][pGroupToy][0], PlayerInfo[playerid][pGroupToy][1], PlayerInfo[playerid][pGroupToy][2],
				PlayerInfo[playerid][pGroupToy][3], PlayerInfo[playerid][pGroupToy][4], PlayerInfo[playerid][pGroupToy][5],
				PlayerInfo[playerid][pGroupToy][6], PlayerInfo[playerid][pGroupToy][7], PlayerInfo[playerid][pGroupToy][8]);

			DeletePVar(playerid, "EditGToy");
			g_mysql_SaveGroupToy(playerid);
			SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da chinh sua nhom do choi cua ban.");
		}
		else {
		    new slotid = GetPVarInt(playerid, "ToySlot");
			PlayerToyInfo[playerid][slotid][ptPosX] = fOffsetX;
			PlayerToyInfo[playerid][slotid][ptPosY] = fOffsetY;
			PlayerToyInfo[playerid][slotid][ptPosZ] = fOffsetZ;
			PlayerToyInfo[playerid][slotid][ptRotX] = fRotX;
			PlayerToyInfo[playerid][slotid][ptRotY] = fRotY;
			PlayerToyInfo[playerid][slotid][ptRotZ] = fRotZ;
			PlayerToyInfo[playerid][slotid][ptScaleX] = fScaleX;
			PlayerToyInfo[playerid][slotid][ptScaleY] = fScaleY;
			PlayerToyInfo[playerid][slotid][ptScaleZ] = fScaleZ;

		    g_mysql_SaveToys(playerid,slotid);
			ShowEditMenu(playerid);
		}
	}
	else
	{
		if(GetPVarType(playerid, "EditGToy")) {
			DeletePVar(playerid, "EditGToy");
			SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da ngung chinh sua nhom do choi cua ban.");
		}
		else {
		    ShowEditMenu(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da tat chinh sua do choi.");
		}
	}
	return 1;
}

public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
	if(gPlayerLogged{playerid} && GetPVarInt(playerid, "EventToken") == 0)
	{
		PlayerInfo[playerid][pInt] = newinteriorid;
		if(newinteriorid != 0)
		{
			SetPlayerWeather(playerid, 0);
		}
		else
		{
			SetPlayerWeather(playerid, gWeather);
		}
	}
	foreach(new i: Player)
	{
		if(Spectating[i] > 0 && Spectate[i] == playerid) {
			SetTimerEx("SpecUpdate", 1500, false, "i", i);
		}
	}
}

public OnPlayerPressButton(playerid, buttonid)
{
	// New SASD interior.
	if(buttonid == SASDButtons[0] || buttonid == SASDButtons[3])
	{
		if(IsACop(playerid))
		{
			MoveDynamicObject(SASDDoors[0], 14.92530, 53.51950, 996.84857, 4, 0.00000, 0.00000, 180.00000);
			SetTimer("CloseSASDNew1", 2500, 0);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY," Access denied.");
			return 1;
		}
	}

	if(buttonid == SASDButtons[2] || buttonid == SASDButtons[1])
	{
		if(IsACop(playerid))
		{
			MoveDynamicObject(SASDDoors[1], 8.70370, 57.32530, 991.03699, 4, 0.00000, 0.00000, 0.00000);
			SetTimer("CloseSASDNew2", 2500, 0);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY," Access denied.");
			return 1;
		}
	}


	if(buttonid == sasdbtn1)
	{
	    if(IsACop(playerid) && PlayerInfo[playerid][pRank] >= 5)
	    {
	        MoveDynamicObject(sasd1A,2510.65332031,-1697.00976562,561.79223633,4);
	 		MoveDynamicObject(sasd1B,2515.67211914,-1696.97485352,561.79223633,4);
			SetTimer("CloseSASD1", 2500, 0);
	    }
	    else
	    {
	        SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
	}
	if(buttonid == sasdbtn2)
	{
	    if(IsACop(playerid) && PlayerInfo[playerid][pRank] >= 3)
	    {
	        MoveDynamicObject(sasd5A,2523.86059570,-1660.07177734,561.80206299,4);
	 		MoveDynamicObject(sasd5B,2518.84228516,-1660.10888672,561.80004883,4);
	 		//2522.86059570,-1660.07177734,561.80206299
			//2519.84228516,-1660.10888672,561.80004883
			SetTimer("CloseSASD5", 2500, 0);
	    }
	    else
	    {
	        SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
	}
	if(buttonid == sasdbtn3)
	{
	    if(IsACop(playerid) && PlayerInfo[playerid][pRank] >= 5)
	    {
	        MoveDynamicObject(sasd3A,2521.15600586,-1697.01550293,561.79223633,4);
	 		MoveDynamicObject(sasd3B,2526.15893555,-1696.98010254,561.79223633,4);
			SetTimer("CloseSASD3", 2500, 0);
	    }
	    else
	    {
	        SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
	}
	if(buttonid == sasdbtn4)
	{
		if(IsACop(playerid) && PlayerInfo[playerid][pRank] >= 5)
	    {
            MoveDynamicObject(sasd2A,2515.87548828,-1697.01525879,561.79223633,4);
	 		MoveDynamicObject(sasd2B,2520.89257812,-1696.97509766,561.79223633,4);
			SetTimer("CloseSASD2", 2500, 0);
	    }
	    else
	    {
	        SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
	}
	if(buttonid == sasdbtn5)
	{
		if(IsACop(playerid) && PlayerInfo[playerid][pRank] >= 3)
	    {
	        MoveDynamicObject(sasd4A,2510.84130859,-1660.08081055,561.79528809,4);
	 		MoveDynamicObject(sasd4B,2515.81982422,-1660.04650879,561.80004883,4);
			SetTimer("CloseSASD4", 2500, 0);
	    }
	    else
	    {
	        SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
	}
	if(buttonid == westout)
	{
		if(!IsACop(playerid))
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
		MoveDynamicObject(westlobby1,239.71582031,115.09179688,1002.21502686,4);
		MoveDynamicObject(westlobby2,239.67968750,120.09960938,1002.21502686,4);
		SetTimer("CloseWestLobby", 2500, 0);
	}
	if(buttonid == eastout)
	{
		if(!IsACop(playerid))
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
 		MoveDynamicObject(eastlobby1,253.14941406,111.59960938,1002.21502686,4);
 		MoveDynamicObject(eastlobby2,253.18457031,106.59960938,1002.21502686,4);
		SetTimer("CloseEastLobby", 2500, 0);
	}
	if(buttonid == lockerin || buttonid == lockerout)
	{
		if(!IsACop(playerid))
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
		MoveDynamicObject(locker1,268.29980469,112.56640625,1003.61718750,4);
		MoveDynamicObject(locker2,263.29980469,112.52929688,1003.61718750,4);
		SetTimer("CloseLocker", 2500, 0);
	}
	if(buttonid == cctvin || buttonid == cctvout)
	{
		if(!IsACop(playerid))
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
		MoveDynamicObject(cctv1,263.44921875,115.79980469,1003.61718750,4);
		MoveDynamicObject(cctv2,268.46875000,115.83691406,1003.61718750,4);
		SetTimer("CloseCCTV", 2500, 0);
	}
	if(buttonid == chiefin || buttonid == chiefout)
	{
		if(!IsACop(playerid) || PlayerInfo[playerid][pRank] < 6)
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
		MoveDynamicObject(chief1,228.0,119.50000000,1009.21875000,4);
		MoveDynamicObject(chief2,230.0,119.53515625,1009.21875000,4);
	    SetTimer("CloseChief", 2500, 0);
	}
	if(buttonid == elevator)
	{
		if(!IsACop(playerid))
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
		//else ShowPlayerDialogEx( playerid, ELEVATOR3, DIALOG_STYLE_LIST, "Elevator", "Rooftop\nGarage", "Select", "Cancel");
		else SendClientMessageEx(playerid, COLOR_GRAD1, "This elevator is out of service.");
	}
	if(buttonid == garagekey)
	{
		if(!IsACop(playerid))
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
		//else ShowPlayerDialogEx( playerid, ELEVATOR2, DIALOG_STYLE_LIST, "Elevator", "Rooftop\nInterior", "Select", "Cancel");
		else SendClientMessageEx(playerid, COLOR_GRAD1, "This elevator is out of service.");
	}
	if(buttonid == roofkey)
	{
		if(!IsACop(playerid))
		{
			SendClientMessageEx(playerid,COLOR_GREY,"Access denied.");
			return 1;
		}
		//else ShowPlayerDialogEx( playerid, ELEVATOR, DIALOG_STYLE_LIST, "Elevator", "Interior\nGarage", "Select", "Cancel");
		else SendClientMessageEx(playerid, COLOR_GRAD1, "This elevator is out of service.");
	}
	if(buttonid == westin)
	{
		MoveDynamicObject(westlobby1,239.71582031,115.09179688,1002.21502686,4);
		MoveDynamicObject(westlobby2,239.67968750,120.09960938,1002.21502686,4);
		SetTimer("CloseWestLobby", 2500, 0);
	}
	if(buttonid == eastin)
	{
	    MoveDynamicObject(eastlobby1,253.14941406,111.59960938,1002.21502686,4);
	    MoveDynamicObject(eastlobby2,253.18457031,106.59960938,1002.21502686,4);
		SetTimer("CloseEastLobby", 2500, 0);
	}
	for(new i = 0; i < sizeof(DocButton); i++) {
		if (buttonid == DocButton[i]) {
			if(IsACop(playerid)) {
				OpenDocAreaDoors(i, 1);
				SetTimerEx("OpenDocAreaDoors", 5000, false, "ii", i, 0);

			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "Access denied");
				break;
			}
		}
	}
	if(buttonid == DocCPButton[0] || buttonid == DocCPButton[1])
	{
		if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Tu choi truy cap");
		ShowDocPrisonControls(playerid, 0);
	}
	if(buttonid == SFPDHighCMDButton[0]) // Chief
	{
		if(PlayerInfo[playerid][pLeader] != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Tu choi truy cap");
		SFPDDoors(0, 1);
		SetTimerEx("SFPDDoors", 3000, false, "ii", 0, 0);
	}
	if(buttonid == SFPDHighCMDButton[1]) // Deputy Chief
	{
		if(PlayerInfo[playerid][pLeader] != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Tu choi truy cap");
		SFPDDoors(1, 1);
		SetTimerEx("SFPDDoors", 3000, false, "ii", 1, 0);
	}
	if(buttonid == SFPDHighCMDButton[2]) // Commander
	{
		if(PlayerInfo[playerid][pLeader] != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Tu choi truy cap");
		SFPDDoors(2, 1);
		SetTimerEx("SFPDDoors", 3000, false, "ii", 2, 0);
	}
	if(buttonid == SFPDLobbyButton[0])
	{
		if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Tu choi truy cap");
		SFPDDoors(3, 1);
		SetTimerEx("SFPDDoors", 3000, false, "ii", 3, 0);
	}
	if(buttonid == SFPDLobbyButton[1])
	{
		if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Tu choi truy cap");
		SFPDDoors(4, 1);
		SetTimerEx("SFPDDoors", 3000, false, "ii", 4, 0);
	}
	return false;
}

public OnEnterExitModShop( playerid, enterexit, interiorid ) {
	
	SetPVarInt(playerid, "AntiTPCheck", gettime()+5);
	if(!enterexit && GetPlayerVehicle(playerid, GetPlayerVehicleID(playerid)) > -1) UpdatePlayerVehicleMods(playerid, GetPlayerVehicle(playerid, GetPlayerVehicleID(playerid)));
	if(!enterexit && DynVeh[GetPlayerVehicleID(playerid)] != -1) UpdateGroupVehicleMods(GetPlayerVehicleID(playerid));
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    if(GetPlayerVehicle(playerid, vehicleid) > -1)
	{
		PlayerVehicleInfo[playerid][GetPlayerVehicle(playerid, vehicleid)][pvPaintJob] = paintjobid;
	}
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    if(GetPlayerVehicle(playerid, vehicleid) > -1)
	{
		PlayerVehicleInfo[playerid][GetPlayerVehicle(playerid, vehicleid)][pvColor1] = color1;
		PlayerVehicleInfo[playerid][GetPlayerVehicle(playerid, vehicleid)][pvColor2] = color2;
	}
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	new tableid = GetPVarInt(playerid, "pkrTableID")-1;
	if(playertextid == PlayerPokerUI[playerid][38])
	{
		switch(GetPVarInt(playerid, "pkrActionOptions"))
 		{
			case 1: // Raise
			{
				PokerRaiseHand(playerid);
				PokerTable[tableid][pkrRotations] = 0;
			}
			case 2: // Call
			{
				PokerCallHand(playerid);
			}
			case 3: // Check
			{
				PokerCheckHand(playerid);
				PokerRotateActivePlayer(tableid);
			}
 		}
	}
	if(playertextid == PlayerPokerUI[playerid][39])
	{
		switch(GetPVarInt(playerid, "pkrActionOptions"))
		{
			case 1: // Check
			{
				PokerCheckHand(playerid);
				PokerRotateActivePlayer(tableid);
			}
			case 2: // Raise
			{
				PokerRaiseHand(playerid);
				PokerTable[tableid][pkrRotations] = 0;
			}
			case 3: // Fold
			{
				PokerFoldHand(playerid);
				PokerRotateActivePlayer(tableid);
			}
		}
	}
	if(playertextid == PlayerPokerUI[playerid][40])
	{
		switch(GetPVarInt(playerid, "pkrActionOptions"))
		{
			case 1: // Fold
			{
				PokerFoldHand(playerid);
				PokerRotateActivePlayer(tableid);
			}
			case 2: // Fold
			{
				PokerFoldHand(playerid);
				PokerRotateActivePlayer(tableid);
			}
		}
	}
	if(playertextid == PlayerPokerUI[playerid][41]) // LEAVE
	{
		if(GetPVarType(playerid, "pkrTableID")) {
			LeavePokerTable(playerid);
		}
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	/*if(!response)
	{
 		if(listid == CarList)
	    {
	        print("[ListReloaded]");
	        ToyList = LoadModelSelectionMenu("ToyList.txt");
			CarList = LoadModelSelectionMenu("CarList.txt");
			PlaneList = LoadModelSelectionMenu("PlaneList.txt");
			BoatList = LoadModelSelectionMenu("BoatList.txt");
			SkinList = LoadModelSelectionMenu("SkinList.txt");
	    }
	} */
	if(listid == ToyList2 || listid == ToyList)
	{
	    if(response)
	    {
	        if(modelid == 18647)
	        {
				ShowPlayerDialogEx(playerid, DIALOG_SHOPNEON, DIALOG_STYLE_LIST, "Neon Tubes", "Red Neon Tube\nBlue Neon Tube\nGreen Neon Tube\nYellow Neon Tube\nPink Neon Tube\nWhite Neon Tube", "Select", "Cancel");
	        }
	        else
	        {
				szMiscArray[0] = 0;
				for(new z;z<MAX_PLAYERTOYS;z++)
				{
					new name[24];
   					format(name, sizeof(name), "None");

					for(new i;i<sizeof(HoldingObjectsAll);i++)
					{
						if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][z][ptModelID])
						{
							format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
						}
					}

					format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s (Bone: %s)\n", szMiscArray, z, name, HoldingBones[PlayerToyInfo[playerid][z][ptBone]]);
				}
				printf("MODELID: %d", modelid);
				ShowPlayerDialogEx(playerid, DIALOG_SHOPBUYTOYS, DIALOG_STYLE_LIST, "Select a Slot", szMiscArray, "Select", "Cancel");
	  			SetPVarInt(playerid, "ToyID", modelid);
			}
	    }
	    else SendClientMessage(playerid, COLOR_GREY, "Ban da dong cua hang do choi .");
    	return 1;
	}
	if(listid == BoatList)
	{
		if(response)
		{
			new string[128];
			SetPVarInt(playerid, "VehicleID", modelid), SetPVarInt(playerid, "BoatShop", 1);
			format(string, sizeof(string), "Item: %s\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", VehicleName[modelid-400], number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[5][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[5][sItemPrice]));
			ShowPlayerDialogEx(playerid, DIALOG_CARSHOP, DIALOG_STYLE_MSGBOX, "Vehicle Shop", string, "Purchase", "Cancel");
		}
	}
	if(listid == PlaneList)
	{
		if(response)
		{
			new string[128];
			SetPVarInt(playerid, "VehicleID", modelid);
			format(string, sizeof(string), "Item: %s\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", VehicleName[modelid-400], number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[5][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[5][sItemPrice]));
			ShowPlayerDialogEx(playerid, DIALOG_CARSHOP, DIALOG_STYLE_MSGBOX, "Vehicle Shop", string, "Purchase", "Cancel");
		}
	}
	if(listid == CarList2 || listid == CarList)
	{
	    if(response)
	    {
			if(GetPVarInt(playerid, "PlayerCuffed") != 0) // Check to see if you're tazed or cuffed
			{
				DeletePVar(playerid, "voucherdialog");
				DeletePVar(playerid, "WhoIsThis");
				return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay khi dang bi cong tay hoac tazed.");
			}
			if(IsPlayerInAnyVehicle(playerid))
			{
				DeletePVar(playerid, "voucherdialog");
				DeletePVar(playerid, "WhoIsThis");
				return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay khi dang o trong xe.");
			}
			if(GetPVarInt(playerid, "voucherdialog") == 0)
			{
				if(!GetPVarType(playerid, "RentaCar"))
				{
					new string[128];
					SetPVarInt(playerid, "VehicleID", modelid);
					format(string, sizeof(string), "Item: %s\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", VehicleName[modelid-400], number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[5][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[5][sItemPrice]));
					ShowPlayerDialogEx(playerid, DIALOG_CARSHOP, DIALOG_STYLE_MSGBOX, "Vehicle Shop", string, "Purchase", "Cancel");
				}
				else
				{
					new string[128];
					SetPVarInt(playerid, "VehicleID", modelid);
					format(string, sizeof(string), "Item: %s\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", VehicleName[modelid-400], number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[20][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[20][sItemPrice]));
					ShowPlayerDialogEx(playerid, DIALOG_RENTACAR, DIALOG_STYLE_MSGBOX, "Rent a Car", string, "Purchase", "Cancel");
				}
			}
			else if(GetPVarInt(playerid, "voucherdialog") == 1)
			{
				if(!vehicleCountCheck(playerid)) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the so huu them xe - Ban co the mua them cac slot xe tu /vstorage.");
				if(!vehicleSpawnCountCheck(playerid)) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban co qua nhieu xe dem ra ngoai, vui long cat bot 1 chiec.");
				if(PlayerInfo[playerid][pVehVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co car voucher.");
				new Float: arr_fPlayerPos[4], szLog[128], szString[128];
				GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
				GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
				CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), modelid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, 0, 0);
				SetPlayerVirtualWorld(playerid, 0);

				PlayerInfo[playerid][pVehVoucher]--;
				format(szString, sizeof(szString), "Ban da su dung mot trong nhung car voucher(s), ban con %d car voucher(s) .", PlayerInfo[playerid][pVehVoucher]);
				SendClientMessageEx(playerid, COLOR_CYAN, szString);
				format(szLog, sizeof(szLog), "%s(%d) da su dung car voucher(s) va con %d .", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pVehVoucher]);
				Log("logs/vouchers.log", szLog);
				DeletePVar(playerid, "voucherdialog");
				DeletePVar(playerid, "WhoIsThis");
				DeletePVar(playerid, "ShopTP");
			}
		}
		DeletePVar(playerid, "voucherdialog");
		DeletePVar(playerid, "WhoIsThis");
		DeletePVar(playerid, "RentaCar");
	}
	if(listid == CarList3)
	{
	    if(response)
	    {
	        new string[128];
       		SetPVarInt(playerid, "VehicleID", modelid);
       		format(string, sizeof(string), "Item: %s\nCost: 1 Restricted Car Voucher", VehicleName[modelid-400]);
   			ShowPlayerDialogEx(playerid, DIALOG_CARSHOP2, DIALOG_STYLE_MSGBOX, "Restricted Vehicle Shop", string, "Purchase", "Cancel");
	    }
	}
	if(listid == SkinList)
	{
		if(response)
		{
			ClearAnimationsEx(playerid);
			if(PlayerInfo[playerid][pDonateRank] >= 2)
			{
				if (PlayerInfo[playerid][pModel] == modelid)
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban da mac nhung bo quan ao nay.");

				PlayerInfo[playerid][pModel] = modelid;
				SetPlayerSkin(playerid, modelid);
				return SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: Ban da thay quan ao mien phi.");
			}
			if(IsValidSkin(modelid) == 0)
			{
				if(PlayerInfo[playerid][mInventory][13])
				{
					if(PlayerInfo[playerid][pModel] == modelid) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da mac nhung bo quan ao nay.");
					PlayerInfo[playerid][mInventory][13]--;
					PlayerInfo[playerid][pModel] = modelid;
					SetPlayerSkin(playerid, modelid);
					return SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da su dung Restricted Skin token de thay doi quan ao.");
				}
				if(GetPVarInt(playerid, "freeSkin") == 1)
			    {
					SendClientMessageEx(playerid, COLOR_GREY, "Trang phuc nay bi gioi han vi cua mot to chuc!");
	            	ShowModelSelectionMenu(playerid, SkinList, "Thay doi skin cua ban .");
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Trang phuc nay bi gioi han vi cua mot to chuc!");
	            	ShowModelSelectionMenu(playerid, SkinList, "Thay doi Skin.");
				}
			}
			else {
				if (PlayerInfo[playerid][pModel] == modelid)
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban da mac nhung bo quan ao nay.");
				}
			    if(GetPVarInt(playerid, "freeSkin") == 1)
			    {
					PlayerInfo[playerid][pModel] = modelid;
					SetPlayerSkin(playerid, modelid);
					SetPVarInt(playerid, "freeSkin", 0);
			    }
			    else
			    {
			        new
						string[128],
						iBusiness = InBusiness(playerid);

					if(iBusiness == INVALID_BUSINESS_ID || Businesses[iBusiness][bType] != BUSINESS_TYPE_CLOTHING) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trong cua hang quan ao!");
			        if(GetPlayerCash(playerid) < GetPVarInt(playerid, "SkinChangeCost")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the mua nhung bo quan ao nay!");
					GameTextForPlayer(playerid, "~g~Clothes purchased!", 2000, 1);
					PlayerInfo[playerid][pModel] = modelid;
					SetPlayerSkin(playerid, modelid);

					Businesses[iBusiness][bInventory]--;
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(GetPVarInt(playerid, "SkinChangeCost"));
                    GivePlayerCash(playerid, -GetPVarInt(playerid, "SkinChangeCost"));

					format(string, sizeof(string), "%s(%d) (IP: %s) has bought skin %d in %s (%d) for %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), modelid, Businesses[InBusiness(playerid)][bName],InBusiness(playerid),GetPVarInt(playerid, "SkinChangeCost"));
					Log("logs/business.log", string);
					DeletePVar(playerid, "SkinChangeCost");
				}
			}
		}
	}
	/*
	for(new i; i < sizeof(FurnitureList); ++i) {

		if(listid == FurnitureList[i]) {

			if(response) {
				SetPVarInt(playerid, PVAR_FURNITURE_BUYMODEL, modelid);
				format(szMiscArray, sizeof(szMiscArray), "Ban co muon mua %s cho $%s va %s materials?", GetFurnitureName(modelid), number_format(GetFurniturePrice(modelid)), number_format(GetFurniturePrice(modelid) / 10));
				ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_BUYCONFIRM, DIALOG_STYLE_MSGBOX, "Furniture Menu | Confirm Purchase", szMiscArray, "Buy", "Cancel");
			}
			else {
				FurnitureMenu(playerid, 0);
			}
			break;
		}
	}
	*/
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	acstruct[playerid][checkmaptp] = 1; acstruct[playerid][maptplastclick] = GetTickCount();
	acstruct[playerid][maptp][0] = fX; acstruct[playerid][maptp][1] = fY; acstruct[playerid][maptp][2] = fZ;
	return 1;
}


public OnPlayerStreamIn(playerid, forplayerid)
{
    switch(Backup[playerid]) {
		case 1: {
	        if(PlayerInfo[playerid][pMember] == PlayerInfo[forplayerid][pMember])
	        {
	            new string[128];
	            if(GetPVarInt(playerid, "InRangeBackup") < 1)
	            {
		            SetPVarInt(playerid, "InRangeBackup", 30);
		            format(string, sizeof(string), "Ban dang trong pham vi %s's backup call (Code 3) (Blue marker on minimap)", GetPlayerNameEx(playerid));
		            SendClientMessageEx(forplayerid, DEPTRADIO, string);
				}
	  			SetPlayerMarkerForPlayer(forplayerid, playerid, 0x2641FEAA);
			}
		}
		case 2: {
  			if(PlayerInfo[playerid][pMember] == PlayerInfo[forplayerid][pMember])
	        {
	            new string[128];
	            if(GetPVarInt(playerid, "InRangeBackup") < 1)
	            {
		            SetPVarInt(playerid, "InRangeBackup", 30);
		            format(string, sizeof(string), "Ban dang trong pham vi %s's backup call (Code 2) (Green marker on minimap)", GetPlayerNameEx(playerid));
		            SendClientMessageEx(forplayerid, DEPTRADIO, string);
				}
	  			SetPlayerMarkerForPlayer(forplayerid, playerid, 0x00FF33AA);
			}
		}
		case 3: {
  			if(IsACop(forplayerid))
	        {
	            new string[128];
	            if(GetPVarInt(playerid, "InRangeBackup") < 1)
	            {
		            SetPVarInt(playerid, "InRangeBackup", 30);
		            format(string, sizeof(string), "Ban dang trong pham vi %s's backup call (Code 3) (Blue marker on minimap)", GetPlayerNameEx(playerid));
		            SendClientMessageEx(forplayerid, DEPTRADIO, string);
				}
	  			SetPlayerMarkerForPlayer(forplayerid, playerid, 0x2641FEAA);
			}
		}
	}
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
    if(Backup[playerid] > 0) {
        if(IsACop(forplayerid))
        {
  			SetPlayerToTeamColor(playerid);
		}
	}
    return 1;
}

public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;

	g_arrQueryHandle{playerid} = random(256);

	TotalConnect++;
	if(Iter_Count(Player) > MaxPlayersConnected) {
		MaxPlayersConnected = Iter_Count(Player);
		getdate(MPYear,MPMonth,MPDay);
	}

	RemoveVendingMachines(playerid);

	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);

	gPlayerUsingLoopingAnim[playerid] = 0;
	gPlayerAnimLibsPreloaded[playerid] = 0;
	SetPVarInt(playerid, "AOSlotPaintballFlag", -1);
	DeletePVar(playerid, "TempLevel");
	HackingMods[playerid] = 0;
	PlayerInfo[playerid][pHitman] = -1;
	pSpeed[playerid] = 0.0;
	//SetTimerEx("HackingTimer", 1000, 0, "i", playerid);

	for(new i = 0; i < 3; i++) {
		StopaniFloats[playerid][i] = 0;
	}

	for(new i = 0; i < 3; i++) {
        ConfigEventCPs[playerid][i] = 0;
    }
    ConfigEventCPId[playerid] = 0;
    RCPIdCurrent[playerid] = 0;

	for(new i = 0; i < 6; i++) {
	    EventFloats[playerid][i] = 0.0;
	}
	EventLastInt[playerid] = 0; EventLastVW[playerid] = 0;

	for(new i = 0; i < MAX_PLAYERVEHICLES; ++i) {
		PlayerVehicleInfo[playerid][i][pvModelId] = 0;
		PlayerVehicleInfo[playerid][i][pvId] = INVALID_PLAYER_VEHICLE_ID;
		PlayerVehicleInfo[playerid][i][pvSpawned] = 0;
		PlayerVehicleInfo[playerid][i][pvSlotId] = 0;
		PlayerVehicleInfo[playerid][i][pvBeingPickLocked] = 0;
		PlayerVehicleInfo[playerid][i][pvAlarmTriggered] = 0;
		PlayerVehicleInfo[playerid][i][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		PlayerVehicleInfo[playerid][i][pvAllowedPlayerId] = INVALID_PLAYER_ID;
	}

	for(new i = 0; i < MAX_PLAYERTOYS; i++) {
		PlayerToyInfo[playerid][i][ptID] = -1;
		PlayerToyInfo[playerid][i][ptModelID] = 0;
		PlayerToyInfo[playerid][i][ptBone] = 0;
		PlayerToyInfo[playerid][i][ptSpecial] = 0;
	}

	for(new i = 0; i < 10; i++) {
		PlayerHoldingObject[playerid][i] = 0;
	}

	for(new i = 0; i < 5; i++) {
		LottoNumbers[playerid][i] = 0;
	}

	for(new i = 0; i < MAX_BUSINESSSALES; i++) {
        Selected[playerid][i] = 0;
	}
	for(new x=0; x < mS_SELECTION_ITEMS; x++) {
        gSelectionItems[playerid][x] = PlayerText:INVALID_TEXT_DRAW;
	}

	gHeaderTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gBackgroundTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gCurrentPageTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gNextButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gPrevButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gCancelButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	inSafeZone{playerid} = false;
    SpoofKill[playerid] = 0;
	KillTime[playerid] = 0;
	gItemAt[playerid] = 0;
	TruckUsed[playerid] = INVALID_VEHICLE_ID;
	pDrunkLevelLast[playerid] = 0;
    pFPS[playerid] = 0;
	BackupClearTimer[playerid] = 0;
	Backup[playerid] = 0;
    CarRadars[playerid] = 0;
	PlayerInfo[playerid][pReg] = 0;
	OrderAssignedTo[playerid] = INVALID_PLAYER_ID;
	TruckUsed[playerid] = INVALID_VEHICLE_ID;
	HouseOffer[playerid] = INVALID_PLAYER_ID;
	House[playerid] = 0;
	HousePrice[playerid] = 0;
	playerTabbed[playerid] = 0;
	playerAFK[playerid] = 0;
	gBug{playerid} = 1;
	TazerTimeout[playerid] = 0;
	gRadio{playerid} = 1;
	playerLastTyped[playerid] = 0;
	pTazer{playerid} = 0;
	pTazerReplace{playerid} = 0;
	pCurrentWeapon{playerid} = 0;
	MedicAccepted[playerid] = INVALID_PLAYER_ID;
	DefendOffer[playerid] = INVALID_PLAYER_ID;
	AppealOffer[playerid] = INVALID_PLAYER_ID;
	AppealOfferAccepted[playerid] = 0;
	PlayerInfo[playerid][pWantedLevel] = 0;
	DefendPrice[playerid] = 0;
	Spectating[playerid] = 0;
	GettingSpectated[playerid] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pPhonePrivacy] = 0;
	NewbieTimer[playerid] = 0;
	HlKickTimer[playerid] = 0;
	HelperTimer[playerid] = 0;
	VehicleOffer[playerid] = INVALID_PLAYER_ID;
	VehiclePrice[playerid] = 0;
	VehicleId[playerid] = -1;
	NOPTrigger[playerid] = 0;
	JustReported[playerid] = -1;
	UsedCrack[playerid] = 0;
	UsedWeed[playerid] = 0;
	SexOffer[playerid] = INVALID_PLAYER_ID;
	DrinkOffer[playerid] =  INVALID_PLAYER_ID;
	PotOffer[playerid] = INVALID_PLAYER_ID;
	PotStorageID[playerid] = -1;
	CrackOffer[playerid] = INVALID_PLAYER_ID;
	CrackStorageID[playerid] = -1;
	GunOffer[playerid] = INVALID_PLAYER_ID;
	GunStorageID[playerid] = -1;
	CraftOffer[playerid] = INVALID_PLAYER_ID;
	RepairOffer[playerid] = INVALID_PLAYER_ID;
	GuardOffer[playerid] = INVALID_PLAYER_ID;
	LiveOffer[playerid] = INVALID_PLAYER_ID;
	RefillOffer[playerid] = INVALID_PLAYER_ID;
	MatsOffer[playerid] = INVALID_PLAYER_ID;
	MatsStorageID[playerid] = -1;
	MatsPrice[playerid] = 0;
	MatsAmount[playerid] = 0;
	BoxOffer[playerid] = INVALID_PLAYER_ID;
	MarryWitnessOffer[playerid] = INVALID_PLAYER_ID;
	ProposeOffer[playerid] = INVALID_PLAYER_ID;
	DivorceOffer[playerid] = INVALID_PLAYER_ID;
	HidePM[playerid] = 0;
	PhoneOnline[playerid] = 0;
	unbanip[playerid][0] = 0;
    advisorchat[playerid] = 1;
	ChosenSkin[playerid]=0;
	SelectFChar[playerid]=0;
	MatsHolding[playerid]=0;
	MatDeliver[playerid]=-1;
	MatDeliver2[playerid]=0;
	szAdvert[playerid][0] = 0;
	AdvertType[playerid] = 0;
	SelectFCharPlace[playerid]=0;
	GettingJob[playerid]=0;
	GettingJob2[playerid]=0;
	GettingJob3[playerid]=0;
	GuardOffer[playerid]= INVALID_PLAYER_ID;
	GuardPrice[playerid]=0;
	ApprovedLawyer[playerid]=0;
	CallLawyer[playerid]=0;
	WantLawyer[playerid]=0;
	CurrentMoney[playerid]=0;
	UsedFind[playerid]=0;
	CP[playerid]=0;
	Condom[playerid]=0;
	SexOffer[playerid]= INVALID_PLAYER_ID;
	SexPrice[playerid]=0;
	PlayerInfo[playerid][pAdmin]=0;
	RepairOffer[playerid]= INVALID_PLAYER_ID;
	RepairPrice[playerid]=0;
	RepairCar[playerid]=0;
	TalkingLive[playerid]=INVALID_PLAYER_ID;
	LiveOffer[playerid]= INVALID_PLAYER_ID;
	RefillOffer[playerid]= INVALID_PLAYER_ID;
	RefillPrice[playerid]=0;
	InsidePlane[playerid]=INVALID_VEHICLE_ID;
	InsideMainMenu{playerid}=0;
	InsideTut{playerid}=0;
	CrackOffer[playerid]= INVALID_PLAYER_ID;
	CrackStorageID[playerid]=-1;
	PlayerCuffed[playerid]=0;
	PlayerCuffedTime[playerid]=0;
	PotPrice[playerid]=0;
	CrackPrice[playerid]=0;
	RegistrationStep[playerid]=0;
	PotGram[playerid]=0;
	CrackGram[playerid]=0;
	PlayerInfo[playerid][pBanned]=0;
	ConnectedToPC[playerid]=0;
	OrderReady[playerid]=0;
	GunId[playerid]=0;
	GunMats[playerid]=0;
	CraftId[playerid]=0;
	CraftMats[playerid]=0;
	HitOffer[playerid]= INVALID_PLAYER_ID;
	HitToGet[playerid]= INVALID_PLAYER_ID;
	InviteOffer[playerid]= INVALID_PLAYER_ID;
	hInviteHouse[playerid]=INVALID_HOUSE_ID;
	hInviteOffer[playerid]= INVALID_PLAYER_ID;
	hInviteOfferTo[playerid]= INVALID_PLAYER_ID;
	GotHit[playerid]=0;
	GoChase[playerid]= INVALID_PLAYER_ID;
	GetChased[playerid]= INVALID_PLAYER_ID;
	CalledCops[playerid]=0;
	CopsCallTime[playerid]=0;
	BoxWaitTime[playerid]=0;
	CalledMedics[playerid]=0;
	TransportDuty[playerid]=0;
	PlayerTied[playerid]=0;
	MedicsCallTime[playerid]=0;
	BusCallTime[playerid]=0;
	TaxiCallTime[playerid]=0;
	EMSCallTime[playerid]=0;
	MedicCallTime[playerid]=0;
	MechanicCallTime[playerid]=0;
	FindTimePoints[playerid]=0;
	FindingPlayer[playerid]=-1;
	FindTime[playerid]=0;
	JobDuty[playerid]=0;
	Mobile[playerid]=INVALID_PLAYER_ID;
	Music[playerid]=0;
	BoxOffer[playerid]= INVALID_PLAYER_ID;
	PlayerBoxing[playerid]=0;
	Spectate[playerid]= INVALID_PLAYER_ID;
	PlayerDrunk[playerid]=0;
	PlayerDrunkTime[playerid]=0;
	format(PlayerInfo[playerid][pPrisonReason],128,"None");
	// FishCount[playerid]=0;
	HelpingNewbie[playerid]= INVALID_PLAYER_ID;
	courtjail[playerid]=0;
	gLastCar[playerid]=0;
	FirstSpawn[playerid]=0;
	JetPack[playerid]=0;
	PlayerInfo[playerid][pKills]=0;
	PlayerInfo[playerid][pPaintTeam]=0;
	TextSpamTimes[playerid] = 0;
	TextSpamUnmute[playerid] = 0;
 	CommandSpamTimes[playerid] = 0;
	CommandSpamUnmute[playerid] = 0;
	gOoc[playerid] = 0;
	arr_Towing[playerid] = INVALID_VEHICLE_ID;
	gNews[playerid] = 0;
	PlayerInfo[playerid][pToggledChats][0] = 1;
	gPlayerLogged{playerid} = 0;
	gPlayerLogTries[playerid] = 0;
	IsSpawned[playerid] = 0;
	SpawnKick[playerid] = 0;
	PlayerStoned[playerid] = 0;
	StartTime[playerid] = 0;
	TicketOffer[playerid] = INVALID_PLAYER_ID;
	TicketMoney[playerid] = 0;
	PlayerInfo[playerid][pVehicleKeysFrom] = INVALID_PLAYER_ID;
	ActiveChatbox[playerid] = 1;
	TutStep[playerid] = 0;
	PlayerInfo[playerid][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
	TaxiAccepted[playerid] = INVALID_PLAYER_ID;
	EMSAccepted[playerid] = INVALID_PLAYER_ID;
	BusAccepted[playerid] = INVALID_PLAYER_ID;
	HireCar[playerid] = 299;
	TransportValue[playerid] = 0;
	TransportMoney[playerid] = 0;
	TransportTime[playerid] = 0;
	TransportCost[playerid] = 0;
	TransportDriver[playerid] = INVALID_PLAYER_ID;
	Locator[playerid] = 0;
	ReleasingMenu[playerid] = INVALID_PLAYER_ID;
	Fishes[playerid][pLastFish] = 0;
	Fishes[playerid][pFishID] = 0;
	ProposeOffer[playerid] = INVALID_PLAYER_ID;
	MarryWitness[playerid] = INVALID_PLAYER_ID;
	MarryWitnessOffer[playerid] = INVALID_PLAYER_ID;
	MarriageCeremoney[playerid] = 0;
	ProposedTo[playerid] = INVALID_PLAYER_ID;
	GotProposedBy[playerid] = INVALID_PLAYER_ID;
	DivorceOffer[playerid] = INVALID_PLAYER_ID;
	gBike[playerid] = 0;
	gBikeRenting[playerid] = 0;
	Fixr[playerid] = 0;
	VehicleSpawned[playerid] = 0;
	ReportCount[playerid] = 0;
	ReportHourCount[playerid] = 0;
	WDReportCount[playerid] = 0;
	WDReportHourCount[playerid] = 0;
	PlayerInfo[playerid][pServiceTime] = 0;
	Homes[playerid] = 0;
	sobeitCheckvar[playerid] = 0;
	sobeitCheckIsDone[playerid] = 0;
	IsPlayerFrozen[playerid] = 0;
	strdel(PlayerInfo[playerid][pAutoTextReply], 0, 64);
	rBigEarT[playerid] = 0;
	aLastShot[playerid] = INVALID_PLAYER_ID;
	aLastShotBone[playerid] = 0;
	if(IsValidDynamic3DTextLabel(RFLTeamN3D[playerid])) {
		DestroyDynamic3DTextLabel(RFLTeamN3D[playerid]);
		RFLTeamN3D[playerid] = Text3D:-1;
	}
	SpecTime[playerid] = 0;
	PlayerShots[playerid] = 0;
	PlayerSniperShots[playerid] = 0;
	PlayerKills[playerid] = 0;
	// These need to be reset to prevent some bugs (DO NOT REMOVE)
	PlayerInfo[playerid][pModel] = 0;
	PlayerInfo[playerid][pLeader] = INVALID_GROUP_ID;
	PlayerInfo[playerid][pMember] = INVALID_GROUP_ID;
	PlayerInfo[playerid][pDivision] = INVALID_DIVISION;
	strcpy(PlayerInfo[playerid][pBadge], "None", 9);
	PlayerInfo[playerid][pRank] = INVALID_RANK;
	PlayerInfo[playerid][pOrder] = 0;
	PlayerInfo[playerid][pOrderConfirmed] = 0;
	PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
	acstruct[playerid][LastOnFootPosition][0] = 0.0; acstruct[playerid][LastOnFootPosition][1] = 0.0; acstruct[playerid][LastOnFootPosition][2] = 0.0;
	acstruct[playerid][checkmaptp] = 0; acstruct[playerid][maptplastclick] = 0;
	acstruct[playerid][maptp][0] = 0.0; acstruct[playerid][maptp][1] = 0.0; acstruct[playerid][maptp][2] = 0.0;

	PlayerInfo[playerid][pLastPass][0] = 0;
	PlayerInfo[playerid][pGroupToy][0] = 0.0;
	PlayerInfo[playerid][pGroupToy][1] = 0.0;
	PlayerInfo[playerid][pGroupToy][2] = 0.0;
	PlayerInfo[playerid][pGroupToy][3] = 0.0;
	PlayerInfo[playerid][pGroupToy][4] = 0.0;
	PlayerInfo[playerid][pGroupToy][5] = 0.0;
	PlayerInfo[playerid][pGroupToy][6] = 1.0;
	PlayerInfo[playerid][pGroupToy][7] = 1.0;
	PlayerInfo[playerid][pGroupToy][8] = 1.0;

	PlayerInfo[playerid][pHolsteredWeapon] = 0;
	IsDoingAnim[playerid] = 0;
	GhostHacker[playerid][0] = 0;
	GhostHacker[playerid][1] = gettime();
	GhostHacker[playerid][2] = 0;
	GhostHacker[playerid][3] = 0;
	GhostHacker[playerid][4] = 0;
	GhostHacker[playerid][5] = gettime();
	GhostHacker[playerid][6] = gettime();
	foreach(new x: Player)
	{
	    ShotPlayer[playerid][x] = 0;
	}

	for(new s = 0; s < 12; s++) {
		PlayerInfo[playerid][pAGuns][s] = 0;
		PlayerInfo[playerid][pGuns][s] = 0;
	}

	for(new s = 0; s < 40; s++) {
		ListItemReportId[playerid][s] = -1;
	}

	for(new s = 0; s < 20; s++) {
		ListItemRCPId[playerid][s] = -1;
	}

	CancelReport[playerid] = -1;
	GiveKeysTo[playerid] = INVALID_PLAYER_ID;
	RocketExplosions[playerid] = -1;
	// ClearFishes(playerid); no.
	ClearMarriage(playerid);

	// Crash Fix - GhoulSlayeR
	if(!InvalidNameCheck(playerid)) {
		return 1;
	}

	Format_PlayerName(playerid);

	//CheckAdminWhitelist(playerid);
	CheckBanEx(playerid);

	new string[128], serial[64];
	gpci(playerid, serial, sizeof(serial));
	format(string, sizeof(string), "%s/checks/gpci.php?g=%s&n=%s&i=%s", SAMP_WEB, serial, GetPlayerNameExt(playerid), GetPlayerIpEx(playerid));
	HTTP(0, HTTP_HEAD, string, "", "");

	// Main Menu Features
	InsideMainMenu{playerid} = 0;
	InsideTut{playerid} = 0;

	ShowMainMenuGUI(playerid);
	//SetPlayerJoinCamera(playerid);
	ClearChatbox(playerid);
	SetPlayerVirtualWorld(playerid, 1);

	SetPlayerColor(playerid,TEAM_HIT_COLOR);
	SendClientMessage( playerid, COLOR_WHITE, "SERVER: Ban dang ket noi voi may chu GTA Netwok." );

	SyncPlayerTime(playerid);

	ShowNoticeGUIFrame(playerid, 1);

	logincheck[playerid] = SetTimerEx("LoginCheck", 220000, 0, "i", playerid);

	SetTimerEx("LoginCheckEx", 5000, 0, "i", playerid);

	gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
	SetHealth(playerid, 100);
	SetArmour(playerid, 0);

	Bit_Off(arrPlayerBits[playerid], dr_bitUsedDrug);
	Bit_Off(arrPlayerBits[playerid], dr_bitInDrugEffect);
	Bit_Off(arrPlayerBits[playerid], phone_bitState);
	Bit_Off(arrPlayerBits[playerid], phone_bitCamState);
	Bit_Off(arrPlayerBits[playerid], phone_bitTraceState);
	Bit_Off(arrPlayerBits[playerid], bitFPS);
	Bit_Off(arrPlayerBits[playerid], pTurfRadar);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(!isnull(unbanip[playerid]))
	{
	    new string[26];
	    format(string, sizeof(string), "unbanip %s", unbanip[playerid]);
	    SendRconCommand(string);
	}
	KillTimer(logincheck[playerid]);
	if(GetPVarType(playerid, "SpectatingWatch")) SetPVarInt(GetPVarInt(playerid, "SpectatingWatch"), "BeingSpectated", 0);
	if(GetPVarInt(playerid, "FreezeTimer")) KillTimer(GetPVarInt(playerid, "FreezeTimer")), DeletePVar(playerid, "FreezeTimer");
	foreach(new i: Player)
	{
		if(Spectating[i] > 0 && Spectate[i] == playerid) {
			SetPVarInt(i, "StartedWatching", 0);
			SetPVarInt(i, "NextWatch", 0);
			SetPVarInt(i, "SpecOff", 1);
			Spectating[i] = 0;
			SpecTime[i] = 0;
			Spectate[i] = INVALID_PLAYER_ID;
			GettingSpectated[playerid] = INVALID_PLAYER_ID;
			TogglePlayerSpectating(i, false);
			SetCameraBehindPlayer(i);
			SendClientMessageEx(i, COLOR_WHITE, "The player you were spectating has left the server.");
		}
		if(GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
			DeletePVar(i, "_dCheck");
			SendClientMessageEx(i, COLOR_WHITE, "The player you were damage checking has left the server.");
		}
		if(GetPVarType(i, "sellbackpack") && GetPVarInt(i, "sellbackpack") == playerid) DeletePVar(i, "sellbackpack");
	}
	// Why save on people who haven't logged in!
	if(gPlayerLogged{playerid} == 1)
	{
		if(TempNumber[playerid] == 1) {
			PlayerInfo[playerid][pPnumber] = GetPVarInt(playerid, "oldnum");
			TempNumber[playerid] = 0;
		}
		if(GetPVarType(playerid, "signID") && IsValidDynamicObject(GetPVarInt(playerid, "signID"))) DestroyDynamicObject(GetPVarInt(playerid, "signID"));
		g_mysql_RemoveDumpFile(GetPlayerSQLId(playerid));
		if(HungerPlayerInfo[playerid][hgInEvent] == 1)
		{
			if(hgActive == 2)
			{
				if(hgPlayerCount == 3)
				{
					new szmessage[128];
					format(szmessage, sizeof(szmessage), "** %s has came in third place in the Hunger Games Event.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);

					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);

					ResetPlayerWeapons(playerid);

					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
					HideHungerGamesTextdraw(playerid);
					PlayerInfo[playerid][pRewardDrawChance] += 10;
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "** Ban da duoc tang 10 luot quay cho su kien Fall into Fun Event.");

					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w]);
						}
					}
				}
				else if(hgPlayerCount == 2)
				{
					new szmessage[128];
					format(szmessage, sizeof(szmessage), "** %s has came in second place in the Hunger Games Event.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);

					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);

					ResetPlayerWeapons(playerid);

					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
					HideHungerGamesTextdraw(playerid);
					PlayerInfo[playerid][pRewardDrawChance] += 25;
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "** Ban da duoc tang 25 luot quay cho su kien Fall into Fun Event.");

					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w]);
						}
					}

					foreach(new i: Player)
					{
						if(HungerPlayerInfo[i][hgInEvent] == 1)
						{
							format(szmessage, sizeof(szmessage), "** %s has came in first place in the Hunger Games Event.", GetPlayerNameEx(i));
							SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);

							SetHealth(i, HungerPlayerInfo[i][hgLastHealth]);
							SetArmour(i, HungerPlayerInfo[i][hgLastArmour]);
							SetPlayerVirtualWorld(i, HungerPlayerInfo[i][hgLastVW]);
							SetPlayerInterior(i, HungerPlayerInfo[i][hgLastInt]);
							SetPlayerPos(i, HungerPlayerInfo[i][hgLastPosition][0], HungerPlayerInfo[i][hgLastPosition][1], HungerPlayerInfo[i][hgLastPosition][2]);

							ResetPlayerWeapons(i);

							HungerPlayerInfo[i][hgInEvent] = 0;
							hgPlayerCount--;
							HideHungerGamesTextdraw(i);
							PlayerInfo[i][pRewardDrawChance] += 50;
							SendClientMessageEx(i, COLOR_LIGHTBLUE, "** Ban da duoc tang 50 luot quay cho su kien Fall into Fun Event.");
							hgActive = 0;

							for(new w = 0; w < 12; w++)
							{
								PlayerInfo[i][pGuns][w] = HungerPlayerInfo[i][hgLastWeapon][w];
								if(PlayerInfo[i][pGuns][w] > 0 && PlayerInfo[i][pAGuns][w] == 0)
								{
									GivePlayerValidWeapon(i, PlayerInfo[i][pGuns][w]);
								}
							}
						}
					}

					for(new i = 0; i < 600; i++)
					{
						if(IsValidDynamic3DTextLabel(HungerBackpackInfo[i][hgBackpack3DText]))
						{
							DestroyDynamic3DTextLabel(HungerBackpackInfo[i][hgBackpack3DText]);
						}
						if(IsValidDynamicPickup(HungerBackpackInfo[i][hgBackpackPickupId]))
						{
							DestroyDynamicPickup(HungerBackpackInfo[i][hgBackpackPickupId]);
						}

						HungerBackpackInfo[i][hgActiveEx] = 0;
					}
				}
				else if(hgPlayerCount > 3)
				{
					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);

					ResetPlayerWeapons(playerid);

					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da chet va bi thoat khoi su kien Hunger Games , chuc may man lan toi .");

					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;

					HideHungerGamesTextdraw(playerid);

					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w]);
						}
					}
				}

				new string[128];
				format(string, sizeof(string), "Players in event: %d", hgPlayerCount);
				foreach(new i: Player)
				{
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgPlayerText], string);
				}

				return true;
			}
		}
		if (GetPVarInt(playerid, "_BikeParkourStage") > 0)
		{
			new slot = GetPVarInt(playerid, "_BikeParkourSlot");
			new biz = InBusiness(playerid);

			DestroyDynamicPickup(GetPVarInt(playerid, "_BikeParkourPickup"));

			Businesses[biz][bGymBikePlayers][slot] = INVALID_PLAYER_ID;

			if (GetPVarInt(playerid, "_BikeParkourStage") > 1)
			{
				DestroyVehicle(Businesses[biz][bGymBikeVehicles][slot]);
				Businesses[biz][bGymBikeVehicles][slot] = INVALID_VEHICLE_ID;
			}
		}
		if(GetPVarType(playerid, "DeliveringVehicleTime")) {
			if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
				new szQuery[128];
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d' AND `sqlID` = '%d'", VehicleFuel[GetPVarInt(playerid, "LockPickVehicle")], GetPVarInt(playerid, "LockPickVehicleSQLId"), GetPVarInt(playerid, "LockPickPlayerSQLId"));
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
			else {
				new slot = GetPlayerVehicle(GetPVarInt(playerid, "LockPickPlayer"), GetPVarInt(playerid, "LockPickVehicle")),
					ownerid = GetPVarInt(playerid, "LockPickPlayer");
				--PlayerCars;
				VehicleSpawned[ownerid]--;
				PlayerVehicleInfo[ownerid][slot][pvBeingPickLocked] = 0;
				PlayerVehicleInfo[ownerid][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
				PlayerVehicleInfo[ownerid][slot][pvAlarmTriggered] = 0;
				PlayerVehicleInfo[ownerid][slot][pvSpawned] = 0;
				PlayerVehicleInfo[ownerid][slot][pvFuel] = VehicleFuel[GetPVarInt(playerid, "LockPickVehicle")];
				GetVehicleHealth(PlayerVehicleInfo[ownerid][slot][pvId], PlayerVehicleInfo[ownerid][slot][pvHealth]);
				PlayerVehicleInfo[ownerid][slot][pvId] = INVALID_PLAYER_VEHICLE_ID;
				g_mysql_SaveVehicle(ownerid, slot);
			}
			DestroyVehicle(GetPVarInt(playerid, "LockPickVehicle"));
			DisablePlayerCheckpoint(playerid);
		}
		if(GetPVarType(playerid, "AttemptingLockPick")) {
			if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
				DestroyVehicle(GetPVarInt(playerid, "LockPickVehicle"));
			}
			else {
				new slot = GetPlayerVehicle(GetPVarInt(playerid, "LockPickPlayer"), GetPVarInt(playerid, "LockPickVehicle"));
				PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLocked] = 0;
				PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
			}
		}
		if(GetPVarType(playerid, "Gas_TrailerID"))
		{
		    if(GetVehicleModel(GetPVarInt(playerid, "Gas_TrailerID")) == 584)
		    {
		        printf("Deleting Trailer. Veh ID %d Player %s", GetPVarInt(playerid, "Gas_TrailerID"), GetPlayerNameExt(playerid));
		        DestroyVehicle(GetPVarInt(playerid, "Gas_TrailerID"));
		    }
		}

		// added to prevent trucks holding shit after logging out. hotfix #1069
		if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
		{
			SetVehicleToRespawn(TruckUsed[playerid]);
		}

		if (GetPVarType(playerid, "_BoxingFight"))
		{
			new fighterid = GetPVarInt(playerid, "_BoxingFight") - 1;
			DeletePVar(fighterid, "_BoxingFight");
			SendClientMessageEx(fighterid, COLOR_GREY, "Nguoi ma ban chien dau da roi khoi dau truong.");
			SetPVarInt(fighterid, "_BoxingFightOver", gettime() + 1);
			new biz = InBusiness(fighterid);
			if(biz != INVALID_BUSINESS_ID) {
				if (Businesses[biz][bGymBoxingArena1][0] == fighterid || Businesses[biz][bGymBoxingArena1][1] == fighterid) // first arena
				{
					Businesses[biz][bGymBoxingArena1][0] = INVALID_PLAYER_ID;
					Businesses[biz][bGymBoxingArena1][1] = INVALID_PLAYER_ID;
				}
				else if (Businesses[biz][bGymBoxingArena2][0] == fighterid || Businesses[biz][bGymBoxingArena2][1] == fighterid) // second arena
				{
					Businesses[biz][bGymBoxingArena2][0] = INVALID_PLAYER_ID;
					Businesses[biz][bGymBoxingArena2][1] = INVALID_PLAYER_ID;
				}
			}

			PlayerInfo[playerid][pPos_x] = 2913.2175;
			PlayerInfo[playerid][pPos_y] = -2288.1914;
			PlayerInfo[playerid][pPos_z] = 7.2543;
		}
		if(RocketExplosions[playerid] != -1)
		{
			DestroyDynamicObject(Rocket[playerid]);
			DestroyDynamicObject(RocketLight[playerid]);
			DestroyDynamicObject(RocketSmoke[playerid]);
		}

		if(GetPVarType(playerid, "pBoomBox"))
		{
		    DestroyDynamicObject(GetPVarInt(playerid, "pBoomBox"));
		    DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "pBoomBoxLabel"));
		    if(GetPVarType(playerid, "pBoomBoxArea"))
		    {
		        new string[128];
				format(string, sizeof(string), "The boombox owner (%s) has logged off", GetPlayerNameEx(playerid));
		        foreach(new i: Player)
				{
					if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea")))
					{
						StopAudioStreamForPlayerEx(i);
						SendClientMessage(i, COLOR_PURPLE, string);
					}
				}
			}
		}
		#if defined zombiemode
		if(GetPVarType(playerid, "pZombieBit"))
		{
            MakeZombie(playerid);
		}
		#endif
		if(GetPVarType(playerid, "RentedVehicle")) {
		    DestroyVehicle(GetPVarInt(playerid, "RentedVehicle"));
		}
		if(GetPVarType(playerid, "pkrTableID")) {
			LeavePokerTable(playerid);
		}

		if(GetPVarType(playerid, "pTable")) {
		    DestroyPokerTable(GetPVarInt(playerid, "pTable"));
		}
		if(GetPVarType(playerid, "DraggingPlayer"))
		{
            DeletePVar(GetPVarInt(playerid, "DraggingPlayer"), "BeingDragged");
		}
		if(pTazer{playerid} == 1) GivePlayerValidWeapon(playerid,pTazerReplace{playerid});
		if(GetPVarInt(playerid, "SpeedRadar") == 1) GivePlayerValidWeapon(playerid, GetPVarInt(playerid, "RadarReplacement"));

		if(GetPVarType(playerid, "MovingStretcher")) {
			KillTimer(GetPVarInt(playerid, "TickEMSMove"));
		}
		if(GetPVarInt(playerid, "Injured") == 1) {
			PlayerInfo[playerid][pHospital] = 1;
			ResetPlayerWeaponsEx(playerid);
		}
		KillEMSQueue(playerid);
		if(GetPVarInt(playerid, "HeroinEffect")) {
			KillTimer(GetPVarInt(playerid, "HeroinEffect"));
			PlayerInfo[playerid][pHospital] = 1;
			KillEMSQueue(playerid);
			ResetPlayerWeaponsEx(playerid);
		}
		if(GetPVarInt(playerid, "AttemptPurify"))
		{
			Purification[0] = 0;
	    	KillTimer(GetPVarInt(playerid, "AttemptPurify"));
		}
		if(control[playerid] == 1) {
			control[playerid] = 0;
			KillTimer(ControlTimer[playerid]);
		}
		if(PlayerInfo[playerid][pLockCar] != INVALID_VEHICLE_ID) {
			vehicle_unlock_doors(PlayerInfo[playerid][pLockCar]);
			PlayerInfo[playerid][pLockCar] = INVALID_VEHICLE_ID;
		}

		if(PlayerInfo[playerid][pVehicleKeysFrom] != INVALID_PLAYER_ID) {
			PlayerVehicleInfo[PlayerInfo[playerid][pVehicleKeysFrom]][PlayerInfo[playerid][pVehicleKeys]][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		}
		if(GetPVarType(playerid, "ttSeller") && GetPVarInt(playerid, "ttSeller") != INVALID_PLAYER_ID)
		{
			SendClientMessageEx(GetPVarInt(playerid, "ttSeller"), COLOR_GRAD2, "The buyer has disconnected from the server.");
			DeletePVar(GetPVarInt(playerid, "ttSeller"), "ttBuyer");
			DeletePVar(GetPVarInt(playerid, "ttSeller"), "ttCost");
			DeletePVar(playerid, "ttSeller");
			HideTradeToysGUI(playerid);
		}
		if(GetPVarType(playerid, "buyerVoucher"))
		{
			DeletePVar(GetPVarInt(playerid, "buyerVoucher"), "sellerVoucher");
		}
		if(GetPVarType(playerid, "sellerVoucher"))
		{
			DeletePVar(GetPVarInt(playerid, "sellerVoucher"), "buyerVoucher");
		}
		if(HackingMods[playerid] > 0) { HackingMods[playerid] = 0; }

		if(gettime() >= PlayerInfo[playerid][pMechTime]) PlayerInfo[playerid][pMechTime] = 0;
		if(gettime() >= PlayerInfo[playerid][pLawyerTime]) PlayerInfo[playerid][pLawyerTime] = 0;
		if(gettime() >= PlayerInfo[playerid][pDrugsTime]) PlayerInfo[playerid][pDrugsTime] = 0;
		if(gettime() >= PlayerInfo[playerid][pSexTime]) PlayerInfo[playerid][pSexTime] = 0;

		if(GetPVarInt(playerid, "HidingKnife") == 1) PlayerInfo[playerid][pGuns][1] = 4;

		//if(GetPVarType(playerid, "IsInArena")) LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));

		// Trucker revamp.
		/*for(new i = 0; i < MAX_VEHICLES; i++)
		{
			if(TruckUsedBy[i] == playerid) TruckUsedBy[i] = -1; // Resets a truck if a player disconnects mid-route.
			PlayerInfo[playerid][pUsingTruck] = -1;
		}*/

		new string[128];
		switch(reason)
		{
			case 0:
			{
				if(PlayerInfo[playerid][pAdmin] >= 2 && Spectating[playerid] == 1)
				{
					PlayerInfo[playerid][pPos_x] = GetPVarFloat(playerid, "SpecPosX");
					PlayerInfo[playerid][pPos_y] = GetPVarFloat(playerid, "SpecPosY");
					PlayerInfo[playerid][pPos_z] = GetPVarFloat(playerid, "SpecPosZ");
					PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "SpecInt");
					PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "SpecVW");
					DeletePVar(playerid, "SpecOff");
					if(GetPVarType(playerid, "pGodMode"))
					{
						SetHealth(playerid, 0x7FB00000);
						SetArmour(playerid, 0x7FB00000);
					}
					GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
					Spectate[playerid] = INVALID_PLAYER_ID;
				}
				else
				{
					format(string, sizeof(string), "%s da thoat khoi game (timeout).", GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW);
				}
				format(string, sizeof(string), "%s (ID: %d | SQL ID: %d | Level: %d | IP: %s) has timed out.", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pIP]);
				Log("logs/login.log", string);
				if(PlayerCuffed[playerid] != 0)
				{
					if(PlayerCuffed[playerid] == 2)
				    {
					    SetHealth(playerid, GetPVarFloat(playerid, "cuffhealth"));
	                    SetArmour(playerid, GetPVarFloat(playerid, "cuffarmor"));
	                    DeletePVar(playerid, "cuffhealth");
						DeletePVar(playerid, "PlayerCuffed");
					}
					strcpy(PlayerInfo[playerid][pPrisonReason], "[IC] DMCF ((CWC))", 128);
					strcpy(PlayerInfo[playerid][pPrisonedBy], "System - CWC", 128);
					if(PlayerInfo[playerid][pWantedJailTime] != 0) PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pWantedJailTime]*60; else PlayerInfo[playerid][pJailTime] += 120*60;
					if(PlayerInfo[playerid][pWantedJailFine] != 0) GivePlayerCash(playerid, -PlayerInfo[playerid][pWantedJailFine]);

					format(string, sizeof(string), "%s has crashed while cuffed. (ID: %d | SQLID: %D | JT: %d | F: %d | IP: %s)", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pWantedJailTime], PlayerInfo[playerid][pWantedJailFine], PlayerInfo[playerid][pIP]);
					Log("logs/login.log", string);

					PlayerInfo[playerid][pBailPrice] = 15000000;
					PlayerInfo[playerid][pWantedJailFine] = 0;
					PlayerInfo[playerid][pWantedJailTime] = 0;
					PlayerInfo[playerid][pWantedLevel] = 0;
				}
				if(((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)) && (PlayerInfo[playerid][pAdmin] < 2 || (PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pTogReports])))
				{
					new badge[12], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
					if(strcmp(PlayerInfo[playerid][pBadge], "None", true) != 0) format(badge, sizeof(badge), "[%s] ", PlayerInfo[playerid][pBadge]);
					GetPlayerGroupInfo(playerid, rank, division, employer);
					if(IsACop(playerid))
					{
						if(PlayerInfo[playerid][pDuty])
						{
							format(string, sizeof(string), "** %s%s %s is code 0 **", badge, rank, GetPlayerNameEx(playerid));
							foreach(new i: Player)
							{
								if(PlayerInfo[i][pToggledChats][12] == 0)
								{
									if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
						}
						format(string, sizeof string, "%s%s %s has timed out.", badge, rank, GetPlayerNameEx(playerid));
						GroupLog(PlayerInfo[playerid][pMember], string);
					}
					else if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && !IsACop(playerid))
					{
						if(PlayerInfo[playerid][pDuty] || arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_CRIMINAL)
						{
							format(string, sizeof(string), "** %s%s %s is no longer available (( lost connection )) **", badge, rank, GetPlayerNameEx(playerid));
							foreach(new i: Player)
							{
								if(PlayerInfo[i][pToggledChats][12] == 0)
								{
									if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
						}
						format(string, sizeof string, "%s%s %s has lost connection.", badge, rank, GetPlayerNameEx(playerid));
						GroupLog(PlayerInfo[playerid][pMember], string);
					}
				}
			}
			case 1:
			{
				if(PlayerInfo[playerid][pAdmin] >= 2 && Spectating[playerid] == 1)
				{
					PlayerInfo[playerid][pPos_x] = GetPVarFloat(playerid, "SpecPosX");
					PlayerInfo[playerid][pPos_y] = GetPVarFloat(playerid, "SpecPosY");
					PlayerInfo[playerid][pPos_z] = GetPVarFloat(playerid, "SpecPosZ");
					PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "SpecInt");
					PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "SpecVW");
					DeletePVar(playerid, "SpecOff");
					if(GetPVarType(playerid, "pGodMode"))
					{
						SetHealth(playerid, 0x7FB00000);
						SetArmour(playerid, 0x7FB00000);
					}
					GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
					Spectate[playerid] = INVALID_PLAYER_ID;
				}
				else
				{
					format(string, sizeof(string), "%s da thoat khoi game (/q).", GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW);
				}
				format(string, sizeof(string), "%s (ID: %d | SQL ID: %d | Level: %d | IP: %s) has disconnected.", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pIP]);
				Log("logs/login.log", string);
				if(PlayerCuffed[playerid] != 0)
				{
				    if(PlayerCuffed[playerid] == 2)
				    {
					    SetHealth(playerid, GetPVarFloat(playerid, "cuffhealth"));
	                    SetArmour(playerid, GetPVarFloat(playerid, "cuffarmor"));
	                    DeletePVar(playerid, "cuffhealth");
						DeletePVar(playerid, "PlayerCuffed");
					}
					strcpy(PlayerInfo[playerid][pPrisonReason], "[IC] EBCF ((LWC))", 128);
					strcpy(PlayerInfo[playerid][pPrisonedBy], "System - LWC", 128);
					if(PlayerInfo[playerid][pWantedJailTime] != 0) PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pWantedJailTime]*60; else PlayerInfo[playerid][pJailTime] += 120*60;
					if(PlayerInfo[playerid][pWantedJailFine] != 0) GivePlayerCash(playerid, -PlayerInfo[playerid][pWantedJailFine]);

					new szMessage[80+MAX_PLAYER_NAME];
					format(szMessage, sizeof(szMessage), "{AA3333}GTN-Warning{FFFF00}: %s has left (/q) the server while being cuffed.", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_YELLOW, szMessage, 2);

					format(string, sizeof(string), "%s has left (/q) while cuffed. (ID: %d | SQLID: %D | JT: %d | F: %d | IP: %s)", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pWantedJailTime], PlayerInfo[playerid][pWantedJailFine], PlayerInfo[playerid][pIP]);
					Log("logs/login.log", string);

					PlayerInfo[playerid][pBailPrice] = 15000000;
					PlayerInfo[playerid][pWantedJailFine] = 0;
					PlayerInfo[playerid][pWantedJailTime] = 0;
					PlayerInfo[playerid][pWantedLevel] = 0;
				}
				else if(GetPVarType(playerid, "IsTackled"))
				{
					strcpy(PlayerInfo[playerid][pPrisonReason], "[IC] EBCF ((LWT))", 128);
					strcpy(PlayerInfo[playerid][pPrisonedBy], "System - LWT", 128);
					if(PlayerInfo[playerid][pWantedJailTime] != 0) PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pWantedJailTime]*60; else PlayerInfo[playerid][pJailTime] += 120*60;
					if(PlayerInfo[playerid][pWantedJailFine] != 0) GivePlayerCash(playerid, -PlayerInfo[playerid][pWantedJailFine]);

					format(string, sizeof(string), "%s has left (/q) while tackled. (ID: %d | SQLID: %D | JT: %d | F: %d | IP: %s)", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pWantedJailTime], PlayerInfo[playerid][pWantedJailFine], PlayerInfo[playerid][pIP]);
					Log("logs/login.log", string);

					PlayerInfo[playerid][pBailPrice] = 15000000;
					PlayerInfo[playerid][pWantedJailFine] = 0;
					PlayerInfo[playerid][pWantedJailTime] = 0;
					PlayerInfo[playerid][pWantedLevel] = 0;

					new szMessage[80+MAX_PLAYER_NAME];
					format(szMessage, sizeof(szMessage), "{AA3333}GTN-Warning{FFFF00}: %s has left (/q) the server while being tackled.", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_YELLOW, szMessage, 2);
				}
				if(((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)) && (PlayerInfo[playerid][pAdmin] < 2 || (PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pTogReports])))
				{
					new badge[12], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
					if(strcmp(PlayerInfo[playerid][pBadge], "None", true) != 0) format(badge, sizeof(badge), "[%s] ", PlayerInfo[playerid][pBadge]);
					GetPlayerGroupInfo(playerid, rank, division, employer);
					if(IsACop(playerid))
					{
						if(PlayerInfo[playerid][pDuty])
						{
							format(string, sizeof(string), "** %s%s %s is out of service **", badge, rank, GetPlayerNameEx(playerid));
							foreach(new i: Player)
							{
								if(PlayerInfo[i][pToggledChats][12] == 0)
								{
									if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
						}
						format(string, sizeof string, "%s%s %s has logged out.", badge, rank, GetPlayerNameEx(playerid));
						GroupLog(PlayerInfo[playerid][pMember], string);
					}
					else if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && !IsACop(playerid))
					{
						if(PlayerInfo[playerid][pDuty] || arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_CRIMINAL)
						{
							format(string, sizeof(string), "** %s%s %s is no longer available **", badge, rank, GetPlayerNameEx(playerid));
							foreach(new i: Player)
							{
								if(PlayerInfo[i][pToggledChats][12] == 0)
								{
									if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
						}
						format(string, sizeof string, "%s%s has logged out.", badge, GetPlayerNameEx(playerid));
						GroupLog(PlayerInfo[playerid][pMember], string);
					}
				}
			}
			case 2:
			{
				if(PlayerInfo[playerid][pAdmin] >= 2 && Spectating[playerid] == 1)
				{
					PlayerInfo[playerid][pPos_x] = GetPVarFloat(playerid, "SpecPosX");
					PlayerInfo[playerid][pPos_y] = GetPVarFloat(playerid, "SpecPosY");
					PlayerInfo[playerid][pPos_z] = GetPVarFloat(playerid, "SpecPosZ");
					PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "SpecInt");
					PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "SpecVW");
					DeletePVar(playerid, "SpecOff");
					if(GetPVarType(playerid, "pGodMode"))
					{
						SetHealth(playerid, 0x7FB00000);
						SetArmour(playerid, 0x7FB00000);
					}
					GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
					Spectate[playerid] = INVALID_PLAYER_ID;
				}
				else
				{
					format(string, sizeof(string), "%s da thoat khoi game (kicked/banned).", GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW);
				}
				format(string, sizeof(string), "%s (ID: %d | SQL ID: %d | Level: %d | IP: %s) has been kicked/banned.", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pIP]);
				Log("logs/login.log", string);
			}
			case 3:
			{
				if(PlayerInfo[playerid][pAdmin] < 2 && Spectating[playerid] != 1)
				{
					format(string, sizeof(string), "%s da thoat khoi game (Force Relog).", GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW,COLOR_ORANGEYELLOW);
				}
				format(string, sizeof(string), "%s (ID: %d | SQL ID: %d | Level: %d | IP: %s) has been force relogged", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pIP]);
				Log("logs/login.log", string);
			}
		}
		if(EventKernel[EventRequest] == playerid)
		{
			EventKernel[EventRequest] = INVALID_PLAYER_ID;
			ABroadCast( COLOR_YELLOW, "{AA3333}GTN-Warning{FFFF00}: The player that was requesting an event has disconnected/crashed.", 4 );
		}
		if(EventKernel[EventCreator] == playerid)
		{
			EventKernel[EventCreator] = INVALID_PLAYER_ID;
			ABroadCast( COLOR_YELLOW, "{AA3333}GTN-Warning{FFFF00}: The player that was creating an event has disconnected/crashed.", 4 );
		}
		for(new x; x < sizeof(EventKernel[EventStaff]); x++) {
			if(EventKernel[EventStaff][x] == playerid) {
				EventKernel[EventStaff][x] = INVALID_PLAYER_ID;
				RemovePlayerWeapon(playerid, 38);
				break;
			}
		}
		if(GetPVarType(playerid, "IsInArena")) LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"), 1);
		/*
		if(GetPVarType(playerid, "IsInArena"))
		{
			LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
			PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "pbOldInt");
			PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "pbOldVW");
			PlayerInfo[playerid][pPos_x] = 2012.500366;
			PlayerInfo[playerid][pPos_y] = -1264.768554;
			PlayerInfo[playerid][pPos_z] = 23.547389;
			PlayerInfo[playerid][pHealth] = 100;
			//PlayerInfo[playerid][pArmor] = GetPVarFloat(playerid, "pbOldArmor");
			new szLog[128], Float: realarmor;
			GetArmour(playerid, realarmor);
			format(szLog, sizeof(szLog), "Player %s(%d) disconnects inside paintball with %f.2 armor, but has %f.2.", GetPlayerNameEx(playerid), playerid, PlayerInfo[playerid][pArmor], realarmor);
			Log("logs/debug.log", szLog);
			SetHealth(playerid,GetPVarFloat(playerid, "pbOldHealth"));
			SetArmour(playerid,GetPVarFloat(playerid, "pbOldArmor"));
		}*/
		if(GetPVarInt(playerid, "EventToken") == 0 && !GetPVarType(playerid, "LoadingObjects"))
		{
		    if(IsPlayerInRangeOfPoint(playerid, 1200, -1083.90002441,4289.70019531,7.59999990) && PlayerInfo[playerid][pMember] == INVALID_GROUP_ID)
			{
				PlayerInfo[playerid][pInt] = 0;
				PlayerInfo[playerid][pVW] = 0;
				GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
				PlayerInfo[playerid][pPos_x] = 1529.6;
				PlayerInfo[playerid][pPos_y] = -1691.2;
				PlayerInfo[playerid][pPos_z] = 13.3;
			}
			else
			{
				new Float: x, Float: y, Float: z;
				PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
				PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(playerid);
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
				PlayerInfo[playerid][pPos_x] = x;
				PlayerInfo[playerid][pPos_y] = y;
				PlayerInfo[playerid][pPos_z] = z;
			}
		}
		else
		{
			PlayerInfo[playerid][pInt] = EventLastInt[playerid];
			PlayerInfo[playerid][pVW] = EventLastVW[playerid];
			PlayerInfo[playerid][pPos_r] = EventFloats[playerid][0];
			PlayerInfo[playerid][pPos_x] = EventFloats[playerid][1];
			PlayerInfo[playerid][pPos_y] = EventFloats[playerid][2];
			PlayerInfo[playerid][pPos_z] = EventFloats[playerid][3];
		}
		if(GetPVarInt(playerid, "WatchingTV"))
		{
			PlayerInfo[playerid][pInt] = BroadcastLastInt[playerid];
			PlayerInfo[playerid][pVW] = BroadcastLastVW[playerid];
			PlayerInfo[playerid][pPos_r] = BroadcastFloats[playerid][0];
			PlayerInfo[playerid][pPos_x] = BroadcastFloats[playerid][1];
			PlayerInfo[playerid][pPos_y] = BroadcastFloats[playerid][2];
			PlayerInfo[playerid][pPos_z] = BroadcastFloats[playerid][3];
			DeletePVar(playerid, "WatchingTV");
			viewers--;
		}
		if(gBike[playerid] >= 0 && gBikeRenting[playerid] == 1)
		{
			gBike[playerid] = 0;
			gBikeRenting[playerid] = 0;
			KillTimer(GetPVarInt(playerid, "RentTime"));
		}

		PlayerTextDrawDestroy(playerid, GPS[playerid]);

		if(PlayerInfo[playerid][pAdmin] >= 2) TextDrawDestroy(PriorityReport[playerid]);

		if(InsidePlane[playerid] != INVALID_VEHICLE_ID)
		{
			if(!IsAPlane(InsidePlane[playerid]))
			{
				GivePlayerValidWeapon(playerid, 46);
				PlayerInfo[playerid][pPos_x] = 0.000000;
				PlayerInfo[playerid][pPos_y] = 0.000000;
				PlayerInfo[playerid][pPos_z] = 420.000000;
			}
			else
			{
				new Float:X, Float:Y, Float:Z;
				GetVehiclePos(InsidePlane[playerid], X, Y, Z);
				PlayerInfo[playerid][pPos_x] = X;
				PlayerInfo[playerid][pPos_y] = Y;
				PlayerInfo[playerid][pPos_z] = Z;
				if(Z > 50.0)
				{
					GivePlayerValidWeapon(playerid, 46);
				}
			}
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerInterior(playerid, 0);
			InsidePlane[playerid] = INVALID_VEHICLE_ID;
		}

		if(GetPVarType(playerid, "Injured")) PlayerInfo[playerid][pHospital] = 1;

		OnPlayerStatsUpdate(playerid);
		if(reason == 0)
		{
			new Float:pos[4];
			for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				if(PlayerVehicleInfo[playerid][v][pvId] != INVALID_PLAYER_VEHICLE_ID)
				{
					GetVehiclePos(PlayerVehicleInfo[playerid][v][pvId], pos[0], pos[1], pos[2]);
					GetVehicleZAngle(PlayerVehicleInfo[playerid][v][pvId], pos[3]);
					if(PlayerVehicleInfo[playerid][v][pvPosX] != pos[0])
					{
						PlayerVehicleInfo[playerid][v][pvCrashFlag] = 1;
						PlayerVehicleInfo[playerid][v][pvCrashVW] = GetVehicleVirtualWorld(PlayerVehicleInfo[playerid][v][pvId]);
						PlayerVehicleInfo[playerid][v][pvCrashX] = pos[0];
						PlayerVehicleInfo[playerid][v][pvCrashY] = pos[1];
						PlayerVehicleInfo[playerid][v][pvCrashZ] = pos[2];
						PlayerVehicleInfo[playerid][v][pvCrashAngle] = pos[3];
						GetVehicleHealth(PlayerVehicleInfo[playerid][v][pvId], PlayerVehicleInfo[playerid][v][pvHealth]);
						g_mysql_SaveVehicle(playerid, v);
					}
				}
			}

		}
		UnloadPlayerVehicles(playerid, 1, reason);
		g_mysql_AccountOnline(playerid, 0);
		for(new i = 0; i < MAX_REPORTS; i++)
		{
			if(Reports[i][ReportFrom] == playerid)
			{
				Reports[i][ReportFrom] = INVALID_PLAYER_ID;
				Reports[i][BeingUsed] = 0;
				Reports[i][TimeToExpire] = 0;
        		Reports[i][ReportPriority] = 0;
        		Reports[i][ReportLevel] = 0;
			}
		}
		for(new i = 0; i < MAX_CALLS; i++)
		{
			if(Calls[i][CallFrom] == playerid)
			{
				if(Calls[i][BeingUsed] == 1) DeletePVar(Calls[i][CallFrom], "Has911Call");
				strmid(Calls[i][Area], "None", 0, 4, 4);
				strmid(Calls[i][MainZone], "None", 0, 4, 4);
				strmid(Calls[i][Description], "None", 0, 4, 4);
				Calls[i][RespondingID] = INVALID_PLAYER_ID;
				Calls[i][CallFrom] = INVALID_PLAYER_ID;
				Calls[i][Type] = -1;
				Calls[i][TimeToExpire] = 0;
			}
		}
		foreach(new i: Player)
		{
			if (GetPVarType(i, "hFind") && GetPVarInt(i, "hFind") == playerid)
			{
				SendClientMessageEx(i, COLOR_GREY, "Nguoi choi da thoat khoi game.");
				DeletePVar(i, "hFind");
				DisablePlayerCheckpoint(i);
			}
			if (GetPVarType(i, "Backup") && GetPVarInt(i, "Backup") == playerid)
			{
				SendClientMessageEx(i, COLOR_GREY, "Nguoi yeu cau ho tro da thoat khoi game.");
				DeletePVar(i, "Backup");
			}
			if(TaxiAccepted[i] == playerid)
			{
				TaxiAccepted[i] = INVALID_PLAYER_ID;
				GameTextForPlayer(i, "~w~Taxi Caller~n~~r~thoat game", 5000, 1);
				TaxiCallTime[i] = 0;
				DisablePlayerCheckpoint(i);
			}
			if(EMSAccepted[i] == playerid)
			{
				EMSAccepted[i] = INVALID_PLAYER_ID;
				GameTextForPlayer(i, "~w~EMS Caller~n~~r~thoat game", 5000, 1);
				EMSCallTime[i] = 0;
				DisablePlayerCheckpoint(i);
			}
			if(BusAccepted[i] == playerid)
			{
				BusAccepted[i] = INVALID_PLAYER_ID;
				GameTextForPlayer(i, "~w~Bus Caller~n~~r~thoat game", 5000, 1);
				BusCallTime[i] = 0;
				DisablePlayerCheckpoint(i);
			}
			if(MedicAccepted[i] == playerid)
			{
				TaxiAccepted[playerid] = INVALID_PLAYER_ID; BusAccepted[playerid] = INVALID_PLAYER_ID; MedicAccepted[playerid] = INVALID_PLAYER_ID;
				GameTextForPlayer(i, "~w~Medic Caller~n~~r~thoat game", 5000, 1);
				MedicCallTime[i] = 0;
				DisablePlayerCheckpoint(i);
			}
			if(OrderAssignedTo[i] == playerid)
			{
			   OrderAssignedTo[i] = INVALID_PLAYER_ID;
			}
		}
		if(TransportCost[playerid] > 0 && TransportDriver[playerid] != INVALID_PLAYER_ID)
		{
			if(IsPlayerConnected(TransportDriver[playerid]))
			{
				TransportMoney[TransportDriver[playerid]] += TransportCost[playerid];
				TransportTime[TransportDriver[playerid]] = 0;
				TransportCost[TransportDriver[playerid]] = 0;
				format(string, sizeof(string), "~w~Passenger left~n~~g~Earned $%d",TransportCost[playerid]);
				GameTextForPlayer(TransportDriver[playerid], string, 5000, 1);
				GivePlayerCashEx(playerid, TYPE_ONHAND, -TransportCost[playerid]);
				TransportDriver[playerid] = INVALID_PLAYER_ID;
			}
		}
		if(GotHit[playerid] > 0)
		{
			if(GetChased[playerid] != INVALID_PLAYER_ID)
			{
				if(IsPlayerConnected(GetChased[playerid]))
				{
					SendClientMessageEx(GetChased[playerid], COLOR_YELLOW, "Muc tieu cua ban da thoat game.");
					GoChase[GetChased[playerid]] = INVALID_PLAYER_ID;
				}
			}
		}
		if(GoChase[playerid] != INVALID_PLAYER_ID)
		{
		  GetChased[GoChase[playerid]] = INVALID_PLAYER_ID;
		  GotHit[GoChase[playerid]] = INVALID_PLAYER_ID;
		}
		if(HireCar[playerid] != 299)
		{
			vehicle_unlock_doors(HireCar[playerid]);
		}
		if (gLastCar[playerid] > 0)
		{
			if(PlayerInfo[playerid][pPhousekey] != gLastCar[playerid]-1)
			{
				vehicle_unlock_doors(gLastCar[playerid]);
			}
		}
		if(PlayerBoxing[playerid] > 0)
		{
			if(Boxer1 == playerid)
			{
				if(IsPlayerConnected(Boxer2))
				{
					if(IsPlayerInRangeOfPoint(PlayerBoxing[Boxer2], 20.0, 768.94, -70.87, 1001.56))
					{
						PlayerBoxing[Boxer2] = 0;
						SetPlayerPos(Boxer2, 768.48, -73.66, 1000.57);
						SetPlayerInterior(Boxer2, 7);
						GameTextForPlayer(Boxer2, "~r~Match interupted", 5000, 1);
					}
					PlayerBoxing[Boxer2] = 0;
					SetPlayerPos(Boxer2, 765.8433,3.2924,1000.7186);
					SetPlayerInterior(Boxer2, 5);
					GameTextForPlayer(Boxer2, "~r~Match interupted", 5000, 1);
				}
			}
			else if(Boxer2 == playerid)
			{
				if(IsPlayerConnected(Boxer1))
				{
					if(IsPlayerInRangeOfPoint(PlayerBoxing[Boxer1],20.0,764.35, -66.48, 1001.56))
					{
						PlayerBoxing[Boxer1] = 0;
						SetPlayerPos(Boxer1, 768.48, -73.66, 1000.57);
						SetPlayerInterior(Boxer1, 7);
						GameTextForPlayer(Boxer1, "~r~Match interupted", 5000, 1);
					}
					PlayerBoxing[Boxer1] = 0;
					SetPlayerPos(Boxer1, 765.8433,3.2924,1000.7186);
					SetPlayerInterior(Boxer1, 5);
					GameTextForPlayer(Boxer1, "~r~Match interupted", 5000, 1);
				}
			}
			InRing = 0;
			RoundStarted = 0;
			Boxer1 = INVALID_PLAYER_ID;
			Boxer2 = INVALID_PLAYER_ID;
			TBoxer = INVALID_PLAYER_ID;
		}
		if(GetPVarInt(playerid, "AdvisorDuty") == 1)
		{
			Advisors--;
		}
		if(TransportDuty[playerid] == 1)
		{
			TaxiDrivers -= 1;
		}
		else if(TransportDuty[playerid] == 2)
		{
			BusDrivers -= 1;
		}
		if(PlayerInfo[playerid][pJob] == 11 || PlayerInfo[playerid][pJob2] == 11 || PlayerInfo[playerid][pJob3] == 11)
		{
			if(JobDuty[playerid] == 1) { Medics -= 1; }
		}
		if(PlayerInfo[playerid][pJob] == 7 || PlayerInfo[playerid][pJob2] == 7 || PlayerInfo[playerid][pJob3] == 7)
		{
			if(GetPVarInt(playerid, "MechanicDuty") == 1) { Mechanics -= 1; }
		}
		if(PlayerInfo[playerid][pJob] == 11 || PlayerInfo[playerid][pJob2] == 11 || PlayerInfo[playerid][pJob3] == 11)
		{
			if(JobDuty[playerid] == 1) { Coastguard -= 1; }
		}
		new Float:health, Float:armor;
		if(GetPVarType(playerid, "pGodMode") == 1)
		{
			health = GetPVarFloat(playerid, "pPreGodHealth");
			SetHealth(playerid,health);
			armor = GetPVarFloat(playerid, "pPreGodArmor");
			SetArmour(playerid, armor);
			DeletePVar(playerid, "pGodMode");
			DeletePVar(playerid, "pPreGodHealth");
			DeletePVar(playerid, "pPreGodArmor");
		}
		if(GetPVarInt(playerid, "ttSeller") >= 0)
		{
			DeletePVar(playerid, "ttSeller");
			HideTradeToysGUI(playerid);
		}
		if(IsValidDynamic3DTextLabel(RFLTeamN3D[playerid])) {
			DestroyDynamic3DTextLabel(RFLTeamN3D[playerid]);
			RFLTeamN3D[playerid] = Text3D:-1;
		}
		pSpeed[playerid] = 0.0;
		SetPVarInt(playerid, "PlayerOwnASurf", 0);
	}
	PlayerInfo[playerid][pWarrant][0] = 0;
	DeletePVar(playerid, "pTmpEmail");
	DeletePVar(playerid, "NullEmail");
	DeletePVar(playerid, "ViewedPMOTD");
	DeletePVar(playerid, "WatchdogChat");
	DeletePVar(playerid, "vStaffChat");
	DeletePVar(playerid, "SECChat");
	DeletePVar(playerid, "aLvl");
	DeletePVar(playerid, "hLvl");
	DeletePVar(playerid, "fLvl");
	DeletePVar(playerid, "gLvl");
	DeletePVar(playerid, "Autoban");
	DeletePVar(playerid, "ticketreason");
	gPlayerLogged{playerid} = 0;
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	if(success)
	{
		new pip[16];
		szMiscArray[0] = 0;
		foreach(new i : Player)
		{
			GetPlayerIp(i, pip, sizeof(pip));
			if(!strcmp(ip, pip, true))
			{
				if(PlayerInfo[i][pAdmin] < 1337)
				{
					CreateBan(INVALID_PLAYER_ID, PlayerInfo[i][pId], i, PlayerInfo[i][pIP], "Successful RCON Login - Not Head Admin", 9999);

					format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s(%s) has successfully logged into RCON without being a Head Admin, and has been perma-banned.", GetPlayerNameEx(i), ip);
					ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				}
			}
		}
	}
    if(!success)
    {
        new pip[16];
        foreach(new i : Player)
		{
			GetPlayerIp(i, pip, sizeof(pip));
			if(!strcmp(ip, pip, true))
			{
				new logins = GetPVarInt(i, "RconFailedLogin")+1;
				SetPVarInt(i, "RconFailedLogin", logins);
				if(GetPVarInt(i, "RconFailedLogin") >= 3)
				{
					CreateBan(INVALID_PLAYER_ID, PlayerInfo[i][pId], i, PlayerInfo[i][pIP], "Excessive RCON Login Attempts", 365);
				}
			}
		}
    }
    return 1;
}

public OnVehicleDeath(vehicleid) {
	new Float:X, Float:Y, Float:Z;
	new Float:XB, Float:YB, Float:ZB;
	VehicleStatus{vehicleid} = 1;
	TruckContents{vehicleid} = 0;
	foreach(new i: Player)
	{
		if(TruckUsed[i] == vehicleid)
		{
			DeletePVar(i, "LoadTruckTime");
			DeletePVar(i, "TruckDeliver");
			TruckUsed[i] = INVALID_VEHICLE_ID;
			gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
			DisablePlayerCheckpoint(i);
		}
		if(InsidePlane[i] == vehicleid)
		{
			TogglePlayerSpectating(i, 0);
			GetVehiclePos(InsidePlane[i], X, Y, Z);
			SetPlayerPos(i, X-4, Y-2.3, Z);
			GetVehiclePos(InsidePlane[i], XB, YB, ZB);
			if(ZB > 50.0)
			{
				PlayerInfo[i][pAGuns][GetWeaponSlot(46)] = 46;
				GivePlayerValidWeapon(i, 46);
			}
			PlayerInfo[i][pVW] = 0;
			SetPlayerVirtualWorld(i, 0);
			PlayerInfo[i][pInt] = 0;
			SetPlayerInterior(i, 0);
			InsidePlane[i] = INVALID_VEHICLE_ID;
			SendClientMessageEx(i, COLOR_WHITE, "May bay da bi hong, ban khong the o trong do !");
		}
		if(GetPVarInt(i, "NGPassengerVeh") == vehicleid)
		{
			TogglePlayerSpectating(i, 0);
		}
	}
	/*if(DynVeh[vehicleid] != -1)
	{
		DynVeh_Spawn(DynVeh[vehicleid]);
	}*/
	arr_Engine{vehicleid} = 0;
}

public OnPlayerSpawn(playerid)
{
	TextDrawHideForPlayer(playerid, TDE_LOGINGTN[0]);
	TextDrawHideForPlayer(playerid, TDE_LOGINGTN[1]);
    if(IsPlayerNPC(playerid)) return 1;

    if(!gPlayerLogged{playerid})
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Ban chua dang nhap!");
        SetTimerEx("KickEx", 1000, 0, "i", playerid);
        return 1;
	}

	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
	PlayerIsDead[playerid] = false;
	hideChuyenTien{playerid} = false;
	if(!gPlayerAnimLibsPreloaded[playerid])
	{
	    PreloadAnimLib(playerid,"AIRPORT");
		PreloadAnimLib(playerid,"Attractors");
		PreloadAnimLib(playerid,"BAR");
		PreloadAnimLib(playerid,"BASEBALL");
		PreloadAnimLib(playerid,"BD_FIRE");
		PreloadAnimLib(playerid,"benchpress");
        PreloadAnimLib(playerid,"BF_injection");
        PreloadAnimLib(playerid,"BIKED");
        PreloadAnimLib(playerid,"BIKEH");
        PreloadAnimLib(playerid,"BIKELEAP");
        PreloadAnimLib(playerid,"BIKES");
        PreloadAnimLib(playerid,"BIKEV");
        PreloadAnimLib(playerid,"BIKE_DBZ");
        PreloadAnimLib(playerid,"BMX");
        PreloadAnimLib(playerid,"BOX");
        PreloadAnimLib(playerid,"BSKTBALL");
        PreloadAnimLib(playerid,"BUDDY");
        PreloadAnimLib(playerid,"BUS");
        PreloadAnimLib(playerid,"CAMERA");
        PreloadAnimLib(playerid,"CAR");
        PreloadAnimLib(playerid,"CAR_CHAT");
        PreloadAnimLib(playerid,"CASINO");
        PreloadAnimLib(playerid,"CHAINSAW");
        PreloadAnimLib(playerid,"CHOPPA");
        PreloadAnimLib(playerid,"CLOTHES");
        PreloadAnimLib(playerid,"COACH");
        PreloadAnimLib(playerid,"COLT45");
        PreloadAnimLib(playerid,"COP_DVBYZ");
        PreloadAnimLib(playerid,"CRIB");
        PreloadAnimLib(playerid,"DAM_JUMP");
        PreloadAnimLib(playerid,"DANCING");
        PreloadAnimLib(playerid,"DILDO");
        PreloadAnimLib(playerid,"DODGE");
        PreloadAnimLib(playerid,"DOZER");
        PreloadAnimLib(playerid,"DRIVEBYS");
        PreloadAnimLib(playerid,"FAT");
        PreloadAnimLib(playerid,"FIGHT_B");
        PreloadAnimLib(playerid,"FIGHT_C");
        PreloadAnimLib(playerid,"FIGHT_D");
        PreloadAnimLib(playerid,"FIGHT_E");
        PreloadAnimLib(playerid,"FINALE");
        PreloadAnimLib(playerid,"FINALE2");
        PreloadAnimLib(playerid,"Flowers");
        PreloadAnimLib(playerid,"FOOD");
        PreloadAnimLib(playerid,"Freeweights");
        PreloadAnimLib(playerid,"GANGS");
        PreloadAnimLib(playerid,"GHANDS");
        PreloadAnimLib(playerid,"GHETTO_DB");
        PreloadAnimLib(playerid,"goggles");
        PreloadAnimLib(playerid,"GRAFFITI");
        PreloadAnimLib(playerid,"GRAVEYARD");
        PreloadAnimLib(playerid,"GRENADE");
        PreloadAnimLib(playerid,"GYMNASIUM");
        PreloadAnimLib(playerid,"HAIRCUTS");
        PreloadAnimLib(playerid,"HEIST9");
        PreloadAnimLib(playerid,"INT_HOUSE");
        PreloadAnimLib(playerid,"INT_OFFICE");
        PreloadAnimLib(playerid,"INT_SHOP");
        PreloadAnimLib(playerid,"JST_BUISNESS");
        PreloadAnimLib(playerid,"KART");
        PreloadAnimLib(playerid,"KISSING");
        PreloadAnimLib(playerid,"KNIFE");
        PreloadAnimLib(playerid,"LAPDAN1");
        PreloadAnimLib(playerid,"LAPDAN2");
        PreloadAnimLib(playerid,"LAPDAN3");
        PreloadAnimLib(playerid,"LOWRIDER");
        PreloadAnimLib(playerid,"MD_CHASE");
        PreloadAnimLib(playerid,"MEDIC");
        PreloadAnimLib(playerid,"MD_END");
        PreloadAnimLib(playerid,"MISC");
        PreloadAnimLib(playerid,"MTB");
        PreloadAnimLib(playerid,"MUSCULAR");
        PreloadAnimLib(playerid,"NEVADA");
        PreloadAnimLib(playerid,"ON_LOOKERS");
        PreloadAnimLib(playerid,"OTB");
        PreloadAnimLib(playerid,"PARACHUTE");
        PreloadAnimLib(playerid,"PARK");
        PreloadAnimLib(playerid,"PAULNMAC");
        PreloadAnimLib(playerid,"PED");
        PreloadAnimLib(playerid,"PLAYER_DVBYS");
        PreloadAnimLib(playerid,"PLAYIDLES");
        PreloadAnimLib(playerid,"POLICE");
        PreloadAnimLib(playerid,"POOL");
        PreloadAnimLib(playerid,"POOR");
        PreloadAnimLib(playerid,"PYTHON");
        PreloadAnimLib(playerid,"QUAD");
        PreloadAnimLib(playerid,"QUAD_DBZ");
        PreloadAnimLib(playerid,"RIFLE");
        PreloadAnimLib(playerid,"RIOT");
        PreloadAnimLib(playerid,"ROB_BANK");
        PreloadAnimLib(playerid,"ROCKET");
        PreloadAnimLib(playerid,"RUSTLER");
        PreloadAnimLib(playerid,"RYDER");
        PreloadAnimLib(playerid,"SCRATCHING");
        PreloadAnimLib(playerid,"SHAMAL");
        PreloadAnimLib(playerid,"SHOTGUN");
        PreloadAnimLib(playerid,"SILENCED");
        PreloadAnimLib(playerid,"SKATE");
        PreloadAnimLib(playerid,"SPRAYCAN");
        PreloadAnimLib(playerid,"STRIP");
        PreloadAnimLib(playerid,"SUNBATHE");
        PreloadAnimLib(playerid,"SWAT");
        PreloadAnimLib(playerid,"SWEET");
        PreloadAnimLib(playerid,"SWIM");
        PreloadAnimLib(playerid,"SWORD");
        PreloadAnimLib(playerid,"TANK");
        PreloadAnimLib(playerid,"TATTOOS");
        PreloadAnimLib(playerid,"TEC");
        PreloadAnimLib(playerid,"TRAIN");
        PreloadAnimLib(playerid,"TRUCK");
        PreloadAnimLib(playerid,"UZI");
        PreloadAnimLib(playerid,"VAN");
        PreloadAnimLib(playerid,"VENDING");
        PreloadAnimLib(playerid,"VORTEX");
        PreloadAnimLib(playerid,"WAYFARER");
        PreloadAnimLib(playerid,"WEAPONS");
        PreloadAnimLib(playerid,"WUZI");
        PreloadAnimLib(playerid,"SNM");
        PreloadAnimLib(playerid,"BLOWJOBZ");
        PreloadAnimLib(playerid,"SEX");
   		PreloadAnimLib(playerid,"BOMBER");
   		PreloadAnimLib(playerid,"RAPPING");
    	PreloadAnimLib(playerid,"SHOP");
   		PreloadAnimLib(playerid,"BEACH");
   		PreloadAnimLib(playerid,"SMOKING");
    	PreloadAnimLib(playerid,"FOOD");
    	PreloadAnimLib(playerid,"ON_LOOKERS");
    	PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"FOOD");
		gPlayerAnimLibsPreloaded[playerid] = 1;
	}
 	if(sobeitCheckvar[playerid] == 0)
	{
	    if(PlayerInfo[playerid][pInt] == 0 && PlayerInfo[playerid][pVW] == 0)
	    {
			if(sobeitCheckIsDone[playerid] == 0)
			{
			    if(PlayerInfo[playerid][pAdmin] < 2)
			    {
			        if(PlayerInfo[playerid][pHospital] == 0)
			        {
					    sobeitCheckIsDone[playerid] = 1;
					    SetTimerEx("sobeitCheck", 10000, 0, "i", playerid);
						TogglePlayerControllable(playerid, false);
					}
				}
			}
  		}
	}
	SetPVarInt(playerid, "AntiTPCheck", gettime()+5);
	if(GetPVarType(playerid, "WatchingTV")) return 1;
	if(GetPVarInt(playerid, "NGPassenger") == 1)
	{
	    new Float:X, Float:Y, Float:Z;
	    GetVehiclePos(GetPVarInt(playerid, "NGPassengerVeh"), X, Y, Z);
	    SetPlayerPos(playerid, (X-2.557), (Y-3.049), Z);
	    SetPlayerWeaponsEx(playerid);
        GivePlayerValidWeapon(playerid, 46);
        SetPlayerSkin(playerid, GetPVarInt(playerid, "NGPassengerSkin"));
        SetHealth(playerid, GetPVarFloat(playerid, "NGPassengerHP"));
        if(GetPVarFloat(playerid, "NGPassengerArmor") > 0) {
        	SetArmour(playerid, GetPVarFloat(playerid, "NGPassengerArmor"));
        }
		DeletePVar(playerid, "NGPassenger");
	    DeletePVar(playerid, "NGPassengerVeh");
		DeletePVar(playerid, "NGPassengerArmor");
		DeletePVar(playerid, "NGPassengerHP");
		DeletePVar(playerid, "NGPassengerSkin");
	    return 1;
	}
	if(InsidePlane[playerid] != INVALID_VEHICLE_ID)
	{
		SetPlayerPos(playerid, GetPVarFloat(playerid, "air_Xpos"), GetPVarFloat(playerid, "air_Ypos"), GetPVarFloat(playerid, "air_Zpos"));
		SetPlayerFacingAngle(playerid, GetPVarFloat(playerid, "air_Rpos"));
		SetHealth(playerid, GetPVarFloat(playerid, "air_HP"));
		if(GetPVarFloat(playerid, "air_Arm") > 0) {
			SetArmour(playerid, GetPVarFloat(playerid, "air_Arm"));
		}
		SetPlayerWeaponsEx(playerid);
		SetPlayerToTeamColor(playerid);
        SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		SetPlayerInterior(playerid, GetPVarInt(playerid, "air_Int"));

		DeletePVar(playerid, "air_Xpos");
		DeletePVar(playerid, "air_Ypos");
		DeletePVar(playerid, "air_Zpos");
		DeletePVar(playerid, "air_Rpos");
		DeletePVar(playerid, "air_HP");
		DeletePVar(playerid, "air_Arm");
		DeletePVar(playerid, "air_Mode");
		DeletePVar(playerid, "air_Int");

		SetCameraBehindPlayer(playerid);
		SetPlayerVirtualWorld(playerid, InsidePlane[playerid]);
		return 1;
	}
	SyncPlayerTime(playerid);

	if(GetPVarType(playerid, "STD")) {
		DeletePVar(playerid, "STD");
	}

	SetTeam(playerid, NO_TEAM);
	SetPlayerSpawn(playerid);
	SetPlayerWeapons(playerid);
	SetPlayerToTeamColor(playerid);
	IsSpawned[playerid] = 1;
	SpawnKick[playerid] = 0;
	SetPlayerArmedWeapon(playerid, 0); // making sure players spawn with their fists.
	if(PlayerInfo[playerid][pTut] != -1)
	{
		if(PlayerInfo[playerid][pTut] < 14) PlayerInfo[playerid][pTut] = 0;
		AdvanceTutorial(playerid);
	}

	if(PlayerInfo[playerid][pTut] == -1 && PlayerInfo[playerid][pNation] != 0 && PlayerInfo[playerid][pNation] != 1) ShowPlayerDialogEx(playerid, DIALOG_NATION_CHECK, DIALOG_STYLE_LIST, "Please chose a nation.", "San Andreas\nNew Robada", "Select", "<<");
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "EventToken") == 1 && GetPVarInt(playerid, "InWaterStationRCP") == 1)
	{
	    KillTimer(GetPVarInt(playerid, "WSRCPTimerId"));
	    SetPVarInt(playerid, "WSRCPTimerId", 0);
     	SetPVarInt(playerid, "InWaterStationRCP", 0);
     	RCPIdCurrent[playerid]++;
		if(EventRCPT[RCPIdCurrent[playerid]] == 1) {
	        DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
		}
		else if(EventRCPT[RCPIdCurrent[playerid]] == 4) {
		    DisablePlayerCheckpoint(playerid);
		    SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
		} else {
		    DisablePlayerCheckpoint(playerid);
		    SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban da thoat khoi tram kiem soat , ban se khong bi mat nuoc nua.");
		return 1;
	}
    if(GetPVarType(playerid,"IsInArena"))
	{
	    new arenaid = GetPVarInt(playerid, "IsInArena");
	    if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5)
	    {
	        //SendAudioToPlayer(playerid, 24, 100);
	    }
	    return 1;
	}
	if(PlayerInfo[playerid][pTut] != -1)
	{
		if(PlayerInfo[playerid][pTut] < 14) PlayerInfo[playerid][pTut] = 0;
		AdvanceTutorial(playerid);
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "EventToken") == 1)
	{
	    if(EventKernel[EventFootRace] == 1 && IsPlayerInAnyVehicle(playerid))
	    {
			return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the o trong xe va tham gia su kien ngay luc nay.");
	    }
	    if(EventRCPT[RCPIdCurrent[playerid]] == 3 && PlayerInfo[playerid][pHydration] < 60) {
		    SendClientMessageEx(playerid, COLOR_WHITE, "Ban da vao tram kiem soat watering station, ban can o lai day de duoc bu nuoc lan nua.");
		    SendClientMessageEx(playerid, COLOR_WHITE, "Ban co the roi di bat cu luc nao hoac doi cho den khi ban nhan duoc thong bao bu nuoc day du.");
            SetPVarInt(playerid, "WSRCPTimerId", SetTimerEx("WateringStation", 4000, 1, "i", playerid));
            SetPVarInt(playerid, "InWaterStationRCP", 1);
            return 1;
		}
	    else if(EventRCPT[RCPIdCurrent[playerid]] == 4) {
			RCPIdCurrent[playerid] = 0;
			PlayerInfo[playerid][pHydration] -= 4;
			PlayerInfo[playerid][pRacePlayerLaps]++;
			if(PlayerInfo[playerid][pRacePlayerLaps] % 10 == 0) {
			    GiftPlayer(MAX_PLAYERS, playerid);
			}
			else if(PlayerInfo[playerid][pRacePlayerLaps] == 25) {
			    PlayerInfo[playerid][pEXPToken]++;
			    SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da nhan duoc EXP Double token vi hoan thanh 25 vong");
			}
			if(toglapcount == 0 && rflstatus > 0) {
				RaceTotalLaps++;
				Misc_Save();
				new query[128];
				if(PlayerInfo[playerid][pRFLTeam] != -1) {
					RFLInfo[PlayerInfo[playerid][pRFLTeam]][RFLlaps] +=1;
					mysql_format(MainPipeline, query, sizeof(query), "UPDATE `rflteams` SET `laps` = %d WHERE `id` = %d;",
					RFLInfo[PlayerInfo[playerid][pRFLTeam]][RFLlaps],
					RFLInfo[PlayerInfo[playerid][pRFLTeam]][RFLsqlid]);
					mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
				}
				mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `RacePlayerLaps` = %d WHERE `id` = %d;", PlayerInfo[playerid][pRacePlayerLaps], GetPlayerSQLId(playerid));
				mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			new string[128];
			if(PlayerInfo[playerid][pRFLTeam] != -1) {
				format(string, sizeof(string), "Lap successfully completed. Laps Completed: %d | Team Laps Completed: %d | Total Laps Completed: %d", PlayerInfo[playerid][pRacePlayerLaps], RFLInfo[PlayerInfo[playerid][pRFLTeam]][RFLlaps], RaceTotalLaps);
			}
			else {
				format(string, sizeof(string), "Lap successfully completed. Laps Completed: %d | Total Laps Completed: %d", PlayerInfo[playerid][pRacePlayerLaps], RaceTotalLaps);
			}
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	    else
		{
	    	RCPIdCurrent[playerid]++;
            PlayerInfo[playerid][pHydration] -= 4;
		}
		new string[128];
        if(PlayerInfo[playerid][pHydration] > 60)
        {
			format(string, sizeof(string), "Hydration level normal(%d)", PlayerInfo[playerid][pHydration]);
			SendClientMessageEx(playerid, COLOR_GREEN, string);
		}
		else if(PlayerInfo[playerid][pHydration] < 61 && PlayerInfo[playerid][pHydration] > 30)
		{
		    format(string, sizeof(string), "Hydration level low(%d)", PlayerInfo[playerid][pHydration]);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
		else if(PlayerInfo[playerid][pHydration] < 31 && PlayerInfo[playerid][pHydration] > 0)
		{
		    format(string, sizeof(string), "Hydration level very low(%d)", PlayerInfo[playerid][pHydration]);
			SendClientMessageEx(playerid, COLOR_RED, string);
		}
		else if(PlayerInfo[playerid][pHydration] < 0)
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "Ban da nga xuong dat do mat nuoc,FDSA se giai cuu ban va dua ban den tram so cuu.");
            DeletePVar(playerid, "EventToken");
			DisablePlayerCheckpoint(playerid);
			PlayerInfo[playerid][pHydration] = 100;
			if(IsValidDynamic3DTextLabel(RFLTeamN3D[playerid])) {
				DestroyDynamic3DTextLabel(RFLTeamN3D[playerid]);
				RFLTeamN3D[playerid] = Text3D:-1;
			}
			SetHealth(playerid, 0);
			return 1;
		}
	    if(EventRCPT[RCPIdCurrent[playerid]] == 1) {
	        DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
		}
		else if(EventRCPT[RCPIdCurrent[playerid]] == 4) {
		    DisablePlayerCheckpoint(playerid);
		    SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
		} else {
		    DisablePlayerCheckpoint(playerid);
		    SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
		}
		return 1;
	}
	if(GetPVarType(playerid,"IsInArena"))
	{
	    new arenaid = GetPVarInt(playerid, "IsInArena");
	    if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5)
	    {
	        //SendAudioToPlayer(playerid, 23, 100);
	    }
	    return 1;
	}
	if(GetPVarInt(playerid, "ShopCheckpoint") != 0)
	{
	    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	    DisablePlayerCheckpoint(playerid);
		DeletePVar(playerid, "ShopCheckpoint");
		return 1;
	}
	if(GetPVarInt(playerid,"TrackCar") != 0)
	{
	    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	    DisablePlayerCheckpoint(playerid);
		DeletePVar(playerid, "TrackCar");
		return 1;
	}
	if(GetPVarType(playerid,"DeliveringVehicleTime"))
	{
		if(!IsPlayerInVehicle(playerid, GetPVarInt(playerid, "LockPickVehicle")))
			return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can phai o trong chiec xe ban dang giao!");
		new szMessage[140];
		new RandAmount;
		switch(PlayerInfo[playerid][pCarLockPickSkill]) {
			case 0 .. 49: RandAmount = Random(10000, 13000);
			case 50 .. 124: RandAmount = Random(13000, 16000);
			case 125 .. 224: RandAmount = Random(16000, 24000);
			case 225 .. 349: RandAmount = Random(24000, 27000);
			default: RandAmount = Random(27000, 33000);
		}
		if(!Bank_TransferCheck(RandAmount)) return 1;
		PlayerInfo[playerid][pAccount] += RandAmount;
		format(szMessage, sizeof(szMessage), "SMS: Cam on ban da cung cap mot %s(%d) phan thuong cua ban la $%s, tien se duoc chuyen den tai khoan cua ban, sender: Unknown", GetVehicleName(GetPVarInt(playerid, "LockPickVehicle")), GetPVarInt(playerid, "LockPickVehicle"), number_format(RandAmount));
		SendClientMessageEx(playerid, COLOR_YELLOW, szMessage);
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
		new ip[MAX_PLAYER_NAME], ip2[MAX_PLAYER_NAME];
		GetPlayerIp(playerid, ip, sizeof(ip));
		if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
			mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d' AND `sqlID` = '%d'", VehicleFuel[GetPVarInt(playerid, "LockPickVehicle")], GetPVarInt(playerid, "LockPickVehicleSQLId"), GetPVarInt(playerid, "LockPickPlayerSQLId"));
			mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			GetPVarString(playerid, "LockPickPlayerName", ip2, sizeof(ip2));
			format(szMessage, sizeof(szMessage), "[LOCK PICK] %s(%d) (IP:%s) delivered a %s(VID:%d SQLId:%d) owned by %s(Offline SQLId %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetVehicleName(GetPVarInt(playerid, "LockPickVehicle")), GetPVarInt(playerid, "LockPickVehicle"), GetPVarInt(playerid, "LockPickVehicleSQLId"), ip2, GetPVarInt(playerid, "LockPickPlayerSQLId"));
			Log("logs/playervehicle.log", szMessage);
			DeletePVar(playerid, "LockPickVehicleSQLId");
			DeletePVar(playerid, "LockPickPlayerSQLId");
			DeletePVar(playerid, "LockPickPlayerName");
		}
		else {
			new ownerid = GetPVarInt(playerid, "LockPickPlayer"), slot = GetPlayerVehicle(GetPVarInt(playerid, "LockPickPlayer"), GetPVarInt(playerid, "LockPickVehicle"));
			GetPlayerIp(ownerid, ip2, sizeof(ip2));
			format(szMessage, sizeof(szMessage), "[LOCK PICK] %s(%d) (IP:%s) delivered a %s(VID:%d Slot %d) owned by %s(IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetVehicleName(PlayerVehicleInfo[ownerid][slot][pvId]), PlayerVehicleInfo[ownerid][slot][pvId], slot, GetPlayerNameEx(ownerid), ip2);
			Log("logs/playervehicle.log", szMessage);
			--PlayerCars;
			VehicleSpawned[ownerid]--;
			PlayerVehicleInfo[ownerid][slot][pvAlarmTriggered] = 0;
			PlayerVehicleInfo[ownerid][slot][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[ownerid][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
			PlayerVehicleInfo[ownerid][slot][pvSpawned] = 0;
			GetVehicleHealth(PlayerVehicleInfo[ownerid][slot][pvId], PlayerVehicleInfo[ownerid][slot][pvHealth]);
			PlayerVehicleInfo[ownerid][slot][pvId] = INVALID_PLAYER_VEHICLE_ID;
			PlayerVehicleInfo[ownerid][slot][pvFuel] = VehicleFuel[GetPVarInt(playerid, "LockPickVehicle")];
			g_mysql_SaveVehicle(ownerid, slot);
		}

		DestroyVehicle(GetPVarInt(playerid, "LockPickVehicle"));
	    DisablePlayerCheckpoint(playerid);
		DeletePVar(playerid, "DeliveringVehicleTime");
		DeletePVar(playerid, "LockPickVehicle");
		DeletePVar(playerid, "LockPickPlayer");
		return 1;
	}
	if(GetPVarInt(playerid,"DV_TrackCar") != 0)
	{
	    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	    DisablePlayerCheckpoint(playerid);
		DeletePVar(playerid, "DV_TrackCar");
		return 1;
	}
	if(GetPVarInt(playerid,"bpanic") != 0)
	{
	    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	    DisablePlayerCheckpoint(playerid);
		DeletePVar(playerid, "bpanic");
		return 1;
	}
	if(GetPVarInt(playerid,"igps") != 0)
	{
	    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	    DisablePlayerCheckpoint(playerid);
		DeletePVar(playerid, "igps");
		return 1;
	}
	if(GetPVarInt(playerid, "GiftBoxCP") == 1)
	{
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	    DisablePlayerCheckpoint(playerid);
		DeletePVar(playerid, "GiftBoxCP");
		return true;
	}
	// Dynamic Points System
	if((0 <= MatDeliver[playerid] < MAX_POINTS)) {
		new string[128], drugname[8];
		if(IsPlayerInRangeOfPoint(playerid, 6.0, DynPoints[MatDeliver[playerid]][poPos2][0], DynPoints[MatDeliver[playerid]][poPos2][1], DynPoints[MatDeliver[playerid]][poPos2][2])) {
			switch(DynPoints[MatDeliver[playerid]][poType])
			{
				case 1: drugname = "Pot";
				case 2: drugname = "Crack";
				case 3: drugname = "Meth";
				case 4: drugname = "Ecstasy";
			}
			if(DynPoints[MatDeliver[playerid]][poBoat] && !IsABoat(GetPlayerVehicleID(playerid))) {
				GameTextForPlayer(playerid, "~r~Ban khong o tren thuyen!", 3000, 1);
				return 1;
			}
			if(DynPoints[MatDeliver[playerid]][poType] == 0) { // Materials
				SendClientMessageEx(playerid, COLOR_WHITE, "Nha may da dua cho ban %s vat lieu cho chuyen nay.", number_format(MatsAmount[playerid]));
				TransferStorage(playerid, -1, -1, -1, 4, MatsAmount[playerid], -1, 2);
				/*if(GetPVarInt(playerid, "CheckCPVL") < gettime())
					{
						new stringr[128];
						new rbNumberVL = Random(100000, 999999);
						SetPVarInt(playerid, "VatLieuNumber", rbNumberVL);

						format(stringr, sizeof(string), "{FFFFFF}Vui long nhap so {FF0000}%d {FFFFFF}de tiep tuc lay vat lieu" , rbNumberVL);
						ShowPlayerDialog(playerid, DIALOG_ATVATLIEU, DIALOG_STYLE_INPUT, "Anti Treo", stringr, "Oke","Thoat");
			  		}
		    	else
				Kick(playerid);
				*/
			}
			if((1 <= DynPoints[MatDeliver[playerid]][poType] < 5)) {
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban da giao cac goi thuoc phien va nhan duoc %s gram %s", number_format(MatsAmount[playerid]), drugname);
				PlayerInfo[playerid][pDrugs][DynPoints[MatDeliver[playerid]][poType]-1] += MatsAmount[playerid];
				IncreaseSmugglerLevel(playerid);
			}
			if(GetPVarInt(playerid, "tpMatRunTimer") != 0)
		    {
		    	format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) was auto-kicked, reason: teleport material/drug runs.", GetPlayerNameEx(playerid), playerid);
		    	ABroadCast(COLOR_YELLOW, string, 2);
                Kick(playerid);
			}
			MatDeliver[playerid] = -1;
			MatsAmount[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
		}
	}
	if(GetPVarInt(playerid, "TruckDeliver") > 0 && gPlayerCheckpointStatus[playerid] != CHECKPOINT_RETURNTRUCK)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    {
	        SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong o trong xe tai!");
	        return 1;
	    }
	    if(TruckUsed[playerid] != INVALID_VEHICLE_ID && vehicleid != TruckUsed[playerid])
	    {
	        SendClientMessageEx(playerid, COLOR_WHITE, "Day khong phai xe tai cua ban voi hang hoa ban dang giao!");
	        return 1;
	    }

		if(!IsAtTruckDeliveryPoint(playerid))
 		{// In the case the player finds a way to exploit the checkpoint to different location
			CancelTruckDelivery(playerid);
			SendClientMessageEx(playerid, COLOR_REALRED, "ERROR: Wrong checkpoint entered. Truck delivery canceled completely.");
			return 1;
   		}

		if(GetPVarInt(playerid, "tpTruckRunTimer") != 0)
		{
  			new string[128];
			format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) is possibly teleport truck/boat running.", GetPlayerNameEx(playerid), playerid);
  			ABroadCast( COLOR_YELLOW, string, 2 );
    		// format(string, sizeof(string), "%s (ID %d) is possibly teleport truckrunning.", GetPlayerNameEx(playerid), playerid);
	    	// Log("logs/hack.log", string);
		}
		new truckdeliver = GetPVarInt(playerid, "TruckDeliver");
		TruckContents{vehicleid} = 0;

		if(truckdeliver == 1)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da giao do an do uong, tra xe ve ben de nhan tien luong cua ban.");
		}
		else if(truckdeliver == 2)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da giao quan ao, tra xe ve ben cang de nhan tien luong cua ban.");
		}
		else if(truckdeliver == 3)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da giao tai lieu, tra xe ve ben de nhan tien luong cua ban.");
		}
		else if(truckdeliver == 4)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da giao cac mat hang 24/7, tra lai xe cho ben cang de nhan tien luong cua ban.");
		}
		else if(truckdeliver == 5)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da giao vu khi, tra xe ve ben tau de nhan tien luong cua ban.");
		}
		else if(truckdeliver == 6)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da giao thuoc, tra xe ve ben de nhan tien luong cua ban.");
		}
		else if(truckdeliver == 7)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da giao cac vat lieu bat hop phap, tra xe cho ben cang de nhan tien luong cua ban.");
		}
		DisablePlayerCheckpoint(playerid);

		gPlayerCheckpointStatus[playerid] = CHECKPOINT_RETURNTRUCK;
		if(!IsABoat(vehicleid))
		{
			SetPlayerCheckpoint(playerid, -1548.087524, 123.590423, 3.554687, 5);
			GameTextForPlayer(playerid, "~w~Diem den duoc thiet lap ~r~ Ben cang SF ", 5000, 1);
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Quay tro lai ben tau San Fierro (xem diem danh dau tren radar).");
		}
		else
		{
			SetPlayerCheckpoint(playerid, 2098.6543,-104.3568,-0.4820, 5);
			GameTextForPlayer(playerid, "~w~Diem den duoc thiet lap ~r~Ben cang Palamino ", 5000, 1);
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Quay tro lai ben tau Palamino (xem diem danh dau tren radar).");
		}

		SetPVarInt(playerid, "tpTruckRunTimer", 30);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
		return 1;
	}
	if(gPlayerCheckpointStatus[playerid] == CHECKPOINT_DELIVERY)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    {
	        SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong o trong xe tai!");
	        return 1;
	    }
	    if(TruckUsed[playerid] != INVALID_VEHICLE_ID && vehicleid != TruckUsed[playerid])
	    {
	        SendClientMessageEx(playerid, COLOR_WHITE, "Day khong phai phuong tien cua ban voi hang hoa ban se giao!");
	        return 1;
	    }

		new business = TruckDeliveringTo[vehicleid];

		if (!IsPlayerInRangeOfPoint(playerid, 20.0, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2])) return 1;

		if(GetPVarInt(playerid, "tpTruckRunTimer") != 0)
		{
  			new string[128];
			format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) is possibly teleport truck/boat running.", GetPlayerNameEx(playerid), playerid);
  			ABroadCast( COLOR_YELLOW, string, 2 );
    		// format(string, sizeof(string), "%s (ID %d) is possibly teleport truckrunning.", GetPlayerNameEx(playerid), playerid);
	    	// Log("logs/hack.log", string);
		}

		new string[128];
		format(string, sizeof(string), "* Ban da van chuyen %s den %s. tra xe tai ve ben tau San Fierro de nhan tien luong.", GetInventoryType(business), Businesses[business][bName]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

		Businesses[business][bOrderState] = 3;
		Businesses[business][bInventory] += Businesses[business][bOrderAmount];
		foreach (new i: Player)
		{
			if (PlayerInfo[i][pBusiness] == business) SendClientMessageEx(i, COLOR_WHITE, "Mot don hang duoc giao cho doanh nghiep cua ban.");
		}

		/*if (Businesses[business][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP)
		{
		    new iSlot = GetPVarInt(playerid, "CarryingSlot");
		    new iVehicle = GetPVarInt(playerid , "CarryingVehicle");
		    if (GetDistanceToCar(playerid, iVehicle) > 10.0) return SendClientMessageEx(playerid, COLOR_WHITE, "Phuong tien khong di cung ban.");
			Businesses[business][DealershipVehStock][iSlot] = 1;
			SetVehiclePos(iVehicle, Businesses[business][bParkPosX][iSlot], Businesses[business][bParkPosY][iSlot], Businesses[business][bParkPosZ][iSlot]);
			SetVehicleZAngle(iVehicle, Businesses[business][bParkAngle][iSlot]);
			DeletePVar(playerid, "CarryingSlot");
			DeletePVar(playerid, "CarryingVehicle");
		}*/
		if (Businesses[business][bType] == BUSINESS_TYPE_GASSTATION)
		{
			for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++)
			{
				Businesses[business][GasPumpGallons][i] = Businesses[business][GasPumpCapacity][i];
			}
			DestroyVehicle(GetVehicleTrailer(vehicleid));
			DeletePVar(playerid, "Gas_TrailerID");
		}
		SaveBusiness(business);
		DisablePlayerCheckpoint(playerid);

		gPlayerCheckpointStatus[playerid] = CHECKPOINT_RETURNTRUCK;
		SetPlayerCheckpoint(playerid, -1548.087524, 123.590423, 3.554687, 5);
		GameTextForPlayer(playerid, "~w~Diem den duoc thiet lap ~r~San Fierro Docks", 5000, 1);
		SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Quay tro lai ben tau San Fierro (xem diem danh dau tren radar).");

		//SetPVarInt(playerid, "tpTruckRunTimer", 30);
		//SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
		return 1;
	}
	// Pizza Delivery
	if(GetPVarType(playerid, "Pizza") > 0 && GetPVarInt(playerid, "pizzaTimer") > 0 && IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[GetPVarInt(playerid, "Pizza")][hExteriorX], HouseInfo[GetPVarInt(playerid, "Pizza")][hExteriorY], HouseInfo[GetPVarInt(playerid, "Pizza")][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[GetPVarInt(playerid, "Pizza")][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[GetPVarInt(playerid, "Pizza")][hExtVW])
	{
	    new string[128];
		if (GetPVarInt(playerid, "tpPizzaTimer") != 0)
		{
			format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) is possibly teleport pizzarunning.", GetPlayerNameEx(playerid), playerid);
  			ABroadCast( COLOR_YELLOW, string, 2 );
    		// format(string, sizeof(string), "%s (ID %d) is possibly teleport pizzarunning.", GetPlayerNameEx(playerid), playerid);
	    	// Log("logs/hack.log", string);
		}
		format(string, sizeof(string), "Ban da giao banh pizza den dich, ban da nhan $%d neu khong biet duong go /map chon cong viec pizza de quay ve lam tiep.", (GetPVarInt(playerid, "pizzaTimer") * 100));
		Misc_Save();
		GivePlayerCash(playerid, floatround((GetPVarInt(playerid, "pizzaTimer") * 100), floatround_round));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		DeletePVar(playerid, "Pizza");
		DeletePVar(playerid, "pizzaTimer");
		DisablePlayerCheckpoint(playerid);

	}
	if(GetPVarInt(playerid, "Finding")>=1)
	{
	    DeletePVar(playerid, "Finding");
	    DisablePlayerCheckpoint(playerid);
	    GameTextForPlayer(playerid, "~w~Reached destination", 5000, 1);
	}
	if(TaxiCallTime[playerid] > 0 && TaxiAccepted[playerid] != INVALID_PLAYER_ID)
	{
		TaxiAccepted[playerid] = INVALID_PLAYER_ID;
		GameTextForPlayer(playerid, "~w~Reached destination", 5000, 1);
		TaxiCallTime[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
	}
	else if(EMSCallTime[playerid] > 0 && EMSAccepted[playerid] != INVALID_PLAYER_ID)
	{
	    if(GetPVarInt(EMSAccepted[playerid], "Injured") == 1)
	    {
	    	SendEMSQueue(EMSAccepted[playerid],2);
	    	EMSAccepted[playerid] = INVALID_PLAYER_ID;
	    	GameTextForPlayer(playerid, "~w~Reached destination", 5000, 1);
	    	EMSCallTime[playerid] = 0;
	    	DisablePlayerCheckpoint(playerid);
		}
		else
		{
            EMSAccepted[playerid] = INVALID_PLAYER_ID;
		    GameTextForPlayer(playerid, "~r~Patient has died", 5000, 1);
		    EMSCallTime[playerid] = 0;
	    	DisablePlayerCheckpoint(playerid);
		}
	}
	else if(BusCallTime[playerid] > 0 && BusAccepted[playerid] != INVALID_PLAYER_ID)
	{
		BusAccepted[playerid] = INVALID_PLAYER_ID;
		GameTextForPlayer(playerid, "~w~Reached destination", 5000, 1);
		BusCallTime[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
	}
	else if(MedicCallTime[playerid] > 0 && MedicAccepted[playerid] != INVALID_PLAYER_ID)
	{
		MedicAccepted[playerid] = INVALID_PLAYER_ID;
		GameTextForPlayer(playerid, "~w~Reached patient", 5000, 1);
		MedicCallTime[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
	}
	else
	{
		switch (gPlayerCheckpointStatus[playerid])
		{
			case CHECKPOINT_NOTHING: {

				DisablePlayerCheckpoint(playerid);
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
				return 1;
			}
			case CHECKPOINT_HOME:
			{
				PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
				new i = GetPVarInt(playerid, "hInviteHouse");
				DisablePlayerCheckpoint(playerid);
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
				SetPlayerInterior(playerid,HouseInfo[i][hIntIW]);
				SetPlayerPos(playerid,HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ]);
				GameTextForPlayer(playerid, "~w~Welcome Home", 5000, 1);
				PlayerInfo[playerid][pInt] = HouseInfo[i][hIntIW];
				PlayerInfo[playerid][pVW] = HouseInfo[i][hIntVW];
				SetPlayerVirtualWorld(playerid,HouseInfo[i][hIntVW]);
				if(HouseInfo[i][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ], FREEZE_TIME);
			}
			case CHECKPOINT_LOADTRUCK:
			{
			    if(IsPlayerInRangeOfPoint(playerid, 6, -1598.454956, 75.236511, 3.554687) || IsPlayerInRangeOfPoint(playerid, 6, 2098.6543,-104.3568,-0.4820))
			    {
				    new vehicleid = GetPlayerVehicleID(playerid);

					if(GetVehicleModel(vehicleid) == 440 || GetVehicleModel(vehicleid) == 413) // Level Three Vehicle Check
					{
						if(PlayerInfo[playerid][pTruckSkill] < 400)
						{
							return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can dat ky nang Trucker cap do 3 moi co the su dung xe nay.");
						}
					}
					if(GetVehicleModel(vehicleid) == 482) // Level Five Vehicle Check
					{
						if(PlayerInfo[playerid][pTruckSkill] < 6400)
						{
							return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can dat ky nang Trucker cap do 5 moi co the su dung xe nay.");
						}
					}
	   				if(IsATruckerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		    		{
				    	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
				    	DisablePlayerCheckpoint(playerid);
				    	gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
						TogglePlayerControllable(playerid, 0);
						SetPVarInt(playerid, "IsFrozen", 1);
						DisplayOrders(playerid);
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong lai dung thuyen hoac xe tai!");
				}
			}
			case CHECKPOINT_RETURNTRUCK:
			{
			    if(!IsPlayerInRangeOfPoint(playerid, 6, -1548.087524, 123.590423, 3.554687) && !IsPlayerInRangeOfPoint(playerid, 6, 2098.6543,-104.3568,-0.4820))
			    {// In the case the person finds a way to exploit the checkpoint to different location
                    CancelTruckDelivery(playerid);
                    SendClientMessageEx(playerid, COLOR_REALRED, "ERROR: Wrong checkpoint entered. Truck delivery canceled completely.");
					return 1;
			    }
 				if(GetPVarInt(playerid, "tpTruckRunTimer") != 0)
				{
  					new string[128];
					format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) is possibly teleport truck/boat running.", GetPlayerNameEx(playerid), playerid);
  					ABroadCast( COLOR_YELLOW, string, 2 );
    				// format(string, sizeof(string), "%s (ID %d) is possibly teleport truckrunning.", GetPlayerNameEx(playerid), playerid);
	    			// Log("logs/hack.log", string);
				}
   				new vehicleid = GetPlayerVehicleID(playerid);
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    		{
	        		SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong o trong phuong tien van chuyen!");
	        		return 1;
	    		}
	    		if(TruckUsed[playerid] != INVALID_VEHICLE_ID && vehicleid != TruckUsed[playerid])
	    		{
	        		SendClientMessageEx(playerid, COLOR_WHITE, "Day khong phai la chiec xe ban da su dung, hay tra lai chiec xe ban da su dung de nhan tien luong cua ban!");
	        		return 1;
	    		}

			    PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
			    DisablePlayerCheckpoint(playerid);
			    gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
				new route = TruckRoute[vehicleid];
   				new string[128], payment;
				new level = PlayerInfo[playerid][pTruckSkill];
				switch(level) {
					case 0 .. 100: payment = 7500;
					case 101 .. 400: payment = 9500;
					case 401 .. 1600: payment = 11000;
					case 1601 .. 6400: payment = 13000;
					case 6401: payment = 15500;
					default: payment = 15500;
				}
				new Float:distancepay;
				if(IsABoat(vehicleid))
				{
				    distancepay = floatmul(GetDistanceBetweenPoints(2098.6543,-104.3568,-0.4820, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ]), 1.5);
				}
				else
				{
				    distancepay = floatmul(GetDistanceBetweenPoints(-1598.454956, 75.236511, 3.554687, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ]), 1.5);
				}
				payment += floatround(distancepay);
				if(TruckDeliveringTo[vehicleid] != INVALID_BUSINESS_ID) {
					new iBusiness = TruckDeliveringTo[vehicleid];
			 		new Float: iDist = GetPlayerDistanceFromPoint(playerid, Businesses[iBusiness][bSupplyPos][0], Businesses[iBusiness][bSupplyPos][1], Businesses[iBusiness][bSupplyPos][2]);

				 	payment = floatround(iDist / 2300 * payment);
					if (payment > 30000) payment = 30000;

					GivePlayerCash(playerid, payment);
					format(string, sizeof(string), "* Ban duoc tra $%d khi giao hang va tra lai xe.", payment);

				    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				    SetVehicleToRespawn(vehicleid);
				}
				else {
				    DeletePVar(playerid, "LoadType");
				    new truckdeliver = GetPVarInt(playerid, "TruckDeliver");
					TruckContents{vehicleid} = 0;

					if(truckdeliver >= 1 && truckdeliver <= 5)
					{
						GivePlayerCash(playerid, payment);
						format(string, sizeof(string), "* Ban duoc tra $%d khi giao hang va tra lai xe.", payment);
					}
					else if(truckdeliver >= 5 && truckdeliver <= 7)
					{
						payment = floatround(payment * 1.25);
						GivePlayerCash(playerid, payment);
		    			format(string, sizeof(string), "* Ban duoc tra $%d khi giao hang va tra xe.", payment);
		    			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban nhan duoc them hoa hong 25 phan tram vi tranh rui ro tu canh sat.");

					}
				    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					if(truckdeliver == 5) // Weapons
					{
						if(PlayerInfo[playerid][pConnectHours] >= 2 && PlayerInfo[playerid][pWRestricted] <= 0)
						{
							switch(level) {
								case 0 .. 99: GivePlayerValidWeapon(playerid, WEAPON_BAT);
								case 100 .. 400: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm", "Chon", "");
								case 401 .. 1600: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun", "Chon", "");
								case 1601 .. 6400: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun\nMP5", "Chon", "");
								case 6401: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun\nMP5\nDeagle", "Chon", "");
								default: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun\nMP5\nDeagle", "Chon", "");
							}
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban khong duoc cap vu khi boi vi ban bi han che vu khi.");
						}
					}
					if(truckdeliver == 6) // Drugs
					{

						if(level >= 0 && level <= 100)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban nhan duoc 2 pot 1 crack nhu mot phan thuong cho viec mao hiem van chuyen ma tuy bat hop phap.");
						    PlayerInfo[playerid][pDrugs][0] += 2;
						    PlayerInfo[playerid][pDrugs][1] += 1;
						}
						else if(level >= 101 && level <= 400)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban nhan duoc 4 pot 2 crack nhu mot phan thuong cho viec mao hiem van chuyen ma tuy bat hop phap.");
					    	PlayerInfo[playerid][pDrugs][0] += 4;
						    PlayerInfo[playerid][pDrugs][1] += 2;
						}
						else if(level >= 401 && level <= 1600)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban nhan duoc 6 pot 3 crack nhu mot phan thuong cho viec mao hiem van chuyen ma tuy bat hop phap.");
					    	PlayerInfo[playerid][pDrugs][0] += 6;
						    PlayerInfo[playerid][pDrugs][1] += 3;
						}
						else if(level >= 1601 && level <= 6400)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban nhan duoc 8 pot 4 crack nhu mot phan thuong cho viec mao hiem van chuyen ma tuy bat hop phap.");
					  	  	PlayerInfo[playerid][pDrugs][0] += 8;
						    PlayerInfo[playerid][pDrugs][1] += 4;
						}
						else if(level >= 6401)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban nhan duoc 10 pot 5 crack nhu mot phan thuong cho viec mao hiem van chuyen ma tuy bat hop phap.");
					   	 	PlayerInfo[playerid][pDrugs][0] += 10;
						    PlayerInfo[playerid][pDrugs][1] += 5;
						}
					}
					if(truckdeliver == 7) // Illegal materials
					{
						if(level >= 0 && level <= 100)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban duoc nhan 100 vat lieu nhu mot phan thuong cho viec chap nhan rui ro van chuyen cac tai lieu bat hop phap.");
							PlayerInfo[playerid][pMats] += 100;
						}
						else if(level >= 101 && level <= 400)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban duoc nhan 200 vat lieu nhu mot phan thuong cho viec chap nhan rui ro van chuyen cac tai lieu bat hop phap.");
							PlayerInfo[playerid][pMats] += 200;
						}
						else if(level >= 401 && level <= 1600)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban duoc nhan 400 vat lieu nhu mot phan thuong cho viec chap nhan rui ro van chuyen cac tai lieu bat hop phap.");
							PlayerInfo[playerid][pMats] += 400;
						}
						else if(level >= 1601 && level <= 6400)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban duoc nhan 600 vat lieu nhu mot phan thuong cho viec chap nhan rui ro van chuyen cac tai lieu bat hop phap.");
							PlayerInfo[playerid][pMats] += 600;
						}
						else if(level >= 6401)
						{
		                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban duoc nhan 1000 vat lieu nhu mot phan thuong cho viec chap nhan rui ro van chuyen cac tai lieu bat hop phap.");
							PlayerInfo[playerid][pMats] += 1000;
						}
					}
				    SetVehicleToRespawn(vehicleid);
				}

				if(PlayerInfo[playerid][pDoubleEXP] > 0)
				{
					format(string, sizeof(string), "Ban da duoc 2 diem ky nang thay vi 1. Ban con %d gio Double EXP Token .", PlayerInfo[playerid][pDoubleEXP]);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					PlayerInfo[playerid][pTruckSkill] += 2;
				}
				else
				{
					PlayerInfo[playerid][pTruckSkill] += 1;
				}

				TruckUsed[playerid] = INVALID_VEHICLE_ID;
				DeletePVar(playerid, "TruckDeliver");

				new mypoint = -1;
				for (new i=0; i<MAX_POINTS; i++)
				{
					if(strcmp(Points[i][Name], "San Fierro Docks", true) == 0)
					{
						mypoint = i;
					}
				}
				for(new i = 0; i < MAX_GROUPS; i++)
				{
					if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
					{
						Misc_Save();
						arrGroupData[i][g_iBudget] += 0;
					}
			 	}
			}
		}
	}
	if (GetPVarInt(playerid, "_SwimmingActivity") > 0)
	{
		new stage = GetPVarInt(playerid, "_SwimmingActivity");

		switch (stage)
		{
			case 1:
			{
				SetPlayerCheckpoint(playerid, 2889.5471, -2269.0251, 0.2176, 2.0);
				SetPVarInt(playerid, "_SwimmingActivity", 2);
			}

			case 2:
			{
				SetPlayerCheckpoint(playerid, 2839.7312, -2268.6123, -0.9815, 2.0);
				SetPVarInt(playerid, "_SwimmingActivity", 3);
			}

			case 3:
			{
				SetPlayerCheckpoint(playerid, 2839.5469, -2281.9521, -0.8549, 2.0);
				SetPVarInt(playerid, "_SwimmingActivity", 4);
			}

			case 4:
			{
				SetPlayerCheckpoint(playerid, 2888.1426, -2284.0317, 0.1347, 2.0);
				SetPVarInt(playerid, "_SwimmingActivity", 5);
			}

			case 5:
			{
				SetPlayerCheckpoint(playerid, 2889.5471, -2269.0251, 0.2176, 2.0);
				SetPVarInt(playerid, "_SwimmingActivity", 6);
			}

			case 6:
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Ket thuc vong! The luc cua ban da tang len mot chut. (/thongtin de kiem tra the luc)");
				if(PlayerInfo[playerid][mCooldown][4]) PlayerInfo[playerid][pFitness] += 5;
				else PlayerInfo[playerid][pFitness] += 3;
				if (PlayerInfo[playerid][pFitness] > 100) PlayerInfo[playerid][pFitness] = 100;
				SendClientMessageEx(playerid, COLOR_WHITE, "Neu ban khong tap nua hay su dung lenh (/dungboi)");
				SetPVarInt(playerid, "_SwimmingActivity", 3);
				SetPlayerCheckpoint(playerid, 2839.7312, -2268.6123, -0.9815, 2.0);
			}
		}
	}

	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPVarInt(playerid, "Injured") == 1) return 1;
	if(PlayerInfo[playerid][pHospital] > 0) return 1;
	if(gPlayerUsingLoopingAnim[playerid] && IsKeyJustDown(KEY_SPRINT,newkeys,oldkeys))
	{
	    StopLoopingAnim(playerid);
        TextDrawHideForPlayer(playerid,txtAnimHelper);
    }
	if(newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1,0,1,1,0,0);
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
	    new string[128];
	    if(!GetPVarType(playerid, "Tackling"))	{
	        if(GetPVarInt(playerid, "TackleMode") == 1 && GetPlayerTargetPlayer(playerid) != INVALID_PLAYER_ID && PlayerCuffed[GetPlayerTargetPlayer(playerid)] == 0 && ProxDetectorS(4.0, playerid, GetPlayerTargetPlayer(playerid)) && !IsPlayerNPC(GetPlayerTargetPlayer(playerid)))
	        {
		        if(GetPVarInt(playerid, "CopTackleCooldown") != 0)
		        {
		            format(string, sizeof(string), "Ban bi kiet suc roi! Se mat %d giay truoc khi ban co the tan cong lai.", GetPVarInt(playerid, "CopTackleCooldown"));
		            return SendClientMessageEx(playerid, COLOR_GRAD2, string);
		        }
	            if(PlayerInfo[GetPlayerTargetPlayer(playerid)][pAdmin] >= 2 && PlayerInfo[GetPlayerTargetPlayer(playerid)][pTogReports] != 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Admin khong the bi tan cong!");
					return 1;
				}
				if(IsPlayerInAnyVehicle(GetPlayerTargetPlayer(playerid)))
				{
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the tan cong ai do dang o trong xe!");
				}
				if(IsPlayerInAnyVehicle(playerid))
				{
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the tan cong ai do khi dang o trong xe!");
				}
				if(GetPVarType(GetPlayerTargetPlayer(playerid), "IsTackled"))
				{
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi do da bi tan cong, dung ben canh ho de ho tro!");
				}
				if(GetPVarInt(GetPlayerTargetPlayer(playerid), "CantBeTackledCount") > 0)
				{
					format(string, sizeof(string), "Nguoi nay khong the bi xu ly trong %d giay nua.", GetPVarInt(GetPlayerTargetPlayer(playerid), "CantBeTackledCount"));
		            return SendClientMessageEx(playerid, COLOR_GRAD2, string);
				}
				#if defined zombiemode
				if(GetPVarInt(GetPlayerTargetPlayer(playerid), "pIsZombie"))
				{
				    SendClientMessageEx(playerid, COLOR_GRAD2, "Zombie khong the chien dau!");
					return 1;
				}
				#endif
	            new tacklechance = random(10);
				switch(tacklechance)
				{
					case 0..6: //success
					{
					    TacklePlayer(playerid, GetPlayerTargetPlayer(playerid));
					}
					default: // fail
					{
						format(string, sizeof(string), "** %s nhay vao %s co gang tan cong chung nhung khong the.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPlayerTargetPlayer(playerid)));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						TogglePlayerControllable(playerid, 0);
						SetTimerEx("CopGetUp", 2500, 0, "i", playerid);
						ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 1, 1, 1, 0, 1);
					}
	            }
	        }
		}
	}
    if(newkeys & KEY_NO)
	{
		if(InsideTradeToys[playerid] == 1)
		{
			if(IsPlayerConnected(GetPVarInt(playerid, "ttSeller")))
			{
				new string[128];
				format(string, sizeof(string), "%s da tu choi loi de nghi do choi.", GetPlayerNameEx(playerid));
				SendClientMessageEx(GetPVarInt(playerid, "ttSeller"), COLOR_LIGHTBLUE, string);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban da tu choi loi de nghi do choi.");

				DeletePVar(GetPVarInt(playerid, "ttSeller"), "ttBuyer");
				DeletePVar(GetPVarInt(playerid, "ttSeller"), "ttCost");
				DeletePVar(playerid, "ttSeller");

				HideTradeToysGUI(playerid);
				return 1;
			}
			else {
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Nguoi ban da ngat ket noi voi may chu,do do ban khong the tien hanh giao dich.");
				DeletePVar(playerid, "ttSeller");

				HideTradeToysGUI(playerid);
			}
		}
	}
    if(newkeys & KEY_YES)
    {
		if(InsideTradeToys[playerid] == 1)
		{
			if(IsPlayerConnected(GetPVarInt(playerid, "ttSeller")))
			{
				ShowPlayerDialogEx(playerid, CONFIRMSELLTOY, DIALOG_STYLE_MSGBOX, "Vui long xac nhan lua chon cua ban", "Ban co chac chan muon mua do choi nay voi so tien chi dinh khong?", "Co", "Khong");
			}
			else {
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Nguoi ban da ngat ket noi voi may chu, do do ban khong the tien hanh giao dich.");
				DeletePVar(playerid, "ttSeller");

				HideTradeToysGUI(playerid);
			}
		}
		if(GetPVarType(playerid, "Tackling"))	{
		    ClearTackle(GetPVarInt(playerid, "Tackling"));
			CopGetUp(playerid);
		    return 1;
		}
        if(GetPlayerTargetPlayer(playerid) != INVALID_PLAYER_ID && ProxDetectorS(5.0, playerid, GetPlayerTargetPlayer(playerid)) && !IsPlayerNPC(GetPlayerTargetPlayer(playerid)))
        {
            if(GetPVarInt(playerid, "TackleMode") == 1) {
		    	return 1;
			}
			Player_InteractMenu(playerid, GetPlayerTargetPlayer(playerid));
        }
    }
	// If the client clicked the fire key and is currently injured
	else if((newkeys && KEY_FIRE) && GetPVarInt(playerid, "Injured") == 1)
	{
		ClearAnimationsEx(playerid);
		return 1;
	}
	else if((newkeys & KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPlayerWeapon(playerid) == SPEEDGUN && GetPVarType(playerid, "SpeedRadar"))
	{
	    if(GetPVarInt(playerid, "RadarTimeout") == 0)
	    {
			new Float:x,Float:y,Float:z;
			foreach(new i: Player)
			{
				if(IsPlayerStreamedIn(i, playerid))
				{
					GetPlayerPos(i,x,y,z);
					if(IsPlayerAimingAt(playerid,x,y,z,10))
					{
						new string[68];
						format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~b~License Plate: ~w~%d~n~~b~Speed: ~w~%.0f MPH", GetPlayerVehicleID(i), fVehSpeed[i]);
						GameTextForPlayer(playerid, string,3500, 3);
						format(string, sizeof(string), "License Plate: %d. Speed: %.0f MPH", GetPlayerVehicleID(i), fVehSpeed[i]);
						SendClientMessageEx(playerid, COLOR_GRAD4, string);
						SetPVarInt(playerid, "RadarTimeout", 1);
						SetTimerEx("RadarCooldown", 3000, 0, "i", playerid);
						return 1;
					}
				}
			}
		}
	}
	else if((newkeys & 16) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PlayerCuffed[playerid] == 0 && PlayerInfo[playerid][pBeingSentenced] == 0 && GetPVarType(playerid,"UsingAnim") && !GetPVarType(playerid, "IsFrozen"))
	{
		ClearAnimationsEx(playerid);
		DeletePVar(playerid,"UsingAnim");
	}
	else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_BEER && (newkeys & KEY_FIRE))
	{
	    if(GetPVarInt(playerid, "DrinkCooledDown") == 1)
	    {
			new Float: cHealth;
			GetHealth(playerid, cHealth);
		    if(cHealth < 100)
		    {
				SetHealth(playerid, cHealth+5);
		    }
		    else
		    {
		        SendClientMessageEx(playerid, COLOR_GREY, "* Ban da uong xong va vut no di.");
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				SetHealth(playerid, 100);
		    }
			DeletePVar(playerid, "DrinkCooledDown");
		    SetTimerEx("DrinkCooldown", 2500, 0, "i", playerid);
			return 1;
		}
	}
	else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_WINE && (newkeys & KEY_FIRE))
	{
	    if(GetPVarInt(playerid, "DrinkCooledDown") == 1)
	    {
			new Float: cHealth;
			GetHealth(playerid, cHealth);
		    if(cHealth < 100)
		    {
				SetHealth(playerid, cHealth+8);
		    }
		    else
		    {
		        SendClientMessageEx(playerid, COLOR_GREY, "* Ban da uong xong va vut no di.");
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				SetHealth(playerid, 100);
		    }
			DeletePVar(playerid, "DrinkCooledDown");
		    SetTimerEx("DrinkCooldown", 2500, 0, "i", playerid);
			return 1;
		}
	}

	else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_SPRUNK && (newkeys & KEY_FIRE))
	{
		if(GetPVarInt(playerid, "DrinkCooledDown") == 1 && GetPVarInt(playerid, "UsingSprunk") == 1)
		{
			new Float: cHealth;
			GetHealth(playerid, cHealth);
			if(cHealth < 100)
			{
				SetHealth(playerid, cHealth+2);
			}
			else
			{
				DeletePVar(playerid, "UsingSprunk");
				SendClientMessageEx(playerid, COLOR_GREY, "* Ban da uong xong va vut no di.");
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				SetHealth(playerid, 100);
			}
			DeletePVar(playerid, "DrinkCooledDown");
			SetTimerEx("DrinkCooldown", 2500, 0, "i", playerid);
			return 1;
		}
	}
	else if(IsKeyJustDown(KEY_SECONDARY_ATTACK, newkeys, oldkeys))
	{
	    if(GetPVarInt(playerid, "NGPassenger") == 1)
	    {
	        TogglePlayerSpectating(playerid, 0);
		}
		if(GetPVarInt(playerid, "UsingSprunk"))
		{
			DeletePVar(playerid, "UsingSprunk");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			return 1;
		}
	}
	/*else if(!IsPlayerInAnyVehicle(playerid) && PRESSED(KEY_HANDBRAKE))
	{
		if(GetPlayerWeapon(playerid) == WEAPON_ROCKETLAUNCHER || GetPlayerWeapon(playerid) == WEAPON_SNIPER
			 || GetPlayerWeapon(playerid) == WEAPON_CAMERA || GetPlayerWeapon(playerid) == WEAPON_HEATSEEKER)
		{
			for(new i = 0; i < 11; i++)
			{
				printf("Toy %d - %d", i, PlayerHoldingObject[playerid][i]);
				if(i == 9 && PlayerInfo[playerid][pBEquipped])
				{
					RemovePlayerAttachedObject(playerid, 9);
					break;
				}
				RemovePlayerAttachedObject(playerid, i);
			}
		}
	}
	else if(!IsPlayerInAnyVehicle(playerid) && RELEASED(KEY_HANDBRAKE))
	{
		for(new i = 1; i < 11; i++)
		{
			if(PlayerHoldingObject[playerid][i] != 0 || PlayerInfo[playerid][pBEquipped])
			{
				if(i == 10 && PlayerInfo[playerid][pBEquipped])
				{
					switch(PlayerInfo[playerid][pBackpack])
					{
						case 1: SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
						case 2: SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
						case 3: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
					}
					break;
				}
				new toy = i - 1;
				printf("Toy %d - i: %d, PlayerHoldingObject: %d", toy, i, PlayerHoldingObject[playerid][i]);
				SetPlayerAttachedObject(playerid, toy,
					PlayerToyInfo[playerid][toy][ptModelID],
					PlayerToyInfo[playerid][toy][ptBone],
					PlayerToyInfo[playerid][toy][ptPosX],
					PlayerToyInfo[playerid][toy][ptPosY],
					PlayerToyInfo[playerid][toy][ptPosZ],
					PlayerToyInfo[playerid][toy][ptRotX],
					PlayerToyInfo[playerid][toy][ptRotY],
					PlayerToyInfo[playerid][toy][ptRotZ],
					PlayerToyInfo[playerid][toy][ptScaleX],
					PlayerToyInfo[playerid][toy][ptScaleY],
					PlayerToyInfo[playerid][toy][ptScaleZ]
				);
			}
		}
	}*/
	/*else if(IsKeyJustDown(128, newkeys, oldkeys))
	{
	    if(ConfigEventCPs[playerid][1] == 1 && ConfigEventCPs[playerid][0] == 1) {
        	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da huy giai doan 1, ban khong the chinh sua vi tri cua checkpoint.");
        	ConfigEventCPs[playerid][1] = 0;
        	ConfigEventCPs[playerid][0] = 0;
        	ConfigEventCPs[playerid][2] = 0;
		}
		else if(ConfigEventCPs[playerid][1] == 2 && ConfigEventCPs[playerid][0] == 1) {
        	TogglePlayerControllable(playerid, true);
        	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da huy giai doan 2, vui long chon vi tri khac. Neu ban muon sua vi tri 1 (Edit CP Position) press the AIM button again.");
        	ConfigEventCPs[playerid][1] = 1;
		}
		if(GetPVarInt(playerid, "CreateGT") == 1)
		{
			DeletePVar(playerid, "CreateGT");
			SendClientMessageEx(playerid, COLOR_GREY, "Ban da ngung tao new gang tag.");
		}
		if(GetPVarInt(playerid, "gt_Edit") == 1)
		{
			DeletePVar(playerid, "gt_ID");
			DeletePVar(playerid, "gt_Edit");
			SendClientMessageEx(playerid, COLOR_GREY, "Ban da dung chinh sua vi tri.");
		}
	}*/
	else if (IsKeyJustDown(KEY_FIRE, newkeys, oldkeys))
 	{
 	    if(ConfigEventCPs[playerid][1] == 1 && ConfigEventCPs[playerid][0] == 1) {
		    TogglePlayerControllable(playerid, false);
		    new string[92], Float: x, Float: y, Float: z;
			GetPlayerPos(playerid, x, y, z);
		    format(string, sizeof(string), "Position: X = %f.3 Y = %f.3 Z = %f.3", x, y, z);
		    SendClientMessageEx(playerid, COLOR_WHITE, "Are you sure this is the correct position? Please press the fire button again to confirm this, you can cancel by simply pressing the AIM button.");
            SendClientMessageEx(playerid, COLOR_YELLOW, string);
            ConfigEventCPs[playerid][1] = 2;
		}
		else if(ConfigEventCPs[playerid][1] == 2 && ConfigEventCPs[playerid][0] == 1) {
		    TogglePlayerControllable(playerid, true);
		    new string[298];
			GetPlayerPos(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]]);
		    format(string, sizeof(string), "You have successfuly created a race checkpoint. Position: X = %f.3 Y = %f.3 Z = %f.3 - ID:%d", EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], ConfigEventCPId[playerid]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
			if(ConfigEventCPs[playerid][2] == 1)
			{
			    EventRCPU[ConfigEventCPId[playerid]] = 1;
            	EventRCPS[ConfigEventCPId[playerid]] = 10.0;
            	if(ConfigEventCPId[playerid] == 0) {
					EventRCPT[ConfigEventCPId[playerid]] = 1;
					SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
            	else {
					EventRCPT[ConfigEventCPId[playerid]] = 2;
					SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				ConfigEventCPs[playerid][1] = 3;
            	format(string,sizeof(string),"Race Checkpoint %d Size", ConfigEventCPId[playerid]);
				ShowPlayerDialogEx(playerid,RCPSIZE,DIALOG_STYLE_INPUT,string,"You are now in stage 3, which means you will need to choose the size of the checkpoint\nYou now have a preview of the checkpoint(Step outside the checkpoint so you can see it)\nNote: Checkpoint is now made with the default settings,\nyou may choose not to continue checkpoint won't be affected.","Ok","Cancel");
			}
			else
			{
	        	if(EventRCPT[ConfigEventCPId[playerid]] == 1) {
					SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				else if(EventRCPT[ConfigEventCPId[playerid]] == 4) {
				    SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				else {
				    SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
			}
		}
 	    if( PlayerInfo[playerid][pC4Used] == 1 )
 	    {
			if(GoChase[playerid] != INVALID_PLAYER_ID)
			{
			    if(IsPlayerInRangeOfPoint(GoChase[playerid], 12.0, GetPVarFloat(playerid, "DYN_C4_FLOAT_X"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Y"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Z")))
			    {
			        if(PlayerInfo[GoChase[playerid]][pHeadValue] >= 1)
					{
						if (IsAHitman(playerid))
						{
							new string[128];
							new takemoney = PlayerInfo[GoChase[playerid]][pHeadValue];
							GivePlayerCash(playerid, floatround(takemoney * 0.9));
							GivePlayerCash(GoChase[playerid], -takemoney);
							format(string,sizeof(string),"Hitman %s da hoan thanh hop dong tren %s va nhan duoc $%d",GetPlayerNameEx(playerid),GetPlayerNameEx(GoChase[playerid]),takemoney);
							foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, string);
							format(string,sizeof(string),"Ban da bi hitman hap diem va mat so tien la $%d!",takemoney);
							ResetPlayerWeaponsEx(GoChase[playerid]);
						    // SpawnPlayer(GoChase[playerid]);
							SendClientMessageEx(GoChase[playerid], COLOR_YELLOW, string);

							PlayerInfo[GoChase[playerid]][pHeadValue] = 0;
							PlayerInfo[playerid][pCHits] += 1;
							SetHealth(GoChase[playerid], 0.0);
							// KillEMSQueue(GoChase[playerid]);
							GotHit[GoChase[playerid]] = 0;
							GetChased[GoChase[playerid]] = INVALID_PLAYER_ID;
							GoChase[playerid] = INVALID_PLAYER_ID;
							new iHitPercent = floatround(takemoney * 0.10);
							iHMASafe_Val += iHitPercent;
							format(szMiscArray, sizeof szMiscArray, "[hit] %s (%d) has killed %s (%d) [C4] for $%s ($%s deposited to safe).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(GoChase[playerid]), GetPlayerSQLId(GoChase[playerid]), number_format(takemoney), number_format(iHitPercent));
							Log("logs/hitman.log", szMiscArray);
						}
					}
			    }
			}
 	        PlayerInfo[playerid][pC4Used] = 0;
			CreateExplosion(GetPVarFloat(playerid, "DYN_C4_FLOAT_X"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Y"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Z"), 7, 8);
			PickUpC4(playerid);
			SendClientMessageEx(playerid, COLOR_YELLOW, " Bom da duoc kich no!");
			PlayerInfo[playerid][pC4Used] = 0;
			return 1;
 	    }
 	    if(GetPVarType(playerid, "MovingStretcher"))
 	    {
 	        KillTimer(GetPVarInt(playerid, "TickEMSMove"));
		    MoveEMS(playerid);
			return 1;
 	    }
		if(GetPVarType(playerid, "DraggingPlayer"))
		{
			new Float:dX, Float:dY, Float:dZ, string[128];
    		GetPlayerPos(playerid, dX, dY, dZ);
			floatsub(dX, 0.4);
			floatsub(dY, 0.4);

    		SetPVarFloat(GetPVarInt(playerid, "DraggingPlayer"), "DragX", dX);
			SetPVarFloat(GetPVarInt(playerid, "DraggingPlayer"), "DragY", dY);
			SetPVarFloat(GetPVarInt(playerid, "DraggingPlayer"), "DragZ", dZ);
			SetPVarInt(GetPVarInt(playerid, "DraggingPlayer"), "DragWorld", GetPlayerVirtualWorld(playerid));
			SetPVarInt(GetPVarInt(playerid, "DraggingPlayer"), "DragInt", GetPlayerInterior(playerid));
			Streamer_UpdateEx(GetPVarInt(playerid, "DraggingPlayer"), dX, dY, dZ);
			SetPlayerPos(GetPVarInt(playerid, "DraggingPlayer"), dX, dY, dZ);
			SetPlayerInterior(GetPVarInt(playerid, "DraggingPlayer"), GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(GetPVarInt(playerid, "DraggingPlayer"), GetPlayerVirtualWorld(playerid));
			ClearAnimationsEx(GetPVarInt(playerid, "DraggingPlayer"));
			ApplyAnimation(GetPVarInt(playerid, "DraggingPlayer"), "ped","cower",1,1,0,0,0,0,1);
            DeletePVar(GetPVarInt(playerid, "DraggingPlayer"), "BeingDragged");
            format(string, sizeof(string), "* Ba da ngung keo %s.", GetPlayerNameEx(GetPVarInt(playerid, "DraggingPlayer")));
			DeletePVar(playerid, "DraggingPlayer");
            SendClientMessage(playerid, COLOR_GRAD2, string);
		}
	}
	else if((newkeys & KEY_SPRINT) && GetPlayerState(playerid) == 2)// Pressing the gas, detonates the bomb.
	{
		new string[128], vehicleid = GetPlayerVehicleID(playerid);
		if(GetChased[playerid] != INVALID_PLAYER_ID && VehicleBomb{vehicleid} == 1)
		{
			if(PlayerInfo[playerid][pHeadValue] >= 1)
			{
				if (IsAHitman(GetChased[playerid]))
				{
					new Float:boomx, Float:boomy, Float:boomz;
					GetPlayerPos(playerid,boomx, boomy, boomz);
					CreateExplosion(boomx, boomy , boomz, 7, 1);
					VehicleBomb{vehicleid} = 0;
					PlacedVehicleBomb[GetChased[playerid]] = INVALID_VEHICLE_ID;
					new takemoney = PlayerInfo[playerid][pHeadValue];//(PlayerInfo[playerid][pHeadValue] / 4) * 2;
					GivePlayerCash(GetChased[playerid], floatround(takemoney * 0.9));
					GivePlayerCash(playerid, -takemoney);
					format(string,sizeof(string),"Hitman %s da hoan thanh hop dong tren %s va thu duoc $%d.",GetPlayerNameEx(GetChased[playerid]),GetPlayerNameEx(playerid),takemoney);
					foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, string);
					format(string,sizeof(string),"Ban da bi hap diem boi hitman va bi mat $%d!",takemoney);
					ResetPlayerWeaponsEx(playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					PlayerInfo[playerid][pHeadValue] = 0;
					PlayerInfo[GetChased[playerid]][pCHits] += 1;
					SetHealth(playerid, 0.0);
					GoChase[GetChased[playerid]] = INVALID_PLAYER_ID;
					PlayerInfo[GetChased[playerid]][pC4Used] = 0;
					PlayerInfo[GetChased[playerid]][pC4] = 0;
					GotHit[playerid] = 0;
					GetChased[playerid] = INVALID_PLAYER_ID;

					new iHitPercent = floatround(takemoney * 0.10);
					iHMASafe_Val += iHitPercent;
					format(szMiscArray, sizeof szMiscArray, "[hit] %s (%d) has killed %s (%d) [car bomb] for $%s ($%s deposited to safe).", GetPlayerNameEx(GetChased[playerid]), GetPlayerSQLId(GetChased[playerid]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), number_format(takemoney), number_format(iHitPercent));
					Log("logs/hitman.log", szMiscArray);
					return 1;
				}
			}
		}
    }
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	switch(oldstate)
	{
		case PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER:
		{
			DangLenXe[playerid] = -1;
			GetPlayerPos(playerid, PlayerPosCheck[playerid][0], PlayerPosCheck[playerid][1], PlayerPosCheck[playerid][2]);
		}
	}
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
 		if(!IsPlayerEntering{playerid} && PlayerInfo[playerid][pAdmin] < 2)
		{
			if(GetPVarInt(playerid, "TeleportWarnings") == 3) {
				new string[128];
		    	format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) may have just teleported into a vehicle.", GetPlayerNameEx(playerid), playerid);
				ABroadCast(COLOR_YELLOW, string, 2);
				DeletePVar(playerid, "TeleportWarnings");
				if(!gPlayerLogged{playerid})
				{
					CreateBan(INVALID_PLAYER_ID, INVALID_PLAYER_ID, playerid, GetPlayerIpEx(playerid), "Hacking while !Logged", 99999);
				}
			}
			else
			{
			    SetPVarInt(playerid, "TeleportWarnings", GetPVarInt(playerid, "TeleportWarnings")+1);
			}
		}
		if (CarRadars[playerid] > 0)
		{
			PlayerTextDrawShow(playerid, _crTextTarget[playerid]);
			PlayerTextDrawShow(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawShow(playerid, _crTickets[playerid]);
			DeletePVar(playerid, "_lastTicketWarning");
		}
	}
	IsPlayerEntering{playerid} = false;
	if(newstate == PLAYER_STATE_PASSENGER)
	{
		if (PlayerInfo[playerid][pSpeedo] != 0)
		{
			ShowVehicleHUDForPlayer(playerid);
		}
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if (IsAtGym(playerid))
		{
			new biz = InBusiness(playerid);
			new veh = GetPlayerVehicleID(playerid);

			for (new it = 0; it < 10; ++it)
			{
				if (Businesses[biz][bGymBikeVehicles][it] == veh)
				{
					if (GetPVarInt(playerid, "_BikeParkourSlot") != it)
					{
						RemovePlayerFromVehicle(playerid);
						SendClientMessageEx(playerid, COLOR_GRAD2, "That is not your bike!");
					}
				}
			}
		}

		if (PlayerInfo[playerid][pSpeedo] != 0)
		{
			ShowVehicleHUDForPlayer(playerid);
		}
		if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
		{
			if(GetPlayerWeapon(playerid) != 28 && GetPlayerWeapon(playerid) != 29)
			{
				SetPlayerArmedWeapon(playerid, 0);
			}
		}
	    new vehicleid = GetPlayerVehicleID(playerid);
		new Float: pX, Float: pY, Float: pZ;
		GetPlayerPos(playerid, pX, pY, pZ);
		if(GetPVarType(playerid, "IsInArena")) {

			for(new i = 0; i < MAX_ARENAS; i++)
			{
				if(PaintBallArena[i][pbVeh1ID] == vehicleid && GetPVarInt(playerid, "IsInArena") != i)
				{
					SetPlayerPos(playerid, pX, pY, pZ);
				}
				if(PaintBallArena[i][pbVeh2ID] == vehicleid && GetPVarInt(playerid, "IsInArena") != i)
				{
					SetPlayerPos(playerid, pX, pY, pZ);
				}
				if(PaintBallArena[i][pbVeh3ID] == vehicleid && GetPVarInt(playerid, "IsInArena") != i)
				{
					SetPlayerPos(playerid, pX, pY, pZ);
				}
				if(PaintBallArena[i][pbVeh4ID] == vehicleid && GetPVarInt(playerid, "IsInArena") != i)
				{
					SetPlayerPos(playerid, pX, pY, pZ);
				}
				if(PaintBallArena[i][pbVeh5ID] == vehicleid && GetPVarInt(playerid, "IsInArena") != i)
				{
					SetPlayerPos(playerid, pX, pY, pZ);
				}
				if(PaintBallArena[i][pbVeh6ID] == vehicleid && GetPVarInt(playerid, "IsInArena") != i)
				{
					SetPlayerPos(playerid, pX, pY, pZ);
				}
			}
		}
	}
    if(newstate != 2) NOPTrigger[playerid] = 0;
	//Specating
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_ONFOOT)
	{
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] >= 2 || GetPVarType(i, "StartedWatching")) {
				if(Spectating[i] > 0 && Spectate[i] == playerid) {
					if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
						TogglePlayerSpectating(i, true);
						new carid = GetPlayerVehicleID( playerid );
						PlayerSpectateVehicle( i, carid );
					}
					else if(newstate == PLAYER_STATE_ONFOOT) {
						TogglePlayerSpectating(i, true);
						PlayerSpectatePlayer( i, playerid );
						SetPlayerInterior( i, GetPlayerInterior( playerid ) );
					}
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		StopAudioStreamForPlayerEx(playerid);
		if(GetPVarType(playerid, "Siren"))
		{
  			if(IsPlayerAttachedObjectSlotUsed(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 3)) RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 3);
    		if(IsPlayerAttachedObjectSlotUsed(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2)) RemovePlayerAttachedObject(playerid, MAX_PLAYER_ATTACHED_OBJECTS - 2);
      		DeletePVar(playerid, "Siren");
		}

		/*if(GettingSpectated[playerid] != INVALID_PLAYER_ID && PlayerInfo[GettingSpectated[playerid]][pAdmin] >= 2) {
			new spectator = GettingSpectated[playerid];
	        // Preventing possible buffer overflows with the arrays
	 		TogglePlayerSpectating(spectator, true);
			PlayerSpectatePlayer( spectator, playerid );
			SetPlayerInterior( spectator, GetPlayerInterior( playerid ) );
			SetPlayerInterior( spectator, GetPlayerInterior( playerid ) );
			SetPlayerVirtualWorld( spectator, GetPlayerVirtualWorld( playerid ) );
		}*/

	    if(oldstate == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(IsAHelicopter(vehicleid))
			{
				new Float:vehPos[3];
				GetVehiclePos(vehicleid, vehPos[0], vehPos[1], vehPos[2]);
				foreach(new i: Player)
				{
					if(IsPlayerInRangeOfPoint(i, 50.0, vehPos[0], vehPos[1], vehPos[2]))
					{
						PlayerPlaySound(i, 1000, 0.0, 0.0, 0.0);
						PlayerPlaySound(i, 1001, 0.0, 0.0, 0.0);
					}
				}
			}
			if (_vhudVisible[playerid] == 1)
			{
				HideVehicleHUDForPlayer(playerid); // incase vehicle despawns
			}
			if (CarRadars[playerid] > 0)
			{
				PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
				PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
				PlayerTextDrawHide(playerid, _crTickets[playerid]);
				DeletePVar(playerid, "_lastTicketWarning");
			}
			SetPlayerWeaponsEx(playerid);
		}
		else if(oldstate == PLAYER_STATE_PASSENGER) SetPlayerWeaponsEx(playerid);

		if(ConnectedToPC[playerid] == 1337)//mdc
	    {
	        ConnectedToPC[playerid] = 0;
		}
        if(TransportDuty[playerid] > 0)
		{
		    if(TransportDuty[playerid] == 1)
			{
		        TaxiDrivers -= 1;
			}
			else if(TransportDuty[playerid] == 2)
			{
			    BusDrivers -= 1;
			}
			TransportDuty[playerid] = 0;
			new string[70]; // increased buf size as full message wasn't getting shown
			format(string, sizeof(string), "Ban da ngung lam viec va kiem duoc $%d.", TransportMoney[playerid]);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

			foreach(new i: Player)
			{
				if (TransportDriver[i] == playerid)
				{
					GivePlayerCash(i, -TransportCost[i]);
					format(string, sizeof(string), "Tai xe cua ban da roi khoi xe nen ban duoc tra tien $%d.", TransportCost[i]);
					TransportCost[i] = 0; // I've not used either of these two variables before, could be more that resetting
					TransportDriver[i] = INVALID_PLAYER_ID;
					SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
				}
			}

			GivePlayerCash(playerid, (TransportMoney[playerid] * 1));
			if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)) arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] += TransportMoney[playerid];
			if(TransportMoney[playerid]) format(szMiscArray, sizeof(szMiscArray), "%s da ngung lam viec va kiem duoc $%s", GetPlayerNameEx(playerid), number_format(TransportMoney[playerid])), GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
			TransportValue[playerid] = 0; TransportMoney[playerid] = 0;
			if(!IsATaxiDriver(playerid)) { SetPlayerColor(playerid, TEAM_HIT_COLOR); }
			TransportTime[playerid] = 0;
   			TransportCost[playerid] = 0;
		}
		if(TransportDriver[playerid] < MAX_PLAYERS)
		{
			new string[128];
			TransportMoney[TransportDriver[playerid]] += TransportCost[playerid];
			format(string, sizeof(string), "~w~Chi phi di xe~n~~r~$%d",TransportCost[playerid]);
			GameTextForPlayer(playerid, string, 5000, 3);
			format(string, sizeof(string), "~w~Khach da xuong xe.~n~~g~Ban nhan duoc $%d",TransportCost[playerid]);
			GameTextForPlayer(TransportDriver[playerid], string, 5000, 3);
			GivePlayerCash(playerid, -TransportCost[playerid]);

			if(TransportCost[playerid] >= 10000)
			{
				format(string, sizeof(string), "%s (IP:%s) has taxied %s (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(TransportDriver[playerid]), GetPlayerIpEx(TransportDriver[playerid]), TransportCost[playerid]);
				//Log("logs/pay.log", string);
				ABroadCast(COLOR_YELLOW, string, 2);
			}
			TransportTime[TransportDriver[playerid]] = 0;
			TransportCost[TransportDriver[playerid]] = 0;
			TransportCost[playerid] = 0;
			TransportTime[playerid] = 0;
			TransportDriver[playerid] = INVALID_PLAYER_ID;
		}
	}
    if(newstate == PLAYER_STATE_PASSENGER) // TAXI & BUSSES
	{
	    #if defined zombiemode
   		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't go into cars.");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPlayerPos(playerid, X, Y, Z);
			return 1;
		}
		#endif
		fVehSpeed[playerid] = 0;
		fVehHealth[playerid] = 0;
 		if(!isnull(stationidv[GetPlayerVehicleID(playerid)]))
		{
   			PlayAudioStreamForPlayerEx(playerid, stationidv[GetPlayerVehicleID(playerid)]);
		}
        new vehicleid = GetPlayerVehicleID(playerid);
	    /*if(vehicleid == NGVehicles[12] ||
		vehicleid == NGVehicles[13] ||
		vehicleid == NGVehicles[14] ||
		vehicleid == NGVehicles[15] ||
		vehicleid == NGVehicles[16] ||
		vehicleid == NGVehicles[17])
		{
		    TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, vehicleid);
			SetPVarInt(playerid, "NGPassenger", 1);
			SetPVarInt(playerid, "NGPassengerVeh", vehicleid);
			SetPVarInt(playerid, "NGPassengerSkin", GetPlayerSkin(playerid));
			new Float:health, Float:armour;
			GetHealth(playerid, health);
			GetArmour(playerid, armour);
			SetPVarFloat(playerid, "NGPassengerHP", health);
			SetPVarFloat(playerid, "NGPassengerArmor", armour);
		}*/
        if(!IsADriveByWeapon(GetPlayerWeapon(playerid)) && !IsADriveByWeapon(GetPVarInt(playerid, "LastWeapon"))) SetPlayerArmedWeapon(playerid,0);
        //if(PlayerInfo[playerid][pGuns][4] > 0)	SetPlayerArmedWeapon(playerid,PlayerInfo[playerid][pGuns][4]);
		//else SetPlayerArmedWeapon(playerid,0);

	    gLastCar[playerid] = vehicleid;
	    foreach(new i: Player)
		{
			if(IsPlayerInVehicle(i, vehicleid) && GetPlayerState(i) == 2 && TransportDuty[i] > 0)
			{
				if(GetPlayerCash(playerid) < TransportValue[i])
				{
					new string[28];
					format(string, sizeof(string), "* Ban can co $%d de vao.", TransportValue[i]);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					RemovePlayerFromVehicle(playerid);
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(playerid, X, Y, Z);
					SetPlayerPos(playerid, X, Y, Z+2);
					TogglePlayerControllable(playerid, 1);
				}
				else
				{
					new string[35+MAX_PLAYER_NAME];
					if(TransportDuty[i] == 1)
					{
						format(string, sizeof(string), "* Ban tra $%d cho tai xe taxi.", TransportValue[i]);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Hanh khach %s da buoc vao xe taxi.", GetPlayerNameEx(playerid));
						SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
						TransportTime[i] = 1;
						TransportTime[playerid] = 1;
						TransportCost[playerid] = TransportValue[i];
						TransportCost[i] = TransportValue[i];
						TransportDriver[playerid] = i;
					}
					else if(TransportDuty[i] == 2)
					{
						format(string, sizeof(string), "* Ban da tra $%d cho tai xe taxi.", TransportValue[i]);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Hanh khach %s da buoc vao xe taxi.", GetPlayerNameEx(playerid));
						SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
					}
					GivePlayerCash(playerid, - TransportValue[i]);
					TransportMoney[i] += TransportValue[i];
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_WASTED)
	{
	    if(GetPVarInt(playerid, "EventToken") == 0)
	    {
			SetPVarInt(playerid, "MedicBill", 1);
		}
		if(ConnectedToPC[playerid] == 1337)//mdc
	    {
	        ConnectedToPC[playerid] = 0;
		}
		Seatbelt[playerid] = 0;
		if(GetPVarType(playerid, "HelmetOn"))
		{
			for(new i; i < 10; i++) {
				if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "HelmetOn")) {
					PlayerHoldingObject[playerid][i] = 0;
					RemovePlayerAttachedObject(playerid, i);
					DeletePVar(playerid, "HelmetOn");
					break;
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    #if defined zombiemode
    	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't drive.");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			SetPlayerPos(playerid, X, Y, Z);
			return 1;
		}
		#endif
		fVehSpeed[playerid] = 0;
		fVehHealth[playerid] = 0;
	    if(!isnull(stationidv[GetPlayerVehicleID(playerid)]))
		{
   			PlayAudioStreamForPlayerEx(playerid, stationidv[GetPlayerVehicleID(playerid)]);
		}

		SetPlayerArmedWeapon(playerid, 0);

		new
			newcar = GetPlayerVehicleID(playerid),
			engine, lights, alarm, doors, bonnet, boot, objective, v;

		gLastCar[playerid] = newcar;
		if(GetPVarInt(playerid, "EventToken") == 1) {
			if(EventKernel[EventFootRace] == 1) {
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				SetPlayerPos(playerid, X, Y, Z+1.3);
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the vao trong xe va tham gia su kien nay cung mot luc.");
				return 1;
			}
		}
	 	foreach(new i: Player)
		{
			v = GetPlayerVehicle(i, newcar);
			if(v != -1) {
				if(i == playerid) {

					new
						string[128];

					format(string, sizeof(string),"Ban la nguoi so huu cua %s.", GetVehicleName(newcar));
					SendClientMessageEx(playerid, COLOR_GREY, string);
					if(PlayerVehicleInfo[i][v][pvTicket] != 0)
					{
						format(string, sizeof(string),"Chiec xe nay co $%d ve chua thanh toan. Ban phai thanh toan phi tai DMV tai Dilimore.", PlayerVehicleInfo[i][v][pvTicket]);
						SendClientMessageEx(playerid, COLOR_GREY, string);
						SendClientMessageEx(playerid, COLOR_GREY, "Viec khong tra nhung ve nay cang som cang tot se dan den viec bi phat them, tam giu phuong tien hoac tham chi bat giu.");
					}
				}
				else if(i == PlayerInfo[playerid][pVehicleKeysFrom] && v == PlayerInfo[playerid][pVehicleKeys]) {

					new
						string[64 + MAX_PLAYER_NAME];

					format(string, sizeof(string),"Ban nhan duoc chia khoa cua %s tu nguoi chu %s.", GetVehicleName(newcar), GetPlayerNameEx(i));
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
				else if(PlayerVehicleInfo[i][v][pvLocked] == 1 && PlayerVehicleInfo[i][v][pvLock] == 1) {
					GetVehicleParamsEx(newcar,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(newcar,engine,lights,VEHICLE_PARAMS_ON,doors,bonnet,boot,objective);
					SetTimerEx("DisableVehicleAlarm", 20000, 0, "d",  newcar);
				}
				else if(PlayerVehicleInfo[i][v][pvLocked] == 1 && PlayerVehicleInfo[i][v][pvLock] == 2 && PlayerVehicleInfo[i][v][pvLocksLeft] > 0) { // Electronic Lock System

					new
						string[49 + MAX_PLAYER_NAME];

					if(PlayerInfo[playerid][pAdmin] < 2)
					{
						new Float:slx, Float:sly, Float:slz;
						GetPlayerPos(playerid, slx, sly, slz);
						SetPlayerPos(playerid, slx, sly, slz+1.3);
						RemovePlayerFromVehicle(playerid);
						defer NOPCheck(playerid);
					}
					else
					{
						format(string, sizeof(string), "Canh bao: Chiec %s duoc so huu boi %s.", GetVehicleName(newcar), GetPlayerNameEx(i));
						SendClientMessageEx(playerid, COLOR_GREY, string);
					}
				}
				return 1;
			}
		}
		new vehicleid = newcar;
		if(IsVIPcar(vehicleid))
		{
			if(zombieevent)
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				defer NOPCheck(playerid);
				return SendClientMessageEx(playerid, -1, "Ban khong the su dung phuong tien nay khi dang Event Zombie!");
			}
		    if(PlayerInfo[playerid][pDonateRank] > 0)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: Day la mot chiec xe VIP tu nha xe VIP, vi vay no khong bao gio het xang.");
			}
		    else
			{
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+1.3);
				PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
			    RemovePlayerFromVehicle(playerid);
			    defer NOPCheck(playerid);
			    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la VIP, day la phuong tien tu nha xe VIP!");
			}
		}
		else if(IsFamedVeh(vehicleid))
		{
		    if(PlayerInfo[playerid][pFamed] < 1)
		    {
		        new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+1.3);
				PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
			    RemovePlayerFromVehicle(playerid);
			    defer NOPCheck(playerid);
			    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la Famed Member Thanh vien noi tieng, xe nay thuoc Famed Garage!");
			 }
			 else {
			    SendClientMessageEx(playerid, COLOR_YELLOW, "Famed: Day la phuong tien danh cho Famed Member, vi vay no khong bao gio het xang.");
			}
		}
		else if(DynVeh[vehicleid] != -1)
		{
			new string[128], Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			if(DynVehicleInfo[DynVeh[vehicleid]][gv_igID] != INVALID_GROUP_ID && (PlayerInfo[playerid][pMember] != DynVehicleInfo[DynVeh[vehicleid]][gv_igID]))
			{
				RemovePlayerFromVehicle(playerid);
				SetPlayerPos(playerid, slx, sly, slz+1.3);
				defer NOPCheck(playerid);
				if(arrGroupData[DynVehicleInfo[DynVeh[vehicleid]][gv_igID]][g_iGroupType] != 2)
				{
					format(string, sizeof(string), "Ban can phai o trong %s de lai phuong tien nay.", arrGroupData[DynVehicleInfo[DynVeh[vehicleid]][gv_igID]][g_szGroupName]);
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
				}
			}
			else if(DynVehicleInfo[DynVeh[vehicleid]][gv_igDivID] != 0 && PlayerInfo[playerid][pDivision] != DynVehicleInfo[DynVeh[vehicleid]][gv_igDivID] && PlayerInfo[playerid][pMember] != PlayerInfo[playerid][pLeader])
			{
				if(PlayerInfo[playerid][pMember])
				RemovePlayerFromVehicle(playerid);
				SetPlayerPos(playerid, slx, sly, slz+1.3);
				defer NOPCheck(playerid);
				format(string, sizeof(string), "Ban can phai o trong bo phan %s's %s  de lai chiec xe nay.",
				arrGroupData[DynVehicleInfo[DynVeh[vehicleid]][gv_igID]][g_szGroupName],
				arrGroupDivisions[DynVehicleInfo[DynVeh[vehicleid]][gv_igID]][DynVehicleInfo[DynVeh[vehicleid]][gv_igDivID]]);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
			else if(DynVehicleInfo[DynVeh[vehicleid]][gv_irID] > 0 && (PlayerInfo[playerid][pRank] < DynVehicleInfo[DynVeh[vehicleid]][gv_irID]))
			{
				RemovePlayerFromVehicle(playerid);
				SetPlayerPos(playerid, slx, sly, slz+1.3);
				defer NOPCheck(playerid);
				format(string, sizeof(string), "Ban can dat rank %s(%d) hoac cao hon de lai chiec xe nay.",
				arrGroupRanks[DynVehicleInfo[DynVeh[vehicleid]][gv_igID]][DynVehicleInfo[DynVeh[vehicleid]][gv_irID]],
				DynVehicleInfo[DynVeh[vehicleid]][gv_irID]);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
		}
	   	else if(IsAPlane(vehicleid))
		{
	  		if(PlayerInfo[playerid][pFlyLic] != 1)
	  		{
				if(GetPVarInt(playerid, "SprunkGuardLic") == 0)
				{
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz);
					defer NOPCheck(playerid);
					SendClientMessageEx(playerid,COLOR_GREY,"Ban khong co bang lai may bay!");
				}
	  		}
		}
		else if(IsAHelicopter(vehicleid))
		{
		    PlayerInfo[playerid][pAGuns][GetWeaponSlot(46)] = 46;
			GivePlayerValidWeapon(playerid, 46);
		}
		else if(IsAnTaxi(vehicleid) || IsAnBus(vehicleid))
		{
		    if(PlayerInfo[playerid][pJob] == 17 || PlayerInfo[playerid][pJob2] == 17 || PlayerInfo[playerid][pJob3] == 17 || IsATaxiDriver(playerid) || PlayerInfo[playerid][pTaxiLicense] == 1)
			{
			}
			else
			{
				for(new i = 0; i < GetPlayerVehicleSlots(playerid); i++)
				{
					if(IsAnTaxi(PlayerVehicleInfo[playerid][i][pvModelId]))
					return 1;
				}
				SendClientMessageEx(playerid,COLOR_GREY,"   Ban khong phai la tai xe taxi/bus !");
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				defer NOPCheck(playerid);
			}
		}

		if(GetCarBusiness(newcar) != INVALID_BUSINESS_ID && PlayerInfo[playerid][pAdmin] < 1337)
        {
			if(zombieevent)
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				defer NOPCheck(playerid);
				return SendClientMessageEx(playerid, -1, "Ban khong the mua xe trong bat ky dai ly ban xe khi trong su kien zombie!");
			}
            new
				iBusiness = GetCarBusiness(newcar),
				iSlot = GetBusinessCarSlot(newcar),
				string[128];

			if(Businesses[iBusiness][bInventory] == 0) {
			    SendClientMessageEx(playerid,COLOR_GREY,"Dai ly nay da het hang.");
		        RemovePlayerFromVehicle(playerid);
		        new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				defer NOPCheck(playerid);
				return 1;
			}
			format(string, sizeof(string), "Ban co muon mua chiec %s\nChiec xe nay co gia $%s.", GetVehicleName(newcar), number_format(Businesses[iBusiness][bPrice][iSlot]));
		    ShowPlayerDialogEx(playerid,DIALOG_CDBUY,DIALOG_STYLE_MSGBOX,"Buy Vehicle",string,"Buy","Cancel");
		    TogglePlayerControllable(playerid, false);
		    return 1;
        }
	    if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1)
	    {
	        SendClientMessageEx(playerid, COLOR_GRAD1, "Crate Related Commands: /loadforklift /(un)loadplane /cargo /announcetakeoff /cgun /crates /destroycrate /cratelimit");
	        SendClientMessageEx(playerid, COLOR_GRAD1, " /(un)loadcrate /delivercrate");
	    }
		GetVehicleParamsEx(newcar,engine,lights,alarm,doors,bonnet,boot,objective);
		if((engine == VEHICLE_PARAMS_UNSET || engine == VEHICLE_PARAMS_OFF) && GetVehicleModel(newcar) != 509 && GetVehicleModel(newcar) != 481 && GetVehicleModel(newcar) != 510 && (DynVeh[newcar] != -1 && GetVehicleModel(newcar) == 592 && DynVehicleInfo[DynVeh[newcar]][gv_iType] != 1) ) {
			SendClientMessageEx(playerid, COLOR_WHITE, "Dong co phuong tien nay khong chay - Neu ban muon khoi dong no, nhan ~k~~CONVERSATION_YES~.");
		}
		else if((engine == VEHICLE_PARAMS_UNSET || engine == VEHICLE_PARAMS_OFF) && (DynVeh[newcar] != -1 && GetVehicleModel(newcar) == 592 && DynVehicleInfo[DynVeh[newcar]][gv_iType] == 1))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban phai yeu cau giai phong mat bang de cat canh. /announcetakeoff de dua ra yeu cau.");
		}
	}
	if((newstate == 2 || newstate == 3 || newstate == 7 || newstate == 9) && pTazer{playerid} == 1)
	{
		RemovePlayerWeapon(playerid, 23);
		GivePlayerValidWeapon(playerid, pTazerReplace{playerid});
		pTazer{playerid} = 0;
	}
	if(newstate == PLAYER_STATE_SPAWNED)
	{
		if(ConnectedToPC[playerid] == 1337)//mdc
	    {
	        ConnectedToPC[playerid] = 0;
		}
	}
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
		Seatbelt[playerid] = 0;
		if(GetPVarType(playerid, "HelmetOn"))
		{
			for(new i; i < 10; i++) {
				if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "HelmetOn")) {
					PlayerHoldingObject[playerid][i] = 0;
					RemovePlayerAttachedObject(playerid, i);
					DeletePVar(playerid, "HelmetOn");
					break;
				}
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if (_vhudVisible[playerid] == 1)
	{
		HideVehicleHUDForPlayer(playerid);
	}
	if (CarRadars[playerid] > 0)
	{
		PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
		PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
		PlayerTextDrawHide(playerid, _crTickets[playerid]);
		DeletePVar(playerid, "_lastTicketWarning");
	}

	switch(Seatbelt[playerid])
	{
	    case 1:
	    {
			new string[128];
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da coi day an toan.");
			format(string, sizeof(string), "* %s da voi tay thao day an toan cua ho.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
  			Seatbelt[playerid] = 0;
	    }
		case 2:
	    {
			new string[128];
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da coi mu bao hiem cua ban.");
			format(string, sizeof(string), "* %s da voi tay lay mu bao hiem cua ho xuong.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			if(GetPVarType(playerid, "HelmetOn"))
			{
				for(new i; i < 10; i++) {
					if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "HelmetOn")) {
						PlayerHoldingObject[playerid][i] = 0;
						RemovePlayerAttachedObject(playerid, i);
						DeletePVar(playerid, "HelmetOn");
						break;
					}
				}
			}
  			Seatbelt[playerid] = 0;
	    }
	}

	if(GetPVarInt(playerid, "rccam") == 1)
	{
		DestroyVehicle(GetPVarInt(playerid, "rcveh"));
	    SetPlayerPos(playerid, GetPVarFloat(playerid, "rcX"), GetPVarFloat(playerid, "rcY"), GetPVarFloat(playerid, "rcZ"));
		DeletePVar(playerid, "rccam");
	    KillTimer(GetPVarInt(playerid, "rccamtimer"));
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    if(IsPlayerNPC(playerid)) return 1;
	if(gPlayerLogged{playerid} == 1)
	{
		TogglePlayerSpectating(playerid, 0);
		SetTimerEx("ForceSpawn", 10, false, "i", playerid);
	}
	else
	{
		TogglePlayerSpectating(playerid, 1);
		//SetPlayerJoinCamera(playerid);
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	// if(!success) SendClientMessageEx(playerid, COLOR_WHITE, "SERVER: Unknown command. Please use /help to list all available commands.");
	if(result == -1) {

		TextDrawShowForPlayer(playerid, TD_ServerError[1]);
		TextDrawShowForPlayer(playerid, TD_ServerError[0]);

		defer HideServerError(playerid);
	}
	return 1;
}

timer HideServerError[5000](playerid) {

	TextDrawHideForPlayer(playerid, TD_ServerError[1]);
	TextDrawHideForPlayer(playerid, TD_ServerError[0]);
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags) {

	if(gPlayerLogged{playerid} != 1) {
		SendClientMessageEx(playerid, COLOR_RED, "Ban chua dang nhap.");
		return 0;
	}
	if(server_restaring) {
		SendClientMessage(playerid, -1, "Server dang bao tri, vui long thoat khoi tro choi");
		return 0;
	}
	if(GetPVarInt(playerid, "ShopTP") == 1 && strfind(cmd, "arena") != -1) {
		SendClientMessage(playerid, -1, "Dang duoc dich chuyen den GN-Shop, khong the lam dieu nay");
		return 0;
	}
/*
	arrAntiCheat[playerid][ac_iCommandCount]++;
	switch(arrAntiCheat[playerid][ac_iCommandCount]) {
		case 0 .. 6: {}
		default: {
			AC_Process(playerid, AC_CMDSPAM, arrAntiCheat[playerid][ac_iCommandCount]);
			return 0;
		}
	}*/

	playerLastTyped[playerid] = 0;
	printf("[zcmd] [%s]: %s", GetPlayerNameEx(playerid), (strfind(cmd, "changepass", true) == 0 ? ("changepass") : cmd));
	if(PlayerInfo[playerid][pForcePasswordChange] == 1) return ShowLoginDialogs(playerid, 0), 0;
	if(PlayerInfo[playerid][pMuted] == 1) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the noi, ban da im lang!");
		return 0;
	}
	if(CommandSpamUnmute[playerid] != 0) {
		SendClientMessage(playerid, COLOR_WHITE, "Ba da bi tat tieng khi go lenh ngay luc nay.");
		return 0;
	}

	if(GetPVarInt(playerid, "voucherdialog"))
	{
		if(GetPVarInt(playerid, "voucherdialog") == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Please finalize your voucher transaction."), 0;
		new string[128];
		format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) may be attempting to exploit the voucher system. (CMD)", GetPlayerNameEx(playerid), playerid);
		ABroadCast(COLOR_YELLOW, string, 2);
		format(string,sizeof(string),"AdmWarning: %s(%d) (ID: %d) may be attempting to exploit the voucher system. (CMD)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerid);
		Log("logs/vouchers.log", string);
		return 0;
	}

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		if(++CommandSpamTimes[playerid] >= 5) {
			CommandSpamTimes[playerid] = 0;
			CommandSpamUnmute[playerid] = 10;
			SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da bi tat tieng tu dong vi spam. Vui long doi 10 giay va thu lai.");
			SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			return 0;
		}
	}

	if(strfind(params, "|") != -1 || strfind(params, "\n") != -1 || strfind(params, "\r") != -1) {
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung cac ky tu khong chuan trong cac lenh.");
		return 0;
	}

    if (strcmp(GiftCode, "off") != 0 && strfind(cmd, "giftcode") == -1)
    {
		if(strfind(params, GiftCode) != -1)
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the noi cho nguoi khac biet ma qua tang.");
		    return 0;
		}
	}

	if(PlayerInfo[playerid][pAdmin] < 2 && CheckServerAd(params))
	{
		new string[128];
		format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) may be server advertising: '{AA3333}%s{FFFF00}'.", GetPlayerNameEx(playerid), playerid, params);
		ABroadCast(COLOR_YELLOW, string, 2);
		format(string,sizeof(string),"%s(%d) (IP: %s) may be server advertising: '%s'.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), params);
		Log("logs/hack.log", string);
		return 0;
	}
	return 1;
}

/*
public OnPlayerCommandText(playerid, cmdtext[])
{
	return 1;
}
*/

public OnPlayerText(playerid, text[])
{
	szMiscArray[0] = 0;

	text[0] = toupper(text[0]);

	if(gPlayerLogged{playerid} != 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "Ban chua dang nhap.");
		return 0;
	}
	if(server_restaring) {
		SendClientMessage(playerid, -1, "Server dang bao tri, vui long thoat khoi tro choi");
		return 0;
	}
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b"), 0;
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new string[128];
	playerLastTyped[playerid] = 0;

	//if(strcmp("lol", text, true) == 0) return callcmd::me(playerid, "laughs out loud."), 0;

	if(TextSpamUnmute[playerid] != 0)
	{
		if(PlayerInfo[playerid][pAdmin] < 2)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Ban bi tat tieng khi gui van ban ngay bay gio.");
			return 0;
		}
	}

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		if(++TextSpamTimes[playerid] == 5)
		{
			TextSpamTimes[playerid] = 0;
			TextSpamUnmute[playerid] = 10;
			SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da bi tat tieng tu dong vi spam, vui long doi 10 giay va thu lai.");
			SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			return 0;
		}
	}


 	/*Compares last string with current, if the same, alert the staff only on the 3rd command. (Expires after 5 secs)
	if(PlayerInfo[playerid][pAdmin] < 2) {
		new laststring[128];
		if(GetPVarString(playerid, "LastText", laststring, 128)) {
			if(!strcmp(laststring, text, true)) {
				TextSpamTimes[playerid]++;

				if(TextSpamTimes[playerid] == 2) {
					TextSpamTimer[playerid] = 30;
					TextSpamTimes[playerid] = 0;
					format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (ID %d) is spamming with: %s", GetPlayerNameEx(playerid), playerid, text);
					ABroadCast(COLOR_YELLOW, string, 2);
				}
			}
		}
		SetPVarString(playerid, "LastText", text);
	}*/

	if(strfind(text, "|", true) != -1) {
	    SendClientMessageEx(playerid, COLOR_RED, "Ban khong the dung ky tu '|' character trong van ban.");
		return 0;
	}

	if(PlayerInfo[playerid][pMuted] == 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the noi, ban da im lang!");
		return 0;
	}

	if (strcmp(GiftCode, "off") != 0 && strfind(text, "/giftcode") == -1)
    {
		if(strfind(text, GiftCode) != -1)
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the noi nguoi khac biet ma tang qua.");
		    return 0;
		}
	}

	if(PlayerInfo[playerid][pAdmin] < 2 && CheckServerAd(text))
	{
		format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID: %d) may be server advertising: '{AA3333}%s{FFFF00}'.", GetPlayerNameEx(playerid), playerid, text);
		ABroadCast(COLOR_YELLOW, string, 2);
		format(string,sizeof(string),"%s(%d) (IP: %s) may be server advertising: '%s'.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), text);
		Log("logs/hack.log", string);
		return 0;
	}

	if(MarriageCeremoney[playerid] > 0)
	{
		if (strcmp("Yes", text, true) == 0)
		{
			if(GotProposedBy[playerid] != INVALID_PLAYER_ID)
			{
				if(IsPlayerConnected(GotProposedBy[playerid]))
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(GotProposedBy[playerid], giveplayer, sizeof(giveplayer));
					format(string, sizeof(string), "Linh Muc: %s, con co muon lay %s lam vo khong? (Neu co hay nhap 'Yes' - ghi nhung cai khac se bi tu choi).", giveplayer,sendername);
					SendClientMessageEx(GotProposedBy[playerid], COLOR_WHITE, string);
					MarriageCeremoney[GotProposedBy[playerid]] = 1;
					MarriageCeremoney[playerid] = 0;
					GotProposedBy[playerid] = INVALID_PLAYER_ID;
					return 0; // Yeah... no more "YES DILDOS SEX RAPE LOL" broadcast to the whole server
				}
				else
				{
					MarriageCeremoney[playerid] = 0;
					GotProposedBy[playerid] = INVALID_PLAYER_ID;
					return 0;
				}
			}
			else if(ProposedTo[playerid] != INVALID_PLAYER_ID)
			{
				if(IsPlayerConnected(ProposedTo[playerid]))
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(ProposedTo[playerid], giveplayer, sizeof(giveplayer));
					if(PlayerInfo[playerid][pSex] == 1 && PlayerInfo[ProposedTo[playerid]][pSex] == 2)
					{
						format(string, sizeof(string), "Linh Muc: %s va %s, ta tuyen bo tu nay chung con la Vo Chong. Con co the hon co dau.", sendername, giveplayer);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
				   		format(string, sizeof(string), "Linh Muc: %s va %s, ta tuyen bo tu nay chung con la Vo Chong. Con co the hon chu re..", giveplayer, sendername);
						SendClientMessageEx(ProposedTo[playerid], COLOR_WHITE, string);
						format(string, sizeof(string), "Hon nhan: Chung ta co mot cap vo chong rat dang yeu! %s va %s da ket hon voi nhau.", sendername, giveplayer);
						OOCNews(COLOR_PINK, string);
					}
					else if(PlayerInfo[playerid][pSex] == 1 && PlayerInfo[ProposedTo[playerid]][pSex] == 1)
					{
						format(string, sizeof(string), "Linh Muc: %s va %s, ta tuyen bo tu nay chung con la vo Chong. Con co the hon co dau.", sendername, giveplayer);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
				   		format(string, sizeof(string), "Linh Muc: %s va %s, ta tuyen bo tu nay chung con la Vo Chong. Con co the hon chu re.", giveplayer, sendername);
						SendClientMessageEx(ProposedTo[playerid], COLOR_WHITE, string);
						format(string, sizeof(string), "Hon nhan: Chung ta co mot cap Gay de thuong! %s va %s da ket hon voi nhau.", sendername, giveplayer);
						OOCNews(COLOR_PINK, string);
					}
					else if(PlayerInfo[playerid][pSex] == 2 && PlayerInfo[ProposedTo[playerid]][pSex] == 2)
					{
						format(string, sizeof(string), "Linh Muc: %s va %s, ta tuyen bo tu nay chung con la Vo Chong. Con co the hon co dau.", sendername, giveplayer);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
				   		format(string, sizeof(string), "Linh Muc: %s va %s, ta tuyen bo tu nay chung con la Vo Chong. Con co the hon chu re.", giveplayer, sendername);
						SendClientMessageEx(ProposedTo[playerid], COLOR_WHITE, string);
						format(string, sizeof(string), "Hon nhan: Chung ta co mot cap Les de thuong! %s va %s da ket hon voi nhau.", sendername, giveplayer);
						OOCNews(COLOR_PINK, string);
					}
					if(GetPVarInt(playerid, "marriagelastname") == 2)
					{
						new escapedName[MAX_PLAYER_NAME];
						format(string, sizeof(string), "%s_%s", GetFirstName(playerid), GetLastName(ProposedTo[playerid]));
						mysql_escape_string(string, escapedName);
						SetPVarString(playerid, "NewNameRequest", escapedName);
						mysql_format(MainPipeline, string, sizeof(string), "SELECT `Username` FROM `accounts` WHERE `Username`='%e'", string);
						mysql_tquery(MainPipeline, string, "OnApproveName", "ii", playerid, playerid);
					}
					if(GetPVarInt(ProposedTo[playerid], "marriagelastname") == 2)
					{
						new escapedName[MAX_PLAYER_NAME];
						format(string, sizeof(string), "%s_%s", GetFirstName(ProposedTo[playerid]), GetLastName(playerid));
						mysql_escape_string(string, escapedName);
						SetPVarString(ProposedTo[playerid], "NewNameRequest", escapedName);
						mysql_format(MainPipeline, string, sizeof(string), "SELECT `Username` FROM `accounts` WHERE `Username`='%e'", string);
						mysql_tquery(MainPipeline, string, "OnApproveName", "ii", ProposedTo[playerid], ProposedTo[playerid]);
					}
					//MarriageCeremoney[ProposedTo[playerid]] = 1;
					MarriageCeremoney[ProposedTo[playerid]] = 0;
					MarriageCeremoney[playerid] = 0;
					PlayerInfo[ProposedTo[playerid]][pMarriedID] = GetPlayerSQLId(playerid);
					format(PlayerInfo[ProposedTo[playerid]][pMarriedName], MAX_PLAYER_NAME, "%s", sendername);
					PlayerInfo[playerid][pMarriedID] = GetPlayerSQLId(ProposedTo[playerid]);
					format(PlayerInfo[playerid][pMarriedName], MAX_PLAYER_NAME, "%s", giveplayer);
					GivePlayerCash(playerid, - 100000);
					ProposedTo[playerid] = INVALID_PLAYER_ID;
					MarriageCeremoney[playerid] = 0;
					return 0;
				}
				else
				{
					MarriageCeremoney[playerid] = 0;
					ProposedTo[playerid] = INVALID_PLAYER_ID;
					return 0;
				}
			}
		}
		else
		{
			if(GotProposedBy[playerid] != INVALID_PLAYER_ID)
			{
				if(IsPlayerConnected(GotProposedBy[playerid]))
				{
					format(string, sizeof(string), "* Ban khong muon ket hon voi %s, khong duoc noi Yes.", GetPlayerNameEx(GotProposedBy[playerid]));
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					format(string, sizeof(string), "* %s khong muon ket hon voi, khong duoc noi Yes.",GetPlayerNameEx(playerid));
					SendClientMessageEx(GotProposedBy[playerid], COLOR_YELLOW, string);
					return 0;
				}
				else
				{
					MarriageCeremoney[playerid] = 0;
					GotProposedBy[playerid] = INVALID_PLAYER_ID;
					return 0;
				}
			}
			else if(ProposedTo[playerid] != INVALID_PLAYER_ID)
			{
				if(IsPlayerConnected(ProposedTo[playerid]))
				{
					format(string, sizeof(string), "* Ban khong muon ket hon voi %s, khong duoc noi Yes.",GetPlayerNameEx(ProposedTo[playerid]));
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					format(string, sizeof(string), "* %s khong muon ket hon voi ban, khong duoc noi Yes.",GetPlayerNameEx(playerid));
					SendClientMessageEx(ProposedTo[playerid], COLOR_YELLOW, string);
					return 0;
				}
				else
				{
					MarriageCeremoney[playerid] = 0;
					ProposedTo[playerid] = INVALID_PLAYER_ID;
					return 0;
				}
			}
		}
		return 0;
	}
	if(CallLawyer[playerid] == 111)
	{
		if (strcmp("yes", text, true) == 0)
		{
			format(string, sizeof(string), "** %s dang o trong tu, va can mot Luat Su. Hay di den don canh sat.", GetPlayerNameEx(playerid));
			SendJobMessage(2, TEAM_AZTECAS_COLOR, string);
			SendJobMessage(2, TEAM_AZTECAS_COLOR, "* Khi ban den don canh sat, hay yeu cau mot canh sat phe duyet  ban voi lenh /chapnhan lawyer.");
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "Mot tin nhan da gui den tat ca luat su co san, vui long cho.");
			WantLawyer[playerid] = 0;
			CallLawyer[playerid] = 0;
			return 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "Khong co luat su bao chua cho ban nua, thoi gian vao tu bat dau.");
			WantLawyer[playerid] = 0;
			CallLawyer[playerid] = 0;
			return 0;
		}
	}
	if(TalkingLive[playerid] != INVALID_PLAYER_ID)
	{
		if(IsAReporter(playerid))
		{
			format(string, sizeof(string), "Phong vien tin tuc truc tiep %s: %s", GetPlayerNameEx(playerid), text);
			OOCNews(COLOR_LIGHTGREEN, string);
			format(szMiscArray, sizeof(szMiscArray), "[/LIVE] %s (%i): %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), text);
			Log("logs/broadcast.log", szMiscArray);
		}
		else
		{
			format(string, sizeof(string), "Phong van truc tiep khach moi %s: %s", GetPlayerNameEx(playerid), text);
			OOCNews(COLOR_LIGHTGREEN, string);
			format(szMiscArray, sizeof(szMiscArray), "[/LIVE] %s (%i): %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), text);
			Log("logs/broadcast.log", szMiscArray);
		}
		return 0;
	}
	if(Mobile[playerid] != INVALID_PLAYER_ID) 
	{
		if(GetPVarType(playerid, "PayPhone")) {
			format(string, sizeof(string), "(payphone)(unknown) noi: %s", text);
		}
		else format(string, sizeof(string), "(cellphone) %s noi: %s", GetPlayerNameEx(playerid), text);


		ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		if(IsPlayerConnected(Mobile[playerid]))
		{
			if(GetPVarInt(Mobile[playerid], "hCall") == playerid)
			{
				if(PlayerInfo[Mobile[playerid]][pSpeakerPhone] != 0)
				{
				    format(string, sizeof(string), "(speakerphone) Unknown noi: %s",  text);
					ProxDetector(20.0, Mobile[playerid], string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
				}
				else
				{
				    ChatTrafficProcess(Mobile[playerid], COLOR_YELLOW, string, 7);
				}
				if(PlayerInfo[playerid][pBugged] != INVALID_GROUP_ID)
			    {
			    	format(string, sizeof(string), "{8D8DFF}(BUGGED) {CBCCCE}Unknown (cellphone): %s",  text);
			    }
			    else if(PlayerInfo[Mobile[playerid]][pBugged] != INVALID_GROUP_ID){
			    	format(string, sizeof(string), "{8D8DFF}(BUG ID %d) {CBCCCE}Unknown (cellphone): %s", Mobile[playerid], text);
			    }
				SendBugMessage(playerid, PlayerInfo[playerid][pBugged], string);
			}
			else if(Mobile[Mobile[playerid]] == playerid)
			{
				if(PlayerInfo[Mobile[playerid]][pSpeakerPhone] != 0)
				{
				    if(GetPVarType(playerid, "PayPhone")) {
						format(string, sizeof(string), "(speakerphone)(unknown) noi: %s", text);
					}
				    else format(string, sizeof(string), "(speakerphone) %s noi: %s", GetPlayerNameEx(playerid), text);
					ProxDetector(20.0, Mobile[playerid], string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
				}
				else
				{
					ChatTrafficProcess(Mobile[playerid], COLOR_YELLOW, string, 7);
				}
				if(PlayerInfo[playerid][pBugged] != INVALID_GROUP_ID)
			    {
			    	format(string, sizeof(string), "{8D8DFF}(BUGGED) {CBCCCE}%s (cellphone): %s", GetPlayerNameEx(playerid), text);
			    }
			    else if(PlayerInfo[Mobile[playerid]][pBugged] != INVALID_GROUP_ID){
			    	format(string, sizeof(string), "{8D8DFF}(BUG ID %d) {CBCCCE}%s (cellphone): %s", Mobile[playerid], GetPlayerNameEx(playerid), text);
			    }
				SendBugMessage(playerid, PlayerInfo[playerid][pBugged], string);
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_YELLOW,"There's nobody there!");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			RemovePlayerAttachedObject(playerid, 8);
			Mobile[playerid] = INVALID_PLAYER_ID;
		}
		return 0;
	}

	sendername = GetPlayerNameEx(playerid);

	if(GetPVarType(playerid, "IsInArena"))
	{
		new a = GetPVarInt(playerid, "IsInArena");
		if(PaintBallArena[a][pbGameType] == 2 || PaintBallArena[a][pbGameType] == 3 || PaintBallArena[a][pbGameType] == 5)
		{
			if(PlayerInfo[playerid][pPaintTeam] == 1)
			{
				format(string, sizeof(string), "[Paintball Arena] ({FF0000}Red Team{FFFFFF}) %s noi: %s", sendername, text);
			}
			if(PlayerInfo[playerid][pPaintTeam] == 2)
			{
				format(string, sizeof(string), "[Paintball Arena] ({0000FF}Blue Team{FFFFFF}) %s noi: %s", sendername, text);
			}
		}
		else
		{
			format(string, sizeof(string), "[Dau truong] %s noi: %s", sendername, text);
		}
		SendPaintballArenaMessage(a, COLOR_WHITE, string);
		return 0;
	}

	new accent[32];

	switch(PlayerInfo[playerid][pAccent])
	{
		case 0, 1: accent = "";
		case 2: accent = "(Ha Noi) ";
		case 3: accent = "(Da Nang) ";
		case 4: accent = "(Sai Gon) ";
		case 5: accent = "(Han Quoc) ";
		case 6: accent = "(Tau Khua) ";
		case 7: accent = "(Han Xeng) ";
		case 8: accent = "(Sadboiz) ";
		case 9: accent = "(Trau Tre) ";
		case 10: accent = "(Mien Nam) ";
		case 11: accent = "(Mien Bac) ";
		case 12: accent = "(Mien Trung) ";
		case 13: accent = "(Mien Tay) ";
		case 14: accent = "(Gangsta) ";
		case 15: accent = "(Gay) ";
		case 16: accent = "(Bede) ";
		case 17: accent = "(Mr) ";
		case 18: accent = "(Mrs) ";
		case 19: accent = "(Police) ";
		case 20: accent = "(Doctor) ";
		case 21: accent = "(Grab) ";
		case 22: accent = "(Taxi) ";
		case 23: accent = "(HotBoy) ";
		case 24: accent = "(HotGirl) ";
		case 25: accent = "(Dang Cap) ";
		case 26: accent = "(An Xin) ";
		case 27: accent = "(Dan Choi) ";
		case 28: accent = "(Super) ";
		case 29: accent = "(Sieu Nhan) ";
		case 21515: accent = "{5F773F}OS{E6E6E6} ";
		case 32215: accent = "{FFE900}GTANetwork{E6E6E6} ";
		case 54561873: accent = "{96281B}Admin{E6E6E6} ";
		case 99697894: accent = "{C650F4}VIP{E6E6E6} ";
		case 49518: accent = "{DB1A1A}Hypebeast{E6E6E6} "; // Temira Vo
		case 95418: accent = "{FF6BFA}SipHong{E6E6E6} "; // Ngoc Tienn
		case 35854: accent = "{FFE900}Proplayer{E6E6E6} ";
		case 25842: accent = "{FFE900}FendiGang{E6E6E6} ";
		case 14841: accent = "{FFA8fc}GucciGang{E6E6E6} ";
		case 27101: accent = "{FF6524}SUPER{E6E6E6} ";
		case 10172: accent = "{F5A442}My name is{E6E6E6} ";
		case 271001: accent = "{ffdc52}Nguyen{E6E6E6} ";
		case 128942: accent = "{fa57ab}SouthSide{E6E6E6} "; // Samuel Buzikk
		case 45981: accent = "{CCFFCC}Developer{E6E6E6} "; 
		case 98132: accent = "{6ff542}Morgan{E6E6E6} "; // Quang Hac
		case 339900: accent = "{339900}Stoner{E6E6E6} "; 
		case 813184: accent = "{267a38}Cam Ranh{E6E6E6} ";
		case 215485: accent = "{5493ff}Police{E6E6E6} ";
		case 875851: accent = "{ff52d9}Korea{E6E6E6} ";

	}

	if(!GetPVarType(playerid, "WatchingTV")) {

		new Float: f_playerPos[3];
		GetPlayerPos(playerid, f_playerPos[0], f_playerPos[1], f_playerPos[2]);
		new str[128];
		foreach(new i: Player)
		{
			if((InsidePlane[playerid] == GetPlayerVehicleID(i) && GetPlayerState(i) == 2) || (InsidePlane[i] == GetPlayerVehicleID(playerid) && GetPlayerState(playerid) == 2) || (InsidePlane[playerid] != INVALID_VEHICLE_ID && InsidePlane[playerid] == InsidePlane[i])) {
				//if(PlayerInfo[playerid][pDuty] || IsAHitman(playerid)) format(string, sizeof(string), "%s{%06x}%s{E6E6E6} says: %s", accent, GetPlayerColor(playerid), sendername, text);
				format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
				SendClientMessageEx(i, COLOR_FADE1, string);
			}
			else if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) {
				if(IsPlayerInRangeOfPoint(i, 20.0 * 0.6, f_playerPos[0], f_playerPos[1], f_playerPos[2]) && PlayerInfo[i][pBugged] >= 0)
				{
					if(playerid == i)
					{
						format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
						format(str, sizeof(str), "{8D8DFF}(BUGGED) {CBCCCE}%s", string);
					}
					else {
						format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
						format(str, sizeof(str), "{8D8DFF}(BUG ID %d) {CBCCCE}%s", i,string);
					}
					if(PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pTogReports] == 1 || PlayerInfo[playerid][pAdmin] < 2 || PlayerInfo[i][pAdmin] >= 2 && PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2) SendBugMessage(i, PlayerInfo[i][pBugged], str);
				}
				if(IsPlayerInRangeOfPoint(i, 20.0, f_playerPos[0], f_playerPos[1], f_playerPos[2]) && PlayerInfo[playerid][pAccountRestricted] == 1)
				{
					format(string, sizeof(string), "[Restricted] %s: %s", GetPlayerNameEx(playerid), text);
					SendClientMessageEx(i, COLOR_FADE5, string);
				}
				else if(IsPlayerInRangeOfPoint(i, 20.0 / 16, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
					SendClientMessageEx(i, COLOR_FADE1, string);
				}
				else if(IsPlayerInRangeOfPoint(i, 20.0 / 8, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
					SendClientMessageEx(i, COLOR_FADE2, string);
				}
				else if(IsPlayerInRangeOfPoint(i, 20.0 / 4, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
					SendClientMessageEx(i, COLOR_FADE3, string);
				}
				else if(IsPlayerInRangeOfPoint(i, 20.0 / 2, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
					SendClientMessageEx(i, COLOR_FADE4, string);
				}
				else if(IsPlayerInRangeOfPoint(i, 20.0, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
					SendClientMessageEx(i, COLOR_FADE5, string);
				}
			}
			if(GetPVarInt(i, "BigEar") == 1 || GetPVarInt(i, "BigEar") == 6 && GetPVarInt(i, "BigEarPlayer") == playerid) {
				format(string, sizeof(string), "%s%s noi: %s", accent, sendername, text);
				new string2[128] = "(BE) ";
				strcat(string2,string, sizeof(string2));
				SendClientMessageEx(i, COLOR_FADE1, string);
			}
		}
	}
	SetPlayerChatBubble(playerid, text, COLOR_WHITE, 20.0, 5000);

	format(string, sizeof(string), "(BE) %s: %s", GetPlayerNameEx(playerid), text);
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] > 1 && GetPVarInt(i, "BigEar") == 3)
		{
			SendClientMessageEx(i, COLOR_WHITE, string);
		}
	}
	return 0;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	if(DynVeh[vehicleid] != -1)
	{
	    new vw[1];
		vw[0] = GetVehicleVirtualWorld(vehicleid);
	    if(DynVehicleObjInfo[DynVeh[vehicleid]][1][gv_iAttachedObjectModel] != INVALID_OBJECT_ID)
	    {
	    	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleObjInfo[DynVeh[vehicleid]][0][gv_iAttachedObjectID], E_STREAMER_WORLD_ID, vw[0]);

		}
		if(DynVehicleObjInfo[DynVeh[vehicleid]][0][gv_iAttachedObjectModel] != INVALID_OBJECT_ID)
	    {
			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleObjInfo[DynVeh[vehicleid]][1][gv_iAttachedObjectID], E_STREAMER_WORLD_ID, vw[0]);
		}
	}
	return 0;
}

public OnPlayerModelSelectionEx(playerid, response, extraid, modelid, extralist_id) {
	//balo
	if(extraid == INVENTORY_MENU)
    {
	    if(response)
		    {
		        if(modelid == 19198) return SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Trong.");

		        if(modelid == 21001) // Skin ID: 21001
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
		        if(modelid == 21002) // Skin ID: 21002
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN2, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
		        if(modelid == 21003) // Skin ID: 21003
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN3, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21004) // Skin ID: 21004
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN4, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21005) // Skin ID: 21005
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN5, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21006) // Skin ID: 21006
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN6, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21014) // Skin ID: 21014
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN7, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21015) // Skin ID: 21015
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN8, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21016) // Skin ID: 21016
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN9, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21017) // Skin ID: 21017
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN10, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21018) // Skin ID: 21018
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN11, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21019) // Skin ID: 21019
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN12, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21020) // Skin ID: 21020
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN13, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21021) // Skin ID: 21021
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN14, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21022) // Skin ID: 21022
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN15, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21049) // Skin ID: 21049
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN16, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21050) // Skin ID: 21050
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN17, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21051) // Skin ID: 21051
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN18, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21052) // Skin ID: 21052
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN19, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21053) // Skin ID: 21053
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN20, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21054) // Skin ID: 21054
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN21, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21083) // Skin ID: 21083
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN22, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21084) // Skin ID: 21084
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN23, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
				if(modelid == 21085) // Skin ID: 21085
		        {
		            ShowPlayerDialog(playerid, ITEM_SKIN24, DIALOG_STYLE_LIST, "[BALO] Trang phuc", "Su dung trang phuc\n{FF0000}Vut trang phuc\nThong tin trang phuc", "Chon", "Thoat");
		        }
		   	}
        else SendClientMessage(playerid,-1, "[{F5CB42}BALO{FFFFFF}] Ban da dong balo.");
    }
	//balo
	if(extraid == 1500 && response) {

		new iGroup = PlayerInfo[playerid][pMember];
		for(new i; i < MAX_BARRICADES; i++)
		{
			if(Barricades[iGroup][i][sX] == 0 && Barricades[iGroup][i][sY] == 0 && Barricades[iGroup][i][sZ] == 0)
			{
				new Float: f_TempAngle;

				GetPlayerPos(playerid, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ]);
				GetPlayerFacingAngle(playerid, f_TempAngle);

				switch(modelid)
				{
					case 981: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(981, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ], 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 2, Barricades[iGroup][i][sY] + 2, Barricades[iGroup][i][sZ] + 2);
					}
					case 4504: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(4504, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] + 1.6996, 0.0, 0.0, f_TempAngle + 270);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 10, Barricades[iGroup][i][sY] + 10, Barricades[iGroup][i][sZ] + 5);
					}
					case 4505: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(4505, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] + 1.6996, 0.0, 0.0, f_TempAngle + 270);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 10, Barricades[iGroup][i][sY] + 10, Barricades[iGroup][i][sZ] + 5);
					}
					case 4514: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(4514, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] + 1.2394, 0.0, 0.0, f_TempAngle + 270);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 10, Barricades[iGroup][i][sY] + 10, Barricades[iGroup][i][sZ] + 5);
					}
					case 4526: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(4526, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] + 0.7227, 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 10, Barricades[iGroup][i][sY] + 10, Barricades[iGroup][i][sZ] + 5);
					}
					case 978: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(978, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ], 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 2, Barricades[iGroup][i][sY] + 2, Barricades[iGroup][i][sZ]);
					}
					case 979: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(979, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ], 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 2, Barricades[iGroup][i][sY] + 2, Barricades[iGroup][i][sZ]);
					}
					case 3091: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(3091, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] - 0.30, 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 2, Barricades[iGroup][i][sY] + 2, Barricades[iGroup][i][sZ]);
					}
					case 1459: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(1459, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] - 0.40, 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 2, Barricades[iGroup][i][sY] + 2, Barricades[iGroup][i][sZ]);
					}
					case 1423: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(1423, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] - 0.35, 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 2, Barricades[iGroup][i][sY] + 2, Barricades[iGroup][i][sZ]);
					}
					case 1424: {
						Barricades[iGroup][i][sObjectID] = CreateDynamicObject(1424, Barricades[iGroup][i][sX], Barricades[iGroup][i][sY], Barricades[iGroup][i][sZ] - 0.35, 0.0, 0.0, f_TempAngle);
						SetPlayerPos(playerid, Barricades[iGroup][i][sX] + 2, Barricades[iGroup][i][sY] + 2, Barricades[iGroup][i][sZ]);
					}
				}
				GetPlayer3DZone(playerid, Barricades[iGroup][i][sDeployedAt], MAX_ZONE_NAME);
				Barricades[iGroup][i][sDeployedBy] = GetPlayerNameEx(playerid);
				if(PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pTogReports] != 1) Barricades[iGroup][i][sDeployedByStatus] = 1;
				else Barricades[iGroup][i][sDeployedByStatus] = 0;
				format(szMiscArray, sizeof(szMiscArray), "Barricade ID: %d successfully created.", i);
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				/*format(string, sizeof(string), "** HQ: A barricade has been deployed by %s at %s **", GetPlayerNameEx(playerid), Barricades[iGroup][i][sDeployedAt]);
				foreach(new x: Player)
				{
					if(PlayerInfo[x][pToggledChats][12] == 0)
					{
						if(PlayerInfo[x][pMember] == iGroup) SendClientMessageEx(x, arrGroupData[iGroup][g_hRadioColour] * 256 + 255, string);
						if(GetPVarInt(x, "BigEar") == 4 && GetPVarInt(x, "BigEarGroup") == iGroup)
						{
							new szBigEar[128];
							format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
							SendClientMessageEx(x, arrGroupData[iGroup][g_hRadioColour] * 256 + 255, szBigEar);
						}
					}
				}*/
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "Unable to spawn more barricades, limit is " #MAX_BARRICADES# ".");
		return 1;
	}
	/*
	if(extraid == 1505) {

		if(response) {
			SetPVarInt(playerid, PVAR_FURNITURE_BUYMODEL, modelid);
			format(szMiscArray, sizeof(szMiscArray), "Ban co muon mua cai %s voi $%s va %s vat lieu khong?", GetFurnitureName(modelid), number_format(GetFurniturePrice(modelid)), number_format(GetFurniturePrice(modelid) / 10));
			ShowPlayerDialogEx(playerid, DIALOG_FURNITURE_BUYCONFIRM, DIALOG_STYLE_MSGBOX, "Furniture Menu | Confirm Purchase", szMiscArray, "Buy", "Cancel");
		}
		else {
			FurnitureMenu(playerid, 0);
		}
	}
	*/
	if(extraid == DYNAMIC_FAMILY_CLOTHES)
	{
		if(response)
		{
			PlayerInfo[playerid][pModel] = modelid;
			SetPlayerSkin(playerid, modelid);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da thay quan ao.");
		}
		else
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban thoat khoi menu chon quan ao.");
	}
	else if(extraid == 1338)
	{
		if(response)
		{
			if(modelid == 1654) PlayerInfo[playerid][pC4] = CreateDynamicObject(modelid, GetPVarFloat(playerid, "DYN_C4_FLOAT_X"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Y"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Z")-0.9, 0, 89.325012207031, 3.9700012207031);
			else PlayerInfo[playerid][pC4] = CreateDynamicObject(modelid, GetPVarFloat(playerid, "DYN_C4_FLOAT_X"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Y"), GetPVarFloat(playerid, "DYN_C4_FLOAT_Z")-0.7, 0, 0, 0);
			ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
			ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
			PlayerInfo[playerid][pBombs]--;
			PlayerInfo[playerid][pC4Used] = 1;
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da dat c4 tren mat dat, /pickupbomb de xoa no.");
		}
		else
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da thoat khoi menu chon bom.");
		}
	}
	else if(extraid == 1339)
	{
		if(response)
		{
			if(GetSpecialPlayerToyCountEx(playerid, 2) > 7)
				return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban chi co the so huu toi da 8 mu bao hiem.");
			new i, string[144];
			for(i = 0; i < MAX_PLAYERTOYS; i++)
			{
				if(PlayerToyInfo[playerid][i][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][i][ptModelID] =  modelid;
					PlayerToyInfo[playerid][i][ptBone] = 2;
					PlayerToyInfo[playerid][i][ptPosX] = 0.07;
					PlayerToyInfo[playerid][i][ptPosY] = 0.0;
					PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][i][ptRotX] = 88.0;
					PlayerToyInfo[playerid][i][ptRotY] = 75.0;
					PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleX] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleY] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleZ] = 0.0;
					PlayerToyInfo[playerid][i][ptTradable] = 1;
					PlayerToyInfo[playerid][i][ptSpecial] = 2; // New special object with actual functionality

					g_mysql_NewToy(playerid, i);

					SetPVarInt(playerid, "ToySlot", i);
					ShowEditMenu(playerid);

					new iBusiness = GetPVarInt(playerid, "businessid");
					new cost = GetPVarInt(playerid, "helcost");
					new iItem = GetPVarInt(playerid, "item")-1;
					Businesses[iBusiness][bInventory]-= StoreItemCost[iItem][ItemValue];
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
					//if(penalty) Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
					GivePlayerCash(playerid, -cost);
					if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++;
					SaveBusiness(iBusiness);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					if (PlayerInfo[playerid][pDonateRank] >= 1)
					{
						format(string,sizeof(string),"VIP: Ban nhan duoc 20 phan tram giam gia san pham thay vi tra tien $%s, ban da tra $%s.", number_format(Businesses[iBusiness][bItemPrices][iItem]), number_format(cost));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					format(string,sizeof(string),"%s(%d) (IP: %s) has bought a Helmet in %s (%d) for $%s.",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[iBusiness][bName], iBusiness, number_format(cost));
					Log("logs/business.log", string);
					format(string,sizeof(string),"* Ban da mua non bao hiem tu %s voi $%s, Bay gio ban co the doi mu bao hiem voi /helmet(/hm).", Businesses[iBusiness][bName], number_format(cost));
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					new playersold = GetPVarInt(playerid, "playersold");
					if(playersold)
					{
						DeletePVar(playerid, "Business_ItemType");
						DeletePVar(playerid, "Business_ItemPrice");
						DeletePVar(playerid, "Business_ItemOfferer");
						DeletePVar(playerid, "Business_ItemOffererSQLId");
					}
					SendClientMessageEx(playerid, COLOR_RED, "Luu y: Xin luu y rang day la mot do choi thuc te voi chuc nang, no khong anh huong so luong do choi cua ban va ban co the so huu.");
					break;
				}
			}
			if(i == MAX_PLAYERTOYS) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the co do choi nua, xin vui long xoa mot 1 cai.");
		}
		else
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da thoat khoi menu chon mu bao hiem.");
	}
	else if(extraid == 2000)
	{
		if(response)
		{
			new toycount = GetFreeToySlot(playerid), string[144];
			if(toycount == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the gan hon 10 do vat, vui long thao mot cai de su dung mu bao hiem .");
			if(toycount == 9 && PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the gan do choi khac vao o vi ban da trang bi balo.");

			if(PlayerToyInfo[playerid][extralist_id][ptScaleX] == 0) {
				PlayerToyInfo[playerid][extralist_id][ptScaleX] = 1.0;
				PlayerToyInfo[playerid][extralist_id][ptScaleY] = 1.0;
				PlayerToyInfo[playerid][extralist_id][ptScaleZ] = 1.0;
			}
			new name[24];
			format(name, sizeof(name), "Unknown");

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][extralist_id][ptModelID])
				{
					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			format(string, sizeof(string), "Da trang bi thanh cong %s(%d) (Bone: %s) (Slot: %d)", name, PlayerToyInfo[playerid][extralist_id][ptModelID], HoldingBones[PlayerToyInfo[playerid][extralist_id][ptBone]], extralist_id);
			SendClientMessageEx(playerid, COLOR_RED, string);
			SetPVarInt(playerid, "HelmetOn", extralist_id);
			PlayerHoldingObject[playerid][toycount] = extralist_id;
			SetPlayerAttachedObject(playerid, toycount, PlayerToyInfo[playerid][extralist_id][ptModelID], PlayerToyInfo[playerid][extralist_id][ptBone], PlayerToyInfo[playerid][extralist_id][ptPosX], PlayerToyInfo[playerid][extralist_id][ptPosY], PlayerToyInfo[playerid][extralist_id][ptPosZ],
			PlayerToyInfo[playerid][extralist_id][ptRotX], PlayerToyInfo[playerid][extralist_id][ptRotY], PlayerToyInfo[playerid][extralist_id][ptRotZ], PlayerToyInfo[playerid][extralist_id][ptScaleX], PlayerToyInfo[playerid][extralist_id][ptScaleY], PlayerToyInfo[playerid][extralist_id][ptScaleZ]);

			Seatbelt[playerid] = 2;
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s da voi lay mu bao hiem cua ho va doi len dau.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi mu bao hiem.");
		}
		else
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da thoat khoi menu chon mu bao hiem.");
	}
	else if(extraid == DIALOG_STPATRICKSSHOP) // St Patrick's Day
	{
		if(!response) return 1;
		new name[24] = "None";
		for(new i; i < sizeof(HoldingObjectsAll); i++)
		{
			if(HoldingObjectsAll[i][holdingmodelid] == modelid)
			{
				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				break;
			}
		}
		format(szMiscArray, sizeof(szMiscArray),"Item: %s\nYour Credits: %s\nCost: {FFD700}150{A9C4E4}\nCredits Left: %s", name, number_format(PlayerInfo[playerid][pCredits]), number_format(PlayerInfo[playerid][pCredits]-150));
		SetPVarInt(playerid, "StPatrickToy", modelid);
		ShowPlayerDialogEx(playerid, DIALOG_STPATRICKSSHOP, DIALOG_STYLE_MSGBOX, "St Patrick's Day Shop", szMiscArray, "Purchase", "Exit");
	}
	else if(extraid == 0525) // Memorial's Day
	{
		if(!response) return 1;
		new name[24] = "None";
		for(new i; i < sizeof(HoldingObjectsAll); i++)
		{
			if(HoldingObjectsAll[i][holdingmodelid] == modelid)
			{
				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				break;
			}
		}
		format(szMiscArray, sizeof(szMiscArray),"Item: %s\nYour Credits: %s\nCost: {FFD700}150{A9C4E4}\nCredits Left: %s", name, number_format(PlayerInfo[playerid][pCredits]), number_format(PlayerInfo[playerid][pCredits]-150));
		SetPVarInt(playerid, "MemorialToy", modelid);
		ShowPlayerDialogEx(playerid, 0525, DIALOG_STYLE_MSGBOX, "Memorial's Day Shop", szMiscArray, "Purchase", "Exit");
	}
	/*
	if(extraid == REGISTER_SKINMODEL)
	{
		if(response)
		{
			PlayerInfo[playerid][pModel] = modelid;
			Register_CreatePlayer(playerid, modelid);
		}
		Register_MainMenu(playerid);
	}
	*/
	if(extraid == PRISON_SKINSELECT)
	{
		if(response)
		{
			if(GetPVarInt(playerid, "pPrisonSelectingSkin") == 1)
			{
			    if(PlayerInfo[playerid][pPrisonCredits] >= 250)
                {
                    PlayerInfo[playerid][pModel] = modelid;
                    PlayerInfo[playerid][pPrisonCredits] -= 250;
					SetPlayerSkin(playerid, modelid);
					SetPVarInt(playerid, "pPrisonSelectingSkin", 0);

					SendClientMessageEx(playerid, COLOR_GREY, "Ban da mua 1 bo quan ao tu cua hang nha tu voi gia 500 credits.");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "  Ban khong co du Prison Credits!");
			}
			else return 1;
		}
		else SetPVarInt(playerid, "pPrisonSelectingSkin", 0);
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if((PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pSMod] >= 2) && source == CLICK_SOURCE_SCOREBOARD)
	{
		new szString[5], string[MAX_PLAYER_NAME+82];
		format(szString, sizeof(szString), "%i", clickedplayerid);
		format(string, sizeof(string), "Ban co muon de nghi  %s doi ten mien phi?", GetPlayerNameEx(clickedplayerid));
		SetPVarString(playerid, "nrn", szString);
		ShowPlayerDialogEx(playerid, DIALOG_NRNCONFIRM, DIALOG_STYLE_MSGBOX, "Confirm this NRN", string, "Yes", "No");
	}
	return true;
}
