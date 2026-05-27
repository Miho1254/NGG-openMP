#include <YSI\y_hooks>

#define VECHAI_MAX_STOCK 500
#define VECHAI_CARRY_LIMIT 10

new Float:VeChai_Angles[MAX_VECHAI_POINTS] = {
    59.0425, 1.5348, 5.4559, 180.7964, 6.3477, 136.5011, 348.4479, 177.6921, 90.9019
};


new const VeChai_BasePrice[MAX_VECHAI_POINTS] = {
    35, // SAAS (Medium distance)
    45, // BV SF (Very close)
    40, // Nha bo hoang (Close)
    38, // Ben cang SF (Close-medium)
    30, // Nha may SF (Medium-far)
    30, // Lam nghiep SF (Medium-far)
    25, // Container Blueberry (Far)
    20, // Sanew (Very far)
    15  // Xay dung LS (Extremely far)
};

new VeChaiStock[MAX_VECHAI_POINTS];
new Text3D:VeChaiLabel[MAX_VECHAI_POINTS];

new pVeChai[MAX_PLAYERS];
new VehVeChai[MAX_VEHICLES];
new VeChaiHotspotPoint = -1;

stock UpdateVeChaiLabel(point) {
    new str[256];
    if(point == VeChaiHotspotPoint) {
        format(str, sizeof(str), "{FF0000}[HOTSPOT - GIAM 50%%]{FFFF00}\nVat lieu ve chai ({FFFFFF}%s{FFFF00})\nHien co: {00FF00}%d kg\n{FFFFFF}Su dung {FFFF00}/muavechai", VeChai_Names[point], VeChaiStock[point]);
    } else {
        format(str, sizeof(str), "{FFFF00}Vat lieu ve chai ({FFFFFF}%s{FFFF00})\nHien co: {00FF00}%d kg\n{FFFFFF}Su dung {FFFF00}/muavechai", VeChai_Names[point], VeChaiStock[point]);
    }
    UpdateDynamic3DTextLabelText(VeChaiLabel[point], COLOR_YELLOW, str);
}

hook OnGameModeInit() {
    for(new i = 0; i < MAX_VECHAI_POINTS; i++) {
        CreateDynamicActor(153, VeChai_Locations[i][0], VeChai_Locations[i][1], VeChai_Locations[i][2], VeChai_Angles[i], 1, 100.0, -1, -1, -1);
        VeChaiStock[i] = 100 + random(201); // 100 - 300
        new str[256];
        format(str, sizeof(str), "{FFFF00}Vat lieu ve chai ({FFFFFF}%s{FFFF00})\nHien co: {00FF00}%d kg\n{FFFFFF}Su dung {FFFF00}/muavechai", VeChai_Names[i], VeChaiStock[i]);
        VeChaiLabel[i] = CreateDynamic3DTextLabel(str, COLOR_YELLOW, VeChai_Locations[i][0], VeChai_Locations[i][1], VeChai_Locations[i][2] + 1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 15.0);
    }
    
    // Thuong lai NPC
    CreateDynamicActor(153, -2525.4250, 247.3949, 11.0938, 217.2882, 1, 100.0, -1, -1, -1);
    CreateDynamic3DTextLabel("{FFFF00}Anh Nguyen Chu Thau (Thu mua Vat Lieu)\n{FFFFFF}Su dung {FFFF00}/banvechai\n{FFFFFF}Yeu cau do xe tai gan day", COLOR_YELLOW, -2525.4250, 247.3949, 11.0938 + 1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 15.0);
    return 1;
}

task VeChaiStock_Refill[3600000]() {
    for(new i = 0; i < MAX_VECHAI_POINTS; i++) {
        if(i == VeChaiHotspotPoint) continue;
        VeChaiStock[i] += 100 + random(201);
        if(VeChaiStock[i] > VECHAI_MAX_STOCK) VeChaiStock[i] = VECHAI_MAX_STOCK;
        UpdateVeChaiLabel(i);
    }
}

task VeChai_UpdateHotspot[1800000]() {
    new next_hotspot = random(MAX_VECHAI_POINTS);
    if(next_hotspot == VeChaiHotspotPoint) next_hotspot = (next_hotspot + 1) % MAX_VECHAI_POINTS;
    
    new old_hotspot = VeChaiHotspotPoint;
    VeChaiHotspotPoint = next_hotspot;
    
    if(old_hotspot != -1) UpdateVeChaiLabel(old_hotspot);
    
    VeChaiStock[VeChaiHotspotPoint] = VECHAI_MAX_STOCK;
    UpdateVeChaiLabel(VeChaiHotspotPoint);
    
    new str[256];
    format(str, sizeof(str), "{FFFF00}[Ve Chai] Diem thu mua '%s' dang co nguon hang thanh ly voi gia giam 50%%! Nhap /map de dinh vi.", VeChai_Names[VeChaiHotspotPoint]);
    SendClientMessageToAllEx(COLOR_YELLOW, str);
}

hook OnPlayerConnect(playerid) {
    pVeChai[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    pVeChai[playerid] = 0;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if(pVeChai[playerid] > 0) {
        pVeChai[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 9);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi chet va lam rot so ve chai dang cam!");
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    VehVeChai[vehicleid] = 0;
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    if(VehVeChai[vehicleid] > 0) {
        new msg[128];
        format(msg, sizeof(msg), "%dkg ve chai tren xe da bi mat vi xe bi pha huy!", VehVeChai[vehicleid]);
        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(vehicleid, vx, vy, vz);
        foreach(new i : Player) {
            if(IsPlayerInRangeOfPoint(i, 50.0, vx, vy, vz)) {
                SendClientMessageEx(i, COLOR_RED, msg);
            }
        }
        VehVeChai[vehicleid] = 0;
    }
    return 1;
}

stock IsValidVeChaiTruck(vehicleid) {
    new model = GetVehicleModel(vehicleid);
    switch(model) {
        case 478, 422, 543, 605, 600, 554, 444, 556, 557: return 1; // Walton, Bobcat, Sadler (543), Sadler móp méo (605), Picador, Yosemite, Monster Trucks
    }
    return 0;
}

CMD:muavechai(playerid, params[]) {
    if(pVeChai[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang om mot dong ve chai tren tay roi, khong the be them!");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai buoc xuong xe moi co the mua!");
    if(gettime() < GetPVarInt(playerid, "VeChaiCooldown")) {
        new string[128];
        format(string, sizeof(string), "Ban phai cho %d giay de tiep tuc thu mua ve chai!", GetPVarInt(playerid, "VeChaiCooldown") - gettime());
        return SendClientMessageEx(playerid, COLOR_GREY, string);
    }
    
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
    
    new base = VeChai_BasePrice[nearest_point];
    new price_per_kg = base - 5 + random(11); // base price +/- $5
    if(nearest_point == VeChaiHotspotPoint) {
        price_per_kg /= 2; // 50% discount
    }
    
    new amount = (VeChaiStock[nearest_point] >= VECHAI_CARRY_LIMIT) ? VECHAI_CARRY_LIMIT : VeChaiStock[nearest_point];
    new total_cost = amount * price_per_kg;

    if(GetPlayerCash(playerid) < total_cost) {
        new string[128];
        format(string, sizeof(string), "Nguoi thu gom [NPC]: Ban khong du tien! Can $%s de mua %d kg ve chai (gia $%d/kg).", number_format(total_cost), amount, price_per_kg);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        return 1;
    }
    
    GivePlayerCash(playerid, -total_cost);
    pVeChai[playerid] = amount;
    VeChaiStock[nearest_point] -= amount;
    UpdateVeChaiLabel(nearest_point);
    
    SetPlayerAttachedObject(playerid, 9, 1271, 1, -0.071, 0.536, -0.026999, -2.19999, 87.1999, 0.699999, 0.8, 0.8, 0.8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY); // Force walk
    
    SetPVarInt(playerid, "VeChaiCooldown", gettime() + 10);
    
    new string[128];
    format(string, sizeof(string), "Ban da mua thanh cong %d kg ve chai voi gia $%s (gia $%d/kg). Hay di bo dem bo vao cop xe tai cua ban (/putvechai).", amount, number_format(total_cost), price_per_kg);
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
    
    if(closestcar == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Khong tim thay chiec xe tai ban tai nao (Walton, Bobcat, Sadler, Picador, Yosemite...) o gan day!");
    
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(closestcar, engine, lights, alarm, doors, bonnet, boot, objective);
    if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban phai mo cop xe ra truoc! (/car trunk)");
    
    if(VehVeChai[closestcar] + pVeChai[playerid] > 100) return SendClientMessageEx(playerid, COLOR_GREY, "Xe tai cua ban da dat gioi han tai trong ve chai (Toi da 100 kg)!");
    
    VehVeChai[closestcar] += pVeChai[playerid];
    new string[128];
    format(string, sizeof(string), "Ban da bo %d kg ve chai vao cop xe. (Tong cong: %d kg tren xe)", pVeChai[playerid], VehVeChai[closestcar]);
    SendClientMessageEx(playerid, COLOR_GREEN, string);
    
    pVeChai[playerid] = 0;
    RemovePlayerAttachedObject(playerid, 9);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    ClearAnimations(playerid);
    return 1;
}

CMD:banvechai(playerid, params[]) {
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2525.4250, 247.3949, 11.0938)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai dung gan Anh Nguyen Chu Thau!");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai buoc xuong xe moi co the ban ve chai!");
    
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
    
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(closestcar, engine, lights, alarm, doors, bonnet, boot, objective);
    if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD3, "Ban phai mo cop xe ra de lay hang! (/car trunk)");
    
    if(VehVeChai[closestcar] <= 0) return SendClientMessageEx(playerid, COLOR_GREY, "Xe tai cua ban khong co kg ve chai nao!");
    
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
    
    new name_str[128];
    format(name_str, sizeof(name_str), "* %s dang be ve chai tu trong cop xe ban cho Anh Nguyen Chu Thau.", GetPlayerNameEx(playerid));
    ProxDetector(30.0, playerid, name_str, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    
    new totalMats = 0;
    for(new i = 0; i < MAX_GROUPS; i++) {
        totalMats += arrGroupData[i][g_iLockerStock];
    }
    
    new Float:FeePer10kg = 0.0;
    
    if(totalMats > 10000000) {
        FeePer10kg = 150.0;
    } else if(totalMats < 2000000) {
        FeePer10kg = 30.0;
    } else {
        FeePer10kg = ((float(totalMats) - 2000000.0) / 8000000.0) * 120.0 + 30.0;
    }
    
    new kg = VehVeChai[closestcar];
    new mats_per_kg = 50 + random(21); // 50 - 70 mats per kg
    new mats_gain = kg * mats_per_kg;
    new fee_total = floatround((float(kg) / 10.0) * FeePer10kg);
    
    if(GetPlayerCash(playerid) < fee_total) {
        new string[128];
        format(string, sizeof(string), "Anh Nguyen Chu Thau [NPC]: May khong du tien tra phi gia cong roi! Can $%s de gia cong %d kg.", number_format(fee_total), kg);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        return 1;
    }
    
    GivePlayerCash(playerid, -fee_total);
    PlayerInfo[playerid][pMats] += mats_gain;
    VehVeChai[closestcar] = 0;
    
    new string[128];
    format(string, sizeof(string), "Ban da ton $%s chi phi gia cong de doi %d kg ve chai lay %s Vat lieu (Mats) (Ty le: %d Mats/kg).", number_format(fee_total), kg, number_format(mats_gain), mats_per_kg);
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
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            ClearAnimations(playerid);
        }
    }
    return 1;
}
