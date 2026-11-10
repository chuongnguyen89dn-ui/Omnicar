# BẢNG ĐO TỔNG — GIAO DIỆN OMNICAR 1.0.3 (1 TRANG)

Rút gọn từ `UI_INVENTORY.md` (223 mục, commit `6b92721`, verifier độc lập ≈90%).
Khung đo xe: cửa sổ **640×360 pt**, ô phải rộng **297 pt**. Mọi số dưới đây là pt,
trừ khi ghi khác. Nguồn chi tiết (file:dòng) ở bản kiểm kê đầy đủ.

## 1. HỌ MÀU CHỦ ĐẠO (đổi là đổi cả hệ)

| Dùng ở đâu | Màu |
|---|---|
| Accent gradient (knob, chip, spinner, vòng tốc độ) | `#9B87F8 → #5DB4F6`, chéo (0,0)→(1,1) |
| Vòng conic (ratio ring, bubble ring, header) | `#A78BFA → #60C5FA → #5EDDB6 → #F59AC0` (khép vòng về `#A78BFA`) |
| Navy — chữ/tint chính trên xe | `#4A4F80` (chữ phụ cùng màu @ alpha 0,55) |
| Đỏ — nút hủy / thoát / vượt tốc | `#FF5A5F` (biển báo `#E5262D`) |
| Hổ phách — cảnh báo mức 1 | `#FFB340` |
| Nền cover / loader ô | `#EEF0FB` |
| Bóng (shadow) toàn hệ | tím `#6E64C8` |
| Kính (glass) | trắng alpha 0,85 (viền) / 0,35 (nền handle) / 0,02 (shield chặn chạm) |
| Prefs sáng / tối | nền `#F4F5FB` / `#0E0F16`; accent `#7B6CF6` / `#A89BFF` |
| Font | 100% font hệ thống, 0 file font. Số tốc độ: Heavy + Rounded, 24–48. Chữ xe: Semibold/Medium 10,5–14. |

## 2. TỪNG PHẦN TỬ — KÍCH THƯỚC + MÀU + FONT

| Phần tử | Kích thước | Màu / font / bo góc |
|---|---|---|
| Nút logo (góc split) | **34×34**, vùng chạm **44×44**; tâm (appMaxX−25, appMinY+25) | glyph 17×12; mờ sau 4 s idle (chỉ opacity — vẫn ăn chạm, xem lưu ý) |
| Nút logo (vị trí dock) | ≤30 (min(gapDock−8, 30)) | cùng 1 object với nút góc split |
| Grip 3 chấm | pill **34×12**, bo 6; chấm **4×4**; tâm Y=12 | nền trắng α0,35, viền 0,5 trắng α0,55; chấm navy `#4A4F80` α0,85 |
| Thanh menu (pane bar) | cao **52**, rộng **259** (= 12 + 5×48 + 7), bo 22 | nút 48×40, chip kính 40×40 bo 20, icon 22; nút X đỏ `#FF5A5F`; tự ẩn sau 4 s |
| Divider | dày **1**, dài suốt cạnh chia; vùng chạm nới 6 mỗi phía | trong suốt; snap tỉ lệ {1/3, 1/2, 2/3} |
| Knob divider | đĩa **14×14** bo 7, chấm 4×4; vùng chạm **66×66** | mặt kính blur, viền 1,5 trắng α0,95; active scale 1,6× + accent |
| Cửa sổ nổi | nhỏ ≤240×170, lớn ≤360×260; cách mép 8 | viền 1 trắng α0,85 |
| Sheet chọn app | **542×242** (đo xe, cols=6; xem lưu ý công thức) | bo 24, bóng radius 24 α0,3; phủ 61,2% ô |
| Cell app trong sheet | **62×56**; icon **38×38** bo 27% | badge check 14×14, nền `#9B87F8`, viền trắng 1 |
| Cột phụ sheet | rộng **150**; nút hủy 32×32, tâm (120,30) | tiêu đề 12,5 Semibold navy; phụ đề 10,5 |
| Panel bố cục | rộng min(104 + số lựa chọn×84, areaW−16); y = minY+6 | bo 24, bóng 24 α0,3; nút lựa chọn 84×56 bo 14; glyph 73×40; tự đóng 4 s |
| Menu tỉ lệ | cao **42** bo 21; chip **34×34** bo 17, cách nhau 36 | 2 ô: 3 chip (rộng 114); 3 ô: 4 chip (rộng 150); tự ẩn 4 s |
| Bong bóng tốc độ | style 0: **120×118** (đĩa 100×100); vị trí mặc định tâm (W−86, 170) | số Heavy Rounded 24–48; "km/h" 9–12; scale hiển thị = %cỡ × 0,9 |
| Splash | hiện **5 s** mặc định (tối thiểu 1 s), fade-out 0,4 s | logo vuông cạnh min(0,5×W, 0,62×H); đồng hồ 30 Light; chào 10 Semibold; ngày 6 Medium |
| Toast chữ | cao ≥38, rộng vừa chữ + 32; tâm Y = đáy host − 50 | bo 19, nền trắng α0,94, chữ navy 14 Medium; giữ 2,6 s |
| Toast chạy nền | cao **34**; tâm Y = 26 | icon 24×24; nút "Mở lại" cao 26 bo 13, nền accent |
| Bàn phím tự vẽ | **44 phím** (chữ) / **43** (số), 5 hàng + 2 nút header | phím chính 17 Regular; phím phụ 11 Semibold; phím chức năng 10 |
| Prefs | 8 trang + 2 modal, ≈105 hàng | accent `#7B6CF6`/`#A89BFF`; chữ 13–16; bo card 20 |

## 3. THỜI GIAN & HIỆU ỨNG (dùng lại cho thiết kế mới)

- Tự ẩn: bar 4 s · panel 4 s · menu tỉ lệ 4 s · AutoHide toàn phiên 4 s.
- Vào: spring 0,45–0,5 s (bar từ scale 0,9, dịch 8 pt; sheet từ scale 0,92, dịch 48 pt).
- Ra: fade 0,15–0,22 s (bar 0,18 s; sheet 0,22 s; bubble 0,18 s).
- Nhấn nút: thu scale 0,9 trong 0,12 s, thả về trong 0,3 s (damping 0,7).
- Bo góc hay dùng: 24 (panel/sheet) · 22 (bar) · 20 (bàn phím) · 17 (chip) · 14 (nút panel) · 7 (knob/badge) · 6 (handle).
- Vùng chạm tối thiểu: **44 pt** (chuẩn HIG) — mọi nút đều nới tới 44×44.

## 4. BA ĐIỂM CHƯA TUYỆT ĐỐI (đừng thiết kế dựa vào số chết ở đây)

1. **Sheet 542×242 là kết quả công thức**, không phải hằng số — đổi số app / độ phân giải là sheet đổi cỡ (công thức: rộng = cols×62 + 20 + 150).
2. **Vài mục INFERRED/PARTIAL**: màu viền biển tốc độ, 2 hàm vẽ hạt/pháo hoa màn chào còn xung đột giữa các bản phục hồi, tên style blur 11.
3. **Màu động ngoài code** (icon app thứ ba, màu hệ thống iOS) không thuộc bảng này.
4. **Bẫy đã đo trên xe**: nút logo mờ bằng opacity vẫn ăn chạm 100% (hl6 đã thêm cổng chặn ở cây hl, không phải gốc); gọi logo hiện cả hàng menu do wake gọi cứng `setBarVisible:YES` — thiết kế mới phải tách 2 việc này.

---
Nguồn: `~/workspace/push9-clone/ui-inventory/UI_INVENTORY.md` (Phần 3 chrome, Phần 4 tokens,
Phần 5 bàn phím/Prefs; commit `6b92721`, 2026-11-10). Bảng này chỉ rút gọn — số đo gốc,
neo source từng dòng và 15 PNG thật nằm ở bản kiểm kê đầy đủ.
