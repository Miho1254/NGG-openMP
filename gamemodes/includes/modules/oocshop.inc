#if defined _modules_oocshop_included
    #endinput
#endif

#define _modules_oocshop_included

#include <YSI\y_hooks>

new gPlayerAtShopList[MAX_PLAYERS];
new gPlayerAtShopOOC[MAX_PLAYERS];

new Float:BoatShopPoint[][3] =
{
    {2976.0159,-1463.1479,2.8184}
};

new Float:PlaneShopPoint[][3] =
{
    {2964.5337,-1326.3348,5.5575}
};

new Float:CarShopPoint[][3] =
{
    {2934.0732,-1341.0725,10.7981}
};

Dialog:DIALOG_OOCSHOP_NEW(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(gPlayerAtShopList[playerid])
        {
            case 1:
            {
                if(PlayerData[playerid][pc_Coin] < 300)
                {
                    gPlayerAtShopOOC[playerid] = 0;
                    gPlayerAtShopList[playerid] = 0;
                    SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du coin de mua vat pham nay!");
                }
                else
                {
                    PlayerData[playerid][pc_Coin] -= 300;
                    new createcar;
                    createcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), gPlayerAtShopOOC[playerid], 2984.4536,-1461.3499,-0.4015,169.3457, -1, -1, 0, 0, -1);
                    PutPlayerInVehicle(playerid, createcar, 0);
                    
                    new day, month, year, hours, minutes, seconds;
                    getdate(day, month, year);
                    gettime(hours, minutes, seconds);

                    format(szMiscArray, sizeof(szMiscArray), "[%04d:%02d:%02d-%02d:%02d:%02d] %s da mua chiec %s tu shop OOC voi gia 300 coin.", year, month, day, hours, minutes, seconds, GetPlayerNameEx(playerid), VehicleName[gPlayerAtShopOOC[playerid]-400]);
                    SendAdminMessage(2, szMiscArray);

                    format(szMiscArray, sizeof(szMiscArray), "Ban da mua mot chiec %s tu cua hang OOC voi gia 300 coin.", VehicleName[gPlayerAtShopOOC[playerid]]);
                    SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
                }
            }
            case 2:
            {
                if(PlayerData[playerid][pc_Coin] < 350)
                {
                    gPlayerAtShopOOC[playerid] = 0;
                    gPlayerAtShopList[playerid] = 0;
                    SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du coin de mua vat pham nay!");
                }
                else
                {
                    PlayerData[playerid][pc_Coin] -= 350;
                    new createcar;
                    createcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), gPlayerAtShopOOC[playerid], 2927.8816,-1434.5470,10.8750,4.8587, -1, -1, 0, 0, -1);
                    PutPlayerInVehicle(playerid, createcar, 0);
                    
                    new day, month, year, hours, minutes, seconds;
                    getdate(day, month, year);
                    gettime(hours, minutes, seconds);

                    format(szMiscArray, sizeof(szMiscArray), "[%04d:%02d:%02d-%02d:%02d:%02d] %s da mua chiec %s tu shop OOC voi gia 350 coin.", year, month, day, hours, minutes, seconds, GetPlayerNameEx(playerid), VehicleName[gPlayerAtShopOOC[playerid]-400]);
                    SendAdminMessage(2, szMiscArray);

                    format(szMiscArray, sizeof(szMiscArray), "Ban da mua mot chiec %s tu cua hang OOC voi gia 350 coin.", VehicleName[gPlayerAtShopOOC[playerid]]);
                    SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
                }
            }
            case 3:
            {
                if(PlayerData[playerid][pc_Coin] < 200)
                {
                    gPlayerAtShopOOC[playerid] = 0;
                    gPlayerAtShopList[playerid] = 0;
                    SendClientMessageEx(playerid, COLOR_GRAD3, "Ban khong du coin de mua vat pham nay!");
                }
                else
                {
                    PlayerData[playerid][pc_Coin] -= 200;
                    new createcar;
                    createcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), gPlayerAtShopOOC[playerid], 2927.8816,-1434.5470,10.8750,4.8587, -1, -1, 0, 0, -1);
                    PutPlayerInVehicle(playerid, createcar, 0);
                    
                    new day, month, year, hours, minutes, seconds;
                    getdate(day, month, year);
                    gettime(hours, minutes, seconds);

                    format(szMiscArray, sizeof(szMiscArray), "[%04d:%02d:%02d-%02d:%02d:%02d] %s da mua chiec %s tu shop OOC voi gia 200 coin.", year, month, day, hours, minutes, seconds, GetPlayerNameEx(playerid), VehicleName[gPlayerAtShopOOC[playerid]-400]);
                    SendAdminMessage(2, szMiscArray);

                    format(szMiscArray, sizeof(szMiscArray), "Ban da mua mot chiec %s tu cua hang OOC voi gia 200 coin.", VehicleName[gPlayerAtShopOOC[playerid]]);
                    SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
                }
            }
        }
    }
    else
    {
        gPlayerAtShopOOC[playerid] = 0;
        gPlayerAtShopList[playerid] = 0;
    }
    return 1;
}

hook OnGameModeInit()
{

    CreateDynamic3DTextLabel("Diem mua thuyen\nSu dung /muathuyen de truy cap shop", 0xFFFFFFFF, BoatShopPoint[0][0], BoatShopPoint[0][1], BoatShopPoint[0][2], 40.0);
    CreateDynamicPickup(1272, 1, BoatShopPoint[0][0], BoatShopPoint[0][1], BoatShopPoint[0][2], 0, -1, -1, 100.0);

    CreateDynamic3DTextLabel("Diem mua may bay\nSu dung /muamaybay de truy cap shop", 0xFFFFFFFF, PlaneShopPoint[0][0], PlaneShopPoint[0][1], PlaneShopPoint[0][2], 40.0);
    CreateDynamicPickup(1272, 1, PlaneShopPoint[0][0], PlaneShopPoint[0][1], PlaneShopPoint[0][2], 0, -1, -1, 100.0);

    CreateDynamic3DTextLabel("Diem mua xe\nSu dung /muaxe de truy cap shop", 0xFFFFFFFF, CarShopPoint[0][0], CarShopPoint[0][1], CarShopPoint[0][2], 40.0);
    CreateDynamicPickup(1272, 1, CarShopPoint[0][0], CarShopPoint[0][1], CarShopPoint[0][2], 0, -1, -1, 100.0);

    return 1;
}

hook OnPlayerModelSelection(playerid, response, listid, modelid)
{
    new str[560];
    if(listid == BoatList)
    {
        if(response)
        {
            gPlayerAtShopOOC[playerid] = modelid;
            gPlayerAtShopList[playerid] = 1;
            format(str, sizeof(str), "{FFFFFF}Ban co chac muon mua chiec %s voi gia 300 coin khong?\n\
            Ban hien dang co: {00D8DB}%d coin{FFFFFF}\n\
            Gia can de mua: {00D8DB}300 coin{FFFFFF}\n\
            Gia thanh toan con lai: {00D8DB}%d coin{FFFFFF}",
            VehicleName[modelid - 400], PlayerData[playerid][pc_Coin], PlayerData[playerid][pc_Coin] - 300);
            Dialog_Show(playerid, DIALOG_OOCSHOP_NEW, DIALOG_STYLE_MSGBOX, "Thong tin thanh toan", str, "Mua", "Huy");
        }
    }
    if(listid == PlaneList)
    {
        if(response)
        {
            gPlayerAtShopOOC[playerid] = modelid;
            gPlayerAtShopList[playerid] = 2;
            format(str, sizeof(str), "{FFFFFF}Ban co chac muon mua chiec %s voi gia 350 coin khong?\n\
            Ban hien dang co: {00D8DB}%d coin{FFFFFF}\n\
            Gia can de mua: {00D8DB}350 coin{FFFFFF}\n\
            Gia thanh toan con lai: {00D8DB}%d coin{FFFFFF}",
            VehicleName[modelid - 400], PlayerData[playerid][pc_Coin], PlayerData[playerid][pc_Coin] - 350);
            Dialog_Show(playerid, DIALOG_OOCSHOP_NEW, DIALOG_STYLE_MSGBOX, "Thong tin thanh toan", str, "Mua", "Huy");
        }
    }
    if(listid == CarList)
    {
        if(response)
        {
            gPlayerAtShopOOC[playerid] = modelid;
            gPlayerAtShopList[playerid] = 3;
            format(str, sizeof(str), "{FFFFFF}Ban co chac muon mua chiec %s voi gia 200 coin khong?\n\
            Ban hien dang co: {00D8DB}%d coin{FFFFFF}\n\
            Gia can de mua: {00D8DB}200 coin{FFFFFF}\n\
            Gia thanh toan con lai: {00D8DB}%d coin{FFFFFF}",
            VehicleName[modelid - 400], PlayerData[playerid][pc_Coin], PlayerData[playerid][pc_Coin] - 200);
            Dialog_Show(playerid, DIALOG_OOCSHOP_NEW, DIALOG_STYLE_MSGBOX, "Thong tin thanh toan", str, "Mua", "Huy");
        }
    }

    return 1;
}

hook OnPlayerConnect(playerid)
{
    gPlayerAtShopOOC[playerid] = 0;
    gPlayerAtShopList[playerid] = 0;
    return 1;
}