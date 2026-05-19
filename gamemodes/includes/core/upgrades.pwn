/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Upgrades System

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

CMD:resetupgrades(playerid, params[]) {
	if(gPlayerLogged{playerid} == 0) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not logged in.");
	}
	else if (GetPlayerCash(playerid) < 100000) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You need $100,000 to reset your upgrade points.");
	}
	else if (PlayerInfo[playerid][pLevel] < 2) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You must be at least level 2.");
	}
	else {
		PlayerInfo[playerid][gPupgrade] = (PlayerInfo[playerid][pLevel]-1)*2;
		PlayerInfo[playerid][pSHealth] = 0.0;

		if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID) {
			HouseInfo[PlayerInfo[playerid][pPhousekey]][hGLUpgrade] = 1;
			SaveHouse(PlayerInfo[playerid][pPhousekey]);
		}
		if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID) {
			HouseInfo[PlayerInfo[playerid][pPhousekey2]][hGLUpgrade] = 1;
			SaveHouse(PlayerInfo[playerid][pPhousekey2]);
		}
		if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID) {
			HouseInfo[PlayerInfo[playerid][pPhousekey3]][hGLUpgrade] = 1;
			SaveHouse(PlayerInfo[playerid][pPhousekey3]);
		}	
		for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
		{
			PlayerVehicleInfo[playerid][d][pvWepUpgrade] = 0;
		}

		GivePlayerCash(playerid,-100000);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

		new	szMessage[73];

		format(szMessage, sizeof(szMessage), "You have reset your upgrades - you now have %i unspent upgrade points.", PlayerInfo[playerid][gPupgrade]);
		SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
	}
	return 1;
}
// Auto Levels
LevelCheck(playerid)
{
	if (gPlayerLogged{playerid} != 0)
	{
		if(PlayerInfo[playerid][pLevel] >= 0)
		{
			new nxtlevel = PlayerInfo[playerid][pLevel]+1;
			new expamount = nxtlevel*4;

			if (PlayerInfo[playerid][pExp] < expamount)
			{
				return 0;
			}
			else if(PlayerInfo[playerid][pExp] > expamount)
			{
				while(PlayerInfo[playerid][pExp] > expamount) 
				{
					PlayerInfo[playerid][pLevel]++;
					PlayerInfo[playerid][pExp] = PlayerInfo[playerid][pExp]-expamount;
					PlayerInfo[playerid][gPupgrade] = PlayerInfo[playerid][gPupgrade]+2;
					SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
					nxtlevel = PlayerInfo[playerid][pLevel]+1;
					expamount = nxtlevel*4;
				}
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban da co nhieu diem Respect Point, do do cap do cua ban se duoc dieu chinh thanh %d.", PlayerInfo[playerid][pLevel]);
				return 1;
			}
			else
			{
				new string[92];
				format(string, sizeof(string), "~g~LEVEL UP~n~~w~Hien tai ban dat duoc Level %d", nxtlevel);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pLevel]++;
				PlayerInfo[playerid][pExp] = PlayerInfo[playerid][pExp]-expamount;
				PlayerInfo[playerid][gPupgrade] = PlayerInfo[playerid][gPupgrade]+2;
				GameTextForPlayer(playerid, string, 5000, 1);
				format(string, sizeof(string), "[!] Ban da len cap %d, va nhan duoc %i diem nang cap! /nangcap de su dung.", nxtlevel, PlayerInfo[playerid][gPupgrade]);
				SendClientMessageEx(playerid, COLOR_GREEN, string);
				SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
				if(PlayerInfo[playerid][pLevel] == 3)
				{
				    new szQuery[128],
						szString[128],
						szReferrer = ReturnUser(PlayerInfo[playerid][pReferredBy]);

					if(strcmp(PlayerInfo[playerid][pReferredBy], "Nobody") != 0)
					{
					    if(IsPlayerConnected(szReferrer))
					    {
					        if(PlayerInfo[szReferrer][pRefers] < 5 && PlayerInfo[szReferrer][pRefers] > 0)
					        {
					            PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 100 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
						    }
					        else if(PlayerInfo[szReferrer][pRefers] == 5)
					        {
	            				PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL*5;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL*5);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 500 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
							}
							else if(PlayerInfo[szReferrer][pRefers] < 10 && PlayerInfo[szReferrer][pRefers] > 5)
					        {
					            PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 100 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
						    }
							else if(PlayerInfo[szReferrer][pRefers] == 10)
							{
							    PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL*10;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL*10);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 1000 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
							}
							else if(PlayerInfo[szReferrer][pRefers] < 15 && PlayerInfo[szReferrer][pRefers] > 10)
					        {
					            PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 100 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
						    }
							else if(PlayerInfo[szReferrer][pRefers] == 15)
							{
							    PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL*15;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL*15);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 1500 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
							}
							else if(PlayerInfo[szReferrer][pRefers] < 20 && PlayerInfo[szReferrer][pRefers] > 15)
					        {
					            PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 100 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
						    }
							else if(PlayerInfo[szReferrer][pRefers] == 20)
							{
							    PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL*20;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL*20);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 2000 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
							}
							else if(PlayerInfo[szReferrer][pRefers] < 25 && PlayerInfo[szReferrer][pRefers] > 20)
					        {
					            PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 100 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
						    }
							else if(PlayerInfo[szReferrer][pRefers] >= 25)
							{
							    PlayerInfo[szReferrer][pCredits] += CREDITS_AMOUNT_REFERRAL*25;
	            				PlayerInfo[szReferrer][pRefers] ++;
								mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[szReferrer][pCredits], GetPlayerNameExt(szReferrer));
								mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
								format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(szReferrer), GetPlayerSQLId(szReferrer), CREDITS_AMOUNT_REFERRAL*25);
								Log("logs/referral.log", szString);
				        		format(string, sizeof(string), "Your friend '%s' that you referred to the server has reached level 3. Therefore you have received 2500 credits.", GetPlayerNameEx(playerid));
						        SendClientMessageEx(szReferrer, COLOR_LIGHTBLUE, string);
							}
					    }
					    else {
					        mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `PendingRefReward`=1 WHERE `Username`='%s'", PlayerInfo[playerid][pReferredBy]);
					        mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "iii", REWARD_REFERRAL_THREAD, playerid, g_arrQueryHandle{playerid});
						}
					}
				}
				if(PlayerInfo[playerid][pLevel] == 6)
				{
				    SendClientMessageEx(playerid, COLOR_WHITE, "Newbie chat will now be automatically togged off on login.");
				}
			}
		}
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not logged in.");
	}
	return 1;
}


CMD:nangcap(playerid, params[])
{
	if(isnull(params))
	{
		new string[64];
		format(string, sizeof(string), "SU DUNG: /nangcap [tuy chon] (Hien tai ban co %d diem nang cap).",PlayerInfo[playerid][gPupgrade]);
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessageEx(playerid, COLOR_WHITE,"*** NANG CAP ***");
		SendClientMessageEx(playerid, COLOR_GRAD2,string);
		SendClientMessageEx(playerid, COLOR_GRAD5, "TUY CHON: giap, copxe, gunlocker, gunlocker2, gunlocker3.");
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "LUU Y: gunlocker la ngoi nha (1), gunlocker2 la ngoi nha (2), gunlocker3 la ngoi nha (3).");
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		return 1;
	}
	if( PlayerInfo[playerid][gPupgrade] >= 1 )
	{
		if (PlayerInfo[playerid][pLevel] >= 1 && strcmp(params, "giap", true) == 0)
		{
			if (PlayerInfo[playerid][pSHealth] < 100)
			{
				new string[51];
				++PlayerInfo[playerid][pSHealth];
				PlayerInfo[playerid][gPupgrade]--;
				format(string, sizeof(string), "Nang cap thanh cong: Khi hoi sinh day ban se nhan duoc %.2f giap.",PlayerInfo[playerid][pSHealth]);
				SendClientMessageEx(playerid, COLOR_GREEN, string);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD6, "Ban da nang cap giap den muc do toi da.");
				return 1;
			}
		}
		else if(strcmp(params, "gunlocker", true) == 0)
		{
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid))
			{
				if( PlayerInfo[playerid][gPupgrade] < 2 )
				{
					SendClientMessageEx(playerid, COLOR_GRAD6, "Ban can co it nhat 2 diem nang cap.");
					return 1;
				}
				switch(HouseInfo[PlayerInfo[playerid][pPhousekey]][hGLUpgrade])
				{
					case 0:
					{
						if(PlayerInfo[playerid][pCash] >= 50000)
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hGLUpgrade] = 1;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hWeapons][0] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 1 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 1:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hWeapons][1] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 2 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 2:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hWeapons][2] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 3 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 3:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hWeapons][3] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 4 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 4:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey]][hWeapons][4] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 5 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 5:
					{
						SendClientMessageEx(playerid, COLOR_LIGHTRED, "Xin loi, ban da nhan cap tu do den muc toi da cho ngoi nha nay.");
						return 1;
					}
				}
				PlayerInfo[playerid][gPupgrade]--;
				SaveHouse(PlayerInfo[playerid][pPhousekey]);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la chu so huu ngoi nha so (2).");
				return 1;
			}
		}

		else if(strcmp(params, "gunlocker2", true) == 0)
		{
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid))
			{
				if( PlayerInfo[playerid][gPupgrade] < 2 )
				{
					SendClientMessageEx(playerid, COLOR_GRAD6, "Ban can co it nhat 2 diem nang cap.");
					return 1;
				}
				switch( HouseInfo[PlayerInfo[playerid][pPhousekey2]][hGLUpgrade] )
				{
					case 0:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hGLUpgrade] = 1;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hWeapons][0] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 1 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 1:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hWeapons][1] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 2 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 2:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hWeapons][2] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 3 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 3:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hWeapons][3] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 4 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 4:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey2]][hWeapons][4] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 5 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 5:
					{
						SendClientMessageEx(playerid, COLOR_LIGHTRED, "Xin loi, ban da nhan cap tu do den muc toi da cho ngoi nha nay.");
						return 1;
					}
				}
				PlayerInfo[playerid][gPupgrade]--;
				SaveHouse(PlayerInfo[playerid][pPhousekey2]);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la chu ngoi nha (3).");
				return 1;
			}
		}
		else if(strcmp(params, "gunlocker3", true) == 0)
		{
			new playername[MAX_PLAYER_NAME];
			GetPlayerName(playerid, playername, sizeof(playername));
			if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid))
			{
				if( PlayerInfo[playerid][gPupgrade] < 2 )
				{
					SendClientMessageEx(playerid, COLOR_GRAD6, "Ban can co it nhat 2 diem nang cap.");
					return 1;
				}
				switch( HouseInfo[PlayerInfo[playerid][pPhousekey3]][hGLUpgrade] )
				{
					case 0:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hGLUpgrade] = 1;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hWeapons][0] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 1 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 1:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hWeapons][1] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 2 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 2:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hWeapons][2] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 3 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 3:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hWeapons][3] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 4 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 4:
					{
						if( PlayerInfo[playerid][pCash] >= 50000 )
						{
							PlayerInfo[playerid][pCash] -= 50000;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hGLUpgrade]++;
							HouseInfo[PlayerInfo[playerid][pPhousekey3]][hWeapons][4] = 0;
							SendClientMessageEx(playerid, COLOR_GREEN, "Ban da mua them mot slot tu do trong nha cua ban, chi phi: $50.000.");
							SendClientMessageEx(playerid, COLOR_GRAD2, "MEO: De su dung tu do, ban hay su dung lenh /hcatsung va /hlaysung. Hien tai ban dang co 5 slot trong tu do." );
						}
						else
						{
							SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong co du tien de nang cap (Yeu cau: $50,000).");
							return 1;
						}
					}
					case 5:
					{
						SendClientMessageEx(playerid, COLOR_LIGHTRED, "Xin loi, ban da nhan cap tu do den muc toi da cho ngoi nha nay.");
						return 1;
					}
				}
				PlayerInfo[playerid][gPupgrade]--;
				SaveHouse(PlayerInfo[playerid][pPhousekey3]);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la chu ngoi nha nay.");
				return 1;
			}
		}
		else if(strcmp(params, "copxe", true) == 0)
		{
			new Float: x, Float: y, Float: z;
			for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
			{
				if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
				if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
				{
					if( PlayerInfo[playerid][gPupgrade] < 2 )
					{
						SendClientMessageEx(playerid, COLOR_GRAD6, "Ban can co it nhat 2 diem nang cap.");
						return 1;
					}
					if(PlayerVehicleInfo[playerid][d][pvWepUpgrade] < 2)
					{
						new string[114];
						GameTextForPlayer(playerid,"~g~Nang cap cop xe thanh cong!",5000,6);
						PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
						PlayerVehicleInfo[playerid][d][pvWepUpgrade]++;
						PlayerVehicleInfo[playerid][d][pvWeapons][PlayerVehicleInfo[playerid][d][pvWepUpgrade]] = 0;
						PlayerInfo[playerid][gPupgrade] = PlayerInfo[playerid][gPupgrade]-2;
						SendClientMessageEx(playerid, COLOR_GREEN, "Ban da nang cap mot cop xe moi.");
						format(string, sizeof(string), "MEO: De su dung cop xe ban hay su dung lenh /catsung va /laysung. Hien tai ban da co %d slot cop xe.", PlayerVehicleInfo[playerid][d][pvWepUpgrade]+1);
						SendClientMessageEx(playerid, COLOR_GRAD2, string );
						return 1;
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban da nang cap cop xe den muc do toi da.");
						return 1;
					}
				}
			}
			SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan phuong tien xe ma ban so huu.");
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD6, "Tuy chon nang cap khong chinh xac, hay thu lai.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD6, "Ban co 0 diem nang cap.");
		return 1;
	}
	return 1;
}