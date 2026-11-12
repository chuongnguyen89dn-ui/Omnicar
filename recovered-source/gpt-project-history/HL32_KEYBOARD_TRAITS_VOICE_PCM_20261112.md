# HL32 DuoCar — keyboard traits/keyplane + voice PCM readiness (2026-11-12)

## Mục tiêu / bất biến
Theo yêu cầu Nguyen: sửa bàn phím DuoCar với cơ chế traits/keyplane tham khảo **đúng** DuoNavi 1.0.4 SHA-pinned, sửa voice chạy từ bong bóng CarPlay, giữ Home/Dock, pinch, YTZ, AutoHide, menu gốc, settings/respring, native feed. **Không sửa TCC DB, không cấp quyền ngầm, không sao chép DuoNavi binary, không merge main, không Sileo**.

## Nền và nhánh
- Repository thi công duy nhất `chuongnguyen89dn-ui/Omnicar`, cây `recovered-source/`.
- Nền HL31 `70c7c4870d407a0fca06989a150b2d0fdeb51402`, sản phẩm HL31 FAT run `43140397415`, nhưng voice/keyboard thiết bị chưa PASS.
- Nhánh mới `feature/duocar-hl32-keyboard-voice-20261112`; trước tạo đã kiểm chưa tồn tại và HEAD nền đúng.
- Commits trên nhánh, theo thứ tự đã xác thực: `8ef057e39e90e8d1592238d4d3132f73a1eafa9f` (traits 7 files); `70b6eaeef6fae3d50b6db2fab9a3d92961c06839` (voice PCM + native, 6 files); `8ed592888ea17cecdd1b9690b54b70d442efb3f7` (tests/workflow/rebrand 7 files); `ec98b7be482042c985b1c2cdfb3973511debe9d6` (fix exact legacy probe string + CGSize ABI); `4f13d1ea14381afef35d382b88e24125262cf689` (fix iOS SDK AVAudioPCMFormatFloat32). HEAD kiểm gần nhất `4f13d1ea`. Không có checkout local để đánh giá dirty; GitHub commits là trạng thái bền vững.

## Keyboard source đã sửa (SOURCE-COMMITTED, không DEVICE PASS)
- Cặp `project/OmniCarAppBridge/ABKeyboardTraits104.m/.h` ↔ `src/AppBridgeB/ABKeyboardTraits104.m/.h` mô đun mới. Hook UIKit private tùy chọn và kiểm selector+signature: `UIKBScreenTraits traitsWithScreen:orientation:`, `keyboardWidth`, `keyboardScreenReferenceSize`; `UIKeyboardLayoutStar setKeyboardName:`, `setKeyboardName:appearance:`, `setKeyplaneName:`, `setScreenTraits:`. Một chủ width lấy từ scene logical/actual host key UIWindow, guarded by hosted/main thread. Không dùng original vendor runtime code. `setKeyboardWidth:` và idiom emulation có ABI guard, fail closed. CGSize getter return-length guard.
- `project/OmniCarAppBridge/ABInApp.m` và mirror `src/AppBridgeB/ABInApp.m`: truyền `physicalW/logicalW`, orientation, revision vào module, gọi hook trước first responder và cập nhật traits trước layout. Bỏ `keyboard.transform=CGAffineTransformMakeScale(scale,scale)` gây `744/375=1.984>1.6` bị reject; giữ fit frame/window single owner và restore khi hide/focus/host release; giữ log/keyplane clip probes, không động trực tiếp `UIKeyboardLayoutStar.transform` hoặc reloadInputViews. `Makefile` AppBridge thêm module. **Chưa chứng minh private hooks install/fires trên iOS 16.7.16 hoặc raster/touch đúng**.
- Source test cũ HL30 đã được cập nhật theo thế hệ HL32, không còn đòi giữ transform gây lỗi; test HL32 xác nhận giữ giới hạn quyền và hình học. Nghiệm thu phải kéo 35:65 → 50:50 → 65:35 → solo → ngược, phím bên phải/bên dưới có hình và nhận touch, không che nội dung hay gây lag, về iPhone native restore.

## Voice source đã sửa (SOURCE-COMMITTED, không DEVICE PASS)
- `project/OmniCarSplitScreen/SCPVoiceSpringAgent.m` và `src/SplitScreenA/SCPVoiceSpringAgent.m`: giữ SpringBoard user-initiated voice agent, permission gate của đúng process; **chỉ gửi listening sau PCM callback đầu tiên**, engine.start trước đó là requesting. Timeout 2s không PCM báo `no-pcm-frames`, log input route và RMS ngắn (không log raw audio/transcript); Apple STT partial và online opt-in qua pref; wait ACK before new session; TTS có output port marker nhưng không khẳng định âm thanh đã nghe trên xe. `SCPVoiceNative.m` và mirror bubble hiển thị giai đoạn requesting/PCM confirmed, lý do lỗi.
- Giữ original bubble, typed command parser/whitelist, owner ack; không code grant TCC; user cần phê duyệt trước nếu muốn phương án cấp quyền riêng. **Không tự kết luận SpringBoard TCC bị deny khi chưa có log**; giọng nói vẫn có thể không chạy nếu không cấp được Microphone/Speech.

## Kiểm chứng đã chạy thực tế và trạng thái hiện thời
- 5 cặp source/project đã fetch_file+SHA parity bằng GitHub connector: `ABInApp.m`, `ABKeyboardTraits104.m/.h`, `SCPVoiceSpringAgent.m`, `SCPVoiceNative.m` — 5/5 bằng nhau. Kiểm source 15/15 điều kiện trực tiếp bằng dữ liệu GitHub (không phải thiết bị).
- CI FAT workflow `.github/workflows/build-fat-macos.yml` push-trigger trên nhánh HL32 (không tự dispatch trùng).
- Run `43147567164` commit `8ed59288`: FAILED do verify HL25 test dùng đúng string cũ của call observe; HL24 PASS; đã sửa giữ định dạng thân hàm trong commit `ec98b7be`.
- Run `43147825354` commit `ec98b7be`: HL22–HL32 source, parser, rebrand PASS; FAILED ở `Build the package (arm64 + arm64e)`; đã sửa tên enum audio PCM hợp lệ từ `AVAudioPCMFormatPCMFloat32` sang `AVAudioPCMFormatFloat32` trong `4f13d1ea`.
- Run `43148151634` commit `4f13d1ea`: **in_progress** lúc kiểm gần nhất 2026-11-12; đã PASS HL8, HL22, HL24/25, HL26–HL32 source/tests, parser, rebrand, hiện đang ở bước build FAT. **Chưa có artifact/hash/DEB HL32 đã được xác minh** tại thời điểm checkpoint này, không tuyên bố package PASS.
- Gói/version mục tiêu `com.chuong.duocar`, `1.0.3-hl32traitsvoice`, `arm64 + arm64e`; workflow upload `duocar-hl32-traitsvoice-fat-deb` nếu PASS. Test asset phải được trích từ artifact cuối, đối chiếu hash/payload/8 FAT signed, chỉ sau đó mới link .deb trực tiếp.
- GitHub main chỉ lưu GPT docs, code HL32 **chưa merge**. Rollback về HL31 `70c7c487`.

## Việc cần làm tiếp / điều kiện kết thúc
1. Kiểm trực tiếp run `43148151634` conclusion/steps; nếu compile fail, đọc đúng job logs, sửa file/hunk và xác nhận retry push; không chạy trùng CI, không tạo DEB thiếu binary.
2. Khi PASS tải ZIP artifact, tách file `.deb` không bắt Nguyen tải ZIP, kiểm SHA256, control Package/Version/Architecture, 8 binary slices+signature và marker keyboard/voice, báo artifact ID và hash.
3. Nguyen thử xe kết hợp một phiên: 35:65→50:50→65:35→solo→ngược, kiểm đủ mọi phím và touch; nhấn bubble CarPlay nói `chia hai ô`, nghe lời trả lời ở loa xe. Log cùng PID/marker: `[hl32-kbtraits]` (hook installed, width, clip), `[hl32-voice]` (permission, routeIn/out, PCM count/RMS, STT partial, owner dispatch/ack, TTS started/finished). Nếu TCC báo denied, dừng để xin phê duyệt giải pháp hợp pháp/phù hợp trước khi thay đổi quyền; **không tự cấp quyền**.
4. Không nhầm BUILD PASS với RUNTIME/DEVICE PASS; không có log không chứng minh ABSENT (BLIND).
