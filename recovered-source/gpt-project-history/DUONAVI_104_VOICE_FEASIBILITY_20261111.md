# Nghiên cứu khả năng tích hợp trợ lý giọng nói DuoNavi 1.0.4 vào DuoCar HL28
Ngày: 2026-11-11. Trạng thái: **đối chiếu tĩnh tài liệu/binary audit + source hiện có; KHÔNG sửa code, KHÔNG build, KHÔNG test xe**.

## 1. Nguồn xác nhận, định danh
- Nguyen sửa đúng phiên bản tham khảo: **DuoNavi 1.0.4** (không phải 1.1.4).
- Repo tham khảo độc lập: `chuongnguyen89dn-ui/Duoface`, branch `spec-main`, HEAD kiểm `bae9288ef356d0b6a05ee660b53716091df92184`, không chỉnh sửa repo.
- **Đúng binary gốc**: `dist/com.duonavi.app_1.0.4_iphoneos-arm64.deb`, SHA256 `f3f911de5db461d487ce91249aed1bb25d44f076e7ff5fb89e54b658569328dd`. Trong gói có `DuoNaviDashboard.dylib`, SHA256 `44fdd4b4df0e3cc277ca69f71129da356f3bd8d6af70e0fde1ef36f266b66d15`. Bằng chứng gốc: `Duoface/docs/duoface_104_voice_linkage.md` (blob `6f604ab64f70667e427579c6459ac5f65dcd57ad`, tài liệu dựng từ `llvm-objdump --macho --objc-meta-data`); `Duoface/sideplay/audit/qa127-vs-duonavi-original-20261030/runs/41022357107/DuoNavi104_ALL_FILES_AND_BINARIES.json` (blob `ed437b9e416ecf309dff750fafc428b9ee17408b`), xác thực control Package `com.duonavi.app`, Version `1.0.4`.
- Không nhầm với `Duoface/sideplay/deb-duonavi-1.0.3-12`: nhánh 1.0.3 cũ có `CBAssistantManager` và đường Google Speech API; **không gán kiến trúc/method của 1.0.3 cho 1.0.4**. Cũng không nhầm `DFVoiceAssistant` do dự án DuoFace tự viết ở version 0.1.105 với binary gốc DuoNavi 1.0.4.

## 2. Đã có bằng chứng trong bản gốc 1.0.4 (metadata, chưa runtime)
- `CBVoiceSessionManager`: `sharedInstance`, `toggleSession`, `startSession`, `setState:`, `announceErrorAndReset`.
- `CBVoiceAudioCapture`: `startRecording:`, `stopRecording`, `setMode:`.
- `CBVoiceAudioPlayer`: `appendAudioData:`, `playWithCompletion:`, `stopAndClear`.
- `CBVoiceSTTAppleOnDeviceProvider`: `startSessionWithInputFormat:error:`, `consumeAudioBuffer:`, `stopSession`.
- `CBVoiceSTTCloudStreamingProvider`: cùng 3 phương thức input/consume/stop; không có xác minh URL/nhà cung cấp đám mây hay privacy policy của bản 1.0.4.
- `CBVoiceDirectiveDispatcher`: `registerHandler:`, `dispatchDirective:completion:`.
- `CBVoiceSceneDispatcher`: `dispatchAppWithBundleID:launchURL:targetSlot:completion:`.
- `CBAppLaunchDirectiveHandler`: `canHandleDirective:`, `executeDirective:completion:`.
- `CBAIBubbleView`: `setupAuraPulse`, `setupCoreBubble`, `setupBrandingIcon`; type property linked vào native Dashboard.
- Speech/AVFoundation/AudioToolbox dùng trong original theo audit; các tên trên được chứng minh **có mặt trong Mach-O**, chưa chứng minh mỗi command đã chạy thực tế trên xe. Hệ thống voice **nằm trong cùng Dashboard executable**, không phải thư mục module tách sẵn.

## 3. Bằng chứng và rủi ro của installer DuoNavi gốc
- `DuoNavi104_ALL_FILES_AND_BINARIES.json` chứa postinst dùng helper setuid-root `cboptimize_helper`, gọi `--grant-tcc` để **ghi cấp phép Speech Recognition và microphone trước cho SpringBoard** (đường TCC.db). Là đặc điểm gói vendor, không phải API/sử dụng được phép tự động áp dụng. **Không port helper setuid, không chỉnh TCC.db, không mặc định cấp quyền micro**, không dùng cloud STT không rõ backend/user consent. Không trộn gói original vào runtime DuoCar, tránh xung đột bundle/class/scene và cả license.
- Khác nhau giữa metadata và hành vi: các class/directive có mặt ≠ đã đạt CarPlay device/đã nhận lệnh để mở app hoặc nghe voice background. Chưa có disassembly chuyên sâu các IMP voice 1.0.4 trong lượt này, chưa có log về audio ownership/microphone route/CarPlay microphone.

## 4. Đối chiếu DuoCar HL28 đã đọc trực tiếp
- Repo `chuongnguyen89dn-ui/Omnicar`, branch source hiện hành `feature/duocar-hl28-keyboard-settings-20261111`, HEAD `291e997c7df9077d166348902b0ce36701c501b4`, **bản sửa bàn phím và Cài đặt đang chờ test thiết bị**; không đụng code.
- `recovered-source/project/OmniCarApp/OMCAppDelegate.m` blob `824c6f4f8917faf1ce570c29353d26a35d5566c9`: root app là `OMCNativeSettingsRootController()`; URL command chuyển bằng `NSDistributedNotificationCenter` sang tweak rồi có đường `suspend` sau 300ms. Đường URL này **không phù hợp để giữ một phiên nghe microphone dài**, phải xây lifecycle riêng.
- `recovered-source/project/OmniCarApp/Makefile` blob `ac0f9ac4aff0e1396e01fbefa7b0c1741784439e`: có AVFoundation, nhưng **chưa link Speech.framework**, source app hiện thiếu voice assistant manager.
- `recovered-source/src/App/Info.plist` và `recovered-source/project/OmniCarApp/Resources/Info.plist` cùng blob `a812acf1ec8e581ba6a3aedc14eceb6646e09b24`: **chưa có** `NSSpeechRecognitionUsageDescription` hoặc `NSMicrophoneUsageDescription`; có photo usage only; rebrand script lúc build phải đổi nhận diện DuoCar trước đóng gói.
- `recovered-source/project/OmniCarApp/OMCNativeSettings.m` blob `e325f8f5b32acc6dd6d8664151d58a302718332d`: đã có giao diện UIKit, mục `SPLITSCREEN_SIRI` là Shortcuts (không phải voice engine) và `speedBubbleWarnVoice` (lời nhắc tốc độ, không phải STT).
- `recovered-source/project/OmniCarSplitScreen/SCPSpringBoardHooks.m` blob `6bf6ed5a282c0f62f7f9a5ab03a73f137a8159a5` có observer IPC native và Respring ACK trong SpringBoard; không mở thêm split owner, và không cho phép assistant tự đổi app khi session stale.
- Tham khảo **first-party có source** (khác original): `Duoface/sideplay/duoface-native-scene-host/DFVoiceAssistant.m/.h`, blob `8df077c0949e6fcd0b632866c4a3a314c251844d` và `31bd2709a55633e8151354a64b27af83901e7f80`: iPhone button-to-talk, Speech/AVFoundation, quyền tự xin, 12s cap, generation cancellation, chỉ release AVAudioSession do chính nó sở hữu, không can thiệp Siri/CarPlay/route. Source pattern tham khảo kiến trúc, **KHÔNG phải tích hợp gốc 1.0.4**.

## 5. Kết luận kỹ thuật và thiết kế đề xuất
**Có thể xây dựng tính năng tương đương về kiến trúc** theo chuỗi: button -> phiên nghe một lần -> STT -> parser/allowlisted directive -> xác nhận tình trạng session -> action trên owner DuoCar -> AVSpeechSynthesizer/status bubble. **Chưa có bằng chứng phép transplant nguyên binary**, nghiêm cấm chép `DuoNaviDashboard.dylib` hoặc `CBAIBubbleView` vendor vào DuoCar. Tách module mới (ví dụ `DCVoiceSession` thuộc UIKit iPhone app), không tạo Dashboard thứ hai và không nhân bản split engine.
- **Giai đoạn nền an toàn:** micro được bật **sau chạm rõ ràng**, popup xin quyền theo Apple, 1 lệnh/phiên, tối đa 10–12 giây, ưu tiên STT Apple vi-VN và en-US; hiển thị transcript + xác nhận cho lệnh tác động, trạng thái nghe/đang xử lý/lỗi; không bật lắng nghe liên tục và không lưu audio. Chỉ hỏi trạng thái/đổi app trong whitelist hoặc mở split bằng **điểm nối IPC hiện có**; đồng bộ session epoch/revision/slot, stale thì báo lỗi không thực hiện. Bật/tắt trong Cài đặt UIKit (không thêm PreferenceLoader logic). Không điều khiển xe, không ghi đè cuộc gọi/Siri/CarPlay playback.
- **Giai đoạn CarPlay UI sau khi chứng minh micro route:** một nút trợ lý ngay panel hiện có, AutoHide/Wake tương thích, không che các ô; phải thử riêng khả năng ghi âm khi iPhone app không foreground. Không giả định SpringBoard có quyền micro; không dùng vendor TCC bypass. Nếu voice process không thể nghe ổn định khi app background thì chỉ cung cấp trên iPhone hoặc thiết kế user-consent/eligible background audio đúng quyền.
- Voice result không được chuyển thẳng sang `openURL`/bundle launch bằng chuỗi tự do. Validate bundle trong catalog được duyệt, targetSlot có tồn tại đúng phiên, tránh chạm vào stock Siri/Settings/Phone. Cloud STT tạm **OFF** mặc định, chỉ triển khai sau khi xác minh vendor mới, privacy và user consent.
- **Điểm rủi ro lớn:** iOS TCC quyền Speech/Mic, audio-session routing/ducking, Siri/interruption, CarPlay phone/background lifetime, cơ chế audio in/out trong xe, lần lượt app-switch/pinch/kb/Respring. Đặc biệt phát âm thanh nói qua CarPlay cần nghiệm thu riêng; một phần STT hoạt động trên iPhone không chứng minh mic xe hoạt động.

## 6. Cổng tiếp theo nếu được giao triển khai
1. Kiểm lại LICENSE/ownership và disassembly selector/callgraph **chính binary 1.0.4** ở các IMP session/start/mic/STT/command/bubble, không dùng 1.0.3 làm bằng chứng 1.0.4; xử lý mọi bí mật/khóa API không in log.
2. Làm module voice iPhone first-party chỉ opt-in, thêm Speech.framework/Info.plist permission, UI trạng thái và disable, test quyền deny/allow/offline/interrupt/timeout/cleanup. Không sửa HL28 keyboard/Respring/Split ngoài IPC hook tối thiểu đã rà.
3. Ghép dispatcher type-safe vào controller split đang dùng; active lease, slot generation, transaction ACK, không cho command mở app tuỳ ý từ STT.
4. Chạy source verifier, compiler, một DEB FAT sau tích hợp (chỉ khi Nguyen giao build, không Sileo/merge); lấy đúng artifact/hash rồi chạy test thiết bị khi xe dừng. Không tự nhận DEVICE PASS.

## 7. Checkpoint thao tác và trạng thái
- GitHub connector read-only `get_repo`, `fetch` tree/branch, `fetch_file`; search code rỗng cho file vendor vì bản 1.0.4 là Mach-O, không phải source text.
- Chưa tạo nhánh, chưa sửa source, chưa CI/deb mới, không gửi yêu cầu cho Muse. Code HL28 giữ nguyên. Tuân thủ chia vai: nếu có triển khai giao diện/voice phải chốt điểm nối với Muse trước tích hợp.
- Đánh giá: **Original metadata VERIFIED (bằng báo cáo llvm-objdump đã lưu), khả thi kiến trúc INFERRED, CarPlay audio/mic UNVERIFIED, integration NOT STARTED.** Không gọi 'đã chạy trực tiếp llvm-objdump' trong lượt này vì dùng báo cáo repo.
