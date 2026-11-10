# KIỂM KÊ TOÀN DIỆN GIAO DIỆN — OmniCar 1.0.3 (bản gốc)

**Mục đích:** bản kê tất tần tật về thể hiện giao diện của deb gốc OmniCar 1.0.3 — hình ảnh, hình vẽ,
symbol, icon, nút logo, màu, chữ, kích thước, hiệu ứng — làm chất liệu để thiết kế giao diện mới.
**Chỉ đọc/thống kê:** không sửa code, không build, không chạy binary đã bóc.

**Nguồn (đã đối chiếu):**
- Deb gốc `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, SHA-256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd` (payload 176 file, khớp manifest từng byte).
- Source phục hồi `recovered-source/src` tương ứng cây `~/workspace/omnicar-re/src` (207 file .m/.h, 11 module; 66 lớp / 1.872 phương thức đã phục hồi).
- Số đo các phiên xe thật (hl3–hl6) trong PATCH_NOTES §29 — chỉ dùng khi gắn nhãn [ĐO-XE].

**Cách đọc nhãn bằng chứng (giữ nguyên từ các bản kê thành phần):**
- **VERIFIED** — đọc trực tiếp từ file/source phục hồi đã đối chiếu disasm/plist.
- **[ĐO-XE]** — số đo/log từ xe thật, ưu tiên hơn suy luận source khi hai bên lệch (mâu thuẫn được kê riêng ở Phần 3 §11).
- **INFERRED / PARTIAL** — source tự ghi suy luận hoặc phục hồi chưa trọn; **CHƯA PHỤC HỒI / UNRECOVERED** — chưa có dữ kiện.
- **[CÂY-HL] / [tái tạo]** — phần thuộc cây tái tạo hoặc các vòng hl về sau (Muse/GPT thêm), KHÔNG phải gốc 1.0.3; khi thiết kế trên gốc thì bỏ qua.

**Cấu trúc:** Phần 1 tài sản hình ảnh · Phần 2 vẽ bằng code · Phần 3 chrome & điều khiển trên xe ·
Phần 4 hệ thống thị giác (tokens) · Phần 5 bàn phím tự vẽ + Prefs UI + popup/shield ·
Phần 6 điểm can thiệp thiết kế · Phần 7 độ phủ, errata và khoảng trống chưa phục hồi ·
Phụ lục A bản kê bổ sung (lấp khoảng trống của verifier) · Phụ lục B báo cáo verifier độc lập.
Thư mục `assets/` cạnh file này chứa 15 file PNG tĩnh trích nguyên byte từ deb + `SHA256SUMS.tsv`.

## Tổng số toàn cục (đã qua verifier độc lập — Phần 7)

| Hạng mục | Số lượng |
|---|---|
| File tĩnh hình ảnh trong deb | **15 PNG / 279.667 B** (100% có checksum, khớp bản gốc) |
| Nhóm tài sản runtime ngoài bundle | 5 nhóm (logo splash, video splash + khung JPG, ảnh Home ×2, video Home) |
| Dylib mang giao diện | 6 dylib, tổng 3.580.512 B (+ app companion + Prefs bundle) |
| Mục vẽ bằng code (Phần 2) | **101 mục** (24 shape/layer/gradient · 16 glyph chép đủ toạ độ · 15 SpeedBubble · 13 StartupScreen · 11 Prefs preview · symbol + text-symbol) |
| Phần tử chrome trên xe (Phần 3) | **39 mục** / 10 nhóm, kê cả bản chính (CarPlayApp) lẫn bản mirror (SpringBoard) |
| Màu phân biệt | 102 literal RGBA + **60 hex** (xem errata E3) + 51 cặp trắng–alpha |
| Font | ~30 cặp (size, weight) — 100% system font, 0 font file |
| Bo góc / border | ~25 giá trị cornerRadius / 7 giá trị borderWidth |
| Thời gian animation | 14 duration UIView + ~10 duration CA phân biệt |
| Bàn phím tự vẽ | **44 phím** (chế độ chữ) / **43** (chế độ số), 5 hàng + 2 nút header |
| Prefs UI | 8 trang/bề mặt + 2 modal, **≈105 hàng điều khiển** |
| Bản địa hoá bề mặt chữ | 10 bảng × 14 ngôn ngữ; en 602 key, vi 480 key, cộng dồn 7.466 key |
| SF Symbols | 32 call site trực tiếp + các bảng tên theo plist/thời tiết/đèn báo (≈70 tên qua bộ `OMCIcon`) |
| Độ phủ sau verifier + lấp khoảng trống | **≈90% → các khoảng G1–G8 đã lấp**; còn lại là các hàm INFERRED/PARTIAL liệt kê ở Phần 7 |

---

## Phần 1 — Tài sản hình ảnh tĩnh, runtime và hệ thống mượn


Phạm vi: chỉ đọc/thống kê. Nguồn: `payload/` (đã đối chiếu SHA với deb gốc
`d9297b01…76d9fd`, xem INVENTORY.md), source phục hồi `src/`, strings nhị phân
(chỉ đọc), `final/assets-checksums.tsv` (khớp 15/15 SHA dưới đây).

## Kết quả xác minh định dạng (toàn deb)

- Toàn payload 176 file chỉ có 5 họ đuôi: `.strings` ×139, `.png` ×15,
  `.plist` ×14, `.dylib` ×6, không đuôi ×2 (Mach-O). **Không có** JPG/JPEG,
  PDF, `.car`/Assets.car, GIF, SVG, storyboard/nib nào.
- Quét magic bytes: không file phi-PNG nào chứa magic PNG/JPEG; hai hit
  chuỗi `.car` trong binary là substring của chữ khác (vd `…/OMCCar…`),
  không phải asset catalog.
- Cả 15 PNG đều: PNG 8-bit, color type 6 (RGBA), non-interlaced, **có
  alpha**. Không PNG nào nhúng trong plist/strings (139 `.strings` + 14
  plist đều là binary plist thuần văn bản/cấu hình).

## A. Tĩnh trong deb — [tĩnh-trong-deb] (15 file)

### AppIcon60x60@2x.png
Loại: [tĩnh-trong-deb] — icon app OmniCar.app (SpringBoard/CarPlay)
Đặc tả số: `var/jb/Applications/OmniCar.app/AppIcon60x60@2x.png` · 120×120 px = 60×60 pt @2x · 24.659 B · SHA-256 `b304145f7002c44d0e33b43c30886510ce6c97c6e215cad36f938f63827fb164` · RGBA, alpha có
Neo source: chỉ hệ thống dùng — `OmniCar.app/Info.plist`: `CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles = [AppIcon60x60]`, `UIPrerenderedIcon = true`; không code nào nạp trực tiếp
Điểm can thiệp: thay file ảnh (giữ tên/kích thước)
Mức bằng chứng: verified-từ-file

### AppIcon60x60@3x.png
Loại: [tĩnh-trong-deb] — icon app OmniCar.app
Đặc tả số: `var/jb/Applications/OmniCar.app/AppIcon60x60@3x.png` · 180×180 px = 60×60 pt @3x · 44.470 B · SHA-256 `bab820c8bd04975393d268ac3ea9e1dd8665a317a0eab4dbe9a6d1f62381da00` · RGBA, alpha có
Neo source: chỉ hệ thống dùng — cùng khai báo `Info.plist` như bản @2x ở trên
Điểm can thiệp: thay file ảnh (giữ tên/kích thước)
Mức bằng chứng: verified-từ-file

### PackageIcon.png
Loại: [tĩnh-trong-deb] — icon gói cho Sileo/trình quản lý gói + logo splash dự phòng thứ nhất
Đặc tả số: `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png` · 256×256 px (không hậu tố scale; nạp theo đường dẫn nên hệ thống coi là @1x) · 74.767 B · SHA-256 `e8663a8b360c85c9b151e354d7bc62262e5b18edada7bc80c52cb32095ee972c` · RGBA, alpha có
Neo source: (1) trường `Icon:` trong DEBIAN/control trỏ `file:///var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png` (hệ thống/Sileo dùng); (2) `src/StartupScreen/SSStartupViewBuilders.m:935-936` — cảnh splash Logo: `OMCRealPath("/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png")` → `imageWithContentsOfFile:`, hiện ở khung 300×300·k
Điểm can thiệp: thay file ảnh (một file phục vụ 2 nơi: icon gói + splash)
Mức bằng chứng: verified-từ-file + verified-từ-source

### icon.png
Loại: [tĩnh-trong-deb] — icon mục OmniCar trong Settings (PreferenceLoader)
Đặc tả số: `…/OmniCarPrefs.bundle/icon.png` · 29×29 px = 29×29 pt @1x · 2.481 B · SHA-256 `db186260d10b29bcfcf48d8fb2e1ecd346fd60c13eb31c7a4130b29ee58450bd` · RGBA, alpha có
Neo source: chỉ hệ thống dùng — `var/jb/Library/PreferenceLoader/Preferences/OmniCarPrefs.plist`: `entry.icon = "icon.png"`; PreferenceLoader tự chọn biến thể theo scale
Điểm can thiệp: thay file ảnh
Mức bằng chứng: verified-từ-file

### icon@2x.png
Loại: [tĩnh-trong-deb] — icon Settings, biến thể @2x
Đặc tả số: `…/OmniCarPrefs.bundle/icon@2x.png` · 58×58 px = 29×29 pt @2x · 7.968 B · SHA-256 `473c7dc85b502977bd4d5b19b672ed30ad76e6d2a219a66abf416b66804dc073` · RGBA, alpha có
Neo source: chỉ hệ thống dùng — cùng `entry.icon = "icon.png"` như trên
Điểm can thiệp: thay file ảnh
Mức bằng chứng: verified-từ-file

### icon@3x.png
Loại: [tĩnh-trong-deb] — icon Settings, biến thể @3x
Đặc tả số: `…/OmniCarPrefs.bundle/icon@3x.png` · 87×87 px = 29×29 pt @3x · 14.988 B · SHA-256 `0d4e4682b382861ef68b2cf48cc33ee12b8b9fad1357d6299aef6bd7227d6360` · RGBA, alpha có
Neo source: chỉ hệ thống dùng — cùng `entry.icon = "icon.png"` như trên
Điểm can thiệp: thay file ảnh
Mức bằng chứng: verified-từ-file

### logo.png
Loại: [tĩnh-trong-deb] — logo thương hiệu trên thẻ header của trang Settings gốc (OMCHeaderCard)
Đặc tả số: `…/OmniCarPrefs.bundle/logo.png` · 64×64 px = 64×64 pt @1x · 9.406 B · SHA-256 `7077849cb7ce87b43a56bf52cceacf6ebd28f79837d12c16beaae3838a92b27a` · RGBA, alpha có
Neo source: `src/Prefs/OMCPrefs/OMCHeaderCard.m:47` — `-[OMCHeaderCard initWithFrame:]`: `[UIImage imageNamed:@"logo" inBundle:bundleForClass]`, `contentMode = ScaleAspectFit`
Điểm can thiệp: thay file ảnh (cả bộ 3 scale phải cùng hình)
Mức bằng chứng: verified-từ-file + verified-từ-source

### logo@2x.png
Loại: [tĩnh-trong-deb] — logo header Settings, biến thể @2x
Đặc tả số: `…/OmniCarPrefs.bundle/logo@2x.png` · 128×128 px = 64×64 pt @2x · 27.891 B · SHA-256 `9e234f6a399cd603e34050d5b623ae68c31e352b63dbaeb57aaa5a82ece1c232` · RGBA, alpha có
Neo source: cùng điểm nạp `imageNamed:@"logo"` tại `OMCHeaderCard.m:47` (UIImage tự chọn scale)
Điểm can thiệp: thay file ảnh
Mức bằng chứng: verified-từ-file + verified-từ-source

### logo@3x.png
Loại: [tĩnh-trong-deb] — logo header Settings @3x + logo splash dự phòng thứ hai
Đặc tả số: `…/OmniCarPrefs.bundle/logo@3x.png` · 192×192 px = 64×64 pt @3x · 48.665 B · SHA-256 `d6407325dca6ec9f864dfc7b0906930015a702318f851a9d7c30782fdfd4ba08` · RGBA, alpha có
Neo source: (1) `imageNamed:@"logo"` tại `OMCHeaderCard.m:47`; (2) `src/StartupScreen/SSStartupViewBuilders.m:938-939` — chỉ khi PackageIcon.png nạp hỏng mới lùi xuống file này (đường dẫn cứng, qua `OMCRealPath`)
Điểm can thiệp: thay file ảnh
Mức bằng chứng: verified-từ-file + verified-từ-source

### SpeedBubbleIcon.png
Loại: [tĩnh-trong-deb] — icon tính năng Speed Bubble (KHÔNG tìm được nơi dùng — xem Ghi chú khoảng trống)
Đặc tả số: `…/OmniCarPrefs.bundle/SpeedBubbleIcon.png` · 29×29 px = 29×29 pt @1x (cùng khổ lưới icon Settings 29 pt) · 2.092 B · SHA-256 `3b63f8510689c9393936b96eb85f67dd9a36591af6a5000958d67b80a9b33156` · RGBA, alpha có
Neo source: không có — không chuỗi `SpeedBubbleIcon` nào trong cả 8 binary (quét strings) lẫn `src/`; hàng Speed Bubble trong danh sách tính năng dùng SF Symbol `speedometer` từ `FeatureSpeedBubble.plist` (`featureSymbol`) qua bộ vẽ `OMCIcon` (`OMCRootListController.m:102-103`, `OMCCommon.m:374`)
Điểm can thiệp: thay file ảnh KHÔNG có tác dụng nếu không nối lại code/plist; muốn dùng phải thêm khoá `featureIcon` vào FeatureSpeedBubble.plist (cơ chế đã có sẵn: `featureIcon` → property `icon` → `imageNamed:inBundle:` tại `OMCCommon.m:379`)
Mức bằng chứng: verified-từ-file; nơi dùng = chưa phục hồi/không tồn tại trong bản 1.0.3 đã phục hồi

### SpeedBubbleIcon@2x.png
Loại: [tĩnh-trong-deb] — biến thể @2x của mục trên (không nơi dùng)
Đặc tả số: `…/OmniCarPrefs.bundle/SpeedBubbleIcon@2x.png` · 58×58 px = 29×29 pt @2x · 4.963 B · SHA-256 `615f6f8beea12ddb419ba850e31696fc8d9d8cf023fc9e1d77d489e80c7dfc18` · RGBA, alpha có
Neo source: không có (như SpeedBubbleIcon.png)
Điểm can thiệp: như mục trên
Mức bằng chứng: verified-từ-file; nơi dùng chưa phục hồi

### SpeedBubbleIcon@3x.png
Loại: [tĩnh-trong-deb] — biến thể @3x của mục trên (không nơi dùng)
Đặc tả số: `…/OmniCarPrefs.bundle/SpeedBubbleIcon@3x.png` · 87×87 px = 29×29 pt @3x · 7.688 B · SHA-256 `ecc7e132e77729c009c11153afa2fad2bd7832e44f9271c80f98076b35b0c43b` · RGBA, alpha có
Neo source: không có (như SpeedBubbleIcon.png)
Điểm can thiệp: như mục trên
Mức bằng chứng: verified-từ-file; nơi dùng chưa phục hồi

### StartupScreenIcon.png
Loại: [tĩnh-trong-deb] — icon tính năng Startup Screen (KHÔNG tìm được nơi dùng)
Đặc tả số: `…/OmniCarPrefs.bundle/StartupScreenIcon.png` · 29×29 px = 29×29 pt @1x · 1.567 B · SHA-256 `8912542026dd6b1d8af665721cb71550a225d0c9a3e3f6096878ca91811ffe90` · RGBA, alpha có
Neo source: không có — không chuỗi `StartupScreenIcon` trong binary/`src/`; hàng Startup Screen dùng SF Symbol `play.rectangle.fill` từ `FeatureStartupScreen.plist` (`featureSymbol`) qua `OMCIcon` như Speed Bubble
Điểm can thiệp: thay file ảnh không có tác dụng; nối lại bằng khoá `featureIcon` trong FeatureStartupScreen.plist nếu muốn dùng
Mức bằng chứng: verified-từ-file; nơi dùng = chưa phục hồi/không tồn tại trong bản đã phục hồi

### StartupScreenIcon@2x.png
Loại: [tĩnh-trong-deb] — biến thể @2x của mục trên (không nơi dùng)
Đặc tả số: `…/OmniCarPrefs.bundle/StartupScreenIcon@2x.png` · 58×58 px = 29×29 pt @2x · 3.150 B · SHA-256 `02068cf8c3a7cae437f16cb40eeba7e284f276dd8b2a98382e4a3982da43fda8` · RGBA, alpha có
Neo source: không có (như StartupScreenIcon.png)
Điểm can thiệp: như mục trên
Mức bằng chứng: verified-từ-file; nơi dùng chưa phục hồi

### StartupScreenIcon@3x.png
Loại: [tĩnh-trong-deb] — biến thể @3x của mục trên (không nơi dùng)
Đặc tả số: `…/OmniCarPrefs.bundle/StartupScreenIcon@3x.png` · 87×87 px = 29×29 pt @3x · 4.912 B · SHA-256 `1bfc0b7305f3ec4c1e12252329ed0da12d6c956d0fce76eae41381639d3c86cf` · RGBA, alpha có
Neo source: không có (như StartupScreenIcon.png)
Điểm can thiệp: như mục trên
Mức bằng chứng: verified-từ-file; nơi dùng chưa phục hồi

## B. Ảnh runtime ngoài bundle — [runtime-người-dùng]

Gốc dữ liệu: `/var/mobile/Library/OmniCar/` (mọi đường dẫn đều qua
realpath/libroot để tương thích rootless). Không file nào trong nhóm này
có trong deb; vắng file luôn có hành vi mặc định, không crash.

### StartupScreen/Logo/logo.png (logo splash tuỳ biến)
Loại: [runtime-người-dùng] — logo người dùng cho splash style Logo (style 1)
Đặc tả số: đường dẫn `/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png` · PNG do app tự ghi: cạnh dài nhất ≤1024 px, scale 1, không opaque (giữ alpha), quyền 0644 — thông số ghi tại `saveLogoImage:` (dưới đây); file nguồn người dùng chọn: bất kỳ ảnh nào Photos/Files đưa được
Neo source: GHI — `src/Prefs/OMCPrefs/OMCStartupScreenController.m:1202-1231` `-saveLogoImage:` (nén cạnh ≤1024, `UIImagePNGRepresentation`), vào từ `chooseLogo` (:1168), `imagePickerController:didFinishPickingMediaWithInfo:` (:1056-1059) và `documentPicker:` (:1084); XOÁ — `-deleteLogo` :1233-1243. ĐỌC — `src/StartupScreen/SSStartupScreen.m:68` `SSLogoPath()` → `SSSplash.m:91` `SSLoadImageAtPath` (ImageIO, `SSStartupScreen.m` sub_5a5c); bản Prefs đọc lại để xem trước tại `OMCStartupScreenController.m:679-680`
Điểm can thiệp: thay file ảnh tại đúng đường dẫn (hoặc qua nút chọn logo trong Settings); đổi giới hạn 1024 px tại `saveLogoImage:`
Mức bằng chứng: verified-từ-source
Mặc định khi vắng: splash rơi xuống glyph SF Symbol `car.fill` (`SSSplash.m:91` log "no logo at …, showing the car glyph"); preview style 1 trống ảnh

### StartupScreen/Videos/<video> + .frames/<video>/%05lu.jpg (video splash → chuỗi khung JPG)
Loại: [runtime-người-dùng] — nguồn video người dùng (không phải ảnh) + chuỗi khung JPG do app sinh ra để phát splash style 0
Đặc tả số: video gốc: `/var/mobile/Library/OmniCar/StartupScreen/Videos/<tên>` (copy nguyên file từ Photos — `UTTypeMovie`, export passthrough — hoặc Files; tên từ Files giữ nguyên, từ Photos đặt `Video yyyyMMdd-HHmmss.<ext>`). Khung: `Videos/.frames/<tên video>/%05lu.jpg` (00000.jpg, 00001.jpg, …), trích ở 24 fps trên tối đa 60 s đầu, cạnh dài ≤2000 px, JPEG qua CIContext; kèm `info.plist {version:2, count, fps:24}` và `audio.m4a`
Neo source: GHI video — `OMCStartupScreenController.m:1094` `-copyVideoAtURL:name:`; GHI khung — `-extractFramesForVideo:error:progress:` :~948-1006 (`JPEGRepresentationOfImage` → `writeToFile:`). ĐỌC/PHÁT — `src/StartupScreen/SSSplash.m:5-9,257`: style 0 là trình phát chuỗi khung JPEG `%05lu.jpg` (không AVPlayer); chọn video tại `SSStartupScreen.m:134` `SSChosenVideoName()` (pref `startupScreenVideoName`, hết hạn thì lấy file đầu tiên sắp xếp theo tên, bỏ file ẩn). Preview trong Prefs đọc `00000.jpg` tại `OMCStartupScreenController.m:672-676`
Điểm can thiệp: thay video tại thư mục Videos/ (qua Settings hoặc chép file); tham số trích khung (24 fps, ≤2000 px, 60 s) tại `extractFramesForVideo:`
Mức bằng chứng: verified-từ-source
Mặc định khi vắng: không video → style tự rơi về "liquid style" (`SSStartupScreen.m:338` log "no video found in … -> liquid style")

### HomeScreen/photo.jpg (ảnh người dùng cho hình nền xe)
Loại: [runtime-người-dùng] — ảnh tĩnh trung gian: nguồn để tạo wallpaper style 7
Đặc tả số: `/var/mobile/Library/OmniCar/HomeScreen/photo.jpg` · JPEG chất lượng 0.85, cạnh dài ≤2000 px, scale 1, opaque, quyền 0644 (thông số tại `useWallpaper:`/`writeJPEG:to:` dưới đây)
Neo source: GHI — `src/Prefs/OMCPrefs/OMCAppBridgeAppsController.m:1043-1060` `-useWallpaper:` (thu cạnh ≤2000 rồi `-writeJPEG:to:` :1029, `UIImageJPEGRepresentation(…, 0.85)`); ĐỌC — cùng file :259 (nạp vào `self.photo` khi mở trang Home Screen)
Điểm can thiệp: thay file ảnh tại đường dẫn; tham số 2000 px/0.85 tại `useWallpaper:`/`writeJPEG:to:`
Mức bằng chứng: verified-từ-source
Mặc định khi vắng: `self.photo = nil`; style 7 không có ảnh để áp

### HomeScreen/wallpaper.jpg (hình nền đang hiệu lực trên màn xe)
Loại: [runtime-người-dùng] — hình nền Home CarPlay (áp cho lưới icon xe)
Đặc tả số: `/var/mobile/Library/OmniCar/HomeScreen/wallpaper.jpg` · JPEG 0.85, 0644; nội dung tuỳ style: style 1-6 = gradient vẽ bằng code render ở khổ 2000×720 (neo dưới), style 7 = photo.jpg, style 8 = khung đầu video (video.jpg)
Neo source: GHI — `OMCAppBridgeAppsController.m:1004-1027` `-useStyle:` (mọi style đều kết thúc bằng `writeJPEG:…wallpaper.jpg`; style 0 = xoá file + tắt pref `homeScreenWallpaper`); ĐỌC phía xe — `src/SplitScreenC/SCPHomeApply.m:150-162` `SCPHomeApply` (style 8 đọc video.mp4, còn lại đọc wallpaper.jpg) → `src/SplitScreenB/SCPHomeWallView.m:115` `imageWithContentsOfFile:` + mờ Gaussian tuỳ chọn (CIGaussianBlur theo pref blur); ĐỌC phía Prefs — `OMCAppBridgeAppsController.m:266-274`
Điểm can thiệp: thay file ảnh tại đường dẫn (chỉ bền khi pref `homeScreenWallpaperStyle` tương ứng còn bật; Settings ghi đè khi đổi style); tham số tại `useStyle:`
Mức bằng chứng: verified-từ-source
Mặc định khi vắng: `SCPHomeApply` không tạo `SCPHomeWallView` → lưới icon xe giữ nền hệ thống; phía Prefs ép `wallStyle = 0`

### HomeScreen/video.mp4 + video.jpg (video nền xe + ảnh thumb của nó)
Loại: [runtime-người-dùng] — video nền Home CarPlay (style 8) và ảnh thumb JPEG đi kèm
Đặc tả số: `video.mp4`: xuất lại bằng AVAssetExportSession preset 1280×720, cắt tối đa 20 s, MP4, 0644. `video.jpg`: khung hình tại t=0 của chính video đó, JPEG 0.85 qua `writeJPEG:to:`
Neo source: GHI — `OMCAppBridgeAppsController.m:1063-1119` `-useVideo:` (export → move vào `HomeScreen/video.mp4` → `AVAssetImageGenerator` lấy khung 0 → ghi `video.jpg` → `useStyle:8`); ĐỌC — `SCPHomeApply.m:158` (style 8 → video.mp4, phát qua `SCPHomeWallView startVideo:`), Prefs đọc thumb :261-263 và dùng làm wallpaper tĩnh khi style 8 :269-270
Điểm can thiệp: thay file tại đường dẫn; preset/thời lượng tại `useVideo:`
Mức bằng chứng: verified-từ-source
Mặc định khi vắng: không có thumb/video; style 8 không khả dụng

Ghi chú ngoài phạm vi ảnh (cùng cây runtime, luồng khác phụ trách):
`StartupScreen/Sounds/<audio>` (âm thanh khởi động tuỳ biến, copy tại
`OMCStartupScreenController.m:1262` `-copySoundAtURL:`) và hai plist cache
`StartupScreen/weather.plist`, `location.plist` — không phải tài sản ảnh.

## C. Ảnh hệ thống / bên thứ ba mà giao diện mượn — [hệ-thống-mượn]

### Icon của app được chọn (picker/launcher/split trên xe) — cơ chế truy vấn hệ thống
Loại: [hệ-thống-mượn] — icon thuộc về app khác, hệ thống cung cấp tại runtime, không có file trong deb
Đặc tả số: API riêng của UIImage: `+_applicationIconImageForBundleIdentifier:format:scale:` — phía xe dùng format 2, scale 2.0 cố định; phía Prefs dùng format 2, scale = scale màn hình chính. Selector vắng → trả nil, không crash
Neo source: định nghĩa/truy vấn trung tâm `src/SplitScreenA/SCPShared.m:320-340` `SCPAppIconForBundle()` (có log DIAG kích thước/scale từng bundle); wrapper phía CarPlay `src/SplitScreenC/SCPCarApps.m:152-155` `SCPCarAppIcon`. Nơi hiển thị: picker/split xe — `src/SplitScreenB/SCPCarSplit+Picker.m:690,1087,1491,1677`, `SCPCarSplit+Panel.m:113,371,412`, `SCPCarSplit+Drag.m:115`, `src/SplitScreenA/SCPCarSplit.m:2560`; tên app đi kèm lấy từ `LSApplicationProxy applicationProxyForIdentifier:` → `displayName`/`localizedName` (`SCPCarApps.m` `SCPCarAppName`)
Điểm can thiệp: không thay file được; đổi format/scale tại `SCPAppIconForBundle` — muốn icon tự thiết kế phải vẽ lớp thay thế ở các điểm hiển thị trên
Mức bằng chứng: verified-từ-source

### Icon app trong Settings (danh sách chọn app / xem trước Home Screen)
Loại: [hệ-thống-mượn] — cùng API icon hệ thống, bản có cache + fallback vẽ tay
Đặc tả số: format 2, scale = scale màn hình; kết quả cache theo khoá `<bundleID>/<điểm>` (NSCache)
Neo source: `src/Prefs/OMCPrefs/OMCHSPreview.m:38` `OMCIconSized(bundleID, points)` — kiểm tra app đã cài qua LSApplicationProxy (`OMCHSInstalled`) rồi mới gọi API icon; dùng tại `OMCAppBridgeAppsController` (khai báo :93-95) và preview Home Screen. Fallback khi không lấy được icon: ô gradient + SF Symbol đoán theo bundle id — `app.fill` (mặc định), `play.fill` (NowPlaying), `gearshape.fill` (Settings), `car.fill` (tiền tố `com.apple.CarPlay`)
Điểm can thiệp: bảng fallback (symbol + cặp màu gradient) tại `OMCHSPreview.m:58-70`
Mức bằng chứng: verified-từ-source

### Icon nguồn tốc độ trong bong bóng tốc độ (Vietmap Live / GOFA / Waze / Wyn)
Loại: [hệ-thống-mượn] — icon của 4 app dẫn đường bên thứ ba + fallback chữ vẽ tay
Đặc tả số: hai điểm truy vấn cùng API `_applicationIconImageForBundleIdentifier:format:scale:`: phía Settings format 2/scale màn hình; phía bong bóng runtime format 0 (INFERRED)/scale màn hình, gọi qua `UIApplication` thay vì `UIImage`. Pref tắt/bật: `speedBubbleShowAppIcon` (mặc định bật)
Neo source: Settings — `src/Prefs/OMCPrefs/OMCSpeedBubbleController.m:26-60` `SPPAppIconForSource()` cho 4 bundle `vn.vietmap.live`, `com.lumi.GOFA`, `com.waze.iphone`, `com.wynauto.wyn`; fallback vẽ ô 60×60 chữ V/G/W/Y trắng nền `#F07A12/#1AA260/#33CCFF/#E5322D`. Runtime xe — `src/SpeedBubble/SPPBubble.m:607-645`: cache theo app; fallback ô 62×62 vẽ bởi `SPPDrawIconTile` kèm log "khong lay duoc icon … -> dung chu viet tat"
Điểm can thiệp: bảng màu/chữ fallback tại hai nơi trên; không thay được icon thật của app thứ ba
Mức bằng chứng: verified-từ-source (riêng format 0 phía runtime: inferred)

### SF Symbols khai trong plist (hàng Settings + trang tính năng + WhatsNew)
Loại: [hệ-thống-mượn] — tên symbol lưu trong plist, hệ thống (SF Symbols) cung cấp hình
Đặc tả số: bộ vẽ `OMCIcon(symbol, màu)` tại `src/Prefs/OMCPrefs/OMCCommon.m:480`: symbol 14 pt semibold trắng, đặt giữa ô bo góc 29×29 pt (bán kính 8.5) phủ gradient 2 màu chọn theo hue của màu chủ đạo (tím `#B7A6FF→#8B7CFF`, xanh lá `#2BC79A→#9DF2D8`, hồng `#FF7FA8→#FFC2D6`, xanh dương `#5AB8FF→#8FD3FF`). Tên theo file: Root.plist — `arrow.uturn.backward`, `exclamationmark.triangle.fill`, `square.grid.2x2.fill`, `apps.iphone`, `car.2.fill`, `lightbulb`, `sparkles`, `square.and.arrow.up`; FeatureSpeedBubble.plist — `speedometer`; FeatureSplitScreen.plist — `rectangle.split.2x1.fill`; FeatureStartupScreen.plist — `play.rectangle.fill` + nhóm random style: `film`, `seal`, `hand.wave`, `cloud.sun.rain`, `speedometer`, `car.fill`, `sparkles`, `scope`, `rectangle.grid.2x2`; WhatsNew.plist — `keyboard`, `arrow.up.left.and.arrow.down.right`, `globe`, `lightbulb`
Neo source: plist trong `OmniCarPrefs.bundle/` (dump đầy đủ ở INVENTORY.md §5); đường nạp: `OMCRootListController.m:102-103` (featureSymbol → property `symbol`), `OMCCommon.m:371-374` (symbol → `OMCIcon` → `iconImage`), `OMCWhatsNewController.m:94-95` (đọc khoá `symbol`, hỏng lùi về `sparkles`)
Điểm can thiệp: đổi tên symbol ngay trong plist; đổi khung ô/gradient tại `OMCIcon` trong `OMCCommon.m:480`
Mức bằng chứng: verified-từ-file (plist) + verified-từ-source

### SF Symbols gọi thẳng bằng literal trong code
Loại: [hệ-thống-mượn] — `systemImageNamed:` với tên hằng tại điểm gọi
Đặc tả số: danh sách theo nơi dùng — bàn phím tự vẽ: `keyboard.chevron.compact.down`, `shift`/`shift.fill`, `delete.left`, `globe`, `return` (`src/AppBridgeB/ABKeyboard.m:535,622-639,807`); bong bóng tốc độ (nút menu): `minus`, `plus`, `exclamationmark.triangle`, `speaker.wave.2`, `xmark` 17 pt (`src/SpeedBubble/SPPBubble.m:980-990`); Settings: `arrow.clockwise`, `globe` (thanh nút Root, `OMCRootListController.m:209,233`), `chevron.down`/`chevron.right` (mũi tên gập mục, `OMCAppBridgeAppsController.m:609`, `OMCSplitScreenController.m:346`), `play.circle`/`play.circle.fill` (`OMCSpeedBubbleController.m:588`, `OMCAppBridgeAppsController.m:961`), `xmark.circle.fill` (nút xoá logo, `OMCStartupScreenController.m:717`), `nosign` 22 pt (hàng "không chọn app", `OMCSplitScreenAppPickerController.m:169`), `pin.fill` (`OMCSplitPreview.m:95`), `rectangle`, `sun.max.fill`, `rectangle.fill`, `circle.circle` (ô hiệu ứng cảnh báo tốc độ, `OMCSpeedBubbleController.m:712-720`), `rectangle.dashed`, `speaker.wave.2.fill` (`OMCSpeedBubbleController.m:609-612`), `command` qua OMCIcon (hàng Siri, `OMCSplitScreenController.m:346`); onboarding: `square.grid.2x2.fill` + symbol theo trang, hỏng lùi `car.fill` (`OMCOnboardingController.m:85,117`)
Neo source: từng file:line ở trên; các điểm dùng biến động (symbol lấy từ dữ liệu): `OMCCommon.m:483`, `OMCSSStyleTileCell.m:85`, `OMCHSPreview.m:72`, `SSStartupView.m:471` (Prefs) — tên thật nằm ở dữ liệu gọi vào
Điểm can thiệp: đổi tên symbol tại điểm gọi hoặc tại bảng dữ liệu nguồn
Mức bằng chứng: verified-từ-source

### SF Symbols thời tiết + trạng thái splash (bảng tra theo mã thời tiết / đèn cảnh báo / style)
Loại: [hệ-thống-mượn] — symbol chọn theo bảng tra trong code, cấu hình multicolor ở cảnh thời tiết
Đặc tả số: thời tiết (theo mã + ngày/đêm): `sun.max.fill`, `moon.stars.fill`, `cloud.sun.fill`, `cloud.moon.fill`, `cloud.fill`, `cloud.fog.fill`, `cloud.drizzle.fill`, `cloud.heavyrain.fill`, `cloud.sun.rain.fill`, `cloud.rain.fill`, `cloud.snow.fill`, `cloud.bolt.rain.fill` — định nghĩa một chỗ dùng hai nơi: `src/Prefs/OMCPrefs/SSStartupView.m:76-106` (hàm SSWeatherSymbol) và `src/StartupScreen/SSStartupViewScenesB.m:159-187`; hỏng → `cloud.fill`. Đèn cảnh báo cảnh động cơ (kLamps): `fuelpump.fill`; `minus.plus.batteryblock.fill`/`minus.plus.batteryblock`/`bolt.fill`; `exclamationmark.triangle.fill`; (mục 3 không tên — luôn vẽ chữ "ABS"); `engine.combustion.fill`/`exclamationmark.circle.fill`; `headlight.high.beam.fill`/`light.max` (`SSStartupViewScenesB.m:584-602`). Glyph theo style splash (ô chọn style): `film`; `seal.fill`/`seal`; `hand.wave.fill`/`hand.wave`; `cloud.sun.rain.fill`; `gauge.with.dots.needle.67percent`/`speedometer`; `car.side.fill`/`car.fill`; `sparkles`; `scope`; `rectangle.grid.2x2.fill`; `drop.fill`/`drop`; `shuffle` (`src/Prefs/OMCPrefs/OMCSSStyleTileCell.m:18-29`). Fallback cảnh splash: poster `play.rectangle.fill`, logo `car.fill` (`src/StartupScreen/SSStartupView.m:245,248`; bản Prefs `SSStartupView.m:354,372`)
Neo source: các file:line trên
Điểm can thiệp: sửa bảng tra tại các file trên (giữ cặp dự phòng theo thứ tự thử)
Mức bằng chứng: verified-từ-source

### Ảnh sinh bằng code (không file, không hệ thống) — ghi để tránh nhầm là tài sản tĩnh
Loại: [hệ-thống-mượn] về mặt trình bày (vẽ tại runtime bằng UIGraphicsImageRenderer/CoreGraphics; không thuộc 15 file tĩnh)
Đặc tả số: (1) `OMCLogoMeshImage` — ảnh lưới/gradient logo thủ tục, dùng làm nền bảng Settings (`OMCCommon.m:393`), nền chrome split/app-bridge (`SCPCarSplit+Chrome.m:41`, `ABHostBMethods.m:1124`, `ABKeyboard.m:490`); (2) ảnh bản đồ giả sau preview bong bóng tốc độ `SPPMapImage` (`OMCSpeedBubbleController.m:~64`); (3) các ô icon fallback đã nêu ở hai mục icon app phía trên
Neo source: `src/OMCCommon/OMCCommon.h:188` + disasm `_OMCLogoMeshImage.asm`; các neo còn lại tại từng mục
Điểm can thiệp: phải vẽ lại bằng code (đổi hằng màu/hình trong hàm vẽ), không thay file
Mức bằng chứng: verified-từ-source

## Bảng tổng kết

| Nhóm | Số mục | Dung lượng / ghi chú |
|---|---|---|
| [tĩnh-trong-deb] PNG | **15 file** | **279.667 B** (= 273,1 KiB; ≈4,7% tổng payload 5.909.467 B) |
| — AppIcon (OmniCar.app) | 2 | 69.129 B |
| — PackageIcon.png | 1 | 74.767 B |
| — icon (Settings) ×3 scale | 3 | 25.437 B |
| — logo ×3 scale | 3 | 85.962 B |
| — SpeedBubbleIcon ×3 (không nơi dùng) | 3 | 14.743 B |
| — StartupScreenIcon ×3 (không nơi dùng) | 3 | 9.629 B |
| [runtime-người-dùng] | 5 mục (7+ đường dẫn file) | không trong deb; kích thước do nội dung người dùng quyết định, bị chặn bởi tham số ghi (logo ≤1024 px, ảnh nền ≤2000 px, khung video ≤2000 px/24 fps, video nền ≤1280×720/20 s) |
| [hệ-thống-mượn] | 7 mục cơ chế/bảng | 0 B trong deb — icon app khác qua API icon hệ thống; ~70 tên SF Symbol (plist + literal + bảng tra) |
| Định dạng ảnh khác trong deb (JPG/PDF/.car/GIF/SVG) | **0** | đã xác minh bằng danh sách đuôi file + quét magic bytes toàn payload |

## Khoảng trống / chưa xác định

1. **SpeedBubbleIcon ×3 + StartupScreenIcon ×3 (6 file, 24.372 B)**: không
   tìm được bất kỳ nơi dùng nào — vắng mặt trong strings của cả 8 binary và
   toàn bộ `src/` đã phục hồi; danh sách tính năng thực tế dùng SF Symbol
   qua `featureSymbol`. Khả năng còn lại (inferred): tàn dư của bản cũ hoặc
   tác giả đóng sẵn cho cơ chế `featureIcon` mà plist 1.0.3 không khai.
   Muốn kết luận tuyệt đối cần rà disasm thô của OmniCarPrefs ngoài phần
   đã phục hồi thành `src/` — ngoài phạm vi luồng này.
2. Nội dung hình vẽ cụ thể của từng PNG (nhận dạng bằng mắt) không nằm
   trong luồng thống kê này; file gốc đã có sẵn ở
   `work/ui-inventory/final/assets/` kèm `assets-checksums.tsv` (khớp SHA
   toàn bộ 15 file ở mục A).
3. Biểu tượng của app bên thứ ba và SF Symbol: chỉ kiểm kê tên + cơ chế
   truy vấn theo yêu cầu; không trích xuất file hệ thống.

---

## Phần 2 — Vẽ bằng code (custom drawing)


Phạm vi: CHỈ ĐỌC source phục hồi `~/workspace/omnicar-re/src/` (207 file .m/.h)
+ disasm trong thư mục `disasm/` của từng module khi source ghi
inferred/chưa phục hồi. Không chạy binary, không sửa code. Giá trị màu ghi
tại chỗ theo source (RGB 0–1 hoặc hex); bảng màu tổng hợp để luồng 4 lo.

Quy ước mức bằng chứng: VERIFIED = đọc từ thân hàm phục hồi khớp disasm;
INFERRED = tên/giá trị suy từ hằng số hoặc ngữ cảnh; PARTIAL = có một phần
số liệu, thiếu phần còn lại; UNRECOVERED = chưa có số liệu.

Màu dùng lặp (ghi tại chỗ từng mục, tổng hợp ở đây cho tiện đọc):
navy/indigo chữ = RGB(0.29020, 0.30980, 0.50196) (≈ RGB(74,79,128));
accent tím = RGB(0.60784, 0.52941, 0.97255) (≈ RGB(155,135,248));
accent xanh = RGB(0.36471, 0.70588, 0.96471) (≈ RGB(93,180,246));
tím bóng = RGB(0.43137, 0.39216, 0.78431) (≈ RGB(110,100,200)).

## A. Shape / layer / gradient / mask / shadow / blur

### ABBoxView — mask lỗ even-odd
Loại: shape/mask | Đặc tả số: CAShapeLayer làm mask, fillRule
kCAFillRuleEvenOdd; path = rect bounds + hole là rounded rect
cornerRadius 12; hole rỗng → mask = nil; cập nhật trong CATransaction
disableActions | Neo source: AppBridgeB/ABChromeViews.m, `ABBoxView
-applyHole` (~line 63–95, @0x9C10) | Điểm can thiệp: đổi cornerRadius 12 /
fillRule tại applyHole | Mức bằng chứng: VERIFIED

### SCPCTouchWatch — shield mask lỗ hình chữ nhật
Loại: shape/mask | Đặc tả số: CAShapeLayer even-odd; path = rect bounds +
từng hole rect KHÔNG bo góc; tái dùng mask layer có sẵn nếu đã có | Neo
source: SplitScreenB/SCPCTouchWatch.m `-setHoles:` (@0xf4d4) | Điểm can
thiệp: đổi hình học hole tại setHoles: | Mức bằng chứng: VERIFIED

### SCPHomeWallView — mờ/blur hình nền home
Loại: blur/hiệu ứng | Đặc tả số: ảnh ScaleAspectFill; lớp dim đen alpha =
settings dim/100; blur tĩnh bằng CIFilter CIGaussianBlur
(kCIInputRadiusKey = blur), cross-dissolve 0.4 s; video AVPlayerLayer
ResizeAspectFill | Neo source: SplitScreenB/SCPHomeWallView.m | Điểm can
thiệp: bán kính blur / alpha dim tại SCPHomeWallView | Mức bằng chứng:
VERIFIED (contentMode video, muted, videoGravity: INFERRED)

### Divider knob (SplitScreen) — mặt kính + chấm
Loại: shape/shadow | Đặc tả số: knob 14×14, cornerRadius 7 continuous,
border 1.5 white α0.95; shadow RGB(0.43137,0.39216,0.78431) opacity 0,
radius 3, offset (0,1); mặt = SCPKnobFaceView (xem mục riêng); chấm layer
tên "omcDot" frame (5,5,4,4) radius 2, màu navy RGB(0.29020,0.30980,
0.50196). Knob tạo mới ở newDividerAt: có shadow opacity 0, radius 3,
offset zero | Neo source: SplitScreenB/SCPCarSplit+Layout.m
`-layoutKnobOf:` (@0x2c848) | Điểm can thiệp: kích thước/border/shadow tại
layoutKnobOf: | Mức bằng chứng: VERIFIED

### Knob active — gradient "omcAccent" + spring scale
Loại: gradient/hiệu ứng | Đặc tả số: CAGradientLayer tên "omcAccent"
RGB(155,135,248)→RGB(93,180,246), startPoint (0,0) endPoint (1,1),
cornerRadius = width/2, opacity 0→1 khi active; spring bật 0.15 s /
tắt 0.3 s, damping 0.7, scale 1.6×; chấm → white khi active (nghỉ:
RGB(74,79,128)); border white α1 (active) / α0.95 (nghỉ); shadow active
RGB(110,120,255) opacity 0.5 radius 7; nghỉ RGB(110,100,200) opacity 0
radius 3 | Neo source: SplitScreenB/SCPCarDividerView.m `SCPSetKnobActive`
(@0xeb20) | Điểm can thiệp: 2 màu gradient / hệ số scale tại
SCPSetKnobActive | Mức bằng chứng: VERIFIED

### SCPKnobFaceView — mặt mờ của knob
Loại: blur | Đặc tả số: UIVisualEffectView UIBlurEffect style 11 (tên
INFERRED: UIBlurEffectStyleSystemUltraThinMaterialLight), contentView
white α0.35, border 0.5 white α0.85, radius 7; chế độ lite: effect = nil +
white α0.92 | Neo source: SplitScreenB/SCPCarDividerView.m
`SCPKnobFaceView` | Điểm can thiệp: style blur / alpha tại init của
SCPKnobFaceView | Mức bằng chứng: VERIFIED (tên style: INFERRED)

### Knobs AppBridge (bản AB) — đĩa chạm 66 + chấm 14
Loại: shape/blur/shadow | Đặc tả số: hit disc 66×66 radius 33, bg white
α0.012; dotView 14×14 tại (26,26) radius 7, blur style 11, border 1.5
white α0.95, shadow RGB(110,100,200) opacity 0.45 radius 3 offset (0,1);
chấm "omcDot" (5,5,4,4) radius 2; active: spring 0.15 s / 0.2 s options 4
(bản SplitScreen: 0.15/0.3 s options 6), scale 1.6× | Neo source:
AppBridgeB/ABHostBMethods.m `-setKnobs:` (@0x13ABC) | Điểm can thiệp:
kích thước đĩa/chấm tại setKnobs: | Mức bằng chứng: VERIFIED

### Handle pill + 3 chấm (SplitScreen)
Loại: glyph-view/shape | Đặc tả số: pill 34×12, bg white α0.35, radius 6
continuous, border 0.5 white α0.55; 3 chấm 4×4 radius 2, tâm x = 9/17/25
(bước 8), y = 6, màu navy α0.85 | Neo source:
SplitScreenB/SCPCarSplit+Chrome.m `-setupBarForPane:` (@0x22adc) | Điểm
can thiệp: cỡ pill / vị trí chấm tại setupBarForPane: | Mức bằng chứng:
VERIFIED

### Handle AppBridge (bản AB) — pill + 3 chấm bước 7
Loại: glyph-view/shape | Đặc tả số: vùng chạm 44×24; pill 34×12 tại (5,6);
3 chấm 4×4 tại x = 9/16/23 (bước 7 — KHÁC bản SplitScreen bước 8), y = 4 |
Neo source: AppBridgeB/ABHostBMethods.m (handle builder) | Điểm can
thiệp: bước chấm tại handle builder AB | Mức bằng chứng: VERIFIED

### Thanh bar SplitScreen — chip, nút, separator
Loại: shape/shadow | Đặc tả số: chiều cao bar 52; nút 48×40; chip 40×40
(SCPStyleChip, radius 20), icon inset 6; separator 1×30 white α0.95
radius 0.5; menu tỉ lệ gắn SCPStyleRatioMenu(bar, 22) | Neo source:
SplitScreenB/SCPCarSplit+Chrome.m `-setupBarForPane:` (@0x22adc) | Điểm
can thiệp: cỡ chip/nút tại setupBarForPane: | Mức bằng chứng: VERIFIED

### SCPStyleChip
Loại: shape/shadow | Đặc tả số: bg white α0.5, border 1 white α0.9, shadow
RGB(0.43137,0.39216,0.78431) opacity 0.12 radius 3 offset (0,2) | Neo
source: SplitScreenB/SCPCarSplit+Chrome.m `SCPStyleChip` (@0x35f70) |
Điểm can thiệp: tại SCPStyleChip | Mức bằng chứng: VERIFIED

### SCPApplyAccent / ABApplyAccent — gradient điểm nhấn dùng chung
Loại: gradient/shadow | Đặc tả số: CAGradientLayer tên "omcAccent"
RGB(0.60784,0.52941,0.97255)→RGB(0.36471,0.70588,0.96471), (0,0)→(1,1),
cornerRadius = view.layer.cornerRadius; bật: shadow RGB(0.43137,0.47059,
1.0) opacity 0.45 radius 9 offset (0,4); tắt: gỡ layer, shadow opacity 0.
Bản AB (ABApplyAccent, sub_11F58): cùng gradient; accented → bg clear +
chấm white; nghỉ → bg white α0.35 + chấm RGB(74,79,128) α0.85 | Neo
source: SplitScreenB/SCPCarSplit+Chrome.m `SCPApplyAccent` (@0x293a0);
AppBridgeB/ABHostBMethods.m `ABApplyAccent` | Điểm can thiệp: 2 màu tại
hàm ApplyAccent tương ứng | Mức bằng chứng: VERIFIED

### Thanh bar AppBridge (bản AB)
Loại: shape/blur/mesh/shadow | Đặc tả số: radius 22, shadow
RGB(110,100,200) opacity 0.3 radius 14 offset (0,6), blur style 11 + mesh
backdrop (xem SCPApplyMeshBackdrop), border 1 white α0.85 | Neo source:
AppBridgeB/ABHostBMethods.m (bar builder) | Điểm can thiệp: tại bar
builder AB | Mức bằng chứng: VERIFIED

### SCPApplyMeshBackdrop — nền mesh logo cho menu/panel/sheet
Loại: mesh/blur | Đặc tả số: UIImageView chứa ảnh OMCLogoMeshImage(0),
contentMode ScaleToFill, autoresizing 0x12, chèn vào contentView của
UIVisualEffectView tại index 0; border của effect view: width 1, white
α0.85 | Neo source: SplitScreenB/SCPCarSplit+Chrome.m
`SCPApplyMeshBackdrop` (@0x35d5c) | Điểm can thiệp: ảnh mesh / border tại
SCPApplyMeshBackdrop; bản thân mesh xem mục OMCDrawLogoMesh | Mức bằng
chứng: VERIFIED

### SCPStyleRatioMenu / SCPPrepareRatioMenu — vỏ menu tỉ lệ
Loại: shape/shadow/blur/hiệu ứng | Đặc tả số: shadow RGB(0.43137,0.39216,
0.78431) opacity 0.3 radius 14 offset (0,6); chèn SCPKnobFaceView + mesh
backdrop, clipsToBounds; xuất hiện: alpha 0, scale 0.9, dịch −8 pt, spring
0.45 s damping 0.86 velocity 0.4 | Neo source:
SplitScreenB/SCPCarSplit+Chrome.m `SCPStyleRatioMenu` (@0x29b10),
`SCPPrepareRatioMenu` (@0x24a34) | Điểm can thiệp: shadow/spring tại hai
hàm trên | Mức bằng chứng: VERIFIED

### Ratio chip + vòng conic khi được chọn
Loại: glyph-view/gradient/mask | Đặc tả số: nút chip 34×34 radius 17,
tint navy; khi chọn: CAGradientLayer type conic, startPoint (0.5,0.5)
endPoint (0,1), màu RGB(0.65490,0.54510,0.98039) / (0.37647,0.77255,
0.98039) / (0.36863,0.86667,0.71373) / (0.96078,0.60392,0.75294) / lặp màu
đầu; mask CAShapeLayer rounded rect inset 1, radius max(cornerRadius−1,0),
lineWidth 2, fill nil stroke black; shadow RGB(0.60784,0.52941,0.97255)
opacity 0.3 radius 8 offset (0,4) | Neo source:
SplitScreenB/SCPCarSplit+RatioMenu.m `SCPWrapRatioChip` (@0x302f8),
`SCPMarkRatioChipSelected` (@0x30450) | Điểm can thiệp: bảng 4 màu conic /
lineWidth mask tại SCPMarkRatioChipSelected | Mức bằng chứng: VERIFIED

### Panel chọn bố cục — vỏ + placeholder gạch đứt + nút choice
Loại: shape/shadow/dash | Đặc tả số: panel radius 24 continuous, shadow
opacity 0.3 radius 24 offset (0,8); placeholder rỗng: CAShapeLayer nét đứt
— rounded rect inset 0.5 radius 6, fill nil, stroke navy α0.25, lineWidth
1, lineDashPattern @[@3,@3]; divider 1×33 white α0.95; nút choice 84×56
stride 84, radius 14, border 1 white α0.75 | Neo source:
SplitScreenB/SCPCarSplit+Panel.m | Điểm can thiệp: dash pattern / radius
panel tại SCPCarSplit+Panel.m | Mức bằng chứng: VERIFIED

### Picker sheet — vỏ, vạch gradient, ô app, badge, vòng loader, chấm trang
Loại: shape/gradient/shadow | Đặc tả số: sheet radius 24, shadow opacity
0.3 radius 24 offset (0,8); cột phụ 150 pt có CAGradientLayer vạch dọc
1 pt: navy α 0→0.32→0.32→0, locations 0/0.2/0.8/1, frame (0,10,1,
sheetH−20); ô app 62×56, icon 38×38 tại (12,9), shadowView shadow opacity
0.25 radius 5 offset (0,4) + shadowPath rounded rect; badge "check" 14×14
radius 7, border 1 white, bg accent RGB(0.60784,…), tint white; vòng
loader: CAShapeLayer cung tâm (10,10) bán kính 8, từ −π/2→π, stroke
accent, lineWidth 2, lineCap round, quay CABasicAnimation
transform.rotation.z 0.9 s vô hạn; chấm trang: cao 6 radius 3, trang hiện
tại rộng 16 màu accent, trang khác rộng 6 navy α0.2, khoảng cách 6 | Neo
source: SplitScreenB/SCPCarSplit+Picker.m `-buildPickerSheetForPane:`,
`layoutPickerDotsForPage:` (@0x3b630) | Điểm can thiệp: tại các hàm trên |
Mức bằng chứng: VERIFIED

### Cover ô trống + ghost icon
Loại: shape | Đặc tả số: cover phủ pane, bg RGB(0.93333,0.94118,0.98431),
không nhận chạm, fade in 0.12 s / out 0.22 s; icon ghost 52×52 giữa cover,
tag 77 | Neo source: SplitScreenB/SCPCarSplit+Picker.m
`-addCoverToPane:` (@0x2a2e8) | Điểm can thiệp: màu cover tại
addCoverToPane: | Mức bằng chứng: VERIFIED

### SCPStyleDragGhost / SCPStyleGhostIcon — bóng kéo thả
Loại: shape/shadow | Đặc tả số: ghost: bg white α0.9, border 0.5 white
α0.85, shadow opacity 0.25 radius 10 offset (0,4); ghost kéo thực tế:
radius 16, border 1.5 accent, icon 44×44; icon: cornerRadius = width×0.27
continuous, clipsToBounds; thiếu icon → bg RGB(0.93333,0.94118,0.98431) |
Neo source: SplitScreenB/SCPCarSplit+Drag.m `SCPStyleDragGhost`
(@0x271e4), `SCPStyleGhostIcon` (@0x21158) | Điểm can thiệp: tại hai hàm
trên | Mức bằng chứng: VERIFIED

### Toast chữ (pill) + toast nền (icon + nút Mở lại)
Loại: shape/gradient | Đặc tả số: toast chữ: nhãn 14 pt Medium navy trên
white α0.94 (SCPStyleDragGhost radius 19), cao tối thiểu 38, tâm tại
(hostW/2, hostH−50), fade 0.2 s vào / 0.3 s ra; toast nền: cao 34,
SCPStyleRatioMenu(toast, 18), icon 24×24 tại (7,6), nhãn 13 pt Medium,
nút "Mở lại" 13 pt Semibold white trên SCPApplyAccent, radius 13, tự tắt
5 s | Neo source: SplitScreenB/SCPCarSplit+Picker.m `-toast:duration:`
(@0x44f80), `-showBackgroundToastFor:slot:` (@0x28c68) | Điểm can thiệp:
tại hai method trên | Mức bằng chứng: VERIFIED

### SCPLauncherGlyphImage — glyph 2 ô của launcher
Loại: glyph-path | Đặc tả số: renderer UIGraphicsImageRenderer, template;
w = max(round(w),6), h = max(round(h),4); gap = max(round(w×0.11),1.5);
paneW = min((w−gap)×0.5, h); radius = max(paneW×0.18, 2.5); hai rounded
rect (0,0,paneW,h) và (paneW+gap,0,paneW,h), fill white; nút chứa: bounds
34×34 radius 17, tint navy | Neo source: SplitScreenA/SCPCarSplit.m
`SCPLauncherGlyphImage` (sub_42564), `SCPButtonWithGlyph` (sub_302f8) |
Điểm can thiệp: hệ số gap/radius tại SCPLauncherGlyphImage | Mức bằng
chứng: VERIFIED

### Bàn phím AB — ABKey paint (gradient phím điểm nhấn)
Loại: gradient/shadow | Đặc tả số: CAGradientLayer accent RGB(0.60784,
0.52941,0.97255)→RGB(0.36471,0.70588,0.96471), (0,0)→(1,1), cornerRadius
7, shadow colorA opacity 0.4 radius 6 offset (0,3); accent.opacity =
on ? 0.82 : 1.0 (chiều ngược trực giác — ghi nguyên theo source) | Neo
source: AppBridgeB/ABKeyboard.m `ABKey -paint:` (@0x181DC) | Điểm can
thiệp: màu/opacity tại paint: | Mức bằng chứng: VERIFIED

### Bàn phím AB — phím thường + panel kính
Loại: shape/blur/mesh/shadow | Đặc tả số: phím: radius 7 continuous,
border (!special || punct) ? 1 : 0 white α0.9, shadow RGB(110,100,200)
opacity 0.18 radius 1 offset (0,1), restColor white α0.9 / α0.5, restTint
RGB(74,79,128); font: space 10 pt, special 17 pt, thường 11 pt Semibold;
hint label 11×11 tại (w−13, 0); panel: shadow opacity 0.3 radius 20
offset (0,6), glass blur style 11 + mesh logo, radius 20, border 1 white
α0.85; ô nhập white α0.85 radius 12 border 1 white | Neo source:
AppBridgeB/ABKeyboard.m (key factory @0x1ABB0, panel @0x1A200) | Điểm can
thiệp: tại key factory / panel builder | Mức bằng chứng: VERIFIED

## B. Mesh gradient / logo vẽ bằng code

### OMCDrawLogoMesh / OMCLogoMeshImage — bản Core (chuẩn)
Loại: mesh-gradient (radial ×4) | Đặc tả số: renderer 88×88, scale 1.0,
cache 2 style; style 0: alpha 0.95, opaque NO, nền RGB(232,234,250) α0.8;
style 1: alpha 1.0, opaque YES, nền RGB(226,228,246); 4 radial gradient
từ 4 góc (88,88), (0,88), (88,0), (0,0), bán kính cuối 95.035151391472,
stop packed {0x00A0F1D9, 0x00FEC4D8, 0x00A6DDFD, 0x00C9BAFC} → RGB
(217,241,160), (216,196,254), (253,221,166), (252,186,201); mỗi gradient
mờ dần alpha → 0 | Neo source: OMCCommon/OMCCommon.c `OMCLogoMeshImage`
(@0xcb38) | Điểm can thiệp: 4 stop / bán kính tại OMCDrawLogoMesh | Mức
bằng chứng: VERIFIED

### OMCLogoMeshImage — bản Prefs (BIẾN THỂ KHÁC bản Core)
Loại: mesh-gradient (radial ×3) | Đặc tả số: 120×120 opaque, nền
RGB(0.10,0.11,0.22); 3 blob radial bán kính 70: (30,20) RGB(0.62,0.45,1)
α0.55; (90,40) RGB(0.35,0.65,1) α0.45; (60,95) RGB(0.45,0.95,0.80) α0.40 |
Neo source: Prefs/OMCPrefs/OMCCommon.m `OMCLogoMeshImage` (@0x185e8) |
Điểm can thiệp: tại bản Prefs của OMCLogoMeshImage | Mức bằng chứng:
VERIFIED — hai binary dùng HAI công thức mesh khác nhau, phải giữ riêng

### OMCIcon — tile gradient + SF Symbol (Prefs)
Loại: gradient/glyph-symbol | Đặc tả số: symbol 14 pt Semibold tint white
vẽ giữa tile 29×29 rounded rect radius 8.5; nền linear gradient
(0,0)→(29,29) theo hue của màu đầu vào: purple #B7A6FF→#8B7CFF; green
#2BC79A→#9DF2D8; pink #FF7FA8→#FFC2D6; blue #5AB8FF→#8FD3FF | Neo source:
Prefs/OMCPrefs/OMCCommon.m `OMCIcon` (@0x18144) | Điểm can thiệp: bảng 4
cặp màu tại OMCIcon | Mức bằng chứng: VERIFIED

## C. Glyph tự vẽ bằng vector (lưới 24×24)

### SCPDrawSymbolIcon / SCPRenderTemplateImage — bộ máy glyph
Loại: glyph-path (engine) | Đặc tả số: UIGraphicsImageRenderer, CTM scale
size/24; stroke path lineWidth 1.8 round cap/join + fill path, cả hai sơn
đen rồi lấy ảnh template (AlwaysTemplate); họ hm_* hạ lineWidth xuống
1.5. `SCPSymbolImage` (@0x2b474) cache theo key "name/size/0". Bản thứ hai
của cùng bộ glyph nằm trong AppBridgeB: `ABSetBarButtonContent` (block
@0x168B0) — render 22 pt cho hm_*, 20 pt cho tên thường, AlwaysOriginal,
cache theo tên; tập tên AB chỉ gồm fullscreen, replace, close, float,
dock + hm_* (không có layouts/recent/favorite/exit/check/swap) | Neo
source: SplitScreenB/SCPCarSplit+RatioMenu.m `SCPDrawSymbolIcon` (block
@0x46b90), `SCPRenderTemplateImage` (@0x46a64); AppBridgeB/ABHostBMethods.m
`ABSetBarButtonContent` | Điểm can thiệp: lineWidth / chế độ render tại
hai engine trên | Mức bằng chứng: VERIFIED

### Glyph fullscreen
Loại: glyph-path | Đặc tả số (lưới 24): nét (13.5,4)→(20,4)→(20,10.5);
(20,4)→(14,10); (10.5,20)→(4,20)→(4,13.5); (4,20)→(10,14) | Neo source:
SCPDrawSymbolIcon, nhánh fullscreen | Điểm can thiệp: toạ độ tại nhánh
fullscreen | Mức bằng chứng: VERIFIED

### Glyph replace
Loại: glyph-path | Đặc tả số: 3 rounded rect (3.5,3.5,7.5,7.5) r2.4,
(13,3.5,7.5,7.5) r2.4, (3.5,13,7.5,7.5) r2.4 + nét (16.75,13.5)→
(20,16.75), (13.5,16.75)→(20,16.75) | Neo source: SCPDrawSymbolIcon,
nhánh replace | Điểm can thiệp: tại nhánh replace | Mức bằng chứng:
VERIFIED

### Glyph close (X tự vẽ)
Loại: glyph-path | Đặc tả số: (7,7)→(17,17); (17,7)→(7,17) | Neo source:
SCPDrawSymbolIcon, nhánh close | Điểm can thiệp: tại nhánh close | Mức
bằng chứng: VERIFIED

### Glyph layouts
Loại: glyph-path | Đặc tả số: rounded rect (3.5,5,9,14) r2.6 +
(14,5,6.5,14) r2.6 | Neo source: SCPDrawSymbolIcon, nhánh layouts | Điểm
can thiệp: tại nhánh layouts | Mức bằng chứng: VERIFIED

### Glyph recent (đồng hồ)
Loại: glyph-path | Đặc tả số: oval (3.75,3.75,16.5,16.5); kim
(12,7.5)→(12,12)→(15,14) | Neo source: SCPDrawSymbolIcon, nhánh recent |
Điểm can thiệp: tại nhánh recent | Mức bằng chứng: VERIFIED

### Glyph favorite (sao 10 điểm)
Loại: glyph-path | Đặc tả số: tâm (12,12.6), R ngoài 8.6 / R trong 3.9,
điểm tính bằng cos/sin, góc bắt đầu −π/2, bước π/5, closePath | Neo
source: SCPDrawSymbolIcon, nhánh favorite | Điểm can thiệp: R ngoài /
trong tại nhánh favorite | Mức bằng chứng: VERIFIED

### Glyph exit (cửa + mũi tên)
Loại: glyph-path | Đặc tả số: khung cửa bằng line + arc r2.5 tại (6.5,6.5)
và (6.5,17.5); mũi tên (10,12)→(20,12), cánh (16.5,8.5)→(16.5,15.5) | Neo
source: SCPDrawSymbolIcon, nhánh exit | Điểm can thiệp: tại nhánh exit |
Mức bằng chứng: VERIFIED

### Glyph float
Loại: glyph-path | Đặc tả số: outline rounded rect (3.5,4.5,17,15) r3 +
fill rounded rect (11.5,11,6.5,6) r1.6 | Neo source: SCPDrawSymbolIcon,
nhánh float | Điểm can thiệp: tại nhánh float | Mức bằng chứng: VERIFIED

### Glyph dock
Loại: glyph-path | Đặc tả số: outline như float + vạch đứng
(12,4.5)→(12,19.5) + fill (5.6,6.6,4.6,10.8) r1.4 | Neo source:
SCPDrawSymbolIcon, nhánh dock | Điểm can thiệp: tại nhánh dock | Mức
bằng chứng: VERIFIED

### Glyph check
Loại: glyph-path | Đặc tả số: (6,12.5)→(10,16.5)→(18,8) | Neo source:
SCPDrawSymbolIcon, nhánh check | Điểm can thiệp: tại nhánh check | Mức
bằng chứng: VERIFIED

### Glyph swap (2 mũi tên ngang)
Loại: glyph-path | Đặc tả số: mũi tên y=8.5: (4.5)→(19), đầu (15.5,5) /
(15.5,12); mũi tên y=15.5: (19.5)→(5), đầu (8.5,12) / (8.5,19) | Neo
source: SCPDrawSymbolIcon, nhánh swap | Điểm can thiệp: tại nhánh swap |
Mức bằng chứng: VERIFIED

### Glyph hm_apps (lưới 4 ô)
Loại: glyph-path | Đặc tả số: 4 rounded rect 7×7 r2.2 tại (4,4), (13,4),
(4,13), (13,13); lineWidth 1.5 | Neo source: SCPDrawSymbolIcon, nhánh
hm_apps | Điểm can thiệp: tại nhánh hm_apps | Mức bằng chứng: VERIFIED

### Glyph hm_full
Loại: glyph-path | Đặc tả số: outline (4,4,16,16) r3.5 vẽ bằng 4 arc góc |
Neo source: SCPDrawSymbolIcon, nhánh hm_full | Điểm can thiệp: tại nhánh
hm_full | Mức bằng chứng: VERIFIED

### Glyph hm_split
Loại: glyph-path | Đặc tả số: 2 rounded rect (3.5,4.5,7.5,15) r2.5 +
(13,4.5,7.5,15) r2.5 | Neo source: SCPDrawSymbolIcon, nhánh hm_split |
Điểm can thiệp: tại nhánh hm_split | Mức bằng chứng: VERIFIED

### Glyph hm_float
Loại: glyph-path | Đặc tả số: outline r3 như float + fill
(11.5,11.5,6.5,5.5) r1.6 | Neo source: SCPDrawSymbolIcon, nhánh hm_float |
Điểm can thiệp: tại nhánh hm_float | Mức bằng chứng: VERIFIED

### Glyph hm_min (gạch ngang)
Loại: glyph-path | Đặc tả số: nét (5.5,12)→(18.5,12) | Neo source:
SCPDrawSymbolIcon, nhánh hm_min | Điểm can thiệp: tại nhánh hm_min | Mức
bằng chứng: VERIFIED

### Glyph hm_close (X mảnh)
Loại: glyph-path | Đặc tả số: (6.5,6.5)→(17.5,17.5); (17.5,6.5)→
(6.5,17.5) | Neo source: SCPDrawSymbolIcon, nhánh hm_close | Điểm can
thiệp: tại nhánh hm_close | Mức bằng chứng: VERIFIED

### SCPDrawPresetGlyph — glyph tỉ lệ preset
Loại: glyph-path | Đặc tả số: lưới x[3,21] y[5,19], gap 1.6; mỗi ô một
rounded rect outline lineWidth 1.5, radius = min(min(w,h)×0.5, 2), kích
thước làm tròn 0.1; mainStack: ô chính rộng preset[0]×16.4, cột xếp chồng
cao preset[1]×12.4; render size 22; rotated = vertical (xoay −90°) | Neo
source: SplitScreenB/SCPCarSplit+RatioMenu.m `SCPDrawPresetGlyph` (block
@0x47e00) | Điểm can thiệp: lưới/gap tại SCPDrawPresetGlyph | Mức bằng
chứng: VERIFIED

### SCPRenderLayoutGlyph — glyph bố cục panel (canvas 73×40)
Loại: glyph-path | Đặc tả số: canvas cố định 73×40; rect layout 13/31
chép nguyên (vertical: (0,0,73,18), (0,20.5,34,19.5), (36.5,20.5,35.5,
19.5); horizontal tương ứng; 31 = mirror theo trục chia); layout 2/3 ô:
gap 2.5, floor + dư cho ô cuối; mỗi ô fill rounded rect r5 + stroke inset
0.75 r4.4 lineWidth 1.5; icon app clip rounded rect r = side×0.27, side =
floor(minDim−4); ô trống vẽ dấu +: cánh min(floor(minDim×0.25),4),
lineWidth 1.4 round cap, màu SCPColorSecondary (helper @0x2b380 trả navy
RGB(0.29020,0.30980,0.50196) ở α0.55; tại glyph dùng dạng đầy đủ qua tham
số plusColor) | Neo source: SplitScreenB/SCPCarSplit+RatioMenu.m
`SCPRenderLayoutGlyph` (block @0x4829c) | Điểm can thiệp: canvas/gap/dấu
+ tại SCPRenderLayoutGlyph | Mức bằng chứng: VERIFIED

### Dấu + trong picker map (nhãn chữ)
Loại: glyph-text | Đặc tả số: UILabel "+", font cỡ min(floor(min×0.8),22);
Bold + chữ trắng nếu là pane đích, ngược lại Regular màu secondary | Neo
source: SplitScreenB/SCPCarSplit+Picker.m `-pickerMapForPane:` | Điểm can
thiệp: tại pickerMapForPane: | Mức bằng chứng: VERIFIED

## D. SpeedBubble — vòng tốc độ và 9 style bong bóng

### SPPGradientRing / SPPGradientColors — vòng gradient dùng chung
Loại: gradient/mask | Đặc tả số: bảng 5 màu: violet RGB(0.65490,0.54510,
0.98039), sky (0.37647,0.77255,0.98039), teal (0.36863,0.86667,0.71373),
pink (0.96078,0.60392,0.75294), violet (lặp); Colors3 = 3 màu đầu. Ring:
conic startPoint (0.5,0.5) endPoint (0.5,0), hoặc linear (0,0)→(1,1);
mask CAShapeLayer fill clear, stroke black, lineCap round | Neo source:
SpeedBubble/SPPBubbleView.m `SPPGradientColors5`, `SPPGradientRing` |
Điểm can thiệp: bảng màu tại SPPGradientColors5 | Mức bằng chứng:
VERIFIED

### SPPGlassView — kính bong bóng (bản SpeedBubble)
Loại: gradient/shadow | Đặc tả số: border 1 white α0.85; fill gradient
white α1→α0.5; sheen = 55% chiều cao trên; shadow RGB(0.27451,0.23529,
0.54902) radius 10 offset (0,4); shadowPath rounded rect theo corner |
Neo source: SpeedBubble/SPPViews.m `SPPGlassView` | Điểm can thiệp: tại
SPPGlassView | Mức bằng chứng: VERIFIED (shadowOpacity = 1: INFERRED)

### SPPSignView — biển giới hạn tốc độ (vòng tròn)
Loại: glyph-view | Đặc tả số: layoutSubviews radius = min(w,h)/2; vòng
biển tròn viền đỏ | Neo source: SpeedBubble/SPPViews.m `SPPSignView` |
Điểm can thiệp: tại SPPSignView | Mức bằng chứng: PARTIAL — applyColors
INFERRED (border 3, đỏ RGB(0.94118,0.19608,0.22745), muted xám 0.6/0.55)

### Số tốc độ — font và cỡ theo style
Loại: text | Đặc tả số: số dùng SPPHeavyFont (Heavy + Rounded + tabular
figures), đơn vị SPPRoundedFont Semibold; màu trạng thái: 0 = indigo
(74,79,128), 1 = amber (255,179,64), 2 = đỏ (255,90,95); cỡ (số/đơn vị)
theo style: 0:34/10, 1:32/10, 2:30/10, 3:33/10, 4:40/10, 5:48/12, 6:30/10,
7:30/10, 8:24/9 | Neo source: SpeedBubble/SPPBubbleView.m | Điểm can
thiệp: bảng cỡ tại SPPBubbleView | Mức bằng chứng: VERIFIED

### SpeedBubble style 0 — vòng tròn kính + conic ring
Loại: shape/gradient | Đặc tả số: glass (4,16,100,100) corner 50; conic
ring lineWidth 3, mask oval (1.5,1.5,97,97); shine gradient white
α0.75→0 frame (16,9,46,26) radius 13; biển 50 tại (95,25); icon 22 tại
(11,107); content 120×118 | Neo source: SpeedBubble/SPPBubbleView.m
(style 0) | Điểm can thiệp: tại nhánh style 0 | Mức bằng chứng: VERIFIED

### SpeedBubble style 1 — strip ngang
Loại: shape | Đặc tả số: strip glass corner 30 cao 60; chấm 8×8 tại
(10,26) radius 4 (trạng thái 0 = teal (0.36863,0.86667,0.71373)); vạch
chia 1.5×32 indigo α0.18 radius 0.75; biển 44 | Neo source:
SpeedBubble/SPPBubbleView.m (style 1) | Điểm can thiệp: tại nhánh style 1
| Mức bằng chứng: VERIFIED

### SpeedBubble style 2 — vòng nhỏ + nearRing amber
Loại: shape | Đặc tả số: glass (4,4,76,76) corner 38; nearRing
CAShapeLayer stroke amber lineWidth 3, oval (1.5,1.5,73,73), ẩn trừ trạng
thái 1; trạng thái 2: glass đỏ (255,90,95)→(240,64,70); biển 72 tại
(124,41); content 160×80 | Neo source: SpeedBubble/SPPBubbleView.m
(style 2) | Điểm can thiệp: tại nhánh style 2 | Mức bằng chứng: VERIFIED

### SpeedBubble style 3 — cung 270°
Loại: shape/gradient | Đặc tả số: glass 104×104 corner 52; cung 270° tâm
(52,52) bán kính 46, từ 2.356194490192345→7.0685834705770345 rad; track
indigo α0.12 lineWidth 7 round cap; fill = gradient ring lineWidth 7 mask
cùng cung, strokeEnd = ratio (anim 0.6 s); biển 46 tại (52,99); content
104×122 | Neo source: SpeedBubble/SPPBubbleView.m (style 3) | Điểm can
thiệp: góc cung / lineWidth tại nhánh style 3 | Mức bằng chứng: VERIFIED

### SpeedBubble style 4 — card mesh + progress
Loại: mesh/gradient | Đặc tả số: card 124×124 corner 28; mesh
CAGradientLayer chéo (1,0)→(0,1): sky (0.65098,0.86667,0.99216) α0.9→0 và
pink (0.99608,0.76863,0.84706) α0→0.9, locations @[@0,@0.5,@0.5,@1], ẩn
khi trạng thái ≠ 0; glass border white, shadow RGB(0.31373,0.27451,
0.62745) opacity 0.28 radius 12; progress track (12,106,100,6) white
α0.55 radius 3; fill gradient (0,0.5)→(1,0.5) accent RGB(0.60784,…)→
RGB(0.36471,…) | Neo source: SpeedBubble/SPPBubbleView.m (style 4) | Điểm
can thiệp: tại nhánh style 4 | Mức bằng chứng: VERIFIED

### SpeedBubble style 5 — số trần + track mảnh
Loại: shape/gradient | Đặc tả số: glass ẩn; số 48 pt; track (92×5) white
α0.8 radius 2.5, shadow đen opacity 0.15 radius 2 offset (0,1); fill
gradient = Colors3; nhãn có shadow trắng radius 4 | Neo source:
SpeedBubble/SPPBubbleView.m (style 5) | Điểm can thiệp: tại nhánh style 5
| Mức bằng chứng: VERIFIED

### SpeedBubble style 6 — pill tối + glow
Loại: shape/gradient/glow | Đặc tả số: pill tối 70×contentH corner 35;
glass trên RGB(0.07059,0.07843,0.11765) α0.82 → dưới RGB(0.04706,0.05098,
0.07843) α0.86, border 0, sheen ẩn, shadow đen opacity 0.35; glow
CAShapeLayer stroke violet lineWidth 1.5, shadow violet radius 4 opacity
0.9; conic ring lineWidth 1.5 mask rounded rect (0.75,0.75,68.5,H−1.5)
radius 34.25; biển 50 tại (35,33) | Neo source:
SpeedBubble/SPPBubbleView.m (style 6) | Điểm can thiệp: tại nhánh style 6
| Mức bằng chứng: VERIFIED

### SpeedBubble style 7 — cột ticks
Loại: shape/mask/gradient | Đặc tả số: strip ticks 61×24 tại y17; mask
gồm các cột rounded rect rộng 5 cách 8, cao h = 14.88×(1−(x+2.5)/61),
radius 1.5; nền strip indigo α0.16; fill gradient Colors3 / amber (state
1) / đỏ (state 2), anim width 0.9 s; glass corner 29 cao 59; biển 50 |
Neo source: SpeedBubble/SPPBubbleView.m (style 7) | Điểm can thiệp: công
thức chiều cao cột tại nhánh style 7 | Mức bằng chứng: VERIFIED

### SpeedBubble style 8 — gauge analog (kim)
Loại: shape/gradient/glyph-path | Đặc tả số: deco 140×140, shadow đen
opacity 0.35 radius 8 offset (0,4), shadowPath vòng r70; mặt radial
gradient RGB(0.16471,0.18039,0.27059)→RGB(0.04706,0.05098,0.07843),
startPoint (0.5,0.42) endPoint (1.1,1.02), bán kính 70; ring conic
lineWidth 3 mask cung r67; vòng trong r64 white α0.08 lineWidth 1; góc
gauge: angle(v) = 150 + 240×min(max(v,0)/160, 1.04) độ, tâm (70,70); tick
mỗi 10 km/h từ 0–150: minor r57→61 lineWidth 1.2 white α0.45, major
r53→61 lineWidth 2 white α0.9; nhãn tại r43 (9 nhãn 0,20,…,160 — vòng lặp
nhãn dừng ở 150 nên nhãn cuối không được đặt); vùng đỏ: cung r63 từ
limit→160, stroke đỏ α0.9 lineWidth 3.5 butt cap, ẩn nếu limit < 1 hoặc
≥ 160; limTick r52→65 lineWidth 2.5 round; progress: gradient ring
lineWidth 3 (linear (0,1)→(1,0)) mask cung r49 từ 2.6179938779914944→
6.8067840827778845 rad, strokeEnd theo gauge; kim: path tam giác
(59,67.8)→(117,70)→(59,72.2) fill RGB(1,0.35294,0.21176), shadow cùng màu
radius 3 opacity 0.8, xoay theo angle(speed); hub vòng r7 fill
RGB(0.13725,0.14902,0.22745) stroke white α0.85 lineWidth 1.5; content
164×158 | Neo source: SpeedBubble/SPPBubbleView.m (style 8) | Điểm can
thiệp: dải góc / màu kim tại nhánh style 8 | Mức bằng chứng: VERIFIED

### Cảnh báo vượt giới hạn — flash đỏ + pulse
Loại: hiệu ứng | Đặc tả số: flashView đỏ (255,90,95) pulse opacity 0.5 s
autoreverse vô hạn (key sppFlash) + biển pulse scale (key sppPulse);
frame flash = inset −6 quanh flashRef (style 0,2,3,5,8) hoặc glass bounds
(1,4,6,7) | Neo source: SpeedBubble/SPPBubbleView.m | Điểm can thiệp: chu
kỳ pulse tại SPPBubbleView | Mức bằng chứng: VERIFIED

### SPPBubble — menu bong bóng + slash "off"
Loại: shape/glyph-path | Đặc tả số: nút menu 48×48 radius 18, bg white
α0.55, border 1 white α0.95, shadow RGB(0.27451,0.23529,0.54902) opacity
1 radius 3 offset (0,2); symbol 17 pt; nút "off" thêm CAShapeLayer tên
"slash": path (8,28)→(28,8), lineCap round, fill nil — source phục hồi
KHÔNG gán path, số liệu này đào từ disasm (path + cap VERIFIED; lineWidth
có hai hằng 2.4/5.4 chọn theo cờ, stroke white α0.95 ở một nhánh — PARTIAL);
panel shadow RGB(0.35294,0.27451,0.66667) radius 12 offset (0,6); item
đầu là logo mesh tròn (radius = h/2, border 1 white α0.92); shield white
α0.02 | Neo source: SpeedBubble/SPPBubble.m `-setMenuButton:off:`;
disasm `0001ae1c_-[SPPBubble_setMenuButton_off_].txt` | Điểm can thiệp:
path slash tại setMenuButton:off: | Mức bằng chứng: PARTIAL (xem trên)

## E. StartupScreen — cảnh khởi động (canvas 1600×600)

Quy ước canvas: _k = s/6 với s = min(H/100, W/260); _ox/_oy căn giữa.

### SSStartupView — nền gradient theo cảnh
Loại: gradient | Đặc tả số: layerClass = CAGradientLayer axial
(0.5,0)→(0.5,1); ss_sceneColors: style 4: 0x05070C→0x000000; 5:
0x020308→0x06070D; 6: 0x020309→0x070A18; 7: 0x01050C→0x04121E; 8:
0x0C1A33→0x1F3A66; 9: 0xEEF0FB→0xF4F5FB; occasion 1: 0x5A0006→0xA3000F;
2: 0x1B0B3A→0x3B1A78; 3: 0x04121F→0x0B2A3D; 4: 0x0A0A24→0x1D1446; mặc
định 0x020A24→0x0B1D4A. Style 3 (thời tiết) chọn lại gradient theo
category (bảng rgb trong -reload) | Neo source:
StartupScreen/SSStartupView.m `ss_sceneColors`, `-reload` | Điểm can
thiệp: bảng màu tại ss_sceneColors | Mức bằng chứng: VERIFIED

### Logo + nhãn cảnh khởi động
Loại: shape/text/shadow | Đặc tả số: logo hình vuông cạnh min(W×0.5,
H×0.62), shadowRadius 7×s; symbol poster dự phòng render 28×s pt; nhãn
cảnh: shadowRadius 1.5×unit, offset (0, 0.5×unit); font: greeting time
30u Light / title 10u Semibold / date 6u Medium; thời tiết: temp 30u
Medium, icon 32u; thẻ thời tiết radius 5.5u, blur style 16 (SystemMaterial,
truyền số thô), border 0.5 white α0.22, contentView đen α0.18 | Neo
source: StartupScreen/SSStartupView.m | Điểm can thiệp: tại SSStartupView
| Mức bằng chứng: VERIFIED

### Gauge động cơ (RPM / SPEED) — ScenesB
Loại: shape/gradient/glyph-path | Đặc tả số: cung 3π/4→9π/4, lineWidth
max(u×10,2), track white α0.1 round cap; fill gradient (0,0.5)→(1,0.5)
0x7FD3FF→0xFFFFFF bị mask bởi cung strokeEnd, glow shadow trắng opacity
0.6 radius u×8; 11 tick từ r−26u→r−14u lineWidth max(u×3,1) (hai lớp:
white α0.55 và RGB(1,0.36078,0.32941) α0.9 — parity INFERRED); kim từ tâm
tới (mid.x−30u, mid.y) lineWidth max(u×5,1.5) màu RGB(1,0.36078,0.32941),
shadow radius u×6 opacity 1; hub oval 28u×28u fill RGB(0.06667,0.06667,
0.06667). Hai gauge r = u×210 tại (_ox+330u, _oy+320u) RPM max 8 red 0.8
và (_ox+1270u, _oy+320u) SPEED max 220/140 red 0.9. ss_setGauge: kim quay
π×0.75 + value×π×1.5; hot (value > red) → fill trên 0xFF5C54, số đỏ | Neo
source: StartupScreen/SSStartupViewScenesB.m `ss_gaugeAt:` (@0x12a98),
`ss_setGauge:` | Điểm can thiệp: dải cung / màu fill tại ss_gaugeAt: |
Mức bằng chứng: VERIFIED (parity của tick: INFERRED)

### Đèn cảnh báo động cơ (6 lamp)
Loại: glyph-symbol | Đặc tả số: 6 lamp SF Symbol tại x = 600+80i (u),
y = 120u, pointSize max(u×30,6) weight 7, shadow màu lamp opacity 0.7
radius u×5; danh sách symbol + màu ở mục SF Symbols | Neo source:
StartupScreen/SSStartupViewScenesB.m | Điểm can thiệp: tại builder lamp |
Mức bằng chứng: VERIFIED

### SSPathGlowLayer — đường phát sáng
Loại: shape/glow | Đặc tả số: shape layer fill nil, stroke white,
lineWidth max(unit×6,1.5), round cap/join, shadow RGB(0.62745,0.82353,1)
opacity 0.95 radius unit×15; dùng cho wave/arcs ở cảnh Welcome | Neo
source: StartupScreen (sub_149cc) | Điểm can thiệp: tại SSPathGlowLayer |
Mức bằng chứng: VERIFIED

### SSRadialGlowLayer — quầng sáng radial
Loại: gradient | Đặc tả số: radial gradient startPoint (0.5,0.5)
endPoint (1,1); frame = hình vuông đường kính 2r quanh tâm; dùng khắp
các cảnh (mặt trời, trăng, blob…) | Neo source: StartupScreen
(sub_12554) | Điểm can thiệp: tại SSRadialGlowLayer | Mức bằng chứng:
VERIFIED

### Bầu trời — mặt trời / sao / trăng / mây / sương
Loại: shape/gradient/glyph-symbol | Đặc tả số: mặt trời tại (_ox+1340k,
_oy+150k): 12 tia CALayer bg RGB(1,0.94118,0.70588) α0.18, bounds
520k×28k, anchor (0,0.5), xoay i×π/6; glow radial r180k. Đêm: 110 sao
(bán kính max(k×(0.6+1.4rand), 0.5), y trong 0.7H, twinkle opacity
0.4+0.6|sin(2t+phase)|) + glow trăng r120k. Mây: ảnh cloud.fill 120 pt
nhuộm (trắng ngày / RGB(0.70588,0.74510,0.82353) đêm), rộng k×(260+
100rand), opacity 0.35–0.6, drift k×(8+14rand). Sương: 6 dải radial
gradient trắng α 0.3/0.14/0, locations 0/0.6/1, bounds 840k×110k | Neo
source: StartupScreen/SSStartupViewBuilders.m | Điểm can thiệp: tại
builder sky | Mức bằng chứng: VERIFIED

### Mưa + kính ướt + gạt nước + sét + tuyết
Loại: shape/mask/glyph | Đặc tả số: giọt mưa SSRainDropImage — canvas
3×40 clip ellipse, radial gradient trắng α0.75→RGB(0.70588,0.78431,
0.86275) α0.15, tâm (11,14) r0 → (16,20) r22, DrawsAfterEndLocation; 70
giọt (sky 6) / 120 giọt (sky 7,8), layer 1.6len×2len, len = k×(3+6rand);
pane tối RGB(0.11765,0.15686,0.21569) α0.55; wet mask CAShapeLayer
even-odd fill đen, quét theo cung ±0.4 rad quanh pivot (W×0.5, H+81k),
bán kính min(980k, 0.6125W); gạt nước: arm stroke RGB(0.04314,0.04314,
0.05098) lineWidth max(16k,2) round, blade (60k,−6k)→(L,−6k) white α0.15
lineWidth max(3k,1); sét: plane RGB(0.86667,0.90196,1) opacity theo
pow(sin) khi apply; tuyết: 100 hạt tròn trắng α0.85 r = k×(1.5+3rand) |
Neo source: StartupScreen/SSStartupViewBuilders.m | Điểm can thiệp: tại
builder weather | Mức bằng chứng: VERIFIED

### Hạt tên người dùng (particles)
Loại: draw-immediate | Đặc tả số: tên người dùng raster hoá alpha-only
bitmap (ngưỡng > 0x80, bước lấy mẫu step = max(sqrt(onCount/800),1), tối
đa 900 hạt, record 48 byte {targetX, targetY, startX, startY, delayA,
delayB, hue 190+40rand}); _dot = max(step×0.55, 1.5) | Neo source:
StartupScreen/SSStartupViewBuilders.m | Điểm can thiệp: ngưỡng/số hạt tại
builder particles | Mức bằng chứng: PARTIAL — hàm vẽ `ss_drawParticles:`
mâu thuẫn giữa hai bản phục hồi (bản StartupScreen: blend Screen, fill
rect trắng, record kiểu SSParticle {x,y,vx,vy,size,phase} không khớp
layout 48 byte của Builders; bản Prefs: blend PlusLighter, rect 2.2×2.2,
màu RGB(0.72,0.68,1)) — chưa chốt được thân vẽ

### HUD khởi động — 3 vòng + đĩa quét + checklist
Loại: shape/gradient/text-symbol | Đặc tả số: 3 vòng tâm (_ox+400k,
_oy+300k) r = 210k/170k/130k, stroke accent RGB(0.47059,0.86275,1)
α0.55, lineWidth max(3k,1)/max(2k,1)/max(2k,1); dash vòng 2 @[6k,10k],
vòng 3 @[40k,16k]; đĩa conic quét r205k, góc (0.5,0.5)→(1,0.5), màu
accent α 0/0/0.45 locations 0/0.88/1, masksToBounds radius discR; nhãn %
màu RGB(0.66667,0.92157,1) 64 pt Heavy đếm 0→100%; hàng checklist glyph
✓/! 30 pt Heavy (✓ RGB(0.47059,1,0.66667), ! RGB(1,0.66667,0.23529)) +
chữ RGB(0.86275,0.94118,1); chữ READY 44 pt Heavy | Neo source:
StartupScreen/SSStartupViewBuilders.m | Điểm can thiệp: tại builder HUD |
Mức bằng chứng: VERIFIED

### Briefing — thẻ kính thông tin
Loại: shape/text | Đặc tả số: thẻ 700k×210k, bg white α0.08, radius 34k,
border max(1.2k,0.5) white α0.22; lưới 2 cột (x 70/810; hàng đặc biệt căn
giữa 450; y 70+240×hàng, hoặc 195 khi 2 hàng); icon emoji 70 pt tại
(90k,105k); title 40 pt Bold; detail 26 pt Medium α0.7 | Neo source:
StartupScreen/SSStartupViewBuilders.m | Điểm can thiệp: tại builder
briefing | Mức bằng chứng: VERIFIED

### Liquid — blob màu + logo + chữ mask gradient + pill tải
Loại: gradient/mask/hiệu ứng | Đặc tả số: 4 blob radial glow palette
{0xB7A9FF tại (260,120) r700; 0x8FD7FF (1350,170) r650; 0x9DF668
(1250,560) r600; 0xFFC966 (320,540) r560} α0.85→0, drift position
±60k/±40–70k trong 14 s; logo 300k×300k tại (560k,300k), shadow
RGB(0.35294,0.31373,0.66667) opacity 0.35 radius 26k offset (0,14k),
breathe translation.y ±4k chu kỳ 2.4 s; title "OmniCar" 110k Heavy làm
maskView cho gradient container RGB(0.43529,0.36078,0.96471)→
RGB(0.23137,0.61176,0.94118), (0,0.5)→(1,0.5); pill tải 240k×max(8k,2)
bg RGB(0.12157,0.13333,0.2) α0.9 radius h/2, sweep gradient rộng 40% pill
RGB(0.54510,0.48627,1)→RGB(0.85,0.72157,1), anim translation.x
−0.4pillW→1.04pillW chu kỳ 1.6 s | Neo source:
StartupScreen/SSStartupViewBuilders.m | Điểm can thiệp: palette blob /
gradient chữ tại builder liquid | Mức bằng chứng: VERIFIED

### Festive — pháo hoa / hoa Tết / confetti / tuyết / mặt trăng
Loại: draw-immediate/glyph | Đặc tả số: pháo hoa: 7 burst record 32 byte
{cx,cy,delay,hue}, hue {0,45,55,330,20,200,120}, delay 0.3+0.55i. Tết:
36 cánh hoa dùng SSFlowerImage — canvas 48×48, 5 cánh ellipse
(−7,−22,14,22) vàng RGB(1,0.83137,0.23137) xoay 72° (1.2566370614359172
rad) quanh tâm + chấm đỏ RGB(0.90980,0.34902,0.04706) ellipse 9×9. Sinh
nhật: 100 confetti dải size×6k màu HSL(h rand, 0.9, 0.6). Giáng sinh: 120
tuyết. Trung thu: 7 mặt trăng mote — glow radial RGB(1,0.66667,0.31373)
α0.35 r90k + oval CAShapeLayer rect (−0.03k,−0.06k,68k,86k) fill
RGB(1,0.47059,0.15686) α0.9; glow nền trăng tại (_ox+1300k, _oy+160k)
r160k | Neo source: StartupScreen/SSStartupViewBuilders.m | Điểm can
thiệp: tại builder festive | Mức bằng chứng: VERIFIED, trừ
`ss_drawFireworks:` — PARTIAL: hai bản phục hồi mâu thuẫn (StartupScreen:
blend Screen, 24 tia/burst, ellipse 3×3 RGB(1,0.8,0.4); Prefs:
PlusLighter, tia = b[i].b, r = life×46×unit)

## F. Prefs — vẽ tức thời (drawRect:) và preview

### OMCSplitPreview -drawRect:
Loại: drawRect | Đặc tả số: nền RGB(0.055,0.06,0.075) radius 14; strip
trái (0,0,30,H) RGB(0.086,0.09,0.106); 3 "traffic dot" rounded rect 16×16
radius 5 tại (7, y) y = 10/32/54, màu #8B7CFF / #2E9CF5 / #FA2D55; hai
pane y=4 cao H−8: p1 x=34 rộng floor((W−40)×0.46), p2 x=38+leftW, fill
RGB(0.12,0.13,0.16) radius 10; icon cạnh min(paneH×0.42, 44) vẽ giữa
pane; pin badge pin.fill #FFB340 tại (maxX(p2)−18, 10, 12, 13); trạng
thái off: chữ 13 pt white α0.55 căn giữa lệch +15 | Neo source:
Prefs/OMCPrefs/OMCSplitPreview.m `-drawRect:` (@0x37a48) | Điểm can
thiệp: tại drawRect: | Mức bằng chứng: VERIFIED

### OMCHSPreview -drawRect:
Loại: drawRect | Đặc tả số: canvas logic rộng 800 (scale = W/800);
wallpaper aspect-fill vào (64,0,736,H) tâm (432,H/2); blur wash trắng
min(blur/120, 0.25); dim wash đen dim/100; không wallpaper: fill
RGB(0.10,0.11,0.14); strip trái (0,0,64,H) RGB(0.06,0.07,0.08); đồng hồ
"9:41" bold 12 tại (17,8); icon strip tại (11, 34+50k, 42, 42); 6 vạch
dưới-trái 7×6 white α0.8 tại x = 18+(i mod 3)×10, y = H−30+(i>2 ? 9 : 0);
lưới icon: cell 712/cols × (H−30)/rows, icon round(64×size/100), drawIcon
có CG shadow offset (0,3) blur 6 đen α0.3, fallback tile rounded rect
radius w×0.225 white α0.16; nhãn 12 pt Medium trắng rộng min(textW,
cellW−6) cao 16; page pills: pill đầu 16×6, còn lại 6×6, radius 3, white
α1/0.4, y = H−12, tâm x = 432; thẻ video "▶︎ video" 12 pt Semibold white
α0.85 tại (730, H−20) | Neo source: Prefs/OMCPrefs/OMCHSPreview.m
`-drawRect:` (@0x1bc48) | Điểm can thiệp: tại drawRect: | Mức bằng chứng:
VERIFIED, trừ danh sách phần tử icon strip trái — UNRECOVERED (hằng tại
0x7f948, payload rỗng trong source; hình học vị trí đã biết)

### OMCIconSized — fallback tile Prefs
Loại: gradient/glyph-symbol | Đặc tả số: tile gradient + symbol một
trong app.fill / play.fill / gearshape.fill / car.fill (màu: play #FF8A65
→#FF3D71, car #5AB8FF→#2E7CF6, khác #9AA0A8→#636A73); symbol pointSize =
points×0.48 Semibold | Neo source: Prefs/OMCPrefs/OMCHSPreview.m
`OMCIconSized` | Điểm can thiệp: tại OMCIconSized | Mức bằng chứng:
VERIFIED

### OMCHeaderCard — thẻ đầu Prefs
Loại: gradient/blur/shadow | Đặc tả số: card radius 20; shadow đen
opacity 0.18 (bật: 0.22 / tắt: 0.10) radius 16 offset (0,6); shadowPath
rounded rect radius 20; gradient chéo #B7A6FF→#8FD3FF→#9DF2D8 (0,0)→(1,1);
glass UIBlurEffectStyleSystemUltraThinMaterial; sheen trắng α0.12 nửa
trên; logo 44×44 tại (margins.left+16, 18); chấm trạng thái 8×8 radius 4
(systemGreen / tertiaryLabel) | Neo source: Prefs/OMCPrefs/OMCHeaderCard.m
| Điểm can thiệp: tại OMCHeaderCard | Mức bằng chứng: VERIFIED

### SPPMapImage — bản đồ giả (Prefs SpeedBubble)
Loại: draw-immediate | Đặc tả số: nền #EEF0EA; oval công viên #CDECCF
(0.62w,0.08h,0.3w,0.34h); oval nước #C8E4F7 (0.05w,0.6h,0.26w,0.3h); 3
đường round cap: #FFE9A8 lineWidth h×0.09 (−10,0.68h)→(w+10,0.4h); trắng
lineWidth h×0.06 (0.3w,−10)→(0.45w,h+10); #3D8BFF lineWidth h×0.045
(−10,0.25h)→(w+10,0.8h) | Neo source:
Prefs/OMCPrefs/OMCSpeedBubbleController.m `SPPMapImage` | Điểm can thiệp:
tại SPPMapImage | Mức bằng chứng: PARTIAL (palette VERIFIED; hình học
đường INFERRED)

### SPPSetRing — vòng conic quanh nút (Prefs)
Loại: gradient/mask | Đặc tả số: conic ring tên "omcRing", frame inset
−2.5, màu #A78BFA / #60C5FA / #5EDDB6 / #F59AC0 / #A78BFA, startPoint
(0.5,0.5) endPoint (0,1); mask rounded rect inset 1.25 radius 12, stroke
black lineWidth 2.5 | Neo source: Prefs/OMCPrefs/OMCSpeedBubbleController.m
`SPPSetRing` (sub_2b2ec) | Điểm can thiệp: tại SPPSetRing | Mức bằng
chứng: VERIFIED (radius mask 12: INFERRED exact)

### Swatch màu + avatar dự phòng + nút "try" (Prefs)
Loại: shape/gradient/text | Đặc tả số: swatch 26×26 radius 13; ô 0 chứa
conic gradient cùng bảng SPPSetRing; ô đang chọn thêm vòng CAShapeLayer
oval inset −4 stroke #6F62F2 lineWidth 2; avatar nguồn dự phòng: ô 60×60
fill #F07A12 / #1AA260 / #33CCFF / #E5322D + chữ cái V/G/W/Y 28 pt Heavy
trắng giữa ô; nút "try" gradient radius 13 | Neo source:
Prefs/OMCPrefs/OMCSpeedBubbleController.m | Điểm can thiệp: tại controller
| Mức bằng chứng: VERIFIED (số màu nút "try" chưa đọc kỹ — PARTIAL)

### Tile wallpaper conic (Prefs AppBridge)
Loại: gradient/mask | Đặc tả số: tile style 1–6: conic gradient frame
inset −3, startPoint (0.5,0.5) endPoint (0,1); source dùng systemPurple /
Blue / Pink / Orange / Teal nhưng chú thích ghi 5 bộ RGB từ constant pool
0x657a0 (thứ tự thành phần INFERRED); mask rounded rect inset 1 radius 12
stroke black lineWidth 2 — mask lại được addSublayer thẳng vào tile.layer
thay vì gán làm mask (ghi nguyên trạng) | Neo source:
Prefs/OMCPrefs/OMCAppBridgeAppsController.m `layoutTilesIn:` | Điểm can
thiệp: tại layoutTilesIn: | Mức bằng chứng: PARTIAL

### OMCSSStyleTileCell — ô style màn hình khởi động (Prefs)
Loại: gradient/glyph-symbol | Đặc tả số: card 62×62 radius 18; fill
gradient (0,0)→(1,1) hai màu suy từ base hex (giữ hue, saturation ×0.75,
brightness ×1.15); đang chọn → #8B7CFF→#5AB8FF + shadow #6E78FF opacity
0.5; glyph 28 pt Semibold tint white; base hex theo style 0–10: #E11D48,
#7C3AED, #F59E0B, #0EA5E9, #EA580C, #0D9488, #C026D3, #16A34A, #4F46E5,
#8B7CFF, #475569 | Neo source: Prefs/OMCPrefs/OMCSSStyleTileCell.m | Điểm
can thiệp: bảng base hex tại OMCSSStyleTileCell | Mức bằng chứng:
VERIFIED

### SPPGlassView — bản Prefs (khác bản SpeedBubble)
Loại: gradient/shadow | Đặc tả số: fill CAGradientLayer border 1 white
α0.85, cornerCurve continuous; sheen white α0.5→0 chiếm 55% chiều cao;
mặc định top white α0.9, bottom RGB(0.945,0.941,0.984); shadow
RGB(0.275,0.235,0.549) opacity 0.22 radius 10 offset (0,4); shadowPath
rounded rect theo corner; userInteractionEnabled = NO | Neo source:
Prefs/OMCPrefs/SPPGlassView.m (init @0x2c6fc) | Điểm can thiệp: tại
SPPGlassView (Prefs) | Mức bằng chứng: VERIFIED — khác bản SpeedBubble ở
shadowOpacity (0.22 so với INFERRED 1) và fill mặc định

### Gauge + outline xe (SSStartupView bản Prefs)
Loại: shape/gradient/glyph-path | Đặc tả số: gauge: track white α0.18
lineWidth 4u; fill gradient 0x2BC79A→0x5AB8FF mask cung; kim trắng
lineWidth 2u; ss_setGauge bản Prefs chia value/max (KHÁC bản
StartupScreen VERIFIED là không chia). Car outline ở ss_buildWelcome:
bezier silhouette tương đối (0.16w,0.66h)→(0.3w,0.64h)→quad
(0.36w,0.52h)→(0.42w,0.5h)→(0.6w,0.5h)→quad (0.68w,0.52h)→(0.72w,0.64h)→
(0.84w,0.66h), stroke RGB(0.48,0.42,0.96) lineWidth 2u round, shadow cùng
màu opacity 0.7 radius 8, strokeEnd chạy 0→1 trong 1.8 s từ t=0.4. HUD
Prefs: vòng dash @[@4,@3] stroke RGB(0.48,0.42,0.96) α0.7 lineWidth 1.5u
r=20u tại (0.86W,0.52H); apply: xoay 0.25t + strokeEnd 0.65+0.3·sin(0.8t)
| Neo source: Prefs/OMCPrefs/SSStartupView.m | Điểm can thiệp: tại bản
Prefs của SSStartupView | Mức bằng chứng: PARTIAL — nhiều builder chỉ
"VERIFIED composition, geometry INFERRED in detail"; ivar `_wheels` tồn
tại trong header nhưng KHÔNG có thân vẽ nào gán/dùng (cả hai bản
SSStartupView đều chỉ gán nil)

## G. SF Symbols (systemImageNamed:)

Tổng: 32 call site systemImageNamed trực tiếp trong cây src/, cộng các
symbol đi qua OMCIcon (14 pt Semibold, tile gradient — xem mục OMCIcon)
và qua bảng tên trong code. SCPSymbolImage KHÔNG phải SF Symbol (glyph tự
vẽ, mục C). SplitScreenC/home không có systemImageNamed riêng (icon app
lấy qua SCPAppIconForBundle — ảnh hệ thống); SplitScreenA không có vẽ
riêng đáng kể ngoài chrome kế thừa B.

### SF Symbols — bàn phím AB
Loại: symbol | Đặc tả số: `keyboard.chevron.compact.down` 16 pt Medium,
tint RGB(74,79,128) — nút ẩn bàn phím; qua ABKey symbol 15 pt Medium:
`shift` / `shift.fill` (theo trạng thái shift), `delete.left`, `globe`,
`return` | Neo source: AppBridgeB/ABKeyboard.m (~line 535; 622–639;
806–808) | Điểm can thiệp: tại ABKeyboard | Mức bằng chứng: VERIFIED

### SF Symbols — menu SPPBubble
Loại: symbol | Đặc tả số: `minus`, `plus`, `exclamationmark.triangle`,
`speaker.wave.2`, `xmark` — 17 pt, template tint indigo (kind 4: tint phụ
thuộc trạng thái cảnh báo) | Neo source: SpeedBubble/SPPBubble.m | Điểm
can thiệp: tại SPPBubble menu | Mức bằng chứng: VERIFIED tên/cỡ; weight
Medium và mapping tint kind 4: INFERRED

### SF Symbols — thời tiết StartupScreen
Loại: symbol | Đặc tả số: theo mã thời tiết ngày/đêm: `sun.max.fill` /
`moon.stars.fill`, `cloud.sun.fill` / `cloud.moon.fill`, `cloud.fill`,
`cloud.fog.fill`, `cloud.drizzle.fill`, `cloud.heavyrain.fill`,
`cloud.sun.rain.fill` / `cloud.rain.fill`, `cloud.snow.fill`,
`cloud.bolt.rain.fill`; cấu hình thẻ: 44 pt weight 4 (Regular dạng số) +
PreferringMulticolor; sprite mây trên trời: `cloud.fill` 120 pt; bản
Prefs: 180 pt Regular + multicolor, fallback `cloud.fill` | Neo source:
StartupScreen/SSStartupViewScenesB.m `SSWeatherSymbolAndText` (sub_eb68);
Prefs/OMCPrefs/SSStartupView.m | Điểm can thiệp: bảng ánh xạ mã→symbol
tại SSWeatherSymbolAndText | Mức bằng chứng: VERIFIED (bản SSStartupView.m
`SSWeatherSymbolName` ghi INFERRED và có 2 tên khác: `moon.fill` cho mã 0
đêm — bản VERIFIED dùng `moon.stars.fill`; `cloud.bolt.fill` cho ≥95 —
bản VERIFIED dùng `cloud.bolt.rain.fill`)

### SF Symbols — đèn cảnh báo + dự phòng StartupScreen
Loại: symbol | Đặc tả số: lamp: `fuelpump.fill` #FFB400;
[`minus.plus.batteryblock.fill`, `minus.plus.batteryblock`, `bolt.fill`]
#FF5C54; `exclamationmark.triangle.fill` #FFB400; (entry 3 không tên →
chữ "ABS"); [`engine.combustion.fill`, `exclamationmark.circle.fill`]
#FFB400; [`headlight.high.beam.fill`, `light.max`] #50C8FF — cấu hình
max(u×30,6) weight 7, lấy tên đầu tiên nạp được. Dự phòng: poster
`play.rectangle.fill` tint white α0.35; logo `car.fill` tint white | Neo
source: StartupScreen/SSStartupViewScenesB.m; SSStartupView.m | Điểm can
thiệp: bảng lamp tại ScenesB | Mức bằng chứng: VERIFIED

### SF Symbols — Prefs: AppBridge controller
Loại: symbol | Đặc tả số: `chevron.down` / `chevron.right` (mở/đóng
section, không config riêng); `rectangle.split.3x1.fill` #5AB8FF;
`rectangle.split.1x2.fill` #2BC79A; `plus.magnifyingglass` #8B7CFF (qua
OMCIcon); `drop.fill` / `moon.fill` (blur); `play.circle.fill` (badge
video tile) | Neo source: Prefs/OMCPrefs/OMCAppBridgeAppsController.m
(~line 609; ~740) | Điểm can thiệp: tại controller | Mức bằng chứng:
VERIFIED

### SF Symbols — Prefs: SpeedBubble controller
Loại: symbol | Đặc tả số: `play.circle` / `play.circle.fill` 22 pt
Regular (~line 585); `rectangle.dashed` #FF5A5F; `speaker.wave.2.fill`
#5AB8FF; `rectangle`; `sun.max.fill`; `rectangle.fill`; `circle.circle`
(fx tiles, 12 pt Semibold); `app.badge.fill` #FF7FA8; `car.fill` /
`iphone` #2BC79A; `exclamationmark.triangle.fill` #FFB340;
`paintpalette.fill` (OMCIcon #A78BFA) | Neo source:
Prefs/OMCPrefs/OMCSpeedBubbleController.m | Điểm can thiệp: tại
controller | Mức bằng chứng: VERIFIED

### SF Symbols — Prefs: SplitScreen / Startup / Root / picker controllers
Loại: symbol | Đặc tả số: OMCSplitScreenController: `bolt.fill` /
`rectangle.split.2x1.fill`; `pin.fill` #FFB340;
`list.bullet.rectangle.fill` #FF7FA8; `chevron.down` / `chevron.right`;
`arrow.up.left.and.arrow.down.right`; `play.rectangle.fill`;
`arrow.up.and.down.and.arrow.left.and.right` (qua OMCIcon trừ chevron).
OMCStartupScreenController: `xmark.circle.fill` (nút clear, ~line 717).
OMCSplitScreenAppPickerController: `nosign` 22 pt Regular.
OMCRootListController: `arrow.clockwise`, `globe` (bar button, không
config). OMCCommon: mọi spec "symbol" từ plist qua OMCIcon, màu mặc định
#0A59F7 | Neo source: Prefs/OMCPrefs/OMCSplitScreenController.m;
OMCStartupScreenController.m; OMCSplitScreenAppPickerController.m;
OMCRootListController.m; OMCCommon.m | Điểm can thiệp: tại từng controller
| Mức bằng chứng: VERIFIED

### SF Symbols — Prefs: CarProfiles / Onboarding / WhatsNew / style tiles
Loại: symbol | Đặc tả số: OMCCarProfilesController: `car.2.fill`,
`car.fill` (OMCIcon, màu nil). OMCOnboardingController: trang `car.fill`,
`rectangle.split.2x1.fill`… 40 pt Semibold tint white trên tile accent;
nút `square.grid.2x2.fill` (UIButtonConfiguration). OMCWhatsNewController:
symbol lấy từ WhatsNew.plist (mặc định/fallback `sparkles`); tile side 40
pointSize 18 radius 11; hero side 76 pointSize 32 radius 20; config
Semibold tint white. OMCSSStyleTileCell — glyph ứng viên theo style:
[`film`], [`seal.fill`, `seal`], [`hand.wave.fill`, `hand.wave`],
[`cloud.sun.rain.fill`], [`gauge.with.dots.needle.67percent`,
`speedometer`], [`car.side.fill`, `car.fill`], [`sparkles`], [`scope`],
[`rectangle.grid.2x2.fill`], [`drop.fill`, `drop`], [`shuffle`] — 28 pt
Semibold | Neo source: Prefs/OMCPrefs/OMCCarProfilesController.m;
OMCOnboardingController.m; OMCWhatsNewController.m; OMCSSStyleTileCell.m
| Điểm can thiệp: tại từng controller/cell | Mức bằng chứng: VERIFIED

## H. Text-symbol / emoji dùng làm icon

### Dấu "+" làm nhãn nút/ô trống
Loại: text-symbol | Đặc tả số: (1) ô trống picker: font 40 pt Light, màu
SCPColorSecondary α0.6, border picker màu accent RGB(0.60784,0.52941,
0.97255); (2) picker map: xem mục "Dấu + trong picker map"; (3) nút thêm
trong Prefs: `[btn setTitle:@"+"]` | Neo source:
SplitScreenB/SCPCarSplit+Picker.m:305; SplitScreenB/SCPCarSplit+Picker.m
(pickerMapForPane:); Prefs/OMCPrefs/OMCSplitScreenController.m:535 | Điểm
can thiệp: tại từng chỗ đặt title | Mức bằng chứng: VERIFIED

### Glyph "✓" / "!" — checklist HUD
Loại: text-symbol | Đặc tả số: nhãn glyph ✓/! 30 pt Heavy, màu xem mục
HUD; bản Prefs dùng format `"%@ %@"` với ✓ hoặc ! | Neo source:
StartupScreen/SSStartupViewBuilders.m:721; Prefs/OMCPrefs/SSStartupView.m:
1226 | Điểm can thiệp: tại builder checklist | Mức bằng chứng: VERIFIED

### Tiền tố "↑ " / "↓ " nhiệt độ
Loại: text-symbol | Đặc tả số: tiền tố nhiệt độ cao/thấp "↑ " / "↓ ";
briefing dùng format `"↑ %@ ↓ %@"` (hai khoảng trắng trước ↓) | Neo
source: Prefs/OMCPrefs/SSStartupView.m:486–487, 1278–1279;
StartupScreen/SSStartupViewScenesB.m:352–353;
SSStartupViewBuilders.m (briefing) | Điểm can thiệp: tại format string |
Mức bằng chứng: VERIFIED

### Dấu phân cách " · " và "…"
Loại: text-symbol | Đặc tả số: " · " nối pin + trạng thái sạc và các
dòng thông tin; "…" nối vào STARTUPSCREEN_PREPARING | Neo source:
Prefs/OMCPrefs/OMCCommon.m:1050; Prefs/OMCPrefs/SSStartupView.m:1283;
StartupScreen/SSStartupViewBuilders.m:798;
Prefs/OMCPrefs/OMCStartupScreenController.m:904 | Điểm can thiệp: tại
format string | Mức bằng chứng: VERIFIED

### Emoji briefing / festive / thẻ video
Loại: emoji | Đặc tả số: briefing theo category thời tiết 0–9: ☀️ 🌙 ⛅
☁️ ☁️ 🌫 🌦 🌧 ⛈ 🌨 (bảng @0x30c98); pin 🪫 (≤19%) / 🔋; lịch 📅; an toàn
🛡; chào 👋; festive 🎂 (sinh nhật), 🎄 (Giáng sinh) — cỡ 120 qua
ss_festiveIcon; thẻ video HSPreview "▶︎ video" (ký tự ▶︎ + chữ) | Neo
source: StartupScreen/SSStartupViewBuilders.m:801, 813–860, 1145, 1167;
Prefs/OMCPrefs/OMCHSPreview.m:211 | Điểm can thiệp: bảng emoji tại
Builders | Mức bằng chứng: VERIFIED

### Loại trừ (KHÔNG phải icon)
Loại: ghi chú | Đặc tả số: "..." trong CarProbe.m:974, SBFlutter.m:189,
SCPSessionCore.m:149 chỉ là cắt ngắn log/description; đồng hồ "9:41" của
HSPreview là text giả lập. KHÔNG tìm thấy ký tự ⋯/••• làm title nút (ba
chấm của handle là 3 UIView chấm vẽ riêng — xem mục Handle), không có ×/✕
dạng text (dấu X đều là glyph vector hm_close/close hoặc SF Symbol xmark /
xmark.circle.fill), không có ‹ › dạng text icon. Chuỗi mẹo trong toast
có chứa "•••" dạng ký tự trong NỘI DUNG chữ ("giữ và kéo ••• thả lên ô
khác") — là text hướng dẫn nhắc tới handle, không phải title/icon | Neo
source: SplitScreenB/SCPCarSplit+Picker.m `-showTipSoon` | Điểm can
thiệp: — | Mức bằng chứng: VERIFIED

## I. Chưa phục hồi tới mức số liệu / lưu ý trùng lặp

1. `SPPSignView -applyColors:/-setMuted:/-layoutSubviews` và `SPPIconView
-setShape:/-layoutSubviews` (SpeedBubble/SPPViews.m): thân INFERRED —
border 3 của biển giới hạn là đoán; SPPGlassView shadowOpacity = 1 và
userInteractionEnabled cũng INFERRED.
2. CAShapeLayer "slash" (SpeedBubble/SPPBubble.m `-setMenuButton:off:`):
source phục hồi không gán path; đã đào disasm được path (8,28)→(28,8) +
lineCap round + fill nil, nhưng lineWidth (hằng 2.4 và 5.4 cùng xuất
hiện, chọn theo cờ) và nhánh màu stroke chưa chốt — PARTIAL.
3. `ss_drawParticles:` và `ss_drawFireworks:`: hai bản phục hồi
(StartupScreen structural vs Prefs) mâu thuẫn về blend mode, màu, layout
record — chưa chốt được thân vẽ thật.
4. Welcome wave (StartupScreen): 11 điểm điều khiển tại @0x294b0 + 2
vector cơ sở @0x29440/@0x29450 CHƯA chép toạ độ — PARTIAL trong ScenesB.
5. OMCHSPreview: payload danh sách icon strip trái (hằng tại 0x7f948)
UNRECOVERED — hình học vị trí đã biết, nội dung chưa.
6. OMCAppBridgeAppsController conic tiles: thứ tự 5 bộ RGB từ constant
pool 0x657a0 INFERRED. SPPSetRing: radius mask 12 INFERRED exact.
SPPMapImage: hình học đường INFERRED (palette VERIFIED). Nút "try"
(OMCSpeedBubbleController): chưa đọc kỹ số màu gradient.
7. Prefs SSStartupView: nhiều builder chỉ "VERIFIED composition, geometry
INFERRED in detail"; ss_setGauge bản Prefs khác bản StartupScreen
VERIFIED; ivar `_wheels` không có thân vẽ (chỉ gán nil ở cả hai bản).
8. Tên blur style 11 (UIBlurEffectStyleSystemUltraThinMaterialLight) là
INFERRED ở mọi nơi dùng — giá trị số 11 VERIFIED; style 16 ở thẻ thời
tiết truyền số thô.
9. SPPBubble: weight Medium của symbol menu INFERRED; mapping tint kind 4
INFERRED; bố cục panel showMenu "partly INFERRED".
10. SSStartupView.m (Prefs): bảng wording greeting/weather có chỗ
NOT-RECOVERED (bản ScenesB/Builders là bản VERIFIED chính).
11. Trùng lặp cần biết khi thiết kế lại: SPPBubbleView tồn tại hai bản
phục hồi (SpeedBubble/SPPBubbleView.m — bản chi tiết, đã qua bubblefix 23
chỗ lệch; Prefs/OMCPrefs/SPPBubbleView.m — bản ít chính xác hơn, 27 hit
CAGradientLayer). Bộ glyph 24×24 tồn tại hai engine (SplitScreenB
template + AppBridgeB original). Mesh logo có hai công thức (Core/Prefs).

---

## Phần 3 — Chrome và điều khiển trên màn xe


Phạm vi: CHỈ ĐỌC. Nguồn: source phục hồi `~/workspace/omnicar-re/src/` (SplitScreenA/B/C, AppBridgeB, StartupScreen, SpeedBubble, OMCCommon), đối chiếu đo xe `work/session-hl4/check-logo-reveal.md` + `work/session-hl5/check-video-faults.md` và PATCH_NOTES §29.x (push9-clone). Khung tham chiếu đo xe: cửa sổ **640×360 pt**, ô phải rộng **297 pt**.

Quy ước mức bằng chứng: **[ĐO-XE]** = số đo/log phiên xe thật · **[VERIFIED]** = đọc line-by-line từ disasm binary gốc trong source phục hồi · **[INFERRED]** = source tự ghi inferred · **[CÂY-HL]** = lớp Muse/GPT thêm ở các vòng hl (autohide, cổng hl5/hl6…) — KHÔNG phải hành vi gốc 1.0.3. Khi source và đo xe lệch nhau, ghi cả hai ở mục "Mâu thuẫn" cuối file.

Tổng quan kiến trúc chrome: chrome tồn tại ở HAI phía tiến trình — phía CarPlayApp (`SCPCarSplit`, SplitScreenA/B) vẽ bản chính; phía SpringBoard (`ABHost`, AppBridgeB) vẽ bản mirror cho ô hosted (handle/bar/knob mirror), đồng bộ qua kênh Darwin `appbridge.*`. Người dùng chạm vào bản nào tùy ô là native hay hosted.

---

## 1. NÚT LOGO / HOME BUTTON

### homeButton — vị trí dock (launcher trên dải dock)
Loại: `SCPCButton` (UIButton) do `SCPCarSplit` sở hữu, `@property homeButton` | Đặc tả số: size = `min(gapDock − 8, 30)` pt và ≤ khoảng trống dọc (floor(avail)); chỉ khi dải dock ≥ **30 pt**; glyph trong nút: rộng 0,6×size, cao 0,4×size (hoặc theo rect glyph Home thật nếu 8 ≤ w ≤ size); host = view tổ tiên của dock view chứa rect nút (`dockHostForRect:inParent:`), dock cluster bị đẩy lên `shift` pt khi cần chỗ | Trạng thái & hành vi chạm: hiện khi ở dashboard/Home và tính năng bật; chạm → `homeButtonTapped` → `homeButtonTappedUnsafe`: tray đang mở → `collapseAppTray`, ngược lại → `showLayoutPanelForApp:` (app toàn màn hiện tại hoặc nil) | Neo source: `SplitScreenA/SCPCarSplit.m:3332` `launcherCenterInParent:size:shift:`; `:3429` `dockHostForRect:inParent:`; `:3245` `homeButtonTappedUnsafe`; khai báo `SCPCarSplit.h:86` | Điểm can thiệp: `refreshHomeButton` `SCPCarSplit.m:2996` (điểm dựng DUY NHẤT, gán tại `:3160` trong cây hl — bản gốc §29.13 là `:3095`); cổng `[gpt-home-grid-only]` | Mức bằng chứng: [VERIFIED] cơ chế gốc; [CÂY-HL] cổng retire-dock — ở hl4 cổng này chặn cả 2 vị trí khiến nút không được dựng cả phiên (kết án check-logo-reveal.md §2, PATCH_NOTES §29.25); hl5 sửa theo placement, hl6 sửa theo role (active = split role)

### homeButton — vị trí góc split ("goc", bare)
Loại: CÙNG MỘT object/vật thể với vị trí dock — không tồn tại logo riêng trong split | Đặc tả số: **34×34 pt**; glyph bare: rộng 0,5×34 = 17 pt, cao 0,36×34 ≈ 12 pt; tâm = **(appMaxX − 25, appMinY + 25)** — góc trên-phải vùng app; host = chính `tabParent`; vùng chạm hiệu dụng **44×44 pt** do `SCPCButton pointInside:` nới tối thiểu 44 (xem mục SCPCButton) → trên hình học 640×360: khung nhìn x≈598–632, y≈8–42; vùng chạm x≈593–637, y≈3–47 (dải cục bộ ô phải ≈250–294/297 pt, 47 pt đầu ô) | Trạng thái & hành vi chạm: được `raiseLauncher` nâng lên trên nội dung (`SCPCarSplit.m:3289`); thuộc tập sơn AutoHide — ẩn bằng `layer.opacity = 0` sau 4,0 s idle (xem mục AutoHide); chạm → cùng `homeButtonTapped` → panel bố cục như vị trí dock | Neo source: `SplitScreenA/SCPCarSplit.m:3332` (nhánh "goc tren phai vung app"); `SplitScreenB/SCPCButton.m:17-24`; `SplitScreenA/SCPCarSplit+AutoHide.m:104-114` (tập sơn có homeButton) | Điểm can thiệp: cổng hit-test theo trạng thái faded tại `AHPaintView`/`ahApplyCurrentStateToView:`; thu nới 44 pt tại `SCPCButton` (đụng mọi nút dùng chung class) | Mức bằng chứng: **[ĐO-XE]** 34 pt + 44×44 (check-video-faults.md §2, khớp source); [VERIFIED] hệ quả gốc nguy hiểm: bản gốc chỉ mờ bằng opacity, KHÔNG ghi hidden/alpha/userInteractionEnabled → nút vô hình VẪN ăn chạm 100% (đã gây bấm X clip YouTube / mục "Nhà hàng" mà kích hoạt logo); [CÂY-HL] cây hl6 đã thêm cổng "faded = not hittable" trong `ahPaintCurrentSet` — khác hành vi gốc, phải ghi rõ khi thiết kế lại

### raiseLauncher + installIconLongPress (hành vi phụ của nút logo)
Loại: hàm nâng z-order + bộ cài long-press lên icon | Đặc tả số: throttle tính lại vị trí tối đa 1 lần/1,0 s khi nút đã có host | Trạng thái & hành vi chạm: `raiseLauncher` chỉ nâng BẢN THÂN nút (host là tabParent → qua `raiseView:` né stackedContainer; host khác → bringSubviewToFront nếu chưa ở cuối); KHÔNG dựng/không hiện nút — nút nil thì mọi đường đều no-op lặng lẽ | Neo source: `SplitScreenA/SCPCarSplit.m:3289` `raiseLauncher`; `:2996` `refreshHomeButton` (2 điểm gọi: `SCPCarSplit.m:241` đường layout dashboard, `SplitScreenB/SCPCarSplit+Picker.m:1255` `refreshAppTab`) | Điểm can thiệp: đây là điểm "hiện mà không thấy" kinh điển — kiểm homeButton != nil trước khi đổ lỗi cho raise | Mức bằng chứng: [VERIFIED]; triệu chứng hl4 "gọi dậy không thấy logo" đã kết án ở điểm DỰNG, không phải raise (check-logo-reveal.md §2/§4)

### SCPCButton (class nút dùng chung cho logo, ô picker, chip tỉ lệ, nút panel)
Loại: UIButton subclass | Đặc tả số: `pointInside:` nới rect chạm đối xứng tới tối thiểu **44×44 pt** (hằng số −44,0); highlight: spring scale 0,9 trong 0,12 s khi nhấn / về identity 0,3 s khi thả, damping 0,7 | Trạng thái & hành vi chạm: mọi nút con cháu đều kế thừa vùng chạm ≥44 pt và hiệu ứng nhấn thu 90% | Neo source: `SplitScreenB/SCPCButton.m:17-24` (pointInside @0xe69c), `:29-45` (setHighlighted @0xe738) | Điểm can thiệp: thu/hủy nới 44 ở đây sẽ đổi vùng chạm của TOÀN BỘ chrome cùng lúc | Mức bằng chứng: [VERIFIED]

---

## 2. THANH PILL MENU CỦA TỪNG Ô (PANE BAR) + 3. GRIP 3 CHẤM VÀ MENU CỦA NÓ

Hai mục của đề bài là cùng một cơ chế: grip 3 chấm chính là handle ở đỉnh ô; "menu 5 nút" của grip chính là pane bar dưới đây. Ghi tách hai mục để đối chiếu đề bài, nội dung nút chỉ liệt kê một lần ở mục Bar.

### Grip / handle 3 chấm — phía CarPlayApp (SCPCarPane.handle)
Loại: UIView pill + 3 dot con | Đặc tả số: pill **34×12 pt**, bo góc 6, nền trắng alpha 0,35, viền 0,5 pt trắng 0,55; 3 chấm tròn **4×4 pt** (bo 2), màu navy RGB(74,79,128) alpha 0,85, tâm chấm tại x = 9/17/25, y = 6; vị trí: tâm X = giữa ô (+38 pt nếu ô không bắt đầu ở mép trên container và không phải main-stack — `handleShiftForPane:`), tâm Y = **12**; ẩn khi ô chưa có vc (`pane.handle.hidden = (vc == nil)`) | Trạng thái & hành vi chạm: 3 recognizer trên cùng handle — tap đơn → `handleTapped:` toggle bar của ô; double-tap (tap đơn phải chờ double-tap fail) → `handleDoubleTapped:` → zoom ô / đổi cỡ cửa sổ nổi; pan 1 ngón → `handlePanned:` kéo đổi chỗ ô (ghost, mục riêng). Khi bar hiện: handle được "accent" — gradient tím→xanh RGB(155,135,248)→RGB(93,180,246) + bóng phát sáng (opacity 0,45, radius 9); bar ẩn → accent tắt. Grip thuộc tập sơn AutoHide (mờ opacity sau 4 s idle toàn phiên) | Neo source: `SplitScreenB/SCPCarSplit+Chrome.m:173-198` `setupBarForPane:` (@0x22adc); `:238-297` `layoutBarForPane:`/`handleShiftForPane:`; `SplitScreenB/SCPCarSplit+Zoom.m:63` `handleTapped:`, `:51` `handleDoubleTapped:`; `SplitScreenB/SCPCarSplit+Drag.m:53` `handlePanned:` | Điểm can thiệp: `setupBarForPane:` (hình dạng grip), `layoutBarForPane:` (vị trí), accent tại `SCPApplyAccent` Chrome.m:95 | Mức bằng chứng: [VERIFIED] toàn bộ số; [ĐO-XE] phiên hl5: grip trên ô hosted từng KHÔNG mở được menu (kết án ở đường mirror/host, PATCH_NOTES §29 — bản gốc phía CarPlayApp không lỗi này)

### Grip / handle — phía SpringBoard mirror (ABPane.handle + handleHit, cho ô hosted)
Loại: UIView hit bọc ngoài + pill con | Đặc tả số: vùng hit **44×24 pt**; pill con 34×12 tại (5,6), cùng thông số vẽ như bản CarPlayApp; tâm hit: X = giữa box + `handleOffset`, Y = 12 | Trạng thái & hành vi chạm: tap → `ABHost handleTapped:` phát kênh `ABChanHandleTap {identifier}` → phía CarPlayApp `bridgeHandleTapped:` (tap đơn toggle bar; 2 tap cùng app cách nhau < 0,35 s = double-tap → zoom); pan → `ABChanHandleDrag {identifier, phase, x, y}` → `bridgeHandleDrag:` | Neo source: `AppBridgeB/ABHostBMethods.m:1251` `setupHandleForPane:` (@0x133C8), `:1284` `setHandleVisible:forPane:`, `:943` `handleTapped:`, `:920` `handlePanned:`; phía nhận: `SplitScreenA/SCPCarSplit.m:2647` `bridgeHandleTapped:`, `:2690` `bridgeHandleDrag:` | Điểm can thiệp: lệch hình học giữa mirror và bản chính là nguồn lỗi chạm ô hosted — sửa phải sửa CẢ hai phía | Mức bằng chứng: [VERIFIED]

### Pane bar (thanh pill menu) — phía CarPlayApp
Loại: UIView kính mờ (blur + ảnh mesh logo, `SCPStyleRatioMenu` radius 22) chứa hàng nút | Đặc tả số: cao **52 pt**, bo góc 22; rộng = 12 + 5×48 + 7 = **259 pt** (5 nút 48 + 1 separator 7 + đệm 12); khi ô hẹp: scale thu nhỏ = (rộng ô − 10)/259 nếu 259 > rộng ô − 10 và rộng ô − 10 > 40; tâm X = giữa ô, tâm Y = **24 + scale×26**; nút con: khung 48×40, chip kính 40×40 (tại x+4) bo 20, icon 22 pt trong icon view inset 6 (tag 0x1c85/0x1c86) | Trạng thái & hành vi chạm: sinh ra với `hidden = YES`; hiện qua `setBarVisible:YES forPane:` — ẩn bar mọi ô khác, bật accent trên grip, animation vào `SCPPrepareRatioMenu` (từ alpha 0, scale 0,9, dịch lên 8 pt, spring 0,45 s); **timer tự ẩn RIÊNG của bar: 4,0 s** (`pane.barTimer`) — độc lập với AutoHide 4 s toàn phiên; ẩn bằng animation 0,18 s (alpha→0, scale 0,94) rồi hidden=YES + khôi phục alpha/transform. Đường wake hosted `bwHandleWakePacket:` gọi cứng `setBarVisible:YES` TRƯỚC `ahReveal` — đây là nguyên nhân "gọi logo thì hiện hàng menu" ở hl4/hl5 | Neo source: `SplitScreenB/SCPCarSplit+Chrome.m:201-233` (dựng), `:318-380` `setBarVisible:forPane:` (@0x241fc); liên kết wake: `SplitScreenA/SCPCarSplit+BridgeWake.m:1171-1176` | Điểm can thiệp: tách lệnh bật bar khỏi đường wake tại BridgeWake.m:1171 (nhưng phải tính lại định nghĩa HIDDEN ở BridgeWake.m:884/901-905 vốn dùng barHidden làm thành phần); timer tại Chrome.m:333-336 | Mức bằng chứng: [VERIFIED] + [ĐO-XE] triệu chứng hl4/hl5 khớp cơ chế (check-video-faults.md §1)

### Pane bar — phía SpringBoard mirror (ABHost buildBarForPane:)
Loại: UIView mirror của bar trên, cho ô hosted | Đặc tả số: cùng 52 pt cao, rộng 259 pt, bo 22, cùng bộ 5 nút; khác bản chính ở layout: tâm Y = **50** (cố định theo box, công thức `(1−scale)×(−52)×0,5 + 50`); sinh ra hidden=YES VÀ alpha=0; nút con là `ABBarButton` — vùng chạm bị GIỚI HẠN ở rect giữa tối đa **44×44 pt** (ngược SCPCButton nới ra), nhấn thu scale 0,9 (0,12 s) / thả 0,3 s | Trạng thái & hành vi chạm: hiện/ẩn qua `setBarVisible:pop:dim:single:forApp:` nhận lệnh từ phía CarPlayApp; các nút phát action về qua kênh bridge → `bridgeBarAction:forBundle:` phân phối: replace/full/pop/bg/close | Neo source: `AppBridgeB/ABHostBMethods.m:1092` `buildBarForPane:` (@0x105B8), `:1162` `layoutBarForPane:`, `:1186` `setBarVisible:…`, `:1224` `hideBarForPane:` (ẩn 0,18 s như bản chính — từ cây này có thêm guard alpha==0 ở completion, xem mục Mâu thuẫn); nút: `AppBridgeB/ABChromeViews.m:177-207` `ABBarButton`; nhận lệnh: `SplitScreenA/SCPCarSplit.m:2627` `bridgeBarAction:forBundle:` | Điểm can thiệp: mọi thay đổi bố cục bar phải nhân đôi ở đây | Mức bằng chứng: [VERIFIED]

### Các nút trên pane bar — thứ tự trái → phải (áp dụng cả 2 phía)
Loại: 5 `SCPCButton`/`ABBarButton` 48×40 + 1 separator | Đặc tả số: separator là vạch 1×30 pt, trắng alpha 0,95, bo 0,5, đặt TRƯỚC nút đóng | Trạng thái & hành vi chạm — từng nút:
1. **Đổi app** — icon `hm_apps` (lưới 4 ô vuông), nhãn "Đổi app"/"Change app", tint navy → `paneChoose:`: ẩn bar; ô đang ghim → toast "Ô này đang ghim"; else mở picker cho slot đó (`showPickerForSlot:` + sheet).
2. **Toàn màn** — icon `hm_full`, nhãn "Toàn màn"/"Full screen", navy → `paneSolo:` → `runSoloForPane:`: ≥2 ô = toggle zoom ô; ô đơn/nổi = solo giữ app này. Khi ô ĐANG zoom, nội dung nút tự đổi thành icon `hm_split` + nhãn "Chia màn"/"Split" (đổi ở `layoutBarForPane:`).
3. **Cửa sổ nổi** — icon `hm_float`, nhãn "Cửa sổ nổi"/"Float", navy → `panePopOut:` → `popOutPane:` (đưa app ra cửa sổ nổi, hoặc hoán đổi với app đang nổi). Trên bar của CHÍNH cửa sổ nổi: đổi thành `hm_split`/"Chia màn" = dock-back, enabled khi vc != nil và tổng ô < 3; nút mờ alpha 0,35 khi không khả dụng.
4. **Chạy nền** — icon `hm_min` (vạch ngang), nhãn "Chạy nền"/"Background", navy → `paneBackground:` → đóng slot vào nền + hiện background toast có nút "Mở lại" (mục Toast).
5. **Tắt app (nút X của bar)** — icon `hm_close` (dấu ×), nhãn "Tắt app"/"Quit app", tint **đỏ** RGB(255,90,95) → `paneClose:` → `runCloseForPane:`: ẩn bar, đóng slot vào nền, lên lịch kill app hẳn (`killAppSoon:`). Đây là nút đóng ô DUY NHẤT trên bar — không có nút X riêng ngoài 5 nút này.
| Neo source: `SplitScreenB/SCPCarSplit+Chrome.m:205-216` (thứ tự mảng nút + NSNull separator), factory `:155` `SCPBarButton` (@0x23710); hành động: `SplitScreenB/SCPCarSplit+Panel.m:155` `paneChoose:`, `SplitScreenA/SCPCarSplit.m:3590/3615/3638` `paneSolo/paneBackground/paneClose:`, `SplitScreenB/SCPCarSplit+Zoom.m:254` `panePopOut:`; mirror: `ABHostBMethods.m:1097-1106` (selector barReplace:/barFull:/barPop:/barBackground:/barClose:) | Điểm can thiệp: thứ tự/icon/nhãn khai tại mảng `buttons` trong `setupBarForPane:` + mảng tương ứng ở ABHost; đổi nhãn song ngữ qua `OMCTr` | Mức bằng chứng: [VERIFIED] toàn bộ; icon là hình VẼ vector trên lưới 24×24 (`SCPDrawSymbolIcon`, RatioMenu.m) — không có file PNG

---

## 4. DIVIDER / KNOB / HANDLE KÉO

### Divider (vạch chia)
Loại: `SCPCarDividerView` (UIView) | Đặc tả số: thân dày **1 pt**, dài suốt cạnh chia của vùng app (main-stack: divider 1 chỉ dài theo ô slot 1); nền trong suốt; vùng chạm thân = bounds nới **6 pt** mỗi phía; khi không có knob hiện: chỉ vùng này ăn chạm | Trạng thái & hành vi chạm: pan → `dividerPanned:` kéo đổi tỉ lệ 2 ô kề (kẹp fraction [0,04 ; pair−0,04]); kéo 1 ô xuống dưới 0,12 → khi thả: đóng ô đó vào nền; thả bình thường → snap tỉ lệ (2 ô: gần nhất trong {1/3, 1/2, 2/3}); double-tap → `dividerDoubleTapped:` hoán đổi 2 ô kề; tap trúng knob → menu tỉ lệ (mục 7). Divider thuộc tập sơn AutoHide | Neo source: `SplitScreenB/SCPCarSplit+Layout.m:275-300` `dividerFrameAt:` (@0x11ba0), `:545` `newDividerAt:`; `SplitScreenB/SCPCarDividerView.m:97` `pointInside:` (@0xf174); kéo: `SplitScreenB/SCPCarSplit+Divider.m:105` `dividerPan:…`, `:395` `dividerDoubleTapOn:` | Điểm can thiệp: độ dày 1 pt tại `dividerFrameAt:`; ngưỡng đóng ô 0,12 và snap tại Divider.m | Mức bằng chứng: [VERIFIED]

### Knob tỉ lệ trên divider — phía CarPlayApp
Loại: UIView con của divider (`divider.knob`), `userInteractionEnabled = NO` (chạm đi qua divider) | Đặc tả số: đĩa **14×14 pt**, bo tròn 7, mặt kính blur (style 11, tên style [INFERRED] UltraThinMaterialLight; Lite mode: nền trắng 0,92), viền 1,5 pt trắng 0,95; chấm tâm "omcDot" **4×4 pt** tại (5,5), navy RGB(74,79,128); vị trí: tâm của divider (main-stack: chỉ divider 0 có knob, đặt tại giao điểm với divider 1); vùng chạm hiệu dụng: divider nhận chạm trong rect knob nới **26 pt** mỗi phía → **66×66 pt** | Trạng thái & hành vi chạm: nhấn divider → knob "active": spring scale **1,6×** (0,15 s vào / 0,3 s ra, damping 0,7), lớp gradient accent hiện, chấm chuyển trắng, bóng radius 7 opacity 0,5; thả → khôi phục. Thuộc tập sơn AutoHide cùng divider | Neo source: `SplitScreenB/SCPCarSplit+Layout.m:591` `layoutKnobOf:` (@0x2c848); `SplitScreenB/SCPCarDividerView.m:36` `SCPSetKnobActive`, `:83` `SCPKnobFaceView` (@0x35c74) | Điểm can thiệp: cỡ đĩa tại `layoutKnobOf:`; nới chạm 26 pt tại `SCPCarDividerView pointInside:` | Mức bằng chứng: [VERIFIED] (trừ tên blur style)

### Knob mirror — phía SpringBoard (ABKnobView, cho ô hosted)
Loại: UIView cửa sổ riêng trên window SpringBoard | Đặc tả số: đĩa chạm **66×66 pt** (khớp vùng nới 26 của bản chính), bo 33, nền trắng alpha 0,012; chấm kính trung tâm **14×14 pt** (layer "omcDot"); tâm đặt đúng tọa độ window mà phía CarPlayApp công bố qua gói `appbridge.knobs` ([x, y, active, index]) | Trạng thái & hành vi chạm: touches began/moved/ended/cancelled → `relay:` phát `ABChanKnobTouch {index, phase, x, y}` (tọa độ window; move bị throttle: bỏ qua nếu di chuyển < 1,0 pt) → phía CarPlayApp `remoteKnobTouch:` tổng hợp kéo: move ≥ 8 pt mới thành drag; tap nhanh = mở/đóng menu tỉ lệ; 2 tap < 0,35 s = hoán đổi ô. Trạng thái active (scale 1,6, accent) do gói knobs đẩy xuống, không tự quyết | Neo source: `AppBridgeB/ABHostBMethods.m:1506` `setKnobs:` (@0x13ABC); `AppBridgeB/ABChromeViews.m:133` `ABKnobView relay:` (@0xA58C); phía nhận: `SplitScreenB/SCPCarSplit+Divider.m:471` `remoteKnobTouch:` (@0x2edfc) | Điểm can thiệp: cỡ 66 tại `setKnobs:`; throttle 1,0 pt tại `relay:` | Mức bằng chứng: [VERIFIED]

### Cửa sổ nổi (float pane, slot 9) — phần tử liên quan divider/bar
Loại: SCPCarPane nổi trên container | Đặc tả số: cỡ nhỏ: rộng clamp(30% W, 160, 240), cao clamp(45% H, 96, 170); cỡ lớn: rộng clamp(45% W, 220, 360), cao clamp(62% H, 130, 260); đều kẹp ≤ bounds − 16; vị trí đầu: góc dưới-phải, cách mép 8 pt; viền 1 pt trắng 0,85 | Trạng thái & hành vi chạm: xuất hiện spring từ alpha 0/scale 0,6 (0,45 s); kéo bằng handle (pan riêng `floatPanned:`), thả → snap về mép trái/phải (x = 8 hoặc W − w − 8); double-tap handle → đổi cỡ nhỏ/lớn; có bar riêng (nút nổi đổi thành "Chia màn" = dock-back) | Neo source: `SplitScreenB/SCPCarSplit+Zoom.m:118` `ensureFloatPane:`, `:160` `floatSizeLarge:`, `:386` `floatPanned:` | Điểm can thiệp: preset cỡ tại `floatSizeLarge:` | Mức bằng chứng: [VERIFIED]

---

## 5. PICKER CHỌN APP + SHEET + PANEL BỐ CỤC

### Placeholder ô trống trong ô (pane.picker, dấu "+")
Loại: UIView phủ kín ô + UILabel con | Đặc tả số: frame = đúng cỡ ô (gốc 0,0 theo ô); nền: ô đã có nội dung → trong suốt; ô trống → xanh-xám nhạt RGB(238,240,251); viền màu lavender RGB(155,135,248), độ dày viền = **3 pt** khi ô này là ô đích của sheet đang mở, else 0 (`markPickerPanes`); nhãn "+" font Light **40 pt**, màu navy alpha 0,6, giữa ô | Trạng thái & hành vi chạm: hiện fade-in 0,25 s; tap → đặt ô làm đích sheet + `refreshPickerSheetSoon` mở/cập nhật sheet; gỡ bằng fade 0,15 s | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:253` `showPickerForSlot:` (@0x31530), `:914` `markPickerPanes`, `:344` `pickerPaneTapped:` | Điểm can thiệp: `showPickerForSlot:` | Mức bằng chứng: [VERIFIED]

### Picker sheet (bảng chọn app)
Loại: UIView thẻ kính (blur + mesh; bo 24, bóng radius 24 opacity 0,3), host ở tray window nếu có, else container | Đặc tả số: tổng rộng = gridW + cột phụ 150; gridW = cols×62 + 20; cols = min(max(số app, 4), (areaW − 194)/62); cao = min(areaH − 16, max(headerH + 66, gridH + 14 + extra)) với gridH = hàng/trang×56 + 4, extra = 16 khi >1 trang else 0; neo: **giữa vùng app** (tâm area). **[ĐO-XE] phiên đo cho sheet 542×242 pt** — khớp công thức với cols = 6 (6×62 + 20 + 150 = 542) trên area 640×360 | Trạng thái & hành vi chạm: vào: spring 0,5 s từ alpha 0 / scale 0,92 / dịch xuống 48 pt (có sheet cũ: cross-fade 0,35 s); các cell trang đầu stagger fade-in; đóng: fade + tụt + scale, **0,22 s [ĐO-XE: animation đóng 0,22 s khớp `removePickerSheet`]**; phủ **61,2% ô** khi đo [ĐO-XE] — nguyên nhân kết án: mặt blur+mesh của sheet là tấm đặc che app đang hiển thị bên dưới; [CÂY-HL] vòng hl5 thêm chế độ "clear face" (bỏ effect+mesh khi sheet chồng ô hosted sống, giữ viền 1 pt) — KHÔNG phải gốc | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:442` `buildPickerSheetForPane:` (@0x334e4), `:924` `removePickerSheet` (@0x32498); kết án vật che: PATCH_NOTES §29.26 + check hl4 §picker | Điểm can thiệp: mặt sheet tại điểm dựng effectView trong `buildPickerSheetForPane:` (đây là điểm can thiệp thiết kế chính của toàn luồng); công thức cỡ ngay đầu hàm | Mức bằng chứng: [VERIFIED] công thức + [ĐO-XE] 542×242 / 61,2% / 0,22 s

### Cell lưới app trong sheet
Loại: `SCPCButton` trong UIScrollView phân trang ngang (paging, ẩn thanh cuộn) | Đặc tả số: cell **62×56 pt**; icon app **38×38 pt** tại (12,9) trong cell, bo squircle 27% bề rộng, bóng radius 5; vị trí cell: x = trang×gridW + 10 + cột×62, y = hàng×56 + 2; tên app KHÔNG có nhãn chữ dưới icon trong cell — tên chỉ ở `accessibilityLabel` | Trạng thái & hành vi chạm: tap → `pickerAppTapped:` mở app vào ô đích; cell của app ĐÃ đang dùng ở ô khác: có **badge dấu check** (mục dưới) + mờ 0,3 + KHÔNG chạm được | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:674-729` (vòng dựng cell trong `buildPickerSheetForPane:`) | Điểm can thiệp: cỡ cell/icon tại vòng dựng này; muốn thêm nhãn tên app thì can thiệp tại đây (gốc không có) | Mức bằng chứng: [VERIFIED]

### Badge "đã dùng" trên cell picker
Loại: UIImageView con của cell | Đặc tả số: **14×14 pt** tại góc trên-phải icon (x = maxX icon − 10, y = minY icon − 4), bo 7, nền lavender RGB(155,135,248), glyph "check" trắng 10 pt vẽ vector, viền trắng 1 pt | Trạng thái & hành vi chạm: `userInteractionEnabled = NO`; xuất hiện kèm cell bị khóa (alpha mọi subview 0,3, cell disabled) khi bundle đã có ở ô khác hoặc đang pending | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:708-726` | Điểm can thiệp: cùng vòng dựng cell | Mức bằng chứng: [VERIFIED]

### Cột phụ 150 pt của sheet (slot-map + tiêu đề + nút hủy)
Loại: UIView con của contentView sheet tại (gridW, 0, 150, sheetH), có vạch gradient navy phân cách ở mép trái (1 pt, alpha 0→0,32→0,32→0) | Đặc tả số — từng phần tử con (tọa độ LOCAL cột): (a) **slot-map**: bản đồ ô thu nhỏ cao `scale = min(96×areaH/areaW, 56)`, bọc trong wrapper bo 12 nền trắng 0,35 viền trắng 0,7, wrapper rộng mapW + 10, đặt x = (150 − mapW)/2, y = max((sheetH − 68 − headerH)/2, 0) + 54; (b) **tiêu đề** "Chọn app cho ô N"/"Choose an app for pane N" (ô nổi: "Chọn app cho cửa sổ nổi"), font 12,5 Semibold navy, khung (8, đáy wrapper + 8, 134, titleH), tối đa 2 dòng, giữa; (c) **phụ đề** "Chạm 1 app để mở vào ô này"/"Tap an app to open it here", font 10,5, màu phụ, (8, đáy tiêu đề + 2, 134, subH); (d) **nút hủy X**: chip 32×32 (glyph "close" 14 pt), bo 16, tint đỏ, **tâm (120, 30)** → `pickerCancel:` | Trạng thái & hành vi chạm: chỉ nút X chạm được; X đóng sheet | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:582-660` | Điểm can thiệp: bố cục cột tại đoạn này; tọa độ X từng bị chép hoán đổi trục ở bản phục hồi cũ — bản hiện tại đã sửa theo dump @0x34448 | Mức bằng chứng: [VERIFIED]

### Chấm chỉ trang (picker dots)
Loại: UIView + các dot con | Đặc tả số: chỉ tồn tại khi ≥2 trang; khung (0, gridH + extra, gridW, 16); mỗi dot bo 3 (đường kính 6) | Trạng thái & hành vi chạm: `userInteractionEnabled = NO` — chỉ báo trang, cập nhật ở `scrollViewDidScroll:` qua `layoutPickerDotsForPage:` | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:731-748` | Điểm can thiệp: cùng đoạn dựng sheet | Mức bằng chứng: [VERIFIED]

### Panel bố cục (layout panel / app tray) — khung
Loại: UIView thẻ kính (blur + mesh, bo 24, bóng radius 24) tên nội bộ `tray`, host tray window hoặc tabParent | Đặc tả số: rộng = min(104 + maxChoices×84, areaW − 16); cao = min(số section×56 + 20 + (số section − 1)×6, areaH − 12); neo: giữa-ngang vùng app, **y = minY area + 6** (sát đỉnh); **timer tự đóng riêng: 4,0 s** (`restartTrayTimer` → `collapseAppTray`) | Trạng thái & hành vi chạm: mở từ nút logo / tile Home / tap giữ icon; vào: spring 0,5 s từ alpha 0, scale 0,92, dịch lên 18 pt; các nút lựa chọn stagger vào (delay 0,06 + 0,025×thứ tự, spring 0,45 s); khi panel KHÔNG ở tray window: các ô hosted bị phủ cover và app solo bị phủ placeholder cover (icon 56×56 giữa) — đây là một nguồn "che app" khác ngoài sheet | Neo source: `SplitScreenB/SCPCarSplit+Panel.m:213` `showLayoutPanelForApp:` (@0x37e8c); timer: `SplitScreenB/SCPCarSplit+Picker.m:1357` `restartTrayTimer` | Điểm can thiệp: khung + cover tại `showLayoutPanelForApp:` | Mức bằng chứng: [VERIFIED]

### Panel bố cục — từng hàng / section và nút
Loại: hàng ngang trong UIScrollView của panel: icon section (18 pt, màu phụ, tâm x = 26) + các nút lựa chọn glyph chảy ngang | Đặc tả số: nút lựa chọn **84×56 pt**, stride 84, bắt đầu x = 42, bo 14, viền trắng 0,75; glyph bố cục vẽ trong canvas **73×40 pt** (tâm nút (42,28)), ô con trong glyph cách nhau 2,5 pt, bo 5, icon app trong ô glyph cắt bo 27% cạnh, ô trống vẽ dấu "+" (cánh ≤ 4 pt, nét 1,4); nút đang chọn: vòng conic-gradient 4 màu (tím/xanh dương/xanh lá/hồng) + nền trắng alpha 0,75 (chưa chọn 0,45) | Trạng thái & hành vi chạm — từng hàng theo `panelSections:`:
- **Hàng 1 "layouts" (luôn có)** — icon section `layouts`, accessibility "Đổi bố cục": 4 lựa chọn cố định: layout **2** "2 ô", **3** "3 ô", **13** "1 lớn + 2", **31** "2 + 1 lớn" → `panelChoiceTapped:` → `layoutChosenID:`.
- **Hàng 2 "recent" (chỉ khi pref showRecent)** — icon đồng hồ `recent`: mỗi mục là 1 bố cục gần đây có >1 app, nhãn = tên hiển thị các app CarPlay nối bằng " + ", glyph dùng icon app thật của bố cục đó → chọn = mở lại setup layout với danh sách app (`openSetupLayout:apps:`).
- **Hàng 3 "favorite" (chỉ khi showFavorites và có favorite hợp lệ)** — icon sao `favorite`: favorite 1..3 đã lưu.
- Section rỗng: thay nút bằng placeholder khung nét đứt 73×40 tại (48, y + 8), dash [3,3], nhãn "Chia màn xong sẽ hiện ở đây".
- **Vạch chia + nút Thoát**: sau hàng 1 có vạch dọc 1×33 tại x = 42 + maxChoices×84 + 2; nút **thoát** = chip tròn 34×34, icon `exit` 20 pt, tint đỏ, tâm x = vạch + 28, y = 38, nhãn "Thoát chia màn"/"Exit split" (chưa chia: "Đóng"/"Close") → `exitTapped`: đang chia → giữ app của ô focus chạy solo toàn màn (`soloBundle:`), không có app giữ → `closeGoingHome:YES`; nút thoát có thể mang **badge icon app 16×16** ở góc dưới-phải = app sẽ được giữ lại | Neo source: `SplitScreenB/SCPCarSplit+Panel.m:395` `panelSections:`, `:270-390` (dựng hàng/nút/thoát), glyph: `:38` `SCPLayoutGlyphRects`, `:95` `SCPRenderLayoutGlyph`; thoát: `SplitScreenA/SCPCarSplit.m:2498` `exitTapped`, `:2483` `exitKeepBundle` | Điểm can thiệp: danh sách layout tại `panelSections:`; glyph tại 2 helper đầu file Panel.m | Mức bằng chứng: [VERIFIED] (glyph canvas 73×40 và nút 84×56 đã sửa ở vòng closure-2 — bản chép cũ 56×41/stride 88 là SAI, xem mục Mâu thuẫn)

### Popup shield (lớp chặn chạm ngoài popup)
Loại: `SCPCTouchWatch` phủ host (tray window hoặc tabParent), nền trắng alpha 0,02 | Đặc tả số: phủ toàn host; các "lỗ" exempt = rect (tọa độ window) của: tray, ratio menu, picker sheet, homeButton, ratioKnob, picker trong-ô của sheet, mọi handle/bar ĐANG hiện | Trạng thái & hành vi chạm: chạm NGOÀI lỗ → `closePopups` (đóng tray + menu tỉ lệ + sheet + mọi bar); chạm trong lỗ đi qua. Phía SpringBoard có bản tương ứng `ABShieldView`: chạm vào → phát `ABChanBarDismiss` + `ABHost outsideTouched` (nuốt chạm, không chuyển tiếp) | Neo source: `SplitScreenB/SCPCarSplit+Chrome.m:439` `updatePopupShield`, `:475` `shieldExemptRects`; mirror: `AppBridgeB/ABChromeViews.m:110` `ABShieldView touchesBegan:` (@0xA4B4) | Điểm can thiệp: danh sách exempt tại `shieldExemptRects` — thiếu phần tử nào trong danh sách này là phần tử đó bị shield nuốt chạm | Mức bằng chứng: [VERIFIED] cơ chế; hướng `isDescendantOfView:` trong `hideBarsForTouchOn:` là [INFERRED] (source tự ghi)

### ABBoxView (hộp chứa chrome mirror của ô hosted)
Loại: UIView cổng hit-test + mặt nạ lỗ | Đặc tả số: hiển thị bị cắt bởi mặt nạ CAShapeLayer even-odd: rect bounds trừ **lỗ bo góc 12** (vùng scene hosted hiện xuyên qua) | Trạng thái & hành vi chạm — thứ tự quyết định `pointInside:`: trong handleHit hiện → YES; trong bar hiện → YES; trong lỗ → NO (chạm rơi xuống scene); còn lại chỉ YES trong bounds thu bởi `passInsets` | Neo source: `AppBridgeB/ABChromeViews.m:18` `ABBoxView` (@0x98A0/0x9C10) | Điểm can thiệp: `applyHole`/`setPassInsets:` phía ABHost | Mức bằng chứng: [VERIFIED]

---

## 6. SPLASH KHI KẾT NỐI (StartupScreen)

### Splash window + khung thời lượng
Loại: `SSSplashWindow` (UIWindow) đen, level = UIWindowLevelAlert + 1000, phủ toàn màn xe; nội dung hoặc SSStartupView (style 1–11) hoặc trình phát chuỗi khung JPEG (style 0) | Đặc tả số: **thời lượng hiển thị = pref `startupScreenDuration`, mặc định 5 s, tối thiểu 1 s** (`SSPlaybackSeconds`); hết giờ → fade-out **0,4 s** rồi gỡ cửa sổ; watchdog: style 0 mà 10 s chưa có khung nào → tự hủy; chạm để bỏ qua khi pref `startupScreenTapToSkip` (mặc định bật) | Trạng thái & hành vi chạm: nội dung `userInteractionEnabled = NO` [INFERRED ở khâu gán]; tap trên window (khi tapToSkip) → dismiss ngay | Neo source: `StartupScreen/SSSplash.m:29-33, 59, 165-190, 265-290, 300-330`; thời lượng: `StartupScreen/SSStartupScreen.m:81-83` `SSPlaybackSeconds` | Điểm can thiệp: mặc định 5 s tại `SSPlaybackSeconds`; fade 0,4 tại `kSSDismissFadeDuration` | Mức bằng chứng: [VERIFIED] số; gán userInteractionEnabled [INFERRED]

### Splash — logo + poster nền
Loại: 2 UIImageView riêng biệt trong SSStartupView | Đặc tả số: poster = phủ toàn khung (AspectFill, hoặc AspectFit theo pref ảnh); **logo = hình vuông ở chính giữa, cạnh = min(0,5×W, 0,62×H)**, AspectFit, tint trắng; không có file logo (`Logo/logo.png` trong thư mục StartupScreen) → poster = symbol "play.rectangle.fill" ở giữa, trắng alpha 0,35, cỡ 28×hệ-số-scale; logo dự phòng = symbol "car.fill" trắng | Trạng thái & hành vi chạm: không chạm; intro: logo từ alpha 0, theo `startupScreenLogoEffect` (0 = mặc định): effect 1 = spring scale từ 0,5 trong 1,1 s (delay 0,1); các biến thể khác: fade 0,9 s / phát sáng glow 1,2 s / scale 0,96→1 trong 1,2 s | Neo source: `StartupScreen/SSStartupView.m:222-251` `reload`, `:458-471` `layoutSubviews`, `:548-600` `playIntro`; đường logo: `SSStartupScreen.m:68` `SSLogoPath` | Điểm can thiệp: tỉ lệ 0,5/0,62 tại `layoutSubviews` | Mức bằng chứng: [VERIFIED]

### Splash — chồng chào (greeting stack, style hiệu dụng ≠ 3)
Loại: UIStackView dọc giữa màn, 3 nhãn trắng căn giữa; hệ số scale s = min(H/100, W/260), mọi cỡ chữ nhân s | Đặc tả số: **đồng hồ** font Light **30×s** (định dạng giờ địa phương); **lời chào** Semibold **10×s**; **dòng ngày** Medium **6×s**, alpha 0,85; stack cách 3×s, rộng ≤ W − 16. Nội dung lời chào theo buổi: sáng "Chào buổi sáng", trưa "Chào buổi trưa", tối "Chào buổi tối", đêm "Chúc ngủ ngon" — kèm tên người dùng (pref `startupScreenGreetingName`) qua `SSGreetingWithName`; dịp đặc biệt (occasion 1–5, style 11): Tết "Chúc mừng năm mới!", Giáng sinh "Giáng sinh vui vẻ!", Trung thu "Tết Trung thu vui vẻ!" | Trạng thái & hành vi chạm: không chạm; style 11 chỉ hiện khi occasion ∈ [1,6), ngoài dịp rơi về style 2 (greeting thường) | Neo source: `StartupScreen/SSStartupView.m:342-362` `SSGreetingLine` (bảng chữ đánh dấu [VERIFIED existence; exact wording tables NOT-RECOVERED] — các câu trên là bản phục hồi hiện tại), `:495-545` `applyUnit:`; builder thật ở `SSStartupViewScenesB.m:295-303` `buildGreetingWithDate:period:` | Điểm can thiệp: cỡ chữ tại `applyUnit:`; bảng lời chào tại `SSGreetingLine`/`SSGreetingWithName` | Mức bằng chứng: [VERIFIED] hình học/cỡ chữ; bảng chữ dịp lễ mức phục hồi (chưa đối chiếu byte-level toàn bộ)

### Splash — thẻ thời tiết (style hiệu dụng 3)
Loại: UIStackView dọc giữa màn: [tiêu đề chào, hàng ngang (icon thời tiết, nhiệt độ, thẻ con), dòng cập nhật] — chỉ dựng khi style hiệu dụng = 3 (style đặt 3 nhưng không có dữ liệu thời tiết → rơi về greeting) | Đặc tả số (×s như trên): tiêu đề chào Semibold 7×s, alpha 0,92; **nhiệt độ** Medium **30×s**; icon thời tiết **32×s × 32×s** (symbol SF theo mã WMO: nắng "sun.max.fill", mưa "cloud.rain.fill", tuyết "cloud.snow.fill", giông "cloud.bolt.fill"… — bảng symbol [INFERRED], riêng "cloud.fill" [VERIFIED]); thẻ con: điều kiện Semibold 7,5×s / khoảng nhiệt Medium 6×s / mưa Medium 5,5×s alpha 0,9, xếp dọc cách 1,2×s, nền thẻ bo 5,5×s, lề 5×s và 3,5×s; dòng "đã cập nhật" Regular 4,2×s alpha 0,65 (ẩn khi không có ngày dữ liệu); hàng ngang cách 4×s, sau nhiệt độ thêm 6×s; nền: gradient dọc theo category bầu trời 0–9 từ mã WMO + ngày/đêm | Trạng thái & hành vi chạm: không chạm; dữ liệu từ cache thời tiết tối đa 12 h lúc khởi động, chỉ style 3 và 8 mới xin làm mới thời tiết; [ĐO-XE/di sản phiên] splash từng "rò" thời tiết sang cảnh greeting ở bản phục hồi cũ — gốc chỉ dựng thẻ khi style = 3 | Neo source: `StartupScreen/SSStartupViewScenesB.m:310-418` `buildWeatherWithPeriod:`; `SSStartupView.m:253-313` (điều kiện style 3 + chọn lại gradient), `:507-531` `applyUnit:` nhánh thời tiết; dữ liệu: `SSStartupScreen.m:588` `SSWeatherParse` | Điểm can thiệp: điều kiện dựng tại `reload` (SSStartupView.m:259); cỡ tại `applyUnit:` | Mức bằng chứng: [VERIFIED] hình học + điều kiện; bảng symbol [INFERRED]

### Splash — HUD checklist trạng thái (một số style cảnh)
Loại: danh sách dòng chữ trạng thái (`view.hud`) đính vào SSStartupView | Đặc tả số: thứ tự cố định: "Đã kết nối CarPlay" → "Pin iPhone N%" → "Nhiệt độ máy: OK/hot/very hot" → "Lite mode: on/auto/off" → (nếu bật car profiles) "Car profile: <tên>"; kèm sự kiện lịch tiếp theo trong 24 h (EventKit, nếu được cấp quyền) và phần trăm pin | Trạng thái & hành vi chạm: chỉ hiển thị, không chạm | Neo source: `StartupScreen/SSSplash.m:94-128` (dựng hud), `:130-160` (nextEvent) | Điểm can thiệp: danh sách tại init của SSSplash | Mức bằng chứng: [VERIFIED] thứ tự/dòng chính; ánh xạ chữ Lite mode + nhóm thermal [INFERRED] (source tự ghi)

---

## 7. MENU TỈ LỆ (ratio menu)

### Menu tỉ lệ (thanh preset nổi trên knob)
Loại: UIView kính mờ (`SCPStyleRatioMenu` radius 21) chứa hàng chip preset | Đặc tả số: cao **42 pt**, bo 21; rộng = 6 + 36×số chip (không có separator nào được chèn trong bản hiện tại — vòng lặp có nhánh separator 9 pt nhưng mảng chips chỉ chứa nút); chip preset **34×34 pt** bo 17, tâm chip cách nhau 36, chip đầu tâm x = cursor 4 + 17, tâm y = 21; vị trí menu: tâm X = tâm knob (kẹp trong container, lề 6); tâm Y = trên knob 10 pt (minY knob − 10 − 21), nếu chật trên thì lật xuống dưới knob + 10; **timer tự ẩn 4,0 s** (`ratioTimer`) | Trạng thái & hành vi chạm: mở bằng tap trúng knob divider (mục 4) hoặc tap từ mirror; vào bằng `SCPPrepareRatioMenu` (0,45 s spring); đóng: fade 0,15 s; khi menu nằm trong container (không có tray window) nó phủ cover lên các ô hosted giao nhau (nới −6) | Neo source: `SplitScreenB/SCPCarSplit+RatioMenu.m:352` `showRatioMenuForDivider:` (@0x2f614), `:442` `hideRatioMenu` (@0x30ce0) | Điểm can thiệp: vị trí/kẹp tại cuối `showRatioMenuForDivider:`; timer tại cuối hàm | Mức bằng chứng: [VERIFIED]

### Các mức tỉ lệ trong menu (preset theo cấu hình ô)
Loại: chip mang glyph sơ đồ tỉ lệ (vẽ vector trên lưới 24×24, mỗi ô con bo góc, khoảng cách 1,6) — chip của tỉ lệ hiện tại được đánh dấu vòng conic-gradient (`SCPMarkRatioChipSelected`, khớp cơ chế đánh dấu nút panel) | Đặc tả số — **bảng preset đọc thẳng từ code** (`ratioPresets`, hằng số __data):
- 2 ô thường: **[1/3 : 2/3], [1/2 : 1/2], [2/3 : 1/3]** — 3 chip, menu rộng 114 pt.
- Main-stack (1 lớn + 2 xếp chồng): **[chính 1/3, phụ 1/2], [1/2, 1/2], [2/3, 1/2]** — 3 chip, 114 pt (số thứ hai là tỉ lệ chia dọc trong cột phụ).
- 3 ô thường: **[1/3, 1/3, 1/3], [1/4, 1/2, 1/4], [1/2, 1/4, 1/4], [1/4, 1/4, 1/2]** — 4 chip, menu rộng 150 pt.
| Trạng thái & hành vi chạm: tap chip → `ratioPresetTapped:`: ẩn menu, áp fractions của preset, relayout có animation, `saveRatio` (lưu pref tỉ lệ + tỉ lệ theo cặp app cho 2 ô) | Neo source: `SplitScreenB/SCPCarSplit+Divider.m:355` `ratioPresets` (@0x2e9a0), `:461` `ratioPresetTapped:` (@0x31194); glyph: `SCPCarSplit+RatioMenu.m:230` `SCPDrawPresetGlyph` | Điểm can thiệp: bảng preset tại `ratioPresets` — thêm mức tỉ lệ mới là thêm đúng tại đây + glyph tự suy theo fractions | Mức bằng chứng: [VERIFIED] (hằng số đọc từ __data, source ghi rõ)

---

## 8. DOCK / LAUNCHER GRID CỦA SCPHomeLauncher

### Tile OmniCar trên lưới Home CarPlay (dock icon phía Home)
Loại: KHÔNG phải view tự vẽ — là **icon app thật trên lưới Home gốc của CarPlay**: module inject một `CRCarPlayAppDeclaration` hợp lệ cho app OmniCar đã cài thật (`com.anlai.omnicar.app`, `supportsMaps = YES`, `supportsTemplates = NO`, tag "OmniCarHomeLauncher") vào DBApplicationInfo + đảm bảo app có mặt trong thư viện app của dashboard (`_newApplicationLibrary`) | Đặc tả số: kích thước/vị trí icon = do lưới Home gốc của iOS quyết (module không can thiệp hình học); điều kiện hiện: tính năng bật + app OmniCar cài thật và LS proxy hợp lệ; KHÔNG cần bật app trong Cài đặt iPhone → CarPlay (đây chính là cơ chế "không cần toggle" kiểu OmniCar) | Trạng thái & hành vi chạm: tap icon → hook `-[DBDashboardHomeViewController iconManager:launchIconForIconView:]` (chỉ cài khi type encoding đúng `v32@0:8@16@24`) chặn RIÊNG icon OmniCar → `SCPHomeLauncherConsumeLaunch` → mở **panel bố cục** (`showLayoutPanelForApp:` — cùng panel của nút logo); icon khác → chuyển tiếp hành vi gốc đúng 1 lần; chống nuốt trùng: 2 callback trong 0,65 s gộp 1 | Neo source: `SplitScreenC/SCPHomeLauncher.m:66-125` `SCPHomeLauncherInjectInfo`, `:127-170` `EnsureInLibrary`, `:290-330` `ConsumeLaunch`, `:362-396` tap hook | Điểm can thiệp: khai báo tại `InjectInfo`; cổng hook tại `SCPHomeLauncherInstallTapHook` | Mức bằng chứng: cơ chế [VERIFIED] từ source phục hồi, NHƯNG module này là **[CÂY-HL/GPT thêm]** (header ghi "OmniCar's OWN … (GPT)"), không phải thành phần gốc 1.0.3; trên xe còn 3 cổng câm lặng có thể rơi về gốc: ABI encoding lệch, trích bundle id trượt (sâu tối đa 3 tầng), root CarPlay không sống — xem check-video-faults.md §3b. KHÔNG có launcher grid tự vẽ riêng: "lưới" chính là Home gốc + panel bố cục ở mục 5

### Thông báo / greeting phía Home launcher
Loại: không tồn tại | Đặc tả số: tìm khắp `SCPHomeLauncher.m` + `SCPHomeHooks.m`/`SCPHomeApply.m`: KHÔNG có banner, toast, notification hay greeting riêng của launcher — đầu ra duy nhất là log `[home-launch] phase=…` và việc mở panel bố cục. Thông báo dạng chữ trên màn xe thuộc 2 phần tử Toast ở mục 10 | Neo source: `SplitScreenC/SCPHomeLauncher.m` (toàn file, 396 dòng) | Điểm can thiệp: muốn có banner Home thì phải thêm mới hoàn toàn | Mức bằng chứng: [VERIFIED] vắng mặt trong source phục hồi

### Nút Home HỆ THỐNG (sự kiện Home) — hành vi liên quan chrome
Loại: hook sự kiện, không phải phần tử vẽ | Đặc tả số: — | Trạng thái & hành vi chạm: bấm Home khi split đang chạy → thứ tự cứng: phá split (`noteCloseSource "home-system"` + `closeGoingHome:NO`) → dọn dẹp `homePressedDuringSplit:` (chỉ dọn, KHÔNG mở panel/lưới) → chạy sự kiện Home gốc → về dashboard gốc. Toàn cây không có đường từ sự kiện Home tới panel bố cục | Neo source: `SplitScreenA/SCPHooks.m:243-258` `_handleHomeEvent:`; `SCPCarSplit.m:1832` `homePressedDuringSplit:` | Điểm can thiệp: hook này, sau `closeGoingHome:` — đổi hành vi = thay đổi thiết kế, không phải sửa lỗi | Mức bằng chứng: [VERIFIED] + [ĐO-XE] triệu chứng hl5 (c) khớp thiết kế gốc (check-video-faults.md §3a)

---

## 9. SPEED BUBBLE (mục trỏ — chi tiết vẽ để luồng 2/4 bổ sung)

### Speed bubble (SPPBubbleView trên thẻ SPPBubble)
Loại: thẻ bong bóng trong UIWindow riêng xuyên chạm trên màn xe (cũng có mặt trên màn điện thoại) | Đặc tả số: vị trí mặc định trên XE: tâm = **(W − 86, 170)** (điện thoại: (W − 52, 70)); vị trí người dùng kéo được lưu dạng tỉ lệ của cửa sổ, clamp trong cửa sổ; scale hiển thị = phần trăm cỡ người dùng × 0,9 (100% → 0,9); cỡ nội dung tùy style (9 style): ví dụ style 0 = **120×118 pt** (đĩa kính 100×100 tại (4,16)), các style khác cao ~60 pt (thanh kính) hoặc theo nội dung render; nhãn chính: **số tốc độ** font Heavy bo tròn cỡ 24–48 pt tùy style, không có dữ liệu → "--"; nhãn phụ: **"km/h"** 9–12 pt; biển giới hạn con: số giới hạn (không rõ giới hạn thì ẩn/rỗng); trạng thái màu theo speedState: 0 = dưới giới hạn, 1 = ≥ 90% giới hạn, 2 = vượt giới hạn | Trạng thái & hành vi chạm: hiện spring từ scale 0,7×base (0,45 s, damping 0,5) khi có dữ liệu + app dẫn đường ở trước + xe không bận; ẩn fade/thu 0,18 s; kéo để dời vị trí, pinch để đổi cỡ (chi tiết tương tác + vẽ từng style: luồng 2/4) | Neo source: `SpeedBubble/SPPBubble.m:1338` `defaultCardCenter`, `:505-545` đường hiện, `:605` `renderBubble`; view: `SpeedBubble/SPPBubbleView.m:801-820` (gán chữ số/đơn vị/biển), `:825-872` (khung style 0/1) | Điểm can thiệp: vị trí mặc định tại `defaultCardCenter`; cỡ/chữ tại `SPPBubbleView render` | Mức bằng chứng: [VERIFIED]

---

## 10. CƠ CHẾ CHUNG + PHẦN TỬ PHỤ (nền cho các mục trên)

### AutoHide toàn phiên (máy ẩn chrome dùng chung)
Loại: lớp điều khiển mờ (Muse thêm theo mẫu QA20 — [CÂY-HL], không phải gốc 1.0.3) | Đặc tả số: **1 timer idle chung 4,0 s** cho toàn split; tập sơn khi fade: `pane.handle` mọi ô + mọi divider + knob của chúng + `homeButton`; loại trừ tường minh: `pane.bar` (timer riêng), `ratioKnob`, `launcherHost` | Trạng thái & hành vi chạm: fade = chỉ ghi `layer.opacity = 0` (bản gốc của cơ chế này KHÔNG tắt hit-test — xem mâu thuẫn ở mục logo góc); hoạt động (chạm host, kéo, mở panel, wake…) → `ahReveal` khôi phục opacity đã lưu + reset đồng hồ 4 s; giữ nguyên trạng thái khi bàn phím đang mở | Neo source: `SplitScreenA/SCPCarSplit+AutoHide.m:31` `kAHIdleSeconds = 4.0`, `:79` `AHPaintView`, `:106` `ahPaintCurrentSet`, `:227` `ahRevealBody:` | Điểm can thiệp: danh sách sơn tại `ahPaintCurrentSet` là NƠI quyết định "gọi dậy thì hiện những gì" | Mức bằng chứng: [CÂY-HL] + [ĐO-XE] hành vi reveal ở hl4

### Toast pill (thông báo chữ ngắn)
Loại: UILabel pill tự vẽ (nền trắng 0,94 qua `SCPStyleDragGhost` bo 19, chữ navy, font 14 Medium, tối đa 2 dòng) | Đặc tả số: rộng = min(rộng host − 48, vừa chữ + 32), cao = max(vừa chữ + 18, 38); neo: giữa-ngang dashboard, tâm Y = **đáy host − 50**; nếu điểm đó rơi trên ô bridged đang live → né sang tâm ô khác đang hiện (y = đáy ô đó − cao/2 − 12) | Trạng thái & hành vi chạm: không chạm; fade-in 0,2 s, giữ `duration` (mặc định **2,6 s**), fade-out 0,3 s. Các nội dung dùng toast: "Ô này đang ghim", lỗi mở app, thay app, app về nền, không chia được app… Mẹo dùng (tips, tối đa 3 lần đếm bằng pref): hiện sau 3 s khi split active, giữ **4,5 s** — 3 mẹo cố định về double-tap divider / kéo grip đổi chỗ / kéo divider sát mép đóng ô | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:1607` `toast:`, `:1616` `toast:duration:` (@0x44f80), mẹo: `:1740` `showTipSoon` | Điểm can thiệp: hình dạng/vị trí tại `toast:duration:` | Mức bằng chứng: [VERIFIED]

### Background toast (thông báo app chạy nền + nút Mở lại)
Loại: UIView thẻ (`SCPStyleRatioMenu` bo 18) | Đặc tả số: cao **34 pt**, rộng theo nội dung; neo: giữa-ngang host (tray window nếu có), **tâm Y = 26** (sát đỉnh); con: icon app 24×24 tại (7,6); nhãn "<App> đang chạy nền" font 13 Medium tại x = 39; nút **"Mở lại"** font 13 Semibold trắng trên nền accent gradient, cao 26, bo 13, rộng = vừa chữ + 24, cách nhãn 10 | Trạng thái & hành vi chạm: nút Mở lại → gỡ toast + `openApp:slot:` mở lại app vào ô cũ; tự hủy sau **5,0 s** (fade 0,25 s) | Neo source: `SplitScreenB/SCPCarSplit+Picker.m:1671` `showBackgroundToastFor:slot:` (@0x28c68) | Điểm can thiệp: tại hàm này | Mức bằng chứng: [VERIFIED]

### Drag ghost (thẻ ma khi kéo grip đổi chỗ ô)
Loại: UIView kính, `userInteractionEnabled = NO`, host tray window hoặc container | Đặc tả số: rộng = clamp(40% rộng ô, 88, 180); cao suy theo tỉ lệ, clamp [72, 130]; bo 16, viền accent 1,5; icon app **44×44** ở giữa thẻ | Trạng thái & hành vi chạm: xuất hiện khi pan grip bắt đầu kéo (ô gốc bị phủ cover alpha 0,55); thả lên ô khác → `swapSlot:with:` đổi chỗ 2 app; thả ngoài → hủy | Neo source: `SplitScreenB/SCPCarSplit+Drag.m:90` `beginPaneDrag:at:`, `:53` `handlePanned:` | Điểm can thiệp: cỡ ghost tại `beginPaneDrag:` | Mức bằng chứng: [VERIFIED]

### Solo cover / loader mở app (màn chờ)
Loại: UIView phủ vùng app, `userInteractionEnabled = NO` | Đặc tả số: nền RGB(238,240,251); icon app **52×52** giữa (lệch lên 6), bo squircle 27%; spinner Medium màu lavender dưới icon 18 pt; tự ẩn: app hosted **6 s**, app khác **3 s**; ẩn bằng fade 0,25 s. Bản trong panel (trayCover) dùng icon 56×56 giữa cover | Neo source: `SplitScreenA/SCPCarSplit.m:2560` `showSoloCoverForBundle:`, `:2601` `hideSoloCover` | Điểm can thiệp: tại 2 hàm này | Mức bằng chứng: [VERIFIED]

---

## 11. MÂU THUẪN SỐ SOURCE ↔ ĐO XE / GIỮA CÁC BẢN PHỤC HỒI

1. **Sheet picker 542×242**: đo xe cho 542×242 cố định; source cho công thức động — hai bên KHỚP khi suy ngược (cols = 6 trên area 640×360). Không phải mâu thuẫn thật; ghi nhận để tránh ai đọc số đo như hằng số: đổi số app/độ phân giải là sheet đổi cỡ.
2. **Animation đóng sheet 0,22 s**: số đo xe (hl4/hl5) khớp `removePickerSheet` trong cây hiện tại. Các animation đóng khác KHÁC số này: bar 0,18 s, menu tỉ lệ 0,15 s, picker trong-ô 0,15 s — đừng gộp chung "0,22 s cho mọi popup".
3. **Nút logo ăn chạm khi vô hình**: source GỐC (theo check hl5 §2, đối chiếu binary) chỉ mờ opacity → vẫn ăn chạm; cây hl6 hiện tại đã chèn cổng hit-test vào AutoHide (`faded = not hittable`). Hai "sự thật" này thuộc hai phiên bản khác nhau — bản kê ghi cơ chế gốc là chuẩn, cổng hl6 ghi rõ [CÂY-HL].
4. **Vị trí nút logo**: ở hl4 nút không tồn tại cả phiên (cổng dock-retirement); ở hl5 bản sửa theo placement vẫn mất nút khi placement lật sang dock lúc active (frameWin {{-17,-17},{34,34}} off-screen, PATCH_NOTES §29.29); hl6 đổi tiêu chí sang role. Số hình học 34 pt / tâm (maxX−25, minY+25) ổn định ở mọi phiên — cái thay đổi là CỔNG dựng, không phải hình học.
5. **Glyph panel**: bản chép phục hồi đời đầu ghi nút lựa chọn 56×41 trên stride 88 → glyph 73×40 tràn nút (thấy trên xe 08/11 là "hai lớp ô chồng"); bản closure-2 sửa thành nút 84×56 / stride 84 theo dump. Tin số closure-2.
6. **Tâm bar mirror (AB) Y = 50 vs tâm bar chính Y = 24 + scale×26 (= 50 khi scale = 1)**: hai công thức KHÁC chữ nhưng cho cùng kết quả ở scale 1; chỉ lệch khi bar bị thu nhỏ (ô hẹp) — điểm cần đo lại nếu thiết kế lại bar cho ô hẹp.
7. **Completion của hide bar**: bản chính (Chrome.m) thực thi 4 lệnh vô điều kiện (hidden/alpha/transform/push frames); bản mirror AB (`hideBarForPane:`) trong cây có thêm guard `alpha == 0` ở completion — acceptance 09/11 đã kết án guard này là của phía AB, không được chép sang phía chính.

## 12. PHẦN TỬ / CHI TIẾT CHỈ Ở MỨC INFERRED (chưa có bằng chứng binary/xe đủ)

- Tên blur style của mặt knob: "UIBlurEffectStyleSystemUltraThinMaterialLight" (style 11) — [INFERRED], cả 2 phía dùng chung factory.
- Bảng symbol thời tiết của splash (trừ "cloud.fill") — [INFERRED]; bảng chữ lời chào dịp lễ — phục hồi, chưa đối chiếu byte-level toàn bộ; ánh xạ chữ Lite mode + nhóm trạng thái thermal trong HUD — [INFERRED].
- `contentView.userInteractionEnabled = NO` + autoresizing mask của splash window — [INFERRED] ở khâu lắp cửa sổ.
- Hướng receiver/argument của `isDescendantOfView:` trong `hideBarsForTouchOn:` — [INFERRED].
- Công thức chính xác của tâm mặc định speed bubble ("inset from top-right" — hằng số 86/170 [VERIFIED], diễn giải công thức [INFERRED]); margin clamp 1/displayScale — [INFERRED].
- Window level của cửa sổ chrome mirror AB: `UIWindowLevelStatusBar + 60` — hằng số 60 [VERIFIED], base level [INFERRED].
- SCPHomeLauncher toàn module: là mã GPT thêm ở vòng hl, trạng thái "PENDING-DEVICE" ngay trong header của chính nó — cơ chế đọc được từ source nhưng chưa phải bằng chứng gốc 1.0.3, và 3 cổng câm lặng của nó mới có bằng chứng xe một phần (hl5 §3b).

## 13. TỔNG KẾT PHỦ

- Tổng mục kê: **39 mục `###`** thuộc 10 nhóm + 2 mục tổng kết, bao phủ đủ 9 yêu cầu của đề bài (mục 2 và 3 của đề là cùng cơ chế grip→bar, đã ghi tách và chú thích).
- Mọi kích thước pt trong bản kê đều truy được về file:line trong `~/workspace/omnicar-re/src/` hoặc về biên bản đo hl4/hl5; không có số nào lấy từ trí nhớ.
- Ba điểm can thiệp thiết kế lớn nhất cho giao diện mới: (1) mặt sheet picker tại `buildPickerSheetForPane:` (vật che 61,2%); (2) cổng dựng homeButton tại `refreshHomeButton` (một nút — hai vị trí — mọi cổng chặn phải phân biệt vị trí/role); (3) liên kết wake→bar tại `BridgeWake.m:1171` (quyết định gọi dậy hiện những gì).

---

## Phần 4 — Hệ thống thị giác (design tokens)


> CHỈ ĐỌC source phục hồi `src/` (207 file .m/.h, 11 module) + plist Prefs/Info. Không chạy binary, không sửa code.
> Trạng thái nhãn: không ghi chú = VERIFIED trong source phục hồi; `[INFERRED]` = source tự ghi inferred; `[tái tạo]` = AutoHide ở cây rebuild (mô hình theo QA20, không phải token gốc 1.0.3 — xem §4).

## Phương pháp grep (verifier rà lại được)

```sh
cd ~/workspace/omnicar-re/src
grep -rn --include="*.m" --include="*.h" -E "colorWithRed:|colorWithWhite:|colorWithHue:" .   # 442 dòng
grep -rhoE '#[0-9A-Fa-f]{6}\b' --include="*.m" --include="*.h" . | sort | uniq -c            # hex qua OMCColorFromHex
grep -rn -E "systemFontOfSize|boldSystemFont|fontWithName|monospacedDigit|fontWithDescriptor" .  # 73+ dòng; fontWithName: 0 hit (chỉ fontWithDescriptor:)
grep -rn -E "cornerRadius\s*=|borderWidth\s*=|shadowRadius|shadowOpacity|shadowOffset" .
grep -rn -E "animateWithDuration:|CABasicAnimation|usingSpringWithDamping|CAMediaTimingFunction|UIViewAnimationOptionCurve" .
grep -rn -E "UIBlurEffect|effectWithStyle|CAGradientLayer|startPoint|endPoint|\.locations" .
grep -rn -E "windowLevel|bringSubviewToFront|insertSubview:.+atIndex|zPosition" .
grep -rn -i -E "color|font|#[0-9A-F]{6}" ../payload/var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/*.plist */Info.plist
# → plist: 0 khóa màu/font. Màu/font 100% nằm trong code.
```

Đếm máy (script python, chuẩn hoá /255 ↔ 0–1): **102 RGBA literal phân biệt trên 1 dòng (129 lần)** — chưa kể literal trải nhiều dòng (đa số ở SplitScreen/AppBridge) nên tổng màu phân biệt thực tế cao hơn; bảng §1 gộp theo RGB (bỏ khác biệt alpha `1`/`1.0`).

## 1. MÀU

### 1.1 Token có tên (helper — nguồn sự thật của hệ)

| Token | Giá trị | Dùng ở đâu | Neo |
|---|---|---|---|
| Accent (dynamic) | light `#7B6CF6` / dark `#A89BFF` (OMCDynamicColor) | tint toàn Prefs, slider, icon chọn | Prefs/OMCPrefs/OMCCommon.m:282; .h:112 |
| Background (dynamic) | light `#F4F5FB` / dark `#0E0F16` | nền trang Prefs | Prefs/OMCPrefs/OMCCommon.m:285 |
| Card (dynamic) | light `systemBackgroundColor` / dark `secondarySystemBackgroundColor` | nền card Prefs | Prefs/OMCPrefs/OMCCommon.m:288-294 |
| Switch | `systemGreenColor` | onTintColor mọi UISwitch | Prefs/OMCPrefs/OMCCommon.m:300 |
| SCPColorSecondary | `#4A4F80` @ alpha 0,55 | chữ phụ/icon trên xe (picker, panel) | SplitScreenB/SCPCarSplit+Chrome.m:53-57 |
| SPPSlate | `#4A4F80` (0,29020/0,30980/0,50196) | chữ số tốc độ + nhãn bubble trạng thái thường | Prefs/OMCPrefs/SPPBubbleView.m:154; SpeedBubble/SPPBubbleView.m (bản sao) |
| SPPAmber | `#FFB340` (1/0,70196/0,25098) | cảnh báo tốc độ mức 1 (amber) | Prefs/OMCPrefs/SPPBubbleView.m:157 |
| SPPStateRed | `#FF5A5F` (1/0,35294/0,37255) | cảnh báo tốc độ mức 2 / overspeed | Prefs/OMCPrefs/SPPBubbleView.m:160 |
| Shadow violet | `#6E64C8` (0,43137/0,39216/0,78431) | shadowColor của knob/chip/sheet/panel/ghost — lặp ≥10 lần | SplitScreenA/SCPCarSplit.m:2935; SplitScreenB/SCPCarSplit+Chrome.m:68 |
| Shadow violet sáng | rgb(110,100,200)/255 ≈ `#6E64C8` | shadow keyboard/host (biến thể /255) | AppBridgeB/ABKeyboard.m:480; ABHostBMethods.m:529 |
| Glass top/bottom (Prefs) | top trắng 0,9 / bottom `#F1F0FB` (0,945/0,941/0,984) | SPPGlassView mặc định | Prefs/OMCPrefs/SPPGlassView.m:29-30 |
| Glass shadow | `#463C8C` (0,275/0,235/0,549) | SPPGlassView + style tile | Prefs/OMCPrefs/SPPGlassView.m:32; OMCSSStyleTileCell.m:114 |

### 1.2 Bảng màu RGB literal (gộp trùng, tần suất ≥2 hoặc có vai trò; hex từ RGB×255)

| Hex | RGBA gốc | Tần suất | Dùng ở đâu | Neo |
|---|---|---|---|---|
| `#9B87F8` | 0,60784/0,52941/0,97255/1 | ≥8 | accent gradient đầu (violet) — knob, chip, spinner, ring tốc độ | SplitScreenB/SCPCarSplit+Chrome.m:107; SCPCarSplit.m:2566 (SplitScreenA) |
| `#5DB4F6` | 0,36471/0,70588/0,96471/1 | ≥8 | accent gradient cuối (xanh dương) — cặp với `#9B87F8`, start (0,0)→end (1,1) | SplitScreenB/SCPCarSplit+Chrome.m:109; AppBridgeB/ABKeyboard.m:175-177 |
| `#A78BFA` | 0,65490/0,54510/0,98039/1 | ≥7 (+7 dạng hex) | gradient conic: ratio ring, bubble ring, header | Prefs/OMCPrefs/SPPBubbleView.m:59; SplitScreenB/SCPCarSplit+RatioMenu.m:290 |
| `#60C5FA` | 0,37647/0,77255/0,98039/1 | ≥5 | gradient conic điểm 2 | Prefs/OMCPrefs/SPPBubbleView.m:60 |
| `#5EDDB6` | 0,36863/0,86667/0,71373/1 | ≥5 | gradient conic điểm 3 (mint) | Prefs/OMCPrefs/SPPBubbleView.m:61 |
| `#F59AC0` | 0,96078/0,60392/0,75294/1 | ≥4 | gradient conic điểm 4 (hồng) | Prefs/OMCPrefs/SPPBubbleView.m:69; RatioMenu.m:293 |
| `#4A4F80` | 0,29020/0,30980/0,50196/1 | ≥10 | navy chữ chính trên xe: tint nút, dot, dash stroke @0,25, label picker | SplitScreenA/SCPCarSplit.m:2921; SplitScreenB/SCPCarSplit+Picker.m:1621 |
| `#EEF0FB` | 0,93333/0,94118/0,98431/1 | ≥6 | nền cover/loader pane (xám-tím rất nhạt) | SplitScreenA/SCPCarSplit.m:512; SplitScreenB/SCPCarSplit+Picker.m:212 |
| `#D9D6EE` | 0,85098/0,83922/0,93333/1 | 1 | biến thể cover khi có image | SplitScreenA/SCPCarSplit.m:511 |
| `#FF5A5F`-họ đỏ | 1/0,35294/0,37255/1 | ≥4 | tint nút cancel/exit trên xe | SplitScreenB/SCPCarSplit+Picker.m:654; +Panel.m:360 |
| `#FF5C54` | 0xFF/0x5C/0x54 | 2 (1 hex literal) | nút Clear (Startup prefs), cảnh báo splash | StartupScreen/SSStartupView.m:959; Prefs/OMCStartupScreenController.m:718 |
| `#E5262D` | 0,898/0,149/0,176/1 | 2 | border biển báo tốc độ (sign red, VERIFIED) | Prefs/OMCPrefs/SPPSignView.m:31,53 |
| `#141417` | 0,078/0,078/0,09/1 `[INFERRED g/b]` | 2 | chữ trên biển báo | Prefs/OMCPrefs/SPPSignView.m:38 |
| `#AE4ABC` | 0,682/0,29 `[INFERRED g]`/0,737/1 | 2 | border/chữ biển báo biến thể | Prefs/OMCPrefs/SPPSignView.m:50,56 |
| `#78797D`-họ | 0,471/0,486/0,525/1 | 1 | nền biển báo | Prefs/OMCPrefs/SPPSignView.m:49 |
| `#4A4F80`-xám kb | rgb(74,79,128)/255 = `#4A4F80` | ≥8 | chữ/tint bàn phím tự vẽ + host: lang, hide, hint, bubble, key tint | AppBridgeB/ABKeyboard.m:521,539,607,711,793 |
| `#6E64C8`-kb | rgb(110,100,200)/255 | ≥4 | shadow panel/keyboard/host | AppBridgeB/ABKeyboard.m:480,717 |
| `#6E78FF` | rgb(110,120,255)/255 (b=1,0) | 2 | shadow knob khi active | SplitScreenB/SCPCarDividerView.m:83; ABHostBMethods.m:1602 |
| `#293D10` | 0,16/0,24/0,0625 @1 và @0,6 | 2 | textColor preview bàn phím (xanh rêu đậm — lạ, giữ nguyên văn) | AppBridgeB/ABKeyboard.m:456,461 |
| `#1A1C38`-họ | 0,10/0,11/0,22/1 | 1 | fill vẽ trong OMCCommon (nền tối) | Prefs/OMCPrefs/OMCCommon.m:525 |
| `#463C8C` bóng | 0,35/0,45/0,95/1 | 1 | shadowColor khác ở OMCCommon (xanh dương bão hoà) | Prefs/OMCPrefs/OMCCommon.m:428 |

### 1.3 Trắng alpha (colorWithWhite:1) — họ "glass trên xe", 51 cặp (white,alpha) phân biệt / 118 lần

| Alpha | Tần suất | Vai trò điển hình | Neo |
|---|---|---|---|
| 0,85 | 17 (1+1.0) | border glass/chip/blur phổ biến nhất | SplitScreenB/SCPCarSplit+Chrome.m:49 |
| 0,90 / 0,95 | 11 / 8 | border mạnh, divider, separator | SplitScreenB/SCPCarSplit+Chrome.m:67; +Picker.m:1145 (ABHost) |
| 0,35 | 8 | nền handle/wrapper mờ | SplitScreenB/SCPCarSplit+Picker.m:613 |
| 0,50 / 0,55 | 4 / 7 | nền chip, border handle | SplitScreenB/SCPCarSplit+Chrome.m:63,167 |
| 0,75 / 0,80 | 5 / 5 | border nút panel, border nút picker | SplitScreenB/SCPCarSplit+Panel.m:292; +Picker.m:1080 |
| 0,92 / 0,94 | 2 / 1 | nền knob-face / label nền | SplitScreenB/SCPCarDividerView.m:103; +Picker.m:1633 |
| 0,02 / 0,012 / 0,08 | 1 / 1 / 2 | shield gần như trong suốt (hit-test) | SplitScreenB/SCPCarSplit+Chrome.m:440; ABHostBMethods.m:1530,890 |
| 0 (đen 0,0–0,14 xám) | rải rác | nền placeholder đen `white:0 @1`, pane `white:0,08 @1`, chip tối `white:0,14 @0,5` | SplitScreenA/SCPSmallClasses.m:13; SCPCarSplit.m:1436; Prefs/OMCSplitScreenController.m:436 |

### 1.4 Hex literal qua `OMCColorFromHex` — 61 giá trị phân biệt

Nhóm thương hiệu lặp nhiều nhất: `#8B7CFF`×10, `#5AB8FF`×8, `#A78BFA`×7, `#FF7FA8`×4, `#2BC79A`×4, `#FFB340`×3, bộ header `#B7A6FF/#8FD3FF/#9DF2D8`×3 mỗi màu.

| Hex | Dùng ở đâu | Neo |
|---|---|---|
| `#B7A6FF → #8FD3FF → #9DF2D8` | gradient header card Prefs (0,0)→(1,1) | Prefs/OMCPrefs/OMCHeaderCard.m:32-34 |
| `#A78BFA → #60C5FA → #5EDDB6 → #F59AC0 → #A78BFA` | ring conic SpeedBubble (lặp ở controller + tile) | Prefs/OMCPrefs/OMCSpeedBubbleController.m:132-136,777-781 |
| `#9B87F8 → #5DB4F6` | gradient nút Try (SpeedBubble prefs) | Prefs/OMCPrefs/OMCSpeedBubbleController.m:435-436 |
| `#8B7CFF` | icon/border chọn style, dot preview split | Prefs/OMCPrefs/OMCSpeedBubbleController.m:460,716; OMCSplitPreview.m:55 |
| `#4B3FD0` | chữ/icon tile khi selected (tím đậm) | Prefs/OMCPrefs/OMCSpeedBubbleController.m:724,729 |
| `#6F62F2` | stroke ring swatch | Prefs/OMCPrefs/OMCSpeedBubbleController.m:790 |
| `#FF7FA8` | icon badge app | Prefs/OMCPrefs/OMCSpeedBubbleController.m:472 |
| `#2BC79A` | icon car/iphone | Prefs/OMCPrefs/OMCSpeedBubbleController.m:485 |
| `#FFB340` | icon cảnh báo, tint trong split preview | Prefs/OMCPrefs/OMCSpeedBubbleController.m:693; OMCSplitPreview.m:96 |
| `#2E9CF5`, `#FA2D55` | dot 2/3 split preview | Prefs/OMCPrefs/OMCSplitPreview.m:56-57 |
| `#EEF0EA/#CDECCF/#C8E4F7/#FFE9A8/#3D8BFF` | vẽ minh hoạ bubble trong prefs (fill/stroke) | Prefs/OMCPrefs/OMCSpeedBubbleController.m:73-92 |
| `#5AB8FF` / `#4A4F80` | icon tính năng blur bật/tắt | Prefs/OMCPrefs/OMCAppBridgeAppsController.m:741 |
| Đơn lẻ (×1–2, chủ yếu bảng màu chọn style/startup) | `#FF8A65 #F07A12 #E5322D #33CCFF #1AA260 #FF9F43 #FF3D71 #F59E0B #EA580C #E8558C #E11D48 #C026D3 #7C5CF0 #7C3AED #4F46E5 #0EA5E9 #0D9488 #0A59F7 #16A34A #475569 #636A73 #9AA0A8 #16182A …` | grep `#[0-9A-F]{6}` toàn cây |

### 1.5 Màu hệ thống (đếm lần xuất hiện theo tên)

| Màu | Số lần | Ghi chú | Neo mẫu |
|---|---|---|---|
| `whiteColor` | 94 | chữ/icon trên nền tối, border badge | SplitScreenB/SCPCarSplit+Picker.m:710 |
| `blackColor` | 39 | nền dim, mask stroke, `setFill` | SplitScreenB/SCPHomeWallView.m:24 |
| `clearColor` | 35 | nền window/chrome trong suốt | SplitScreenB/SCPCarSplit+Picker.m:1332 |
| `secondaryLabelColor` | 30 | chữ phụ Prefs | Prefs/OMCPrefs/OMCSpeedBubbleController.m:724 |
| `labelColor` | 17 | chữ chính Prefs | Prefs/OMCPrefs/OMCSpeedBubbleController.m:658 |
| `tertiaryLabelColor` | 7 | chữ mờ nhất Prefs | grep `tertiaryLabelColor` |
| `systemGreenColor` | 4 | = OMCSwitchColor | Prefs/OMCPrefs/OMCCommon.m:300 |
| `systemBackgroundColor` | 3 | qua OMCCardColor | Prefs/OMCPrefs/OMCCommon.m:294 |
| `systemTeal/Red/Purple/Pink/Orange/BlueColor` | 1 mỗi màu | bảng màu icon tính năng | grep `system.*Color` Prefs |

### 1.6 Gradient & blur (tóm tắt — chi tiết lớp để luồng 3)

| Hiệu ứng | Thông số | Neo |
|---|---|---|
| Accent axial | `#9B87F8 → #5DB4F6`, (0,0)→(1,1), tên lớp `omcAccent`, insertSublayer atIndex:0 | SplitScreenB/SCPCarSplit+Chrome.m:107-112 |
| Conic ring | `#A78BFA/#60C5FA/#5EDDB6/#F59AC0`, type Conic, start (0,5/0,5) end (0,1) | SplitScreenB/SCPCarSplit+RatioMenu.m:287-293 |
| Fade navy picker | SCP navy @ alpha 0 → 0,32 → 0,32 → 0; locations 0/0,2/0,8/1 | SplitScreenB/SCPCarSplit+Picker.m:594-601 |
| Sheen glass | trắng 0,5 → trắng 0 | Prefs/OMCPrefs/SPPGlassView.m:23-24; SPPBubbleView.m:289-290 |
| Mesh bubble | `#A6DDFF`@0,9/0 + `#FEC4D8`@0/0,9; locations 0/0,5/0,5/1; (1,0)→(0,1) | Prefs/OMCPrefs/SPPBubbleView.m:320-326 |
| Face tối bubble | `#2A2E45 → #0C140D` radial/axial | Prefs/OMCPrefs/SPPBubbleView.m:401-402 |
| Blur chủ đạo trên xe | `UIBlurEffectStyle` **11** = SystemUltraThinMaterialLight `[INFERRED tên]` | SplitScreenB/SCPCarDividerView.m:106; ABKeyboard.m:488; ABHostBMethods.m:1122,1537 |
| Blur Prefs/Startup | SystemUltraThinMaterial (header), SystemMaterial (card), style **16** (startup card) | Prefs/OMCPrefs/OMCHeaderCard.m:39; SSStartupView.m:506; StartupScreen/SSStartupViewScenesB.m:373 |
| Blur tuỳ biến Home | pref `homeScreenBlur` 0–30, mặc định 0 | SplitScreenC/SCPHomeSettings.m:16,57 |

## 2. FONT

Không có `fontWithName:` nào. Họ font = **system font** là chính; biến thể qua descriptor: **Rounded design** (bubble tốc độ + startup) và **monospacedDigit** (số đo Prefs). ~73 dòng grep font; bảng dưới là các cặp (size, weight) phân biệt có neo.

### 2.1 Helper font có tên

| Helper | Công thức | Neo |
|---|---|---|
| SPPSpeedFont(size) | system Heavy + design Rounded + tabular figures (feature type 1/selector 0) | Prefs/OMCPrefs/SPPBubbleView.m:26-36; SPPSignView.m:12 |
| SPPRoundedFont(size) | system Semibold + design Rounded | Prefs/OMCPrefs/SPPBubbleView.m:40; SpeedBubble/SPPBubbleView.m:295 |
| SPPHeavyFont(size) | như SPPSpeedFont (bản SpeedBubble) | SpeedBubble/SPPBubbleView.m:310 |
| Startup label helper | system(size, weight truyền vào) + design Rounded | StartupScreen/SSStartupView.m:86-88 (+ bản sao ScenesB:103, Builders:119; Prefs SSStartupView.m:130) |

### 2.2 Bảng size/weight theo ngữ cảnh

| Size | Weight | Dùng ở đâu (+ textColor/alignment/lines cạnh font) | Neo |
|---|---|---|---|
| 40 | Light | ký tự lớn picker (label giữa) — Center | SplitScreenB/SCPCarSplit+Picker.m:312-313 |
| 28 | Heavy | số tốc độ lớn trong prefs (NSFontAttribute) | Prefs/OMCPrefs/OMCSpeedBubbleController.m:52 |
| 26 | Bold | tiêu đề WhatsNew (scaledFont) | Prefs/OMCPrefs/OMCWhatsNewController.m:167 |
| 22 | Bold | tên app ở header card Prefs | Prefs/OMCPrefs/OMCHeaderCard.m:55 |
| 17 | Regular (mặc định) | phím ký tự chính bàn phím tự vẽ | AppBridgeB/ABKeyboard.m:826 |
| 16 | Regular / Medium | textLabel cell Prefs / tiêu đề section speed | Prefs/OMCPrefs/OMCCommon.m:408; OMCSpeedBubbleController.m:752 |
| 15 | Semibold / Regular | nút Prefs, nhãn app delegate (Center, lines 0) | Prefs/OMCAppBridgeAppsController.m:720; App/OMCAppDelegate.m:24-25 |
| 14 | Medium / Regular / Semibold | nhãn phụ phổ biến nhất; monospacedDigit 14 cho giá trị số (Right) | Prefs/OMCPrefs/OMCCardPage.m:198; OMCAppBridgeAppsController.m:828 |
| 13 | Medium ×nhiều / Semibold / Regular | size "mặc định phụ" toàn hệ: version/tagline/status header, preview kb, nút picker Semibold | Prefs/OMCPrefs/OMCHeaderCard.m:60,65,74; ABKeyboard.m:514; Picker.m:1698 |
| 13 | Medium, monospacedDigit | giá trị slider Prefs | Prefs/OMCPrefs/OMCCardPage.m:160 |
| 12,5 | Semibold / Regular | title đo picker (12,5 Semibold), hint, chip, nút Try | SplitScreenB/SCPCarSplit+Picker.m:485; Prefs/OMCSpeedBubbleController.m:429 |
| 12 | Medium / Regular / boldSystem | nhãn loader picker 12 Medium; hint 12; HS preview dùng `boldSystemFontOfSize:12` (hit boldSystem duy nhất cùng loại) | SplitScreenB/SCPCarSplit+Picker.m:1499; Prefs/OMCHSPreview.m:226 |
| 11,5 | Semibold | textLabel cell nhỏ SpeedBubble prefs (×3) | Prefs/OMCPrefs/OMCSpeedBubbleController.m:645,839,894 |
| 11 | Semibold / Regular | detail cell app list; phím phụ kb Semibold 11 | Prefs/OMCAppBridgeAppsController.m:586; ABKeyboard.m:828 |
| 10,5 | Semibold / Regular | nút lang kb Semibold; subFont đo picker Regular | AppBridgeB/ABKeyboard.m:520; Picker.m:486 |
| 10 | Regular | nhãn phím chức năng kb | AppBridgeB/ABKeyboard.m:824 |
| 9 | Bold | tick số trên mặt bubble tốc độ | Prefs/OMCPrefs/SPPBubbleView.m:442; SpeedBubble/SPPBubbleView.m:696 |
| 8 | Regular | hint nhỏ trên phím | AppBridgeB/ABKeyboard.m:606 |
| động | — | phím: `MAX(floor(rowH×0,56),14)`; bubble kb: `round(kh×0,85)`; plus picker: size động Bold/Regular tuỳ pane | AppBridgeB/ABKeyboard.m:673,738; Picker.m:1096-1098 |

### 2.3 Thuộc tính chữ đi kèm (mẫu lặp)

| Thuộc tính | Giá trị trội | Neo mẫu |
|---|---|---|
| textAlignment | Center áp đảo trên xe/startup; Right cho giá trị số Prefs; Left/Natural ở startup builders | Picker.m:313; Prefs/OMCSpeedBubbleController.m:758; StartupScreen/SSStartupViewScenesB.m:367 |
| numberOfLines | 2 (title tile/picker), 0 (nội dung dài Prefs), 1 (label startup) | Picker.m:629; Prefs/OMCCardPage.m:197; StartupScreen/SSStartupView.m:99 |
| lineBreakMode | TruncatingHead (preview kb), TruncatingMiddle (cell split), Clipping (title tile) | ABKeyboard.m:515; Prefs/OMCSplitScreenController.m:355; OMCSSStyleTileCell.m:64 |
| textColor nhãn chính trên xe | SCPColorSecondary (navy @0,55) hoặc navy @0,6 / trắng | SplitScreenB/SCPCarSplit+Picker.m:309,637,1095 |

## 3. HÌNH HỌC & KIỂU

### 3.1 cornerRadius (giá trị phân biệt ≈25; mọi phần tử đều kèm `kCACornerCurveContinuous` ở chrome trên xe)

| Giá trị | Phần tử | Neo |
|---|---|---|
| 24 | panel split, sheet picker, effectView của sheet/panel (bo lớn nhất trên xe) | SplitScreenB/SCPCarSplit+Panel.m:234,247; +Picker.m:515,576 |
| 22 | bar + blur bar (AppBridge host) | AppBridgeB/ABHostBMethods.m:1114,1130 |
| 20 | glass keyboard panel, plate host, header card Prefs, onboarding tile, preview startup | ABKeyboard.m:495; ABHostBMethods.m:526; Prefs/OMCHeaderCard.m:17 |
| 18 | card style tile, nút bubble tốc độ | Prefs/OMCSSStyleTileCell.m:40,48; SpeedBubble/SPPBubble.m:969 |
| 17 | nút ratio-menu / nút bar | SplitScreenB/SCPCarSplit+RatioMenu.m:260; SplitScreenA/SCPCarSplit.m:2920 |
| 16 | nút cancel picker, row onboarding | SplitScreenB/SCPCarSplit+Picker.m:652 |
| 14 | nút panel, view OMCCommon, liveMap, thumb/tile speed | SplitScreenB/SCPCarSplit+Panel.m:287; Prefs/OMCCommon.m:432 |
| 13 | nút picker cuối, nút Try + gradient của nó, swatch | SplitScreenB/SCPCarSplit+Picker.m:1702; Prefs/OMCSpeedBubbleController.m:431,437 |
| 12 | wrapper picker, field kb, label toast Prefs, HS preview | SplitScreenB/SCPCarSplit+Picker.m:614; ABKeyboard.m:506 |
| 11 / 10 | nút app-bridge, tile app, chip split | Prefs/OMCAppBridgeAppsController.m:722,938; OMCSplitScreenController.m:438 |
| 9 / 8 | bubble kb, field split prefs, nút split prefs | ABKeyboard.m:714; Prefs/OMCSplitScreenController.m:482,534 |
| 7 | knob, knob face, badge picker, gradient+key kb | SplitScreenB/SCPCarSplit+Layout.m:597,606; ABKeyboard.m:181,796 |
| 6 / 6,0 | handle, langButton, pane/floatPane | SplitScreenB/SCPCarSplit+Chrome.m:164; SCPCarSplit.m:1437 (A) |
| 5 | nút ô picker | SplitScreenB/SCPCarSplit+Picker.m:1070 |
| 3 / 2,5 / 2 / 1 / 0,75 / 0,5 | track/fill bubble 3 & 2,5; dot 2; confetti 1; bar bubble 0,75; divider 0,5 | Prefs/SPPBubbleView.m:335,353,300; Layout.m:627; Chrome.m:236 |
| 33 / 70 | knob tròn lớn host (33), mặt bubble (70 = s/2) | ABHostBMethods.m:1531; Prefs/SPPBubbleView.m:844 |
| tỉ lệ | `s/2`, `pillH×0,5`, `width×0,27` (icon), `5×unit`/`5,5×unit` (card startup), `34×_k` (card builders) | grep `cornerRadius`; StartupScreen/SSStartupView.m:519; SSStartupViewBuilders.m:871 |

### 3.2 borderWidth / borderColor

| Width | Dùng ở đâu | Neo |
|---|---|---|
| 0,5 | hairline: knob face, chip drag, card Prefs, preview | SplitScreenB/SCPCarSplit+Layout.m:608; Prefs/OMCCommon.m:426 |
| 0,75 | icon view Prefs | Prefs/OMCPrefs/SPPIconView.m:16 |
| 1,0 | mặc định chrome: blur, glass, plate, tile | SplitScreenB/SCPCarSplit+Chrome.m:47,66 |
| 1,5 | knob, ghost drag, nút picker, dotView, tile selected | SplitScreenB/SCPCarSplit+Layout.m:614; +Picker.m:1078 |
| 2,5 / 3,0 | viền pane khi accent/drag-mark, picker của pane đang chọn | SplitScreenB/SCPCarSplit+Layout.m:678; +Drag.m:164; +Picker.m:918 |
| 0 | tắt viền (drag kết thúc, glass fill) | SplitScreenB/SCPCarSplit+Drag.m:171 `[INFERRED ở 1 điểm]` |
Màu border đi kèm: chủ yếu trắng alpha 0,85/0,9/0,95 (§1.3); accent `#9B87F8` cho picker border (Picker.m:300); `#8B7CFF` tile selected (OMCSpeedBubbleController.m:716).

### 3.3 Shadow ( bộ ba lặp lại — shadowColor luôn là violet §1.1 trừ khi ghi khác)

| opacity / radius / offset | Phần tử | Neo |
|---|---|---|
| 0,12 / 3 / (0,2) | chip nhỏ | SplitScreenB/SCPCarSplit+Chrome.m:72-74 |
| 0,25 / 10 / (0,4) | view nổi drag/host | SplitScreenB/SCPCarSplit+Drag.m:33-35 |
| 0,30 / 24 / (0,8) | panel + sheet picker (bóng sâu nhất) | SplitScreenB/SCPCarSplit+Panel.m:240-242; +Picker.m:521-523 |
| 0,30 / 8–14 / (0,4–6) | ratio menu 8, menu phụ 14 | SplitScreenB/SCPCarSplit+RatioMenu.m:315-317,329-331 |
| 0,45 / 9 / (0,4) | accent bật (glow) / dotView 0,45/3/(0,1) | SplitScreenB/SCPCarSplit+Chrome.m:125-127; ABHostBMethods.m:1550 |
| 0,5 / 7 active, 0 / 3 inactive | knob (shadowOpacity/Radius theo active) | SplitScreenB/SCPCarDividerView.m:85-86; ABHostBMethods.m:1605-1606 |
| 0,18 / 14–16 / (0,6) | card/view Prefs | Prefs/OMCPrefs/OMCCommon.m:429-431; OMCHeaderCard.m:19-21 |
| 0,3 / 20 / (0,6); 0,4 / 6 / (0,3); 0,18 / 1 / (0,1) | panel kb; kb root; key kb | AppBridgeB/ABKeyboard.m:482-484,186-188,802-804 |

### 3.4 Hằng số kích thước lặp lại

| Giá trị | Ý nghĩa | Neo |
|---|---|---|
| 44 | hit-target tối thiểu (nút bấm, handle hit `MAX(w,44)`) — chuẩn HIG | SplitScreenB/SCPCButton.m:20-21; SplitScreenA/SCPCarSplit+AutoHide.m:259 `[tái tạo]`; ABChromeViews.m:176 |
| 34 | size nút/logo mặc định trong SCPCarSplit (3 điểm gán) | SplitScreenA/SCPCarSplit.m:3069,3084,3355 |
| 52 | offset bar khi thu: `(1−scale)×−52×0,5+50`; mép bubble `size.width−52` | AppBridgeB/ABHostBMethods.m:1168; SpeedBubble/SPPBubble.m:1344 |
| 542×242 | **không phải hằng khung** — kích thước slab do backdrop picker phủ ~61% pane (ghi trong chú thích hl5) | SplitScreenB/SCPCarSplit+Picker.m:530 |
| 297 | **không tìm thấy** hằng 297 trong source phục hồi (0 hit ngoài số nhà/địa chỉ hex) | grep `\b297\b` |
| 48×40 / 40×40 | nút bar + icon bên trong | SplitScreenB/SCPCarSplit+Chrome.m (sau :127, factory @0x23710) |
| 24 | lưới thiết kế icon host (scale `size/24`) | AppBridgeB/ABHostBMethods.m:402,421 |
| 56 | bước hàng khi tính rows picker `(areaH−44)/56` | SplitScreenB/SCPCarSplit+Picker.m:495 |

## 4. THỜI GIAN & HIỆU ỨNG ĐỘNG

14 giá trị `animateWithDuration:` literal phân biệt (0,1–1,2 s). Tần suất: 0,25×8; 0,45×7; 0,3×7; 0,2×7; 0,18×5; 0,15×5; 0,22×3; 0,9×3; còn lại ×2.

| Duration (s) | Sự kiện | Curve / spring | Neo |
|---|---|---|---|
| 4,0 | AutoHide: idle không hoạt động → fade controls `[tái tạo — hằng kAHIdleSeconds của cây rebuild, mô hình QA20; KHÔNG phải hằng gốc 1.0.3 đã xác minh]` | fade đích `layer.opacity = 0`, lưu & khôi phục opacity gốc từng view | SplitScreenA/SCPCarSplit+AutoHide.m:31,88-90; .h:6 |
| 0,22 | **đóng picker** (+ mở lại biến thể), layout sheet | LayoutSubviews | SplitScreenB/SCPCarSplit+Picker.m:239,958,1394 |
| 0,12 | cover picker hiện (alpha→1); highlight nút 0,12 vào / 0,3 ra | — | SplitScreenB/SCPCarSplit+Picker.m:232; SCPCButton.m:37 |
| 0,15 / 0,3 | divider/host active-inactive; drag thả 0,15–0,3 | spring 0,7 (divider) | SplitScreenB/SCPCarDividerView.m:71-73; +Drag.m:221 |
| 0,18 | chrome trượt; bubble kb spring | spring 0,62 (kb bubble) | SplitScreenB/SCPCarSplit+Chrome.m:347; ABKeyboard.m:743-745 |
| 0,2 / 0,25 | zoom phụ, host frame đổi 0,25 (0 nếu frame cũ rỗng), toast Prefs 0,25 EaseOut + thoát 0,3 delay 1,6 EaseIn | EaseOut (toast) | SplitScreenB/SCPCarSplit+Zoom.m:217; ABHostBMethods.m:708-709; Prefs/OMCCardPage.m:212,215 |
| 0,35 / 0,5 | sheet picker: 0,35 khi thay sheet cũ, 0,5 khi mở mới | spring 0,86/0,85 | SplitScreenB/SCPCarSplit+Picker.m:780,794 |
| 0,45 | zoom FS / panel / ratio menu / host bar — duration "chuẩn" của chuyển cảnh lớn | spring 0,75–0,86, velocity 0,3–0,5 | SplitScreenB/SCPCarSplit+Zoom.m:123-124; +Panel.m:428-429; +RatioMenu.m:351-352 |
| 0,5 | panel đóng; loader | — | SplitScreenB/SCPCarSplit+Panel.m:428; +Picker.m:1563 |
| 0,4 | splash dismiss fade (= stop-fade nhạc) `kSSDismissFadeDuration` | fade alpha | StartupScreen/SSSplash.m:33,307 |
| 0,9 / 1,1 / 1,2 | startup: logo alpha 0,9; khối vào 1,1 delay 0,1 spring 0,7; glow CABasic 1,2 autoreverse EaseInEaseOut | EaseInEaseOut | StartupScreen/SSStartupView.m:570-595; Prefs/SSStartupView.m:657-679 |
| 0,9 CABasic | spinner picker `transform.rotation.z`, lặp | — | SplitScreenB/SCPCarSplit+Picker.m:1516-1518 |
| 0,8 CABasic | pulse `transform.scale` picker | EaseInEaseOut | SplitScreenB/SCPCarSplit+Picker.m:1567-1575 |
| 0,5 CABasic ×2 | flash opacity + pulse scale bubble khi overspeed | EaseInEaseOut | Prefs/SPPBubbleView.m:482-495; SpeedBubble/SPPBubbleView.m:1285-1300 |
| 0,45 / 0,7 / 1,6 CABasic | pulse opacity overspeed theo mức hiệu ứng fx 2/0/1 | EaseInEaseOut, lặp vô hạn | SpeedBubble/SPPOverspeed.m:403-409 |
| 0,7 CABasic | anim bubble (SPPBubble) | EaseInEaseOut | SpeedBubble/SPPBubble.m:746-749 |
| 0,1 / 0,18 / 0,3 spring | bubble tốc độ vào/ra: 0,3 spring 0,85 & 0,8; thu 0,18; chạm 0,1 | spring 0,5–0,85 | SpeedBubble/SPPBubble.m:515-522,838,1062,1107,1155 |
| 1,6 / 2,4 / 3+0,7i / 14 CABasic | startup cảnh: sweep 1,6 (controlPoints 0,2/0/0,2/1), breathe 2,4, blob trôi 3+0,7×i lặp, drift mây 14 | EaseInEaseOut | StartupScreen/SSStartupViewBuilders.m:1014-1019,953-960,921-930; Prefs/SSStartupView.m:1335-1344 |
| 60 / 5 | splash: thời lượng phát mặc định dự phòng 60 s (cold); preview prefs `p.duration = dur ?: 5` | — | StartupScreen/SSSplash.m:269-271; Prefs/OMCStartupScreenController.m:667 |

Curve tổng: `kCAMediaTimingFunctionEaseInEaseOut`×11, `CurveEaseOut`×4, `CurveEaseIn`×1, spring damping tập trung 0,7 / 0,85–0,86 (0,5–0,9 toàn dải). Độ mờ đích khi faded: **opacity 0 tuyệt đối** (AutoHide + accent tắt), accent bật = 1,0; kb accent giữ 0,82 khi "on" (ABKeyboard.m:190); flash overspeed dao động opacity theo sin/pow (SSStartupView.m:903).

## 5. Z-ORDER / LEVEL (gọn — chi tiết phần tử ở luồng 3)

| Lớp / level | Giá trị | Neo |
|---|---|---|
| Splash startup | `UIWindowLevelAlert + 1000` (cao nhất) | StartupScreen/SSSplash.m:25-28,175 |
| Picker tray window (trên xe) | `UIWindowLevelStatusBar + 65` | SplitScreenB/SCPCarSplit+Picker.m:1252,1331 |
| Cửa sổ overspeed | `UIWindowLevelStatusBar + 65` | SpeedBubble/SPPOverspeed.m:328 |
| Cửa sổ host AppBridge | `UIWindowLevelStatusBar + 60` `[INFERRED base]` | AppBridgeB/ABHostBMethods.m:1049 |
| Thứ tự trong container split | pane ← divider (front) ← ratioMenu (front nhất); trong pane: handle → bar lần lượt bringSubviewToFront; shield phủ host được bring ra trước | SplitScreenB/SCPCarSplit+Layout.m:662-664; +Chrome.m:295-296,458; +Picker.m:762 (tray front) |
| Gradient/mesh | luôn insertSublayer/insertSubview **atIndex:0** (dưới nội dung) | SplitScreenB/SCPCarSplit+Chrome.m:46,113 |

## 6. Giá trị chỉ INFERRED / không có

- Tên blur style 11 → "SystemUltraThinMaterialLight": INFERRED (số 11 đã xác minh).
- Shadow knob inactive ở 1 biến thể, borderWidth 0 ở Drag.m:171, base StatusBar ở ABHostBMethods.m:1049: INFERRED.
- `#141417` (g/b) và `#AE4ABC` (g) ở SPPSignView: INFERRED từng kênh.
- AutoHide 4,0 s + opacity-0: của cây **tái tạo** (theo QA20), không phải token trích từ binary gốc.
- Không có: màu/font trong plist; `fontWithName:`; hằng khung 297; 542×242 là kích thước slab chú thích, không phải token khung.

---

## Phần 5 — Bàn phím tự vẽ, Prefs UI, popup/shield


Chỉ đọc; không chạy binary, không sửa code. Nguồn: source phục hồi `src/AppBridgeB`, `src/Prefs/OMCPrefs`, `src/App`; payload `OmniCarPrefs.bundle` (plist + `.strings` en/vi, đều là plist nhị phân, đọc bằng plistlib: en 602 key, vi 480 key — vi thiếu các key chỉ có ở Car.strings và key dạng câu động).
Mức bằng chứng: **VERIFIED** = ghi rõ trong source phục hồi là đã đối chiếu disasm/plist · **INFERRED** = source tự ghi suy luận · **CHƯA PHỤC HỒI** = chưa có dữ kiện.
Cách đếm hàng điều khiển: chỉ đếm hàng có control/nút/link thao tác được; không đếm group header, footer, thẻ preview, hàng tĩnh thuần hiển thị (có ghi riêng khi cần).
Lưu ý hai lớp: (a) cơ chế GỐC 1.0.3 trong binary; (b) các chốt khoá/sửa về sau đã nằm trong cây source phục hồi (đánh dấu [hl3], [fs-diag]…) — khi hai lớp khác nhau, ghi cả hai.

## 1. BÀN PHÍM TỰ VẼ (ABKeyboard / ABKey, phía SpringBoard/CarPlay window)

### Trạng thái bật/tắt hiện tại — cổng khoá
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Cổng phía host (bản phục hồi hiện tại) | `ABNativeKeyboardEnabled()` trả YES vô điều kiện → `ABDrawnKeyboardEnabled()` = `!native` = NO vĩnh viễn; pref `appBridgeNativeKeyboard` KHÔNG còn được đọc, marker hl2 `appBridgeNativeKeyboardDrawnRestoredHl2` vô hiệu; log 1 lần/process: "native KHOA CUNG cho app hosted (lenh Nguyen 22:14)". Đây là lệnh Nguyen 09/11/2026 22:14 trong AGENTS.md/MEMORY (mọi app về phím gốc) | `src/AppBridgeB/ABHostBMethods.m:80-103` | Muốn bật lại: khôi phục phép đọc pref trong `ABNativeKeyboardEnabled()` | VERIFIED (trong cây phục hồi; là sửa đổi SAU bản gốc, không phải hành vi 1.0.3 gốc)
Tem cổng trên frame-info | Host đóng dấu `drawnKeyboard` vào MỌI payload frame-info (`ABChanOrientation`); bản khoá luôn đóng `0` | `src/AppBridgeB/ABHostGeometry.m:56-82` (`ABPostOrientationToApp`) | Cùng điểm trên | VERIFIED
Cổng phía app hosted | Cache `ABDrawnKb` khởi tạo NO (native); payload `drawnKeyboard=1` bị BỎ QUA + log; khi native: `ABSuppressSystemKeyboard` return ngay (không gắn inputView trống, không marker), `ABKeyboardPublish` return ngay (không phát kênh Darwin phím) | `src/AppBridgeB/ABInApp.m:529-610, 2573-2580, 2653-2662` | Phía app không tự bật được; phụ thuộc tem host | VERIFIED
Cơ chế GỐC (khi cổng mở = drawn) | Field trong app hosted thành first responder → hook gắn inputView trống cỡ 0 (marker associated object) để dập phím hệ thống → app phát trạng thái đóng gói qua Darwin notify `com.anlai.omnicar/appbridge.keyboard` (state = shown | keyboardType<<1 | returnKeyType<<8 | FNV1a(bundleID)<<24) → host `ABKeyboardDispatch` gọi `showForApp:keyboardType:returnType:` / `hideForApp:`; phím gõ quay lại app qua NSDistributed `com.anlai.omnicar/appbridge.key`, userInfo `{action, del, text?}`, object = bundleID | `src/AppBridgeB/ABInApp.m:2548-2677`; `ABChannelNames.m:25,40`; `ABHostGeometry.m:285-377`; `ABKeyboard.m:225-248` (`-send:del:text:`) | — | VERIFIED
Pref ngôn ngữ phím | `appBridgeKeyboardLang` (domain `com.anlai.omnicar`): 1 = tiếng Việt/Telex, 0 = English; mặc định = 1 nếu ngôn ngữ máy là vi; ghi lại mỗi lần bấm phím globe/lang | `src/AppBridgeB/ABKeyboard.m:262-286, 388-420` | CFPreferences key `appBridgeKeyboardLang` | VERIFIED

### Khung panel + header (buildPanel / layoutPanelIn / layoutKeys)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Panel chứa | UIView nền trong suốt, bóng tím (110,100,200)/255 opacity 0.3, radius 20, offset (0,6); hiện: trượt lên 0.35s (cubic (0.1,0)-(0.1,1)), ẩn: trượt xuống 0.25s rồi removeFromSuperview | `ABKeyboard.m` `-buildPanel` (~L470), `-showForApp:` (~L270), `-hideForApp:` (~L330) | `ABKeyboard:buildPanel/layoutPanelIn:` | VERIFIED
Kích thước panel | Rộng = max(chiều rộng vùng app xe ∩ cửa sổ − 12, 200), x = minX(vùng)+6 kẹp trong cửa sổ; cao = min(floor(0.78 × cao cửa sổ), 280); y = đáy cửa sổ − cao − 6 | `ABKeyboard.m` `-layoutPanelIn:` | Hằng 0.78 / cap 280 / lề 6-12 | VERIFIED
Lớp kính (glass) | UIVisualEffectView blur style 11 (SystemUltraThinMaterialLight), bo 20 continuous, viền trắng alpha 0.85 dày 1, phủ ảnh mesh `OMCLogoMeshImage(0)`, `userInteractionEnabled = NO` | `ABKeyboard.m` `-buildPanel` | `ABKeyboard:glass` | VERIFIED
Ô preview (field) | View trắng alpha 0.85, bo 12, viền trắng 1pt; frame: y=5, cao 24, từ x=5 tới sát nút lang (fieldX−13 rộng); bên trong là UILabel preview inset (10,0), font System 13 Medium, cắt đầu dòng (TruncatingHead) | `ABKeyboard.m` `-buildPanel`, `-layoutKeys` | `ABKeyboard:field/preview` | VERIFIED
Chữ preview | Có chữ đã gõ: hiện toàn bộ `typed`, màu (0.16, 0.24, 0.0625) alpha 1. Trống: placeholder theo chế độ — VI: "Gõ tiếng Việt kiểu Telex"/EN: "Vietnamese (Telex)"; không VI: "Gõ để nhập vào app"/"Type into the app" (qua OMCTr theo ngôn ngữ máy, không phải theo `vietnamese`), alpha 0.6 | `ABKeyboard.m` `-updatePreview` | `ABKeyboard:updatePreview` | VERIFIED
Nút lang (header) | UIButton chữ "VI"/"EN" (theo chế độ hiện tại, set ở rebuildKeys), font 10.5 Semibold, màu slate (74,79,128)/255, viền slate alpha 0.25 dày 1, bo 6; frame 26×16 tại (hideX−30, 9); bấm = `langTapped` → keyTapped command `lang` | `ABKeyboard.m` `-buildPanel`, `-layoutKeys`, `-rebuildKeys`, `-langTapped` | `ABKeyboard:langButton` | VERIFIED
Nút ẩn phím (header) | UIButton icon SF Symbol `keyboard.chevron.compact.down` pointSize 16 Medium, tint slate; frame 34×24 tại (W−39, 5); bấm = `hideTapped`: gửi action `dismiss` rồi `hideForApp:nil` (ép ẩn) | `ABKeyboard.m` `-buildPanel`, `-layoutKeys`, `-hideTapped` | `ABKeyboard:hideButton` | VERIFIED
Vùng phím (keysView) | Frame (5, 33, W−10, H−38); hàng cách nhau 5pt; cao hàng = floor((cao − 5×(số hàng−1))/số hàng); phím cách nhau 5pt; hàng chữ ngắn (không phải 2 hàng cuối, <10 phím) bị cap bề rộng đơn vị = (rộng−45)/10 để giữ căn giữa | `ABKeyboard.m` `-layoutKeys` | Hằng 33/38/5 trong `layoutKeys` | VERIFIED
Bubble phóng to phím | Khi nhấn giữ phím thường (không command, có value): UILabel bong bóng trắng, chữ slate, bo 9, bóng tím, cỡ = round(1.3×rộng phím) × round(1.45×cao phím), font round(0.85×cao phím), anchor (0.5,1), nảy spring 0.18s từ scale 0.7; thả tay: fade 0.12s về alpha 0; không nhận chạm | `ABKeyboard.m` `-key:pressed:`, `ABKey -setHighlighted:` | `ABKeyboard:bubble` | VERIFIED

### Layout phím — chế độ chữ (numbers = NO). Tổng 44 phím + 2 nút header
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Hàng 0 — số | 10 phím `1 2 3 4 5 6 7 8 9 0`, weight 1.0/phím; hàng "plain": không hoa/thường theo shift, không hint | `ABKeyboard.m` `-rebuildKeys` (rowStrings `@[@"1234567890",…]`) | Chuỗi hàng trong `rebuildKeys` | VERIFIED
Hàng 1 | 10 phím `q w e r t y u i o p`, weight 1.0 | nt | nt | VERIFIED
Hàng 2 | 9 phím `a s d f g h j k l`, weight 1.0 | nt | nt | VERIFIED
Hàng 3 | 9 phím: [shift: symbol `shift`/`shift.fill` khi bật, command `shift`, weight 1.5] + `z x c v b n m` (7, weight 1.0) + [xoá: symbol `delete.left`, command `del`, weight 1.5] | nt | nt | VERIFIED
Hàng 4 — chức năng (cuối) | 6 phím: `#+…` nhãn `#+=' (mở số) command `mode` weight 1.4 · [globe: symbol `globe`, command `lang`, weight 1.1] · `,` weight 1.0 · [space: nhãn `Tiếng Việt` khi VI / `space` khi EN, value " ", command `space`, weight 4.2] · `.` weight 1.0 · [enter: symbol `return`, command `ret`, weight 1.8, luôn lit] | nt | nt | VERIFIED
Chế độ bắt đầu | keyboardType ∈ {2,4,5,8,11} (bitmask 0x934, type <12) → mở thẳng chế độ số/ký hiệu; còn lại mở chế độ chữ; shift luôn reset NO khi show | `ABKeyboard.m` `-showForApp:` | Bitmask 0x934 | VERIFIED

### Layout phím — chế độ số/ký hiệu (numbers = YES). Tổng 43 phím + 2 nút header
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Hàng 0 | 10 phím `1…0` (giữ nguyên như chế độ chữ) | `ABKeyboard.m` `-rebuildKeys` (mảng numbers @0x39468) | Chuỗi hàng numbers | VERIFIED
Hàng 1 | 10 phím `[ ] { } # % ^ * + =` | nt | nt | VERIFIED
Hàng 2 | 10 phím `- / : ; ( ) $ & @ "` | nt | nt | VERIFIED
Hàng 3 | 7 phím: [`#` thường, weight 1.5 — thay vị trí shift] + `. , ? ! '` (5 phím, weight 1.0) + [xoá `delete.left`, weight 1.5] | nt | nt | VERIFIED
Hàng 4 | Như chế độ chữ, chỉ khác phím mode: nhãn `ABC` (quay về chữ) | nt | nt | VERIFIED
Toàn chế độ số | Mọi hàng đều "plain": không hint, không shift-case | nt | Cờ `plain = (ri==0) || numbers` | VERIFIED

### Hint góc phím (chỉ hàng chữ 1–3, chế độ chữ)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Hint label | UILabel 11×11 ở góc phải trên (x = rộng−13, y=0), font System 8, màu slate alpha 0.55, căn giữa, không nhận chạm; nội dung tra bảng theo ký tự thường | `ABKeyboard.m` `-rebuildKeys`, `ABKey -layoutSubviews` | `ABKeyHintTable()` + frame trong `ABKey:layoutSubviews` | VERIFIED
Bảng hint VI (10) | a→â, d→đ, e→ê, f→` (huyền), j→. (nặng), o→ô, r→? (hỏi), s→´ U+00B4 (sắc), w→ư, x→~ (ngã) — tức hint = ký tự Telex của chính phím đó | `ABKeyboard.m` `ABKeyHintTable` (hằng 0x39630) | Bảng VI trong `ABKeyHintTable` | VERIFIED
Bảng hint EN (26) | a→@ b→; c→' d→& e→| f→* g→- h→+ i→> j→( k→) l→" m→? n→! o→{ p→} q→% r→= s→# t→[ u→< v→: w→\\ x→$ y→] z→_ — hint = ký hiệu "giữ phím" kiểu iOS | nt (hằng 0x39658) | Bảng EN trong `ABKeyHintTable` | VERIFIED

### Vỏ phím (ABKey factory) + Telex + hành vi gõ
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Phím thường | UIButton type 0; nền trắng alpha 0.9 (phím chữ/ký hiệu thường), 0.5 (phím chức năng có command/phím `,` `.`); bo 7 continuous, viền trắng alpha 0.9 dày 1 (chỉ khi chưa lit), bóng tím opacity 0.18 radius 1 offset (0,1); chữ slate (74,79,128); font hàng = max(floor(cao hàng×0.56), 14) đặt ở layoutKeys cho phím không command; font gốc factory: thường 11 Semibold, special 17, space 10 | `ABKeyboard.m` `-key:symbol:value:command:weight:` | Factory `ABKey` | VERIFIED
Phím lit (enter luôn lit; shift lit khi đang bật) | Không viền/bóng của factory; khi paint: gradient chéo accent tím→xanh (0.608,0.529,0.973)→(0.365,0.706,0.965), bo 7, bóng màu đầu gradient opacity 0.4 radius 6 offset (0,3), nền trong suốt, chữ/trắng; nhấn: gradient opacity 0.82 | `ABKeyboard.m` `ABKey -paint:`, factory | Palette accent dùng chung ABChromeViews | VERIFIED
Hiệu ứng nhấn | scale 0.96 trong 0.08s khi highlight, nảy về 0.3s spring damping 0.6 khi thả; phím thường đồng thời báo press-edge cho bubble | `ABKeyboard.m` `ABKey -setHighlighted:` | nt | VERIFIED
Symbol trên phím chức năng | SF Symbol pointSize 15 Medium cho shift/delete/globe/return (vẽ qua `systemImageNamed:withConfiguration:`) | `ABKeyboard.m` factory | nt | VERIFIED
Gõ 1 ký tự | `typeCharacter:`: nếu VI và từ hiện tại +1 ≤ 11 ký tự → `ABTelexApply(word, ch)`; có kết quả Telex: gửi action `type` với del = độ dài từ cũ, text = từ mới; không: gửi del 0, text = ký tự; ký tự không phải chữ cái → reset từ Telex | `ABKeyboard.m` `-typeCharacter:` | Giới hạn từ 11 ký tự | VERIFIED
Telex engine | 12 họ nguyên âm × 6 cột [thường, sắc, huyền, hỏi, ngã, nặng]: a/ă/â, e/ê, i, o/ô/ơ, u/ư, y (chuỗi đầy đủ trong source); phím dấu s/f/r/x/j, biến âm a/e/o/w, d→đ, z gỡ dấu; BẢN GỐC LỆCH Telex chuẩn ở 8 điểm đã ghi [D1]–[D8] trong source (quét ngược bị chặn bởi "bound", d-rule tác động ký tự đầu từ, escape chỉ thấy trong [base,bound)…) — giữ nguyên khi thiết kế lại, đừng "sửa" theo Telex chuẩn | `src/AppBridgeB/ABTelex.m` đầu file + bảng `ABTelexFamilies` (đã kiểm 253.908 ca, 0 lệch) | `ABTelexApply` | VERIFIED
Đánh đổi của phím vẽ (đối chiếu AGENTS.md, khớp source) | Mất autocorrect/gợi ý/dictation của phím gốc; tiếng Việt phải tự viết Telex (đúng engine trên); bù lại: gõ được ngay trên màn xe cho app hosted vốn bị dập phím hệ thống | `ABInApp.m` (dập phím) + `ABTelex.m` | — | VERIFIED
Hành vi command | `del`: gửi del 1, cắt ký tự cuối typed/word · `shift`: đảo shift + rebuild (chỉ 1 ký tự hoa rồi tự tắt sau khi gõ phím thường/space) · `mode`: đảo numbers, shift=NO · `lang`: đảo VI/EN, xoá từ đang gõ, lưu pref · `ret`: gửi action `return` · lỗi trong keyTapped bị @catch, log "ban phim xe: loi phim" và rơi phím đó | `ABKeyboard.m` `-keyTapped:` | nt | VERIFIED
Return key | Panel nhận `returnType` của field nhưng KHÔNG đổi nhãn/symbol phím enter theo returnType (phím luôn là symbol `return`); returnType chỉ vào log show | `ABKeyboard.m` `-showForApp:` (lưu `self.returnType`, không nơi nào đọc để vẽ) | Nếu muốn nhãn Go/Search/Send: sửa factory theo `returnType` | VERIFIED (vắng mặt trong source)
Không có | Hàng số riêng trên chế độ chữ ngoài hàng 0; không phím `.com`/emoji/dictation/mũi tên; không long-press ký tự thay thế (chỉ hint hiển thị) | Toàn bộ `rebuildKeys` | — | VERIFIED (vắng mặt)

## 2. PREFS UI — Settings > OmniCar

### Điểm vào + trang Root (OmniCar)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
PreferenceLoader entry | Hàng "OmniCar", icon `icon.png` (29×29pt, có @2x/@3x), mở bundle `OmniCarPrefs`, controller `OMCRootListController` (NSPrincipalClass) | `payload/…/PreferenceLoader/Preferences/OmniCarPrefs.plist`; `OmniCarPrefs.bundle/Info.plist` | — | VERIFIED
Thẻ header | Card kính/gradient cao 118: logo.png 44×44 (file 64×64 + @2x/@3x), tên "OmniCar" 22 Bold, version "1.0.3" 13 Medium, tagline EN "The power of CarPlay"/VI "Sức mạnh của CarPlay", chấm trạng thái 8×8 (xanh lá khi bật) + chữ On/Off/Expired EN "On"/"Off"/"Expired" VI "Đang bật"/"Đang tắt"/"Đã hết hạn", gradient #B7A6FF→#8FD3FF→#9DF2D8, bo 20 | `src/Prefs/OMCPrefs/OMCHeaderCard.m`; `OMCRootListController.m:251-284` | `OMCHeaderCard` | VERIFIED
Công tắc tổng (master) | UISwitch 51×31 trong header card; pref key `enabled` (domain com.anlai.omnicar); đổi là post `com.anlai.omnicar/prefschanged`; hết hạn bản quyền thì switch bị disable | `OMCRootListController.m:279-284` (`masterToggled:`), `OMCCommon.m:237` (`OMCEnabled`) | key `enabled` | VERIFIED
Nút thanh điều hướng | Phải: nút Respring (icon, accessibility "Respring") + nút globe mở menu 14 ngôn ngữ (key `language`); nhãn EN "Language"/VI "Ngôn ngữ", "Respring" giữ nguyên cả VI | `OMCRootListController.m:206-247` | `languageButton`/`setLanguage:` | VERIFIED
Nhóm Rescue (chỉ hiện khi có tính năng bị rescue tắt) | Group EN "Rescue mode"/VI "Chế độ cứu", footer động liệt kê tính năng bị tắt; nút EN "Turn back on"/VI "Bật lại" (symbol arrow.uturn.backward, action rescueRestore) → bật lại + báo EN "Turned back on. Reconnect the car to apply."/VI "Đã bật lại. Rút và cắm lại xe để áp dụng." | `Root.plist` items 0-1 (omcGroup=rescue); `OMCRootListController.m:applySupportState` | Xoá hẳn khi không có rescue | VERIFIED
Nhóm Conflicts (chỉ hiện khi có tweak CarPlay khác đang chạy) | Group EN "Possible tweak conflict"/VI "Tweak có thể xung đột" + hàng tĩnh tên tweak (symbol exclamationmark.triangle.fill), footer cảnh báo 2 tweak cùng sửa CarPlay | `Root.plist` items 2-3 (omcGroup=conflicts) | nt | VERIFIED
Hàng App trên màn xe | PSLinkCell EN "Apps on the car screen"/VI "App trên màn xe", symbol square.grid.2x2.fill, cellClass riêng OMCAppBridgeAppsLinkCell, mở OMCAppBridgeAppsController | `Root.plist` item 5 | — | VERIFIED
Hàng Màn chính CarPlay | PSLinkCell EN "CarPlay home screen"/VI "Màn chính CarPlay", symbol apps.iphone, mở OMCHomeScreenController | `Root.plist` item 6 | — | VERIFIED
Nhóm Tính năng + 3 hàng feature | Group EN "Features"/VI "Tính năng", footer EN "Changes apply right away. Respring after installing or updating."/VI "Thay đổi áp dụng ngay. Respring sau khi cài hoặc cập nhật."; 3 hàng link tự chèn theo featureOrder: Startup Screen (10, symbol play.rectangle.fill, icon file StartupScreenIcon.png 29pt), Speed Bubble (20, speedometer, SpeedBubbleIcon.png 29pt), Split Screen (30, rectangle.split.2x1.fill, không file icon riêng); mỗi hàng feature hiển thị trạng thái bật/tắt lấy từ switch đầu tiên của Feature*.plist (OMCFeatureStatusCell) | `Root.plist` item 7-8; `Feature*.plist` (featureLabel/featureSymbol/featureOrder/featureController); `OMCRootListController.m:insertFeatureSpecifiers` | Thêm feature = thêm 1 Feature*.plist | VERIFIED
Hàng Hồ sơ xe | PSLinkCell EN "Car profiles"/VI "Hồ sơ theo xe", symbol car.2.fill → OMCCarProfilesController | `Root.plist` item 9 | — | VERIFIED
Nhóm Hỗ trợ | Group EN "Support"/VI "Hỗ trợ"; nút EN "Show guide again"/VI "Xem lại hướng dẫn" (symbol lightbulb, mở Onboarding); nút EN "What's new"/VI "Có gì mới" (symbol sparkles, mở WhatsNew) | `Root.plist` items 10-12 | — | VERIFIED
Nhóm Developer + Gửi log | Group EN "Developer"/VI "Nhà phát triển", footer EN "Something wrong? Tap Send log and pick Mail or a chat app…"/VI "Gặp lỗi? Bấm Gửi log rồi chọn Zalo hoặc Mail…"; nút EN "Send log"/VI "Gửi log" (symbol square.and.arrow.up) → tạo file `OmniCar-log-<yyyyMMdd-HHmm>.txt` (kèm mục chẩn đoán DIAG_*) rồi mở share sheet; lỗi tạo file → alert SEND_LOG_FAILED | `Root.plist` items 13-14; `OMCCommon.m:900-945` (OMCShareReport) | `sendLog` | VERIFIED
Tổng Root | 15 item plist = 5 group + 9 hàng thao tác cố định + 3 hàng feature chèn động + header (1 switch); 2 nhóm rescue/conflicts có điều kiện | Đếm từ Root.plist + code | — | VERIFIED

### Trang Startup Screen (FeatureStartupScreen.plist, 44 item; OMCStartupScreenController)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Header trang (code) | Table header cao ~280: thẻ preview SSStartupView (rộng min(W−32,560), cao ×0.375, bo 20, chạm để phát lại) + tiêu đề EN "Startup style"/VI "Kiểu khởi động" + hint EN "Tap the preview to replay"/VI "Chạm hình để xem lại" + gallery ngang 11 ô kiểu (78×108, cách 4) ghi key `startupScreenStyle` (mặc định: không có trong plist — vắng = style 0 Video): 0 Video, 1 Logo, 2 Greeting/Lời chào, 3 Weather/Thời tiết, 4 Engine start/Khởi động máy, 5 Welcome light/Ánh sáng chào, 6 Particles/Hạt sáng, 7 HUD check/HUD tự kiểm tra, 8 Briefing/Bảng tin, 9 Liquid/Chất lỏng, 10 Random/Ngẫu nhiên. Các hàng bên dưới lọc theo `ssStyles` của style đang chọn | `OMCStartupScreenController.m:423-576, 100-108`; `FeatureStartupScreen.plist` (lọc ở `specifiers` L235-320) | `startupScreenStyle`, mảng ssStyles | VERIFIED
Switch tổng | EN "Startup Screen"/VI "Màn hình khởi động", key `startupScreenEnabled`, mặc định BẬT | Feature plist item 1 | key | VERIFIED
Nhóm Video (style 0) | Group EN "Video"/VI "Video", footer "MP4, MOV, M4V · up to 60 seconds."/VI giữ nguyên định dạng + "tối đa 60 giây."; hàng list EN "Video"/VI "Video" key `startupScreenVideoName` (PSLinkListCell, dynamicTitles); nút EN "Add video"/VI "Thêm video"; nút EN "Preview"/VI "Xem thử"; nút đỏ EN "Delete video"/VI "Xoá video" | items 2-6 | — | VERIFIED
Nhóm Hiển thị (style 0) | Group EN "Display"/VI "Hiển thị"; segment Fill/Fit EN "Fill"/"Fit" VI "Lấp đầy"/"Vừa khung", key `startupScreenScaleMode`, mặc định 0; switch EN "Play full video"/VI "Phát hết video" key `startupScreenPlayFull` mặc định TẮT; switch EN "Video sound"/VI "Âm thanh của video" key `startupScreenSound` mặc định TẮT | items 7-10 | keys | VERIFIED
Nhóm Logo (style 1) | Group EN "Logo"/VI "Logo"; segment hiệu ứng Fade in/Zoom/Glow EN VI "Hiện dần"/"Phóng to"/"Phát sáng", key `startupScreenLogoEffect` mặc định 0; nút EN "Choose logo"/VI "Chọn logo"; nút đỏ EN "Remove logo"/VI "Xoá logo" | items 11-14 | key | VERIFIED
Nhóm theo style chào (styles 2,3,6,8) | Group tên = tên style; text field EN "Your name"/VI "Tên của bạn", placeholder EN "Optional"/VI "Không bắt buộc", key `startupScreenGreetingName`; footer đổi theo style (greeting/weather/particles/briefing) | items 15-16 | key | VERIFIED
Nhóm tên xe (styles 4,7) | Text field EN "Car name"/VI "Tên xe", key `startupScreenCarName`, placeholder = tên xe đọc từ CarPlay (fallback "OmniCar"), footer "Leave empty to use the car's own name."/"Để trống để dùng tên xe nhận từ CarPlay." | items 17-18 | key | VERIFIED
Nhóm nhịp (style 5) | Segment Slow/Medium/Fast EN VI "Chậm rãi"/"Vừa"/"Nhanh", key `startupScreenTempo`, mặc định 1 (Medium) | items 19-20 | key | VERIFIED
Nhóm Random (style 9) | Group EN "Pick from"/VI "Chọn ngẫu nhiên từ"; 9 nút bật/tắt từng style con (symbols film/seal/hand.wave/cloud.sun.rain/speedometer/car.fill/sparkles + HUD + Briefing), key mảng `startupScreenRandomSet` (vắng = cả 10 style 0-9), giữ tối thiểu 1 | items 21-30 | key mảng | VERIFIED
Nhóm Thời lượng | Group EN "Duration (seconds)"/VI "Thời lượng (giây)"; slider key `startupScreenDuration` 1-30, mặc định 5, showValue, 29 nấc; switch EN "Tap to skip"/VI "Chạm để bỏ qua" key `startupScreenTapToSkip` mặc định BẬT | items 31-33 | keys | VERIFIED
Nhóm Âm thanh khởi động | Group EN "Startup sound"/VI "Âm thanh khởi động"; nút Choose sound/Chọn âm thanh, Play sound/Nghe thử, nút đỏ Remove sound/Xoá âm thanh (file key `startupScreenSoundFile`); slider âm lượng 0-100 mặc định 100, 20 nấc — footer của nhóm gộp cả dòng "Volume/Âm lượng" + file đang dùng; switch EN "Silent during a call"/VI "Im lặng khi đang gọi điện" key `startupScreenSoundSkipCall` mặc định BẬT | items 34-39 | keys | VERIFIED
Nhóm Ngày đặc biệt | Group EN "Special days"/VI "Ngày đặc biệt"; switch EN "Festive screen"/VI "Màn hình ngày lễ" key `startupScreenOccasions` mặc định BẬT; hàng tĩnh EN "Birthday"/VI "Sinh nhật" (id birthday, giá trị ngày sinh key `startupScreenBirthday`); nút Preview (nhãn động "Preview: <ngày lễ sắp tới>" — Tết/Sinh nhật/Giáng sinh/Trung thu/Năm mới) | items 40-43 | keys | VERIFIED
Tổng Startup | 44 item plist = 11 group + 33 hàng; số hàng THẤY được thay đổi theo style (lọc ssStyles) + header (preview + gallery 11 ô) | Đếm plist | — | VERIFIED

### Trang Speed Bubble (OMCSpeedBubbleController, dựng bằng code — FeatureSpeedBubble.plist chỉ có switch tổng)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Khung trang | 6 section; section 0 = thẻ preview sống (bản đồ + bong bóng SPPBubbleView + nút gradient "Try on the car"/"Xem thử trên xe" → hiện bong bóng trên xe 10 giây); tắt tổng thì section ≥2 mờ alpha 0.4 + khoá chạm | `OMCSpeedBubbleController.m:325-530` | — | VERIFIED
Switch tổng | EN "Speed Bubble"/VI "Bong bóng tốc độ", phụ đề EN "Shows while the navigation app runs in the background"/VI "Hiện khi app dẫn đường chạy nền", icon speedometer #8B7CFF, key `speedBubbleEnabled` mặc định BẬT (khớp Feature plist item 1) | L461-473; FeatureSpeedBubble.plist | key | VERIFIED
Section Appearance/Giao diện | Hàng ô kiểu: 9 kiểu (key `speedBubbleStyle`, dải tile ngang) EN Glass drop/Glass pill/Twin/Arc/Harmony card/Minimal/Night glass/HUD strip/Dashboard gauge — VI Giọt kính/Viên kính/Cặp đôi/Vòng cung/Thẻ Harmony/Tối giản/Kính đêm/Dải HUD/Đồng hồ taplo; hàng màu nền: 7 màu (key `speedBubbleColor` mặc định 0) Default/White/Black/Violet/Blue/Mint/Pink — VI Mặc định/Trắng/Đen/Tím/Xanh dương/Bạc hà/Hồng; switch EN "Source app icon"/VI "Icon app nguồn" key `speedBubbleShowAppIcon` mặc định BẬT, icon app.badge.fill #FF7FA8 | L465-486, 745-870 (layoutStyles/layoutColors) | keys `speedBubbleStyle/Color/ShowAppIcon` | VERIFIED (tên key style suy từ idiom controller; hàng tile VERIFIED)
Section Size and position/Cỡ và vị trí | Slider EN "CarPlay" key `speedBubbleSizeCar` và EN "iPhone" key `speedBubbleSizePhone`, cùng 60-220, mặc định 100, format %ld%%; hàng nút EN "Reset position and size"/VI "Đặt lại vị trí và cỡ"; footer là hướng dẫn cử chỉ trên xe (kéo/chụm/chạm/giữ) | L486-500 | keys | VERIFIED
Section Speed source/Nguồn tốc độ | Hàng ô chọn nguồn (key `speedBubbleSource` mặc định 0): 0 Vietmap Live, 1 GOFA, 2 Waze (GPS + biển thử nghiệm), 3 Wyn — tên app là tên riêng không dịch; hàng hint tĩnh đổi theo nguồn (SPEEDBUBBLE_SRC_HINT_0..3) | L494-530, 869-910 | key | VERIFIED
Section Overspeed warning/Cảnh báo quá tốc độ | Hàng động theo mode (key bitmask `speedBubbleWarnMode`): switch "Warning"/"Cảnh báo" (bit 1, icon rectangle.dashed #FF5A5F) → thêm hàng 4 ô hiệu ứng (key `speedBubbleWarnFx`: Blinking rim/Glow/Screen flash/Bubble — VI Viền nháy/Phát sáng/Nháy màn/Bong bóng); switch "Sound"/"Âm thanh" (bit 2, icon speaker.wave.2.fill) → segment Tone/Voice (key `speedBubbleWarnSound`, EN "Tone"/"Voice" VI "Âm báo"/"Giọng nói"): Tone = 6 hàng chọn + nghe thử (Beep/Double beep/Fast beeps/Ding-dong chime/Ping/Radar, key `speedBubbleWarnTone`); Voice = 9 câu giọng (nhóm Serious/Fun) + hàng nhập câu riêng (text field, key `speedBubbleWarnVoice`/`speedBubbleWarnText`); cuối: slider EN "Threshold"/VI "Ngưỡng" key `speedBubbleWarnOver` −10…+10 mặc định +5, format %+ld km/h | L540-720 (`buildWarnRows`/`warnCell:`) | keys | VERIFIED (key warnText theo idiom; hàng VERIFIED)
Tổng Speed Bubble | Cố định 9 hàng (preview, enable, style, color, icon, sizeCar, sizePhone, reset, sources, hint = 10 kể cả hint tĩnh) + section cảnh báo 3-16 hàng theo mode/loại âm | Đếm từ code | — | VERIFIED

### Trang Split Screen (OMCSplitScreenController, code — FeatureSplitScreen.plist chỉ có switch tổng)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Khung trang | 7 section (section 6 là phần thêm về sau — xem ghi chú cuối mục); section 0 = thẻ preview chia màn (mặc định trái com.apple.Music, ghim com.apple.Maps); tắt tổng thì section ≥2 mờ 0.4 + khoá | `OMCSplitScreenController.m:145-430` | — | VERIFIED
2 switch | EN "Split Screen"/VI "Chia màn hình" key `splitScreenEnabled` mặc định BẬT (icon rectangle.split.2x1.fill #8B7CFF); EN "Open on connect"/VI "Tự mở khi cắm xe" key `splitScreenAutoLaunch` mặc định TẮT (icon bolt.fill #2BC79A) | L268-280 | keys | VERIFIED
Section Layout/Bố cục | 1 hàng link EN "Pinned pane"/VI "Ô được ghim" (icon pin.fill #FFB340) → mở app picker (OMCSplitScreenAppPickerController), key `splitScreenPinnedApp`, giá trị hiện tại hiện ở detail, trống = "None"/"Không chọn"; footer giải thích ô ghim | L280-290 | key | VERIFIED
Section Favorite layouts/Bố cục yêu thích | 3 hàng bố cục yêu thích; chạm mở editor 4 hàng con: tên (text field, placeholder Commute/Weekend/Road trip — VI Đi làm/Đi chơi/Đi xa), hàng chọn bố cục 4 chip (2 panes/3 panes/1 large + 2/2 + 1 large — VI 2 ô/3 ô/1 lớn + 2/2 + 1 lớn), 3 ô chọn app (Pane 1/2/3), nút Done/Xong; keys dạng fav<n>Layout/fav<n>Apps… (SSFavKey) | L290-330, 460-580 | Họ key fav | VERIFIED (cấu trúc; tên key con theo SSFavKey)
Section OmniCar panel in the car/Bảng OmniCar trên xe | 1 hàng EN "Show in the panel"/VI "Hiện trong bảng" với 2 chip bật/tắt: Recent/Gần đây (key `splitScreenShowRecent`, mặc định BẬT), Favorites/Yêu thích (key `splitScreenShowFavorites`, mặc định BẬT) | L305-320 | keys | VERIFIED
Section trợ giúp | Switch hàng EN "Gestures on the car"/VI "Cử chỉ trên xe" (chỉ ẩn/hiện đoạn hướng dẫn, không phải pref tính năng) → đoạn text hướng dẫn 6 dòng; hàng gập EN "Siri / Shortcuts"/VI "Siri / Phím tắt" → danh sách URL omnicar://… mỗi hàng có nút Copy/Chép (bấm hàng cũng chép; toast xác nhận — xem §3) | L320-420, 133 (`urls`) | — | VERIFIED
Section Diagnostics [KHÔNG PHẢI GỐC 1.0.3] | 3 hàng do vòng sửa sau thêm ([fs-diag] GPT WO fix-p, nhãn SPLITSCREEN_DIAG_* KHÔNG có trong .strings của payload gốc): switch fullscreenDiagExpand mặc định TẮT; switch youtubeVirtualize mặc định BẬT; segment bridgewake.pinchMode (Off/Dry/Enforce) mặc định 1 Dry | L365-410 | Chỉ tồn tại trong cây phục hồi, đừng tính vào thiết kế gốc | VERIFIED (là thêm sau)
Tổng Split Screen | Gốc: 1 preview + 2 switch + 1 pinned + 3 fav (+4 editor khi mở) + 1 panel + 1 gestures + 1 siri (+URL khi mở) ≈ 10 hàng gốc; +3 hàng diag thêm sau | Đếm từ code | — | VERIFIED

### Trang Apps on the car screen (OMCAppBridgeAppsController, layoutPage = NO)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Khung trang | Table grouped, bật editing thường trực; nút phải "Reset"/"Đặt lại" → hộp xác nhận (xem §3). Chỉ hiện section 1-3 (shows:section) | `OMCAppBridgeAppsController.m:120-160, 438-470` | `layoutPage` | VERIFIED
Section Included/Bao gồm (CarPlay apps) | Mỗi app CarPlay gốc 1 hàng (icon 37pt + tên + phụ đề trạng thái: "App Bridge" / EN "Removed in iOS Settings"/VI "Đã bỏ trong Cài đặt iPhone"); vuốt/xoá trong editing để gỡ icon khỏi màn xe; dữ liệu key `homeScreenCarApps` (mảng {id,name,off}), dự phòng `splitScreenCarPlayApps`; footer EN "Remove a CarPlay app to take its icon off…"/VI tương ứng; chưa cắm xe lần nào thì footer báo đang đoán theo hỗ trợ CarPlay | L190-260, 560-600; keys APPS_* | keys mảng | VERIFIED (hành vi hàng); INFERRED (khớp chính xác affordance xoá theo report)
Section Choose apps/Chọn app | Hàng đầu = thanh tìm kiếm (placeholder EN "Search apps"/VI "Tìm app"); tiếp: mọi app iPhone đã cài (trừ 6 bundle hệ thống liệt kê trong code) 1 hàng; chạm/+ để đưa lên xe qua App Bridge (key tập `appBridgeApps` qua OMCAppBridgeAppsPref); hàng trống: EN "None"/VI "Chưa chọn" hoặc "No app matches."/"Không có app nào khớp."; footer: app đã có CarPlay riêng không liệt kê | L200-260, 640-680 | key `appBridgeApps` | VERIFIED (cấu trúc); INFERRED (wiring search bar — source tự ghi)
Không có hàng phím | Trang này KHÔNG có switch/segment nào cho bàn phím tự vẽ: không pref UI nào bật/tắt ABKeyboard trong toàn bộ Prefs (đã grep toàn bộ OMCPrefs: không `appBridgeNativeKeyboard`, không `appBridgeKeyboardLang`) | Grep `src/Prefs/OMCPrefs/*.m` | Muốn có công tắc: thêm specifier mới | VERIFIED (vắng mặt)

### Trang CarPlay home screen (OMCHomeScreenController = cùng class, layoutPage = YES)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Khác biệt duy nhất | `layoutPage` trả YES → chỉ hiện section 0 (preview) + section 4; tiêu đề EN "CarPlay home screen"/VI "Màn chính CarPlay"; nút Reset đổi sang xác nhận đặt lại màn chính | `OMCHomeScreenController.m` (1 method, 8 byte); `OMCAppBridgeAppsController.m:120-125` | Cờ layoutPage | VERIFIED
Section preview | Thẻ xem trước màn chính xe (OMCHSPreview): lưới icon + hình nền hiện tại, cao floor((W−60)×300/800)+20 | L620-650 | `OMCHSPreview` | VERIFIED
Section Icon grid/Lưới icon (4 hàng) | Stepper EN "Columns"/VI "Số cột" key `homeScreenGridCols` giá trị {0=Tự động,3,4,5,6,7,8} (icon rectangle.split.3x1.fill #5AB8FF); stepper EN "Rows"/VI "Số hàng" key `homeScreenGridRows` {0,1,2,3,4} (rectangle.split.1x2.fill #2BC79A); slider EN "Icon size"/VI "Cỡ icon" key `homeScreenIconSize` 60-130 mặc định 100 đơn vị % (plus.magnifyingglass #8B7CFF); switch EN "App names"/VI "Tên app" key `homeScreenShowNames` mặc định BẬT (textformat #FF7FA8) | L660-700; OMCGridEntries | keys | VERIFIED
Section Wallpaper/Hình nền (gập/mở, mặc định mở) | Hàng header (icon photo.fill #FF8A65, detail = tên nền hiện tại); hàng 9 ô nền: 0 Default/Mặc định, 1 Ocean/Đại dương, 2 Sunset/Hoàng hôn, 3 OmniCar, 4 Night/Đêm, 5 Dawn/Bình minh, 6 Forest/Rừng, 7 Your photo/Ảnh của bạn, 8 Your video/Video của bạn (keys `homeScreenWallpaper` bool + `homeScreenWallpaperStyle`); nút EN "From Photos (picture or video)"/VI "Từ Ảnh (ảnh hoặc video)"; slider EN "Blur"/VI "Độ mờ" key `homeScreenBlur` 0-30 mặc định 0 (drop.fill #5AB8FF); slider EN "Darkness"/VI "Độ tối" key `homeScreenDim` 0-70 mặc định 25 % (moon.fill #4A4F80); hàng thứ 6 của section: INFERRED/unused trong source | L704-760 | keys + file `~/…/HomeScreen/wallpaper.jpg|photo.jpg|video.mp4` (OMCDataPath) | VERIFIED; hàng 6 INFERRED
Tổng 2 trang Apps/Home | Apps: 2 section danh sách động (số hàng = số app) + search. Home: 1 preview + 4 hàng lưới + tối đa 6 hàng nền | Đếm từ code | — | VERIFIED

### Trang Car profiles (OMCCarProfilesController)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Switch | EN "A profile for each car"/VI "Hồ sơ riêng cho từng xe", icon car.2.fill, key `carProfilesEnabled` (đọc qua OMCCarPref, mặc định TẮT khi vắng); footer dài: mỗi xe nhớ riêng bố cục chia màn, ô ghim, bong bóng tốc độ, màn khởi động, độ phóng app iPhone | `OMCCarProfilesController.m:73-112` | key | VERIFIED
Danh sách xe | Section EN "Cars"/VI "Xe đã nhận": mỗi xe 1 hàng (icon car.fill, tên xe, phụ đề "Last connected: %@"/"Lần cuối: %@", dấu ✓ = xe đang dùng key `carProfileCurrent`); vuốt trái để quên xe; trống: EN "No cars yet: turn it on and connect a car once"/VI "Chưa có xe nào: bật rồi cắm xe một lần"; footer: dấu ✓ là xe đang dùng, vuốt trái để quên | L114-171 | Họ key carProfile* | VERIFIED
Tổng Profiles | 1 switch + N hàng xe | Đếm từ code | — | VERIFIED

### Onboarding (OMCOnboardingController — modal FormSheet, tự hiện lần đầu)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Điều kiện hiện | Tự trình ở Root `viewDidAppear` khi pref `onboardingDone` chưa đúng; mở lại bằng nút "Show guide again"; trình dạng UINavigationController modal FormSheet; đóng = markDone ghi `onboardingDone` | `OMCOnboardingController.m:17-35`; `OMCRootListController.m:190-200` | key `onboardingDone` | VERIFIED
Khung | Pager ngang 4 trang (paging, không thanh cuộn), UIPageControl chấm (chấm hiện tại = accent), nút Skip/Bỏ qua + Next/Tiếp — trang cuối Next thành Done/Xong; mỗi trang: icon SF Symbol lớn, tiêu đề, body, extra, note cuối trang (layout chi tiết trang INFERRED trong source) | L64-310 | `pageWithSymbol:title:body:extra:note:` | VERIFIED (khung); INFERRED (font/khoảng cách trong trang)
Trang 1 — Welcome | Symbol `car.fill`; EN "Welcome to OmniCar"/VI "Chào mừng đến OmniCar"; body: chọn app iPhone đưa lên xe kể cả app không có CarPlay; nút phụ EN "Choose apps"/VI "Chọn app" (icon square.grid.2x2.fill) → nhảy sang trang Apps; note: đổi lại lúc nào cũng được trong App trên màn xe | L114-128; ONB_P1_* | — | VERIFIED
Trang 2 — Split | Symbol `rectangle.split.2x1.fill`; EN "Split the car screen"/VI "Chia đôi màn xe"; body 4 gạch đầu dòng (nút OmniCar ở dock, chọn bố cục 2/3/1 lớn+2/2+1 lớn, giữ lâu icon, kéo chấm tròn, Home thoát); note về Favorite layouts | L130-133; ONB_P2_* | — | VERIFIED
Trang 3 — Speed Bubble | Symbol `speedometer`; EN/VI "Speed Bubble"/"Bong bóng tốc độ"; body: bong bóng hiện tốc độ + giới hạn; extra = hàng switch "Speed Bubble" ghi thẳng key `speedBubbleEnabled`; note: cần Vietmap Live hoặc GOFA | L135-166; ONB_P3_* | key | VERIFIED
Trang 4 — Quick tips | Symbol `lifepreserver`; EN "Quick tips"/VI "Mẹo nhanh"; body 3 gạch (bảng bố cục, Recent/Favorites, Gửi log khi lỗi); note: mở lại ở Hỗ trợ > Xem lại hướng dẫn | L168-171; ONB_P4_* | — | VERIFIED

### WhatsNew (OMCWhatsNewController — modal, tự hiện 1 lần/phiên bản)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Điều kiện hiện | Root `viewDidAppear`: chỉ khi Onboarding không hiện và pref `whatsNewSeen` ≠ version hiện tại ("1.0.0"); markSeen ngay khi trình | `OMCWhatsNewController.m:46-60`; `WhatsNew.plist` | key `whatsNewSeen` | VERIFIED
Nội dung 1.0.0 | Tiêu đề EN "What's new in OmniCar %@"/VI "Có gì mới trong OmniCar %@"; 4 thẻ (ô icon 40×40 bo 11, symbol 18pt): keyboard — "Keyboard on the car screen"/"Bàn phím trên màn hình xe" (đây là nơi bản gốc QUẢNG BÁ phím tự vẽ); arrow.up.left.and.arrow.down.right — "Pane zoom"/"Phóng to ô"; globe — "14 languages"/"14 ngôn ngữ"; lightbulb — "First-run guide"/"Hướng dẫn lần đầu"; nút EN "Continue"/VI "Tiếp tục" | `WhatsNew.plist` key "1.0.0"; L89-180 | Sửa WhatsNew.plist + WN_* strings | VERIFIED

## 3. POPUP / SHIELD / OVERLAY

### pickerShield (SplitScreen, che nền khi mở picker chọn app)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Bản chất thật | KHÔNG phải view che riêng: trong source phục hồi, `pickerShield` chỉ được gán = nil ở mọi điểm (mở sheet, đóng sheet) và được ĐỌC ở các dòng đo [picker-measure]; vật che thực tế khi picker mở là (a) chính sheet (UIVisualEffectView) và (b) popupShield bên dưới. Đừng thiết kế "pickerShield alpha X" — không tồn tại | `src/SplitScreenB/SCPCarSplit+Picker.m:450-461, 764-766, 926-1002` (grep toàn bộ gán pickerShield) | — | VERIFIED (vắng mặt phép tạo)
Sheet picker (vật che thật 1) | UIVisualEffectView bo 24 continuous; khi có app hosted dưới sheet: effect bị gỡ → trong suốt + chỉ còn viền trắng alpha 0.85 dày 1 ([picker-face] clear — đây là "vật che picker" đã kết án ở vòng hl4: effect view phủ ~61%/ô); không có hosted: nền mesh mờ gốc; bên trong: lưới app ô 62×56 (icon 38×38, badge ✓ tím cho app đã dùng + mờ 0.3 + khoá), cột phải 150pt (bản đồ ô, tiêu đề, nút huỷ chip 32×32 đỏ tại tâm (120,30)), chấm trang khi ≥2 trang; vào: spring 0.5s từ translate(0,48)+scale 0.92 (đổi sheet cũ: fade 0.35s); ra: fade+rơi 0.22s | `SCPCarSplit+Picker.m:440-790` (`buildPickerSheetForPane:`), `920-1010` (`removePickerSheet`) | `SCPApplyMeshBackdrop` / cờ clear-face | VERIFIED

### popupShield (SplitScreen, bắt chạm ngoài popup)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Vật che | SCPCTouchWatch phủ TOÀN BỘ host (tray window nếu có, không thì tabParent), autoresizing 0x12, nền trắng alpha **0.02** — khớp số đã đo "alpha hiệu dụng 0,02"; chỉ tồn tại khi panel đang mở (`panelOpen`) và có tabParent; luôn được đưa lên trước | `src/SplitScreenB/SCPCarSplit+Chrome.m:420-466` (`updatePopupShield`) | Alpha 0.02 tại Chrome.m:440 | VERIFIED
Hit-test | `hitTest:` LUÔN trả nil (không nuốt chạm theo nghĩa view): điểm trong vùng + không thuộc exempt → gọi callback `outside` → `closePopups` (đóng tray, ratio menu, picker sheet, ẩn bar); điểm exempt → bỏ qua. Vùng exempt = rect (toạ độ cửa sổ) của tray, ratioMenu, pickerSheet, homeButton, ratioKnob, picker của sheet, và mọi handle/bar đang hiện của các ô | `src/SplitScreenB/SCPCTouchWatch.m:18-45`; `SCPCarSplit+Chrome.m:471-501` (`shieldExemptRects/Point:`) | `exempt`/`outside` blocks | VERIFIED
Lỗ thủng (holes) | `refreshShieldHoles` chuyển exempt rects sang hệ toạ độ shield và set `holes`: mask CAShapeLayer even-odd = bounds trừ holes → vùng exempt trong suốt về mặt vẽ | `SCPCTouchWatch.m:48-75` (`setHoles:`); `Chrome.m:502-512` | nt | VERIFIED
Ghi chú đo | Các dòng log "[do] shield exempt/hitTest" trong 2 file trên là instrumentation fix-round4 E-2 của vòng sửa sau, KHÔNG phải hành vi gốc | Comment trong source tại 2 điểm trên | — | VERIFIED

### ABShieldView (AppBridge host, che ô hosted)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Vật che | UIView con của pane.box, frame = box.bounds, nền trắng alpha **0.08** (khác popupShield 0.02), autoresizing flexible W+H; bật/tắt theo pane bằng `setShield:forPane:` / `setShieldAll:`; phía trên shield vẫn nổi bar + handleHit của ô | `src/AppBridgeB/ABHostBMethods.m:872-903` | Alpha 0.08 tại ABHostBMethods.m:890 | VERIFIED
Hit-test | Chỉ override `touchesBegan:`: chạm vào shield = "chạm ngoài thanh nút" → log, post kênh `ABChanBarDismiss`, gọi `-[ABHost outsideTouched]` (gỡ mọi shield + ẩn mọi bar); chạm bị NUỐT, không chuyển tiếp | `src/AppBridgeB/ABChromeViews.m:113-135` (`ABShieldView`) | `ABShieldView:touchesBegan:` | VERIFIED
Lớp liên quan | ABBoxView: cổng hit-test của ô — pointInside: cho qua ở handleHit/bar, rơi xuyên qua "hole" (mask even-odd bo 12 khoét vùng scene), còn lại chỉ nhận trong bounds thu bởi passInsets | `ABChromeViews.m:56-112` | `ABBoxView:pointInside:`/`applyHole` | VERIFIED

### Toast / thông báo nổi trên màn xe (SplitScreen)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Toast chữ (pill) | UILabel tối đa 2 dòng, font 14 Medium, chữ navy (0.29,0.31,0.50), nền trắng alpha 0.94 bo 19 (SCPStyleDragGhost), rộng = chữ+32 (max = rộng host−48, min 160), cao = chữ+18 (min 38); vị trí: giữa, cách đáy dashboard 50pt; nếu đè ô bridged đang sống thì né sang ô hiện khác; fade in 0.2s, giữ `duration` (mặc định 2.6s), fade out 0.3s rồi gỡ | `SCPCarSplit+Picker.m:1605-1660` (`toast:`/`toast:duration:`) | `SCPCarSplit:toast:` | VERIFIED
Nội dung toast đã phục hồi | "App này không hỗ trợ CarPlay" · "Ô này đang ghim" · "%@ đang mở ở %@" · "%@ thay %@ ở ô %d" · "%@ về nền" · "Không mở được %@ trên xe" · "App này không chia màn hình được" · "Đã đủ 3 ô, không đưa về được" + các lý do zoom bị từ chối (bản EN tương ứng qua OMCTr trong source) | `src/SplitScreenA/SCPCarSplit.m` (các điểm gọi toast), `SCPCarSplit+Panel.m:153-161`, `SCPCarSplit+Zoom.m:240-339` | Điểm gọi | VERIFIED
Toast nền (background toast) | Thanh cao 34, bo 18 (SCPStyleRatioMenu), ở giữa đỉnh container/tray window (center y=26), tag 0x5c9b: icon app 24×24 tại (7,6) + nhãn "%@ đang chạy nền" 13 Medium + nút "Mở lại"/"Reopen" (chữ trắng 13 Semibold trên accent, bo 13) → mở lại app vào ô; tự fade 0.25s sau 5s; bản cũ bị gỡ trước khi hiện bản mới | `SCPCarSplit+Picker.m:1663-1740` (`showBackgroundToastFor:slot:`) | nt | VERIFIED
Tips luân phiên | Tối đa 3 lần (counter pref tipCount), bắn sau 3s khi split đang active, hiện bằng toast 4.5s: (1) chạm 2 lần vạch chia để đổi chỗ 2 ô · (2) giữ và kéo ••• thả lên ô khác để đổi chỗ · (3) kéo vạch chia sát mép để đóng ô | `SCPCarSplit+Picker.m:1742-1770` (`showTipSoon`) | Mảng tips | VERIFIED

### Hộp thoại / toast / sheet TRONG app Cài đặt (Prefs)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Alert 1 nút OK (mẫu chung) | UIAlertController style Alert, title "OmniCar", 1 action "OK" — dùng bởi OMCFeatureListController.showMessage, OMCRootListController.showMessage, và báo lỗi tạo file log (SEND_LOG_FAILED) | `OMCFeatureListController.m:104-112`; `OMCRootListController.m:331-340`; `OMCCommon.m:925-930` | `showMessage:` | VERIFIED
Xác nhận Respring | Alert title EN "Respring", message EN "Respring now?"/VI "Respring ngay bây giờ?", nút Cancel/Huỷ + nút Respring destructive → OMCRespring() | `OMCRootListController.m:369-380` | `respring` | VERIFIED
Xác nhận Reset (Apps/Home) | Alert (title nil), message = APPS_RESET_CONFIRM hoặc HOMESCREEN_RESET_CONFIRM (en/vi đầy đủ trong strings), nút Cancel + "Reset"/"Đặt lại" destructive | `OMCAppBridgeAppsController.m:400-420` (`resetTapped`) | nt | VERIFIED
Xác nhận xoá video Startup | Alert EN "Delete video"/VI "Xoá video", message 'Delete "%@"?'/'Xoá "%@"?', Cancel + Delete/Xoá destructive (xoá cả thư mục .frames) | `OMCStartupScreenController.m:1144-1166` (`deleteVideo`) | nt | VERIFIED
ActionSheet chọn nguồn | addVideo và chooseLogo: sheet (title/message nil) 3 mục: EN "From Photos"/VI "Từ Ảnh" · "From Files"/"Từ Tệp" · "Cancel"/"Huỷ"; neo popover giữa view | `OMCStartupScreenController.m:1117-1130, 1168-1180` | nt | VERIFIED
Alert tiến trình (không nút) | "Preparing video for CarPlay…"/"Đang chuẩn bị video cho CarPlay…" + % tiến độ (Startup, extractFrames); "Preparing the video…"/"Đang chuẩn bị video…" (Apps, export video nền 1280×720); tự dismiss khi xong, lỗi → showMessage/alert lỗi | `OMCStartupScreenController.m:895-930`; `OMCAppBridgeAppsController.m:1080-1095` | nt | VERIFIED
Toast trong Prefs | OMCCardPage.toast: UILabel đen alpha 0.82, chữ trắng 14 Medium, bo 12, cao 40, rộng = chữ+32 (max = view−40), đáy view − safeBottom − 64; fade in 0.25, giữ 1.6s, fade out 0.3. Dùng cho: xác nhận "URL copied"/"Đã chép URL" ở Split Screen; trang con SpeedBubble/SplitScreen kế thừa | `OMCCardPage.m:191-218`; `OMCSplitScreenController.m:610` | `OMCCardPage:toast:` | VERIFIED
Share sheet | Gửi log mở UIActivityViewController (file .txt), popover neo giữa presenter | `OMCCommon.m:932-945` | `OMCShareReport` | VERIFIED
Không có | Không UIAlertController tự dựng kiểu custom-view nào khác trong Prefs; không toast nào trong trang Root/Startup ngoài các mẫu trên | Grep UIAlertController toàn OMCPrefs (17 điểm, đã liệt kê hết theo nhóm) | — | VERIFIED (vắng mặt)

## 4. APP OmniCar.app (companion, com.anlai.omnicar.app)
Loại | Đặc tả | Neo | Điểm can thiệp | Mức bằng chứng
---|---|---|---|---
Payload | Chỉ `Info.plist` + binary `OmniCar` + AppIcon60x60@2x.png (120×120) / @3x.png (180×180); KHÔNG storyboard/xib/nib nào; icon prefs dùng file riêng ở bundle prefs (luồng 1) | `payload/var/jb/Applications/OmniCar.app/` (liệt kê thư mục); `src/App/Info.plist` | — | VERIFIED
Info.plist | Version 1.0.3 (build 1), URL scheme `omnicar`, chỉ portrait, UIRequiresFullScreen, Dark style, iPhone only, min iOS 15.0, không background mode | `src/App/Info.plist` | — | VERIFIED
Màn duy nhất | Dựng 100% bằng code trong `didFinishLaunching`: UIWindow full màn; view nền navy (0.05,0.07,0.15); 1 UILabel giữa (inset ngang 24, font 15, trắng, căn giữa, nhiều dòng) với nội dung cố định: "OmniCar" + câu nhận lệnh Shortcuts/Siri + hướng dẫn tạo Shortcut "Mở URL" + 3 URL mẫu (splitscreen/open?left=com.apple.Maps&right=com.spotify.client · splitscreen/fav?n=1 · splitscreen/close) + dòng trỏ Cài đặt; ngôn ngữ vi/en theo preferredLanguages (chỉ 2 ngôn ngữ, không theo pref `language` của tweak) | `src/App/OMCAppDelegate.m:14-48` | `OMCAppDelegate:didFinishLaunching` | VERIFIED
Nút duy nhất | UIButton system "Mở Cài đặt OmniCar"/"Open OmniCar Settings", frame (0, H−90, W, 44) → mở `prefs:root=OmniCar` | `OMCAppDelegate.m:38-46, 52-58` (`openSettings`) | nt | VERIFIED
Hành vi URL | Mọi `omnicar://` được chuyển NGUYÊN VĂN qua NSDistributedNotificationCenter `com.anlai.omnicar/url` (userInfo {url}); app không tự parse route; 0.3s sau bất kỳ openURL nào app tự suspend (private selector) để Shortcut quay lại chỗ cũ | `OMCAppDelegate.m:60-90` | nt | VERIFIED
Không có màn nào khác | Không tab, không navigation, không màn cài đặt riêng trong app — mọi UI cài đặt nằm ở Prefs (§2) | `src/App/App_REPORT.md`; toàn bộ OMCAppDelegate (1 class, 6 method) | — | VERIFIED

## 5. TỔNG SỐ + PHẦN CHƯA PHỤC HỒI
- **Bàn phím: 44 phím (chế độ chữ) / 43 phím (chế độ số)** mỗi panel, + 2 nút header (lang VI/EN, ẩn phím) + bubble phóng to; 5 hàng mỗi chế độ; Telex 12 họ × 6 cột dấu.
- **Prefs: 8 trang/bề mặt** (Root, Apps, Home Screen, Profiles, Startup, Speed Bubble, Split Screen, app-picker con) **+ 2 modal** (Onboarding 4 trang con, WhatsNew). **Tổng hàng điều khiển ≈ 105**: Root 12 (kể cả master switch; +2 điều kiện) · Startup 33 (+ gallery 11 ô) · Speed Bubble 10 cố định + 3-16 động (section cảnh báo) · Split Screen 10 gốc (+3 diag thêm sau, không tính gốc) · Apps: search + 2 danh sách động · Home 10 · Profiles 1 + N xe · app-picker: danh sách động.
- **Popup/shield/overlay: 7 nhóm** — popupShield (alpha 0.02), ABShieldView (alpha 0.08), picker sheet (vật che thật thay pickerShield), toast pill xe, background toast, tips, và bộ alert/sheet/toast/share trong Prefs (6 mẫu). pickerShield: biến luôn nil — không phải vật thể thiết kế.
- CHƯA PHỤC HỒI / INFERRED còn lại: font + khoảng cách chính xác bên trong trang Onboarding (source tự ghi condensed); wiring thanh tìm kiếm ở trang Apps và hàng 6 section nền Home (source tự ghi INFERRED); tên key chính xác của vài hàng tile Speed Bubble (style/warnText — suy từ idiom controller, hành vi hàng đã VERIFIED); affordance xoá chính xác từng hàng CarPlay ở trang Apps; nhãn phím enter theo returnType (xác nhận KHÔNG tồn tại trong gốc).
- Ngoài phạm vi luồng này: picker/ratio menu/tray phía SplitScreen (luồng khác) — ở đây chỉ ghi phần shield/toast dính tới chúng.

---

## 6. Điểm can thiệp thiết kế — đổi từng phần tử bằng cách nào

Mục này chỉ nêu ĐIỂM NEO can thiệp cho từng nhóm phần tử (chi tiết neo file:line nằm tại từng mục của các
phần 1–5). Không thiết kế thay Nguyen. Năm cách can thiệp:

- **[A] Thay file ảnh trong bundle** — chép đè file cùng tên/đường dẫn trong gói; không đụng code.
- **[B] Thay qua thư mục runtime của người dùng** — file nằm ngoài bundle (`/var/mobile/Library/OmniCar/…`);
  giao diện đổi khi người dùng thay file, hoặc đổi quy ước đọc (đường dẫn/kích thước/nén) tại code đọc.
- **[C] Đổi tham số tại neo** — màu/font/kích thước/thời gian là literal hoặc hằng số trong source phục hồi;
  sửa giá trị tại neo là đủ (neo chính xác ở từng mục).
- **[D] Vẽ lại code** — phần tử do code tự vẽ (path/glyph/scene); bản kê này chép đủ toạ độ/tham số làm đặc tả vẽ lại.
- **[E] Mượn hệ thống** — không sở hữu tài sản; chỉ đổi được cách triệu gọi (tên symbol, format icon) hoặc
  không đổi được (lưới Home gốc).

### 6.1 Nhóm [A] — file ảnh tĩnh trong deb (15 PNG, 279.667 B)

| Phần tử | Neo đọc | Ghi chú can thiệp |
|---|---|---|
| AppIcon60x60@2x/@3x (OmniCar.app) | Info.plist của app | Thay file là đổi icon app ở mọi nơi hệ thống hiện |
| PackageIcon.png | `control` (trường Icon) + fallback splash tại `SSStartupViewBuilders.m:935` | Kiêm hai vai: icon gói trên Sileo VÀ ảnh dự phòng của splash |
| icon.png/@2x/@3x (Prefs bundle) | PreferenceLoader plist | Chỉ hệ thống dùng (trang Settings) |
| logo.png/@2x/@3x (Prefs bundle) | `OMCHeaderCard.m:47` (thẻ đầu trang Prefs) + splash fallback 2 (bản @3x) | Thay file đổi cả hai nơi |
| SpeedBubbleIcon ×3, StartupScreenIcon ×3 | **Không có neo** — 0 tham chiếu trong 8 binary và toàn bộ source | Thay file hiện KHÔNG có tác dụng: cơ chế `featureIcon` mà plist 1.0.3 dùng đã chuyển sang SF Symbol (`featureSymbol`). Muốn dùng lại phải nối lại cơ chế đọc icon trong Prefs |

### 6.2 Nhóm [B] — tài sản runtime người dùng

| Phần tử | Code ghi | Code đọc | Quy ước hiện tại |
|---|---|---|---|
| Logo splash `StartupScreen/Logo/logo.png` | `OMCStartupScreenController.saveLogoImage:` (nén cạnh ≤1024 px) | `SSLoadImageAtPath`/`SSSplash.m:91`; vắng → glyph `car.fill` | Đổi quy ước tại hai neo này |
| Video splash `StartupScreen/Videos/` + `.frames/<video>/%05lu.jpg` | bộ export trong Prefs | SSSplash phát chuỗi khung JPG (không AVPlayer), 24 fps, cạnh ≤2000 px | Đổi cơ chế phát = sửa SSSplash |
| Ảnh Home `HomeScreen/photo.jpg`, `wallpaper.jpg` | export JPEG 0.85, ≤2000 px | `SCPHomeApply.m:158`, `SCPHomeWallView.m:115` | — |
| Video Home `HomeScreen/video.mp4` + `video.jpg` | export 1280×720/20 s | phía xe (HomeScreen) | — |

### 6.3 Nhóm [C] — tham số tại neo (tóm tắt; bảng đầy đủ ở Phần 4)

- **Màu:** accent lõi gradient `#9B87F8 → #5DB4F6`; hex qua `OMCColorFromHex` (61 giá trị phân biệt);
  102 literal RGBA; accent động Prefs light `#7B6CF6`/dark `#A89BFF`. Đổi tại literal hoặc gom về một bảng màu trung tâm (hiện chưa có — màu rải rác theo từng view).
- **Font:** 100% system font tại call site (~30 cặp size/weight; biến thể Rounded cho bubble/startup, monospacedDigit cho số Prefs). Không có font file.
- **Hình học:** hằng lặp 34 (nút/logo), 44 (vùng chạm tối thiểu), 52 (thanh bar/bubble), bo góc 24 cho panel/sheet, 20 glass, 7 knob — mỗi giá trị neo ở từng mục Phần 3/4.
- **Thời gian:** 14 duration UIView + ~10 duration CA phân biệt; các mốc thiết kế nhạy cảm: tự ẩn chrome (4,0 s —
  **[lưu ý: con số này thuộc cây tái tạo mô hình QA20, xem nhãn ở Phần 4]**), đóng picker 0,22 s, toast 2,6 s.
- **SF Symbols:** đổi tên symbol tại call site (danh sách đầy đủ ở Phần 2 mục G + Phần 1 mục hệ thống mượn):
  bộ `OMCIcon` 29×29 pt trong Prefs đọc tên từ plist `featureSymbol`; symbol trong code là literal tại chỗ.

### 6.4 Nhóm [D] — vẽ lại code (đặc tả đã chép đủ ở Phần 2)

- **Glyph engine 24×24** (`SCPDrawSymbolIcon` + bản sao AppBridgeB): 16 glyph đã chép đủ toạ độ vector —
  vẽ lại = thay bảng toạ độ hoặc thay engine; stroke chuẩn 1.8 (bản chính) / 1.5 (half-metric).
- **Logo mesh:** HAI công thức khác nhau đang tồn tại (Core 88×88 4 radial; Prefs 120×120 3 blob) —
  thiết kế mới phải chọn/thống nhất một bản.
- **SpeedBubble 9 style (0–8):** mỗi style là một hàm vẽ riêng (vòng cung 270°, gauge analog, sign, glass…) —
  đổi style = vẽ lại hàm; bảng 5 màu vòng tại `SPPGradientRing`.
- **StartupScreen 11 cảnh:** gradient theo hex từng cảnh + gauge RPM/SPEED + liquid + festive + HUD —
  mỗi cảnh là scene code riêng trong StartupScreen/Scenes*.
- **Bàn phím tự vẽ:** layout 44/43 phím là bảng hằng trong ABKeyboard* (rộng theo hệ số 1.4/1.1/4.2/1.8);
  hiện đang khoá cứng native theo lệnh Nguyen — mở lại phải qua cổng đã ghi ở Phần 5, thiết kế lại = thay bảng layout + bảng hint Telex.
- **Sheet/panel/picker:** hình học động theo công thức (sheet 542×242 là kết quả công thức trên khung 640×360,
  không phải hằng) — đổi tỉ lệ phải sửa công thức neo ở Picker.m, không sửa một con số duy nhất.

### 6.5 Nhóm [E] — mượn hệ thống

- **Icon app bên thứ ba** (picker, launcher, trang Apps): lấy qua API riêng
  `UIImage +_applicationIconImageForBundleIdentifier:format:scale:` — không có file để thay; chỉ đổi được
  format/scale/khung chứa tại `SCPShared.m:320` (xe) và `OMCIconSized` (Prefs, có fallback ô gradient+symbol).
- **Lưới Home CarPlay gốc + panel bố cục:** "lưới chọn app" là Home gốc của hệ thống, không phải lưới tự vẽ;
  phần tự sở hữu chỉ là panel bố cục và đường route khi chạm icon OmniCar.
- **Phím hệ thống (native):** không thuộc giao diện OmniCar — hiện là phím duy nhất đang dùng theo lệnh khoá.

### 6.6 Ba cảnh báo khi thiết kế lại (rút từ đối chiếu các luồng)

1. **Chrome có hai bản song sinh** (phía CarPlayApp `SCPCarSplit*` và mirror phía SpringBoard `ABHost*`):
   đổi một phía mà quên phía kia sẽ lệch hành vi chạm/hình — mọi thay đổi chrome phải áp cả hai neo.
2. **Vài "sự thật" thuộc cây tái tạo/hl, không phải gốc 1.0.3** — đã gắn nhãn `[CÂY-HL]`/`[tái tạo]` tại từng
   mục (điển hình: cổng hit-test khi mờ của hl6, hằng AutoHide 4,0 s, module SCPHomeLauncher do GPT thêm).
   Thiết kế trên gốc thì bỏ qua các nhãn này.
3. **Tên blur "style 11"** xuất hiện ở knob, mặt phím, splash: giá trị số 11 đã xác minh ở mọi nơi, tên
   `SystemUltraThinMaterialLight` là suy luận — khi vẽ lại, lấy số 11 làm chuẩn, đừng lấy tên.

---

## 7. Độ phủ, errata và khoảng trống chưa phục hồi

### 7.1 Verifier độc lập — phương pháp và kết quả

Một verifier độc lập (không tham gia 5 luồng kê) tự trích lại dữ kiện từ deb/source/binary và rà 5 phép:
(1) mọi file trong 176 file deb có được kê/phân loại không; (2) mọi tên ảnh/SF Symbol trong strings của
8 binary và trong source có mặt trong bản kê không; (3) đếm độc lập các call site vẽ
(CAGradientLayer 208, UIBezierPath 178, CAShapeLayer 160, UIVisualEffectView 41, systemImageNamed: 32, drawRect: 10);
(4) mọi class có tên dạng UI trong source có được kê không; (5) đếm lại số học cơ bản.
Kết luận: **độ phủ ≈ 90%** trước khi lấp khoảng trống; không mảng UI quyết định nào bị bỏ sót nguyên khối.
Báo cáo đầy đủ của verifier ở **Phụ lục B**; 13 mục lấp khoảng trống G1–G8 ở **Phụ lục A**.

### 7.2 Errata (hiệu đính sau verifier — số trong các phần tương ứng chưa sửa tại chỗ, đọc kèm mục này)

- **E1 (Phần 5):** phân rã Root.plist ghi "5 group + 9 hàng" là sai phép tách; đúng là **7 group + 8 hàng = 15**
  (tổng số bề mặt điều khiển vẫn đúng).
- **E2 (Phần 3):** tên symbol thời tiết ghi `cloud.bolt.fill` ở một chỗ; tên chuẩn theo Phần 1/2 là
  **`cloud.bolt.rain.fill`** — tên kia là biến thể INFERRED của bản Prefs (theo chính Phần 2).
- **E3 (Phần 4):** "61 hex phân biệt" — verifier đếm lại được **60**; lấy 60 làm chuẩn.

### 7.3 Khoảng trống CHƯA phục hồi (không suy diễn thêm — giữ nguyên nhãn)

Từ Phần 2 mục I và các luồng, các điểm sau chưa có đặc tả tới mức số liệu:

1. `SPPSignView -applyColors:/-setMuted:` và `SPPIconView -setShape:/-layoutSubviews` (SPPViews.m) — INFERRED;
   shadowOpacity=1 của SPPGlassView cũng INFERRED.
2. Slash trong `SPPBubble -setMenuButton:off:` — đã đào được path từ disasm nhưng lineWidth còn hai hằng
   ứng viên (2.4/5.4) theo cờ, nhánh màu stroke chưa chốt → PARTIAL.
3. `ss_drawParticles:` và `ss_drawFireworks:` — hai bản phục hồi (module StartupScreen và bản Prefs) mâu thuẫn
   nhau về blend mode/màu/layout record → chưa chốt bản nào đúng.
4. Welcome wave của splash: 11 điểm điều khiển + 2 vector cơ sở chưa chép toạ độ → PARTIAL.
5. `OMCHSPreview`: payload danh sách icon strip bên trái (hằng @0x294b0/@0x7f948) — UNRECOVERED.
6. Tile conic của `OMCAppBridgeAppsController`: thứ tự 5 bộ RGB từ constant pool — INFERRED;
   radius mask của SPPSetRing (=12) và hình học đường của SPPMapImage — INFERRED.
7. Prefs `SSStartupView`: nhiều builder chỉ đạt "VERIFIED thành phần, hình học INFERRED"; `ss_setGauge`
   bản Prefs khác bản StartupScreen đã VERIFIED; ivar `_wheels` không có thân vẽ ở cả hai bản.
8. Trang Onboarding: font/khoảng cách chi tiết — INFERRED trong source; wiring search bar trang Apps và
   hàng 6 section nền Home — INFERRED; tên key chính xác của vài hàng tile Speed Bubble — suy từ idiom
   (hành vi hàng đã VERIFIED).
9. Tên của blur style số 11 (khắp nơi: knob, mặt phím, splash) — giá trị số VERIFIED, tên
   `SystemUltraThinMaterialLight` là INFERRED.
10. Nội dung hình vẽ *bằng mắt* của 15 PNG tĩnh không thuộc phạm vi thống kê này — file gốc nằm ở `assets/`
    để mở xem trực tiếp.

### 7.4 Ghi chú phạm vi

- Module `SCPHomeLauncher` (icon Home/launcher) là phần GPT thêm ở các vòng hl, KHÔNG thuộc gốc 1.0.3 —
  vẫn được kê ở Phần 3 kèm nhãn, để không nhầm khi đối chiếu hành vi bản đang chạy trên xe.
- Hai dylib CarProbe và Core **không có bề mặt UI riêng** (CarProbe là bản sao OMCCommon nhúng tĩnh;
  Core là lõi chung) — kết luận có bằng chứng, không phải thiếu dữ kiện (Phụ lục A, mục G1).
- Các mục AutoHide thuộc cây tái tạo (mô hình theo QA20) đã gắn nhãn `[tái tạo]` ở Phần 4 — gồm cả
  hằng tự ẩn 4,0 s; bản gốc 1.0.3 có cơ chế ẩn chrome của riêng nó (timer bar 4,0 s ở Phần 3 là của gốc).

---

## Phụ lục A — Bản kê bổ sung (lấp khoảng trống G1–G8 của verifier)


Phạm vi: chỉ đọc. Nguồn: `payload/` (plist đọc bằng plistlib, kích
thước bằng `stat`), source phục hồi `src/`. Lấp G1–G8 của
`verifier-gaps.md`; G9–G11 không thuộc luồng này.
Đường tắt: `DL = payload/var/jb/Library/MobileSubstrate/DynamicLibraries/`,
`PB = payload/var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/`.
Mọi Filter dưới đây chỉ có khoá `Filter.Bundles` — không có
`Classes`/`Executables` trong cả 6 plist (plistlib, verified).

## G1. Sáu dylib + sáu filter plist

### OmniCarAppBridge.dylib + OmniCarAppBridge.plist
Loại: [tiêm] — dylib 613.376 B; plist 87 B
Đặc tả: Filter.Bundles = [`com.apple.UIKit`] → nạp vào mọi tiến trình
dùng UIKit (phía app được host). Vai trò UI: nửa phía-app của App
Bridge — host scene, bàn phím AB, chrome/knob phía app (strand2:
ABBoxView, ABKey, thanh bar AB; strand5: bàn phím).
Neo: `DL/OmniCarAppBridge.plist` (plistlib); `src/AppBridgeB/`
Điểm can thiệp: đổi Filter = đổi tập app được tiêm; UI sửa ở source module
Mức bằng chứng: verified-từ-file + verified-từ-source

### OmniCarCarProbe.dylib + OmniCarCarProbe.plist
Loại: [tiêm] — dylib 242.784 B; plist 92 B
Đặc tả: Filter.Bundles = [`com.apple.CarPlayApp`] → chỉ CarPlayApp.
Vai trò UI: KHÔNG có bề mặt UI riêng — là bản sao OMCCommon (prefs,
bản địa hoá, log, crash guard, probe hiệu năng CarPlay) tĩnh nhúng,
chỉ đóng dấu chẩn đoán khi nạp (xem `src/CarProbe/CarProbe_REPORT.md` §1).
Neo: `DL/OmniCarCarProbe.plist` (plistlib); `src/CarProbe/OmniCarCarProbe.m`
Điểm can thiệp: không có điểm can thiệp UI; chỉ liên quan chẩn đoán/log
Mức bằng chứng: verified-từ-file + verified-từ-source

### OmniCarCore.dylib + OmniCarCore.plist
Loại: [tiêm] — dylib 276.832 B; plist 93 B
Đặc tả: Filter.Bundles = [`com.apple.springboard`] → chỉ SpringBoard.
Vai trò UI: lõi chung OMCCommon ở phía SpringBoard (prefs, hạn dùng,
logo mesh dùng chung — strand2: OMCDrawLogoMesh/OMCLogoMeshImage
"bản Core (chuẩn)"); không tự vẽ chrome riêng.
Neo: `DL/OmniCarCore.plist` (plistlib); `src/OMCCommon/OmniCarCore.c`
Điểm can thiệp: token/logo dùng chung sửa ở đây lan sang mọi module
Mức bằng chứng: verified-từ-file + verified-từ-source

### OmniCarSpeedBubble.dylib + OmniCarSpeedBubble.plist
Loại: [tiêm] — dylib 649.808 B; plist 194 B (dài nhất, vì nhiều bundle)
Đặc tả: Filter.Bundles = [`com.apple.springboard`,
`com.apple.CarPlayApp`, `vn.vietmap.live`, `com.lumi.GOFA`,
`com.waze.iphone`, `com.wynauto.wyn`] → SpringBoard + CarPlayApp +
4 app dẫn đường nguồn tốc độ. Vai trò UI: bong bóng tốc độ trên xe
(strand2: SPPGlassView, SPPSignView, vòng gradient, số tốc độ).
Neo: `DL/OmniCarSpeedBubble.plist` (plistlib); `src/SpeedBubble/`
Điểm can thiệp: thêm/bớt bundle id nguồn tốc độ ở Filter này
Mức bằng chứng: verified-từ-file + verified-từ-source

### OmniCarSplitScreen.dylib + OmniCarSplitScreen.plist
Loại: [tiêm] — dylib 1.229.920 B (lớn nhất trong 6); plist 118 B
Đặc tả: Filter.Bundles = [`com.apple.CarPlayApp`,
`com.apple.springboard`]. Vai trò UI: toàn bộ chrome chia màn phía xe
— container/tab/pane/divider/knob/picker/ratio menu (strand2 + strand3;
hai class gốc xem G3, G4 dưới đây).
Neo: `DL/OmniCarSplitScreen.plist` (plistlib); `src/SplitScreenA|B|C/`
Điểm can thiệp: UI sửa ở source module; Filter quyết định 2 tiến trình chủ
Mức bằng chứng: verified-từ-file + verified-từ-source

### OmniCarStartupScreen.dylib + OmniCarStartupScreen.plist
Loại: [tiêm] — dylib 567.792 B; plist 118 B
Đặc tả: Filter.Bundles = [`com.apple.CarPlayApp`,
`com.apple.springboard`] (giống hệt SplitScreen). Vai trò UI: màn
chào/splash khi kết nối xe — các cảnh startup vẽ trên SSCanvasView
(strand2, strand5; class canvas xem G7).
Neo: `DL/OmniCarStartupScreen.plist` (plistlib); `src/StartupScreen/`
Điểm can thiệp: cảnh splash sửa ở source module / bản Prefs (G7)
Mức bằng chứng: verified-từ-file + verified-từ-source

Tổng G1: 6 dylib = 3.580.512 B. Chỉ SpeedBubble có Filter vượt ra
ngoài ba tiến trình hệ thống (thêm 4 app dẫn đường).

## G2. Ma trận bản địa hoá `.strings` (Prefs bundle)

### Ma trận 10 bảng × 14 ngôn ngữ
Loại: [bản địa hoá] — bề mặt chữ phải thiết kế/dịch lại
Đặc tả: 14 thư mục `PB/*.lproj`: ar, de, en, es, fr, id, it, ja, ko,
pt-BR, ru, th, vi, zh-Hans. Số key từng bảng (plistlib đếm trực tiếp):

| Bảng | en | vi | 12 ngôn ngữ còn lại |
|---|---|---|---|
| Localizable | 179 | 179 | 179 |
| Car | 122 | **vắng file** | 83 |
| StartupScreen | 92 | 92 | 61 |
| SpeedBubble | 76 | 76 | 76 |
| SplitScreen | 46 | 46 | 46 |
| HomeScreen | 43 | 43 | 43 |
| Onboarding | 18 | 18 | 18 |
| WhatsNew | 11 | 11 | 11 |
| AppBridge | 8 | 8 | 8 |
| Profiles | 7 | 7 | 7 |
| **Tổng** | **602** | **480** | **532 / ngôn ngữ** |

Neo: `PB/en.lproj/*.strings`, `PB/vi.lproj/*.strings` (9 file, thiếu
`Car.strings`), 12 thư mục còn lại (mỗi thư mục đủ 10 file)
Điểm can thiệp: thiết kế lại chữ = 10 bảng trên; vi muốn đủ bề mặt
phải bổ sung `Car.strings` (122 key theo en); 12 ngôn ngữ ngoài
en/vi đều thiếu so với en ở Car (−39) và StartupScreen (−31)
Mức bằng chứng: verified-từ-file (plistlib, tự đếm toàn bộ 139 file)

Tổng toàn cục: 139 file `.strings` = 14×10 − 1 (vi thiếu Car);
tổng key cộng dồn mọi ngôn ngữ = 7.466. Bảng lớn nhất là
`Localizable` (179 key) — bảng này chưa từng được nêu tên ở 5 luồng trước.

## G3–G5. Hai class container/chạm phía xe + symbol còn thiếu

### SCPCarTabView
Loại: [vẽ-code] — UIView, dải tab phía xe (SplitScreen)
Đặc tả: không ivar riêng (instance_size 8), không tự vẽ trong source
phục hồi — hành vi duy nhất là nới vùng chạm: `pointInside:withEvent:`
trả `CGRectContainsPoint(CGRectInset(bounds, −18, −14), point)`, tức
chấp nhận chạm vượt bounds 18 pt mỗi phía ngang và 14 pt mỗi phía
dọc. Quan hệ: là view tab trong cây chia màn mà `SCPCarSplit.tabParent`
là cha neo layout (dashboard baseContainerView.superview).
Neo: `src/SplitScreenB/SCPCarTabView.h/.m`; disasm @0xf334
Điểm can thiệp: sửa hằng −18/−14 tại `pointInside:` để chỉnh độ dễ chạm tab
Mức bằng chứng: verified-từ-source (header ghi VERIFIED @0xf334)

### SCPCarSplitView
Loại: [vẽ-code] — UIView, container gốc của layout chia màn
Đặc tả: property duy nhất của `SCPCarSplit` kiểu này là `container`
(ivar `_container` @144); được tạo với frame = `parent.bounds`,
`backgroundColor = black`, `clipsToBounds = YES`, gắn vào cha lấy từ
dashboard root. Một ivar duy nhất `_touched` @8 (copy block
`(CGPoint, UIView*)`). `hitTest:withEvent:` gọi super, rồi — khi hit
≠ nil, block đã cài, `event.type == UIEventTypeTouches (0)` — gọi
`touched(point, hitView)` và trả hit nguyên vẹn (không nuốt/đổi chạm).
Block do controller cài: `hideBarsForTouchOn:` vô điều kiện, bỏ qua
khi chạm trong float pane đang hiện, còn lại quét `slots`: pane nào
chứa điểm thì đặt `focusedSlot`, và chỉ khi đổi focus + ≥2 pane mới
lên lịch `flashFocusOnPane:` (dispatch delay 0). Mọi pane/divider/
picker của layout đều sống dưới container này.
Neo: `src/SplitScreenB/SCPCarSplitView.h/.m` (@0xe88c);
`src/SplitScreenA/SCPCarSplit.m:337,352` (tạo view + cài block)
Điểm can thiệp: điểm quan sát chạm gốc của chia màn là block `touched` này
Mức bằng chứng: verified-từ-source (header ghi VERIFIED @0xe88c;
phần feed autohide trong cùng `.m` là lớp thêm của bản phục hồi, không phải gốc)

### hand.tap.fill
Loại: [symbol] — SF Symbol, icon hàng "Gestures" trang Split Screen (Prefs)
Đặc tả: `OMCIcon(@"hand.tap.fill", #5AB8FF)` cho hàng có nhãn
`L(@"SPLITSCREEN_GESTURES")`, accessory là UISwitch (tag 1,
`showGestures`, action `gestureSwitchChanged:`). Qua `OMCIcon` nên
cấu hình chung: symbol 14 pt, weight Semibold, tint trắng, vẽ giữa
tile gradient 29×29 bo góc 8,5; `#5AB8FF` rơi vào họ xanh dương nên
gradient tile = `#5AB8FF → #8FD3FF`. Không có cấu hình size/weight
riêng cho hàng này.
Neo: `src/Prefs/OMCPrefs/OMCSplitScreenController.m:324`;
`OMCIcon` tại `src/Prefs/OMCPrefs/OMCCommon.m:480`
Điểm can thiệp: đổi tên symbol/màu hex tại dòng 324
Mức bằng chứng: verified-từ-source

## G6–G8. Nền vẽ, canvas Prefs, cell còn thiếu

### UIBezierPath + CGContext (nền vẽ của luồng 2)
Loại: [vẽ-code] — ghi chú thuật ngữ nền, không phải phần tử riêng
Đặc tả: mọi mục vẽ của strand2 (glyph, mask, ring, chip, panel…)
đứng trên hai API này: `UIBezierPath` 178 lần / 26 file `.m`/`.h`
(path: rect/roundedRect/oval/arc, `.CGPath` nạp cho CAShapeLayer,
`fill`/`addClip`) và `CGContext` 92 lần / 12 file (CTM scale/rotate,
Save/RestoreGState, gradient, context của UIGraphicsImageRenderer).
Neo tiêu biểu: `src/SplitScreenB/SCPCTouchWatch.m:55` (path rect +
append lỗ — mask của strand2); `src/SplitScreenB/SCPCarSplit+RatioMenu.m:39-43`
(CGContext + ScaleCTM theo lưới 24); `src/Prefs/OMCPrefs/OMCCommon.m:496`
(clip bezier của OMCIcon); `src/AppBridgeB/ABKeyboard.m:574`
(roundedRect path → CAShapeLayer của phím AB)
Điểm can thiệp: thiết kế lại hình học vẽ = sửa path/context tại các neo trên
Mức bằng chứng: verified-từ-source (tự grep lại: 178/26 và 92/12, khớp verifier)

### SSCanvasView (bản Prefs)
Loại: [vẽ-code] — UIView trong suốt, bề mặt vẽ của preview Startup (Prefs)
Đặc tả: một property `owner` weak trỏ `SSStartupView`
(objc_storeWeak). `drawRect:` bỏ qua rect, chuyển tiếp nguyên vẹn:
`[owner ss_drawCanvas:UIGraphicsGetCurrentContext() size:bounds.size]`.
Chủ tạo nó qua `ss_addCanvas`: frame = bounds của SSStartupView,
`opaque = NO`, nền clear, `userInteractionEnabled = NO`,
`contentScaleFactor = 1`, `contentMode = Redraw`. Nội dung cảnh
(particles/fireworks theo sceneStyle…) do `ss_drawCanvas:size:` của
owner vẽ — đã kê ở strand2; mục này chỉ bổ sung class chủ + cơ chế
chuyển tiếp. (Có class cùng tên ở phía xe trong
`src/StartupScreen/SSStartupView.m:141`, cùng mẫu weak-owner.)
Neo: `src/Prefs/OMCPrefs/SSCanvasView.h/.m` (VERIFIED 0x461c0);
`src/Prefs/OMCPrefs/SSStartupView.m:809,1454`
Điểm can thiệp: bề mặt preview đổi ở `ss_drawCanvas:` của owner, không ở class này
Mức bằng chứng: verified-từ-source

### OMCSplitScreenAppLinkCell
Loại: [prefs-cell] — PSTableCell subclass, cell thứ ba trong OMCCells
Đặc tả: không ivar; 2 method như hai cell anh em. Ép
`UITableViewCellStyleValue1` khi init (để có detailTextLabel).
`refreshCellContentsWithSpecifier:`: lấy tên khoá từ property `key`
của specifier → đọc bundle id trong prefs `com.anlai.omnicar`
(CFPreferences) → hiện tên app bản địa hoá qua
`LSApplicationProxy applicationProxyForIdentifier:` +
`localizedName` (rơi về chính bundle id nếu không có tên); chưa đặt
thì hiện `L(@"SPLITSCREEN_APP_NOT_SET")`; accessory luôn
DisclosureIndicator. Đối chiếu anh em (đã kê ở strand5): 
`OMCFeatureStatusCell` hiện On/Off theo `featureKey`/`featureDefault`;
`OMCAppBridgeAppsLinkCell` hiện số app đã chọn của khoá `appBridgeApps`;
cell này khác ở chỗ giá trị là MỘT bundle id lấy theo khoá động của specifier.
Neo: `src/Prefs/OMCPrefs/OMCCells.h`; `OMCCells.m:69-96`
Điểm can thiệp: cách hiện tên app của hàng giá trị-app trong trang Split Screen prefs
Mức bằng chứng: verified-từ-source

---

## Phụ lục B — Báo cáo verifier độc lập (nguyên văn)


Vai trò: verifier chỉ đọc, độc lập với 5 bản kê nháp (`strand1-assets.md`,
`strand2-drawing.md`, `strand3-chrome.md`, `strand4-tokens.md`,
`strand5-keyboard-prefs.md`). Không sửa bản kê, không chạy binary.
Nguồn đối chiếu tự trích lại từ: `deb-files.txt` (176 file),
`inventory/manifest.tsv` (177 dòng dữ liệu, gồm `DEBIAN/control` ngoài
176), `coverage/strings-*.txt` (8 file), `payload/` (đọc plist bằng
plistlib), `src/` (207 file `.m`/`.h`).

Kiểm chứng bản trích strings: tự chạy `strings -a` lại trên
`payload/var/jb/Applications/OmniCar.app/OmniCar` → 748 dòng, tập chuỗi
khớp 100% với `coverage/strings-OmniCar.txt` (748 dòng). Bản trích dùng
được.

---

## PHÉP RÀ 1 — FILE DEB (176 file)

**Phương pháp:** đếm họ đuôi từ `deb-files.txt`; kiểm từng basename (và
stem) có xuất hiện nguyên văn trong hợp nhất 5 bản kê không; đối chiếu
plist bằng plistlib trên `payload/`.

**Số đếm nền (khớp strand1):** `.strings` ×139, `.png` ×15, `.plist`
×14, `.dylib` ×6, không đuôi ×2 = 176. Strand1 phân loại đúng 100% ở
mức họ đuôi.

**Theo từng file:**

| Nhóm | Tổng | Kê từng tên | Kết quả |
|---|---|---|---|
| PNG | 15 | 15/15 | Đủ tuyệt đối: AppIcon60x60@2x/@3x, PackageIcon, icon×3, logo×3, SpeedBubbleIcon×3, StartupScreenIcon×3 — mỗi file có mục riêng ở strand1 §A |
| Plist UI (Prefs/App) | 8 | 8/8 | Root.plist, FeatureSpeedBubble/SplitScreen/StartupScreen.plist, WhatsNew.plist, Info.plist ×2 (app + prefs bundle), PreferenceLoader `OmniCarPrefs.plist` — đều được nhắc và dump nội dung ở strand1/strand5 |
| Plist lọc tiêm (MobileSubstrate) | 6 | **0/6** | `OmniCarAppBridge/CarProbe/Core/SpeedBubble/SplitScreen/StartupScreen.plist` — KHÔNG tên nào xuất hiện trong bất kỳ bản kê nào (cả basename lẫn stem). Nội dung thật (đã tự đọc): Filter Bundles = UIKit / com.apple.CarPlayApp / com.apple.springboard; riêng SpeedBubble lọc thêm 4 app dẫn đường (vn.vietmap.live, com.lumi.GOFA, com.waze.iphone, com.wynauto.wyn). Phán: không phải tài sản hình ảnh, nhưng quyết định UI sống ở tiến trình nào — liên quan UI gián tiếp |
| Dylib | 6 | **0/6 theo tên file** | `OmniCarAppBridge.dylib` … `OmniCarStartupScreen.dylib` — không filename nào xuất hiện nguyên văn; các module được kê theo tên source (`AppBridgeB`, `SplitScreenB`…) chứ không theo tên file deb. Phán: phủ chức năng có, phủ tên file không |
| Mach-O không đuôi | 2 | 2/2 | `OmniCar` (app, strand5 §4) và `OmniCarPrefs` (bundle principal class, strand5 §2) đều được nhắc |
| `.strings` | 139 | **0/139 theo tên file** | Xem chi tiết dưới |

**Chi tiết `.strings`:** 139 = 14 ngôn ngữ × 10 bảng − 1 (vi thiếu
`Car.strings` — strand5 có ghi chú vi thiếu key của Car, nhưng không
bảng kê nào liệt kê ma trận ngôn ngữ × bảng). Kiểm stem từng bảng trong
5 bản kê: 9/10 bảng xuất hiện dưới dạng từ thường (AppBridge, Car,
HomeScreen, Onboarding, Profiles, SpeedBubble, SplitScreen,
StartupScreen, WhatsNew — đều là tên tính năng/controller, không phải
tên file `.strings`); **`Localizable` xuất hiện 0 lần trong cả 5 bản
kê** — trong khi đây là bảng lớn nhất (179 key ở en, tự đếm bằng
plistlib). Chỉ 2/14 ngôn ngữ được đọc thật: en (602 key) + vi (480
key) theo strand5; 12 ngôn ngữ còn lại (ar, de, es, fr, id, it, ja, ko,
pt-BR, ru, th, zh-Hans) không được liệt kê ở đâu — bản kê chỉ nói "14
ngôn ngữ" mà không kê danh sách.

## PHÉP RÀ 2 — TÊN ẢNH / SYMBOL TRONG BINARY

**Phương pháp:** (a) trích từ hợp nhất `strings-*.txt` (7.738 chuỗi duy
nhất) mọi chuỗi có đuôi `.png/.jpg/.jpeg/.pdf/.gif/.svg/.car` hoặc đường
dẫn chứa Icon/Logo/Home/Startup; (b) grep source `.m`/`.h` cho
`systemImageNamed:` (tách literal vs động), cộng mọi literal dạng tên
symbol trong source và mọi chuỗi SF-like trong binary; kiểm từng tên
trong 5 bản kê.

**(a) Tên ảnh: 8/8 — KHÔNG THIẾU.** Toàn bộ chuỗi ảnh trong binary chỉ
có 8: `%05lu.jpg`, `00000.jpg`, `…/PackageIcon.png`,
`…/logo@3x.png`, `/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png`,
`HomeScreen/photo.jpg`, `HomeScreen/video.jpg`,
`HomeScreen/wallpaper.jpg` — cả 8 đều có trong strand1 (mục B). Không
có chuỗi `.pdf/.gif/.svg/.car` dạng asset nào. Khẳng định âm tính của
strand1 (không chuỗi `SpeedBubbleIcon`/`StartupScreenIcon` trong 8
binary) đã tự kiểm lại: đúng.

**(b) SF Symbol: thiếu đúng 1 tên.**
- `systemImageNamed:` trong source: **32 call site** (khớp tuyệt đối
  con số strand2 §G công bố), trong đó 17 literal / 15 động, 12 tên
  literal duy nhất — 12/12 có trong bản kê.
- Literal dạng dotted trong source: 84 chuỗi; loại bundle-id /
  entitlement / khoá animation (`com.apple.*`, `transform.*`,
  `icon.application` = khoá KVC trong diag dump…) còn lại là symbol.
- Chuỗi SF-like trong binary: 63 ứng viên (trừ nhiễu `an.7`,
  `kern.osversion`, `tyz.k`) — 62/63 có trong bản kê.
- **Tên duy nhất thiếu: `hand.tap.fill`** — icon của hàng "Gestures on
  the car" (`OMCIcon(@"hand.tap.fill", #5AB8FF)` trong
  `src/Prefs/OMCPrefs/OMCSplitScreenController.m`). Strand5 kê hàng
  Gestures nhưng không ghi symbol của nó. Các bảng symbol lớn (thời
  tiết 12 tên, đèn cảnh báo, glyph theo style splash, symbol trong
  plist Root/Feature/WhatsNew) đều đủ.

## PHÉP RÀ 3 — HÀM VẼ TRONG SOURCE

**Phương pháp:** đếm occurrence độc lập trên 207 file `.m`/`.h`, đối
chiếu số lần bản kê nhắc tên mẫu.

| Mẫu | Source (lần / file) | Nhắc trong bản kê | Phán |
|---|---|---|---|
| `CAGradientLayer` | 208 / 29 | strand2 ×9, strand4 ×1 + bảng token | Đúng thứ hạng cao nhất; phủ tốt ở mức phần tử + token |
| `UIBezierPath` | 178 / 26 | **0 lần trong cả 5 bản kê** | Mẫu lớn thứ 2 mà không được nêu tên lần nào (xem G6) |
| `CAShapeLayer` | 160 / 22 | strand2 ×13, strand3 ×1, strand5 ×1 | Phủ tốt (mask, ring, slash, ticks…) |
| `UIVisualEffectView` | 41 / 16 | strand2 ×2, strand5 ×3 (+ strand3/5 mô tả sheet/effect nhiều chỗ không nêu tên class) | Phủ đạt; vật che picker đã kết án đúng |
| `systemImageNamed:` | 32 / 18 | strand2 công bố đúng tổng 32 | Khớp tuyệt đối |
| `drawRect:` | 10 / 6 | strand2 §F kê 2 họ chính (OMCSplitPreview, OMCHSPreview) + cảnh canvas | Còn `SSCanvasView -drawRect:` (xem G7); `SSStartupView` vẽ qua canvas nên đã phủ theo nội dung |

Bổ sung tự đếm: `CGContext` 92 lần / `UIGraphicsImageRenderer` 90 lần
trong source — `CGContext` cũng 0 lần được nêu tên trong bản kê
(strand2 dùng thuật ngữ "draw-immediate"; chữ "bezier" thường xuất
hiện đúng 1 lần). Hình học glyph/path bản thân được kê rất kỹ (mục C
của strand2, lưới 24×24 từng glyph) — khoảng trống ở đây là *tên API*,
không phải nội dung vẽ.

## PHÉP RÀ 4 — LỚP UI CHƯA KÊ

**Phương pháp:** trích mọi tên khớp mẫu
View/Button/Bar/Cell/Panel/Keyboard/Bubble/Splash/HUD/Toast/Chip/Glyph/
Preview/Header/Card/Shield/Popup/Menu/Knob/Handle từ tên file `.h`/`.m`
và `@interface` trong `src/` → 39 tên; kiểm từng tên trong 5 bản kê:
**31 có mặt, 8 vắng mặt hoàn toàn.**

8 tên vắng mặt, đã đọc source từng cái để phán thật/giả:

| Tên | Nguồn | Phán |
|---|---|---|
| `SCPCarTabView` | `SplitScreenB/SCPCarTabView.h/.m` | **THẬT** — view dải tab, `pointInside:` nới vùng chạm −18 pt ngang / −14 pt dọc mỗi phía (@0xf334). Đặc tả hình học chạm cụ thể, không bản kê nào có |
| `SCPCarSplitView` | `SplitScreenB/SCPCarSplitView.h/.m` | **THẬT** — view container gốc của toàn bộ layout chia màn (`SCPCarSplit.container`), `hitTest:` + block `touched` (@0xe88c). Bản kê nói "container/tabParent" chung chung, không nêu class và cơ chế touched |
| `SSCanvasView` | `Prefs/OMCPrefs/SSCanvasView.h/.m` | **THẬT (nhẹ)** — view canvas mà `drawRect:` của nó chuyển cho `ss_drawCanvas:` — bề mặt vẽ của mọi cảnh Startup bản Prefs. Nội dung cảnh đã kê, class chủ không |
| `OMCSplitScreenAppLinkCell` | `Prefs/OMCPrefs/OMCCells.h` | **THẬT (nhẹ)** — 1 trong 3 PSTableCell subclass (hiện tên app của hàng giá trị-app, vd hàng ô ghim). Hai cell anh em (`OMCFeatureStatusCell`, `OMCAppBridgeAppsLinkCell`) đều được strand5 nêu tên, cell này thì không |
| `ABKeyboardDecl` | `AppBridgeB/ABKeyboardDecl.h` | GIẢ — chỉ là header khai báo trùng của `ABKeyboard` (đã kê kỹ); không phải class riêng |
| `OMCCells` | tên file `OMCCells.h/.m` | GIẢ — là file gom 3 cell, không phải class |
| `DBApplicationSceneViewController`, `DBDashboardRootViewController` | `SplitScreenA/SCPShared.h` | GIẢ (với tư cách class của OmniCar) — class framework CarPlay của Apple, source tự ghi chú "CarPlay framework"; bản kê đã kê cơ chế host/dashboard quanh chúng |

## PHÉP RÀ 5 — SỐ HỌC CƠ BẢN (tự đếm lại)

| Con số trong bản kê | Tự đếm lại | Kết quả |
|---|---|---|
| PNG: 15 file, tổng 279.667 B; từng nhóm 69.129 / 74.767 / 25.437 / 85.962 / 14.743 / 9.629 B (strand1) | manifest.tsv: 15 PNG, tổng đúng 279.667 B; từng nhóm khớp từng byte | **KHỚP tuyệt đối** (kể cả tổng payload 5.909.467 B = manifest 5.911.399 − 1.932 B của DEBIAN/control; tỉ lệ 4,7% đúng) |
| `.strings` en 602 key / vi 480 key (strand5) | plistlib trên payload: en = 8+122+43+179+18+7+76+46+92+11 = 602; vi = 480 (thiếu Car 122) | **KHỚP tuyệt đối** |
| `systemImageNamed:` tổng 32 call site (strand2) | grep source: 32 | **KHỚP tuyệt đối** |
| Symbol thời tiết: 12 tên (strand1 & strand2) | liệt kê lại từ hai bản: 12 tên, trùng nhau | KHỚP giữa strand1↔strand2 (nhưng strand3 lệch — xem G10) |
| Root.plist: 15 item (strand5) | plistlib: 15 item | Tổng KHỚP; **phân rã LỆCH** — strand5 viết "5 group + 9 hàng", thực tế 7 PSGroupCell + 8 hàng (5+9=14≠15) — xem G9 |
| Startup plist: 44 item = 11 group + 33 hàng (strand5) | plistlib: 44 item, PSGroupCell ×11, còn lại 33 | **KHỚP** |
| Bàn phím: 44 phím chữ / 43 phím số (strand5) | cộng từng hàng: chữ 10+10+9+9+6=44; số 10+10+10+7+6=43 | **KHỚP** |
| Strand4: 442 dòng `colorWithRed:/White:/Hue:`; whiteColor 94, blackColor 39, clearColor 35, secondaryLabelColor 30, labelColor 17, tertiaryLabelColor 7, systemGreenColor 4; 14 giá trị `animateWithDuration:`; `fontWithName:` 0 | grep lại toàn bộ: 442; 94/39/35/30/17/7/4; đúng 14 giá trị phân biệt; 0 | **KHỚP tuyệt đối** — riêng "61 hex phân biệt" tự đếm được 60 (lệch 1, xem G11) |

---

## DANH SÁCH KHOẢNG TRỐNG (đánh số)

- **G1 [TRUNG] — 12 file tiêm không được kê từng tên.** 6 dylib
  (`OmniCarAppBridge.dylib`, `OmniCarCarProbe.dylib`,
  `OmniCarCore.dylib`, `OmniCarSpeedBubble.dylib`,
  `OmniCarSplitScreen.dylib`, `OmniCarStartupScreen.dylib`) và 6 plist
  lọc cùng tên trong `Library/MobileSubstrate/DynamicLibraries/` không
  xuất hiện nguyên văn trong bất kỳ bản kê nào; bản kê chỉ có số đếm
  theo họ (×6/×14) và tên module source. Thiếu luôn nội dung Filter
  (tiến trình đích của từng module; filter SpeedBubble gồm cả 4 app
  dẫn đường). Nguồn: `deb-files.txt` + `payload/…/DynamicLibraries/*.plist`.
- **G2 [TRUNG] — Kiểm kê `.strings` dừng ở mức tổng, thiếu ma trận
  file/bảng/ngôn ngữ.** 139 file không được liệt kê; `Localizable.strings`
  (bảng lớn nhất, 179 key en) không được nêu tên lần nào trong 5 bản
  kê; 12/14 ngôn ngữ (ar, de, es, fr, id, it, ja, ko, pt-BR, ru, th,
  zh-Hans) không có danh sách; không có phân rã 10 bảng × ngôn ngữ
  (kể cả việc vi thiếu hẳn `Car.strings` chỉ được suy ra từ ghi chú
  thiếu key). Nguồn: `payload/…/OmniCarPrefs.bundle/*.lproj/` (tự đếm:
  14 thư mục, 10 bảng, vi chỉ 9).
- **G3 [TRUNG] — `SCPCarTabView` vắng mặt hoàn toàn.** View dải tab
  phía xe với vùng chạm nới −18 pt (ngang) / −14 pt (dọc) mỗi phía —
  một đặc tả hình học chạm cụ thể không có ở bất kỳ bản kê nào.
  Nguồn: `src/SplitScreenB/SCPCarTabView.m` (@0xf334).
- **G4 [TRUNG] — `SCPCarSplitView` vắng mặt hoàn toàn.** Class view
  container gốc của toàn bộ chrome chia màn (property `container` của
  `SCPCarSplit`), với `hitTest:` chuyển tiếp + block `touched` — cơ
  chế quan sát chạm ở gốc cây view. Bản kê dùng danh từ chung
  "container/tabParent" thay cho class này. Nguồn:
  `src/SplitScreenB/SCPCarSplitView.h/.m` (@0xe88c).
- **G5 [THẤP] — Thiếu SF Symbol `hand.tap.fill`.** Icon hàng Gestures
  trong trang Split Screen (`OMCSplitScreenController.m`, qua OMCIcon,
  màu #5AB8FF). Đây là tên symbol duy nhất trong binary/source vắng
  mặt trong bản kê (62/63 tên SF-like trong binary đã đủ). Strand5 kê
  hàng Gestures nhưng bỏ tên symbol.
- **G6 [THẤP] — `UIBezierPath` (và `CGContext`) không được nêu tên.**
  `UIBezierPath`: 178 lần / 26 file — API vẽ lớn thứ hai của dự án —
  xuất hiện 0 lần trong cả 5 bản kê; `CGContext`: 92 lần, cũng 0 lần.
  Nội dung path/glyph đã kê đủ ở strand2 nên đây là khoảng trống truy
  vết/thuật ngữ cho người thiết kế lại, không phải thiếu nội dung vẽ.
- **G7 [THẤP] — `SSCanvasView` không được kê.** View chủ của bề mặt vẽ
  tức thời bản Prefs (drawRect: → `ss_drawCanvas:`); các cảnh vẽ trên
  nó đã được strand2 kê, nhưng class + cơ chế chuyển tiếp thì không.
  Nguồn: `src/Prefs/OMCPrefs/SSCanvasView.m`.
- **G8 [THẤP] — `OMCSplitScreenAppLinkCell` không được kê.** Cell thứ
  ba trong `OMCCells.h` (hiện tên app đã lưu cho hàng kiểu app); hai
  cell cùng file đều được strand5 nêu tên. Nguồn:
  `src/Prefs/OMCPrefs/OMCCells.h`.
- **G9 [THẤP] — Phân rã số học Root.plist trong strand5 sai.** Strand5
  viết "15 item = 5 group + 9 hàng thao tác cố định" (= 14); đếm lại
  bằng plistlib: 7 PSGroupCell + 4 PSButtonCell + 3 PSLinkCell + 1
  PSStaticTextCell = 15 (tức 7 ô group + 8 hàng). Tổng 15 đúng, phân
  rã sai cả hai số hạng. (Con số "Root 12" ở mục tổng kết strand5 —
  8 hàng cố định + 3 feature + 1 master switch — lại tự khớp.)
- **G10 [THẤP] — Lệch tên symbol thời tiết giữa các bản kê.** Strand3
  §6 ghi symbol giông là `cloud.bolt.fill`; strand1 + strand2 ghi
  `cloud.bolt.rain.fill` (và strand2 tự chú thích `cloud.bolt.fill` là
  tên ở bảng INFERRED của bản Prefs). Người đọc chỉ strand3 sẽ dùng
  sai tên.
- **G11 [THẤP] — Strand4 lệch 1 ở "61 hex phân biệt".** Grep lại đúng
  phương pháp strand4 công bố (.m/.h, `#[0-9A-Fa-f]{6}`) cho 60 giá
  trị phân biệt (115 lần). Mọi con số đếm khác của strand4 đều khớp
  tuyệt đối (xem phép rà 5) nên đây là lệch đơn lẻ, không hệ thống.

**Đã rà và kết luận KHÔNG phải khoảng trống:** `ABKeyboardDecl`
(header khai báo trùng), `OMCCells` (tên file), hai class
`DBApplicationSceneViewController`/`DBDashboardRootViewController`
(class Apple), `icon.application`/`transform.translation.x|y` (không
phải SF Symbol), khẳng định "không có JPG/PDF/.car/GIF/SVG trong deb"
của strand1 (đúng theo họ đuôi + chuỗi binary).

## KẾT LUẬN ĐỘ PHỦ

- Ảnh tĩnh + ảnh runtime: **100%** (15/15 PNG từng file, 8/8 chuỗi ảnh
  binary, đủ đường dẫn runtime).
- SF Symbol: **~98%** (62/63 tên trong binary; 12/12 tên literal của
  `systemImageNamed:`; thiếu duy nhất `hand.tap.fill`).
- Vẽ bằng code + token: nội dung **~95%** (hình học/màu/font/animation
  được kiểm chứng số học gần như tuyệt đối); trừ thuật ngữ
  `UIBezierPath`/`CGContext` không được nêu tên.
- Class UI: 31/35 class thật được nêu tên (**~89%**); 2 class vắng
  mặt đáng kể đều ở tầng container/chạm phía xe (G3, G4).
- File deb ở mức từng tên: họ đuôi 176/176, nhưng từng file chỉ đạt
  cao ở PNG/plist-UI; dylib + filter plist 0/12 và `.strings` 0/139
  theo tên (G1, G2).

**Độ phủ tổng thể ước tính: ≈ 90%** (khoảng 88–92%). Phần thiếu tập
trung ở hai mảng: (1) kê từng tên file ở tầng tiêm + bản địa hoá
(G1, G2 — mức trung bình), và (2) hai class container/chạm phía xe
(G3, G4 — mức trung bình). Không phát hiện khoảng trống mức CAO:
không có tài sản ảnh, symbol (trừ 1), hàng prefs hay cơ chế vẽ nào
mang tính quyết định thiết kế bị bỏ sót nguyên khối.
