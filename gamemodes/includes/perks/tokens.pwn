/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Token System

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

CMD:tokenhelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"____________________TRO GIUP TOKEN____________________");
    SendClientMessageEx(playerid, COLOR_GRAD3,"Ban co the dung VIP Token de lay vu khi tai tu do VIP.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"Ban co the mua VIP Token tai Misc Shop hoac nhan hop qua.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"Moi vu khi trong tu do vip co gia 1-5 VIP Token, tuy loai vu khi.");

    SendClientMessageEx(playerid, COLOR_GRAD3,"Ban co the dua cho nguoi khac VIP Token bang lenh (/givetokens).");
    return 1;
}

CMD:random(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] >= 1337) {

		new
			iHours,
			iBroadcast;

		if(sscanf(params, "dd", iHours, iBroadcast)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /random [hours] [broadcast]");
		}

		new
			arr_Winners[MAX_PLAYERS],
			iWinCount;

		foreach(new i: Player)
		{
			if(SeeSpecialTokens(i, iHours)) arr_Winners[iWinCount++] = i;
		}
		if(iWinCount > 0) {

			new
				iWinrar = arr_Winners[random(iWinCount)],
				szMessage[48 + MAX_PLAYER_NAME];

			if(iBroadcast == 1) {
				format(szMessage, sizeof(szMessage), "%s was just randomly selected! Congratulations!", GetPlayerNameEx(iWinrar));
				SendClientMessageToAllEx(COLOR_WHITE, szMessage);
			}
			else {
				format(szMessage, sizeof(szMessage), "%s (ID %d) was randomly selected.", GetPlayerNameEx(iWinrar), iWinrar);
				ABroadCast(COLOR_YELLOW, szMessage, 1338);
			}
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "Nobody online can win!");
	}
	return 1;
}

CMD:vrandom(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] >= 1337) {

		new
			iHours,
			iBroadcast;

		if(sscanf(params, "dd", iHours, iBroadcast)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /vrandom [hours] [broadcast]");
		}

		new
			arr_Winners[MAX_PLAYERS],
			iWinCount;

		foreach(new i: Player)
		{
			if(SeeSpecialTokens(i, iHours) && PlayerInfo[i][pDonateRank] > 0) arr_Winners[iWinCount++] = i;
		}	
		if(iWinCount > 0) {

			new
				iWinrar = arr_Winners[random(iWinCount)],
				szMessage[48 + MAX_PLAYER_NAME];

			if(iBroadcast == 1) {
				format(szMessage, sizeof(szMessage), "%s was just randomly selected! Congratulations!", GetPlayerNameEx(iWinrar));
				SendClientMessageToAllEx(COLOR_WHITE, szMessage);
			}
			else {
				format(szMessage, sizeof(szMessage), "%s (ID %d) was randomly selected.", GetPlayerNameEx(iWinrar), iWinrar);
				ABroadCast(COLOR_YELLOW, szMessage, 1338);
			}
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "Nobody online can win!");
	}
	return 1;
}

CMD:givetokens(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] > 0)
	{
		new string[128], giveplayerid, amount;
		if(sscanf(params, "ud", giveplayerid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givetokens [player] [amount]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pDonateRank] > 0)
			{
				if(PlayerInfo[playerid][pTokens] >= amount)
				{
					if(amount < 1)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "You can not give that amount!");
						return 1;
					}
					if(giveplayerid == playerid)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "You can not give tokens to yourself!");
						return 1;
					}
					if (!ProxDetectorS(5.0, playerid, giveplayerid))
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
						return 1;
					}
					PlayerInfo[playerid][pTokens] -= amount;
					PlayerInfo[giveplayerid][pTokens] += amount;

					format(string, sizeof(string), "You have received %d Tokens from %s.", amount, GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "Ban da cho %s %d Tokens.", GetPlayerNameEx(giveplayerid), amount);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s da duoc cho %s some Tokens.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong cothat many tokens!");
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "That person is not a VIP!");
			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong phai la VIP!");
	}
	return 1;
}

CMD:settoken(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new string[128], giveplayerid, amount;
		if(sscanf(params, "ud", giveplayerid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /settoken [player] [amount]");

		if(IsPlayerConnected(giveplayerid))
		{
			PlayerInfo[giveplayerid][pTokens] = amount;
			format(string, sizeof(string), "You have set %s's tokens to %d !",GetPlayerNameEx(giveplayerid),amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "VIP: Admin %s has set your tokens to %d.",GetPlayerNameEx(playerid),amount);
			SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);

			format(string, sizeof(string), "%s has set %s's(%d) tokens to %d.",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), amount);
			Log("logs/stats.log", string);

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}

CMD:givetoken(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new string[128], giveplayerid, amount;
		if(sscanf(params, "ud", giveplayerid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givetoken [player] [amount]");

		if(IsPlayerConnected(giveplayerid))
		{
			PlayerInfo[giveplayerid][pTokens] += amount;
			format(string, sizeof(string), "Ban da cho %s %d tokens !",GetPlayerNameEx(giveplayerid),amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "VIP: Admin %s da duoc cho you %d tokens.",GetPlayerNameEx(playerid),amount);
			SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);

			format(string, sizeof(string), "%s da duoc cho %s(%d) %d tokens.",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), amount);
			Log("logs/stats.log", string);

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}