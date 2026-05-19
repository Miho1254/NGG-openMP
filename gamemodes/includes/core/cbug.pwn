#include <YSI\y_hooks>

 
forward OnPlayerMakeCBug(playerid);
public OnPlayerMakeCBug(playerid)
{
    ApplyAnimation(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
    GameTextForPlayer(playerid, "~r~Khong duoc CBUG !", 5000, 1); 
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_FIRE && oldkeys & KEY_CROUCH && IsCbugWeapon(playerid))
    {
        CallLocalFunction("OnPlayerMakeCBug", "i", playerid);
    }
    return 1;
}
 
stock IsCbugWeapon(playerid)
{
    new weaponID = GetPlayerWeapon(playerid);
    if(weaponID == 22 || weaponID == 24 || weaponID == 25 || weaponID == 27)
    {
        return 1;
    }
    return 0;
}