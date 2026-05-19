/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Taxi Group Type

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
stock SendTaxiMessage(color, string[])
{
	foreach(new i: Player)
	{
		if((IsATaxiDriver(i) && PlayerInfo[i][pDuty] > 0) || (IsATaxiDriver(i) && TransportDuty[i] > 0)) {
			SendClientMessageEx(i, color, string);
		}
	}	
}

CMD:fare(playerid, params[])
{
	if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_TAXI)
	{
		new string[128], fare;
		if(sscanf(params, "d", fare)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /fare [gia]");

		if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay bay gio.");

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
			format(string, sizeof(string), "Ban da tat huy hieu va nhan duoc $%d.", TransportMoney[playerid]);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			GivePlayerCash(playerid, (TransportMoney[playerid] / 100 * 25));
			if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_TAXI))
			{
				arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] += (TransportMoney[playerid] / 100 * 25);
				if(TransportMoney[playerid]) format(szMiscArray, sizeof(szMiscArray), "%s da tat huy hieu va nhan duoc $%s", GetPlayerNameEx(playerid), number_format(TransportMoney[playerid])), GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
			}
			TransportValue[playerid] = 0; TransportMoney[playerid] = 0;
			SetPlayerToTeamColor(playerid);
			return 1;
		}
		if(GetPVarInt(playerid, "MechanicDuty") == 1 || GetPVarInt(playerid, "LawyerDuty") == 1) return SendClientMessageEx(playerid,COLOR_GREY,"Ban can phai offduty tho sua xe/ luat su truoc.");
		if(GetPlayerState(playerid) != 2) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la tai xe Taxi");
		if(fare < 1 || fare > 2000) return SendClientMessageEx(playerid, COLOR_GREY, "Gia khong duoc thap hon $1 va cao hon $2,000.");
		new newcar = GetPlayerVehicleID(playerid);
		if(IsAnBus(newcar))
		{
			fare = 1500;
			BusDrivers += 1; TransportDuty[playerid] = 2; TransportValue[playerid] = fare;
			format(string, sizeof(string), "Ban da bat huy hieu Bus Driver, fare: $%d.", TransportValue[playerid]);
		}
		else
		{
			TaxiDrivers += 1; TransportDuty[playerid] = 1; TransportValue[playerid] = fare;
			format(string, sizeof(string), "Ban da bat huy hieu Taxi Driver, fare: $%d.", TransportValue[playerid]);
		}
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		if(IsATaxiDriver(playerid)) SetPlayerColor(playerid, COLOR_TAXI); else SetPlayerColor(playerid,TEAM_TAXI_COLOR);
	}
	else
	{
		return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong trong faction Transport (taxi)!");
	}
	return 1;
}

CMD:eba(playerid, params[]) {
	return callcmd::emergencybutton(playerid, params);
}



CMD:emergencybutton(playerid, params[]) {

	if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 7 || arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == 7 || IsAReporter(playerid)) {
		
		new
			szLocation[MAX_ZONE_NAME];
				
        if(PlayerCuffed[playerid] >= 1 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerTied[playerid] > 0 ) {
			return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay ngay bay gio..");
		}

		if(GetPVarType(playerid, "UsedEBA")) {

			if(!IsAReporter(playerid)) {
				format(szMiscArray, sizeof(szMiscArray), "HQ: The SA News distress signal from %s has been cancelled", GetPlayerNameEx(playerid));
				SendGroupMessage(GROUP_TYPE_NEWS, TEAM_BLUE_COLOR, szMiscArray);
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "HQ: The taxi co. distress signal from %s has been cancelled", GetPlayerNameEx(playerid));
				SendTaxiMessage(TEAM_AZTECAS_COLOR, szMiscArray);
			}
			foreach(new i: Player) {

				if(IsACop(i)) SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
			}
			
			SendClientMessage(playerid, COLOR_WHITE, "You have cancelled the emergency button.");
			DeletePVar(playerid, "UsedEBA");
			return 1;
		}

		GetPlayer2DZone(playerid, szLocation, MAX_ZONE_NAME);
	    foreach(new i: Player) {

	    	if(IsACop(i)) {
				if(!IsAReporter(playerid)) SendClientMessageEx(i, TEAM_BLUE_COLOR, "HQ: All Units APB: Reporter: Taxi Company Office");
				else SendClientMessageEx(i, TEAM_BLUE_COLOR, "HQ: All Units APB: Reporter: SA News");

				if(!IsAReporter(playerid)) format(szMiscArray, sizeof(szMiscArray), "HQ: A distress signal is forwarded from the Taxi Company Office for %s at %s",GetPlayerNameEx(playerid), szLocation);
				else format(szMiscArray, sizeof szMiscArray, "HQ: A distress signal is forwarded from SA News for %s at %s", GetPlayerNameEx(playerid), szLocation);

				SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
			}
		}
		format(szMiscArray, sizeof(szMiscArray), "* An alarm engages in %s's vehicle at %s. A message is dispatched to the company's office.", GetPlayerNameEx(playerid), szLocation);
		SendTaxiMessage(TEAM_AZTECAS_COLOR, szMiscArray);
		SendClientMessage(playerid, COLOR_WHITE, "You have pressed the emergency button. The police have been informed.");
		SetPVarInt(playerid, "UsedEBA", 1);
	}
	return 1;
}

CMD:abus(playerid, params[]) return callcmd::ataxi(playerid, params);
CMD:ataxi(playerid, params[])
{
	if(!IsATaxiDriver(playerid)) 
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la tai xe taxi/bus !");
	if(TransportDuty[playerid] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban hien dang tat huy hieu.");

	new
		szMessage[128],
		iTarget;
	if(TransportDuty[playerid] == 1)
	{
		if(sscanf(params, "u", iTarget)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /ataxi [player]");
		if(!IsPlayerConnected(iTarget)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
		if(iTarget == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the chap nhan cuoc goi chinh minh.");
		if(TaxiCallTime[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang chap nhan mot cuoc goi khac.");
		if(!GetPVarType(iTarget, "TaxiCall")) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong yeu cau xe taxi.");

		format(szMessage, sizeof(szMessage), "** Taxi Driver %s da chap nhan cuoc goi cua %s(%d)." , GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget), iTarget);
		SendTaxiMessage(TEAM_AZTECAS_COLOR, szMessage);
		format(szMessage, sizeof(szMessage), "* Tai xe %s da chap nhan cuoc goi Taxi cua ban. Hay doi trong giay lat.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTarget, COLOR_LIGHTBLUE, szMessage);
		GameTextForPlayer(playerid, "~w~Taxi Caller~n~~r~Vi tri da duoc dinh vi", 5000, 1);
		TaxiCallTime[playerid] = 1;
		TaxiAccepted[playerid] = iTarget;
		DeletePVar(iTarget, "TaxiCall");
	}
	if(TransportDuty[playerid] == 2)
	{
		if(sscanf(params, "u", iTarget)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /abus [player]");
		if(!IsPlayerConnected(iTarget)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
		if(iTarget == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the chap nhan cuoc goi chinh minh.");
		if(BusCallTime[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang chap nhan mot cuoc goi khac.");
		if(!GetPVarType(iTarget, "BusCall")) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong yeu cau xe bus.");
		
		format(szMessage, sizeof(szMessage), "** Bus Driver %s has accepted the Bus Call from %s(%d)" , GetPlayerNameEx(playerid), GetPlayerNameEx(iTarget), iTarget);
		SendTaxiMessage(TEAM_AZTECAS_COLOR, szMessage);
		format(szMessage, sizeof(szMessage), "* Tai xe %s da chap nhan cuoc goi Bus cua ban. Hay doi trong giay lat.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTarget, COLOR_LIGHTBLUE, szMessage);
		GameTextForPlayer(playerid, "~w~Bus Caller~n~~r~Vi tri da duoc dinh vi", 5000, 1);
		BusCallTime[playerid] = 1;
		BusAccepted[playerid] = iTarget;
		DeletePVar(iTarget, "BusCall");
	}
	PlayerInfo[playerid][pCallsAccepted]++;
	return 1;
}
