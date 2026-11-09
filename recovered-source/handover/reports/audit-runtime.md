# GATE 0 — AUDIT RUNTIME cho WO "OMNICAR BRIDGE WAKE QA180 PORT"

Chỉ-đọc; không sửa/build/git. Cây source đã đọc: `~/workspace/omnicar-re/project/`
(bản build; mirror của `recovered-source/` trên repo). Binary gốc lấy từ DEB đầu vào
`~/workspace/omnicar-re/input/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` (SHA `d9297b01…`).
Log xe: `work/device-log-20261109-fixround5/session.txt` + `...-fixround6/session.txt`.
Mọi khẳng định kèm file:line hoặc offset.

## 1. Kiểm kê dylib

### 1a. Trong DEB rebuilt (fixround6 và fixround7 — tập file Giống hệt nhau, đo bằng `ar`/`tar tf`)
| Thành phần thực thi | Filter (Bundles) → process đích |
|---|---|
| `OmniCarAppBridge.dylib` | `com.apple.UIKit` → **mọi process UIKit** |
| `OmniCarCore.dylib` | `com.apple.springboard` |
| `OmniCarSplitScreen.dylib` | `com.apple.CarPlayApp`, `com.apple.springboard` |
| `OmniCarStartupScreen.dylib` | `com.apple.CarPlayApp`, `com.apple.springboard` |
| `OmniCarCarProbe.dylib` | `com.apple.CarPlayApp` |
| `OmniCarSpeedBubble.dylib` | springboard, CarPlayApp, `vn.vietmap.live`, `com.lumi.GOFA`, `com.waze.iphone`, `com.wynauto.wyn` |
| `OmniCarPrefs.bundle/OmniCarPrefs` | PreferenceBundle (process Preferences) |
| `OmniCar.app/OmniCar` | app thực thi |

**Không có dylib QA19/QA20 nào trong cả hai DEB rebuilt.**

### 1b. Hai add-on cũ trên repo (đọc từ source, `~/workspace/push9-clone/`)
- **QA19 → `OmniCarYouTubeHandleIdle.dylib`** (Makefile `TWEAK_NAME := OmniCarYouTubeHandleIdle`),
  filter `Bundles = ( "com.apple.UIKit" )` → nạp vào **mọi process UIKit**.
  - Hook `UIApplication sendEvent:` (nhóm OMCYTAppProcessTouchRelay): **`%orig;` chạy TRƯỚC**
    (xm, đầu thân hook), sau đó nếu có touch Began thì `OMCYTWakeAll(@"app-process-touch")`.
    **Không có cổng nuốt nào** — xác minh đúng như WO mô tả. Relay cài ở mọi process UIKit trừ
    springboard/carplayapp/backboardd/uikit/webkit/*.xpc (hàm `OMCYTShouldObserveAppTouches`).
  - Hook phía SpringBoard: `ABHost setHandleVisible:forPane:` + `layoutBarForPane:` — tự quản trạng
    thái riêng cho pane YouTube: **timer NSTimer 4,0 s riêng** (`kOMCYTIdleSeconds`), ẩn bằng
    `layer.opacity` của ABPane handle/handleHit (không đụng hidden/alpha/userInteractionEnabled),
    recognizer quan sát thụ động gắn lên box + handleHit.
  - Kênh Darwin chung: **`com.anlai.omnicar.qa19.controls.activity`** (CFNotificationCenter Darwin,
    DeliverImmediately; phát có throttle 0,12 s; nhận → wake, không phát lại từ đường nhận).
- **QA20 → `OmniCarNativeSoloTimer.dylib`** (Makefile `TWEAK_NAME := OmniCarNativeSoloTimer`),
  filter `Bundles = ( "com.apple.CarPlayApp", "com.apple.springboard" )`.
  - Hook `SCPCarSplit` (rootDidLayout/setActive:/layoutBarForPane:/handleTapped:/dividerTapped:) và
    `SCPCarSplitView hitTest:withEvent:` — `%orig` trước, trả nguyên target; Began khớp window →
    shared activity. **Timer 4,0 s riêng theo split** (`kOMCNativeIdleSeconds`); ẩn bằng
    `layer.opacity` của pane.handle + divider + **divider.knob**.
  - Dùng **cùng kênh Darwin `com.anlai.omnicar.qa19.controls.activity`** (phát throttle 0,12 s;
    nhận → wake với publish=NO). %ctor chỉ chạy khi bundle là CarPlayApp/SpringBoard.
- **Hệ quả xếp chồng:** nếu hai gói add-on còn cài trên máy, QA19 nạp vào mọi process UIKit và hook
  ABHost (SpringBoard) + UIApplication sendEvent (mọi app); QA20 hook SCPCarSplit/SCPCarSplitView —
  tức hook chồng lên **chính các class mà bản rebuilt định nghĩa**. Trước khi gắn hook wake mới phải
  chốt trạng thái cài đặt của chúng trên thiết bị (xem Q1 ở mục 6).

### 1c. Log xe hai phiên RE (fixround5 + fixround6)
- Module thực sự nạp: AppBridge, SplitScreen, SpeedBubble, Core (SpringBoard); thêm CarProbe
  (CarPlay); SpeedBubble nạp vào cả app hosted (GOFA, Waze). Phần in-app của AppBridge hoạt động
  trong process YouTube: `11:20:45.460 [YouTube:32251] AppBridge: com.google.ios.youtube: dua len xe, cai hook`.
- `grep -ci "qa19|qa20|YouTubeHandle|NativeSoloTimer|HandleIdle"` trên cả hai session.txt = **0**.
  Các tag log riêng của QA19/QA20 (`[OmniCarYTHandleIdleQA19]`, `[OmniCarUnifiedWakeQA19/QA20]`,
  `[OmniCarNativeSoloTimer]`) đều chứa các chuỗi trên → **trong hai phiên RE, add-on QA19/QA20
  không hoạt động**. (Không hoạt động ≠ đã gỡ — xem Q1.)

## 2. Sáu vị trí source đã đọc

**ABInApp.m** (585 dòng, `OmniCarAppBridge/`):
- Entry phía app: `ABInstallInAppObservers` (dòng 239) do ctor gọi; chỉ đăng ký **hai** observer
  NSDistributed: `ABChanOrientation` → `ABOrientationBlock` (84), `ABChanKey` → `ABKeyBlock` (206).
- Hook được cài **lười** ngay trong `ABOrientationBlock` ở thông báo hướng đầu tiên (86–147):
  CADisplayLink ×3, `UIWindow _setRotatableViewOrientation:duration:force:`, UIDevice
  beginGen/setOrientation:/orientation, UITextField/UITextView become/resignFirstResponder,
  UIWindowScene requestGeometryUpdate (nếu có), VC setNeedsUpdate/attemptRotation.
- **KHÔNG có hook `sendEvent:`** — `grep sendEvent` trên toàn module OmniCarAppBridge = 0 kết quả.
  Điểm chạm duy nhất của bản rebuilt trong process app hiện tại là các hook trên; không có điểm
  quan sát touch nào.
- First responder: `__weak id ABCurrentResponder` (50); `ABResponderBecame` (298) /
  `ABResponderResigned` (305) do hook become/resign của TF/TV gọi.
- Keyboard publisher: `ABKeyboardPublish` (343) → Darwin `ABNotifyKeyboard` bằng
  notify_register_check/set_state/post, state đóng gói: bit0 shown | keyboardType<<1 |
  returnKeyType<<8 | băm bundle<<24. (Kênh app→host có sẵn, đúng thành ngữ đóng gói số.)
- Orientation publisher: `ABPublishAppOrientation` (sub_67fc) + debounce
  `ABScheduleAppOrientationPublish` (sub_6750, 0,25 s) — giữ nguyên theo WO §VIII.

**AppBridgeEntry.m** (99 dòng): filter `com.apple.UIKit` (mọi process UIKit). `ABAppCtor`: vai app
hosted cho mọi bundle `.app` **trừ 6 bundle loại trừ** (springboard, CarPlayApp,
CarPlayTemplateUIHost, CarPlaySettings, InCallService, Preferences). `ABHostCtor`: chỉ SpringBoard.
Hệ quả: **process CarPlayApp không chạy máy in-app nào của AppBridge** (bị loại khỏi vai app, vai
host chỉ dành SpringBoard).

**ABHostBMethods.m** (`OmniCarAppBridge/`, 1564 dòng):
- `buildBarForPane:` (992; bar sinh alpha 0), `layoutBarForPane:` (1062),
  `setBarVisible:pop:dim:single:forApp:` (1086; guard `bar.isHidden == visible` @0x11ab8 + alpha=1
  ở entrance — C-A/C-B đã khôi phục), `hideBarForPane:` (1124).
- `setupHandleForPane:` (1151): handleHit 44×24 (recognizer tap→`handleTapped:`, pan→
  `handlePanned:`), pill handle 34×12 bên trong (userInteractionEnabled=NO).
  `setHandleVisible:forPane:` (1184): `handleHit.hidden = !visible` + căn giữa + đưa lên trước.
- `handleTapped:` (845): log "cham thanh •••" + post `ABChanHandleTap` {identifier} (NSDistributed).
  `handlePanned:` (820): post `ABChanHandleDrag`. `outsideTouched` (807): ẩn bar mọi pane.
- `setFrame:forApp:…handle:…` (599): dòng 606 `[self setHandleVisible:(handle && !collapsed)
  forPane:pane]` — hiển thị handle phía host **nô lệ theo cờ handle của từng frame** phía CarPlay.
- `setKnobs:` (1224): spec[2]=active → transform 1.6×/identity + accent (1294–1314);
  `raiseKnobs` (1192); `ensureWindow` (910; windowLevel = StatusBar + 60,0 tại 949);
  `teardownPane:` (1331); `sceneMonitor:sceneWasDestroyed:` (860).

**SCPCarSplit.m** (3411 dòng): `allPanes` (345); `hostedPanes` (2138, lọc `SCPVCIsHosted(pane.vc)`);
`hostFrameInfo:` (2022) gộp `hostBarInfoForPane:` (2038); `hostBarInfoForPane:` (2103):
`bar = !pane.bar.isHidden`, pop, popDim, single; `bridgeHandleTapped:` (2490): chạm đơn →
`setBarVisible:pane.bar.isHidden` (toggle), chạm đôi <0,35 s → zoom/float; `bridgeBarAction:`
(2468); `publishBusy` (Darwin `com.anlai.omnicar/car.busy`, notify_set_state — tiền lệ đóng gói
trạng thái sẵn có); `publishKnobsSoon` (2585, coalesce bằng dispatch_async) → `publishKnobsNow`
(2603, xem mục 4).

**SCPCarSplit+Chrome.m** (505 dòng):
- `setupBarForPane:` (~161): tạo pane.handle (pill 34×12, 3 chấm; tap/double-tap/pan →
  handleTapped:/handleDoubleTapped:/handlePanned:) và pane.bar (52 pt, 5 nút; **bar.hidden = YES
  lúc sinh**).
- `layoutBarForPane:` (256): dòng 259 `pane.handle.hidden = (pane.vc == nil)` — handle native chỉ
  ẩn khi pane mất VC.
- **`setBarVisible:forPane:` (313) là điểm đổi trạng thái bar DUY NHẤT**: hiện → ẩn bar các pane
  khác, layout, bỏ ẩn, `SCPApplyAccent(handle, YES)`, gài **pane.barTimer 4,0 s** (329) tự ẩn;
  ẩn → accent off, fade 0,18 s, completion đặt hidden=YES + alpha=1 + khôi phục transform +
  pushHostFramesLive:NO.
- Timer trong module: **ba timer 4,0 s độc lập** — pane.barTimer (Chrome 329), trayTimer
  (Picker.m:984), ratioTimer (RatioMenu.m:457). **Không có timer idle toàn cục cho controls và
  không có biến trạng thái controlsVisible ở bất cứ đâu trong project** (grep = 0). Handle native
  và knob **không có cơ chế tự ẩn theo idle nào** trong các vị trí đã đọc + grep timer/opacity
  toàn module; bar là control duy nhất tự ẩn.

## 3. Bản đồ 5 đối tượng (không gộp)

| Đối tượng | Process | Ai tạo | Ai ẩn/hiện; biến quyết định |
|---|---|---|---|
| `SCPCarPane.handle` (pill "…") | CarPlay (SCPCarSplit) | `setupBarForPane:` Chrome ~165 | hidden = (vc==nil) tại `layoutBarForPane:` Chrome 259; accent bởi `setBarVisible:forPane:` qua SCPApplyAccent; chạm → `handleTapped:` Zoom.m:63 (toggle bar) |
| `ABPane.handle` + `ABPane.handleHit` | SpringBoard (ABHost) | `setupHandleForPane:` BMethods 1151 (hit 44×24 chứa pill 34×12) | `handleHit.hidden` bởi `setHandleVisible:forPane:` BMethods 1184, dẫn bởi cờ handle của frame (BMethods 606) + setup; accent bởi host `setBarVisible:` (1104); chạm hit → `handleTapped:` BMethods 845 |
| `SCPCarDividerView.knob` | CarPlay | con của divider; `layoutKnobOf:` Layout.m:574 | active (scale 1.6×/accent) bởi `SCPSetKnobActive` DividerView.m ~48 theo chạm divider; ẩn khi knob.isHidden/divider alpha<0.5 (bị publishKnobsNow bỏ qua); hit-test phình 26 pt (DividerView @0xf174) |
| `SCPCarPane.bar` (menu) | CarPlay | `setupBarForPane:` Chrome ~245, sinh hidden=YES | `pane.bar.isHidden` — đổi **chỉ** qua `setBarVisible:forPane:` Chrome 313 + barTimer của chính nó; là dữ kiện 'bar' duy nhất hostBarInfo xuất sang host |
| `ABKnobView` (mirror) | SpringBoard (ABHost) | `setKnobs:` BMethods 1240 (đĩa 66×66 + chấm 14×14, subview trực tiếp của AB window) | không có trạng thái ẩn riêng: có mặt trong mảng spec = hiện; center/active lấy thẳng từ spec[0..2]; bringSubviewToFront mỗi reconcile + `raiseKnobs` 1192 |

**Tập "controls thuộc phạm vi điều phối" cho wake** (kết luận Gate 0):
- Phía hosted (SpringBoard): ABPane.handleHit (hiện/ẩn), ABPane.bar (gương của bar phía CarPlay),
  ABKnobView (hiện diện + active).
- Phía native (CarPlay): SCPCarPane.handle, SCPCarPane.bar, SCPCarDividerView.knob.
- Dữ kiện hiển thị liên-process **duy nhất đang tồn tại** là `hostBarInfo['bar']` (một BOOL về menu).
  Không tồn tại trạng thái "toàn bộ controls đang ẩn" ở bất cứ đâu — chủ trạng thái theo WO §II là
  thành phần **phải tạo mới**, và mỗi đối tượng trên có nguồn sự thật riêng như bảng đã ghi;
  `pane.bar.isHidden` một mình không đại diện được cho bất kỳ phía nào.

## 4. Xác minh lại publishKnobsNow trên hai slice GỐC (dump mới trong audit này)

Từ DEB đầu vào, thin `OmniCarSplitScreen.dylib`, disasm vùng publishKnobsNow:
- **arm64:** `bl _CGAffineTransformIsIdentity` @0x3efb4 → `mov x27, x0` @0x3efb8 →
  **`eor w2, w27, #0x1` @0x3eff8** → stub numberWithBool: @0x3effc → phần tử thứ 3 của mảng.
  Payload = **!IsIdentity**.
- **arm64e:** `bl _CGAffineTransformIsIdentity` @0x41368 → `mov x27, x0` @0x4136c →
  **`eor w2, w27, #0x1` @0x413ac** → stub numberWithBool: @0x413b0. Payload = **!IsIdentity**.
- Source hiện tại (`SCPCarSplit.m:2616–2617`): `scaled = !CGAffineTransformIsIdentity(...)` rồi
  phát `@(!scaled)` = IsIdentity. **KHÔNG khớp trên cả hai slice** — source đảo cực so với gốc;
  cơ sở sửa của WO §VII được xác nhận độc lập: payload đúng là `scaled` (= !IsIdentity).
  Phía tiêu thụ: ABHost `setKnobs:` lấy spec[2] làm active → 1.6× (BMethods 1294).

## 5. Điểm phát trạng thái ứng viên + cách ABHost xác nhận chrome hosted

**Mọi điểm trạng thái hiển thị THỰC SỰ đổi (phía CarPlay):**
- `setBarVisible:forPane:` (Chrome 313) — bar + accent của handle, cả hai chiều, cộng tự ẩn qua
  barTimer. Được gọi từ: `handleTapped:` (Zoom.m:63), `bridgeHandleTapped:` (SCPCarSplit.m:2490),
  `hideBarsForTouchOn:`/`closePopups` (Chrome), các nút hành động của pane, `bridgeBarAction:`
  nhánh "replace" (SCPCarSplit.m:2468).
- `layoutBarForPane:` (Chrome 256) — `handle.hidden = (vc == nil)`: đổi theo **gán pane**, không
  theo idle.
- `SCPSetKnobActive` (DividerView.m ~48) — transform của knob, theo chạm divider.
- `setupBarForPane:`/teardown — sinh/chết của chrome.

**Điểm tương đương `layoutControls` của DuoFace:** `setBarVisible:forPane:` là điểm duy nhất mà
một control nhìn thấy được đổi trạng thái do tương tác/idle — nhưng nó **theo từng pane và chỉ
phạm vi bar**. Không tồn tại một điểm duy nhất bao quát handle + knob + bar; một điểm phát trạng
thái wake (nếu làm) phải là điểm tổng hợp MỚI đặt tại các điểm trên cộng với thay đổi membership
của pane trong SCPCarSplit — đây là việc của strand thiết kế, Gate 0 chỉ khẳng định không có sẵn.

**ABHost xác nhận chrome hosted bằng dữ kiện nào:** ABHost **không tự sinh** trạng thái chrome;
nó áp các dữ kiện phía CarPlay cấp theo từng frame:
- cờ `handle` trong hostFrameInfo → `setFrame:…handle:` → `setHandleVisible:(handle && !collapsed)`
  (BMethods 606): handleHit hiện/ẩn nô lệ theo quyết định từng frame của CarPlay.
- `hostBarInfo['bar']` → host `setBarVisible:pop:dim:single:forApp:` (BMethods 1086) áp lên frame
  push (pushHostFramesLive).
- mảng spec knobs → `setKnobs:` (BMethods 1224).
Vì vậy "xác nhận phía SpringBoard" theo nghĩa WO §II chỉ có thể đọc từ các giá trị đã áp:
`handleHit.hidden`, `bar.isHidden`, số lượng knobViews — không có kênh báo cáo ngược nào khác.

## 6. Tranh chấp bằng chứng sendEvent (bản 44 của saga pinch vs DuoFace QA180)

**Khẳng định cần phân định** (từ `work/fix-round6/study-pinch-fullscreen.md` mục 2.1): "chạm trên
ô hosted KHÔNG đi qua `-[UIApplication sendEvent:]` của process app — trong một phiên split đang
sống, relay trong app chỉ nhận đúng 1 bản ghi chạm, ngay lúc teardown". Nếu đúng tuyệt đối, thiết
kế probe của WO §IV vô nghĩa; nhưng nó mâu thuẫn với DuoFace QA180 (hook sendEvent trong process
app thấy và nuốt được chạm, 12 swallowed=1 trên xe). Audit kiểm lại từ hồ sơ saga trên đĩa
(`~/workspace/omnicar-pinch/`):

### 6.1 "Cổng trong-app" của bản 44 hook ở đâu — XÁC MINH: đúng sendEvent trong process app
- Bản 44 = host 0.18.0~fix1 + **relay 0.9.0~fix1 (`OmniCarPinchRelay.dylib`)**, filter là danh sách
  **13 bundle app** (YouTube, GOFA, Google Maps, Waze, Facebook… — `redo/BUILD44_REPORT.md`, mục
  Delta 5). Delta 3 của bản 44: khôi phục **nguyên văn** máy nuốt của bản 41/0.7.0 từ
  `redo/backup-42/OmniCarPinchRelay-0.7.0.xm`, "gate snapshot before %orig".
- File 0.7.0 đó: hook `-[UIApplication sendEvent:]` tại **dòng 130**; bản relay hiện hành
  (`relay/OmniCarPinchRelay.xm`) ghi ngay header dòng 9 "Gate at -[UIApplication sendEvent:]" và
  hook tại **dòng 217–218**. Vậy điểm cài và process **không có gì phải bàn**: cổng của bản 44 nằm
  đúng tại sendEvent của process app được host — cùng vị trí với DuoFace QA180.

### 6.2 "Đúng 1 bản ghi lúc teardown" là bản ghi gì
- Đó là **bản ghi chạm (kind=touch) mà consumer phía host đọc được từ mailbox DF156**, không phải
  bản ghi log cục bộ của relay. Trong phiên bản 44 (log `work/device-log-20261108-1932.log`, cửa
  sổ 08:00–08:02), consumer `probe-read` nhận: state ×25, query ×6, kb ×2, torn ×8 — và **touch
  đúng 1 bản ghi duy nhất**: GOFA count=22 lúc 08:02:46, swallowed=0 (dòng 2345–2347, kèm
  `wake-actuated`), **~2 giây trước teardown** của split lúc 08:02:48 ("tat split"). Comment
  HISTORY tại `feature/src/OmniCarDoubleTapFullscreen.xm:1029–1032` ghi lại đúng quan sát này.
- Cùng cửa sổ, tầng sendEvent của **CarPlayApp** thấy lưu lượng chạm dày đặc (pinch
  suppressedTotal=305) — tương phản đó là gốc của kết luận "chạm không qua sendEvent của app".

### 6.3 Kết luận phân định
**Tiền đề của khẳng định là ĐÚNG** (bản 44 đo đúng sendEvent trong process app), **nhưng nó
không phủ quyết được thiết kế probe của WO**, vì hai nhiễu độc lập làm con số "1" không phải là
phép đo lưu lượng sendEvent:
1. **Kênh quan sát tự mất dữ liệu.** Mọi bản ghi của relay tới analyst qua mailbox DF156 **một
   ô, latest-wins**, dùng chung cho tối đa 13 relay và 5 loại bản ghi. Chính `BUILD44_REPORT.md`
   (judgment call 3) ghi nhận việc ghi-đè có hệ thống trong kênh này, và thứ tự ghi verdict-trước/
   touch-sau làm bản ghi đến trước dễ bị bản ghi sau đè. Bản ghi state sống sót vì relay phát lại
   liên tục (tự chữa); bản ghi chạm và bản ghi verdict đều là **một lần cho mỗi Began** — và trong
   cửa sổ trên, consumer cũng đọc được **0 verdict** dù verdict cũng được ghi mỗi Began. Log vì
   vậy không tách được "hook không cháy" khỏi "bản ghi bị đè trước khi đọc": con số 1 là **cận
   dưới**, không phải số đếm sendEvent. (Cộng thêm: writer có throttle 0,25 s cho bản ghi quan
   sát — Delta 3.)
2. **Khác ngăn xếp hosting.** QA180 chạy trên hosting của DuoFace (cửa sổ dashboard phía
   SpringBoard); bản 44 chạy trên hosting QA20 (dashboard trong CarPlayApp). Đường phân phối
   chạm vào process app là tính chất của ngăn xếp hosting — hai kết quả đo hai ngăn xếp khác
   nhau nên không trực tiếp bác nhau. Ngăn xếp mà WO nhắm tới (AppBridge của bản rebuilt, gần
   gốc 1.0.3 nhất) là ngăn xếp **thứ ba, chưa từng được đo**.
- Thêm một dữ kiện hai mặt: bản ghi GOFA duy nhất kia **chứng minh hook của relay có cháy ít
  nhất một Began trong app hosted** ở phiên đó — đường đi không chết về cấu trúc; thời điểm của
  nó (sát teardown, khi lưu lượng mailbox giảm) cũng tương thích với giả thuyết bị đè.
- **Hệ quả cho WO:** tranh chấp là THẬT nhưng CHƯA PHÂN ĐỊNH. Bản 44 nâng xác suất chống lại
  thiết kế, không đóng được nó. Probe dry-run của WO §IV — ghi log **cục bộ ngay trong process
  app**, không qua mailbox dùng chung — là dụng cụ loại đúng nhiễu (1) và đo đúng ngăn xếp đích;
  nó vẫn là bước quyết định bắt buộc, và Gate 0 không có cơ sở để tuyên bố nó vô ích cũng như
  không có cơ sở để tuyên bố nó sẽ thành công.

## 7. Câu hỏi mở cho các strand sau
- **Q1 (chặn Gate 1):** gói add-on QA19/QA20 có còn **cài** trên máy test không? Hai phiên RE cho
  thấy chúng không hoạt động, nhưng filter của QA19 (mọi process UIKit) sẽ để lại dòng
  `app-input-relay-installed` trong log nếu còn cài — không thấy trong log r5/r6. Một ảnh chụp
  `dpkg -l` trên máy sẽ chốt dứt điểm.
- **Q2:** trong bản rebuilt, SCPCarSplit chạy vai chrome ở process nào (dylib nạp cả CarPlayApp
  lẫn SpringBoard; log r6 cho thấy hành động split ở process CarPlay) — chủ trạng thái của WO
  phải đặt đúng process đang sống đó; cần chốt ở SCPHooks/ctor.
- **Q3:** đối số `handle` của hostFrameInfo được suy ra thế nào tại các điểm gọi
  (SCPCarSplit.m:1882, 1994) — quyết định khi nào handle phía host biến mất hợp lệ (sụp ô vs idle).
- **Q4:** transport chính xác của các kênh `hostPost:` (appbridge.knobs/handletap/shield —
  NSDistributed hay Darwin + payload) chưa được đọc ở Gate 0; strand IPC phải chốt trước khi
  thiết kế namespace mới, dù WO cấm đụng vào các kênh này.
- **Q5 (âm tính có giới hạn):** trong 6 vị trí đã đọc + grep timer/opacity toàn module
  SplitScreen, **không tồn tại** cơ chế tự ẩn theo idle cho handle native và knob — bar là control
  duy nhất tự ẩn (4,0 s). Nếu trên xe RE thấy handle/knob mờ dần, cơ chế nằm ngoài phạm vi đã đọc
  và phải tìm lại; không được mặc định nó tồn tại như QA20 (nơi GPT add-on tự sơn opacity).
