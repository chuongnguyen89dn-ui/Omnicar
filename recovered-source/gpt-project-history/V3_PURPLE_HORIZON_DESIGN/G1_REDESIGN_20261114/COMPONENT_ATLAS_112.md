# DuoCar V3 — P4/G1 BẢNG PHỦ ĐÍCH DANH 112/112 ID (THIẾT KẾ / GIỮ / KIỂM)

Ngày 2026-11-14. Nguồn chính: `APEX_V3_P0_BANG_PHU_20261114.md` (Muse; 112 rows), `APEX_V3_P4_G0_AUDIT_20261114.md` (2 DEB verified by Muse), source present (G2 R0). Toàn bộ hình nằm tại `V3_PURPLE_HORIZON_DESIGN/G1_REDESIGN_20261114/screens/`.

**Phân biệt:** 112 hạng mục audit ≠ 112 màn cần vẽ. 23 artboard là giao diện mẫu source-vector cho toàn bộ **giao diện chính**. Bảng này **chỉ khóa quyết định thiết kế và nơi tra code**; chưa xác minh đã thi công, chưa thực hiện screenshot-diff, 5 UNKNOWN G0 giữ UNKNOWN. `G1-REDESIGN`: mặt DuoCar do dự án vẽ cần thay thiết kế; `DISPLAY-MIGRATION`: đổi brand/text nhưng tuyệt đối không đổi keys; `PROTECTED-KEEP`: chức năng hay khuôn/asset cần giữ nguyên; `VALIDATE-BEFORE-CODE`: cần bằng chứng trước khi đổi. H1/H2, nhiệt/SpeedBubble/Lề ngoài scope thay tính năng, vẫn có artboard chỉ để ghi ràng buộc.

## Phân loại audit
- **A**: 30 hạng mục; phân loại: G1-REDESIGN=5, PROTECTED-KEEP=8, DISPLAY-MIGRATION=14, VALIDATE-BEFORE-CODE=3.
- **B-N**: 20 hạng mục; phân loại: G1-REDESIGN=15, PROTECTED-KEEP=5, DISPLAY-MIGRATION=0, VALIDATE-BEFORE-CODE=0.
- **B-H**: 4 hạng mục; phân loại: G1-REDESIGN=3, PROTECTED-KEEP=1, DISPLAY-MIGRATION=0, VALIDATE-BEFORE-CODE=0.
- **D**: 5 hạng mục; phân loại: G1-REDESIGN=4, PROTECTED-KEEP=1, DISPLAY-MIGRATION=0, VALIDATE-BEFORE-CODE=0.
- **C**: 17 hạng mục; phân loại: G1-REDESIGN=14, PROTECTED-KEEP=0, DISPLAY-MIGRATION=1, VALIDATE-BEFORE-CODE=2.
- **P**: 8 hạng mục; phân loại: G1-REDESIGN=6, PROTECTED-KEEP=1, DISPLAY-MIGRATION=1, VALIDATE-BEFORE-CODE=0.
- **S**: 5 hạng mục; phân loại: G1-REDESIGN=3, PROTECTED-KEEP=1, DISPLAY-MIGRATION=1, VALIDATE-BEFORE-CODE=0.
- **H**: 4 hạng mục; phân loại: G1-REDESIGN=0, PROTECTED-KEEP=4, DISPLAY-MIGRATION=0, VALIDATE-BEFORE-CODE=0.
- **E**: 19 hạng mục; phân loại: G1-REDESIGN=0, PROTECTED-KEEP=15, DISPLAY-MIGRATION=0, VALIDATE-BEFORE-CODE=4.

## Danh mục từng ID — map artwork và data/handler (không là source code đã sửa)

| ID | Trách nhiệm | SVG G1 | Quyết định thiết kế / giữ chức năng | Source/owner tham chiếu |
|---|---|---|---|---|
| A1 | PROTECTED-KEEP | #11, #14, #22 | D nghiêng tím: giữ nguyên binary icon app; không sinh logo mới | `OmniCarApp/Resources/AppIcon` |
| A2 | PROTECTED-KEEP | #14, #22 | Header dùng đúng D gốc; không raster lại WebP thumbnail | `OmniCarPrefs/Resources/logo*.png; OMCHeaderCard.m` |
| A3 | PROTECTED-KEEP | #22 | Icon mục Cài đặt giữ bản D gốc, chỉ đổi plate đặt icon | `OmniCarPrefs/Resources/icon*.png` |
| A4 | PROTECTED-KEEP | #22 | PackageIcon lấy D asset hiện có, không đổi đường asset | `PackageIcon.png; control Icon` |
| A5 | VALIDATE-BEFORE-CODE | #19, #21 | Icon SpeedBubble chỉ được bao bởi component giao diện chính, vendor ngoài scope | `Prefs Feature/Resources` |
| A6 | VALIDATE-BEFORE-CODE | #19 | Icon Startup asset giữ và áp plate mới, không sửa media user | `Prefs StartupScreen/Resources` |
| A7 | G1-REDESIGN | #01, #02, #03, #04, #05, #06 | Skin mesh graphite cũ thay face tím đêm đúng factory (trừ scene app) | `Chrome.m; ABHostBMethods.m; ABKeyboard.m` |
| A8 | G1-REDESIGN | #14, #22 | Thẻ prefs header mới, không kéo mesh V2 vào lại | `OMCCommon.m:524` |
| A9 | PROTECTED-KEEP | #10 | Core mesh dormant, không kích hoạt trong P4 | `OMCCommon.c:1633` |
| A10 | PROTECTED-KEEP | #10 | CarProbe mesh dormant, không kích hoạt | `OmniCarCarProbe.m:1619` |
| A11 | PROTECTED-KEEP | #01, #12 | Wallpaper split là media cá nhân; không vẽ lại | `SCPHomeWallView.m:115` |
| A12 | PROTECTED-KEEP | #09, #19 | Preview ảnh/video khởi động từ media người dùng; không fake | `StartupScreen media source` |
| A13 | DISPLAY-MIGRATION | #11, #14 | DisplayName DuoCar; giữ CFBundleIdentifier | `OmniCarApp/Resources/Info.plist` |
| A14 | DISPLAY-MIGRATION | #19 | Photo permission copy DuoCar, giữ ý nghĩa/quyền | `OmniCarApp/Resources/Info.plist` |
| A15 | DISPLAY-MIGRATION | #22 | Package metadata hiển thị DuoCar, package ID giữ ABI hiện hành | `project/control` |
| A16 | DISPLAY-MIGRATION | #22 | Nhãn PreferenceLoader hiển thị DuoCar | `layout/.../OmniCarPrefs.plist` |
| A17 | G1-REDESIGN | #22 | HeaderCard dạng brand capsule mới + version động từ bundle | `OMCHeaderCard.m:48,57,63` |
| A18 | DISPLAY-MIGRATION | #22 | Title/alert legacy dùng DuoCar, không sửa hành vi | `OMCRootListController.m:207,334` |
| A19 | DISPLAY-MIGRATION | #22 | Root.plist title DuoCar; 15 specifier giữ nguyên | `OmniCarPrefs/Resources/Root.plist` |
| A20 | DISPLAY-MIGRATION | #22 | Ba alert prefs title DuoCar | `OMCCommon.m; OMCFeatureListController.m; OMCStartupScreenController.m` |
| A21 | DISPLAY-MIGRATION | #19, #22 | Startup placeholder DuoCar, không thay fallback media | `OMCStartupScreenController.m:307` |
| A22 | DISPLAY-MIGRATION | #09, #19 | Prefs copy SSStartupView: fallback string DuoCar | `SSStartupView.m` |
| A23 | DISPLAY-MIGRATION | #09 | Scene splash copy: fallback DuoCar | `SSStartupViewBuilders.m; ScenesB.m; SSStartupScreen.m` |
| A24 | DISPLAY-MIGRATION | #14, #22 | Car banner rescue chỉ thay brand hiển thị | `OmniCarCore.c` |
| A25 | DISPLAY-MIGRATION | #14 | OMCAlert title DuoCar; dùng alert component chung | `OMCNativeSettings.m:174` |
| A26 | DISPLAY-MIGRATION | #22, #23 | 99 .strings files: chỉ thay values hiển thị, không keys/locale semantics | `OmniCarPrefs/Resources/*/*.strings` |
| A27 | DISPLAY-MIGRATION | #11, #23 | Copy hướng dẫn nút dock đổi thành DuoCar, không thay nút system | `OmniCarPrefs locale` |
| A28 | VALIDATE-BEFORE-CODE | #14 | Brand đang là DuoCar ở app; đối chiếu real screenshot | `OMCNativeSettings.m:440` |
| A29 | G1-REDESIGN | #22 | Gradient header prefs chuyển plate Orbit, giữ nội dung | `OMCHeaderCard.m:37` |
| A30 | G1-REDESIGN | #01, #14 | Mesh đồ họa trang chính thay lớp horizon, không đụng gốc AppBridge | `project main UI skins` |
| B-N1 | G1-REDESIGN | #13, #05 | Tay nắm 34×12: vạch sáng / four states, không thay hit | `SCPCarSplit+Chrome.m:setupBarForPane` |
| B-N2 | PROTECTED-KEEP | #05, #13 | Native recognizer tap/double/pan & wake giữ nguyên | `Chrome.m; Zoom.m; Drag.m` |
| B-N3 | G1-REDESIGN | #05 | Hàng 5 nút cũ → Orbit 5 sector thật, old bar fallback | `Chrome.m:204-216; setBarVisible` |
| B-N4 | G1-REDESIGN | #05, #13 | Accent active dùng bloom/outline trạng thái, không chặn hit | `Chrome.m:SCPApplyAccent` |
| B-N5 | PROTECTED-KEEP | #02, #03 | Tray hosting +65 giữ nguyên level/hit; chỉ content/face mới | `Picker.m:refreshPickerSheet` |
| B-N6 | G1-REDESIGN | #02, #03 | Mặt picker tím đêm đặc và cards trong bound cũ | `Picker.m:buildPickerSheetForPane` |
| B-N7 | G1-REDESIGN | #02, #03 | Sidebar 150pt thành vùng status/target/Apply theo cổng hình học | `Picker.m:sideColumn` |
| B-N8 | G1-REDESIGN | #04 | Knob/divider nhận stroke gradient/drag states, không sửa tỷ lệ/hit | `DividerView.m; Layout.m` |
| B-N9 | G1-REDESIGN | #02, #03, #04 | SCPKnobFaceView: thống nhất dark plate không lấy màu app dưới | `SCPCarDividerView.m:99` |
| B-N10 | G1-REDESIGN | #04, #13 | Knob pressed/selected có ngữ nghĩa mới, giữ gesture | `SCPSetKnobActive` |
| B-N11 | G1-REDESIGN | #04 | Ratio popup vẫn 42pt, preset icon mới và nhãn tùy không tràn | `SCPCarSplit+RatioMenu.m` |
| B-N12 | G1-REDESIGN | #04, #05, #14 | Bố cục panel thành palette theo trạng thái, giữ layoutChosenID | `SCPCarSplit+Panel.m` |
| B-N13 | G1-REDESIGN | #04, #05 | Native glyph template & selected state, không phá cache | `SCPDrawSymbolIcon; SCPWrapRatioChip` |
| B-N14 | PROTECTED-KEEP | #04, #13 | SCPCButton hit ≥44, press spring giữ nguyên | `SCPCButton.m` |
| B-N15 | G1-REDESIGN | #01, #12 | Viền focus, float frame/preview cùng ngôn ngữ ribbon | `SCPCarSplit+Layout.m; Zoom.m` |
| B-N16 | G1-REDESIGN | #01, #02 | MeshBackdrop ứng dụng trên surface DuoCar, không phủ scene | `Chrome.m:SCPApplyMeshBackdrop` |
| B-N17 | G1-REDESIGN | #02, #03, #12 | Placeholder slot trống mới nhưng picker cover/host logic giữ nguyên | `Picker.m:clear/cover` |
| B-N18 | PROTECTED-KEEP | #02, #03 | HL46-HL57 picker scene/window flags giữ nguyên | `SCPCarSplit+Picker.m; SCPCarSplit.m` |
| B-N19 | G1-REDESIGN | #02, #04 | Icon picker shadow/ghost dùng token V3, bundle icon thật | `Picker.m; Drag.m` |
| B-N20 | PROTECTED-KEEP | #05, #07 | Fullscreen/float label theo state owner thật, không cache stale | `Chrome.m:state glyph` |
| B-H1 | G1-REDESIGN | #06, #13 | Tay nắm hosted 34×12 trong hit 44×24, vạch tím và 4 state | `ABHostBMethods.m:setupHandleForPane` |
| B-H2 | G1-REDESIGN | #06 | Hosted glyph không đen: template/tint thật; wheel cùng owner | `ABSetBarButtonContent; ABHostLaunch.m` |
| B-H3 | G1-REDESIGN | #06 | Hosted blur mesh thay theme source token, không tạo bar chạm đôi | `ABHostBMethods.m:buildBarForPane` |
| B-H4 | PROTECTED-KEEP | #17, #20 | HUD thuộc SplitScreen, không thêm hosted duplicate | `AppBridge HUD absence` |
| D1 | G1-REDESIGN | #08 | Keycaps hình học hiện có, face tím, chữ sáng, active violet | `ABKeyboard.m:ABKey paint` |
| D2 | G1-REDESIGN | #08 | Input field/ẩn phím ngữ nghĩa mới, hit và resize giữ nguyên | `ABKeyboard.m:buildPanel` |
| D3 | G1-REDESIGN | #08 | Runtime preview/hint Telex không trôi về text màu tối cũ | `ABKeyboard.m:updatePreview` |
| D4 | G1-REDESIGN | #08 | Key pressed bubble theo theme, không chạm ngoài keyplane | `ABKeyboard.m:key pressed` |
| D5 | PROTECTED-KEEP | #08 | Telex, layout/resize, native keyplane giữ nguyên | `ABKeyboard.m layout; ABTelex.m` |
| C1 | G1-REDESIGN | #14, #15, #16, #17, #18 | 5 tab root điều hướng mới với 5 destination thật | `OMCNativeSettings.m:root` |
| C2 | G1-REDESIGN | #14 | Dashboard theo hero + bento grid + shortcuts thay table rows | `OMCNativeSettings.m:dashSections` |
| C3 | G1-REDESIGN | #14, #15 | Split preview dùng diagram có nhãn MINH HỌA, không realtime giả | `OMCNativeSettings.m:omcInstallSplitPreview` |
| C4 | G1-REDESIGN | #15 | Bố cục qua preset diagram, pins/switch giữ action cũ | `OMCNativeSettings.m:kind1` |
| C5 | G1-REDESIGN | #16 | Ứng dụng source catalog qua bento cards; empty/retry states mới | `OMCNativeSettings.m:AppsPage` |
| C6 | G1-REDESIGN | #17 | Thiết bị data-driven metric tiles / unavailable — | `OMCNativeSettings.m:kind5` |
| C7 | G1-REDESIGN | #18 | Tùy chỉnh grouped creative controls, prefs key giữ nguyên | `OMCNativeSettings.m:kind6` |
| C8 | G1-REDESIGN | #14 | Root sections theo hero + critical notice + bento; giữ rescue/conflicts | `OMCNativeSettings.m:kind0` |
| C9 | G1-REDESIGN | #18 | Home customization tile/grid, giữ setting keys | `OMCNativeSettings.m:kind2` |
| C10 | VALIDATE-BEFORE-CODE | #21 | Lề wrapper điều hướng tối giản, vendor core ngoài scope | `OMCNativeSettings.m:kind3` |
| C11 | G1-REDESIGN | #18 | Car profile detail trên card thật, không fake profile | `OMCNativeSettings.m:kind4` |
| C12 | G1-REDESIGN | #19 | Startup nested page media picker theo actual file, no copy scene | `OMCNativeStartup.m` |
| C13 | VALIDATE-BEFORE-CODE | #21 | Lề prefs host wrapper style only, không sửa cfg/ack | `OMCLePrefsHost.m` |
| C14 | G1-REDESIGN | #17, #20 | Vitals page metric layout + empty/refresh/error | `OMCDeviceVitalsController.m` |
| C15 | G1-REDESIGN | #23 | Guide/WhatsNew thành timeline/orbit cards, không chỉ tint UITextView | `OMCNativeSettings.m:guide` |
| C16 | DISPLAY-MIGRATION | #14, #22 | Alert title DuoCar + reusable alert typography | `OMCAlert` |
| C17 | G1-REDESIGN | #14, #18, #22 | OMCApexStyle token factory mở rộng, cùng semantic spacing/type | `OMCApexStyle.h` |
| P1 | G1-REDESIGN | #22 | Root prefs giữ controller, thay header/navigation/section face | `OMCRootListController.m` |
| P2 | G1-REDESIGN | #22 | Header 118pt dạng brand + master switch, version đọc động | `OMCHeaderCard.m` |
| P3 | DISPLAY-MIGRATION | #22 | Root title DuoCar và title style | `OmniCarPrefs/Resources/Root.plist` |
| P4 | G1-REDESIGN | #22 | Feature order giữ hành vi, ô feature mới theo group UI | `OMCRootListController.m:specifier order` |
| P5 | G1-REDESIGN | #22 | Nested prefs mỗi trang mới theo token với states; geometry UNKNOWN | `OmniCarPrefs nested controllers` |
| P6 | G1-REDESIGN | #22 | Dark/light dynamic face tương thích, không phá preference mechanism | `OMCCommon.m theme` |
| P7 | G1-REDESIGN | #23 | Onboarding/WhatsNew card/timeline và trạng thái, giữ key | `OmniCarPrefs onboarding` |
| P8 | PROTECTED-KEEP | #22 | Assets prefs D gốc, không dùng logo mới vẽ | `Prefs Resources` |
| S1 | G1-REDESIGN | #09 | Splash brand + horizon có logo gốc, không lấn user media | `SSSplash.m` |
| S2 | G1-REDESIGN | #09 | Startup scene visual state, không sửa claim/scene ownership | `SSStartupView; SSStartupScreen` |
| S3 | DISPLAY-MIGRATION | #09 | Fallback tên DuoCar, không làm chủ claim | `SSStartupView*` |
| S4 | PROTECTED-KEEP | #09, #19 | Giữ media start /var/mobile/Library/OmniCar/StartupScreen | `StartupScreen path` |
| S5 | G1-REDESIGN | #09 | Diagnostic HUD typography/color token, không fake kết quả | `SSSplash.m` |
| H1 | PROTECTED-KEEP | #07, #20 | Vitals bubble fullscreen giữ original placement/touch & data | `SCPFullscreenVitalsBubble.m` |
| H2 | PROTECTED-KEEP | #07, #20 | Dock HUD giữ anchor nguồn giờ/pin/nhiệt | `SCPDeviceVitalsHUD.m` |
| H3 | PROTECTED-KEEP | #10, #20 | Cảnh báo đỏ #FF0610 & pulse 0.75s — ngoài scope đổi UI | `SCPThermalEdgeWarning.h` |
| H4 | PROTECTED-KEEP | #10, #20 | Ngưỡng 37°C mô phỏng/logic cảnh báo giữ nguyên | `thermal gate` |
| E1 | PROTECTED-KEEP | #14 | enabled default YES; UI switch semantics giữ | `enabled` |
| E2 | PROTECTED-KEEP | #14, #22 | Language default en và localization keys giữ | `language` |
| E3 | VALIDATE-BEFORE-CODE | #14, #18 | Lite mode device default chưa rõ; cần đo, không đoán | `liteMode` |
| E4 | PROTECTED-KEEP | #17, #20 | Vitals enabled flag & live data giữ | `duocarVitalsEnabled` |
| E5 | PROTECTED-KEEP | #17, #20 | Fullscreen vitals config giữ, không đổi anchor | `duocarFullscreenVitalsEnabled` |
| E6 | PROTECTED-KEEP | #17, #20 | Thermal test37 default NO giữ, không phát sinh mô phỏng trong UI | `duocarThermalTest37Enabled` |
| E7 | PROTECTED-KEEP | #15 | Split enable/autolaunch key+default giữ | `splitScreenEnabled / splitScreenAutoLaunch` |
| E8 | PROTECTED-KEEP | #15, #16 | Show recent/favorites giữ logic | `splitScreenShowRecent / ShowFavorites` |
| E9 | PROTECTED-KEEP | #15, #16 | Pinned app bundle giữ key và guard | `splitScreenPinnedApp` |
| E10 | PROTECTED-KEEP | #18 | Home grid rows/cols/names/blur/dim preference giữ | `homeScreen*` |
| E11 | VALIDATE-BEFORE-CODE | #18 | Car profile model shape mismatch cần guard; không sửa data trong skin | `carProfiles` |
| E12 | PROTECTED-KEEP | #23 | onboardingDone state key giữ | `onboardingDone` |
| E13 | PROTECTED-KEEP | #23 | whatsNewSeen state key giữ | `whatsNewSeen` |
| E14 | PROTECTED-KEEP | #09 | Splash one-shot per connection giữ | `StartupScreen claim` |
| E15 | VALIDATE-BEFORE-CODE | #02, #03 | HL46 guard chỉ nằm ở CarPlay; không suy ra từ prefs | `HL46` |
| E16 | PROTECTED-KEEP | #02, #03 | HL49 historic comments, active branch HL51; không đổi | `HL49 / HL51` |
| E17 | PROTECTED-KEEP | #07, #20 | HL57 vitals changes giữ semantic | `HL57` |
| E18 | VALIDATE-BEFORE-CODE | #07, #20 | Native/hosted HUD parity unknown: test, không fake | `E18` |
| E19 | PROTECTED-KEEP | #22 | Preferences domain ABI giữ nguyên dù đổi nhãn DuoCar | `com.anlai.omnicar` |

## Cổng định nghĩa 100% (không tuyên bố PASS trước)
1. **Inventory:** tất cả 112/112 ID có owner/policy/nguồn (bảng trên), trừ `PROTECTED-KEEP`/metadata không cần redraw nhưng cần chứng minh không mất.
2. **Visual:** từng surface `G1-REDESIGN` phải có ảnh OLD từ DEB/device có provenance + ảnh NEW runtime trên **cùng frame**, đối chiếu không cùng hierarchy cũ trừ khung/hit bắt buộc. Artboard tĩnh không chứng minh.
3. **Technical:** project/src mirror, source file:hunk, hash, no illegal key/IPC/scene change, no false data, test native + hosted + iPhone.
4. **Device:** mỗi feature đang có vẫn làm được trên DEB thật; full/float/keyboard/resizing/AutoHide/reconnect, no overlayer black screens. Build xanh không đủ.

## Lỗ hổng chưa đo/đã biết
G0 ghi 5 UNKNOWN: B-N5 tray window level (Muse R0 chứng minh +65 ở source, chưa tự xác nhận device); B-N12 original ratio panel frame; B-N18 HL50 behavior; P5 nested prefs geometry; E3 liteMode device default. Muse không được điền số đo dự đoán. G2 R0 xác nhận Fullspace chỉ giãn toàn split; chọn riêng một pane+pinch-in restore chưa có: disable sector cho tới giải pháp.
