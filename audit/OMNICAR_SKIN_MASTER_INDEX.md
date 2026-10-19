# OMNICAR — SỔ TỔNG HỢP SKIN (CHỈ OMNICAR VẼ)

**Quy tắc đã chốt 2026-10-19:** người dùng chỉ cho phép thay phần UI do OmniCar tạo. Không sửa bất kỳ giao diện hệ thống iOS/Apple CarPlay hoặc nội dung app khác. Tài liệu nghiên cứu, không phải skin đã áp dụng.

## 1. Nguồn kiểm kê

- DEB nguyên bản: com.anlai.omnicar_1.0.3_iphoneos-arm64.deb; SHA256: d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd.
- 176 file: 15 PNG, 139 bản dịch strings, 14 plist, 6 dylib, 2 executable. Không có bộ PNG cho divider, nút ba chấm, HUD và menu split.
- Nguồn bằng chứng: audit/OmniCar_1.0.3_skin_asset_inventory.md, audit/omnicar_1.0.3_assets.csv. Đã kiểm tra metadata/UI selector trên 6 dylib và 2 binary, plist Settings. 33 nhóm API/selector x 8 binary = 264 phép tra; 163 lần có dấu hiệu API. Đây là presence check, KHÔNG phải 163 nút hoặc màu đã xác minh.

## 2. Danh mục tất cả khu vực OmniCar được đổi skin

| Nhóm | Thành phần | Các thay đổi ngoại hình có thể nghiên cứu |
|---|---|---|
| OmniCarSplitScreen.dylib | Khung chia, viền, đường chia, nút tròn, menu 3 bố cục, nút ba chấm và thanh menu, home 2 ô vuông, picker, tray, cửa sổ nổi, spinner/toast | Nền, gradient, kính mờ, nút/icon, shadow, nét, màu selected, corner radius |
| OmniCarAppBridge.dylib | Thanh công cụ app iPhone, knob, bảng popup, bàn phím OmniCar | Nền, nút, tint, font và border của UI OmniCar |
| OmniCarSpeedBubble.dylib | Bong bóng tốc độ, biển giới hạn, 9 kiểu HUD, icon và menu nguồn | Nền kính, viền, vòng sign, màu tốc độ, glow/cảnh báo |
| OmniCarStartupScreen.dylib | Splash/canvas, logo, gauge, chữ và hiệu ứng mở đầu | Gradient, gauge stroke, nền, icon, font, animation appearance |
| OmniCarPrefs.bundle và OmniCar.app | Form cài đặt, biểu tượng cài đặt, icon/branding OmniCar | 15 PNG chính chủ, color/tint cho form do OmniCar tạo |
| Addon Zoom OmniCar 0.7 | Nút Zoom nằm dưới nút tròn | Gradient xanh-tím, kích thước trang trí, viền trắng, nét mũi tên |

Chi tiết 22 hạng mục, owner và những phần không được sửa: **audit/OMNICAR_SKIN_SURFACE_MATRIX.csv**.

## 3. Thuộc tính skin và API

- UIView/UIButton: backgroundColor, tintColor, alpha, trạng thái normal/pressed/selected/disabled; chỉ đúng đối tượng UI OmniCar.
- CALayer: borderColor, borderWidth, cornerRadius, shadowOpacity, shadowColor; không thay cấu trúc view.
- CAGradientLayer: các màu gradient, hướng và stops; giữ clipping/vùng chạm.
- CAShapeLayer/UIBezierPath/CoreGraphics: màu tô, màu nét, độ dày, độ cong của hình trang trí; không làm lệch vị trí nút.
- UILabel/UIFont/UIImageView/SF Symbols: text/icon tint, font/size/weight hợp lý để không cắt nhãn tiếng Việt.
- UIVisualEffectView: style blur và màu phủ NẾU view được xác minh có hiệu ứng này trong runtime.
- UIImage: thay PNG OmniCar-owned đúng tên @2x/@3x; không giả định thay ảnh sẽ đổi các nút được vẽ bằng mã.

## 4. DANH SÁCH CẤM — không đụng hệ thống hay app thứ ba

- KHÔNG theme dock Apple CarPlay, thanh status/clock/battery/LTE, DBStatusBarWindow, CARStatusBarWindow, icon hệ thống, CarPlay Dashboard/native apps.
- KHÔNG đổi bất kỳ nội dung YouTube/Maps/Waze/GOFA/Vietmap hoặc scene con của chúng. Nút của AppBridge do OmniCar tự vẽ là ngoại lệ; nội dung ứng dụng KHÔNG phải ngoại lệ.
- KHÔNG hook UIView/UIButton/UIColor/CALayer/UIWindow toàn hệ thống; phải giới hạn whitelist theo lớp OmniCar cụ thể.
- KHÔNG động sceneBox, appBridgeZoom, host frame, orientation, viewport, hitTest, gesture, timer, chia tỷ lệ, mở app, zoom, phát video, GPS.
- KHÔNG khôi phục nút cứu hộ 0.6.0 do người dùng đã loại bỏ. Giữ cơ chế Zoom 0.5/0.7.
- KHÔNG phát hành Sileo hoặc cài lên thiết bị chỉ để đổi skin khi chưa có yêu cầu.

## 5. Phương án thực thi khi người dùng chọn màu/skin

1. Dùng một bộ token màu / viền / gradient riêng cho OmniCar (template: skin/omnicar_tokens_template.json). Giá trị mẫu là null, chưa có skin được duyệt.
2. Làm theo từng nhóm, bắt đầu SplitScreen; hook sau khi OmniCar tạo view/layer (ưu tiên các selector setup/layout xác minh được), đổi CHỈ appearance, không thay callback hoặc frame.
3. Kiểm tra split 2/3 ô, ratio drag, menu, pane 3 chấm, fullscreen, float, nhãn tiếng Việt, touch targets và nút thoát. Sai là rollback nhóm skin.
4. Tiếp tục độc lập cho AppBridge controls, SpeedBubble, Startup, Settings/branding. Mặc định theme off = giữ nguyên ngoại hình gốc.
5. Chỉ tạo DEB thử nghiệm sau khi chốt bảng màu; không ghép thay đổi skin với sửa logic fullscreen/auto-hide/YouTube.

**Tình trạng:** kiểm kê và phạm vi hoàn tất. Từng thuộc tính cụ thể của từng view cần đối chiếu runtime; chưa viết theme hooks, chưa đổi một màu trên thiết bị, chưa build DEB skin.
