# S2 — Picker: kết án lớp phủ bằng [picker-measure] (hl2)

Nguồn: `OmniCar.log.old`+`OmniCar.log`. hl2 = CarPlay PID 37310 (loaded 22:03:25) + 37334 (loaded 22:16:01). Thế hệ cũ 36768/36808 (21:12–21:14) chỉ có `[applib] build reason=picker-*`, không `[picker]`/`[picker-measure]` → loại. Tổng hl2: **13+13 dòng, tất cả ở `.old`**; `OmniCar.log` (22:18:40→22:27:21, PID 37334) có 0 dòng picker.

## 1. Bảng từng lần mở

Trường đo GIỐNG HỆT cả 13 lần (chỉ frame picker khác — cột W): `cover{nil} picker{alpha=1.00 hidden=0 super=nil bg=0.000,0.000,0.000,0.000} sheet{nil} shield{nil} pshield{nil} trayWin{frame={{0,0},{640,360}} level=1065 hidden=1}`. App suy từ `[scenevis]`/`pane=slotN(...)`/`drop-hosted` ngay trước mở; native = scene `CarPlayTemplateUIHost`/trực tiếp, hosted = `scene=nil`+`host-attach`.

| # | Giờ | PID | Slot | App đang gắn (loại) | hasContent | W picker |
|---|---|---|---|---|---|---|
| 1 | 22:04:38.033 | 37310 | 0 | com.google.Maps (native) | 1 | 297 |
| 2 | 22:04:42.368 | 37310 | 1 | com.google.ios.youtube (hosted) | 1 | 297 |
| 3 | 22:10:30.042 | 37310 | 0 | com.google.Maps (native) | 1 | 297 |
| 4 | 22:10:52.029 | 37310 | 1 | com.apple.mobilecal (native) | 1 | 297 |
| 5 | 22:11:06.089 | 37310 | 1 | com.google.Maps (native) | 1 | 297 |
| 6 | 22:12:01.458 | 37310 | 0 | com.waze.iphone (native) | 1 | 297 |
| 7 | 22:12:29.457 | 37310 | 0 | com.google.Maps (native) | 1 | 396 |
| 8 | 22:14:54.114 | 37310 | 0 | com.google.ios.youtube (hosted) | 1 | 426 |
| 9 | 22:16:53.748 | 37334 | 0 | com.ss.iphone.ugc.Ame (hosted) | 1 | 297 |
| 10 | 22:16:58.549 | 37334 | 0 | com.ss.iphone.ugc.Ame (hosted) | 1 | 297 |
| 11 | 22:17:18.619 | 37334 | 1 | com.lumi.GOFA (native) | 1 | 297 |
| 12 | 22:17:25.205 | 37334 | 0 | com.ss.iphone.ugc.Ame (hosted) | 1 | 297 |
| 13 | 22:18:13.083 | 37334 | 0 | com.ss.iphone.ugc.Ame (hosted) | 1 | 297 |

Trích nguyên văn (mọi lần như nhau): `2026-11-09 22:04:38.033 [CarPlay:37310] SplitScreen: [picker-measure] slot=0 hasContent=1 cover{nil} picker{alpha=1.00 hidden=0 super=nil frame={{0, 0}, {297, 360}} bg=0.000,0.000,0.000,0.000} sheet{nil} shield{nil} pshield{nil} trayWin{frame={{0, 0}, {640, 360}} level=1065 hidden=1}`

## 2. Đối chiếu hosted vs native

Hosted: #2,8,9,10,12,13 (6). Native: #1,3,4,5,6,7,11 (7). **Khác biệt trong các trường đo: KHÔNG CÓ** — cover/sheet/shield/pshield đều nil, picker đều alpha=1.00/hidden=0/super=nil/bg trong suốt, trayWin đều hidden=1 ở cả hai nhóm. Biến duy nhất: bề rộng frame picker (297/396/426) chạy theo bề rộng ô lúc mở (#7,#8), không theo hosted/native. Dòng đo KHÔNG giải thích được verdict miệng Nguyen (§29.15: hosted bị ẩn nội dung, native bình thường).

## 3. KẾT ÁN — không kết án được phần tử nào; phép đo chụp TRƯỚC khi trình bày

- Tại thời điểm đo: mọi nghi phạm đều vô tội/vắng mặt — `cover{nil}` (không tồn tại → bác pane.cover tại điểm này), `sheet/shield/pshield{nil}`, bg picker trong suốt, `trayWin hidden=1`.
- Nhưng hai trường tự tố cáo thời điểm đo: picker `super=nil` = **chưa gắn vào hierarchy nào**, trayWin `hidden=1` = overlay **chưa hiện**. Tức `[picker-measure]` chụp ở showPickerForSlot TRƯỚC khi picker lên màn — không phải trạng thái lúc Nguyen thấy che trắng.
- Trường quyết định THIẾU: (a) trạng thái SAU khi gắn/hiện của picker (super/alpha/bg+subview) và trayWin (hidden/alpha/bg sau unhide) — trayWin 640×360 level 1065 là ứng viên phủ toàn màn nhưng log chỉ ghi lúc nó đang ẩn; (b) alpha/hidden của view scene hosted lúc picker mở.
- Kết luận tối đa: phủ trắng xảy ra SAU điểm đo, bởi trạng thái sau-trình-bày của picker/trayWin hoặc phần tử ngoài tập đo; hasContent=1 đủ 13/13 → placeholder vô tội (khớp ytz5hl1). Muốn kết án phải đo lại sau khi picker đã gắn + trayWin đã hiện.

## 4. Chuỗi mở → đóng/chọn

- Chọn app (choose; nội dung quay lại dạng app mới — detach-bg/attach +1,3–2,3s): #3 Maps→Waze 22:10:31.430/.434; #4 mobilecal→Maps 22:10:54.370/.373; #5 Maps→GOFA 22:11:08.292/.296; #6 Waze→Maps 22:12:03.651/.656; #7 Maps→YouTube(hosted) 22:12:30.793/.804; #8 YouTube→Ame 22:14:56.352 (host-attach); #13 Ame→YouTube 22:18:14.721 (host-attach).
- Đóng không chọn: #1 — `22:04:40.974 CarSplit: dong popup (tray khong, ti le khong, chon app co, thanh khong)` (+2,94s), không đổi scene → Maps native ở nguyên.
- Không có dòng đóng riêng: #2, #9–#12 — chỉ có chạm `drop-popup(picker)` sau mở ~1,3–2,3s và dòng `22:17:16.768 dong popup (... chon app co, thanh co)` đóng picker của #9/#10 ngay trước #11. Không dòng nào ghi picker gỡ/hiện lại nội dung ô hosted sau đóng — "nội dung quay lại" chỉ suy gián tiếp qua các cặp attach ở trên.
