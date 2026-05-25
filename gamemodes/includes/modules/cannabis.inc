#if defined _modules_cannabis_included
    #endinput
#endif
#define _modules_cannabis_included

#include <YSI\y_hooks>

// =============================================================================
// CONSTANTS
// =============================================================================
#define MAX_CANNABIS_PLANTS         25
#define CANNABIS_RESPAWN_TIME       1800    // 30 phút (giây)
#define CANNABIS_ITEM_RAW           51      // Cần sa nguyên chất
#define CANNABIS_ITEM_ZIP           52      // Túi zip cần sa
#define CANNABIS_SELL_PRICE         800     // $/túi zip
#define CANNABIS_NPC_SKIN           116     // Skin NPC thu mua
#define CANNABIS_PROCESS_TIME       5       // Giây chế biến
#define CANNABIS_HARVEST_TIME       5       // Giây hái

// =============================================================================
// PLANT LOCATIONS (25 tọa độ cây cần sa)
// =============================================================================
new Float:CannabisPlantPos[MAX_CANNABIS_PLANTS][3] = {
    {-1329.3389, -2212.6155, 25.7908},
    {-1374.4536, -2209.4580, 26.8476},
    {-1407.8932, -2179.1599, 19.4489},
    {-1392.7179, -2223.1316, 30.4841},
    {-1398.5044, -2257.0691, 38.2427},
    {-1353.4897, -2303.4253, 39.3224},
    {-1244.4923, -2190.7664, 30.1444},
    {-1228.1880, -2209.5581, 29.7414},
    {-1236.5109, -2222.7354, 30.1598},
    {-1316.5753, -2295.4976, 36.4713},
    {-1286.1594, -2344.3101, 30.1242},
    {-1326.5574, -2358.8281, 34.4770},
    {-1421.6877, -2344.6863, 27.6375},
    {-1481.6563, -2343.4661, 9.6581},
    {-1453.8947, -2242.9263, 19.9825},
    {-1441.0206, -2224.7051, 21.0023},
    {-1380.1781, -2124.4624, 27.3289},
    {-1247.2299, -2154.3896, 29.3370},
    {-1259.5188, -2158.5144, 29.6059},
    {-1335.6152, -2118.0059, 29.6349},
    {-1327.5358, -2050.2329, 13.1759},
    {-1298.2048, -2032.5225, 15.0775},
    {-1264.9274, -2148.8906, 27.7766},
    {-1254.0526, -2215.7852, 29.4008},
    {-1279.5355, -2350.1396, 28.0290}
};

// =============================================================================
// STATE ARRAYS
// =============================================================================
new CannabisPlantObj[MAX_CANNABIS_PLANTS];
new bool:CannabisPlantAlive[MAX_CANNABIS_PLANTS];
new CannabisPlantTimer[MAX_CANNABIS_PLANTS];

// Khu chế biến
#define CANNABIS_PROCESS_X  -1105.5685
#define CANNABIS_PROCESS_Y  -1657.4761
#define CANNABIS_PROCESS_Z  76.3672

// NPC thu mua
#define CANNABIS_NPC_X      -2204.5874
#define CANNABIS_NPC_Y      961.0796
#define CANNABIS_NPC_Z      80.0000
#define CANNABIS_NPC_A      178.5543

// Checkpoint khu vực cần sa (dùng cho /map)
#define CANNABIS_AREA_X     -1333.2675
#define CANNABIS_AREA_Y     -2161.7058
#define CANNABIS_AREA_Z     22.8201

new Actor:CannabisNPC;
new Text3D:CannabisProcessLabel;
new Text3D:CannabisNPCLabel;

// =============================================================================
// INITIALIZATION
// =============================================================================
hook OnGameModeInit()
{
    // Spawn 25 cây cần sa
    for(new i = 0; i < MAX_CANNABIS_PLANTS; i++)
    {
        CannabisPlantObj[i] = CreateDynamicObject(19473, CannabisPlantPos[i][0], CannabisPlantPos[i][1], CannabisPlantPos[i][2] - 1.0, 0.0, 0.0, 0.0);
        CannabisPlantAlive[i] = true;
        CannabisPlantTimer[i] = 0;
    }

    // 3D Label khu chế biến
    CannabisProcessLabel = CreateDynamic3DTextLabel("{FF6347}Khu che bien can sa\n{FFFFFF}/chebiencansa", COLOR_YELLOW, CANNABIS_PROCESS_X, CANNABIS_PROCESS_Y, CANNABIS_PROCESS_Z, 10.0);

    // NPC thu mua
    CannabisNPC = CreateActor(CANNABIS_NPC_SKIN, CANNABIS_NPC_X, CANNABIS_NPC_Y, CANNABIS_NPC_Z, CANNABIS_NPC_A);
    CannabisNPCLabel = CreateDynamic3DTextLabel("{FF6347}Nguoi thu mua can sa\n{FFFFFF}/bancansa", COLOR_YELLOW, CANNABIS_NPC_X, CANNABIS_NPC_Y, CANNABIS_NPC_Z + 1.0, 10.0);

    printf("[Cannabis] Loaded %d plants, 1 processing point, 1 NPC buyer.", MAX_CANNABIS_PLANTS);
    return 1;
}

// =============================================================================
// HELPER: Tìm item trong balo
// =============================================================================
stock Cannabis_FindItem(playerid, itemid)
{
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] == itemid)
            return i;
    }
    return -1;
}

stock Cannabis_CountItem(playerid, itemid)
{
    new count = 0;
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] == itemid)
            count += CharacterInfo[playerid][0][cb_ItemAmount][i];
    }
    return count;
}

stock Cannabis_RemoveItem(playerid, itemid, amount)
{
    new remaining = amount;
    for(new i = 0; i < MAX_PLAYER_CB_ITEM && remaining > 0; i++)
    {
        if(CharacterInfo[playerid][0][cb_ItemID][i] == itemid)
        {
            if(CharacterInfo[playerid][0][cb_ItemAmount][i] >= remaining)
            {
                CharacterInfo[playerid][0][cb_ItemAmount][i] -= remaining;
                if(CharacterInfo[playerid][0][cb_ItemAmount][i] == 0)
                {
                    CharacterInfo[playerid][0][cb_ItemID][i] = INVALID_OBJECT_ID;
                    CharacterInfo[playerid][0][cb_ItemWeight][i] = 0.0;
                    CharacterInfo[playerid][0][cb_ItemDurability][i] = 0;
                }
                remaining = 0;
            }
            else
            {
                remaining -= CharacterInfo[playerid][0][cb_ItemAmount][i];
                CharacterInfo[playerid][0][cb_ItemID][i] = INVALID_OBJECT_ID;
                CharacterInfo[playerid][0][cb_ItemAmount][i] = 0;
                CharacterInfo[playerid][0][cb_ItemWeight][i] = 0.0;
                CharacterInfo[playerid][0][cb_ItemDurability][i] = 0;
            }
        }
    }
    return (remaining == 0);
}

// =============================================================================
// RESPAWN TIMER
// =============================================================================
forward Cannabis_RespawnPlant(plantid);
public Cannabis_RespawnPlant(plantid)
{
    if(plantid < 0 || plantid >= MAX_CANNABIS_PLANTS) return 0;

    CannabisPlantObj[plantid] = CreateDynamicObject(19473, CannabisPlantPos[plantid][0], CannabisPlantPos[plantid][1], CannabisPlantPos[plantid][2] - 1.0, 0.0, 0.0, 0.0);
    CannabisPlantAlive[plantid] = true;
    CannabisPlantTimer[plantid] = 0;
    return 1;
}

// =============================================================================
// COMMAND: /haican
// =============================================================================
CMD:haican(playerid, params[])
{
    if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerTied[playerid] != 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay bay gio!");

    if(GetPVarType(playerid, "Cannabis_Harvesting"))
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang thu hoach roi!");

    // Tìm cây gần nhất
    new closestPlant = -1;
    new Float:closestDist = 5.0;

    for(new i = 0; i < MAX_CANNABIS_PLANTS; i++)
    {
        if(!CannabisPlantAlive[i]) continue;
        new Float:dist = GetPlayerDistanceFromPoint(playerid, CannabisPlantPos[i][0], CannabisPlantPos[i][1], CannabisPlantPos[i][2]);
        if(dist < closestDist)
        {
            closestDist = dist;
            closestPlant = i;
        }
    }

    if(closestPlant == -1)
        return SendClientMessageEx(playerid, COLOR_GREY, "Khong co cay can sa nao gan day.");

    // Bắt đầu hái
    SetPVarInt(playerid, "Cannabis_Harvesting", 1);
    SetPVarInt(playerid, "Cannabis_PlantID", closestPlant);
    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
    SendClientMessageEx(playerid, COLOR_YELLOW, "* Ban dang thu hoach can sa... Vui long cho.");

    SetTimerEx("Cannabis_HarvestDone", CANNABIS_HARVEST_TIME * 1000, false, "ii", playerid, closestPlant);
    return 1;
}

forward Cannabis_HarvestDone(playerid, plantid);
public Cannabis_HarvestDone(playerid, plantid)
{
    DeletePVar(playerid, "Cannabis_Harvesting");
    TogglePlayerControllable(playerid, 1);
    ClearAnimationsEx(playerid);

    if(!IsPlayerConnected(playerid)) return 0;
    if(plantid < 0 || plantid >= MAX_CANNABIS_PLANTS) return 0;
    if(!CannabisPlantAlive[plantid]) return 0;

    // Kiểm tra player còn gần cây không
    new Float:dist = GetPlayerDistanceFromPoint(playerid, CannabisPlantPos[plantid][0], CannabisPlantPos[plantid][1], CannabisPlantPos[plantid][2]);
    if(dist > 8.0)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Ban di qua xa, thu hoach that bai.");
        return 0;
    }

    // RNG
    new rand = random(100);
    new amount = 1;
    new szMsg[128];

    if(rand < 70) // 70% - Bình thường
    {
        amount = 1;
        format(szMsg, sizeof(szMsg), "* Ban da thu hoach duoc %d khoi can sa nguyen chat.", amount);
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, szMsg);
    }
    else if(rand < 90) // 20% - Trúng mánh
    {
        amount = 2;
        format(szMsg, sizeof(szMsg), "* Khuc nay cay tot vai, chuc mung! Ban thu hoach duoc %d khoi can sa!", amount);
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, szMsg);
    }
    else // 10% - Báo thủ: rắn cắn
    {
        SendClientMessageEx(playerid, COLOR_RED, "A du! Ban bi ran can trung! Mat 20 HP!");
        new Float:hp;
        GetHealth(playerid, hp);
        SetHealth(playerid, hp - 20.0);
        amount = 0;
    }

    // Thêm item vào balo
    if(amount > 0)
    {
        GivePlayerItem(playerid, CANNABIS_ITEM_RAW, amount);
    }

    // Xóa cây, bắt đầu respawn
    DestroyDynamicObject(CannabisPlantObj[plantid]);
    CannabisPlantAlive[plantid] = false;
    CannabisPlantTimer[plantid] = SetTimerEx("Cannabis_RespawnPlant", CANNABIS_RESPAWN_TIME * 1000, false, "i", plantid);

    return 1;
}

// =============================================================================
// COMMAND: /chebiencansa
// =============================================================================
CMD:chebiencansa(playerid, params[])
{
    if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerTied[playerid] != 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay bay gio!");

    if(GetPVarType(playerid, "Cannabis_Processing"))
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang che bien roi!");

    // Kiểm tra vị trí khu chế biến
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, CANNABIS_PROCESS_X, CANNABIS_PROCESS_Y, CANNABIS_PROCESS_Z))
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan khu che bien can sa!");

    // Kiểm tra có cần sa thô không
    new rawCount = Cannabis_CountItem(playerid, CANNABIS_ITEM_RAW);
    if(rawCount < 1)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co can sa nguyen chat de che bien!");

    // Bắt đầu chế biến
    SetPVarInt(playerid, "Cannabis_Processing", 1);
    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BD_FIRE", "BD_FIRE1", 4.0, 1, 0, 0, 0, 0, 1);
    SendClientMessageEx(playerid, COLOR_YELLOW, "* Ban dang che bien can sa... Vui long cho.");

    SetTimerEx("Cannabis_ProcessDone", CANNABIS_PROCESS_TIME * 1000, false, "i", playerid);
    return 1;
}

forward Cannabis_ProcessDone(playerid);
public Cannabis_ProcessDone(playerid)
{
    DeletePVar(playerid, "Cannabis_Processing");
    TogglePlayerControllable(playerid, 1);
    ClearAnimationsEx(playerid);

    if(!IsPlayerConnected(playerid)) return 0;

    // Kiểm tra còn ở khu chế biến không
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, CANNABIS_PROCESS_X, CANNABIS_PROCESS_Y, CANNABIS_PROCESS_Z))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Ban di qua xa, che bien that bai.");
        return 0;
    }

    // Kiểm tra lại có cần sa thô không
    new rawCount = Cannabis_CountItem(playerid, CANNABIS_ITEM_RAW);
    if(rawCount < 1)
    {
        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong con can sa nguyen chat.");
        return 0;
    }

    // Xóa 1 cần sa thô
    Cannabis_RemoveItem(playerid, CANNABIS_ITEM_RAW, 1);

    // RNG: random 1-5 túi zip
    new zipAmount = 1 + random(5); // 1-5
    new szMsg[128];

    if(zipAmount == 1)
    {
        SendClientMessageEx(playerid, COLOR_RED, "Tay ban bi run a? Thai vun bet nhe, chi vot vat duoc 1 tui Zip.");
    }
    else if(zipAmount >= 4)
    {
        format(szMsg, sizeof(szMsg), "Tay che bien cung lam! Ban thai duoc %d tui Zip can sa!", zipAmount);
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, szMsg);
    }
    else
    {
        format(szMsg, sizeof(szMsg), "* Ban che bien thanh cong duoc %d tui Zip can sa.", zipAmount);
        SendClientMessageEx(playerid, COLOR_YELLOW, szMsg);
    }

    // Thêm túi zip vào balo
    GivePlayerItem(playerid, CANNABIS_ITEM_ZIP, zipAmount);

    return 1;
}

// =============================================================================
// COMMAND: /bancansa
// =============================================================================
CMD:bancansa(playerid, params[])
{
    if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerTied[playerid] != 0)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay ngay bay gio!");

    // Kiểm tra gần NPC
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, CANNABIS_NPC_X, CANNABIS_NPC_Y, CANNABIS_NPC_Z))
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan nguoi thu mua can sa!");

    // Kiểm tra có túi zip không
    new zipCount = Cannabis_CountItem(playerid, CANNABIS_ITEM_ZIP);
    if(zipCount < 1)
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co tui zip can sa nao de ban!");

    // Hiển dialog chọn số lượng
    new szDialog[512];
    format(szDialog, sizeof(szDialog),
        "{FFFFFF}Ban co {F5CB42}%d {FFFFFF}tui Zip can sa.\n\n\
        Gia ban: {F5CB42}$%s {FFFFFF}/tui\n\
        Nhap so luong muon ban:",
        zipCount, number_format(CANNABIS_SELL_PRICE));

    ShowPlayerDialogEx(playerid, DIALOG_CANNABIS_SELL, DIALOG_STYLE_INPUT, "Ban can sa", szDialog, "Ban", "Huy");
    return 1;
}

// =============================================================================
// DIALOG CALLBACK: Bán cần sa
// =============================================================================
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_CANNABIS_SELL)
    {
        if(!response) return 1;

        new amount = strval(inputtext);
        if(amount < 1)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "So luong khong hop le!");
            return 1;
        }

        new zipCount = Cannabis_CountItem(playerid, CANNABIS_ITEM_ZIP);
        if(amount > zipCount)
        {
            SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tui zip can sa!");
            return 1;
        }

        // Kiểm tra lại gần NPC
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, CANNABIS_NPC_X, CANNABIS_NPC_Y, CANNABIS_NPC_Z))
            return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan nguoi thu mua can sa!");

        // Xóa túi zip
        Cannabis_RemoveItem(playerid, CANNABIS_ITEM_ZIP, amount);

        // Tính tiền
        new totalMoney = amount * CANNABIS_SELL_PRICE;

        // Thêm tiền bẩn
        PlayerInfo[playerid][pDirtyMoney] += totalMoney;

        // Message cho player
        new szMsg[128];
        format(szMsg, sizeof(szMsg), "* Ban da ban %d tui Zip can sa va nhan duoc $%s tien ban.", amount, number_format(totalMoney));
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, szMsg);

        // Gửi cảnh báo cho toàn bộ LAW faction
        foreach(new i: Player)
        {
            if(IsACop(i))
            {
                format(szMsg, sizeof(szMsg), "[CAMERA] Vua phat hien giao dich chat cam cua %s, cac don vi luu y doi tuong nay.", GetPlayerNameEx(playerid));
                SendClientMessageEx(i, COLOR_LIGHTRED, szMsg);
            }
        }

        // Log
        new logStr[256], year, month, day, hour, minute, second;
        getdate(year, month, day);
        gettime(hour, minute, second);
        format(logStr, sizeof(logStr), "[%04d-%02d-%02d %02d:%02d:%02d] %s da ban %d tui zip can sa, nhan $%s tien ban (DirtyMoney: $%s)",
            year, month, day, hour, minute, second, GetPlayerNameEx(playerid), amount, number_format(totalMoney), number_format(PlayerInfo[playerid][pDirtyMoney]));
        Log("logs/Cannabis.log", logStr);
    }
    return 0;
}
