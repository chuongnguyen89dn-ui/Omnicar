# S4 — YTZ + linh tinh, ytz4

Phạm vi: log.old 10.889 dòng (16:35:40–17:40:48) + log 1.678 dòng (17:40:49–17:44:31); đối chiếu `fix-y2s-revokesnap.md`.

## 1) YTZ chính — DEVICE PASS (lease/ack); OFF control: NO DATA

Lease cap 8, `split=1` ×8 / `split=0` ×0; thu hồi 8, tất cả `ly do=teardown`. Ack SpringBoard 54 = applied 51 (mọi dòng `windows=1 mismatch=0`) + revoked 2 (`w=0 m=0`) + request 1; relay app 51 khớp. Baseline ytz3 applied 38/38 → nay 51/51. Trong `[ytz]`: expired 0, lapse 0, fallback 0, mismatch≠0: 0.
Mask 24 lọt: 0; cả 5 dòng đều là chặn ở YouTube, vd: `2026-11-09 16:36:34.196 [YouTube:35060] AppBridge: bo qua su kien xoay gia: app dang chi cho mask 24`. Cộng hưởng: `tieu thu tuyen bo (lease song)` ×13, `chan apporient` ×3.
OFF control: KHÔNG có ca nào — `ly do=pref` 0, snap pref 0. Mọi revoke đều teardown ⇒ không cửa sổ OFF, không độ dài OFF, không hành vi-khi-OFF để trích. pref→re-grant: PENDING/NO DATA.

## 2) [ytz-revoke-snap] / [ytz-nextlayout] — PASS một phần (instrument chạy; cặp 3/7)

Snap 7, nextlayout 3. Thu hồi 8 nhưng snap 7: ca sớm nhất 16:54:00.206 (SpringBoard 35036, `lease thu hoi ly do=teardown`) không có snap kèm; 7 ca sau khớp 1-1 cùng mốc.
Snapshot đầu tiên (nguyên văn):
`2026-11-09 17:33:38.370 [SpringBoard:35973] AppBridge: [ytz-revoke-snap] ly do=teardown bundle=com.google.ios.youtube hash=d3b4e0df gen=11 logical=248x428 pub=248x428 box=198x342.667 frame=45,0,198x342.667 reqOrient=0 paneOrient=1 settingsOrient=1 lastDecl=unavailable`
`lastDecl=unavailable` ở 7/7 snap + 3/3 nextlayout — khớp thiết kế (trường cố định).
Cặp: 3 snap đầu (cùng SpringBoard 35973) đều có nextlayout theo sau + grant `prevRevoke` khớp `dt`: 17:33:38→17:33:50 dt=12.207; 17:34:06→17:37:30 dt=203.752; 17:38:19→17:38:27 dt=8.805. Bốn snap còn lại (17:40:07, 17:41:11, 17:43:04, 17:44:20) KHÔNG có nextlayout: grant kế tiếp là grant tươi `gen=0` ở SpringBoard pid mới, không `prevRevoke` (ca cuối: log hết).
Số đo layout đầu sau re-grant vs snap (chỉ số): cặp 1 logical 248x428→371x428, box 198→297, frame x 45 giữ; cặp 2: 80x428→248x428, box 64→198; cặp 3: 30x428→248x428, box 24→198, frame x 616→45. Cả 3: pub=logical hai đầu; reqOrient/paneOrient/settingsOrient giữ 0/1/1.

## 3) WEATHER — NO DATA (yêu cầu thật vẫn 0)

`req#`: 0 dòng cả hai file — không yêu cầu thật nên bộ đếm không tăng. `ans#` chỉ `#1` ×15 (mỗi chu kỳ warming 3 dòng begin/fetch-begin/ready-posted, reset theo SpringBoard mới). Warming: 5 chu kỳ (16:54, 17:22, 17:40, 17:42, 17:43), mỗi chu kỳ tự ghi: `[weather] source=warming-cache (internal startup call, NOT a CarPlay request)`. updated 5/5 (`updated in 1.0–1.2s (http 200, no error)`), timeout 0, display 0. Chuỗi request→answer→display khép: 0 lần — như hai phiên trước.

## 4) KNOB — NO DATA

`publishKnobsNow` 0, `knobs` 0, payload-knob 0 (5 hit `payload` là dump DIAG selector). Từ `knob` 69 dòng, chỉ 3 dạng không số đo hình học: `host knob fade applied` ×36, `fade restored` ×31, `fade last=hostknob idle=<s>` ×2. Không dòng nào mang cỡ/vị trí/opacity knob.

## 5) [scenevis] — DEVICE PASS (verify 39/39)

Tổng 135; verify 39, bất thường 0 — cả 39 đều `attached=1 inHost=1 hidden=0 alpha=1.00 window=1`.
`attached=0`: 59 dòng, TẤT CẢ `scene=nil` (ca cấu trúc đã biết): host-attach 15, host-state-ready 14, going-home 12, detach-bg 10, pane-remove 4, host-state-gone 2, invalidate 2 — cộng 2 dòng sentinel dưới đây. Hidden bất thường ngoài nhóm này: 0.
Hai dòng khác hẳn (lúc teardown YouTube 17:34:06/17:38:19, kèm `detach bundle=? slot=-1 inHost=0`):
`2026-11-09 17:34:06.367 [CarPlay:35998] SplitScreen: [scenevis] going-home bundle=? slot=0 scene=nil attached=0 inHost=0 hidden=-1 alpha=-1.00 window=0`
`2026-11-09 17:38:19.133 [CarPlay:35998] SplitScreen: [scenevis] going-home bundle=? slot=0 scene=nil attached=0 inHost=0 hidden=-1 alpha=-1.00 window=0`

## 6) Quét lỗi toàn cục — PASS (0 lỗi thật)

Theo loại: exception 0, NSInvalidArgument 0, KVC 0, SIGBUS 0, SIGSEGV 0, `khong the` 0, `Error Domain` 0, `fault` dạng từ độc lập 0. Hit thô lành tính đã loại: `fault` 95 = substring của `default` trong DIAG; `crash` 5 = selector trong DIAG dashboard; `error` 50 = DIAG + `no error` của weather. Không có 3 dòng đáng ngờ thật; gần nhất là hai dòng `bundle=?` mục 5 (đã trích).

## Tách bạch

Có bằng chứng: mọi con số/dòng trích trên, đếm trực tiếp trên 2 file.
Đang giả định: (a) ca 16:54:00 thiếu snap — log không nói lý do, không kết án; (b) vắng nextlayout ở 4 snap cuối hiểu theo giới hạn instrument ở biên bản fix-y2s (republication ở SpringBoard mới không mang pending cũ) — hợp số liệu gen=0/pid mới, chưa có dòng xác nhận trực tiếp.
