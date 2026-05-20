#if defined _modules_craftweapon_included
    #endinput
#endif

#define _modules_craftweapon_included

#include <YSI\y_hooks>

#define MAX_CRAFTABLE_WEAPONS 14

new CraftWeaponInvModel[MAX_CRAFTABLE_WEAPONS] =
{
    41, 24, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35
};
new CraftWeaponList[MAX_CRAFTABLE_WEAPONS][] =
{
    "Hop dan (tich hop)", "9mm", "Silenced Pistol", "Deagle", "Shotgun", "Sawn-off Shotgun", "Combat-Shotgun", "Uzi", "MP5", "AK-47",
    "M4", "Tec-9", "Rifle", "Sniper Rifle"
};
new CraftWeaponPrice[MAX_CRAFTABLE_WEAPONS] = { 100000, 250000, 350000, 350000, 320000, 1200000, 1250000, 650000, 450000, 850000, 850000, 650000, 850000, 850000};
new CraftWeaponEXP[MAX_CRAFTABLE_WEAPONS] = { 0, 4000, 5500, 5500, 10000, 25000, 25000, 12000, 10000, 25000, 25000, 12000, 20000, 20000};

new CraftWeaponKS_Silver[MAX_CRAFTABLE_WEAPONS] = { 
    0, 25, 25, 25, 25, 25, 25, 25, 25, 
    15, 
    25, 
    25, 
    10, 
    25 
};
new CraftWeaponKS_Niken[MAX_CRAFTABLE_WEAPONS] = { 
    0, 25, 25, 25, 25, 25, 25, 25, 25, 
    15, 
    25, 
    25, 
    10, 
    25
};
new CraftWeaponKS_Gold[MAX_CRAFTABLE_WEAPONS] = { 
    0, 25, 25, 25, 25, 25, 25, 25, 25, 
    15, 
    25, 
    25, 
    10, 
    25
};
new CraftWeaponKS_Cu[MAX_CRAFTABLE_WEAPONS] = { 
    0, 25, 25, 25, 25, 25, 25, 25, 25, 
    15, 
    30, 
    25, 
    10, 
    30  
};
new CraftWeaponKS_Crom[MAX_CRAFTABLE_WEAPONS] = { 
    0, 25, 25, 25, 25, 25, 25, 25, 25, 
    15, 
    30, 
    25, 
    10, 
    30  
};

Dialog:DIALOG_CRAFT_WEAPON(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[356];
        new denought;
        
        if(listitem == 0)
        {
            if(GetPlayerCash(playerid) < CraftWeaponPrice[listitem])
            {
                denought = CraftWeaponPrice[listitem] - GetPlayerCash(playerid);
                format(str, sizeof(str), "[{62FF00}Che Tao{FFFFFF}] Ban khong du chi phi mua (thieu $%s).", number_format(denought));
                return SendClientMessageEx(playerid, COLOR_WHITE, str);
            }
            
            new success = -1;
            SetPlayerItem(playerid, CraftWeaponInvModel[listitem], GetAmmoWeaponLimit(CraftWeaponInvModel[listitem]), success);
            
            if(success == 1)
            {
                GivePlayerCash(playerid, -CraftWeaponPrice[listitem]);
                Update_Adventures(playerid);
                
                format(str, sizeof(str), "[{62FF00}Che Tao{FFFFFF}] Da mua thanh cong [* %s *].", CraftWeaponList[listitem]);
                SendClientMessageEx(playerid, COLOR_WHITE, str);
            }
            return 1;
        }
        
        if(GetPlayerCash(playerid) < CraftWeaponPrice[listitem])
        {
            denought = CraftWeaponPrice[listitem] - GetPlayerCash(playerid);
            format(str, sizeof(str), "[{62FF00}Che Tao{FFFFFF}] Ban khong du chi phi che tao (thieu $%s).", number_format(denought));
            return SendClientMessageEx(playerid, COLOR_WHITE, str);
        }
        if(PlayerData[playerid][pc_EA] < CraftWeaponEXP[listitem])
        {
            denought = CraftWeaponEXP[listitem] - PlayerData[playerid][pc_EA];
            format(str, sizeof(str), "[{62FF00}Che Tao{FFFFFF}] Ban khong du chi phi che tao (thieu %d EXP).", denought);
            return SendClientMessageEx(playerid, COLOR_WHITE, str);
        }

        new i, z, ifind[5];
        new ifindid[] = {3, 4, 5, 6, 7};
        new ifindlist[][] = {"Bac [Silver]", "Niken", "Vang [Gold]", "Dong [Cu]", "Crom"};
        new ifindamount[5];
        new findstack = 0;
        ifindamount[0] = CraftWeaponKS_Silver[listitem];
        ifindamount[1] = CraftWeaponKS_Niken[listitem];
        ifindamount[2] = CraftWeaponKS_Gold[listitem];
        ifindamount[3] = CraftWeaponKS_Cu[listitem];
        ifindamount[4] = CraftWeaponKS_Crom[listitem];
        
        for(i = 0 ; i < sizeof(ifindlist) ; i++)
        {
            ifind[i] = -1;
            for(z = 0 ; z < MAX_PLAYER_CB_ITEM ; z++)
            {
                if(CharacterInfo[playerid][0][cb_ItemID][z] == ifindid[i])
                {
                    if(CharacterInfo[playerid][0][cb_ItemAmount][z] >= ifindamount[i])
                    {
                        ifind[i] = z;
                        break;
                    }
                }
            }
        }
        
        str[0] = EOS; 

        for(i = 0 ; i < sizeof(ifindlist) ; i++)
        {
            if(ifind[i] == -1)
            {
                if(i == 0)
                {
                    format(str, sizeof(str), "Danh sach khoang san con thieu (can tim kiem hoac\n");
                    format(str, sizeof(str), "%skiem tra ghep cac vat pham lai thanh 1)\n", str);
                    format(str, sizeof(str), "%sTen khoang san\tSo luong\n", str);
                }
                format(str, sizeof(str), "%s%s\t%d\n", str, ifindlist[i], ifindamount[i]);
            }
            else findstack++;
        }
        
        if(!isnull(str)) return Dialog_Show(playerid, DIALOG_ERROR_CRAFTWEAPON, DIALOG_STYLE_MSGBOX, "Danh sach quang con thieu", str, "Dong Y", "Thoat");
        
        if(findstack == 5)
        {
            new success = -1;
            SetPlayerItem(playerid, CraftWeaponInvModel[listitem], GetAmmoWeaponLimit(CraftWeaponInvModel[listitem]), success);
            if(success == 1)
            {
                GivePlayerCash(playerid, -CraftWeaponPrice[listitem]);
                PlayerData[playerid][pc_EA] -= CraftWeaponEXP[listitem];

                Update_Adventures(playerid);

                for(i = 0 ; i < sizeof(ifindlist) ; i++)
                {
                    CharacterInfo[playerid][0][cb_ItemAmount][ifind[i]] -= ifindamount[i];
                    if(CharacterInfo[playerid][0][cb_ItemAmount][ifind[i]] <= 0)
                        RemovePlayerItem(playerid, ifind[i]);
                }
                
                format(str, sizeof(str), "[{62FF00}Che Tao{FFFFFF}] Da che tao thanh cong [* %s *].", CraftWeaponList[listitem]);
                SendClientMessageEx(playerid, COLOR_WHITE, str);
            }
        }
    }
    else
    {

    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_YES))
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, -2403.5537,533.8314,30.3828) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
            new str[4096];
            for(new i = 0 ; i < MAX_CRAFTABLE_WEAPONS ; i++)
            {
                new price = CraftWeaponPrice[i];
                new exp = CraftWeaponEXP[i];
                
                new silver = CraftWeaponKS_Silver[i];
                new niken = CraftWeaponKS_Niken[i];
                new gold = CraftWeaponKS_Gold[i];
                new cu = CraftWeaponKS_Cu[i];
                new crom = CraftWeaponKS_Crom[i];
                
                if (i == 0)
                {
                    format(str, sizeof(str), "%s(%d)%s (Mua thang: $%s)", str, i + 1, CraftWeaponList[i], number_format(price));
                }
                else
                {
                    format(str, sizeof(str), "%s(%d)%s ($%s, %d EXP, %d Silver, %d Niken, %d Gold, %d Cu, %d Crom)", str, i + 1, CraftWeaponList[i], number_format(price),
                    exp, silver, niken, gold, cu, crom);
                }
                format(str, sizeof(str), "%s\n", str);
            }
            Dialog_Show(playerid, DIALOG_CRAFT_WEAPON, DIALOG_STYLE_LIST, "Bang che tao", str, "Chon", "Thoat");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 5.0, -2125.5991,303.3193,34.5406))
        {
            SetPVarInt(playerid, "ShopQuestion", 1);
            new str[256];
            format(str, sizeof(str), "[0] Sword Katana\t$500,000\n\
            [1] Gay Bong Chay\t$450,000\n");
            Dialog_Show(playerid, DIALOG_BUYCC_WEAPON, DIALOG_STYLE_TABLIST, "Mua vu khi can chien", str, "Mua", "Huy");
        }
    }
    return 1;
}