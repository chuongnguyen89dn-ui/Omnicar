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

## Lượt kiểm và yêu cầu DEB trực tiếp (2026-11-12)

Nguyen giao tiếp tục kiểm, build/ký **một file DEB trực tiếp**. Đã xác minh cấu trúc và chức năng workflow thật tại `.github/workflows/build-fat-macos.yml` trên chính nhánh. Docker hiện tại không có checkout; `git ls-remote` từ container thất bại `Could not resolve host: github.com`, nên không được nhận đã chạy Python/compiler local. Có thể chạy cổng test trên macOS Actions theo quy trình cũ (không tự merge Sileo).

Đã sửa lỗ hổng test tĩnh: `verify_hl34_keyboard_recovery.py` còn kiểm chuỗi `if (keyboard && key)` cũ (vì source mới dùng `BOOL placed=keyboard && key`), thay đúng hợp đồng source hiện tại, commit `bd05fc01a200c4e510321f95e2e649dd32a2a1e3`. Điều này chỉ sửa test lỗi thời, **không sửa implementation**.

Chuẩn bị đóng gói **version mới hơn HL36**: `1.0.3-hl37kbsync1` (package `com.chuong.duocar`; không trùng `1.0.3-hl36nativeonly` đã cài, không tự gỡ OmniCar). 
- `rebrand_duocar.py` commit `2c56b9cbf59933fcbf52727ac19722fda01bd497`.
- `verify_duocar_payload.py` commit `946d31e85dc1550d3f6c0ff552f76e5deeaa47fb`: version + marker `[hl36-kbsync]` trong chính FAT AppBridge.
- Dự kiến artifact sau runner: `com.chuong.duocar_1.0.3-hl37kbsync1_iphoneos-arm64.deb` (cần xác minh tên, hash, FAT, ldid từ **artifact thật**, không đặt tên thủ công cho một DEB cũ).
- Chỉ cập nhật build glue/workflow để áp dụng gate HL36 đúng cho nhánh mới. Workflow phải được xác nhận đã trigger đúng HEAD, không suy build từ push. Việc chuyển DEB đến cuộc trò chuyện phải dùng artifact sau khi CI SUCCESS, giải nén ZIP và đưa chính `.deb` trực tiếp, không bắt Nguyen tải ZIP.


## 2026-11-12 17:55 — HL37 DEVICE FAIL, log mới xác nhận deadlock keyplane

**Phạm vi**: người dùng gửi ảnh thực tế `IMG_0017.jpeg` (YouTube bàn phím bị cắt phím mép phải) và `IMG_0018.jpeg` (tỷ lệ kéo ô thay đổi nhưng bàn phím không resize; TikTok/search trắng). Xác nhận **DEVICE VISUAL FAIL** của `1.0.3-hl37kbsync1`, dù CI run `43202106624` SUCCESS và DEB đã chạy được; không được viện dẫn FAT/codesign như bằng chứng runtime.

**Log thật mới**: GitHub `chuongnguyen89dn-ui/Omnicar` commit upload `543b2dfda7007ff4bad01ac6511d0732e81ccc82` lúc 2026-11-12 17:55:56 +07; `main:logs/DuoCar.log` blob **`ab32c49469a61a4e5868786d0ace302dc2353ba0`**, 2,063,194 byte / 8,200 dòng. Do GitHub `fetch_file` trả `content=""` với blob > ngưỡng, dùng **`mcp__GitHub__fetch_blob` theo SHA** và đối chiếu marker/time/PID. **53 sự kiện `[hl36-kbsync]`**, 42 `viewport-await-uikit`, 11 `uikit-reflow-request`. PID thuộc HL37: YouTube **4470** (19), TikTok **4474** (34). Dải mới 17:49:31.821–17:53:43.181; không trộn với log HL36 PID 4013 lúc 15:35.

**Timeline xác định lỗi runtime**:
- **17:49:33.548–33.899**, YouTube PID 4470, rev **78**: SpringBoard phát `physicalW=297 logicalW=371 zoom=.8`; app nhận `stale=0 changed=1`; `key={{0,0},{371,450}}` nhưng `UIRemoteKeyboardWindow={{0,0},{495,450}}`, `_UIKeyboardWindowScene`, keyplane `{{7.5,288},{495,162}}`. HL37 `viewport-await-uikit` giữ window 495 và từ chối target 371. **33.740** `traits-width value=371`, **33.741** `reloadInputViews` request, **33.899** `post-uikit-reflow` vẫn `starW=495 keyplane width=495`. Không có resize.
- **17:52:48.276–48.639**, TikTok PID 4474 rev **25**: pane physical **198**, logical **248**, key `248×450`, keyboard **495×450**, keyplane **495 x=7.5**. `traits-width value=248` **48.468**, `uikit-reflow-request` **48.469**, `post-uikit-reflow` **48.639** vẫn 495; `viewport-await-uikit` (defer) tiếp tục.
- **17:53:42.372–43.182**, TikTok PID 4474 rev **82**: physical **297**, logical **371**, key **371×450**, keyboard/keyplane **495**. Lặp `traits-width=371`, `reloadInputViews`, `post-uikit-reflow` vẫn **495**. **Chỉ có setter/traits log không chứng minh UIKit dựng lại keycap**.
- Cả trường hợp **target=495, window=495, plane width=495, x=7.5** vẫn bị HL37 đánh `defer` vì `7.5+495>495`; thêm bằng chứng phép kiểm fit/x-offset không tự giải quyết clipping thật. `rightInsideClip=YES` trong log của window 495 **không có nghĩa vừa với pane 297/198 physical**; log `keycapRaster/touch=UNKNOWN` phải phân biệt với ảnh người dùng.

**Đối chiếu native app vs hosted**: Nguyen xác nhận keyboard các ứng dụng CarPlay native/hệ thống đúng cả khi đổi tỷ lệ. Native như Maps/Waze được CarPlay cấp context template/scene; hosted YouTube/TikTok là iPhone scene qua `FBSceneSettings setFrame:`, còn keyboard `UIRemoteKeyboardWindow` được cấp scene riêng `_UIKeyboardWindowScene`. Trong `ABHostBMethods.m` nhánh `setFrame:forApp:live:YES` return trước `layoutPane:`; settle mới `layoutPane:` + `ABPostOrientationToApp` của `ABHostGeometry.m`. `AB25SceneReferenceApply` hiện **chỉ probe, tuyệt đối không invoke** các private `setContentReferenceSize...`. Log HL36 đúng receiver `UIMutableApplicationSceneSettings` báo `status=unavailable`; không thể chỉ bê lệnh DuoNavi sang đây. `ABKeyboardTraits104.m::KB104WriteTraits` dùng `setKeyboardWidth:` và getter `keyboardScreenReferenceSize`; log mới chứng minh **traits-width đã đổi** nhưng keyplane **không rebuild**.

**PHÁN QUYẾT**: HL37 là **sai chiến lược**, không phải thiếu timeout. `reloadInputViews` không bắt buộc UIKit keyboard system keyplane rebuild khi một `_UIKeyboardWindowScene` không nhận kích thước mới; guard `planeKnown&&!fits&&(narrowing||!changed)` duy trì keyboard quá rộng. Cần xác minh đúng chủ/transaction của **keyboard scene** và khối nhận `setScreenTraits:`/construction, đồng bộ *pane physical → hosted scene logical → keyboard scene/keyplane lifecycle* và chỉ can thiệp cho hosted. Không thêm writer cửa sổ hoặc scale keyplane thứ hai, không sửa các app native, Home/Dock, YTZ, zoom, picker, settings, voice. Ngừng phát DEB giả định thành công; build chỉ sau khi xác minh contract trigger/ABI và có gate đo keyboard surface qua một revision, ảnh/touch DEVICE PASS mới là nghiệm thu.

**Trạng thái checkpoint**: RESEARCH / NEW LOG ROOT-CAUSE CONFIRMATION / HL37 DEVICE FAIL. **Chưa sửa source/build/CI/DEB**, chưa tự test xe, không merge code/main, không đẩy Sileo. Source branch build SHA `4c317cfcf73a1c9c8ef762aec457b176c5e15322`. Log nguồn hiện SHA ở trên. Tiếp tục tại các mắt: keyboard scene owner/geometry callback và `UIKeyboardLayoutStar` rebuild; cổng thành công là keyplane cùng logical width và mép phải nằm trong keyboard **và** pane hiện chính xác sau kéo ở cả hai hướng, mọi phím mép phải thấy/chạm được.
