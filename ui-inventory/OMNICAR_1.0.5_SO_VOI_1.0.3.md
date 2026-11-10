# OMNICAR 1.0.5 SO VỚI 1.0.3 — CÓ THÊM NHỮNG GÌ

Quét 2026-11-10, chỉ đọc (không chạy binary). Deb 1.0.5:
`com.anlai.omnicar_1.0.5_iphoneos-arm64.deb`, 1.438.672 B,
SHA-256 `189444dc…65562`. Đối chiếu với deb gốc 1.0.3
(`d9297b01…76d9fd`) bằng 3 đường độc lập: (A) plist/strings Cài đặt +
WhatsNew · (B) binary (class/khóa/kênh) · (C) vỏ gói. Các điểm chính đã
kiểm chứng lại trực tiếp trên binary trước khi ghi.

## 0. TỔNG HÌNH

- Cây file gần như nguyên: 176 → 174 file; delta duy nhất ở cấp file là
  **mất `OmniCarCarProbe.dylib` + plist lọc** (xem §8 — không mất tính
  năng).
- Cả 6 binary còn lại đều phình: Prefs **+217 KB**, SplitScreen
  **+168 KB**, AppBridge **+119 KB**, Core **+101 KB**, StartupScreen
  **+69 KB**, SpeedBubble **+69 KB**; app companion −64 B.
  Installed-Size 6160 → 6668 KB. Kiến trúc giữ nguyên FAT arm64+arm64e.
- 15/15 PNG khớp từng byte với 1.0.3; 5 plist lọc MobileSubstrate khớp
  từng byte (không nạp vào process mới nào); không maintainer script ở
  cả hai bản.

## 1. MỚI LỚN NHẤT — HỆ THỐNG BẢN QUYỀN ONLINE (1.0.3 không có)

- Máy chủ kích hoạt `https://omnicar-license.omnicar-tweak.workers.dev`
  (có trong cả 6 binary 1.0.5; 1.0.3: 0). Xác thực chữ ký EC
  (ECDSA/SHA256) + 2 mã băm ghim sẵn; gắn key với thiết bị qua số seri /
  UUID / UDID.
- Mô hình bán: key dạng `OMC-XXXX-…`, **1 key 1 máy**, **dùng thử
  1 ngày/máy**, có trạng thái **ân hạn offline**; trang mua trong Cài
  đặt ghi giá **99.000đ**, mua qua Zalo/Facebook ("Hoàng An"), chuyển
  khoản, "trả 1 lần dùng vĩnh viễn". 61 khóa chữ LICENSE_* + 2
  controller mới `OMCLicenseController`, `OMCLicenseBuyController`.
- Cài đặt có thêm: nhóm **"Bản quyền"** ở trang gốc + nút **Kích hoạt
  OmniCar** + nút **Liên hệ** (cuối trang, sau Gửi log); email
  `omnicartweak@gmail.com` được nối vào chân nhóm hỗ trợ.
- 4 kênh Darwin mới ở Core/Prefs: `com.anlai.omnicar/license.activate`,
  `.done`, `.probe`, `.trial`; khóa mới `licenseKeyPending`,
  `licenseProbe`, `licenseResult`.
- **Cổng chặn nằm trong tính năng:** chưa kích hoạt thì AppBridge không
  host app, SplitScreen không chia màn, StartupScreen bỏ qua màn chào
  (còn sót chuỗi log tiếng Việt đánh dấu "(4.1)" trong bản phát hành).
- Trạng thái lỗi đầy đủ: key bị thu hồi / đã dùng máy khác / hết dùng
  thử / token sai / sai thiết bị… (10 lỗi máy chủ có khóa chữ riêng).

## 2. HẠN DÙNG CỨNG BỊ GỠ

- 1.0.3: hết hạn cứng 01/05/2027 (chuỗi `"2027-04-30"` + 86400 s, có
  2 bản trong Core). 1.0.5: chuỗi này **biến mất khỏi cả 6 binary**
  (kiểm chứng trực tiếp: 0 kết quả), không có ngày thay thế — thời hạn
  nay do token bản quyền (`expires` từ máy chủ) quyết. Khóa chống lùi
  giờ `trustedTime` vẫn còn.

## 3. APP BRIDGE — TÙY CHỌN TỪNG APP (mới)

- Trang con mới `OMCAppBridgeAppOptionsController`: **ép giao diện
  iPhone cho app CarPlay** (app CarPlay gốc hiển thị theo giao diện
  iPhone thay vì template xe; có badge đánh dấu trong danh sách app).
- **Cỡ app 60–100%, mặc định 80%** — chính là khóa `appBridgeZoom` vốn
  "mồ côi" ở 1.0.3 (có nơi đọc, không giao diện ghi) nay có giao diện;
  khóa gộp mới `appBridgeAppOptions` = hướng + zoom **riêng từng app**.
  Cả hai tùy chọn cần respring.
- Class mới `ABWakeView` + kênh `appbridge.handlewake` — view đánh thức
  trong app được host.
- Chống trắng màn: hook khóa màn hình hiển thị có **tự gác crash theo
  từng bản build** (`appBridgeBlankHook{,Crashed,Pending}`,
  `appBridgeSpringBoard{Crashed,Pending}`); assertion giữ màn xe sáng
  (`appBridgeDisplayPower`); khóa hướng scene khi phóng app.
- Nhận diện xung đột thêm CarPlay Cast (khớp Conflicts +6 gói, §9).

## 4. SPLIT SCREEN — 4 BỐ CỤC MỚI + LƯỚI HOME THẬT

- **4 kiểu bố cục mới thiên về xếp dọc:** `LAYOUT_12` (1 ô lớn trên +
  2 ô), `LAYOUT_21` (2 ô + 1 lớn dưới), `LAYOUT_22` (2 ô trên/dưới),
  `LAYOUT_33` (3 hàng) — bên cạnh các kiểu 2/3/13/31 cũ. Tên bố cục
  tiếng Anh mới trong binary: "1 large left + 2", "2 panes,
  top/bottom"…
- Class mới `SCPHomeLayoutGrid` — bộ máy lưới Home trên xe thật + bảng
  chọn bố cục ngay trên xe; `SCPHostedPlaceholderView` — khung giữ chỗ
  cho ô hosted; `SCPCWakeView` — view đánh thức phía chia màn.
- Phóng app đổi cơ chế: khai báo qua `CRCarPlayAppPolicyEvaluator`,
  phóng bằng template UI (`setLaunchUsingTemplateUI/MapsTemplateUI`).
- Watchdog cho núm chia (knob); tự mở lại cặp app sau khi màn chào kết
  thúc; nhận diện môi trường jailbreak (palera1n / roothide / Dopamine)
  để xử lý riêng.

## 5. SPEED BUBBLE — NGUỒN GPS MỚI + HIỆU CHỈNH GPS

- Class mới `SPPSpeedGPS` — **nguồn tốc độ GPS trực tiếp** của chính
  OmniCar (các chuỗi đọc tốc độ cũ kiểu `CurrentSpeed`,
  `vml_main_channel` biến mất).
- Khóa mới `speedBubbleCalibKmh` + slider **Hiệu chỉnh GPS ±10 km/h**
  trong Cài đặt: cộng/trừ vào tốc độ GPS cho khớp đồng hồ xe; cảnh báo
  vượt tốc tính theo số đã hiệu chỉnh (kiểm chứng: khóa có 2 bản trong
  binary SpeedBubble 1.0.5).
- Kênh mới `car.area` — bong bóng bám theo vùng CarPlay thật.

## 6. STARTUP SCREEN

- Ép màn chào khớp khung DashBoard của xe (`fitToViewArea`); kênh mới
  `splash`.
- Thời tiết có **định vị dự phòng theo IP** khi không có vị trí:
  gọi `https://ipwho.is/` (và ipapi.co theo khóa chữ) — 1.0.3 không có
  lời gọi mạng này.

## 7. PHẦN CỦA 1.0.4 (1.0.5 bao gồm, đều mới so với 1.0.3 — theo WhatsNew chính chủ)

1. **iOS 15 chạy tốt hơn:** xoay đúng trên iPhone 7/8/X, YouTube toàn
   màn hết xoay lệch, hết kẹt logo Apple.
2. **Màn xe vuông và dọc:** hỗ trợ màn tỉ lệ lạ (vd 850×800), dock
   xuống dưới; cài đặt **Loại màn hình: Tự động / Rộng / Dọc**.
3. **Lưới màn chính đều hơn:** icon dàn đều theo cột × hàng đã chọn;
   app jailbreak không bị đưa lên xe.
4. **Bong bóng tốc độ:** GOFA đọc đúng biển báo; mỗi nguồn tốc độ có
   một bộ đọc riêng.
   (Một mục What's New về Ủng hộ/Liên hệ — khóa `WN_104_DONATE_*` —
   đã dịch sẵn nhưng bị bỏ khỏi danh sách hiển thị của 1.0.4.)

## 8. CARPROBE BIẾN MẤT — KHÔNG MẤT TÍNH NĂNG

CarProbe 1.0.3 chỉ là injector mỏng nạp lõi OMC dùng chung vào
CarPlayApp: class `OMCPerfTicker`, kênh `perf` và các khóa `diag*` đều
thuộc lõi chung, đã có trong mọi module 1.0.3 và còn nguyên trong mọi
module 1.0.5; 32 chuỗi riêng của nó chỉ là định danh + nhiễu. CarPlayApp
vẫn được SplitScreen/StartupScreen/SpeedBubble nạp như cũ → 1.0.5 gỡ
một injector thừa, không gỡ tính năng. Đồng thời lớp gác crash được
chuẩn hoá toàn hệ: class dùng chung mới `OMCCrashGuard`/`OMCGuard`
xuất hiện ở mọi module (không class nào của 1.0.3 bị mất). Thư mục dữ
liệu mới `/var/mobile/Library/OmniCar`. Build stamp đổi
`fbebb21` → `647a45a`. Tổng: **9 kênh Darwin mới, 0 kênh mất**.

## 9. VỎ GÓI

- **Conflicts thêm 6 gói** (chỉ xung đột, không thay thế):
  `com.leemin.carbridge`, `com.ethanarbuckle.carplay-cast`,
  `com.leftyfl1p.carbridge13`, `com.bvn.carbridge13`,
  `com.bvn.carbridge13.vn`, `com.cortex.carplayenable`. Replaces giữ
  nguyên 5 gói cũ.
- **Description KHÔNG đổi** — văn quảng cáo dài đã có nguyên văn từ
  1.0.3 (đính chính: không phải điểm mới của 1.0.5). Control chỉ khác
  đúng 3 trường: Conflicts, Version, Installed-Size.
- App companion: bị gỡ entitlement `platform-application` khỏi chữ ký
  nhúng (executable co đúng 64 B khớp khối bị gỡ); Info.plist chỉ đổi
  version — URL scheme vẫn chỉ `omnicar`, không background mode, không
  usage-description ở cả hai bản.
- Mục **Ủng hộ (DONATE_*)** có 6 khóa chữ nhưng chuỗi cho thấy chưa có
  phương thức ủng hộ cụ thể trong bản này — tính năng để dành.

## 10. HƯỚNG DẪN (ONBOARDING) 4 → 8 TRANG

13 khóa chữ mới, 9 khóa đổi: trang 2 nay là "App iPhone" (chính tính
năng §3), thêm trang Màn hình khởi động, Màn chính & hồ sơ xe, Mẹo &
hỗ trợ, và trang Cảm ơn kết thúc.

---
Hồ sơ chi tiết 3 đường rà: `~/workspace/omnicar-105/audit/agent-a-prefs.md`,
`agent-b-binary.md`, `agent-c-shell.md` (2026-11-10). Đối chiếu tĩnh
chỉ đọc; tính năng suy ra từ binary/strings/changelog chính chủ, chưa
chạy thử trên xe.
