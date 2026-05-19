/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				  Accept / Cancel Commands

				GTA.Network, LLC
	(created by GTA.Network Development Team)

	* Copyright (c) 2016, GTA.Network, LLCLLLL
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

CMD:accept(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	new szMessage[256];
	new string[128];
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new giveplayerid;
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay trong Hunger Games Event!");
    if(IsPlayerConnected(playerid)) {
        if(isnull(params)) {
            SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /chapnhan [Lua chon]");
			SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: Chet, Vukhi, Aogiap, Chetao, Suaxe, Doxang, Cuahang, Vatpham, Xe, Nha, Battay ");
            SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: Sex, Mats, Crack, Cannabis, Lawyer, Job, Live");
            SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: Firework, Group, Boxing, Medic, Mechanic, Ticket, Backpack");
            SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: Offer, Heroin, Rawopium, Syringes, Rimkit, Voucher, Kiss, RenderAid, Frisk");
            return 1;
        }
		if(strcmp(params, "door", true) == 0)
		{
			new target, fine, count;
			target = INVALID_PLAYER_ID;
			foreach(new i: Player)
			{
				if(gPlayerLogged{i} == 1 && DDSalePendingAdmin[i] == false && DDSalePendingPlayer[i] == true && DDSaleTarget[i] == playerid)
				{
					target = i;
					count ++;
					if(count > 1) break;
				}
			}
			if(target == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co yeu cau giao dich door.");
			if(count > 1)
			{
				foreach(new i : Player) if(gPlayerLogged{i} == 1 && DDSaleTarget[i] == playerid) ClearDoorSaleVariables(i);
				SendClientMessageEx(playerid, COLOR_GREY, "Da xay ra loi, vui long thuc hien lai giao dich cua ban.");
				return 1;
			}
			if(GetPlayerCash(playerid) < DDSalePrice[target])
			{
				format(string, sizeof(string), "Ban khong du tien cho giao dich nay ($%s).", number_format(DDSalePrice[target]));
				SendClientMessageEx(playerid, COLOR_GREY, string);
				return 1;
			}
			fine = CalculatePercentage(DDSalePrice[target], 10, 1000000);
			if(GetPlayerCash(target) < fine)
			{
				format(string, sizeof(string), "%s does not have the sufficient funds for the transfer fine ($%s).", GetPlayerNameEx(target), number_format(fine));
				SendClientMessageEx(playerid, COLOR_GREY, string);
				return 1;
			}
			stop DDSaleTimer[target];
			DDSalePendingAdmin[target] = true;
			DDSalePendingPlayer[target] = false;
			format(string, sizeof(string), "You have accepted %s's dynamic door sale offer for $%s.", GetPlayerNameEx(target), number_format(DDSalePrice[target]));
			SendClientMessageEx(playerid, COLOR_GREEN, string);
			SendClientMessageEx(playerid, COLOR_GREEN, "Server administration will now review the request before it is processed.");
			format(string, sizeof(string), "%s accepted your dynamic door sale offer for $%s.", GetPlayerNameEx(playerid), number_format(DDSalePrice[target]));
			SendClientMessageEx(target, COLOR_GREEN, string);
			SendClientMessageEx(target, COLOR_GREEN, "Server administration will now review the request before it is processed.");
			format(string, sizeof(string), "[New Dynamic Door Sale Request]: (ID: %d) %s.", target, GetPlayerNameEx(target));
			ABroadCast(COLOR_LIGHTRED, string, 4);
			return 1;
		}
		else if(strcmp(params, "renderaid", true) == 0)
		{
			if(!GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trang thai bi thuong.");
			if(!GetPVarType(playerid, "renderaid")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Khong co ai yeu cau ban giup do!");
			new target = GetPVarInt(playerid, "renderaid");
			if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi de nghi giup do ban khong truc tuyen.");
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			if(!IsPlayerInRangeOfPoint(target, 5.0, pos[0], pos[1], pos[2])) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o gan nguoi de nghi giup do ban.");
			if(GetPVarInt(target, "MedVestKit") != 1)
				return SendClientMessageEx(target, COLOR_GRAD2, "Ban khong mang theo hop cuu thuong."), SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi choi khong the ho tro ban vi ho khong co hop cuu thuong.");
			ApplyAnimation(target, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
			SetHealth(playerid, 100);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s renders aid to %s.", GetPlayerNameEx(target), GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			DeletePVar(playerid, "renderaid");
			DeletePVar(target, "MedVestKit");
		}
		else if(strcmp(params, "vukhi", true) == 0)
		{
			new id = GetPVarInt(playerid, "pSellGunID");
			if(!GetPVarType(playerid, "pSellGunID") || id == INVALID_PLAYER_ID || !IsPlayerConnected(id) || !gPlayerLogged{id}) {
				DeletePVar(playerid, "pSellGunID");
				return SendClientMessageEx(playerid, COLOR_GRAD2, "Khong co ai yeu cau ban vu khi cho ban!");
			} 

			if(PlayerInfo[id][pMats] < GetPVarInt(playerid, "pSellGunMats")) 
			{
				SendClientMessage(id, COLOR_WHITE, "Ban khong co khong du vat lieu de che tao vat pham nay!");
				return SendClientMessage(playerid, COLOR_WHITE, "Nguoi che tao vu khi nay hien khong du vat lieu de che tao vat pham nay!");
			}

			new weapon[16];
			GetWeaponName(GetPVarInt(playerid, "pSellGun"), weapon, sizeof(weapon));

			PlayerInfo[id][pMats] -= GetPVarInt(playerid, "pSellGunMats");
			GivePlayerValidWeapon(playerid, GetPVarInt(playerid, "pSellGun"));

  			if(PlayerInfo[id][pDoubleEXP] > 0)
			{
				SendClientMessageEx(id, COLOR_YELLOW, "Ban da dat 2 ky nang thay vi 1. Ban con %d gio nua de het han su dung Double EXP.", PlayerInfo[id][pDoubleEXP]);
   				PlayerInfo[id][pArmsSkill] += (GetPVarInt(playerid, "pSellGunXP")*2);
			}
			else
			{
  				PlayerInfo[id][pArmsSkill] += GetPVarInt(playerid, "pSellGunXP");
			}

			format(szMiscArray, sizeof(szMiscArray), "* %s da che tao %s tu Vat lieu va dua cho %s.", GetPlayerNameEx(id), weapon, GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it. -Winterfield
			PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);

			DeletePVar(playerid, "pSellGun");
			DeletePVar(playerid, "pSellGunID");
			DeletePVar(playerid, "pSellGunMats");
			DeletePVar(playerid, "pSellGunXP");
		}
        else if(strcmp(params, "valentine", true) == 0)
		{
	        if (!GetPVarType(playerid, "kissvaloffer")) {
       	 		return SendClientMessageEx(playerid, COLOR_GREY, "No one has offered you a valentine!");
			}
			if (GetPVarInt(playerid,"kissvalsqlid") != GetPlayerSQLId(GetPVarInt(playerid, "kissvaloffer"))) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
			}
			new Float: ppFloats[3], targetid;
			targetid = GetPVarInt(playerid, "kissvaloffer");
			GetPlayerPos(targetid, ppFloats[0], ppFloats[1], ppFloats[2]);

			if(!IsPlayerInRangeOfPoint(playerid, 2, ppFloats[0], ppFloats[1], ppFloats[2]) || Spectating[targetid] > 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You're too far away!");
				DeletePVar(playerid, "kissvaloffer");
	      		DeletePVar(playerid, "kissvalsqlid");
				DeletePVar(targetid, "kissvalstyle");
				return 1;
			}
			if(PlayerInfo[playerid][pGiftTime] > 0)
			{
				format(string, sizeof(string),"Vat pham: Reset thoi gian nhan qua\nCredit hien co: %s\nGia: {FFD700}%s{A9C4E4}\nCredit con lai: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
				ShowPlayerDialogEx( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Mua", "Thoat" );
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a gift in the last 5 hours!");
				SendClientMessageEx(targetid, COLOR_GRAD2, "Your requested valentine cannot accept.");
				DeletePVar(playerid, "kissvaloffer");
	      		DeletePVar(playerid, "kissvalsqlid");
				DeletePVar(targetid, "kissvalstyle");
				return 1;
			}
			else if(PlayerInfo[targetid][pGiftTime] > 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player has already received a gift in the last 5 hours!");
				DeletePVar(playerid, "kissvaloffer");
	      		DeletePVar(playerid, "kissvalsqlid");
				DeletePVar(targetid, "kissvalstyle");
				return 1;
			}
			ClearAnimationsEx(playerid);
			ClearAnimationsEx(targetid);
			PlayerFacePlayer( playerid, targetid );
			switch(GetPVarInt(targetid,"kissvalstyle")) {
				case 1:
				{
					ApplyAnimation( playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 2:
				{
					ApplyAnimation( playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 3:
				{
					ApplyAnimation( playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 4:
				{
					ApplyAnimation( playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 5:
				{
					ApplyAnimation( playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 6:
				{
					ApplyAnimation( playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
			format(string, sizeof(string), "* %s da duoc cho %s a kiss.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			GiftPlayer(MAX_PLAYERS, playerid);
			GiftPlayer(MAX_PLAYERS, targetid);
   			DeletePVar(playerid, "kissvaloffer");
      		DeletePVar(playerid, "kissvalsqlid");
			DeletePVar(targetid, "kissvalstyle");
   		}
		else if(strcmp(params, "cuahang", true) == 0)
		{
	        if (!GetPVarType(playerid, "Business_Inviter")) {
       	 		return SendClientMessageEx(playerid, COLOR_GREY, "Khong co loi de nghi nao moi ban vao cua hang!");
			}
			if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang lam cho mot cua hang khac va ban can nghi viec cua hang hien tai de vao lam cho mot cua hang khac.");
			}
			if (GetPVarInt(playerid,"Business_InviterSQLId") != GetPlayerSQLId(GetPVarInt(playerid, "Business_Inviter"))) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong ton tai.");
			}
			PlayerInfo[playerid][pBusiness] = GetPVarInt(playerid, "Business_Invited");
			PlayerInfo[playerid][pBusinessRank] = 0;
            format(string, sizeof(string), "* Da chap nhan loi de nghi tham gia cua hang %s, ban duoc moi boi %s.", Businesses[GetPVarInt(playerid, "Business_Invited")][bName], GetPlayerNameEx(GetPVarInt(playerid, "Business_Inviter")));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
            format(string, sizeof(string), "* %s da moi ban tham gia cua hang %s.", GetPlayerNameEx(playerid),Businesses[GetPVarInt(playerid, "Business_Invited")][bName]);
            SendClientMessageEx(GetPVarInt(playerid, "Business_Inviter"), COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "%s(%d) has accepted %s's(%d) invite to join %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(GetPVarInt(playerid, "Business_Inviter")), GetPlayerSQLId(GetPVarInt(playerid, "Business_Inviter")), Businesses[GetPVarInt(playerid, "Business_Invited")][bName]);
			Log("logs/business.log", string);
   			DeletePVar(playerid, "Business_Inviter");
      		DeletePVar(playerid, "Business_Invited");
   		}
        else if(strcmp(params, "gun", true) == 0)
		{
			if (!GetPVarType(playerid, "Business_WeapOfferer"))	{
		        return SendClientMessageEx(playerid, COLOR_GREY, "Khong ai cung cap cho ban mot vu khi nao ca!");
			}
		    new offerer = GetPVarInt(playerid, "Business_WeapOfferer"), business = PlayerInfo[offerer][pBusiness];
			if (GetPlayerSQLId(offerer) != GetPVarInt(playerid, "Business_WeapOffererSQLId")) {
   				return SendClientMessage(playerid, COLOR_GRAD2, "Nguoi ban hang da thoat game!");
			}
            if(!ProxDetectorS(5.0, playerid, offerer)) {
       	        SendClientMessageEx(playerid, COLOR_GREY, "Nguoi mua hang khong dung gan ban!");
       	        return 1;
            }
		    if(GetPVarType(playerid, "IsInArena")) {
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay o trong Paintball!");
				return 1;
			}
		    if (GetPlayerCash(playerid) < GetPVarInt(playerid, "Business_WeapPrice")) {
			    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du tien de mua vu khi!");
			    return 1;
		    }
		    if (Businesses[business][bInventory] < GetWeaponParam(GetPVarInt(playerid, "Business_WeapType"), WeaponMats)) {
				SendClientMessage(playerid, COLOR_GRAD2, "Cua hang nay da het mat hang, hay quay lai sau!");
				return 1;
		    }
			if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) {
   				SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay luc nay!");
   				return 1;
			}

		    Businesses[business][bTotalSales]++;
		    Businesses[business][bLevelProgress]++;
		    Businesses[business][bSafeBalance] += TaxSale(GetPVarInt(playerid, "Business_WeapPrice"));
  			GivePlayerCash(playerid, -GetPVarInt(playerid, "Business_WeapPrice"));
		    Businesses[business][bInventory] -= GetWeaponParam(GetPVarInt(playerid, "Business_WeapType"), WeaponMats);
		    SaveBusiness(business);

            format(string, sizeof(string), "Ban dan ban cho %s khau sung %s.", GetPlayerNameEx(playerid),Weapon_ReturnName(GetPVarInt(playerid, "Business_WeapType")));
            SendClientMessageEx(offerer, COLOR_GRAD1, string);
            format(string, sizeof(string), "Ban da nhan duoc mot %s tu %s.", Weapon_ReturnName(GetPVarInt(playerid, "Business_WeapType")), GetPlayerNameEx(offerer));
            SendClientMessageEx(playerid, COLOR_GRAD1, string);
            PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
            PlayerPlaySound(offerer, 1052, 0.0, 0.0, 0.0);
            format(string, sizeof(string), "* %s da che tao vu khi tu vat lieu va dua cho %s.", GetPlayerNameEx(offerer), GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            GivePlayerValidWeapon(playerid,GetPVarInt(playerid, "Business_WeapType"));

			format(string, sizeof(string), "%s %s(%d) (IP: %s) has sold a %s to %s(%d) (IP: %s) for $%d in %s (%d)", GetBusinessRankName(PlayerInfo[offerer][pBusinessRank]), GetPlayerNameEx(offerer), GetPlayerSQLId(offerer), GetPlayerIpEx(offerer), Weapon_ReturnName(GetPVarInt(playerid, "Business_WeapType")), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "Business_WeapPrice"), Businesses[business][bName], business);
			Log("logs/business.log", string);

  		    DeletePVar(playerid, "Business_WeapPrice");
		    DeletePVar(playerid, "Business_WeapType");
		    DeletePVar(playerid, "Business_WeapOfferer");
		    DeletePVar(playerid, "Business_WeapOffererSQLId");
		}

        else if(strcmp(params, "vatpham", true) == 0) {

			if (!GetPVarType(playerid, "Business_ItemOfferer")) {
		        SendClientMessageEx(playerid, COLOR_GREY, "No one has offered you a item!");
		        return 1;
			}

		    new offerer = GetPVarInt(playerid, "Business_ItemOfferer");
		    new item = GetPVarInt(playerid, "Business_ItemType");
		    new price = GetPVarInt(playerid, "Business_ItemPrice");
			new business = InBusiness(playerid);

			if (business == INVALID_BUSINESS_ID)
			{
				SendClientMessage(playerid, COLOR_GRAD2, "Ban khong dung tai cua hang cua ban!");
   				return 1;
			}
			if (GetPlayerSQLId(offerer) != GetPVarInt(playerid, "Business_ItemOffererSQLId")) {
   				SendClientMessage(playerid, COLOR_GRAD2, "Nguoi ban hang da ngat ket noi!");
   				return 1;
			}
		    if (GetPlayerCash(playerid) < price) {
			    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du tien de mua mat hang nay!");
			    return 1;
		    }
			if (!Businesses[business][bItemPrices][item]) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Mat hang nay khong con de ban nua.");
			    return 1;
			}
		 	if (Businesses[business][bInventory] < 1) {
	   	 		SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang nay da het toan bo mat hang!");
	   	 		return 1;
			}
			if (GetPVarInt(playerid, "Business_ItemPrice") != Businesses[business][bItemPrices][item]) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Mua vat pham that bai, vi vat pham nay vua duoc chinh sua gia.");
			    return 1;
			}

			if(item == ITEM_ILOCK || item == ITEM_SCALARM || item == ITEM_ELOCK)
   			{
      			if(Businesses[business][bInventory] >= StoreItemCost[item][ItemValue])
	        	{

					SetPVarInt(playerid, "lockcost", price);
     				SetPVarInt(playerid, "businessid", business);
	        		SetPVarInt(playerid, "item", item);
		        	SetPVarInt(playerid, "playersold", item);
			        GivePlayerStoreItem(playerid, 1, business, item+1, price);
				}
				else return SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang khong du hang cho vat pham nay!");
    		}
  			else GivePlayerStoreItem(playerid, 1, business, item+1, price);
		}


        else if(strcmp(params, "vehicle", true) == 0) {

		    new offerer = GetPVarInt(playerid, "Business_VehicleOfferer");
		    new price = GetPVarInt(playerid, "Business_VehiclePrice");
		    new slot = GetPVarInt(playerid, "Business_VehicleSlot");
		    new businessid = PlayerInfo[offerer][pBusiness];

			if (!GetPVarType(playerid, "Business_VehicleOfferer")) {
		        SendClientMessageEx(playerid, COLOR_GREY, "No one has offered you chiec xe!");
		        return 1;
			}

			if (GetPlayerSQLId(offerer) != GetPVarInt(playerid, "Business_VehicleOffererSQLId")) {
   				SendClientMessage(playerid, COLOR_GRAD2, "The offerer has disconnected!");
   				return 1;
			}
		    if (GetPlayerCash(playerid) < price) {
			    SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the vehicle!");
			    return 1;
		    }

            new playervehicleid = GetPlayerFreeVehicleId(playerid);

			if(!vehicleCountCheck(playerid)) {
				return SendClientMessage(playerid, COLOR_GRAD2, "You can't own any more vehicles.");
			}
			if(!vehicleSpawnCountCheck(playerid)) {
				return SendClientMessage(playerid, COLOR_GRAD2, "You have too many vehicles spawned - store one first.");
			}
            PlayerVehicleInfo[playerid][playervehicleid][pvId] = Businesses[businessid][bVehID][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = Businesses[businessid][bModel][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = Businesses[businessid][bParkPosX][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = Businesses[businessid][bParkPosY][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = Businesses[businessid][bParkPosZ][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = Businesses[businessid][bParkAngle][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
            Businesses[businessid][DealershipVehStock][slot] = 0;
            VehicleSpawned[playerid]++;

		    g_mysql_SaveVehicle(playerid, playervehicleid);

    		Businesses[businessid][bSafeBalance] += TaxSale(GetPVarInt(playerid, "Business_ItemPrice"));
			GivePlayerCash(playerid, -GetPVarInt(playerid, "Business_VehiclePrice"));
			if (PlayerInfo[playerid][pBusiness] != PlayerInfo[offerer][pBusiness]) Businesses[businessid][bLevelProgress]++;
			SaveBusiness(businessid);
			OnPlayerStatsUpdate(playerid);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			DeletePVar(playerid, "Business_VehiclePrice");
			DeletePVar(playerid, "Business_VehicleOfferer");
			DeletePVar(playerid, "Business_VehicleOffererSQLId");
			DeletePVar(playerid, "Business_VehicleSlot");
        }
        else if(strcmp(params, "chet", true) == 0) {
            if(GetPVarInt(playerid, "Injured") == 1) {

            	if(GetPVarInt(playerid, "InjuredWait") > gettime())
            		return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the tu bo bay gio, vui long cho doi.");

                SendClientMessageEx(playerid, COLOR_WHITE, "Ban da chet va cam thay bi thuong nang, da duoc lap tuc dua den benh vien.");
                KillEMSQueue(playerid);
                ResetPlayerWeaponsEx(playerid);
                SpawnPlayer(playerid);
            }
            else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong bi thuong, ban khong the lam dieu nay ngay luc nay!");
        }
        else if(strcmp(params, "xe", true) == 0) {
            if(VehicleOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(VehicleOffer[playerid])) {
                    if(GetPlayerCash(playerid) > VehiclePrice[playerid]) {
                        if(IsPlayerInVehicle(VehicleOffer[playerid], PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId])) {
                            if(!ProxDetectorS(8.0, VehicleOffer[playerid], playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan the car dealer");
                            new playervehicleid = GetPlayerFreeVehicleId(playerid);

			 				if(!vehicleCountCheck(playerid)) {
								return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the so huu them xe.");
							}
   							if(!vehicleSpawnCountCheck(playerid)) {
								return SendClientMessage(playerid, COLOR_GRAD2, "Ban co nhieu xe dem ra ngoai, vui long cat bot .");
							}
							if(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvBeingPickLocked])
								return SendClientMessage(playerid, COLOR_GRAD2, "Co loi xay ra khi dang giao dich xe.");

                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(VehicleOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "[CAR] %s(%d) (IP: %s) da tra $%s to %s(%d) for the %s (IP: %s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(VehiclePrice[playerid]), GetPlayerNameEx(VehicleOffer[playerid]), GetPlayerSQLId(VehicleOffer[playerid]), GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), ipex);
                            Log("logs/pay.log", szMessage);

                            format(szMiscArray, sizeof(szMiscArray), "{AA3333}GTN-Warning{FFFF00}: (Ban xe) %s(ID: %d) da mua phuong tien %s ($%s) tu %s (ID: %d).", GetPlayerNameEx(playerid), playerid, GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), number_format(VehiclePrice[playerid]), GetPlayerNameEx(VehicleOffer[playerid]), VehicleOffer[playerid]);
                            ABroadCast(COLOR_YELLOW, szMiscArray, 2);

                            GetPlayerName(VehicleOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* Ban da mua %s voi gia $%s, tu %s. (Su dung /tgxe de xem cac lenh lien quan)", GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), number_format(VehiclePrice[playerid]), giveplayer);
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* Ban da ban %s cho %s voi gia $%s.",GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), sendername, number_format(VehiclePrice[playerid]));
                            SendClientMessageEx(VehicleOffer[playerid], COLOR_LIGHTBLUE, szMessage);
							GivePlayerCashEx(playerid, TYPE_ONHAND, -VehiclePrice[playerid]);

							if(IsWeaponizedVehicle(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvModelId]))
							{
								new fine = GetPVarInt(VehicleOffer[playerid], "WepVehSaleFine");
								GivePlayerCashEx(VehicleOffer[playerid], TYPE_ONHAND, VehiclePrice[playerid] - fine);

								format(szMessage, sizeof(szMessage), "* Ban da bi tru tien %s cho cuoc giao dich nay", number_format(fine));
                            	SendClientMessageEx(VehicleOffer[playerid], COLOR_LIGHTBLUE, szMessage);

								DeletePVar(VehicleOffer[playerid], "WepVehSalePlayer");
								DeletePVar(VehicleOffer[playerid], "WepVehSaleVehicle");
								DeletePVar(VehicleOffer[playerid], "WepVehSalePrice");
								DeletePVar(VehicleOffer[playerid], "WepVehSaleFine");
							}
							else GivePlayerCashEx(VehicleOffer[playerid], TYPE_ONHAND, VehiclePrice[playerid]);

                            /*GivePlayerCash( VehicleOffer[playerid], VehiclePrice[playerid] );
                            GivePlayerCash(playerid, -VehiclePrice[playerid]);*/
                            RemovePlayerFromVehicle(VehicleOffer[playerid]);
                            new Float:slx, Float:sly, Float:slz;
                            GetPlayerPos(VehicleOffer[playerid], slx, sly, slz);
                            SetPlayerPos(VehicleOffer[playerid], slx, sly, slz+2);
							if(PlayerInfo[VehicleOffer[playerid]][pBackpack] > 0 && PlayerInfo[VehicleOffer[playerid]][pBStoredV] == PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSlotId])
							{
								PlayerInfo[VehicleOffer[playerid]][pBackpack] = 0;
								PlayerInfo[VehicleOffer[playerid]][pBEquipped] = 0;
								PlayerInfo[VehicleOffer[playerid]][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
								PlayerInfo[VehicleOffer[playerid]][pBStoredH] = INVALID_HOUSE_ID;
								SendClientMessageEx(VehicleOffer[playerid], COLOR_WHITE, "Ban da bi mat ba lo vi ban khong rut no ra");

							}
                            PlayerVehicleInfo[playerid][playervehicleid][pvId] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId];
                            PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvModelId];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosX];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosY];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosZ];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosAngle];
                            PlayerVehicleInfo[playerid][playervehicleid][pvLock] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLock];
                            PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocked];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPaintJob];
                            PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor1];
                            PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor2];
                            PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAllowedPlayerId];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPark] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPark];
                            PlayerVehicleInfo[playerid][playervehicleid][pvVW] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvVW];
                            PlayerVehicleInfo[playerid][playervehicleid][pvInt] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvInt];
							PlayerVehicleInfo[playerid][playervehicleid][pvAlarm] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAlarm];
							PlayerVehicleInfo[playerid][playervehicleid][pvLocksLeft] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocksLeft];
							PlayerVehicleInfo[playerid][playervehicleid][pvFull] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvFull];
							PlayerVehicleInfo[playerid][playervehicleid][pvHealthcar] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvHealthcar];
							PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][0] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][1] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][2] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
                            PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
							PlayerVehicleInfo[playerid][playervehicleid][pvAlarmTriggered] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLocked] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvLastLockPickedBy] = 0;
                            VehicleSpawned[playerid]++;
                            for(new m = 0; m < MAX_MODS; m++) {
                                PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvMods][m];
                            }

        					mysql_format(MainPipeline, szMessage, sizeof(szMessage), "INSERT INTO `vehicles` (`sqlID`) VALUES ('%d')", GetPlayerSQLId(playerid));
							mysql_tquery(MainPipeline, szMessage, "OnQueryCreateVehicle", "ii", playerid, playervehicleid);

							mysql_format(MainPipeline, szMessage, sizeof(szMessage), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSlotId]);
							mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, VehicleOffer[playerid]);

							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSlotId] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvModelId] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosX] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosY] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosZ] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosAngle] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLock] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocksLeft] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocked] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPaintJob] = -1;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor1] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvImpounded] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor2] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAllowedPlayerId] = INVALID_PLAYER_ID;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPark] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSpawned] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvVW] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvInt] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvWeapons][0] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvWeapons][1] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvWeapons][2] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPlate] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvTicket] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAlarm] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAlarmTriggered] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvBeingPickLocked] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLastLockPickedBy] = 0;
                            VehicleSpawned[VehicleOffer[playerid]]--;
                            for(new m = 0; m < MAX_MODS; m++) {
                                PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvMods][m] = 0;
                            }

                            VehicleOffer[playerid] = INVALID_PLAYER_ID;
                            VehiclePrice[playerid] = 0;
                            return 1;
                        }
                        else {
                            SendClientMessageEx(playerid, COLOR_GREY, "The Car Dealer is not in the offered car!");
                            return 1;
                        }
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien de mua chiec xe nay!");
                        return 1;
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai de nghi ban mua xe ca!");
                return 1;
            }
        }
        else if(strcmp(params, "nha", true) == 0)
		{
            if(HouseOffer[playerid] != INVALID_PLAYER_ID)
			{
                if(IsPlayerConnected(HouseOffer[playerid]))
				{
                    if(HouseInfo[House[playerid]][hOwnerID] != GetPlayerSQLId(HouseOffer[playerid])) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu ngoi nha do!");
					if(House[playerid] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_RED, "LOI: Khong co nha duoc chi dinh.");
                    if(GetPlayerCash(playerid) > HousePrice[playerid])
					{
						if(PlayerInfo[HouseOffer[playerid]][pBackpack] > 0 && PlayerInfo[HouseOffer[playerid]][pBStoredH] == HouseInfo[House[playerid]][hSQLId])
						{
							PlayerInfo[HouseOffer[playerid]][pBackpack] = 0;
							PlayerInfo[HouseOffer[playerid]][pBEquipped] = 0;
							PlayerInfo[HouseOffer[playerid]][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
							PlayerInfo[HouseOffer[playerid]][pBStoredH] = INVALID_HOUSE_ID;
							SendClientMessageEx(HouseOffer[playerid], COLOR_WHITE, "You have lost your backpack since you did not withdraw it");
						}
                        ClearHouse(House[playerid]);
                        HouseInfo[House[playerid]][hLock] = 1;
                        format(HouseInfo[House[playerid]][hOwnerName], 128, "Nobody");
						HouseInfo[House[playerid]][hOwnerID] = -1;
                        sendername = GetPlayerNameEx(HouseOffer[playerid]);
                        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                        format(szMessage, sizeof(szMessage), "~w~Congratulations~n~ You have sold your property for ~n~~g~$%d", HousePrice[playerid]);
                        GameTextForPlayer(HouseOffer[playerid], szMessage, 4000, 3);
                        if(House[playerid] == PlayerInfo[HouseOffer[playerid]][pPhousekey])
						{
							PlayerInfo[HouseOffer[playerid]][pPhousekey] = INVALID_HOUSE_ID;
							PlayerInfo[playerid][pPhousekey] = House[playerid];
						}
                        else if(House[playerid] == PlayerInfo[HouseOffer[playerid]][pPhousekey2])
						{
							PlayerInfo[HouseOffer[playerid]][pPhousekey2] = INVALID_HOUSE_ID;
							PlayerInfo[playerid][pPhousekey2] = House[playerid];
						}
						else if(House[playerid] == PlayerInfo[HouseOffer[playerid]][pPhousekey3])
						{
							PlayerInfo[HouseOffer[playerid]][pPhousekey3] = INVALID_HOUSE_ID;
							PlayerInfo[playerid][pPhousekey3] = House[playerid];
						}
						Homes[HouseOffer[playerid]]--;
						Homes[playerid]++;
                        GivePlayerCash(HouseOffer[playerid],HousePrice[playerid]);
						OnPlayerStatsUpdate(HouseOffer[playerid]);

						HouseInfo[House[playerid]][hOwnerID] = GetPlayerSQLId(playerid);
                        HouseInfo[House[playerid]][hOwned] = 1;
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        strmid(HouseInfo[House[playerid]][hOwnerName], sendername, 0, strlen(sendername), 255);
                        GivePlayerCash(playerid,-HousePrice[playerid]);
                        SendClientMessageEx(playerid, COLOR_WHITE, "Chuc mung, ban da mua mot can nha moi!");
                        SendClientMessageEx(playerid, COLOR_WHITE, "Su dung /tgnha de xem cac lenh lien quan!");
                        SaveHouse(House[playerid]);
                        OnPlayerStatsUpdate(playerid);
						ReloadHouseText(House[playerid]);

                        new ip[32], ipex[32];
                        GetPlayerIp(HouseOffer[playerid], ip, sizeof(ip));
                        GetPlayerIp(playerid, ipex, sizeof(ipex));
                        format(szMessage,sizeof(szMessage),"%s(%d) (IP: %s) has sold their house (ID %d) to %s(%d) (IP: %s) for $%s.", GetPlayerNameEx(HouseOffer[playerid]), GetPlayerSQLId(HouseOffer[playerid]), ip, House[playerid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipex, number_format(HousePrice[playerid]));
                        Log("logs/house.log", szMessage);

                        HouseOffer[playerid] = INVALID_PLAYER_ID;
                        HousePrice[playerid] = 0;
                        House[playerid] = INVALID_HOUSE_ID;
						return 1;
                    }
                    else
					{
                        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du tien de mua ngoi nha nay!");
                        HouseOffer[playerid] = INVALID_PLAYER_ID;
                        HousePrice[playerid] = 0;
                        House[playerid] = INVALID_HOUSE_ID;
                        return 1;
                    }
                }
				else return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi mua da thoat game!");
            }
            else return SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai de nghi ban mua nha ca!");
        }
        else if(strcmp(params, "battay", true) == 0) {
            new
                Count;

            foreach(new i: Player)
			{
				if(GetPVarType(i, "shrequest") && GetPVarInt(i, "shrequest") == playerid) {
					new
						Float: ppFloats[3];

					GetPlayerPos(i, ppFloats[0], ppFloats[1], ppFloats[2]);

					if(!IsPlayerInRangeOfPoint(playerid, 5, ppFloats[0], ppFloats[1], ppFloats[2]) || Spectating[i] > 0) {
						Count++;
						SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong o gan nguoi do de bat tay.");
					}
					else {
						switch(GetPVarInt(i, "shstyle")) {
							case 1:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkaa", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkaa", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 2:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkba", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkba", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 3:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 4:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkcb", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 5:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkda", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 6:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS","hndshkfa_swt", 4.0, 1, 1, 1, 0, 2600 );
								ApplyAnimation( i, "GANGS","hndshkfa_swt", 4.0, 1, 1, 1, 0, 2600 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 7:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "prtial_hndshk_01", 4.0, 1, 1, 1, 0, 1250 );
								ApplyAnimation( i, "GANGS", "prtial_hndshk_01", 4.0, 1, 1, 1, 0, 1250 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 8:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "prtial_hndshk_biz_01", 3.7, 1, 1, 1, 0, 2200 );
								ApplyAnimation( i, "GANGS", "prtial_hndshk_biz_01", 3.5, 1, 1, 1, 0, 2200 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s da bat tay voi %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
						}
					}
				}
            }
            if(Count == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co ai de nghi bat tay ca.");
            return 1;
        }
		else if(strcmp(params, "rflteam",true) == 0) {
			if(!GetPVarType(playerid, "RFLTeam_Invite")) return SendClientMessageEx(playerid, COLOR_GREY, "Khong ai de nghi ban tham gia Teams.");
			new team = GetPVarInt(playerid, "RFLTeam_Team");
			giveplayerid = GetPVarInt(playerid, "RFLTeam_Inviter");
			DeletePVar(playerid, "RFLTeam_Invite");
			DeletePVar(playerid, "RFLTeam_Team");
			DeletePVar(playerid, "RFLTeam_Inviter");
			PlayerInfo[playerid][pRFLTeam] = team;
			RFLInfo[team][RFLmembers] +=1;
			format(szMessage, sizeof(szMessage), "* You are now part of %s's team. Bay gio ban co theuse /rflhelp.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
			format(szMessage, sizeof(szMessage), "* %s da chap nhan loi moi cua ban.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMessage);
			if( GetPVarInt( playerid, "EventToken" ) == 1 ) {
				if( EventKernel[ EventStatus ] == 1 || EventKernel[ EventStatus ] == 2 ) {
					if(EventKernel[EventType] == 3) {
						new Float:X, Float:Y, Float:Z;
						GetPlayerPos( playerid, X, Y, Z );
						format(szMessage, sizeof(szMessage), "Team: %s", RFLInfo[team][RFLname]);
						RFLTeamN3D[playerid] = CreateDynamic3DTextLabel(szMessage,0x008080FF,X,Y,Z,10.0,.attachedplayer = playerid, .worldid = GetPlayerVirtualWorld(playerid));
					}
				}
			}
			OnPlayerStatsUpdate(playerid);
			SaveRelayForLifeTeam(team);
		}
        else if(strcmp(params, "invite", true) == 0)
		{
            if(hInviteOffer[playerid] != INVALID_PLAYER_ID)
			{
                if(IsPlayerConnected(hInviteOffer[playerid]))
				{
	                if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Hay chac rang diem danh dau mau do cua ban phai bi xoa (Neu muon xoa diem danh dau nay , hay go /xoamuctieu).");
                    format(szMessage, sizeof(szMessage), "* Ban da chap nhan loi moi ve nha cua %s, di theo diem danh dau tren ban do de den can nha do.", GetPlayerNameEx(hInviteOffer[playerid]));
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* %s da chap nhan loi moi ve nha cua ban.", GetPlayerNameEx(playerid));
                    SendClientMessageEx(hInviteOffer[playerid], COLOR_LIGHTBLUE, szMessage);
					DisablePlayerCheckpoint(playerid);
                    SetPlayerCheckpoint(playerid, HouseInfo[hInviteHouse[playerid]][hExteriorX], HouseInfo[hInviteHouse[playerid]][hExteriorY], HouseInfo[hInviteHouse[playerid]][hExteriorZ], 4.0);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOME;
					SetPVarInt(playerid, "hInviteHouse", hInviteHouse[playerid]);
                    hInviteOffer[playerid] = INVALID_PLAYER_ID;
					hInviteHouse[playerid] = INVALID_HOUSE_ID;
                    return 1;
                }
                else
				{
                    hInviteOffer[playerid] = INVALID_PLAYER_ID;
                    hInviteHouse[playerid] = INVALID_HOUSE_ID;
                    SendClientMessageEx(playerid, COLOR_GREY, "Nguoi gui de nghi cho ban da thoat game.");
                }
            }
            else return SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai moi ban ve nha ca.");
            return 1;
        }
        /*else if(strcmp(params, "divorce", true) == 0) {
            if(DivorceOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(DivorceOffer[playerid])) {
                    if(ProxDetectorS(10.0, playerid, DivorceOffer[playerid])) {
                        GetPlayerName(DivorceOffer[playerid], giveplayer, sizeof(giveplayer));
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        format(szMessage, sizeof(szMessage), "* You have signed the divorce papers from %s, you are now single again.", giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        format(szMessage, sizeof(szMessage), "* %s has signed the divorce papers, you are now single again.", sendername);
                        SendClientMessageEx(DivorceOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                        ClearMarriage(playerid);
                        ClearMarriage(DivorceOffer[playerid]);
                        PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "   The person that sent you the Divorce Papers is not near you!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Nobody sent you any divorce papers.");
                return 1;
            }
        }*/
        else if(strcmp(params, "group", true) == 0) {
            if(GetPVarType(playerid, "Group_Inviter")) {

    			new
					iInviter = GetPVarInt(playerid, "Group_Inviter"),
					iGroupID = PlayerInfo[iInviter][pLeader],
					iRank = PlayerInfo[iInviter][pRank];

				if (PlayerInfo[playerid][pCSFBanned]) {
					if (arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC)	{
						SendClientMessageEx(playerid, COLOR_WHITE, "You are unable to accept this group invite, as you're banned from civil service groups. Contact a member of DGA.");
						DeletePVar(playerid, "Group_Invite");
						DeletePVar(iInviter, "Group_Invited");
						return 1;
					}
				}

                if(IsPlayerConnected(iInviter) && GetPVarInt(iInviter, "Group_Invited") == playerid && 0 <= iGroupID < MAX_GROUPS) {
					PlayerInfo[playerid][pMember] = iGroupID;
					PlayerInfo[playerid][pRank] = 0;
					PlayerInfo[playerid][pDivision] = INVALID_DIVISION;
					strcpy(PlayerInfo[playerid][pBadge], "None", 9);
					arrGroupData[iGroupID][g_iMemberCount]++;

					format(szMessage, sizeof szMessage, "Ban da chap nhan loi moi tham gia nhom  boi %s %s, bay gio ban la thanh vien cua %s.", arrGroupRanks[iGroupID][iRank], GetPlayerNameEx(iInviter), arrGroupData[iGroupID][g_szGroupName]);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

					format(szMessage, sizeof szMessage, "%s da chap nhan loi moi tham gia group.", GetPlayerNameEx(playerid));
					SendClientMessageEx(iInviter, COLOR_LIGHTBLUE, szMessage);

					format(szMessage, sizeof szMessage, "%s (%d) accepted %s %s's (%d) invite to join %s (%d).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), arrGroupRanks[iGroupID][iRank], GetPlayerNameEx(iInviter), GetPlayerSQLId(iInviter), arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
					GroupLog(iGroupID, szMessage);

					DeletePVar(playerid, "Group_Invite");
					DeletePVar(iInviter, "Group_Invited");
                }
				else SendClientMessageEx(playerid, COLOR_GREY, "Nguoi moi ban tham gia group da thoat game.");
            }
            else SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai moi ban tham gia nao group ca.");
        }
        else if(strcmp(params, "witness", true) == 0) {
            if(MarryWitnessOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(MarryWitnessOffer[playerid])) {
                    if(ProxDetectorS(10.0, playerid, MarryWitnessOffer[playerid])) {
                        GetPlayerName(MarryWitnessOffer[playerid], giveplayer, sizeof(giveplayer));
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        format(szMessage, sizeof(szMessage), "Ban da chap nhan  %s", giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        format(szMessage, sizeof(szMessage), "%s da chap nhan lam chung cho cuoc hon nhan.", sendername);
                        SendClientMessageEx(MarryWitnessOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                        MarryWitness[MarryWitnessOffer[playerid]] = playerid;
                        MarryWitnessOffer[playerid] = INVALID_PLAYER_ID;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "Nguoi yeu cau ban ban lam chung cuoc hon nhan cua ho khong o gan ban!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong ai yeu cau ban lam chung cuoc hon nhan nao ca!");
                return 1;
            }
        }
        else if(strcmp(params, "marriage", true) == 0) {
            if(ProposeOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(ProposeOffer[playerid])) {
                    if(ProxDetectorS(10.0, playerid, ProposeOffer[playerid])) {
                        if(MarryWitness[ProposeOffer[playerid]] == INVALID_PLAYER_ID) {
                            SendClientMessageEx(playerid, COLOR_GREY, "Nguoi cau hon ban khong co nguoi lam chung cuoc hon nhan!");
                            return 1;
                        }
                        if(IsPlayerConnected(MarryWitness[ProposeOffer[playerid]])) {
                            if(ProxDetectorS(12.0, ProposeOffer[playerid], MarryWitness[ProposeOffer[playerid]])) {
                                if(IsPlayerInRangeOfPoint(playerid, 10.0, 1963.9612, -369.1851, 1093.7289)) {
                                    GetPlayerName(ProposeOffer[playerid], giveplayer, sizeof(giveplayer));
                                    GetPlayerName(playerid, sendername, sizeof(sendername));
                                    format(szMessage, sizeof(szMessage), "* You have accepted %s's request to be your husband.", giveplayer);
                                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                                    format(szMessage, sizeof(szMessage), "* %s has accepted your request to be your wife.", sendername);
                                    SendClientMessageEx(ProposeOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                                    format(szMessage, sizeof(szMessage), "Priest: %s, do you take %s as your lovely husband? (Type 'yes', as anything else will reject the marriage.)", sendername, giveplayer);
                                    SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
                                    MarriageCeremoney[playerid] = 1;
									if(GetPVarInt(ProposeOffer[playerid], "marriagelastname") == 1)
									{
										ShowPlayerDialogEx(playerid, DIALOG_MARRIAGE, DIALOG_STYLE_MSGBOX, "Marriage Last Name",
										"As your spouse decided to keep their last name you have the option to keep your last name or use your spouse's.\n\
										Please use the buttons below to make your decision.", "Keep", "Use Their's");
									}
									if(GetPVarInt(ProposeOffer[playerid], "marriagelastname") == 2)
									{
										SendClientMessageEx(playerid, -1, "Your spouse decided to use your last name.");
									}
                                    ProposedTo[ProposeOffer[playerid]] = playerid;
                                    GotProposedBy[playerid] = ProposeOffer[playerid];
                                    MarryWitness[ProposeOffer[playerid]] = INVALID_PLAYER_ID;
                                    ProposeOffer[playerid] = INVALID_PLAYER_ID;
                                    return 1;
                                }
                                else {
                                    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai the church!");
                                    return 1;
                                }
                            }
                            else {
                                SendClientMessageEx(playerid, COLOR_GREY, "The marriage witness is not near your proposer!");
                                return 1;
                            }
                        }
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "Nguoi cau hon ban khong o gan ban!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong ai cau hon ban ca!");
                return 1;
            }
        }
        else if(strcmp(params, "ticket", true) == 0) {
            if(TicketOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(TicketOffer[playerid])) {
                    if (ProxDetectorS(5.0, playerid, TicketOffer[playerid])) {
                        if(GetPlayerCash(playerid) >= TicketMoney[playerid]) {
                            //new ip[32], ipex[32];
                            //GetPlayerIp(playerid, ip, sizeof(ip));
                            //GetPlayerIp(TicketOffer[playerid], ipex, sizeof(ipex));
                            //format(szMessage, sizeof(szMessage), "[FACTION TICKET] %s (IP: %s) has paid $%d to %s (IP: %s)", GetPlayerNameEx(playerid), ip, TicketMoney[playerid], GetPlayerNameEx(TicketOffer[playerid]), ipex);
                            // Log("logs/pay.log", szMessage);
                            format(szMessage, sizeof(szMessage), "* You have paid the ticket of $%d to %s.", TicketMoney[playerid], GetPlayerNameEx(TicketOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s has paid your ticket of $%d.", GetPlayerNameEx(playerid), TicketMoney[playerid]);
                            SendClientMessageEx(TicketOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s has paid the ticket.", GetPlayerNameEx(playerid));
                            ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                            GivePlayerCash(playerid, - TicketMoney[playerid]);
                            new money = floatround(TicketMoney[playerid] / 3), iGroupID = PlayerInfo[TicketOffer[playerid]][pMember];
                            Tax += money;
                            arrGroupData[iGroupID][g_iBudget] += money;
                            GetPVarString(playerid, "ticketreason", szMiscArray, sizeof(szMiscArray));
                            new str[128];
			                format(str, sizeof(str), "%s has paid %s's ticket of $%d [Reason: %s] and $%d has been sent to %s's budget fund.", GetPlayerNameEx(playerid), GetPlayerNameEx(TicketOffer[playerid]), TicketMoney[playerid], szMiscArray, money, arrGroupData[iGroupID][g_szGroupName]);
							GroupPayLog(iGroupID, str);
                            TicketOffer[playerid] = INVALID_PLAYER_ID;
                            TicketMoney[playerid] = 0;
                            DeletePVar(playerid, "ticketreason");
                            if(GetPlayerCash(playerid) < 1) GivePlayerCash(playerid, 0);
                            return 1;
                        }
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "Canh sat viet ve phat do khong o gan ban!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong ai viet ve phat cho ban!");
                return 1;
            }
        }
		else if(strcmp(params, "boxing", true) == 0) {
            if(BoxOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(BoxOffer[playerid])) {
                    new points;
                    new mypoints;
                    GetPlayerName(BoxOffer[playerid], giveplayer, sizeof(giveplayer));
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    new level = PlayerInfo[BoxOffer[playerid]][pBoxSkill];
                    if(level >= 0 && level <= 50) { points = 40; }
                    else if(level >= 51 && level <= 100) { points = 50; }
                    else if(level >= 101 && level <= 200) { points = 60; }
                    else if(level >= 201 && level <= 400) { points = 70; }
                    else if(level >= 401) { points = 80; }
                    if(PlayerInfo[playerid][pJob] == 12 || PlayerInfo[playerid][pJob2] == 12 || PlayerInfo[playerid][pJob3] == 12) {
                        new clevel = PlayerInfo[playerid][pBoxSkill];
                        if(clevel >= 0 && clevel <= 50) { mypoints = 40; }
                        else if(clevel >= 51 && clevel <= 100) { mypoints = 50; }
                        else if(clevel >= 101 && clevel <= 200) { mypoints = 60; }
                        else if(clevel >= 201 && clevel <= 400) { mypoints = 70; }
                        else if(clevel >= 401) { mypoints = 80; }
                    }
                    else {
                        mypoints = 30;
                    }
                    format(szMessage, sizeof(szMessage), "* You have accepted the Boxing Challenge from %s, and will fight with %d Health.",giveplayer,mypoints);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* %s has accepted your Boxing Challenge Request, you will fight with %d Health.",sendername,points);
                    SendClientMessageEx(BoxOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                    if(IsPlayerInRangeOfPoint(playerid,20.0,758.98, -60.32, 1000.78) || IsPlayerInRangeOfPoint(BoxOffer[playerid],20.0,758.98, -60.32, 1000.78)) {
                        ResetPlayerWeapons(playerid);
                        ResetPlayerWeapons(BoxOffer[playerid]);
                        SetHealth(playerid, mypoints);
                        SetHealth(BoxOffer[playerid], points);
                        SetPlayerInterior(playerid, 7); SetPlayerInterior(BoxOffer[playerid], 7);
                        SetPlayerPos(playerid, 768.94, -70.87, 1001.56); SetPlayerFacingAngle(playerid, 131.8632);
                        SetPlayerPos(BoxOffer[playerid], 764.35, -66.48, 1001.56); SetPlayerFacingAngle(BoxOffer[playerid], 313.1165);
                        TogglePlayerControllable(playerid, 0); TogglePlayerControllable(BoxOffer[playerid], 0);
                        GameTextForPlayer(playerid, "~r~Waiting", 3000, 1); GameTextForPlayer(BoxOffer[playerid], "~r~Waiting", 3000, 1);
                        new name[MAX_PLAYER_NAME];
                        new dszMessage[MAX_PLAYER_NAME];
                        new wszMessage[MAX_PLAYER_NAME];
                        GetPlayerName(playerid, name, sizeof(name));
                        format(dszMessage, sizeof(dszMessage), "%s", name);
                        strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                        if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                            format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  sendername, giveplayer);
                            ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                            TBoxer = playerid;
                            BoxDelay = 60;
                        }
                        GetPlayerName(BoxOffer[playerid], name, sizeof(name));
                        format(dszMessage, sizeof(dszMessage), "%s", name);
                        strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                        if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                            format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  giveplayer, sendername);
                            ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                            TBoxer = BoxOffer[playerid];
                            BoxDelay = 60;
                        }
                        BoxWaitTime[playerid] = 1; BoxWaitTime[BoxOffer[playerid]] = 1;
                        if(BoxDelay < 1) { BoxDelay = 20; }
                        InRing = 1;
                        Boxer1 = BoxOffer[playerid];
                        Boxer2 = playerid;
                        PlayerBoxing[playerid] = 1;
                        PlayerBoxing[BoxOffer[playerid]] = 1;
                        BoxOffer[playerid] = INVALID_PLAYER_ID;
                        return 1;
                    }
                    ResetPlayerWeapons(playerid);
                    ResetPlayerWeapons(BoxOffer[playerid]);
                    SetHealth(playerid, mypoints);
                    SetHealth(BoxOffer[playerid], points);
                    SetPlayerInterior(playerid, 5); SetPlayerInterior(BoxOffer[playerid], 5);
                    SetPlayerPos(playerid, 762.9852,2.4439,1001.5942); SetPlayerFacingAngle(playerid, 131.8632);
                    SetPlayerPos(BoxOffer[playerid], 758.7064,-1.8038,1001.5942); SetPlayerFacingAngle(BoxOffer[playerid], 313.1165);
                    TogglePlayerControllable(playerid, 0); TogglePlayerControllable(BoxOffer[playerid], 0);
                    GameTextForPlayer(playerid, "~r~Waiting", 3000, 1); GameTextForPlayer(BoxOffer[playerid], "~r~Waiting", 3000, 1);
                    new name[MAX_PLAYER_NAME];
                    new dszMessage[MAX_PLAYER_NAME];
                    new wszMessage[MAX_PLAYER_NAME];
                    GetPlayerName(playerid, name, sizeof(name));
                    format(dszMessage, sizeof(dszMessage), "%s", name);
                    strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                    if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                        format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  sendername, giveplayer);
                        ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                        TBoxer = playerid;
                        BoxDelay = 60;
                    }
                    GetPlayerName(BoxOffer[playerid], name, sizeof(name));
                    format(dszMessage, sizeof(dszMessage), "%s", name);
                    strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                    if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                        format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  giveplayer, sendername);
                        ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                        TBoxer = BoxOffer[playerid];
                        BoxDelay = 60;
                    }
                    BoxWaitTime[playerid] = 1; BoxWaitTime[BoxOffer[playerid]] = 1;
                    if(BoxDelay < 1) { BoxDelay = 20; }
                    InRing = 1;
                    Boxer1 = BoxOffer[playerid];
                    Boxer2 = playerid;
                    PlayerBoxing[playerid] = 1;
                    PlayerBoxing[BoxOffer[playerid]] = 1;
                    BoxOffer[playerid] = INVALID_PLAYER_ID;
                    return 1;
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai moi ban thach dau boxing ca!");
                return 1;
            }
        }
                                                  // accept taxi
   /*     else if(strcmp(params,"taxi",true) == 0) {
            if(TransportDuty[playerid] != 1) {
                SendClientMessageEx(playerid, COLOR_GREY, "   Ban khong phai la Taxi Driver!");
                return 1;
            }
            if(TaxiCallTime[playerid] > 0) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You have already accepted a taxi call!");
                return 1;
            }
            if(TaxiCall != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(TaxiCall)) {
                	if(taxitime[TaxiCall] == 1 && PlayerInfo[playerid][pMember] != 10 && PlayerInfo[playerid][pLeader] != 10)
					{
					    return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai doi 20 seconds before accepting this call! To recieve priority, join the Taxi Company!");
					}
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    GetPlayerName(TaxiCall, giveplayer, sizeof(giveplayer));
                    format(szMessage, sizeof(szMessage), "* You have accepted the taxi call from %s, you will see the marker until you have reached it.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    new zone[MAX_ZONE_NAME];
					GetPlayer3DZone(TaxiCall, zone, sizeof(zone));
					format(szMessage, sizeof(szMessage), "* %s can be found at %s.", GetPlayerNameEx(TaxiCall), zone);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* Taxi Driver %s has accepted your Taxi Call; please wait at your current position.",sendername);
                    SendClientMessageEx(TaxiCall, COLOR_LIGHTBLUE, szMessage);
                    GameTextForPlayer(playerid, "~w~Taxi Caller~n~~r~Go to the red marker.", 5000, 1);
                    TaxiCallTime[playerid] = 1;
                    TaxiAccepted[playerid] = TaxiCall;
                    TaxiCall = INVALID_PLAYER_ID;
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   Nobody called for a taxi yet!");
                return 1;
            }
        }
        else if(strcmp(params, "bus", true) == 0) {
            if(TransportDuty[playerid] != 2) {
                SendClientMessageEx(playerid, COLOR_GREY, "   Ban khong phai la bus driver!");
                return 1;
            }
            if(BusCallTime[playerid] > 0) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You have already accepted a bus call!");
                return 1;
            }
            if(BusCall != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(BusCall)) {
                    if(CheckPointCheck(playerid)) {
                        SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa muc tieu truoc khi thuc hien danh dau khac (/xoamuctieu).");
                        return 1;
                    }
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    GetPlayerName(BusCall, giveplayer, sizeof(giveplayer));
                    format(szMessage, sizeof(szMessage), "* You have accepted the Bus Call from %s, you will see the marker untill you have reached it.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    new zone[MAX_ZONE_NAME];
					GetPlayer3DZone(BusCall, zone, sizeof(zone));
					format(szMessage, sizeof(szMessage), "* %s can be found at %s.", GetPlayerNameEx(BusCall), zone);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* Bus Driver %s has accepted your bus call; please wait at your current position.",sendername);
                    SendClientMessageEx(BusCall, COLOR_LIGHTBLUE, szMessage);
                    new Float:X,Float:Y,Float:Z;
                    GetPlayerPos(BusCall, X, Y, Z);
                    SetPlayerCheckpoint(playerid, X, Y, Z, 5);
                    GameTextForPlayer(playerid, "~w~Bus Caller~n~~r~Goto redmarker", 5000, 1);
                    BusCallTime[playerid] = 1;
                    BusAccepted[playerid] = BusCall;
                    BusCall = INVALID_PLAYER_ID;
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one called for a Bus yet!");
                return 1;
            }
        }*/
        else if(strcmp(params, "medic", true) == 0) {
            if(IsAMedic(playerid)) {
                if(MedicCallTime[playerid] > 0) {
                    SendClientMessageEx(playerid, COLOR_GREY, "Ban da chap nhan mot cuoc goi Medic roi!");
                    return 1;
                }
                if(CheckPointCheck(playerid)) {
                    SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa muc tieu truoc khi thuc hien danh dau khac (/xoamuctieu).");
                    return 1;
                }
                if(MedicCall != INVALID_PLAYER_ID) {
                    if(IsPlayerConnected(MedicCall)) {
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        GetPlayerName(MedicCall, giveplayer, sizeof(giveplayer));
                        format(szMessage, sizeof(szMessage), "* Ban da chap nhan cuoc goi Medic cua %s.",giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        // SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* After the 45 Seconds the red marker will dissapear.");
                        format(szMessage, sizeof(szMessage), "* Cuu thuong %s da chap nhan cuoc goi Medic cua ban vui long giu yen vi tri.",sendername);
                        SendClientMessageEx(MedicCall, COLOR_LIGHTBLUE, szMessage);
                        new Float:X,Float:Y,Float:Z;
                        GetPlayerPos(MedicCall, X, Y, Z);
                        SetPlayerCheckpoint(playerid, X, Y, Z, 5);
                        new zone[MAX_ZONE_NAME];
                        GetPlayer3DZone(MedicCall, zone, sizeof(zone));
                        format(szMessage, sizeof(szMessage), "MEO: %s dang o khu vuc %s", GetPlayerNameEx(MedicCall), zone);
                        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
                        MedicCallTime[playerid] = 1;
                        MedicAccepted[playerid] = MedicCall;
                        MedicCall = INVALID_PLAYER_ID;
                        return 1;
                    }
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "Chua co ai yeu cau dich vu medic!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Medic!");
                return 1;
            }
        }
        else if(strcmp(params, "mechanic", true) == 0) {
            if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7 && PlayerInfo[playerid][pJob3] != 7) {
                SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Car Mechanic!");
                return 1;
            }
            if(MechanicCallTime[playerid] > 0) {
                SendClientMessageEx(playerid, COLOR_GREY, "Ban da chap nhan mot cuoc goi Mechanic roi!");
                return 1;
            }
            if(CheckPointCheck(playerid)) {
                SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa muc tieu truoc khi thuc hien danh dau khac (/xoamuctieu).");
                return 1;
            }
            if(MechanicCall != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(MechanicCall)) {
                    if(playerid == MechanicCall) return 1;
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    GetPlayerName(MechanicCall, giveplayer, sizeof(giveplayer));
                    format(szMessage, sizeof(szMessage), "* Ban da chap nhan cuoc goi Mechanic cua %s, ban co 30 giay de den vi tri cua ho.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Sau 30 giay diem dau danh tren ban do se bien mat.");
                    format(szMessage, sizeof(szMessage), "* Car Mechanic %s da chap nhan cuoc goi cua ban, ho dang tren duong den.",sendername);
                    SendClientMessageEx(MechanicCall, COLOR_LIGHTBLUE, szMessage);
                    new Float:X,Float:Y,Float:Z;
                    GetPlayerPos(MechanicCall, X, Y, Z);
                    SetPlayerCheckpoint(playerid, X, Y, Z, 5);
                    GameTextForPlayer(playerid, "~w~Mechanic Calls~n~~r~Di theo diem danh dau", 5000, 1);
                    MechanicCallTime[playerid] = 1;
                    MechanicCall = INVALID_PLAYER_ID;
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai yeu cau Mechanic!");
                return 1;
            }
        }
        else if(strcmp(params, "live", true) == 0) {
            if(LiveOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(LiveOffer[playerid])) {
                    if (ProxDetectorS(5.0, playerid, LiveOffer[playerid])) {
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are frozen till the Live Conversation ends.");
                        SendClientMessageEx(LiveOffer[playerid], COLOR_LIGHTBLUE, "* You are frozen till the Live Conversation ends (use /live again).");
                        TogglePlayerControllable(playerid, 0);
                        TogglePlayerControllable(LiveOffer[playerid], 0);
						SetPVarInt(playerid, "IsLive", 1);
						SetPVarInt(LiveOffer[playerid], "IsLive", 1);
                        TalkingLive[playerid] = LiveOffer[playerid];
                        TalkingLive[LiveOffer[playerid]] = playerid;
                        LiveOffer[playerid] = INVALID_PLAYER_ID;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "You are to far away from the News Reporter!");
                        return 1;
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "No-one gave you a Live Conversation offer!");
                return 1;
            }
        }
        else if(strcmp(params, "lawyer", true) == 0) {
            if(sscanf(params, "u", giveplayerid))
            {
                SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /chapnhan lawyer [player]");
                return 1;
            }
            if (IsACop(playerid)) {
                if(IsPlayerConnected(giveplayerid)) {
                    if(giveplayerid != INVALID_PLAYER_ID) {
                        if(PlayerInfo[giveplayerid][pJob] == 2 || PlayerInfo[giveplayerid][pJob2] == 2 || PlayerInfo[giveplayerid][pJob3] == 2) {
                            GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* You allowed %s to free a Jailed Person.", giveplayer);
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE,szMessage);
                            format(szMessage, sizeof(szMessage), "* Officer %s approved (allowed) you to free a Jailed Person. (use /free)", sendername);
                            SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE,szMessage);
                            ApprovedLawyer[giveplayerid] = 1;
                            return 1;
                        }
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Invalid action! (You are no cop / person is not a Lawyer / Bad ID)");
                return 1;
            }
        }
        else if(strcmp(params, "aogiap", true) == 0) {
        	if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay trong Paintball!");
            if(GuardOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > GuardPrice[playerid]) {
                    if(IsPlayerConnected(GuardOffer[playerid])) {
                        if(ProxDetectorS(6.0, playerid, GuardOffer[playerid])) {
                            new Float:armour;
                            GetArmour(playerid, armour);
                            if(armour >= 50) {
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da co mot bo giap!");
                                return 1;
                            }
                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(GuardOffer[playerid], ipex, sizeof(ipex));
                            //format(szMessage, sizeof(szMessage), "[BODYGUARD] %s (IP:%s) has paid $%d to %s (IP:%s)", GetPlayerNameEx(playerid), ip, GuardPrice[playerid], GetPlayerNameEx(GuardOffer[playerid]), ipex);
                            // Log("logs/pay.log", szMessage);

                            if(GuardPrice[playerid] >= 25000 && (PlayerInfo[GuardOffer[playerid]][pLevel] <= 3 || PlayerInfo[playerid][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s (IP:%s) has guarded %s (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(GuardOffer[playerid]), ipex, GuardPrice[playerid]);
                                // Log("logs/pay.log", szMessage);
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            SetArmour(playerid, 50);
                            GetPlayerName(GuardOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* Ban da chap nhan mua giap voi gia $%d tu %s.",GuardPrice[playerid],GetPlayerNameEx(GuardOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s da chap nhan loi de nghi mua giap cua ban, so tien $%d da duoc dua vao tui cua ban.",GetPlayerNameEx(playerid),GuardPrice[playerid]);
                            SendClientMessageEx(GuardOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                            GivePlayerCash(GuardOffer[playerid], GuardPrice[playerid]);
                            GivePlayerCash(playerid, -GuardPrice[playerid]);
                            ExtortionTurfsWarsZone(GuardOffer[playerid], 2, GuardPrice[playerid]);
                            GuardOffer[playerid] = INVALID_PLAYER_ID;
                            GuardPrice[playerid] = 0;
                            return 1;
                        }
                        else {
                            SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi ban giap cho ban da thoat game!");
                            return 1;
                        }
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du tien de mua giap!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai ban giap cho ban ca!");
                return 1;
            }
        }
        else if(strcmp(params, "defense", true) == 0) {
            if(DefendOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > DefendPrice[playerid]) {
                    if(IsPlayerConnected(DefendOffer[playerid])) {
                        /*new ip[32], ipex[32];
                        GetPlayerIp(playerid, ip, sizeof(ip));
                        GetPlayerIp(DefendOffer[playerid], ipex, sizeof(ipex));
                        format(szMessage, sizeof(szMessage), "[LAWYER] %s (IP:%s) has paid $%d to %s (IP:%s)", GetPlayerNameEx(playerid), ip, DefendPrice[playerid], GetPlayerNameEx(DefendOffer[playerid]), ipex);
                        Log("logs/pay.log", szMessage);*/
                        PlayerInfo[playerid][pWantedLevel]--;
                        SetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWantedLevel]);
                        SetPlayerToTeamColor(playerid);
                        giveplayer = GetPlayerNameEx(DefendOffer[playerid]);
                        sendername = GetPlayerNameEx(playerid);
                        format(szMessage, sizeof(szMessage), "Ban da chap nhan bao chua voi gia $%d boi %s.",DefendPrice[playerid],giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        format(szMessage, sizeof(szMessage), "%s da chap nhan bao chua voi gia $%d.",sendername,DefendPrice[playerid]);
                        SendClientMessageEx(DefendOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                        GivePlayerCash( DefendOffer[playerid],DefendPrice[playerid]);
                        GivePlayerCash(playerid, -DefendPrice[playerid]);
                        DefendOffer[playerid] = INVALID_PLAYER_ID;
                        DefendPrice[playerid] = 0;
                        return 1;
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du kha nang de mua giap!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong ai yeu cau ban giap ca.");
                return 1;
            }
        }
        else if(strcmp(params, "appeal", true) == 0) {
            if(AppealOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(AppealOffer[playerid])) {
                    AppealOfferAccepted[playerid] = 1;
                    giveplayer = GetPlayerNameEx(AppealOffer[playerid]);
                    sendername = GetPlayerNameEx(playerid);
                    format(szMessage, sizeof(szMessage), "* You accepted the appeal from Lawyer %s.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* %s accepted your appeal, a message to the Judicial System has been sent, please wait at the courtroom.",sendername);
                    SendClientMessageEx(AppealOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                    return 1;
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong ai yeu cau ban giap ca.");
                return 1;
            }
        }
 	    else if(strcmp(params, "rimkit", true) == 0) {
        	if (GetPVarType(playerid, "RimOffer")) {
	            if(GetPlayerCash(playerid) > GetPVarInt(playerid, "RimPrice")) {
	            	if(IsPlayerConnected(GetPVarInt(playerid, "RimOffer"))) {
	            		if (GetPVarInt(playerid, "RimSeller_SQLId") != GetPlayerSQLId(GetPVarInt(playerid, "RimOffer")))
						{
			                return SendClientMessageEx(playerid, COLOR_GREY, "The other person has disconnected.");
						}
						if(PlayerInfo[GetPVarInt(playerid, "RimOffer")][pRimMod] < GetPVarInt(playerid, "RimCount"))	{
							SendClientMessageEx(playerid,COLOR_GREY, "Nguoi do khong co du Rimkit de ban cho ban!");
							return 1;
						}
	                    GivePlayerCash(playerid, -GetPVarInt(playerid, "RimPrice"));
	                    GivePlayerCash(GetPVarInt(playerid, "RimOffer"), GetPVarInt(playerid, "RimPrice"));
						GetPlayerName(GetPVarInt(playerid, "RimOffer"), giveplayer, sizeof(giveplayer));
	                    format(szMessage, sizeof(szMessage), "* Ban da mua %d rimkit voi gia $%d tu %s.",GetPVarInt(playerid, "RimCount"),GetPVarInt(playerid, "RimPrice"),giveplayer);
	                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
	                    GetPlayerName(playerid, sendername, sizeof(sendername));
	                    format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d rimkit, ban da nhan duoc $%d.",sendername,GetPVarInt(playerid, "RimCount"),GetPVarInt(playerid, "RimPrice"));
	                    SendClientMessageEx(GetPVarInt(playerid, "RimOffer"), COLOR_LIGHTBLUE, szMessage);
	                    PlayerInfo[GetPVarInt(playerid, "RimOffer")][pRimMod] -= GetPVarInt(playerid, "RimCount");
	                    PlayerInfo[playerid][pRimMod] += GetPVarInt(playerid, "RimCount");

                        format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) rim kits for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "RimCount"), number_format(GetPVarInt(playerid, "RimPrice")),  GetPlayerNameEx(GetPVarInt(playerid, "RimOffer")), GetPlayerSQLId(GetPVarInt(playerid, "RimOffer")), GetPlayerIpEx(GetPVarInt(playerid, "RimOffer")));
						Log("logs/pay.log", szMessage);

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(GetPVarInt(playerid, "RimOffer"));

	                    DeletePVar(playerid, "RimOffer");
	                    DeletePVar(playerid, "RimPrice");
	                    DeletePVar(playerid, "RimCount");
                    	DeletePVar(playerid, "RimSeller_SQLId");
	                    return 1;
	  				}
	     		}
	      		else
				{
	            	SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien!");
	                return 1;
	        	}
       		}
			else
			{
        		SendClientMessageEx(playerid, COLOR_GREY, "Khong ai ban rimkit cho ban ca!");
			}
 	    }
		else if(strcmp(params, "voucher", true) == 0)
		{
			if(!GetPVarType(playerid, "buyingVoucher")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Khong ai yeu cau ban voucher ca.");

			new sellerid = GetPVarInt(playerid, "sellerVoucher"),
				price = GetPVarInt(playerid, "priceVoucher"),
				amount = GetPVarInt(playerid, "amountVoucher");

			DeletePVar(playerid, "sellVoucher");
			DeletePVar(playerid, "priceVoucher");
			DeletePVar(playerid, "amountVoucher");
			if(GetPlayerCash(playerid) > price)
			{
				if(IsPlayerConnected(sellerid))
				{
					if(GetPVarInt(playerid, "SQLID_Voucher") != GetPlayerSQLId(sellerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi ban vat pham nay da thoat game.");
					if(GetPVarInt(playerid, "buyingVoucher") == 1) // Car Voucher
					{
						if(PlayerInfo[sellerid][pVehVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d Car Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d Car Voucher cua ban, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Car Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pVehVoucher] += amount;
						PlayerInfo[sellerid][pVehVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 2) // Silver VIP Voucher
					{
						if(PlayerInfo[sellerid][pSVIPVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d Silver VIP Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d Silver VIP Voucher cua ban, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Silver VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pSVIPVoucher] += amount;
						PlayerInfo[sellerid][pSVIPVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 3) // Gold VIP Voucher
					{
						if(PlayerInfo[sellerid][pGVIPVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d Gold VIP Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d Gold VIP Voucher cua ban, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Gold VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pGVIPVoucher] += amount;
						PlayerInfo[sellerid][pGVIPVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 4) // 1 month PVIP Voucher
					{
						if(PlayerInfo[sellerid][pPVIPVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d 1 thang VIP Platinum Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d 1 thang VIP Platinum Voucher voi gia, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) 1 month PVIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pPVIPVoucher] += amount;
						PlayerInfo[sellerid][pPVIPVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 5) // Restricted Car Voucher
					{
						if(PlayerInfo[sellerid][pCarVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d Restricted Car Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d Restricted Car Voucher cua ban, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Restricted Car Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pCarVoucher] += amount;
						PlayerInfo[sellerid][pCarVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 6) // Priority Advertisement Voucher
					{
						if(PlayerInfo[sellerid][pAdvertVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d Priority Advertisement Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d Priority Advertisement Voucher cua ban, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Priority Advertisement Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pAdvertVoucher] += amount;
						PlayerInfo[sellerid][pAdvertVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 7) // 7 Days Silver VIP
					{
						if(PlayerInfo[sellerid][pSVIPExVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d 7 Days Silver VIP Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d 7 Days Silver VIP Voucher cua ban, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) 7 Day Silver VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pSVIPExVoucher] += amount;
						PlayerInfo[sellerid][pSVIPExVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 8) // 7 Days Gold VIP
					{
						if(PlayerInfo[sellerid][pGVIPExVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* Ban da chap nhan de nghi mua %d 7 Days Gold VIP Voucher voi gia $%s tu %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s da chap nhan mua %d 7 Days Gold VIP Voucher voi gia, ban da nhan duoc $%s.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) 7 Days Gold VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pGVIPExVoucher] += amount;
						PlayerInfo[sellerid][pGVIPExVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
				}
				else return SendClientMessageEx(playerid, COLOR_GRAD2, "Khong ai de nghi ban mua voucher.");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du tien.");
		}
        else if(strcmp(params,"chetao",true) == 0) {
            if(CraftOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(CraftOffer[playerid])) {
                    if (ProxDetectorS(5.0, playerid, CraftOffer[playerid])) {
                        if(PlayerInfo[playerid][pHospital] > 0) {
                            SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the che tao vu khi trong benh vien.");
                            return 1;
                        }

                        if(PlayerInfo[CraftOffer[playerid]][pMats] < CraftMats[playerid]) {

                        	CraftOffer[playerid] = INVALID_PLAYER_ID;
                       		CraftId[playerid] = 0;
                        	CraftMats[playerid] = 0;
                        	return SendClientMessageEx(playerid, COLOR_GREY, "Craftmans khong co du vat lieu.");
                        }

                        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can ra khoi phuong tien de thuc hien lenh nay.");
						if(CraftId[playerid] == 17)
						{
							if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID && PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID && PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu Nha!");
								SendClientMessageEx(CraftOffer[playerid], COLOR_GREY, "The buyer doesn't own a house!");
								return 1;
							}
							if((IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW]) &&
							(IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]) && GetPlayerVirtualWorld(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW] && GetPlayerInterior(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW]))
							{
							}
							else if((IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW]) &&
							(IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]) && GetPlayerVirtualWorld(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW] && GetPlayerInterior(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW]))
							{
							}
							else if((IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW]) &&
							(IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]) && GetPlayerVirtualWorld(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW] && GetPlayerInterior(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW]))
							{
							}
							else
							{
								SendClientMessageEx(playerid, COLOR_GREY, "The craftsman is not inside of your house!");
								SendClientMessageEx(CraftOffer[playerid], COLOR_GREY, "Ban khong dung tai side of the buyer's house!");
								return 1;
							}
						}
                        new weaponname[50];
                        format(weaponname, 50, "%s", CraftName[playerid]);
                        switch(CraftId[playerid]) {
                            case 1:
                            {
                                PlayerInfo[playerid][pScrewdriver]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/sellgun");
                            }
                            case 2:
                            {
                                PlayerInfo[playerid][pSmslog]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/smslog");
                            }
                            case 3:
                            {
                                PlayerInfo[playerid][pWristwatch]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/wristwatch");
                            }
                            case 4:
                            {
                                PlayerInfo[playerid][pSurveillance]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/(p)lace(c)amera /(s)ee(c)amera /(d)estroy(c)amera");
                            }
                            case 5:
                            {
                                PlayerInfo[playerid][pTire]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/repair");
                            }
                            case 6:
                            {
                                PlayerInfo[playerid][pLock]=1;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/lock");
                            }
                            case 7:
                            {
                                PlayerInfo[playerid][pFirstaid]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/firstaid");
                            }
                            case 8:
                            {
                                GivePlayerValidWeapon(playerid, 43);
                            }
                            case 9:
                            {
                                PlayerInfo[playerid][pRccam]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/rccam");
                            }
                            case 10:
                            {
                                PlayerInfo[playerid][pReceiver]++;
                                SetPVarInt(playerid, "pReceiverMLeft", 4);
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You will receive the next four department radio messages.");
                            }
                            case 11:
                            {
                                PlayerInfo[playerid][pGPS] = 1;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/gps");
                            }
                            case 12:
                            {
                                PlayerInfo[playerid][pSweep]++;
                                PlayerInfo[playerid][pSweepLeft] = 3;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/sweep");
                            }
                            case 13:
                            {
                                GivePlayerValidWeapon(playerid, 46);
                            }
							case 14:
							{

								if(PlayerInfo[playerid][pTreasureSkill] >=0 && PlayerInfo[playerid][pTreasureSkill] <= 24) PlayerInfo[playerid][pMetalDetector] += 25;
								else if(PlayerInfo[playerid][pTreasureSkill] >=25 && PlayerInfo[playerid][pTreasureSkill] <= 149) PlayerInfo[playerid][pMetalDetector] += 50;
								else if(PlayerInfo[playerid][pTreasureSkill] >=150 && PlayerInfo[playerid][pTreasureSkill] <= 299) PlayerInfo[playerid][pMetalDetector] += 75;
								else if(PlayerInfo[playerid][pTreasureSkill] >=300 && PlayerInfo[playerid][pTreasureSkill] <= 599) PlayerInfo[playerid][pMetalDetector] += 100;
								else if(PlayerInfo[playerid][pTreasureSkill] >=600) PlayerInfo[playerid][pMetalDetector] += 125;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/search");
							}
                            case 15:
                            {
                                PlayerInfo[playerid][pMailbox]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Su dung /placemailbox de dat hop thu ra.");
                            }
							case 16:
							{
								if(PlayerInfo[playerid][pSyringes] < 3) {
									PlayerInfo[playerid][pSyringes]++;
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/usedrug heroin");
								}
								else
								{
						    		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the cam them ong tim nua.");
						    		return 1;
								}
							}
							case 17:
							{
								if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]) && IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]))
								{
									GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetZ]);
									if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID]);
									HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW], .streamdistance = 10.0);
									SaveHouse(PlayerInfo[playerid][pPhousekey]);
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/closet(add/remove)");
								}
								else if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]) && IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]))
								{
									GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetZ]);
									if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID]);
									HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW], .streamdistance = 10.0);
									SaveHouse(PlayerInfo[playerid][pPhousekey2]);
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/closet(add/remove)");
								}
								else if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]) && IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]))
								{
									GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]);
									if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID]);
									HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW], .streamdistance = 10.0);
									SaveHouse(PlayerInfo[playerid][pPhousekey3]);
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/closet(add/remove)");
								}
							}
							case 18:
							{
								PlayerInfo[playerid][pToolBox] += 15;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /pickveh(icle) in any car to attempt to lock pick it.");
							}
							case 19:
							{
								PlayerInfo[playerid][pCrowBar] += 25;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /cracktrunk in any car that you already lock picked to attempt to open the trunk.");
							}
							case 20: GivePlayerValidWeapon(playerid, WEAPON_FLOWER);
							case 21: GivePlayerValidWeapon(playerid, WEAPON_BRASSKNUCKLE);
							case 22: GivePlayerValidWeapon(playerid, WEAPON_BAT);
							case 23: GivePlayerValidWeapon(playerid, WEAPON_CANE);
							case 24: GivePlayerValidWeapon(playerid, WEAPON_SHOVEL);
							case 25: GivePlayerValidWeapon(playerid, WEAPON_POOLSTICK);
							case 26: GivePlayerValidWeapon(playerid, WEAPON_KATANA);
							case 27: GivePlayerValidWeapon(playerid, WEAPON_DILDO);
							case 28: GivePlayerValidWeapon(playerid, WEAPON_SPRAYCAN);
							case 29: {
								PlayerInfo[playerid][pRimMod]++;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /userimkit as a mechanic in any car to modify your rims.");
							}
                        }
                        format(szMessage, sizeof(szMessage), "   Ban da che tao cho %s, mot khau sung %s.", GetPlayerNameEx(playerid),weaponname);
                        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                        SendClientMessageEx(CraftOffer[playerid], COLOR_GRAD1, szMessage);
                        format(szMessage, sizeof(szMessage), "   Ban da nhan duoc mot %s tu %s.", weaponname, GetPlayerNameEx(CraftOffer[playerid]));
                        SendClientMessageEx(playerid, COLOR_GRAD1, szMessage);
                        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                        format(szMessage, sizeof(szMessage), "* %s tao mot thu gi do tu Vat lieu va dua cho %s.", GetPlayerNameEx(CraftOffer[playerid]), GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                        new ip[32], ipex[32];
                        GetPlayerIp(playerid, ip, sizeof(ip));
                        GetPlayerIp(CraftOffer[playerid], ipex, sizeof(ipex));
                        format(szMessage, sizeof(szMessage), "[CRAFTSMAN DEAL] %s(%d) (IP: %s) has bought a %s from %s(%d) (IP: %s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, weaponname, GetPlayerNameEx(CraftOffer[playerid]), GetPlayerSQLId(CraftOffer[playerid]), ipex);
                        Log("logs/sell.log", szMessage);
                        PlayerInfo[CraftOffer[playerid]][pMats] -= CraftMats[playerid];
                        PlayerInfo[CraftOffer[playerid]][pArmsSkill]++;
                        CraftOffer[playerid] = INVALID_PLAYER_ID;
                        CraftId[playerid] = 0;
                        CraftMats[playerid] = 0;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can phai dung gan nguoi ban vu khi cho ban!");
                        return 1;
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "No-one offered you a craft!");
                return 1;
            }
        }
		else if(strcmp(params,"contract",true) == 0) {
			if(HitOffer[playerid] != INVALID_PLAYER_ID) {
				if(HitToGet[playerid] != INVALID_PLAYER_ID) {
					if(IsPlayerConnected(HitToGet[playerid])) {
						format(szMessage, sizeof(szMessage), "* %s has accepted the contract to kill %s.", GetPlayerNameEx(playerid),GetPlayerNameEx(HitToGet[playerid]));
						SendClientMessageEx(HitOffer[playerid], COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* You have accepted the contract to kill %s, you will recieve $%d when completed.", GetPlayerNameEx(HitToGet[playerid]), PlayerInfo[HitToGet[playerid]][pHeadValue]);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s has been assigned to the contract on %s, for $%d.", GetPlayerNameEx(playerid), GetPlayerNameEx(HitToGet[playerid]),  PlayerInfo[HitToGet[playerid]][pHeadValue]);
						foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, szMessage);
						//SendClientMessage(playerid, COLOR_LIGHTBLUE, "Hit accepted.  Wait 15 seconds for the final go ahead from the Agency.");
						//SetPVarInt(playerid, "HitCooldown", 15);
						GoChase[playerid] = HitToGet[playerid];
						GetChased[HitToGet[playerid]] = playerid;
						GotHit[HitToGet[playerid]] = 1;
						HitToGet[playerid] = INVALID_PLAYER_ID;
						HitOffer[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					else {
						HitToGet[playerid] = INVALID_PLAYER_ID;
						HitOffer[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
				}
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "No-one offered you a contract!");
				return 1;
			}
		}
        else if(strcmp(params,"sex",true) == 0) {
            if(SexOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > SexPrice[playerid]) {
                    if (IsPlayerConnected(SexOffer[playerid])) {
                        new Car = GetPlayerVehicleID(playerid);
                        if(IsPlayerInAnyVehicle(playerid) && IsPlayerInVehicle(SexOffer[playerid], Car)) {
                            GetPlayerName(SexOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* You had sex with Whore %s, for $%s.", giveplayer, number_format(SexPrice[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s had sex with you. You have earned $%d.", sendername, SexPrice[playerid]);
                            SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, szMessage);

                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(SexOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "[SEX] %s(%d) (IP:%s) had sex with %s(%d) (IP:%s) for %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(SexOffer[playerid]), GetPlayerSQLId(SexOffer[playerid]), ipex, SexPrice[playerid]);
                            Log("logs/sell.log", szMessage);

                            if(SexPrice[playerid] >= 25000 && (PlayerInfo[SexOffer[playerid]][pLevel] <= 3 || PlayerInfo[playerid][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) had sex with %s(%d) (IP:%s) for $%s in this session.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(SexOffer[playerid]), GetPlayerSQLId(SexOffer[playerid]), ipex, number_format(SexPrice[playerid]));
                                Log("logs/sell.log", szMessage);
                                format(szMessage, sizeof(szMessage), "%s (IP:%s) had sex with %s (IP:%s) for $%s in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(SexOffer[playerid]), ipex, number_format(SexPrice[playerid]));
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            ExtortionTurfsWarsZone(SexOffer[playerid], 6, SexPrice[playerid]);
                            GivePlayerCash(SexOffer[playerid], SexPrice[playerid]);
                            GivePlayerCash(playerid, -SexPrice[playerid]);

  							if(PlayerInfo[SexOffer[playerid]][pDoubleEXP] > 0)
							{
								format(szMessage, sizeof(szMessage), "You have gained 2 whore skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[SexOffer[playerid]][pDoubleEXP]);
								SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, szMessage);
   								PlayerInfo[SexOffer[playerid]][pSexSkill] += 2;
							}
							else
							{
  								PlayerInfo[SexOffer[playerid]][pSexSkill] += 1;
							}

                            if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 50) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 2, you offer better Sex (health) and less chance on STI.");
                            }
                            else if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 100) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 3, you offer better Sex (health) and less chance on STI.");
                            }
                            else if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 200) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 4, you offer better Sex (health) and less chance on STI.");
                            }
                            else if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 400) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 5, you offer better Sex (health) and less chance on STI.");
                            }

                            if(!GetPVarType(playerid, "STD")) {
                                if(Condom[playerid] == 0) {
                                    new Float:health;
                                    new level = PlayerInfo[SexOffer[playerid]][pSexSkill];
                                    if(level >= 0 && level <= 50) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 90) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 10.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD1));
                                        SetPVarInt(playerid, "STD", STD1[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD1[rand]);
                                        if(STD1[rand] == 0) {
                                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health + no STI while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex.");
                                        }
                                        else if(STD1[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD1[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD1[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 51 && level <= 100) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 80) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 20.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD2));
                                        SetPVarInt(playerid, "STD", STD2[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD2[rand]);
                                        if(STD2[rand] == 0) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health + no STD while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex."); }
                                        else if(STD2[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD2[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD2[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 101 && level <= 200) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 70) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 30.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD3));
                                        SetPVarInt(playerid, "STD", STD3[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD3[rand]);
                                        if(STD3[rand] == 0) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health + no STI while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex."); }
                                        else if(STD3[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD3[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD3[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 201 && level <= 400) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 60) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 40.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD4));
                                        SetPVarInt(playerid, "STD", STD4[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD4[rand]);
                                        if(STD4[rand] == 0) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health + no STI while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex."); }
                                        else if(STD4[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD4[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD4[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 401) {
                                        GetHealth(playerid, health);
                                        if(health > 50) {
                                            SetHealth(playerid, 100);
                                        }
                                        else {
                                            SetHealth(playerid, health + 50.0);
                                        }
                                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Your sex skill level was high enough to give them a lot of health and no STD.");
                                        SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* The whore's sex skill level was high enough to give you a lot of health and no STD.");
                                    }
                                }
                                else {
                                    SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* The person used a Condom.");
                                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da su dung bao cao su.");
                                    Condom[playerid] --;
                                }
                            }
                            else {
                                SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* Nguoi nay dang bi benh STD.");
								SexOffer[playerid] = INVALID_PLAYER_ID;
                                return 1;
                            }
                            SexOffer[playerid] = INVALID_PLAYER_ID;
                            return 1;
                        }
                        else {
                            SendClientMessageEx(playerid, COLOR_GREY, "Ban hoac gai diem khong ngoi tren xe!");
                            return 1;
                        }
                    }                             //Connected or not
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du kha nang de lam chuyen tinh duc!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong ai moi ban lam chuyen tinh duc!");
                return 1;
            }
        }
        else if(strcmp(params,"suaxe",true) == 0) {
            if(RepairOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > RepairPrice[playerid]) {
                    if(IsPlayerInAnyVehicle(playerid)) {
                        if(IsPlayerConnected(RepairOffer[playerid])) {
                            RepairCar[playerid] = GetPlayerVehicleID(playerid);
                            RepairVehicle(RepairCar[playerid]);
							Vehicle_Armor(RepairCar[playerid]);
                            PlayerInfo[RepairOffer[playerid]][pTire]--;

                            GivePlayerCash(RepairOffer[playerid], RepairPrice[playerid]);
                            GivePlayerCash(playerid, -RepairPrice[playerid]);
                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(RepairOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has repaired the vehicle from %s(%d) (IP:%s) for $%d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RepairOffer[playerid]), GetPlayerSQLId(RepairOffer[playerid]), ipex, RepairPrice[playerid]);
                            Log("logs/sell.log", szMessage);
                            format(szMessage, sizeof(szMessage), "* %s da sua phuong tien cua %s.", GetPlayerNameEx(RepairOffer[playerid]), GetPlayerNameEx(playerid));
                            ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                            format(szMessage, sizeof(szMessage), "* Ban da chap nhan yeu cau sua chua phuong tien voi gia $%d tu Car Mechanic %s.",RepairPrice[playerid],GetPlayerNameEx(RepairOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

                            if(RepairPrice[playerid] >= 25000 && (PlayerInfo[RepairOffer[playerid]][pLevel] <= 3 || PlayerInfo[RepairOffer[playerid]][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has repaired %s(%d) (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RepairOffer[playerid]), GetPlayerSQLId(RepairOffer[playerid]), ipex, RepairPrice[playerid]);
                                Log("logs/sell.log", szMessage);
								format(szMessage, sizeof(szMessage), "%s (IP:%s) has repaired %s (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(RepairOffer[playerid]), ipex, RepairPrice[playerid]);
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            format(szMessage, sizeof(szMessage), "* Ban da sua phuong tien cua %s voi gia $%d.",GetPlayerNameEx(playerid),RepairPrice[playerid]);
                            SendClientMessageEx(RepairOffer[playerid], COLOR_LIGHTBLUE, szMessage);

   							if(PlayerInfo[RepairOffer[playerid]][pDoubleEXP] > 0)
							{
								format(szMessage, sizeof(szMessage), "You have gained 2 mechanic skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[RepairOffer[playerid]][pDoubleEXP]);
								SendClientMessageEx(RepairOffer[playerid], COLOR_YELLOW, szMessage);
   								PlayerInfo[RepairOffer[playerid]][pMechSkill] += 2;
							}
							else
							{
								PlayerInfo[RepairOffer[playerid]][pMechSkill] += 1;
							}

                            RepairOffer[playerid] = INVALID_PLAYER_ID;
                            RepairPrice[playerid] = 0;
                            return 1;
                        }
                        return 1;
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the Repair!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai yeu cau sua phuong tien!");
                return 1;
            }
        }
        else if(strcmp(params,"doxang",true) == 0) {
            if(RefillOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > RefillPrice[playerid]) {
                    if(IsPlayerInAnyVehicle(playerid)) {
                        if(IsPlayerConnected(RefillOffer[playerid])) {

	      					if(!ProxDetectorS(8.0, RefillOffer[playerid], playerid))
		  					{
								return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan nguoi do.");
							}
                            new Float:fueltogive;
                            new level = PlayerInfo[RefillOffer[playerid]][pMechSkill];
                            if(level >= 0 && level < 100) { fueltogive = 2.0; }
                            else if(level >= 100 && level < 300) { fueltogive = 4.0; }
                            else if(level >= 300 && level < 500) { fueltogive = 6.0; }
                            else if(level >= 500 && level < 700) { fueltogive = 8.0; }
                            else if(level >= 700) { fueltogive = 10.0; }
                            GetPlayerName(RefillOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            new vehicleid = GetPlayerVehicleID(playerid);
                            VehicleFuel[vehicleid] = floatadd(VehicleFuel[vehicleid], fueltogive);
                            if(VehicleFuel[vehicleid] > 100.0) VehicleFuel[vehicleid] = 100.0;
                            for(new vehicleslot = 0; vehicleslot < MAX_PLAYERVEHICLES; vehicleslot++)
							{
								if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][vehicleslot][pvId]))
								{
									if(vehicleslot != -1) {
										mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d'", VehicleFuel[vehicleid], PlayerVehicleInfo[playerid][vehicleslot][pvSlotId]);
										mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
									}
								}
							}
                            GivePlayerCash(RefillOffer[playerid], RefillPrice[playerid]);
                            GivePlayerCash(playerid, -RefillPrice[playerid]);
                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(RefillOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has refilled the vehicle from %s(%d) (IP:%s) for $%d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RefillOffer[playerid]), GetPlayerSQLId(RefillOffer[playerid]), ipex, RefillPrice[playerid]);
							Log("logs/sell.log", szMessage);
                            format(szMessage, sizeof(szMessage), "* %s da do xang cho phuong tien cua %s.", GetPlayerNameEx(RefillOffer[playerid]), GetPlayerNameEx(playerid));
                           	ProxChatBubble(playerid, szMessage);
                            // ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                            format(szMessage, sizeof(szMessage), "* Phuong tien cua ban da duoc do %.2f xang voi gia $%d boi Tho sua xe %s.",fueltogive,RefillPrice[playerid],GetPlayerNameEx(RefillOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* Ban da do %.2f xamg cho phuong tien cua %s, va nhan duoc $%d.",fueltogive,GetPlayerNameEx(playerid),RefillPrice[playerid]);
                            SendClientMessageEx(RefillOffer[playerid], COLOR_LIGHTBLUE, szMessage);

 							if(PlayerInfo[RefillOffer[playerid]][pDoubleEXP] > 0)
							{
								format(szMessage, sizeof(szMessage), "You have gained 2 mechanic skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[RefillOffer[playerid]][pDoubleEXP]);
								SendClientMessageEx(RefillOffer[playerid], COLOR_YELLOW, szMessage);
   								PlayerInfo[RefillOffer[playerid]][pMechSkill] += 2;
							}
							else
							{
								PlayerInfo[RefillOffer[playerid]][pMechSkill] += 1;
							}

                            if(RefillPrice[playerid] >= 30000 && (PlayerInfo[playerid][pLevel] <= 3 || PlayerInfo[RefillOffer[playerid]][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has refueled %s(%d) (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RefillOffer[playerid]), GetPlayerSQLId(RefillOffer[playerid]), ipex, RefillPrice[playerid]);
                                Log("logs/sell.log", szMessage);
								format(szMessage, sizeof(szMessage), "%s (IP:%s) has refueled %s (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(RefillOffer[playerid]), ipex, RefillPrice[playerid]);
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            RefillOffer[playerid] = INVALID_PLAYER_ID;
                            RefillPrice[playerid] = 0;
                            return 1;
                        }
                        return 1;
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du kha nang de do xang!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Khong co ai yeu cau do xang ca!");
                return 1;
            }
        }
		else if(strcmp(params, "backpack", true) == 0) {
			if(GetPVarType(playerid, "sellbackpack") && IsPlayerConnected(GetPVarInt(playerid, "sellbackpack")))
			{
				if(GetPlayerCash(playerid) > GetPVarInt(playerid, "sellbackpackprice"))
				{
					if(PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack] < 1)	{
						SendClientMessageEx(playerid,COLOR_GREY, "That person does not have a backpack anymore!");
						return 1;
					}
					new btype[8];
					if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					switch(PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack])
					{
						case 1:
						{
							btype = "Small";
							SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
						}
						case 2:
						{
							btype = "Medium";
							SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
						}
						case 3:
						{
							btype = "Large";
							SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
						}
					}
					GivePlayerCash(playerid, -GetPVarInt(playerid, "sellbackpackprice"));
					GivePlayerCash(GetPVarInt(playerid, "sellbackpack"), GetPVarInt(playerid, "sellbackpackprice"));
					format(szMessage, sizeof(szMessage), "* You bought a %s Backpack for $%s from %s.",btype,number_format(GetPVarInt(playerid, "sellbackpackprice")),GetPlayerNameEx(GetPVarInt(playerid, "sellbackpack")));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
					format(szMessage, sizeof(szMessage), "* %s has bought your %s Backpack, $%s was added to your money.",GetPlayerNameEx(playerid),btype, number_format(GetPVarInt(playerid, "sellbackpackprice")));
					SendClientMessageEx(GetPVarInt(playerid, "sellbackpack"), COLOR_LIGHTBLUE, szMessage);


					PlayerInfo[playerid][pBackpack] = PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack];
					PlayerInfo[playerid][pBEquipped] = 1;
					PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;
					PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
					RemovePlayerAttachedObject(GetPVarInt(playerid, "sellbackpack"), 9);

					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack] = 0;
					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBEquipped] = 0;
					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBStoredH] = INVALID_HOUSE_ID;
					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
					for(new i = 0; i < 10; i++)
					{
						PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBItems][i] = 0;
					}

					format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought %s Backpack for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), btype, number_format(GetPVarInt(playerid, "sellbackpackprice")),  GetPlayerNameEx(GetPVarInt(playerid, "sellbackpack")), GetPlayerSQLId(GetPVarInt(playerid, "sellbackpack")), GetPlayerIpEx(GetPVarInt(playerid, "sellbackpack")));
					Log("logs/pay.log", szMessage);
					Log("logs/backpack.log", szMessage);

					OnPlayerStatsUpdate(playerid);
					OnPlayerStatsUpdate(GetPVarInt(playerid, "sellbackpack"));
					DeletePVar(GetPVarInt(playerid, "sellbackpack"), "sellingbackpack");
					DeletePVar(playerid, "sellbackpack");
					DeletePVar(playerid, "sellbackpackprice");
					return 1;
	     		}
	      		else
				{
	            	SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the backpack!");
					DeletePVar(playerid, "sellbackpack");
	                DeletePVar(playerid, "sellbackpackprice");
	                return 1;
	        	}
			}
		}
        return 1;
    }                                             //not connected
    return 1;
}

CMD:cancel(playerid, params[])
{
	new string[128], choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /huy [Lua chon]");
		SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: Chetao, Suaxe, Aogiap, Doxang, Trogiup, Nha, Xe, Giaohang, Door");
		SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: Sex, Mats, Cannabis, Crack, Lawyer, Live, Boxing");
		SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: Taxi, Bus, Medic, Mechanic, Ticket, Witness, Marriage, Drink, Firstaid, Garbage");
		SendClientMessageEx(playerid, COLOR_GREY, "LUA CHON: FoodOffer, RenderAid, DrugRun");
		if(PlayerInfo[playerid][pTut] != -1) SendClientMessageEx(playerid, COLOR_GREY, "KHAC: nvhuongdan");
		if(IsAHitman(playerid)) { SendClientMessageEx(playerid, COLOR_GREY, "HITMAN: contract"); }
		return 1;
	}

	if(strcmp(choice, "nvhuongdan", true) == 0 && PlayerInfo[playerid][pTut] >= 15)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban da huy huong dan nguoi choi moi. Chao mung den voi GTA.Network!");
		SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
		PlayerInfo[playerid][pTut] = -1;
		DisablePlayerCheckpoint(playerid);
	}

	if(strcmp(choice, "door", true) == 0)
	{
		if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are not logged into your account.");
		if(DDSalePendingAdmin[playerid] == false && DDSalePendingPlayer[playerid] == false) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co de nghi Sell Door.");
		ClearDoorSaleVariables(playerid);
	}
	else if(strcmp(choice,"renderaid",true) == 0) DeletePVar(playerid, "renderaid");
	else if(strcmp(choice,"sex",true) == 0) {
		if(GetPVarType(playerid, "SexOfferTo")) {
			SexOffer[GetPVarInt(playerid, "SexOfferTo")] = INVALID_PLAYER_ID;
			SexPrice[GetPVarInt(playerid, "SexOfferTo")] = 0;
			DeletePVar(playerid, "SexOfferTo");
		}
		else {
			SexOffer[playerid] = INVALID_PLAYER_ID; SexPrice[playerid] = 0;
		}
	}
	else if(strcmp(choice,"chetao",true) == 0) { CraftOffer[playerid] = INVALID_PLAYER_ID; CraftId[playerid] = 0; }
	else if(strcmp(choice,"suaxe",true) == 0) {
		if(GetPVarType(playerid, "RepairOfferTo")) {
			RepairOffer[GetPVarInt(playerid, "RepairOfferTo")] = INVALID_PLAYER_ID;
			RepairPrice[GetPVarInt(playerid, "RepairOfferTo")] = 0;
			RepairCar[GetPVarInt(playerid, "RepairOfferTo")] = 0;
			DeletePVar(playerid, "RepairOfferTo");
		}
		else {
			RepairOffer[playerid] = INVALID_PLAYER_ID; RepairPrice[playerid] = 0; RepairCar[playerid] = 0;
		}
	}
	else if(strcmp(choice,"lawyer",true) == 0) { WantLawyer[playerid] = 0; CallLawyer[playerid] = 0; }
	else if(strcmp(choice,"aogiap",true) == 0) { GuardOffer[playerid] = INVALID_PLAYER_ID; GuardPrice[playerid] = 0; }
	else if(strcmp(choice,"live",true) == 0) { LiveOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"doxang",true) == 0) { RefillOffer[playerid] = INVALID_PLAYER_ID; RefillPrice[playerid] = 0; }
	else if(strcmp(choice,"xe",true) == 0) { VehicleOffer[playerid] = INVALID_PLAYER_ID; VehiclePrice[playerid] = 0; VehicleId[playerid] = -1; }
	else if(strcmp(choice,"nha",true) == 0) { HouseOffer[playerid] = INVALID_PLAYER_ID; HousePrice[playerid] = 0; House[playerid] = 0; }
	else if(strcmp(choice,"boxing",true) == 0) { BoxOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"witness",true) == 0) { MarryWitnessOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"marriage",true) == 0) { DeletePVar(ProposeOffer[playerid], "marriagelastname"), ProposeOffer[playerid] = INVALID_PLAYER_ID, DeletePVar(playerid, "marriagelastname"); }
	//else if(strcmp(choice,"divorce",true) == 0) { DivorceOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"drink",true) == 0) { DrinkOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"firstaid",true) == 0)
	{
		if(GetPVarInt(playerid, "usingfirstaid"))
		{
			KillTimer(GetPVarInt(playerid, "firstaid5"));
			SetPVarInt(playerid, "usingfirstaid", 0);
		}
	}
	else if(strcmp(choice,"drugrun",true) == 0)
	{
		if(GetPVarInt(playerid, "pDrugRun"))
		{
			Player_KillCheckPoint(playerid);
			DeletePVar(playerid, "pDrugRun");
			DeletePVar(playerid, "pDrugBoat");
			DeletePVar(playerid, "pPotPackages");
			DeletePVar(playerid, "pCrackPackages");
			DeletePVar(playerid, "pMethPackages");
			DeletePVar(playerid, "pEcstasyPackages");
		}
	}
	else if(strcmp(choice,"giaohang",true) == 0)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can phai in a valid vehicle.");
 		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "TruckDeliver");

		TruckContents{vehicleid} = 0;
		if((0 <= TruckDeliveringTo[vehicleid] < MAX_BUSINESSES)) Businesses[TruckDeliveringTo[vehicleid]][bOrderState] = 0;
		TruckDeliveringTo[vehicleid] = INVALID_BUSINESS_ID;

		TruckUsed[playerid] = INVALID_VEHICLE_ID;
		gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
 		DisablePlayerCheckpoint(playerid);
	}
	else if(strcmp(choice,"garbage",true) == 0)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can phai in a valid vehicle.");
 		DeletePVar(playerid, "pGarbageRun");
		DeletePVar(playerid, "pGarbageStage");

 		DisablePlayerCheckpoint(playerid);
	}
	else if(strcmp(choice,"trogiup", true) == 0)
	{
	    if(GetPVarInt(playerid, "COMMUNITY_ADVISOR_REQUEST") == 1)
	    {
		    DeletePVar(playerid, "COMMUNITY_ADVISOR_REQUEST");
			DeletePVar(playerid, "HelpTime");
			DeletePVar(playerid, "HelpReason");
		}
		else {
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You did not requested help.");
		    return 1;
		}
	}
	else if(strcmp(choice,"contract",true) == 0)
	{
		if(GoChase[playerid] != INVALID_PLAYER_ID || HitToGet[playerid] != INVALID_PLAYER_ID) {
			new Float:health;
			GetHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
			if (hpint >=  80)
			{
				HitToGet[playerid] = INVALID_PLAYER_ID;
				HitOffer[playerid] = INVALID_PLAYER_ID;
				GetChased[GoChase[playerid]] = INVALID_PLAYER_ID;
				GotHit[GoChase[playerid]] = 0;
				GoChase[playerid] = INVALID_PLAYER_ID;
				DeletePVar(playerid, "HitCooldown");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot cancel a contract with less than 80 percent health!");

		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co an active contract!");
	}
	else if(strcmp(choice,"ticket",true) == 0) { TicketOffer[playerid] = INVALID_PLAYER_ID; TicketMoney[playerid] = 0; }
	else if(strcmp(choice,"medic",true) == 0) { if(IsPlayerConnected(MedicCall)) { if(MedicCall == playerid) { MedicCall = INVALID_PLAYER_ID; } else { SendClientMessageEx(playerid, COLOR_GREY, "   Ban khong phai la current Caller!"); return 1; } } }
	else if(strcmp(choice,"mechanic",true) == 0) { if(IsPlayerConnected(MechanicCall)) { if(MechanicCall == playerid) { MechanicCall = INVALID_PLAYER_ID; } else { SendClientMessageEx(playerid, COLOR_GREY, "   Ban khong phai la current Caller!"); return 1; } } }
	else if(strcmp(choice,"trogiup",true) == 0) { if(GetPVarInt(playerid, "COMMUNITY_ADVISOR_REQUEST")) { DeletePVar(playerid, "COMMUNITY_ADVISOR_REQUEST"); } else { SendClientMessageEx(playerid, COLOR_GREY, "   Ban khong phai la current Caller!"); return 1; } }
	else if(strcmp(choice,"taxi",true) == 0)
	{
		if(TransportDuty[playerid] == 1 && TaxiCallTime[playerid] > 0)
		{
			GameTextForPlayer(TaxiAccepted[playerid], "~w~Taxi Driver~n~~r~Canceled the call", 5000, 1);
			DeletePVar(TaxiAccepted[playerid], "TaxiCall");
			TaxiAccepted[playerid] = INVALID_PLAYER_ID;
			GameTextForPlayer(playerid, "~w~You have~n~~r~Canceled the call", 5000, 1);
			TaxiCallTime[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
		}
		else
		{
			if(GetPVarInt(playerid, "TaxiCall")) DeletePVar(playerid, "TaxiCall");
			else {
				foreach(new i: Player)
				{
					if(TaxiAccepted[i] != INVALID_PLAYER_ID && TaxiAccepted[i] == playerid)
					{
							GameTextForPlayer(i, "~w~Taxi Caller~n~~r~Canceled the call", 5000, 1);
							TaxiCallTime[i] = 0;
							DeletePVar(TaxiAccepted[i], "TaxiCall");
							TaxiAccepted[i] = INVALID_PLAYER_ID;
							DisablePlayerCheckpoint(i);
					}
				}
			}
		}
	}
	else if(strcmp(choice,"bus",true) == 0)
	{
		if(TransportDuty[playerid] == 2 && BusCallTime[playerid] > 0)
		{
			GameTextForPlayer(BusAccepted[playerid], "~w~Bus Driver~n~~r~Canceled the call", 5000, 1);
			DeletePVar(BusAccepted[playerid], "BusCall");
			BusAccepted[playerid] = INVALID_PLAYER_ID;
			GameTextForPlayer(playerid, "~w~You have~n~~r~Canceled the call", 5000, 1);
			BusCallTime[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
		}
		else
		{
			foreach(new i: Player)
			{
				if(BusAccepted[i] != INVALID_PLAYER_ID && BusAccepted[i] == playerid)
				{
					GameTextForPlayer(i, "~w~Bus Caller~n~~r~Canceled the call", 5000, 1);
					BusCallTime[i] = 0;
					DeletePVar(BusAccepted[i], "BusCall");
					BusAccepted[i] = INVALID_PLAYER_ID;
					DisablePlayerCheckpoint(i);
				}
			}
		}
	}
	else if(strcmp(choice,"foodoffer",true) == 0) {
		new offeredTo = GetPVarInt(playerid, "OfferedMealTo");
		DeletePVar(offeredTo, "OfferedMeal");
		DeletePVar(offeredTo, "OfferedMealBy");
		DeletePVar(playerid, "OfferingMeal");
		DeletePVar(playerid, "OfferedMealTo");
	}
	else { return 1; }
	format(string, sizeof(string), "* Ban da huy : %s.", choice);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

timer Cooldown_Mechanic[10000](playerid) {
	DeletePVar(playerid, "MCH_CLDWN");
}

CMD:refill(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7 && PlayerInfo[playerid][pJob3] != 7)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Car Mechanic.");
	}

	new string[128];
	if(gettime() < PlayerInfo[playerid][pMechTime])
	{
		format(string, sizeof(string), "Ban phai doi %d giay!", PlayerInfo[playerid][pMechTime]-gettime());
		return SendClientMessageEx(playerid, COLOR_GRAD1,string);
	}
	new giveplayerid, money;
	if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /doxang [player] [gia]");

	if(!(money >= 1 && money < 10000))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Gia khong duoc thap hon $1 va cao hon $10,000!");
	}
	if(IsPlayerConnected(giveplayerid))
	{
		if(ProxDetectorS(8.0, playerid, giveplayerid) && IsPlayerInAnyVehicle(giveplayerid))
		{

			new Float: fueltogive;
			switch(PlayerInfo[playerid][pMechSkill])
			{
			case 0 .. 99: fueltogive = 2.0;
			case 100 .. 299: fueltogive = 4.0;
			case 300 .. 499: fueltogive = 6.0;
			case 500 .. 699: fueltogive = 8.0;
			default: fueltogive = 10.0;
			}
			if(giveplayerid == playerid)
			{
				if(PlayerInfo[playerid][pMechSkill] >= 400)
				{
					if(GetPVarType(playerid, "MCH_CLDWN")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't refill so fast!");

					SetPVarInt(playerid, "MCH_CLDWN", 1);
					defer Cooldown_Mechanic(playerid);

					new vehicleid = GetPlayerVehicleID(playerid);
					VehicleFuel[vehicleid] = VehicleFuel[vehicleid] + fueltogive;
					if(VehicleFuel[vehicleid] > 100.0) VehicleFuel[vehicleid] = 100.0;
					format(string, sizeof(string), "* %s da do xang vao phuong tien cua ho.", GetPlayerNameEx(playerid));
					ProxChatBubble(playerid, string);
					// ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					format(string, sizeof(string), "Ban da them %.2f lit xang cho phuong tien cua ban.",fueltogive);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					for(new vehicleslot = 0; vehicleslot < MAX_PLAYERVEHICLES; vehicleslot++)
					{
						if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][vehicleslot][pvId]))
						{
							if(vehicleslot != -1) {
								mysql_format(MainPipeline, string, sizeof(string), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d'", VehicleFuel[vehicleid], PlayerVehicleInfo[playerid][vehicleslot][pvSlotId]);
								mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
							}
						}
					}
					return 1;
				}
				SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the do xang cho chinh ban."); return 1;
			}
			format(string, sizeof(string), "* Ban de nghi %s do %.2f lit xang voi gia $%d.",GetPlayerNameEx(giveplayerid),fueltogive,money);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* Car Mechanic %s da de nghi do %.2f lit xang voi gia $%d, nhap (/chapnhan doxang) de chap nhan.",GetPlayerNameEx(playerid),fueltogive,money);
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			PlayerInfo[playerid][pMechTime] = gettime()+60;
			RefillOffer[giveplayerid] = playerid;
			RefillPrice[giveplayerid] = money;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi do khong gan ban hoac khong ngoi tren xe.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong truc tuyen.");
	return 1;
}

CMD:repair(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7 && PlayerInfo[playerid][pJob3] != 7)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Car Mechanic!");
		return 1;
	}
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the sua xe khi dang ngoi trong xe.");

	new string[128];
	if(gettime() < PlayerInfo[playerid][pMechTime])
	{
		format(string, sizeof(string), "Ban phai doi %d giay!", PlayerInfo[playerid][pMechTime]-gettime());
		SendClientMessageEx(playerid, COLOR_GRAD1,string);
		return 1;
	}
	if(GetPVarInt(playerid, "EventToken")) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the su dung lenh nay trong su kien.");
	}
	new giveplayerid, money;
	if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /suaxe [player] [gia]");

	if(PlayerInfo[playerid][pTire] > 0)
	{
		if(money < 1 || money > 10000) { SendClientMessageEx(playerid, COLOR_GREY, "Gia khong duoc thap hon $1 va cao hon $10,000!"); return 1; }
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    new closestcar = GetClosestCar(playerid);

	  			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 8.0))
	  			{
					if(ProxDetectorS(8.0, playerid, giveplayerid)&& IsPlayerInAnyVehicle(giveplayerid))
					{
						if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay."); return 1; }
	                    if(!IsABike(closestcar) && !IsAPlane(closestcar))
						{
							new engine,lights,alarm,doors,bonnet,boot,objective;
							GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
							if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
							{
								SendClientMessageEx(playerid, COLOR_GRAD1, "Chiec xe nay chua duoc mo mui xe (/car hood).");
								return 1;
							}
						}
						format(string, sizeof(string), "* Ban de nghi %s sua xe voi gia $%d .",GetPlayerNameEx(giveplayerid),money);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Car Mechanic %s da de nghi sua xe voi gia $%d, nhap (/chapnhan suaxe) de chap nhan.",GetPlayerNameEx(playerid),money);
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						PlayerInfo[playerid][pMechTime] = gettime()+60;
						SetPVarInt(playerid, "RepairOfferTo", giveplayerid);
						RepairOffer[giveplayerid] = playerid;
						RepairPrice[giveplayerid] = money;
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi do khong gan ban hoac khong ngoi tren xe.");
					}
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan chiec xe.");
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong truc tuyen.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co tire.");
	}
	return 1;
}
