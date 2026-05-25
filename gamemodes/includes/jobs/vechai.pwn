#include <YSI\y_hooks>

#define MAX_VECHAI_POINTS 9
#define VECHAI_MAX_STOCK 500

new Float:VeChai_Locations[MAX_VECHAI_POINTS][3] = {
    {-1566.9843, 469.1526, 7.1868}, // SAAS
    {-2653.7520, 698.6767, 27.9185}, // BV SF
    {-2073.8164, 8.3023, 35.3203}, // Nha bo hoang
    {-1830.6876, -107.5092, 5.6484}, // Ben cang SF
    {-1024.6283, -587.0613, 32.0078}, // Nha may SF
    {-756.8199, -112.6511, 65.9816}, // Lam nghiep SF
    {93.6625, -237.3292, 1.5781}, // Container Blueberry
    {782.4303, -1389.3700, 13.6063}, // Sanew
    {1861.1680, -1320.0677, 13.5435} // Xay dung LS
};

new Float:VeChai_Angles[MAX_VECHAI_POINTS] = {
    59.0425, 1.5348, 5.4559, 180.7964, 6.3477, 136.5011, 348.4479, 177.6921, 90.9019
};

new VeChaiStock[MAX_VECHAI_POINTS];
new Text3D:VeChaiLabel[MAX_VECHAI_POINTS];

new pVeChai[MAX_PLAYERS];
new VehVeChai[MAX_VEHICLES];

stock UpdateVeChaiLabel(point) {
    new str[128];
    format(str, sizeof(str), "{FFFF00}Vat lieu ve chai\n{FFFFFF}Hien co: {00FF00}%d kg\n{FFFFFF}Su dung {FFFF00}/muavechai", VeChaiStock[point]);
    UpdateDynamic3DTextLabelText(VeChaiLabel[point], COLOR_YELLOW, str);
}

hook OnGameModeInit() {
    for(new i = 0; i < MAX_VECHAI_POINTS; i++) {
        CreateDynamicActor(153, VeChai_Locations[i][0], VeChai_Locations[i][1], VeChai_Locations[i][2], VeChai_Angles[i], 1, 100.0, -1, -1, -1);
        VeChaiStock[i] = 100 + random(201); // 100 - 300
        new str[128];
        format(str, sizeof(str), "{FFFF00}Vat lieu ve chai\n{FFFFFF}Hien co: {00FF00}%d kg\n{FFFFFF}Su dung {FFFF00}/muavechai", VeChaiStock[i]);
        VeChaiLabel[i] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, VeChai_Locations[i][0], VeChai_Locations[i][1], VeChai_Locations[i][2] + 1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 15.0);
    }
    
    // Thuong lai NPC
    CreateDynamicActor(153, -2525.4250, 247.3949, 11.0938, 217.2882, 1, 100.0, -1, -1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Thuong Lai Ve Chai\n{FFFFFF}Su dung {FFFF00}/banvechai\n{FFFFFF}Yeu cau do xe tai gan day", COLOR_YELLOW, -2525.4250, 247.3949, 11.0938 + 1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 15.0);
    return 1;
}

task VeChaiStock_Refill[3600000]() {
    for(new i = 0; i < MAX_VECHAI_POINTS; i++) {
        VeChaiStock[i] += 100 + random(201);
        if(VeChaiStock[i] > VECHAI_MAX_STOCK) VeChaiStock[i] = VECHAI_MAX_STOCK;
        UpdateVeChaiLabel(i);
    }
}

hook OnPlayerConnect(playerid) {
    pVeChai[playerid] = 0;
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    VehVeChai[vehicleid] = 0;
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    VehVeChai[vehicleid] = 0;
    return 1;
}

stock IsValidVeChaiTruck(vehicleid) {
    new model = GetVehicleModel(vehicleid);
    switch(model) {
        case 478, 422, 605, 600: return 1; // Walton, Bobcat, Sadler, Picador
    }
    return 0;
}

CMD:muavechai(playerid, params[]) {
    if(pVeChai[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang om mot dong ve chai tren tay roi, khong the be them!");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai buoc xuong xe moi co the mua!");
    
    new nearest_point = -1;
    for(new i = 0; i < MAX_VECHAI_POINTS; i++) {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, VeChai_Locations[i][0], VeChai_Locations[i][1], VeChai_Locations[i][2])) {
            nearest_point = i;
            break;
        }
    }
    
    if(nearest_point == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan diem thu mua ve chai nao!");
    
    if(VeChaiStock[nearest_point] <= 0) {
        new string[128];
        format(string, sizeof(string), "Nguoi thu gom [NPC]: Het hang roi, qua cho khac ma thu mua!");
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        return 1;
    }
    
    pVeChai[playerid] = VeChaiStock[nearest_point];
    VeChaiStock[nearest_point] = 0;
    UpdateVeChaiLabel(nearest_point);
    
    SetPlayerAttachedObject(playerid, 9, 1271, 1, 0.1, 0.3, 0.0, 0.0, 90.0, 0.0, 1.0, 1.0, 1.0);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY); // Force walk
    
    new string[128];
    format(string, sizeof(string), "Ban da mua thanh cong %d kg ve chai. Hay di bo dem bo vao cop xe tai cua ban (/putvechai).", pVeChai[playerid]);
    SendClientMessageEx(playerid, COLOR_GREEN, string);
    return 1;
}

CMD:putvechai(playerid, params[]) {
    if(pVeChai[playerid] <= 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong mang theo ve chai tren tay!");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam vay khi dang o tren xe!");
    
    new closestcar = -1;
    new Float:x, Float:y, Float:z;
    for(new i = 0; i < MAX_VEHICLES; i++) {
        if(IsValidVeChaiTruck(i)) {
            GetVehiclePos(i, x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 4.0, x, y, z)) {
                closestcar = i;
                break;
            }
        }
    }
    
    if(closestcar == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Khong tim thay chiec xe tai 2 cho nao (Walton, Bobcat, Sadler, Picador) o gan day!");
    
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(closestcar, engine, lights, alarm, doors, bonnet, boot, objective);
    if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban phai mo cop xe ra truoc! (/car trunk)");
    
    VehVeChai[closestcar] += pVeChai[playerid];
    new string[128];
    format(string, sizeof(string), "Ban da bo %d kg ve chai vao cop xe. (Tong cong: %d kg tren xe)", pVeChai[playerid], VehVeChai[closestcar]);
    SendClientMessageEx(playerid, COLOR_GREEN, string);
    
    pVeChai[playerid] = 0;
    RemovePlayerAttachedObject(playerid, 9);
    ClearAnimations(playerid);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    return 1;
}

CMD:banvechai(playerid, params[]) {
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2525.4250, 247.3949, 11.0938)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai dung gan NPC Thuong Lai Ve Chai!");
    
    new closestcar = -1;
    new Float:x, Float:y, Float:z;
    for(new i = 0; i < MAX_VEHICLES; i++) {
        if(IsValidVeChaiTruck(i)) {
            GetVehiclePos(i, x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z)) {
                closestcar = i;
                break;
            }
        }
    }
    
    if(closestcar == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Phai co xe tai cua ban cho ve chai nam o gan day!");
    if(VehVeChai[closestcar] <= 0) return SendClientMessageEx(playerid, COLOR_GREY, "Xe tai cua ban khong co kg ve chai nao!");
    
    new totalMats = 0;
    for(new i = 0; i < MAX_GROUPS; i++) {
        totalMats += arrGroupData[i][g_iLockerStock];
    }
    
    new Float:FeePer10kg = 0.0;
    
    if(totalMats > 100000) {
        FeePer10kg = 150.0;
    } else if(totalMats < 20000) {
        FeePer10kg = 30.0;
    } else {
        FeePer10kg = ((float(totalMats) - 20000.0) / 80000.0) * 120.0 + 30.0;
    }
    
    new kg = VehVeChai[closestcar];
    new mats_gain = kg * 10;
    new fee_total = floatround((float(kg) / 10.0) * FeePer10kg);
    
    if(GetPlayerCash(playerid) < fee_total) {
        new string[128];
        format(string, sizeof(string), "Thuong Lai [NPC]: May khong du tien tra phi gia cong roi! Can $%s de gia cong %d kg.", number_format(fee_total), kg);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        return 1;
    }
    
    GivePlayerCash(playerid, -fee_total);
    PlayerInfo[playerid][pMats] += mats_gain;
    VehVeChai[closestcar] = 0;
    
    new string[128];
    format(string, sizeof(string), "Ban da ton $%s chi phi gia cong de doi %d kg ve chai lay %s Vat lieu (Mats).", number_format(fee_total), kg, number_format(mats_gain));
    SendClientMessageEx(playerid, COLOR_GREEN, string);
    format(string, sizeof(string), "[Kinh Te] Tinh trang server: %s Mats -> Muc phi hien tai: $%d / 10kg.", number_format(totalMats), floatround(FeePer10kg));
    SendClientMessageEx(playerid, COLOR_YELLOW, string);
    
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
        if(pVeChai[playerid] > 0) {
            SendClientMessageEx(playerid, COLOR_RED, "Ban da danh roi so ve chai dang cam tren tay khi len xe!");
            pVeChai[playerid] = 0;
            RemovePlayerAttachedObject(playerid, 9);
            ClearAnimations(playerid);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        }
    }
    return 1;
}
