/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Shop Core

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

CreateHouseSaleSign(houseid)
{
	if(!HouseInfo[houseid][hSign][0]) return 1;
	if(IsValidDynamicObject(HouseInfo[houseid][hSignObj])) DestroyDynamicObject(HouseInfo[houseid][hSignObj]);
	if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hSignText])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hSignText]);
	new string[64];
	HouseInfo[houseid][hSignObj] = CreateDynamicObject(19471, HouseInfo[houseid][hSign][0], HouseInfo[houseid][hSign][1], HouseInfo[houseid][hSign][2], 0, 0, HouseInfo[houseid][hSign][3], HouseInfo[houseid][hExtVW], HouseInfo[houseid][hExtIW]);
	format(string,sizeof(string),"ID Bang ban nha: %d\nnhap /noidungbannha de xem noi dung chu nha nay da ghi.", houseid);
	HouseInfo[houseid][hSignText] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, HouseInfo[houseid][hSign][0], HouseInfo[houseid][hSign][1], HouseInfo[houseid][hSign][2] + 0.5, 10.0, .worldid = HouseInfo[houseid][hExtVW], .streamdistance = 25.0);
	return 1;
}

DeleteHouseSaleSign(houseid)
{
	format(HouseInfo[houseid][hSignDesc], 64, "Trong");
	HouseInfo[houseid][hSign][0] = 0.0;
	HouseInfo[houseid][hSign][1] = 0.0;
	HouseInfo[houseid][hSign][2] = 0.0;
	HouseInfo[houseid][hSign][3] = 0.0;
	HouseInfo[houseid][hSignExpire] = 0;
	if(IsValidDynamicObject(HouseInfo[houseid][hSignObj])) DestroyDynamicObject(HouseInfo[houseid][hSignObj]);
	if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hSignText])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hSignText]);
	SaveHouse(houseid);
	return 1;
}

forward FuelCan(playerid, vehicleid, amount);
public FuelCan(playerid, vehicleid, amount)
{
	new string[128];
	if(GetPVarInt(playerid, "fuelcan") == 1)
	{
		PlayerInfo[playerid][mInventory][7]--;
		format(string, sizeof(string), "[FUELCAN] %s(%d) used a fuel can. Left: %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][mInventory][7]);
		Log("logs/micro.log", string);
	}
	if(GetPVarInt(playerid, "fuelcan") == 2)
	{
		format(string, sizeof(string), "[ZFUELCAN] %s(%d) used a fuel can with %d%% fuel.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][zFuelCan]);
		Log("logs/micro.log", string);
		PlayerInfo[playerid][zFuelCan] = 0;
	}
	VehicleFuel[vehicleid] += float(amount);
	if(VehicleFuel[vehicleid] > 100) VehicleFuel[vehicleid] = 100.0;
	format(string, sizeof(string), "%s has used a fuel can to refill their vehicle.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have used a fuel can to refill your vehicle.");
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	DeletePVar(playerid, "fuelcan");
	return 1;
}

forward JumpStart(playerid, vehicleid);
public JumpStart(playerid, vehicleid)
{
	PlayerInfo[playerid][mInventory][8]--;
	RepairVehicle(vehicleid);
	Vehicle_Armor(vehicleid);
	if(IsTrailerAttachedToVehicle(vehicleid))
	{
		RepairVehicle(GetVehicleTrailer(vehicleid));
		Vehicle_Armor(GetVehicleTrailer(vehicleid));
	}
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid, engine,lights,alarm,doors,bonnet,boot,objective);
	SetVehicleParamsEx(vehicleid, engine,lights,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
	new string[128];
	format(string, sizeof(string), "%s has jump started their vehicle.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	SendClientMessage(playerid, COLOR_WHITE, "Your vehicle has been Jump Started!");
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	format(string, sizeof(string), "[JUMPSTART] %s(%d) used a jump start. Left: %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][mInventory][8]);
	Log("logs/micro.log", string);
	DeletePVar(playerid, "jumpstarting");
	return 1;
}

forward EatBar(playerid);
public EatBar(playerid)
{
	PlayerInfo[playerid][mInventory][4]--;
	PlayerInfo[playerid][mCooldown][4] = 60;
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	SendClientMessageEx(playerid, -1, "You have consumed a energy bar, effects will last for 1 hour.");
	SendClientMessageEx(playerid, -1, "Your health will decrease slower when in a injured state.");
	new string[128];
	format(string, sizeof(string), "[ENERGYBAR] %s(%d) used a energy bar. Left: %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][mInventory][4]);
	Log("logs/micro.log", string);
	DeletePVar(playerid, "eatingbar");
	return 1;
}

stock HireCost(carid)
{
	switch (carid)
	{
		case 69:
		{
			return 90000; //bullit
		}
		case 70:
		{
			return 130000; //infurnus
		}
		case 71:
		{
			return 100000; //turismo
		}
		case 72:
		{
			return 80000;
		}
		case 73:
		{
			return 70000;
		}
		case 74:
		{
			return 60000;
		}
	}
	return 0;
}

forward TeleportToShop(playerid);
public TeleportToShop(playerid)
{
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "EventToken") == 1 || GetPVarInt(playerid, "IsInArena") || !GetPVarInt(playerid, "ShopTP"))
		return DeletePVar(playerid, "ShopTP"), SendClientMessage(playerid, COLOR_GRAD2, "GN:SHOP: Ban da huy dich chuyen den SHOP.");
	if(gettime() - LastShot[playerid] < 30) {
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid, "ShopTP");
		return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban vua bi ai do tan cong, khong the dich chuyen den SHOP.");
	}
	if(GetPVarInt(playerid, "ShopTP") == 1)
	{
		SetPlayerPos(playerid, 2957.9670, -1459.4045, 10.8092);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 1);
		TogglePlayerControllable(playerid, 1);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Neu ban muon roi khoi SHOP, hay su dung lenh (/roignshop) de tro lai vi tri cu.");
	}
	return 1;
}

CMD:shopplate(playerid, params[])
{
    if(PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new iVehType, iVehIndex, iTargetOwner, carid, orderid, plate[32];
        if(sscanf(params, "dds[32]", carid, orderid, plate))
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopplate [carid] [orderid] [plate/remove]");
		    SendClientMessageEx(playerid, COLOR_GREY, "MAU: (black/white/blue/red/green/purple/yellow/lightblue/navy/beige/darkgreen/darkblue/darkgrey/gold/brown/darkbrown/darkred");
			SendClientMessageEx(playerid, COLOR_GREY, "/pink) USAGE: (red)Hi(white)how are you? NOTE: Each color counts for 8 characters");
			return 1;
		}

		foreach(new i: Player)
		{
			iVehIndex = GetPlayerVehicle(i, carid);
			if(iVehIndex != -1)
			{
				iVehType = 1;
				iTargetOwner = i;
				break;
			}
		}	
		if(iVehType == 1)
		{
		    format(plate, sizeof(plate), "%s", str_replace("(black)", "{000000}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(white)", "{FFFFFF}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(blue)", "{0000FF}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(red)", "{FF0000}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(green)", "{008000}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(purple)", "{800080}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(yellow)", "{FFFF00}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(lightblue)", "{ADD8E6}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(navy)", "{000080}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(beige)", "{F5F5DC}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(darkgreen)", "{006400}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(darkblue)", "{00008B}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(darkgrey)", "{A9A9A9}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(gold)", "{FFD700}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(brown)", "{A52A2A}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(darkbrown)", "{5C4033}", plate));
		    format(plate, sizeof(plate), "%s", str_replace("(darkred)", "{8B0000}", plate));
			format(plate, sizeof(plate), "%s", str_replace("(pink)", "{FF5B77}", plate));

			new string[128], Float:X, Float:Y, Float:Z;
			GetVehiclePos(carid, X, Y, Z);
			if(strcmp(plate, "remove", true) == 0)
			{
				PlayerVehicleInfo[iTargetOwner][iVehIndex][pvPlate] = 0;
			}
			else
			{
				format(PlayerVehicleInfo[iTargetOwner][iVehIndex][pvPlate], 32, "%s", plate);
			}
			SetVehicleToRespawn(carid);
			SetVehiclePos(carid, X, Y, Z);
			g_mysql_SaveVehicle(iTargetOwner, iVehIndex);

			format(string, sizeof(string), "Plate set on %s (ID: %d) %s (ID: %d)", GetPlayerNameEx(iTargetOwner), iTargetOwner, GetVehicleName(carid), carid);
			SendClientMessage(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "(OrderID: %d) Plate: %s", orderid, plate);
			SendClientMessage(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s set %s(%d) %s (Slot %d) plate to %s (order %d)", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetOwner), GetPlayerSQLId(iTargetOwner), GetVehicleName(carid), iVehIndex, plate, orderid);
			Log("logs/shoplog.log", string);
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GRAD1, "This is not a person owned vehicle, you cannot give it a custom plate.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}

CMD:shopcredits(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pShopTech] >= 2)
	{
		new szMessage[128], player, amount, invid;

		if(sscanf(params, "udd", player, amount, invid))
			return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /givecredits [player] [amount] [invoiceid]");

		if(!IsPlayerConnected(player))
		    return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");

		if(!(1 < amount < 2401)) return SendClientMessageEx(playerid, COLOR_GREY, "You can only go low as 1 and maximum is 2400 credits!");
		if(PlayerInfo[player][pAdmin] > 2) return SendClientMessageEx(playerid, COLOR_GREY, "You can only issue Credits onto roleplay accounts only!");

		if(amount > 999)
		{
			format(szMessage, sizeof(szMessage), "{AA3333}GTN-Warning{FFFF00}: %s issued %s %s credits. (Invoice ID: %d)", GetPlayerNameEx(playerid), GetPlayerNameEx(player), invid);
			ABroadCast(COLOR_YELLOW, szMessage, 2);
		}

		PlayerInfo[player][pCredits] += amount;

		mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `accounts` SET `Credits` = %d WHERE `id` = %d", PlayerInfo[player][pCredits], GetPlayerSQLId(player));
		mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, player);
		print(szMessage);

        SendClientMessageEx(player, COLOR_LIGHTBLUE, "* %s da duoc cho you %s credits (New total: %s)", GetPlayerNameEx(playerid), number_format(amount), number_format(PlayerInfo[player][pCredits]));

		format(szMessage, sizeof(szMessage), "%s da duoc cho %s %s credits. [TC: %s] (Invoice ID: %d)", GetPlayerNameEx(playerid), GetPlayerNameEx(player), number_format(amount), number_format(PlayerInfo[player][pCredits]), invid);
		Log("logs/shoplog.log", szMessage), print(szMessage);

		SendClientMessageEx(playerid, COLOR_CYAN, "Ban da cho %s %s credits. (Invoice ID: %d)", GetPlayerNameEx(player), number_format(amount), invid);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, " Ban khong duoc phep su dung lenh nay."); 
	return 1;
}

CMD:shopcar(playerid, params[]) {
	if(PlayerInfo[playerid][pShopTech] >= 1) {

		new
			szInvoice[32],
			iColors[2],
			iTargetID,
			iModelID;

		if(sscanf(params, "uiiis[32]", iTargetID, iModelID, iColors[0], iColors[1], szInvoice)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopcar [player] [model] [color 1] [color 2] [invoice #]");
		}
		else if(!(400 <= iModelID <= 611)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid model specified (model IDs start at 400, and end at 611).");
		}
		else if(IsATrain(iModelID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Trains cannot be spawned during runtime.");
		}
		else if(IsRestrictedVehicle(iModelID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "You cannot issue restricted vehicles!");
		}
		else if(!(0 <= iColors[0] <= 255 && 0 <= iColors[1] <= 255)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid color specified (IDs start at 0, and end at 255).");
		}
		else if(!vehicleCountCheck(iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "That person can't have more vehicles - they own too many.");
		}
		else if(!vehicleSpawnCountCheck(iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "That person has too many vehicles spawned - they must store one first.");
		}
		else {

			new
				Float: arr_fPlayerPos[4],
				szMessage[84];

			GetPlayerPos(iTargetID, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
			GetPlayerFacingAngle(iTargetID, arr_fPlayerPos[3]);
			CreatePlayerVehicle(iTargetID, GetPlayerFreeVehicleId(iTargetID), iModelID, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], iColors[0], iColors[1], 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

			format(szMessage, sizeof(szMessage), "You have successfully created a %s for %s (invoice %s).", VehicleName[iModelID - 400], GetPlayerNameEx(iTargetID), szInvoice);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

			format(szMessage, sizeof(szMessage), "%s created a %s (%i) for %s(%d) (invoice %s).", GetPlayerNameEx(playerid), VehicleName[iModelID - 400], iModelID, GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), szInvoice);
			Log("logs/shoplog.log", szMessage);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, " Ban khong duoc phep su dung lenh nay.");
    return 1;
}

CMD:shopcardel(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128], invoicenum[32], giveplayerid, vehicleid;
		if(sscanf(params, "uds[32]", giveplayerid, vehicleid, invoicenum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopcardel [player] [vehicleid] [invoice #]");

		new playervehicleid = GetPlayerVehicle(giveplayerid, vehicleid);
		if(playervehicleid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: That person doesn't own that vehicle.");

		format(string, sizeof(string), "You have deleted %s's %s (vehicle ID %d).", GetPlayerNameEx(giveplayerid), GetVehicleName(vehicleid), vehicleid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "An Administrator has deleted your %s.", GetVehicleName(vehicleid));
		SendClientMessageEx(giveplayerid, COLOR_GREY, string);
		format(string, sizeof(string), "[SHOPCARDEL] %s deleted vehicle ID %d - Invoice %s for %s(%d)", GetPlayerNameEx(playerid), playervehicleid, invoicenum, GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
		Log("logs/shoplog.log", string);
		DestroyPlayerVehicle(giveplayerid, playervehicleid);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay.");
	return 1;
}

CMD:setstpay(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 99999)
	{
	    new string[128];
		if(sscanf(params, "f", ShopTechPay))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Usage: /setstpay [value]");
			format(string, sizeof(string), "Current Pay: $%.2f", ShopTechPay);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 1;
		}
		mysql_format(MainPipeline, string, sizeof(string), "UPDATE `misc` SET `ShopTechPay` = '%.2f'", ShopTechPay);
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

		format(string, sizeof(string), "Shop Tech Pay set to $%.2f", ShopTechPay);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	return 1;
}

CMD:resetstpay(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 99999)
	{
	    if(GetPVarInt(playerid, "resetstpay"))
	    {
	        mysql_tquery(MainPipeline, "UPDATE `shoptech` SET `total` = 0, dtotal = 0", "OnQueryFinish", "i", SENDDATA_THREAD);
            SendClientMessage(playerid, COLOR_WHITE, "Shop Tech Payments Reset");
	        DeletePVar(playerid, "resetstpay");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WHITE, "WARNING: This command will reset the shop tech payment counters");
		    SendClientMessage(playerid, COLOR_WHITE, "This action cannot be undone, ARE YOU SURE YOU WISH TO CONTINUE?");
		    SendClientMessage(playerid, COLOR_WHITE, "Type this command again to proceed");
		    SetPVarInt(playerid, "resetstpay", 1);
		}
	}
	return 1;
}

CMD:changeuserpin(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pShopTech] < 2)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do!");
        return 1;
    }

    new string[128], accountName[20], password[64], query[512];
    if(sscanf(params, "s[20]s[64]", accountName, password))
		return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /changeuserpin [player name] [new pin]");

    if(strlen(password) > 4 || !IsNumeric(password))
        return SendClientMessageEx(playerid, COLOR_GREY, "The pin must be numbers, and must have 4 digits.");

    new passbuffer[129];
    WP_Hash(passbuffer, sizeof(passbuffer), password);

	format(string, sizeof(string), "Attempting to change %s's pin...", accountName);
    SendClientMessageEx(playerid, COLOR_YELLOW, string);

	format(string, sizeof(string), "AdmCmd: %s's pin was changed by %s.", accountName, GetPlayerNameEx(playerid));
    Log("logs/pin.log", string);

	SetPVarInt(playerid, "ChangePin", 1);

	new tmpName[24];
	mysql_escape_string(accountName, tmpName);

    mysql_format(MainPipeline, query,sizeof(query),"UPDATE `accounts` SET `Pin`='%s' WHERE `Username`='%s' AND `AdminLevel` < 2", passbuffer, tmpName);
	mysql_tquery(MainPipeline, query, "OnChangeUserPassword", "i", playerid);
	SetPVarString(playerid, "OnChangeUserPassword", tmpName);
	return 1;
}

CMD:changeuserpassword(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do!");
        return 1;
    }

    new string[128], accountName[20], password[64], query[512];
    if(sscanf(params, "s[20]s[64]", accountName, password)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /changeuserpassword [player name] [new password]");

    new passbuffer[129], salt[11];
	randomString(salt);
	format(string, sizeof(string), "%s%s", password, salt);
    WP_Hash(passbuffer, sizeof(passbuffer), string);

	format(string, sizeof(string), "Attempting to change %s's password...", accountName);
    SendClientMessageEx(playerid, COLOR_YELLOW, string);

	format(string, sizeof(string), "AdmCmd: %s's password was changed by %s.", accountName, GetPlayerNameEx(playerid));
    Log("logs/password.log", string);

	new tmpName[24];
	mysql_escape_string(accountName, tmpName);

    mysql_format(MainPipeline, query,sizeof(query),"UPDATE `accounts` SET `Key`='%s', `Salt`='%s' WHERE `Username`='%s' AND `AdminLevel` < 2", passbuffer, salt, tmpName);
	mysql_tquery(MainPipeline, query, "OnChangeUserPassword", "i", playerid);
	SetPVarString(playerid, "OnChangeUserPassword", tmpName);
	return 1;
}

CMD:orders(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] > 0 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
 		new string[128];
        SendClientMessageEx(playerid, COLOR_GREEN, "____________________ SHOP ORDERS _____________________");
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pOrder] > 0 && OrderAssignedTo[i] == INVALID_PLAYER_ID)
			{
				new playerip[32];
				GetPlayerIp(i, playerip, sizeof(playerip));

				new orderid = PlayerInfo[i][pOrder];

				if(PlayerInfo[i][pOrderConfirmed]) {
					format(string, sizeof(string), "%s(%d) | Order ID: %d (Confirmed) | IP: %s | Assigned to: Nobody", GetPlayerNameEx(i), i, orderid, playerip);
				} else {
					format(string, sizeof(string), "%s(%d) | Order ID: %d (Invalid) | IP: %s | Assigned to: Nobody", GetPlayerNameEx(i), i, orderid, playerip);
				}
				SendClientMessageEx(playerid, COLOR_SHOP, string);
			}
			else if(PlayerInfo[i][pOrder] > 0 && OrderAssignedTo[i] != INVALID_PLAYER_ID)
			{
				new playerip[32];
				GetPlayerIp(i, playerip, sizeof(playerip));

				new orderid = PlayerInfo[i][pOrder];

				if(PlayerInfo[i][pOrderConfirmed]) {
					format(string, sizeof(string), "%s(%d) | Order ID: %d (Confirmed) | IP: %s | Assigned to: %s", GetPlayerNameEx(i), i, orderid, playerip, GetPlayerNameEx(OrderAssignedTo[i]));
				} else {
					format(string, sizeof(string), "%s(%d) | Order ID: %d (Invalid) | IP: %s | Assigned to: %s", GetPlayerNameEx(i), i, orderid, playerip, GetPlayerNameEx(OrderAssignedTo[i]));
				}
				SendClientMessageEx(playerid, COLOR_SHOP, string);
			}
		}	
  		SendClientMessageEx(playerid, COLOR_WHITE, "Use /givemeorder /processorder /denyorder");
        SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________________");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh do.");
	return 1;
}

CMD:givemeorder(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] > 0 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givemeorder [player]");
			return 1;
		}

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pOrder] > 0)
			{
			    if(IsPlayerConnected(OrderAssignedTo[giveplayerid]))
			    {
			        if(GetPVarInt(playerid, "OrderAssignedTo") == giveplayerid)
			        {
			            DeletePVar(playerid, "OrderAssignedTo");
			        }
			        else
			        {
					    SendClientMessageEx(playerid, COLOR_WHITE, "That order ID has already been assigned to another admin!");
					    SendClientMessageEx(playerid, COLOR_WHITE, "If you are sure you wish to take the order anyway, type this command again.");
					    SetPVarInt(playerid, "OrderAssignedTo", giveplayerid);
				        return 1;
					}
			    }
		    	new string[128];
		    	new orderid = PlayerInfo[giveplayerid][pOrder];
				format(string, sizeof(string), "AdmCmd: %s assigned himself to shop order ID %d from %s (ID: %d).", GetPlayerNameEx(playerid), orderid, GetPlayerNameEx(giveplayerid), giveplayerid);
				ShopTechBroadCast(COLOR_ORANGE, string);

				format(string, sizeof(string), "%s is now reviewing your shop order ID %d.", GetPlayerNameEx(playerid), orderid);
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);

				OrderAssignedTo[giveplayerid] = playerid;
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "That person does not have any shop orders pending!");
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");

	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh do.");
	return 1;
}

/*CMD:adjustoid(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] > 0 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
	    new giveplayerid, orderid, string[128];
		if(sscanf(params, "ui", giveplayerid, orderid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adjustoid [player] [new orderid]");
		SendClientMessageEx(playerid, COLOR_WHITE, "Processing..");
  		PlayerInfo[giveplayerid][pOrder] = orderid;
		format(string, sizeof(string), "gta.network/idcheck.php?id=%d", orderid);
		HTTP(giveplayerid, HTTP_GET, string, "", "HttpCallback_ShopIDCheck");
		format(string, sizeof(string), "%s has edited %s's Order ID to %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), orderid);
		Log("logs/shoporders.log", string);
	}
	return 1;
}*/

CMD:processorder(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] > 0 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /processorder [player]");
			return 1;
		}

		if(IsPlayerConnected(giveplayerid))
		{
			if(OrderAssignedTo[giveplayerid] != playerid)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "You must be assigned to that order ID to process it, use /givemeorder");
		        return 1;
		    }
			if(PlayerInfo[giveplayerid][pOrder] > 0)
			{
		    	new string[128];
		    	new orderid = PlayerInfo[giveplayerid][pOrder];
				format(string, sizeof(string), "AdmCmd: %s has processed shop order ID %d from %s (ID: %d).", GetPlayerNameEx(playerid), orderid, GetPlayerNameEx(giveplayerid), giveplayerid);
				ShopTechBroadCast(COLOR_ORANGE, string);

				format(string, sizeof(string), "%s has processed your shop order ID %d.", GetPlayerNameEx(playerid), orderid);
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);

				new playerip[32], giveplayerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				GetPlayerIp(giveplayerid, giveplayerip, sizeof(giveplayerip));

				if(PlayerInfo[giveplayerid][pOrderConfirmed])
				{
				    mysql_format(MainPipeline, string, sizeof(string), "SELECT `id` FROM `orders` WHERE `id` = '%d'", PlayerInfo[giveplayerid][pOrder]);
					mysql_tquery(MainPipeline, string, "OnProcessOrderCheck", "ii", playerid, giveplayerid);
					SetPVarInt(playerid, "processorder", orderid);
				}
				else
				{
					format(string, sizeof(string), "%s(IP: %s) has processed shop order ID %d from %s(%d) (IP: %s).", GetPlayerNameEx(playerid), playerip, orderid, GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), giveplayerip);
					Log("logs/shoporders.log", string);
				}

				PlayerInfo[giveplayerid][pOrder] = 0;
				PlayerInfo[giveplayerid][pOrderConfirmed] = 0;
				OrderAssignedTo[giveplayerid] = INVALID_PLAYER_ID;
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "That person does not have any shop orders pending!");
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");

	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh do.");
	return 1;
}

CMD:denyorder(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] > 0 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /denyorder [player] [reason]");
			return 1;
		}

		if(IsPlayerConnected(giveplayerid))
		{
			if(OrderAssignedTo[giveplayerid] != playerid)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "You must be assigned to that order ID to deny it, use /givemeorder");
		        return 1;
		    }
			if(PlayerInfo[giveplayerid][pOrder] > 0)
			{
		    	new string[128];
		    	new orderid = PlayerInfo[giveplayerid][pOrder];
				format(string, sizeof(string), "AdmCmd: %s has denied shop order ID %d from %s (ID: %d), reason: %s", GetPlayerNameEx(playerid), orderid, GetPlayerNameEx(giveplayerid), giveplayerid, reason);
				ShopTechBroadCast(COLOR_ORANGE, string);

				format(string, sizeof(string), "%s has denied your shop order ID %d, reason: %s", GetPlayerNameEx(playerid), orderid, reason);
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);

				new playerip[32], giveplayerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				GetPlayerIp(giveplayerid, giveplayerip, sizeof(giveplayerip));

				format(string, sizeof(string), "%s(IP: %s) has denied shop order ID %d from %s(%d) (IP: %s), reason: %s", GetPlayerNameEx(playerid), playerip, orderid, GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), giveplayerip, reason);
				Log("logs/shoporders.log", string);

				PlayerInfo[giveplayerid][pOrder] = 0;
				OrderAssignedTo[giveplayerid] = INVALID_PLAYER_ID;
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "That person does not have any shop orders pending!");
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh do.");
	return 1;
}

CMD:shoporder(playerid, params[])
{
	if(PlayerInfo[playerid][pOrder] != 0)
	{
	    new string[128];
	    new orderid = PlayerInfo[playerid][pOrder];
		format(string, sizeof(string), "You already have shop order ID %d pending, if you wish to cancel that type /cancelorder", orderid);
 		SendClientMessageEx(playerid, COLOR_WHITE, string);
	    return 1;
	}
	if (GetPVarInt(playerid, "ShopOrderTimer") > 0)
	{
		new string[128];
		format(string, sizeof(string), "Ban phai doi %d seconds before submitting another shop order.", GetPVarInt(playerid, "ShopOrderTimer"));
		SendClientMessageEx(playerid,COLOR_GREY, string);
		return 1;
	}
	ShowPlayerDialogEx(playerid, DIALOG_SHOPORDER, DIALOG_STYLE_INPUT, "Shop Order", "This is for shop orders from http://gta.network\n\nIf Ban khong coa shop order then please cancel this dialog box now.\n\nWarning: Abuse of this feature may result to an indefinite block from this command.\n\nPlease enter your shop order ID (if you do not know it put 1):", "Submit", "Cancel" );
	return 1;
}

CMD:cancelorder(playerid, params[])
{
	if(PlayerInfo[playerid][pOrder] != 0)
	{
	    new string[128];
	    new orderid = PlayerInfo[playerid][pOrder];
		new playerip[32];
		GetPlayerIp(playerid, playerip, sizeof(playerip));
		format(string, sizeof(string), "%s(%d) (IP: %s) canceled their shop order (ID %i).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, orderid);
		Log("logs/shoporders.log", string);

		format(string, sizeof(string), "Ban da huy  your shop order (ID %i). If you wish to submit another order, type /shoporder.", orderid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		PlayerInfo[playerid][pOrder] = 0;
		OrderAssignedTo[playerid] = INVALID_PLAYER_ID;
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coany shop orders pending!");
	}
	return 1;
}

CMD:useexp(playerid, params[])
{
	new string[128];
    if (PlayerInfo[playerid][pEXPToken] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " Ban khong coany Double EXP tokens!");
		return 1;
	}
    PlayerInfo[playerid][pDoubleEXP] += 8;
    PlayerInfo[playerid][pEXPToken]--;
    format(string, sizeof(string), "You have used a Double EXP Token! You now have a total of %d of Double EXP hours!", PlayerInfo[playerid][pDoubleEXP]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
    return 1;
}

CMD:shopexp(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 3)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " Ban khong duoc phep su dung lenh nay.");
		return 1;
	}

	new string[128], giveplayerid, amount, invoice[32];
	if(sscanf(params, "uds[32]", giveplayerid, amount, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /shopexp [player] [so luong] [Ma giao dich (ST0000)]");

	PlayerInfo[giveplayerid][pEXPToken] += amount;

	format(string, sizeof(string), "Ban da nhan duoc %d Double EXP Token boi Shop Tech %s.", amount, GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_GREEN, string);
	format(string, sizeof(string), "[SHOPEXP] %s da set cho %s (%d), %d Double EXP Token(s) - Ma giao dich: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), amount, invoice);
	SendClientMessageEx(playerid, COLOR_GREEN, string);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:shoptokens(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " Ban khong duoc phep su dung lenh nay.");
		return 1;
	}

	new string[128], giveplayerid, amount, invoice[32];
	if(sscanf(params, "uds[32]", giveplayerid, amount, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /shoptokens [player] [so luong] [Ma giao dich (ST0000)]");

	PlayerInfo[giveplayerid][pPaintTokens] += amount;

	format(string, sizeof(string), "You have received %d Paintball Tokens from Shop Tech %s.", amount, GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "[SHOPTOKENS] %s given %s(%d), %d Paintball Tokens - Invoice %s for %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), amount, invoice, GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_GRAD1, string);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:shopviptokens(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " Ban khong duoc phep su dung lenh nay.");
		return 1;
	}

	new string[128], giveplayerid, amount, invoice[32];
	if(sscanf(params, "uds[32]", giveplayerid, amount, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopviptokens [player] [amount] [Ma giao dich (ST0000)]");

	PlayerInfo[giveplayerid][pTokens] += amount;

	format(string, sizeof(string), "You have received %d VIP Tokens from Shop Tech %s.", amount, GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "[SHOPTOKENS] %s given %s(%d), %d VIP Tokens - Invoice %s for %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), amount, invoice, GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_GRAD1, string);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:shopfirework(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " Ban khong duoc phep su dung lenh nay.");
		return 1;
	}

	new string[128], giveplayerid, amount, invoice[32];
	if(sscanf(params, "uds[32]", giveplayerid, amount, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopfirework [player] [amount] [Ma giao dich (ST0000)]");

	PlayerInfo[giveplayerid][pFirework] += amount;

	format(string, sizeof(string), "You have received %d Fireworks from Shop Tech %s. ", amount, GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "[SHOPFIREWORK] %s given %s(%d) %d Firework(s) - Invoice %s for %s. ", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), amount, invoice, GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_GRAD1, string);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:miscshop(playerid, params[])
{
    if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang nay da dong cua.");

	if (IsAt247(playerid) || IsPlayerInRangeOfPoint(playerid, 4.0, 2939.8442, -1411.2906, 11.0000) && GetPlayerVirtualWorld(playerid) == 1)
	{
 		if(GetPVarInt(playerid, "PinConfirmed"))
   		{
			new szDialog[1024];
			format(szDialog, sizeof(szDialog), "Ban Poker (Credits: {FFD700}%s{A9C4E4})\nBoombox (Credits: {FFD700}%s{A9C4E4})\n100 Paintball Tokens (Credits: {FFD700}%s{A9C4E4})\nEXP Token (Credits: {FFD700}%s{A9C4E4})\nPhao hoa (x5) (Credits: {FFD700}%s{A9C4E4})\nBien so xe custom (Credits: {FFD700}%s{A9C4E4})",
			number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]), number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]), 
			number_format(ShopItems[10][sItemPrice]), number_format(ShopItems[22][sItemPrice]));
			format(szDialog, sizeof(szDialog), "%s\nRestricted Last Name (NEW) (Credits: {FFD700}%s{A9C4E4})\nRestricted Last Name (CHANGE) (Credits: {FFD700}%s{A9C4E4})\nCustom User Title (NEW) (Credits: {FFD700}%s{A9C4E4})\nCustom User Title (CHANGE) (Credits: {FFD700}%s{A9C4E4})\nTeamspeak User Channel (Credits: {FFD700}%s{A9C4E4})\nBackpacks\nDeluxe Car Alarm (Credits: {FFD700}%s{A9C4E4})", 
			szDialog, number_format(ShopItems[31][sItemPrice]), number_format(ShopItems[32][sItemPrice]), number_format(ShopItems[33][sItemPrice]), number_format(ShopItems[34][sItemPrice]), number_format(ShopItems[35][sItemPrice]), number_format(ShopItems[39][sItemPrice]));
			ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP, DIALOG_STYLE_LIST, "Misc Shop", szDialog, "Chon", "Huy");
		}
		else
		{
		    SetPVarInt(playerid, "OpenShop", 1);
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o tai cua hang 24/7.");
	}
	return 1;
}

CMD:credits(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		new szString[128];
		format(szString, sizeof(szString), "Credits: {FFD700}%s", number_format(PlayerInfo[playerid][pCredits]));
		SendClientMessageEx(playerid, COLOR_CYAN, szString);
	}
	else
	{
	    new Player;
	    if(sscanf(params, "u", Player))
			return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /credits [Player]");

		if(Player < 0 || Player > MAX_PLAYERS || !gPlayerLogged{Player}) return SendClientMessage(playerid, -1, "Nguoi choi khong hop le");
        new szString[128];
		format(szString, sizeof(szString), "%s - Credits: {FFD700}%s",GetPlayerNameEx(Player), number_format(PlayerInfo[Player][pCredits]));
		SendClientMessageEx(playerid, COLOR_CYAN, szString);
	}
	return 1;
}

CMD:shopstats(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338 && PlayerInfo[playerid][pShopTech] != 3)
	    return 0;

	mysql_tquery(MainPipeline, "SELECT `id`, `Month` FROM `sales`", "CheckSales", "i", playerid);
	return 1;
}
 
CMD:shophelp(playerid, params[]) {
    return ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU, DIALOG_STYLE_LIST, "Which shop do you want to learn more about?","VIP Shop\nHouse Shop\nBusiness Shop\nToy Shop\nMiscellaneous Shop\nCar Shop\nPlane Shop\nBoat Shop", "Select", "Exit");
}

CMD:gnshopfkfkdkdj(playerid, params[]) {
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "EventToken") == 1 || GetPVarInt(playerid, "IsInArena"))
		return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay bay gio!");
	if(PlayerInfo[playerid][pWantedLevel] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi truy na.");
	if(gettime() - LastShot[playerid] < 60) return SendClientMessageEx(playerid, COLOR_GREY, "Ban vua bi tan cong nen khong the dich chuyen.");
	if(IsPlayerInDynamicArea(playerid, NGGShop)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da o tai SHOP roi (/roignshop) de tro ve.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai o ngoai phuong tien de su dung lenh nay.");
	if(GetPVarInt(playerid, "ShopTP") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang yeu cau dich chuyen den SHOP roi.");
	
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[!] Ban dang duoc dich chuyen den SHOP GTA.NETWORK, hay cho 15 giay sau de duoc dich chuyen...");
	SetTimerEx("TeleportToShop", 15000, false, "i", playerid);
	TogglePlayerControllable(playerid, 0);
	SetPVarInt(playerid, "ShopTP", 1);
	
	new Float:tmp[3];
	GetPlayerPos(playerid, tmp[0], tmp[1], tmp[2]);
	SetPVarFloat(playerid, "tmpX", tmp[0]);
	SetPVarFloat(playerid, "tmpY", tmp[1]);
	SetPVarFloat(playerid, "tmpZ", tmp[2]);
	SetPVarInt(playerid, "tmpInt", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "tmpVW", GetPlayerVirtualWorld(playerid));
	return 1;
}

CMD:leaveshop(playerid, params[]) {
	if(GetPVarInt(playerid, "ShopTP") == 1)
	{
		DeletePVar(playerid, "ShopTP");
		if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0 || IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay bay gio!.");
		if(gettime() - LastShot[playerid] < 60) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban vua bi ai do tan cong nen khong the dich chuyen lai vi tri cu cua ban.");
		Player_StreamPrep(playerid, GetPVarFloat(playerid, "tmpX"), GetPVarFloat(playerid, "tmpY"), GetPVarFloat(playerid, "tmpZ"), 2500);
		PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "tmpVW");
		SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
		PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "tmpInt");
		SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);
	}
	return 1;
}

CMD:buygiftreset(playerid, params[]) {
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 2937.2878, -1357.2294, 10.8503))
	{
		new string[128];
		format(string, sizeof(string),"Vat pham: Gift Reset\nCredits hien tai: %s\nGia: {FFD700}%s{A9C4E4}\nCredits sau khi mua: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
		return ShowPlayerDialogEx( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Mua Gift Reset", string, "Mua", "Thoat" );
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o tai khu vuc mua Gift Reset.");
}

CMD:buyhealthcare(playerid, params[]) {
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 2946.8672, -1484.9561, 11.0000))
	{
		return ShowPlayerDialogEx(playerid, DIALOG_HEALTHCARE, DIALOG_STYLE_LIST, "Cham soc suc khoe", "Cham soc suc khoe binh thuong\nCham soc suc khoe dac biet", "Chon", "Thoat");
	}
	return 1;
}

CMD:togshopnotices(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(ShopReminder == 0)
		{
			ShopReminder = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled Shop Notifications.");
		}
		else
		{
			ShopReminder = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled Shop Notifications.");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co quyen de thuc hien lenh nay.");
	return 1;
}

CMD:stoprentacar(playerid, params[])
{
    if(GetPVarType(playerid, "RentedVehicle"))
	{
	    new string[128];
        SendClientMessageEx(playerid, COLOR_CYAN, "You have stopped renting your vehicle.");
		DestroyVehicle(GetPVarInt(playerid, "RentedVehicle"));

		mysql_format(MainPipeline, string, sizeof(string), "DELETE FROM `rentedcars` WHERE `sqlid`= '%d'", GetPlayerSQLId(playerid));
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

		DeletePVar(playerid, "RentedHours");
		DeletePVar(playerid, "RentedVehicle");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not currently renting chiec xe.");
	return 1;
}

CMD:rentacar(playerid, params[])
{
    if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "The shop is currently closed.");

    if(IsPlayerInRangeOfPoint(playerid, 4, 1102.8999, -1440.1669, 15.7969) || IsPlayerInRangeOfPoint(playerid, 4, 1796.0620, -1588.5571, 13.4951))
	{
		if(GetPVarInt(playerid, "PinConfirmed"))
		{
		    if(!GetPVarType(playerid, "RentedVehicle"))
			{
		    	SetPVarInt(playerid, "RentaCar", 1);
				ShowModelSelectionMenu(playerid, CarList2, "Rent a Car!");
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You already are renting chiec xe.");
		}
		else
		{
		    SetPVarInt(playerid, "OpenShop", 2);
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "You aren't at a rent a car location.");
	}
	return 1;
}

CMD:boatshop(playerid, params[])
{
    if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang hien tai da dong cua.");

	if(IsPlayerInRangeOfPoint(playerid, 4, -2214.1636, 2422.4763, 2.4961) || IsPlayerInRangeOfPoint(playerid, 4,-2975.8950, 505.1325, 2.4297) || IsPlayerInRangeOfPoint(playerid, 4, 723.1553, -1494.4547, 1.9343) || IsPlayerInRangeOfPoint(playerid, 4, 2974.7520, -1462.9265, 2.8184))
	{
		if(GetPVarInt(playerid, "PinConfirmed"))
		{
			ShowModelSelectionMenu(playerid, BoatList, "Cua hang mua Thuyen");
		}
		else
		{
		    SetPVarInt(playerid, "OpenShop", 8);
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o tai khu vuc mua thuyen.");
	}
	return 1;
}

CMD:planeshop(playerid, params[])
{
    if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang hien tai da dong cua.");

	if(IsPlayerInRangeOfPoint(playerid, 5, 1891.9105, -2279.6174, 13.5469) || IsPlayerInRangeOfPoint(playerid, 5, 1632.0836, 1551.7365, 10.8061) || IsPlayerInRangeOfPoint(playerid, 5, 2950.4014,-1283.0776,4.6875))
	{
		if(GetPVarInt(playerid, "PinConfirmed"))
		{
			ShowModelSelectionMenu(playerid, PlaneList, "Cua hang mua May bay");
		}
		else
		{
		    SetPVarInt(playerid, "OpenShop", 7);
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o tai khu vuc mua may bay.");
	}
	return 1;
}

CMD:carshop(playerid, params[])
{
    if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang hien tai da dong cua.");

	if(IsPlayerInRangeOfPoint(playerid, 4, 2280.5720, -2325.2490, 13.5469) || IsPlayerInRangeOfPoint(playerid, 4,-1731.1923, 127.4794, 3.2976) || IsPlayerInRangeOfPoint(playerid, 4, 1663.9569, 1628.5106, 10.8203) ||
	IsPlayerInRangeOfPoint(playerid, 4, 2958.2200, -1339.2900, 5.2100))
	{
		if(GetPVarInt(playerid, "PinConfirmed"))
		{
			ShowModelSelectionMenu(playerid, CarList2, "Cua hang xe");
		}
		else
		{
		    SetPVarInt(playerid, "OpenShop", 3);
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai khu vuc mua xe");
	}
	return 1;
}

/** CMD:changepin(playerid, params[])
{
    if(GetPVarInt(playerid, "PinConfirmed"))
	{
	    SetPVarInt(playerid, "ChangePin", 1);
	    ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Doi ma PIN", "Hay nhap ma pin moi cua ban de doi.", "Doi", "Huy");
	}
	else
	{
	    PinLogin(playerid);
	}
	return 1;
}
**/

CMD:houseshop(playerid, params[])
{
	if(ShopClosed == 1) return SendClientMessageEx(playerid, COLOR_GREY, "The shop is currently closed.");
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 2938.2734, -1391.0596, 11.0000) && GetPlayerVirtualWorld(playerid) == 1)
	{
		if(GetPVarInt(playerid, "PinConfirmed"))
		{
			ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP, DIALOG_STYLE_LIST, "House Shop", "Mua nha\nDoi noi that nha\nDi chuyen nha\nGarage (Nho)\nGarage (Vua)\nGarage (To)\nGarage (Lon)","Chon", "Thoat" );
		}
		else
		{
			SetPVarInt(playerid, "OpenShop", 4);
			PinLogin(playerid);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai khu vuc House Shop.");
	return 1;
}

CMD:sellcredits(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "May chu sap bao tri, nen ban khong the giao dich credits.");
	new
		Player,
		Credits,
		Amount;

	if(SellClosed == 1)
		return SendClientMessageEx(playerid, COLOR_GREY, "Lenh nay hien dang bi vo hieu hoa.");

	if(PlayerInfo[playerid][pDonateRank] < 2 && !nonvipcredits)
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the giao dich tru khi ban la Silver VIP!");

	if(sscanf(params, "udd", Player, Credits, Amount))
		return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /sellcredits [Player] [Credits] [Gia]");

	else if(!IsPlayerConnected(Player))
		return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");

	else if(Credits < 0 || Amount < 0)
		return SendClientMessageEx(playerid, COLOR_GREY, "Gia tien va credits khong duoc thap hon 0.");

	else if(Player == playerid)
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the sell credits cho chinh minh!");

	else if(Credits > PlayerInfo[playerid][pCredits])
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co credits.");

	else if(Credits < 100)
		return SendClientMessageEx(playerid, COLOR_GREY, "Giao dich credits it nhat 100 tro len");

	else if (!ProxDetectorS(10.0, playerid, Player))
		return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi do khong dung gan ban.");

	else if(GetPVarType(Player, "CreditsAmount"))
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang giao dich voi nguoi nay.");

	else if(!GetPVarInt(playerid, "PinConfirmed"))
		PinLogin(playerid);

	else
	{
		new szMessage[200], CreditsTaxed;
		new year, month, day;
		new TransactionFee;
		
		getdate(year, month, day);
		SetPVarInt(Player, "CreditsFirstAmount", Credits);
		
		if(!freeweekend)
		{
			switch(PlayerInfo[playerid][pDonateRank]) {
				case 0 .. 2: {
					CreditsTaxed = 2*Credits/100;
					Credits = Credits-10;
					Credits = Credits-CreditsTaxed;
					TransactionFee = (10+CreditsTaxed);
				}
				case 3: {
					CreditsTaxed = 2*Credits/100;
					Credits = Credits-5;
					Credits = Credits-CreditsTaxed;
					TransactionFee = (5+CreditsTaxed);
				}
				case 4 .. 5: {
					CreditsTaxed = 0;
					Credits = Credits-5;
					TransactionFee = 5;
				}
			}
		}
		
		SetPVarInt(Player, "CreditsOffer", Amount);
		SetPVarInt(Player, "CreditsAmount", Credits);
		SetPVarInt(Player, "CreditsSeller", playerid);
		SetPVarInt(playerid, "CreditsSeller", Player);

		format(szMessage, 200, "Ban da de nghi %s mua {FFD700}%s{FFFFFF} voi gia $%s. (Phi giao dich: %s credits).", GetPlayerNameEx(Player), number_format(Credits+TransactionFee), number_format(Amount), number_format(TransactionFee));
		SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

		format(szMessage, 200, "Nguoi ban: %s(%d)\nGia tien: $%s\nCredits: {FFD700}%s{A9C4E4}\nPhi giao dich: {FFD700}%s{A9C4E4} credits\nCredits nhan duoc {FFD700}%s{A9C4E4}", GetPlayerNameEx(playerid), playerid, number_format(Amount), number_format(Credits+TransactionFee), number_format(TransactionFee), number_format(Credits));
		ShowPlayerDialogEx(Player, DIALOG_SELLCREDITS, DIALOG_STYLE_MSGBOX, "Giao dich Credits", szMessage, "Mua", "Tu choi");
	}
	return 1;
}

CMD:togglehealthcare(playerid, params[])
{
	if(PlayerInfo[playerid][pHealthCare] == 0)
	{
		ShowPlayerDialogEx(playerid, DIALOG_HEALTHCARE, DIALOG_STYLE_LIST, "Cham soc suc khoe", "Cham soc suc khoe binh thuong\nCham soc suc khoe dac biet", "Chon", "Thoat");
	}
	else
	{
	    PlayerInfo[playerid][pHealthCare] = 0;
	    SendClientMessageEx(playerid, COLOR_CYAN, "Ban da tat dich vu cham soc suc khoe.");
	}
	return 1;
}

CMD:vipshop(playerid, params[])
{
	if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang hien tai da dong cua.");

	if(IsPlayerInRangeOfPoint(playerid, 4, 1024.1156, -1916.5101, 12.7565))
	{
 		if(GetPVarInt(playerid, "PinConfirmed"))
   		{
			ShowPlayerDialogEx( playerid, DIALOG_VIPSHOP, DIALOG_STYLE_LIST, "VIP Shop", "Mua VIP\nGia han VIP","Tiep tuc", "Thoat" );
		}
		else
		{
		    SetPVarInt(playerid, "OpenShop", 5);
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o tai khu vuc VIP Shop.");
	}
	return 1;
}

CMD:reloadstats(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338 && PlayerInfo[playerid][pShopTech] != 3)
	    return 0;

    mysql_tquery(MainPipeline, "SELECT * FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
    SendClientMessageEx(playerid, COLOR_WHITE, "Reloading sale stats.");
	return 1;
}

CMD:closesellcredits(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338 && PlayerInfo[playerid][pShopTech] != 3)
	    return 0;

	if(SellClosed == 0)
	{
	    SellClosed = 1;
	    SendClientMessageEx(playerid, COLOR_WHITE, "Ban da khoa giao dich credits.");
	}
	else
	{
	    SellClosed = 0;
	    SendClientMessageEx(playerid, COLOR_WHITE, "Ban da mo khoa giao dich credits.");
	}
	return 1;
}

CMD:closeshop(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338 && PlayerInfo[playerid][pShopTech] != 3)
	    return 0;

	if(ShopClosed == 0)
	{
	    ShopClosed = 1;
	    SendClientMessageEx(playerid, COLOR_WHITE, "Ban da khoa Misc Shop");
	}
	else
	{
	    ShopClosed = 0;
	    SendClientMessageEx(playerid, COLOR_WHITE, "Ban da mo khoa Misc Shop.");
	}
	g_mysql_SaveMOTD();
	return 1;
}

CMD:editshop(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1338 && PlayerInfo[playerid][pShopTech] != 3)
	    return 0;

    if (isnull(params)) {
		SendClientMessageEx(playerid, COLOR_WHITE, "SU DUNG: /editshop <code>");
		return 1;
	}

	if (strcmp(params, SecurityCode) == 0)
	{
		ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPMENU, DIALOG_STYLE_LIST, "Edit Shop", "Edit Shop Prices\nEdit Business Shop\nEdit Micro Shop", "Select", "Exit");
	    if(GetPVarType(playerid, "CodeAttempts")) DeletePVar(playerid, "CodeAttempts");
	}
	else
	{
	    if(GetPVarInt(playerid, "CodeAttempts") != 3) {
	        SendClientMessageEx(playerid, COLOR_GREY, "Password entered is invalid.");
			SetPVarInt(playerid, "CodeAttempts", GetPVarInt(playerid, "CodeAttempts")+1);
	    }
	    else
	    {
	        new string[128];
	        format(string, sizeof(string), "AdmCmd: %s has been auto-banned, reason: To many failed attempts.", GetPlayerNameEx(playerid)), ABroadCast(COLOR_YELLOW,string,2);
			PlayerInfo[playerid][pBanned] = 1;
			SystemBan(playerid, "[System] (To many failed attempts)");
			Kick(playerid);
	    }
	}
	return 1;
}

CMD:businessshop(playerid, params[])
{
    if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang hien tai da dong cua.");

	if(GetPVarInt(playerid, "PinConfirmed"))
	{
		ShowPlayerDialogEx(playerid, DIALOG_SHOPBUSINESS, DIALOG_STYLE_LIST, "Businesses Shop", "Mua cua hang\nGia han cua hang", "Tiep tuc", "Thoat");
	}
	else
	{
	    SetPVarInt(playerid, "OpenShop", 6);
		PinLogin(playerid);
	}
	return 1;
}

CMD:toyshop(playerid, params[])
{
    if(ShopClosed == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang hien tai da dong cua.");

	if (IsAtClothingStore(playerid) || IsPlayerInRangeOfPoint(playerid, 4.0, 1023.7519, -1922.7075, 12.7356))
	{
 		if(GetPVarInt(playerid, "PinConfirmed"))
   		{
   			ShowModelSelectionMenu(playerid, ToyList2, "Toy Shop");
		}
		else
		{
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai khu vuc Toy Shop.");
	}
	return 1;
}

CMD:thanksgivingshop(playerid, params[])
{
    if(HalloweenShop == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang hien tai da dong cua.");

	if (IsAtClothingStore(playerid))
	{
 		if(GetPVarInt(playerid, "PinConfirmed"))
   		{
			new string[150];
			format(string, sizeof(string), "Straw Hat (Cost: 150 Credits | Stock: %d)\nCluckin Bell Hat (Cost: 150 Credits | Stock: %d)", PumpkinStock, PumpkinStock);//\nSpiked Club Toy (Cost: 60 Credits)", PumpkinStock);
			ShowPlayerDialogEx(playerid, DIALOG_HALLOWEENSHOP, DIALOG_STYLE_LIST, "Cua hang Halloween", string, "Chon", "Thoat");
			return 1;
		}
		else
		{
  			PinLogin(playerid);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai khu vuc Toy Shop.");
	}
	return 1;
}

CMD:chargeplayer(playerid, params[])
{
	new string[128], giveplayerid, amount, reason[64];
	if(sscanf(params, "uds[64]", giveplayerid, amount, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /chargeplayer [player] [amount] [reason]");

	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pShopTech] == 2)
	{
		if(IsPlayerConnected(giveplayerid))
		{
			if (amount < 1)
				return SendClientMessageEx(playerid, COLOR_GREY, "Amount must be greater than 0");

			if(PlayerInfo[giveplayerid][pCredits] < amount)
			    return SendClientMessageEx(playerid, COLOR_GREY, "That player doesn't have that many credits.");

			format(string, sizeof(string), "You da de nghi %s a charge of %s credits for %s.",  GetPlayerNameEx(giveplayerid), number_format(amount), reason);
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			SetPVarInt(giveplayerid, "FineAmount", amount), SetPVarInt(giveplayerid, "FineBy", playerid), SetPVarString(giveplayerid, "FineReason", reason);
			format(string, sizeof(string), "Admin: %s\nReason: %s\nCredits Available: %s\nFine Amount: %s", GetPlayerNameEx(playerid), reason, number_format(PlayerInfo[giveplayerid][pCredits]), number_format(amount));
			ShowPlayerDialogEx(giveplayerid, DIALOG_CHARGEPLAYER, DIALOG_STYLE_MSGBOX, "Credit Fine", string, "Accept", "Decline");
			return 1;
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You're not a level three admin.");
	}
	return 1;
}

CMD:admgivecre(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pShopTech] != 2)
	    return 0;

	new szMessage[128], Player, Amount;

	if(sscanf(params, "ud", Player, Amount))
		return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /givecredits [Player] [Amount]");

	if(!IsPlayerConnected(Player))
	    return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");

	PlayerInfo[Player][pCredits] += Amount;

	mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `accounts` SET `Credits`=%d WHERE `id` = %d", PlayerInfo[Player][pCredits], GetPlayerSQLId(Player));
	mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szMessage);

	format(szMessage, sizeof(szMessage), "[SETCREDITS] [Amount: %d] [User: %s(%i)] [IP: %s] [Credits: %s] [Admin: %s] [IP: %s]",Amount,GetPlayerNameEx(Player), GetPlayerSQLId(Player), GetPlayerIpEx(Player), number_format(PlayerInfo[Player][pCredits]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
	Log("logs/credits.log", szMessage), print(szMessage);

	format(szMessage, sizeof(szMessage), "Ban da cho %s (%s Credits).", GetPlayerNameEx(Player), number_format(Amount));
	SendClientMessageEx(playerid, COLOR_GREEN, szMessage);
	return 1;
}

CMD:admsetcre(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 99999 && PlayerInfo[playerid][pShopTech] != 2)
	    return 0;

	new szMessage[128], Player, Amount;

	if(sscanf(params, "ud", Player, Amount))
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setcredits [Player] [Amount]");

	if(!IsPlayerConnected(Player))
	    return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");

	PlayerInfo[Player][pCredits] = Amount;

	mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `accounts` SET `Credits`=%d WHERE `id` = %d", PlayerInfo[Player][pCredits], GetPlayerSQLId(Player));
	mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szMessage);

	format(szMessage, sizeof(szMessage), "[SETCREDITS] [Amount: %d] [User: %s(%i)] [IP: %s] [Credits: %s] [Admin: %s] [IP: %s]",Amount,GetPlayerNameEx(Player), GetPlayerSQLId(Player), GetPlayerIpEx(Player), number_format(PlayerInfo[Player][pCredits]), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
	Log("logs/credits.log", szMessage), print(szMessage);

	format(szMessage, sizeof(szMessage), "You have set %s's credits to %s.", GetPlayerNameEx(Player), number_format(PlayerInfo[Player][pCredits]));
	SendClientMessageEx(playerid, COLOR_GREEN, szMessage);
	return 1;
}

CMD:adminsettotalcreditsst(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 99999 && PlayerInfo[playerid][pShopTech] != 3)
	    return 0;

	new szMessage[128], Player, Amount;

	if(sscanf(params, "ud", Player, Amount))
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /settotalcredits [Player] [Amount]");

	if(!IsPlayerConnected(Player))
	    return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");

	PlayerInfo[Player][pTotalCredits] = Amount;

    mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `accounts` SET `TotalCredits`=%d WHERE `id` = %d", PlayerInfo[Player][pTotalCredits], GetPlayerSQLId(Player));
	mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);

	format(szMessage, sizeof(szMessage), "[SETTOTALCREDITS][Amount: %d] [User: %s(%i)] [IP: %s] [Admin: %s] [IP: %s]",Amount, GetPlayerNameEx(Player), GetPlayerSQLId(Player), GetPlayerIpEx(Player), GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
	Log("logs/credits.log", szMessage), print(szMessage);

	format(szMessage, sizeof(szMessage), "You have set %s's total credits to %s.", GetPlayerNameEx(Player), number_format(PlayerInfo[Player][pTotalCredits]));
	SendClientMessageEx(playerid, COLOR_CYAN, szMessage);
	return 1;
}

CMD:toghalloweenshop(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1337 || PlayerInfo[playerid][pPR] == 2 || PlayerInfo[playerid][pShopTech] == 3)
	{
		new string[128];
		if(HalloweenShop)
		{
			HalloweenShop = 0;
			SendClientMessageEx(playerid, COLOR_RED, "You have toggled the halloween shop on.  It will now be available to players.");
			g_mysql_SaveMOTD();
			format(string, sizeof(string), "Admin %s(%i) has toggled the halloween toy shop on.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid) );
			Log("logs/zombiecure.log", string);
		}
		else{
			HalloweenShop = 1;
			SendClientMessageEx(playerid, COLOR_RED, "You have toggled the halloween shop off.  It will not be available to players.");
			g_mysql_SaveMOTD();
			format(string, sizeof(string), "Admin %s(%i) has toggled the halloween toy shop off.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid) );
			Log("logs/zombiecure.log", string);
		}
	}
	return 1;
}

CMD:setpumpkinstock(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1337 || PlayerInfo[playerid][pPR] == 2 || PlayerInfo[playerid][pShopTech] == 3)
	{
		new string[128], pumpkins;
		if(sscanf(params, "d", pumpkins)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setpumpkinstock [stock]");
		format(string, sizeof(string), "You have set the pumpkin stock to %d.", pumpkins);
		SendClientMessageEx(playerid, COLOR_GRAD1, string);
		format(string, sizeof(string), "Admin %s(%i) has set the pumpkin stock to %d from %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), pumpkins, PumpkinStock );
		Log("logs/zombiecure.log", string);
		PumpkinStock = pumpkins;
		g_mysql_SaveMOTD();
	}
	return 1;
}

CMD:microshop(playerid, params[])
{
	DeletePVar(playerid, "m_listitem");
	DeletePVar(playerid, "m_Item");
	DeletePVar(playerid, "m_Response");
	if(GetPVarInt(playerid, "PinConfirmed")) ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP, DIALOG_STYLE_LIST, "Mirco Shop", "Cong viec\nVIP\nThuc an\nHouse\nPhuong tien\nChung\nSu kien", "Tiep tuc", "Thoat");
	else SetPVarInt(playerid, "OpenShop", 11), PinLogin(playerid);
	return 1;
}

CMD:placesign(playerid, params[])
{
	if(!PlayerInfo[playerid][mInventory][6]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co BANG BAN NHA, hay su dung (/mircoshop > House > Bang ban nha) de mua.");
	new h = InRangeOfWhichHouse(playerid, 10);
	if(h == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai o pham vi 10 met de dat bang ban nha xuong.");
	if(HouseInfo[h][hSignExpire]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da co bang ban nha, su dung /editsign de chinh sua vi tri hoac chinh sua van ban.");
	if(GetPVarType(playerid, "signID")) return SendClientMessageEx(playerid, COLOR_GREY, "Hay hoan thien mot bang ban nha nha truoc khi dat mot cai khac.");
	ClearCheckpoint(playerid);
	new Float:pos[4];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);
	SetPVarInt(playerid, "house", h);
	SetPVarInt(playerid, "editingsign", 1);
	SetPVarInt(playerid, "signID", CreateDynamicObject(19471, pos[0]+1, pos[1], pos[2], 0, 0, pos[3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));
	EditDynamicObject(playerid, GetPVarInt(playerid, "signID"));
	SendClientMessageEx(playerid, 0xFFFFAAAA, "MEO: Giu phim {8000FF}~k~~PED_SPRINT~ {FFFFAA}de di chuyen goc nhin.");
	SetPlayerCheckpoint(playerid, HouseInfo[h][hExteriorX], HouseInfo[h][hExteriorY], HouseInfo[h][hExteriorZ], 20);
	SendClientMessageEx(playerid, COLOR_GREY, "Hay di chuyen den vi tri ban muon va luu lai.");
	return 1;
}

CMD:editsign(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new h, option[10], desc[64];
		if(sscanf(params, "ds[10]S()[64]", h, option, desc)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /editsign [houseid] [tuy chon]"), SendClientMessageEx(playerid, COLOR_GREY, "Available options: text, position");
		if(HouseInfo[h][hSignExpire] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay chua co bang ban nha, hay /placesign de dat ra.");
		if(!strcmp(option, "text", true))
		{
			if(!(1 <= strlen(desc) <= 64)) return SendClientMessageEx(playerid, COLOR_GREY, "Noi dung ghi vao bang ban nha toi thieu 64 ki tu.");
			new string[128], escapeDesc[64];
			mysql_escape_string(desc, escapeDesc);
			format(HouseInfo[h][hSignDesc], sizeof(escapeDesc), "%s", escapeDesc);
			format(string, sizeof(string), "%s has edited house ID: %d sale sign text to %s", GetPlayerNameEx(playerid), h, HouseInfo[h][hSignDesc]);
			Log("logs/hedit.log", string);
			SendClientMessageEx(playerid, -1, string);
		}
		if(!strcmp(option, "position", true))
		{
			ClearCheckpoint(playerid);
			SetPVarInt(playerid, "house", h);
			SetPVarInt(playerid, "editingsign", 3);
			SetPVarInt(playerid, "signID", HouseInfo[h][hSignObj]);
			EditDynamicObject(playerid, GetPVarInt(playerid, "signID"));
			SendClientMessageEx(playerid, 0xFFFFAAAA, "MEO: Giu phim {8000FF}~k~~PED_SPRINT~ {FFFFAA}de di chuyen goc nhin.");
			SetPlayerCheckpoint(playerid, HouseInfo[h][hExteriorX], HouseInfo[h][hExteriorY], HouseInfo[h][hExteriorZ], 20);
			SendClientMessageEx(playerid, COLOR_GREY, "Hay di chuyen den vi tri ban muon va luu lai.");
		}
		return 1;
	}
	if(GetPVarType(playerid, "editingsign")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da chinh sua bang ban nha cua ban.");
	new h = InRangeOfWhichHouse(playerid, 10);
	if(h == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai dung gan nhat 10 met tai vi tri ngoi nha ban de chinh sua bang ban nha");
	if(HouseInfo[h][hSignExpire] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay da co bang ban nha, /placesign de dat ra.");
	new option[10], desc[64];
	if(sscanf(params, "s[10]S()[64]", option, desc)) return 
					SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /editsign [Tuy chon]"), 
					SendClientMessageEx(playerid, COLOR_GREY, "TUY CHON: text, position");
	if(!strcmp(option, "text", true))
	{
		if(GetPVarType(playerid, "HasReport")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chi co the gui 1 bao cao duy nhat trong luc nay. (/huybaocao)");
		if(isnull(desc)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editsign text [noi dung]");
		if(!(1 <= strlen(desc) <= 64)) return SendClientMessageEx(playerid, COLOR_GREY, "Noi dung ghi vao bang ban nha toi thieu 64 ki tu.");
		new string[128];
		SetPVarInt(playerid, "hSignRequest", h);
		SetPVarString(playerid, "hSignRequestText", desc);
		format(string, sizeof(string), "Ban da doi noi dung bang ban nha cua House ID: %d, hay cho General Admin+ phe duyet.", h);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "Bang ban nha da duoc doi noi dung (HID: %d)", h);
		SendReportToQue(playerid, string, 2, 4);
	}
	if(!strcmp(option, "position", true))
	{
		ClearCheckpoint(playerid);
		SetPVarInt(playerid, "house", h);
		SetPVarInt(playerid, "editingsign", 2);
		SetPVarInt(playerid, "signID", HouseInfo[h][hSignObj]);
		EditDynamicObject(playerid, GetPVarInt(playerid, "signID"));
		SendClientMessageEx(playerid, 0xFFFFAAAA, "HINT: Giu phim {8000FF}~k~~PED_SPRINT~ {FFFFAA}de di chuyen goc nhin.");
		SetPlayerCheckpoint(playerid, HouseInfo[h][hExteriorX], HouseInfo[h][hExteriorY], HouseInfo[h][hExteriorZ], 20);
		SendClientMessageEx(playerid, COLOR_GREY, "Hay di chuyen den vi tri ban muon va luu lai.");
	}
	return 1;
}

CMD:readsign(playerid, params[])
{
	for(new i; i < MAX_HOUSES; i++)
	{
		if(!HouseInfo[i][hSignExpire]) continue;
		if(IsPlayerInRangeOfPoint(playerid, 5, HouseInfo[i][hSign][0], HouseInfo[i][hSign][1], HouseInfo[i][hSign][2]))
		{
			if(isnull(HouseInfo[i][hSignDesc])) format(HouseInfo[i][hSignDesc], 64, "Khong co noi dung");
			return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Noi dung chu nha da ghi", HouseInfo[i][hSignDesc], "Da doc", "");
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan bang ban nha nao ca.");
	return 1;
}

CMD:fuelcan(playerid, params[])
{
	if(!PlayerInfo[playerid][mInventory][7]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co binh xang, hay su dung (/microshop > Phuong tien > Binh xang) de mua.");
	if(GetPVarInt(playerid, "fuelcan") == 1) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the lam dieu nay khi ngoi trong phuong tien.");
	if(GetPVarInt(playerid, "EventToken")) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the lam dieu nay trong su kien.");
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay luc nay!");
	new closestcar = GetClosestCar(playerid);
	if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 10.0)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong dung gan phuong tien nao ca.");
	new string[72];
	format(string, sizeof(string), "%s da lay binh xang va do vao xe.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	ApplyAnimation(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0, 1);
	SetTimerEx("FuelCan", 10000, false, "iii", playerid, closestcar, 100);
	SetPVarInt(playerid, "fuelcan", 1);
	GameTextForPlayer(playerid, "~w~DANG DO XANG...", 10000, 3);
	return 1;
}

CMD:jumpstart(playerid, params[])
{
	if(!PlayerInfo[playerid][mInventory][8]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co hop dung cu sua xe, hay su dung (/microshop > Phuong tien > Hop dung cu sua xe) de mua.");
	if(GetPVarInt(playerid, "jumpstarting") == 1) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the lam dieu nay khi ngoi trong phuong tien.");
	if(GetPVarInt(playerid, "EventToken")) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the lam dieu nay trong su kien.");
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay luc nay!");
	new closestcar = GetClosestCar(playerid);
	if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 10.0)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong dung gan phuong tien nao ca.");
	if(!IsABike(closestcar) && !IsAPlane(closestcar))
	{
		new engine,lights,alarm,doors,bonnet,boot,objective;
		GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
		if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD1, "Phuong tien chua duoc mo mui xe (/car hood).");
	}
	new string[61];
	format(string, sizeof(string), "%s da lay hop dung cu ra va sua xe.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	ApplyAnimation(playerid, "MISC", "Plunger_01", 4.1, 1, 1, 1, 1, 1, 1);
	SetTimerEx("JumpStart", 10000, false, "ii", playerid, closestcar);
	SetPVarInt(playerid, "jumpstarting", 1);
	GameTextForPlayer(playerid, "~w~SUA XE...", 10000, 3);
	return 1;
}

CMD:rcarcolor(playerid, params[])
{
	if(!PlayerInfo[playerid][mInventory][9]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Binh son xe VIP, hay su dung (/microshop > Phuong tien > Binh son xe VIP) de mua.");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong ngoi tren phuong tien nao ca.");
	new iColors[2];
	if(sscanf(params, "dd", iColors[0], iColors[1])) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rcarcolor [color1] [color2]");
	if(!(128 <= iColors[0] <= 255 && 0 <= iColors[1] <= 255)) return SendClientMessageEx(playerid, COLOR_GRAD2, "ID Color phuong tien it tu 128 den 255.");
	new szMessage[128];
	for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
	{
		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][i][pvId]))
		{
			PlayerVehicleInfo[playerid][i][pvColor1] = iColors[0], PlayerVehicleInfo[playerid][i][pvColor2] = iColors[1];
			ChangeVehicleColor(PlayerVehicleInfo[playerid][i][pvId], PlayerVehicleInfo[playerid][i][pvColor1], PlayerVehicleInfo[playerid][i][pvColor2]);
			PlayerInfo[playerid][mInventory][9]--;
			g_mysql_SaveVehicle(playerid, i);
			format(szMessage, sizeof(szMessage), "[RCARCOLOR] %s(%d) used a restricted car color. Left: %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][mInventory][9]);
			Log("logs/micro.log", szMessage);
			format(szMessage, sizeof(szMessage), "Ban da doi phuong tien ban thanh mau %d, %d.", iColors[0], iColors[1]);
			return SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai ngoi tren chiec xe ma ban so huu.");
	return 1;
}

CMD:eatbar(playerid, params[])
{
	if(!PlayerInfo[playerid][mInventory][4]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Nuoc Tang Luc, hay su dung (/microshop > Phuong tien > Nuoc Tang Luc) de mua.");
	if(GetPVarInt(playerid, "eatingbar") == 1) return 1;
	new string[128];
	if(PlayerInfo[playerid][mCooldown][4]) 
	{
		format(string, sizeof(string), "Ban da su dung Nuoc Tang Luc, no se het hieu luc sau %d phut moi co the su dung lai.", PlayerInfo[playerid][mCooldown][4]);
		return SendClientMessageEx(playerid, COLOR_GRAD2, string);
	}
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 1, 0, 0, 0, 0, 1);
	format(string, sizeof(string), "%s dang su dung Nuoc Tang Luc.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	SetPVarInt(playerid, "eatingbar", 1);
	SetTimerEx("EatBar", 2000, false, "i", playerid);
	return 1;
}

CMD:activeitems(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][mPurchaseCount][1] && PlayerInfo[playerid][mCooldown][1]) format(string, sizeof(string), "You currently have an active Job Boost for the %s job for another %d minute(s).", GetJobName(PlayerInfo[playerid][mBoost][0]), PlayerInfo[playerid][mCooldown][1]), SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][mCooldown][4]) format(string, sizeof(string), "Ban da su dung Nuoc Tang Luc, het hieu luc sau %d phut.", PlayerInfo[playerid][mCooldown][4]), SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][mPurchaseCount][12] && PlayerInfo[playerid][mCooldown][12]) format(string, sizeof(string), "You currently have a Quick Bank Access for another %d minute(s).", PlayerInfo[playerid][mCooldown][12]), SendClientMessageEx(playerid, -1, string);
	if(zombieevent) format(string, sizeof(string), "You currently have a antibiotic flowing through your bloodstream protecting you from %d zombie bite(s).", PlayerInfo[playerid][mInventory][18]), SendClientMessageEx(playerid, -1, string);
	return 1;
}

CMD:cooldowns(playerid, params[])
{
	new string[128];
	for(new item; item < MAX_MICROITEMS; item++)
	{
		if(gettime() < PlayerInfo[playerid][mCooldown][item])
		{
			format(string, sizeof(string), "You can purchase another \"%s\" in %s.", mItemName[item], ConvertTimeS(PlayerInfo[playerid][mCooldown][item]-gettime()));
			SendClientMessageEx(playerid, -1, string);
		}
	}
	return 1;
}

CMD:managecredits(playerid, params[]) 
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pShopTech] >= 3)
		return ShowPlayerDialogEx(playerid, DIALOG_MANAGECREDITS, DIALOG_STYLE_LIST, "Manage Credits",  "Credits Selling\nFree Weekend\nNon-VIP Credit Selling", "Okay", "Cancel");
	return 0;
}

forward OnShopOrder(index);
public OnShopOrder(index)
{
	if(IsPlayerConnected(index))
	{
	    HideNoticeGUIFrame(index);
		new rows;
		cache_get_row_count(rows);
		if(rows > 0)
		{
		    new string[512];
		    new ipsql[16], ip[16];
	    	GetPlayerIp(index, ip, sizeof(ip));
		    cache_get_value_name(0, "ip", ipsql);
		    if(!isnull(ipsql) && strcmp(ipsql, ip, true) == 0)
			{
			    new status, name[64], quantity, delivered, product_id;
			    for(new i;i<rows;i++)
			    {
	   				cache_get_value_name_int(i, "order_status_id", status);
			    	if(status == 2)
				    {
	    			 	cache_get_value_name(i, "name", name);
			  			cache_get_value_name_int(i, "quantity", quantity);
			  		    cache_get_value_name_int(i, "delivered", delivered);
			  			cache_get_value_name_int(i, "order_product_id", product_id);
				    	if(quantity-delivered <= 0)
					    {
	        				if(i<rows) format(string, sizeof(string), "%s%s (Delivered)\n", string, name);
					        else format(string, sizeof(string), "%s%s (Delivered)", string, name);
						}
						else
						{
		    				if(i<rows) format(string, sizeof(string), "%s%s (%d)\n", string, name, quantity-delivered);
					    	else format(string, sizeof(string), "%s%s (%d)", string, name, quantity-delivered);
						}
					}
					else
					{
					    new reason[27];
						switch(status)
						{
						    case 0: format(reason, sizeof(reason), "{FF0000}No Payment");
						    case 1: format(reason, sizeof(reason), "{FF0000}Pending");
						    case 3: format(reason, sizeof(reason), "{00FF00}Shipped");
						    case 5:
							{
								ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "This order has already been delivered", "OK", "");
								return 1;
							}
			    			case 7: format(reason, sizeof(reason), "{FF0000}Cancelled");
					    	case 8: format(reason, sizeof(reason), "{FF0000}Denied");
				   			case 9: format(reason, sizeof(reason), "{FF0000}Cancelled Reversal");
					    	case 10: format(reason, sizeof(reason), "{FF0000}Failed");
						    case 11: format(reason, sizeof(reason), "{00FF00}Refundend");
						    case 12: format(reason, sizeof(reason), "{FF0000}Reversed");
						    case 13: format(reason, sizeof(reason), "{FF0000}Chargeback");
				   			default: format(reason, sizeof(reason), "{FF0000}Unknown");
						}
						format(string, sizeof(string), "We are unable to process that order at this time,\nbecause the payment is currently marked as: %s", reason);
						ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", string, "OK", "");
	  					return 1;
					}
				}
			}
			else
			{
			    new email[256];
			    cache_get_value_name(0, "email", email);
			    SetPVarString(index, "ShopEmailVerify", email);
			    ShowPlayerDialogEx(index, DIALOG_SHOPORDEREMAIL, DIALOG_STYLE_INPUT, "Shop Order Error", "We were unable to link your order to your IP,\nfor further verification of your identity please input your shop e-mail address:", "Submit", "Cancel");
			    return 1;
			}
			ShowPlayerDialogEx(index, DIALOG_SHOPORDER2, DIALOG_STYLE_LIST, "Shop Order List", string, "Select", "Cancel");
		}
		else
		{
		    ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "Error: No orders were found by that Order ID\nIf you are sure that is the correct Order ID, please try again or input '1' for your order ID.", "OK", "");
		}
	}
	return 1;
}

forward OnShopOrderEmailVer(index);
public OnShopOrderEmailVer(index)
{
	if(IsPlayerConnected(index))
	{
	    HideNoticeGUIFrame(index);
		new rows;
		cache_get_row_count(rows);
		if(rows > 0)
		{
		    new string[512];
		   	new status, name[64], quantity, delivered, product_id;
		    for(new i; i < rows; i++)
		    {
			    cache_get_value_name_int(i, "order_status_id", status);
				if(status == 2)
	   			{
					cache_get_value_name(i, "name", name);
	 				cache_get_value_name_int(i, "quantity", quantity);
		    		cache_get_value_name_int(i, "delivered", delivered);
	  				cache_get_value_name_int(i, "order_product_id", product_id);
		   			if(quantity-delivered <= 0)
				    {
	   					if(i<rows) format(string, sizeof(string), "%s%s (Delivered)\n", string, name);
	       				else format(string, sizeof(string), "%s%s (Delivered)", string, name);
					}
					else
					{
					    if(i<rows) format(string, sizeof(string), "%s%s (%d)\n", string, name, quantity-delivered);
					    else format(string, sizeof(string), "%s%s (%d)", string, name, quantity-delivered);
					}
				}
				else
				{
	    			new reason[27];
					switch(status)
					{
	    				case 0: format(reason, sizeof(reason), "{FF0000}No Payment");
		   				case 1: format(reason, sizeof(reason), "{FF0000}Pending");
					    case 3: format(reason, sizeof(reason), "{00FF00}Shipped");
					    case 5:
						{
							ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "This order has already been delivered", "OK", "");
							return 1;
						}
			   			case 7: format(reason, sizeof(reason), "{FF0000}Cancelled");
					    case 8: format(reason, sizeof(reason), "{FF0000}Denied");
					    case 9: format(reason, sizeof(reason), "{FF0000}Cancelled Reversal");
					    case 10: format(reason, sizeof(reason), "{FF0000}Failed");
			   			case 11: format(reason, sizeof(reason), "{00FF00}Refundend");
					    case 12: format(reason, sizeof(reason), "{FF0000}Reversed");
					    case 13: format(reason, sizeof(reason), "{FF0000}Chargeback");
					    default: format(reason, sizeof(reason), "{FF0000}Unknown");
					}
					format(string, sizeof(string), "We are unable to process that order at this time,\nbecause the payment is currently marked as: %s", reason);
					ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", string, "OK", "");
	 				return 1;
				}
			}
			ShowPlayerDialogEx(index, DIALOG_SHOPORDER2, DIALOG_STYLE_LIST, "Shop Order List", string, "Select", "Cancel");
		}
		else
		{
		    ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "Error: No orders were found by that Order ID\nIf you are sure that is the correct Order ID, please try again or input '1' for your order ID.", "OK", "");
		}
	}
	return 1;
}

forward OnShopOrder2(index, extraid);
public OnShopOrder2(index, extraid)
{
	if(IsPlayerConnected(index))
	{
	    HideNoticeGUIFrame(index);
		new string[256];
		new rows;
		cache_get_row_count(rows);
		if(rows > 0)
		{
		    for(new i; i < rows; i++)
		    {
	  			if(i == extraid)
		    	{
	      			new status;
		        	cache_get_value_name_int(i, "status", status);
			        if(status == 2)
		        	{
			    		new order_id, order_product_id, product_id, name[64], price, user[32], quantity, delivered;
				    	cache_get_value_name_int(i, "order_id", order_id);
						cache_get_value_name_int(i, "order_product_id", order_product_id);
						cache_get_value_name_int(i, "product_id", product_id);
						cache_get_value_name(i, "name", name);
		  				cache_get_value_name_int(i, "price", price);
			  			cache_get_value_name(i, "deliveruser", user);
			  			cache_get_value_name_int(i, "quantity", quantity);
			  			cache_get_value_name_int(i, "delivered", delivered);

						format(string, sizeof(string), "Order ID: %d\nProduct ID: %d\nProduct: %s\nPrice: %s\nName: %s\nQuantity: %d", \
						order_id, order_product_id, name, price, user, quantity-delivered);

						SetPVarInt(index, "DShop_order_id", order_id);
						SetPVarInt(index, "DShop_product_id", product_id);
						SetPVarString(index, "DShop_name", name);
						SetPVarInt(index, "DShop_quantity", quantity-delivered);

						ShowPlayerDialogEx(index, DIALOG_SHOPDELIVER, DIALOG_STYLE_LIST, "Shop Order Info", string, "Deliver", "Cancel");
						return 1;
					}
					else
					{
						new reason[27];
						switch(status)
						{
						    case 0: format(reason, sizeof(reason), "{FF0000}No Payment");
						    case 1: format(reason, sizeof(reason), "{FF0000}Pending");
						    case 3: format(reason, sizeof(reason), "{00FF00}Shipped");
						    case 5:
							{
								ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "This order has already been delivered", "OK", "");
								return 1;
							}
				   			case 7: format(reason, sizeof(reason), "{FF0000}Cancelled");
						    case 8: format(reason, sizeof(reason), "{FF0000}Denied");
						    case 9: format(reason, sizeof(reason), "{FF0000}Cancelled Reversal");
						    case 10: format(reason, sizeof(reason), "{FF0000}Failed");
						    case 11: format(reason, sizeof(reason), "{00FF00}Refundend");
						    case 12: format(reason, sizeof(reason), "{FF0000}Reversed");
						    case 13: format(reason, sizeof(reason), "{FF0000}Chargeback");
						    default: format(reason, sizeof(reason), "{FF0000}Unknown");
						}
						format(string, sizeof(string), "We are unable to process that order at this time,\nbecause the payment is currently marked as: %s", reason);
						ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", string, "OK", "");
	  					return 1;
					}
				}
			}
		}
		else
		{
		    ShowPlayerDialogEx(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "Error: No orders were found by that Order ID\nIf you are sure that is the correct Order ID, please try again or input '1' for your order ID.", "OK", "");
		}
	}
	return 1;
}

forward OnProcessOrderCheck(index, extraid);
public OnProcessOrderCheck(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		new string[256],playerip[32], giveplayerip[32];
		GetPlayerIp(index, playerip, sizeof(playerip));
		GetPlayerIp(extraid, giveplayerip, sizeof(giveplayerip));

		new rows;
		cache_get_row_count(rows);
		if(rows)
		{
			SendClientMessageEx(index, COLOR_WHITE, "This order has previously been processed, therefore it did not count toward your pay.");
			format(string, sizeof(string), "%s(IP: %s) has processed shop order ID %d from %s(IP: %s).", GetPlayerNameEx(index), playerip, GetPVarInt(index, "processorder"), GetPlayerNameEx(extraid), giveplayerip);
			Log("logs/shoporders.log", string);
		}
		else
		{
			format(string, sizeof(string), "%s(IP: %s) has processed shop order ID %d from %s(IP: %s).", GetPlayerNameEx(index), playerip, GetPVarInt(index, "processorder"), GetPlayerNameEx(extraid), giveplayerip);
			Log("logs/shopconfirmedorders.log", string);
			PlayerInfo[index][pShopTechOrders]++;

			mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO shoptech (id,total,dtotal) VALUES (%d,1,%f) ON DUPLICATE KEY UPDATE total = total + 1, dtotal = dtotal + %f", GetPlayerSQLId(index), ShopTechPay, ShopTechPay);
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, index);

			mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `orders` (`id`) VALUES ('%d')", GetPVarInt(index, "processorder"));
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
			
			/*format(string, sizeof(string), "INSERT INTO betazorder_history (`order_id`, `order_status_id`, `comment`, `date_added`, `notify`) \
			VALUES ('%d', '5', 'Order Processed (%s) (Status: Complete)', NOW(), '1')", GetPVarInt(index, "processorder"), GetPlayerNameEx(index));
			mysql_tquery(ShopPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
			
			format(string, sizeof(string), "UPDATE betazorder SET `order_status_id` = '5' WHERE `order_id` = '%d'", GetPVarInt(index, "processorder"));
			mysql_tquery(ShopPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);*/
		}
		DeletePVar(index, "processorder");
	}
	return 1;
}
