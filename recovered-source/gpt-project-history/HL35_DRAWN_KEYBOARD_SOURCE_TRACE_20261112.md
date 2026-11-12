# HL35 — Truy vết bàn phím vẽ OmniCar gốc; đối chiếu đường native DuoCar

Ngày kiểm trực tiếp GitHub: 2026-11-12 (Asia/Ho_Chi_Minh). Phạm vi: **read-only source audit**; không sửa code, không CI, không tạo DEB, không thử xe.

## Nguồn / phiên bản / trạng thái

- Repository **duy nhất**: `chuongnguyen89dn-ui/Omnicar`, cây thi công `recovered-source/`.
- Nhánh source kiểm: `feature/duocar-hl35-native-keyboard-only-20261112` HEAD **`1cc0820fc7a477c59ccadef1dce4943d1a8a4bd8`** (GitHub ref/commit, kiểm 2026-11-12); `feature/duocar-hl34-keyboard-recovery-20261112` hiện cũng trỏ cùng SHA (compare GitHub: identical). `main` ref lúc kiểm **`69906021153d4d9f3e2ca6479b4e5ff9a3f6480b`**.
- Không có local checkout, nên local dirty state/job VM không kiểm. Không tự suy code branch là DEB đã đóng hoặc thiết bị PASS.
- Bản đồ cơ chế trước đó đã có trong `recovered-source/handover/reports/map-m2-keyboard.md`, cùng các file disassembly `recovered-source/src/AppBridgeB/disasm/m_ABKeyboard_*.txt`; đây là **đối chiếu lại source hiện hành**, không tự nhận giải mã mới binary gốc.

## Đã xác định — cơ chế BÀN PHÍM VẼ gốc

1. **App nhận focus:** `project/OmniCarAppBridge/ABInApp.m`, `ABHook_TFBecome` / `ABHook_TVBecome` (khoảng dòng 3060–3078) → `ABResponderBecame` (3014–3030). Gốc tạo `UIView` zero-size để `setInputView:` thay bàn phím UIKit; marker `ABBlankInputViewKey` cho phép trả `inputView=nil` đúng responder tại `ABRestoreBlankInputView` (2975–3012). Trên nhánh HL35 đường suppress có cổng `ABDrawnKeyboardActive()`, không chạy khi native.
2. **Đăng yêu cầu:** `ABKeyboardPublish` (3090–3133) đóng trạng thái 64-bit: bit 0 shown, bits 1–7 UIKeyboardType, bits 8–15 returnKeyType, FNV-1a hash bundle ở bits 24+; phát Darwin notify `ABNotifyKeyboard` = `com.anlai.omnicar/appbridge.keyboard` (channel names file). Trên HL35 `ABDrawnKb=NO` cache tại ABInApp.m khoảng dòng 553, và publisher return sớm tại 3099 khi native.
3. **SpringBoard/host tiêu thụ:** `project/OmniCarAppBridge/ABHostGeometry.m` `ABKeyboardDispatch` (437–479): giải hash/flags, chỉ `showForApp:keyboardType:returnType:` khi `ABDrawnKeyboardEnabled()`; lệnh hide vẫn dọn panel cũ.
4. **Vẽ panel CarPlay:** `project/OmniCarAppBridge/ABKeyboard.m`, `ABKeyboard : NSObject`, `ABKey : UIButton`, singleton `+shared`. `showForApp:` (276–311) gắn panel lên `[ABHost shared].carWindow`, `buildPanel` (477+), `layoutPanelIn:` (561+), `rebuildKeys` (584+) và `layoutKeys` (647+); phím có `paint:`, `setHighlighted:`, gradient; hàng chữ/số/shift/lang/space/return; `typeCharacter:` + `ABTelexApply` (từ `ABTelex.m`) tạo ký tự.
5. **Lệnh gõ trả về app:** `ABKeyboard.send:del:text:` (ABKeyboard.m 247–255) gửi `NSDistributedNotificationCenter` tên `ABChanKey` = `com.anlai.omnicar/appbridge.key`, object là bundle đích, userInfo action/del/text. `ABInApp.m` `ABInstallInAppObservers` (2909–2910) nhận thông qua `ABKeyBlock` (2871–2898), gọi `deleteBackward`, `insertText`, return hoặc `resignFirstResponder`. Đây là **relay text**, không phải bàn phím native của iOS.

## Thực trạng ở HL35 — CHƯA GỠ HẲN

- Ở chế độ native, publish trên app bị chặn, host không gọi show panel, và suppression chỉ chạy với drawn gate. **SOURCE-PROVEN** là đường hiển thị bàn phím vẽ bị vô hiệu trong chế độ native.
- **Tuy vậy**, `project/OmniCarAppBridge/Makefile` dòng 12 **vẫn liệt kê `ABKeyboard.m` và `ABTelex.m`** trong `OmniCarAppBridge_FILES`; lớp panel, channel observer `ABChanKey`, dispatch `ABKeyboardDispatch`, cùng đường `setInputView` có cổng vẫn ở source. Do đó **KHÔNG** thể gọi là “đã bỏ bàn phím vẽ khỏi DEB”; chưa kiểm file DEB HL35.
- Đường native trên HL35 còn `ABKeyboardTraits104.m` và `ABNativeKbBegin`/observe/scene geometry; đây là cơ chế **khác**, đang cần nghiệm thu về keyplane, clipping, độ ổn định. Không nhầm việc loại bàn phím vẽ với việc đã sửa xong bàn phím hệ thống.

## Phương án tiếp — chưa thực hiện

- Nếu yêu cầu là **loại hoàn toàn custom keyboard khỏi bản DuoCar**: phân tích tham chiếu rồi bỏ `ABKeyboard.m` và các phần Telex chỉ dùng cho panel khỏi danh sách biên dịch; xóa hoặc vô hiệu theo điểm nối `ABChanKey` receiver và Darwin panel dispatcher, nhưng **giữ** hooks first-responder và telemetry/sustain thật sự cần cho native keyboard + BridgeWake; tránh ghép nhầm kênh kb-sync của panel vào trạng thái native.
- Kiểm static trước build: zero compiled `ABKeyboard/ABKey` classes, zero active relay `ABChanKey`, zero `setInputView:blank` ở native; không có unresolved symbol; hai cây src/project khớp; native keyboard owner duy nhất và đầy đủ phím.
- Chỉ khi chính DEB tổng hợp được kiểm payload/binary và Nguyen thử xe mới phân định **PACKAGE PASS** / **DEVICE PASS**; không lấy việc nhánh được đặt tên `native-keyboard-only` làm bằng chứng.

## Checkpoint

Đã xong: truy đúng source/IPC/render/return của bàn phím vẽ, xác nhận native gate và tồn dư trong build list. Chưa làm: xóa code, build/đóng DEB, kiểm byte-level payload, xe. Bị chặn nghiệm thu: chưa có bản build/test xe cho việc loại bỏ này. Tiếp theo: chỉ sửa source khi được giao; thực hiện trên branch có HEAD xác thực, kiểm xung đột mới từ Muse, không copy đè file dùng chung; giao một DEB tổng hợp qua đúng quy trình và kiểm file thật.
