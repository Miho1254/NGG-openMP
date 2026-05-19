/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Mechanic System

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

timer Fix_PlayerInVehicleCheck[3000](playerid) {

	if(IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][pMechSkill] < 700) {

		TogglePlayerControllable(playerid, true);
		RemovePlayerFromVehicle(playerid);
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SERVER]: Please do not exploit this again.");
		TogglePlayerControllable(playerid, false);
	}
}

CMD:fix(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 7 || PlayerInfo[playerid][pJob2] == 7 || PlayerInfo[playerid][pJob3] == 7 ||
	(PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID && Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_MECHANIC && InBusiness(playerid) == PlayerInfo[playerid][pBusiness]))
	{
    	new string[32 + MAX_PLAYER_NAME];
        if(IsPlayerInAnyVehicle(playerid))
		{
		    SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the sua xe khi o trong xe.");
		    return 1;
		}

  		if(gettime() < PlayerInfo[playerid][pMechTime])
		{
  			format(string, sizeof(string), "Ban can cho doi %d giay!", PlayerInfo[playerid][pMechTime]-gettime());
     		SendClientMessageEx(playerid, COLOR_GRAD1,string);
     		return 1;
     	}
     	else if(GetPVarType(playerid, "IsInArena"))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the sua xe o arena!");
			return 1;
		}
		else if(GetPVarInt(playerid, "EventToken"))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the sua xe o event.");
			return 1;
		}
		else if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen"))
		{
			return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu do bay gio!");
		}
		else if(GetPVarType(playerid, "FixVehicleTimer"))
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang sua xe!");
		}
  		else
		{
			new closestcar = GetClosestCar(playerid);

  			if (IsPlayerInRangeOfVehicle(playerid, closestcar, 10.0))
  			{
				new engine,lights,alarm,doors,bonnet,boot,objective;
				new level = PlayerInfo[playerid][pMechSkill];
				GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
				if (IsABike(closestcar) || IsAPlane(closestcar))
				{
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 1, 0, 0, 0, 0, 1);
				}
				else
				{
					if (bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai mo nap xe ra de sua ( /xe hood ).");
						return 1;
					}
					if (!IsPlayerNearHood(playerid, closestcar))
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai can dung truoc mui xe.");
						return 1;
					}
					new Float:z_angle;
					GetVehicleZAngle(closestcar, z_angle);
					SetPlayerFacingAngle(playerid, z_angle);
					TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "CAR", "Fixn_Car_Loop", 4.1, 1, 0, 0, 0, 0, 1);

				}
				format(string, sizeof(string), "* %s Dang sua phuong tien cua anh ta.", GetPlayerNameEx(playerid));
    			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

    			if (level >= 400) SetTimerEx("FixVehicle", 2000, false, "ii", playerid, closestcar); // Fixes the crash bug.
				else SetPVarInt(playerid, "FixVehicleTimer", SetTimerEx("FixVehicle", 15000, false, "ii", playerid, closestcar));

		
				defer Fix_PlayerInVehicleCheck(playerid);
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong o gan phuong tien.");
  		}
    }
    else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong phai tho sua xe!" );
    return 1;
}

forward FixVehicle(playerid, vehicleid);
public FixVehicle(playerid, vehicleid)
{
	TogglePlayerControllable(playerid, 1);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	ClearAnimationsEx(playerid);
	// SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	PlayerInfo[playerid][pMechTime] = gettime()+60;
	SetVehicleHealth(vehicleid, 1000.0);
	Vehicle_Armor(vehicleid);
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	if(GetVehicleModel(vehicleid) == 481 && GetVehicleModel(vehicleid) == 509 && GetVehicleModel(vehicleid) == 510)
	{
		SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		arr_Engine{vehicleid} = 1;
	}
	format(szMiscArray, sizeof(szMiscArray), "* %s da sua chua xong phuong tien.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	DeletePVar(playerid, "FixVehicleTimer");
}

CMD:mechduty(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 7 || PlayerInfo[playerid][pJob2] == 7 || PlayerInfo[playerid][pJob3] == 7)
	{
        if(GetPVarInt(playerid, "MechanicDuty") == 1)
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da nghi lam va se khong nhan duoc cuoc goi nao nua.");
			SetPVarInt(playerid, "MechanicDuty", 0);
            Mechanics -= 1;
        }
        else if(GetPVarInt(playerid, "MechanicDuty") == 0)
		{
            if (TransportDuty[playerid] != 0) return SendClientMessageEx(playerid,COLOR_GREY,"You are get off duty as a transport driver first.");
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da bat dau lam viec va se nhan duoc cac cuoc goi sua chua phuong tien.");
			SetPVarInt(playerid, "MechanicDuty", 1);
            ++Mechanics;
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong phai la Mechanic!");
    }
    return 1;
}

CMD:nos(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 7 || PlayerInfo[playerid][pJob2] == 7 || PlayerInfo[playerid][pJob3] == 7) {
        if(IsPlayerInAnyVehicle(playerid)) {
			if(GetPVarInt(playerid, "EventToken")) {
				return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the lam dieu nay trong su kien.");
			}
   			if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1010)) != 1010 && GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1009)) != 1009 && GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), GetVehicleComponentType(1008)) != 1008)
   			{
            	if(!IsPlayerInInvalidNosVehicle(playerid))
				{
                	new string[128];
                	new nostogive;
               		new level = PlayerInfo[playerid][pMechSkill];
 		 			if(level >= 0 && level < 100) { nostogive = 1009; }
    		 		else if(level >= 100 && level < 300) { nostogive = 1009; }
         			else if(level >= 300 && level < 500) { nostogive = 1008; }
                	else if(level >= 500 && level < 700) { nostogive = 1008; }
                	else if(level >= 700) { nostogive = 1010; }
                	AddVehicleComponent(GetPlayerVehicleID(playerid),nostogive);
                	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
                	format(string, sizeof(string), "* %s da them nitro vao phuong tien.", GetPlayerNameEx(playerid));
                	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            	}
            	else {
            	    SendClientMessageEx(playerid, COLOR_GREY, "Nitro khong the gan vao phuong tien nay nay.");
            	}
			 }
			 else {
			    SendClientMessageEx(playerid, COLOR_GREY, "Phuong tien nay da co nitro.");
		 	}
        }
        else {
            SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai chiec xe.");
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Mechanic!" );
    }
    return 1;
}

CMD:hyd(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 7 || PlayerInfo[playerid][pJob2] == 7 || PlayerInfo[playerid][pJob3] == 7) {
        if(IsPlayerInAnyVehicle(playerid)) {
			if(IsPlayerInInvalidNosVehicle(playerid) || (DynVeh[GetPlayerVehicleID(playerid)] != -1 && DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_igID] != INVALID_GROUP_ID && arrGroupData[DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_igID]][g_iGroupType] != GROUP_TYPE_CRIMINAL)) return SendClientMessageEx(playerid, COLOR_WHITE, "Hydraulics cannot be installed in this vehicle.");
			if(gettime() < PlayerInfo[playerid][pServiceTime]) return SendClientMessage(playerid, COLOR_GREY, "Ban phai doi 20 giay truoc khi su dung lai.");
			new string[128];
			PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
			format(string, sizeof(string), "* %s da them hyd vao phuong tien.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			PlayerInfo[playerid][pServiceTime] = gettime()+20;
        }
        else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung tai chiec xe.");
    }
    else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong phai la Mechanic!");
    return 1;
}

stock GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}
stock IsPlayerNearHood(playerid, vehicleid)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleHood(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 3.0, fX, fY, fZ);
}
