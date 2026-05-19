
#include <YSI\y_hooks>

#include <dini>



//item

//
enum inv
{
    MSlot,
    iSlot[21]
}
new SlotBalo[MAX_PLAYERS][inv];


CMD:balo(playerid, params[])
{
    	if(PlayerInfo[playerid][pAdmin] >= 2)
        {
			ShowBalo(playerid);
		}
    	return 1;
}
hook OnPlayerDisconnect(playerid, reason)
{
    SaveBalo(playerid);
    return 1;
}
hook OnPlayerSpawn(playerid)
{
    LoadBalo(playerid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{

    return 1;
}
/*public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if ((newkeys & KEY_CTRL_BACK))
	{
        if(IsPlayerInAnyVehicle(playerid) == 0)
        {
        	if(GetPVarInt(playerid, "IsInArena") >= 0)
			{
				SendClientMessage(playerid, -1, "Ban khong the lam dieu nay trong dau truong!");
				return 1;
			}
			if(GetPVarInt( playerid, "EventToken") != 0)
			{
				SendClientMessage(playerid, -1, "Ban khong the lam dieu nay khi dang trong su kien.");
				return 1;
			}
			ShowBalo(playerid);
		}
	}
	return 1;
}*/

CMD:addskin(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
    new giveplayerid, idskin;
    if(sscanf(params, "udd", giveplayerid, idskin))
    {
            SendClientMessage(playerid, COLOR_GRAD1,"SU DUNG: /addskin [player] [ID Skin]");
            return 1;
    }
    if(IsPlayerConnected(giveplayerid))
        {
            new string[64];
            AddItem(giveplayerid,idskin);
            format(string, sizeof(string), "Ban da nhan duoc mot bo trang phuc tu Admin %s.", GetPlayerNameEx(playerid));
            SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
        }
     }
    else
    {
        SendClientMessage(playerid, 0xf8F8F8FFF,"Ban khong co quyen de thuc hien lenh nay.");
    }
    return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) // ADD SKIN
{
	if(dialogid == ITEM_SKIN) // SKIN ID: 21001
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21001);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21001);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 16603236, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay co the nhan tu Event.", "Xac nhan", "");
	        		return 1;
				}
			}
		}

    if(dialogid == ITEM_SKIN2) // SKIN ID: 21002
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21002);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21002);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 166415166, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay co the nhan tu Event.", "Xac nhan", "");
	        		return 1;
				}
			}
		}

  	if(dialogid == ITEM_SKIN3) // SKIN ID: 21003
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21003);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21003);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 161561164, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay co the nhan tu Event", "Xac nhan", "");
	        		return 1;
				}
			}
		}

	if(dialogid == ITEM_SKIN4)// SKIN ID: 21004
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21004);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21004);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 151518845, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay co the nhan tu Event", "Xac nhan", "");
	        		return 1;
				}
			}
		}

	if(dialogid == ITEM_SKIN5)// SKIN ID: 21005
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21005);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21005);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 153616518, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban chi co the nhan tu Admin", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN6)// SKIN ID: 21006
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21006);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21006);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 1515161848, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban chi co the nhan tu Admin", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN7)// SKIN ID: 21014
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21014);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21014);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 312211518, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Rick Statham", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN8)// SKIN ID: 21015
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21015);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21015);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 151613154, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Bi Bi", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN9)// SKIN ID: 21016
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21016);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21016);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 984121631, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Rick Statham", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN10)// SKIN ID: 21017
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21017);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21017);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 161651312, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Ngoc Tienn", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN11)// SKIN ID: 21018
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21018);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21018);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 1231315161, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Quang Hac", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN12)// SKIN ID: 21019
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21019);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21019);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 156156121, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Quang Hac", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN13)// SKIN ID: 21020
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21020);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21020);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 311545925, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Bryan Mills", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN14)// SKIN ID: 21021
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21021);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21021);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 311545925, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Temira Vo", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN15)// SKIN ID: 21022
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21022);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21022);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 311545925, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Temira Vo", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN16)// SKIN ID: 21049
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21049);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21049);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 16516513213, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban the co khi tham gia to chuc SASD", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN17)// SKIN ID: 21050
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21050);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21050);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 9498412615, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban the co khi tham gia to chuc SASD", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN18)// SKIN ID: 21051
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21051);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21051);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 1021215150, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban the co khi tham gia to chuc FDSA", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN19)// SKIN ID: 21052
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21052);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21052);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 12120205, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban the co khi tham gia to chuc FDSA", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN20)// SKIN ID: 21053
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21053);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21053);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 12120205, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban the co khi tham gia to chuc San Andreas Goverment (LS)", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN21)// SKIN ID: 21054
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21054);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21054);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 235485215, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban the co khi tham gia to chuc San Andreas Goverment (LS)", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN22)// SKIN ID: 21083
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21083);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21083);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 145151236, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay ban co the so huu neu la Pizza Boy chan chinh", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN23)// SKIN ID: 21084
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21084);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21084);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 212151866, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc doc quyen cua Hien, ban co the nhan khi la Friends cua Hien", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	if(dialogid == ITEM_SKIN24)// SKIN ID: 21085
	    {
		    if(response)
		    {
			    if(listitem == 0)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da mang bo trang phuc.");
                    SetPlayerSkin(playerid, 21085);
	        		return 1;
				}
				if(listitem == 1)
			    {
                    SendClientMessage(playerid,-1,"[{F5CB42}BALO{FFFFFF}] Ban da vut bo trang phuc.");
	        		XoaItem(playerid,21085);
	        		ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
	        		return 1;
				}
				if(listitem == 2)
			    {
                    ShowPlayerDialog(playerid, 1213051515, DIALOG_STYLE_MSGBOX, "Thong tin trang phuc", "Trang phuc nay kha hiem tai may chu GTA Network", "Xac nhan", "");
	        		return 1;
				}
			}
		}
	return 1;
}

stock XoaItem(playerid,modelid)
{
    for(new i = 0;i<20;i++)
    {
    if(SlotBalo[playerid][iSlot][i] == modelid)
    {
    SlotBalo[playerid][iSlot][i] = 0;
    break;
    }
    }
    return 1;
}

stock AddItem(playerid,modelid)
{
    for(new i = 0;i<20;i++)
    {
    if(SlotBalo[playerid][iSlot][i] == 0)
    {
    SlotBalo[playerid][iSlot][i] = modelid;
    break;
    }

    }
    return 1;
}
stock ShowBalo(playerid)
{
    new iteminv[20];
    for(new i = 0; i < 20;i++)
    {
    iteminv[i] = SlotBalo[playerid][iSlot][i];
    if(SlotBalo[playerid][iSlot][i] == 0)
    {
    	iteminv[i] = 19198;
    }

    }
    SendClientMessage(playerid,-1, "[{F5CB42}BALO{FFFFFF}] Ban da mo balo.");
    ShowModelSelectionMenuEx(playerid, iteminv, 20, "Balo", INVENTORY_MENU, 0.4, 0.4, -20.5);
    return 1;
}

stock SaveBalo(playerid)
{
    new file[64];
    format(file, sizeof(file), "balo/%s.ini", GetName(playerid));
    if(!dini_Exists(file)) dini_Create(file);
    dini_IntSet(file, "Slot0", SlotBalo[playerid][iSlot][0]);
    dini_IntSet(file, "Slot1", SlotBalo[playerid][iSlot][1]);
    dini_IntSet(file, "Slot2", SlotBalo[playerid][iSlot][2]);
    dini_IntSet(file, "Slot3", SlotBalo[playerid][iSlot][3]);
    dini_IntSet(file, "Slot4", SlotBalo[playerid][iSlot][4]);
    dini_IntSet(file, "Slot5", SlotBalo[playerid][iSlot][5]);
    dini_IntSet(file, "Slot6", SlotBalo[playerid][iSlot][6]);
    dini_IntSet(file, "Slot7", SlotBalo[playerid][iSlot][7]);
    dini_IntSet(file, "Slot8", SlotBalo[playerid][iSlot][8]);
    dini_IntSet(file, "Slot9", SlotBalo[playerid][iSlot][9]);
    dini_IntSet(file, "Slot10", SlotBalo[playerid][iSlot][10]);
    dini_IntSet(file, "Slot11", SlotBalo[playerid][iSlot][11]);
    dini_IntSet(file, "Slot12", SlotBalo[playerid][iSlot][12]);
    dini_IntSet(file, "Slot13", SlotBalo[playerid][iSlot][13]);
    dini_IntSet(file, "Slot14", SlotBalo[playerid][iSlot][14]);
    dini_IntSet(file, "Slot15", SlotBalo[playerid][iSlot][15]);
    dini_IntSet(file, "Slot16", SlotBalo[playerid][iSlot][16]);
    dini_IntSet(file, "Slot17", SlotBalo[playerid][iSlot][17]);
    dini_IntSet(file, "Slot18", SlotBalo[playerid][iSlot][18]);
    dini_IntSet(file, "Slot19", SlotBalo[playerid][iSlot][19]);
    dini_IntSet(file, "Slot20", SlotBalo[playerid][iSlot][20]);

}
stock LoadBalo(playerid)
{
    new file[64];
    format(file, sizeof(file), "balo/%s.ini", GetName(playerid));
    SlotBalo[playerid][iSlot][0] = dini_Int(file,"Slot0");
    SlotBalo[playerid][iSlot][1] = dini_Int(file,"Slot1");
    SlotBalo[playerid][iSlot][2] = dini_Int(file,"Slot2");
    SlotBalo[playerid][iSlot][3] = dini_Int(file,"Slot3");
    SlotBalo[playerid][iSlot][4] = dini_Int(file,"Slot4");
    SlotBalo[playerid][iSlot][5] = dini_Int(file,"Slot5");
    SlotBalo[playerid][iSlot][6] = dini_Int(file,"Slot6");
    SlotBalo[playerid][iSlot][7] = dini_Int(file,"Slot7");
    SlotBalo[playerid][iSlot][8] = dini_Int(file,"Slot8");
    SlotBalo[playerid][iSlot][9] = dini_Int(file,"Slot9");
    SlotBalo[playerid][iSlot][10] = dini_Int(file,"Slot10");
    SlotBalo[playerid][iSlot][11] = dini_Int(file,"Slot11");
    SlotBalo[playerid][iSlot][12] = dini_Int(file,"Slot12");
    SlotBalo[playerid][iSlot][13] = dini_Int(file,"Slot13");
    SlotBalo[playerid][iSlot][14] = dini_Int(file,"Slot14");
    SlotBalo[playerid][iSlot][15] = dini_Int(file,"Slot15");
    SlotBalo[playerid][iSlot][16] = dini_Int(file,"Slot16");
    SlotBalo[playerid][iSlot][17] = dini_Int(file,"Slot17");
    SlotBalo[playerid][iSlot][18] = dini_Int(file,"Slot18");
    SlotBalo[playerid][iSlot][19] = dini_Int(file,"Slot19");
    SlotBalo[playerid][iSlot][20] = dini_Int(file,"Slot20");
}
stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}




