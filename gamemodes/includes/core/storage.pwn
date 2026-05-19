/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Storage System

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

stock ShowStorageEquipDialog(playerid)
{
	if(gPlayerLogged{playerid} != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not logged in!");

	new dialogstring[256];
	new epstring[][] = { "Unequipped", "Equipped", "Not Owned" };

	for(new i = 0; i < 3; i++)
	{
		format(dialogstring, sizeof(dialogstring), "%s%s", dialogstring, storagetype[i+1]);
		if(StorageInfo[playerid][i][sStorage] != 1) format(dialogstring, sizeof(dialogstring), "%s (%s)\n", dialogstring, epstring[2]);
		else format(dialogstring, sizeof(dialogstring), "%s (%s)\n", dialogstring, epstring[StorageInfo[playerid][i][sAttached]]);
	}

	ShowPlayerDialogEx(playerid, STORAGEEQUIP, DIALOG_STYLE_LIST, "Storage - Equip/Unequip", dialogstring, "Select", "Exit");
	return 1;
}

/*stock ShowStorageDialog(playerid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	new titlestring[128], dialogstring[512];

	SetPVarInt(playerid, "Storage_transaction", 1); // Prevent double transactions.
	SetPVarInt(playerid, "Storage_fromplayerid", fromplayerid);
	SetPVarInt(playerid, "Storage_fromstorageid", fromstorageid);
	SetPVarInt(playerid, "Storage_itemid", itemid);
	SetPVarInt(playerid, "Storage_amount", amount);
	SetPVarInt(playerid, "Storage_price", price);
	SetPVarInt(playerid, "Storage_special", special);

	if(price == -1) format(titlestring, sizeof(titlestring), "Where do you want to store %d %s?", amount, itemtype[itemid]);
	else format(titlestring, sizeof(titlestring), "You are buying %d %s for %d", amount, itemtype[itemid], price);

	switch(itemid)
	{
		case 1:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - ($%d)\n", PlayerInfo[playerid][pCash]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - ($%d/$%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sCash], limits[i+1][0]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - ($%d)\nBag - ($%d/$%d)\nBackpack - ($%d/$%d)\nBriefcase - ($%d/$%d)",
				//PlayerInfo[playerid][pCash],
				//StorageInfo[playerid][0][sCash],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sCash],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sCash],
				//briefcaselimit[itemid-1]
			//);
		}
		case 2:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d)\n", PlayerInfo[playerid][pPot]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - (%d/%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sPot], limits[i+1][0]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d/%d)\nBag - (%d/%d)\nBackpack - (%d/%d)\nBriefcase - (%d/%d)",
				//PlayerInfo[playerid][pPot],
				//onhandlimit[itemid-1],
				//StorageInfo[playerid][0][sPot],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sPot],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sPot],
				//briefcaselimit[itemid-1]
			//);
		}
		case 3:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - ($%d)\n", PlayerInfo[playerid][pCrack]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - (%d/%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sCrack], limits[i+1][0]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d/%d)\nBag - (%d/%d)\nBackpack - (%d/%d)\nBriefcase - (%d/%d)",
				//PlayerInfo[playerid][pCrack],
				//onhandlimit[itemid-1],
				//StorageInfo[playerid][0][sCrack],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sCrack],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sCrack],
				//briefcaselimit[itemid-1]
			//);
		}
		case 4:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d)\n", PlayerInfo[playerid][pMats]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - (%d/%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sMats], limits[i+1][3]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d/%d)\nBag - (%d/%d)\nBackpack - (%d/%d)\nBriefcase - (%d/%d)",
				//PlayerInfo[playerid][pMats],
				//onhandlimit[itemid-1],
				//StorageInfo[playerid][0][sMats],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sMats],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sMats],
				//briefcaselimit[itemid-1]
			//);
		}
	}

	ShowPlayerDialogEx(playerid, STORAGESTORE, DIALOG_STYLE_LIST, titlestring, dialogstring, "Choose", "Cancel");
}

stock DeathDrop(playerid)
{
	new storageid;
	new bool:itemEquipped = false;
	for(new i = 0; i < 3; i++)
	{
		if(StorageInfo[playerid][i][sAttached] == 1) {
			storageid = i;
			if(storageid != 0) itemEquipped = true; // Bag is exempted from death drops.
		}
	}

	if(itemEquipped == true)
	{

		new rand = random(101);

		switch (PlayerInfo[playerid][pDonateRank])
		{
			case 0: // Normal (50 Percent)
			{
				if(rand > 0 && rand <= 50) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 1: // BVIP (40 Percent)
			{
				if(rand > 0 && rand <= 40) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 2: // SVIP (30 Percent)
			{
				if(rand > 0 && rand <= 30) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 3: // GVIP (20 Percent)
			{
				if(rand > 0 && rand <= 20) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 4: // PVIP (No Chance)
			{
				return SendClientMessageEx(playerid, COLOR_YELLOW, "Since you are Platinum VIP, you lose nothing from storage device.");
			}
			case 5: // Moderator (No Chance)
			{
				return SendClientMessageEx(playerid, COLOR_YELLOW, "Since you are (Moderator) Platinum VIP, you lose nothing from storage device.");
			}
		}
	}
	return 1;
}

// Doc Usage:
// playerid - Person Reciving the Item's Amount. (Who is storing the amount)
// storageid - PlayerID's storage index. (Where to store sending amount)
// fromplayerid - Person Giving the Item's Amount. (Notice: Use -1 if from a non-player, script-based etc.).
// fromstorageid - FromStorageID's storage index. (Notice: Use -1 if from a non-player, script-based etc.)
// itemid - ItemID index that is tradeing, used for both. (What is storing)
// amount - The amount of ItemID that is tradeing, used for both. (What amount is storing)
// price - The price of the transaction (in pCash), sent to playerid from sender. (Notice: Use -1 if no price is required)
// special - Set this to 1 if function is being used by skills or other things. (Notice: Use -1 if no special is required)

// ItemIDs:
// 0 - Nothing
// 1 - Cash
// 2 - Pot
// 3 - Crack
// 4 - Materials

// StorageIDs:
// 0 - Pocket/OnHand
// 1 - Bag
// 2 - Backpack
// 3 - Briefcase
*/

stock TransferStorage(playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	if(playerid == fromplayerid)
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR! You cannot transfer from yourself to yourself");
	}

	storageid=0; fromstorageid=0; //temp
	//printf("TransferStorage(playerid=%d, storageid=%d, fromplayerid=%d, fromstorageid=%d, itemid=%d, amount=%d, price=%d, special=%d)", playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special);

	if(GetPVarInt(playerid, "Storage_transaction") == 1)
	{
		if(fromplayerid != -1 && fromstorageid != -1) {
			SendClientMessageEx(fromplayerid, COLOR_WHITE, "Player is busy with an existing transaction.");
		}
		return 0;
	}

	new string[128];

	// Disable Prices for Cash Transfers
	if(price != -1 && itemid == 1) price = -1;

	// Ask the player where to store
	if(storageid == -1)
	{
		//UNCOMMENT WHEN RE RELEASE
		//ShowStorageDialog(playerid, fromplayerid, fromstorageid, itemid, amount, price, special);
		return 0;
	}

	// Check if such item is equipped.
	if(storageid > 0 && storageid < 4)
	{
		if(StorageInfo[playerid][storageid-1][sAttached] == 0)
		{
			format(string, sizeof(string), "Ban khong co the %s equipped!", storagetype[storageid]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 0;
		}
	}

	if(fromplayerid != -1 && fromstorageid != -1)
	{
		if(!IsPlayerConnected(fromplayerid)) return 0;
		if(amount < 0) return 0;

		if(fromstorageid > 0 && fromstorageid < 4)
		{
			if(StorageInfo[fromplayerid][fromstorageid-1][sAttached] == 0)
			{
				format(string, sizeof(string), "Ban khong co the %s equipped!", storagetype[fromstorageid]);
				SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
				return 0;
			}
		}
	}

    if(special == 1 && itemid == 2) // Pot Special "Selling"
	{
		ExtortionTurfsWarsZone(PotOffer[playerid], 0, PotPrice[playerid]);

        GivePlayerCash(PotOffer[playerid], PotPrice[playerid]);
		GivePlayerCash(playerid, -PotPrice[playerid]);

  		if(PlayerInfo[PotOffer[playerid]][pDoubleEXP] > 0)
		{
			format(string, sizeof(string), "You have gained 2 drug dealer skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[PotOffer[playerid]][pDoubleEXP]);
			SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, string);
			PlayerInfo[PotOffer[playerid]][pDrugSmuggler] += 2;
		}
		else
		{
			PlayerInfo[PotOffer[playerid]][pDrugSmuggler] += 1;
		}

        if(PlayerInfo[PotOffer[playerid]][pDrugSmuggler] == 50)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 2, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugSmuggler] == 100)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 3, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugSmuggler] == 200)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 4, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugSmuggler] == 400)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 5, you can buy more Grams and Cheaper."); }
        OnPlayerStatsUpdate(playerid);
        OnPlayerStatsUpdate(PotOffer[playerid]);
		PotOffer[playerid] = INVALID_PLAYER_ID;
		PotStorageID[playerid] = -1;
        PotPrice[playerid] = 0;
        PotGram[playerid] = 0;

	}
	if(special == 1 && itemid == 3) // Crack Special "Selling"
	{
		ExtortionTurfsWarsZone(CrackOffer[playerid], 0, CrackPrice[playerid]);


        GivePlayerCash(CrackOffer[playerid], CrackPrice[playerid]);
		GivePlayerCash(playerid, -CrackPrice[playerid]);

		if(PlayerInfo[CrackOffer[playerid]][pDoubleEXP] > 0)
		{
			format(string, sizeof(string), "You have gained 2 drug dealer skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[CrackOffer[playerid]][pDoubleEXP]);
			SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, string);
			PlayerInfo[CrackOffer[playerid]][pDrugSmuggler] += 2;
		}
		else
		{
			PlayerInfo[CrackOffer[playerid]][pDrugSmuggler] += 1;
		}

        PlayerInfo[playerid][pDrugs][2] += CrackGram[playerid];
        PlayerInfo[CrackOffer[playerid]][pDrugs][2] -= CrackGram[playerid];
        if(PlayerInfo[CrackOffer[playerid]][pDrugSmuggler] == 50)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 2, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugSmuggler] == 100)
		{ SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 3, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugSmuggler] == 200)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 4, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugSmuggler] == 400)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 5, you can buy more Grams and Cheaper."); }
		OnPlayerStatsUpdate(playerid);
        OnPlayerStatsUpdate(CrackOffer[playerid]);
		CrackOffer[playerid] = INVALID_PLAYER_ID;
		CrackStorageID[playerid] = -1;
        CrackPrice[playerid] = 0;
        CrackGram[playerid] = 0;
	}
	if(special == 2 && itemid == 2) // Pot Special "Getting"
	{
		new mypoint = -1;
		for (new i=0; i<MAX_POINTS; i++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 3)
			{
				new myvw = GetPlayerVirtualWorld(playerid);
				if(myvw == Points[i][pointVW3])
				{
					mypoint = i;
				}
			}
		}

		if(PlayerInfo[playerid][pDonateRank] < 1)
		{
			Points[mypoint][Stock] -= amount;
			format(string, sizeof(string), " Pot/OPIUM AVAILABLE: %d/1000.", Points[mypoint][Stock]);
			UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
		}
		for(new i = 0; i < MAX_GROUPS; i++)
		{
			if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
			{
				arrGroupData[i][g_iBudget] += price/2;
			}
		}
	}
	if(special == 2 && itemid == 3) // Crack Special "Getting"
	{
		new mypoint = -1;
		for (new i=0; i<MAX_POINTS; i++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 4)
			{
				new myvw = GetPlayerVirtualWorld(playerid);
				if(myvw == Points[i][pointVW3])
				{
					mypoint = i;
				}
			}
		}
		if(PlayerInfo[playerid][pDonateRank] < 1)
		{
			Points[mypoint][Stock] -= amount;
			format(string, sizeof(string), " CRACK AVAILABLE: %d/500.", Points[mypoint][Stock]);
			UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
		}
		for(new i = 0; i < MAX_GROUPS; i++)
		{
			if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
			{
				arrGroupData[i][g_iBudget] += price/2;
			}
		}
	}
	if(special == 2 && itemid == 4) // Materials Special "Getting"
	{
		DeletePVar(playerid, "Packages");
		DeletePVar(playerid, "MatDeliver");
		DisablePlayerCheckpoint(playerid);
	}
	if(special == 4 && itemid == 1) // House Withdraw - Cash
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hSafeMoney] -= amount;
	}
	if(special == 4 && itemid == 2) // House Withdraw - Pot
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hPot] -= amount;
	}
	if(special == 4 && itemid == 3) // House Withdraw - Crack
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hCrack] -= amount;
	}
	if(special == 4 && itemid == 4) // House Withdraw - Mats
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hMaterials] -= amount;
	}

	switch(storageid)
	{
		case 0: // Pocket or On Hand
		{
			if(itemid == 1)
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pCash] += amount;
				OnPlayerStatsUpdate(playerid);
				if(fromplayerid != -1) {
        			OnPlayerStatsUpdate(fromplayerid);
        		}
				format(string, sizeof(string), "$%d da duoc dua vao vi tien cua ban (Tien mat hien tai cua ban: $%d).", amount, PlayerInfo[playerid][pCash]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d da duoc lay tu %s cua ban va dua vao %s cua %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s trong %s, va dua so tien do cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given $%s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s has given $%s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given $%s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s (IP:%s) da dua $%s %s cho %s (IP:%s).", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (PlayerInfo[playerid][pDrugs][1] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][1] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][1] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pDrugs][1] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pDrugs][1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (PlayerInfo[playerid][pDrugs][2] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][2] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][2] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pDrugs][2] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pDrugs][2]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (PlayerInfo[playerid][pMats] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pMats] += amount;
				//format(string, sizeof(string), "%d Materials has been transfered to your Pocket (%d/%d).", amount, PlayerInfo[playerid][pMats], onhandlimit[itemid-1]);
				format(string, sizeof(string), "%s vat lieu da duoc chuyen vao tui do cua ban (Vat lieu hien tai: %s).", number_format(amount), number_format(PlayerInfo[playerid][pMats]));
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s vat lieu trong %s, va dua cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			/*if(itemid == 4)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You need at least a Bag to be able to store Materials.");
				return 0;
			}*/

			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d).", amount, storagetype[storageid], PlayerInfo[playerid][pCash]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pDrugs][1], onhandlimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pDrugs][2], onhandlimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pMats], onhandlimit[itemid-1]);

			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		case 1: // Bag
		{
			if(StorageInfo[playerid][0][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Bag. You may purchase one at a 24/7 store.");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][0][sCash] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Bag ($%d/$%d).", amount, StorageInfo[playerid][0][sCash], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][0][sPot] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][1] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][1] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sPot], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][0][sCrack] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][2] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][2] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sCrack], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][0][sMats] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sMats] += amount;
				format(string, sizeof(string), "%d Materials has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sMats], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}

			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][0][sCash], bbackpacklimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sPot], bbackpacklimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sCrack], bbackpacklimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sMats], bbackpacklimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

		}
		case 2: // Backpack
		{
			if(StorageInfo[playerid][1][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Backpack. You may purchase one on our E-Store.");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][1][sCash] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Backpack ($%d/$%d).", amount, StorageInfo[playerid][1][sCash], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][1][sPot] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][1] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][1] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sPot], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][1][sCrack] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][2] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][2] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sCrack], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][1][sMats] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sMats] += amount;
				format(string, sizeof(string), "%d Materials has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sMats], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][1][sCash], backpacklimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sPot], backpacklimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sCrack], backpacklimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sMats], backpacklimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		case 3: // Briefcase
		{
			if(StorageInfo[playerid][2][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Briefcase. You may purchase one on our E-Store.");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][2][sCash] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Briefcase ($%d/$%d).", amount, StorageInfo[playerid][2][sCash], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][2][sPot] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][1] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][1] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Briefcase (%d/%d).", amount, StorageInfo[playerid][2][sPot], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][2][sCrack] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pDrugs][2] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pDrugs][2] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Briefcase. (%d/%d)", amount, StorageInfo[playerid][2][sCrack], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][2][sMats] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong cosufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sMats] += amount;
				format(string, sizeof(string), "%d Materials has been transfered to your Briefcase (%d/%d).", amount, StorageInfo[playerid][2][sMats], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay ra mot it %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) da duoc cho %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) da duoc cho %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}

			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][2][sCash], briefcaselimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sPot], briefcaselimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sCrack], briefcaselimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sMats], briefcaselimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	return 0;
}

stock ShowInventory(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[64], pnumber[20], toolboxstring[30];
		if(PlayerInfo[targetid][pPnumber] == 0) pnumber = "None"; else format(pnumber, sizeof(pnumber), "%d", PlayerInfo[targetid][pPnumber]);
		new totalwealth;
		totalwealth = PlayerInfo[targetid][pAccount] + GetPlayerCash(targetid);
		if(PlayerInfo[targetid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey]][hSafeMoney];
		if(PlayerInfo[targetid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey2]][hSafeMoney];
		if(PlayerInfo[targetid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey3]][hSafeMoney];

		if(PlayerInfo[targetid][pToolBox] >= 1) format(toolboxstring, 50, "Tool Box: 1, (Usages: %s)", number_format(PlayerInfo[targetid][pToolBox]));
		else format(toolboxstring, 50, "Tool Box: 0");

		SetPVarInt(playerid, "ShowInventory", targetid);
		format(header, sizeof(header), "%s's Tui do", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"{FFFFFF}Tong so tien: $%s\n\
		Tien mat: $%s\n\
		Tien ngan hang: $%s\n\
		{FFFF00}Vang{FFFFFF}: %s Cay\n\
		So dien thoai: %s\n\
		Tan so: %dkhz\n\
		Vat lieu: %s\n\
		Dice: %s\n\
		Day thung: %s\n\
		Rags: %s\n\
		Tua vit: %s\n\
		Lop xe: %s\n\
		Paper: %s\n\
		Thuoc la: %s\n\
		Nuoc giai khat: %s\n\
		Binh son xe: %s\n\
		%s\n\
		Xa beng: %d",
		number_format(totalwealth),
		number_format(GetPlayerCash(targetid)),
		number_format(PlayerInfo[targetid][pAccount]),
		number_format(PlayerInfo[targetid][pVang]),
		pnumber,
		PlayerInfo[targetid][pRadioFreq],
		number_format(PlayerInfo[targetid][pMats]),
		number_format(PlayerInfo[targetid][pDice]),
		number_format(PlayerInfo[targetid][pRope]),
		number_format(PlayerInfo[targetid][pRags]),
		number_format(PlayerInfo[targetid][pScrewdriver]),
		number_format(PlayerInfo[targetid][pTire]),
		number_format(PlayerInfo[targetid][pPaper]),
		number_format(PlayerInfo[targetid][pCigar]),
		number_format(PlayerInfo[targetid][pSprunk]),
		number_format(PlayerInfo[targetid][pSpraycan]),
		toolboxstring,
		PlayerInfo[targetid][pCrowBar]);
		ShowPlayerDialogEx(playerid, DISPLAY_INV, DIALOG_STYLE_MSGBOX, header, resultline, "Trang sau", "Tat");
	}
	return 1;
}

stock FindGunInVehicleForPlayer(ownerid, slot, playerid)
{
	new
		i = 0;
	while (i < (PlayerVehicleInfo[ownerid][slot][pvWepUpgrade] + 1) && (!PlayerVehicleInfo[ownerid][slot][pvWeapons][i] || PlayerInfo[playerid][pGuns][GetWeaponSlot(PlayerVehicleInfo[ownerid][slot][pvWeapons][i])] == PlayerVehicleInfo[ownerid][slot][pvWeapons][i]))
	{
		i++;
	}
	if (i == (PlayerVehicleInfo[ownerid][slot][pvWepUpgrade] + 1)) return -1;
	return i;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DISPLAY_INV:
		{
			new targetid = GetPVarInt(playerid, "ShowInventory");
			if(IsPlayerConnected(targetid))
			{
				if(response)
				{
					new resultline[1024], header[64];

					format(header, sizeof(header), "Tui do cua %s", GetPlayerNameEx(targetid));
					format(resultline, sizeof(resultline),"{FFFFFF}Khoa: %d\n\
					Hop mau: %d\n\
					Receivers: %d\n\
					GPS: %d\n\
					Bug Sweeps: %d\n\
					Phao hoa: %d\n\
					Boombox: %d\n\
					Mailbox: %d\n\
					Rim Kits: %d\n\
					Checks: %s\n\
					Car slot da mua: %s\n\
					Toys slot da mua: %s",
					PlayerInfo[targetid][pLock],
					PlayerInfo[targetid][pFirstaid],
					PlayerInfo[targetid][pReceiver],
					PlayerInfo[targetid][pGPS],
					PlayerInfo[targetid][pSweep],
					PlayerInfo[targetid][pFirework],
					PlayerInfo[targetid][pBoombox],
					PlayerInfo[targetid][pMailbox],
					PlayerInfo[targetid][pRimMod],
					number_format(PlayerInfo[targetid][pChecks]),
					number_format(PlayerInfo[targetid][pVehicleSlot]),
					number_format(PlayerInfo[targetid][pToySlot]));
					if(zombieevent) format(resultline, sizeof(resultline), "%s\nCure Vials: %d\nScrap Metal: %d\nAntibiotic Injections: %d\n.50 Cals: %d\nSurvivor Kits: %d\nFuel Can: %d%% Fuel", resultline, PlayerInfo[targetid][pVials], PlayerInfo[targetid][mInventory][16], PlayerInfo[targetid][mInventory][17], PlayerInfo[targetid][mPurchaseCount][18], PlayerInfo[targetid][mInventory][19], PlayerInfo[targetid][zFuelCan]);
					ShowPlayerDialogEx(playerid, DISPLAY_INV2, DIALOG_STYLE_MSGBOX, header, resultline, "Trang truoc", "Tat");
				}
				else DeletePVar(playerid, "ShowInventory");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi ban dang kiem tra da thoat game!");
				DeletePVar(playerid, "ShowInventory");
				return 1;
			}
		}
		case DISPLAY_INV2:
		{
			new targetid = GetPVarInt(playerid, "ShowInventory");
			if(IsPlayerConnected(targetid))
			{
				if(response)
				{
					ShowInventory(playerid, targetid);
				}
				else DeletePVar(playerid, "ShowInventory");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
				DeletePVar(playerid, "ShowInventory");
				return 1;
			}
		}
	}
	return 0;
}

/*CMD:storagehelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** STORAGE *** /(vs)viewstorage /(es)equipstorage /personalwithdraw /personaldeposit /storagegive");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** STORAGE *** /transferstorage");
    return 1;
}*/

CMD:inv(playerid, params[]) {
	return callcmd::inventory(playerid, params);
}

CMD:inventory(playerid, params[])
{
	if(gPlayerLogged{playerid} != 0) ShowInventory(playerid, playerid);
	return 1;
}

CMD:mytokens(playerid, params[])
{
	szMiscArray[0] = 0;

	SendClientMessage(playerid, COLOR_GREY, "------------------------------------------------------------------------------------------------");

	format(szMiscArray, sizeof(szMiscArray), "VIP Tokens: %s, Paintball Tokens: %s, EXP Tokens: %s (Gio: %s), Event Tokens: %s, Gold Giftbox: %s",
		number_format(PlayerInfo[playerid][pTokens]),
		number_format(PlayerInfo[playerid][pPaintTokens]),
		number_format(PlayerInfo[playerid][pEXPToken]),
		number_format(PlayerInfo[playerid][pDoubleEXP]),
		number_format(PlayerInfo[playerid][pEventTokens]),
		number_format(PlayerInfo[playerid][pGoldBoxTokens]));

	SendClientMessage(playerid, COLOR_WHITE, szMiscArray);

	SendClientMessage(playerid, COLOR_GREY, "------------------------------------------------------------------------------------------------");
	return 1;
}

CMD:trunkput(playerid, params[])
{
	if(GetPVarType(playerid, "IsInArena"))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the thuc hien lenh nay khi dang trong Arena!");
		return 1;
	}
	if(GetPVarInt( playerid, "EventToken") != 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the thuc hien lenh nay khi dang trong Su kien!");
		return 1;
	}
	if(IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the thuc hien lenh nay khi dang ngoi trong xe!"); return 1; }
	if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the su dung lenh nay khi dang duoc cap cuu!");

	new string[128], weaponchoice[32], slot;
	if(sscanf(params, "s[32]D(0)", weaponchoice, slot)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /catsung [ten vu khi] [slot]");

	new pvid = -1, Float: x, Float: y, Float: z;

	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	{
		if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
		{
			pvid = d;
			break;
		}
	}
	if(pvid == -1) return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong dung gan phuong tien xe ma ban so huu.");
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(PlayerVehicleInfo[playerid][pvid][pvId],engine,lights,alarm,doors,bonnet,boot,objective);
	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong the lay hay bo do vao trong cop xe neu no dang dong!(/car trunk de mo no ra)");
	if(GetVehicleModel(PlayerVehicleInfo[playerid][pvid][pvId]) == 481 || GetVehicleModel(PlayerVehicleInfo[playerid][pvid][pvId]) == 510)  return SendClientMessageEx(playerid,COLOR_GREY,"Xe nay khong co cop.");

	new Float: Health;
	GetHealth(playerid, Health);
	if(Health < 80.0) return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong the cat sung hoac chat kich thich vao cop xe khi dang con 80 mau.");
	if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
	{
		format(string, sizeof(string), "Ban phai doi %d giay nua moi co the tiep tuc cat vu khi vao cop xe.", GetPVarInt(playerid, "GiveWeaponTimer"));
		SendClientMessageEx(playerid,COLOR_GREY,string);
		return 1;
	}

	new maxslots = PlayerVehicleInfo[playerid][pvid][pvWepUpgrade]+1;
	if(slot > maxslots || slot < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Slot khong hop le.");
		return 1;
	}

	if( PlayerVehicleInfo[playerid][pvid][pvWeapons][slot-1] != 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban da co vu khi trong slot nay roi.");
		return 1;
	}

	new weapon;
	if(strcmp(weaponchoice, "sdpistol", true, strlen(weaponchoice)) == 0)
	{
		if(pTazer{playerid} == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the cat khau sung Tazer vao cop xe cua ban!");
		if( PlayerInfo[playerid][pGuns][2] == 23 && PlayerInfo[playerid][pAGuns][2] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung Sdpistol vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][2];
			format(string,sizeof(string), "* %s da cat khau sung Sdpistol vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "9mm", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][2] == 22 && PlayerInfo[playerid][pAGuns][2] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung 9mm trong cop xe");
			weapon = PlayerInfo[playerid][pGuns][2];
			format(string,sizeof(string), "* %s da cat khau sung 9mm vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "deagle", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][2] == 24 && PlayerInfo[playerid][pAGuns][2] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung Deagle vao trong cop xe");
			weapon = PlayerInfo[playerid][pGuns][2];
			format(string,sizeof(string), "* %s da cat khau sung Deagle vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "shotgun", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][3] == 25 && PlayerInfo[playerid][pAGuns][3] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung Shotgun vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][3];
			format(string,sizeof(string), "* %s da cat khau sung Shotgun vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "spas12", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][3] == 27 && PlayerInfo[playerid][pAGuns][3] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung SPAS-12 vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][3];
			format(string,sizeof(string), "* %s da cat khau sung SPAS-12 vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "mp5", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][4] == 29 && PlayerInfo[playerid][pAGuns][4] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung MP5 vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][4];
			format(string,sizeof(string), "* %s da cat khau sung MP5 vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}

	else if(strcmp(weaponchoice, "tec9", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][4] == 32 && PlayerInfo[playerid][pAGuns][4] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung TEC9 vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][4];
			format(string,sizeof(string), "* %s da cat khau sung TEC9 vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}

	else if(strcmp(weaponchoice, "uzi", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][4] == 28 && PlayerInfo[playerid][pAGuns][4] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung TEC9 vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][4];
			format(string,sizeof(string), "* %s da cat khau sung TEC9 vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}

	else if(strcmp(weaponchoice, "ak47", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][5] == 30 && PlayerInfo[playerid][pAGuns][5] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung AK-47 vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][5];
			format(string,sizeof(string), "* %s da cat khau sung AK-47 vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "m4", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][5] == 31 && PlayerInfo[playerid][pAGuns][5] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung M4 vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][5];
			format(string,sizeof(string), "* %s da cat khau sung M4 vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "rifle", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][6] == 33 && PlayerInfo[playerid][pAGuns][6] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung Rifle vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][6];
			format(string,sizeof(string), "* %s da cat khau sung Rifle vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "sniper", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][6] == 34 && PlayerInfo[playerid][pAGuns][6] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat khau sung Sniper vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][6];
			format(string,sizeof(string), "* %s da cat khau sung Sniper vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "golfclub", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 2 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Golf Club vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s da cat Golf Club vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "baseballbat", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 5 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Baseball Bat vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s da cat Baseball Bat vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "shovel", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 6 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Shovel vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s da cat Shovel vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "poolcue", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 7 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Pool Cue vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s da cat Pool Cue vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "katana", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 8 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Katana vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s da cat Katana vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "cane", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][10] == 15 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Cane vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][10];
			format(string,sizeof(string), "* %s da cat Cane vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "flowers", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][10] == 14 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Flowers vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][10];
			format(string,sizeof(string), "* %s da cat Flowers vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "parachute", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][11] == 46 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Parachute vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][11];
			format(string,sizeof(string), "* %s da cat Parachute vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "dildo", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][10] == 10 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Ban da cat Dildo vao trong cop xe.");
			weapon = PlayerInfo[playerid][pGuns][10];
			format(string,sizeof(string), "* %s da cat Dildo vao trong cop xe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else { SendClientMessageEx(playerid,COLOR_GREY,"Ten vu khi khong hop le!"); return 1; }
	if(PlayerVehicleInfo[playerid][pvid][pvWeapons][slot-1] == 0)
	{
		PlayerVehicleInfo[playerid][pvid][pvWeapons][slot-1] = weapon;
		RemovePlayerWeapon(playerid, weapon);
		g_mysql_SaveVehicle(playerid, pvid);
	}
	return 1;
}

CMD:trunktake(playerid, params[]) {
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the su dung lenh nay khi dang ngoi tren xe.");
	if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Tai khoan cua ban dang bi han che!");
	else if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay khi dang trong dau truong!");
	else if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay khi dang trong su kien.");
	else if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay, vi ban dang bi han che su dung vu khi!");
	else if(GetPVarInt(playerid, "GiveWeaponTimer") >= 1)
	{
		new szMessage[59];
		format(szMessage, sizeof(szMessage), "Ban phai doi %d giay truoc khi lay mot vu khi khac.", GetPVarInt(playerid, "GiveWeaponTimer"));
		return SendClientMessageEx(playerid, COLOR_GREY, szMessage);
	}

	new
		Float: fVehPos[3],
		iWeaponSlot = strval(params);

	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++) {
		if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) {
			GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], fVehPos[0], fVehPos[1], fVehPos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, fVehPos[0], fVehPos[1], fVehPos[2])) {
				if(isnull(params)) {

					new
						szMessage[64];

					format(szMessage, sizeof(szMessage), "*** %s - Cop xe (%s) ***", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					for(new s = 0; s < 3; s++) if(PlayerVehicleInfo[playerid][d][pvWeapons][s] != 0) {

						new
							szWeapon[16];

						GetWeaponName(PlayerVehicleInfo[playerid][d][pvWeapons][s], szWeapon, sizeof(szWeapon));
						format(szMessage, sizeof(szMessage), "Slot %d: %s", s+1, szWeapon);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
					return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /laysung [slot]");
				}
				else if(GetVehicleModel(PlayerVehicleInfo[playerid][d][pvId]) == 481 || GetVehicleModel(PlayerVehicleInfo[playerid][d][pvId]) == 509) {
					return SendClientMessageEx(playerid,COLOR_GREY,"Chiec xe do khong co cop xe.");
				}

				new
					engine, lights, alarm, doors, bonnet, boot, objective;

				GetVehicleParamsEx(PlayerVehicleInfo[playerid][d][pvId], engine, lights, alarm, doors, bonnet, boot, objective);

				if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) {
					return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong the lay vu khi ra ngoai khi cop xe dang bi dong! /car trunk de mo no.");
				}

				new maxslots = PlayerVehicleInfo[playerid][d][pvWepUpgrade]+1;
				if(iWeaponSlot > maxslots || iWeaponSlot < 1) {
					return SendClientMessageEx(playerid, COLOR_GREY, "Vi tri chi dinh khong hop le.");
				}

				else if(PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1] != 0) {
					new
						szWeapon[16],
						szMessage[128];


					new aWeapons[13][2];

					for(new i; i < 13; ++i) {
						GetPlayerWeaponData(playerid, i, aWeapons[i][0], aWeapons[i][1]);
						if(aWeapons[i][0] == PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are already carrying this weapon.");
					}

					GetWeaponName(PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1], szWeapon, sizeof(szWeapon));
					GivePlayerValidWeapon(playerid, PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1]);
					PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1] = 0;
					g_mysql_SaveVehicle(playerid, d);

					format(szMessage, sizeof(szMessage), "Ban da lay %s ra tu cop xe.", szWeapon);
					SendClientMessageEx(playerid, COLOR_GREEN, szMessage);

					format(szMessage, sizeof(szMessage), "* %s da lay %s ra tu cop xe.", GetPlayerNameEx(playerid), szWeapon);
					return ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co vu khi o slot nay.");
			}
		}
	}
	return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong dung gan phuong tien xe ma ban so huu.");
}

CMD:storegun(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
		if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay luc nay!");
		new string[128], weaponchoice[32], slot;
		if(sscanf(params, "s[32]d", weaponchoice, slot)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hcatsung [ten vu khi] [slot]");

		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
				{
					format(string, sizeof(string), "Ban phai doi %d giay nua de tiep tuc cat sung.", GetPVarInt(playerid, "GiveWeaponTimer"));
					SendClientMessageEx(playerid,COLOR_GREY,string);
					return 1;
				}

				new maxslots = HouseInfo[i][hGLUpgrade];
				if(slot > maxslots || slot == 0)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Slot khong kha dung (1-5).");
					return 1;
				}

				if( HouseInfo[i][hWeapons][slot-1] != 0)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Ban da co vu khi duoc luu tru trong slot nay roi.");
					return 1;
				}

				new weapon;
				if(strcmp(weaponchoice, "sdpistol", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][2] == 23 && PlayerInfo[playerid][pAGuns][2] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Sdpistol vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][2];
						format(string,sizeof(string), "* %s da cat khau sung Sdpistol vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "deagle", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][2] == 24 && PlayerInfo[playerid][pAGuns][2] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Desert Eagle vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][2];
						format(string,sizeof(string), "* %s da cat khau sung Desert Eagle vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "shotgun", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][3] == 25 && PlayerInfo[playerid][pAGuns][3] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Shotgun vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][3];
						format(string,sizeof(string), "* %s da cat khau sung Shotgun vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "spas12", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][3] == 27 && PlayerInfo[playerid][pAGuns][3] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Combat Shotgun vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][3];
						format(string,sizeof(string), "* %s da cat khau sung Combat Shotgun vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "mp5", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][4] == 29 && PlayerInfo[playerid][pAGuns][4] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau MP5 vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][4];
						format(string,sizeof(string), "* %s da cat khau sung MP5 vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "ak47", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][5] == 30 && PlayerInfo[playerid][pAGuns][5] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau AK-47 vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][5];
						format(string,sizeof(string), "* %s da cat khau sung AK-47 vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "m4", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][5] == 31 && PlayerInfo[playerid][pAGuns][5] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau M4 vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][5];
						format(string,sizeof(string), "* %s da cat khau sung M4 vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "rifle", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][6] == 33 && PlayerInfo[playerid][pAGuns][6] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Rifle vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][6];
						format(string,sizeof(string), "* %s da cat khau sung Rifle vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "sniper", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][6] == 34 && PlayerInfo[playerid][pAGuns][6] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Sniper Rifle vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][6];
						format(string,sizeof(string), "* %s da cat khau sung Sniper Rifle vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "uzi", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][4] == 28 && PlayerInfo[playerid][pAGuns][4] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Uzi vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][4];
						format(string,sizeof(string), "* %s da cat khau sung Uzi vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "tec9", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][4] == 32 && PlayerInfo[playerid][pAGuns][4] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cat 1 khau Tec-9 vao trong tu do.");
						weapon = PlayerInfo[playerid][pGuns][4];
						format(string,sizeof(string), "* %s da cat khau sung Tec-9 vao trong nha.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				if(weapon == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong cam vu khi do tren nguoi.");
				if(HouseInfo[i][hWeapons][slot-1] == 0)
				{
					HouseInfo[i][hWeapons][slot-1] = weapon;
					RemovePlayerWeapon(playerid, weapon);
					SaveHouse(i);
					return 1;
				}
				else { SendClientMessageEx(playerid,COLOR_LIGHTRED,"Ten vu khi khong hop le!"); return 1; }
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha.");
	return 1;
}

CMD:getgun(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		new string[128], slot;

		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay, vi ban dang bi han che su dung vu khi!");

				if(sscanf(params, "d", slot))
				{
					new weaponname[50];
					SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
					format(string, sizeof(string), "*** Tu do trong nha cua %s ***", GetPlayerNameEx(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					for(new s = 0; s < 5; s++)
					{
						if( HouseInfo[i][hWeapons][s] != 0 )
						{
							GetWeaponName(HouseInfo[i][hWeapons][s], weaponname, sizeof(weaponname));
							format(string, sizeof(string), "Slot %d: %s", s+1, weaponname);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
					}
					SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
					SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /hlaysung [slot]");
					return 1;
				}

				if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
				{
					format(string, sizeof(string), "Ban phai doi %d giay nua de co the tiep tuc lay sung.", GetPVarInt(playerid, "GiveWeaponTimer"));
					SendClientMessageEx(playerid,COLOR_GREY,string);
					return 1;
				}
				new maxslots = HouseInfo[i][hGLUpgrade];
				if(slot > maxslots)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Slot khong hop le (1-5).");
					return 1;
				}

				if(HouseInfo[i][hWeapons][slot-1] != 0)
				{
					new weaponname[50];
					GetWeaponName(HouseInfo[i][hWeapons][slot-1], weaponname, sizeof(weaponname));
					GivePlayerValidWeapon(playerid, HouseInfo[i][hWeapons][slot-1]);
					HouseInfo[i][hWeapons][slot-1] = 0;
					if(strcmp(weaponname, "silenced pistol", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Sdpistol tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau Sdpistol tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "desert eagle", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Deagle tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau Deagle tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "shotgun", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Shotgun tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau Shotgun tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "combat shotgun", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Combat Shotgun tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau Combat Shotgun tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "mp5", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung MP5 tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau MP5 tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "ak47", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung AK-47 tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau AK-47 tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "m4", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung M4 tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau M4 tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "rifle", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Rifle tu trong tu do.");
						format(string,sizeof(string), "* %s da rut ra mot khau Rifle tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "sniper rifle", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Sniper Rifle tu trong tu do.");
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
						format(string,sizeof(string), "* %s da rut ra mot khau Sniper Rifle tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					if(strcmp(weaponname, "micro smg", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Uzi tu trong tu do.");
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
						format(string,sizeof(string), "* %s da rut ra mot khau Uzi tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					if(strcmp(weaponname, "tec9", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da lay 1 khau sung Tec-9 tu trong tu do.");
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
						format(string,sizeof(string), "* %s da rut ra mot khau Tec-9 tu trong tu do nha ra va cam tren tay.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					SaveHouse(i);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co vu khi nao o slot nay ca.");
					return 1;
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu ngoi nha nay.");
	return 1;
}


CMD:hwithdraw(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				new itemid, amount, string[128];

				if(sscanf(params, "dd", itemid, amount))
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hwithdraw [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Meth - (6) Ecstasy - (7) Heroin");
					return 1;
				}
				if(itemid < 1 || itemid > 7) {
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hwithdraw [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Meth - (6) Ecstasy - (7) Heroin");
					return 1;
				}

				if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't withdraw less than 1.");

				switch(itemid)
				{
					case 1: // Cash
					{
						if(HouseInfo[i][hSafeMoney] >= amount)
						{
							HouseInfo[i][hSafeMoney] -= amount;
							GivePlayerCash(playerid, amount);
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "Ban da rut ra $%d from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn $%d from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to withdraw!");
					}
					case 2: // Pot
					{
						if(HouseInfo[i][hPot] >= amount)
						{
							HouseInfo[i][hPot] -= amount;
							PlayerInfo[playerid][pDrugs][0] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "Ban da rut ra %d Pot from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d Pot from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to withdraw!");
					}
					case 3: // Crack
					{
						if(HouseInfo[i][hCrack] >= amount)
						{
							HouseInfo[i][hCrack] -= amount;
							PlayerInfo[playerid][pDrugs][1] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "Ban da rut ra %d crack from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d crack from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to withdraw!");
					}
					case 4: // Materials
					{
						if(HouseInfo[i][hMaterials] >= amount)
						{
							HouseInfo[i][hMaterials] -= amount;
							PlayerInfo[playerid][pMats] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "Ban da rut ra %d materials from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d materials from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to withdraw!");
					}
					case 5: // Meth
					{
						if(HouseInfo[i][hMeth] >= amount)
						{
							HouseInfo[i][hMeth] -= amount;
							PlayerInfo[playerid][pDrugs][2] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "Ban da rut ra %d meth from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d meth from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to withdraw!");
					}
					case 6: // Ecstasy
					{
						if(HouseInfo[i][hEcstasy] >= amount)
						{
							HouseInfo[i][hEcstasy] -= amount;
							PlayerInfo[playerid][pDrugs][3] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "Ban da rut ra %d ecstasy from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d ecstasy from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to withdraw!");
					}
					case 7: // Heroin
					{
						if(HouseInfo[i][hHeroin] >= amount)
						{
							HouseInfo[i][hHeroin] -= amount;
							PlayerInfo[playerid][pDrugs][4] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "Ban da rut ra %d heroin from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d heroin from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to withdraw!");
					}
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha.");
	return 1;
}

CMD:hdeposit(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				new string[128], itemid, amount;

				if(sscanf(params, "dd", itemid, amount))
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hdeposit [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Meth - (6) Ecstasy - (7) Heroin");
					return 1;
				}
				if(itemid < 1 || itemid > 7) {
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hdeposit [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Meth - (6) Ecstasy - (7) Heroin");
					return 1;
				}

				if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't deposit less than 1.");
				switch(itemid)
				{
					case 1: // Cash
					{
						if(PlayerInfo[playerid][pCash] >= amount) PlayerInfo[playerid][pCash] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to deposit!");

						HouseInfo[i][hSafeMoney] += amount;
						format(string, sizeof(string), "Ban da gui $%d to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited $%d into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 2: // Pot
					{
						if(PlayerInfo[playerid][pDrugs][0] >= amount) PlayerInfo[playerid][pDrugs][0] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to deposit!");

						HouseInfo[i][hPot] += amount;
						format(string, sizeof(string), "Ban da gui %d Pot to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d Pot into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 3: // Crack
					{
						if(PlayerInfo[playerid][pDrugs][1] >= amount) PlayerInfo[playerid][pDrugs][1] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to deposit!");

						HouseInfo[i][hCrack] += amount;
						format(string, sizeof(string), "Ban da gui %d Crack to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d crack into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 4: // Materials
					{
						if(PlayerInfo[playerid][pMats] >= amount) PlayerInfo[playerid][pMats] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to deposit!");

						HouseInfo[i][hMaterials] += amount;
						format(string, sizeof(string), "Ban da gui %d Materials to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d materials into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 5: // Meth
					{
						if(PlayerInfo[playerid][pDrugs][2] >= amount) PlayerInfo[playerid][pDrugs][2] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to deposit!");

						HouseInfo[i][hMeth] += amount;
						format(string, sizeof(string), "Ban da gui %d Meth to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d meth into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 6: // Ecstasy
					{
						if(PlayerInfo[playerid][pDrugs][3] >= amount) PlayerInfo[playerid][pDrugs][3] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to deposit!");

						HouseInfo[i][hEcstasy] += amount;
						format(string, sizeof(string), "Ban da gui %d Ecstasy to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d Ecstasy into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 7: // Heroin
					{
						if(PlayerInfo[playerid][pDrugs][4] >= amount) PlayerInfo[playerid][pDrugs][4] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough to deposit!");

						HouseInfo[i][hHeroin] += amount;
						format(string, sizeof(string), "Ban da gui %d Heroin to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d heroin into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha.");
	return 1;
}

/*
CMD:workbench(playerid, params[]) {
        new szType[10], iChoice, iAmount, houseid;
        if(sscanf(params, "s[6]ii", szType, iChoice, iAmount)) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /workbench [type] [choice] [amount]");
            SendClientMessageEx(playerid, COLOR_GRAD2, "TYPE: melee, gun");
            SendClientMessageEx(playerid, COLOR_GRAD2, "CHOICE GUN: 9mm (0), SDPistol (1), Shotgun (2), Rifle (3)");
            SendClientMessageEx(playerid, COLOR_GRAD2, "CHOICE MELEE: Brass Knuckles (0), Baseball Bat (1), Shovel (2), Pool Cue (3), Cane (4)");
            return SendClientMessageEx(playerid, COLOR_GRAD2, "CHOICE MELEE: Dildo (5), Vibrator (6), Katana (7), Flowers (8), SprayCan (9)");
        }
        for(new i = 0; i < 3; i++)
        {
            if(i == 0) houseid = PlayerInfo[playerid][pPhousekey];
            if(i == 1) houseid = PlayerInfo[playerid][pPhousekey2];
            if(i == 2) houseid = PlayerInfo[playerid][pPhousekey3];
            if(houseid != INVALID_HOUSE_ID && HouseInfo[houseid][hOwnerID] == GetPlayerSQLId(playerid) && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[houseid][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[houseid][hIntIW])
            {
       			if(iAmount <= 0) return SendClientMessageEx(playerid, -1, "You can't have negative amount values.");
				if(strcmp(szType,"melee",true) == 0)
				{
           			if(playerid != INVALID_PLAYER_ID && iChoice >= 0 || iChoice <= 9)
           	   		  	{
                    		if(PlayerInfo[playerid][pMats] < 150) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du vat lieu de san xuat vu khi.");
                    		if(PlayerInfo[playerid][pMats] < 2000 && iChoice == 9) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du vat lieu de san xuat vu khi.");
                    		switch(iChoice)
                    		{
                    			case 0: GivePlayerValidWeapon(playerid, WEAPON_BRASSKNUCKLE);
								case 1: GivePlayerValidWeapon(playerid, WEAPON_BAT);
								case 2: GivePlayerValidWeapon(playerid, WEAPON_SHOVEL);
								case 3: GivePlayerValidWeapon(playerid, WEAPON_POOLSTICK);
								case 4: GivePlayerValidWeapon(playerid, WEAPON_CANE);
								case 5:	GivePlayerValidWeapon(playerid, WEAPON_DILDO);
								case 6:	GivePlayerValidWeapon(playerid, WEAPON_VIBRATOR);
								case 7:	GivePlayerValidWeapon(playerid, WEAPON_KATANA);
								case 8: GivePlayerValidWeapon(playerid, WEAPON_FLOWER);
								case 9: GivePlayerValidWeapon(playerid, WEAPON_SPRAYCAN);
                    		}
                    		if(iChoice == 9) { PlayerInfo[playerid][pMats] -= 1850; }
                    		PlayerInfo[playerid][pMats] -= 150;
                    		format(szMiscArray, sizeof(szMiscArray), "Ban da che tao ra mot melee weapon.", iAmount);
                    		return SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
               			}
				}
				if(strcmp(szType,"gun",true) == 0)
				{
            		if(playerid != INVALID_PLAYER_ID && iChoice >= 0 || iChoice <= 3)
               		{
                   		switch(iChoice)
                   		{
                   			case 0:
                   			{
                   				if(PlayerInfo[playerid][pMats] < 3000) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du vat lieu de san xuat vu khi.");
                   				GivePlayerValidWeapon(playerid, WEAPON_COLT45);
                   				PlayerInfo[playerid][pMats] -= 3000;
                    			format(szMiscArray, sizeof(szMiscArray), "Ban da che tao ra mot 9mm weapon.", iAmount);
                   			}
                   			case 1:
                   			{
                   				if(PlayerInfo[playerid][pMats] < 3000) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du vat lieu de san xuat vu khi.");
                   				GivePlayerValidWeapon(playerid, WEAPON_SILENCED);
                   				PlayerInfo[playerid][pMats] -= 3000;
                    			format(szMiscArray, sizeof(szMiscArray), "Ban da che tao ra mot Silenced weapon.", iAmount);
                   			}
                   			case 2:
                   			{
                   				if(PlayerInfo[playerid][pMats] < 4000) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du vat lieu de san xuat vu khi.");
                   				GivePlayerValidWeapon(playerid, WEAPON_SHOTGUN);
                   				PlayerInfo[playerid][pMats] -= 4000;
                    			format(szMiscArray, sizeof(szMiscArray), "Ban da che tao ra mot Shotgun weapon.", iAmount);
                   			}
                   			case 3:
                   			{
                   				if(PlayerInfo[playerid][pMats] < 4000) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du vat lieu de san xuat vu khi.");
                   				GivePlayerValidWeapon(playerid, WEAPON_RIFLE);
                   				PlayerInfo[playerid][pMats] -= 4000;
                    			format(szMiscArray, sizeof(szMiscArray), "Ban da che tao ra mot Country Rifle weapon.", iAmount);
                   			}
                   		}
                    	return SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
                	}
            	}
       		}
        	SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung tai a house you own.");
    	}
		return 1;
}*/

CMD:hbalance(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				new string[128];
				SendClientMessageEx(playerid, COLOR_GREEN, "|________________________________TAI SAN TRONG NHA_________________________________|");
				format(string, sizeof(string), "Tien: $%s | Pot: %s | Crack: %s | Vat lieu: %s | Meth: %s | Ecstasy: %s | Heroin: %s", number_format(HouseInfo[i][hSafeMoney]), number_format(HouseInfo[i][hPot]), number_format(HouseInfo[i][hCrack]), number_format(HouseInfo[i][hMaterials]), number_format(HouseInfo[i][hMeth]), number_format(HouseInfo[i][hEcstasy]), number_format(HouseInfo[i][hHeroin]));
				SendClientMessageEx(playerid, COLOR_WHITE, string);

				SendClientMessageEx(playerid, COLOR_GREEN, "|__________________________________________________________________________________|");
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha.");
	return 1;
}

CMD:closet(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(HouseInfo[i][hClosetX] != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]))
					{
						return DisplaySkins(playerid);
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't near your closet!");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a closet in this house!");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha.");
	return 1;
}

CMD:closetadd(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(HouseInfo[i][hClosetX] != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]))
					{
						CountSkins(playerid);
						if((PlayerInfo[playerid][pDonateRank] <= 0 && PlayerInfo[playerid][pSkins] <= 10)	 || (PlayerInfo[playerid][pDonateRank] > 0 && PlayerInfo[playerid][pSkins] <= 25))
						{
							new string[128];
							new skinid = GetPlayerSkin(playerid);
							AddSkin(playerid, skinid);
							format(string, sizeof(string), "You have added skin ID %d to your closet.", skinid);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "Your closet doesn't have anymore space for clothes!");
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't near your closet!");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a closet in this house!");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha.");
	return 1;
}

CMD:closetremove(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(HouseInfo[i][hClosetX] != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]))
					{
						new query[128];
						mysql_format(MainPipeline, query, sizeof(query), "SELECT `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
						mysql_tquery(MainPipeline, query, "SkinQueryFinish", "ii", playerid, Skin_Query_Delete);
						return 1;
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't near your closet!");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a closet in this house!");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nha noi ban dang so huu.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha.");
	return 1;
}

CMD:vut(playerid, params[])
{
	new string[128], amount, choice[32];
	if(sscanf(params, "s[32]D(0)", choice, amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /vut [lua chon] [so luong]");
		SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: weapons, vatlieu, Packages, Radio, Pizza, Syringes, Backpack, dienthoai");
		SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: Pot, Crack, Meth, Ecstasy, Heroin");
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "LUU Y: /vut weapons la vut tat ca vu khi tren nguoi ban, hay dung lenh /vutvukhi");
		return 1;
	}
	else if(strcmp(choice,"backpack",true) == 0)
	{
		if(PlayerInfo[playerid][pBackpack] > 0)
		{
			ShowPlayerDialogEx(playerid, DIALOG_BDROP, DIALOG_STYLE_MSGBOX, "Xac nhan vut Backpack", "{FFFFFF}Ban co chac chan vut bo Backpack cua minh khong?\n{FF8000}Luu y{FFFFFF}: Neu xac nhan thi Backpack se bi mat {FF0000}vinh vien{FFFFFF}", "Xac nhan", "Huy");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co backpack!");
		}
	}
	else if(strcmp(choice,"syringes",true) == 0)
	{
		if(PlayerInfo[playerid][pSyringes] > 0)
		{
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Vui long ghi so luong");
			if(amount > PlayerInfo[playerid][pSyringes]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du so luong syringes do de vut bo!");
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "Ban da vut %d syringes.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pSyringes] -= amount;
			format(string, sizeof(string), "* %s da vut bo syringes cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co syringes!");
		}
	}
	else if(strcmp(choice,"pot",true) == 0)
	{
		if(PlayerInfo[playerid][pDrugs][0] > 0)
		{
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Vui long ghi so luong");
			if(amount > PlayerInfo[playerid][pDrugs][0]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du so luong pot do de vut bo!");
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "Ban da vut bo %d pot.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pDrugs][0] -= amount;
			format(string, sizeof(string), "* %s da vut bo pot cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co pot!");
		}
	}
	else if(strcmp(choice,"crack",true) == 0)
	{
		if(PlayerInfo[playerid][pDrugs][1] > 0)
		{
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Vui long ghi so luong");
			if(amount > PlayerInfo[playerid][pDrugs][1]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du so luong crack do de vut bo!");
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "Ban da vut bo %d crack.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pDrugs][1] -= amount;
			format(string, sizeof(string), "* %s da vut bo crack cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co crack!");
		}
	}
	else if(strcmp(choice,"meth",true) == 0)
	{
		if(PlayerInfo[playerid][pDrugs][2] > 0)
		{
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Vui long ghi so luong");
			if(amount > PlayerInfo[playerid][pDrugs][2]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du so luong meth do de vut bo!");
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "Ban da vut bo %d meth.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pDrugs][2] -= amount;
			format(string, sizeof(string), "* %s da vut bo meth cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co meth");
		}
	}
	else if(strcmp(choice,"ecstasy",true) == 0)
	{
		if(PlayerInfo[playerid][pDrugs][3] > 0)
		{
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Vui long ghi so luong");
			if(amount > PlayerInfo[playerid][pDrugs][3]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du so luong ecstasy do de vut bo!");
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "Ban da vut bo %d ecstasy.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pDrugs][3] -= amount;
			format(string, sizeof(string), "* %s da vut bo ecstasy cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co ecstasy!");
		}
	}
	else if(strcmp(choice,"heroin",true) == 0)
	{
		if(PlayerInfo[playerid][pDrugs][4] > 0)
		{
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Vui long ghi so luong");
			if(amount > PlayerInfo[playerid][pDrugs][4]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du so luong heroin do de vut bo!");
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "Ban da vut bo %d heroin.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pDrugs][4] -= amount;
			format(string, sizeof(string), "* %s da vut bo heroin cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co heroin!");
		}
	}

	else if(strcmp(choice,"vatlieu",true) == 0)
	{
		if(PlayerInfo[playerid][pMats] > 0)
		{
			if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Vui long ghi so luong");
			if(amount > PlayerInfo[playerid][pMats]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du so luong vat lieu do de vut bo!");
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "Ban da vut bo %d vat lieu.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "* %s da vut bo vat lieu cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			PlayerInfo[playerid][pMats] -= amount;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co vat lieu!");
		}
	}
	else if(strcmp(choice,"radio",true) == 0)
	{
		if(PlayerInfo[playerid][pRadio] != 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s da vut bo radio cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			PlayerInfo[playerid][pRadio] = 0;
			PlayerInfo[playerid][pRadioFreq] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co radio!");
		}
	}
	else if(strcmp(choice,"weapons",true) == 0)
	{
		if(GetPVarType(playerid, "IsInArena"))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay trong dau truong");
			return 1;
		}
		if(GetPVarInt( playerid, "EventToken") != 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay trong su kien!");
			return 1;
		}
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		ResetPlayerWeaponsEx(playerid);
		format(string, sizeof(string), "* %s da vut bo vu khi cua ho.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else if(strcmp(choice,"packages",true) == 0)
	{
		if(GetPVarInt(playerid, "Packages") > 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s da vut goi vat lieu cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			DeletePVar(playerid, "Packages");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Hien ban khong giao bat ki goi vat lieu nao!");
		}
	}
	else if(strcmp(choice,"pizza",true) == 0)
	{
		if(GetPVarType(playerid, "Pizza"))
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s da vut bo banh pizza cua ho di.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            DeletePVar(playerid, "Pizza");
			DeletePVar(playerid, "pizzaTimer");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Hien ban khong giao bat ki banh pizza nao!");
		}
	}
	else if(strcmp(choice,"dienthoai", true) == 0)
	{
		if(PlayerInfo[playerid][pPnumber] != 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s da vut dien thoai cua ho di.", GetPlayerNameEx(playerid));
			ProxChatBubble(playerid, string);
			PlayerInfo[playerid][pPnumber] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co dien thoai.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /vut [lua chon] [so luong]");
		SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: weapons, vatlieu, Packages, Radio, Pizza, Syringes, Backpack, dienthoai");
		return SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: Pot, Crack, Meth, Ecstasy, Heroin");
	}
	return 1;
}

CMD:show(playerid, params[])
{
	new string[128], giveplayerid, choice[32];
	if(sscanf(params, "us[32]", giveplayerid, choice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /choxem [player] [lua chon]");
		SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: Pot, Crack, Meth, Ecstasy, Heroin, vatlieu, Credit");
		return 1;
	}

	if(giveplayerid == playerid)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the dung lenh nay voi chinh minh!");
		return 1;
	}

	if(IsPlayerConnected(giveplayerid))
	{
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			if (!ProxDetectorS(5.0, playerid, giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
				return 1;
			}

			if (strcmp(choice, "vatlieu", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pMats];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co vat lieu!");
					return 1;
			    }
				format(string, sizeof(string), "%s da cho ban xem %d vat lieu cua ho.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "Ban da cho %s xem %d vat lieu cua ban.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s da cho %s xem vat lieu cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if (strcmp(choice, "pot", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pDrugs][0];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co pot!");
					return 1;
			    }
				format(string, sizeof(string), "%s da cho ban xem %d pot cua ho.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "Ban da cho %s xem %d pot cua ban.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s da cho %s xem pot cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if (strcmp(choice, "crack", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pDrugs][1];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co crack!");
					return 1;
			    }
				format(string, sizeof(string), "%s da cho ban xem %d crack cua ho.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "Ban da cho %s xem %d crack cua ban.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s da cho %s xem crack cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if (strcmp(choice, "meth", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pDrugs][2];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co meth!");
					return 1;
			    }
				format(string, sizeof(string), "%s da cho ban xem %d meth cua ho.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "Ban da cho %s xem %d meth cua ban.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s da cho %s xem meth cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if (strcmp(choice, "ecstasy", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pDrugs][3];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co ecstasy!");
					return 1;
			    }
				format(string, sizeof(string), "%s da cho ban xem %d ecstasy cua ho.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "Ban da cho %s xem %d ecstasy cua ban.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s da cho %s xem ecstasy cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
   			if (strcmp(choice, "heroin", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pDrugs][4];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co heroin!");
					return 1;
			    }
				format(string, sizeof(string), "%s da cho ban xem %d heroin cua ho",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "Ban da cho %s xem %d heroin cua ban.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s da cho %s xem heroin cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if (strcmp(choice, "credit", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pCredits];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co credit!");
					return 1;
			    }
				format(string, sizeof(string), "%s da cho ban xem %d credit cua ho.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "Ban da cho %s xem %d credit cua ban.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s da cho %s xem credit cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
		}
	}
	return 1;
}

CMD:sell(playerid, params[])
{
	new string[128], giveplayerid, choice[32], amount, price;
    if(sscanf(params, "us[32]dd", giveplayerid, choice, amount, price))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /buonban [player] [lua chon] [so luong] [gia]");
		SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: Rimkit, PVIPVoucher");
		return 1;
	}
	if(PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "pBagged") >= 1 ||PlayerInfo[playerid][pHospital] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
	if(GetPVarInt(playerid, "WatchingTV")) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay khi dang xem TV!");
	if(price < 50000) return SendClientMessageEx(playerid, COLOR_GREY, "Gia khong duoc thap hon $50,000.");
	if(price > 50000000) return SendClientMessageEx(playerid, COLOR_GREY, "Gia khong duoc thap hon $50,000,000.");
	if(price > 100000000)
	{
		format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s is trying to sell %s to %s for $%d.", GetPlayerNameEx(playerid), choice, GetPlayerNameEx(giveplayerid), price);
		ABroadCast(COLOR_YELLOW, string, 2);
	}
	if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "So luong khong duoc thap hon 1.");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong ton tai.");
	if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay voi chinh minh!");
	if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");

    else if (strcmp(choice, "rimkit", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pRimMod])
			return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co rimkit");

		format(string, sizeof(string), "Ban de nghi %s mua %d Rimkit voi gia $%s.", GetPlayerNameEx(giveplayerid), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "%s de nghi ban mua %d Rimkit voi gia $%s, (/chapnhan rimkit) de mua.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(giveplayerid, "RimOffer", playerid);
	 	SetPVarInt(giveplayerid, "RimPrice", price);
	 	SetPVarInt(giveplayerid, "RimCount", amount);
	 	SetPVarInt(giveplayerid, "RimSeller_SQLId", GetPlayerSQLId(playerid));
	}
	else if (strcmp(choice, "pvipvoucher", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pPVIPVoucher])
			return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co PVIP Voucher.");

		format(string, sizeof(string), "Ban de nghi %s mua %d PVIP Voucher (1 thang) voi gia $%s.", GetPlayerNameEx(giveplayerid), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "%s de nghi ban mua %d PVIP Voucher (1 thang) voi gia $%s, (/chapnhan pvipvoucher) de mua.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(giveplayerid, "PVIPVoucherOffer", playerid);
	 	SetPVarInt(giveplayerid, "PVIPVoucherPrice", price);
	 	SetPVarInt(giveplayerid, "PVIPVoucherCount", amount);
	 	SetPVarInt(giveplayerid, "PVIPVoucherSeller_SQLId", GetPlayerSQLId(playerid));
	}
	return 1;

}
