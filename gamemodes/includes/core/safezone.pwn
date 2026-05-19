

#include <YSI\y_hooks>

enum sf_empty_data {
    Text3D: sfTextID,
	sfPickupID,
	Float:sfPos[4],
	sfVw,
	sfInt,
	sfAreaID
}

enum e_sfData {
    Float:pos_x,
    Float:pos_y,
    Float:pos_z,
    Float:range,
    _VW,
    _Int,
}

new 
    totalSafeZone = 0,
    SafeZone[MAX_SAFE_ZONE][sf_empty_data];
new SafeZoneList[][e_sfData] = {
    //      x,       y,       z,     range,  vw, int
    {1133.71,   -1464.52,   15.77,   150.0,   0, 0},  // Mall
    {378.07,    -2068.11,    7.83,    40.0,   0, 0},  // Cauca1
    {836.09,    -2048.50,   12.86,    60.0,   0, 0},  // Cauca2
    {-1598.42,     75.28,    3.55,    75.0,   0, 0},  // Trucker
    {-1701.51,   1368.42,    7.17,   150.0,   0, 0},  // Pizza SF
    {2109.14,   -1806.57,   13.54,    50.0,   0, 0},  // Pizza LS
    {2383.27,    2659.64, 8001.14,    30.0,  -1, -1}, // BV -- Interior
    {-2599.33,    616.18,   15.62,   150.0,   0, 0},  // Outside BV SF
    //{-2433.45,    512.58,   30.37,    50.0,   0, 0},  // VIP SF
    //{1809.76,   -1586.00,   14.04,    50.0,   0, 0},  // VIP LS
    {2310.28,      -5.62,   26.74,    15.0,  -1, -1}, // Bank -- Interior
    {-1615.43,    681.88,    7.18,   100.0,   0, 0},  // Police SF
    {1555.68,   -1675.53,   28.39,    50.0,   0, 0},  // Police LS
    {-1663.47,   1203.53,    7.25,    25.0,   0, 0},  // SHOP XE DOWNTOWN SF
    {1715.25,   -1891.89,   13.56,    20.0,   0, 0},  // SPAWN
    {1174.73,   -1322.83,   19.43,    60.0,   0, 0},  // All Saints Outside
    //{2555.19,    1417.70, 7703.70,    35.0,  -1, -1},  // VIP -- interior
    {1175.44,   -2038.37,   67.05,    80.0,   0, 0}   // San Andreas Goverment (LS)
    //{-4400.94,    866.03,  993.49,    35.0,  -1,  -1}   // Garage VIP
};

stock LoadDynamicSafeZone()
{
    for(new i; i < sizeof(SafeZoneList); i++) {
        if(i > MAX_SAFE_ZONE) break;
        SafeZone[i][sfPos][0] = SafeZoneList[i][pos_x];
        SafeZone[i][sfPos][1] = SafeZoneList[i][pos_y];
        SafeZone[i][sfPos][2] = SafeZoneList[i][pos_z];
        SafeZone[i][sfPos][3] = SafeZoneList[i][range];
        SafeZone[i][sfVw] = SafeZoneList[i][_VW];
        SafeZone[i][sfInt] = SafeZoneList[i][_Int];
        
        if(IsValidDynamicArea(SafeZone[i][sfAreaID])) DestroyDynamicArea(SafeZone[i][sfAreaID]), SafeZone[i][sfAreaID] = _:-1;
        if(IsValidDynamicPickup(SafeZone[i][sfPickupID])) DestroyDynamicPickup(SafeZone[i][sfPickupID]), SafeZone[i][sfPickupID] = _:-1;
        if(IsValidDynamic3DTextLabel(SafeZone[i][sfTextID])) DestroyDynamic3DTextLabel(SafeZone[i][sfTextID]), SafeZone[i][sfTextID] = Text3D:-1;
        SafeZone[i][sfAreaID] = CreateDynamicSphere(SafeZone[i][sfPos][0], SafeZone[i][sfPos][1], SafeZone[i][sfPos][2], SafeZone[i][sfPos][3], .worldid = SafeZone[i][sfVw], .interiorid = SafeZone[i][sfInt]);
        SafeZone[i][sfPickupID] = CreateDynamicPickup(1239, 23, SafeZone[i][sfPos][0], SafeZone[i][sfPos][1], SafeZone[i][sfPos][2], .worldid = SafeZone[i][sfVw], .interiorid = SafeZone[i][sfInt], .streamdistance = 200.0);
        format(szMiscArray, sizeof szMiscArray, "{FFFF00}SafeZone({FFFFFF}ID: %i{FFFF00})\n\nPham vi: {FFFFFF}%0.1f", i, SafeZone[i][sfPos][3]);
        SafeZone[i][sfTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, SafeZone[i][sfPos][0], SafeZone[i][sfPos][1], SafeZone[i][sfPos][2]+0.6, 10.0, .testlos = 1, .worldid = SafeZone[i][sfVw], .interiorid = SafeZone[i][sfInt], .streamdistance = 10.0); 
        totalSafeZone++;
    }
    if(totalSafeZone > 0) printf("[LoadDynamicSafeZone] %d safezone rehashed/loaded.", totalSafeZone);
	else printf("[LoadDynamicSafeZone] Failed to load any safezone.");
}


hook OnPlayerEnterDynArea(playerid, areaid) {

    for(new i = 0; i < totalSafeZone; i++) {
        if(areaid == SafeZone[i][sfAreaID]) {
            SendClientMessage(playerid, -1, "{31c600}[!]{FFFFFF} Ban da vao khu vuc SafeZone.");
            inSafeZone{playerid} = true;
            break;
        }
    }
}
hook OnPlayerLeaveDynArea(playerid, areaid) {
    for(new i = 0; i < totalSafeZone; i++) {
        if(areaid == SafeZone[i][sfAreaID]) {
            SendClientMessage(playerid, -1, "{ff2e00}[!]{FFFFFF} Ban da ra khoi khu vuc SafeZone.");
            inSafeZone{playerid} = false;
            break;
        }
    }
}

