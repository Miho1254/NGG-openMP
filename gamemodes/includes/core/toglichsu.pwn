
#include <YSI\y_hooks>

forward Inventory_IsLAWWeapon(playerid, weaponid);






hook OnPlayerConnect(playerid)
{
    InfoDame[playerid] = true;
	return 1;
}


CMD:toglichsu(playerid, params[])
{
    if(InfoDame[playerid] == false)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Ban da bat lich su chien dau.");
        InfoDame[playerid] = true;
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, "Ban da tat lich su chien dau.");
        InfoDame[playerid] = false;
    }
    return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
    if(InfoDame[playerid] == true && issuerid != INVALID_PLAYER_ID)
    {
        new infoString[128], weaponName[32];
        
        if(weaponid == 0 || weaponid == 54) format(weaponName, sizeof(weaponName), "Tay Khong/Va Dap");
        else
        {
            GetWeaponName(weaponid, weaponName, sizeof(weaponName));
            if(Inventory_IsLAWWeapon(issuerid, weaponid))
            {
                format(weaponName, sizeof(weaponName), "%s [LAW]", weaponName);
                switch(weaponid)
                {
                    case 22: amount = 10.5;
                    case 24: amount = 52.0;
                    case 29: amount = 10.5;
                    case 30: amount = 10.9;
                    case 31: amount = 10.9;
                }
            }
        }

        format(infoString, sizeof(infoString), "{FF4C4C}<< -%.1f HP {FFFFFF}| Tu: {00FFCC}%s {FFFFFF}| Vu khi: {FFCC00}%s", amount, GetPlayerNameEx(issuerid), weaponName);
        SendClientMessage(playerid, -1, infoString);
    }
    return 1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
    if(InfoDame[playerid] == true && damagedid != INVALID_PLAYER_ID)
    {
        new string[128], weaponName[32];
        
        if(weaponid == 0 || weaponid == 54) format(weaponName, sizeof(weaponName), "Tay Khong");
        else
        {
            GetWeaponName(weaponid, weaponName, sizeof(weaponName));
            if(Inventory_IsLAWWeapon(playerid, weaponid))
            {
                format(weaponName, sizeof(weaponName), "%s [LAW]", weaponName);
                switch(weaponid)
                {
                    case 22: amount = 10.5;
                    case 24: amount = 52.0;
                    case 29: amount = 10.5;
                    case 30: amount = 10.9;
                    case 31: amount = 10.9;
                }
            }
        }
        
        format(string, sizeof(string), "{4EC25D}>> +%.1f DMG {FFFFFF}| Muc tieu: {00FFCC}%s {FFFFFF}| Vu khi: {FFCC00}%s", amount, GetPlayerNameEx(damagedid), weaponName);
        SendClientMessage(playerid, -1, string);
    }
    return 1;
}