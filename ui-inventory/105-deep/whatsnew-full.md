# WHATSNEW — TOÀN VĂN (OmniCar 1.0.5, EN + VI)

Cấu trúc nguồn: WhatsNew.plist là dict version → mảng mục {titleKey, textKey, symbol}.
Bản 1.0.3 chỉ có mục version "1.0.0"; bản 1.0.5 có thêm "1.0.4" và "1.0.5".
Giá trị dưới đây trích nguyên văn từ WhatsNew.strings (en.lproj / vi.lproj) của 1.0.5.

## Version 1.0.5 — 3 mục

### Mục 1: `WN_105_PHONEUI_TITLE` / `WN_105_PHONEUI_TEXT` (symbol: `iphone`)

- **Title EN:** iPhone interface for CarPlay apps
- **Title VI:** Giao diện iPhone cho app CarPlay
- **Text EN:** In Apps on the car screen, tap a CarPlay app and turn on iPhone interface: on the car screen it runs like on your iPhone instead of its CarPlay interface.
- **Text VI:** Trong App trên màn xe, chạm một app CarPlay rồi bật Giao diện iPhone: trên màn xe app chạy giống trên iPhone thay cho giao diện CarPlay.

### Mục 2: `WN_105_ZOOM_TITLE` / `WN_105_ZOOM_TEXT` (symbol: `plus.magnifyingglass`)

- **Title EN:** App scale
- **Title VI:** Điều chỉnh tỉ lệ app
- **Text EN:** Tap an app in Apps on the car screen and set App size from 60 to 100 % (default 80 %) so text and buttons fit the car screen. Respring after changing.
- **Text VI:** Chạm một app trong App trên màn xe, chỉnh Cỡ app từ 60 đến 100 % (mặc định 80 %) để chữ và nút vừa màn xe. Đổi xong bấm Respring.

### Mục 3: `WN_105_GPS_TITLE` / `WN_105_GPS_TEXT` (symbol: `speedometer`)

- **Title EN:** GPS calibration for your car
- **Title VI:** Hiệu chỉnh GPS theo xe
- **Text EN:** In Speed Bubble: drag the GPS calibration slider, plus or minus up to 10 km/h, so the bubble matches your dashboard.
- **Text VI:** Trong Bong bóng tốc độ: kéo thanh Hiệu chỉnh GPS, cộng hoặc trừ đến 10 km/h, để số trên bong bóng khớp đồng hồ xe.

## Version 1.0.4 — 4 mục

### Mục 1: `WN_104_IOS15_TITLE` / `WN_104_IOS15_TEXT` (symbol: `iphone`)

- **Title EN:** Better on iOS 15
- **Title VI:** iOS 15 chạy tốt hơn
- **Text EN:** iPhone apps on the car screen rotate correctly on iPhone 7, 8 and X; full-screen YouTube no longer turns sideways. No more hang on the Apple logo at boot.
- **Text VI:** App iPhone trên màn xe xoay đúng trên iPhone 7, 8, X; YouTube toàn màn không còn xoay lệch. Không còn kẹt logo Apple khi khởi động.

### Mục 2: `WN_104_SQUARE_TITLE` / `WN_104_SQUARE_TEXT` (symbol: `rectangle.portrait`)

- **Title EN:** Square and tall car screens
- **Title VI:** Màn xe vuông và dọc
- **Text EN:** Split Screen fits 850x800 and portrait screens with the dock at the bottom. Choose the screen type: Auto, Wide or Tall.
- **Text VI:** Chia màn hình hợp với màn 850x800 và màn dọc, dock ở dưới. Chọn Loại màn hình: Tự động, Ngang hoặc Dọc.

### Mục 3: `WN_104_GRID_TITLE` / `WN_104_GRID_TEXT` (symbol: `square.grid.3x3`)

- **Title EN:** Even home grid
- **Title VI:** Lưới màn chính đều hơn
- **Text EN:** Icons spread evenly over the chosen columns x rows, sized to fit. Jailbreak apps no longer appear on the car.
- **Text VI:** Icon dàn đều theo số cột x hàng đã chọn, cỡ icon vừa màn. App của jailbreak không còn lên màn xe.

### Mục 4: `WN_104_BUBBLE_TITLE` / `WN_104_BUBBLE_TEXT` (symbol: `speedometer`)

- **Title EN:** Speed Bubble
- **Title VI:** Bong bóng tốc độ
- **Text EN:** GOFA reads the posted limit correctly. Each source (Vietmap Live, GOFA, Waze, Wyn) has its own reader, more stable.
- **Text VI:** GOFA đọc đúng biển giới hạn. Mỗi nguồn (Vietmap Live, GOFA, Waze, Wyn) có cách đọc riêng, ổn định hơn.

## Khóa WN_* MỒ CÔI — có trong strings 1.0.5 nhưng WhatsNew.plist KHÔNG tham chiếu (5 khóa)

| Khóa | EN | VI |
|---|---|---|
| `WN_104_DONATE_TEXT` | Under Developer: email omnicartweak@gmail.com and ways to donate to OmniCar. The guide gets a thank-you page. | Trong Nhà phát triển: email omnicartweak@gmail.com và cách ủng hộ OmniCar. Hướng dẫn lần đầu có thêm trang cảm ơn. |
| `WN_104_DONATE_TITLE` | Contact & Donate | Liên hệ & ủng hộ tác giả |
| `WN_CONTINUE` | Continue | Tiếp tục |
| `WN_ROW` | What's new | Có gì mới |
| `WN_TITLE` | What's new in OmniCar %@ | Có gì mới trong OmniCar %@ |

## Phụ lục — mục version 1.0.0 (đã có ở 1.0.3, ghi lại để trọn bộ)

### Mục 1: `WN_KEYBOARD_TITLE` / `WN_KEYBOARD_TEXT` (symbol: `keyboard`)

- **Title EN:** Keyboard on the car screen
- **Title VI:** Bàn phím trên màn hình xe
- **Text EN:** Type in iPhone apps shown on the car screen with a keyboard right on the car display.
- **Text VI:** Gõ chữ trong các app iPhone hiển thị trên màn hình xe bằng bàn phím ngay trên màn hình xe.

### Mục 2: `WN_ZOOM_TITLE` / `WN_ZOOM_TEXT` (symbol: `arrow.up.left.and.arrow.down.right`)

- **Title EN:** Pane zoom
- **Title VI:** Phóng to ô
- **Text EN:** Double-tap the ••• of a Split Screen pane to fill the screen with it, double-tap again to go back.
- **Text VI:** Chạm hai lần vào ••• của một ô Chia màn hình để ô đó chiếm cả màn hình, chạm hai lần nữa để quay lại.

### Mục 3: `WN_LANG_TITLE` / `WN_LANG_TEXT` (symbol: `globe`)

- **Title EN:** 14 languages
- **Title VI:** 14 ngôn ngữ
- **Text EN:** Settings, car screen text and notices in 14 languages. Pick one with the globe button.
- **Text VI:** Cài đặt, chữ trên màn hình xe và thông báo có 14 ngôn ngữ. Chọn bằng nút quả địa cầu.

### Mục 4: `WN_GUIDE_TITLE` / `WN_GUIDE_TEXT` (symbol: `lightbulb`)

- **Title EN:** First-run guide
- **Title VI:** Hướng dẫn lần đầu
- **Text EN:** A short guide to get started. Open it any time from Support > Show guide again.
- **Text VI:** Một hướng dẫn ngắn để bắt đầu. Mở lại bất cứ lúc nào ở Hỗ trợ > Xem lại hướng dẫn.
