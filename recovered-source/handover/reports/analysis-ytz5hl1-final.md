# PHÂN TÍCH PHIÊN YTZ5HL1 — ĐỐI HOÀ 5 STRAND (09/11/2026)

Nguồn: `OmniCar.log` (965.241 B, SHA-256 `e7e62a0b…`, 5.112 dòng) +
`OmniCar.log.old` (2.102.266 B, 9.204 dòng), Nguyen up ở commit repo
`5e745bc`. Bản chạy: DEB tổng hợp ytz5hl1, SHA-256 `e28883b9…` (HEAD tích
hợp `8a2c7aa`). Biên bản strand: analysis-s1-frame / s2-picker /
s3-keyboard / s4-icon / s5-wake cùng thư mục. Mọi đếm bằng grep trên file
gốc; mọi kết luận ghim dòng có timestamp.

## 0. Khung phiên (S1)

| Đoạn | Vị trí | PID | Khoảng |
|---|---|---|---|
| A — ytz4 cũ | .old 1–2477 | SB 36056…, CP 36057… | 17:40:49–17:49:22 |
| B — ytz5hl1 pha 1 | .old 2478–9204 + log 1–1016 | SB 36658, CP 36683 | 20:18:10–20:39:50 |
| C — ytz5hl1 pha 2 | log 1017–5112 | SB 36711, CP 36712 | 20:39:56–20:52:18 |

- Mốc thế hệ mới: `20:18:10.158 [SpringBoard:36658] loaded into
  SpringBoard` (.old:2478); CarPlay:36683 load 20:18:43. Việc cài đặt nằm
  trong khoảng trống log 2:28:48 giữa hai thế hệ — NO-DATA trong log.
- Dấu riêng của ytz5hl1 (đoạn A đều = 0): `[home-launch]` 121,
  `[kbstate]` 1.430 (đầu tiên 20:24:44.418), `[ytz5-k5]` 7. Chuỗi build
  `1.0.3 (fbebb21) [fixround7]` GIỐNG HỆT cả hai thế hệ — chỉ phân biệt
  được bằng PID + timestamp + tag riêng. `[pinch1]` đã có từ đoạn A
  (17:42:54) — KHÔNG phải dấu riêng của vòng này.
- Hai file nối LIÊN TỤC tại 20:36:45 (seq kb-sync 1976→1977, kbstate
  626→627, cùng gen/session) — không hở.
- Đổi PID trong phiên: đúng 1 lần, đồng loạt SB+CP lúc 20:39:51–57 kèm
  "loaded into" mới (dạng respring); KHÔNG crash/exception/SIG/disconnect
  quanh đó — nguyên nhân NO-DATA. Lỗi toàn cục cả phiên: 0 (mọi hit
  crash/error/fail đều là dump DIAG, `no error`, hoặc bộ đếm = 0).
- Phiên hiệu dụng 34m08s; verdict 20:34 của Nguyen thuộc pha 1, log còn
  chạy 18m18s sau đó. Trong phiên không khoảng trống >60s.

## 1. Bảng verdict: báo cáo tại xe → verdict log

| Bước | Nguyen (20:34) | Verdict log | Căn cứ chính |
|---|---|---|---|
| 1 Icon Home | TẠM ỔN | **LOG-CONFIRMED** (tầng model: NO-DATA) | library/declaration/tap-gate đủ ở 2 lần dựng; **11 lần chạm THẬT** routed-existing-panel (20:18:56→20:32:27), openURL = 0 |
| 2 Vòng đời AutoHide | TẠM ỔN | **LOG-CONFIRMED** | 3/3 lần thoát lúc mờ → mở lại hiện đủ (restored ≤44 ms), fade lại đúng idle 4.00 (20×4.00, 2×4.01); không lần mở lại nào bắt đầu ở trạng thái mờ |
| 3 Picker nhìn xuyên | THẤT BẠI | **THẤT BẠI CONFIRMED — cơ chế = nhánh (b)** | hasContent=1 ở cả 2 lần mở thật; =0 xuất hiện 0 lần — phép bắt occupancy ĐÚNG, placeholder vô tội; lớp phủ là phần tử khác (mục 2) |
| 4 Phím gốc hosted | THẤT BẠI (không hiện) | **THẤT BẠI CONFIRMED — phân định nhánh (i)** | cổng native xác nhận trên thiết bị; app báo ACTIVE đầy đủ; chuỗi kbstate KHÉP; phím hệ thống không dựng trên màn xe cho scene hosted (mục 3) |
| 5 Đánh thức | hiện logo ĐƯỢC | **LOG-CONFIRMED** (reveal); nuốt vẫn DRY_RUN | Gate 3: lần đầu có 4 ca would=1 SẠCH ở điều kiện đầy đủ (mục 4) |
| 6 A/B icon | TẠM ỔN | **LOG-CONFIRMED một phần / model NO-DATA** | thoát lúc mờ ⇒ goHome=NO 3/3 (khớp ytz4) nhưng lúc hiện cũng NO 4/4 — `src=` là biến trội phiên này; cell giữ ở 5/7 ca after-close; tầng model mù toàn phiên |

Tầng mù chung (không kết luận quá dữ kiện): model icon (mục 5), cell/pixel
trên màn xe, tầng trình bày bàn phím (log câm tuyệt đối: `UIKeyboard` = 0
ở mọi process).

## 2. Bước 3 — picker: hỏng ở nhánh (b), phép bắt occupancy vô tội (S2)

Toàn phiên chỉ có **đúng 2 lần mở picker thật**, cả hai qua nút "Đổi app"
trên ô 0 (YouTube hosted; ô 1 là Maps native):

- Lần 1: `20:25:25.561 [picker] hasContent=1` → popup 19 app ô 0
  20:25:25.953; đóng bằng chạm ngoài 20:25:34.657, không chọn.
- Lần 2: `20:25:36.896 [picker] hasContent=1` → popup 20:25:37.094; đóng
  `closePopups` 20:25:43.708, không chọn.

Ô 0 lúc mở có YouTube hosted thật (`20:24:33.120 [scenevis] host-attach
bundle=com.google.ios.youtube slot=0 inHost=1 hidden=0 alpha=1.00`).
`hasContent=0` xuất hiện **0 lần** toàn phiên → nhánh (a) của §29.10 bị
**LOG-CONTRADICTS**: phép bắt trả đúng. Dòng `[picker]` và phép gán
`backgroundColor ? clearColor` nằm cùng một hunk của P5 → placeholder
`pane.picker` được loại khỏi diện nghi phạm ở tầng log.

Nghi phạm nhánh (b), xếp hạng:
- **(b1) `pane.cover`** — phủ toàn pane trên `pane.host`, đúng hằng màu
  đặc rgb(0.9333, 0.9412, 0.9843) như nền cũ của placeholder (khớp màu
  trắng Nguyen thấy); nhưng `addCoverToPane:`/`removeCoverFromPane:`
  KHÔNG phát dòng log nào (grep `cover` ngoài DIAG = 0/0) → sự hiện diện
  tại hai mốc mở là NO-DATA.
- **(b2) lớp shield của popup** — LOG-CONFIRMED dựng đúng tại 2 mốc mở
  (`20:25:25.951` / `20:25:37.092 [do] shield host
  SCPCPass_UIRootSceneWindow` + `man xe ban (an lop phu)`; chuỗi này chỉ
  xuất hiện tại 2 mốc đó trong thế hệ mới); màu/alpha của nó không được
  ghi → NO-DATA về tính trong suốt.

Loader bị loại (tự gỡ trước điểm bắt, 0 sự kiện); sheet nằm ở cửa sổ
riêng, không che pane. Trong cửa sổ mở có 0 dòng `[scenevis]` và log
không ghi backgroundColor/alpha của bất kỳ view phủ nào → muốn kết án
đích danh (b1)/(b2) cần đúng 1 dòng đo bổ sung: alpha + superview của
`pane.cover` và `pane.picker` ngay sau điểm bắt hasContent trong
`showPickerForSlot:`.

## 3. Bước 4 — bàn phím: phân định nhánh (i), kết án tầng xe, bridge vô tội (S3)

**Cổng = native, LOG-CONFIRMED phía host.** Token dự đoán `drawnKeyboard`
= 0 ở cả hai file; biến thể log thật là `[ytz5-k5] cong ban phim doi:
native (prefschanged)` — 7 lần (20:27:39.611; 20:36:06.315/.763;
20:39:33.964→20:39:44.852), toàn SpringBoard, không một lần drawn. Phía
app nhận payload hướng trùng mili-giây với sự kiện cổng (20:36:06.315↔
.319, `huong o 1 ... doi=0`).

**Hai cửa sổ ACTIVE duy nhất của phiên** (cả hai ở pha 1): tập A seq
63–110 (20:25:46.499→20:26:31.130), tập B gen=20 seq 565–593
(20:35:46.138→20:36:14.074) — tổng **75 báo cáo state=1** (session
2089400554, hash d3b4e0d = YouTube), accept 100%, 0 reject trong cửa sổ.
**Chuỗi kbstate KHÉP trọn vòng** theo tiêu chuẩn vòng: accept 1.425
(state=1: 75, state=0: 1.350) / reject 5 (noassignment ×3 lúc đóng ô
20:31:15–17, badgen ×2 lúc đổi assignment 20:38:16–17; badhash/
badsession/staleseq = 0); seq hai session chạy liền 1→720 và 1→710;
accept→emit trễ 0–1 ms; `[kb-sync] emit active=1
source=app-input-session` = 148; có ca stale→UNKNOWN thật sau badgen
(known tụt 0, probe ghi `failopen=unknown` — freshness neo vào nguồn,
owner không tự gia hạn, đúng luật W2). **AutoHide giữ đúng:** `fade
deferred (kb)` = 11 (5 tập A + 6 tập B), `hold reason=kbunknown` = 5 cặp
đầu phiên CarPlay và nhả đúng mili-giây báo cáo hợp lệ đầu tiên tới;
fade thật trong lúc ACTIVE = **0**. Kênh host cũ chỉ còn 6 dòng `host
post active=0 source=host-keyboard-session` tại mốc đóng ô — không dòng
nào trong cửa sổ ACTIVE (nguồn panel đã tách sạch như thiết kế).

**Nhánh (ii) bị LOG-CONTRADICTS:** không lệch cổng, phía app không có
dòng suppression nào (grep `suppress` ngoài DIAG = 0), host không
post/chặn panel trong lúc nhập liệu. Giới hạn ghi rõ: "app không blank
inputView" là suy luận từ cổng native + hành vi báo cáo ACTIVE (log
không có dòng inputView theo cả hai chiều); tầng trình bày phím câm log
tuyệt đối. Kết án dựa trên chuỗi bridge khép kín + verdict màn hình
KHÔNG HIỆN của Nguyen.

**Kết luận:** mọi tầng do tweak kiểm soát đều làm đúng — cổng tới app,
app không suppress và báo phiên nhập liệu thật, owner nhận hợp lệ, fade
gate giữ controls. **Phím hệ thống không dựng trên màn xe cho scene
hosted** — đây là đáp án tầng xe của khả thi 3 tầng đã khai trước build.
Hệ quả thực tế: ở chế độ native, app hosted trên bộ máy này **không có
bàn phím dùng được**; phím tự vẽ (code giữ nguyên sau cổng) là đường duy
nhất từng hiện và gõ được — quyết định lật mặc định về drawn thuộc
Nguyen/GPT.

## 4. Bước 5 — Gate 3: bằng chứng tiến một bước lớn, một mắt xích hoá ra bị chính thiết kế chặn (S5)

34 probe wouldSwallow, tất cả thuộc thế hệ mới (phần 17:xx = 0).

- **Điều kiện nuốt đầy đủ (HIDDEN + known + kb INACTIVE từ nguồn xác
  thực): 9 ca.** would=1 SẠCH ở **4 ca** — seq=1 (20:25:02.102,
  kbAge=625), seq=8 (20:25:45.294, kbAge=623), seq=17 (20:26:36.426,
  kbAge=235), seq=20 (20:30:25.943, kbAge=9) — cả 4 failopen=`-`. Đây là
  phiên đầu tiên có ca dương tính sạch trên nguồn kb đã sửa.
- would=0 ở 5 ca còn lại: 4 ca failopen=stale (seq 18/31/32/46 — cổng
  fail-open hoạt động đúng thiết kế) và **1 ca bất thường seq=45**
  (20:37:23.977, kbAge=527, failopen=`-` mà would=0): tại mili-giây đó
  phía host đang trong nhịp reveal (fade applied 20:37:23.917–.927,
  act-posted stateage=24 lúc .943, reveal-applied .948) — giả thuyết
  chưa chứng minh: snapshot H của probe chụp ngay trước nhịp reveal vài
  chục ms. Đây là ca duy nhất phá tương quan would ↔ điều kiện; cần GPT
  soi tiếp (race state-flip giữa host và probe?).
- **Mắt xích "chạm lúc HIDDEN + kb ACTIVE": không có ca nào — và tổ hợp
  đó KHÔNG ĐỒNG TỒN TẠI trong phiên:** cả 3 cửa sổ kb ACTIVE (75 accept
  state=1; kb-sync active=1 ×148) đều có trạng thái owner = VISIBLE, vì
  chính sửa đổi ytz5 (kb ACTIVE ⇒ giữ controls hiện) làm HIDDEN không
  thể xảy ra trong lúc phím mở. Tiêu chuẩn Gate 3 như viết hiện tại đòi
  một tổ hợp mà thiết kế đã chốt của GPT tự chặn — cần GPT phán lại tiêu
  chuẩn, không phải thiếu dữ kiện đo.
- Mắt xích "chạm sau khi đóng phím trên cùng assignment": **ĐÃ CÓ** —
  cửa sổ B đóng 20:36:14.074 (gen=20), sau đó seq 42–47 cùng app/cùng
  kb session/gen; nhưng ca H trong đó chính là seq=45 bất thường ở trên.
- Bằng chứng gõ phím: vẫn NO-DATA (chỉ 2 probe chạm đơn trong các cửa
  sổ kb; phím không hiện nên không có gì để gõ — hệ quả của bước 4).

## 5. Icon — hai tầng (S4)

**Home Launcher (bước 1):** 121 dòng `[home-launch]` — library
`added-to-real-library` ×2, declaration `injected` ×2 +
`already-ours` ×13, tap-gate `installed` ×2 (đủ ở cả 2 lần dựng, trước
và sau lần đổi PID). **11 lần chạm thật** đi trọn chuỗi home-callback
own=1 → consumed-own-icon → routed-existing-panel (20:18:56→20:32:27,
đều ở pha 1; panel mở thật 20:18:56.142); openURL = 0; không event-1
mới. Sau lần đổi PID (pha 2) không có chạm icon nào nữa — nửa sau phiên
là NO-DATA cho tap, không phải tap hỏng.

**Tầng model mù toàn phiên (cả hai phía đo):** 58/58 mẫu model
`BLIND/no-icon-models, lists=3, icons=0, ownModel=0`; toàn phiên ABSENT
= 0, PRESENT = 0, BLIND = 188. `[iconstate]` 130 dòng = 26 sự kiện × 5
bundle host (không gồm OmniCar), before/after-close giống hệt nhau
(BLIND empty-model). Theo đúng chuẩn bằng chứng GPT đã sửa ở vòng
trước: reader không hợp lệ (model rỗng) thì count=0 KHÔNG phải bằng
chứng xoá icon — câu hỏi "đúng một icon trong model" và "mất icon tầng
model khi thoát lúc mờ" đều là **NO-DATA**, không có kết luận ngược.

**A/B thoát Home (8 lần):** thoát lúc mờ (close-cleanup faded=1) 3 ca →
goHome=NO 3/3 (khớp tương quan ytz4); nhưng home-system lúc HIỆN cũng
NO 4/4, ca YES duy nhất là solo lúc hiện (20:38:20, goHome=1) → trong
phiên này `src=` là biến trội hơn trạng thái mờ/hiện. Tầng cell:
after-close còn giữ ownCells/attached ở 5/7 ca home-system; icon vẫn
chạm routed được sau các lần đóng #2, #4, #5 — không có ca mất icon nào
bị log bắt được ở tầng cell. Nút dock: 8 lần bấm "Split Screen" trên
dock, panel mở, 0 lỗi → LOG-CONFIRMED còn nguyên. `[homelib]` 708
dòng: inject/lib-add cho Facebook, TikTok, YouTube, Nuvio ở cả 2 lần
dựng; YouTube injected=1 ổn định (586 dòng); **remove = 0** toàn phiên.

## 6. Hồi quy và các dữ kiện phụ (S5 + S1)

- **Native feed:** fired 31/229 (toàn bộ trên Maps native; các drop đều
  có lý do: hosted 60, inactive 110, systemregion 16, popup 10,
  unconverted 2). act-posted 47 vs act-accepted 46 — **lệch đúng 1**:
  seq=19 (posted 20:27:50.617, gen=8) không được accepted ở cả hai file;
  thêm 12 act-drop-nosession có lý do. stateage tối đa **42.546 ms**
  (20:32:18.162) — hiện tượng trạng thái wake cũ ở kênh state vẫn còn
  (kênh kbstate mới thì sạch, xem mục 3).
- **FS1:** 9 thao tác — expand confirmed 2 (txn=1, txn=3), restore
  refused 3, expand refused 2 (inactive), abbreviated restore 2.
  **Dữ kiện CONTRADICTS mô tả guard:** ở cả 5 lần refused, snap đều
  `picker=0 ratio=0 dg=0 toast=0 tray=0` — không thành phần nội dung nào
  sống; cờ sống duy nhất chung cả 5 là `to=1` (thêm `tw=1 twh=1` ở 3
  lần trong OmniCar.log). Guard từ chối khi các con trỏ nội dung mà nó
  được mô tả là canh đều tắt, với `to=1` là điểm chung — cần truy `to`
  là đầu vào nào của predicate (điểm mới cho GPT).
- **YTZ:** grant 8, gia hạn 8, lease nhận 23, ack applied 23 — mismatch
  khác 0 = 0 toàn phiên. Revoke teardown 6 (chỉ ở pha 1), snap cho thấy
  frame giữ nguyên — không layout cưỡng bức. Mask 24: 29 dòng phía app,
  không ca nào rời khỏi 24. OFF-control: NO-DATA (pref không tắt lần nào,
  8/8 lần xin đều được cấp).
- **Weather/knob:** phiên thứ tư liên tiếp NO-DATA — chỉ 2 chu trình
  `ans#1` warming-cache lúc SpringBoard startup (tự ghi NOT a CarPlay
  request, http 200, ready-posted); không ans#2, không payload hiển
  thị. Knob fade applied 23 / restored 22.
- **Pinch:** trạng thái OFF nhất quán (bw modes pinch=0 ×9, wouldPinch
  =0 ×34); dòng migration riêng NO-DATA (grep `migration` = 0 —
  `[pinch1]` chỉ có recognizer attached ×10 + 1 dòng session-end). BẰNG
  CHỨNG HAI NGÓN PHÍA TRONG APP ĐÃ CÓ: probe seq=49 (20:38:23.821)
  `ph B=2 M=17 E=2` do chính YouTube ghi — một episode hai chạm thật
  trong tiến trình app hosted (củng cố đính chính §29.11: kênh trong
  app thấy đủ hai ngón). `[touchset]` 590 dòng phía CarPlayApp không
  được dùng kết án pinch theo quy tắc đã chốt.
- **scenevis** (S1): 79 dòng ở thế hệ mới (Maps 43, YouTube 32,
  mobilecal 4); hidden=1 = 0, alpha≠1.00 = 0; attached=0 có 32/79, tất
  cả là YouTube scene=nil ở các mốc host-attach/going-home/detach-bg.

## 7. Trạng thái sau phiên

- ĐẠT (log): icon Home chạm mở panel (1); vòng đời AutoHide sau sửa (2);
  chuỗi kbstate khép trọn vòng + fade gate dùng đúng nguồn xác thực;
  YTZ sạch; FS expand confirmed.
- THẤT BẠI (log + màn hình): picker vẫn che nội dung — lỗi ở lớp phủ
  KHÁC placeholder, nghi phạm (b1) `pane.cover` / (b2) shield popup,
  cần 1 dòng đo alpha/superview để kết án đích danh (3); phím gốc
  hosted không dựng trên màn xe — tầng xe, không sửa bằng code bridge
  được (4).
- CHỜ PHÁN: Gate 3 — 4 ca would=1 sạch + mắt xích sau-đóng-phím đã có,
  nhưng tiêu chuẩn "HIDDEN + kb ACTIVE" bị chính thiết kế kb-hold chặn
  về cấu trúc; ca seq=45 (race reveal) cần soi; FS refusal với snap
  toàn 0 và `to=1` cần truy predicate.
- NO-DATA giữ nguyên: tầng model icon (reader BLIND cả phiên — giới
  hạn W5), weather/knob (phiên thứ 4), nguyên nhân respring 20:39:51,
  bằng chứng gõ phím (hệ quả của bước 4).
