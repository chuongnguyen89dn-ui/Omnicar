# APEX V3 — P4 G0: AUDIT HÌNH HỌC/ASSET — DEB GỐC vs DEB P3 (2026-11-14)

> Chủ trì: Muse (tổng duyệt), 3 tuyến forensic chỉ-đọc. Phạm vi: CHỈ ĐO VÀ ĐỐI CHIẾU — không sửa runtime, không build, theo cổng G0 tại Issue #1 (chỉ đạo khóa #6878846745).
> Hai gói đã mở thật trên VM và xác minh trước khi đo:
> - **GỐC:** `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` — 1.306.228 byte — SHA-256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd` (khớp mã GPT công bố; blob repo `04fca3d0`).
> - **P3:** `com.chuong.duocar_1.0.5-v3p2test1_iphoneos-arm64.deb` — 930.840 byte — SHA-256 `1eb191ade7d09486cb76bf93632155774fad384ce97a221a0d97471d67481e4a` (source `b65741e`).
> Phương pháp: giải nén chỉ-đọc; parser Mach-O tự viết đọc metadata ObjC (giải chained-fixup, slice arm64); PIL đo asset; đối chiếu disasm khôi phục trong `recovered-source/src/**/disasm/` và hằng tại source. **Không chạy bất kỳ binary/script nào của hai gói.**
> Nguyên tắc trung thực: hằng số điểm (pt) KHÔNG để lại vết ở tầng strings/metadata của binary — mọi con số hình học phía gốc đều có nguồn DISASM cụ thể; con số nào không có nguồn thì ghi **KHÔNG ĐO ĐƯỢC / UNKNOWN**, không suy đoán.

---

## 1. KIỂM KÊ HAI GÓI — NHỮNG LỆCH Ở TẦNG MÔ-ĐUN

| Chỉ tiêu | GỐC 1.0.3 | P3 (dòng HL61) | Phán quyết |
|---|---|---|---|
| Tổng file | 176 | 331 (thừa kế cây DuoCar: thêm strings chẩn đoán/tài nguyên đời sau) | Khác theo dòng dõi, đã biết |
| Mach-O | **8, tất cả FAT arm64+arm64e** | **7, arm64 đơn** | arm64e mất do clang-18 của VM hạ slice (giới hạn toolchain đã ghi nhận từ 06/11; máy test arm64 không ảnh hưởng) |
| Dylib MobileSubstrate | **6**: AppBridge, CarProbe, Core, **SpeedBubble**, SplitScreen, StartupScreen | **5**: AppBridge, CarProbe, Core, SplitScreen, StartupScreen | **DIFF MÔ-ĐUN — xem 1.1** |
| Class/method đo từ binary | 66 class định nghĩa; 1.822 instance + 50 class method = **1.872** (khớp độc lập tổng RE cũ) | cây khôi phục (không đếm lại ở G0) | Gốc đã chốt số |
| nib/storyboard/.car | **Không có** — UI dựng bằng code 100% | Không có | MATCH (kiến trúc) |
| Kênh Darwin phía gốc | 40 tên dạng slash + 1 dạng chấm đo từ binary (16 kênh appbridge.*, splitscreen.*, startupscreen.*, speedbubble.*…) | Đã đổi miền theo rebrand (K3, chủ đích) | Theo hợp đồng danh tính |
| Chuỗi `le024`/giao thức Lề | **Không tồn tại trong gói gốc** | Có (F9) | Tính năng đời DuoCar thêm — không phải của gốc |
| Pref keys | 18 key đo từ plist defaults trong gói; đối chiếu 127 key ứng viên của cây khôi phục: 96 có vết trong binary gốc | 31 key không có vết — **toàn bộ là lớp DuoCar thêm sau** (bridgewake.*, duocarHL46–HL51*, voiceAssistant*…) | Cây khôi phục tại HEAD không còn nguyên trạng gốc ở các vùng đó — đã khai báo |
| Icon app trong gói | 180×180 **RGBA** | 180×180 **RGB** (asset master V3) | DIFF định dạng nhỏ, chủ đích V3 |
| URL scheme / bundle app | `omnicar` / com.anlai.omnicar.app | Giữ ở source (K1–K12); staging rebrand đổi hiển thị | Theo khóa |

### 1.1. DIFF MÔ-ĐUN SpeedBubble — khai báo mở, cần GPT/Nguyen phán quyết phạm vi
Gói gốc có `OmniCarSpeedBubble.dylib` độc lập, filter nạp vào SpringBoard + CarPlayApp + **VietMap Live, GOFA, Waze, Wyn** — đây là phía NGUỒN dữ liệu tốc độ (đọc vị trí từ các app bản đồ; strings có CLLocationManager/CARSession/CurrentSpeed). Dòng DuoCar hiện hành (nền HL61 `298b7b4a`, thừa kế nguyên trạng vào P3 — danh sách file P3 trùng 371/371 với apex2 nên **không phải P2/P3 làm rơi**) **không có dylib này**. Phía HIỂN THỊ bong bóng vẫn còn đủ trong cây hiện hành: class `SCPFullscreenVitalsBubble` trong SplitScreen + trang prefs SpeedBubble + các key liên quan.
- Hệ quả đúng mức: các hàng UI nhóm S trong bảng 112 (bề mặt bong bóng/trang prefs) vẫn đối chiếu hình học bình thường; phần thiếu là **đường cấp dữ liệu từ app bản đồ bên thứ ba** — vấn đề runtime/mô-đun, nằm ngoài phạm vi hình học của G0 và ngoài phạm vi UI của P4.
- G0 không tự kết luận đây là cắt bỏ chủ đích của dòng HL hay rơi rớt chưa ai nhận. **Chuyển GPT + Nguyen quyết**: (a) ghi nhận là giảm phạm vi đã biết của nền HL61 và bỏ qua ở P4; hoặc (b) mở hạng mục khôi phục mô-đun riêng ngoài P4.

---

## 2. PHÁN QUYẾT TỔNG DUYỆT TRÊN 112 HÀNG P0

Chi tiết từng hàng (ID, file:method, số gốc kèm nguồn, số P3 kèm dòng, ghi chú ràng buộc) ở **Phụ lục** cuối tài liệu này. Tổng hợp:

- **23 hàng có đủ cặp số hình học gốc/P3: MATCH ở khung và vùng chạm cốt lõi** — thanh 52; nút 48×40; chip 40×40; handle 34×12 hai phía; hit SCPCButton ≥44pt; knob hit +26/+6, dot 14×14; công thức sheet picker (sheetW = cols×62+20, outer +150, corner 24, pitch 62×56, icon 38, cột metadata 150, cancel 32×32); panel phím (tỷ lệ 0.78/trần 280, keysView y=33); viền nhiệt 7.0pt/nhịp 0.75s; header prefs logo 44×44; preview dashboard 55/45 trong thẻ 118. Đây là phần "kích thước gốc" mà chỉ đạo khóa yêu cầu giữ — bằng chứng cho thấy P2/P3 **chưa hề phá** chúng.
- **5 điểm DIFF đã khai báo** (đều là thay đổi chủ đích của vòng P2, nằm TRONG cùng bounding box, không đổi hitbox):
  1. **B-N1 + B-H1** — 3 chấm 4×4 của gốc bị xoá cả hai phía, thay bằng 1 vạch gradient (6.9, 4.8, 20.1, 2.4) theo master. Lệch ở tầng subview — đúng chủ đích thiết kế đã duyệt, ghi DIFF để hồ sơ trung thực.
  2. **B-N9 + B-H3** — blur 11 → 16 cả hai phía: suy luận "twin tối", **chưa có bằng chứng binary/thiết bị** về tương đương vật liệu. Ở P4, chỉ đạo khóa đã chốt giải pháp cứng hơn: nền tím đêm cố định bên trong sheet — điểm này sẽ bị thay thế bởi spec G1.
  3. **B-N4** — lớp accent phủ bounds handle của gốc thành no-op (frame giữ nguyên, lớp vẽ mất).
  4. **B-H2** — AlwaysOriginal → AlwaysTemplate (sửa gốc lỗi icon đen hosted; hình học trùng, cơ chế hiển thị khác gốc).
  5. **A2** — glyph logo trong file đích đổi tỷ lệ (master 395×260 đệm trong suốt thay glyph vuông); khung view/file trùng.
- **5 hàng UNKNOWN (thiếu số phía gốc — BLOCKED, không gọi đạt):** B-N5 (windowLevel của tray), B-N12 (frame riêng của ratio panel trong P0), B-N18 (thân HL50), P5 (chi tiết từng trang con prefs), E3 (default liteMode trên máy thật). Cách đóng từng điểm ghi trong Phụ lục; phần lớn cần GPT trích disasm bổ sung hoặc đo trên thiết bị.
- **84 hàng không có chỉ tiêu hình học** (chữ/asset/cờ/ABI): trạng thái parity suy từ cùng cây source — gồm cả nhãn `SPEEDBUBBLE` giữ nguyên chữ theo lệnh (6 chuỗi trong OMCNativeSettings.m, chờ Nguyen chốt).

## 3. FACTORY/THEME — ĐIỂM PHẢI THỐNG NHẤT CHO KHÓA "MỘT MẶT/MỘT MÀU"

Đo tại source `b65741e`:
- Phía xe native đã hội tụ qua cặp factory chung `SCPKnobFaceView + SCPApplyMeshBackdrop` (picker, bar, ratio, panel, knob) — đây là hạt nhân đúng để làm **nguồn sự thật duy nhất** theo chỉ đạo khóa.
- Nhưng cùng một "mặt kính" hiện có **3 bản sao độc lập**: mesh native (SplitScreen), `ABApexGraphiteSkinImage` (hosted), `ABKbApexGraphiteSkinImage` (bàn phím). P4 phải gom về một factory/một bộ tham số dùng chung cho cả native + hosted + phím — điều kiện kỹ thuật để menu ô 1 = ô 2 và mọi bề mặt cùng một mặt.
- **8 bề mặt tự vẽ còn sót màu thời APEX, chưa qua token V3** (điểm danh cho bộ component G1): plate nút hosted (27,42,52); trang trí knob native + accent active cyan-teal tại `SCPSetKnobActive`; ghost kéo thả ghi đè trắng/#61D9F2; viền phím + bong bóng phím; chấm knob hosted navy; chữ vitals fullscreen tông Ice; gradient startup cyan-teal. (Danh sách file:dòng đầy đủ trong báo cáo tuyến B lưu ở workspace Muse; GPT cần trích chi tiết thì Muse cung cấp nguyên văn.)

## 4. HAI CHỈ TIÊU CHỈ CÓ CÔNG THỨC — KHÔNG CÓ SỐ TUYỆT ĐỐI

- **Keyplane:** binary gốc + disasm chỉ cho công thức động — chiều cao hàng `rowH = floor((cao panel − 5×(n−1))/n)`, font ×0.56, panel neo đáy `MIN(floor(H·0.78), 280)`, keysView y=33, gap 5. Số pt tuyệt đối của từng phím **KHÔNG ĐO ĐƯỢC** từ binary (phụ thuộc kích thước panel lúc chạy). Hệ quả cho G1: spec nội thất phím phải thiết kế theo tỷ lệ/công thức trong khung panel gốc, không theo số tuyệt đối tự đặt.
- **Knob tuyệt đối phía gốc:** cây khôi phục ở vùng knob đã lẫn thay đổi đời DuoCar nên số tuyệt đối phía gốc **KHÔNG ĐO ĐƯỢC** từ cây này; phía P3 đo được đầy đủ (đĩa 66×66 vùng chạm hiệu dụng, dot 14×14). Cần GPT trích disasm gốc bổ sung nếu muốn khóa số knob phía gốc trước G2.

## 5. KẾT LUẬN G0

- Hình học khung/vùng chạm của mọi bề mặt DuoCar sở hữu: **đã đối chiếu gốc ↔ P3, trùng khớp**, trừ 5 điểm DIFF chủ đích đã khai báo và 5 hàng UNKNOWN đã điểm danh. Không có con số nào trong tài liệu này là suy đoán.
- G0 không sửa runtime, không build. **Cổng tiếp theo thuộc GPT (bộ chi tiết từng component cho G1) và Nguyen (duyệt 2 tiêu chí: khác rõ về UI mọi mảng; đúng kích thước gốc + menu 2 ô cùng màu).** Muse chỉ vào G2 sau khi Nguyen duyệt hình.

---

## PHỤ LỤC — BẢNG 112 HÀNG (file:method · số gốc kèm nguồn · số P3 kèm dòng · ràng buộc)

# G0-C — KHUNG BẢNG AUDIT ĐỐI CHIẾU 112 HÀNG P0 (tuyến G0-C, chỉ-đọc, 14/11/2026)

**Phạm vi:** đối chiếu hình học cho đủ 112 hàng của bảng phủ P0 (`APEX_V3_P0_BANG_PHU_20261114.md`, nhóm A:30 · B-N:20 · B-H:4 · D:5 · C:17 · P:8 · S:5 · H:4 · E:19) theo chỉ đạo khóa Nguyen tại Issue #1 comment 6878846745 (thiết kế lại 100% hình thức nhưng **kích thước/hình học gốc phải trùng**; menu ô 1 = ô 2 cùng một mặt/một màu).

**Định nghĩa hai cột số:**
- **Hình học GỐC** = số mà hồ sơ/source khôi phục ghi nhận là của binary gốc: comment bằng chứng trong source khôi phục (địa chỉ `@0x…`, nhãn [VERIFIED], mô tả hành vi binary gốc), P0 Phụ lục A, và thư mục `recovered-source/src/**/disasm/` (SplitScreenB có disasm cho pointInside/handle/picker; AppBridgeB có fin_imp_*/m_ABHost_*). Ghi kèm nguồn.
- **Hình học P3** = hằng/frame thực tế trong source hiện hành tại `b65741e` (worktree đã xác nhận HEAD = b65741e; grep trực tiếp, ghi số dòng).
- Hàng nào P0 không có chỉ tiêu hình học (chỉ chữ/màu/asset/cờ) ghi đúng câu: *không có chỉ tiêu hình học — chỉ asset/chữ*.
- **Cột TRẠNG THÁI để trống** cho tổng duyệt chốt MATCH / DIFF / UNKNOWN.
- Cột ghi chú: ràng buộc vùng cấm (F/C/K theo P0 mục 5–6) + đánh dấu **2-Ô** nếu hàng thuộc diện "menu 2 ô cùng màu" (mặt picker/sheet/bar/handle dùng chung cho 2 pane hoặc có cặp native/hosted phải đồng nhất).

---

## NHÓM A — Brand/asset (30 hàng)

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| A1 | Icon app iPhone + ô Home xe | project/OmniCarApp/Resources/AppIcon60x60@2x.png (120×120), @3x.png (180×180); Info.plist CFBundleIcons | Kích thước chuẩn iOS 60pt @2x/@3x = 120/180px (P0 A1; md5 bản APEX 7f262bbd…) | 120×120 và 180×180 RGB — đã thay bằng icon master V3 ở P2-fix (1545b5a), size/mode giữ nguyên | | Asset; K5 (tên tài nguyên là khoá) |
| A2 | Logo header prefs | project/OmniCarPrefs/Resources/logo.png/@2x/@3x (64/128/192px); OMCHeaderCard.m:48 imageNamed:@"logo", khung hiển thị 44×44 tại layout :110 | Glyph gốc trong khung vuông 64/128/192 (P0 A2) | File vẫn 64/128/192 RGBA; glyph master tỷ lệ 395×260 thu vừa khung + đệm trong suốt (P2-fix); khung view 44×44 không đổi | | Asset; K5 |
| A3 | Icon mục DuoCar trong Cài đặt | project/OmniCarPrefs/Resources/icon.png/@2x/@3x (29/58/87px); layout PreferenceLoader entry.icon | 29/58/87px chuẩn PreferenceLoader (P0 A3) | 29/58/87 RGB giữ nguyên, nội dung = icon V3 (P2-fix) | | Asset; K5 |
| A4 | PackageIcon (icon gói Sileo) | project/OmniCarPrefs/Resources/PackageIcon.png 256×256; control trỏ đường bundle | 256×256 (P0 A4) | 256×256 RGB giữ nguyên, nội dung V3 (P2-fix) | | Asset; giữ đường dẫn |
| A5 | Icon hàng SpeedBubble (prefs) | project/OmniCarPrefs/Resources/SpeedBubbleIcon*.png; nạp qua spec property icon, OMCCommon.m:~384 (P0) / OMCCommon.m hiện hành | Không có chỉ tiêu hình học riêng ngoài kích thước file icon prefs chuẩn — chỉ asset/chữ | Không đổi ở P2/P3 (glyph tính năng, ngoài phạm vi brand) | | Asset; F9 liên quan trang Lề |
| A6 | Icon hàng StartupScreen (prefs) | project/OmniCarPrefs/Resources/StartupScreenIcon*.png; spec property icon | Như A5 — chỉ asset/chữ | Không đổi ở P2/P3 | | Asset |
| A7 | Mesh phía xe (3 helper vẽ bằng code) | SCPCarSplit+Chrome.m:42 SCPApexGraphiteSkinImage / :64 SCPApplyMeshBackdrop; ABHostBMethods.m ABApexGraphiteSkinImage; ABKeyboard.m ABKbApexGraphiteSkinImage — ảnh mesh 64×64 (Chrome.m:45 tại P3) | Ảnh mesh 64×64 vẽ gradient chéo (0,0)→(64,64) (source khôi phục, cả 3 helper) | 64×64 giữ nguyên; màu gradient đổi sang #100923→#1B1138 ở P2 | | Chỉ màu; **2-Ô** (mesh là mặt chung bar/panel/picker) |
| A8 | Mesh bảng prefs OMCLogoMeshImage | project/OmniCarPrefs/OMCCommon.m:524 OMCLogoMeshImage — renderer 120×120 | Renderer 120×120, blob tại (30,20)/(90,40)/(60,95) bán kính gradient 70 (source khôi phục :528+) | 120×120 + toạ độ blob giữ nguyên; màu blob cyan/teal→tím, mint→lavender (P2-fix B2 + tổng duyệt) | | Chỉ màu |
| A9 | Renderer mesh gốc lõi C (dormant) | project/OMCCommon/OMCCommon.c:1633 OMCDrawLogoMesh / :1667 | Palette lavender/hồng gốc; 0 caller sống (P0 A9) | Không đổi (dormant, không hunk ở P2) | | **Vùng cấm lõi C (BL-11)** |
| A10 | Bản sao mesh CarProbe (dormant) | project/OmniCarCarProbe/OmniCarCarProbe.m:1619 | Không caller (P0 A10) — chỉ asset/chữ | Không đổi | | Dormant |
| A11 | Placeholder/wallpaper ô split | SCPCarSplit+... SCPHomeWallView.m:115 (media người dùng) | Không có chỉ tiêu hình học — chỉ asset/chữ (bằng chứng âm: phía xe không nạp bitmap logo) | Không đổi | | Media người dùng |
| A12 | Preview startup/logo tuỳ biến | Module StartupScreen — toàn bộ media người dùng | Không có chỉ tiêu hình học — chỉ asset/chữ | Không đổi | | Media người dùng; S4/K4 |
| A13 | Info.plist: tên app | project/OmniCarApp/Resources/Info.plist CFBundleDisplayName/CFBundleName | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi → "DuoCar" (P2 dd45d8f) | | K1/K2/K3 giữ (id, executable, scheme) |
| A14 | Info.plist: 2 câu quyền Photos | Info.plist NSPhotoLibrary*UsageDescription | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi tên đầu câu → DuoCar (P2) | | Chữ hiển thị |
| A15 | control: Name/Description/Maintainer | project/control | Không có chỉ tiêu hình học — chỉ asset/chữ | Name "DuoCar", Maintainer/ Author "DuoCar Project" (P2); Package giữ com.anlai.omnicar trong cây (K1) | | K1 |
| A16 | PreferenceLoader label | project/layout/Library/PreferenceLoader/Preferences/OmniCarPrefs.plist entry.label | Không có chỉ tiêu hình học — chỉ asset/chữ | Label → "DuoCar" (P2) | | K5 |
| A17 | Thẻ header prefs: tên + version | project/OmniCarPrefs/OMCHeaderCard.m (P0: :57/:63; P3: tên :55, version động :61) — khung thẻ xem P2 | Không có chỉ tiêu hình học ở hàng chữ này — chỉ asset/chữ (khung thẻ ở P2) | Tên "DuoCar"; version đọc động CFBundleShortVersionString (P2) | | Chữ; khung thẻ → P2 |
| A18 | RootListController: title + alert | project/OmniCarPrefs/OMCRootListController.m:207/:334 (số dòng P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi → DuoCar (P2) | | K5 (class giữ) |
| A19 | Root.plist title | project/OmniCarPrefs/Resources/Root.plist /title | Không có chỉ tiêu hình học — chỉ asset/chữ | → "DuoCar" (P2) | | Chữ |
| A20 | Alert title ×3 (prefs) | OMCCommon.m:931; OMCFeatureListController.m:107; OMCStartupScreenController.m:903 (số dòng P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi → DuoCar (P2) | | Chữ |
| A21 | Placeholder prefs startup | OMCStartupScreenController.m:307 ?: fallback | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi → DuoCar (P2), giữ điều kiện ?: | | Chữ |
| A22 | Bản sao SSStartupView trong prefs: 5 fallback | project/OmniCarPrefs/SSStartupView.m:209/1072/1145/1207/1347 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi cả 5 → DuoCar (P2) | | Chữ; S1 (logic scene cấm đụng) |
| A23 | Scene splash xe: 5 fallback | SSStartupViewBuilders.m:318/575/964; SSStartupViewScenesB.m:631; SSStartupScreen.m:911 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi cả 5 → DuoCar (P2) | | Chữ; S1 |
| A24 | Banner cứu hộ song ngữ | project/OmniCarCore/OmniCarCore.c:184/187 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi 6 chuỗi con hiển thị → DuoCar (P2; bản đồ ghi 4, thực tế 6 — đã khai báo); giữ 2 chuỗi chẩn đoán terminate | | Chỉ chuỗi; logic guard giữ (K11) |
| A25 | Helper alert app | project/OmniCarApp/OMCNativeSettings.m:174 OMCAlert (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Title → "DuoCar" (P2) | | = C16 |
| A26 | .strings prefs 16 locale (99/139 file) | project/OmniCarPrefs/Resources/*/*.strings; qua L()/OMCLocalizable | Không có chỉ tiêu hình học — chỉ asset/chữ | Value "OmniCar"→"DuoCar" ở 99 file/392 key; key-diff = 0/139 (kiểm độc lập ở P2) | | **K10** (key giữ tuyệt đối) |
| A27 | Nhãn "nút OmniCar trên dock" | Nằm trong A26 (Localizable) | Không có chỉ tiêu hình học — chỉ asset/chữ | Đã đổi theo A26 | | Chữ mô tả |
| A28 | Đối chứng: thân app đã DuoCar | OMCNativeSettings.m:440/629/682/1053/1413 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Giữ nguyên (đã DuoCar từ trước P0) | | Đối chứng |
| A29 | Đối chứng: gradient header prefs (bản APEX) | OMCHeaderCard.m:37–39 (P0) → P3 gradient :33–35 | Không có chỉ tiêu hình học — chỉ asset/chữ | P2-fix đổi tiếp → #28194D/#1B1138/#100923 (khung thẻ ở P2) | | Chỉ màu |
| A30 | Đối chứng: mesh xe trung tính | = A7 | Không có chỉ tiêu hình học — chỉ asset/chữ | = A7 | | **2-Ô** |

---

## NHÓM B-N — Native phía xe (20 hàng) — module OmniCarSplitScreen

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| B-N1 | Handle native (pill + chấm) | SCPCarSplit+Chrome.m -setupBarForPane: — pill :154, chấm :195–200 (P0) | Pill **34×12**, radius 6, border 0.5; 3 dot subview **4×4** radius 2, center tại (dx+17, 6), dx = −8/0/8 (P0 B-N1 + source khôi phục Chrome.m:184–202) | Pill **34×12** radius 6 (:154/:158) — TRÙNG; **dot bị xoá**, thay 1 CAGradientLayer `v3HandleLine` frame **(6.9, 4.8, 20.1, 2.4)** radius 1.2 (:169–170) — cấu trúc subview KHÁC gốc (thay đổi hình thức có chủ đích của P2/master) | | Gesture giữ (B-N2); **2-Ô** (cặp với B-H1) |
| B-N2 | Gesture handle + wake/AutoHide | Chrome.m:202–218 (tap/double-tap/pan); Zoom.m:51/63; Drag.m:53; bwRecompute/ahApply Chrome:326–327, 368–385 (P0) | Không có chỉ tiêu hình học mới — cơ chế: tap chờ double-tap fail; handle là subview pane, bringSubviewToFront cuối layout | Không đổi ở P2 (grep: các điểm gọi giữ nguyên) | | **Cấm tách (C1/C2 wake)** |
| B-N3 | Bar native + nút action | Chrome.m -setupBarForPane: bar :220; SCPBarButton :127–129; tint :229–233 (P0) | Bar cao **52**; nút **48×40**; chip trong **40×40** tại (4,0); separator **1×30** tại y=11 (source khôi phục + chỉ đạo khóa 6878846745) | Bar (0,0,totalW,**52**) :220; button bounds **48×40** :127; chip (4,0,**40×40**) :129; divider (x+3,11,**1×30**) radius 0.5 :232–234 — TRÙNG | | **2-Ô** (cặp với bar hosted B-H3) |
| B-N4 | Accent handle (SCPApplyAccent) | Chrome.m:113–156 (P0) → P3 no-op | Gradient layer "omcAccent" phủ bounds handle + shadow tím opacity 0 ở nhánh tắt :124–128 (P0) | Hàm thành no-op hình ảnh (P2 BL-06c), giữ chữ ký + 2 điểm gọi — layer accent KHÔNG còn được tạo (khác gốc ở lớp trang trí, frame handle không đổi) | | Cấm đụng setBarVisible/timer (C) |
| B-N5 | Hosting sheet / tray window | SCPCarSplit+Picker.m -refreshPickerSheet :622 (P0), host :672, tray :1502, SCPHL49SameWindowPicker :554–573 | windowLevel cụ thể = **UNKNOWN ở P0** (U1) | KHÔNG TRA ĐƯỢC số windowLevel tuyệt đối bằng grep tĩnh trong lần này (chỉ thấy trayLevel qua log hl51-menu) — cần đo runtime/binary | | **2-Ô** (sheet là mặt chung 2 pane); F (cơ chế window) |
| B-N6 | Mặt sheet picker (vật liệu) | Picker.m:768–805 (P0) → buildPickerSheetForPane: :662+ | Công thức sheet (chỉ đạo khóa + disasm rem2_buildPickerSheetForPane.txt): scale=MIN(96·areaH/areaW,56); cols=MAX(MIN(MAX(count,4),(areaW−194)/62),1); gridH=rowsPerPage·56+4; **sheetW=cols·62+20; outer width=sheetW+150; sheetH=MIN(areaH−16,MAX(headerH+66,gridH+14+extra))**; sheet canh giữa; **corner 24** | Công thức y nguyên tại :707 (scale), :725 (cols qua (areaW−194)/62), :732 (gridH), :737 (sheetH), :742 (sheetW), :745–746 (frame sheetW+150, canh giữa), :750 cornerRadius **24** — TRÙNG từng hằng | | **2-Ô**; F (không đổi window/scene) |
| B-N7 | Cột phụ picker (separator/title/wrapper) | Picker.m:837–862 (P0) → :854/:864 (title/sub), wrapper :816 | Cột metadata rộng **150pt** tại x=sheetW (source khôi phục :816); title (8, wrapperMaxY+8, **134**, titleH); subtitle (8, +2, **134**, subH); titleH/subH đo từ boundingRect 134×40/134×30 (:719/:721) | Số giữ nguyên tại :816 (150pt), :854 (134×titleH), :864 (134×subH) — TRÙNG; chỉ màu đổi (P2) | | **2-Ô**; chỉ màu ở P2 |
| B-N8 | Divider / knob chia màn | SCPCarDividerView.m (toàn file); SCPCarSplit+Layout.m -layoutKnobOf: :591–663 (P0) → :591+ | Knob dot **14×14** (Layout source khôi phục); hit: knob nới **26pt** mỗi phía, thân divider nới **6pt** (DividerView pointInside + disasm SCPCarDividerView__pointInside_withEvent_.txt @0xf174) | knob.bounds **14×14** (Layout.m:595); pointInside: CGRectInset(knob.frame, **−26,−26**) :119 và CGRectInset(bounds, **−6,−6**) :123 — TRÙNG | | **C** (hit là cơ chế — cấm thu nhỏ) |
| B-N9 | SCPKnobFaceView (vật liệu chung) | SCPCarDividerView.m:99–107 (P0) → :99 | Blur **Light style 11**; nhánh Lite = trắng alpha **0.92** (P0 B-N9) | Style **16** (twin tối); Lite → #1B1138 alpha 0.92 (P2 BL-05) — alpha TRÙNG, style KHÁC (đây là thay vật liệu có chủ đích; style 16 là suy luận twin tối — D-13, chưa đo thiết bị) | | **F-adjacent** (1 factory → 5 bề mặt); **2-Ô** |
| B-N10 | Pressed knob (SCPSetKnobActive) | SCPCarDividerView.m:48–95 (P0) | Không có chỉ tiêu hình học riêng ngoài knob 14×14/hit ở B-N8 — trạng thái pressed đổi scale/màu theo code APEX; comment :31–46 còn mô tả màu tím gốc (lệch code — P0 ghi nhận) | Không đổi hình học ở P2 | | Trạng thái; comment lệch giữ nguyên văn |
| B-N11 | Ratio menu | SCPCarSplit+RatioMenu.m:364–466 (P0); chip SCPWrapRatioChip :263–266 | Chip cancel **32×32** radius 16 (Picker.m:881–882 — cùng factory chip); separator menu **1×18**, cursor += 9 (P0/P2 grep RatioMenu); vòng conic giữ tên layer omcRing, mask lineWidth 2 | Cancel bounds **32×32** radius **16** (Picker.m:881–882 tại P3) — TRÙNG; màu separator/tint đổi ở P2 | | **2-Ô** (menu che pane hosted :449–456 giữ) |
| B-N12 | Panel bố cục (layout panel) | SCPCarSplit+Panel.m:228–330 (P0); shadow :236–242; border/glyph :295–312 | Không có chỉ tiêu hình học số riêng được P0 ghi ngoài frame theo layout động — mặt panel dùng SCPKnobFaceView + mesh (B-N9/B-N16) | Không đổi frame ở P2; shadow → #A16EFF, border/glyph → token V3 (chỉ màu) | | **2-Ô** |
| B-N13 | Glyph native (vẽ + template + cache) | SCPCarSplit+RatioMenu.m: SCPRenderTemplateImage :26–55, SCPDrawSymbolIcon :61, cache :197–200 | Canvas glyph theo size yêu cầu (renderer CGSizeMake(size,size) :37); các nét vẽ trong lưới **24×24** (path tại 3.5/7.5/13… — source khôi phục); ảnh trả **AlwaysTemplate** :54 | Canvas + lưới vẽ giữ nguyên tại :37 và các path :78–153 — TRÙNG; tint chip navy :263 đã đổi → #F5F0FF (P2) | | Cơ chế template giữ; cache không tự làm mới |
| B-N14 | SCPCButton (hit + pressed) | SCPCButton.m:13–42; disasm SCPCButton__pointInside_withEvent_.txt @0xe69c | Hit nới để mỗi chiều **≥44pt**: dx=MIN(0,(w−44)·0.5), dy tương tự (comment bằng chứng :12–16 + disasm); pressed spring scale **0.9** | pointInside :20–21 đúng công thức 44pt; setHighlighted scale **0.9** :43 — TRÙNG | | **Cấm thu nhỏ hit (C)** |
| B-N15 | Focus flash + float pane + ô preview | Layout.m focus flash :666–683 (P0); Zoom.m float :~105; Picker.m preview :1318–1327 | Focus flash: border accent dày **2.5pt** (source khôi phục Layout) | borderWidth **2.5** (Layout.m trong đoạn :660–690 tại P3) — TRÙNG; viền float Zoom đổi màu → lavender (P2 bổ sung), độ dày 1.0 giữ | | Chỉ màu ở P2 |
| B-N16 | SCPApplyMeshBackdrop (phạm vi phủ) | Chrome.m:61–79 (P0) → :65 mesh.frame = contentView.bounds | Mesh phủ đúng contentView.bounds của effectView; caller thật: bar/ratio (SCPStyleRatioMenu), panel, picker nhánh original; KHÔNG phủ knob/HL49/placeholder (P0 đã xác minh caller) | mesh.frame = contentView.bounds :65 — TRÙNG; màu mesh đổi (A7) | | **2-Ô** (mặt chung) |
| B-N17 | Mặt picker trong pane + cover kéo | Picker.m:~372 (mặt trong pane), :301–305 (cover) (P0) | Mặt lavender đặc (0.933,0.941,0.984) alpha 1.0 mặc định (P0) | Frame giữ nguyên; màu → #100923 alpha 1.0 (P2) — màu KHÁC gốc theo thiết kế V3 (chủ đích), hình học TRÙNG | | **2-Ô**; recognizer mở sheet :549–556 giữ |
| B-N18 | Các nhánh pref HL46/48/49/50/51/57 | Picker.m:284–774 (các điểm P0 liệt kê); SCPCarSplit.m:2285 (HL51 keep-hosted) | Không có chỉ tiêu hình học riêng — cổng hành vi đọc pref @YES default YES; thân HL50 = UNKNOWN (U2) | Không đổi ở P2 (chỉ màu các mặt; điều kiện nhánh giữ nguyên — đã rà ở tổng duyệt P2) | | **Vùng F — chỉ đọc, cấm đổi default/điều kiện** |
| B-N19 | Lưới icon picker + ghost kéo | Picker.m:905–955; SCPCarSplit+Drag.m SCPStyleGhostIcon :40–47 (P0) → Drag.m:23 SCPStyleDragGhost | Ô lưới theo pitch **62×56**, icon **38×38** (chỉ đạo khóa trích từ source; comment Picker:656 "62x56 app cells"); ghost = kích thước icon kéo theo | Pitch/cell giữ nguyên (công thức B-N6); ghost: nền/border/shadow đổi màu ở P2 bổ sung (frame theo icon, không hằng riêng) | | **2-Ô** |
| B-N20 | Glyph/nhãn theo trạng thái fullscreen/float | Chrome.m:296–322 (P0) | Không có chỉ tiêu hình học riêng — đổi icon/nhãn theo trạng thái, cấm cache cứng | Không đổi ở P2 | | Trạng thái; cấm cache cứng icon nút |

---

## NHÓM B-H — Hosted phía xe (4 hàng) — module OmniCarAppBridge

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| B-H1 | Handle hosted (pill trong hit) | ABHostBMethods.m -setupHandleForPane: :1341–1369 (P0) → hit :1334, pill :1343 | Hit view **44×24**; pill visual **34×12** tại (5,6), radius 6, border 0.5; 3 dot như native (P0 + chỉ đạo khóa) | handleHit (0,0,**44×24**) :1334; pill **34×12** tại (5,6) radius 6 — TRÙNG; **dot bị xoá**, thay CAGradientLayer `v3HandleLine` (6.9,4.8,20.1,2.4) radius 1.2 dạng layer (P2) — cấu trúc subview KHÁC gốc như B-N1 | | Gesture tap+pan giữ, **không double-tap** (bất đối xứng với native — giữ nguyên); **2-Ô** |
| B-H2 | Glyph bar hosted | ABHostBMethods.m ABSetBarButtonContent :401–503 (P0) → :492–503; ABMakeBarButton :505 | Nút **48×40** (:505); icon view con tag **7302**, frame inset **6** (P0 :503); glyph vẽ đen, ảnh AlwaysOriginal :501 | button.bounds **48×40** :505; icon tag 7302 :518 — TRÙNG hình học; rendering mode → **AlwaysTemplate** + gán tint phòng vệ (P2 BL-07A) — cơ chế hiển thị KHÁC gốc (đây chính là sửa lỗi icon đen) | | Giữ hình học glyph hm_* + selector; **2-Ô** (parity với B-N13) |
| B-H3 | Bar hosted + mesh | ABHostBMethods.m -buildBarForPane: :1183–1253 (P0) → bar :1195; blur :1217 (P0) | Bar cao **52**; blur style 11 riêng; mesh graphite riêng (helper :1164–1181) | Bar (0,0,totalWidth,**52**) :1195 — TRÙNG; blur style → **16**, mesh → tím (P2 BL-05) — vật liệu KHÁC gốc như B-N9 | | **2-Ô** (cặp với B-N3/B-N9) |
| B-H4 | HUD trong AppBridge | Toàn module OmniCarAppBridge — grep battery/thermal/clock | Không tồn tại bề mặt HUD (kết luận âm có bằng chứng — P0) | Vẫn không tồn tại (không thêm ở P2) | | Kết luận âm |

---

## NHÓM D — Bàn phím vẽ (5 hàng) — ABKeyboard.m / ABTelex.m

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| D1 | Keyplane + ABKey paint | ABKeyboard.m -key:... :810–871; ABKey -paint: :175–206 (P0) | Hình học phím suy từ layoutKeys (D5): hàng cao rowH = floor((kbH − 5·(n−1))/n), khe **5pt** (comment bằng chứng :687/:707); hint label **11×11** tại (W−13,0) :235 | rowH/gap giữ nguyên (:707 tại P3); hint frame (W−13,0,**11×11**) :235 — TRÙNG; mặt phím → #3A275F, highlight → #7D5EA5 (P2, commit riêng 23bf855) | | **D5** (layout giữ) |
| D2 | Panel phím + field + nút ẩn/lang | ABKeyboard.m -buildPanel :513–584; -layoutPanelIn :590–606 (P0) | Panel: cao = **MIN(floor(H_container × 0.78), 280)**, cách đáy **6** (comment @0x2B3A8 :590–591 + code :603/:605); keysView (5, **33**, W−10, H−38) :704; hideButton **34×24** tại (W−39,5) :697; langButton **26×16** :699; field cao **24** :702 | panelH công thức :603, y :605, keysView :704, hideButton :697, langButton :699 — TRÙNG từng hằng; vật liệu panel blur 11→16 + mesh/viền tím (P2 bổ sung) | | **D5/F8** |
| D3 | Màu runtime preview + hint Telex | ABKeyboard.m -updatePreview :465–474; hint :642–645 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ (màu ghi đè mỗi lần gõ) | Màu → #F5F0FF / #C7B8E4 (P2 BL-08); vị trí preview/hint không đổi | | Cấm đụng Telex (D5) |
| D4 | Bong bóng phím (key pop) | ABKeyboard.m -key:pressed: :731–787 (P0) | Geometry theo bounds phím (kw/kh tại :762), spring giữ (P0) | Không đổi ở P2 | | Geometry/spring giữ |
| D5 | Vùng cấm bàn phím (layout + Telex) | ABKeyboard.m layoutPanelIn :602–618; layoutKeys :700–729; rebuildKeys :620–697; Telex :357–369 + ABTelex.m | Toàn bộ công thức ở D1/D2 là của vùng này — nguồn gốc hình học keyplane | Không file nào trong vùng bị đụng ở P2 (ABTelex.m nằm trong danh sách 10 file cấm — git status P2 xác nhận không xuất hiện) | | **VÙNG CẤM (F8/C11)** |

---

## NHÓM C — App iPhone (17 hàng) — OMCNativeSettings.m + liên quan

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| C1 | Gốc 5 tab | OMCNativeSettingsRootController :1471–1497 (P0); AppDelegate.m:18 | Không có chỉ tiêu hình học riêng — TabBar chuẩn hệ thống, selectedIndex=0 | Không đổi ở P2 (chỉ token màu chảy qua OMCApexStyle ở fix B2) | | Giữ selectedIndex=0 |
| C2 | Dashboard | OMCNativeSettings.m :1346/1411–1426/1457–1468 (P0) | Không có chỉ tiêu hình học số được P0 ghi — bố cục theo code APEX D5-A | Không đổi frame ở P2/P2-fix | | Cấm nối dữ liệu thật vào minh họa (C3) |
| C3 | Thẻ preview chia màn (minh họa tĩnh) | OMCNativeSettings.m :1359–1408 (P0) | Không có chỉ tiêu hình học số được P0 ghi ngoài frame trong code APEX | Không đổi ở P2 | | Minh họa tĩnh |
| C4 | Tab Bố cục kind1 + nhãn ghim | OMCNativeSettings.m :519–539; :581–610/686–688 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ + token | Không đổi ở P2 | | |
| C5 | Tab Ứng dụng (AppsPage) | OMCNativeSettings.m :181/199 (P0) | Empty-state/loading KHÔNG tồn tại trong source (P0) — không có chỉ tiêu hình học | Vẫn không tồn tại (P2 không thêm) | | Trạng thái thiếu — ghi nhận |
| C6 | Tab Thiết bị kind5 | OMCNativeSettings.m :491–518 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ + token | Không đổi ở P2 | | |
| C7 | Tab Tùy chỉnh kind6 + thẻ master | OMCNativeSettings.m :612–668 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ + token | Không đổi ở P2 | | |
| C8 | Nền kind0 | OMCNativeSettings.m :448–490 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ; thứ tự nhóm là bố cục gốc (comment :456–458) | Màu đã theo token; P2-fix chảy token V3 | | Giữ thứ tự nhóm |
| C9 | kind2 Home | OMCNativeSettings.m :541–555 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Không đổi ở P2 | | |
| C10 | kind3 Lề — nhãn SPEEDBUBBLE | OMCNativeSettings.m keys[3] | Không có chỉ tiêu hình học — chỉ asset/chữ (nhãn cố ý giữ từ HL58) | Vẫn "SPEEDBUBBLE" tại P3 — grep xác nhận còn nguyên, 0 dòng diff ở P2 | | **F9** (giao thức Lề cấm đụng); chờ Nguyen chốt (BL-10) |
| C11 | kind4 Hồ sơ xe | OMCNativeSettings.m :564–579 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ; schema carProfiles giữ | Không đổi ở P2 | | Schema giữ |
| C12 | Trang Startup trong app | OMCNativeStartup.m | Không có chỉ tiêu hình học số được P0 ghi | Không đổi ở P2 | | |
| C13 | Trang Lề trong app | OMCLePrefsHost.m | Không có chỉ tiêu hình học — chỉ asset/chữ | Token chảy theo OMCApexStyle (P2-fix) | | **F9** |
| C14 | Pin & nhiệt | OMCDeviceVitalsController.m | Không có chỉ tiêu hình học số được P0 ghi; hiển thị dữ liệu thật | Token chảy theo OMCApexStyle (P2-fix); không bịa số (chỉ đạo khóa: không có dữ liệu thì '—') | | Dữ liệu thật |
| C15 | Guide/WhatsNew trong app | OMCNativeSettings.m :1289–1320 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ (nền systemBackground, không token) | Nền → #100923, text → #F5F0FF, backgroundColor text = clear (P2 BL-09); constraints giữ nguyên | | Chỉ màu ở P2 |
| C16 | Alert app (OMCAlert) | OMCNativeSettings.m :173–179 (P0) → :174 | Không có chỉ tiêu hình học — chỉ asset/chữ | Title → "DuoCar" (P2) | | = A25 |
| C17 | Token app OMCApexStyle.h | project/OmniCarApp/OMCApexStyle.h :1–21 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ (bộ token màu) | Toàn bộ token remap V3 ở P2-fix (b65741e); giữ Amber #F4B75F + Danger #FF4757 | | Màu; dùng bởi 4 file UI |

---

## NHÓM P — Preferences (8 hàng)

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| P1 | Gốc prefs (specifiers) | OMCRootListController.m -specifiers :31–36 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Không đổi cấu trúc ở P2 | | **K5** (ABI) |
| P2 | Thẻ header prefs (khung + logo) | OMCHeaderCard.m — layout :110–114 | Logo **44×44** tại (x,18); name (textX,16,**140×26**); version (…+6,21,**60×18**); tagline (textX,44, W−textX−90, 18); dot trạng thái **8×8** :71 (source khôi phục tại P3 — cùng các hằng này ở bản gốc theo comment [VERIFIED] của file) | logo.frame (x,18,**44×44**) :110; nameLabel :112 (140×26); versionLabel :113 (60×18); tagline :114; dot 8×8 :71 — TRÙNG; gradient/màu đổi (A29) | | Khung giữ; K5 |
| P3 | Root.plist title | = A19 | Không có chỉ tiêu hình học — chỉ asset/chữ | = A19 | | |
| P4 | Hàng feature động | OMCRootListController.m :65–113 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ (featureOrder/controller là ABI) | Không đổi ở P2 | | ABI giữ |
| P5 | Các trang con prefs (AppBridgeApps/SplitScreen/SpeedBubble/StartupScreen…) | OMCPrefs: AppBridgeAppsController, SplitScreen, SpeedBubble, StartupScreen + SSStartupView, CarProfiles, FeatureList | **UNKNOWN mức từng trang ở P0 (U5)** — chưa có số hình học gốc theo trang | KHÔNG TRA ĐƯỢC số gốc theo trang từ hồ sơ hiện có — cần kiểm kê riêng từng trang (ngoài grep lần này) | | U5 |
| P6 | Hệ màu động prefs (OMCCommon.m) | project/OmniCarPrefs/OMCCommon.m — OMCDynamicColor :284; các helper :287–450 | Không có chỉ tiêu hình học — chỉ asset/chữ (cơ chế dynamic light/dark riêng, không import OMCApexStyle) | Thành phần TỐI → V3 ở P2-fix; thành phần SÁNG giữ nguyên (đã khai báo — GPT noted, chờ quyết Light) | | Màu |
| P7 | Onboarding/WhatsNew prefs | OMCCommon.m/RootList :196–200/347/356 (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ | Không đổi cơ chế ở P2 | | |
| P8 | Asset prefs | = A2/A3/A4/A5/A6 | Kích thước file như nhóm A | Đã thay V3 ở P2-fix (trừ A5/A6 giữ) | | Asset |

---

## NHÓM S — Startup (5 hàng)

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| S1 | Splash + vòng đời scene | SSSplash.m; SSStartupScreen.m:284; claim :148–158 | Không có chỉ tiêu hình học riêng ngoài full-bounds của scene xe (màn 640×360 theo ngữ cảnh CarPlay) — vòng đời/claim là cơ chế | Chỉ đổi màu (D9/P2); logic cửa sổ/claim không đụng | | **Cấm đụng logic scene/claim** |
| S2 | Engine scene (Builders/ScenesB) | SSStartupView.m / SSStartupViewBuilders.m / SSStartupViewScenesB.m | Hình học theo bounds scene động; hằng số màu tại chỗ, không import token (P0) | Không đổi hình học ở P2 (chỉ chữ fallback A23 + màu HUD S5) | | |
| S3 | Fallback chữ trên scene | = A23 | Không có chỉ tiêu hình học — chỉ asset/chữ | = A23 | | |
| S4 | Media người dùng | /var/mobile/Library/OmniCar/StartupScreen (đường dẫn trong source) | Không có chỉ tiêu hình học — dữ liệu người dùng | GIỮ NGUYÊN (không đụng ở mọi lô) | | **K4** |
| S5 | Dòng chẩn đoán trên splash | SSSplash.m:95–118 (P0); render thực tế ở SSStartupViewBuilders.m -ss_buildHud | Không có chỉ tiêu hình học số được P0 ghi — dòng chữ trạng thái trên splash | Màu render → #F5F0FF/#A16EFF/#C7B8E4 (P2 BL-09); chuỗi ở SSSplash.m giữ nguyên; nhãn READY dùng chung biến percentColor (đã khai báo) | | Chỉ màu |

---

## NHÓM H — HUD / nhiệt (4 hàng)

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC (số + nguồn) | Hình học P3 | Trạng thái | Ràng buộc / 2-Ô |
|---|---|---|---|---|---|---|
| H1 | Bong bóng fullscreen (giờ/pin/nhiệt) | SCPFullscreenVitalsBubble.m — statusView :242–244, frame :316, cornerRadius :349 | Hàng trạng thái **một hàng trên-trái, không capsule**: cornerRadius = **0** (:349); frame tính từ bounds + left inset (:316 *outFrame); timeLabel (0,0,clockWidth,H) :242; metricsLabel tại batteryX :244 (source khôi phục; điều kiện hiện = "confirmed fullscreen" :187/320 P0) | cornerRadius **0** :349; các frame :242/:244/:316 giữ nguyên — TRÙNG; chỉ màu qua D10/P2 | | Cấm đổi windowLevel/điều kiện hiện |
| H2 | HUD neo Dock | SCPDeviceVitalsHUD.m — neo cây Dock :241 (P0); frame appArea :338–341 | Frame HUD suy từ root/appArea của Dock gốc (CGRectMake theo MinX/MaxX của root tại :338–341) — không hằng pt độc lập được P0 ghi | Không đổi ở P2 (grep: các frame :338–341 giữ nguyên) | | Cấm đụng neo Dock HL51 (F) |
| H3 | Viền nhiệt ≥37°C | SCPThermalEdgeWarning.h:11–70 (P0) → :23/:31–37 | Border **7.0pt**; pulse opacity 0.45→1.0, duration **0.75s**, autoreverses, repeat vô hạn; màu **#FF0610** (source khôi phục) | borderWidth **7.0** :23; pulse 0.45→1.0/0.75s :31–37 — TRÙNG; file nằm trong danh sách cấm — không xuất hiện trong diff P2 | | **GIỮ NGUYÊN (an toàn)** |
| H4 | Cổng nhiệt HL60 + kênh giả lập | Kênh Darwin nhiệt (xem E19); cổng trong OMCCommon | Không có chỉ tiêu hình học — chỉ asset/chữ/cơ chế | Không đổi ở mọi lô | | **GIỮ NGUYÊN** |

---

## NHÓM E — Cờ / trạng thái / mặc định (19 hàng)

*Cả nhóm E không có chỉ tiêu hình học — là pref key/default/ABI. Cột hình học ghi gộp một mẫu: "không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI)". Ràng buộc chung: E19/K7 — miền prefs `com.anlai.omnicar` trong cây nguồn là ABI nền của mọi cờ; danh tính DuoCar sinh ở rebrand đóng gói.*

| ID | Bề mặt / thành phần | Path + file:method (P3) | Hình học GỐC | Hình học P3 | Trạng thái | Ràng buộc |
|---|---|---|---|---|---|---|
| E1 | enabled @YES | OMCCommon.h (defaults) | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | K7 |
| E2 | language @en | OMCCommon.h | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | K7/K10 |
| E3 | liteMode — MÂU THUẪN default | OMCCommon.h:81 (@2) vs SSSplash.m:107 (@0); CarProbe.m:240 | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI); default thật trên máy = **UNKNOWN (U3)** | Mâu thuẫn còn nguyên tại P3 (không lô nào sửa — đúng BL-12: việc đo, không phải sửa) | | U3; BL-12 |
| E4 | duocarVitalsEnabled @YES | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | |
| E5 | duocarFullscreenVitalsEnabled @YES | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | Liên quan H1 |
| E6 | duocarThermalTest37Enabled @NO | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | Liên quan H4 |
| E7 | splitScreenEnabled @YES / AutoLaunch @NO | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | |
| E8 | ShowRecent/Favorites @YES | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | |
| E9 | splitScreenPinnedApp @"" | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | |
| E10 | homeScreen* (cols/rows @0, size @100, names @YES, blur @0, dim @25) | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) — LƯU Ý: size @100/dim @25 là THAM SỐ hiển thị của lưới Home, không phải frame runtime | Không đổi | | K7 |
| E11 | carProfilesEnabled @NO | Defaults; lệch kiểu đọc NSArray/NSDictionary giữa splash và kind4 | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi (chỉ ghi nhận lệch kiểu đọc) | | |
| E12 | onboardingDone | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | |
| E13 | whatsNewSeen | Defaults | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ/ABI) | Không đổi | | |
| E14 | Splash 1 lần/kết nối (claim không xoá) | SSStartupScreen.m:148–158 | Không có chỉ tiêu hình học — chỉ asset/chữ (cơ chế) | Không đổi | | S1 |
| E15 | HL46 trong tuyến app/prefs/startup/HUD | Grep âm tính ở tuyến này (P0) | Không có chỉ tiêu hình học — chỉ asset/chữ; cơ chế sống ở phía xe (B-N18) | Không đổi | | F |
| E16 | HL49 trong tuyến này | SCPDeviceVitalsHUD.m:238 (chỉ còn comment) | Không có chỉ tiêu hình học — chỉ asset/chữ; cơ chế sống = HL51 | Không đổi | | F |
| E17 | HL57 = H1 | SCPFullscreenVitalsBubble.m | Không có chỉ tiêu hình học — chỉ asset/chữ (cờ) — hình học ở H1 | Không đổi | | = H1 |
| E18 | Quyết định native/hosted cho HUD | Tuyến xe (H1/H2) | Không có chỉ tiêu hình học — UNKNOWN tại tuyến app (P0) | Chưa quyết ở P2/P3 | | UNKNOWN |
| E19 | Miền prefs com.anlai.omnicar (ABI nền) | Toàn cây (K7) | Không có chỉ tiêu hình học — chỉ asset/chữ (ABI) | Giữ nguyên trong cây nguồn; rebrand staging sinh com.chuong.duocar (P3 đã kiểm trên DEB) | | **K7 — ràng buộc cứng** |

---

## TỔNG KẾT G0-C (số liệu để tổng duyệt dùng)

- **Phủ: 112/112 hàng** (A 30 · B-N 20 · B-H 4 · D 5 · C 17 · P 8 · S 5 · H 4 · E 19).
- **Có đủ cặp số gốc/P3 để đối chiếu hình học: 23 hàng** — A1–A4, A8, B-N1, B-N3, B-N6–B-N8, B-N11, B-N13–B-N16, B-N19, B-H1, B-H2, D1, D2, P2, H1, H3.
- **Thiếu số phía gốc (không đối chiếu số được): 5 hàng** — B-N5 (windowLevel, U1), B-N12 (P0 không ghi số frame riêng), B-N18 (thân HL50, U2), P5 (chi tiết từng trang con, U5), E3 (default liteMode trên máy, U3 — thuộc nhóm cờ nhưng là UNKNOWN gốc thực sự).
- **Không có chỉ tiêu hình học (chỉ asset/chữ/cờ): 84 hàng** còn lại.
- **Hàng đáng ngờ lệch hình học/cấu trúc giữa gốc và P3 (cần tổng duyệt nhìn thẳng):**
  1. **B-N1 + B-H1** — pill/hit TRÙNG (34×12; hosted hit 44×24) nhưng **3 dot subview 4×4 của gốc đã bị xoá** ở cả hai phía, thay bằng 1 gradient layer (6.9, 4.8, 20.1, 2.4). Lệch ở tầng subview bên trong bounding box — đúng chủ đích master V3 (một vạch), nhưng theo chuẩn "hình học gốc phải trùng" của chỉ đạo khóa thì đây là điểm phải ghi DIFF/được duyệt riêng, không tự ghi MATCH.
  2. **B-N9 + B-H3** — blur style **11 → 16** ở cả hai phía (vật liệu, không phải frame). Style 16 là suy luận "twin tối của 11" (D-13), **chưa có bằng chứng binary/thiết bị** — hàng UNKNOWN về tính tương đương vật liệu.
  3. **B-N4** — SCPApplyAccent thành no-op: layer accent phủ bounds handle của gốc không còn tồn tại. Frame không đổi; lớp trang trí khác.
  4. **B-H2** — rendering mode AlwaysOriginal → AlwaysTemplate: hình học TRÙNG nhưng cơ chế hiển thị khác gốc (đây là sửa lỗi icon đen đã chốt ở P0 — vẫn phải khai báo là thay đổi cơ chế hiển thị, không phải chỉ màu).
  5. **A2** — glyph logo trong file đích đổi tỷ lệ (glyph master 395×260 đệm trong suốt thay vì glyph vuông gốc); khung file/khung view TRÙNG, silhouette bên trong khác — GPT đã PASS ở re-review P2 nhưng ghi lại để tổng duyệt G0 thấy.
- **Không phát hiện** lệch nào ở các hằng khung/hit cốt lõi: bar 52, nút 48×40, chip 40×40, handle 34×12, hit hosted 44×24, hit SCPCButton ≥44pt, knob hit +26/+6, knob dot 14×14, công thức sheet picker + corner 24, pitch 62×56, cột metadata 150pt, cancel 32×32, panel phím 0.78/280/33, viền nhiệt 7.0/0.75s, header prefs 44×44 — tất cả TRÙNG giữa comment bằng chứng gốc và hằng tại b65741e.
