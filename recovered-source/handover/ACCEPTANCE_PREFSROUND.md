# NGHIỆM THU BẢN TỔNG HỢP PREFSROUND — một phiên gộp duy nhất

Bản: `com.anlai.omnicar_1.0.3-rebuilt-prefsround_iphoneos-arm64.deb`
(FAT do CI đóng từ cùng cây source), Version
`1.0.3-rebuilt-prefsround`, SHA-256 bản local
`2e89d0a5d18d25d8a638fa9ceb356a46084df069d7e16570f296a1b1b063d650`.
UUID SplitScreen `4C4C4434-5555-3144-A12D-FE9691749170`,
Prefs `4C4C4447-5555-3144-A1FE-0EBD27D16A3C`,
StartupScreen `4C4C44B4-5555-3144-A162-0E8998F52385`.

Điều kiện: xe đỗ, cài bản này (thay bản đang chạy), respring,
làm MỘT phiên theo đúng thứ tự dưới đây. Mỗi mục ghi
ĐẠT / LỖI / CHƯA THỬ. Đây là bản đã qua đủ cổng tĩnh;
chỉ phiên này mới quyết định được gọi là "hoàn thiện"
hay chưa. Không phát hành Sileo.

## 1. Cài đặt và các trang con (chưa cần cắm xe)

1. Mở Cài đặt → OmniCar: trang gốc mở bình thường,
   footer cứu hộ hiện đúng danh sách tính năng bằng
   tiếng Việt, KHÔNG còn "(null)".
2. Mở lần lượt từng trang con: Chia màn hình, Màn hình
   khởi động, Bong bóng tốc độ, App trên màn xe — trang
   nào cũng phải vào được.
3. **Trang Màn hình khởi động (mục quan trọng nhất):**
   mở đi mở lại NHIỀU lần, ra vào liên tục — không được
   văng ra màn hình chính nữa. Thử đủ 11 lựa chọn kiểu
   khởi động; thử chọn video, logo, âm thanh; quay ra
   rồi mở lại, lựa chọn phải được lưu đúng.
4. **Xóa âm thanh (cổng phán quyết GPT):** khi trong máy
   có từ 2 tệp âm thanh trở lên, xóa tệp đang chọn —
   tệp đó mất, các tệp còn lại PHẢI còn nguyên.
5. Cuộn qua các preview trong lúc cuộn trang:
   - Màn chính CarPlay (trang App trên màn xe): các icon
     nằm đúng ô lưới, tên app đọc được, không chồng nhau.
   - Preview Bong bóng tốc độ (trong trang Bong bóng):
     bong bóng hiện đủ hình, số và biển báo đúng vị trí.
   - Preview Chia màn hình: hai ô tỉ lệ đúng, dải tiêu
     đề nằm bên TRÁI, không bị ép thành dải mỏng.

## 2. Cắm xe — splash và màn hình khởi động

6. Cắm CarPlay: splash hiện. Nếu đang ở kiểu Liquid
   (hoặc kiểu không có video): chữ "OmniCar CarPlay"
   phải nằm giữa màn hình, đúng cỡ; logo vuông ở giữa;
   KHÔNG còn cảnh chữ khổng lồ bị cắt ở góc trái trên
   nền trắng trơn.
7. **Ngắt kết nối trong lúc splash đang hiện rồi cắm
   lại** (mục còn nợ từ §14): máy không treo, không
   crash; cắm lại thì splash/chia màn hình chạy lại
   bình thường.

## 3. Chia màn hình và đường launch (lỗi nặng nhất của bản trước)

8. Nếu Chia màn hình đang bị rescue tắt: bật lại từ
   hộp thoại cứu hộ / trong Cài đặt.
9. Mở **Music** (app CarPlay native) vào một ô: app
   phải vào ô và dùng được — đây là đường đi qua cổng
   isCarPlayApp đã sửa ở §15.
10. Mở **GOFA** vào ô còn lại: đây là đường launch từng
    làm CarPlay sập hai lần ở phiên 22:55. Tiêu chí
    qua: KHÔNG còn exception `carPlayDeclaration`,
    CarPlay không chết, rescue không kích hoạt.
11. Mở thêm một app iPhone qua AppBridge (ví dụ
    Facebook) vào ô: app hiện và chạm được trong ô.
12. Kéo divider: hai tỉ lệ cộng lại phải đủ 1.00
    (không còn kiểu 0.33/1.33 như log cũ).
13. Mở panel chọn bố cục: các nút phải nằm gọn trong
    khung viền của chúng, không lệch, không hai lớp.
14. Chạm trong cả hai ô: thao tác ăn bình thường,
    không màn đen nhấp nháy.

## 4. Bong bóng tốc độ trên xe

15. Bong bóng hiện trên màn xe: đủ số tốc độ, biển báo
    giới hạn đúng kích thước (không còn biển nhỏ 34pt),
    đổi qua vài kiểu hiển thị nếu tiện — hình học
    không vỡ.

## 5. Kết thúc phiên — BẮT BUỘC

16. Up lên repo (thư mục `logs/`): toàn bộ `OmniCar.log`
    của phiên và mọi file `.ips` mới phát sinh (đặc
    biệt nếu có Preferences.ips hoặc CarPlay.ips).
17. **Nếu trang Màn hình khởi động vẫn văng:** đừng thử
    lại nhiều lần — cứ gửi nguyên log phiên đó. Bản này
    đã gắn sẵn ghi log từng bước [W1] kèm handler ghi
    ngoại lệ rồi ném tiếp: log sẽ chỉ đích danh bước
    gãy, không cần đoán nữa.
18. Báo lại theo từng mục: ĐẠT / LỖI / CHƯA THỬ, kèm
    giờ trên đồng hồ xe của từng lỗi nếu có.
