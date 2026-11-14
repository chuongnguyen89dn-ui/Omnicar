# DuoCar APEX — GPT DESIGN V2 (DESIGN-ONLY)

**Ngày:** 2026-11-14. **Trạng thái:** bộ thiết kế GPT bàn giao để NGUYEN DUYỆT; **chưa được duyệt, không phải UI đang chạy**. Muse **không tự viết UI M2/M3** khi chưa có phê duyệt. Đây là nhánh thiết kế kế thừa M0 PASS, M1 Muse v1 FAIL; không sửa/xóa 46 ảnh lịch sử.

- Duy nhất repo `chuongnguyen89dn-ui/Omnicar`, cây `recovered-source/`, Issue #1.
- HL61 source baseline `298b7b4a8432037d71db441d0975aca1db1f6e04`; nhánh Muse `feature/duocar-apex-ui-muse-20261114`.
- Bộ này gồm **15 mockup vector từng màn + board nhận diện, 11 file vector asset, spec, ma trận và kiểm nhận**. Tất cả SVG là ảnh thiết kế hiển thị trực tiếp trên GitHub, có thể phóng to không vỡ; **không phải PNG chụp máy/xe**. Bản mockup iPhone 390×844, CarPlay 1280×720. Không có UI code/DEB/CI.
- Hình minh họa map/media/app gốc **không** phải ảnh chụp Google Maps/YouTube/iOS và không phải bằng chứng compositor; Muse tuyệt đối không vẽ lại hoặc đổi màu nội dung của ứng dụng bên thứ ba.
- [Bảng nhận diện](visual/00-brand-system.svg) · [Home icon](assets/duocar-apex-home.svg) · [Spec triển khai](APEX_V2_SPEC.md) · [Ma trận source/hợp đồng](APEX_V2_MATRIX.md) · [Checklist nghiệm thu](ACCEPTANCE.txt)

## Đối chiếu từng màn (cột cũ chỉ là minh họa dựng theo HL61 của M1 v1, KHÔNG phải ảnh chụp thiết bị)

| Bề mặt | Tham chiếu trước | Thiết kế APEX GPT mới |
|---|---|---|
| Bảng điều khiển | [Tham chiếu HL61 dựng lại](../APEX_M1/iphone-bang-dieu-khien-truoc.png) | [APEX V2](visual/iphone-01-dashboard.svg) |
| Bố cục | [Tham chiếu HL61 dựng lại](../APEX_M1/iphone-bo-cuc-truoc.png) | [APEX V2](visual/iphone-02-layout.svg) |
| Ứng dụng | [Tham chiếu HL61 dựng lại](../APEX_M1/iphone-ung-dung-truoc.png) | [APEX V2](visual/iphone-03-apps.svg) |
| Thiết bị | [Tham chiếu HL61 dựng lại](../APEX_M1/iphone-thiet-bi-truoc.png) | [APEX V2](visual/iphone-04-device.svg) |
| Tùy chỉnh | [Tham chiếu HL61 dựng lại](../APEX_M1/iphone-tuy-chinh-truoc.png) | [APEX V2](visual/iphone-05-customize.svg) |
| Startup iPhone | [Tham chiếu HL61 dựng lại](../APEX_M1/iphone-startup-truoc.png) | [APEX V2](visual/iphone-06-startup.svg) |
| Split native + hosted | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-split-truoc-2x.png) | [APEX V2](visual/carplay-01-split.svg) |
| Hosted | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-hosted-truoc-2x.png) | [APEX V2](visual/carplay-02-hosted.svg) |
| Picker native | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-picker-native-truoc-2x.png) | [APEX V2](visual/carplay-03-picker-native.svg) |
| Picker hosted | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-picker-hosted-truoc-2x.png) | [APEX V2](visual/carplay-04-picker-hosted.svg) |
| Fullscreen | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-fullscreen-truoc-2x.png) | [APEX V2](visual/carplay-05-fullscreen.svg) |
| Keyboard hosted | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-keyboard-truoc-2x.png) | [APEX V2](visual/carplay-06-keyboard.svg) |
| Home xe | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-home-truoc-2x.png) | [APEX V2](visual/carplay-07-home.svg) |
| Startup xe | [Tham chiếu HL61 dựng lại](../APEX_M1/carplay-startup-truoc-2x.png) | [APEX V2](visual/carplay-08-startup.svg) |
| Viền nhiệt A1 | HL61, chỉ có source | [APEX V2](visual/carplay-09-thermal.svg) |

## Cấu trúc asset

- `assets/duocar-apex-mark.svg` dấu nhận diện D cách điệu theo đường đôi, sáng tác riêng, không dựa logo hãng xe.
- `assets/duocar-apex-home.svg` icon vuông cho app DuoCar, chỉ thay DUOCAR-OWNED tile; Home iOS/CarPlay giữ nguyên.
- `assets/duocar-apex-wordmark.svg` chữ thương hiệu, tham khảo thiết kế.
- `assets/hm_*.svg` glyph vector 24px để Muse chuyển thành UIImage/draw; **giữ nguyên selector/hitbox/tag**. Không thêm asset runtime trước khi duyệt.
- `visual/` gồm mockup đặc tả tình huống; hình không phải mã thực thi.

## Điểm phải duyệt

1. Hệ hình Stealth: logo D hai làn, sắc Graphite/Titanium, cyan dùng làm chỉ báo chọn thay vì viền tất cả card.
2. iPhone điều hướng 5 mục; xác nhận dòng chữ/hierarchy. Tất cả key/action/giá trị cũ không được thay.
3. CarPlay: toolbar nhẹ trong khung gốc 52pt; picker phải giữ nguyên scene dưới, không thêm lớp che; fullscreen một hàng **không nền** góc trên trái, không chắn tương tác.
4. A1: giữ đỏ thật HL61 (gần `#FF0610`) cho viền cảnh báo; `#FF4757` là token đỏ cho nút/thành phần APEX, **không tự thay HL61**.
5. Chấp thuận hình không đồng nghĩa cho phép thay hitbox/windowLevel, nhiệt 37°C, GPS, shim Lề, app third-party hay ký DEB.
