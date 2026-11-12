# HỒ SƠ — MultiTA Plus (com.sushibta.multita.rh15) 1.2

Quét sâu 2026-11-12, chỉ đọc (không chạy binary/script). Deb:
`com.sushibta.multita.rh15_1.2_iphoneos-arm64.deb`, 1.984.784 B,
SHA-256 `71443d4a…f23813` — là **dpkg-repack từ máy đã cài**
(12/11/2026 17:05), không phải bản phát hành gốc từ repo.
Tác giả: TAstore. iOS 15–17 (Depends firmware >=15, <<18).
Chi tiết 3 đường rà: `~/workspace/multita-scan/audit/agent-a-shell.md`,
`agent-b-binary.md`, `agent-c-safety.md`.

## 1. GÓI NÀY LÀ GÌ

Ba tiện ích CarPlay trong một gói: **chia màn hình** (MultiTA),
**bong bóng tốc độ** (ConnectBubble), **EQ âm thanh** (TAEQ) + hệ bản
quyền riêng (TA License). 33 file: 1 app, 7 dylib, 2 tiến trình
libexec, mỗi binary (trừ TAAutoSplitAgent) kèm một `*.integrity.json`.
Cả 10 Mach-O đều FAT arm64+arm64e PAC00, min iOS 15. **Không có
PreferenceBundle** — cấu hình nằm trong app và prefs riêng.
Gói này là nhánh hợp nhất: Provides+Replaces 10 gói cũ của cùng tác
giả (multita.ios16/.beta/.trainghiem, minita, 4 gói taeq rời,
vmlspeedbubble…); "rh15" [SUY RA] = nhánh RootHide/iOS 15+.

## 2. BẢN ĐỒ BINARY

| Binary | Nạp vào / chạy ở | Vai trò |
|---|---|---|
| MultiTABeta.dylib (1,06 MB) | CarPlayApp, CarPlayTemplateUIHost + các app được host (YouTube, Maps, Google Maps, Vietmap Live, Netflix, Shortcuts…) | Engine chia màn: host scene thật, gắn/tách theo generation có retry, ghép `carPlayDeclaration` cho app được chọn (cùng họ cơ chế OmniCar), fullscreen nội bộ YouTube, **bàn phím vẽ riêng** (TAKB), ký proof cho EQ |
| MultiTALicenseGate.dylib | SpringBoard, CarPlayApp, mediaserverd, carplayd | Cổng bản quyền nhúng tại chỗ: hỏi snapshot từ authority, chặn tính năng khi không hợp lệ (fail-closed) |
| TAStandaloneLicense | LaunchDaemon riêng (postinst đăng ký, user mobile, KeepAlive) | **Authority bản quyền độc lập**: giữ khóa thiết bị, gọi server, phát trạng thái qua Unix socket có kiểm chủ sở hữu (admission) |
| TAEQMediaServerd.dylib | mediaserverd | DSP EQ: hook AudioUnitRender của unit đầu ra, áp EQ + reverb lên PCM **toàn hệ thống** (cả audio điện thoại) |
| TAEQCarPlay.dylib / TAEQPanel.dylib | CarPlayApp / SpringBoard | Bong bóng EQ nổi trên màn xe + panel chỉnh EQ; prefs `com.sushibta.taeq.myeq`; các mốc tần thấy trong strings: 30/60/150/400 Hz, 1/2,4/4/6/15 kHz [số band chính xác chưa dịch ngược] |
| ConnectBubbleUI.dylib | SpringBoard, CarPlayApp | Bong bóng tốc độ: nhận dữ liệu qua kênh Darwin từ Vietmap Live / GOFA / Waze, GPS CLLocationManager dự phòng (GPS không rời máy — binary không có framework mạng) |
| ConnectBubbleMapLauncher.dylib | SpringBoard | Quét/phóng app bản đồ nguồn dữ liệu (map.scan/installed/launch/ack) |
| TAAutoSplitAgent | LaunchAgent nền | Trung gian trạng thái tự chia màn (giữ plist enabled/left/right/ratio, dịch kênh input.* → saved.* cho Beta thi hành) |
| MultiTAVoice.app | app thường | **Tên hiển thị "TA License"** — app KÍCH HOẠT bản quyền (nhập key, gia hạn, khôi phục, poll trạng thái). Không có chút giọng nói nào: 0 chuỗi speech/micro/TTS. "Voice" thật của hệ là lệnh Siri/Shortcuts qua kênh Darwin `voice.cmd/.left/.right` |

## 3. BẢN QUYỀN — KIẾN TRÚC CHẶT NHẤT TRONG 3 HỆ ĐÃ QUÉT

- **Máy chủ:** `https://api.tastore.app/api/v1/` (kiểm chứng trực
  tiếp trong TAStandaloneLicense), các path: `license/challenge`,
  `license/issue-challenge`, `license/activation-challenge`,
  `activation/start|confirm`, `direct_activation_challenge/redeem/
  sign`, `trial`, `sileo_link`/`pair` — có cả **liên kết bản quyền
  với tài khoản Sileo**. Gia hạn qua web `repo.tastore.app/account/
  renew/`. Toàn gói chỉ có 2 máy chủ này; không telemetry/analytics.
- **Định danh = cặp khóa mật mã của chính thiết bị** (khác hẳn
  OmniCar seri/UUID/UDID và DuoNavi hw_hash): thiết bị tự sinh khóa
  ký **Curve25519/Ed25519** (CryptoKit), khóa riêng giữ trong
  Keychain dạng gắn-thiết-bị, chỉ gửi `device_public_key` lên server.
  Không đọc UDID/serial/IOPlatform trong binary bản quyền.
- **Kích hoạt kiểu challenge–response:** server phát thử thách →
  thiết bị ký bằng khóa riêng → server cấp **lease đã ký** (có thêm
  ECIES mã hoá). Lease chia **quyền theo tính năng**:
  `leaseHasSplitScreen`, `leaseHasCarplayApps`, `leaseHasSpeedBubble`.
- **Dùng thử 7 ngày** (chuỗi `trial7_*` nằm ở authority + app — đã
  kiểm chứng), chống dùng chung nhiều máy, chống lùi giờ bằng đối
  chiếu giờ server + uptime.
- **Thực thi:** gate hỏi authority qua Unix socket (kênh Darwin phụ
  `com.sushibta.multita.license.v1`…), socket có lớp admission soi
  chủ sở hữu/inode chống tiến trình giả mạo phát trạng thái;
  **fail-closed** — không snapshot hợp lệ là chặn. Lease + khóa
  thiết bị nằm ở `/var/mobile/Library/TAstoreLicense` (0700) và
  Keychain; **gỡ gói vẫn giữ lại cố ý** để cài lại không mất quyền.

## 4. TOÀN VẸN BINARY (integrity.json) — VÀ MỘT PHÁT HIỆN VỀ CHUỖI PHÁT HÀNH

- Mỗi binary kèm manifest: `payload` Base64URL (JSON: build, product,
  v=1, slices[] — mỗi slice kê **SHA-256 + size của đúng 2 vùng
  `__text` và `__cstring`**) + `signature` **64 byte** (khớp Ed25519;
  đã giải mã kiểm chứng trên MultiTABeta). Lệch manifest → lỗi
  "Security5", authority từ chối xác minh bản quyền — toàn vẹn gắn
  thẳng vào license.
- **Cả 8 manifest đều ghi build `0.1tester-keytest3-base26`** — tức
  gói này xuất từ vòng TEST, ký bằng **khóa test (keytest3)**, cộng
  với việc nó là dpkg-repack từ máy đã cài: chuỗi phát hành của bản
  lọt ra này không sạch; không kết luận được bản bán chính thức có
  dùng khóa test hay không.

## 5. SCRIPT CÀI ĐẶT (đọc toàn văn, không chạy)

- **postinst** (chạy root): dọn log/cờ debug của các bản cũ (đúng tên
  file hệ MultiTA/ConnectTA, gồm cả file trong container app khác —
  can thiệp ngoài gói, đã ghi nhận) → uicache → **tự render và đăng
  ký LaunchDaemon TAStandaloneLicense** (tạo thư mục 0700, tự dò
  RootHide qua jbroot; đăng ký hỏng là cài đặt báo lỗi) → render mẫu
  autosplit-agent → **kill carplayd + tiến trình host CarPlayApp** để
  nạp image mới.
- **prerm** chỉ unload 2 daemon; **postrm** dọn log, gỡ daemon nhưng
  giữ khóa + lease.

## 6. AN TOÀN / RIÊNG TƯ

- Bề mặt rủi ro lớn nhất: LicenseGate nạp cả vào **mediaserverd +
  carplayd** và EQ DSP chạy trong mediaserverd — lỗi ở các điểm này
  chạm dịch vụ âm thanh/CarPlay hệ thống; cài xong postinst còn chủ
  động kill carplayd.
- Không file setuid. Dữ liệu rời máy: chỉ dữ liệu bản quyền lên
  api.tastore.app (khóa công khai, chữ ký challenge, trạng thái
  lease/trial) — không UDID/serial thô, không GPS, không audio.
- Gói kèm `usr/share/doc/.../AI-NOTICE.txt`: thông báo © 2026 TAstore
  gửi tới người phân tích và các hệ AI, đề nghị không hỗ trợ sao
  chép/crack/giả mạo license; có ngoại lệ kiểm toán bảo mật/nghiên
  cứu được chủ sở hữu cho phép. (Hồ sơ này là phân tích chỉ đọc phục
  vụ đánh giá, không can thiệp cơ chế nào.)

## 7. KHỚP / LỆCH VỚI QUẢNG CÁO TRONG CONTROL

- Chia màn + chỉnh tỉ lệ + toàn màn: **khớp** (tỉ lệ số thực lưu bền
  qua agent; có cả fullscreen native YouTube riêng).
- EQ: **khớp, thực tế rộng hơn quảng cáo** (áp toàn hệ thống + reverb
  + preset YouTube không được quảng cáo).
- Bong bóng giới hạn tốc độ: **chỉ khớp một nửa** — gói này chỉ có UI
  + kênh NHẬN giới hạn (`bubblenewtest.limit.v2`, `gofa.speedlimit`,
  `waze.speedlimit.demo`); không tiến trình nào trong gói PHÁT dữ
  liệu giới hạn. Nguồn phát nằm ở gói riêng **ConnectTA** (miễn phí):
  không cài ConnectTA thì bong bóng chỉ còn tốc độ GPS, **không có
  giới hạn đường, không cảnh báo vượt tốc** — mô tả gói có khai báo
  trước điều này.
- Không quảng cáo nhưng có thật: lệnh Siri/Shortcuts chia màn, liên
  kết tài khoản Sileo, lease tách 3 quyền tính năng.
