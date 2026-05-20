# DEPENDENCIES MAP — Hệ thống Inventory/Balo

> Nguồn: `Rgame2018/gamemodes/modules/`
> Ngày: 2026-05-20

---

## MỤC LỤC
1. [Tổng quan dependency graph](#1-tổng-quan-dependency-graph)
2. [cac.inc — PlayerData Enum](#2-cacinc--playerdata-enum)
3. [hunger-system.inc](#3-hunger-systeminc)
4. [adventure.inc](#4-adventureinc)
5. [guide.inc](#5-guideinc)
6. [tradenewitem.inc](#6-tradenewiteminc)
7. [sellgunnew.inc](#7-sellgunnewinc)
8. [drop_pick_item.inc](#8-drop_pick_iteminc)
9. [craftweapon.inc](#9-craftweaponinc)
10. [gs-utils.inc](#10-gs-utilsinc)
11. [famed-mission.inc](#11-famed-missioninc)
12. [new_stats.inc](#12-new_statsinc)
13. [oocshop.inc](#13-oocshopinc)
14. [Cross-file API usage matrix](#14-cross-file-api-usage-matrix)
15. [Kế hoạch copy](#15-kế-hoạch-copy)

---

## 1. TỔNG QUAN DEPENDENCY GRAPH

```
inventory.inc (CORE)
├── cac.inc (PlayerData enum) ← PHỤ THUỘC TRỰC TIẾP
│   ├── hunger-system.inc (FoodBar/WaterBar)
│   ├── adventure.inc (EA progress bar)
│   └── new_stats.inc (hiển thị stats)
│
├── guide.inc (Guide_ReadPost, GuideTimer, Inventory_Show)
│
├── tradenewitem.inc (GivePlayerItem, RemovePlayerItem, CharacterInfo)
├── sellgunnew.inc (CharacterInfo, GetIDWeapon, Inventory_ListItems)
├── drop_pick_item.inc (SetPlayerItem, CharacterInfo, SetPlayerWeaponsEx)
├── craftweapon.inc (SetPlayerItem, RemovePlayerItem, CharacterInfo, PlayerData[pc_EA])
│
├── gs-utils.inc (SetPlayerItem, CharacterInfo, GetAmmoWeaponLimit)
├── famed-mission.inc (SetPlayerItem, GivePlayerEA, PlayerData[pc_FamedPoint])
│
├── useitemgain.inc (ItemGain timer system) ← ĐÃ COPY
├── oocshop.inc (PlayerData[pc_Coin])
│
└── event_rg/ (Event_Show, TaskFarm_Show, CheckRedZoneData)
```

---

## 2. cac.inc — PlayerData Enum

**File:** `modules/cac.inc` (435 dòng)
**Vai trò:** Định nghĩa PlayerData enum + account config system (password, settings)

### Enum:
```pawn
enum pc_Info {
    pc_Pass[4],                    // Financial password (4 digits)
    pc_GP,                         // Game Points
    pc_Coin,                       // Premium Coin
    pc_EA,                         // EXP Adventure
    Float:pc_FoodBar,              // Thanh thức ăn (0-100)
    Float:pc_WaterBar,             // Thanh nước (0-100)
    pc_Job, pc_Job2, pc_Job3,     // Job IDs
    pc_FishmanSkill,               // Skill câu cá
    pc_AlcoholSkill,               // Skill giao rượu
    pc_PizzaBoySkill,              // Skill pizza
    pc_SweeperSkill,               // Skill quét đường
    pc_TruckerSkill,               // Skill trucker
    pc_AlcoholLimit,               // Daily alcohol limit
    pc_SweeperLimit,               // Daily sweeper limit
    pc_AlcoholTimer,               // Alcohol cooldown
    pc_SweeperTimer,               // Sweeper cooldown
    pc_CaribbeanTeam,              // Caribbean event team
    pc_CaribbeanEvent,             // Caribbean event status
    pc_FamedPoint,                 // Fame points
    pc_LimitEventReward,           // Event reward limit
    pc_ClaimRoseWinter,            // Rose Winter claim
    pc_CargoTimeOnline,            // Cargo online time
    pc_CargoTimeSeconds,           // Cargo seconds
    pc_ItemTradeNeft_Miner,        // Daily mineral trade count
    pc_ItemTradeNeftExpire_Miner   // Mineral trade expiry timestamp
};
new PlayerData[MAX_PLAYERS][pc_Info];
```

### Global vars:
```pawn
new pc_PassKey[][] = {"1","2","3","4","5","6","7","8","9","Reset","Hoan thanh"};
new temppc_Pass[MAX_PLAYERS][4];
new temppc_Login[MAX_PLAYERS];
```

### Commands:
| Command | Line | Description |
|---------|------|-------------|
| `/taikhoan` | 51 | Account settings (alias: `/account`) |
| `/account` | 56 | Same as above |
| `/gtasa_setmygp` | 74 | Admin: set GP cho mình |

### Key Functions:
| Function | Line | Description |
|----------|------|-------------|
| `GetPlayerConfigAccount(playerid)` | 98 | Load PlayerData từ MySQL |
| `CheckPlayerConfigAccount(playerid)` | 106 | Check + create nếu chưa có row |
| `SavePlayerAccountic(playerid)` | 174 | Save PlayerData to MySQL |
| `SAC_Integer(SQLId, field, value)` | 205 | MySQL update helper |

### MySQL Table: `account2`
```sql
-- Columns: SQLId, GP, Coin, EA, FoodBar, WaterBar, Job, Job2, Job3,
-- FishmanSkill, AlcoholSkill, PizzaBoySkill, SweeperSkill, TruckerSkill,
-- AlcoholLimit, SweeperLimit, AlcoholTimer, SweeperTimer,
-- CaribbeanTeam, CaribbeanEvent, FamedPoint, LimitEventReward,
-- ClaimRoseWinter, CargoTimeOnline, CargoTimeSeconds,
-- ItemTradeNeft_Miner, ItemTradeNeftExpire_Miner
```

### Callbacks:
- `hook OnPlayerConnect` (line 391) — reset PlayerData
- `hook OnPlayerDisconnect` (line 428) — save PlayerData
- Calls `OnPlayerLoad(playerid)` after loading (line 158, 169)

### Dependencies:
- `PlayerInfo[playerid][pAdmin]`, `PlayerInfo[playerid][pId]`
- `gPlayerLogged{playerid}`
- `MainPipeline` (MySQL)
- `KickEx` timer
- `OnPlayerLoad(playerid)` — forward defined elsewhere

---

## 3. hunger-system.inc

**File:** `modules/hunger-system.inc` (55 dòng)
**Vai trò:** Thanh thức ăn/nước, giảm dần theo thời gian

### Global vars:
```pawn
new PlayerBar:FoodBar[MAX_PLAYERS];
new PlayerBar:WaterBar[MAX_PLAYERS];
```

### Functions:
| Function | Line | Description |
|----------|------|-------------|
| `hook OnPlayerConnect` | 12 | Tạo FoodBar/WaterBar PlayerBar |
| `Setup_Hunger(playerid)` | 20 | Setup bars (position, color, value) |
| `Update_Hunger(playerid)` | 28 | Update bar display từ PlayerData |
| `ptask TakenHunger[180000]` | 35 | Mỗi 3 phút: giảm Food/Water bar |

### Logic:
- `pc_FoodBar` giảm 1.0 mỗi 3 phút, `pc_WaterBar` giảm 2.0 mỗi 3 phút
- Khi FoodBar = 0 hoặc WaterBar = 0 → trừ máu
- Dùng `PlayerBar` library (progress bars)

### Dependencies:
- `PlayerData[playerid][pc_FoodBar]`, `PlayerData[playerid][pc_WaterBar]`
- `PlayerBar` library (progress bar plugin/include)

---

## 4. adventure.inc

**File:** `modules/adventure.inc` (28 dòng)
**Vai trò:** EXP Adventure progress bar

### Global vars:
```pawn
new PlayerBar:EABar[MAX_PLAYERS];
```

### Functions:
| Function | Line | Description |
|----------|------|-------------|
| `hook OnPlayerConnect` | 11 | Tạo EABar PlayerBar |
| `Setup_Adventures(playerid)` | 17 | Setup bar |
| `Update_Adventures(playerid)` | 24 | Update bar từ `PlayerData[pc_EA]` |

### Dependencies:
- `PlayerData[playerid][pc_EA]`
- `PlayerBar` library

---

## 5. guide.inc

**File:** `modules/guide.inc` (609 dòng)
**Vai trò:** Guide system (tab-based UI: Guide, Inventory, Event, Task Farm)

### Global vars:
```pawn
new PlayerText:Guide_Main[MAX_PLAYERS][MAX_GUIDE][MAX_ITEM_GUIDE]; // 3 tabs x 8 items
new PlayerText:Guide_Post[MAX_PLAYERS];
new Guide_ReadTab[MAX_PLAYERS];
new Guide_ReadPost[MAX_PLAYERS];    // ← SHARE với inventory.inc
new Guide_Page[MAX_PLAYERS];
new GuideTimer[MAX_PLAYERS];         // ← SHARE với inventory.inc
```

### Constants:
```pawn
#define MAX_GUIDE 3
#define MAX_ITEM_GUIDE 8
```

### Commands:
| Command | Line | Description |
|---------|------|-------------|
| `/closeguide` | 442 | Đóng guide |

### Key Functions:
| Function | Line | Description |
|----------|------|-------------|
| `CPTD_Guide(playerid)` | 19 | Tạo guide TextDraws |
| `CPTD_GuidePost(playerid)` | 265 | Tạo post TextDraw |
| `Guide_Action(playerid, action)` | 279 | State machine (0=open, 1=update, 2=tab switch, etc.) |

### Inventory Connection:
- `guide.inc:488` — Tab 3 gọi `Inventory_Action(playerid, 0)` để mở inventory
- `guide.inc:552` — Kiểm tra `Inventory_Show[playerid]` trước khi mở guide
- `Guide_ReadPost` được share: inventory dùng nó cho page navigation (page 1/2)
- `GuideTimer` được share: anti-spam timer

### Dependencies:
- `Inventory_Action()`, `Inventory_Show[]`
- `Event_Show[][]`, `TaskFarm_Show[]`
- `VNC_Action()`, `TaskFarm_Action()` (from event modules)
- `IsPlayerUsingSampMobile()`
- `gPlayerLogged{playerid}`

---

## 6. tradenewitem.inc

**File:** `modules/tradenewitem.inc` (278 dòng)
**Vai trò:** Trade items giữa 2 players

### Commands:
| Command | Line | Description |
|---------|------|-------------|
| `/giaodich` | 11 | Mở trade dialog |

### Inventory API Usage:
| Function | Lines | Context |
|----------|-------|---------|
| `CharacterInfo[playerid][0][cb_ItemID]` | 22,40,81,84,88,160,162,200,227 | List items, check items |
| `CharacterInfo[playerid][0][cb_ItemAmount]` | 81,84,160,200,227 | Check amount |
| `Inventory_ListItems[]` | 24,165,232 | Display names |
| `GetIDWeapon()` | 22 | Filter weapons out |
| `GivePlayerItem()` | 216 | Give to buyer |
| `RemovePlayerItem()` | 229 | Remove from seller |

### PlayerData Usage:
- `PlayerData[playerid][pc_ItemTradeNeft_Miner]` (line 43, 244, 246, 248) — daily mineral trade limit
- `PlayerData[playerid][pc_ItemTradeNeftExpire_Miner]` (line 91) — trade expiry

### Block Rules:
- Không trade weapons (`GetIDWeapon(item) != 0`)
- Không trade treasure maps (item 43)
- Daily mineral trade limit = `MAX_ITEM_TRADE_NEFT` (1)

---

## 7. sellgunnew.inc

**File:** `modules/sellgunnew.inc` (343 dòng)
**Vai trò:** Bán vũ khí cho player khác

### Constants:
```pawn
#define TRADE_WEAPON 1
#define TRADE_TIMEOUT_MS (5 * 60 * 1000)
```

### Commands:
| Command | Line | Description |
|---------|------|-------------|
| `/banvukhi` | 39 | Bán vũ khí |

### Inventory API Usage:
| Function | Lines | Context |
|----------|-------|---------|
| `CharacterInfo[playerid][1][cb_ItemID]` | 56,73,114,166,220,246,262,285,290 | Weapon slots |
| `CharacterInfo[playerid][0][cb_ItemID]` | 236,262,290 | Bag slots |
| `CharacterInfo[playerid][0][cb_Weight]` | 254 | Weight check |
| `GetIDWeapon()` | 59,61,168,223,281 | Weapon ID mapping |
| `GetItemWeight()` | 253 | Weight validation |
| `Inventory_ListItems[]` | 118,122,176,304,307,314 | Display names |
| `SetPlayerWeaponsEx()` | 283 (via ResetPlayerWeapons) | Re-sync weapons |

### Block Rules:
- LAW weapons (items 44-48) không được bán
- Weight check trước khi nhận vũ khí

---

## 8. drop_pick_item.inc

**File:** `modules/drop_pick_item.inc` (235 dòng)
**Vai trò:** Rớt/nhặt vũ khí trên ground

### Constants:
```pawn
#define MAX_GUNS_DROP 2000
```

### Enum:
```pawn
enum gunDropInfo {
    g_szGunID,          // Weapon SA-MP ID
    g_szGunAmmo,        // Ammo count
    g_szGunObj,         // Object model
    g_szDynGunObj,      // Dynamic object ID
    Float:gszObjPosX,   // Drop position X
    Float:gszObjPosY,   // Drop position Y
    Float:gszObjPosZ    // Drop position Z
};
new GunDropData[MAX_GUNS_DROP][gunDropInfo];
```

### Commands:
| Command | Line | Description |
|---------|------|-------------|
| `/nhatsung` | 45 | Nhặt vũ khí từ ground |
| `/vutsung` | 102 | Rớt vũ khí đang cầm |

### Inventory API Usage:
| Function | Lines | Context |
|----------|-------|---------|
| `SetPlayerItem()` | 78 | Add picked-up weapon to bag |
| `CharacterInfo[playerid][1][cb_ItemID]` | 183-185,198-203 | Read/clear equipped weapon |
| `GetIDWeapon()` | 183 | Map item → weapon ID |
| `SetPlayerWeaponsEx()` | 195 | Re-sync after drop |

### Block Rules:
- LAW weapons (44-48) không được drop
- Tối đa `MAX_GUNS_DROP` (2000) objects trên ground

---

## 9. craftweapon.inc

**File:** `modules/craftweapon.inc` (224 dòng)
**Vai trò:** Chế tạo vũ khí từ khoáng sản

### Constants:
```pawn
#define MAX_CRAFTABLE_WEAPONS 14
```

### Data:
```pawn
new CraftWeaponInvModel[14] = {41, 24, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35};
new CraftWeaponList[14][] = {"Hop dan (tich hop)", "9mm", "SD-Pistol", "Deagle", ...};
new CraftWeaponPrice[14] = {100000, 250000, 300000, 500000, ...};
new CraftWeaponEXP[14] = {0, 4000, 4000, 6000, 6000, 8000, 8000, 10000, 12000, 15000, 18000, 20000, 25000, 30000};
new CraftWeaponKS_Silver[14] = {0, 5, 5, 10, 10, 15, 15, 20, 25, 30, 35, 40, 50, 60};
new CraftWeaponKS_Niken[14] = {0, 3, 3, 5, 5, 8, 8, 10, 15, 20, 25, 30, 35, 40};
new CraftWeaponKS_Gold[14] = {0, 1, 1, 2, 2, 3, 3, 5, 8, 10, 12, 15, 20, 25};
new CraftWeaponKS_Cu[14] = {0, 2, 2, 3, 3, 5, 5, 8, 10, 12, 15, 18, 22, 28};
new CraftWeaponKS_Crom[14] = {0, 0, 0, 1, 1, 2, 2, 3, 5, 8, 10, 12, 15, 20};
```

### Inventory API Usage:
| Function | Lines | Context |
|----------|-------|---------|
| `SetPlayerItem()` | 81, 156 | Add crafted weapon |
| `RemovePlayerItem()` | 168 | Consume minerals |
| `CharacterInfo[playerid][0][cb_ItemID]` | 123 | Check mineral items |
| `CharacterInfo[playerid][0][cb_ItemAmount]` | 125, 166 | Check mineral amounts |
| `GetAmmoWeaponLimit()` | 81, 156 | Get max ammo for crafted weapon |

### PlayerData Usage:
- `PlayerData[playerid][pc_EA]` (lines 100, 102, 160) — EXP cost for crafting

### Crafting Location:
- `IsPlayerInRangeOfPoint(playerid, 3.0, 2132.0698, -2282.2427, 20.6719)` — crafting table position

---

## 10. gs-utils.inc

**File:** `modules/gs-utils.inc` (761 dòng)
**Vai trò:** VIP shop, LAW locker, custom skins, damage logging

### Inventory API Usage:
| Function | Lines | Context |
|----------|-------|---------|
| `SetPlayerItem()` | 113,114,162,180,402,407,485,516,531,544,557 | VIP shop, LAW locker, missions |
| `CharacterInfo[playerid][0/1][cb_ItemID]` | 28,35,60,67,103,469,476,500,507,611 | Check existing items |
| `CharacterInfo[playerid][0][cb_Weight]` | 28, 60 | Set weight capacity |
| `CharacterInfo[playerid][0][cb_ItemLock]` | 35,67,103 | Unlock slots |
| `Inventory_ListItems[]` | 413, 613 | Display names |
| `GetIDWeapon()` | 611 | Weapon ID mapping |
| `GetAmmoWeaponLimit()` | 402 | Max ammo for LAW weapons |

### Key Features:
- VIP shop bán mining machines (8/9), medkit (11), jerry cans (21/22)
- LAW faction locker give weapons + ammo boxes
- Custom VIP skins (20006, 20009)
- OPDGiveDMG — damage logging với weapon names từ Inventory_ListItems

---

## 11. famed-mission.inc

**File:** `modules/famed-mission.inc` (1054 dòng)
**Vai trò:** Fame mission system (quests từ NPCs)

### Inventory API Usage:
| Function | Lines | Context |
|----------|-------|---------|
| `SetPlayerItem(playerid, 8, 1, success)` | 514 | Reward: mining machine |
| `SetPlayerItem(playerid, 21, 100, success)` | 515 | Reward: jerry can 100L |
| `SetPlayerItem(playerid, 43, 1, success)` | 516 | Reward: treasure map |
| `GivePlayerEA(playerid, 1250)` | 525, 832 | Reward: EXP |
| `GivePlayerEA(playerid, 3000)` | 623 | Reward: EXP |
| `GivePlayerEA(playerid, 5000)` | 878 | Reward: EXP |

### PlayerData Usage:
- `PlayerData[playerid][pc_FamedPoint]` (lines 526, 625, 833, 879)

---

## 12. new_stats.inc

**File:** `modules/new_stats.inc` (190 dòng)
**Vai trò:** Hiển thị stats player

### PlayerData Usage:
- `PlayerData[targetid][pc_EA]`, `[pc_GP]`, `[pc_Coin]` (lines 156-158) — hiển thị trong stats
- `PlayerData[playerid][pc_Job/pc_Job2/pc_Job3]` (lines 175-180)
- `PlayerData[playerid][pc_FamedPoint]` (line 94)

---

## 13. oocshop.inc

**File:** `modules/oocshop.inc` (190 dòng)
**Vai trò:** OOC vehicle shop (boats, planes, cars) bằng Coin

### PlayerData Usage:
- `PlayerData[playerid][pc_Coin]` (lines 35,43,61,69,87,95,149,163,177) — check & deduct coins

---

## 14. CROSS-FILE API USAGE MATRIX

| API Function | inventory | cac | hunger | adventure | guide | tradenew | sellgunnew | drop_pick | craftweapon | gs-utils | famed | stats | oocshop |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `SetPlayerItem` | ✓ | - | - | - | - | - | - | ✓ | ✓ | ✓ | ✓ | - | - |
| `GivePlayerItem` | ✓ | - | - | - | - | ✓ | - | - | - | - | - | - | - |
| `RemovePlayerItem` | ✓ | - | - | - | - | ✓ | - | - | ✓ | - | - | - | - |
| `CharacterInfo` | ✓ | - | - | - | - | ✓ | ✓ | ✓ | ✓ | ✓ | - | - | - |
| `Inventory_ListItems` | ✓ | - | - | - | - | ✓ | ✓ | - | - | ✓ | - | - | - |
| `GetIDWeapon` | ✓ | - | - | - | - | ✓ | ✓ | ✓ | - | ✓ | - | - | - |
| `GetItemWeight` | ✓ | - | - | - | - | - | ✓ | - | - | - | - | - | - |
| `GetAmmoWeaponLimit` | ✓ | - | - | - | - | - | - | - | ✓ | ✓ | - | - | - |
| `GivePlayerEA` | ✓ | - | - | - | - | - | - | - | - | - | ✓ | - | - |
| `Inventory_Action` | ✓ | - | - | - | ✓ | - | - | - | - | - | - | - | - |
| `Inventory_Show` | ✓ | - | - | - | ✓ | - | - | - | - | - | - | - | - |
| `SetPlayerWeaponsEx` | ✓ | - | - | - | - | - | - | ✓ | - | - | - | - | - |
| `Update_Adventures` | - | - | - | ✓ | - | - | - | - | ✓ | ✓ | - | - | - |
| `PlayerData[pc_GP]` | ✓ | ✓ | - | - | - | - | - | - | - | ✓ | - | ✓ | - |
| `PlayerData[pc_Coin]` | ✓ | ✓ | - | - | - | - | - | - | - | - | - | ✓ | ✓ |
| `PlayerData[pc_EA]` | ✓ | ✓ | - | ✓ | - | - | - | - | ✓ | ✓ | ✓ | ✓ | - |
| `PlayerData[pc_FoodBar]` | ✓ | ✓ | ✓ | - | - | - | - | - | - | - | - | - | - |
| `PlayerData[pc_WaterBar]` | ✓ | ✓ | ✓ | - | - | - | - | - | - | - | - | - | - |
| `PlayerData[pc_FamedPoint]` | - | ✓ | - | - | - | - | - | - | - | - | ✓ | ✓ | - |

---

## 15. KẾ HOẠCH COPY

### Phase 1: Core Dependencies (BẮT BUỘC)
| # | File | Lines | Action | Ghi chú |
|---|------|-------|--------|---------|
| 1 | `cac.inc` | 435 | Copy + fix | PlayerData enum, MySQL load/save cho account2 |
| 2 | `hunger-system.inc` | 55 | Copy + fix | Cần PlayerBar library |
| 3 | `adventure.inc` | 28 | Copy + fix | Cần PlayerBar library |

### Phase 2: Inventory-Adjacent Systems
| # | File | Lines | Action | Ghi chú |
|---|------|-------|--------|---------|
| 4 | `guide.inc` | 609 | Copy + fix | Share vars với inventory, cần OnPlayerClickPlayerTD |
| 5 | `tradenewitem.inc` | 278 | Copy + fix | Dùng inventory API |
| 6 | `sellgunnew.inc` | 343 | Copy + fix | Dùng inventory API |
| 7 | `drop_pick_item.inc` | 235 | Copy + fix | Dùng inventory API |
| 8 | `craftweapon.inc` | 224 | Copy + fix | Dùng inventory API + PlayerData |

### Phase 3: Extended Systems
| # | File | Lines | Action | Ghi chú |
|---|------|-------|--------|---------|
| 9 | `gs-utils.inc` | 761 | Copy + fix | VIP shop, LAW locker, custom skins |
| 10 | `famed-mission.inc` | 1054 | Copy + fix | Fame missions |
| 11 | `new_stats.inc` | 190 | Copy + fix | Stats display |
| 12 | `oocshop.inc` | 190 | Copy + fix | OOC vehicle shop |

### Phase 4: Event Systems (OPTIONAL)
| # | File | Lines | Action | Ghi chú |
|---|------|-------|--------|---------|
| 13 | `event_rg/event.inc` | ? | Nếu cần | Event_Show |
| 13a | `event_rg/event_list/task_farm-daily.inc` | ? | Nếu cần | TaskFarm_Show |
| 13b | `event_rg/event_list/redzone.inc` | ? | Nếu cần | CheckRedZoneData |
| 13c | `event_rg/event_list/vn_capsule.inc` | ? | Nếu cần | Event shop |

### Compatibility Fixes cần làm cho MỖI file:
1. `#include <YSI_Coding\y_hooks>` → `<YSI\y_hooks>`
2. `Function:` macro → đã define trong defines.pwn
3. `Dialog_Show()` → đã có trong easyDialog.inc
4. `cmd_xxx` forward → dùng `callcmd::xxx` (Pawn.CMD)
5. `SendAdminMessage` → đã có stub trong inventory.inc
6. Kiểm tra conflict tên function với code NGG hiện có
7. `PlayerBar` library → cần kiểm tra có trong NGG không

### MySQL Tables cần tạo:
| Table | Source |
|-------|--------|
| `inventory` | `inventory.sql` (đã copy) |
| `account2` | `cac.inc` MySQL queries |

### Missing Libraries cần kiểm tra:
| Library | Dùng bởi | Trong NGG? |
|---------|----------|-----------|
| `PlayerBar` | hunger-system, adventure | ? |
| `mSelection` | gs-utils (skin selection) | ✅ (NGRP.pwn:107) |
| `easyDialog` | All dialog systems | ✅ (NGRP.pwn:111) |
| `Pawn.CMD` | All commands | ✅ (NGRP.pwn:102) |
| `streamer` | drop_pick_item | ✅ (NGRP.pwn:100) |
| `sscanf2` | All sscanf calls | ✅ (NGRP.pwn:103) |
