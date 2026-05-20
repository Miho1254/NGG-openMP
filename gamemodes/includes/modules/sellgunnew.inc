#if defined _modules_sellgun_included
    #endinput
#endif

#define _modules_sellgun_included

#include <YSI\y_hooks>

#define TRADE_WEAPON 1
#define TRADE_TIMEOUT_MS (5 * 60 * 1000)

Function: CancelWeaponTrade(buyerid, sellerid)
{
    new timerid = GetPVarInt(buyerid, "pTradeOfferTimer");
    if (timerid != 0) {
        KillTimer(timerid);
    }

    DeletePVar(buyerid, "pTradeOfferFrom");
    DeletePVar(buyerid, "pTradeOfferPrice");
    DeletePVar(buyerid, "pTradeOfferType");
    DeletePVar(buyerid, "pTradeOfferItemIndex");
    DeletePVar(buyerid, "pTradeOfferTimer");
    DeletePVar(buyerid, "pCanAcceptTradeTime");

    if (IsPlayerConnected(buyerid))
    {
        SendClientMessageEx(buyerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Giao dich vu khi da bi huy.");
    }

    if (IsPlayerConnected(sellerid))
    {
        SendClientMessageEx(sellerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Giao dich vu khi cua ban da bi huy.");
    }

    return 1;
}

CMD:banvukhi(playerid, params[])
{
    if(!gPlayerLogged{playerid}) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban can dang nhap de lam dieu nay!");

    if(PlayerInfo[playerid][pMember] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban can la thanh vien cua gang moi duoc su dung lenh nay.");

    if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban can la gang moi duoc su dung lenh nay!");
    
    if(PlayerInfo[playerid][pLevel] < 2) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban can dat level 2+ de co the su dung lenh nay!");
    
    new i;
    new weaponid = GetPlayerWeapon(playerid);
    new weaponindex = -1;
    
    // Tim vu khi dang cam tren tay trong tui do [1]
    for(i = 0 ; i < 7 ; i++)
    {
        new item_id = CharacterInfo[playerid][1][cb_ItemID][i];
        if(item_id != INVALID_OBJECT_ID)
        {
            if(GetIDWeapon(item_id))
            {
                if(GetIDWeapon(item_id) == weaponid)
                {
                    weaponindex = i;
                    break;
                }
            }
        }
    }

    if(weaponindex == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}TUI DO{FFFFFF}]: Ban can cam tren tay vu khi ma ban muon ban.");

    // KIEM TRA VU KHI LAW/RPG (ID 44 den 48)
    new item_id_to_check = CharacterInfo[playerid][1][cb_ItemID][weaponindex];
    if (item_id_to_check >= 44 && item_id_to_check <= 48)
    {
        return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Ban khong the ban vu khi LAW.");
    }
    
    new id, price;
    if(sscanf(params, "ui", id, price))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /banvukhi [id] [gia tien]");
    }

    if(id == playerid) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong the ban vu khi cho chinh minh.");
    
    if(!IsPlayerConnected(id) || !gPlayerLogged{id}) return SendClientMessageEx(id, COLOR_GRAD3, "Nguoi choi nay chua dang nhap vao may chu.");
    
    if(price < 10000 || price > 2000000000) return SendClientMessageEx(playerid, COLOR_GRAD3, "Gia tien phai tu 10,000 cho den duoi 2 ty.");
    
    if (GetPVarInt(id, "pTradeOfferType") != 0) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Nguoi choi nay dang co mot giao dich khac dang cho.");
    }
    
    new Float:Pos[3];
    GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
    
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, Pos[0], Pos[1], Pos[2]))
    {
        return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban can dung gan nguoi choi nay trong vong ban kinh 5m moi co the giao dich duoc.");
    }

    SetPVarInt(id, "pTradeOfferFrom", playerid);
    SetPVarInt(id, "pTradeOfferPrice", price);
    SetPVarInt(id, "pTradeOfferType", TRADE_WEAPON);
    SetPVarInt(id, "pTradeOfferItemIndex", weaponindex);

    new trade_timer = SetTimerEx("CancelWeaponTrade", TRADE_TIMEOUT_MS, false, "ii", id, playerid);
    SetPVarInt(id, "pTradeOfferTimer", trade_timer);
    
    SetPVarInt(id, "pCanAcceptTradeTime", gettime() + 10); 

    new str[512];
    new item_id = CharacterInfo[playerid][1][cb_ItemID][weaponindex];
    format(str, sizeof(str), "Ban dang duoc de nghi mua vu khi '%s' tu %s voi gia $%s.\n\
        Ban co 5 phut de phan hoi.\n\n\
        [Luu y quan trong]: De tranh bi loi dung, ban phai cho 10 giay moi duoc bam nut 'Dong Y'! Thoi gian cho con lai: %d giay", 
        Inventory_ListItems[item_id - 1], GetPlayerNameEx(playerid), number_format(price), 10
    );
    Dialog_Show(id, Dialog_TradeGun_Step1, DIALOG_STYLE_MSGBOX, "XAC NHAN MUA VU KHI", str, "Dong Y", "Tu Choi");

    format(str, sizeof(str), "[{62FF00}Trade{FFFFFF}] Ban da de nghi %s mua vu khi %s cua ban voi gia $%s. Vui long doi %s phan hoi (Giao dich se tu huy sau 5 phut).", GetPlayerNameEx(id), Inventory_ListItems[item_id - 1], number_format(price), GetPlayerNameEx(id));
    SendClientMessageEx(playerid, COLOR_WHITE, str);
    
    return 1;
}

Dialog:Dialog_TradeGun_Step1(playerid, response, listitem, inputtext[])
{
    new sellerid = GetPVarInt(playerid, "pTradeOfferFrom");

    if (!response) {
        return CancelWeaponTrade(playerid, sellerid);
    }
    
    if (gettime() < GetPVarInt(playerid, "pCanAcceptTradeTime")) 
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Ban phai cho 10 giay moi duoc bam chap nhan! Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }

    if (!IsPlayerConnected(sellerid) || !gPlayerLogged{sellerid})
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Nguoi ban da thoat khoi may chu. Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }

    new Float:PosSeller[3];
    GetPlayerPos(sellerid, PosSeller[0], PosSeller[1], PosSeller[2]);
    
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, PosSeller[0], PosSeller[1], PosSeller[2]))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Ban hoac nguoi ban da di qua xa (hon 5m). Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }
    
    new price = GetPVarInt(playerid, "pTradeOfferPrice");
    new weaponindex = GetPVarInt(playerid, "pTradeOfferItemIndex");
    
    // Kiem tra itemid truoc khi su dung weaponindex de tranh crash do PVar bi loi
    if (weaponindex < 0 || weaponindex >= 7) {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Loi he thong (index vu khi khong hop le). Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }

    new itemid = CharacterInfo[sellerid][1][cb_ItemID][weaponindex];
    
    if (itemid == INVALID_OBJECT_ID || !GetIDWeapon(itemid)) {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Vu khi da bi nguoi ban su dung hoac chuyen di. Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }

    new str[256];
    format(str, sizeof(str), 
        "Ban co chac chan muon mua vu khi '%s' voi gia $%s khong? Thao tac nay khong the hoan lai.",
        Inventory_ListItems[itemid - 1], number_format(price)
    );
    Dialog_Show(playerid, Dialog_TradeGun_Step2, DIALOG_STYLE_MSGBOX, "XAC NHAN LAN CUOI", str, "XAC NHAN MUA", "Huy Bo");

    return 1;
}

Dialog:Dialog_TradeGun_Step2(playerid, response, listitem, inputtext[])
{
    new sellerid = GetPVarInt(playerid, "pTradeOfferFrom");
    
    if (!response) {
        return CancelWeaponTrade(playerid, sellerid);
    }

    new price = GetPVarInt(playerid, "pTradeOfferPrice");
    new weaponindex = GetPVarInt(playerid, "pTradeOfferItemIndex");
    
    if (!IsPlayerConnected(sellerid) || !gPlayerLogged{sellerid})
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Nguoi ban da thoat khoi may chu. Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }

    new Float:PosSeller[3];
    GetPlayerPos(sellerid, PosSeller[0], PosSeller[1], PosSeller[2]);
    
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, PosSeller[0], PosSeller[1], PosSeller[2]))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Ban hoac nguoi ban da di qua xa (hon 5m). Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }
    
    if (GetPlayerCash(playerid) < price) {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Ban khong co du tien mat ($%s) de mua vu khi nay.", number_format(price));
        return CancelWeaponTrade(playerid, sellerid);
    }
    
    // KIEM TRA WEAPON INDEX TRUOC KHI TRUY CAP MANG
    if (weaponindex < 0 || weaponindex >= 7) {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Loi he thong (index vu khi khong hop le). Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }

    new itemid_to_transfer = CharacterInfo[sellerid][1][cb_ItemID][weaponindex];
    new seller_item_amount = CharacterInfo[sellerid][1][cb_ItemAmount][weaponindex];

    if (itemid_to_transfer == INVALID_OBJECT_ID || !GetIDWeapon(itemid_to_transfer)) {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Vu khi da bi nguoi ban su dung hoac chuyen di. Giao dich bi huy.");
        return CancelWeaponTrade(playerid, sellerid);
    }
    
    // START: KIEM TRA CAN NANG VA SLOT TRONG CUA NGUOI MUA (playerid)
    new j, k;
    new Float:new_weight;
    new Float:Weight = 0.0;
    
    // 1. Tinh tong trong luong tui do chinh (Index 0) - Trang bi
    for (j = 0; j < MAX_PLAYER_CB_ITEM; j++) 
    {
        if (CharacterInfo[playerid][0][cb_ItemID][j] > 0) 
        {
            Weight += CharacterInfo[playerid][0][cb_ItemWeight][j];
        }
    }
    
    // 2. Tinh tong trong luong tui do phu/dac biet (Chi la Index 1) - Tui do
    // CHỈ TÍNH TÚI [1] VÀ 7 SLOTS (INDEX 0 den 6)
    for (k = 0; k <= 6; k++) 
    {
        if (CharacterInfo[playerid][1][cb_ItemID][k] > 0)
        {
            Weight += CharacterInfo[playerid][1][cb_ItemWeight][k];
        }
    }
    
    // 3. Kiem tra Can nang
    new_weight = GetItemWeight(itemid_to_transfer);
    if (Weight + new_weight > CharacterInfo[playerid][0][cb_Weight])
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Khong the mua vu khi vi da qua gioi han can nang tui do.");
        return CancelWeaponTrade(playerid, sellerid);
    }

    // 4. Kiem tra Slot trong trong tui do chinh [0] - Noi vu khi se duoc them vao
    new buyer_slot = -1;
    for (new i = 0; i < MAX_PLAYER_CB_ITEM; i++) 
    {
        if (CharacterInfo[playerid][0][cb_ItemID][i] == INVALID_OBJECT_ID) 
        {
            buyer_slot = i;
            break;
        }
    }
    
    if (buyer_slot == -1) {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Ban khong con cho trong trong tui do de nhan vu khi nay.");
        return CancelWeaponTrade(playerid, sellerid);
    }
    
    // END: KIEM TRA CAN NANG VA SLOT TRONG CUA NGUOI MUA
    
    // THUC HIEN GIAO DICH
    
    // A. Xoa vu khi khoi nguoi ban (slot: weaponindex, bag: [1])
    if (GetPlayerWeapon(sellerid) == GetIDWeapon(itemid_to_transfer))
    {
        ResetPlayerWeapons(sellerid);
    }
    CharacterInfo[sellerid][1][cb_ItemID][weaponindex] = INVALID_OBJECT_ID; 
    CharacterInfo[sellerid][1][cb_ItemAmount][weaponindex] = 0;
    CharacterInfo[sellerid][1][cb_ItemWeight][weaponindex] = 0.0;
    
    // B. Them vu khi vao nguoi mua (slot: buyer_slot, bag: [0])
    CharacterInfo[playerid][0][cb_ItemID][buyer_slot] = itemid_to_transfer;
    CharacterInfo[playerid][0][cb_ItemAmount][buyer_slot] = seller_item_amount;
    CharacterInfo[playerid][0][cb_ItemWeight][buyer_slot] = new_weight;
    CharacterInfo[playerid][0][cb_ItemDurability][buyer_slot] = 100;

    // C. Chuyen tien
    GivePlayerCash(playerid, -price);
    GivePlayerCash(sellerid, price);
    
    // D. Don dep PVar va Timer
    CancelWeaponTrade(playerid, sellerid);

    // E. Thong bao thanh cong
    new str[512]; 
    format(str, sizeof(str), "[{62FF00}Trade{FFFFFF}] Ban da ban vu khi %s cho %s voi gia $%s.", Inventory_ListItems[itemid_to_transfer - 1], GetPlayerNameEx(playerid), number_format(price));
    SendClientMessageEx(sellerid, COLOR_WHITE, str);
    
    format(str, sizeof(str), "[{62FF00}Trade{FFFFFF}] Ban da mua vu khi %s tu %s voi gia $%s.", Inventory_ListItems[itemid_to_transfer - 1], GetPlayerNameEx(sellerid), number_format(price));
    SendClientMessageEx(playerid, COLOR_WHITE, str);

    new year, month, day, hours, minutes, seconds;
    getdate(year, month, day);
    gettime(hours, minutes, seconds);

    format(str, sizeof(str), "[%04d-%02d-%02d-%02d:%02d:%02d] %s da ban lai vu khi %s cho %s voi gia $%s.", year, month, day, hours, minutes, seconds, GetPlayerNameEx(sellerid), Inventory_ListItems[itemid_to_transfer - 1], GetPlayerNameEx(playerid), number_format(price));
    SendAdminMessage(2, str);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (GetPVarInt(playerid, "pTradeOfferType") == TRADE_WEAPON)
    {
        new sellerid = GetPVarInt(playerid, "pTradeOfferFrom");
        new timerid = GetPVarInt(playerid, "pTradeOfferTimer");
        
        KillTimer(timerid);
        
        if (IsPlayerConnected(sellerid))
        {
            new str[256]; 
            format(str, sizeof(str), "[{FFB561}Trade{FFFFFF}]: Giao dich voi %s da bi huy do ho thoat khoi may chu.", GetPlayerNameEx(playerid));
            SendClientMessageEx(sellerid, COLOR_WHITE, str);
        }
        
        DeletePVar(playerid, "pTradeOfferFrom");
        DeletePVar(playerid, "pTradeOfferPrice");
        DeletePVar(playerid, "pTradeOfferType");
        DeletePVar(playerid, "pTradeOfferItemIndex");
        DeletePVar(playerid, "pTradeOfferTimer");
        DeletePVar(playerid, "pCanAcceptTradeTime");
    }
    return 1;
}