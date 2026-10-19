# OmniCar 1.0.3 — audit nhấn đúp / fullscreen (2026-10-19)

> Phân tích tĩnh, **không phải patch đã build/test**. Tài liệu gốc được phân tích từ DEB do người dùng cung cấp trong phiên ChatGPT. Đã hiệu chỉnh để không đồng nhất nút tròn với bất kỳ callback divider nào chưa có chứng cứ.

## DEB gốc
- Filename: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`
- Package: `com.anlai.omnicar`; version `1.0.3`; `iphoneos-arm64`, rootless.
- Input SHA256: `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`
- Library: `/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib` (Mach-O arm64/arm64e)
- Library SHA256: `f696b518579266cf99cfd46f85cb54931d18e679c793a563ee2fcc9bf8115754`

## Các method tìm được trong ARM64 slice
| Class / method | IMP | Ghi chú |
| --- | --- | --- |
| `SCPCarSplit.dividerDoubleTapped:` | `0x2e6e8` | callback của divider, chưa chứng minh gắn với **nút tròn**. |
| `SCPCarSplit.dividerDoubleTapOn:` | `0x2e73c` | nhánh có hành vi đổi chỗ pane theo phân tích static, chưa xác nhận trên nút tròn. |
| `SCPCarSplit.dividerPanned:` | `0x2d05c` | kéo divider. |
| `SCPCarSplit.dividerPan:state:location:translation:` | `0x2d210` | sửa tỷ lệ chia. |
| `SCPCarSplit.newDividerAt:` | `0x2c4c0` | tạo divider/handle. |
| `SCPCarSplit.toggleZoomForPane:` | `0x251b0` | zoom một pane, **không phải** host fullscreen. |
| `SCPCarSplit.handleDoubleTapped:` | `0x25048` | nhấn đúp khác, phải truy owner/gesture. |
| `SCPCarSplit.zoomedSlot` | `0x4590c` | state per-pane zoom. |

Các class liên quan `SCPCarDividerView`, `SCPCarSplitView`, `SCPCarPane`. Chuỗi `Tip: double-tap a divider to swap the two panes` có trong thư viện, **không chứng minh hành vi người dùng quan sát tại nút tròn**.

## Đính chính theo ảnh và xác nhận từ người dùng

- Mục tiêu chính là **nút tròn trắng có tâm xanh** ở thanh chia, phía dưới ba nút lựa chọn layout; **khác nút ba chấm xanh nằm trên pane**.
- **Nhấn 1 lần chọn ô** — hoạt động thật; phải giữ nguyên.
- **Nhấn đúp hiện chưa có hành vi người dùng quan sát**. Không tự tuyên bố nó đang swap pane.
- Yêu cầu: nhấn đúp lần 1 **fullscreen toàn bộ giao diện OmniCar**, nhấn đúp lần 2 **restore hai pane** đúng vị trí/tỷ lệ và giữ app đang chạy.
- Giữ kéo chia, HUD, picker, chrome và UI khác nguyên trạng. **Không phát hành Sileo**.

## Tại sao không chép nguyên DuoFace

DuoFace sử dụng `CBBridgeManager` / `CBWindow` và `DFHostGeometry.xm`, `DFFullscreenCoordinator.mm`, `DFFullscreenTransport.mm`; OmniCar có lớp host riêng. Dùng DuoFace làm tham khảo state-machine và snapshot/restore nhưng phải nối vào owner/window thật của OmniCar. Phải giữ nút tròn nhận được nhấn đúp lần 2 khi fullscreen.

## Trạng thái và kế hoạch kiểm chứng

- Chưa có mã patched, DEB mới, CI build, chữ ký hay thử nghiệm CarPlay.
- Linux local thiếu Theos/iOS SDK/ldid đầy đủ; dùng workflow macOS GitHub Actions **của repo `chuongnguyen89dn-ui/Omnicar`** để build/đóng gói và kiểm tra.
- Bước gần nhất: truy `newDividerAt:` và hit-testing, recognizer thực của handle tròn; xác minh owner runtime (SpringBoard/CarPlay). Sau đó mới viết hook tối thiểu để fullscreen theo snapshot/restore, test click một lần/kéo/double-tap-in/double-tap-out.
- DEB nguồn hiện ở attachment chat; repo `Omnicar` mới được khởi tạo bàn giao và **chưa có bản sao DEB gốc**.
