const VehicleDestroyed = 136;

const PLAYER_SYNC = 207;
const VEHICLE_SYNC = 200;
const PASSENGER_SYNC = 211;
// const TRAILER_SYNC = 210;
// const UNOCCUPIED_SYNC = 209;
const AIM_SYNC = 203;
const BULLET_SYNC = 206;
const UNOCCUPIED_SYNC = 209;

//RPCs
const RPC_ServerJoin = 137;
const RPC_ServerQuit = 138;

// enum eDisabledKeys
// {
//     Disable_LeftKey,
//     Disable_RightKey,
//     Disable_UpKey,
//     Disable_DownKey,
//     Disabled_Keys
// };
// new gPlayerDisabledKeys[MAX_PLAYERS][eDisabledKeys];

// stock ProcessDisabledKeys(playerid, &lrKey, &udKey, &keys)
// {
//     if (
//         (lrKey == KEY_LEFT && gPlayerDisabledKeys[playerid][Disable_LeftKey]) ||
//         (lrKey == KEY_RIGHT && gPlayerDisabledKeys[playerid][Disable_RightKey])
//     ) {
//         lrKey = 0;
//     }

//     if (
//         (udKey == KEY_UP && gPlayerDisabledKeys[playerid][Disable_UpKey]) ||
//         (udKey == KEY_DOWN && gPlayerDisabledKeys[playerid][Disable_DownKey])
//     ) {
//         udKey = 0;
//     }

//     keys &= ~gPlayerDisabledKeys[playerid][Disabled_Keys];
// }

// stock SetPlayerDisableKeysSync(playerid, keys, left = false, right = false, up = false, down = false)
// {
//     gPlayerDisabledKeys[playerid][Disable_LeftKey] = left;
//     gPlayerDisabledKeys[playerid][Disable_RightKey] = right;
//     gPlayerDisabledKeys[playerid][Disable_UpKey] = up;
//     gPlayerDisabledKeys[playerid][Disable_DownKey] = down;

//     gPlayerDisabledKeys[playerid][Disabled_Keys] = keys;
// }

// ShowPlayerOnScoreBoard(playerid, toplayerid, bool:show)
// {
//     if(!IsPlayerConnected(playerid) || !IsPlayerConnected(toplayerid)) return 0;
    
//     new BitStream:bs = BS_New(), name[MAX_PLAYER_NAME];
    
//     BS_WriteValue(
//         bs,
//         PR_UINT16, playerid,
//         PR_UINT8, 1
//     );

//     BS_RPC(bs, toplayerid, RPC_ServerQuit);
//     BS_Reset(bs);
    
//     GetPlayerName(playerid, name, sizeof(name));
    
//     BS_WriteValue(
//         bs,
//         PR_UINT16, playerid,
//         PR_INT32, 0,
//         PR_UINT8, !show,
//         PR_UINT8, strlen(name),
//         PR_STRING, name
//     );
    
//     BS_RPC(bs, toplayerid, RPC_ServerJoin);
//     BS_Delete(bs);
//     return 1;
// }  

public OnIncomingPacket(playerid, packetid, BitStream:bs)
{
    if (packetid == PLAYER_SYNC)
    {
        new onFootData[PR_OnFootSync];

        BS_IgnoreBits(bs, 8); // ignore packetid (byte)
        BS_ReadOnFootSync(bs, onFootData);

        if (onFootData[PR_surfingVehicleId] != 0 &&
            onFootData[PR_surfingVehicleId] != INVALID_VEHICLE_ID
        ) {
            if ((floatabs(onFootData[PR_surfingOffsets][0]) >= 10.0) ||
                (floatabs(onFootData[PR_surfingOffsets][1]) >= 10.0) ||
                (floatabs(onFootData[PR_surfingOffsets][2]) >= 10.0) ||
                (floatabs(onFootData[PR_surfingOffsets][0]) <= -10.0) ||
                (floatabs(onFootData[PR_surfingOffsets][1]) <= -10.0) ||
                (floatabs(onFootData[PR_surfingOffsets][2]) <= -10.0)
            ) {
                onFootData[PR_surfingOffsets][0] = onFootData[PR_surfingOffsets][1] = onFootData[PR_surfingOffsets][2] = 0.0;

                BS_SetWriteOffset(bs, 8);
                BS_WriteOnFootSync(bs, onFootData); // rewrite
            } 
        }
    }

    return 1;
}

IRPC:VehicleDestroyed(playerid, BitStream:bs)
{
    new vehicleid;

    BS_ReadUint16(bs, vehicleid);

    if (GetVehicleModel(vehicleid) < 400)
    {
        return 0;
    }

    return OnVehicleDeathRequest(vehicleid, playerid);
}

forward OnVehicleDeathRequest(vehicleid, killerid);
public OnVehicleDeathRequest(vehicleid, killerid)
{
    new Float:health;

    GetVehicleHealth(vehicleid, health);

    if (health > 300.0)
    {
        return 0;
    }

    return 1;
}

IPacket:PLAYER_SYNC(playerid, BitStream:bs)
{
    new string[128], onFootData[PR_OnFootSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadOnFootSync(bs, onFootData);
    // new Float:S = floatsqroot(floatpower(floatabs(onFootData[PR_velocity][0]), 2.0) + floatpower(floatabs(onFootData[PR_velocity][1]), 2.0) + floatpower(floatabs(onFootData[PR_velocity][2]), 2.0)) * 253.3;
    // if(S > 70.0) {
    //     new string[128];
    //     format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: FastWalk", GetPlayerNameExt(playerid),playerid);
    //     ABroadCast(COLOR_YELLOW, string, 3);
    //     string[0] = EOS;
    //     Kick(playerid);
    //     return false;
    // }
    if(onFootData[PR_position][2] == -3.0 && onFootData[PR_surfingVehicleId] == INVALID_VEHICLE_ID) {
        printf(
            "PLAYER_SYNC[%d]:\nlrKey %d \nudKey %d \nkeys %d \nposition: %.2f %.2f %.2f \nquaternion %.2f %.2f %.2f %.2f \nhealth %d \narmour %d \nadditionalKey %d \nweaponId %d \nspecialAction %d \nvelocity %.2f %.2f %.2f \nsurfingOffsets %.2f %.2f %.2f \nsurfingVehicleId %d \nanimationId %d \nanimationFlags %d",
            playerid,
            onFootData[PR_lrKey],
            onFootData[PR_udKey],
            onFootData[PR_keys],
            onFootData[PR_position][0],
            onFootData[PR_position][1],
            onFootData[PR_position][2],
            onFootData[PR_quaternion][0],
            onFootData[PR_quaternion][1],
            onFootData[PR_quaternion][2],
            onFootData[PR_quaternion][3],
            onFootData[PR_health],
            onFootData[PR_armour],
            onFootData[PR_additionalKey],
            onFootData[PR_weaponId],
            onFootData[PR_specialAction],
            onFootData[PR_velocity][0],
            onFootData[PR_velocity][1],
            onFootData[PR_velocity][2],
            onFootData[PR_surfingOffsets][0],
            onFootData[PR_surfingOffsets][1],
            onFootData[PR_surfingOffsets][2],
            onFootData[PR_surfingVehicleId],
            onFootData[PR_animationId],
            onFootData[PR_animationFlags]
        );
    }

    if(onFootData[PR_position][2] == -5.5) {
        format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: BulletCrasher", GetPlayerNameExt(playerid),playerid);
        ABroadCast(COLOR_YELLOW, string, 3);
        Log("newanti.log", string);
        string[0] = EOS;
        Kick(playerid);
        return false;
    }

    if(!gPlayerLogged{playerid})
    {
        if(GetPointDistanceToPoint(onFootData[PR_position][0],onFootData[PR_position][1],onFootData[PR_position][2],1129.1584,-1449.4734,15.9497) < 100.0)
        {
            
            // format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: teleport 1", GetPlayerNameExt(playerid),playerid);
            // ABroadCast(COLOR_YELLOW, string, 3);
            // Log("newanti.log", string);
            Kick(playerid);
            return false;
        }

        if(PlayerPosCheck[playerid][2] != 0.0 && GetPointDistanceToPoint(onFootData[PR_position][0],onFootData[PR_position][1],onFootData[PR_position][2],PlayerPosCheck[playerid][0],PlayerPosCheck[playerid][1],PlayerPosCheck[playerid][2]) > 100.0 && GetPVarInt(playerid, "AntiTPCheck") < gettime())
        {
            if(Spectating[playerid] == 0 && !PlayerInfo[playerid][pSpectating])
            {
                
                // format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: teleport 2", GetPlayerNameExt(playerid),playerid);
                // ABroadCast(COLOR_YELLOW, string, 3);
                // Log("newanti.log", string);
                Kick(playerid);
                return false;
            }
        }

        if(PlayerPosCheck[playerid][0] != onFootData[PR_position][0]) PlayerPosCheck[playerid][0] = onFootData[PR_position][0];
        if(PlayerPosCheck[playerid][1] != onFootData[PR_position][1]) PlayerPosCheck[playerid][1] = onFootData[PR_position][1];
        if(PlayerPosCheck[playerid][2] != onFootData[PR_position][0]) PlayerPosCheck[playerid][2] = onFootData[PR_position][2];
    }
    
    if(!IsPlayerInAnyVehicle(playerid) && InsidePlane[playerid] == INVALID_VEHICLE_ID && gPlayerLogged{playerid})
    {
        // if(PlayerPosCheck[playerid][2] != 0.0 && GetPointDistanceToPoint(onFootData[PR_position][0],onFootData[PR_position][1],onFootData[PR_position][2],PlayerPosCheck[playerid][0],PlayerPosCheck[playerid][1],PlayerPosCheck[playerid][2]) > 30.0 && GetPVarInt(playerid, "AntiTPCheck") < gettime())
        // {
        //     if(Spectating[playerid] == 0 && !PlayerInfo[playerid][pSpectating] && !Connecting{playerid} && ++AntiTPRaknet[playerid] >= 2)
        //     {
                
        //         format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: teleport 3", GetPlayerNameExt(playerid),playerid);
        //         ABroadCast(COLOR_YELLOW, string, 3);
        //         Log("newanti.log", string);
        //         Kick(playerid);
        //         return false;
        //     }
        // }
        if(PlayerPosCheck[playerid][0] != onFootData[PR_position][0]) PlayerPosCheck[playerid][0] = onFootData[PR_position][0];
        if(PlayerPosCheck[playerid][1] != onFootData[PR_position][1]) PlayerPosCheck[playerid][1] = onFootData[PR_position][1];
        if(PlayerPosCheck[playerid][2] != onFootData[PR_position][0]) PlayerPosCheck[playerid][2] = onFootData[PR_position][2];
    }

    // if(CheckSafeZone(playerid)) 
    // {
    //     InSafeZone{playerid} = false;
    //     PlayerSafezoneRequire(playerid, true);
    // }
    // else {
    //     InSafeZone{playerid} = true;
    //     PlayerSafezoneRequire(playerid, false);
    // }
    
    // if(isDisabledFire{playerid}) ProcessDisabledKeys(playerid, onFootData[PR_lrKey], onFootData[PR_udKey], onFootData[PR_keys]);

    // BS_SetWriteOffset(bs, 8);
    // BS_WriteOnFootSync(bs, onFootData);

    return true;
}

IPacket:VEHICLE_SYNC(playerid, BitStream:bs)
{
    new string[128], inCarData[PR_InCarSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadInCarSync(bs, inCarData);

    // if(IsPlayerInAnyVehicle(playerid) && !gPlayerLogged{playerid})
    // {
    //     format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: Invalid Login Car", GetPlayerNameExt(playerid),playerid);
    //     ABroadCast(COLOR_YELLOW, string, 3);
    //     Log("newanti.log", string);
    //     string[0] = EOS;
    //     Kick(playerid);
    //     return false;
    // }

    // if(IsPlayerInAnyVehicle(playerid) && DangLenXe[playerid] != inCarData[PR_vehicleId] && GetPVarInt(playerid, "AntiTPCheck") < gettime())
    // {
    //     format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: CarJack", GetPlayerNameExt(playerid),playerid);
    //     ABroadCast(COLOR_YELLOW, string, 3);
    //     Log("newanti.log", string);
    //     string[0] = EOS;
    //     Kick(playerid);
    //     return false;
    // }
    // new Float:S = floatsqroot(floatpower(floatabs(inCarData[PR_velocity][0]), 2.0) + floatpower(floatabs(inCarData[PR_velocity][1]), 2.0) + floatpower(floatabs(inCarData[PR_velocity][2]), 2.0)) * 253.3;
    // if(S > 400.0 && !IsAPlane(inCarData[PR_vehicleId])) {

    //     format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: Speedcar", GetPlayerNameExt(playerid),playerid);
    //     ABroadCast(COLOR_YELLOW, string, 3);
    //     Log("newanti.log", string);
    //     string[0] = EOS;
    //     Kick(playerid);
    //     return false;
    // }

    // new log[256];
    // format(log, sizeof log,"VEHICLE_SYNC[%d]:\nvehicleId %d \nlrKey %d \nudKey %d \nkeys %d \nquaternion %.2f %.2f %.2f %.2f \nposition %.2f %.2f %.2f \nvelocity %.2f %.2f %.2f \nvehicleHealth %.2f \nplayerHealth %d \narmour %d \nadditionalKey %d \nweaponId %d \nsirenState %d \nlandingGearState %d \ntrailerId %d \ntrainSpeed %.2f",
    //     playerid,
    //     inCarData[PR_vehicleId],
    //     inCarData[PR_lrKey],
    //     inCarData[PR_udKey],
    //     inCarData[PR_keys],
    //     inCarData[PR_quaternion][0],
    //     inCarData[PR_quaternion][1],
    //     inCarData[PR_quaternion][2],
    //     inCarData[PR_quaternion][3],
    //     inCarData[PR_position][0],
    //     inCarData[PR_position][1],
    //     inCarData[PR_position][2],
    //     inCarData[PR_velocity][0],
    //     inCarData[PR_velocity][1],
    //     inCarData[PR_velocity][2],
    //     inCarData[PR_vehicleHealth],
    //     inCarData[PR_playerHealth],
    //     inCarData[PR_armour],
    //     inCarData[PR_additionalKey],
    //     inCarData[PR_weaponId],
    //     inCarData[PR_sirenState],
    //     inCarData[PR_landingGearState],
    //     inCarData[PR_trailerId],
    //     inCarData[PR_trainSpeed]
    // );
    // Log("vehicle_sync.log", log);

    if(IsPlayerInAnyVehicle(playerid) && InsidePlane[playerid] == INVALID_VEHICLE_ID && !PlayerInfo[playerid][pSpectating] && gPlayerLogged{playerid})
    {
        new Float:fdistance = 50.0;
        if(IsAPlane(inCarData[PR_vehicleId])) fdistance = 70.0;

        if(++AntiTPRaknet[playerid] >= 2 && PlayerPosCheck[playerid][2] != 0.0 && GetPointDistanceToPoint(inCarData[PR_position][0],inCarData[PR_position][1],inCarData[PR_position][2],PlayerPosCheck[playerid][0],PlayerPosCheck[playerid][1],PlayerPosCheck[playerid][2]) > fdistance && GetPVarInt(playerid, "AntiTPCheck") < gettime())
        {
            format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %s (ID:%d) was auto-kicked, reason: Teleport (vehicle)", GetPlayerNameExt(playerid),playerid);
            ABroadCast(COLOR_YELLOW, string, 3);
            Log("newanti.log", string);
            // string[0] = EOS;
            Kick(playerid);
            return false;
        }
        if(PlayerPosCheck[playerid][0] != inCarData[PR_position][0]) PlayerPosCheck[playerid][0] = inCarData[PR_position][0];
        if(PlayerPosCheck[playerid][1] != inCarData[PR_position][1]) PlayerPosCheck[playerid][1] = inCarData[PR_position][1];
        if(PlayerPosCheck[playerid][2] != inCarData[PR_position][2]) PlayerPosCheck[playerid][2] = inCarData[PR_position][2];
    }
    // if(isDisabledFire{playerid}) ProcessDisabledKeys(playerid, inCarData[PR_lrKey], inCarData[PR_udKey], inCarData[PR_keys]);

    // BS_SetWriteOffset(bs, 8);
    // BS_WriteInCarSync(bs, inCarData);
    
    return true;
}

IPacket:PASSENGER_SYNC(playerid, BitStream:bs)
{
    new passengerData[PR_PassengerSync];

    BS_IgnoreBits(bs, 8);
    BS_ReadPassengerSync(bs, passengerData);


    // if(GetPlayerVehicleSeat(playerid) == 0) {
    //     // new string[128];
    //     // format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %q (ID:%d) was auto-kicked, reason: InvalidSeat",GetPlayerNameExt(playerid),playerid);
    //     // ABroadCast(COLOR_YELLOW, string, 3);
    //     // Log("newanti.log", string);
    //     // string[0] = EOS;
    //     Kick(playerid);
    //     return false;
    // }



    // new log[256];
    // format(log, sizeof log,"PASSENGER_SYNC[%d]:\nvehicleId %d \ndriveBy %d \nseatId %d \nadditionalKey %d \nweaponId %d \nplayerHealth %d \nplayerArmour %d \nlrKey %d \nudKey %d \nkeys %d \nposition %.2f %.2f %.2f",
    //     playerid,
    //     passengerData[PR_vehicleId],
    //     passengerData[PR_driveBy],
    //     passengerData[PR_seatId],
    //     passengerData[PR_additionalKey],
    //     passengerData[PR_weaponId],
    //     passengerData[PR_playerHealth],
    //     passengerData[PR_playerArmour],
    //     passengerData[PR_lrKey],
    //     passengerData[PR_udKey],
    //     passengerData[PR_keys],
    //     passengerData[PR_position][0],
    //     passengerData[PR_position][1],
    //     passengerData[PR_position][2]
    // );
    // Log("passenger_sync.log", log);
    // if(isDisabledFire{playerid}) ProcessDisabledKeys(playerid, passengerData[PR_lrKey], passengerData[PR_udKey], passengerData[PR_keys]);

    // BS_SetWriteOffset(bs, 8);
    // BS_WritePassengerSync(bs, passengerData);
    return 1;
}

IPacket:AIM_SYNC(playerid, BitStream:bs)
{
    new aimData[PR_AimSync];
    
    BS_IgnoreBits(bs, 8);
    BS_ReadAimSync(bs, aimData);

    if (aimData[PR_aimZ] != aimData[PR_aimZ]) // is NaN
    {
        aimData[PR_aimZ] = 0.0;

        BS_SetWriteOffset(bs, 8);
        BS_WriteAimSync(bs, aimData);
    }

    // if(CheckSafeZone(playerid)) 
    // {
    //     InSafeZone{playerid} = false;
    //     PlayerSafezoneRequire(playerid, true);
    // }
    // else {
    //     InSafeZone{playerid} = true;
    //     PlayerSafezoneRequire(playerid, false);
    // }


    // new log[144];
    // format(log, sizeof log, "AIM_SYNC[%d]:\ncamMode %d \ncamFrontVec %.2f %.2f %.2f \ncamPos %.2f %.2f %.2f \naimZ %.2f \nweaponState %d \ncamZoom %d \naspectRatio %d",
    //     playerid,
    //     aimData[PR_camMode],
    //     aimData[PR_camFrontVec][0],
    //     aimData[PR_camFrontVec][1],
    //     aimData[PR_camFrontVec][2],
    //     aimData[PR_camPos][0],
    //     aimData[PR_camPos][1],
    //     aimData[PR_camPos][2],
    //     aimData[PR_aimZ],
    //     aimData[PR_weaponState],
    //     aimData[PR_camZoom],
    //     aimData[PR_aspectRatio]
    // );

    // Log("aim_sync.log", log);
    return 1;
}

IPacket:BULLET_SYNC(playerid, BitStream:bs)
{
    new bulletData[PR_BulletSync];

    BS_IgnoreBits(bs, 8);
    BS_ReadBulletSync(bs, bulletData);

    // new log[144];
    // format(log, sizeof log, "BULLET_SYNC[%d]:\nhitType %d \nhitId %d \norigin %.2f %.2f %.2f \nhitPos %.2f %.2f %.2f \noffsets %.2f %.2f %.2f \nweaponId %d",
    //     playerid,
    //     bulletData[PR_hitType],
    //     bulletData[PR_hitId],
    //     bulletData[PR_origin][0],
    //     bulletData[PR_origin][1],
    //     bulletData[PR_origin][2],
    //     bulletData[PR_hitPos][0],
    //     bulletData[PR_hitPos][1],
    //     bulletData[PR_hitPos][2],
    //     bulletData[PR_offsets][0],
    //     bulletData[PR_offsets][1],
    //     bulletData[PR_offsets][2],
    //     bulletData[PR_weaponId]
    // );
    // Log("bullet_sync.log", log);

    if(bulletData[PR_offsets][2] == 0.50)
    {
        AntiGiveDMG[playerid]++;
        if(AntiGiveDMG[playerid] >= 3) {
            new string[128];
            format(string,sizeof(string),"{AA3333}GTN-Warning{FFFF00}: %q (ID:%d) was auto-kicked, reason: GiveDMG.cs",GetPlayerNameExt(playerid),playerid);
            ABroadCast(COLOR_YELLOW, string, 3);
            Log("newanti.log", string);
            // string[0] = EOS;
            Kick(playerid);
        }
        return false;
    }
    return 1;
}

IPacket:UNOCCUPIED_SYNC(playerid, BitStream:bs)
{
    new unoccupiedData[PR_UnoccupiedSync];
 
    BS_IgnoreBits(bs, 8);
    BS_ReadUnoccupiedSync(bs, unoccupiedData);
 
    if(floatcmp(floatabs(unoccupiedData[PR_roll][0]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_roll][1]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_roll][2]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_direction][0]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_direction][1]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_direction][2]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_position][0]), 20000.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_position][1]), 20000.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_position][2]), 20000.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_angularVelocity][0]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_angularVelocity][1]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_angularVelocity][2]), 1.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_velocity][0]), 100.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_velocity][1]), 100.00000) == 1
        || floatcmp(floatabs(unoccupiedData[PR_velocity][2]), 100.00000) == 1
    ) {
        return false;
    }

    return true;
}