#include <YSI\y_hooks>

#define MAX_LISTINGS_PER_PAGE (35)

hook OnPlayerConnect(playerid)
{
	AdTracking[playerid] = 0;
	HouseMarketTracking[playerid] = 0;
	ClearDoorSaleVariables(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	for(new i = 0; i < sizeof(HouseInfo); i ++) if(HouseInfo[i][hOwnerID] == GetPlayerSQLId(playerid) && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 1) ClearHouseSaleVariables(i);
	foreach(new i : Player)
	{
		if(DDSaleTarget[i] == playerid && i != playerid)
		{
			SendClientMessageEx(i, COLOR_GREY, "The person purchasing your dynamic doors has disconnected.");
			ClearDoorSaleVariables(i);
			break;
		}
	}
	return 1;
}

ClearHouseSaleVariables(houseid)
{
	HouseInfo[houseid][Listed] = 0;
	HouseInfo[houseid][PendingApproval] = 0;
	HouseInfo[houseid][ListedTimeStamp] = 0;
	HouseInfo[houseid][ListingPrice] = 0;
	for(new i = 0; i < 5; i ++)
	{
		if(i < 2) HouseInfo[houseid][LinkedGarage][i] = 0;
		HouseInfo[houseid][LinkedDoor][i] = 0;
	}
	strcpy(HouseInfo[houseid][ListingDescription], "N/A", 128);
	SaveHouse(houseid);
	return 1;
}

ShowListingInformation(playerid, houseid, dialogid)
{
	new count[3];
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "Thong tin nha:\n\n  House ID: %d\n  Gia: $%s\n  Nguoi ban: %s", houseid, number_format(HouseInfo[houseid][ListingPrice]), StripUnderscore(HouseInfo[houseid][hOwnerName]));
	if(strcmp("N/A", HouseInfo[houseid][ListingDescription], true) != 0) format(szMiscArray, sizeof(szMiscArray), "%s\n  Mo ta ngoi nha: %s", szMiscArray, HouseInfo[houseid][ListingDescription]);
	format(szMiscArray, sizeof(szMiscArray), "%s\n  Rao ban luc: %s", szMiscArray, date(HouseInfo[houseid][ListedTimeStamp], 4));
	strcat(szMiscArray, "\n\nLinked Dynamic Doors:\n");
	for(new i = 0; i < 5; i ++)
	{
		if(HouseInfo[houseid][LinkedDoor][i] != 0 && DDoorsInfo[HouseInfo[houseid][LinkedDoor][i]][ddOwner] == HouseInfo[houseid][hOwnerID]) 
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n  Door ID: %d (%s)", szMiscArray, HouseInfo[houseid][LinkedDoor][i], DDoorsInfo[HouseInfo[houseid][LinkedDoor][i]][ddDescription]);
			count[0] ++;
		}
	}
	if(count[0] == 0) strcat(szMiscArray, "\n  Khong co");
	strcat(szMiscArray, "\n\nLinked Dynamic Gates:\n");
	for(new i = 0; i < sizeof(GateInfo); i ++)
	{
		if(GateInfo[i][gHID] == houseid) 
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n  Gate ID: %d", szMiscArray, i);
			count[1] ++;
		}
	}
	if(count[1] == 0) strcat(szMiscArray, "\n  Khong co");
	strcat(szMiscArray, "\n\nLinked Garages:\n");
	for(new i = 0; i < 2; i ++)
	{
		if(HouseInfo[houseid][LinkedGarage][i] != 0 && GarageInfo[HouseInfo[houseid][LinkedGarage][i]][gar_Owner] == HouseInfo[houseid][hOwnerID]) 
		{
			format(szMiscArray, sizeof(szMiscArray), "%s\n  Garage ID: %d", szMiscArray, HouseInfo[houseid][LinkedGarage][i]);
			count[2] ++;
		}
	}
	if(count[2] == 0) strcat(szMiscArray, "\n  Khong co");
	ShowPlayerDialogEx(playerid, dialogid, DIALOG_STYLE_MSGBOX, "Thong tin nha", szMiscArray, "Xac nhan", "Huy");
	return 1;
}

GetNearestOwnedHouse(playerid)
{
	for(new i = 0; i < sizeof(HouseInfo); i ++) if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]) return i;
	return -1;
}

ShowMainListingDialog(playerid)
{
	new houseid;
	szMiscArray[0] = 0;
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return 1;
	format(szMiscArray, sizeof(szMiscArray), "Setting\tValue\nGia tien\t$%s\nLinked Door 1\t%s\nLinked Door 2\t%s\nLinked Door 3\t%s\nLinked Door 4\t%s\nLinked Door 5\t%s\nLinked Garage 1\t%s\nLinked Garage 2\t%s\nMo ta ngoi nha\t%s\nXac nhan va rao ban",
	number_format(HouseInfo[houseid][ListingPrice]), ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][0]),
	ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][1]), ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][2]),
	ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][3]), ReturnDoorLineDetails(playerid, HouseInfo[houseid][LinkedDoor][4]), 
	ReturnGarageLineDetails(playerid, HouseInfo[houseid][LinkedGarage][0]), ReturnGarageLineDetails(playerid, HouseInfo[houseid][LinkedGarage][1]), HouseInfo[houseid][ListingDescription]);
	ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEMAIN, DIALOG_STYLE_TABLIST_HEADERS, "Rao ban nha", szMiscArray, "Xac nhan", "Huy");
	return 1;
}

AdditionalAdvertisements(index)
{
	for(new i = index; i < sizeof(HouseInfo); i ++) if(HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 0) return true;
	return false;
}

task HouseMarket[60000]()
{
	new bool:notification;
	for(new i = 0; i < sizeof(HouseInfo); i ++)
	{
		if(HouseInfo[i][Listed] == 1)
		{
			switch(HouseInfo[i][PendingApproval])
			{
				case 0:
				{
					if(gettime() >= HouseInfo[i][ListedTimeStamp])
					{
						ClearHouseSaleVariables(i);
						foreach(new p: Player) 
						{
							if(gPlayerLogged{p} == 1 && HouseInfo[i][hOwnerID] == GetPlayerSQLId(p))
							{
								SendClientMessageEx(p, COLOR_GREY, "Ngoi nha cua ban da het han rao ban va da bi xoa khoi danh sach rao ban.");
								break;
							}
						}
					}
				}
				case 1:
				{
					if(notification == false)
					{
						ABroadCast(COLOR_LIGHTRED, "Hien dang co mot so yeu cau rao ban nha can duoc phe duyet (/adanhsachnha).", 4, true);
						notification = true;
					}
				}
			}
		}
	}
	return 1;
}

CMD:al(playerid, params[]) return callcmd::approvelisting(playerid, params);
CMD:dli(playerid, params[]) return callcmd::denylisting(playerid, params);

CMD:houselistinghelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "** TAT CA LENH RAO BAN NHA **");
	SendClientMessageEx(playerid, COLOR_GREY, "/raobannha - Rao ban nha toan quoc - phi $500,000).");
	SendClientMessageEx(playerid, COLOR_GREY, "/giahanbannha - Gia han thoi han rao ban nha - phi gia han $100,000.");
	SendClientMessageEx(playerid, COLOR_GREY, "/thoihanbannha - Xem thoi han rao ban nha con lai.");
	SendClientMessageEx(playerid, COLOR_GREY, "/huybannha - Huy bo rao ban nha.");
	SendClientMessageEx(playerid, COLOR_GREY, "/danhsachnha - Xem danh sach nha dang duoc rao ban toan quoc.");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "{EE9A4D}SENIOR ADMIN{D8D8D8} /adanhsachnha - Xem danh sach yeu cau rao ban nha chua duoc phe duyet.");
		SendClientMessageEx(playerid, COLOR_GREY, "{EE9A4D}SENIOR ADMIN{D8D8D8} /athontinnha [HouseID] - Xem thong tin yeu cau rao ban nha cua nguoi choi.");
		SendClientMessageEx(playerid, COLOR_GREY, "{EE9A4D}SENIOR ADMIN{D8D8D8} /al [HouseID] - Chap nhan yeu cau rao ban nha.");
		SendClientMessageEx(playerid, COLOR_GREY, "{EE9A4D}SENIOR ADMIN{D8D8D8} /dli [HouseID] - Tu choi yeu cau rao ban nha.");
		SendClientMessageEx(playerid, COLOR_GREY, "{EE9A4D}SENIOR ADMIN{D8D8D8} /axoadanhsach [HouseID] - Xoa nha trong danh sach rao ban nha");
		SendClientMessageEx(playerid, COLOR_GREY, "[!] MEO: Su dung lenh (/admute) se cam nguoi choi rao ban nha.");
	}
	return 1;
}

CMD:denylisting(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du quyen de thuc hien lenh nay!");
	new houseid, reason[64], string[128];
	if(sscanf(params, "ds[64]", houseid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /denylisting [HouseID] [Ly do]");
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "ID House thap nhat la 1 va cao nhat la %d!", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(strlen(reason) < 3 || strlen(reason) > 60) return SendClientMessageEx(playerid, COLOR_GREY, "Ly do it nhat la phai 3 ky tu tro len hoac nhieu nhat la 60 ky tu.");
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified house is not currently owned.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay khong co trong danh sach yeu cau rao ban nha.");
	ClearHouseSaleVariables(houseid);
	format(string, sizeof(string), "Ban da tu choi rao ban nha - House ID: %d's (Chu so huu: %s), ly do: %s.", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]), reason);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	foreach(new i: Player) 
	{
		if(gPlayerLogged{i} == 1 && HouseInfo[houseid][hOwnerID] == GetPlayerSQLId(i))
		{
			format(string, sizeof(string), "%s da tu choi rao ban nha - (House ID: %d), ly do: %s.", GetPlayerNameEx(playerid), houseid, reason);
			SendClientMessageEx(i, COLOR_LIGHTRED, string);
			break;
		}
	}
	PlayerInfo[playerid][pTrashReport] ++;
	format(string, sizeof(string), "AdmCmd: %s da tu choi rao ban nha - House ID: %d's (Chu so huu: %s), ly do: %s.", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]), reason);
	ABroadCast(COLOR_LIGHTRED, string, 4);
	Log("logs/admin.log", string);
	return 1;
}

CMD:approvelisting(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du quyen de thuc hien lenh nay!");
	new houseid, seller, string[128];
	if(sscanf(params, "d", houseid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /approvelisting [HouseID]");
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "ID House thap nhat la 1 va cao nhat la %d!", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay hien khong co chu so huu.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay khong co trong danh sach yeu cau rao ban nha.");
	seller = INVALID_PLAYER_ID;
	foreach(new i: Player) 
	{
		if(gPlayerLogged{i} == 1 && HouseInfo[houseid][hOwnerID] == GetPlayerSQLId(i))
		{
			seller = i;
			break;
		}
	}
	switch(seller)
	{
		case INVALID_PLAYER_ID:
		{
			PlayerInfo[playerid][pAcceptReport] ++;
			ReportCount[playerid] ++;
			ReportHourCount[playerid] ++;
			format(string, sizeof(string), "House ID %d's hien dang bi loi, ngoi nha da bi xoa khoi danh sach rao ban.", houseid);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
			return 1;
		}
		default:
		{
			if(GetPlayerCash(seller) < 500000)
			{
				ClearHouseSaleVariables(houseid);
				SendClientMessageEx(seller, COLOR_LIGHTRED, "Yeu cau rao ban nha cua ban da bi huy, vi so du cua ban khong du $500,000 trong nguoi.");
				PlayerInfo[playerid][pAcceptReport] ++;
				ReportCount[playerid] ++;
				ReportHourCount[playerid] ++;
				format(string, sizeof(string), "Ban da chap nhan yeu cau rao ban nha khong thanh cong - House ID: %d's (Nguoi nay khong du tien de tra phi - Chu so huu: %s).", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "AdmCmd: %s da chap nhan yeu cau rao ban nha khong thanh cong - House ID %d's (Nguoi nay khong du tien de tra phi - Chu so huu: %s).", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				Log("logs/admin.log", string);
				return 1;
			}
			else if(GetPlayerCash(seller) >= 500000)
			{
				GivePlayerCashEx(seller, TYPE_ONHAND, -500000);
				HouseInfo[houseid][PendingApproval] = 0;
				HouseInfo[houseid][ListedTimeStamp] = gettime() + 259200;
				SaveHouse(houseid);
				SendClientMessageEx(seller, COLOR_LIGHTBLUE, "Yeu cau rao ban nha cua ban da duoc chap thuan boi Admin, ban da chi tra $500,000.");
				PlayerInfo[playerid][pAcceptReport] ++;
				ReportCount[playerid] ++;
				ReportHourCount[playerid] ++;
				format(string, sizeof(string), "Ban da chap nhan yeu cau rao ban nha - House ID: %d's (Chu so huu: %s).", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "AdmCmd: %s da chap nhan yeu cau rao ban nha - House ID: %d's (Chu so huu: %s).", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
				ABroadCast(COLOR_LIGHTRED, string, 4);
				Log("logs/admin.log", string);
				return 1;
			}
			return 1;
		}
	}
	return 1;
}

CMD:adeletelisting(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du quyen de thuc hien lenh nay!");
	new houseid, string[128];
	if(sscanf(params, "d", houseid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /axoadanhsach [HouseID]");
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "ID House thap nhat la 1 va cao nhat la %d!", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay hien khong co chu so huu.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay khong co trong danh sach yeu cau rao ban nha.");
	ClearHouseSaleVariables(houseid);
	format(string, sizeof(string), "Ban da xoa House ID: %d's ra khoi danh sach rao ban (Chu so huu: %s).", houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "AdmCmd: %s da xoa House ID: %d's ra khoi danh sach rao ban (Chu so huu: %s).", GetPlayerNameEx(playerid), houseid, StripUnderscore(HouseInfo[houseid][hOwnerName]));
	ABroadCast(COLOR_LIGHTRED, string, 4);
	Log("logs/admin.log", string);
	return 1;
}

CMD:listingdetails(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du quyen de thuc hien lenh nay!");
	new houseid;
	if(sscanf(params, "d", houseid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /athongtinnha [HouseID]");
	szMiscArray[0] = 0;
	if(houseid < 1 || houseid >= MAX_HOUSES)
	{
		format(szMiscArray, sizeof(szMiscArray), "ID House thap nhat la 1 va cao nhat la %d!", MAX_HOUSES - 1);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		return 1;
	}
	if(HouseInfo[houseid][hOwned] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay hien khong co chu so huu.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay hien khong nam trong danh sach cho phe duyet.");
	ShowListingInformation(playerid, houseid, DIALOG_LISTINGINFORMATION);
	return 1;
}

CMD:pendinglistings(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du quyen de thuc hien lenh nay!");
	new count, string[64];
	SendClientMessageEx(playerid, COLOR_WHITE, "_________DANH SACH HOUSE CHO PHE DUYET_________");
	for(new i = 0; i < sizeof(HouseInfo); i ++)
	{
		if(HouseInfo[i][hOwned] == 1 && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 1)
		{
			format(string, sizeof(string), "(House ID: %d) | Chu so huu: %s", i, StripUnderscore(HouseInfo[i][hOwnerName]));
			SendClientMessageEx(playerid, COLOR_GREY, string);
			count ++;
		}
	}
	if(count == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co ngoi nha nao can phe duyet.");
	return 1;
}

CMD:listhouse(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
	if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam su dung kenh QUANG CAO.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
	if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai co it nhat $500,000 de dat yeu cau rao ban nha.");
	new houseid;
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "Lenh nay da bi vo hieu hoa!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
	if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay da co trong danh sach rao ban nha!");
	HouseInfo[houseid][ListingPrice] = 0;
	HouseInfo[houseid][PendingApproval] = 0;
	HouseInfo[houseid][ListedTimeStamp] = 0;
	for(new i = 0; i < 5; i ++) 
	{
		if(i < 2) HouseInfo[houseid][LinkedGarage][i] = 0;
		HouseInfo[houseid][LinkedDoor][i] = 0;
	}
	strcpy(HouseInfo[houseid][ListingDescription], "Trong", 128);
	SaveHouse(houseid);
	ShowMainListingDialog(playerid);	
    return 1;
}

CMD:listingdate(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
	new houseid, string[128];
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "Lenh nay da bi vo hieu hoa!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay chua co trong danh sach rao ban.");
	format(string, sizeof(string), "Ngoi nha ban se het han rao ban vao %s.", date(HouseInfo[houseid][ListedTimeStamp], 4));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
    return 1;
}

CMD:renewlisting(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
	if(GetPlayerCash(playerid) < 100000) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai co it nhat $100,000 de gia han rao ban nha.");
	new houseid, string[128];
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "Lenh nay da bi vo hieu hoa!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay chua co trong danh sach rao ban.");
	HouseInfo[houseid][ListedTimeStamp] += 86400;
	SaveHouse(houseid);
	format(string, sizeof(string), "Ban da gia han rao ban nha them 1 ngay, thoi han rao ban duoc keo dai den %s.", date(HouseInfo[houseid][ListedTimeStamp], 4));
	SendClientMessageEx(playerid, COLOR_GREEN, string);
	GivePlayerCashEx(playerid, TYPE_ONHAND, -100000);
    return 1;
}

CMD:deletelisting(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
	new houseid;
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	houseid = GetNearestOwnedHouse(playerid);
	if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
	if(HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is not currently listed on the house market.");
	ClearHouseSaleVariables(houseid);
	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da xoa ngoi nha ban ra khoi danh sach rao ban.");
    return 1;
}

CMD:houselistings(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
	if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
	new count[4], location[MAX_ZONE_NAME];
	szMiscArray[0] = 0;
	for(new i = 0; i < sizeof(HouseInfo); i ++)
	{
		if(HouseInfo[i][hOwned] == 1 && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 0)
		{
			location = "San Andreas";
			for(new l = 1; l < sizeof(count); l ++) count[l] = 0;
			for(new l = 0; l < 5; l ++) 
			{
				if(l < 2) if(HouseInfo[i][LinkedGarage][l] != 0) count[3] ++;
				if(HouseInfo[i][LinkedDoor][l] != 0) count[1] ++;
			}
			for(new l = 0; l < sizeof(GateInfo); l ++) if(GateInfo[l][gHID] == i) count[2] ++;
			Get3DZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], location, sizeof(location));
			format(szMiscArray, sizeof(szMiscArray), "%s\n(%d) [$%s] [%s] [%d DD(s)] [%d DG(s)] [%d G(s)]", szMiscArray, i, number_format(HouseInfo[i][ListingPrice]), location, count[1], count[2], count[3]);
			AdTracking[playerid] = i;
			count[0] ++;
		}
		if(count[0] == MAX_LISTINGS_PER_PAGE) break;
	}
	if(count[0] == 0) return SendClientMessage(playerid, COLOR_GREY, "Hien tai chua co ngoi nha nao duoc rao ban.");
	if(count[0] == MAX_LISTINGS_PER_PAGE) format(szMiscArray, sizeof(szMiscArray), "%s\n[Trang ke...]", szMiscArray);
	ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSELISTINGS, DIALOG_STYLE_LIST, "DANH SACH NHA DANG DUOC RAO BAN", szMiscArray, "Chon", "Huy");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	new string[128];
	switch(dialogid)
	{
		case DIALOG_LISTHOUSEMAIN:
		{
			new houseid;
			houseid = GetNearestOwnedHouse(playerid);
			switch(response)
			{
				case false: if(houseid != -1)  return ClearHouseSaleVariables(houseid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam su dung QUANG CAO.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai co it nhat $500,000 de dat yeu cau rao ban nha.");
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay da co trong danh sach rao ban.");
					switch(listitem)
					{
						case 0: return ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "GIA TIEN", "Hay nhap gia tien nhan duoc khi ban nha.", "Xac nhan", "Huy");
						case 1..5:
						{
							HouseMarketTracking[playerid] = listitem - 1;
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
							return 1;
						}
						case 6, 7:
						{
							HouseMarketTracking[playerid] = listitem - 6;
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
							return 1;
						}
						case 8: return ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDESCRIPTION, DIALOG_STYLE_INPUT, "MO TA NGOI NHA", "Ghi mo ta ve ngoi nha vao phia duoi (Khong bat buoc).", "Xac nhan", "Huy");
						case 9:
						{
							if(HouseInfo[houseid][ListingPrice] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "Ban phai nhap GIA TIEN truoc khi rao ban nha nay.");
								ShowMainListingDialog(playerid);
								return 1;
							}
							for(new i = 0; i < 5; i ++) 
							{
								if(i < 2) if(HouseInfo[houseid][LinkedGarage][i] != 0 && GetPlayerSQLId(playerid) != GarageInfo[HouseInfo[houseid][LinkedGarage][i]][gar_Owner]) HouseInfo[houseid][LinkedGarage][i] = 0;
								if(HouseInfo[houseid][LinkedDoor][i] != 0 && GetPlayerSQLId(playerid) != DDoorsInfo[HouseInfo[houseid][LinkedDoor][i]][ddOwner]) HouseInfo[houseid][LinkedDoor][i] = 0;
							}
							HouseInfo[houseid][Listed] = 1;
							HouseInfo[houseid][PendingApproval] = 1;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "Yeu cau rao ban nha cua ban da duoc gui den Admin, hay cho Admin truc tuyen xet duyet...");
							format(string, sizeof(string), "[YEU CAU RAO BAN NHA]: House ID %d, Chu so huu: %s.", houseid, GetPlayerNameEx(playerid));
							ABroadCast(COLOR_LIGHTRED, string, 4);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEPRICE:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam su dung QUANG CAO.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai co it nhat $500,000 de dat yeu cau rao ban nha.");
					new houseid, price;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay da co trong danh sach rao ban.");
					if(sscanf(inputtext, "d", price))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Gia tien phai duoc ghi bang so.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "GIA TIEN", "Hay nhap gia tien nhan duoc khi ban nha.", "Xac nhan", "Huy");
						return 1;
					}
					if(price < 100000 || price > 500000000)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Gia tien phai cao hon $100,000 va thap hon $500,000,000.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "GIA TIEN", "Hay nhap gia tien nhan duoc khi ban nha.", "Xac nhan", "Huy");
						return 1;
					}
					if(price == HouseInfo[houseid][ListingPrice])
					{
						format(string, sizeof(string), "Gia niem yet cua ban da duoc dat thanh $%s.", number_format(price));
						SendClientMessageEx(playerid, COLOR_GREY, string);
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEPRICE, DIALOG_STYLE_INPUT, "GIA TIEN", "Hay nhap gia tien nhan duoc khi ban nha.", "Xac nhan", "Huy");
						return 1;
					}
					HouseInfo[houseid][ListingPrice] = price;
					SaveHouse(houseid);
					SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cap nhat gia tien thanh cong.");
					ShowMainListingDialog(playerid);
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEDESCRIPTION:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam su dung QUANG CAO.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai co it nhat $500,000 de dat yeu cau rao ban nha.");
					new houseid;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay da co trong danh sach rao ban.");
					if(strlen(inputtext) < 1 || strlen(inputtext) > 128)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Noi dung phai it nhat 1 ky tu va nhieu nhat 128 ky tu.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDESCRIPTION, DIALOG_STYLE_INPUT, "MO TA NGOI NHA", "Ghi mo ta ve ngoi nha vao phia duoi (Khong bat buoc).", "Xac nhan", "Huy");
						return 1;
					}
					if(strcmp(inputtext, HouseInfo[houseid][ListingDescription], false) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The description you have specified is already set the set description.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDESCRIPTION, DIALOG_STYLE_INPUT, "MO TA NGOI NHA", "Ghi mo ta ve ngoi nha vao phia duoi (Khong bat buoc).", "Xac nhan", "Huy");
						return 1;
					}
					for(new i = 0; i < strlen(inputtext) - 7; i ++)
					{
						if(inputtext[i] == '{' && inputtext[i + 7] == '}')
						{
							strmid(string, inputtext, i + 1, i + 7);
							if(ishex(string))
							{
								strdel(inputtext, i, i + 8);
								continue;
							}
						}
					}
					strcpy(HouseInfo[houseid][ListingDescription], inputtext, 128);
					SaveHouse(houseid);
					SendClientMessageEx(playerid, COLOR_WHITE, "Ban da cap nhat mo ta ngoi nha thanh cong.");
					ShowMainListingDialog(playerid);
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEDOORS:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam su dung QUANG CAO.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai co it nhat $500,000 de dat yeu cau rao ban nha.");
					new houseid, doorid;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay da co trong danh sach rao ban.");
					if(sscanf(inputtext, "d", doorid))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "ID Door ban phai nhap bang so.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
						return 1;
					}
					if(doorid < 0 || doorid >= MAX_DDOORS)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "ID Door khong hop le.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
						return 1;
					}
					for(new i = 0; i < 5; i ++)
					{
						if(HouseInfo[houseid][LinkedDoor][i] == doorid && doorid != 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "The specified dynamic door is already linked to your listing.");
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
							return 1;
						}
					}
					switch(doorid)
					{
						case 0:
						{
							if(HouseInfo[houseid][LinkedDoor][HouseMarketTracking[playerid]] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not currently have a linked dynamic door in the specified slot.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedDoor][HouseMarketTracking[playerid]] = 0;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "Ban da cap nhat/loai bo door dynamic thanh cong.");
							ShowMainListingDialog(playerid);
							return 1;
						}
						default:
						{
							if(DDoorsInfo[doorid][ddOwner] != GetPlayerSQLId(playerid))
							{
								SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Door nay.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							if(HouseInfo[houseid][hIntIW] != DDoorsInfo[doorid][ddInteriorInt] || HouseInfo[houseid][hIntVW] != DDoorsInfo[doorid][ddInteriorVW])
							{
								SendClientMessageEx(playerid, COLOR_GREY, "The specified dynamic door is not linked to your house.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEDOORS, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a door to link it to your listing. Input \"0\" to remove a dynamic door.", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedDoor][HouseMarketTracking[playerid]] = doorid;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You have updated the dynamic door(s) linked to your listing.");
							ShowMainListingDialog(playerid);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSEGARAGES:
		{
			switch(response)
			{
				case false: return ShowMainListingDialog(playerid);
				case true:
				{
					if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
					if(PlayerInfo[playerid][pADMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from advertisements.");
					if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while injured.");
					if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings right now.");
					if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use house listings while in jail.");
					if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to access house listings.");
					if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GREY, "You must have at least $500,000 to place a house listing.");
					new houseid, garageid;
					houseid = GetNearestOwnedHouse(playerid);
					if(houseid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan can nha ban dang so huu.");
					if(HouseInfo[houseid][Listed] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This house is already listed on the house market.");
					if(sscanf(inputtext, "d", garageid))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "The specified garage ID must be numerical.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
						return 1;
					}
					if(garageid < 0 || garageid >= MAX_GARAGES)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Invalid garage ID specified.");
						ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
						return 1;
					}
					for(new i = 0; i < 2; i ++)
					{
						if(HouseInfo[houseid][LinkedGarage][i] == garageid && garageid != 0)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "The specified garage is already linked to your listing.");
							ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
							return 1;
						}
					}
					switch(garageid)
					{
						case 0:
						{
							if(HouseInfo[houseid][LinkedGarage][HouseMarketTracking[playerid]] == 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not currently have a linked garage in the specified slot.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedGarage][HouseMarketTracking[playerid]] = 0;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You have updated/removed the gate(s) linked to your listing.");
							ShowMainListingDialog(playerid);
							return 1;
						}
						default:
						{
							if(DDoorsInfo[garageid][ddOwner] != GetPlayerSQLId(playerid))
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You do not own the specified garage.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSEGARAGES, DIALOG_STYLE_INPUT, "House Listings", "Input the ID of a garage to link it to your listing. Input \"0\" to remove a garage..", "Okay", "Cancel");
								return 1;
							}
							HouseInfo[houseid][LinkedGarage][HouseMarketTracking[playerid]] = garageid;
							SaveHouse(houseid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You have updated the garage(s) linked to your listing.");
							ShowMainListingDialog(playerid);
							return 1;
						}
					}
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTHOUSELISTINGS:
		{
			if(response)
			{
				if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
				if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
				if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
				if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
				if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
				szMiscArray[0] = 0;
				new houseid, position[2], count[4], location[MAX_ZONE_NAME];
				if(strcmp(inputtext, "[Trang ke...]", true) == 0)
				{
					for(new i = AdTracking[playerid] + 1; i < sizeof(HouseInfo); i ++)
					{
						if(HouseInfo[i][hOwned] == 1 && HouseInfo[i][Listed] == 1 && HouseInfo[i][PendingApproval] == 0)
						{
							location = "San Andreas";
							for(new l = 1; l < sizeof(count); l ++) count[l] = 0;
							for(new l = 0; l < 5; l ++) 
							{
								if(l < 2) if(HouseInfo[i][LinkedGarage][l] != 0) count[3] ++;
								if(HouseInfo[i][LinkedDoor][l] != 0) count[1] ++;
							}
							for(new l = 0; l < sizeof(GateInfo); l ++) if(GateInfo[l][gHID] == i) count[2] ++;
							Get3DZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], location, sizeof(location));
							format(szMiscArray, sizeof(szMiscArray), "%s\n(HOUSE ID: %d) [GIA: $%s] [VI TRI: %s] [%d DD(s)] [%d DG(s)] [%d G(s)]", szMiscArray, i, number_format(HouseInfo[i][ListingPrice]), location, count[1], count[2], count[3]);
							AdTracking[playerid] = i;
							count[0] ++;
						}
						if(count[0] == MAX_LISTINGS_PER_PAGE) break;
					}
					if(count[0] == 0) return SendClientMessage(playerid, COLOR_GREY, "Hien tai khong co nha nao dang duoc rao ban.");
					if(count[0] == MAX_LISTINGS_PER_PAGE && AdditionalAdvertisements(AdTracking[playerid] + 1)) strcat(szMiscArray, "\n[Trang ke...]");
					ShowPlayerDialogEx(playerid, DIALOG_LISTHOUSELISTINGS, DIALOG_STYLE_LIST, "Danh sach nha dang rao ban", szMiscArray, "Xac nhan", "Huy");
					return 1;
				}
				position[0] = strfind(inputtext, "(");
				position[1] = strfind(inputtext, ")");
				strmid(string, inputtext, position[0] + 1, position[1]);
				houseid = strval(string);
				if(HouseInfo[houseid][hOwned] == 0 || HouseInfo[houseid][Listed] == 0 || HouseInfo[houseid][PendingApproval] == 1)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay hien khong ban.");
					callcmd::houselistings(playerid, "");
					return 1;
				}
				HouseMarketTracking[playerid] = houseid;
				ShowListingInformation(playerid, houseid, DIALOG_SELECTEDLISTING);
				return 1;
			}
		}
		case DIALOG_SELECTEDLISTING:
		{
			if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
			if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
			if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
			if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
			if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
			switch(response)
			{
				case false: return callcmd::houselistings(playerid, "");
				case true: 
				{
					if(HouseInfo[HouseMarketTracking[playerid]][hOwned] == 0 || HouseInfo[HouseMarketTracking[playerid]][Listed] == 0 || HouseInfo[HouseMarketTracking[playerid]][PendingApproval] == 1)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay hien khong ban.");
						callcmd::houselistings(playerid, "");
						return 1;
					}
					ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "Lua chon", "Xem nha\nMua nha", "Xac nhan", "Huy");
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_LISTINGOPTIONS:
		{
			if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap vao game.");
			if(GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi thuong.");
			if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang bi cong tay.");
			if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay khi dang o tu.");
			if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dat lvl.3+ de thuc hien lenh nay.");
			if(HouseInfo[HouseMarketTracking[playerid]][hOwned] == 0 || HouseInfo[HouseMarketTracking[playerid]][Listed] == 0 || HouseInfo[HouseMarketTracking[playerid]][PendingApproval] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay hien khong ban.");
				callcmd::houselistings(playerid, "");
				return 1;
			}
			switch(response)
			{
				case false: return ShowListingInformation(playerid, HouseMarketTracking[playerid], DIALOG_SELECTEDLISTING);
				case true:
				{
					switch(listitem)
					{
						case 0:
						{
							if(GetPlayerSQLId(playerid) == HouseInfo[HouseMarketTracking[playerid]][hOwnerID])
							{
								SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay la cua ban, hay su dung lenh (/home).");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "Lua chon", "Xem nha\nMua nha", "Xac nhan", "Huy");
								return 1;
							}
							if(HouseInfo[HouseMarketTracking[playerid]][hExtIW] != 0 || HouseInfo[HouseMarketTracking[playerid]][hExtVW] != 0)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "Dia diem nha khong xac dinh, hay lien he chu so huu ngoi nha nay.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "Lua chon", "Xem nha\nMua nha", "Xac nhan", "Huy");
								return 1;
							}
							DisablePlayerCheckpoint(playerid);
							SetPlayerCheckpoint(playerid, HouseInfo[HouseMarketTracking[playerid]][hExteriorX], HouseInfo[HouseMarketTracking[playerid]][hExteriorY], HouseInfo[HouseMarketTracking[playerid]][hExteriorZ], 4.0);
							gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOME;
							hInviteHouse[playerid] = HouseMarketTracking[playerid];
							SendClientMessageEx(playerid, COLOR_WHITE, "Dia diem ngoi nha da duoc danh dau tren ban do.");
							return 1;
						}
						case 1:
						{
							if(GetPlayerSQLId(playerid) == HouseInfo[HouseMarketTracking[playerid]][hOwnerID])
							{
								SendClientMessageEx(playerid, COLOR_GREY, "Ngoi nha nay la cua ban, ban khong the mua.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "Lua chon", "Xem nha\nMua nha", "Xac nhan", "Huy");
								return 1;
							}
							if(Homes[playerid] >= MAX_OWNABLE_HOUSES)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the so huu them ngoi nha nao nua.");
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "Lua chon", "Xem nha\nMua nha", "Xac nhan", "Huy");
								return 1;
							}
							if(GetPlayerCash(playerid) < HouseInfo[HouseMarketTracking[playerid]][ListingPrice])
							{
								format(string, sizeof(string), "Ban can co $%s de mua ngoi nha nay.", number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
								SendClientMessageEx(playerid, COLOR_GREY, string);
								ShowPlayerDialogEx(playerid, DIALOG_LISTINGOPTIONS, DIALOG_STYLE_LIST, "Lua chon", "Xem nha\nMua nha", "Xac nhan", "Huy");
								return 1;
							}
							new name[24], bool:online;
							foreach(new i: Player) 
							{
								if(gPlayerLogged{i} == 1 && HouseInfo[HouseMarketTracking[playerid]][hOwnerID] == GetPlayerSQLId(i))
								{
									GivePlayerCashEx(i, TYPE_BANK, HouseInfo[HouseMarketTracking[playerid]][ListingPrice]);
									format(string, sizeof(string), "%s da mua nha cua ban (House ID: %d) voi gia $%s.", GetPlayerNameEx(playerid), HouseMarketTracking[playerid], number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
									SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
									online = true;
									break;
								}
							}
							if(online == false)
							{
								szMiscArray[0] = 0;
								mysql_escape_string(HouseInfo[HouseMarketTracking[playerid]][hOwnerName], name);
								mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `Bank`=`Bank`+%d WHERE `Username`='%s'", HouseInfo[HouseMarketTracking[playerid]][ListingPrice], name);
								mysql_tquery(MainPipeline, szMiscArray, "", "i", playerid);
								format(string, sizeof(string), "I purchased your house (ID: %d) for $%s.", HouseMarketTracking[playerid], number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
								mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `letters` (`Sender_Id`, `Receiver_Id`, `Date`, `Message`, `Delivery_Min`, `Notify`) VALUES (%d, %d, NOW(), '%e', 0, 1)", GetPlayerSQLId(playerid), HouseInfo[HouseMarketTracking[playerid]][hOwnerID], string);
								mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								
							}
							format(string, sizeof(string), "Ban da mua nha House ID %d thanh cong voi gia $%s.", HouseMarketTracking[playerid], number_format(HouseInfo[HouseMarketTracking[playerid]][ListingPrice]));
							SendClientMessageEx(playerid, COLOR_GREEN, string);
							Homes[playerid] ++;
							GivePlayerCashEx(playerid, TYPE_ONHAND, -HouseInfo[HouseMarketTracking[playerid]][ListingPrice]);
							for(new i = 0; i < 5; i ++)
							{
								if(i < 2)
								{
									if(HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i] != 0 && HouseInfo[HouseMarketTracking[playerid]][hOwnerID] == GarageInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]][gar_Owner])
									{
										strcpy(GarageInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]][gar_OwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
										GarageInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]][gar_Owner] = GetPlayerSQLId(playerid);
										CreateGarage(HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]);
										SaveGarage(HouseInfo[HouseMarketTracking[playerid]][LinkedGarage][i]);
									}
								}
								if(HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i] != 0 && HouseInfo[HouseMarketTracking[playerid]][hOwnerID] == DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddOwner])
								{
									strcpy(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
									DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddOwner] = GetPlayerSQLId(playerid);
									DestroyDynamicPickup(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddPickupID]);
									if(IsValidDynamic3DTextLabel(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]][ddTextID]);
									CreateDynamicDoor(HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]);
									SaveDynamicDoor(HouseInfo[HouseMarketTracking[playerid]][LinkedDoor][i]);
								}
							}
							if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey] = HouseMarketTracking[playerid];
							else PlayerInfo[playerid][pPhousekey2] = HouseMarketTracking[playerid];
							HouseInfo[HouseMarketTracking[playerid]][hOwnerID] = GetPlayerSQLId(playerid);
							strcpy(HouseInfo[HouseMarketTracking[playerid]][hOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
							ReloadHouseText(HouseMarketTracking[playerid]);
							ClearHouseSaleVariables(HouseMarketTracking[playerid]);
							return 1;
						}
					}
				}
			}
			return 1;
		}
	}
	return 0;
}
