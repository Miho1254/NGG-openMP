/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Paintball System

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

IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if (x > minx && x < maxx && y > miny && y < maxy) return 1;
    return 0;
}

stock PaintballEditMenu(playerid)
{
	new status[64];
	for(new i = 0; i < MAX_ARENAS; i++)
	{
	    if(PaintBallArena[i][pbLocked] == 0)
 	    {
 	        format(status,sizeof(status),"Mo");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 1)
 	    {
 	        format(status,sizeof(status),"Dang hoat dong");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 2)
 	    {
 	        format(status,sizeof(status),"Khoa");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 3)
 	    {
 	        format(status,sizeof(status),"Dang cai dat");
 	    }
		format(szMiscArray,sizeof(szMiscArray),"%s%s - \t(%s)\n",szMiscArray,PaintBallArena[i][pbArenaName],status);
	}
	ShowPlayerDialogEx(playerid,PBEDITMENU,DIALOG_STYLE_LIST,"Paintball Arena - Edit Menu:",szMiscArray,"Select","Back");
}

stock PaintballEditArenaMenu(playerid)
{
	if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }

	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	format(szMiscArray,sizeof(szMiscArray),"Edit Arena Name - (%s)\nEdit Deathmatch Positions...\nEdit Team Positions...\nEdit Flag Positions...\nEdit Hill Position...\nHill Radius (%f)\nInterior (%d)\nVirtual World (%d)\nWar Vehicle 1\nWar Vehicle 2\nWar Vehicle 3\nWar Vehicle 4\nWar Vehicle 5\nWar Vehicle 6",PaintBallArena[arenaid][pbArenaName],PaintBallArena[arenaid][pbHillRadius],PaintBallArena[arenaid][pbInterior],PaintBallArena[arenaid][pbVirtual]);
	ShowPlayerDialogEx(playerid,PBEDITARENAMENU,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena Menu:",szMiscArray,"Select","Back");
	return 1;
}

stock PaintballEditArenaName(playerid)
{
	if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }

	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	format(szMiscArray,sizeof(szMiscArray),"Enter a new Arena Name for Arena Slot %d:",arenaid);
	ShowPlayerDialogEx(playerid,PBEDITARENANAME,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Name:",szMiscArray,"Change","Back");
	return 1;
}

stock PaintballEditArenaDMSpawns(playerid)
{
    if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }
	ShowPlayerDialogEx(playerid,PBEDITARENADMSPAWNS,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena DM Spawns:","Deathmatch Spawn 1\nDeathmatch Spawn 2\nDeathmatch Spawn 3\nDeathmatch Spawn 4","Change","Back");
	return 1;
}

stock PaintballEditArenaTeamSpawns(playerid)
{
	if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }
	ShowPlayerDialogEx(playerid,PBEDITARENATEAMSPAWNS,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena Team Spawns:","Red Team Spawn 1\nRed Team Spawn 2\nRed Team Spawn 3\nBlue Team Spawn 1\nBlue Team Spawn 2\nBlue Team Spawn 3","Change","Back");
	return 1;
}

stock PaintballEditArenaFlagSpawns(playerid)
{
	if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }
	ShowPlayerDialogEx(playerid,PBEDITARENAFLAGSPAWNS,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena Flag Spawns:","Red Team Flag\nBlue Team Flag","Change","Back");
	return 1;
}

stock PaintballEditArenaInt(playerid)
{
	if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }
	ShowPlayerDialogEx(playerid,PBEDITARENAINT,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Interior:","Please enter a new interior id to place on the Arena:","Change","Back");
	return 1;
}

stock PaintballEditArenaVW(playerid)
{
	if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }
	ShowPlayerDialogEx(playerid,PBEDITARENAVW,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Virtual World:","Please enter a new virtual world id to place on the Arena:","Change","Back");
	return 1;
}

stock PaintballEditArenaHillRadius(playerid)
{
	if(!GetPVarType(playerid, "ArenaNumber")) { return 1; }
	ShowPlayerDialogEx(playerid,PBEDITARENAHILLRADIUS,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Hill Radius:","Please enter a new hill radius for the Arena:","Change","Back");
	return 1;
}

stock PaintballScoreboard(playerid, arenaid)
{
	szMiscArray[0] = 0;
	
	if(!GetPVarType(playerid, "IsInArena")) return 1;

	new titlestring[128];

 	foreach(new p: Player)
	{
		if(!GetPVarType(p, "IsInArena")) continue;
		if(GetPVarInt(p, "IsInArena") == arenaid)
		{
			if(PaintBallArena[arenaid][pbGameType] == 1)
			{
				format(szMiscArray,sizeof(szMiscArray),"%s(ID: %d) %s - (Giet: %d) (Chet: %d) (Ping: %d)\n", szMiscArray, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],PlayerInfo[p][pDeaths],GetPlayerPing(p));
			}
			if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3)
			{
				switch(PlayerInfo[p][pPaintTeam])
				{
					case 1: // Red Team
					{
						format(szMiscArray,sizeof(szMiscArray),"%s(ID: %d) ({FF0000}Red Team{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", szMiscArray, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
					case 2: // Blue Team
					{
						format(szMiscArray,sizeof(szMiscArray),"%s(ID: %d) ({0000FF}Blue Team{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", szMiscArray, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
				}
			}
			if(PaintBallArena[arenaid][pbGameType] == 4)
			{
				format(szMiscArray,sizeof(szMiscArray),"%s(ID: %d) %s - (Diem: %d) (Ping: %d)\n", szMiscArray, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
			}
			if(PaintBallArena[arenaid][pbGameType] == 5)
			{
				switch(PlayerInfo[p][pPaintTeam])
				{
					case 1: // Red Team
					{
						format(szMiscArray,sizeof(szMiscArray),"%s(ID: %d) ({FF0000}Red Team{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", szMiscArray, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
					case 2: // Blue Team
					{
						format(szMiscArray,sizeof(szMiscArray),"%s(ID: %d) ({0000FF}Blue Team{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", szMiscArray, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
				}
			}
		}
	}	
	switch (PaintBallArena[arenaid][pbGameType])
	{
		case 1: // Deathmatch
		{
			format(titlestring,sizeof(titlestring),"(DM) Diem so - Thoi gian con lai: (%d)",PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 2: // Team Deathmatch
		{
		    format(titlestring,sizeof(titlestring),"(TDM) Diem so - Red: (%d) - Blue: (%d) - Thoi gian con lai: (%d)",
			PaintBallArena[arenaid][pbTeamRedKills],
			PaintBallArena[arenaid][pbTeamBlueKills],
			PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 3: // Capture The Flag
		{
		    format(titlestring,sizeof(titlestring),"(CTF) Diem so - Red: (%d) - Blue: (%d) - Thoi gian con lai: (%d)",PaintBallArena[arenaid][pbTeamRedScores],PaintBallArena[arenaid][pbTeamBlueScores],PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 4: // King of the Hill
		{
		    format(titlestring,sizeof(titlestring),"(KOTH) Diem so - Thoi gian con lai: (%d)",PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 5: // Team King of the Hill
		{
		    format(titlestring,sizeof(titlestring),"(TKOTH) Diem so - Red: (%d) - Blue: (%d) - Thoi gian con lai (%d)",PaintBallArena[arenaid][pbTeamRedScores],PaintBallArena[arenaid][pbTeamBlueScores],PaintBallArena[arenaid][pbTimeLeft]);
		}
	}
	ShowPlayerDialogEx(playerid,PBARENASCORES,DIALOG_STYLE_LIST,titlestring,szMiscArray,"Cap nhat","Thoat");
	return 1;
}

stock PaintballArenaSelection(playerid)
{
	new status[64], gametype[64], eperm[64], war[32], limit, count, money;
 	for(new i = 0; i < MAX_ARENAS; i++) if(!isnull(PaintBallArena[i][pbArenaName]))
 	{
 	    limit = PaintBallArena[i][pbLimit];
 	    count = PaintBallArena[i][pbPlayers];
 	    money = PaintBallArena[i][pbBidMoney];

 	    if(PaintBallArena[i][pbLocked] == 0)
 	    {
 	        format(status,sizeof(status),"{00FF00}Mo{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 1)
 	    {
 	        format(status,sizeof(status),"{00FF00}Dang hoat dong{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 2)
 	    {
 	        format(status,sizeof(status),"{FF0000}Khoa{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 3)
 	    {
 	        format(status,sizeof(status),"{FF6600}Dang cai dat{FFFFFF}");
 	    }

 	    if(PaintBallArena[i][pbGameType] == 1)
 	    {
 	        format(gametype,sizeof(gametype),"DM");
		}
		if(PaintBallArena[i][pbGameType] == 2)
		{
		    format(gametype,sizeof(gametype),"TDM");
		}
		if(PaintBallArena[i][pbGameType] == 3)
		{
		    format(gametype,sizeof(gametype),"CTF");
		}
		if(PaintBallArena[i][pbGameType] == 4)
		{
		    format(gametype,sizeof(gametype),"KOTH");
		}
		if(PaintBallArena[i][pbGameType] == 5)
		{
		    format(gametype,sizeof(gametype),"TKOTH");
		}

		if(PaintBallArena[i][pbExploitPerm] == 0)
		{
		    format(eperm,sizeof(eperm),"{FF0000}No QS/CS{FFFFFF}");
		}
		if(PaintBallArena[i][pbExploitPerm] == 1)
		{
		    format(eperm,sizeof(eperm),"{00FF00}QS/CS{FFFFFF}");
		}
		
		if(PaintBallArena[i][pbWar] == 0)
		{
			format(war, sizeof(war), "");
		}
		if(PaintBallArena[i][pbWar] == 1)
		{
			format(war, sizeof(war), " ({FFFF00}War{FFFFFF})");
		}

		if(!strcmp(PaintBallArena[i][pbPassword], "none", false))
		{
 	    	format(szMiscArray,sizeof(szMiscArray),"%s{FFFFFF}%s - \t(%s) (%s) (%s) (%d/%d) ($%d) (%s)%s\n",szMiscArray,PaintBallArena[i][pbArenaName],PaintBallArena[i][pbOwner],status,gametype,count,limit,money,eperm,war);
		}
		else
		{
		    format(szMiscArray,sizeof(szMiscArray),"%s{FFFFFF}%s - \t(%s) (%s) (%s) (%d/%d) ($%d) (%s)%s (PW)\n",szMiscArray,PaintBallArena[i][pbArenaName],PaintBallArena[i][pbOwner],status,gametype,count,limit,money,eperm,war);
		}
	}
	ShowPlayerDialogEx(playerid,PBARENASELECTION,DIALOG_STYLE_LIST,"Paintball Arena - Chon phong:",szMiscArray,"Chon","Tro ve");
}

stock PaintballTokenBuyMenu(playerid)
{
	format(szMiscArray,sizeof(szMiscArray),"{FFFFFF}Ban muon mua bao nhieu Paintball Token?\n\n1 PB co gia la $%d. Ban dang so huu {AA3333}%d{FFFFFF} PB Tokens.", 5000, PlayerInfo[playerid][pPaintTokens]);
	ShowPlayerDialogEx(playerid,PBTOKENBUYMENU,DIALOG_STYLE_INPUT,"Paintball Arena - Mua PB:",szMiscArray,"Mua","Tro ve");
}

stock PaintballSetupArena(playerid)
{
	new gametype[32], password[64], wepname1[128], wepname2[128], wepname3[128], eperm[64], finstagib[64], fnoweapons[64], war[32];
	new timelimit, limit, money, Float:health, Float:armor, wep1, wep2, wep3;
	new a = GetPVarInt(playerid, "ArenaNumber");

	format(password,sizeof(password),"%s", PaintBallArena[a][pbPassword]);
	timelimit = PaintBallArena[a][pbTimeLeft]/60;
	limit = PaintBallArena[a][pbLimit];
	money = PaintBallArena[a][pbBidMoney];
	health = PaintBallArena[a][pbHealth];
	armor = PaintBallArena[a][pbArmor];
	wep1 = PaintBallArena[a][pbWeapons][0];
	wep2 = PaintBallArena[a][pbWeapons][1];
	wep3 = PaintBallArena[a][pbWeapons][2];

	GetWeaponName(wep1,wepname1,sizeof(wepname1));
	GetWeaponName(wep2,wepname2,sizeof(wepname2));
	GetWeaponName(wep3,wepname3,sizeof(wepname3));

	if(PaintBallArena[a][pbGameType] == 1)
	{
		format(gametype,sizeof(gametype),"DM");
	}
	if(PaintBallArena[a][pbGameType] == 2)
	{
	    format(gametype,sizeof(gametype),"TDM");
	}
	if(PaintBallArena[a][pbGameType] == 3)
	{
	    format(gametype,sizeof(gametype),"CTF");
	}
	if(PaintBallArena[a][pbGameType] == 4)
	{
	    format(gametype,sizeof(gametype),"KOTH");
	}
	if(PaintBallArena[a][pbGameType] == 5)
	{
	    format(gametype,sizeof(gametype),"TKOTH");
	}

	if(PaintBallArena[a][pbExploitPerm] == 0)
	{
		format(eperm,sizeof(eperm),"Not Allowed");
	}
	if(PaintBallArena[a][pbExploitPerm] == 1)
	{
	    format(eperm,sizeof(eperm),"Allowed");
	}

	if(PaintBallArena[a][pbFlagInstagib] == 0)
	{
	    format(finstagib,sizeof(finstagib),"Off");
	}
	if(PaintBallArena[a][pbFlagInstagib] == 1)
	{
	    format(finstagib,sizeof(finstagib),"On");
	}

	if(PaintBallArena[a][pbFlagNoWeapons] == 0)
	{
	    format(fnoweapons,sizeof(fnoweapons),"Off");
	}
	if(PaintBallArena[a][pbFlagNoWeapons] == 1)
	{
	    format(fnoweapons,sizeof(fnoweapons),"On");
	}
	if(PaintBallArena[a][pbWar] == 0)
	{
		format(war, sizeof(war), "Off");
	}
	if(PaintBallArena[a][pbWar] == 1)
	{
		format(war, sizeof(war), "On");
	}

	switch(PaintBallArena[a][pbGameType])
	{
	    case 1:
	    {
	        format(szMiscArray,sizeof(szMiscArray),"Mat khau - (%s)\nThe loai - (%s)\nGioi han nguoi choi - (%d)\nThoi gian tran dau - (%d Phut)\nGia tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nVu khi 1 - (%s)\nVu khi 2 - (%s)\nVu khi 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBat dau arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	    case 2:
	    {
	        format(szMiscArray,sizeof(szMiscArray),"Mat khau - (%s)\nThe loai - (%s)\nGioi han nguoi choi - (%d)\nThoi gian tran dau - (%d Phut)\nGia tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nVu khi 1 - (%s)\nVu khi 2 - (%s)\nVu khi 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBat dau arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	    case 3:
	    {
	        format(szMiscArray,sizeof(szMiscArray),"Mat khau - (%s)\nThe loai - (%s)\nGioi han nguoi choi - (%d)\nThoi gian tran dau - (%d Phut)\nGia tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nVu khi 1 - (%s)\nVu khi 2 - (%s)\nVu khi 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nFlag Instagib - (%s)\nFlag No Weapons - (%s)\nBat dau arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war,finstagib,fnoweapons);
	    }
	    case 4:
	    {
	        format(szMiscArray,sizeof(szMiscArray),"Mat khau - (%s)\nThe loai - (%s)\nGioi han nguoi choi - (%d)\nThoi gian tran dau - (%d Phut)\nGia tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nVu khi 1 - (%s)\nVu khi 2 - (%s)\nVu khi 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBat dau arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	    case 5:
	    {
	        format(szMiscArray,sizeof(szMiscArray),"Mat khau - (%s)\nThe loai - (%s)\nGioi han nguoi choi - (%d)\nThoi gian tran dau - (%d Phut)\nGia tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nVu khi 1 - (%s)\nVu khi 2 - (%s)\nVu khi 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBat dau arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	}
	ShowPlayerDialogEx(playerid,PBSETUPARENA,DIALOG_STYLE_LIST,"Khu vuc dau truong - Cai dat dau truong:",szMiscArray,"Chon","Thoat");
}

stock PaintballSwitchTeam(playerid)
{
	new arenaid = GetPVarInt(playerid, "IsInArena");
	new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
	format(szMiscArray, sizeof(szMiscArray),"{FF0000}Red Team (%d/%d)\n{0000FF}Blue Team (%d/%d)",PaintBallArena[arenaid][pbTeamRed],teamlimit,PaintBallArena[arenaid][pbTeamBlue],teamlimit);
	ShowPlayerDialogEx(playerid,PBSWITCHTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Chon team:", szMiscArray,"Chon","Huy");
}

stock InitPaintballArenas()
{
	for(new i = 0; i < MAX_ARENAS; i++)
	{
	    format(szMiscArray, sizeof(szMiscArray), "Unoccupied");
		strmid(PaintBallArena[i][pbOwner], szMiscArray, 0, strlen(szMiscArray), 64);

		format(szMiscArray, sizeof(szMiscArray), "None");
		strmid(PaintBallArena[i][pbPassword], szMiscArray, 0, strlen(szMiscArray), 64);

	    PaintBallArena[i][pbGameType] = 1;
  		PaintBallArena[i][pbActive] = 0;
  		PaintBallArena[i][pbExploitPerm] = 0;
		PaintBallArena[i][pbWar] = 0;
  		PaintBallArena[i][pbFlagInstagib] = 0;
  		PaintBallArena[i][pbFlagNoWeapons] = 0;
  		PaintBallArena[i][pbTimeLeft] = 900;
  		PaintBallArena[i][pbHealth] = 100;
   		PaintBallArena[i][pbArmor] = 99;
   		PaintBallArena[i][pbLocked] = 0;
		PaintBallArena[i][pbLimit] = 16;
		PaintBallArena[i][pbPlayers] = 0;
		PaintBallArena[i][pbTeamRed] = 0;
		PaintBallArena[i][pbTeamBlue] = 0;
		PaintBallArena[i][pbBidMoney] = 500;
		PaintBallArena[i][pbMoneyPool] = 0;
		PaintBallArena[i][pbWeapons][0] = 29;
		PaintBallArena[i][pbWeapons][1] = 24;
		PaintBallArena[i][pbWeapons][2] = 27;
		PaintBallArena[i][pbHillX] = 0.0;
		PaintBallArena[i][pbHillY] = 0.0;
		PaintBallArena[i][pbHillZ] = 0.0;
		PaintBallArena[i][pbHillRadius] = 0.0;
	}
	return 1;
}

stock ResetPaintballArena(arenaid)
{
	format(szMiscArray, sizeof(szMiscArray), "Khong co ai ca");
	strmid(PaintBallArena[arenaid][pbOwner], szMiscArray, 0, strlen(szMiscArray), 64);
	format(szMiscArray, sizeof(szMiscArray), "None");
	strmid(PaintBallArena[arenaid][pbPassword], szMiscArray, 0, strlen(szMiscArray), 64);

	if(PaintBallArena[arenaid][pbGameType] == 3) {
	    if(PaintBallArena[arenaid][pbFlagRedActive] == 1) {
	        Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
		}
		if(PaintBallArena[arenaid][pbFlagBlueActive] == 1) {
		    Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
		}
	    Delete3DTextLabel(PaintBallArena[arenaid][pbTeamRedTextID]);
		Delete3DTextLabel(PaintBallArena[arenaid][pbTeamBlueTextID]);
		DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
		DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	}

	if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) {
	    ResetPaintballArenaHill(arenaid);
	}

  	PaintBallArena[arenaid][pbGameType] = 1;
  	PaintBallArena[arenaid][pbActive] = 0;
  	PaintBallArena[arenaid][pbExploitPerm] = 0;
	PaintBallArena[arenaid][pbWar] = 0;
  	PaintBallArena[arenaid][pbFlagInstagib] = 0;
	PaintBallArena[arenaid][pbFlagNoWeapons] = 0;
  	PaintBallArena[arenaid][pbTimeLeft] = 900;
  	PaintBallArena[arenaid][pbHealth] = 100;
   	PaintBallArena[arenaid][pbArmor] = 99;
   	PaintBallArena[arenaid][pbLocked] = 0;
	PaintBallArena[arenaid][pbLimit] = 16;
	PaintBallArena[arenaid][pbPlayers] = 0;
	PaintBallArena[arenaid][pbTeamRed] = 0;
	PaintBallArena[arenaid][pbTeamBlue] = 0;
	PaintBallArena[arenaid][pbBidMoney] = 500;
	PaintBallArena[arenaid][pbMoneyPool] = 0;
	PaintBallArena[arenaid][pbWeapons][0] = 29;
	PaintBallArena[arenaid][pbWeapons][1] = 24;
	PaintBallArena[arenaid][pbWeapons][2] = 27;
	PaintBallArena[arenaid][pbTeamRedKills] = 0;
	PaintBallArena[arenaid][pbTeamBlueKills] = 0;
	PaintBallArena[arenaid][pbTeamRedDeaths] = 0;
	PaintBallArena[arenaid][pbTeamBlueDeaths] = 0;
	
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh1ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh1ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh2ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh2ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh3ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh3ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh4ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh4ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh5ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh5ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh6ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh6ID]);
	}
	PaintBallArena[arenaid][pbVeh1ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh2ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh3ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh4ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh5ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh6ID] = INVALID_VEHICLE_ID;
	return 1;
}

stock CreatePaintballArenaHill(arenaid) {
	PaintBallArena[arenaid][pbHillTextID] = Create3DTextLabel("Hill", COLOR_GREEN, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], 200.0, PaintBallArena[arenaid][pbVirtual], 0);
}

stock ResetPaintballArenaHill(arenaid) {
    Delete3DTextLabel(PaintBallArena[arenaid][pbHillTextID]);
}

stock SortWinnerPaintballScores(arenaid)
{
	new highscore = 0;
	new score = 0;
	new winnerid;

	for(new i = 0; i < PaintBallArena[arenaid][pbLimit]; i++) {
	   
	    foreach(new p: Player)
		{	
			if(!GetPVarType(p, "IsInArena")) continue;
			if(GetPVarInt(p, "IsInArena") == arenaid) {
				score = PlayerInfo[p][pKills];
				if(score > highscore) {
					highscore = score;
					winnerid = p;
				}
			}
		}	
	}
	return winnerid;
}

stock SendPaintballArenaTextMessage(arenaid, style, message[])
{
	foreach(new p: Player)
	{	
		if(!GetPVarType(p, "IsInArena")) continue;
		new carenaid = GetPVarInt(p, "IsInArena");
		if(arenaid == carenaid) {
			GameTextForPlayer(p, message, 5000, style);
		}
	}	
	return 1;
}

stock SendPaintballArenaMessage(arenaid, color, message[])
{
	foreach(new p: Player)
	{
		if(!GetPVarType(p, "IsInArena")) continue;
		new carenaid = GetPVarInt(p, "IsInArena");
		if(arenaid == carenaid) {
			SendClientMessageEx(p, color, message);
		}
	}	
	return 1;
}

/*
stock SendPaintballArenaSound(arenaid, soundid)
{
    foreach(new p: Player) {
   		new carenaid = GetPVarInt(p, "IsInArena");
   		if(arenaid == carenaid) {
	      	PlayerPlaySound(p, soundid, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

stock //SendPaintballArenaAudio(arenaid)
{
	foreach(new p: Player) {
	    new carenaid = GetPVarInt(p, "IsInArena");
	    if(arenaid == carenaid) {
	        //SendAudioToPlayer(p, soundid, volume);
	    }
	}
	return 1;
}

stock SendPaintballArenaAudioTeam(arenaid, team)
{
	foreach(new p: Player) {
	    new carenaid = GetPVarInt(p, "IsInArena");
	    if(arenaid == carenaid) {
	        if(PlayerInfo[p][pPaintTeam] == team) {
	            //SendAudioToPlayer(p, soundid, volume);
	        }
	    }
	}
}*/

stock ResetFlagPaintballArena(arenaid, flagid)
{
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 24, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 29, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = 0;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Do Flag ~w~Returned!");
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);


	        PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
	        PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
	        PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];
	    }
	    case 2: // Blue Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 24, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 11, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 0;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Xanh Flag ~w~Returned!");
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
	        PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
	        PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];
	    }
	}
}

stock ScoreFlagPaintballArena(playerid, arenaid, flagid)
{
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
	        {
	            SetHealth(playerid, PaintBallArena[arenaid][pbHealth]);
	            if(PaintBallArena[arenaid][pbArmor] > 0) {
	            	SetArmour(playerid, PaintBallArena[arenaid][pbArmor]);
	            }
	        }

	        PlayerInfo[playerid][pKills] += 5;

			////SendPaintballArenaAudio(arenaid, 25, 75);
         	//SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 15, 100);
	        RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	        SetPVarInt(playerid, "AOSlotPaintballFlag", -1);
	        PaintBallArena[arenaid][pbFlagRedActive] = 0;
	        PaintBallArena[arenaid][pbTeamBlueScores]++;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Do Team ~w~Scores!");
			format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da ghi diem cho doi XANH!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, szMiscArray);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
	        PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
	        PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];
	    }
	    case 2: // Blue Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
	        {
	            SetHealth(playerid, PaintBallArena[arenaid][pbHealth]);
	            if(PaintBallArena[arenaid][pbArmor] > 0) {
	            	SetArmour(playerid, PaintBallArena[arenaid][pbArmor]);
	            }
	        }

	        PlayerInfo[playerid][pKills] += 5;

			////SendPaintballArenaAudio(arenaid, 25, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 33, 100);
	        RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	        SetPVarInt(playerid, "AOSlotPaintballFlag", -1);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 0;
	        PaintBallArena[arenaid][pbTeamRedScores]++;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Xanh Team ~w~Scores!");
			format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da ghi diem cho doi DO.", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, szMiscArray);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
	        PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
	        PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];
	    }
	}
}

stock DropFlagPaintballArena(playerid, arenaid, flagid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	SetPVarInt(playerid, "AOSlotPaintballFlag", -1);

	switch(flagid)
	{
	    case 1: // Red Flag
	    {
  			////SendPaintballArenaAudio(arenaid, 28, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = 1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Red Flag ~w~Dropped!");
			format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s has dropped the Red Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, szMiscArray);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, X, Y, Z, 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
	        PaintBallArena[arenaid][pbFlagRedTextID] = Create3DTextLabel("Red Flag", COLOR_RED, X, Y, Z, 200.0, PaintBallArena[arenaid][pbVirtual], 0);
	        //PaintBallArena[arenaid][pbFlagRedTextID] = CreateDynamic3DTextLabel("Red Flag", COLOR_RED, X, Y, Z, 200.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
	        PaintBallArena[arenaid][pbFlagRedActiveTime] = 30;

	        PaintBallArena[arenaid][pbFlagRedPos][0] = X;
	        PaintBallArena[arenaid][pbFlagRedPos][1] = Y;
	        PaintBallArena[arenaid][pbFlagRedPos][2] = Z;
	    }
	    case 2: // Blue Flag
	    {
	        ////SendPaintballArenaAudio(arenaid, 10, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Blue Flag ~w~Dropped!");
			format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s has dropped the Blue Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, szMiscArray);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, X, Y, Z, 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
	        PaintBallArena[arenaid][pbFlagBlueTextID] = Create3DTextLabel("Blue Flag", COLOR_DBLUE, X, Y, Z, 200.0, PaintBallArena[arenaid][pbVirtual], 0);
	        //PaintBallArena[arenaid][pbFlagBlueTextID] = CreateDynamic3DTextLabel("Blue Flag", COLOR_DBLUE, X, Y, Z, 200.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
	        PaintBallArena[arenaid][pbFlagBlueActiveTime] = 30;

	        PaintBallArena[arenaid][pbFlagBluePos][0] = X;
	        PaintBallArena[arenaid][pbFlagBluePos][1] = Y;
	        PaintBallArena[arenaid][pbFlagBluePos][2] = Z;
	    }
	}
}

stock PickupFlagPaintballArena(playerid, arenaid, flagid)
{
	new index = -1;
    if(GetPlayerState(playerid) == PLAYER_STATE_WASTED) { return 1; }
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 23, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 30, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = -1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Red Flag ~w~Taken!");
			format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s has taken the Red Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, szMiscArray);
	        //SetTimerEx("//SendAudioToPlayer", 1500, false, "iii", playerid, 42, 100);
			index = FindFreeAttachedObjectSlot(playerid);
			if(index == -1) { RemovePlayerAttachedObject(playerid, 4), index = 4; }
	        SetPlayerAttachedObject(playerid,index,RED_FLAG_OBJ,5,0.0,0.0,0.0,30.0,0.0,0.0);
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
	    }
	    case 2: // Blug Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 23, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 12, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = -1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Blue Flag ~w~Taken!");
			format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s has taken the Blue Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, szMiscArray);
	        //SetTimerEx("//SendAudioToPlayer", 1500, false, "iii", playerid, 42, 100);
			index = FindFreeAttachedObjectSlot(playerid);
			if(index == -1) { RemovePlayerAttachedObject(playerid, 4), index = 4; }
	        SetPlayerAttachedObject(playerid,index,BLUE_FLAG_OBJ,5,0.0,0.0,0.0,30.0,0.0,0.0);
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	    }
	}
	SetPVarInt(playerid, "AOSlotPaintballFlag", index);
	return 1;
}

stock SpawnPaintballArena(playerid, arenaid)
{
	switch(PaintBallArena[arenaid][pbGameType])
	{
	    case 1,4: // Deathmatch, KOTH
	    {
			new rand = Random(1,5);
			switch (rand)
			{
	    		case 1:
	    		{
	        		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch1][0],PaintBallArena[arenaid][pbDeathmatch1][1],PaintBallArena[arenaid][pbDeathmatch1][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch1][3]);
	    		}
	    		case 2:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch2][0],PaintBallArena[arenaid][pbDeathmatch2][1],PaintBallArena[arenaid][pbDeathmatch2][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch2][3]);
				}
				case 3:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch3][0],PaintBallArena[arenaid][pbDeathmatch3][1],PaintBallArena[arenaid][pbDeathmatch3][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch3][3]);
				}
				case 4:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch4][0],PaintBallArena[arenaid][pbDeathmatch4][1],PaintBallArena[arenaid][pbDeathmatch4][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch4][3]);
				}
			}
		}
		case 2,3,5: // Team Deathmatch, Capture the Flag or Team KOTH
		{
		    if(PlayerInfo[playerid][pPaintTeam] == 1) // Red
		    {
		    	new rand = Random(1,4);
		    	switch (rand)
		    	{
		    	    case 1:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed1][0],PaintBallArena[arenaid][pbTeamRed1][1],PaintBallArena[arenaid][pbTeamRed1][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed1][3]);
		    	    }
		    	    case 2:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed2][0],PaintBallArena[arenaid][pbTeamRed2][1],PaintBallArena[arenaid][pbTeamRed2][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed2][3]);
		    	    }
		    	    case 3:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed3][0],PaintBallArena[arenaid][pbTeamRed3][1],PaintBallArena[arenaid][pbTeamRed3][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed3][3]);
		    	    }
		    	}
				SetPlayerColor(playerid, PAINTBALL_TEAM_RED);
			}
			if(PlayerInfo[playerid][pPaintTeam] == 2) // Blue
			{
			    new rand = Random(1,4);
			    switch (rand)
			    {
			        case 1:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue1][0],PaintBallArena[arenaid][pbTeamBlue1][1],PaintBallArena[arenaid][pbTeamBlue1][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue1][3]);
		    	    }
		    	    case 2:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue2][0],PaintBallArena[arenaid][pbTeamBlue2][1],PaintBallArena[arenaid][pbTeamBlue2][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue2][3]);
		    	    }
		    	    case 3:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue3][0],PaintBallArena[arenaid][pbTeamBlue3][1],PaintBallArena[arenaid][pbTeamBlue3][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue3][3]);
		    	    }
			    }
			    SetPlayerColor(playerid, PAINTBALL_TEAM_BLUE);
			}
		}
	}
	PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
	PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];


	pTazer{playerid} = 0; // Reset Tazer
	ResetPlayerWeapons(playerid);

 	SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
 	SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);
 	SetHealth(playerid, PaintBallArena[arenaid][pbHealth]);
 	if(PaintBallArena[arenaid][pbArmor] >= 0) {
 		SetArmour(playerid, PaintBallArena[arenaid][pbArmor]);
 	}
 	GivePlayerValidWeapon(playerid, PaintBallArena[arenaid][pbWeapons][0]);
 	GivePlayerValidWeapon(playerid, PaintBallArena[arenaid][pbWeapons][1]);
 	GivePlayerValidWeapon(playerid, PaintBallArena[arenaid][pbWeapons][2]);
}

stock JoinPaintballArena(playerid, arenaid, password[])
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));

	if(PaintBallArena[arenaid][pbPlayers] >= PaintBallArena[arenaid][pbLimit]) {
	   	return 0;
	}

	if(strcmp(PaintBallArena[arenaid][pbPassword], password, false)) {
	    return 0;
	}

	new team = GetPVarInt(playerid, "pbTeamChoice");
	new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldHealth, Float:oldArmor;
	GetPlayerPos(playerid, oldX, oldY, oldZ);

	SetPVarFloat(playerid, "pbOldX", oldX);
	SetPVarFloat(playerid, "pbOldY", oldY);
	SetPVarFloat(playerid, "pbOldZ", oldZ);

	GetHealth(playerid,oldHealth);
	GetArmour(playerid,oldArmor);
	SetPVarInt(playerid, "pbOldInt", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "pbOldVW", GetPlayerVirtualWorld(playerid));
	SetPVarFloat(playerid, "pbOldHealth", oldHealth);
	SetPVarFloat(playerid, "pbOldArmor", oldArmor);

	firstaidexpire(playerid);

 	PaintBallArena[arenaid][pbPlayers]++;

 	if(PaintBallArena[arenaid][pbGameType] == 3) {
		SetPVarInt(playerid, "TickCTFID", SetTimerEx("TickCTF", 1000, true, "d", playerid)); // Player's CTF Tick Function
	}

 	if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) {
 		SetPlayerCheckpoint(playerid, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], PaintBallArena[arenaid][pbHillRadius]);
   		SetPVarInt(playerid, "TickKOTHID", SetTimerEx("TickKOTH", 1000, true, "d", playerid)); // Player's KOTH Tick Function
	}

 	SetPVarInt(playerid, "IsInArena", arenaid);
	switch(team)
	{
	    case 0: // No Team
	    {
	        format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da tham gia vao tran dau!", name);
	        SendPaintballArenaMessage(arenaid,COLOR_WHITE,szMiscArray);
	        //SendAudioToPlayer(playerid, 27, 100);
	    }
	    case 1: // Red Team
		{
		    if(PaintBallArena[arenaid][pbTeamRed] >= teamlimit)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "Red team hien da day, hay chon Blue team.");
		        PlayerInfo[playerid][pPaintTeam] = 2;
		    	PaintBallArena[arenaid][pbTeamBlue]++;
		    	format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da tham gia Paintball va chon Blue Team!", name);
		       	SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,szMiscArray);
		       	//SendAudioToPlayer(playerid, 40, 100);
		    }
		    else
		    {
		        if(PaintBallArena[arenaid][pbTeamRed] > PaintBallArena[arenaid][pbTeamBlue])
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Cac doi hien tai khong dong dieu, ban se duoc vao Blue team.");
		        	PlayerInfo[playerid][pPaintTeam] = 2;
		    		PaintBallArena[arenaid][pbTeamBlue]++;
		    		format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da tham gia Paintball va chon Blue Team!", name);
		       		SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,szMiscArray);
		       		//SendAudioToPlayer(playerid, 40, 100);
		        }
		        else
		        {
		        	PlayerInfo[playerid][pPaintTeam] = 1;
		    		PaintBallArena[arenaid][pbTeamRed]++;
		    		format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da tham gia Paintball va chon Red Team!", name);
		       		SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,szMiscArray);
		       		//SendAudioToPlayer(playerid, 41, 100);
				}
		    }
		}
  		case 2: // Blue Team
	   	{
     		if(PaintBallArena[arenaid][pbTeamBlue] >= teamlimit)
   			{
      			SendClientMessageEx(playerid, COLOR_WHITE, "Blue team hien da day, hay chon Red team.");
	        	PlayerInfo[playerid][pPaintTeam] = 1;
	    		PaintBallArena[arenaid][pbTeamRed]++;
	    		format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da tham gia Paintball va chon Red Team!", name);
      			SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,szMiscArray);
      			//SendAudioToPlayer(playerid, 41, 100);
		    }
	    	else
		    {
		        if(PaintBallArena[arenaid][pbTeamBlue] > PaintBallArena[arenaid][pbTeamRed])
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Cac doi hien tai khong dong dieu, ban se duoc vao Red team.");
	        		PlayerInfo[playerid][pPaintTeam] = 1;
	    			PaintBallArena[arenaid][pbTeamRed]++;
	    			format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da tham gia Paintball va chon Red Team!", name);
      				SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,szMiscArray);
      				//SendAudioToPlayer(playerid, 41, 100);
		        }
		        else
		        {
      				PlayerInfo[playerid][pPaintTeam] = 2;
	    			PaintBallArena[arenaid][pbTeamBlue]++;
		    		format(szMiscArray,sizeof(szMiscArray),"[Paintball Arena] %s da tham gia Paintball va chon Blue Team!", name);
      				SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,szMiscArray);
      				//SendAudioToPlayer(playerid, 40, 100);
				}
		    }
	    }
	}
 	SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");

	if(PaintBallArena[arenaid][pbExploitPerm] == 0)
 	{
 	    SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: This room does not allow any QS/CS, any attempt will be punishable.");
 	}
 	else
 	{
 	    SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: This room allows QS/CS, if you do not like it, leave the arena now.");
 	}

 	PlayerInfo[playerid][pKills] = 0;
  	PlayerInfo[playerid][pDeaths] = 0;

  	GivePlayerCash(playerid,-PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbBidMoney]);
    PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbMoneyPool] += PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbBidMoney];

 	SpawnPaintballArena(playerid,GetPVarInt(playerid, "IsInArena"));
 	return 1;
}

stock LeavePaintballArena(playerid, arenaid, disconnect = 0)
{
	if(!GetPVarType(playerid, "IsInArena")) return 1;
	if(arenaid == GetPVarInt(playerid, "IsInArena"))
	{
	    new name[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, name, sizeof(name));

		if(arenaid == GetPVarInt(playerid, "ArenaNumber"))
		{
		    DeletePVar(playerid, "ArenaNumber");
		}
		// We must not remove the var OnPlayerDisconenct or else we can't place them outside of the arena!
		if(!disconnect) DeletePVar(playerid, "IsInArena");

		PlayerInfo[playerid][pKills] = 0;
	    PlayerInfo[playerid][pDeaths] = 0;

		if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5)
		{
		    KillTimer(GetPVarInt(playerid, "TickKOTHID"));
		    DisablePlayerCheckpoint(playerid);
		}
		if(PlayerInfo[playerid][pPaintTeam] == 1)
		{
		    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
		    {
				DropFlagPaintballArena(playerid, arenaid, 2);
		    }
		    KillTimer(GetPVarInt(playerid, "TickCTFID"));
		    PaintBallArena[arenaid][pbTeamRed]--;
		    PlayerInfo[playerid][pPaintTeam] = 0;
		}
		if(PlayerInfo[playerid][pPaintTeam] == 2)
		{
		    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
		    {
				DropFlagPaintballArena(playerid, arenaid, 1);
		    }
		    KillTimer(GetPVarInt(playerid, "TickCTFID"));
		    PaintBallArena[arenaid][pbTeamBlue]--;
		    PlayerInfo[playerid][pPaintTeam] = 0;
		}
		PaintBallArena[arenaid][pbPlayers]--;
		if(PaintBallArena[arenaid][pbTimeLeft] > 30)
		{
			format(szMiscArray, sizeof(szMiscArray),"[Paintball Arena] %s da thoat khoi tran dau!", name);
			SendPaintballArenaMessage(arenaid, COLOR_WHITE, szMiscArray);
		}
		if(PaintBallArena[arenaid][pbPlayers] == 0)
		{
		    ResetPaintballArena(arenaid);
		}

		SetPlayerWeapons(playerid);
  		// SetPlayerToTeamColor(playerid);
  		SetPlayerColor(playerid,TEAM_HIT_COLOR);
  		SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		SetPlayerPos(playerid, GetPVarFloat(playerid, "pbOldX"), GetPVarFloat(playerid, "pbOldY"), GetPVarFloat(playerid, "pbOldZ"));
		SetHealth(playerid, GetPVarFloat(playerid, "pbOldHealth"));
		SetArmour(playerid, GetPVarFloat(playerid, "pbOldArmor"));
		SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pbOldVW"));
		SetPlayerInterior(playerid, GetPVarInt(playerid, "pbOldInt"));
		PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "pbOldVW");
		PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "pbOldInt");
        PlayerInfo[playerid][pPaintTeam] = 0;
        DeletePVar(playerid, "pbTeamChoice");
		Player_StreamPrep(playerid, GetPVarFloat(playerid, "pbOldX"), GetPVarFloat(playerid, "pbOldY"), GetPVarFloat(playerid, "pbOldZ"), FREEZE_TIME);
	}
	return 1;
}

forward TickCTF(playerid);
public TickCTF(playerid)
{
	if(GetPVarType(playerid, "IsInArena"))
	{
	    new arenaid = GetPVarInt(playerid, "IsInArena");
	    if(PaintBallArena[arenaid][pbGameType] == 3)
	    {
	        // Flag Active Codes
			//
			// Active -1 = Flag is being carried by someone, not pickupable by anyone intill dropping.
			// Active 0 = Flag is on the stand, pickupable by only the opp team.
			// Active 1 = Flag is lying on the ground somewhere, pickupable by both teams, same team resets the flag.

			// Inactive Teams Check
			if(PaintBallArena[arenaid][pbTeamRed] == 0)
			{
			    return 1;
			}
			if(PaintBallArena[arenaid][pbTeamBlue] == 0)
			{
			    return 1;
			}

	        new teamid = PlayerInfo[playerid][pPaintTeam];
	        switch(teamid)
	        {
	            case 1: // Red Team's Tick
	            {
	                // Red Flag Checks
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 0)
					{
					    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
					    {
					    	if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
	                		{
	                		    ScoreFlagPaintballArena(playerid, arenaid, 2);
	                		}
						}
					}
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	                {
	                	if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
	                	{
	                	    ResetFlagPaintballArena(arenaid, 1);
	                	}
					}

					// Blue Flag Checks
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 0)
					{
					    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetHealth(playerid, 1);
					            RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 2);
					    }
					}
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetHealth(playerid, 1);
					            RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 2);
					    }
					}
	            }
	            case 2: // Blue Team's Tick
	            {
	                // Blue Flag Checks
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 0)
	                {
	                    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
	                    {
	                        if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
	                		{
	                		    ScoreFlagPaintballArena(playerid, arenaid, 1);
	                		}
	                    }
	                }
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
	                	{
	                	    ResetFlagPaintballArena(arenaid, 2);
	                	}
	                }

	                // Red Flag Checks
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 0)
	                {
                        if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetHealth(playerid, 1);
                                RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 1);
					    }
	                }
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetHealth(playerid, 1);
					            RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 1);
					    }
					}
	            }
	        }
	    }
	}
	return 1;
}

forward TickKOTH(playerid);
public TickKOTH(playerid)
{
	if(GetPVarType(playerid, "IsInArena"))
	{
	    new arenaid = GetPVarInt(playerid, "IsInArena");

   		// Inactive Players Check
       	if(PaintBallArena[arenaid][pbPlayers] < 2)
       	{
			return 1;
		}

	    if(PaintBallArena[arenaid][pbGameType] == 4) // King of the Hill
		{
		    if(IsPlayerInCheckpoint(playerid))
			{
			    new Float:health;
			    GetHealth(playerid, health);
			    SetHealth(playerid, health+1);

			    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			    PlayerInfo[playerid][pKills] += 1;
			}
		}
		if(PaintBallArena[arenaid][pbGameType] == 5) // Team King of the Hill
		{
		    if(IsPlayerInCheckpoint(playerid))
			{
			    new Float:health;
			    GetHealth(playerid, health);
			    SetHealth(playerid, health+1);

			    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);


			    switch(PlayerInfo[playerid][pPaintTeam])
			    {
			        case 1:
			        {
						PaintBallArena[arenaid][pbTeamRedScores] += 1;
			        }
			        case 2:
			        {
			            PaintBallArena[arenaid][pbTeamBlueScores] += 1;
					}
			    }
			}
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case PBMAINMENU: // Paintball Arena System
		{
			if(response == 1)
			{
				switch(listitem)
				{
					case 0: // Choose a Arena
					{
						PaintballArenaSelection(playerid);
					}
					case 1: // Buy Paintball Tokens
					{
						PaintballTokenBuyMenu(playerid);
					}
					case 2:
					{
						if(PlayerInfo[playerid][pAdmin] >= 1337)
						{
							ShowPlayerDialogEx(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Chinh sua arena...\nKhoa Arena\nMo khoa Arena\nSave Changes to All Arenas","Chon","Tro ve");
						}
						else
						{
							ShowPlayerDialogEx(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Chon phong\nMua Token Paintball\nAdmin Menu","Chon","Thoat");
							SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co quyen truy cap Admin Menu.");
							return 1;
						}
					}
				}
			}
		}
		case PBADMINMENU:
		{
			if(response == 1)
			{
				switch(listitem)
				{
					case 0: // Edit Arena
					{
						PaintballEditMenu(playerid);
					}
					case 1: // Lock all Arenas
					{
						for(new i = 0; i < MAX_ARENAS; i++)
						{
							foreach(new p: Player)
							{
								if(!GetPVarType(p, "IsInArena")) continue;
								new arenaid = GetPVarInt(p, "IsInArena");
								if(arenaid == i)
								{
									if(PaintBallArena[arenaid][pbBidMoney] > 0)
									{
										GivePlayerCash(p,PaintBallArena[arenaid][pbBidMoney]);
										format(szMiscArray,sizeof(szMiscArray),"Ban da duoc hoan lai so tien ($%d) vi PB da dong cua som.",PaintBallArena[arenaid][pbBidMoney]);
										SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
									}
									if(arenaid == GetPVarInt(p, "ArenaNumber"))
									{
										switch(PaintBallArena[arenaid][pbGameType])
										{
											case 1:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 3;
													format(szMiscArray,sizeof(szMiscArray),"Ban da duoc hoan lai PB Token (%d) vi PB da dong cua som.",3);
													SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
												}
											}
											case 2:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 4;
													format(szMiscArray,sizeof(szMiscArray),"Ban da duoc hoan lai PB Token (%d) vi PB da dong cua som.",4);
													SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
												}
											}
											case 3:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 5;
													format(szMiscArray,sizeof(szMiscArray),"Ban da duoc hoan lai PB Token (%d) vi PB da dong cua som.",5);
													SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
												}
											}
											case 4:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 5;
													format(szMiscArray,sizeof(szMiscArray),"Ban da duoc hoan lai PB Token (%d) vi PB da dong cua som.",5);
													SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
												}
											}
											case 5:
											{
												if(PlayerInfo[p][pDonateRank] < 3)
												{
													PlayerInfo[p][pPaintTokens] += 6;
													format(szMiscArray,sizeof(szMiscArray),"Ban da duoc hoan lai PB Token (%d) vi PB da dong cua som.",6);
													SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
												}
											}
										}
									}
									LeavePaintballArena(p, arenaid);
								}
							}	
							ResetPaintballArena(i);
							PaintBallArena[i][pbLocked] = 2;
						}
						format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s da khoa tat ca phong Paintball.", GetPlayerNameEx(playerid));
						ABroadCast(COLOR_YELLOW, szMiscArray, 2);
						format(szMiscArray, sizeof(szMiscArray), "* Admin %s da khoa tat ca cac phong trong dau truong de bao tri.", GetPlayerNameEx(playerid));
						SendClientMessageToAllEx(COLOR_LIGHTBLUE, szMiscArray);
						ShowPlayerDialogEx(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Chinh sua arena...\nKhoa Arena\nMo khoa Arena\nSave Changes to All Arenas","Chon","Tro ve");
					}
					case 2: // Unlock all Arenas
					{
						for(new i = 0; i < MAX_ARENAS; i++)
						{
							if(PaintBallArena[i][pbLocked] == 2)
							{
								ResetPaintballArena(i);
							}
						}
						format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s da mo khoa tat ca phong Paintball.", GetPlayerNameEx(playerid));
						ABroadCast(COLOR_YELLOW, szMiscArray, 2);
						format(szMiscArray, sizeof(szMiscArray), "* Admin %s da mo khoa tat ca phong trong dau truong, cac ban co the tham gia.", GetPlayerNameEx(playerid));
						SendClientMessageToAllEx(COLOR_LIGHTBLUE, szMiscArray);
						ShowPlayerDialogEx(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Chinh sua arena...\nKhoa Arena\nMo khoa Arena\nSave Changes to All Arenas","Chon","Tro ve");
					}
					case 3: // Force Save Arenas
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "You have forced saved all changes to the Painball Arenas.");
						SavePaintballArenas();
						ShowPlayerDialogEx(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Chinh sua arena...\nKhoa Arena\nMo khoa Arena\nSave Changes to All Arenas","Chon","Tro ve");
					}
				}
			}
			else
			{
				ShowPlayerDialogEx(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Chon phong\nMua Token Paintball\nAdmin Menu","Chon","Thoat");
			}
		}
		case PBARENASCORES:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "IsInArena");
				PaintballScoreboard(playerid,arenaid);
			}
		}
		case PBEDITMENU:
		{
			if(response == 1)
			{
				for(new i = 0; i < MAX_ARENAS; i++)
				{
					if(listitem == i)
					{
						if(PaintBallArena[i][pbLocked] != 2)
						{
							PaintballEditMenu(playerid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You cannot edit a arena that is not closed.");
							return 1;
						}
						ResetPaintballArena(i);
						PaintBallArena[i][pbLocked] = 2;

						new Float:oldX, Float:oldY, Float:oldZ;
						GetPlayerPos(playerid, oldX, oldY, oldZ);

						SetPVarFloat(playerid, "pbOldX", oldX);
						SetPVarFloat(playerid, "pbOldY", oldY);
						SetPVarFloat(playerid, "pbOldZ", oldZ);

						SetPVarInt(playerid, "pbOldInt", GetPlayerInterior(playerid));
						SetPVarInt(playerid, "pbOldVW", GetPlayerVirtualWorld(playerid));

						SetPlayerPos(playerid, PaintBallArena[i][pbDeathmatch1][0],PaintBallArena[i][pbDeathmatch1][1],PaintBallArena[i][pbDeathmatch1][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[i][pbDeathmatch1][3]);
						SetPlayerInterior(playerid, PaintBallArena[i][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[i][pbVirtual]);
						SetPVarInt(playerid, "ArenaNumber", i);

						PaintballEditArenaMenu(playerid);
					}
				}
			}
			else
			{
				ShowPlayerDialogEx(playerid,PBADMINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Admin Menu:","Chinh sua arena...\nKhoa Arena\nMo khoa Arena\nSave Changes to All Arenas","Chon","Tro ve");
			}
		}
		case PBEDITARENAMENU:
		{
			if(response == 1)
			{
				switch(listitem)
				{
					case 0: // Name
					{
						PaintballEditArenaName(playerid);
					}
					case 1: // Deathmatch Spawn Points
					{
						PaintballEditArenaDMSpawns(playerid);
					}
					case 2: // Team/CTF Spawn Points
					{
						PaintballEditArenaTeamSpawns(playerid);
					}
					case 3: // CTF Flag Spawn Points
					{
						PaintballEditArenaFlagSpawns(playerid);
					}
					case 4: // Hill Position
					{
						SetPVarInt(playerid, "EditingHillStage", 1);
						SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savehillpos) to edit the Hill Position.");
					}
					case 5: // Hill Radius
					{
						PaintballEditArenaHillRadius(playerid);
					}
					case 6: // Interior
					{
						PaintballEditArenaInt(playerid);
					}
					case 7: // Virtual World
					{
						PaintballEditArenaVW(playerid);
					}
					case 8: // War Vehicle 1
					{
						SetPVarInt(playerid, "PBVeh", 1);
						SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
					}
					case 9: // War Vehicle 2
					{
						SetPVarInt(playerid, "PBVeh", 2);
						SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
					}
					case 10: // War Vehicle 3
					{
						SetPVarInt(playerid, "PBVeh", 3);
						SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
					}
					case 11: // War Vehicle 4
					{
						SetPVarInt(playerid, "PBVeh", 4);
						SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
					}
					case 12: // War Vehicle 5
					{
						SetPVarInt(playerid, "PBVeh", 5);
						SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
					}
					case 13: // War Vehicle 6
					{
						SetPVarInt(playerid, "PBVeh", 6);
						SendClientMessageEx(playerid, COLOR_WHITE, "Type /savepbvehicle inside the selected vehicle (or outside if you want to delete it).");
					}				
				}
			}
			else
			{
				if(GetPVarType(playerid, "ArenaNumber"))
				{
					SetPlayerPos(playerid, GetPVarFloat(playerid, "pbOldX"),GetPVarFloat(playerid, "pbOldY"),GetPVarFloat(playerid, "pbOldZ"));
					SetPlayerInterior(playerid, GetPVarInt(playerid, "pbOldInt"));
					SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pbOldVW"));
					DeletePVar(playerid, "ArenaNumber");
					Player_StreamPrep(playerid, GetPVarFloat(playerid, "pbOldX"),GetPVarFloat(playerid, "pbOldY"),GetPVarFloat(playerid, "pbOldZ"), FREEZE_TIME);
				}
				PaintballEditMenu(playerid);
			}
		}
		case PBEDITARENANAME:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					PaintballEditArenaName(playerid);
					return 1;
				}
				if(strlen(inputtext) > 11)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "Arena names cannot be bigger than 11 characters.");
					PaintballEditArenaName(playerid);
					return 1;
				}
				format(szMiscArray, sizeof(szMiscArray), inputtext);
				strmid(PaintBallArena[arenaid][pbArenaName], szMiscArray, 0, strlen(szMiscArray), 64);
				PaintballEditArenaMenu(playerid);
			}
			else
			{
				PaintballEditArenaMenu(playerid);
			}
		}
		case PBEDITARENADMSPAWNS:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				switch(listitem)
				{
					case 0: // Spawn Positions 1
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 1: Move in a position and type (/savedmpos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingDMPos", 1);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch1][0],PaintBallArena[arenaid][pbDeathmatch1][1],PaintBallArena[arenaid][pbDeathmatch1][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch1][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 1: // Spawn Positions 2
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 2: Move in a position and type (/savedmpos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingDMPos", 2);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch2][0],PaintBallArena[arenaid][pbDeathmatch2][1],PaintBallArena[arenaid][pbDeathmatch2][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch2][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 2: // Spawn Positions 3
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 3: Move in a position and type (/savedmpos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingDMPos", 3);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch3][0],PaintBallArena[arenaid][pbDeathmatch3][1],PaintBallArena[arenaid][pbDeathmatch3][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch3][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 3: // Spawn Positions 4
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "DM Position 4: Move in a position and type (/savedmpos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingDMPos", 4);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch4][0],PaintBallArena[arenaid][pbDeathmatch4][1],PaintBallArena[arenaid][pbDeathmatch4][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch4][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
				}
			}
			else
			{
				PaintballEditArenaMenu(playerid);
			}
		}
		case PBEDITARENATEAMSPAWNS:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				switch(listitem)
				{
					case 0: // Red Spawn Positions 1
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Position 1: Move in a position and type (/saveteampos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingTeamPos", 1);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed1][0],PaintBallArena[arenaid][pbTeamRed1][1],PaintBallArena[arenaid][pbTeamRed1][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed1][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 1: // Red Spawn Positions 2
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Position 2: Move in a position and type (/saveteampos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingTeamPos", 2);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed2][0],PaintBallArena[arenaid][pbTeamRed2][1],PaintBallArena[arenaid][pbTeamRed2][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed2][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 2: // Red Spawn Positions 3
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Position 3: Move in a position and type (/saveteampos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingTeamPos", 3);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed3][0],PaintBallArena[arenaid][pbTeamRed3][1],PaintBallArena[arenaid][pbTeamRed3][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed3][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 3: // Blue Spawn Positions 1
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Position 1: Move in a position and type (/saveteampos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingTeamPos", 4);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue1][0],PaintBallArena[arenaid][pbTeamBlue1][1],PaintBallArena[arenaid][pbTeamBlue1][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue1][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 4: // Blue Spawn Positions 2
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Position 2: Move in a position and type (/saveteampos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingTeamPos", 5);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue2][0],PaintBallArena[arenaid][pbTeamBlue2][1],PaintBallArena[arenaid][pbTeamBlue2][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue2][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
					case 5: // Blue Spawn Positions 3
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Position 3: Move in a position and type (/saveteampos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingTeamPos", 6);

						SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue3][0],PaintBallArena[arenaid][pbTeamBlue3][1],PaintBallArena[arenaid][pbTeamBlue3][2]);
						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue3][3]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);

						PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
						PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];
					}
				}
			}
			else
			{
				PaintballEditArenaMenu(playerid);
			}
		}
		case PBEDITARENAFLAGSPAWNS:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				switch(listitem)
				{
					case 0: // Red Flag
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Red Team Flag Position: Move in a position and type (/saveflagpos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingFlagPos", 1);

						SetPlayerPos(playerid,PaintBallArena[arenaid][pbFlagRedSpawn][0],PaintBallArena[arenaid][pbFlagRedSpawn][1],PaintBallArena[arenaid][pbFlagRedSpawn][2]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);
					}
					case 1: // Blue Flag
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Blue Team Flag Position: Move in a position and type (/saveflagpos).");
						SendClientMessageEx(playerid, COLOR_WHITE, "Be sure that you are in the correct position before saving.");
						SetPVarInt(playerid, "EditingFlagPos", 2);

						SetPlayerPos(playerid,PaintBallArena[arenaid][pbFlagBlueSpawn][0],PaintBallArena[arenaid][pbFlagBlueSpawn][1],PaintBallArena[arenaid][pbFlagBlueSpawn][2]);
						SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
						SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);
					}
				}
			}
			else
			{
				PaintballEditArenaMenu(playerid);
			}
		}
		case PBEDITARENAINT:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					PaintballEditArenaInt(playerid);
					return 1;
				}
				PaintBallArena[arenaid][pbInterior] = strval(inputtext);
				PaintballEditArenaMenu(playerid);
			}
			else
			{
				PaintballEditArenaMenu(playerid);
			}
		}
		case PBEDITARENAVW:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					PaintballEditArenaVW(playerid);
					return 1;
				}
				PaintBallArena[arenaid][pbVirtual] = strval(inputtext);
				PaintballEditArenaMenu(playerid);
			}
			else
			{
				PaintballEditArenaMenu(playerid);
			}
		}
		case PBEDITARENAHILLRADIUS:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					PaintballEditArenaHillRadius(playerid);
					return 1;
				}
				if(floatstr(inputtext) < 0.0 || floatstr(inputtext) > 100.0)
				{
					PaintballEditArenaHillRadius(playerid);
					return 1;
				}
				PaintBallArena[arenaid][pbHillRadius] = floatstr(inputtext);
				PaintballEditArenaMenu(playerid);
			}
			else
			{
				PaintballEditArenaMenu(playerid);
			}
		}
		case PBARENASELECTION: // Paintball Arena System
		{
			if(response == 1)
			{
				for(new i = 0; i < MAX_ARENAS; i++)
				{
					if(listitem == i)
					{
						//format(szMiscArray, sizeof(szMiscArray), "Debug: You have entered Arena %d.", i+1);
						//SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

						if(PaintBallArena[i][pbLocked] == 0) // Open
						{
							if(PlayerInfo[playerid][pPaintTokens] < 3)
							{
								if(PlayerInfo[playerid][pDonateRank] <= 2)
								{
									SendClientMessageEx(playerid, COLOR_WHITE, "You need at least 3 tokens to rent a room.");
									PaintballArenaSelection(playerid);
									return 1;
								}
							}
							ResetPaintballArena(i);
							PaintBallArena[i][pbPlayers] = 1;
							PaintBallArena[i][pbLocked] = 3;

							new Float:oldX, Float:oldY, Float:oldZ, Float:oldHealth, Float:oldArmor;
							GetPlayerPos(playerid, oldX, oldY, oldZ);

							SetPVarFloat(playerid, "pbOldX", oldX);
							SetPVarFloat(playerid, "pbOldY", oldY);
							SetPVarFloat(playerid, "pbOldZ", oldZ);

							GetHealth(playerid,oldHealth);
							GetArmour(playerid,oldArmor);
							SetPVarInt(playerid, "pbOldInt", GetPlayerInterior(playerid));
							SetPVarInt(playerid, "pbOldVW", GetPlayerVirtualWorld(playerid));
							SetPVarFloat(playerid, "pbOldHealth", oldHealth);
							SetPVarFloat(playerid, "pbOldArmor", oldArmor);

							SetPlayerPos(playerid, PaintBallArena[i][pbDeathmatch1][0],PaintBallArena[i][pbDeathmatch1][1],PaintBallArena[i][pbDeathmatch1][2]);
							SetPlayerFacingAngle(playerid, PaintBallArena[i][pbDeathmatch1][3]);
							SetPlayerInterior(playerid, PaintBallArena[i][pbInterior]);
							SetPlayerVirtualWorld(playerid, PaintBallArena[i][pbVirtual]);

							PlayerInfo[playerid][pVW] = PaintBallArena[i][pbVirtual];
							PlayerInfo[playerid][pInt] = PaintBallArena[i][pbInterior];

							format(szMiscArray, sizeof(szMiscArray), "%s",GetPlayerNameEx(playerid));
							strmid(PaintBallArena[i][pbOwner], szMiscArray, 0, strlen(szMiscArray), 64);
							SetPVarInt(playerid, "ArenaNumber", i);
							SetPVarInt(playerid, "IsInArena", i);
							PaintballSetupArena(playerid);
							return 1;
						}
						if(PaintBallArena[i][pbLocked] == 1) // Active
						{
							if(PaintBallArena[i][pbPlayers] >= PaintBallArena[i][pbLimit])
							{
								//format(szMiscArray, sizeof(szMiscArray), "Debug: Arena %d is currently full, Ban khong the vao it.", i+1);
								//SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
								PaintballArenaSelection(playerid);
								return 1;
							}
							if(PaintBallArena[i][pbBidMoney] > GetPlayerCash(playerid))
							{
								SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du tien de tham gia tran dau nay.");
								PaintballArenaSelection(playerid);
								return 1;
							}
							if(PaintBallArena[i][pbTimeLeft] < 180)
							{
								SendClientMessageEx(playerid, COLOR_WHITE, "Phong nay sap ket thuc, ban khong the tham gia.");
								PaintballArenaSelection(playerid);
								return 1;
							}
							if(PaintBallArena[i][pbWar] == 1 && PlayerInfo[playerid][pDonateRank] < 3)
							{
								SendClientMessageEx(playerid, COLOR_WHITE, "Chi co VIP Gold+ moi co the tham gia PB.");
								PaintballArenaSelection(playerid);
								return 1;
							}
							if(PaintBallArena[i][pbGameType] == 2 || PaintBallArena[i][pbGameType] == 3 || PaintBallArena[i][pbGameType] == 5)
							{
								SetPVarInt(playerid, "ArenaEnterTeam", i);
								ShowPlayerDialogEx(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Chon team:","{FF0000}Red Team\n{0000FF}Blue Team","Xac nhan","Thoat");
								return 1;
							}
							if(strcmp(PaintBallArena[i][pbPassword], "None", false))
							{
								SetPVarInt(playerid, "ArenaEnterPass", i);
								ShowPlayerDialogEx(playerid,PBJOINPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Mat khau:","Phong nay duoc thiet lap mat khau, hay dien mat khau vao:","Xac nhan","Thoat");
								return 1;
							}
							JoinPaintballArena(playerid, i, "None");
						}
						if(PaintBallArena[i][pbLocked] == 2) // Closed
						{
							PaintballArenaSelection(playerid);
							return 1;
						}
						if(PaintBallArena[i][pbLocked] == 3) // Setup
						{
							PaintballArenaSelection(playerid);
							return 1;
						}
					}
				}
			}
			else
			{
				ShowPlayerDialogEx(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Chon phong\nMua Token Paintball\nAdmin Menu","Chon","Thoat");
			}
		}
		case PBTOKENBUYMENU:
		{
			if(response == 1)
			{
				if(isnull(inputtext))
				{
					PaintballTokenBuyMenu(playerid);
					return 1;
				}
				if(strval(inputtext) <= 0)
				{
					PaintballTokenBuyMenu(playerid);
					return 1;
				}
				if(strval(inputtext) > 1000)
				{
					PaintballTokenBuyMenu(playerid);
					SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the mua hon 1000 PB Token cung mot luc.");
					return 1;
				}
				if(GetPlayerCash(playerid) < 5000*strval(inputtext))
				{
					PaintballTokenBuyMenu(playerid);
					format(szMiscArray,sizeof(szMiscArray), "Ban khong co du tien de mua %d PB Token voi gia $%d.",strval(inputtext),strval(inputtext)*5000);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					return 1;
				}
				GivePlayerCash(playerid, -5000*strval(inputtext));
				PlayerInfo[playerid][pPaintTokens] += strval(inputtext);
				format(szMiscArray,sizeof(szMiscArray), "Ban da mua %d PB Token voi gia $%d.",strval(inputtext),strval(inputtext)*5000);
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			}
			else
			{
				ShowPlayerDialogEx(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Chon phong\nMua Token Paintball\nAdmin Menu","Chon","Thoat");
			}
		}
		case PBSETUPARENA:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(PaintBallArena[arenaid][pbGameType] == 1 || PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) // Deathmatch, Team Deathmatch, Single and Team King of the Hill.
				{
					switch(listitem)
					{
						case 0: // Password
						{
							ShowPlayerDialogEx(playerid,PBCHANGEPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap mat khau:","Ban hay nhap mat khau cho phong nay:","Xac nhan","Tro ve");
							return 1;
						}
						case 1: // GameType
						{
							ShowPlayerDialogEx(playerid,PBCHANGEGAMEMODE,DIALOG_STYLE_LIST,"Paintball Arena - Chon the loai:","Deathmatch\nTeam Deathmatch\nCapture the Flag\nKing of the Hill\nTeam King of the Hill","Xac nhan","Tro ve");
							return 1;
						}
						case 2: // Limit
						{
							ShowPlayerDialogEx(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Gioi han nguoi tham gia:","Ban hay nhap gioi han nguoi tham gia (2 > 16):","Xac nhan","Tro ve");
							return 1;
						}
						case 3: // Time Limit
						{
							ShowPlayerDialogEx(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Thoi gian tran dau:","Ban hay nhap thoi gian cho tran dau nay (5 > 15 phut):","Xac nhan","Tro ve");
							return 1;
						}
						case 4: // Bid Money
						{
							ShowPlayerDialogEx(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Gia tien tham gia:","Ban hay nhap gia tien de tham gia phong nay ($0 > $10000):","Xac nhan","Tro ve");
							return 1;
						}
						case 5: // Health
						{
							ShowPlayerDialogEx(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap HP:","Ban hay thiet lap HP cho phong nay (1 > 100):","Xac nhan","Tro ve");
							return 1;
						}
						case 6: // Armor
						{
							ShowPlayerDialogEx(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap Giap:","Ban hay thiet lap GIAP cho phong nay (0-100):","Xac nhan","Tro ve");
							return 1;
						}
						case 7: // Weapons 1
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 1):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
							return 1;
						}
						case 8: // Weapons 2
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 2):","Ban hay thiet lap ID vu khi 2 cho phong nay (0 > 34):","Xac nhan","Tro ve");
							return 1;
						}
						case 9: // Weapons 3
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 3):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
							return 1;
						}
						case 10: // Exploit Perm
						{
							ShowPlayerDialogEx(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Ban co muon cho phep QS/CS trong phong khong? (1 = Co / 0 = Khong):","Xac nhan","Tro ve");
							return 1;
						}
						case 11: // War
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWAR,DIALOG_STYLE_MSGBOX,"Paintball Arena - Change War:", "Ban co muon cho phep WAR trong phong khong?", "Co", "Khong");
							return 1;
						}
						case 12: // Begin Arena
						{
							if(PaintBallArena[arenaid][pbGameType] == 1)
							{
								if(PlayerInfo[playerid][pDonateRank] <= 2)
								{
									PlayerInfo[playerid][pPaintTokens] -= 3;
									format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,3);
									SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
									SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
									PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
									//SendAudioToPlayer(playerid, 27, 100);
								}
								else
								{
									format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
									SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
									SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
									PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
									//SendAudioToPlayer(playerid, 27, 100);
								}
							}
							if(PaintBallArena[arenaid][pbGameType] == 2)
							{
								if(PlayerInfo[playerid][pDonateRank] <= 2)
								{
									if(PlayerInfo[playerid][pPaintTokens] >= 4)
									{
										PlayerInfo[playerid][pPaintTokens] -= 4;
										format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,4);
										SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
										SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
										PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
										//SendAudioToPlayer(playerid, 27, 100);
									}
									else
									{
										PaintballSetupArena(playerid);
										SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du PB Token de tao phong nay.");
										return 1;
									}
								}
								else
								{
									format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
									SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
									SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
									PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
									//SendAudioToPlayer(playerid, 41, 100);
								}
								PlayerInfo[playerid][pPaintTeam] = 1;
								PaintBallArena[arenaid][pbTeamRed] = 1;
							}
							if(PaintBallArena[arenaid][pbGameType] == 4)
							{
								if(PlayerInfo[playerid][pDonateRank] <= 2)
								{
									PlayerInfo[playerid][pPaintTokens] -= 5;
									format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,5);
									SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
									SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
									PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
									//SendAudioToPlayer(playerid, 27, 100);
								}
								else
								{
									format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
									SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
									SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
									PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
									//SendAudioToPlayer(playerid, 27, 100);
								}

								CreatePaintballArenaHill(arenaid);
								SetPVarInt(playerid, "TickKOTHID", SetTimerEx("TickKOTH", 1000, true, "d", playerid)); // Room Owner's KOTH Tick Function
								SetPlayerCheckpoint(playerid, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], PaintBallArena[arenaid][pbHillRadius]);
							}
							if(PaintBallArena[arenaid][pbGameType] == 5)
							{
								if(PlayerInfo[playerid][pDonateRank] <= 2)
								{
									if(PlayerInfo[playerid][pPaintTokens] >= 6)
									{
										PlayerInfo[playerid][pPaintTokens] -= 6;
										format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,6);
										SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
										SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
										PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
										//SendAudioToPlayer(playerid, 41, 100);
									}
									else
									{
										PaintballSetupArena(playerid);
										SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co du PB Token de tao phong nay.");
										return 1;
									}
								}
								else
								{
									format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
									SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
									SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
									PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
									//SendAudioToPlayer(playerid, 41, 100);
								}

								CreatePaintballArenaHill(arenaid);
								SetPVarInt(playerid, "TickKOTHID", SetTimerEx("TickKOTH", 1000, true, "d", playerid)); // Room Owner's KOTH Tick Function
								SetPlayerCheckpoint(playerid, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], PaintBallArena[arenaid][pbHillRadius]);
								PlayerInfo[playerid][pPaintTeam] = 1;
								PaintBallArena[arenaid][pbTeamRed] = 1;
							}
							if(PaintBallArena[arenaid][pbWar] == 1)
							{
								if(PaintBallArena[arenaid][pbVeh1Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh1ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh1Model], PaintBallArena[arenaid][pbVeh1X], PaintBallArena[arenaid][pbVeh1Y], PaintBallArena[arenaid][pbVeh1Z], PaintBallArena[arenaid][pbVeh1A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh2Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh2ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh2Model], PaintBallArena[arenaid][pbVeh2X], PaintBallArena[arenaid][pbVeh2Y], PaintBallArena[arenaid][pbVeh2Z], PaintBallArena[arenaid][pbVeh2A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh3Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh3ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh3Model], PaintBallArena[arenaid][pbVeh3X], PaintBallArena[arenaid][pbVeh3Y], PaintBallArena[arenaid][pbVeh3Z], PaintBallArena[arenaid][pbVeh3A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh4Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh4ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh4Model], PaintBallArena[arenaid][pbVeh4X], PaintBallArena[arenaid][pbVeh4Y], PaintBallArena[arenaid][pbVeh4Z], PaintBallArena[arenaid][pbVeh4A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh5Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh5ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh5Model], PaintBallArena[arenaid][pbVeh5X], PaintBallArena[arenaid][pbVeh5Y], PaintBallArena[arenaid][pbVeh5Z], PaintBallArena[arenaid][pbVeh5A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh6Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh6ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh6Model], PaintBallArena[arenaid][pbVeh6X], PaintBallArena[arenaid][pbVeh6Y], PaintBallArena[arenaid][pbVeh6Z], PaintBallArena[arenaid][pbVeh6A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbInterior]);
								}							
							}	
							PaintBallArena[arenaid][pbActive] = 1;
							PaintBallArena[arenaid][pbLocked] = 1;
							GivePlayerCash(playerid,-PaintBallArena[arenaid][pbBidMoney]);
							PaintBallArena[arenaid][pbMoneyPool] += PaintBallArena[arenaid][pbBidMoney];
							SpawnPaintballArena(playerid, arenaid);
							return 1;
						}
					}
				}
				if(PaintBallArena[arenaid][pbGameType] == 3) // Capture the Flag
				{
					switch(listitem)
					{
						case 0: // Password
						{
							ShowPlayerDialogEx(playerid,PBCHANGEPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap mat khau:","Ban hay nhap mat khau cho phong nay:","Xac nhan","Tro ve");
							return 1;
						}
						case 1: // GameType
						{
							ShowPlayerDialogEx(playerid,PBCHANGEGAMEMODE,DIALOG_STYLE_LIST,"Paintball Arena - Chon the loai:","Deathmatch\nTeam Deathmatch\nCapture the Flag\nKing of the Hill\nTeam King of the Hill","Xac nhan","Tro ve");
							return 1;
						}
						case 2: // Limit
						{
							ShowPlayerDialogEx(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Gioi han nguoi tham gia:","Ban hay nhap gioi han nguoi tham gia (2 > 16):","Xac nhan","Tro ve");
							return 1;
						}
						case 3: // Time Limit
						{
							ShowPlayerDialogEx(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Thoi gian tran dau:","Ban hay nhap thoi gian cho tran dau nay (5 > 15 phut):","Xac nhan","Tro ve");
							return 1;
						}
						case 4: // Bid Money
						{
							ShowPlayerDialogEx(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Gia tien tham gia:","Ban hay nhap gia tien de tham gia phong nay ($0 > $10000):","Xac nhan","Tro ve");
							return 1;
						}
						case 5: // Health
						{
							ShowPlayerDialogEx(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap HP:","Ban hay thiet lap HP cho phong nay (1 > 100):","Xac nhan","Tro ve");
							return 1;
						}
						case 6: // Armor
						{
							ShowPlayerDialogEx(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap Giap:","Ban hay thiet lap GIAP cho phong nay (0-100):","Xac nhan","Tro ve");
							return 1;
						}
						case 7: // Weapons 1
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 1):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
							return 1;
						}
						case 8: // Weapons 2
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 2):","Ban hay thiet lap ID vu khi 2 cho phong nay (0 > 34):","Xac nhan","Tro ve");
							return 1;
						}
						case 9: // Weapons 3
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 3):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
							return 1;
						}
						case 10: // Exploit Perm
						{
							ShowPlayerDialogEx(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Ban co muon cho phep QS/CS trong phong khong? (1 = Co / 0 = Khong):","Xac nhan","Tro ve");
							return 1;
						}
						case 11: // War
						{
							ShowPlayerDialogEx(playerid,PBCHANGEWAR,DIALOG_STYLE_MSGBOX,"Paintball Arena - Change War:", "Ban co muon cho phep WAR trong phong khong?", "Co", "Khong");
							return 1;
						}
						case 12: // Flag 
						{
							ShowPlayerDialogEx(playerid,PBCHANGEFLAGINSTAGIB,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag Instagib:","Ban co muon cho phep one-shot nguoi giu co khong? (1 = Co / 0 = Khong):\n\nMEO: Nguoi giu co se chi co 1 HP","Xac nhan","Tro ve");
							return 1;
						}
						case 13: // Flag No Weapons
						{
							ShowPlayerDialogEx(playerid,PBCHANGEFLAGNOWEAPONS,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag No Weapons:","Ban co muon tat che do su dung vu khi cho nguoi giu co khong? (1 = Co / 0 = Khong):\n\nMEO: Nguoi giu co se khong the su dung vu khi, chi su dung nam dam","Xac nhan","Tro ve");
							return 1;
						}
						case 14: // Begin Arena
						{
							if(PlayerInfo[playerid][pDonateRank] <= 2)
							{
								if(PlayerInfo[playerid][pPaintTokens] >= 5)
								{
									PlayerInfo[playerid][pPaintTokens] -= 5;
									format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at a cost of %d tokens.",PaintBallArena[arenaid][pbTimeLeft]/60,5);
									SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
									SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
									PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
									//SendAudioToPlayer(playerid, 41, 100);
								}
								else
								{
									PaintballSetupArena(playerid);
									SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong coenough tokens to rent this room for this gametype.");
									return 1;
								}
							}
							else
							{
								format(szMiscArray,sizeof(szMiscArray),"You have rented this room for %d minutes at no cost because of Gold+ VIP.",PaintBallArena[arenaid][pbTimeLeft]/60);
								SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
								SendClientMessageEx(playerid, COLOR_WHITE, "CAC LENH PB: /scores - /exitarena - /joinarena - /switchteam");
								PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
								//SendAudioToPlayer(playerid, 41, 100);
							}

							SetPVarInt(playerid, "TickCTFID", SetTimerEx("TickCTF", 1000, true, "d", playerid)); // Room Owner's CTF Tick Function
							PlayerInfo[playerid][pPaintTeam] = 1;
							PaintBallArena[arenaid][pbTeamRed] = 1;

							// Spawn Flags
							PaintBallArena[arenaid][pbTeamRedTextID] = Create3DTextLabel("Red Base", COLOR_RED, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 1000.0, PaintBallArena[arenaid][pbVirtual], 0);
							//PaintBallArena[arenaid][pbTeamRedTextID] = CreateDynamic3DTextLabel("Red Base", COLOR_RED, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 1000.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
							PaintBallArena[arenaid][pbTeamBlueTextID] = Create3DTextLabel("Blue Base", COLOR_DBLUE, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 1000.0, PaintBallArena[arenaid][pbVirtual], 0);
							//PaintBallArena[arenaid][pbTeamBlueTextID] = CreateDynamic3DTextLabel("Blue Base", COLOR_DBLUE, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 1000.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
							PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
							PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

							// Default Flag Positions
							PaintBallArena[arenaid][pbFlagRedActive] = 0;
							PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
							PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
							PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];

							PaintBallArena[arenaid][pbFlagBlueActive] = 0;
							PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
							PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
							PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];

							// Start Round, Open Room
							if(PaintBallArena[arenaid][pbWar] == 1)
							{
								if(PaintBallArena[arenaid][pbVeh1Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh1ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh1Model], PaintBallArena[arenaid][pbVeh1X], PaintBallArena[arenaid][pbVeh1Y], PaintBallArena[arenaid][pbVeh1Z], PaintBallArena[arenaid][pbVeh1A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh1ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh2Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh2ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh2Model], PaintBallArena[arenaid][pbVeh2X], PaintBallArena[arenaid][pbVeh2Y], PaintBallArena[arenaid][pbVeh2Z], PaintBallArena[arenaid][pbVeh2A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh2ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh3Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh3ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh3Model], PaintBallArena[arenaid][pbVeh3X], PaintBallArena[arenaid][pbVeh3Y], PaintBallArena[arenaid][pbVeh3Z], PaintBallArena[arenaid][pbVeh3A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh3ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh4Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh4ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh4Model], PaintBallArena[arenaid][pbVeh4X], PaintBallArena[arenaid][pbVeh4Y], PaintBallArena[arenaid][pbVeh4Z], PaintBallArena[arenaid][pbVeh4A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh4ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh5Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh5ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh5Model], PaintBallArena[arenaid][pbVeh5X], PaintBallArena[arenaid][pbVeh5Y], PaintBallArena[arenaid][pbVeh5Z], PaintBallArena[arenaid][pbVeh5A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh5ID], PaintBallArena[arenaid][pbInterior]);
								}
								if(PaintBallArena[arenaid][pbVeh6Model] != 0)
								{
									PaintBallArena[arenaid][pbVeh6ID] = CreateVehicle(PaintBallArena[arenaid][pbVeh6Model], PaintBallArena[arenaid][pbVeh6X], PaintBallArena[arenaid][pbVeh6Y], PaintBallArena[arenaid][pbVeh6Z], PaintBallArena[arenaid][pbVeh6A], 0, 0, -1);
									SetVehicleVirtualWorld(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbVirtual]);
									LinkVehicleToInterior(PaintBallArena[arenaid][pbVeh6ID], PaintBallArena[arenaid][pbInterior]);
								}							
							}			
							PaintBallArena[arenaid][pbActive] = 1;
							PaintBallArena[arenaid][pbLocked] = 1;
							GivePlayerCash(playerid,-PaintBallArena[arenaid][pbBidMoney]);
							PaintBallArena[arenaid][pbMoneyPool] += PaintBallArena[arenaid][pbBidMoney];
							SpawnPaintballArena(playerid, arenaid);
							return 1;
						}
					}
				}
				PaintballSetupArena(playerid);
			}
			else
			{
				LeavePaintballArena(playerid, GetPVarInt(playerid, "ArenaNumber"));
				PaintballArenaSelection(playerid);
			}
		}
		case PBCHANGEPASSWORD:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					format(szMiscArray, sizeof(szMiscArray), "None");
					strmid(PaintBallArena[arenaid][pbPassword], szMiscArray, 0, strlen(szMiscArray), 64);
					PaintballSetupArena(playerid);
					return 1;
				}
				strmid(PaintBallArena[arenaid][pbPassword], inputtext, 0, strlen(inputtext), 64);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEGAMEMODE:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				switch(listitem)
				{
					case 0:
					{
						PaintBallArena[arenaid][pbGameType] = 1;
						PaintballSetupArena(playerid);
					}
					case 1:
					{
						PaintBallArena[arenaid][pbGameType] = 2;
						PaintballSetupArena(playerid);
					}
					case 2:
					{
						PaintBallArena[arenaid][pbGameType] = 3;
						PaintballSetupArena(playerid);
					}
					case 3:
					{
						PaintBallArena[arenaid][pbGameType] = 4;
						PaintballSetupArena(playerid);
					}
					case 4:
					{
						PaintBallArena[arenaid][pbGameType] = 5;
						PaintballSetupArena(playerid);
					}
				}
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGELIMIT:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Gioi han nguoi tham gia:","Ban hay nhap gioi han nguoi tham gia phong nay (2 > 16):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) < 2 || strval(inputtext) > 16)
				{
					ShowPlayerDialogEx(playerid,PBCHANGELIMIT,DIALOG_STYLE_INPUT,"Paintball Arena - Gioi han nguoi tham gia:","Ban hay nhap gioi han nguoi tham gia phong nay (2-16):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbLimit] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGETIMELEFT:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Thoi gian tran dau:","Ban hay nhap thoi gian cho tran dau nay (5 > 15 phut):","Xac nhan","Tro ve");
					return 1;
				}
				if(strfind(".", inputtext, true) != -1)
				{
					ShowPlayerDialogEx(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Thoi gian tran dau:","Ban hay nhap thoi gian cho tran dau nay (5 > 15 phut):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) < 5 || strval(inputtext) > 15)
				{
					ShowPlayerDialogEx(playerid,PBCHANGETIMELEFT,DIALOG_STYLE_INPUT,"Paintball Arena - Thoi gian tran dau:","Ban hay nhap thoi gian cho tran dau nay (5 > 15 phut):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbTimeLeft] = strval(inputtext)*60;
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEBIDMONEY:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Gia tien tham gia:","Ban hay nhap gia tien de tham gia phong nay ($0 > $10000):","Xac nhan","Tro ve");

					return 1;
				}
				if(strval(inputtext) < 0 || strval(inputtext) > 10000)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEBIDMONEY,DIALOG_STYLE_INPUT,"Paintball Arena - Gia tien tham gia:","Ban hay nhap gia tien de tham gia phong nay ($0 > $10000):","Xac nhan","Tro ve");

					return 1;
				}
				if(strval(inputtext) > GetPlayerCash(playerid))
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the nhap so tien hzay nhieu hon so voi so tien mat ban dang co.");
					return 1;
				}
				PaintBallArena[arenaid][pbBidMoney] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEHEALTH:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap HP:","Ban hay thiet lap HP cho phong nay (1 > 100):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 100)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEHEALTH,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap HP:","Ban hay thiet lap HP cho phong nay (1 > 100):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbHealth] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEARMOR:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap Giap:","Ban hay thiet lap GIAP cho phong nay (0-100):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) < 0 || strval(inputtext) > 99)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEARMOR,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap Giap:","Ban hay thiet lap GIAP cho phong nay (0-100):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbArmor] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEWEAPONS1:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 1):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) == 16 || strval(inputtext) == 18)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 1):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;			
				}
				if(strval(inputtext) < 0||strval(inputtext) > 34)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 1):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) >= 19 && strval(inputtext) <= 21)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 1):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbWeapons][0] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEWEAPONS2:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 2):","Ban hay thiet lap ID vu khi 2 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) == 16 || strval(inputtext) == 18)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 2):","Ban hay thiet lap ID vu khi 2 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;			
				}			
				if(strval(inputtext) < 0||strval(inputtext) > 34)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 2):","Ban hay thiet lap ID vu khi 2 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) >= 19 && strval(inputtext) <= 21)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS2,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 1):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbWeapons][1] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEWEAPONS3:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 3):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) == 16 || strval(inputtext) == 18)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS1,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 3):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;			
				}			
				if(strval(inputtext) < 0||strval(inputtext) > 34)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 3):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) >= 19 && strval(inputtext) <= 21)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEWEAPONS3,DIALOG_STYLE_INPUT,"Paintball Arena - Thiet lap vu khi (Slot 3):","Ban hay thiet lap ID vu khi 1 cho phong nay (0 > 34):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbWeapons][2] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEEXPLOITPERM:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Ban co muon cho phep QS/CS trong phong khong? (1 = Co / 0 = Khong):","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) < 0||strval(inputtext) > 1)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEEXPLOITPERM,DIALOG_STYLE_INPUT,"Paintball Arena - Change Exploit Permissions:","Ban co muon cho phep QS/CS trong phong khong? (1 = Co / 0 = Khong):","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbExploitPerm] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEWAR:
		{
			new arenaid = GetPVarInt(playerid, "ArenaNumber");
			if(response == 1)
			{
				if(PlayerInfo[playerid][pDonateRank] >= 3)
				{
					PaintBallArena[arenaid][pbWar] = 1;
				}
				else
				{
					PaintBallArena[arenaid][pbWar] = 0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Chi co VIP Gold+ moi co the su dung tinh nang nay.");
				}
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintBallArena[arenaid][pbWar] = 0;
				PaintballSetupArena(playerid);
			}
		}	
		case PBCHANGEFLAGINSTAGIB:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEFLAGINSTAGIB,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag Instagib:","Ban co muon cho phep one-shot nguoi giu co khong? (1 = Co / 0 = Khong):\n\nMEO: Nguoi giu co se chi co 1 HP","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) < 0||strval(inputtext) > 1)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEFLAGINSTAGIB,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag Instagib:","Ban co muon cho phep one-shot nguoi giu co khong? (1 = Co / 0 = Khong):\n\nMEO: Nguoi giu co se chi co 1 HP","Xac nhan","Tro ve");

					return 1;
				}
				PaintBallArena[arenaid][pbFlagInstagib] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBCHANGEFLAGNOWEAPONS:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaNumber");
				if(isnull(inputtext))
				{
					ShowPlayerDialogEx(playerid,PBCHANGEFLAGNOWEAPONS,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag No Weapons:","Ban co muon tat che do su dung vu khi cho nguoi giu co khong? (1 = Co / 0 = Khong):\n\nMEO: Nguoi giu co se khong the su dung vu khi, chi su dung nam dam","Xac nhan","Tro ve");
					return 1;
				}
				if(strval(inputtext) < 0||strval(inputtext) > 1)
				{
					ShowPlayerDialogEx(playerid,PBCHANGEFLAGNOWEAPONS,DIALOG_STYLE_INPUT,"Paintball Arena - Change Flag No Weapons:","Ban co muon tat che do su dung vu khi cho nguoi giu co khong? (1 = Co / 0 = Khong):\n\nMEO: Nguoi giu co se khong the su dung vu khi, chi su dung nam dam","Xac nhan","Tro ve");
					return 1;
				}
				PaintBallArena[arenaid][pbFlagNoWeapons] = strval(inputtext);
				PaintballSetupArena(playerid);
			}
			else
			{
				PaintballSetupArena(playerid);
			}
		}
		case PBJOINPASSWORD:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaEnterPass");
				if(PaintBallArena[arenaid][pbPlayers] >= PaintBallArena[arenaid][pbLimit])
				{
					PaintballArenaSelection(playerid);
					DeletePVar(playerid, "ArenaEnterPass");
					DeletePVar(playerid, "pbTeamChoice");
					return 1;
				}
				if(isnull(inputtext))
				{
					PaintballArenaSelection(playerid);
					DeletePVar(playerid, "ArenaEnterPass");
					DeletePVar(playerid, "pbTeamChoice");
					return 1;
				}
				if(strcmp(PaintBallArena[arenaid][pbPassword], inputtext, false))
				{
					PaintballArenaSelection(playerid);
					DeletePVar(playerid, "ArenaEnterPass");
					DeletePVar(playerid, "pbTeamChoice");
					return 1;
				}
				if(JoinPaintballArena(playerid,arenaid,inputtext))
				{
					DeletePVar(playerid, "ArenaEnterPass");
				}
				else
				{
					PaintballArenaSelection(playerid);
					DeletePVar(playerid, "pbTeamChoice");
				}
			}
			else
			{
				PaintballArenaSelection(playerid);
				DeletePVar(playerid, "pbTeamChoice");
			}
		}
		case PBSWITCHTEAM:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "IsInArena");
				switch(listitem)
				{
					case 0: // Red
					{
						new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
						if(PlayerInfo[playerid][pPaintTeam] == 1)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang o Red team roi.");
							PaintballSwitchTeam(playerid);
							return 1;
						}
						if(PaintBallArena[arenaid][pbTimeLeft] < 180)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the chuyen team ngay bay gio!");
							return 1;
						}
						if(PaintBallArena[arenaid][pbTeamRed] >= teamlimit)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Red team da full, yeu cau chon doi khac.");
							PaintballSwitchTeam(playerid);
							return 1;
						}
						if(PaintBallArena[arenaid][pbTeamRed] > PaintBallArena[arenaid][pbTeamBlue])
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Cac doi hien khong dong dieu, ban khong the chuyen team ngay bay gio!");
							return 1;
						}
						PaintBallArena[arenaid][pbTeamBlue]--;
						PaintBallArena[arenaid][pbTeamRed]++;
						PlayerInfo[playerid][pPaintTeam] = 1;
						SetHealth(playerid, 0);
					}
					case 1: // Blue
					{
						new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
						if(PlayerInfo[playerid][pPaintTeam] == 2)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang o Blue team roi.");
							PaintballSwitchTeam(playerid);
							return 1;
						}
						if(PaintBallArena[arenaid][pbTimeLeft] < 180)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the chuyen team ngay bay gio!");
							return 1;
						}
						if(PaintBallArena[arenaid][pbTeamBlue] >= teamlimit)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Blue team da full, yeu cau chon doi khac.");
							PaintballSwitchTeam(playerid);
							return 1;
						}
						if(PaintBallArena[arenaid][pbTeamBlue] > PaintBallArena[arenaid][pbTeamRed])
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Cac doi hien khong dong dieu, ban khong the chuyen team ngay bay gio!");
							return 1;
						}
						PaintBallArena[arenaid][pbTeamRed]--;
						PaintBallArena[arenaid][pbTeamBlue]++;
						PlayerInfo[playerid][pPaintTeam] = 2;
						SetHealth(playerid, 0);
					}
				}
			}
		}
		case PBJOINTEAM:
		{
			if(response == 1)
			{
				new arenaid = GetPVarInt(playerid, "ArenaEnterTeam");
				if(PaintBallArena[arenaid][pbPlayers] >= PaintBallArena[arenaid][pbLimit])
				{
					PaintballArenaSelection(playerid);
					DeletePVar(playerid, "ArenaEnterTeam");
					return 1;
				}
				switch(listitem)
				{
					case 0: // Red
					{
						new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
						if(PaintBallArena[arenaid][pbTeamRed] >= teamlimit)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Red team da dat full, yeu cau chon doi khac.");
							ShowPlayerDialogEx(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Chon team:","{FF0000}Red Team\n{0000FF}Blue Team","Xac nhan","Thoat");
							return 1;
						}
						if(PaintBallArena[arenaid][pbTeamRed] > PaintBallArena[arenaid][pbTeamBlue])
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Cac doi hien khong dong dieu, ban khong the chuyen team ngay bay gio!");
							ShowPlayerDialogEx(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Chon team:","{FF0000}Red Team\n{0000FF}Blue Team","Xac nhan","Thoat");
							return 1;
						}
						SetPVarInt(playerid, "pbTeamChoice", 1);
						if(strcmp(PaintBallArena[arenaid][pbPassword], "None", false))
						{
							SetPVarInt(playerid, "ArenaEnterPass", arenaid);
							ShowPlayerDialogEx(playerid,PBJOINPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Mat khau:","Phong nay duoc thiet lap mat khau, hay dien mat khau vao:","Xac nhan","Thoat");
							return 1;
						}
						JoinPaintballArena(playerid, arenaid, "None");
					}
					case 1: // Blue
					{
						new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
						if(PaintBallArena[arenaid][pbTeamBlue] >= teamlimit)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Blue team da dat full, yeu cau chon doi khac.");
							ShowPlayerDialogEx(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Chon team:","{FF0000}Red Team\n{0000FF}Blue Team","Xac nhan","Thoat");
							return 1;
						}
						if(PaintBallArena[arenaid][pbTeamBlue] > PaintBallArena[arenaid][pbTeamRed])
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Cac doi hien khong dong dieu, ban khong the chuyen team ngay bay gio!");
							ShowPlayerDialogEx(playerid,PBJOINTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Chon team:","{FF0000}Red Team\n{0000FF}Blue Team","Xac nhan","Thoat");
							return 1;
						}
						SetPVarInt(playerid, "pbTeamChoice", 2);
						if(strcmp(PaintBallArena[arenaid][pbPassword], "None", false))
						{
							SetPVarInt(playerid, "ArenaEnterPass", arenaid);
							ShowPlayerDialogEx(playerid,PBJOINPASSWORD,DIALOG_STYLE_INPUT,"Paintball Arena - Mat khau:","Phong nay duoc thiet lap mat khau, hay dien mat khau vao:","Xac nhan","Thoat");
							return 1;
						}
						JoinPaintballArena(playerid, arenaid, "None");
					}
				}
			}
			else
			{
				PaintballArenaSelection(playerid);
			}
		}
	}
	return 0;
}

CMD:areloadpb(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
		LoadPaintballArenas();
		SendClientMessageEx(playerid, COLOR_RED, " Paintball Arenas Loaded from the database. ");
    }
}

CMD:unlockarenas(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
        return 1;
    }
    for(new i = 0; i < MAX_ARENAS; i++) {
        if(PaintBallArena[i][pbLocked] == 2) {
            ResetPaintballArena(i);
        }
    }
    format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s da mo khoa.", GetPlayerNameEx(playerid));
    ABroadCast(COLOR_YELLOW, szMiscArray, 2);
    format(szMiscArray, sizeof(szMiscArray), "* Admin %s da mo khoa tat ca cac phong trong dau truong, ban co the tham gia.", GetPlayerNameEx(playerid));
    SendClientMessageToAllEx(COLOR_LIGHTBLUE, szMiscArray);
    return 1;
}

CMD:lockarenas(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
        return 1;
    }

    for(new i = 0; i < MAX_ARENAS; i++) {

        foreach(new p: Player) {

			if(!GetPVarType(p, "IsInArena")) continue;
			new arenaid = GetPVarInt(p, "IsInArena");
			if(arenaid == i) {
				if(PaintBallArena[arenaid][pbBidMoney] > 0) {
					GivePlayerCash(p,PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
					format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of $%d because of premature closure.",PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
					SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
				}
				if(arenaid == GetPVarInt(p, "ArenaNumber")) {
					switch(PaintBallArena[arenaid][pbGameType]) {
						case 1:
						{
							if(PlayerInfo[p][pDonateRank] < 3) {
								PlayerInfo[p][pPaintTokens] += 3;
								format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",3);
								SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
							}
						}
						case 2:
						{
							if(PlayerInfo[p][pDonateRank] < 3) {
								PlayerInfo[p][pPaintTokens] += 4;
								format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",4);
								SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
							}
						}
						case 3:
						{
							if(PlayerInfo[p][pDonateRank] < 3) {
								PlayerInfo[p][pPaintTokens] += 5;
								format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
							}
						}
						case 4:
						{
							if(PlayerInfo[p][pDonateRank] < 3) {
								PlayerInfo[p][pPaintTokens] += 5;
								format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
							}
						}
						case 5:
						{
							if(PlayerInfo[p][pDonateRank] < 3) {
								PlayerInfo[p][pPaintTokens] += 6;
								format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",6);
								SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
							}
						}
					}
				}
				LeavePaintballArena(p, arenaid);
			}
		}	
        ResetPaintballArena(i);
        PaintBallArena[i][pbLocked] = 2;
    }
    format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s da khoa tat ca cac phong trong dau truong.", GetPlayerNameEx(playerid));
    ABroadCast(COLOR_YELLOW, szMiscArray, 2);
    format(szMiscArray, sizeof(szMiscArray), "* Admin %s has locked all Paintball Arenas for some short maintenance.", GetPlayerNameEx(playerid));
    SendClientMessageToAllEx(COLOR_LIGHTBLUE, szMiscArray);
    return 1;
}

CMD:savedmpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(GetPVarInt(playerid, "EditingDMPos") == 0) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any spawn positions.");
            return 1;
        }
        if(!GetPVarType(playerid, "ArenaNumber")) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new dmposid = GetPVarInt(playerid, "EditingDMPos");
        new Float:x, Float: y, Float: z, Float: angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);

        switch(dmposid) {
            case 1:
            {
                PaintBallArena[arenaid][pbDeathmatch1][0] = x;
                PaintBallArena[arenaid][pbDeathmatch1][1] = y;
                PaintBallArena[arenaid][pbDeathmatch1][2] = z;
                PaintBallArena[arenaid][pbDeathmatch1][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 1.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
            case 2:
            {
                PaintBallArena[arenaid][pbDeathmatch2][0] = x;
                PaintBallArena[arenaid][pbDeathmatch2][1] = y;
                PaintBallArena[arenaid][pbDeathmatch2][2] = z;
                PaintBallArena[arenaid][pbDeathmatch2][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 2.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
            case 3:
            {
                PaintBallArena[arenaid][pbDeathmatch3][0] = x;
                PaintBallArena[arenaid][pbDeathmatch3][1] = y;
                PaintBallArena[arenaid][pbDeathmatch3][2] = z;
                PaintBallArena[arenaid][pbDeathmatch3][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 3.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
            case 4:
            {
                PaintBallArena[arenaid][pbDeathmatch4][0] = x;
                PaintBallArena[arenaid][pbDeathmatch4][1] = y;
                PaintBallArena[arenaid][pbDeathmatch4][2] = z;
                PaintBallArena[arenaid][pbDeathmatch4][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 4.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
    }
    return 1;
}

CMD:saveteampos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(GetPVarInt(playerid, "EditingTeamPos") == 0) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any spawn positions.");
            return 1;
        }
        if(!GetPVarType(playerid, "ArenaNumber")) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new teamposid = GetPVarInt(playerid, "EditingTeamPos");
        new Float:x, Float: y, Float: z, Float: angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);

        switch(teamposid) {
            case 1:
            {
                PaintBallArena[arenaid][pbTeamRed1][0] = x;
                PaintBallArena[arenaid][pbTeamRed1][1] = y;
                PaintBallArena[arenaid][pbTeamRed1][2] = z;
                PaintBallArena[arenaid][pbTeamRed1][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Spawn Position 1.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 2:
            {
                PaintBallArena[arenaid][pbTeamRed2][0] = x;
                PaintBallArena[arenaid][pbTeamRed2][1] = y;
                PaintBallArena[arenaid][pbTeamRed2][2] = z;
                PaintBallArena[arenaid][pbTeamRed2][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Spawn Position 2.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 3:
            {
                PaintBallArena[arenaid][pbTeamRed3][0] = x;
                PaintBallArena[arenaid][pbTeamRed3][1] = y;
                PaintBallArena[arenaid][pbTeamRed3][2] = z;
                PaintBallArena[arenaid][pbTeamRed3][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Spawn Position 3.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 4:
            {
                PaintBallArena[arenaid][pbTeamBlue1][0] = x;
                PaintBallArena[arenaid][pbTeamBlue1][1] = y;
                PaintBallArena[arenaid][pbTeamBlue1][2] = z;
                PaintBallArena[arenaid][pbTeamBlue1][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Spawn Position 1.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 5:
            {
                PaintBallArena[arenaid][pbTeamBlue2][0] = x;
                PaintBallArena[arenaid][pbTeamBlue2][1] = y;
                PaintBallArena[arenaid][pbTeamBlue2][2] = z;
                PaintBallArena[arenaid][pbTeamBlue2][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Spawn Position 2.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 6:
            {
                PaintBallArena[arenaid][pbTeamBlue3][0] = x;
                PaintBallArena[arenaid][pbTeamBlue3][1] = y;
                PaintBallArena[arenaid][pbTeamBlue3][2] = z;
                PaintBallArena[arenaid][pbTeamBlue3][3] = angle;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Spawn Position 3.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
    }
    return 1;
}

CMD:saveflagpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(GetPVarInt(playerid, "EditingFlagPos") == 0) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any flag positions.");
            return 1;
        }
        if(!GetPVarType(playerid, "ArenaNumber")) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new flagposid = GetPVarInt(playerid, "EditingFlagPos");
        new Float:x, Float: y, Float: z;
        GetPlayerPos(playerid, x, y, z);

        switch(flagposid) {
            case 1:                               // Red Flag Spawn Position
            {
                PaintBallArena[arenaid][pbFlagRedSpawn][0] = x;
                PaintBallArena[arenaid][pbFlagRedSpawn][1] = y;
                PaintBallArena[arenaid][pbFlagRedSpawn][2] = z;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f",x,y,z);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Flag Position.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingFlagPos", 0);
                PaintballEditArenaFlagSpawns(playerid);
            }
            case 2:                               // Blue Flag Spawn Position
            {
                PaintBallArena[arenaid][pbFlagBlueSpawn][0] = x;
                PaintBallArena[arenaid][pbFlagBlueSpawn][1] = y;
                PaintBallArena[arenaid][pbFlagBlueSpawn][2] = z;

                format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f",x,y,z);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Flag Position.");
                SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                SetPVarInt(playerid, "EditingFlagPos", 0);
                PaintballEditArenaFlagSpawns(playerid);
            }
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
    }
    return 1;
}

CMD:savehillpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(!GetPVarType(playerid, "ArenaNumber")) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new stage = GetPVarInt(playerid, "EditingHillStage");
        new Float:x, Float: y, Float: z;
        GetPlayerPos(playerid, x, y, z);

        if(stage == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are not editing any Hill Positions right now!");
            return 1;
        }
        else {
            switch(stage) {
                case 1:
                {
                    PaintBallArena[arenaid][pbHillX] = x;
                    PaintBallArena[arenaid][pbHillY] = y;
                    PaintBallArena[arenaid][pbHillZ] = z;

                    format(szMiscArray,sizeof(szMiscArray),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited the Hill Position.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);

                    DeletePVar(playerid, "EditingHillStage");
                    PaintballEditArenaMenu(playerid);
                }
            }
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
    }
    return 1;
}

CMD:switchteam(playerid, params[])
{
    if(!GetPVarType(playerid, "IsInArena")) {
        SendClientMessageEx(playerid,COLOR_WHITE,"Ban khong dung tai an arena, you can not switch teams!");
        return 1;
    }
    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1) {
        SendClientMessageEx(playerid,COLOR_WHITE,"You can not switch teams while holding the flag!");
        return 1;
    }

    new arenaid = GetPVarInt(playerid, "IsInArena");
    if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3 || PaintBallArena[arenaid][pbGameType] == 5) {
        PaintballSwitchTeam(playerid);
    }
    else {
        SendClientMessageEx(playerid,COLOR_WHITE,"You can not switch teams in this gamemode!");
    }
    return 1;
}

CMD:joinarena(playerid, params[])
{
    if(!GetPVarType(playerid, "IsInArena")) {
        if(PlayerInfo[playerid][pLevel] < 2) {
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong the tham gia Paintball vi dang bi han che su dung vu khi.");
            return 1;
        }
        if(GetPVarInt(playerid, "Packages") >= 1 || TaxiAccepted[playerid] != INVALID_PLAYER_ID || EMSAccepted[playerid] != INVALID_PLAYER_ID || BusAccepted[playerid] != INVALID_PLAYER_ID || MedicAccepted[playerid] != INVALID_PLAYER_ID || MechanicCallTime[playerid] >= 1) {
            SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa muc tieu truoc khi thuc hien danh dau khac (/xoamuctieu).");
            return 1;
        }
        if(pTazer{playerid} != 0)
		{
			RemovePlayerWeapon(playerid, 23);
			GivePlayerValidWeapon(playerid, pTazerReplace{playerid});
			format(szMiscArray, sizeof(szMiscArray), "* %s holsters their tazer.", GetPlayerNameEx(playerid));			ProxDetector(4.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
 			pTazer{playerid} = 0;
 		}
		if(PlayerCuffed[playerid] >= 1 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx( playerid, COLOR_WHITE, "You can't do this right now." );
        if(PlayerInfo[playerid][pAdmin] > 2) {
            ShowPlayerDialogEx(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Chon phong\nMua Token Paintball\nAdmin Menu","Chon","Thoat");
            return 1;
        }
        if(IsPlayerInRangeOfPoint(playerid, 10.0, 1294.5062, -1445.0599, 0.4403)) {
            ShowPlayerDialogEx(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Chon phong\nMua Token Paintball\nAdmin Menu","Chon","Thoat");
        }
        else {
            SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung gan the Paintball Arena!");
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang o trong Paintball!");
    }
    return 1;
}

CMD:exitarena(playerid, params[])
{
    if(GetPVarType(playerid, "IsInArena")) {
        if(GetPlayerState(playerid) == PLAYER_STATE_WASTED) {
            SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu do vao luc nay.");
            return 1;
        }
        if(PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbTimeLeft] <= 30) {
            SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the roi khoi phong nay khi tran dau con 30 giay!");
            return 1;
        }
        if(GetPVarInt(playerid, "commitSuicide") == 1) {
        	DeletePVar(playerid, "commitSuicide");
        	SendClientMessageEx(playerid, COLOR_GREY, "Ban da thoat Paintball, he thong tu dong huy yeu cau /kill.");
        } 
        LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung tai Paintball!");
    }
    return 1;
}

CMD:scores(playerid, params[])
{
    if(GetPVarType(playerid, "IsInArena"))
	{
        PaintballScoreboard(playerid, GetPVarInt(playerid, "IsInArena"));
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung tai Paintball!");
    }
    return 1;
}

CMD:lockarena(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
		return 1;
	}

	new arenaid;
	if(sscanf(params, "d", arenaid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /lockarena [arenaid]");

	arenaid--;

	if(arenaid < 0 || arenaid > MAX_ARENAS-1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have entered a invalid arenaid.");
		return 1;
	}
	foreach(new p: Player)
	{
		if(!GetPVarType(p, "IsInArena")) return 1;
		new cid = GetPVarInt(p, "IsInArena");
		if(cid == arenaid)
		{
			if(PaintBallArena[cid][pbBidMoney] > 0)
			{
				GivePlayerCash(p,PaintBallArena[cid][pbBidMoney]);
				format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of $%d because of premature closure.",PaintBallArena[cid][pbBidMoney]);
				SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
			}
			if(arenaid == GetPVarInt(p, "ArenaNumber"))
			{
				switch(PaintBallArena[arenaid][pbGameType])
				{
					case 1:
					{
						if(PlayerInfo[p][pDonateRank] < 3)
						{
							PlayerInfo[p][pPaintTokens] += 3;
							format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",3);
							SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
						}
					}
					case 2:
					{
						if(PlayerInfo[p][pDonateRank] < 3)
						{
							PlayerInfo[p][pPaintTokens] += 4;
							format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",4);
							SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
						}
					}
					case 3:
					{
						if(PlayerInfo[p][pDonateRank] < 3)
						{
							PlayerInfo[p][pPaintTokens] += 5;
							format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
							SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
						}
					}
					case 4:
					{
						if(PlayerInfo[p][pDonateRank] < 3)
						{
							PlayerInfo[p][pPaintTokens] += 5;
							format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
							SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
						}
					}
					case 5:
					{
						if(PlayerInfo[p][pDonateRank] < 3)
						{
							PlayerInfo[p][pPaintTokens] += 6;
							format(szMiscArray,sizeof(szMiscArray),"You have been refunded a total of %d Paintball Tokens because of premature closure.",6);
							SendClientMessageEx(p, COLOR_WHITE, szMiscArray);
						}
					}
				}
			}
			LeavePaintballArena(p, cid);
		}
	}	
	ResetPaintballArena(arenaid);
	PaintBallArena[arenaid][pbLocked] = 2;
	format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s has locked %s.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName]);
	ABroadCast(COLOR_YELLOW, szMiscArray, 2);
	format(szMiscArray, sizeof(szMiscArray), "* Admin %s has locked %s (ArenaID: %d) for some short maintenance.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName],arenaid+1);
	SendClientMessageToAllEx(COLOR_LIGHTBLUE, szMiscArray);
	return 1;
}

CMD:unlockarena(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
		return 1;
	}

	new arenaid;
	if(sscanf(params, "d", arenaid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /unlockarena [arenaid]");

	arenaid--;

	if(arenaid < 0 || arenaid > MAX_ARENAS-1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have entered a invalid arenaid.");
		return 1;
	}
	if(PaintBallArena[arenaid][pbLocked] == 2)
	{
		ResetPaintballArena(arenaid);
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s has unlocked %s.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName]);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);
		format(szMiscArray, sizeof(szMiscArray), "* Admin %s has unlocked %s (ArenaID: %d), you may join/create it now.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName],arenaid+1);
		SendClientMessageToAllEx(COLOR_LIGHTBLUE, szMiscArray);
	}
	return 1;
}

CMD:givepainttokens(playerid, params[])
{
	new giveplayerid, amount;
	if(sscanf(params, "ud", giveplayerid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givepainttokens [player] [amount]");

	if(IsPlayerConnected(giveplayerid))
	{
		if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh nay.");
			return 1;
		}
		PlayerInfo[giveplayerid][pPaintTokens] += amount;

		format(szMiscArray, sizeof(szMiscArray), "You have received %d Paintball Tokens from Admin %s.", amount, GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "Ban da cho %s %d Paintbll Tokens.", GetPlayerNameEx(giveplayerid), amount);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: %s da duoc cho %s, %d Paintball Tokens.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid),amount);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);

	}
	return 1;
}

CMD:savepbvehicle(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay.");
	if(!GetPVarType(playerid, "ArenaNumber")) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban chua chon mot phong nao tai Paintball.");
	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	new vehslot = GetPVarInt(playerid, "PBVeh");

	if(IsPlayerInAnyVehicle(playerid))
	{
		new Float: vPosX, Float: vPosY, Float: vPosZ, Float: vPosA, vID;
		vID = GetPlayerVehicleID(playerid);
		GetVehiclePos(vID, vPosX, vPosY, vPosZ);
		GetVehicleZAngle(vID, vPosA);
		switch(vehslot)
		{
			case 1:
			{
				PaintBallArena[arenaid][pbVeh1Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh1X] = vPosX;
				PaintBallArena[arenaid][pbVeh1Y] = vPosY;
				PaintBallArena[arenaid][pbVeh1Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh1A] = vPosA;
			}
			case 2:
			{
				PaintBallArena[arenaid][pbVeh2Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh2X] = vPosX;
				PaintBallArena[arenaid][pbVeh2Y] = vPosY;
				PaintBallArena[arenaid][pbVeh2Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh2A] = vPosA;
			}
			case 3:
			{
				PaintBallArena[arenaid][pbVeh3Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh3X] = vPosX;
				PaintBallArena[arenaid][pbVeh3Y] = vPosY;
				PaintBallArena[arenaid][pbVeh3Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh3A] = vPosA;
			}
			case 4:
			{
				PaintBallArena[arenaid][pbVeh4Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh4X] = vPosX;
				PaintBallArena[arenaid][pbVeh4Y] = vPosY;
				PaintBallArena[arenaid][pbVeh4Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh4A] = vPosA;
			}
			case 5:
			{
				PaintBallArena[arenaid][pbVeh5Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh5X] = vPosX;
				PaintBallArena[arenaid][pbVeh5Y] = vPosY;
				PaintBallArena[arenaid][pbVeh5Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh5A] = vPosA;
			}
			case 6:
			{
				PaintBallArena[arenaid][pbVeh6Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh6X] = vPosX;
				PaintBallArena[arenaid][pbVeh6Y] = vPosY;
				PaintBallArena[arenaid][pbVeh6Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh6A] = vPosA;
			}
		}
	}
	else
	{
		switch(vehslot)
		{
			case 1:
			{
				PaintBallArena[arenaid][pbVeh1Model] = 0;
				PaintBallArena[arenaid][pbVeh1X] = 0.0;
				PaintBallArena[arenaid][pbVeh1Y] = 0.0;
				PaintBallArena[arenaid][pbVeh1Z] = 0.0;
				PaintBallArena[arenaid][pbVeh1A] = 0.0;
			}
			case 2:
			{
				PaintBallArena[arenaid][pbVeh2Model] = 0;
				PaintBallArena[arenaid][pbVeh2X] = 0.0;
				PaintBallArena[arenaid][pbVeh2Y] = 0.0;
				PaintBallArena[arenaid][pbVeh2Z] = 0.0;
				PaintBallArena[arenaid][pbVeh2A] = 0.0;
			}
			case 3:
			{
				PaintBallArena[arenaid][pbVeh3Model] = 0;
				PaintBallArena[arenaid][pbVeh3X] = 0.0;
				PaintBallArena[arenaid][pbVeh3Y] = 0.0;
				PaintBallArena[arenaid][pbVeh3Z] = 0.0;
				PaintBallArena[arenaid][pbVeh3A] = 0.0;
			}
			case 4:
			{
				PaintBallArena[arenaid][pbVeh4Model] = 0;
				PaintBallArena[arenaid][pbVeh4X] = 0.0;
				PaintBallArena[arenaid][pbVeh4Y] = 0.0;
				PaintBallArena[arenaid][pbVeh4Z] = 0.0;
				PaintBallArena[arenaid][pbVeh4A] = 0.0;
			}
			case 5:
			{
				PaintBallArena[arenaid][pbVeh5Model] = 0;
				PaintBallArena[arenaid][pbVeh5X] = 0.0;
				PaintBallArena[arenaid][pbVeh5Y] = 0.0;
				PaintBallArena[arenaid][pbVeh5Z] = 0.0;
				PaintBallArena[arenaid][pbVeh5A] = 0.0;
			}
			case 6:
			{
				PaintBallArena[arenaid][pbVeh6Model] = 0;
				PaintBallArena[arenaid][pbVeh6X] = 0.0;
				PaintBallArena[arenaid][pbVeh6Y] = 0.0;
				PaintBallArena[arenaid][pbVeh6Z] = 0.0;
				PaintBallArena[arenaid][pbVeh6A] = 0.0;
			}
		}
	}
	format(szMiscArray, sizeof(szMiscArray), "You have adjusted War Vehicle %d for ArenaID %d.",vehslot, arenaid);
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	SavePaintballArena(arenaid);
	PaintballEditArenaMenu(playerid);
	return 1;
}
