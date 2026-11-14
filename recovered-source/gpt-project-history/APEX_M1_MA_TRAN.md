# APEX M1 — MA TRẬN PHỦ 100% (D1–D14 + A1)

> Mốc: M1 DuoCar APEX — design-only, KHÔNG sửa source.
> Baseline khóa: HL61 `298b7b4a8432037d71db441d0975aca1db1f6e04`.
> Căn cứ file/method/số dòng: `MA_TRAN_M0_APEX.md` tại HL61 (cây `project/` là nguồn build thật).
> Quy ước ảnh: cột "Ảnh cũ" = file `-truoc` (dựng lại từ source, không phải ảnh thiết bị); cột "Ảnh APEX" = file `-sau` (mockup đề xuất). Ảnh CarPlay có thêm bản `-2x` (1280×720) cho mỗi file.
> Trạng thái mọi hàng: **CHỜ NGUYEN DUYỆT**.

---

## 1. BẢNG PHỦ

| ID | Ảnh cũ (file) | Ảnh APEX (file) | Token/spec áp dụng | Nguồn component (file/method tại HL61) | Trạng thái |
|---|---|---|---|---|---|
| **D1** Thanh lệnh split + hosted | `carplay-split-truoc.png` (+`-2x`), `carplay-hosted-truoc.png` (+`-2x`) | `carplay-split-sau.png` (+`-2x`), `carplay-hosted-sau.png` (+`-2x`) | Thanh Slate `#1F303D`, bo 14, viền 1pt line `#2C4356`*, nút Ø36/glyph 20, chọn = Teal `#2EA6BB` + viền cyan `#61D9F2`, đóng đỏ chờ chọn; một bộ icon `hm_apps/hm_full/hm_float/hm_min/hm_close` + `hm_split` dùng chung hai phía (SPEC §3.1) | build: `project/OmniCarSplitScreen/SCPCarSplit+Chrome.m` — `SCPBarButton :132`, `-setupBarForPane: :161` (thanh 52pt); `project/OmniCarAppBridge/ABHostBMethods.m` — glyph `hm_* :387–490`, `-buildBarForPane: :1158` (52pt) | CHỜ NGUYEN DUYỆT |
| **D2** Handle pill split + hosted | `carplay-split-truoc.png` (+`-2x`), `carplay-hosted-truoc.png` (+`-2x`) | `carplay-split-sau.png` (+`-2x`), `carplay-hosted-sau.png` (+`-2x`) | Pill 34×12 bo 6, nền surface2 `#27394A`*, chấm cyan; **vùng chạm 44×24 giữ nguyên** (SPEC §3.2) | build: `SCPCarSplit+Chrome.m -setupBarForPane: :161` (pill 34×12, chấm x=9/17/25); `ABHostBMethods.m -setupHandleForPane: :1317`, `-setHandleVisible:forPane: :1350` | CHỜ NGUYEN DUYỆT |
| **D3** Picker sheet | `carplay-picker-native-truoc.png` (+`-2x`), `carplay-picker-hosted-truoc.png` (+`-2x`) | `carplay-picker-native-sau.png` (+`-2x`), `carplay-picker-hosted-sau.png` (+`-2x`) | Sheet Slate bo 14 + viền 1pt + glow Teal; ô app bo 12, icon Ø52, nhãn 13/11; chấm trang cyan (SPEC §3.4); cỡ sheet C3 giữ nguyên | build: `project/OmniCarSplitScreen/SCPCarSplit+Picker.m` (2.019 dòng) — `-showPickerForSlot: :344`, `-buildPickerSheetForPane: :662`, `-trayWindowForParent: :1505` (level +65 `:1582`) | CHỜ NGUYEN DUYỆT — **DEVICE PENDING (U11)**: trạng thái picker trên xe sau vá HL51 chưa có kết luận xe mới |
| **D4** Divider + knob + menu tỉ lệ | `carplay-split-truoc.png` (+`-2x`) | `carplay-split-sau.png` (+`-2x`) | Knob Slate viền cyan 2pt + glow Teal; vòng menu tỉ lệ cyan/Teal/Ice white thay conic 4 màu cũ (SPEC §3.3); frame/hit/relay C4 giữ nguyên | build: `project/OmniCarSplitScreen/SCPCarDividerView.m` vẽ knob `:51–84`; `+Divider.m -saveRatio :334` (F10, không đụng), `-ratioPresets :353`; `+Layout.m -layoutKnobOf: :591`; `+RatioMenu.m -showRatioMenuForDivider: :361`, `-hideRatioMenu :465` | CHỜ NGUYEN DUYỆT |
| **D5** Cài đặt trong app iPhone (3 tab → 5 mục) | `iphone-bang-dieu-khien-truoc.png`, `iphone-bo-cuc-truoc.png`, `iphone-ung-dung-truoc.png`, `iphone-thiet-bi-truoc.png`, `iphone-tuy-chinh-truoc.png` | `iphone-bang-dieu-khien-sau.png`, `iphone-bo-cuc-sau.png`, `iphone-ung-dung-sau.png`, `iphone-thiet-bi-sau.png`, `iphone-tuy-chinh-sau.png` | Hệ màu APEX thêm mới (Graphite/Slate/cyan/Ice white) trên nền màu hệ thống cũ; thẻ bo 14 viền 1pt; switch/slider theo SPEC §3.5; cấu trúc 5 mục + nhãn 9 (SPEC §4) | build: `project/OmniCarApp/OMCNativeSettings.m` (1.271 dòng) — `OMCNativeSettingsRootController() :1253` (tab `:1261/:1263/:1265`, `selectedIndex=2 :1267`), `-makeSections :437`, `OMCNativeSetPref :26` (thân `:30–37`, F10) | CHỜ NGUYEN DUYỆT — **DEVICE PENDING (U8/U10)**: điểm ghi `duocarVitalsEnabled` (U8) và mặc định vitals (U10) chưa chốt ở M0 |
| **D6** Trang Startup trong app | `iphone-startup-truoc.png` | `iphone-startup-sau.png` | Header/gallery/bố cục tông APEX; key startup C5 giữ nguyên (SPEC §4.4) | build: `project/OmniCarApp/OMCNativeStartup.m` (676 dòng) — `OMCNativeStartupPage` impl `:77`, `refreshGallery :108`, `styleSelected: :145`, `saveLogo: :566`, factory `:674` | CHỜ NGUYEN DUYỆT |
| **D7** Trang điều khiển Lề trong app | Trong `iphone-thiet-bi-truoc.png` | Trong `iphone-thiet-bi-sau.png` | Chỉ hình thức trang tông APEX (thẻ/switch/slider SPEC §3.5); giao thức giữ nguyên | build: `project/OmniCarApp/OMCLePrefsHost.m` (253 dòng) — `DCLLeStandaloneControls` impl `:30`, `-masterChanged: :174`, slider GPS −10..+10 (`-gpsChanged: :177`, `-gpsEnded: :185`), `-enqueueKey:raw: :164` (F9, tránh) | CHỜ NGUYEN DUYỆT |
| **D8** Trang vitals trong app | Trong `iphone-thiet-bi-truoc.png` + `iphone-bang-dieu-khien-truoc.png` (phần chỉ số) | Trong `iphone-thiet-bi-sau.png` + `iphone-bang-dieu-khien-sau.png` (phần chỉ số) | Toàn trang tông APEX; chữ Ice white, số liệu cyan | build: `project/OmniCarApp/OMCDeviceVitalsController.m` (117 dòng) — `OMCVitalsPage` impl `:13`, `-updateVitals :83`, factory `:115` | CHỜ NGUYEN DUYỆT — gắn cùng **DEVICE PENDING (U10)** qua mặc định vitals |
| **D9** Màn khởi động trên xe (splash + cảnh) | `carplay-startup-truoc.png` (+`-2x`) | `carplay-startup-sau.png` (+`-2x`) | Nền Graphite thay tím đậm `0x1B0B3A→0x3B1A78`; logo APEX; chữ Ice white, nhấn cyan/Teal; style qua cùng dispatch `ss_buildScene` (SPEC §3.7) | build: `project/OmniCarStartupScreen/SSSplash.m` (458 dòng) — `windowLevel Alert+1000 :175`, `-start :185`, `-dismissBecause: :298`, `-tearDown :314`; `SSStartupView.m` (1.149), `SSStartupViewBuilders.m` (1.229), `SSStartupViewScenesB.m` (699; tím `:287`) | CHỜ NGUYEN DUYỆT |
| **D10** Vitals trên xe (HUD Dock + hàng trạng thái fullscreen) | `carplay-fullscreen-truoc.png` (+`-2x`); phần chỉ số trong `iphone-bang-dieu-khien-truoc.png` | `carplay-fullscreen-sau.png` (+`-2x`); phần chỉ số trong `iphone-bang-dieu-khien-sau.png` | Chữ Ice white, số liệu cyan, nhãn phụ sub `#8FA6B3`*; vị trí/mức cửa sổ (+64.0/+64.5) và xuyên chạm giữ nguyên C9 (SPEC §3.6) | build: `project/OmniCarSplitScreen/SCPDeviceVitalsHUD.m` (519 dòng) — impl `:32`, `-showForParent:… :421`, `SCPVitalsNativeDockView :239`, nhãn `:195–218`; `SCPFullscreenVitalsBubble.m` (399 dòng) — cửa sổ `:30` (level +64.0 `:78`), `-layoutStatusLine :234`, `-tick :247` | CHỜ NGUYEN DUYỆT — **DEVICE PENDING (U8/U10)** |
| **D11** Home xe (nền, blur, dim, tên icon) | `carplay-home-truoc.png` (+`-2x`) | `carplay-home-sau.png` (+`-2x`) | Nền/blur/dim tông Graphite/Slate; tên icon Ice white; icon Home 76; lưới C10 giữ nguyên | build: `project/OmniCarSplitScreen/SCPHomeLauncher.m` (722 dòng) — `SCPHomeLauncherInjectInfo :73`, `SCPHomeLauncherEnsureInLibrary :127`; `SCPAppIcons.m` — `SCPInjectDeclarationIfChosen :157` (F4, không đụng khối tiêm), `SCPAddChosenAppsToLibrary :275`; `SCPHooks.m Hook_newApplicationLibrary :87` | CHỜ NGUYEN DUYỆT |
| **D12** Icon app/Prefs + ảnh PNG Resources | `bang-nhan-dien.png` (nửa cũ: logo play + mesh pastel) — mục Home icon + bộ icon | `bang-nhan-dien.png` (nửa APEX: biểu tượng hai ô chia màn + Home icon APEX) | Thay toàn bộ artwork bằng bộ APEX: nền Graphite, hai ô Slate/cyan, knob cyan; cỡ Home icon 60–180 phía iPhone, 76 trên xe | build: `project/OmniCarApp/Resources/` (AppIcon60x60@2x/@3x, khai `Info.plist:22–25`), `project/OmniCarPrefs/Resources/` (`logo.png` ×3 nạp tại `OMCHeaderCard.m:47`, `PackageIcon.png`, `icon.png` ×3); toàn cây 15 PNG, 0 storyboard/xib/Assets.car | CHỜ NGUYEN DUYỆT (kèm quyết định logo: duyệt / sửa / bác) |
| **D13** Bàn phím hosted tự vẽ — CHỈ hình thức | `carplay-keyboard-truoc.png` (+`-2x`) | `carplay-keyboard-sau.png` (+`-2x`) | Phím Slate/surface2, ký tự Ice white, nhấn cyan, bo góc + nhãn phụ APEX; **bố cục/value/command/Telex giữ nguyên** C11/F8 (SPEC §3.8) | build: `project/OmniCarAppBridge/ABKeyboard.m` (848 dòng) — `-[ABKey paint:] :175`, `-buildPanel :487`, `-layoutPanelIn: :571`, `-rebuildKeys :595`, `-layoutKeys :670`, `-send:del:text: :254`, factory `:767/:788`; cờ `ABDrawnKb = YES` tại `ABInApp.m:549` | CHỜ NGUYEN DUYỆT — **DEVICE PENDING (U3)**: trạng thái xe chưa kết luận (HL41 fail, HL43 pending; lệnh cũ "native-locked" mâu thuẫn source). Lô M3-9 chỉ làm sau khi chốt U3 |
| **D14** Prefs bundle (Settings.app) — hình thức, **ưu tiên thấp**, không phải đường cài đặt hiện hành | Trong `iphone-tuy-chinh-truoc.png` (hình thức Prefs) | Trong `iphone-tuy-chinh-sau.png` (hình thức Prefs) | Nhấn tím cũ (`0x7B6CF6`/`0xA89BFF`, họ `#8B7CFF`) → cyan/Teal APEX; mesh Prefs → nhận diện APEX; ghi rõ ưu tiên thấp, lô M2-5 làm cuối M2 | build: `project/OmniCarPrefs/OMCCommon.m` — `OMCAccentColor :282`, `OMCStyleTable :388–398`, `OMCIcon :480`, mesh `:518–546` (cùng file chứa Expiry `:205` + Rescue `:301` — F12, hunk phải duyệt trước); `OMCHeaderCard.m` gradient `:38–41`, logo `:47` | CHỜ NGUYEN DUYỆT |
| **A1** Cảnh báo nhiệt viền đỏ nhấp nháy, giữa trong suốt (MỚI HL61) | Không có file `-truoc` riêng trong danh sách ảnh khóa: bề mặt này không tồn tại ở DC58; phía "trước" là hình thức HL61 hiện tại dựng từ source (viền `#FF0610`), trình bày đối chiếu trong cùng một ảnh | `canh-bao-nhiet.png` (file duy nhất của A1 theo danh sách khóa; chứa đối chiếu hai lựa chọn đỏ) | Giữ nguyên mọi số source: inset 5/7pt + inset 12/1.5pt, bo 15, glow blur 12, pulse 0.45→1.0 chu kỳ 0.75s, chữ duy nhất 28 bold trắng (SPEC §3.9); chỉ điểm màu đỏ chờ chọn `#FF0610` / `#FF4757` | build: `project/OmniCarSplitScreen/SCPThermalEdgeWarning.h` (70 dòng) — `SCPThermalEdgeWarningCreate :9` (viền ngoài `:24`, pulse `:31–37`, viền trong `:39–47`, chữ `:58`); gọi tại `SCPDeviceVitalsHUD.m -showThermalWarningInParent: :68`, `SCPFullscreenVitalsBubble.m -updateThermalWarningWithSample:now: :202` | CHỜ NGUYEN DUYỆT — HL61 chưa build/chưa test xe: hình thức [ĐÃ ĐO TẠI SOURCE], hiệu quả xe [CHƯA XÁC MINH] (M0 Mục 5.1) |

> Ghi chú tên file A1: danh sách ảnh khóa của M1 chỉ có một file `canh-bao-nhiet.png` cho A1 (không có cặp `-truoc/-sau` như các trạng thái khác) — ảnh này trình bày đối chiếu hai lựa chọn đỏ trong cùng một hình. Dòng A1 ở trên ghi rõ điều này thay vì bịa thêm tên file.

---

## 2. HỢP ĐỒNG BẢO VỆ — A2 / A3 (KHÔNG THUỘC THIẾT KẾ LẠI)

### A2 — Cổng nhiệt liên tục 37°C + công tắc giả lập (MỚI HL60) — LOGIC KHÓA CỨNG

- Nguồn: `SCPThermalAlarm.h` (25 dòng) — `SCPThermalAlarmStep :13`; `realHot = tempC >= 37.0 :19`; `active = realHot || simulated :21`. Hàng switch: `OMCNativeSettings.m:474–475`, pref `duocarThermalTest37Enabled`, mặc định NO. Notify `com.anlai.omnicar/thermaltest37.changed` phát tại `OMCNativeSetPref :30–37`, nghe tại `SCPDeviceVitalsHUD -init :41–57` và `SCPFullscreenVitalsBubble -init :112–136`. Timer mẫu 3 giây: HUD `-startThermalForParent: :145–157`; Bubble `-tick :247`.
- Ràng buộc: **F14 (cổng nhiệt — CẤM)**, F10 (pref + notify qua hàm ghi pref), F5 (kênh notify).
- Phạm vi M1/M2 duy nhất: **hình thức hàng công tắc** đi theo lô D5 (M2-4) — và hunk hàng switch trong `-makeSections` thuộc diện báo trước chờ duyệt (F10/C5). Ngoài hình thức hàng, không đề xuất đổi ngưỡng 37°C, logic `active`, pref, notify hay chu kỳ mẫu ở bất kỳ mốc nào của APEX.
- Điểm chưa xác minh (M0 Mục 5.2): hệ quả của việc bỏ điều kiện nguồn "battery" khi lấy mẫu nhiệt — file sinh mẫu `OMCDeviceVitals.m` không nằm trong diff DC58→HL61 và chưa đọc lại ở M0.

### A3 — Lớp nâng bong bóng Lề `[hl59-layer]` (MỚI HL59) — KHÓA CỨNG F9

- Nguồn: `project/OmniCarLeExtension/DCLLeExtension.m` (346 dòng) — `DCLPeerWindow :90`; `DCLRaiseOriginalBubble :129–165` (gán `windowLevel = peer.windowLevel + 2.0 :149–152`, chặn trần `< UIWindowLevelAlert − 1`, chỉ nâng không hạ); hook `:216/:222/:226/:231/:235`; handler master ON/OFF `:324–325`.
- Ràng buộc: **F9 (cầu Lề — CẤM)**, F5. **KHÔNG đụng `DCLLeExtension.m`** ở mọi mốc APEX.
- Bề mặt này không có phần vẽ của DuoCar (bong bóng là của hãng) — ghi vào ma trận chỉ để bản đồ mức cửa sổ đúng: bong bóng hãng có thể nằm TRÊN logo tròn DuoCar và TRÊN app hosted. Kết quả xe theo hồ sơ: DC59CL PASS riêng lớp này.
- Lưu ý hồ sơ: comment đầu file `DCLLeExtension.m:2–5` vẫn ghi "EXACTLY two functions… Never touch… windowLevel" — mâu thuẫn chính code của nó (M0 Mục 4.2); M1 chỉ ghi nhận, không đề xuất sửa.

---

## 3. NGOẠI LỆ — KHÔNG THUỘC DUOCAR, KHÔNG ÁP TÔNG APEX

| Bề mặt | Lý do ngoại lệ |
|---|---|
| Giao diện iOS gốc (Settings.app hệ thống, bàn phím gốc, chrome hệ thống) | Của iOS — DuoCar không sở hữu; D14 chỉ là hình thức bundle Prefs của DuoCar hiển thị trong đó, không đổi giao diện hệ thống |
| Google Maps / bản đồ native và các app CarPlay native khác | Nội dung của app bên thứ ba — giữ màu gốc trong mockup (hàm `draw_map_pane` riêng trong `apex_style.py`), không nhuộm APEX |
| YouTube / app hosted nói chung | Giao diện của app được host — giữ màu gốc (hàm `draw_video_pane`); DuoCar chỉ sở hữu thanh lệnh/handle phủ lên (D1/D2 phía hosted) |
| Bong bóng của vendor Lề (bong bóng hãng gốc) | Của hãng — APEX không thiết kế lại. Phần thuộc DuoCar chỉ là **shim điều khiển** (`OMCLePrefsHost.m` phía app — D7 chỉ hình thức; `DCLLeExtension.m` phía extension — A3 khóa cứng F9, không đụng) |

Không tính hàng thiết kế (giữ nguyên trạng thái audit DC58 theo M0): N1 SpeedBubble gốc `SPP*` (forensic, không vào gói), N2 Voice `SCPVoice*/DCVoice*` (loại khỏi build từ HL36), N3 LeTraffic `DCLTraffic*` (chưa tích hợp).

---

## 4. ĐỀ XUẤT LÔ M2/M3 — CHỈ ĐỀ XUẤT, CHƯA THỰC HIỆN

Chép lại thứ tự lô từ Mục 6 ma trận M0. Nguyên tắc của M0: mỗi lô = một bề mặt/một nhóm file riêng, không chồng lấn giữa các người làm; commit nhỏ, revert độc lập; hunk thuộc Mục 3 của ma trận M0 (file dùng chung đụng vùng F/C) phải **báo trước và chờ duyệt** mới được vào lô. Thứ tự trong mỗi mốc đi từ rủi ro thấp tới cao.

**Trạng thái toàn bộ mục này: CHỈ ĐỀ XUẤT — CHƯA THỰC HIỆN. M1 không sửa source nào.**

### M2 — iPhone

1. **Lô M2-1 · D12 Assets**: thay AppIcon + toàn bộ PNG nhận diện cũ (logo/PackageIcon/icon) bằng bộ APEX. Thuần tài nguyên + khai plist giữ nguyên tên file. Rủi ro thấp nhất, làm đầu để khóa nhận diện.
2. **Lô M2-2 · D8 + D7 hình thức**: trang vitals (file riêng, ít điểm chạm) và trang Lề (chỉ hình thức; giao thức F9 không đụng; tránh `-enqueueKey:raw:`).
3. **Lô M2-3 · D6 Trang Startup trong app**: header/gallery/bố cục; không đụng đường nạp logo runtime của người dùng.
4. **Lô M2-4 · D5 Cài đặt — chia 3 commit con**: (i) áp hệ màu/phong cách APEX giữ nguyên cấu trúc 3 tab và ánh xạ hàng→key; (ii) tách mục mới (Bảng điều khiển / Tùy chỉnh) thành trang mới, không đổi hàng cũ; (iii) preview split + chọn app trực quan. Mọi hunk đụng `OMCNativeSetPref` hoặc ánh xạ key/default trong `-makeSections` tách riêng, báo trước theo F10/C5 (gồm cả hàng công tắc A2). — **Hunk F10/C5 của lô này thuộc diện BÁO-TRƯỚC-CHỜ-DUYỆT.**
5. **Lô M2-5 · D14 Prefs bundle**: hình thức controllers + header card; hunk trong `OmniCarPrefs/OMCCommon.m` (mesh/màu) tách riêng chờ duyệt (C7/F12); ưu tiên thấp, làm cuối M2.

### M3 — CarPlay

0. **Lô M3-0 · C7 Mesh dùng chung** — **BÁO TRƯỚC — CHỜ DUYỆT** (nằm trong file lõi F12): đổi `OMCDrawLogoMesh`/`OMCLogoMeshImage` ở `OMCCommon.c` sang nhận diện APEX. Làm TRƯỚC các lô dùng mesh (D1/D3/D13) để không sửa hai lần; bản mesh riêng của Prefs đi cùng lô M2-5.
1. **Lô M3-1 · A1 Cảnh báo nhiệt viền**: chỉ `SCPThermalEdgeWarning.h` (màu/glow/chữ; quyết định ánh xạ đỏ `#FF4757` hay giữ `#FF0610` ghi trong commit). Không đụng method gọi, mức cửa sổ, xuyên chạm. Nhỏ và revert độc lập nhất ở phía xe — nhưng vẫn là bề mặt F14, commit phải ghi rõ chỉ đổi hình thức.
2. **Lô M3-2 · D10 Vitals chữ/màu**: chỉ các hunk nhãn/màu trong `SCPDeviceVitalsHUD.m` + `SCPFullscreenVitalsBubble.m`; tránh method gắn Dock/`showForParent` (F14/C9) — nếu chung hunk thì tách và báo trước.
3. **Lô M3-3 · Bộ icon `hm_*` dùng chung + D1 màu hai thanh**: factory glyph ở `+Chrome.m` (`:78/:132` theo M0 Mục 6) và `ABHostBMethods.m` (`:387–490`) trong cùng một lô để hai thanh không lệch nhau; tránh khối shield trong Chrome (F2).
4. **Lô M3-4 · D2 Handle pill hai phía**: giữ nguyên vùng chạm C1 (44×24 hosted; pill 34×12 split).
5. **Lô M3-5 · D4 Divider/knob + menu tỉ lệ**: chỉ khối vẽ; giữ frame/hit/relay C4; `-saveRatio` (F10) không đụng.
6. **Lô M3-6 · D3 Picker sheet**: hình thức lưới/icon/chấm trang; giữ cỡ sheet + mức tray C3; method `-trayWindowForParent:` không đụng.
7. **Lô M3-7 · D11 Home xe**: nền/blur/dim/tên icon; giữ lưới C10; khối declaration trong `SCPAppIcons.m`/`SCPHomeLauncher.m` (F4) không đụng.
8. **Lô M3-8 · D9 Màn khởi động**: cảnh/màu qua builders + dispatch `ss_buildScene`; **hunk `SSSplash.m` (C8 vòng đời) tách riêng chờ duyệt nếu bắt buộc** — thuộc diện BÁO-TRƯỚC-CHỜ-DUYỆT.
9. **Lô M3-9 · D13 Bàn phím hosted**: LÔ CUỐI — chỉ làm sau khi chốt U3 (trạng thái xe của đường phím vẽ). Chỉ `-paint:`/`-buildPanel` về hình thức; giữ bố cục/value/command (C11) và kiểm chứng Telex HL43 sau mỗi thay đổi.

### Tổng hợp các lô có hunk thuộc diện báo-trước-chờ-duyệt

| Lô | Hunk | Căn cứ |
|---|---|---|
| M3-0 | Mesh C7 trong `OMCCommon.c` (file lõi) | C7 / F12 |
| M2-4 | Hunk đụng `OMCNativeSetPref` / ánh xạ key-default trong `-makeSections` (gồm hàng công tắc A2) | F10 / C5 |
| M3-8 | Hunk `SSSplash.m` nếu bắt buộc phải chạm | C8 |
| (kèm theo) M2-5 | Hunk mesh/màu trong `OmniCarPrefs/OMCCommon.m` tách riêng chờ duyệt | C7 / F12 |

— Hết ma trận phủ M1. —
