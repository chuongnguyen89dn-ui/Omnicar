# HL36 — Loại hẳn bàn phím vẽ khỏi bản biên dịch, chỉ giữ bàn phím UIKit hệ thống

Ngày 12/11/2026 (Asia/Ho_Chi_Minh). Nguyen yêu cầu: **gỡ hẳn bàn phím vẽ OmniCar, giữ các hàm cần thiết, dùng bàn phím hệ thống**. Phạm vi này **không** cho phép sửa YTZ, picker, scene sustain, zoom, settings hay giọng nói ngoài điểm nối keyboard.

## Đầu mối và nền mã

- Repository **duy nhất** `chuongnguyen89dn-ui/Omnicar`; cây build `recovered-source/project/`, source tham chiếu `recovered-source/src/`.
- Nhánh mới: `feature/duocar-hl36-native-only-retire-drawn-20261112` tạo từ HL35 `1cc0820fc7a477c59ccadef1dce4943d1a8a4bd8`, không sửa HL35/Muse.
- Commit source `54c8fafd0593500902e6300244dc853f3d219f3d`, commit mở rộng gate HL34 `360e3d1acf0152a072ac8c3bea1dd73e93b75b4f`, commit sửa regex gate `31b80661679c448a0744ef1b6fd34e699b1b28ce`.
- Kết nối GitHub được kiểm trực tiếp; **không có checkout cục bộ/VM**, không thể khẳng định local dirty state hay job đang chạy bên Muse. Trên nhánh HL34/HL35 đã đối chiếu cùng SHA trước khi triển khai. Không copy file nguyên từ nhánh cũ đè lên nền mới.
- Nguồn cơ chế gốc: `gpt-project-history/HL35_DRAWN_KEYBOARD_SOURCE_TRACE_20261112.md`, `handover/reports/map-m2-keyboard.md` và disasm `src/AppBridgeB/disasm/m_ABKeyboard_*.txt`. Source đã được đọc trực tiếp bằng GitHub connector trước sửa.

## Cụ thể đã thay đổi ở source

1. `project/OmniCarAppBridge/Makefile`: bỏ `ABKeyboard.m` + `ABTelex.m` khỏi `OmniCarAppBridge_FILES`; hai file gốc **vẫn tồn tại trong repo**, cùng bản `src/AppBridgeB/`, chỉ để tra cứu, không được link vào DEB.
2. `project/OmniCarAppBridge/ABInApp.m`: gỡ producer `ABKeyboardPublish`, consumer `ABKeyBlock`, observer `ABChanKey`, marker `ABBlankInputViewKey` và mọi đường tạo `setInputView:blank`. Giữ nguyên hook `UITextField`/`UITextView` become/resign, `ABCurrentResponder`, `BWKbLocalSet`, `BWKbStateBecame`/`BWKbStateResignedDeferred`, các phép đo không nội dung gõ, native keyplane/traits, callback scene. `ABDrawnKb` là hằng NO; payload drawn=1 cũ không tái kích hoạt panel.
3. `project/OmniCarAppBridge/ABHostGeometry.m`: bỏ đăng ký Darwin panel + `ABKeyboardDispatch`, bỏ mọi lệnh `ABKeyboard.shared show/hide`; giữ `ABNotifyAppOrient`, `ABKbSyncNoteEvent` phục vụ invalidation trên close/disconnect và trạng thái native độc lập từ app. Cổng `drawnKeyboard` trong frame packet giữ bằng 0 vì ABI tương thích.
4. `project/OmniCarAppBridge/ABHostLaunch.m`: bỏ dynamic lookup `NSClassFromString(@"ABKeyboard")`/hideForApp, **giữ** `ABKbSyncNoteEvent(bundleID, NO)` ngay trước teardown.
5. `ABChannelNames.m` + `AppBridgeB.h`: bỏ hai tên kênh panel và khai báo `ABTelexApply` không còn link; không đụng `appbridge.kbsync`, orientation, BridgeWake.
6. `ABIntegrationShims.h`: bỏ prototype dispatcher đã xóa. `ABHostBMethods.m`: điều chỉnh ghi chú luật khóa native; `ABNativeKeyboardEnabled()=YES` giữ nguyên. `ABKeyboardTraits104.m/.h` **không thay đổi**.
7. Đã mirror cùng byte 6 cặp file: `ABInApp.m`, `ABHostGeometry.m`, `ABHostLaunch.m`, `ABChannelNames.m`, `AppBridgeB.h`, `ABHostBMethods.m` vào `src/AppBridgeB` hoặc `src/AppBridgeA/src` tương ứng.
8. Không sửa file dead `#if 0` trong `project/OmniCarAppBridge/ABChannels.m`, tránh biến handler hide-only lịch sử thành đường live. Không xóa disasm hoặc nguồn phục hồi.

## Bằng chứng kiểm thực tế

- **GitHub commit source xác nhận**: `54c8fafd...`; ref read-back sau source, test HEAD `31b80661...`.
- **Kiểm nguồn bằng tool connector trên nhánh**: 21/21 điều kiện **PASS** về danh sách biên dịch, kênh giả đã xóa, native traits còn trong build, hook responder/kbstate còn sống, đúng 1 lệnh ghi `keyboard.frame=` trong `ABKeyboardTraits104.m`, 0 ở `ABInApp.m`, bản gốc `ABKeyboard.m` và `ABTelex.m` có SHA blob không đổi.
- **Đối xứng**: 6/6 cặp `src/project` đổi khớp blob SHA; cả hai bản Telex và ABKeyboard di sản khớp.
- Tận dụng script đã có `gpt-project-history/verify_hl34_keyboard_recovery.py` (không tạo script mới), thêm cổng HL36. Đồng thời sửa regex cũ của HL34 từ `r"keyboard\\\\.frame\\\\s*="` thành `r"keyboard\\.frame\\s*="` (tài liệu này mô tả chuỗi escape) để cổng thật sự đếm writer. **Script chưa chạy trong checkout có Theos; các assert tương ứng đã kiểm trực tiếp trên nội dung GitHub bằng JavaScript.**
- Không có lệnh shell git/build chạy thành công (GitHub không resolve DNS từ container); các thao tác là GitHub connector `fetch_file`, `create_branch`, `create_tree`, `create_commit`, `update_ref`, `update_file`, `fetch`.
- **Không dispatch CI, không tạo/ký/kiểm DEB, không merge main, không Sileo, không thử thiết bị.** Không gọi HL36 PACKAGE PASS hoặc DEVICE PASS.

## Phân công / điểm nối / cổng tiếp

- Muse giữ điểm tích hợp, xây/ký DEB tổng hợp. Trước xây: đọc code HEAD HL36, kiểm các nhánh mới Muse và merge bằng từng hunk, **không đè file `ABInApp.m`/host**. Đặc biệt `ABKeyboardTraits104` do HL34 quản lý một owner `keyboard.frame`; không tái lập fit/rollback thứ hai.
- Workflow `.github/workflows/build-fat-macos.yml`, `rebrand_duocar.py`, `verify_duocar_payload.py` trên nhánh hiện còn dùng version/package mẫu **HL34**. **Phải đổi cùng một lần sang HL36 ở bước ghép build**, hoặc có nguy cơ phát hành DEB nhận diện nhầm. HL36 chưa được thêm vào push trigger để không tự chạy CI.
- Yêu cầu trước đó của Nguyen là **tạm bỏ voice khỏi DEB**: HL36 chỉ xử lý keyboard, không tự sửa module Muse đang quản; gói build sau này cần phối hợp tách voice theo yêu cầu trước khi giao. Không gọi binary HL36 là voice-free.
- Cổng build: test HL34+HL36 trên source, compile FAT arm64/arm64e, kiểm code signature, **trích chính DEB cuối** để xác minh không có lớp ObjC `ABKeyboard`/`ABKey`, symbol `ABTelexApply`, kênh `appbridge.key` (cho phép `appbridge.kbsync`), và có marker native mới. Hash/version/architecture cần ghi cụ thể từ artifact thật.
- Cổng DEVICE của Nguyen: app không hỗ trợ mở phím UIKit đủ cả hàng QWERTY/dấu cách/return, nhập được/chạm được; đổi tỉ lệ 2 ô, chế độ solo, trở lại, đổi app, đóng/mở split, ngắt–nối/restart không mất phím hoặc tạo panel thứ hai. Kiểm PID+marker đúng một phiên. **Gỡ UI vẽ không tự sửa được lỗi keyplane bị cắt**: nếu còn, lấy `UIRemoteKeyboardWindow`/clip/keyplane geometry và touch/raster theo log rồi khắc phục theo bằng chứng, không vá scale phỏng đoán.

## Điểm tiếp tục / hoàn nguyên

- Đang ở **SOURCE CHANGED + STATIC-CHECKED**, **BUILD PENDING**, **DEVICE PENDING**. Chưa làm: phối hợp Muse về voice/đầu mối source, stage version, chạy CI hợp lệ, lấy trực tiếp DEB và nghiệm thu xe.
- Để hoàn nguyên hunk HL36: quay về `1cc0820fc7a477c59ccadef1dce4943d1a8a4bd8` (HL35) theo từng file đã sửa; không force-push/ghi đè nhánh người khác; giữ riêng checkpoint lịch sử này.
- Không lưu token, thông tin TCC riêng tư hoặc dữ liệu gõ.

## 12/11/2026 — cập nhật: build gate HL36 + gỡ giọng nói khỏi DEB

**Yêu cầu mới thay thế giới hạn vòng trước:** Nguyen yêu cầu *chuẩn bị đầy đủ cổng build và kiểm DEB HL36; đảm bảo bàn phím vẽ không được biên dịch, giữ bàn phím hệ thống UIKit, tạm gỡ hẳn phần trợ lý giọng nói khỏi DEB*. Tại mục "Phân công / điểm nối" bên trên, ghi nhận "voice chưa tách" là trạng thái **trước** các commit mới dưới đây, không còn là kết luận source hiện tại. YTZ, picker, geometry, Dock, speed-bubble/tính năng cảnh báo tốc độ giữ nguyên. Không nhầm "trợ lý giọng nói" với `speedBubbleWarnVoice`.

### Chuỗi commit bổ sung — nhánh riêng, không merge main

- Source voice iPhone: `ab837e150aa9188aefe470f8c8ba48b1f5d36be7`.
- Source voice CarPlay/SpringBoard: `42bd55d9de7aa860f68981a094d7657f365379e1`.
- Build/DEB/static gates: `07258c876e1a99c4e809a5165d5b7663172d2a44`.
- Parent source trước tách voice: `9086be880564aa183338122fb82f02224c153fc6`. Code vẫn ở **một repo** `chuongnguyen89dn-ui/Omnicar`, nhánh `feature/duocar-hl36-native-only-retire-drawn-20261112`. Không tạo DEB, không chạy/dispatch CI, không push main, không phát hành Sileo.
- Branch HEAD đọc trực tiếp sau commit build-gates: `07258c876e1a99c4e809a5165d5b7663172d2a44` (trước commit checkpoint này).

### Hunk source giọng nói — giữ mã tham khảo, không còn liên kết binary

**Ứng dụng iPhone**:
- `project/OmniCarApp/Makefile`: loại `DCVoiceSession.m` và `DCVoiceCommand.m` khỏi `OmniCar_FILES`; bỏ framework `Speech` (giữ `AVFoundation` cho startup media).
- `OMCAppDelegate.m`: bỏ observer `voice.request`, mọi đường kích hoạt DCVoice. `OMCNativeSettings.m`: bỏ trang/công tắc trợ lý, lựa chọn ngôn ngữ, chức năng nhấn nói; không sửa các mục Settings, split, startup, bong bóng tốc độ. `Resources/Info.plist`: bỏ `NSMicrophoneUsageDescription` + `NSSpeechRecognitionUsageDescription`; giữ quyền thư viện ảnh.
- Mirror sang `src/App/` đúng byte (`OMCAppDelegate.m`, `OMCNativeSettings.m`, `Info.plist`).

**CarPlay / SpringBoard**:
- `project/OmniCarSplitScreen/Makefile`: loại `SCPVoiceBridge.m`, `SCPVoiceBubbleView.m`, `SCPVoiceNative.m`, `SCPVoiceSpringAgent.m`, `../OmniCarApp/DCVoiceCommand.m`; bỏ framework `Speech` nhưng giữ AVFoundation và toàn bộ thành phần split khác.
- Gỡ callsite và import voice từ `SCPCarSplit.m` (activate, close, invalidation), `SCPHooks.m` (layout, install), `SCPSpringBoardHooks.m` (install agent), `SCPCarSplit+Picker.m` (picker show/hide), `SCPCarSplit+RatioMenu.m` (menu).
- Các file `src/SplitScreenA/` và `src/SplitScreenB/` được sửa **theo hunk** trên đúng nền từng file. `SCPCarSplit.m` và `SCPHooks.m` có khác biệt include tương đối `../SplitScreenC/` ở src so với project (không phải xung đột chức năng, không copy đè), đã giữ nguyên. Ba cặp file còn lại khớp blob SHA sau sửa. Runtime voice callsites 0/10 tệp dự án+src ở năm TU.
- Tất cả `DCVoice*.m` và `SCPVoice*.m` vẫn tồn tại trong repo như tư liệu **không biên dịch**; các warning/chức năng bong bóng tốc độ và lời cảnh báo tốc độ vẫn sống.

### Giao ước build và kiểm DEB

- `.github/workflows/build-fat-macos.yml`: HL36 **chỉ workflow_dispatch**, *không nằm trong push trigger*; các gate HL29/HL31 voice và lịch sử keyboard không tương thích được skip đúng HL36; cổng `verify_hl34_keyboard_recovery.py` HL34+HL36 được nối trước build. Nguyên đường `make clean; make package FINALPACKAGE=1 ARCHS="arm64 arm64e"`, kiểm lipo, code signature, ký và upload artifact tư nhân giữ nguyên.
- Bước chỉ đọc log HL34 run `43166409936` đã thất bại **trước biên dịch** (`re.PatternError: unbalanced parenthesis` ở `analyze_hl34_car_log.py`); branch HL36 sửa regex gốc và đặt `continue-on-error: true` cho diagnostic-only. Vì không dispatch CI, fix này chưa được kiểm trên runner; không nói đã chữa lỗi xây/biên dịch thực.
- `gpt-project-history/rebrand_duocar.py`, workflow và `verify_duocar_payload.py` cùng định danh chính xác `com.chuong.duocar`, `1.0.3-hl36nativeonly`, kiến trúc `iphoneos-arm64`; artifact dự kiến `duocar-hl36-nativeonly-fat-deb`, file dự kiến `com.chuong.duocar_1.0.3-hl36nativeonly_iphoneos-arm64.deb`. **Đây là tên đích build, không phải file hiện có hoặc link tải.**
- Bộ kiểm **trên chính DEB tương lai**, không phải code source: xác nhận 8 FAT binaries ký với 2 slice arm64/arm64e, marker `[hl36-native-only]` + các marker native/scene/Logo/Dock hiện có, không tồn tại tên lớp `ABKeyboard`/`ABKey` hoặc ký hiệu `ABTelexApply`/kênh `appbridge.key`-`appbridge.keyboard`, không có `SCPVoiceBubbleView`, `SCPVoiceSpringSession`, các hàm voice install và kênh `voice.capture.*`/`voice.action`/`voice.ack`; app không có controller voice, không link `Speech.framework`, app plist không yêu cầu quyền microphone/nhận dạng giọng nói. Không cấm chung chữ "voice" để không nhầm `speedBubbleWarnVoice`.
- `verify_hl34_keyboard_recovery.py`: mở rộng kiểm source-only cho Makefile, hooks native/input session, cặp app mirror, absence voice ở tệp thực sự biên dịch, sự tồn tại lời cảnh báo tốc độ và cặp module di sản; không tạo script trùng. Đây là **cổng chưa chạy thực tế trong runner**.

### Kiểm đọc lại GitHub ở lượt này

- 14/14 điều kiện nguồn (ứng dụng iPhone + SplitScreen + AppBridge + Info/plist): **PASS trực tiếp trên blob của nhánh**.
- 10/10 tệp TU (`project` và `src` của 5 file split) không còn các callsite `SCPVoiceBubbleUpdate/Detach`, `SCPVoiceInstall`, `SCPVoiceSpringInstall`; 2 cặp khác byte **chỉ vì đường include cần thiết**, sau chuẩn hoá include giống nhau.
- 15/15 điều kiện trực tiếp về workflow/scripts: phiên bản, manual-only, native marker, FAT, code signature, cấm voice và drawn UI: **PASS qua kiểm tra nội dung GitHub**.
- Lúc kiểm mới nhất danh sách Actions không có run HL36; run HL34 `43166409936` FAILED tại bước diagnostic, HL33 `43160289936` SUCCESS nhưng là binary khác.
- Không có checkout Theos/macOS tại môi trường GPT; container không truy cập GitHub qua DNS, nên **chưa thể chạy thực tế các script Python trên toàn cây, chưa build/ký và chưa có DEB thật để kiểm binary**. Không có bằng chứng ngoài xe; trạng thái = **SOURCE COMMITTED, DIRECT STATIC CHECKED / BUILD-PENDING / PACKAGE-PENDING / DEVICE-PENDING**.

### Cổng tiếp theo và đường rollback

1. Muse/Nguyen kiểm branch+HEAD, các điểm hunk với nhánh Muse, xác minh điều kiện runner; không gộp đè các file người khác. Kiểm `verify_hl34_keyboard_recovery.py`, xác nhận các gate cũ không mâu thuẫn trong runner, rồi khi được phép chạy **một** build FAT trên branch HL36 đã chọn bằng `workflow_dispatch`. Tránh CI tự chạy trùng.
2. Kiểm `verify_duocar_payload.py` trực tiếp trên file DEB thật, ghi run ID/artifact ID/version/SHA256/byte size/các slice/chữ ký/marker, kiểm đầu ra binary; nếu thất bại thì giữ build-fail, sửa đúng hunk, không phát hành.
3. Nguyen test một phiên gộp keyboard trên xe: cả hàng phím, chạm, nhập, thay đổi tỷ lệ, solo/full split, chuyển app, home, reconnect/restart; voice bubble không xuất hiện. Build PASS không phải DEVICE PASS.
4. Trước khi build nếu cần quay lui riêng đợt tách voice: revert `ab837e15`, `42bd55d9` theo từng hunk và chỉnh lại build-gates `07258c87`. Nếu quay toàn bộ HL36 thì lấy nền HL35 `1cc0820f`; không force-update nhánh Muse/main.



## 2026-11-12 — DEVICE VISUAL FAIL: bàn phím vẫn bị cắt ở ô YouTube

- Nguyen cung cấp **ảnh xe** ngay sau vòng HL36, đồng hồ hiển thị **16:35** (giờ hiển thị trên CarPlay, không tự suy thời điểm ghi file). Đang chia **YouTube bên trái / bản đồ bên phải**; khi tìm kiếm YouTube, hàng phím hiển thị tới `i` thay vì đủ `o,p`, hàng `asdfghjk` thiếu `l`, hàng `zxcvbnm` bị cắt ở mép; một dải danh sách/thumbnail YouTube còn nằm phía phải vùng bàn phím. **Kết luận sản phẩm: thất bại về hiển thị đầy đủ phím**. Không được báo HL36 bàn phím đã fix xong.
- Độ chắc chắn: đây là **ảnh quan sát thực tế**, nhưng ảnh riêng lẻ **không chứa PID, binary marker hay version**, nên chưa chứng minh hình thuộc đúng hash DEB HL36. Không gọi đây là runtime-proven ở cấp PID/version trước khi có log đúng phiên.
- GitHub Actions **build + package pass** run `43183267776` ở source SHA `4b671c5907dc113a690794ceedc49626609f2662`; artifact ZIP `13926903505`, DEB bên trong `com.chuong.duocar_1.0.3-hl36nativeonly_iphoneos-arm64.deb`, 1,339,388 byte, SHA-256 `673df26cf04cd9dbc93f4d8e8f6eec38a9f695ef1efac1dc6cc823e872608452`. Kết quả CI chỉ chứng minh cấu trúc/binary, **không có raster/touch pass**. Không trộn log HL34 và HL36.
- Đối chiếu **trực tiếp** source HL36: `ABKeyboardTraits104.m:ABKB104PlaceKeyboardWindow` chỉ ghi **`keyboard.frame=sceneWindow.frame`** sau khi packet width khớp key window; `ABKB104SetHostGeometry`/traits ghi `keyboardWidth` và `keyboardScreenReferenceSize.width`, nhưng không có cơ chế chứng minh **keyplane đã reflow** để 10 phím vừa trong khung sau split/scene. `ABInApp.m:ABNativeKbObserve` đo `UIKeyboardLayoutStar`, keyplane rect và ancestor clips; **không đo raster/touch**. Việc HL36 gỡ UI vẽ **không thay đổi thuật toán layout** HL34. **Giả thuyết cần xác minh:** keyplane/KeyboardLayoutStar rộng hơn vùng khả kiến hoặc cửa sổ bàn phím nằm dưới lớp UI khác. Chưa xác định chính xác clip owner/subview nên **không vá scale/frame bằng suy đoán**.
- Log `logs/DuoCar.log` mới nhất hiện chỉ ghi nhận commit `69906021153d4d9f3e2ca6479b4e5ff9a3f6480b` ngày 12/11 06:01:56 UTC (13:01:56 GMT+7), **trước** hình được người dùng đưa sau khi build; chưa có log HL36 đúng phiên để đối chiếu. File lớn 1.3 MB khiến GitHub connector `fetch_file` trả nội dung rỗng; không suy absence từ log blind. Không có nguồn xác nhận runtime đầy đủ của ảnh.
- Bằng chứng cần có trong **một phiên**: `[hl36-native-only]`, PID của app/CarPlay, `[hl23-kbphysical] send`, `[hl24-geometry] recv`, `[hl32-kbtraits] traits-width / hook-installed`, `[hl34-keyboard] native-window-placed`, `[hl25-kb-surface]`, `[hl27-keyplane]` vào đúng lúc bàn phím bị cắt; đối chiếu key-window/frame, logical/physical pane, LayoutStar width, keyplane right/clip/ancestor, hộp YouTube phủ; không log văn bản người dùng nhập. Khi đủ, sửa **một chủ geometry/clip** theo nguyên nhân rồi nghiệm thu trên xe.
- **Quyết định:** đánh dấu `HL36 VISUAL DEVICE FAIL / PACKAGE PASS`, chưa sửa source vòng tiếp, **không phát hành**; không dispatch build thêm trước khi xác định chủ cắt mất `o,p,l`. Nhánh đang ở HEAD `306dc8a39483e982f8ff0946b1b84cc04df291fe` tại thời điểm kiểm. CI HL36 đã chuyển về manual-only từ commit `306dc8a39483e982f8ff0946b1b84cc04df291fe`. File/hunk rollback về HL35 `1cc0820f` theo biên bản phía trên, không force push. Điểm tiếp tục: nhận log đúng phiên, nối PID+marker rồi chứng minh clip/raster, sửa đúng hunk, chạy 1 build và 1 lượt nghiệm thu thay vì lặp vá.
