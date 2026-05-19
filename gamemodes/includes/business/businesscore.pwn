/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Business System

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

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES && InBusiness(playerid) != INVALID_BUSINESS_ID) {
		if(IsAt247(playerid)) return callcmd::buy(playerid, "");
		else if(IsAtRestaurant(playerid)) return callcmd::buyfood(playerid, "");
		else if(IsAtClothingStore(playerid)) return callcmd::buyclothes(playerid, "");
	}
	return 1;
}

stock TaxSale(amount)
{
	new iTaxAmount = floatround(amount / 100 * BUSINESS_TAX_PERCENT);
	Tax += iTaxAmount;
	for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
	{
		if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV && arrGroupData[iGroupID][g_iAllegiance] == 1)
		{
			new str[128];
			format(str, sizeof(str), "Cua hang da tra $%s trong thue ban hang.", number_format(iTaxAmount));
			GroupPayLog(iGroupID, str);
		}
	}
	Misc_Save();
	return amount - iTaxAmount;
}

stock GivePlayerStoreItem(playerid, type, business, item, price)
{
	if(Businesses[business][bInventory] <= StoreItemCost[item-1][ItemValue]) return SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang khong du hang cho mat hang do!");
	new string[256];
	switch (item)
  	{
  		case ITEM_CELLPHONE:
		{
			if(PlayerInfo[playerid][pTut] == 17)
			{
				PlayerInfo[playerid][pTut]++;
				AdvanceTutorial(playerid);
			}
			if(PlayerInfo[playerid][pPnumber] == 0)
			{
				new randphone = 99999 + random(900000);
				SetPVarInt(playerid, "WantedPh", randphone);
				SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
		        SetPVarInt(playerid, "PhChangeCost", 500);
				mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'", randphone);
				mysql_tquery(MainPipeline, szMiscArray, "OnPhoneNumberCheck", "ii", playerid, 2);
			}
			Phone_PhoneColorMenu(playerid);
		}
  		case ITEM_PHONEBOOK:
		{
			PlayerInfo[playerid][pPhoneBook] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua danh ba, bay gio co the lien lac voi nguoi khac.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /number <id/ten>.");
		}
  		case ITEM_DICE:
		{
  			if(PlayerInfo[playerid][pDice] == 0)
	    	{
				PlayerInfo[playerid][pDice] += 10;
				SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua xuc xac.");
			}
            else return SendClientMessageEx(playerid, COLOR_GREY, "Ban van con xuc xac nen khong the mua them nua.");
		}
  		case ITEM_CONDOM:
		{
			Condom[playerid]++;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua bao cao su.");
		}
  		case ITEM_MUSICPLAYER:
		{
			PlayerInfo[playerid][pCDPlayer] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua may nghe nhac.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /music");
		}
  		case ITEM_ROPE:
		{
			printf("%d", Businesses[business][bItemPrices][ITEM_ROPE]);
			PlayerInfo[playerid][pRope]++;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da mua soi day.");
			SendClientMessageEx(playerid, COLOR_GREY, "Goi y: Nhap /tie trong khi ai do do tay troi lai.");
		}
  		case ITEM_CIGAR:
		{
			PlayerInfo[playerid][pCigar] = 10;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua 10 dieu xi ga.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /usecigar de hut xi ga. chuot trai de hut, F de vut no di.");
		}
  		case ITEM_SPRUNK:
		{
			PlayerInfo[playerid][pSprunk] += 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua nuoc giai khat Sprunk.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /usesprunk de uong lon nuoc Sprunk. Chuot trai de uong, F de vut no di.");
		}
  		case ITEM_VEHICLELOCK:
		{
			PlayerInfo[playerid][pLock] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua chia khoa xe.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /pvlock de mo/khoa phuong tien.");
		}
		case ITEM_SPRAYCAN:
		{
			if(PlayerInfo[playerid][pSpraycan] < 20)
			{
				PlayerInfo[playerid][pSpraycan] += 10;
				SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua 10 binh xit son.");
				SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /colorcar hoac /paintcar khi dang ngoi trong xe.");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD4, "Ban khong the giu them mat hang nay!");
		}
  		case ITEM_RADIO:
		{
			PlayerInfo[playerid][pRadio] = 1;
			PlayerInfo[playerid][pRadioFreq] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua mot radio.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /pr de tro chuyen tren kenh radio.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nhap /setfreq de dat tan so cho radio.");
		}
  		case ITEM_CAMERA:
		{
			GivePlayerValidWeapon(playerid, WEAPON_CAMERA);
			SendClientMessageEx(playerid, COLOR_GRAD4, "Da mua mot Camera.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Nho nhin vao khung ngam va chup anh.");
		}
  		case ITEM_LOTTERYTICKET:
		{
			ShowPlayerDialogEx(playerid, LOTTOMENU, DIALOG_STYLE_INPUT, "Lua chon ve so","Vui long nhap so", "Chon", "Huy" );
		}
  		case ITEM_CHECKBOOK:
		{
	        if(PlayerInfo[playerid][pChecks] == 0)
	    	{
		        PlayerInfo[playerid][pChecks] += 10;
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Da mua Sec, hien tai ban dang co 1 tam Sec.");
			    SendClientMessageEx(playerid, COLOR_WHITE, "Goi y: Go /writecheck de viet sec.");
		    }
			else return SendClientMessageEx(playerid, COLOR_GREY, "Ban con Sec chua su dung, vui long su dung chung truoc khi nhan so Sec khac.");
		}
  		case ITEM_PAPERS:
		{
	        if(PlayerInfo[playerid][pPaper] == 0)
	        {
		        PlayerInfo[playerid][pPaper] = 15;
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua Giay To , hien tai ban co 15 giay viet thu de gui.");
		    }
			else return SendClientMessageEx(playerid, COLOR_GREY, "Ban van con giay to chua su dung, vui long su dung truoc khi nhan them giay to.");
		}
		case ITEM_SCALARM:
		{
			if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 1);
				for(new i=0; i<MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(string, sizeof(string), "Phuong tien %d| Ten: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				return ShowPlayerDialogEx(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Chon mot chiec xe ma ban muon cat dat chia khoa:", "Chon", "Huy");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co mot chiec xe nao de chung toi co the cai dat mat hang nay?");
		}
		case ITEM_ELOCK:
		{
			if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 2);
				for(new i=0; i<MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(string, sizeof(string), "Phuong tien %d | Ten: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				return ShowPlayerDialogEx(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Chon mot chiec xe ma ban muon cat dat chia khoa:", "Chon", "Huy");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co mot chiec xe nao de chung toi co the cai dat mat hang nay?");
		}
		case ITEM_ILOCK:
		{
			if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 3);
				for(new i=0; i<MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(string, sizeof(string), "Phuong tien %d | Ten: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				return ShowPlayerDialogEx(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Chon mot chiec xe ma ban muon cat dat chia khoa:", "Chon", "Huy");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co mot chiec xe nao de chung toi co the cai dat mat hang nay?");
		}
		case ITEM_HELMET:
		{
			/* if(GetPlayerVehicleCount(playerid) != 0)
			{ */
			SetPVarInt(playerid, "helmetsel", 1);
			SetPVarInt(playerid, "helcost", price);
			SetPVarInt(playerid, "businessid", business);
			SetPVarInt(playerid, "item", item);
			new models[8] = {18936, 18937, 18938, 18976, 18977, 18978, 18979, 18645};
			return ShowModelSelectionMenuEx(playerid, models, sizeof(models), "Chon mu bao hiem", 1339, 0.0, 0.0, 120.0);
			/* }
			else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co any cars - where we can install this item?"); */
		}
		case ITEM_RAG:
		{
			PlayerInfo[playerid][pRags]++;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da mua mot mieng Gie.");
			SendClientMessageEx(playerid, COLOR_GREY, "Goi y: Go /blindfold trong khi nguoi bi troi de bit mat ho.");
		}
		default:
		{
			printf("Error %d ITEM", item);
		    return 0;
		}
	}
	printf("%d", Businesses[business][bItemPrices][ITEM_RAG]);
	Businesses[business][bInventory] -= StoreItemCost[item-1][ItemValue];
	Businesses[business][bTotalSales]++;
	Businesses[business][bSafeBalance] += TaxSale(price);
	GivePlayerCash(playerid, -price);
	if(PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[business][bLevelProgress]++;
	SaveBusiness(business);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	printf("%d", Businesses[business][bItemPrices][ITEM_RAG]);
	switch(type)
	{
		case 0:
		{
			format(string,sizeof(string),"%s(%d) (IP: %s) da mua mot %s in %s (%d) for $%s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), StoreItems[item-1], Businesses[business][bName], business, number_format(price));
			Log("logs/business.log", string);
			format(string,sizeof(string),"Ban da mua mot %s tu %s voi gia $%s.", StoreItems[item-1], Businesses[business][bName], number_format(price));
			SendClientMessage(playerid, COLOR_GRAD2, string);
		}
		case 1:
		{
			new offerer = GetPVarInt(playerid, "Business_ItemOfferer");
			format(string, sizeof(string), "%s %s(%d) (IP: %s) da ban mot %s to %s (IP: %s) for $%s in %s (%d)", GetBusinessRankName(PlayerInfo[offerer][pBusinessRank]), GetPlayerNameEx(offerer), GetPlayerSQLId(offerer), GetPlayerIpEx(offerer), StoreItems[item-1], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), number_format(price), Businesses[business][bName], business);
			Log("logs/business.log", string);
			format(string,sizeof(string),"* %s da mua %s from you for $%s.", GetPlayerNameEx(playerid), StoreItems[item-1], number_format(price));
			SendClientMessage(offerer, COLOR_GRAD2, string);
			format(string,sizeof(string),"* Ban da mua  %s tu %s voi gia $%s.", StoreItems[item-1], GetPlayerNameEx(offerer), number_format(price));
			SendClientMessage(playerid, COLOR_GRAD2, string);
			DeletePVar(playerid, "Business_ItemType");
			DeletePVar(playerid, "Business_ItemPrice");
			DeletePVar(playerid, "Business_ItemOfferer");
			DeletePVar(playerid, "Business_ItemOffererSQLId");
		}
	}
	return 1;
}


stock DisplayItemPricesDialog(businessid, playerid)
{

	new szDialog[612], pvar[25], iListIndex, i;
	if (Businesses[businessid][bType] == BUSINESS_TYPE_STORE || Businesses[businessid][bType] == BUSINESS_TYPE_GASSTATION) i = sizeof(StoreItems);
	if (Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP) i = sizeof(SexItems);
	if (Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT) i = sizeof(RestaurantItems);

	for(new item; item < i; item++)
	{
	    if(Businesses[businessid][bItemPrices][item] == 0) continue;
		new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(Businesses[businessid][bItemPrices][item] * 0.8)) : (Businesses[businessid][bItemPrices][item]);
	    if(Businesses[businessid][bType] == BUSINESS_TYPE_STORE || Businesses[businessid][bType] == BUSINESS_TYPE_GASSTATION) format(szDialog, sizeof(szDialog), "%s%s\t\t\t$%s\n", szDialog, StoreItems[item], number_format(cost));
	    else if(Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP) format(szDialog, sizeof(szDialog), "%s%s\t\t\t$%s\n", szDialog, SexItems[item], number_format(cost));
	    else if(Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT) format(szDialog, sizeof(szDialog), "%s%s\t\t\t$%s\n", szDialog, RestaurantItems[item], number_format(cost));
		format(pvar, sizeof(pvar), "Business_MenuItem%d", iListIndex);
		SetPVarInt(playerid, pvar, item + 1);
	    format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", iListIndex++);
		SetPVarInt(playerid, pvar, Businesses[businessid][bItemPrices][item]);
	}

   	if(strlen(szDialog) == 0) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang khong ban bat ky mat hang nay nua!");
    }
    else {
        if (Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP)
        {
			ShowPlayerDialogEx(playerid, SHOPMENU, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Mua", "Huy");
        }
		else if (Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT)
		{
			ShowPlayerDialogEx(playerid, RESTAURANTMENU2, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Mua", "Huy");
		}
        else
        {
    		ShowPlayerDialogEx(playerid, STOREMENU, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Mua", "Huy");
		}
    }
}

stock IsAt247(playerid)
{
    new iBusiness = InBusiness(playerid);
   	return (iBusiness != INVALID_BUSINESS_ID && (Businesses[iBusiness][bType] == BUSINESS_TYPE_STORE || Businesses[iBusiness][bType] == BUSINESS_TYPE_GASSTATION));
}

stock IsAtCasino(playerid)
{
    new iBusiness = InBusiness(playerid);
   	return (iBusiness != INVALID_BUSINESS_ID && (Businesses[iBusiness][bType] == BUSINESS_TYPE_CASINO));
}

stock IsAtClothingStore(playerid)
{
    new iBusiness = InBusiness(playerid);
   	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_CLOTHING);
}

stock IsAtRestaurant(playerid)
{
	new iBusiness = InBusiness(playerid);
	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT);
}

stock IsAtGym(playerid)
{
	new iBusiness = InBusiness(playerid);
	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_GYM);
}

stock StopRefueling(playerid, iBusinessID, iPumpID)
{

	new
		iCost = floatround(Businesses[iBusinessID][GasPumpSalePrice][iPumpID]),
		iVehicleID = Businesses[iBusinessID][GasPumpVehicleID][iPumpID],
		string[128];

	format(string, sizeof(string), "Xe cua ban da duoc do day lai cho $%d.", iCost);

	if( DynVeh[iVehicleID] != -1)
	{
	    DynVehicleInfo[DynVeh[iVehicleID]][gv_fFuel] = VehicleFuel[iVehicleID];
	    DynVeh_Save(DynVeh[iVehicleID]);
	}
	if(IsDynamicCrateVehicle(iVehicleID) != -1) {
		SaveCrateVehicle(IsDynamicCrateVehicle(iVehicleID));
	}
	if (DynVeh[iVehicleID] != -1 && DynVehicleInfo[DynVeh[iVehicleID]][gv_igID] != INVALID_GROUP_ID)
 	{
 		new iGroupID = DynVehicleInfo[DynVeh[iVehicleID]][gv_igID];
		arrGroupData[iGroupID][g_iBudget] -= iCost;
		new str[128];
        format(str, sizeof(str), "%s da tiep nhien lieu xe %d voi chi phi $%d to %s's quy ngan sach.", GetPlayerNameEx(playerid), iVehicleID, iCost, arrGroupData[iGroupID][g_szGroupName]);
		GroupPayLog(iGroupID, str);
 		SendClientMessageEx(playerid, COLOR_GREY, "Day la mot chiec xe nhom va chi phi tiep nhien lieu duoc chinh phu tra.");
	}
	else GivePlayerCash(playerid, -iCost);

	Businesses[iBusinessID][bSafeBalance] += TaxSale(iCost);

	KillTimer(Businesses[iBusinessID][GasPumpTimer][iPumpID]);

	SendClientMessageEx(playerid, COLOR_WHITE, string);

	new vehicleslot = GetPlayerVehicle(playerid, iVehicleID);

	// Save Fuel to MySQL
	if(vehicleslot != -1) {
	    PlayerVehicleInfo[playerid][vehicleslot][pvFuel] = VehicleFuel[iVehicleID];
		mysql_format(MainPipeline, string, sizeof(string), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d'", VehicleFuel[iVehicleID], PlayerVehicleInfo[playerid][vehicleslot][pvSlotId]);
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	}

	Businesses[iBusinessID][GasPumpVehicleID][iPumpID] = 0;

	DeletePVar(playerid, "Refueling");

	format(string,sizeof(string),"%s(%d) (IP: %s) da tiep nhien lieu cho xe cua ho $%d tai %s (%d)",GetPlayerNameEx(playerid),GetPlayerSQLId(playerid),GetPlayerIpEx(playerid),iCost,Businesses[iBusinessID][bName], iBusinessID);
	Log("logs/business.log", string);

	return true;
}

stock GetCarBusiness(carid)
{
    for(new b = 0; b < MAX_BUSINESSES; b++)
    {
	    for(new i = 0; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
	    {
	        if (Businesses[b][bVehID][i] == carid) return b;
	    }
	}
	return INVALID_BUSINESS_ID;
}

stock GetBusinessCarSlot(carid)
{
    for(new b = 0; b < MAX_BUSINESSES; b++)
    {
	    for(new i = 0; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
	    {
	        if (Businesses[b][bVehID][i] == carid) return i;
	    }
	}
	return INVALID_BUSINESS_ID;
}

stock IsValidBusinessID(id)
{
	if(id == INVALID_BUSINESS_ID) return 0;
	else if(id >= 0 && id < MAX_BUSINESSES) return 1;
	return 0;
}

stock DestroyDynamicGasPump(iBusiness, iPump)
{
	DestroyDynamicObject(Businesses[iBusiness][GasPumpObjectID][iPump]);
	DestroyDynamic3DTextLabel(Businesses[iBusiness][GasPumpInfoTextID][iPump]);
	DestroyDynamic3DTextLabel(Businesses[iBusiness][GasPumpSaleTextID][iPump]);

	#if defined TEXTLABEL_DEBUG
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Businesses[iBusiness][GasPumpInfoTextID][iPump], E_STREAMER_EXTRA_ID, 10);
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Businesses[iBusiness][GasPumpSaleTextID][iPump], E_STREAMER_EXTRA_ID, 1);
	#endif
}

stock CreateDynamicGasPump(iPlayerID = INVALID_PLAYER_ID, iBusiness, iPump)
{
	if (iPlayerID != INVALID_PLAYER_ID)
	{
		new Float: arr_fPos[4];
		GetPlayerPos(iPlayerID, arr_fPos[0], arr_fPos[1], arr_fPos[2]);
		GetPlayerFacingAngle(iPlayerID, arr_fPos[3]);
		Businesses[iBusiness][GasPumpPosX][iPump] = arr_fPos[0];
		Businesses[iBusiness][GasPumpPosY][iPump] = arr_fPos[1];
		Businesses[iBusiness][GasPumpPosZ][iPump] = arr_fPos[2] + 0.4;
		Businesses[iBusiness][GasPumpAngle][iPump] = arr_fPos[3];
	}
	new szLabel[148];
	Businesses[iBusiness][GasPumpObjectID][iPump] = CreateDynamicObject(1676, Businesses[iBusiness][GasPumpPosX][iPump], Businesses[iBusiness][GasPumpPosY][iPump], Businesses[iBusiness][GasPumpPosZ][iPump], 0, 0, Businesses[iBusiness][GasPumpAngle][iPump], .worldid = 0, .streamdistance = 100);
	format(szLabel, sizeof(szLabel), "{33AA33}Gas Pump\nID: %d\n{FFFF00}Nhap '/bomxang' de bom xang cho phuong tien.", iPump);
	Businesses[iBusiness][GasPumpInfoTextID][iPump] = CreateDynamic3DTextLabel(szLabel, COLOR_YELLOW, Businesses[iBusiness][GasPumpPosX][iPump], Businesses[iBusiness][GasPumpPosY][iPump], Businesses[iBusiness][GasPumpPosZ][iPump] - 0.3, 10.00);
	format(szLabel, sizeof(szLabel), "Price Per Gallon: $%.2f\nThis Sale: $0.00\nGallons: 0.000\nGas Available: %.2f/%.2f gallons", Businesses[iBusiness][bGasPrice], Businesses[iBusiness][GasPumpGallons][iPump], Businesses[iBusiness][GasPumpCapacity][iPump]);
	Businesses[iBusiness][GasPumpSaleTextID][iPump] = CreateDynamic3DTextLabel(szLabel, COLOR_YELLOW, Businesses[iBusiness][GasPumpPosX][iPump], Businesses[iBusiness][GasPumpPosY][iPump], Businesses[iBusiness][GasPumpPosZ][iPump] + 0.7, 10.00);
}

stock RefreshBusinessPickup(i)
{
	DestroyDynamic3DTextLabel(Businesses[i][bDoorText]);
  	DestroyDynamic3DTextLabel(Businesses[i][bStateText]);
  	DestroyDynamic3DTextLabel(Businesses[i][bSupplyText]);

  	#if defined TEXTLABEL_DEBUG
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Businesses[i][bDoorText], E_STREAMER_EXTRA_ID, 2);
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Businesses[i][bStateText], E_STREAMER_EXTRA_ID, 3);
	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Businesses[i][bSupplyText], E_STREAMER_EXTRA_ID, 4);
	#endif


  	DestroyDynamicPickup(Businesses[i][bPickup]);
  	DestroyDynamicPickup(Businesses[i][bPickup_int]);
  	if(IsValidDynamicArea(Businesses[i][bAreaID][0])) DestroyDynamicArea(Businesses[i][bAreaID][0]);
  	if(IsValidDynamicArea(Businesses[i][bAreaID][1])) DestroyDynamicArea(Businesses[i][bAreaID][1]);

    if (!(Businesses[i][bExtPos][0] == 0.0 && Businesses[i][bExtPos][1] == 0.0 && Businesses[i][bExtPos][2] == 0.0)) {

		Businesses[i][bPickup] = CreateDynamicPickup(GetBusinessDefaultPickup(i), 23, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]);
		Businesses[i][bAreaID][0] = CreateDynamicSphere(Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2], 2.5);

        if (Businesses[i][bOwner] < 1) {
			format(szMiscArray,sizeof(szMiscArray),"Business (%d)\nCua hang: %s\nCua hang dang duoc ban!\nGia cua hang: %s", i, GetBusinessTypeName(Businesses[i][bType]), number_format(Businesses[i][bValue]));
		}
		else {
		    if(Businesses[i][bType] != BUSINESS_TYPE_GYM) {
				format(szMiscArray,sizeof(szMiscArray),"Business (%d)\nCua hang: %s\n%s\n Chu so huu: %s", i, GetBusinessTypeName(Businesses[i][bType]), Businesses[i][bName], StripUnderscore(Businesses[i][bOwnerName]));
			}
			else {
			    format(szMiscArray,sizeof(szMiscArray),"Business (%d)\nCua hang: %s\n%s\nChu so huu: %s\nGia ra vao: $%s", i, GetBusinessTypeName(Businesses[i][bType]), Businesses[i][bName], StripUnderscore(Businesses[i][bOwnerName]), number_format(Businesses[i][bGymEntryFee]));
			}
		}
		Businesses[i][bDoorText] =	CreateDynamic3DTextLabel(szMiscArray, BUSINESS_NAME_COLOR, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2] + 0.85, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1);
		Businesses[i][bStateText] =	CreateDynamic3DTextLabel((Businesses[i][bStatus]) ? ("Dang mo") : ("Da dong"), (Businesses[i][bStatus]) ? BUSINESS_OPEN_COLOR : BUSINESS_CLOSED_COLOR, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2] + 1.05, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1);
		if(Businesses[i][bSupplyPos][0] != 0.0)
		{
			format(szMiscArray,sizeof(szMiscArray),"%s\nDiem giao hang", Businesses[i][bName]);
			Businesses[i][bSupplyText] = CreateDynamic3DTextLabel(szMiscArray, BUSINESS_NAME_COLOR, Businesses[i][bSupplyPos][0], Businesses[i][bSupplyPos][1], Businesses[i][bSupplyPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1);
		}
	}
	if(Businesses[i][bVW] == 0)	{

		Businesses[i][bPickup_int] = CreateDynamicPickup(1559, 23, Businesses[i][bIntPos][0], Businesses[i][bIntPos][1], Businesses[i][bIntPos][2], .worldid = BUSINESS_BASE_VW + i);
		Businesses[i][bAreaID][1] = CreateDynamicSphere(Businesses[i][bIntPos][0], Businesses[i][bIntPos][1], Businesses[i][bIntPos][2], 2.5, .worldid = BUSINESS_BASE_VW + i);
	}
	else {

		Businesses[i][bPickup_int] = CreateDynamicPickup(1559, 23, Businesses[i][bIntPos][0], Businesses[i][bIntPos][1], Businesses[i][bIntPos][2], .worldid = Businesses[i][bVW]);
		Businesses[i][bAreaID][1] = CreateDynamicSphere(Businesses[i][bIntPos][0], Businesses[i][bIntPos][1], Businesses[i][bIntPos][2], 2.5, .worldid = Businesses[i][bVW]);
	}

	/*
	Streamer_SetIntData(STREAMER_TYPE_AREA, Businesses[i][bAreaID][0], E_STREAMER_EXTRA_ID, i);
	Streamer_SetIntData(STREAMER_TYPE_AREA, Businesses[i][bAreaID][1], E_STREAMER_EXTRA_ID, i);
	*/

	format(szMiscArray, sizeof(szMiscArray), "[Business] Created Business: %d | Exterior Area ID: %d | Interior Area ID: %d", i, Businesses[i][bAreaID][0], Businesses[i][bAreaID][1]);
	Log("debug/door_business.log", szMiscArray);

}


stock GetBusinessDefaultPickup(business)
{
	switch (Businesses[business][bType]) {
		case BUSINESS_TYPE_GASSTATION: return 1650;
		case BUSINESS_TYPE_CLOTHING: return 1275;
		case BUSINESS_TYPE_RESTAURANT: return 19094;
		case BUSINESS_TYPE_SEXSHOP: return 321;
		case BUSINESS_TYPE_BAR:
		{
		    new rnd = random(4);
		    if (rnd == 0) return 1486;
		    if (rnd == 1) return 1543;
		    if (rnd == 2) return 1544;
		    if (rnd == 3) return 1951;
		}
		case BUSINESS_TYPE_GYM: return 1318;
		default: return 1274;
	}
	return 1318;
}

stock GetBusinessRankName(rank)
{
	new string[16];
	switch (rank) {
		case 0: string = "Trainee";
		case 1: string = "Employee";
		case 2: string = "Senior Employee";
		case 3: string = "Manager";
		case 4: string = "Co-Owner";
		case 5: string = "Owner";
		default: string = "Undefined";
	}
	return string;
}

stock GetBusinessTypeName(type)
{
	new string[20];
	switch (type) {
		case 1: string = "Tram xang";
		case 2: string = "Quan ao";
		case 3: string = "Nha hang";
		case 4: string = "Ban vu khi";
		case 5: string = "Dai ly xe moi";
		case 6: string = "Dai ly xe cu";
		case 7: string = "Sua xe";
		case 8: string = "24/7";
		case 9: string = "Bar";
		case 10: string = "Club";
		case 11: string = "Sex Shop";
		case 12: string = "Gym";
		case 13: string = "Casino";
		default: string = "Undefined";
	}
	return string;
}

stock GetInventoryType(businessid)
{
	new string[30];
	if(businessid == INVALID_BUSINESS_ID) {
        string = "Empty";
		return string;
	}
	switch (Businesses[businessid][bType]) {
		case BUSINESS_TYPE_NEWCARDEALERSHIP: string = "Vehicles";
		case BUSINESS_TYPE_GASSTATION: string = "Petrol";
		case BUSINESS_TYPE_GUNSHOP: string = "Illegal Materials";
		case BUSINESS_TYPE_MECHANIC: string = "Car Parts";
		case BUSINESS_TYPE_STORE: string = "24/7 Items";
		case BUSINESS_TYPE_CLOTHING: string = "Clothing";
		case BUSINESS_TYPE_RESTAURANT, BUSINESS_TYPE_BAR, BUSINESS_TYPE_CLUB: string = "Food & Beverages";
		default: string = "Empty";
	}
	return string;
}

stock GetSupplyState(stateid)
{
	new string[28];
	switch (stateid)	{
		case 0: string = "{FF3333}Inactive";
		case 1: string = "{FFFF00}Pending Shipment";
		case 2: string = "{FFAA00}Shipping";
		case 3: string = "{00AA00}Delivered";
		case 4: string = "{FF3333}Cancelled";
		default: string = "Undefined";
	}
	return string;
}

stock InBusiness(playerid)
{
    if(GetPVarType(playerid, "BusinessesID")) return GetPVarInt(playerid, "BusinessesID");
    else return INVALID_BUSINESS_ID;
}

stock GetClosestGasPump(playerid, &businessid, &pumpslot)
{
	new Float: minrange = 5.0, Float: range;

	businessid = INVALID_BUSINESS_ID;

    for(new b = 0; b < MAX_BUSINESSES; b++)
    {
	    for(new i = 0; i < MAX_BUSINESS_GAS_PUMPS; i++)
	    {
	        range = GetPlayerDistanceFromPoint(playerid, Businesses[b][GasPumpPosX][i], Businesses[b][GasPumpPosY][i], Businesses[b][GasPumpPosZ][i]);
	 	    if (range < minrange)
			{
				businessid = b;
				pumpslot = i;
			    minrange = range;
		    }
	   	}
 	}
}

stock IsBusinessGasAble(iBusinessType) {
 	switch (iBusinessType) {
 		case 1,7,8: return 1;
	}
	return 0;
}

stock GetFreeGasPumpID(biz)
{
    for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
		if (Businesses[biz][GasPumpPosX][i] == 0.0) return i;
	}
	return INVALID_GAS_PUMP;
}

forward GasPumpSaleTimer(playerid, iBusinessID, iPumpID);
public GasPumpSaleTimer(playerid, iBusinessID, iPumpID)
{
	new
		Float: fPumpAmount = FUEL_PUMP_RATE / 4,
		iVehicleID = Businesses[iBusinessID][GasPumpVehicleID][iPumpID],
		szSaleText[148];

	if (GetVehicleDistanceFromPoint(iVehicleID, Businesses[iBusinessID][GasPumpPosX][iPumpID], Businesses[iBusinessID][GasPumpPosY][iPumpID], Businesses[iBusinessID][GasPumpPosZ][iPumpID]) > 5.0)
	{
	    StopRefueling(playerid, iBusinessID, iPumpID);
		return 1;
	}
	if (fPumpAmount*10 + VehicleFuel[iVehicleID] > 100.0)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "Xe cua ban da day xang.");
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}
	if (GetPVarInt(playerid, "Refueling") == -1)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "Ban da ngung tiep nhien lieu.");
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}
	if (fPumpAmount > Businesses[iBusinessID][GasPumpGallons][iPumpID])
	{
		SendClientMessageEx(playerid, COLOR_RED, "Khong con gas trong bom xang cua tram.");
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}
	if(DynVeh[iVehicleID] != -1 && DynVehicleInfo[DynVeh[iVehicleID]][gv_igID] != INVALID_GROUP_ID) {
		if(arrGroupData[DynVehicleInfo[DynVeh[iVehicleID]][gv_igID]][g_iBudget] < floatround(Businesses[iBusinessID][GasPumpSalePrice][iPumpID])) {
			SendClientMessageEx(playerid, COLOR_RED, "Chiec xe thuoc nhom nay da di het tien!");
		    StopRefueling(playerid, iBusinessID, iPumpID);
		    return 1;
		}
	}
	else {
		if(GetPlayerCash(playerid) < floatround(Businesses[iBusinessID][GasPumpSalePrice][iPumpID])) {
			SendClientMessageEx(playerid, COLOR_RED, "Ban het tien.");
		    StopRefueling(playerid, iBusinessID, iPumpID);
		    return 1;
		}
	}

	Businesses[iBusinessID][GasPumpGallons][iPumpID] -= fPumpAmount;
	VehicleFuel[iVehicleID] += fPumpAmount*10;
	Businesses[iBusinessID][GasPumpSaleGallons][iPumpID] += fPumpAmount;
	Businesses[iBusinessID][GasPumpSalePrice][iPumpID] += fPumpAmount * Businesses[iBusinessID][bGasPrice];

	format(szSaleText,sizeof(szSaleText),"Gia cho moi Gallon: $%.2f\nThis Sale: $%.2f\nGallons: %.3f\nGas Available: %.2f/%.2f gallons", Businesses[iBusinessID][bGasPrice], Businesses[iBusinessID][GasPumpSalePrice][iPumpID], Businesses[iBusinessID][GasPumpSaleGallons][iPumpID], Businesses[iBusinessID][GasPumpGallons][iPumpID], Businesses[iBusinessID][GasPumpCapacity][iPumpID]);
	UpdateDynamic3DTextLabelText(Businesses[iBusinessID][GasPumpSaleTextID][iPumpID], COLOR_YELLOW, szSaleText);
	return 1;
}

stock GetWeaponPrice(business, id)
{
	for (new i; i < sizeof(Weapons); i++)
	{
		if (Weapons[i][WeaponId] == id) return Businesses[business][bItemPrices][i];
	}
	return 0;
}

CMD:businessdate(playerid, params[]) {
	new giveplayerid;
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    giveplayerid = playerid;
	}
	else
	{
	    if(sscanf(params, "u", giveplayerid)) giveplayerid = playerid;
	}
	if(IsValidBusinessID(PlayerInfo[playerid][pBusiness]))
	{
	    new string[128];
	    new datestring[32];
		datestring = date(Businesses[PlayerInfo[giveplayerid][pBusiness]][bMonths], 4);
		if(Businesses[PlayerInfo[giveplayerid][pBusiness]][bMonths] == 0) format(string, sizeof(string), "* Your business subscription is not set to expire.");
		else format(string, sizeof(string), "* Dang ky business kinh doanh cua ban het han vao %s.", datestring);
	    SendClientMessageEx(playerid, COLOR_VIP, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dang ky kinh doanh.");
	return 1;
}

CMD:businesshelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"____________________TRO GIUP CUA HANG____________________");
	SendClientMessageEx(playerid, COLOR_GRAD3,"[!]LENH: /buybizlevel /binvite /buninvite /bouninvite /bgiverank /resign /bsafe");
	SendClientMessageEx(playerid, COLOR_GRAD3,"[!]LENH: /binventory /offeritem /resupply /checkresupply /cancelresupply /minrank");
	SendClientMessageEx(playerid, COLOR_GRAD3,"[!]LENH: /employeepayset /employeeautopay /editgasprice /editprices /bizlock");
	SendClientMessageEx(playerid, COLOR_GRAD3,"[!]LENH: /buybiz /sellbiz /bauto /bonline /bpanic /b(iz)r(adio)");
	if(IsValidBusinessID(PlayerInfo[playerid][pBusiness]))
	{
		if(Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP || Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_OLDCARDEALERSHIP) {
			SendClientMessageEx(playerid, COLOR_GRAD3, "[!]LENH: /editcarprice /editcarspawn");
		}
		else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_GUNSHOP) {
		    SendClientMessageEx(playerid, COLOR_GRAD3, "[!]LENH: /addmat(erial)s");
		}
		else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_STORE) {
		    SendClientMessageEx(playerid, COLOR_GRAD3, "[!]LENH: /offeritem /editprices");
		}
		else if (Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_BAR || Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_CLUB || Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_RESTAURANT) {
	        SendClientMessageEx(playerid, COLOR_GRAD3, "[!]LENH: /offermenu");
	    }
	}
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] > 0 || PlayerInfo[playerid][pBM] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD3, "[!]LENH ADMIN: /bedit /bname (ST) /bnext (ST) /bnear (ST) /gotobiz (ST) /goinbiz (ST)");
		SendClientMessageEx(playerid, COLOR_GRAD3, "[!]LENH ADMIN: /deletegaspump /asellbiz /creategaspump /editgaspump");
	}
    return 1;
}

CMD:bhelp(playerid, params[]) {
	return callcmd::businesshelp(playerid, params);
}

CMD:bonline(playerid, params[]) {
	new iBusinessID = PlayerInfo[playerid][pBusiness];
    if((0 <= iBusinessID < MAX_BUSINESSES) && PlayerInfo[playerid][pBusinessRank] >= Businesses[iBusinessID][bMinInviteRank])
	{
		new szDialog[1024];
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pBusiness] == PlayerInfo[playerid][pBusiness] && (PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2))
			{
				format(szDialog, sizeof(szDialog), "%s\n* %s (%s)", szDialog, GetPlayerNameEx(i), GetBusinessRankName(PlayerInfo[i][pBusinessRank]));
			}
		}
		if(!isnull(szDialog)) {
		    strdel(szDialog, 0, 1);
			ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_LIST, "Nhan vien truc tuyen", szDialog, "Chon", "Huy");
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co nhan vien cua hang nao dang truc tuyen.");
    }
	else SendClientMessageEx(playerid, COLOR_GREY, "Chi co chu so huu cua hang moi co the su dung lenh nay!");
    return 1;
}

CMD:buy(playerid, params[])
{
   	if (!IsAt247(playerid)) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung tai cua hang 24/7!");
        return 1;
    }

	new iBusiness = InBusiness(playerid);

    if (Businesses[iBusiness][bAutoSale]) {
		if (Businesses[iBusiness][bInventory] < 1) {
			SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang nay khong co bat ky mat hang nao vao luc nay!");
			return 1;
		}
		if (!Businesses[iBusiness][bStatus]) {
			SendClientMessageEx(playerid, COLOR_WHITE, "Cua hang nay hien dang Dong cua!");
			return 1;
		}
	} else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can tuong tac voi nhan vien kinh doanh de mua.");

	DisplayItemPricesDialog(iBusiness, playerid);

    return 1;
}

CMD:beginswimming(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trong Gym!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	if(CheckPointCheck(playerid))
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "Hay xoa muc tieu truoc khi thuc hien danh dau muc tieu. (/xoamuctieu)");
	}
	if (Businesses[iBusiness][bGymType] != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Gym nay khong the boi duoc.");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingQueue") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang trong tran dau boxing. (/roiboxing)");
		return 1;
	}

	if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang trong qua trinh boi. (/dungboi).");
		return 1;
	}

	SetPVarInt(playerid, "_SwimmingActivity", 1);
	SetPlayerCheckpoint(playerid, 2892.5071, -2261.9607, 1.4645, 2.0);
	SendClientMessageEx(playerid, COLOR_WHITE, "Bat dau boi! Hay boi den nhung diem mau do!.");
	SendClientMessageEx(playerid, COLOR_WHITE, "Nhap (/dungboi) de dung boi.");
	/*if(!PlayerInfo[playerid][mCooldown][4] && !PlayerInfo[playerid][pShopNotice])
	{
		PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[10]);
		PlayerTextDrawShow(playerid, MicroNotice[playerid]);
		SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
	}*/
	return 1;
}

CMD:stopswimming(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trong Gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_SwimmingActivity") < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Hien tai ban khong co boi!");
		return 1;
	}

	DeletePVar(playerid, "_SwimmingActivity");
	DisablePlayerCheckpoint(playerid);

	SendClientMessageEx(playerid, COLOR_GREY, "Ban da dung bai tap boi.");

	return 1;
}

CMD:joinboxing(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trong Gym!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	if (Businesses[iBusiness][bGymType] != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the (/joinboxing) o Gym nay!");
		return 1;
	}

	if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang trong qua trinh boi. (/dungboi).");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingQueue") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang xep hang thi dau boxing roi!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingFight") != 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang trong tran dau boxing roi!");
		return 1;
	}

	SetPVarInt(playerid, "_BoxingQueue", 1);
	SetPVarInt(playerid, "_BoxingQueueTick", 1);

	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da xep hang dau boxing, hay cho nguoi khac.");

	return 1;
}

CMD:leaveboxing(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trong Gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingQueue") != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " Ban khong dung tai diem thi dau boxing.");
		return 1;
	}

	DeletePVar(playerid, "_BoxingQueue");
	DeletePVar(playerid, "_BoxingQueueTick");

	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da thoat xep hang dau boxing.");

	return 1;
}

CMD:beginparkour(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trong Gym!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	if (Businesses[iBusiness][bGymType] != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not /beginparkour in this type of gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BikeParkourStage") != 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are already participating in that activity!");
		return 1;
	}

	new bool:available = false;
	new pos;

	for (new it = 0; it < 9; ++it)
	{
		if (Businesses[iBusiness][bGymBikePlayers][it] == INVALID_PLAYER_ID)
		{
			available = true;
			Businesses[iBusiness][bGymBikePlayers][it] = playerid;
			pos = it;
			break;
		}
	}

	if (available == false)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  Too many people are on this track, try again later.");
		return 1;
	}

	SendClientMessage(playerid, COLOR_WHITE, "Proceed to the pickup point to collect your bike.");
	SetPVarInt(playerid, "_BikeParkourStage", 1);
	SetPVarInt(playerid, "_BikeParkourSlot", pos);
	new pickup = CreateDynamicPickup(1318, 23, 2833.8757, -2256.8293, 95.9497, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
	SetPVarInt(playerid, "_BikeParkourPickup", pickup);
	/*if(!PlayerInfo[playerid][mCooldown][4] && !PlayerInfo[playerid][pShopNotice])
	{
		PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[10]);
		PlayerTextDrawShow(playerid, MicroNotice[playerid]);
		SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
	}*/
	return 1;
}

CMD:leaveparkour(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong trong Gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BikeParkourStage") == 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not participating in that activity.");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	Businesses[iBusiness][bGymBikePlayers][GetPVarInt(playerid, "_BikeParkourSlot")] = INVALID_PLAYER_ID;

	SendClientMessageEx(playerid, COLOR_WHITE, "You have left the biking activity.");

	new vehicle = Businesses[iBusiness][bGymBikeVehicles][GetPVarInt(playerid, "_BikeParkourSlot")];

	if (vehicle != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(vehicle);
		Businesses[iBusiness][bGymBikeVehicles][GetPVarInt(playerid, "_BikeParkourSlot")] = INVALID_VEHICLE_ID;
	}

	DeletePVar(playerid, "_BikeParkourStage");
	DeletePVar(playerid, "_BikeParkourSlot");

	new pickup = GetPVarInt(playerid, "_BikeParkourPickup");
	if (pickup != 0)
	{
		DestroyDynamicPickup(pickup);
		DeletePVar(playerid, "_BikeParkourPickup");
	}

	return 1;
}

CMD:bauto(playerid, params[])
{
   	new
	   iBusiness = PlayerInfo[playerid][pBusiness],
	   iRank     = PlayerInfo[playerid][pBusinessRank];

	if (iBusiness != INVALID_BUSINESS_ID && iRank >= 5)
	{
	    new iType = Businesses[iBusiness][bType];
	    if (iType == BUSINESS_TYPE_GASSTATION || iType == BUSINESS_TYPE_STORE || iType == BUSINESS_TYPE_CLOTHING) {
			if (Businesses[iBusiness][bAutoSale])	{
				Businesses[iBusiness][bAutoSale] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban da tat che do ban hang tu dong!");
				SaveBusiness(iBusiness);
			}
			else {
				Businesses[iBusiness][bAutoSale] = 1;
		       	SendClientMessageEx(playerid, COLOR_WHITE, "Ban da bat che do ban hang tu dong!");
		       	SendClientMessageEx(playerid, COLOR_GREY, "Luu y: Neu bat cua hang se giam loi nhuan.");
		       	SaveBusiness(iBusiness);
			}
	    }  else SendClientMessageEx(playerid, COLOR_WHITE, "Lenh nay khong su dung cho the loai kinh doanh cua ban.");
	} else SendClientMessageEx(playerid, COLOR_WHITE, "Chi co chu so huu cua hang moi co the su dung lenh nay");
	return 1;
}

CMD:shop(playerid, params[])
{

	new iBusiness = InBusiness(playerid);

   	if (iBusiness == INVALID_BUSINESS_ID || Businesses[iBusiness][bType] != BUSINESS_TYPE_SEXSHOP) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung tai cua hang Sextoy!");
        return 1;
    }
    if (Businesses[iBusiness][bAutoSale]) {
		if (Businesses[iBusiness][bInventory] < 1) {
		    SendClientMessageEx(playerid, COLOR_WHITE, "Hien tai cac mat hang cua cua hang da het");
		    return 1;
		}
		if (!Businesses[iBusiness][bStatus]) {
		    SendClientMessageEx(playerid, COLOR_WHITE, "Hien tai cua hang nay da Dong cua!");
		    return 1;
		}
	} else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can tuong tac voi nhan vien kinh doanh de mua.");

	DisplayItemPricesDialog(iBusiness, playerid);

    return 1;
}

CMD:refuel(playerid, params[])
{
	if(zombieevent) return SendClientMessageEx(playerid, -1, "You can't use Gas Stations during the Zombie Event!");
    if (GetPVarType(playerid, "Refueling"))
	{
	    SetPVarInt(playerid, "Refueling", -1);
	}
	else
	{

	    new vehicleid = GetPlayerVehicleID(playerid);

		new
			iBusinessID,
			iPumpID;

		GetClosestGasPump(playerid, iBusinessID, iPumpID);

		if (iBusinessID == INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_RED, "Ban khong dung tai Tram xang dau.");
		if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_RED, "Ban khong dung tai chiec xe.");
		if (!Businesses[iBusinessID][bStatus]) return SendClientMessageEx(playerid, COLOR_RED, "Tram xang nay da dong cua.");
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_RED, "You're not the driver.");
		if (IsVIPcar(vehicleid)) return SendClientMessageEx(playerid, COLOR_RED, "Day la phuong tien VIP ban khong the bom xang cho no, xe VIP se khong bao gio het xang.");
		if (IsFamedVeh(vehicleid)) return SendClientMessageEx(playerid, COLOR_RED, "Day la phuong tien Famed ban khong the bom xang cho no, xe Famed se khong bao gio het xang.");
		if (IsAdminSpawnedVehicle(vehicleid)) return SendClientMessageEx(playerid, COLOR_RED, "Day la phuong tien Admin da tao ra ban khong the bom xang cho no, xe Admin tao ra se khong bao gio het xang.");
	    new engine,lights,alarm,doors,bonnet,boot,objective;
    	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	    if(engine == VEHICLE_PARAMS_ON) return SendClientMessageEx(playerid, COLOR_RED, "Ban can phai tat dong co phuong tien moi co the bom xang (nhan phim ~k~~CONVERSATION_YES~).");
     	if (Businesses[iBusinessID][GasPumpGallons][iPumpID] == 0.0) return SendClientMessageEx(playerid, COLOR_RED, "Tram xang nay khong con xang.");
	    if (!IsRefuelableVehicle(vehicleid)) return SendClientMessageEx(playerid,COLOR_RED,"Phuong tien nay khong can xang.");
	    if (VehicleFuel[vehicleid] >= 100.0) return SendClientMessageEx(playerid, COLOR_RED, "Phuong tien nay da co day xang roi.");
	    if (Businesses[iBusinessID][GasPumpVehicleID][iPumpID] > 0) return SendClientMessageEx(playerid, COLOR_RED, "This gas pump is occupied.");

       	SendClientMessageEx(playerid, COLOR_WHITE, "Phuong tien dang duoc bom xang vao, hay cho mot lat...");
       	SendClientMessageEx(playerid, COLOR_WHITE, "Nhap {F7C741}/bomxang{FFFFFF} mot lan nua de ngung bom xang.");

		SetPVarInt(playerid, "Refueling", vehicleid);
       	Businesses[iBusinessID][GasPumpSaleGallons][iPumpID] = 0;
       	Businesses[iBusinessID][GasPumpSalePrice][iPumpID] = 0;
       	Businesses[iBusinessID][GasPumpVehicleID][iPumpID] = vehicleid;
       	Businesses[iBusinessID][GasPumpTimer][iPumpID] = SetTimerEx("GasPumpSaleTimer", 200, true, "iii", playerid, iBusinessID, iPumpID);
	}
	return 1;
}

CMD:editcarspawn(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own chiec xe dealership.");
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 20.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2])) {
		SendClientMessageEx(playerid, COLOR_GREY, "The location needs to be near the business entrance.");
	}
	else if(PlayerInfo[playerid][pBusinessRank] < 5) {
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't high enough rank to edit the car dealership.");
	}
	else {
		new Float: Positionsz[4];
		GetPlayerPos(playerid, Positionsz[0], Positionsz[1], Positionsz[2]);
		GetPlayerFacingAngle(playerid, Positionsz[3]);
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseX] = Positionsz[0];
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseY] = Positionsz[1];
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseZ] = Positionsz[2];
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseAngle] = Positionsz[3];
		SendClientMessageEx(playerid, COLOR_WHITE, "You have moved the vehicle purchase spawn location.");
		SaveDealershipSpawn(PlayerInfo[playerid][pBusiness]);
	}
	return 1;
}

CMD:entrancefee(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GYM) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a gym.");
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 5.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2])) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai standing near the gym entrance.");
	}
	else {
		new amount;
		if(sscanf(params, "d", amount)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /entrancefee [Price]");
		}
		else if(amount < 0 || amount > 10000) {
			return SendClientMessageEx(playerid, COLOR_GREY, "The price can't be set the price below $0 and above $10,000.");
		}

		else {
			new string[128];
			Businesses[PlayerInfo[playerid][pBusiness]][bGymEntryFee] = amount;
			format(string, sizeof(string), "You have set the gym entry fee to $%s.", number_format(amount));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			RefreshBusinessPickup(PlayerInfo[playerid][pBusiness]);
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
		}
	}
	return 1;
}

CMD:editcarprice(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own chiec xe dealership.");
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 5.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2])) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai standing near the dealership entrance.");
	}
	else if(PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinSupplyRank]) {
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't high enough rank to edit the car dealership.");
	}
	else {
		new vehicleid, amount;
		if(sscanf(params, "dd", vehicleid, amount)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editcarprice [VehicleID] [Price]");
		}
		else if(PlayerInfo[playerid][pBusiness] != GetCarBusiness(vehicleid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "That vehicle is not part of your dealership.");
		}
		else if(amount < 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "The price can't be set below 0");
		}
		else {

 			new
				iSlot = GetBusinessCarSlot(vehicleid),
				Message[128];

			Businesses[PlayerInfo[playerid][pBusiness]][bPrice][iSlot] = amount;
			format(Message, sizeof(Message), "%s For Sale | Price: $%s", GetVehicleName(Businesses[PlayerInfo[playerid][pBusiness]][bVehID][iSlot]), number_format(Businesses[PlayerInfo[playerid][pBusiness]][bPrice][iSlot]));
            UpdateDynamic3DTextLabelText(Businesses[PlayerInfo[playerid][pBusiness]][bVehicleLabel][iSlot], COLOR_LIGHTBLUE, Message);
			format(Message, sizeof(Message), "%s price has been set to $%s", GetVehicleName(vehicleid), number_format(amount));
			SendClientMessageEx(playerid, COLOR_WHITE, Message);
			SaveDealershipVehicle(PlayerInfo[playerid][pBusiness], iSlot);
		}
	}
	return 1;
}

CMD:deletecdveh(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pBM] == 2) {

		new
		    iBusiness,
			iVehicle;

		if(sscanf(params, "ii", iBusiness, iVehicle )) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deletecdveh [business ID] [model id]");
		}
		else if(Businesses[iBusiness][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[iBusiness][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Business is not a car dealership!");
		}
		else if(iBusiness != GetCarBusiness(iVehicle)) {
			SendClientMessageEx(playerid, COLOR_GREY, "That vehicle isn't a dealership vehicle.");
		}
		else {

			new
				ID = GetBusinessCarSlot(iVehicle);

			if(Businesses[iBusiness][bVehID][ID] != INVALID_VEHICLE_ID) {
			    if(IsValidDynamic3DTextLabel(Businesses[iBusiness][bVehicleLabel][ID])) DestroyDynamic3DTextLabel(Businesses[iBusiness][bVehicleLabel][ID]), Businesses[iBusiness][bVehicleLabel][ID] = Text3D:-1;
                DestroyVehicle(Businesses[iBusiness][bVehID][ID]);
               	Businesses[iBusiness][bModel][ID] = 0;
				Businesses[iBusiness][bParkPosX][ID] = 0;
  				Businesses[iBusiness][bParkPosY][ID] = 0;
			   	Businesses[iBusiness][bParkPosZ][ID] = 0;
		   	 	Businesses[iBusiness][bParkAngle][ID] = 0;
		   	 	Businesses[iBusiness][bVehID][ID] = 0;
		   	 	Businesses[iBusiness][bPrice][ID] = 0;
		   	 	SaveDealershipVehicle(iBusiness, ID);
	   	 		return 1;
       		}
			return SendClientMessageEx(playerid, COLOR_GREY, "The max number of vehicles for this business has been reached.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do.");
	return 1;
}

CMD:createcdveh(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pBM] == 2) {

		new
		    iBusiness,
			iVehicle,
			iColors[2];

		if(sscanf(params, "iiii", iBusiness, iVehicle, iColors[0], iColors[1])) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createcdveh [business ID] [model id] [color 1] [color 2]");
		}
		else if(!(400 <= iVehicle <= 611)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid model specified (model IDs start at 400, and end at 611).");
		}
		else if(IsATrain(iVehicle)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Trains cannot be spawned during runtime.");
		}
		else if(!(0 <= iColors[0] <= 255 && 0 <= iColors[1] <= 255)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid color specified (IDs start at 0, and end at 255).");
		}
		else if(Businesses[iBusiness][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[iBusiness][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Business is not a car dealership!");
		}
		else {

			new
				Float: fVehPos[4], label[50];

			GetPlayerPos(playerid, fVehPos[0], fVehPos[1], fVehPos[2]);
			GetPlayerFacingAngle(playerid, fVehPos[3]);
			for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
			{
				if (Businesses[iBusiness][bVehID][i] == 0) {
					Businesses[iBusiness][bVehID][i] = CreateVehicle(iVehicle, fVehPos[0], fVehPos[1], fVehPos[2], fVehPos[3], iColors[0], iColors[1], 10);
					VehicleFuel[Businesses[iBusiness][bVehID][i]] = 100.0;

					Businesses[iBusiness][bModel][i] = iVehicle;

				 	Businesses[iBusiness][bParkPosX][i] = fVehPos[0];
	  				Businesses[iBusiness][bParkPosY][i] = fVehPos[1];
				   	Businesses[iBusiness][bParkPosZ][i] = fVehPos[2];
			   	 	Businesses[iBusiness][bParkAngle][i] = fVehPos[3];

					format(label, sizeof(label), "%s For Sale | Price: $%s", GetVehicleName(Businesses[iBusiness][bVehID][i]), number_format(Businesses[iBusiness][bPrice][i]));
					Businesses[iBusiness][bVehicleLabel][i] = CreateDynamic3DTextLabel(label,COLOR_LIGHTBLUE,Businesses[iBusiness][bParkPosX][i], Businesses[iBusiness][bParkPosY][i], Businesses[iBusiness][bParkPosZ][i],8.0,INVALID_PLAYER_ID, Businesses[iBusiness][bVehID][i]);

					Businesses[iBusiness][DealershipVehStock][i] = 1;
					Vehicle_ResetData(Businesses[iBusiness][bVehID][i]);
					SaveDealershipVehicle(iBusiness, i);
					return 1;
				}
			}
			return SendClientMessageEx(playerid, COLOR_GREY, "The max number of vehicles for this business has been reached.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh do.");
	return 1;
}

CMD:switchbiz(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3 || PlayerInfo[playerid][pBM] >= 1)
	{
		new string[128], bizid;
		if(sscanf(params, "d", bizid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /switchbiz [bizid]");
		if(bizid < 1 || bizid > MAX_BUSINESSES) return SendClientMessageEx(playerid, COLOR_WHITE, "Invalid business ID.");
		format(string, sizeof(string), "You have switched to business ID %d (%s).", bizid, Businesses[bizid][bName]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		PlayerInfo[playerid][pBusinessRank] = 5;
		PlayerInfo[playerid][pBusiness] = bizid;
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay");
	return 1;
}

CMD:brenewal(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] >= 1)
	{
	    new
	        iType,
	        iOrderID,
	        iBusiness,
			szMessage[128],
			months;

		if(sscanf(params, "dddd", iBusiness, iType, months, iOrderID)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /brenewal [Business ID] [Type (1-3)] [Months] [OrderID]");
		}
		else if(!IsValidBusinessID(iBusiness)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "Invalid business ID");
		}
		else {
		    Businesses[iBusiness][bMonths] = 259200+gettime()+(2592000*months);
			format(szMessage, sizeof(szMessage), "You have renewed business %i for %i months.", iBusiness, months);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
			format(szMessage, sizeof(szMessage), "[BUSINESS RENEWAL] %s(%d) has renewed BusinessID %i, Type %i, Months %i, OrderID %i", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), iBusiness, iType, months, iOrderID);
			Log("logs/shoplog.log", szMessage);
			SaveBusiness(iBusiness);
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}

CMD:shopbusiness(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 1 && PlayerInfo[playerid][pBM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
		return 1;
	}

	new string[128], choice[32], businessid, amount, invoice[64];
	if(sscanf(params, "s[32]dDs[64]", choice, businessid, amount, invoice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopbusiness [name] [business ID] [Amount] [invoice #]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Exterior, Interior, SupplyPoint, Price, Type, Inventory, InventoryCapacity, Delete");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CustomInterior, CustomExterior, Months, VW, grade");
		return 1;
	}

	if (!IsValidBusinessID(businessid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid business ID entered.");
		return 1;
	}
    if(!strcmp(choice, "grade", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the grade on this business!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Grade to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bGrade] = amount;
		Log("logs/shoplog.log", string);
	}
    if(!strcmp(choice, "months", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the months left on this business!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Months to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bMonths] = (2592000*amount)+gettime()+259200;
		Log("logs/shoplog.log", string);
	}
	else if(!strcmp(choice, "vw", true))
	{
		Businesses[businessid][bVW] = amount;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the VW!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's vw to %d", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}
	if(!strcmp(choice, "exterior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bExtPos][3]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Exterior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1],Businesses[businessid][bExtPos][2]);
		Log("logs/shoplog.log", string);
	}
	else if(!strcmp(choice, "interior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1], Businesses[businessid][bIntPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bIntPos][3]);
		Businesses[businessid][bInt] = GetPlayerInterior(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the interior!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Interior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1],Businesses[businessid][bIntPos][2]);
		Log("logs/shoplog.log", string);
	}
	else if(strcmp(choice, "custominterior", true) == 0)
	{
		if(Businesses[businessid][bCustomInterior] == 0)
		{
			Businesses[businessid][bCustomInterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom interior!");
		}
		else
		{
			Businesses[businessid][bCustomInterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) interior!");
		}
		format(string, sizeof(string), "[SHOPBUSINESS] %s has edited BusinessID %d's CustomInterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/shoplog.log", string);
		return 1;
	}
	else if(strcmp(choice, "customexterior", true) == 0)
	{
		if(Businesses[businessid][bCustomExterior] == 0)
		{
			Businesses[businessid][bCustomExterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom exterior!");
		}
		else
		{
			Businesses[businessid][bCustomExterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) exterior!");
		}
		format(string, sizeof(string), "[SHOPBUSINESS] %s has edited BusinessID %d's CustomExterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/shoplog.log", string);
		return 1;
	}
	else if(!strcmp(choice, "supplypoint", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the supply point when a delivery is on its way.");
		}
		GetPlayerPos(playerid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1], Businesses[businessid][bSupplyPos][2]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the supply point!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Supply Point to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1],Businesses[businessid][bSupplyPos][2]);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "price", true))
	{
		Businesses[businessid][bValue] = amount;
		format(string, sizeof(string), "You have set the business price to $%d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Price to $%d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "type", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the business type when a delivery is on its way.");
		}
		Businesses[businessid][bType] = amount;
		format(string, sizeof(string), "You have set the business type to %s.", GetBusinessTypeName(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Type to %s (%d).", GetPlayerNameEx(playerid), businessid, GetBusinessTypeName(amount), amount);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "inventory", true))
	{
		Businesses[businessid][bInventory] = amount;
		format(string, sizeof(string), "You have set the business inventory to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Inventory to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}
	else if(!strcmp(choice, "InventoryCapacity", true))
	{
		Businesses[businessid][bInventoryCapacity] = amount;
		format(string, sizeof(string), "You have set the business inventory capacity to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Inventory Capacity to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "delete", true))
	{
		Businesses[businessid][bExtPos][0] = 0;
		Businesses[businessid][bExtPos][1] = 0;
		Businesses[businessid][bExtPos][2] = 0;
		Businesses[businessid][bIntPos][0] = 0; 
		Businesses[businessid][bIntPos][1] = 0;
		Businesses[businessid][bIntPos][2] = 0;
		Businesses[businessid][bName][0] = 0;
		Businesses[businessid][bType] = 0;
		format(string, sizeof(string), "You have deleted the business.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has deleted BusinessID %d.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);
		//TODO IMPROVE
		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
			DestroyDynamicGasPump(businessid, i);
		}
		for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++) {
			if(IsValidVehicle(Businesses[businessid][bVehID][i])) DestroyVehicle(Businesses[businessid][bVehID][i]);
			if(IsValidDynamic3DTextLabel(Businesses[businessid][bVehicleLabel][i])) DestroyDynamic3DTextLabel(Businesses[businessid][bVehicleLabel][i]), Businesses[businessid][bVehicleLabel][i] = Text3D:-1;
			Businesses[businessid][bModel][i] = 0;
			Businesses[businessid][bParkPosX][i] = 0;
			Businesses[businessid][bParkPosY][i] = 0;
			Businesses[businessid][bParkPosZ][i] = 0;
			Businesses[businessid][bParkAngle][i] = 0;
			Businesses[businessid][bVehID][i] = 0;
			Businesses[businessid][bPrice][i] = 0;
			SaveDealershipVehicle(businessid, i);
		}
	}

	RefreshBusinessPickup(businessid);
	SaveBusiness(businessid);
	Streamer_UpdateEx(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);
	return 1;
}

CMD:shopbusinessname(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 1 && PlayerInfo[playerid][pBM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
		return 1;
	}

	new string[128], houseid, ownername, invoice[64];
	if(sscanf(params, "dus[64]", houseid, ownername, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopbusinessname [Business ID] [Player] [invoice]");

	if(!IsPlayerConnected(ownername)) {
    	return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	}
	if(PlayerInfo[ownername][pLevel] == 1 && PlayerInfo[ownername][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_RED, "You can't use /shopbusinessname on level 1's");
	if(PlayerInfo[ownername][pBusiness] != INVALID_BUSINESS_ID) {
	    return SendClientMessageEx(playerid, COLOR_GREY, "That player already owns another business.");
	}

	Businesses[houseid][bOwner] = GetPlayerSQLId(ownername);
	strcpy(Businesses[houseid][bOwnerName], GetPlayerNameEx(ownername), MAX_PLAYER_NAME);
	PlayerInfo[ownername][pBusiness] = houseid;
	PlayerInfo[ownername][pBusinessRank] = 5;
	SaveBusiness(houseid);
	OnPlayerStatsUpdate(ownername);
	RefreshBusinessPickup(houseid);

	format(string, sizeof(string), "[SHOPBUSINESS] %s modified Owner on Business %d to %s(%d) - Invoice %s", GetPlayerNameEx(playerid), houseid, GetPlayerNameEx(ownername), GetPlayerSQLId(ownername), invoice);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:buyclothes(playerid, params[])
{
	new biz = InBusiness(playerid);

   	if (biz == INVALID_BUSINESS_ID || Businesses[biz][bType] != BUSINESS_TYPE_CLOTHING) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung tai a cua hang quan ao!");
        return 1;
    }
	if (Businesses[biz][bInventory] < 1) {
	    SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang nay khong co nhieu quan ao do!");
	    return 1;
	}
	if (!Businesses[biz][bStatus]) {
	    SendClientMessageEx(playerid, COLOR_GRAD2, "This clothing store is closed!");
	    return 1;
	}
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
    new string[64];
    format(string, sizeof(string), "Luu Y: Thay doi trang phuc se ton $%s", number_format(Businesses[biz][bItemPrices][0]));
    SetPVarInt(playerid, "SkinChangeCost", Businesses[biz][bItemPrices][0]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	if(PlayerInfo[playerid][mInventory][13] && PlayerInfo[playerid][pDonateRank] < 2) SendClientMessageEx(playerid, -1, "You have Restricted Skin tokens in your inventory, if you select a restricted skin you will use a token and no additional fees will come.");
	ShowModelSelectionMenu(playerid, SkinList, "Thay trang phuc");
	return 1;
}

CMD:buybizlevel(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Chi co chu so huu cua hang moi co the su dung lenh nay!");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bLevel] >= 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You cannot buy levels anymore.");
	}

	new newLevel = Businesses[PlayerInfo[playerid][pBusiness]][bLevel] + 1;
	new totalSales = Businesses[PlayerInfo[playerid][pBusiness]][bTotalSales];
	new totalProfits = Businesses[PlayerInfo[playerid][pBusiness]][bTotalProfits];

	if (newLevel == 2 && totalSales < 1000 && totalProfits < 300000)
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have enough total sales/profits to purchase this uprgade!");
	else if (newLevel == 3 && totalSales < 5000 && totalProfits < 2000000)
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have enough total sales/profits to purchase this uprgade!");
	else if (newLevel == 4 && totalSales < 15000 && totalProfits < 10000000)
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have enough total sales/profits to purchase this uprgade!");

	new cost = Businesses[PlayerInfo[playerid][pBusiness]][bLevel] * 100000;
	if(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] < cost)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "The business does not have enough money in the safe to purchase this upgrade!");
	}
	Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] -= cost;
	OnPlayerStatsUpdate(playerid);
	new string[128];
   	format(string, sizeof(string), "~g~BUSINESS LEVEL UP~n~~w~Current Level %d", ++Businesses[PlayerInfo[playerid][pBusiness]][bLevel]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

    Businesses[PlayerInfo[playerid][pBusiness]][bLevelProgress] = 0;
    Businesses[PlayerInfo[playerid][pBusiness]][bInventoryCapacity] *= 2;
	if(IsBusinessGasAble(Businesses[PlayerInfo[playerid][pBusiness]][bType]))
	{
		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++)
		{
			Businesses[PlayerInfo[playerid][pBusiness]][GasPumpCapacity][i] *= 2;
		}
	}
    SaveBusiness(PlayerInfo[playerid][pBusiness]);

    return 1;
}

// Business Leadership Commands Start

CMD:binvite(playerid, params[]) {

	new iBusinessID = PlayerInfo[playerid][pBusiness];

	if((0 <= iBusinessID < MAX_BUSINESSES) && PlayerInfo[playerid][pBusinessRank] >= Businesses[iBusinessID][bMinInviteRank]) {

		new
			iTargetID,
			string[128];

		if(sscanf(params, "u", iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /binvite [player]");
		}
		else if(IsPlayerConnected(iTargetID)) {
		    if (iTargetID != playerid) {
				if(!(0 <= PlayerInfo[iTargetID][pBusiness] < MAX_BUSINESSES)) {

					SetPVarInt(iTargetID, "Business_Inviter", playerid);
					SetPVarInt(iTargetID, "Business_InviterSQLId", GetPlayerSQLId(playerid));
					SetPVarInt(iTargetID, "Business_Invited", iBusinessID);
					format(string, sizeof(string), "Ban da moi %s tham gia cua hang %s", GetPlayerNameEx(iTargetID), Businesses[iBusinessID][bName]);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "%s %s da moi ban tham gia cua hang %s - (/chapnhan cuahang) de chap nhan de nghi.", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), Businesses[iBusinessID][bName]);
					SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);

					format(string, sizeof(string), "%s(%d) da invite %s(%d) vao cua hang %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), Businesses[iBusinessID][bName]);
					Log("logs/business.log", string);

				}
				else SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay dang lam cho mot cua hang khac!");
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the thuc hien lenh nay voi chinh ban.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong truc tuyen.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban can phai la Chu cua hang hoac co quyen han moi co the thuc hien lenh nay!");
	return 1;
}

CMD:buninvite(playerid, params[]) {
	if(0 <= PlayerInfo[playerid][pBusiness] < MAX_BUSINESSES && PlayerInfo[playerid][pBusinessRank] >= Businesses[PlayerInfo[playerid][pBusiness]][bMinInviteRank]) {

		new
			iTargetID,
			iGroupID = PlayerInfo[playerid][pBusiness];

		if(sscanf(params, "u", iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /buninvite [player]");
		}
		else if(IsPlayerConnected(iTargetID)) {
			if(iGroupID == PlayerInfo[iTargetID][pBusiness]) {
				if(playerid == iTargetID) {
					SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the thuc hien voi chinh ban!");
				}
				else if(PlayerInfo[playerid][pBusinessRank] > PlayerInfo[iTargetID][pBusinessRank]) {

					new
						szMessage[128],
						iRank = PlayerInfo[iTargetID][pBusinessRank];

					format(szMessage, sizeof(szMessage), "Ban da duoi %s ra khoi cua hang cua ban.", GetPlayerNameEx(iTargetID));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
					format(szMessage, sizeof(szMessage), "* Ban da bi duoi ra khoi cua hang boi %s %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);
					format(szMessage, sizeof(szMessage), "%s(%d) uninvited %s(%d) from the %s as a rank %i.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), Businesses[PlayerInfo[iTargetID][pBusiness]][bName], iRank);
					Log("logs/business.log", szMessage);

					PlayerInfo[iTargetID][pBusiness] = INVALID_BUSINESS_ID;
					PlayerInfo[iTargetID][pBusinessRank] = 0;
					OnPlayerStatsUpdate(iTargetID);

				}
				else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay voi nguoi cung cap bac voi ban hoac cao hon.");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi nay khong lam tai cua hang cua ban!");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong truc tuyen.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban can phai la Chu cua hang hoac co quyen han moi co the thuc hien lenh nay!");
	return 1;
}



CMD:bouninvite(playerid, params[])
{
	new name[32], query[128];
	if (sscanf(params, "s[32]", name)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /bouninvite [account name]");
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Chu so huu.");
		return 1;
	}
    if(PlayerInfo[playerid][pBusinessRank] != 5) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Chu so huu.");
		return 1;
	}
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Username` = '%e' AND `Business` = %d", name, PlayerInfo[playerid][pBusiness]);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	SendClientMessageEx(playerid, COLOR_GREY, "Ban da kick offline nguoi do.");
	return 1;
}

CMD:bgiverank(playerid, params[])
{
    new string[128], targetid, rank;
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai a business!");
	}
	if(sscanf(params, "ud", targetid, rank)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /bgiverank [player] [cap bac]");
	}
	else if (PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinGiveRankRank]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du quyen han de thuc hien lenh nay!");
	}
	else if (!IsPlayerConnected(targetid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong truc tuyen!");
	}
	else if (playerid == targetid) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay len chinh minh!");
	}
	else if(PlayerInfo[playerid][pBusiness] != PlayerInfo[targetid][pBusiness]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay khong lam tai cua hang cua ban!");
	}
	else if (PlayerInfo[targetid][pBusinessRank] > PlayerInfo[playerid][pBusinessRank])	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You can not use this command on that rank persons!");
	}
	else if(rank > PlayerInfo[playerid][pBusinessRank])
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the thuc hien lenh nay voi nguoi cung cap bac cua ban hoac cao hon!");
	}
	else if(rank < 0 || rank > 5) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Cap bac it nhat la 0 hoac cao nhat la 5!");
	}
	if (rank > PlayerInfo[targetid][pBusinessRank])	{
		format(string, sizeof(string), "* Ban da duoc thang chuc vu (%s) boi %s.", GetBusinessRankName(rank), GetPlayerNameEx(playerid));
		SendClientMessageEx(targetid, COLOR_LIGHTBLUE, string);
	}
	else if (rank < PlayerInfo[targetid][pBusinessRank]) {
		format(string, sizeof(string), "* Ban da bi ha xuong chuc vu (%s) boi %s.", GetBusinessRankName(rank), GetPlayerNameEx(playerid));
		SendClientMessageEx(targetid, COLOR_LIGHTBLUE, string);
	}
	else {
		return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi nay dang o cap bac ban da chon.");
	}
	PlayerInfo[targetid][pBusinessRank] = rank;
	format(string, sizeof(string), "* Ban da cho %s rank %d.", GetPlayerNameEx(targetid), rank);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s(%d) da duoc cho %s(%d) rank %i in %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), rank, Businesses[PlayerInfo[targetid][pBusiness]][bName]);
	Log("logs/business.log", string);
	return 1;
}

CMD:resign(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID)
	{
		new string[128];
		format(string, sizeof(string), "%s(%d) has resigned from their business as a rank %i", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pBusinessRank]);
		Log("logs/business.log", string);
		PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
		PlayerInfo[playerid][pBusinessRank] = INVALID_RANK;
		return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Ban da roi nghi viec tai cua hang ban dang lam.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai cua hang cua ban dang lam!");
}

CMD:bsafe(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Chu so huu cua hang.");
		return 1;
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 25.0, Businesses[PlayerInfo[playerid][pBusiness]][bIntPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bIntPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bIntPos][2])) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban phai ben trong cua hang ban moi co the thuc hien lenh nay.");
		return 1;
	}
	else if(PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinSafeRank]) {
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du cap bac de thuc hien lenh nay!");
		return 1;
	}
	else {
	    new choice[10], Amount, string[256];
	    if(sscanf(params, "s[10]D", choice, Amount)) {
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /bsafe [tuy chon] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "TUY CHON: Balance, Withdraw, Deposit");
			return 1;
		}
		else if(!strcmp(choice, "Balance", true))
		{
		    format(string, sizeof(string), "Business(%d) Safe Balance: $%s", PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]));
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(Amount < 1) {
		    SendClientMessageEx(playerid, COLOR_GREY, "The amount can't be under 1.");
		    return 1;
		}
		else if(!strcmp(choice, "Withdraw", true))
		{
		    if(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] >= Amount) {
		    	format(string, sizeof(string), "You have withdrew $%s from your business safe.", number_format(Amount));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	format(string, sizeof(string), "Business(%d) Safe Balance: $%s", PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	format(string,sizeof(string),"%s(%d) (IP: %s) has withdrawn $%s from their business safe (BusinessID - %d)[PT: $%s][NT: $%s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(Amount), PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]), number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] - Amount));
		    	Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] -= Amount;
				Log("logs/business.log", string);
		   		GivePlayerCash(playerid, Amount);
		   		SaveBusiness(PlayerInfo[playerid][pBusiness]);
				OnPlayerStatsUpdate(playerid);
			}
			else {
			    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co that much in your business safe.");
			}
		}
		else if(!strcmp(choice, "Deposit", true))
		{
		    if(GetPlayerCash(playerid) >= Amount) {
		    	format(string, sizeof(string), "Ban da gui $%s into your business safe.", number_format(Amount));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	format(string, sizeof(string), "Business(%d) Safe Balance: $%s", PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	format(string,sizeof(string),"%s(%d) (IP: %s) has deposited $%s into their business safe (BusinessID - %d)[PT: $%s][NT: $%s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(Amount), PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]), number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] + Amount));
		    	Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] += Amount;
				Log("logs/business.log", string);
		   		GivePlayerCash(playerid, -Amount);
		   		SaveBusiness(PlayerInfo[playerid][pBusiness]);
				OnPlayerStatsUpdate(playerid);
			}
			else {
			    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co that much cash on you.");
			}
		}
	}
	return 1;
}

// Business Admin Commands
CMD:bedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pShopTech] < 3 && PlayerInfo[playerid][pBM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do!");
		return 1;
	}

	new choice[32], businessid, amount, string[128];
	if(sscanf(params, "s[32]dD(0)", choice, businessid, amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /bedit [tuy chon] [businessid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "TUY CHON: Exterior, Interior, SupplyPoint, Price, Type, Inventory, InventoryCapacity, SafeBalance, Delete");
		SendClientMessageEx(playerid, COLOR_GREY, "TUY CHON: CustomInterior, CustomExterior, Months, GymEntryFee, GymType, VW, Grade, MaxLevel");
		return 1;
	}

	if (!IsValidBusinessID(businessid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "ID Biz khong hop le.");
		return 1;
	}
	if(!strcmp(choice, "maxlevel", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the max level allowed to enter this business!");
		format(string, sizeof(string), "%s has changed BusinessID %d's MaxLevel to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bMaxLevel] = amount;
		Log("logs/bedit.log", string);
	}
	if(!strcmp(choice, "grade", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the grade on this business!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Grade to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bGrade] = amount;
		Log("logs/bedit.log", string);
	}
    if(!strcmp(choice, "months", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the months left on this business!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Months to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bMonths] = 2592000*amount+gettime()+259200;
		Log("logs/bedit.log", string);
	}
	else if(!strcmp(choice, "vw", true))
	{
		Businesses[businessid][bVW] = amount;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the VW!");
		format(string, sizeof(string), "%s has changed BusinessID %d's vw to %d", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}
	if(!strcmp(choice, "exterior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bExtPos][3]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Exterior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1],Businesses[businessid][bExtPos][2]);
		Log("logs/bedit.log", string);
	}
	else if(!strcmp(choice, "interior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1], Businesses[businessid][bIntPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bIntPos][3]);
		Businesses[businessid][bInt] = GetPlayerInterior(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the interior!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Interior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1],Businesses[businessid][bIntPos][2]);
		Log("logs/bedit.log", string);
	}
	else if(strcmp(choice, "custominterior", true) == 0)
	{
		if(Businesses[businessid][bCustomInterior] == 0)
		{
			Businesses[businessid][bCustomInterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom interior!");
		}
		else
		{
			Businesses[businessid][bCustomInterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) interior!");
		}
		format(string, sizeof(string), "%s has edited BusinessID %d's CustomInterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "customexterior", true) == 0)
	{
		if(Businesses[businessid][bCustomExterior] == 0)
		{
			Businesses[businessid][bCustomExterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom exterior!");
		}
		else
		{
			Businesses[businessid][bCustomExterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) exterior!");
		}
		format(string, sizeof(string), "%s has edited BusinessID %d's CustomExterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);
		return 1;
	}
	else if(!strcmp(choice, "supplypoint", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the supply point when a delivery is on its way.");
		}
		GetPlayerPos(playerid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1], Businesses[businessid][bSupplyPos][2]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the supply point!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Supply Point to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1],Businesses[businessid][bSupplyPos][2]);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "price", true))
	{
		Businesses[businessid][bValue] = amount;
		format(string, sizeof(string), "You have set the business price to $%d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Price to $%d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "type", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the business type when a delivery is on its way.");
		}
		Businesses[businessid][bType] = amount;
		format(string, sizeof(string), "You have set the business type to %s.", GetBusinessTypeName(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Type to %s (%d).", GetPlayerNameEx(playerid), businessid, GetBusinessTypeName(amount), amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "inventory", true))
	{
		Businesses[businessid][bInventory] = amount;
		format(string, sizeof(string), "You have set the business inventory to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Inventory to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}
	else if(!strcmp(choice, "InventoryCapacity", true))
	{
		Businesses[businessid][bInventoryCapacity] = amount;
		format(string, sizeof(string), "You have set the business inventory capacity to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Inventory Capacity to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "safebalance", true))
	{
		Businesses[businessid][bSafeBalance] = amount;
		format(string, sizeof(string), "You have set the business safe to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's safe to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if (!strcmp(choice, "gymentryfee", true))
	{
		if (Businesses[businessid][bType] != BUSINESS_TYPE_GYM)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Only Gyms can have entrance fees!");
		}

		Businesses[businessid][bGymEntryFee] = amount;
		format(string, sizeof(string), "You have set the gym entry fee to %i.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %i's gym entry fee to %i.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if (!strcmp(choice, "gymtype", true))
	{
		if (Businesses[businessid][bType] != BUSINESS_TYPE_GYM)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only use this command on a gym!");
		}

		if (amount == 1) // swimming pool & boxing arena
		{
			Businesses[businessid][bGymType] = amount;
		}
		else if (amount == 2) // bike parkour
		{
			Businesses[businessid][bGymType] = amount;
		}
		else
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Available types are: Swimming Pool / Boxing Arena(1) or Bike Parkour (2)");
		}

		format(string, sizeof(string), "You have the set the gym type to %i.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %i's gym type to %i.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "delete", true))
	{
		Businesses[businessid][bExtPos][0] = 0;
		Businesses[businessid][bExtPos][1] = 0;
		Businesses[businessid][bExtPos][2] = 0;
		Businesses[businessid][bIntPos][0] = 0; 
		Businesses[businessid][bIntPos][1] = 0;
		Businesses[businessid][bIntPos][2] = 0;
		Businesses[businessid][bName][0] = 0;
		Businesses[businessid][bType] = 0;
		format(string, sizeof(string), "You have deleted the business.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has deleted BusinessID %d.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);

		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
			DestroyDynamicGasPump(businessid, i);
		}
		for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++) {
			if(IsValidVehicle(Businesses[businessid][bVehID][i])) DestroyVehicle(Businesses[businessid][bVehID][i]);
			if(IsValidDynamic3DTextLabel(Businesses[businessid][bVehicleLabel][i])) DestroyDynamic3DTextLabel(Businesses[businessid][bVehicleLabel][i]), Businesses[businessid][bVehicleLabel][i] = Text3D:-1;
			Businesses[businessid][bModel][i] = 0;
			Businesses[businessid][bParkPosX][i] = 0;
			Businesses[businessid][bParkPosY][i] = 0;
			Businesses[businessid][bParkPosZ][i] = 0;
			Businesses[businessid][bParkAngle][i] = 0;
			Businesses[businessid][bVehID][i] = 0;
			Businesses[businessid][bPrice][i] = 0;
			SaveDealershipVehicle(businessid, i);
		}
	}

	RefreshBusinessPickup(businessid);
	SaveBusiness(businessid);
	Streamer_UpdateEx(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);

	return 1;
}

CMD:bname(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		new name[40], businessid;

		if(sscanf(params, "ds[40]", businessid, name)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /bname [business id] [name]");
		}
		else if (!IsValidBusinessID(businessid)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "ID Biz khong hop le.");
		}
		else if(strfind(name, "\r") != -1 || strfind(name, "\n") != -1) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Newline characters are forbidden.");
		}

		strcpy(Businesses[businessid][bName], name, sizeof(name));
		SaveBusiness(businessid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the name of this business.");
		RefreshBusinessPickup(businessid);

		new string[128];
		format(string, sizeof(string), "%s has edited business ID %d's name to %s.", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bName]);
		Log("logs/bedit.log", string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
	}

	return 1;
}

CMD:bnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available business...");
		for(new i; i<MAX_BUSINESSES;i++)
		{
		    if(Businesses[i][bExtPos] == 0.0)
		    {
		        new string[128];
		        format(string, sizeof(string), "%d is available to use.", i);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}


CMD:bnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing businesses within 30 meters of you");
		for(new i;i<MAX_BUSINESSES;i++)
		{
			if(Businesses[i][bExtPos][0] != 0 && Businesses[i][bExtPos][1] != 0 &&  Businesses[i][bExtPos][2] != 0) {
				if(IsPlayerInRangeOfPoint(playerid, 30, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]))
				{
					new string[128];
					format(string, sizeof(string), "Business ID %d | %f from you", i, GetPlayerDistanceFromPoint(playerid,Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}

CMD:gotobiz(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /gotobiz [business id]");
		if(!IsValidBusinessID(id)) return SendClientMessageEx(playerid, COLOR_GREY, "ID Biz khong hop le.");
		if (Businesses[id][bExtPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GREY, "Biz nay khong ton tai.");
		GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		PlayerInfo[playerid][pVW] = 0;
		SetPlayerPos(playerid,Businesses[id][bExtPos][0],Businesses[id][bExtPos][1],Businesses[id][bExtPos][2]);
		SetPlayerFacingAngle(playerid,Businesses[id][bExtPos][3]);
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}


CMD:goinbiz(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /goinbiz [businessid]");
		if(!IsValidBusinessID(id)) return SendClientMessageEx(playerid, COLOR_GREY, "ID Biz khong hop le.");
		if (Businesses[id][bExtPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GREY, "Noi that cua Biz nay chua duoc cai dat.");
		SetPlayerInterior(playerid,Businesses[id][bInt]);
		SetPlayerPos(playerid,Businesses[id][bIntPos][0],Businesses[id][bIntPos][1],Businesses[id][bIntPos][2]);
		SetPlayerFacingAngle(playerid,Businesses[id][bIntPos][3]);
		SetPVarInt(playerid, "BusinessesID", id);
		if(Businesses[id][bVW] == 0) SetPlayerVirtualWorld(playerid, BUSINESS_BASE_VW + id), PlayerInfo[playerid][pVW] = BUSINESS_BASE_VW + id;
		else SetPlayerVirtualWorld(playerid, Businesses[id][bVW]), PlayerInfo[playerid][pVW] = Businesses[id][bVW];
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
	}
	return 1;
}

CMD:asellbiz(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pBM] < 2) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh do.");
	}

	new string[128], biz;
	if(sscanf(params, "d", biz)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /asellbiz [business id]");

	Businesses[biz][bOwner] = -1;
	SaveBusiness(biz);
	RefreshBusinessPickup(biz);
	new ip[16];
	GetPlayerIp(playerid,ip,sizeof(ip));
	format(string,sizeof(string),"Administrator %s (IP: %s) has admin-sold business ID %d (was owned by %d).",GetPlayerNameEx(playerid),ip,biz,Businesses[biz][bOwner]);
	Log("logs/business.log", string);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	format(string, sizeof(string), "~w~You have sold business %d.", biz);
	GameTextForPlayer(playerid, string, 10000, 3);
	foreach(new j: Player)
	{
		if(PlayerInfo[j][pBusiness] == biz)
		{
			PlayerInfo[j][pBusiness] = INVALID_BUSINESS_ID;
			PlayerInfo[j][pBusinessRank] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "An admin has sold this business, your business stats have been reset.");
		}
	}

	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Business` = '%d'", biz);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

CMD:gtansellbiz(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID )
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu cua hang!");
	}
	else if(PlayerInfo[playerid][pBusinessRank] < 5 && Businesses[PlayerInfo[playerid][pBusiness]][bOwner] != GetPlayerSQLId(playerid)) {
	    return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai chu so huu cua hang nay.");
	}
    else if (IsPlayerInRangeOfPoint(playerid, 2.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2]))
    {
        new i = PlayerInfo[playerid][pBusiness];

		PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
		PlayerInfo[playerid][pBusinessRank] = 0;
		GivePlayerCash(playerid,Businesses[i][bValue]);
		OnPlayerStatsUpdate(playerid);
		Businesses[i][bOwner] = -1;
		SaveBusiness(i);
		RefreshBusinessPickup(i);
		new string[128];
		format(string,sizeof(string),"%s (IP: %s) has sold business ID %d for $%d",GetPlayerNameEx(playerid),GetPlayerIpEx(playerid),i, Businesses[i][bValue]);
		Log("logs/business.log", string);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		format(string, sizeof(string), "~w~Congratulations~n~You have sold your business for ~n~~g~$%d", Businesses[i][bValue]);
		GameTextForPlayer(playerid, string, 10000, 3);
		foreach(new j: Player) {
			if(PlayerInfo[j][pBusiness] == i) {
				PlayerInfo[j][pBusiness] = INVALID_BUSINESS_ID;
				PlayerInfo[j][pBusinessRank] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Chu cua hang cua ban da ban cua hang cua ho.");
			}
		}

		format(string, sizeof(string), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Business` = '%d'", i);
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
		return 1;
    }
    else
    {
	    SendClientMessageEx(playerid, COLOR_WHITE, "Ban can phai dung tai cua hang cua minh.");
	    return 1;
    }
}

CMD:buybiz(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da so huu mot cua hang.");
	for(new i = 0; i < sizeof(Businesses); i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]))
	    {
	        if (Businesses[i][bOwner] >= 1)
	        {
	        	return SendClientMessageEx(playerid, COLOR_GREY, "Cua hang nay da co chu so huu!");
	        }
	        if (GetPlayerCash(playerid) < Businesses[i][bValue])
	        {
	        	return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du tien de mua!");
	        }
			GivePlayerCash(playerid, -Businesses[i][bValue]);
			Businesses[i][bOwner] = GetPlayerSQLId(playerid);
			strcpy(Businesses[i][bOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PlayerInfo[playerid][pBusiness] = i;
			PlayerInfo[playerid][pBusinessRank] = 5;
			SendClientMessageEx(playerid, COLOR_WHITE, "Xin chuc mung! Ban da mua thanh cong!");
			SendClientMessageEx(playerid, COLOR_WHITE, "De xem cac lenh lien quan den cua hang hay dung lenh (/trogiup) hoac (/tgbiz).");
			SaveBusiness(i);
			OnPlayerStatsUpdate(playerid);
			RefreshBusinessPickup(i);
			new string[128];
			format(string,sizeof(string),"%s (IP: %s) has bought business ID %d for $%d.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), i, Businesses[i][bValue]);
			Log("logs/business.log", string);
			return 1;
	    }
	}
	return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung gan cua hang!");
}

CMD:creategaspump(playerid, params[])
{
    new string[128], iBusinessID;
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pBM] >= 1) {

		if(sscanf(params, "d", iBusinessID)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /creategaspump [business id]");
		}
		else
		{
			if (GetFreeGasPumpID(iBusinessID) == INVALID_GAS_PUMP)
			return SendClientMessageEx(playerid, COLOR_GRAD1, "The maximum number of gas pumps has been reached for this business.");

			if (!(0 <= iBusinessID < MAX_BUSINESSES)) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Invalid business specified.");
			}
		 	if (!Businesses[iBusinessID][bType]) {
		 		return SendClientMessageEx(playerid, COLOR_GREY, "Type of this business must have been set before using this command.");
		 	}
			if(!IsBusinessGasAble(Businesses[iBusinessID][bType])) {
		        return SendClientMessageEx(playerid, COLOR_GREY, "You can't create gas pumps for this type of business.");
		    }
		    if(!IsPlayerInRangeOfPoint(playerid, 150.0, Businesses[iBusinessID][bExtPos][0], Businesses[iBusinessID][bExtPos][1], Businesses[iBusinessID][bExtPos][2])) {
		        return SendClientMessageEx(playerid, COLOR_GREY, "You are too far away from the business.");
		    }
			new iPump = GetFreeGasPumpID(iBusinessID);
			Businesses[iBusinessID][GasPumpCapacity][iPump] = Businesses[iBusinessID][bLevel] * 100;
			CreateDynamicGasPump(playerid, iBusinessID, iPump);
			SaveBusiness(iBusinessID);

			format(string, sizeof(string), "%s has created a gas pump for %s (%d)", Businesses[iBusinessID][bName], iBusinessID);
			Log("logs/bedit.log", string);
			return 1;

		}
    } else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay.");
}

CMD:editgaspump(playerid, params[])
{
    new iBusinessID, iPumpID, szLog[128], szName[9], Float: fValue;
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pBM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay.");
    }

	if(sscanf(params, "dds[9]F(0)", iBusinessID, iPumpID, szName, fValue)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editgaspump [business id] [pump id] [name] [value]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available Names: Capacity, Gas, Position");
	}

	if (!(0 <= iBusinessID < MAX_BUSINESSES))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid business specified.");
	}
	else if (!(0 <= iPumpID < MAX_BUSINESS_GAS_PUMPS))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid gas pump specified.");
	}
	else if(Businesses[iBusinessID][GasPumpVehicleID][iPumpID])
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't edit a gas pump while it is in use.");
	}

	if(!strcmp(szName, "position", true))
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 150.0, Businesses[iBusinessID][bExtPos][0], Businesses[iBusinessID][bExtPos][1], Businesses[iBusinessID][bExtPos][2])) {
        	return SendClientMessageEx(playerid, COLOR_GREY, "You are far away from the business.");
    	}
    	format(szLog, sizeof(szLog), "%s has changed the position of pump %d for business %d", GetPlayerNameEx(playerid), iPumpID, iBusinessID);

		DestroyDynamicGasPump(iBusinessID, iPumpID);
		CreateDynamicGasPump(playerid, iBusinessID, iPumpID);
		SaveBusiness(iBusinessID);

	}
	else if(!strcmp(szName, "gas", true))
	{
	    if (fValue > Businesses[iBusinessID][GasPumpCapacity][iPumpID])
	    {
		    SendClientMessageEx(playerid, COLOR_GREY, "The value cannot be higher than the capacity!");
		    return 1;
	    }
		Businesses[iBusinessID][GasPumpGallons][iPumpID] = fValue;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the gas pump gas amount!");
		format(szLog, sizeof(szLog), "%s has changed the gas amount of pump %d for %s (%d) to %.2f", GetPlayerNameEx(playerid), iPumpID, Businesses[iBusinessID][bName], iBusinessID, fValue);
	}
	else if(!strcmp(szName, "capacity", true))
	{
		Businesses[iBusinessID][GasPumpCapacity][iPumpID] = fValue;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the gas pump capacity!");
		format(szLog, sizeof(szLog), "%s has changed the gas capacity of pump %d for %s (%d) to %.2f", GetPlayerNameEx(playerid), iPumpID, Businesses[iBusinessID][bName], iBusinessID, fValue);
	}

	SaveBusiness(iBusinessID);
	Log("logs/bedit.log", szLog);
	return 1;
}

CMD:deletegaspump(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pBM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
    }
    new businessid, id, string[128];
	if(sscanf(params, "dd", businessid, id)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deletegaspump [business id] [pump id]");
	}
	if(!IsValidBusinessID(businessid) || id < 0 || id >= MAX_BUSINESS_GAS_PUMPS || Businesses[businessid][GasPumpPosX][id] == 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "No gas pump found with that ID.");
	}
	if(Businesses[businessid][GasPumpVehicleID][id]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't delete a gas pump while it is in use.");
	}

 	DestroyDynamicGasPump(businessid, id);
	Businesses[businessid][GasPumpPosX][id] = 0;
	Businesses[businessid][GasPumpPosY][id] = 0;
	Businesses[businessid][GasPumpPosZ][id] = 0;
	Businesses[businessid][GasPumpAngle][id] = 0;
	Businesses[businessid][GasPumpCapacity][id] = 0;
	Businesses[businessid][GasPumpGallons][id] = 0;
	Businesses[businessid][GasPumpSaleGallons][id] = 0;
	Businesses[businessid][GasPumpSalePrice][id] = 0;
	SaveBusiness(businessid);

    format(string, sizeof(string), "You have successfully deleted the gas pump %d for business %d.", id, businessid);
    SendClientMessageEx(playerid, COLOR_WHITE, string);

	format(string, sizeof(string), "Admin %s deleted a gas pump for business %d", businessid);
	Log("logs/bedit.log", string);

	return 1;
}

CMD:addmats(playerid, params[]) {
	return callcmd::addmaterials(playerid, params);
}

CMD:addmaterials(playerid, params[])
{
    new	string[128], amount;
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai a business!");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GUNSHOP) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Command not available for this type of business.");
	}
	if(sscanf(params, "d", amount) || amount < 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /addmaterials [amount]");
	}
	if (amount > PlayerInfo[playerid][pMats]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co nhieu vat lieu.");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bInventory] + amount > Businesses[PlayerInfo[playerid][pBusiness]][bInventoryCapacity]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Inventory capacity exceeded.");
	}
	if (InBusiness(playerid) != PlayerInfo[playerid][pBusiness]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You must be inside the business.");
	}
	Businesses[PlayerInfo[playerid][pBusiness]][bInventory] += amount;
	PlayerInfo[playerid][pMats] -= amount;
	OnPlayerStatsUpdate(playerid);
	SaveBusiness(PlayerInfo[playerid][pBusiness]);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have successfully added materials to the business inventory!");
	format(string, sizeof(string), "INVENTORY: %d/%d materials", Businesses[PlayerInfo[playerid][pBusiness]][bInventory], Businesses[PlayerInfo[playerid][pBusiness]][bInventoryCapacity]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	return 1;
}

/*CMD:offergun(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GUNSHOP)	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for a gun store!");
	}
	new buyerid, weapon;
	if (sscanf(params, "uk<sweapon>", buyerid, weapon)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /offergun [player] [weapon name]");
	}
	if (!IsPlayerConnected(buyerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified!");
	}
	if (playerid == buyerid) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't offer a gun to yourself!");
	}
    if(!ProxDetectorS(5.0, playerid, buyerid)) {
    	return SendClientMessageEx(playerid, COLOR_GREY, "The customer is not near you!");
    }
	if (InBusiness(playerid) != PlayerInfo[playerid][pBusiness]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung taiside the business!");
	}
	if(PlayerInfo[buyerid][pConnectHours] < 2 || PlayerInfo[buyerid][pWRestricted] > 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently weapon restricted!");
	}
	new b = InBusiness(playerid);
	if (Businesses[b][bInventory] < GetWeaponParam(weapon, WeaponMats)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Business inventory does not have khong du vat lieu for vu khi do.");
	}
	if (Businesses[b][bInventory] < GetWeaponParam(weapon, WeaponMinLevel)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Business level is not high enough to sell that type of gun.");
 	}

	new price = GetWeaponPrice(PlayerInfo[playerid][pBusiness], weapon);

	new string[128];
	format(string, sizeof(string), "* Ban de nghi %s de mua a %s for $%s", GetPlayerNameEx(buyerid), Weapon_ReturnName(weapon), number_format(price));
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
    format(string, sizeof(string), "* Employee %s offers you a %s for $%s (type /accept gun) de mua.", GetPlayerNameEx(playerid), Weapon_ReturnName(weapon), number_format(price));
    SendClientMessageEx(buyerid, COLOR_LIGHTBLUE, string);

	SetPVarInt(buyerid, "Business_WeapType", weapon);
	SetPVarInt(buyerid, "Business_WeapOfferer", playerid);
	SetPVarInt(buyerid, "Business_WeapOffererSQLId", GetPlayerSQLId(playerid));
	SetPVarInt(buyerid, "Business_WeapPrice", price);
	return 1;
}*/


CMD:offermenu(playerid, params[])
{
    new iBusiness = InBusiness(playerid);

   	if(iBusiness == INVALID_BUSINESS_ID || (Businesses[iBusiness][bType] != BUSINESS_TYPE_BAR && Businesses[iBusiness][bType] != BUSINESS_TYPE_CLUB && Businesses[iBusiness][bType] != BUSINESS_TYPE_RESTAURANT)) return SendClientMessageEx(playerid, COLOR_GRAD2, "   Ban khong dung tai a bar, club or restaurant!");
	else if(Businesses[iBusiness][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang nay khong du hang ton kho!");
	if(GetPlayerInterior(playerid) != Businesses[iBusiness][bInt]) return 1;
	new szDialog[512], pvar[25], line;

	if (Businesses[iBusiness][bType] == BUSINESS_TYPE_BAR || Businesses[iBusiness][bType] == BUSINESS_TYPE_CLUB)
	{
		for (new item; item < sizeof(Drinks); item++)
		{
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(Businesses[iBusiness][bItemPrices][item] * 0.8)) : (Businesses[iBusiness][bItemPrices][item]);
			format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, Drinks[item], number_format(cost));
			format(pvar, sizeof(pvar), "Business_MenuItem%d", line);
			SetPVarInt(playerid, pvar, item);
			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", line);
			SetPVarInt(playerid, pvar, Businesses[iBusiness][bItemPrices][item]);
			line++;
		}
	}
	else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT)
	{
		for (new item; item < sizeof(RestaurantItems); ++item)
		{
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(Businesses[iBusiness][bItemPrices][item] * 0.8)) : (Businesses[iBusiness][bItemPrices][item]);
			format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[item], number_format(cost));
			format(pvar, sizeof(pvar), "Business_MenuItem%d", line);
			SetPVarInt(playerid, pvar, item);
			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", line);
			SetPVarInt(playerid, pvar, Businesses[iBusiness][bItemPrices][item]);
			line++;
		}
	}

   	if(strlen(szDialog) == 0) SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang khong ban bat ki mat hang nao!");
    else ShowPlayerDialogEx(playerid, RESTAURANTMENU, DIALOG_STYLE_LIST, "Menu", szDialog, "Mua", "Huy");
    return 1;
}

CMD:buyfood(playerid, params[])
{
	if (!IsAtRestaurant(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung tai cua hang!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);

	if (Businesses[iBusiness][bInventory] < 1) {
	    SendClientMessageEx(playerid, COLOR_GRAD2, "Nha hang nay hien het thuc an!");
	    return 1;
	}

	if (!Businesses[iBusiness][bStatus])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Nha hang nay hien dang dong cua!");
		return 1;
	}
	if(Businesses[iBusiness][bMaxLevel] > 0 && PlayerInfo[playerid][pConnectHours] > Businesses[iBusiness][bMaxLevel])
		return SendClientMessageEx(playerid, COLOR_GRAD2, "The cashier has denied you service, this discount store is for new citizens only.");
	new szDialog[512], pvar[25], line;

	for (new item; item < sizeof(RestaurantItems); ++item)
	{
		format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[item], number_format(Businesses[iBusiness][bItemPrices][item]));
		format(pvar, sizeof(pvar), "Business_MenuItem%d", line);
		SetPVarInt(playerid, pvar, item);
		format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", line);
		SetPVarInt(playerid, pvar, Businesses[iBusiness][bItemPrices][item]);
		line++;
	}

	if (strlen(szDialog) == 0)
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang khong ban bat ki mat hang nao!");
    }
    else
	{
    	ShowPlayerDialogEx(playerid, RESTAURANTMENU, DIALOG_STYLE_LIST, "Thuc don", szDialog, "Mua", "Huy");
    }

	return 1;
}

CMD:bpanic(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for a business!");
	}
	if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai the business interior!");
	}
	new string[128];
	if(GetPVarInt(playerid, "bizpanic") == 0)
	{
		format(string, sizeof(string), "** %s hits a small button.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		format(string, sizeof(string), "* %s %s has hit the panic button at %s - /bizfind %d for a gps location.", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), Businesses[InBusiness(playerid)][bName], InBusiness(playerid));
		SendClientMessage(playerid, COLOR_GRAD2, "* The police have been notified that you require help. ");
		SetPVarInt(playerid, "bizpanic", 1);
	}
	else
	{
		format(string, sizeof(string), "** %s hits a small button.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		format(string, sizeof(string), "* %s %s no longer requires help at %s.", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), Businesses[InBusiness(playerid)][bName]);
		SendClientMessage(playerid, COLOR_GRAD2, "* The police have been notified that you no longer require help. ");
		SetPVarInt(playerid, "bizpanic", 0);
	}
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, 0x2641FEAA);
			SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
		}
	}
	return 1;
}

CMD:bizfind(playerid, params[])
{
	if(IsACop(playerid))
	{
	    new iBusinessID, string[128];
	    if(sscanf(params, "d", iBusinessID))
	    {
	        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bizfind [business id]");
	    }
		if(IsValidBusinessID(iBusinessID))
		{
		    if(Businesses[iBusinessID][bOwner])
		    {
                SetPVarInt(playerid,"bpanic", 1);
		        format(string, sizeof(string), "* Setting your GPS Waypoint to find %s", Businesses[iBusinessID][bName]);
 				SetPlayerCheckpoint(playerid, Businesses[iBusinessID][bExtPos][0], Businesses[iBusinessID][bExtPos][1], Businesses[iBusinessID][bExtPos][2], 4.0);
 				return 1;
			}
			return SendClientMessageEx(playerid, COLOR_GRAD2, " That business doesn't have an owner. ");
		}
		return SendClientMessageEx(playerid, COLOR_GRAD2, " Invalid Business ID.");
	}
	return SendClientMessageEx(playerid, COLOR_GRAD2, " Ban khong coaccess to the Business Directory. (Law Enforcement Only)");
}

CMD:binventory(playerid, params[])
{
	new
		string[128],
		iBusiness = PlayerInfo[playerid][pBusiness];
	if(iBusiness != INVALID_BUSINESS_ID)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "|_________ Business Inventory_________|");
		format(string, sizeof(string), "Amount: %d / Capacity: %d / Type: %s", Businesses[iBusiness][bInventory], Businesses[iBusiness][bInventoryCapacity], GetInventoryType(iBusiness));
		SendClientMessageEx(playerid, COLOR_WHITE, string);

		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
			if (Businesses[iBusiness][GasPumpPosX][i] != 0.0) {
				format(string, sizeof(string), "Gas Tank %d:  %.2f gal / %.2f gal", i+1, Businesses[iBusiness][GasPumpGallons][i], Businesses[iBusiness][GasPumpCapacity][i]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD2, " You don't own or work for a business.");
	return 1;
}

CMD:offeritem(playerid, params[])
{
	new buyerid, item;
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_STORE && Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GASSTATION) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for a 24/7 store!");
	}
	if (sscanf(params, "uk<storeitem>", buyerid, item))	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /offeritem [Player] [Item]");
	    SendClientMessageEx(playerid, COLOR_GREY, "Items - cellphone, phonebook, dice, condom, musicplayer, rope, cigar, sprunk, lock, spraycan, radio, camera, lotteryticket,");
	    return SendClientMessageEx(playerid, COLOR_GREY, "checkbook, paper, industriallock, elock, standardcaralarm, helmet");
	}
	if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai the business interior!");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bInventory] < 1) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Business inventory has no items.");
	}
	if (!IsPlayerConnected(buyerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified!");
	}
	if (item == INVALID_STORE_ITEM)	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid item specified!");
	}
	if (!Businesses[PlayerInfo[playerid][pBusiness]][bItemPrices][item-1]) {
	    SendClientMessageEx(playerid, COLOR_GRAD4, "Vat pham nay khong co ban.");
	    return 1;
	}
	if (playerid == buyerid) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't offer an item to yourself!");
	}
    if(!ProxDetectorS(5.0, playerid, buyerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "The customer is not near you!");
    }

	new string[128];
    format(string, sizeof(string), "* Ban de nghi %s de mua a %s.", GetPlayerNameEx(buyerid), StoreItems[item-1]);
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
    format(string, sizeof(string), "* %s muon ban mua mot %s voi gia $%s (nhap /chapnhan vatpham) de mua.", GetPlayerNameEx(playerid), StoreItems[item-1], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bItemPrices][item-1]));
    SendClientMessageEx(buyerid, COLOR_LIGHTBLUE, string);

	SetPVarInt(buyerid, "Business_ItemType", item-1);
	SetPVarInt(buyerid, "Business_ItemPrice", Businesses[PlayerInfo[playerid][pBusiness]][bItemPrices][item-1]);
	SetPVarInt(buyerid, "Business_ItemOfferer", playerid);
	SetPVarInt(buyerid, "Business_ItemOffererSQLId", GetPlayerSQLId(playerid));

	return 1;
}

CMD:resupplyadac123987(playerid, params[])
{
	new iBusiness = PlayerInfo[playerid][pBusiness];
	new amount;
	new string[128];
	new year, month, day;
	if (sscanf(params, "d", amount))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /resupply [amount]");
	}
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	if (PlayerInfo[playerid][pBusinessRank] < Businesses[iBusiness][bMinSupplyRank]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Your rank is not high enough for placing resupply orders!");
	}
	if(amount < 1) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Resupply amount cannot be below 1.");
	}
	if (Businesses[iBusiness][bOrderState] == 1) {
		return SendClientMessageEx(playerid, COLOR_WHITE, "You already have a pending order. Either cancel it or wait for it to be delivered before placing orders.");
	}
	if (Businesses[iBusiness][bOrderState] == 2) {
		return SendClientMessageEx(playerid, COLOR_WHITE, "You already have an order which is being delivered.");
	}
	if (Businesses[iBusiness][bSupplyPos][0] == 0.0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have a delivery point for Truckers.");
	}
	if (Businesses[iBusiness][bInventory] >= Businesses[iBusiness][bInventoryCapacity]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Inventory is already at full capacity.");
	}
	if(Businesses[iBusiness][bInventory] + amount > Businesses[iBusiness][bInventoryCapacity])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "Your inventory does not have the capacity.");
	}
	new rSupCost = floatround(amount * BUSINESS_ITEMS_COST);
	if (!Businesses[iBusiness][bSafeBalance] || Businesses[iBusiness][bSafeBalance] < rSupCost || rSupCost < 0) {
		if(rSupCost < 0) format(string, sizeof(string), "!! %s attempted to exploit resupply with an amount of %d in BizID: %d !!", GetPlayerNameEx(playerid), amount, iBusiness), Log("/logs/business.log", string);
	    format(string, sizeof(string), "Safe balance is not enough for this. ($%s)", number_format(floatround(amount * BUSINESS_ITEMS_COST)));
		return SendClientMessageEx(playerid, COLOR_GREY, string);
	}

	format(Businesses[iBusiness][bOrderBy], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));
	getdate(year, month, day);
	format(Businesses[iBusiness][bOrderDate], 30, "%d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minuite, second);
	Businesses[iBusiness][bSafeBalance] -= floatround(amount * BUSINESS_ITEMS_COST);
	Businesses[iBusiness][bOrderAmount] = amount;
	Businesses[iBusiness][bOrderState] = 1;
	SaveBusiness(iBusiness);
	format(string, sizeof(string), "%s (IP: %s) has placed a resupply order for %s (%d) - Amount: %d", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), Businesses[PlayerInfo[playerid][pBusiness]][bName], PlayerInfo[playerid][pBusiness], amount);
	Log("logs/business.log", string);
	format(string, sizeof(string), "* You have placed a resupply order for %s", Businesses[PlayerInfo[playerid][pBusiness]][bName]);
	SendClientMessage(playerid, COLOR_GRAD2, string);
	return 1;
}

CMD:checkresupply(playerid, params[])
{
	new iBusinessID = PlayerInfo[playerid][pBusiness];
	if((0 <= iBusinessID < MAX_BUSINESSES) && PlayerInfo[playerid][pBusinessRank] >= Businesses[iBusinessID][bMinSupplyRank])
	{
		new iOrderState = Businesses[iBusinessID][bOrderState];
		if (!iOrderState)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Your business has never placed a resupply order.");
			return 1;
		}
		else
		{
			new string[128];
			SendClientMessageEx(playerid, COLOR_GREEN, "|___________ Latest Resupply Order ___________|");
			format(string,sizeof(string), "Date/Time: %s -- Amount: %s -- Status: %s", Businesses[iBusinessID][bOrderDate], number_format(Businesses[iBusinessID][bOrderAmount]), GetSupplyState(iOrderState));
			//if (iOrderState == 2) format(string,sizeof(string), "%s {DDDDDD}(Truck Distance: %d)");
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string,sizeof(string), "This order was submitted by %s", Businesses[iBusinessID][bOrderBy]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			if (iOrderState == 1) SendClientMessageEx(playerid, COLOR_YELLOW, "You can use /cancelresupply to cancel this order.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Only authorized business employees may use this command.");
	return 1;
}

CMD:cancelresupply(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID)	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung tai a business!");
	}
	else if (PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinSupplyRank]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Your rank is not high enough for cancelling resupply orders!");
	}
	else {
		new orderstate = Businesses[PlayerInfo[playerid][pBusiness]][bOrderState];
		if (orderstate == 0) {
			return SendClientMessageEx(playerid, COLOR_WHITE, "Your business has never placed a resupply order.");
		}
		else if (orderstate == 2) {
		    foreach(new i : Player)
			{
				if(TruckDeliveringTo[GetPlayerVehicleID(i)] == PlayerInfo[playerid][pBusiness])
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "You can't cancel an order while it is being shipped!");
					return 1;
				}
			}
		    Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] += floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * BUSINESS_ITEMS_COST);
		    Businesses[PlayerInfo[playerid][pBusiness]][bOrderState] = 4;
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
			new string[128];
			format(string, sizeof(string), "%s(%d) (IP: %s) has cancelled the resupply order for %s (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[PlayerInfo[playerid][pBusiness]][bName], PlayerInfo[playerid][pBusiness]);
			Log("logs/business.log", string);
			format(string, sizeof(string), "You have cancelled your resupply order! A refund of $%s has been given.", number_format(floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * (BUSINESS_ITEMS_COST * 0.8))));
			return SendClientMessageEx(playerid, COLOR_WHITE, string);

		}
		else if (orderstate == 1) {
		    Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] += floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * BUSINESS_ITEMS_COST);
		    Businesses[PlayerInfo[playerid][pBusiness]][bOrderState] = 4;
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
			new string[128];
			format(string, sizeof(string), "%s(%d) (IP: %s) has cancelled the resupply order for %s (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[PlayerInfo[playerid][pBusiness]][bName], PlayerInfo[playerid][pBusiness]);
			Log("logs/business.log", string);
			format(string, sizeof(string), "You have cancelled your resupply order! A refund of $%s has been given.", number_format(floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * (BUSINESS_ITEMS_COST * 0.8))));
			return SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}

CMD:minrank(playerid, params[])
{
	new rank, commandx[32];
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Chi co chu so huu cua hang moi co the su dung lenh nay!");
	}
	if (sscanf(params, "ds[32]", rank, commandx))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /minrank [rank] [invite/giverank/supply]");
	}
	if(rank < 0 || rank > 5)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Don't go below number 0 or above number 5!");
	}
	if (strcmp(commandx, "invite", true) == 0) Businesses[PlayerInfo[playerid][pBusiness]][bMinInviteRank] = rank, SaveBusiness(PlayerInfo[playerid][pBusiness]);
	else if (strcmp(commandx, "giverank", true) == 0) Businesses[PlayerInfo[playerid][pBusiness]][bMinGiveRankRank] = rank, SaveBusiness(PlayerInfo[playerid][pBusiness]);
	else if (strcmp(commandx, "supply", true) == 0) Businesses[PlayerInfo[playerid][pBusiness]][bMinSupplyRank] = rank, SaveBusiness(PlayerInfo[playerid][pBusiness]);
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid Permission Name");

	new string[128];
	format(string, sizeof(string), "You have set the minimum rank for %s to %d (%s)", commandx, rank, GetBusinessRankName(rank));
	SendClientMessageEx(playerid, COLOR_GREY, string);

	return 1;
}

CMD:br(playerid, params[])
{
	return callcmd::bizradio(playerid, params);
}

CMD:bizradio(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	new
		string[128],
		iBusinessID = PlayerInfo[playerid][pBusiness],
		iRank = PlayerInfo[playerid][pBusinessRank];

	if (!IsValidBusinessID(iBusinessID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not an employee of a business!");
	else if(iBusinessID == INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not an employee of a business!");
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay bay gio.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /b(iz)r(radio) [biz chat]");

	//format(string, sizeof(string), "(radio) %s", params);
	//SetPlayerChatBubble(playerid,string,COLOR_WHITE,15.0,5000);
	format(string, sizeof(string), "** (%d) %s %s: %s **", iRank, GetBusinessRankName(iRank), GetPlayerNameEx(playerid), params);
	foreach(new i: Player)
	{
		if (PlayerInfo[i][pBusiness] == iBusinessID && GetPVarInt(i, "BusinessRadio") != 1) {

			ChatTrafficProcess(i, COLOR_BR, string, 14);
		}
	}

	return 1;
}

CMD:employeepayset(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] != 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Not authorized to use this command!");
	}
	new rank, amount;
	if (sscanf(params, "dd", rank, amount))
	{
	    SendClientMessageEx(playerid, COLOR_RED, "Listing current paycheck amounts...");
	    for (new i, string[64]; i < 5; i++) {
	        format(string,sizeof(string), "Rank %d (%s): $%s", i, GetBusinessRankName(i), number_format(Businesses[PlayerInfo[playerid][pBusiness]][bRankPay][i]));
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
	    }
		return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /employeepayset [rank] [amount]");
	}
	if (rank < 0 || rank > 4)
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "Invalid rank entered!");
   	}
	if (amount < 1 || amount > 100000)
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "Amount can't be lower than $1 or higher than $100,000!");
    }

	Businesses[PlayerInfo[playerid][pBusiness]][bRankPay][rank] = amount;
	SaveBusiness(PlayerInfo[playerid][pBusiness]);
    new string[128];
    format(string, sizeof(string), "You have set paycheck amount for rank %d (%s) to $%s", rank, GetBusinessRankName(rank), number_format(amount));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string,sizeof(string),"%s(%d) has changed paycheck of rank %d to $%s for business %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), rank, number_format(amount), PlayerInfo[playerid][pBusiness]);
	Log("logs/business.log", string);

	return 1;
}


CMD:employeeautopay(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] != 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Not authorized to use this command!");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bAutoPay])
	{
		Businesses[PlayerInfo[playerid][pBusiness]][bAutoPay] = 0;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled paychecks for the business.");
		SaveBusiness(PlayerInfo[playerid][pBusiness]);
		return 1;
	}
 	else
	{
		Businesses[PlayerInfo[playerid][pBusiness]][bAutoPay] = 1;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled paychecks for the business.");
		SaveBusiness(PlayerInfo[playerid][pBusiness]);
		return 1;
	}
}

CMD:editgasprice(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID && PlayerInfo[playerid][pBusinessRank] >= 5 && IsBusinessGasAble(Businesses[PlayerInfo[playerid][pBusiness]][bType]))
	{
		ShowPlayerDialogEx(playerid, DIALOG_GASPRICE, DIALOG_STYLE_INPUT, "Edit Gas Price", "Enter the new price per 1 gallon (e.g. 4.52)", "OK", "Cancel");
		SetPVarInt(playerid, "EditingBusiness", PlayerInfo[playerid][pBusiness]);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Your are not the owner of a gas station!");
	return 1;
}

CMD:editpricegtn(playerid, params[])
{
	new
		iBusiness = PlayerInfo[playerid][pBusiness];

	if (iBusiness != INVALID_BUSINESS_ID)
	{
	    if(PlayerInfo[playerid][pBusinessRank] >= 5)
		{
			if(Businesses[iBusiness][bType] == BUSINESS_TYPE_STORE || Businesses[iBusiness][bType] == BUSINESS_TYPE_GASSTATION) {
	    		new szDialog[912];
				for (new i = 0; i < sizeof(StoreItems); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s) (Cost of Good: $%s)\n", szDialog, StoreItems[i], number_format(Businesses[iBusiness][bItemPrices][i]), number_format(floatround(StoreItemCost[i][ItemValue] * BUSINESS_ITEMS_COST)) );
				ShowPlayerDialogEx(playerid, DIALOG_STOREPRICES, DIALOG_STYLE_LIST, "Edit 24/7 Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}

		    else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_CLOTHING) {
		    	ShowPlayerDialogEx(playerid, DIALOG_STORECLOTHINGPRICE, DIALOG_STYLE_INPUT, "Edit Price", "{FFFFFF}Enter the new sale price for clothing\n(Items with the price of $0 will not be for sale)", "Okay", "Cancel");
                SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_GUNSHOP) {
			    new szDialog[512];
				for (new i = 0; i < sizeof(Weapons); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, GetWeaponNameEx(Weapons[i][WeaponId]), number_format(Businesses[iBusiness][bItemPrices][i]));
				ShowPlayerDialogEx(playerid, DIALOG_GUNPRICES, DIALOG_STYLE_LIST, "Edit Weapon Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_BAR || Businesses[iBusiness][bType] == BUSINESS_TYPE_CLUB /*|| Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT*/)
			{
			    new szDialog[512];
				for (new i; i < sizeof(Drinks); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, Drinks[i], number_format(Businesses[iBusiness][bItemPrices][i]));
				ShowPlayerDialogEx(playerid, DIALOG_BARPRICE, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_SEXSHOP)
			{
			    new szDialog[512];
				for (new i = 0; i < sizeof(SexItems); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, SexItems[i], number_format(Businesses[iBusiness][bItemPrices][i]));
				ShowPlayerDialogEx(playerid, DIALOG_SEXSHOP, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if (Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT)
			{
				new buf[512];
				for (new i = 0; i < sizeof(RestaurantItems); ++i)
				{
					format(buf, sizeof(buf), "%s%s  ($%s)\n", buf, RestaurantItems[i], number_format(Businesses[iBusiness][bItemPrices][i]));
				}

				ShowPlayerDialogEx(playerid, DIALOG_RESTAURANT, DIALOG_STYLE_LIST, "Edit Business Prices", buf, "Chinh sua", "Huy");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Chu so huu.");
		    return 1;
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong phai la Chu so huu.");
	}
	return 1;
}

CMD:bizlock(playerid, params[])
{
	if(PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID && PlayerInfo[playerid][pBusinessRank] >= Businesses[PlayerInfo[playerid][pBusiness]][bMinDoorRank] &&
	IsPlayerInRangeOfPoint(playerid, 2.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2]))
	{
		if(Businesses[PlayerInfo[playerid][pBusiness]][bStatus] == 1)
		{
			Businesses[PlayerInfo[playerid][pBusiness]][bStatus] = 0;
			new string[MAX_PLAYER_NAME + 28];
			format(string, sizeof(string), "* %s da KHOA cua Biz.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			Businesses[PlayerInfo[playerid][pBusiness]][bStatus] = 1;
			new string[MAX_PLAYER_NAME + 28];
			format(string, sizeof(string), "* %s da MO KHOA cua BIZ.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		RefreshBusinessPickup(PlayerInfo[playerid][pBusiness]);
		Streamer_UpdateEx(playerid, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2]);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong dung gan cua hang cua ban hoac khong du quyen de thuc hien.");
		return 1;
	}
	return 1;
}

stock LoadBusinesses() {
	printf("[LoadBusinesses] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT OwnerName.Username, b.* FROM businesses b LEFT JOIN accounts OwnerName ON b.OwnerID = OwnerName.id", "BusinessesLoadQueryFinish", "");
}

forward BusinessesLoadQueryFinish();
public BusinessesLoadQueryFinish()
{

	new i, rows;
	cache_get_row_count(rows);
	while(i < rows)
	{
		cache_get_value_name(i, "Name", Businesses[i][bName], MAX_BUSINESS_NAME);
		cache_get_value_name_int(i, "OwnerID", Businesses[i][bOwner]);
		cache_get_value_name(i, "Username", Businesses[i][bOwnerName], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "Type", Businesses[i][bType]);
		cache_get_value_name_int(i, "Value", Businesses[i][bValue]);
		cache_get_value_name_int(i, "Status", Businesses[i][bStatus]);
		cache_get_value_name_int(i, "Level", Businesses[i][bLevel]);
		cache_get_value_name_int(i, "LevelProgress", Businesses[i][bLevelProgress]);
		cache_get_value_name_int(i, "SafeBalance", Businesses[i][bSafeBalance]);
		cache_get_value_name_int(i, "Inventory", Businesses[i][bInventory]);
		cache_get_value_name_int(i, "InventoryCapacity", Businesses[i][bInventoryCapacity]);
		cache_get_value_name_int(i, "AutoSale", Businesses[i][bAutoSale]);
		cache_get_value_name_int(i, "TotalSales", Businesses[i][bTotalSales]);
		cache_get_value_name_float(i, "ExteriorX", Businesses[i][bExtPos][0]);
		cache_get_value_name_float(i, "ExteriorY", Businesses[i][bExtPos][1]);
		cache_get_value_name_float(i, "ExteriorZ", Businesses[i][bExtPos][2]);
		cache_get_value_name_float(i, "ExteriorA", Businesses[i][bExtPos][3]);
		cache_get_value_name_float(i, "InteriorX", Businesses[i][bIntPos][0]);
		cache_get_value_name_float(i, "InteriorY", Businesses[i][bIntPos][1]);
		cache_get_value_name_float(i, "InteriorZ", Businesses[i][bIntPos][2]);
		cache_get_value_name_float(i, "InteriorA", Businesses[i][bIntPos][3]);
		cache_get_value_name_int(i, "Interior", Businesses[i][bInt]);
		cache_get_value_name_float(i, "SupplyPointX", Businesses[i][bSupplyPos][0]);
		cache_get_value_name_float(i, "SupplyPointY", Businesses[i][bSupplyPos][1]);
		cache_get_value_name_float(i, "SupplyPointZ", Businesses[i][bSupplyPos][2]);
		cache_get_value_name_float(i, "GasPrice", Businesses[i][bGasPrice]);
		cache_get_value_name(i, "OrderBy", Businesses[i][bOrderBy], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "OrderState", Businesses[i][bOrderState]);
		cache_get_value_name_int(i, "OrderAmount", Businesses[i][bOrderAmount]);
		cache_get_value_name(i, "OrderDate", Businesses[i][bOrderDate], 30);
		cache_get_value_name_int(i, "CustomExterior", Businesses[i][bCustomExterior]);
		cache_get_value_name_int(i, "CustomInterior", Businesses[i][bCustomInterior]);
		cache_get_value_name_int(i, "Grade", Businesses[i][bGrade]);
		cache_get_value_name_int(i, "CustomVW", Businesses[i][bVW]);
		cache_get_value_name_int(i, "Pay", Businesses[i][bAutoPay]);
		cache_get_value_name_int(i, "MinInviteRank", Businesses[i][bMinInviteRank]);
		cache_get_value_name_int(i, "MinSupplyRank", Businesses[i][bMinSupplyRank]);
		cache_get_value_name_int(i, "MinGiveRankRank", Businesses[i][bMinGiveRankRank]);
		cache_get_value_name_int(i, "MinSafeRank", Businesses[i][bMinSafeRank]);
		cache_get_value_name_int(i, "Months", Businesses[i][bMonths]);
		cache_get_value_name_int(i, "GymEntryFee", Businesses[i][bGymEntryFee]);
		cache_get_value_name_int(i, "GymType", Businesses[i][bGymType]);

		if (Businesses[i][bOrderState] == 2) {
		    Businesses[i][bOrderState] = 1;
		}

		if(Businesses[i][bExtPos][0] != 0.0) RefreshBusinessPickup(i); // If the business is at blueberry, do not spawn it

		for (new j; j <= 5; j++)
		{
		    new col[9];
			format(col, sizeof(col), "Rank%dPay", j);
			cache_get_value_name_int(i, col, Businesses[i][bRankPay][j]);
		}

		if (Businesses[i][bType] == BUSINESS_TYPE_GASSTATION)
		{
			for (new j, column[17]; j < MAX_BUSINESS_GAS_PUMPS; j++)
			{
			    format(column, sizeof(column), "GasPump%dPosX", j + 1);
				cache_get_value_name_float(i, column, Businesses[i][GasPumpPosX][j]);
			    format(column, sizeof(column), "GasPump%dPosY", j + 1);
				cache_get_value_name_float(i, column, Businesses[i][GasPumpPosY][j]);
			    format(column, sizeof(column), "GasPump%dPosZ", j + 1);
				cache_get_value_name_float(i, column, Businesses[i][GasPumpPosZ][j]);
			    format(column, sizeof(column), "GasPump%dAngle", j + 1);
				cache_get_value_name_float(i, column, Businesses[i][GasPumpAngle][j]);
			    format(column, sizeof(column), "GasPump%dCapacity", j + 1);
				cache_get_value_name_float(i, column, Businesses[i][GasPumpCapacity][j]);
			    format(column, sizeof(column), "GasPump%dGas", j + 1);
				cache_get_value_name_float(i, column, Businesses[i][GasPumpGallons][j]);

				if(Businesses[i][GasPumpPosX][j] != 0.0) CreateDynamicGasPump(_, i, j);

				for (new z; z < sizeof(StoreItems); z++)
				{
			    	new col[12];
					format(col, sizeof(col), "Item%dPrice", z + 1);
					cache_get_value_name_int(i, col, Businesses[i][bItemPrices][z]);
				}
			}
		}
		else if (Businesses[i][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP || Businesses[i][bType] == BUSINESS_TYPE_OLDCARDEALERSHIP)
		{
			for (new j, column[16], label[50]; j < MAX_BUSINESS_DEALERSHIP_VEHICLES; j++)
			{

			    format(column, sizeof(column), "Car%dModelId", j);
				cache_get_value_name_int(i, column, Businesses[i][bModel][j]);
			    format(column, sizeof(column), "Car%dPosX", j);
				cache_get_value_name_float(i, column, Businesses[i][bParkPosX][j]);
			    format(column, sizeof(column), "Car%dPosY", j);
				cache_get_value_name_float(i, column, Businesses[i][bParkPosY][j]);
			    format(column, sizeof(column), "Car%dPosZ", j);
				cache_get_value_name_float(i, column, Businesses[i][bParkPosZ][j]);
			    format(column, sizeof(column), "Car%dPosAngle", j);
				cache_get_value_name_float(i, column, Businesses[i][bParkAngle][j]);
			    format(column, sizeof(column), "Car%dPrice", j);
				cache_get_value_name_int(i, column, Businesses[i][bPrice][j]);

				cache_get_value_name_float(i, "PurchaseX", Businesses[i][bPurchaseX][j]);
				cache_get_value_name_float(i, "PurchaseY", Businesses[i][bPurchaseY][j]);
				cache_get_value_name_float(i, "PurchaseZ", Businesses[i][bPurchaseZ][j]);
				cache_get_value_name_float(i, "PurchaseAngle", Businesses[i][bPurchaseAngle][j]);

				if(400 < Businesses[i][bModel][j] < 612 || Businesses[i][bParkPosX][j] != 0.0)
				{
			 		Businesses[i][bVehID][j] = CreateVehicle(Businesses[i][bModel][j], Businesses[i][bParkPosX][j], Businesses[i][bParkPosY][j], Businesses[i][bParkPosZ][j], Businesses[i][bParkAngle][j], Businesses[i][bColor1][j], Businesses[i][bColor2][j], 10);
     				format(label, sizeof(label), "%s For Sale | Price: $%s", GetVehicleName(Businesses[i][bVehID][j]), number_format(Businesses[i][bPrice][j]));
					Businesses[i][bVehicleLabel][j] = CreateDynamic3DTextLabel(label,COLOR_LIGHTBLUE,Businesses[i][bParkPosX][j], Businesses[i][bParkPosY][j], Businesses[i][bParkPosZ][j],8.0,INVALID_PLAYER_ID, Businesses[i][bVehID][j]);
				}
			}
		}
		else
		{
			for (new j; j < sizeof(StoreItems); j++)
			{
			    new col[12];
				format(col, sizeof(col), "Item%dPrice", j + 1);
				cache_get_value_name_int(i, col, Businesses[i][bItemPrices][j]);
			}
		}

		Businesses[i][bGymBoxingArena1][0] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena1][1] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena2][0] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena2][1] = INVALID_PLAYER_ID;

		for (new it = 0; it < 10; ++it)
		{
			Businesses[i][bGymBikePlayers][it] = INVALID_PLAYER_ID;
			Businesses[i][bGymBikeVehicles][it] = INVALID_VEHICLE_ID;
		}
		cache_get_value_name_int(i, "MaxLevel", Businesses[i][bMaxLevel]);
		i++;
	}
	if(i > 0) printf("[LoadBusinesses] %d businesses rehashed/loaded.", i);
	else printf("[LoadBusinesses] Failed to load any businesses.");
}

stock SaveBusiness(id)
{
	new query[4019];

	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `businesses` SET ");

	mysql_format(MainPipeline, query, sizeof(query), "%s \
	`Name` = '%e', `Type` = %d, `Value` = %d, `OwnerID` = %d, `Months` = %d, `SafeBalance` = %d, `Inventory` = %d, `InventoryCapacity` = %d, `Status` = %d, `Level` = %d, \
	`LevelProgress` = %d, `AutoSale` = %d, `OrderDate` = '%s', `OrderAmount` = %d, `OrderBy` = '%e', `OrderState` = %d, `TotalSales` = %d, ",
	query,
	Businesses[id][bName], Businesses[id][bType], Businesses[id][bValue], Businesses[id][bOwner], Businesses[id][bMonths], Businesses[id][bSafeBalance], Businesses[id][bInventory], Businesses[id][bInventoryCapacity], Businesses[id][bStatus], Businesses[id][bLevel],
	Businesses[id][bLevelProgress], Businesses[id][bAutoSale], Businesses[id][bOrderDate], Businesses[id][bOrderAmount], Businesses[id][bOrderBy], Businesses[id][bOrderState], Businesses[id][bTotalSales]);

	mysql_format(MainPipeline, query, sizeof(query), "%s \
	`ExteriorX` = %f, `ExteriorY` = %f, `ExteriorZ` = %f, `ExteriorA` = %f, \
	`InteriorX` = %f, `InteriorY` = %f, `InteriorZ` = %f, `InteriorA` = %f, \
	`Interior` = %d, `CustomExterior` = %d, `CustomInterior` = %d, `Grade` = %d, `CustomVW` = %d, `SupplyPointX` = %f, `SupplyPointY` = %f, `SupplyPointZ` = %f, ",
	query,
	Businesses[id][bExtPos][0],	Businesses[id][bExtPos][1],	Businesses[id][bExtPos][2],	Businesses[id][bExtPos][3],
	Businesses[id][bIntPos][0],	Businesses[id][bIntPos][1], Businesses[id][bIntPos][2], Businesses[id][bIntPos][3],
	Businesses[id][bInt], Businesses[id][bCustomExterior], Businesses[id][bCustomInterior], Businesses[id][bGrade], Businesses[id][bVW], Businesses[id][bSupplyPos][0],Businesses[id][bSupplyPos][1], Businesses[id][bSupplyPos][2]);

	for (new i; i < sizeof(StoreItems); i++) mysql_format(MainPipeline, query, sizeof(query), "%s`Item%dPrice` = %d, ", query, i+1, Businesses[id][bItemPrices][i]);
	for (new i; i < 5; i++)	mysql_format(MainPipeline, query, sizeof(query), "%s`Rank%dPay` = %d, ", query, i, Businesses[id][bRankPay][i], id);
	for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) mysql_format(MainPipeline, query, sizeof(query), "%s `GasPump%dPosX` = %f, `GasPump%dPosY` = %f, `GasPump%dPosZ` = %f, `GasPump%dAngle` = %f, `GasPump%dModel` = %d, `GasPump%dCapacity` = %f, `GasPump%dGas` = %f, ", query, i+1, Businesses[id][GasPumpPosX][i],	i+1, Businesses[id][GasPumpPosY][i], i+1, Businesses[id][GasPumpPosZ][i], i+1, Businesses[id][GasPumpAngle][i], i+1, 1646,i+1, Businesses[id][GasPumpCapacity],	i+1, Businesses[id][GasPumpGallons]);

	mysql_format(MainPipeline, query, sizeof(query), "%s \
	`Pay` = %d, `GasPrice` = %f, `MinInviteRank` = %d, `MinSupplyRank` = %d, `MinGiveRankRank` = %d, `MinSafeRank` = %d, `GymEntryFee` = %d, `GymType` = %d, `TotalProfits` = %d, `MaxLevel` = %d WHERE `Id` = %d",
	query,
	Businesses[id][bAutoPay], Businesses[id][bGasPrice], Businesses[id][bMinInviteRank], Businesses[id][bMinSupplyRank], Businesses[id][bMinGiveRankRank], Businesses[id][bMinSafeRank], Businesses[id][bGymEntryFee], Businesses[id][bGymType], Businesses[id][bTotalProfits], Businesses[id][bMaxLevel], id+1);

	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);

 	//printf("Len :%d", strlen(query));
	printf("[business] saved %i", id);

	return 1;
}

stock LoadBusinessSales() {

	print("[LoadBusinessSales] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `businesssales`", "LoadBusinessesSaless", "");
}

forward LoadBusinessesSaless();
public LoadBusinessesSaless() {

	new
		iRows,
		iIndex;

	cache_get_row_count(iRows);

	while((iIndex < iRows)) {
		cache_get_value_name_int(iIndex, "bID", BusinessSales[iIndex][bID]);
		cache_get_value_name_int(iIndex, "BusinessID", BusinessSales[iIndex][bBusinessID]);
		cache_get_value_name(iIndex, "Text", BusinessSales[iIndex][bText], 128);
		cache_get_value_name_int(iIndex, "Price", BusinessSales[iIndex][bPrice]);
		cache_get_value_name_int(iIndex, "Available", BusinessSales[iIndex][bAvailable]);
		cache_get_value_name_int(iIndex, "Purchased", BusinessSales[iIndex][bPurchased]);
		cache_get_value_name_int(iIndex, "Type", BusinessSales[iIndex][bType]);
		iIndex++;
	}
	return 1;
}

stock SaveBusinessSale(id)
{
	new query[200];
	mysql_format(MainPipeline, query, 200, "UPDATE `businesssales` SET `BusinessID` = '%d', `Text` = '%e', `Price` = '%d', `Available` = '%d', `Purchased` = '%d', `Type` = '%d' WHERE `bID` = '%d'", BusinessSales[id][bBusinessID], BusinessSales[id][bText],
	BusinessSales[id][bPrice], BusinessSales[id][bAvailable], BusinessSales[id][bPurchased], BusinessSales[id][bType], BusinessSales[id][bID]);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	printf("[BusinessSale] saved %i", id);
	return 1;
}

stock SaveDealershipSpawn(businessid) {
	new query[200];
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `businesses` SET");
	mysql_format(MainPipeline, query, sizeof(query), "%s `PurchaseX` = %0.5f, `PurchaseY` = %0.5f, `PurchaseZ` = %0.5f, `PurchaseAngle` = %0.5f", query, Businesses[businessid][bPurchaseX], Businesses[businessid][bPurchaseY], Businesses[businessid][bPurchaseZ], Businesses[businessid][bPurchaseAngle]);
    mysql_format(MainPipeline, query, sizeof(query), "%s WHERE `Id` = %d", query, businessid+1);
    mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock SaveDealershipVehicle(businessid, slotid)
{
	new query[256];
	//slotid++;
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `businesses` SET");
	mysql_format(MainPipeline, query, sizeof(query), "%s `Car%dPosX` = %0.5f,", query, slotid, Businesses[businessid][bParkPosX][slotid]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `Car%dPosY` = %0.5f,", query, slotid, Businesses[businessid][bParkPosY][slotid]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `Car%dPosZ` = %0.5f,", query, slotid, Businesses[businessid][bParkPosZ][slotid]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `Car%dPosAngle` = %0.5f,", query, slotid, Businesses[businessid][bParkAngle][slotid]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `Car%dModelId` = %d,", query, slotid, Businesses[businessid][bModel][slotid]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `Car%dPrice` = %d", query, slotid, Businesses[businessid][bPrice][slotid]);
	mysql_format(MainPipeline, query, sizeof(query), "%s WHERE `Id` = %d", query, businessid+1);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

CMD:dealershiprespawn(playerid, params[])
{
	if(!PlayerInfo[playerid][pBM]) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh do.");
	new business = PlayerInfo[playerid][pBusiness];
	if(business == INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong dung tai vi tri cua hang");
	SendClientMessageEx(playerid, COLOR_GREY, "** Respawning dealership vehicles..");
	for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
	{
		if(Businesses[business][bVehID][i] != 0) SetVehicleToRespawn(Businesses[business][bVehID][i]);
	}
	return 1;
}
