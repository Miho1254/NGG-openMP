#include <YSI\y_hooks>

#define 	ITEM_DRUG			(0)
#define 	ITEM_MATS			(1)
#define 	ITEM_FIREWORK		(2)
#define 	ITEM_SYRINGES		(3)
#define 	ITEM_SPRUNKDRINK	(4)
#define 	ITEM_PBTOKENS		(5)
#define 	ITEM_WEAPON			(6)

#define 	INTERACT_AMOUNT			(10049)
#define 	INTERACT_MAIN 			(10050)
#define 	INTERACT_GIVE 			(10051)
#define 	DETAIN_SEAT 			(10052)
#define 	GIVE_TICKET				(10053)
#define 	HEAL_PLAYER				(10054)
#define 	TICKET_REASON			(10055)
#define 	PATIENT_SEAT			(10056)
#define 	INTERACT_WEAPON			(10057)
#define 	PAY_PLAYER				(10058)
#define 	INTERACT_SELL 			(10059)
#define 	INTERACT_SELLCONFIRM 	(10060)
#define 	INTERACT_DRUGS			(10061)
#define 	INTERACT_SELLCONFIRM2 	(10062)

#define 	INTERACT_PRESCRIBE		(10063)
#define 	INTERACT_PRESCRIBE1 	(10064)


Player_InteractMenu(playerid, giveplayerid, menu = 0) {

	if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot interact with yourself.");
	if(server_restaring) return SendClientMessageEx(playerid, COLOR_GREY, "Server dang bao tri, khong the thao tac");

	szMiscArray[0] = 0;

	new szTitle[64];

	format(szTitle, sizeof(szTitle), "Tuong tac voi %s", GetPlayerNameEx(giveplayerid));

	switch(menu) {
		case 0: {

			DeletePVar(giveplayerid, "Interact_Buying");
			DeletePVar(playerid, "Interact_SellPrice");
			DeletePVar(playerid, "Interact_Sell");
			DeletePVar(playerid, "Interact_SellGun");
			DeletePVar(playerid, "Interact_GiveItem");
			DeletePVar(playerid, "Interact_SellAmt");
			DeletePVar(playerid, "Interact_Drug");

			SetPVarInt(playerid, "Interact_Target", giveplayerid);

			format(szMiscArray, sizeof(szMiscArray), "Pay\nDua vat pham\nBan vat pham\nLuc soat\nTrinh bang lai");

			if(IsACop(playerid)) { // LEO-related interaction commands
				strcat(szMiscArray, "\nCong tay\nDan di\nDua len xe\nTicket\nThao cong\nDrug Test\nTich thu Drug");
			}

			if(IsAMedic(playerid)) { // Medical-related commands.
				strcat(szMiscArray, "\nPrescribe Drug\nLoadpt\nPhat thuoc (15hp)\nBan thuoc\nMovept\nDrug Test");
			}
			return ShowPlayerDialogEx(playerid, INTERACT_MAIN, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Chon", "Thoat");
		}
		case 1: {
			/*Ingredients\n\
			Pistol Ammo\t%d\n\
				Rifle Ammo\t%d\n\
				Deagle Ammo\t%d\n\
				Shotgun Ammo\t%d\n\*/
			format(szMiscArray, sizeof(szMiscArray), "Vat pham\tSo luong\n\
				Thuoc phien\n\
				Vat lieu\t%d\n\
				Phao hoa\t%d\n\
				Kim tiem\t%d\n\
				Nuoc\t%d\n\
				PB Tokens",
				PlayerInfo[playerid][pMats],
				PlayerInfo[playerid][pFirework],
				PlayerInfo[playerid][pSyringes],
				PlayerInfo[playerid][pSprunk],
				PlayerInfo[playerid][pPaintTokens]
			);
			return ShowPlayerDialogEx(playerid, INTERACT_GIVE, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "Chon", "Tro ve");
		}
		case 2: {
			new itemid = GetPVarInt(playerid, "Interact_GiveItem");

			if(GetPVarType(playerid, "Interact_Drug")) {
				format(szMiscArray, sizeof(szMiscArray), "Ban muon dua bao nhieu grams %s cho %s?", Drugs[GetPVarInt(playerid, "Interact_Drug")], GetPlayerNameEx(giveplayerid));
			}
			else format(szMiscArray, sizeof(szMiscArray), "Ban muon dua bao nhieu %s cho %s?", Item_Getname(itemid), GetPlayerNameEx(giveplayerid));
			return ShowPlayerDialogEx(playerid, INTERACT_AMOUNT, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Chon", "Tro ve");
		}
		case 3: {

			for(new g = 0; g < 12; g++)	{
				if(PlayerInfo[playerid][pGuns][g] != 0 && PlayerInfo[playerid][pAGuns][g] == 0) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s(%i)", szMiscArray, Weapon_ReturnName(PlayerInfo[playerid][pGuns][g]), PlayerInfo[playerid][pGuns][g]);
				}
			}
			return ShowPlayerDialogEx(playerid, INTERACT_WEAPON, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Chon", "Tro ve");
		}
		case 4: {
			new itemid = GetPVarInt(playerid, "Interact_GiveItem");
			new amount = GetPVarInt(playerid, "Interact_SellAmt");

			if(GetPVarType(playerid, "Interact_SellGun")) {
				new weaponid = GetPVarInt(playerid, "Interact_SellGun");

				format(szMiscArray, sizeof(szMiscArray), "How much do you want to sell %s to %s for?", ReturnWeaponName(weaponid), GetPlayerNameEx(giveplayerid));
			}
			if(GetPVarType(playerid, "Interact_Drug")) {

				new drugid = GetPVarInt(playerid, "Interact_Drug");

				format(szMiscArray, sizeof(szMiscArray), "How much do you want to sell %dg of %s to %s for?", amount, Drugs[drugid], GetPlayerNameEx(giveplayerid));
			}
			else format(szMiscArray, sizeof(szMiscArray), "How much do you want to sell %d %s to %s for?", amount, Item_Getname(itemid), GetPlayerNameEx(giveplayerid));

			return ShowPlayerDialogEx(playerid, INTERACT_SELL, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Ban", "Tro ve");
		}

		case 5: {
			new itemid = GetPVarInt(playerid, "Interact_GiveItem");
			new amount = GetPVarInt(playerid, "Interact_SellAmt");
			new offerprice = GetPVarInt(playerid, "Interact_SellPrice");


			if(GetPVarType(playerid, "Interact_SellGun")) {

				new weaponid = GetPVarInt(playerid, "Interact_SellGun");

				format(szMiscArray, sizeof(szMiscArray), "Ban da de nghi %s de mua %s voi gia $%s", GetPlayerNameEx(giveplayerid), Item_Getname(itemid), number_format(offerprice));
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s da de nghi de mua %s voi gia $%s", GetPlayerNameEx(playerid), ReturnWeaponName(weaponid), number_format(offerprice));
			}
			else if(GetPVarType(playerid, "Interact_Drug")) {
				new drugid = GetPVarInt(playerid, "Interact_Drug");

				format(szMiscArray, sizeof(szMiscArray), "Ban da de nghi %s de mua %d gram %s voi gia $%s", GetPlayerNameEx(giveplayerid), amount, Drugs[drugid], number_format(offerprice));
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s da de nghi ban mua %d gram %s voi gia $%s", GetPlayerNameEx(playerid), amount, Drugs[drugid], number_format(offerprice));
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "Ban da de nghi %s de mua %d %s voi gia $%s", GetPlayerNameEx(giveplayerid), amount, Item_Getname(itemid), number_format(offerprice));
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s da de nghi ban mua %d %s voi gia $%s", GetPlayerNameEx(playerid), amount, Item_Getname(itemid), number_format(offerprice));
			}
			ShowPlayerDialogEx(giveplayerid, INTERACT_SELLCONFIRM, DIALOG_STYLE_MSGBOX, szTitle, szMiscArray, "Mua", "Tu choi");


		}
		case 6: {

			szMiscArray = "Drug\tAmount\n";
			for(new d; d < sizeof(Drugs); ++d) {

				format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, Drugs[d], PlayerInfo[playerid][pDrugs][d]);
			}
			return ShowPlayerDialogEx(playerid, INTERACT_DRUGS, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "Select", "Back");
		}
	}

	return 1;
}

Player_GiveItem(playerid, giveplayerid, itemid, amount, saleprice = 0) {

	// amount in the case of giving weapons is the weapon id ...

	szMiscArray[0] = 0;

	if(amount <= 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot give nothing.");

	if(restarting) return SendClientMessageEx(playerid, COLOR_RED, "Server restart in progress, trading is disabled.");

	if(saleprice != 0 && (GetPlayerCash(giveplayerid) < saleprice || saleprice < 0)) return SendClientMessage(giveplayerid, COLOR_GRAD2, "Ban khong du tien");

	switch(itemid) {

		case ITEM_DRUG: {

			new drugid = GetPVarInt(playerid, "Interact_Drug");
			if(PlayerInfo[playerid][pDrugs][drugid] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du drug.");

			if(amount + PlayerInfo[giveplayerid][pDrugs][drugid] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pDrugs][drugid] += amount;
			PlayerInfo[playerid][pDrugs][drugid] -= amount;

		}
		case ITEM_MATS: {

			if(PlayerInfo[playerid][pMats] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du vat lieu.");

			if(amount + PlayerInfo[giveplayerid][pMats] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pMats] += amount;
			PlayerInfo[playerid][pMats] -= amount;
		}
		case ITEM_FIREWORK: {

			if(PlayerInfo[playerid][pFirework] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du fireworks.");

			if(amount + PlayerInfo[giveplayerid][pFirework] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pFirework] += amount;
			PlayerInfo[playerid][pFirework] -= amount;
		}
		case ITEM_SYRINGES: {

			if(PlayerInfo[playerid][pSyringes] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du syringes.");

			if(amount + PlayerInfo[giveplayerid][pSyringes] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pSyringes] += amount;
			PlayerInfo[playerid][pSyringes] -= amount;
		}
		case ITEM_SPRUNKDRINK: {

			if(PlayerInfo[playerid][pSprunk] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du Sprunk.");

			if(amount + PlayerInfo[giveplayerid][pSprunk] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pSprunk] += amount;
			PlayerInfo[playerid][pSprunk] -= amount;

		}
		case ITEM_PBTOKENS: {

			if(PlayerInfo[playerid][pPaintTokens] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du PB tokens.");

			if(amount + PlayerInfo[giveplayerid][pPaintTokens] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pPaintTokens] += amount;
			PlayerInfo[playerid][pPaintTokens] -= amount;
		}
	}

	if(saleprice == 0) {

		format(szMiscArray, sizeof(szMiscArray), "Ban da cho %s %d %s", GetPlayerNameEx(giveplayerid), amount, Item_Getname(itemid));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s da dua cho ban %d %s", GetPlayerNameEx(playerid), amount, Item_Getname(itemid));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s dua cho %s mot it %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Item_Getname(itemid));
		SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 5, 5000);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) da duoc cho %d %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Item_Getname(itemid), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "gave %d %s.", amount, Item_Getname(itemid));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}
	else {

		GivePlayerCash(playerid, saleprice);
		GivePlayerCash(giveplayerid, -saleprice);

		//TurfWars_TurfTax(giveplayerid, Item_Getname(itemid), saleprice); // Tax the buyer, not the seller.
		ExtortionTurfsWarsZone(playerid, 7, saleprice); // Back to taxing the seller. 

		format(szMiscArray, sizeof(szMiscArray), "Ban da ban %s %d %s voi gia $%s", GetPlayerNameEx(giveplayerid), amount, Item_Getname(itemid), number_format(saleprice));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s da ban %d %s voi gia $%s", GetPlayerNameEx(playerid), amount, Item_Getname(itemid), number_format(saleprice));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s dua cho %s mot so %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Item_Getname(itemid));
		SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 5, 5000);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has sold %d %s $%s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Item_Getname(itemid), number_format(saleprice), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%d %s $%s.", amount, Item_Getname(itemid), number_format(saleprice));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}

	return 1;
}

Player_MaxCapacity(playerid, itemid) {

	// planning on making this relative to a storage system in the future

	new iTemp = 0;

	switch(itemid) {
		case ITEM_MATS: iTemp = 1000000;
		case ITEM_FIREWORK: iTemp = 10;
		case ITEM_SYRINGES: iTemp = 20;
		case ITEM_SPRUNKDRINK: iTemp = 1;
		case ITEM_PBTOKENS: iTemp = 40;
		case ITEM_DRUG: {
			iTemp = GetMaxDrugsAllowed(GetPVarInt(playerid, "Interact_Drug"));
		}
	}
	return iTemp;
}

Player_LeftCapacity(playerid, itemid) {

	new
		iCapacity = Player_MaxCapacity(playerid, itemid);

	switch(itemid) {

		case ITEM_MATS: return (iCapacity - PlayerInfo[playerid][pMats]);
		case ITEM_FIREWORK: return (iCapacity - PlayerInfo[playerid][pFirework]);
		case ITEM_SYRINGES: return (iCapacity - PlayerInfo[playerid][pSyringes]);
		case ITEM_SPRUNKDRINK: return (iCapacity - PlayerInfo[playerid][pSprunk]);
		case ITEM_PBTOKENS: return (iCapacity - PlayerInfo[playerid][pPaintTokens]);
		case ITEM_DRUG: return (iCapacity - PlayerInfo[playerid][pDrugs][GetPVarInt(playerid, "Interact_Drug")]);
		default: return 0;
	}

	return 0;
}

Item_Getname(itemid) {

	new szTemp[18];

	switch(itemid) {
		case ITEM_MATS: szTemp = "materials";
		case ITEM_FIREWORK: szTemp = "fireworks";
		case ITEM_SYRINGES: szTemp = "syringes";
		case ITEM_SPRUNKDRINK: szTemp = "sprunk";
		case ITEM_PBTOKENS: szTemp = "paintball tokens";
	}
	return szTemp;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {
		case INTERACT_MAIN: {

			if(!response) {
				return DeletePVar(playerid, "Interact_Target");
			}

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");
			if(giveplayerid == INVALID_PLAYER_ID || !IsPlayerConnected(giveplayerid) || PlayerInfo[giveplayerid][pLevel] < 2 || PlayerInfo[playerid][pLevel] < 2) {
				if(listitem <= 2) {
					DeletePVar(playerid, "Interact_Target");
					return SendClientMessage(playerid, -1, "Ban hoac nguoi choi do can dat cap do 2 de giao dich.");
				}
			}
			switch(listitem) {

				case 0: return Interact_PayPlayer(playerid, giveplayerid);
				case 1: return Player_InteractMenu(playerid, giveplayerid, 1);
				case 2: {
					SetPVarInt(playerid, "Interact_Sell", 1);
					return Player_InteractMenu(playerid, giveplayerid, 1);
				}
				case 3: return Interact_FriskPlayer(playerid, giveplayerid);
				case 4: return Interact_ShowLicenses(playerid, giveplayerid);
			}

			if(strcmp(inputtext, "Cong tay") == 0) return Interact_CuffPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Dan di") == 0) return Interact_DragPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Dua len xe") == 0) return Interact_DetainPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Ticket") == 0) return Interact_GiveTicket(playerid, giveplayerid, "");
			else if(strcmp(inputtext, "Thao cong") == 0) return Interact_UncuffPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Drug Test") == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Drug tests have been disabled and will later be removed completely.");
			else if(strcmp(inputtext, "Confiscate Drugs") == 0) return Interact_TakeDrugs(playerid, giveplayerid);
			else if(strcmp(inputtext, "Prescribe Drug") == 0) return Interact_Prescribe(playerid, 0);
			else if(strcmp(inputtext, "Loadpt") == 0) Interact_LoadPatient(playerid, giveplayerid);
			else if(strcmp(inputtext, "Phat thuoc (15hp)") == 0) return Interact_Triage(playerid, giveplayerid);
			else if(strcmp(inputtext, "Ban thuoc") == 0) return Interact_Heal(playerid, giveplayerid);
			else if(strcmp(inputtext, "Movept") == 0) return Interact_MovePatient(playerid, giveplayerid);
		}

		case INTERACT_GIVE: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);
			if(strcmp(inputtext, "Thuoc phien") == 0) return Player_InteractMenu(playerid, giveplayerid, 6);
			if(strcmp(inputtext, "Vu khi") == 0) return Player_InteractMenu(playerid, giveplayerid, 3);

			SetPVarInt(playerid, "Interact_GiveItem", listitem);

			Player_InteractMenu(playerid, giveplayerid, 2);


		}

		case INTERACT_AMOUNT: {
			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new
				amount = strval(inputtext),
				itemid = GetPVarInt(playerid, "Interact_GiveItem");

			if(amount < 1) {
				SendClientMessageEx(playerid, COLOR_RED, "You must offer an item greater than 0!");
				return Player_InteractMenu(playerid, giveplayerid, 0);
			}

			SetPVarInt(playerid, "Interact_SellAmt", amount);
			if(GetPVarType(playerid, "Interact_Sell")) {

				return Player_InteractMenu(playerid, giveplayerid, 4);
			}
			if(GetPVarType(playerid, "Interact_Drug")) {
				Interact_GivePlayerDrug(playerid, giveplayerid, GetPVarInt(playerid, "Interact_Drug"));
				return 1;
			}
			Player_GiveItem(playerid, giveplayerid, itemid, amount);
		}

		case DETAIN_SEAT: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new seatid = strval(inputtext);

			if(!(0 < seatid <= 3)) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Seat id must be between 1, 2 or 3.");
				return Interact_DetainPlayer(playerid, giveplayerid);
			}

			Interact_DetainPlayer(playerid, giveplayerid, seatid);
		}

		case GIVE_TICKET: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new amount = strval(inputtext);

			if(!(0 < amount <= 25000)) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Ticket price must be between $0 and $25,000.");
				return Interact_GiveTicket(playerid, giveplayerid, "");
			}


			SetPVarInt(playerid, "Ticket_Amount", amount);
			Interact_GiveTicket(playerid, giveplayerid, "", amount);
		}

		case TICKET_REASON: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new amount = GetPVarInt(playerid, "Ticket_Amount");

			Interact_GiveTicket(playerid, giveplayerid, inputtext, amount);
		}

		case PATIENT_SEAT: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new seatid = strval(inputtext);

			if(!(0 < seatid <= 3)) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Seat id must be between 1, 2 or 3.");
				return Interact_LoadPatient(playerid, giveplayerid);
			}

			Interact_LoadPatient(playerid, giveplayerid, seatid);
		}

		case PAY_PLAYER: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new amount = strval(inputtext);

			Interact_PayPlayer(playerid, giveplayerid, amount);
		}

		case INTERACT_WEAPON: {
			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new stpos = strfind(inputtext, "(");
		    new fpos = strfind(inputtext, ")");
		    new idstr[4], id;
		    strmid(idstr, inputtext, stpos+1, fpos);
		    id = strval(idstr);

		    if(GetPVarType(playerid, "Interact_Sell")) {
				SetPVarInt(playerid, "Interact_SellGun", id);
				return Player_InteractMenu(playerid, giveplayerid, 4);
			}

		    Interact_GivePlayerValidWeapon(playerid, giveplayerid, id);
		}
		case INTERACT_DRUGS: {
			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);
			SetPVarInt(playerid, "Interact_GiveItem", ITEM_DRUG);
			SetPVarInt(playerid, "Interact_Drug", listitem);

			if(GetPVarType(playerid, "Interact_Sell")) {
				return Player_InteractMenu(playerid, giveplayerid, 2);
			}

			Player_InteractMenu(playerid, giveplayerid, 2);
		}
		case INTERACT_SELL: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new price = strval(inputtext);

			SetPVarInt(playerid, "Interact_SellPrice", price);
			SetPVarInt(giveplayerid, "Interact_Buying", playerid);

			Player_InteractMenu(playerid, giveplayerid, 5);

		}
		case INTERACT_SELLCONFIRM: {
			new buyingfrom = GetPVarInt(playerid, "Interact_Buying");

			if(!response) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da tu choi giao dich.");
				SendClientMessageEx(buyingfrom, COLOR_LIGHTBLUE, "Nguoi do da tu choi giao dich cua ban.");

				DeletePVar(playerid, "Interact_Buying");
				DeletePVar(buyingfrom, "Interact_SellPrice");
				DeletePVar(buyingfrom, "Interact_Sell");
				DeletePVar(buyingfrom, "Interact_SellGun");
				DeletePVar(playerid, "Interact_Drug");
				DeletePVar(buyingfrom, "Interact_GiveItem");
				DeletePVar(buyingfrom, "Interact_SellAmt");
				return 1;
			}

			new itemid = GetPVarInt(buyingfrom, "Interact_GiveItem");
			new amount = GetPVarInt(buyingfrom, "Interact_SellAmt");
			new offerprice = GetPVarInt(buyingfrom, "Interact_SellPrice");
			
			if(GetPVarType(buyingfrom, "Interact_SellGun")) {

				new weaponid = GetPVarInt(buyingfrom, "Interact_SellGun");

				format(szMiscArray, sizeof(szMiscArray), "%s, ban co muon mua %s voi gia $%s?\n\nNeu ban muon mua hay nhan Dong y hoac khong muon mua hay nhan Tu choi.", GetPlayerNameEx(buyingfrom), ReturnWeaponName(weaponid), number_format(offerprice));
			}
			else if(GetPVarType(buyingfrom, "Interact_Drug")) {
				new drugid = GetPVarInt(buyingfrom, "Interact_Drug");
				format(szMiscArray, sizeof(szMiscArray), "%s, ban co muon mua %d grams %s voi gia $%s?\n\nNeu ban muon mua hay nhan Dong y hoac khong muon mua hay nhan Tu choi.", GetPlayerNameEx(buyingfrom), amount, Drugs[drugid], number_format(offerprice));
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "%s, ban co muon mua %d %s voi gia $%s?\n\nNeu ban muon mua hay nhan Dong y hoac khong muon mua hay nhan Tu choi.", GetPlayerNameEx(playerid), amount, Item_Getname(itemid), number_format(offerprice));
			}			

			ShowPlayerDialogEx(playerid, INTERACT_SELLCONFIRM2, DIALOG_STYLE_MSGBOX, "Xac nhan giao dich", szMiscArray, "Dong y", "Tu choi");
		}
		case INTERACT_SELLCONFIRM2: {

			new buyingfrom = GetPVarInt(playerid, "Interact_Buying");

			if(!response) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da tu choi giao dich.");
				SendClientMessageEx(buyingfrom, COLOR_LIGHTBLUE, "Nguoi do da tu choi giao dich cua ban.");

				DeletePVar(playerid, "Interact_Buying");
				DeletePVar(buyingfrom, "Interact_SellPrice");
				DeletePVar(buyingfrom, "Interact_Sell");
				DeletePVar(buyingfrom, "Interact_SellGun");
				DeletePVar(playerid, "Interact_Drug");
				DeletePVar(buyingfrom, "Interact_GiveItem");
				DeletePVar(buyingfrom, "Interact_SellAmt");
				return 1;
			}

			new price = GetPVarInt(buyingfrom, "Interact_SellPrice");

			if(GetPVarType(buyingfrom, "Interact_Sell")) {

				if(GetPVarType(buyingfrom, "Interact_SellGun")) {

					new weaponid = GetPVarInt(buyingfrom, "Interact_SellGun");
					if(PlayerInfo[buyingfrom][pGuns][GetWeaponSlot(weaponid)] == weaponid)
					{
						Interact_GivePlayerValidWeapon(buyingfrom, playerid, weaponid, price);
					}
				}
				else if(GetPVarType(buyingfrom, "Interact_Drug")) {

					new drugid = GetPVarInt(buyingfrom, "Interact_Drug");
					Interact_GivePlayerDrug(buyingfrom, playerid, drugid, price);
				}
				else {

					new itemid = GetPVarInt(buyingfrom, "Interact_GiveItem");
					new amount = GetPVarInt(buyingfrom, "Interact_SellAmt");

					Player_GiveItem(buyingfrom, playerid, itemid, amount, price);
				}
			}
			DeletePVar(playerid, "Interact_Buying");
			DeletePVar(buyingfrom, "Interact_SellPrice");
			DeletePVar(buyingfrom, "Interact_Sell");
			DeletePVar(buyingfrom, "Interact_SellGun");
			DeletePVar(buyingfrom, "Interact_GiveItem");
			DeletePVar(buyingfrom, "Interact_SellAmt");
		}
		case INTERACT_PRESCRIBE: {
			SetPVarString(playerid, "DR_PTYPE", inputtext);
			Interact_Prescribe(playerid, 1);
		}
		case INTERACT_PRESCRIBE1: {
			if(strval(inputtext) <= 0 || !IsNumeric(inputtext)) return SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid value.");
			SetPVarInt(playerid, "DR_PAM", strval(inputtext));
			Interact_ProcessPrescription(playerid);
		}
	}
	return 0;
}

Interact_GivePlayerValidWeapon(playerid, giveplayerid, weaponid, saleprice = 0) {

	if(PlayerInfo[giveplayerid][pGuns][GetWeaponSlot(weaponid)] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player already has a weapon in that slot");
	if(PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] != weaponid) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co a weapon in your possession.");
	if(weaponid == WEAPON_KNIFE) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot give knives!");
	if(GetPVarType(giveplayerid, "IsInArena") || GetPVarInt(giveplayerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now!");
	if(PlayerInfo[giveplayerid][pConnectHours] < 2 || PlayerInfo[giveplayerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "That person is currently restricted from carrying weapons");


	if(saleprice != 0 && (GetPlayerCash(giveplayerid) < saleprice || saleprice < 0)) return SendClientMessage(giveplayerid, COLOR_GRAD2, "Ban khong du tien");
	PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] = 0;
	SetPlayerWeaponsEx(playerid);

	GivePlayerValidWeapon(giveplayerid, weaponid);

	if(saleprice != 0) {

		GivePlayerCash(playerid, saleprice);
		GivePlayerCash(giveplayerid, -saleprice);

		//TurfWars_TurfTax(giveplayerid, ReturnWeaponName(weaponid), saleprice);
		ExtortionTurfsWarsZone(playerid, 3, saleprice);

		format(szMiscArray, sizeof(szMiscArray), "You have sold %s a %s for $%s", GetPlayerNameEx(giveplayerid), ReturnWeaponName(weaponid), number_format(saleprice));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has sold you a %s $%s", GetPlayerNameEx(playerid), ReturnWeaponName(weaponid), number_format(saleprice));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has sold a %s for $%s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], ReturnWeaponName(weaponid), number_format(saleprice), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "sold a %s for $%s.", ReturnWeaponName(weaponid), number_format(saleprice));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}
	else {
		format(szMiscArray, sizeof(szMiscArray), "Ban da dua cho %s mot %s", GetPlayerNameEx(giveplayerid), ReturnWeaponName(weaponid));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s da duoc cho ban mot %s", GetPlayerNameEx(playerid), ReturnWeaponName(weaponid));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) da duoc cho a %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], ReturnWeaponName(weaponid), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "gave a %s.", ReturnWeaponName(weaponid));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}

	format(szMiscArray, sizeof(szMiscArray), "%s gave %s a %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), ReturnWeaponName(weaponid));
	SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 10, 5000);


	return 1;
}

Interact_GivePlayerDrug(playerid, giveplayerid, drugid, saleprice = 0) {

	szMiscArray[0] = 0;

	new amount = GetPVarInt(playerid, "Interact_SellAmt");
	if(amount < 0) return 1;

	if(restarting) return SendClientMessageEx(playerid, COLOR_RED, "Server restart in progress, trading is disabled.");

	if(saleprice != 0 && (GetPlayerCash(giveplayerid) < saleprice || saleprice < 0)) return SendClientMessage(giveplayerid, COLOR_GRAD2, "Ban khong du tien");

	if(PlayerInfo[playerid][pDrugs][drugid] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong cothat much.");

	if(amount + PlayerInfo[giveplayerid][pDrugs][drugid] > Player_MaxCapacity(giveplayerid, ITEM_DRUG)) {
		format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, ITEM_DRUG));
		SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
		return Player_InteractMenu(playerid, giveplayerid);
	}

	PlayerInfo[giveplayerid][pDrugs][drugid] += amount;
	PlayerInfo[playerid][pDrugs][drugid] -= amount;
	//PlayerInfo[giveplayerid][pDrugsQuality][drugid] = PlayerInfo[playerid][pDrugsQuality][drugid];

	if(saleprice != 0) {

		GivePlayerCash(playerid, saleprice);
		GivePlayerCash(giveplayerid, -saleprice);

		//TurfWars_TurfTax(giveplayerid, Drugs[drugid], saleprice);
		ExtortionTurfsWarsZone(playerid, 1, saleprice);

		format(szMiscArray, sizeof(szMiscArray), "You have sold %s %dg of %s for $%s", GetPlayerNameEx(giveplayerid), amount, Drugs[drugid], number_format(saleprice));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has sold you %dg of %s for $%s", GetPlayerNameEx(playerid), amount, Drugs[drugid], number_format(saleprice));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has sold %dg of %s for $%s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Drugs[drugid], number_format(saleprice), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "sold %dg of %s for $%s.", amount, Drugs[drugid], number_format(saleprice));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}
	else {
		format(szMiscArray, sizeof(szMiscArray), "Ban da cho %s %dg of %s", GetPlayerNameEx(giveplayerid), amount, Drugs[drugid]);
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s da duoc cho you %dg of %s", GetPlayerNameEx(playerid), amount, Drugs[drugid]);
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) da duoc cho %dg of %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Drugs[drugid], GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "gave %dg of %s.", amount, Drugs[drugid]);
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}

	format(szMiscArray, sizeof(szMiscArray), "%s gave %s some %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Drugs[drugid]);
	SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 10, 5000);
	return 1;
}

Interact_PayPlayer(playerid, giveplayerid, amount = -1) {


	if(amount == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Hay nhap so tien ban muon dua cho {FF0000}%s", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, PAY_PLAYER, DIALOG_STYLE_INPUT, "Dua tien", szMiscArray, "Xac nhan", "");
	}
	else {

		if(!(500000 < amount <= 1000000)) return SendClientMessageEx(playerid, COLOR_WHITE, "Gia tien khong duoc duoi 500,000$ hoac hon 1,000,000$.");
		if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan nguoi nay.");

		if(PlayerInfo[playerid][pCash] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co du tien.");

		format(szMiscArray, sizeof(szMiscArray), "Ban da dua cho %s so tien $%s.", GetPlayerNameEx(giveplayerid), number_format(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "Ban da nhan duoc $%s tu %s.", number_format(amount), GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		GivePlayerCash(playerid, -amount);
		GivePlayerCash(giveplayerid, amount);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has paid %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], number_format(amount), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "has been paid $%s", number_format(amount));
		DBLog(playerid, giveplayerid, "Pay_Log", szMiscArray);
	}
	return 1;
}

Interact_CuffPlayer(playerid, giveplayerid) {
	if(GetPVarInt(playerid, "Injured") == 1 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0)
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay bay gio.");

	if(PlayerInfo[playerid][pHasCuff] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co mang theo cong tay!");

	new Float:health, Float:armor;
	if(!IsPlayerConnected(giveplayerid))
	if (!ProxDetectorS(8.0, playerid, giveplayerid))
	if(GetPVarInt(giveplayerid, "Injured") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the cong tay ai do trong tinh trang bi thuong.");
	if(PlayerCuffed[giveplayerid] != 1 && GetPlayerSpecialAction(giveplayerid) != SPECIAL_ACTION_HANDSUP) return SendClientMessage(playerid, COLOR_WHITE, "Nguoi nay chua bi cuong che.");

	if(PlayerInfo[giveplayerid][pConnectHours] < 32) SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Neu ban thoat game ngay bay gio ban se bi tu dong giam trong vong 2 gio!");

	format(szMiscArray, sizeof(szMiscArray), "Ban da bi cong tay boi %s.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Ban da cong tay %s, thao tac lai de mo cong.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* %s da cong tay %s va that chat cong tay.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	GameTextForPlayer(giveplayerid, "~r~Cong tay", 2500, 3);
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
	//Frozen[giveplayerid] = 1;
	PlayerCuffedTime[giveplayerid] = 60;

	if(GetPVarType(giveplayerid, "IsTackled")) {
	    format(szMiscArray, sizeof(szMiscArray), "* %s da lay cong ra khoi that lung cua anh ay va co gang cong tay %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, giveplayerid);
	}
	return 1;
}

Interact_UncuffPlayer(playerid, giveplayerid) {

	if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong o gan ban.");
	if(PlayerCuffed[giveplayerid]>1) {

		DeletePVar(giveplayerid, "IsFrozen");
		format(szMiscArray, sizeof(szMiscArray), "Ban da duoc thao cong boi %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "Ban da thao cong cho %s.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s da thao cong cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GameTextForPlayer(giveplayerid, "~g~Thao cong", 2500, 3);
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
	else if(GetPVarInt(giveplayerid, "jailcuffs") == 1) {
		DeletePVar(giveplayerid, "IsFrozen");
		format(szMiscArray, sizeof(szMiscArray), "Ban da duoc thao cong boi %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "Ban da thao cong cho %s.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s da thao cong cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GameTextForPlayer(giveplayerid, "~g~Thao cong", 2500, 3);
		ClearAnimationsEx(giveplayerid);
		SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
		DeletePVar(giveplayerid, "jailcuffs");
	}
	return 1;
}

/*Interact_DrugTest(playerid, giveplayerid) {

	new szTitle[128];

	format(szTitle, sizeof(szTitle), "_______ %s's Drug Test _______", GetPlayerNameEx(giveplayerid));

	szMiscArray = "Name\tLevel (CT)\n";

	for(new i; i < sizeof(Drugs); ++i) {

		if(PlayerInfo[giveplayerid][pDrugsTaken][i] > 0) format(szMiscArray, sizeof(szMiscArray), "%s%s \t Level: %d CT\n", szMiscArray, Drugs[i], PlayerInfo[giveplayerid][pDrugsTaken][i]);
		else format(szMiscArray, sizeof(szMiscArray), "%s%s \t Level: None\n", szMiscArray, Drugs[i]);
	}
	strcat(szMiscArray, "________________________________", sizeof(szMiscArray));

	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<<", "");

	format(szMiscArray, sizeof(szMiscArray), "** %s has conducted a drug test on %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
	return SendClientMessage(playerid, COLOR_WHITE, "This feature has been removed.");
}*/

Interact_TakeDrugs(playerid, giveplayerid) {

	for(new i; i < sizeof(Drugs); ++i) {

		PlayerInfo[giveplayerid][pDrugs][i] = 0;
		PlayerInfo[giveplayerid][pBDrugs][i] = 0;
	}

	format(szMiscArray, sizeof(szMiscArray), "* %s da tich thu tat ca drug cua %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

Interact_ShowLicenses(playerid, giveplayerid) {

	if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan nguoi nay.");
	new text1[40], text2[20], text3[20], text4[20], text5[40];
	if(PlayerInfo[playerid][pCarLic] == 0) { text1 = "Khong co"; }
	else { text1 = date(PlayerInfo[playerid][pCarLic], 1); }
	if(PlayerInfo[playerid][pFlyLic]) { text4 = "Co"; } else { text4 = "Khong co"; }
	if(PlayerInfo[playerid][pBoatLic]) { text2 = "Co"; } else { text2 = "Khong co"; }
	if(PlayerInfo[playerid][pTaxiLicense]) { text3 = "Co"; } else { text3 = "Khong co"; }
	if(PlayerInfo[playerid][pGunLic] == 0) {text5 = "Khong co"; }
	else {text5 = date(PlayerInfo[playerid][pGunLic], 1);}

	switch(PlayerInfo[playerid][pNation]) {
		case 0: SendClientMessageEx(giveplayerid, COLOR_WHITE, "** Cong dan cua San Andreas **");
		case 1: SendClientMessageEx(giveplayerid, COLOR_TR, "** Cong dan cua New Robada **");
		case 2: SendClientMessageEx(giveplayerid, COLOR_TR, "** Khong quoc tich **");
	}
	format(szMiscArray, sizeof(szMiscArray), "Bang lai cua %s:", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Ngay sinh: %s", PlayerInfo[playerid][pBirthDate]);
	SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Bang lai Driver (xe): %s.", text1);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Bang lai Pilot (may bay): %s.", text4);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Bang lai Boating (thuyen): %s.", text2);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Bang lai Taxi: %s.", text3);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Giay phep su dung vu khi: %s.", text5);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* %s da dua bang lai cho ban xem.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* Ban da dua bang lai cho %s xem.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	return 1;
}

Interact_FriskPlayer(playerid, giveplayerid) {

	if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung gan nguoi nay.");
	if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the luc soat chinh minh!"); return 1; }

	new packages = GetPVarInt(giveplayerid, "Packages");
	new crates = PlayerInfo[giveplayerid][pCrates];
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
	format(szMiscArray, sizeof(szMiscArray), "Tui do cua %s.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	SendClientMessageEx(playerid, COLOR_WHITE, "** Vat pham **");
	if(PlayerInfo[giveplayerid][pMats] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Tui do) %d vat lieu.", PlayerInfo[giveplayerid][pMats]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	if(PlayerInfo[giveplayerid][pSyringes] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Tui do) %d kim tiem.", PlayerInfo[giveplayerid][pSyringes]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
    if(packages > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Tui do) %d goi vat lieu.", packages);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	if(crates > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Tui do) %d thung thuoc.", crates);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}

	SendClientMessageEx(playerid, COLOR_WHITE, "** Chat kich thich **");
	for(new i = 0; i < sizeof(Drugs); i++) {

		if(PlayerInfo[giveplayerid][pDrugs][i] > 0) {
			format(szMiscArray, sizeof(szMiscArray), "%s: %dg", Drugs[i], PlayerInfo[giveplayerid][pDrugs][i]);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
		}
	}

	if(Fishes[giveplayerid][pWeight1] > 0 || Fishes[giveplayerid][pWeight2] > 0 || Fishes[giveplayerid][pWeight3] > 0 || Fishes[giveplayerid][pWeight4] > 0 || Fishes[giveplayerid][pWeight5] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Tui do) %d ca.", PlayerInfo[giveplayerid][pFishes]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	SendClientMessageEx(playerid, COLOR_WHITE, "** Khac **");
	if(PlayerInfo[giveplayerid][pPhoneBook] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Danh ba.");
	if(PlayerInfo[giveplayerid][pCDPlayer] > 0) SendClientMessageEx(playerid, COLOR_GREY, "May nghe nhac.");
	new weaponname[50];
	SendClientMessageEx(playerid, COLOR_WHITE, "** Vu khi **");
	for (new i = 0; i < 12; i++)
	{
		if(PlayerInfo[giveplayerid][pGuns][i] > 0)
		{
			GetWeaponName(PlayerInfo[giveplayerid][pGuns][i], weaponname, sizeof(weaponname));
			format(szMiscArray, sizeof(szMiscArray), "Vu khi: %s.", weaponname);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
		}
	}
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");

	format(szMiscArray, sizeof(szMiscArray), "* %s dang kiem tra cac vat pham trong nguoi cua %s.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;

}

Interact_DragPlayer(playerid, giveplayerid) {

	if(GetPVarInt(giveplayerid, "PlayerCuffed") != 2) return SendClientMessageEx(playerid, COLOR_WHITE, "Nguoi nay chua bi cong tay!");

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban phai ra khoi xe de thuc hien lenh nay.");
	if(GetPVarInt(giveplayerid, "BeingDragged") == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Nguoi nay dang duoc keo di. ");

    new
    	Float:TempPos[3];

	GetPlayerPos(giveplayerid, TempPos[0], TempPos[1], TempPos[2]);
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, TempPos[0], TempPos[1], TempPos[2])) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nghi pham nay khong o gan ban.");

	format(szMiscArray, sizeof(szMiscArray), "%s da keo ban di theo ho.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "Ban da keo nghi pham %s di theo ban, bay gio ban hay di chuyen.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "%s da keo nghi pham %s di theo ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang dan nghi pham di theo minh, hay nhan '{AA3333}FIRE{FFFFFF}' de ngung keo di.");

	SetPVarInt(giveplayerid, "BeingDragged", 1);
	SetPVarInt(playerid, "DraggingPlayer", giveplayerid);
	SetTimerEx("DragPlayer", 1000, 0, "ii", playerid, giveplayerid);

	return 1;
}

Interact_DetainPlayer(playerid, giveplayerid, seatid = -1) {

	if(seatid == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Hay nhap vi tri cho ngoi (1-3) de dua nghi pham %s len xe.", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, DETAIN_SEAT, DIALOG_STYLE_INPUT, "Dua len xe", szMiscArray, "Xac nhan", "");
	}
	else {
		if(IsPlayerInAnyVehicle(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay dang o trong xe, hay dua ho ra khoi xe truoc.");
		if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan nghi pham nay!");
		if(PlayerCuffed[giveplayerid] != 2) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong bi cong tay");

		new carid = gLastCar[playerid];
		if(!IsSeatAvailable(carid, seatid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Vi tri cho ngoi nay da co nguoi!");
			return Interact_DetainPlayer(playerid, giveplayerid);
		}

		new Float:pos[6];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetPlayerPos(giveplayerid, pos[3], pos[4], pos[5]);
		GetVehiclePos( carid, pos[0], pos[1], pos[2]);
		if (floatcmp(floatabs(floatsub(pos[0], pos[3])), 10.0) != -1 &&
				floatcmp(floatabs(floatsub(pos[1], pos[4])), 10.0) != -1 &&
				floatcmp(floatabs(floatsub(pos[2], pos[5])), 10.0) != -1) return false;
		format(szMiscArray, sizeof(szMiscArray), "Ban da duoc dua len xe boi %s .", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "Ban da dua nghi pham %s len xe.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s da dua nghi pham %s len xe.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GameTextForPlayer(giveplayerid, "~r~Dua len xe", 2500, 3);
		ClearAnimationsEx(giveplayerid);
		TogglePlayerControllable(giveplayerid, false);
		IsPlayerEntering{giveplayerid} = true;
		DangLenXe[giveplayerid] = carid;
		PutPlayerInVehicle(giveplayerid, carid, seatid);
	}
	return 1;
}

Interact_GiveTicket(playerid, giveplayerid, reason[], amount = -1) {
	if(amount == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Hay nhap so tien ban muon viet ve phat cho {FF0000}%s", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, GIVE_TICKET, DIALOG_STYLE_INPUT, "Ve phat", szMiscArray, "Tiep tuc", "");
	}
	if(isnull(reason)) {
		format(szMiscArray, sizeof(szMiscArray), "Hay nhap ly do ban muon viet ve phat cho {FF0000}%s", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, TICKET_REASON, DIALOG_STYLE_INPUT, "Ve phat", szMiscArray, "Xac nhan", "");
	}
	else {
		if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung gan nguoi nay.");

		format(szMiscArray, sizeof(szMiscArray), "Ban da viet mot ve phat cho %s voi gia $%d, ly do: %s.", GetPlayerNameEx(giveplayerid), amount, reason);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* Officer %s da duoc cho ban mot ve phat va ban phai tra $%d, ly do: %s", GetPlayerNameEx(playerid), amount, reason);
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* Officer %s da viet mot ve phat va dua cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "(( Hay nhap lenh /chapnhan ticket de chap nhan )).");
		TicketOffer[giveplayerid] = playerid;
		TicketMoney[giveplayerid] = amount;
	}
	return 1;
}

Interact_LoadPatient(playerid, giveplayerid, seatid = -1) {

	if(seatid == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Hay nhap vi tri cho ngoi (1-3) de dua nbenh nhan %s len xe.", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, PATIENT_SEAT, DIALOG_STYLE_INPUT, "Load Patient", szMiscArray, "Xac nhan", "");
	}
	else {
		if(GetPVarInt(giveplayerid, "Injured") != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong bi thuong.");
        if(IsPlayerInAnyVehicle(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay dang o trong xe roi.");
        if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan nguoi nay.");

        new carid = gLastCar[playerid];
        if(!IsAnAmbulance(carid)) return SendClientMessageEx(playerid, COLOR_GREY, "Xe cuoi cung ban lai khong phai la xe Ambulance.");
        if(IsVehicleOccupied(carid, seatid)) return SendClientMessageEx(playerid, COLOR_GREY, "Vi tri cho ngoi nay da co nguoi.");
		if(!IsPlayerInRangeOfVehicle(giveplayerid, carid, 10.0) || !IsPlayerInRangeOfVehicle(playerid, carid, 10.0)) return SendClientMessageEx(playerid, COLOR_GREY, "Both you and your patient must be near the ambulance.");

		format(szMiscArray, sizeof(szMiscArray), "Ban da duoc dua len xe boi Doctor %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "Ban da dua benh nhan %s len xe.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s da dua benh nhan %s len xe %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetVehicleName(carid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPVarInt(giveplayerid, "EMSAttempt", 3);
		ClearAnimationsEx(giveplayerid);
		IsPlayerEntering{giveplayerid} = true;
		DangLenXe[giveplayerid] = carid;
		PutPlayerInVehicle(giveplayerid,carid,seatid);
		TogglePlayerControllable(giveplayerid, false);
	}
	return 1;
}

Interact_Triage(playerid, giveplayerid) {
	if(PlayerInfo[playerid][pTriageTime] != 0)	return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai doi 2 phut nua moi co the thuc hien lai.");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi nay khong ket noi.");
    if(!ProxDetectorS(5.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung gan nguoi nay!");

    new Float: health;
    GetHealth(giveplayerid, health);
    if(health >= 85) SetHealth(giveplayerid, 100);
	else SetHealth(giveplayerid, health+15.0);
    format(szMiscArray, sizeof(szMiscArray), "* %s da cho %s mot vien thuoc.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
    ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	PlayerInfo[playerid][pTriageTime] = 120;
	return 1;
}

Interact_Heal(playerid, giveplayerid, healprice = -1) {

	if(healprice == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Hay nhap so tien ban muon ban thuoc cho {FF0000}%d", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, HEAL_PLAYER, DIALOG_STYLE_INPUT, "Ban thuoc", szMiscArray, "Xac nhan", "");
	}
	else {
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(giveplayerid, X, Y, Z);

		if(!IsPlayerInRangeOfPoint(playerid, 10, X, Y, Z)) return SendClientMessageEx(playerid, TEAM_GREEN_COLOR,"Ban khong dung gan nguoi nay!");

		new Float:tempheal;
		GetHealth(giveplayerid,tempheal);
		if(tempheal >= 100.0) return SendClientMessageEx(playerid, TEAM_GREEN_COLOR,"Nguoi nay da day mau.");

		format(szMiscArray, sizeof(szMiscArray), "Ban da ban thuoc cho %s voi gia $%d.", GetPlayerNameEx(giveplayerid),healprice);
		SendClientMessageEx(playerid, COLOR_PINK, szMiscArray);
		GivePlayerCash(playerid, healprice / 2);

		//Tax += healprice / 2;

		GivePlayerCash(giveplayerid, -healprice);
		SetHealth(giveplayerid, 100);

		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		PlayerPlaySound(giveplayerid, 1150, 0.0, 0.0, 0.0);

		format(szMiscArray, sizeof(szMiscArray), "Ban da nhan duoc 100 health voi gia $%d tu Doctor %s.",healprice, GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, TEAM_GREEN_COLOR,szMiscArray);

		if(GetPVarType(giveplayerid, "STD")){
			DeletePVar(giveplayerid, "STD");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "* You are no longer infected with a STD because of the medic's help.");
		}
	}
	return 1;
}

Interact_MovePatient(playerid, giveplayerid) {

	if(GetPVarInt(giveplayerid,"Injured") != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Nguoi nay khong bi thuong.");

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi nay dang tren xe.");
	if(PlayerInfo[giveplayerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the su dung lenh nay voi tu nhan.");
	if(GetPVarInt(giveplayerid, "OnStretcher") == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi nay da duoc movept.");

	new Float:mX, Float:mY, Float:mZ;
	GetPlayerPos(giveplayerid, mX, mY, mZ);
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, mX, mY, mZ)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be close to the patient to be able to move them!");

	SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da dua benh nhan len bang ca va day ho den xe cuu thuong, nhan '{AA3333}FIRE{BFC0C2}' de dung lai.");
	format(szMiscArray, sizeof(szMiscArray), "Ban da duoc dua len bang ca boi %s.", GetPlayerNameEx(playerid));

	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Ban da dua %s len bang ca va day ho di.", GetPlayerNameEx(giveplayerid));

	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* %s da dua %s len bang ca va that day an toan cho benh nhan.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));

	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	SetPVarInt(giveplayerid, "OnStretcher", 1);
	SetPVarInt(playerid, "TickEMSMove", SetTimerEx("MoveEMS", 30000, false, "d", playerid));
	SetPVarInt(playerid, "MovingStretcher", giveplayerid);
	return 1;
}

Interact_Prescribe(playerid, stage = 0) {

	switch(stage) {

		case 0: {

			ShowPlayerDialogEx(playerid, DIALOG_STYLE_LIST, INTERACT_PRESCRIBE, "Type | Drug Prescription", "Demerol\n\
				Morphine\n\
				Haloperidol\n\
				Aspirin",
				"Select", "Cancel");
		}
		case 1: {

			ShowPlayerDialogEx(playerid, DIALOG_STYLE_INPUT, INTERACT_PRESCRIBE1, "Grams | Drug Prescription", "How many pieces would you like to prescribe?", "Prescribe", "Cancel");
		}
	}
	return 1;
}

Interact_ProcessPrescription(playerid) {

	new giveplayerid = GetPVarInt(playerid, "Interact_Target"),
		iAmount = GetPVarInt(playerid, "DR_PAM");

	GetPVarString(playerid, "DR_PTYPE", szMiscArray, sizeof(szMiscArray));
	new iDrugID = GetDrugID(szMiscArray);

	if(iAmount + PlayerInfo[giveplayerid][pDrugs][iDrugID] > Player_MaxCapacity(giveplayerid, ITEM_DRUG)) {
		format(szMiscArray, sizeof(szMiscArray), "Nguoi choi nay chi co the giu them %d cho vat pham do.", Player_LeftCapacity(giveplayerid, ITEM_DRUG));
		SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
		return Player_InteractMenu(playerid, giveplayerid);
	}

	if(PlayerInfo[playerid][pDrugs][iDrugID] < iAmount) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong co du drug.");
	format(szMiscArray, sizeof(szMiscArray), "You have prescribed %s %d pc of %s.", GetPlayerNameEx(giveplayerid), iAmount, szMiscArray);
	SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s has prescribed you %d pc of %s.", GetPlayerNameEx(playerid), iAmount, szMiscArray);
	SendClientMessage(giveplayerid, COLOR_GRAD2, szMiscArray);
	PlayerInfo[playerid][pDrugs][iDrugID] += iAmount;
	return 1;
}

/*
	Concept is to introduce the ability to pickup items that have been dropped and have a player add it to their inventory.
	Also to centralize all posessions into a single dialog.
*/

/*Player_InventoryMenu(playerid) {

	return 1;
}

Player_InventoryAction(playerid) {

	return 1;
}

Player_DropItem(playerid) {

	return 1;
}*/

CMD:tuongtac(playerid, params[]) {


	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /tuongtac [playerid]");

	new giveplayerid = strval(params);
	if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the tuong tac voi chinh minh.");
	if(giveplayerid == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong online.");
	if(GetPVarInt(playerid, "Injured") == 1) return 1;
	if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan nguoi nay.");
	if(PlayerInfo[giveplayerid][pAdmin] >= 2 && !PlayerInfo[giveplayerid][pTogReports]) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
	Player_InteractMenu(playerid, giveplayerid);
	return 1;
}
