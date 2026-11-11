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

## 8. Bổ sung câu hỏi nút bấm trên ô tô (2026-11-11)
- **Màn hình CarPlay**: thực hiện được về kiến trúc bằng nút microphone riêng trong panel DuoCar hiện hữu; chạm gọi toggle one-shot voice session. Chưa viết source, chưa kiểm bố cục/hit test/touch/autoHide trên xe. Original DuoNavi 1.0.4 có `CBAIBubbleView`, `CBVoiceSessionManager.toggleSession` trong metadata nhưng chưa chứng minh thực tế bubble làm nút hay chạm trên xe đi tới selector nào.
- **Nút giọng nói vật lý trên vô-lăng**: Apple CarPlay giao nút nhấn giữ cho Siri; Apple Support: `https://support.apple.com/guide/iphone/use-siri-in-your-car-iph0aa8c80e6/26/ios/26`. Website DuoNavi `https://duonavi.com/vi` quảng bá điều khiển hands-free, nhưng không phải bằng chứng interception/điều khiển nút vô-lăng ở DuoNavi 1.0.4. Chưa có xref/IMP/hardware log original xác định đường button -> `toggleSession`; gắn nhãn UNVERIFIED. Không cướp nút Siri hoặc thay đổi audio route bằng suy đoán. Nếu muốn hỗ trợ nút vô-lăng, cần xác định đúng event, quyền ownership và tác động Siri trên iPhone/xe trước khi thiết kế.

## 8. Kiểm tra riêng nút vật lý trên vô-lăng (2026-11-11)
**VERDICT: STEERING BUTTON ACTIVATION = UNVERIFIED; không khẳng định bản 1.0.4 đã có, cũng không khẳng định không có.**
- Đã đọc `Duoface/docs/duoface_104_voice_linkage.md` blob `6f604ab64f70667e427579c6459ac5f65dcd57ad`: có `CBVoiceSessionManager.toggleSession`, `startSession`, `CBAIBubbleView` và nhận dạng tiếng nói, nhưng không có source-level/IMP xref từ sự kiện vô-lăng tới hàm toggle.
- Đọc hai inventory **đúng original DuoNavi 1.0.4** ở `Duoface/sideplay/audit/qa127-vs-duonavi-original-20261030/runs/41022357107/DuoNavi104_ALL_FILES_AND_BINARIES.json` blob `ed437b9e416ecf309dff750fafc428b9ee17408b` và `qa125-vs-four-original-real-debs-20261030/runs/41015886871/DuoNavi104_ALL_FILES_AND_BINARIES.json` blob `17cfc97c2fa0d97db9f01e6a0febd5675e154314`. Hai inventory tổng hợp không chứa marker Steering/Siri/CBVoice vì không quét toàn bộ method selector; **KHÔNG được diễn giải không thấy marker = ABSENT**.
- Đã đọc `Duoface/sideplay/README.md` blob `88236c0ec3519b8efe9fa6bab5f90129e53535a5` và `Duoface/sideplay/tiep tuc du an.md` blob `fad85e65964059f033c8d88e76f53c15b4ed6b8c`: không tìm thấy tuyên bố bằng chứng nút steering/voice toggle của gốc.
- Apple Support chính thức `https://support.apple.com/guide/iphone/use-siri-in-your-car-iph0aa8c80e6/26/ios/26` và /27: giữ nút voice command steering wheel kích hoạt Siri trong CarPlay mặc định. DuoNavi `https://duonavi.com/vi` quảng bá điều khiển rảnh tay; đây là marketing, **không phải bằng chứng map nút**.
- Chưa thể lấy original DEB 1.0.4 trong môi trường hiện tại để giải mã thêm; GitHub branch `spec-main` lưu tài liệu audit/bản report, không có file .deb trong tree đệ quy. Không giả định đường VM của Muse tồn tại. Để đưa ra YES/NO chắc chắn cần binary gốc 1.0.4 và disassembly mọi callsite của `CBVoiceSessionManager.toggleSession`/voice start; rà hook CarPlay/MediaRemote/Siri/presses/hardware; hoặc observer trên thiết bị với nút vô-lăng (cả nhấn ngắn và nhấn giữ) và marker từ original. **Không can thiệp Siri theo suy đoán**.
- Trả lời Nguyen: nút mic cảm ứng trong panel DuoCar khả thi với source mới; nút vô-lăng original 1.0.4 hiện **chưa chứng minh**, không đưa vào yêu cầu kỹ thuật đã xong.

## 9. Thiết kế cụ thể tích hợp DuoCar HL28: giao diện, nút, chức năng, hàm và rủi ro (2026-11-11)
**Đây là thiết kế đề xuất, không phải source đã được triển khai.** Nền giữ nguyên `feature/duocar-hl28-keyboard-settings-20261111`, commit `291e997c7df9077d166348902b0ce36701c501b4`. Không đổi phân công Muse, không đụng Cài đặt/Respring HL27, keyboard HL28, Dock, Home, menu/AutoHide/Wake, zoom/pinch trong lượt này.

### A. UI / icon (không copy CBAIBubbleView vendor)
- Một icon `mic` ở **lớp điều khiển chung của DuoCar** trên màn hình CarPlay (chưa chọn vị trí toạ độ cố định), tự tắt khi voice disabled; không tạo thêm app/icon CarPlay Home, không thay logo. Bubble nhỏ thể hiện trạng thái: idle, requesting-permission, listening, recognizing, confirming, success/error; nghe chỉ sau user tap. Mọi nút phải có hit target rõ, thoát được và không che nền quá mức.
- `SCPCarSplit+Chrome.m` hiện có **5 nút 48×40** trong action bar từng ô, kèm separator và lề. Không thêm nút thứ 6 vào bar này mặc định vì có khả năng tràn khi chia ô hẹp và đã có lịch sử overlay che nội dung. Tạo overlay riêng thuộc container/shared owner hoặc đặt cạnh logo **chỉ khi** đã đo không giao target vùng hit của logo, handle, divider, ứng dụng dưới. AutoHide `SCPCarSplit+AutoHide.m` hiện vẽ opacity=0 và tắt touch riêng cho homeButton; nút voice mới cũng phải có gate touch khi mờ/ẩn, cleanup khi close/solo/reconnect.
- Trên iPhone: Cài đặt UIKit `OMCNativeSettings.m` thêm section `Trợ lý giọng nói` gồm bật/tắt, ngôn ngữ vi-VN/en-US, ưu tiên speech on-device (chỉ khả dụng khi `supportsOnDeviceRecognition`), phản hồi âm thanh ON/OFF, nút thử microphone. Không đổi Root layout gốc tùy tiện.

### B. Pipeline / owner
```
car-touch mic button (only if visible / fresh session)
  -> DCVoiceUIController presents state+button
  -> typed IPC start {requestId, ownerSession, generation, deadline, origin}
  -> DCVoiceSession in authorized DuoCar app process:
     request user microphone + Speech permissions
     AVAudioSession owner gating + AVAudioEngine -> SFSpeechRecognizer
     at most one utterance, bounded timer, cancel/interrupt cleanup
  -> DCVoiceParser makes typed, allowlisted command (not free-form URL)
  -> typed command / ownerSession / expected layout+slot revision via IPC
  -> verified CarPlay split-owner SCPCarSplit calls EXISTING method
  -> acknowledgement+current state -> feedback bubble/optional AVSpeechSynthesizer
```
- CarPlay display process and iPhone sandbox **khác context**; `NSDistributedNotificationCenter` hiện có cho các việc ngắn và `SCPPostNativeSplitRequest` nhưng **không được giả định nó giữ iPhone app live để thu âm**. Source app `OMCAppDelegate.m` có `openURL:` tự suspend sau 300ms. Voice phải là lifecycle riêng; gate microphone CarPlay while phone app background = **UNPROVEN**. Nếu route/bảo vệ background chưa đạt thì chỉ hỗ trợ mic tại **app iPhone foreground**, không phát nút CarPlay giả có thể nghe.
- Não lệnh chạy ở process app được user cấp quyền, KHÔNG thu âm trực tiếp ở SpringBoard, KHÔNG dùng cboptimize_helper setuid hay sửa TCC.db của DuoNavi. Thứ tự lấy/nhả AVAudioSession: chỉ nhả nếu code chính nó đã chiếm; stop khi disconnect/Siri/điện thoại gọi/panel đóng/time-out/Respring; không ghi audio vào log, không gửi cloud khi chưa có opt-in backend minh bạch.
- Muốn on-device speech không qua network: kiểm `SFSpeechRecognizer.supportsOnDeviceRecognition` rồi set `SFSpeechRecognitionRequest.requiresOnDeviceRecognition=YES` khi hỗ trợ; nếu không phải báo không khả dụng hoặc xin user explicit cloud consent, không tuyên bố vi-VN offline mặc định. Apple docs `https://developer.apple.com/documentation/speech/sfspeechrecognizer/supportsondevicerecognition` và `https://developer.apple.com/documentation/speech/sfspeechrecognitionrequest/requiresondevicerecognition`.

### C. Bộ lệnh type-safe → điểm nối đã được đọc thực tế
- `mở [app] bên trái/phải`: resolve tên theo catalog/allowlist được user cho phép, `SCPCarSplit.openApp:slot:` (slot index 0/1; tài liệu source xác nhận tự phân nhánh hosted vs native và kiểm app, pinned-slot, pending). Không tự launch bundle chưa đăng ký.
- `chia 2 ô / 3 ô / kiểu chữ L`: `SCPCarSplit.urlLayout:` chỉ hỗ trợ layout ID `2,3,13,31`.
- `chia 50/50, 60/40`: `SCPCarSplit.urlRatio:` với số thực `0.2..0.8`, chỉ khi active, `paneCount==2`, không mainStack.
- `đổi chỗ hai ô`: `SCPCarSplit.urlSwap`.
- `bố cục yêu thích 1/2/3`: `SCPCarSplit.openFavorite:` trên cấu hình đã lưu.
- `phóng to/thu gọn ô số N`: `SCPCarSplit.urlZoomPane:` dùng index 1-based, không đồng nghĩa với **pinch fullscreen toàn DuoCar**. Giữ nguyên pinch gesture controller; không cho trợ lý gọi private zoom khác.
- `trạng thái`: đọc `split.active`, `paneCount`, `layoutID` và session freshness; phản hồi ngắn. Lệnh nguy cơ `closeSlot:background:`, kill/terminate và điều khiển xe không ở v1, đòi xác nhận và design riêng.
- Tất cả callback tác động UIKit/SCPCarSplit chạy đúng owner's main queue, ACK đúng thế hệ/nonce/slot/session, reject stale/not-visible/not-authorized/no-app. Bổ sung source module riêng và một observer nhỏ ở nơi sở hữu `SCPCarSplit`, không tạo engine hoặc Dashboard thứ hai, không sao chép implementation vendor. `SCPURLBlock` hiện ở `SCPSpringBoardHooks.m` chuyển URL thẳng thành dict; **không dùng một URL transcript tự do** vì nguy cơ gửi command không kiểm.
- Mọi tính năng chỉ *source design*, không có `DCVoice*` nào tồn tại trong HL28 khi kiểm (đừng báo đã có).

### D. Phần nút vô-lăng
- Theo Apple Support, nhấn giữ nút voice steering-wheel của CarPlay gọi **Siri**: `https://support.apple.com/guide/iphone/use-siri-in-your-car-iph0aa8c80e6/26/ios/26`. Không có bằng chứng original DuoNavi 1.0.4 có interceptor gắn `toggleSession`; STEERING BUTTON ACTIVATION = UNVERIFIED, không cướp nút Siri.
- Đường thực tế ít rủi ro hơn là **Siri Shortcuts/App Intents** cho một nhóm lệnh typed cho phép, vẫn thông qua Siri và chính các hàm `SCPCarSplit`, không thay thế Siri. Apple `https://developer.apple.com/documentation/AppIntents`, `https://support.apple.com/guide/iphone/use-siri-with-apps-iph0193a9d54/ios`. Shortcut chạy được từ Siri iPhone không đồng nghĩa đã chạy qua nút vô-lăng/CarPlay khi khoá máy; cần kiểm vật lý trước (có thể yêu cầu unlock).

### E. Mức khó và nghiệm thu
- Mức thấp/trung bình: iPhone permission-based press-to-talk, parser lệnh vi-VN trong whitelist, UI trạng thái, nối existing `SCPCarSplit` action, toggle Cài đặt.
- Mức khó cao/rủi ro: CarPlay touchscreen button hit-test/AutoHide layer, microphone route khi iPhone app không foreground, audio-session ducking/Siri interruption, ghép IPA/app entitlement rootless, băng tiếng Việt offline, rollback nếu Split/Keyboard/Respring regress.
- Không giải quyết bản quyền bằng cách copy `DuoNaviDashboard.dylib` và không tự cấp TCC; chỉ dùng ý tưởng luồng.
- Cổng thử đầu: iPhone foreground 10 commands allow/deny/cancel/interruption (no audio retained); UI icon overlap 0, inactive invisible/hit blocked, native/hosted input vẫn tương tác, log speaker/action ACK; kiểm voice từ ô CarPlay qua reconnect/close/solo/autohide, mới sau đó thử micro capture từ CarPlay button; giữ device baseline HL28 keyboard, settings, Home, Dock, pinch, menu. Lặp/đổi app không ghi transcript ra log và chỉ kiểm xe khi dừng.
- Không sửa source, không build/DEB/CI/publish/Sileo. Chỉ quyết định phạm vi và điểm nối; Nguyen nghiệm thu thiết bị, Muse integration theo phân công trừ khi đổi.

## 10. Tài khoản AI Free do người dùng tự sở hữu (2026-11-11) — research, chưa chọn triển khai
- Câu hỏi của Nguyen: liệu user DuoCar tự dùng tài khoản AI Free của họ để không cần chủ DuoCar cấp API/cõng chi phí. **Kết luận quan trọng: đăng nhập sản phẩm ChatGPT/Gemini không đồng nghĩa có quyền gọi API trong DuoCar.** Đây là kiểm chứng tài liệu nhà cung cấp, chưa có chức năng DuoCar.
- **ChatGPT Free:** chính sách OpenAI "Using your ChatGPT plan in other apps and sites" (https://help.openai.com/en/articles/20001542-using-your-chatgpt-plan-in-other-apps-and-sites) hiện cho phép người dùng đăng nhập tài khoản bất kỳ ở ứng dụng tham gia, nhưng **dùng hạn mức ChatGPT plan cho AI bên thứ ba cần Go/Plus/Pro/Business và đối tác hỗ trợ**. DuoCar chưa tham gia; Free account chỉ sign-in identity không cho app gọi AI bằng hạn mức Free. ChatGPT API vẫn tính/billing riêng theo https://help.openai.com/en/articles/9039756-managing-billing-for-chatgpt-and-the-api-platform. Không tự động lấy cookie/session, mạo danh ChatGPT app hay dùng browser automation để vượt hạn mức.
- **Gemini:** Google AI Studio Gemini API có **free tier** cho một số models, tốc độ/giới hạn tùy tier, có thể dùng người dùng **tự tạo project+API key** tại https://ai.google.dev/gemini-api/docs/get-started và https://ai.google.dev/gemini-api/docs/billing . Đăng nhập tài khoản Gemini app Free không tự chuyển quota của app sang DuoCar. Google có OAuth cho Gemini API nhưng tài liệu https://ai.google.dev/gemini-api/docs/oauth yêu cầu Google Cloud project/authorization; không khẳng định "Login Google" một chạm tự chuyển gói Free qua được.
- Nếu xây **Bring Your Own Key**: người dùng tự tạo Gemini AI Studio API key một lần, dán vào trang Cài đặt DuoCar; lưu Keychain (không ghi preferences hay log), giới hạn rate/budget, không in raw requests/audio, hiện quota error rõ ràng. Không bao giờ nhúng master API key vào DEB, không chia sẻ key giữa người dùng. Google cảnh báo free-tier dữ liệu có thể được dùng cải thiện sản phẩm; phải thông báo privacy rõ và xin consent trước khi gửi transcript. Phải xác minh chính sách thương mại/free tier tại lúc phát hành.
- Ưu tiên kiến trúc 3 tầng: (1) trợ lý điều khiển split local không API, (2) Gemini API Free BYOK tùy chọn, (3) provider khác hoặc server khi có nhu cầu. Trạng thái: **bằng chứng docs VERIFIED, lựa chọn sản phẩm CHƯA CHỐT, CODE/CI/DEVICE NOT STARTED**. Không thay HL28 keyboard/Settings.
