#include <YSI\y_hooks>

CMD:newb(playerid, params[]) {

	szMiscArray[0] = 0;

	if(PlayerInfo[playerid][pNMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang bi mute kenh Newb.");
	if(PlayerInfo[playerid][pToggledChats][0]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da tat kenh Newb, /tog newb de bat lai!");
	if(PlayerInfo[playerid][pTut] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay luc nay.");
	if(nonewbie) return SendClientMessageEx(playerid, COLOR_GRAD2, "Kenh Newb da bi tat boi Admin!");

	if(GetPVarType(playerid, "HasNewbQues")) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban da dat ra mot cau hoi cho Helper roi.");
		return SendClientMessageEx(playerid, COLOR_GREY, "Go /huycauhoi de yeu cau de nghi moi");
	}

	ShowPlayerDialogEx(playerid, SEND_NEWBIE, DIALOG_STYLE_INPUT, "Nguoi choi moi dat cau hoi", "Vui long dat cau hoi\nChi dat cau hoi nao lien quan den van de trong game.", "Gui", "Huy");

	return 1;
}

CMD:cancelnewbie(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da huy yeu cau cua minh");
	ClearNewbVars(playerid);
	return 1;
}

CMD:newbquestions(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pHelper] > 0) {
		GetNewbieQuestions(playerid);
	}

	return 1;
}

CMD:an(playerid, params[]) {

	szMiscArray[0] = 0;

	new id;

	if(sscanf(params, "u", id)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /an [playerid]");
	if(!IsPlayerConnected(id)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi do chua ket noi!");
	if(!GetPVarType(id, "HasNewbQues")) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi nay khong dat cau hoi!");
	if(GetPVarType(id, "NewbBeingAnswered")) return SendClientMessageEx(playerid, COLOR_GREY, "Mot nguoi khac dang tra loi cau hoi nay!");

	if(PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pHelper] > 0) {

		SetPVarInt(playerid, "AnsweringNewb", id);
		SetPVarInt(id, "NewbBeingAnswered", playerid);
		GetPVarString(id, "HasNewbQues", szMiscArray, 128);
		format(szMiscArray, sizeof(szMiscArray), "%s(ID:%d) hoi: %s\nGhi ro cau tra loi vao khung duoi!", GetPlayerNameEx(id), id, szMiscArray);
		ShowPlayerDialogEx(playerid, ACCEPT_NEWBIE, DIALOG_STYLE_INPUT, "Tra loi cau hoi", szMiscArray, "Tra loi", "");
	}

	return 1;
}

CMD:tn(playerid, params[]) {

	szMiscArray[0] = 0;

	new id;

	if(sscanf(params, "u", id)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /tn [playerid]");
	if(!IsPlayerConnected(id)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi do chua ket noi!");
	if(!GetPVarType(id, "HasNewbQues")) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi nay khong dat cau hoi!");
	if(GetPVarType(id, "NewbBeingAnswered")) return SendClientMessageEx(playerid, COLOR_GREY, "Mot nguoi khac dang tra loi cau hoi nay!");


	if(PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pHelper] > 0) {

		SetPVarInt(playerid, "AnsweringNewb", id);
		SetPVarInt(id, "NewbBeingAnswered", playerid);
		GetPVarString(id, "HasNewbQues", szMiscArray, 128);

		ShowPlayerDialogEx(playerid, DENY_NEWBIE, DIALOG_STYLE_LIST, "Ly do tu choi cau hoi?", "Khong phai 1 cau hoi\nVan de IC\nSpam\nKhong ro cau hoi", "Chon","");
	}

	return 1;
}

SendNewbQuestionToQueue(iPlayerID, szQuestion[]) {

	szMiscArray[0] = 0;

	SetPVarString(iPlayerID, "HasNewbQues", szQuestion);

	format(szMiscArray, sizeof(szMiscArray), "Nguoi choi: %s(ID:%d) hoi: %s", GetPlayerNameEx(iPlayerID), iPlayerID, szQuestion);

	foreach(new i : Player) {
		if((PlayerInfo[i][pAdmin] >= 1 || PlayerInfo[i][pHelper] > 0))

			ChatTrafficProcess(i, COLOR_NEWBIE, szMiscArray, 0);
	}

	SendClientMessageEx(iPlayerID, COLOR_LIGHTBLUE, "Ban da gui cau hoi den doi ngu Helper, cho mot lat de duoc tra loi.");

	return 1;
}

ClearNewbVars(iPlayerID) {

	DeletePVar(iPlayerID, "HasNewbQues");
	DeletePVar(GetPVarInt(iPlayerID, "NewbBeingAnswered"), "AnsweringNewb");
	DeletePVar(iPlayerID, "NewbBeingAnswered");

	return 1;
}

AnswerNewbie(iPlayerID, iNewbieID, szAnswer[]) {

	szMiscArray[0] = 0;

	if(!GetPVarType(iNewbieID, "HasNewbQues")) return SendClientMessageEx(iPlayerID, COLOR_GREY, "Nguoi choi do khong dat cau hoi!");

	GetPVarString(iNewbieID, "HasNewbQues", szMiscArray, 128);

	format(szMiscArray, sizeof(szMiscArray), "[?] Nguoi choi %s hoi: %s", GetPlayerNameEx(iNewbieID), szMiscArray);
	SendGlobalNewbMsg(szMiscArray);
	Log("logs/newbiechat.log", szMiscArray);

	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "[!] %s %s tra loi: %s", GetStaffRank(iPlayerID), GetPlayerNameEx(iPlayerID), szAnswer);
	SendGlobalNewbMsg(szMiscArray);
	Log("logs/newbiechat.log", szMiscArray);

	if(PlayerInfo[iPlayerID][pHelper] == 1 && PlayerInfo[iPlayerID][pAdmin] < 1) {
		ReportCount[iPlayerID]++;
		ReportHourCount[iPlayerID]++;
		AddCAReportToken(iPlayerID); // Advisor Tokens
	}

	SendClientMessageEx(iNewbieID, COLOR_GREEN, "Cau hoi cua ban da duoc tra loi! Neu ban con thac mac van de gi nua hay /yeucautrogiup.");

	ClearNewbVars(iNewbieID);

	return 1;
}

SendGlobalNewbMsg(szMessage[]) {

	foreach(new i : Player) {
		if(PlayerInfo[i][pToggledChats][0] == 0) {
			SendClientMessageEx(i, COLOR_NEWBIE, szMessage);
		}
	}
	return 1;
}

GetNewbieQuestions(iPlayerID) {

	szMiscArray[0] = 0;

	SendClientMessageEx(iPlayerID, COLOR_GREENEW,"------------------------------------------------------------------------------------------------------------------------");
	foreach(new i : Player) {
		if(GetPVarType(i, "HasNewbQues")) {
			GetPVarString(i, "HasNewbQues", szMiscArray, 128);
			format(szMiscArray, sizeof(szMiscArray), "Nguoi choi: %s (ID:%d) - Noi dung cau hoi: %s", GetPlayerNameEx(i), i, szMiscArray);
			SendClientMessageEx(iPlayerID, COLOR_NEWBIE, szMiscArray);
		}
	}
	SendClientMessageEx(iPlayerID, COLOR_GREENEW,"------------------------------------------------------------------------------------------------------------------------");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case SEND_NEWBIE: {

			if(response) {

				if(isnull(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the gui cau hoi!");
				if(strlen(inputtext) > 110) return SendClientMessageEx(playerid, COLOR_GRAD2, "Cau hoi cua ban qua dai!");

				SendNewbQuestionToQueue(playerid, inputtext);
			}
		}

		case ACCEPT_NEWBIE: {

			if(response) {
				if(isnull(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the gui cau tra loi!");
				if(strlen(inputtext) > 110) {
					DeletePVar(GetPVarInt(playerid, "AnsweringNewb"), "NewbBeingAnswered");
					DeletePVar(playerid, "AnsweringNewb");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Cau tra loi cua ban qua dai!");
				}

				AnswerNewbie(playerid, GetPVarInt(playerid, "AnsweringNewb"), inputtext);
			}
			else {

				DeletePVar(GetPVarInt(playerid, "AnsweringNewb"), "NewbBeingAnswered");
				DeletePVar(playerid, "AnsweringNewb");
			}
		}

		case DENY_NEWBIE: {

			if(response) {
				new id = GetPVarInt(playerid, "AnsweringNewb");

				switch(listitem) {

					case 0: {
						SendClientMessageEx(id, COLOR_LIGHTRED, "Cau hoi cua ban da bi tu choi, ly do: Khong phai 1 cau hoi.");
						SendClientMessageEx(id, COLOR_LIGHTRED, "Hay /newb va ghi dung cau hoi.");
					}

					case 1: {
						SendClientMessageEx(id, COLOR_LIGHTRED, "Cau hoi cua ban da bi tu choi, ly do: Van de IC.");
						SendClientMessageEx(id, COLOR_LIGHTRED, "Chung toi chi duoc tra loi nhung cau hoi den lenh/he thong tai may chu.");
					}

					case 2: {
						SendClientMessageEx(id, COLOR_LIGHTRED, "Cau hoi cua ban da bi tu choi, ly do: Spam.");
						SendClientMessageEx(id, COLOR_LIGHTRED, "Lam dung kenh /newb se bi cam hoac co the bi phat nang.");
					}
					case 3: {
						SendClientMessageEx(id, COLOR_LIGHTRED, "Cau hoi cua ban da bi tu choi, ly do: Khong ro cau hoi.");
						SendClientMessageEx(id, COLOR_LIGHTRED, "Hay /newb va neu ro ra cau hoi cua ban.");
					}

				}

				ClearNewbVars(id);
			}
			else {

				DeletePVar(GetPVarInt(playerid, "AnsweringNewb"), "NewbBeingAnswered");
				DeletePVar(playerid, "AnsweringNewb");
			}

		}
	}
	return 0;
}

hook OnPlayerDisconnect(playerid, reason) {

	// cancel newbie report if they have one
	ClearNewbVars(playerid);

	return 1;
}
