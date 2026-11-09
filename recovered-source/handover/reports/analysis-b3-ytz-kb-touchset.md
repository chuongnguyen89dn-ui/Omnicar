# PHÂN TÍCH LOG PHIÊN YTZ3 — CỤM C: YTZ OFF/REVOKE + BÀN PHÍM + TOUCHSET/PINCH

Chỉ-đọc, đếm bằng lệnh, trích dòng nguyên văn kèm timestamp + PID.

## Nguồn và cửa sổ

- `OmniCar.log.old` (2.100.219 B, 6.957 dòng, SHA-256 `ea0b20ba…`): cửa sổ ytz3 bắt đầu tại **dòng 2332** = dòng `[probe-feed]` đầu tiên: `2026-11-09 16:18:14.148 [CarPlay:34964] [probe-feed] t=292493.740 epoch=1 fired pane=slot0(com.google.Maps)`.
- `OmniCar.log` (107.094 B, 879 dòng, SHA-256 `7c14140d…`): nối tiếp 16:35:40.244 → 16:50:44.741.
- Cửa sổ phân tích = `.old` dòng 2332–6957 + toàn bộ `OmniCar.log` = **5.505 dòng**, 16:18:14 → 16:50:44.
- Các phiên CarPlay trong cửa sổ: PID 34964 (16:18), 34985 (16:19–16:27), 35035 (16:27–16:50). SpringBoard tương ứng: 34934 / 34986 / 35036. YouTube: 34974 / 35007 / 35060.

---

## 1) YTZ — tắt công tắc GIỮA phiên: CÓ, và log khớp từng đoạn lời Nguyen

### 1.1 Số đếm được (toàn cửa sổ)

| Sự kiện | Đếm |
|---|---|
| `[ytz]` tổng | 164 dòng |
| `lease cap` (mở lease) | 6 (gen=0 ×3 phiên mới; gen=5, gen=10, gen=9 sau teardown/revoke) |
| `ack phase=applied` | **38 — tất cả windows=1 mismatch=0** |
| `ack phase=revoked` | 1 (windows=0) |
| `ack phase=expired` | **0** |
| `lease thu hoi ly do=pref` | **1** |
| `lease thu hoi ly do=teardown` | 3 |
| `ao hoa TAT ly do=revoke` / `ly do=close` | 1 / 4 |
| `tieu thu tuyen bo (lease song)` (tuyên bố hướng bị tiêu thụ khi lease sống) | 10 |
| `chan apporient: pane dang ao hoa` (chặn gói xoay) | 5 |
| `sua residue` | 1 |
| `isSplit-fallback` | **0** |
| dòng lease-lapse | **0** (2 hit của grep "lapse" là dump DIAG, không phải sự kiện) |
| Mọi `lease cap` đều `split=1` | 6/6 |

### 1.2 Ca quyết định: grant → pref-revoke → grant lại, CÙNG một phiên (SpringBoard 34986 / YouTube 35007)

- 16:19:26.759 `[SB:34986] lease cap gen=0 size=238x300 split=1` → ack applied 16:19:29.175. Lease sống liên tục, các lần cập nhật cỡ qua divider: gen=1 `116x300` (16:19:49.219), gen=2 `159x300` (16:19:49.763), gen=3 `478x300` (16:21:12.387 — lúc bung fullscreen), teardown 16:21:19.326, cap lại gen=5 `159x300` (16:21:23.348), gen=6 `238x300`, gen=7 `266x300`, gen=8 `238x300`, gen=9 `266x300` (16:22:10.352).
- **16:22:22.329 `[SB:34986] [ytz] lease thu hoi ly do=pref`** — cùng millisecond, phía CarPlay ghi `[wake1] bw modes wake=1 pinch=1 allowlist=all autohide=1` (đọc lại modes do pref đổi). App nhận: `16:22:22.333 [YouTube:35007] ao hoa TAT ly do=revoke`; host xác nhận `16:22:22.337 ack phase=revoked windows=0 mismatch=0`.
- **16:22:33.449 `[SB:34986] [ytz] sua residue: requestedOrientation 4 -> 0`** rồi ngay sau đó `16:22:33.450 lease cap gen=10 size=266x300 split=1` — công tắc bật lại. **Khoảng OFF = 11,121 s** (đây là lần đầu đối chứng OFF dài ≥10 s thực sự đo được; ở ytz2 chỉ 0,5 s).
- Sau khi bật lại: lease chạy tiếp gen=11…25 (16:22:34 → 16:25:59), mọi ack applied windows=1 mismatch=0.

### 1.3 Kiểm R1 (revoke không chạy layout/commit của host)

- Trong **2 giây sau revoke** (16:22:22.329 → 16:22:24.329), toàn bộ dòng của host (SpringBoard:34986, AppBridge) chỉ có đúng 2 dòng: `lease thu hoi ly do=pref` và `ack phase=revoked`. **Không có dòng layout/commit khung nào cho ô YouTube.**
- Mở rộng cả khoảng OFF (tới 16:22:33.450): host không phát bất kỳ lệnh hình học nào; hành động settings đầu tiên của host sau revoke là **đáp tuyên bố hướng của app** lúc 16:22:28.044 (+5,715 s). Chuỗi `layoutPane` không tồn tại trong toàn bộ log (0 hit) — phép kiểm là bằng chứng vắng mặt trên mọi họ dòng commit khung có trong log, cộng với bằng chứng dương ở 1.4.

### 1.4 Kiểm R3 (sau revoke app có tuyên bố hướng mới không — CÓ, và bệnh gốc lộ nguyên hình)

Trong khoảng OFF, app phát 4 tuyên bố, host đáp trên **đường gốc** (không dòng `[ytz] chan` nào):

```
16:22:28.044 [SB:34986] com.google.ios.youtube doi yeu cau xoay (ma 255, mask 2)  -> scene huong 1
16:22:28.695 [SB:34986] com.google.ios.youtube doi yeu cau xoay (ma 255, mask 2)  -> scene huong 1
16:22:29.725 [SB:34986] com.google.ios.youtube doi yeu cau xoay (ma 255, mask 24) -> scene huong 4
16:22:30.378 [SB:34986] com.google.ios.youtube doi yeu cau xoay (ma 255, mask 24) -> scene huong 4
```

- Hai tuyên bố `mask 24` (cả hai chiều ngang — tuyên bố của trình phát toàn màn) bị đường gốc **suy ra huong 4** và ghi vào `requestedOrientation` — bằng chứng dương: dòng `sua residue: requestedOrientation 4 -> 0` lúc bật lại (16:22:33.449) cho thấy trong kỳ OFF trường này đã bị ghi giá trị 4, phải dọn trước khi cấp lease mới. Đây chính là cơ chế bệnh gốc (mask 24 → suy ra 4 → hoán trục trong hộp dọc) bắt được trực tiếp trong log.
- Vậy R3 ở ca này **không** xảy ra theo dạng "không có tuyên bố mới": app có tuyên bố mới sau +5,7 s, nhưng tuyên bố đó được xử lý bằng đường gốc nên **tự nó tạo ra trạng thái sai** thay vì chữa. Lệch hình học của kỳ OFF không cần tới R1/R3 riêng lẻ — đường gốc đang sống là đủ.
- Ngay sau khi bật lại, tuyên bố đầu tiên bị chặn đúng thiết kế: `16:22:33.810 [YouTube:35007] bao SpringBoard: ma 255, mask 24` → `16:22:33.811 [SB:34986] [ytz] chan apporient: pane dang ao hoa (hash=3551846623)`.

### 1.5 Đối chiếu lời Nguyen

- "Tắt → sai chiều + bó giao diện": **khớp** — kỳ OFF 11,1 s chứa 2 đáp án `mask 24 -> huong 4` trên đường gốc + residue `requestedOrientation=4`.
- "Bật lại → phóng tốt": **khớp** — residue được dọn (`4 -> 0`), lease cấp lại gen=10, gói xoay bị chặn ngay mili-giây đầu, 38/38 ack applied của cả cửa sổ đều windows=1 mismatch=0, không một ack expired, không lapse.
- Không có trong log: kích thước snapshot khôi phục phía app lúc revoke (dòng `ao hoa TAT ly do=revoke` không kèm cỡ) → kiểm R2 (snapshot cỡ đầu phiên) **không thực hiện được** từ log này.

---

## 2) BÀN PHÍM — app ô phải là Google Maps NATIVE; H2 được chứng minh, H1 đúng ở mức hình học scene

### 2.1 Số đếm được

| Kiểm | Kết quả |
|---|---|
| Dòng `ban phim xe: hien cho <bundle>` (bàn phím tự vẽ ABKeyboard của đường hosted) | **0 trong toàn cửa sổ** |
| Dòng chứa `keyboard` | 18 — **cả 18 nằm trong dump DIAG** (danh sách method của lớp), không phải sự kiện bàn phím |
| `kb=` trong gói/probe | `kb=-` ×38 (bw probe phía app), `kb=0` ×26 (act-accepted); **`kb=1`: 0** — cổng wake không hề thấy một phiên bàn phím nào trong cửa sổ |
| `host-attach` | chỉ `com.google.ios.youtube` ×5 — Maps/GOFA không bao giờ host-attach |

### 2.2 Danh tính ô phải lúc ~16:20 (khớp ảnh: YouTube trái + Maps tìm kiếm phải)

```
16:19:25.941 [CarPlay:34985] [scenevis] attach bundle=com.google.Maps slot=1 scene=Car[2-3]:com.apple.CarPlayTemplateUIHost:com.google.Maps attached=1 inHost=1 hidden=0 alpha=1.00 window=1
16:19:25.942 [CarPlay:34985] CarSplit: dua com.google.Maps (DBApplicationSceneViewController) vao o 1
16:19:25.944 [CarPlay:34985] CarSplit: scene com.google.Maps -> {191, 240}
16:19:26.856 [CarPlay:34985] CarSplit: scene com.google.Maps that = {191, 240} (can {191, 240})
16:19:49.156 [CarPlay:34985] CarSplit: scene com.google.Maps -> {254, 240}
16:19:50.098 [CarPlay:34985] CarSplit: scene com.google.Maps that = {254, 240} (can {254, 240})
16:20:04.587 [CarPlay:34985] [probe-foreign] began … pt={394.5,21.0} pane=slot1 (com.google.Maps native) side=R
```

- App bản đồ ô phải là **com.google.Maps ở dạng NATIVE** — scene template CarPlay (`CarPlayTemplateUIHost`), vào ô bằng `DBApplicationSceneViewController`, không qua ABHost. GOFA trong cửa sổ cũng native cùng một kiểu (`scene=Car[2-3]:…:com.lumi.GOFA`, `dua com.lumi.GOFA (DBApplicationSceneViewController) vao o 1`).
- Khung hình học: vùng app toàn màn = `{{45, 0}, {382, 240}}` (màn 427×240, dock 45). Scene Maps lúc mở phiên = **{191, 240}** (đúng nửa vùng app); sau cú kéo divider 16:19:49 (`ti le cac o = 0.33 / 0.67`) scene Maps = **{254, 240}** — đây là kích thước còn hiệu lực tại thời điểm ảnh 16:20 (lần đổi cỡ tiếp theo là 16:21:25, về {191, 240}).

### 2.3 Phán H1 / H2

- **H2 — ĐÚNG và là kết luận chính:** phiên này Maps chạy **native**, không phải hosted. Hệ quả tất yếu: bàn phím trong ảnh là **bàn phím hệ thống dựng trong scene template của chính Maps**, không phải ABKeyboard (đường hosted có 0 dòng hiện phím trong cả cửa sổ). Hai renderer khác nhau thật, và phiên này rơi vào renderer native.
- **H1 — đúng ở mức hình học, không phải nguyên nhân độc lập:** scene native chỉ rộng 191 pt (lúc dựng) / 254 pt (lúc chụp ảnh) trên vùng app 382 pt — bàn phím hệ thống bị nén theo bề rộng scene là hệ quả hình học trực tiếp của việc scene bị gán khung cỡ ô. Tỉ lệ 0.33/0.67 có thật trong log (16:19:49.159).
- **Không có trong log:** bất kỳ dòng nào ghi thời điểm bàn phím native mở/đóng hay kích thước của nó — bàn phím trong scene native **không phát sự kiện nào** vào log này (kb không bao giờ =1). Vì vậy log không cho biết phiên trước ("lần trước không lỗi") app lên hosted hay native — chỉ chốt được phiên này: native + scene 254×240 tại thời điểm ảnh.

---

## 3) TOUCHSET — 62/62 ca active=2 là biểu diễn TRÙNG của MỘT contact; hai contact độc lập cùng ô: 0

### 3.1 Số đếm được

| Kiểm | Kết quả |
|---|---|
| Dòng `[touchset]` toàn cửa sổ | 335 |
| Snapshot `active=2` | **62** |
| Snapshot `active>=3` | **0** |
| Cặp active=2 có **evB khác nhau** | **0 / 62** (đếm bằng lệnh: tách cả hai evB của từng dòng, so sánh số học) |
| Cặp có 2 điểm bắt đầu phân biệt (hai ngón thật) | **0 / 62** |

### 3.2 Mẫu hình của cả 62 ca (ba biến thể, cùng một bản chất)

**Biến thể A — cùng điểm, hai window (đa số).** Hai record khác con trỏ UITouch nhưng **cùng evB và cùng điểm screen-space** tại thời điểm xuất hiện; record ở `_UISystemGestureWindow` đứng yên tại điểm bắt đầu, record ở window nội dung (`UIWindow` / `SCPCPass_UIRootSceneWindow`) mới di chuyển theo ngón tay:

```
16:18:17.115 [CarPlay:34964] [touchset] … active=2 [ptr=0x980814d30 win=_UISystemGestureWindow raw={232,124} scr={232,124} pane=slot0(com.google.Maps) evB=292496.699] [ptr=0x980910eb0 win=UIWindow raw={232,124} scr={232,124} pane=slot0(com.google.Maps) evB=292496.699]
16:18:29.391 [CarPlay:34964] [touchset] … active=2 [ptr=0x980f04750 win=_UISystemGestureWindow … scr={338,112} pane=slot1(com.lumi.GOFA) evB=292508.968] [ptr=0x980b28480 win=SCPCPass_UIRootSceneWindow … scr={338,112} pane=slot1(com.lumi.GOFA) evB=292508.968]
16:18:29.516 … record 2 trượt tới scr={232,122} pane=slot0 trong khi record 1 vẫn {338,112} — MỘT ngón kéo ngang qua divider, không phải hai ngón.
16:25:46.314 [CarPlay:34985] [touchset] … active=2 [ptr=0x838d0c710 win=_UISystemGestureWindow scr={308,12} pane=slot1(com.google.Maps) evB=292945.897] [ptr=0x838c19b20 win=UIWindow scr={308,12} pane=slot1(com.google.Maps) evB=292945.897]
```

**Biến thể B — vùng hệ thống:** cặp `_UISystemGestureWindow` + `DBStatusBarWindow`, cùng điểm, `pane=none` — các cú chạm góc Home/status (vd {15,10} lúc 16:18:21.459, {22,223} lúc 16:18:39.951, {25,224} lúc 16:21:19.247). Đây là đúng họ trùng biểu diễn mà GPT đã cảnh báo với ca mẫu {15,222.5}.

**Biến thể C — record ma không window:** record thứ hai `win=(nil) raw={0,0} scr=- pane=n/a` nhưng **evB vẫn trùng** với record thật (vd 16:18:18.112, 16:22:25.751) — một biểu diễn phụ không tọa độ của cùng event.

Chuỗi kéo dài nhất (16:18:44–16:18:49, `pane=none`) cũng giữ mẫu: record 1 đóng băng tại {340,150} / {276,134} ở gesture window, record 2 trượt {340,150}→{302,152}→{225,166} / {276,134}→{166,153} — một ngón kéo bản đồ, hai biểu diễn.

### 3.3 Kết luận cho kiến trúc pinch

- Trong toàn bộ cửa sổ **không tồn tại một ca nào** có hai contact độc lập đồng thời — cùng ô: **0**, khác ô: **0**. Mọi active=2 đều là một contact vật lý bị nhân đôi qua hai window (cùng evB tuyệt đối, 62/62).
- Hệ quả đo được: nếu ghép mọi record đồng thời thành "hai ngón", **62/62 ca sẽ là pinch giả** — gồm cả chạm góc Home và kéo một ngón. Dữ kiện này xác nhận hướng của GPT: chưa được ghép cặp tại CarPlayApp nếu không có phép khử trùng theo (evB + điểm bắt đầu + window) — và ngay cả sau khử trùng, phiên này không ghi được một pinch hai ngón thật nào để hiệu chuẩn (các lần Nguyen pinch thử hoặc không tới CarPlayApp thành hai contact, hoặc bị nuốt vào cùng một biểu diễn — log không phân biệt được hai khả năng đó).

---

## 4) PINCH / FS ĐƯỜNG PINCH — 0 tuyệt đối, đúng kỳ vọng DRY_RUN

| Kiểm | Kết quả |
|---|---|
| `[pinch1]` | 5 dòng: 4× `recognizer attached to split container`, 1× tổng kết phiên |
| Tổng kết phiên 16:42:18.460 [CarPlay:35035] | `session end pairs split complete=0 truncated=0 \| expanded complete=0 truncated=0` — recognizer trên container **không hợp thành một cặp nào** cả phiên |
| `wouldPinch=1` (probe phía app) | **0** (38 dòng probe, tất cả `wouldPinch=0`) |
| Dòng `disposition` | **0** |
| `BlockedHidden` | **0** |
| `provenance=pinch` | **0** (mọi expand/restore trong cửa sổ: `provenance=diag` ×40, `provenance=teardown` ×2) |

Không có bất kỳ disposition hay expand nào xuất phát từ pinch trong cửa sổ — đường pinch hoàn toàn bất hoạt đúng như thiết kế DRY_RUN của bản ytz3.

---

## Tóm tắt "không có trong log" (để không suy diễn quá dữ kiện)

1. Kích thước snapshot khôi phục phía app tại revoke → R2 không kiểm được.
2. Sự kiện mở/đóng và kích thước của bàn phím native trong scene Maps → chỉ chốt được renderer (native) và cỡ scene, không chốt được hành vi bàn phím.
3. Danh tính hosted/native của app bản đồ ở **phiên trước** → ngoài cửa sổ này.
4. Một pinch hai ngón thật → không xuất hiện trong cửa sổ; log không nói được pinch thử của Nguyen đã đi đâu.
