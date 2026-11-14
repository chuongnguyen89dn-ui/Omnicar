# APEX M1 — SPEC THIẾT KẾ (DESIGN-ONLY)

> Mốc: M1 DuoCar APEX — chỉ thiết kế/mockup, KHÔNG sửa source.
> Baseline khóa: HL61 `298b7b4a8432037d71db441d0975aca1db1f6e04`, nhánh `feature/duocar-apex-ui-muse-20261114`.
> Căn cứ duy nhất về file/method/số dòng: `MA_TRAN_M0_APEX.md` (ma trận M0, 17 hàng D1–D14 + A1–A3, số dòng tại HL61, cây `project/` là nguồn build thật).
> Token vẽ thực tế: `apex_style.py` (module dùng chung cho mọi mockup M1).
> Trạng thái toàn bộ tài liệu: **CHỜ NGUYEN DUYỆT** — mockup là đề xuất, không phải bằng chứng runtime (xem Mục 6).

---

## 1. BẢNG TOKEN — CŨ / APEX

HEX cũ đo từ source HL61 qua ma trận M0 và `apex_style.py` (`OLD`). HEX APEX khóa trong Issue #1 mục B; sắc có dấu `*` là sắc phối **suy ra** từ token gốc trong `apex_style.py` (`APEX`), không phải token đã khóa trong Issue.

| Thành phần | CŨ (HL61) | APEX |
|---|---|---|
| Nền chính | `#EEF0FB` | Graphite `#101820` (khóa) |
| Bề mặt thẻ | `#FFFFFF` (trắng, `surface` trong `apex_style.py`) | Slate `#1F303D` (khóa) |
| Bề mặt phụ | `#E3E6F7` | `#27394A` * (surface2, phối suy ra) |
| Nhấn / đang chọn | gradient `#9B87F8 → #5DB4F6` (tím cốt lõi toàn cây xe; Chrome `:106–110`, ABHost `:366–367`) | Electric cyan `#61D9F2` (khóa) — trạng thái chọn dùng nền Teal + viền cyan (xem Mục 3) |
| Glow / shadow | Không có hệ glow/token riêng — họ tím nhấn `#9B87F8` kiêm vai trò phát sáng (bảng nhận diện tóm tắt đúng ý này; Issue #1 nêu ví dụ `#6E64C8` nhưng M0 không đo được HEX glow cũ riêng — chưa xác minh) | Teal `#2EA6BB` (khóa) |
| Chữ chính | ink `#4A4F80` | Ice white `#EAF6FB` (khóa) |
| Chữ phụ | `#7A7EA5` (RGB 122, 126, 165 trong `apex_style.py`) | `#8FA6B3` * (sub, phối suy ra) |
| Viền | `#CED1E9` (RGB 206, 209, 233 trong `apex_style.py`) | `#2C4356` * (line, phối suy ra) |
| Nút đóng | `#FF5A5F` (Chrome `:204–205`; ABHost `:1161`) | `#FF4757` — **CHỜ CHỌN** (xem hàng đỏ nhiệt) |
| Đỏ nhiệt (A1) | `#FF0610` — quy đổi của điều phối M0 từ đỏ source (1.0, 0.025, 0.065, α 0.96) tại `SCPThermalEdgeWarning.h:24` (≈ `#FF0610`, RGB 255, 6, 16 trong `apex_style.py`) | Hai lựa chọn: `#FF0610` (giữ nguyên đỏ source) **hoặc** `#FF4757` (đỏ APEX khóa trong Issue) — **TRẠNG THÁI: CHỜ NGUYEN CHỌN**. Cùng quyết định này áp cho nút đóng. Ghi chú M0 Mục 4.9: chuỗi `FF4757` chưa tồn tại trong cây HL61 (grep = 0); các đỏ hiện hữu khác: `#FF5A5F` (nút đóng/Tắt app), `#FF5C54` (gauge startup, `SSStartupView.m:959`), đỏ nhiệt (1.0, 0.025, 0.065) |

Token phụ đã khóa/ghi nhận:

- Nền startup cũ (D9): tím đậm `0x1B0B3A → 0x3B1A78` (`SSStartupViewScenesB.m:287`) — thay bằng nền Graphite APEX.
- Nhấn Prefs cũ (D14): `OMCAccentColor` `0x7B6CF6` sáng / `0xA89BFF` tối (`OMCCommon.m:282` phía Prefs); họ tím `#8B7CFF / #A78BFA / #B7A6FF` — thay bằng cyan/Teal APEX ở lô M2-5 (ưu tiên thấp).
- Xanh trạng thái APEX trong `apex_style.py`: `(61, 220, 151)` — chỉ dùng cho trạng thái bật/tốt phía iPhone, không thay cyan nhấn.
- Phía app iPhone (D5–D8) tại HL61 gần như **không có màu hardcode** (toàn màu hệ thống iOS) — đổi tông ở đó là THÊM hệ màu APEX mới, không phải quét màu cũ (M0 Mục 2, đoạn tài nguyên màu).

---

## 2. THANG ĐO DÙNG CHUNG

### 2.1 Thang chữ (pt)

| Cấp | Cỡ | Dùng cho |
|---|---|---|
| Hiển thị | 28 | Chữ duy nhất của cảnh báo nhiệt A1 (bold, trắng — giữ nguyên cỡ source `:58`); tiêu đề lớn splash |
| Tiêu đề | 22 | Tiêu đề trang iPhone, tiêu đề sheet picker |
| Đầu mục | 17 | Tên nhóm/mục cài đặt, nhãn chính thẻ |
| Thân | 15 | Nhãn hàng cài đặt, nhãn nút, chữ HUD |
| Phụ | 13 | Chữ phụ, mô tả hàng, nhãn ô app picker |
| Chú thích | 11 | Chú thích, số liệu phụ HUD, chấm trang kèm số |
| Nhãn tab | 9 | Nhãn tab/mục điều hướng iPhone (5 mục — cỡ nhỏ để đủ 5 mục trên 390pt) |

### 2.2 Spacing

Thang: **4 / 8 / 12 / 16 / 24** pt. Mọi khoảng đệm, khoảng cách hàng, khoảng cách lưới picker và lề thẻ lấy từ thang này, không dùng số ngoài thang.

### 2.3 Bo góc

| Bo góc | Áp cho |
|---|---|
| 15 | Viền ngoài cảnh báo nhiệt A1 (giữ nguyên `cornerRadius=15` source) |
| 14 | Thẻ và thanh lệnh (khớp `radius=14` trong `draw_bar` của `apex_style.py`) |
| 12 | Ô app trong picker |
| 6 | Handle pill D2 (giữ nguyên bo 6 source) |

### 2.4 Stroke

- Cảnh báo nhiệt A1: viền ngoài **7pt** + viền trong **1.5pt** (giữ nguyên source, xem Mục 3.9).
- Viền thẻ/thanh/sheet APEX: **1pt** màu line `#2C4356` *.

### 2.5 Glow

- Màu glow: Teal `#2EA6BB`, blur **12** (khớp `glow_under(..., blur=12)` và `shadowRadius=12` của viền nhiệt source).
- Cảnh báo nhiệt A1: pulse opacity **0.45 → 1.0**, chu kỳ **0.75s**, autoreverse, lặp vô hạn (giữ nguyên animation source `hl61-thermal-edge-glow`, `SCPThermalEdgeWarning.h:31–37`).

### 2.6 Cỡ icon

| Hạng mục | Cỡ |
|---|---|
| Nút thanh lệnh | Ø36 (vùng nút tròn trên thanh 52pt; glyph 20) |
| Glyph trong nút thanh | 20 |
| Ô app picker | Ø52 (icon trong ô lưới) |
| Icon Home trên xe | 76 |
| Icon Home / app icon iPhone | 60–180 (dải cỡ asset D12 theo ngữ cảnh hiển thị) |

---

## 3. SPEC TỪNG COMPONENT

Mọi kích thước hình/vùng chạm ghi "giữ nguyên" là số đo tại HL61 trong ma trận M0 — M1 chỉ đổi hình thức, không đổi số đo đó.

### 3.1 D1 — Thanh lệnh split + hosted

- Thanh cao **52pt** (split: `SCPCarSplit+Chrome.m -setupBarForPane: :161`; hosted: `ABHostBMethods.m -buildBarForPane: :1158`, rộng 259pt phía hosted giữ nguyên).
- **5 nút** với tên glyph cố định: `hm_apps / hm_full / hm_float / hm_min / hm_close`, cộng nút `hm_split` ở ngữ cảnh split.
- **Một bộ icon duy nhất dùng chung hai phía** (split + hosted) — factory phía split `SCPBarButton :132` (Chrome) và factory glyph `hm_* :387–490` (ABHost) phải ra cùng một bộ hình ở M3; mockup M1 đã vẽ bằng cùng hàm `glyph()` trong `apex_style.py`.
- Hình thức APEX: nền thanh Slate `#1F303D`, viền 1pt line, bo 14, glow Teal mờ dưới thanh; nút Ø36 nền surface2; nút đang chọn: nền Teal `#2EA6BB` + viền cyan `#61D9F2`, glyph trắng; glyph thường Ice white; nút đóng glyph đỏ (theo quyết định chờ chọn ở Mục 1).
- Ràng buộc: C2 (guard + kích thước bar, kiểm cả hai chủ); C7 (mesh — Chrome `:38–41`, ABHost `:1190`); F2 (cùng file Chrome chứa khiên popup `-updatePopupShield :431` → hunk chung phải duyệt trước).

### 3.2 D2 — Handle pill

- Hình pill **34×12**, bo 6, 3 chấm tại x = 9/17/25 (split, trong `-setupBarForPane: :161`).
- **Vùng chạm 44×24 giữ nguyên tuyệt đối** (hosted: `-setupHandleForPane: :1317`; hiện/ẩn: `-setHandleVisible:forPane: :1350`) — C1: vùng chạm lớn hơn hình là có chủ đích đã đo, mockup chỉ vẽ hình 34×12.
- Hình thức APEX: pill nền surface2, viền cyan mờ, 3 chấm cyan `#61D9F2`. Cũ: pill trắng α0.35, chấm trắng.

### 3.3 D4 — Knob + menu tỉ lệ

- Knob divider: hình tròn tại khe chia (vẽ `SCPCarDividerView.m :51–84`; đặt bởi `+Layout.m -layoutKnobOf: :591`). Cũ fill gradient `#9B87F8→#5DB4F6` (`:57–58`) → APEX: nền Slate, viền cyan 2pt, glow Teal, 3 vạch grip cyan.
- Menu tỉ lệ: `+RatioMenu.m -showRatioMenuForDivider: :361`, `-hideRatioMenu :465`; vòng conic 4 màu cũ (`:290–293`, `#A78BFA` tím…) + mesh (`:335`) → vòng APEX: nền Slate, các cung tỉ lệ dùng cyan/Teal/Ice white phân cấp, preset đang chọn tô cyan.
- Giữ nguyên: frame/hit/relay C4 (`-pointInside: :114` nới −26pt giữ nguyên), preset và hành vi chọn; `-saveRatio :334` (`+Divider.m`) ghi pref tỉ lệ — **F10, không đụng ở M1 và không đổi ở lô vẽ M3-5**.

### 3.4 D3 — Picker sheet

- Chủ: `SCPCarSplit+Picker.m` (2.019 dòng) — mở picker `-showPickerForSlot: :344`, dựng sheet `-buildPickerSheetForPane: :662` (mesh `:803`), cửa sổ tray `-trayWindowForParent: :1505` (level StatusBar+65 `:1582`).
- Hình thức APEX: sheet nền Slate bo 14 + viền 1pt line + glow Teal; lưới app: ô bo 12, icon Ø52, nhãn 13 Ice white / phụ 11 sub; chấm trang: chấm đang chọn cyan kéo dài, chấm còn lại line/sub.
- Giữ nguyên: cỡ sheet C3 (`cols×62+20`, +150 cột bản đồ), mức tray +65, cơ chế mặt trong suốt khi đè ô hosted và hitTest xuyên chạm của tray (`:1565–1576`) — F2/F3, không nằm trong phạm vi vẽ.
- Hai biến thể mockup tách riêng: picker native và picker hosted (xem Mục 5).

### 3.5 Thẻ / nút / switch / slider phía iPhone (D5–D8)

- Thẻ: nền Slate `#1F303D` trên nền Graphite `#101820`, bo 14, viền 1pt line, tiêu đề 17 Ice white, mô tả 13 sub.
- Nút chính: nền Teal, chữ trắng/Ice white; nút phụ: nền surface2, viền line; nút nguy hiểm/đóng: đỏ theo quyết định chờ chọn.
- Switch: bật = track Teal + viền cyan, tắt = track surface2 + viền line, núm trắng (khớp `draw_switch` trong `apex_style.py`; cỡ chuẩn 51×31 giữ nguyên).
- Slider: track line, phần đã qua cyan, núm trắng viền cyan (khớp `draw_slider`); điển hình slider GPS offset −10..+10 của D7 (`-gpsChanged: :177`, `-gpsEnded: :185`) — chỉ đổi hình thức, dải giá trị giữ nguyên.
- Hàng cài đặt: nhãn 15, giá trị/phụ 13 sub, chevron/điều khiển bên phải; mọi hàng giữ nguyên key/action (xem Mục 4).

### 3.6 D10 — HUD vitals trên xe

- Hai bề mặt: panel Dock `SCPDeviceVitalsHUD.m` (impl `:32`; `-showForParent:appArea:dockFrame:homeFrame:launcherFrame: :421`; view Dock `SCPVitalsNativeDockView :239`; nhãn pin/nhiệt `:195–218`; panel không nhận chạm `:479`) và hàng trạng thái fullscreen `SCPFullscreenVitalsBubble.m` (`DCFVCreateCarPlayWindow :30`, level +64.0 `:78`; `-layoutStatusLine :234`; `-tick :247`; `-showForConfirmedFullscreenInParent: :320`).
- Hình thức APEX: chữ Ice white, số liệu nhấn cyan, nhãn phụ sub; vị trí, mức cửa sổ (+64.0 / +64.5) và tính xuyên chạm giữ nguyên — C9/F14/F7.
- Nội dung dòng trạng thái giữ nguyên: giờ – pin – nhiệt.

### 3.7 D9 — Splash / màn khởi động trên xe

- Chủ: `SSSplash.m` (458 dòng; cửa sổ `SSSplashWindow` khai tại `SSStartupScreen.h:91`, `windowLevel = Alert+1000 :175`; `-start :185`; `-dismissBecause: :298`; `-tearDown :314`) + cảnh `SSStartupView.m` (1.149 dòng), `SSStartupViewBuilders.m` (1.229 dòng; 93 điểm màu, 17 CAGradientLayer), `SSStartupViewScenesB.m` (699 dòng).
- Hình thức APEX: nền Graphite thay tím đậm `0x1B0B3A→0x3B1A78` (`:287`), logo APEX (Mục 5, ảnh `bang-nhan-dien.png`), chữ Ice white, điểm nhấn cyan/Teal; style mới đi qua cùng dispatch `ss_buildScene`.
- Giữ nguyên: thứ tự dismiss/tearDown C8 — mọi hunk `SSSplash.m` phải báo trước chờ duyệt (lô M3-8).

### 3.8 D13 — Bàn phím hosted tự vẽ (CHỈ hình thức)

- Chủ: `ABKeyboard.m` (848 dòng) — sơn phím `-[ABKey paint:] :175` (gradient phím cũ `#9B87F8→#5DB4F6 :180–182`), `-buildPanel :487` (mesh `:500`), `-layoutPanelIn: :571`, `-rebuildKeys :595`, `-layoutKeys :670`, factory phím `:767/:788`, gửi phím `-send:del:text: :254`. Cờ `ABDrawnKb = YES` tại `ABInApp.m:549`.
- APEX chỉ đổi: màu phím/panel (Slate/surface2, ký tự Ice white, phím nhấn cyan), bo góc, nhãn phụ.
- **Giữ nguyên tuyệt đối**: bố cục hàng/phím, value/command từng phím, engine Telex (kiểm chứng `verify_hl43_shared_telex.py`) — C11/F8. Lô M3-9 là lô cuối của M3, chỉ làm sau khi chốt U3 (DEVICE PENDING, xem Mục 6 của ma trận phủ).

### 3.9 A1 — Viền nhiệt (hình thức đã có tại HL61, M1 chỉ chuẩn hóa token)

- Chủ: `SCPThermalEdgeWarning.h` (70 dòng, header-only), hàm `SCPThermalEdgeWarningCreate(CGRect) :9`. Điểm gọi: `SCPDeviceVitalsHUD.m -showThermalWarningInParent: :68` (gắn `:113`; cửa sổ +64.5 `:110`, hitTest nil `:58`) và `SCPFullscreenVitalsBubble.m -updateThermalWarningWithSample:now: :202` (gắn `:224`; cửa sổ +64.0).
- Spec giữ nguyên từng số source:
  - Bề mặt: nền `clearColor`, `opaque=NO`, `userInteractionEnabled=NO` (`:10–16`) — giữa trong suốt hoàn toàn, không fill đỏ, hai ô vẫn thấy/bấm được.
  - Viền ngoài: **inset 5pt**, `cornerRadius=15`, **border 7pt**, đỏ (1.0, 0.025, 0.065, α 0.96) (`:18–36`); bóng đỏ `shadowOpacity=0.94` / `shadowRadius=12`; pulse opacity 0.45→1.0, `duration=0.75`, autoreverse, lặp vô hạn, key `hl61-thermal-edge-glow`.
  - Viền trong: **inset 12pt**, **border 1.5pt**, đỏ α 0.65 (`:38–49`).
  - Nhãn giữa màn: khung cao 98pt căn giữa dọc (`:51–68`); chữ **DUY NHẤT** `LÀM MÁT THIẾT BỊ CỦA BẠN` (`:58`), bold 28pt, trắng, căn giữa, tối đa 2 dòng, `minimumScaleFactor=0.68`, bóng chữ đen. Không số nhiệt độ, không chữ ngưỡng/nguồn/mô phỏng.
- Điểm chưa quyết: màu đỏ ánh xạ `#FF0610` hay `#FF4757` — CHỜ NGUYEN CHỌN (Mục 1). Ngoài điểm màu này, M1 không đề xuất đổi bất kỳ số nào của A1.

---

## 4. LUỒNG ĐIỀU HƯỚNG iPhone — 3 TAB CŨ → 5 MỤC MỚI

### 4.1 Cấu trúc cũ (HL61)

`OMCNativeSettings.m` (1.271 dòng), `OMCNativeSettingsRootController() :1253`:

| Tab | Tên | Icon SF | Dòng |
|---|---|---|---|
| 0 | Ứng dụng | `square.grid.2x2.fill` | `:1261` |
| 1 | Chia màn | `rectangle.split.2x1` | `:1263` |
| 2 | Cài đặt | `gearshape.fill` | `:1265` |

`selectedIndex=2` (`:1267`) — app mở sẵn ở tab Cài đặt. Các hàng dựng bởi `-makeSections :437`; ghi pref qua `OMCNativeSetPref :26` (thân `:30–37`).

### 4.2 Cấu trúc mới (đề xuất M1)

5 mục: **Bảng điều khiển / Bố cục / Ứng dụng / Thiết bị / Tùy chỉnh**. Nhãn mục cỡ 9 (Mục 2.1) để đủ 5 mục. Đây là thay đổi cấu trúc lớn nhất phía iPhone (D5) — ở M2 phải chia lô nhỏ: skin giữ cấu trúc trước, đổi cấu trúc sau (lô M2-4).

### 4.3 Bảng ánh xạ cũ → mới

| Hàng / chức năng cũ (nguồn M0) | Mục mới | Ghi chú giữ nguyên |
|---|---|---|
| Tab Ứng dụng (tab 0): chọn app đưa lên xe / app bridge | **Ứng dụng** | Toàn bộ hàng và action giữ nguyên; cộng chọn app trực quan + preview (phần mới của D5, không thay hàng cũ) |
| Tab Chia màn (tab 1): bố cục split, tỉ lệ chia | **Bố cục** | Tỉ lệ vẫn qua `-saveRatio` (F10, xem 4.4); cộng preview split trực quan |
| Tab Cài đặt (tab 2) — nhóm tổng quan/trạng thái | **Bảng điều khiển** | Mục mở đầu mới gom trạng thái + chỉ số vitals tóm tắt (phần chỉ số liên quan D8/D10) |
| Trang vitals trong app (D8, `OMCDeviceVitalsController.m`) | **Thiết bị** (và tóm tắt ở Bảng điều khiển) | `-updateVitals :83` giữ nguyên nguồn số liệu |
| Hàng công tắc giả lập cảnh báo nhiệt 37°C (A2, trong nhóm Device của `-makeSections`, `:474–475`) | **Thiết bị** | **Chỉ hình thức hàng công tắc theo D5; logic thuộc A2 khóa cứng** (xem 4.5) |
| Công tắc vitals Dock / fullscreen (`duocarVitalsEnabled`, `duocarFullscreenVitalsEnabled`) | **Thiết bị** | Key + mặc định giữ nguyên (điểm ghi `duocarVitalsEnabled` thuộc U8, mặc định thuộc U10 — chưa chốt ở M0, M1 không tự chốt) |
| Trang điều khiển Lề (D7, `OMCLePrefsHost.m`: master ON/OFF `-masterChanged: :174`, slider GPS offset) | **Thiết bị** | Chỉ hình thức; giao thức F9 giữ nguyên, tránh `-enqueueKey:raw: :164` |
| Trang Startup trong app (D6, `OMCNativeStartup.m`) | **Tùy chỉnh** | Gallery/header tông APEX; key startup C5 giữ nguyên; logo/video người dùng nạp lúc chạy (`Logo/logo.png :578–580`) nằm ngoài cây — phạm vi APEX chưa xác minh ở M0 |
| Các hàng tùy biến giao diện/hành vi còn lại của tab Cài đặt | **Tùy chỉnh** | Gồm cả hình thức Prefs (D14, ưu tiên thấp) ở dạng mục tham chiếu |
| Mọi hàng còn lại trong `-makeSections :437` chưa liệt kê riêng ở trên | Giữ đúng mục tương ứng theo nhóm gốc của hàng (Ứng dụng/Chia màn vào Ứng dụng/Bố cục; Cài đặt vào Bảng điều khiển/Thiết bị/Tùy chỉnh theo chức năng) | Không hàng nào bị bỏ; ánh xạ chi tiết từng hàng phải đối chiếu `-makeSections` khi làm lô M2-4 và báo trước nếu đụng key/default (F10/C5) |

**Khẳng định bảo toàn:** ánh xạ này không làm mất bất kỳ key/action/pref nào — mọi hàng cũ có đúng một mục mới chứa nó; thay đổi duy nhất là vị trí trình bày và hình thức. Mọi hunk đụng `OMCNativeSetPref` hoặc ánh xạ hàng→key/default trong `-makeSections` phải tách riêng, báo trước chờ duyệt (F10/C5) — kể cả hàng công tắc A2.

### 4.4 Pref key đã biết từ ma trận M0

| Key / nhóm | Nguồn trong ma trận M0 | Trạng thái |
|---|---|---|
| `duocarThermalTest37Enabled` | A2 — hàng switch `OMCNativeSettings.m:474–475`, mặc định NO; notify riêng `com.anlai.omnicar/thermaltest37.changed` phát tại `OMCNativeSetPref :30–37` | Logic khóa cứng (A2); chỉ hình thức hàng theo D5 |
| `duocarVitalsEnabled` | D5/D10 — điểm ghi thuộc U8, mặc định thuộc U10 (chưa chốt ở M0) | Giữ nguyên; M1 không chốt mặc định |
| `duocarFullscreenVitalsEnabled` | D10/A1 — điều kiện hiện bong bóng fullscreen `SCPFullscreenVitalsBubble.m:191–195` (OR với `duocarThermalTest37Enabled`) | Giữ nguyên |
| Nhóm `le024.raw.*` | D7/F9 — kho raw của giao thức Lề trong `OMCLePrefsHost.m` | **F9 — cấm đụng**; chỉ hình thức trang |
| Tỉ lệ chia qua `-saveRatio` | D4 — `SCPCarSplit+Divider.m -saveRatio :334` ghi pref tỉ lệ; preset tại `-ratioPresets :353` | F10 — method ghi không đụng ở lô vẽ |
| Key startup | D6/C5 — key của trang Startup (`OMCNativeStartup.m`; `saveLogo: :566`, `styleSelected: :145`) | C5 — giữ nguyên key/kiểu/mặc định |

Ngoài các key trên, ma trận M0 không liệt kê thêm pref key cụ thể theo tên cho D5 — danh sách đầy đủ từng hàng→key nằm trong `-makeSections :437` và phải trích trực tiếp từ source khi làm M2-4, không suy đoán ở M1.

### 4.5 Hàng công tắc giả lập nhiệt — thuộc D5 về hình thức, thuộc A2 về logic

Hàng "Giả lập cảnh báo nhiệt 37°C" (`:474–475`) hiển thị trong cấu trúc D5 nên hình thức của nó đi theo skin D5 (switch APEX, Mục 3.5). Nhưng **logic của nó là A2 và khóa cứng**: cổng `SCPThermalAlarmStep` (`SCPThermalAlarm.h:13`; `realHot = tempC >= 37.0 :19`; `active = realHot || simulated :21`), pref, notify và chu kỳ mẫu 3 giây đều thuộc F14/F10/F5 — M1/M2 không đề xuất đổi bất kỳ phần nào ngoài hình thức hàng công tắc.

---

## 5. BẢNG MAPPING — MOCKUP → COMPONENT → FILE/METHOD CHỦ

Quy ước tên file ảnh: iPhone 390×844, mỗi màn 2 file `-truoc`/`-sau`; CarPlay 640×360 + bản 2x 1280×720, mỗi trạng thái 2 file `-truoc`/`-sau` (+ `-2x`). File chủ là cây `project/…` tại HL61 theo ma trận M0 (bản gương `src/…` không liệt kê lại).

| Ảnh mockup | ID | Component | File chủ (build) | Method / điểm chủ tại HL61 |
|---|---|---|---|---|
| `bang-nhan-dien.png` | D12 (+ D11, D9) | Bộ nhận diện: logo APEX đề xuất (biểu tượng hai ô chia màn), Home icon, AppIcon/Prefs icon | `project/OmniCarApp/Resources/` (AppIcon khai `Info.plist:22–25`), `project/OmniCarPrefs/Resources/` (logo nạp tại `OMCHeaderCard.m:47`) | Toàn cây 15 file PNG, 0 storyboard/xib/Assets.car; icon Home liên quan `SCPAppIcons.m` / `SCPHomeLauncher.m` (D11) |
| `canh-bao-nhiet.png` | A1 | Viền nhiệt nhấp nháy, giữa trong suốt, chữ duy nhất | `project/OmniCarSplitScreen/SCPThermalEdgeWarning.h` | `SCPThermalEdgeWarningCreate :9`; gọi tại `SCPDeviceVitalsHUD.m -showThermalWarningInParent: :68`, `SCPFullscreenVitalsBubble.m -updateThermalWarningWithSample:now: :202` |
| `iphone-bang-dieu-khien-truoc.png` / `-sau.png` | D5 (+ D8, D10 phần chỉ số) | Mục Bảng điều khiển mới: trạng thái + chỉ số vitals tóm tắt | `project/OmniCarApp/OMCNativeSettings.m`; `project/OmniCarApp/OMCDeviceVitalsController.m` | `OMCNativeSettingsRootController() :1253`; `-makeSections :437`; `OMCVitalsPage -updateVitals :83` |
| `iphone-bo-cuc-truoc.png` / `-sau.png` | D5 (tab Chia màn cũ) | Mục Bố cục: chia màn, tỉ lệ, preview split | `project/OmniCarApp/OMCNativeSettings.m` | `-makeSections :437`; tỉ lệ qua `SCPCarSplit+Divider.m -saveRatio :334` (F10, chỉ tham chiếu) |
| `iphone-ung-dung-truoc.png` / `-sau.png` | D5 (tab Ứng dụng cũ) | Mục Ứng dụng: chọn app trực quan | `project/OmniCarApp/OMCNativeSettings.m` | Tab 0 cũ `:1261`; `-makeSections :437` |
| `iphone-thiet-bi-truoc.png` / `-sau.png` | D5 + D7 + D8 | Mục Thiết bị: vitals, hàng công tắc nhiệt A2 (chỉ hình thức), điều khiển Lề | `project/OmniCarApp/OMCNativeSettings.m`; `project/OmniCarApp/OMCLePrefsHost.m`; `project/OmniCarApp/OMCDeviceVitalsController.m` | Hàng nhiệt `:474–475`; `DCLLeStandaloneControls` impl `:30`, `-masterChanged: :174`; `OMCVitalsPage` impl `:13` |
| `iphone-tuy-chinh-truoc.png` / `-sau.png` | D5 + D14 | Mục Tùy chỉnh: các hàng tùy biến + hình thức Prefs (ưu tiên thấp) | `project/OmniCarApp/OMCNativeSettings.m`; `project/OmniCarPrefs/OMCCommon.m` | `-makeSections :437`; Prefs: `OMCAccentColor :282`, `OMCStyleTable :388–398`, `OMCIcon :480` |
| `iphone-startup-truoc.png` / `-sau.png` | D6 | Trang Startup trong app: header/gallery/bố cục | `project/OmniCarApp/OMCNativeStartup.m` | `OMCNativeStartupPage` impl `:77`; `refreshGallery :108`; `styleSelected: :145`; `saveLogo: :566`; factory `:674` |
| `carplay-split-truoc.png` / `-sau.png` (+ `-2x`) | D1 + D2 + D4 | Split: thanh lệnh, handle, knob + menu tỉ lệ | `project/OmniCarSplitScreen/SCPCarSplit+Chrome.m`; `SCPCarDividerView.m`; `+RatioMenu.m` | `SCPBarButton :132`; `-setupBarForPane: :161`; knob vẽ `:51–84`; `-showRatioMenuForDivider: :361` |
| `carplay-hosted-truoc.png` / `-sau.png` (+ `-2x`) | D1 + D2 | Hosted: thanh lệnh + handle phía app bridge | `project/OmniCarAppBridge/ABHostBMethods.m` | Glyph `hm_* :387–490`; `-buildBarForPane: :1158`; `-setupHandleForPane: :1317` |
| `carplay-picker-native-truoc.png` / `-sau.png` (+ `-2x`) | D3 | Picker sheet — biến thể native | `project/OmniCarSplitScreen/SCPCarSplit+Picker.m` | `-showPickerForSlot: :344`; `-buildPickerSheetForPane: :662`; `-trayWindowForParent: :1505` |
| `carplay-picker-hosted-truoc.png` / `-sau.png` (+ `-2x`) | D3 | Picker sheet — biến thể đè ô hosted | `project/OmniCarSplitScreen/SCPCarSplit+Picker.m` | Như trên; hitTest tray `:1565–1576` giữ nguyên (F2/F3) |
| `carplay-fullscreen-truoc.png` / `-sau.png` (+ `-2x`) | D10 | Fullscreen: hàng trạng thái giờ–pin–nhiệt | `project/OmniCarSplitScreen/SCPFullscreenVitalsBubble.m`; `SCPDeviceVitalsHUD.m` | `-layoutStatusLine :234`; cửa sổ `:30` (level +64.0 `:78`); HUD `-showForParent:… :421` |
| `carplay-keyboard-truoc.png` / `-sau.png` (+ `-2x`) | D13 | Bàn phím hosted tự vẽ — chỉ hình thức | `project/OmniCarAppBridge/ABKeyboard.m` | `-[ABKey paint:] :175`; `-buildPanel :487`; `-layoutKeys :670` |
| `carplay-home-truoc.png` / `-sau.png` (+ `-2x`) | D11 | Home xe: nền, blur, dim, tên icon, icon Home mới | `project/OmniCarSplitScreen/SCPHomeLauncher.m`; `SCPAppIcons.m`; `SCPHooks.m` | `SCPHomeLauncherInjectInfo :73`; `SCPHomeLauncherEnsureInLibrary :127`; `SCPInjectDeclarationIfChosen :157`; `Hook_newApplicationLibrary :87` |
| `carplay-startup-truoc.png` / `-sau.png` (+ `-2x`) | D9 | Màn khởi động trên xe: splash + cảnh + logo | `project/OmniCarStartupScreen/SSSplash.m`; `SSStartupView.m`; `SSStartupViewBuilders.m`; `SSStartupViewScenesB.m` | `windowLevel Alert+1000 :175`; `-start :185`; dispatch `ss_buildScene`; cảnh tím cũ `:287` (ScenesB) |

---

## 6. NGOẠI LỆ + NHÃN ẢNH

1. **Ảnh TRƯỚC là dựng lại từ source** HL61 bằng `apex_style.py` — KHÔNG phải ảnh chụp thiết bị, không phải log xe. Mọi ảnh `-truoc` mang dải chú thích: "DỰNG LẠI TỪ SOURCE HL61 — KHÔNG PHẢI ẢNH CHỤP THIẾT BỊ".
2. **Ảnh SAU là mockup đề xuất** — mang dải chú thích: "MOCKUP APEX — ĐỀ XUẤT THIẾT KẾ, CHƯA PHẢI RUNTIME". Mockup không phải bằng chứng runtime, không chứng minh hành vi trên xe.
3. **Nội dung app bên thứ ba giữ màu gốc** trong cả hai phiên bản ảnh: ô bản đồ native và ô video hosted được vẽ bằng hàm riêng (`draw_map_pane`, `draw_video_pane` trong `apex_style.py`) và KHÔNG nhuộm tông APEX — tông APEX chỉ áp cho chrome/bề mặt của DuoCar (xem thêm mục ngoại lệ trong `APEX_M1_MA_TRAN.md`).
4. Logo APEX trong `bang-nhan-dien.png` (biểu tượng hai ô chia màn + knob ở khe chia) là **đề xuất chờ duyệt / sửa / bác**, chưa phải nhận diện đã chốt.
5. Điểm đỏ A1 + nút đóng có hai lựa chọn `#FF0610` / `#FF4757` đang **CHỜ NGUYEN CHỌN** — mockup dùng `#FF4757` để trình bày, không có nghĩa đã quyết.

— Hết SPEC M1. Tài liệu này không sửa file source nào; cây `apex-wt` chỉ đọc. —
