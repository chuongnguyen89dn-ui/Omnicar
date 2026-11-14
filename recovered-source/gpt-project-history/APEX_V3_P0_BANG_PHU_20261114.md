# DUOCAR V3 — P0: BẢNG PHỦ 100% + ĐỐI CHIẾU + BACKLOG (Muse, 2026-11-14)

Nguồn lệnh: chỉ đạo V3 của Nguyen (#6876443778) + giao việc GPT (#6876562736). Phạm vi: chỉ kiểm kê, không sửa runtime, không thiết kế. Cây: nhánh `feature/duocar-apex-ui-muse-20261114`, source runtime `3107d0e` (docs HEAD `88cea15`), đối chiếu `project/` (build thật) và gương `src/`. Phương pháp 3 lớp: quét tĩnh toàn bộ target thật sự build; truy call chain/view/layer tại từng điểm render; đối chiếu DEB APEX1 + trạng thái thiết bị đã biết. Tổng số dòng kiểm kê: **112** (A:30 · B-native:20 · B-hosted:4 · D-bàn phím:5 · C-app:17 · P-prefs:8 · S-startup:5 · H-HUD:4 · E-cờ:19).

## 0. TRẢ LỜI THẲNG: VÌ SAO APEX1 VẪN GIỐNG OMNICAR (từ source, không đoán)

1. **Thiết bị chưa từng chạy binary APEX trong lần giao đầu.** Gói `com.anlai.omnicar 1.0.3-apex1` cài thành app riêng; bản DuoCar đang chạy trên máy không bị thay (ảnh máy: app DuoCar vẫn 3 tab cũ). Mọi marker APEX trong file đều đúng nhưng không chứng minh được máy đã nạp — thiếu đối chiếu installed/PID (lỗi phương pháp của Muse, đã ghi nhận tại #6876588469).
2. **Toàn bộ lớp brand hiển thị nằm ngoài mọi lô APEX đã làm.** Tên app trong Info.plist, câu xin quyền Photos, metadata gói, nhãn PreferenceLoader, thẻ header prefs (tên "OmniCar" + version cứng "1.0.3"), tiêu đề Root.plist, tiêu đề alert ở cả hai phía, 5 chữ fallback trên scene khởi động xe, banner cứu hộ, và **99/139 file `.strings` của prefs (16 locale)** còn nguyên tên OmniCar trong giá trị hiển thị. Lô APEX chỉ thay 15 bitmap — và cả 15 bitmap đó đã xác nhận là artwork mới (xem trực tiếp), nên phần "nhìn là OmniCar" còn lại nằm ở CHỮ và BỀ MẶT, không nằm ở logo bitmap.
3. **Vật liệu mặt chung phía xe vẫn là kính SÁNG.** `SCPKnobFaceView()` (SCPCarDividerView.m:99–107) = blur Light style 11, fallback Lite = trắng 0.92 — là factory dùng chung cho bar, panel, picker, ratio menu, knob. Các lô APEX phủ ảnh graphite VÀO TRONG contentView của lớp blur sáng đó (SCPApplyMeshBackdrop chỉ có đúng 3 caller: style ratio menu/bar, panel, mặt picker nhánh original) chứ không thay vật liệu. Mặt picker trong pane mặc định là **lavender đặc (0.933,0.941,0.984)** và chỉ biến mất nhờ các nhánh clear HL46/HL48/HL49 (mặc định YES).
4. **Picker phía xe giữ nguyên bộ khung gốc:** nhánh mặc định HL51 (`duocarHL51RestoreOriginalMenuWindow=YES`) đưa sheet về cửa sổ menu gốc + mặt original; separator gradient + chữ title + tint chip còn **navy (0.290,0.310,0.502)**; shadow panel và shadow icon app còn **tím (0.431,0.392,0.784)**; wrapper xem trước còn trắng 0.35/viền trắng 0.7.
5. **Tay nắm 3 chấm còn nguyên ở cả hai phía:** native pill 34×12 nền trắng 0.35 (chỉ chấm đã đổi màu graphite — Chrome.m:184–202); hosted pill tương tự trong hit area 44×24 (ABHostBMethods.m:1341–1369). Chưa lô nào thay HÌNH THỨC tay nắm.
6. **Glyph phía hosted dùng cơ chế vẽ gốc chưa lô nào đụng** — xem mục 3: đây là nguyên nhân trực tiếp của icon hosted đen.
7. **Hai điểm màu runtime của bàn phím vẽ sót ngoài lô D13:** màu chữ preview bị ghi đè mỗi lần gõ về hằng số tối gốc (0.16,0.24,0.0625) trên field tối (ABKeyboard.m:465–474) và nhãn hint Telex màu slate gốc (:642–645).
8. **Palette mesh gốc còn nguyên nhưng ĐANG NGỦ:** `OMCLogoMeshImage` trong lõi C (OMCCommon.c:1633–1667) giữ palette lavender/hồng cũ; không còn caller sống trong 7 module build — caller duy nhất là module SpeedBubble đã loại khỏi build. Lộ diện ngay nếu V3 kích hoạt lại SpeedBubble.

## 1. KIỂM ĐỘC LẬP DEB APEX1 (theo điểm 3 của GPT)

- File `com.anlai.omnicar_1.0.3-apex1_iphoneos-arm64.deb`: SHA-256 `ccdc581fcd1f787450e3a0983a7497b98c71bd2daa894b36a84ed87ab7b4b670`, 891.420 byte, nén xz cả control/data (đã kiểm `file`/`ar t`), control: Package `com.anlai.omnicar`, Version `1.0.3-apex1`, Architecture `iphoneos-arm64`, 371 file.
- Binary nhúng: app chứa đủ marker APEX (chuỗi UTF-16LE "Bảng điều khiển"/"Minh họa"/"Thiết bị", `tabs=5`, selector `omcPinnedCaptionText`); 3 binary chính khớp md5 cây staging đóng gói; icon APEX trong app khớp md5 asset nguồn `7f262bbd…`.
- Kết luận trung thực: gói ĐÚNG nội dung APEX đã duyệt ở cổng source, nhưng SAI danh tính so với bản đang chạy trên máy (xem mục 0.1) và version đặt trong bối cảnh cây nguồn (`1.0.3-apex1` < dòng bản GPT `1.0.4-hl*`). Quy tắc version đề xuất cho mọi bản thử sau: (1) đúng mã gói của bản đang cài trên máy; (2) version cao hơn bản đang cài; (3) quét quyền file toàn gói (755/644) trước khi giao; (4) ghi SHA-256 + đối chiếu installed sau cài.
- Chuỗi sự kiện thiết bị tối 14/11 (đã báo #6876588469): bản rebrand `com.chuong.duocar 1.0.4-apex1` lỗi quyền 660 toàn gói (đo trên gói) → cài xong mất app; bản sửa `1.0.4-apex2` SHA-256 `f706242b…` — Nguyen xác nhận tại chat 18:30 "Bản mới đã cài đc" = DEVICE INSTALL CONFIRMED ở mức cài đặt. Chưa có ảnh after của giao diện APEX trên xe → mọi hàng vision của APEX giữ PENDING/UNKNOWN (mục 4).

## 2. BẢNG PHỦ — TÓM TẮT TRẠNG THÁI THEO NHÓM

| Nhóm | Số dòng | DONE | NOT DONE (còn sót cũ) | UNKNOWN |
|---|---|---|---|---|
| A Brand/asset | 30 | 15 (toàn bộ bitmap + mesh đã thay + đối chứng DuoCar) | 13 hiển thị/metadata (A13–A27, A26 = 99 file strings) + 2 dormant (A9, A10) | gương asset trong src/ |
| B Native (xe) | 20 | 11 | B-N1 (nền pill), B-N6/N9 (vật liệu blur Light), B-N7 (navy+wrapper), B-N11 (separator/tint), B-N12 (shadow tím), B-N13 (tint navy chip), B-N15 (float/preview trắng), B-N17 (lavender), B-N19 (shadow tím+ghost) | windowLevel số cụ thể (B-N5); chi tiết HL50 scene-preserve (B-N18) |
| B Hosted (xe) | 4 | 3 | **B-H2 — glyph đen (trọng tâm)** | — |
| D Bàn phím/HUD | 5+4 | D1, D2, D4, D5, H1, H2, H3, H4 | D3 (2 màu runtime) | quyết định native/hosted cho HUD (E18) |
| C App iPhone | 17 | 14 | C15 (trang Guide/WhatsNew chưa token), C16 (alert title OmniCar), C10 (nhãn SPEEDBUBBLE trên nội dung Lề — cố ý HL58) | — |
| P Prefs | 8 | 4 | P2 (tên + version cứng), P3 (title Root.plist) | chi tiết từng trang con (P5) |
| S Startup | 5 | 2 | S3 (5 fallback OmniCar), S5 (HUD chẩn đoán trên splash) | — |
| E Cờ/trạng thái | 19 | 15 | — | E3 (liteMode default mâu thuẫn @0/@2), E15 (HL46 không dấu vết trong tuyến app/prefs/startup/HUD) |

Chi tiết từng dòng: Phụ lục A ở cuối tài liệu này (ID, bề mặt, file:method:dòng, call chain rút gọn, sót cụ thể, ràng buộc).

## 3. BẢNG PHÂN BIỆT NATIVE / HOSTED (điểm render quyết định)

| Yếu tố | Native (SplitScreen) | Hosted (AppBridge) | Hệ quả / khác biệt thật |
|---|---|---|---|
| Renderer glyph | `SCPDrawSymbolIcon` + `SCPRenderTemplateImage` (RatioMenu.m:26–61): vẽ đen nhưng trả ảnh **AlwaysTemplate** (:54) | `ABSetBarButtonContent` (ABHostBMethods.m:401–503): vẽ `[[UIColor blackColor] set]` (:410) cho MỌI glyph, chốt ảnh **AlwaysOriginal** (:501) | **Nguyên nhân icon hosted đen, đã chốt ở source:** cùng cách vẽ đen, khác duy nhất rendering mode |
| Tint | Factory gán `button.tintColor` và ĂN THẬT (RatioMenu.m:263 — còn sót giá trị navy; Chrome.m:165 truyền Ice/danger) | `ABMakeBarButton` gán `button.tintColor` Ice/danger (ABHostBMethods.m:514, 1184–1197) nhưng CHẾT ở 2 tầng: ảnh AlwaysOriginal + ảnh hiển thị qua UIImageView con tag 7302 (:503, frame inset 6) chứ không phải image template của button | Muốn hosted ăn tint phải đổi rendering mode VÀ/hoặc đường hiển thị — đây là hunk trình bày nằm trong file dùng chung, cần duyệt trước (mục 5, BL-07) |
| Cache glyph | static NSDictionary, key `name/size/0` (RatioMenu.m:197–200), không có xoá cache | static NSMutableDictionary theo `name` (ABHostBMethods.m:402–404, 502) — 1 ảnh cho mọi trạng thái | Cả hai phía: đổi màu glyph phải tính chuyện cache không tự làm mới trong cùng tiến trình |
| Pressed / disabled | `SCPCButton -setHighlighted:` spring scale 0.9 (SCPCButton.m:26–42) dùng chung; disabled thể hiện bằng alpha (popButton 0.35 Chrome:308; ô đã dùng trong picker alpha 0.3 + khoá chạm) | Không có biến thể pressed/disabled cho glyph; chỉ `pane.popButton.alpha = dim ? 0.35 : 1.0` (ABHostBMethods.m:1286) | V3 cần trạng thái pressed/disabled riêng cho hosted nếu muốn đồng nhất |
| Tay nắm | Pill 34×12 gắn gesture TRỰC TIẾP (tap + **double-tap** + pan; tap chờ double-tap fail) — Chrome.m:182–218, Zoom.m:51/63, Drag.m:53 | Pill 34×12 nằm trong lớp hit riêng **44×24**, chỉ tap + pan, **không có double-tap** — ABHostBMethods.m:1341–1378 | Hành vi hai phía vốn KHÔNG đối xứng (double-tap chỉ native). Thay hình thức tay nắm phải giữ nguyên bất đối xứng này trừ khi có lệnh riêng |
| Hit mở rộng | `SCPCButton.pointInside` nới mỗi chiều ≥44pt (SCPCButton.m:18–22); knob nới 26pt, thân divider 6pt (SCPCarDividerView.m:118–127) | Lớp hit 44×24 của handle; plate nút trong bar | Vùng hit là cơ chế — cấm thu nhỏ khi đổi hình thức |
| Mặt/vật liệu | Blur Light style 11 qua `SCPKnobFaceView()` + skin graphite phủ trong contentView ở 3 caller | Bar hosted: blur style 11 riêng (ABHostBMethods.m:1217–1219) + mesh graphite riêng (helper ABApexGraphiteSkinImage :1164–1181) | Hai phía dùng HAI hiện thực blur/mesh riêng — V3 phải xử lý cả hai nơi, không có một điểm đổi chung |
| HUD | Bong bóng fullscreen chỉ hiện khi "confirmed fullscreen" (SCPFullscreenVitalsBubble.m:187,320); HUD neo cây Dock gốc (SCPDeviceVitalsHUD.m:241) | Không có bề mặt HUD trong module AppBridge (grep âm tính có bằng chứng) | Quyết định hiện HUD nằm ở phía gọi trong chrome — đối chiếu thuộc tuyến xe |

## 4. BẢNG KIỂM THIẾT BỊ (VISION GATE) — TRẠNG THÁI BẰNG CHỨNG

| Nhóm bề mặt | Before (đã có) | After APEX (đã có) | Trạng thái |
|---|---|---|---|
| Picker phía xe | Ảnh Nguyen 14/11 17:49: sheet hồng/tím/trắng trên bản đang chạy lúc đó | Chưa có ảnh picker của binary APEX chạy thật trên xe | **UNKNOWN** — ảnh before thuộc bản DuoCar tiền-APEX (mục 0.1); cấm dùng làm "after" |
| Thanh lệnh native/hosted | Ảnh xe trong chỉ đạo V3 (#6876443778): native đọc được icon, hosted icon đen | Chưa có | **PENDING** — nguyên nhân hosted đen đã chốt ở source (mục 3) nhưng chưa có ảnh xác nhận sau sửa |
| Tay nắm 3 chấm | Ảnh xe: pill 3 chấm hình gốc | Chưa có (chưa lô nào thay hình thức) | **NOT DONE** ở source |
| App iPhone 5 tab | Ảnh Nguyen 17:52: app DuoCar 3 tab (bản tiền-APEX) | apex2 cài thành công (Nguyen xác nhận 18:30) — chưa có ảnh chụp 5 tab | **INSTALL CONFIRMED / VISUAL UNKNOWN** |
| Gói trên máy | apex1-anlai: cài song song (đã đo bằng ảnh + hành vi); duocar-apex1: lỗi quyền 660 (đo trên gói) | duocar-apex2: cài đè thành công | **DONE ở mức cài đặt**; PID/marker tiến trình: **UNKNOWN** (không có log thiết bị) |
| Startup/HUD/nhiệt | Không có ảnh/log đợt này | Không có | **UNKNOWN** |

Nguyên tắc giữ nguyên: không gọi ảnh/log của bản khác là bằng chứng của bản này; SOURCE/BUILD PASS không suy ra VISUAL/DEVICE PASS.

## 5. BACKLOG TRIỂN KHAI V3 (chờ thiết kế GPT được Nguyen duyệt — thứ tự đề xuất)

| ID | Hạng mục | File/method chính | Rủi ro | Điểm duyệt |
|---|---|---|---|---|
| BL-01 | Quét chữ brand hiển thị: Info.plist (DisplayName/Name/2 câu Photos), control (Name/Description/Maintainer), PreferenceLoader label, Root.plist title, OMCHeaderCard (tên + version cứng → đọc từ bundle), tiêu đề/alert OMCNativeSettings.m:174, OMCRootListController.m:207/334, 3 alert prefs, placeholder SS prefs | Thuần hằng số hiển thị; không đụng identifier K1–K12 | Thấp | Không chạm F/C; chỉ cần GPT chốt tên hiển thị cuối |
| BL-02 | `.strings` prefs 16 locale: thay tên hãng trong VALUE của 99/139 file, giữ nguyên 100% key | OMCLocalizable qua `L()` | Thấp–trung bình (khối lượng lớn, cần script kiểm key-diff = 0) | K10 |
| BL-03 | 5 fallback "OmniCar" trên scene startup xe + 5 trong bản sao prefs SSStartupView + banner cứu hộ song ngữ | SSStartupViewBuilders.m:318/575/964, ScenesB:631, SSStartupScreen.m:911; SSStartupView.m (prefs); OmniCarCore.c:184/187 (chỉ chuỗi) | Thấp | Cấm đụng logic scene/claim (S1) và logic crash-guard |
| BL-04 | Picker: navy 3 điểm (separator/title/tint chip SCPWrapRatioChip), tím 2 điểm (shadow panel/icon), wrapper trắng, ghost lavender, mặt lavender trong pane + cover | Picker.m:837–862, ~920–929, ~372, 301–305; Panel.m:236–242; RatioMenu.m:263–266; Drag.m:40–47 | Trung bình (màu thuần, không frame/hit) | Đổi default nhánh HL51/HL49 = KHÔNG thuộc mục này — đó là thay đổi hành vi, cần lệnh riêng |
| BL-05 | Vật liệu mặt chung: SCPKnobFaceView (blur Light + Lite trắng 0.92) — 1 factory cho bar/panel/picker/ratio/knob + phía hosted blur riêng ở bar | SCPCarDividerView.m:99–107; ABHostBMethods.m:1217–1219 | **Cao** — đổi 1 chỗ đổi 5 bề mặt cùng lúc, liên quan độ tương phản/độ sâu của sheet trên app | Cần thiết kế V3 chốt vật liệu + hunk duyệt trước (F-adjacent) |
| BL-06 | Tay nắm thay 3 chấm cả hai phía (giữ nguyên: hitbox, gesture, thứ tự gọi bwRecompute/ahApply, bất đối xứng double-tap) | Chrome.m:182–218; ABHostBMethods.m:1341–1378 | Trung bình–cao (view cấu trúc gắn gesture) | Trình hunk + impact trước; cấm đổi selector/callback |
| BL-07 | Hosted glyph: đưa rendering về template/tint sống như native (đổi mode + đường hiển thị UIImageView con, xử lý cache) | ABHostBMethods.m:401–503 | Trung bình (chỉ trình bày, trong file dùng chung AppBridge) | Trình hunk trước theo điều kiện file dùng chung; giữ nguyên hình học glyph hm_* và selector |
| BL-08 | Bàn phím: 2 màu runtime sót (preview khi gõ + hint Telex) | ABKeyboard.m:465–474, 642–645 | Thấp | Cấm đụng Telex/layout (D5) |
| BL-09 | Trang Guide/WhatsNew trong app về token; dòng chẩn đoán trên splash về hình thức V3 | OMCNativeSettings.m:1289–1320; SSSplash.m:95–118 | Thấp | Giữ nguyên nội dung chữ/khoá strings |
| BL-10 | Nhãn SPEEDBUBBLE trên trang Lề (kind 3) | OMCNativeSettings.m keys[3] | Thấp | Cần Nguyen quyết (đang giữ cố ý từ HL58); giao thức Lề F9 cấm đụng |
| BL-11 | Mesh dormant OMCLogoMeshImage (lõi C): GIỮ NGUYÊN trong V3 này; chỉ xử lý nếu V3 kích hoạt lại SpeedBubble | OMCCommon.c:1633–1667 | — | Vùng cấm lõi C — không hunk trong P2 trừ khi có lệnh riêng |
| BL-12 | Đo liteMode trên máy (E3): cần 1 lần đọc pref/log thiết bị để chốt default thật @0 hay @2 | OMCCommon.h:81 vs SSSplash.m:107 | — | Việc đo, không phải sửa |

## 6. IDENTIFIER TUYỆT ĐỐI GIỮ (đổi = vỡ liên kết/dữ liệu/IPC) + ĐĂNG KÝ UNKNOWN

**Giữ:** K1 Package id trong cây `com.anlai.omnicar` (danh tính DuoCar sinh ở rebrand đóng gói) · K2 bundle id app/prefs · K3 URL scheme `omnicar` · K4 thư mục dữ liệu `/var/mobile/Library/OmniCar/...` (StartupScreen/HomeScreen — media người dùng) · K5 danh tính bundle prefs `OmniCarPrefs.bundle` + class `OMCRootListController` + entry icon/label keys · K6 file log/chẩn đoán liên module (OmniCar.log, crashguard plist…) · K7 miền prefs `com.anlai.omnicar` + kênh Darwin `prefschanged`/nhiệt (toàn bộ cài đặt người dùng sống ở đây) · K8 logic khớp tiền tố tên dylib `OmniCar` trong quy kết crash/session · K9 tiền tố class/symbol `OMC*` · K10 key `.strings` · K11 chuỗi chẩn đoán không hiển thị (NSLog/terminate reason) · K12 giao thức Lề `com.chuong.duocar/le024.cfg/.ack` (F9).

**UNKNOWN còn mở:** (U1) windowLevel số cụ thể của cửa sổ tray picker; (U2) chi tiết cơ chế scene-preserve HL50 tại Picker.m:506; (U3) liteMode default thật trên máy (E3); (U4) HL46 — không dấu vết trong các module app/prefs/startup/HUD (điểm đọc nằm phía xe: Picker.m — đã xác minh ở tuyến native B-N18); (U5) chi tiết từng trang con prefs (P5) ở mức từng hàng; (U6) gương asset bitmap trong src/ chưa cmp; (U7) PID/marker binary APEX trên thiết bị + toàn bộ ảnh after phía xe.

## PHỤ LỤC A — BẢNG PHỦ CHI TIẾT TỪNG DÒNG (rút gọn từ 4 tuyến kiểm kê)

### A. Brand/asset (tuyến 1) — gương src/ đã cmp KHỚP cho mọi file code trích dẫn
- A1 Icon app `OmniCarApp/Resources/AppIcon60x60@2x/@3x.png` (md5 7f262bbd…/43ed1b0a…) — DONE, artwork APEX, iOS nạp qua Info.plist CFBundleIcons.
- A2 Logo header prefs `OmniCarPrefs/Resources/logo*.png` — DONE; nạp `OMCHeaderCard.m:48 imageNamed:@"logo"` (tên tài nguyên là khoá nội bộ, giữ).
- A3 Icon mục Cài đặt `icon*.png` — DONE; PreferenceLoader đọc qua layout plist (entry.icon).
- A4 PackageIcon.png — DONE; control:36 trỏ đường bundle prefs (giữ đường dẫn).
- A5/A6 Icon hàng SpeedBubble/StartupScreen trong prefs — DONE, glyph trung tính; nạp qua spec property icon (OMCCommon.m:~384).
- A7 Mesh phía xe đã thay — 3 helper graphite vẽ bằng code (Chrome.m:42/64, ABHostBMethods.m:1164/1214, ABKeyboard.m:491/522) — DONE (TASK1).
- A8 Mesh bảng prefs `OMCCommon.m:524 OMCLogoMeshImage` renderer đã graphite (nền #101820 + blob cyan/teal) — DONE nội dung; tên hàm giữ.
- A9 Renderer mesh gốc lõi C `OMCCommon.c:1633 OMCDrawLogoMesh/:1667` — NOT DONE (dormant): palette lavender/hồng nguyên vẹn, 0 caller sống trong build; caller duy nhất SPPBubble.m:1043 ở module ngoài build. Vùng cấm lõi C.
- A10 Bản sao mesh CarProbe `OmniCarCarProbe.m:1619` — NOT DONE (dormant), không caller.
- A11 Placeholder/wallpaper ô split: media người dùng (`SCPHomeWallView.m:115`), phía xe không nạp bitmap logo — DONE (bằng chứng âm).
- A12 Preview startup/logo tuỳ biến: toàn bộ media người dùng — DONE.
- A13 Info.plist app: CFBundleDisplayName/CFBundleName = OmniCar — NOT DONE (bundle id/executable/scheme giữ).
- A14 Info.plist: 2 câu NSPhotoLibrary*UsageDescription chứa "OmniCar" — NOT DONE.
- A15 control: Name/Description/Maintainer/Author + "Settings > OmniCar" — NOT DONE (Package giữ).
- A16 layout PreferenceLoader plist: entry.label = "OmniCar" — NOT DONE (bundle/detail/icon giữ).
- A17 OMCHeaderCard.m:57 tên @"OmniCar" + :63 version cứng @"1.0.3" — NOT DONE.
- A18 OMCRootListController.m:207 title + :334 alert title @"OmniCar" — NOT DONE.
- A19 Root.plist /title = OmniCar — NOT DONE.
- A20 Alert title @"OmniCar" ×3: OMCCommon.m:931, OMCFeatureListController.m:107, OMCStartupScreenController.m:903 — NOT DONE.
- A21 Placeholder prefs startup `OMCStartupScreenController.m:307 ?: @"OmniCar"` — NOT DONE.
- A22 Bản sao SSStartupView.m trong prefs: 5 fallback @"OmniCar" (:209,1072,1145,1207,1347) — NOT DONE.
- A23 Scene splash xe: SSStartupViewBuilders.m:318/575/964, ScenesB.m:631, SSStartupScreen.m:911 — 5 fallback hiển thị — NOT DONE.
- A24 Banner cứu hộ OmniCarCore.c:184/187 (song ngữ) — NOT DONE (chỉ chuỗi; logic guard giữ).
- A25 Helper alert app OMCNativeSettings.m:174 title @"OmniCar" — NOT DONE (1 điểm, ảnh hưởng toàn app).
- A26 `.strings` prefs 16 locale: 99/139 file còn "OmniCar" trong value hiển thị (en Localizable 16 key, Onboarding 4, SplitScreen 3, Car 2, HomeScreen 1, Profiles 1, StartupScreen 1, WhatsNew 1; vi tương tự) — NOT DONE; key giữ tuyệt đối.
- A27 Nhãn mô tả "nút OmniCar trên dock" — nằm trong A26 (chữ mô tả; glyph dock không chữ) — NOT DONE.
- A28–A30 Đối chứng DONE: thân app đã DuoCar (OMCNativeSettings.m:440/629/682/1053/1413); gradient header prefs đã retune (OMCHeaderCard.m:37–39); mesh xe đã trung tính (A7).

### B. Native phía xe (tuyến 2) — module OmniCarSplitScreen
- B-N1 Handle: Chrome.m -setupBarForPane: :182–218 — nền pill trắng 0.35/viền trắng 0.55 NOT DONE; chấm graphite :195–200 DONE. Giữ: handle là subview pane, bringSubviewToFront cuối layout (:324–325), hidden=(vc==nil).
- B-N2 Gesture handle: tap/double-tap/pan gắn trực tiếp (Chrome:202–218; Zoom.m:51/63; Drag.m:53); wake `bwRecomputeForPane:` 4 điểm + AutoHide `ahApplyCurrentStateToView:` (:326–327, 368–385) — DONE, cấm tách.
- B-N3 Bar + nút: Chrome:220–268, factory :160–180, setBarVisible :339–386; chip SCPStyleChip :95–106; tint Ice/danger :229–233 — DONE (tên biến `navy` giữ nhưng giá trị đã Ice).
- B-N4 Accent: SCPApplyAccent Chrome:113–156 — DONE phần nhìn thấy; sót shadow tím (opacity 0) :124–128.
- B-N5 Hosting sheet: Picker.m -refreshPickerSheet :622, host :672, tray window :1502, SCPHL49SameWindowPicker :554–573 — DONE cấu trúc; windowLevel số = UNKNOWN.
- B-N6 Mặt sheet: Picker:768–805 — skin graphite qua mesh DONE; vật liệu blur Light NOT DONE (= B-N9).
- B-N7 Cột phụ picker: separator gradient navy :837–847, title navy :854, wrapper trắng 0.35/0.7 :856–862 — NOT DONE.
- B-N8 Divider/knob: SCPCarDividerView.m toàn file; Layout.m -layoutKnobOf: :591–663 — DONE (hit nới knob 26pt/thân 6pt :118–127 giữ).
- B-N9 SCPKnobFaceView DividerView:99–107 — blur Light style 11 + Lite trắng 0.92 — NOT DONE (vật liệu chung 5 bề mặt).
- B-N10 Pressed knob SCPSetKnobActive :48–95 — DONE code APEX; comment :31–46 còn mô tả màu tím gốc (lệch code).
- B-N11 Ratio menu RatioMenu.m:364–466 — nền DONE; separator trắng :~414 + tint chip navy NOT DONE; cơ chế che pane hosted khi menu ở container :449–456 giữ.
- B-N12 Panel bố cục Panel.m:228–330 — face DONE; shadow tím :236–242 + border/glyph trắng :295–312 NOT DONE.
- B-N13 Glyph native: SCPDrawSymbolIcon RatioMenu.m:61 + SCPRenderTemplateImage :26–55 (AlwaysTemplate :54), cache :197–200, SCPCButton pressed — cơ chế DONE; tint navy tại SCPWrapRatioChip :263–266 NOT DONE.
- B-N14 SCPCButton.m:13–42 hit ≥44pt + pressed spring — DONE, cấm thu nhỏ hit.
- B-N15 Focus flash Layout:666–683 (accent 2.5pt) DONE; border float trắng Zoom:~105 + ô preview trắng Picker:1318–1327 NOT DONE.
- B-N16 SCPApplyMeshBackdrop Chrome:61–79 — phạm vi phủ thật: bar/ratio (qua SCPStyleRatioMenu), panel, picker nhánh original; KHÔNG phủ knob, nhánh HL49 no-blur, placeholder/cover, SPPBubbleView — DONE (đã xác minh caller).
- B-N17 Mặt picker trong pane + cover: lavender đặc Picker:~372 và :301–305 — NOT DONE (mặc định); recognizer mở sheet :549–556 giữ.
- B-N18 Nhánh prefs (đọc OMCPref @YES, default YES toàn bộ): HL46 native clear :356/:411–419, HL46 cover-off :284/379, HL48 hosted clear :392, HL49 occupied clear :396/:420–431, HL50 preserve :506, HL51 restore-original :569/770, HL51 keep-hosted SCPCarSplit.m:2285, HL49 same-window :572 (chỉ tới khi HL51=NO), HL49 live-under :771–774, HL57 dùng lại pref HL51 :757–770 — DONE đã xác minh default+điểm áp; thân HL50 = UNKNOWN. Toàn bộ là cổng hành vi vùng F — chỉ đọc.
- B-N19 Lưới icon picker :905–955 + SCPStyleGhostIcon Drag.m:40–47 — badge/dots DONE; shadow icon tím :~920–929 + nền ghost lavender NOT DONE.
- B-N20 Đổi glyph/nhãn theo trạng thái fullscreen/float: Chrome:296–322 — DONE; cấm cache cứng icon nút.

### B/D. Hosted + bàn phím (tuyến 3) — module OmniCarAppBridge, gương src/AppBridgeB khớp dòng
- B-H1 Handle hosted ABHostBMethods.m -setupHandleForPane: :1341–1369 — hình thức DONE (pill 34×12, chấm graphite; comment "dot-blue" cũ sót); hit 44×24 :1342; gesture tap+pan :1359–1364 (không double-tap — khác native); accent ABApplyAccent :356–383.
- B-H2 Glyph bar hosted ABSetBarButtonContent :401–503 — NOT DONE (trọng tâm): vẽ đen :410 mọi glyph; ảnh AlwaysOriginal :501; hiển thị qua UIImageView con tag 7302 :503; tint của ABMakeBarButton :514 chết 2 tầng; cache theo name :402–404; không trạng thái pressed/disabled (chỉ alpha popButton :1286). Đối chiếu native AlwaysTemplate RatioMenu.m:54.
- B-H3 Mesh bar hosted -buildBarForPane: :1183–1253 + helper :1164–1181 — DONE (blur 11 :1217, mesh graphite vào contentView, viền stroke).
- B-H4 HUD trong AppBridge: KHÔNG tồn tại (grep battery/thermal/clock âm tính có bằng chứng) — DONE (kết luận âm).
- D1 Keyplane ABKeyboard.m -key:... :810–871 + ABKey -paint: :175–206 — DONE lô D13 (phím graphite, chữ Ice, lit gradient cyan–teal, glow teal).
- D2 Panel/field/lang/hide -buildPanel :513–584 + helper :493–511 — DONE (hideButton dùng SF Symbol template + tint Ice :570–574 — tint ăn, ngược B-H2).
- D3 Màu runtime sót: -updatePreview :465–474 ghi đè preview (0.16,0.24,0.0625)/placeholder 0.6 mỗi lần gõ; hint Telex (74,79,128)@0.55 tại :642–645 — NOT DONE.
- D4 Bong bóng phím -key:pressed: :731–787 — DONE (nền surface.2, chữ Ice); geometry/spring giữ.
- D5 Vùng cấm bàn phím nguyên vẹn: layoutPanelIn :602–618, layoutKeys :700–729, rebuildKeys :620–697, Telex :357–369 (ABTelexApply, engine ABTelex.m) — DONE xác nhận không lô nào đụng.

### C/P/S/H/E. App + prefs + startup + HUD + cờ (tuyến 4)
- C1 Gốc 5 tab OMCNativeSettingsRootController :1471–1497 (AppDelegate.m:18, không cổng onboarding) — DONE (580421b); giữ selectedIndex=0.
- C2 Dashboard :1346/1411–1426/1457–1468 — DONE (477263b + fix factory Startup 4ed1733).
- C3 Thẻ preview chia màn :1359–1408 — DONE (8cc471c, 2e23365); minh họa tĩnh, cấm nối dữ liệu thật.
- C4 Tab Bố cục kind1 :519–539 + header/nhãn ghim :581–610/686–688 — DONE.
- C5 Tab Ứng dụng AppsPage :181/199 — token DONE; empty-state/loading KHÔNG tồn tại trong source — NOT DONE (chưa từng có).
- C6 Tab Thiết bị kind5: phân vùng theo nội dung :491–518 — DONE (fa48bf4).
- C7 Tab Tùy chỉnh kind6 + thẻ master :612–668 — DONE.
- C8 Nền kind0 :448–490 — màu DONE; thứ tự nhóm là bố cục OmniCar gốc (comment :456–458 tự ghi) — giữ theo thiết kế D5-B.
- C9 kind2 Home :541–555 — DONE. C10 kind3: nội dung đã là trang Lề nhưng title còn SPEEDBUBBLE (keys[3]) — nhãn NOT DONE (giữ cố ý HL58; F9 giữ). C11 kind4 Hồ sơ xe :564–579 — DONE (schema carProfiles giữ).
- C12 Trang Startup trong app OMCNativeStartup.m — DONE (D6). C13 Trang Lề OMCLePrefsHost.m — DONE hình thức (D7); F9 giữ. C14 Pin & nhiệt OMCDeviceVitalsController.m — DONE (D8).
- C15 Guide/WhatsNew trong app :1289–1320 nền systemBackground, không token — NOT DONE.
- C16 Alert app: helper OMCAlert :173–179 title @"OmniCar" (= A25) — NOT DONE.
- C17 Token OMCApexStyle.h :1–21 dùng bởi 4 file UI app — DONE.
- P1 Gốc prefs OMCRootListController -specifiers :31–36 — DONE một phần. P2 Thẻ header (= A17) NOT DONE. P3 Root.plist title (= A19) NOT DONE. P4 Hàng feature động :65–113 — DONE (featureOrder/controller là ABI). P5 Trang con prefs (AppBridgeApps 53KB, SplitScreen 30KB, SpeedBubble 45KB, StartupScreen 63KB + bản sao SSStartupView, CarProfiles, FeatureList; OMCHomeScreenController chỉ là stub, trang thật ở OMCCardPage) — UNKNOWN mức từng trang. P6 Lõi OMCCommon.m prefs: hệ màu ĐỘNG riêng (tối trùng token APEX, sáng còn tông cũ 0x0F7E9E/0xE8F0F4), không import OMCApexStyle — DONE theo D14, cơ chế cũ. P7 Onboarding/WhatsNew prefs :196–200/347/356 — DONE cơ chế. P8 Asset prefs — DONE (D12).
- S1 Splash/vòng đời SSSplash.m + SSStartupScreen.m:284 — DONE chỉ màu (D9); logic cửa sổ/claim cấm đụng. S2 Engine scene SSStartupView/Builders/ScenesB — DONE màu (D9, hằng số tại chỗ, không import token). S3 Fallback chữ (= A23) NOT DONE. S4 Media người dùng /var/mobile/Library/OmniCar/StartupScreen — GIỮ NGUYÊN (đổi = mất media). S5 Dòng chẩn đoán SSSplash.m:95–118 — NOT DONE hình thức.
- H1 Bong bóng fullscreen SCPFullscreenVitalsBubble.m — DONE (D10); cấm đổi windowLevel/điều kiện hiện. H2 HUD Dock SCPDeviceVitalsHUD.m — DONE (D10); cấm đụng neo Dock HL51. H3 Viền nhiệt SCPThermalEdgeWarning.h:11–70 #FF0610 + pulse 0.75s — GIỮ NGUYÊN (an toàn). H4 Cổng nhiệt HL60 + kênh giả lập — GIỮ NGUYÊN.
- E1 enabled @YES · E2 language @en · E4 duocarVitalsEnabled @YES · E5 duocarFullscreenVitalsEnabled @YES · E6 duocarThermalTest37Enabled @NO · E7 splitScreenEnabled @YES/AutoLaunch @NO · E8 ShowRecent/Favorites @YES · E9 splitScreenPinnedApp @"" · E10 homeScreen* (cols/rows @0, size @100, names @YES, blur @0, dim @25) · E11 carProfilesEnabled @NO (lệch kiểu đọc NSArray/NSDictionary giữa splash và kind4 — chỉ ghi nhận) · E12 onboardingDone · E13 whatsNewSeen — DONE ở mức source. E3 liteMode: MÂU THUẪN default (@0 tại SSSplash.m:107 vs @2 tại OMCCommon.h:81 + CarProbe.m:240) — UNKNOWN trên máy. E14 splash 1 lần/kết nối (claim không xoá, SSStartupScreen.m:148–158) — DONE source. E15 HL46 trong tuyến này: âm tính — UNKNOWN tại tuyến này (đã xác minh phía xe ở B-N18). E16 HL49: chỉ còn comment (HUD.m:238), cơ chế sống = HL51 — DONE. E17 HL57 = H1 — DONE. E18 native/hosted cho HUD — UNKNOWN trong tuyến này. E19 Miền prefs com.anlai.omnicar là ABI nền của mọi cờ — DONE, ràng buộc cứng.

— Hết P0. Muse không tự thiết kế V3; chờ gói thiết kế của GPT được Nguyen duyệt để vào P2 theo backlog mục 5. —
