# HL31 — DuoNavi 1.0.4 original forensic → CarPlay bubble → SpringBoard voice agent → Apple TTS
Ngày 2026-11-12. **Nguyen yêu cầu: bong bóng CarPlay PHẢI nghe, hiểu và nói phản hồi thành tiếng.** Không chỉ có icon; không mượn app iPhone foreground. Đây là yêu cầu nghiệm thu thiết bị, không được gọi PASS nếu chỉ có CI xanh.

## Nguồn gốc và phân công
Repository duy nhất code: `chuongnguyen89dn-ui/Omnicar`, cây thi công `recovered-source/`. Nền HL30 `c27ed0e7a9c2e17ea17425c391ee5fc766a0691e` được user kết luận DEVICE FAIL (keyboard phóng và solo, CarPlay mic không nghe, iPhone speech không nhận). Nhánh mới đã tạo một lần: `feature/duocar-hl31-duonavi-parity-20261112`; main code **chưa merge**, không deploy/Sileo, không gửi tin Muse. Source công việc GPT chuyên biệt, Muse phối hợp tích hợp cuối theo hồ sơ dự án, Nguyen nghiệm thu trên xe.

DEB gốc DuoNavi **1.0.4** SHA-256 `f3f911de5db461d487ce91249aed1bb25d44f076e7ff5fb89e54b658569328dd`, Dashboard dylib SHA `44fdd4b4df0e3cc277ca69f71129da356f3bd8d6af70e0fde1ef36f266b66d15`. Đã lấy gốc read-only từ archive qua GitHub Actions jobs:
- `43136504978`, artifact `13908040694` (voice/scene ARM64);
- `43136720837`, artifact `13908305117` (thêm PCM + callback);
- `43136895238`, artifact `13907827020` (đủ updateLayout);
- `43137306970`, artifact `13907807575` (bubble gesture/idle/tap/owner scan), đều **CI SUCCESS**.
Báo cáo JSON/TXT được tải và đọc trong container `/mnt/data/HL31_DuoNavi_*.zip`. Raw vendor binary **không được chép vào DuoCar runtime**.

### Bằng chứng phương thức ARM64 kiểm được (không suy ra runtime)
- `CBAIBubbleView.setupGestures` `0xbb55c`, `handleTap:` `0xbc3c4`: gọi `wakeBubble` rồi `onBubbleTapped` callback; `handlePan:` `0xbbb8c`, `snapToNearestEdgeAnimated:` `0xbc058`, `restartIdleTimer` `0xbb784`, `dimBubble` `0xbba38`, `setVisualState:animated:` `0xbc4a8`. 455 chủ phương thức được scan, có callback owner references trong `CBVoiceTransport.connectWithContext:completion:` và `CBVoiceSessionManager.setState:`, nhưng không chứng minh process/PID live.
- `CBVoiceSessionManager.startSession` `0x13eaf4`; `CBVoiceAudioCapture.startRecording:` `0x12c79c` (AVAudioSession/route/engine/STT); `CBVoiceSTTAppleOnDeviceProvider.startSessionWithInputFormat:error:` `0x12e404` có setter `setShouldReportPartialResults:` với w2=1; `audioCaptureDidTranscribeText:isFinal:` `0x140094`; `voiceTransportDidReceiveDirective:` `0x14025c`; `CBVoiceAudioPlayer` độc lập cho phát câu trả lời. Có nhánh cloud streaming/transport riêng dùng server/vendor URL, không sao chép.
- Installer original có postinst setuid helper `cboptimize_helper --grant-tcc` cho **SpringBoard** Microphone+Speech; đây là cơ chế đặc quyền làm khác biệt với iPhone app permission. Chỉ thấy postinst/helper manifest, chưa đảo ngược body helper. **Không mặc định quyền SpringBoard có sẵn**, không tự viết TCC DB; nếu log TCC bị từ chối, cần phép vận hành/phân tích quyền đúng, user phải quyết định trước khi động đến DB hệ thống.

## Source thật đã commit trên HL31
- `SCPVoiceBubbleView.m/.h` và mirror `src/SplitScreenA`: module riêng, callback bấm, pan, cạnh gần nhất, lưu bên trái/phải và normalizedY, idle 4s dim/wake, state idle/listening/thinking/speaking/error. Không thêm UIWindow, vẫn chính `SCPCarSplit.container`. Commit `4b1a06e9392a64554bcb92e013eebc505743b811`. Đã build thử bong bóng **43138108363 SUCCESS**, nhưng chỉ structural build, chưa xe.
- `SCPVoiceSpringAgent.m/.h` và mirror: process SpringBoard có observer nhận `voice.capture.request` từ CarPlay, chỉ start khi user chạm và pref enabled, kiểm TCC Mic+Speech, open AVAudioSession + AVAudioEngine, Apple Speech partial + silence 1.6 s/timeout 15 s, parser `DCVoiceParseCommand` whitelist; gửi typed `voice.action` đến **controller split hiện có**, nhận `voice.ack`; nhánh trả lời dùng **AVSpeechSynthesizer** trên SpringBoard, log tuyến output và report `speaking`. Mỗi mắt log `[hl31-voice-agent]` qua `OMCLogWrite`; không ghi audio/transcript, không tự bypass TCC.
- `SCPVoiceNative.m/.h` và mirror: bỏ capture local trong CarPlay, bong bóng gửi request có UUID/timestamp, nhận state từ SpringBoard qua chính `SCPVoiceBridge.m` observer. `SCPSpringBoardHooks.m` gọi `SCPVoiceSpringInstall()` **sau** original `applicationDidFinishLaunching:`, không thêm constructor trùng. Makefile chỉ thêm một source mới, reuse parser `../OmniCarApp/DCVoiceCommand.m` hiện hữu.
- `DCVoiceSession.m` + mirror iPhone: bật Apple Speech partial, debounce 1.6s nếu không có final, vẫn explicit permission/foreground; tránh bỏ mất lệnh ngắn. Commit `1a383640f3ef881b0b0ee4806d210b1b75d1beb3`. Build source agent + rebrand version `1.0.3-hl31voiceagent` atomic commit **`4a44cde9f14d19afbd065c04f794d7446cdfca2b`**, sửa test/check iPhone `1a383640`, sửa comment làm fail source guard `70c7c4870d407a0fca06989a150b2d0fdeb51402` (HEAD gần nhất tại lúc ghi). Các cặp agent, native, iPhone đã fetch_file/read-back SHA parity true.
- Workflow FAT `.github/workflows/build-fat-macos.yml` target `1.0.3-hl31voiceagent`; verifier HL29/30/31, payload, chữ ký + arm64/arm64e. Run đầu `43139803650` FAIL source verifier vì assertion nhầm `SCPVoiceDispatchLocalCommand(command)` tìm trong bridge (đã sửa đúng signature trong HL30 verifier); run `43140155291` FAIL vì comment chứa literal `TCC.db` mà test cấm; sửa comment trong một atomic commit, **run `43140397415` đang chạy** (trạng thái lúc cập nhật). Chưa có DEB mới đã kiểm được/hash, không tuyên bố completed.
- Trạng thái thẩm định: **SOURCE-COMMITTED + BUBBLE-ONLY CI PASS + VOICE AGENT CI PENDING, DEVICE FAIL/NOT TESTED**. TCC và tuyến TTS trên loa ô tô cần log thiết bị; CI không chứng minh khả năng nghe/nói.

## Gate đo khi có DEB và người dùng thử
Đúng DEB `com.chuong.duocar`, version `1.0.3-hl31voiceagent`, hash từ artifact cuối. Một ca **chỉ chạm bong bóng CarPlay, nói “chia hai ô”**, chờ câu trả lời nói thành tiếng. Đối chiếu cùng PID/version/time:
1. CarPlay `[hl31-bubble] event=tap-callback`, `[hl31-voice] event=bubble-request`.
2. SpringBoard `[hl31-voice-agent] event=observer-ready` và `event=request`, `event=permission` => Speech/mic authorized hoặc **springboard-tcc-denied**.
3. Nếu authorized: `event=capture-started` (input route), `event=pcm-frames count>0`, `event=stt-partial`/final hoặc error domain/code, không log chữ người nói.
4. `event=owner-dispatch` ở SpringBoard, `event=owner-ack` và CarPlay `event=agent-state`, actual UI cập nhật (không nhầm ACK accepted với device-proven).
5. `event=tts-started output=...` và `event=tts-finished`, **nghe âm thanh thật từ loa xe**.
6. Stop/close/disconnect/interruption: không còn mic capture, idle.
Nếu thiếu bất kỳ mắt nào, báo lỗi chính xác, không nói DONE. Nếu log chưa có là reader BLIND, không tự ghi ABSENT.

## Bước tiếp theo / rollback
Theo dõi **chính** run `43140397415`, đọc log khi fail, sửa đúng compile or verifier, đến khi FAT sign payload PASS; download artifact rồi kiểm DEB với `dpkg-deb`, Mach-O slices, sha256 và gửi **.deb** trực tiếp sandbox. Nếu lỗi runtime TCC cần permission grant của SpringBoard như original; đề nghị Nguyen cho phép kiểm tra/chốt thao tác cấp quyền phù hợp trước khi thay đổi DB. Không triển khai TCC helper lén hoặc tự cấp quyền; không phát hành Sileo.
Rollback source: HL31 speech to HL31 bubble-only commit `881938d9f47abf51cd73a660c014c2827d54330a`; HL30 full `c27ed0e...`. Local ZIP/temp không phải checkpoint bền vững; mọi source cập nhật qua GitHub connector create_blob/create_tree/create_commit/update_ref với expected_sha.
