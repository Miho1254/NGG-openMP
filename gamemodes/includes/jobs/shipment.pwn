/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Shipment System

				GTA.Network, LLC
	(created by GTA.Network Development Team)

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

#include <YSI\y_hooks>

forward HijackTruck(playerid);
public HijackTruck(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
  	new business = TruckDeliveringTo[vehicleid];

	SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "Hay doi ~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay de cuop hang", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);
	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("HijackTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);
  		DeletePVar(playerid, "LoadTruckTime");

        if(!IsPlayerInVehicle(playerid, vehicleid))
        {
			TruckUsed[playerid] = INVALID_VEHICLE_ID;
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
 			DisablePlayerCheckpoint(playerid);
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Ban da that bai khi dang cuop hang.");
			return 1;
        }


		foreach(new i: Player)
		{
			if(TruckUsed[i] == vehicleid)
			{
				DeletePVar(i, "LoadTruckTime");
				TruckUsed[i] = INVALID_VEHICLE_ID;
				DisablePlayerCheckpoint(i);
				gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
				SendClientMessageEx(i, COLOR_WHITE, "Chuyen hang cua ban da that bai vi da bi ai do cuop!");
			}
		}

  		TruckUsed[playerid] = vehicleid;
  		if(!IsABoat(vehicleid))
  		{
			new route = TruckRoute[vehicleid];
			SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			switch(TruckContents{vehicleid}) {
			    case 0: {
			        if(business != INVALID_BUSINESS_ID)
			        {
						format(string, sizeof(string), "Ban da cuop chuyen hang cua %s", GetInventoryType(TruckDeliveringTo[vehicleid]));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

				        SetPlayerCheckpoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2], 10.0);
					}
				}
				case 1: {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang food & beverages.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang clothing.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang materials.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang 24/7 items.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang weapons - Hay can than canh sat!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang drugs - Hay can than canh sat!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang illegal materials - Hay can than canh sat!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh bao: Hay can than nhung ten cuop, no co the cuop hang cua ban day!");
		}
		else
		{
		    SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			new route = TruckRoute[vehicleid];
			switch(TruckContents{vehicleid}) {
				case 1: {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang food & beverages.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang clothing.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang materials.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang 24/7 items.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang weapons - Hay can than canh sat!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang drugs - Hay can than canh sat!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop chuyen hang illegal materials - Hay can than canh sat!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				default: return SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle is not loaded with hijackable goods.");
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh bao: Hay can than nhung ten cuop, no co the cuop hang cua ban day!");
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Giao hang den diem chi dinh (xem diem danh dau mau do tren radar).");
	}
	return 1;
}

forward LoadTruckOld(playerid);
public LoadTruckOld(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "Hay doi ~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay de chat hang", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new truckdeliver = GetPVarInt(playerid, "TruckDeliver");
  		TruckContents{vehicleid} = truckdeliver;
  		TruckUsed[playerid] = vehicleid;
  		if(!IsABoat(vehicleid))
  		{
	  		new route = random(sizeof(TruckerDropoffs));
	  		TruckRoute[vehicleid] = route;
			// 1 = food and bev
			// 2 = clothing
			// 3 = legal mats
			// 4 = 24/7 items
			// 5 = weapons
			// 6 = illegal drugs
			// 7 = illegal materials
			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Xe tai cua ban da duoc chat day food & beverages.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Xe tai cua ban da duoc chat day clothing.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Xe tai cua ban da duoc chat day materials.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Xe tai cua ban da duoc chat day 24/7 items.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Xe tai cua ban da duoc chat day weapons.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Xe tai cua ban da duoc chat day drugs.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Xe tai cua ban da duoc chat day illegal materials.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh bao : Can than tui cuop truck, tui no co the lay hang cua ban va kiem tien");
		}
		else
		{
			new route = random(sizeof(BoatDropoffs));
	  		TruckRoute[vehicleid] = route;

			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban da duoc chat day food & beverages.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban da duoc chat day clothing.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban da duoc chat day materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban da duoc chat day 24/7 items.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban da duoc chat day weapons.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban da duoc chat day drugs.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban da duoc chat day illegal materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh bao: Canh giac voi nhung ke cuop thuyen, ho co the cuop thuyen va lay di hang hoa.");
		}
		if(truckdeliver >= 5)
		{
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh bao #2: Ban dang giao hang cam , hay can than voi canh sat.");
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Giao hang den diem chi dinh (xem diem danh dau mau do tren radar).");
		SetPVarInt(playerid, "tpTruckRunTimer", 30);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}

forward LoadTruck(playerid);
public LoadTruck(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "Hay doi ~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay de chat hang", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new business = TruckDeliveringTo[vehicleid];
  		TruckUsed[playerid] = vehicleid;


		gPlayerCheckpointStatus[playerid] = CHECKPOINT_DELIVERY;

		format(string, sizeof(string), "* Xe tai cua ban da duoc chat day %s", GetInventoryType(business));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

        SetPlayerCheckpoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2], 10.0);

		SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Deliver the goods to the specified location (see checkpoint on radar).");
		SendClientMessageEx(playerid, COLOR_REALRED, "Canh bao : Can than tui cuop truck, tui no co the lay hang cua ban va kiem tien");

		if (Businesses[business][bType] == BUSINESS_TYPE_GUNSHOP)
		{
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING #2: You are transporting illegal goods so watch out for law enforcement.");
		}
		else if (Businesses[business][bType] == BUSINESS_TYPE_GASSTATION)
		{
		  	new Float:x, Float:y, Float:z, Float:ang;
		  	SetVehiclePos(vehicleid, -1570.9833,96.7547,4.1442);
		  	SetVehicleZAngle(vehicleid, 136.18);
		    GetPlayerPos(playerid, x, y, z);
		    GetVehicleZAngle(vehicleid, ang);
		    new iTrailer = CreateVehicle(584, x, y, z+1, ang, -1, -1, 1000);
		    SetPVarInt(playerid, "Gas_TrailerID", iTrailer);
			SetTimerEx("AttachGasTrailer", 500, false, "ii", iTrailer, vehicleid);
		}
		/*else if (Businesses[business][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP)
		{
			new iModel, iSlot;
		    for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
		    {
			    if (Businesses[business][DealershipVehOrder][i]) {
					iModel = Businesses[business][bModel][i];
					iSlot = i;
	 			}
		    }
			new Float: fVehPos[4];
			GetVehiclePos(vehicleid, fVehPos[0], fVehPos[1], fVehPos[2]);
			GetVehicleZAngle(vehicleid, fVehPos[3]);
			new iDeliveredVeh = CreateVehicle(iModel, fVehPos[0], fVehPos[1], fVehPos[2] + 3, fVehPos[3], 1, 1, -1);
			SetVehicleZAngle(iDeliveredVeh, fVehPos[3]);
			vehicle_lock_doors(iDeliveredVeh);

			SetPVarInt(playerid, "CarryingVehicle", iDeliveredVeh);
			SetPVarInt(playerid, "CarryingSlot", iSlot);
		} */
		SetPVarInt(playerid, "tpTruckRunTimer", floatround(GetPlayerDistanceFromPoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2]) / 100));
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}

stock DisplayOrders(playerid)
{
	new szDialog[2048];
	for (new i, j; i < MAX_BUSINESSES; i++)
	{
	    if (Businesses[i][bOrderState] == 1)
	    {
	        if(Businesses[i][bType] > 0)
	        {
		    	format(szDialog, sizeof(szDialog), "%s%s\t%s\n", szDialog, Businesses[i][bName], GetInventoryType(i));
				ListItemTrackId[playerid][j++] = i;
			}
		}
	}

	if (!szDialog[0] || IsABoat(GetPlayerVehicleID(playerid)))
	{

		/*ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Error", "No jobs available right now. Try again later.", "OK", "");
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid, "IsFrozen"); */
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 456 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 414 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 413 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 440 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 482 || IsABoat(GetPlayerVehicleID(playerid)))
		{
			ShowPlayerDialogEx(playerid,DIALOG_LOADTRUCKOLD,DIALOG_STYLE_LIST,"Ban muon van chuyen gi?","{00F70C}Hop phap {FFFFFF}(khong rui ro nhung khong co thuong)\n{FF0606}Hang cam {FFFFFF}(rui ro nhung co thuong)","Select","Cancel");
		}
		else
		{
			ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Error", "Khong co viec lam cho loai xe tai nay ngay bay gio , thu lai sau.", "OK", "");
			TogglePlayerControllable(playerid, 1);
			DeletePVar(playerid, "IsFrozen");
		}
	}
	else
	{
	    ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCK, DIALOG_STYLE_LIST, "Available Orders", szDialog, "Take", "Close");
	}
	return 1;
}

IsAtTruckDeliveryPoint(playerid)
{
	for(new i = 0; i < sizeof(TruckerDropoffs); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 6, TruckerDropoffs[i][PosX], TruckerDropoffs[i][PosY], TruckerDropoffs[i][PosZ])) {
		    return 1;
		}
	}
	for(new i = 0; i < sizeof(BoatDropoffs); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 6, BoatDropoffs[i][PosX], BoatDropoffs[i][PosY], BoatDropoffs[i][PosZ])) {
		    return 1;
		}
	}
	return false;
}

CancelTruckDelivery(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(TruckUsed[playerid] == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "Ban khong co chuyen hang nao");
	if(TruckDeliveringTo[TruckUsed[playerid]] != INVALID_BUSINESS_ID)
	{
		if(Businesses[TruckDeliveringTo[TruckUsed[playerid]]][bType] == BUSINESS_TYPE_GASSTATION)
		{
			DestroyVehicle(GetPVarInt(playerid, "Gas_TrailerID"));
			DeletePVar(playerid, "Gas_TrailerID");
		}
		Businesses[TruckDeliveringTo[TruckUsed[playerid]]][bOrderState] = 1;
		SaveBusiness(TruckDeliveringTo[TruckUsed[playerid]]);
	}
	if(1 <= TruckUsed[playerid] <= MAX_VEHICLES){
		TruckDeliveringTo[TruckUsed[playerid]] = INVALID_BUSINESS_ID, TruckContents{TruckUsed[playerid]} = 0;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsATruckerCar(vehicleid)) SetVehicleToRespawn(vehicleid);
	}
	gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
	TruckUsed[playerid] = INVALID_VEHICLE_ID;
 	DisablePlayerCheckpoint(playerid);
 	DeletePVar(playerid, "TruckDeliver");
	return 1;
}

CMD:checkcargo(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 20 && PlayerInfo[playerid][pJob2] != 20 && PlayerInfo[playerid][pJob3] != 20 && !IsACop(playerid))
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la Trucker hoac Canh sat!");
        return 1;
	}

	new carid = GetPlayerVehicleID(playerid);
 	new closestcar = GetClosestCar(playerid, carid);
  	if(IsPlayerInRangeOfVehicle(playerid, closestcar, 6.0) && IsATruckerCar(closestcar))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the kiem tra thung hang khi dang ngoi trong xe.");
			return 1;
		}
		new engine,lights,alarm,doors,bonnet,boot,objective;
		GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
		if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Thung xe chua duoc mo, can phai mo no ra truoc khi kiem tra (/car trunk).");
			return 1;
		}

		new string[128];

     	SendClientMessageEx(playerid, COLOR_GREEN,"_______________ KHO HANG _______________");
		if(IsPlayerInVehicle(playerid, closestcar))
  		{
    		SendClientMessageEx(playerid, COLOR_WHITE, "Phuong tien nay dang co nguoi dieu khien, hay keu no ra khoi phuong tien va kiem tra lai.");
      		return 1;
		}
		new iTruckContents = TruckContents{closestcar};
		new truckcontentname[50];
		if(iTruckContents == 1)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Thuc pham & do uong");}
		else if(iTruckContents == 2)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Quan ao"); }
		else if(iTruckContents == 3)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Vat lieu hop phap"); }
		else if(iTruckContents == 4)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Vat pham 24/7"); }
		else if(iTruckContents == 5)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Vu khi"); }
		else if(iTruckContents == 6)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Thuoc phien"); }
		else if(iTruckContents == 7)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Vat lieu bat hop phap"); }
		format(string, sizeof(string), "Vehicle registration: %s (%d)", GetVehicleName(closestcar), closestcar);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		if(iTruckContents == 0)
		{ format(truckcontentname, sizeof(truckcontentname), "%s",  GetInventoryType(TruckDeliveringTo[closestcar])); }
		format(string, sizeof(string), "Content: %s", truckcontentname);
		SendClientMessageEx(playerid, COLOR_WHITE, string);

		if(IsACop(playerid))
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "De tieu huy so hang hoa bat hop phap nay, go /clearcargo gan chiec xe truck.");
		}

		if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob3] == 20)
		{
			if(TruckDeliveringTo[closestcar] > 0 && TruckUsed[playerid] == INVALID_VEHICLE_ID)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "De giao chuyen hang nay, go /cuophang khi dang lai xe .");
			}
			else if(TruckUsed[playerid] == INVALID_VEHICLE_ID)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "De lay hang , hay nhap /layhang.");
			}
			else if(TruckUsed[playerid] == closestcar && gPlayerCheckpointStatus[playerid] == CHECKPOINT_RETURNTRUCK)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Day khong phai xe cho hang cua ban. Ban khong the chay xe nay ve diem tra hang.");
			}
			else if(TruckUsed[playerid] == closestcar)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Day khong phai xe cho hang cua ban. Ban khong the chay xe nay ve diem tra hang.");
			}
			else if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Ban dang giao mot chuyen hang nao do. Go lenh /huy giaohang de huy chuyen hang do.");
			}
		}
     	SendClientMessageEx(playerid, COLOR_GREEN,"_________________________________________________________");
    }
	else
	{
 		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong gan chiec xe truck.");
 	}
    return 1;
}

CMD:hijackcargo(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob3] == 20)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsATruckerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
     		if(!CheckPointCheck(playerid))
	        {
         		if(GetPVarInt(playerid, "LoadTruckTime") > 0)
	            {
	                SendClientMessageEx(playerid, COLOR_GREY, "Ban dang chat hang roi!");
					return 1;
	            }
	            if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
	            {
	                SendClientMessageEx(playerid, COLOR_GREY, "Ban dang giao chuyen hang khac, neu muon huy chuyen hang hay go lenh /huy giaohang.");
					return 1;
	            }
				if(TruckDeliveringTo[vehicleid] == 0 && TruckContents{vehicleid} == 0)
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe nay chua co hang!");
				    return 1;
				}
				if(IsPlayerInRangeOfPoint(playerid, 65, -1598.454956, 75.236511, 3.554687))
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the cuop hang tai khu vuc Trucker!");
					return 1;
				}
				if(!IsABoat(vehicleid))
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Ban dang cuop hang truck, vui long cho mot chut...");
				}
				else
				{
					if(PlayerInfo[playerid][pTruckSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Ban dang cuop hang truck, vui long cho mot chut...");
					}
					else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can dat ky nang Trucker cap do 3 de lam Truck thuyen.");
				}

				TogglePlayerControllable(playerid, 0);
				SetPVarInt(playerid, "IsFrozen", 1);

				SetPVarInt(playerid, "LoadTruckTime", 10);
				SetTimerEx("HijackTruck", 1000, 0, "dd", playerid);
	        }
	        else return SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa muc tieu truoc khi thuc hien danh dau khac (/xoamuctieu).");
	    }
	    else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong lai dung phuong tien xe tai truck!");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Trucker!");
	return 1;
}

CMD:loadshipment(playerid, params[])
{

	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	if(Hour < 7 && Hour > 2) return SendClientMessageEx(playerid, -1,"Cong viec nay bat dau tu 7 gio sang den 2 khuya.");

	if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob3] == 20)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsATruckerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
	        if(!CheckPointCheck(playerid))
	        {
	            if(GetPVarInt(playerid, "LoadTruckTime") > 0)
	            {
	                SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban dang chat hang len xe!");
					return 1;
	            }
	            if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
	            {
	                SendClientMessageEx(playerid, COLOR_GREY, "Ban dang giao chuyen hang khac, neu muon huy chuyen hang hay go lenh /huy giaohang.");
					return 1;
	            }
				if(TruckContents{vehicleid} != 0)
				{
				    return SendClientMessageEx(playerid, COLOR_GRAD2, "Chiec xe nay da duoc chat hang.");
				}
				if(TruckDeliveringTo[vehicleid] != INVALID_BUSINESS_ID && TruckContents{vehicleid} == 0)
				{
				    return SendClientMessageEx(playerid, COLOR_GRAD2, "Chiec xe nay da duoc chat hang.");
				}
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 440 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 413) // Level Three Vehicle Check
				{
					if(PlayerInfo[playerid][pTruckSkill] < 400)
					{
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can dat ky nang Trucker cap do 3 moi co the su dung xe nay.");
					}
				}
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 482) // Level Five Vehicle Check
				{
					if(PlayerInfo[playerid][pTruckSkill] < 6400)
					{
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can dat ky nang Trucker cap do 5 moi co the su dung xe nay.");
					}
				}
	            if(!IsABoat(vehicleid))
	            {
		            SetPlayerCheckpoint(playerid,-1598.454956, 75.236511, 3.554687, 4);
		            GameTextForPlayer(playerid, "~w~Diem den duoc danh dau tai~n~~r~San Fierro Docks", 5000, 1);
		            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Nhan mot so hang hoa de van chuyen voi xe tai cua ban tai San Fierro Docks (xem diem danh dau mau do tren radar).");
				}
				else
				{
					if(PlayerInfo[playerid][pTruckSkill] >= 400)
					{
						SetPlayerCheckpoint(playerid,2095.8335, -108.6530, 0.5730, 4);
						GameTextForPlayer(playerid, "~w~Diem den duoc danh dau tai~n~~r~Palamino Docks", 5000, 1);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Nhan mot so hang hoa de van chuyen tren thuyen cua ban tai Palamino Docks (xem diem danh dau mau do tren radar).");
					}
					else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can dat ky nang Trucker cap do 3 de lai Truck thuyen.");
				}
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_LOADTRUCK;
	        }
	        else return SendClientMessageEx(playerid, COLOR_WHITE, "Hay dam bao rang diem kiem tra hien tai cua ban da bi pha huy (Ban co goi vat lieu hoac diem kiem tra mau do khac ).");
	    }
	    else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong lai xe van chuyen!");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Trucker!");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {
		case D_TRUCKDELIVER_WEPCHOICE: {

			if(!response) {

				switch(PlayerInfo[playerid][pTruckSkill]) {
					case 0 .. 99: GivePlayerValidWeapon(playerid, WEAPON_BAT);
					case 100 .. 400: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm", "Chon", "");
					case 401 .. 1600: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun", "Chon", "");
					case 1601 .. 6400: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun\nMP5", "Chon", "");
					case 6401: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun\nMP5\nDeagle", "Chon", "");
					default: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Chon phan thuong", "Baseball Bat\n9mm\nShotgun\nMP5\nDeagle", "Chon", "");
				}
				return 1;
			}
			else {
				switch(listitem) {
					case 0: GivePlayerValidWeapon(playerid, WEAPON_BAT);
					case 1: GivePlayerValidWeapon(playerid, WEAPON_COLT45);
					case 2: GivePlayerValidWeapon(playerid, WEAPON_SHOTGUN);
					case 3: GivePlayerValidWeapon(playerid, WEAPON_MP5);
					case 4: GivePlayerValidWeapon(playerid, WEAPON_DEAGLE);
				}
				return 1;
			}
		}
	}
	return 0;
}
