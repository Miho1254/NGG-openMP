# HỆ THỐNG INVENTORY / BALO - RGAME2018 DOCUMENTATION

> Nguồn: `C:\Users\RimikoPC\Downloads\samp-code\Rgame2018`
> Ngày tạo: 2026-05-20

---

## MỤC LỤC
1. [Tổng quan kiến trúc](#1-tổng-quan-kiến-trúc)
2. [SQL Schema](#2-sql-schema)
3. [Inventory Enum & Data Structure](#3-inventory-enum--data-structure)
4. [Danh sách Items (50 items)](#4-danh-sách-items-50-items)
5. [Item Weight System](#5-item-weight-system)
6. [Item Amount/Stack Limits](#6-item-amountstack-limits)
7. [Weapon System](#7-weapon-system)
8. [TextDraw UI System](#8-textdraw-ui-system)
9. [DFF/TXD Custom Model System](#9-dfftxd-custom-model-system)
10. [Core Functions](#10-core-functions)
11. [Commands](#11-commands)
12. [Dialog System](#12-dialog-system)
13. [MySQL Save/Load](#13-mysql-saveload)
14. [Item Drop & Pickup](#14-item-drop--pickup)
15. [Trading System](#15-trading-system)
16. [Additional Related Files](#16-additional-related-files)

---

## 1. TỔNG QUAN KIẾN TRÚC

### File chính
- **`gamemodes/modules/inventory.inc`** (4268 dòng) - Module chính
- **`gamemodes/GTASA.pwn`** line 363 - Include inventory module
- **`inventory.sql`** (481 dòng) - Schema riêng cho inventory

### Constants (defines.pwn line 1625-1629)
```pawn
#define MAX_INTERFACE 2              // 2 tab: [0] = balo chính (84 slots), [1] = trang bị vũ khí (7 slots)
#define MAX_PLAYER_CB_ITEM 84       // 84 slots per tab
#define MAX_SERIAL_LENGTH 36        // serial number length
#define MAX_PLAYER_TD_INVENTORY     62   // Số TextDraw chính (defines.pwn:1627)
#define MAX_PLAYER_TD_INVENTORYINFO  8   // Số TextDraw info panel (defines.pwn:1628)
#define MAX_PLAYER_SYSTEM_SHOW       2   // (defines.pwn:1626)
#define MAX_EVENT_SPAWN              1   // (defines.pwn:1629)
#define Function:%0(%1) forward%0(%1); public%0(%1)  // Macro (defines.pwn:1623)
```

### Biến toàn cục
```pawn
new CharacterInfo[MAX_PLAYERS][MAX_INTERFACE][cb_Info];   // Dữ liệu inventory per player
new cb_ItemSerial[MAX_PLAYERS][MAX_INTERFACE][MAX_PLAYER_CB_ITEM][MAX_SERIAL_LENGTH]; // serial
new Inventory_Character[MAX_PLAYERS];  // Toggle character panel (0/1)
new Inventory_Timer[MAX_PLAYERS];      // Timer anti-spam
new Inventory_Show[MAX_PLAYERS];       // Trạng thái mở/tắt inventory (defined in variables.pwn:2720)
```

### Danh sách tên items array
```pawn
new Inventory_ListItems[][] = {
    "Camera","Minigun","Khoang san bac","Khoang san niken","Khoang san vang","Khoang san Cu (Dong)","Khoang san Crom","May dao thuong","May dao VIP",
    "Coin Exchange (gp -> coin)", "Medkit", "Thuoc gatacetamol", "Phieu mo rong tui do", "The GP Bonus 30%", "The EXP Bonus 10%", "The EXP Bonus 20%",
    "The EXP Bonus 30%", "Hom trang phuc Event Vietnam Capsule mua 1", "Hom xe Event Vietnam Capsule mua 1", "Hom Toy Event Vietnam Capsule mua 1",
    "Jerry can (100 lit)", "Jerry can (200 lit)", "SD-Pistol", "Colt-9mm", "Deagle", "Shotgun", "Sawn-Off", "Spas-12", "Uzi", "Mp5", "AK", "M4",
    "Tec9", "Rifle", "Sniper", "Da tho", "Ca thu", "Ca ngu", "Ca noc", "Ruou & thuoc la", "Hop dan tich hop", "Combo GFC", "Ban do kho bau","M4 LAW",
    "AK LAW", "Deagle LAW", "9mm LAW", "MP5 LAW", "Sword Katana", "Gay Bong Chay"
};
```

---

## 2. SQL SCHEMA

### File: `inventory.sql`

**Bảng `inventory`** - Bảng riêng, KHÔNG nằm trong accounts table.

```sql
CREATE TABLE IF NOT EXISTS `inventory` (
    `Weight` FLOAT DEFAULT 0.0,                    -- Trọng lượng tối đa tab chính

    -- ItemLock[84]: Khóa slot (0 = mở, 1 = khóa)
    `ItemLock0` TINYINT(1) DEFAULT 0,
    ... (đến ItemLock83)

    -- ItemID[84]: ID vật phẩm (-1 = trống)
    `ItemID0` INT DEFAULT -1,
    ... (đến ItemID83)

    -- ItemWeight[84]: Trọng lượng thực tế của item trong slot
    `ItemWeight0` FLOAT DEFAULT 0.0,
    ... (đến ItemWeight83)

    -- ItemDurability[84]: Độ bền (0-100)
    `ItemDurability0` INT DEFAULT 0,
    ... (đến ItemDurability83)

    -- ItemAmount[84]: Số lượng / Ammo
    `ItemAmount0` INT DEFAULT 0,
    ... (đến ItemAmount83)

    -- TAB PHỤ (Weapon slots)
    `Weight2` FLOAT DEFAULT 0.0,                   -- Trọng lượng tối đa tab vũ khí

    `Item2Lock0`-`Item2Lock6` INT DEFAULT 0,       // 7 slot khóa
    `Item2ID0`-`Item2ID6` INT DEFAULT -1,          // 7 slot ID
    `Item2Weight0`-`Item2Weight6` FLOAT DEFAULT 0.0, // 7 slot trọng lượng
    `Item2Durability0`-`Item2Durability6` INT DEFAULT 0, // 7 slot độ bền
    `Item2Amount0`-`Item2Amount6` INT DEFAULT 0    // 7 slot số lượng
);
```

**Lưu ý quan trọng:**
- Bảng `inventory` KHÔNG có primary key riêng - dùng `SQLId` (nhưng trong file .sql standalone thì thiếu, trong full dump gtasa(15).sql thì có `Id` và `SQLId`)
- Mỗi player = 1 row trong bảng inventory
- Tab chính: 84 slots (13 slots mở mặc định, 71 slots còn lại bị khóa)
- Tab vũ khí: 7 slots (tất cả mở mặc định)

### Cấu trúc trong full dump (`gtasa (15).sql`):
```sql
CREATE TABLE `inventory` (
  `Id` int(11) NOT NULL,
  `SQLId` int(11) NOT NULL,
  `Weight` float DEFAULT 0,
  -- 84 slots cho tab chính
  `ItemLock0`..`ItemLock83` tinyint(1) DEFAULT 0,
  `ItemID0`..`ItemID83` int(11) DEFAULT -1,
  `ItemWeight0`..`ItemWeight83` float DEFAULT 0.0,
  `ItemDurability0`..`ItemDurability83` int(11) DEFAULT 0,
  `ItemAmount0`..`ItemAmount83` int(11) DEFAULT 0,
  -- 7 slots cho tab vũ khí
  `Weight2` float DEFAULT 0.0,
  `Item2Lock0`..`Item2Lock6` int(11) DEFAULT 0,
  `Item2ID0`..`Item2ID6` int(11) DEFAULT -1,
  `Item2Weight0`..`Item2Weight6` float DEFAULT 0.0,
  `Item2Durability0`..`Item2Durability6` int(11) DEFAULT 0,
  `Item2Amount0`..`Item2Amount6` int(11) DEFAULT 0
);
```

---

## 3. INVENTORY ENUM & DATA STRUCTURE

```pawn
enum cb_Info {
    Float:cb_Weight,                         // Trọng lượng tối đa
    cb_ItemLock[MAX_PLAYER_CB_ITEM],         // Khóa slot (84)
    cb_ItemID[MAX_PLAYER_CB_ITEM],           // ID vật phẩm (84)
    Float:cb_ItemWeight[MAX_PLAYER_CB_ITEM], // Trọng lượng item (84)
    cb_ItemDurability[MAX_PLAYER_CB_ITEM],   // Độ bền (84)
    cb_ItemAmount[MAX_PLAYER_CB_ITEM]        // Số lượng/ammo (84)
};
```

### Trạng thái slot:
| Giá trị | Ý nghĩa |
|---------|---------|
| `cb_ItemLock[i] == 1` | Slot bị khóa (hiện icon khóa) |
| `cb_ItemLock[i] == 0 && cb_ItemID[i] == INVALID_OBJECT_ID` | Slot trống (hiện icon null) |
| `cb_ItemLock[i] == 0 && cb_ItemID[i] != INVALID_OBJECT_ID` | Slot có item (hiện sprite item) |

### Trạng thái mặc định khi tạo mới:
- Tab chính [0]: 13 slots mở (index 0-12), 71 slots khóa (index 13-83)
- Tab vũ khí [1]: Tất cả 7 slots mở
- Weight mặc định: 60.0 (tab chính), 30.0 (tab vũ khí = Weight/2)
- Tất cả itemID = INVALID_OBJECT_ID
- Tất cả amount/weight/durability = 0

---

## 4. DANH SÁCH ITEMS (50 ITEMS)

| ID | Tên (VN) | Tên (EN) | Loại | SA Weapon ID | Model Custom |
|----|----------|----------|------|-------------|-------------|
| 1 | Camera | Camera | Weapon | 43 | - |
| 2 | Minigun | Minigun | Weapon | 38 | - |
| 3 | Khoang san bac | Silver Ore | Material | - | - |
| 4 | Khoang san niken | Nickel Ore | Material | - | - |
| 5 | Khoang san vang | Gold Ore | Material | - | - |
| 6 | Khoang san Cu (Dong) | Copper Ore | Material | - | - |
| 7 | Khoang san Crom | Chromium Ore | Material | - | - |
| 8 | May dao thuong | Normal Excavator | Tool | -1000 | DFF: flamednormal.dff |
| 9 | May dao VIP | VIP Excavator | Tool | -1001 | DFF: flamedvip.dff |
| 10 | Coin Exchange (gp -> coin) | GP→Coin Converter | Consumable | - | - |
| 11 | Medkit | Medkit | Consumable | - | - |
| 12 | Thuoc gatacetamol | Gatacetamol | Consumable | - | - |
| 13 | Phieu mo rong tui do | Bag Expansion Card | Consumable | - | - |
| 14 | The GP Bonus 30% | GP Bonus Card | Consumable | - | - |
| 15 | The EXP Bonus 10% | EXP Bonus 10% | Consumable | - | - |
| 16 | The EXP Bonus 20% | EXP Bonus 20% | Consumable | - | - |
| 17 | The EXP Bonus 30% | EXP Bonus 30% | Consumable | - | - |
| 18 | Hom trang phuc Event Vietnam Capsule | Costume Box | Box | - | - |
| 19 | Hom xe Event Vietnam Capsule | Vehicle Box | Box | - | - |
| 20 | Hom Toy Event Vietnam Capsule | Toy Box | Box | - | - |
| 21 | Jerry can (100 lit) | Jerry Can 100L | Fuel | - | - |
| 22 | Jerry can (200 lit) | Jerry Can 200L | Fuel | - | - |
| 23 | SD-Pistol | SD Pistol | Weapon | 22 | - |
| 24 | Colt-9mm | Colt 9mm | Weapon | 23 | - |
| 25 | Deagle | Desert Eagle | Weapon | 24 | - |
| 26 | Shotgun | Shotgun | Weapon | 25 | - |
| 27 | Sawn-Off | Sawn-Off | Weapon | 26 | - |
| 28 | Spas-12 | SPAS-12 | Weapon | 27 | - |
| 29 | Uzi | Micro Uzi | Weapon | 28 | - |
| 30 | Mp5 | MP5 | Weapon | 29 | - |
| 31 | AK | AK-47 | Weapon | 30 | - |
| 32 | M4 | M4 | Weapon | 31 | - |
| 33 | Tec9 | Tec-9 | Weapon | 32 | - |
| 34 | Rifle | Rifle | Weapon | 33 | - |
| 35 | Sniper | Sniper | Weapon | 34 | - |
| 36 | Da tho | Raw Stone | Material | - | - |
| 37 | Ca thu | Tuna | Fish | - | - |
| 38 | Ca ngu | Mackerel | Fish | - | - |
| 39 | Ca noc | Pufferfish | Fish | - | - |
| 40 | Ruou & thuoc la | Alcohol & Cigarettes | Job item | - | - |
| 41 | Hop dan tich hop | Ammo Box | Ammo | - | - |
| 42 | Combo GFC | GFC Combo | Food | - | - |
| 43 | Ban do kho bau | Treasure Map | Quest | - | DFF: TikiTreasure |
| 44 | M4 LAW | M4 LAW | Faction Weapon | 31 | - |
| 45 | AK LAW | AK LAW | Faction Weapon | 30 | - |
| 46 | Deagle LAW | Deagle LAW | Faction Weapon | 24 | - |
| 47 | 9mm LAW | 9mm LAW | Faction Weapon | 22 | - |
| 48 | MP5 LAW | MP5 LAW | Faction Weapon | 29 | - |
| 49 | Sword Katana | Katana | Weapon | 8 | - |
| 50 | Gay Bong Chay | Baseball Bat | Weapon | 5 | - |

---

## 5. ITEM WEIGHT SYSTEM

```pawn
stock Float:GetItemWeight(item) {
    switch(item) {
        case 1:     return 1.0;    // Camera
        case 2:     return 15.0;   // Minigun
        case 3..7:  return 4.0;    // Khoáng sản
        case 8..9:  return 10.0;   // Máy khai thác
        case 10:    return 0.2;    // Thẻ mở slot
        case 11:    return 1.2;    // Medkit
        case 12..17: return 0.4;   // Thẻ phiếu thuốc
        case 18..20: return 1.5;   // Box
        case 21..22: return 10.0;  // Jerry can
        case 23..25: return 3.0;   // Pistol (SD, Colt, Deagle)
        case 26..35: return 4.0;   // Vũ khí nặng (Shotgun→Sniper)
        case 36:    return 4.0;    // Đá thô
        case 37..39: return 1.2;   // Cá
        case 40:    return 0.4;    // Rượu & thuốc lá
        case 41:    return 2.0;    // Hộp đạn
        case 42:    return 0.4;    // Combo GFC
        case 43:    return 0.0;    // Bản đồ kho báu
        case 44,45,48: return 4.0; // M4, AK, MP5 LAW
        case 46,47: return 3.0;    // Deagle, 9mm LAW
        case 49:    return 2.1;    // Katana
        case 50:    return 2.1;    // Baseball Bat
    }
    return 0.0;
}
```

### Trọng lượng tối đa mặc định:
- Tab chính: **60.0 kg** (có item "Phieu mo rong tui do" để tăng)
- Tab vũ khí: **30.0 kg** (bằng 1/2 tab chính)

---

## 6. ITEM AMOUNT/STACK LIMITS

### Giới hạn số lượng cho non-weapon items:
```pawn
stock GetAmountItemLimit(item) {
    switch(item) {
        case 3..7:   return 250;   // Khoáng sản
        case 10..20: return 1;     // Consumables (không stack)
        case 21:     return 100;   // Jerry can 100L
        case 22:     return 200;   // Jerry can 200L
        case 36:     return 250;   // Đá thô
        case 37..39: return 60;    // Cá
        case 40:     return 60;    // Rượu & thuốc lá
        case 41:     return 1200;  // Hộp đạn
        case 42:     return 1;     // Combo GFC
        case 43:     return 1;     // Bản đồ kho báu
    }
    return 0;
}
```

### Giới hạn ammo cho weapon items:
```pawn
stock GetAmmoWeaponLimit(item) {
    switch(item) {
        case 1:     return 1;       // Camera
        case 2:     return 999999;  // Minigun
        case 8..9:  return 100;     // Máy khai thác (flame)
        case 23..25: return 29;     // Pistol
        case 26..28: return 60;     // Shotgun, Sawn-off, SPAS
        case 29..30: return 120;    // Uzi, MP5
        case 31..32: return 199;    // AK, M4
        case 33:    return 120;     // Tec9
        case 34..35: return 60;     // Rifle, Sniper
        case 44..45: return 199;    // M4, AK LAW
        case 46..47: return 29;     // Deagle, 9mm LAW
        case 48:    return 120;     // MP5 LAW
        case 49:    return 1;       // Katana
        case 50:    return 1;       // Baseball Bat
    }
    return 0;
}
```

---

## 7. WEAPON SYSTEM

### Ánh xảng Item ID → SA Weapon ID:
```pawn
stock GetIDWeapon(item) {
    switch(item) {
        case 1:  return 43;    // Camera
        case 2:  return 38;    // Minigun
        case 8:  return -1000; // Máy đào thường (custom model)
        case 9:  return -1001; // Máy đào VIP (custom model)
        case 23: return 22;    // SD-Pistol
        case 24: return 23;    // Colt-9mm
        case 25: return 24;    // Deagle
        case 26: return 25;    // Shotgun
        case 27: return 26;    // Sawn-Off
        case 28: return 27;    // Spas-12
        case 29: return 28;    // Uzi
        case 30: return 29;    // MP5
        case 31: return 30;    // AK
        case 32: return 31;    // M4
        case 33: return 32;    // Tec9
        case 34: return 33;    // Rifle
        case 35: return 34;    // Sniper
        case 44: return 31;    // M4 LAW
        case 45: return 30;    // AK LAW
        case 46: return 24;    // Deagle LAW
        case 47: return 22;    // 9mm LAW
        case 48: return 29;    // MP5 LAW
        case 49: return 8;     // Katana
        case 50: return 5;     // Baseball Bat
    }
    return 0;
}
```

### Weapon Type (cho kiểm tra trùng loại):
```pawn
stock GetWeaponType(item) {
    switch(item) {
        case 23..25: return 1;  // Pistol
        case 26..28: return 2;  // Shotgun
        case 29..30: return 3;  // SMG (Uzi, MP5)
        case 31..32: return 4;  // Assault (AK, M4)
        case 33:     return 3;  // Tec9 → SMG
        case 34..35: return 5;  // Rifle/Sniper
        case 44..45: return 4;  // LAW Assault
        case 46..47: return 1;  // LAW Pistol
        case 48:     return 3;  // LAW SMG
        case 49,50:  return 6;  // Melee
    }
    return 0;
}
```

### Logic mang vũ khí:
- Không được mang 2 vũ khí cùng loại (weapon type)
- Tab vũ khí [1] chỉ có 7 slots
- Ammo giảm khi bắn (`OnPlayerWeaponShot`)
- Khi chết: reset vũ khí trong tab [1] (trừ item 8, 9 là máy đào)

---

## 8. TEXTDRAW UI SYSTEM

### TextDraw Array
```pawn
new PlayerText: GTASA_Inventory[MAX_PLAYERS][2][62];
// [0][0..61] = Main inventory TextDraws (62 elements)
// [1][0..7]  = Info panel TextDraws (8 elements)
```

### Cấu trúc layout:

#### Tab chính [0]:
| Index | Sprite | Vị trí | Mô tả |
|-------|--------|--------|-------|
| [0] | `mdl-2002:bg_main` | 470, 134 (164x274) | Background chính |
| [1] | `mdl-2002:bg_character` | 307, 134 (164x209) | Background character panel |
| [2] | `mdl-2002:btn_cancel` | 617, 143 (10x11) | Nút đóng (selectable) |
| [3] | `mdl-2002:btn_select` | 573, 372 (53x13) | Nút chọn (selectable) |
| [4] | `mdl-2002:btn_character` | 573, 387 (53x13) | Nút character panel (selectable) |
| [5] | Font 5 (3D preview) | 440, 309 (27x21) | Player preview model |
| [6..12] | `mdl-2002:item_lock` | Cột trái (316-439, 170-262) | **7 weapon slots** (selectable) |
| [13..54] | `mdl-2002:item_lock` | Grid phải (479-603, 166-336) | **42 main slots** (selectable) |
| [55] | `mdl-2002:item_progress_colweight` | - | Weight progress bar |
| [56] | `mdl-2002:item_progress_coladventure` | - | Adventure progress bar |
| [57] | Text | - | GP display |
| [58] | Text | - | Coin display |
| [59] | `LD_BEAT:left` | 540, 364 (6x6) | Page prev (selectable) |
| [60] | `LD_BEAT:right` | 559, 364 (6x6) | Page next (selectable) |
| [61] | Text "1/2" | - | Page indicator |

#### Weapon slots layout (7 slots, cột trái):
```
[6]  → 316, 170  (23x26)
[7]  → 316, 201
[8]  → 316, 232
[9]  → 316, 262
[10] → 439, 170
[11] → 439, 201
[12] → 439, 232
```

#### Main grid layout (42 slots, 7 hàng x 6 cột):
```
Hàng 1 (y=166): [13] [14] [15] [16] [17] [18]   x: 479, 504, 529, 554, 578, 603
Hàng 2 (y=194): [19] [20] [21] [22] [23] [24]
Hàng 3 (y=222): [25] [26] [27] [28] [29] [30]
Hàng 4 (y=251): [31] [32] [33] [34] [35] [36]
Hàng 5 (y=280): [37] [38] [39] [40] [41] [42]
Hàng 6 (y=308): [43] [44] [45] [46] [47] [48]
Hàng 7 (y=336): [49] [50] [51] [52] [53] [54]
```

Mỗi slot: 22x25 pixel, selectable.

#### Info panel [1] (hiện khi chọn item, 8 TextDraws):
**Lưu ý:** Vị trí thay đổi dựa trên `Inventory_Character[playerid]`:
- Character panel mở (case 1): anchor x=147, y=133
- Character panel đóng (default): anchor x=306, y=133

| Index | Sprite/Text | Vị trí (default) | Mô tả |
|-------|------------|------------------|-------|
| [0] | `mdl-2002:item_info` | 306, 133 (164x167) | Background info panel |
| [1] | `mdl-2002:item_progress_colplus` | 353, 174 (61x7) | Weight bar của item |
| [2] | `mdl-2002:item_progress_colplus` | 353, 188 (61x7) | Durability bar |
| [3] | Text "ITEM_NULL" | 349, 145 | Tên item |
| [4] | Text "NULL" | 353, 159 | Serial/info |
| [5] | Text "100/200" | 352, 203 | Amount display (non-weapon) |
| [6] | Text "50/200" | 361, 218 | Ammo display (weapon) |
| [7] | Text description | 322, 250 | Mô tả item (word wrap ~n~) |

### Logic hiển thị slot:
```pawn
if(cb_ItemLock[i] == 1)                     → "mdl-2002:item_lock"
if(cb_ItemLock[i] == 0 && cb_ItemID[i] == -1) → "mdl-2002:item_null"
if(cb_ItemLock[i] == 0 && cb_ItemID[i] != -1) → GetItemMDL(cb_ItemID[i])  // sprite item
```

### Paging:
- Trang 1: Slots 0-41 (hiển thị textdraw indices 13-54)
- Trang 2: Slots 42-83 (hiển thị textdraw indices 13-54, remap index: `z - 29`)

---

## 9. DFF/TXD CUSTOM MODEL SYSTEM

### File: `models/artconfig.txt`

#### Custom Skins (AddCharModel):
```
AddCharModel(0, 20001, "./skincustom/gasman.dff", "./skincustom/gasman.txd");
AddCharModel(0, 20002, "./skincustom/CJeano.dff", "./skincustom/CJeano.txd");
AddCharModel(0, 20003, "./skincustom/0002.dff", "./skincustom/0002.txd");
AddCharModel(72, 20004, "./skincustom/GhostRiderMFF.dff","./skincustom/GhostRiderMFF.txd");
AddCharModel(155, 20005, "./skincustom/Leonrpd.dff","./skincustom/Leonrpd.txd");
AddCharModel(291, 20006, "./skincustom/dwmolc2.dff","./skincustom/dwmolc2.txd");
AddCharModel(211, 20007, "./skincustom/ofyst.dff","./skincustom/ofyst.txd");
AddCharModel(294, 20008, "./skincustom/male01.dff","./skincustom/male01.txd");
AddCharModel(294, 20009, "./skincustom/swmyhp1.dff","./skincustom/swmyhp1.txd");
```

#### Custom Item Objects (AddSimpleModel - base 386):
```
AddSimpleModel(-1, 386, -1000, "./item/flamednormal.dff", "./item/flamednormal.txd");  // Normal Excavator
AddSimpleModel(-1, 386, -1001, "./item/flamedvip.dff", "./item/flamedvip.txd");          // VIP Excavator
AddSimpleModel(-1, 386, -1002, "./item/TikiTreasure.dff", "./item/TikiTreasure.txd");   // Tiki Treasure
AddSimpleModel(-1, 386, -1003, "./item/schiffer.dff", "./item/schiffer.txd");            // Schiffer
AddSimpleModel(-1, 386, -1004, "./item/alex-freeway.dff", "./item/alex-freeway.txd");    // Freeway
AddSimpleModel(-1, 386, -1005, "./item/alex-nrg500.dff", "./item/alex-nrg500.txd");      // NRG 500
AddSimpleModel(-1, 386, -1006, "./item/alex-sanchez.dff", "./item/alex-sanchez.txd");    // Sanchez
```

#### TextDraw Texture Models (base 19379 - dùng cho UI sprites):
```
AddSimpleModel(-1, 19379, -2000, "./textdraw/object.dff", "./textdraw/sa-mp_screen.txd");
AddSimpleModel(-1, 19379, -2001, "./textdraw/object.dff", "./textdraw/gtasa_guide.txd");
AddSimpleModel(-1, 19379, -2002, "./textdraw/object.dff", "./textdraw/gtasa_character.txd");  // ← INVENTORY UI
AddSimpleModel(-1, 19379, -2003, "./textdraw/object.dff", "./textdraw/gtasa_shop.txd");
AddSimpleModel(-1, 19379, -2004, "./textdraw/object.dff", "./textdraw/task_farm-daily.txd");
AddSimpleModel(-1, 19379, -2005, "./textdraw/object.dff", "./textdraw/caribbean.txd");
AddSimpleModel(-1, 19379, -2006, "./textdraw/object.dff", "./textdraw/khobaumap.txd");
```

### Bảng tổng hợp Custom Model IDs:

| Model ID | Type | File DFF | File TXD | Usage |
|----------|------|----------|----------|-------|
| 20001-20009 | CharModel | skincustom/*.dff | skincustom/*.txd | Custom player skins |
| -1000 | SimpleModel (386) | item/flamednormal.dff | item/flamednormal.txd | Normal Excavator (weapon) |
| -1001 | SimpleModel (386) | item/flamedvip.dff | item/flamedvip.txd | VIP Excavator (weapon) |
| -1002 | SimpleModel (386) | item/TikiTreasure.dff | item/TikiTreasure.txd | Tiki Treasure object |
| -1003 | SimpleModel (386) | item/schiffer.dff | item/schiffer.txd | Schiffer object |
| -1004 | SimpleModel (386) | item/alex-freeway.dff | item/alex-freeway.txd | Freeway vehicle |
| -1005 | SimpleModel (386) | item/alex-nrg500.dff | item/alex-nrg500.txd | NRG 500 vehicle |
| -1006 | SimpleModel (386) | item/alex-sanchez.dff | item/alex-sanchez.txd | Sanchez vehicle |
| -2000 | SimpleModel (19379) | textdraw/object.dff | textdraw/sa-mp_screen.txd | SA-MP screen UI |
| -2001 | SimpleModel (19379) | textdraw/object.dff | textdraw/gtasa_guide.txd | Guide UI |
| **-2002** | **SimpleModel (19379)** | **textdraw/object.dff** | **textdraw/gtasa_character.txd** | **INVENTORY UI** |
| -2003 | SimpleModel (19379) | textdraw/object.dff | textdraw/gtasa_shop.txd | Shop UI |
| -2004 | SimpleModel (19379) | textdraw/object.dff | textdraw/task_farm-daily.txd | Farm task UI |
| -2005 | SimpleModel (19379) | textdraw/object.dff | textdraw/caribbean.txd | Caribbean UI |
| -2006 | SimpleModel (19379) | textdraw/object.dff | textdraw/khobaumap.txd | Treasure map UI |

### Item Sprite Textures trong TXD `gtasa_character.txd` (model -2002):

Đây là các sprite names được dùng trong TextDraw:
```
mdl-2002:bg_main                    // Background chính
mdl-2002:bg_character               // Background character panel
mdl-2002:btn_cancel                 // Nút đóng
mdl-2002:btn_select                 // Nút chọn
mdl-2002:btn_character              // Nút character
mdl-2002:item_lock                  // Icon khóa slot
mdl-2002:item_null                  // Icon slot trống
mdl-2002:item_progress_colweight    // Progress bar trọng lượng
mdl-2002:item_progress_coladventure // Progress bar adventure
mdl-2002:item_progress_colplus      // Progress bar info panel
mdl-2002:item_info                  // Info panel background
mdl-2002:item_camera                // Item: Camera
mdl-2002:item_minigun               // Item: Minigun
mdl-2002:item_kssilver              // Item: Khoáng sản bạc
mdl-2002:item_ksniken               // Item: Khoáng sản niken
mdl-2002:item_ksgold                // Item: Khoáng sản vàng
mdl-2002:item_kscu                  // Item: Khoáng sản đồng
mdl-2002:item_kscrom                // Item: Khoáng sản crom
mdl-2002:item_flamednormal          // Item: Máy đào thường
mdl-2002:item_flamedvip             // Item: Máy đào VIP
mdl-2002:item_coinexchange          // Item: Coin Exchange
mdl-2002:item_medkit                // Item: Medkit
mdl-2002:item_gatacetamol           // Item: Gatacetamol
mdl-2002:item_slotcard              // Item: Slot card
mdl-2002:item_gp_bonus_30           // Item: GP Bonus 30%
mdl-2002:item_exp_bonus_10          // Item: EXP Bonus 10%
mdl-2002:item_exp_bonus_20          // Item: EXP Bonus 20%
mdl-2002:item_exp_bonus_30          // Item: EXP Bonus 30%
mdl-2002:item_box                   // Item: Box (3 loại box chung 1 sprite)
mdl-2002:item_jerrycan              // Item: Jerry can
mdl-2002:item_sdpistol              // Item: SD-Pistol
mdl-2002:item_colt45                // Item: Colt-9mm
mdl-2002:item_deagle                // Item: Deagle
mdl-2002:item_shotgun               // Item: Shotgun
mdl-2002:item_sawnoff               // Item: Sawn-Off
mdl-2002:item_spas12                // Item: Spas-12
mdl-2002:item_uzi                   // Item: Uzi
mdl-2002:item_mp5                   // Item: MP5
mdl-2002:item_ak                    // Item: AK
mdl-2002:item_m4                    // Item: M4
mdl-2002:item_tec9                  // Item: Tec9
mdl-2002:item_rifle                 // Item: Rifle
mdl-2002:item_sniper                // Item: Sniper
mdl-2002:item_datho                 // Item: Đá thô
mdl-2002:item_cathu                 // Item: Cá thu
mdl-2002:item_cangu                 // Item: Cá ngừ
mdl-2002:item_canoc                 // Item: Cá nóc
mdl-2002:item_ruouthuocla           // Item: Rượu & thuốc lá
mdl-2002:item_ammo-box              // Item: Hộp đạn
mdl-2002:item_combo-gfc             // Item: Combo GFC
mdl-2002:item_m4law                 // Item: M4 LAW
mdl-2002:item_aklaw                 // Item: AK LAW
mdl-2002:item_deaglelaw             // Item: Deagle LAW
mdl-2002:item_9mmlaw                // Item: 9mm LAW
mdl-2002:item_mp5law                // Item: MP5 LAW
mdl-2002:item_swordkatana           // Item: Katana
mdl-2002:item_baseballbat           // Item: Baseball Bat
```

Sprite từ TXD khác:
```
mdl-2006:bandokhobau                // Item: Bản đồ kho báu (từ gtasa_shop.txd model -2006)
```

Sprite từ SA-MP built-in (Font 4):
```
LD_BEAT:left                        // Page prev arrow [59]
LD_BEAT:right                       // Page next arrow [60]
```

### Native functions cho custom models (omp_object.inc):
```pawn
native AddCharModel(baseid, newid, dff[], textureLibrary[]);
native AddSimpleModel(virtualWorld, baseid, newid, dff[], textureLibrary[]);
native AddSimpleModelTimed(virtualWorld, baseid, newid, dff[], textureLibrary[], timeOn, timeOff);
native GetCustomModelPath(modelid, dffPath[], dffSize, txdPath[], txdSize);
native IsValidCustomModel(modelid);
```

---

## 10. CORE FUNCTIONS

### Tạo TextDraw Inventory
```pawn
Function: CPTD_Inventory(playerid)    // line 134 - Tạo tất cả PlayerTextDraw cho inventory
Function: CPTD_InventoryInfo(playerid) // line ~870 - Tạo info panel TextDraws
```

### Inventory State Machine
```pawn
Function: Inventory_Action(playerid, action)  // line 974
// action:
//   -1 = Reset state vars
//    0 = Mở inventory (tạo TextDraw, show, start timer)
//    1 = Cập nhật hiển thị slot items
//    2 = Toggle character panel (hiện/ẩn weight bar, player model)
//    3 = Mở dialog action cho item đã chọn
//    4 = Hiển thị info panel cho item đã chọn
```

### Page Navigation
```pawn
Function: Inventory_SetPost(playerid, post)  // line 1214
// post 1 = Hiển thị slots 0-41 (page 1)
// post 2 = Hiển thị slots 42-83 (page 2)
```

### Item Management
```pawn
stock SetPlayerItem(playerid, id, amount, &succes)    // line 1382 - Set item vào slot trống (không stack)
stock GivePlayerItem(playerid, id, amount)             // line 1461 - Give item với stacking logic
stock RemovePlayerItem(playerid, index)                // line 1554 - Xóa item khỏi slot
stock Inventory_AddItem(source, targetid, id, stack)   // line 1563 - Add item với transfer support
stock Inventory_CountSlot(playerid, stack, &slot)      // line 1653 - Tìm slot trống
```

### Item Info Functions
```pawn
stock GetItemInfo(item)                // line 1667 - Mô tả item (Vietnamese)
stock GetAmountItemLimit(item)         // line 1701 - Max stack amount
stock GetAmmoWeaponLimit(item)         // line 1719 - Max ammo cho weapon
stock GetIDWeapon(item)                // line 1741 - Map inventory ID → SA weapon ID
stock GetWeaponType(item)              // line 1773 - Weapon category
stock GetItemMDL(item)                 // line 1791 - Sprite texture name cho TextDraw
stock GetItemName(item)                // line 1850 - Tên hiển thị
stock GetItemWeight(item)              // line 42   - Trọng lượng mỗi unit
```

### Weapon Management
```pawn
Function: SetPlayerWeapons(playerid)      // line 1281 - Set weapons từ inventory tab [1]
Function: SetPlayerWeaponsEx(playerid)    // line 1306 - Set weapons + armed weapon
stock GivePlayerValidWeaponEx(playerid, weaponid, ammo)  // line 1331 - Give weapon với ammo
Function: TakeAmmoDeathPlayer(playerid)   // line 1266 - Reset weapons khi chết
```

### Utility
```pawn
stock GivePlayerEA(playerid, amount)  // line 1370 - Give Energy/Addition points
stock GivePlayerGP(playerid, amount)  // line 1376 - Give GP points
```

---

## 11. COMMANDS

### User Commands
| Command | Line | Mô tả |
|---------|------|-------|
| `/tuido` | 3657 | Mở inventory. Auto-detect mobile → chuyển sang dialog. Kiểm tra trạng thái (logged in, cuffed, injured, event, etc.) |
| `/tuidomobile` | 3690 | Mở inventory dạng dialog (cho mobile users) |
| `/closeinv` | 3701 | Đóng inventory, destroy TextDraws, reset state |

### Admin Commands
| Command | Line | Mô tả |
|---------|------|-------|
| `/gtasa_givemyitem` | 3733 | Admin 1337+: Give item cho chính mình (dialog chọn item + số lượng) |
| `/giftplayeritem` | 3560 | Admin 1338+: Give item cho player khác. USAGE: `/giftplayeritem [playerid] [so luong]` → dialog chọn item → confirm |

### Logic trong `/tuido`:
```pawn
CMD:tuido(playerid, params[]) {
    if(gPlayerLogged{playerid}) {
        // Kiểm tra: GuideTimer, EventToken, Cuffed, Bagged, Injured, Frozen
        // Kiểm tra: Inventory_Show (đã mở chưa)
        // Kiểm tra: Event_Show, TaskFarm_Show
        // Fix weight 45.0 → 60.0
        // Unlock slots 11-12 nếu bị khóa
        if(IsPlayerUsingSampMobile(playerid)) return cmd_tuidomobile(playerid, params);
        else return Inventory_Action(playerid, 0);
    }
}
```

---

## 12. DIALOG SYSTEM

**Lưu ý quan trọng:** Dialog IDs trong Rgame2018 sử dụng hệ thống `Dialog:` callback (auto-hash từ tên string), KHÔNG phải `#define` constants. Ví dụ: `Dialog:DIALOG_INVENTORY_ACTION(playerid, response, listitem, inputtext[])` tự động tạo dialog ID từ hash của string "DIALOG_INVENTORY_ACTION".

### Dialog: DIALOG_INVENTORY_ACTION (line 2786)
```pawn
// PC TextDraw mode - Khi click nút "Select" hoặc click item:
// Tab chính [0]: "- Su dung\n- {FF0000}Xoa bo\n- Phan tach\n- Ghep lai"
//   + Nếu Jerry can (21,22): "+ Tieu thu nhien lieu"
//   + Nếu admin 1337+: "+ Admin Panel"
// Tab vũ khí [1]: "- Mang len nguoi\n- Go xuong\n- {FF0000}Xoa bo"
//   + Nếu admin 1337+: "+ Admin Panel"
```

### Dialog: DIALOG_INVENTORY_AMB (line 2322)
```pawn
// Mobile mode - Action dialog:
// "- Su dung\n- {FF0000}Xoa bo"
// "- Mang len nguoi\n- {FF0000}Go xuong"
```

### Dialog: DIALOG_INVMOBILE_CHOICE (line 2214)
```pawn
// Chọn chế độ xem:
// "Tui do custom (PC - TextDraw)"
// "Tui do mobile (Dialog)"
// "Danh sach vat pham so huu"   → DIALOG_LIST_ITEMINV
// "Danh sach trang bi dang mang" → DIALOG_LIST_ITEMINV2
```

### Dialog: DIALOG_LIST_ITEMINV (line 2268)
```pawn
// Tab list items chính: "Ten vat pham\tSo luong\tSo KG\tDo ben"
// Hiển thị tất cả 84 slots dưới dạng tablist
// Click → DIALOG_INVENTORY_AMB
```

### Dialog: DIALOG_LIST_ITEMINV2 (line 2295)
```pawn
// Tab list vũ khí: "Ten vat pham\tSo luong\tSo KG\tDo ben"
// Hiển thị 7 weapon slots
// Click → DIALOG_INVENTORY_AMB
```

### Dialog: DIALOG_AMMOBOX_WPChoice (line 3503)
```pawn
// Khi sử dụng "Hop dan tich hop" (item 41):
// Tablist: "Slot\tVu khi\tSo dan"
// Hiển thị 7 weapon slots với ammo hiện tại / max
// Cho phép nap dan tu hop dan vao vu khi
```

### Dialog: DG_EXCHANGE_COIN (line 3459)
```pawn
// Khi sử dụng "Coin Exchange" (item 10):
// Step 1: MSGBOX hiển thị bảng quy đổi GP → Coin
// Step 2: INPUT nhập số coin muốn đổi
// Quy đổi: 1 coin = 1,000 GP
```

### Dialog: DG_PASS_FISH (line 3404)
```pawn
// Khi bán hải sản (items 37-39) cho nhà hàng:
// INPUT nhập số lượng hải sản muốn bán
// Giá random: $2000, $3000, $4000 per unit
```

### Dialog: DIALOG_AGPITEM (line 3594)
```pawn
// Admin: Chọn item từ list 50 items → DIALOG_AGPITEM2
```

### Dialog: DIALOG_AGPITEM2 (line 3614)
```pawn
// Admin: Confirm give item → SetPlayerItem() + log admin action
```

### Dialog: DG_INVENTORY_GIVE_ITEM (line 3745)
```pawn
// Admin 1337+ self-give: List 50 items → chọn số lượng
```

---

## 13. MYSQL SAVE/LOAD

### Load (khi player join):
```pawn
Function: Inventory_CallData(playerid)    // line 2117
// Query: SELECT * FROM inventory WHERE SQLId = %d
// Callback: Inventory_GetData(playerid)

Function: Inventory_GetData(playerid)      // line 2125
// Nếu rows > 0: Load tất cả fields (Weight, ItemLock0..83, ItemID0..83, etc.)
// Nếu rows == 0: INSERT mới + set defaults (Weight=60, 13 slots mở, 71 khóa)
```

### Save:
```pawn
stock Inventory_SaveData(playerid)         // line 2059
// Save Weight, Weight2
// Loop 84 slots tab [0]: ItemLock, ItemID, ItemWeight, ItemDurability, ItemAmount
// Loop 7 slots tab [1]: Item2Lock, Item2ID, Item2Weight, Item2Durability, Item2Amount
```

### MySQL Helper:
```pawn
stock Inventory_SavePlayerInt(sqlId, fieldname[], arg)     // line 2101
// UPDATE inventory SET `%s` = %d WHERE SQLId = %d

stock Inventory_SavePlayerFloat(sqlId, fieldname[], arg)   // line 2109
// UPDATE inventory SET `%s` = '%.2f' WHERE SQLId = %d
```

**Lưu ý:** Save từng field riêng lẻ (không batch update) → nhiều queries.

---

## 14. ITEM DROP & PICKUP

### Các file liên quan:
- `gamemodes/modules/useitemgain.inc` - TextDraw popup khi nhặt item
- `gamemodes/modules/famed-mission.inc` - Treasure map system

### Item Use Actions (từ code DIALOG_INVENTORY_AMB và DIALOG_INVENTORY_ACTION):

| Item ID | Action | Chi tiết |
|---------|--------|----------|
| 8, 9 | Máy đào | Equip tab vũ khí (weapon type check) |
| 10 | Coin Exchange | Dialog GP → Coin (1:1000 ratio) |
| 11 | Medkit | ItemGain timer 15s, hồi máu |
| 12 | Gatacetamol | ItemGain timer, tăng hiệu suất |
| 13 | Slot Card | Tăng thêm 1 slot mở |
| 14-17 | Bonus Cards | Kích hoạt bonus GP/EXP theo tỷ lệ |
| 18 | Costume Box | Random skin từ event |
| 19 | Vehicle Box | Random xe từ event |
| 20 | Toy Box | Random toy từ event |
| 21, 22 | Jerry can | "Tieu thu nhien lieu" - đổ xăng cho xe |
| 23-35 | Vũ khí | Equip vào tab vũ khí (7 slots, check trùng loại) |
| 37-39 | Hải sản | Bán cho nhà hàng (DG_PASS_FISH, giá random $2000-4000) |
| 41 | Hộp đạn | Nap dan vao vũ khí đang equip (DIALOG_AMMOBOX_WPChoice) |
| 43 | Bản đồ kho báu | Mở TextDraw bản đồ (ShowBDKBTimer) |
| 44-50 | LAW weapons + Melee | Equip tab vũ khí |

### Logic drop (từ dialog action):
- "Xoa bo" = RemovePlayerItem(slot) → item biến mất (không drop ra ground)
- Không có hệ thống drop item ra ground visible trong inventory.inc

### Item gain popup (useitemgain.inc):
```pawn
// File: gamemodes/modules/useitemgain.inc
enum usg_Info {
    usg_ItemID[4],     // ID item đang active (tối đa 4 cùng lúc)
    usg_ItemTimer[4]   // Timer đếm ngược per item
};
new UseItemGain[MAX_PLAYERS][usg_Info];
new PlayerText: PTD_ItemGain[MAX_PLAYERS][8];  // 8 TextDraws: 4 sprite + 4 timer text

// Sprite items: positions 111, 131, 151, 171 (y=423), size 18x21
// Timer text: positions 120, 140, 160, 180 (y=430), font 1

// ItemGain(playerid, action):
//   action 1 = Check nếu item đã có timer → reset timer
//   action 2 = Tìm slot trống, tạo TextDraw, show
//   action 3 = Timer tick (1s), giảm timer, ẩn khi = 0
//   action 4 = Apply effect khi timer = 0 (hồi máu, bonus, etc.)
```

---

## 15. TRADING SYSTEM

### File: `gamemodes/modules/tradenewitem.inc`
- Hệ thống trade giữa 2 players
- Tách biệt khỏi inventory.inc

### File: `gamemodes/modules/sellgunnew.inc`
- Hệ thống bán vũ khí

---

## 16. ADDITIONAL RELATED FILES

| File | Mô tả |
|------|-------|
| `gamemodes/modules/inventory.inc` | **MODULE CHÍNH** (4268 dòng) |
| `gamemodes/modules/tradenewitem.inc` | Player-to-player item trading |
| `gamemodes/modules/sellgunnew.inc` | Weapon selling system |
| `gamemodes/modules/useitemgain.inc` | Item gain popup TextDraws (8 PTDs: 4 sprite items + 4 timer text) |
| `gamemodes/modules/guide.inc` | Guide system, links to inventory |
| `gamemodes/modules/gs-utils.inc` | VIP locker / organization locker item access |
| `gamemodes/modules/famed-mission.inc` | Treasure map item in inventory |
| `gamemodes/includes/business/businesscore.pwn` | Business inventory (separate) |
| `gamemodes/includes/enums.pwn` | StoreItemCostEnum, ShopItem, dgItems |
| `gamemodes/includes/defines.pwn` | ITEM_* constants (line 301-320), MAX_PLAYER_TD_* (line 1627-1628) |
| `gamemodes/includes/variables.pwn` | Inventory_Show[MAX_PLAYERS] (line 2720) |
| `gamemodes/includes/callbacks.pwn` | ESC handler → closeinv (line 845) |
| `gamemodes/modules/vehiclesinfo/upgradevehiclehealth.inc` | Uses ITEM_COPPER_ORE (6) |
| `inventory.sql` | Standalone SQL schema |
| `gtasa (15).sql` | Full DB dump với inventory table |
| `models/artconfig.txt` | Custom model registrations |

### Bảng `backpacks` trong SQL dump (Rgame2018 only):

**Đây là bảng cho VISUAL backpack object (phần nhìn thấy trên nhân vật), KHÔNG phải inventory items.**

```sql
CREATE TABLE `backpacks` (
  `id` int(11) NOT NULL,
  `BEquipped` int(11) NOT NULL DEFAULT 0,       -- 0=không mang, 1=đang mang
  `BStoredH` int(11) NOT NULL DEFAULT -1,       -- House ID lưu trữ (-1 = none)
  `BStoredV` int(11) NOT NULL DEFAULT 0,        -- Vehicle ID lưu trữ
  `posX` float NOT NULL DEFAULT 0,              -- Vị trí attach X
  `posY` float NOT NULL DEFAULT 0,              -- Vị trí attach Y
  `posZ` float NOT NULL DEFAULT 0,              -- Vị trí attach Z
  `rotX` float NOT NULL DEFAULT 0,              -- Góc xoay X
  `rotY` float NOT NULL DEFAULT 0,              -- Góc xoay Y
  `rotZ` float NOT NULL DEFAULT 0,              -- Góc xoay Z
  `scaleX` float NOT NULL DEFAULT 0,            -- Scale X
  `scaleY` float NOT NULL DEFAULT 0,            -- Scale Y
  `scaleZ` float NOT NULL DEFAULT 0,            -- Scale Z
  `color` mediumint(8) UNSIGNED NOT NULL DEFAULT 16777215  -- Màu (white default)
);
```

**Lưu ý:** Không tìm thấy code .inc/.pwn nào reference bảng `backpacks` trong gamemodes → có thể là unused/orphaned table hoặc được dùng bởi hệ thống khác chưa được include.

### Store Items (tách biệt, trong accounts table):
```pawn
// defines.pwn line 301-320
#define ITEM_CELLPHONE      1
#define ITEM_PHONEBOOK       2
#define ITEM_DICE            3
#define ITEM_CONDOM          4
#define ITEM_MUSICPLAYER     5
#define ITEM_ROPE            6
#define ITEM_CIGAR           7
#define ITEM_SPRUNK          8
#define ITEM_VEHICLELOCK     9
#define ITEM_SPRAYCAN        10
#define ITEM_RADIO           11
#define ITEM_CAMERA          12
#define ITEM_LOTTERYTICKET   13
#define ITEM_CHECKBOOK       14
#define ITEM_PAPERS          15
#define ITEM_ILOCK           16
#define ITEM_ELOCK           17
#define ITEM_SCALARM         18
#define ITEM_HELMET          19
#define ITEM_RAG             20
```

**Lưu ý:** Store items (ITEM_CELLPHONE etc.) là hệ thống **KHÁC** với inventory items (Inventory_ListItems). Store items lưu trong accounts table dạng `mInventory` varchar(255) phân tách bằng `|`.

---

## TÓM TẮT KIẾN TRÚC

```
Rgame2018 Server
├── models/artconfig.txt          ← Đăng ký custom DFF/TXD models
│   ├── skincustom/*.dff/.txd     ← Custom player skins (ID 20001-20009)
│   ├── item/*.dff/.txd           ← Custom item objects (ID -1000 to -1006)
│   └── textdraw/*.dff/.txd       ← TextDraw UI textures (ID -2000 to -2006)
│       └── gtasa_character.txd   ← Inventory UI sprites (model -2002)
│
├── inventory.sql                 ← Bảng inventory riêng (84+7 slots)
│
├── gamemodes/modules/
│   ├── inventory.inc             ← MODULE CHÍNH (4268 dòng)
│   │   ├── Enum cb_Info          ← Data structure
│   │   ├── CPTD_Inventory()      ← Tạo TextDraw UI
│   │   ├── Inventory_Action()    ← State machine
│   │   ├── GetItem*()            ← Item info functions
│   │   ├── GivePlayerItem()      ← Give với stacking
│   │   ├── SetPlayerItem()       ← Set slot
│   │   ├── RemovePlayerItem()    ← Remove
│   │   ├── Inventory_SaveData()  ← MySQL save
│   │   ├── Inventory_CallData()  ← MySQL load
│   │   ├── CMD:tuido             ← Main command
│   │   └── OnPlayerClickPlayerTD ← TextDraw click handler
│   ├── tradenewitem.inc          ← Trading
│   ├── sellgunnew.inc            ← Gun selling
│   ├── useitemgain.inc           ← Item gain popup
│   └── gs-utils.inc              ← Locker access
│
└── gamemodes/includes/
    ├── defines.pwn               ← ITEM_* constants (store items)
    ├── enums.pwn                 ← PlayerInfo enum
    └── business/businesscore.pwn ← Business inventory (separate)
```
