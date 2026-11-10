# OmniCar HL6 — GPT trực tiếp sửa Logo, Wake và Pinch toàn giao diện (2026-11-10)

**Nhãn:** SOURCE COMMITTED + STATIC/PARITY REVIEW. CHƯA BUILD, CHƯA CI, CHƯA TEST XE; không gọi DEVICE PASS.

## Lệnh mới và mục tiêu
Theo lệnh mới của Nguyen, GPT trực tiếp sửa cả ba đường Logo, Wake và Pinch (thay phân công cũ giao những mục này cho Muse); Muse chỉ tích hợp vào source mới nhất rồi build/ký MỘT DEB. Phần khác của Muse (YTZ, picker, keyboard, feed, native scene, hình học khác) không tự ý sửa.

**Định nghĩa pinch đúng của Nguyen:** hai ngón bung ra mở rộng **cả hai ô** của OmniCar đến fullscreen và **ẩn dock CarPlay**; hai ngón thu vào trả toàn bộ split cùng dock. KHÔNG phóng video YouTube, không solo một ô, không tạo fullscreen engine thứ hai. Giữ SCPFullscreenController qua SCPPinchController.shared.adapter làm nguồn trạng thái duy nhất.

## Mốc nguồn và dữ kiện HL6
- Repo duy nhất: chuongnguyen89dn-ui/Omnicar; cây thi công recovered-source/.
- Main HEAD tại lúc nhận việc: 817bf872c9eb2eb1e98858e808593b83cdee16dc. Log upload cùng commit: logs/OmniCar.log và logs/OmniCar.log.old.
- Log phiên xe HL6 2026-11-10 ~11:13–11:19 ICT: CarPlay PID 40220, YouTube PID 40229, các marker [logo-hit], [picker-surface], [pinch2] began xuất hiện. **HL6 cũ ĐÃ chạy trên xe**; cùng control Version 1.0.3 vẫn là lỗi đóng gói nhưng không chứng minh HL6 chưa cài.
- Logo: 17 lần reveal cùng hitWin={{0.5, 172}, {44, 44}}, bị đặt ở dải dock trái vì launcherCenterInParent tính theo dock; splitRole chỉ đổi size=34, bare và clamp parent.bounds.
- Wake: bwHandleWakePacket gọi setBarVisible:YES trên mọi wake hợp lệ, nên chạm gọi logo đồng thời mở menu ô. Định nghĩa HIDDEN còn phụ thuộc pane.bar.isHidden, cần sửa đồng bộ ACK/AutoHide.
- Pinch: YouTube nhận 54/54 [pinch2] began touches=1 distinct=1 tracked=0; không có toggle-sent/toggle-applied. Các record [touchset] active=2 thường là hai bản sao cùng tọa độ/thời điểm ở các cửa sổ khác nhau hoặc đối tượng window=nil; KHÔNG được gọi nhầm là hai ngón độc lập.

## Nhánh và commit đã xác minh trên GitHub
Nhánh riêng: feature/hl6-logo-wake-gpt-20261110, tạo từ main 817bf872. Có ba commit SOURCE:
1. 58539895e8902e00d4ddd2f7b1e47477febd0485 — Logo theo appArea; định nghĩa HIDDEN, wake/reveal không mở bar; sửa ACK mirror.
2. 0581d23233f3ac2a320b621cdc0d1b12a7910026 — theo dõi hai ngón thật ở CarPlayApp và gọi adapter fullscreen có sẵn; mode loại chồng hai recognizer.
3. 234c52074dfe60af82773fbcfef6b674c4b94d16 — cho phép hai ngón trải trên hai ô đang sống, kiểm membership ở formation + fire, hủy khi popup xuất hiện.

Tại lần compare sau ba commit: ahead=3/behind=0, đúng 10 file path. Chưa merge main.

## File/hunk và hợp đồng
- src/SplitScreenA/SCPCarSplit.m ↔ project/OmniCarSplitScreen/SCPCarSplit.m: khi splitRole, tính center=(maxX-28,minY+28) trong giao appAreaInParent với parent.bounds; không dùng dock placement; hit 44pt nằm trong appArea, không bị throttle một giây giữ tâm cũ; marker [logo-geometry].
- src/SplitScreenA/SCPCarSplit+BridgeWake.m ↔ project/OmniCarSplitScreen/SCPCarSplit+BridgeWake.m: HIDDEN khi AutoHide thực sự faded và không popup (không đồng nhất đóng bar với ẩn controls); wake không gọi setBarVisible:YES; thiết lập WAKING trước reveal, push frame confirm khi đang chờ; marker [wake-ui]. Mode bridgewake.carHostPinch (vắng=YES) gửi pinchMode OFF cho app và tắt recognizer container cũ để tránh double toggle; mode NO trở lại đường legacy.
- src/SplitScreenA/SCPCarSplit+BridgeWake.h ↔ project/OmniCarSplitScreen/SCPCarSplit+BridgeWake.h: accessor bwCarHostPinchEnabled.
- src/AppBridgeA/src/ABChannels.m ↔ project/OmniCarAppBridge/ABChannels.m: SpringBoard role=1 ACK dùng chứng cứ handleHidden=NO và faded=NO thay vì buộc bar phải mở; snapshot sau applyFade, có fallback kiểm 120ms sau arm và timeout gốc 800ms. Không đổi payload ACK.
- src/SplitScreenA/SCPTouchProbe.m ↔ project/OmniCarSplitScreen/SCPTouchProbe.m: tận dụng đúng hook UIApplication sendEvent: CarPlayApp hiện hữu; orig chạy trước và nguyên vẹn; dedup bản sao contact cách nhau <=12pt, event Began <=50ms; chỉ ghép hai điểm độc lập ở ô live với khoảng cách đầu >=26pt, Began cách nhau <=1.2s, tỷ lệ bung >=1.10 / thu <=0.90, loại drag bằng midpoint drift; một command cho mỗi pair; gọi adapter existing để nới TOÀN split/ẩn dock hoặc khôi phục; log [car-pinch] pair/request/expand applied/restore applied/mirrored. Không biến hai lần chạm đơn kế tiếp thành pinch, không can thiệp sendEvent hay feed.

**Parity sau commit thứ 3, đã FETCH lại từ GitHub:** cùng nội dung giữa src và project ở mọi cặp, trừ 3 đường import vốn khác cấu trúc hai cây (SCPCarSplit.m 2, BridgeWake.m 1). Không có thay đổi YTZ, AutoHide painter, picker, video YouTube hay keyboard.

## Điều đã kiểm / chưa kiểm
Đã kiểm trực tiếp bằng GitHub connector: repo, main/branch HEAD, CI gần nhất trước code, ba commit SOURCE, compare, nội dung thực tế 10 file, marker và parity. Không có checkout local/build Theos hoặc lệnh test compiler trong lượt này. Các thao tác thực tế: GitHub fetch_file, fetch git tree/branch/log, create_branch, create_blob/create_tree/create_commit/update_ref có expected_sha, và đọc lại file. KHÔNG giả lập terminal build. Chưa có artifact hash/version mới và chưa có car PID chạy code GPT.

**Rủi ro còn mở:** nếu CarPlay thực tế không phát hai contact phân biệt lên UIApplication sendEvent, host detector không có đủ dữ liệu để nổ: không suy rằng code đã giải quyết trên xe; phải nhìn thấy [car-pinch] pair -> request -> expand applied=1 -> restore applied=1, đồng thời có hình xe full split không dock và thu về có dock. Wake ACK vẫn chờ test riêng; một ACK timeout HL6 cũ không chứng minh đã được sửa trên xe.

## Muse tích hợp một DEB, không giao lại phần code này
Đọc HEAD main MỚI NHẤT và các commit GPT theo thứ tự, ghép TỪNG HUNK chứ không copy nguyên file/module; giải quyết overlap với Muse tại SCPCarSplit, BridgeWake, ABChannels, SCPTouchProbe. Đồng bộ src/project đúng Makefile thực tế. Trước build xem workflow/job đang chạy tránh CI trùng. Build/ký MỘT DEB, kiểm control Package/Version/Architecture, hash, size, arm64/arm64e theo hợp đồng build, markers từng slice. **Control Version phải khác 1.0.3**, ví dụ 1.0.3-hl7; tên file không thay thế Version. Không tự publish Sileo.

Nguyen test xe đúng DEB mới và quay hình: Home icon OmniCar gọi panel; vào split sau fade, chạm wake chỉ khôi phục logo/chrome cần thiết KHÔNG tự bung bar; hit rect logo ở góc trên-phải của vùng app; pinch bung cả 2 ô phủ màn & ẩn dock, thu cả split trả dock; thử ngón cả ô hosted/native và trải qua ranh hai ô; picker/thay app/reconnect/teardown không tạo lần pinch giả, không mất logo/ACK. Đối chiếu mốc PID + version + artifact SHA để tránh nhầm HL6 cũ. Static/signed DEB không thay thế DEVICE PASS.

## Rollback / điểm tiếp nối
- Tắt mới host pinch bằng pref bridgewake.carHostPinch=NO, phát prefs changed; quay về recognizer in-app cũ để khoanh vùng. Rollback code pinch: revert 234c520 rồi 0581d232 trên nhánh tích hợp; rollback Logo/Wake thêm 58539895 nếu cần, không force main.
- Không tự merge/main, dispatch CI, build/ký, phát hành Sileo, liên lạc Muse ngoài chat. Đầu mối hồ sơ này liên kết từ README.md trong cùng thư mục. Không copy code Git sang repo khác.
- Tiếp: Muse chỉ ghép/build/ký artifact, Nguyen test, GPT đối chiếu video/log HL7 với mốc [logo-geometry]/[wake-ui]/[car-pinch] và các marker ACK; nếu vẫn 0 pair thật thì đo nguồn multi-touch, không bịa hai ngón từ bản sao.

## Bổ sung 2026-11-10 — GPT kiểm CHÍNH DEB HL7 sau Muse CI build (BINARY VERIFIED, chưa test xe)

**Nhãn trạng thái cập nhật:** HL7 CI BUILD PASS + ARTIFACT BINARY/CONTROL/ARM64+ARM64E MARKERS/SIGNATURE-HASH VERIFIED; vẫn **CHƯA DEVICE PASS**. Các dòng "chưa build" ở trên chỉ đúng tại thời điểm commit SOURCE, không còn là trạng thái mới nhất của bản tích hợp HL7.

**Bằng chứng CI:** workflow build-fat-macos run **42759723768**, run_number 68, event workflow_dispatch, branch ci-fat-test, head **5e7e301e2bcc79b23f6f750e31f2917d3ba2d9cc**, job build-fat **129642317955**, completed success (10 step workflow thành công). Artifact ID **13736992542**, name omnicar-fat-deb, 2026-11-10T05:07:41Z. ZIP **1.263.717 B**, SHA-256 **d71f77ae40a7f1272b947867462b1a0a5a0ce8b019b2ebb67e38fde31dac2683** (digest CI trùng hash tính lại trên file tải bằng GitHub connector). CI trước đó run 42759108623 FAILURE do hardcoded tên DEB theo Version 1.0.3; commit 5e7e301 sửa verify/upload dùng HL7; run mới PASS.

**Đã tải & kiểm artifact thật:** GitHub connector action download_workflow_artifact(id 13736992542) → ZIP local /mnt/data/omnicar-hl7-fat-artifact.zip; unzip và lấy file **com.anlai.omnicar_1.0.3-hl7_iphoneos-arm64.deb**, kích thước **1.263.168 B**, SHA-256 **5c9b2077c777196fd55dbe4019d48acebc71152c958c2ecea45cbc3117fb4ce9**. Không nhầm ZIP hash với DEB hash. AR entries debian-binary, control.tar.gz, data.tar.lzma; dpkg-deb -f: Package=com.anlai.omnicar, Version=1.0.3-hl7, Architecture=iphoneos-arm64, Depends=mobilesubstrate>=0.9.5000/preferenceloader/firmware>=15.0. Lệnh dpkg --compare-versions xác nhận 1.0.3-hl7 > 1.0.3. Artifact ZIP chỉ chứa **một** DEB HL7 (không chọn bản 1.0.3 cũ đang nằm cạnh đó trong working dir CI).

**Binary FAT:** file/lipo trên chính file trích DEB: đủ arm64 + arm64e (PAC00) cho 6 dylib OmniCar (Core, AppBridge, CarProbe, SpeedBubble, SplitScreen, StartupScreen), Prefs bundle binary và app binary; SplitScreen file 1.307.664 B, AppBridge 668.160 B. CI cũng xác nhận 7 thành phần FAT. Không nhầm Architecture iphoneos-arm64 (metadata rootless) với thiếu slice.

**Dấu hiệu code đã biên dịch trong CẢ HAI lát binary:**
- OmniCarSplitScreen.dylib arm64 và arm64e: [logo-geometry]×1/lát, [wake-ui]×1, [car-pinch]×8, [car-pinch] pair panes=×1, [car-pinch] request×1, [car-pinch] expand applied=×1, [car-pinch] restore applied=×1, bridgewake.carHostPinch×1, [fs1] fs expand confirmed×1 và restore confirmed×1.
- OmniCarAppBridge.dylib arm64/arm64e: [bridgewake] host ack role=1×1 và handleHidden=×1; legacy [pinch2] trigger=began toggle-sent vẫn có bytecode nhưng được mode owner OFF khi host pinch bật (theo source).
- 5 file build staging trong commit CI **SHA blob trùng tuyệt đối** file tương ứng trên tip GPT code: SCPTouchProbe.m, SCPCarSplit.m, SCPCarSplit+BridgeWake.m/.h, ABChannels.m (project tree). Kiểm qua fetch_file ref CI vs ref GPT, không chỉ suy từ commit ancestry.

**Chữ ký:** parse LC_CODE_SIGNATURE trên 8 Mach-O trong DEB, cả arm64/arm64e: đều có embedded signature SuperBlob 0xfade0cc0 và CodeDirectory SHA1/SHA256; script kiểm độc lập đọc CodeDirectory, băm lại TỪNG trang code ở cả hai slice (8 binary × 2 arch × 2 CodeDirectory), kết quả **PASS tất cả hash page**. Đây là **chữ ký nhúng nội tại nhất quán**, KHÔNG tương đương kiểm trust chain Apple hay xác nhận runtime được substrate nạp. Không tuyên bố Apple-signed hoặc device-pass.

**Công cụ/lệnh thật:** GitHub fetch workflow runs/jobs/artifacts, fetch_file CI/ref, download_workflow_artifact; trong container unzip -l/-oq, sha256sum, dpkg-deb -f/-I/-x/-e, ar t, file, llvm-objdump --macho --universal-headers và --private-headers, dpkg --compare-versions; Python struct/hashlib cục bộ parse FAT/LC_CODE_SIGNATURE/CodeDirectory trong `/mnt/data/omnicar_hl7_verify/verify_binary.py` và `check_codesign.py`. Các đường /mnt/data là bản kiểm tạm, GitHub artifacts/commit là tham chiếu bền.

**Phán quyết tích hợp:** DEB HL7 đủ điều kiện **chuyển sang vòng TEST XE** về mặt package, version, hai lát, code marker và tính nhất quán code-signature; chưa được coi Logo/Wake/Pinch đã hoạt động. Test phải đối chiếu phiên PID mới và các cặp [car-pinch] pair/request/expand applied=1/restore applied=1, [logo-geometry], [wake-ui], [bridgewake] host ack; nhìn bằng mắt whole split phủ màn hình, dock ẩn/hiện. Đặc biệt không suy hai ngón từ 2 record mirror, cũng không coi marker có mặt = logic đã kích hoạt.

**Tiếp nối:** đọc đúng artifact GitHub Actions run 42759723768, ID 13736992542, DEB SHA nêu trên (không lấy artifact cũ); nếu Muse build bản mới thì cập nhật run/sha/version; kiểm live trên xe bởi Nguyen trước mọi kết luận DEVICE PASS. Không đụng main/CI/phát hành trong lượt kiểm này.
