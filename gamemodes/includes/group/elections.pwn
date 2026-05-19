/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Election System
							Jingles

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

hook OnGameModeInit() {

	LoadElections();
}

hook OnGameModeExit() {
	UnloadElections();
}

LoadElections() {

	SetGVarInt("ElectionArea", CreateDynamicSphere(366.54, 159.09, 1008.38, 100));
	return 1;
}

UnloadElections() {
	
	DestroyDynamicArea(GetGVarInt("ElectionArea"));
	DeleteGVar("ElectionArea");
}

hook OnPlayerEnterDynArea(playerid, areaid) {

	if(areaid == GetGVarInt("ElectionArea")) SendClientMessage(playerid, COLOR_WHITE, "Ban dang o khu vuc bau cu - Bam phim{ffe900} ~k~~CONVERSATION_YES~ {FFFFFF}de bau cu.");
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES && IsPlayerInDynamicArea(playerid, GetGVarInt("ElectionArea"))) {
		ShowElectionMenu(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0; 

	switch(dialogid) {
		case ELECTIONS: {

			szMiscArray[0] = 0;
			if(!response) return SendClientMessage(playerid, COLOR_WHITE, "Ban chua bo phieu bau cu.");

			if(strcmp(inputtext, "Them ung cu vien") == 0) {
				if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la Admin.");
				return ShowPlayerDialogEx(playerid, ELECTIONS_ADD, DIALOG_STYLE_INPUT, "Them ung cu vien", "Hay nham ten ung cu vien.", "Xac nhan", "Huy");
			}

			if(strcmp(inputtext, "Xoa ung cu vien") == 0) {
				if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la Admin.");
				new 
					szTemp[MAX_PLAYER_NAME],
					iCount = GetGVarInt("CandidateCount");

				for(new i = 0; i < iCount; ++i) {
					szTemp[0] = 0; 
					GetGVarString("CandidateName", szTemp, sizeof(szTemp), i);
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, szTemp);
				}
				return ShowPlayerDialogEx(playerid, ELECTIONS_REMOVE, DIALOG_STYLE_LIST, "Bau cu", szMiscArray, "Chon", "Huy");
			}	

			if(strcmp(inputtext, "Bat dau bau cu") == 0) {
				if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la Admin.");
				SendClientMessageToAll(COLOR_WHITE, "[BAU CU] Bau cu Tong Thong da duoc bat dau.");
				SendClientMessageToAll(COLOR_WHITE, "[BAU CU] Hay den City Hall de bau cu Tong Thong moi!");
				SetGVarInt("ElectionActive", 1);
				return 1;
			}

			if(strcmp(inputtext, "Ket thuc bau cu") == 0) {
				if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la Admin.");
				DeleteGVar("ElectionActive");
				return CountVotes(playerid);
			}

			if(listitem <= GetGVarInt("CandidateCount")) {
				return CastVote(playerid, listitem);
			}
		}
		case ELECTIONS_ADD: {

			if(!response || isnull(inputtext) || IsNumeric(inputtext)) return 1;
			if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la Admin.");
			new iOptionID = GetGVarInt("CandidateCount");
			SetGVarString("CandidateName", inputtext, iOptionID);
			iOptionID++;
			SetGVarInt("CandidateCount", iOptionID);
			format(szMiscArray, sizeof(szMiscArray), "Ban da them %s vao danh sach ung cu vien. %d", inputtext, iOptionID);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "%s added %s as election candidate no. %d", GetPlayerNameExt(playerid), inputtext, iOptionID);
			Log("logs/elections.log", szMiscArray);
		}
		case ELECTIONS_REMOVE: {

			if(!response) return 1;
			if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_GREY, "Ban khong phai la Admin.");
			new szName[MAX_PLAYER_NAME],
				iCount = GetGVarInt("CandidateCount");

			GetGVarString("CandidateName", szName, sizeof(szName), listitem);
			DeleteGVar("CandidateName", listitem);
			SetGVarInt("CandidateCount", iCount - 1);
			format(szMiscArray, sizeof(szMiscArray), "Ban da xoa %s ra khoi danh sach ung cu vien. %d", szName, listitem);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "%s removed %s as election candidate no. %d", GetPlayerNameExt(playerid), szName, listitem);
			Log("logs/elections.log", szMiscArray);

		}
	}
	return 0;
}

CastVote(playerid, iOptionID) {

	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pNation] != 0) return SendClientMessage(playerid, COLOR_GREY, "Ban khong thuoc quoc tich San Andreas.");
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `electionresults` WHERE `ip` = '%s'", PlayerInfo[playerid][pIP]);
	mysql_tquery(MainPipeline, szMiscArray, "OnIPVoteCheck", "ii", playerid, iOptionID);
	return 1;
}
forward OnIPVoteCheck(playerid, iOptionID);
public OnIPVoteCheck(playerid, iOptionID)
{
	new iRows;
	cache_get_row_count(iRows);
	szMiscArray[0] = 0;

	if(iRows > 0) {
		return SendClientMessageEx(playerid, COLOR_WHITE, "Ban da bau cu roi!");
	} else {
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `electionresults` WHERE `accountid` = '%d'", PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, szMiscArray, "OnCastVote", "ii", playerid, iOptionID);
	}
	return 1;

}
forward OnCastVote(playerid, iOptionID);
public OnCastVote(playerid, iOptionID) {

	new iRows;
	cache_get_row_count(iRows);
	szMiscArray[0] = 0;

	if(iRows > 0) {
		return SendClientMessageEx(playerid, COLOR_WHITE, "Ban da bau cu roi!");
	}
	else {
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `electionresults` (`accountid`, `optionid`, `ip`) VALUES ('%d', '%d', '%s')", PlayerInfo[playerid][pId], iOptionID, PlayerInfo[playerid][pIP]);
		mysql_tquery(MainPipeline, szMiscArray, "OnFinaliseVote", "ii", playerid, iOptionID);
	}
	return 1;
}

forward OnFinaliseVote(playerid, iOptionID);
public OnFinaliseVote(playerid, iOptionID) {

	if(!mysql_errno(MainPipeline)) SendClientMessage(playerid, COLOR_WHITE, "Ban vua bau cu cho ai do.");
	return 1;
}

CountVotes(playerid) {

	if(GetGVarInt("CandidateCount") == 0) return SendClientMessageEx(playerid, COLOR_RED, "Khong co ung cu vien, nen khong the dem duoc.");
	else mysql_tquery(MainPipeline, "SELECT `optionid` FROM `electionresults`", "OnCountVotes", "i", playerid);
	return 1;
}

forward OnCountVotes(playerid);
public OnCountVotes(playerid) {

	new 
		iRows,
		iCount,
		iTemp,
		szTemp[MAX_PLAYER_NAME],
		iCandidates = GetGVarInt("CandidateCount");
	szMiscArray[0] = 0;
	cache_get_row_count(iRows);

	while(iCount < iRows) {
		cache_get_value_name_int(iCount, "optionid", iTemp);
		SetGVarInt("Results", GetGVarInt("Results", iTemp)+1, iTemp);
		iCount++;
	}

	SendClientMessageToAll(COLOR_WHITE, "[BAU CU] Hien tai da ket thuc bau cu, nguoi co nhieu phieu nhat se tro thanh Tong Thong:");
	for(new i = 0; i < iCandidates; ++i) {
		GetGVarString("CandidateName", szTemp, sizeof(szTemp), i);
		format(szMiscArray, sizeof(szMiscArray), "%s - %d phieu.", szTemp, GetGVarInt("Results", i));
		SendClientMessageToAll(COLOR_WHITE, szMiscArray);
	}
	return 1;
}

ShowElectionMenu(playerid) {

	if(PlayerInfo[playerid][pConnectHours] < 32 && PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_WHITE, "Ban can co 32 gio choi tro len de bau cu.");

	szMiscArray[0] = 0;

	new 
		szTemp[MAX_PLAYER_NAME],
		iCount = GetGVarInt("CandidateCount");

	for(new i = 0; i < iCount; i++) {
		szTemp[0] = 0;
		GetGVarString("CandidateName", szTemp, sizeof(szTemp), i);
		format(szMiscArray, sizeof(szMiscArray), "%s\n%s", szMiscArray, szTemp);
	}

	if(PlayerInfo[playerid][pAdmin] >= 1337 && !GetGVarType("ElectionActive")) strcat(szMiscArray, "\nThem ung cu vien\nXoa ung cu vien\nBat dau bau cu");
	if(PlayerInfo[playerid][pAdmin] >= 1337 && GetGVarType("ElectionActive")) strcat(szMiscArray, "\nKet thuc bau cu");
	return ShowPlayerDialogEx(playerid, ELECTIONS, DIALOG_STYLE_LIST, "Bau cu", szMiscArray, "Chon", "Thoat");
}

CMD:elections(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_WHITE, "Ban khong duoc phep su dung lenh nay.");

	switch(GetGVarInt("ElectionActive")) {

		case 0: {
			SendClientMessageEx(playerid, COLOR_YELLOW, "You have enabled the elections.");
			return SetGVarInt("ElectionActive", 1);
		}
		case 1: {
			SendClientMessageEx(playerid, COLOR_YELLOW, "You have disabled the elections.");
			return DeleteGVar("ElectionActive");
		}
	}
	return 1;
}
