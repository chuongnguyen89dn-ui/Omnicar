# CÀI ĐẶT OMNICAR 1.0.3 — LIỆT KÊ TỪNG TRANG, TỪNG DÒNG

Bản trình bày từng trang/từng dòng rút từ `CAI_DAT_TOAN_BO.md` (bản hợp
nhất 3 đường rà: plist gốc + source Prefs + truy vết khóa, 2026-11-10).
Mỗi dòng: mục hiển thị — khóa prefs (nếu có) — mặc định — chức năng.

## TRANG 1 — TRANG GỐC "OmniCar"

Phần đầu trang (code dựng, không có trong file cấu hình):

1. Logo + tên "OmniCar" + số version "1.0.3" + dòng giới thiệu theo ngôn ngữ — nhận diện, không bấm được.
2. Chấm trạng thái + chữ trạng thái — xanh khi đang bật, xám khi tắt, hiện "Đã hết hạn" sau 01/05/2027.
3. **Công tắc tổng** — khóa `enabled`, mặc định BẬT: tắt là mọi tính năng OmniCar dừng.

Hai nút trên thanh điều hướng:

4. **Respring** — hỏi xác nhận rồi khởi động lại SpringBoard.
5. **Ngôn ngữ** (icon quả địa cầu) — menu 14 ngôn ngữ (Việt, Anh, Tây Ban Nha, Bồ Đào Nha, Đức, Pháp, Ý, Nga, Trung, Nhật, Hàn, Ả Rập, Thái, Indonesia); ghi khóa `language`, giao diện nạp lại ngay.

Các hàng theo thứ tự:

6. Nhóm "Chế độ cứu" + nút **Bật lại** — CHỈ hiện khi có tính năng bị hệ thống tự tắt sau crash: bấm để bật lại tất cả, xóa dấu vết cứu hộ.
7. Nhóm "Tweak có thể xung đột" + 1 hàng chữ — CHỈ hiện khi phát hiện CarBridge / DuoDash / TrueDash / CarPlayEnable đang cài: cảnh báo thuần chữ.
8. **App trên màn xe** → vào Trang 2 (ô phải hiện số app đã chọn).
9. **Màn chính CarPlay** → vào Trang 3.
10. **Màn hình khởi động** → vào Trang 5 (ô phải hiện Bật/Tắt — chính là khóa `startupScreenEnabled`).
11. **Bong bóng tốc độ** → vào Trang 6 (`speedBubbleEnabled`).
12. **Chia màn hình** → vào Trang 7 (`splitScreenEnabled`).
13. **Hồ sơ theo xe** → vào Trang 4.
14. **Xem lại hướng dẫn** — mở lại modal hướng dẫn (Trang 8).
15. **Có gì mới** — mở modal What's New (Trang 9).
16. **Gửi log** — soạn báo cáo chẩn đoán + đính 2 file log, mở khay chia sẻ gửi Mail/chat cho tác giả.

## TRANG 2 — APPS "App trên màn xe" (toàn bộ dựng bằng code)

1. Nút **Đặt lại** (thanh điều hướng) — xóa tập app ẩn/hiện, giữ nguyên lựa chọn app.
2. **Danh sách app đã chọn** (số hàng thay đổi theo số app) — khóa `appBridgeApps`: các app iPhone được đưa lên lưới xe. Mỗi hàng: icon + tên + nhãn phụ "iOS đã tắt" nếu app bị tắt trong Cài đặt CarPlay gốc. Vuốt hoặc nút − để bỏ chọn. App gốc (Điện thoại, Nhạc, Bản đồ, Tin nhắn…) bị khóa không bỏ được.
3. **Ô tìm kiếm** — lọc cả hai danh sách theo tên app.
4. **Danh sách mọi app còn lại** — nút + để thêm app lên xe; app hệ thống ẩn/bị cấm chạy bị loại sẵn.
5. Stepper **số cột lưới** — `homeScreenGridCols`: 0 = Tự động, hoặc ép 3–8 cột.
6. Stepper **số hàng lưới** — `homeScreenGridRows`: 0 = Tự động, hoặc ép 1–4 hàng.
7. Slider **cỡ icon** — `homeScreenIconSize`: 60–130%, mặc định 100; kéo là áp dụng sống.
8. Switch **hiện tên app** — `homeScreenShowNames`, mặc định BẬT: hiện tên dưới icon trên lưới xe.

## TRANG 3 — HOME SCREEN "Màn chính CarPlay" (code; cùng lớp với Trang 2)

1. Nút **Đặt lại** (thanh điều hướng) — xóa 8 khóa lưới/nền + xóa file nền, về mặc định.
2. **Xem trước màn xe** — hình mô phỏng lưới xe (dải trái, đồng hồ 9:41, lưới app theo cấu hình hiện tại, chấm phân trang), tự vẽ lại khi đổi bất cứ mục nào dưới đây.
3. Thẻ **Hình nền** (bấm để gập/mở) — 9 ô kiểu: Mặc định · 6 ô gradient · Ảnh của bạn · Video. Ghi `homeScreenWallpaperStyle` + `homeScreenWallpaper`: chọn nền cho lưới Home trên xe; ô gradient thì hệ tự render thành ảnh nền.
4. Nút **Từ thư viện ảnh** — chọn ảnh (tự thu ≤2000 px) hoặc video (tự cắt ≤20 giây, xuất 1280×720) làm nền.
5. Slider **Mờ (Blur)** — `homeScreenBlur`: 0–30, mặc định 0.
6. Slider **Tối (Dim)** — `homeScreenDim`: 0–70%, mặc định 25.

## TRANG 4 — PROFILES "Hồ sơ theo xe" (code)

1. Switch **bật hồ sơ xe** — `carProfilesEnabled`, mặc định TẮT: bật thì mỗi xe nhớ riêng 14 khóa cấu hình (cặp app gần nhất, app ghim, tự mở chia màn, tỉ lệ chia, mức zoom ô app, kiểu màn chào, tên xe…), nối xe nào áp cấu hình xe đó.
2. **Danh sách xe đã gặp** (số hàng theo số xe) — đọc `carProfiles` + `carProfileCurrent`: mỗi hàng icon xe + tên xe + "lần cuối kết nối: ngày giờ" + dấu ✓ ở xe hiện tại.
3. Hàng chữ "chưa có xe nào" — chỉ hiện khi danh sách trống.
4. Vuốt một hàng xe → **xóa** xe đó khỏi kho hồ sơ (xóa đúng xe hiện tại thì xóa luôn con trỏ hiện tại).

## TRANG 5 — STARTUP SCREEN "Màn hình khởi động" (44 item cấu hình + phần code)

Đầu trang (code dựng):

1. **Xem trước màn chào** — vẽ kiểu đang chọn bằng dữ liệu mẫu; chạm vào = phát lại intro; tự cập nhật khi đổi các mục dưới.
2. **Bộ sưu tập 11 kiểu** (ô cuộn ngang) — `startupScreenStyle`, mặc định 0: 0 Video · 1 Logo · 2 Lời chào · 3 Thời tiết · 4 Khởi động máy · 5 Ánh sáng chào · 6 Hạt sáng · 7 HUD tự kiểm tra · 8 Bảng tin · 9 Lỏng · 10 Ngẫu nhiên. Bấm ô nào thì cả trang dưới đổi theo kiểu đó.
3. Switch **Màn hình khởi động** — `startupScreenEnabled`, mặc định BẬT.

Khi kiểu = Video (9 dòng):

4. **Chọn video** — `startupScreenVideoName`: danh sách lấy từ thư mục Videos trên máy; chưa có video thì màn chào hiện icon xe thay thế.
5. Nút **Thêm video** — nhập từ Ảnh hoặc Tệp (MP4/MOV/M4V ≤60 giây), hệ tự trích khung hình 24 fps + tiếng.
6. Nút **Xem thử** — phát thử video.
7. Nút **Xóa video** (chữ đỏ) — xóa file + thư mục khung hình của video.
8. Segment **Lấp đầy / Vừa khung** — `startupScreenScaleMode`, mặc định Lấp đầy.
9. Switch **Phát hết video** — `startupScreenPlayFull`, mặc định TẮT: bật thì phát hết/lặp thay vì cắt theo thời lượng.
10. Switch **Âm thanh của video** — `startupScreenSound`, mặc định TẮT: bật thì tiếng video thay âm thanh khởi động.

Khi kiểu = Logo (3 dòng):

11. Segment hiệu ứng **Hiện dần / Phóng to / Phát sáng** — `startupScreenLogoEffect`, mặc định Hiện dần.
12. Nút **Chọn logo** — nhập ảnh, tự thu ≤1024 px, lưu thành logo.png (PNG nền trong suốt là đẹp nhất).
13. Nút **Xóa logo** (đỏ) — xóa logo, quay về icon xe.

Khi kiểu = Lời chào / Thời tiết / Hạt sáng / Bảng tin (1 dòng):

14. Ô nhập **Tên của bạn** (không bắt buộc) — `startupScreenGreetingName`: tên trong câu chào theo giờ "Chào buổi sáng, <tên>".

Khi kiểu = Khởi động máy / HUD (1 dòng):

15. Ô nhập **Tên xe** — `startupScreenCarName`: để trống = dùng tên xe do CarPlay báo.

Khi kiểu = Ánh sáng chào (1 dòng):

16. Segment **Chậm rãi / Vừa / Nhanh** — `startupScreenTempo`, mặc định Vừa: tốc độ vệt sáng vẽ dáng xe.

Khi kiểu = Ngẫu nhiên (9 dòng):

17–25. **9 nút kiểu có dấu ✓** (Video, Logo, Lời chào, Thời tiết, Khởi động máy, Ánh sáng chào, Hạt sáng, HUD, Bảng tin) — `startupScreenRandomSet`: mỗi lần kết nối hiện một kiểu khác trong tập đã chọn; không cho tắt hết, phải giữ ít nhất 1.

Luôn hiện ở mọi kiểu (9 dòng):

26. Slider **Thời lượng (giây)** 1–30 — `startupScreenDuration`, mặc định 5: màn chào ở trên màn xe bao lâu.
27. Switch **Chạm để bỏ qua** — `startupScreenTapToSkip`, mặc định BẬT.
28. Nút **Chọn âm thanh** — `startupScreenSoundFile`: chọn file M4A/MP3/WAV/CAF làm âm thanh khởi động phát qua loa xe.
29. Nút **Nghe thử** — phát thử âm thanh khởi động.
30. Nút **Xóa âm thanh** (đỏ) — bản gốc xóa **cả thư mục âm thanh** (cây phục hồi đã chủ động sửa thành chỉ xóa file đang chọn).
31. Slider **Âm lượng** 0–100 — `startupScreenSoundVolume`, mặc định 100.
32. Switch **Im lặng khi đang gọi điện** — `startupScreenSoundSkipCall`, mặc định BẬT.
33. Switch **Màn hình ngày lễ** — `startupScreenOccasions`, mặc định BẬT: Tết/Trung thu/Giáng sinh/Năm mới/sinh nhật hiện màn dịp đặc biệt tối đa 3 lần/ngày.
34. Hàng **Sinh nhật** + ô chọn ngày gắn bằng code (kèm nút × xóa) — `startupScreenBirthday`: ngày sinh để chúc mừng đúng ngày.
35. Nút **Xem thử** ngày lễ — tên nút tự đổi thành dịp sắp tới; bấm là chạy thử màn dịp đó.

## TRANG 6 — SPEED BUBBLE "Bong bóng tốc độ" (code; file cấu hình chỉ có công tắc bật)

1. **Xem trước trực tiếp** — bản đồ giả + bong bóng thật chạy sóng tốc độ 33–72 km/h quanh giới hạn 60.
2. Nút **Thử trên xe** (trên hình xem trước) — ra lệnh cho bong bóng chạy thử ngay trên màn xe + rung + hiện toast.
3. Switch **Bong bóng tốc độ** — `speedBubbleEnabled`, mặc định BẬT.
4. **Dải 9 kiểu bong bóng** (thẻ cuộn ngang) — `speedBubbleLook` 0–8, mặc định 0: 9 style hiển thị.
5. Hàng **Màu** với 7 chấm — `speedBubbleColor`, mặc định 0: 0 conic tự động · 1 trắng · 2 đen · 3 tím · 4 xanh · 5 ngọc · 6 hồng.
6. Switch **hiện icon app** — `speedBubbleShowAppIcon`, mặc định BẬT: hiện icon app nguồn tốc độ trên bong bóng.
7. Slider **cỡ trên điện thoại** — `speedBubbleSizePhone`, mặc định 100%.
8. Slider **cỡ trên xe** — `speedBubbleSizeCar`, mặc định 100%.
9. Hàng **Đặt lại vị trí** — bong bóng trên xe về vị trí mặc định (khi đã bị kéo đi chỗ khác).
10. **4 ô nguồn tốc độ** — `speedBubbleSource`, mặc định Vietmap: Vietmap Live · GOFA · Waze · Wyn; dưới có dòng gợi ý đổi theo nguồn.
11. Switch **cảnh báo viền** — bit 1 của `speedBubbleWarnMode` (mặc định cả hai bit đều bật): vượt giới hạn thì bong bóng có hiệu ứng viền.
12. **4 ô hiệu ứng viền** (chỉ hiện khi mục 11 bật) — `speedBubbleWarnFx`: khung chữ nhật / mặt trời / đầy / vòng tròn.
13. Switch **cảnh báo âm thanh** — bit 2 của `speedBubbleWarnMode`.
14. Segment **Chuông / Giọng nói** (chỉ hiện khi mục 13 bật) — `speedBubbleWarnSound`, mặc định Chuông.
15. **6 hàng chuông** (khi chọn Chuông) — `speedBubbleWarnTone` 0–5: 6 tông chuông tổng hợp, bấm là nghe thử.
16. **8 hàng câu thoại** (khi chọn Giọng nói) — `speedBubbleWarnVoice`: 3 câu nghiêm túc ("Bạn đang vượt quá giới hạn tốc độ"…) + 5 câu vui (kiểu máy bay, ví mỏng, camera phạt nguội…); bấm là đọc thử bằng giọng máy.
17. Ô nhập **câu thoại tùy chỉnh** (≤80 chữ, nút phát bên cạnh) — `speedBubbleWarnVoiceText`: tự viết câu cảnh báo.
18. Slider **ngưỡng cảnh báo** −10…+10 km/h — `speedBubbleWarnOver`, mặc định +5: vượt giới hạn thêm chừng này mới cảnh báo.

## TRANG 7 — SPLIT SCREEN "Chia màn hình" (code; file cấu hình chỉ có công tắc bật)

1. **Xem trước chia màn** — khung mô phỏng 2 ô app + huy hiệu ghim; tắt tính năng thì hiện chữ "đã tắt".
2. Switch **Chia màn hình** — `splitScreenEnabled`, mặc định BẬT. Tắt thì mọi mục dưới bị mờ và khóa.
3. Switch **tự mở khi kết nối** — `splitScreenAutoLaunch`, mặc định TẮT.
4. Hàng **app ghim** (hiện tên app đang ghim) — `splitScreenPinnedApp`: bấm mở Trang 7b chọn app cố định cho một ô.
5–7. **3 hàng Bố cục yêu thích 1–3** — họ khóa `splitScreenFav<N>…`: mỗi hàng hiện tên bố cục + mô tả "kiểu · các app"; bấm vào một hàng là mở trình sửa ngay trong danh sách gồm:
   - 5a. Ô nhập **tên bố cục** — `…Name` (xóa trắng tên = hệ tự đặt "Bố cục N").
   - 5b. Segment **kiểu bố cục** 4 lựa chọn — `…Layout`: 2 ô / 3 ô / hai biến thể xếp chồng.
   - 5c. **2–3 nút chọn app** (chưa đặt hiện dấu +) — `…Left / …Right / …Third`, bấm mở Trang 7b.
   - 5d. Nút **Xong** — thu trình sửa.
8. Hàng panel với 2 chip bật/tắt **Gần đây** / **Yêu thích** — `splitScreenShowRecent`, `splitScreenShowFavorites`: panel trên xe có hiện hai mục này không. (Lưu ý: phía Cài đặt hiển thị mặc định là bật, phía chạy thật đọc mặc định là tắt — lệch đã ghi trong tài liệu.)
9. Mục **Cử chỉ** (bấm để gập/mở, không lưu cài đặt) — mở ra hiện đoạn hướng dẫn cử chỉ trên xe.
10. Mục **Siri Shortcuts** (gập/mở) + các hàng **URL phím tắt** kèm nút **Sao chép** — chép URL `omnicar://…` vào bộ nhớ đệm để dán vào app Phím tắt của iOS, kèm toast xác nhận.

## TRANG 7b — TRANG CON CHỌN APP (mở từ mục ghim / nút app ở Trang 7)

1. Hàng **Không chọn** (icon cấm) — bỏ ghim/bỏ app ở vị trí đó; có dấu ✓ khi đang trống.
2. Danh sách **app CarPlay** (icon 36 + tên + mã bundle + dấu ✓ ở app đang chọn) — app gốc do phía xe công bố cộng 8 app Apple hạt giống (Bản đồ, Nhạc, Podcasts, Điện thoại, Tin nhắn, Sách, Tin tức, Lịch); chân danh sách ghi rõ khi đây là danh sách "đoán".
3. Danh sách **app đã đưa lên xe** — chính là tập app đã chọn ở Trang 2.
4. Chọn một app → ghi khóa đích, tự quay lại sau 0,25 giây.

## TRANG 8 — MODAL HƯỚNG DẪN (tự bật lần đầu mở Cài đặt; mở lại từ Trang 1 mục 14)

1. Trang 1 "Chào mừng" (icon xe) — giới thiệu + nút hành động nhảy thẳng sang Trang 2 (Apps) ngay trong modal.
2. Trang 2 "Chia màn" — giới thiệu tính năng chia màn.
3. Trang 3 "Tốc độ" — giới thiệu bong bóng tốc độ, có **một công tắc thật** ghi thẳng `speedBubbleEnabled`.
4. Trang 4 "Mẹo" — mẹo sử dụng.
5. Khung chung: 4 chấm phân trang · nút **Bỏ qua** (ẩn ở trang cuối) · nút **Tiếp/Xong**. Hoàn tất hay bỏ qua đều ghi `onboardingDone` để không tự hiện lại.

## TRANG 9 — MODAL "CÓ GÌ MỚI" (tự bật 1 lần mỗi version; mở lại từ Trang 1 mục 15)

1. Khung: icon tia lửa + tiêu đề + số version + nút **Tiếp tục** đóng modal. Hiện modal là ghi `whatsNewSeen = "1.0.3"`.
2. Hàng **Bàn phím trên màn hình xe** — gõ chữ trong app iPhone ngay trên màn xe.
3. Hàng **Phóng to ô** — chạm hai lần vào dấu ••• của một ô để ô chiếm cả màn hình, chạm hai lần nữa để quay lại.
4. Hàng **14 ngôn ngữ** — chọn bằng nút quả địa cầu.
5. Hàng **Hướng dẫn lần đầu** — chỉ đường mở lại hướng dẫn.

---

Phần đối chiếu sâu nằm ở `CAI_DAT_TOAN_BO.md` cùng thư mục: §10 —
khoảng 30 khóa ẩn không có giao diện (trạng thái, chẩn đoán, chống lùi
giờ…), 1 khóa chết + 7 khóa mồ côi, và các bất thường (lệch tên khóa
hướng chia, URL ghi sai kiểu dữ liệu); §11 — phần của thời RE không
thuộc gốc (mục Diagnostics ở Trang 7, họ khóa bridgewake).
