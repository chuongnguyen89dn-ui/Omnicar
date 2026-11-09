# Phân tích log phiên ytz3 — Cụm B: Wake / AutoHide / Feed native / Failopen

Chỉ-đọc, đếm bằng lệnh trên hai file gốc. Mọi số dưới đây là "đếm được" trừ chỗ ghi rõ "không có trong log".

## 0. Cửa sổ + phiên

| File | Byte | Dòng | SHA-256 |
|---|---|---|---|
| OmniCar.log.old | 2.100.219 | 6.957 | `ea0b20bab8458f545f52c3dd276a966e743a4c10fdf9a031472671d6253b9f3e` |
| OmniCar.log | 107.094 | 879 | `7c14140d45b712476d9f20c62bc3ae161fa6da623c0ea482995302c10c771290` |

- Cửa sổ ytz3 theo định nghĩa đề bài: từ dòng **[probe-feed] đầu tiên** = `OmniCar.log.old` dòng 2332, `2026-11-09 16:18:14.148 [CarPlay:34964] [probe-feed] t=292493.740 epoch=1 fired pane=slot0(com.google.Maps)` → hết `OmniCar.log` (16:50:44). Tổng cửa sổ: **5.505 dòng**.
- CarPlay PID trong cửa sổ: **34964** (phiên bắt đầu 16:17:57.770, trong cửa sổ 16:18:14 → 16:19:08.891), **34985** (16:19:13.435 → 16:27:15.089), **35035** (16:27:19.745 → ngắt màn 16:42:18.552; phần log sau 16:42 chỉ còn dòng SpeedBubble của GOFA). Hai lần CarPlay khởi động lại giữa cửa sổ (~16:19:09–13 và ~16:27:16–19).
- Ca biên: PID 34964 bắt đầu trước mốc cửa sổ 17 giây; fade 16:18:08.340 và reveal của nó ở dòng 2331 (ngay trước mốc 1 dòng) được phân tích riêng như "ca biên", không tính vào số trong cửa sổ.

## 1. AutoHide — fade / reveal / mồ côi

**Số đếm được (trong cửa sổ):**

- Fade thật (`fade last=*`): **14** — `last=container` ×8, `last=app` ×3, `last=home` ×1, `last=dragend` ×1, `last=hosthandle` ×1. Mọi fade đều `idle=4.00` (một ca `idle=4.01` ×2, một ca dị thường `idle=97.00` — xem mục 6).
- Fade deferred: **1** — `16:21:08.371 [CarPlay:34985] fade deferred (surface-open)`; nó hiện thực hoá 7,25 s sau thành fade `last=hosthandle` 16:21:15.619 (đã tính trong 14).
- Reveal (`reveal-applied`): **13** — `reason=activity` ×9, `reason=unsuspend` ×4 (mọi reveal đều `views=5`, unsuspend `views=6`).
- Gương phía host (SpringBoard): `host fade applied` ×13, `host fade restored` ×12, `host knob fade applied` ×12, `host knob fade restored` ×11.

**Ghép cặp fade → reveal (14/14 xác định được):**

| # | Fade (PID) | Đóng bởi | Reveal lúc | Nguồn activity |
|---|---|---|---|---|
| A (biên) | 16:18:08.340 container (34964) | activity | 16:18:14.148 | feed native Maps slot0 (ca biên) |
| 1 | 16:18:21.117 container (34964) | activity | 16:18:22.747 | feed native GOFA slot1 |
| 2 | 16:18:31.943 home (34964) | **MỒ CÔI** | — | — |
| 3 | 16:19:29.562 container (34985) | activity | 16:19:33.603 | feed native Maps slot1 |
| 4 | 16:19:37.607 container (34985) | activity | 16:19:38.480 | feed native Maps slot1 |
| 5 | 16:19:42.484 container (34985) | activity | 16:19:43.186 | feed native Maps slot1 |
| 6 | 16:19:53.153 dragend (34985) | activity | 16:20:04.588 | feed native Maps slot1 |
| 7 | 16:20:08.590 container (34985) | activity | 16:21:03.115 | act hosted YouTube (act-accepted seq=1, 16:21:03.114) |
| 8 | 16:21:15.619 hosthandle (34985) | activity | 16:21:17.223 | act hosted YouTube (seq=2) |
| 9 | 16:21:38.229 container (34985) | unsuspend | 16:22:04.454 | vào EXPANDED (suspend khôi phục) |
| 10 | 16:23:11.230 container idle=97.00 (34985) | activity | 16:24:38.273 | act hosted YouTube (seq=16) |
| 11 | 16:27:36.200 container (35035) | unsuspend | 16:27:50.015 | vào EXPANDED |
| 12 | 16:28:00.197 app (35035) | unsuspend | 16:28:06.340 | vào EXPANDED |
| 13 | 16:33:18.997 app (35035) | activity | 16:33:21.296 | act hosted YouTube (seq=5, PID 35060) |
| 14 | 16:33:25.840 app (35035) | unsuspend | 16:33:33.848 | vào EXPANDED |

**Fade mồ côi: đúng 1 ca** — fade #2, `16:18:31.943 [CarPlay:34964] fade last=home idle=4.00` (gương host có áp: `16:18:31.947 [SpringBoard:34934] host fade applied bundle=com.google.ios.youtube`). Ngữ cảnh: split lúc đó là slot0 Maps native + YouTube hosted đang vào ô. Sau fade chỉ có 2 cú chạm trước khi PID chết, **không cú nào đủ điều kiện thành activity**:

- `16:18:39.946` Began tại {22.5, 223.0} → `drop-systemregion` (góc Home dưới-trái, bị loại theo thiết kế; cả hai biểu diễn cửa sổ đều drop cùng lý do).
- `16:18:43.385` Began `active=0` → `drop-inactive` (split đã tắt, epoch lên 2).

PID 34964 chết 16:19:08.891 không có reveal/restore nào. Kết luận: mồ côi do **phiên chết**, không phải do feed/act bỏ qua một cú chạm hợp lệ. Bốn fade đóng bởi unsuspend (#9/#11/#12/#14) cũng không có cú chạm hợp lệ nào chen giữa fade và lúc vào EXPANDED — chúng không phải mồ côi, chúng bị đóng bởi máy suspend.

Gương host: 13 `host fade applied` khớp 13/14 fade trong cửa sổ; hai fade ở PID 34964 trước khi YouTube vào ô (ca biên A và #1 — split toàn native Maps+GOFA) không có dòng host, đúng vì chưa có ô hosted. `host knob fade applied` thiếu đúng 1 (fade #8 dạng deferred/hosthandle). `restored` hụt đúng 1 so với `applied` ở cả hai kênh = chính fade mồ côi #2. Cuối phiên: `16:42:18.460 [CarPlay:35035] teardown faded=0` — không fade nào treo lúc ngắt.

## 2. Feed native [probe-feed]

**Số đếm được:** tổng `[probe-feed]` = **155 dòng** = fired **41** + drop **114**.

**fired theo ô/bundle (41):** `slot1(com.google.Maps)` ×32, `slot0(com.google.Maps)` ×7, `slot1(com.lumi.GOFA)` ×2 — **100% là ô native**. Theo PID: 34964 ×8, 34985 ×33, **35035 ×0**.

Lưu ý đếm: fired đếm theo DÒNG; một số cú chạm vật lý xuất hiện qua 2 cửa sổ nên có 2 dòng fired cùng điểm (ít nhất 3 cặp: 16:18:17.111/.115, 16:25:46.311/.314, 16:25:47.879/.880) → số cú chạm native phân biệt ≈ 38.

**drop theo lý do (114):**

| Lý do | Số | Ghi chú |
|---|---|---|
| drop-inactive | 44 | split không active (trước session start / sau teardown / giữa hai PID) |
| drop-hosted | 36 | chạm thuộc ô hosted — feed nhường đường act (F4) |
| drop-popup | 15 | sub: `(picker)` ×6, `(traywindow)` ×5, `(tray)` ×4 |
| drop-systemregion | 9 | cửa sổ status bar + góc Home {22.5, 223.0} |
| drop-notassigned | 5 | `pane=none` ×4, `pane=slot1((nil))` ×1 (16:21:24.270) |
| drop-unconverted | 5 | `win=(nil)` ×5 |
| drop-display | **0** | **không có trong log** — cổng này không lần nào kích hoạt, chưa được kiểm chứng |

**Ca quyết định (fade đang hiệu lực → Began trên ô native → fired → reveal-applied): 6/6 trọn vẹn** (1 biên + 5 trong cửa sổ: fade #1, #3, #4, #5, #6 ở bảng mục 1). Mẫu nguyên văn ca đầu tiên của cơ chế:

```
16:18:14.147 [CarPlay:34964] [probe-foreign] began … pane=slot0 (com.google.Maps native)
16:18:14.148 [CarPlay:34964] [autohide] reveal-applied reason=activity views=5
16:18:14.148 [CarPlay:34964] [probe-feed] t=292493.740 epoch=1 fired pane=slot0(com.google.Maps) win=_UISystemGestureWindow
```

Độ trễ Began → reveal trong cả 6 ca: **0–3 ms** theo timestamp log (dòng reveal đứng trước dòng fired 0–1 ms vì `ahNoteActivity` áp reveal đồng bộ ngay trong lời gọi feed, feed ghi log sau). **Không có ca nào gãy ở mắt feed**: mọi Began native đủ điều kiện trong lúc đang faded đều thành reveal.

Các "không-chuỗi" đều giải thích được, không phải gãy: (a) fade mồ côi #2 — sau fade không có Began hợp lệ nào (mục 1); (b) 4 fade đóng bởi unsuspend — người dùng không chạm trước khi vào EXPANDED; (c) 9 dòng fired rơi vào khoảng đang suspend-EXPANDED (mục 6) — feed có bắn nhưng AutoHide no-op theo thiết kế, và controls vốn đang hiện nên không cần reveal; (d) PID 35035 fired = 0 vì **không có Began nào rơi vào ô native lúc split active**: toàn bộ 20 dòng probe-feed của PID này là drop-hosted ×6 (slot0 YouTube), drop-systemregion ×2, drop-inactive ×12 — người dùng không chạm ô GOFA slot1 trong các khoảng split active của PID này.

**So với ytz2 (bằng số):** ytz2 không có feed; hai ca bị kết án là fade 15:37:49 → **16 Began native → 0 reveal** và fade 15:39:33 → **25 Began native → 0 reveal** (tổng 41 Began native, tỉ lệ chuyển đổi 0%). ytz3: **41 dòng fired**, 6/6 chuỗi fade→native Began→reveal trọn vẹn, độ trễ ≤3 ms (ytz2: vô hạn — không bao giờ reveal). Khoảng trống wake-native đã đóng ở tầng cơ chế đối với các phiên split đang active.

## 3. Act hosted — vòng khép kín

**Số đếm được:**

- `act-posted` (phía app): **26** — YouTube PID 35007 ×20, YouTube PID 35060 ×6. Không app hosted nào khác phát act phiên này (GOFA là native ở 34964/34985; Facebook/TikTok không xuất hiện — khác ytz2 có 3 app).
- `act-accepted` (phía owner): **26**, 100% `bundle=com.google.ios.youtube`, `kb=0` ×26.
- Drop phía owner (6 lý do decode-fail/bad-hash/bad-gen/session-inactive/not-assigned/split-inactive): **0 dòng trong log**. Vòng posted → accepted khép kín **26/26**.
- Drop phía app: `act-drop-nosession` **×12**, tất cả YouTube:35007, `stateage=-1`, trải 16:26:01.681 → 16:26:35.926.

**Ngữ cảnh 12 ca nosession (không phải đứt vòng):** 16:25:58.820 người dùng kéo divider sát mép → ô GOFA đóng → `CarSplit: tat split (goHome=1)` → `[fs1] fs session-end abbreviated restore provenance=teardown`, renew dừng; YouTube chuyển sang App Bridge toàn màn solo. Agent trong app vẫn đánh giá các cú chạm sau đó nhưng phiên BW đã teardown (không còn gói state mới) → state=UNKNOWN, act bị drop nosession. Vòng act kết thúc vì **phiên split kết thúc**, không phải vì lỗi đường truyền. Độ trễ act-posted → act-accepted → reveal ở 4 fade đóng bởi act (#7/#8/#10/#13): 1–6 ms.

## 4. Failopen / suppression — bằng chứng cho Gate 3

**Số đếm được:** dòng `[do] bw probe` (đánh giá DRY_RUN phía app): **38**, toàn bộ từ YouTube (35007 ×32, 35060 ×6).

- `wouldSwallow=0` ×**38/38**; `wouldPinch=0` ×38/38. Dòng nuốt thật (`swallowed`): **không có trong log** (đúng thiết kế DRY_RUN).
- Phân bố state: `state=V` ×22, `state=H` ×4, `state=U` ×12.
- `failopen=-` (không failopen) ×22; `failopen=kbunknown` ×**4**; `failopen=unknown` ×**12**. Không có chính tả failopen nào khác trong cả hai file.

**kbunknown ×4 — cả 4 đều ở `state=H`** (đúng các ca quyết định cho suppression), đều trùng một reveal đóng bởi act:

```
16:21:03.129 [YouTube:35007] bw probe seq=1  state=H kb=- wouldSwallow=0 failopen=kbunknown
16:21:17.255 [YouTube:35007] bw probe seq=2  state=H kb=- wouldSwallow=0 failopen=kbunknown
16:24:38.291 [YouTube:35007] bw probe seq=16 state=H kb=- wouldSwallow=0 failopen=kbunknown
16:33:21.345 [YouTube:35060] bw probe seq=5  state=H kb=- wouldSwallow=0 failopen=kbunknown
```

Sự thật cấu trúc: trường `kb=` phía app là `-` (không rõ) ở **38/38** dòng probe — phía app **không một lần nào** quan sát được giá trị kb xác định trong phiên này; trong khi phía owner ghi `kb=0` ở 26/26 act-accepted. Hệ quả: cứ khi nào cổng có đủ điều kiện state=H (4/4 ca), nó đều fail-open vì kbunknown. **Bằng chứng suppression vẫn CHƯA trọn: vật cản còn lại là tín hiệu kb phía app (chưa từng known), không còn là độ tươi của state** (mục 5). `wouldSwallow=1`: **0 dòng trong log** — chưa có cú chạm nào trong phiên đạt đủ mọi điều kiện nuốt ngay cả ở mức đánh giá.

**unknown ×12** — tất cả YouTube:35007 seq=21–32, 16:26:01.726 → 16:26:35.985, `state=U`: chính là giai đoạn solo sau teardown split ở mục 3 (mỗi dòng probe đứng sau một `act-drop-nosession` cùng cú chạm ~50 ms). Đây là trạng thái "không có phiên" trung thực theo thiết kế, không phải lỗi cổng.

## 5. Renewal + state age

- `bw renew panes=` : **1.275 dòng** (34964 ×8, 34985 ×388, 35035 ×879 — trong đó 398 dòng nằm ở OmniCar.log), **100% `panes=1`**: chỉ ô hosted YouTube nằm trong vòng renewal; ô native không được renew (đúng thiết kế — native nay có feed riêng). `bw renew start` ×5, `bw renew stop` ×5; stop cuối 16:42:18.460 đúng lúc ngắt.
- Nhịp tick: **1,00 s** (mẫu 35035: 16:27:33.245 → 34.244 → 35.244 → 36.244 → 37.244 → 38.244; và cuối file .old: 16:35:39.028 → 16:35:40.027/028).
- `stateage` của 26 act đã posted (ms): 26, 175, 237, 266, 278, 290, 430, 439, 443, 457, 501, 534, 554, 573, 584, 608, 620, 621, 695, 788, 806, 876, 895, 946, 973, **987 (max)**. Số ca >1000 ms: **0**. Số ca >2500 ms: **0**. (ytz2: max 2.056 ms, có 1 ca >2 s.) Ca phân định W2 (act với stateage >2.500 ms) **lại không xuất hiện** — renewal giữ state luôn trẻ, nên phép tách freshness của W2 vẫn chỉ có bằng chứng gián tiếp. 12 ca nosession mang `stateage=-1` = không có state nào cả (phiên đã teardown), khác hẳn state cũ.

## 6. Wake quanh EXPANDED

**Số đếm được (phía wake):** `bw expanded ON` ×13 / `OFF` ×13; `[autohide] suspend` ×13 (khớp 1-1 với ON), `resume` ×12 (khớp OFF trừ lần OFF cuối do teardown 16:42:18.462, đi cùng `teardown faded=0`). Các chu kỳ EXPANDED: 16:22:04–16:23:07 (6 chu kỳ ngắn, có lần chỉ 0,8–1,4 s), 16:24:41–16:25:58 (77 s, kết thúc bởi teardown split), 16:27:50–16:33:37 (6 chu kỳ ở PID 35035, có lần suspend chỉ 0,9 s), và chu kỳ cuối **16:33:37.123 → 16:42:18.462 (8 phút 41 s)** kết thúc bởi ngắt màn.

- **Fade trong các khoảng EXPANDED/suspend: 0.** Cả 14 fade đều rơi vào khoảng không-bị-suspend. Đây là bằng chứng log của hiện tượng Nguyen báo ("khi fullscreen thì logo không tự ẩn"): hai khoá treo (suspend qua `bwSetExpandedActive` + cổng fade `expanded`) làm AutoHide không bao giờ khởi động được khi đang EXPANDED — feed vẫn bắn (9 dòng fired trong các khoảng suspend: 16:22:12.411, 16:22:15.456, 16:22:19.450, 16:25:44.715, 16:25:46.311, 16:25:46.314, 16:25:47.879, 16:25:47.880, 16:25:58.428) nhưng `ahNoteActivity` no-op, và vì suspend đã khôi phục controls về hiện nên cũng không phát sinh reveal nào.
- **Reveal tại miệng vào EXPANDED: 4** (`reason=unsuspend`, cùng mili-giây với suspend + expanded ON): 16:22:04.454, 16:27:50.015, 16:28:06.340, 16:33:33.848 — dọn các fade #9/#11/#12/#14. 9 lần suspend còn lại vào lúc controls đang hiện nên không có reveal.
- Dị thường đếm idle: fade 16:23:11.230 ghi `idle=97.00` — nó bắn 4,003 s sau resume 16:23:07.227 nhưng bộ đếm idle tính từ activity cuối **trước** cả giai đoạn suspend (idle bao gồm thời gian bị treo). Không ảnh hưởng ghép cặp, nhưng là artefact cần biết khi đọc log các phiên sau.

## 7. Không có trong log (giới hạn bằng chứng)

- `drop-display`: 0 dòng — không Began nào đến từ màn hình lạ; cổng display chưa được kiểm chứng, không phải đã chứng minh.
- `wouldSwallow=1`: 0 dòng — chưa cú chạm nào đạt đủ điều kiện nuốt ở mức đánh giá DRY_RUN (mọi ca state=H đều chết ở kbunknown).
- Ca state age >2.500 ms: không xảy ra (lần thứ hai liên tiếp) — phép tách freshness của W2 chưa có ca phân định trực tiếp.
- Ngoài YouTube, không app hosted nào phát act/probe trong phiên này; đường act của app hosted khác (Facebook/TikTok như ytz2) không có dữ kiện phiên này.
