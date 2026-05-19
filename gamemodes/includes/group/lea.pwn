/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						LEnhom Type

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
stock ShowBackupActiveForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, BackupText[playerid]);
}

stock HideBackupActiveForPlayer(playerid)
{
	PlayerTextDrawHide(playerid, BackupText[playerid]);
}

forward SetPlayerFree(playerid,declare,reason[]);
public SetPlayerFree(playerid,declare,reason[])
{
	if(IsPlayerConnected(playerid))
	{
		ClearCrimes(playerid, declare);
		new string[128];
		foreach(new i: Player)
		{
			if(IsACop(i))
			{
				format(string, sizeof(string), "HQ: Officer %s da bat giam thanh cong.", GetPlayerNameEx(declare));
				SendClientMessageEx(i, COLOR_DBLUE, string);
				format(string, sizeof(string), "HQ: Doi tuong: %s da duoc dua vao tu, ly do: %s.", GetPlayerNameEx(playerid), reason);
				SendClientMessageEx(i, COLOR_DBLUE, string);
			}
		}	
	}
}

stock IsACopCar(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA) return 1;
		}
	}
	return 0;
}

stock CuffTacklee(playerid, giveplayerid)
{
	new string[128], Float: health, Float: armor;
    ClearTackle(giveplayerid);
	format(string, sizeof(string), "* You have been handcuffed by %s.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "* You handcuffed %s, till uncuff.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "* %s handcuffs %s, tightening the cuffs securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	GameTextForPlayer(giveplayerid, "~r~Cuffed", 2500, 3);
	TogglePlayerControllable(giveplayerid, 0);
	ClearAnimationsEx(giveplayerid);
	ClearAnimationsEx(playerid);
	GetHealth(giveplayerid, health);
	GetArmour(giveplayerid, armor);
	SetPVarFloat(giveplayerid, "cuffhealth",health);
	SetPVarFloat(giveplayerid, "cuffarmor",armor);
	SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
	ApplyAnimation(giveplayerid,"ped","cower",1,1,0,0,0,0,1);
	PlayerCuffed[giveplayerid] = 2;
	SetPVarInt(giveplayerid, "PlayerCuffed", 2);
	SetPVarInt(giveplayerid, "IsFrozen", 1);
	//Frozen[giveplayerid] = 1;
	PlayerCuffedTime[giveplayerid] = 300;
	PlayerFacePlayer(playerid, giveplayerid);
	return 1;
}

stock ClearTackle(playerid)
{
    TogglePlayerControllable(playerid, 1);
	//PreloadAnimLib(playerid, "SUNBATHE");
	//PreloadAnimLib(GetPVarInt(playerid, "IsTackled"), "SUNBATHE");
    ApplyAnimation(playerid, "SUNBATHE", "Lay_Bac_out", 4.1, 0, 1, 1, 0, 0, 1);
	SetPVarInt(playerid, "CantBeTackledCount", 15); // cant be tackled again for 15 seconds
	DeletePVar(GetPVarInt(playerid, "IsTackled"), "Tackling");
	DeletePVar(playerid, "IsTackled");
	DeletePVar(playerid, "TackleCooldown");
	DeletePVar(playerid, "TackledResisting");
	DeletePVar(playerid, "IsFrozen");
	ShowPlayerDialogEx(playerid, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
	return 1;
}

forward DragPlayer(dragger, dragee);
public DragPlayer(dragger, dragee)
{
	if(!IsPlayerConnected(dragger)) SendClientMessageEx(dragee, COLOR_GRAD2, "The player that was dragging you has disconnected.");
	if(!IsPlayerConnected(dragee))
	{
		DeletePVar(dragger, "DraggingPlayer");
		SendClientMessageEx(dragger, COLOR_GRAD2, "The player you were dragging has disconnected.");
	}
	if(GetPVarType(dragger, "DraggingPlayer") && GetPVarType(dragger, "DraggingPlayer"))
	{
		new Float:dX, Float:dY, Float:dZ;
		GetPlayerPos(dragger, dX, dY, dZ);
		floatsub(dX, 0.4);
		floatsub(dY, 0.4);

		SetPVarFloat(dragee, "DragX", dX);
		SetPVarFloat(dragee, "DragY", dY-1.5);
		SetPVarFloat(dragee, "DragZ", dZ);
		SetPVarInt(dragee, "DragWorld", GetPlayerVirtualWorld(dragger));
		SetPVarInt(dragee, "DragInt", GetPlayerInterior(dragger));
		Streamer_UpdateEx(dragee, dX, dY-1, dZ);
		SetPlayerPos(dragee, dX, dY-1, dZ);
		SetPlayerInterior(dragee, GetPlayerInterior(dragger));
		SetPlayerVirtualWorld(dragee, GetPlayerVirtualWorld(dragger));
		ClearAnimationsEx(dragee);
		ApplyAnimation(dragee, "ped","cower",1,1,0,0,0,0,1);
        SetTimerEx("DragPlayer", 1000, 0, "ii", dragger, dragee);
	}
	return 1;
}

forward CuffTackled(playerid, giveplayerid);
public CuffTackled(playerid, giveplayerid)
{
	new string[128];
	if(!GetPVarType(giveplayerid, "IsTackled"))
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "The suspect has escaped your tackle.  Tackle or Taze him again or get them to comply!");
	}
	if(GetPVarType(giveplayerid, "TackledResisting")) // If they haven't chosen - we assume they're resisting
	{
	    if(GetPVarInt(giveplayerid, "TackledResisting") == 1) // complying
	    {
			if(GetPVarType(giveplayerid, "IsTackled"))
			{
				return CuffTacklee(playerid, giveplayerid);
			}
		}
	    if(GetPVarInt(giveplayerid, "TackledResisting") == 2) // resisting
	    {
	        new copcount;
			foreach(new j: Player)
			{
				if(ProxDetectorS(4.0, giveplayerid, j) && IsACop(j) && j != giveplayerid)
				{
					copcount++;
				}
			}	
	        format(string, sizeof(string), "* %s pushes and attempts to resist %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    		ProxDetector(30.0, giveplayerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        new cuffchance = random(11);
	        if(copcount >= 2 && copcount < 5) cuffchance = random(6);
			else if(copcount >= 5) cuffchance = 1;
			switch(cuffchance)
			{
			    case 0..4: // success
			    {
			        return CuffTacklee(playerid, giveplayerid);
			    }
				default: // fail
				{
					format(string, sizeof(string), "* %s pushes %s aside and is able to escape.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    				ProxDetector(30.0, giveplayerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    				TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 1, 1, 1, 0, 1);
					SetTimerEx("CopGetUp", 3500, 0, "i", playerid);
				 	ClearTackle(giveplayerid);
				}
			}
	    }
	}
	else
	{
	    ShowPlayerDialogEx(giveplayerid, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
	    SetPVarInt(giveplayerid, "TackledResisting", 2);
		CuffTackled(playerid, giveplayerid);
	}
	return 1;
}

forward CopGetUp(playerid);
public CopGetUp(playerid)
{
    SetPVarInt(playerid, "CopTackleCooldown", 30); // a Cooldown on when the cop can tackle again after tackling someone
	DeletePVar(playerid, "Tackling");
    SendClientMessageEx(playerid, COLOR_GRAD2, "It will be 30 seconds before you can tackle again.");
	TogglePlayerControllable(playerid, 1);
	//PreloadAnimLib(playerid, "SUNBATHE");
	ApplyAnimation(playerid, "SUNBATHE", "Lay_Bac_out", 4.0, 0, 1, 1, 0, 0, 1);
	return 1;
}

stock TacklePlayer(playerid, tacklee)
{
	new string[128], Float: posx, Float: posy, Float: posz, group[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
	//PreloadAnimLib(playerid, "PED");
	format(string, sizeof(string), "** %s leaps at %s, tackling them.", GetPlayerNameEx(playerid), GetPlayerNameEx(tacklee));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	SetPVarInt(tacklee, "IsTackled", playerid);
	TogglePlayerControllable(tacklee, 0);
	SetPVarInt(tacklee, "IsFrozen", 1);
	SetPVarInt(tacklee, "TackleCooldown", 20); //Actually a countdown till the tackle is over
	SetPVarInt(playerid, "Tackling", tacklee);
	GetPlayerPos(tacklee, posx, posy,posz);
	SetPlayerFacingAngle(playerid, 180.0);
	SetPlayerFacingAngle(tacklee, 0.0);
	GetXYBehindPlayer(tacklee, posx, posy, 0.5);
	ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 20000, 1);
	ApplyAnimation(tacklee, "DILDO", "Dildo_Hit_3", 4.1, 0, 1, 1, 1, 20000, 1);
	GetPlayerGroupInfo(playerid, group, rank, division);
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Push ~r~'~k~~CONVERSATION_YES~' ~n~~w~to get up off the suspect.", 15000, 3);
	format(string, sizeof(string), "%s %s %s has tackled you.  Do you wish to comply or resist?", group, rank, GetPlayerNameEx(playerid));
	ShowPlayerDialogEx(tacklee, DIALOG_TACKLED, DIALOG_STYLE_MSGBOX, "You've been tackled", string, "Comply", "Resist");
	if(GetPVarType(tacklee, "FixVehicleTimer")) KillTimer(GetPVarInt(tacklee, "FixVehicleTimer")), DeletePVar(tacklee, "FixVehicleTimer");
	return 1;
}

forward TazerTimer(playerid);
public TazerTimer(playerid)
{
	if(TazerTimeout[playerid] > 0)
   	{
		new string[128];
   		format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~r~Tazer reloading... ~w~%d", TazerTimeout[playerid]);
		GameTextForPlayer(playerid, string,1500, 3);
		TazerTimeout[playerid] -= 1;
		SetTimerEx("TazerTimer",1000,false,"d",playerid);
   	}
	return 1;
}

forward BackupClear(playerid, calledbytimer);
public BackupClear(playerid, calledbytimer)
{
	if(IsPlayerConnected(playerid) && PlayerInfo[playerid][pMember] >= 0 && PlayerInfo[playerid][pMember] <= MAX_GROUPS)
	{
		if(IsACop(playerid) || IsAMedic(playerid) || arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_TOWING)
		{
			if (Backup[playerid] > 0)
			{
			    foreach(new i: Player)
				{
					if(IsACop(i))
					{
						SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
					}
				}	
				SetPlayerToTeamColor(playerid);
				new string[128];
				if (calledbytimer != 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Yeu cau ho tro cua ban da het thoi gian.");
					format(string, sizeof(string), "* %s khong yeu cau tro ho them.", GetPlayerNameEx(playerid));
					foreach(new i: Player)
					{
						switch(Backup[playerid]) 
						{
							case 1, 2:
							{
								if(PlayerInfo[playerid][pMember] == PlayerInfo[i][pMember]) {
									SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
							case 3:
							{
								if(IsACop(i) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[i][pMember]][g_iAllegiance]) {
									SendClientMessageEx(i, COLOR_LIGHTGREEN, string);
								}
							}
							default: if(IsACop(i)) {
								SendClientMessageEx(i, COLOR_LIGHTGREEN, string);
							}
						}	
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Your backup request has been cleared automatically.");
					format(string, sizeof(string), "* %s's backup request has expired.", GetPlayerNameEx(playerid));
					foreach(new i: Player)
					{
						switch(Backup[playerid]) {
							case 1, 2:
							{
								if(PlayerInfo[playerid][pMember] == PlayerInfo[i][pMember]) {
									SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
							case 3:
							{
								if(IsACop(i) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[i][pMember]][g_iAllegiance]) {
									SendClientMessageEx(i, COLOR_LIGHTGREEN, string);
	
							}
							}
							default: if(IsACop(i)) {
								SendClientMessageEx(i, COLOR_LIGHTGREEN, string);
							}
						}
					}	
				}
				HideBackupActiveForPlayer(playerid);
				Backup[playerid] = 0;
				BackupClearTimer[playerid] = 0;
			}
			else
			{
				if (calledbytimer != 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co an active backup request!");
				}
			}
		}
		else
		{
			if (calledbytimer != 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "   Ban khong phai la law enforcement officer!");
			}
		}
	}
	return 1;
}

forward SetAllCopCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi);
public SetAllCopCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi)
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SetPlayerCheckpoint(i,allx,ally,allz, radi);
		}
	}	
	return 1;
}

forward ShowPlayerBeaconForCops(playerid);
public ShowPlayerBeaconForCops(playerid)
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, COP_GREEN_COLOR);
		}
	}
	return 1;
}

forward HidePlayerBeaconForCops(playerid);
public HidePlayerBeaconForCops(playerid)
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
		}
	}
	SetPlayerToTeamColor(playerid);
	return 1;
}


CMD:placekit(playerid, params[]) {
	if(IsACop(playerid) || IsAMedic(playerid) || IsAReporter(playerid) || IsAGovernment(playerid) || IsATowman(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		if(!GetPVarInt(playerid, "MedVestKit")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You aren't carrying a kit.");
		new choice[9];
		if(sscanf(params, "s[9]", choice))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /placekit [name]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Car, Backpack");
			return 1;
		}
		new string[128];
		if(strcmp(choice, "Car", true)  == 0)
		{
			new vehicleid = GetClosestCar(playerid, INVALID_VEHICLE_ID, 10.0);
			if( vehicleid != INVALID_VEHICLE_ID && GetDistanceToCar(playerid, vehicleid) < 10 )
			{
				if(!IsABike(vehicleid) && !IsAPlane(vehicleid)) {
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle's trunk must be opened in order to place it.");
						return 1;
					}
				}
				if(VehInfo[vehicleid][vCarVestKit] == 2)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "This vehicle already has two kits loaded.");
				}
				format(string, sizeof(string), "{FF8000}** {C2A2DA}%s da dat vao cop xe mot bo Kevlar Vest & First Aid Kit inside.", GetPlayerNameEx(playerid));
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban da dat bo dung cu vao cop xe phuong tien gan nhat. /usekit de su dung bo dung cu.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "MedVestKit", 0);
				VehInfo[vehicleid][vCarVestKit] += 1;
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung gan any vehicle.");
		}
		else if(strcmp(choice, "Backpack", true)  == 0)
		{
			if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBEquipped])
			{
				if(PlayerInfo[playerid][pBItems][5] > 0 && PlayerInfo[playerid][pBackpack] == 1)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "Your backpack size only lets you store 1 med kit.");
				}
				else if(PlayerInfo[playerid][pBItems][5] > 1 && PlayerInfo[playerid][pBackpack] == 2)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "Your backpack size only lets you store 2 med kit.");
				}
				else if(PlayerInfo[playerid][pBItems][5] > 2 && PlayerInfo[playerid][pBackpack] == 3)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "Your backpack size only lets you store 3 med kit.");
				}
				format(string, sizeof(string), "{FF8000}** {C2A2DA}%s opens a backpack and places a Kevlar Vest & First Aid Kit inside.", GetPlayerNameEx(playerid));
				SendClientMessageEx(playerid, COLOR_WHITE, "You have loaded the Med Kit in to your backpack. /usekit to use it.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "MedVestKit", 0);
				PlayerInfo[playerid][pBItems][5] += 1;
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co a backpack Equipped, if you want de mua one type /miscshop.");
		}
		else 
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /placekit [name]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Car, Backpack");
			return 1;
		}
	}
	return 1;
}

CMD:givekit(playerid, params[])
{
	if(IsACop(playerid) || IsAMedic(playerid) || IsAGovernment(playerid) || IsATowman(playerid))
	{
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		if(IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!"); return 1; }
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");

		new iTarget;
		if(sscanf(params, "u", iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /givekit [playerid]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid player specified.");

		new Float:X, Float:Y, Float:Z; GetPlayerPos(iTarget, X, Y, Z);
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, X, Y, Z)) return SendClientMessage(playerid, COLOR_GRAD2, "You're not close enough to that player.");

		if(IsACop(iTarget) || IsAMedic(iTarget) || IsAGovernment(iTarget) || IsATowman(iTarget))
		{
			if(GetPVarInt(playerid, "MedVestKit") > 0)
			{
				if(GetPVarInt(iTarget, "MedVestKit") > 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player already has a kit.");

				format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s gives a Med Kit to %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget));
				SendClientMessageEx(iTarget, COLOR_WHITE, "You have been given a Med Kit. To use it, use /placekit and then /usekit.");
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "MedVestKit", 0);
				SetPVarInt(iTarget, "MedVestKit", 1);
			}
			else SendClientMessage(playerid, COLOR_GRAD2, "Ban khong coa kit.");
		}
		else SendClientMessage(playerid, COLOR_GRAD2, "That player cannot use kits.");
	}
	return 1;
}

CMD:usekit(playerid, params[]) {
	if(IsACop(playerid) || IsAMedic(playerid) || IsAReporter(playerid) || IsAGovernment(playerid) || IsATowman(playerid))
	{
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		if(IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!"); return 1; }
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		new string[128];
		new vehicleid = GetClosestCar(playerid, INVALID_VEHICLE_ID, 10.0);
		if(vehicleid != INVALID_VEHICLE_ID && GetDistanceToCar(playerid, vehicleid) < 10)
		{
		    if(VehInfo[vehicleid][vCarVestKit] > 0)
		    {
		    	if(!IsABike(vehicleid) && !IsAPlane(vehicleid)) {
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "Cop xe chua duoc mo, hay mo cop xe ra truoc.");
						return 1;
					}
				}
		        format(string, sizeof(string), "{FF8000}** {C2A2DA}%s da dua tay vao cop xe lay ra mot boKevlar Vest & First Aid Kit.", GetPlayerNameEx(playerid));
            	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da su dung bo dung cu tu trong cop xe.");
            	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetHealth(playerid, 100);
				SetArmour(playerid, 150);
            	VehInfo[vehicleid][vCarVestKit] -= 1;
				return 1;
		    }
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "Trong phuong tien nay khong co bo dung cu duoc dat ra."); 
		}
		else if(IsBackpackAvailable(playerid))
		{
			if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBEquipped])
			{
				if(PlayerInfo[playerid][pBItems][5] > 0)
				{
					if(GetPVarInt(playerid, "BackpackMedKit") == 1) {
						return SendClientMessageEx(playerid, COLOR_GRAD2, "You have already requested to use a medic kit.");
					}
					else 
					{
						defer FinishMedKit(playerid);
						SetPVarInt(playerid, "BackpackMedKit", 1);
						ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
						format(string, sizeof(string), "{FF8000}** {C2A2DA}%s opens a backpack and takes out a Kevlar Vest & First Aid Kit inside.", GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_WHITE, "You are taking a Med Kit from your backpack, please wait.");
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
				}
				else return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no med kits available in your backpack.");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "You have no kits inside your backpack.");
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong dung gan phuong tien hoac khong co bo dung cu.");
	}
	return 1;
}

CMD:searchcar(playerid, params[])
{
	if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la law enforcement officer!");
	if(GetPVarInt(playerid, "Injured") != 0 || GetPVarInt(playerid, "EventToken") != 0) return SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
	new closestcar = GetClosestCar(playerid), v, string[128];
	if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 9.0)) return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong dung gan any vehicles.");
	if(IsABike(closestcar) || IsAPlane(closestcar)) return SendClientMessageEx(playerid,COLOR_GREY,"You can't search this type of vehicle!");

	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD1, "Cop xe chua duoc mo, hay mo cop xe ra truoc.");

	foreach(new i: Player)
	{
		v = GetPlayerVehicle(i, closestcar);
		string[0] = 0;
		if(v != -1) {
			Smuggle_VehicleLoad(playerid, i, v);
			for(new x = 0; x < 3; x++)
			{
				if(PlayerVehicleInfo[i][v][pvWeapons][x] != 0)
				{
					new
						szWep[20];

					GetWeaponName(PlayerVehicleInfo[i][v][pvWeapons][x], szWep, sizeof(szWep));
					if(isnull(string)) format(string, sizeof(string), "* Trunk contains: %s", szWep);
					else format(string, sizeof(string), "%s, %s", string, szWep);
				}
			}
			if(!isnull(string)) {
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				if(VehInfo[closestcar][vCarVestKit]) {
					SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains:");
					SendClientMessageEx(playerid, COLOR_WHITE, "* Kevlar Vest.");
					SendClientMessageEx(playerid, COLOR_WHITE, "* First Aid Kit.");
				}
			}
			else SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains: nothing.");
			strins(string, "F", 0, sizeof(string));
		}
	}
    if(isnull(string)) {
        if(VehInfo[closestcar][vCarVestKit] > 0) {
            new str[84];
            SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains:");
            format(str, sizeof(str), "* Kevlar Vest (x%d).", VehInfo[closestcar][vCarVestKit]);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
            format(str, sizeof(str), "* First Aid Kit(x%d).", VehInfo[closestcar][vCarVestKit]);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains: nothing.");
    }
    return 1;
}


CMD:takecarweapons(playerid, params[])
{
    if (!IsACop(playerid))
	{
        SendClientMessageEx(playerid,COLOR_GREY,"You're not a law enforcement officer.");
        return 1;
    }
    new carid = GetPlayerVehicleID(playerid);
    new closestcar = GetClosestCar(playerid,carid);
    if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 9.0))
	{
        SendClientMessageEx(playerid,COLOR_GREY,"Ban khong dung gan any vehicles.");
        return 1;
    }
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Cop xe chua duoc mo, hay mo cop xe ra truoc.");
		return 1;
	}
    foreach(new i: Player)
	{
		new v = GetPlayerVehicle(i, closestcar);
		if(v != -1)
		{
			if (!PlayerVehicleInfo[i][v][pvWeapons][0] && !PlayerVehicleInfo[i][v][pvWeapons][1] && !PlayerVehicleInfo[i][v][pvWeapons][2])
			{
				SendClientMessageEx(playerid, COLOR_WHITE,  "No weapons in the trunk.");
				return 1;
			}
			else
			{
				PlayerVehicleInfo[i][v][pvWeapons][0] = 0;
				PlayerVehicleInfo[i][v][pvWeapons][1] = 0;
				PlayerVehicleInfo[i][v][pvWeapons][2] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE,  "All weapons have been removed from this vehicle.");
				new string[MAX_PLAYER_NAME + 44];
				format(string, sizeof(string), "* %s has taken the weapons away from the trunk.", GetPlayerNameEx(playerid));
				ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
		}
	}	
    return 1;
}

CMD:mdc(playerid, params[])
{
    if(IsMDCPermitted(playerid))
	{
        if(IsPlayerInAnyVehicle(playerid) || Bit_State(arrPlayerBits[playerid], phone_bitState))
		{
            ShowPlayerDialogEx(playerid, MDC_MAIN, DIALOG_STYLE_LIST, "MDC - Logged in", "*Civilian Information\n*Register Suspect\n*Clear Suspect\n*Vehicle registrations\n*Find LEO\n*Law Enforcement Agencies\n*MDC Message\n*SMS", "OK", "Cancel");
            ConnectedToPC[playerid] = 1337;
        }
        else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai chiec xe.");
    }
    return 1;
}

CMD:clearcargo(playerid, params[])
{
	if(!IsACop(playerid))
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la law enforcement officer!");
        return 1;
	}

	new carid = GetPlayerVehicleID(playerid);
 	new closestcar = GetClosestCar(playerid, carid);
  	if(IsPlayerInRangeOfVehicle(playerid, closestcar, 6.0) && IsATruckerCar(closestcar))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
		    SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the tich thu hang khi dang ngoi trong phuong tien.");
		    return 1;
		}
		if(TruckContents{closestcar} == 0)
		{
		 	if(TruckDeliveringTo[closestcar] != INVALID_BUSINESS_ID && (Businesses[TruckDeliveringTo[closestcar]][bType] != BUSINESS_TYPE_GASSTATION || Businesses[TruckDeliveringTo[closestcar]][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You cannot take the content away.");
				return 1;
			}
		}
		new truckcontentname[50];
		new iTruckContents = TruckContents{closestcar};
		if(iTruckContents >= 0 && iTruckContents < 5)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Khong co vat pham bat hop phap trong phuong tien.");
			return 1;
		}
		else if(TruckDeliveringTo[closestcar] == INVALID_BUSINESS_ID && iTruckContents == 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Khong co vat pham bat hop phap trong phuong tien.");
			return 1;
		}
		if(iTruckContents == 5)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Vu khi"); }
		else if(iTruckContents == 6)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Thuoc phien"); }
		else if(iTruckContents == 7)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Vat lieu bat hop phap"); }
		else format(truckcontentname, sizeof(truckcontentname), "{FF0606}Vat lieu bat hop phap");
 		foreach(new i: Player)
		{
			if(TruckUsed[i] == closestcar)
			{
				TruckUsed[i] = INVALID_VEHICLE_ID;
				TruckDeliveringTo[closestcar] = INVALID_BUSINESS_ID;
				TruckContents{closestcar} = 0;
				TruckRoute[closestcar] = 0;
				DisablePlayerCheckpoint(i);
				gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
				DeletePVar(i, "TruckDeliver");
				SendClientMessageEx(i, COLOR_WHITE, "Chuyen hang da bi huy. Canh sat da tich thu vat pham bat hop phap.");
			}
		}	
		new string[128];
		format(string, sizeof(string), "Ban da tich thu %s {FFFFFF}khoi phuong tien.", truckcontentname);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "* %s da tich thu cac vat pham bat hop phap khoi phuong tien.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    }
   	else
	{
 		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong o gan phuong tien.");
 	}
    return 1;
}

CMD:backup(playerid, params[])
{
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) {

		return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban dang o tu OOC nen khong the su dung lenh nay.");
	}

    if(IsACop(playerid) || IsAMedic(playerid) || arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_TOWING)
	{
	    new code[10],
		zone[MAX_ZONE_NAME],
		string[128];
	    GetPlayer3DZone(playerid, zone, sizeof(zone));
		if(sscanf(params, "s[10]", code) && (Backup[playerid] == 0 || Backup[playerid] == 2)) {
			format(string, sizeof(string), "* %s da yeu cau tro giup tu radio.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			format(string, sizeof(string), "* %s da yeu cau ho tro tai %s. {AA3333}Code 3 [Bat den xe va Siren].", GetPlayerNameEx(playerid), zone);
            ShowBackupActiveForPlayer(playerid);
			Backup[playerid] = 1;

			foreach(new i : Player)
			{
				if(PlayerInfo[playerid][pMember] == PlayerInfo[i][pMember])
				{
      				SetPlayerMarkerForPlayer(i, playerid, 0x2641FEAA);
					SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "Nhap '/backup' them mot lan nua de tro ve lai Code 2.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Su dung /nobackup de ngung yeu cau ho tro.");
			if(BackupClearTimer[playerid] != 0)
			{
				KillTimer(BackupClearTimer[playerid]);
				BackupClearTimer[playerid] = 0;
			}
			BackupClearTimer[playerid] = SetTimerEx("BackupClear", 300000, false, "ii", playerid, 1);
		}
		else if(strcmp(code, "code2", true) == 0 && (Backup[playerid] == 0 || Backup[playerid] == 1))
		{
			format(string, sizeof(string), "* %s da yeu cau tro giup tu radio.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			format(string, sizeof(string), "* %s da yeu cau ho tro tai %s. {00FF33}Code 2 [Khong bat den xe va Siren].", GetPlayerNameEx(playerid), zone);
            ShowBackupActiveForPlayer(playerid);
			Backup[playerid] = 2;

			foreach(new i : Player)
			{
				if(PlayerInfo[playerid][pMember] == PlayerInfo[i][pMember])
				{
      				SetPlayerMarkerForPlayer(i, playerid, 0x00FF33AA);
					SendClientMessageEx(i,  arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "Nhap '/backup' them mot lan nua de yeu cau ho tro Code 3.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Su dung /nobackup de ngung yeu cau ho tro.");
			if(BackupClearTimer[playerid] != 0)
			{
				KillTimer(BackupClearTimer[playerid]);
				BackupClearTimer[playerid] = 0;
			}
			BackupClearTimer[playerid] = SetTimerEx("BackupClear", 300000, false, "ii", playerid, 1);
		}
		else if(code[0] && !(strcmp(code, "code2", true) == 0))
		{
		    return SendClientMessageEx(playerid, COLOR_GREY, "Incorrect parameter - type /backup or /backup code2 only");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban dang yeu cau ho tro tu to chuc! Hay su dung /nobackup de huy yeu cau.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la mot Canh sat hoac Bac si.");
	}
	return 1;
}

CMD:backupall(playerid, params[])
{
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) {
		
		return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban dang o tu OOC nen khong the su dung lenh nay.");
	}
    if(IsACop(playerid) || IsAMedic(playerid))
	{
	    new
			zone[MAX_ZONE_NAME],
			string[128];
	    GetPlayer3DZone(playerid, zone, sizeof(zone));
		if(Backup[playerid] == 0 || Backup[playerid] == 1)
		{
			format(string, sizeof(string), "* %s da yeu cau tro giup tu radio.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			format(string, sizeof(string), "* %s da yeu cau ho tro tai %s. {AA3333}Code 3A [Bat den xe va Siren].", GetPlayerNameEx(playerid), zone);
            ShowBackupActiveForPlayer(playerid);
			Backup[playerid] = 3;
			foreach(new i : Player)
			{
				if(IsACop(i) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[i][pMember]][g_iAllegiance])
				{
      				SetPlayerMarkerForPlayer(i, playerid, 0x2641FEAA);
					SendClientMessageEx(i, DEPTRADIO, string);
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "Su dung /nobackup de ngung yeu cau ho tro.");
			if(BackupClearTimer[playerid] != 0)
			{
				KillTimer(BackupClearTimer[playerid]);
				BackupClearTimer[playerid] = 0;
			}
			BackupClearTimer[playerid] = SetTimerEx("BackupClear", 300000, false, "ii", playerid, 1);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban dang yeu cau ho tro tu to chuc! Hay su dung /nobackup de huy yeu cau.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la mot Canh sat hoac Bac si!");
	}
	return 1;
}

CMD:backupint(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) {
		
		return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban dang o tu OOC nen khong the su dung lenh nay.");
	}
    if(IsACop(playerid) || IsAMedic(playerid))
	{
	    new
			zone[MAX_ZONE_NAME],
			string[128];
	    GetPlayer3DZone(playerid, zone, sizeof(zone));
		if(Backup[playerid] == 0 || Backup[playerid] == 1)
		{
			format(string, sizeof(string), "* %s da yeu cau tro giup tu radio..", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			format(string, sizeof(string), "* %s da yeu cua ho tro toan quoc tai %s. {AA3333}Code 3A [Bat den xe va Siren].", GetPlayerNameEx(playerid), zone);
            ShowBackupActiveForPlayer(playerid);
			Backup[playerid] = 4;
			foreach(new i : Player)
			{
				if(IsACop(i))
				{
      				SetPlayerMarkerForPlayer(i, playerid, 0x2641FEAA);
					SendClientMessageEx(i, DEPTRADIO, string);
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "Su dung /nobackup de ngung yeu cau ho tro.");
			if(BackupClearTimer[playerid] != 0)
			{
				KillTimer(BackupClearTimer[playerid]);
				BackupClearTimer[playerid] = 0;
			}
			BackupClearTimer[playerid] = SetTimerEx("BackupClear", 300000, false, "ii", playerid, 1);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban dang yeu cau ho tro tu to chuc! Hay su dung /nobackup de huy yeu cau.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la mot Canh sat hoac Bac si!");
	}
	return 1;
}

CMD:nobackup(playerid, params[])
{
    BackupClear(playerid, 0);
	return 1;
}

CMD:vmdc(playerid, params[])
{
    if(IsACop(playerid) || IsATowman(playerid) || IsAHitman(playerid) || PlayerInfo[playerid][pAdmin] >= 2)
    {
        new string[128], giveplayerid;
        if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /vmdc [player]");

   		if(IsPlayerConnected(giveplayerid))
    	{
	        SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
			format(string, sizeof(string), "*** %s's Vehicles  ***", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_GRAD2, string);
	        for(new i=0; i<MAX_PLAYERVEHICLES; i++)
         	{
			    if(PlayerVehicleInfo[giveplayerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
				{
    				format(string, sizeof(string), "ID phuong tien: %d | Ten phuong tien: %s | Ve phat: $%d.",PlayerVehicleInfo[giveplayerid][i][pvId],GetVehicleName(PlayerVehicleInfo[giveplayerid][i][pvId]),PlayerVehicleInfo[giveplayerid][i][pvTicket]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
	    		}
				else if(PlayerVehicleInfo[giveplayerid][i][pvImpounded])
				{
    				format(string, sizeof(string), "ID phuong tien: DANG BI GIAM | Ten phuong tien: %s | Ve phat: $%d.",VehicleName[PlayerVehicleInfo[giveplayerid][i][pvModelId]-400],PlayerVehicleInfo[giveplayerid][i][pvTicket]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
	    		}
	    	}
	    	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
   		}
    }
	return 1;
}

CMD:vticket(playerid, params[])
{
	if(IsACop(playerid) || IsATowman(playerid)) {
		new vehid, amount;
		if(sscanf(params, "ii", vehid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /vticket [id phuong tien] [so tien phat]");
		if(PlayerInfo[playerid][pTicketTime] != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai doi vai phut nua moi co the su dung lai lenh nay!");
		if(amount > 50000) return SendClientMessageEx(playerid, COLOR_GREY, "Ve phat gioi han $50,000.");
		if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ve phat it nhat $1.");
		new string[128], Float: x, Float: y, Float: z, veh = -1;
		GetVehiclePos(vehid, x, y, z);
		if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) {
			foreach(new i: Player) {
				if((veh = GetPlayerVehicle(i, vehid)) != -1) {
					PlayerVehicleInfo[i][veh][pvTicket] += amount;
					PlayerInfo[playerid][pTicketTime] = 60;
					SendClientMessageEx(playerid, COLOR_WHITE, "You have issued a $%s ticket on %s's %s.", number_format(amount), GetPlayerNameEx(i), GetVehicleName(PlayerVehicleInfo[i][veh][pvId]));
					format(string, sizeof(string), "[VTICKET] Officer %s has ticketed %s's %s (%d) for $%s.", GetPlayerNameEx(playerid), GetPlayerNameEx(i), GetVehicleName(PlayerVehicleInfo[i][veh][pvId]), PlayerVehicleInfo[i][veh][pvSlotId], number_format(amount));
					GroupLog(PlayerInfo[playerid][pMember], string);
					break;
				}
			}
			if((veh = IsDynamicCrateVehicle(vehid)) != -1) {
				if(ValidGroup(CrateVehicle[veh][cvGroupID])) {
					if(PlayerInfo[playerid][pMember] == CrateVehicle[veh][cvGroupID]) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Day la phuong tien cua groups ban khong the ghi ve phat!");
					CrateVehicle[veh][cvTickets] += amount;
					PlayerInfo[playerid][pTicketTime] = 60;
					SendClientMessageEx(playerid, COLOR_WHITE, "You have issued a $%s ticket on the %s.", number_format(amount), VehicleName[CrateVehicle[veh][cvModel] - 400]);
					format(string, sizeof(string), "[VTICKET] Officer %s has ticketed %s's %s (%d) for $%s.", GetPlayerNameEx(playerid), arrGroupData[CrateVehicle[veh][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[veh][cvModel] - 400], CrateVehicle[veh][cvId], number_format(amount));
					GroupLog(PlayerInfo[playerid][pMember], string);
					SaveCrateVehicle(veh);
				} else veh = -1;
			}
			if(veh == -1) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Phuong tien nay chua duoc dang ky!");
			}
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can phai dung gan phuong tien do!");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
    return 1;
}

CMD:vlookup(playerid, params[]) {

	if(IsACop(playerid) || IsATowman(playerid) || IsAHitman(playerid) || PlayerInfo[playerid][pAdmin] >= 2)
	{
        if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /vlookup [vehicle registration]");
        new carid = strval(params);
        new dynveh = DynVeh[carid];
        new cveh = IsDynamicCrateVehicle(carid);
		foreach(new i: Player)
		{
			new v = GetPlayerVehicle(i, carid);

			if(v != -1)
			{
				new string[78 + MAX_PLAYER_NAME];
				format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: $%s", carid, GetVehicleName(PlayerVehicleInfo[i][v][pvId]), GetPlayerNameEx(i), number_format(PlayerVehicleInfo[i][v][pvTicket]));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
		}	
        if(dynveh != -1)
		{
		    if(DynVehicleInfo[dynveh][gv_igID] != INVALID_GROUP_ID && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] != GROUP_TYPE_CONTRACT && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] != GROUP_TYPE_CRIMINAL)
		    {
				new string[78 + MAX_PLAYER_NAME];
                format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: EXEMPT", carid, GetVehicleName(carid), arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_szGroupName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
                return 1;
			}
			else if(DynVehicleInfo[dynveh][gv_igID] != INVALID_GROUP_ID && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] == GROUP_TYPE_CRIMINAL)
			{
				new string[78 + MAX_PLAYER_NAME];
				format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s", carid, GetVehicleName(carid), arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
        }
        if(cveh != -1) {
        	if(ValidGroup(CrateVehicle[cveh][cvGroupID])) {
        		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Tickets: $%s", carid, GetVehicleName(carid), arrGroupData[CrateVehicle[cveh][cvGroupID]][g_szGroupName], number_format(CrateVehicle[cveh][cvTickets]));
        		return 1;
        	}
        }
        SendClientMessageEx(playerid, COLOR_GRAD2, "Phuong tien nay khong co nguoi so huu!");
    }
    return 1;
}

CMD:vcheck(playerid, params[])
{
    if(IsACop(playerid) || IsATowman(playerid) || IsAHitman(playerid) || PlayerInfo[playerid][pAdmin] >= 2)
	{
        new carid = GetPlayerVehicleID(playerid);
        new closestcar = GetClosestCar(playerid, carid);
        if(IsTrailerAttachedToVehicle(carid))
		{
            new carbeingtowed = GetVehicleTrailer(carid);
            new dynveh = DynVeh[carbeingtowed];
            new cveh = IsDynamicCrateVehicle(carbeingtowed);
			foreach(new i: Player)
			{
				new v = GetPlayerVehicle(i, carbeingtowed);

				if(v != -1)
				{
					new string[78 + MAX_PLAYER_NAME];
					format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: $%s", carbeingtowed, GetVehicleName(PlayerVehicleInfo[i][v][pvId]), GetPlayerNameEx(i), number_format(PlayerVehicleInfo[i][v][pvTicket]));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					return 1;
				}
			}	
            if(dynveh != -1)
			{
			    if(DynVehicleInfo[dynveh][gv_igID] != INVALID_GROUP_ID && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] != GROUP_TYPE_CONTRACT && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] != GROUP_TYPE_CRIMINAL)
			    {
					new string[78 + MAX_PLAYER_NAME];
                    format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: EXEMPT", carbeingtowed, GetVehicleName(carbeingtowed), arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_szGroupName]);
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                    return 1;
				}
				else if(DynVehicleInfo[dynveh][gv_igID] != INVALID_GROUP_ID && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] == GROUP_TYPE_CRIMINAL)
				{
					new string[78 + MAX_PLAYER_NAME];
					format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s", closestcar, GetVehicleName(closestcar), arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_szGroupName]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					return 1;
				}
            }
            if(cveh != -1) {
            	if(ValidGroup(CrateVehicle[cveh][cvGroupID])) {
            		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: $%s", closestcar, GetVehicleName(closestcar), arrGroupData[CrateVehicle[cveh][cvGroupID]][g_szGroupName], number_format(CrateVehicle[cveh][cvTickets]));
        			return 1;
        		}
            }
            SendClientMessageEx(playerid, COLOR_GRAD2, "Phuong tien nay khong co nguoi so huu");
        }
        else if(IsPlayerInRangeOfVehicle(playerid, closestcar, 9.0) && !IsTrailerAttachedToVehicle(carid) && (GetVehicleVirtualWorld(closestcar) == GetPlayerVirtualWorld(playerid)))
		{
		    new dynveh = DynVeh[closestcar], szClamp[16], cveh = IsDynamicCrateVehicle(closestcar);
		    if(WheelClamp{closestcar}) {
		    	format(szClamp, sizeof(szClamp), "| Wheelclamp: Yes");
		    }
            foreach(new i: Player)
			{

				new v = GetPlayerVehicle(i, closestcar);
				if(v != -1)
				{
					new string[99 + MAX_PLAYER_NAME];
					format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: $%d | Speed: %.0f MPH %s", closestcar, GetVehicleName(PlayerVehicleInfo[i][v][pvId]), GetPlayerNameEx(i), PlayerVehicleInfo[i][v][pvTicket],  vehicle_get_speed(closestcar), szClamp);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					return 1;
				}
			}	
            if(dynveh != -1)
			{
			    if(DynVehicleInfo[dynveh][gv_igID] != INVALID_GROUP_ID && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] != GROUP_TYPE_CONTRACT && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] != GROUP_TYPE_CRIMINAL)
			    {
					new string[99 + MAX_PLAYER_NAME];
                    format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: EXEMPT %s", closestcar, GetVehicleName(closestcar), arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_szGroupName], szClamp);
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                    return 1;
				}
				else if(DynVehicleInfo[dynveh][gv_igID] != INVALID_GROUP_ID && arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_iGroupType] == GROUP_TYPE_CRIMINAL)
			    {
					new string[99 + MAX_PLAYER_NAME];
                    format(string, sizeof(string), "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s %s", closestcar, GetVehicleName(closestcar), arrGroupData[DynVehicleInfo[dynveh][gv_igID]][g_szGroupName], szClamp);
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                    return 1;
				}
            }
            if(cveh != -1) {
            	if(ValidGroup(CrateVehicle[cveh][cvGroupID])) {
            		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle registration: %d | Ten phuong tien: %s | Chu so huu: %s | Ticket: $%s %s", closestcar, GetVehicleName(closestcar), arrGroupData[CrateVehicle[cveh][cvGroupID]][g_szGroupName], number_format(CrateVehicle[cveh][cvTickets]), szClamp);
        			return 1;
        		}
            }
            SendClientMessageEx(playerid, COLOR_GRAD2, "Phuong tien nay khong co nguoi so huu!");
        }
        else SendClientMessageEx(playerid, COLOR_GRAD1, "ERROR: You are not towing chiec xe/near to another vehicle.");
    }
    else return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh nay.");
    return 1;
}



CMD:ram(playerid, params[])
{
	if(IsACop(playerid) || IsAMedic(playerid) || IsAHitman(playerid))
	{
		if(GetPVarType(playerid, "IsInArena"))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
			return 1;
		}
		if( PlayerCuffed[playerid] >= 1 )
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the thuc hien lenh nay ngay bay gio.");
			return 1;
		}

		new string[128];
		for(new i = 0; i < sizeof(HouseInfo); i++)
		{
			if (IsPlayerInRangeOfPoint(playerid,3,HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && PlayerInfo[playerid][pVW] == HouseInfo[i][hExtVW])
			{
				format(string, sizeof(string), "* %s breaches the door, and enters.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPlayerInterior(playerid,HouseInfo[i][hIntIW]);
				SetPlayerPos(playerid,HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ]);
				GameTextForPlayer(playerid, "~r~Breached the door", 5000, 1);
				PlayerInfo[playerid][pInt] = HouseInfo[i][hIntIW];
				PlayerInfo[playerid][pVW] = HouseInfo[i][hIntVW];
				SetPlayerVirtualWorld(playerid,HouseInfo[i][hIntVW]);
				if(HouseInfo[i][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ], FREEZE_TIME);
				return 1;
			}
		}
		if(PlayerInfo[playerid][pRank] > 3)
		{
			for(new i = 0; i < sizeof(DDoorsInfo); i++)
			{
				if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] && DDoorsInfo[i][ddVIP] > 0)
				{
					SetPlayerInterior(playerid,DDoorsInfo[i][ddInteriorInt]);
					PlayerInfo[playerid][pInt] = DDoorsInfo[i][ddInteriorInt];
					PlayerInfo[playerid][pVW] = DDoorsInfo[i][ddInteriorVW];
					SetPlayerVirtualWorld(playerid, DDoorsInfo[i][ddInteriorVW]);
					if(DDoorsInfo[i][ddVehicleAble] > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
						SetVehiclePos(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddInteriorX],DDoorsInfo[i][ddInteriorY],DDoorsInfo[i][ddInteriorZ]);
						SetVehicleZAngle(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddInteriorA]);
						if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0)
							SetPVarInt(playerid, "tpJustEntered", 1);
						SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddInteriorVW]);
						LinkVehicleToInterior(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddInteriorInt]);
					}
					else {
						SetPlayerPos(playerid,DDoorsInfo[i][ddInteriorX],DDoorsInfo[i][ddInteriorY],DDoorsInfo[i][ddInteriorZ]);
						SetPlayerFacingAngle(playerid,DDoorsInfo[i][ddInteriorA]);
						SetCameraBehindPlayer(playerid);
					}
					if(DDoorsInfo[i][ddCustomInterior]) Player_StreamPrep(playerid, DDoorsInfo[i][ddInteriorX],DDoorsInfo[i][ddInteriorY],DDoorsInfo[i][ddInteriorZ], FREEZE_TIME);
					return 1;
				}
			}
		}
	    for(new i = 0; i < sizeof(Businesses); i++) {
	        if (IsPlayerInRangeOfPoint(playerid,3,Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2])) {
		        if (Businesses[i][bExtPos][1] == 0.0) return 1;
				format(string, sizeof(string), "* %s breaches the door, and enters.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPlayerInterior(playerid,Businesses[i][bInt]);
		        if(Businesses[i][bVW] == 0) SetPlayerVirtualWorld(playerid, BUSINESS_BASE_VW + i), PlayerInfo[playerid][pVW] = BUSINESS_BASE_VW + i;
		        else SetPlayerVirtualWorld(playerid, Businesses[i][bVW]), PlayerInfo[playerid][pVW] = Businesses[i][bVW];
		        SetPlayerPos(playerid,Businesses[i][bIntPos][0],Businesses[i][bIntPos][1],Businesses[i][bIntPos][2]);
			    SetPlayerFacingAngle(playerid, Businesses[i][bIntPos][3]);
		        SetCameraBehindPlayer(playerid);
				GameTextForPlayer(playerid, "~r~Breached the door", 5000, 1);
				return 1;
	        }
	    }
		if (IsPlayerInRangeOfPoint(playerid,4.0,648.7888,-1360.7708,13.5875))
		{
			format(string, sizeof(string), "* %s breaches the door, and enters.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPlayerInterior(playerid,1);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerVirtualWorld(playerid, 4225);
			PlayerInfo[playerid][pVW] = 4225;
			SetPlayerPos(playerid,626.4980,21.4223,1107.9686);
			SetPlayerFacingAngle(playerid, 178.6711);
			Player_StreamPrep(playerid, 626.4980,21.4223,1107.9686, FREEZE_TIME);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai trong to chuc Laws.");
	}
	return 1;
}

CMD:take(playerid, params[])
{
	if(IsACop(playerid))
	{
		new string[128], choice[32], giveplayerid;
		if(sscanf(params, "s[32]u", choice, giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /take [tuy chon] [player]");
			SendClientMessageEx(playerid, COLOR_GREY, "TUY CHON: Weapons, Pot, Crack, Meth, Ecstasy, Materials, Radio, Heroin, Rawopium, Syringes, PotSeeds, OpiumSeeds, DrugCrates");
			return 1;
		}
		if(giveplayerid == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, "Nguoi choi khong ton tai");
		if(PlayerInfo[playerid][pAdmin] < 2 && (PlayerInfo[giveplayerid][pJailTime] && strfind(PlayerInfo[giveplayerid][pPrisonReason], "[OOC]", true) != -1)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot take items from a OOC Prisoner.");
		if (playerid == giveplayerid)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the tich thu chinh ban!");
			return 1;
		}
		else if(strcmp(choice,"opiumseeds",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pOpiumSeeds] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any opium seeds.");

					format(string, sizeof(string), "* You have taken away %s's opiumseeds.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your opiumseeds.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's opiumseeds.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pOpiumSeeds] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"PotSeeds",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pWSeeds] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any pot seeds.");
					format(string, sizeof(string), "* You have taken away %s's Cannabisseeds.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your Cannabisseeds.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's Cannabisseeds.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pWSeeds] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"drugcrates",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pCrates] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any drug crates.");

					format(string, sizeof(string), "* You have taken away %s's Drug Crates.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your Drug Crates.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's Drug Crates.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pCrates] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"Syringes",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pSyringes] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any syringes.");

					format(string, sizeof(string), "* You have taken away %s's syringes.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your syringes.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's syringes.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pSyringes] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"Rawopium",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pRawOpium] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any raw opium.");

					format(string, sizeof(string), "* You have taken away %s's raw opium.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your raw opium.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's raw opium.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pRawOpium] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"Meth",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pDrugs][2] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any meth.");

					format(string, sizeof(string), "* You have taken away %s's Meth.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your Meth.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's Meth.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pDrugs][2] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"Ecstasy",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pDrugs][3] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any ecstasy.");

					format(string, sizeof(string), "* You have taken away %s's Ecstasy.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your Ecstasy.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's Ecstasy.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pDrugs][3] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"Heroin",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pDrugs][4] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any heroin.");

					format(string, sizeof(string), "* You have taken away %s's Heroin.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your Heroin.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's Heroin.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pDrugs][4] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"radio",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pRadio] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have a radio.");

					format(string, sizeof(string), "* You have taken away %s's radio.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your radio.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's radio.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pRadio] = 0;
					PlayerInfo[giveplayerid][pRadioFreq] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"weapons",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					format(string, sizeof(string), "* You have taken away %s's weapons.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your weapons.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's weapons.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					ResetPlayerWeaponsEx(giveplayerid);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"Pot",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pDrugs][0] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any pot.");

					format(string, sizeof(string), "* You have taken away %s's Cannabis.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your Cannabis.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's Cannabis.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pDrugs][0] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"crack",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pDrugs][1] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any crack.");

					format(string, sizeof(string), "* You have taken away %s's crack.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away your crack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's crack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pDrugs][1] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else if(strcmp(choice,"materials",true) == 0)
		{
			if(IsPlayerConnected(giveplayerid))
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(PlayerInfo[giveplayerid][pMats] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "That player does not have any materials.");

					format(string, sizeof(string), "* You have taken away %s's materials.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s as taken away your materials.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s has taken away %s's materials.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					PlayerInfo[giveplayerid][pMats] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}

			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Vat pham khong ton tai.");
			return 1;
		}
		GroupLog(PlayerInfo[playerid][pMember], string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Canh sat!");
		return 1;
	}
	return 1;
}

CMD:tackle(playerid, params[])
{
	#if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't tackle humans!");
	#endif
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iTackleAccess])
	{
		if(GetPVarInt(playerid, "ReTackleCooldown") != 0 && gettime() < GetPVarInt(playerid, "ReTackleCooldown") + 30)
		{
			new string[128];
			format(string, sizeof(string), "Ban phai doi %d seconds before you can enable tackle mode again!", GetPVarInt(playerid, "ReTackleCooldown") + 30 - gettime());
			return SendClientMessageEx(playerid, COLOR_GRAD2, string);
		}
		if(GetPVarInt(playerid, "WeaponsHolstered") == 0) //Unholstered
	    {
	        callcmd::holster(playerid, params);
			//UnholsterWeapon(playerid, 0);
		}
        if(GetPVarInt(playerid, "TackleMode") == 0)
        {
	        SetPVarInt(playerid, "TackleMode", 1);
	        return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You've enabled tackling.  Aim at the suspect and hit enter to initiate the tackle.");
		}
		else
		{
	        SetPVarInt(playerid, "TackleMode", 0);
	        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You've disabled tackling. Bay gio ban co theunholster your weapon.");
			callcmd::holster(playerid, params);
			return SetPVarInt(playerid, "ReTackleCooldown", gettime());
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co quyen han de su dung lenh nay!.");
}

CMD:tazer(playerid, params[])
{
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
	if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your account is restricted!");
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(IsACop(playerid))
	{
		new string[128];
		if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Hien tai ban dang bi han che su dung vu khi nen khong the su dung lenh nay!");

		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay khi dang o tren xe.");
			return 1;
		}

		if(GetPVarType(playerid, "IsInArena"))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the su dung lenh nay khi dang trong dau truong!");
			return 1;
		}
		if(GetPVarInt( playerid, "EventToken") != 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang trong su kien.");
			return 1;
		}
		if(PlayerCuffedTime[playerid] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
			return 1;
		}
		if(GetPVarInt(playerid, "Injured") == 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
			return 1;
		}

		if(PlayerInfo[playerid][pJailTime] > 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the su dung lenh nay khi dang bi o tu.");
			return 1;
		}
		if(PlayerCuffed[playerid] >= 1) {
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the su dung lenh nay khi dang bi tazer/cong tay.");
			return 1;
		}
		if(PlayerInfo[playerid][pHasTazer] < 1)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "Ban khong co Tazer/Cuff!");
		    return 1;
		}

		if(pTazer{playerid} == 0)
		{
			if(TazerTimeout[playerid] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Dang thay dan Tazer");

			pTazerReplace{playerid} = PlayerInfo[playerid][pGuns][2];
			if(PlayerInfo[playerid][pGuns][2] != 0) RemovePlayerWeapon(playerid, PlayerInfo[playerid][pGuns][2]);
			format(string, sizeof(string), "* %s da lay sung dien tu that lung ra.", GetPlayerNameEx(playerid));
			ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			GivePlayerValidWeapon(playerid, 23);
			pTazer{playerid} = 1;
			SetPlayerAmmo(playerid, 23, 60000);
			SetPVarInt(playerid, "TazerShots", 2);
			SetPlayerAmmo(playerid, WEAPON_SILENCED, 3);
		}
		else
		{
			RemovePlayerWeapon(playerid, 23);
			GivePlayerValidWeapon(playerid, pTazerReplace{playerid});
			format(string, sizeof(string), "* %s da cat sung dien vao that lung.", GetPlayerNameEx(playerid));
			ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			pTazer{playerid} = 0;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la Canh sat!");
		return 1;
	}
	return 1;
}

CMD:vradar(playerid, params[])
{
	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessageEx(playerid, 0xFF0000FF, "Ban phai ngoi tren phuong tien de su dung lenh nay.");

	if(!IsACop(playerid) && !IsATowman(playerid))
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Canh sat!");

	switch (CarRadars[playerid])
	{
		case 0: // player has not deployed dashboard radar
		{
			CarRadars[playerid] = 1;
			PlayerTextDrawShow(playerid, _crTextTarget[playerid]);
			PlayerTextDrawShow(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawShow(playerid, _crTickets[playerid]);

			SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang su dung /vradar, su dung them 1 lan nua de tat no.");
			SetPVarInt(playerid, "_lastTicketWarning", 0);
		}

		case 1..2: // dashboard radar has been deployed
		{
			CarRadars[playerid] = 0;
			PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
			PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawHide(playerid, _crTickets[playerid]);
			
			SendClientMessageEx(playerid, COLOR_WHITE, "You are no longer using your dashboard radar.");
			DeletePVar(playerid, "_lastTicketWarning");
		}
	}

	return 1;
}

CMD:radargun(playerid, params[])
{
	if(IsACop(playerid))
	{
		new string[128];
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam viec nay khi dang ngoi tren xe.");
			return 1;
		}

		if(GetPVarType(playerid, "IsInArena"))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay khi dang trong dau truong!");
			return 1;
		}
		if(GetPVarInt( playerid, "EventToken") != 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay khi dang trong su kien.");
			return 1;
		}

		if(GetPVarInt(playerid, "Injured") == 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay khi dang bi thuong.");
			return 1;
		}

		if(PlayerInfo[playerid][pJailTime] > 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay khi dang trong tu.");
			return 1;
		}
		if(PlayerCuffed[playerid] >= 1) {
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay khi dang bi cong tay hoac cuong che.");
			return 1;
		}

		new SpeedRadar = GetPVarInt(playerid, "SpeedRadar");
		if(SpeedRadar == 0)
		{
			SetPVarInt(playerid, "RadarReplacement", PlayerInfo[playerid][pGuns][9]);
			if(PlayerInfo[playerid][pGuns][9] != 0) RemovePlayerWeapon(playerid, PlayerInfo[playerid][pGuns][9]);
			format(string, sizeof(string), "* %s da lay sung ban toc do ra.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			GivePlayerValidWeapon(playerid, 43);
			SetPVarInt(playerid, "SpeedRadar", 1);
		}
		else
		{
			RemovePlayerWeapon(playerid, 43);
			GivePlayerValidWeapon(playerid, GetPVarInt(playerid, "RadarReplacement"));
			format(string, sizeof(string), "* %s da cat sung ban toc do vao.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			DeletePVar(playerid, "SpeedRadar");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la Canh sat!");
		return 1;
	}
	return 1;
}

CMD:cuff(playerid, params[])
{
	if(IsACop(playerid))
	{
		if(GetPVarInt(playerid, "Injured") == 1 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the thuc hien lenh nay o thoi diem hien tai!");
			return 1;
		}

		if(PlayerInfo[playerid][pHasCuff] < 1)
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong mang theo cong tay!");
		    return 1;
		}

		new string[128], giveplayerid, Float:health, Float:armor;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /congtay [player]");
		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the cong tay voi chinh minh!"); return 1; }
				if(GetPVarInt(giveplayerid, "Injured") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the cong tay khi dang bi thuong.");
				if(PlayerCuffed[giveplayerid] == 1 || GetPlayerSpecialAction(giveplayerid) == SPECIAL_ACTION_HANDSUP || GetPVarInt(giveplayerid, "pBagged") >= 1)
				{
					if(PlayerInfo[giveplayerid][pConnectHours] < 32) SendClientMessageEx(giveplayerid, COLOR_WHITE, "Ban dang bi cong, neu ban thoat khoi may chu se bi o tu hon 2 gio!");
					format(string, sizeof(string), "* Ban da bi cong tay boi %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Ban da cong tay %s thanh cong.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s da cong tay %s va that chat cong lai.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					GameTextForPlayer(giveplayerid, "~r~CONG TAY", 2500, 3);
					TogglePlayerControllable(giveplayerid, 0);
					ClearAnimationsEx(giveplayerid);
					GetHealth(giveplayerid, health);
					GetArmour(giveplayerid, armor);
					SetPVarFloat(giveplayerid, "cuffhealth",health);
					SetPVarFloat(giveplayerid, "cuffarmor",armor);
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
					ApplyAnimation(giveplayerid,"ped","cower",1,1,0,0,0,0,1);
					PlayerCuffed[giveplayerid] = 2;
					SetPVarInt(giveplayerid, "PlayerCuffed", 2);
					SetPVarInt(giveplayerid, "IsFrozen", 1);
					DeletePVar(giveplayerid, "pBagged");
					//Frozen[giveplayerid] = 1;
					PlayerCuffedTime[giveplayerid] = 300;
				}
				else if(GetPVarType(giveplayerid, "IsTackled"))
				{
				    format(string, sizeof(string), "* %s da lay cong tay ra tu that lung va cong tay %s lai.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, giveplayerid);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi nay khong bi cuong che!");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Canh sat!");
	}
	return 1;
}

CMD:uncuff(playerid, params[])
{
	if(IsACop(playerid))
	{
		if(PlayerCuffed[playerid] == 2) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the thao cong cho chinh minh!");
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /thaocong [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				/*if(PlayerInfo[giveplayerid][pJailTime] >= 1)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "You can't uncuff a jailed player.");
					return 1;
				} */
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the tu thao cong cho chinh minh!"); return 1; }
				if(PlayerCuffed[giveplayerid] > 1)
				{
					DeletePVar(giveplayerid, "IsFrozen");
					format(string, sizeof(string), "* Ban da duoc thao cong boi %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Ban da thao cong cho %s thanh cong.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s da thao cong cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					GameTextForPlayer(giveplayerid, "~g~THAO CONG", 2500, 3);
					TogglePlayerControllable(giveplayerid, 1);
					ClearAnimationsEx(giveplayerid);
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
					PlayerCuffed[giveplayerid] = 0;
                    PlayerCuffedTime[giveplayerid] = 0;
                    SetHealth(giveplayerid, GetPVarFloat(giveplayerid, "cuffhealth"));
                    SetArmour(giveplayerid, GetPVarFloat(giveplayerid, "cuffarmor"));
                    DeletePVar(giveplayerid, "cuffhealth");
					DeletePVar(giveplayerid, "PlayerCuffed");
					DeletePVar(giveplayerid, "jailcuffs");
				}
				else if(GetPVarInt(giveplayerid, "jailcuffs") == 1)
				{
					DeletePVar(giveplayerid, "IsFrozen");
					format(string, sizeof(string), "* Ban da duoc thao cong boi %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Ban da thao cong %s thanh cong.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s da thao cong cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					GameTextForPlayer(giveplayerid, "~g~THAO CONG", 2500, 3);
					ClearAnimationsEx(giveplayerid);
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
					DeletePVar(giveplayerid, "jailcuffs");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong bi cong tay.");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Canh sat!");
	}
	return 1;
}

CMD:detain(playerid, params[])
{
	if(IsACop(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang ngoi tren xe.");
			return 1;
		}

		new string[128], giveplayerid, seat;
		if(sscanf(params, "ud", giveplayerid, seat)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /dualenxe [player] [seatid 1-3]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(seat < 1 || seat > 3)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "Seat ID khong duoc hon 3 hoac it hon 1.");
				return 1;
			}
			/*if(IsACop(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You can't detain other law enforcement officers.");
				return 1;
			}*/
			if(IsPlayerInAnyVehicle(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay dang o trong xe, hay dua ho ra truoc.");
				return 1;
			}
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the dua chinh minh len xe!"); return 1; }
				if(PlayerCuffed[giveplayerid] == 2)
				{
					new carid = gLastCar[playerid];
					if(IsSeatAvailable(carid, seat))
					{
						new Float:pos[6];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						GetPlayerPos(giveplayerid, pos[3], pos[4], pos[5]);
						GetVehiclePos( carid, pos[0], pos[1], pos[2]);
						if (floatcmp(floatabs(floatsub(pos[0], pos[3])), 10.0) != -1 &&
								floatcmp(floatabs(floatsub(pos[1], pos[4])), 10.0) != -1 &&
								floatcmp(floatabs(floatsub(pos[2], pos[5])), 10.0) != -1) return false;
						format(string, sizeof(string), "* Ban da duoc dua len xe boi %s .", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Ban da dua %s len xe.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* %s da dua %s len chiec xe gan do.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						GameTextForPlayer(giveplayerid, "~r~DUA LEN XE", 2500, 3);
						ClearAnimationsEx(giveplayerid);
						TogglePlayerControllable(giveplayerid, false);
						IsPlayerEntering{giveplayerid} = true;
						DangLenXe[giveplayerid] = carid;
						PutPlayerInVehicle(giveplayerid, carid, seat);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Ghe ngoi do khong co san!");
						return 1;
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi do khong bi cong tay!");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan toi pham hoac phuong tien!");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la Canh sat!");
	}
	return 1;
}

CMD:drag(playerid, params[])
{
	if(IsACop(playerid))
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /dandi [playerid]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid == playerid) {
				SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay voi chinh minh!");
				return 1;
			}
			if(GetPVarInt(giveplayerid, "PlayerCuffed") == 2)
			{
				if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai ra khoi phuong tien de su dung lenh nay.");
				if(GetPVarInt(giveplayerid, "BeingDragged") == 1)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi do dang duoc keo di. ");
					return 1;
				}
                new Float:dX, Float:dY, Float:dZ;
				GetPlayerPos(giveplayerid, dX, dY, dZ);
				if(!IsPlayerInRangeOfPoint(playerid, 5.0, dX, dY, dZ))
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi do khong dung gan ban.");
					return 1;
				}
				format(string, sizeof(string), "* %s da keo ban di theo ho.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
				format(string, sizeof(string), "* Ban da keo %s di theo ban.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "* %s da keo %s di theo ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SendClientMessageEx(playerid, COLOR_WHITE, "Bay gio ban dang keo nghi phap di theo, nhan chuot '{AA3333}TRAI{FFFFFF}' de ngung keo di.");
				SetPVarInt(giveplayerid, "BeingDragged", 1);
				SetPVarInt(playerid, "DraggingPlayer", giveplayerid);
				SetTimerEx("DragPlayer", 1000, 0, "ii", playerid, giveplayerid);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Nguoi nay khong bi cong tay!");
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Canh sat!");
		return 1;
	}
	return 1;
}

CMD:wanted(playerid, params[])
{
	if(IsACop(playerid) || IsAJudge(playerid) || IsAGovernment(playerid) || PlayerInfo[playerid][pJob] == 2 || PlayerInfo[playerid][pJob2] == 2 || PlayerInfo[playerid][pJob3] == 2)
	{
		szMiscArray[0] = 0;
		
		new x,
			szNation[24];

		SendClientMessageEx(playerid, COLOR_GREEN, "Danh sach truy na:");
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pWantedLevel] >= 1)
			{
				switch(PlayerInfo[i][pNation]) {
					case 0: szNation = "San Andreas";
					case 1: szNation = "New Robada";
					default: szNation = "None";
				}
				format(szMiscArray, sizeof(szMiscArray), "%s%s: %d (%s)", szMiscArray, GetPlayerNameEx(i),PlayerInfo[i][pWantedLevel], szNation);
				x++;
				if(x > 3) {
					SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
					x = 0;
					format(szMiscArray, sizeof(szMiscArray), " ");
				} else {
					format(szMiscArray, sizeof(szMiscArray), "%s, ", szMiscArray);
				}
			}
		}	
		if(x <= 3 && x > 0)
		{
			szMiscArray[strlen(szMiscArray)-2] = '.';
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Luat su hoac Canh sat!");
	}
	return 1;
}

CMD:ticket(playerid, params[])
{
	if(IsACop(playerid))
	{

		new string[128], giveplayerid, moneys, reason[64];
		if(sscanf(params, "uds[64]", giveplayerid, moneys, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /ticket [player] [gia] [ly do]");

		if(giveplayerid == playerid)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the ghi ve phat cho chinh minh.");
			return 1;
		}
		if(giveplayerid < 0 || giveplayerid == INVALID_PLAYER_ID || giveplayerid > MAX_PLAYERS) return SendClientMessage(playerid, -1, "Nguoi choi do khong ton tai");
		if(moneys < 50000 || moneys > 500000) { SendClientMessageEx(playerid, COLOR_GREY, "Ve phat it nhat la $50,000 va cao nhat la $500,000."); return 1; }
		if(PlayerInfo[giveplayerid][pConnectHours] < 2 && moneys > 20000) { SendClientMessageEx(playerid, COLOR_GREY, "Ban chi co the viet ve phat cho nguoi choi thap hon 2 gio choi toi da $20,000."); return 1; }
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(giveplayerid == playerid) return 1;

					format(string, sizeof(string), "* Ban da dua cho %s mot ve phat va phi nop phat la $%d, ly do: %s", GetPlayerNameEx(giveplayerid), moneys, reason);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s da dua cho ban mot ve phat va ban phai dong $%d, ly do: %s", GetPlayerNameEx(playerid), moneys, reason);
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Officer %s viet ve phat va dua cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "(( Hay nhap /chapnhan ticket de chap nhan )).");
					TicketOffer[giveplayerid] = playerid;
					TicketMoney[giveplayerid] = moneys;
					SetPVarString(playerid, "ticketreason", reason);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
			return 1;
		}
	}
	return 1;
}

CMD:wheelclamp(playerid, params[])
{
	if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iWheelClamps]) {
		new vehicleid = GetClosestCar(playerid, INVALID_VEHICLE_ID, 5.0),
			szMessage[24 + 51 + MAX_PLAYER_NAME];
		if(vehicleid != INVALID_VEHICLE_ID && GetDistanceToCar(playerid, vehicleid) < 5 && !IsPlayerInAnyVehicle(playerid)) {
			if(IsAPlane(vehicleid) || IsWeaponizedVehicle(GetVehicleModel(vehicleid)) || IsABike(vehicleid) || IsABoat(vehicleid))
				return SendClientMessageEx(playerid,COLOR_GREY,"(( You can't place wheel clamps on this vehicle. ))");
			if(WheelClamp{vehicleid}) {
				WheelClamp{vehicleid} = 0;
				format(szMessage, sizeof(szMessage), "* %s has removed a Wheel Clamp from the %s's front tire.", GetPlayerNameEx(playerid), GetVehicleName(vehicleid), vehicleid);
				ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SendClientMessageEx(playerid, COLOR_PURPLE, "(( You have removed the Wheel Clamp from this vehicle's front tire. ))");
			}
			else {
				SetPVarInt(playerid, "wheelclampvehicle", vehicleid);
				SetPVarInt(playerid, "wheelclampcountdown", 10);
				format(szMessage, sizeof(szMessage), "* %s is attempting to place a Wheel Clamp in the %s's front tire.", GetPlayerNameEx(playerid), GetVehicleName(vehicleid), vehicleid);
				ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SendClientMessageEx(playerid, COLOR_PURPLE, "(( You're now placing a Wheel Clamp in the vehicle's front tire, please wait. ))");
			}
			RemoveVehicleFromMeter(vehicleid);
		} 
		else
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung gan phuong tien nao ca.");
	}
	else
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong duoc phep su dung lenh nay.");
	return 1;
}
