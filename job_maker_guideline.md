# SA-MP Job System GDD

## Hard RP / Anti-Exploit / Scalable Design

---

# 1. Gameplay Overview & State Machine

## 1.1. Design Goals

Job system không được là kiểu:

> đứng checkpoint → nhận tiền.

Thiết kế phải có:

* nhiều giai đoạn rõ ràng;
* yếu tố thời gian / vận chuyển / công cụ;
* random route chống farm;
* state validation;
* anti-exploit từ thiết kế gốc;
* fail state hợp lý;
* dễ mở rộng sau này.

---

## 1.2. Core Gameplay Loop

```text
Nhận ca
   ↓
Di chuyển
   ↓
Thu thập nguyên liệu
   ↓
Mang hàng
   ↓
Xử lý / chế biến
   ↓
Vận chuyển
   ↓
Giao hàng / bán hàng
```

---

## 1.3. Gameplay Stages

### Stage A — Nhận ca / Chuẩn bị

Player:

* đăng ký ca;
* nhận task;
* thuê xe;
* nhận tool;
* trả phí đầu vào.

Có thể thêm:

* level requirement;
* skill requirement;
* confirmation prompt;
* mini-interaction nhẹ.

---

### Stage B — Thu thập nguyên liệu

Yêu cầu:

* random checkpoint;
* không tuyến cố định;
* carry giới hạn thực tế;
* animation phù hợp.

Ví dụ carry:

* 1 bao;
* 1 thùng;
* 1 bó hàng;
* 1 mẻ cá;
* 1 khối nguyên liệu.

---

### Stage C — Xử lý / Chế biến

Không nên bán raw material trực tiếp.

Ví dụ:

```text
Cá sống -> cân ký -> đóng thùng
Quặng -> nung -> tinh lọc
Gỗ -> bó kiện
```

Có thể thêm:

* mini-interaction;
* quality system;
* failure penalty.

---

### Stage D — Vận chuyển / Giao hàng

Player:

* giao cho NPC;
* giao kho;
* giao faction;
* giao player khác.

Yêu cầu:

* random delivery point;
* dynamic pricing;
* risk factor;
* cargo protection.

---

# 2. State Machine Design

## 2.1. Full State Machine

```pawn
JOB_STATE_NONE
JOB_STATE_ONSHIFT
JOB_STATE_TRAVELING
JOB_STATE_GATHERING
JOB_STATE_CARRYING
JOB_STATE_PROCESSING
JOB_STATE_DELIVERING
JOB_STATE_WAITING_MINIGAME
JOB_STATE_COOLDOWN
JOB_STATE_FAILED
JOB_STATE_OFFSHIFT
```

---

## 2.2. Core Rules

Mọi interaction đều phải check state.

Ví dụ:

* không bán khi chưa carry;
* không nhặt hàng khi đang deliver;
* không đổi job khi đang mang hàng;
* không bypass cooldown;
* không logout abuse.

---

# 3. Animation & Stamina System

## 3.1. Animation Rules

Mỗi action nên có:

* animation;
* delay;
* input lock;
* action timer.

---

## 3.2. Stamina Logic

### Khi stamina thấp

* move chậm hơn;
* animation lâu hơn;
* fatigue warning;
* giảm hiệu suất.

### Khi stamina = 0

* forced rest;
* temporary lock.

---

## 3.3. Carry Restrictions

Không cho:

```text
"nhét 50 khúc gỗ vào inventory"
```

Nên dùng:

* carry slot;
* cargo weight;
* vehicle storage;
* trunk inventory.

---

# 4. Anti-Bot / Mini-Game

## 4.1. Mini-Interaction Types

Ví dụ:

* nhập ký tự;
* bấm đúng phím;
* chọn đúng item;
* timing interaction;
* Y/N sequence.

---

## 4.2. Placement

Mini-game chỉ nên xuất hiện ở:

* mở ca;
* bắt đầu lô hàng;
* xử lý hàng;
* hàng giá trị cao.

---

## 4.3. Rules

* không spam captcha;
* random pattern;
* cooldown giữa các lần hỏi.

Sai captcha:

* reset action;
* tăng cooldown;
* log suspicion.

---

# 5. Economy Design

## 5.1. Economy Goals

Job phải:

* kiếm tiền ổn định;
* không phá economy;
* chống infinite farm;
* có progression.

---

## 5.2. Reward Formula

```text
Reward =
BasePay
+ TimeBonus
+ RiskBonus
+ SkillBonus
- FailurePenalty
- EconomyPenalty
```

---

## 5.3. Reward Factors

### Positive

* thời gian;
* rủi ro;
* skill;
* quality;
* distance.

### Negative

* fail state;
* economy saturation;
* repetitive farming.

---

# 6. Dynamic Economy

## 6.1. Global Variables

```pawn
GlobalSupplyCount
DailyJobVolume
RecentSoldAmount
```

---

## 6.2. Economy Rules

### Khi nhiều người bán

* giá giảm nhẹ.

### Khi ít người bán

* giá hồi dần.

---

## 6.3. Inflation Protection

Phải có:

* price floor;
* price ceiling;
* soft decay;
* recovery curve.

---

# 7. Entry Cost Design

Ví dụ:

* thuê xe;
* tool durability;
* processing fee;
* fuel;
* deposit;
* packaging cost.

---

## Goals

* chống spam;
* tạo investment loop;
* tạo decision making.

---

# 8. Skill Leveling

## Level 1

* chậm;
* ít reward;
* nhiều captcha;
* route khó hơn.

---

## Level 2

* cooldown thấp hơn;
* tool tốt hơn;
* tăng nhẹ productivity.

---

## Level 3

* unlock quality cargo;
* thêm carry slot hợp lệ;
* tuyến an toàn hơn.

---

## Level 4

* unlock advanced vehicle;
* giảm fail chance;
* tăng nhẹ sell price.

---

## Level 5

* unlock premium route;
* special contract;
* long shift capability.

---

## Balancing Rule

Skill:

```text
Tăng tiện lợi
≠
Máy in tiền vô hạn
```

---

# 9. Exploit Matrix

| Exploit          | Goal           | Detection                | Counter           |
| ---------------- | -------------- | ------------------------ | ----------------- |
| Teleport Hack    | đi quá nhanh   | distance/time validation | cancel reward     |
| Animation Bypass | chạy khi carry | animation check          | drop cargo        |
| Disconnect Abuse | tránh risk     | reconnect state check    | cargo persistence |
| Macro            | auto action    | timing pattern           | random prompt     |
| Multi-box        | farm nhiều acc | pattern analysis         | reward reduction  |
| Checkpoint Spam  | farm route     | repetition detection     | random route      |
| Vehicle Abuse    | chở quá tải    | vehicle validation       | deny loading      |

---

# 10. Teleport / Speedhack Protection

## Detection Logic

Lưu:

* start position;
* start time;
* expected travel time;
* vehicle type.

Khi đến nơi:

```text
distance / theoretical speed
```

Nếu bất thường:

* cancel job;
* log suspicion;
* increase suspicion score.

---

## Important Rule

Không punish mạnh ngay lần đầu.

Tránh false positive.

---

# 11. Animation Bypass Protection

## Threat

Player:

* jump;
* cancel anim;
* spam command;
* state bypass.

---

## Counter

Khi carry:

* lock sprint;
* lock jump;
* validate animation;
* validate attached object.

Nếu bypass:

* drop cargo;
* reset state;
* cooldown.

---

# 12. Disconnect Abuse Protection

## Problem

Player `/q` để:

* tránh cướp;
* giữ hàng;
* tránh thất bại.

---

## Solution

Khi disconnect:

```text
save cargo state
save job state
```

Có thể:

* drop world cargo;
* temporary storage;
* reconnect recovery;
* partial cargo loss.

---

# 13. Multi-box / AFK Farm Protection

## Detection

* repetitive timing;
* identical pattern;
* same IP behavior;
* no interaction.

---

## Counter

* random prompt;
* interaction check;
* reward scaling;
* admin audit log.

---

# 14. Multiplayer Job Expansion

Ví dụ:

* tài xế;
* bốc vác;
* kiểm hàng;
* bảo vệ;
* áp tải.

---

## Advantages

* tăng RP;
* chống solo farm;
* faction interaction;
* convoy gameplay.

---

# 15. Faction Interaction

Nếu hàng nhạy cảm:

Faction có thể nhận alert khi:

* hàng lớn;
* route bất thường;
* hoạt động ngoài giờ;
* cargo mismatch.

---

# 16. Player Variables

## Job State

```pawn
pJobID
pJobState
pJobSkill
pJobShiftActive
pJobCooldown
pJobFailCount
pJobWarningCount
```

---

## Cargo

```pawn
pJobCargoType
pJobCargoAmount
pJobCargoQuality
pJobCargoWeight
pJobCarryLimit
pJobCargoValue
pJobHasCargo
```

---

## RP / Stamina

```pawn
pJobStamina
pJobFatigue
pJobAnimLocked
pJobLastActionTick
pJobLastCheckpointID
pJobLastRouteHash
```

---

## Anti-Exploit

```pawn
pJobSuspicionScore
pJobLastMoveTick
pJobStartPosX
pJobStartPosY
pJobStartPosZ
pJobStartTime
pJobExpectedTravelTime
pJobAntiBotStage
pJobAntiBotPass
```

---

## Economy

```pawn
pJobEntryCostPaid
pJobPendingReward
pJobDailyJobCount
pJobDailyProfit
pJobEconomyMultiplier
```

---

# 17. Global Variables

```pawn
gJobSupplyCount[JOB_TYPE_MAX]
gJobDemandCount[JOB_TYPE_MAX]
gJobPriceBase[JOB_TYPE_MAX]
gJobPriceFloor[JOB_TYPE_MAX]
gJobPriceCeil[JOB_TYPE_MAX]
gJobPriceMultiplier[JOB_TYPE_MAX]
gJobActiveWorkers[JOB_TYPE_MAX]
gJobRandomPointPool[JOB_TYPE_MAX]
gJobShiftLimit[JOB_TYPE_MAX]
gJobCooldownPolicy[JOB_TYPE_MAX]
```

---

# 18. Task Structure

## Task Enum

```pawn
taskStage
taskProgress
taskSourcePoint
taskProcessPoint
taskDeliveryPoint
taskNeedVehicle
taskNeedItem
taskTimeLimit
taskRewardBase
taskRiskLevel
```

---

# 19. Missing Features Often Forgotten

## Fail State

Job fail khi:

* timeout;
* sai vehicle;
* bỏ animation;
* fail captcha;
* rời vùng quá lâu.

---

## Logging

Log:

* nhận job;
* complete stage;
* reward;
* disconnect;
* suspicion;
* delivery.

---

## Reconnect Recovery

Reconnect không được:

```text
reset exploit risk
```

---

## Weight / Capacity

Phải có giới hạn cho:

* player;
* vehicle;
* storage;
* processing area.

---

## Route Randomization

Random:

* source;
* process point;
* delivery point;
* timing;
* mini-game chance.

---

## High-Value Cargo

Hàng giá trị cao nên:

* nặng hơn;
* khó vận chuyển;
* high risk;
* faction alert;
* reward cao hơn.

---

# 20. Complexity Scaling Philosophy

## Core Principle

```text
Complexity must scale with reward.
```

---

# 21. Job Complexity Tiers

## Tier 1 — Simple Job

Ví dụ:

* quét rác;
* phát báo;
* rửa xe;
* hái trái cây.

### Chỉ cần

* basic state;
* random checkpoint;
* cooldown;
* animation;
* anti-idle nhẹ.

### Không cần

* dynamic economy;
* anti-speedhack;
* cargo persistence;
* faction interaction.

---

## Tier 2 — Medium Job

Ví dụ:

* mining;
* fishing;
* logistics;
* woodcutting.

### Cần

* full state machine;
* vehicle requirement;
* processing stage;
* anti-animation bypass;
* anti-macro.

---

## Tier 3 — Advanced Economy Job

Ví dụ:

* smuggling;
* convoy;
* black market;
* container logistics.

### MỚI cần

* dynamic economy;
* faction alert;
* disconnect persistence;
* convoy logic;
* multiplayer sync;
* audit log.

---

# 22. Minimal State Philosophy

## Simple Job

```pawn
JOB_STATE_NONE
JOB_STATE_WORKING
JOB_STATE_CARRYING
JOB_STATE_COOLDOWN
```

---

## Medium Job

```pawn
PROCESSING
DELIVERING
WAITING_INPUT
```

---

## Advanced Job

```pawn
FAILED
ESCORTED
UNDER_ATTACK
CUSTOMS_CHECK
CARGO_LOCKED
```

---

# 23. Anti-Exploit Scaling

## Simple Job

Chỉ cần:

* anti-spam;
* anti-idle;
* animation check;
* random route.

---

## Medium Job

Mới cần:

* timing validation;
* carry restriction;
* macro prevention.

---

## Advanced Job

Mới cần:

* travel estimation;
* disconnect penalty;
* cargo persistence;
* audit system;
* multi-box analysis.

---

# 24. MySQL Design Philosophy

## Chỉ lưu persistent data

### NÊN lưu

```text
skill
xp
unlock
license
statistics
large cooldown
```

---

### KHÔNG nên lưu

```text
current checkpoint
animation
temporary state
attached object
captcha state
runtime carry
```

---

## Runtime-only Data

Dùng:

* PVar;
* array;
* runtime memory.

---

# 25. Pawn Source Design Rules

## 1 Callback = 1 Responsibility

Không nên nhét:

* reward;
* mysql;
* anti-cheat;
* animation;
* checkpoint;
* logging;

vào callback 500 dòng.

---

# 26. Timer Design

## Sai lầm phổ biến

```text
1 timer / player / action
```

300 player = chết server.

---

## Tối ưu

Dùng:

* global processing tick;
* lightweight polling;
* centralized update loop.

---

# 27. Randomization Philosophy

Không cần:

```text
procedural generation
```

Chỉ cần:

* random checkpoint;
* random delay;
* random modifier;
* random interaction.

Là đủ phá macro.

---

# 28. Animation Design Philosophy

## Simple Job

Chỉ cần:

* animation;
* movement freeze nhẹ.

---

## Medium+

Mới cần:

* carry object;
* movement penalty;
* animation validation.

---

# 29. Final Design Philosophy

Một job tốt trong SA-MP RP là job:

* khó exploit;
* dễ hiểu;
* có RP;
* ít bug;
* ít timer;
* ít callback rác;
* dễ expand;
* maintainable sau nhiều tháng.

---

# 30. Important Final Principle

```text
Đừng build enterprise architecture
cho job kiếm 500$/phút.
```

SA-MP Pawn:

* không phải Unreal Engine;
* không phải MMO backend hiện đại;
* callback có giới hạn;
* timer có giới hạn;
* maintainability quan trọng hơn fancy system.
