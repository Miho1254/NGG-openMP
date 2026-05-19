/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Service Commands

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

CMD:service(playerid, params[])
{
	new string[128], choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /dichvu [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "DICH VU: Taxi, Bus, Medic, Mechanic");
		return 1;
	}

	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
		return 1;
	}
	if(gettime() < PlayerInfo[playerid][pServiceTime]) return SendClientMessage(playerid, COLOR_GREY, "Ban phai cho 30 giay sau de su dung lai..." );

	if(strcmp(choice,"medic",true) == 0)
	{
		if(GetPVarInt(playerid, "Injured") == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban khong bi thuong de su dung dich vu nay!");
			return 1;
		}
		new zone[MAX_ZONE_NAME];
		GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
		SetPVarInt(playerid, "EMSAttempt", 1);
		SendClientMessageEx(playerid, COLOR_WHITE, "Cuu thuong da xac nhan duoc vi tri cua ban va dang tren duong den.");
		format(string, sizeof(string), "Emergency Dispatch da bao cao (%d) %s bi thuong tai %s. Ho can cuu thuong den ho tro ngay lap tuc (/emslist).",playerid, GetPlayerNameEx(playerid), zone);
		SendMedicMessage(TEAM_MED_COLOR, string);
		PlayerInfo[playerid][pServiceTime] = gettime()+30;
		return 1;
	}
	else if(strcmp(choice,"taxi",true) == 0)
	{
		if(TaxiDrivers < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co taxi nao lam viec! Hay goi lai sau...");
		if(TransportDuty[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban khong the goi taxi!");

		if(GetPVarInt(playerid, "TaxiCall")) return SendClientMessage(playerid, COLOR_GREY, "Ban da yeu cau dich vu taxi roi! Neu muon huy su dung lenh (/huy taxi).");

		new szZoneName[MAX_ZONE_NAME];
		GetPlayer2DZone(playerid, szZoneName, MAX_ZONE_NAME);
		format(string, sizeof(string), "** %s (%d) dang can mot chiec taxi den %s - su dung /ataxi de chap nhan cuoc goi.", GetPlayerNameEx(playerid), playerid, szZoneName );
		SendTaxiMessage(TEAM_AZTECAS_COLOR, string);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da yeu cau dich vu taxi! Hay cho mot lat...");
		SetPVarInt(playerid, "TaxiCall", 1);
		PlayerInfo[playerid][pServiceTime] = gettime()+30;
		return 1;
	}
	else if(strcmp(choice,"bus",true) == 0)
	{
		if(BusDrivers < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co bus nao lam viec! Hay goi lai sau...");
		if(TransportDuty[playerid] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban khong the goi bus!");

		new szZoneName[MAX_ZONE_NAME];
		GetPlayer2DZone(playerid, szZoneName, sizeof(szZoneName));
		format(string, sizeof(string), "** %s(%d) dang can mot chiec bus den %s - su dung /abus de chap nhan cuoc goi.", GetPlayerNameEx(playerid), playerid, szZoneName );
		SendTaxiMessage(TEAM_AZTECAS_COLOR, string);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da yeu cau dich vu bus! Hay cho mot lat...");
		SetPVarInt(playerid, "BusCall", 1);
		PlayerInfo[playerid][pServiceTime] = gettime()+30;
		return 1;
	}
	/*
	else if(strcmp(choice,"medic",true) == 0)
	{
		new OnDutyMedics;
		foreach(new i: Player)
		{
			if(IsAMedic(i) || IsFirstAid(i) && PlayerInfo[i][pDuty] == 1)
			{
				OnDutyMedics++;
			}
		}
		if(OnDutyMedics < 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co cuu thuong nao lam viec! Hay goi lai sau...");
			return 1;
		}
		else
		{
			format(string, sizeof(string), "** %s dang can mot chiec xe cuu thuong - su dung /chapnhan medic de chap nhan cuoc goi.", GetPlayerNameEx(playerid));
			SendDivisionMessage(12, 2, TEAM_AZTECAS_COLOR, string);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da yeu cau dich vu cuu thuong! Hay cho mot lat...");
			MedicCall = playerid;
			PlayerInfo[playerid][pServiceTime] = gettime()+30;
			OnDutyMedics = 0;
			return 1;
		}
	}
	*/
	else if(strcmp(choice,"mechanic",true) == 0)
	{
		if(Mechanics < 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co Car Mechanic nao lam viec! Hay goi lai sau...");
			return 1;
		}
		format(string, sizeof(string), "** %s dang can mot Car Mechanic - su dung /chapnhan mechanic de chap nhan cuoc goi.", GetPlayerNameEx(playerid));
		SendJobMessage(7, TEAM_AZTECAS_COLOR, string);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da yeu cau dich vu Car Mechanic! Hay cho mot lat...");
		MechanicCall = playerid;
		PlayerInfo[playerid][pServiceTime] = gettime()+30;
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Dich vu khong ton tai!");
		return 1;
	}
}
