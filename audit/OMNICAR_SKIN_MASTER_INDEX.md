
# OMNICAR — MASTER SKIN INVENTORY / TỔNG HỢP TOÀN BỘ SKIN

**Kiểm tra:** 2026-10-19. **Trạng thái:** chỉ phân tích DEB gốc; KHÔNG sửa DEB, không theme mới, không phát hành Sileo.

## 1. Nguồn và kết quả có bằng chứng

- **Nguồn:** com.anlai.omnicar_1.0.3_iphoneos-arm64.deb, SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd.
- Đã giải nén 176 file: **15 PNG, 139 .strings ngôn ngữ, 14 PLIST, 6 dylib, 2 executable**. Không có bộ .car/.xcassets, HTML/CSS skin, hoặc hình PNG riêng cho nút ba chấm/thanh chia/launcher/HUD.
- Đã kiểm tra 8 Mach-O bằng strings: **33 kiểu/API UI trên mỗi binary** = 264 phép kiểm tra, **163 lần phát hiện API/kiểu UI** (không phải 163 màu hay 163 nút). Đã đọc các PLIST Settings: 70 mục cấu hình/symbol. Các kết quả có thể chạy lại với scripts/audit_skin_surfaces.py.
- Chỉ những API có mặt trong binary đã được xác minh. **Cần disassembly + log/screenshot runtime** trước khi khẳng định từng thành phần có thể hook chính xác tại một method. Không đánh đồng selector có mặt với property của tất cả view.

## 2. Các loại skin đổi được: màu, icon, lớp, kích thước và hiệu ứng

| API/lớp được phát hiện | Thuộc tính có thể can thiệp | Lưu ý |
| --- | --- | --- |
| UIView | backgroundColor, tintColor, alpha, hidden, clipsToBounds | Thay đúng view của OmniCar, không hook UIKit toàn cục |
| UIButton | màu nền, màu icon, hình/nét icon, selected/pressed/disabled, nhãn | Không sửa action, hitTest, gesture, vùng chạm |
| UILabel / UIFont | màu chữ, font, độ đậm, size, căn lề | Giữ layout và chữ tiếng Việt |
| UIImageView / SF Symbols | tint, hình, renderingMode, symbol weight/size | Không đổi UI bên trong YouTube hoặc Maps |
| CALayer | borderColor, borderWidth, cornerRadius, shadowColor, shadowOpacity, shadowRadius | Giữ frame, z-index, clipping, mask |
| CAGradientLayer | colors, locations, startPoint, endPoint, alpha | Đổi đúng layer, không swizzle màu toàn hệ thống |
| CAShapeLayer | fillColor, strokeColor, lineWidth, lineCap, path | Đổi path/hình học chỉ khi đã test hit-target |
| UIBezierPath / CoreGraphics | fill, stroke, đường cong, hình trang trí | Không có file PNG để thay thế nét được vẽ bằng mã |
| UIVisualEffectView | blur/vibrancy, mức tint phủ lên vật liệu | Tùy bộ điều khiển; phải test độ tương phản trên xe |
| PNG nguồn | icon app, Settings, logo, @2x/@3x | Không thay được lớp chia màn hình bằng cách thay 15 PNG |

**Có thể tạo skin đổi màu toàn diện**, nhưng đó là lớp giao diện/theme mới hook vào các lớp OmniCar, KHÔNG phải một công tắc đổi màu chung đã có sẵn trong DEB.

## 3. Bản đồ 27 khu vực giao diện / nơi chỉnh

Xem chi tiết theo từng hàng tại **audit/skin_surface_matrix.csv**.

### A — OmniCarSplitScreen.dylib (11 nhóm — ưu tiên số một)

Owner có bằng chứng: SCPCarSplit, SCPCarPane, SCPCarSplitView, SCPCarDividerView; selectors tìm thấy: newDividerAt:, setupBarForPane:, layoutBarForPane:, setBarVisible:forPane:, showRatioMenuForDivider:, hideRatioMenu, refreshHomeButton, buildPickerSheetForPane:, refreshPickerSheet, layoutPickerDotsForPage:, restartTrayTimer, showLayoutPanelForApp:, closeFloat:.

1. **Nền ô chia đôi / 3 ô:** màu panel, border, corner radius, mask, shadow, focus.
2. **Thanh/vạch phân chia:** lineColor, alpha, thickness, highlight khi kéo; giữ pan và đổi tỷ lệ.
3. **Nút tròn chia tỷ lệ:** gradient xanh-tím, viền, vòng sáng, icon; giữ kích thước vùng chạm.
4. **Thanh 3 nút lựa chọn bố cục:** nền kính/gradient, viền, selected stroke/icon, màu 3 ô, shadow.
5. **Nút ba chấm nhỏ trên mỗi pane:** nền capsule, dot tint, đường viền, alpha.
6. **Thanh menu mở rộng của pane:** nền mờ, action icon, text, trạng thái focus; giữ timer và callbacks.
7. **Nút hai ô vuông/mở lại giao diện:** màu, icon, viền; tuyệt đối giữ đường thoát fullscreen.
8. **Picker chọn ứng dụng:** panel, icon app, chấm phân trang, selected, chữ.
9. **Tray / preset / bảng lựa chọn:** nền, màu text, viền, badge, bóng.
10. **Floating/solo popup:** nền/viền cửa sổ, toolbar, shadow, icon, nhưng không sửa scene ownership.
11. **Loading/toast/placeholder:** icon tải, progress, text, nền, hiệu ứng.

### B — OmniCarAppBridge.dylib (4 nhóm)

Các class ABBarButton, ABBoxView, ABKnobView, ABPane, ABKeyboard, ABShieldView, selectors buildBarForPane:, layoutBarForPane:, setHandleVisible:forPane:, buildPanel, layoutPanelIn:, setupHandleForPane:.

12. Thanh công cụ khi host ứng dụng iPhone: blur, nền, tint icon, viền.
13. Núm kéo/chấm của Bridge: capsule, glow, border/alpha, màu khi active.
14. Keyboard + panel + nút chức năng: nền, font, màu nút, selected và panel kính.
15. Preview/overlay/app switcher: màu khung/điểm nhấn; không thay safe-area, zoom, kích thước app hay touch mapping.

### C — OmniCarSpeedBubble.dylib (5 nhóm)

Classes SPPBubbleView, SPPGlassView, SPPSignView, SPPIconView, SPPBubble. Selectors buildStyle:, renderBubble, renderStyle, applyColor:, applyColors, showMenu. Preferences speedBubbleLook, speedBubbleColor, speedBubbleSizeCar, speedBubbleShowAppIcon.

16. Nền bong bóng tốc độ: glass, fill, gradient, transparency, radius, shadow.
17. Số tốc độ / biển giới hạn: font, màu chữ, viền, lineWidth, badge.
18. Icon nguồn dữ liệu/app: tone, nền, glow và accent.
19. Cảnh báo: đỏ/cam/cấp độ màu, flash, stroke; giữ nguyên logic cảnh báo.
20. Menu điều chỉnh bubble: nút, selected, viền, kính mờ.

**Chín kiểu bubble có sẵn** chủ yếu được dựng động, không tương ứng với chín PNG resource trong gói.

### D — OmniCarStartupScreen.dylib (3 nhóm)

Classes SSCanvasView, SSStartupView, SSGauge, SSSplash. CAGradientLayer/CAShapeLayer, UIBezierPath và SF Symbols được dùng trong binary.

21. Nền splash, gradient, độ mờ, animation.
22. Gauge/kim đo, vòng viền, text/number, các card greeting/weather.
23. Logo/title/symbol và overlay. Video/ảnh tự chọn được đọc từ điện thoại, không nằm trong DEB.

### E — Settings / app icons / shared (4 nhóm)

24. OmniCarPrefs: PreferenceLoader Settings row, công tắc, icon/label/SF Symbols; có thể thay thiết kế Settings độc lập.
25. OmniCar.app icon (AppIcon60x60@2x/@3x), branding và logo.
26. OmniCarCore.dylib: tiện ích và một số UI/color methods, **không phát hiện theme engine chung**.
27. OmniCarCarProbe.dylib: thăm dò/kiểm tra kết nối, **không có surface skin chính được xác minh**.

Danh sách **15 ảnh** (6 nhóm AppIcon, PackageIcon, Settings icon, logo, SpeedBubbleIcon, StartupScreenIcon), đủ path/resolution/SHA256: audit/omnicar_1.0.3_assets.csv. Danh sách UI class, method và rủi ro: audit/skin_surface_matrix.csv.

## 4. Những phần KHÔNG nằm trong bộ skin OmniCar

- Thanh Dock, status bar, đồng hồ và icon ứng dụng trên Apple CarPlay: do hệ thống cung cấp, không phải asset trong OmniCar.
- Nội dung của YouTube, bản đồ, Waze, GOFA, Vietmap và các ứng dụng iPhone được host: do app đó tự vẽ. Skin OmniCar chỉ đổi phần khung/điều khiển bao quanh.
- Không gộp thay skin với: sửa timer tự ẩn 3 giây, phóng to/thu nhỏ scene, mất ba chấm, kích thước YouTube, native dock, đổi hành vi kéo, hay độ ổn định của CarPlay.

## 5. Đề xuất gom skin thành một theme thống nhất

File **skin/theme_tokens.template.json** liệt kê những biến cần thống nhất; các giá trị màu để null cho đến khi người dùng duyệt thiết kế.

- Palette: panel, surface, accent, selected, icon, disabled, text, border, divider, glass overlay, danger/warning, HUD.
- Gradient: màu đầu/cuối, hướng chuyển, stop.
- Glass: blur style, overlay tint, opacity.
- Shape: border thickness, corner/pill radius, visible knob diameter, touch target.
- Effects: shadow color/opacity/radius, glow, transition duration.
- Typography: size, weight, icon size/symbol weight; trạng thái normal/selected/pressed/disabled/fullscreen/split/dark/light.

**Không thể áp JSON thẳng lên các dylib đóng.** Phải viết một theme addon riêng với whitelist class/process của OmniCar và hook ở thời điểm view/layer được tạo/cập nhật, đồng bộ các token. Không viết hook UIColor/UIView toàn hệ thống.

## 6. Thứ tự và ràng buộc thực hiện khi sau này làm skin

1. Chốt bộ màu và mẫu UI, ưu tiên **11 nhóm SplitScreen** vì đây là phần người dùng thấy nhiều nhất.
2. Làm skin addon rootless mới, không sửa DEB gốc; không đổi chức năng Zoom (đang dùng 0.7.0) hay thêm nút cứu (đã bị hủy).
3. Test một cửa sổ/từng menu trước, rồi kiểm 2-pane/3-pane/fullscreen/float, portrait/landscape, tương phản và thao tác chạm/kéo.
4. Tiếp tục theo nhóm AppBridge → SpeedBubble → StartupScreen → Settings khi mỗi nhóm đã được xác nhận trên xe.
5. **Không xuất DEB skin hoặc triển khai Sileo khi mới chỉ đang tổng hợp.**

**Tài liệu liên quan:** audit/OmniCar_1.0.3_skin_asset_inventory.md; audit/omnicar_1.0.3_assets.csv; scripts/audit_skin_assets.py; scripts/audit_skin_surfaces.py. Quét tĩnh đã thực hiện; chưa có skin mới được xác minh trên xe.
