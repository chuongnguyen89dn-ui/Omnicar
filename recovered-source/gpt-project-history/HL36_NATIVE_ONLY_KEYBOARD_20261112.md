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
