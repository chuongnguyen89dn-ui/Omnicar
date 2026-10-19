# OMNICAR — TIẾP TỤC DỰ ÁN / BÀN GIAO

> Khởi tạo ngày **2026-10-19**. Đây là hồ sơ dự án OmniCar **riêng biệt** với DuoFace. Tài liệu là checkpoint phân tích, **không phải bằng chứng đã sửa/build/cài DEB**.

## 1. Repository, thiết bị, bản gốc

- **Repo bàn giao/chính thức:** https://github.com/chuongnguyen89dn-ui/Omnicar — mặc định `main`. Tất cả nguồn, workflow, audit, test, DEB ứng viên về sau phải nằm **tại repo này**, không ở `Gpt-training-`, `Duoface` hay `carplaydsp`.
- **Gói người dùng đưa để phân tích:** `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`.
- **Package ID / version / architecture:** `com.anlai.omnicar` / `1.0.3` / `iphoneos-arm64`, rootless, gói công bố iOS 15–16. Không tự đổi package ID hoặc đè gói đang sử dụng trừ khi người dùng đồng ý.
- **SHA256 DEB nguồn (kiểm tra trực tiếp):** `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.
- **Thành phần cần nghiên cứu:** `/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib` (binary Mach-O arm64/arm64e), SHA256: `f696b518579266cf99cfd46f85cb54931d18e679c793a563ee2fcc9bf8115754`.
- Bản DEB gốc được cung cấp **trong cuộc trò chuyện**, **chưa kiểm chứng đã lưu thành file tại repo này**; phải lưu bản sao đúng checksum vào repo hoặc cơ chế lưu trữ của repo khi xây build.

## 2. Phạm vi yêu cầu đã chốt

Người dùng đã chỉ rõ **nút tròn trắng trên thanh chia màn hình**, nằm bên dưới cụm ba nút chọn bố cục trong ảnh màn CarPlay (khác **nút ba chấm xanh** ở phía trên mỗi ô).

- **Chạm 1 lần vào nút tròn:** hiện là thao tác **chọn ô** — **phải giữ nguyên**.
- **Nhấn đúp lần 1 vào cùng nút tròn:** mở rộng **toàn bộ giao diện OmniCar đang chia ô thành fullscreen**, lấy hành vi host-fullscreen DuoFace từng hoạt động làm chuẩn, **không phải** phóng riêng một pane.
- **Nhấn đúp lần 2 vào cùng nút tròn:** **thu nhỏ về giao diện chia ô**, đúng tỉ lệ, vị trí, ứng dụng đang chạy và trạng thái trước khi phóng to; không reload/đóng apps.
- **Kéo nút / thanh chia:** giữ nguyên khả năng thay đổi tỉ lệ.
- Không sửa UI menu, nút 3 chấm, HUD tốc độ, trình chọn app, popup, Shortcuts, các chế độ bố cục hoặc các chức năng khác.
- **Không đụng Sileo.** Chỉ tạo **DEB thử nghiệm tải ngay trong chat** khi đã thực sự có bản build; bản build/nguồn/test phải lưu tại repo này.

### Đính chính quan trọng

Không được khẳng định **nút tròn hiện nhấn đúp để đổi chỗ ô**. Người dùng khẳng định nút tròn **nhấn 1 lần chọn ô, nhấn đúp hiện chưa gắn tác vụ**. Phân tích static chỉ tìm thấy một callback double-tap **ở divider nói chung** (có liên quan đổi chỗ), **chưa chứng minh callback đó thuộc nút tròn người dùng chỉ**. Cần xác định chính xác view/hit-test/gesture của nút tròn bằng binary và log runtime trước khi hook.

## 3. Tình trạng điều tra DEB (19/10/2026)

Trong `OmniCarSplitScreen.dylib` tìm được tên ObjC và địa chỉ IMP của slice ARM64:

| Class / selector | IMP | Bằng chứng / lưu ý |
| --- | --- | --- |
| `SCPCarSplit.dividerDoubleTapped:` | `0x2e6e8` | Sự kiện nhấn đúp **một divider**; chưa gắn chắc chắn với nút tròn. |
| `SCPCarSplit.dividerDoubleTapOn:` | `0x2e73c` | Luồng divider double-tap hiện có khả năng đổi chỗ các pane. **Không được áp thẳng kết luận này cho nút tròn**. |
| `SCPCarSplit.dividerPanned:` | `0x2d05c` | Kéo divider. |
| `SCPCarSplit.dividerPan:state:location:translation:` | `0x2d210` | Tác vụ đổi tỉ lệ. |
| `SCPCarSplit.newDividerAt:` | `0x2c4c0` | Khởi tạo view divider và tay nắm. |
| `SCPCarSplit.toggleZoomForPane:` | `0x251b0` | **Zoom từng pane**, khác fullscreen toàn host. |
| `SCPCarSplit.handleDoubleTapped:` | `0x25048` | Một recognizer nhấn đúp khác, owner phải truy tiếp. |

Các class có liên quan: `SCPCarDividerView`, `SCPCarSplitView`, `SCPCarPane`. Chỉ có binary, chưa có mã nguồn OmniCar gốc.

## 4. Đối chiếu với DuoFace (chỉ là tham khảo kỹ thuật, KHÔNG nhập package)

Repo tham chiếu: https://github.com/chuongnguyen89dn-ui/Duoface

- `runtime/fullscreen/DFPickerZoomMenu.xm`: nút Zoom gửi `com.duoface.fullscreen.picker.v1`.
- `runtime/fullscreen/DFFullscreenCoordinator.mm`: `DFEnterFullscreen()` và `DFExitFullscreen()`, xác nhận ACK.
- `runtime/fullscreen/DFFullscreenTransport.mm`: yêu cầu `DFRequestHostFullscreen(YES/NO)`, quản lý owner, ACK.
- `runtime/fullscreen/DFHostGeometry.xm`: `DFHostSetExpanded()` chụp geometry và `DFHostRestore()` khôi phục.
- `runtime/fullscreen/DFDashboardChrome.xm`: quản lý chrome riêng với geometry.
- `tiep tuc du an.md` của DuoFace dòng ~2235 ghi **người dùng xác nhận đã phóng fullscreen trên thiết bị** vào 14/10/2026; dòng ~2634 ghi đã chuyển thao tác Zoom vào menu. **Không đồng nghĩa đã test OmniCar**.
- **Kiến trúc không thể chép nguyên:** DuoFace dùng `CBBridgeManager` / `CBWindow` ở SpringBoard; OmniCar dùng `SCPCarSplit` cùng hệ thống pane/host riêng. Cần chuyển thiết kế snapshot → expand → verify → restore, không copy thẳng selector/class và không thay đổi runtime DuoFace.

## 5. Phần chưa thực hiện / chưa xác minh

- Chưa truy hết **gesture và owner thực** của nút tròn trắng (phải tách khỏi tab đổi layout và thanh divider).
- Chưa xác định đầy đủ owner window, Dashboard chrome/dock, frame, snapshot/restore trong OmniCar.
- Chưa có patch dylib/tweak riêng, mã nguồn build, CI workflow hay DEB ứng viên.
- **Chưa biên dịch thành công**, chưa ký binary, chưa cài hoặc thử nghiệm trên xe. Không được gọi bản phân tích này là patch hoạt động.
- Môi trường phân tích Linux có `dpkg-deb`, `clang`, `llvm-objdump` nhưng không có đủ iOS SDK, Theos, iOS linker và `ldid`; dùng **GitHub Actions macOS / Theos / SDK**, xác minh kết quả thực, không chế DEB không hợp lệ.
- Repository OmniCar lúc kiểm tra trước khi tạo hồ sơ này **đang trống**, nên chưa có lịch sử dự án/CI riêng để nối tiếp.

## 6. Bước tiếp theo cụ thể

1. Kiểm tra nguồn DEB bằng SHA256. Truy `newDividerAt:` → `SCPCarDividerView` → vùng chạm của **nút tròn trắng** → recognizer single/pan/double, đọc kỹ hành vi double-tap đã có/đang không kích hoạt; chỉ hook chính view yêu cầu.
2. Truy đối tượng chủ `UIWindow`/scene và vùng usable bounds của OmniCar, vị trí dock/chrome; thiết kế một **snapshot** gồm host frame/insets, pane ratios, focus state, layout và scene ownership. Xây enter/restore bất biến với các thao tác cũ.
3. Đảm bảo **nút tròn còn nhận lần nhấn đúp thứ hai trong fullscreen**; nếu bị che/mất thì phải sửa đường gesture gốc, không thêm nút nổi hay tự đổi UX.
4. Viết patch tối thiểu dạng tweak mới/override có filter an toàn; test static và kiểm tra tính tương thích ABI, packaging/postinst/rollback trên macOS GitHub Actions.
5. Lưu mã, CI logs, checksum, DEB candidate vào **repo OmniCar**, đối chiếu contents với DEB nguồn để chắc chắn các thành phần không liên quan giữ nguyên.
6. Sau **build thành công thực sự**, đưa DEB tải trong chat để người dùng kiểm thử. Checklist: click 1 lần chọn ô; click 2 lần fullscreen; click 2 lần restore; kéo ratio; giữ 2 app chạy; không crash SpringBoard/CarPlay. Có lỗi thì lưu log và tiếp tục sửa đúng chức năng.
7. **Không push/publish bất kỳ gói nào lên Sileo**.

## 7. Kỹ năng & bảo quản chứng cứ

- Repo quy tắc: `chuongnguyen89dn-ui/Gpt-training-`; ZIP liên quan đã xác định ở `skills/01-github-continuity.zip`, `skills/02-ios-deb-ipa-carplay.zip`, `skills/05-research-debug-testing.zip`. Các bản Markdown `PROJECT_INSTRUCTIONS.md`, `AGENTS.md`, `SKILL_INDEX.md`, `DEB_IPA_SKILL.md` đã được đọc. **ZIP chưa được giải nén/đọc đầy đủ ở lần bàn giao này**, không tuyên bố đã đọc nếu chưa thực hiện.
- File phân tích tại môi trường phiên ChatGPT: `OmniCar_1.0.3_doubletap_fullscreen_AUDIT.md`; bản tại workspace chỉ có giá trị tham khảo đến khi thực sự commit/đọc lại ở repo.
- Cập nhật **chính file này**, không tạo nhiều hồ sơ bàn giao trùng, sau mỗi thay đổi đã xác minh về yêu cầu, mã/commit, blocker, workflow, DEB, thiết bị.
