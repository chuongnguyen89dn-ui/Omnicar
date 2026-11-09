# THIẾT KẾ (chỉ-đọc) — Bóc cơ chế ẩn logo + gọi lại của DuoFace QA180 `h1wake3` tới mức sẵn-sàng-áp-dụng, và bảng ánh xạ sang OmniCar

Ngày: 2026-11-09. Loại việc: nghiên cứu thiết kế chỉ-đọc — không sửa code, không build, không git.
Nền: `work/fix-round6/invest-duoface-logo.md` (cơ chế + bằng chứng + 8 điều kiện tiên quyết) — tài liệu này không lặp lại phần điều tra, chỉ đào tới mức trạng thái máy đầy đủ, ánh xạ source OmniCar, và kế hoạch bản đo.
Nguồn sâu: `~/workspace/duoface-audit/BUOC0_QA180.md`, `BAO_CAO_TAN_RANG_TONG_HOP.md` (chỉ là hồ sơ deb DuoNavi gốc — không chứa cơ chế wake; đã kiểm, không dùng cho mục 1), strings `sweep-ours/relay_strings.txt` (khớp tên `sendEvent:`, `_DF156Write/_DF156ReadState/_DF156Channel`), `~/memory/2026-11-03.md`, `~/memory/2026-11-06.md`, `~/MEMORY.md`.
Phía OmniCar: cây `~/workspace/omnicar-re/project/` (`OmniCarAppBridge/`, `OmniCarSplitScreen/`) + `metadata/IPC_MAP.md`.

---

## 1. Máy trạng thái đầy đủ của QA180 `0.0.180~h1wake3`

### 1.1 Phía host — `DFNative12Chrome` (process SpringBoard)

Trạng thái controls là **giá trị suy ra**, không có biến độc lập. Mọi trường:

| Trường / hằng | Loại | Ý nghĩa |
|---|---|---|
| `controlsVisible` | suy ra trong `layoutControls` | `panActive \|\| logoTouchPending \|\| now <= controlsUntil` |
| `controlsUntil` | deadline (NSTimeInterval) | `noteUserActivity` đặt `= now + 4.0` mỗi lần có hoạt động/wake |
| `borderUntil` | deadline | `noteUserActivity` đặt `= now + 2.0` (viền, đi kèm controls) |
| `logoTouchPending` | cờ | đang có chạm chờ trên chính logo |
| `panActive` | cờ | đang pan/kéo |
| dọn theo hẹn | `dispatch_after` 4,05 s | sau `noteUserActivity`, hẹn layout lại để controls tự ẩn khi qua `controlsUntil` (relayout có throttle 250 ms) |

Hành vi cốt lõi:

- `noteUserActivity` là **hành động đánh thức duy nhất**: đặt hai deadline, gọi `layoutControls`. Mọi nguồn hoạt động (kể cả wake từ app) đều quy về hàm này.
- `layoutControls` là **điểm duy nhất** vừa suy ra `controlsVisible` vừa áp lên hình — và ở h1wake3 là **điểm duy nhất được phép phát trạng thái**: mỗi lần giá trị suy ra *đổi*, companion `DFH1Wake188.m` (swizzle `start`/`stop`/`layoutControls`, file Chrome gốc giữ byte-identical với nền QA171) post đúng một trong hai Darwin notification: `com.duoface.controls188.hidden` hoặc `com.duoface.controls188.shown`.
- Hỏi/đáp: companion đăng ký nhận `com.duoface.controls188.query`; mỗi query tới → post lại notification tương ứng trạng thái hiện tại (không đổi trạng thái, chỉ trả lời).
- Nhận wake: companion đăng ký wake DF156 trong `start`; khi wake tới → **kiểm tra độ tươi + chống trùng** → gọi `noteUserActivity` nguyên dạng. (Giới hạn đã ghi ở STATUS_QA178: validation phía host chỉ ở mức tươi + trùng, chưa sao chép toàn bộ validation process-sống của cây khôi phục.)
- Đời trước (h1wake1, đã thay): publish bằng ghi plist `ControlsHidden188` + một notify `com.duoface.controls188.state` — phía app đọc plist là điểm gãy (mục 1.3).

### 1.2 Đường tín hiệu wake (app → host) — mailbox DF156

- Vận chuyển: Darwin notify mang payload trong notify state (`notify_register_check` / `notify_set_state` / `notify_post` qua `DF156Write`/`DF156ReadState`/`DF156Channel`); payload chạm = `{bundle, count, ts}`, chặn cứng ≤ 2048 byte, **một ô latest-value cho mỗi kênh** (ghi sau đè ghi trước — hệ quả đã đo: các record dày đặc có thể ghi đè nhau, xem lỗi đo QA181 ở hồ sơ khác).
- Nhịp gửi phía app: throttle **250 ms** cho tín hiệu chạm thường; **dãy bị nuốt bỏ qua throttle** (phát wake ngay).
- Tên wake phía host: `DF177TouchWakeName`, đăng ký trong `start` của Chrome; handler `df177HandleAppTouch` → `noteUserActivity`.
- Kill-switch: key `AppTouchRecall177` trong plist qa177 — vắng mặt = bật; cả hai phía đọc trực tiếp (đọc hỏng → phía app hiểu là bật, xem `DF177AppTouchEnabled()` ở 1.3).

### 1.3 Phía relay — trong process app được host

Cài đặt: `DF177InstallAppTouchHook(bundle)` gọi trong constructor của relay DF154 (phủ 14 app pilot) và của relay YouTube riêng; cả hai dùng header chung `DFAppTouch177.h`.

**Hook** `-[UIApplication sendEvent:]` (MSHookMessageEx trên UIApplication):

- Dạng H1 (QA177, chỉ-đọc): IMP gốc chạy trước, hook chỉ đọc pha Began, bộ đếm cộng dồn, gửi tín hiệu DF156.
- Dạng cổng (h1wake1 → h1wake3): tại đầu mỗi dãy chạm, đánh giá cổng (bảng dưới). Cổng thỏa → **không gọi chuyển tiếp trọn dãy** cho tới Ended/Cancelled (app không nhận được dãy đó), chỉ phát wake; cổng không thỏa → chuyển tiếp bình thường và vẫn phát tín hiệu như H1.

**Ba bit trạng thái phía relay** (đây là toàn bộ đầu vào của cổng; record log ghi chúng trong trường `gate`):

| Bit | Nguồn | Cách đặt/xoá |
|---|---|---|
| `known` | kênh trạng thái | = 1 khi relay đã nhận **ít nhất một** `.hidden`/`.shown` (qua đẩy hoặc qua trả lời query). Trước đó = 0 → **fail-open**: không nuốt, chạy như H1 chỉ-đọc |
| `hidden` | kênh trạng thái | bit giữ trong process, lật theo notification gần nhất của host (`.hidden` → 1, `.shown` → 0) |
| `kb` | phiên bàn phím tại relay | = 1 trong phiên bàn phím. Đo bằng: observer `UIKeyboardWillShowNotification` / `UIKeyboardWillHideNotification` + quét khởi tạo chỉ tính frame bàn phím **đã dựng với `origin.y > 0`** (loại frame parked) |

Điều kiện nuốt: `known == 1 && hidden == 1 && kb == 0`.

Lịch sử của bit `kb` (quyết định thiết kế đã trả giá hai vòng): h1wake1 tính bằng `DF177KbComputeVisible()` — quét cửa sổ tìm `UIRemoteKeyboardWindow` không ẩn. Trong app được host, cửa sổ này **tồn tại thường trực** với frame dựng sẵn → kb luôn = 1 → cổng tự ngắt vĩnh viễn (QA178: 14/14 `swallowed=0`). h1wake2 thay bằng trạng thái phiên (WillShow/Hide + origin.y>0), h1wake3 giữ nguyên.

Lịch sử của bit `known`/`hidden`: ở 178/179 chúng do `DF188RefreshControlsHidden()` nạp từ key `ControlsHidden188` trong `/var/mobile/Library/Preferences/com.duoface.nativehost.qa177.plist` — file **ngoài sandbox của app App Store** → Known không bao giờ YES ở cả 4 app test → cổng không bao giờ đóng (QA179: 0/24 `swallowed=1`), trong khi `DF177AppTouchEnabled()` lại trả YES khi đọc hỏng (v=nil → YES) nên đường wake vẫn chạy — hai hàm đọc cùng một plist, xử lý lỗi ngược nhau. h1wake3 **loại hẳn** `DF188RefreshControlsHidden()` khỏi cổng: bit nạp từ Darwin như bảng trên.

**Bắt tay khi relay nạp muộn / mất đồng bộ**: relay post `com.duoface.controls188.query` → host post lại `.hidden` hoặc `.shown` theo trạng thái hiện tại → relay set `known=1`, `hidden` = trạng thái thật. Không có timeout/đoán: chưa có trả lời thì `known` vẫn 0 và cổng fail-open.

### 1.4 Một chu kỳ đầy đủ (dòng thời gian)

1. Controls đang hiện sau hoạt động cuối; `controlsUntil` hết → `layoutControls` suy ra ẩn → host post `.hidden` → mọi relay set `hidden=1`.
2. Người dùng chạm vào nội dung app. Relay (đã `known=1, hidden=1, kb=0`) nuốt trọn dãy, phát wake DF156 ngay (không chờ throttle).
3. Host nhận wake → tươi + không trùng → `noteUserActivity` → `controlsUntil = now + 4.0` → `layoutControls` → controls hiện → host post `.shown`.
4. Relay set `hidden=0`. Mọi chạm sau đi qua bình thường (`swallowed=0`) cho tới khi controls tự ẩn lại sau ~4 s → lặp lại từ bước 1.

### 1.5 Log chuẩn dùng để nghiệm thu (và chữ ký thất bại)

| Marker | Phía ghi | Nội dung | Dùng để |
|---|---|---|---|
| `qa177-app-touch` | relay → host | chạm quan sát được, bộ đếm cộng dồn, theo bundle | chứng minh hook thấy chạm (H1: 20 dòng, Maps + YouTube) |
| `qa177-recall` | host | chỉ ghi khi ẩn → hiện | đếm lần gọi lại thật (H1: 6 dòng) |
| `qa188-h1-controls-state` | host | `hidden=0/1` mỗi lần publish | chứng minh lớp phát trạng thái sống (178/179 đều lật đúng chu kỳ — lỗi không nằm ở đây) |
| `qa188-h1-app-touch-wake` | relay | mỗi dãy chạm: `swallowed=0/1`; h1wake3 thêm `gate=known/hidden/kb` | bằng chứng định lượng của cổng |

Số nghiệm thu đã khép: **QA180 — 12 `swallowed=1`** (Waze + Facebook, nhiều chu kỳ liên tiếp), **35 `swallowed=0`** (chạm thường khi đang hiện), `gate` cho thấy `known=1`; kèm verdict xe của Nguyen 06/11 20:47 «ĐÃ SỬA ĐƯỢC LỖI GỌI LOGO». Hai chữ ký thất bại để nhận diện khi áp sang hệ khác: (A) publish lật đúng mà `swallowed=0` toàn bộ với kb bị nghi — kiểm bit kb trước; (B) publish lật đúng mà `swallowed=0` toàn bộ và `known=0` — kênh nạp trạng thái phía app chết (sandbox), không phải lỗi cổng.

Tính ổn định của thiết kế: `DFAppTouch177.h` và `DFH1Wake188.m` được giữ **byte-identical** qua QA181 và QA182 (đã kiểm md5 trong hồ sơ) — QA180 là bản thành công gần nhất và thiết kế của nó đang là bản đứng, không bị sửa tiếp.

---

## 2. Bảng ánh xạ DuoFace → OmniCar

Trạng thái: **CÓ SẴN** = thành phần tương ứng đã tồn tại trong source phục hồi; **PHẢI THÊM** = đã rõ phải viết mới, điểm gắn đã xác định; **CHƯA RÕ** = chưa đủ bằng chứng, cần quyết định/đo thêm (mục 3, 4).

| # | Thành phần DuoFace | Tương ứng OmniCar (source đã phục hồi) | Trạng thái | Bằng chứng / ghi chú |
|---|---|---|---|---|
| 1 | Relay sống trong process app được host (DF154 phủ 14 app pilot + relay YouTube riêng; app ngoài phạm vi = không gọi lại được) | `ABInApp` trong `OmniCarAppBridge.dylib`: filter `{"Bundles": ["com.apple.UIKit"]}` nạp vào **mọi** process UIKit; ctor app (0x44A8) chạy trong mọi `.app` trừ 6 bundle loại trừ (SpringBoard, CarPlayApp, CarPlayTemplateUIHost, CarPlaySettings, InCallService, Preferences) | **CÓ SẴN — mạnh hơn DuoFace** | `project/OmniCarAppBridge/AppBridgeEntry.m`, `OmniCarAppBridge.plist`. Khoảng trống kiểu "app thứ ba không có relay" (GOFA ở DuoFace) **không tồn tại** ở OmniCar |
| 2 | Hook `-[UIApplication sendEvent:]` trong relay — điểm thấy + nuốt chạm duy nhất | **Không có.** `ABInApp.m` hook: CADisplayLink (3), `UIWindow._setRotatableViewOrientation`, UIDevice orientation (3), UITextField/UITextView become/resign first responder, `UIWindowScene.requestGeometryUpdate…`, VC rotation (2) — không hook nào ở đường sự kiện chạm | **PHẢI THÊM** | `project/OmniCarAppBridge/ABInApp.m` (toàn bộ danh sách cài trong `ABOrientationBlock`). Đây là ẩn số của bản đo ở mục 3 |
| 3 | Chủ trạng thái chrome: `DFNative12Chrome` (SpringBoard), một trạng thái toàn cục | `SCPCarSplit` (process **CarPlay**) giữ trạng thái bar **theo từng pane** (`pane.bar.isHidden`), cổng tổng hợp `anyBarVisible`/`popupOpen` | **CÓ SẴN** (khác process, khác độ mịn) | `project/OmniCarSplitScreen/SCPCarSplit+Chrome.m` |
| 4 | Điểm phát trạng thái khi đổi: swizzle `layoutControls` post `.hidden`/`.shown` | Chưa có gì phát cho phía app. Trạng thái bar hiện chỉ chảy CarPlay → SpringBoard trong payload frame (`hostBarInfoForPane:` → `bar = @(!pane.bar.isHidden)`) | **PHẢI THÊM** (điểm phát: mục 2.1) | `SCPCarSplit.m:2109` (`-hostBarInfoForPane:` @0x3cd60) |
| 5 | Kênh trạng thái: 3 tên Darwin (`…controls188.hidden/.shown/.query`), post thuần | Họ kênh `appbridge.*`: 14 tên NSDistributed (`com.anlai.omnicar/appbridge.*`, địa chỉ theo bundle) + đúng 2 tên Darwin (`appbridge.keyboard`, `appbridge.apporient`) theo thành ngữ **notify_set_state đóng gói** (bit trường + `FNV1a(bundle)<<24`). Chưa có kênh trạng thái controls nào | **PHẢI THÊM** (chọn vận chuyển: quyết định D2) | `project/OmniCarAppBridge/ABChannelNames.m`; `ABInApp.m` `ABKeyboardPublish`/`ABPublishAppOrientation` |
| 6 | Hỏi/đáp lấy trạng thái ban đầu (query → post lại) | Cả hai thành ngữ đều có sẵn trong cây: NSDistributed địa chỉ theo `object = bundleID` (kênh orientation/key, host→app) và Darwin `notify_get_state` đọc trạng thái hiện tại theo token | **CÓ SẴN** về cơ chế, **PHẢI THÊM** tên + logic | `ABInApp.m` `ABInstallInAppObservers`; `ABKeyboardPublish` (register_check/set_state) |
| 7 | Wake app → host: mailbox DF156 (Darwin + payload state `{bundle,count,ts}`, throttle 250 ms) | Phía app đã post Darwin về SpringBoard (apporient, keyboard). Nhưng **chủ bar ở process CarPlay** — tiền lệ vận chuyển tới CarPlay là NSDistributed: `SCPHooks.m` đăng ký observer `appbridge.handletap` trong CarPlay (`SCPBridgeHandleTapBlock`) | **CÓ SẴN** tiền lệ, **PHẢI THÊM** tên kênh + handler | `project/OmniCarSplitScreen/SCPHooks.m:480,767`; `SCPShared.m:23` |
| 8 | Handler wake → `noteUserActivity` (gia hạn cửa sổ hiện + layout lại) | Hiện bar = `-[SCPCarSplit setBarVisible:YES forPane:]` — bản thân nó đã **tự gắn timer tự ẩn 4,0 s** (`pane.barTimer`), tức "gia hạn khi wake" nằm sẵn trong đường hiện | **CÓ SẴN** điểm gọi, **PHẢI THÊM** handler phân giải bundle → pane | `SCPCarSplit+Chrome.m:314,329` |
| 9 | Tự ẩn sau ~4 s (`controlsUntil` + dọn 4,05 s) | `pane.barTimer` one-shot 4,0 s → `setBarVisible:NO forPane:` | **CÓ SẴN** (cùng hằng 4,0 s, theo pane thay vì toàn cục) | `SCPCarSplit+Chrome.m:329-333` |
| 10 | Bit `kb` phía relay: phiên bàn phím (WillShow/Hide + frame origin.y>0) | `ABInApp` **không** theo dõi thông báo bàn phím. Nó biết trạng thái soạn thảo qua hook first responder: `ABCurrentResponder` (weak) + `ABKeyboardPublish(shown…)` khi become/resign. Lưu ý ngữ nghĩa khác hẳn DuoFace: trong app được host, bàn phím hệ thống bị **bịt** (inputView rỗng CGRectZero — `ABSuppressSystemKeyboard`), bàn phím người dùng thấy là panel phía SpringBoard (`ABKeyboard`) | **CHƯA RÕ** | `ABInApp.m` `ABSuppressSystemKeyboard`, `ABResponderBecame/Resigned`, `ABKeyboardPublish`. Ba ứng viên tín hiệu kb: quyết định D3 |
| 11 | Fail-open khi `known=0` | Chưa có cổng nên chưa có luật này | **PHẢI THÊM** (luật thiết kế, mang nguyên sang) | Mục 1.3 |
| 12 | Kill-switch `AppTouchRecall177` (plist, vắng = bật, đọc hỏng = bật) | Hệ prefs OmniCar có sẵn (domain `com.anlai.omnicar`), nhưng bài học QA179 cấm phụ thuộc vào việc app App Store đọc được plist chia sẻ — switch phía app phải hoặc fail-open khi đọc hỏng (như DuoFace) hoặc được chở trong chính kênh trạng thái | **CHƯA RÕ** | Quyết định D4 |
| 13 | Hạ tầng log nghiệm thu (`qa177-*`, `qa188-*`) | `OMCLogWrite` chạy được trong process app (đã có dòng thật trong OmniCar.log: `huong o …`, `bao SpringBoard: …`, `ban phim xe: …` kèm tag `[App:pid]`); phía SplitScreen/SB đã có mẫu log `[do]` cho instrumentation ngoài bản gốc (`cham thanh`, `bridge handletap`, `closePopups`) | **CÓ SẴN** hạ tầng, **PHẢI THÊM** marker theo mục 3 | `ABInApp.m` (các `OMCLogWrite(@"AppBridge", …)`); `SCPHooks.m:485` |

### 2.1 Điểm tương đương `layoutControls` trong OmniCar — phân tích ứng viên

Luật rút từ DuoFace (điều kiện tiên quyết 3): **chỉ phát trạng thái từ điểm duy nhất vừa quyết định vừa áp trạng thái**, để bit phía relay không bao giờ lệch pha với hình thật.

**Ứng viên A — CHÍNH: `-[SCPCarSplit setBarVisible:forPane:]`** (`SCPCarSplit+Chrome.m:314`, gốc @0x241fc, process CarPlay).
Bằng chứng nó là phễu duy nhất: trong toàn module SplitScreen, các phép gán trực tiếp lên `pane.bar.hidden` sau khi bar được sinh ra **chỉ nằm trong hàm này** — nhánh hiện gán `hidden = NO` (dòng 324), nhánh ẩn gán `hidden = YES` trong completion của fade 0,18 s (dòng 349); phép gán còn lại duy nhất là trạng thái sinh trong `setupBarForPane:` (dòng 240). Mọi tác nhân khác đều gọi vào nó: toggle từ handle `bridgeHandleTapped:` (`SCPCarSplit.m:2506`), chính timer tự ẩn 4,0 s (khối timer gọi lại nó với NO, `SCPCarSplit+Chrome.m:329`), `hideBarsForTouchOn:`/`closePopups` (Chrome.m:374, 409), Divider (122, 377), Drag (91), Panel (159), `SCPCarSplit.m` (2474, 3348, 3374, 3396). Phát tại hàm này = bắt 100% chuyển trạng thái kể cả lần ẩn do timer — đúng tính chất của `layoutControls`.
Chi tiết thiết kế phải xử lý: nhánh ẩn là **bất đồng bộ** (hidden=YES chỉ落地 trong completion sau 0,18 s). DuoFace phát theo *quyết định* tại thời điểm layout, không chờ hoạt ảnh xong → phát tại thời điểm gọi (decision-time) là khớp tiền lệ; phát trong completion là lựa chọn khác phải nêu cho GPT (D2).

**Ứng viên B — LOẠI làm nguồn phát (giữ làm đối chứng): `-[ABHost setBarVisible:pop:dim:single:forApp:]`** (`ABHostBMethods.m:1086`, gốc @0x11868, process SpringBoard). Đây là **bản gương**: nó áp trạng thái *nhận được* từ `hostBarInfoForPane:` qua các lần đẩy frame. Phát ở đây = phát từ bản sao, theo nhịp đẩy frame, lại trộn thêm chiều pop/dim/single không thuộc trạng thái ẩn/hiện thuần. Đúng vai trò của nó trong thiết kế: dòng log đối chứng để kiểm tra trạng thái phát đi và trạng thái gương có khớp nhau không.

**Ứng viên C — LOẠI: `bridgeHandleTapped:`** (`SCPCarSplit.m:2490`, @0x3f65c). Chỉ là lối vào toggle của handle; bỏ sót ẩn do timer, ẩn do `closePopups`, ẩn do kéo divider → bit phía app sẽ lệch pha đúng kiểu lỗi DuoFace đã trả giá.

**Khác biệt cấu trúc phải tôn trọng** (không phải thiếu sót): (i) trạng thái là **theo pane/bundle**, không toàn cục — mỗi app chỉ được biết bit của pane chứa nó, nên kênh trạng thái bắt buộc có địa chỉ/định danh theo bundle; (ii) hiện một bar sẽ **ẩn các bar còn lại** (trong `setBarVisible:` nhánh hiện) → một lần wake kéo theo hai lần chuyển trạng thái ở hai pane khác nhau, cả hai đều phải được phát; (iii) chủ trạng thái ở CarPlay, gương ở SpringBoard, người tiêu thụ ở app — ba process; vận chuyển trực tiếp CarPlay → app (NSDistributed/Darwin đều xuyên process) tránh thêm một chặng qua SpringBoard; (iv) đích của wake là bar "•••" của pane (+ accent của handle) — handle vốn luôn hiện (nó là đích chạm của `handletap`), nên "gọi lại bằng chạm nội dung" là hành vi **mới** trên OmniCar: hiện nay chạm nội dung của pane hosted không tới được logic chrome nào (chạm nội dung phía CarPlay chỉ có đường `SCPCarSplitView.touched` → `hideBarsForTouchOn:` cho view thuộc process CarPlay); (v) ngữ nghĩa double-tap 0,35 s → zoom nằm trên đường handle (`bridgeHandleTapped:`), tách biệt với đường chạm nội dung — cổng nuốt phía app không được đụng vào dãy chạm trên handle (handle thuộc SpringBoard/CarPlay, không qua app — tự nó đã tách).

---

## 3. Kế hoạch bản đo chỉ-đọc (probe) — quyết ẩn số duy nhất còn lại

**Ẩn số:** hook `-[UIApplication sendEvent:]` đặt trong process app được host của OmniCar có (a) *thấy* trọn dãy chạm nội dung khi phiên CarPlay đang chạy, và (b) đứng ở điểm nghẹn mà việc không gọi IMP gốc sẽ dập được dãy chạm đó hay không.
**Vì sao chưa ai trả lời được:** các cổng của saga pinch đặt ở phía CarPlay/SpringBoard và dylib cộng thêm — hồ sơ cho thấy chạm trên pane hosted đi đường scene và không qua các cổng đó (cùng ngõ cụt DuoFace đã chết ở QA176 phía SpringBoard). Chưa từng có bản OmniCar nào hook `sendEvent:` **trong chính process app**. (Mức chắc chắn: theo hồ sơ dự án hiện có.)

### 3.1 Thiết kế probe

- **Vị trí gắn:** `ABInApp.m` — thêm một orig slot + hàm thay thế cho `-[UIApplication sendEvent:]`, cài trong `ABOrientationBlock` cạnh 14 hook hiện có (chung điểm cài lười: hook chỉ tồn tại khi app thật sự được host, có sẵn ngữ cảnh `ABForcedOrientation`). Không cài ở ctor (ctor chạy trong mọi app kể cả không được host → nhiễu + rủi ro ngoài ngữ cảnh).
- **Hành vi:** luôn gọi IMP gốc **trước** như dạng H1 của DuoFace; không bao giờ giữ lại sự kiện. Theo dõi `event.allTouches`: Began mở một bản ghi dãy (số thứ tự, t0), Ended/Cancelled đóng dãy.
- **Log** (qua `OMCLogWrite(@"AppBridge", …)` — đã chứng minh vào được OmniCar.log với tag process; tiền tố `[do]` theo quy ước instrumentation không thuộc bản gốc của các vòng trước):
  - lúc cài: `[do] probe sendEvent: da cai (hosted=%d)`;
  - mỗi dãy đóng: `[do] probe sendEvent: seq=%lld phases B=%lu M=%lu E=%lu C=%lu dur=%.2fs hosted=%d kb=%d` (`kb` = `ABCurrentResponder != nil` — đồng thời trả lời phụ cho D3: ghi thêm một dòng mỗi khi có `UIKeyboardWillShow/Hide` bắn trong process nếu đăng ký observer chỉ-để-nghe trong cùng bản đo);
  - chống ngập log: tối đa 200 dãy/app-launch, sau đó chuyển sang dòng tổng kết mỗi 30 s (đếm dãy/pha).
- **Đối chứng thời gian:** Began của dãy đầu tiên trong mỗi app được log thêm dòng riêng kèm timestamp — cùng file log, cùng đồng hồ với các dòng `cham thanh`/`bridge handletap` phía host, nên thứ tự tương đối kiểm được.

### 3.2 Kịch bản một phiên (gộp, ~10 phút, một lần up log)

1. Cài bản probe (candidate như các vòng fixround, chỉ khác ở instrumentation này, marker `[do]`).
2. Kết nối CarPlay → host app A (YouTube): chờ > 4 s cho bar tự ẩn → chạm nội dung 5 lần, cách nhau ~1 s → chạm handle một lần (dòng `cham thanh` làm mốc đối chứng).
3. Host app B (Facebook/TikTok): lặp lại 5 lần chạm nội dung khi bar ẩn.
4. Trong B: mở một trường nhập → panel bàn phím xe hiện → 3 chạm nội dung + quan sát WillShow/Hide có bắn trong process không.
5. Một lần zoom solo bằng double-tap handle (đối chứng đường handle không bị probe ảnh hưởng).
6. Ngắt kết nối, up `OmniCar.log` một lần.

### 3.3 Tiêu chí

**PASS:**
- P1 (thấy): mỗi app ≥ 5 dãy đóng hoàn chỉnh ứng với 5 chạm nội dung chủ đích, mỗi dãy có B ≥ 1 và (E + C) ≥ 1, `hosted=1`, dur < 2 s.
- P2 (đúng loại chạm): các dãy ở bước 2–3 xuất hiện **không** kèm dòng `handletap` (phân biệt được chạm nội dung với chạm handle).
- P3 (điểm nghẹn — bằng chứng hỗ trợ): timestamp Began của probe đứng **trước** phản ứng quan sát được của app với cùng cú chạm (ví dụ dòng `bao SpringBoard:` hoặc `ban phim xe:` mà cú chạm đó gây ra, khi có).
- Về khả năng *dập*: probe chỉ-đọc **không thể** tự chứng minh việc nuốt — điều này phải nói thẳng. Khả năng dập được suy từ cấu trúc + tiền lệ: cùng selector, cùng dạng hook thay thế MSHookMessageEx, cùng cơ chế "không gọi orig = app không nhận dãy" đã chạy trên xe ở QA180. Probe chứng minh hai điều kiện cần mà OmniCar chưa từng có số: hook *thấy đủ* và hook *đứng trước* đường phân phối trong đúng điều kiện phiên CarPlay đang chạy.

**FAIL:**
- F1: chạm nội dung khi phiên đang chạy cho **0 dãy** → sự kiện vòng qua `UIApplication` trong đường route theo scene của OmniCar → hướng chuyển cổng chết tại điểm này, quay lại GPT.
- F2: dãy cụt hàng loạt (có Began, không Ended/Cancelled) → hook thấy dòng đã lọc; thiết kế cổng phải nghĩ lại.
- F3: hook chỉ bắn khi **không** được host (`hosted=0` có dãy, `hosted=1` không) → khác biệt route là thật trên OmniCar, cùng kết luận như F1.

Sau verdict: nếu PASS, probe chính là bộ khung của cổng (như H1 thành h1wake1 ở DuoFace) — giữ lại và gắn cổng ở vòng sau; nếu FAIL, gỡ probe, không để lại instrumentation vô chủ.

---

## 4. Các quyết định treo cho GPT (khớp Q1–Q3 của bản tham vấn, thêm D4)

**D1 — Thứ tự triển khai (= Q1).**
- (a) *Probe trước, cổng sau* (thứ tự đã thắng ở DuoFace: H1 chỉ-đọc QA177 → cổng h1wake1): tốn thêm một vòng build + một phiên xe, nhưng cổng không bao giờ được xây trên điểm nghẹn chưa có số.
- (b) *Xây cổng luôn* (fail-open như thiết kế DuoFace): nếu điểm nghẹn chết, chữ ký thất bại sẽ lẫn với lỗi cổng/kênh — đúng mô thức đã đốt hai vòng QA178/QA179 cho các ẩn số mà một bản đo sẽ tách ra được từ đầu.

**D2 — Vận chuyển trạng thái + thời điểm phát (= Q2).** Chủ trạng thái đã cố định bởi bằng chứng: `-[SCPCarSplit setBarVisible:forPane:]` (mục 2.1). Còn phải chọn:
- (a) *Bộ ba Darwin kiểu DuoFace* (`…appbridge.controls.hidden/.shown/.query`): post là broadcast toàn hệ → định danh theo bundle phải chở trong notify state (đóng gói hash như apporient/keyboard — thành ngữ sẵn của OmniCar) và mọi app tự lọc. Query/response giữ nguyên dạng DuoFace.
- (b) *NSDistributed địa chỉ theo bundle* (`object = bundleID`, tiền lệ kênh orientation/key): chỉ app được địa chỉ mới thức; payload mang `{hidden}` trực tiếp; trạng thái ban đầu qua một tên query do phía CarPlay (hoặc SB) trả lời. Khác DuoFace ở transport nhưng khớp thành ngữ địa chỉ của chính OmniCar.
- (c) *Một tên Darwin + `notify_get_state` để app tự đọc khi cần* (lúc nạp, lúc chạm): bỏ được query/response; nhưng ô state là theo-tên toàn cục — nhiều pane phải đóng gói nhiều bit + hash vào một uint64, vướng pane nổi; đơn giản cho một app, khó mở rộng.
- Tiểu quyết định đi kèm: phát tại **thời điểm quyết định** (khi `setBarVisible:` được gọi — khớp tiền lệ DuoFace) hay tại **thời điểm hoàn tất** (riêng nhánh ẩn: trong completion sau fade 0,18 s — bit phía app trễ hơn hình thật tối đa 0,18 s nhưng không bao giờ đi trước hình).

**D3 — Tín hiệu `kb` phía app (= Q3).**
- (a) *Observer phiên bàn phím trong ABInApp* (WillShow/Hide + quét frame origin.y>0 — nguyên dạng bản đạt DuoFace): thêm bề mặt mới; câu hỏi mở: trong app được host, bàn phím hệ thống đã bị bịt bằng inputView rỗng — WillShow/Hide **có bắn trong process không**? Bản đo ở mục 3 trả lời phụ được câu này trong cùng một phiên.
- (b) *Dựa trên first responder sẵn có*: `kb := (ABCurrentResponder != nil)` — không thêm observer nào; ngữ nghĩa: đang có trường soạn thảo được focus = phiên kb. Lệch so với (a): responder được dọn khi resign (kể cả resign do `appbridge.key` action "dismiss") nên hai tín hiệu hội tụ ở hầu hết đường đi; trường hợp field còn focus mà panel đã ẩn bằng đường khác sẽ chặn wake thừa (lệch về phía an toàn: bớt nuốt, không bao giờ ăn mất chạm gõ).
- (c) *Phía host gấp bit kb vào trạng thái phát đi*: ABKeyboard (SpringBoard) biết panel có đang hiện; nhưng chủ trạng thái bar ở CarPlay → bit kb phải đi một chặng SB → CarPlay hoặc SB phát riêng cho app — thêm một nguồn phát thứ hai, phá tính "một điểm phát duy nhất" của mục 2.1 trừ khi SB chỉ *cung* bit cho CarPlay.

**D4 — Nguồn kill-switch / cờ bật-tắt đọc được từ trong sandbox app (phát sinh từ ánh xạ #12).**
- (a) Đọc pref với fail-open khi đọc hỏng (mẫu `DF177AppTouchEnabled()`): đơn giản, nhưng một app đọc *được* pref ở hệ khác có thể tắt cổng ngoài ý muốn điều hành.
- (b) Cờ chở trong chính kênh trạng thái (host phát kèm): một nguồn sự thật duy nhất, app không tự đọc gì; đổi lại muốn tắt nóng phải qua đường phát của host.

---

## 5. Tóm tắt một đoạn (để trích vào bản tham vấn)

QA180 thắng vì bốn quyết định đúng cùng lúc: điểm nuốt nằm **trong process app** (hook `sendEvent:`), trạng thái do **một chủ duy nhất** phát **tại điểm quyết định layout**, kênh trạng thái **xuyên được sandbox** (Darwin đẩy + hỏi/đáp thay plist), và cổng **fail-open trên ba bit** `known/hidden/kb` với `kb` đo bằng phiên thay vì quét cửa sổ. OmniCar đã có sẵn: relay trong mọi app (mạnh hơn phạm vi pilot của DuoFace), điểm quyết định duy nhất tương đương `layoutControls` (`-[SCPCarSplit setBarVisible:forPane:]`, phễu 100% kể cả timer), timer tự ẩn cùng hằng 4,0 s, và cả hai thành ngữ vận chuyển (Darwin đóng gói state + NSDistributed địa chỉ theo bundle). OmniCar còn thiếu: hook `sendEvent:` (chưa từng được thử trong process app — bản đo chỉ-đọc ở mục 3 quyết định nó), kênh trạng thái controls, handler wake, và tín hiệu `kb` phía app. Bốn quyết định D1–D4 là phần cần GPT phán quyết trước khi viết bất kỳ dòng code nào.
