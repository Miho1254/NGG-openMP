#if defined _modules_afk_mining_included
    #endinput
#endif
#define _modules_afk_mining_included
#pragma warning disable 200
#include <YSI\y_hooks>

// Tùy chỉnh thông số
#define MAX_MINING_NODES 60
#define MAX_MINING_MACHINES_PER_PLAYER 3

#define MINING_NODE_MAX_HP 1000
#define MINING_NODE_RESPAWN_TIME 900 // 15 phút (giây)

#define MACHINE_NORMAL_ID 8 // Item ID máy đào thường
#define MACHINE_VIP_ID 9    // Item ID máy đào VIP

#define MACHINE_NORMAL_HP 300
#define MACHINE_VIP_HP 600

#define MACHINE_NORMAL_SPEED 10 // Đào 10 HP đá mỗi giây
#define MACHINE_VIP_SPEED 20    // Đào 20 HP đá mỗi giây

#define MACHINE_VIP_MAX_DURABILITY 10

// Enum và Biến
enum e_MiningNode {
    Float:mn_PosX,
    Float:mn_PosY,
    Float:mn_PosZ,
    Float:mn_Rot,
    mn_ObjectID,
    Text3D:mn_Text3D,
    mn_HP,
    mn_RespawnTime, // Timestamp khi nào respawn
    bool:mn_IsActive,
    mn_MachineOwner, // PlayerID cua may dao dang cam
    mn_MachineSlot   // Slot cua may dao
};

enum e_MiningMachine {
    bool:mm_IsActive,
    mm_Type, // 0 = thuong, 1 = VIP
    mm_NodeID, // dang cam tai mo da nao
    mm_ObjectID,
    Text3D:mm_Text3D,
    mm_HP,
    mm_Durability
};

new MiningNodes[MAX_MINING_NODES][e_MiningNode];
new MiningMachines[MAX_PLAYERS][MAX_MINING_MACHINES_PER_PLAYER][e_MiningMachine];

new Float:MiningSpawnPoints[][4] = {
    {-1252.1819, -841.4357, 106.4100, 180.8114},
    {-1143.9645, -678.5795, 32.9566, 141.5117},
    {-1124.8250, -855.8016, 125.6799, 180.0737},
    {-1073.2748, -866.0548, 135.7455, 271.5326},
    {-1046.5233, -863.8691, 136.0742, 274.3561},
    {-990.7901, -859.8434, 120.6027, 273.0514},
    {-908.0709, -842.1669, 118.8227, 283.8056},
    {-891.1888, -831.6273, 144.8432, 358.7569},
    {-821.4482, -757.6113, 155.2154, 288.4765},
    {-707.7225, -811.1931, 149.8979, 239.1635},
    {-562.7147, -833.4121, 103.3813, 233.1882},
    {-666.6876, -770.3126, 87.0228, 48.4195},
    {-730.4816, -630.8339, 56.7407, 49.9419},
    {-708.8059, -492.0129, 28.4795, 305.9892},
    {-679.4416, -479.9998, 34.9664, 288.0655},
    {-615.4174, -451.0155, 30.2629, 310.1164},
    {-841.8046, -211.5020, 63.9415, 64.3886},
    {-914.0706, -79.8135, 51.8502, 344.1155},
    {-858.7735, 51.7727, 33.6278, 302.5129},
    {-645.6982, 35.5937, 54.5654, 272.7505},
    {-595.1505, 18.2549, 57.7934, 238.2074},
    {-538.7007, 184.8725, 12.9048, 346.5043},
    {-858.6132, 92.9062, 12.1485, 187.1326},
    {-588.3714, -719.0711, 41.2128, 79.5505},
    {-626.2073, -703.1497, 48.6986, 79.5505},
    {-678.1854, -646.2309, 46.1243, 117.6762},
    {-701.0962, -657.6690, 57.8132, 110.2896},
    {-594.2460, -706.0427, 40.6804, 228.2560},
    {-494.5994, -738.2549, 28.3477, 249.5457},
    {-480.4549, -763.4718, 29.8917, 200.9897},
    {-437.6166, -733.1912, 27.6656, 247.1544},
    {-426.0377, -751.6334, 29.5831, 198.6007},
    {-442.3247, -799.9621, 38.2044, 161.1248},
    {-473.7814, -802.5414, 55.3675, 78.1382},
    {-461.0758, -778.8642, 47.7153, 323.7559},
    {-468.1578, -765.3011, 50.5978, 30.6687},
    {-475.5629, -750.5121, 45.3760, 26.4325},
    {-590.4833, -671.4784, 30.5503, 69.6645},
    {-646.9966, -716.6503, 61.6412, 128.5383},
    {-641.0145, -750.3309, 67.6176, 168.6190},
    {-673.7835, -769.4530, 91.5925, 120.2813},
    {-623.1559, -818.0743, 89.9335, 240.6370},
    {-652.1639, -836.1534, 103.5965, 123.3243},
    {-579.4142, -804.7053, 93.1372, 68.0352},
    {-606.9255, -816.2709, 93.3296, 137.2282},
    {-631.4471, -825.0913, 94.8203, 107.5729},
    {-725.7526, -698.3486, 104.1104, 313.2206},
    {-640.2815, -564.0922, 30.6883, 12.0077},
    {-517.4841, -574.3001, 22.9998, 166.6037},
    {-974.5636, -212.8393, 48.8445, 310.0938},
    {-1164.4944, -558.8151, 31.2512, 209.4014},
    {-1714.7971, -865.0967, 76.9361, 63.8939},
    {-1786.7200, -986.1936, 67.0760, 300.6416},
    {-1778.1343, -946.6129, 71.8598, 348.0031},
    {-1765.3408, -891.7453, 76.5317, 326.1688},
    {-1828.9443, -933.2246, 48.8355, 171.9246},
    {-1850.2512, -694.5314, 31.9766, 52.4411}
};

new AFK_Timer;

// Helper: Tim item trong tui
stock AFK_HasItem(playerid, itemid) {
    for(new i = 0; i < MAX_PLAYER_CB_ITEM; i++) {
        if(CharacterInfo[playerid][0][cb_ItemID][i] == itemid && CharacterInfo[playerid][0][cb_ItemAmount][i] > 0) return i;
    }
    return -1;
}

// Helper: Xoa item khoi tui
stock AFK_RemoveItem(playerid, itemid, amount) {
    new slot = AFK_HasItem(playerid, itemid);
    if(slot != -1) {
        CharacterInfo[playerid][0][cb_ItemAmount][slot] -= amount;
        if(CharacterInfo[playerid][0][cb_ItemAmount][slot] <= 0) {
            RemovePlayerItem(playerid, slot);
        }
        return 1;
    }
    return 0;
}

stock UpdateNode3DText(nodeid) {
    if(!MiningNodes[nodeid][mn_IsActive]) {
        UpdateDynamic3DTextLabelText(MiningNodes[nodeid][mn_Text3D], 0xFF0000FF, "{FF0000}Mo Da Khoang San (Can Kiet){FFFFFF}\nDang phuc hoi...");
        return;
    }
    new str[128];
    format(str, sizeof(str), "{FFA500}Mo Da Khoang San{FFFFFF}\nHP: %d/%d\n/datmay de khai thac", MiningNodes[nodeid][mn_HP], MINING_NODE_MAX_HP);
    UpdateDynamic3DTextLabelText(MiningNodes[nodeid][mn_Text3D], 0xFFFFFFFF, str);
}

stock UpdateMachine3DText(playerid, slot) {
    if(!MiningMachines[playerid][slot][mm_IsActive]) return;
    new str[128], type_str[32];
    if(MiningMachines[playerid][slot][mm_Type] == 0) type_str = "Thuong";
    else type_str = "VIP";
    
    format(str, sizeof(str), "{00FFFF}[May Dao %s]{FFFFFF}\nChu: %s\nHP May: %d\nDang khai thac...", type_str, GetPlayerNameEx(playerid), MiningMachines[playerid][slot][mm_HP]);
    UpdateDynamic3DTextLabelText(MiningMachines[playerid][slot][mm_Text3D], 0xFFFFFFFF, str);
}

stock RemoveMachine(playerid, slot) {
    if(MiningMachines[playerid][slot][mm_IsActive]) {
        DestroyDynamicObject(MiningMachines[playerid][slot][mm_ObjectID]);
        DestroyDynamic3DTextLabel(MiningMachines[playerid][slot][mm_Text3D]);
        
        new nodeid = MiningMachines[playerid][slot][mm_NodeID];
        if(nodeid != -1 && MiningNodes[nodeid][mn_MachineOwner] == playerid && MiningNodes[nodeid][mn_MachineSlot] == slot) {
            MiningNodes[nodeid][mn_MachineOwner] = -1;
            MiningNodes[nodeid][mn_MachineSlot] = -1;
        }
        
        MiningMachines[playerid][slot][mm_IsActive] = false;
        MiningMachines[playerid][slot][mm_NodeID] = -1;
    }
}

hook OnGameModeInit()
{
    // Khoi tao cac mo da
    for(new i = 0; i < sizeof(MiningSpawnPoints); i++)
    {
        if(i >= MAX_MINING_NODES) break;
        MiningNodes[i][mn_PosX] = MiningSpawnPoints[i][0];
        MiningNodes[i][mn_PosY] = MiningSpawnPoints[i][1];
        MiningNodes[i][mn_PosZ] = MiningSpawnPoints[i][2];
        MiningNodes[i][mn_Rot]  = MiningSpawnPoints[i][3];
        MiningNodes[i][mn_HP]   = MINING_NODE_MAX_HP;
        MiningNodes[i][mn_IsActive] = true;
        MiningNodes[i][mn_RespawnTime] = 0;
        MiningNodes[i][mn_MachineOwner] = -1;
        MiningNodes[i][mn_MachineSlot] = -1;

        MiningNodes[i][mn_ObjectID] = CreateDynamicObject(3930, MiningNodes[i][mn_PosX], MiningNodes[i][mn_PosY], MiningNodes[i][mn_PosZ] - 0.5, 0.0, 0.0, MiningNodes[i][mn_Rot], -1, -1, -1, 500.0, 500.0);
        
        MiningNodes[i][mn_Text3D] = CreateDynamic3DTextLabel("Mo Da", 0xFFFFFFFF, MiningNodes[i][mn_PosX], MiningNodes[i][mn_PosY], MiningNodes[i][mn_PosZ] + 1.0, 300.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 300.0);
        UpdateNode3DText(i);
    }
    
    AFK_Timer = SetTimer("AFKMining_GlobalUpdate", 1000, true);
}

hook OnGameModeExit()
{
    KillTimer(AFK_Timer);
}

hook OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i < MAX_MINING_MACHINES_PER_PLAYER; i++) {
        if(MiningMachines[playerid][i][mm_IsActive]) {
            // Khi out game, may dao se bi mat
            RemoveMachine(playerid, i);
        }
    }
}

hook OnPlayerShootDynamicObject(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z)
{
    // Kiem tra xem co trung may dao nao khong
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            for(new j = 0; j < MAX_MINING_MACHINES_PER_PLAYER; j++) {
                if(MiningMachines[i][j][mm_IsActive] && objectid == STREAMER_TAG_OBJECT:MiningMachines[i][j][mm_ObjectID]) {
                    // Trung may dao
                    new damage = 20; // Sat thuong mac dinh moi vien dan
                    if(weaponid >= 22 && weaponid <= 34) damage = 30;
                    if(weaponid == 38) damage = 50; // minigun
                    
                    MiningMachines[i][j][mm_HP] -= damage;
                    
                    if(MiningMachines[i][j][mm_HP] <= 0) {
                        // May no
                        RemoveMachine(i, j);
                        SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da ban no 1 may dao khoang san!");
                        if(IsPlayerConnected(i)) {
                            SendClientMessageEx(i, COLOR_RED, "[Canh Bao] May dao khoang san cua ban da bi nguoi khac ban no!");
                        }
                    } else {
                        UpdateMachine3DText(i, j);
                    }
                    return 1;
                }
            }
        }
    }
    return 1;
}

CMD:datmay(playerid, params[])
{
    new node_id = -1;
    for(new i = 0; i < sizeof(MiningSpawnPoints); i++) {
        if(MiningNodes[i][mn_IsActive] && IsPlayerInRangeOfPoint(playerid, 3.0, MiningNodes[i][mn_PosX], MiningNodes[i][mn_PosY], MiningNodes[i][mn_PosZ])) {
            node_id = i;
            break;
        }
    }
    
    if(node_id == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan mo da nao hoac mo da da can kiet.");
    if(MiningNodes[node_id][mn_MachineOwner] != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Mo da nay dang co may dao hoat dong roi.");
    
    new has_normal = (AFK_HasItem(playerid, MACHINE_NORMAL_ID) != -1);
    new has_vip = (AFK_HasItem(playerid, MACHINE_VIP_ID) != -1);
    
    if(!has_normal && !has_vip) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co May Dao (Thuong hoac VIP) trong tui do.");
    
    new type = 0; // 0 = thuong, 1 = VIP
    if(has_normal && has_vip) {
        if(strcmp(params, "vip", true) == 0) {
            type = 1;
        } else if(strcmp(params, "thuong", true) == 0) {
            type = 0;
        } else {
            return SendClientMessageEx(playerid, COLOR_YELLOW, "Su dung: /datmay [thuong/vip] (Ban dang co ca 2 loai may dao)");
        }
    } else if(has_vip) {
        type = 1;
    } else {
        type = 0;
    }
    
    // Check limit per type: Max 1 active normal machine, Max 2 active VIP machines
    new active_normal = 0;
    new active_vip = 0;
    for(new i = 0; i < MAX_MINING_MACHINES_PER_PLAYER; i++) {
        if(MiningMachines[playerid][i][mm_IsActive]) {
            if(MiningMachines[playerid][i][mm_Type] == 1) active_vip++;
            else active_normal++;
        }
    }
    
    if(type == 1) {
        if(active_vip >= 2) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da dat toi da so luong may dao VIP cho phep (2 may).");
    } else {
        if(active_normal >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da dat toi da so luong may dao thuong cho phep (1 may).");
    }
    
    // Tim slot trong
    new slot = -1;
    for(new i = 0; i < MAX_MINING_MACHINES_PER_PLAYER; i++) {
        if(!MiningMachines[playerid][i][mm_IsActive]) {
            slot = i;
            break;
        }
    }
    
    if(slot == -1) return 1;
    
    new initial_durability = 1;
    if(type == 1) {
        new inv_slot = AFK_HasItem(playerid, MACHINE_VIP_ID);
        new dur_pct = CharacterInfo[playerid][0][cb_ItemDurability][inv_slot];
        if(dur_pct <= 0) dur_pct = 100;
        initial_durability = dur_pct / 10;
        if(initial_durability <= 0) initial_durability = 1;
        
        AFK_RemoveItem(playerid, MACHINE_VIP_ID, 1);
    } else {
        initial_durability = 1;
        AFK_RemoveItem(playerid, MACHINE_NORMAL_ID, 1);
    }
    
    MiningMachines[playerid][slot][mm_IsActive] = true;
    MiningMachines[playerid][slot][mm_Type] = type;
    MiningMachines[playerid][slot][mm_NodeID] = node_id;
    MiningMachines[playerid][slot][mm_HP] = (type == 1) ? MACHINE_VIP_HP : MACHINE_NORMAL_HP;
    MiningMachines[playerid][slot][mm_Durability] = initial_durability;
    
    MiningNodes[node_id][mn_MachineOwner] = playerid;
    MiningNodes[node_id][mn_MachineSlot] = slot;
    
    // Hien thi Object may dao, vi tri gan cuc da
    MiningMachines[playerid][slot][mm_ObjectID] = CreateDynamicObject(1886, MiningNodes[node_id][mn_PosX] + 1.0, MiningNodes[node_id][mn_PosY], MiningNodes[node_id][mn_PosZ] - 0.5, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
    MiningMachines[playerid][slot][mm_Text3D] = CreateDynamic3DTextLabel("May Dao", 0xFFFFFFFF, MiningNodes[node_id][mn_PosX] + 1.0, MiningNodes[node_id][mn_PosY], MiningNodes[node_id][mn_PosZ] + 1.0, 300.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 300.0);
    
    UpdateMachine3DText(playerid, slot);
    
    SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "Ban da dat may dao thanh cong. Ban co the di lam viec khac.");
    return 1;
}

forward AFKMining_GlobalUpdate();
public AFKMining_GlobalUpdate()
{
    new curtime = gettime();
    
    // Update Node Respawn
    for(new i = 0; i < sizeof(MiningSpawnPoints); i++) {
        if(!MiningNodes[i][mn_IsActive]) {
            if(curtime >= MiningNodes[i][mn_RespawnTime]) {
                MiningNodes[i][mn_IsActive] = true;
                MiningNodes[i][mn_HP] = MINING_NODE_MAX_HP;
                MiningNodes[i][mn_MachineOwner] = -1;
                MiningNodes[i][mn_MachineSlot] = -1;
                UpdateNode3DText(i);
            }
        }
    }
    
    // Update Machines
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            for(new j = 0; j < MAX_MINING_MACHINES_PER_PLAYER; j++) {
                if(MiningMachines[i][j][mm_IsActive]) {
                    new node = MiningMachines[i][j][mm_NodeID];
                    if(node != -1 && MiningNodes[node][mn_IsActive]) {
                        new speed = (MiningMachines[i][j][mm_Type] == 1) ? MACHINE_VIP_SPEED : MACHINE_NORMAL_SPEED;
                        MiningNodes[node][mn_HP] -= speed;
                        
                        if(MiningNodes[node][mn_HP] <= 0) {
                            // Da vo, hoan thanh viec dao
                            MiningNodes[node][mn_HP] = 0;
                            MiningNodes[node][mn_IsActive] = false;
                            MiningNodes[node][mn_RespawnTime] = curtime + MINING_NODE_RESPAWN_TIME;
                            
                            // Random khoang san (ID 3 toi 7)
                            new item_id = 3 + random(5);
                            new amount = 1 + random(2);
                            if(MiningMachines[i][j][mm_Type] == 1) amount += 2; // VIP duoc nhieu hon
                            
                            GivePlayerItem(i, item_id, amount);
                            
                            new str[128];
                            format(str, sizeof(str), "May dao cua ban da dao xong! Ban nhan duoc %d khoang san.", amount);
                            SendClientMessageEx(i, COLOR_LIGHTGREEN, str);
                            
                            // Xu ly may dao
                            if(MiningMachines[i][j][mm_Type] == 1) {
                                MiningMachines[i][j][mm_Durability] -= 1;
                                if(MiningMachines[i][j][mm_Durability] <= 0) {
                                    SendClientMessageEx(i, COLOR_RED, "May dao VIP cua ban da hu hong hoan toan!");
                                } else {
                                    GivePlayerItem(i, MACHINE_VIP_ID, 1); // Tra lai VIP
                                    new new_slot = AFK_HasItem(i, MACHINE_VIP_ID);
                                    if(new_slot != -1) {
                                        CharacterInfo[i][0][cb_ItemDurability][new_slot] = MiningMachines[i][j][mm_Durability] * 10;
                                    }
                                    Inventory_SaveData(i);
                                    SendClientMessageEx(i, COLOR_YELLOW, "May dao VIP cua ban da duoc thu hoi vao tui do.");
                                }
                            } else {
                                SendClientMessageEx(i, COLOR_YELLOW, "May dao thuong cua ban da vo tan sau khi su dung.");
                            }
                            
                            RemoveMachine(i, j);
                            UpdateNode3DText(node);
                        } else {
                            UpdateNode3DText(node);
                        }
                    }
                }
            }
        }
    }
    return 1;
}
