# S4 — ICON HOME + ICONSTATE — phiên ytz5hl1 (bước 1 + 6)

Chỉ-đọc trên log. Nguồn: `OmniCar.log` (20:36:45→20:52:18)
và `OmniCar.log.old`, cùng thư mục phiên.

## 0. Ranh giới thế hệ (điều kiện tiên quyết)

- `.old` gồm 2 thế hệ: dòng 1–2477 = phiên cũ 17:40–17:49
  (SpringBoard 36056/36137/36167/36240, CarPlay 36057/36136/36168);
  dòng 2478→cuối = thế hệ MỚI, bắt đầu 20:18:10.158
  `[SpringBoard:36658] loaded into SpringBoard`, CarPlay:36683
  từ 20:18:43.414. Mọi kết luận dưới đây CHỈ trên thế hệ mới:
  `.old` dòng ≥2478 + toàn bộ `OmniCar.log`.
- Thế hệ mới có 2 lần CarPlay khởi động: PID 36683
  (20:18:43→20:39:44) và PID 36712 (20:39:56→20:52:18,
  SpringBoard 36711). Build cả hai: `1.0.3 (fbebb21)`.
- Kiểm chéo ranh giới: tổng `[home-launch]` trong `.old` = 91,
  trong đoạn mới của `.old` = 91, đoạn cũ = 0 → không lẫn thế hệ
  ở hai họ dòng trọng tâm. `[iconstate]`: `.old` 95 = đoạn mới 95.
- Đếm bằng grep trên hợp nhất thế hệ mới (11.839 dòng):
  `[home-launch]` = 121, `[iconstate]` = 130, `[homelib]` = 708,
  `goHome` = 8, `close-cleanup` = 8.
- Phân bố `[home-launch]` theo phase: model 58, declaration 15,
  tap-gate 13, home-callback 11, tap 11, reconcile 11, library 2.

## 1. [home-launch] — icon com.anlai.omnicar.app đi tới đâu

### 1a. library + declaration + tap-gate: đủ, ở cả 2 lần khởi động

Mỗi lần CarPlay lên đều lặp đúng trình tự (grep status:
`added-to-real-library` = 2, `injected` = 2,
`already-ours` = 13, `tap-gate installed` = 2):

- 20:18:43.421 `[CarPlay:36683]` tap-gate `status=installed
  type=v32@0:8@16@24`
- 20:18:44.096 declaration `status=injected path=present`;
  ngay sau đó `status=already-ours`
- 20:18:44.097 library `status=added-to-real-library`
- 20:39:56.365 `[CarPlay:36712]` tap-gate `installed` (lần 2)
- 20:39:56.871 declaration `injected path=present` +
  `already-ours`; library `added-to-real-library` (lần 2)

Các `already-ours` còn lại (11) rải ở reconcile
`home-appear`/`prefs-changed`: 20:18:45.822, 20:27:39.614,
20:27:46.935, 20:34:57.034, 20:36:06.318/.762, 20:39:33.966,
20:39:35.139, 20:39:43.158, 20:39:44.854, 20:40:09.337 —
declaration không bị mất, không inject trùng lần hai.

**LOG-CONFIRMED:** library + declaration + tap-gate đều đạt,
đúng identity `com.anlai.omnicar.app`, ở cả 2 process.

### 1b. model: probe MÙ toàn phiên — không đếm được "đúng một"

58/58 dòng `phase=model` đều giống hệt nhau về trạng thái:
`state=BLIND blind=no-icon-models lists=3 icons=0 ownModel=0`
(grep: state=BLIND 58/58; icons=0 58/58; ownModel=0 58/58;
toàn phiên: `ABSENT` = 0 dòng, `PRESENT` = 0 dòng, `BLIND` = 188).

Tức cổng hợp lệ `lists>0 && modelIcons>0` KHÔNG bao giờ thỏa
(lists=3 nhưng modelIcons/icons luôn 0) → probe không đọc được
icon model nào của BẤT KỲ app nào, nên:

- Câu hỏi "trong model có đúng một icon com.anlai.omnicar.app
  không" = **NO-DATA**. Không phải "có 0 icon": `ownModel=0`
  ở đây là hệ quả của mù (no-icon-models), không phải phép đếm.
- Tầng cell (ngoài model) có tín hiệu riêng: `ownCells=1`
  ở 27/58 mẫu, `ownCells=0` ở 31/58, `attached` đi cùng
  ownCells trong mọi mẫu trước/sau close (xem §2).

### 1c. home-callback + tap: CÓ chạm thật, 11 lần

Không phải "chưa chạm". 11 bộ ba khớp nhau tuyệt đối
(grep: home-callback 11, `consumed-own-icon` 11,
`routed-existing-panel` 11), tất cả ở CarPlay:36683,
mẫu đầy đủ lần đầu:

- 20:18:56.138 `phase=home-callback observedBundle=
  com.anlai.omnicar.app viewClass=DBIconView own=1`
- 20:18:56.138 `phase=tap-gate status=consumed-own-icon`
- 20:18:56.250 `phase=tap source=iconManager:
  launchIconForIconView: status=routed-existing-panel active=0`
- 20:18:56.142 (giữa callback và tap) panel thật mở:
  `CarSplit: cua so bang bo cuc {{0, 0}, {640, 360}} muc 1065`

11 mốc tap routed: 20:18:56.250, 20:18:58.617, 20:20:06.815,
20:20:22.325, 20:21:15.782, 20:23:15.897, 20:23:20.566,
20:24:30.219, 20:26:58.836, 20:32:25.185, 20:32:27.065.
Đây là chạm của người dùng trên icon (mỗi tap đều đi trước bởi
touch probe `seq` tương ứng, vd 20:18:56.086 pt={330.7,226.3}).

Đúng hợp đồng đã mô tả: không `openURL` nào trong phiên
(grep openURL = 0), không literal `showLayoutPanelForApp`
trong log (= 0; log chỉ ghi marker `routed-existing-panel`,
không ghi tên selector — không suy diễn thêm), không dòng
dashboard-event nào (grep SCPSendDashboardEvent = 0).
Sau lần khởi động 36712 (20:39:56) KHÔNG có tap icon nào nữa
(chỉ có after-home 20:40:09) → nửa cuối phiên icon không
được test chạm lại.

**LOG-CONFIRMED** cho bước 1 ở tầng library/declaration/
tap-gate/callback/tap; **NO-DATA** ở tầng model (probe mù).

## 2. [iconstate] + các lần thoát (bước 6, A/B mờ/hiện)

### 2a. Bản chất dữ liệu iconstate phiên này

130 dòng = 26 sự kiện × 5 bundle được host
(Facebook, com.google.Maps, com.google.ios.youtube,
com.nuvio.app, com.ss.iphone.ugc.Ame — mỗi bundle 26 dòng).
**Icon OmniCar KHÔNG nằm trong tập iconstate** (grep
`iconstate.*omnicar` = 0); trạng thái của nó chỉ có ở
`phase=model` của [home-launch] (§1b). Cả 130/130 dòng đều
`state=BLIND reason=empty-model lists=3 modelIcons=0` —
trước close và sau close GIỐNG HỆT, không một dòng ABSENT
hay PRESENT nào trong toàn phiên.

Phân bố sự kiện: after-home src=home 10 sự kiện (50 dòng),
before/after-close src=home-system 7 cặp (70 dòng),
before/after-close src=solo 1 cặp (10 dòng). Cộng các dòng
`tat split`: src xuất hiện home-system 7, solo 1, home 0 —
đường `src=home` không bao giờ là đường thoát split.

### 2b. Bảng 8 lần thoát (toàn bộ close của phiên)

Trạng thái controls lấy từ chính dòng đồng hành cùng timestamp
`[autohide] close-cleanup faded=` (bằng chứng trực tiếp tại mốc
close), đối chiếu mốc fade/reveal gần nhất trước đó:

| # | Timestamp | src= | goHome | faded= | Mốc fade/reveal gần nhất | Controls | model before→after (ownCells/attached) |
|---|---|---|---|---|---|---|---|
| 1 | 20:18:53.357 | home-system | 0 (NO) | 0 | session start 20:18:50.650, chưa fade | HIỆN | 1/1 → 1/1 |
| 2 | 20:26:49.741 | home-system | 0 (NO) | 1 | fade 20:26:40.382, không reveal sau | MỜ | 1/1 → 1/1 |
| 3 | 20:31:14.391 | home-system | 0 (NO) | 1 | fade last=home 20:31:05.922 | MỜ | 1/1 → 1/1 |
| 4 | 20:32:19.111 | home-system | 0 (NO) | 0 | reveal 20:32:18.177 | HIỆN | 0/0 → 0/0 |
| 5 | 20:32:30.195 | home-system | 0 (NO) | 0 | session start 20:32:27.848, chưa fade | HIỆN | 1/1 → 1/1 |
| 6 | 20:33:36.873 | home-system | 0 (NO) | 0 | reveal 20:33:36.089 | HIỆN | 1/1 → 1/1 |
| 7 | 20:33:49.843 | home-system | 0 (NO) | 1 | fade 20:33:43.176 | MỜ | 0/0 → 0/0 |
| 8 | 20:38:20.163 | solo | 1 (YES) | 0 | reveal 20:38:10.138 | HIỆN | 1/1 → 0/0 |

Mẫu dòng gốc (lần 2): `20:26:49.741 CarSplit: tat split
(goHome=0) src=home-system` + `20:26:49.740 [autohide]
close-cleanup faded=1`. Lần 8 là goHome=YES duy nhất:
`20:38:20.163 tat split (goHome=1) src=solo`.

### 2c. Đọc A/B — tách bạch bằng chứng / không kết luận quá

- Thoát lúc MỜ (faded=1): 3 ca (#2, #3, #7) → goHome=NO 3/3.
  Khớp chiều hướng ytz4 (mờ ⇒ NO 5/5), cỡ mẫu nhỏ hơn.
- Thoát lúc HIỆN (faded=0): 5 ca → NO 4/4 nếu là src=home-system
  (#1, #4, #5, #6), YES 1/1 nếu là src=solo (#8).
  ⇒ Trong phiên này goHome phân biệt theo SRC trước khi phân
  biệt theo mờ/hiện: đường home-system cho NO ở CẢ hai trạng
  thái controls (7/7), đường solo cho YES (1/1). Không đủ cơ sở
  gán NO của home-system cho riêng yếu tố "đang mờ" như cách
  đọc thuần A/B mờ/hiện của ytz4.
- "Thoát lúc mờ còn mất icon ở tầng model không": **NO-DATA**.
  Trước và sau mọi close, model đều BLIND (icons=0,
  modelIcons=0, ownModel=0) — trạng thái ABSENT-MODEL không
  xuất hiện vì probe không hề vào được trạng thái đọc được;
  mất-icon-tầng-model không khẳng định được, cũng không phủ
  định được, từ log này.
- Tầng cell thì đọc được một phần: ở 5/7 close home-system,
  mẫu after-close (trong vòng 4–17 ms) vẫn ownCells=1/
  attached=1 như before; 2 ca (#4, #7) vốn đã 0/0 từ before.
  Mẫu `after-home-event` ngay sau đó (23–54 ms) tụt 0/0 ở
  #1, #2, #3, #5, #6 nhưng lại LÊN 1/1 ở #4 và #7 — dao động
  hai chiều, không phải mẫu "close xong mất hẳn". Riêng solo
  #8: after-close tụt 1/1 → 0/0 ngay (đúng tính chất goHome).
- Sau các close, icon vẫn hoạt động ở tầng tap: tap routed
  20:26:58 (sau close #2), 20:32:25 + 20:32:27 (sau #4, #5)
  đều routed-existing-panel bình thường.

**Nhãn bước 6:** A/B mờ→NO: LOG-CONFIRMED (3/3, kèm cảnh báo
src là biến nhiễu trội). Mất icon tầng model khi mờ:
NO-DATA (probe mù cả phiên). Icon còn dùng được sau close
ở tầng cell/tap: LOG-CONFIRMED.

## 3. Nút dock (đường cũ mở panel) — còn dùng, không lỗi

- Nút được dựng lặp lại mỗi lần vào split, vd 20:18:45.472–.475
  `nut Split Screen dat tren nut Home, 30pt` + `[GPT-F] Dock
  gate created gate=pass`; 65 dòng chứa "dock" trong phiên.
- Được BẤM thật 8 lần (grep `bam nut Split Screen tren dock`
  = 8): 20:20:17.786 (man chinh), 20:26:55.641 (man chinh),
  20:27:49.022 (com.google.Maps), 20:31:01.919 (dang chia ->
  doi bo cuc), 20:31:16.135, 20:32:21.960, 20:32:32.329,
  20:33:38.168 (man chinh).
- Panel mở ngay sau các lần bấm đó: `cua so bang bo cuc`
  = 3 dòng tường minh (20:18:56.142 — lần này do tap icon,
  20:27:49.025 — sát nút dock 20:27:49.022, 20:38:12.868);
  các lần bấm còn lại đi vào luồng đổi bố cục/session-start
  bình thường (autohide session start 20:26:59.971,
  20:31:17.575, 20:32:27.848, 20:32:33.100, 20:33:39.174).
- Không có dòng lỗi nào gắn dock/panel/home trong phiên
  (grep error/fail/crash lọc theo dock|panel|home = 0;
  crash/SIGBUS/SIGSEGV toàn phiên = 0).

**LOG-CONFIRMED:** nút dock còn được dùng thật (8 lần bấm),
đường mở panel chạy, không lỗi log nào.

## 4. [homelib] thế hệ mới — inject/remove

708 dòng. Cấu trúc: `loadFromProxy` 632, `apply-published` 10,
`new-library` 2; decision: inject 8, lib-add 8,
lib-skip-present 2, skip-real-declaration 2,
skip-not-chosen 44. injected=1: 588 dòng; injected=0: 44.

- Hai lần dựng library (20:18:44 ở 36683, 20:39:56 ở 36712),
  mỗi lần: `new-library libclass=FBSApplicationLibrary
  count=26 chosen=5`; lib-add + inject cho đúng 4 bundle:
  com.facebook.Facebook, com.ss.iphone.ugc.Ame,
  com.google.ios.youtube, com.nuvio.app; com.google.Maps =
  `lib-skip-present` (đã có sẵn, không add trùng).
- YouTube (com.google.ios.youtube): 586 dòng homelib, gồm
  lib-add + inject ở cả 2 lần dựng và 582 dòng loadFromProxy
  injected=1 xuyên phiên (gồm cả đợt dồn 20:39:42) — trạng
  thái injected giữ nguyên, không tụt về 0 sau lần dựng đầu.
- REMOVE: **không có ca remove nào**. Grep `remove` trên
  [homelib] = 0; grep `remove` toàn phiên = 1 dòng duy nhất
  thuộc họ khác: `20:38:20.157 [scenevis] pane-remove
  bundle=com.google.Maps slot=0` (gỡ pane khi solo close #8,
  không phải gỡ icon khỏi library).
- Riêng OmniCar trong homelib: `decision=skip-not-chosen
  bundle=com.anlai.omnicar.app` + `OMNI decision=skip-not-
  chosen` + `loadFromProxy injected=0` ở cả 2 lần dựng — icon
  Home đi đường [home-launch] riêng (§1), không qua homelib;
  `apply-published count=0 omni=0` cả 10 lần (không publish
  thêm app nào giữa phiên, omni không bị publish/remove).

**LOG-CONFIRMED:** không remove bất thường; YouTube inject
ổn định cả phiên.

## 5. Đối chiếu hai verdict của Nguyen + tầng log vẫn mù

| Verdict tại xe | Nhãn | Căn cứ tóm tắt |
|---|---|---|
| Bước 1 icon Home TẠM ỔN | LOG-CONFIRMED (trừ tầng model: NO-DATA) | library 2/2 lần dựng, declaration injected 2 + already-ours 13, tap-gate installed 2, 11 tap thật đều callback own=1 → consumed → routed-existing-panel, panel mở thật 20:18:56.142; không openURL/event lạ |
| Bước 6 A/B icon TẠM ỔN | LOG-CONFIRMED một phần / NO-DATA phần model | mờ ⇒ goHome=NO 3/3 (khớp ytz4); nhưng home-system cũng NO khi HIỆN 4/4 → src là biến trội; sau close icon vẫn tap được; mất-icon-tầng-model: không đo được |

Không có điểm nào CONTRADICTS hai verdict trên dữ kiện log.

Tầng log VẪN MÙ (không kết luận):
1. **Tầng model icon**: mù tuyệt đối cả phiên — 188 dòng BLIND,
   0 ABSENT, 0 PRESENT, modelIcons luôn 0 dù lists=3. Mọi câu
   hỏi dạng "icon còn/mất trong model, có đúng một icon" đều
   NO-DATA cho tới khi probe đọc được model thật.
2. **Tầng cell/pixel trên màn xe**: log chỉ có ownCells/
   attached (tầng view cell) và lời kể tại xe của Nguyen;
   icon có HIỆN hình đúng, đúng vị trí, không nhấp nháy hay
   không — log không chứng minh được, verdict TẠM ỔN tại xe
   là nguồn duy nhất cho tầng này.
3. **Tên selector** của đường tap: log ghi marker
   `routed-existing-panel`, không ghi `showLayoutPanelForApp:`
   hay `ahNoteActivity:AHSourceHome` (grep cả hai = 0/0;
   `ahNoteActivity` dạng text chỉ xuất hiện 46 lần trong dòng
   autohide `act-accepted ... -> ahNoteActivity` của app được
   host, không gắn với tap icon Home) — khớp/không khớp ở mức
   selector là NO-DATA từ log.
4. **Nửa cuối phiên** (sau restart 36712, 20:39:56→20:52:18):
   icon chỉ được dựng lại (library/declaration/tap-gate đủ)
   nhưng không có tap, không có close nào → hành vi chạm/thoát
   của icon ở process mới là NO-DATA.
