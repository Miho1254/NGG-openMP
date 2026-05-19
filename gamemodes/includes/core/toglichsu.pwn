
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
    if(InfoDame[playerid] == true && issuerid != INVALID_PLAYER_ID)
    {
        new infoString[128], weaponName[24];
        
        // Weapon ID 0 là đấm tay không hoặc ngã, 54 là fall damage, không có tên súng
        if(weaponid == 0 || weaponid == 54) format(weaponName, sizeof(weaponName), "Tay Khong/Va Dap");
        else GetWeaponName(weaponid, weaponName, sizeof(weaponName));

        // Format: [Tổn hại] << -25.5 HP (Bởi: Thang_Ban | Súng: M4)
        format(infoString, sizeof(infoString), "{FF4C4C}<< -%.1f HP {FFFFFF}| Tu: {00FFCC}%s {FFFFFF}| Vu khi: {FFCC00}%s", amount, GetPlayerNameEx(issuerid), weaponName);
        SendClientMessage(playerid, -1, infoString);
    }
    return 1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
    if(InfoDame[playerid] == true && damagedid != INVALID_PLAYER_ID)
    {
        new string[128], weaponName[24];
        
        if(weaponid == 0 || weaponid == 54) format(weaponName, sizeof(weaponName), "Tay Khong");
        else GetWeaponName(weaponid, weaponName, sizeof(weaponName));
        
        // Format: [Trúng đích] >> +25.5 DMG (Mục tiêu: Thang_Dich | Súng: M4)
        format(string, sizeof(string), "{4EC25D}>> +%.1f DMG {FFFFFF}| Muc tieu: {00FFCC}%s {FFFFFF}| Vu khi: {FFCC00}%s", amount, GetPlayerNameEx(damagedid), weaponName);
        SendClientMessage(playerid, -1, string);
    }
    return 1;
}