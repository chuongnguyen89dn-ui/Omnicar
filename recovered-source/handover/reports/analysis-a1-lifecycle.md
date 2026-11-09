# PHÂN TÍCH A1 — VÒNG ĐỜI PHIÊN + SẬP 2-NATIVE + CÔNG TẮC CHẨN ĐOÁN

Nguồn: `OmniCar.log` (724.079 B, 15:33:22–15:42:17) + `OmniCar.log.old` (2.098.672 B, 13:49:29–15:33:22). Cửa sổ ytz2 = từ phiên CarPlay PID 34376 (load 15:27:36) tới cuối log. Mọi kết luận dưới đây đếm/trích trực tiếp từ hai file; mục log không trả lời được ghi rõ "log không có".

---

## 1) SẬP 2-NATIVE — chuỗi sự kiện và điểm bất thường đầu tiên

### 1.1 Mọi lần dựng cấu hình 2-native trong cửa sổ ytz2 (7 lần)

| # | Mốc hoàn tất | Ô 0 | Ô 1 | Scene ô 0 xác nhận | Scene ô 1 xác nhận |
|---|---|---|---|---|---|
| 1 | 15:30:56.815 | com.apple.Music (native) | com.google.Maps (native, từ 15:28:20) | 15:30:57.763 `{190,240}` = cần | (đã xác nhận từ 15:28) |
| 2 | 15:31:56.279 | com.apple.Music | com.google.Maps | 15:31:56.440 `{190,240}` ✓ | 15:31:57.223 `{191,240}` ✓ |
| 3 | 15:33:04.437 | com.apple.Music | com.google.Maps | ✓ (trong phiên 34442) | ✓ |
| 4 | 15:35:56.415 | com.apple.Music | com.lumi.GOFA (native) | 15:35:57.365 `{190,240}` ✓ | (GOFA đã ở ô 1) |
| 5 | 15:37:20.616 | com.apple.Music | com.lumi.GOFA | 15:37:20.349 `{190,240}` ✓ | 15:37:21.548 `{191,240}` ✓ |
| 6 | 15:37:45.731 | com.google.Maps | com.lumi.GOFA | 15:37:46.673 `{190,240}` ✓ | 15:37:44.106 `{191,240}` ✓ |
| 7 | 15:39:30.598 | com.google.Maps | com.lumi.GOFA | 15:39:30.607 `{190,240}` ✓ | 15:39:31.544 `{191,240}` ✓ |

Mẫu dòng gán (giống hệt ca hỗn hợp thành công): `dua <bundle> (DBApplicationSceneViewController) vao o N` → `scene <bundle> -> {w,240}` → `chan deactivate scene (mask=0) cua app trong ngan` → `scene <bundle> that = {w,240} (can {w,240})`.

**Đối chiếu ca hỗn hợp thành công cùng log** (15:27:41 YouTube hosted ô 0 + GOFA native ô 1; 15:28:08 Music native ô 1; 15:28:20 GMaps native ô 1): chuỗi dòng gán/xác nhận **không khác gì** ca 2-native. Trong toàn cửa sổ ytz2: **0 dòng** `DashBoard invalidate`, **0 dòng** lỗi huỷ scene ngoài các dump DIAG (đường invalidate chỉ xuất hiện ở cửa sổ fs1: 15:15:13/15:15:32/15:15:51 `DashBoard invalidate -> bo split`).

> **Kết luận 1A:** Điểm gán ô native thứ hai **không phải** điểm sập. Cả hai scene native đều được đặt và xác nhận đúng khung ở cả 7 lần. Bất thường nằm ở chuỗi sự kiện SAU khi cấu hình 2-native hoàn tất.

### 1.2 Chuỗi sau 2-native — bảng sự kiện (lần 1, phiên 34376, đầy đủ nhất)

| Mốc | Sự kiện |
|---|---|
| 15:30:54.896 | Mở popup chọn app cho ô 0 (`popup chon 18 app cho o 0`) |
| 15:30:56.815 | Music native → ô 0; YouTube hosted bị teardown đúng quy trình (`MILESTONE teardown bundle=com.google.ios.youtube`, `[ytz] lease thu hoi ly do=teardown` 15:30:56.817) |
| 15:30:57.763 | Scene Music xác nhận `{190,240}` |
| 15:30:58–15:31:04 | Chạm liên tục trên cả hai ô (probe chain seq 86–102, đều phân loại `foreign`) — giao diện vẫn nhận chạm |
| 15:31:05.153/.156 | Hai chạm Began tại **{19.0, 224.0}** (góc dưới-trái) trên `_UISystemGestureWindow` và **`DBStatusBarWindow`** |
| **15:31:05.200** | **`CarSplit: tat split (goHome=0)`** — 47 ms sau chạm góc |
| 15:31:29.256 | Dòng cuối cùng của CarPlay PID 34376 (probe chain) — sau đó im lặng tuyệt đối phía CarPlay/SpringBoard |
| 15:31:42.449 | CarPlay PID mới 34413 + SpringBoard PID mới 34412 nạp lại toàn bộ (= respring) |

Các lần sau lặp đúng khuôn:
- Lần 2 (phiên 34413): dựng xong 15:31:57.223 → **fade AutoHide 15:31:58.660** (`fade last=container idle=4.00`), không có reveal nào sau đó trong phiên → chạm góc {12.5,217} trên DBStatusBarWindow 15:32:02.674 → `tat split` 15:32:02.747 → respring 15:32:54 (SB 34443).
- Lần 5 (phiên 34442): dựng xong 15:37:21.548 → chạm góc {13.5,226} DBStatusBarWindow 15:37:21.932 → `tat split` 15:37:22.000 → respring 15:37:32 (SB 34491).
- Lần 7 (phiên 34521): dựng xong 15:39:31.544 → chạm góc {23.5,220.5} DBStatusBarWindow 15:40:24.015 → `tat split` 15:40:24.092 → ngắt CarPlay 15:42:00.749 (kết thúc phiên).

**Kiểm chứng mẫu chạm-góc:** 4/4 lần `tat split` được kiểm chi tiết đều có chạm Began trên `DBStatusBarWindow` tại góc dưới-trái ({19,224}, {12.5,217}, {13.5,226}, {23.5,220.5}) trước đó 47–80 ms. Tổng cửa sổ ytz2: 6 lần `tat split (goHome=0)` (15:31:05, 15:32:02, 15:36:00, 15:37:22, 15:37:57, 15:40:24), và 4 lần respring trong 15:31–15:40 (SB 34412 @15:31:42, 34443 @15:32:54, 34491 @15:37:32, 34520 @15:39:20).

> **Kết luận 1B — điểm bất thường đầu tiên có bằng chứng:** Không phải gán ô, mà là **trạng thái sau khi 2-native hoàn tất không còn ô hosted nào**: (i) phiên mất toàn bộ đường activity (không act, không feed) → AutoHide mờ controls sau 4 s (bằng chứng: fade 15:31:58.660 ở phiên toàn-native, và phiên đó **không có bất kỳ `reveal-applied` nào sau fade**, trái với phiên hỗn hợp 34442 có reveal-applied lặp lại nhiều lần); (ii) mọi lối thoát khỏi split trong log đều qua **chạm góc dưới-trái trên DBStatusBarWindow → `tat split (goHome=0)`** — tức người dùng bị đẩy ra CarPlay Home gốc qua đường chạm góc hệ thống, không có lối ra nào của OmniCar được ghi nhận sau khi controls đã mờ; (iii) sau các lần thoát này là **4 respring trong ~9 phút** — hành vi khôi phục khi không còn đường mở lại OmniCar từ phía xe (khớp báo cáo mất icon dock).

> **Log không có:** (a) cơ chế icon OmniCar biến mất khỏi lưới/dock gốc — OmniCar.log không ghi trạng thái thư viện app gốc đối với chính app OmniCar (các dòng `AppIcons:` chỉ ghi việc ghép 5 app đã chọn lúc bắt đầu phiên: `them 4 / 5 app da chon vao thu vien FBSApplicationLibrary`, Google Maps có declaration thật nên không ghép); (b) lý do respring (cố ý hay crash) — xem mục 3; (c) ô phải trắng trong video — ở phiên cuối (34521) cả hai scene đều xác nhận đúng khung, log không có dòng lỗi trình bày nào cho ô phải; không phân định được ô trắng là trạng thái sau `tat split` trên dashboard gốc hay bị che bởi bề mặt khác.

---

## 2) CÔNG TẮC FULLSCREEN CHẨN ĐOÁN — phân định 3 khả năng

Toàn bộ dòng `[fs-diag]`/`[fs1]` liên quan trong hai file (đếm: fs-diag 16 dòng, fs1 19 dòng):

| Mốc | Dòng | Kết quả |
|---|---|---|
| 15:29:03.847 | `fullscreenDiagExpand -> ON (expand)` | `[fs1] fs expand refused reason=tray provenance=diag` |
| 15:29:33.842 | `-> OFF (restore)` | `fs restore refused state=SPLIT` |
| 15:29:34.600 | `-> ON` | `fs expand refused reason=tray` |
| 15:29:37.129/.645 | OFF → ON | restore refused SPLIT; expand refused `tray` |
| 15:29:45.537/.46.002 | OFF → ON | restore refused SPLIT; expand refused `tray` |
| 15:39:07.966–15:39:10.808 | OFF, ON, OFF, ON (phiên 34490) | ON ×2 → `fs expand refused reason=inactive` |

Ngữ cảnh hai cửa sổ:
- **15:29 (phiên 34376):** popup chọn app cho ô 1 mở từ **15:28:05.960** (`popup chon 18 app cho o 1 (cua so rieng, 0 o cho)`, mở lại 15:28:10.643) và chỉ đóng ở ~15:30:06 (`dong popup (tray khong, ti le co, chon app khong, thanh khong)` ×3 lúc 15:30:06/10/12). Cả 4 lần ON đều nằm trong khoảng popup đang mở. Log không ghi riêng cờ `tray` tại các mốc 15:29 — chỉ biết chắc có một bề mặt popup đang mở phủ đúng các mốc đó, và reason guard in ra là `tray`.
- **15:39 (phiên 34490):** split đã tắt từ 15:37:57.342 (`tat split`), phiên split không active → reason `inactive` khớp trạng thái thật.

> **Kết luận 2:** Kênh pref **tới được** controller (mọi lần gạt đều có dòng `[fs-diag]` đúng chiều, kể cả sau respring `diag listener installed want=1`). Expand **chưa từng chạy qua guard**: tổng số lần expand thành công = **0**, số dòng read-back expand/restore = **0** trong cả hai file. Phân loại: **"tới nhưng bị chặn ở guard"** ở cả hai cửa sổ — 15:29 bị chặn bởi bề mặt đang mở (popup chọn app; reason=`tray`), 15:39 bị chặn vì phiên inactive. **Không tồn tại lần gạt nào trong điều kiện sạch** (split active + không bề mặt mở) trong toàn bộ log — nên khả năng "expand chạy nhưng chrome không ẩn" **chưa từng được kiểm chứng trên xe** (log không có dữ kiện), và kết luận "công tắc không hoạt động" trên xe là hệ quả của guard, chưa phải bằng chứng đường expand/chrome hỏng.

---

## 3) TỔNG QUAN PHIÊN

Đếm bằng grep -c trên từng file:

| Chỉ số | OmniCar.log.old (13:49–15:33) | OmniCar.log (15:33–15:42) |
|---|---|---|
| `bat split` (kích hoạt split) | 8 | 3 |
| `tat split` | 4 (1× goHome=1 @13:54:38; 3× goHome=0) | 4 (đều goHome=0) |
| `cam xe -> se tu mo split` | 8 | 3 |
| CarPlay process generations | 33559, 33873, 33941, 33999, 34376, 34413, 34442 | 34442 (tiếp), 34490, 34521 |
| SpringBoard generations | 33592, 33764, 33843, 33885, 33975, 34377, 34412, 34443 | 34443 (tiếp), 34491, 34520 |

- **Cửa sổ fs1** (~13:49–15:19): 4 thế hệ CarPlay (33559, 33873, 33941, 33999), respring tại 13:56, 14:29, 14:33, 14:39, 15:16 (bối cảnh cài đặt/respring kiểm soát được — không khẳng định crash). 3 lần `DashBoard invalidate -> bo split` lúc 15:15 — teardown bất thường duy nhất có ghi tên trong cả hai file, thuộc cửa sổ fs1.
- **Cửa sổ ytz2** (15:27–15:42): 5 thế hệ CarPlay (34376, 34413, 34442, 34490, 34521), 6 lần `bat split`, 6 lần `tat split` — và **4 respring trong 15:31–15:40** (15:31:42, 15:32:54, 15:37:32, 15:39:20) bám sát các lần thoát split sau cấu hình 2-native; 1 lần ngắt/nối lại màn CarPlay giữa phiên (disconnect 15:37:06.321 → connected 15:37:13.257, cùng PID 34442); ngắt cuối 15:42:00.749 kết thúc log.
- **Teardown bất thường nhất:** sau `tat split` 15:31:05.200 (phiên 34376), CarPlay chỉ còn log probe tới 15:31:29.256 rồi **cả CarPlay lẫn SpringBoard im lặng hoàn toàn** (dòng SB cuối: 15:31:04.547) cho tới khi tiến trình mới nạp 15:31:42 — phiên chết hẳn, không qua đường teardown có ghi. Các lần thoát ở phiên 34442 thì tiến trình sống tiếp và split mở lại được ở lần cắm/kích hoạt sau.
- **Crash/exception:** grep từng từ khoá trên cả hai file: `Exception` = 0/0, `unrecognized` = 0/0, `SIGBUS` = 0/0, `abort` = 0/0, `EXC_` = 0/0, `crash` = 0/0. (Các hit case-insensitive trước đó đều nằm trong dump DIAG liệt kê ivar/method của hệ thống, không phải báo cáo crash.) **Log không có** bất kỳ bằng chứng crash/exception nào — các respring chỉ xác định được mốc thay tiến trình, không xác định được nguyên nhân (người dùng respring tay để khôi phục hay SpringBoard tự chết đều không phân định được từ OmniCar.log).

---

## TÓM TẮT KẾT LUẬN CÓ BẰNG CHỨNG

1. **2-native không sập tại điểm gán** — 7/7 lần cả hai scene native đặt + xác nhận khung đúng, mẫu dòng y hệt ca hỗn hợp. Điểm gãy nằm sau đó: mất ô hosted ⇒ mất đường activity ⇒ controls mờ sau 4 s và không gọi lại được trong phiên toàn-native (fade không kèm reveal ở phiên 34413), mọi lối thoát ghi được đều là chạm góc DBStatusBarWindow → `tat split (goHome=0)`, và 4 respring nối tiếp — khớp chuỗi "mất logo → ra Home gốc → không mở lại được → respring" trong báo cáo xe. Cơ chế mất icon khỏi thư viện gốc và lý do respring: **log không có**.
2. **Công tắc chẩn đoán tới nơi nhưng bị guard chặn 100%** — 0 lần expand chạy, 0 read-back; 15:29 vướng popup chọn app đang mở (reason `tray`), 15:39 vướng phiên inactive. Chưa có lần test sạch nào cho đường expand/chrome.
3. **Không crash/exception nào trong log**; teardown bất thường duy nhất có tên là `DashBoard invalidate` ở cửa sổ fs1 (15:15 ×3) và phiên chết im lặng 15:31:29→15:31:42 ở cửa sổ ytz2.
