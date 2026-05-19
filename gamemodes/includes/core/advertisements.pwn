/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Advertisements System

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

stock ShowAdMuteFine(playerid)
{
	new string[128];
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));

	new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

    new fine = 10*totalwealth/100;
	if(PlayerInfo[playerid][pADMuteTotal] < 4)
	{
		format(string,sizeof(string),"Jail for %d Minutes\nCash Fine ($%d)",PlayerInfo[playerid][pADMuteTotal]*15,fine);
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 4)
	{
	    format(string,sizeof(string),"Prison for 1 Hour");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 5)
	{
	    format(string,sizeof(string),"Prison for 1 Hour and 15 Minutes)");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 6)
	{
	    format(string,sizeof(string),"Prison for 1 Hour and 30 Minutes");
	}
	ShowPlayerDialogEx(playerid,ADMUTE,DIALOG_STYLE_LIST,"Ads Unmute - Lua chon:",string,"Chon","Huy");
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(strfind(inputtext, "%", true) != -1)
	{
		SendClientMessage(playerid, COLOR_GREY, "Invalid Character, please try again.");
		return 1;
	}
	switch(dialogid)
	{
		case DIALOG_ADCATEGORY:
		{
			if(!response) return 1;
			szMiscArray[0] = 0;
			new szBuffer[32],
				arrAdverts[MAX_PLAYERS] = INVALID_PLAYER_ID,
				iDialogCount,
				iCount,
				iBreak,
				iRand;
			for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;
			foreach(new i: Player) if(!isnull(szAdvert[i])) arrAdverts[iCount++] = i;

			while(iDialogCount < 50 && iBreak < 500) {
				iRand = random(iCount);
				if(iCount && arrAdverts[iRand] != INVALID_PLAYER_ID) {
					if(AdvertType[arrAdverts[iRand]] == listitem+1)
					{
						strcpy(szBuffer, szAdvert[arrAdverts[iRand]], sizeof(szBuffer));
						if(PlayerInfo[playerid][pAdmin] <= 1) format(szMiscArray, sizeof(szMiscArray), "%s%s... (%i)\r\n", szMiscArray, szBuffer, PlayerInfo[arrAdverts[iRand]][pPnumber]);
						else format(szMiscArray, sizeof(szMiscArray), "%s%s... (%s)\r\n", szMiscArray, szBuffer, GetPlayerNameEx(arrAdverts[iRand]));
						ListItemTrackId[playerid][iDialogCount++] = arrAdverts[iRand];
						arrAdverts[iRand] = INVALID_PLAYER_ID;
					}
				}
				++iBreak;
			}
			if(!isnull(szMiscArray)) return ShowPlayerDialogEx(playerid, DIALOG_ADLIST, DIALOG_STYLE_LIST, "Danh sach quang cao", szMiscArray, "Chon", "Tro ve");
			ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Danh muc", "Mua\nBan", "Chon", "Huy");
			SendClientMessage(playerid, COLOR_GREY, "Khong co quang cao nao duoc dang.");
		}
		case DIALOG_ADMAIN: if(response) switch(listitem) {
			case 0: ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORY, DIALOG_STYLE_LIST, "Danh muc", "Mua\nBan", "Chon", "Huy");
			case 1: ShowPlayerDialogEx(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Tim kiem quang cao", "Nhap thu ban muon tim kiem.", "Tim kiem", "Tro ve");
			case 2: {
				if(PlayerInfo[playerid][pADMute] == 1) {
					SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam su dung kenh ads.");
				}
				else if(PlayerInfo[playerid][pPnumber] == 0) {
					SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co dien thoai.");
				}
				else ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACE, DIALOG_STYLE_LIST, "Chon danh muc", "Mua\nBan", "Chon", "Huy");
			}
			case 3: {
				if(PlayerInfo[playerid][pADMute] == 1) {
					SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam su dung kenh ads.");
				}
				else if(PlayerInfo[playerid][pPnumber] == 0) {
					SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co dien thoai.");
				}
				else if(gettime() < GetPVarInt(playerid, "adT")) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban chi duoc dat quang cao toan quoc cach nhau 2 phut.");
				}
				else if(gettime() < iAdverTimer) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban chi duoc dat quang cao cach nhau 30 giay.");
				}
				else
				{
					if(PlayerInfo[playerid][pAdvertVoucher] != 0)
					{
						ShowPlayerDialogEx(playerid, DIALOG_ADVERTVOUCHER, DIALOG_STYLE_MSGBOX, "Ads Voucher", "Tai khoan ban dang co Ads Voucher (dat quang cao mien phi), ban co muon su dung khong?\n\n{FF0000}Luu y: Khi su dung ban se mat 1 Voucher (/myvouchers){FFFFFF}", "Su dung", "Khong su dung");
					}
					else if(PlayerInfo[playerid][pAdvertVoucher] == 0)
						return ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Chon danh muc", "Mua\nBan", "Chon", "Huy");
				}
			}
			case 4: callcmd::houselistings(playerid, "");
		}
		case DIALOG_ADCATEGORYPLACE: {
			if(response) switch(listitem) {
				case 0: {
					AdvertType[playerid] = 1;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Dat quang cao",
					"Hay mo ta thu ban muon mua, khong duoc qua 128 ki tu.", "Xac nhan", "Tro ve");
				}
				case 1: {
					AdvertType[playerid] = 2;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACE, DIALOG_STYLE_INPUT, "Dat quang cao",
					"Hay mo ta thu ban muon ban, khong duoc qua 128 ki tu.", "Xac nhan", "Tro ve");
				}
			}
		}
		case DIALOG_ADCATEGORYPLACEP: {
			if(response) switch(listitem) {
				case 0: {
					AdvertType[playerid] = 1;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Dat quang cao toan quoc",
					"Hay mo ta thu ban muon mua, khong duoc qua 128 ki tu.\nVi day la quang cao toan quoc nen ban phai ton $150,000.", "Xac nhan", "Tro ve");
				}
				case 1: {
					AdvertType[playerid] = 2;
					ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Dat quang cao toan quoc",
					"Hay mo ta thu ban muon mua, khong duoc qua 128 ki tu.\nVi day la quang cao toan quoc nen ban phai ton $150,000.", "Xac nhan", "Tro ve");
				}
			}
		}
		case DIALOG_ADPLACE: {
			if(response) {

				new iLength = strlen(inputtext);

				if(GetPVarInt(playerid, "RequestingAdP") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban dang co mot quang cao can duoc phe duyet.");

				if(!(2 <= iLength <= 127)) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Noi dung cua ban qua dai hoac qua ngan.");
				}

				iLength *= 50;
				if(GetPlayerCash(playerid) < iLength) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien.");
				}
				/*if(Homes[playerid] > 0 && AdvertType[playerid] == 1 && !PlayerInfo[playerid][pShopNotice])
				{
					PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[6]);
					PlayerTextDrawShow(playerid, MicroNotice[playerid]);
					SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
				}*/
				strcpy(szAdvert[playerid], inputtext, 128);
				StripColorEmbedding(szAdvert[playerid]);
				GivePlayerCash(playerid, -iLength);
				SendClientMessageEx(playerid, COLOR_WHITE, "Chuc mung! quang cao cua ban da duoc phe duyet thanh cong!");
			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADPLACEP: {
			if(response) {
				if(GetPVarInt(playerid, "RequestingAdP") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban dang co mot quang cao can duoc phe duyet.");

				if(gettime() < iAdverTimer) {
					SendClientMessageEx(playerid, COLOR_GREY, "Ban chi duoc dat quang cao cach nhau 30 giay.");
					return ShowPlayerDialogEx(playerid, DIALOG_ADPLACEP, DIALOG_STYLE_INPUT, "Dat quang cao toan quoc",
					"Hay mo ta thu ban muon mua, khong duoc qua 128 ki tu.\nVi day la quang cao toan quoc nen ban phai ton $150,000.", "Xac nhan", "Tro ve");
				}
				if(!(2 <= strlen(inputtext) <= 79)) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Noi dung cua ban qua dai hoac qua ngan.");
				}
				if(GetPVarInt(playerid, "AdvertVoucher") > 0)
				{
				}
				else if(PlayerInfo[playerid][pFreeAdsLeft] > 0)
				{
				}
				else if(PlayerInfo[playerid][pDonateRank] == 2 && GetPlayerCash(playerid) < 125000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien.");
				}
				else if(PlayerInfo[playerid][pDonateRank] == 3 && GetPlayerCash(playerid) < 100000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien.");
				}
				else if(PlayerInfo[playerid][pDonateRank] >= 4 && GetPlayerCash(playerid) < 50000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien.");
				}
				else if(PlayerInfo[playerid][pDonateRank] <= 1 && GetPlayerCash(playerid) < 150000) {
					ShowMainAdvertMenu(playerid);
					return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien.");
				}
				SetPVarInt(playerid, "adT", gettime()+120);
				strcpy(szAdvert[playerid], inputtext, 128);
				StripColorEmbedding(szAdvert[playerid]);

				SetPVarInt(playerid, "RequestingAdP", 1);
				SetPVarString(playerid, "PriorityAdText", szAdvert[playerid]);
				new playername[MAX_PLAYER_NAME];
				GetPlayerName(playerid, playername, sizeof(playername));
				SendReportToQue(playerid, "Priority Advertisement", 2, 4);

				return SendClientMessageEx(playerid, COLOR_WHITE, "Ban da dat quang cao, hay cho Admin phe duyet quang cao cua ban.");
			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADSEARCH: {
			if(response) {

				if(!(4 <= strlen(inputtext) <= 80)) {
					return ShowPlayerDialogEx(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Tim kiem quang cao", "Ban can ghi it nhat 4 ki tu\n va nhieu nhat 80 ki tu.\n\nNhap thu ban can tim kiem:", "Tim kiem", "Tro ve");
				}
				else for(new x; x < 50; ++x) ListItemTrackId[playerid][x] = -1;

				new
					szDialog[2256],
					szSearch[80],
					szBuffer[32],
					iCount;

				strcat(szSearch, inputtext, sizeof(szSearch)); // strfind is a piece of shit when it comes to non-indexed arrays, maybe this'll help.
				foreach(new i: Player)
				{
					if(!isnull(szAdvert[i])) {
						// printf("[ads] [NAME: %s] [ID: %i] [AD: %s] [SEARCH: %s]", GetPlayerNameEx(i), i, szAdvert[i], szSearch);
						if(strfind(szAdvert[i], szSearch, true) != -1 && iCount < 50) {
							// printf("[ads - MATCH] [NAME: %s] [ID: %i] [AD: %s] [SEARCH: %s] [COUNT: %i] [DIALOG LENGTH: %i] [FINDPOS: %i]", GetPlayerNameEx(i), i, szAdvert[i], szSearch, iCount, strlen(szDialog), strfind(szAdvert[i], szSearch, true));
							strcpy(szBuffer, szAdvert[i], sizeof(szBuffer));
							if(PlayerInfo[playerid][pAdmin] <= 1) format(szDialog, sizeof(szDialog), "%s%s... (%i)\r\n", szDialog, szBuffer, PlayerInfo[i][pPnumber]);
							else format(szDialog, sizeof(szDialog), "%s%s... (%s)\r\n", szDialog, szBuffer, GetPlayerNameEx(i));
							ListItemTrackId[playerid][iCount++] = i;
						}
					}
				}
				if(!isnull(szDialog)) ShowPlayerDialogEx(playerid, DIALOG_ADSEARCHLIST, DIALOG_STYLE_LIST, "Ket qua tim kiem", szDialog, "Chon", "Tro ve");
				else ShowPlayerDialogEx(playerid, DIALOG_ADSEARCH, DIALOG_STYLE_INPUT, "Tim kiem quang cao", "Rat tiec! Khong tim thay.\n\nNhap thu ban can tim kiem:", "Tim kiem", "Tro ve");

			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADSEARCHLIST: if(response) {

			new
				i = ListItemTrackId[playerid][listitem],
				szDialog[164];

			if(IsPlayerConnected(i) && !isnull(szAdvert[i])) {
				SetPVarInt(playerid, "advertContact", PlayerInfo[i][pPnumber]);
				format(szDialog, sizeof(szDialog), "%s\r\nLien he: %i", szAdvert[i], PlayerInfo[i][pPnumber]);
				ShowPlayerDialogEx(playerid, DIALOG_ADFINAL, DIALOG_STYLE_MSGBOX, "Ket qua tim kiem", szDialog, "Goi", "Thoat");
			}
			else SendClientMessage(playerid, COLOR_GREY, "Khong the lien he voi nguoi nay hoac nguoi nay da xoa quang cao.");
		}
		case DIALOG_ADFINAL: {
			if(response) {
				new params[32];
				format(params, sizeof(params), "%d", GetPVarInt(playerid, "advertContact"));
				DeletePVar(playerid, "adverContact");
				return callcmd::call(playerid, params);
			}
		}
		case DIALOG_ADLIST: {
			if(response) {

				new
					i = ListItemTrackId[playerid][listitem],
					szDialog[164];

				if(IsPlayerConnected(i) && !isnull(szAdvert[i])) {
					SetPVarInt(playerid, "advertContact", PlayerInfo[i][pPnumber]);
					format(szDialog, sizeof(szDialog), "%s\r\nLien he: %i", szAdvert[i], PlayerInfo[i][pPnumber]);
					return ShowPlayerDialogEx(playerid, DIALOG_ADFINAL, DIALOG_STYLE_MSGBOX, "Ket qua tim kiem", szDialog, "Goi", "Thoat");
				}
				else SendClientMessage(playerid, COLOR_GREY, "Khong the lien he voi nguoi nay hoac nguoi nay da xoa quang cao.");
			}
			else ShowMainAdvertMenu(playerid);
		}
		case DIALOG_ADVERTVOUCHER:
		{
			if(response) // Clicked Yes
			{
				SetPVarInt(playerid, "AdvertVoucher", 1);
				ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Chon danh muc", "Mua\nBan", "Chon", "Huy");
			}
			else // Clicked No
			{
				ShowPlayerDialogEx(playerid, DIALOG_ADCATEGORYPLACEP, DIALOG_STYLE_LIST, "Chon danh muc", "Mua\nBan", "Chon", "Huy");
			}
		}
	}
	return 0;
}

CMD:ads(playerid, params[]) {
	return callcmd::advertisements(playerid, params);
}

CMD:advertisements(playerid, params[]) {
	if(gPlayerLogged{playerid} == 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
	}
	else if(GetPVarType(playerid, "Injured")) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung kenh ads khi bi thuong.");
	}
	else if(PlayerCuffed[playerid] != 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung kenh ads khi bi cong tay.");
	}
	else if(PlayerInfo[playerid][pJailTime] > 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung kenh ads khi o tu.");
	}
	else ShowMainAdvertMenu(playerid);
	return 1;
}

CMD:adunmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /adunmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pADMute] == 1)
			{
				if(PlayerInfo[giveplayerid][pJailTime] != 0)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You cannot offer someone in jail/prison an unmute!");
					SendClientMessageEx(giveplayerid, COLOR_GREY, "Xin loi, ban khong the unmute khi nguoi choi do dang o trong tu.");
					return 1;
				}
				format(string, sizeof(string), "AdmCmd: %s(%d) was unmuted from /ad by %s.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
				format(string, sizeof(string), "AdmCmd: %s was unmuted from /ad by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				PlayerInfo[giveplayerid][pADMute] = 0;
				PlayerInfo[giveplayerid][pADMuteTotal]--;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY,"Nguoi choi nay khong bi mute");
			}

		}
	}
	return 1;
}

CMD:admute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pSMod] == 1)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /admute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
				if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the mute Admin!");
				if(PlayerInfo[giveplayerid][pADMute] == 0)
				{
				    SetPVarInt(giveplayerid, "UnmuteTime", gettime());
					PlayerInfo[giveplayerid][pADMute] = 1;
					PlayerInfo[giveplayerid][pADMuteTotal] += 1;
					format(string, sizeof(string), "AdmCmd: %s(%d) was muted from placing /ad's by %s(%d).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/admin.log", string);
					format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED,string,2);

					if(PlayerInfo[giveplayerid][pADMuteTotal] > 6)
					{
						PlayerInfo[giveplayerid][pADMuteTotal] = 0;
						CreateBan(playerid, PlayerInfo[giveplayerid][pId], giveplayerid, PlayerInfo[giveplayerid][pIP], "Excessive Ad-mutes", 14);
					}

					if(PlayerInfo[playerid][pAdmin] == 1)
					{
						format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by Admin.", GetPlayerNameEx(giveplayerid));
						SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
						SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Ban da bi cam su dung kenh /ads boi Admin.");
					}
					else
					{
						format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
						SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
						format(string, sizeof(string), "Ban da bi cam su dung kenh /ads boi %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					}

					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Hay nho, kenh /ads chi duoc su dung vao muc dich IC vi the ban khong duoc su dung vi muc dich khac.");
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Neu ban muon unmute hay lien he Admin/Advisor de duoc giai quyet (/yeucautrogiup).");

					format(string, sizeof(string), "AdmCmd: %s da bi mute kenh /ads.", GetPlayerNameEx(giveplayerid));
					SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				}
				else
				{
					if(PlayerInfo[playerid][pAdmin] >= 2)
					{
						ShowAdMuteFine(giveplayerid);
						format(string, sizeof(string), "Ban de nghi %s unmute kenh /ads.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "That person is currently muted. You are unable to unmute players from advertisements as a Advisor.");
					}
				}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}

CMD:freeads(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Platinum VIP+");
	new string[128], days;
	ConvertTime(gettime() - PlayerInfo[playerid][pFreeAdsDay], .ctd=days);
	if(days >= 1)
	{
		PlayerInfo[playerid][pFreeAdsDay] = gettime();
		PlayerInfo[playerid][pFreeAdsLeft] = 3;
		SendClientMessageEx(playerid, COLOR_YELLOW, "* Ban con 3 ngay de su dung freeads.");
	}
	else if(PlayerInfo[playerid][pFreeAdsLeft] > 0)
	{
		format(string, sizeof(string), "* Ban con %d ngay de su dung freeads.", PlayerInfo[playerid][pFreeAdsLeft]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	else
	{
		new datestring[32];
		datestring = date(PlayerInfo[playerid][pFreeAdsDay]+86400, 3);
		format(string, sizeof(string), "* You have used all your free ads, you will need to wait until %s.", datestring);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	return 1;
}

ShowMainAdvertMenu(playerid)
	return ShowPlayerDialogEx(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Quang cao", "Danh sach quang cao\nTim kiem quang cao\nDat quang cao\nDat quang cao toan quoc\nDanh sach nha", "Chon", "Huy");
