#if defined _drop_pick_item_included
    #endinput

#endif

#define _drop_pick_item_included

#define MAX_GUNS_DROP 2000

enum gunDropInfo
{
    g_szGunID, // <-- id súng
    g_szGunAmmo,
    g_szGunObj, // <-- dynamic object
    g_szDynGunObj, // <-- lưu trữ id obj
    Float:gszObjPosX,
    Float:gszObjPosY,
    Float:gszObjPosZ
};
new GunDropData[MAX_GUNS_DROP][gunDropInfo];

stock GetGunObjToy(weaponid)
{
    switch(weaponid)
    {
        case 5: return 336;
        case 8: return 339;
        case 22: return 346;
        case 23: return 347;
        case 24: return 348;
        case 25: return 349;
        case 26: return 350;
        case 27: return 351;
        case 28: return 352;
        case 29: return 353;
        case 30: return 355;
        case 31: return 356;
        case 32: return 372;
        case 33: return 357;
        case 34: return 358;
    }
    return 0;
}

CMD:nhatsung(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        for(new i = 0 ; i < MAX_GUNS_DROP ; i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, GunDropData[i][gszObjPosX], GunDropData[i][gszObjPosY], GunDropData[i][gszObjPosZ]))
            {
                new success = -1;
                new gunid = 0;

                switch(GunDropData[i][g_szGunID])
                {
                    case 5: gunid = 50;
                    case 8: gunid = 49;
                    case 22: gunid = 24;
                    case 23: gunid = 23;
                    case 24: gunid = 25;
                    case 25: gunid = 26;
                    case 26: gunid = 27;
                    case 27: gunid = 28;
                    case 28: gunid = 29;
                    case 29: gunid = 30;
                    case 30: gunid = 31;
                    case 31: gunid = 32;
                    case 32: gunid = 33;
                    case 33: gunid = 34;
                    case 34: gunid = 35;
        
                }

                if(gunid == 0) return 1;

                SetPlayerItem(playerid, gunid, GunDropData[i][g_szGunAmmo], success);
                if(success == 1)
                {
                    new str[256];
                    SendClientMessageEx(playerid, COLOR_YELLOW, "[?] Ban da nhat mot vu khi va duoc dua vao tui do.");
                    format(str, sizeof(str), "%s da nhat mot khau sung tu duoi dat va dua vao balo.", GetPlayerNameEx(playerid));
                    ProxChatBubble(playerid, str);

                    GunDropData[i][g_szGunID] = 0;
                    GunDropData[i][g_szGunAmmo] = 0;
                    GunDropData[i][g_szGunObj] = 0;
                    GunDropData[i][gszObjPosX] = 0.0;
                    GunDropData[i][gszObjPosY] = 0.0;
                    GunDropData[i][gszObjPosZ] = 0.0;

                    if(IsValidDynamicObject(GunDropData[i][g_szDynGunObj])) DestroyDynamicObject(GunDropData[i][g_szDynGunObj]);
                }
                return 1;
            }
        }
    }
    return 1;
}

CMD:vutsung(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        new
            weaponname[20];
        new weaponid = 0;
        if(sscanf(params, "s[20]", weaponname))
        {
            SendClientMessageEx(playerid, COLOR_GRAD3, "TEN VU KHI: Sword Katana, Baseball.");
            SendClientMessageEx(playerid, COLOR_GRAD3, "TEN VU KHI: 9mm, SD Pistol, Deagle, Shotgun, Sawn-off, Spas-12, Uzi, MP5.");
            SendClientMessageEx(playerid, COLOR_GRAD3, "TEN VU KHI: AK, M4, Tec-9, Rifle, Sniper Rifle.");
            return SendClientMessageEx(playerid, COLOR_GRAD3, "SU DUNG: /vutsung [ten vu khi]");
        }
        else if(strcmp(weaponname, "Sword Katana", true) == 0)
        {
            weaponid = 8;
        }
        else if(strcmp(weaponname, "Baseball", true) == 0)
        {
            weaponid = 5;
        }
        else if(strcmp(weaponname, "9mm", true) == 0)
        {
            weaponid = 22;
        }
        else if(strcmp(weaponname, "SD Pistol", true) == 0)
        {
            weaponid = 23;
        }
        else if(strcmp(weaponname, "Deagle", true) == 0)
        {
            weaponid = 24;
        }
        else if(strcmp(weaponname, "Shotgun", true) == 0)
        {
            weaponid = 25;
        }
        else if(strcmp(weaponname, "Sawn-off", true) == 0)
        {
            weaponid = 26;
        }
        else if(strcmp(weaponname, "Spas-12", true) == 0)
        {
            weaponid = 27;
        }
        else if(strcmp(weaponname, "Uzi", true) == 0)
        {
            weaponid = 28;
        }
        else if(strcmp(weaponname, "MP5", true) == 0)
        {
            weaponid = 29;
        }
        else if(strcmp(weaponname, "AK", true) == 0)
        {
            weaponid = 30;
        }
        else if(strcmp(weaponname, "M4", true) == 0)
        {
            weaponid = 31;
        }
        else if(strcmp(weaponname, "Tec-9", true) == 0)
        {
            weaponid = 32;
        }
        else if(strcmp(weaponname, "Rifle", true) == 0)
        {
            weaponid = 33;
        }
        else if(strcmp(weaponname, "Sniper Rifle", true) == 0)
        {
            weaponid = 34;
        }

        new i, z, j;

        if(GetPlayerWeapon(playerid) == weaponid)
        {
            for(i = 0 ; i < 7 ; i++)
            {
                if(GetIDWeapon(CharacterInfo[playerid][1][cb_ItemID][i]) == weaponid)
                {
                    new itemid = CharacterInfo[playerid][1][cb_ItemID][i];
                    if (itemid >= 44 && itemid <= 48)
                    {
                        return SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}Trade{FFFFFF}]: Ban khong the ban vu khi LAW.");
                    }
                    for(z = 0 ; z < 12 ; z++)
                    {
                        if(PlayerInfo[playerid][pGuns][z] == weaponid)
                        {
                            PlayerInfo[playerid][pGuns][z] = 0;
                            SetPlayerWeaponsEx(playerid);
                            SendClientMessageEx(playerid, COLOR_RED, "Ban da vut bo mot vu khi xuong dat.");

                            new ammo = CharacterInfo[playerid][1][cb_ItemAmount];

                            CharacterInfo[playerid][1][cb_ItemID][i] = INVALID_OBJECT_ID;
                            CharacterInfo[playerid][1][cb_ItemWeight][i] = 0.0;
                            CharacterInfo[playerid][1][cb_ItemDurability][i] = 0;
                            CharacterInfo[playerid][1][cb_ItemAmount][i] = 0;

                            new str[256];
                            format(str, sizeof(str), "%s da vut mot khau sung xuong dat.", GetPlayerNameEx(playerid));
                            ProxChatBubble(playerid, str);

                            for(j = 0 ; j < MAX_GUNS_DROP ; j++)
                            {
                                if(GunDropData[j][g_szGunID] == 0)
                                {
                                    new Float:Pos[3];
                                    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
                                    GunDropData[j][g_szGunID] = weaponid;
                                    GunDropData[j][g_szGunAmmo] = ammo;
                                    GunDropData[j][g_szGunObj] = GetGunObjToy(weaponid);
                                    GunDropData[j][gszObjPosX] = Pos[0];
                                    GunDropData[j][gszObjPosY] = Pos[1];
                                    GunDropData[j][gszObjPosZ] = Pos[2];
                                    
                                    GunDropData[j][g_szDynGunObj] = CreateDynamicObject(GunDropData[j][g_szGunObj], Pos[0], Pos[1], Pos[2] - 0.9, 86.0000, 0.0000, 0.0000);
                                    break;
                                }
                            }

                            break;
                        }
                    }
                }
            }
        }
    }
    return 1;
}