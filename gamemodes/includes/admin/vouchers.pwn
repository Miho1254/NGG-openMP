/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Vouchers System

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

stock ShowVouchers(playerid, targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new szDialog[1024], szTitle[MAX_PLAYER_NAME+9];
		SetPVarInt(playerid, "WhoIsThis", targetid);
		
		format(szTitle, sizeof(szTitle), "Voucher cua %s", GetPlayerNameEx(targetid));
		format(szDialog, sizeof(szDialog), "Car Voucher:\t\t\t{18F0F0}%d\nSilver VIP Voucher:\t\t{18F0F0}%d\nGold VIP Voucher:\t\t{18F0F0}%d\nPVIP Voucher (1 thang):\t{18F0F0}%d\nRestricted Car Voucher:\t{18F0F0}%d\nGift Reset Voucher:\t\t{18F0F0}%d\n" \
		"Priority Advert Voucher:\t{18F0F0}%d\nSilver VIP Voucher (7 ngay): \t{18F0F0}%d\nGold VIP Voucher (7 ngay):\t{18F0F0}%d\n",
		PlayerInfo[targetid][pVehVoucher], PlayerInfo[targetid][pSVIPVoucher], PlayerInfo[targetid][pGVIPVoucher], PlayerInfo[targetid][pPVIPVoucher], PlayerInfo[targetid][pCarVoucher], PlayerInfo[targetid][pGiftVoucher], PlayerInfo[targetid][pAdvertVoucher], PlayerInfo[targetid][pSVIPExVoucher], PlayerInfo[targetid][pGVIPExVoucher]);
		ShowPlayerDialogEx(playerid, DIALOG_VOUCHER, DIALOG_STYLE_LIST, szTitle, szDialog, "Chon", "Thoat");
	}
	return 1;
}	

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_VOUCHER:
		{
			if(response)
			{
				new playeridd = GetPVarInt(playerid, "WhoIsThis");
				switch(listitem)
				{

					case 0: // Car Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 1);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pVehVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 1);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Su dung Voucher", "Ban co chac chan su dung Car Voucher?", "Co", "Khong");
						}
						else if(PlayerInfo[playeridd][pVehVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 1);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s! Ban khong co Car Voucher.", GetPlayerNameEx(GetPVarInt(playerid, "WhoIsThis")));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 1: // SVIP Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 2);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pSVIPVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 2);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Su dung Voucher", "Ban co chac chan su dung Silver VIP Voucher?", "Co", "Khong");
						}
						else if(PlayerInfo[playeridd][pSVIPVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 2);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s! Ban khong co Silver VIP Voucher.", GetPlayerNameEx(GetPVarInt(playerid, "WhoIsThis")));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 2: // GVIP Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1) 
						{
							SetPVarInt(playerid, "voucherdialog", 3);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pGVIPVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 3);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Su dung Voucher", "Ban co chac chan su dung Gold VIP Voucher?", "Co", "Khong");
						}
						else if(PlayerInfo[playeridd][pGVIPVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 3);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s! Ban khong co Gold VIP Voucher.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 3: // PVIP Voucher
					{
						if(playerid != playeridd) return 1;
						if(PlayerInfo[playeridd][pPVIPVoucher] < 1) 
						{
							new szDialog[128];
							format(szDialog, sizeof(szDialog), "%s! Ban khong co PVIP Voucher (1 thang).", GetPlayerNameEx(playeridd));
							DeletePVar(playerid, "WhoIsThis");
							return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
						}
						
						if(PlayerInfo[playerid][pDonateRank] >= 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da la Platinum VIP roi nen khong the su dung them."), DeletePVar(playerid, "WhoIsThis");
						
						ShowPlayerDialogEx(playerid, DIALOG_PVIPVOUCHER, DIALOG_STYLE_MSGBOX, "PVIP Voucher (1 thang)", "Ban se tro thanh Platinum VIP sau khi su dung phieu voucher nay.", "Xac nhan", "Huy");	
					}
					case 4: // Restricted Car Voucher
					{
						if(playerid != playeridd) return 1;
						
						if(ShopClosed == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Shop hien dang dong cua.");
						
						if(PlayerInfo[playeridd][pCarVoucher] < 1) 
						{
							new szDialog[128];
							format(szDialog, sizeof(szDialog), "%s! Ban khong co Retricted Car Voucher", GetPlayerNameEx(playeridd));
							DeletePVar(playerid, "WhoIsThis");
							return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
						}
						if(!IsPlayerInDynamicArea(playerid, NGGShop) && GetPlayerVirtualWorld(playerid) != 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai o cua hang xe tai GN SHOP de co the doi Car Voucher.");
						ShowModelSelectionMenu(playerid, CarList3, "Car Shop");
					}
					case 5: // Gift Reset Voucher
					{
						if((PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] >= 1) && PlayerInfo[playerid][pTogReports] == 0)
						{
							SetPVarInt(playerid, "voucherdialog", 4);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pGiftVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 4);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Su dung Voucher", "Ban co chac chan su dung Gift Reset Voucher?", "Co", "Khong");
						}
						else if(PlayerInfo[playeridd][pGiftVoucher] < 1)
						{
							if((PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] >= 1) && PlayerInfo[playerid][pTogReports] == 0)
							{
								SetPVarInt(playerid, "voucherdialog", 4);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s! Ban khong co Gift Reset Voucher.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 6: // Priority Advertisement Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 5);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pAdvertVoucher] > 0 && (playerid == playeridd))
						{
							return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use your voucher through here, you will be prompt a dialog while in the advertisement menu to use this voucher.");
						}
						else if(PlayerInfo[playeridd][pAdvertVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 5);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s %s! Ban khong co Priority Advertisement Voucher.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 7: // 7 Days Silver VIP
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 6);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pSVIPExVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 5);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Su dung Voucher", "Ban co chac chan su dung Silver VIP Voucher (7 ngay)?", "Co", "Khong");
						}
						else if(PlayerInfo[playeridd][pSVIPExVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 6);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s! Ban khong co Silver VIP Voucher (7 ngay)", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 8: // 7 Days Gold VIP
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 7);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pGVIPExVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 6);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Su dung Voucher", "Ban co chac chan su dung Gold VIP Voucher (7 ngay)?", "Co", "Khong");
						}
						else if(PlayerInfo[playeridd][pGVIPExVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 7);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s! Ban khong co Gold VIP Voucher (7 ngay).", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Thoat", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
				}
			} 
		}		
		case DIALOG_VOUCHERADMIN:
		{
			if(response)
			{
				if(!isnull(inputtext))
				{
					if(IsNumeric(inputtext))
					{
						if(!IsPlayerConnected(GetPVarInt(playerid, "WhoIsThis"))) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player has disconnected from the server.");
						if(strval(inputtext) < 1) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GRAD1, "You can't give less than 1 voucher.");
						if(GetPVarInt(playerid,	"voucherdialog") == 1) // Car Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"), 
								amount = strval(inputtext),
								szString[128];
								
							PlayerInfo[targetid][pVehVoucher] += amount;
							format(szString, sizeof(szString), "Ban da set cho %s (%d Car Voucher).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "Ban da nhan duoc %d Car Voucher boi %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "%s da duoc cho %s(%d) %d car voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), amount);
							Log("logs/vouchers.log", szString);
						}
						if(GetPVarInt(playerid,	"voucherdialog") == 2) // SVIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"), 
								amount = strval(inputtext),
								szString[128];
								
							PlayerInfo[targetid][pSVIPVoucher] += amount;
							format(szString, sizeof(szString), "Ban da set cho %s (%d Silver VIP Voucher).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "Ban da nhan duoc %d Silver VIP Voucher boi %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "%s da duoc cho %s(%d) %d Silver VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), amount);
							Log("logs/vouchers.log", szString);
						}
						if(GetPVarInt(playerid,	"voucherdialog") == 3) // GVIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"), 
								amount = strval(inputtext),
								szString[128];
								
							PlayerInfo[targetid][pGVIPVoucher] += amount;
							format(szString, sizeof(szString), "Ban da set cho %s (%d Gold VIP Voucher).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "Ban da nhan duoc %d Gold VIP Voucher boi %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "%s da duoc cho %s(%d) %d Gold VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), amount);
							Log("logs/vouchers.log", szString);
						}
						if(GetPVarInt(playerid, "voucherdialog") == 4) // Gift Reset Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pGiftVoucher] += amount;
							format(szString, sizeof(szString), "Ban da set cho %s (%d Gift Reset Voucher).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "Ban da nhan duoc %d Gift Reset Voucher boi %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) da duoc cho %s(%d)(IP:%s) %d free gift reset voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/adminrewards.log", szString);	
						}
						if(GetPVarInt(playerid, "voucherdialog") == 5) // Priority Advertisement Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pAdvertVoucher] += amount;
							format(szString, sizeof(szString), "Ban da set cho %s (%d Priority Advertisement Voucher).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "Ban da nhan duoc %d Priority Advertisement Voucher boi %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) da duoc cho %s(%d)(IP:%s) %d free Priority Advertisement voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/vouchers.log", szString);	
						}
						if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days Silver VIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pSVIPExVoucher] += amount;
							format(szString, sizeof(szString), "Ban da set cho %s (%d Silver VIP voucher 7 ngay).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "Ban da nhan duoc %d Silver VIP Voucher (7 ngay) boi %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) da duoc cho %s(%d)(IP:%s) %d free 7 Days Silver VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/vouchers.log", szString);	
						}
						if(GetPVarInt(playerid, "voucherdialog") == 7) // 7 Days Gold VIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pGVIPExVoucher] += amount;
							format(szString, sizeof(szString), "Ban da set cho %s (%d Gold VIP Voucher 7 ngay).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "Ban da nhan duoc %d Gold VIP Voucher (7 ngay) boi %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_GREEN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) da duoc cho %s(%d)(IP:%s) %d free 7 Days Gold VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/vouchers.log", szString);	
						}
					}
					else ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System - {FF0000}That's not a number", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}	
				else ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System ", "Please enter how many would you like to give to this player.", "Enter", "Cancel");	
			}
			DeletePVar(playerid, "voucherdialog");
			DeletePVar(playerid, "WhoIsThis");
		}										
		case DIALOG_VOUCHER2:
		{
			if(response) // Clicked "Use"
			{	
				if(PlayerInfo[playerid][pJailTime] > 0)
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the su dung voucher khi dang o tu.");
				}
				if(GetPVarInt(playerid, "voucherdialog") == 1) // Car Voucher
				{
					if(GetPlayerInterior(playerid) != 0 || !IsPlayerInDynamicArea(playerid, NGGShop)) 
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						if(GetPlayerInterior(playerid) != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this while being inside an interior.");
						if(!IsPlayerInDynamicArea(playerid, NGGShop) && GetPlayerVirtualWorld(playerid) != 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai o cua hang xe tai GN SHOP de co the doi Car Voucher.");
					}
					else
					{
						return ShowModelSelectionMenu(playerid, CarList2, "Chon Car Voucher");
					}
				}
				if(GetPVarInt(playerid, "voucherdialog") == 2) // SVIP Voucher
				{
					if(PlayerInfo[playerid][pDonateRank] >= 2)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang so huu VIP Silver+");
					}
					if(PlayerInfo[playerid][pSVIPVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Silver VIP Voucher.");
					PlayerInfo[playerid][pSVIPVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 2;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 0;
					PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "[VOUCHER]: %s (%d) da su dung VIP Silver Voucher.", GetPlayerNameEx(playerid), playerid);
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "Ban da su dung thanh cong Silver VIP Voucher, hien tai ban con lai %d Silver VIP Voucher.", PlayerInfo[playerid][pSVIPVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, "{ff1500}Luu y{FFFFFF}: VIP Silver se het han sau 30 ngay (/vipdate de xem thoi han).");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Silver (2) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pSVIPVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 3) // GVIP Voucher - Not renewable
				{
					if(PlayerInfo[playerid][pDonateRank] >= 3)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang so huu VIP Gold+");
					}
					if(PlayerInfo[playerid][pGVIPVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Gold VIP Voucher.");
					PlayerInfo[playerid][pGVIPVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 3;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 0;
					PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "[VOUCHER]: %s (%d) da su dung VIP Gold Voucher.", GetPlayerNameEx(playerid), playerid);
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "Ban da su dung thanh cong Gold VIP Voucher, hien tai ban con lai %d Gold VIP Voucher.", PlayerInfo[playerid][pGVIPVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, "{ff1500}Luu y{FFFFFF}: VIP Gold se het han sau 30 ngay (/vipdate de xem thoi han).");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Gold (3) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pGVIPVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 4) // Gift Reset Voucher
				{
					if(PlayerInfo[playerid][pGiftTime] <= 0)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Hien tai ban van co the nhan qua tu cac hop qua.");
					}
					if(PlayerInfo[playerid][pGiftVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Gift Reset Voucher.");
					PlayerInfo[playerid][pGiftVoucher]--;
					PlayerInfo[playerid][pGiftTime] = 0;
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "Ban da su dung thanh cong Gift Reset Voucher, hien tai ban con lai %d Gift Reset Voucher.", PlayerInfo[playerid][pGiftVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, "{ff1500}Luu y{FFFFFF}: Bay gio ban co the nhan qua tu hop qua.");
					format(szMiscArray, sizeof(szMiscArray), "%s(%d)(IP:%s) has used a Gift Reset Voucher. (Vouchers Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pGiftVoucher]);
					Log("logs/vouchers.log", szMiscArray);	
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 5) // 7 Days Silver VIP
				{
					if(PlayerInfo[playerid][pDonateRank] >= 2)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang so huu VIP Silver+");
					}
					if(PlayerInfo[playerid][pSVIPExVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Silver VIP Voucher (7 ngay).");
					PlayerInfo[playerid][pSVIPExVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 2;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 1;
					PlayerInfo[playerid][pVIPExpire] = gettime()+604800*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "[VOUCHER]: %s (%d) da su dung VIP Silver Voucher (7 ngay).", GetPlayerNameEx(playerid), playerid);
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "Ban da su dung thanh cong Silver VIP Voucher (7 ngay), hien tai ban con lai %d Silver VIP Voucher (7 ngay).", PlayerInfo[playerid][pSVIPExVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, "{ff1500}Luu y{FFFFFF}: VIP Silver se het han sau 7 ngay (/vipdate de xem thoi han).");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Silver (7 Days)(3) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pSVIPExVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days Gold VIP
				{
					if(PlayerInfo[playerid][pDonateRank] >= 3)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban dang so huu VIP Gold+");
					}
					if(PlayerInfo[playerid][pGVIPExVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Gold VIP Voucher (7 ngay).");
					PlayerInfo[playerid][pGVIPExVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 3;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 1;
					PlayerInfo[playerid][pVIPExpire] = gettime()+604800*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "[VOUCHER]: %s (%d) da su dung VIP Gold Voucher (7 ngay).", GetPlayerNameEx(playerid), playerid);
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "Ban da su dung thanh cong Gold VIP Voucher (7 ngay), hien tai ban con lai %d Gold VIP Voucher (7 ngay).", PlayerInfo[playerid][pGVIPExVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_WHITE, "{ff1500}Luu y{FFFFFF}: VIP Gold se het han sau 7 ngay (/vipdate de xem thoi han).");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Gold (7 Days)(3) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pGVIPExVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
			}
			DeletePVar(playerid, "voucherdialog");
			DeletePVar(playerid, "WhoIsThis");
		}
	}
	return 0;
}

// Start of the voucher commands
CMD:myvouchers(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the su dung voucher khi dang o tu.");
	
	ShowVouchers(playerid, playerid);
	return 1;
}

CMD:admkiemtravouchers(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co quyen de thuc hien lenh nay!");
	if(sscanf(params, "u", targetid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /checkvouchers [player]");
	if(!IsPlayerConnected(targetid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong ton tai.");
	
	ShowVouchers(playerid, targetid);
	return 1;
}		

CMD:sellvoucher(playerid, params[])
{
	//if(PlayerInfo[playerid][pAdmin] < 99999) return SendClientMessageEx(playerid, COLOR_GRAD1, "Hien tai lenh nay da bi vo hieu hoa, se som mo lai...");
	new choice[32], amount, price, buyer;
    if(sscanf(params, "s[32]ddu", choice, amount, price, buyer))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /sellvoucher [lua chon] [so luong] [price] [player]");
		SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: CarVoucher, SilverVIP, PVIP, RestrictedCar, Advert, 7DaySVIP, 7DayGVIP");
		return 1;
	}
	if(buyer == INVALID_PLAYER_ID || PlayerInfo[buyer][pLevel] < 2 || PlayerInfo[playerid][pLevel] < 2) return SendClientMessage(playerid, -1, "Ban khong the thuc hien dieu nay!");
	new Float: bPos[3];
	GetPlayerPos(buyer, bPos[0], bPos[1], bPos[2]);
	if(GetPlayerVirtualWorld(buyer) != GetPlayerVirtualWorld(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong dung ganthis player.");
	if(price < 1 || price > 99999999) return SendClientMessageEx(playerid, COLOR_GRAD1, "So tien khong duoc thap hon $1 va cao hon $99,999,999.");
	if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "So luong khong duoc thap hon 1.");
	if(!IsPlayerConnected(buyer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong ton tai.");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, bPos[0], bPos[1], bPos[2])) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong dung gan nguoi nay.");
	if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay bay gio.");
	if(GetPVarInt(buyer, "Injured") != 0 || PlayerCuffed[buyer] != 0 || PlayerInfo[buyer][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the giao dich voucher voi mot nguoi dang bi thuong hoac dang o tu.");
	if(GetPVarType(buyer, "buyingVoucher")) return SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi nay dang co mot de nghi khac, vui long thu lai sau...");
	if(playerid == buyer) return SendClientMessageEx(playerid, -1, "Ban khong the ban cho chinh ban");
	new string[128];
	if(strcmp(choice, "carvoucher", true) == 0) 
	{
		if(amount > PlayerInfo[playerid][pVehVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");
		
		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 1);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d Car Voucher voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d Car Voucher voi gia $%s.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "silvervip", true) == 0) 
	{
		if(amount > PlayerInfo[playerid][pSVIPVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");
		
		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 2);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d Silver VIP Voucher voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d Silver VIP Voucher voi gia $%s.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	/*else if(strcmp(choice, "goldvip", true) == 0) 
	{
		if(amount > PlayerInfo[playerid][pGVIPVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");
		
		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 3);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d Gold VIP Voucher voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d Gold VIP Voucher voi gia $%s", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}*/
	else if(strcmp(choice, "pvip", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pPVIPVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 4);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d PVIP Voucher (1 thang) voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d PVIP Voucher (1 thang) voi gia $%s", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "restrictedcar", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pCarVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 5);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d Restricted Car Voucher voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d Restricted Car Voucher voi gia $%s", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "advert", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pAdvertVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 6);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d Priority Advertisement Voucher voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d Priority Advertisement Voucher voi gia $%s.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "7daysvip", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pSVIPExVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 7);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d Silver VIP Voucher (7 ngay) voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d Silver VIP Voucher (7 ngay) voi gia $%s.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "7daygvip", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pGVIPExVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong co voucher nay.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 8);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s da de nghi ban mua %d Gold VIP Voucher (7 ngay) voi gia $%s - (/chapnhan voucher hoac /tuchoivoucher).", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Ban da de nghi %s mua %d Gold VIP Voucher (7 ngay) voi gia $%s.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "Lua chon khong hop le.");
	return 1;
}	

CMD:denyvoucher(playerid, params[])
{
	if(GetPVarType(playerid, "buyingVoucher"))
	{
		new string[128];
		format(string, sizeof(string), "* %s da tu choi de nghi giao dich voucher.", GetPlayerNameEx(playerid));
		SendClientMessageEx(GetPVarInt(playerid, "sellerVoucher"), COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* Ban da tu choi de nghi giao dich voucher tu %s.", GetPlayerNameEx(GetPVarInt(playerid, "sellerVoucher")));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		DeletePVar(playerid, "priceVoucher");
		DeletePVar(playerid, "amountVoucher");
		DeletePVar(playerid, "buyingVoucher");
		DeletePVar(playerid, "sellerVoucher");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "Khong ai de nghi giao dich voucher voi ban ca.");
	return 1;
}		

CMD:voucherhelp(playerid, params[])
{
	SetPVarInt(playerid, "HelpResultCat0", 10);
	Help_ListCat(playerid, DIALOG_HELPCATOTHER1);
	return 1;
}

CMD:ovoucherhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GREEN, "__________________TRO GIUP VOUCHER____________________");
	SendClientMessageEx(playerid, COLOR_GRAD1, "** LENH: /phieucuatoi /tuchoivoucher /chapnhan voucher");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** Admin CMD: /checkvouchers");
	}
	return 1;
}
//end of the voucher commands
