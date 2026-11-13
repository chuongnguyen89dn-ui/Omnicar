# NHÓM A — HIỂN THỊ & RELAY: LeBubble, LeGoogleRelay, LeSupervisor, LeGuidanceRelay

Gói: `dev.bechou.le` 0.2.4 ("Lề"). Phân tích tĩnh chỉ-đọc (Mach-O arm64, ObjC metadata, disassembly có mục tiêu). Nhãn: **[ĐÃ ĐO]** = có bằng chứng trực tiếp trong binary (class/method/chuỗi/địa chỉ); **[SUY LUẬN]** = suy từ nhiều bằng chứng gián tiếp; **[CHƯA RÕ]** = chưa đủ bằng chứng.

## 0. Kết luận bao trùm

- **[ĐÃ ĐO] Cả 4 dylib KHÔNG hook một method nào.** Không file nào link `CydiaSubstrate`, không có chuỗi/symbol `MSHookMessageEx`, không import `class_getInstanceMethod`/`method_setImplementation`/`method_exchangeImplementations`. Toàn bộ nhóm hiển thị/relay hoạt động bằng: (1) cửa sổ `UIWindow` tự tạo, (2) duyệt cây view/scene của tiến trình chủ bằng `objc_getClass`/`NSClassFromString`, (3) IPC bằng **Darwin notify kèm state 64-bit** (`notify_register_check`/`notify_set_state`/`notify_get_state`/`notify_post`/`notify_register_dispatch` — cả 4 file đều import), (4) file JSON dùng chung, (5) CFPreferences.
- **[ĐÃ ĐO] Mã dùng chung được biên dịch lặp vào nhiều dylib:** bộ hàm `CWTrafficBubbleLayout*`/`CWReadTrafficBubble*`/`CWStoreTrafficBubble*`/`CWWriteOwnedStateFile` xuất hiện nguyên vẹn trong LeBubble, LeGoogleRelay và LeSupervisor; bộ `GVM*` (giao thức dữ liệu nguồn) xuất hiện trong LeBubble và LeGoogleRelay.
- **[ĐÃ ĐO] Thư mục dữ liệu chung** (theo `NSHomeDirectory()`): `~/Library/Preferences/dev.bechou.le.bubble/` chứa `layout-v1.json` (bố cục bubble) và `traffic-bubble-state-v1.json` (trạng thái); `~/Library/Caches/dev.bechou.le.bubble/` chứa file chẩn đoán/trạng thái phía host; `/var/mobile/Library/Caches/dev.bechou.le.source-icons/` chứa icon các app nguồn (PNG) + kênh báo thay đổi `dev.bechou.le.source-icons.changed`.
- **[ĐÃ ĐO] Mọi dữ liệu "sống" đều đóng gói vào state 64-bit của notify:** mỗi kênh có một hàm `GVMEncode*`/`GVMDecode*` tương ứng (đóng/mở các trường bit), bên nhận đăng ký `notify_register_dispatch` hoặc đọc vòng `notify_get_state`.

---

## 1. LeBubble.dylib — hiển thị bong bóng giao thông (704.064 byte)

Filter **[ĐÃ ĐO]**: `com.apple.CarPlayApp` + `com.apple.springboard`.

### 1.1 Khởi động — hai vai theo tiến trình

Constructor tại `0x4000` **[ĐÃ ĐO]**:
- Chỉ chạy khi `geteuid() == 501` (user mobile) và iOS major − 15 ≤ 11 (tức iOS 15–26).
- So `bundleIdentifier`: nếu `com.apple.CarPlayApp` → tạo singleton **`CWTrafficOverlayController`**; nếu `com.apple.springboard` → tạo singleton **`CWCastBubbleController`** (đối chiếu classref slot `0x4b508`→class struct `0x4bc18`, `0x4b510`→`0x4bcb8`).

### 1.2 Bản đồ class (13 class, 364 method) **[ĐÃ ĐO]**

| Class | Số method | Vai trò (bằng chứng tên method/property) |
|---|---|---|
| `CWTrafficOverlayController` | 138 | Bộ điều khiển trong **CarPlayApp**: `hostsSeen:`, `dashboardHost:`, `dockFrame`, `placementArea`, `place`, `renderTraffic`, `beat` (heartbeat), `updatePresence`, `castSet:token:state:`, `publishCastPlace:`, `noteChannel:`, `chooseSource:`, `googleFullMap`, `todayShowsIn:`, ghi log từ chối/che khuất (`noteRefusal:`, `noteCover`, `writeHostText`, `refusalLines`, `coverLines`) |
| `CWCastBubbleController` | 85 | Bộ điều khiển trong **SpringBoard**: `showAt:level:`, `bubbleFrame`, `place:`, `hide:`, `markShown:`, `prepareBubble`, `windowConfiguration`, `carConfiguration`, `tapped:`/`panned:`, đọc `cache`/`layoutDirectory`/`state` |
| `CWTrafficWindow` | 1 | `UIWindow` con, override `hitTest:withEvent:` |
| `CWTrafficHitView` | 4 | View bắt chạm cho bubble (`hitTest:withEvent:`, property `bubble`) |
| `CWTrafficBubbleView` | 42 | View vẽ bubble: `drawBubbleInRect:`, `drawSpeedPiece:`, `drawLanesPiece:`, `drawSignPiece:`, `displaySnapshot:source:`, `rearrange`, `overspeedBlinkFrequency`, `pulsePath`/`updatePulse` (hiệu ứng nhịp), `surfaceColor`, `material`, `darkTone`, `setCollapsed:`, `setCornerOnLeft:`, `setCornerAtBottom:` |
| `CWTrafficBubbleCanvas` | 4 | Lớp vẽ nền (`drawRect:`, `owner`) |
| `CWTrafficBubbleContent` | 25 | Model nội dung: `speedText`, `limit`, `speedState`, `overspeedExcess`, `signs`, `lanes`, `lanesDistanceNumber/Unit`, `inForce`, `upcoming`, `spokenSummary`, `live`; factory `+contentWithSnapshot:` |
| `CWTrafficBubbleSign` | 13 | Một biển/cảnh báo: `kind`, `artwork`, `value`, `distanceNumber`, `distanceUnit`, `spokenName` |
| `CWTrafficBubbleLane` | 4 | Một làn: `artworkCode`, `dimmed` |
| `CWTrafficBubblePiece` | 22 | Một "mảnh" trong bố cục: `kind`, `frame`, `glued`, `surface`, `compact`, `sourceOnly`, `disc` (đĩa tốc độ), `plate` (biển giới hạn) |
| `CWTrafficBubbleArrangement` | 13 | Bố cục tổng: `pieces`, `size`, `style`, `compact`, `sourceBadge` (huy hiệu app nguồn) |
| `CWCarPlayHostClasses` | 11 | Tra cứu class riêng của DashBoard/CarPlay: `+current`, `initWithLookup:`, `root`, `home`, `app`, `today`, `mainWindow`, `dock`, `complete`, `summary` |
| `CWBubbleOutputEndpoint` | 2 | Đầu cuối tiêu thụ dữ liệu nguồn: `initWithSourceID:` (+ ivar `tokens`, `published`, `previous`, `previousCommit`, `previousSelection` — chống trùng/lặp bản tin) |

Hàm C đáng chú ý **[ĐÃ ĐO]**: `CWDrawRoadSign`, `CWRoadSignImage`/`CWRoadSignNames` (vẽ biển báo VN), `CWDrawWazeAlert`, `CWWazeAlertImage` (vẽ cảnh báo kiểu Waze), `CWLaneArrowBuild`/`CWLaneArrowDraw` (mũi tên làn), `CWEdgeGlowDraw`/`CWEdgeGlowBlink` (viền phát sáng khi quá tốc độ), `CWEncodeCastPlace`/`CWDecodeCastPlace`, `CWTrafficSnapshotFromCardOutput`, `CWExportSourceAppIcons`.

### 1.3 Bubble hiển thị bằng gì

- **[ĐÃ ĐO] Cửa sổ riêng `CWTrafficWindow`** (subclass `UIWindow`, override `hitTest:withEvent:` để chỉ vùng bubble bắt chạm — kết hợp `CWTrafficHitView`), tạo bằng `initWithWindowScene:` trên scene CarPlay (chuỗi `UIWindowSceneSessionRoleCarPlay`, selector `connectedScenes`, `allWindowsIncludingInternalWindows:onlyVisibleWindows:`). Bubble là `CWTrafficBubbleView` tự vẽ toàn bộ bằng CoreGraphics (hàng chục symbol `CGContext*`/`CGPath*`), không dùng ảnh giao diện có sẵn.
- **[ĐÃ ĐO] Window level là giá trị ĐỘNG, không phải hằng số:** `CWCastBubbleController showAt:level:` nhận level làm tham số; hàm `CWCastLevelAbove` tính level cao hơn cửa sổ chủ (dashboard) — chuỗi log đối chiếu các cửa sổ khác trên màn CarPlay: `"nothing over the bubble (%lu windows on the CarPlay screen)"`, `"no window of another tweak off the main screen"`. **[CHƯA RÕ]** giá trị số tuyệt đối (phụ thuộc level của cửa sổ DashBoard tại thời điểm chạy).
- **[ĐÃ ĐO] Điểm neo là DashBoard của CarPlayApp:** `CWCarPlayHostClasses` tra (`objc_getClass`) các class riêng: `DBDashboardRootViewController`, `DBDashboardHomeViewController`, `DBApplicationSceneViewController`, `DashBoard.DBDashboardMainWindow`, `DashBoard.DBDockWindow`, `DBStatusBarWindow`, `CARTodayViewController`, `CARStatusBarWindow` — overlay controller tính `dockFrame`, `placementArea` (vùng trống cạnh dock), `corner` (góc đặt), và ghi log khi không có chỗ: `"no room: area %@ beside dock %@ in window %@, bubble %.0fx%.0f"`, `"the bubble in CarPlay has no room"`, `"covered: CarPlay classes missing"`. Có cả đường gắn "through CarPlay's dashboard" (`hostThroughDashboard`) và đường qua scene khác (`"(other scene)"`).
- **[ĐÃ ĐO] Tương tác:** chạm để thu/mở (`toggle`, `tapped:`, chuỗi trợ năng "Chạm để mở rộng. Kéo sang góc khác để đổi vị trí."), kéo đổi góc (`panned:`, `dragCenter`, `dragAnchor`), trạng thái thu gọn `collapsed` được lưu vào state file.
- **[SUY LUẬN] Hai đường hiển thị song song:** phía CarPlayApp (OverlayController) gắn bubble vào vùng dashboard nó tìm thấy và *công bố vị trí* qua kênh cast; phía SpringBoard (CastBubbleController) dựng cửa sổ trên scene CarPlay do SpringBoard quản và báo đã hiện. Chuỗi `"the bubble in CarPlay is not attached"` + cơ chế `cast` cho thấy đây là cơ chế dự phòng/điều phối hai phía, chưa đủ bằng chứng xác định chính xác điều kiện chuyển đường.

### 1.4 Nội dung bubble **[ĐÃ ĐO]**

Từ model `CWTrafficBubbleContent` + các hàm vẽ + chuỗi tiếng Việt trong `__ustring`:
- **Tốc độ hiện tại**: `speedText` (nguồn `currentSpeedMps` → hiển thị "Tốc độ %@ km/h"); trạng thái `speedState` + `overspeedExcess` (vượt bao nhiêu), nhấp nháy viền theo `overspeedBlinkFrequency`/`CWEdgeGlowBlink`.
- **Giới hạn tốc độ**: `limit` — vẽ thành "đĩa/biển" (`disc`, `plate`, format "Biển %.0f km/h").
- **Biển báo & cảnh báo**: mảng `signs` (`CWTrafficBubbleSign`: kind/artwork/khoảng cách/tên đọc). Tập artwork PNG kiểu Waze (`speed-camera.png`, `red-light-camera.png`, `school-zone.png`, `police.png`, `railway.png`, `emergency-vehicle.png`, `hazard-pothole.png`…) cộng biển VN vẽ bằng code (`CWRoadSign*`: "Biển tốc độ", "Cấm vượt", "Khu dân cư", "Hầm", "Trạm thu phí", các loại camera: "camera giao thông", "camera cảnh sát cơ động", "camera dây an toàn"…). Hai cảnh báo đồng thời qua kênh `alert.first`/`alert.second`; `inForce` (đang hiệu lực) vs `upcoming` (sắp tới).
- **Làn đường**: mảng `lanes` (`CWTrafficBubbleLane.artworkCode`, `dimmed`) + khoảng cách tới điểm rẽ (`lanesDistanceNumber/Unit`, format "%@ cách %@", "%lu làn%@").
- **Huy hiệu nguồn** (`sourceBadge`) — icon app đang cấp dữ liệu (GOFA/Waze/VietMap/Google), lấy từ thư mục source-icons dùng chung.
- **Tóm tắt đọc (accessibility/spoken)**: `spokenSummary`, format "Giao thông %@, %@. %@".

### 1.5 Kênh dữ liệu của LeBubble **[ĐÃ ĐO]** (chuỗi trong binary; hướng theo tên hàm/property)

Nhận vào:
- Dữ liệu nguồn qua thư viện GVM nhúng: `GVMObserveSourceOutput`, `GVMObserveSelection`, `GVMReadSourceOutput` + `CWBubbleOutputEndpoint` — các kênh đầu ra theo nguồn `dev.bechou.le.gmaps.source.*` và kênh chuẩn hoá `dev.bechou.le.gmaps.speed` (mẫu tốc độ, `GVMDecodeSample`), `dev.bechou.le.gmaps.limit` (`GVMLimitStateName`), `dev.bechou.le.gmaps.alert.first` / `.alert.second` (`GVMDecodeAlert`), `dev.bechou.le.gmaps.carplay.guidance` (xem §4), `dev.bechou.le.gmaps.carplay-fullmap` (property `fullmapWatchToken`, method `googleFullMap`).
- Cấu hình: `dev.bechou.le.bubble.layout-changed`, `dev.bechou.le.gmaps.bubble-presence`, file `layout-v1.json` + `traffic-bubble-state-v1.json`.

Phát ra:
- `dev.bechou.le.bubble.carplay-heartbeat` (method `beat`, `heartbeatToken`, `lastHeartbeat`) — nhịp sống phía CarPlay.
- `dev.bechou.le.bubble.alive` (`aliveToken`), `dev.bechou.le.bubble.cast` + `dev.bechou.le.bubble.place` (`CWEncodeCastPlace`, `publishCastPlace:`, `castPlaceToken`), `dev.bechou.le.bubble.cast-shown` (`shownToken`, `markShown:` phía Cast), `dev.bechou.le.bubble.state` / `dev.bechou.le.bubble.state-changed` (`stateToken`), `dev.bechou.le.bubble.carplay-fresh` (`CWCastFresh`, `freshToken`).
- File chẩn đoán trong `~/Library/Caches/dev.bechou.le.bubble/`: `writeHostText`/`hostText`/`hostSummary` (văn bản trạng thái host để phía điện thoại/prefs đọc), log "refusal" và "cover" (lý do không hiện/ bị che).

---

## 2. LeGoogleRelay.dylib — trạm trung chuyển cấu hình & chọn nguồn (328.880 byte)

Filter **[ĐÃ ĐO]**: `com.apple.springboard` + `com.apple.CarPlayApp` (chạy ở cả hai tiến trình).

Class duy nhất: `GVMOutputEndpoint` (2 method: `initWithSourceID:`, `dealloc`) — cùng khuôn với `CWBubbleOutputEndpoint` của LeBubble. Phần còn lại là ~100 hàm C tiền tố `GVM*`/`CW*` **[ĐÃ ĐO]**.

### 2.1 Relay cái gì

1. **Cấu hình: CFPreferences → Darwin notify.** **[ĐÃ ĐO]** Constructor (init offset `0x8c78`) và vòng lặp của nó đọc hàng loạt khoá CFPreferences (`CFPreferencesCopyAppValue`/`CFPreferencesCopyMultiple`, `CFPreferencesAppSynchronize`) + file layout/state, mã hoá (`GVMEncodeBubbleVisibility`, `GVMEncodeSizes`, `GVMEncodePhonePlacement`, `GVMEncodeBubbleConfiguration`, `GVMEncodePlacement`, `GVMEncodePresentationOptions`, `GVMEncodeInterfaceStyle`, `GVMEncodeOverspeedLease`…) rồi `notify_set_state` + `notify_post` lên các kênh `dev.bechou.le.gmaps.*` tương ứng. Đây là cầu nối để mọi thành phần (kể cả trong app Google Maps/CarPlayApp vốn không đọc chung prefs) nhận cùng một cấu hình.
2. **Chọn nguồn dữ liệu (source arbitration).** **[ĐÃ ĐO]** `GVMSelectedSourceID`, `GVMSelectOutputSource`, `GVMApplyChosenSource`, `GVMRequestSelectedSource`, `GVMShouldRequestSource`, `GVMObserveSourceOutput`, `GVMObserveSelection`, `GVMPublishSourceOutput`, `GVMReadSourceOutput`, `GVMNormalizeSourceOutput`. Nguồn hợp lệ **[ĐÃ ĐO từ cfstring]**: `gofa` = `com.lumi.GOFA`, `waze` = `com.waze.iphone`, `vietmap-live` = `vn.vietmap.live`, và Google Maps. Kênh yêu cầu theo nguồn có mẫu `dev.bechou.le.gmaps.source.%lu.request` (hàm `GVMSourceRequestName`, `GVMOutputRequestName(sourceID)`) và kênh `.source.selection`. `GVMOutputEndpoint` giữ `tokens/published/previous/previousCommit/previousSelection` để chỉ chuyển tiếp khi dữ liệu nguồn được chọn thay đổi.
3. **Xuất icon nguồn.** **[ĐÃ ĐO]** `CWExportSourceAppIcons`/`CWSourceAppIcon` dùng dịch vụ icon hệ thống (`initWithBundleIdentifier:`, `prepareImageForDescriptor:`, `CGImageForImageDescriptor:`, `UIImagePNGRepresentation`) ghi PNG vào `/var/mobile/Library/Caches/dev.bechou.le.source-icons/` và phát `dev.bechou.le.source-icons.changed`.
4. **Di trú cài đặt cũ.** **[ĐÃ ĐO]** `CWImportLegacySettings` + marker `legacySettingsImported`: đọc thư mục cũ `Library/Preferences/org.carwidget.traffic-bubble`, `Library/Caches/org.carwidget.traffic-bubble`, domain `org.carwidget.gmaps` (tên sản phẩm tiền thân "CarWidget").

### 2.2 Kênh của LeGoogleRelay **[ĐÃ ĐO]** (24 tên kênh `dev.bechou.le.*` trong binary)

Nhóm dữ liệu nguồn: `gmaps.speed`, `gmaps.limit`, `gmaps.alert.first`, `gmaps.alert.second`, `gmaps.test.alert.first`, `gmaps.test.alert.second` (kênh kiểm thử), `gmaps.source.vietmap.request`.
Nhóm cấu hình/hiển thị: `gmaps.placement-state`, `gmaps.size-state`, `gmaps.size-changed`, `gmaps.phone-placement-percent`, `gmaps.bubble-visibility`, `gmaps.bubble-presence`, `gmaps.bubble-configuration`, `gmaps.bubble-modules`, `gmaps.interface-style`, `gmaps.presentation-options`, `gmaps.overspeed.mode`, `gmaps.overspeed.lease`, `bubble.layout-changed`, `source-icons.changed`.
Khoá cấu hình thấy trong cfstring **[ĐÃ ĐO]**: vị trí/kích thước 3 mặt (`dashboardPosition/Scale`, `phonePosition/Scale`, `fullPosition/Scale`, `phoneXPercent/phoneYPercent`, `anchorX/anchorY`), `modules` (speed/limit/lanes/maneuver/alerts…), `arrangement` (column/grid/strip…), `background` (asphalt/glass/gradient/haze/bare/paint…), `backgroundOpacity`, `overspeedBlink`, `overspeedScope`, `interfaceStyle` (dark/light), chế độ trình bày (`bubble-only`, `maps-only`, `maps-home`…), `closeSource`, `wakeSource`.

**[SUY LUẬN]** Vì chạy ở cả SpringBoard lẫn CarPlayApp với cùng mã xuất bản cấu hình, LeGoogleRelay là "nguồn sự thật" phân phối cấu hình theo thời gian thực: LePrefs (Settings) ghi CFPreferences/file → bản sao LeGoogleRelay gần nhất đọc và phát notify → LeBubble và các dylib nguồn áp dụng ngay, không cần respring.

---

## 3. LeSupervisor.dylib — watchdog đánh thức/đóng app nguồn nền (205.056 byte)

Filter **[ĐÃ ĐO]**: chỉ `com.apple.springboard`. **0 class ObjC riêng**; Foundation thuần (không UIKit), 27 symbol định nghĩa (chủ yếu là thư viện layout dùng chung) + lõi giám sát trong vùng `0x4000–0x7560`.

### 3.1 Giám sát cái gì **[ĐÃ ĐO]**

- **Phiên CarPlay**: dlopen `/System/Library/PrivateFrameworks/CarKit.framework` lấy class `CARSessionStatus`, đọc `currentSession` (4 framework dlopen tại constructor: CarKit, FrontBoardServices, RunningBoardServices, CoreLocation). Chuỗi log: `"session started: the bubble or Google Maps' card shows"`, `"CarPlay disconnected; 20 second countdown started"`, `"CarPlay reconnected; countdown cancelled"`.
- **Nhịp/độ tươi phía CarPlay**: đăng ký các kênh notify (`notify_register_dispatch` ×5, `notify_register_check` ×8, `notify_get_state` ×6 trong lõi): `dev.bechou.le.bubble.carplay-heartbeat`, `dev.bechou.le.bubble.carplay-fresh`, `dev.bechou.le.bubble.layout-changed`, và nhóm nền `dev.bechou.le.gmaps.background.carplay` / `.background.phone` / `.background.location-session` / `.background.location-source` / `.background.shown.2` / `.background.shown.3`, cộng sự kiện nguồn `dev.bechou.le.bubble.gofa-events`, `dev.bechou.le.bubble.waze-events`, `dev.bechou.le.bubble.vietmap-shown`.
- **Cấu hình**: đọc cùng `layout-v1.json` (khoá `wakeSource`, `closeSource`) — quyết định app nào được đánh thức/đóng.
- Vòng lặp bằng `NSTimer` trên main run loop + `dispatch_after` **[ĐÃ ĐO từ import/selector]**.

### 3.2 Hành động cụ thể **[ĐÃ ĐO từ chuỗi log + selector riêng]**

1. **Đánh thức app nguồn khi CarPlay nối**: dùng FrontBoardServices (`FBSOpenApplicationService`, `FBSSystemService`, `serviceWithDefaultShellEndpoint`, `openApplication:withOptions:completion:`, tuỳ chọn `__ActivateSuspended`) mở app nguồn đã chọn (GOFA/Waze/VietMap/Google Maps) ở chế độ nền; nếu máy đang khoá thì hoãn và thử lại không tính lượt (`__PromptUnlockDevice`/`__UnlockDevice`, "launch refused while locked; retrying without counting").
2. **Giữ app sống nền**: xin `RBSAssertion` qua RunningBoardServices (`RBSDomainAttribute` domain `com.apple.frontboard`... thuộc tính `Workspace-BackgroundActive`, `newAssertionForBundleIdentifier:withReason:`, `targetWithPid:`) — log "background execution acquired=%d"; đồng thời xin ngữ cảnh vị trí tạm thời `CLInUseAssertion` của CoreLocation và kiểm tra quyền vị trí của app nguồn (`authorizationStatusForBundleIdentifier:`, "location permission=%ld (3 Always or 4 While Using)", "Location Services off; nothing is woken").
3. **Thử lại có giới hạn**: đếm số lần launch theo "round" ("publishing after %u launch attempt(s) in round %u", "%s did not stay up after %d launches; trying again in %.0f s").
4. **Đóng app khi CarPlay ngắt**: sau **20 giây** đếm ngược, đóng đúng pid mình đã mở (`terminateApplication:forReason:andReport:withDescription:` qua `SBApplicationController`/`LSApplicationWorkspace`, log "%s pid %d closed, 20 s after the disconnect was noticed"). Ngoại lệ **[ĐÃ ĐO]**: không đóng nếu Google Maps trên iPhone đang dùng dữ liệu của nó ("%s left running while Google Maps on the iPhone uses its data"), không đóng app không phải do nó mở / không còn được chọn ("close requested pid=%d reason=launched for %s, no longer chosen"), tôn trọng công tắc `closeSource` ("close switch off/on"), và nếu app không còn dữ liệu mới nhưng vẫn chạy thì để yên sau khi ghi log ("%s running, no data for %.0f s; left running").
5. **Chẩn đoán**: ghi log riêng `/var/mobile/Library/Logs/le-supervisor.log` (`CWWriteOwnedStateFile`, có giữ vòng "diagnostics held %lu/%lu"); kênh debug động `dev.bechou.le.gmaps.debug.v1.%@.%@` với khoá `event%lu`/`recent%lu` **[SUY LUẬN: vòng đệm sự kiện chẩn đoán phát qua notify state]**. Supervisor cũng dùng introspection `NSMethodSignature` (`methodSignatureForSelector:`, `getArgumentTypeAtIndex:`…) để gọi API riêng một cách mềm — khi giao diện riêng thay đổi thì tự vô hiệu hoá thay vì crash ("private interface changed; nothing is woken or closed for CarPlay").

**Không phải** watchdog kiểu giết/restart tiến trình hệ thống: nó chỉ quản vòng đời **app nguồn dữ liệu** quanh phiên CarPlay. **[ĐÃ ĐO]**

---

## 4. LeGuidanceRelay.dylib — relay hình học thẻ dẫn đường CarPlay gốc (167.424 byte)

Filter **[ĐÃ ĐO]**: `com.apple.CarPlayTemplateUIHost`. **0 class riêng, 0 hook**; 3 symbol: `GVMEncodeGuidance` (`0x4990`), `GVMDecodeGuidance` (`0x4b3c`), biến `GVMGuidanceStateName`.

### 4.1 Cách lấy dữ liệu **[ĐÃ ĐO từ disassembly constructor + vòng quét]**

- Constructor (`0x4000`): chỉ tiếp tục nếu `bundleIdentifier == "com.apple.CarPlayTemplateUIHost"`; `dispatch_async` về main queue → hàm dựng `0x408c`: `NSClassFromString` ba class riêng của hệ thống CarPlay: **`CPSCardPlatterView`**, **`CPSManeuversCardView`**, **`CPSNavigationETAView`** (lưu con trỏ class vào global); thiếu bất kỳ class nào thì dừng.
- Tạo **dispatch timer trên main queue: bắt đầu sau 500 ms, chu kỳ 100 ms** (`dispatch_source_set_timer` với start `0x1DCD6500` ns, interval `0x05F5E100` ns tại `0x4130–0x4154`) — tức **quét 10 lần/giây**, không hook.
- Mỗi nhịp (hàm quét `0x4178`): duyệt `UIApplication.connectedScenes → windows → subviews` đệ quy, tìm view thuộc 3 class trên; với thẻ maneuver tìm được, lấy `bounds`, quy đổi hệ toạ độ bằng `convertRect:toView:`/`convertRect:toCoordinateSpace:` sang view ETA/khung chứa, lấy `CGRectGetMinY`/`CGRectGetMaxY`, kiểm tra `isHidden`/`alpha`. **Không đọc text/nội dung chữ** (không có selector label/text nào trong bảng selector — toàn hình học).

### 4.2 Chuyển đi đâu, dạng gì **[ĐÃ ĐO]**

- `GVMEncodeGuidance` đóng gói **5 giá trị số thực (double) thành 5 trường × 12 bit** trong state 64-bit (các `orr … lsl #12/#24/#36/#48` tại `0x4b24–0x4b30`) và **đặt bit 63 = "còn hiệu lực"** (`orr x0, x8, #0x8000000000000000`). **[SUY LUẬN]** Năm giá trị là các mốc hình học dọc của thẻ dẫn đường (MinY/MaxY của `CPSManeuversCardView` sau quy đổi và của `CPSNavigationETAView`) — đủ để phía nhận biết thẻ dẫn đường gốc đang hiện ở đâu/cao bao nhiêu mà tránh va chạm.
- Phát trên **đúng một kênh**: `dev.bechou.le.gmaps.carplay.guidance` — `notify_register_check` (token lưu global `GVMGuidanceStateName`), `notify_set_state` mỗi nhịp, nhưng **`notify_post` chỉ khi 48 bit thấp thay đổi** so với giá trị đã lưu (so sánh tại `0x44dc–0x44ec`) — giảm đánh thức không cần thiết.
- Bên nhận: LeGoogleSource/LeGoogleMaps (có `GVMDecodeGuidance` đối xứng — ngoài phạm vi nhóm này) và LeBubble (có chuỗi kênh trong binary) **[ĐÃ ĐO về sự tồn tại của kênh ở phía nhận; SUY LUẬN về mục đích tránh chồng lấn với thẻ Google/bubble]**.

---

## 5. Sơ đồ luồng dữ liệu tổng

```
 NGUỒN (trong app bản đồ)                TRUNG CHUYỂN / ĐIỀU PHỐI                      HIỂN THỊ
 ────────────────────────                 ──────────────────────────                      ────────
 LeGoogleSource (Google Maps) ─┐
 LeGofaSource (GOFA) ───────────┤  output theo nguồn:
 LeWazeSource (Waze) ───────────┤  dev.bechou.le.gmaps.source.<id>.*   ┌──────────────────────────────────┐
 LeVietMap source ──────────────┘ ────────────────────────────────►   │ LeGoogleRelay (SB + CarPlayApp)  │
        ▲ yêu cầu dữ liệu:                                            │  • GVMOutputEndpoint từng nguồn  │
        │ dev.bechou.le.gmaps.source.<id>.request                     │  • chọn 1 nguồn đang hoạt động   │
        │                                                             │  • CFPreferences + layout/state  │
        │                                                             │    JSON → phát lại cấu hình      │
        │                                                             └───────┬──────────────────┬───────┘
        │            kênh chuẩn hoá: gmaps.speed / gmaps.limit /              │                  │
        │            gmaps.alert.first / .second / bubble-* /                 ▼                  ▼
        │            placement-state / size-state / overspeed.*     LeBubble (CarPlayApp):        LeBubble (SpringBoard):
        │                                                           CWTrafficOverlayController    CWCastBubbleController
        │                                                           • tìm host DashBoard, dock    • CWTrafficWindow trên
        │                                                           • render CWTrafficBubbleView    scene CarPlay, showAt:level:
        └─────────────────────────────────────────────────────────  • beat → bubble.carplay-      • markShown →
                                                                      heartbeat                       bubble.cast-shown
 LeGuidanceRelay (CarPlayTemplateUIHost) ── dev.bechou.le.gmaps.carplay.guidance (hình học thẻ
        quét CPSManeuversCardView/ETA 10 Hz ──► (cho LeGoogleSource/LeBubble né chồng lấn)

 LeSupervisor (SpringBoard): xem CARSessionStatus (CarKit) + heartbeat/fresh + gmaps.background.*
        ├─ CarPlay nối  → FBS mở app nguồn nền + RBSAssertion giữ sống + CLInUseAssertion vị trí
        └─ CarPlay ngắt → chờ 20 s → terminate đúng pid đã mở (trừ khi Maps iPhone đang dùng)
 LePrefs (Settings) → ghi CFPreferences + layout-v1.json ──► LeGoogleRelay phát notify ──► tất cả áp dụng
 Icon nguồn: LeGoogleRelay/LeBubble (CWExportSourceAppIcons) → Caches/dev.bechou.le.source-icons/*.png
             + dev.bechou.le.source-icons.changed → huy hiệu nguồn trên bubble
```

### Bảng kênh IPC chính (tổng hợp cả 4 file) **[ĐÃ ĐO]**

| Kênh | Bên phát | Bên nhận | Nội dung (state 64-bit) |
|---|---|---|---|
| `dev.bechou.le.gmaps.speed` | nguồn / relay | LeBubble | mẫu tốc độ (GVMEncodeSample) |
| `dev.bechou.le.gmaps.limit` | nguồn / relay | LeBubble | giới hạn tốc độ (mặt "dial") |
| `dev.bechou.le.gmaps.alert.first` / `.second` | nguồn / relay | LeBubble | 2 cảnh báo đường (GVMEncodeAlert) |
| `dev.bechou.le.gmaps.test.alert.first` / `.second` | LePrefs (test) | LeBubble | cảnh báo kiểm thử |
| `dev.bechou.le.gmaps.source.vietmap.request`, mẫu `…source.%lu.request`, `…source.selection` | relay / bubble | các dylib nguồn | yêu cầu/chọn nguồn cấp dữ liệu |
| `dev.bechou.le.gmaps.carplay.guidance` | LeGuidanceRelay | LeGoogleSource, LeBubble | 5 trường hình học thẻ dẫn đường gốc + bit hiệu lực |
| `dev.bechou.le.gmaps.carplay-fullmap` | LeGoogleMaps | LeBubble | Google Maps đang full-map ở CarPlay |
| `dev.bechou.le.gmaps.bubble-presence` | LeBubble/relay | các bên | bubble đang hiện |
| `dev.bechou.le.gmaps.placement-state`, `.size-state`, `.size-changed`, `.phone-placement-percent` | LeGoogleRelay | LeBubble, nguồn | vị trí/kích thước bubble theo từng mặt (xe/điện thoại/full) |
| `dev.bechou.le.gmaps.bubble-visibility`, `.bubble-configuration`, `.bubble-modules`, `.interface-style`, `.presentation-options` | LeGoogleRelay | LeBubble | cấu hình hiển thị bubble |
| `dev.bechou.le.gmaps.overspeed.mode`, `.overspeed.lease` | LeGoogleRelay | LeBubble/nguồn | chế độ cảnh báo quá tốc + "lease" thời hạn |
| `dev.bechou.le.bubble.layout-changed` | LePrefs/bubble | tất cả | bố cục đã đổi (đọc lại layout-v1.json) |
| `dev.bechou.le.bubble.cast`, `.bubble.place`, `.bubble.cast-shown`, `.bubble.alive`, `.bubble.state`, `.bubble.state-changed` | LeBubble hai phía | LeBubble phía kia, Supervisor | điều phối vị trí/hiện bubble giữa SpringBoard ↔ CarPlayApp |
| `dev.bechou.le.bubble.carplay-heartbeat`, `.bubble.carplay-fresh` | LeBubble (CarPlayApp) | LeSupervisor, LeBubble (SB) | nhịp sống/độ tươi phía CarPlay |
| `dev.bechou.le.bubble.gofa-events`, `.bubble.waze-events`, `.bubble.vietmap-shown` | các nguồn | LeSupervisor | sự kiện nguồn đã hiện dữ liệu |
| `dev.bechou.le.gmaps.background.carplay` / `.background.phone` / `.background.location-session` / `.background.location-source` / `.background.shown.2` / `.background.shown.3` | nguồn / Google Maps | LeSupervisor | trạng thái nền & phiên vị trí của app nguồn |
| `dev.bechou.le.source-icons.changed` | LeGoogleRelay/LeBubble | LeBubble | icon nguồn đã xuất xong |
| `dev.bechou.le.gmaps.debug.v1.%@.%@` | (mẫu tên động) | LeSupervisor | kênh chẩn đoán theo cặp khoá |

### Đếm tổng hợp **[ĐÃ ĐO]**

| File | Class riêng | Method ObjC | Symbol C định nghĩa | Kênh `dev.bechou.le.*` (chuỗi) | Hook MSHook |
|---|---|---|---|---|---|
| LeBubble | 13 | 364 | 162 | 22 | 0 |
| LeGoogleRelay | 1 | 2 | 134 | 24 | 0 |
| LeSupervisor | 0 | 0 | 27 | 14 | 0 |
| LeGuidanceRelay | 0 | 0 | 3 | 1 | 0 |

## 6. Ba phát hiện quan trọng nhất

1. **Không hook nào trong cả nhóm hiển thị/relay** — kiến trúc "lịch sự": cửa sổ riêng + duyệt cây view bằng tra cứu class + notify/file. Điểm giòn nằm ở chỗ phụ thuộc tên class riêng của DashBoard (`DBDashboard*`) và CarPlay (`CPSManeuversCardView`…) — iOS đổi tên là mất hiển thị, và mã có sẵn log "private interface changed" để tự nhận biết tình trạng này.
2. **Toàn bộ dữ liệu sống đi qua state 64-bit của Darwin notify với giao thức đóng gói bit riêng (họ hàm `GVMEncode*/GVMDecode*`)** — tốc độ, giới hạn, 2 cảnh báo, vị trí, cấu hình, và cả hình học thẻ dẫn đường gốc (5×12 bit + bit hiệu lực) đều là số nguyên đóng gói, không có XPC/socket/file cho dữ liệu thời gian thực; file JSON chỉ dùng cho cấu hình và chẩn đoán.
3. **LeSupervisor là "người giữ app nguồn sống"**: nó tự mở app bản đồ nguồn ở nền khi CarPlay kết nối (FrontBoardServices + RunningBoard assertion + CLInUseAssertion), thử lại có đếm lượt, và đóng đúng pid đã mở sau 20 s khi CarPlay ngắt — đây là mảnh ghép khiến GOFA/Waze/VietMap "luôn có dữ liệu" cho bubble dù người dùng không mở app.
