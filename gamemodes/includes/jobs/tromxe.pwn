#include <YSI\y_hooks>

// Global arrays for lockpick state tracking
new LockPickTargetOwner[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new LockPickTargetSlot[MAX_PLAYERS] = {-1, ...};
new LockPickVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new LockPickPinCode[MAX_PLAYERS];
new LockPickAttempts[MAX_PLAYERS];
new LockPickPrevGuesses[MAX_PLAYERS][6];
new LockPickGuessCount[MAX_PLAYERS];

// Thief current session stolen vehicle tracking
new StolenVehOwner[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new StolenVehSlot[MAX_PLAYERS] = {-1, ...};
new StolenVehID[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

// Player's Dialog selection trackers for ransom list
new PlayerRansomVehSlot[MAX_PLAYERS][MAX_PLAYERVEHICLES];
new PlayerRansomVehCount[MAX_PLAYERS];

// Helper: Check if player has Picklock in their backpack
stock HasPicklock(playerid)
{
    for(new idx = 0; idx < MAX_PLAYER_CB_ITEM; idx++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][idx] == 53 && CharacterInfo[playerid][0][cb_ItemAmount][idx] > 0)
        {
            return idx;
        }
    }
    return -1;
}

// Helper: Consume 1 Picklock from player's backpack
stock ConsumePicklock(playerid)
{
    new slot = HasPicklock(playerid);
    if(slot != -1)
    {
        CharacterInfo[playerid][0][cb_ItemAmount][slot]--;
        if(CharacterInfo[playerid][0][cb_ItemAmount][slot] <= 0)
        {
            CharacterInfo[playerid][0][cb_ItemID][slot] = INVALID_OBJECT_ID;
            CharacterInfo[playerid][0][cb_ItemAmount][slot] = 0;
            CharacterInfo[playerid][0][cb_ItemWeight][slot] = 0.0;
            CharacterInfo[playerid][0][cb_ItemDurability][slot] = 0;
        }
        Inventory_SetPost(playerid, Guide_ReadPost[playerid]);
        return 1;
    }
    return 0;
}

// Setup NPC and Checkpoints
hook OnGameModeInit()
{
    // NPC Six Que at coordinates
    CreateDynamicActor(3, -2211.9250, 611.0851, 35.1641, 76.1080, 1, 100.0, -1, -1, -1);
    CreateDynamic3DTextLabel("{33CCFF}Six Que - Chuoc Xe Stolen\n{FFFFFF}Nhan {FFFF00}H{FFFFFF} hoac {FFFF00}/chuocxe", COLOR_YELLOW, -2211.9250, 611.0851, 35.1641 + 1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 15.0);

    // Disposal / Phi tang point
    CreateDynamic3DTextLabel("{FF0000}Diem Phi Tang Xe Trom\n{FFFFFF}Go {FFFF00}/banxetrom {FFFFFF}khi ngoi tren xe", COLOR_YELLOW, -2107.4202, -2402.3198, 31.3793 + 1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 15.0);
    return 1;
}

// Clean target values on disconnect
hook OnPlayerConnect(playerid)
{
    LockPickTargetOwner[playerid] = INVALID_PLAYER_ID;
    LockPickTargetSlot[playerid] = -1;
    LockPickVehicle[playerid] = INVALID_VEHICLE_ID;

    StolenVehOwner[playerid] = INVALID_PLAYER_ID;
    StolenVehSlot[playerid] = -1;
    StolenVehID[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

// Key detection for NPC Six Que
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_CTRL_BACK) && !(oldkeys & KEY_CTRL_BACK))
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, -2211.9250, 611.0851, 35.1641))
        {
            return callcmd::chuocxe(playerid, "");
        }
    }
    return 1;
}

// Command: Craft Picklock
CMD:chepicklock(playerid, params[])
{
    if(PlayerInfo[playerid][pMats] < 2000)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong du Vat lieu (yeu cau 2,000 Mats) de che tao Picklock!");
    }

    new success = 0;
    SetPlayerItem(playerid, 53, 1, success);
    if(success == 1)
    {
        PlayerInfo[playerid][pMats] -= 2000;
        SendClientMessageEx(playerid, COLOR_GREEN, "[CHE TAO]: Che tao thanh cong 1x Picklock trong /balo (-2,000 Mats).");
        PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);
    }
    return 1;
}

// Command: Picklock / Tromxe
CMD:tromxe(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai xuong xe de thuc hien be khoa!");
    }

    if(HasPicklock(playerid) == -1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co dung cu Picklock trong /balo!");
    }

    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new closestveh = GetClosestCar(playerid, INVALID_VEHICLE_ID, 4.0);
    if(closestveh == INVALID_VEHICLE_ID)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Khong tim thay phuong tien nao o gan ban (pham vi 4.0m)!");
    }

    if(IsVIPcar(closestveh))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Day la xe VIP, ban khong the be khoa phuong tien nay!");
    }

    new target_owner = INVALID_PLAYER_ID;
    new target_slot = -1;

    // Find the player who owns this vehicle
    foreach(new target_id : Player)
    {
        new slot = GetPlayerVehicle(target_id, closestveh);
        if(slot != -1)
        {
            target_owner = target_id;
            target_slot = slot;
            break;
        }
    }

    if(target_owner == INVALID_PLAYER_ID || target_slot == -1)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Phuong tien nay khong phai xe so huu cua nguoi choi khac (Xe Faction/Gang/Public/Job)!");
    }

    if(target_owner == playerid)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the tu be khoa phuong tien cua chinh minh!");
    }

    // Check lock status
    if(PlayerVehicleInfo[target_owner][target_slot][pvLock] == 0 || PlayerVehicleInfo[target_owner][target_slot][pvLocked] == 0)
    {
        // Immediately unlocked & successful!
        PlayerVehicleInfo[target_owner][target_slot][pvLocked] = 0;
        UnLockPlayerVehicle(target_owner, closestveh, PlayerVehicleInfo[target_owner][target_slot][pvLock]);
        
        StolenVehOwner[playerid] = target_owner;
        StolenVehSlot[playerid] = target_slot;
        StolenVehID[playerid] = closestveh;
        
        SetPlayerCheckpoint(playerid, -2107.4202, -2402.3198, 31.3793, 5.0);
        SendClientMessageEx(playerid, COLOR_GREEN, "[BE KHOA]: Phuong tien khong co khoa hoac dang mo! Bieu tuong phi tang da hien thi tren ban do.");
        return 1;
    }

    if(PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLocked])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Phuong tien nay dang bi nguoi khac be khoa!");
    }

    // Try consuming picklock
    if(!ConsumePicklock(playerid))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co Picklock trong balo!");
    }

    // Initialize Lockpick game
    PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLocked] = 1;
    PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLockedBy] = playerid;

    LockPickTargetOwner[playerid] = target_owner;
    LockPickTargetSlot[playerid] = target_slot;
    LockPickVehicle[playerid] = closestveh;
    LockPickAttempts[playerid] = 6;
    LockPickPinCode[playerid] = 100 + random(900); // Random 100 to 999
    LockPickGuessCount[playerid] = 0;

    // Send law alert
    new zone[MAX_ZONE_NAME], szMsg[144];
    Get3DZone(px, py, pz, zone, sizeof(zone));
    format(szMsg, sizeof(szMsg), "[Camera] Phat hien phuong tien cua %s dang bi be khoa tai khu vuc %s.", GetPlayerNameEx(target_owner), zone);
    SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTRED, szMsg);

    // Apply crouch animation
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0);

    // Show PIN cracking dialog
    new dialog_msg[512];
    format(dialog_msg, sizeof(dialog_msg),
        "{FFFFFF}[KHOA XE] Ma PIN bao mat cua phuong tien dang duoc ma hoa.\n\
        Hay do mat ma co gia tri trong khoang {FFFF00}100 den 999{FFFFFF}.\n\n\
        So luot do con lai: {FF0000}%d{FFFFFF}\n\n\
        Nhap mat ma du doan:",
        LockPickAttempts[playerid]);

    ShowPlayerDialogEx(playerid, DIALOG_LOCKPICK_GAME, DIALOG_STYLE_INPUT, "{33CCFF}Be Khoa Xe - Do Ma PIN", dialog_msg, "Gui", "Huy");
    return 1;
}

// Dialog input handler for lockpick game
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_LOCKPICK_GAME)
    {
        new target_owner = LockPickTargetOwner[playerid];
        new target_slot = LockPickTargetSlot[playerid];
        new vehid = LockPickVehicle[playerid];

        if(target_owner == INVALID_PLAYER_ID || target_slot == -1 || vehid == INVALID_VEHICLE_ID)
        {
            return 1;
        }

        if(!response)
        {
            // Cancel lockpicking
            PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLocked] = 0;
            PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
            
            LockPickTargetOwner[playerid] = INVALID_PLAYER_ID;
            LockPickTargetSlot[playerid] = -1;
            LockPickVehicle[playerid] = INVALID_VEHICLE_ID;

            ClearAnimationsEx(playerid);
            SendClientMessageEx(playerid, COLOR_GREY, "[BE KHOA]: Ban da huy bo viec be khoa.");
            return 1;
        }

        if(!IsNumeric(inputtext) || strval(inputtext) < 100 || strval(inputtext) > 999)
        {
            new dialog_msg[512];
            format(dialog_msg, sizeof(dialog_msg),
                "{FF0000}LOI: Ma PIN phai la so nguyen tu 100 den 999!{FFFFFF}\n\n\
                So luot do con lai: {FF0000}%d{FFFFFF}\n\n\
                Nhap lai mat ma du doan:",
                LockPickAttempts[playerid]);
            ShowPlayerDialogEx(playerid, DIALOG_LOCKPICK_GAME, DIALOG_STYLE_INPUT, "{33CCFF}Be Khoa Xe - Do Ma PIN", dialog_msg, "Gui", "Huy");
            return 1;
        }

        new guess = strval(inputtext);
        LockPickPrevGuesses[playerid][LockPickGuessCount[playerid]++] = guess;
        LockPickAttempts[playerid]--;

        // Success condition
        if(guess == LockPickPinCode[playerid])
        {
            PlayerVehicleInfo[target_owner][target_slot][pvLocked] = 0;
            UnLockPlayerVehicle(target_owner, vehid, PlayerVehicleInfo[target_owner][target_slot][pvLock]);
            
            PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLocked] = 0;
            PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;

            StolenVehOwner[playerid] = target_owner;
            StolenVehSlot[playerid] = target_slot;
            StolenVehID[playerid] = vehid;

            LockPickTargetOwner[playerid] = INVALID_PLAYER_ID;
            LockPickTargetSlot[playerid] = -1;
            LockPickVehicle[playerid] = INVALID_VEHICLE_ID;

            ClearAnimationsEx(playerid);
            SendClientMessageEx(playerid, COLOR_GREEN, "[BE KHOA]: Be khoa thanh cong! Diem phi tang da duoc danh dau tren Minimap.");
            SetPlayerCheckpoint(playerid, -2107.4202, -2402.3198, 31.3793, 5.0);
            return 1;
        }

        // Out of attempts condition (Failure)
        if(LockPickAttempts[playerid] <= 0)
        {
            PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLocked] = 0;
            PlayerVehicleInfo[target_owner][target_slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;

            LockPickTargetOwner[playerid] = INVALID_PLAYER_ID;
            LockPickTargetSlot[playerid] = -1;
            LockPickVehicle[playerid] = INVALID_VEHICLE_ID;

            ClearAnimationsEx(playerid);
            SendClientMessageEx(playerid, COLOR_RED, "[BE KHOA]: Khoa an toan da tu dong khoa chat! Picklock cua ban da bi gay.");

            // Shock probability (30%)
            if(random(100) < 30)
            {
                new Float:hp;
                GetHealth(playerid, hp);
                SetHealth(playerid, hp - 25.0);
                SendClientMessageEx(playerid, COLOR_LIGHTRED, "[CANH BAO] Ban bi giat dien boi thiet bi chong trom (-25 HP)!");
                PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);

                // Small explosion effect for electric spark
                new Float:ax, Float:ay, Float:az;
                GetPlayerPos(playerid, ax, ay, az);
                CreateExplosion(ax, ay, az, 12, 2.0); // 12 represents small spark explosion
            }
            return 1;
        }

        // Next guess dialogue building
        new hint[64];
        if(guess < LockPickPinCode[playerid])
        {
            format(hint, sizeof(hint), "Goi y: Ma PIN can tim > %d", guess);
        }
        else
        {
            format(hint, sizeof(hint), "Goi y: Ma PIN can tim < %d", guess);
        }

        new history[256];
        format(history, sizeof(history), "{BBBBBB}Lich su do: ");
        for(new g = 0; g < LockPickGuessCount[playerid]; g++)
        {
            format(history, sizeof(history), "%s%d (%s)  ", history, LockPickPrevGuesses[playerid][g], (LockPickPrevGuesses[playerid][g] < LockPickPinCode[playerid]) ? (">") : ("<"));
        }

        new dialog_msg[512];
        format(dialog_msg, sizeof(dialog_msg),
            "{FFFFFF}[KHOA XE] Mat ma vua nhap khong chinh xac!\n\n\
            {FFFF00}%s{FFFFFF}\n\
            %s{FFFFFF}\n\n\
            So luot do con lai: {FF0000}%d{FFFFFF}\n\n\
            Nhap lai mat ma du doan:",
            hint, history, LockPickAttempts[playerid]);

        ShowPlayerDialogEx(playerid, DIALOG_LOCKPICK_GAME, DIALOG_STYLE_INPUT, "{33CCFF}Be Khoa Xe - Do Ma PIN", dialog_msg, "Gui", "Huy");
        return 1;
    }

    if(dialogid == DIALOG_VEHICLE_RANSOM)
    {
        if(!response) return 1;

        new index = listitem;
        if(index < 0 || index >= PlayerRansomVehCount[playerid])
        {
            return 1;
        }

        new slot = PlayerRansomVehSlot[playerid][index];
        new cost = 25000 + (PlayerVehicleInfo[playerid][slot][pvPrice] / 10);
        if(cost > 60000) cost = 60000;

        if(GetPlayerCash(playerid) < cost)
        {
            new errStr[128];
            format(errStr, sizeof(errStr), "Ban khong co du $%s de chuoc chiec xe nay!", number_format(cost));
            return SendClientMessageEx(playerid, COLOR_GREY, errStr);
        }

        // Deduct money and reset stolen status
        GivePlayerCash(playerid, -cost);
        PlayerVehicleInfo[playerid][slot][pvStolen] = 0;
        g_mysql_SaveVehicle(playerid, slot);

        new successStr[256];
        format(successStr, sizeof(successStr), "[CHƯƠC XE]: Ban da thanh toan $%s de chuoc lai chiec %s. Hay go /chinhxe de lay xe.", number_format(cost), VehicleName[PlayerVehicleInfo[playerid][slot][pvModelId] - 400]);
        SendClientMessageEx(playerid, COLOR_GREEN, successStr);
        PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
        return 1;
    }
    return 0;
}

// Command: Sell stolen vehicle
CMD:banxetrom(playerid, params[])
{
    new Float:px, Float:py, Float:pz;
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai lai xe bi trom den day!");
    }

    new vehid = GetPlayerVehicleID(playerid);
    if(vehid != StolenVehID[playerid])
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Phuong tien nay khong phai do ban be khoa!");
    }

    if(!IsPlayerInRangeOfPoint(playerid, 8.0, -2107.4202, -2402.3198, 31.3793))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai lai xe den dung Diem Phi Tang de tieu thu!");
    }

    new target_owner = StolenVehOwner[playerid];
    new target_slot = StolenVehSlot[playerid];

    if(!IsPlayerConnected(target_owner))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Chu so huu phuong tien da offline, khong the tieu thu luc nay.");
    }

    // Calculate dynamic reward
    new baseReward = 15000 + (PlayerVehicleInfo[target_owner][target_slot][pvPrice] / 20);
    if(baseReward > 30000) baseReward = 30000;
    new matsReward = 100 + random(201); // 100 to 300 mats

    // Give rewards
    GivePlayerCash(playerid, baseReward);
    PlayerInfo[playerid][pMats] += matsReward;

    // Set stolen state & despawn vehicle
    PlayerVehicleInfo[target_owner][target_slot][pvStolen] = 1;
    PlayerVehicleInfo[target_owner][target_slot][pvSpawned] = 0;
    
    // Attempt desync safety
    if(IsValidDynamicArea(iVehEnterAreaID[vehid])) DestroyDynamicArea(iVehEnterAreaID[vehid]);
    DestroyVehicle(vehid);
    PlayerVehicleInfo[target_owner][target_slot][pvId] = INVALID_PLAYER_VEHICLE_ID;
    
    // Save state to SQL
    g_mysql_SaveVehicle(target_owner, target_slot);

    // Notify victim
    new notifyMsg[144];
    format(notifyMsg, sizeof(notifyMsg), "[CANH BAO]: Chiec xe %s cua ban da bi tieu thu. Hay toi NPC Six Que de chuoc lai xe.", VehicleName[PlayerVehicleInfo[target_owner][target_slot][pvModelId] - 400]);
    SendClientMessageEx(target_owner, COLOR_LIGHTRED, notifyMsg);

    // Alert police
    new zone[MAX_ZONE_NAME], szMsg[144];
    GetPlayerPos(playerid, px, py, pz);
    Get3DZone(px, py, pz, zone, sizeof(zone));
    format(szMsg, sizeof(szMsg), "[Camera] Phat hien xe cua %s da bi tieu thu tai %s. Doi tuong kha nghi la %s.", GetPlayerNameEx(target_owner), zone, GetPlayerNameEx(playerid));
    SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTRED, szMsg);

    // Notify thief
    new thiefMsg[256];
    format(thiefMsg, sizeof(thiefMsg), "[TIEU THU]: Tieu thu xe trom thanh cong! Ban nhan duoc $%s va %d Vat lieu.", number_format(baseReward), matsReward);
    SendClientMessageEx(playerid, COLOR_GREEN, thiefMsg);
    PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);

    // Clear thief session stolen tracker
    DisablePlayerCheckpoint(playerid);
    StolenVehOwner[playerid] = INVALID_PLAYER_ID;
    StolenVehSlot[playerid] = -1;
    StolenVehID[playerid] = INVALID_VEHICLE_ID;

    return 1;
}

// Command: Ransom stolen vehicles
CMD:chuocxe(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 4.0, -2211.9250, 611.0851, 35.1641))
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai dung gan NPC Six Que de chuoc xe!");
    }

    new szList[2048], count = 0;
    szList[0] = 0;
    format(szList, sizeof(szList), "Phuong tien\tGia chuoc xe\n");

    for(new slot_idx = 0; slot_idx < GetPlayerVehicleSlots(playerid); slot_idx++)
    {
        if(PlayerVehicleInfo[playerid][slot_idx][pvModelId] >= 400 && PlayerVehicleInfo[playerid][slot_idx][pvStolen] == 1)
        {
            new cost = 25000 + (PlayerVehicleInfo[playerid][slot_idx][pvPrice] / 10);
            if(cost > 60000) cost = 60000;

            format(szList, sizeof(szList), "%s%s\t{57FF57}$%s{FFFFFF}\n", szList, VehicleName[PlayerVehicleInfo[playerid][slot_idx][pvModelId] - 400], number_format(cost));
            PlayerRansomVehSlot[playerid][count] = slot_idx;
            count++;
        }
    }

    PlayerRansomVehCount[playerid] = count;

    if(count == 0)
    {
        return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Six Que - Chuoc Xe", "{FFFFFF}Hien tai ban khong co phuong tien nao dang bi danh cap!", "Dong", "");
    }

    ShowPlayerDialogEx(playerid, DIALOG_VEHICLE_RANSOM, DIALOG_STYLE_TABLIST_HEADERS, "Six Que - Chuoc Xe Bị Trom", szList, "Chuoc xe", "Huy");
    return 1;
}
