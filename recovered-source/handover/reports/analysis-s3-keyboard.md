# S3 — BÀN PHÍM + KBSTATE — PHIÊN YTZ5HL1 (bước 4, ĐIỂM HỎNG 2)

Chỉ-đọc trên log gốc. Mọi đếm bằng grep trên file gốc
`OmniCar.log` + `OmniCar.log.old` (thư mục session-ytz5hl1).
Nhãn: LOG-CONFIRMED = có dòng ghim; CONTRADICTS = log ngược
khẳng định; NO-DATA = log không có dữ kiện.

## 0. Phạm vi thế hệ — loại ytz4

- `.old` gồm HAI thế hệ. Thế hệ cũ ytz4: dòng 1–2477,
  17:40:49–17:49:22, SpringBoard:36240 / CarPlay:36056-36168.
  Thế hệ MỚI bắt đầu tại dòng 2478 của `.old`:
  `2026-11-09 20:18:10.158 [SpringBoard:36658] AppBridge: loaded into SpringBoard`
  và chạy tiếp qua hết `OmniCar.log` (đến 20:52:18,
  CarPlay:36712). Mọi kết luận dưới đây CHỈ trên thế hệ mới
  (20:18:10 → 20:52:18; SpringBoard:36658/36711;
  CarPlay:36683 rồi 36712; YouTube:36693 rồi 36733).
- Bằng chứng ranh giới sạch: trong 2477 dòng ytz4 của `.old`,
  `grep -c kbstate` = 0 và `grep -c ytz5-k5` = 0 — kênh
  kbstate và cổng ytz5 CHỈ tồn tại ở thế hệ mới. Toàn bộ
  626 dòng kbstate của `.old` đều nằm từ dòng 2478 trở đi.
- `OmniCar.log` tự nó chứa 2 đoạn của thế hệ mới: đuôi phiên
  CarPlay:36683 (gen=20, 20:36:45→~20:38) và phiên
  CarPlay:36712 (gen=1, session=2366851231, →20:52:18).

## 1. Cổng bàn phím: NATIVE — LOG-CONFIRMED phía host

Token recon dự đoán không tồn tại trong log:
`grep -c drawnKeyboard` = 0/0 (cả hai file); `grep -c drawn`
= 0/0; `grep -c ABPostOrientation` = 0. Biến thể ghi log
thật của cổng là tiếng Việt `[ytz5-k5] cong ban phim doi:`.

Cổng trên thiết bị = **native**, 7 lần, KHÔNG một lần nào
khác, toàn bộ đều phía SpringBoard (host), sự kiện
prefschanged:
- `2026-11-09 20:27:39.611 [SpringBoard:36658] AppBridge: [ytz5-k5] cong ban phim doi: native (prefschanged)` (.old)
- `2026-11-09 20:36:06.315` + `20:36:06.763 [SpringBoard:36658]` cùng nội dung (.old)
- `2026-11-09 20:39:33.964`, `20:39:35.140`, `20:39:43.156`,
  `20:39:44.852 [SpringBoard:36658]` cùng nội dung (OmniCar.log)

App YouTube có nhận được giá trị đó không — **NO-DATA ở mức
trường dữ liệu**: phía app (YouTube:36693/36733) không có
dòng nào ghi cổng, không trường drawn/native nào trong log
app. Payload host→app chỉ lộ qua dòng nhận hướng:
- `2026-11-09 20:36:06.319 [YouTube:36693] AppBridge: huong o 1, thiet bi gia 1 (doi=0)`
- `2026-11-09 20:36:06.768 [YouTube:36693]` cùng nội dung —
  trùng khớp từng mili-giây với 2 sự kiện prefschanged
  20:36:06.315/.763 phía host: app CÓ nhận payload hướng
  ngay tại các mốc cổng đổi (payload là kênh chở trường
  cổng theo thiết kế), nhưng log không in giá trị cổng
  phía app nên không ghim được "app đọc drawn=0".
- Gián tiếp LOG-CONFIRMED: app hành xử đúng native — app
  báo ACTIVE khi first responder thật bật (mục 2); phía
  app không có bất kỳ dòng suppression/publish nào:
  `grep -i suppress` (trừ dòng DIAG dump) = 0 trên toàn
  thế hệ mới; `grep -i firstResponder` tương tự = 0;
  `grep -ci UIKeyboard` = 0 ở MỌI process.

## 2. Các tập mở nhập liệu YouTube — app CÓ báo ACTIVE

Log không ghi nhãn UI "tìm kiếm" (grep search/tim kiem chỉ
trúng dump giao diện SpringBoard) — NO-DATA về nhãn. Nhưng
toàn phiên chỉ có ĐÚNG 2 cửa sổ kbstate state=1 (ACTIVE),
cùng hash d3b4e0d = YouTube, cùng session=2089400554; đây
là hai ứng viên duy nhất cho thao tác mở tìm kiếm của
Nguyen. Cả hai đều ở phần `.old` của thế hệ mới;
`OmniCar.log` (20:36:45→20:52:18) có state=1 = **0 lần**.

TẬP A (slot 0→1): mở 20:25:46.499, chớp tắt, mở lại:
- A1: `20:25:46.499 [CarPlay:36683] [kbstate] accept slot=0 hash=d3b4e0d gen=3 session=2089400554 seq=63 state=1 source=app-input-session`
  → seq=67 (20:25:49.420); tắt seq=68 state=0 lúc
  20:25:49.856 kèm `[autohide] kb hold released`.
- A2: seq=70 state=1 lúc 20:25:51.122, liên tục qua đổi ô
  (gen=4, slot=1 từ seq=82, 20:26:02.420) tới seq=110
  20:26:30.424; kết thúc seq=111 state=0 lúc 20:26:31.130.
  A1+A2 = 46 báo cáo state=1 (seq 63–67 và 70–110, seq
  liên tục không đứt — mục 4).

TẬP B (slot 1): `20:35:46.138 [CarPlay:36683] [kbstate] accept slot=1 hash=d3b4e0d gen=20 session=2089400554 seq=565 state=1 source=app-input-session`
→ seq=593 (20:36:13.414); kết thúc seq=594 state=0 lúc
20:36:14.074. Tổng 29 báo cáo state=1, ~27 giây.

Owner: cả 75 báo cáo ACTIVE đều **accept**, 0 reject trong
cửa sổ ACTIVE. Ngay sau báo cáo đầu mỗi tập, funnel phát:
`20:25:46.500 [kb-sync] emit com.google.ios.youtube gen=3 seq=231 known=1 active=1 source=app-input-session` (chậm 1 ms).

[kb-sync] cũ: KHÔNG còn kênh panel riêng — funnel emit nay
chở chính nguồn mới (mục 4). Kênh host cũ chỉ còn 6 dòng
`[kb-sync] host post ... active=0 session=0 source=host-keyboard-session`
phía SpringBoard (20:26:49.753; 20:31:14.409; 20:32:19.118;
20:32:30.205; 20:33:36.881; 20:33:49.850) — TẤT CẢ ở mốc
đóng ô, active=0, KHÔNG dòng nào trong hai tập ACTIVE:
host không hề post/chặn panel trong lúc phiên nhập liệu mở.

## 3. AutoHide trong hai tập: GIỮ vì kb — LOG-CONFIRMED

- `fade deferred (kb)` toàn phiên = 11, nằm trọn trong hai
  tập: tập A2 có 5 (20:26:09.563; 20:26:18.577;
  20:26:22.579; 20:26:26.580; 20:26:30.582), tập B có 6
  (20:35:51.632; 20:35:55.633; 20:35:59.634; 20:36:03.636;
  20:36:07.637; 20:36:11.638) — nhịp ~4 s đúng chu kỳ xét
  fade. Tập A1 (~3 s) chưa tới lượt xét fade; thay vào đó
  act-accepted mang kb=1: `20:25:47.880 [autohide] act-accepted bundle=com.google.ios.youtube kb=1 seq=10`.
- Fade THẬT (`fade last=...` + host fade applied) trong
  lúc ACTIVE: **0**. Các fade last kề nhất nằm NGOÀI cửa
  sổ: 20:25:44.004 (trước A1), 20:26:35.133 (sau A2 đóng
  4 s), 20:35:31.182 (trước B), 20:36:18.077 (sau B đóng
  4 s). Không fade nào cắt ngang phiên nhập liệu.
- Nhánh kbunknown cũng chạy thật: `hold reason=kbunknown`
  + `fade deferred (kbunknown)` = 5 cặp — 2 cặp đầu phiên
  36683 (20:24:37.092; 20:24:41.093, trước báo cáo kbstate
  đầu tiên 20:24:44.418) và 3 cặp đầu phiên 36712
  (20:40:18.275; 20:40:22.277; 20:40:26.278), nhả đúng lúc
  báo cáo hợp lệ đầu tới: `20:40:28.852 [kbstate] accept ... gen=1 session=2366851231 seq=1 state=0` + cùng mili-giây
  `[autohide] kb hold released -> idle reset`.

## 4. Chuỗi kbstate có KHÉP không: CÓ, trọn vòng

Báo cáo nguồn → owner → emit → fade gate, đếm toàn thế hệ
mới (grep trên 2 file gốc cộng lại):
- [kbstate]: accept **1425** (state=1: 75; state=0: 1350),
  reject **5** — noassignment ×3 (`20:31:15.417 seq=383`,
  `20:31:16.421 seq=384`, `20:31:17.417 seq=385`, gen=10:
  báo cáo tới sau khi ô đã đóng), badgen ×2
  (`20:38:16.413 seq=717 slot=0`, `20:38:17.423 seq=718 slot=1`,
  gen=20 đã cũ so với assignment gen 19/22). badhash = 0,
  badsession = 0, staleseq = 0.
- Seq: session 2089400554 chạy 1→720 KHÔNG đứt quãng;
  session 2366851231 chạy 1→710 KHÔNG đứt quãng (kiểm
  sort+uniq+gap = rỗng). Độ trễ accept→emit ~0–1 ms (cùng
  mili-giây, vd 20:25:46.499→.500).
- [kb-sync] emit source=app-input-session: known=1
  active=1 = **148** (phủ cả hai tập), known=1 active=0 =
  2698, known=0 = 33. Ca stale→UNKNOWN có thật: sau 2
  reject badgen 20:38:16–17, emit tụt known=0 (gen=19/22,
  20:38:16.119→20:38:18.119) và phía app probe báo
  `kbKnown=0 kbSrc=none failopen=unknown` từ 20:38:22.055
  — đúng thiết kế tụt UNKNOWN khi nguồn mất hiệu lực,
  không kẹt ACTIVE giả.
- Fade gate dùng số liệu đó thật: mục 3 (deferred kb 11,
  kbunknown 5, 0 fade trong ACTIVE).

## 5. KẾT LUẬN PHÂN ĐỊNH: chọn (i) — LOG-CONFIRMED theo chuỗi

**(i) ĐÚNG.** App báo ACTIVE thật (75 lần, accept toàn bộ,
theo đúng định nghĩa thiết kế: ACTIVE chỉ sau khi xác
nhận first responder thật) → owner nhận → [kb-sync] phát
active=1 (148 lần) → fade gate giữ controls vì kb (11 lần
deferred, 0 fade lọt). Cổng host = native (7/7 dòng), host
không post/chặn panel nào trong cửa sổ ACTIVE, phía app
không có dòng suppression nào. Toàn bộ phần bridge đo
được đều ĐÚNG — mà màn xe của Nguyen: phím KHÔNG HIỆN.
Vậy điểm hỏng nằm ở tầng xe: cửa sổ phím hệ thống không
được dựng/trình bày trên màn CarPlay cho scene hosted,
dù app đã thành first responder thật ở phía điện thoại.
Cơ chế bridge vô tội trong phạm vi log chứng minh được.

**(ii) BỊ BÁC — CONTRADICTS.** Nhánh này đòi cổng lệch
hoặc không tới app + host chặn panel đồng thời. Log
ngược cả hai vế: cổng native nhất quán 7 lần không một
dòng drawn nào; app nhận payload hướng trùng mili-giây
với sự kiện cổng (20:36:06.315↔.319, .763↔.768); 6 dòng
host post đều active=0 tại mốc đóng ô, ngoài cửa sổ
ACTIVE. Không có dòng nào làm điểm ghim cho (ii).

Giới hạn trung thực (không đổi kết luận): (a) log không
in trường cổng phía app và không có dòng inputView nào
theo cả hai chiều (suppress = 0, publish phím = 0) —
việc "app không blank inputView" là SUY LUẬN từ cổng
native + hành vi ACTIVE, không phải dòng ghim trực tiếp
(NO-DATA ở mắt xích vi mô này). (b) Log không nhãn UI
nên hai cửa sổ ACTIVE được xác định là "phiên nhập liệu
YouTube duy nhất của phiên", khớp verdict xe của Nguyen
về mở tìm kiếm, nhưng log tự nó không ghi chữ "search".
(c) Không tồn tại dòng nào về cửa sổ phím hệ thống ở bất
kỳ process nào (UIKeyboard = 0): tầng xe câm log hoàn
toàn — kết án tầng xe dựa trên chuỗi bridge khép kín +
đáp án màn hình KHÔNG HIỆN, không dựa trên dòng lỗi của
chính tầng xe.
