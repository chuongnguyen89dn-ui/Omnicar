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
