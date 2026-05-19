/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Chat System

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


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_ADO: {

			if(!response) return DeletePVar(playerid, "actionstring");

			new iTargetID = ListItemTrackId[playerid][listitem],
				szMessage[150];

			GetPVarString(playerid, "actionstring", szMessage, sizeof(szMessage));
			SetPVarInt(iTargetID, "actionplayer", playerid);
			format(szMiscArray, sizeof(szMiscArray), " ** Sent: {C2A2DA}%s attempts to %s", GetPlayerNameEx(playerid), szMessage);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), " * > Action request sent to: %s. Awaiting response...", GetPlayerNameEx(iTargetID));
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "Sender: %s\n\nAction: %s (( %s ))\n\n\
				Select 'Accept' to accept the action.\n\
				Select 'Deny' to deny the action. You will need to provide a reason.", GetPlayerNameExt(playerid), szMessage, GetPlayerNameExt(playerid));
			ShowPlayerDialogEx(iTargetID, DIALOG_ADO2, DIALOG_STYLE_MSGBOX, "Incoming Action Request", szMiscArray, "Accept", "Deny");
		}
		case DIALOG_ADO2: {

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_ADO3, DIALOG_STYLE_INPUT, "Action Denied", "Please provide a reason for denying the action request", "Submit", "Cancel");
			}
			new iActionID = GetPVarInt(playerid, "actionplayer");
			GetPVarString(iActionID, "actionstring", szMiscArray, sizeof(szMiscArray));
			format(szMiscArray, sizeof(szMiscArray), "* %s (( %s ))", szMiscArray, GetPlayerNameExt(iActionID));
			ProxDetectorWrap(playerid, szMiscArray, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			DeletePVar(iActionID, "actionstring");
			DeletePVar(playerid, "actionplayer");

		}
		case DIALOG_ADO3: {

			new iActionID = GetPVarInt(playerid, "actionplayer");
			format(szMiscArray, sizeof(szMiscArray), " * %s denied the action.", GetPlayerNameExt(iActionID));
			SendClientMessage(iActionID, COLOR_PURPLE, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), " * Reason: %s.", inputtext);
			SendClientMessage(iActionID, COLOR_YELLOW, szMiscArray);
			SendClientMessage(playerid, COLOR_PURPLE, "You denied the action.");
			format(szMiscArray, sizeof(szMiscArray), " * Reason: %s.", inputtext);
			SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
			DeletePVar(iActionID, "actionstring");
			DeletePVar(playerid, "actionplayer");
		}
	}
	return 1;
}

hook OnPlayerConnect(playerid) {

	for(new i; i < MAX_CHATSETS; ++i) PlayerInfo[playerid][pToggledChats][i] = 0;
	for(new i; i < MAX_CHATSETS; ++i) PlayerInfo[playerid][pChatbox][i] = 0;
	DeletePVar(playerid, "actionplayer");
	DeletePVar(playerid, "actionstring");
	return 1;
}

/*
stock SendClientMessageEx(playerid, color, string[])
{
	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1 || ActiveChatbox[playerid] == 0)
		return 0;

	else SendClientMessage(playerid, color, string);
	return 1;
}
*/

// Test with SendClientMessageEx
stock SendClientMessageEx(playerid, color, msg[], va_args<>)
{
	if(playerid == INVALID_PLAYER_ID) return 0;
	new string[128];
	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1 || ActiveChatbox[playerid] == 0)
			return 0;
	else {
			va_format(string, sizeof(string), msg, va_start<3>);
			SendClientMessage(playerid, color, string);
	}
	return 1;
}
stock SendClientMessageToAllEx(color, string[])
{
	foreach(new i: Player)
	{
		if(InsideMainMenu{i} == 1 || InsideTut{i} == 1 || ActiveChatbox[i] == 0) {}
		else {

			SendClientMessage(i, color, string);
		}
	}
	return 1;
}


CMD:togchatbox2(playerid, params[]) {

	if(PlayerInfo[playerid][pToggledChats][19]) {

		for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawShow(playerid, TD_ChatBox[i]);
		PlayerInfo[playerid][pToggledChats][19] = 0;
	}
	else {

		for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawHide(playerid, TD_ChatBox[i]);
		PlayerInfo[playerid][pToggledChats][19] = 1;
	}
	return 1;
}


stock SendClientMessageWrap(playerid, color, width, string[])
{
	if(strlen(string) > width)
	{
		new firstline[128], secondline[128];
		strmid(firstline, string, 0, 88);
		strmid(secondline, string, 88, 128);
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		ChatTrafficProcess(playerid, color, firstline, 3);
		ChatTrafficProcess(playerid, color, secondline, 3);
	}
	else ChatTrafficProcess(playerid, color, string, 3);
}

stock ClearChatbox(playerid)
{
	for(new i = 0; i < 50; i++) {
		SendClientMessage(playerid, COLOR_WHITE, "");
	}
	return 1;
}

stock OOCOff(color,string[])
{
	foreach(new i: Player)
	{
		if(!gOoc[i]) {
			SendClientMessageEx(i, color, string);
		}
	}
}

stock RadioBroadCast(playerid, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pRadioFreq] == PlayerInfo[playerid][pRadioFreq] && PlayerInfo[i][pRadio] >= 1 && gRadio{i} != 0)
		{
			format(szMiscArray, sizeof(szMiscArray), "** Radio (%d kHz) ** %s: %s", PlayerInfo[playerid][pRadioFreq], GetPlayerNameEx(playerid), string);
			ChatTrafficProcess(i, PUBLICRADIO_COLOR, szMiscArray, 5);
			format(szMiscArray, sizeof(szMiscArray), "(radio) %s", string);
			SetPlayerChatBubble(playerid, szMiscArray, COLOR_WHITE, 15.0, 5000);
		}
	}
}

CMD:togooc(playerid, params[])
{
	if (!gOoc[playerid])
	{
		gOoc[playerid] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da tat kenh Global OOC chat.");
	}
	else
	{
		gOoc[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da bat Global OOC chat.");
	}
	return 1;
}

CMD:me(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /me [action]");
	new string[255];
	format(string, sizeof(string), "{FF8000}* {C2A2DA}%s %s", GetPlayerNameEx(playerid), params);
	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetector(5.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	else ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:whisper(playerid, params[]) {
	return callcmd::w(playerid, params);
}

CMD:w(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	new giveplayerid, whisper[128];

	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap.");
		return 1;
	}
	if(sscanf(params, "us[128]", giveplayerid, whisper))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: (/w)hisper [player] [noi dung]");
		return 1;
	}
	if(GetPVarType(playerid, "WatchingTV") && PlayerInfo[playerid][pAdmin] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the su dung lenh nay khi dang xem TV.");
		return 1;
	}
	if (IsPlayerConnected(giveplayerid))
	{
		if(HidePM[giveplayerid] > 0 && PlayerInfo[playerid][pAdmin] < 2)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay da tat thi tham!");
			return 1;
		}
		new giveplayer[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], string[128];
		sendername = GetPlayerNameEx(playerid);
		giveplayer = GetPlayerNameEx(giveplayerid);
		if(giveplayerid == playerid)
		{
			if(PlayerInfo[playerid][pSex] == 1) format(string, sizeof(string), "* %s lam bam dieu gi do voi ban than anh ay.", GetPlayerNameEx(playerid));
			else format(string, sizeof(string), "* %s lam bam gi do voi ban than co ay.", GetPlayerNameEx(playerid));
			return ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		if(ProxDetectorS(5.0, playerid, giveplayerid) || PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] == 2)
		{
		    foreach(new i: Player)
			{
				if(GetPVarInt(i, "BigEar") == 6 && (GetPVarInt(i, "BigEarPlayer") == playerid || GetPVarInt(i, "BigEarPlayer")  == giveplayerid))
				{
					format(string, sizeof(string), "(BE)%s(ID %d) thi tham voi %s(ID %d): %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
					SendClientMessageWrap(i, COLOR_YELLOW, 92, string);
				}
			}

			format(string, sizeof(string), "(( %s (ID %d) thi tham voi ban: %s ))", GetPlayerNameEx(playerid), playerid, whisper);
			SendClientMessageWrap(giveplayerid, COLOR_YELLOW, 92, string);

			format(string, sizeof(string), "(( Ban thi tham voi %s: %s ))", GetPlayerNameEx(giveplayerid),whisper);
			SendClientMessageWrap(playerid, COLOR_YELLOW, 92, string);
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
		}
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong ton tai.");
	}
	return 1;
}

CMD:do(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap.");
		return 1;
	}
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /do [action]");
	else if(strlen(params) > 120) return SendClientMessageEx(playerid, COLOR_GREY, "Van ban khong duoc dai hon 120 ky tu!");
	new
		iCount,
		iPos,
		iChar;

	while((iChar = params[iPos++])) {
		if(iChar == '@') iCount++;
	}
	if(iCount >= 5) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc ghi nhieu qua 4 ki tu '@'.");
	}

	new string[150];
	format(string, sizeof(string), "* %s (( %s ))", params, GetPlayerNameEx(playerid));
	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetectorWrap(playerid, string, 92, 5.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	else ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:ooc(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap.");
		return 1;
	}
	if ((noooc) && PlayerInfo[playerid][pAdmin] < 2 && EventKernel[EventCreator] != playerid)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Hien tai kenh OOC bi tat boi Admin");
		return 1;
	}
	if(gOoc[playerid])
	{
		SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Ban da tat kenh OOC, /togooc de bat lai!");
		return 1;
	}
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /ooc [ooc chat]");

	if(PlayerInfo[playerid][pAdmin] == 1)
	{
		new string[128];
		format(string, sizeof(string), "(( Moderator %s: %s ))", GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
	}
	else if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128];
		format(string, sizeof(string), "(( %s %s: %s ))", GetAdminRankName(PlayerInfo[playerid][pAdmin]), GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
	}
	else if(PlayerInfo[playerid][pHelper] >= 1)
	{
		new string[128];
		format(string, sizeof(string), "(( Advisor %s: %s ))", GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
		return 1;
	}
	else if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pHelper] <= 2)
	{
		new string[128];
		format(string, sizeof(string), "(( %s: %s ))", GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
		return 1;
	}
	return 1;
}

CMD:o(playerid, params[])
{
	return SendClientMessageEx(playerid, COLOR_GRAD1, "/o da chuyen thanh /ooc.");
}

CMD:shout(playerid, params[]) {
	return callcmd::s(playerid, params);
}

CMD:s(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap.");
		return 1;
	}

	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: (/s)hout [het to]");

	new string[128];
	format(string, sizeof(string), "(het to) %s!", params);
	SetPlayerChatBubble(playerid,string,COLOR_WHITE,60.0,5000);
	format(string, sizeof(string), "%s het to: %s!", GetPlayerNameEx(playerid), params);
	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetector(5.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1); // addition for prison system
	else ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
	return 1;
}

CMD:low(playerid, params[]) {
	return callcmd::l(playerid, params);
}

CMD:l(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap.");
		return 1;
	}
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: (/l)ow [noi nho]");

	new string[128];
	format(string, sizeof(string), "%s noi nho: %s", GetPlayerNameEx(playerid), params);
	ProxDetector(5.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, 1);
	format(string, sizeof(string), "(noi nho) %s", params);
	SetPlayerChatBubble(playerid,string,COLOR_WHITE,5.0,5000);
	return 1;
}

CMD:b(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap.");
		return 1;
	}
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /b [OOC CHAT]");
	if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong the su dung lenh nay khi dang xem TV.");
	new string[128];
	format(string, sizeof(string), "%s: (( %s ))", GetPlayerNameEx(playerid), params);

	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetector(5.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	else ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, 1, 2, 1);

	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] > 1 && GetPVarInt(i, "BigEar") == 2)
		{
			new szAntiprivacy[128];
			format(szAntiprivacy, sizeof(szAntiprivacy), "(BE) %s: %s", GetPlayerNameEx(playerid), params);
			ChatTrafficProcess(i, COLOR_FADE1, szAntiprivacy, 2);
		}
	}
	return 1;
}


CMD:pr(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pRadio] == 1)
	{
		if(isnull(params))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /pr [noi dung]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "[!]MEO: De doi tan so ban /tanso de chuyen sang kenh khac.");
			return 1;
		}
		if(PlayerInfo[playerid][pRadioFreq] >= 1 || PlayerInfo[playerid][pRadioFreq] <= -1)
		{
			if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay bay gio.");
			RadioBroadCast(playerid, params);
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "Tan so cua ban hien tai la \"0\" nen ban khong the noi chuyen, hay doi qua kenh khac (/tanso).");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co Radio Portable!");
	}
	return 1;
}

CMD:setfreq(playerid, params[])
{
	new string[128], frequency;
	if(sscanf(params, "d", frequency))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /tanso [so kenh]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "[!]MEO: Dat tan so la \"0\" neu ban khong muon tham gia vao kenh nao ca.");
		return 1;
	}

	if(frequency > 9999999 || frequency < -9999999) { SendClientMessageEx(playerid, COLOR_GREY, "Kenh tan so khong duoc thap hon -9999999 va cao hon 9999999!"); return 1; }
	if (PlayerInfo[playerid][pRadio] == 1)
	{
		PlayerInfo[playerid][pRadioFreq] = frequency;
		format(string, sizeof(string), "Ban da chuyen tan so sang kenh %d.",frequency);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co Radio Portable!");
	}
	return 1;
}


ChatTrafficProcess(playerid, color, szString[], chattype) {

	if(PlayerInfo[playerid][pToggledChats][chattype] == 0) SendClientMessageEx(playerid, color, szString);
	return 1;
	/*
	if(PlayerInfo[playerid][pChatbox][chattype] > 0 && PlayerInfo[playerid][pToggledChats][19] == 0) { // if Secondary Chatbox is not active, route all chat to normal chatbox.

		if(chattype == 1) return SendClientMessageEx(playerid, color, szString); // temp bug fix for /news.
		if(chattype == 16) return SendClientMessageEx(playerid, color, szString); // temp bug fix for /staff.

		ChatBoxProcess(playerid, color, szString);
	}
	else SendClientMessageEx(playerid, color, szString);
	return 1;
	*/
}

ProxChatBubble(playerid, szString[]) {

	SetPlayerChatBubble(playerid, szString, COLOR_PURPLE, 15.0, 5000);
	//format(szString, 128, "{FF8000}> {C2A2DA}%s", szString);
	SendClientMessageEx(playerid, COLOR_PURPLE, szString);
}

/*
new MessageStr[MAX_PLAYERS][11][128],
	MessageColor[MAX_PLAYERS][11];

ChatBoxProcess(playerid, hColor, szText[]) {

	if(PlayerInfo[playerid][pToggledChats][19] == 1) return 1;

	new iSize = sizeof(TD_ChatBox) - 1;

	for(new line = 1; line < sizeof(TD_ChatBox); line++)
	{
    	PlayerTextDrawHide(playerid, TD_ChatBox[line]);
    	if(line < iSize)
		{
		    MessageStr[playerid][line] = MessageStr[playerid][line+1];
    		MessageColor[playerid][line] = MessageColor[playerid][line+1];
    		PlayerTextDrawSetString(playerid, TD_ChatBox[line], MessageStr[playerid][line]);
 		}
	}
	format(MessageStr[playerid][iSize], 128, "... %s", szText);
	PlayerTextDrawSetString(playerid, TD_ChatBox[9], MessageStr[playerid][iSize]);
	MessageColor[playerid][iSize] = hColor;
	for(new line = 1; line < sizeof(TD_ChatBox); line++)
	{
		PlayerTextDrawColor(playerid, TD_ChatBox[line], MessageColor[playerid][line]);
     	PlayerTextDrawShow(playerid, TD_ChatBox[line]);
	}
	return 1;
}
*/

/*
ChatBoxProcess(playerid, hColor, szText[]) {

	if(PlayerInfo[playerid][pToggledChats][19] == 1) return 1;

	new PVarID[5];

	for(new i = 10; i > 1; --i) {

		format(PVarID, sizeof(PVarID), "CB%d", i - 1);
		GetPVarString(playerid, PVarID, szMiscArray, sizeof(szMiscArray));
		ChatBoxColor[playerid][i] = ChatBoxColor[playerid][i - 1];
		if(!isnull(szMiscArray)) PlayerTextDrawColor(playerid, TD_ChatBox[i], ChatBoxColor[playerid][i]);
		PlayerTextDrawSetString(playerid, TD_ChatBox[i], szMiscArray);
		PlayerTextDrawShow(playerid, TD_ChatBox[i]);

		format(PVarID, sizeof(PVarID), "CB%d", i);
		SetPVarString(playerid, PVarID, szMiscArray);

	}
	SetPVarString(playerid, "CB1", szText);
	ChatBoxColor[playerid][1] = hColor;
	PlayerTextDrawColor(playerid, TD_ChatBox[1], hColor);
	PlayerTextDrawSetString(playerid, TD_ChatBox[1], szText);
	PlayerTextDrawShow(playerid, TD_ChatBox[1]);
	return 1;
}
*/

CMD:ame(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /ame [action]");
	new string[128];
	format(string, sizeof(string), "%s %s", GetPlayerNameEx(playerid), params);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 15.0, 5000);
	format(string, sizeof(string), "{FF8000}> {C2A2DA}%s", params);
	SendClientMessageEx(playerid, COLOR_PURPLE, string);
	return 1;
}

CMD:lme(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /lme [action]");
	new string[128];
	format(string, sizeof(string), "{FF8000}* {C2A2DA}%s %s", GetPlayerNameEx(playerid), params);
	ProxDetectorWrap(playerid, string, 92, 15, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:ldo(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang trong tu nen bi han che, hay su dung /b.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /ldo [action]");
	else if(strlen(params) > 120) return SendClientMessageEx(playerid, COLOR_GREY, "Van ban khong duoc dai hon 120 ky tu!");
	new
		iCount,
		iPos,
		iChar;
	while((iChar = params[iPos++])) if(iChar == '@') iCount++;
	if(iCount >= 5) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc ghi nhieu qua 4 ki tu '@'.");

	new string[150];
	format(string, sizeof(string), "* %s (( %s ))", params, GetPlayerNameEx(playerid));
	ProxDetectorWrap(playerid, string, 92, 15.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:resetexamine(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return 1;
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /resetmota [playerid]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ket noi!");
	format(PlayerInfo[target][pExamineDesc], 256, "None");
	return SendClientMessageEx(playerid, COLOR_GREY, "Ban da reset thanh cong mo ta cua nguoi do.");
}

CMD:se(playerid, params[]) return callcmd::setexamine(playerid, params);
CMD:setexamine(playerid, params[]) return ShowPlayerDialogEx(playerid, DIALOG_SETEXAMINE, DIALOG_STYLE_INPUT, "Dat mo ta", "Hay mo ta ve ban than.\nVi du: la mot nguoi da trang", "Xac nhan", "Huy");

CMD:examine(playerid, params[])
{
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /mota [playerid]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ket noi!");
	if(!ProxDetectorS(5.0, playerid, target) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
	if(!strlen(PlayerInfo[target][pExamineDesc]) || !strcmp(PlayerInfo[target][pExamineDesc], "None", true)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong co phan mo ta.");
	if(strlen(PlayerInfo[target][pExamineDesc]) > 101)
	{
		new firstline[128], secondline[128];
		strmid(firstline, PlayerInfo[target][pExamineDesc], 0, 101);
		strmid(secondline, PlayerInfo[target][pExamineDesc], 101, 128);
		format(firstline, sizeof(firstline), "* %s %s", GetPlayerNameEx(target), firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		SendClientMessageEx(playerid, COLOR_PURPLE, firstline);
		SendClientMessageEx(playerid, COLOR_PURPLE, secondline);
	}
	else
	{
		new string[128];
		format(string, sizeof(string), "* %s %s", GetPlayerNameEx(target), PlayerInfo[target][pExamineDesc]);
		SendClientMessageEx(playerid, COLOR_PURPLE, string);
	}
	return 1;
}
