#include <YSI\y_hooks>

#define ATM					10000
#define ATM_AMOUNT 			10001
#define ATM_TRANSFER_TO		10002
#define ATM_TRANSFER_AMT	10003

new ATMPoint[43]; 

LoadATMPoints() {
	
	ATMPoint[0] = CreateDynamicSphere(2065.439453125, -1897.5510253906, 13.19670009613, 3.0); // Willowfield
	ATMPoint[1] = CreateDynamicSphere(1497.7467041016, -1749.8747558594, 15.088212013245, 3.0); // CityHall LS
	ATMPoint[2] = CreateDynamicSphere(2093.5124511719, -1359.5474853516, 23.62727355957, 3.0); // Jefferson
	ATMPoint[3] = CreateDynamicSphere(1155.6235351563, -1464.9141845703, 15.44321346283, 3.0); // Market
	ATMPoint[4] = CreateDynamicSphere(2139.4487304688, -1164.0811767578, 23.63508605957, 3.0); // Glen Park
	ATMPoint[5] = CreateDynamicSphere(1482.7761230469, -1010.3353881836, 26.48664855957, 3.0); // Mullholand Bank
	ATMPoint[6] = CreateDynamicSphere(387.16552734375, -1816.0512695313, 7.4834146499634, 3.0); // Santa Maria Beach
	ATMPoint[7] = CreateDynamicSphere(-24.385023117065, -92.001075744629, 1003.1897583008, 3.0); // bug object
	ATMPoint[8] = CreateDynamicSphere(-31.811220169067, -58.106018066406, 1003.1897583008, 3.0); // bug object
	ATMPoint[9] = CreateDynamicSphere(1212.7785644531, 2.451762676239, 1000.5647583008, 3.0); // Bug object
	ATMPoint[10] = CreateDynamicSphere(2324.4028320313, -1644.9445800781, 14.469946861267, 3.0); // Ganton
	ATMPoint[11] = CreateDynamicSphere(2228.39, -1707.78, 13.25, 3.0); // Ganton
	ATMPoint[12] = CreateDynamicSphere(651.19305419922, -520.48815917969, 15.978837013245, 3.0); // Dillimore 
	ATMPoint[13] = CreateDynamicSphere(45.78035736084, -291.80926513672, 1.5024013519287, 3.0); // BB
	ATMPoint[14] = CreateDynamicSphere(1275.7958984375, 368.31481933594, 19.19758605957, 3.0); // Montgomery
	ATMPoint[15] = CreateDynamicSphere(2303.4577636719, -13.539554595947, 26.12727355957, 3.0); // Palomino creek
	ATMPoint[16] = CreateDynamicSphere(294.80, -84.01, 1001.0, 3.0); // Bug object
	ATMPoint[17] = CreateDynamicSphere(691.08215332031, -618.5625, 15.978837013245, 3.0); // Dillimore
	ATMPoint[18] = CreateDynamicSphere(173.23471069336, -155.07606506348, 1.2210245132446, 3.0); // BlueB
	ATMPoint[19] = CreateDynamicSphere(1260.8796386719, 209.30152893066, 19.19758605957, 3.0); // Montgomery
	ATMPoint[20] = CreateDynamicSphere(2316.1015625, -88.522567749023, 26.12727355957, 3.0); // Palomino Creek
	ATMPoint[21] = CreateDynamicSphere(1311.0361,-1446.2249,0.2216, 3.0); // Paintball
	ATMPoint[22] = CreateDynamicSphere(2565.667480, 1406.839355, 7699.584472, 3.0); // LSVIP
	ATMPoint[23] = CreateDynamicSphere(1829.5000, 1391.0000, 1464.0000, 3.0); // LVVIP
	ATMPoint[24] = CreateDynamicSphere(883.7170, 1442.4282, -82.3370, 3.0); // Famed Hq
	ATMPoint[25] = CreateDynamicSphere(986.4434,2056.2480,1085.8531, 3.0); // Casino ATM1
	ATMPoint[26] = CreateDynamicSphere(1014.1396,2060.8284,1085.8531, 3.0); // Casino ATM2
	ATMPoint[27] = CreateDynamicSphere(1013.4720,2023.8784,1085.8531, 3.0); // Casino ATM3
	ATMPoint[28] = CreateDynamicSphere(985.53719, 2056.1026, 1085.5, 3.0); // Casino ATM4
	ATMPoint[29] = CreateDynamicSphere(1014.48039, 2023.90137, 1085.5, 3.0); // Casino ATM5
	ATMPoint[30] = CreateDynamicSphere(1014.1004, 2061.80117, 1085.5, 3.0); // Casino ATM6
	ATMPoint[31] = CreateDynamicSphere(218.18401, 1809.87610, 2000.68555, 3.0);  // Lucky Cowboy Casino
	ATMPoint[32] = CreateDynamicSphere(-1981.29394, 121.52153, 27.68750, 3.0);  // HQ Taxi SF
	ATMPoint[33] = CreateDynamicSphere(1361.9102, 2523.3557, 15.6768, 3.0); // Gucci Gang
	ATMPoint[34] = CreateDynamicSphere(2318.6352, -1137.0861, 1050.7031, 3.0); // house



	// for(new i = 0; i < 37; i++) Streamer_SetIntData(STREAMER_TYPE_AREA, ATMPoint[i], E_STREAMER_EXTRA_ID, i);

	print("[Streamer] ATM Points Loaded");

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if((newkeys & KEY_YES) && IsPlayerInAnyDynamicArea(playerid))
	{
		new areaid[1];
		GetPlayerDynamicAreas(playerid, areaid); //Assign nearest areaid.
		// new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid[0], E_STREAMER_EXTRA_ID);
		for(new i; i < sizeof(ATMPoint); ++i) {

			if(areaid[0] == ATMPoint[i]) {
				
				format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s dang tuong tac voi ATM.", GetPlayerNameEx(playerid));
				//ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 15.0, 5000);
				ShowATMMenu(playerid);
			}
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case ATM: {
			
			if(!response) {
				TogglePlayerControllable(playerid, 1);
				return 1;
			}

			TogglePlayerControllable(playerid, 0);

			switch(listitem) {		
				case 0: ShowATMMenu(playerid, 1);
				case 1: ShowATMMenu(playerid, 2);
				case 2: ShowATMMenu(playerid, 3);
			}
		}

		case ATM_AMOUNT: {
			if(!response) {
				DeletePVar(playerid, "ATMWithdraw");
				DeletePVar(playerid, "ATMDeposit");
				return ShowATMMenu(playerid);
			}

			new 
				iAmount = strval(inputtext);

			if(GetPVarType(playerid, "ATMWithdraw")) {
				
				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "So luong am khong the chuyen tien!");
					return ShowATMMenu(playerid, 1);
				}

				if(iAmount > PlayerInfo[playerid][pAccount]) {
					SendClientMessageEx(playerid, COLOR_WHITE, "Ban da rut tien nhieu hon nhung gi ban co!");
					return ShowATMMenu(playerid, 1);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "Sau 10 giay ban moi co the thuc hien giao dich, vui long doi!");
					return ShowATMMenu(playerid, 1);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
				
				if(!Bank_TransferCheck(-iAmount)) return 1;
				GivePlayerCash(playerid, iAmount);
				PlayerInfo[playerid][pAccount] -= iAmount; 
				format(szMiscArray, sizeof(szMiscArray), "Ban da rut $%s tu tai khoan cua minh. ", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				if(PlayerInfo[playerid][pDonateRank] == 0) {
					new fee;
					fee = 2*iAmount/100;
					if(!Bank_TransferCheck(-fee)) return 1;
					PlayerInfo[playerid][pAccount] -= fee;
					format(szMiscArray, sizeof(szMiscArray), "Phi giao dich la 2 phan tram: -$%d.", fee);
					SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				}

				OnPlayerStatsUpdate(playerid);

				DeletePVar(playerid, "ATMWithdraw");

				return ShowATMMenu(playerid);
			}
			else if(GetPVarType(playerid, "ATMDeposit")) {

				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "So tien am nen khong the chuyen duoc!");
					return ShowATMMenu(playerid, 2);
				}

				if(iAmount > GetPlayerCash(playerid)) {
					SendClientMessageEx(playerid, COLOR_WHITE, "So du trong tai khoan cua ban khong du!");
					return ShowATMMenu(playerid, 2);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "Sau 10 giay ban moi co the thuc hien giao dich, vui long doi!");
					return ShowATMMenu(playerid, 2);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
				
				if(!Bank_TransferCheck(iAmount)) return 1;
				GivePlayerCash(playerid, -iAmount);
				PlayerInfo[playerid][pAccount] += iAmount; 
				format(szMiscArray, sizeof(szMiscArray), "Ban da gui $%s vao tai khoan cua minh.", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				if(PlayerInfo[playerid][pDonateRank] == 0) {
					new fee;
					fee = 2*iAmount/100;
					if(!Bank_TransferCheck(-fee)) return 1;
					PlayerInfo[playerid][pAccount] -= fee;
					format(szMiscArray, sizeof(szMiscArray), "Phi giao dich la 2 phan tram: -$%d.", fee);
					SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				}

				OnPlayerStatsUpdate(playerid);

				DeletePVar(playerid, "ATMDeposit");

				return ShowATMMenu(playerid);
			}
		}

		case ATM_TRANSFER_TO: {
			
			if(!response) {
				return ShowATMMenu(playerid);
			}

			new id = strval(inputtext);
			
			if(!IsPlayerConnected(id) || !gPlayerLogged{id}) {
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
				return ShowATMMenu(playerid, 3);
			}

			SetPVarInt(playerid, "ATMTransferTo", id);
			return ShowATMMenu(playerid, 4);
		}

		case ATM_TRANSFER_AMT: {

			if(!response) {
				DeletePVar(playerid, "ATMTransferTo");
				return ShowATMMenu(playerid, 3);
			}

			new 
				id = GetPVarInt(playerid, "ATMTransferTo"),
				iAmount = strval(inputtext);


			if(restarting) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Giao dich hien tai dang bi khoa vi ly do may chu sap duoc bao tri.");
				return ShowATMMenu(playerid, 3);
			}
			if(PlayerInfo[playerid][pLevel] < 3) {
				SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai cap do 3 moi dung duoc tinh nang nay!");
				return ShowATMMenu(playerid, 3);
			}
			if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Sau 10 giay ban moi co the thuc hien giao dich, vui long doi!");
				return ShowATMMenu(playerid, 3);
			}

			if(iAmount > PlayerInfo[playerid][pAccount] || iAmount < 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang co gang gui so tien nhieu hon ban dang co!");

			if(PlayerInfo[playerid][pDonateRank] == 0) {
				new fee;
				fee = 2*iAmount/100;
				PlayerInfo[playerid][pAccount] -= fee;
				format(szMiscArray, sizeof(szMiscArray), "Phi giao dich la 2 phan tram: -$%d.", fee);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			}

			// Use these as they update the MySQL Directly with less function calls
			GivePlayerCashEx(playerid, TYPE_BANK, -iAmount);
			GivePlayerCashEx(id, TYPE_BANK, iAmount);

			format(szMiscArray, sizeof(szMiscArray), "Ban da chuyen $%s den tai khoan cua %s.", number_format(iAmount), GetPlayerNameEx(id));
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			
			format(szMiscArray, sizeof(szMiscArray), "So tien $%s da duoc chuyen vao tai khoan cua ban boi %s.", number_format(iAmount), GetPlayerNameEx(playerid));
			SendClientMessageEx(id, COLOR_YELLOW, szMiscArray);

			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);
				
				
			new ip[32], ipex[32];
			GetPlayerIp(playerid, ip, sizeof(ip));
			GetPlayerIp(id, ipex, sizeof(ipex));
			format(szMiscArray, sizeof(szMiscArray), "[ATM] %s(%d) (IP:%s) da chuyen $%s to %s(%d) (IP:%s).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), GetPlayerSQLId(id), ipex);
			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) Log("logs/adminpay.log", szMiscArray); else Log("logs/pay.log", szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: (ATM) %s (IP:%s) has da chuyen $%s to %s (IP:%s).", GetPlayerNameEx(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), ipex);
			

			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: (ATM) %s da chuyen $%s cho %s.", GetPlayerNameEx(playerid), number_format(iAmount), GetPlayerNameEx(id));
				if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(id), true)) strcat(szMiscArray, " (1)");
				ABroadCast(COLOR_YELLOW,szMiscArray, 4);
			}
			else ABroadCast(COLOR_YELLOW,szMiscArray,2);
			
			SetPVarInt(playerid, "LastTransaction", gettime());
			DeletePVar(playerid, "ATMTransferTo");

			return ShowATMMenu(playerid);
		}
	}
	return 0;
}


forward ForgetATM(playerid);
public ForgetATM(playerid) {
	DeletePVar(playerid, "AtATM");
	return 1;
}

ShowATMMenu(playerid, menu = 0) {

	new szTitle[48];

	szMiscArray[0] = 0;

	format(szTitle, sizeof(szTitle), "ATM Menu ($%s)", number_format(PlayerInfo[playerid][pAccount]));

	if(PlayerInfo[playerid][pFreezeBank] == 1) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, szTitle, "Your assets have been frozen! Contact judicial!", "Ok", "");

	switch(menu) {

		case 0: { // main menu
			ShowPlayerDialogEx(playerid, ATM, DIALOG_STYLE_LIST, szTitle, "Rut tien\nGui tien\nChuyen tien", "Chon", "Huy");
		}

		case 1: { // iAmount withdraw
			ShowPlayerDialogEx(playerid, ATM_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Hay nhap so tien ban muon rut khoi tai khoan.", "Xac nhan", "Huy");
			SetPVarInt(playerid, "ATMWithdraw", 1);
		}

		case 2: { // iAmount deposit
			ShowPlayerDialogEx(playerid, ATM_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Hay nhap so tien ban muon gui vao tai khoan.", "Xac nhan", "Huy");
			SetPVarInt(playerid, "ATMDeposit", 1);
		}

		case 3: { // transfer to
			ShowPlayerDialogEx(playerid, ATM_TRANSFER_TO, DIALOG_STYLE_INPUT, szTitle, "Hay nhap ID nguoi choi ban muon chuyen tien.", "Tiep tuc", "Huy");
		}

		case 4: { // transfer iAmount
			format(szMiscArray, sizeof(szMiscArray), "Hay nhap so tien ban muon chuyen cho {FF0000}%s", GetPlayerNameEx(GetPVarInt(playerid, "ATMTransferTo")));
			ShowPlayerDialogEx(playerid, ATM_TRANSFER_AMT, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Xac nhan", "Huy");
		}
	}

	return 1;
}
