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
- Hồ sơ audit đã lưu và đọc lại tại repo này: `audit/OmniCar_1.0.3_doubletap_fullscreen_20261019.md` (commit `f3278ca9fdca8b9f75df3f70cddee51dc4175daa`). Bản audit ChatGPT ban đầu có một giả định chưa xác nhận về nhấn đúp vào nút tròn; **dùng bản audit đã đính chính trong repo**.
- Cập nhật **chính file này**, không tạo nhiều hồ sơ bàn giao trùng, sau mỗi thay đổi đã xác minh về yêu cầu, mã/commit, blocker, workflow, DEB, thiết bị.


## CHECKPOINT 2026-10-19 — DOUBLE TAP CANDIDATE 0.1.0 ĐÃ BUILD VÀ LƯU REPO (CHƯA TEST MÁY)

- **Phạm vi source thay đổi:** chỉ thêm **addon rootless riêng**, KHÔNG ghi đè \`com.anlai.omnicar\` 1.0.3 và KHÔNG chỉnh DuoFace/Sileo.
- Source \`src/OmniCarDoubleTapFullscreen.xm\` hook \`SCPCarSplit.newDividerAt:\` để gắn \`UITapGestureRecognizer.numberOfTapsRequired=2\` vào divider có **hit area giới hạn ở \`SCPCarDividerView.knob\`**. Dùng \`cancelsTouchesInView=NO\`, simultaneous gestures để không chặn thao tác native chọn ô một lần/kéo ratio; chặn native \`dividerDoubleTapped:\` **chỉ khi vị trí chạm nằm trên knob** (không chặn divider line).
- Fullscreen candidate: khi double-tap, ghi snapshot parent/clip/original area của \`SCPCarSplit\`, hook \`appAreaInParent:\` trả vùng thực \`parent.window.bounds\` đã convert về hệ tọa độ parent, yêu cầu \`relayoutAnimated:NO pushScenes:YES\` và \`rootDidLayout\`. Lần double-tap tiếp theo tắt override, phục hồi clip và relayout scene. **Không dùng \`CBWindow\` của DuoFace**.
- Fix \`e5eecb5\`: đợi class \`SCPCarSplit\` / \`SCPCarDividerView\` được nạp trước khi \`%init\`, tránh load-order patch chạy trước thư viện OmniCar.
- Build Files: \`Makefile\`, \`control\`, \`OmniCarDoubleTapFullscreen.plist\` filter SpringBoard/CarPlayApp; CI \`.github/workflows/build-candidate.yml\` runner macos-15, Theos+SDK, ldid/dpkg. Quy trình **không có push Sileo**.
- Build 1: Actions [39226143864](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39226143864) đã compile/link/sign/package, nhưng job kết thúc **failure** do cú pháp \`lipo -verify_arch arm64 "$DYLIB"\` sai vị trí đối số. Sửa workflow commit \`2d9e7c5bde19ed43eca4bc1b3cb6b95fe77081f2\`.
- **BUILD 2 XÁC MINH SUCCESS:** [Actions 39226363345](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39226363345) — tất cả steps setup, static guards, compile, link, signing, packaging, upload artifact và lưu vào GitHub **SUCCESS**; source ref \`2d9e7c5\`.
- **Artifact repo:** \`dist/candidates/doubletapfullscreen-0.1.0/com.anlai.omnicar.doubletapfullscreen_0.1.0_iphoneos-arm64.deb\`, size **7702 bytes**, SHA256 **\`32da987a58595d2f40638b22d0b621fb1bea584d43bd0b88ee9b7d3188f92244\`**. \`SHA256SUMS.txt\`, \`package-contents.txt\`, \`STATUS.txt\` lưu cạnh DEB.
- **Kiểm tra độc lập từ artifact Actions:** zip test PASS; DEB SHA trùng báo cáo, \`dpkg-deb --field\` xác nhận Package \`com.anlai.omnicar.doubletapfullscreen\`, version \`0.1.0\`, depends \`com.anlai.omnicar >= 1.0.3\`; nội dung chỉ 1 dylib 70240 bytes + 1 plist 118 bytes dưới \`/var/jb/Library/MobileSubstrate/DynamicLibraries\`. Original OmniCar và Sileo không chỉnh sửa.
- **TRẠNG THÁI THỰC TẾ:** COMPILE/PACKAGE/REPOSITORY PASS; **ON-DEVICE TEST CHƯA CÓ**. Không tuyên bố fullscreen đã thực sự lấy toàn bộ CarPlay chrome/dock hoặc rằng nút tròn chắc chắn tiếp nhận double-tap cho đến khi user test trên xe. Native engine có thể bố trí lại chỉ trong viewport, không che dock. Nếu không phóng, dùng log \`[OmniCarDT]\` và ảnh để tìm đúng host owner; không thay code khác.
- **TEST CẦN USER:** giữ OmniCar gốc 1.0.3, cài addon DEB 0.1.0 (không cần thêm nguồn Sileo), respring khi cần, kết nối xe lúc **đỗ**; kiểm tra một lần chọn ô, kéo ratio, double lần 1 phóng full cả giao diện, double lần 2 trả đúng split, hai app không reload; ghi ảnh/log nếu có lỗi. Gỡ **chỉ addon** nếu gặp xung đột/khởi động lại; không gỡ OmniCar gốc.
- **Không có yêu cầu phát hành Sileo:** tuyệt đối không làm tiếp bước deploy khi chưa có lệnh.


## CHECKPOINT 2026-10-19 — YÊU CẦU UI MỚI THAY CHO NHẤN ĐÚP (CHƯA DUYỆT DEMO)

- Người dùng chỉ rõ nút tròn trắng tại vạch chia: **nhấn một lần mở thanh 3 ô chọn bố cục ở phía trên**, ảnh CarPlay đã gửi. Người dùng nghi ngờ có thao tác đổi ô qua lại; cần giữ nguyên callback gốc, không áp lệnh mới vào double-tap khi chưa xác minh.
- **Yêu cầu UI mới ưu tiên:** giữ nguyên 3 ô chọn bố cục ở hàng trên; **thêm đúng 1 ô/nút Zoom ở hàng phía dưới**, dùng kiểu nút, kích thước, màu, hình dạng đồng bộ với thanh lựa chọn gốc. Kích hoạt cùng menu bởi chạm một lần vào nút tròn; bấm Zoom lần 1 fullscreen toàn host, lần 2 restore split. Không sửa tính năng cũ (chọn bố cục, chạm nút tròn, kéo divider, swap, HUD, app).
- Người dùng yêu cầu **demo hình để duyệt TRƯỚC KHI viết/sửa code/DEB**. Đã tạo demo so sánh trái/phải trong cuộc trò chuyện từ ảnh người dùng; đây là **mockup ảnh, không phải giao diện runtime hoặc DEB đã sửa**. Hình minh họa bên phải có 3 ô gốc + nút fullscreen ở hàng dưới và nút tròn ngay bên dưới. Chưa được người dùng chấp thuận.
- **Lưu ý phần đã thay đổi trước yêu cầu mới:** source `src/OmniCarDoubleTapFullscreen.xm` commit `d4f2cbe19096e9328e31e71f3cf50a576c42e1d7` đã điều chỉnh callback native doubletap, nhưng **chưa có DEB build được xác minh cho commit đó**; không sử dụng nó làm bản final mới, và không tự kích hoạt release/Sileo. DEB addon 0.1.0 trước đó build PASS nhưng user thử không phản hồi.
- **Bước tiếp theo:** chờ người dùng duyệt/chỉnh mockup; sau đó khảo sát kỹ nút/menu native (không phỏng đoán lớp), đưa nút Zoom vào menu ở đúng vị trí, giữ nguyên callback gốc, build và kiểm chứng. Không đụng Sileo.


## CHECKPOINT 2026-10-19 — ĐÃ DUYỆT ICON ZOOM BÊN DƯỚI NÚT TRÒN; SOURCE/CI 0.3.0

- **Yêu cầu được duyệt và thay yêu cầu nhấn đúp cũ:** một lần chạm nút tròn vẫn hiển thị ba lựa chọn bố cục phía **TRÊN**; thêm một nút/icon Zoom **RIÊNG PHÍA DƯỚI nút tròn**, căn giữa đúng trục giữa ba lựa chọn, màu xanh nhạt/trắng và kiểu bo tròn tương đồng native. Mục đích chạm mới Zoom In/Zoom Out toàn giao diện; không sửa callback ba nút gốc, chọn ô, kéo/tỷ lệ, đổi ô, HUD hoặc các app. User đã xem demo thứ hai và nói **"Ok. Làm vậy đi"**. Không dùng double-tap nữa. Không Sileo.
- **Mã đã ghi** commit `1888edd9e47f120620eed71013135e9a8e0d60e0`: `src/OmniCarDoubleTapFullscreen.xm` nay chỉ hook `SCPCarSplit.showRatioMenuForDivider:` để tạo 1 UIButton bên dưới `ratioKnob`, đồng bộ chiều cao/kiểu từ `ratioMenu` thật; hook `hideRatioMenu` để xoá button; **đã bỏ override `dividerDoubleTapped:`, `newDividerAt:`, không add gesture mới**. Action Zoom bật/tắt host geometry bằng `appAreaInParent:`/relayout như ứng viên trước. Log `[OmniCarZoom] event=... ` để xác định runtime.
- **Đã đổi nhãn/version 0.3.0**: `control` commit `6f6cd13f`, `README.md` commit `b043aabb`; workflow `.github/workflows/build-candidate.yml` commit `b6e160a347ee832f1d18509a24c54aa20a78d45b` dùng static guards mới, expected version `0.3.0`, artifact riêng `dist/candidates/menuzoom-0.3.0/`, không ghi đè 0.1/0.2 và không phát hành Sileo.
- **CI hiện tại:** run [39230106125](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39230106125) vừa queued khi kiểm tra; **chưa có kết luận build/DEB/ảnh thực**. Các run ngay trước đó theo source mới nhưng workflow cũ expected native-doubletap (ví dụ `39229930310`) có thể fail static guard cũ; không dùng làm đánh giá chức năng.
- **Bước tiếp ngay:** xác minh trạng thái/job/log run 39230106125, sửa đúng lỗi compile/packaging nếu fail, đọc lại artifact GitHub và SHA256; **chỉ giao candidate 0.3.0 khi build thật success**. Khi cài xe thật, kiểm menu giữ đúng 3 ô, Zoom nằm dưới circle, nhấn Zoom phóng/thu có thay đổi thật; nếu không có phản hồi, lấy `[OmniCarZoom]` log và khảo sát owner/hit-test native, không đoán.
- **Ràng buộc:** mã mới compile thành công (nếu có) vẫn chưa chứng minh zoom toàn bộ CarPlay hoặc nút hoạt động. Không tự tuyên bố device PASS. Chỉ thực hiện trong repo này.


## CHECKPOINT 2026-10-19 — MENU ZOOM 0.3.0 CI/DEB VERIFIED (CHỜ TEST XE)

- **Mục tiêu duyệt:** chạm 1 lần nút tròn gốc hiển thị 3 lựa chọn ở phía TRÊN; thêm **một icon fullscreen tròn ở phía DƯỚI nút tròn**, giữ tất cả chọn bố cục/drag/tap native; icon chạm 1 lần expand, chạm lại restore. Không dùng double tap.
- **Nguồn cuối thực thi:** `src/OmniCarDoubleTapFullscreen.xm` commit `197a50ae109437ffb95df3c79eb2ef38ea3b9892`. `showRatioMenuForDivider:` %orig → `OMCShowButton` sibling `ratioMenu`; vị trí theo `ratioKnob` thực và chiều cao native menu, màu lam nhạt/nền trắng trong; `hideRatioMenu` remove button. `OMCToggleHost` cố gắng override `appAreaInParent:` và native relayout để expand/restore; không đụng gesture/callback divider. Trạng thái `expanded` gắn owner, cần device validation.
- **Build đầu (source old 1888edd)** run `39230106125` FAILED compile do UIKit SDK18.5 `UIButton.adjustsImageWhenHighlighted` deprecated + `-Werror`; đã xóa chính 1 dòng đó commit `197a50ae` (không thay hành vi).
- **Build xác minh SUCCESS:** [GitHub Actions run 39230367305](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39230367305), source `197a50ae`. Setup macOS-15, static guard no double-tap, compile/link/sign/package, artifact upload, push candidate `dist/` đều SUCCESS.
- **DEB candidate** `dist/candidates/menuzoom-0.3.0/com.anlai.omnicar.doubletapfullscreen_0.3.0_iphoneos-arm64.deb`: **8574 bytes**, SHA256 **`d37acbee0a5d10c79f84a8b4220542f93985f0d9f7771ded4da722c63f030c79`**, artifact ID `12176548705`. Đã tải ZIP artifact về container, zip `testzip() == None`; hash SHA256 khớp `SHA256SUMS.txt`, đọc `dpkg-deb --field` xác nhận package `com.anlai.omnicar.doubletapfullscreen`, `Version: 0.3.0`, dependency OmniCar 1.0.3, arm64 rootless; `dpkg-deb --contents` chỉ có tweak .dylib **70704 bytes** và plist **118 bytes**.
- **Delivery:** file đúng được xác minh cục bộ `/mnt/data/com.anlai.omnicar.doubletapfullscreen_0.3.0_iphoneos-arm64.deb`; repo main cũng lưu đầy đủ binary+checksum. **NO SILEO CHANGES.**
- **CẤP ĐỘ XÁC NHẬN:** code, CI, package, checksum và GitHub persistence PASS; **chưa có kết quả ảnh/log runtime CarPlay**, không được gọi UI/Zoom device PASS. Style chỉ lấy theo kích thước/border/background native menu + fallback xanh trắng; chưa thể bảo đảm 100% tương đồng pixel hoặc fullscreen thực khi chưa test.
- **Next:** user thử tại xe khi đỗ: (1) giữ ba lựa chọn layout gốc, (2) chạm circle hiển thị thêm icon bên dưới, (3) bấm Zoom phóng toàn host, (4) bấm lần hai thu nhỏ giữ đúng tỷ lệ và hai app; (5) đảm bảo kéo ratio/hoán đổi/điều khiển HUD vẫn hoạt động. Nếu không thấy nút mới: lấy runtime log `[OmniCarZoom] event=hook-installed|menu-unavailable|knob-unavailable|button-installed`; nếu thấy nút nhưng không zoom: `zoom-button-pressed|expand-request|restore-request` và ảnh. Sửa đúng blocker rồi build số khác, không lặp lại double-tap và không Sileo.


## 2026-10-19 — Ảnh thiết bị: Zoom 0.3.0 sai vị trí, dock chưa ẩn; ứng viên 0.4.0

- Người dùng gửi `IMG_7962.jpeg`. Quan sát ảnh ngang: nút Zoom tròn nằm trên bản đồ phía trái, cách xa vòng tròn trên vạch chia; dock CarPlay có đồng hồ/GOFA/Nhạc/Phone còn hiện. **0.3.0 DEVICE FAIL** về vị trí và fullscreen. Không được đánh đồng UI đã vẽ và fullscreen thành công.
- Tra toàn bộ lịch sử liên quan trong `Duoface/tiep tuc du an.md` và đọc mã `DFHostGeometry.xm`, `DFDashboardChrome.xm`. Fullscreen DuoFace cần hai xử lý độc lập: host geometry và ẩn/khôi phục window chrome `DBStatusBarWindow` hoặc `CARStatusBarWindow`. Mã OmniCar 0.3.0 mới điều chỉnh app area, **thiếu chrome**.
- Nguyên nhân vị trí: dùng `SCPCarSplit.ratioKnob` làm neo, nhưng ảnh thực chứng minh không phải nút tròn dưới thanh 3 ô. Commit `02b3073` neo Zoom theo tâm menu 3 ô, ưu tiên nút thật `SCPCarDividerView.knob` khi xác minh đúng trục, đặt icon dưới nút tròn; đổi nền từ màu đặc sang gradient trắng/tím nhạt–xanh giống menu.
- Thêm `src/OmniCarChrome.xm` commit `737592e` để theo dõi và ẩn/khôi phục trạng thái `DBStatusBarWindow/CARStatusBarWindow`; chuyển tín hiệu giữa CarPlayApp/SpringBoard bằng `NSDistributedNotificationCenter`. `src/OmniCarDoubleTapFullscreen.xm` commit `671ffc1` nối lệnh hide khi Zoom In và restore khi Zoom Out hoặc split hết active. Không sửa nút/layout gốc, không thay đổi Sileo.
- Đã cập nhật `Makefile` (`be90036`), `control` (`684251b`), workflow `.github/workflows/build-candidate.yml` (`dc83f4d`) sang ứng viên **0.4.0**.
- **CI VERIFIED SUCCESS:** [GitHub Actions run 39233237787](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39233237787) từ commit `dc83f4d`, mọi bước static/compile/link/sign/package/upload/repo archive thành công. Repo artifact `dist/candidates/menuzoom-0.4.0/com.anlai.omnicar.doubletapfullscreen_0.4.0_iphoneos-arm64.deb`, 11,868 bytes, SHA256 `e9fea6ebf3d3dec4896be65d4819db1db7c5f0f0efca15763d690d73804c8eb5`; artifact ID `12177063145`. ZIP tải về và `ZipFile.testzip()==None`, dpkg-deb control/contents đã đọc, chứa đúng rootless .dylib và .plist. Không có bước Sileo.
- **Trạng thái:** source fix, CI và DEB PASS; **thiết bị 0.4.0 CHƯA TEST**, chưa có bằng chứng ẩn được dock hay vị trí icon chính xác mọi kích thước. Các log cần xem `[OmniCarZoom]` (anchor-check, button-installed, expand/restore) và `[OmniCarZoomChrome]` (chrome-hook-installed, sent, hide, restore hoặc FAILED). Tránh báo đã fix CarPlay khi chỉ CI xanh.
- **Bước tiếp theo:** giao DEB 0.4.0 cho chủ dự án thử trên máy đỗ xe; xác nhận 3 lựa chọn native giữ nguyên, nút mới dưới vòng tròn, ẩn dock khi Zoom In và phục hồi dock/trạng thái hai app/tỷ lệ khi Zoom Out. Nếu thất bại cần log owner/window trước khi tiếp tục sửa; không tái dùng `ratioKnob` để neo. Không cập nhật Sileo.


## 2026-10-19 — DEVICE PHOTO: 0.4.0 DOES NOT SHOW ZOOM BUTTON; CANDIDATE 0.5.0

- User provided `IMG_6361F045-19D3-477E-883F-8A48D18634D8.jpeg`. On the CarPlay screen, the native three-choice menu and central round handle are visible, but **NO additional Zoom control beneath the circle**. The adjacent iPhone Sileo install list visibly lists OmniCar Menu Zoom and Chrome 0.4.0. This is **USER-OBSERVED 0.4.0 VISIBILITY FAIL**, not a device PASS. No input indicating a successful/fullscreen action was captured. Original three controls still visible.
- Static source review identified **two plausible 0.4.0 blockers**, NOT yet proven as the sole runtime cause: (1) `OMCShowButton` added the button to `menu.superview` (clipped pane) and returned when below-panel frame exceeded that view's bounds; (2) `OMCAreaValid(menuRect)` wrongly required a compact native control to exceed **50 pt height**, which can reject a valid original menu. Either could prevent drawing the icon. Fix 0.5.0 changes parent coordinates to `menu.window`, converts menu and candidate circle to common UIWindow coordinates, validates compact menu with finite positive bounds, keeps required BELOW position, logs `outside-window` if truly off-screen. Touch actions of native menu/knob/drag remain unmodified.
- **Commits:** source `7869a5743c5f90aac60be58e560bdca4437c2613` (window coordinate) and `ae83ae2475bdbecd9b0979d31bdf16f92f869ea2` (compact geometry). Added source checks and pure geometry regression test `scripts/test_menuzoom_geometry.py`. New candidate version **0.5.0**, separate target `dist/candidates/menuzoom-0.5.0`, no overwrite of previous DEBs, no Sileo publication.
- **Next:** check Actions build for new candidate, verify package and checksum. Real device follow-up must check *presence* and placement BELOW the white-blue circle before attempting fullscreen. If still missing, collect existing `[OmniCarZoom] event=hook-installed|anchor-check|invalid-menu-geometry|outside-window|button-installed` logs; must not guess another placement without runtime geometry. Fullscreen dock hiding and restore are still UNVERIFIED.

### VERIFIED RESULT 2026-10-19 — Candidate 0.5.0 BUILD PASS, device pending
- [Actions run 39235038598](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39235038598), head `9d7be0bb30a1aa887eabe947ae37d3ad2af9c794`: **SUCCESS** (geometry regression test; Theos setup; static guards; ARM64 compile/link/sign; rootless package; artifact upload; GitHub candidate persistence).
- Artifact ID `12179155410`; repo: `dist/candidates/menuzoom-0.5.0/com.anlai.omnicar.doubletapfullscreen_0.5.0_iphoneos-arm64.deb`, size **11,970 bytes**, SHA256 **`b990b60079b90e91a25f763aef078479b1c5e0e728a2d142e5d2fe54333d6bb2`**. ZIP artifact fetched into runtime, `unzip -t` PASS; `sha256sum -c SHA256SUMS.txt` PASS; `dpkg-deb -f` checked package/version/arm64/dependency, `dpkg-deb -c` shows only `OmniCarDoubleTapFullscreen.dylib` 88,736 bytes + `OmniCarDoubleTapFullscreen.plist` 118 bytes. Verified copy in this chat at `/mnt/data/com.anlai.omnicar.doubletapfullscreen_0.5.0_iphoneos-arm64.deb`.
- **DEVICE STATUS:** 0.4.0 was reported NOT showing Zoom; 0.5.0 not yet tested. The revised UI positioning is a source-grounded fix for two plausible early returns, not proof its button is visible. The chrome/dock fullscreen behavior remains unverified. If still invisible, inspect `[OmniCarZoom]` logs for `hook-installed`, `menu-unavailable`, `anchor-check`, `invalid-menu-geometry`, `outside-window`, `button-installed`. Do not change other features or publish to Sileo.

## CHECKPOINT 2026-10-19 — 0.5.0 ZOOM WORKS, STYLE PENDING; YOUTUBE APP BRIDGE AUDIT

- User report: photo IMG_D38958F4-B01F-4FF6-AEF1-2B712E23C49E.jpeg and confirmation 'Đc rồi hoạt động rồi' after addon 0.5.0. The extra Zoom button is now visible below the original circular trigger; user confirms it works. We have not independently validated full Chrome hide/restore geometry from device logs.
- UI unfinished: new button is disproportionately large, symbol low contrast compared with native pale violet/cyan 3-choice selector; user requests matching diameter, color and icon. Preserve working action; ONLY visual polish pending, not performed in this turn.
- New request: review original OmniCar 1.0.3 DEB to diagnose oversized iPhone YouTube UI in split CarPlay. Static analysis saved at audit/OmniCar_YouTube_AppBridge_scaling_20261019.md, commit 0c6097ebfd6131d293df94aac35a9b46238491d8; file readback verified.
- Evidence: original DEB SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd; AppBridge (injected in UIKit) owns iPhone scene orientation/frame and preference appBridgeZoom. ABHost zoom IMP arm64 0xae20 converts percent and clamps 0.6..1.0; setFrame:forApp:live:handle:passInsets: at 0xfe68; hook SBSceneView -_updateReferenceSize:andOrientation:. SplitScreen sends hostFrameInfo:pane:live:handle: and appbridge.frame per pane. No explicit YouTube-specific resize found in strings, no evidence addon 0.5 edits YouTube app UI.
- Assessment: likely App Bridge fixed scene zoom/referenceSize/size-class mismatch with phone-only YouTube adaptive UI. Exact phone preference and runtime sceneBox/frame/orientation unknown. Do NOT assert YouTube application itself is defective or permanently changed; no runtime proof of sole cause. No blanket scale change to other apps.
- Follow-up if user authorizes repair: compare YouTube UI on iPhone, CarPlay full width, CarPlay split; capture bundle ID, appBridgeZoom, appBridgeOrientation, sceneBox, frame/scene reference size and safe area; implement targeted fix, preserve original app and working Zoom. Style polish of added control remains separate. NO Sileo changes.
- Current turn changed only documentation; no executable source, CI, DEB, nor user device modified.

## CHECKPOINT 2026-10-19 — NORMAL SPLIT AND FULLSCREEN AUTO-HIDE CLARIFICATION

- User corrected idle-visibility requirement: **BOTH normal split mode AND fullscreen** must automatically hide the tiny three-dot per-pane bars and relevant two-squares mode-switch control after **3 seconds of no interaction**; also account for CarPlay dock where appropriate. Touch anywhere reveals them temporarily. Must preserve tap to reveal and exit fullscreen, original pane controls, native split gestures and the now-working Zoom 0.5.0 action. This supersedes the previous fullscreen-only interpretation.
- **Original DEB inspected** `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` (SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`) and ARM64 disassembly of `OmniCarSplitScreen.dylib`. Complete static evidence, class method addresses, commands and caveats: [`audit/OmniCar_native_controls_idle_visibility_20261019.md`](audit/OmniCar_native_controls_idle_visibility_20261019.md), commit `d23a4241ab987da8217052d369e9b4193e311b38`.
- **VERIFIED EXISTING:** `SCPCarSplit.setBarVisible:forPane:` arm64 `0x241fc` restarts `barTimer` using `scheduledTimerWithTimeInterval:repeats:block:` passing **4.0 s** at `0x24424/0x24434`; block at `0x24bac` calls `setBarVisible:NO` at `0x24bf8`. `hideBarsForTouchOn:` `0x25558` also hides pane bars on touch/gesture. This applies to the normal split manager, not only fullscreen.
- **NOT VERIFIED / NO UNIFIED 3s MODE:** the two-squares launcher is managed by `refreshHomeButton`/`homeButtonTapped`/`removeHomeButton` with no equivalent 3s timer found. `restartTrayTimer` is another independent 4.0s timer for the app tray, not the requested buttons. The CarPlay dock/status chrome is separate and the current addon `OmniCarChrome.xm` handles explicit Zoom hide/restore only, not idle auto-hide. Photos show visible controls but do not establish timing after 3 seconds untouched.
- **CONCLUSION:** per-pane native bar auto-hide exists at **4 seconds**, **not** a unified 3-second hide of bars + two-squares launcher + dock in both layouts. Need preserve native route; add 3s coordinator only after mapping real owner and restoration paths, so fullscreen cannot become stuck without a visible exit button.
- **NO EXECUTABLE CHANGE IN THIS CHECKPOINT:** source / DEB / CI / Sileo / user device untouched. Previous active addon `com.anlai.omnicar.doubletapfullscreen 0.5.0` remains latest. Next task if user requests implementation: isolate native pane/launcher/dock views by selector, reuse bar visibility, reset inactivity timer on actual screen touches, safely reveal on first touch, run CI candidate independently and test parked on the head unit.

## 2026-10-19 — Clarify never-hiding three-dot handles: likely baseline, not addon regression

- User states: in both ordinary split and fullscreen, three-dot pills/control buttons NEVER visibly auto-hide; asks whether caused by our independent Zoom 0.5.0 addon.
- Static distinction verified: original `SCPCarPane.handle` is separate from `SCPCarPane.bar`. Previously reported `setBarVisible:forPane:` 4-second `barTimer` automatically hides EXPANDED `bar`, NOT necessarily the small always-visible three-dot `handle`. Do not assert that 4-second timer should remove dots on-screen. Corrected audit at `audit/OmniCar_native_controls_idle_visibility_20261019.md` commit `9a6a265608efd6a434c5d94522ac24679df1844b`.
- Reviewed addon `src/OmniCarDoubleTapFullscreen.xm` 0.5.0: hooks `showRatioMenuForDivider:`, `hideRatioMenu`, `setActive:`, `appAreaInParent:` ONLY, no `barTimer`, `setBarVisible`, `handleTapped`, `refreshHomeButton`, `homeButtonTapped`, `hideBarsForTouchOn` overrides. Thus not a direct timer or three-dot visibility interception. App-wide overlay may affect touches/layout indirectly, cannot rule out without on-device A/B.
- `src/OmniCarChrome.xm` modifies statusbar window visibility during explicit Zoom enter/restore but does not implement 3s idle timer; dock behavior may still be affected by addon on Zoom transition.
- Best-supported judgment: permanent native small three-dot handles and two-square button are likely OEM behavior in DEB 1.0.3, not addon damage. Need baseline A/B: user when parked can temporarily remove **ONLY** addon `com.anlai.omnicar.doubletapfullscreen` and leave base `com.anlai.omnicar`, wait 6-8s with no touch, inspect controls; restore addon 0.5.0 to compare. Do not claim A/B occurred.
- User's desired new function: 3-second unified idle hide/reveal for persistent handles and launcher in BOTH split and fullscreen; implement only after runtime owner and touch-reveal paths are mapped. Do NOT simply reduce native expanded bar timer 4→3, as that does not hide persistent handles. No executable code, DEB, CI or Sileo changes in this checkpoint.

## 2026-10-19 — A/B CONFIRMED: addon removed, tiny handles still never hide; exact native timer map

- User performed the earlier suggested A/B and confirms: even after uninstalling the Zoom addon, OmniCar's tiny three-dot buttons / fullscreen two-square control **do not auto-hide**. This is now **observed baseline behavior of original OmniCar**, no longer just a static inference about the addon.
- Rechecked original user's 1.0.3 DEB ARM64 Mach-O; exact 4s timers: `barTimer` callback scheduled in `setBarVisible:forPane:` at 0x24434, `fmov d0,#4.0` at 0x24424; `ratioTimer` in `showRatioMenuForDivider:` at 0x2ff88, 4.0 at 0x2ff78; `trayTimer` in `restartTrayTimer` at 0x3bcb4, 4.0 at 0x3bca4. The expanded per-pane BAR, layout ratio MENU and app TRAY are the timer targets, **not the persistent three-dot `handle` or `homeButton` two-squares control**. No direct timer setup in `setupBarForPane:`, `layoutBarForPane:` or `refreshHomeButton` method address ranges. CarPlay dock is separate.
- Full report and disassembly reproduction: `audit/OmniCar_native_controls_idle_visibility_20261019.md`, updated audit commit `0e2870623e7f5a5932b969f15351ef2aecc2e9ef`. Timer audit is complete **STATIC PASS**; user A/B baseline **device observation PASS**; there is **no working 3-second unified inactivity feature** yet.
- User wants 3s hide **in normal split AND fullscreen**, tap-to-reveal and no original function loss. Next: implement NEW 3s inactivity coordinator for persistent `SCPCarPane.handle` and `SCPCarSplit.homeButton` with safe touch-to-reveal, and separately handle CarPlay native dock through its status owner. Do NOT merely change existing 4s bar timer. Preserve working Zoom 0.5.0, native app scene/ratio, and no Sileo.
- This turn changed **only audit/handoff Markdown** in Omnicar repo. No source, packaging, workflow, build, DEB, device action, or Sileo publication.


## 2026-10-19 — CRITICAL: fullscreen exit lock-out after native pane zoom → menu → float → zoom

- New user photos (4 steps) uploaded as \`IMG_CB068A68-F9A8-42C5-BAE4-B06E114F96B8.jpeg\`, \`IMG_AA07BECB-075D-4FC3-BA67-D30775394A46.jpeg\`, \`IMG_97BFC89A-A372-4F94-BEE5-EAB066F63FCF.jpeg\`, \`IMG_DA7457FA-2F98-4B30-8759-C24C2390A5A8.jpeg\`; 17:50–17:51 in screenshots. User reports: zoom one pane, open control menu, move to floating/small window, then zoom again; original three-dot menu handle disappears. If CarPlay dock has already been hidden by fullscreen, user has **no way back**. **DEVICE-OBSERVED BUG**; whether native baseline or addon caused transition is NOT isolated.
- Original \`OmniCarSplitScreen.dylib\` arm64 ObjC introspection confirms separate states/paths: \`toggleZoomForPane:\` IMP \`0x251b0\`, \`setZoomedSlot:\` \`0x45914\`, \`panePopOut:\` \`0x201f0\`, \`closeFloat:\` \`0x1fb1c\` (BOOL arg), \`setFloatPane:\` \`0x45d34\`, \`endHostedSolo\` \`0x3fe5c\`, \`setSoloHostedBundle:\` \`0x45bbc\`, \`rootDidLayout\` \`0x15984\`, \`refreshHomeButton\` \`0x41be4\`, and \`homeButtonTapped\` \`0x43514\`.
- Addon 0.5.0 \`OMCHideButton\` removes ONLY its own Zoom control when ratio menu disappears; Chrome restored only by addon's explicit Zoom Out or when split becomes inactive. This is an insufficient safety invariant when NATIVE pane zoom/float/solo transition eliminates the original menu. Do not conflate overlay control with native pane menu.
- **Implemented source-only candidate 0.6.0** \`src/OmniCarDoubleTapFullscreen.xm\` commits \`ffca1f42e5f2e90cfcc885d4a00be44fe03445ed\` and \`81b4662a5d0c263f2530653b54110e2c7f6a5874\`: \`OMCRescueAction\`, \`OMCRefreshRescue\`, \`OMCScheduleRescue\` add a small direct-\`UIWindow\` emergency return button when addon expanded OR native \`zoomedSlot\` / \`floatPane\` / \`soloHostedBundle\` set OR native pane handles all unavailable. Hooks \`rootDidLayout\`, \`toggleZoomForPane:\`, \`panePopOut:\`, setters \`setZoomedSlot:\` / \`setFloatPane:\` / \`setSoloHostedBundle:\` to refresh only; original logic preserved with \`%orig\`. Recovery tries native transitions via \`toggleZoomForPane:\`, \`closeFloat:NO\`, \`endHostedSolo\`, and ALWAYS invokes \`OMCChromeSetHidden(NO)\` in \`@finally\`. UI intentionally remains accessible while special mode active; no 3-second hiding of last exit. No Sileo.
- **Warning:** This patch has not been tested on device, and only build/runtime testing can establish its safety on actual CarPlay. Do not declare the missing native three-dot handle itself fixed; the current patch provides an INDEPENDENT route out. If native recovery leaves the view in another layout, Chrome is requested visible and safety button remains until host state clears.
- NEXT: run exact macOS CI, inspect compiler warning/errors, save candidate 0.6.0 DEB & SHA to repo and chat, then user parked-device test the 4-step sequence including repeat exit and dock restoration. Do not implement idle 3s timer at same time; separate test/fix later.

### BUILD VERIFIED — standalone fullscreen escape safety 0.6.0 (2026-10-19)

- CI success: [GitHub Actions 39241642473](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39241642473), source commit `172492cf3bc6ca979ff794bf340d35e48558a037`. Tested `scripts/test_menuzoom_geometry.py` plus `scripts/test_fullscreen_escape_safety.py`; Theos/SDK setup, static guards, ARM64 compile/link/sign, rootless package, artifact upload, repo persist all **SUCCESS**.
- Artifact ID `12181177895`, repo path `dist/candidates/menuzoom-0.6.0/com.anlai.omnicar.doubletapfullscreen_0.6.0_iphoneos-arm64.deb`, file size 14992 bytes, SHA256 `e2330b8c57dd009593dbe444aa5213a4f0711b17beade8520aea8476797f77a9`. Downloaded Actions ZIP, `zipfile.testzip()==None`, extracted DEB and checked local sha256sum PASS. Verified `dpkg-deb -f`: package `com.anlai.omnicar.doubletapfullscreen`, version 0.6.0, arm64 rootless dependency `com.anlai.omnicar >=1.0.3`; `dpkg-deb -c` includes only `OmniCarDoubleTapFullscreen.dylib` 89632 bytes + injection filter plist 118 bytes. Local verified download path `/mnt/data/com.anlai.omnicar.doubletapfullscreen_0.6.0_iphoneos-arm64.deb`.
- **CAUTION:** CI/packaging test SUCCESS, real-CarPlay escape sequence **NOT TESTED**. 0.6.0 adds independent rescue control visible during native zoom/float/solo or absent native handles; pressing calls native zoom exit/closeFloat/endHostedSolo as appropriate and requests dock restore in finally. This is an **anti-lockout workaround**, not a proven fix for why the native three-dot handle disappears. Do not claim full resolution before user tests the four-photo sequence.
- Native addon baseline 0.5.0 previously user-reported Zoom working and visually oversized; 0.6.0 preserves native menu Zoom and changes only escape safety, not 3s idle timer, color/size polish or YouTube scaling. Sileo has not been updated. If user sees a crash, advise removal ONLY of addon and restoration of 0.5.0 test candidate; base OmniCar 1.0.3 untouched.
- Required parked-device QA: reproduce map full → native pane menu → floating pane → full map again; verify the new small return icon remains accessible after native dots disappear, the dock restores on press, split returns with correct apps/layout, and no SpringBoard crash. Record `[OmniCarRescue] event=available/pressed/emergency-dock-restore-requested` log plus screenshot if not.


## 2026-10-19 — USER DIRECTIVE SUPERSEDES 0.6 RESCUE: RESTORE 0.5 + ZOOM STYLE

- User requested Zoom UI polish, then explicitly corrected scope: **"Quay về bản 0.5 ko cần nút cứu."** This overrides the earlier 0.6 emergency exit proposal. **Do not keep the rescue button or any native pane zoom/float/solo hooks from 0.6.**
- Restore source `src/OmniCarDoubleTapFullscreen.xm` exactly from working 0.5 source commit `9d7be0bb30a1aa887eabe947ae37d3ad2af9c794` as starting point. Retain `OMCToggleHost`, menu hooks, `appAreaInParent:`, and existing `src/OmniCarChrome.xm`. Style changes only: visual diameter 29–36pt vs old 46–62pt, transparent 44pt hit area, lilac/cyan fill + white rim and drawn dark-blue arrow glyph. No rescue button, no 3s auto-hide or YouTube adjustments.
- Package candidate **0.7.0**, higher than installed 0.6 to permit direct upgrade; still `com.anlai.omnicar.doubletapfullscreen`, original OmniCar base untouched. Updated `control`, CI, `scripts/test_zoom_style.py`, README. No Sileo.
- Known consequence: the reported missing native three-dot menu / fullscreen lock-out can recur because the user explicitly declined separate rescue UI. Do not say issue fixed by this style release.
- Next: GitHub Actions actual build and SHA, archive standalone candidate; verify source has no `OMCRescueAction`; hand off DEB for parked-device visual confirmation.


### 2026-10-19 — 0.7.0 RESTORE-0.5 BASE / ZOOM STYLE DEB BUILD VERIFIED

- Source commit `8b047d25a55877b7e75a4bb6e2e21736f729ad26` restores `src/OmniCarDoubleTapFullscreen.xm` from 0.5 source `9d7be0b` and applies **only** compact native-like Zoom styling. **No 0.6 rescue button or rescue hooks**, verified readback. Package ID preserved to upgrade directly over 0.6, number 0.7.0 only to permit package-manager upgrade.
- GitHub Actions [run #39247315596](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39247315596) SUCCESS all steps: static style/no-rescue gate; Theos, SDK, ARM64 compile, signing, DEB packaging, artifact and repo archival.
- Artifact ID `12183937471`; `dist/candidates/menuzoom-0.7.0/com.anlai.omnicar.doubletapfullscreen_0.7.0_iphoneos-arm64.deb` size **12320 bytes**, SHA256 **`352687f66d18685e4defb06564b37831f0c18e3734fd0365577c0a7cbf1c47a6`**. GitHub Action ZIP downloaded and verified `zipfile.testzip()==None`, SHA256 matched, `dpkg-deb -f` Package/Version/Depends rootless verified; contains only tweak dylib 89488 bytes + matching 118-byte injection plist. Local verified `/mnt/data/com.anlai.omnicar.doubletapfullscreen_0.7.0_iphoneos-arm64.deb`.
- Status: build/package/GitHub persistence **PASS**; 0.7 zoom visuals **DEVICE NOT TESTED**. User should check compact 29–36pt button, pale lavender/cyan fill, crisp arrow and unchanged click functionality + original 3 selection buttons. **No Sileo changes**, no original OmniCar DEB alterations, no idle auto-hide.
- Risk explicitly accepted by user: removed 0.6 emergency rescue, so previously reported native missing-three-dot fullscreen lock-out can still occur after native pane Zoom/float transitions. Do not describe that issue as solved. Follow-up if required is separate from this visual polish.


## CHECKPOINT 2026-10-19 — FULL ORIGINAL DEB SKIN/GRAPHIC AUDIT

- User requested exhaustively locating all original DEB images and graphics to understand a potential new skin. This is **research-only**, not consent to modify the installed app or prepare a theme build.
- Exact original com.anlai.omnicar_1.0.3_iphoneos-arm64.deb (1,306,228 bytes, SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd) extracted with dpkg-deb -x, **176 files**: 15 RGBA PNG = 6 icon/logo families, 139 .strings, 14 .plist, 6 dylibs, 2 executables. **No bundled images of split buttons/menu/divider/HUD or .car catalog**. Binary graphics are runtime-generated.
- Mapped UI owners: OmniCarSplitScreen.dylib (SCPCarSplit, SCPCarPane, SCPCarDividerView: three-dot handle, ratio chooser, popup bars, home button, border and floating layout), OmniCarAppBridge.dylib (ABBarButton/ABKnobView/ABKeyboard), OmniCarSpeedBubble.dylib (SPPBubbleView/SPPSignView render multiple styles), OmniCarStartupScreen.dylib (SSCanvasView/SSGauge/SF Symbols), OmniCarPrefs for Settings bitmap icon families. Original screenshots include system dock and third-party YouTube/maps that are NOT OmniCar skins.
- Durable audit paths: audit/OmniCar_1.0.3_skin_asset_inventory.md, audit/omnicar_1.0.3_assets.csv (15 PNG full paths/sizes/SHA256), scripts/audit_skin_assets.py (regeneration from user-provided original DEB). The generated contact sheet PNG exists TEMPORARILY at /mnt/data/omnicar_skin_audit/skin_original_assets_contact_sheet.png; not persisted as binary to GitHub.
- Tool tests: original DEB sha256 check, dpkg-deb inspect/extract, filesystem extension counts, PNG size+mode verification with Pillow, plistlib, strings class/selector scans across six dylibs and binaries, no PNG/JPEG magic in the Mach-O. This is only a static audit, no UI modification, no new DEB, CI or Sileo.
- Technical conclusion: replacing the 15 PNG only themes app and Settings icons, not CarPlay UI; full skin needs carefully scoped dynamic class/layer styling (UIColor, gradients, CAShapeLayer, UIBezierPath) while preserving all native behavior. Do not rewrite layouts or 0.7.0 Zoom without explicit design approval. Next: user chooses skin scope and look; then create theme architecture and one feature at a time.

## CHECKPOINT 2026-10-19 — BẢN ĐỒ SKIN TỔNG THỂ (CHƯA THAY ĐỔI BINARY)

- Yêu cầu mới: tổng hợp TẤT CẢ các yếu tố có thể thay skin OmniCar; xác nhận khả năng đổi màu UIView, UIButton, gradient, CAShapeLayer, UIBezierPath, kính mờ, viền và icon. Đây là yêu cầu kiểm kê/phân tích, KHÔNG phải phê duyệt giao diện mới hay build.
- Đã dùng original DEB com.anlai.omnicar_1.0.3_iphoneos-arm64.deb SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd. Quét 176 file, 15 PNG, 8 Mach-O, kiểm API dạng strings **264 phép kiểm tra, 163 có mặt**, và đọc **70 Settings config/symbol entries**. Phân biệt API có trong binary với binding đúng UI instance còn cần xác minh runtime.
- Hồ sơ MỚI không trùng file bàn giao: audit/OMNICAR_SKIN_MASTER_INDEX.md (27 khu vực và loại thay đổi/owner/rủi ro); audit/skin_surface_matrix.csv (máy đọc); audit/skin_scan_summary.json; scripts/audit_skin_surfaces.py (chạy lại), skin/theme_tokens.template.json (CHƯA có bảng màu chọn). Kết hợp audit/OmniCar_1.0.3_skin_asset_inventory.md và audit/omnicar_1.0.3_assets.csv (15 tài nguyên PNG).
- Kết luận: có thể đổi màu nền/button/icon/text/gradient/border/blur/shadow bằng các hook có phạm vi từng class/view do OmniCar tạo; KHÔNG có file skin PNG chung. Các vùng ứng dụng YouTube/Maps, CarPlay Dock và geometry/gesture không thuộc skin OmniCar.
- Giữ nguyên addon v0.7.0 (Zoom nền 0.5 đã bỏ nút cứu), DEB gốc, mọi GitHub workflow và Sileo; **không sửa source thực thi hoặc build** ở lượt này. Nếu làm skin sau này: người dùng phải chọn phạm vi và mẫu palette, ưu tiên SplitScreen, test từng UI trước khi kết hợp AppBridge/HUD/Splash/Settings.


## CHECKPOINT 2026-10-19 — CHỐT RANH GIỚI SKIN OMNICAR-ONLY

- User explicitly: **Tôi chỉ làm những thứ omni vẽ ko đụng hệ thống**. Áp dụng bắt buộc cho tất cả công việc skin OmniCar sau này.
- Được sửa: giao diện do OmniCarSplitScreen, OmniCarAppBridge, OmniCarSpeedBubble, OmniCarStartupScreen, OmniCarPrefs, OmniCar.app và nút Zoom OmniCar addon tự tạo. Chỉ màu sắc/kính mờ/gradient/viền/icon/font/trang trí được duyệt.
- Không sửa: Apple CarPlay dock, status, biểu tượng hệ thống, DBStatusBarWindow/CARStatusBarWindow, YouTube/Maps/GOFA/Waze scene/UI, UIKit/UIColor/CALayer swizzle toàn hệ thống; không đổi frame/scene/touch/gesture/timer/app data hoặc chức năng. Không tái tạo nút cứu hộ 0.6.0, không Sileo.
- Tổng hợp độc lập từ 176 file gốc, 15 PNG, 6 dylib, 2 executable; chi tiết tại audit/OMNICAR_SKIN_MASTER_INDEX.md và audit/OMNICAR_SKIN_SURFACE_MATRIX.csv (22 hạng mục), token mẫu skin/omnicar_tokens_template.json. Chủ lớp/selector tìm bằng binary strings; binding thuộc tính thực tế cho từng view cần runtime kiểm tra.
- Đây là **tài liệu và ràng buộc phạm vi**, KHÔNG có source patch, build, DEB mới, kiểm thử thiết bị hoặc phát hành. Mốc addon mới nhất vẫn 0.7.0; không thay đổi.
