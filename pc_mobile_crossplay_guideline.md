---
skill_name: samp_openmp_cross_platform_dev
description: Hệ thống nguyên tắc và hướng dẫn (guidelines) để phát triển server SA-MP (openMP) tương thích đa nền tảng giữa PC và Mobile.
target_audience: AI Agent / Code Assistant
version: 1.0
---

# TỔNG QUAN HỆ THỐNG (SYSTEM OVERVIEW)
Tựa game GTA San Andreas đã 20 năm tuổi, kiến trúc client của Mobile và PC có sự sai lệch lớn. Nhiệm vụ cốt lõi của AI Agent khi tạo tính năng là: **Luôn viết code nền tảng cho PC, nhưng BẮT BUỘC phải có logic fallback (dự phòng) hoặc tối ưu hóa cho Mobile.**

## RÀNG BUỘC CỐT LÕI (CORE CONSTRAINTS)
1. **Tuyệt đối không** giả định tất cả `playerid` có cùng thiết bị phần cứng hoặc phương thức nhập liệu (chuột/bàn phím).
2. Client Mobile cực kỳ nhạy cảm với giới hạn bộ nhớ (memory limits). Spam object/textdraw vô tội vạ sẽ dẫn đến Crash Client.
3. Không được sử dụng các phím bấm custom (Y, N, H) làm phương thức tương tác DUY NHẤT.

---

# BỘ QUY TẮC PHÁT TRIỂN (DEVELOPMENT RULES)

## 1. Phân loại Client (Client Detection System)
Mọi hệ thống xử lý logic phụ thuộc vào phần cứng phải đi qua bộ lọc kiểm tra client.

*   **Logic:**
    *   Sử dụng chuỗi Version (`GetPlayerVersion`) hoặc API từ plugin chuyên dụng (như `samp-android`) để định danh nền tảng.
    *   **Bắt buộc** khai báo và sử dụng macro/hàm kiểm tra xuyên suốt project.
*   **Pseudo-code tham chiếu:**
    ```pawn
    // AI Agent phải sử dụng hàm này trước khi render UI hoặc xử lý KeyState
    stock IsPlayerOnMobile(playerid) {
        // Implement logic check client version ở đây
        // Trả về true nếu là Mobile, false nếu là PC.
    }
    
2. Thiết kế Giao diện (UI/UX - TextDraws & Dialogs)
Phải cân bằng giữa "Con chuột" (PC) và "Màn hình cảm ứng" (Mobile).

Hitbox TextDraw:

RULE: Khi thiết kế TextDraw có thể click (TextDrawSetSelectable), hitbox (TextDrawTextSize) BẮT BUỘC phải đủ lớn để thao tác bằng ngón tay.

Tỉ lệ màn hình (Aspect Ratio):

RULE: Không neo (anchor) TextDraw ở sát lề màn hình. Điện thoại có nhiều tỉ lệ (16:9, 18:9, có tai thỏ). Luôn thiết kế UI có padding an toàn ở tâm màn hình.

Dialogs:

IF yêu cầu người chơi nhập text dài/phức tạp:

THEN cố gắng tránh DIALOG_STYLE_INPUT nếu có thể, vì bàn phím ảo sẽ che 50% màn hình mobile.

THAY THẾ BẰNG: DIALOG_STYLE_LIST hoặc DIALOG_STYLE_TABLIST với các option có sẵn.

3. Hệ thống Điều khiển (Key States & Controls)
Player PC có 104 phím, Mobile chỉ có các nút bấm cảm ứng mặc định của game.

RULE: KHÔNG được dùng OnPlayerKeyStateChange với các phím như KEY_YES (Y) hay KEY_NO (N) làm cách duy nhất để kích hoạt hệ thống.

FALLBACK PATTERN (Mẫu dự phòng):

Cách 1 (Ưu tiên): Gắn tương tác vào các phím vật lý chắc chắn có trên Mobile (Còi xe - KEY_CROUCH, Chạy - KEY_SPRINT, Nhắm bắn).

Cách 2: Nếu bắt buộc dùng phím PC, BẮT BUỘC phải tạo thêm lệnh chat thay thế (ví dụ: Tạo command /tuongtac song song với việc bấm Y).

Cách 3: Sử dụng 3D Text Label có tích hợp tính năng touch (nếu client có hỗ trợ).

4. Tối ưu hóa Streaming (Memory Anti-Crash)
Ngăn chặn tình trạng tràn RAM và crash trên thiết bị di động.

RULE: BẮT BUỘC sử dụng Streamer Plugin (Incognito) cho mọi Object, 3D Text Label, và Map Icon. Không dùng hàm gốc của SA-MP.

CONDITIONAL RENDERING:

IF IsPlayerOnMobile(playerid) == true:

THEN Giảm streamdistance và drawdistance của các thực thể xung quanh người chơi đó xuống mức an toàn (ví dụ: Giảm 30-50% so với cấu hình PC).

5. Cân bằng Gameplay (Combat & Auto-aim)
Nhận thức sự chênh lệch cơ chế bắn súng: Mobile có Auto-aim, PC có C-bug/Chuột.

RULE: Khi AI Agent thiết kế các mini-game, job, hoặc hệ thống PvP:

Xác định rõ tính chất của khu vực (Competitive hay Roleplay).

IF Competitive PvP: Đề xuất logic cô lập người chơi PC và Mobile vào 2 arena/dimension khác nhau.

IF Roleplay/Job: Thiết kế hệ thống ít phụ thuộc vào kỹ năng bắn súng phản xạ nhanh, tăng cường tương tác (tuyến tính, point-and-click).

ANTI-PATTERNS (NHỮNG ĐIỀU AI KHÔNG ĐƯỢC LÀM)
KHÔNG ĐƯỢC hardcode tọa độ TextDraw sát viền trục X (VD: X < 20 hoặc X > 600).

KHÔNG ĐƯỢC bắt người chơi Mobile thực hiện các chuỗi QTE (Quick Time Event) yêu cầu bấm phím liên tục.

KHÔNG ĐƯỢC spawn quá 500 object phức tạp (như cây cối độ phân giải cao) trong cùng một chunk hiển thị quanh một người chơi Mobile.