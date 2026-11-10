# QUÉT SÂU TÍNH NĂNG MỚI 1.0.5 (NGOÀI BẢN QUYỀN) — cấp class/selector/khóa/chuỗi

Chỉ đọc, không chạy binary. Nguồn: payload 1.0.5
`~/workspace/omnicar-105/payload/`, đối chiếu 1.0.3
`~/workspace/omnicar-re/payload/`, nền bề mặt: `audit/agent-b-binary.md`.
[BẰNG CHỨNG] = chuỗi/selector/khóa đọc trực tiếp từ binary hoặc
.strings của 1.0.5 và không có ở 1.0.3 (đã đối chiếu tập chuỗi).
[SUY RA] = diễn giải cơ chế từ các bằng chứng đó.

## 1. TÙY CHỌN TỪNG APP (AppBridge)

### 1.1 Trang cài đặt `OMCAppBridgeAppOptionsController` (Prefs)
- [BẰNG CHỨNG] Class mới trong OmniCarPrefs, kèm ivar
  `T@"NSDictionary",&,N,V_appOptions` / `_appOptions` /
  `setAppOptions:` và selector `hasOptions:`,
  `appCell:inTable:options:` — controller giữ một NSDictionary tùy
  chọn cho nhiều app và vẽ từng hàng app kèm trạng thái có/không có
  tùy chọn riêng.
- [BẰNG CHỨNG] Khóa chữ (AppBridge.strings, nguyên văn):
  - `APPBRIDGE_OPT_ZOOM` — EN "App size" / VI "Cỡ app"
  - `APPBRIDGE_OPT_DISPLAY` — EN "On the car screen" / VI "Hiển thị
    trên xe"
  - `APPBRIDGE_OPT_PHONE_UI` — EN "iPhone interface" / VI "Giao diện
    iPhone"
  - `APPBRIDGE_OPT_DEFAULT` — EN "Default" / VI "Chung"
  - `APPBRIDGE_OPT_FOOTER` — EN: "App size: the app is drawn larger
    and scaled down so text and buttons are not oversized on the car.
    Default is 80 %: minus makes the app smaller, plus makes it
    larger. Changes take effect after a respring (button at the top
    right)." / VI: "Cỡ app: app vẽ to hơn rồi thu nhỏ để chữ và nút
    không quá to trên xe. Chung là 80 %: trừ để app nhỏ hơn, cộng để
    to hơn. Thay đổi có hiệu lực sau khi respring (nút góc trên bên
    phải)."
  - `APPBRIDGE_OPT_PHONE_UI_FOOTER` — EN: "Show this app's iPhone
    interface on the car through App Bridge instead of its CarPlay
    interface. While on, steering-wheel buttons, Now Playing and Siri
    do not control the app. Takes effect after a respring (button at
    the top right)." / VI: "Đưa giao diện iPhone của app này lên xe
    qua App Bridge thay cho giao diện CarPlay. Khi bật, nút vô lăng,
    Đang phát và Siri không điều khiển được app. Có hiệu lực sau khi
    respring (nút góc trên bên phải)."
  - `APPBRIDGE_OPT_RESPRING_MSG` — EN "Changes on this page take
    effect after a respring." / VI "Thay đổi ở trang này có hiệu lực
    sau khi respring."
  - [BẰNG CHỨNG] Trong binary Prefs còn khóa `APPBRIDGE_PHONE_UI_BADGE`
    (huy hiệu đánh dấu app đang ép giao diện iPhone trong danh sách);
    khóa này không xuất hiện trong các file .strings đã trích — chỉ
    có dạng tên khóa trong binary.
- [BẰNG CHỨNG] WhatsNew 1.0.5 mô tả đường vào: "Trong App trên màn
  xe, chạm một app CarPlay rồi bật Giao diện iPhone…" và "Chạm một
  app trong App trên màn xe, chỉnh Cỡ app từ 60 đến 100 % (mặc định
  80 %)" → trang tùy chọn mở từ danh sách Apps, không phải một trang
  plist tĩnh (cả 3 Feature*.plist không đổi so với 1.0.3).

### 1.2 Cấu trúc khóa `appBridgeAppOptions`
- [BẰNG CHỨNG] Khóa prefs mới `appBridgeAppOptions` (AppBridge +
  Prefs đều có chuỗi này; 1.0.3 không có). Log phía AppBridge:
  `tuy chon rieng %@: huong %lld, zoom %@` — tra theo bundle ID (%@),
  đọc ra **hướng (số nguyên %lld)** và **zoom**.
- [BẰNG CHỨNG] Các literal trường con có mặt trong AppBridge 1.0.5:
  `zoom`, `orientation`, `phoneUI` (cùng `phoneUI:`,
  `phoneUISwitched:` ở Prefs — callback khi gạt công tắc giao diện
  iPhone).
- [SUY RA] Cấu trúc: `appBridgeAppOptions = { <bundleID>: { zoom:
  <số/%>, orientation: <nguyên>, phoneUI: <bool> } }`. Ba trường khớp
  1-1 với ba mục trên trang tùy chọn (Cỡ app / hướng hiển thị / Giao
  diện iPhone) và với log "huong %lld, zoom %@". Giá trị zoom mặc
  định toàn cục 80 %, khoảng 60–100 % theo WhatsNew/footer.

### 1.3 `ABWakeView` + kênh `appbridge.handlewake`
- [BẰNG CHỨNG] Class mới `ABWakeView` (AppBridge, phía app được host)
  và `SCPCWakeView` (SplitScreen, phía CarPlayApp). Cả hai đều có
  ivar `T@"UIView",&,N,V_wake` và selector `setWake:`; phía AppBridge
  thêm `setWake:forApp:` (gắn view đánh thức theo từng app),
  `WakeView`.
- [BẰNG CHỨNG] Kênh Darwin chung: `com.anlai.omnicar/appbridge.
  handlewake` — có trong cả AppBridge và SplitScreen; phía
  SplitScreen còn hằng `AB_HANDLE_WAKE` và selector `bridgeWake`.
- [BẰNG CHỨNG] Phía AppBridge, wake đi cùng cơ chế cổng màn chào:
  `applySplashGate`, `watchSplash`, ivar `TQ,N,V_splashGen` /
  `splashGen` (thế hệ màn chào), kênh `com.anlai.omnicar/splash`, và
  log `splash chua tat sau 20 s -> van hien cua so o` (màn chào chưa
  tắt sau 20 s thì vẫn hiện cửa sổ ô app).
- [SUY RA] Luồng hoạt động: SplitScreen (trên xe) phát tín hiệu qua
  kênh handlewake khi cần gọi app dậy (chạm khi controls đang ẩn /
  sau màn chào); ABWakeView nằm trong app hosted nhận lệnh, phối hợp
  splashGen để chỉ "đánh thức" khi màn chào còn hiệu lực, tránh cửa
  sổ ô hiện sớm/lệch. Chi tiết payload của kênh không lộ qua chuỗi.

### 1.4 Bộ khóa tự-gác-crash của AppBridge
- [BẰNG CHỨNG] 4 khóa prefs MỚI (chỉ AppBridge có):
  `appBridgeBlankHook`, `appBridgeBlankHookCrashed`,
  `appBridgeBlankHookPending`, `appBridgeSpringBoardCrashed`,
  `appBridgeSpringBoardPending` (thực tế 5 khóa kể cả khóa chính).
  Hàm cài hook: `_ABInstallScreenBlankHook` /
  `InstallScreenBlankHook`, vá `BKSDisplayServicesSetScreenBlanked`;
  log `da va BKSDisplayServicesSetScreenBlanked (lan dau host app)`.
- [BẰNG CHỨNG] Chuỗi log cơ chế (nguyên văn):
  - `lan truoc SpringBoard khong len duoc sau khi %@ -> bo buoc nay
    o build %@ (doi cai dat App Bridge de thu lai)`
  - `bo qua %@: tung lam SpringBoard khong len o build %@`
  - `co dau "dang cai" cu (%@) cua build khac, khong tinh cho build
    %@`
  - `doi cai dat -> lan khoi dong sau thu cai hook App Bridge lai`
  - `khong va BKSDisplayServicesSetScreenBlanked: SpringBoard da
    nap %@ (cung va ham nay)`
  - `khong va BKSDisplayServicesSetScreenBlanked: tat bang %@ (thu
    power assertion mot minh)`
- [SUY RA] Cơ chế: trước khi làm bước nguy hiểm (cài hook chống
  trắng màn), ghi khóa `*Pending` kèm **build stamp** (`647a45a`).
  Lần nạp sau: nếu còn dấu Pending của **cùng build** mà quá trình
  trước chết trước khi kịp xóa dấu → kết luận bước đó làm
  SpringBoard không lên → ghi `*Crashed` và **bỏ qua bước đó trong
  toàn bộ build hiện tại**; dấu Pending của build khác bị bỏ qua
  ("khong tinh"). Đổi cài đặt App Bridge là đường mở khóa thử lại.
  Có 2 điểm gác riêng: bản thân hook blank (`BlankHook*`) và sức
  khỏe SpringBoard nói chung (`SpringBoard*`).

### 1.5 `appBridgeDisplayPower`
- [BẰNG CHỨNG] Khóa mới `appBridgeDisplayPower`; ivar
  `T@,&,N,V_displayPowerAssertion`; selector
  `acquireDisplayPower` / `releaseDisplayPower` /
  `setDisplayPowerAssertion:`; gọi
  `createPowerAssertionWithReason:identifier:`; log lỗi
  `power assertion man xe: %@ khong co
  createPowerAssertionWithReason:identifier: (iOS %@)`.
- [SUY RA] Khi host app, AppBridge giữ một power assertion để màn
  hình xe không bị hệ thống tắt/giảm sáng; đây cũng là phương án dự
  phòng khi không cài được hook blank (log "thu power assertion mot
  minh" ở §1.4).

## 2. SPLIT SCREEN

### 2.1 Bốn bố cục mới
- [BẰNG CHỨNG] Khóa chữ mới trong SplitScreen.strings (1.0.3 chỉ có
  _2/_3/_13/_31):
  - `SPLITSCREEN_LAYOUT_12` — EN "1 large top + 2" / VI "1 lớn trên
    + 2"
  - `SPLITSCREEN_LAYOUT_21` — EN "2 + 1 large bottom" / VI "2 + 1
    lớn dưới"
  - `SPLITSCREEN_LAYOUT_22` — EN "2 panes, top / bottom" / VI "2 ô
    trên / dưới"
  - `SPLITSCREEN_LAYOUT_33` — EN "3 rows" / VI "3 hàng"
  (Bốn tên này cũng xuất hiện dạng chuỗi cứng tiếng Anh trong binary
  SplitScreen, cùng nhóm `Landscape layouts` / `Portrait layouts` —
  tức bảng chọn trên xe nhóm bố cục theo hướng màn.)
- [SUY RA] Giá trị/ID số của bố cục = con số trong tên khóa (12, 21,
  22, 33), nhất quán với hệ cũ (2, 3, 13, 31) và với tham số URL
  `omnicar://splitscreen/layout?id=3` trong footer phím tắt. Bốn bố
  cục mới đều là biến thể xếp dọc (trên/dưới, hàng) — phục vụ màn
  Tall/Wide ở §5. Không tìm thấy bảng ánh xạ ID→hình học dạng chuỗi.

### 2.2 `SCPHomeLayoutGrid`
- [BẰNG CHỨNG] Class + hàm C mới `_SCPHomeLayoutGrid`,
  `_SCPHomeIconSide`; selector `iconColumnsForCurrentOrientation`,
  `iconRowsForCurrentOrientation`; ivar nguyên `Tq,N,V_layoutKind`.
  Log: `HomeScreen: luoi deu %lux%lu trong %@ (%@): o %.0fx%.0f, %lu
  icon, dat lai %lu` và `HomeScreen: o luoi %.0fx%.0f -> canh icon
  %.0f pt (Co icon %.0f %%)`.
- [SUY RA] Lưới Home trên xe được tính lại đều theo cột×hàng của
  hướng màn hiện tại, cạnh icon suy từ kích thước ô — khớp mục
  WhatsNew 1.0.4 "Lưới màn chính đều hơn".

### 2.3 `SCPHostedPlaceholderView` và `SCPCWakeView`
- [BẰNG CHỨNG] `SCPHostedPlaceholderView` — class mới, chỉ lộ tên
  class + `PlaceholderView` trong chuỗi (không selector riêng nổi
  bật). `SCPCWakeView` xem §1.3.
- [SUY RA] PlaceholderView là khung giữ chỗ hiển thị trong ô hosted
  khi scene của app đang nạp lại/đã bị hủy (cặp với log phía
  AppBridge "scene cua %@ bi huy -> bo o" và phía SplitScreen
  `CarSplit: scene cua %@ bi huy (app thoat/crash) -> dong ngan %d`).

### 2.4 Khai báo app qua policy evaluator + template UI
- [BẰNG CHỨNG] Chuỗi/selector mới: `CRCarPlayAppPolicyEvaluator`,
  `effectivePolicyForAppDeclaration:inVehicleWithCertificate
  Serial:`, `supportsTemplates`, `setLaunchUsingTemplateUI:`,
  `setLaunchUsingMapsTemplateUI:`. Log tự thú rất rõ:
  `AppIcons: khong co -[CRCarPlayAppPolicyEvaluator
  effectivePolicyForAppDeclaration:...] (%@), giao dien iPhone chi
  qua declaration gia` — tức khi API policy không có, đường dự phòng
  là "declaration giả" (cơ chế cũ kiểu 1.0.3).
- [SUY RA] 1.0.5 ưu tiên hỏi chính sách khai báo thật từ hệ thống
  trước khi quyết định app nào được lên lưới/phóng bằng template UI
  (thường hay Maps template); declaration giả chỉ còn là fallback.

### 2.5 Watchdog núm chia
- [BẰNG CHỨNG] Ivar mới `T@"NSTimer",&,N,V_knobWatchdog` /
  `knobWatchdog` / `setKnobWatchdog:`, cặp với `knobDragging`,
  `knobsVisible`. Nhóm selector mới khác: `handleTimer`,
  `watchSoloLaunch`, `soloHostedAt`,
  `openRememberedPairWhenSplashGone:`.
- [SUY RA] Một NSTimer canh núm divider (kẹt/biến mất thì dựng lại),
  đồng thời canh app chạy đơn lẻ để tự mở lại cặp app đã nhớ khi màn
  chào biến mất.

### 2.6 Nhận diện môi trường jailbreak
- [BẰNG CHỨNG] Chuỗi mới trong SplitScreen: tiền tố bundle
  `com.palera1n`, `org.palera1n`, `com.roothide.`, `io.roothide.`,
  `com.opa334.` (Dopamine), `com.saurik.`, `org.coolstar.`,
  `com.serena.`, `com.tigisoftware.`, `com.ichitaso.`, `com.nito.`,
  `com.rpetrich.`, `net.angelxwind.`, `ws.hbang.`, `xyz.willy.` và
  đường dẫn `/.jbroot`, `/procursus/`, `/var/jb/`.
- [SUY RA] Dùng để lọc app của jailbreak khỏi lưới xe (khớp WhatsNew
  1.0.4: "App của jailbreak không còn lên màn xe") và/hoặc ghi chẩn
  đoán môi trường; đích dùng cụ thể không lộ qua chuỗi.

## 3. SPEED BUBBLE

### 3.1 `SPPSpeedGPS` — nguồn tốc độ GPS nội bộ
- [BẰNG CHỨNG] Class mới, chỉ có trong SpeedBubble. Ivar mới đi kèm:
  `T@"CLLocationManager",&,N,V_mgr`, `T@"CLLocation",&,N,V_last`,
  `Td,N,V_lastUpdate`; dùng delegate
  `locationManager:didUpdateLocations:` và
  `_kCLLocationAccuracyBestForNavigation`. (Các chuỗi CoreLocation
  chung có ở cả 1.0.3, nhưng bộ ivar + class này chỉ có ở 1.0.5.)
- [SUY RA] SPPSpeedGPS bọc CLLocationManager (độ chính xác mức dẫn
  đường) thành một nguồn tốc độ độc lập cạnh 4 nguồn app ngoài
  (Vietmap Live/GOFA/Waze/Wyn), lưu vị trí + mốc cập nhật cuối để
  tính tốc độ hiển thị và cho hiệu chuẩn ở §3.2.

### 3.2 Hiệu chỉnh GPS (calib)
- [BẰNG CHỨNG] Khóa prefs mới `speedBubbleCalibKmh` (có trong
  SpeedBubble + Prefs, dạng `calibkmh` khi ghi specifier); selector
  `calibrate:`.
- [BẰNG CHỨNG] Khóa chữ (SpeedBubble.strings, nguyên văn):
  - `SPEEDBUBBLE_CALIB` — EN "GPS calibration" / VI "Hiệu chỉnh GPS"
  - `SPEEDBUBBLE_CALIB_KMH` — EN "Add / subtract" / VI "Cộng / trừ"
  - `SPEEDBUBBLE_CALIB_FOOTER` — EN "GPS %ld km/h → shows %ld km/h.
    The overspeed warning follows the adjusted number too." / VI
    "GPS %ld km/h → hiện %ld km/h. Cảnh báo quá tốc độ cũng theo số
    đã chỉnh."
  - `SPEEDBUBBLE_CALIB_FOOTER_OFF` — EN "Add or subtract a few km/h
    from the GPS speed, e.g. when the car speedometer reads a little
    higher than GPS." / VI "Cộng hoặc trừ một số km/h vào tốc độ
    GPS, ví dụ khi đồng hồ xe chỉ cao hơn GPS vài km/h."
- [BẰNG CHỨNG] WhatsNew 1.0.5: kéo thanh Hiệu chỉnh GPS "cộng hoặc
  trừ đến 10 km/h" → biên slider ±10 km/h; số đã chỉnh áp cho cả
  cảnh báo vượt tốc.

### 3.3 Kênh `car.area`
- [BẰNG CHỨNG] Kênh Darwin mới `com.anlai.omnicar/car.area` (có ở
  SpeedBubble và SplitScreen); phía SpeedBubble: ivar
  `T{CGRect=...},N,V_carArea` / `setCarArea:` / `areaBounds`, log
  `bubble: vung CarPlay tren man xe %@ (cua so xe %@)`.
- [SUY RA] Phía xe (SplitScreen) gửi hình chữ nhật vùng CarPlay thật
  sang; bong bóng bám/giới hạn trong vùng đó thay vì tự suy đoán
  khung màn hình.

## 4. STARTUP SCREEN

- [BẰNG CHỨNG] Ép khớp khung DashBoard: selector mới
  `fitToViewArea`; ivar `Ti,N,V_fitTries` (số lần thử khớp),
  `TB,N,V_fitted`, `_currentDashboard`. Log nguyên văn:
  `view area %@ in a %@ screen -> splash window fitted to the
  CarPlay box` và `no DashBoard content frame after 3s, splash stays
  full screen`.
- [SUY RA] Khi kết nối, màn chào thử khớp cửa sổ của mình vào khung
  nội dung DashBoard thật (tối đa vài lần/3 giây); không lấy được
  khung thì giữ toàn màn hình.
- [BẰNG CHỨNG] Hai lời gọi tra cứu địa lý theo IP (chỉ có ở
  StartupScreen 1.0.5): `https://ipwho.is/` và
  `https://ipapi.co/json/` — đầy đủ nguyên văn như trong binary;
  kèm chuỗi log `%@, HTTP %ld, answer %@` / `http %ld %@` cho thấy
  có đọc mã HTTP và nội dung trả lời.
- [SUY RA] Hai dịch vụ dự phòng lẫn nhau để lấy vị trí quốc gia/thành
  phố theo IP (phục vụ mục thời tiết/vùng trên màn chào khi không có
  GPS) — đích dùng cụ thể không lộ qua chuỗi.
- [BẰNG CHỨNG] Kênh `com.anlai.omnicar/splash` có ở AppBridge,
  SplitScreen và StartupScreen (1.0.3 không có): kênh chung báo
  trạng thái màn chào cho cơ chế wake/gate ở §1.3.

## 5. LOẠI MÀN HÌNH (mục của 1.0.4: Auto / Wide / Tall, dock dưới)
- [BẰNG CHỨNG] Nội dung chính chủ (WhatsNew.strings
  `WN_104_SQUARE_*`): EN "Split Screen fits 850x800 and portrait
  screens with the dock at the bottom. Choose the screen type:
  Auto, Wide or Tall." / VI "Chia màn hình hợp với màn 850x800 và
  màn dọc, dock ở dưới. Chọn Loại màn hình: Tự động, Ngang hoặc
  Dọc."
- [BẰNG CHỨNG] Selector MỚI duy nhất liên quan: `screenKind` — chỉ
  có trong SplitScreen 1.0.5 (nằm trong bảng selector của binary,
  không có ở 1.0.3), cùng nhóm selector về scene (`sceneSize`,
  `sceneOfViewController:`).
- [BẰNG CHỨNG — kết quả âm] KHÔNG tìm thấy khóa prefs riêng cho loại
  màn hình: rà toàn bộ chuỗi của Core/SplitScreen/Prefs không có
  khóa dạng `*screenType*`/`*displayType*`/`*aspect*`, và không có
  khóa chữ UI riêng cho mục này trong bất kỳ .strings nào; cả 3
  Feature*.plist không đổi so với 1.0.3 nên mục này không nằm trong
  plist tĩnh.
- [SUY RA] Loại màn hình nhiều khả năng được suy từ hình học scene
  (qua `screenKind`) với lựa chọn người dùng nằm trong giao diện xây
  bằng code của trang Split Screen (cùng trang chứa các mục code như
  bố cục yêu thích) — nhưng tên khóa và trang chứa cụ thể KHÔNG xác
  định được từ chuỗi. Log phía SplitScreen có ghi nhận dock theo
  khung nội dung: `dock theo contentView`,
  `dockHostForRect:inParent:horizontal:` → vị trí dock (dưới/ngang)
  được tính từ hình học thật của cửa sổ xe.

## 6. LỚP GÁC CRASH TOÀN HỆ — `OMCCrashGuard` / `OMCGuard`

- [BẰNG CHỨNG] Hai class mới xuất hiện trong **cả 6 binary**:
  `OMCCrashGuard`, `OMCGuard` (kèm symbol `_OMCCrashGuard`, hằng
  `OMC_CRASHGUARD`). Tệp trạng thái dùng chung: `OmniCar-crashguard.
  plist` và tệp ghi nhận crash phía CarPlay
  `OmniCar-CarPlay-crash.txt` (cả hai có trong Core, AppBridge,
  SplitScreen). Thư mục dữ liệu mới `/var/mobile/Library/OmniCar`
  cũng có trong mọi module.
- [BẰNG CHỨNG] Định dạng log crash dùng chung:
  `omc-crash age=%ld suspect=%s last=%s how=%s` (tuổi của vụ crash,
  nghi phạm, bước cuối, cách chết) và khóa chẩn đoán `diagLastCrash`
  (có cả ở Prefs). Phía Prefs có nhóm khóa chữ sức khỏe hệ thống:
  `CHK_CRASH`, `CHK_CRASH_AT`, `CHK_CRASH_FIX`, `CHK_CRASH_NONE`,
  `CHK_CRASH_SUSPECT`.
- [BẰNG CHỨNG] Chuỗi Core: `CarPlay crashed %d times in a row right
  after connecting, so OmniCar turned off: %@.` — đếm crash liên
  tiếp ngay sau khi kết nối xe; quá ngưỡng thì **tự tắt OmniCar**
  kèm lý do.
- [BẰNG CHỨNG] Toàn bộ khóa `*Crashed`/`*Pending` trong 1.0.5:
  - AppBridge (MỚI cả bộ): `appBridgeBlankHookCrashed`,
    `appBridgeBlankHookPending`, `appBridgeSpringBoardCrashed`,
    `appBridgeSpringBoardPending` (+ khóa chính
    `appBridgeBlankHook`) — cơ chế ở §1.4.
  - SplitScreen: `splitScreenIconsCrashed`,
    `splitScreenIconsPending` — **đã có từ 1.0.3** (kiểm lại tập
    chuỗi 1.0.3: có cả hai), nhưng ở 1.0.5 được đặt trên nền
    CrashGuard chung; log mới nguyên văn: `AppIcons: lan truoc
    CarPlay sap sau khi chen icon -> tat chen icon o build %@ (doi
    danh sach app de thu lai)`, `AppIcons: dang tat vi tung sap o
    build %@`, `AppIcons: co dau "dang chen" cu (%@) cua build khac,
    khong tinh cho build %@`.
  - Các module còn lại (Core, SpeedBubble, StartupScreen, app
    companion): không có khóa `*Crashed`/`*Pending` riêng — chúng
    dùng tệp crashguard chung + `diagLastCrash`. (`licenseKey
    Pending` thuộc hệ bản quyền, `pendingTrial`/`_stopPending`/
    `_dismissStuckPending` là trạng thái UI/thao tác, không thuộc
    lớp gác crash.)
- [SUY RA] Mô hình chung của lớp gác: mỗi bước nguy hiểm được bọc
  theo mẫu **đánh dấu Pending + build stamp → sống sót thì xóa dấu →
  chết khi đang có dấu thì lần nạp sau ghi Crashed và tắt riêng
  bước đó cho cả build**, mở khóa bằng cách người dùng đổi cài đặt
  liên quan. 1.0.5 chuẩn hoá mẫu này (vốn chỉ có lẻ cho việc chèn
  icon ở 1.0.3) thành class dùng chung OMCCrashGuard cho mọi module,
  cộng thêm bộ đếm crash CarPlay liên tiếp để tự tắt toàn cục khi xe
  crash lặp ngay sau kết nối.

---
Phạm vi: chỉ các tính năng MỚI ngoài hệ bản quyền, đào tới mức chuỗi
cho phép. Mọi khẳng định cơ chế đều tách [BẰNG CHỨNG]/[SUY RA];
payload của các kênh Darwin và hình học chính xác của bố cục không
lộ qua chuỗi nên không suy đoán thêm.
