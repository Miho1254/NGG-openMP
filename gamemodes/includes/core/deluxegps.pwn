/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				GTA.Network, LLC
	(created by GTA.Network Development Team)

	Developers:
		(***) Austin
		(***) Connor
		(***) Jingles

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

#define		DIALOG_GPS_ONE				9800
#define		DIALOG_GPS_TWO				9801
#define		DIALOG_GPS_GEN				9802
#define		DIALOG_GPS_THREE			9984
#define		DIALOG_GPS_BCATS			9986
#define		DIALOG_GPS_BSELECT			9987
#define		DIALOG_GPS_BIZCONF			9988
#define		DIALOG_GPS_FAVS				9809
#define		DIALOG_GPS_SETFAV			9808
#define		DIALOG_GPS_SETFAVNAME		9708

#define 	DIALOG_MAP_BUSINESSES 		9709
#define 	DIALOG_MAP_BUSINESSES2 		9710
#define 	DIALOG_MAP_JOBS				9711

#define 	CHECKPOINT_GEN_LOCATION 	4500
#define 	CHECKPOINT_BUSINESS 		4501
#define 	CHECKPOINT_JOB 				4502
#define 	CHECKPOINT_DOOR				4503
#define 	CHECKPOINT_HOUSE			4504

#define		MAX_GPSFAV					(5)

/*
enum gpsFavs
{
	FavName[128],
	Float:FavPos[3]
}
new GPSFav[MAX_PLAYERS][MAX_GPSFAV][gpsFavs];
*/

new Float:gpsZones[][4] = {
	{-1605.2828,721.5994,11.9206,177.5852}, // SAPD (SF)
	{1542.4990,-1675.5034,13.5546,271.4706}, // SAPD (LS)
	{-2685.5671,628.9943,14.4545,359.4150}, // FDSA (SF)
	{1189.6350,-1324.4755,13.5670,90.5575}, // FDSA (LS)
	{725.8740,-1389.6359,13.6792,3.0747}, // SANews
	{-1991.4381,137.7790,27.5391,272.1380}, // Taxi Company SF
	{1816.9723,-1890.5344,13.4178,91.9728}, // Taxi Company LS
	{636.3160,-571.7883,16.3359,270.5647}, // SASD
	{1265.1078,-2050.7852,59.3019,84.8860}, // Government // Dialog 1 END -- (9)
	{-1581.3046,910.2631,7.6953,181.8651}, // Bank Downtown
	{1456.9108,-1028.2728,23.8281,2.1988}, // Bank Mullholand
	{588.4825,-1236.6666,17.8415,203.1859}, // Bank Rodeo
	{2299.6001,-16.0722,26.4844,269.7224}, // Bank Palomino Creek
	{648.7963,-524.6929,16.3359,0.4097}, // Bank Dillimore -- Dialog 2 End -- (5)
	{-2432.1289,494.6811,29.9240,26.3876}, // SF VIP
	{1817.9268,-1576.2262,13.5469,85.9855}, // LS VIP
	{1022.9951,-1134.2111,23.8281,1.6635}, // Famed Lounge -- Dialog 3 End -- (3)
	{-2685.5671,628.9943,14.4545,359.4150}, // Santa Flora Hospital
	{1993.6011,-1454.2915,13.5547,311.0426}, // County Hospital
	{1189.6350,-1324.4755,13.5670,90.5575}, // All Saints -- Dialog 4 End -- (3)
	{-2754.8542,375.8127,4.3341,92.9305}, // City Hall (SF)
	{1481.6110,-1737.8517,13.5469,0.3324}, // City Hall (LS)
	{844.609375,-576.782287,16.521030,0.4097}, // DMV Dillimore
	{2022.5978,-1266.4010,23.9779,358.9305}, // Chung cu Glen Park
	{385.3801,-2058.6086,7.8359,179.2644}, // Cau ca 1
	{836.7430,-2002.4119,12.8672,179.4972}, // Cau ca 2
 	{1128.9141,-1411.1869,13.6130,2.1723},// Market
 	{-1830.8905,-176.5405,9.3984,269.6470} ,// Vat lieu Doherty (SF) 
 	{2407.9810,-2012.0629,13.5469,270.4795},// Vat lieu Market (LS)
 	{1421.3479,-1328.8800,13.5648,356.0145}, // Vat lieu Ocean Docks (LS) 
 	{-1636.6312,1201.3365,7.2021,73.9180} // Shop xe Downtown (SF) -- Dialog 5 End -- (10)
};

new gpsZoneName[31][] = {
	"SAPD (SF)",
	"SAPD (LS)",
	"FDSA (SF)",
	"FDSA (LS)",
	"SANews (LS)",
	"Taxi Company (SF)",
	"Taxi Company (LS)",
	"SASD (Dillimore)",
	"Government (LS)",
	"Bank Downtown (SF)",
	"Bank Mullholand (LS)",
	"Bank Rodeo (LS)",
	"Bank Palomino Creek",
	"Bank Dillimore",
	"SF VIP",
	"LS VIP",
	"Famed Lounge",
	"Santa Flora Hospital (SF)",
	"County General Hospital (LS)",
	"All Saints Hospital (LS)",
	"City Hall (SF)",
	"City Hall (LS)",
	"DMV (Dillimore)",
	"Chung cu Glen Park (LS)",
	"Khu cau ca 1 (LS)",
	"Khu cau ca 2 (LS)",
	"Market (LS)",
	"Vat lieu Doherty (SF)",
	"Vat lieu Market (LS)",
	"Vat lieu Ocean Docks (LS)",
	"Shop xe Downtown (SF)"
};

GetEntity3DZone(entityID, type, zone[], len, Float:x2 = 0.0, Float:y2 = 0.0, Float:z2 = 0.0) //Credits to Cueball, Betamaster, Mabako, and Simon.
{
	new Float:x, Float:y, Float:z;
	switch(type) {
		case 0: {
			x = Businesses[entityID][bExtPos][0];
			y = Businesses[entityID][bExtPos][1];
			z = Businesses[entityID][bExtPos][2];
		}
		case 1: {
			x = HouseInfo[entityID][hExteriorX];
			y = HouseInfo[entityID][hExteriorY];
			z = HouseInfo[entityID][hExteriorZ];
		}
		case 2: {
			x = DDoorsInfo[entityID][ddExteriorX];
			y = DDoorsInfo[entityID][ddExteriorY];
			z = DDoorsInfo[entityID][ddExteriorZ];
		}
		case 3: {
			x = x2;
			y = y2;
			z = z2;
		}
	}

	for(new i = 0; i != sizeof(gSAZones); i++) {
		if(x >= gSAZones[i][SAZONE_AREA][0]
				&& x <= gSAZones[i][SAZONE_AREA][3]
				&& y >= gSAZones[i][SAZONE_AREA][1]
				&& y <= gSAZones[i][SAZONE_AREA][4]
				&& z >= gSAZones[i][SAZONE_AREA][2]
				&& z <= gSAZones[i][SAZONE_AREA][5]) {
			return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

/*
CMD:gpsfaves(playerid,params[])
{
	new string[128];
	for(new i = 0; i < MAX_GPSFAV; i++)
	{
		format(string,sizeof(string), "%s\n%s", string, GPSFav[playerid][i][FavName]);
	}
	ShowPlayerDialogEx(playerid, DIALOG_GPS_SETFAV, DIALOG_STYLE_LIST, "Delux GPS - Save Favorite", string, "Save Favorite", "Cancel");
	return 1;
}
*/

CMD:map(playerid, params[]) {

	Phone_Map(playerid);
	return 1;
}

CMD:mygps(playerid, params[]) {
	if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa muc tieu truoc khi thuc hien danh dau khac (/xoamuctieu).");
	ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "Tim dia diem | Menu", "Cua hang\n\
		Cong viec\n\
		Dia diem tap trung\n\
		Dia chi Cua hang \n\
		Dia chi House\n\
		Dia chi Door\n", "Tiep tuc", "Huy");
	
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	switch(gPlayerCheckpointStatus[playerid])
	{
		case CHECKPOINT_GEN_LOCATION:
		{
			GetPVarString(playerid, "gpsName", szMiscArray, sizeof(szMiscArray));
			format(szMiscArray, sizeof(szMiscArray),"Ban da den {33CCFF}%s{FFFFFF}.", szMiscArray);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DeletePVar(playerid,"gpsName");
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		case CHECKPOINT_BUSINESS:
		{
			new id = GetPVarInt(playerid,"gpsBiz");
			format(szMiscArray, sizeof(szMiscArray), "Ban da den {33CCFF}%s{FFFFFF}.", Businesses[id][bName]);
			SendClientMessageEx(playerid,COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		case CHECKPOINT_JOB:
		{
			new id = GetPVarInt(playerid,"gpsJob");
			format(szMiscArray, sizeof(szMiscArray), "Ban da den {33CCFF}%s{FFFFFF}.", GetJobName(JobData[id][jType]));
			SendClientMessageEx(playerid,COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}

		case CHECKPOINT_HOUSE:
		{
			new id = GetPVarInt(playerid,"gpsHouse");
			format(szMiscArray, sizeof(szMiscArray), "Ban da den house #{33CCFF}%i{FFFFFF}.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		case CHECKPOINT_DOOR:
		{
			new id = GetPVarInt(playerid,"gpsDoor");
			format(szMiscArray, sizeof(szMiscArray), "Ban da den door #%i ({33CCFF}%s{FFFFFF}).", id,DDoorsInfo[id][ddDescription]);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
		}
		/*
		case CHECKPOINT_FAVORITES:
		{
			new id = GetPVarInt(playerid, "gpsFav");
			DeletePVar(playerid, "gpsFav");
			format(szMiscArray, sizeof(szMiscArray), "Ban da den {33CCFF}%s{FFFFFF}.", GPSFav[playerid][id][FavName]);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			DisablePlayerCheckpoint(playerid);
		}
		*/
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_MAP_BUSINESSES:	{

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "Tim dia diem | Menu", "Cua hang\n\
					Cong viec\n\
					Dia diem tap chung\n\
					Dia chi Cua hang\n\
					Dia chi House\n\
					Dia chi Door\n", "Tiep tuc", "Huy");
			}

			Map_ShowBusinesses(playerid, listitem);
			return 1;
		}
		case DIALOG_MAP_BUSINESSES2: {

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_MAP_BUSINESSES, DIALOG_STYLE_LIST, "San Andreas | Map | Businesses", "\
						24/7\n\
						Cua hang quan ao\n\
						Nha hang\n\
						Bars\n\
						Cua hang vu khi\n\
						Tram xang\n\
						Cua hang ban xe\n\
						Clubs", "Tiep tuc", "Tro ve");
			}
			else {

				new id = ListItemTrackId[playerid][listitem];

				GetEntity3DZone(id, 0, szMiscArray, sizeof(szMiscArray));
				format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi {33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", Businesses[id][bName], szMiscArray);
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_BUSINESS;
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, Businesses[id][bExtPos][0], Businesses[id][bExtPos][1], Businesses[id][bExtPos][2], 15.0);
			}
			return 1;
		}
		case DIALOG_MAP_JOBS: if(response) return Map_ShowJobs(playerid, inputtext);
		case DIALOG_GPS_ONE: {

			if(!response) return 1;

			switch(listitem) {

				case 0:
				{
					if(!response) return 1;
					ShowPlayerDialogEx(playerid, DIALOG_MAP_BUSINESSES, DIALOG_STYLE_LIST, "San Andreas | Map | Businesses", "\
						24/7\n\
						Cua hang quan ao\n\
						Nha hang\n\
						Bars\n\
						Cua hang vu khi\n\
						Tram xang\n\
						Cua hang ban xe\n\
						Clubs", "Tiep tuc", "Tro ve");
				}
				case 1:
				{	
					new zone[MAX_ZONE_NAME];
					
					for(new i; i < MAX_JOBPOINTS; ++i)
					{
						if(JobData[i][jPos][0] == 0.0 || JobData[i][jPos][0] == 0) continue;
						Get3DZone(JobData[i][jPos][0], JobData[i][jPos][1], JobData[i][jPos][2], zone, sizeof(zone));
						format(szMiscArray, sizeof(szMiscArray), "%s%s (%s)\n", szMiscArray, JobName[ JobData[i][jType] ],zone);
					}
					return ShowPlayerDialogEx(playerid, DIALOG_MAP_JOBS, DIALOG_STYLE_LIST, "Dia diem cong viec", szMiscArray, "Chon", "Tro ve");
				}
				case 2: {
					SetPVarInt(playerid, "gpsUsingID", 0);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_LIST, "Dia diem tap chung", "Tru so to chuc\nNgan hang\nKhu vuc VIP\nBenh vien\nDia diem khac\nDang cap nhat...", "Xac nhan", "Huy");
				}
				case 3: {
					SetPVarInt(playerid, "gpsUsingID", 1);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim cua hang", "Hay nhap ID cua hang", "Xac nhan", "Huy");
				}
				case 4: {
					SetPVarInt(playerid, "gpsUsingID", 2);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim House", "Hay nhap ID House", "Xac nhan", "Huy");
				}
				case 5: {
					SetPVarInt(playerid, "gpsUsingID", 3);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim Door", "Hay nhap ID House", "Xac nhan", "Huy");
				}
			}
		}
		case DIALOG_GPS_TWO: {

			if(!response) return 1;
			
			switch(GetPVarInt(playerid, "gpsUsingID")) {
				
				case 0: {

					SetPVarInt(playerid, "gpsUsingID", listitem);
					switch(listitem) {
						case 0: {
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Tru so canh sat", "SAPD (SF)\nSAPD (LS)\nFDSA (SF)\nFDSA (LS)\nSANews (LS)\nTaxi Company (SF)\nTaxi Company (LS)\nSASD (Dillimore)\nGovernment", "Xac nhan", "Huy");
						}
						case 1: {
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Ngan hang", "Bank Downtown (SF)\nBank Mullholand (LS)\nBank Rodeo (LS)\nBank Palomino Creek\nBank Dillimore", "Xac nhan", "Huy");
						}
						case 2:	{
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Khu vuc VIP", "SF VIP\nLS VIP\nFamed Lounge", "Xac nhan", "Huy");
						}
						case 3:	{
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Benh vien", "Santa Flora Hospital (SF)\nCounty General Hospital (LS)\nAll Saints Hospital (LS)", "Xac nhan", "Huy");
						}
						case 4: 
						{
							ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "Dia diem khac","City Hall (SF)\nCity Hall (LS)\nDMV (Dillimore)\nChung cu Glen Park (LS)\nKhu cau ca 1 (LS)\nKhu cau ca 2 (LS)\nMarket (LS)\nVat lieu Doherty (SF)\nVat lieu Market (LS)\nVat lieu Ocean Docks (LS)\nShop xe Downtown (SF)", "Xac nhan", "Huy");
						}
					}
				}
				case 1: {

					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if(inputtext[i] > '9' || inputtext[i] < '0') {
							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the business.");
							return 1;
						}
					}

					new id = strval(inputtext);

					if(!IsValidBusinessID(id)) {

						SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang nay khong ton tai.");
						return 1;
					}

					GetEntity3DZone(id, 0, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Ban co muon dat danh dau den dia diem:\n\n\
					{33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}?", Businesses[id][bName], szMiscArray);
					
					SetPVarInt(playerid, "gpsUsingID", 1);
					SetPVarInt(playerid,"gpsBiz", id);
					
					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Tim dia diem", szMiscArray, "Co", "Khong");
				}
				case 2:
				{
					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if (inputtext[i] > '9' || inputtext[i] < '0')
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Ban phai nhap gia tri so, (ID House).");
							return 1;
						}
					}

					new id = strval(inputtext);

					SetPVarInt(playerid, "gpsHouse", id);

					if(HouseInfo[id][hOwned] == 0)
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Ngoi nha nay hien khong co nguoi so huu.");
						return 1;
					}
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					SetPVarInt(playerid, "gpsUsingID", 2);
					format(szMiscArray,sizeof(szMiscArray),"{FFFFFF}Ban co muon dat danh dau den dia diem:\n\n\
					house {33CCFF}#%i{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}?", id, szMiscArray);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Tim dia diem", szMiscArray, "Co", "Khong");
 				}
				case 3:
				{
					for (new i = 0, j = strlen(inputtext); i < j; i++) {

						if (inputtext[i] > '9' || inputtext[i] < '0') {

							SendClientMessageEx(playerid, COLOR_WHITE, "You must input a numerical value. In this case, the ID of the door.");
							return 1;
						}
					}

					new id = strval(inputtext);
					if (id < 0 || id > MAX_DDOORS) return SendClientMessageEx(playerid, -1, "ID %d khong hop le", id);
					SetPVarInt(playerid, "gpsDoor", id);
					if(DDoorsInfo[id][ddDescription] == 0)
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Ngoi nha nay hien khong co nguoi so huu.");
						return 1;
					}

			     	GetEntity3DZone(id, 2, szMiscArray, sizeof(szMiscArray));
					SetPVarInt(playerid, "gpsUsingID", 3);
					format(szMiscArray,sizeof(szMiscArray),"{FFFFFF}Ban co muon dat danh dau den dia diem:\n\n\
					Door #%i ({33CCFF}%s{FFFFFF}) o khu vuc {FF0000}%s{FFFFFF}?", id, DDoorsInfo[id][ddDescription], szMiscArray);

					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Tim dia diem", szMiscArray, "Co", "Khong");
				}
			}
		}
		case DIALOG_GPS_GEN: {
			if(!response) return 1;
			new gpsItemStart;
			switch(GetPVarInt(playerid, "gpsUsingID")) {

				case 0: gpsItemStart = 0;
				case 1:	gpsItemStart = 9;
				case 2: gpsItemStart = 14;
				case 3: gpsItemStart = 17;
				case 4: gpsItemStart = 20;
				case 5: gpsItemStart = 31;
			}
			GetEntity3DZone(0, 3, szMiscArray, sizeof(szMiscArray), gpsZones[gpsItemStart + listitem][0], gpsZones[gpsItemStart + listitem][1], gpsZones[gpsItemStart + listitem][2]);
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, gpsZones[gpsItemStart + listitem][0], gpsZones[gpsItemStart + listitem][1], gpsZones[gpsItemStart + listitem][2] , 15.0);
			format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi {33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", gpsZoneName[gpsItemStart + listitem], szMiscArray);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			SetPVarString(playerid, "gpsName", gpsZoneName[gpsItemStart + listitem]);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_GEN_LOCATION;
		}
		case DIALOG_GPS_THREE:{

			if(!response) return 1;

			switch(GetPVarInt(playerid,"gpsUsingID"))
			{
				case 1:
				{
					new id = GetPVarInt(playerid,"gpsBiz");
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi {33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", Businesses[id][bName], szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_BUSINESS;
					DisablePlayerCheckpoint(playerid);		
					SetPlayerCheckpoint(playerid, Businesses[id][bExtPos][0], Businesses[id][bExtPos][1], Businesses[id][bExtPos][2], 15.0);
				}
				case 2:
				{
					new id = GetPVarInt(playerid,"gpsHouse");
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi house #{33CCFF}%i{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", id, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOUSE;
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, HouseInfo[id][hExteriorX], HouseInfo[id][hExteriorY], HouseInfo[id][hExteriorZ], 15.0);
				}
				case 3:
				{
					new id = GetPVarInt(playerid,"gpsDoor");
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi door #%i ({33CCFF}%s{FFFFFF}) o khu vuc {FF0000}%s{FFFFFF}.", id, DDoorsInfo[id][ddDescription],  szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_DOOR;
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, DDoorsInfo[id][ddExteriorX], DDoorsInfo[id][ddExteriorY], DDoorsInfo[id][ddExteriorZ], 15.0);
				}
			}
		}
		/*
		case DIALOG_GPS_FAVS:
		{
			if(!response) return 1;
			if(!strcmp(inputtext, "None", true)) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co a favorite stored in that slot.");
			GetEntity3DZone(listitem, 3, szMiscArray, sizeof(szMiscArray), GPSFav[playerid][listitem][FavPos][0], GPSFav[playerid][listitem][FavPos][1], GPSFav[playerid][listitem][FavPos][2]);
			format(szMiscArray, sizeof(szMiscArray), "GPS da danh dau duong di toi {33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", GPSFav[playerid][listitem][FavName], szMiscArray);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAVORITES;
			SetPVarInt(playerid, "gpsFav", listitem);
			SetPlayerCheckpoint(playerid, GPSFav[playerid][listitem][FavPos][0],GPSFav[playerid][listitem][FavPos][1],GPSFav[playerid][listitem][FavPos][2], 15.0);
		}
		case DIALOG_GPS_SETFAV:
		{
			if(!response) return 1;
			SetPVarInt(playerid, "sFav", listitem);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_SETFAVNAME, DIALOG_STYLE_INPUT, "Enter Favorite Name", "Please enter a name for your favorite.\n\nIt will be saved in the slot you have selected.", "Submit", "Cancel"); 
		}
		case DIALOG_GPS_SETFAVNAME:
		{
			if(!response) return 1;
			new sFav = GetPVarInt(playerid, "sFav");
			strcpy(GPSFav[playerid][sFav][FavName], inputtext, 128);
			GetPlayerPos(playerid, GPSFav[playerid][sFav][FavPos][0],GPSFav[playerid][sFav][FavPos][1],GPSFav[playerid][sFav][FavPos][2]);
			SendClientMessage(playerid,COLOR_WHITE, "GPS Location Saved!");
			new szQuery[256];
			format(szQuery, sizeof(szQuery), "UPDATE `GPSFavs` SET `Fav%i` = '%s|%f|%f|%f' WHERE `SQLid` = %d", sFav+1, GPSFav[playerid][sFav][FavName], GPSFav[playerid][sFav][FavPos][0],GPSFav[playerid][sFav][FavPos][1],GPSFav[playerid][sFav][FavPos][2], GetPlayerSQLId(playerid)); 
			mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		}
		*/
	}
	return 0;
}


Map_ShowBusinesses(playerid, btype)
{
	szMiscArray[0] = 0;
	new szStatus[20],
		j;
	switch(btype)
	{
		case 0:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_STORE)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
		}
		case 1:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_CLOTHING)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
		}
		case 2:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_RESTAURANT)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co gi ca.");
		}
		case 3:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_BAR)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co gi ca.");
		}
		case 4:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_GUNSHOP)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co gi ca.");
		}
		case 5:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_GASSTATION)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;					
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co gi ca.");
		}
		case 6:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP)
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co gi ca.");
		}
		case 7:
		{
			for(new i; i < MAX_BUSINESSES; ++i)
			{
				if(Businesses[i][bType] == BUSINESS_TYPE_CLUB) 
				{
					switch(Businesses[i][bStatus])
					{
						case 0: szStatus = "{FF0000} DONG";
						case 1: szStatus = "{00FF00} MO";
					}
					format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, Businesses[i][bName], szStatus);
					ListItemTrackId[playerid][j++] = i;
				}
			}
			if(j == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Khong co gi ca.");
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_MAP_BUSINESSES2, DIALOG_STYLE_TABLIST, "Dia diem cua hang", szMiscArray, "Chon", "Tro ve");
	return 1;
}


Map_ShowJobs(playerid, iJobname[])
{
	new jobName[128], zone[MAX_ZONE_NAME];
	for(new i; i < MAX_JOBPOINTS; ++i)
	{
		if(JobData[i][jPos][0] == 0.0 || JobData[i][jPos][0] == 0) continue;
		Get3DZone(JobData[i][jPos][0], JobData[i][jPos][1], JobData[i][jPos][2], zone, sizeof(zone));
		format(jobName, sizeof(jobName), "%s (%s)", JobName[ JobData[i][jType] ],zone);
		if(!strcmp(iJobname, jobName, true)) {
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_JOB;
			SetPVarInt(playerid, "gpsJob", i);
			SetPlayerCheckpoint(playerid, JobData[ i ][jPos][0], JobData[ i ][jPos][1], JobData[ i ][jPos][2], 5.0);
			SendClientMessage(playerid, COLOR_YELLOW, "Mot diem danh dau mau do da duoc thiet lap tren minimap.");
			return 1;
		}
	}

	SendClientMessageEx(playerid, COLOR_GREY, "Loai cong viec khong hop le.");
	return 1;
}
