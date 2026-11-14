# APEX M2/M3 — BẢN ĐỒ TRIỂN KHAI (file / method / hunk + map key/action)

**Ngày:** 2026-11-14. **Người lập:** Muse (tổng duyệt), từ 4 tuyến đọc source thật tại HL61.
**Nền:** `298b7b4a8432037d71db441d0975aca1db1f6e04`; nhánh `feature/duocar-apex-ui-muse-20261114`.
**Thiết kế áp dụng:** gói GPT V2 (commit `eab80668` + `9e80678`), Nguyen đã duyệt và ra lệnh làm (chat chính 14/11 16:38).
**Trạng thái:** bản đồ này là cổng ACCEPTANCE "BEFORE SOURCE M2/M3". Mọi hunk chạm vùng F/C được gắn cờ ⛔ CHỜ DUYỆT ở mục 5.

---

## 1. Nền gương project/ ↔ src/ — kết luận đối chiếu

- Nguồn build thật: `recovered-source/project/`. Mọi file chủ sở hữu của các lô M2/M3 đều **giống hệt từng byte** với bản gương `src/` (đã `cmp` từng cặp), NGOẠI TRỪ 2 file thuộc danh sách 7 file trôi của M0 mà APEX có liên quan:
  - `SCPHomeLauncher.m`: chỉ khác 4 dòng import (L13–16, tiền tố đường dẫn); thân 722 dòng giống hệt. → Lô D11 **không sửa file này** (xem D11 ở mục 3).
  - `OMCLePrefsHost.h`: chỉ khác comment đầu file (5 dòng); 3 khai báo hàm giống hệt. → Lô D7 **không sửa header**.
- 5 file trôi còn lại (`SCPCarSplit.m`, `SCPCarSplit+BridgeWake.m`, `SCPHomeApply.m`, `SCPHooks.m`, `SCPShared.m`) là engine/hook — **APEX không đụng**.
- Quy tắc: sửa ở `project/`; sau mỗi lô, chép đúng hunk sang bản gương `src/` tương ứng (trừ 2 file trên — không áp dụng vì không sửa). Resources của prefs không có bản gương trong `src/` (chỉ tồn tại ở `project/`).

## 2. Sự thật source quyết định phạm vi (đã đo, không suy đoán)

1. **A1 viền nhiệt — KHÔNG CẦN SỬA CODE.** `SCPThermalEdgeWarning.h` tại HL61 khớp từng hằng số với SPEC GPT V2 §4: inset ngoài 5pt (L17), border 7pt (L23), đỏ rgb(1.0, 0.025, 0.065) ≈ #FF0610 (L24), inner inset 12pt/1.5pt (L39/L45), pulse opacity 0.45→1.0, duration 0.75s (L31–36), chữ duy nhất "LÀM MÁT THIẾT BỊ CỦA BẠN" (L58), mọi lớp `userInteractionEnabled=NO`, nền clear. Hai cửa sổ chủ đều xuyên chạm (hitTest trả nil; split level StatusBar+64.5, fullscreen +64.0). Lô A1 = **kiểm chứng, 0 hunk**.
2. **D10 fullscreen — KHÔNG có capsule/nền ở bản hiện hành.** `SCPFullscreenVitalsBubble.m`: status view nền clear, cornerRadius 0, borderWidth 0, `userInteractionEnabled=NO` (L347–352), 1 hàng góc trên-trái (frame L297–319), chỉ hiện khi `fsCommittedState == Expanded` (L187–196). Phần APEX còn lại cho D10 chỉ là **màu/font/shadow của 2 label + nhãn vitals ở Dock** (HUD L483, L225–231). Method điều kiện hiện (L187–196) thuộc F7/F14 — **không đụng**.
3. **D11 Home — KHÔNG có code hình trong `SCPHomeLauncher.m` / `SCPAppIcons.m`** (grep UIColor/UIFont = 0). Icon + tên DuoCar trên Home xe lấy từ chính bundle app → toàn bộ D11 được thực hiện bằng **D12** (thay AppIcon trong Resources). Registration (`SCPHomeLauncherInjectInfo` L73–125, `SCPInjectDeclarationIfChosen` L157–255) và launch (L466–506) **không đụng**.
4. **Phía iPhone (D5–D8) KHÔNG có màu hardcode nào** — toàn màu hệ thống động. Đổi tông = THÊM lớp token APEX vào các điểm tạo view đã xác định, không phải quét màu cũ.
5. **Hình học chrome khớp SPEC ở mọi điểm kiểm:** bar 52pt (Chrome.m L248; ABHostBMethods.m L1178), handle visual 34×12 (Chrome.m L188; ABHostBMethods L1319), hitbox hosted 44×24 (ABHostBMethods L1318 — chỉ phía AppBridge), picker `cols×62+20` (Picker.m L742), cột phụ +150 (L746), tray window StatusBar+65 (L1582). **Không lô nào cần đổi hình học.**
6. **Glyph `hm_*` đã tồn tại trong source** với đúng tên GPT dùng (hm_apps/hm_full/hm_split/hm_float/hm_min/hm_close + hm_back/hm_gear ở asset GPT là MỚI — source chưa có hai tên này; chỉ đưa vào nếu có nút thật dùng, hiện tại không nút nào dùng → không thêm). Glyph hiện vẽ bằng 2 renderer riêng: `SCPDrawSymbolIcon` (RatioMenu.m L62–222, nhánh hm_ L180–221, nét 1.5, lưới 24) cho phía SplitScreen và `ABSetBarButtonContent` (ABHostBMethods.m L401–504) cho phía AppBridge. Selector hai phía KHÁC nhau và giữ nguyên từng phía: SplitScreen `paneChoose:/paneSolo:/panePopOut:/paneBackground:/paneClose:`; AppBridge `barReplace:/barFull:/barPop:/barBackground:/barClose:`. Tag view icon `0x1C86` cả hai phía.

## 3. Bản đồ theo lô

### M2-1 · D12 — Tài nguyên nhận diện (0 hunk code)
- Xuất từ SVG của GPT bằng cairosvg, đúng kích thước khai báo thật:
  - `assets/duocar-apex-home.svg` → `project/OmniCarApp/Resources/AppIcon60x60@2x.png` (120), `AppIcon60x60@3x.png` (180); `project/OmniCarPrefs/Resources/PackageIcon.png` (256), `icon.png` (29), `icon@2x.png` (58), `icon@3x.png` (87).
  - `assets/duocar-apex-mark.svg` → `project/OmniCarPrefs/Resources/logo.png` (64), `logo@2x.png` (128), `logo@3x.png` (192) — logo nạp tại `OMCHeaderCard.m:47`, hiện ở thẻ 44×44.
- Không đổi: tên file, `Info.plist` (CFBundleIconFiles = AppIcon60x60, L22–25), bundle id, `SpeedBubbleIcon*`/`StartupScreenIcon*` (icon tính năng, không phải nhận diện hãng — GPT không cấp bản thay).

### M2-2 · D8 — Trang vitals iPhone (`project/OmniCarApp/OMCDeviceVitalsController.m`, 117 dòng)
- Hunk hình thức: `lineWithSize:strong:` (L15–24) + `viewDidLoad` (L25–64): thêm màu token (nhãn chính Ice, phụ #93AAB8), nền trang Graphite, nút Làm mới tint cyan.
- **File này đọc/ghi 0 pref key, phát 0 notify** (dữ liệu qua `OMCDeviceVitalsSample()` từ OMCCommon) — rủi ro thấp nhất phía iPhone.

### M2-3 · D7 — Trang Lề trong app (`project/OmniCarApp/OMCLePrefsHost.m`, 253 dòng)
- Hunk hình thức DUY NHẤT ở: nền bảng (L40–72), nhãn header (font/màu), cell section 1 (nhãn giá trị đang `systemBlueColor` → cyan token; slider tint), footer.
- ⛔ KHÔNG ĐỤNG (F9 — hợp đồng HL59): kênh `com.chuong.duocar/le024.cfg` / `.ack` (L11–12), định dạng gói (magic 0x4C45/0xAC49, L188–246), key logic 4 (bong bóng) + 27 (GPS raw = bù + 10), timeout ACK 3s, các action `masterChanged:`/`gpsChanged:`/`gpsEnded:`, logic khóa điều khiển chờ ACK (L97–99). Header `.h` không sửa (xem mục 1).

### M2-4 · D6 — Trang Startup iPhone (`project/OmniCarApp/OMCNativeStartup.m`, 676 dòng)
- Hunk hình thức: header preview (L86–107: `previewImage` radius 14 giữ, màu nền → surface.1; `previewLabel`), `refreshGallery` (L108–136: nút style — nền chọn → surface.2 + viền cyan thay `tertiarySystemFillColor`), cell destructive giữ `systemRedColor` → đổi `danger.control` #FF4757 là hunk màu thuần.
- KHÔNG ĐỤNG: toàn bộ key `startupScreen*` + schema `FeatureStartupScreen.plist`, hợp đồng thư mục `/var/mobile/Library/OmniCar/StartupScreen` (+ `.frames` v2, `Logo/logo.png`), các action/media handler (L291–673).

### M2-5 · D5 — App iPhone (`project/OmniCarApp/OMCNativeSettings.m`, 1.271 dòng)
- **Phần A — hình thức trên cấu trúc hiện tại (làm ngay):** thẻ header kind 0 (`viewDidLoad` L544–590: card 120pt radius 15 → token surface + tiêu đề "DuoCar" giữ nguyên chữ), màu detail/detailTextLabel (L625–668), tint tab bar + nav bar, màu nền grouped → Graphite/surface theo token; giữ nguyên 3 tab, mọi hàng, mọi handler.
- **Phần B — cấu trúc 5 mục (Bảng điều khiển / Bố cục / Ứng dụng / Thiết bị / Tùy chỉnh):** SPEC GPT §3 yêu cầu trình sơ đồ chuyển tiếp/route + mapping key trước, chờ duyệt hunk C5/F10. Đề xuất route: RootController (L1253–1271) từ 3 tab → 5 vùng điều hướng BẰNG cách tái dùng nguyên các page class hiện có (AppsPage; SimplePage kind 1 = Bố cục; SimplePage kind 0 tách Thiết bị = trang vitals + nhóm Thiết bị; Tùy chỉnh = các nhóm còn lại của kind 0) — **không tạo prefs domain/key mới**, mọi hàng giữ đúng key/action ở mục 4. Phần B chỉ code sau khi GPT + Nguyen duyệt sơ đồ này.
- KHÔNG ĐỤNG: `OMCNativePref`/`OMCNativeSetPref` (L18–41) + nhánh notify riêng `thermaltest37.changed` (L35–36), kênh respring NSDistributedNotification (L861–892), `isHomeProtected:` (L379–384), hợp đồng file nền Home (L894–1096).

### M2-6 · D14 — Prefs bundle (`project/OmniCarPrefs/OMCCommon.m` 1.212 dòng + `OMCHeaderCard.m` 120 dòng)
- Hai lõi "OMCCommon" KHÁC nhau: bản prefs (file này) chỉ link vào bundle prefs; lõi C dùng chung ở `project/OMCCommon/OMCCommon.c` là file khác — sửa bản prefs **không lan** ra app/dylib. Trong bundle, 16/22 file dùng các hàm style này → đổi tại đây = đổi toàn bộ trang Cài đặt.
- Hunk hình thức theo từng hàm (surgical): `OMCAccentColor` L282 (tím 0x7B6CF6/0xA89BFF → cyan #61D9F2), `OMCBackgroundColor` L285, `OMCStyleTable` L389, `OMCStyleCell` L402, `OMCStyleGlassCard` L420, `OMCIcon` L480 (4 palette gradient → họ cyan/teal/graphite), `OMCLogoMeshImage` (bản prefs) L518 (mesh tím → nền graphite + blob cyan/teal), `OMCHeaderCard.m` gradient L32–34 (→ titanium/graphite), radius/shadow giữ; logo đã thay ở M2-1.
- ⛔ CẤM ĐỤNG trong cùng file: `OMCExpired`/đọc `trustedTime` (L226–254, hạn 2027-05-01), `OMCProfileKeys` (L246–254), `OMCRescueRestore` (L317–325) và các hàm đọc/ghi pref (L31–105, L696–1074). Các hàm style nằm L257–546 — hunk phải cắt đúng biên hàm, tổng duyệt diff từng hàm trước commit.

### M3-0 · Mesh dùng chung trên xe ⛔ CHỜ DUYỆT (quyết định riêng)
- Mesh trên chrome xe đến từ **lõi C dùng chung** `OMCCommon.c:1667 OMCLogoMeshImage(int style)` (palette pastel), được gọi ở `SCPApplyMeshBackdrop` (Chrome.m L43–55), ABHostBMethods (L1190), ABKeyboard panel (L500), SPPBubble (N1 forensic). Đổi mesh tại lõi = đổi cả bong bóng tốc độ N1 (ngoài phạm vi APEX). Hai phương án trình duyệt: **(i)** giữ nguyên hàm lõi, chrome APEX ngừng gọi mesh và thay bằng mặt kính graphite thuần (hunk nằm trong file chrome, không đụng lõi); **(ii)** đổi style 0 của lõi sang graphite (đụng N1 — không khuyến nghị). Muse đề xuất (i).

### M3-1 · A1 — Kiểm chứng, 0 hunk (xem mục 2.1).

### M3-2 · D10 — Vitals trên xe
- `SCPFullscreenVitalsBubble.m`: hunk màu/font ở 2 label (L355–374) + chuỗi metrics (L279) — đổi sang token (chữ Ice, shadow giữ), **không** đụng frame (L297–319), cửa sổ (L30–86), điều kiện hiện (L187–196), teardown (L164–186).
- `SCPDeviceVitalsHUD.m`: hunk màu nhãn dock (L225–231: ấm rgb(1,0.91,0.65) → amber token #F4B75F; nghiêm trọng giữ đỏ), font nhãn (L483). Không đụng slot dock (L316–420), `showForParent:` (L421–517), cửa sổ nhiệt (L68–158).

### M3-3 · D1/D2 — Glyph + thanh lệnh + handle
- Thay **tọa độ path** của nhánh `hm_` trong `SCPDrawSymbolIcon` (RatioMenu.m L180–221) và trong `ABSetBarButtonContent` (ABHostBMethods.m L401–504) bằng hình học từ SVG `hm_*.svg` của GPT (quy về lưới 24×24, nét 1.8–2.2 theo SPEC §4). Giữ: tên glyph, cỡ 22, cache, tag 0x1C86, selector từng phía, thứ tự nút, vách ngăn.
- Màu: `SCPStyleChip` (Chrome.m L73–88), `SCPStyleRatioMenu` (RatioMenu.m L339–358 — phần mesh theo M3-0), plate AppBridge (ABHostBMethods L507–531), handle pill + chấm (Chrome.m L186–206; ABHostBMethods L1314–1347), accent gradient khi bật (Chrome.m L97–127; ABHostBMethods L356–381 — gradient tím → cyan/teal, giữ cơ chế bật/tắt + việc tô lại chấm phía AppBridge). Tint nút: navy (74,79,128) → Ice; close giữ đỏ (danger.control #FF4757 phía AppBridge L1163–1172 hiện rgb(1,90,95) ≈ #FF5A5F → chuẩn hoá #FF4757 là hunk màu thuần; phía SplitScreen đỏ rgb(1,0.3529,0.3725) ≈ #FF5A5E → cùng chuẩn hoá).
- KHÔNG ĐỤNG: hình học (mục 2.5), hẹn giờ tự ẩn 4.0s (Chrome.m L374–378), `setBarVisible:`/`layoutBarForPane:` logic, khiên popup (L477–570), relay cử chỉ handle (ABHostBMethods L986–1040), AutoHide/wake call sites (Chrome.m L324–325).

### M3-4 · D4 — Divider/knob/menu tỉ lệ
- Hunk hình thức: gradient active của knob `SCPSetKnobActive` (DividerView.m L49–94: tím → cyan/teal; scale 1.6 + cơ chế giữ), vòng chọn preset `SCPMarkRatioChipSelected` (RatioMenu.m L313–337: conic 4 màu → vòng cyan đơn sắc), mặt knob (Layout.m L590–668: nền trắng 0.35 → surface kính; chấm navy → Ice), glyph preset `SCPDrawPresetGlyph` (L296–327, chỉ tint qua template).
- KHÔNG ĐỤNG: `pointInside` nới −26/−6 (DividerView.m L113–123), snap fraction + ngưỡng đóng ô (Divider.m L31–45, L151+), `dividerTapOn:`/`remoteKnobTouch:` (L466–554), frame divider 1pt (Layout.m L280–308).

### M3-5 · D3 — Picker
- Hunk hình thức trong `buildPickerSheetForPane:` (Picker.m L665–1050): mặt sheet (L748–807 — phần mesh theo M3-0), bóng (tím 0.3 → đen/graphite), chấm trang (L960–977: pill tím nhấn → cyan), huy hiệu check (L905–958: nền tím nhấn → cyan, giữ alpha 0.3 + tắt tương tác cho app đã dùng), tiêu đề/phụ đề (navy → Ice/#93AAB8), dải phân cách cột phụ (L820–830).
- KHÔNG ĐỤNG: mọi công thức hình học (mục 2.5), `trayWindowForParent:` + hitTest xuyên chạm (L1505–1590), quyết định host HL49 (L560–575) + 2 pref liên quan, selector ô (`pickerAppTapped:` L1415), U11 giữ DEVICE PENDING.

### M3-6 · D11 — Xong theo M2-1 (0 hunk code, xem mục 2.3).

### M3-7 · D9 — Startup trên xe
- Hunk hình thức: bảng màu scene `ss_sceneColors` (SSStartupViewScenesB.m L275–292 → họ graphite/cyan), các điểm màu trong SSStartupViewBuilders.m (sky/hud/particles/briefing/liquid/festive) + SSStartupView.m (font factory L85–104, greeting/weather L503–519) — đổi palette, giữ cấu trúc scene + dispatch `ss_buildScene` (L683–723).
- ⛔ KHÔNG ĐỤNG: `SSSplash.m` toàn bộ vòng đời/cửa sổ (windowLevel Alert+1000 L175, `start`/`dismissBecause:`/`tearDown` L185–329) — hunk trong SSSplash.m nếu phát sinh phải duyệt trước (C8). Bản sao `SSStartupView.m` trong OmniCarPrefs đi cùng lô M2-6 (cùng palette) hoặc để nguyên — ghi rõ khi commit.

### M3-8 · D13 — Bàn phím vẽ hosted (LÔ CUỐI, sau chốt U3)
- Hunk hình thức đã định vị: gradient lit `-[ABKey paint:]` (ABKeyboard.m L175–204: #9B87F8→#5DB4F6 → cyan #61D9F2→teal #2EA6BB), factory phím (L788–846: restColor/restTint slate (74,79,128) → họ Ice/graphite), panel (L487–561: blur + mesh — phần mesh theo M3-0; border/shadow → graphite), bong bóng nhấn phím (L714–759).
- KHÔNG ĐỤNG: bố cục hàng/phím, value/command, `-send:del:text:`, Telex (`ABTelex.m` ngoài file này), cờ `ABDrawnKb` ở ABInApp.m. **U3 DEVICE PENDING** — trạng thái phím vẽ trên xe chưa kết luận và lệnh cũ của Nguyen là phím native; lô này chỉ chạy khi Nguyen chốt lại U3.

## 4. Map key / action (bất biến khi đổi giao diện)

- **Domain pref:** `com.anlai.omnicar`; notify sau ghi: `com.anlai.omnicar/prefschanged`. Đọc/ghi qua `OMCNativePref`/`OMCNativeSetPref` (OMCNativeSettings.m L18–41).
- **Settings (D5):** `enabled` (tổng, YES), `language`, `appBridgeApps`, `homeScreenHiddenApps`, `homeScreenShownApps`, `homeScreenCarApps` (chỉ đọc), `splitScreenCarPlayApps` (chỉ đọc); nhóm Thiết bị: `duocarVitalsEnabled` (YES), `duocarFullscreenVitalsEnabled` (YES), `duocarThermalTest37Enabled` (NO — ghi key này phát thêm `com.anlai.omnicar/thermaltest37.changed`, L35–36); Split: `splitScreenEnabled/AutoLaunch/PinnedApp/ShowRecent/ShowFavorites` + `splitScreenFav{1..3}*`; Home: `homeScreenGridCols/GridRows/IconSize/ShowNames/Blur/Dim/Wallpaper/WallpaperStyle`; Profiles: `carProfilesEnabled/carProfiles/carProfileCurrent`; động: `<feature>Enabled`, `rescueFeatures`, `rescueDate`, `startupScreenEnabled` (chỉ đọc trạng thái).
- **Startup (D6):** `startupScreenStyle` (0–10), `startupScreenVideoName`, `startupScreenRandomSet`, `startupScreenBirthday` (MM-dd), `startupScreenSoundFile`, `startupScreenSoundVolume` + toàn bộ key trong schema `FeatureStartupScreen.plist` (ghi theo `row[@"key"]`).
- **Lề (D7):** KHÔNG dùng pref — giao thức Darwin state: gửi `com.chuong.duocar/le024.cfg`, nhận `com.chuong.duocar/le024.ack`; key 4 = bong bóng (mặc định 1), key 27 = GPS raw 0..20 ⇔ −10..+10 km/h (mặc định 10).
- **Vitals (D8):** không key/notify — mẫu qua `OMCDeviceVitalsSample()` (dict: batteryPercent, batteryState, temperatureCelsius, temperatureKind, thermalState, temperatureSource).
- **Prefs (D14):** cùng domain; helper `OMCPrefValue`/`OMCCardPage storeValue:forKey:`; 14 key hồ sơ xe ở `OMCProfileKeys` (OMCCommon.m L246–254) — giữ nguyên toàn bộ.

## 5. Danh sách ⛔ CHỜ DUYỆT (không tự sửa)

1. **M3-0** — mesh lõi C dùng chung (phương án (i)/(ii) ở trên).
2. **D5 Phần B** — sơ đồ 5 mục + route/key mapping (mục M2-5).
3. **D13 / U3** — chỉ chạy sau khi Nguyen chốt trạng thái phím vẽ.
4. Mọi hunk phát sinh ngoài danh sách method ở mục 3 mà chạm F1–F14/C1–C12 (đặc biệt: `SSSplash.m`, method điều kiện hiện của Bubble/HUD, file engine/hook) — dừng, báo trước tại Issue này, chờ duyệt.

## 6. Thứ tự thực hiện

M2-1 → M2-2 → M2-3 → M2-4 → M2-5A → M2-6 → (M3-0 chờ duyệt) → M3-1 (kiểm chứng) → M3-2 → M3-3 → M3-4 → M3-5 → M3-7 → M3-8 (sau U3). Mỗi lô 1 commit riêng trên nhánh APEX, tổng duyệt diff đối chiếu F/C trước khi đẩy. Không CI, không DEB, không PR — M5 chỉ khi Nguyen lệnh.

## 7. TRẠNG THÁI SAU TASK1 + TASK2 (2026-11-14, HEAD `477263b`)

| Mục | Trạng thái source |
|---|---|
| D1 chrome split | XONG (M3-3a/b) + mesh thay ở TASK1 |
| D2 thanh AppBridge/hosted | XONG (M3-3) + mesh thay ở TASK1 |
| D3 picker | XONG (M3-5) + mặt sheet qua helper mesh mới (TASK1) |
| D4 knob/divider | XONG (M3-4) |
| D5 cài đặt iPhone | XONG — 3 tab cũ (M2-4A) → **5 mục** (TASK2: route `580421b`, phân vùng `fa48bf4`, dashboard/preview `477263b`) |
| D6 trang Startup iPhone | XONG (M2-3) |
| D7 trang Lề | XONG (M2-2) |
| D8 trang vitals iPhone | XONG (M2-2) |
| D9 startup trên xe | XONG (M3-7) |
| D10 vitals trên xe | XONG (M3-2) |
| D11 icon Home xe | XONG qua D12 (0 hunk code) |
| D12 asset nhận diện | XONG (M2-1) |
| D13 bàn phím vẽ | XONG (M3-8) — GPT SOURCE SCOPE PASS 6875586688; panel mesh thay ở TASK1 |
| D14 prefs bundle | XONG (M2-5) |
| A1 viền nhiệt HL61 | KIỂM CHỨNG khớp SPEC — 0 hunk |

**Nhãn toàn cục: SOURCE COMPLETE / COMPILE PENDING (toolchain VM của Muse hỏng) / DEVICE PENDING (U3, U8, U10, U11).**
