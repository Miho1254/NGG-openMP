#include <YSI\y_hooks>

#define MAX_TREES 87
#define TREE_RESPAWN_TIME 300 // 5 phut (300 giay)
#define TREE_NORMAL_OBJECT 657
#define TREE_RARE_OBJECT 615

#define WOOD_NORMAL_PRICE 500 // $500/kg
#define WOOD_RARE_PRICE 300000 // $300k cho go sua do (tien ban)

new Float:TreePositions[MAX_TREES][3] = {
    {-757.2557, -684.4448, 108.4334}, {-775.0583, -690.6780, 111.7782}, {-774.4075, -705.1472, 110.6751}, {-764.2418, -701.3694, 108.9665},
    {-749.8496, -705.8756, 105.6667}, {-756.5586, -714.2742, 106.6107}, {-854.6294, -655.3543, 123.2726}, {-860.4531, -668.6838, 120.4852},
    {-871.1602, -677.2764, 115.3576}, {-875.8388, -665.2486, 114.6227}, {-886.4332, -670.4278, 110.3138}, {-888.2452, -655.5944, 108.7859},
    {-873.2961, -651.1197, 115.0084}, {-716.4658, -501.0838, 29.6540}, {-733.8571, -510.0349, 29.9213}, {-730.9474, -525.1390, 32.0917},
    {-746.1032, -517.5776, 30.2769}, {-749.3294, -504.2438, 28.2023}, {-734.3657, -497.5363, 28.0902}, {-717.7461, -503.2396, 29.8016},
    {-658.3976, -440.0627, 29.3162}, {-645.3488, -447.1461, 28.0719}, {-638.0724, -461.7352, 29.8048}, {-551.7875, -427.1370, 30.6385},
    {-539.7545, -429.5011, 30.8156}, {-528.4848, -426.7849, 28.3643}, {-517.0320, -431.7500, 28.8211}, {-531.0746, -441.4586, 31.8998},
    {-475.9265, -584.6185, 16.6632}, {-462.3106, -591.3206, 13.6095}, {-458.3753, -580.3936, 18.5166}, {-442.8446, -584.1492, 15.0873},
    {-455.8493, -657.6627, 14.3826}, {-471.2444, -650.3641, 14.4494}, {-474.9440, -663.5901, 15.1332}, {-488.6609, -656.8159, 14.7719},
    {-670.2941, -190.2338, 65.2841}, {-659.0410, -185.9337, 64.6621}, {-645.8977, -187.1100, 66.1849}, {-652.3979, -198.2758, 68.8925},
    {-665.0208, -204.3815, 67.9460}, {-653.0050, -214.3959, 67.1663}, {-642.9272, -205.6339, 67.7397}, {-643.4634, -188.3397, 66.7463},
    {-623.0296, -160.1820, 69.8834}, {-612.7721, -163.2522, 73.4697}, {-613.1680, -150.0784, 72.6685}, {-626.2606, -124.9295, 66.5031},
    {-639.4916, -119.4496, 64.2013}, {-629.5955, -110.9468, 65.1672}, {-613.5125, -111.1674, 65.9383}, {-616.6803, -99.6416, 65.2147},
    {-629.0776, -89.7199, 65.3737}, {-638.8939, -98.6450, 64.0749}, {-601.7023, -41.8642, 63.3578}, {-587.3694, -44.0822, 64.6070},
    {-587.2205, -32.9052, 64.4344}, {-596.8044, -23.7632, 63.5080}, {-589.7728, -11.3141, 63.1390}, {-578.9227, -19.0754, 63.7901},
    {-572.7900, -31.3519, 64.4392}, {-559.7842, 9.7570, 62.6030}, {-573.5242, 18.0648, 60.8845}, {-570.6464, 29.6412, 59.7415},
    {-558.6529, 26.1339, 61.2858}, {-543.5492, 18.2658, 61.0142}, {-543.0731, 31.0996, 58.7595}, {-531.5477, 53.0082, 53.0167},
    {-517.6381, 66.3013, 35.2440}, {-465.6271, 26.7966, 48.8598}, {-451.1225, 26.4244, 49.4778}, {-430.0649, 44.6202, 44.6908},
    {-419.0052, 72.1618, 33.2317}, {-408.2499, 82.4731, 29.2074}, {-405.5447, 70.7605, 35.3425}, {-401.8106, -88.0153, 47.7858},
    {-387.2177, -85.0403, 45.8157}, {-370.9259, -90.1868, 46.0671}, {-372.6361, -102.7016, 48.0065}, {-398.2333, -105.8012, 49.5789},
    {-375.0856, -104.3323, 48.3330}, {-380.9572, -113.4360, 50.3049}, {-399.1083, -136.9926, 57.0851}, {-399.7623, -149.9504, 60.2282},
    {-385.7018, -194.3419, 61.2438}, {-402.4494, -198.4403, 64.8435}, {-402.9744, -210.9594, 62.1881}
};

new Float:NPC_XuongMoc[4] = {-237.9103, -230.4285, 2.3567, 268.1198};
new Float:NPC_ChoDen[4] = {-713.3918, 273.0150, 2.4172, 22.0890};

enum e_TreeData {
    treeObj,
    Text3D:treeLabel,
    treeState, // 0 = Normal, 1 = Respawning, 2 = Rare Event
    treeRespawnTime,
    treeHP
}
new TreeData[MAX_TREES][e_TreeData];

new VehWood[MAX_VEHICLES];
new VehRareWood[MAX_VEHICLES]; // 0 = khong co, 1 = co go sua
new PlayerText:ChatCayTD[MAX_PLAYERS];

new Actor:ActorXuongMoc;
new Actor:ActorChoDen;
new RareTreeIndex = -1;

stock IsValidLamTacTruck(vehicleid) {
    new model = GetVehicleModel(vehicleid);
    switch(model) {
        case 478, 422, 543, 605, 600, 554, 444, 556, 557: return 1;
    }
    return 0;
}

hook OnGameModeInit() {
    print("[LamTac] Loading Lumberjack System...");
    for(new i = 0; i < MAX_TREES; i++) {
        TreeData[i][treeState] = 0;
        TreeData[i][treeHP] = 100;
        TreeData[i][treeObj] = CreateDynamicObject(TREE_NORMAL_OBJECT, TreePositions[i][0], TreePositions[i][1], TreePositions[i][2] - 1.0, 0.0, 0.0, 0.0);
        TreeData[i][treeLabel] = CreateDynamic3DTextLabel("{33AA33}[CAY GO THUONG]{FFFFFF}\nSu dung /chatcay de khai thac", COLOR_WHITE, TreePositions[i][0], TreePositions[i][1], TreePositions[i][2] + 2.0, 15.0);
    }
    
    ActorXuongMoc = CreateActor(16, NPC_XuongMoc[0], NPC_XuongMoc[1], NPC_XuongMoc[2], NPC_XuongMoc[3]);
    CreateDynamic3DTextLabel("{33AA33}Anh Nam Lam Nghiep{FFFFFF}\n/sellgo de ban go", COLOR_WHITE, NPC_XuongMoc[0], NPC_XuongMoc[1], NPC_XuongMoc[2] + 1.0, 15.0);
    
    ActorChoDen = CreateActor(28, NPC_ChoDen[0], NPC_ChoDen[1], NPC_ChoDen[2], NPC_ChoDen[3]);
    CreateDynamic3DTextLabel("{FF0000}Cho Den{FFFFFF}\n/sellgohiem de ban go sua do", COLOR_WHITE, NPC_ChoDen[0], NPC_ChoDen[1], NPC_ChoDen[2] + 1.0, 15.0);
    
    SetTimer("LamTac_GlobalTimer", 60000, true);
    return 1;
}

hook OnPlayerConnect(playerid) {
    ChatCayTD[playerid] = CreatePlayerTextDraw(playerid, 320.0, 380.0, "~y~Dang chat cay: ~w~5 giay");
    PlayerTextDrawLetterSize(playerid, ChatCayTD[playerid], 0.3, 1.5);
    PlayerTextDrawAlignment(playerid, ChatCayTD[playerid], 2);
    PlayerTextDrawColor(playerid, ChatCayTD[playerid], -1);
    PlayerTextDrawSetShadow(playerid, ChatCayTD[playerid], 1);
    PlayerTextDrawSetOutline(playerid, ChatCayTD[playerid], 0);
    PlayerTextDrawFont(playerid, ChatCayTD[playerid], 1);
    PlayerTextDrawSetProportional(playerid, ChatCayTD[playerid], 1);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if(GetPVarInt(playerid, "ChatCayTimer") != 0) {
        ClearChatCay(playerid);
    }
    DeletePVar(playerid, "WoodCarrying");
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if(GetPVarInt(playerid, "ChatCayTimer") != 0) {
        ClearChatCay(playerid);
        SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi chet khi dang chat cay! Chuyen chat cay bi huy.");
    }
    if(GetPVarInt(playerid, "WoodCarrying") > 0) {
        DeletePVar(playerid, "WoodCarrying");
        RemovePlayerAttachedObject(playerid, 9);
        SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi chet va lam rot khoi go!");
    }
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    if(VehWood[vehicleid] > 0 || VehRareWood[vehicleid] > 0) {
        new msg[128];
        if(VehRareWood[vehicleid] > 0) {
            format(msg, sizeof(msg), "Go Sua Do Ngan Nam tren xe da bi mat vi xe bi pha huy!");
        } else {
            format(msg, sizeof(msg), "%dkg go thuong tren xe da bi mat vi xe bi pha huy!", VehWood[vehicleid]);
        }
        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(vehicleid, vx, vy, vz);
        foreach(new i : Player) {
            if(IsPlayerInRangeOfPoint(i, 50.0, vx, vy, vz)) {
                SendClientMessageEx(i, COLOR_RED, msg);
            }
        }
        VehWood[vehicleid] = 0;
        VehRareWood[vehicleid] = 0;
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    VehWood[vehicleid] = 0;
    VehRareWood[vehicleid] = 0;
    return 1;
}

forward LamTac_GlobalTimer();
public LamTac_GlobalTimer() {
    new year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour, minute, second);
    
    // Cap nhat 3D Text cho cay dang respawn
    for(new i = 0; i < MAX_TREES; i++) {
        if(TreeData[i][treeState] == 1) {
            new left = TreeData[i][treeRespawnTime] - gettime();
            if(left <= 0) {
                TreeData[i][treeState] = 0;
                TreeData[i][treeHP] = 100;
                Streamer_SetIntData(STREAMER_TYPE_OBJECT, TreeData[i][treeObj], E_STREAMER_MODEL_ID, TREE_NORMAL_OBJECT);
                UpdateDynamic3DTextLabelText(TreeData[i][treeLabel], COLOR_WHITE, "{33AA33}[CAY GO THUONG]{FFFFFF}\nSu dung /chatcay de khai thac");
            } else {
                new str[128];
                format(str, sizeof(str), "{AFAFAF}[CAY DANG MOC]{FFFFFF}\nMoc lai sau: %d phut", (left / 60) + 1);
                UpdateDynamic3DTextLabelText(TreeData[i][treeLabel], COLOR_WHITE, str);
            }
        }
    }
    
    // Spawn Event Go Sua Do (19h)
    if(hour == 19 && minute == 0 && RareTreeIndex == -1) {
        new r = random(MAX_TREES);
        // Neu cay do dang respawn, reset no luon
        TreeData[r][treeState] = 2;
        TreeData[r][treeHP] = 10000;
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, TreeData[r][treeObj], E_STREAMER_MODEL_ID, TREE_RARE_OBJECT);
        UpdateDynamic3DTextLabelText(TreeData[r][treeLabel], COLOR_WHITE, "{FF0000}[GO SUA DO NGAN NAM]{FFFFFF}\nHP: 10000/10000\nSu dung /chatcay de khai thac");
        RareTreeIndex = r;
        
        SendClientMessageToAll(COLOR_RED, "{FF0000}[TIN TUC] {FFFFFF}Mot cay Go Sua Do ngan nam vua xuat hien tai khu vuc rung nui! Su dung {FFFF00}/gpsgohiem{FFFFFF} de tim vi tri!");
        SendGroupMessage(GROUP_TYPE_LEA, COLOR_RED, "{0000FF}[HQ] {FFFFFF}Tinh bao: Lam tac dang nham den Go Sua Do, hay chuan bi xe boc thep den tich thu!");
    }
    
    // Despawn Event Go Sua Do (22h)
    if(hour == 22 && minute == 0 && RareTreeIndex != -1) {
        new r = RareTreeIndex;
        TreeData[r][treeState] = 0;
        TreeData[r][treeHP] = 100;
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, TreeData[r][treeObj], E_STREAMER_MODEL_ID, TREE_NORMAL_OBJECT);
        UpdateDynamic3DTextLabelText(TreeData[r][treeLabel], COLOR_WHITE, "{33AA33}[CAY GO THUONG]{FFFFFF}\nSu dung /chatcay de khai thac");
        RareTreeIndex = -1;
        SendClientMessageToAll(COLOR_YELLOW, "{FF0000}[TIN TUC] {FFFFFF}Go Sua Do da bien mat vi khong ai thu hoach!");
    }
}

stock ClearChatCay(playerid) {
    KillTimer(GetPVarInt(playerid, "ChatCayTimer"));
    DeletePVar(playerid, "ChatCayTimer");
    DeletePVar(playerid, "ChatCayTarget");
    DeletePVar(playerid, "ChatCayCount");
    PlayerTextDrawHide(playerid, ChatCayTD[playerid]);
    ClearAnimations(playerid);
    RemovePlayerAttachedObject(playerid, 9); // Xoa cua may (slot 9)
}

CMD:chatcay(playerid, params[]) {
    if(GetPVarInt(playerid, "WoodCarrying") > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang om go roi, khong the chat them!");
    
    new treeid = -1;
    for(new i = 0; i < MAX_TREES; i++) {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, TreePositions[i][0], TreePositions[i][1], TreePositions[i][2])) {
            treeid = i;
            break;
        }
    }
    
    if(treeid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong dung gan cai cay nao!");
    if(TreeData[treeid][treeState] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Cay nay dang moc lai, khong the chat!");
    if(GetPVarInt(playerid, "ChatCayTimer") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban dang chat cay roi!");
    
    SetPlayerAttachedObject(playerid, 9, 341, 6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0); // Cua may
    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);
    
    SetPVarInt(playerid, "ChatCayTarget", treeid);
    if(TreeData[treeid][treeState] == 2) { // Go Sua Do
        SetPVarInt(playerid, "ChatCayCount", 0); // Vo han, tinh theo HP
        SetPVarInt(playerid, "ChatCayTimer", SetTimerEx("ChatCay_RareTick", 1000, true, "i", playerid));
        PlayerTextDrawSetString(playerid, ChatCayTD[playerid], "~r~Dang chat go sua do...");
        
        new zone[MAX_ZONE_NAME];
        Get3DZone(TreePositions[treeid][0], TreePositions[treeid][1], TreePositions[treeid][2], zone, sizeof(zone));
        new lawMsg[128];
        format(lawMsg, sizeof(lawMsg), "{0000FF}[HQ] {FFFFFF}Canh bao: Phat hien lam tac dang bat dau khai thac Go Sua Do Ngan Nam tai khu vuc %s!", zone);
        SendGroupMessage(GROUP_TYPE_LEA, COLOR_RED, lawMsg);
    } else { // Go thuong
        SetPVarInt(playerid, "ChatCayCount", 5); // 5 giay
        SetPVarInt(playerid, "ChatCayTimer", SetTimerEx("ChatCay_NormalTick", 1000, true, "i", playerid));
        PlayerTextDrawSetString(playerid, ChatCayTD[playerid], "~y~Dang chat cay: ~w~5 giay");
    }
    PlayerTextDrawShow(playerid, ChatCayTD[playerid]);
    return 1;
}

forward ChatCay_NormalTick(playerid);
public ChatCay_NormalTick(playerid) {
    new count = GetPVarInt(playerid, "ChatCayCount") - 1;
    new treeid = GetPVarInt(playerid, "ChatCayTarget");
    
    if(!IsPlayerInRangeOfPoint(playerid, 4.0, TreePositions[treeid][0], TreePositions[treeid][1], TreePositions[treeid][2])) {
        SendClientMessageEx(playerid, COLOR_GREY, "Ban da di ra xa khoi cai cay.");
        ClearChatCay(playerid);
        return 1;
    }
    
    if(TreeData[treeid][treeState] != 0) {
        SendClientMessageEx(playerid, COLOR_GREY, "Cay nay da bi nguoi khac chat roi!");
        ClearChatCay(playerid);
        return 1;
    }
    
    if(count <= 0) {
        ClearChatCay(playerid);
        
        // Hoan thanh chat cay thuong
        TreeData[treeid][treeState] = 1;
        TreeData[treeid][treeRespawnTime] = gettime() + TREE_RESPAWN_TIME;
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, TreeData[treeid][treeObj], E_STREAMER_MODEL_ID, 0); // Giau object
        UpdateDynamic3DTextLabelText(TreeData[treeid][treeLabel], COLOR_WHITE, "{AFAFAF}[CAY DANG MOC]{FFFFFF}\nMoc lai sau: 5 phut");
        
        SetPVarInt(playerid, "WoodCarrying", 1);
        SetPlayerAttachedObject(playerid, 9, 1463, 1, 0.1, 0.55, 0.0, 0.0, 90.0, 0.0); // Cam khuc go (RP: push forward to hands)
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "{33AA33}[LAM TAC]{FFFFFF} Ban da chat xong 10kg go thuong. Hay ra phia sau xe tai dung lenh {FFFF00}/putgo{FFFFFF}.");
    } else {
        SetPVarInt(playerid, "ChatCayCount", count);
        new str[64];
        format(str, sizeof(str), "~y~Dang chat cay: ~w~%d giay", count);
        PlayerTextDrawSetString(playerid, ChatCayTD[playerid], str);
    }
    return 1;
}

forward ChatCay_RareTick(playerid);
public ChatCay_RareTick(playerid) {
    new treeid = GetPVarInt(playerid, "ChatCayTarget");
    
    if(!IsPlayerInRangeOfPoint(playerid, 4.0, TreePositions[treeid][0], TreePositions[treeid][1], TreePositions[treeid][2])) {
        SendClientMessageEx(playerid, COLOR_GREY, "Ban da di ra xa khoi cay Go Sua Do.");
        ClearChatCay(playerid);
        return 1;
    }
    
    if(TreeData[treeid][treeState] != 2) {
        SendClientMessageEx(playerid, COLOR_GREY, "Cay Go Sua Do da bi ai do chat hoac da bien mat!");
        ClearChatCay(playerid);
        return 1;
    }
    
    // Tru HP
    TreeData[treeid][treeHP] -= 5;
    if(TreeData[treeid][treeHP] <= 0) { // LAST HIT
        ClearChatCay(playerid);
        
        TreeData[treeid][treeState] = 1;
        TreeData[treeid][treeRespawnTime] = gettime() + TREE_RESPAWN_TIME;
        Streamer_SetIntData(STREAMER_TYPE_OBJECT, TreeData[treeid][treeObj], E_STREAMER_MODEL_ID, 0);
        UpdateDynamic3DTextLabelText(TreeData[treeid][treeLabel], COLOR_WHITE, "{AFAFAF}[CAY DANG MOC]{FFFFFF}\nMoc lai sau: 5 phut");
        RareTreeIndex = -1;
        
        SetPVarInt(playerid, "WoodCarrying", 2); // Go sua do
        SetPlayerAttachedObject(playerid, 9, 1974, 1, 0.1, 0.55, 0.0, 0.0, 90.0, 0.0); // Khuc go to (RP: push forward to hands)
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        
        new str[128];
        format(str, sizeof(str), "{FF0000}[TIN TUC] {FFFFFF}%s da chat ha thanh cong Go Sua Do Ngan Nam!", GetPlayerNameEx(playerid));
        SendClientMessageToAll(COLOR_RED, str);
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "{FF0000}[LAM TAC]{FFFFFF} Ban da lay duoc Go Sua Do! Mau dua len xe tai va dem ban tai Cho Den {FFFF00}/putgo{FFFFFF}.");
    } else {
        new str[128];
        format(str, sizeof(str), "{FF0000}[GO SUA DO NGAN NAM]{FFFFFF}\nHP: %d/10000\nSu dung /chatcay de khai thac", TreeData[treeid][treeHP]);
        UpdateDynamic3DTextLabelText(TreeData[treeid][treeLabel], COLOR_WHITE, str);
    }
    return 1;
}

CMD:putgo(playerid, params[]) {
    new wType = GetPVarInt(playerid, "WoodCarrying");
    if(wType == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong mang theo khuc go nao tren tay!");
    
    new vehicleid = GetClosestCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Khong co chiec xe nao o gan day!");
    if(!IsValidLamTacTruck(vehicleid)) return SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe nay khong phai xe tai, khong the cho go!");
    
    new Float:vX, Float:vY, Float:vZ;
    GetVehiclePos(vehicleid, vX, vY, vZ);
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, vX, vY, vZ)) return SendClientMessageEx(playerid, COLOR_GREY, "Hay lai gan cop xe phia sau hon!");
    
    if(wType == 1) { // Go thuong
        if(VehWood[vehicleid] >= 100) return SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe nay da cho day 100kg go thuong! Khong the nhet them!");
        if(VehRareWood[vehicleid] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Xe nay dang cho Go Sua Do, khong the de lan lon go thuong vao!");
        
        VehWood[vehicleid] += 10;
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "{33AA33}[LAM TAC]{FFFFFF} Ban da quang 10kg go thuong len xe.");
        new str[128];
        format(str, sizeof(str), "Xe tai hien dang chua: %d/100 kg go thuong.", VehWood[vehicleid]);
        SendClientMessageEx(playerid, COLOR_WHITE, str);
    } 
    else if(wType == 2) { // Go sua do
        if(VehWood[vehicleid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Xe nay dang cho go thuong! Vut go thuong di moi cho duoc Go Sua Do kich thuoc lon!");
        if(VehRareWood[vehicleid] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Xe nay da cho 1 khuc Go Sua Do roi, khong the cho them!");
        
        VehRareWood[vehicleid] = 1;
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "{FF0000}[LAM TAC]{FFFFFF} Ban da dua Go Sua Do Ngan Nam len xe thanh cong! Mau tau thoat!");
    }
    
    DeletePVar(playerid, "WoodCarrying");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 9);
    ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:sellgo(playerid, params[]) {
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, NPC_XuongMoc[0], NPC_XuongMoc[1], NPC_XuongMoc[2])) 
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan Anh Nam Lam Nghiep (Xuong Moc).");
    
    new vehicleid = GetClosestCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidLamTacTruck(vehicleid)) 
        return SendClientMessageEx(playerid, COLOR_GREY, "Phai dem chiec xe tai cho go den day, dau sat vao bot!");
    
    if(VehWood[vehicleid] <= 0) return SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe nay khong co go thuong nao!");
    
    new amount = VehWood[vehicleid];
    new money = amount * WOOD_NORMAL_PRICE;
    
    VehWood[vehicleid] = 0; // Xoa go tren xe
    GivePlayerCash(playerid, money);
    
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1); // Animation ban hang
    new str[128];
    format(str, sizeof(str), "{33AA33}[LAM TAC]{FFFFFF} Ban da giao %dkg go thuong va nhan duoc $%s tien mat.", amount, number_format(money));
    SendClientMessageEx(playerid, COLOR_WHITE, str);
    return 1;
}

CMD:sellgohiem(playerid, params[]) {
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, NPC_ChoDen[0], NPC_ChoDen[1], NPC_ChoDen[2])) 
        return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o gan khu vuc Cho Den.");
    
    new vehicleid = GetClosestCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidLamTacTruck(vehicleid)) 
        return SendClientMessageEx(playerid, COLOR_GREY, "Phai dem chiec xe tai cho go den day, dau sat vao bot!");
    
    if(VehRareWood[vehicleid] != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe nay KHONG CO Go Sua Do!");
    
    VehRareWood[vehicleid] = 0; // Xoa go tren xe
    PlayerInfo[playerid][pDirtyMoney] += WOOD_RARE_PRICE;
    
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
    new str[128];
    format(str, sizeof(str), "{FF0000}[CHO DEN]{FFFFFF} Ban da giao dich thanh cong Go Sua Do va nhan duoc $%s tien ban.", number_format(WOOD_RARE_PRICE));
    SendClientMessageEx(playerid, COLOR_WHITE, str);
    
    new globalMsg[128];
    format(globalMsg, sizeof(globalMsg), "{FF0000}[TIN TUC] {FFFFFF}Mot luong Go Sua Do Ngan Nam da duoc tieu thu thanh cong tai Cho Den!");
    SendClientMessageToAll(COLOR_RED, globalMsg);
    return 1;
}

CMD:tichthugo(playerid, params[]) {
    if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai canh sat!");
    
    new vehicleid = GetClosestCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Khong co chiec xe nao o gan day!");
    
    if(VehRareWood[vehicleid] != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe nay khong chua Go Sua Do de tich thu!");
    
    VehRareWood[vehicleid] = 0;
    GivePlayerCash(playerid, 20000); // Thuong cho PD 20k
    
    new str[128];
    format(str, sizeof(str), "* Canh sat %s da tich thu toan bo Go Sua Do tren chiec xe nay.", GetPlayerNameEx(playerid));
    ProxDetector(30.0, playerid, str, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da tich thu Go Sua Do va duoc thuong nong $20,000.");
    return 1;
}

CMD:gpsgohiem(playerid, params[]) {
    if(RareTreeIndex == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co Go Sua Do nao xuat hien!");
    
    SetPlayerCheckpoint(playerid, TreePositions[RareTreeIndex][0], TreePositions[RareTreeIndex][1], TreePositions[RareTreeIndex][2], 5.0);
    SendClientMessageEx(playerid, COLOR_YELLOW, "Vi tri Go Sua Do da duoc danh dau tren ban do nho cua ban.");
    return 1;
}

// Dev CMD test
CMD:forcegohiem(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 4) return 1;
    if(RareTreeIndex != -1) return SendClientMessageEx(playerid, COLOR_GREY, "Da co go sua roi!");
    
    new r = random(MAX_TREES);
    TreeData[r][treeState] = 2;
    TreeData[r][treeHP] = 10000;
    Streamer_SetIntData(STREAMER_TYPE_OBJECT, TreeData[r][treeObj], E_STREAMER_MODEL_ID, TREE_RARE_OBJECT);
    UpdateDynamic3DTextLabelText(TreeData[r][treeLabel], COLOR_WHITE, "{FF0000}[GO SUA DO NGAN NAM]{FFFFFF}\nHP: 10000/10000\nSu dung /chatcay de khai thac");
    RareTreeIndex = r;
    
    SendClientMessageToAll(COLOR_RED, "{FF0000}[TIN TUC] {FFFFFF}Mot cay Go Sua Do ngan nam vua xuat hien (ADMIN FORCE)! Su dung {FFFF00}/gpsgohiem{FFFFFF} de tim vi tri!");
    return 1;
}
