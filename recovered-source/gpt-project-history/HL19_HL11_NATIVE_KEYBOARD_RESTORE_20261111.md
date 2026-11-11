# HL19 — phục hồi đường bàn phím hệ thống HL11, không đụng pinch/menu (11/11/2026)

## Mục tiêu được Nguyen chốt
- Chỉ dùng bàn phím **hệ thống iOS/CarPlay**, tuyệt đối không hồi sinh ABKeyboard tự vẽ.
- Tìm lại phiên video Nguyen đã gửi cho GPT phân tích: **IMG_8191.mp4**, khung xe 15:33–15:38 10/11/2026. Mốc bàn phím hiện và nhập được là **HL11 `1.0.3-hl11nativekb`**; các hạn chế hồi đó: không tự resize đúng theo ô chia; có lần Maps ô bên cạnh trắng. Pinch toàn OmniCar bị hỏng trên HL11, nhưng có tiến trình sửa riêng từ HL13; không lấy toàn bộ binary HL11 làm nền build.
- Menu ẩn nội dung/controls phải giữ nguyên như người dùng đã yêu cầu tại cuộc trò chuyện 11/11; **không sửa picker/menu, Home/Dock, YTZ, AutoHide/Wake, native maps, settings, scene engine, fullscreen controller** ở vòng phục hồi bàn phím này.
- Đích kỹ thuật: giữ đường tạo keyboard UIKit native từ HL11, không ép private keyplane/keyboardScreenReferenceSize hoặc reload hình học mới gây hồi quy. **Việc resize theo divider vẫn OPEN**, không gọi đây là bản fix resize.

## Bằng chứng đã đọc trực tiếp
- Repo chính `chuongnguyen89dn-ui/Omnicar`, code trong `recovered-source/`. README GPT, `TIEP_TUC_DU_AN.md`, hồ sơ `HL11_DUOFACE_KEYBOARD_INTEGRATION_20261110.md`, `HL12_HOME_DOCK_20261110.md`, `HL13_PINCH_REGRESSION_20261110.md`, `HL14_KEYBOARD_PICKER_FLOATING_DOCK_20261110.md`, `HL18_TECHNICAL_REVIEW_FOR_CLAUDE_20261111.md` đã được đối chiếu; `HUONG_DAN_GPT.txt` trên **main** trả 404, nhưng nội dung quy định có trong hướng dẫn dự án được cung cấp và `TIEP_TUC_DU_AN.md`.
- Lịch sử HL12 mô tả TikTok có pixel keyboard, cửa sổ `UIRemoteKeyboardWindow` fit **238×300**, 15:34:17, restore 15:34:29; đây là chứng cứ được ghi trong hồ sơ từ quan sát log/video, **không phải lần này tự mở được lại video nguồn**. Phiên log phía CarPlay PID 41737 xác nhận Home tile, không chứng minh keyboard pixel. Không nhầm ngữ nghĩa mốc này.
- HL11 source `ABInApp.m` tại `b77e4b4d102ce9b73d4d1384afabccffe718c702`, blob `73557304be29f4b5b7f7a4301e199e3ec655c9c3`: `ABNativeKbFit` chỉ tìm key window + visible keyboard window trong process hosted app, lưu frame gốc, đặt `keyboard.frame = key.frame`, restore on hide/resign; không chỉnh bounds/root, private reference getter hoặc ép keyplane.
- Nền trước patch HL19 `1f70debd27ab614f7ea6bd30db429ae5169e47ca` (nhánh HL19 đã tồn tại): `ABNativeKbFit` trong `ABInApp.m` mở rộng từ HL14/15/16/18 thành physical/logical viewport, chỉnh keyboard frame/bounds/root, can thiệp private `keyboardScreenReferenceSize`, delayed `reloadInputViews` ở nhiều chỗ. Hồ sơ HL16b ghi biến đổi **396×360 → 495×450 → 396×360** trong khoảng 26 ms; không được kết luận đây là nguyên nhân duy nhất gây lỗi pixel, nhưng đây là một đường cụ thể có cơ sở phục hồi.
- Pinch mốc được đo trên HL8 **33/33 fullscreen applied**, HL11 đã hồi quy; sau đó HL13 thêm hosted fallback. Không revert cả file `ABInApp.m`, không chạm `SCPTouchProbe`, `BridgeWake`, `SCPFullscreenController`.
- HEAD kiểm lúc thao tác: **main `24ed33d4c5d5d2f36e0d3ad2346c09463e70d2c9`**, `ci-fat-test` **`e4612cc3410d561f2e1d846a414ad94eddbd2461`** (HL17), nhánh HL19 **`1f70debd27ab614f7ea6bd30db429ae5169e47ca`** trước patch. Không xác minh được local checkout/dirty; chỉ thao tác GitHub connector.

## Mã đã sửa: SOURCE COMMITTED, chưa build
- **Branch:** `feature/hl19-hl7-native-keyboard-restore-20261111`, đã có trước thao tác; không tạo lại.
- **Parent:** `1f70debd27ab614f7ea6bd30db429ae5169e47ca`.
- **Commit mới:** `3eb68dc26a6eb0e753c15a176dc96662954b107b` — GitHub `create_blob` hai path → `create_tree` → `create_commit` → `update_ref(expected_sha=1f70debd...,force=false)` trả **success=true**.
- Chỉ sửa hai file ngang hàng (đã đọc lại từ GitHub, **cùng blob SHA `abf3235f0bca4bdc1507d39cb4b1df9e43ea600b`**):
  1. `recovered-source/project/OmniCarAppBridge/ABInApp.m`
  2. `recovered-source/src/AppBridgeB/ABInApp.m`
- Hunk: biến `ABHL19UseHL11NativeKeyboardFit=YES` (~1189); nhánh đầu `ABNativeKbFit` (~1208–1253) sử dụng HL11 native `UIWindow.frame` mà không đổi bounds/root/ref getter/forced reload; `ABNativeKbMaybeReload` (~1402) bỏ qua khi HL11 active; delayed reload trong `ABNativeKbOnGeometry` (~1462) bỏ qua cho HL11. Các geometry notifications và retry fit đã có sẵn được **giữ**; không thêm keyboard riêng hay IPC riêng. Ghi marker `[hl19kb] mode=hl11-native-frame`.
- Source path có marker `drawnKeyboard` hard-locked native từ HL3; các đường pinch và popup không bị hunk này sửa. Các phần HL15–HL18 cũ được giữ trong code dưới nhánh không chọn, thuận rollback/hậu kiểm; không thể gọi toàn bộ tệp đã trở lại byte-identical HL11.
- Kiểm độc lập sau commit qua GitHub: `fetch_commit` trả đúng diff hai file; `fetch_file` cả hai path trả cùng blob; branch HEAD đọc lại chính xác `3eb68dc...`; anchors `mode=hl11-native-frame`, cổng reload, `BWPinchMode`, `ABPinchTryAttach`, native keyboard gate đều có.
- **STATIC SOURCE PASS (giới hạn)**: thay đổi hẹp, parity src/project, verify HEAD/diff. **CHƯA biên dịch/clаng, chưa ldid, chưa CI, chưa DEB, chưa device proof.** Không được nhận HL19 đã sửa hoàn toàn keyboard, resize hay pinch.

## Rủi ro và cổng nghiệm thu
1. HL11 `key.frame` là khung logical app. Sau zoom tỷ lệ !=1, UI keyplane vẫn có thể rộng hơn ô physical; chính HL11 đã được báo không resize theo ô. Đây là bước **phục hồi bản native hiển thị được**, không phải giải pháp cuối cho responsive keyboard.
2. Sau `ABNativeKbFit` HL11, `ABNativeKbOnGeometry` vẫn thử lại khi divider commit; cần log theo cùng PID để xác định window hiện/hidden, key/frame/ref và ảnh chữ O/P/L, không giả định việc hiển thị đã thành công chỉ từ `result=applied`.
3. Nhánh HL19 đang kế thừa nhiều source HL18 (picker/frameperf), có thể vẫn thất bại trên xe ở picker. Không xử lý lỗi này bằng cách sửa menu ẩn nội dung; lệnh mới nhất là **giữ menu về nguyên bản và không đụng nữa**.
4. Muốn giao DEB mới: trước tiên kiểm `project/control` hiện vẫn `Version: 1.0.3-hl18kbpickerperf`; phải tăng Version nhận diện vòng HL19 và cập nhật workflow theo `Makefile` thực; chỉ chạy CI khi được Nguyen giao rõ, không chạy chồng job Muse; sau build xác minh artifact thật (version, app Info.plist OwnID, 8 FAT Mach-O x2 slices, signatures/sha, marker). **Hiện chưa push `ci-fat-test`, chưa dispatch/merge/publish Sileo**.
5. Nguyen nghiệm thu một phiên xe: TikTok/YouTube nhập, O/P/L đủ, mở/đóng bàn phím, chia kéo divider, xem Maps ô bên không trắng; pinch hai ngón bung/thu **toàn bộ OmniCar + Dock**, Home/Dock icons, menu chọn app và controls vẫn đúng; ghi log `[hl19kb]` và `[hl13pinch]` cùng phiên PID/video.
6. Rollback duy nhất hunk `3eb68dc...` trong hai bản `ABInApp.m`, không revert file nguyên hoặc xóa mốc pinch HL13. `ci-fat-test` chưa bị chạm, bản đã giao HL17 không đổi.

## Vị trí tiếp nối
- Code đã lưu bền vững trên GitHub feature HEAD `3eb68dc...`; README GPT trên main phải dẫn tới hồ sơ này. Không có local tạm tính là checkpoint.
- Khi tiếp: đọc HEAD mới nhất cả nhánh và CI, rà điểm nối Muse; chỉ sau khi có yêu cầu build, stage version/workflow, không trộn bản HL11 full cũ với các fix Home/Dock/pinch; kiểm compile/DEB hash/xe. Resize theo tỷ lệ ô chia là vấn đề độc lập chưa giải quyết bằng đường restore này.
