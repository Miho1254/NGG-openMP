#if defined _modules_gs_utils_included
    #endinput
#endif

#define _modules_gs_utils_included

#include <YSI\y_hooks>

new skinCustomVIPList[] =
{
    20006, 20009
};

stock GetPlayerItemAmountTotal(playerid, itemid)
{
    new total = 0;
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] == itemid && CharacterInfo[playerid][0][cb_ItemLock][i] == 0)
        {
            total += CharacterInfo[playerid][0][cb_ItemAmount][i];
        }
    }
    return total;
}

stock RemovePlayerItemAmountTotal(playerid, itemid, amount)
{
    new remaining = amount;
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] == itemid && CharacterInfo[playerid][0][cb_ItemLock][i] == 0)
        {
            new slotAmount = CharacterInfo[playerid][0][cb_ItemAmount][i];
            if(slotAmount >= remaining)
            {
                CharacterInfo[playerid][0][cb_ItemAmount][i] -= remaining;
                if(CharacterInfo[playerid][0][cb_ItemAmount][i] <= 0)
                {
                    RemovePlayerItem(playerid, i);
                }
                else
                {
                    CharacterInfo[playerid][0][cb_ItemWeight][i] = GetItemWeight(itemid);
                }
                remaining = 0;
                break;
            }
            else
            {
                remaining -= slotAmount;
                RemovePlayerItem(playerid, i);
            }
        }
    }
    return (remaining == 0);
}

/*CMD:quadenbu(playerid, params[])
{
    if(PlayerData[playerid][pc_LimitEventReward] == 0 && PlayerInfo[playerid][pDonateRank] == 3)
    {
		if(PlayerInfo[playerid][pVIPM] == 0) {
			PlayerInfo[playerid][pVIPM] = VIPM;
			VIPM++;
		}
		PlayerInfo[playerid][pDonateRank] = 3;
		PlayerInfo[playerid][pVIPExpire] = PlayerInfo[playerid][pVIPExpire]+259200;
		PlayerInfo[playerid][pTempVIP] = 0;
		PlayerInfo[playerid][pBuddyInvited] = 0;
		PlayerInfo[playerid][pVIPSellable] = 0;

        CharacterInfo[playerid][0][cb_Weight] = 80.0;

        PlayerData[playerid][pc_GP] += 15000;

        new count = 0;
        for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
        {
            if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
            {
                CharacterInfo[playerid][0][cb_ItemLock][i] = 0;
                count++;
                if(count == 2)
                    break;
            }
        }

        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban duoc gia han them 3 ngay VIP va mo rong them 2 o trong tui do va + 20 ky tui do (80KG).");

        PlayerData[playerid][pc_LimitEventReward] = 1;
    }
    else if(PlayerData[playerid][pc_LimitEventReward] == 0 && PlayerInfo[playerid][pDonateRank] != 3)
    {
		if(PlayerInfo[playerid][pVIPM] == 0) {
			PlayerInfo[playerid][pVIPM] = VIPM;
			VIPM++;
		}
		PlayerInfo[playerid][pDonateRank] = 3;
		PlayerInfo[playerid][pVIPExpire] = gettime() + 604800;
		PlayerInfo[playerid][pTempVIP] = 0;
		PlayerInfo[playerid][pBuddyInvited] = 0;
		PlayerInfo[playerid][pVIPSellable] = 0;

        CharacterInfo[playerid][0][cb_Weight] = 80.0;

        PlayerData[playerid][pc_GP] += 15000;

        new count = 0;
        for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
        {
            if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
            {
                CharacterInfo[playerid][0][cb_ItemLock][i] = 0;
                count++;
                if(count == 2)
                    break;
            }
        }

        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da nhan duoc 7 ngay VIP va mo rong them 2 o trong tui do va + 20 ky tui do (80KG) .");

        PlayerData[playerid][pc_LimitEventReward] = 1;
    }
    return 1;
}*/

CMD:nhiemvu(playerid, params[])
{
    new str[128];
    if(PlayerInfo[playerid][pTut] < 29) format(str, sizeof(str), "Nhiem vu tan thu\n");
    else format(str, sizeof(str), "Nhiem vu danh vong\nNhiem vu hang ngay");
    Dialog_Show(playerid, DIALOG_MISSION_SVLIST, DIALOG_STYLE_LIST, "Danh sach nhiem vu", str, "Chon", "Huy");
    return 1;
}

/*CMD:quadenbu(playerid, params[])
{
    if(!gPlayerLogged{playerid}) return SendClientMessageEx(playerid, COLOR_RED, "Ban chua dang nhap vao may chu!");
    if(PlayerData[playerid][pc_LimitEventReward] != 0)
        return SendClientMessageEx(playerid, COLOR_RED, "* Ban da nhan qua den bu ngay hom nay roi.");
    else
    {
        new i;
        new count = 0;
        for(i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
        {
            if(CharacterInfo[playerid][0][cb_ItemLock][i] == 1)
            {
                CharacterInfo[playerid][0][cb_ItemLock][i] = 0;
                count++;
            }
            if(count == 2) break;
        }
        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Tui do duoc mo rong them 2 slot nua.");
        new success1 = -1;
        new success2 = -1;
        SetPlayerItem(playerid, 8, 100, success1);
        SetPlayerItem(playerid, 21, 100, success2);
        if(success1 == 1)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da nhan duoc qua den bu la may khai thac thuong.");
        }
        if(success2 == 1)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da nhan duoc qua den bu la can xang 100ml.");
        }
        if(success1 == -1 && success2 == -1)
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Khong the them vat pham, vui long lien he BQT de chu dong refund.");
        }
        PlayerData[playerid][pc_GP] += 3000;
        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Da nhan refund 3000 GP vao tai khoan.");
        PlayerData[playerid][pc_LimitEventReward] = 1;
        new szQuery[256];
        mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `account2` SET `LimitEventReward` = 1 WHERE `UID` = %d", GetPlayerSQLId(playerid));
        mysql_tquery(MainPipeline, szQuery);

        new year, month, day, hours, minutes, seconds;
        getdate(year, month, day);
        gettime(hours, minutes, seconds);
        format(szQuery, sizeof(szQuery), "[%04d:%02d:%02d-%02d:%02d:%02d] %s đã nhận quà đền bù từ máy chủ.", year, month, day, hours, minutes, seconds, GetPlayerNameExt(playerid));
        SendAdminMessage(1, szQuery);
    }
    return 1;
}*/

// Dialog
Dialog:DIALOG_BUYCC_WEAPON(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(GetPVarInt(playerid, "ShopQuestion") == 1)
        {
            SetPVarInt(playerid, "ShopQuestion", 2);
            SetPVarInt(playerid, "VSShopItem", listitem);
            return Dialog_Show(playerid, DIALOG_BUYCC_WEAPON, DIALOG_STYLE_MSGBOX, "Mua vu khi can chien", "Ban co chac muon mua vat pham nay khong?", "Chac chan", "Khong");
        }
        else
        {
            if(GetPVarInt(playerid, "VSShopItem") == 0)
            {
                if(GetPlayerCash(playerid) < 500000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du tien de mua vu khi sword katana.");
                else
                {
                    new success;
                    SetPlayerItem(playerid, 49, 999999, success);
                    if(success == 1)
                    {
                        GivePlayerCash(playerid, -500000);
                        SendClientMessageEx(playerid, COLOR_WHITE, "[?] Ban da mua thanh cong vu khi 'SWORD KATANA' voi gia $500,000.");
                    }
                    else
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, "[?] Khong the mua duoc vu khi nay vi khong du cho trong/ kho do qua nang.");
                    }
                }
            }
            else if(GetPVarInt(playerid, "VSShopItem") == 1)
            {
                if(GetPlayerCash(playerid) < 450000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du tien de mua vu khi gay bong chay.");
                else
                {
                    new success;
                    SetPlayerItem(playerid, 50, 999999, success);
                    if(success == 1)
                    {
                        GivePlayerCash(playerid, -450000);
                        SendClientMessageEx(playerid, COLOR_WHITE, "[?] Ban da mua thanh cong vu khi 'GAY BONG CHAY' voi gia $450,000.");
                    }
                    else
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, "[?] Khong the mua duoc vu khi nay vi khong du cho trong/ kho do qua nang.");
                    }
                }
            }
        }
    }
    else return 1;
    return 1;
}

Dialog:DIALOG_REPORTMENU2025(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(isnull(inputtext)) return SendClientMessageEx(playerid, COLOR_WHITE, "[!] Loi: Noi dung trong.");
        else if(strlen(inputtext) > 128) return SendClientMessageEx(playerid, COLOR_WHITE, "[!] Loi: Noi dung qua dai.");
        else
        {
            SendReportToQue(playerid, inputtext, 2, 5);
			SendClientMessageEx(playerid, COLOR_WHITE, "Tin nhan cua ban da duoc gui den BQT.");
        }
    }
    else return 1;
    return 1;
}

Dialog:DIALOG_REFUNDVIP_CHOICE(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new Float:health[2];
        GetHealth(playerid, health[0]);
        GetArmour(playerid, health[1]);
        if(strcmp(inputtext, "Giap", true) == 0)
        {
            switch(PlayerInfo[playerid][pDonateRank])
            {
                case 0: return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la VIP.");
                case 1:
                {
                    if(PlayerData[playerid][pc_EA] < 2000) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du EXP Farm de lay giap!");
                    if(health[1] >= 100.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da day giap nen khong the nap them.");
                    else
                    {
                        PlayerData[playerid][pc_EA] -= 2000;
                        SetArmour(playerid, 100);
                        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da su dung 2000 EXP Farm de doi lay 100 giap.");
                    }
                }
                case 2:
                {
                    if(PlayerData[playerid][pc_EA] < 1500) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du EXP Farm de lay giap!");
                    if(health[1] >= 100.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da day giap nen khong the nap them.");
                    else
                    {
                        PlayerData[playerid][pc_EA] -= 1500;
                        SetArmour(playerid, 100);
                        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da su dung 1500 EXP Farm de doi lay 100 giap.");
                    }
                }
                case 3:
                {
                    if(health[1] >= 100.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da day giap nen khong the nap them.");
                    else
                    {
                        SetArmour(playerid, 100);
                        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da lay 100 giap mien phi tu Tu do VIP.");
                    }
                }
            }
        }
        else if(strcmp(inputtext, "Mau", true) == 0)
        {
            switch(PlayerInfo[playerid][pDonateRank])
            {
                case 0: return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai la VIP.");
                case 1:
                {
                    if(PlayerData[playerid][pc_EA] < 2000) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du EXP Farm de lay giap!");
                    if(health[0] >= 100.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da day giap nen khong the nap them.");
                    else
                    {
                        PlayerData[playerid][pc_EA] -= 2000;
                        SetHealth(playerid, 100);
                        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da su dung 2000 EXP Farm de doi lay 100 mau.");
                    }
                }
                case 2:
                {
                    if(PlayerData[playerid][pc_EA] < 1500) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du EXP Farm de lay giap!");
                    if(health[0] >= 100.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da day giap nen khong the nap them.");
                    else
                    {
                        PlayerData[playerid][pc_EA] -= 1500;
                        SetHealth(playerid, 100);
                        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da su dung 1500 EXP Farm de doi lay 100 mau.");
                    }
                }
                case 3:
                {
                    if(health[0] >= 100.0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da day giap nen khong the nap them.");
                    else
                    {
                        SetHealth(playerid, 100);
                        SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da lay 100 mau mien phi tu Tu do VIP.");
                    }
                }
            }
        }
        else if(strcmp(inputtext, "Cong viec", true) == 0)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[!] Lenh khong kha dung.");
        }
        else if(strcmp(inputtext, "Trang phuc thuong", true) == 0)
        {
            Dialog_Show(playerid, DIALOG_REFUNDVIP_SKIN, DIALOG_STYLE_INPUT, "Tu do VIP - Trang phuc thuong", "Hay nhap trang phuc ban yeu thich vao day (tu 1 - 311)", "Nhap", "Huy");
        }
        else if(strcmp(inputtext, "Trang phuc custom", true) == 0)
        {
            new str[256];
            format(str, sizeof(str), "Skin Nam-1\nSkin Nam-2");
            Dialog_Show(playerid, DIALOG_CUSTOMSKIN_VIP, DIALOG_STYLE_LIST, "Danh sach trang phuc cho phep", str, "Chon", "Huy");
        }
        Update_Adventures(playerid);
    }
    else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da ngung tuong tac voi tu do VIP.");
    return 1;
}

Dialog:DIALOG_CUSTOMSKIN_VIP(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(PlayerInfo[playerid][pDonateRank])
        {
            case 3, 4:
            {
                PlayerInfo[playerid][pModel] = skinCustomVIPList[listitem];
                SetPlayerSkin(playerid, skinCustomVIPList[listitem]);
                SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da lay mot bo quan ao tu Tu Do VIP.");
            }
            case 1:
            {
                if(PlayerData[playerid][pc_EA] < 5000) return SendClientMessageEx(playerid, COLOR_GRAD2, "[?] Ban khong du 5000 EXP de doi quan ao.");
                else
                {
                    PlayerData[playerid][pc_EA] -= 5000;
                    PlayerInfo[playerid][pModel] = skinCustomVIPList[listitem];
                    SetPlayerSkin(playerid, skinCustomVIPList[listitem]);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da lay mot bo quan ao tu Tu Do VIP.");
                }
            }
            case 2:
            {
                if(PlayerData[playerid][pc_EA] < 3000) return SendClientMessageEx(playerid, COLOR_GRAD2, "[?] Ban khong du 3000 EXP de doi quan ao.");
                else
                {
                    PlayerData[playerid][pc_EA] -= 3000;
                    PlayerInfo[playerid][pModel] = skinCustomVIPList[listitem];
                    SetPlayerSkin(playerid, skinCustomVIPList[listitem]);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da lay mot bo quan ao tu Tu Do VIP.");
                }
            }
        }
    }
    else
    {
        return 1;
    }
    return 1;
}

Dialog:DIALOG_REFUNDVIP_SKIN(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_REFUNDVIP_SKIN, DIALOG_STYLE_INPUT, "Tu do VIP - Trang phuc thuong", "Hay nhap trang phuc ban yeu thich vao day (tu 1 - 311)", "Nhap", "Huy");
        if(!IsNumeric(inputtext)) return Dialog_Show(playerid, DIALOG_REFUNDVIP_SKIN, DIALOG_STYLE_INPUT, "Tu do VIP - Trang phuc thuong", "Hay nhap trang phuc ban yeu thich vao day (tu 1 - 311)", "Nhap", "Huy");
        new id = strval(inputtext);
        if(id == 0 || id == 74 || id > 311)
        {
            return Dialog_Show(playerid, DIALOG_REFUNDVIP_SKIN, DIALOG_STYLE_INPUT, "Tu do VIP - Trang phuc thuong", "Hay nhap trang phuc ban yeu thich vao day (tu 1 - 311)", "Nhap", "Huy");
        }
        else
        {
            PlayerInfo[playerid][pModel] = id;
            SetPlayerSkin(playerid, id);
            new str[64];
            format(str, sizeof(str), "[{62FF00}Tu Do VIP{FFFFFF}] Ban da chon quan ao ID %d tu tu do VIP.", id);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
        }
    }
    else return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da ngung tuong tac voi tu do VIP.");
    return 1;
}

CMD:lawlocker(playerid, params[])
{
    if(!IsACop(playerid))
        return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong phai canh sat / nhan vien chinh phu.");

    new str[512];
    format(str, sizeof(str), "Hop dan tich hop (1200 dan)\n");
    format(str, sizeof(str), "%sM4 LAW\t(199 dan)\n", str);
    format(str, sizeof(str), "%sAK LAW\t(199 dan)\n", str);
    format(str, sizeof(str), "%sDeagle LAW\t(199 dan)\n", str);
    format(str, sizeof(str), "%s9mm LAW\t(29 dan)\n", str);
    format(str, sizeof(str), "%sMP5 LAW\t(120 dan)\n", str);

    Dialog_Show(playerid, DIALOG_LAW_WEAPON, DIALOG_STYLE_LIST, "TU DO VU KHI LAW", str, "Lay", "Thoat");
    return 1;
}

Dialog:DIALOG_LAW_WEAPON(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new item;
        
        if(listitem != 0) item = listitem + 43; 
        else item = 41; 

        new successs = -1;

        if(listitem != 0) 
        {
            SetPlayerItem(playerid, item, GetAmmoWeaponLimit(item), successs);
        }
        else 
        {
            // Ap dung cho listitem 0 (Vu khi dac biet, 1200 dan)
            SetPlayerItem(playerid, 41, 1200, successs);
        }

        if(successs == 1)
        {
            new str[256];
            format(str, sizeof(str), "[{FFB561}TUI DO{FFFFFF}] Ban da lay %s ra khoi tu do cua to chuc.", Inventory_ListItems[item - 1]);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
        }
        else 
        {
            return SendClientMessageEx(playerid, COLOR_GRAD3, "** Co loi xay ra, khong the lay vu khi tu tu do.");
        }
    }
    else
    {
        return 1;
    }
    return 1;
}
Dialog:DIALOG_MISSION_SVLIST(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strcmp(inputtext, "Nhiem vu tan thu", true) == 0)
        {
            AdvanceTutorial(playerid);
        }
        else if(strcmp(inputtext, "Nhiem vu danh vong", true) == 0)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[!] Lenh khong kha dung.");
            return 1;
        }
        else if(strcmp(inputtext, "Nhiem vu hang ngay", true) == 0)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "[!] Lenh khong kha dung.");
            return 1;
        }
    }
    else 
    {
        return 0;
    }
    return 1;
}

Dialog:DIALOG_NPC_VIPSHOP(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(GetPVarInt(playerid, "ShopQuestion") == 1)
        {
            SetPVarInt(playerid, "ShopQuestion", 2);
            SetPVarInt(playerid, "VSShopItem", listitem);
            return Dialog_Show(playerid, DIALOG_NPC_VIPSHOP, DIALOG_STYLE_MSGBOX, "Cua hang - San Fierro VIP", "Ban co chac muon mua vat pham nay khong?", "Chac chan", "Khong");
        }
        else
        {
            new count = -1;
            new i;
            if(GetPVarInt(playerid, "VSShopItem") == 0)
            {
                for(i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
                {
                    if(CharacterInfo[playerid][0][cb_ItemID][i] == 8)
                        count = 1;
                }
                if(count == -1)
                {
                    for(i = 0 ; i < 7 ; i++)
                    {
                        if(CharacterInfo[playerid][1][cb_ItemID][i] == 8)
                            count = 1;
                    }
                }

                if(count == -1)
                {
                    if(GetPlayerCash(playerid) < 150000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du tien de mua vat pham nay!");
                    new success = -1;
                    SetPlayerItem(playerid, 8, 1, success);
                    if(success == 1)
                    {
                        GivePlayerCash(playerid, -150000);
                        SetPVarInt(playerid, "NormalMachineFuel", 100);
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da mua mot may khai thac thuong voi gia $150,000.");
                    }
                }
                else SendClientMessageEx(playerid, COLOR_GRAD3, "Ban da co vat pham nay trong tui do roi nen khong the mua them nua.");
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
            if(GetPVarInt(playerid, "VSShopItem") == 2)
            {
                for(i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
                {
                    if(CharacterInfo[playerid][0][cb_ItemID][i] == 9)
                        count = 1;
                }
                if(count == -1)
                {
                    for(i = 0 ; i < 7 ; i++)
                    {
                        if(CharacterInfo[playerid][1][cb_ItemID][i] == 9)
                            count = 1;
                    }
                }

                if(count == -1)
                {
                    if(PlayerData[playerid][pc_GP] < 65000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du GP de mua vat pham nay.");
                    new success = -1;
                    SetPlayerItem(playerid, 9, 1, success);
                    if(success == 1)
                    {
                        PlayerData[playerid][pc_GP] -= 65000;
                        SetPVarInt(playerid, "VIPMachineFuel", 100);
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da mua mot may khai thac VIP voi gia 65,000 GP.");
                    }
                }
                else SendClientMessageEx(playerid, COLOR_GRAD3, "Ban da co vat pham nay trong tui do roi nen khong the mua them nua.");
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
            if(GetPVarInt(playerid, "VSShopItem") == 1)
            {
                if(GetPlayerCash(playerid) < 15000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du tien de mua vat pham nay!");
                new success = -1;
                SetPlayerItem(playerid, 11, 1, success);
                if(success == 1)
                {
                    GivePlayerCash(playerid, -15000);
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da mua mot Medkit-A voi gia $15,000");
                }
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
            if(GetPVarInt(playerid, "VSShopItem") == 3)
            {
                if(GetPlayerCash(playerid) < 120000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du tien de mua vat pham nay!");
                new success = -1;
                SetPlayerItem(playerid, 21, 100, success);
                if(success == 1)
                {
                    GivePlayerCash(playerid, -120000);
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da mua mot Can xang (100 lit) voi gia $120,000");
                }
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
            if(GetPVarInt(playerid, "VSShopItem") == 4)
            {
                if(GetPlayerCash(playerid) < 220000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du tien de mua vat pham nay!");
                new success = -1;
                SetPlayerItem(playerid, 22, 200, success);
                if(success == 1)
                {
                    GivePlayerCash(playerid, -220000);
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da mua mot Can xang (200 lit) voi gia $220,000");
                }
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
            if(GetPVarInt(playerid, "VSShopItem") == 5)
            {
                if(GetPlayerCash(playerid) < 25000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du tien de mua vat pham nay!");
                PlayerInfo[playerid][pGPS] = 1;
                GivePlayerCash(playerid, -25000);
                SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da mua mot GPS voi gia $25, hay /gps de su dung no.");
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
            if(GetPVarInt(playerid, "VSShopItem") == 6) // Phieu mo rong tui do (1 o)
            {
                new silver = GetPlayerItemAmountTotal(playerid, 3);
                new niken = GetPlayerItemAmountTotal(playerid, 4);
                new cu = GetPlayerItemAmountTotal(playerid, 6);
                new crom = GetPlayerItemAmountTotal(playerid, 7);
                new gold = GetPlayerItemAmountTotal(playerid, 5);

                if(silver < 30 || niken < 30 || cu < 40 || crom < 20 || gold < 10)
                {
                    SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong co du nguyen lieu de doi Phieu mo rong!");
                    SendClientMessageEx(playerid, COLOR_WHITE, "Yeu cau: 30 Bac, 30 Niken, 40 Dong, 20 Crom, 10 Vang.");
                }
                else
                {
                    new success = -1;
                    SetPlayerItem(playerid, 13, 1, success);
                    if(success == 1)
                    {
                        RemovePlayerItemAmountTotal(playerid, 3, 30);
                        RemovePlayerItemAmountTotal(playerid, 4, 30);
                        RemovePlayerItemAmountTotal(playerid, 6, 40);
                        RemovePlayerItemAmountTotal(playerid, 7, 20);
                        RemovePlayerItemAmountTotal(playerid, 5, 10);
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da doi thanh cong 1 Phieu mo rong slot tui do.");
                    }
                    else
                    {
                        SendClientMessageEx(playerid, COLOR_GRAD3, "Khong the them vat pham (co the tui do cua ban da day hoac qua nang).");
                    }
                }
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
            if(GetPVarInt(playerid, "VSShopItem") == 7) // The nang cap balo (+5kg)
            {
                new silver = GetPlayerItemAmountTotal(playerid, 3);
                new niken = GetPlayerItemAmountTotal(playerid, 4);
                new cu = GetPlayerItemAmountTotal(playerid, 6);
                new crom = GetPlayerItemAmountTotal(playerid, 7);
                new gold = GetPlayerItemAmountTotal(playerid, 5);

                if(silver < 50 || niken < 50 || cu < 60 || crom < 40 || gold < 30)
                {
                    SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong co du nguyen lieu de doi The nang cap trong luong!");
                    SendClientMessageEx(playerid, COLOR_WHITE, "Yeu cau: 50 Bac, 50 Niken, 60 Dong, 40 Crom, 30 Vang.");
                }
                else
                {
                    new success = -1;
                    SetPlayerItem(playerid, 54, 1, success);
                    if(success == 1)
                    {
                        RemovePlayerItemAmountTotal(playerid, 3, 50);
                        RemovePlayerItemAmountTotal(playerid, 4, 50);
                        RemovePlayerItemAmountTotal(playerid, 6, 60);
                        RemovePlayerItemAmountTotal(playerid, 7, 40);
                        RemovePlayerItemAmountTotal(playerid, 5, 30);
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{62FF00}Cua Hang{FFFFFF}] Ban da doi thanh cong 1 The nang cap balo (+5kg).");
                    }
                    else
                    {
                        SendClientMessageEx(playerid, COLOR_GRAD3, "Khong the them vat pham (co the tui do cua ban da day hoac qua nang).");
                    }
                }
                SetPVarInt(playerid, "ShopQuestion", 0);
                SetPVarInt(playerid, "VSShopItem", -1);
            }
        }
    }
    else
    {
        SetPVarInt(playerid, "ShopQuestion", 0);
        SetPVarInt(playerid, "VSShopItem", -1);
    }
    return 1;
}

new g_VIPShopActor = INVALID_ACTOR_ID;

hook OnGameModeInit()
{
    // Tao Actor NPC cho Cua hang VIP SF
    // Toa do: -2411.3362, 519.2717, 29.9297 | Huong mat: 180.0 (huong xuong phia nam)
    g_VIPShopActor = CreateActor(21088, -2411.3362, 519.2717, 29.9297, 180.0);
    SetActorInvulnerable(g_VIPShopActor, true);
    // 3D Text Label huong dan
    CreateDynamic3DTextLabel(
        "{FFFF00}[Cua Hang VIP]\n{FFFFFF}Nhan {62FF00}Y{FFFFFF} de mua vat pham\n{AAAAAA}May dao | Medkit | Xang | GPS",
        0xFFFFFFFF,
        -2411.3362, 519.2717, 30.9297,
        10.0,
        .worldid = 0
    );
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_YES) && IsPlayerInRangeOfPoint(playerid, 5.0, -2411.3362,519.2717,29.9297)) // NPC cua hang
    {
        SetPVarInt(playerid, "ShopQuestion", 1);
        new string[512];
        format(string, sizeof(string), "Vat pham ban\tGia tien / Nguyen lieu doi\n");
        strcat(string, "May khai thac (thuong)\t$150,000\n");
        strcat(string, "Medkit-A\t$15,000\n");
        strcat(string, "May khai thac (VIP)\t65,000 GP\n");
        strcat(string, "Can xang (100 lit)\t$120,000\n");
        strcat(string, "Can xang (200 lit)\t$220,000\n");
        strcat(string, "GPS\t$25,000\n");
        strcat(string, "Phieu mo rong tui do (1 o)\t30 Bac, 30 Niken, 40 Dong, 20 Crom, 10 Vang\n");
        strcat(string, "The nang cap balo (+5kg)\t50 Bac, 50 Niken, 60 Dong, 40 Crom, 30 Vang\n");
        Dialog_Show(playerid, DIALOG_NPC_VIPSHOP, DIALOG_STYLE_TABLIST_HEADERS, "Cua hang - San Fierro VIP", string, "Chon", "Huy");
    }
    return 1;
}

Function: OPDGiveDMG(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if(weaponid == 0) return 1;
    if(playerid != INVALID_PLAYER_ID && damagedid != INVALID_PLAYER_ID)
    {
        new str[256], weaponname[30];
        for(new i = 0 ; i < 7 ; i++)
        {
            if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == weaponid)
            {
                format(weaponname, sizeof(weaponname), "%s", Inventory_ListItems[CharacterInfo[playerid][1][cb_ItemID][i] - 1]);
                break;
            }
        }

        format(str, sizeof(str), "[{62FF00}LICH SU CHIEN DAU{FFFFFF}] Ban da dung %s gay %.2f sat thuong len %s.", weaponname, amount, GetPlayerNameExt(damagedid));
        SendClientMessageEx(playerid, COLOR_WHITE, str);
        format(str, sizeof(str), "[{62FF00}LICH SU CHIEN DAU{FFFFFF}] Ban da bi %s dung %s gay %.2f sat thuong len co the.", GetPlayerNameExt(playerid), weaponname, amount);
        SendClientMessageEx(playerid, COLOR_WHITE, str);
    }
    return 1;
}

Function: UPDATEVERIFICATIONTOKEN()
{
    new i;
    new rows;
    new szQuery[124];
    new accountid;
    new szCode[24];
    cache_get_row_count(rows);
    if(rows == 0) return 1;
    else
    {
        i = 0;
        while(i < rows)
        {
            cache_get_value_name_int(i, "id", accountid);
            format(szCode, sizeof(szCode), "%d%05d", accountid, random(50001));
            mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `verification_token` = '%s' WHERE `id` = %d", szCode, accountid);
            mysql_tquery(MainPipeline, szQuery);
            i++;
        }
        if(i > 0) printf("Da cap nhat %d tai khoan", i);
    }
    return 1;
}

Function: UPDATEVERIFICATIONPOSITION()
{
    new i;
    new rows;
    new szQuery[560];
    new accountid;
    cache_get_row_count(rows);
    if(rows == 0) return 1;
    else
    {
        i = 0;
        while(i < rows)
        {
            cache_get_value_name_int(i, "id", accountid);
            mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `sPos_x` = '-1605.4331', `sPos_y` = '49.4614', `sPos_z` = '3.5547', `sPos_r` = '118.0585', `Hospital` = 0, `pHealth` = '100.0' WHERE `id` = %d", accountid);
            mysql_tquery(MainPipeline, szQuery);
            i++;
        }
        if(i > 0) printf("Da cap nhat %d tai khoan", i);
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    SetPVarInt(playerid, "ShopQuestion", 0);
    SetPVarInt(playerid, "VSShopItem", -1);

    new str[256], playerip[32];
	GetPlayerIp(playerid, playerip, sizeof(playerip));

    format(str, sizeof(str), "[GSA] %s dang ket noi voi dia chi IP: %s.", GetPlayerNameExt(playerid), playerip);
    ABroadCast(COLOR_YELLOW, str, 2);
    return 1;
}

/*new const ATTACKER_SUBNET[] = "125.235.209.";

new const ATTACKER_SUBNET2[] = "42.114.203.";

new const ATTACKER_SUBNET3[] = "125.235.209.";

new const ATTACKER_SUBNET4[] = "235.209.";

new const ATTACKER_SUBNET5[] = "125.235.";

new const ATTACKER_SUBNET6[] = "27.74.";

new const ATTACKER_SUBNET7[] = ".135.";

new const ATTACKER_SUBNET8[] = "125.162.";

new const ATTACKER_SUBNET9[] = "171.253.";*/

task OnPlayerCheckIp[300]()
{
    for(new playerid = 0 ; playerid < MAX_PLAYERS ; playerid++)
    {

        if(GetPlayerWeapon(playerid) == 40)
        {
            SendClientMessageToAll(COLOR_RED," CutMeMayDi");
            CreateBan(playerid, PlayerInfo[playerid][pId], playerid, GetPlayerIpEx(playerid), "Cut me may di", 18, 1);
        }

        /*if (!IsPlayerConnected(playerid)) 
        {
            continue; 
        }

        new ipname[16];
        new name[MAX_PLAYER_NAME + 1];
        
        GetPlayerIp(playerid, ipname, sizeof(ipname));
        GetPlayerName(playerid, name, sizeof(name));
        
        if (strfind(name, "sarp", true) != -1
            || strfind(name, "ddos", true) != -1
            || strfind(name, "dos", true) != -1
            || strfind(name, "D0s", true) != -1
            || strfind(name, "bo_may", true) != -1
            || strfind(name, "tao", true) != -1 
            || strfind(name, "balas", true) != -1
            || strfind(name, "ballas", true)!= -1
            || strfind(name, "Hethon", true) != -1
            || strfind(ipname, ATTACKER_SUBNET, true) == 0 
            || strfind(ipname, ATTACKER_SUBNET2, true) == 0 
            || strfind(ipname, ATTACKER_SUBNET3, true) == 0 
            || strfind(ipname, ATTACKER_SUBNET4, true) == 0
            || strfind(ipname, ATTACKER_SUBNET5, true) == 0
            || strfind(ipname, ATTACKER_SUBNET6, true) == 0
            || strfind(ipname, ATTACKER_SUBNET7, true) == 0
            || strfind(ipname, ATTACKER_SUBNET8, true) == 0
            || strfind(ipname, ATTACKER_SUBNET9, true) == 0)
        {
            printf("[ATTACKER BLOCK] BANNED SUBNET %s for player %s. (Timer Check)", ATTACKER_SUBNET, ipname);
            
            // Block vinh vien trong he thong SA-MP (10 nam)
            BlockIpAddress(ipname, 60 * 60 * 24 * 365 * 10); 
            
            Kick(playerid);

        }*/
    }
}

ptask PlayerCheckOnBear[3000](playerid)
{
    Update_Adventures(playerid);
    return 1;
}