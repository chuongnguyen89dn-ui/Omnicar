# HL36 — Đồng bộ cửa sổ bàn phím/keyplane hosted (2026-11-12)

**Trạng thái**: SOURCE COMMITTED, CONNECTOR-STATIC-CHECK 21/21; **CHƯA chạy Python test/CI/build/DEB**, chưa có runtime hoặc DEVICE PASS. Lượt sửa không đụng chức năng CarPlay native, YTZ, Dock, picker, zoom, settings, voice-off, speed bubble.

## Nền và bằng chứng
- Repo duy nhất `chuongnguyen89dn-ui/Omnicar`, mã thực `recovered-source/`. Nhánh sửa **mới** `feature/duocar-hl36-keyplane-sync-20261112` tạo từ nhánh HL36 `feature/duocar-hl36-native-only-retire-drawn-20261112` HEAD `fa21883e1a6cd3981f1b2db75f5f6cf5ee082f09`. HEAD source sau sửa và kiểm `5574b1142037c720dbaf3a0b7f55ea21fb1370f7` (trước khi lưu file này). Không checkout local, không biết dirty state Muse. CI gần nhất về HL36: run `43183267776` SUCCESS của nền cũ, không chứng minh source mới đã build. Không dispatch mới.
- Nguyen xác nhận trên xe: tất cả bàn phím app hệ thống hiển thị và resize đúng. Chỉ sửa `hosted`.
- Log thật `logs/DuoCar.log` blob `9ead5f9965b1ed4842e7a36f7c60213a02a42be9`, YouTube PID 4013: **15:35:34.953** `UIRemoteKeyboardWindow` 371pt, keyplane 371pt x=25.5 ⇒ tràn phải 25.5pt; **15:35:38.946** window bị thu 495→371pt ở packet rev 29, keyplane 495pt x=7.5 ⇒ tràn 131.5pt; **15:35:38.948** mới log traits-width 371. Cơ chế mất đồng bộ có bằng chứng hình học/thời điểm, chưa chứng minh hết mọi nguyên nhân.
- Cần giữ `ABKeyboard.m`/`ABTelex.m` ngoài danh sách biên dịch, không hồi sinh bàn phím vẽ.

## Hunk source chính xác
1. `project/OmniCarAppBridge/ABKeyboardTraits104.m` và `src/AppBridgeB/ABKeyboardTraits104.m`: `ABKB104PlaceKeyboardWindow` nhận thêm `keyplaneInWindow`; chỉ một writer `keyboard.frame=target`. Khi keyplane tồn tại và đang tràn mục tiêu hẹp hoặc tràn trong window không đổi, **defer** và ghi `[hl36-kbsync] event=viewport-await-uikit`, không bóp/move keycaps. Khi keyplane chưa tạo ở lần window-visible đầu, vẫn cho phép đặt frame ban đầu, tránh chặn dựng bàn phím. Blob mirror `34c207a692818492b0b067fcc2c8f0afeb577663`.
2. Hai header `project/OmniCarAppBridge/ABKeyboardTraits104.h` và `src/AppBridgeB/ABKeyboardTraits104.h`: chữ ký đồng bộ; blob mirror `85f2b21e8c64c94775c0bf497d75b0e199b60198`.
3. `project/OmniCarAppBridge/ABInApp.m` và `src/AppBridgeB/ABInApp.m`: lấy projected keyplane **trước** khi gọi place; `ABNativeKbScheduleUIKitReflow` chỉ gọi `[responder reloadInputViews]` cho hosted first responder, rồi đo `post-uikit-reflow`. Coalesce 0.18s theo focus serial/host epoch/geometry revision; không retry loop. Hủy ticket ở focus resign, did-hide, host release/close/close-all, epoch đổi. Không writer thứ hai, không đặt inputView/transform. Blob mirror `2cd399c74d07efc845d19eefffbdf83390734666`.
4. `gpt-project-history/verify_hl34_keyboard_recovery.py`: cập nhật callsite 4 tham số và thêm contract gates/đối chứng thực cho HL36; blob `c4e7598fbd8a6fbd1a69d9403734e6623b0adb1e`.

## Kiểm tra và rủi ro
- `mcp__GitHub__compare_commits` cho nền `fa21883e...`: **ahead 11, behind 0, 7 files changed** chỉ trong 3 cặp source/headers và 1 script.
- Đã `fetch_file` đọc lại, so khớp **3/3** cặp src/project, kiểm **21/21 điều kiện tĩnh qua JavaScript**: header/implementation/callsite, một keyboard frame writer, không phím vẽ build, reset ticket, cấu trúc Objective-C cân đối. **Đây không phải kết quả chạy Python/clang**.
- `reloadInputViews` chỉ *yêu cầu* UIKit tự tái tạo layout; chưa biết UIKit private keyboard có đáp ứng trên xe. Nếu không, có thể giữ window rộng hơn pane (thay vì cắt phím), chưa đạt DEVICE PASS. Không gọi đây là bản đã fix trên xe.
- Không merge main, không publish Sileo, không gửi Muse, không dispatch CI.

## Bước tiếp và cổng thành công
- Kiểm script thật trong đúng checkout: `python3 recovered-source/gpt-project-history/verify_hl34_keyboard_recovery.py` với cwd gốc repo; đọc workflow `.github/workflows/build-fat-macos.yml` trước CI, không dispatch khi chưa được giao. Sau đó build/ký **một DEB tổng hợp** từ đúng HEAD, xác minh hash/version/arm64+arm64e/signature trên chính artifact.
- Nguyen thử thực tế bàn phím QWERTY (phím cuối, Backspace, Return), drag hẹp↔rộng, close/reopen, đổi app, reconnect trên YouTube và TikTok; giữ nguyên bàn phím native. Đọc log cùng PID + `[hl36-kbsync]` / revision và ảnh. Chỉ qua cổng nếu thực sự hiển thị **đủ phím và gõ được**.
