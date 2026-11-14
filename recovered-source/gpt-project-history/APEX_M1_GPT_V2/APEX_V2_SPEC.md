# DuoCar APEX V2 — DESIGN SYSTEM & IMPLEMENTATION CONTRACT

**Mức chứng cứ: DESIGN PROPOSAL / NOT APPROVED.** Sáng tác hình thức GPT ngày 2026-11-14, chưa có mã mới, chưa compile, CI hoặc test trên xe. Trình Nguyen xem trực quan trước khi Muse viết UI. Không thay đổi chức năng hiện có, không quy đổi mô phỏng thành chứng cứ runtime.

## 1. Hướng sáng tạo

**APEX STEALTH**: hệ hình OEM premium, nhịp sáng tối rõ, icon đường nét đồng bộ. Không còn lưới card pastel/mesh tam giác Play OmniCar; dùng **dấu D có hai tuyến cong như hai làn đường**, mang ý chia đôi/cùng tiến. Brand chỉ xuất hiện trên UI DuoCar. Logo gốc nhà cung cấp và nội dung app khác không đổi. Không biến UI thành dashboard của hãng ô tô nào.

## 2. Design tokens (logical pt, ngoại trừ mockup xuất pixel)

| Token | Giá trị | Vai trò |
|---|---|---|
| surface.root | #101820 | nền DuoCar |
| surface.deep | #0A1218 | thanh điều hướng, vùng âm |
| surface.1 | #1B2A34 | panel nổi mức 1 |
| surface.2 | #233640 | focus / grouped controls |
| surface.3 | #2C424D | pressed / secondary |
| text.primary | #EAF6FB | nội dung / icon |
| text.secondary | #93AAB8 | phụ đề |
| accent.focus | #61D9F2 | duy nhất trạng thái chọn/CTA |
| accent.teal | #2EA6BB | nét phụ và hiệu ứng nhẹ |
| accent.amber | #F4B75F | chỉ số nhiệt bình thường/chú ý |
| danger.control | #FF4757 | nút đóng/lỗi UI thông thường |
| danger.thermal | #FF0610 | **viền nhiệt HL61 gốc; không đổi logic/opacity** |
| stroke.default | #35515F | đường phân tách tinh tế |

**Kiểu chữ:** SF Pro trên iOS, fallback system; iPhone heading 27/semibold-bold, section 18/semibold, body 15–17, caption 11–13; CarPlay glyph 24×24 reference và chữ chức năng 16–20 tùy context. Font có sẵn, KHÔNG bundle font ngoài. **Spacing:** lưới 4/8 pt, page inset 20, panel radius 14–19, border 1 pt chỉ khi cần phân tách; tránh mọi thẻ đều viền cyan. Shadows nhẹ riêng DuoCar-owned chrome, không darken content app. **Color contrast:** chữ chính sáng trên graphite; chú ý ánh sáng ngày; não trạng focus luôn phân biệt bằng shape/border nhẹ, không chỉ hue.

**Trạng thái tương tác:** default = neutral surface+white; focus/selected = 2pt cyan trên component được chọn; pressed = surface.3 + alpha màu nhấn; disabled = muted 55% + không hiệu ứng; danger = red chỉ control/error; loading = spinner gọn nhưng giữ gốc lifecycle; alert A1 = viền đỏ động gốc; touch/haptic KHÔNG đổi trong skin release.

## 3. iPhone — cấu trúc & đường điều hướng

- **Bảng điều khiển (D5):** trạng thái kết nối, preview hai ô **chỉ minh họa**, thao tác Bố cục/Ứng dụng ưu tiên, pin/nhiệt/GPS tham khảo; không đọc scene/screenshot bên thứ ba mới, không tạo IPC mới để phục vụ preview.
- **Bố cục:** danh sách tỷ lệ/cấu hình hiện có, preview tương ứng, CTA Áp dụng gọi action hiện hữu. Mockup 50/50 và 35/65 **chỉ đề xuất UI**, không khẳng định danh sách preset runtime đã có chính xác hai lựa chọn này; khi code, map preset thật trong `OMCNativeSettings.m`.
- **Ứng dụng:** hai ngăn native/hosted, chọn app từ nguồn hiện hữu, không tự thêm quyền CarPlay hoặc bundle; giữ đăng ký và launch path.
- **Thiết bị:** thời gian/pin/nhiệt từ nguồn sẵn có, GPS offset Lề -10..+10 và master bubble của hãng giữ nguyên key/action; hàng thử cảnh báo nhiệt dùng chính `duocarThermalTest37Enabled` (tên hiển thị có thể đổi, key/default/notify tuyệt đối giữ). Không vẽ popup thử trong CarPlay; cảnh báo xe chỉ có câu gốc.
- **Tùy chỉnh:** nơi gom phần hiển thị/Startup/điều khiển đã có; không tự sáng tạo toggle có backend chưa tồn tại. Mọi cell mới phải có bảng map action/key trước code.
- **Startup iPhone:** danh mục style cũ, ảnh/logo do người dùng nạp giữ nguyên đường lưu và phương thức khởi chạy.

**Chú ý:** mockup bottom navigation 5 mục chỉ là visual target. Chuyển từ root 3 tabs hiện có sang 5 vùng phải trình sơ đồ chuyển tiếp/route và mapping key cụ thể trong M2-4; chờ duyệt từng hunk C5/F10, không tạo 5 bộ prefs độc lập. iPhone clock và các số trong mockup là dữ liệu minh họa, KHÔNG phải log/test.

## 4. CarPlay — ranh giới hình thức

- **D1/D2:** 5 glyph `hm_apps/hm_full/hm_float/hm_min/hm_close` dùng chung split và hosted, stroke 1.8–2.2, icon vector 24×24 tham chiếu. Bề mặt charcoal/titanium, alpha nội thất đủ đọc mà không che quá mức; **khung bar 52pt, handle visual 34×12, hitbox hosted 44×24 giữ theo source HL61 (C1/C2)**. Không đổi selector, ABI, AutoHide, wake, click swallow, order hay z-layer.
- **D3 Picker:** cùng hệ nhận diện, tray không xóa cảnh nền ứng dụng ngoài vùng sheet; mockup native/hosted thể hiện hình minh họa tiếp tục chạy phía dưới. **Giữ nguyên frame cols×62+20, +150 cột bản đồ, window StatusBar+65, hitTest pass-through, masks/suppression như source hiện tại**. U11 vẫn chưa device-proven, không được sửa behavior chỉ để hình mockup giống kết quả mong muốn.
- **D4 Divider/knob:** đổi chỉ glyph/gradient/đường viền; giữ kích thước knob, nới hit −26 pt, ratio menu và gesture relay F10/C4. Không đẩy menu lên giữa nội dung app một cách mới.
- **D10 fullscreen:** đúng yêu cầu Nguyen: giờ–pin–nhiệt **một hàng góc trái trên**, KHÔNG nền/capsule/bong bóng, không chặn cảm ứng, không đổi frame/window+64.0, không thêm overlay vào app scene; chỉ xuất hiện sau Expanded và dock ẩn. Nhiệt minh họa 34°C nên mockup fullscreen không có cảnh báo.
- **D11 Home:** duy nhất icon và nhãn DuoCar thuộc phạm vi; Home lưới, dock và các app của iOS không đổi. `SCPHomeLauncherInjectInfo` và launch action F4 tuyệt đối không đổi.
- **D13 phím vẽ hosted:** chỉ đổi màu/chữ/shadow phím trên keyplane đang có, không thay tỷ lệ/bố cục gửi phím, Telex hay keyboard native. **U3 DEVICE PENDING**, cần xác minh trước lô này. Mockup không có giá trị đo keyboard geometry.
- **D9 startup:** đổi scene/asset của DuoCar, không sửa `SSSplashWindow` level Alert+1000 hay start/dismiss/teardown và không che UI runtime sau kết thúc.
- **A1 thermal:** giữ `SCPThermalEdgeWarning.h` inset ngoài 5pt, 7pt border, inner inset 12pt/1.5pt, pulse 0.45↔1.0/0.75s loop và text **DUY NHẤT "LÀM MÁT THIẾT BỊ CỦA BẠN"**. Trung tâm trong suốt, không phủ đỏ; mọi view pass-through. Sắc đỏ HL61 ≈#FF0610 giữ nguyên cho đến khi Nguyen duyệt thay; danger control #FF4757 không áp vào thermal bằng suy đoán. **Logic >=37°C liên tục, chỉ dừng khi nhiệt thật <37 và thử OFF nếu đang thử**, theo contract HL60; không đổi gate/timer/windowLevel.

## 5. Asset contract và hướng dẫn dùng cho Muse

- SVG `assets/duocar-apex-home.svg` là tác phẩm vector đề xuất để chuyển sang kích thước PNG/UIImage theo khai báo Info.plist/Resources **của source thật**, không sử dụng SVG trực tiếp nếu pipeline UIKit không hỗ trợ. Không đổi bundle ID hoặc registration khi thay image.
- Glyph `assets/hm_*.svg` cung cấp hình nét; tạo factory glyph dùng chung bằng mapping nhưng phải giữ **bộ tên/selector đúng ở cả `SCPCarSplit+Chrome.m` và `ABHostBMethods.m`**. Không dùng file icon 24px để tính lại hit target.
- Bảng ảnh visual 390×844/1280×720 dùng để duyệt màu/bố cục/visual hierarchy, KHÔNG là nguồn frame runtime; vị trí chính xác lấy từ project code tại M0.
- Workflow thực tế build từ `project/`; gương `src/` có bảy file trôi; phải hunk-review thay đổi và không copy đè. Không mang PNG concept AI không kiểm soát chữ/số vào runtime. Hình style board mang tính hướng dẫn thẩm mỹ, source SVG chốt text chính xác.
- Hình minh họa map, media, các icon app hệ thống chỉ đại diện cho *nội dung bên thứ ba do hệ thống sở hữu*, không sao chép hay tái tô màu bên trong các scene.

## 6. Gate giao việc

**M1 GPT V2:** cần Nguyen duyệt logo, sắc độ, hierarchy dashboard, picker, thermal, fullscreen và toàn cảnh CarPlay. Sau đó GPT kiểm tra source/hunk implementation map; Muse đề xuất từng lô M2/M3 với file/method/hunk cụ thể và chờ duyệt các vùng F/C. M4 review bằng diff & screenshot thật; M5 chỉ build 1 DEB khi Nguyen yêu cầu. Không mở PR, không CI, không code hay publish trong gói thiết kế này.
