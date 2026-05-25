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

#define 	DIALOG_GPS_VECHAI_SUB		9713
#define 	DIALOG_GPS_FIND_ID			9714

#define 	CHECKPOINT_GEN_LOCATION 	4500
#define 	CHECKPOINT_BUSINESS 		4501
#define 	CHECKPOINT_JOB 				4502
#define 	CHECKPOINT_DOOR				4503
#define 	CHECKPOINT_HOUSE			4504

#define		MAX_GPSFAV					(5)

new szGPSMainMenu[] = "{33CCFF}1. {FFFF00}Dia diem Cong viec {FFFFFF}- Cac cong viec cong dong & Ve Chai\n{33CCFF}2. {FFFF00}Tru so / Faction {FFFFFF}- SAPD, FDSA, Taxi, Government...\n{33CCFF}3. {FFFF00}Ngan hang & Giao dich {FFFFFF}- Nap/Rut tien toan quoc\n{33CCFF}4. {FFFF00}Benh vien {FFFFFF}- Cap cuu va tri thuong\n{33CCFF}5. {FFFF00}Cua hang & Dich vu {FFFFFF}- Sieu thi, Tram xang, Weapon...\n{33CCFF}6. {FFFF00}Khu vuc VIP / Famed {FFFFFF}- Khu vuc dac quyen\n{33CCFF}7. {FFFF00}Khai thac & NPC Thuong nhan {FFFFFF}- Cau ca, Vat lieu, Ca...\n{33CCFF}8. {FFFF00}Dia diem Bat hop phap {FFFFFF}- Khu can sa va thu mua\n{33CCFF}9. {FFFF00}Tim dia chi theo ID {FFFFFF}- Dinh vi Store/House/Door";

new Float:gpsFactionZones[][3] = {
	{-1605.2828,721.5994,11.9206}, // SAPD (SF)
	{1542.4990,-1675.5034,13.5546}, // SAPD (LS)
	{-2685.5671,628.9943,14.4545}, // FDSA (SF)
	{1189.6350,-1324.4755,13.5670}, // FDSA (LS)
	{725.8740,-1389.6359,13.6792}, // SANews
	{-1991.4381,137.7790,27.5391}, // Taxi Company SF
	{1816.9723,-1890.5344,13.4178}, // Taxi Company LS
	{636.3160,-571.7883,16.3359}, // SASD
	{1265.1078,-2050.7852,59.3019} // Government
};
new gpsFactionNames[][32] = {
	"SAPD (SF)",
	"SAPD (LS)",
	"FDSA (SF)",
	"FDSA (LS)",
	"SANews (LS)",
	"Taxi Company (SF)",
	"Taxi Company (LS)",
	"SASD (Dillimore)",
	"Government (LS)"
};

new Float:gpsBankZones[][3] = {
	{-1581.3046,910.2631,7.6953}, // Bank Downtown
	{1456.9108,-1028.2728,23.8281}, // Bank Mullholand
	{588.4825,-1236.6666,17.8415}, // Bank Rodeo
	{2299.6001,-16.0722,26.4844}, // Bank Palomino Creek
	{648.7963,-524.6929,16.3359} // Bank Dillimore
};
new gpsBankNames[][32] = {
	"Bank Downtown (SF)",
	"Bank Mullholand (LS)",
	"Bank Rodeo (LS)",
	"Bank Palomino Creek",
	"Bank Dillimore"
};

new Float:gpsVIPZones[][3] = {
	{-2432.1289,494.6811,29.9240}, // SF VIP
	{1817.9268,-1576.2262,13.5469}, // LS VIP
	{1022.9951,-1134.2111,23.8281} // Famed Lounge
};
new gpsVIPNames[][32] = {
	"SF VIP",
	"LS VIP",
	"Famed Lounge"
};

new Float:gpsHospitalZones[][3] = {
	{-2685.5671,628.9943,14.4545}, // Santa Flora Hospital
	{1993.6011,-1454.2915,13.5547}, // County Hospital
	{1189.6350,-1324.4755,13.5670} // All Saints
};
new gpsHospitalNames[][32] = {
	"Santa Flora Hospital (SF)",
	"County General Hospital (LS)",
	"All Saints Hospital (LS)"
};

new Float:gpsMerchantZones[][3] = {
	{385.3801,-2058.6086,7.8359}, // Cau ca 1
	{836.7430,-2002.4119,12.8672}, // Cau ca 2
	{-1734.1169,1461.6493,7.1875}, // NPC thu mua ca (Shark Hung)
	{-1830.8905,-176.5405,9.3984}, // Vat lieu Doherty (SF) 
	{2407.9810,-2012.0629,13.5469}, // Vat lieu Market (LS)
	{1421.3479,-1328.8800,13.5648}, // Vat lieu Ocean Docks (LS) 
	{-2256.0278,1957.6537,-0.7859}, // Binh ca ca 1
	{-2442.3542,1697.4408,-0.7506}, // Binh ca ca 2
	{-1090.9705,601.9323,-0.5750},  // Binh ca ca 3
	{-1060.4594,126.4771,-0.6570},  // Binh ca ca 4
	{844.609375,-576.782287,16.521030}, // DMV Dillimore
	{-2754.8542,375.8127,4.3341}, // City Hall (SF)
	{1481.6110,-1737.8517,13.5469}, // City Hall (LS)
	{2022.5978,-1266.4010,23.9779}, // Chung cu Glen Park
	{1128.9141,-1411.1869,13.6130}, // Market
	{-1636.6312,1201.3365,7.2021} // Shop xe Downtown (SF)
};
new gpsMerchantNames[][32] = {
	"Khu cau ca 1 (LS)",
	"Khu cau ca 2 (LS)",
	"NPC thu mua ca (Shark Hung)",
	"Vat lieu Doherty (SF)",
	"Vat lieu Market (LS)",
	"Vat lieu Ocean Docks (LS)",
	"Binh ca ca 1 (SF)",
	"Binh ca ca 2 (SF)",
	"Binh ca ca 3 (SF)",
	"Binh ca ca 4 (SF)",
	"DMV (Dillimore)",
	"City Hall (SF)",
	"City Hall (LS)",
	"Chung cu Glen Park (LS)",
	"Market (LS)",
	"Shop xe Downtown (SF)"
};

new Float:gpsIllegalZones[][3] = {
	{-1105.5685,-1657.4761,76.3672}, // Khu che bien can sa
	{-1333.2675,-2161.7058,22.8201}, // Khu vuc can sa
	{-2204.5874,961.0796,80.0000} // NPC thu mua can sa
};
new gpsIllegalNames[][32] = {
	"Khu che bien can sa",
	"Khu vuc can sa",
	"NPC thu mua can sa"
};

stock ShowGPSCategoryDialog(playerid, category) {
	new str[2048];
	str[0] = 0;
	switch(category) {
		case 1: { // Factions
			for(new i = 0; i < sizeof(gpsFactionNames); i++) {
				format(str, sizeof(str), "%s{33CCFF}» {FFFFFF}%s\n", str, gpsFactionNames[i]);
			}
			SetPVarInt(playerid, "gpsUsingID", 1);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "{33CCFF}Tru so / Faction", str, "Xac nhan", "Tro ve");
		}
		case 2: { // Banks
			for(new i = 0; i < sizeof(gpsBankNames); i++) {
				format(str, sizeof(str), "%s{33CCFF}» {FFFFFF}%s\n", str, gpsBankNames[i]);
			}
			SetPVarInt(playerid, "gpsUsingID", 2);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "{33CCFF}Ngan hang & Giao dich", str, "Xac nhan", "Tro ve");
		}
		case 3: { // Hospitals
			for(new i = 0; i < sizeof(gpsHospitalNames); i++) {
				format(str, sizeof(str), "%s{33CCFF}» {FFFFFF}%s\n", str, gpsHospitalNames[i]);
			}
			SetPVarInt(playerid, "gpsUsingID", 3);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "{33CCFF}Benh vien", str, "Xac nhan", "Tro ve");
		}
		case 4: { // VIP
			for(new i = 0; i < sizeof(gpsVIPNames); i++) {
				format(str, sizeof(str), "%s{33CCFF}» {FFFFFF}%s\n", str, gpsVIPNames[i]);
			}
			SetPVarInt(playerid, "gpsUsingID", 4);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "{33CCFF}Khu vuc VIP / Famed", str, "Xac nhan", "Tro ve");
		}
		case 5: { // Merchants
			for(new i = 0; i < sizeof(gpsMerchantNames); i++) {
				format(str, sizeof(str), "%s{33CCFF}» {FFFFFF}%s\n", str, gpsMerchantNames[i]);
			}
			SetPVarInt(playerid, "gpsUsingID", 5);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "{33CCFF}Khai thac & NPC Thuong nhan", str, "Xac nhan", "Tro ve");
		}
		case 6: { // Illegal
			for(new i = 0; i < sizeof(gpsIllegalNames); i++) {
				format(str, sizeof(str), "%s{33CCFF}» {FFFFFF}%s\n", str, gpsIllegalNames[i]);
			}
			SetPVarInt(playerid, "gpsUsingID", 6);
			ShowPlayerDialogEx(playerid, DIALOG_GPS_GEN, DIALOG_STYLE_LIST, "{33CCFF}Dia diem Bat hop phap (Illegal)", str, "Xac nhan", "Tro ve");
		}
	}
	return 1;
}

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

CMD:map(playerid, params[]) {
	Phone_Map(playerid);
	return 1;
}

CMD:mygps(playerid, params[]) {
	if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa muc tieu truoc khi thuc hien danh dau khac (/xoamuctieu).");
	ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "{33CCFF}Ban Do San Andreas | Dinh Vi GPS", szGPSMainMenu, "Tiep tuc", "Huy");
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
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_MAP_BUSINESSES:	{
			if(!response) {
				return ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "{33CCFF}Ban Do San Andreas | Dinh Vi GPS", szGPSMainMenu, "Tiep tuc", "Huy");
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
		case DIALOG_MAP_JOBS: {
			if(!response) {
				return ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "{33CCFF}Ban Do San Andreas | Dinh Vi GPS", szGPSMainMenu, "Tiep tuc", "Huy");
			}
			new index = ListItemTrackId[playerid][listitem];
			if(index == -1) {
				// Show Ve Chai sub-menu
				new str[1024], zone[MAX_ZONE_NAME];
				new Float:locations[9][3] = {
					{-1566.9843, 469.1526, 7.1868}, // SAAS
					{-2653.7520, 698.6767, 27.9185}, // BV SF
					{-2073.8164, 8.3023, 35.3203}, // Nha bo hoang
					{-1830.6876, -107.5092, 5.6484}, // Ben cang SF
					{-1024.6283, -587.0613, 32.0078}, // Nha may SF
					{-756.8199, -112.6511, 65.9816}, // Lam nghiep SF
					{93.6625, -237.3292, 1.5781}, // Container Blueberry
					{782.4303, -1389.3700, 13.6063}, // Sanew
					{1861.1680, -1320.0677, 13.5435} // Xay dung LS
				};
				format(str, sizeof(str), "{00FF00}[Ban]{FFFFFF} Thuong Lai Ve Chai (Diem ban rac)\n");
				for(new i = 0; i < 9; i++) {
					Get3DZone(locations[i][0], locations[i][1], locations[i][2], zone, sizeof(zone));
					format(str, sizeof(str), "%s{FFFF00}[Mua]{FFFFFF} Diem Ve Chai %d (%s)\n", str, i + 1, zone);
				}
				return ShowPlayerDialogEx(playerid, DIALOG_GPS_VECHAI_SUB, DIALOG_STYLE_LIST, "Cong viec Ve Chai", str, "Xac nhan", "Tro ve");
			}
			else if(index == -2) {
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, -1941.356689, 2385.538574, 49.695312, 5.0);
				SendClientMessage(playerid, COLOR_YELLOW, "Diem bat dau Cong viec Giao Bao da duoc danh dau tren minimap.");
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_GEN_LOCATION;
				SetPVarString(playerid, "gpsName", "Bat dau Cong viec Giao Bao");
				return 1;
			}
			else if(index >= 0 && index < MAX_JOBPOINTS) {
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_JOB;
				SetPVarInt(playerid, "gpsJob", index);
				SetPlayerCheckpoint(playerid, JobData[index][jPos][0], JobData[index][jPos][1], JobData[index][jPos][2], 5.0);
				SendClientMessage(playerid, COLOR_YELLOW, "Mot diem danh dau mau do da duoc thiet lap tren minimap.");
				return 1;
			}
			return 1;
		}
		case DIALOG_GPS_VECHAI_SUB: {
			if(!response) {
				new zone[MAX_ZONE_NAME];
				new count = 0;
				szMiscArray[0] = 0;
				
				format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}[Cong viec]{FFFFFF} Ve Chai (Diem thu mua & Nguoi ban)\n", szMiscArray);
				ListItemTrackId[playerid][count++] = -1;

				format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}[Cong viec]{FFFFFF} Giao Bao (San Fierro)\n", szMiscArray);
				ListItemTrackId[playerid][count++] = -2;

				for(new i; i < MAX_JOBPOINTS; ++i)
				{
					if(JobData[i][jPos][0] == 0.0 || JobData[i][jPos][0] == 0) continue;
					Get3DZone(JobData[i][jPos][0], JobData[i][jPos][1], JobData[i][jPos][2], zone, sizeof(zone));
					format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}[Cong viec]{FFFFFF} %s (%s)\n", szMiscArray, JobName[ JobData[i][jType] ], zone);
					ListItemTrackId[playerid][count++] = i;
				}
				return ShowPlayerDialogEx(playerid, DIALOG_MAP_JOBS, DIALOG_STYLE_LIST, "Dia diem cong viec", szMiscArray, "Chon", "Tro ve");
			}
			new Float:x, Float:y, Float:z;
			new location_name[64];
			if(listitem == 0) {
				x = -2525.4250;
				y = 247.3949;
				z = 11.0938;
				format(location_name, sizeof(location_name), "Thuong Lai Ve Chai");
			} else {
				new Float:locations[9][3] = {
					{-1566.9843, 469.1526, 7.1868}, // SAAS
					{-2653.7520, 698.6767, 27.9185}, // BV SF
					{-2073.8164, 8.3023, 35.3203}, // Nha bo hoang
					{-1830.6876, -107.5092, 5.6484}, // Ben cang SF
					{-1024.6283, -587.0613, 32.0078}, // Nha may SF
					{-756.8199, -112.6511, 65.9816}, // Lam nghiep SF
					{93.6625, -237.3292, 1.5781}, // Container Blueberry
					{782.4303, -1389.3700, 13.6063}, // Sanew
					{1861.1680, -1320.0677, 13.5435} // Xay dung LS
				};
				new p = listitem - 1;
				x = locations[p][0];
				y = locations[p][1];
				z = locations[p][2];
				format(location_name, sizeof(location_name), "Diem Ve Chai %d", listitem);
			}
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, x, y, z, 5.0);
			new zone[MAX_ZONE_NAME];
			Get3DZone(x, y, z, zone, sizeof(zone));
			format(szMiscArray, sizeof(szMiscArray), "GPS da danh dau duong di toi {33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", location_name, zone);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			SetPVarString(playerid, "gpsName", location_name);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_GEN_LOCATION;
			return 1;
		}
		case DIALOG_GPS_ONE: {
			if(!response) return 1;
			switch(listitem) {
				case 0: { // Dia diem Cong viec
					new zone[MAX_ZONE_NAME];
					new count = 0;
					szMiscArray[0] = 0;
					
					format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}[Cong viec]{FFFFFF} Ve Chai (Diem thu mua & Nguoi ban)\n", szMiscArray);
					ListItemTrackId[playerid][count++] = -1;

					format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}[Cong viec]{FFFFFF} Giao Bao (San Fierro)\n", szMiscArray);
					ListItemTrackId[playerid][count++] = -2;

					for(new i; i < MAX_JOBPOINTS; ++i)
					{
						if(JobData[i][jPos][0] == 0.0 || JobData[i][jPos][0] == 0) continue;
						Get3DZone(JobData[i][jPos][0], JobData[i][jPos][1], JobData[i][jPos][2], zone, sizeof(zone));
						format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}[Cong viec]{FFFFFF} %s (%s)\n", szMiscArray, JobName[ JobData[i][jType] ], zone);
						ListItemTrackId[playerid][count++] = i;
					}
					return ShowPlayerDialogEx(playerid, DIALOG_MAP_JOBS, DIALOG_STYLE_LIST, "Dia diem cong viec", szMiscArray, "Chon", "Tro ve");
				}
				case 1: ShowGPSCategoryDialog(playerid, 1); // Tru so
				case 2: ShowGPSCategoryDialog(playerid, 2); // Ngan hang
				case 3: ShowGPSCategoryDialog(playerid, 3); // Benh vien
				case 4: { // Cua hang
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
				case 5: ShowGPSCategoryDialog(playerid, 4); // VIP
				case 6: ShowGPSCategoryDialog(playerid, 5); // Khai thac
				case 7: ShowGPSCategoryDialog(playerid, 6); // Illegal
				case 8: { // Tim dia chi ID
					ShowPlayerDialogEx(playerid, DIALOG_GPS_FIND_ID, DIALOG_STYLE_LIST, "Tim dia chi theo ID", "Tim Cua hang theo ID\nTim House theo ID\nTim Door theo ID", "Tiep tuc", "Tro ve");
				}
			}
			return 1;
		}
		case DIALOG_GPS_FIND_ID: {
			if(!response) {
				return ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "{33CCFF}Ban Do San Andreas | Dinh Vi GPS", szGPSMainMenu, "Tiep tuc", "Huy");
			}
			switch(listitem) {
				case 0: {
					SetPVarInt(playerid, "gpsUsingID", 11);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim Cua Hang", "Hay nhap ID Cua hang ban muon tim:", "Xac nhan", "Tro ve");
				}
				case 1: {
					SetPVarInt(playerid, "gpsUsingID", 12);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim House", "Hay nhap ID House ban muon tim:", "Xac nhan", "Tro ve");
				}
				case 2: {
					SetPVarInt(playerid, "gpsUsingID", 13);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim Door", "Hay nhap ID Door ban muon tim:", "Xac nhan", "Tro ve");
				}
			}
			return 1;
		}
		case DIALOG_GPS_TWO: {
			if(!response) {
				new using = GetPVarInt(playerid, "gpsUsingID");
				if(using >= 11 && using <= 13) {
					return ShowPlayerDialogEx(playerid, DIALOG_GPS_FIND_ID, DIALOG_STYLE_LIST, "Tim dia chi theo ID", "Tim Cua hang theo ID\nTim House theo ID\nTim Door theo ID", "Tiep tuc", "Tro ve");
				}
				return 1;
			}
			switch(GetPVarInt(playerid, "gpsUsingID")) {
				case 11: { // Cua hang
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
					SetPVarInt(playerid,"gpsBiz", id);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Tim dia diem", szMiscArray, "Co", "Khong");
				}
				case 12: // House
				{
					for (new i = 0, j = strlen(inputtext); i < j; i++) {
						if (inputtext[i] > '9' || inputtext[i] < '0') {
							SendClientMessageEx(playerid, COLOR_WHITE, "Ban phai nhap gia tri so, (ID House).");
							return 1;
						}
					}
					new id = strval(inputtext);
					SetPVarInt(playerid, "gpsHouse", id);
					if(HouseInfo[id][hOwned] == 0) {
						SendClientMessageEx(playerid, COLOR_WHITE, "Ngoi nha nay hien khong co nguoi so huu.");
						return 1;
					}
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"{FFFFFF}Ban co muon dat danh dau den dia diem:\n\n\
					house {33CCFF}#%i{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}?", id, szMiscArray);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Tim dia diem", szMiscArray, "Co", "Khong");
 				}
				case 13: // Door
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
					if(DDoorsInfo[id][ddDescription] == 0) {
						SendClientMessageEx(playerid, COLOR_WHITE, "Ngoi nha nay hien khong co nguoi so huu.");
						return 1;
					}
			     	GetEntity3DZone(id, 2, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"{FFFFFF}Ban co muon dat danh dau den dia diem:\n\n\
					Door #%i ({33CCFF}%s{FFFFFF}) o khu vuc {FF0000}%s{FFFFFF}?", id, DDoorsInfo[id][ddDescription], szMiscArray);
					ShowPlayerDialogEx(playerid, DIALOG_GPS_THREE, DIALOG_STYLE_MSGBOX, "{FF0000}Tim dia diem", szMiscArray, "Co", "Khong");
				}
			}
			return 1;
		}
		case DIALOG_GPS_THREE:{
			if(!response) {
				new using = GetPVarInt(playerid, "gpsUsingID");
				if(using >= 11 && using <= 13) {
					if(using == 11) ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim Cua Hang", "Hay nhap ID Cua hang ban muon tim:", "Xac nhan", "Tro ve");
					else if(using == 12) ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim House", "Hay nhap ID House ban muon tim:", "Xac nhan", "Tro ve");
					else if(using == 13) ShowPlayerDialogEx(playerid, DIALOG_GPS_TWO, DIALOG_STYLE_INPUT, "Tim Door", "Hay nhap ID Door ban muon tim:", "Xac nhan", "Tro ve");
				}
				return 1;
			}
			switch(GetPVarInt(playerid,"gpsUsingID"))
			{
				case 11:
				{
					new id = GetPVarInt(playerid,"gpsBiz");
					GetEntity3DZone(id, 0, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi {33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", Businesses[id][bName], szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_BUSINESS;
					DisablePlayerCheckpoint(playerid);		
					SetPlayerCheckpoint(playerid, Businesses[id][bExtPos][0], Businesses[id][bExtPos][1], Businesses[id][bExtPos][2], 15.0);
				}
				case 12:
				{
					new id = GetPVarInt(playerid,"gpsHouse");
					GetEntity3DZone(id, 1, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi house #{33CCFF}%i{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", id, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOUSE;
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, HouseInfo[id][hExteriorX], HouseInfo[id][hExteriorY], HouseInfo[id][hExteriorZ], 15.0);
				}
				case 13:
				{
					new id = GetPVarInt(playerid,"gpsDoor");
					GetEntity3DZone(id, 2, szMiscArray, sizeof(szMiscArray));
					format(szMiscArray,sizeof(szMiscArray),"GPS da danh dau duong di toi door #%i ({33CCFF}%s{FFFFFF}) o khu vuc {FF0000}%s{FFFFFF}.", id, DDoorsInfo[id][ddDescription],  szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_DOOR;
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, DDoorsInfo[id][ddExteriorX], DDoorsInfo[id][ddExteriorY], DDoorsInfo[id][ddExteriorZ], 15.0);
				}
			}
			return 1;
		}
		case DIALOG_GPS_GEN: {
			if(!response) {
				return ShowPlayerDialogEx(playerid, DIALOG_GPS_ONE, DIALOG_STYLE_LIST, "{33CCFF}Ban Do San Andreas | Dinh Vi GPS", szGPSMainMenu, "Tiep tuc", "Huy");
			}
			new using = GetPVarInt(playerid, "gpsUsingID");
			new Float:x, Float:y, Float:z;
			new location_name[64];
			
			switch(using) {
				case 1: { // Factions
					if(listitem < 0 || listitem >= sizeof(gpsFactionNames)) return 1;
					x = gpsFactionZones[listitem][0];
					y = gpsFactionZones[listitem][1];
					z = gpsFactionZones[listitem][2];
					format(location_name, sizeof(location_name), "%s", gpsFactionNames[listitem]);
				}
				case 2: { // Banks
					if(listitem < 0 || listitem >= sizeof(gpsBankNames)) return 1;
					x = gpsBankZones[listitem][0];
					y = gpsBankZones[listitem][1];
					z = gpsBankZones[listitem][2];
					format(location_name, sizeof(location_name), "%s", gpsBankNames[listitem]);
				}
				case 3: { // Hospitals
					if(listitem < 0 || listitem >= sizeof(gpsHospitalNames)) return 1;
					x = gpsHospitalZones[listitem][0];
					y = gpsHospitalZones[listitem][1];
					z = gpsHospitalZones[listitem][2];
					format(location_name, sizeof(location_name), "%s", gpsHospitalNames[listitem]);
				}
				case 4: { // VIP
					if(listitem < 0 || listitem >= sizeof(gpsVIPNames)) return 1;
					x = gpsVIPZones[listitem][0];
					y = gpsVIPZones[listitem][1];
					z = gpsVIPZones[listitem][2];
					format(location_name, sizeof(location_name), "%s", gpsVIPNames[listitem]);
				}
				case 5: { // Merchants
					if(listitem < 0 || listitem >= sizeof(gpsMerchantNames)) return 1;
					x = gpsMerchantZones[listitem][0];
					y = gpsMerchantZones[listitem][1];
					z = gpsMerchantZones[listitem][2];
					format(location_name, sizeof(location_name), "%s", gpsMerchantNames[listitem]);
				}
				case 6: { // Illegal
					if(listitem < 0 || listitem >= sizeof(gpsIllegalNames)) return 1;
					x = gpsIllegalZones[listitem][0];
					y = gpsIllegalZones[listitem][1];
					z = gpsIllegalZones[listitem][2];
					format(location_name, sizeof(location_name), "%s", gpsIllegalNames[listitem]);
				}
				default: return 1;
			}
			
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, x, y, z, 15.0);
			new zone[MAX_ZONE_NAME];
			Get3DZone(x, y, z, zone, sizeof(zone));
			format(szMiscArray, sizeof(szMiscArray), "GPS da danh dau duong di toi {33CCFF}%s{FFFFFF} o khu vuc {FF0000}%s{FFFFFF}.", location_name, zone);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			SetPVarString(playerid, "gpsName", location_name);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_GEN_LOCATION;
			return 1;
		}
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
