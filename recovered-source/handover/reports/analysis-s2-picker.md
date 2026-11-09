# S2 — PICKER (bước 3, ĐIỂM HỎNG 1) — phiên ytz5hl1

Chỉ-đọc trên log. Nguồn: `OmniCar.log` + `OmniCar.log.old` trong thư mục phiên.
Nhãn dùng: LOG-CONFIRMED / LOG-CONTRADICTS / NO-DATA, đối chiếu verdict tại xe của Nguyen: bước 3 THẤT BẠI — mở bảng chọn app (nút "Đổi app") thì nội dung ô vẫn bị che trắng.

## 0) Khung phiên tự xác định (file S1 chưa có trong thư mục phiên)

- `OmniCar.log.old`: 17:40:49 → 20:36:45. Phần 17:xx = thế hệ ytz4 (CarPlay PID 36136/36168, SpringBoard 36056/36240). Thế hệ MỚI bắt đầu ở đuôi `.old`: `2026-11-09 20:18:10.158 [SpringBoard:36658] AppBridge: loaded into SpringBoard`; CarPlay PID **36683**.
- `OmniCar.log`: 20:36:45 → 20:52:18, tiếp PID 36683, sau đó CarPlay khởi động lại thành PID **36712** (SpringBoard 36711, từ ~20:40). Dấu thế hệ mới có mặt dày: `[home-launch]` old=91/new=30, `[kbstate]` old=626/new=804, `[pinch1]` old=15/new=1 (đếm grep).
- **Đã loại (ytz4, 17:xx):** dòng có tag đúng `[picker]` = **0** (toàn cục chỉ có 2 dòng `[picker]`, cả hai ở 20:25 — xem §1). Dòng picker-liên-quan của ytz4 bị loại: 6 dòng `[applib] build reason=picker-native/picker-chosen` (3 cặp: 17:42:52, 17:43:56, 17:46:22) + 8 dòng `[fs1] snap{... picker=0 ...}` lúc 17:43 — không dòng nào là lần mở picker có log hasContent.

## 1) Đếm grep toàn cục (cả 2 file)

| Mẫu | old | new | Ghi chú |
|---|---|---|---|
| `[picker] hasContent=` | 2 | 0 | cả 2 đều `hasContent=1`; `hasContent=0` = **0 lần** toàn phiên |
| `popup chon` | 2 | 0 | khớp đúng 2 lần mở ở §2–§3 |
| `[applib] build reason=picker-native` | 5 | 1 | chỉ 2/6 cặp là lần mở thật (§4) |
| `showPicker` / `slotOccupied` / `removeLoader` (chuỗi log) | 0 | 0 | log không có các dòng này |
| `cover` ngoài DIAG | 0 | 0 | `addCoverToPane:`/`removeCoverFromPane:` KHÔNG phát dòng log nào |
| `sheet` ngoài DIAG | 0 | 0 | không có dòng present/dismiss của pickerSheet |
| `loader` | 3 | 1 | cả 4 đều là dump DIAG class, không phải sự kiện loader |

## 2) Lần mở 1 — 20:25:25.561, ô 0, hasContent=1

Trạng thái ô ngay trước khi mở (đối chiếu assignment/scenevis):

- `2026-11-09 20:24:33.120 [CarPlay:36683] SplitScreen: [scenevis] host-attach bundle=com.google.ios.youtube slot=0 scene=nil attached=0 inHost=1 hidden=0 alpha=1.00 window=1`
- `2026-11-09 20:24:33.126 [CarPlay:36683] SplitScreen: AppBridge: host com.google.ios.youtube vao o 0`
- `2026-11-09 20:24:35.857 [CarPlay:36683] SplitScreen: [scenevis] host-state-ready bundle=com.google.ios.youtube slot=0 ... hidden=0 alpha=1.00 window=1`
- Ô 1 cùng lúc: `20:24:33.148 [scenevis] attach bundle=com.google.Maps slot=1 ... attached=1 inHost=1` (native).
- Ngay trước mở, các dòng probe đều ghi `pane=slot0 (com.google.ios.youtube hosted)` (vd `20:25:24.770 [probe-foreign] ... pane=slot0 (com.google.ios.youtube hosted) side=L`).

Chuỗi open → đóng:

- `20:25:24.822 [SpringBoard:36658] AppBridge: cham thanh ••• cua com.google.ios.youtube` → `20:25:24.825 CarSplit: [do] bridge handletap com.google.ios.youtube`
- `20:25:25.554 [SpringBoard:36658] AppBridge: thanh nut com.google.ios.youtube: replace` (đây là nút "Đổi app") → `20:25:25.559 AppBridge: thanh nut replace cua com.google.ios.youtube`
- `20:25:25.560 [wake1] bw state com.google.ios.youtube VISIBLE->UNKNOWN gen=3`
- **`20:25:25.561 [CarPlay:36683] SplitScreen: [picker] hasContent=1`**
- `20:25:25.571 [applib] build reason=picker-native count=14 omni=1` · `20:25:25.833 [applib] build reason=picker-chosen count=5`
- `20:25:25.951 CarSplit: [do] shield host SCPCPass_UIRootSceneWindow superview SCPCPass_UIRootSceneWindow`
- `20:25:25.951 CarSplit: man xe ban (an lop phu)` (+ echo `20:25:25.952 [SpringBoard:36658] SpeedBubble: bubble: man xe ban -> an tren xe`)
- `20:25:25.953 CarSplit: popup chon 19 app cho o 0 (cua so rieng, 0 o cho)` — sheet chọn app nằm ở **cửa sổ riêng**, cho ô 0.
- Trong lúc mở: chạm bị nuốt ở tầng popup — `20:25:34.610 [probe-feed] drop-popup(picker) win=_UISystemGestureWindow scr={583.7,84.0}` (chạm tại vùng ô 1/Maps).
- Đóng: `20:25:34.657 CarSplit: man xe ranh` sau chạm ngoài tại ô 1. **Không có choose**: không dòng assignment/pickerAppTapped nào sau mở; YouTube vẫn nguyên ở ô 0 (probe `20:25:35.926 pane=slot0 (com.google.ios.youtube hosted)`).

## 3) Lần mở 2 — 20:25:36.896, ô 0, hasContent=1

Cùng ô, cùng app (YouTube hosted, ô 0), chỉ 11 giây sau lần 1 đóng:

- `20:25:35.990 [SpringBoard:36658] AppBridge: cham thanh ••• cua com.google.ios.youtube` → `20:25:35.995 CarSplit: [do] bridge handletap com.google.ios.youtube`
- `20:25:36.890 [SpringBoard:36658] AppBridge: thanh nut com.google.ios.youtube: replace` → `20:25:36.894 AppBridge: thanh nut replace cua com.google.ios.youtube`
- **`20:25:36.896 [CarPlay:36683] SplitScreen: [picker] hasContent=1`**
- `20:25:36.906 [applib] build reason=picker-native count=14 omni=1` · `20:25:37.031 [applib] build reason=picker-chosen count=5`
- `20:25:37.092 CarSplit: [do] shield host SCPCPass_UIRootSceneWindow superview SCPCPass_UIRootSceneWindow`
- `20:25:37.092 CarSplit: man xe ban (an lop phu)` (+ echo SpeedBubble `20:25:37.093`)
- `20:25:37.094 CarSplit: popup chon 19 app cho o 0 (cua so rieng, 0 o cho)`
- Trong lúc mở: `20:25:40.213` và `20:25:42.676 [probe-feed] drop-popup(picker)` (chạm tại ô 0 và ô 1 đều bị tầng popup nuốt).
- Đóng: `20:25:43.697 [SpringBoard:36658] AppBridge: cham ngoai thanh nut (lop chan) -> an thanh nut` → `20:25:43.708 CarSplit: [do] closePopups <= 0x1051c6958 (popup 0)`. **Không có choose**; ngay sau đó `20:25:44.003 [wake1] bw state com.google.ios.youtube VISIBLE->HIDDEN` rồi `20:25:45.048 ... HIDDEN->VISIBLE` (autohide thường, không liên quan picker).

Ghi chú: dòng `[picker] hasContent=` tự nó **không ghi số ô** — ô 0 được xác định bằng dòng `popup chon 19 app cho o 0` (+0,39 s sau hasContent ở cả hai lần) và chuỗi `thanh nut replace` của bundle đang ở ô 0.

## 4) Các cặp `[applib] picker-*` KHÔNG phải lần mở (đã loại khỏi danh sách mở)

4 cặp `picker-native/picker-chosen` còn lại của thế hệ mới đều đi kèm `build reason=publish-for-settings` hoặc ngữ cảnh khởi động, và **không** có `[picker] hasContent`, không có `thanh nut replace`, không có `popup chon`:

- `20:18:48.829 / 20:18:49.078` — ~3 s sau khi phiên dựng Home (20:18:45), build thư viện lúc khởi động.
- `20:27:50.037 / 20:27:50.285` — ngay sau `20:27:49.850 closePopups (popup 1)` + `20:27:50.038 build reason=publish-for-settings count=14` (đóng bảng bố cục, publish lại thư viện).
- `20:35:00.126 / 20:35:00.512` — đi cùng `20:35:00.127 publish-for-settings` và `20:35:00.529 CarSplit: 14 app CarPlay cho Settings... cam xe -> se tu mo split` (sự kiện cắm xe).
- `20:40:12.372 / 20:40:12.750` (OmniCar.log, PID 36712) — đi cùng `20:40:12.373 publish-for-settings`, trước `20:40:14.272 tu mo split khi cam xe`.

Kết luận §4: toàn phiên ytz5hl1 chỉ có đúng **2 lần mở picker thật**, cả hai ở §2–§3.

## 5) Kết luận dứt khoát: hỏng ở nhánh (b) — KHÔNG phải nhánh (a)

### Nhánh (a) — phép bắt occupancy sai: **LOG-CONTRADICTS**

- Cả 2 lần mở mà Nguyen test (bước 3) đều trên ô 0 **đang có app thật**: YouTube hosted, chứng bằng `[scenevis] host-attach ... slot=0 inHost=1 hidden=0 alpha=1.00` (20:24:33.120), `host com.google.ios.youtube vao o 0` (20:24:33.126) và `pane=slot0 (com.google.ios.youtube hosted)` ngay trước từng lần mở.
- Cả 2 lần, phép bắt trả **`hasContent=1`** (20:25:25.561 và 20:25:36.896). Không tồn tại lần mở nào trên ô có app mà `hasContent=0` — toàn phiên `hasContent=0` xuất hiện **0 lần**. Phép bắt occupancy ĐÚNG ở cả hai lần mở bị verdict.
- Hệ quả cho placeholder: dòng log `[picker] hasContent=%d` và phép gán `picker.backgroundColor = hasContent ? clearColor : màu đặc` nằm trong **cùng một hunk** của bản sửa P5 (hồ sơ `fix-ytz5-p5.md` §4: log tại Picker.m:172-173, gán nền tại :174-179). Dòng log đã chạy trong binary thật ⇒ phép gán clearColor cho placeholder `pane.picker` cũng nằm trong binary đó. Ở tầng log, placeholder bị LOẠI khỏi diện nghi phạm: với hasContent=1 nó phải trong suốt.

### Nhánh (b) — phần tử phủ KHÁC che nội dung: **LOG-CONFIRMED theo hướng loại trừ, nghi phạm cụ thể = NO-DATA ở tầng log**

Ứng viên đã rà quanh mốc mở:

1. **Lớp shield/popup dựng đúng lúc mở picker — LOG-CONFIRMED là có dựng, NO-DATA về hình dạng.** Ở cả 2 lần mở, +0,39 s sau hasContent đều có `CarSplit: [do] shield host SCPCPass_UIRootSceneWindow superview SCPCPass_UIRootSceneWindow` + `CarSplit: man xe ban (an lop phu)` (20:25:25.951 và 20:25:37.092). Trong toàn thế hệ mới, `man xe ban` CHỈ xuất hiện tại đúng 2 mốc này (2 dòng CarSplit + 2 echo SpeedBubble). Log không ghi màu/alpha của shield ⇒ không ghim được nó là lớp trắng, chỉ ghim được thời điểm dựng.
2. **`pane.cover` — nghi phạm khớp nhất về mặt thị giác, nhưng NO-DATA trong log.** Theo nguồn đã phục dựng (đối chiếu M4): `addCoverToPane:` (Picker.m:106-141) tạo view phủ **toàn bộ pane** (`frame = pane.view.bounds`), chèn **trên** `pane.host`, fade alpha 0→1, nền là **đúng hằng màu đặc** rgb(0.9333, 0.9412, 0.9843) alpha 1 — cùng hằng màu với nền đặc cũ của placeholder, tức mắt thường không phân biệt được "trắng của cover" với "trắng của placeholder". Nhưng `addCoverToPane:`/`removeCoverFromPane:` **không phát bất kỳ dòng log nào** (grep `cover` ngoài DIAG = 0/0 ở cả 2 file) ⇒ log không xác nhận cũng không bác được cover có mặt lúc 20:25:25/20:25:36. Các đường gọi cover (Divider beginResize, RatioMenu, Panel/tray) cũng không để lại dòng log riêng quanh hai mốc mở.
3. **Loader — loại.** `showPickerForSlot:` tự gỡ loader trước điểm bắt hasContent, và toàn phiên không có sự kiện loader nào (4 hit `loader` đều là dump DIAG).
4. **Sheet chọn app — không phải lớp che ô.** Log ghi sheet ở **cửa sổ riêng** (`popup chon 19 app cho o 0 (cua so rieng...)`), không nằm trong pane; không có dòng present/frame/alpha nào của sheet (grep `sheet` ngoài DIAG = 0).

### Tầng NO-DATA — log thiếu đúng các dòng sau

- Không có `[scenevis]` nào trong cửa sổ mở picker: đếm = **0** trong 20:25:25–20:25:44 (scenevis gần nhất: 20:24:35.857 trước mở, 20:25:57.832 sau đóng) ⇒ trạng thái hidden/alpha của scene ô 0 trong lúc picker mở không đo được từ log.
- Không có dòng log nào ghi backgroundColor/alpha thực tế của `pane.picker`, `pane.cover`, hay shield tại thời điểm mở ⇒ không thể ghim lớp trắng vào một view cụ thể chỉ bằng log phiên này. Muốn chốt nghi phạm (b1) cover hay (b2) shield cần thêm đúng 1 dòng đo: log alpha/superview của `pane.cover` + `pane.picker` tại `showPickerForSlot:` ngay sau điểm bắt hasContent.

### Nhãn tổng so với verdict của Nguyen

- Verdict "bước 3 THẤT BẠI, ô bị che trắng khi mở picker": **LOG-CONFIRMED** ở phần sự kiện (picker mở thật 2 lần trên ô có app, không lần nào chọn được app — cả hai đều đóng bằng chạm ngoài) và **LOG-CONTRADICTS** với giả thuyết nhánh (a) trong hồ sơ §29.10.
- **Trả lời dứt khoát: cơ chế hỏng rơi vào nhánh (b)** — hasContent bắt đúng (=1), placeholder được clearColor, lớp trắng Nguyen thấy là một phần tử phủ khác; hai nghi phạm theo thứ tự: (b1) `pane.cover` (cùng màu đặc, phủ toàn pane, trên host — nhưng không có log, NO-DATA về sự hiện diện), (b2) lớp shield/popup dựng tại `shield host` + `man xe ban (an lop phu)` đúng 2 mốc mở (có log về thời điểm, NO-DATA về màu/alpha).
