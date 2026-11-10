# DANH SÁCH ĐẦY ĐỦ MỤC CÀI ĐẶT OMNICAR 1.0.3 — HIỂN THỊ GÌ · KHÓA GÌ · CHỨC NĂNG GÌ

Rà 2026-11-10 bằng 3 đường độc lập đối chiếu chéo: (A) plist specifier +
strings trong bundle gốc `OmniCarPrefs.bundle` của deb 1.0.3 · (B) source
Prefs đã phục hồi (phần dựng bằng code) · (C) truy vết từng khóa prefs
xuống nơi code đọc. Miền prefs chung: `com.anlai.omnicar`; gần như mọi
thay đổi đều phát Darwin `com.anlai.omnicar/prefschanged` (ngoại lệ duy
nhất: đổi ngôn ngữ).

**Tổng bề mặt gốc 1.0.3:** 8 trang + 1 trang con (app picker) + 2 modal ·
63 item khai trong plist (43 hàng + 20 group) · khoảng 60 loại phần tử
chỉ dựng bằng code (chưa kể hàng động theo số app/xe/URL) · ≈90 khóa
prefs thuộc bản gốc (≈55 khóa có giao diện). Các mục của thời RE (họ
`bridgewake.*`, section Diagnostics ở trang Chia màn hình…) KHÔNG thuộc
gốc — tách ở §11.

Quy ước: **Mặc định** = giá trị khi khóa vắng. Chỗ nào mặc định phía
Cài đặt và phía chạy thật lệch nhau, ghi cả hai.

## 1. TRANG GỐC (Root — "OmniCar")

### 1a. Thẻ đầu trang (dựng bằng code, không có trong plist)

| Phần tử | Khóa / mặc định | Chức năng |
|---|---|---|
| Logo + tên "OmniCar" + version "1.0.3" + dòng tagline theo ngôn ngữ | — | Trang trí/nhận diện |
| Chấm + chữ trạng thái | đọc `enabled` + hạn dùng | Xanh = đang bật, xám = tắt, "Expired" khi quá hạn 01/05/2027 |
| **Công tắc tổng** | `enabled`, mặc định **BẬT** | Tắt = mọi tính năng OmniCar dừng (sau cổng hạn dùng; hết hạn thì công tắc bị khóa) |

### 1b. Hai nút trên thanh điều hướng (code)

| Nút | Chức năng |
|---|---|
| **Respring** (icon mũi tên xoay) | Hộp thoại xác nhận → khởi động lại SpringBoard |
| **Ngôn ngữ** (icon quả địa cầu) | Menu 14 ngôn ngữ: Việt, Anh, Tây Ban Nha, Bồ Đào Nha (Brazil), Đức, Pháp, Ý, Nga, Trung (giản thể), Nhật, Hàn, Ả Rập, Thái, Indonesia. Ghi khóa `language`; UI nạp lại ngay; **không** phát prefschanged (ngoại lệ duy nhất toàn hệ) |

### 1c. Các hàng (thứ tự hiển thị)

| Nhãn (VI / EN) | Loại | Khóa / mặc định | Chức năng |
|---|---|---|---|
| Nhóm "Chế độ cứu" + nút **Bật lại** (Turn back on) | nhóm + nút, **chỉ hiện khi có feature bị crash-guard tắt** | `rescueFeatures`, `rescueDate` (ẩn) | Bật lại mọi tính năng bị cơ chế cứu hộ tự tắt sau crash CarPlay lặp lại; xóa 2 khóa cứu hộ |
| Nhóm "Tweak có thể xung đột" + hàng chữ tĩnh | nhóm + chữ tĩnh, **chỉ hiện khi phát hiện tweak xung đột đang cài** (CarBridge, DuoDash, TrueDash, CarPlayEnable) | — | Cảnh báo, không bấm được |
| Nhóm "Màn xe": **App trên màn xe** → trang Apps (§2) | link (ô bên phải hiện số app đã chọn) | xem §2 | |
| **Màn chính CarPlay** → trang Home Screen (§3) | link | xem §3 | |
| Nhóm "Tính năng" (chân nhóm: "Thay đổi áp dụng ngay. Respring sau khi cài hoặc cập nhật."): **Màn hình khởi động** → §5 · **Bong bóng tốc độ** → §6 · **Chia màn hình** → §7 | 3 link chèn động từ 3 file Feature*.plist, ô phải hiện Bật/Tắt | `startupScreenEnabled` / `speedBubbleEnabled` / `splitScreenEnabled`, mặc định **BẬT** | Ba công tắc này chính là 3 công tắc ở đầu mỗi trang con |
| **Hồ sơ theo xe** → trang Profiles (§4) | link | xem §4 | |
| Nhóm "Hỗ trợ": **Xem lại hướng dẫn** | nút | — | Mở lại modal Hướng dẫn (§8) |
| **Có gì mới** | nút | — | Mở modal What's New (§9) |
| Nhóm "Nhà phát triển": **Gửi log** | nút | — | Soạn báo cáo chẩn đoán (trạng thái, kiểm tra hệ thống) + đính 2 file log OmniCar → mở khay chia sẻ để gửi Mail/chat |

## 2. TRANG APPS — "App trên màn xe" (dựng bằng code toàn bộ, không có plist)

Bảng luôn ở chế độ sửa (nút +/− kiểu Cài đặt iOS). Nút **Đặt lại** trên
thanh điều hướng: xóa tập ẩn/hiện, giữ nguyên lựa chọn app.

| Mục | Khóa / mặc định | Chức năng |
|---|---|---|
| **Danh sách app đã chọn** (động, icon 37 pt + tên + nhãn phụ) | `appBridgeApps` (danh sách bundle id, giữ cả thứ tự) | Các app iPhone được đưa lên lưới xe (cơ chế khai báo CarPlay tổng hợp). Vuốt/nút − để bỏ chọn. Nhãn phụ "iOS đã tắt" khi app bị tắt trong Cài đặt CarPlay gốc. App CarPlay gốc (Điện thoại, Nhạc, Bản đồ, Tin nhắn…) bị khóa, không bỏ chọn được |
| **Ô tìm kiếm** | — | Lọc 2 danh sách theo tên app |
| **Danh sách mọi app còn lại** (động) | ghi vào `appBridgeApps` | Nút + để thêm app lên xe. Loại trừ app hệ thống ẩn/bị cấm chạy + 6 bundle cứng (OmniCar, SpringBoard, CarPlay, Cài đặt CarPlay, TemplateUIHost, webapp) |
| Stepper **số cột lưới** | `homeScreenGridCols` {0,3,4,5,6,7,8}, mặc định **0 = Tự động** | Ghi đè số cột của lưới app trên xe |
| Stepper **số hàng lưới** | `homeScreenGridRows` {0,1,2,3,4}, mặc định **0 = Tự động** | Ghi đè số hàng |
| Slider **cỡ icon** | `homeScreenIconSize` 60–130%, mặc định **100** | Cỡ icon lưới xe; kéo là áp sống |
| Switch **hiện tên app** | `homeScreenShowNames`, mặc định **BẬT** | Hiện tên dưới icon trên lưới xe |
| (ẩn, không hiển thị) tập ẩn/hiện | `homeScreenHiddenApps`, `homeScreenShownApps` | Ghi kèm mỗi lần đổi lựa chọn; trang Home Screen dùng chung |

Ghi chú cấu trúc: trang Apps và trang Home Screen là **cùng một lớp
code** — bản Home chỉ thêm 1 method đổi cờ bố cục, hai trang chia nhau
các section của cùng một bảng.

## 3. TRANG HOME SCREEN — "Màn chính CarPlay" (code toàn bộ)

Nút **Đặt lại** trên thanh điều hướng: xóa 8 khóa lưới/nền + xóa file
nền, về mặc định.

| Mục | Khóa / mặc định | Chức năng |
|---|---|---|
| **Xem trước màn xe** (vẽ mô phỏng) | đọc các khóa dưới | Mô phỏng lưới xe: dải trái + đồng hồ 9:41 + lưới app theo cột/hàng/cỡ/tên hiện tại + chấm phân trang; có nền thì phủ nền + lớp mờ/tối. (Một chi tiết chưa phục hồi trọn: danh sách icon trang trí ở dải trái — xem §10) |
| Thẻ **Hình nền** (bấm để gập/mở), 9 ô kiểu: Mặc định · 6 gradient · Ảnh của bạn · Video | `homeScreenWallpaperStyle` (Cài đặt ghi 0–8; phía chạy đọc mặc định **7**, kẹp 1–8) + `homeScreenWallpaper` BẬT/TẮT | Chọn nền cho lưới Home tự vẽ trên xe. Ô 1–6: hệ render gradient thành ảnh nền ghi vào máy; ô 0: xóa nền |
| Nút **Từ thư viện ảnh** | ghi file + tự chọn kiểu 7/8 | Chọn ảnh (thu ≤2000 px) hoặc video (cắt ≤20 s, xuất 1280×720 + ảnh thumb) làm nền |
| Slider **Mờ (Blur)** | `homeScreenBlur` 0–30, mặc định **0** | Độ mờ của ảnh nền |
| Slider **Tối (Dim)** | `homeScreenDim` 0–70%, mặc định **25** | Độ tối phủ lên nền |

## 4. TRANG PROFILES — "Hồ sơ theo xe" (code toàn bộ)

| Mục | Khóa / mặc định | Chức năng |
|---|---|---|
| Switch **bật hồ sơ xe** (+ chân nhóm giải thích) | `carProfilesEnabled`, mặc định **TẮT** | Bật: mỗi xe nhớ riêng 14 khóa cấu hình (cặp app gần nhất, app ghim, tự mở, tỉ lệ chia, zoom ô, style màn chào, tên xe, hướng ô…) — nối xe nào áp cấu hình xe đó |
| **Danh sách xe đã gặp** (động: icon xe + tên + "lần cuối: ngày giờ" + dấu ✓ ở xe hiện tại) | `carProfiles` (kho hồ sơ), `carProfileCurrent` | Vuốt để **xóa** một xe khỏi kho (xóa xe hiện tại thì xóa luôn con trỏ hiện tại) |
| Hàng trống "chưa có xe nào" | — | Chỉ hiện khi kho rỗng |

## 5. TRANG STARTUP SCREEN — "Màn hình khởi động"

Khung: 44 item plist (11 nhóm + 33 hàng) + khối đầu trang dựng bằng code.
Hầu hết hàng chỉ hiện theo **kiểu màn chào đang chọn** (điều kiện
`ssStyles` trong plist).

### 5a. Khối đầu trang (code)

| Mục | Khóa / mặc định | Chức năng |
|---|---|---|
| **Xem trước màn chào** 320×120 | đọc các khóa của trang | Vẽ kiểu đang chọn bằng dữ liệu mẫu; **chạm = phát lại intro**; tự cập nhật khi đổi tên chào/tên xe/nhịp/hiệu ứng/logo/video |
| **Bộ sưu tập 11 kiểu** (ô 78×108, cuộn ngang) | `startupScreenStyle` 0–10, mặc định **0** | 0 Video · 1 Logo · 2 Lời chào · 3 Thời tiết · 4 Khởi động máy · 5 Ánh sáng chào · 6 Hạt sáng · 7 HUD tự kiểm tra · 8 Bảng tin · 9 Lỏng (Liquid) · 10 Ngẫu nhiên. Bấm ô = đổi kiểu, cả trang nạp lại theo kiểu |
| Switch **Màn hình khởi động** (hàng đầu plist) | `startupScreenEnabled`, mặc định **BẬT** | Bật/tắt toàn bộ màn chào |

### 5b. Hàng theo kiểu đang chọn

| Nhóm hiển thị khi | Hàng (loại) | Khóa / mặc định | Chức năng |
|---|---|---|---|
| Kiểu 0 Video | Chọn video (danh sách động từ thư mục Videos) | `startupScreenVideoName` | Video phát lúc kết nối; chưa có video thì màn chào rơi xuống icon xe |
| | Nút **Thêm video** | — (hành động) | Nhập từ Ảnh hoặc Tệp (MP4/MOV/M4V ≤60 s) → sao vào thư mục Videos, tự trích khung hình 24 fps + tiếng để phát |
| | Nút **Xem thử** | — | Phát thử bằng trình phát hệ thống |
| | Nút **Xóa video** (đỏ) | — | Xóa file video + thư mục khung hình của nó |
| | Segment **Lấp đầy / Vừa khung** | `startupScreenScaleMode` 0/1, mặc định **0 (Fill)** | Cách video phủ khung màn xe |
| | Switch **Phát hết video** | `startupScreenPlayFull`, mặc định TẮT | Bật: phát hết/lặp thay vì cắt theo thời lượng |
| | Switch **Âm thanh của video** | `startupScreenSound`, mặc định TẮT | Bật: tiếng video thay âm thanh khởi động |
| Kiểu 1 Logo | Segment hiệu ứng: **Hiện dần / Phóng to / Phát sáng** | `startupScreenLogoEffect` 0/1/2, mặc định **0** | Hiệu ứng xuất hiện của logo |
| | Nút **Chọn logo** / **Xóa logo** (đỏ) | file `Logo/logo.png` | Nhập ảnh (PNG nền trong suốt đẹp nhất, thu ≤1024 px); xóa thì hiện icon xe thay thế |
| Kiểu 2,3,6,8 (chào) | Ô nhập **Tên của bạn** (không bắt buộc) | `startupScreenGreetingName` | Tên dùng trong câu chào theo giờ ("Chào buổi sáng, <tên>"); tên nhóm + chân nhóm đổi theo kiểu (kiểu 3 hiện thêm lần cập nhật thời tiết cuối) |
| Kiểu 4,7 (tên xe) | Ô nhập **Tên xe** | `startupScreenCarName`, mặc định rỗng | Để trống = dùng tên xe CarPlay báo; ô gợi ý (placeholder) lấy từ chẩn đoán xe, dự phòng "OmniCar" |
| Kiểu 5 (nhịp) | Segment **Chậm rãi / Vừa / Nhanh** | `startupScreenTempo` 0/1/2, mặc định **1** | Tốc độ vệt sáng vẽ dáng xe |
| Nhóm "Chọn ngẫu nhiên từ" (điều kiện plist `ssStyles=[9]`) | **9 nút kiểu** có dấu ✓: Video, Logo, Lời chào, Thời tiết, Khởi động máy, Ánh sáng chào, Hạt sáng, HUD, Bảng tin | `startupScreenRandomSet`, mặc định đủ các kiểu | Mỗi lần kết nối hiện một kiểu khác trong tập đã chọn; không cho bỏ hết (giữ tối thiểu 1). ⚠️ **Lệch số thứ tự cần lưu ý:** plist gắn điều kiện hiện nhóm này là style **9**, nhưng gallery trong code xếp Ngẫu nhiên ở vị trí **10** (số 9 là kiểu Lỏng/Liquid) — hai cách đánh số chưa khớp nhau trong hồ sơ (xem §10) |

### 5c. Hàng luôn hiện (mọi kiểu)

| Hàng (loại) | Khóa / mặc định | Chức năng |
|---|---|---|
| Slider **Thời lượng (giây)** 1–30, từng nấc | `startupScreenDuration`, mặc định **5** | Màn chào ở trên màn xe bao lâu; video ngắn hơn thì lặp |
| Switch **Chạm để bỏ qua** | `startupScreenTapToSkip`, mặc định **BẬT** | Chạm là tắt màn chào ngay |
| Nút **Chọn âm thanh** / **Nghe thử** / **Xóa âm thanh** (đỏ) | `startupScreenSoundFile` | Âm thanh khởi động tự chọn (M4A/MP3/WAV/CAF), phát qua loa xe. ⚠️ **Khác gốc:** bản gốc 1.0.3 khi Xóa là xóa **cả thư mục Sounds**; cây phục hồi chủ động chỉ xóa file đang chọn (đã phán quyết 2026-11-08) |
| Slider **Âm lượng** 0–100, từng nấc | `startupScreenSoundVolume`, mặc định **100** | Âm lượng âm thanh khởi động |
| Switch **Im lặng khi đang gọi điện** | `startupScreenSoundSkipCall`, mặc định **BẬT** | Đang có cuộc gọi thì không phát tiếng khởi động |
| Switch **Màn hình ngày lễ** (nhóm Ngày đặc biệt) | `startupScreenOccasions`, mặc định **BẬT** | Tết, Trung thu, Giáng sinh, Năm mới, sinh nhật: hiện màn dịp đặc biệt tối đa 3 lần/ngày thay kiểu đã chọn |
| Hàng **Sinh nhật** + **chọn ngày bằng date-picker gắn bằng code** (kèm nút × xóa) | `startupScreenBirthday` dạng "MM-dd" | Ngày sinh để chúc mừng đúng ngày |
| Nút **Xem thử** (nhóm Ngày đặc biệt) | — | Tiêu đề nút tự tính = dịp sắp tới (quét 400 ngày); bấm = chạy thử màn dịp đó |

## 6. TRANG SPEED BUBBLE — "Bong bóng tốc độ" (code toàn bộ; plist chỉ có công tắc bật)

| Mục | Khóa / mặc định | Chức năng |
|---|---|---|
| **Xem trước trực tiếp** + nút **Thử trên xe** | — (hành động) | Bản đồ giả + bong bóng thật chạy sóng tốc độ 33–72 km/h quanh giới hạn 60. Nút Thử: phát lệnh Darwin riêng `…/speedbubble.demo` cho bong bóng chạy thử trên màn xe + rung + toast |
| Switch **Bong bóng tốc độ** | `speedBubbleEnabled`, mặc định **BẬT** | Bật/tắt bong bóng (cùng khóa với hàng feature ở Root) |
| **Dải 9 kiểu bong bóng** (thẻ cuộn ngang, kiểu chọn có vòng conic) | `speedBubbleLook` 0–8, mặc định **0** | 9 style hiển thị của bong bóng |
| Hàng **Màu**: 7 chấm màu | `speedBubbleColor` 0–6, mặc định **0** | 0 = conic tự động (bảng 5 màu), 1 trắng, 2 đen, 3 tím, 4 xanh, 5 ngọc, 6 hồng |
| Switch **hiện icon app** | `speedBubbleShowAppIcon`, mặc định **BẬT** | Hiện icon app nguồn tốc độ trên bong bóng |
| Slider **cỡ trên điện thoại** / **cỡ trên xe** | `speedBubbleSizePhone` / `speedBubbleSizeCar`, mặc định **100%** (thanh trượt Cài đặt 60–220; phía chạy kẹp 3–220) | Cỡ bong bóng ở hai nơi. ⚠️ Lệch nhỏ: ghi cỡ KHÔNG phát prefschanged (khác mọi khóa khác) |
| Hàng **Đặt lại vị trí** (chữ accent) | — (hành động) | Phát Darwin `…/speedbubble.resetlayout` — bong bóng về vị trí mặc định sau khi bị kéo đi |
| **4 ô nguồn tốc độ** (icon app thật) | `speedBubbleSource` 0–3, mặc định **0** | 0 Vietmap Live · 1 GOFA · 2 Waze · 3 Wyn. Dưới có dòng gợi ý đổi theo nguồn |
| **Mục Cảnh báo vượt tốc** — Switch **cảnh báo viền** | bit 1 của `speedBubbleWarnMode` (bitmask, mặc định **3** = cả hai) | Bật hiệu ứng viền khi vượt giới hạn |
| — 4 ô **hiệu ứng viền** (hiện khi viền bật) | `speedBubbleWarnFx` 0–3, mặc định **0** | Kiểu hiệu ứng: khung chữ nhật, mặt trời, đầy, vòng tròn |
| — Switch **cảnh báo âm thanh** | bit 2 của `speedBubbleWarnMode` | Bật tiếng cảnh báo |
| — Segment **Chuông / Giọng nói** (hiện khi âm thanh bật) | `speedBubbleWarnSound` 0/1, mặc định **0** | Chọn kiểu âm thanh |
| — 6 hàng **chuông** (hiện khi chọn Chuông) | `speedBubbleWarnTone` 0–5, mặc định **0** | 6 tông chuông tổng hợp (660 + n×110 Hz); bấm là nghe thử ngay |
| — 8 hàng **câu thoại** (hiện khi chọn Giọng nói): 3 câu nghiêm túc + 5 câu vui | `speedBubbleWarnVoice` 0–7 (+8 = tùy chỉnh), mặc định **0** | Câu đọc cảnh báo bằng TTS theo ngôn ngữ; bấm là đọc thử. Câu vui gồm kiểu "máy bay", "ví mỏng", "camera phạt nguội"… |
| — Ô nhập **câu thoại tùy chỉnh** (≤80 ký tự, nút phát bên cạnh) | `speedBubbleWarnVoiceText` | Tự viết câu cảnh báo; bắt đầu gõ là lựa chọn tự chuyển sang câu tùy chỉnh |
| — Slider **ngưỡng cảnh báo** −10…+10 km/h | `speedBubbleWarnOver`, mặc định **+5** | Vượt giới hạn thêm bao nhiêu mới cảnh báo |
| Chân mục cảnh báo (code soạn động) | — | Tóm tắt hiệu ứng + chuông/câu + ngưỡng đang chọn; tắt cả hai thì hiện chữ "đã tắt" |

## 7. TRANG SPLIT SCREEN — "Chia màn hình" (code toàn bộ; plist chỉ có công tắc bật)

Khi feature tắt, từ section 2 trở xuống bị mờ và khóa tương tác.

| Mục | Khóa / mặc định | Chức năng |
|---|---|---|
| **Xem trước chia màn** (vẽ mô phỏng) | đọc `splitScreenLastLeft/Right`, `splitScreenPinnedApp` | Khung mô phỏng: dải trái + 2 ô app theo tỉ lệ 0,46 + huy hiệu ghim; tắt feature thì hiện chữ "đã tắt" |
| Switch **Chia màn hình** | `splitScreenEnabled`, mặc định **BẬT** | Bật/tắt toàn bộ chia màn |
| Switch **tự mở khi kết nối** | `splitScreenAutoLaunch`, mặc định **TẮT** | Tự vào chia màn ngay khi CarPlay kết nối |
| Hàng **app ghim** (hiện tên app đang ghim) | `splitScreenPinnedApp`, mặc định trống | Bấm → mở app picker (§7b) chọn app cố định cho một ô |
| **3 hàng Bố cục yêu thích 1–3** (tên + mô tả "kiểu · các app") — bấm là mở **trình sửa ngay trong danh sách** | họ khóa `splitScreenFav<N>…` | Mỗi bố cục nhớ: tên, kiểu, app trái/phải/(thứ ba) |
| — trong trình sửa: ô nhập **tên bố cục** | `splitScreenFav<N>Name` | Để trống (sau khi cắt khoảng trắng) = xóa tên, hệ tự đặt "Bố cục N" |
| — Segment **kiểu bố cục** 4 lựa chọn | `splitScreenFav<N>Layout` {2, 3, 13, 31}, mặc định **2** | 2/3 = số ô; 13/31 = biến thể xếp chồng |
| — 2–3 nút **chọn app** (chưa đặt hiện ô "+") | `splitScreenFav<N>Left/Right/Third` | Bấm từng nút → app picker (§7b) |
| — Nút **Xong** | — | Thu trình sửa |
| Hàng **panel** với 2 chip bật/tắt: Gần đây / Yêu thích | `splitScreenShowRecent`, `splitScreenShowFavorites` — ⚠️ **lệch mặc định:** phía Cài đặt coi như **BẬT**, phía chạy đọc mặc định **TẮT** | Panel trên xe có hiện mục gần đây / yêu thích hay không |
| Mục **Cử chỉ** (gập/mở, không ghi prefs) | — (biến phiên) | Mở ra hiện đoạn hướng dẫn cử chỉ trên xe |
| Mục **Siri Shortcuts** (gập/mở) + các hàng **URL shortcut** kèm nút **Sao chép** (động theo danh sách trong chuỗi đã dịch) | — | Các URL `omnicar://…` để tạo phím tắt Siri; bấm Sao chép → clipboard + toast |
| (trên xe, không phải hàng Cài đặt) tỉ lệ chia + tỉ lệ theo cặp app + bố cục gần đây | `splitScreenSplitRatio` (mặc định 0,5), `splitScreenPairRatios`, `splitScreenRecentLayouts` (tối đa 10) | Kéo divider trên xe là ghi; picker trên xe đọc lại |

### 7b. Trang con APP PICKER (từ hàng app ghim / nút app trong trình sửa)

| Mục | Chức năng |
|---|---|
| Hàng **Không chọn** (icon cấm) | Bỏ ghim/bỏ app ở vị trí đó; có dấu ✓ khi đang trống |
| Danh sách **app CarPlay** (icon 36 + tên + bundle id + ✓) | App gốc CarPlay do phía xe công bố + 8 app Apple hạt giống (Maps, Music, Podcasts, Phone, Messages, Books, News, Calendar); chân nhóm ghi rõ khi danh sách là "đoán" |
| Danh sách **app đã đưa lên xe** | Chính là tập `appBridgeApps` của §2 |
| Chọn một app | Ghi khóa đích, phát prefschanged, tự quay lại sau 250 ms |

## 8. MODAL HƯỚNG DẪN (Onboarding — tự bật lần đầu; mở lại từ Root)

Vuốt ngang 4 trang; nút Bỏ qua / Tiếp / Xong; hoàn tất hay bỏ qua đều
ghi `onboardingDone = BẬT` để không hiện lại.

| Trang | Nội dung | Control thật |
|---|---|---|
| 1 Chào mừng (icon xe) | Tiêu đề + các dòng giới thiệu + ghi chú | Nút hành động → nhảy thẳng sang trang Apps (§2) ngay trong modal |
| 2 Chia màn (icon chia đôi) | Giới thiệu chia màn | — |
| 3 Tốc độ (icon đồng hồ tốc độ) | Giới thiệu bong bóng tốc độ + một hàng thẻ có **công tắc thật** | Switch ghi thẳng `speedBubbleEnabled` |
| 4 Mẹo (icon phao cứu sinh) | Mẹo sử dụng | — |
| Khung | Chấm phân trang 4 chấm · nút Bỏ qua (ẩn ở trang cuối) · nút Tiếp/Xong | — |

## 9. MODAL "CÓ GÌ MỚI" (What's New — tự bật 1 lần mỗi version; mở lại từ Root)

Khung dựng bằng code (ô icon tia lửa 76×76, tiêu đề + số version, nút
Tiếp tục); nội dung đọc từ `WhatsNew.plist`. Gói 1.0.3 chỉ có dữ liệu
version "1.0.0" với **4 hàng**: **Bàn phím trên màn hình xe** · **Phóng
to ô** (chạm hai lần vào •••) · **14 ngôn ngữ** · **Hướng dẫn lần đầu**.
Hiện modal là ghi `whatsNewSeen = "1.0.3"`.

## 10. PHẦN KHÔNG HIỂN THỊ TRONG CÀI ĐẶT (để đối chiếu "đầy đủ không sót")

### 10a. Khóa ẩn — trạng thái / bộ đếm / chẩn đoán / di sản (≈30 khóa gốc)

| Khóa | Vai trò |
|---|---|
| `trustedTime` | Giờ tin cậy chống lùi giờ cho hạn dùng 01/05/2027; chỉ tăng không giảm |
| `liteMode` (mặc định lệch: lõi đọc 2, splash đọc 0) | Chế độ nhẹ khi máy nóng/tải cao; chỉ đổi được qua URL `omnicar://lite`, không có UI |
| `diagCar` | Hồ sơ chẩn đoán xe (có dây/không dây, tên xe…) ghi lúc kết nối; nhiều nơi đọc chéo (gồm placeholder ô Tên xe §5) |
| `diagPerf`, `diagLastCrash`, `diagCleanRam`, `diagLoaded.<Module>@<Process>` | Chỉ ghi để xem trong báo cáo Gửi log — code không đọc lại để quyết định hành vi |
| `carProfiles`, `carProfileCurrent` (xem thêm bất thường 3) | Kho hồ sơ xe + con trỏ xe hiện tại (§4 là giao diện của chúng) |
| `splitScreenPairRatios`, `splitScreenRecentLayouts`, `splitScreenCarPlayApps`, `splitScreenTipCount`, `splitScreenIconsPending`, `splitScreenIconsCrashed` | Trạng thái chia màn: tỉ lệ theo cặp app, bố cục gần đây, danh sách app do phía xe công bố, bộ đếm mẹo trong picker, cờ chống crash khi áp icon |
| `homeScreenCarApps`, `homeScreenShownApps` | Trạng thái lưới Home: app đã áp lần trước (để so lệch), tập app được hiện |
| `startupScreenOccasionLog` | Nhật ký dịp đặc biệt đã hiện trong ngày (chống lặp) |
| `speedBubbleWarnModeV2`, `speedBubbleSourceV2` | Cờ đánh dấu đã chuyển nghĩa khóa cũ (di sản các bản trước) — migration tự ghi |
| `appBridgeAdvancedReset`, `whatsNewSeen`, `onboardingDone` | Cờ migration 1 lần + trạng thái đã xem hướng dẫn/có gì mới |
| `appBridgeKeyboardLang` | Ngôn ngữ bàn phím tự vẽ (Telex/Anh) — đổi bằng nút ngay trên bàn phím xe, không nằm trong Cài đặt |

### 10b. Khóa chết và khóa mồ côi (gốc 1.0.3)

| Khóa | Tình trạng |
|---|---|
| `splitScreenSplitDirection` | **CHẾT về hành vi:** chỉ được snapshot/khôi phục qua hồ sơ xe, không nơi nào đọc để dùng |
| `splitScreenDirection` | **MỒ CÔI + lệch tên:** accessor duy nhất đọc hướng chia lại đọc khóa này (và accessor không có nơi gọi); không nơi nào ghi → cặp khóa hướng chia không bao giờ gặp nhau, nghi lỗi gốc |
| `cleanRamOnConnect` | MỒ CÔI: đọc lúc kết nối (bật thì dọn RAM app nền), không UI/không nơi ghi trong cây |
| `appBridgeZoom` (mặc định 80, kẹp 0,6–1,0) | MỒ CÔI phía ghi: tỉ lệ hình ô app hosted; chỉ đổi qua hồ sơ xe, không có slider nào trong Cài đặt |
| `appBridgeFps`, `appBridgeOrientation` | MỒ CÔI phía ghi: fps ép cho ô hosted / hướng khởi tạo host; không UI |
| `splitScreenEnglish` | MỒ CÔI: có accessor đọc, không nơi gọi, không nơi ghi |
| `youtubeVirtualize` (mặc định BẬT) | MỒ CÔI phía ghi trong bản gốc: ảo hóa YouTube trong ô hosted (đường zoom YT) — công tắc chỉ xuất hiện ở lớp RE về sau (§11) |
| `speedBubbleAppVietmap`, `speedBubbleAppGOFA` | Di sản: chỉ còn làm dự phòng khi khóa nguồn `speedBubbleSource` vắng hẳn |

### 10c. Bất thường phát hiện khi truy vết

1. **Lệch tên khóa hướng chia** (10b) — nghi lỗi gốc.
2. **URL handler ghi sai kiểu:** `omnicar://lite` và `omnicar://startup` ghi `liteMode`/`startupScreenStyle` dạng **chuỗi** trong khi nơi đọc dùng số nguyên — chạy được nhờ ép kiểu ngầm, nhưng tham số chữ (vd `mode=auto`) sẽ thành 0 âm thầm (liteMode 0 = tắt hẳn).
3. **`carProfileCurrent` hai cách hiểu:** lõi đọc như chuỗi định danh xe; màn chào đọc như số thứ tự hồ sơ.
4. **Mặc định lệch giữa các chỗ đọc cùng khóa:** `liteMode` (2 ở lõi / 0 ở splash); chip Gần đây/Yêu thích (§7); cỡ bong bóng (thanh trượt 60–220 / kẹp đọc 3–220); style nền Home (ghi 0–8 / đọc mặc định 7 kẹp 1–8).
5. **Số thứ tự style Ngẫu nhiên lệch giữa plist (9) và gallery code (10)** — xem §5b.
6. **Không có trang Chẩn đoán trong Cài đặt:** mọi dữ liệu diag chỉ xuất hiện trong báo cáo văn bản của nút Gửi log.
7. **Khoảng trống phục hồi:** danh sách icon trang trí ở dải trái của preview Home (§3) chưa phục hồi được nội dung (PARTIAL); cách gắn ô tìm kiếm vào trang Apps là INFERRED.

## 11. PHỤ LỤC — LỚP THỜI RE, **KHÔNG THUỘC GỐC 1.0.3** (liệt kê để khỏi nhầm)

| Mục | Nội dung |
|---|---|
| Section **Diagnostics** ở cuối trang Chia màn hình (3 control) | Switch "Fullscreen diag" (`fullscreenDiagExpand`), switch "YouTube virtualize" (`youtubeVirtualize` — khóa gốc mồ côi nay có công tắc), segment "Pinch mode" 3 mức (`bridgewake.pinchMode`). Lớp `[fs-diag]` thêm ở các vòng phục hồi |
| Họ khóa `bridgewake.*` (8 khóa, không UI) | `wakeMode`, `pinchMode`, `pinchOffMigratedYtz5`, `pinchAllowlist`, `autoHide`, `gate3Trial`, `pinchInApp`, `carHostPinch` — toàn bộ cơ chế gọi-logo/pinch của thời RE; khóa `bridgewake.gate3TrialBundle` đã bị gỡ đọc ở vòng hl4, chết hẳn |
| `splitScreenPickerSheetClearFaceOff` | Cổng khôi phục mặt sheet chọn app nguyên bản (bản vá picker-face vòng hl5); đặt tay, không UI |

---
Nguồn đối chiếu: `agent-a-plist.md` (plist/strings bundle gốc),
`agent-b-source.md` (source Prefs), `agent-c-keys.md` (truy vết khóa) —
cả ba lưu tại `~/workspace/omnicar-re/work/prefs-audit/` ngày 2026-11-10.
Số "53 khóa" ở các vòng RE trước là tập con đã biết lúc đó; lần rà này
vét cả lớp Prefs + họ homeScreen*/speedBubble* nên tổng ≈99 mục khóa
tính cả lớp RE và các họ khóa động.
