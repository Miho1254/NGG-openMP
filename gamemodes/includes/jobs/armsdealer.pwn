/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Arms Dealer Revision
								Winterfield

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

CMD:sellgun(playerid, params[])
{
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay luc nay.");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC tu chi duoc noi chuyen bang /b");
	if(PlayerInfo[playerid][pJob] == 9 || PlayerInfo[playerid][pJob2] == 9 || PlayerInfo[playerid][pJob3] == 9)
	{
		if(GetPVarInt(playerid, "pSellGunTime") > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai doi 10 giay nua truoc khi ban vu khi khac.");
		if(GetPVarType(playerid, "WatchingTV") || GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong the hut can khi dang xem TV.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong the ban sung trong khi lai xe!");
		if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   Ban khong the lam dieu nay trong khi Hunger Games Event!");
   		#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies khong the lam dieu nay.");
		#endif
		if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || (PlayerInfo[playerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1))
   		return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay luc nay!");
		if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "Bang co gang de lockpick, please wait.");
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay khi dang trong Arena!");
		if(PlayerInfo[playerid][pHospital]) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay luc nay.");

		szMiscArray[0] = 0;
		new id, weapon[16];
		if(sscanf(params, "us[16]", id, weapon)) 
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------");
			switch(PlayerInfo[playerid][pArmsSkill])
			{
				case 0 .. 49: // level 1
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(500)    knuckles(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "bat(500)            cane(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(500)         club(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "pool(500)        katana(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(500)          9mm(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(3500)");
				}
				case 50 .. 199: // level 2
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(500)    knuckles(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "bat(500)            cane(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(500)         club(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "pool(500)        katana(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(500)          9mm(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(3500)  shotgun(5000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(5000)");
				}
				case 200 .. 699: // level 3
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(500)    knuckles(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "bat(500)            cane(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(500)         club(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "pool(500)        katana(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(500)          9mm(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(3500)  shotgun(5000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(5000)		 rifle(10000)");
				}
				case 700 .. 1199:// Level 4 
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(500)    knuckles(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "bat(500)            cane(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(500)         club(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "pool(500)        katana(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(500)          9mm(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(3500)  shotgun(5000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(5000)		 rifle(10000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "tec9(8000)        	uzi(8000)");
				}
				default:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "flowers(500)    knuckles(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "bat(500)            cane(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "shovel(500)         club(500)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "pool(500)        katana(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "dildo(500)          9mm(2000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "sdpistol(3500)  shotgun(5000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "mp5(6000)		 rifle(10000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "tec9(8000)        	uzi(8000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "deagle(10000)");
				}
			}
			if(PlayerInfo[playerid][pArmsSkill] >= 700) SendClientMessageEx(playerid, COLOR_YELLOW, "ak47(50000) - Yeu cau VIP GOLD");
			SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "SU DUNG: /banvukhi [playerid] [vu khi]");
			return 1;
		}

		if(IsPlayerConnected(id))
		{
			if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_GRAD1, "Ban khong the ban sung cho ai do trong xe!");
			if(!ProxDetectorS(8.0, playerid, id)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong gan nguoi choi do.");
			if(PlayerInfo[id][pConnectHours] < 2 || PlayerInfo[id][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong the su dung vu khi!");

			if(strcmp(weapon, "Flowers", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 14);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 14);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Knuckles", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 1);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 1);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Bat", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 5);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 5);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Cane", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 15);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 15);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Shovel", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 6);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 6);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Club", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 2);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 2);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Pool", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 7);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 7);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Katana", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 2000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 2000;
						GivePlayerValidWeapon(id, 8);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 8);
						SetPVarInt(id, "pSellGunMats", 2000);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Dildo", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 500;
						GivePlayerValidWeapon(id, 10);
					}
					else
					{
						SetPVarInt(id, "pSellGun", 10);
						SetPVarInt(id, "pSellGunMats", 500);
						SetPVarInt(id, "pSellGunID", playerid);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "9mm", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 2000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 2000;
						GivePlayerValidWeapon(id, 22);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 22);
						SetPVarInt(id, "pSellGunMats", 2000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Shotgun", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 50)
			{
				if(PlayerInfo[playerid][pMats] >= 5000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 5000;
						GivePlayerValidWeapon(id, 25);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 25);
						SetPVarInt(id, "pSellGunMats", 5000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "SDPistol", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 0)
			{
				if(PlayerInfo[playerid][pMats] >= 3500)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 3500;
						GivePlayerValidWeapon(id, 23);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 23);
						SetPVarInt(id, "pSellGunMats", 3500);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Uzi", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 700)
			{
				if(PlayerInfo[playerid][pMats] >= 8000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 8000;
						GivePlayerValidWeapon(id, 28);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 28);
						SetPVarInt(id, "pSellGunMats", 8000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Tec9", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 700)
			{
				if(PlayerInfo[playerid][pMats] >= 8000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 8000;
						GivePlayerValidWeapon(id, 32);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 32);
						SetPVarInt(id, "pSellGunMats", 8000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Rifle", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 700)
			{
				if(PlayerInfo[playerid][pMats] >= 10000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 10000;
						GivePlayerValidWeapon(id, 33);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 33);
						SetPVarInt(id, "pSellGunMats", 10000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "mp5", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 50)
			{
				if(PlayerInfo[playerid][pMats] >= 5000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 5000;
						GivePlayerValidWeapon(id, 29);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 29);
						SetPVarInt(id, "pSellGunMats", 5000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Deagle", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 1200)
			{
				if(PlayerInfo[playerid][pMats] >= 10000)
				{
					if(id == playerid)
					{
						PlayerInfo[playerid][pMats] -= 10000;
						GivePlayerValidWeapon(id, 24);

						PlayerInfo[playerid][pArmsSkill] += 1;
					}
					else
					{
						SetPVarInt(id, "pSellGun", 24);
						SetPVarInt(id, "pSellGunMats", 10000);
						SetPVarInt(id, "pSellGunID", playerid);
						SetPVarInt(id, "pSellGunXP", 1);
					}
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
			}
			else if(strcmp(weapon, "Ak47", true) == 0 && PlayerInfo[playerid][pArmsSkill] >= 1200)
			{
				if(PlayerInfo[playerid][pDonateRank] > 2) {
					if(PlayerInfo[playerid][pMats] >= 50000)
					{
						if(id == playerid)
						{
							PlayerInfo[playerid][pMats] -= 50000;
							GivePlayerValidWeapon(id, 30);

							PlayerInfo[playerid][pArmsSkill] += 1;
						}
						else
						{
							SetPVarInt(id, "pSellGun", 30);
							SetPVarInt(id, "pSellGunMats", 50000);
							SetPVarInt(id, "pSellGunID", playerid);
							SetPVarInt(id, "pSellGunXP", 1);
						}
					}
					else return SendClientMessage(playerid, COLOR_WHITE, "Ban khong du vat lieu!");
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban phai la Gold VIP de rap vu khi nay!");
			}
			else 
			{
				return SendClientMessageEx(playerid, COLOR_GRAD1, "Vu khi khong hop le!");
			}
			weapon[0] = toupper(weapon[0]);

			if(id == playerid) 
			{ 
				format(szMiscArray, sizeof(szMiscArray), "* %s che tao mot %s tu vat lieu cua ho, va mang chung len nguoi.", GetPlayerNameEx(playerid), weapon); 
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it. -Winterfield
			}
			else 
			{
				format(szMiscArray, sizeof(szMiscArray), "Ban de nghi %s a %s.", GetPlayerNameEx(id), weapon);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s da de nghi ban cho ban mot %s, (nhap /chapnhan vukhi) de chap nhan.", GetPlayerNameEx(playerid), weapon);
				SendClientMessage(id, COLOR_LIGHTBLUE, szMiscArray);
			}

			SetPVarInt(playerid, "pSellGunTime", gettime() + 10);
			return 1; // Added so the error message would work.
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai!");
	}
	SendClientMessage(playerid, COLOR_GREY, "Ban khong co phai nguoi che tao vu khi!");
	return 1;
}
