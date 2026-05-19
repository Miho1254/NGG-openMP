#include <YSI\y_hooks>

#define BANK					10004
#define BANK_AMOUNT 			10005
#define BANK_TRANSFER_TO		10006
#define BANK_TRANSFER_AMT		10007


// use the below for bank VWs so that all actors are created properly.
#define BANK_RODEO			1
#define BANK_MULLHOLLAND	2
#define BANK_SF				3
#define BANK_LV				4
#define BANK_DILLIMORE		5
#define BANK_LASBARANCAS	6

new Bankers[12];
new BankPoint[12];

LoadBanks() {

	// rodeo
	Bankers[0] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[1] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[0], BANK_RODEO);
	SetActorVirtualWorld(Bankers[1], BANK_RODEO);

	// mullholland
	Bankers[2] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[3] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[2], BANK_MULLHOLLAND);
	SetActorVirtualWorld(Bankers[3], BANK_MULLHOLLAND);

	// san fierro
	Bankers[4] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[5] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[4], BANK_SF);
	SetActorVirtualWorld(Bankers[5], BANK_SF);

	// las venturas
	Bankers[6] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[7] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[6], BANK_LV);
	SetActorVirtualWorld(Bankers[7], BANK_LV);

	// dillimore
	Bankers[8] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[9] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[8], BANK_DILLIMORE);
	SetActorVirtualWorld(Bankers[9], BANK_DILLIMORE);

	// las barrancas
	Bankers[10] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[11] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[10], BANK_LASBARANCAS);
	SetActorVirtualWorld(Bankers[11], BANK_LASBARANCAS);

	// pickups for interaction.
	BankPoint[0] = CreateDynamicSphere(2316.2263,-7.3651, 26.7422, 3.0);
	BankPoint[1] = CreateDynamicSphere(2316.4480,-15.4179,26.7422, 3.0);

	print("[Streamer] Bank System Loaded");

	return 1;


}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if((newkeys & KEY_YES) && (IsPlayerInDynamicArea(playerid, BankPoint[0]) || IsPlayerInDynamicArea(playerid, BankPoint[1]))) {
		format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s dang tuong tac voi nhan vien ngan hang.", GetPlayerNameEx(playerid));
		//ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 15.0, 5000);
		ShowBankMenu(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case BANK: {

			if(!response) {
				TogglePlayerControllable(playerid, 1);
				return SendClientMessageEx(playerid, COLOR_YELLOW, "[>] {FFFFFF}Ban da ngung tuong tac voi NPC.");
			}

			TogglePlayerControllable(playerid, 0);

			switch(listitem) {
				case 0: ShowBankMenu(playerid, 1);
				case 1: ShowBankMenu(playerid, 2);
				case 2: ShowBankMenu(playerid, 3);
				case 3: {

				 	if(PlayerInfo[playerid][pCheckCash] > 0) {
				    	//GivePlayerCash(playerid,PlayerInfo[playerid][pCheckCash]);
				    	GivePlayerCashEx(playerid, TYPE_BANK, PlayerInfo[playerid][pCheckCash]);
				     	PlayerInfo[playerid][pCheckCash] = 0;
				      	SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da thanh toan het tat ca sec ban co.");
				       	return ShowBankMenu(playerid);
					}
					else {
						SendClientMessageEx(playerid, COLOR_YELLOW, "Ban khong co sec de thanh toan.");
						return ShowBankMenu(playerid);
					}
				}
			}
		}

		case BANK_AMOUNT: {
			if(!response) {
				DeletePVar(playerid, "BankWithdraw");
				DeletePVar(playerid, "BankDeposit");
				return ShowBankMenu(playerid);
			}

			new
				iAmount = strval(inputtext);

			if(GetPVarType(playerid, "BankWithdraw")) {

				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "Khong the chuyen so tien am!");
					return ShowBankMenu(playerid, 1);
				}

				if(iAmount > PlayerInfo[playerid][pAccount]) {
					SendClientMessageEx(playerid, COLOR_WHITE, "Rut tien khong thanh cong, so tien trong tai khoan ngan hang ban khong du de rut!");
					return ShowBankMenu(playerid, 1);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai cho 10 giay nua de co the tiep tuc giao dich...");
					ShowBankMenu(playerid, 1);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());

				if(!Bank_TransferCheck(-iAmount)) return 1;
				GivePlayerCash(playerid, iAmount);
				PlayerInfo[playerid][pAccount] -= iAmount;
				format(szMiscArray, sizeof(szMiscArray), "Ban da rut ra $%s tu ngan hang ", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				if(PlayerInfo[playerid][pTut] == 16)
				{
					PlayerInfo[playerid][pTut]++;
					AdvanceTutorial(playerid);
				}

				OnPlayerStatsUpdate(playerid);

				DeletePVar(playerid, "BankWithdraw");

				return ShowBankMenu(playerid);
			}
			else if(GetPVarType(playerid, "BankDeposit")) {

				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "So tien khong hop le");
					return ShowBankMenu(playerid, 2);
				}

				if(iAmount > GetPlayerCash(playerid)) {
					SendClientMessageEx(playerid, COLOR_WHITE, "Gui tien khong thanh cong, so tien ban da nhap vao khong dung voi so tien ban dang cam tren nguoi!");
					return ShowBankMenu(playerid, 2);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai cho 10 giay nua de co the tiep tuc giao dich...");
					ShowBankMenu(playerid, 2);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());

				if(!Bank_TransferCheck(iAmount)) return 1;
				GivePlayerCash(playerid, -iAmount);
				PlayerInfo[playerid][pAccount] += iAmount;
				format(szMiscArray, sizeof(szMiscArray), "Ban da gui $%s vao ngan hang. ", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				OnPlayerStatsUpdate(playerid);

				DeletePVar(playerid, "BankDeposit");

				return ShowBankMenu(playerid);
			}
		}

		case BANK_TRANSFER_TO: {

			if(!response) {
				return ShowBankMenu(playerid);
			}

			new id = strval(inputtext);

			if(!IsPlayerConnected(id) || !gPlayerLogged{id}) {
				SendClientMessageEx(playerid, COLOR_WHITE, "Nguoi choi ban nhap ID hien khong truc tuyen de duoc chuyen tien!");
				return ShowBankMenu(playerid, 3);
			}

			SetPVarInt(playerid, "BankTransferTo", id);
			return ShowBankMenu(playerid, 4);
		}

		case BANK_TRANSFER_AMT: {

			if(!response) {
				DeletePVar(playerid, "BankTransferTo");
				return ShowBankMenu(playerid, 3);
			}

			new
				id = GetPVarInt(playerid, "BankTransferTo"),
				iAmount = strval(inputtext);


			if(restarting) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Giao dich hien dang tam khoa vi may chu sap bao tri.");
				return ShowBankMenu(playerid, 3);
			}
			if(PlayerInfo[playerid][pLevel] < 3) {
				SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai dat it nhat lvl.3 de thuc hien hanh dong nay!");
				return ShowBankMenu(playerid, 3);
			}
			if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai cho 10 giay nua de co the tiep tuc giao dich...");
				return ShowBankMenu(playerid, 3);
			}

			if(iAmount > PlayerInfo[playerid][pAccount] || iAmount < 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You are trying to send more than you have!");

			// Use these as they update the MySQL Directly with less function calls
			GivePlayerCashEx(playerid, TYPE_BANK, -iAmount);
			GivePlayerCashEx(id, TYPE_BANK, iAmount);

			format(szMiscArray, sizeof(szMiscArray), "Ban da chuyen $%s vao tai khoan ngan hang cua %s.", number_format(iAmount), GetPlayerNameEx(id));
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "$%s da duoc chuyen vao tai khoan cua ban boi %s.", number_format(iAmount), GetPlayerNameEx(playerid));
			SendClientMessageEx(id, COLOR_YELLOW, szMiscArray);

			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);


			new ip[32], ipex[32];
			GetPlayerIp(playerid, ip, sizeof(ip));
			GetPlayerIp(id, ipex, sizeof(ipex));
			format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s(%d) (IP:%s) da chuyen khoan $%s cho %s(%d) (IP:%s).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), GetPlayerSQLId(id), ipex);
			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) Log("logs/adminpay.log", szMiscArray); else Log("logs/pay.log", szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s (IP:%s) da chuyen khoan $%s cho %s (IP:%s).", GetPlayerNameEx(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), ipex);


			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s da chuyen khoan $%s cho %s.", GetPlayerNameEx(playerid), number_format(iAmount), GetPlayerNameEx(id));
				if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(id), true)) strcat(szMiscArray, " (1)");
				ABroadCast(COLOR_YELLOW,szMiscArray, 4);
			}
			else {
				foreach(new i: Player) {
					if(PlayerInfo[i][pAdmin] >= 2 && !hideChuyenTien{i} && !PlayerInfo[i][pTogReports]) {
						SendClientMessageEx(i, COLOR_YELLOW, szMiscArray);
					}
				}
			}

			SetPVarInt(playerid, "LastTransaction", gettime());
			DeletePVar(playerid, "BankTransferTo");

			return ShowBankMenu(playerid);
		}
	}
	return 0;
}

ShowBankMenu(playerid, menu = 0) {

	new szTitle[48];

	szMiscArray[0] = 0;

	format(szTitle, sizeof(szTitle), "Tong tien dang co ($%s)", number_format(PlayerInfo[playerid][pAccount]));

	if(PlayerInfo[playerid][pFreezeBank] == 1) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, szTitle, "Tai san cua ban da bi dong bang, hay lien he to chuc Judicial!", "Ok", "");

	switch(menu) {

		case 0: { // main menu
			ShowPlayerDialogEx(playerid, BANK, DIALOG_STYLE_LIST, szTitle, "Rut tien\nGui tien\nChuyen Tien\nThanh toan sec", "Chon", "Huy");
		}

		case 1: { // iAmount withdraw
			ShowPlayerDialogEx(playerid, BANK_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Vui long nhap so tien ban muon rut tien tu tai khoan cua minh.", "Rut tien", "Huy");
			SetPVarInt(playerid, "BankWithdraw", 1);
		}

		case 2: { // iAmount deposit
			ShowPlayerDialogEx(playerid, BANK_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Vui long nhap so tien ban muon Gui tien tu tai khoan cua minh.", "Gui tien", "Huy");
			SetPVarInt(playerid, "BankDeposit", 1);
		}

		case 3: { // transfer to
			ShowPlayerDialogEx(playerid, BANK_TRANSFER_TO, DIALOG_STYLE_INPUT, szTitle, "Vui long nhap id hoac ten nguoi choi ban muon chuyen tien vao.", "Tiep tuc", "Huy");
		}

		case 4: { // transfer iAmount
			format(szMiscArray, sizeof(szMiscArray), "Vui long nhap so tien ban muon chuyen den {FF0000}%s", GetPlayerNameEx(GetPVarInt(playerid, "BankTransferTo")));
			ShowPlayerDialogEx(playerid, BANK_TRANSFER_AMT, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Chuyen tien", "Huy");
		}
	}

	return 1;
}
