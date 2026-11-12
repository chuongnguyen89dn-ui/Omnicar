# GIẢI PHẪU BINARY — MultiTA 1.2 (com.sushibta.multita.rh15)

Quét 2026-11-12, **chỉ đọc** (strings ASCII + trích chuỗi UTF-8 tiếng Việt +
metadata plist/json), không chạy binary nào. Nguồn:
`~/workspace/multita-scan/payload/`. Dữ liệu trung gian:
`~/workspace/multita-scan/audit/work/*.strings.txt`, `*.utf8.txt`.
Quy ước: [BC] = chuỗi/metadata đọc trực tiếp; [SR] = suy ra từ cụm bằng chứng.

## 0. BẢN ĐỒ TOÀN GÓI — 10 Mach-O, tất cả FAT arm64 + arm64e (PAC00)

| Binary | Kích thước | Nạp vào (bộ lọc MobileSubstrate / vai trò tiến trình) |
|---|---|---|
| MultiTABeta.dylib | 1.058.288 B | CarPlayApp, CarPlayTemplateUIHost, YouTube, Apple Maps, Google Maps, Vietmap Live, Netflix, Shortcuts, WorkflowKit runner, app CleanTA của chính hãng |
| MultiTALicenseGate.dylib | 468.160 B | Bundle: SpringBoard + CarPlayApp (Any); Executable: **mediaserverd + carplayd** |
| TAStandaloneLicense | 680.000 B | Tiến trình độc lập ở `/usr/libexec` — "authority" bản quyền |
| MultiTAVoice (app) | 364.832 B | App `com.sushibta.multita.voice`, tên hiển thị **"TA License"**, scheme `multita://` |
| TAEQMediaServerd.dylib | 262.816 B | Executable mediaserverd |
| TAEQCarPlay.dylib | 270.944 B | CarPlayApp |
| TAEQPanel.dylib | 202.736 B | SpringBoard |
| ConnectBubbleUI.dylib | 238.064 B | SpringBoard + CarPlayApp |
| ConnectBubbleMapLauncher.dylib | 169.296 B | SpringBoard |
| TAAutoSplitAgent | 169.104 B | LaunchAgent (mobile, RunAtLoad, nền) — nhãn `com.sushibta.multita.autosplit-agent` |

Mọi dylib + TAStandaloneLicense đều đi kèm file `<tên>.integrity.json`
riêng — xem §9. Ngôn ngữ chính của tầng bản quyền là **Swift** (symbol
CryptoKit đầy đủ); tầng tính năng chủ yếu ObjC.

---

## 1. BẢN QUYỀN — KIẾN TRÚC 3 LỚP (điểm khác biệt lớn nhất của gói này)

Không có một "cổng kiểm" đơn lẻ. Hệ bản quyền MultiTA gồm **ba lớp tách
biệt giao tiếp qua IPC**, mọi kết luận đều [BC] từ strings của
MultiTALicenseGate + TAStandaloneLicense + app:

1. **TAStandaloneLicense** — tiến trình độc lập giữ quyền quyết định
   ("authority", kênh `com.sushibta.multita.authority`): giữ khóa thiết
   bị, liên hệ máy chủ, cấp/phê duyệt trạng thái, phát "snapshot" đã ký.
2. **MultiTALicenseGate.dylib** — thư viện nhúng vào **mọi tiến trình
   tính năng** (SpringBoard, CarPlayApp, carplayd, mediaserverd): đóng
   vai "Broker1" + client tiêu thụ (`MTLicensePulse`,
   `consumerProbe`), hỏi snapshot từ authority và **chặn tính năng tại
   chỗ** khi bằng chứng không hợp lệ.
3. **App "TA License"** (MultiTAVoice.app) — mặt tiền cho người dùng:
   nhập key, kích hoạt/gia hạn/khôi phục; bản thân app cũng nhúng mã
   client của authority (cùng bộ chuỗi IPC) và class
   `MTCmdPubVerifier` để kiểm chứng lệnh phát qua kênh điều khiển.

### 1.1 Định danh thiết bị = CẶP KHÓA CỦA CHÍNH THIẾT BỊ (không phải UDID/serial)

- [BC] Cả gate lẫn authority dùng CryptoKit **Curve25519.Signing**
  (Ed25519): `PrivateKey.signature(for:)`,
  `PublicKey.isValidSignature(_:for:)`; authority còn có SecKey **ECIES**
  (`kSecKeyAlgorithmECIESEncryptionCofactorX963SHA256AESGCM`,
  `SecKeyCreateRandomKey`, `SecKeyCreateDecryptedData`) và SHA256.
- [BC] Chuỗi nghiệp vụ: `device_public_key`, `decode-device-key`,
  `deviceKeyMarkerPath`, lỗi `keychain-decode-error`,
  `keychain-read-error`, `keychain-ambiguous-before-unlock`,
  thông điệp "Không lưu được license vào Keychain", "Không thể kích
  hoạt: khóa thiết bị chưa sẵn sàng."
- [SR] Thiết bị **tự sinh một cặp khóa ký** và lưu khóa riêng trong
  **Keychain**; định danh gửi lên server là **khóa công khai của thiết
  bị**. Không tìm thấy chuỗi đọc IOPlatformSerialNumber/IOPlatformUUID/
  UDID/MGCopyAnswer trong hai binary bản quyền — khác hẳn OmniCar
  (seri+UUID+UDID) và DuoNavi (hw_hash từ IOKit). Hệ quả: định danh
  không phải số seri phần cứng mà là một danh tính mật mã do thiết bị
  tự tạo và tự chứng minh quyền sở hữu bằng chữ ký.

### 1.2 Giao thức kích hoạt = THỬ THÁCH–ĐÁP ỨNG (challenge–response)

- [BC] Máy chủ duy nhất: `https://api.tastore.app`, gốc API
  `https://api.tastore.app/api/v1/`. Các path thấy trong authority:
  `license/activation-challenge`, `license/issue-challenge`,
  `license/challenge`; hành động `direct_activation_redeem`,
  sự kiện `ipc_activate_received`, `redeem_requested`,
  `redeem_http_failed`.
- [BC] Luồng suy từ tên path + trường `device_public_key` [SR]:
  client gửi khóa công khai → server **phát thử thách** → thiết bị
  **ký thử thách bằng khóa riêng** (chuỗi `pairingSignature`) → server
  xác minh rồi cấp **lease (giấy phép thuê)** đã ký; client kiểm chữ ký
  lease bằng khóa công khai của server (Ed25519) trước khi lưu.
- [BC] Gia hạn/khôi phục đi qua web tài khoản:
  `https://repo.tastore.app/account/renew/` (trong app).

### 1.3 Lease: có hạn, có quyền OFFLINE có kỳ hạn, gắn TỪNG TÍNH NĂNG

- [BC] Vốn từ trạng thái: `verify-stored-lease`, `leaseExpired`,
  `leaseMissing`, `licenseExpiry`/`licenseExpired`; thông điệp
  "Quyền offline/license đã hết hạn. Kết nối mạng và xác minh lại.",
  "License đã hết hạn. Cần kích hoạt license mới.", "Giờ hệ thống
  không khớp với server, hoặc license có thời hạn bất thường. Kiểm tra
  giờ máy." (chống lùi giờ bằng đối chiếu giờ server).
- [BC] Lease mang **cờ quyền theo tính năng**: `leaseHasSplitScreen`,
  `leaseHasCarplayApps`, `leaseHasSpeedBubble` — một lease quyết định
  mở tính năng nào (chia màn / host app CarPlay / bong bóng tốc độ),
  thay vì khóa toàn cục một công tắc.
- [BC] Trạng thái lỗi máy chủ/client: `not_activated`,
  `trial7_already_used`, `trial7_other_device`, `license_other_device`,
  `badSignature`, `transport-denied`, `verify-snapshot-unavailable`.
  Thông điệp người dùng: "License này được cấp cho một thiết bị khác.",
  "Chữ ký license không hợp lệ. Không phải lỗi mạng — liên hệ hỗ trợ."

### 1.4 Dùng thử: 7 ngày (trial7)

- [BC] Tiền tố `trial7_` ở cả hai mã lỗi dùng thử → [SR] dùng thử
  **7 ngày** (ngang DuoNavi, hơn OmniCar 1 ngày). `trial7_already_used`
  = máy này đã dùng thử; `trial7_other_device` = trial đã gắn thiết bị
  (khóa công khai) khác. Vì danh tính là cặp khóa trong Keychain, việc
  "dùng lại trial" phụ thuộc vào dấu phía server theo khóa công khai
  thiết bị [SR].

### 1.5 Kênh liên lạc gate ↔ authority: Unix socket có "admission" + Darwin

- [BC] Authority mở **Unix domain socket** (`socket bind/listen/accept`,
  log `TAStandaloneLicense IPC_STAGE=listener-ready pid=%d inode=%llu`,
  `serve-entered`); gate/app kết nối vào. Có lớp **admission** soi chủ
  sở hữu socket: `admission probe socket`, `admission owner or
  uncertain socket`, `admission existing socket rejected`,
  `admission stale socket changed`, `TAStandaloneAdmission`,
  `IPC_CHECK socket=%s exists=%d errno=%d type_socket=%d inode=%llu` —
  chống tiến trình lạ giả mạo đầu socket để phát trạng thái giả.
- [BC] Kênh Darwin/CFNotification song song: `com.sushibta.multita.
  license.v1` (kênh license chính), `com.sushibta.multita.license.
  cmdpub` (phát lệnh điều khiển — phía nhận có `MTCmdPubVerifier`
  kiểm chứng), `com.sushibta.multita.consumer.probe` (consumer hỏi),
  `com.sushibta.multita.consumer.status.` (prefix trạng thái theo
  consumer), `com.sushibta.tastore.ipc.guard.hi/.lo` (kênh canh IPC).
- [BC] Hành vi khi không có bằng chứng: chuỗi gate "Broker1: bằng
  chứng license không hợp lệ; **đã chặn chia màn**.", "Broker1: chưa
  có license hợp lệ.", "Broker1: đang chờ dịch vụ license khởi động
  (lần …)", "Broker1: không đọc được mã phiên khởi động." →
  [SR] gate **fail-closed**: không lấy được snapshot hợp lệ từ
  authority thì tính năng bị chặn, và gate còn đối chiếu "mã phiên
  khởi động" (boot session) để snapshot cũ từ phiên trước không dùng
  lại được.
- [BC] "Pulse": class `MTLicensePulse` có ở cả gate, authority và app
  — nhịp kiểm tra/phát trạng thái định kỳ giữa các tiến trình [SR].

### 1.6 Toàn vẹn binary là MỘT CỬA của bản quyền

- [BC] Chuỗi kiểm chứng trong cả hai binary: `verify-manifest-metadata`,
  `verify-manifest-read-or-key-decode`, `verify-manifest-verification`,
  và thông điệp: "MultiTA không vượt kiểm tra toàn vẹn (**Security5**).
  Hãy kiểm tra chữ ký manifest và đúng DEB đã cài; **không reset
  license**." → binary bị sửa (lệch manifest đã ký) thì authority từ
  chối xác minh license. Chi tiết manifest ở §9.

### 1.7 So sánh với OmniCar 1.0.5 và DuoNavi

| Trục | MultiTA 1.2 | OmniCar 1.0.5 | DuoNavi 1.0.3-12 |
|---|---|---|---|
| Máy chủ | api.tastore.app/api/v1/ | omnicar-license…workers.dev | duoface.com/api/v1/license/sync |
| Định danh máy | **Cặp khóa Ed25519 tự sinh, lưu Keychain**; gửi khóa công khai | Seri + IOPlatformUUID + UDID (đọc IOKit) | `hw_hash` băm phần cứng (IOKit) |
| Chứng minh sở hữu | **Ký thử thách của server (challenge–response)** | Không có thử thách; key OMC- nhập tay gắn UDID phía server | Đồng bộ lease theo hw_hash |
| Vật mang quyền | Lease đã ký, lưu Keychain, có hạn + hạn offline | Token trong phong bì ký ECDSA P-256 | File plist trạng thái lease (payload ký, cài nguyên tử) |
| Chữ ký | **Ed25519** (CryptoKit Curve25519.Signing) + ECIES cho mã hoá | ECDSA P-256/SHA-256 | Có kiểm chữ ký (OSStatus) — thuật toán chưa xác định |
| Trial | **7 ngày** (trial7), server giữ dấu theo định danh | 1 ngày, server giữ dấu theo UDID | 7 ngày, tự kích hoạt khi cắm CarPlay |
| Kiến trúc thực thi | **Tiến trình authority độc lập + gate nhúng mọi process tính năng, IPC qua Unix socket có admission + Darwin** | Cổng kiểm rải trong từng module, tiến trình runtime tự gọi server | Một sync manager trong app + watchdog trong dylib |
| Phạm vi khóa | **Theo từng tính năng** (leaseHasSplitScreen/CarplayApps/SpeedBubble) | Theo tính năng (mỗi module tự chặn) | Toàn cục (hết hạn là lớp chia màn dừng) |
| Chống sửa binary | **Manifest ký Ed25519 cho từng binary (SHA-256 __text+__cstring) — sửa binary là license từ chối** | Ghim SHA-256 2 file icon của Prefs bundle | Không thấy lớp tương đương |
| Chuyển máy | Chưa thấy cơ chế tự phục vụ trong strings (có trang web renew tài khoản) | Qua người bán sửa tay | Device ID, tối đa 10 lần, tự phục vụ |

Điểm mạnh nhất của MultiTA so với cả hai hệ kia: **danh tính mật mã +
challenge–response + authority độc lập qua socket có admission +
toàn vẹn binary gắn thẳng vào quyết định license**. Đây là kiến trúc
gần với DRM cấp nền tảng hơn là cơ chế key/lease thông thường của
tweak.

---

## 2. MultiTABeta.dylib (1.058.288 B) — TRÁI TIM TÍNH NĂNG: CHIA MÀN + HOST APP + BÀN PHÍM VẼ + MẢNH EQ

Binary lớn nhất gói, là nơi sống của tính năng chính. Class/selector
đáng chú ý [BC]: `TASplitWindow`, `TADividerView`, `TAHandleView`,
`TAControls`, `TAAppTile`, `TABlockButton`, `TACollapseHandoff`,
`attach:slot:`, `commitSplit:`, `openManualSplitPair:`,
`dragDivider:`, `dividerDoubleTap:`, `resetDivider:`,
`finishAttach:generation:request:attempt:`,
`failAttach:bundle:reason:`, `retryPane:`, `restartSplit`,
`selectTile:`, `paneAction:`, `sceneManager:didDestroyScene:`.

- **Cơ chế đưa app lên xe** [BC]: Beta nạp vào **cả hai phía** — phía
  xe (CarPlayApp, CarPlayTemplateUIHost) và phía app được host
  (YouTube, Apple Maps, Google Maps, Vietmap Live, Netflix, Shortcuts,
  WorkflowKit BackgroundShortcutRunner, CleanTA). Trong CarPlayApp nó
  làm việc với các class riêng của hệ thống: `DBDashboard`,
  `DBApplicationSceneViewController`,
  `CARTemplateUIApplicationSceneViewController`,
  `_CARApplicationSceneViewController`, `carPlayDeclaration`,
  `FBSApplicationLibraryConfiguration`, `LayerHost` → [SR] cùng một họ
  cơ chế với OmniCar: **ghép khai báo CarPlay tổng hợp (declaration)
  cho app được chọn + host scene thật của app vào ô chia**, hình học
  một chủ ghi phía CarPlayApp; phía trong app có mã xử lý riêng (điển
  hình: `YTWatchFullscreenViewController`, `closeStandaloneYouTube
  Fullscreen`, kênh `com.sushibta.multita.youtube-fullscreen-request/
  apply` — dọn fullscreen nội bộ của YouTube để khỏi xung đột với
  fullscreen của ô chia).
- **Chia màn** [BC]: engine attach scene theo "generation" có thử lại
  (`finishAttach:generation:request:attempt:`, `retryPane:`,
  `mapSceneRecoveryIssued` — tự cứu scene bản đồ khi chết), divider
  kéo được + chạm đúp (`dragDivider:`, `dividerDoubleTap:`), tỉ lệ
  lưu qua trạng thái autosplit (§7). Kênh fullscreen:
  `com.sushibta.multita.beta.fullscreen.%lu`.
- **Bàn phím vẽ riêng** [BC]: `TAKBController`, `TAKBClientSession`,
  `TAKBKeyButton` — Beta chứa một bộ bàn phím tự vẽ cho ô hosted
  (client session phía app + controller phía xe) — tương tự bài toán
  bàn phím hosted của OmniCar, ở đây hãng làm phím vẽ thật.
- **Mảnh EQ trong Beta** [BC]: class `MTEQProofSigner`, khóa kênh
  `com.sushibta.multita.beta.taeq.licensed`, và cả chuỗi tần số EQ
  (60Hz/150Hz…) xuất hiện trong Beta → [SR] Beta là nơi **ký "proof"
  cho EQ** và/hoặc chứa phần UI EQ phía xe; họ "Proof" (`MTBProof
  Failure`, `MTEQProofSigner` cũng có trong LicenseGate) là cơ chế
  bằng chứng đã ký dùng chung giữa các tính năng.
- **Quan hệ với gói ConnectTA riêng** [BC/SR]: tên các dylib bong bóng
  là "ConnectBubble*", kênh chẩn đoán `com.sushibta.connectta.diag.`
  xuất hiện trong LicenseGate, và lease có cờ riêng
  `leaseHasSpeedBubble` → ConnectTA là dòng sản phẩm bong bóng tốc độ
  riêng của cùng hãng; gói MultiTA **nhúng lại các thành phần Connect**
  và mở chúng bằng quyền trong lease MultiTA, thay vì viết lại.

## 3. TAEQMediaServerd.dylib (262.816 B) — DSP ÂM THANH TRONG mediaserverd

- [BC] Nạp theo **Executable mediaserverd** (không theo bundle). Hook
  tầng render: import `_AudioUnitRender`, `_AudioUnitGetProperty`;
  chuỗi chẩn đoán dày đặc: `com.sushibta.taeqyt.render-called`,
  `render-is-output-unit`/`render-not-output-unit`,
  `render-format-safe-applying`/`render-format-unsafe`,
  `unit-callcount-%d` → [SR] EQ **chặn ở lời gọi render của AudioUnit
  đầu ra ngay trong mediaserverd** và áp bộ lọc lên PCM trước khi xuất
  — tức EQ tác động **toàn hệ thống** (mọi âm thanh qua mediaserverd),
  không phải chỉ trong app nhạc.
- [BC] Nhận lệnh qua Darwin: `com.sushibta.taeqyt.cmd.preset.%@`,
  `com.sushibta.taeqyt.cmd.reverb`; đọc trạng thái bản quyền
  `com.sushibta.taeqyt.eq-licensed-state`; class `TAEQCryptoProbe`
  (tự kiểm tra mật mã khi nạp [SR]) và `TAEQMediaServerd`.
- [BC] Có cả **reverb** bên cạnh EQ (`cmd.reverb`, `reverb-state`).

## 4. TAEQCarPlay.dylib (270.944 B) + TAEQPanel.dylib (202.736 B) — MẶT TIỀN EQ

- [BC] TAEQCarPlay (trong CarPlayApp): `TAEQCPWindow` + vị trí bong
  bóng EQ trên màn xe lưu ở `TAEQCPBubbleX`/`TAEQCPBubbleY` → một
  **nút/bong bóng EQ nổi trên giao diện xe** để mở bảng chỉnh ngay
  trên xe. TAEQPanel (trong SpringBoard): `TAEQPanelController` +
  `TAEQOverlayWindow` — cửa sổ phủ chứa panel EQ phía điện thoại.
- [BC] **Số band**: các tần số xuất hiện trong TAEQCarPlay/TAEQPanel:
  30 Hz, 60 Hz, 150 Hz, 400 Hz, 1 kHz, 2,4 kHz, 4 kHz, 6 kHz, 15 kHz →
  [SR] EQ **9–10 band** (dải tần kiểu graphic EQ xe hơi; con số chính
  xác cần đếm trong dữ liệu UI, strings cho thấy tối thiểu 9 mốc trên).
  Gain hiển thị dạng `%+.1f dB`. Preset đổi qua
  `com.sushibta.taeqyt.cmd.preset.%s` (tên preset dạng chuỗi; strings
  không lộ danh sách preset đầy đủ). Khóa prefs miền
  `com.sushibta.taeq.myeq`.
- [BC] Cả hai binary chứa hàng loạt kênh chẩn đoán tự đếm
  (`com.sushibta.taeqyt.carplay-panel-opens`, `-touches`, `-tap-count`,
  `-window-rebuilds`, `-ctor-ran`…) — EQ được đo đạc rất kỹ khi chạy.
  TAEQPanel còn có ivar đặt tên tiếng Việt `_nguyenBanDangBat`,
  `_nutNguyenBan` (dấu vết đặt tên nội bộ của lập trình viên).
- [SR] Namespace `taeqyt` ("TA EQ YouTube"?) dùng chung với một sản
  phẩm EQ riêng của hãng; trong MultiTA, EQ được mở bằng kênh trạng
  thái bản quyền riêng (`eq-licensed-state`) và proof do Beta ký (§2).

## 5. ConnectBubbleUI.dylib (238.064 B) + ConnectBubbleMapLauncher.dylib (169.296 B) — BONG BÓNG TỐC ĐỘ

- [BC] ConnectBubbleUI (SpringBoard + CarPlayApp): cửa sổ chạm của
  bong bóng `VMLBubbleTouchWindow` (VML = Vietmap Live); vị trí trên
  xe lưu ở prefs `VMLSpeedBubble.CarPlayPosX`/`CarPlayPosY` (miền
  `com.sushibta.bubble`).
- **Nguồn tốc độ** [BC]: (1) **Vietmap Live** — kênh
  `com.sushibta.bubblenewtest.speed` / `.speed.%ld` / `.speed.request`,
  giới hạn `com.sushibta.bubblenewtest.limit.v2`, cảnh báo
  `overspeed.on/off`, cờ scene `vmlcarplaysceneactive`;
  (2) **GOFA** (`com.lumi.GOFA`) — kênh `com.sushibta.gofa.
  speedlimit.v1` + `.session.v1` + `.sequence.v1`,
  `com.sushibta.bubble.foreground.gofa.v1`;
  (3) **Waze** (`com.waze.iphone`) — class `BTAWazeVehicleMonitor`
  đọc tốc độ xe từ Waze, kênh `com.sushibta.waze.speedlimit.demo.v1`;
  (4) **GPS của chính máy** — `CLLocationManager` với
  `kCLLocationAccuracyBest` (dự phòng khi không có app nguồn [SR]).
  Chọn nguồn: `com.sushibta.bubble.autosource.enabled.v1`,
  `com.sushibta.bubble.remote.selectsource`,
  `com.sushibta.connectbubble.source.selected.v1` / `.locked.v1`.
- **MapLauncher** [BC]: ở SpringBoard, làm nhiệm vụ **quét và phóng
  app bản đồ nguồn** để bong bóng có dữ liệu: bộ kênh
  `com.sushibta.connectbubble.map.scan.v1` / `.installed.v1` /
  `.launch.v1` / `.launchack.v1` / `.running.v1` / `.stage.v1` —
  kiểm tra app đã cài → phóng → chờ xác nhận đã chạy. [SR] Đây là
  "launcher" đúng nghĩa đen: đảm bảo app nguồn tốc độ (Vietmap/GOFA/
  Waze) đang chạy nền thì bong bóng trên xe mới có số.
- [BC] UI cũng tham gia canh IPC bản quyền: kênh
  `com.sushibta.tastore.ipc.guard.hi/.lo` xuất hiện trong cụm chuỗi
  bong bóng → consumer của authority cũng phải "điểm danh" qua socket
  canh gác [SR].

## 6. MultiTAVoice.app — KHÔNG PHẢI APP GIỌNG NÓI: ĐÂY LÀ APP LICENSE

- [BC] Kiểm chứng âm tính đầy đủ: **0 chuỗi** về ghi âm/nhận dạng
  giọng/TTS trong toàn binary (không SFSpeechRecognizer, không
  AVAudioRecorder, không AVSpeechSynthesizer, không xin quyền
  microphone trong Info.plist). Cái tên "Voice" là vỏ; Info.plist ghi
  tên hiển thị **"TA License"**, region phát triển `vi`.
- [BC] UI thực tế (ivar/selector): ô nhập key `directLicenseField`,
  `activateEnteredLicense`, `applyLicenseReply:`, nút
  `renewLicenseButton`, `restoreLicenseButton`, nhãn
  `licenseStateLabel`/`licenseDetailLabel`, cơ chế poll trạng thái
  (`licensePollScheduled`, `licenseRequestInFlight`,
  `licensePollGeneration`, `licenseRequestSerial`,
  `licensePendingBegan`). App nhúng nguyên bộ client authority
  (chuỗi IPC_STAGE của TAStandaloneLicense, đường dẫn
  `/TAStandaloneLicense`) và `MTCmdPubVerifier`.
- [SR] Vì sao nằm trong gói này: nó là **điểm kích hoạt duy nhất** mà
  gate chỉ về — thông điệp trong gate/authority đều nói "mở MultiTA
  License trên iPhone" / "Nhập key MultiTA trên iPhone". Đặt tên gói
  là "Voice" nhiều khả năng để tránh chú ý/đánh lạc hướng trên màn
  hình chính [SR — không có bằng chứng trực tiếp về ý đồ].

## 7. TAAutoSplitAgent (169.104 B) — NGƯỜI GIỮ TRẠNG THÁI TỰ CHIA MÀN

- [BC] LaunchAgent chạy nền theo người dùng mobile
  (`autosplit-agent.plist`: RunAtLoad, KeepAlive theo SuccessfulExit,
  ProcessType Background, ThrottleInterval), mang entitlement
  `platform-application`.
- [BC] Việc duy nhất của nó là **trung gian trạng thái autosplit**:
  đọc/ghi `/var/mobile/Library/Preferences/com.sushibta.multita.
  autosplit.v1.plist` (enabled/left/right/ratio), dịch kênh đầu vào
  `com.sushibta.multita.autosplit.v1.input.*` (từ phía cài đặt/người
  dùng) thành bộ `…autosplit.v1.saved.*` + phát `…autosplit.v1.
  request` cho Beta thực thi và trả `…autosplit.v1.ack`/`snapshot`.
  Danh sách app mặc định nó biết: Apple Maps, Music, Podcasts,
  Google Maps, YouTube, YouTube Music, Spotify, TikTok
  (com.ss.iphone.ugc.Ame), Vietmap Live.
- [SR] Tách agent riêng cho việc này để trạng thái "cặp app + tỉ lệ
  đã lưu" sống sót qua respring và có một chủ ghi duy nhất, Beta chỉ
  việc thi hành khi CarPlay kết nối.

## 8. MultiTALicenseGate.dylib — VỊ TRÍ THỰC THI (bổ sung cho §1)

- [BC] Gate mang cùng bộ mã authority (chuỗi IPC_STAGE, verify
  manifest, MTLicensePulse) vì dùng chung thư viện client; phần riêng
  của nó là vai **Broker1** trong tiến trình chủ: SpringBoard và
  CarPlayApp là nơi quyết định chia màn/host app nên gate ở đó giữ
  quyền chặn; bản sao trong mediaserverd/carplayd phục vụ EQ và các
  tính năng chạy trong daemon [SR].
- [BC] Dấu build trong binary: `MultiTALicenseGate.dylib.47ba6b93.
  unsigned`; TAAutoSplitAgent: `TAAutoSplitAgent.bc14244a.unsigned`.

## 9. LỚP TOÀN VẸN TOÀN GÓI (integrity.json) — CHUNG CHO MỌI BINARY

- [BC] Mỗi `.integrity.json` = `{payload: base64url, signature:
  base64url}`; payload giải ra là JSON: `{"build":
  "0.1tester-keytest3-base26", "product": "multita", "v": 1,
  "slices": [{cpu, subtype, regions: {"__text": {sha256, size},
  "__cstring": {sha256, size}}}]}` cho cả 2 slice; chữ ký dài đúng
  **64 byte** → [SR] ký **Ed25519** (khớp CryptoKit Curve25519 trong
  binary). Cả 8 file dùng chung một build id.
- [SR] Cơ chế: khi chạy, mã tự băm lại vùng `__text` (code) và
  `__cstring` (chuỗi) của chính binary, đối chiếu manifest đã ký;
  lệch là coi như binary bị sửa. Đây là lớp chống vá cổng bản quyền:
  sửa gate cũng vô ích nếu authority từ chối snapshot vì manifest
  không khớp — và thông điệp Security5 (§1.6) cho thấy nó nối thẳng
  vào quyết định license.
- [BC] Gói còn mang `AI-NOTICE.txt` của TAstore (thông báo bản quyền
  gửi tới cả các hệ AI) trong `usr/share/doc` — dấu hiệu hãng rất ý
  thức về việc sản phẩm bị phân tích/sao chép.

## 10. GIỚI HẠN CỦA VÒNG QUÉT

- Chỉ strings + metadata: chưa dịch ngược hàm nên **chưa** xác định
  được: khóa công khai của server ghim ở đâu/dạng nào; lease chứa
  trường gì ngoài expiry + 3 cờ tính năng; tỉ lệ chia cụ thể của Beta;
  danh sách preset EQ đầy đủ; số band chính xác (9 mốc tần số đã thấy,
  có thể 10 band nếu còn mốc không nằm trong strings dạng "Hz").
- Tiếng Việt trong dylib tính năng bị cắt mảnh ở strings ASCII; báo
  cáo dựa chủ yếu vào cụm UTF-8 của 3 binary bản quyền + app (đã trích
  riêng) — Beta/TAEQ/ConnectBubble chưa trích UTF-8 toàn phần.
