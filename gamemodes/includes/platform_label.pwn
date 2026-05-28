/*
    ============================================================
    Platform Label System
    
    - Label 1 (trên đầu): "[ Mobile ]" hoặc "[ PC ]"
    - Label 2 (bụng):     Tên group/faction/family — ẩn nếu không có group
    
    Detection Mobile/PC:
      1. gpci() serial check (instant)
      2. SendClientCheck + OnClientCheckResponse (PC responds, Mobile không)
      3. Fallback timer 3.5s: nếu chưa confirm PC → Mobile
    
    Group label:
      - Dùng PlayerInfo[playerid][pMember] để lấy group ID
      - Lấy tên từ arrGroupData[groupid][g_szGroupName]
      - Màu lấy từ g_hDutyColour của group
      - Nếu pMember < 0 hoặc >= MAX_GROUPS → không tạo label
    
    Yêu cầu:
      - Pawn.RakNet (đã include ở raknet.pwn)
      - streamer plugin
    ============================================================
*/

#if defined _platform_label_included
    #endinput
#endif
#define _platform_label_included

#include <YSI\y_hooks>

// ============================================================
// Native declarations
// ============================================================

#if !defined SendClientCheck
    native bool:SendClientCheck(playerid, type, memoryAddress, memoryOffset, byteCount);
#endif

// ============================================================
// Constants
// ============================================================

#define PLATFORM_CHECK_DELAY        3500    // ms timeout cho SendClientCheck
#define PLATFORM_CHECK_ACTION       72      // 0x48

#define MOBILE_GPCI_SERIAL          "ED40ED0E8089CC44C08EE9580F4C8C44EE8EE990"

// Offset Z trên đầu player (PC/Mobile label - ngay trên đầu, không cao quá)
#define PLATFORM_LABEL_OFFSET_Z     0.55
// Offset Z "bụng" player (badge group - ngay bụng)
#define GROUP_LABEL_OFFSET_Z        -0.20

#define PLATFORM_LABEL_DRAWDIST     30.0
#define GROUP_LABEL_DRAWDIST        20.0

#define COLOR_PLATFORM_MOBILE       0xFFD700FF  // Vàng gold
#define COLOR_PLATFORM_PC           0x00BFFFFF  // Cyan

// ============================================================
// Enums / Variables
// ============================================================

enum E_PLATFORM
{
    PLATFORM_UNKNOWN = 0,
    PLATFORM_PC,
    PLATFORM_MOBILE
}

new E_PLATFORM: g_PlayerPlatform[MAX_PLAYERS];
new Text3D: g_PlatformLabel[MAX_PLAYERS];   // Label trên đầu: Mobile/PC
new Text3D: g_GroupLabel[MAX_PLAYERS];      // Label bụng: tên group
new g_PlatformCheckTimer[MAX_PLAYERS];
new g_LastKnownGroup[MAX_PLAYERS];          // Track group changes

// ============================================================
// Forwards
// ============================================================

forward PlatformLabel_FallbackTimer(playerid);

// ============================================================
// Internal: gpci check
// ============================================================

static bool: PlatformLabel_IsMobileGPCI(playerid)
{
    new szSerial[41];
    gpci(playerid, szSerial, sizeof(szSerial));
    return (strcmp(szSerial, MOBILE_GPCI_SERIAL, true) == 0);
}

// ============================================================
// Internal: Set platform
// ============================================================

static PlatformLabel_SetPlatform(playerid, E_PLATFORM: platform)
{
    if (g_PlayerPlatform[playerid] == platform) return 1;
    g_PlayerPlatform[playerid] = platform;

    if (g_PlatformCheckTimer[playerid] != 0)
    {
        KillTimer(g_PlatformCheckTimer[playerid]);
        g_PlatformCheckTimer[playerid] = 0;
    }

    PlatformLabel_UpdatePlatformLabel(playerid);
    return 1;
}

// ============================================================
// Public: Update Platform Label (trên đầu)
// ============================================================

stock PlatformLabel_UpdatePlatformLabel(playerid)
{
    if (!IsPlayerConnected(playerid)) return 0;

    if (IsValidDynamic3DTextLabel(g_PlatformLabel[playerid]))
        DestroyDynamic3DTextLabel(g_PlatformLabel[playerid]);

    new szLabel[32];
    new color;

    switch (g_PlayerPlatform[playerid])
    {
        case PLATFORM_MOBILE:
        {
            format(szLabel, sizeof(szLabel), "{FFD700}[ Mobile ]");
            color = COLOR_PLATFORM_MOBILE;
        }
        case PLATFORM_PC:
        {
            format(szLabel, sizeof(szLabel), "{00BFFF}[ PC ]");
            color = COLOR_PLATFORM_PC;
        }
        default:
        {
            format(szLabel, sizeof(szLabel), "{AAAAAA}[ ... ]");
            color = 0xAAAAAAFF;
        }
    }

    g_PlatformLabel[playerid] = CreateDynamic3DTextLabel(
        szLabel, color,
        0.0, 0.0, PLATFORM_LABEL_OFFSET_Z,
        PLATFORM_LABEL_DRAWDIST,
        playerid, INVALID_VEHICLE_ID, 0,
        .streamdistance = PLATFORM_LABEL_DRAWDIST
    );
    return 1;
}

// ============================================================
// Public: Update Group Label (bụng)
// ============================================================

stock PlatformLabel_UpdateGroupLabel(playerid)
{
    if (!IsPlayerConnected(playerid)) return 0;

    // Destroy existing group label
    if (IsValidDynamic3DTextLabel(g_GroupLabel[playerid]))
    {
        DestroyDynamic3DTextLabel(g_GroupLabel[playerid]);
        g_GroupLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

    new iGroupID = PlayerInfo[playerid][pMember];
    g_LastKnownGroup[playerid] = iGroupID;

    // Không có group → ẩn label
    if (iGroupID < 0 || iGroupID >= MAX_GROUPS) return 1;
    if (!arrGroupData[iGroupID][g_szGroupName][0]) return 1;

    // g_hDutyColour lưu dạng RGB (0xRRGGBB), cần thêm alpha 0xFF
    new rgbColor = arrGroupData[iGroupID][g_hDutyColour];
    new color;
    if (rgbColor == 0 || rgbColor == 0xFFFFFF)
        color = 0xFFFFFFFF; // trắng
    else
        color = rgbColor * 256 + 0xFF; // chuyển sang RGBA

    new szLabel[GROUP_MAX_NAME_LEN + 4];
    format(szLabel, sizeof(szLabel), "%s", arrGroupData[iGroupID][g_szGroupName]);

    g_GroupLabel[playerid] = CreateDynamic3DTextLabel(
        szLabel, color,
        0.0, 0.0, GROUP_LABEL_OFFSET_Z,
        GROUP_LABEL_DRAWDIST,
        playerid, INVALID_VEHICLE_ID, 0,
        .streamdistance = GROUP_LABEL_DRAWDIST
    );
    return 1;
}

// ============================================================
// Public: Update both labels
// ============================================================

stock PlatformLabel_UpdateLabels(playerid)
{
    PlatformLabel_UpdatePlatformLabel(playerid);
    PlatformLabel_UpdateGroupLabel(playerid);
    return 1;
}

// ============================================================
// Public: Destroy all labels
// ============================================================

stock PlatformLabel_DestroyLabels(playerid)
{
    if (IsValidDynamic3DTextLabel(g_PlatformLabel[playerid]))
    {
        DestroyDynamic3DTextLabel(g_PlatformLabel[playerid]);
        g_PlatformLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }
    if (IsValidDynamic3DTextLabel(g_GroupLabel[playerid]))
    {
        DestroyDynamic3DTextLabel(g_GroupLabel[playerid]);
        g_GroupLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }
    return 1;
}

// ============================================================
// Fallback timer
// ============================================================

public PlatformLabel_FallbackTimer(playerid)
{
    g_PlatformCheckTimer[playerid] = 0;
    if (!IsPlayerConnected(playerid)) return 0;

    if (g_PlayerPlatform[playerid] == PLATFORM_UNKNOWN)
    {
        PlatformLabel_SetPlatform(playerid, PLATFORM_MOBILE);
        printf("[PlatformLabel] Player %d (%s) -> MOBILE (no ClientCheck response)", playerid, GetPlayerNameExt(playerid));
    }
    return 1;
}

// ============================================================
// Hooks
// ============================================================

hook OnPlayerConnect(playerid)
{
    if (IsPlayerNPC(playerid)) return 1;

    g_PlayerPlatform[playerid] = PLATFORM_UNKNOWN;
    g_PlatformLabel[playerid]  = Text3D:INVALID_3DTEXT_ID;
    g_GroupLabel[playerid]     = Text3D:INVALID_3DTEXT_ID;
    g_PlatformCheckTimer[playerid] = 0;

    // gpci instant check
    if (PlatformLabel_IsMobileGPCI(playerid))
    {
        PlatformLabel_SetPlatform(playerid, PLATFORM_MOBILE);
        printf("[PlatformLabel] Player %d (%s) -> MOBILE (gpci)", playerid, GetPlayerNameExt(playerid));
        return 1;
    }

    // PC client sẽ respond, mobile thường không
    SendClientCheck(playerid, PLATFORM_CHECK_ACTION, 0, 0, 2);
    g_PlatformCheckTimer[playerid] = SetTimerEx("PlatformLabel_FallbackTimer", PLATFORM_CHECK_DELAY, false, "i", playerid);

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (g_PlatformCheckTimer[playerid] != 0)
    {
        KillTimer(g_PlatformCheckTimer[playerid]);
        g_PlatformCheckTimer[playerid] = 0;
    }
    PlatformLabel_DestroyLabels(playerid);
    g_PlayerPlatform[playerid] = PLATFORM_UNKNOWN;
    g_LastKnownGroup[playerid] = -1;
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    // Refresh cả 2 labels khi spawn
    PlatformLabel_UpdateLabels(playerid);
    return 1;
}

hook OnPlayerConnect_Labels(playerid)
{
    g_LastKnownGroup[playerid] = -1;
    // Tạo group label ngay khi connect (không chỉ spawn)
    SetTimerEx("PlatformLabel_DelayedGroupUpdate", 3000, false, "i", playerid);
    return 1;
}

forward PlatformLabel_DelayedGroupUpdate(playerid);
public PlatformLabel_DelayedGroupUpdate(playerid)
{
    if (!IsPlayerConnected(playerid)) return 0;
    g_LastKnownGroup[playerid] = PlayerInfo[playerid][pMember];
    PlatformLabel_UpdateGroupLabel(playerid);
    return 1;
}

// Periodic check: update group label if pMember changed (every 5s)
task PlatformLabel_PeriodicCheck[5000]()
{
    foreach(new i : Player)
    {
        if (IsPlayerNPC(i)) continue;
        new curGroup = PlayerInfo[i][pMember];
        if (curGroup != g_LastKnownGroup[i])
        {
            g_LastKnownGroup[i] = curGroup;
            PlatformLabel_UpdateGroupLabel(i);
        }
    }
}

// ============================================================
// OnClientCheckResponse
// ============================================================

public OnClientCheckResponse(playerid, actionid, memaddr, retndata)
{
    if (actionid == PLATFORM_CHECK_ACTION)
    {
        if (g_PlayerPlatform[playerid] == PLATFORM_UNKNOWN)
        {
            PlatformLabel_SetPlatform(playerid, PLATFORM_PC);
            printf("[PlatformLabel] Player %d (%s) -> PC (ClientCheck responded)", playerid, GetPlayerNameExt(playerid));
        }
    }

    #if defined Platform_OnClientCheckResponse
        return Platform_OnClientCheckResponse(playerid, actionid, memaddr, retndata);
    #else
        return 1;
    #endif
}

#if defined Platform_OnClientCheckResponse
    forward Platform_OnClientCheckResponse(playerid, actionid, memaddr, retndata);
#endif

// ============================================================
// Helpers
// ============================================================

stock bool: PlatformLabel_IsPlayerMobile(playerid)
{
    return (g_PlayerPlatform[playerid] == PLATFORM_MOBILE);
}

stock PlatformLabel_RefreshGroup(playerid)
{
    return PlatformLabel_UpdateGroupLabel(playerid);
}
