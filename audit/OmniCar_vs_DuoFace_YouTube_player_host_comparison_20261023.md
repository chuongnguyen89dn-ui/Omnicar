# OmniCar ↔ DuoFace Native12 — trình phát YouTube và cơ chế host (23/10/2026)

## Mục tiêu, ranh giới
Người dùng hỏi: “Hãy xem giao diện trình phát youtube của dupface ntn? Có thể thay thế sang omnicar đc ko?”

**Phân biệt ba tầng:** (A) chính ứng dụng YouTube dựng Play/Pause/Next, thanh tiến trình, like/share/comment; (B) bridge/scene đưa UIKit app lên CarPlay và điều chỉnh logical size/orientation/scale/touch; (C) chrome ngoài của tweak, nút ba chấm, Zoom/Swap, thanh chia và timer. Không coi tầng (A) là thư viện player của DuoFace khi chưa thấy bằng chứng.

**Căn cứ đã đọc từ GitHub:**
- DuoFace repo `chuongnguyen89dn-ui/Duoface`, file `audit/v12-host-path-20261014.txt` blob `ff541db7e4f9662ebad8bcd55997cbe46f4c707c`, `audit/v12-geometry-chain-20261014.txt` (metadata v12), `audit/v12-process-ownership-20261014.txt` blob `9c9e634e62cf5bcf9fc13ac6af8f4a16d199d4f5`. Native12 `DuoFaceDashboard.dylib` SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`, mốc kiểm định v12 trong các báo cáo disassembly gốc.
- OmniCar repo `chuongnguyen89dn-ui/Omnicar`, `audit/OmniCar_YouTube_AppBridge_scaling_20261019.md`, `audit/OmniCar_YouTube_AppBridge_UI_owner_QA7_20261020.md`, `audit/OmniCar_AppBridge_scene_path_original_20261020.json` blob `429f19d80d82767b6dc43feac35ca7c95b2b1512`, `audit/OmniCar_vs_DuoFace_external_solo_host_menu_20261020.md` blob `e73aff8e0aacf6211deb53c6b945318ce87f76e1`. OmniCar original DEB SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.
- OmniCar **mốc phát hành hiện hành theo handoff đọc trong lượt**: `QA12 1.0.3-omnicar12-timer-zoom-swap`, DEB SHA256 `f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba`, manifest `dist/candidates/omnicar-original-1.0.3-omnicar12-timer-zoom-swap/BUILD-MANIFEST.json` blob `4800944be87422d790799ea310ed33fc8d58299d`: 176 bản gốc giữ nguyên + CHỈ 2 tweak `OmniCarNativeSoloTimer` và `OmniCarDoubleTapFullscreen` (4 dylib/plist), original Solo giữ nguyên. Public Sileo SHA verifier ở handoff `39546089944` SUCCESS; **chưa có QA12 device PASS**.

## Kết quả đối chiếu các tầng

| Hạng mục | DuoFace Native12 — lớp/hàm đã xác nhận có trong binary | OmniCar original — lớp/hàm đã xác nhận | Ý nghĩa |
|---|---|---|---|
| Host một ứng dụng iPhone như YouTube | `CBBridgedUIAppView initWithBundleIdentifier:scale:` 0xac704; `startInParentViewController:` 0xadf30; `appViewController`, `wrapperView` | `ABHost openApp:frame:` 0xb8a0, `SCPCarSplit.sendHostFrameForPane:live:` 0x3dfac | **Hai kiến trúc khác nhau**, không thể gọi thẳng `CB*` trong OmniCar mà thiếu owner |
| Kích thước logic nội dung theo ô | `CBBridgedUIAppView calculateNativeSizeForSlotRect:` 0xacc28, `updateLayout` 0xacc6c, `layoutSubviews` 0xac8f0 | `ABHost layoutPane:` 0xec80, `sceneBox`, `SCPCarSplit.hostFrameInfo:pane:live:handle:` 0x3d39c | **Nơi đáng nghiên cứu chuyển thuật toán**, KHÔNG đơn thuần chỉnh màu/icon Play |
| Cập nhật scene/video khi đổi khung | `CBBridgedUIAppView updateSceneSettingsFrame` 0xad5bc, `updateSceneFrame` 0xade4c, `refreshSceneLayout` 0xade58; `CBBridgeManager renderSizeForBundleID:` 0x24c920, `supportsInterfaceOrientation:forBundleID:` 0x24d118 | `ABHost setFrame:forApp:live:handle:passInsets:` 0xfe68, `effectiveOrientation:` 0xf364, `SBSceneView -_updateReferenceSize:andOrientation:` literal in AppBridge | Có đường logic để so sánh **source-scene size, hướng, safe-area, phản hồi khi kéo chia/solo** |
| Scale | `CBBridgedUIAppView setAppScale:` 0xac83c, `appScale` 0xaf288; `CBBridgedSplitApp updateScale:forSlot:` 0x108dd8 | `ABHost zoom` 0xae20 (global `appBridgeZoom` → /100, clamp 0.6–1.0), `layoutPane` chia logical size cho zoom rồi `CGAffineTransformMakeScale(zoom,zoom)` ở 0xedac | DuoFace **có đường scale per-slot**, OmniCar **có giá trị bridge zoom chung**; chưa biết công thức Native12/giá trị khi YouTube chạy |
| Nhận chạm | `CBBridgedUIAppView touchesBegan:withEvent:` 0xaca6c; `hitTest:withEvent:` 0xac940; host `CBBridgedSplitApp.noteUserActivity` 0x10c378 | AppBridge host touch + native Split touch/Idle riêng; QA12 timer chỉ tác động `SCPCarPane.handle` và divider | Không dùng overlay che Play/Pause; touch mapping là điều kiện nghiệm thu |
| Chrome/pill/Solo | `CBWindow.rootWindow`, `contentView`, `multitaskingPill` và `CBSlotPillView` thuộc owner khác | `ABPane.handle` khác `SCPCarPane.handle`; original edge-close tiêu hủy owner native split | Lỗi nút `…` của YouTube Solo **tách khỏi** kích thước YouTube player |

Các IMP nêu trên là metadata/disassembly đã ghi trong tài liệu, **chứng minh sự tồn tại của phương thức**, không chứng minh YouTube đi qua từng hàm ở runtime hay thông số đầu vào. Đặc biệt: chưa có bản chụp/trace cùng phiên bản YouTube trên DuoFace Native12 được ghép cặp cùng video và cùng màn CarPlay nên **không thể mô tả chính xác kích thước/nút Play/Next của DuoFace từ ảnh thực**.

## Có thay thế được không?

- **Không nên và chưa chứng minh có một “YouTube player của DuoFace” để thay nguyên cụm.** Bằng chứng hiện có cho thấy DuoFace có *application hosting and sizing* rất rõ; **chưa có chứng cứ riêng về UI Play/Pause/Next do DuoFace tự vẽ**. Cụm nút có thể do YouTube tạo theo kích thước/size-class mà host cấp.
- **Có thể nghiên cứu chuyển cách tính geometry/scene policy** cho phần YouTube từ thuật toán `CBBridgedUIAppView.calculateNativeSizeForSlotRect:` và `updateSceneSettingsFrame/updateSceneFrame/refreshSceneLayout` sang cấu trúc `ABHost.layoutPane:`/ `setFrame:forApp...`/referenceSize của OmniCar. Đây là **viết adapter tương đương** trên API/owner OmniCar, không sao chép dylib proprietary `DuoFaceDashboard`, không can thiệp giấy phép, và không giữ song song hai host cùng quản lý một scene.
- Chuyển nguyên `CBBridgedUIAppView`/binary sẽ kéo theo `CBBridgeManager`, `CBWindow`, view lifecycle, dock, split và dependency của DuoFace. Không có bằng chứng nó link/hoạt động an toàn trong OmniCar. **Không áp dụng**.

## Phép thử nhỏ trước khi viết bản sửa mới

1. Bảo toàn QA12 và rollback byte-exact; **không sửa** `OmniCarDoubleTapFullscreen` (Zoom/Swap), `OmniCarNativeSoloTimer` (4 giây), native Solo, divider hay CarPlay dock. Không thay Player/assets YouTube.
2. Chỉ đọc sâu vùng mã máy thật của `CBBridgedUIAppView.calculateNativeSizeForSlotRect:` (0xacc28), `updateLayout` (0xacc6c), `updateSceneSettingsFrame` (0xad5bc) và đường renderSize theo bundle; ghép với original `ABHost.layoutPane` 0xec80, `setFrame` 0xfe68, `effectiveOrientation` 0xf364 để lấy **công thức**, không suy đoán theo tên selector.
3. Trên iPhone **chỉ log** `bundleID`, frame pane, usable rectangle, source/scene referenceSize, native render size, orientation/scale, transition split↔solo trong hai sản phẩm, tuyệt đối không log tài khoản/video. Cùng **một phiên bản YouTube và một video**. Nếu không có thiết bị đang chạy DuoFace Native12, không tuyên bố A/B DuoFace device PASS.
4. Nếu tìm được khác biệt kiểm chứng được, áp dụng **YouTube/AppBridge-only scene layout policy** bên trong OmniCar host, không global zoom, không chỉnh kích thước icon theo ảnh, không hook toàn bộ `UIWindow`/SpringBoard, không thay đổi native split/menu.
5. CI static/ABI + ARM64 + 176 file original unchanged + chỉ 1 owner AppBridge; kiểm thử thực tế YouTube+map, YouTube solo, điều khiển Play/Next, video, tiếng, nút ba chấm, map+map, Zoom/Swap, 4 giây ẩn/hiện, không văng. QA riêng, chưa thay QA12 trên Sileo nếu chưa đạt.

**Trạng thái 23/10/2026:** chỉ nghiên cứu/đối chiếu GitHub và xuất báo cáo; **không sửa code hoạt động, không build DEB, không deploy Sileo, chưa xác minh DuoFace YouTube UI trên thiết bị thật**. Giai đoạn đầu khả thi ở mức **host geometry/scene adaptation**, chưa thể bảo đảm sẽ cho giao diện giống DuoFace 100% khi chưa có video/screenshot đôi và trace.


## 2026-10-23 — Người dùng xác nhận QA15 vẫn xoay và thay đổi phạm vi: CHỈ giao diện trình phát, mọi chức năng OmniCar giữ nguyên

**Yêu cầu hiện hành (thay thế thử nghiệm QA13/14/15):** “Vẫn vậy. Tham khảo xem chỉ đổi giao diện phát. Còn chức năng vx của omni như trc đc ko?” Nghĩa là người dùng ưu tiên giữ cách OmniCar vận hành như trước, chỉ muốn bề ngoài/trình bày video YouTube giống trải nghiệm DuoFace. Đây không phải cho phép đổi đồng bộ host scene, app orientation, Zoom hay nền tảng split, không phải yêu cầu bê `DuoFaceDashboard.dylib` nguyên khối. **Device feedback:** QA15 vẫn gặp lỗi cũ. Kết quả CI QA15 thành công và public Sileo SHA đúng không phải kiểm thử hành vi thành công.

### Kiểm kê đúng lớp sở hữu (đã đối chiếu từ chính hai repo)

1. **YouTube tự dựng player overlay**: các nút Play/Pause/Previous/Next, progress, video, playlist và tương tác là giao diện bên trong ứng dụng YouTube được bridge lên màn CarPlay. Không có bằng chứng chúng là một bộ UI/asset dành riêng cho YouTube do DuoFace tự dựng.
2. **DuoFace Native12 là host scene**: trong `Duoface/audit/v12-host-path-20261014.txt` blob `ff541db7e4f9662ebad8bcd55997cbe46f4c707c` và `audit/v12-process-ownership-20261014.txt` blob `9c9e634e62cf5bcf9fc13ac6af8f4a16d199d4f5`, 764 và 469 dòng metadata/method được kiểm tra: **0 dòng khớp** `youtube|ytplayer|avplayer|video|playback|playpause|pause|seek|currentTime|nativePlayer` (trong *hai tài liệu metadata đã khảo sát*, **không** có nghĩa toàn bộ DEB tuyệt đối thiếu mọi video code). Có các class/method `CBBridgedUIAppView` (`layoutSubviews`, `updateLayout`, `updateSceneSettingsFrame`, `refreshSceneLayout`), `CBWindow`, `CBBridgedSplitApp`, `CBBridgeManager`. Không xác định được “giao diện phát DuoFace” như một module riêng có thể copy để thay thế.
3. **OmniCar sở hữu chức năng ngoài player**: `OmniCarSplitScreen.dylib` (`SCPCarSplit`, Dock và điều khiển ô), `OmniCarAppBridge.dylib` (`ABHost`/scene, `ABPane.handle`), các module QA12 `OmniCarNativeSoloTimer` và `OmniCarDoubleTapFullscreen`. Các UI “3 chấm” thuộc tầng Omni/AppBridge, KHÔNG phải cùng overlay playback YouTube.
4. **Phạm vi QA13–15 đã sai so với mục tiêu mới**: `youtube-scene`, `youtube-scene-qa14`, `youtube-scene-qa15` đều hook `ABHost.zoom/layoutPane`; QA14 còn hook `effectiveOrientation`; QA15 thử private content-reference setters. Đó là các thay đổi *engine/scene*, không thuần styling. User QA15 vẫn lỗi => không bê tiếp những hook đó sang phương án visual-only.

### Khả thi và giới hạn

**Có thể về mặt phân tách cấu trúc**: giữ OmniCar làm host 100%, tạo một điều chỉnh hiển thị *riêng trong view của player YouTube* (ví dụ vùng video/khung điều khiển/typography/padding/content fitting), không đổi controller scene của OmniCar. Khi chính YouTube thiết kế UI theo view hierarchy, chỉ thực thi trên đúng phiên bản/lớp player đã được chứng minh; không được chỉ dựa vào tên “DuoFace player”. Có thể cần hook trong **process YouTube** với filter đúng bundle, hoặc một adapter view xác định được ở bridge; các chi tiết phải được chứng minh trước khi can thiệp. Không có cam kết mọi phiên bản YouTube dùng các class giống nhau.

**Không thể xác nhận copy nguyên một bộ player DuoFace** với bằng chứng hiện nay: hai metadata không có lớp player tùy biến riêng, và rendering video có thể do YouTube quyết định. Không thể chỉ overlay ảnh/nút giả vì Play/Next/touch/seek sẽ bị đứt liên kết hoặc tạo UI giả. Cũng không được sửa `AVPlayerLayer`/rotate root `UIWindow` toàn cục hay tự vô hiệu hóa hướng từ app mà không có class/owner chứng cứ.

### Baseline bất biến và thử nghiệm có kiểm soát

- **Nền kỹ thuật bắt buộc**: original QA12 `com.anlai.omnicar` `1.0.3-omnicar12-timer-zoom-swap`, exact SHA256 `f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba`, 180 payload, giữ split/drag/solo/Zoom/Swap/3-dot/timer/Dock và Omni app bridge gốc. Đã có QA15 public trên Sileo nhưng **user-device FAIL**; không áp thêm QA15 scene module trong hướng mới.
- **Mốc 1 — xác định thật owner player**: trên iPhone khi đỗ xe, duyệt/log nhẹ view/layer/trait của chính YouTube ở trạng thái trang video và fullscreen, không ghi title, URL, cookie, account. Không hook UI process khác; ghi class + kích thước + hướng + hierarchy depth + player gesture/hit-test.
- **Mốc 2 — skin/presentation-only**: thay duy nhất những giá trị trình bày của đúng view player xác minh (size/padding/content mode và điều khiển đang có), giữ nguyên playback logic, remote YouTube app scene, Omni `ABHost`, `SCPCarSplit`, native Solo/Zoom/Swap/timer, menu 3 chấm, Dock. Mọi hook phải fail closed khi không nhận dạng player, không ép 0.50 và không setContentReferenceSize/orientation hay cảnh, không che cảm ứng.
- **Mốc 3 — build và phát hành**: package thành bản tiếp theo từ QA12 SHA-pinned, inspect source diff để chứng minh không sửa original 180 payload, riêng module YouTube visual-only, kiểm thử build/ABI, sau đó **đưa qua nguồn Sileo CarPlayDSP** theo yêu cầu người dùng để thử trên máy; không tuyên bố QA device PASS dựa trên CI.
- **Tiêu chí**: YouTube phát bình thường, overlay điều khiển đúng tỉ lệ/dễ bấm và không xoay ngược; kéo divider, split↔solo↔split, Zoom/Swap, timer 4s, dấu 3 chấm, Dock, map+map không thay đổi; Crash/Safe Mode không tăng.

**Quyết định:** DỪNG port host DuoFace (scene/reference/rotation) vào OmniCar. Chỉ cân nhắc visual-only sau khi xác định đúng YouTube player view; hiện chưa có class runtime/hook áp dụng để claim đã sửa. Tránh phát hành thêm một gói không có thay đổi thấy được. Cơ chế xoay của UIKit có thể được quyết định ở root/fullscreen view controller thay vì tại subview: Apple `UIViewController.supportedInterfaceOrientations`, `UIWindowScene.Geometry.interfaceOrientation`; sửa một subview không mặc nhiên sửa được lỗi root orientation.
