# APEX V3 — P1: BẢN ĐỒ HUNK BL-01..BL-12 (đối chiếu kit Purple Horizon ↔ P0 ↔ source)

- **Ngày:** 2026-11-14. **Người nộp:** Muse (theo giao việc GPT, comment #6877408566 — bộ kit P1 REVIEW).
- **Cơ sở:** kit `V3_PURPLE_HORIZON_DESIGN/` @ commit `8af9e78` (23 SVG xem duyệt + `SPEC_V3_DESIGN.txt` + `MUSE_HANDOFF.txt`); P0 `APEX_V3_P0_BANG_PHU_20261114.md` @ `8c57ae8`; source tại HEAD `8c57ae8` (runtime `3107d0e`).
- **Trạng thái:** ĐÂY LÀ BẢN ĐỒ CHUẨN BỊ — không sửa một dòng code nào. **Cổng P2 giữ nguyên:** (1) Nguyen duyệt hình bản cuối; (2) master asset gốc (ZIP ~13 MB phía ChatGPT) lên repo. SVG trong repo là bản vẽ lại để xem duyệt, KHÔNG phải artwork master; thumbnail logo webp lossy bị cấm dùng build.
- **Palette áp dụng (chỉ token SPEC):** root `#070416`, deep `#100923`, dark glass `#1B1138`, raised `#28194D`, violet chọn `#A16EFF`, lavender rim `#DBB9FF`, chữ `#F5F0FF`, chữ phụ `#C7B8E4`; nhiệt `#FF0610` ngoài palette, giữ nguyên tuyệt đối. Tên hiển thị đích = **"DuoCar"**; mọi identifier theo K1–K12 giữ nguyên.

## 0. Phương pháp + tổng duyệt chéo (Muse)

Ba tuyến chỉ-đọc độc lập (chữ/brand + bàn phím + trang phụ / picker + vật liệu / tay nắm + glyph hosted), mọi vị trí đọc trực tiếp từ source, không suy từ P0. Kết quả đối chiếu chéo:

1. **Gương project↔src:** mọi file code trong phạm vi đều KHỚP từng byte (`cmp`). Hai điểm cần ghi rõ: (a) gương đúng của `SCPCarDividerView.m` ở `src/SplitScreenB/` (không phải SplitScreenA như đường dẫn cũ từng ghi); (b) gương của `SCPCarSplit+Chrome.m` đúng ở `src/SplitScreenA/` — bản cùng tên trong SplitScreenB là bản cũ lệch, không đụng. **Resources/plists/layout KHÔNG có gương trong `src/`** — các hunk plist/control của BL-01 chỉ làm ở `project/`, kỷ luật chép gương chỉ áp cho file code.
2. **`ABHostBMethods.m` là file dùng chung của 3 backlog** (BL-05 blur/mesh hosted, BL-06 tay nắm hosted, BL-07 glyph) → khi code P2 phải nối tiếp theo từng BL, mỗi BL một commit riêng để revert độc lập, không gộp.
3. **SVG 02 và 03 giống hệt nhau** về hình học/màu (chỉ khác chữ Native/Hosted) vì sheet picker dùng chung một đường code `refreshPickerSheet` — BL-04 áp một lần cho cả hai phía; khác biệt native/hosted nằm ở nội dung app phía dưới, không ở chrome picker.
4. **Tông trang trí trong SVG không thuộc palette SPEC** (13 tông liệt kê ở §BL-04/05 mục 0). Mọi hunk trong tài liệu này dùng token SPEC; nếu GPT muốn dùng tông SVG làm hằng số build thì phải bổ sung vào SPEC trước — Muse không tự lấy tông preview làm hằng số.
5. **BL-02 đếm lại bằng plistlib** (không dùng lại số P0): 139 file `.strings` prefs, 99 file có "OmniCar" trong value, tổng **392 key**. App bundle: 0 file chứa "OmniCar".
6. **Phủ đủ 12/12 BL:** BL-01 = 10 điểm; BL-02 = 1 script (99 file/392 key); BL-03 = 11 điểm; BL-04 = 15 hạng mục + 3 helper dùng chung; BL-05 = factory 2 nhánh + 4 caller + blur/mesh riêng hosted; BL-06 = 7 mục (a–g, trong đó g = không hunk); BL-07 = phương án A (1 dòng, khuyến nghị) + B/C/D đã xét và loại + E hunk riêng chờ chốt; BL-08 = 2 điểm; BL-09 = 2 điểm; **BL-10/BL-11/BL-12 = 0 hunk** (lần lượt: chờ quyết định của Nguyen / giữ nguyên có bằng chứng 0 caller sống / việc đo trên máy, không sửa source).

## 1. Bảng quyết định cần chốt trước P2

| Mã | Quyết định | Thuộc BL | Ai chốt |
|---|---|---|---|
| D-01 | Accent tay nắm: trung hòa thành no-op đúng SVG 13 (3 trạng thái vẽ giống hệt) hay giữ tín hiệu trạng thái bằng wash tím (lệch SVG)? | BL-06c/f | GPT + Nguyen |
| D-02 | Số pt chính xác của vạch tay nắm — hiện là ước lượng (6.9, 4.8, 20.1, 2.4) từ SVG preview ~1.6×; số chính thức lấy từ master board | BL-06b/e | Chờ master asset |
| D-03 | Giá trị tint nút bar: giữ Ice (234,246,251) hay đổi tím `#E5CFFF` theo SVG 05/06? (danger nút close `#FF4757` giữ nguyên) | BL-07E | GPT + Nguyen |
| D-04 | Accent knob chia màn ở `-setKnobs:` (cyan-teal `#79EDF4→#218FAA`) có đổi tím không? Nằm ngoài BL-06/07 — hunk riêng nếu có | Ngoài BL | GPT |
| D-05 | Màu mặt phím theo màn 08 (tím `#31204D/#3A275C`) hay giữ graphite D13? BL-08 chỉ bao 2 màu runtime | BL-08 (ngoài phạm vi) | GPT + Nguyen |
| D-06 | Trang Guide theo màn 23 dạng danh sách chủ đề hay giữ text view một cột? BL-09 hiện chỉ đổi màu nền/chữ | BL-09 | GPT |
| D-07 | Token màu cho glyph đạt/trượt + phần trăm trong HUD chẩn đoán splash — palette V3 không có token "đạt" | BL-09 | GPT |
| D-08 | Nhãn trang kind 3: đổi hiển thị thành "Tương thích Lề" (theo màn 21) hay giữ chữ "SPEEDBUBBLE"? | BL-10 | **Nguyen** |
| D-09 | Tạo file `vi/Car.strings` mới hay giữ cơ chế dự phòng sang bản tiếng Anh cho banner cứu hộ? | BL-02 | GPT |
| D-10 | Toast pill không có mẫu trong SVG — màu map theo palette (chữ `#F5F0FF`, nền `#28194D` @0.94) có đúng ý thiết kế không? | BL-04 | GPT |
| D-11 | Wrapper slot-map trong sheet picker: nền từ trắng mờ 0.35 thành `#1B1138` đặc 1.0 — đúng ý thiết kế? | BL-04 | GPT |
| D-12 | 13 tông trang trí trong SVG có được nâng thành token SPEC không? | BL-04/05 | GPT |
| D-13 | Số style blur tối 16 (twin của 11) là SUY LUẬN từ tên style gốc — phải xác minh trên thiết bị ở vòng test P2; phương án dự phòng an toàn là style 2 | BL-05 | Đo trên thiết bị |

## 2. UNKNOWN còn mở (không đoán)

- Window level dạng số của cửa sổ tray picker (kế thừa từ P0, chưa đo được từ source).
- Độ tương phản của vạch/chấm trên nền blur tối sau khi đổi vật liệu BL-05 (cần ảnh thiết bị ở vòng test P2).
- Giá trị `liteMode` thật trên máy Nguyen (BL-12 — việc đo, xem §BL-12).
- Toàn bộ ảnh "sau" phía xe: chưa có, chỉ có ở vòng test thiết bị sau P2.

## 3. Nhóm commit đề xuất cho P2 (mỗi commit = một đơn vị revert; file code chép project→src trong cùng commit)

1. **BL-01** chữ brand trong code + plist/control (10 điểm).
2. **BL-02** script `.strings` (1 commit riêng, 4 assert kiểm chứng bắt buộc PASS mới commit).
3. **BL-03** fallback startup + banner cứu hộ (11 điểm; banner đổi cùng đợt BL-02 để không lệch với `Car.strings`).
4. **BL-04a** hằng số picker + ghost icon (Picker.m, Drag.m).
5. **BL-04b** ratio/panel + ô preview slot-map (RatioMenu.m, Panel.m, Zoom.m, Picker.m).
6. **BL-05b/04c** helper dùng chung (`SCPColorSecondary()`, `SCPStyleChip()` trong Chrome.m).
7. **BL-05a** factory vật liệu + mesh native/hosted (SCPCarDividerView.m, Chrome.m, ABHostBMethods.m) — **F-adjacent, duyệt hunk riêng trước khi code**.
8. **BL-06** tay nắm hai phía (Chrome.m, ABHostBMethods.m) — vạch bắt buộc dạng layer phía hosted.
9. **BL-07A** glyph hosted sang template (ABHostBMethods.m, 1–2 dòng).
10. **BL-08** 2 màu runtime bàn phím (ABKeyboard.m).
11. **BL-09** màu trang Guide + màu render HUD splash (sau khi D-06/D-07 chốt).

Thứ tự gợi ý: chữ/brand (rủi ro thấp nhất) → picker/ratio → helper → vật liệu (F-adjacent, làm sau khi các mặt đã đúng token) → tay nắm/glyph → bàn phím/trang phụ.

## 4. Vùng cấm — xác nhận giữ nguyên

F1–F14, C1–C12, K1–K12 giữ nguyên toàn bộ. Các điểm **F-adjacent** đã đánh dấu trong từng phần và phải được duyệt hunk trước khi code: toàn bộ BL-05 (factory dùng chung 4 caller/5 bề mặt + nhánh Lite là đường dự phòng nhiệt/máy yếu + nhánh no-blur HL49); mặt picker trong pane + cover (alpha 1.0 là hợp đồng che nội dung — chỉ đổi màu); BL-06 (tay nắm nằm trên đường gọi logo C1/C2 — cấm đụng `setBarVisible:`, `layoutBarForPane:`, bộ đếm giờ 4 giây, completion 4 lệnh phía native, guard + spring phía hosted; bất đối xứng double-tap chỉ-có-native là hành vi, cấm đồng nhất hoá). Telex/layout/geometry bàn phím (vùng cấm D5 của BL-08) nguyên vẹn. Giao thức Lề `com.chuong.duocar/le024.cfg/.ack` (F9) không đụng ở mọi phương án BL-10.

---

# PHẦN 1 — BL-01, BL-02, BL-03 (chữ brand, .strings, fallback + banner)


**Chỉ đọc, không sửa file, không commit.** Cây: `recovered-source/` @ APEX HEAD `88cea15` (source runtime `3107d0e`). Kit: `V3_PURPLE_HORIZON_DESIGN/` — palette V3: root `#070416`, deep `#100923`, dark glass `#1B1138`, raised `#28194D`, selected violet `#A16EFF`, lavender rim `#DBB9FF`, text `#F5F0FF`, secondary `#C7B8E4`; nhiệt `#FF0610` được bảo vệ. Tên hiển thị đích = **"DuoCar"** (metadata hiển thị); mọi identifier theo K1–K12 giữ nguyên. Gương `src/`: **13/13 file code trong cụm KHỚP từng byte** (`cmp`); riêng Resources/plists/layout **không có gương trong `src/`** (không được mirror) — hunk chỉ làm ở `project/`.

## BL-01 — Chữ brand hiển thị (màn 22 legacy prefs, 14 dashboard, 11 home tile, 09 startup)

| # | Hạng mục | Màn SVG | File:dòng (+gương) | Hunk dự kiến | Giữ nguyên | Rủi ro | Rollback |
|---|---|---|---|---|---|---|---|
| 01-1 | Tên app dưới icon Home | 11 | `project/OmniCarApp/Resources/Info.plist`: `CFBundleDisplayName`/`CFBundleName` = `OmniCar` (đã trích plistlib; không gương) | → `DuoCar` cả 2 trường | `CFBundleIdentifier=com.anlai.omnicar.app`, `CFBundleExecutable=OmniCar`, URL scheme `omnicar` + `CFBundleURLName=com.anlai.omnicar`, `CFBundleShortVersionString=1.0.3` (không phải brand) | Thấp | Revert plist |
| 01-2 | Câu xin quyền Photos | 11 | Cùng Info.plist: `NSPhotoLibraryUsageDescription` = "OmniCar uses only photos and videos you select for your startup screen and optional wallpaper."; `NSPhotoLibraryAddUsageDescription` = "OmniCar saves only media you explicitly choose." | → "DuoCar uses only photos…", "DuoCar saves only media…" (chỉ đổi tên hãng, giữ nguyên phần còn lại của câu) | Nội dung câu, quyền đã cấp | Thấp (iOS hiện câu mới ở lần xin quyền sau) | Revert plist |
| 01-3 | Metadata gói Sileo | 22 | `project/control`: `:2 Name: OmniCar`; `:4` mô tả "OmniCar takes CarPlay beyond…"; `:30` "Settings > OmniCar"; `:38–39 Maintainer/Author: OmniCar <omnicartweak@gmail.com>` | Name → `DuoCar`; mô tả → "DuoCar takes CarPlay beyond…"; `:30` → "Settings > DuoCar"; Maintainer/Author → `DuoCar Project` (đúng tiền lệ script rebrand HL47 của GPT) | `Package: com.anlai.omnicar` (:1), `Version: 1.0.3-hl21restored` (:45 — version đóng dấu lúc đóng gói), `Icon:` (:37 — đường dẫn chứa tên bundle, giữ) | Thấp | Revert control |
| 01-4 | Nhãn mục tweak trong Cài đặt iPhone | 22 | `project/layout/Library/PreferenceLoader/Preferences/OmniCarPrefs.plist`: `entry.label = "OmniCar"` (đã giải mã bplist; không gương) | → `"DuoCar"` | `bundle=OmniCarPrefs`, `detail=OMCRootListController`, `icon=icon.png`, `cell/isController` | Thấp | Revert plist |
| 01-5 | Tiêu đề trang Root prefs | 22 | `project/OmniCarPrefs/Resources/Root.plist`: `/title = OmniCar`, 15 items (không gương) | → `DuoCar` | Cấu trúc 15 specifier | Thấp | Revert plist |
| 01-6 | Tên + version trên thẻ header prefs | 22 | `project/OmniCarPrefs/OMCHeaderCard.m:57` `_nameLabel.text = @"OmniCar"`; `:63` `_versionLabel.text = @"1.0.3"` (gương KHỚP) | Tên → `@"DuoCar"`; version → đọc động: `[[NSBundle bundleForClass:[self class]] infoDictionary][@"CFBundleShortVersionString"] ?: @"1.0.3"` (bundle đã có trong scope tại :47; prefs Info.plist đã kiểm: `CFBundleShortVersionString=1.0.3`, `CFBundleVersion=1.0` — phải dùng ShortVersionString) | Logo asset `imageNamed:@"logo"`, màu/gradient thẻ, công tắc master | Thấp | Revert 2 dòng |
| 01-7 | Tiêu đề trang prefs + alert | 22 | `project/OmniCarPrefs/OMCRootListController.m:207` (`applyLanguage`: `navigationItem.title = @"OmniCar"`); `:334` (`showMessage:` alert title `@"OmniCar"`) (gương KHỚP) | → `@"DuoCar"` cả 2 (hằng số, không bản địa hoá — khớp app dùng `@"DuoCar"` tại OMCNativeSettings.m:440/682) | Class `OMCRootListController`, nút Respring/Ngôn ngữ | Thấp | Revert 2 dòng |
| 01-8 | Tiêu đề mọi alert trong app | 14 | `project/OmniCarApp/OMCNativeSettings.m:174` helper `OMCAlert()` (gương KHỚP) — **điểm duy nhất còn `@"OmniCar"` trong toàn bộ `OmniCarApp/`** (grep đã loại path/log) | → `@"DuoCar"` (1 dòng, bao phủ ~15 điểm present qua helper) | Nút "Đóng"/"Close", mọi message truyền vào | Thấp | Revert 1 dòng |
| 01-9 | Tiêu đề 3 alert prefs | 22 | `OMCCommon.m:931` (alert lỗi gửi log, message `L(@"SEND_LOG_FAILED")`); `OMCFeatureListController.m:107` (`showMessage:`); `OMCStartupScreenController.m:903` (alert "đang chuẩn bị" khi trích frame video) (gương KHỚP cả 3) | → `@"DuoCar"` cả 3 | Message/key bản địa hoá, luồng gọi | Thấp | Revert 3 dòng |
| 01-10 | Placeholder tên xe (prefs) | 22/09 | `OMCStartupScreenController.m:307` `[sp setProperty:SSDiagCarName() ?: @"OmniCar" forKey:@"placeholder"]` (gương KHỚP) | → `@"DuoCar"`; giữ nguyên điều kiện `SSDiagCarName() ?:` | Hàm `SSDiagCarName()`, cơ chế specifier | Thấp | Revert 1 dòng |

## BL-02 — `.strings` prefs: đếm lại + cách thay an toàn

**Đếm lại hôm nay bằng plistlib trên toàn bộ `project/OmniCarPrefs/Resources/*/*.strings` (không dựa số P0 cũ): 139 file, 99 file có "OmniCar" trong value, tổng 392 key.** App bundle `.strings`: **0 file** chứa "OmniCar" — không cần đụng app.

| Locale | Số key chứa "OmniCar" trong value | Ghi chú |
|---|---|---|
| ar, de, es, fr, id, it, ja, ko, pt-BR, ru, th, zh-Hans (12 locale) | 28 mỗi locale | Car 2 + HomeScreen 1 + Localizable 16 + Onboarding 4 + Profiles 1 + SplitScreen 3 + WhatsNew 1 |
| en | 29 | 28 + StartupScreen 1 |
| vi | 27 | **Không có file `Car.strings`**; có StartupScreen 1 |
| **Tổng theo bảng** | **392** | Localizable 224 · Onboarding 56 · SplitScreen 42 · Car 26 · HomeScreen 14 · Profiles 14 · WhatsNew 14 · StartupScreen 2 (chỉ en + vi) |

**Cách thực thi (script, 1 commit riêng chỉ chứa .strings):**
1. Với mỗi file: phát hiện định dạng theo magic (`bplist00` → `plistlib.dumps(fmt=FMT_BINARY)`; `<?xml` → `FMT_XML`) rồi ghi lại đúng định dạng gốc.
2. Chỉ thay trong **value** kiểu str: thay chuỗi con `"OmniCar"` → `"DuoCar"` (bao gồm "Settings > OmniCar" → "Settings > DuoCar" trong value). **Key giữ nguyên tuyệt đối** (K10) — kể cả `Car.strings`, nơi key CHÍNH LÀ câu tiếng Anh chứa "OmniCar" (key == value ở en): thay value, key vẫn tra cứu được qua `L()`.
3. Kiểm chứng sau thay (script assert, phải PASS hết mới commit): (a) key-diff = 0 mọi file (tập key trước/sau giống hệt); (b) không còn value nào chứa "OmniCar" (phân biệt chữ hoa/thường); (c) mọi file load lại được bằng plistlib; (d) đếm lại: 0/139 file còn hit trong value.
4. Rủi ro: (a) 392 giá trị × 99 file — sai 1 value là sai 1 câu hiển thị; bắt buộc review `git diff` theo bảng; (b) `vi` thiếu `Car.strings` — banner cứu hộ ở locale vi fallback sang en (cơ chế `OMCLoadStrings` gộp en + lang); sau BL-02, en đã là DuoCar nên vi vẫn thấy tiếng Anh DuoCar như trước — **không tự tạo file `vi/Car.strings` mới** trừ khi GPT quyết; (c) grep thô trên file vẫn thấy "OmniCar" trong key của Car.strings — kiểm chứng phải xét value, không xét byte file. Rollback: revert đúng 1 commit BL-02.

## BL-03 — Fallback startup trên xe + bản sao prefs + banner cứu hộ (màn 09, 19)

| # | Hạng mục | Màn SVG | File:dòng (+gương) | Hunk dự kiến | Giữ nguyên (điều kiện fallback) | Rủi ro | Rollback |
|---|---|---|---|---|---|---|---|
| 03-1 | Tên mặc định trong checklist HUD mặc định | 09 | `SSStartupViewBuilders.m:318` `SSDefaultHudItems`: `name = SSTrimmed(carName).length ? SSTrimmed(carName) : @"OmniCar"` (gương KHỚP) | → `@"DuoCar"` | Chuỗi fallback chỉ khi `carName` trống; dùng khi `self.hud` trống | Thấp | Revert 1 dòng |
| 03-2 | Tên scene khi thiếu name + carName | 09 | `SSStartupViewBuilders.m:575`: `text = SSTrimmed(self.name)` → `SSTrimmed(self.carName)` → `@"OmniCar"` (gương KHỚP) | → `@"DuoCar"` ở bậc cuối; giữ nguyên chuỗi 2 bậc | Font 180 Heavy, attrs | Thấp | Revert 1 dòng |
| 03-3 | Tiêu đề scene lớn (mask gradient 110pt) | 09 | `SSStartupViewBuilders.m:964` `SSSceneLabel(@"OmniCar")` (gương KHỚP) | → `@"DuoCar"` | Label dùng làm mask (textColor đen là cấu trúc — **không** đổi màu); font/size/vị trí | Thấp | Revert 1 dòng |
| 03-4 | Tiêu đề dưới + dòng sẵn sàng | 09 | `SSStartupViewScenesB.m:631` `carDisplay = SSTrimmed(self.carName); if (!carDisplay.length) carDisplay = @"OmniCar"` (gương KHỚP) | → `@"DuoCar"` | Điều kiện rỗng, vị trí/size 70 Heavy | Thấp | Revert 1 dòng |
| 03-5 | Dữ liệu mẫu HUD | 09 | `SSStartupScreen.m:911` `SSSampleHUD`: `carName.length ? carName : @"OmniCar"` (gương KHỚP) | → `@"DuoCar"` | Đây là dữ liệu mẫu khi chưa có HUD thật | Thấp | Revert 1 dòng |
| 03-6 | Bản sao prefs — 5 fallback | 22 | `OMCStartupScreenController.m` → bản sao `OmniCarPrefs/SSStartupView.m`: `:209` (`SSSampleHudItems`, displayName fallback), `:1072` (`if (!car.length) car = @"OmniCar"`), `:1145` (`self.name.length ? self.name : @"OmniCar"`), `:1207` (`self.carName.length ? self.carName : @"OmniCar"`), `:1347` (`ss_label:` fallback) (gương KHỚP) | → `@"DuoCar"` cả 5; giữ nguyên mọi điều kiện | Logic preview scene trong prefs | Thấp | Revert 5 dòng |
| 03-7 | Banner cứu hộ (crash-guard) | — | `OmniCarCore/OmniCarCore.c:184/187` (gương `src/OMCCommon/OmniCarCore.c` KHỚP): title `OMCTr(@"OmniCar: chế độ cứu", @"OmniCar: rescue mode")`; body song ngữ chứa "nên OmniCar đã tắt" + "Vào Cài đặt > OmniCar" / "so OmniCar turned off" + "Open Settings > OmniCar" | → `DuoCar` ở cả 4 vị trí trong 2 literal (vi + en) | Ngưỡng/logic crash-guard, `CFUserNotificationDisplayNotice` qua dlsym, `OMCLogWrite` | Thấp (chỉ chuỗi) | Revert 2 literal |
| — | Đồng bộ bắt buộc | — | Chuỗi cứu hộ tồn tại 2 bản: `OmniCarCore.c:184/187` (code) và `Car.strings` en (BL-02, key == value) | Đổi cả 2 trong cùng đợt BL-02/BL-03 để không lệch nhau | — | — | — |

Màn 09 xác nhận: tiêu đề scene là **"DuoCar"** + "PURPLE HORIZON", và "Ảnh/logo tùy chỉnh của người dùng được giữ nguyên" — fallback "DuoCar" khớp thiết kế; media người dùng (S4, path `/var/mobile/Library/OmniCar/StartupScreen`) **cấm đổi**.


# PHẦN 2 — BL-04, BL-05 (picker/panel/ratio + vật liệu)

## 0. Cơ sở đã đọc

- Kit V3: `SPEC_V3_DESIGN.txt` + `MUSE_HANDOFF.txt` + SVG 02/03/04/12 (preview, không phải master). Palette SPEC: root `#070416`, deep `#100923`, dark glass `#1B1138`, raised `#28194D`, violet `#A16EFF`, lavender rim `#DBB9FF`, text `#F5F0FF`, secondary `#C7B8E4`; nhiệt `#FF0610` giữ nguyên.
- **SVG trang trí không thuộc palette SPEC:** các tông `#241344`, `#0E0B2A`, `#10081D`, `#0C061A`, `#8262AD`, `#6D4A9B`, `#4B3176`, `#5A4478`, `#D6B2FF`, `#AF87E5`, `#44266B`, `#3E2866`, `#201536` là tông preview. Hunk dùng token SPEC; nếu GPT muốn tông SVG thì phải bổ sung vào SPEC trước, không tự lấy tông SVG làm hằng số build.
- SVG 02 và 03 trích xuất giống hệt nhau về hình học/màu (chỉ khác chữ "Native"/"Hosted") — sheet picker dùng chung một đường code `refreshPickerSheet`; khác biệt native/hosted nằm ở nội dung app phía dưới, không ở chrome picker. Hunk BL-04 áp một lần cho cả hai.
- Gương `src/` đã cmp: **KHỚP** cho Picker/Panel/RatioMenu/Drag/Zoom/Chrome (SplitScreenA/B) và ABHostBMethods (AppBridgeB). SCPCarDividerView.m gương đúng ở `src/SplitScreenB/` (không phải SplitScreenA như đường dẫn cũ) — **KHỚP**.

## 1. BL-04 — Picker / Panel / Ratio: bảng hunk

| Hạng mục | Màn SVG | File:method:dòng (project + gương src) | Hunk dự kiến (cũ → token V3) | Giữ nguyên | Rủi ro | Rollback |
|---|---|---|---|---|---|---|
| Separator gradient + title picker | 02/03 | `SCPCarSplit+Picker.m` `-refreshPickerSheet`, navy :820–822, gradient :823–828, title :854 | navy `(0.290,0.310,0.502)` → separator gradient dùng `#DBB9FF` với ramp alpha 0→0.32→0.32→0 giữ nguyên; `titleLabel.textColor = navy` → `#F5F0FF` | Frame/ramp/locations `@0.0/0.2/0.8/1.0`; subLabel dùng `SCPColorSecondary()` | Thấp | Revert commit nhóm picker |
| Wrapper slot-map | 02/03 | `SCPCarSplit+Picker.m` `-refreshPickerSheet` :836–844 | bg trắng 1.0 alpha 0.35 → `#1B1138` alpha 1.0; viền trắng 0.7 → `#DBB9FF` alpha 0.7 | Frame `(150−mapW)/2`, y-offset 54.0, radius 12, borderWidth 1 | Thấp–trung bình (alpha 0.35→1.0 là quyết định thiết kế — GPT chốt) | Revert commit nhóm picker |
| Shadow icon app trong lưới | 02/03 | `SCPCarSplit+Picker.m` `-refreshPickerSheet` :923–931 | shadowColor tím `(0.431,0.392,0.784)` → `#A16EFF`, giữ opacity 0.25 / radius 5 / offset (0,4) / shadowPath | Thứ tự subview shadowView → iconView; frame icon 38×38 | Thấp | Revert commit nhóm picker |
| Mặt picker trong pane + cover kéo | 12; 02/03 khi pane trống | `SCPCarSplit+Picker.m` `-showPickerForSlot:` :368–372 (lavender `(0.933,0.941,0.984)` alpha 1.0); `-addCoverToPane:` :299–305 (cùng màu, alpha 0→1 trong 0.12s) | Cả hai → `#100923` alpha 1.0 (cover giữ fade 0.12s) | **F-adjacent:** alpha 1.0 phải giữ (che nội dung bên dưới); recognizer `pickerPaneTapped:` :549–556; tag 77 ghost icon; nhánh clear HL46/HL48/HL49 (:379–431) không đổi default | Trung bình | Revert commit nhóm picker |
| Ghost fallback thiếu icon | 12; 02/03 | `SCPCarSplit+Drag.m` `SCPStyleGhostIcon` :40–47 | nền fallback lavender → `#1B1138` (chỉ khi `image == nil`; có ảnh thì clear giữ nguyên) | Bo góc 27%, clipsToBounds, toàn bộ caller | Thấp | Revert commit nhóm picker |
| Separator ratio menu | 04 | `SCPCarSplit+RatioMenu.m` `-showRatioMenuForDivider:` :410–415 | trắng 1.0 alpha 0.95 → `#DBB9FF` alpha 0.95; giữ frame 1×18, cursor += 9 | Vị trí/cách tính total width | Thấp | Revert commit nhóm ratio/panel |
| Tint chip ratio + chip cancel picker | 04 | `SCPCarSplit+RatioMenu.m` `SCPWrapRatioChip` :259–268 (tint navy) | tint → `#F5F0FF` (glyph template ăn tint thật — đã xác minh cơ chế) | Chip 34×34, radius 17, `setImage:forState:`; trạng thái chọn do vòng conic đánh dấu | Thấp | Revert commit nhóm ratio/panel |
| Vòng conic chip đã chọn | 04 | `SCPCarSplit+RatioMenu.m` `SCPMarkRatioChipSelected` :282–312 (conic c1 `#79EDF4` → c2 `#61D9F2` → c3 `#2EA6BB` → c4 `#79EDF4`) | Conic → chỉ token SPEC: c1 `#A16EFF`, c2 `#DBB9FF`, c3 `#A16EFF`, c4 `#DBB9FF` (violet↔lavender xen kẽ); giữ mask lineWidth 2, tên layer `omcRing`, frame cập nhật | Tên layer, kiểu conic, start/end point; caller Panel.m:296 + RatioMenu.m:386 | Thấp | Revert commit nhóm ratio/panel |
| Shadow panel bố cục | 04 | `SCPCarSplit+Panel.m` `-showLayoutPanelForApp:` :236–242 | shadowColor tím `(0.431,0.392,0.784)` → `#A16EFF`; giữ opacity 0.3 / radius 24 / offset (0,8) | Radius 24, face qua KnobFace + mesh (:244–246) | Thấp | Revert commit nhóm ratio/panel |
| Viền/border + glyph nút layout | 04 | `SCPCarSplit+Panel.m` :287–306: border trắng 0.75 (:293–294); glyph fill trắng 0.45/0.75 + border trắng 0.95 (:300–303) | Border → `#DBB9FF` alpha 0.75; glyph fill → `#F5F0FF` alpha 0.45 (chưa chọn) / 0.75 (đã chọn); glyph border → `#F5F0FF` alpha 0.95 | Frame 84×56, stride 84, radius 14, `SCPMarkRatioChipSelected` khi chọn | Thấp | Revert commit nhóm ratio/panel |
| Ô preview slot-map | 02/03 | `SCPCarSplit+Picker.m` `-pickerMapForPane:height:` :1313–1327 (ô khác: fill trắng 0.45/0.6, border trắng 0.8/1.5pt; ô hiện tại: clear + `SCPApplyAccent`) | Ô khác: fill → `#28194D` alpha 0.45 (picker!=nil) / 0.6; border → `#DBB9FF` alpha 0.8 | Ô hiện tại (clear + accent) không đổi; button tag = slot là nút chọn thật; icon giữa ô qua ghost style | Thấp | Revert commit nhóm picker |
| Dấu "+" ô trống trong preview | 02/03 | `SCPCarSplit+Picker.m` `-pickerMapForPane:` :1331–1340 (`plus.textColor`: pane hiện tại trắng, còn lại `SCPColorSecondary()`) | Pane hiện tại → `#F5F0FF`; còn lại → `#C7B8E4` (qua helper SCPColorSecondary) | Font 40 Light, frame button.bounds | Thấp | Revert commit nhóm picker |
| Chấm phân trang picker | 02/03 | `SCPCarSplit+Picker.m` `-layoutPickerDotsForPage:` :1367–1390 | Chấm hiện tại cyan `#61D9F2` (16pt pill) → `#A16EFF`; chấm còn lại Ice @0.25 → `#C7B8E4` @0.25; giữ kích thước 16/6pt | Hình học dải chấm, cập nhật qua `scrollViewDidScroll:` | Thấp | Revert commit nhóm picker |
| Toast pill | Không có trong SVG 02/03/04/12 — **thiếu mẫu thiết kế** | `SCPCarSplit+Picker.m` `-toast:duration:` :1872–1890: text navy, bg trắng 0.94, `SCPStyleDragGhost(label, 19.0)` | Text → `#F5F0FF`; bg → `#28194D` alpha 0.94 (theo palette, chưa có mẫu SVG — **cần GPT chốt**) | Logic né pane đang live (`bridgedPane` dodge :1892–1905), fade in 0.2s / out 0.3s | Thấp | Revert commit nhóm picker |
| Dấu "+" lớn trong pane trống | 12 | `SCPCarSplit+Picker.m` `-showPickerForSlot:` :480–493: text "+" 40pt Light, màu `[SCPColorSecondary() colorWithAlphaComponent:0.6]` | Đổi qua helper SCPColorSecondary → tự động thành `#C7B8E4` @0.6 | Ẩn khi nhánh clear HL46/HL48/HL49 bật (:493) | Thấp | Theo commit helper |

### Helper dùng chung (một hunk, nhiều bề mặt — commit riêng)

| Helper | File:dòng | Hunk | Bề mặt chịu ảnh hưởng |
|---|---|---|---|
| `SCPColorSecondary()` | `SCPCarSplit+Chrome.m` :80–82 — `(0.576,0.667,0.722)` @0.85, comment "navy at 55%" | → `#C7B8E4` @0.85 | Picker subtitle (:868), "+" lớn trong pane (:488, @0.6), icon mục trong Panel (:270), "+" trong preview (:1337) |
| `SCPStyleChip()` | `SCPCarSplit+Chrome.m` :85–100 — bg surface.1 `(27,42,52)` @0.55, border stroke APEX `(53,81,95)` @0.9, shadow đen 0.12/3 | bg → `#28194D` @0.55; border → `#DBB9FF` @0.9; shadow đen giữ | Chip cancel/exit (bar + picker) |
| `SCPApplyMeshBackdrop()` | `SCPCarSplit+Chrome.m` :61–79 — mesh gradient `#0A1218→#233640` (64×64, `SCPApexGraphiteSkinImage` :42–59), border stroke `(53,81,95)` @0.85 | Gradient → `#100923 → #1B1138`; border → `#DBB9FF` @0.85 | Bar + ratio menu (qua `SCPStyleRatioMenu` :334), Panel (:246), mặt picker nhánh original (:800) |

## 2. BL-05 — Vật liệu: `SCPKnobFaceView` + blur riêng bar hosted

### 2a. Factory chung — `SCPCarDividerView.m:99–107` (gương `src/SplitScreenB/` KHỚP)

```objc
UIVisualEffectView *SCPKnobFaceView(void) {
    if (OMCLiteActive()) {  // đọc cờ trong OMCCommon.c — VÙNG CẤM, không đụng
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:nil];
        view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.92];  // ← đổi
        return view;
    }
    return [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:11]];
    // style 11 = SystemUltraThinMaterialLight (tên INFERRED từ dump gốc)
}
```

| Hạng mục | Màn SVG | Hunk tối thiểu | Giữ nguyên tuyệt đối | Rủi ro | Rollback |
|---|---|---|---|---|---|
| Nhánh thường: blur Light → Dark | 02/03/04 (mọi mặt kính) | `effectWithStyle:11` → `effectWithStyle:16` (= SystemUltraThinMaterialDark, twin tối của 11) | Chỉ đổi số style; không đổi kiểu view, frame, autoresizing, cornerRadius/clipsToBounds ở caller | **Trung bình–cao:** 1 factory → 5 bề mặt cùng đổi. Số style là INFERRED — cần xác minh trên thiết bị; nếu 16 sai thì dự phòng an toàn là style 2 (Dark) | Revert commit vật liệu (1 commit riêng) |
| Nhánh Lite fallback: trắng 0.92 → kính tối | 02/03/04 (trạng thái Lite) | `colorWithWhite:1.0 alpha:0.92` → `#1B1138` alpha 0.92 (giữ hợp đồng "không blur, nền đục") | Điều kiện `OMCLiteActive()` + `initWithEffect:nil` giữ nguyên; **không đụng `OMCCommon.c` (vùng cấm)** | Trung bình: Lite là đường dự phòng khi máy yếu/nhiệt | Revert commit vật liệu |

### 2b. TẤT CẢ caller/bề mặt chịu ảnh hưởng (đã grep toàn `project/`)

| # | Caller | Bề mặt | Ảnh hưởng thực tế của hunk BL-05 |
|---|---|---|---|
| 1 | `SCPCarSplit+Layout.m:600` `-layoutKnobOf:` | Mặt knob chia màn 14×14 (SVG 04) | **Ảnh hưởng LỚN NHẤT:** knob không có mesh phủ — blur là toàn bộ mặt. Viền knob Ice + chấm graphite + tint contentView surface.1 @0.35 (:603–615) nằm trên mặt này — cần kiểm tương phản sau đổi (chấm graphite trên nền tối có thể chìm → thuộc BL-06/04, không sửa trong hunk này). |
| 2 | `SCPCarSplit+Panel.m:244` | Mặt panel bố cục (SVG 04) | Ảnh hưởng nhỏ: mesh graphite phủ kín contentView (Panel:246) nên blur gần như không lộ; đổi blur chỉ ảnh hưởng viền/mép ngoài mesh. Hunk mesh mới là yếu tố quyết định. |
| 3 | `SCPCarSplit+Picker.m:782` | Mặt sheet picker nhánh original (SVG 02/03) | Ảnh hưởng nhỏ–trung bình: mesh phủ contentView (:800) che phần lớn blur; blur lộ ở mép + khi mesh chưa kịp vẽ. **Nhánh HL49 no-blur (:781,790 — trắng 0.32) KHÔNG qua factory này**: đổi riêng → `#100923` alpha 0.32 (giữ hợp đồng "mờ nhẹ để thấy app sống bên dưới"). Nhánh này chỉ tới được khi HL51=NO — **F-adjacent**. |
| 4 | `SCPCarSplit+RatioMenu.m:331` (trong `SCPStyleRatioMenu` :323–341) | Mặt ratio menu + mặt bar native (SVG 04 + bar) | Ảnh hưởng nhỏ: mesh phủ (:334) che blur; blur lộ ở mép. Shadow đen 0.3/14 của `SCPStyleRatioMenu` giữ. |

### 2c. Blur riêng của bar hosted — `ABHostBMethods.m:1217–1219` (gương `src/AppBridgeB/` KHỚP)

```objc
UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:11]];
// + mesh ABApexGraphiteSkinImage() (:1164–1181, gradient graphite) vào contentView (:1220–1226)
// + border stroke (53,81,95)@0.85, radius 22 (:1227–1231)
```

| Hunk | Giữ nguyên | Rủi ro |
|---|---|---|
| Style 11 → 16 (cùng twin tối, cùng cảnh báo INFERRED) | Frame bar 52pt, cornerRadius 22, clipsToBounds, `userInteractionEnabled = NO` của blur | Thấp–trung bình: bar hosted có mesh riêng che blur nên đổi blur ít lộ; đổi mesh hosted mới lộ rõ |
| Mesh hosted gradient graphite → `#100923 → #1B1138` (helper `:1164–1181`, cùng pattern `dispatch_once` 64×64 như native) | Helper tĩnh riêng từng file (không gộp với native — TASK1 đã chốt 3 helper riêng) | Thấp |
| Border blur `(53,81,95)` @0.85 → `#DBB9FF` @0.85 | BorderWidth 1 | Thấp |

**Không đổi trong BL-05:** hosting window của sheet (`-trayWindowForPane:` / `SCPHL49SameWindowPicker` Picker.m:554–573, 1502); thứ tự layer; hit/hitbox (knob, SCPCButton, handle); thứ tự view trong bar/panel/picker; default pref HL51=YES (Picker.m:569, 770), HL49LiveUnderSheet (Picker.m:773), HL49HostedSameWindowPicker (Picker.m:571); timer tự ẩn bar 4.0s; cơ chế `SCPApplyAccent`; `OMCLiteActive()` và toàn bộ `OMCCommon.c`.

## 3. Điểm chạm F/C (đánh dấu F-adjacent) và điểm cần master asset

**F-adjacent (cần hunk duyệt trước khi code, theo cổng V3):**
- BL-05 toàn bộ: factory vật liệu dùng chung 5 bề mặt + nhánh Lite fallback là đường hành vi dự phòng (F-adjacent, không phải F trực tiếp vì không đổi logic — nhưng đổi 1 chỗ đổi 5 mặt, và Lite liên quan trạng thái nhiệt/máy yếu).
- Nhánh HL49 no-blur trong Picker.m:781–790: màu nền trắng 0.32 → tối 0.32 — nhánh này quyết định app sống có lộ qua sheet không (F-adjacent, giữ nguyên điều kiện chọn nhánh).
- Mặt picker trong pane + cover (Picker.m:368–372, 299–305): alpha 1.0 là hợp đồng che nội dung — hunk chỉ đổi màu, cấm đổi alpha (F-adjacent).
- `SCPColorSecondary()` + `SCPStyleChip()`: helper dùng chung nhiều bề mặt — đổi 1 chỗ đổi nhiều nơi (C-adjacent: coupling, không phải runtime F).

**Không chạm F/C (hằng số trình bày thuần):** navy/separator/title/wrapper/shadow icon/panel, ghost fallback, ratio separator/tint/ring, float border, preview slot-map, dots, toast, mesh gradient + border trong `SCPApplyMeshBackdrop`/helper hosted.

**Cần master asset gốc — KHÔNG dùng để build:**
- Thumbnail `assets/logo_D_purple_reference_preview.webp` chỉ là preview webp lossy — **không upsample, không ship làm icon**. Không có hunk nào trong BL-04/BL-05 cần bitmap (toàn bộ là hằng số màu + mesh vẽ bằng code). Master asset thật (PNG gốc trong ZIP hội thoại) cần được import riêng trước P2 nếu V3 cần thay icon/logo — ngoài phạm vi cụm này.
- 23 SVG trong `screens/` là preview tối ưu cho review, không phải artwork master byte-for-byte — không trích bitmap từ SVG để build; các tông trang trí trong SVG không thuộc palette SPEC.

## 4. Nhóm commit đề xuất (mỗi commit = một đơn vị revert; copy project → src trong cùng commit)

1. **BL-04a picker constants** — Picker.m (navy/separator/title/wrapper/shadow icon/lavender face+cover/dots/toast) + Drag.m (ghost).
2. **BL-04b ratio/panel** — RatioMenu.m (separator/tint/ring) + Panel.m (shadow/border/glyph) + Zoom.m (float border) + Picker.m pickerMap (ô preview/+/dots — hoặc gộp vào BL-04a vì cùng file; tách theo file thì pickerMap vào BL-04a).
3. **BL-05a material factory** — SCPCarDividerView.m (style + Lite) + Chrome.m mesh gradient/border + ABHostBMethods.m blur+mesh+borders hosted.
4. **BL-05b/04c shared helpers** — Chrome.m `SCPColorSecondary()` + `SCPStyleChip()` (ảnh hưởng chéo picker/panel/ratio/bar).

**Chưa xác minh được (ghi UNKNOWN, không đoán):** số style blur Dark chính xác trên thiết bị (16 là twin suy từ tên INFERRED của 11); độ tương phản chấm graphite của knob trên nền blur tối sau đổi (cần ảnh thiết bị); tông SVG trang trí có được GPT chốt thành token palette mới hay không.


# PHẦN 3 — BL-06, BL-07 (tay nắm + glyph hosted)


Chỉ-đọc. Nguồn: kit `V3_PURPLE_HORIZON_DESIGN/` (SPEC + MUSE_HANDOFF + SVG 01/05/06/13), P0 `APEX_V3_P0_BANG_PHU_20261114.md` (B-N1/B-N2/B-H1/B-H2/B-H3, mục 3), source `project/` + gương `src/`. Gương đã kiểm bằng `cmp`: **cả 3 file đều khớp từng byte** — `SCPCarSplit+Chrome.m` ↔ `src/SplitScreenA/`, `ABHostBMethods.m` ↔ `src/AppBridgeB/`, `SCPCarSplit+RatioMenu.m` ↔ `src/SplitScreenB/` (mọi hunk dưới đây phải chép gương theo kỷ luật project→src).

## 0. SỰ THẬT THIẾT KẾ TỪ KIT (cơ sở của mọi hunk)

- **Tay nắm V3 = "one violet luminous line"** (SPEC + SVG 13): capsule 54×20 (đơn vị SVG) fill `#1B1138`, stroke `#8862BD` 1.2, bên trong **một vạch 32×4 rx 2** với gradient `bright` ngang `#DEBAFF → #A16EFF (45%) → #6F42CF`. Ba trạng thái trong SVG 13 — *Bình thường / Hiện thanh lệnh / Đang chạm* — **vẽ Y HỆT NHAU**: tay nắm V3 có hình thức KHÔNG ĐỔI theo trạng thái. Filter `glow` có định nghĩa trong SVG nhưng **không gắn vào bất kỳ phần tử tay nắm nào** (grep = 0 trên cả 4 SVG) → không có hào quang.
- Quy đổi sang pt thật (tay nắm thật 34×12; SVG vẽ ở ~1.6×, tỷ lệ x/y không hoàn toàn đồng nhất nên đây là **ước lượng từ sơ đồ, không phải số master**): vạch ≈ **frame (6.9, 4.8, 20.1, 2.4) pt, rx ≈ 1.2**, nằm giữa pill 34×12. Số pt chính xác phải chốt từ master board (xem mục 4).
- SVG 05/06: cùng tay nắm đó đặt trên thanh lệnh 52pt; chú thích 05: *"giữ nguyên 5 selector, khung gốc 52pt"*; chú thích 06: *"glyph phải dùng template/tint thật, không còn màu đen"*. SVG 01: một tay nắm cùng hình học trong khung split.

## 1. BL-06 — TAY NẮM (cả hai phía)

### 1a. Trạng thái hiện tại (đã đọc source, không suy đoán)

| | Native | Hosted |
|---|---|---|
| Điểm dựng | `SCPCarSplit+Chrome.m` `-setupBarForPane:` :182–218 | `ABHostBMethods.m` `-setupHandleForPane:` :1341–1370 |
| Pill | 34×12, nền trắng 0.35, viền trắng 0.55/0.5pt, radius 6 (:183–189) | 34×12 tại (5,6) trong hit 44×24, nền trắng 0.35, viền trắng 0.55/0.5pt, radius 6 (:1343–1347) |
| Chấm | 3 chấm 4×4, tâm x=9/17/25, y=6 (vòng dx −8..16, :193–202), graphite (16,24,32)@0.85 | 3 chấm 4×4 tại (dotX,4), dotX 9→23 bước 7 (:1348–1356), graphite (16,24,32)@0.85 |
| Gesture | Gắn TRỰC TIẾP lên pill: tap→`handleTapped:` (Zoom.m:63), double-tap→`handleDoubleTapped:` (Zoom.m:51, tap chờ double-tap fail), pan 1 chạm→`handlePanned:` (Drag.m:53) (:204–218) | Gắn lên `handleHit` 44×24: tap→`handleTapped:`, pan 1 chạm→`handlePanned:` (:1358–1363); **không double-tap** |
| Căn vị trí | `layoutBarForPane:` :282–285: tâm (width×0.5 + handleShift, 12), `hidden = (vc == nil)`; bringSubviewToFront handle rồi bar (:324–325) | `setHandleVisible:` :1374–1378: tâm handleHit (box.width×0.5 + handleOffset, 12), bringSubviewToFront; `layoutBarForPane:` :1258–1260 đưa bar rồi handleHit lên trước |
| Accent khi bar hiện/ẩn | `SCPApplyAccent` (Chrome.m :110–156): BẬT = gradient cyan-teal `#79EDF4→#218FAA` chèn index 0 + glow teal; TẮT = gỡ layer + shadowColor tím (0.431,0.392,0.784) với opacity 0 (sót ẩn). Chỉ gọi từ `setBarVisible:` (:350 BẬT / :363 TẮT). Bản sao riêng ở Picker.m (:51, gọi :1322/:1959 cho nút preview slot-map) — **không liên quan tay nắm** | `ABApplyAccent` (:356–383): BẬT = chèn gradient cyan-teal `#79EDF4→#218FAA` ("omcAccent") + nền handle clear + **đổi màu nền MỌI subview** (trắng khi bật, graphite khi tắt); TẮT = gỡ gradient + nền handle trắng 0.35. Chỉ gọi từ `setBarVisible:` (:1292) và `hideBarForPane:` (:1317), đều trên `pane.handle`. Gradient "omcAccent" thứ hai ở `-setKnobs:` (:1663–1677) thuộc **knob chia màn, không phải tay nắm** — cấm đụng trong hunk này |

### 1b. Bảng hunk BL-06

| Hạng mục | Màn SVG | File:method:dòng (+gương) | Hunk / phương án | Giữ nguyên | Rủi ro | Rollback |
|---|---|---|---|---|---|---|
| BL-06a — Pill native: đổi màu nền/viền | 13, 05, 01 | `SCPCarSplit+Chrome.m` `-setupBarForPane:` :183–189 (gương `src/SplitScreenA/`) | Pill: nền trắng 0.35 → `#1B1138`; viền trắng 0.55 → `#8862BD`, giữ width 0.5pt, radius 6, frame 34×12 | Frame, radius, cornerCurve, thứ tự addSubview | Thấp — chỉ hằng số màu | Revert 2 dòng màu |
| BL-06b — Native: thay 3 chấm bằng vạch tím | 13 | Cùng file, :193–202 | Xóa vòng lặp chấm; thêm **một CAGradientLayer** (đặt tên, vd `v3HandleLine`) trực tiếp trên `handle.layer`, frame ≈ (6.9, 4.8, 20.1, 2.4) pt, cornerRadius ≈1.2, gradient ngang `#DEBAFF → #A16EFF → #6F42CF` (startPoint (0,0.5), endPoint (1,0.5)). **Dạng layer, không phải UIView con**: `SCPApplyAccent` chèn gradient ở index 0 nên vạch luôn nằm trên; AutoHide fade alpha áp lên cả view nên vạch mờ theo đúng tay nắm | Gesture/selectors, `pane.handle`, frame 34×12 | Thấp–trung bình: frame layer tĩnh — an toàn vì frame tay nắm không bao giờ resize (layout chỉ đổi `center`); nếu làm dạng UIView con thì `SCPApplyAccent` không động vào nó (helper chỉ động layer/shadow) nên vẫn được, nhưng layer gọn hơn và không tạo thêm bề mặt hit-test | Revert: khôi phục vòng chấm + xóa layer |
| BL-06c — Native: trung hòa accent trên tay nắm | 13 (3 trạng thái giống hệt) | `SCPCarSplit+Chrome.m` `SCPApplyAccent` :110–156 + điểm gọi :350/:363 | **Khuyến nghị: biến helper thành visual no-op có chú thích** (giữ nguyên hàm + 2 điểm gọi; bỏ phần chèn gradient/glow và phần gán shadowColor tím sót ở nhánh tắt). Lý do: SVG quy định tay nắm không đổi theo trạng thái; helper này trong TU Chrome chỉ phục vụ tay nắm (Picker có bản sao riêng, không ảnh hưởng). Phương án thay thế: đổi màu gradient accent sang violet — nhưng sẽ tạo hiệu ứng "pill sáng lên khi bar hiện", **lệch SVG** (pill trong SVG luôn `#1B1138`); chỉ chọn nếu GPT/Nguyen muốn giữ tín hiệu trạng thái | **Không đụng `setBarVisible:`** (hàm chứa completion 4 lệnh có thứ tự + timer 4s + `bwRecomputeForPane:` — vùng wake, C1); không đụng `layoutBarForPane:` (bwRecompute :326 + `ahApplyCurrentStateToView:` :327) | Thấp (helper TU-local, chỉ 2 điểm gọi, đều trên handle). Rủi ro còn lại: mất tín hiệu thị giác "bar đang hiện" trên tay nắm — là quyết định thiết kế, cần GPT/Nguyen xác nhận, không phải rủi ro code | Revert helper về bản cũ |
| BL-06d — Pill hosted: đổi màu nền/viền | 13, 06, 01 | `ABHostBMethods.m` `-setupHandleForPane:` :1343–1347 (gương `src/AppBridgeB/`) | Nền trắng 0.35 → `#1B1138`; viền trắng 0.55 → `#8862BD`; giữ frame, radius 6, `userInteractionEnabled = NO` | Frame 34×12 tại (5,6), hit 44×24 | Thấp | Revert 2 dòng |
| BL-06e — Hosted: thay 3 chấm bằng vạch tím | 13 | Cùng file, :1348–1356 | Xóa vòng lặp chấm; thêm CAGradientLayer `v3HandleLine` trên `handle.layer`, cùng hình học/màu như BL-06b. **BẮT BUỘC dạng layer, không phải UIView con**: `ABApplyAccent` duyệt `view.subviews` và ghi đè `backgroundColor` của mọi subview (:379–383) — UIView vạch sẽ bị sơn lại nền (trắng/graphite), còn layer thì vòng lặp không chạm tới | Gesture trên `handleHit`, `autoresizingMask` flexible L/R (:1364–1365), gán `pane.handle/handleHit/box.handleHit` (:1366–1368), `setHandleVisible:YES` (:1370) | Trung bình nếu làm sai dạng (UIView con) — là lỗi dễ mắc nhất của hunk này; dạng layer thì thấp | Revert: khôi phục vòng chấm + xóa layer |
| BL-06f — Hosted: trung hòa accent trên tay nắm | 13 | `ABHostBMethods.m` `ABApplyAccent` :356–383 + điểm gọi :1292/:1317 | Sửa helper (giữ nguyên hàm + 2 điểm gọi): nhánh BẬT bỏ phần chèn gradient cyan-teal, giữ nền handle clear; nhánh TẮT **đổi nền handle trắng 0.35 → `#1B1138`** (đây là trạng thái nghỉ thường trực — quên dòng này là pill trắng lại như cũ) và giữ lệnh gỡ gradient (phòng vệ); vòng lặp đổi màu subview trở thành no-op sau khi chấm bị xóa (giữ nguyên vòng lặp, không xóa hàm). Không đụng `-setKnobs:` (:1603+, accent knob riêng) | **Không đụng `setBarVisible:pop:dim:single:`** (guard equality + entrance spring + `hideBarForPane:` fade 0.18s) và `hideBarForPane:`; không đụng `layoutBarForPane:` (:1251–1260) | Trung bình: điểm gọi :1292 chạy TRƯỚC guard `bar.isHidden == visible` nên helper phải an toàn khi gọi thừa (no-op thỏa mãn); quên đổi nền nhánh tắt = hồi quy trắng — kiểm bằng checklist visual | Revert helper |
| BL-06g — Căn vị trí (không đổi) | 13 | Native `layoutBarForPane:` :278–327; hosted `setHandleVisible:` :1374–1378 | **Không hunk** — chỉ ghi nhận: tâm tay nắm native (width×0.5 + handleShift, 12), hosted (box.width×0.5 + handleOffset, 12) | Toàn bộ | Không có | — |

**Điểm chạm F/C/K (BL-06):** C1/C2 — tay nắm nằm trên đường wake (tap) + AutoHide (fade tại layout) ở cả hai phía; bất đối xứng double-tap (chỉ native) là hành vi, cấm đồng nhất hóa. Hunk trong 2 file dùng chung (`SCPCarSplit+Chrome.m`, `ABHostBMethods.m`) → cần duyệt hunk theo luật file dùng chung. Không chạm: selector/action, thứ tự gọi `bwRecompute`/`ahApply`, `handleShift`/`handleOffset`, timer 4s, completion 4 lệnh của native, guard equality + spring của hosted, knob accent (`-setKnobs:`), Picker copy của `SCPApplyAccent`. **Asset cần master gốc:** không cần bitmap cho tay nắm (vạch vẽ bằng code); chỉ cần xác nhận số pt chính xác của vạch từ master board (mục 4).

## 2. BL-07 — GLYPH HOSTED (tint sống như native)

### 2a. Cơ chế hiện tại (đã đọc source)

- `ABSetBarButtonContent` (`ABHostBMethods.m` :401–503): cache tĩnh `NSMutableDictionary` key = `name`; size 22 (tên `hm_*`) / 20; `UIGraphicsImageRenderer` (không opaque → nền trong suốt); `[[UIColor blackColor] set]` (:410); stroke (lineWidth 1.5–2.4 theo glyph, round cap/join) + fill song song, chốt ở tail chung; **`imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal` (:501)**; `cache[name] = image`; hiển thị qua `[(UIImageView *)[button viewWithTag:7302] setImage:image]` (:503); `accessibilityLabel = title`.
- `ABMakeBarButton` (:510–536): `button.tintColor = tint` (:514); plate surface.1 + stroke; icon `UIImageView` tag 7302, frame inset 6, `contentMode = Center` (:527–531); gọi `ABSetBarButtonContent` (:530). 5 nút duy nhất tạo tại `buildBarForPane:` :1188–1197 với tint **Ice (234,246,251)** cho 4 nút và **danger `#FF4757`** cho close. Đổi nội dung ở `setBarVisible:` (:1282 pop, :1287 solo) dùng lại cùng button; `popButton.alpha = dim ? 0.35 : 1.0` (:1290).
- Đối chiếu native: `SCPRenderTemplateImage` (`RatioMenu.m` :26–55) — cùng mẫu vẽ (đen + stroke 1.8 round + fill) nhưng trả **`AlwaysTemplate` (:54)**; `SCPDrawSymbolIcon` (:61+) cùng họ glyph; cache key `name/size/0` (:197–200); tint ăn qua `button.tintColor` ở điểm dùng (`SCPBarButton`, `Chrome.m` :165; chip ratio `RatioMenu.m` :263). Native cũng hiển thị qua UIImageView con (tag 0x1c86) → **khác biệt kiến trúc duy nhất là rendering mode**.
- Phạm vi ảnh hưởng đã kiểm: caller của `ABSetBarButtonContent` chỉ có `ABMakeBarButton` (:530) + 2 điểm swap nội dung cùng file (:1282, :1287); nhánh glyph cũ (`fullscreen`/`replace`/`close`/`float`/`dock`) **không có caller nào trong source hiện tại** (chỉ còn nhánh `isEqualToString` trong hàm) → đổi mode không làm đổi hành vi bề mặt sống nào ngoài 5 nút `hm_*`. `ABBarButton` (`ABChromeViews.m` :169+): `pointInside:` nới hit ≥44pt + `setHighlighted:` spring scale — không liên quan tint.

### 2b. Bảng phương án BL-07

| Hạng mục | Màn SVG | File:method:dòng (+gương) | Hunk / phương án | Giữ nguyên | Rủi ro | Rollback |
|---|---|---|---|---|---|---|
| **BL-07A — PHƯƠNG ÁN CHÍNH (khuyến nghị): đổi mode sang Template** | 06 | `ABHostBMethods.m` `ABSetBarButtonContent` :501 (gương `src/AppBridgeB/`) | **1 dòng:** `AlwaysOriginal` → `AlwaysTemplate`. Tùy chọn +1 dòng phòng vệ: trong cùng hàm, sau khi lấy `icon` (tag 7302), gán `icon.tintColor = button.tintColor` (bằng đúng giá trị kế thừa, để việc tint không phụ thuộc ngầm vào chuỗi kế thừa tintColor). Cơ chế: UIImageView vẽ ảnh template bằng tintColor của chính nó, kế thừa qua plate ← button.tintColor (Ice ×4, danger close). Cache key `name` vẫn đúng vì ảnh template không mang màu — cùng một ảnh cache render ra Ice ở 4 nút và danger ở nút close | Hình học glyph + lineWidth từng icon, cache, tag 7302, `[[UIColor blackColor] set]` (native cũng vẽ đen rồi lấy mask alpha — giữ nguyên dòng này), selector/action, `popButton.alpha`, `accessibilityLabel` | **Thấp.** (1) Template chỉ dùng kênh alpha — glyph vẽ bằng stroke/fill đen đặc trên nền trong suốt nên mask đúng; không glyph nào dùng mức xám. (2) Nếu `button.tintColor` từng không được gán thì glyph đen trở lại — nhưng cả 5 nút đều được gán tint lúc tạo và swap dùng lại cùng button. (3) Cache là static trong tiến trình — ảnh cache sau đổi code là template ngay từ lần build đầu, không có ảnh cũ tồn đọng | Revert 1–2 dòng; cache trong bộ nhớ, không cần migration |
| BL-07B — Vẽ glyph bằng màu tint (giữ Original) | 06 | Cùng hàm :410 + chữ ký hàm + cache :402–404 + 3 điểm gọi (:530, :1282, :1287) | Đổi chữ ký để nhận `tint`, vẽ bằng tint thay vì đen, đổi cache key thành `name+tint` | Hình học | **Cao hơn A:** đổi chữ ký + 3 điểm gọi + key cache; nguy cơ cache cũ sai màu nếu key không đủ phân biệt (close danger vs Ice cùng tên `hm_close` ở 2 trạng thái? không — close chỉ có 1 tint, nhưng nguyên tắc vẫn mong manh); trùng lặp cơ chế template của native một cách kém hơn | Revert nhiều điểm; phải xóa cache key mới |
| BL-07C — Tô màu lại ảnh sau khi vẽ (giữ Original) | 06 | Cùng hàm :497–503 | Thêm bước recolor pixel đen→tint mỗi lần hiển thị, cache theo `name+tint` | Hình học | **Cao:** thêm code xử lý ảnh không cần thiết; cùng vấn đề key cache như B; chậm hơn A | Revert bước recolor + key |
| BL-07D — Bỏ UIImageView con, dùng `setImage:forState:` của button | 06 | `ABMakeBarButton` :510–536 + `ABSetBarButtonContent` :503 | Chuyển ảnh lên `button.imageView` thay vì tag 7302 | Layout plate/icon (inset 6, Center), tag 7302 | **Không cần thiết:** native chứng minh đường UIImageView con hoạt động tốt với template; đổi kiến trúc hiển thị đụng layout + `ABBarButton.pointInside`/`setHighlighted:` — rủi ro vượt lợi ích | Revert kiến trúc hiển thị |
| BL-07E — (Ngoài phạm vi hunk này) Đổi GIÁ TRỊ tint sang tím V3 | 05, 06 | `ABHostBMethods.m` `buildBarForPane:` :1186–1189 (tint/closeTint) + native `Chrome.m` :229–233 (biến `navy` = Ice, `red` = danger) | Nếu GPT/Nguyen muốn glyph tím V3 (`#E5CFFF` trong SVG 05/06 thay cho Ice) thì đổi 2 hằng tint ở mỗi phía — là hunk riêng 1 dòng/phía, sau khi cơ chế template đã sống (A). **BL-07 theo phạm vi giao chỉ đổi CƠ CHẾ, không đổi giá trị tint.** Lưu ý: danger của nút close (`#FF4757`) là màu cảnh báo, không thuộc palette tím — giữ nguyên trừ khi thiết kế chốt khác | Giá trị tint hiện tại cho tới khi thiết kế chốt | Thấp | Revert hằng số |

**Điểm chạm F/C/K (BL-07):** file dùng chung `ABHostBMethods.m` → cần duyệt hunk. Không chạm F1–F7 (split engine/cảm ứng): selector, thứ tự 5 nút, `popButton.alpha`, swap nội dung ở `setBarVisible:` đều nguyên. K: tên glyph `hm_*` + key cache `name` là identifier nội bộ — giữ. Không cần asset master (glyph vẽ bằng code, không bitmap).

## 3. BẢNG TỔNG HỢP (theo định dạng yêu cầu)

| Hạng mục | Màn SVG | File:method:dòng (+gương) | Hunk / phương án | Giữ nguyên | Rủi ro | Rollback |
|---|---|---|---|---|---|---|
| BL-06a pill native | 13, 05, 01 | `SCPCarSplit+Chrome.m` `setupBarForPane:` :183–189 (src/SplitScreenA) | Nền → `#1B1138`, viền → `#8862BD` | Frame 34×12, radius 6 | Thấp | Revert 2 dòng |
| BL-06b vạch native | 13 | Cùng file :193–202 | Xóa vòng chấm; thêm `CAGradientLayer` vạch ≈ (6.9, 4.8, 20.1, 2.4) pt, gradient `#DEBAFF→#A16EFF→#6F42CF` ngang | Gesture/selectors, frame, layout | Thấp–TB | Khôi phục vòng chấm |
| BL-06c accent native | 13 | `SCPApplyAccent` :110–156; gọi :350/:363 | Helper thành visual no-op có chú thích (giữ hàm + điểm gọi; bỏ gradient cyan-teal/glow + shadow tím sót) | `setBarVisible:`, `layoutBarForPane:`, timer, completion | Thấp (chỉ 2 điểm gọi, đều trên handle); mất tín hiệu trạng thái — cần GPT/Nguyen xác nhận | Revert helper |
| BL-06d pill hosted | 13, 06, 01 | `ABHostBMethods.m` `setupHandleForPane:` :1343–1347 (src/AppBridgeB) | Nền → `#1B1138`, viền → `#8862BD` | Frame, hit 44×24 | Thấp | Revert 2 dòng |
| BL-06e vạch hosted | 13 | Cùng file :1348–1356 | Xóa vòng chấm; thêm `CAGradientLayer` vạch (cùng hình học BL-06b). **Bắt buộc dạng layer** — `ABApplyAccent` sơn lại mọi UIView con | Gesture trên handleHit, autoresizing, `setHandleVisible:` | TB nếu làm dạng UIView con; thấp nếu dạng layer | Khôi phục vòng chấm |
| BL-06f accent hosted | 13 | `ABApplyAccent` :356–383; gọi :1292/:1317 | Bỏ chèn gradient cyan-teal; nhánh tắt nền handle → `#1B1138`; giữ lệnh gỡ gradient + vòng lặp subview | `setBarVisible:`/`hideBarForPane:`/`layoutBarForPane:`; không đụng `-setKnobs:` | TB: quên nền nhánh tắt = pill trắng lại; guard gọi thừa vẫn an toàn (no-op) | Revert helper |
| BL-07A glyph hosted (CHÍNH) | 06 | `ABHostBMethods.m` `ABSetBarButtonContent` :501 (src/AppBridgeB) | `AlwaysOriginal` → `AlwaysTemplate` (+1 dòng gán `icon.tintColor = button.tintColor` tùy chọn) | Hình học glyph, cache, tag 7302, selector, alpha dim | Thấp | Revert 1–2 dòng |
| BL-07B/C/D | 06 | Cùng hàm | Không khuyến nghị (đổi chữ ký/cache key; recolor; đổi kiến trúc hiển thị) | — | Cao hơn A, không lợi ích thêm | — |
| BL-07E tint tím | 05, 06 | `buildBarForPane:` :1186–1189; native `Chrome.m` :229–233 | Hunk riêng sau A: đổi giá trị tint Ice → `#E5CFFF` nếu thiết kế chốt | Danger close giữ `#FF4757` | Thấp | Revert hằng số |

## 4. QUYẾT ĐỊNH CẦN GPT/NGUYEN CHỐT TRƯỚC KHI CODE + ASSET CẦN MASTER GỐC

1. **Accent tay nắm: no-op hay wash tím?** SVG 13 vẽ tay nắm giống hệt ở cả 3 trạng thái → bản đồ này khuyến nghị no-op (mục BL-06c/f). Nếu muốn giữ tín hiệu "bar đang hiện", phương án thay thế là đổi gradient accent sang violet — nhưng đó là lệch SVG, cần lệnh rõ.
2. **Số pt chính xác của vạch:** (6.9, 4.8, 20.1, 2.4) pt là ước lượng từ SVG preview 1.6× (tỷ lệ x/y của SVG không đồng nhất: 54/34 ≈ 1.59, 20/12 ≈ 1.67). Số chính thức phải lấy từ **master board 23 PNG+23 SVG trong file ZIP 13 MB ở cuộc trò chuyện** (SPEC: SVG trong repo là bản vẽ lại/optimize để xem trước, không phải artwork gốc từng pixel). Không có master bitmap nào khác cần cho cụm này — vạch và glyph đều vẽ bằng code.
3. **Giá trị tint nút bar:** cơ chế template (BL-07A) không quyết định màu; Ice hiện tại hay `#E5CFFF` tím (BL-07E) là quyết định thiết kế — cần chốt cùng lúc với BL-06 để hai phía đồng bộ.
4. **Knob accent cyan-teal ở `-setKnobs:`** (`ABHostBMethods.m` :1663–1677, gradient `#79EDF4→#218FAA` trên knob chia màn) nằm ngoài BL-06/BL-07 nhưng dùng cùng palette APEX cũ — nếu V3 muốn mọi accent tím thì đây là hunk riêng, không tự gộp vào.

**Lưu ý kiểm chứng (không suy đoán):** mọi dòng/số trên đây đọc trực tiếp từ source tại HEAD `8c57ae8` và SVG trong kit; gương project↔src khớp từng byte ở cả 3 file; legacy glyph `fullscreen/replace/close/float/dock` không có caller sống trong source hiện tại; cache glyph theo `name` vẫn hợp lệ sau khi đổi sang template vì ảnh template không mang màu.


# PHẦN 4 — BL-08, BL-09, BL-10, BL-11, BL-12 (bàn phím runtime, trang phụ, nhãn Lề, mesh dormant, liteMode)

## BL-08 — Bàn phím: 2 màu runtime sót (màn 08)

| # | Hạng mục | Màn SVG | File:dòng (+gương) | Hunk dự kiến | Giữ nguyên | Rủi ro | Rollback |
|---|---|---|---|---|---|---|---|
| 08-1 | Màu chữ preview khi gõ + placeholder | 08 | `ABKeyboard.m -updatePreview :465–474` (gương `src/AppBridgeB/ABKeyboard.m` KHỚP): `typed` → `(0.16,0.24,0.0625)` alpha 1.0; placeholder → cùng màu alpha 0.6. Ghi đè `preview.textColor` Ice đã gán ở `buildPanel :545–548` ngay lần gọi đầu (`:307`, `:400`) | `typed` → `#F5F0FF` alpha 1.0 (V3 text primary); placeholder → `#C7B8E4` alpha 0.6 (V3 secondary) | Logic `typed.length` / chuỗi `OMCTr(@"Gõ tiếng Việt kiểu Telex" / @"Gõ để nhập vào app")`, font 13 Medium, `lineBreakMode` | Thấp | Revert 2 literal |
| 08-2 | Màu nhãn hint trên phím | 08 | `ABKeyboard.m :642–645` (trong `-rebuildKeys`): `hint.textColor = (74,79,128)/255 @0.55` | → `#C7B8E4` @0.55 | Font 8, căn giữa, `userInteractionEnabled=NO`, logic `hintText` | Thấp | Revert 1 literal |

Bằng chứng phạm vi: màu slate `(74,79,128)` chỉ còn đúng 1 điểm dùng trong code ABKeyboard.m (chính :642–645; :479 và :806 chỉ là comment ghi chú palette gốc); màu "shadow violet" `(110,100,200)` **không còn điểm dùng nào trong code** (chỉ comment :479–485). Màn 08 xác nhận: nền `#0B0520/#0E0B2A`, phím `#31204D/#3A275C`, chữ `#F5F0FF`, phụ `#C7B8E4`, placeholder "Gõ để nhập vào ứng dụng".
**Câu hỏi thiết kế mở (ngoài BL-08):** màn 08 vẽ phím màu tím V3 (`#31204D/#3A275C`) trong khi phím hiện tại là graphite D13 — đổi màu phím (D1 keyplane) thuộc phạm vi thiết kế D1, **không** nằm trong BL-08 (handoff giới hạn BL-08 ở 2 màu runtime trên); cần GPT xác nhận có đổi D1 theo màn 08 hay giữ graphite.

## BL-09 — Trang Guide/WhatsNew trong app + dòng chẩn đoán trên splash (màn 23, 09)

| # | Hạng mục | Màn SVG | File:dòng (+gương) | Hunk dự kiến | Giữ nguyên | Rủi ro | Rollback |
|---|---|---|---|---|---|---|---|
| 09-1 | Trang Hướng dẫn / Có gì mới (app) | 23 | `OMCNativeSettings.m:1289–1320` (gương KHỚP): `vc.view.backgroundColor = UIColor.systemBackgroundColor`; `UITextView` nền/chữ mặc định hệ thống; nội dung từ key `ONB_P1..4_TITLE/BODY`, `WN_ZOOM_TEXT/WN_KEYBOARD_TEXT/WN_LANG_TITLE` | `vc.view.backgroundColor` → V3 deep `#100923`; `text.backgroundColor = clearColor`; `text.textColor = #F5F0FF`; giữ nguyên constraints 16pt safe-area, `editable=NO/selectable=YES`, toàn bộ key nội dung | Nội dung chữ (key `.strings` app — đã kiểm 0 hit "OmniCar"), luồng push | Thấp | Revert 3 dòng |
| 09-2 | Dòng chẩn đoán trên splash | 09 | `SSSplash.m:95–118` (gương KHỚP): 5 dòng HUD checklist — "Đã kết nối CarPlay", "Pin iPhone %", "Nhiệt độ máy", "Lite mode: on/auto/off", "Car profile" (có điều kiện). Render thật ở `SSStartupViewBuilders.m -ss_buildHud :665+` (rows qua `ss_label`, glyph ✓/"!" theo `ok`, percent count-up ở `ss_applyHud`) | Chỉ đổi màu render trong `-ss_buildHud`: chữ dòng → `#F5F0FF`, glyph ok/failed + percent sang token V3 (cần GPT chốt: palette V3 không có token "ok" xanh — đề xuất giữ chỉ báo thất bại "!" rõ ràng, không tự bịa màu mới) | **Chuỗi dòng** ở SSSplash.m:95–118, logic `ok`/percent count-up, badge "!", điều kiện hiện từng dòng, vòng đời splash | Trung bình (màu render nằm trong Builders dùng chung nhiều scene) | Revert trong `-ss_buildHud` |

**Câu hỏi thiết kế mở:** màn 23 vẽ trang Guide dạng **danh sách chủ đề** ("Giới thiệu DuoCar", "Cách chia hai ứng dụng", "Bàn phím & cảm ứng", "Lịch sử cập nhật", "Thông tin phiên bản") trong khi source hiện tại là 1 text view cuộn duy nhất. Handoff ghi "23 Guide → cosmetic only" → hunk BL-09 chỉ đổi màu, **không** tái cấu trúc thành danh sách; nếu GPT muốn dạng danh sách thì đó là hunk riêng cần thiết kế + duyệt.

## BL-10 — Nhãn SPEEDBUBBLE (màn 21) — QUYẾT ĐỊNH CỦA NGUYEN, KHÔNG PHẢI HUNK KỸ THUẬT

- Vị trí: `OMCNativeSettings.m:438` và `:679` — hai bản sao mảng `keys = @[@"", @"SPLITSCREEN", @"HOME_SCREEN", @"SPEEDBUBBLE", @"PROFILES"]`; tiêu đề trang kind 3 = `OMCNativeLocalized(keys[selected])` (:440). Nội dung trang kind 3 hiện tại **đã là trang Lề** (hàng `@"bubble"` :469 đẩy `OMCLeCompatiblePreferencesController()`; `:557–563`). `OMCNativeLocalized` trả về **chính key** khi không tìm thấy (:63–92) và key `"SPEEDBUBBLE"` không có trong `.strings` của app → màn hình đang hiện đúng chữ `"SPEEDBUBBLE"`.
- Màn 21 tiêu đề là **"Tương thích Lề"** (hàng: Sai lệch GPS −10…+10 · Bong bóng · Giao thức — "Giữ cfg/ack, không đổi").
- Hai phương án (chờ Nguyen chọn): **(a)** Đổi tên hiển thị → "Tương thích Lề": hunk = thay `keys[3]` bằng key bản địa hoá mới (vd `@"LE_COMPAT"`, thêm giá trị en/vi vào app `Localizable.strings`) hoặc gán trực tiếp `OMCText(@"Tương thích Lề", @"Le Compatible")` cho `kind==3` trong `initWithKind` — phải đổi **cả hai** mảng keys (:438 và :679). **(b)** Giữ "SPEEDBUBBLE" — không hunk.
- Dù chọn phương án nào, **cấm đụng**: pref key nội bộ `speedBubbleLook/Color/Src` (:788–789), action hàng `@"bubble"` (:469), key alert `SPEEDBUBBLE_RESET_LAYOUT` (:1251), giao thức Lề `com.chuong.duocar/le024.cfg/.ack` (F9). Rủi ro: thấp (chỉ hiển thị) nhưng bị chặn bởi quyết định, không phải kỹ thuật.

## BL-11 — Xác nhận mesh dormant GIỮ NGUYÊN (không hunk)

- `OMCLogoMeshImage(int)` tại `OMCCommon/OMCCommon.c:1667` (+ `OMCDrawLogoMesh` :1633): palette lavender/hồng gốc nguyên vẹn. **0 caller sống trong 7 module build** — chỉ còn khai báo extern (`SCPCommon.h:53`, `ABHostBMethods.m:14`, `ABKeyboard.m:31`) và comment; bản sao trong `OmniCarCarProbe.m:1619` cũng không có caller. Caller sống duy nhất: `SPPBubble.m:1043` trong module `OmniCarSpeedBubble` — **đã loại khỏi aggregate build**.
- Không nhầm với `OMCLogoMeshImage(void)` của prefs (`OMCCommon.m:524`) — hàm khác, **đang sống** (gọi tại `:398` trong `OMCStyleTable`) và **đã graphite** (A8 DONE).
- **Kết luận: không hunk trong P2.** Nếu V3 kích hoạt lại SpeedBubble thì đây thành hạng mục mới (cần thiết kế + hunk riêng).

## BL-12 — liteMode: việc đo cần gì (không sửa source)

- Mâu thuẫn đã xác minh: `OMCCommon/OMCCommon.h:81` ghi default `@2` (auto); `SSSplash.m:107` đọc `@0` (chỉ để hiển thị nhãn); `OmniCarCarProbe.m:240` và `:1245` đọc `@2` (hành vi).
- Đo trên máy Nguyen (không code): (1) đọc giá trị `liteMode` hiện tại trong domain `com.anlai.omnicar` trên máy (qua app/prefs hoặc log); (2) ghi lại dòng "Lite mode: on/auto/off" trên splash; (3) đối chiếu hành vi auto-lite theo nhiệt trong log CarProbe. Kết quả đo quyết định default đúng trong P2 — **không tự sửa default theo suy đoán**.

## Tổng kết cụm + điểm cần GPT/Nguyen chốt trước P2

| Quyết định cần chốt | Ảnh hưởng |
|---|---|
| Màu phím D1 theo màn 08 (tím `#31204D/#3A275C`) hay giữ graphite D13? | BL-08 chỉ bao 2 màu runtime; đổi D1 là hunk riêng |
| Trang Guide dạng danh sách chủ đề (màn 23) hay giữ text view 1 cột? | BL-09 hiện chỉ đổi màu |
| Màu glyph ok/failed + percent trong `-ss_buildHud` (palette V3 không có token "ok") | BL-09/2 |
| BL-10: đổi tên kind 3 → "Tương thích Lề" hay giữ "SPEEDBUBBLE"? | Chặn bởi quyết định của Nguyen |
| Tạo file `vi/Car.strings` mới hay để vi fallback en cho banner cứu hộ? | BL-02 |

**Số liệu chốt:** BL-01 = 10 điểm (2 plist app + control + layout plist + Root.plist + header + 2 title/alert prefs + 1 helper app + 3 alert prefs + 1 placeholder). BL-02 = 99 file / 392 key (14 locale). BL-03 = 11 điểm (5 xe + 5 prefs + 1 banner). BL-08 = 2 điểm. BL-09 = 2 điểm. BL-10 = 0 hunk (quyết định). BL-11 = 0 hunk (giữ nguyên). BL-12 = 0 hunk (đo). Tổng hunk code/plist trong cụm: **25 điểm + 1 script .strings**, tất cả gương `src/` KHỚP (trừ Resources/plists/layout không có gương).

