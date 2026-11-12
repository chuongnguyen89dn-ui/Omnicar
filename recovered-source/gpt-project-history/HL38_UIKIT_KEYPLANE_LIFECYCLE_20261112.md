# HL38 — Đồng bộ vòng đời UIKit keyplane cho ứng dụng hosted (12/11/2026)

**Trạng thái tại checkpoint**: CANDIDATE SOURCE COMMITTED trên nhánh riêng; kiểm tĩnh GitHub 18/18, chưa chạy Python thực/clang/Theos, chưa build hoặc ký DEB HL38, chưa có kết quả trên xe. **Không gọi FIXED/DEVICE PASS.**

## Nền, mục tiêu, giới hạn

- Repo duy nhất: `chuongnguyen89dn-ui/Omnicar`; cây build thực `recovered-source/project/`, source đối chiếu `recovered-source/src/`.
- Nhánh thi công: `feature/duocar-hl38-uikit-keyplane-lifecycle-20261112`; tạo từ HL37 docs HEAD `795801b32dc633b646d8992abf2c7a5a12114816`, để **không đụng nhánh HL37 có CI và kết quả test xe**. Source/build-gates HEAD trước checkpoint: `1cffa9d7d0b2396e35367bae741bbf79a83e0742`.
- Phạm vi duy nhất: chỉ UIKit bàn phím của app hosted (YouTube/TikTok/FB phone scene); không thay các app CarPlay native/hệ thống, Dock/Home, YTZ, zoom, picker, settings, scene sustain, bridge wake hay speed bubble. Không hồi sinh bàn phím vẽ `ABKeyboard/ABTelex` hoặc trợ lý voice. Không mở keyboard engine thứ hai.
- User thiết bị xác nhận **mọi bàn phím ứng dụng hệ thống hiển thị/resize đúng**. Đây là USER DEVICE OBSERVATION, không phải phép đo của GPT.
- Nguồn log gốc: HL36 `main:logs/DuoCar.log` blob `9ead5f9965b1ed4842e7a36f7c60213a02a42be9`, YouTube PID 4013, 15:35:38.946, window 371pt / keyplane 495pt (x=7.5), chệch 131.5pt. 
- **HL37 DEVICE FAIL** (đã ghi trong hồ sơ cũ, không phải do lượt HL38 này chạy): `main:logs/DuoCar.log` blob `ab32c49469a61a4e5868786d0ace302dc2353ba0`, upload commit `543b2dfda7007ff4bad01ac6511d0732e81ccc82` ngày 12/11 17:55 +07. YouTube PID 4470 rev 78 target 371 vẫn LayoutStar 495 sau `reloadInputViews`; TikTok PID 4474 rev 25 target 248, keyplane 495; khóa HL37 `planeKnown&&!fits&&(narrowing||!changed)` gây deadlock. CI FAT HL37 `43202106624` SUCCESS **không phải device pass**. Nguồn hồ sơ [HL37 keyplane log / zoom hypothesis](HL36_KEYPLANE_SYNC_20261112.md).
- Đối chiếu kiến trúc tham khảo trực tiếp repo `chuongnguyen89dn-ui/Duoface`, nhánh `spec-main`, `sideplay/spec-knowledge/BAO_CAO_QUET_BAN_PHIM_CAC_DEB.md`: bản gốc DuoNavi có hook `UIKeyboardLayoutStar setScreenTraits:/setKeyboardName:/setKeyplaneName:/showKeyboard`, không đơn thuần sửa frame. Đây là audit của Muse từ strings/log, **không chứng minh** thủ thuật HL38 sẽ làm UIKit rebuild trên xe. Không nhập code/binary hãng khác.

## Những hunk thay đổi trong HL38

1. `project/OmniCarAppBridge/ABKeyboardTraits104.m`, mirror `src/AppBridgeB/ABKeyboardTraits104.m` (blob cả hai `a4e0b93d04590db466e7433123ea498f163b5850`):
   - Gỡ return `viewport-await-uikit` trên shrink (gốc deadlock HL37); vẫn giữ duy nhất writer `keyboard.frame=target` dưới kiểm định host geometry, log `[hl38-keyplane] event=viewport-stale-plane` khi keyplane còn quá cỡ.
   - Thêm `ABKB104RequestUIKitKeyplaneUpdate()` nằm trong **đúng owner ABKeyboardTraits104**, chỉ chạy khi `KB104Eligible` (hosted+main thread). ABI-guard class/selector `UIKeyboardLayoutStar.setScreenTraits:`, tìm `screenTraits` hoặc factory `traitsWithScreen:orientation:` theo signature, áp width hiện hành bằng `KB104WriteTraits`, gọi setter UIKit, tùy chọn ABI-guard `updateKeyplaneName`, `setNeedsLayout` (không sửa frame/transform/keycap/text). Có chống đệ quy `KB104RefreshInProgress` và log `refresh-request/refresh-skip/refresh-exception`.
2. `project/OmniCarAppBridge/ABKeyboardTraits104.h`, mirror `src/AppBridgeB/ABKeyboardTraits104.h` blob `6795859d9bcdd909af5962998716155ced725ed4`: khai báo hàm mới.
3. `project/OmniCarAppBridge/ABInApp.m`, mirror `src/AppBridgeB/ABInApp.m` blob `e9d393ec7089bff6be683044da68a9da7a339be8`: thay `reloadInputViews` vô điều kiện bằng tìm đúng `UIRemoteKeyboardWindow/UIKeyboardLayoutStar` của process hosted, gọi `ABKB104RequestUIKitKeyplaneUpdate`; chỉ fallback `reloadInputViews` nếu không thể gọi; giữ coalesce 0.18 s và ticket focus/epoch/revision cancellation, theo dõi sau 0.15 s. Log `scene-layout-request` kèm tên `_UIKeyboardWindowScene` và coordinateSpace bounds (chỉ đọc).
4. `gpt-project-history/verify_hl34_keyboard_recovery.py`: bổ sung assert hợp đồng HL38, chống tái lập deadlock, kiểm ABI, 1 writer và nhánh fallback, giữ cổng native-only/voice-off.
5. `gpt-project-history/rebrand_duocar.py`, `verify_duocar_payload.py`, `.github/workflows/build-fat-macos.yml`: chuẩn bị **version riêng** `com.chuong.duocar 1.0.3-hl38keyplane1`, yêu cầu marker FAT `[hl38-keyplane]` và giữ hàng loạt marker cũ; workflow HL38 **manual-only**, không nằm push triggers, nhận HL38 vào các source gates và bỏ các historical/voice gates không hợp lệ. Artifact CHỈ DỰ KIẾN `com.chuong.duocar_1.0.3-hl38keyplane1_iphoneos-arm64.deb`; **chưa tạo file này**.

## Bằng chứng kiểm thực tế và giới hạn

- GitHub connector `fetch_file`, `update_file`, `fetch`, `compare_commits`; không có checkout cục bộ, không chạy git/make/ldid, không build CI. Đọc workflow thực trước khi sửa; **không dispatch CI**, không merge main, không Sileo, không liên hệ Muse ngoài chat.
- Sau ghi đã đọc GitHub blob của ba cặp source/head, **3/3 src/project trùng byte**. `compare_commits` so với `795801b32...`: ahead 10, behind 0, **đúng 10 file** (3 cặp C/ObjC, 3 script + 1 workflow) và không có hunk các module native/picker/zoom/scene/dock.
- **18/18 điều kiện kiểm tĩnh bằng JS đọc blob GitHub PASS** (mirror, 1 `keyboard.frame=`, ABI guard, host gate, không thêm setter keyplane, bản vẽ chưa biên dịch, voice unlinked, version và workflow manual-only, log/marker/fallback/revision). Đây **không phải** kết quả chạy Python `verify_hl34_keyboard_recovery.py` hoặc biên dịch compiler; **chưa chứng minh xử lý layout thành công**.
- Rủi ro kỹ thuật còn mở: `setScreenTraits:` có thể chỉ lưu traits mà không khởi tạo keyplane mới trong `_UIKeyboardWindowScene`, hoặc API private thiếu/ABI khác trên iOS 16.7.16; fallback có thể vẫn fail như HL37. Không tăng timeout, không sửa keyboard native. Bắt buộc xem log `refresh-request`, `scene-layout-request`, `post-uikit-reflow` theo **cùng PID/revision** để xác định có tái tạo layout. Nếu chưa, cần phân tích owner scene thật trước vòng sửa tiếp. Zoom 80% vs 100% là giả thuyết cần kiểm A/B, **không sửa zoom trong HL38**.

## Cổng tiếp tục / nghiệm thu / rollback

- Tiếp tục kiểm checkout có Theos: cwd repo root, chạy `python3 recovered-source/gpt-project-history/verify_hl34_keyboard_recovery.py` và các cổng hồi quy, static syntax/compile ở macOS rồi đóng một DEB tổng hợp; chỉ dispatch CI khi được Nguyen giao rõ.
- Ngày test xe: QWERTY đầy đủ kể cả cạnh phải, Backspace và Return gõ được, kéo ô **198 ↔ 297 ↔ 396 physical** cùng logical theo zoom, width+origin keyplane nằm trong keyboard **và** hiển thị thực trong pane; thử YouTube/TikTok, đổi app, close/reopen/reconnect, đối chiếu native keyboards vẫn bình thường. Không chấp nhận chỉ vì `traits-width` hoặc `refresh-request` được in log.
- Rollback hunk về branch baseline `795801b32...`, **không force push hay ghi đè thay đổi Muse/người khác**; note HL37 đã DEVICE FAIL nên rollback chỉ phục vụ phân định hành vi, không coi là giải pháp thành công.
- Trạng thái hiện hành: **SOURCE PATCHED / STATIC CHECKED / BUILD PENDING / DEVICE PENDING**, không có local dirty state xác minh và không có job riêng HL38 đang chạy.
