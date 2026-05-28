#include <YSI\y_hooks>

CMD:buygun(playerid, params[])
{
	new business = InBusiness(playerid);

	if(business == INVALID_BUSINESS_ID || Businesses[business][bType] != BUSINESS_TYPE_GUNSHOP) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung tai cua hang vu khi!");
	if(!CanPlayerBuyGuns(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can online du 2h de co the mua vu khi!");
	if(PlayerInfo[playerid][pGunLic] < gettime()) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can co giay phep su dung vu khi moi co the mua sung tu cua hang sung!");

	format(szMiscArray, sizeof(szMiscArray), "Vu khi\tGia\n9mm Pistol\t$%s\nSilenced 9mm\t$%s\nDesert Eagle\t$%s\nPump Shotgun\t$%s\nMP5\t$%s\nAK-47\t$%s\nM4\t$%s\nCountry Rifle\t$%s\nHop dan (1200 vien)\t$%s",
		number_format(GunPrices[0]), number_format(GunPrices[3]), number_format(GunPrices[2]),
		number_format(GunPrices[1]), number_format(GunPrices[4]), number_format(GunPrices[5]),
		number_format(GunPrices[6]), number_format(GunPrices[7]), number_format(GunPrices[8]));
	ShowPlayerDialogEx(playerid, DIALOG_AMMUNATION_GUNS, DIALOG_STYLE_TABLIST_HEADERS, "Ammunation - Mua vu khi", szMiscArray, "Mua", "Thoat");
	return 1;
}

CMD:editgsprices(playerid, params[]) {

	szMiscArray[0] = 0;

	new 
		choice[32], 
		amount;

	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong duoc phep su dung lenh do!");

	if(sscanf(params, "s[32]d", choice, amount)) {
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /editgsprices [choice] [amount]"); 
		SendClientMessageEx(playerid, COLOR_WHITE, "Vu khi: colt45, sdpistol, shotgun, deagle, mp5, ak47, m4, rifle, ammo");
		format(szMiscArray, sizeof(szMiscArray), "colt45: $%s | sdpistol: $%s | shotgun: $%s | deagle: $%s | mp5: $%s | ak47: $%s | m4: $%s | rifle: $%s | ammo: $%s",
			number_format(GunPrices[0]), number_format(GunPrices[3]), number_format(GunPrices[1]), number_format(GunPrices[2]),
			number_format(GunPrices[4]), number_format(GunPrices[5]), number_format(GunPrices[6]), number_format(GunPrices[7]), number_format(GunPrices[8]));
		return SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	}
	if(strcmp(choice, "colt45", true) == 0) {
		GunPrices[0] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the colt45 price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "shotgun", true) == 0) {
		GunPrices[1] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the shotgun price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "deagle", true) == 0) {
		GunPrices[2] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the deagle price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "sdpistol", true) == 0) {
		GunPrices[3] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the silenced pistol price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "mp5", true) == 0) {
		GunPrices[4] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the MP5 price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "ak47", true) == 0) {
		GunPrices[5] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the AK-47 price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "m4", true) == 0) {
		GunPrices[6] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the M4 price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "rifle", true) == 0) {
		GunPrices[7] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the Country Rifle price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "ammo", true) == 0) {
		GunPrices[8] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the Ammo Box price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	g_mysql_SaveMOTD();
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_AMMUNATION_GUNS:
		{
			if(!response)
				return SendClientMessageEx(playerid, COLOR_YELLOW, "Cam on ban da mua sam tai Ammunation!");

			if(listitem < 8 && PlayerInfo[playerid][pGunLic] < gettime())
				return SendClientMessageEx(playerid, COLOR_GREY, "Ban can co giay phep su dung vu khi moi co the mua sung tu cua hang sung!");

			new business = InBusiness(playerid);
			if(business == INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung tai cua hang vu khi!");

			new success = -1;

			switch(listitem)
			{
				case 0: // 9mm Pistol (Inventory Item 23)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[0]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 23, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[0]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[0]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua 9mm Pistol voi gia $%s.", number_format(GunPrices[0]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased 9mm pistol for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[0]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 1: // Silenced 9mm (Inventory Item 24)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[3]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 24, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[3]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[3]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua Silenced 9mm voi gia $%s.", number_format(GunPrices[3]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased silenced 9mm for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[3]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 2: // Desert Eagle (Inventory Item 25)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[2]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 25, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[2]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[2]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua Desert Eagle voi gia $%s.", number_format(GunPrices[2]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased deagle for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[2]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 3: // Pump Shotgun (Inventory Item 26)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[1]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 26, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[1]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[1]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua Pump Shotgun voi gia $%s.", number_format(GunPrices[1]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased shotgun for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[1]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 4: // MP5 (Inventory Item 30)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[4]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 30, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[4]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[4]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua MP5 voi gia $%s.", number_format(GunPrices[4]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased MP5 for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[4]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 5: // AK-47 (Inventory Item 31)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[5]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 31, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[5]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[5]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua AK-47 voi gia $%s.", number_format(GunPrices[5]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased AK-47 for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[5]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 6: // M4 (Inventory Item 32)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[6]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 32, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[6]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[6]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua M4 voi gia $%s.", number_format(GunPrices[6]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased M4 for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[6]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 7: // Country Rifle (Inventory Item 34)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[7]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 34, 1, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[7]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[7]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua Country Rifle voi gia $%s.", number_format(GunPrices[7]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased Country Rifle for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[7]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
				case 8: // Ammo Box (Inventory Item 41, 1200 rounds)
				{
					if(PlayerInfo[playerid][pCash] < GunPrices[8]) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong du tien!");
					if(Businesses[business][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang da het hang!");

					SetPlayerItem(playerid, 41, 1200, success);
					if(success != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Tui do cua ban da day!");

					Businesses[business][bInventory]--;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[8]);
		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[8]);

					format(szMiscArray, sizeof(szMiscArray), "[TUI DO] Ban da mua Hop dan tich hop (1200 vien) voi gia $%s.", number_format(GunPrices[8]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "%s has purchased Ammo Box for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[8]), Businesses[business][bName]);
					Log("logs/business.log", szMiscArray);
				}
			}
		}
	}
	return 0;
}
