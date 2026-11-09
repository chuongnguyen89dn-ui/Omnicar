# S1 — Khung phiên + hồi quy chung — phiên hl2 (chỉ-đọc)

Nguồn: `OmniCar.log.old` (2.097.700 B, 9.657 dòng) + `OmniCar.log`
(977.961 B, 6.672 dòng). Mọi số đếm bằng grep trên file gốc.
Deb hl2 SHA `9250ea01` (theo đề bài; log không tự ghi SHA deb).

## Khung thế hệ hl2 — cách tách

Nhãn riêng hl2 xuất hiện lần đầu trong `.old`:
`[gate3] trial` L1110 (22:03:25.099), `[pinch2]` L1624
(22:03:44.731), `[picker-measure]` L2262 (22:04:38.033),
`mode=drawn` L1466 (22:03:35.980). Chuỗi build KHÔNG phân biệt
được thế hệ: cả hai thế hệ đều ghi `build 1.0.3 (fbebb21)
[fixround7]` — mốc tách duy nhất tin cậy là PID + timestamp.

- Tiền-hl2 (binary cũ, CHỈ ở `.old` L1–1080): 21:12:16.085 →
  21:14:53.880, CarPlay 36768→36808, SpringBoard 36769→36809.
  Bốn dòng cuối của PID cũ ở 22:02:53.443–.445 (CarPlay:36808,
  `[homelib]`/`[home-launch]`) sau khoảng im lặng ~48 phút.
- Thế hệ hl2 = `.old` L1081 → hết `.old` + toàn bộ `OmniCar.log`
  = 8.577 + 6.672 = 15.249 dòng. Mọi mục dưới đây CHỈ tính
  vùng này, trừ chỗ ghi rõ.
- Nhãn `trayOverlay=`: grep cả 2 file = 0/0. Nhãn `snap{`: 0/0.
  Xem mục 3 — đây là phát hiện, không phải lỗi đếm.

## 1. Khung phiên — PID, mốc thời gian, respring, crash

Thế hệ hl2 gồm HAI đoạn PID (đứt giữa phiên):

| Đoạn | CarPlay | SpringBoard | Bắt đầu | Kết thúc |
|---|---|---|---|---|
| A | 37310 (6.157 dòng) | 37287 (230) | SB 22:02:59.603 / CP 22:03:25.087 | CP 22:15:58.812 / SB 22:15:48.070 |
| B | 37334 (6.980) | 37335 (275) | CP 22:16:01.227 / SB 22:16:01.767 | 22:27:18.329 / 22:27:17.036 (cuối log) |

- Đổi PID giữa phiên: CÓ, 1 lần, đồng thời cả CarPlay lẫn
  SpringBoard lúc ~22:16:01 (khoảng lặng ~2,4 s phía CarPlay).
  Owner host đổi `447D193D…` → `71151C5E…`. Log KHÔNG ghi
  nguyên nhân (không dòng crash/respring-reason trước điểm
  đứt) — nguyên nhân: NO-DATA; hình thái khớp respring/kết
  nối lại nhưng log không tự khẳng định.
- Điểm nối 2 file: LIỀN, chồng 25 ms. `.old` kết thúc
  22:18:40.027 (CarPlay:37334, fs expand), `OmniCar.log` bắt
  đầu 22:18:40.002 (YouTube:37370, cùng sự kiện pinch) — cùng
  PID 37334/37335/37370 chạy xuyên, không đứt phiên.
- App hosted trong hl2: YouTube 37317 → 37370 (đổi lúc
  22:18:21.580, relaunch app thường), TikTok 37332 → 37363,
  GOFA 37315 → 37326 → 37362 → 37377, Waze 37329, Preferences
  37333. Đây là vòng đời app, không phải respring.
- Lỗi toàn cục: grep `exception` = 0/0 cả 2 file; `fatal` = 0
  trong hl2; `crash` = 2 hit nhưng cả 2 là dump DIAG liệt kê
  selector (22:03:34.069 / 22:16:39.345), không phải crash
  thật; `error` = 20 hit, gồm 2 dòng `weather: updated …
  (http 200, no error)` + 18 dòng DIAG. `fail` chỉ xuất hiện
  dạng counter `setfail=0 postfail=0` / `failopen=`.
  Verdict: LOG-CONFIRMED — không crash/exception thật nào
  trong thế hệ hl2.

## 2. AutoHide — vòng đời fade/reveal, thoát split khi mờ

Đếm hl2: fade thực thi `fade last=` = 27 (idle=4.00 đủ loại
last=app/container/hosthandle/hostknob/dragend); `fade
deferred` = 43 (kb 24, kbunknown 16, surface-open 3);
`reveal-applied reason=activity views=4` = 24; phía host:
`host fade applied` = 23, `host fade restored` = 20,
`host knob fade applied` = 23, `host knob fade restored` = 21.
`session start` = 9; `close-cleanup` = 6; `teardown faded=` = 2.

Thoát split: `close-cleanup faded=0` ×4 (22:03:41.362,
22:10:06.684, 22:11:53.314, 22:12:06.949) và `faded=1` ×2:

- 22:09:49.036 (`.old` L4056) `close-cleanup faded=1` →
  `tat split src=home-system`. MỞ LẠI: `session start`
  22:09:53.623 (sau 4,59 s); `host knob fade restored`
  22:09:53.671 — 48 ms sau session start, TRƯỚC `request`
  22:09:53.718 và `revealPane` 22:09:53.815. Lần mờ đầu tiên
  của phiên mới mãi tới 22:09:57.625 (fade idle 4 s bình
  thường). → Mở lại KHÔNG bắt đầu ở trạng thái mờ.
- 22:27:17.004 (`OmniCar.log` L6643) `close-cleanup faded=1`
  → `tat split src=dismiss` — lần đóng CUỐI phiên, sau đó
  không còn lần mở nào trong log: NO-DATA cho lần mở kế tiếp.

Verdict: LOG-CONFIRMED — bệnh rò faded-state (kiểu ytz4)
KHÔNG tái diễn ở lần thoát-khi-mờ có mở lại được quan sát;
controls được restored trong 48 ms từ session start.

## 3. FS guard — expand confirmed/refused, nhãn snap

- `fs expand confirmed` = 4, tất cả `provenance=pinch`:
  txn=1 22:05:10.455 (37310); txn=3 22:12:51.921 (37310);
  txn=1 22:18:40.027 (37334, dòng cuối `.old`); txn=3
  22:25:15.986 (37334, `OmniCar.log` L4853).
- `fs expand refused` = 0 (grep cả 2 file: 0/0). Không có
  dòng refused nào nên KHÔNG có trường thủ phạm nào để đếm
  (picker/ratio/dragGhost/toast/trayOverlay/phase/inactive
  đều 0 lần xuất hiện trong ngữ cảnh refused).
- Nhãn snap MỚI: `trayOverlay=` = 0 và `snap{` = 0 trên TOÀN
  BỘ hai file (kể cả tiền-hl2). Binary hl2 kỳ này không hề
  phát snap{} kèm expand — không phải refused bị giấu, mà
  là đường log snap vắng hoàn toàn. Verdict: NO-DATA cho
  trayOverlay; mọi kết luận về guard theo trường là không
  thể rút từ log này.
- Restore phía FS: `fs restore confirmed txn=4
  provenance=diag` ×1 (22:15:48.059); `fs session-end
  abbreviated restore provenance=teardown` ×1 (22:07:21.406);
  `[fs-diag] diag listener installed want=1` ở đoạn A nhưng
  `want=0` ở đoạn B (22:16:01.255).
- Tầng pinch (không phải FS guard): `[pinch2] owner accept`
  = 4 (khớp 4 expand), `owner expand applied=1` = 4,
  `owner reject reason=badstate` = 13 (22:05:11.247 →
  22:13:05.707, toàn đoạn A) — reject ở tầng owner-pinch,
  không sinh dòng fs refused.

## 4. Native feed + act

`[probe-feed]` hl2 = 879: `fired` = 338 — TẤT CẢ fired đều
vào pane NATIVE: slot1 GOFA 208, slot0 Maps 80, slot0 Waze
30, slot1 mobilecal 14, slot1 Maps 6 (mẫu: 22:03:49.277
`fired pane=slot0(com.google.Maps)`). Phần còn lại bị drop:
drop-hosted 374, drop-inactive 70, drop-popup(picker) 34,
drop-popup(traywindow) 27, drop-unconverted 23,
drop-systemregion 8, drop-notassigned 5.

Kênh act (autohide activity): `act-posted` = 261 (YouTube
259, TikTok 2); `act-accepted` = 256 (YouTube 254, TikTok 2).
Lệch = 5, khớp ĐÚNG 5 dòng `act drop reason=session-inactive`
(22:09:41.207 đoạn A; 22:25:12.336 / .863, 22:25:14.458,
22:25:15.096 đoạn B — đều quanh lúc phiên inactive/đóng).
Cộng 2 `act-drop-nosession` phía app TikTok (22:15:21.265,
22:15:22.046) — rớt TRƯỚC khi posted nên không nằm trong
lệch trên. Lưu ý: act là kênh của app HOSTED; log không có
dòng ack riêng gắn từng feed fired của app native — pairing
feed↔ack trực tiếp cho native: NO-DATA.
Verdict: LOG-CONFIRMED cho số feed fired native = 338 và
lệch act 261/256 = 5 có giải thích đủ bằng drop lines.

## 5. YTZ — grant/ack/revoke, mask, layout sau revoke

- Grant: `[ytz] lease cap` = 5 (gen=0 22:03:35.982; gen=1
  22:03:44.860; gen=5 22:09:53.815; gen=8 22:12:31.003 —
  đoạn A; gen=0 22:18:17.751 — đoạn B). `lease gia han` = 5.
- Nhận/ack: `[ytz] lease nhan` = 47 (owner 447D193D 11 lần,
  owner 71151C5E 36 lần) và `[ytz] ack phase=applied` = 47 —
  khớp 1:1. Cộng 1 `ack phase=revoked windows=0` lúc
  22:14:56.386. `relay ap` = 47.
- Mask rò: KHÔNG. Toàn bộ 48 ack + 47 relay đều
  `mismatch=0`; applied luôn `windows=1`, revoked
  `windows=0`. Verdict: LOG-CONFIRMED không rò mask.
- Revoke: `lease thu hoi ly do=teardown` = 5 (22:03:41.374,
  22:09:49.046, 22:10:06.694, 22:14:56.359, 22:27:17.035),
  mỗi lần kèm 1 `[ytz-revoke-snap]` (5). Phía app: `ao hoa
  BAT` = 5, `ao hoa TAT` = 5 (close 4, revoke 1) — cân.
- Layout cưỡng bức sau revoke: KHÔNG thấy. `[ytz-nextlayout]`
  chỉ có 3 dòng (22:03:45.862, 22:09:54.817, 22:12:31.003)
  và cả 3 gắn với thời điểm GRANT gen mới (gen=2/6/8), không
  gắn revoke; sau mỗi revoke chỉ có snap + ack revoked/TAT.
  Verdict: LOG-CONFIRMED — revoke không kéo nextlayout.
- Mode phím: mọi `[ytz5-k5] payload` trong hl2 đều
  `drawnKeyboard=1 mode=drawn` (YouTube 10, TikTok 4 payload).

## 6. Dock vắng mặt + Home icon [home-launch]

Dock button cũ của tweak: KHÔNG dòng nào trong hl2 cho thấy
nó tồn tại hay bị bấm. Mọi hit `dock` có timestamp chỉ là:
(a) `gan giu icon vao SBDockIconListView` ×4 (22:03:26.729,
22:09:36.940, 22:16:31.920, 22:25:10.391) — neo icon Home
vào dock HỆ THỐNG; (b) dòng hình học `dock={{0,124.67},
{45,111}}` ×9 — dải dock gốc dùng tính vùng app; (c) dump
DIAG/view-hierarchy (`SBDockIconListView … count: 0`).
`thanh nut` (thanh grip, khác dock) vẫn sống: 16 dòng.
Verdict: LOG-CONFIRMED — dock-retirement sạch ở mức log;
thứ còn lại mang tên dock là cấu trúc hệ thống.

Home icon `[home-launch]` hl2 = 72 dòng:
- `phase=declaration status=injected` = 2 (22:03:25.482,
  22:16:01.747 — mỗi lần CarPlay khởi động 1 lần);
  `already-ours` = 7; `phase=library
  status=added-to-real-library` = 2.
- `phase=tap-gate status=installed` = 2 (lúc cài hook);
  `status=consumed-own-icon` = 6.
- `phase=tap status=routed-existing-panel` = 6 — icon được
  chạm và routed 6 lần, TẤT CẢ ở `.old`: 22:03:43.306,
  22:09:51.665, 22:10:09.859, 22:11:55.483, 22:12:22.557
  (đoạn A) + 22:16:35.338 (đoạn B). Trong `OmniCar.log`
  (22:18:40 → 22:27:21): routed = 0.
- `phase=model` = 36, tất cả `state=BLIND
  blind=no-icon-models` — model mù suốt phiên nhưng tap vẫn
  routed qua đường consumed-own-icon ở trên.

## 7. Scenevis + weather/knob

Scenevis hl2 = 108 dòng. Riêng `verify` = 43 (`.old` 29 +
`OmniCar.log` 14; GOFA 24, Maps 11, mobilecal 4, Waze 4):
43/43 khỏe — `attached=1 inHost=1 hidden=0 alpha=1.00
window=1` (mẫu 22:18:40.965 GOFA). Toàn bộ 108 dòng:
`hidden=1` = 0, `alpha=0` = 0; 79 dòng `attached=1`; 29
dòng còn lại là pha vòng đời (host-attach 9, host-state-
ready 7, going-home 11, detach-bg 16, invalidate 4,
attach 16, pane-remove 1, detach 1 — tổng các loại có
chồng lấp với verify 43) trong đó duy nhất 1 dòng sentinel
ô trống `bundle=? hidden=-1 alpha=-1.00 window=0` lúc
native-close 22:12:06.949. Verdict: LOG-CONFIRMED verify
khỏe 100%.

Weather: KHÁC các phiên trước — CÓ dữ kiện, nhưng chỉ ở
khởi động SpringBoard: 2 đợt `ans#1` (22:03:14.781 và
22:16:17.215), cả hai ghi rõ `source=warming-cache
(internal startup call, NOT a CarPlay request)`, kết quả
`updated in 1.7s / 1.0s (http 200, no error)` +
`ans#1 ready-posted`. `req#` = 0 dòng; không có weather
request nào từ CarPlay trong phiên. Payload thời tiết chi
tiết: NO-DATA (log chỉ ghi trạng thái fetch, không ghi
nội dung). Knob: chỉ có dữ kiện dạng autohide (applied 23 /
restored 21, mục 2); ngoài đó NO-DATA.
