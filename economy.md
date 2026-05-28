# PHÂN TÍCH NỀN KINH TẾ - NGG-zin-viethoa SA-MP Server

> **Tác giả**: Kilo - Nhà kinh tế & Quản trị đô thị  
> **Ngày phân tích**: 28/05/2026  
> **Mục đích**: Đánh giá toàn diện nền kinh tế trong game, phát hiện mất cân đối và đề xuất cải cách

---

## MỤC LỤC

1. [Tổng quan nền kinh tế](#1-tổng-quan-nền-kinh-tế)
2. [Nguồn thu nhập - Legal Jobs](#2-nguồn-thu-nhập---legal-jobs)
3. [Nguồn thu nhập - Illegal Jobs](#3-nguồn-thu-nhập---illegal-jobs)
4. [Hệ thống kiếm tiền khác](#4-hệ-thống-kiếm-tiền-khác)
5. [Phân tích chi tiêu người chơi](#5-phân-tích-chi-tiêu-người-chơi)
6. [Phân tích lạm phát & dòng tiền](#6-phân-tích-lạm-phát--dòng-tiền)
7. [Đánh giá cân bằng kinh tế](#7-đánh-giá-cân-bằng-kinh-tế)
8. [Đề xuất cải cách](#8-đề-xuất-cải-cách)
9. [Nền kinh tế Materials (Mats)](#9-nền-kinh-tế-materials-mats)
10. [Hệ thống chế tạo vũ khí (Crafting)](#10-hệ-thống-chế-tạo-vũ-khí-crafting)
11. [Tác động VIP đến nền kinh tế](#11-tác-động-vip-đến-nền-kinh-tế)
12. [Phân tích hình phạt chết (Death Penalty)](#12-phân-tích-hình-phạt-chết-death-penalty)
13. [Đánh giá hiệu quả Money Sinks](#13-đánh-giá-hiệu-quả-money-sinks)
14. [Điều kiện bắt đầu cho người mới](#14-điều-kiện-bắt-đầu-cho-người-mới)
15. [Hệ thống nhiên liệu xe chi tiết](#15-hệ-thống-nhiên-liệu-xe-chi-tiết)
16. [Nền kinh tế trong tù (Prison Economy)](#16-nền-kinh-tế-trong-tù-prison-economy)
17. [Bảo vệ kinh tế & Anti-Cheat](#17-bảo-vệ-kinh-tế--anti-cheat)
18. [Hệ thống giao dịch P2P](#18-hệ-thống-giao-dịch-p2p)
19. [Cooldowns trên hoạt động kinh tế](#19-cooldowns-trên-hoạt-động-kinh-tế)
20. [Khoảng trống kinh tế (Missing Systems)](#20-khoảng-trống-kinh-tế-missing-systems)

---

## 1. TỔNG QUAN NỀN KINH TẾ

### 1.1 Loại tiền tệ

| Loại | Mô tả | Nguồn |
|------|-------|-------|
| **Cash ($)** | Tiền mặt chính | Jobs, robberies, trading |
| **Bank ($)** | Tiền ngân hàng | Paycheck, deposits |
| **Dirty Money** | Tiền bẩn (từ hoạt động phi pháp) | Robberies, rare wood, drugs |
| **Materials (Mats)** | Vật liệu chế tạo | Ve Chai, Trom Xe, crafting |
| **Coins** | Tiền premium (OOC) | Nạp tiền, events |
| **GP (Game Points)** | Điểm game | VIP activities |
| **EXP Farm** | Điểm kinh nghiệm | VIP perks |

### 1.2 Luồng tiền tổng quan

```
[NGUỒN THU]                          [NGUỒN CHI]
├─ Jobs (legal/illegal)               ├─ Mua sắm (24/7, Ammunation)
├─ Paycheck ($1-$11/tick × 3600s)     ├─ Xe cộ (mua, sửa, nhiên liệu)
├─ Robberies (ATM/Business)           ├─ Nhà cửa (mua, thuê)
├─ Gambling (Casino, Horse, Tai Xiu)  ├─ Phí bệnh viện & bảo hiểm
├─ Turf/Point income                  ├─ Phạt & thuế
├─ Fishing/Lumberjack                 ├─ Gambling losses
├─ Black Market (dirty→clean 80%)     ├─ Advertisement ($150k)
└─ Group paychecks                    └─ Premium shop (Coins/Credits)
```

---

## 2. NGUỒN THU NHẬP - LEGAL JOBS

### 2.1 Bảng tổng hợp thu nhập hợp pháp

| Job | Thu nhập/lượt | Thời gian ước tính | $/giờ (ước tính) | Ghi chú |
|-----|--------------|-------------------|-----------------|---------|
| **Bus Driver** | $3,000 - $5,700 | 10-15 phút | $12,000 - $34,200 | Skill bonus lên đến $1,200 |
| **Trucker** | $100 - $1,200/shipment | 5-15 phút | $4,000 - $14,400 | Cargo size ảnh hưởng pay |
| **Pizza Boy** | Distance × 3 / 20 | 3-10 phút | ~$10,000 - $30,000 | Phụ thuộc khoảng cách |
| **Garbage Man** | $10,000 - $20,000 | 10-15 phút | $40,000 - $120,000 | **Rất cao so với mặt bằng** |
| **Giao Báo** | $20,000 | 5-10 phút | $120,000 - $240,000 | **Cao bất thường** |
| **Lâm Tặc (gỗ thường)** | $500/kg (10kg/chop) | 5 giây/chop | ~$150,000 - $300,000 | 87 cây, truck max 100kg = $50,000/chuyến |
| **Lâm Tặc (gỗ sưa)** | $300,000 dirty | Event 19h-22h | **$300,000/ngày** | **Event daily, chỉ 1 cây/ngày, HP 10000, police notified** |
| **Ngư Dân** | $1,500 - $5,000/kg | 5-10 phút | $9,000 - $60,000 | Cá Nóc $5,000/kg |
| **Ve Chai** | $15-$45/kg × 10kg | 5-10 phút | $9,000 - $54,000 | + Materials (50-70 Mats/kg) |
| **Bodyguard** | $2,000 - $10,000 | Tùy nhu cầu | Không cố định | Player-set price |
| **Whore** | $1 - $10,000 | Tùy nhu cầu | Không cố định | Player-set price |
| **Mechanic** | Tùy giá | Tùy nhu cầu | Không cố định | Player-set price |
| **Arms Dealer** | Tùy giá | Tùy nhu cầu | Không cố định | Skill-gated weapons |
| **Bartender** | Tùy giá | Tùy nhu cầu | Không cố định | Player-set price |

### 2.2 Paycheck hệ thống (không phụ thuộc job)

| Level | Paycheck/giờ | Paycheck/ngày (8h) |
|-------|-------------|-------------------|
| 0-2 | $3,600 | $28,800 |
| 3-4 | $7,200 | $57,600 |
| 5-6 | $10,800 | $86,400 |
| 7-8 | $14,400 | $115,200 |
| 9-10 | $18,000 | $144,000 |
| 11-12 | $21,600 | $172,800 |
| 13-14 | $25,200 | $201,600 |
| 15-16 | $28,800 | $230,400 |
| 17-18 | $32,400 | $259,200 |
| 19-20 | $36,000 | $288,000 |
| 21+ | $39,600 | $316,800 |

**Lãi suất ngân hàng**: 0.1% (max $50k-$250k tùy VIP)

---

## 3. NGUỒN THU NHẬP - ILLEGAL JOBS

### 3.1 Bảng tổng hợp thu nhập phi pháp

| Hoạt động | Thu nhập | Loại tiền | Điều kiện | $/giờ (ước tính) |
|-----------|---------|-----------|-----------|-----------------|
| **ATM Robbery** | $35,000 - $70,000 | Dirty Money | ≥2 cops, Picklock | $140,000 - $280,000 |
| **Business Robbery** | $60,000 - $110,000 | Dirty Money | ≥2 cops, Picklock | $240,000 - $440,000 |
| **Cannabis** | $800/bag | Cash | Trồng + thu hoạch | ~$9,600 (12 bags/h) |
| **Rare Wood (Gỗ Sưa)** | $300,000 | Dirty Money | Event daily 19h-22h, HP 10000 | **$300,000/ngày** |
| **Vehicle Theft** | $15,000 - $30,000 + 100-300 Mats | Cash + Mats | Picklock (2,000 Mats) | $60,000 - $120,000 |
| **Gang Robbery** | 30% of safe | Cash | Gang activity | Không cố định |
| **Drug Dealing** | Tùy giá | Cash | Player-set | Không cố định |

### 3.2 Black Market - Chuyển đổi tiền bẩn

- **NPC "Koon 8 ngon"**: Xuất hiện ngẫu nhiên 30% mỗi ngày
- **Tỷ lệ chuyển đổi**: $1 dirty → $0.80 cash (80%)
- **Vai trò**: Cầu nối giữa nền kinh tế ngầm và chính thức

---

## 4. HỆ THỐNG KIẾM TIỀN KHÁC

### 4.1 Gambling

| Hệ thống | Bet tối thiểu | Payout | House Edge |
|----------|---------------|--------|------------|
| **Casino Dice** | $5,000,000 | 1:1 | ~50% |
| **Horse Race** | $18,000 - $10,000,000 | $40,000 - $22,000,000 | ~45% |
| **Tai Xiu** | Tùy | Player vs Player | 0% (PvP) |
| **Lottery** | Ticket price | Jackpot starts $50,000 | Rất cao |
| **Poker** | Tùy | Player vs Player | 0% (PvP) |
| **Boxing** | Tùy | Player vs Player | 0% (PvP) |

### 4.2 Group/Faction Income

| Nguồn | Thu nhập | Điều kiện |
|-------|---------|-----------|
| **Turf Control** | Theo territory | Gang control |
| **Group Points** | $500 - $50,000 | Capture points |
| **Group Paycheck** | Rank-based | Faction budget |
| **Crate System** | Random items | Group activity |

### 4.3 Hệ thống phụ

| Hệ thống | Thu nhập | Ghi chú |
|----------|---------|---------|
| **AFK Mining** | Passive income | AFK-friendly |
| **Adventure** | Exploration rewards | Random |
| **Treasure Hunting** | Junk items → sell | Low income |
| **Fishing (legacy)** | $0-$500 random | Money bag catch |
| **Farmed Missions** | Special rewards | Limited |

---

## 5. PHÂN TÍCH CHI TIÊU NGƯỜI CHƠI

### 5.1 Chi phí sinh hoạt cơ bản

| Khoản chi | Chi phí | Tần suất | Ghi chú |
|-----------|---------|----------|---------|
| **Bệnh viện** | $1,000 - $3,000 | Mỗi lần chết | 18 bệnh viện |
| **Bảo hiểm y tế** | $2,500 | Mua 1 lần/lần | Per hospital |
| **Healthcare Level 1-4** | $1,000 - $4,000 | Upgrade | Permanent |
| **Nhiên liệu (Gas Station)** | Dynamic | Thường xuyên | Owner-set price |
| **Nhiên liệu (Canister 100L)** | $120,000 | Khi cần | VIP shop |
| **Nhiên liệu (Canister 200L)** | $220,000 | Khi cần | VIP shop |
| **Sửa xe (Pay N Spray)** | Dynamic | Thường xuyên | Admin-set |
| **Sửa xe (Mechanic)** | Player-set | Khi cần | Player economy |

### 5.2 Chi phí giấy phép

| Giấy phép | Chi phí | Yêu cầu |
|-----------|---------|---------|
| **Bằng lái thuyền** | $5,000 | - |
| **Bằng lái máy bay** | $25,000 | Level 2 |
| **Bằng lái Taxi** | $35,000 | - |
| **Giấy phép súng** | - | Online 8+ giờ |

### 5.3 Chi phí mua sắm

#### 24/7 Store (giá do owner đặt, cost base × 5)

| Mặt hàng | Base Cost | Giá bán (ước tính) |
|----------|-----------|-------------------|
| Điện thoại | $5 | $50 - $500 |
| Danh bạ | $5 | $50 - $500 |
| Dice | $5 | $50 - $500 |
| Bao cao su | $5 | $50 - $500 |
| Dây thừng | $10 | $100 - $1,000 |
| Xe khóa | $30 | $300 - $3,000 |
| Bình sơn | $15 | $150 - $1,500 |
| Portable Radio | $75 | $750 - $7,500 |
| Camera | $20 | $200 - $2,000 |
| Vé số | $5 | $50 - $500 |
| Khóa công nghiệp | $125 | $1,250 - $12,500 |
| Khóa điện tử | $400 | $4,000 - $40,000 |
| Báo động xe | $140 | $1,400 - $14,000 |
| Mũ bảo hiểm | $15 | $150 - $1,500 |

#### Ammunation (giá từ database, admin-editable)

| Vũ khí | Materials Cost | Level yêu cầu |
|--------|---------------|---------------|
| Brass Knuckle | 25 Mats | 1 |
| Bat | 25 Mats | 2 |
| Shovel | 25 Mats | 3 |
| Katana | 25 Mats | 5 |
| Silenced Pistol | 100 Mats | 1 |
| Colt 45 | 150 Mats | 1 |
| Shotgun | 200 Mats | 1 |
| MP5 | 400 Mats | 2 |
| Rifle | 1,000 Mats | 2 |
| Desert Eagle | 2,000 Mats | 3 |

#### VIP Shop (SF NPC)

| Mặt hàng | Giá |
|----------|-----|
| Mining Machine (Normal) | $150,000 |
| Mining Machine (VIP) | 65,000 GP |
| Medkit-A | $15,000 |
| GPS | $25 |
| Sword Katana | $500,000 |
| Gay Bong Chay | $450,000 |

#### Toys/Accessories

| Loại | Giá |
|------|-----|
| Mũ/Kính cơ bản | $500 - $1,500 |
| Quân đội | $2,000 - $4,000 |
| Laser | $10,000 |
| Santa Hat | $10,000 - $30,000 |
| Mask Zorro | $10,000 |
| The Parrot | $7,500 |

### 5.4 Chi phí bất động sản

| Khoản chi | Chi phí | Ghi chú |
|-----------|---------|---------|
| **Nhà (tối thiểu)** | $500,000 | Dynamic, owner-set |
| **Thuê nhà** | Dynamic | Owner-set rent |
| **Quảng cáo quốc gia** | $150,000 | `/ad` |
| **Đổi tên** | Varies | Credit shop |
| **Đổi số điện thoại** | $500 | Bank NPC |

### 5.5 Chi phí xe cộ

| Khoản chi | Công thức/Giá | Ghi chú |
|-----------|--------------|---------|
| **Mua xe** | Dynamic | Business owner-set |
| **VIP discount** | -20% | VIP members |
| **Phí chuộc xe từ impound** | (Giá xe / 20) + Ticket + (Level × $3,000) | Formula |
| **Phí chuộc xe bị trộm** | $25,000 + (Giá xe / 10), max $60,000 | Trom Xe |
| **Phí bán xe vũ trang** | 15% giá trị | Fine |
| **OOC Car Shop** | 300 Coins | Premium |
| **OOC Boat Shop** | 350 Coins | Premium |
| **OOC Plane Shop** | 200 Coins | Premium |

### 5.6 Chi phí thuế & phí

| Khoản | Chi phí | Ghi chú |
|-------|---------|---------|
| **Business Tax** | 10% mỗi sale | Đến government |
| **DDSale fine** | 10% (min $1,000,000) | Seller pays |
| **Speed camera ticket** | Dynamic | Auto-issued |
| **Police ticket** | Officer-set | `/vticket` |
| **Parking meter** | Dynamic | Per meter |

### 5.7 Chi phí gambling

| Hệ thống | Bet tối thiểu | Bet tối đa |
|----------|--------------|-----------|
| **Casino Dice** | $5,000,000 | Không giới hạn |
| **Horse Race** | $18,000 | $10,000,000 |
| **Tai Xiu** | Level 2 required | Player-set |

---

## 6. PHÂN TÍCH LẠM PHÁT & DÒNG TIỀN

### 6.1 Tốc độ tạo tiền (Money Supply Growth)

```
NGUỒN TẠO TIỀN (FAUCET):
─────────────────────────────────────────────────
Paycheck:           $3,600 - $39,600/giờ/player
Garbage Man:        $40,000 - $120,000/giờ
Giao Báo:           $120,000 - $240,000/giờ
Lâm Tặc (gỗ sưa):  $300,000/ngày (EVENT daily 19h-22h)
ATM Robbery:        $140,000 - $280,000/giờ
Business Robbery:   $240,000 - $440,000/giờ
─────────────────────────────────────────────────

NGUỒNG HÚT TIỀN (SINK):
─────────────────────────────────────────────────
Hospital:           $1,000 - $3,000/lần chết
Fuel:               ~$5,000 - $50,000/ngày
Repairs:            ~$5,000 - $20,000/lần
Business Tax:       10% mọi giao dịch
Gambling:           $5,000,000+ (casino minimum)
─────────────────────────────────────────────────
```

### 6.2 Phân tích tỷ lệ Faucet/Sink

| Yếu tố | Đánh giá |
|---------|----------|
| **Paycheck vs Expenses** | Paycheck đủ cover chi phí sinh hoạt cơ bản |
| **Job income vs Luxury items** | Jobs hợp pháp tạo tiền chậm, items đắt → cần thời gian dài |
| **Illegal income vs Risk** | Illegal income cao hơn nhiều so với legal, risk thấp (chỉ cần 2 cops) |
| **Gambling sink** | Casino min $5M → chỉ người giàu mới gamble, không phải sink hiệu quả cho số đông |
| **Business Tax** | 10% là hợp lý nhưng chỉ áp dụng khi mua tại business |

### 6.3 Vấn đề kép: Tiền bẩn (Dirty Money)

```
NGUỒN TIỀN BẨN:
├─ ATM Robbery:       $35,000 - $70,000
├─ Business Robbery:  $60,000 - $110,000
├─ Gỗ Sưa (EVENT):   $300,000 (1 lần/ngày, risk cao)
└─ (Drug dealing có thể)

CHUYỂN ĐỔI:
└─ Black Market:      80% (dirty → cash)

ĐÁNH GIÁ:
- Gỗ Sưa: HỢP LÝ - Event daily với risk cao, không phải lạm phát
- ATM/Biz Robbery: Nguồn tiền bẩn chính, cần 2+ cops online
- Black market 80%: Vẫn cao, nên giảm xuống 50-60%
```

---

## 7. ĐÁNH GIÁ CÂN BẰNG KINH TẾ

### 7.1 Điểm CÂN BẰNG (Tốt)

| Hệ thống | Đánh giá | Lý do |
|----------|----------|-------|
| **Paycheck scaling** | ✅ Tốt | Tăng theo level, khuyến khích chơi lâu |
| **Bus Driver** | ✅ Tốt | Thu nhập hợp lý, có skill bonus |
| **Trucker** | ✅ Tốt | Nhiều loại shipment, risk/reward cân bằng |
| **24/7 Store** | ✅ Tốt | Giá do owner đặt → kinh tế thị trường |
| **Business Tax 10%** | ✅ Tốt | Sink hợp lý |
| **Hospital fees** | ✅ Tốt | Nhẹ, không gây áp lực |
| **License costs** | ✅ Tốt | Hợp lý cho progression |
| **Player-to-player services** | ✅ Tốt | Bodyguard, Mechanic, Bartender → kinh tế tự do |

### 7.2 Điểm MẤT CÂN BẰNG (Cần cải thiện)

| Hệ thống | Vấn đề | Mức độ |
|----------|--------|--------|
| **🟢 Lâm Tặc - Gỗ Sưa** | Event daily 19h-22h, $300k dirty, risk cao | **HỢP LÝ** |
| **🔴 Giao Báo** | $20,000/lượt, quá dễ, 5-10 phút | **CAO** |
| **🔴 Garbage Man** | $10,000-$20,000/lượt, không cần skill | **CAO** |
| **🟡 Casino Minimum** | $5,000,000 bet tối thiểu → quá cao | **TRUNG BÌNH** |
| **🟡 Black Market 80%** | Gần như không mất giá khi rửa tiền | **TRUNG BÌNH** |
| **🟡 Ve Chai → Mats** | Tạo materials quá dễ → ảnh hưởng Arms Dealer | **TRUNG BÌNH** |
| **🟡 ATM Limit** | $10,001/transaction → quá thấp so với giá cả | **THẤP** |
| **🟡 Horse Race top** | $10M bet → $22M payout → sink quá lớn cho少数 | **THẤP** |

### 7.3 Phân tích theo vai trò kinh tế

#### Người mới (Level 0-5)
- **Thu nhập**: Paycheck $3,600/h + Jobs $10,000-$30,000/h
- **Chi phí cơ bản**: Hospital $1-3k, Fuel ~$5-20k, Food ~$1-5k
- **Đánh giá**: ✅ Cân bằng tốt, đủ sống nhưng khó giàu

#### Người chơi trung bình (Level 5-15)
- **Thu nhập**: Paycheck $10,800-$28,800/h + Jobs $20,000-$100,000/h
- **Chi phí**: Xe $100k-$500k, Nhà $500k+, Weapons
- **Đánh giá**: ✅ Hợp lý, có progression

#### Người chơi giàu (Level 15+)
- **Thu nhập**: Paycheck $28,800-$39,600/h + Illegal $200,000-$440,000/h
- **Chi phí**: Casino $5M+, Luxury items, Properties
- **Đánh giá**: ⚠️ Thiếu sink hiệu quả, tiền tích lũy nhanh

#### Người chơi mới bắt đầu server
- **Vấn đề**: Giá cả items cao (nhà $500k+) nhưng thu nhập ban đầu thấp
- **Gap**: Cần ~50 giờ chơi để mua nhà đầu tiên (nếu chỉ dùng paycheck)

---

## 8. ĐỀ XUẤT CẢI CÁCH

### 8.1 Ưu tiên CAO - Fix mất cân bằng thu nhập

#### A. Gỗ Sưa - Đánh giá lại
```
Hiện tại: $300,000 dirty/lần, EVENT daily 19h-22h, chỉ 1 cây/ngày
          HP 10,000 (mất ~33 phút chop solo), police được thông báo
Đánh giá:  ✅ HỢP LÝ - Event daily với risk cao, không phải lạm phát
          - Chỉ 1 cây/ngày → max $300,000 dirty/ngày/server
          - Police notification → risk bị tịch thu ($20,000 thưởng cho PD)
          - HP 10,000 → cần nhiều người hoặc thời gian dài
          - Broadcast khi bán → ai cũng biết
```

#### B. Giao Báo - Giảm pay
```
Hiện tại: $20,000/lượt
Đề xuất:  $5,000 - $8,000/lượt (tương đương Bus Driver)
```

#### C. Garbage Man - Tăng thời gian hoặc giảm pay
```
Hiện tại: $10,000 - $20,000/lượt, 10-15 phút
Đề xuất:  $5,000 - $10,000/lượt
          HOẶC: Tăng số stages từ 5 lên 8-10
```

### 8.2 Ưu tiên TRUNG BÌNH - Cải thiện hệ thống

#### D. Black Market - Giảm tỷ lệ chuyển đổi
```
Hiện tại: 80% (dirty → cash)
Đề xuất:  50-60% (dirty → cash)
          + Thêm NPC "lừa đảo" có thể xuất hiện giả mạo (scam risk)
```

#### E. Casino - Giảm bet minimum
```
Hiện tại: $5,000,000 minimum
Đề xuất:  $1,000,000 minimum (mở rộng đối tượng)
          + Thêm tables với mức bet khác nhau ($100k, $500k, $1M, $5M)
```

#### F. ATM Limit - Tăng
```
Hiện tại: $10,001/transaction
Đề xuất:  $50,000 - $100,000/transaction (phù hợp giá cả)
```

#### G. Ve Chai → Mats - Giảm conversion
```
Hiện tại: 50-70 Mats/kg
Đề xuất:  20-30 Mats/kg
          + Tăng processing fee
```

### 8.3 Ưu tiên THẤP - Cải thiện trải nghiệm

#### H. Thêm Money Sinks
```
Đề xuất:
- Vehicle insurance (hàng tuần, bắt buộc)
- Property tax (hàng tuần cho house owners)
- Premium vehicle customization (tuning, paint)
- Gambling tournaments với entry fee
- Rare item auctions (admin-run)
```

#### I. Thêm Progressive Pricing
```
Đề xuất:
- Ammunation: Giá tăng theo số lần mua trong ngày
- Fuel: Giá tăng khi server đông người
- Hospital: Giá tăng theo level player
```

#### J. Cải thiện kinh tế mới bắt đầu
```
Đề xuất:
- Tutorial bonus: $50,000 cho người mới
- First house discount: -30% cho nhà đầu tiên
- Starter kit: 1 xe miễn phí (cũ), 1 bộ quần áo
```

---

## 9. BẢNG TỔNG HỢP THU NHẬP vs CHI TIÊU

### Thu nhập trung bình/giờ theo activity

```
                    THU NHẬP ($/giờ)
                    ═══════════════════════════════════
Paycheck (Lvl 10)  ████████░░░░░░░░░░░░░░░░░░  $18,000
Bus Driver          ██████████████░░░░░░░░░░░░  $25,000
Trucker             ██████████░░░░░░░░░░░░░░░░  $10,000
Pizza Boy           ████████████████░░░░░░░░░░  $20,000
Garbage Man         ████████████████████████░░  $80,000  ← QUÁ CAO
Giao Báo            ██████████████████████████  $180,000 ← QUÁ CAO
Ngư Dân             ██████████████░░░░░░░░░░░░  $35,000
Ve Chai             ████████████░░░░░░░░░░░░░░  $30,000
Lâm Tặc (thường)   ██████████████████░░░░░░░░  $200,000
Lâm Tặc (gỗ sưa)   ██████████████████████████  $300,000/ngày (EVENT)
ATM Robbery         ████████████████████████░░  $210,000
Biz Robbery         ██████████████████████████  $340,000
Cannabis            ████░░░░░░░░░░░░░░░░░░░░░░  $9,600
```

### Chi tiêu trung bình

```
                    CHI TIÊU
                    ═══════════════════════════════════
Hospital            ██░░░░░░░░░░░░░░░░░░░░░░░░  $2,000
Fuel (ngày)         ████░░░░░░░░░░░░░░░░░░░░░░  $15,000
Food/Drinks         ██░░░░░░░░░░░░░░░░░░░░░░░░  $3,000
Repairs             ████░░░░░░░░░░░░░░░░░░░░░░  $10,000
Ammunation          ████████████░░░░░░░░░░░░░░  150-2000 Mats
24/7 Items          ████░░░░░░░░░░░░░░░░░░░░░░  $5,000-$50,000
House (mua 1 lần)   ████████████████████████░░  $500,000+
Vehicle (mua 1 lần) ██████████████████████████  $100,000 - $1,000,000+
Casino              ██████████████████████████  $5,000,000+
```

---

## 10. KẾT LUẬN

### Tình trạng nền kinh tế: ⚠️ MẤT CÂN BẰNG TRUNG BÌNH

**Điểm mạnh:**
- Hệ thống jobs đa dạng, phong phú
- Kinh tế thị trường tự do (player-set prices)
- Paycheck scaling tốt theo level
- Có cả legal và illegal pathways
- Materials economy tạo tầng kinh tế thứ 2
- Weapon crafting 2 hệ thống song song
- Anti-cheat & logging hệ thống đầy đủ
- Cooldowns chống abuse hiệu quả
- Gỗ Sưa Event design tốt (risk/reward cân bằng)

**Điểm yếu chính:**
1. **Giao Báo & Garbage Man** - Thu nhập quá cao so với độ khó
2. **Thiếu money sinks** cho người chơi giàu (không income tax, property tax, vehicle insurance)
3. **Black Market quá hào phóng** - 80% conversion gần như không penalty
4. **ATM limit quá thấp** - $10,001 không phù hợp với mức giá hiện tại
5. **House inactivity DISABLED** - Nhà không bao giờ bị tịch thu
6. **VIP tạo lợi thế kinh tế quá lớn** - ~$382k/ngày chênh lệch
7. **Người mới quá khó** - Cần 139 giờ paycheck để mua nhà đầu tiên
8. **Weapon loss là sink chính** - Nhưng chỉ punish người có vũ khí

**Khuyến nghị ưu tiên:**
1. 🔴 Bật lại House Inactivity system
2. 🟡 Giảm pay Giao Báo & Garbage Man
3. 🟡 Thêm money sinks (property tax, vehicle insurance, income tax)
4. 🟡 Thêm progressive death penalty (giàu chết mất nhiều hơn)
5. 🟢 Tăng ATM limit lên $50,000-$100,000
6. 🟢 Cải thiện new player experience (starter bonus, first house discount)
7. 🟢 Đa dạng hóa gambling options

---

*Phân tích này dựa trên code source, giá cả có thể thay đổi trong game do admin điều chỉnh hoặc database values khác.*

---

## 9. NỀN KINH TẾ MATERIALS (MATS)

Materials là **nền kinh tế thứ 2** song song với cash, chi phối toàn bộ hệ thống vũ khí và crafting.

### 9.1 Nguồn cung Materials

| Nguồn | Sản lượng | Điều kiện | File |
|-------|----------|-----------|------|
| **`/getmats`** | Tùy ($500/lần) | Job 9 (Arms Dealer) hoặc 18 (Craftsman) | `dynamic/points.pwn:73` |
| **Trucking bonus** | 100-1,000 mats/chuyến | Skill level 1-5 | `callbacks.pwn:3765` |
| **Ve Chai** | 50-70 mats/kg | Mua phế liệu $15-45/kg | `jobs/vechai.pwn` |
| **Trom Xe** | 100-300 mats/xe | Steal + dispose vehicle | `jobs/tromxe.pwn` |
| **Group Points** | Theo territory | Gang capture | `dynamic/points.pwn:423` |
| **Gift Box events** | Random | Server events | Dynamic |
| **`/getmats` tại Points** | $500/pickup | Arms Dealer/Craftsman | `dynamic/points.pwn:73` |

### 9.2 Nhu cầu Materials

| Hệ thống | Chi phí Mats | Sản phẩm | File |
|----------|-------------|----------|------|
| **Arms Dealer - Melee** | 500 mats | Flowers, Knuckles, Bat, Cane, Shovel, Club, Pool | `armsdealer.pwn` |
| **Arms Dealer - 9mm/Katana** | 2,000 mats | 9mm, Katana | `armsdealer.pwn` |
| **Arms Dealer - SD Pistol** | 3,500 mats | Silenced Pistol | `armsdealer.pwn` |
| **Arms Dealer - Shotgun/MP5** | 5,000 mats | Shotgun, MP5 | `armsdealer.pwn` |
| **Arms Dealer - Rifle** | 10,000 mats | Rifle | `armsdealer.pwn` |
| **Arms Dealer - Tec9/Uzi** | 8,000 mats | Tec9, Uzi | `armsdealer.pwn` |
| **Arms Dealer - Deagle** | 10,000 mats | Desert Eagle (skill 1200+) | `armsdealer.pwn` |
| **Arms Dealer - AK-47** | 50,000 mats | AK-47 (Gold VIP+ required) | `armsdealer.pwn:462` |
| **Craftsman - Basic** | 1,000 mats | Wristwatch, GPS, Tire, Firstaid | `craftsman.pwn:401` |
| **Craftsman - Medium** | 1,500 mats | Screwdriver, Lock, Camera, Syringe | `craftsman.pwn:404` |
| **Craftsman - Advanced** | 2,000-5,000 mats | SMS Log, Parachute, Closet, Receiver | `craftsman.pwn:406` |
| **Craftsman - Premium** | 8,000-15,000 mats | Surveillance, RCCam, Bug Sweep, Toolbox, Mailbox | `craftsman.pwn:409` |
| **Group Locker - Kevlar** | 200 mats | Kevlar Armor | `groupcore.pwn:968` |
| **Trom Xe - Picklock** | 2,000 mats | Craft picklock tool | `tromxe.pwn` |

### 9.3 Phân tích cân bằng Materials

```
NGUỒN CUNG:                         NHU CẦU:
├─ /getmats: $500/pickup             ├─ Arms Dealer: 500-50,000 mats
├─ Trucking: 100-1,000/chuyến       ├─ Craftsman: 1,000-15,000 mats
├─ Ve Chai: 50-70 mats/kg           ├─ Group Locker: 200 mats/kevlar
├─ Trom Xe: 100-300 mats/xe         ├─ Picklock: 2,000 mats
└─ Group Points: passive             └─ Weapon trading: player-set

ĐÁNH GIÁ:
- Ve Chai là nguồn mats chính → quá dễ farm (50-70/kg, mua $15-45/kg)
- Arms Dealer level cao cần 50,000 mats → nhưng Ve Chai farm nhanh
- Không có giới hạn daily trên /getmats → spam được
```

---

## 10. HỆ THỐNG CHẾ TẠO VŨ KHÍ (CRAFTING)

Server có **2 hệ thống craft song song**:

### 10.1 Hệ thống A: Arms Dealer truyền thống (`/sellgun`)
- Job ID 9, skill-gated (5 levels)
- Dùng **Materials** duy nhất
- Skill 0-49: Melee + 9mm/SD Pistol
- Skill 1200+ + Gold VIP: AK-47

### 10.2 Hệ thống B: Craft mới với khoáng sản (`/craft`)
**File**: `modules/craftweapon.inc`
- Vị trí: (-2403.55, 533.83, 30.38)
- Cần **5 loại khoáng sản** + **tiền mặt** + **EXP**

| Vũ khí | Cash | EXP | Silver | Niken | Gold | Cu | Crom |
|--------|------|-----|--------|-------|------|----|------|
| Ammo Box | $100,000 | 0 | 0 | 0 | 0 | 0 | 0 |
| 9mm | $250,000 | 4,000 | 25 | 25 | 25 | 25 | 25 |
| Silenced Pistol | $350,000 | 5,500 | 25 | 25 | 25 | 25 | 25 |
| Deagle | $350,000 | 5,500 | 25 | 25 | 25 | 25 | 25 |
| Shotgun | $320,000 | 10,000 | 25 | 25 | 25 | 25 | 25 |
| Sawn-off | $1,200,000 | 25,000 | 25 | 25 | 25 | 25 | 25 |
| Combat Shotgun | $1,250,000 | 25,000 | 25 | 25 | 25 | 25 | 25 |
| Uzi | $650,000 | 12,000 | 25 | 25 | 25 | 25 | 25 |
| MP5 | $450,000 | 10,000 | 25 | 25 | 25 | 25 | 25 |
| AK-47 | $850,000 | 25,000 | 15 | 15 | 15 | 15 | 15 |
| M4 | $850,000 | 25,000 | 25 | 25 | 25 | 25 | 25 |
| Tec-9 | $650,000 | 12,000 | 25 | 25 | 25 | 25 | 25 |
| Rifle | $850,000 | 20,000 | 10 | 10 | 10 | 10 | 10 |
| Sniper Rifle | $850,000 | 20,000 | 25 | 25 | 25 | 25 | 25 |

### 10.3 So sánh 2 hệ thống

| Yếu tố | Arms Dealer | Craft mới |
|---------|------------|-----------|
| **Nguyên liệu** | Materials only | Cash + EXP + 5 minerals |
| **Chi phí thấp nhất** | 500 mats (~$500) | $100,000 (Ammo Box) |
| **Chi phí cao nhất** | 50,000 mats (AK-47) | $1,250,000 + 25,000 EXP + 125 minerals |
| **Yêu cầu** | Job + Skill | Cash + EXP + Location-based |
| **VIP requirement** | Gold VIP cho AK-47 | Không |
| **Đánh giá** | Dễ tiếp cận hơn | Đắt hơn nhưng không cần VIP |

---

## 11. TÁC ĐỘNG VIP ĐẾN NỀN KINH TẾ

### 11.1 Các ưu đãi kinh tế VIP

| Ưu đãi | Regular | Bronze | Silver | Gold | Platinum |
|--------|---------|--------|--------|------|----------|
| **24/7 Discount** | 0% | 20% | 20% | 20% | 20% |
| **Tax Reduction** | 0% | 0% | 0% | 0% | 15% |
| **Interest Cap/paycheck** | $50,000 | $100,000 | $150,000 | $200,000 | $250,000 |
| **Vehicle Registration** | $150,000 | $150,000 | $125,000 | $100,000 | $50,000 |
| **House Slots** | 2 | 2 | 2 | 2 | 3 |
| **Closet Skins** | 10 | 25 | 25 | 25 | 25 |
| **Free Fuel** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **Free ATM/Bank** | ❌ | ❌ | ✅ | ✅ | ✅ |
| **AK-47 Access** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **Birthday x2 Paycheck** | ❌ | ❌ | ❌ | ✅ | ✅ |
| **Auto +1 EXP/5 paychecks** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Hospital 5s** | ❌ | ❌ | ❌ | ❌ | ✅ |

### 11.2 Lợi thế kinh tế tích lũy (ước tính/ngày chơi 8 giờ)

| Yếu tố | Regular Player | Platinum VIP | Chênh lệch |
|---------|---------------|--------------|-----------|
| **Paycheck (Lvl 10)** | $144,000 | $144,000 + $250k interest | +$250,000 |
| **Tax (10% paycheck)** | -$14,400 | -$12,240 (15% reduction) | +$2,160 |
| **24/7 spending** | $50,000 | $40,000 (20% off) | +$10,000 |
| **Fuel cost** | ~$20,000 | $0 (free) | +$20,000 |
| **Vehicle Registration** | $150,000 | $50,000 | +$100,000 |
| **Tổng/ngày** | - | - | **~$382,000/ngày** |

**Đánh giá**: VIP tạo lợi thế kinh tế **rất lớn**, đặc biệt free fuel và interest cap. Người chơi regular khó cạnh tranh về dài hạn.

---

## 12. PHÂN TÍCH HÌNH PHẠT CHẾT (DEATH PENALTY)

### 12.1 Hậu quả khi chết

| Hình phạt | Mức độ | Chi tiết |
|-----------|--------|---------|
| **Mất toàn bộ vũ khí** | ⚠️ **NGHIÊM TRỌNG** | `ResetPlayerWeaponsEx()` - mất hết súng |
| **Hospital fee** | Nhẹ | $1,000 - $3,000 |
| **Fitness loss** | Nhẹ | -6 fitness points |
| **Mất tiền mặt** | ❌ Không | Giữ nguyên cash |
| **Mất items trong túi** | ❌ Không | Inventory giữ nguyên |
| **Mất bank** | ❌ Không | Bank giữ nguyên |
| **Mất dirty money** | ❌ Không | Dirty money giữ nguyên |

### 12.2 Đánh giá Death Penalty

```
VẤN ĐỀ:
- Mất vũ khí = mất hàng trăm nghìn $ hoặc hàng nghìn mats
- Hospital fee $1-3k = quá nhẹ so với thu nhập
- Không mất cash/items → death không đủ răn đe
- Người giàu chết → chỉ mất vũ khí (mua lại dễ)
- Người nghèo chết → mất vũ khí (khó mua lại)

MẤT CÂN BẰNG:
→ Hình phạt chính là WEAPON LOSS, nhưng chỉ punish người có vũ khí
→ Không có progressive penalty (giàu chết mất nhiều hơn)
→ Không có XP/level loss
```

---

## 13. ĐÁNH GIÁ HIỆU QUẢ MONEY SINKS

### 13.1 Bảng đánh giá tất cả Money Sinks

| Sink | Amount | Frequency | Effectiveness | Ghi chú |
|------|--------|-----------|--------------|---------|
| **Hospital fee** | $1,000-$3,000 | Mỗi lần chết | 🔴 LOW | Quá nhẹ |
| **Insurance** | $2,500 | 1 lần/hospital | 🔴 LOW | Mua 1 lần là xong |
| **Healthcare** | $1,000-$4,000 | Per use | 🔴 LOW | Optional |
| **Business Tax** | 10% per sale | Mọi giao dịch | 🟡 MEDIUM | Chỉ khi mua tại business |
| **Vehicle tickets** | Dynamic | Speed cam + police | 🟡 MEDIUM | Phải trả khi lấy xe |
| **Impound release** | (price/20)+ticket+(level×$3k) | Per impound | 🟡 MEDIUM | Formula hợp lý |
| **Arrest fines** | Up to $250,000 | Per arrest | 🟡 MEDIUM | Chỉ áp dụng cho tội phạm |
| **DD Sale fine** | 10% (min $1M) | Per property sale | 🟢 HIGH | Nhưng hiếm khi bán |
| **Dirty money seizure** | ALL dirty | Per arrest | 🟢 HIGH | Chỉ cho tội phạm |
| **Weapon loss on death** | All weapons | Every death | 🟢 HIGH | Sink chính của server |
| **House inactivity** | Full house loss | 180 days | ⚫ DISABLED | Code bị comment out! |
| **Gambling (Casino)** | $5M+ minimum | Per bet | 🟢 HIGH | Nhưng chỉ cho người giàu |

### 13.2 Tổng kết Sink Effectiveness

```
SINK HIỆU QUẢ CHO SỐ ĐÔNG:
├─ Weapon loss on death ✅ (nhưng không đủ vì mua lại được)
├─ Business Tax 10% ✅ (nhưng chỉ khi mua tại business)
└─ Vehicle tickets ✅ (nhưng amount nhỏ)

SINK CHỈ CHO NGƯỜI GIÀU:
├─ Casino $5M+ (limited audience)
└─ DD Sale fine (hiếm khi bán)

SINK BỊ DISABLED:
└─ House inactivity (commented out!)

SINK THIẾU HOÀN TOÀN:
├─ Property tax (hàng tuần)
├─ Vehicle insurance (hàng tuần)
├─ Income tax
├─ Vehicle degradation
└─ Item decay
```

---

## 14. ĐIỀU KIỆN BẮT ĐẦU CHO NGƯỜI MỚI

### 14.1 Tài nguyên khởi đầu

| Tài nguyên | Giá trị | File |
|-----------|---------|------|
| **Level** | 1 | `OnPlayerLoad.pwn:318` |
| **Bank** | $20,000 | `OnPlayerLoad.pwn:323` |
| **Cash** | $0 | Default |
| **Materials** | 0 | `OnPlayerLoad.pwn:265` |
| **Weapons** | 0 | Weapon-restricted 2h |
| **Health** | 50 HP | `OnPlayerLoad.pwn:411` |
| **Armor** | 0 | `OnPlayerLoad.pwn:412` |
| **Phone** | 0 (chưa có số) | `OnPlayerLoad.pwn:319` |
| **Houses** | 0 | - |
| **Vehicles** | 0 | - |

### 14.2 Hạn chế người mới

| Hạn chế | Thời gian | Ghi chú |
|---------|-----------|---------|
| **Weapon restriction** | 2 giờ đầu | Không dùng vũ khí (`banking.pwn:387`) |
| **Level 1 trading limits** | Đến level 2+ | Nhiều hệ thống block level 1 |
| **No `/givemoney` từ admin** | Level 1 | Anti-distribute (`admin.pwn:2390`) |
| **No business ownership** | Level 1+ | `businesscore.pwn:1624` |
| **No vehicle selling** | Level 1 | `vehiclecore.pwn:2570` |

### 14.3 Phân tích Gap

```
Người mới có: $20,000 bank + $0 cash
Cần mua đầu tiên:
├─ Điện thoại: ~$100-500 (24/7)
├─ Xe: ~$100,000-$500,000 (dealership)
├─ Nhà: ~$500,000+ (minimum)
└─ Vũ khí: 25-2,000 mats + cash

THỜI GIAN ĐỂ MUA XE ĐẦU TIÊN (chỉ paycheck Lvl 1):
→ $3,600/giờ → cần ~28-139 giờ chơi
THỜI GIAN ĐỂ MUA NHÀ ĐẦU TIÊN:
→ $3,600/giờ → cần ~139 giờ chơi

ĐÁNH GIÁ: ⚠️ Quá khó cho người mới nếu không có job
```

---

## 15. HỆ THỐNG NHIÊN LIỆU XE CHI TIẾT

### 15.1 Thông số kỹ thuật

| Thông số | Giá trị | File |
|----------|---------|------|
| **Max fuel** | 100.0 units | `businesscore.pwn:1000` |
| **Consumption rate** | 1.0 fuel/60 giây | `timers.pwn:899` |
| **Full tank duration** | 100 phút lái liên tục | Tính toán |
| **Pump rate** | 0.1 gallon/giây | `defines.pwn:323` |
| **VIP/Famed vehicles** | Miễn fuel hoàn toàn | `timers.pwn:895` |
| **Bicycles** | Miễn fuel | `timers.pwn:886` |

### 15.2 Chi phí nhiên liệu ước tính

| Loại | Giá | Nguồn |
|------|-----|-------|
| **Gas Station** | Dynamic (owner-set) | Business |
| **Fuel Canister 100L** | $120,000 | VIP Shop |
| **Fuel Canister 200L** | $220,000 | VIP Shop |
| **Fuel từ inventory** | $1,250/unit | `inventory.inc:2751` |

### 15.3 Phân tích

```
Người chơi regular (8h/ngày):
→ Xe chạy ~80% thời gian = 384 phút
→ Tiêu hao: ~384 fuel = 3.84 bình đầy
→ Chi phí: ~$15,000-$50,000/ngày (tùy giá gas)

VIP player:
→ Chi phí: $0 (miễn fuel)

CHÊNH LỆCH: ~$15,000-$50,000/ngày = $450,000-$1,500,000/tháng
```

---

## 16. NỀN KINH TẾ TRONG TÙ (PRISON ECONOMY)

### 16.1 Tiền tệ trong tù

| Loại | Mô tả | Nguồn |
|------|-------|-------|
| **Prison Credits** | Tiền tệ trong tù | Prison activities |
| **Prison Materials** | Vật liệu trong tù | Prison activities |

### 16.2 Items trong tù

| Item | Giá trị | Công dụng |
|------|---------|----------|
| **Soap** | Tradeable | Currency |
| **Sugar** | Tradeable | Currency |
| **Bread** | Tradeable | Food/currency |
| **Wine** | Tradeable | Currency |
| **Moonshine** | Tradeable | Currency |
| **Shank** | Tradeable | Weapon |
| **Chisel** | Tradeable | Escape tool |

### 16.3 Giao dịch trong tù

- 10-second cooldown giữa các giao dịch credits (`prison_system.pwn:1796`)
- Trading giữa inmates
- Prison economy riêng biệt với thế giới bên ngoài

---

## 17. BẢO VỆ KINH TẾ & ANTI-CHEAT

### 17.1 Hệ thống Anti-Cheat

**File**: `anticheat2.pwn`, `admin/anticheat.pwn`

| Bảo vệ | Mô tả |
|--------|-------|
| **Dialog spoofing** | Kiểm tra mọi dialog handler |
| **Command spam** | Flag sau ngưỡng nhất định |
| **Aimbot detection** | Track consecutive shots |
| **Speed hack** | Infinite stamina detection |
| **Fly hack** | Swim fly check |

### 17.2 Transaction Monitoring

| Monitoring | Điều kiện | File |
|-----------|----------|------|
| **Money transfer alert** | $100,000+ từ level ≤3 | `storage.pwn:552` |
| **Level 1 trading block** | Block nhiều giao dịch | Various |
| **Weapon restriction 2h** | Người mới | `banking.pwn:387` |

### 17.3 Logging System

| Log | File | Mục đích |
|-----|------|---------|
| **Admin actions** | `logs/admin.log` | Admin commands |
| **Stats changes** | `logs/stats.log` | Stat modifications |
| **Credits** | `logs/credits.log` | Credit transactions |
| **Houses** | `logs/house.log` | House transactions |
| **Robbery** | `logs/robbery.log` | Every robbery |
| **Hitman** | `logs/hitman.log` | Hit contracts |
| **Dirty Money** | `logs/DirtyMoney.log` | Money seizures |
| **Cannabis** | `logs/cannabis.log` | Drug sales |
| **Crime** | `logs/crime.log` | Crime additions |
| **Group** | `grouplogs/{id}/{date}.log` | Group operations |
| **Group Pay** | `grouppay/{id}/{date}.log` | Group payments |

### 17.4 Server Restart Protection

- **Tất cả giao dịch bị disable** khi restart:
  - `/give` items blocked
  - Bank transactions blocked
  - Vehicle selling blocked
  - Accept/cancel offers blocked
  - Credit shop blocked
  - ATM access blocked
- **Dữ liệu lưu MySQL** trên disconnect → không mất tiền khi restart

---

## 18. HỆ THỐNG GIAO DỊCH P2P

### 18.1 Weapon Trading (`/banvukhi`)

**File**: `modules/sellgunnew.inc`

| Thông số | Giá trị |
|----------|---------|
| **Price range** | $10,000 - $2,000,000,000 |
| **Yêu cầu** | Gang member, Level 2+ |
| **Khoảng cách** | 5m |
| **Cooldown** | 10 giây trước khi buyer accept |
| **Timeout** | 5 phút tự hủy |
| **Anti-fraud** | IP logged, admin notification |
| **Block** | Không bán LAW weapons (item 44-48) |

### 18.2 Arms Dealer Trading (`/sellgun`)

- Arms Dealer dùng materials để craft → bán cho player
- Buyer phải `/chapnhan vukhi`
- 10-second cooldown giữa mỗi lần sell

### 18.3 General Item Trading (`/give`)

**File**: `core/Player_Interact.pwn:168`

| Item có thể trade | Ghi chú |
|-------------------|---------|
| Drugs | Pot, Crack, Meth, etc. |
| Materials | Có max capacity |
| Fireworks | Event items |
| Syringes | Drug-related |
| Sprunk | Drinks |
| PB Tokens | Premium |

### 18.4 Craftsman Trading (`/craft`)

- Craftsman craft item từ materials → offer cho player
- Buyer `/chapnhan chetao` để accept
- 10-second cooldown

---

## 19. COOLDOWNS TRÊN HOẠT ĐỘNG KINH TẾ

### 19.1 Bảng tổng hợp cooldowns

| Hoạt động | Cooldown | File |
|-----------|----------|------|
| **ATM Robbery** | 15 phút/player, 30 phút/target | `robbery.inc:22-28` |
| **Business Robbery** | 15 phút/player, 30 phút/target | `robbery.inc:22-28` |
| **Drug use** | 60 giây | `drugcore.pwn:88` |
| **Black Market** | 30% chance/ngày | `blackmarket.inc:30` |
| **ATM/Bank transaction** | 10 giây | `ATMs.pwn:122` |
| **Vehicle sell** | 60 giây | `vehiclecore.pwn:2596` |
| **Check writing** | 10 giây | `banking.pwn:790` |
| **Prison credit trade** | 10 giây | `prison_system.pwn:1796` |
| **Weapon trade (P2P)** | 10 giây | `sellgunnew.inc:111` |
| **Arms Dealer sell** | 10 giây | `armsdealer.pwn:45` |
| **Job Boost purchase** | 24h sau 3 lần | `OnDialogResponse.pwn` |
| **Energy Bar purchase** | 24h sau 3 lần | `OnDialogResponse.pwn` |
| **Quick Bank Access** | 24h sau 3 lần (2h active) | `OnDialogResponse.pwn` |

### 19.2 Đánh giá

```
- Robbery cooldown 15 phút → hợp lý, ngăn spam
- Drug cooldown 60 giây → hợp lý
- Bank/ATM 10 giây → chống spam transaction
- Micro shop daily limits → ngăn abuse

ĐÁNH GIÁ: ✅ Hệ thống cooldown khá tốt, ngăn abuse hiệu quả
```

---

## 20. KHOẢNG TRỐNG KINH TẾ (MISSING SYSTEMS)

### 20.1 Hệ thống KHÔNG TỒN TẠI trong code

| Hệ thống | Mô tả | Ảnh hưởng |
|----------|-------|----------|
| **Loan/Debt** | Không có cho vay | Không có leverage/risk trong kinh tế |
| **Dynamic Pricing** | Giá static, không supply/demand | Không có market correction |
| **Income Tax** | Không có thuế thu nhập | Người giàu không bị đánh thuế |
| **Property Tax** | Không có thuế tài sản | Nhà cửa free sau khi mua |
| **Vehicle Insurance** | Không có bảo hiểm xe | Xe không mất giá trị theo thời gian |
| **Vehicle Degradation** | Xe không hỏng theo thời gian | Xe mua 1 lần dùng mãi |
| **Item Decay** | Items không hỏng (trừ food) | Tích lũy items vô hạn |
| **House Inactivity** | **BỊ DISABLED** (commented out) | Nhà không bị tịch thu |
| **Progressive Death Penalty** | Cùng hình phạt cho mọi cấp | Không công bằng |

### 20.2 Nhà inactivity bị DISABLED

```pawn
// Code trong core/inactive2.pwn
// Inactive_ResourceCheck() - COMMENTED OUT
// Hệ thống 180 ngày không login → tịch thu nhà
// ĐANG BỊ VÔ HIỆU HÓA
```

**Hậu quả**: Nhà cửa không bao giờ bị tịch thu → đất đai khan hiếm giả tạo

### 20.3 Đánh giá tổng thể

```
NỀN KINH TẾ CÓ:
✅ Hệ thống jobs đa dạng
✅ Kinh tế thị trường tự do (player-set prices)
✅ Paycheck scaling theo level
✅ Materials economy song song
✅ Weapon crafting 2 hệ thống
✅ Anti-cheat cơ bản
✅ Transaction logging đầy đủ
✅ Cooldowns chống abuse
✅ Death penalty (weapon loss)

NỀN KINH TẾ THIẾU:
❌ Income tax (người giàu không bị đánh thuế)
❌ Property tax (nhà free sau mua)
❌ Vehicle insurance (xe free sau mua)
❌ Vehicle degradation
❌ Item decay (tích lũy vô hạn)
❌ Loan/Debt system
❌ Dynamic pricing
❌ House inactivity (DISABLED)
❌ Progressive penalties
```

---

*Phần bổ sung cập nhật lần 2 - 28/05/2026*
