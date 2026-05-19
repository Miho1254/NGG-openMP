
#include <YSI\y_hooks>






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
    if(InfoDame[playerid] == true)
 	{
       if(issuerid != INVALID_PLAYER_ID)
       {
        new
            infoString[128],
            weaponName[24],
            victimName[MAX_PLAYER_NAME],
            attackerName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, victimName, sizeof (victimName));
        GetPlayerName(issuerid, attackerName, sizeof (attackerName));
        GetWeaponName(weaponid, weaponName, sizeof (weaponName));
        format(infoString, sizeof(infoString), "[DAMAGE] Ban da bi {339966}%s{FFFFFF} tan cong bang {FFCC33}%s{FFFFFF} ton hai {b30707}%.02fHP", attackerName, weaponName, amount);
        SendClientMessage(playerid, 0xFFFFFFFF, infoString);
        }
    }
    return 1;
}
hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)//add vao OnPlayerGiveDamage
{
	if(InfoDame[playerid] == true)
    {
 	new string[128], victim[MAX_PLAYER_NAME], attacker[MAX_PLAYER_NAME];
    new weaponname[24];
    
		
    GetPlayerName(playerid, attacker, sizeof (attacker));
    GetPlayerName(damagedid, victim, sizeof (victim));
    GetWeaponName(weaponid, weaponname, sizeof (weaponname));
    
	
    format(string, sizeof(string), "[DAMAGE] Ban da tan cong {339966}%s{FFFFFF} bang vu khi {FFCC33}%s{FFFFFF} gay ra {b30707}%.02fDMG", victim, weaponname, amount);
    SendClientMessage(playerid, -1, string);
    return 1;
    }
    return 1;
}
