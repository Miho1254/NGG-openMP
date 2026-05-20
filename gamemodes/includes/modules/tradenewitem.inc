#if defined _modules_tradenewitem_included
    #endinput
#endif

#define _modules_tradenewitem_included

#include <YSI\y_hooks>

new gPlayerTradeItem[MAX_PLAYERS][MAX_PLAYER_CB_ITEM];

CMD:giaodich(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        new i;
        new vstring[1024];
        new dialog_index = 0;
        if(PlayerInfo[playerid][pLevel] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban can dat level 2+ de co the su dung lenh nay.");
        format(vstring, sizeof(vstring), "Ten vat pham\tSo luong trong tui\n");
        for(i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
        {
            if(!GetIDWeapon(CharacterInfo[playerid][0][cb_ItemID][i]) && CharacterInfo[playerid][0][cb_ItemID][i] != 43 && CharacterInfo[playerid][0][cb_ItemID][i] != INVALID_OBJECT_ID)
            {
                format(vstring, sizeof(vstring), "%s\n(%d)%s\t%d\n", vstring, i, Inventory_ListItems[CharacterInfo[playerid][0][cb_ItemID][i] - 1], CharacterInfo[playerid][0][cb_ItemAmount][i]);
                gPlayerTradeItem[playerid][dialog_index] = i;
                dialog_index++;
            }
        }
        Dialog_Show(playerid, DIALOG_TRADENEWITEM, DIALOG_STYLE_TABLIST_HEADERS, "Giao dich vat pham", vstring, "Giao dich", "Huy");
    }
    else return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban can dang nhap de thuc hien dieu nay!");
    return 1;
}

Dialog:DIALOG_TRADENEWITEM(playerid, response, listitem, inputtext[])
{
    if(response)
    {

        if(CharacterInfo[playerid][0][cb_ItemID][gPlayerTradeItem[playerid][listitem]] == 3 || CharacterInfo[playerid][0][cb_ItemID][gPlayerTradeItem[playerid][listitem]] == 4 || CharacterInfo[playerid][0][cb_ItemID][gPlayerTradeItem[playerid][listitem]] == 5
        || CharacterInfo[playerid][0][cb_ItemID][gPlayerTradeItem[playerid][listitem]] == 6 || CharacterInfo[playerid][0][cb_ItemID][gPlayerTradeItem[playerid][listitem]] == 7)
        {
            if(PlayerData[playerid][pc_ItemTradeNeftExpire_Miner] != 0)
            {
                for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
                {
                    gPlayerTradeItem[playerid][i] = -1;
                }
                SetPVarInt(playerid, "passitemindex", -1);
                SendClientMessageEx(playerid, COLOR_GRAD3, "Ban da dat gioi han so luong giao dich khoang san ngay hom nay!");
                return 1;
            }
        }

        Dialog_Show(playerid, DIALOG_TRADENEWITEMAM, DIALOG_STYLE_INPUT, "Nhap so luong muon giao dich", "Hay nhap so luong ban muon ban:", "Tiep", "Huy");
        SetPVarInt(playerid, "passitemindex", gPlayerTradeItem[playerid][listitem]);
    }
    else
    {
        for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
        {
            gPlayerTradeItem[playerid][i] = -1;
        }
        SetPVarInt(playerid, "passitemindex", -1);
    }
    return 1;
}

Dialog:DIALOG_TRADENEWITEMAM(playerid, response, lisittem, inputtext[])
{
    if(response)
    {
        new index = GetPVarInt(playerid, "passitemindex");
        new amount = strval(inputtext);

        if(!IsNumeric(inputtext))
        {
            Dialog_Show(playerid, DIALOG_TRADENEWITEMAM, DIALOG_STYLE_INPUT, "Nhap so luong muon giao dich", "Vui long chi nhap so\nHay nhap so luong ban muon ban:", "Tiep", "Huy");
            return 1;
        }
        else if(isnull(inputtext) || amount <= 0 || amount > CharacterInfo[playerid][0][cb_ItemAmount][index])
        {
            new vstring[128];
            format(vstring, sizeof(vstring), "Vui long nhap so luong hop le (1 - %d):\nHay nhap so luong ban muon ban:", CharacterInfo[playerid][0][cb_ItemAmount][index]);
            Dialog_Show(playerid, DIALOG_TRADENEWITEMAM, DIALOG_STYLE_INPUT, "Nhap so luong muon giao dich", vstring, "Tiep", "Huy");
            return 1;
        }
        else if(CharacterInfo[playerid][0][cb_ItemID][index] == 3 || CharacterInfo[playerid][0][cb_ItemID][index] == 4 || CharacterInfo[playerid][0][cb_ItemID][index] == 5
        || CharacterInfo[playerid][0][cb_ItemID][index] == 6 || CharacterInfo[playerid][0][cb_ItemID][index] == 7)
        {
            if(strval(inputtext) + PlayerData[playerid][pc_ItemTradeNeft_Miner] > 85)
            {
                new vstring[128];
                format(vstring, sizeof(vstring), "Ban chi co the ban duoc them %d so luong khoang san trong hom nay\n\
                \nHay nhap so luong ban muon ban:", 85 - PlayerData[playerid][pc_ItemTradeNeft_Miner], CharacterInfo[playerid][0][cb_ItemAmount][index]);
                return Dialog_Show(playerid, DIALOG_TRADENEWITEMAM, DIALOG_STYLE_INPUT, "Nhap so luong muon giao dich", vstring, "Tiep", "Huy");
            }
        }

        SetPVarInt(playerid, "passitemamount", amount);
        
        Dialog_Show(playerid, DIALOG_TRADENEWITEMPRICE, DIALOG_STYLE_INPUT, "Nhap gia muon giao dich", "Hay nhap gia tien ban muon ban (SAD):", "Tiep", "Huy");
    }
    else
    {
        for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
        {
            gPlayerTradeItem[playerid][i] = -1;
        }
        SetPVarInt(playerid, "passitemindex", -1);
        SetPVarInt(playerid, "passitemamount", 0);
    }
    return 1;
}

Dialog:DIALOG_TRADENEWITEMPRICE(playerid, response, lisittem, inputtext[])
{
    if(response)
    {
        new price = strval(inputtext);
        
        if(!IsNumeric(inputtext) || price <= 10000)
        {
            Dialog_Show(playerid, DIALOG_TRADENEWITEMPRICE, DIALOG_STYLE_INPUT, "Nhap gia muon giao dich", "Vui long chi nhap so va phai lon hon 0\nHay nhap gia tien ban muon ban:", "Tiep", "Huy");
            return 1;
        }
        
        SetPVarInt(playerid, "passitemprice", price);

        new Float:Pos[3];
        new targetid = INVALID_PLAYER_ID;
        foreach(new i: Player)
        {
            GetPlayerPos(i, Pos[0], Pos[1], Pos[2]);
            if(IsPlayerInRangeOfPoint(playerid, 5.0, Pos[0], Pos[1], Pos[2]) && i != playerid)
            {
                targetid = i;
                break;
            }
        }

        if(targetid == playerid)
        {
            SendClientMessageEx(playerid, COLOR_RED, "Khong the tu ban cho chinh minh.");
            SetPVarInt(playerid, "passitemindex", -1);
            SetPVarInt(playerid, "passitemamount", 0);
            SetPVarInt(playerid, "passitemprice", 0);
            return 1;
        }
        
        if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        {
            SendClientMessageEx(playerid, COLOR_RED, "Khong tim thay nguoi mua hoac nguoi mua da mat ket noi.");
            SetPVarInt(playerid, "passitemindex", -1);
            SetPVarInt(playerid, "passitemamount", 0);
            SetPVarInt(playerid, "passitemprice", 0);
            return 1;
        }

        new index = GetPVarInt(playerid, "passitemindex");
        new amount = GetPVarInt(playerid, "passitemamount");
        new item_id = CharacterInfo[playerid][0][cb_ItemID][index];
        new item_name[64];
        
        format(item_name, sizeof(item_name), "%s", Inventory_ListItems[item_id - 1]);

        new vstring[512];
        format(vstring, sizeof(vstring), "Nguoi ban: %s (%d)\n", GetPlayerNameEx(playerid), playerid);
        format(vstring, sizeof(vstring), "%sVat pham: %s\n", vstring, item_name);
        format(vstring, sizeof(vstring), "%sSo luong: %d\n", vstring, amount);
        format(vstring, sizeof(vstring), "%sGia ban: $%s\n\n", vstring, number_format(price));
        format(vstring, sizeof(vstring), "%sBan co chac chan muon mua?", vstring);
        
        Dialog_Show(targetid, DIALOG_TRADECONFIRM, DIALOG_STYLE_MSGBOX, "Canh bao giao dich tui do", vstring, "Dong Y", "Huy");
        
        SetPVarInt(targetid, "pTraderSellerID", playerid); 
    }
    else
    {
       SetPVarInt(playerid, "passitemindex", -1);
       SetPVarInt(playerid, "passitemamount", 0);
       SetPVarInt(playerid, "passitemprice", 0);
    }
    return 1;
}

Dialog:DIALOG_TRADECONFIRM(playerid, response, lisittem, inputtext[])
{
    new sellerid = GetPVarInt(playerid, "pTraderSellerID"); 
    
    if(sellerid == INVALID_PLAYER_ID || !IsPlayerConnected(sellerid))
    {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi ban da mat ket noi.");
        return 1;
    }
    
    new index = GetPVarInt(sellerid, "passitemindex");
    new amount = GetPVarInt(sellerid, "passitemamount");
    new price = GetPVarInt(sellerid, "passitemprice");
    new item_id = CharacterInfo[sellerid][0][cb_ItemID][index];

    SetPVarInt(sellerid, "passitemindex", -1);
    SetPVarInt(sellerid, "passitemamount", 0);
    SetPVarInt(sellerid, "passitemprice", 0);
    SetPVarInt(playerid, "pTraderSellerID", -1); 
    
    if(response)
    {
        if(GetPlayerCash(playerid) < price)
        {
            SendClientMessageEx(playerid, COLOR_GRAD2, "[?] Ban khong du tien de mua vat pham nay.");
            SendClientMessageEx(sellerid, COLOR_GRAD2, "[?] Giao dich that bai: Nguoi mua khong du tien.");
            return 1;
        }
        
        if(GivePlayerItem(playerid, item_id, amount) == 0) 
        {
            SendClientMessageEx(playerid, COLOR_GRAD2, "Khong the mua vi tui do cua ban khong du slot hoac qua tai can nang.");
            SendClientMessageEx(sellerid, COLOR_GRAD2, "Giao dich that bai: Nguoi mua khong du slot hoac qua tai can nang.");
            return 1;
        }

        GivePlayerCash(playerid, -price);
        GivePlayerCash(sellerid, price);
        
        
        CharacterInfo[sellerid][0][cb_ItemAmount][index] -= amount;
        if(CharacterInfo[sellerid][0][cb_ItemAmount][index] <= 0)
            RemovePlayerItem(sellerid, index);
        
        new item_name[64];
        format(item_name, sizeof(item_name), "%s", Inventory_ListItems[item_id - 1]);
        
        new str_seller[128];
        format(str_seller, sizeof(str_seller), "Ban da ban %d %s voi gia $%s cho %s.", amount, item_name, number_format(price), GetPlayerNameEx(playerid));
        SendClientMessageEx(sellerid, COLOR_YELLOW, str_seller);
        
        new str_buyer[128];
        format(str_buyer, sizeof(str_buyer), "Ban da mua %d %s voi gia $%s tu %s.", amount, item_name, number_format(price), GetPlayerNameEx(sellerid));
        SendClientMessageEx(playerid, COLOR_YELLOW, str_buyer);

        if(item_id == 3 || item_id == 4 || item_id == 5 || item_id == 6 || item_id == 7)
        {
            PlayerData[sellerid][pc_ItemTradeNeft_Miner] += amount;

            if(PlayerData[sellerid][pc_ItemTradeNeft_Miner] >= 85)
            {
                PlayerData[sellerid][pc_ItemTradeNeftExpire_Miner] = gettime()+86400;
                SendClientMessageEx(sellerid, COLOR_YELLOW, "[?] Ban da dat gioi han giao dich ngay hom nay, hay tro lai vao hom sau!");
            }
        }


        new year, month, day, hours, minutes, seconds;
        getdate(year, month, day);
        gettime(hours, minutes, seconds);

        format(szMiscArray, sizeof(szMiscArray), "[%04d:%02d:%02d-%02d:%02d:%02d] %s da ban lai vat pham %s (so luong: %d) cho %s voi gia $%s.", year, month, day, hours, minutes, seconds,
        GetPlayerNameEx(sellerid), item_name, amount, GetPlayerNameEx(playerid), number_format(price));
        SendAdminMessage(2, szMiscArray);
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GRAD2, "[?] Ban da huy giao dich.");
        SendClientMessageEx(sellerid, COLOR_GRAD2, "[?] Giao dich bi huy boi nguoi mua.");
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    for(new i = 0 ; i < MAX_PLAYER_CB_ITEM ; i++)
    {
        gPlayerTradeItem[playerid][i] = -1;
    }
    SetPVarInt(playerid, "passitemindex", -1);
    return 1;
}