# S5 — KHUNG PHIÊN + HỒI QUY HL3 (chỉ-đọc, đếm grep + trích dòng)

Nguồn: `OmniCar.log.old` (đoạn hl3 = từ `2026-11-10 06:26:34` tới cuối file) + `OmniCar.log` (toàn bộ, đoạn cuối phiên hl3).
Đoạn hl3 gộp để đếm: 6.108 dòng (.old) + 783 dòng (.log) = **6.891 dòng**, 06:26:34.436 → 06:37:43.804.
Build của phiên: `build 1.0.3 (fbebb21) loaded into SpringBoard [fixround7]` (06:26:39.162).

## 1. Khung phiên + bản đồ PID + độ phủ

### Mốc từng file
- `OmniCar.log.old`: 12.808 dòng, 2.097.231 byte; toàn file 2026-11-09 22:18:40.002 → 2026-11-10 06:36:03.490.
  - Phần hl2: dòng 1–6.700, 22:18:40.002 → 22:29:32.631 (chỉ dùng xác định ranh giới).
  - Phần hl3: **dòng 6.701–12.808 (6.108 dòng)**, bắt đầu `2026-11-10 06:26:34.436 [SpringBoard:37965] AppBridge: loaded into SpringBoard`, kết thúc 06:36:03.490.
- `OmniCar.log`: 783 dòng, 109.087 byte (107K); 06:36:03.490 → 06:37:43.804. **Đây là đoạn CUỐI của phiên hl3** (100 giây cuối), sinh ra do log xoay vòng (rotation) tại 06:36:03.490 — không phải một phiên riêng.

### Độ phủ — KHÔNG mất đoạn giữa
- Vết nối liền mạch tuyệt đối: dòng cuối .old và dòng đầu .log cùng timestamp **06:36:03.490**:
  - .old cuối: `2026-11-10 06:36:03.490 [CarPlay:37987] SplitScreen: [touchset] t=343963.232 ev=343963.230 active=0 (empty)`
  - .log đầu: `2026-11-10 06:36:03.490 [Facebook:38006] AppBridge: [do] bw probe seq=41 ph B=2 M=43 E=2 C=0 dur=0.42 ...`
- Trong nội bộ hl3 chỉ có 3 khoảng lặng >5s, đều là lúc không hoạt động (10,5s chờ weather warming lúc khởi động 06:26:39→06:26:49; 5,7s lúc 06:30:56→06:31:02; 11,2s lúc 06:31:02→06:31:13) — không phải mất log. Lệch timestamp liên tiến trình chỉ ở mức ms (jitter ghi log đa tiến trình).
- Lưu ý ngoài phạm vi: giữa hl2 (kết 22:29:32 ngày 09/11) và hl3 (bắt 06:26:34 ngày 10/11) trong .old là khoảng qua đêm giữa hai thế hệ — không thuộc phiên hl3.

### Bản đồ PID hl3 (process → PID, số dòng, khoảng sống)
| Process | PID | Dòng | Từ → tới |
|---|---|---:|---|
| SpringBoard | 37965 | 528 | 06:26:34.436 → 06:37:43.804 (toàn phiên) |
| CarPlay | 37987 | 5.663 | 06:26:51.133 → 06:37:33.928 |
| GOFA | 37991 | 83 | 06:26:56.640 → 06:37:24.163 |
| YouTube | 37993 | 60 | 06:27:04.299 → 06:28:22.953 |
| YouTube | 37999 | 115 | 06:28:30.670 → 06:30:55.770 |
| YouTube | 38003 | 48 | 06:31:20.709 → 06:33:33.712 |
| Facebook | 38006 | 129 | 06:33:34.063 → 06:36:12.051 |
| TikTok | 38009 | 63 | 06:36:24.921 → 06:37:34.923 |

### Đổi PID giữa phiên?
- SpringBoard 37965 và CarPlay 37987: **không đổi** — khớp PID đầu/cuối như đề bài nêu; GOFA/Facebook/TikTok cũng mỗi app 1 PID.
- YouTube có **3 PID = 2 lần restart/re-host**, đều là detach có trật tự, không có crash:
  - `2026-11-10 06:28:22.953 [YouTube:37993] AppBridge: [pinch2] detached` → incarnation mới `2026-11-10 06:28:30.670 [YouTube:37999] AppBridge: [do] bw cai sendEvent probe (com.google.ios.youtube)` (+7,7s).
  - 37999 detach 3 lần (06:30:08.264, 06:30:17.573, lần cuối 06:30:55.770) → `2026-11-10 06:31:20.709 [YouTube:38003] AppBridge: [do] bw cai sendEvent probe ...` (+24,9s).
  - 38003 dừng ở 06:33:33.712 (`[kbstate] reporter-stop`), ngay sau đó Facebook:38006 nhận ô hosted từ 06:33:34.063.

## 2. Lỗi toàn cục + scenevis
- Đếm grep thô trong đoạn hl3: `exception` = **0**, `fatal` = **0**, `crash` = **1**, `error` = **9**, `fault` = **19** — tất cả đều là dương tính giả:
  - `crash` 1 dòng và 8/9 dòng `error`, 19/19 dòng `fault` nằm trong các dump DIAG liệt kê selector/ivar lúc 06:27:00 (vd selector `receiveObservedError:`, chuỗi `default` chứa "fault") — không phải lỗi runtime.
  - Dòng `error` thật duy nhất là tin tốt: `2026-11-10 06:26:50.876 [SpringBoard:37965] StartupScreen: weather: updated in 1.2s (http 200, no error)`.
  - **Kết luận: 0 exception / 0 fatal / 0 crash thật trong hl3.**
- `[scenevis]` = **55 dòng**: verify 16, host-attach 8, host-state-ready 7, attach 6, going-home 6, detach-bg 4, invalidate 4, pane-remove 2, detach 2.
  - Không ca bất thường trên scene thật: 0 dòng `hidden=1`, 0 dòng `alpha=0.xx`; `scene=nil` 26 dòng đều là ô hosted slot0 (YouTube, attached=0 inHost=1) — mẫu quen thuộc của phiên.
  - Điểm lạ duy nhất là đọc trị sentinel của ô trống khi đóng: 3 dòng `going-home bundle=? slot=… scene=nil attached=0 inHost=0 hidden=-1 alpha=-1.00 window=0` (06:28:22.942, 06:30:17.471, 06:30:55.652) — ô rỗng, không phải scene hiển thị bị lỗi.

## 3. AutoHide — vòng đời fade/reveal
- Tổng `[autohide]` = 477 dòng. Chuỗi chính: `fade last=…` **32** (app 20: idle 4.00×16 + 4.01×3 + 4.02×1; container 8: 4.00×6 + 4.01×2; dragend 4.00×4) → `host fade applied` **32** + `host knob fade applied` **32** → `host fade restored` **32** + `host knob fade restored` **32**; phía CarPlay `reveal-applied reason=activity views=4` chỉ **31**.
- Phụ: fade deferred 29 (kbunknown 16, surface-open 7, kb 6), hold reason=kbunknown 16, kb hold released 15, session start 6, close-cleanup faded=0 ×4, teardown faded=1 ×1 + faded=0 ×1.
- Thời lượng mờ (applied → restored) của 32 cặp: 242 ms … 27.318 ms.
- **Thoát split lúc mờ → mở lại: CÓ dữ kiện, đúng 1 ca** (không phải NO-DATA kỳ này):
  - `2026-11-10 06:31:35.511 [SpringBoard:37965] AppBridge: [autohide] host fade applied bundle=com.google.ios.youtube`
  - `2026-11-10 06:31:36.756 [CarPlay:37987] SplitScreen: [autohide] teardown faded=1` — thoát sau 1.245 ms, **không có reveal/restore ở giữa**.
  - `2026-11-10 06:31:49.870 [CarPlay:37987] SplitScreen: [autohide] session start` (mở lại)
  - `2026-11-10 06:31:49.899 [SpringBoard:37965] AppBridge: [autohide] host fade restored bundle=com.google.ios.youtube` — **restored 29 ms sau session start** (14.388 ms sau fade applied).
  - Chính ca này giải thích restored 32 > reveal-applied 31: lần restored khi mở lại không đi qua reveal-applied.
- Các lần đóng còn lại đều sạch: close-cleanup faded=0 (06:28:22.942, 06:30:08.241, 06:30:17.471, 06:30:55.652) và teardown faded=0 cuối phiên (06:37:29.516).

## 4. FS qua đường khác (không pinch)
- `[fs1]` toàn phiên chỉ 3 dòng:
  - `2026-11-10 06:26:51.148 [CarPlay:37987] SplitScreen: [fs1] fs controller installed (CarPlayApp)`
  - `2026-11-10 06:35:47.503 [CarPlay:37987] SplitScreen: [fs1] fs expand confirmed txn=1 provenance=pinch` — đường pinch, **loại khỏi mục này**.
  - `2026-11-10 06:37:29.518 [CarPlay:37987] SplitScreen: [fs1] fs session-end abbreviated restore provenance=teardown` — dọn dẹp cuối phiên, không phải nút/gesture của người dùng.
- **Expand/restore bằng nút/gesture khác: 0 lần; confirmed 0; refused 0.** Không có dòng fs refused nào; "snap refused" không tồn tại — 9 hit grep `snap` = 5 dòng `[ytz-revoke-snap]` + 4 dump DIAG chứa selector snapshot.

## 5. YTZ — grant/ack/revoke, mismatch, mask
- Không có từ "grant" nguyên văn; tương đương grant: `[ytz] lease cap` **5** + `[ytz] lease gia han` **5** (SpringBoard cấp/gia hạn), `[ytz] lease nhan` **25** + `[ytz] relay ap` **25** (app nhận/áp), `ao hoa BAT` **5**.
- `[ytz] ack` = **136**: phase=applied 25, phase=request 108, phase=revoked 3. Mọi dòng mang `mismatch=` (161 = 136 ack + 25 relay) đều `mismatch=0` → **mismatch tổng = 0**, windows chỉ 0/1 khớp phase.
- Revoke: `[ytz-revoke-snap]` **5** (tất cả `ly do=teardown`, YouTube, gen 1/14/16/18/29: 06:28:22.938, 06:30:08.248, 06:30:17.477, 06:30:55.651, 06:33:28.864); `ao hoa TAT ly do=revoke` **3** và ack phase=revoked **3**. Hai revoke-snap gen=14 (06:30:08.248) và gen=16 (06:30:17.477) không có TAT/ack-revoked tương ứng — hai phiên rất ngắn, không thấy dấu ảo hoá đã bật.
- Mask: **không có dòng nào ghi rò mask**. Báo cáo hướng của app: `bao SpringBoard: ma 255, mask 2` ×12 (YouTube 1, Facebook 11) và TikTok `ma 255, mask 30` ×2 (06:36:28.344, 06:37:01.018) — là mask do chính app báo, ack SpringBoard sạch (mismatch=0). 5 dòng `CarSplit: chan deactivate scene (mask=0)` là chặn deactivate, không phải rò.

## 6. Home icon + dock
- `[home-launch]` = **46 dòng** (model 20, tap-gate 7, home-callback 6, tap 6, declaration 4, reconcile 2, library 1).
- **Routed: 6/6 lần chạm icon** — mỗi lần đều `phase=tap-gate … status=consumed-own-icon` rồi `phase=tap … status=routed-existing-panel`:
  06:26:55.947, 06:28:26.068, 06:30:12.396, 06:30:15.276, 06:30:19.573, 06:31:14.867 (đều `bundle=com.anlai.omnicar.app`, `source=iconManager:launchIconForIconView:`).
- Dock cũ: **không xuất hiện**. Bằng chứng: dump cây view cho `SBDockIconListView … count: 0` và `SBDockView … frame = (0 0; 0 0)`; dock hiện diện trong phiên là vùng của CarSplit `dock={{0, 124.666…}, {45, 111}}` (7 dòng geometry `content=… dock=… -> vung app={{45, 0}, {595, 360}}`). Hai dòng `CarSplit: gan giu icon vao SBDockIconListView` (06:26:52.808, 06:31:44.839) là ghim icon, không phải dock cũ hiện hình.
- Nhấn giữ icon: **0 sự kiện thật** — 4 hit grep `long` đều nằm trong dump DIAG (vd tên selector `_backLongPressed:`), không có dòng long-press nào của icon.

## 7. Native feed + act posted/accepted
- `[probe-feed]` = **265 dòng**, trong đó **fired 55** — tất cả ở ô native slot1: GOFA 38 (epoch1: 8, epoch3: 23, epoch7: 1, epoch9: 1, epoch10: 5) + Google Maps 17 (epoch10). Còn lại: drop-hosted 147, drop-inactive 42, drop-popup 15 (picker 14, traywindow 1), drop-systemregion 4, drop-unconverted 1, drop-notassigned 1. Fired đầu 06:27:24.849 (GOFA), cuối 06:37:21.788 (Maps).
- Act: `act-posted` **106** (YouTube 15+29+4 theo 3 PID, Facebook 42, TikTok 16) vs `act-accepted` **106** → **lệch 0** (kỳ trước lệch 1).
- Seq liên tục từng incarnation, không thiếu seq nào: YouTube-37993 seq 1–15; YouTube-37999 seq 1–29 — **seq=19 (seq thiếu kỳ trước) có mặt kỳ này**: `2026-11-10 06:30:02.685 [CarPlay:37987] SplitScreen: [autohide] act-accepted bundle=com.google.ios.youtube kb=1 seq=19 -> ahNoteActivity`; YouTube-38003 seq 1–4; Facebook seq 1–42; TikTok seq 1–16.

## 8. Weather / knob
- Weather: **không có req# nào trong hl3** — không có request thời tiết từ CarPlay. Hoạt động weather duy nhất là ans#1 lúc khởi động, và log tự ghi rõ không phải request:
  - `2026-11-10 06:26:49.679 [SpringBoard:37965] StartupScreen: [weather] source=warming-cache (internal startup call, NOT a CarPlay request)`
  - `2026-11-10 06:26:49.679 … [weather] ans#1 begin` → `fetch-begin source=nav app's (480 min old)` 06:26:49.696 → `weather: updated in 1.2s (http 200, no error)` 06:26:50.876 → `[weather] ans#1 ready-posted` 06:26:50.877.
  - Kết luận mục req#: **NO-DATA** (chuỗi req# không hề bắt đầu trong phiên).
- Knob: chỉ xuất hiện trong cặp AutoHide `host knob fade applied` 32 / `host knob fade restored` 32 (đi cùng fade thường, xem mục 3). Không có tag `[knob]`, không có field payload/ratio/menu nào cho knob trong toàn đoạn hl3 → **knob payload: NO-DATA**.

## Verdict S5 (ngắn)
1. Khung/PID/phủ: hl3 = 06:26:34.436→06:37:43.804, 6.891 dòng; .log là đoạn cuối 100s sau rotation; vết nối 06:36:03.490 khớp tuyệt đối — **không mất đoạn giữa**. SpringBoard/CarPlay 1 PID suốt phiên; YouTube 3 PID do 2 lần re-host có trật tự.
2. Lỗi: **0** exception/fatal/crash thật (mọi hit là dump DIAG); scenevis 55 dòng, không ca bất thường trên scene thật.
3. AutoHide: 32 fade / 32 restored / 31 reveal; **có 1 ca thoát split lúc mờ** (teardown faded=1 06:31:36.756) và **mở lại restored sau session start 29 ms** (06:31:49.899).
4. FS khác pinch: **0 lần** (chỉ 1 expand provenance=pinch + 1 restore provenance=teardown dọn phiên); refused 0, snap refused không có.
5. YTZ: lease cap/gia hạn 5/5, nhận/áp 25/25, ack 136 (applied 25/request 108/revoked 3), revoke-snap 5; **mismatch = 0**, không rò mask.
6. Home/dock: [home-launch] 46 dòng, **routed 6/6**; dock cũ không xuất hiện; nhấn giữ icon 0.
7. Native feed: fired **55** (GOFA 38 + Maps 17); act posted/accepted **106/106, lệch 0** — seq=19 có mặt, không thiếu seq.
8. Weather/knob: req# **NO-DATA** (chỉ ans#1 warming-cache lúc khởi động); knob payload **NO-DATA** (chỉ có cặp knob fade applied/restored 32/32).
