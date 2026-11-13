# Nhóm C — Nguồn VietMap & Google Maps (Lề / dev.bechou.le 0.2.4)

Phạm vi: `LeGoogleSource.dylib`, `LeSourceShown.dylib` (cùng nạp vào VietMap Live, `vn.vietmap.live`) và `LeGoogleMaps.dylib` (nạp vào Google Maps, `com.google.Maps`). Phân tích tĩnh chỉ đọc: strings dump, `llvm-nm-18`, disassembly chọn điểm bằng `llvm-objdump-18`. Mọi kết luận có nhãn **[ĐÃ ĐO]** (dẫn chứng cụ thể), **[SUY LUẬN]**, **[CHƯA RÕ]**.

---

## 1. Vì sao có HAI dylib cùng nạp vào VietMap Live — phân vai

Cả hai file filter đều chỉ chứa đúng một bundle: `vn.vietmap.live` **[ĐÃ ĐO — nội dung `LeGoogleSource.plist` và `LeSourceShown.plist`]**.

| | LeSourceShown (166.256 B) | LeGoogleSource (477.584 B) |
|---|---|---|
| Class tự định nghĩa | **Không có class nào** | `GVMLocationSession`, `GVMOutputEndpoint`, `VMNavSource` **[ĐÃ ĐO — `_OBJC_CLASS_$_…` trong strings]** |
| Hook (MSHook/CydiaSubstrate) | **Không** — không link CydiaSubstrate, không import `MSHookMessageEx`/`NSClassFromString` **[ĐÃ ĐO — danh sách import]** | **Có** — link `@rpath/CydiaSubstrate.framework`, import `_MSHookMessageEx`, `_NSClassFromString` **[ĐÃ ĐO]** |
| Framework đáng chú ý | Chỉ Foundation/CoreFoundation/UIKit | Thêm **CoreLocation** **[ĐÃ ĐO — INVENTORY.md]** |
| Việc duy nhất | Phát tín hiệu "VietMap đang hiển thị" | Trích xuất dữ liệu dẫn đường + quản lý phiên GPS nền + phát dữ liệu ra ngoài |

### LeSourceShown = đèn báo hiện diện (beacon), không đụng dữ liệu

- **[ĐÃ ĐO]** Toàn bộ import của nó chỉ gồm: `NSNotificationCenter`, `UIApplication`, `NSBundle`, `UISceneDidActivateNotification`, và bộ ba Darwin notify `_notify_register_check`, `_notify_set_state`, `_notify_post`, cộng `_getpid`.
- **[ĐÃ ĐO]** Disassembly constructor (arm64e, quanh `0x40c4–0x4274`): đăng ký token cho tên notify `dev.bechou.le.bubble.vietmap-shown`; trong nhánh xử lý scene kích hoạt có chuỗi lệnh `_getpid` → `_notify_set_state(token, pid)` → `_notify_post(token)`.
- **[ĐÃ ĐO]** Selector nó dùng: `connectedScenes`, `activationState`, `bundleIdentifier`, `addObserverForName:object:queue:usingBlock:` — tức nó lắng nghe `UISceneDidActivateNotification`, rà các scene đang kết nối, và khi scene của VietMap vào trạng thái active thì phát notify kèm **state = PID của process VietMap**.
- Nó **không** đọc tốc độ/giới hạn/biển báo gì cả — không có bất kỳ chuỗi dữ liệu dẫn đường nào trong 201 dòng strings.

### LeGoogleSource = bộ trích xuất dữ liệu (provider)

- **[ĐÃ ĐO]** Nó là phía *tiêu thụ* tín hiệu của LeSourceShown: trong strings của LeGoogleSource có `dev.bechou.le.bubble.vietmap-shown` cùng các kênh hiện diện của nguồn khác (`dev.bechou.le.bubble.gofa-events`, `dev.bechou.le.bubble.waze-events`, `dev.bechou.le.gmaps.background.shown.2`, `dev.bechou.le.gmaps.background.shown.3`), và nó import cả `_notify_register_dispatch`/`_notify_get_state` (đọc state của beacon khác).
- **[ĐÃ ĐO]** Chuỗi log tự mô tả vai: `independent Google Maps source loaded 0.1.0`, `common source output publication refused`, `selected source GPS started by wake lease`.

### Vì sao tách hai — [SUY LUẬN] từ các dấu vết trên

1. **Tách độ mong manh**: phần trích dữ liệu bám vào nội bộ Flutter của VietMap và có sẵn đường thoái lui khi app cập nhật — chuỗi `common data channel not hooked: unexpected Flutter engine`, `unsupported Flutter channel ABI; provider inactive` **[ĐÃ ĐO]**. Nếu hook hỏng, provider tự vô hiệu nhưng beacon (chỉ dùng API UIKit ổn định `UISceneDidActivateNotification`) vẫn báo đúng "VietMap đang mở" cho phần còn lại của hệ thống (trọng tài chọn nguồn, bubble).
2. **Beacon phải sống độc lập với logic nặng**: các dylib khác kiểm tra "nguồn nào đang hiển thị" bằng `notify_get_state` đọc PID trong state — cần một phát tín hiệu rẻ, không phụ thuộc phiên GPS/hook. Mẫu này lặp lại cho các nguồn khác (`.background.shown.2/.3`, `gofa-events`, `waze-events`) **[ĐÃ ĐO — tên kênh]**.
3. **[CHƯA RÕ]** Thứ tự nạp/trình tự khởi tạo giữa hai dylib và việc LeGoogleSource có *bắt buộc* cần beacon mới chịu phát dữ liệu hay chỉ dùng nó để chấm freshness — strings cho thấy nó quan sát `vietmap-shown` nhưng chưa khôi phục được toàn bộ điều kiện gating.

---

## 2. LeGoogleSource trích xuất gì từ VietMap Live

### 2.1 Điểm bám: hai kênh Flutter của chính VietMap

VietMap Live là app Flutter. LeGoogleSource hook tầng method channel:

- **[ĐÃ ĐO]** Import `_MSHookMessageEx`; class/selector đích: `FlutterMethodChannel` → `setMethodCallHandler:`, và `setMessageHandlerOnChannel:binaryMessageHandler:` / `…taskQueue:` (kênh binary kiểu Pigeon). Chuỗi trạng thái: `common data hook installed`, `overlay hook installed`.
- **[ĐÃ ĐO]** Kênh method channel tên **`vietmap_car_method_channel`**; log `VietMap overlay handler registered`. Các method bị chặn nghe (strings nguyên văn):
  - `updateCurrentSpeed` — tốc độ hiện tại
  - `updateSpeedLimit` — giới hạn tốc độ
  - `updateLaneInfo` — thông tin làn
  - `updateUpcommingAlerts` (nguyên văn sai chính tả "Upcomming") — cảnh báo sắp tới
  - `updateStickyAlerts` — cảnh báo dính (sticky)
  - `updateMapOverlayData` — gói dữ liệu overlay tổng hợp (log kèm: `overlay state=%ld speed=%@ limit=%@`)
  - `cacheImage`, `setNavigationImage` — ảnh biển báo/hình dẫn đường do app đẩy xuống native
- **[ĐÃ ĐO]** Kênh Pigeon: `dev.flutter.pigeon.vietmap_live_navigation_plugin.CarMapFlutterOverlayAPI.sendVMLCommonData` với payload có khóa `mapMatchingData`; nhóm hàm C tương ứng: `_CWVietMapCommonDataChannel`, `_CWVietMapCommonDataLimit`, `_CWVietMapObserveCommonData` — đây là đường lấy **giới hạn tốc độ từ dữ liệu map-matching** ("common data"), độc lập với kênh overlay ở trên.
- **[ĐÃ ĐO]** Có kiểm tra ABI: block signature kỳ vọng `v24@?0@"<VMFlutterMethodCall>"8@?<v@?@>16`; nếu khác → `unsupported Flutter channel ABI; provider inactive`.

### 2.2 Dữ liệu trích ra

- **Tốc độ hiện tại + giới hạn tốc độ** **[ĐÃ ĐO]** — từ `updateCurrentSpeed`/`updateSpeedLimit` (hàm xử lý `GVMVietMapOutput`, `applyMainSpeed:receivedAt:`, `applyMainSpeedLimit:receivedAt:`) và giới hạn dự phòng từ common data (`_CWVietMapCommonDataLimit`).
- **Cảnh báo (alerts)** **[ĐÃ ĐO]** — tối đa 2 cảnh báo đồng thời (kênh ra `alert.first`, `alert.second`), mỗi cảnh báo giải mã qua `GVMVietMapAlertsFromPayload`, `GVMDecodeAlert`, `GVMEncodeAlert`; khóa payload thấy được: `kind`, `code`, `artworkID`, `enabled`, `distance`. Có thêm nhóm "sticky alerts" riêng (`GVMVietMapOverlayStickyAlerts`) và khóa payload overlay: `stickyAlerts`, `upcomingAlerts`/`upcommingAlerts`, `restrictionEventData`, `parkingInfo`, `noPassingGoingIn`, `trafficSignal`.
- **Nhận diện loại cảnh báo bằng ảnh** **[ĐÃ ĐO]** — VietMap gửi ảnh biển/cảnh báo (qua `cacheImage`/`setNavigationImage`); LeGoogleSource băm SHA-256 ảnh (`imageSHA256`, `_CC_SHA256`) rồi tra bảng digest → tên artwork chuẩn: `speed_limit_10.png` … `speed_limit_120.png`, `khu_dan_cu.png` (khu dân cư), và danh mục kiểu Waze: `accident`, `hazard-pothole`, `hazard-weather-fog`, `bus-lane-cam`, `dummy-camera`, `distance-between-vehicles-camera`, `blocked-lane`, `closed-lane-crash`, … (hàm `GVMVietMapKindForImageDigest`, `GVMVietMapKindForAssetName`, `GVMRoadAlertIconName`). Ảnh debug được lưu `le-gmaps-alert-image.png`, `le-gmaps-navimage-%@.png` khi bật cờ `le-gmaps-alert-image.enable`/`le-gmaps-alert-observation.enable`.
- **Làn đường (lanes)** **[ĐÃ ĐO]** — từ `updateLaneInfo`/`laneInfo`/`laneItems`; mã hướng chuẩn hoá: `STRAIGHT`, `LEFT`, `RIGHT`, `SLIGHT_LEFT`, `SLIGHT_RIGHT`, `SHARP_LEFT`, `SHARP_RIGHT`, `UTURN`, `UTURN_LEFT`, `UTURN_RIGHT`, `NONE`, tiền tố `LANE_`; hàm `GVMVietMapLaneCodeForImage` (làn cũng có thể đến dạng ảnh), `GVMVietMapAdvanceLanes`/`_GVMVietMapAdvanceLaneLifetime` (làn "advance" có vòng đời riêng). Kênh ra: `lanes.first`, `lanes.second`.
- **Trạng thái đứng yên** **[ĐÃ ĐO]** — `_GVMVietMapStandstillHold`, `_GVMVietMapStandstillKph`: có logic giữ/đóng băng mẫu khi xe đứng yên (ngưỡng km/h), chống nhiễu tốc độ.
- **GPS** **[ĐÃ ĐO]** — class `GVMLocationSession`: hook hành vi `CLLocationManager` của app (selector `locationManager:didUpdateLocations:`, `setAllowsBackgroundLocationUpdates:`, `setPausesLocationUpdatesAutomatically:`, `showsBackgroundLocationIndicator`…), log `app requested standard GPS start`, `app requested standard GPS stop; forwarded`, `observing GPS delegate`. Mục đích: giữ phiên GPS chạy nền phục vụ hiển thị trên xe ("wake lease"), dùng cả API `CLBackgroundActivitySession` (`backgroundActivitySessionWithQueue:handler:`) trên iOS mới. Kênh điều phối: `dev.bechou.le.gmaps.background.location-session`, `dev.bechou.le.gmaps.background.location-source`.

### 2.3 Mạng / file

- **[ĐÃ ĐO]** **Không có URL/host mạng nào** trong strings của cả ba dylib (grep `http`, `ws://`, tên miền: rỗng). `dataWithContentsOfURL:`/`dictionaryWithContentsOfURL:` chỉ phục vụ đọc file local (plist/Info.plist cho diagnostics).
- **[ĐÃ ĐO]** File nó ghi (log chẩn đoán, trong thư mục dùng chung của cả hệ Lề): `/var/mobile/Library/Caches/dev.bechou.le.bubble/host.txt`, `presence.log`, `cast.log`, và log riêng `le-gmaps-source.log`, `le-gmaps-location-session.log` (cùng thư mục cache). Đây là log, không phải kênh dữ liệu chính.

---

## 3. LeGoogleMaps — "thẻ" trong Google Maps

`LeGoogleMaps.dylib` (826.896 B) là phía **hiển thị**: nó ngụ trong process Google Maps, nhận dữ liệu nguồn (VietMap/Gofa/Waze) qua Darwin notify và vẽ một thẻ tốc độ đè lên giao diện Google Maps — cả trên CarPlay lẫn trên iPhone. Chuỗi tự mô tả: `native CarPlay replacement loaded 0.1.8; awaiting fresh VietMap samples` và `unsupported Google Maps ABI; replacement inactive` **[ĐÃ ĐO]**.

### 3.1 Nó thay thế đúng UI native nào của Google Maps

- **[ĐÃ ĐO]** Tên class của chính Google Maps xuất hiện trong strings: `GMSNSpeedLimitView`, `GMSNSpeedLimitViewConfiguration`, `GMSNSpeedLimitInfo`, và các selector `supportsSpeedLimitView`, `shouldDisplaySpeedLimitView`, `setSupportsSpeedLimitView:`, `setShouldDisplaySpeedLimitView:`, `setSpeedLimitInfo:`, `setupSpeedLimitViewIfNeeded`, `initWithSpeedLimit:speed:style:distanceUnit:speedingType:`.
- **[ĐÃ ĐO]** Nó import `_MSHookMessageEx` + `_NSClassFromString` (tra class Google Maps lúc chạy, chịu được đổi tên theo version) và `_class_getInstanceMethod`.
- **[SUY LUẬN]** Có hai chế độ (log chẩn đoán phân biệt rõ: `CarPlay mode=%@ speed=%@ limit=%@ window=%@ child=%@ native=%@ bounds=%@ …`): (a) **native** — bơm dữ liệu nguồn ngoài vào `GMSNSpeedLimitInfo` để view giới hạn tốc độ có sẵn của Google Maps hiển thị; (b) **replacement** — giấu/thay view native bằng thẻ tự vẽ. Việc chọn mode theo ABI/version Google Maps (`unsupported Google Maps ABI; replacement inactive`).
- **[ĐÃ ĐO]** Class view CarPlay của Google Maps bị bám: `AZCarPlayView` cùng selector `layoutSubviews`, `didMoveToWindow`, `traitCollectionDidChange:`-họ (`traitCollection`) — hook `layoutSubviews` là điểm neo để gắn/giữ thẻ trong cây view CarPlay của Google Maps. **[CHƯA RÕ]** class chính xác sở hữu `setupSpeedLimitViewIfNeeded` (chưa disasm tới điểm gọi MSHookMessageEx để trích đối số class).

### 3.2 Thẻ được dựng thế nào

- **[ĐÃ ĐO]** View tự định nghĩa: `GVMSpeedCardView`; ba phong cách thẻ là class riêng: `GVMClassicSpeedCard`, `GVMHaloSpeedCard`, `GVMLeTileCard`; thêm mô-đun phụ `GVMHaloLaneStrip` (dải làn), `GVMHaloSignDock` (dock biển báo), `GVMOverspeedFrame` (khung cảnh báo quá tốc), `GVMLaunchBreaker` (ngắt tự động theo số lần launch — `GVMBeginLaunch`/`GVMCheckLaunch`/`GVMClearLaunchCount`, **[SUY LUẬN]** là circuit-breaker chống vòng lặp crash).
- **[ĐÃ ĐO]** Vẽ thuần **CoreGraphics/CoreText**: import hàng loạt `CGContext…`, `CGPath…`, `_CC_SHA256`; hàm vẽ C: `CWDrawRoadSign`, `CWRoadSignImage`, `CWLaneArrowBuild`/`CWLaneArrowDraw`, `CWDrawWazeAlert`, `CWEdgeGlowDraw`/`CWEdgeGlowBlink` (viền phát sáng nhấp nháy khi quá tốc), `CWTrafficBubbleArrange`… Biển giới hạn/cảnh báo được vẽ lại từ tên artwork chuẩn (cùng bảng digest SHA-256 → `speed_limit_*.png` như phía nguồn) chứ không bê ảnh bitmap của VietMap sang.
- **[ĐÃ ĐO]** Nội dung thẻ gồm các mô-đun: đồng hồ tốc độ, biển giới hạn, dải làn, dock biển cảnh báo — hàm `GVMCardModuleIDs`, `GVMCardModuleKey`, `GVMCurrentHiddenCardModules`/`GVMDecodeHiddenCardModules` (người dùng ẩn/hiện từng mô-đun; cấu hình đến qua kênh `dev.bechou.le.gmaps.bubble-modules`).
- **Font Saira** **[ĐÃ ĐO]**: LeGoogleMaps link CoreText, import `_CTFontManagerRegisterFontsForURL`, strings chứa đường dẫn `/usr/share/le/gmaps/fonts` (tức `/var/jb/usr/share/le/gmaps/fonts` trên máy rootless — đúng thư mục kèm gói có `Saira-Bold.ttf`, `Saira-Medium.ttf`, `Saira-SemiBold.ttf`, `SairaCondensed-Bold.ttf`, `AOFL.txt`) và tên PostScript `Saira-Bold`, `Saira-Medium`, `Saira-SemiBold`, `SairaCondensed-Bold`. Nó **đăng ký font từ file lúc chạy** rồi dùng cho chữ số/chữ trên thẻ. **[SUY LUẬN]** SairaCondensed-Bold dùng cho con số tốc độ lớn (bản condensed tiết kiệm bề ngang), các weight thường cho nhãn phụ — chưa disasm điểm chọn font theo mô-đun nên chưa khẳng định được từng mô-đun dùng weight nào.
- **Vị trí/kích thước** **[ĐÃ ĐO]**: hàm `GVMCardOriginFor`, `GVMClampCardOrigin`, `GVMCardSizeFor`, `GVMCarPlayCardSizeForView`, `GVMCarPlayCardSizeForLayout`, `GVMScaleCardSize`; trạng thái vị trí được phát/nhận qua notify `dev.bechou.le.gmaps.placement-state`, `dev.bechou.le.gmaps.size-state`, `dev.bechou.le.gmaps.size-changed`, và hàm `GVMPublishSavedSizes` (kích thước đã lưu được phát lại cho các process khác — ví dụ relay phía CarPlayApp/SpringBoard dùng chung toạ độ).
- **Mặt hiển thị thứ hai — iPhone** **[ĐÃ ĐO]**: ngoài CarPlay còn có "phone card": `GVMUpdatePhoneSpeedCard`, `GVMRemovePhoneSpeedCard`, `GVMPhoneCardOriginFor/SizeFor`, kênh `dev.bechou.le.gmaps.phone-placement-percent`, `dev.bechou.le.gmaps.background.phone`, chuỗi log `iPhone card`, `iPhone card removal`. Tức thẻ tốc độ cũng được gắn trong UI Google Maps trên iPhone, vị trí đặt theo phần trăm do cấu hình quyết định.

### 3.3 Hook trong Google Maps (tóm tắt)

- **[ĐÃ ĐO]** `MSHookMessageEx` lên các selector quanh tính năng speed-limit native: `setupSpeedLimitViewIfNeeded`, `setSpeedLimitInfo:`, `setSupportsSpeedLimitView:`, `setShouldDisplaySpeedLimitView:` (ép Google Maps bật/hiện vùng speed limit kể cả khi dữ liệu native không có).
- **[ĐÃ ĐO]** Hook `layoutSubviews` (bối cảnh `AZCarPlayView`) để neo thẻ; theo dõi `didMoveToWindow`, `traitCollection` (đổi light/dark — kênh `dev.bechou.le.gmaps.interface-style`).
- **[ĐÃ ĐO]** Không thấy hook nào vào tầng bản đồ/render (GMSMapView/vector map) — nó chỉ làm việc ở tầng view UIKit phía trên. **[CHƯA RÕ]** danh sách cặp (class, selector) đầy đủ của từng `MSHookMessageEx` — cần disasm constructor mới liệt kê hết được.

---

## 4. Kênh IPC tổng thể của nhóm

Toàn bộ IPC là **Darwin notify** (`notify_post`/`notify_set_state`/`notify_get_state`/`notify_register_dispatch`/`notify_register_check`/`notify_cancel` — cả ba dylib đều import, trừ LeSourceShown chỉ có nhánh phát) **[ĐÃ ĐO]**. Không socket, không URL, không XPC công khai nào lộ trong strings **[ĐÃ ĐO]**.

### 4.1 Sơ đồ luồng

```
VietMap Live (process vn.vietmap.live)
├─ LeSourceShown ──post──▶ dev.bechou.le.bubble.vietmap-shown   (state = PID VietMap)
└─ LeGoogleSource
     ├─ hook FlutterMethodChannel "vietmap_car_method_channel"
     │    (updateCurrentSpeed/updateSpeedLimit/updateLaneInfo/
     │     updateUpcommingAlerts/updateStickyAlerts/updateMapOverlayData/cacheImage…)
     ├─ hook Pigeon "…CarMapFlutterOverlayAPI.sendVMLCommonData" (mapMatchingData → limit)
     ├─ hook CLLocationManager (giữ GPS nền theo "wake lease")
     └─ publish output của nguồn VietMap ──┐
                                           ▼
Google Maps (process com.google.Maps) — LeGoogleMaps
     ├─ GVMObserveSourceOutput / GVMRequestSelectedSource (xin nguồn đang chọn phát lại)
     ├─ đọc output qua notify_get_state từng kênh con
     └─ vẽ GVMSpeedCardView (CarPlay: neo vào AZCarPlayView; iPhone: phone card)
```

### 4.2 Các kênh chính

**Hiện diện / trọng tài nguồn** (nhiều người gửi, nhiều người nghe) **[ĐÃ ĐO]**:
- `dev.bechou.le.bubble.vietmap-shown` — LeSourceShown phát, state = PID.
- `dev.bechou.le.bubble.gofa-events`, `dev.bechou.le.bubble.waze-events`, `dev.bechou.le.gmaps.background.shown.2`, `dev.bechou.le.gmaps.background.shown.3`, mẫu `dev.bechou.le.gmaps.background.shown.%u` — hiện diện của các nguồn còn lại.
- `dev.bechou.le.bubble.carplay-fresh` — tín hiệu phiên CarPlay mới.
- `dev.bechou.le.gmaps.source.selection` + mẫu `.source.%lu.request` — chọn nguồn đang hoạt động (hàm `GVMObserveSelection`, `GVMApplyChosenSource`, `GVMRequestSelectedSource`, `GVMShouldRequestSource`); phía VietMap có kênh riêng `dev.bechou.le.gmaps.source.vietmap.request` để bên hiển thị yêu cầu nguồn VietMap phát lại dữ liệu.

**Dữ liệu nguồn (output frame, version 1)** **[ĐÃ ĐO tên kênh; SUY LUẬN cách đóng gói]**:
- Mẫu tên: `dev.bechou.le.gmaps.output.v1.%lu.%@` trong đó `%lu` = ID nhà cung cấp (hàm `GVMVietMapProviderID`; các provider: `vietmap-live`, `gofa`, `waze`) và `% @` = tên trường: `kind`, `code`, `enabled`, `limit`, `commit`, `selection`, `sample`, `active`, `alert.first`, `alert.first.value`, `alert.second`, `alert.second.value`, `lanes.first`, `lanes.second`.
- Kênh chốt: `dev.bechou.le.gmaps.output.v1.%lu.changed` — phát sau khi các trường đã set xong (mẫu hình "nhiều kênh con + một notify commit"), phía nhận có `GVMObserveSourceOutput`, `GVMReadSourceOutput`, `GVMOutputChangedName`, `GVMOutputRequestName`, `GVMDecodeSourceOutput`, `GVMNormalizeSourceOutput`.
- **[SUY LUẬN]** Giá trị từng trường được mang trong **state 64-bit** của chính kênh con đó (`notify_set_state` lúc phát / `notify_get_state` lúc đọc): bằng chứng là cả hai đầu đều import đủ bộ set/get state và có cặp hàm `GVMEncode…`/`GVMDecode…` cho từng thực thể (`GVMEncodeSample`/`GVMDecodeSample`, `GVMEncodeAlert`/`GVMDecodeAlert`, `GVMEncodeSourceOutput`/`GVMDecodeSourceOutput`) — tức tốc độ/giới hạn/mã cảnh báo được **đóng gói số học vào 64 bit** thay vì gửi object. Chi tiết bit-layout từng trường: **[CHƯA RÕ]** (chưa disasm hết `GVMEncodeSourceOutput` @0x6478 arm64e).
- Kênh vô hướng rút gọn song song **[ĐÃ ĐO]**: `dev.bechou.le.gmaps.speed`, `dev.bechou.le.gmaps.limit`, `dev.bechou.le.gmaps.alert.first`, `dev.bechou.le.gmaps.alert.second` và bộ kênh test `dev.bechou.le.gmaps.test.alert.first/second`, `dev.bechou.le.gmaps.test`, `dev.bechou.le.gmaps.test.lanes`, `dev.bechou.le.gmaps.test.photo`.

**Điều khiển hiển thị** (LePrefs/relay ↔ LeGoogleMaps) **[ĐÃ ĐO tên kênh]**:
`dev.bechou.le.gmaps.bubble-modules` (mô-đun ẩn/hiện), `dev.bechou.le.gmaps.bubble-visibility`, `dev.bechou.le.gmaps.bubble-presence`, `dev.bechou.le.gmaps.presentation-options`, `dev.bechou.le.gmaps.interface-style`, `dev.bechou.le.gmaps.placement-state`, `dev.bechou.le.gmaps.size-state`, `dev.bechou.le.gmaps.size-changed`, `dev.bechou.le.gmaps.phone-placement-percent`, `dev.bechou.le.gmaps.carplay.guidance`, `dev.bechou.le.gmaps.carplay-fullmap`, `dev.bechou.le.gmaps.background.carplay`, `dev.bechou.le.gmaps.background.phone`, `dev.bechou.le.gmaps.caught-exception`.

**Chẩn đoán** **[ĐÃ ĐO]**: kênh `dev.bechou.le.gmaps.debug.v1.%@.%@`; nhóm hàm `GVMDiagnostics…` (gom log bubble/cast, crash trong `/var/mobile/Library/Logs/CrashReporter`, nhận diện loại jailbreak roothide/rootless) ghi vào các file log trong `/var/mobile/Library/Caches/dev.bechou.le.bubble/`.

### 4.3 Định dạng payload phía VietMap (đầu vào)

- **[ĐÃ ĐO]** Đầu vào là **arguments của Flutter method call** (dictionary): tốc độ/giới hạn dạng số (`source-scalar method=%@ type=%@ value=%@`, `not-numeric`), overlay dạng dictionary có `stickyAlerts`, `upcomingAlerts`, `restrictionEventData`, `parkingInfo`, `laneInfo`/`laneItems`, ảnh dạng bytes kèm `imageSHA256`. Hàm `GVMVietMapDataValue`, `GVMVietMapOverlayObservation`, `GVMVietMapOverlayPatch` cho thấy có cơ chế vá/gộp overlay theo từng phần.
- **[ĐÃ ĐO]** Mẫu (sample) GPS/tốc độ có các khóa `providerName`, `timestamp`, `coord`/`position`, `heading`/`bearing` (hàm `payloadAtUptime:timestamp:`, `freshSamplesAtUptime:` — phía nhận chỉ dùng mẫu còn "tươi").

---

## 5. Danh sách [CHƯA RÕ] còn lại

1. Bit-layout chính xác của state 64-bit cho từng trường output (`GVMEncodeSourceOutput`/`GVMEncodeSample`/`GVMEncodeAlert`) — cần disasm đầy đủ ba hàm này.
2. Cặp (class, selector) đầy đủ của mọi `MSHookMessageEx` trong LeGoogleMaps và LeGoogleSource (đặc biệt class sở hữu `setupSpeedLimitViewIfNeeded`).
3. Điều kiện gating giữa `vietmap-shown` và việc LeGoogleSource chịu publish output.
4. Ánh xạ weight font Saira → từng mô-đun của thẻ.
5. Vai trò chính xác của `LeGoogleRelay`/`LeGuidanceRelay` trong việc chuyển placement-state sang màn CarPlay (ngoài phạm vi nhóm này, chỉ suy ra từ tên kênh dùng chung).
