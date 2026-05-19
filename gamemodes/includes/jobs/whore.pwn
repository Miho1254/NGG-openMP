/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Whore System

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

CMD:sex(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 3 || PlayerInfo[playerid][pJob2] == 3 || PlayerInfo[playerid][pJob3] == 3)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban can ngoi tren xe moi co the Sex!");
			return 1;
		}
		new Car = GetPlayerVehicleID(playerid);

		new string[128], giveplayerid, money;
		if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /sex [player] [price]");

		if(money < 1 || money > 10000) { SendClientMessageEx(playerid, COLOR_GREY, "Gia tien khong duoc it hon $1 va cao hon $10,000!"); return 1; }
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the thuc hien lenh nay voi chinh minh!"); return 1; }
					if(IsPlayerInAnyVehicle(playerid) && IsPlayerInVehicle(giveplayerid, Car))
					{
						if(gettime() >= PlayerInfo[playerid][pSexTime])
						{
							format(string, sizeof(string), "* Ban de nghi %s sex voi ban, voi gia $%s.", GetPlayerNameEx(giveplayerid), number_format(money));
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
							format(string, sizeof(string), "* Gai diem %s da de nghi ban sex voi ho, voi gia $%s (nhap /chapnhan sex) de chap nhan.", GetPlayerNameEx(playerid), number_format(money));
							SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
							SetPVarInt(playerid, "SexOfferTo", giveplayerid);
							SexOffer[giveplayerid] = playerid;
							SexPrice[giveplayerid] = money;
							PlayerInfo[playerid][pSexTime] = gettime()+60;
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang sex voi ai do, hay cho mot lat moi co thuc hien lai!");
							return 1;
						}
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Ban can ngoi trong xe oto de thuc hien sex!");
						return 1;
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong dung gan ban.");
					return 1;
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Gai diem!");
	}
	return 1;
}
