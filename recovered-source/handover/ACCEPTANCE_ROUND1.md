# NGHIỆM THU VÒNG 1 — OmniCar 1.0.3 gốc vs bản tái tạo

Đợt thử TỔNG HỢP MỘT LẦN. Hai bản thay thế nhau trên cùng một máy,
cùng cấu hình, cùng ứng dụng — không cài chạy đồng thời. Thứ tự bắt
buộc: **bản gốc trước** (lấy kết quả đối chiếu), **bản tái tạo sau**
(chạy lại đúng cùng các thao tác). Mỗi mục ghi ĐẠT / LỖI / CHƯA THỬ
cho từng bản; chỗ nào khác bản gốc thì ghi rõ khác thế nào.

## Thông tin đợt thử

- Thiết bị: iPhone X — iOS 16.7.16 — palera1n rootless
- Màn hình xe: ………………………… (ghi model/độ phân giải nếu biết)
- Ngày thử: ……………  Người thử: ……………
- Trạng thái máy TRƯỚC đợt thử: đang cài QA20
  (`1.0.3-omnicar20-divider-knob-idle`). Cả hai bản dưới đây đều thay
  thế nó. Muốn quay về trạng thái hôm nay: cài lại file QA20 kèm theo.

## Hai bản thử (cùng Package `com.anlai.omnicar`, cùng arch)

| Bản | File | SHA-256 | Dung lượng |
|---|---|---|---|
| GỐC 1.0.3 | `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` | `d9297b01…` | 1.306.228 B |
| TÁI TẠO | `com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb` | `93cdcad9…` | 947.056 B |

## Chuẩn bị (làm một lần, trước cả hai bản)

- [ ] Giữ sẵn 3 file DEB (gốc, tái tạo, QA20) trên máy để cài/quay lại.
- [ ] Sao lưu cấu hình (KHÔNG bắt buộc): cấu hình nằm ở domain
      `com.anlai.omnicar` (đã kiểm chứng trong mã). File plist tương
      ứng có thể chưa tồn tại trên máy — dùng tìm kiếm của Filza gõ
      `anlai` trong `/var` để tìm; thấy file nào thì chép file đó
      sang `/var/mobile/Documents/`. Không thấy thì BỎ QUA bước này,
      việc thử không bị ảnh hưởng.
- [ ] Ghi mốc giờ bắt đầu thử để đối chiếu log.
- [ ] Chuẩn bị sẵn cùng một bộ app sẽ thử (Maps + 1 app khác, app
      iPhone đã chọn trong OmniCar).
- [ ] Xe ĐỖ, thao tác màn hình khi xe đứng yên.

Cách cài mỗi bản: tải file từ chat → chia sẻ sang Sileo → Sileo cài
file local → respring. Chuyển bản: cài bản kia đè lên, respring,
KHÔNG cần gỡ tay.

## Các nhóm thử (chạy đủ cho MỖI bản)

| # | Nhóm | Thao tác | Tiêu chí đạt | Gốc | Tái tạo | Khác biệt ghi ở đây |
|---|---|---|---|---|---|---|
| 1 | Cài đặt | Cài DEB, respring, kết nối CarPlay; mở các trang Settings | Không crash; các module tải; trang cài đặt hoạt động | | | |
| 2 | Home | Chọn app iPhone trong OmniCar; tìm rồi mở icon trên Home xe | Icon hiện; mở đúng app; thoát về Home được | | | |
| 3 | Chia ô | Mở Maps + một app khác; thay app từng ô | Cả hai ô hiện nội dung và nhận chạm | | | |
| 4 | Bố cục | Kéo divider; đổi layout; phóng to/thu lại; mở cửa sổ nổi | Khung cập nhật đúng; không trắng ô; không nhảy toàn màn ngoài ý muốn | | | |
| 5 | Tray/picker | Mở bảng chọn; chạm nút VÀ chạm vùng trống quanh bảng | Nút nhận chạm; **vùng trống xuyên chạm xuống dưới như bản gốc** | | | |
| 6 | Bàn phím | Xem bộ chuỗi dò riêng bên dưới + nhập/xóa/Enter, đóng/mở bàn phím | Kết quả và xử lý phím GIỐNG bản gốc, kể cả lỗi vốn có của gốc | | | |
| 7 | Vòng đời | Về Home, mở lại; khóa/mở iPhone; ngắt/kết nối lại CarPlay | Không kẹt cửa sổ; không mất chạm; không giữ scene chết | | | |
| 8 | Speed Bubble | Chạy demo; đổi nguồn/style; di chuyển; đổi kích thước | Hiển thị, số liệu và thao tác khớp bản gốc | | | |
| 9 | Startup Screen | Kết nối lại; thử hiệu ứng, âm thanh, chạm bỏ qua | Hiện đúng; bỏ qua được; âm thanh dừng đúng lúc | | | |

**Không crash chưa đủ để chấm ĐẠT** — phải thấy nội dung hiện và
thao tác được thật.

### Bộ chuỗi dò bàn phím (gõ GIỐNG HỆT trên cả hai bản, ghi lại kết quả từng chuỗi)

Các chuỗi này cố ý dẫm vào các chỗ bộ gõ của bản gốc xử lý khác
Telex chuẩn — bản tái tạo phải cho ra ĐÚNG kết quả của bản gốc, kể
 cả kết quả "sai":

1. `muon` + phím `s`  → ghi kết quả: ……………
2. `ang` + phím `s`   → ghi kết quả: ……………
3. `ba` + phím `s`    → ghi kết quả (kể cả trường hợp phím bị bỏ qua): ……………
4. `aa`               → ghi kết quả: ……………
5. `ab` + phím `a`    → ghi kết quả: ……………
6. `bc` + phím `w`    → ghi kết quả: ……………
7. Một câu thường: `Xin chaof Vieetj Nam` → phải ra "Xin chào Việt Nam"
8. Xóa lùi vài ký tự, Enter, đóng rồi mở lại bàn phím.

## Bằng chứng gửi về (gửi chung MỘT lần sau khi thử xong cả hai bản)

- [ ] `/var/mobile/Documents/OmniCar.log` và `OmniCar.log.old` (nếu có)
- [ ] File plist cấu hình: bản "trước thử" và bản "sau thử"
- [ ] Video màn hình xe, đánh dấu mốc thao tác nào khác bản gốc
- [ ] Crash log nếu có (kèm giờ xảy ra)
- [ ] Bảng trên đã điền ĐẠT / LỖI / CHƯA THỬ cho cả hai bản

## Chốt vòng 1

- Chỉ chốt "tương đương" **trong phạm vi đã thử, trên thiết bị này**.
- Khác biệt phát sinh: đối chiếu TRỰC TIẾP với hành vi bản gốc vừa
  thử — không lấy câu mô tả "phải hoạt động thế này" trong tài liệu
  bàn giao cũ làm kết quả.
- HOÃN sang vòng riêng (KHÔNG làm vòng này): kiểm tra hạn dùng
  (không đổi ngày máy), cứu hộ khi crash (không cố gây crash),
  điều kiện tải nặng.
