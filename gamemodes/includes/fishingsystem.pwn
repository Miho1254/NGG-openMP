/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Fishing Job System

				GTA.Network, LLC
	(created by GTA.Network Development Team)

	* Copyright (c) 2014, GTA.Network, LLC
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

// WINTERFIELD: VERSION .278 FISHING SYSTEM

#include <YSI\y_hooks>

stock IsAtFishPlace(playerid)
{
	new 
		bool:result = false,
		Float:fish_place[][3] = {
			{403.7955,-2088.7966,7.8359},
			{398.7090,-2088.7983,7.8359},
			{396.1417,-2088.7983,7.8359},
			{391.0061,-2088.7971,7.8359},
			{383.4246,-2088.7961,7.8359},
			{374.9548,-2088.7979,7.8359},
			{369.8354,-2088.7939,7.8359},
			{367.1970,-2088.7976,7.8359},
			{362.2394,-2088.7976,7.8359},
			{354.4887,-2088.7979,7.8359},
			{349.9573,-2072.4832,7.8359},
			{349.9331,-2067.3711,7.8359},
			{349.9212,-2064.7942,7.8359},
			{349.8978,-2059.7051,7.8359},
			{349.8628,-2052.0896,7.8359},
			{852.5743,-2064.7422,12.8672},
			{852.5742,-2062.3479,12.8672},
			{852.5746,-2054.2219,12.8672},
			{852.5751,-2051.5710,12.8672},
			{852.5749,-2047.7660,12.8672},
			{852.5754,-2045.3475,12.8672},
			{820.3246,-2064.7949,12.8672},
			{820.3243,-2062.6396,12.8672},
			{820.3250,-2053.6323,12.8672},
			{820.3255,-2051.0129,12.8672},
			{820.3246,-2047.0043,12.8672},
			{820.3253,-2038.4801,12.8672},
			{820.3274,-2033.9192,12.8672},
			{820.3245,-2026.9894,12.8672},
			{820.3247,-2021.5862,12.8672},
			{-1657.9016,1337.0571,7.1780},
			{-1657.9078,1331.4241,7.1780},
			{-1655.2275,1325.5801,7.1826},
			{-1640.9749,1311.3789,7.1740},
			{-1630.1443,1300.5508,7.1797},
			{-1625.2032,1295.6105,7.1797}
		};

	for(new i = 0; i < sizeof(fish_place); i++) {
		if(IsPlayerInRangeOfPoint(playerid, 3.0, fish_place[i][0], fish_place[i][1], fish_place[i][2])) {
			result = true;
			break;
		}
	}
	return result;
}

hook OnPlayerEnterCheckpoint(playerid) {

    if(GetPVarInt(playerid, "pSellingFish"))
    {
        DisablePlayerCheckpoint(playerid);
        DeletePVar(playerid, "pSellingFish");
        SendClientMessageEx(playerid, COLOR_WHITE, "Hay dung lenh (/banca) de ban ca.");
    }
    return 1;
}

IncreaseFishingLevel(playerid) {
    
    if(PlayerInfo[playerid][pDoubleEXP] > 0)
    {
        PlayerInfo[playerid][pFishingSkill] += 2;
        format(szMiscArray, sizeof(szMiscArray), "Ban nhan duoc 2 fishing skill points thay vi 1. Ban co %d gio Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
        SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
        // PlayerInfo[playerid][pXP] += PlayerInfo[playerid][pLevel] * XP_RATE * 2;
    }
    else
    {
        PlayerInfo[playerid][pFishingSkill] += 1;
        // PlayerInfo[playerid][pXP] += PlayerInfo[playerid][pLevel] * XP_RATE;
    }
    return 1;
}

CMD:fishhelp(playerid, params[])
{
	SetPVarInt(playerid, "HelpResultCat0", 5);
	Help_ListCat(playerid, DIALOG_HELPCATOTHER1);
	return 1;
}

CMD:ofishhelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"___________________TRO GIUP CAU CA___________________");
    SendClientMessageEx(playerid, COLOR_GRAD3,"LENH: /cauca /cacuatoi /banca");
    return 1;
}

CMD:fish(playerid, params[]) {
    //if(PlayerInfo[playerid][pJob] == 70 || PlayerInfo[playerid][pJob2] == 70 || PlayerInfo[playerid][pJob3] == 70)
    {
		new vehicleid = GetPlayerVehicleID(playerid);
		new bool:canFish = false, surveh = GetPlayerSurfingVehicleID(playerid);
		if(vehicleid != INVALID_VEHICLE_ID && IsABoat(vehicleid)) {
			new Float:x, Float:y, Float:z;
			GetVehiclePos(vehicleid, x, y, z);
			if(IsPosInWater(x,y,z) ) canFish = true;
			else return SendClientMessage(playerid, -1, "Ban lai thuyen nhung khong o khu vuc bien, khong the cau ca");
		}

		if(surveh != INVALID_VEHICLE_ID && IsABoat(surveh)) {
			new Float:x, Float:y, Float:z;
			GetVehiclePos(surveh, x, y, z);
			if(IsPosInWater(x,y,z) ) canFish = true;
			else return SendClientMessage(playerid, -1, "Ban o tren thuyen nhung khong o khu vuc bien, khong the cau ca");
		}
		if(IsAtFishPlace(playerid)) canFish = true;
		else return SendClientMessage(playerid, -1, "Ban khong o diem cau ca");
		if(IsAtFishPlace(playerid) && vehicleid == INVALID_VEHICLE_ID && surveh == INVALID_VEHICLE_ID) canFish = true;
        if(canFish)
        {
            if(GetPVarInt(playerid, "lastCaptcha") < gettime()) {
				new 
					randomNumber = Random(100000, 999999);
				SetPVarInt(playerid, "FishingNumber", randomNumber);
				Dialog_Show(playerid, fishcaptcha, DIALOG_STYLE_INPUT, "Kiem tra AFK", "{FFFFFF}Vui long nhap so {FF0000}%d {FFFFFF}de tiep tuc cau ca", "Ok", "Huy bo", randomNumber);
			}
			else Fishing(playerid);
        }
		else SendClientMessage(playerid, COLOR_GRAD2, "Ban khong o diem cau ca hoac khong o tren thuyen");
    }
    //else SendClientMessageEx(playerid, COLOR_GRAD2, "  Ban khong phai nguoi cau ca!");
	return 1;
}
Dialog:fishcaptcha(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(strval(inputtext) == GetPVarInt(playerid, "FishingNumber")) {
			SetPVarInt(playerid, "lastCaptcha", gettime() + 60);
			Fishing(playerid);
		}
		else SendClientMessage(playerid, -1, "Ban da nhap sai ma kiem tra !");
	}
	DeletePVar(playerid, "FishingNumber");
}

stock Fishing(playerid) {
	if(PlayerInfo[playerid][pFishWeight] <= 500)
	{
		if(GetPVarInt(playerid, "pFishTime") < gettime())
		{
			switch(PlayerInfo[playerid][pFishingSkill])
			{
				case 0 .. 49:
				{
					switch(random(2))
					{
						case 0:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban khong bat duoc gi ca!");
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 1:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cau duoc 1 con ca Perch!");
							
							PlayerInfo[playerid][pFishWeight] += 5;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 2:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da cau duoc 1 con ca Carp!");
							
							PlayerInfo[playerid][pFishWeight] += 8;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
					}
				}
				case 50 .. 99:
				{
					switch(random(4))
					{
						case 0:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban khong cau duoc gi ca.");
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 1:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Perch!");

							PlayerInfo[playerid][pFishWeight] += 5;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 2:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Carp!");

							PlayerInfo[playerid][pFishWeight] += 8;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 3:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Snowfish!");

							PlayerInfo[playerid][pFishWeight] += 16;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 4:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Catfish!");

							PlayerInfo[playerid][pFishWeight] += 20;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
					}
				}
				case 100 .. 199:
				{
					switch(random(8))
					{
						case 0:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban khong cau duoc gi ca!");
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 1:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Perch!");

							PlayerInfo[playerid][pFishWeight] += 5;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 2:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Carp!");

							PlayerInfo[playerid][pFishWeight] += 8;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 3:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Snowfish!");

							PlayerInfo[playerid][pFishWeight] += 16;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 4:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Catfish!");

							PlayerInfo[playerid][pFishWeight] += 20;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 5:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Salmon!");

							PlayerInfo[playerid][pFishWeight] += 25;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 6:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Tuna!");

							PlayerInfo[playerid][pFishWeight] += 28;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 7:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Swordfish!");

							PlayerInfo[playerid][pFishWeight] += 35;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 8:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Stingray!");

							PlayerInfo[playerid][pFishWeight] += 39;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
					}
				}
				case 200 .. 399:
				{
					switch(random(11))
					{
						case 0:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban khong cau duoc gi ca!");
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 1:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Perch!");

							PlayerInfo[playerid][pFishWeight] += 5;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 2:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Carp!");

							PlayerInfo[playerid][pFishWeight] += 8;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 3:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Snowfish!");

							PlayerInfo[playerid][pFishWeight] += 16;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 4:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Catfish!");

							PlayerInfo[playerid][pFishWeight] += 20;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 5:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Salmon!");

							PlayerInfo[playerid][pFishWeight] += 25;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 6:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Tuna!");

							PlayerInfo[playerid][pFishWeight] += 28;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 7:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Swordfish!");

							PlayerInfo[playerid][pFishWeight] += 35;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 8:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Stingray!");

							PlayerInfo[playerid][pFishWeight] += 39;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 9:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Ariidae!");

							PlayerInfo[playerid][pFishWeight] += 46;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 10:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Tench!");

							PlayerInfo[playerid][pFishWeight] += 55;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 11:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Glassfish!");

							PlayerInfo[playerid][pFishWeight] += 60;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
					}
				}
				default:
				{
					switch(random(12))
					{
						case 0:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban khong cau duoc gi ca!");
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 1:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Perch!");

							PlayerInfo[playerid][pFishWeight] += 5;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 2:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Carp!");

							PlayerInfo[playerid][pFishWeight] += 8;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 3:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Snowfish!");

							PlayerInfo[playerid][pFishWeight] += 16;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 4:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Catfish!");

							PlayerInfo[playerid][pFishWeight] += 20;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 5:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Salmon!");

							PlayerInfo[playerid][pFishWeight] += 25;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 6:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Tuna!");

							PlayerInfo[playerid][pFishWeight] += 28;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 7:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Swordfish!");

							PlayerInfo[playerid][pFishWeight] += 35;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 8:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Stingray!");

							PlayerInfo[playerid][pFishWeight] += 39;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 9:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Ariidae!");

							PlayerInfo[playerid][pFishWeight] += 46;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 10:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Tench!");

							PlayerInfo[playerid][pFishWeight] += 55;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 11:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con ca Glassfish!");

							PlayerInfo[playerid][pFishWeight] += 60;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
						case 12:
						{
							format(szMiscArray, sizeof szMiscArray, "{FF8000}* {C2A2DA}%s da nem can cau va keo can.", GetPlayerNameEx(playerid));
							SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 30.0, 4000);
							SendClientMessageEx(playerid, COLOR_PURPLE, szMiscArray);

							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban cau duoc 1 con bach tuoc!");

							PlayerInfo[playerid][pFishWeight] += 60;
							
							SetPVarInt(playerid, "pFishTime", gettime() + 15);
							IncreaseFishingLevel(playerid);
						}
					}
				}
			}
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai doi 15 giay nua de tiep tuc!");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "So luong ca da dat gioi han, hay ban bot di.");
}
CMD:myfish(playerid, params[]) {

	format(szMiscArray, sizeof(szMiscArray), "So luong hien co: %d pound.", PlayerInfo[playerid][pFishWeight]);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	return 1;
}

CMD:sellfish(playerid, params[]) {

	new amount;
    if(GetPVarInt(playerid, "pFishSellTime") < gettime())
    {
        if(PlayerInfo[playerid][pFishWeight] < 500) return SendClientMessageEx(playerid, COLOR_GREY, "Ban can co 500 pound de ban.");
        if(IsPlayerInRangeOfPoint(playerid, 8.0, 1168.6654,-1489.6687,22.7568))
        {
        	if(sscanf(params, "d", amount))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /banca [so luong]");
				format(szMiscArray, sizeof szMiscArray, "So luong hien co: %d pound.", PlayerInfo[playerid][pFishWeight]);
				return SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			}
        
            if(amount < 500) return SendClientMessageEx(playerid, COLOR_GREY, "So luong khong duoc thap hon 500.");
        	if(PlayerInfo[playerid][pFishWeight] >= amount && PlayerInfo[playerid][pFishWeight] != 0)
       		{
   	    		new rand = random(100) + 100, money = amount * 40 + rand;
				PlayerInfo[playerid][pFishWeight] -= amount;
				GivePlayerCash(playerid, money);

                SetPVarInt(playerid, "pFishSellTime", gettime() + 120);
				
				format(szMiscArray, sizeof szMiscArray, "Ban da ban %d pound va nhan duoc $%s.", amount, number_format(money));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong so luong co do!");
		}
		else
		{
            if(CheckPointCheck(playerid)) callcmd::killcheckpoint(playerid, params);

		    GameTextForPlayer(playerid, "~g~DANH DAU DIA DIEM", 5000, 1);
            SetPVarInt(playerid, "pSellingFish", 1);
		    SetPlayerCheckpoint(playerid, 1168.6654,-1489.6687,22.7568, 5.0);
			return SendClientMessageEx(playerid, COLOR_YELLOW, "Den vi tri danh dau tren minimap de den diem ban ca.");
		}
    }
    else SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai doi 2 phut nua de tiep tuc ban ca!");
	return 1;
}
