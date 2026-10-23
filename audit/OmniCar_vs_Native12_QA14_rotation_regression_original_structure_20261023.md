# Đối chiếu cấu trúc hai DEB gốc và kết luận QA14 xoay ngược — 2026-10-23

**Loại bằng chứng:** ARM64/ObjC selectors được trích từ DEB gốc và CI SHA-pinned trước đó + ảnh thử thiết bị QA13 và phản hồi QA14 của người dùng. **Không có log runtime QA14** và không thử lại thực tế trên xe bằng GitHub Actions. Đây không phải thông báo bug đã sửa.

## Nguồn nhị phân không thay đổi

1. **Original OmniCar 1.0.3:** `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`; `OmniCarAppBridge.dylib` SHA256 `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79`. Host phía CarPlay được nối bởi `OmniCarSplitScreen.dylib`, nhận frame tại `ABHost.setFrame:forApp:live:handle:passInsets:`.
2. **Original DuoFace Native12 HUD8:** pinned repo `chuongnguyen89dn-ui/Duoface` commit `6193b9e77337fd1e9d586da5e5bf39742d041d2d`, `dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb`, SHA256 `8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a`; `DuoFaceDashboard.dylib` SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`.
3. Artifact nguyên bản từ GitHub CI: `audit/native12_vs_omnicar_yt_scene_arm64_20261023.json` và `audit/native12_vs_omnicar_scene_selector_calls_20261023.json`, `audit/omnicar_original_scene_settings_block_20261023.json`, `audit/omnicar_native12_verified_layout_policy_20261023.json`; machine audit success run `39929982072`. Không suy đoán địa chỉ runtime sau ASLR.

## Lỗi tái hiện của QA13 và QA14

- QA13 đã xuất hiện UI YouTube mới, nhưng screenshot sau khi chuyển vào video cho thấy video/logo lộn đầu **180 độ** và được letterbox trên/dưới, trong khi toàn bộ bản đồ bên phải và Dock ở trái **không** bị xoay.
- User xác nhận QA14 (**đã phát hành Sileo**, build run `39934420655`, pub run `39934710313`) **vẫn bị y nguyên**. Đây là thực tế của thiết bị, có ưu tiên cao hơn mọi khẳng định “CI SUCCESS”.
- Không có `[OmniCarYTSceneQA14]` log hoặc video gốc từ máy để nói đây chắc chắn do requestedOrientation 3→4; ảnh chỉ xác nhận phần video/YouTube đảo chiều, không thể định danh chính xác tầng xoay chỉ bằng một ảnh.

## Cấu trúc xử lý original khác nhau

| Tầng | OmniCar original | DuoFace Native12 original | Ý nghĩa |
|---|---|---|---|
| Chủ sở hữu ô chia | `SCPCarSplit.hostFrameForPane:`, `sendHostFrameForPane:live:` → AppBridge | `CBBridgedSplitApp.updateScale:forSlot:` → `CBBridgedUIAppView.refreshSceneLayout` | Hai luồng cập nhật layout không đồng cấu trúc |
| Kích thước trình bày | `ABHost.layoutPane:` @`0xed18` gọi **global** `zoom`, @`0xed74..0xed9c` setFrame `round(bounds/zoom)`, @`0xeda4..0xedc8` setTransform scale, @`0xf074` setSceneBox bằng bounds gốc | `CBBridgedUIAppView.calculateNativeSizeForSlotRect:` @`0xacc38..0xacc50` tính 2× và làm tròn; `updateLayout` @`0xad03c..0xad058` tính min fit | QA13/14 hardcode `zoom=0.5` để mô phỏng 2×, nhưng 2× native scene **không tương đương** chỉ đổi một hệ số view |
| Đồng bộ scene | `ABHost.layoutPane:` lấy `sceneHandle`, `sceneIfExists`, `updateSettingsWithBlock:` (send `0xf048`) | `refreshSceneLayout`: gọi **`updateLayout` tại `0xade74` và `updateSceneSettingsFrame` tại `0xade84`** | DuoFace chủ động đồng bộ cả native scene settings; hai hàm tách riêng |
| Frame/orientation | Block OmniCar original @`0xf210` gọi `setFrame:` `0xf248`, `setInterfaceOrientation:` `0xf280`, `setBackgrounded:` `0xf2b8`, `setForeground:` `0xf30c` | `updateSceneSettingsFrame` @`0xad5bc..` lấy `carPlayUsableBounds` fallback nếu target invalid (`0xad620`), gọi `calculateNativeSizeForSlotRect:` `0xad638`; phía sau có scene settings guarded calls (static) | Cần truy app rotation/content policy, không chỉ host outer bounds |
| Hướng được lấy ở đâu | `ABHost.effectiveOrientation:` original `0xf380`/`0xf390` lấy `ABPane.requestedOrientation` nếu >=1; `0xf39c` fallback `ABPane.orientation`; @`0xefbc` gọi để viết scene settings | Trong flow đã xác minh, DuoFace song song update scene + view; không có bằng chứng chính xác của **chính sách chống lật video** từ selectors có sẵn | Không được kết luận DuoFace đơn giản chỉ pin “landscape đầu tiên” |

## Nguyên nhân thất bại có thể khẳng định từ mã nguồn đã phát hành

1. **QA13 không có cơ chế kiểm soát orientation:** `youtube-scene/src/OmniCarYouTubeScene.xm` chỉ hook `ABHost.zoom` trong `layoutPane`, ép hệ số **0.50** được đoán từ phép 2× gốc của DuoFace. Vì `ABHost.layoutPane` original vẫn gọi `effectiveOrientation:` và ghi `setInterfaceOrientation:`, thay đổi viewport không giữ được chiều của video. Đây là thiếu sót rõ trong QA13.
2. **QA14 không hề khóa video ở tầng YouTube:** source `youtube-scene-qa14/src/OmniCarYouTubeScene.xm` chỉ hook **`ABHost.effectiveOrientation:`**, lưu `first landscape` bằng associated object per `ABPane`. Không hook xử lý fullscreen `AVPlayerLayer`/YouTube view controller/window hoặc scene event trong process YouTube. **Đây là phạm vi mã có thật**, không đủ chứng minh khống chế được video nội bộ.
3. **“Landscape đầu tiên” không phải quy chiếu từ chiều màn hình xe:** `UIInterfaceOrientationLandscapeLeft=3` và `LandscapeRight=4` đều landscape hợp lệ nhưng đối nhau 180 độ. QA14 nhận cái nào đến trước rồi pin nó mà **không đối chiếu với scene/window orientation vật lý đã ổn định**. Vì vậy nếu giá trị đầu là chiều ngược thì QA14 vô tình giữ sai. Đây là lỗi logic xác minh trực tiếp từ source QA14, không cần đoán giá trị thực tế trên điện thoại.
4. **Có thể handler không chạy cho YouTube hoặc xoay xảy ra ngoài handler:** QA14 kiểm bundle qua getter/ivar trên `ABPane`, tối đa depth2. Nếu không tìm đúng bundle, nó trả original; cũng có thể cảnh fullscreen YouTube xử lý orientation/transform bên trong iPhone app mà không qua `ABHost.effectiveOrientation:`. Phải kiểm hai dấu log `event=hook-ready`, `event=orientation-first-landscape-pinned/flip-rejected` mới xác định nhánh nào. **Chưa có log QA14** để kết luận.
5. **Sai lầm quy trình:** QA14 đã build/publish khi chưa đo hướng reference của DuoFace Native12 và chưa chứng minh hiệu lực hook trên máy. Có compile PASS không có nghĩa xoay fixed.

## Chỉ đạo sửa tiếp — không phát hành đoán mò QA15

- Giữ QA14 trong nguồn Sileo **ở trạng thái có lỗi được báo**; không tự tuyên bố chạy đúng hoặc xóa binary lịch sử. Khi đã có bản fix, publish bằng một bản tiếp theo qua nguồn cũ. Nếu người dùng không dùng được, cân nhắc phát hành rollback QA12 với phiên bản mới, không vô tình downgrade ID phiên bản.
- **Điều kiện trước khi sửa runtime:** đo cả `ABPane.requestedOrientation`, `ABPane.orientation`, `ABHost.effectiveOrientation` raw/final, `scene setInterfaceOrientation`, `YouTube video view rotation`, và CarPlay window/render orientation trong *cùng* thao tác video thường → video fullscreen → trở lại. Đặc biệt so DuoFace Native12 cùng YouTube/device resolution; xác minh thật selector/per-app routing để quyết định chỗ nào đặt correction, tránh chồng hook vô ích.
- Điểm kết thúc hợp lệ: YouTube luôn cùng chiều với CarPlay dock/map ở cả split/fullscreen/solo, không letterbox sai, cảm ứng đúng vị trí, map+map và native menu/timer/divider vẫn hoạt động, không crash. Nguồn Sileo là `https://chuongnguyen89dn-ui.github.io/carplaydsp/`; QA14 SHA256 `b29108a568b96ed7447a2000bc26d451d3399c16175a966a08d3b8d09fb808ac`.

**Kết luận:** Hai DEB gốc dùng hai kiến trúc khác nhau về native scene geometry. QA13/14 chưa port chính sách scene/layout của DuoFace; chỉ sửa `zoom` và thử pin hướng trên OmniCar. Đó là lý do *có thể lý giải từ source* vì sao hai bản chưa giải quyết đáng tin cậy lỗi YouTube lật 180°, nhưng tầng xoay chính xác phải được xác định bằng runtime trước khi tuyên bố root cause duy nhất.
