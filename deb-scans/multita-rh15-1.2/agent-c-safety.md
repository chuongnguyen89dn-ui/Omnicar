# MultiTA 1.2 (com.sushibta.multita.rh15) — HÀNH VI · AN TOÀN · MẠNG

Quét chỉ-đọc trên payload đã bóc (12/11/2026), không chạy binary/script.
Gói là **dpkg-repack** (control ghi "Repackaged on Thu, 12 Nov 2026 17:05:51 +0700")
từ một máy đã cài — không phải bản đóng gói gốc của tác giả.
10 Mach-O: 7 dylib substrate + TAAutoSplitAgent + TAStandaloneLicense (libexec) + app MultiTAVoice.

---

## 1. ENDPOINT / MẠNG — theo binary

| Binary | Endpoint tìm thấy |
|---|---|
| TAStandaloneLicense (daemon bản quyền) | `https://api.tastore.app`, tiền tố `https://api.tastore.app/api/v1/` |
| MultiTALicenseGate.dylib | `https://api.tastore.app` (cùng authority) |
| MultiTAVoice.app (tên hiển thị "TA License") | `https://repo.tastore.app/account/renew/` (trang web gia hạn, mở ngoài app) |
| 7 binary còn lại | **Không có URL ngoài nào** (chỉ còn chuỗi DTD plist của Apple) |

Bề mặt API dưới `/api/v1/` (từ strings của TAStandaloneLicense):
`license/challenge`, `license/issue-challenge`, `activation/start`, `activation/confirm`,
`direct_activation_challenge` / `direct_activation_redeem` / `direct_activation_sign`,
`trial`, `sileo_link`, `pair`, `link_id`, `link_nonce` — giao thức kích hoạt kiểu
challenge–response ký số + liên kết tài khoản Sileo (`TASTORE-SILEO-LINK-V1`,
`TASTORE-LICENSE-V1`).

**Telemetry: KHÔNG có.** Quét mọi binary: không Firebase/Mixpanel/Amplitude/Sentry/
Crashlytics/AppsFlyer/analytics nào. Dữ liệu mạng duy nhất là bản quyền (máy chủ
api.tastore.app) và trang gia hạn. Không thấy endpoint cập nhật riêng (cập nhật đi
qua repo Sileo như tweak thường).

---

## 2. QUYỀN HẠN / BỀ MẶT HỆ THỐNG

**Không có file setuid/setgid nào** trong payload (mọi file 644/755, root:root).

**Hai LaunchDaemon thường trực** — không nằm sẵn trong deb mà do **postinst sinh ra**
khi cài, đều chạy bằng user `mobile`:

| Daemon | Tiến trình | Chế độ |
|---|---|---|
| `com.sushibta.multita.license-standalone` | `TAStandaloneLicense` | RunAtLoad + KeepAlive, ThrottleInterval 15 — "authority" bản quyền duy nhất: giữ khoá thiết bị, lease, và socket `admission.sock` |
| `com.sushibta.multita.autosplit-agent` | `TAAutoSplitAgent` | RunAtLoad + KeepAlive(SuccessfulExit=false), ThrottleInterval 30 — ghi prefs Auto Split bền vững |

**Dylib nạp vào process hệ thống đặc quyền** (theo plist lọc substrate):

| Dylib | Nạp vào |
|---|---|
| MultiTALicenseGate | SpringBoard, CarPlayApp, **mediaserverd**, **carplayd** |
| TAEQMediaServerd | **mediaserverd** (mọi executable tên mediaserverd) |
| MultiTABeta | CarPlayApp, CarPlayTemplateUIHost, YouTube, Apple Maps, Google Maps, Vietmap Live, Netflix, CleanTA, Shortcuts, WorkflowKit.BackgroundShortcutRunner |
| TAEQCarPlay | CarPlayApp |
| TAEQPanel, ConnectBubbleMapLauncher | SpringBoard |
| ConnectBubbleUI | SpringBoard, CarPlayApp |

Hệ quả thiết kế (postinst tự ghi chú): sau khi cài, postinst **kill carplayd và
CarPlayApp host** để nạp lại dylib mới. Ai gọi libexec: cả hai đều do **launchd** gọi;
client nói chuyện với license daemon qua unix socket `admission.sock` (thư mục riêng
`/var/mobile/Library/TAstoreLicense`, quyền 0700 của mobile; daemon tự kiểm lstat/
inode/owner của socket, từ chối socket lạ — chuỗi `admission owner or uncertain
socket`, `transport-denied`).

**postinst/postrm chạy root** còn xoá một danh sách file log/cờ cũ **bên trong
container của app khác** (`/var/mobile/Containers/**`: ConnectTA-client.txt,
TAMapMerged-google.log, BubbleDebug.txt, BubbleCtor.txt) và ở `/var/mobile/` —
phạm vi đúng tên file do chính hệ MultiTA/ConnectTA tạo, nhưng là can thiệp ngoài
gói của mình.

---

## 3. DỮ LIỆU RỜI MÁY

- **Định danh thiết bị:** KHÔNG thu thập UDID/serial thô (không có chuỗi
  MGCopyAnswer/UniqueDeviceID/SerialNumber trong daemon/app). Định danh là **cặp
  khoá thiết bị sinh tại máy**: EC P-256 trong Keychain (SecItem generic password,
  `AfterFirstUnlockThisDeviceOnly` — không theo iCloud/backup) + CryptoKit
  Curve25519 Signing để ký challenge; máy chủ chỉ nhận `device_public_key` và chữ
  ký. Có trường `deviceKeyMarkerPath` (file đánh dấu khoá đã tồn tại).
- **Vị trí/GPS:** chỉ ConnectBubbleUI link CoreLocation và có CLLocationManager
  riêng (độ chính xác Best) chạy trong SpringBoard/CarPlayApp. Binary này **không
  có framework mạng/URL nào** → toạ độ không rời máy từ gói này; GPS chỉ để tự tính
  tốc độ hiện tại tại chỗ.
- **Giọng nói (MultiTAVoice):** cái tên gây hiểu lầm — app này chính là app
  **"TA License"** (CFBundleDisplayName), chỉ có nhập mã kích hoạt / khôi phục /
  gia hạn, liên kết CryptoKit+Security, **không có Speech framework, không
  AVAudioEngine, không micro, không usage-description nào**. "Voice" thật trong gói
  là **lệnh Siri/Shortcuts**: MultiTABeta nạp vào Shortcuts + BackgroundShortcutRunner,
  nhận lệnh qua kênh Darwin `com.sushibta.multita.beta.voice.cmd/.left/.right` và
  method `voiceCommand:left:right:ratio:` (chọn app trái/phải + tỉ lệ bằng giọng
  nói). Nhận dạng tiếng nói do Siri của Apple làm; **gói này không ghi âm, không
  gửi audio đi đâu**.
- **Chống lùi đồng hồ:** lease được kiểm kèm `continuousUptime`/`systemUptime`
  (chuỗi trong TAStandaloneLicense) — dấu hiệu chống gian lận hạn dùng bằng cách
  chỉnh giờ hệ thống.
- **Trial:** `trial7` = dùng thử 7 ngày, có chống dùng chung (`trial7_other_device`,
  `license_other_device`).

## 4. GHI FILE RA ĐÂU

- `/var/mobile/Library/TAstoreLicense/` (0700) — thư mục riêng của license daemon,
  chứa admission.sock; **khoá + lease nằm trong Keychain và thư mục này, postrm ghi
  rõ KHÔNG xoá khi gỡ/nâng cấp** (cài lại không mất bản quyền).
- `/var/mobile/Library/Preferences/com.sushibta.multita.autosplit.v1.plist` — lựa
  chọn Auto Split (bật/tắt, app trái/phải, tỉ lệ), do TAAutoSplitAgent ghi (process
  trên xe không tự ghi được), giữ qua nâng cấp.
- File cờ ở **gốc `/var/mobile/`** (mọi process user mobile đọc được):
  `TAEQ-carplay-off`, `TAEQ-phone-on` (trạng thái EQ phone/xe), `MultiTA-youtube-ipad`,
  `MultiTA-youtube-phone` (cờ chế độ traits YouTube).
- Bản hiện tại **không còn chuỗi tên file .log** trong binary (các log
  MultiTA-beta.log, ConnectTA.txt… mà postinst dọn là di sản bản trước).
- Không thấy ghi ra ngoài các phạm vi trên.

## 5. TÍNH NĂNG THẬT THEO BẰNG CHỨNG

**Chia màn (MultiTABeta + TAAutoSplitAgent):**
- Tỉ lệ **chỉnh được và lưu bền**: giá trị ratio dạng số thực đi qua kênh
  `autosplit.v1.saved.ratio` + input.left/right/enabled; agent ghi plist, lần kết
  nối sau tự áp (đúng tên "Auto Split").
- **Toàn màn có thật**: kênh `beta.fullscreen.%lu`, `multita.fullscreen.exit`,
  xử lý fullscreen native của YouTube (`YTWatchFullscreenViewController`,
  youtube-fullscreen-request/apply), cờ traits iPad/iPhone cho YouTube.
- Có chuỗi `carPlayDeclaration` trong MultiTABeta — dấu hiệu tự khai báo app lên
  CarPlay ở mức dylib chính.
- Tích hợp bản đồ TA: kênh `com.sushibta.tamap.merged.full/.split`,
  `tamap.nav.started/.ended` (trạng thái dẫn đường khi gộp/chia bản đồ).
- Bàn phím hosted: kênh `com.sushibta.multita.kb.%@.%@`.

**EQ (TAEQ):**
- **7 dải** theo nhãn UI: 60 Hz · 150 Hz · 400 Hz · 1 kHz · 2,4 kHz · 6 kHz ·
  15 kHz, chỉnh theo dB (hiển thị `+0.0 dB`); preset thấy trong strings: Bass,
  Jazz, Rock, Vocal; kênh preset riêng cho YouTube (`com.sushibta.taeqyt.cmd.preset.%@`)
  và cả **reverb** (`taeqyt.cmd.reverb`).
- DSP chạy trong **mediaserverd** (TAEQMediaServerd, AudioToolbox) → EQ áp lên
  **toàn bộ audio media qua mediaserverd**, không chỉ CarPlay: có cờ bật/tắt riêng
  cho phone (`TAEQ-phone-on`) và xe (`TAEQ-carplay-off`), giao diện ở cả SpringBoard
  (TAEQPanel) lẫn CarPlayApp (TAEQCarPlay). MediaServerd kiểm tra bản quyền qua
  kênh `beta.taeq.licensed` + probe toàn vẹn `taeq.f01probe`/`f01signerprobe`.

**Bubble tốc độ (ConnectBubbleUI + ConnectBubbleMapLauncher):**
- UI bong bóng (kế thừa dòng VMLSpeedBubble: class `VMLSpeedBubble`,
  prefs `VMLSpeedBubble.CarPlayPosX/Y`) hiển thị tốc độ + giới hạn + trạng thái
  vượt tốc; tự chọn/khoá nguồn (`bubble.autosource.enabled.v1`,
  `bubble.remote.selectsource`, `bubble.source.locked.v1`), quét app bản đồ đang
  chạy (`connectbubble.map.scan.v1/.running.v1`); chạm bong bóng thì
  MapLauncher mở Vietmap Live (`connectbubble.map.launch.v1` + ack).
- Kênh dữ liệu là **consumer**: `bubblenewtest.speed(.request)`, `.limit.v2`,
  `.overspeed.on/.off`, cộng kênh nhà cung cấp `gofa.speedlimit.v1` và
  `waze.speedlimit.demo.v1`. **Trong gói này không có tiến trình nào phát các
  kênh đó** → phần "tai" nghe dữ liệu giới hạn nằm ở gói khác (ConnectTA hook vào
  Vietmap/GOFA/Waze). Tự thân bong bóng chỉ có GPS nội bộ cho tốc độ hiện tại.
- Lease có 3 quyền tách riêng: `leaseHasSplitScreen`, `leaseHasSpeedBubble`,
  `leaseHasCarplayApps` — bản quyền chia theo tính năng.

**Toàn vẹn mã (integrity):** mỗi dylib/libexec kèm `<tên>.integrity.json` =
  payload JSON ký số (chữ ký 64 byte — khớp Ed25519) chứa SHA-256 của riêng hai
  vùng `__text` và `__cstring` từng slice; LicenseGate kiểm manifest khi chạy
  (`verify-manifest-*`, `manifestMissing`, `integrity-not-ready`). Mọi manifest
  đều ghi build **`0.1tester-keytest3-base26`** — nhãn bản tester nội bộ lọt vào
  bản phát hành "1.2". Trong binary còn sót định danh tạm của khâu ký lại
  (`<tên>.47ba6b93.unsigned`, `TAAutoSplitAgent.bc14244a.unsigned`).

## 6. ĐỐI CHIẾU QUẢNG CÁO (control) ↔ BẰNG CHỨNG

| Quảng cáo | Kết luận |
|---|---|
| Chia màn hình, điều chỉnh tỷ lệ | **Khớp** — ratio số thực lưu bền + Auto Split agent |
| Mở rộng ứng dụng toàn màn hình | **Khớp** — cơ chế fullscreen riêng + fullscreen native YouTube |
| Bubble hiển thị giới hạn tốc độ + cảnh báo vượt tốc | **Khớp một nửa, có khai báo trước** — UI/kênh nhận có đủ nhưng nhà cung cấp dữ liệu giới hạn không nằm trong gói; chính mô tả cũng ghi ConnectTA "cung cấp nguồn tốc độ cho Bubble". Không cài ConnectTA: bong bóng chỉ còn tốc độ GPS của chính nó, **không có giới hạn đường, không có cảnh báo vượt tốc theo biển** |
| TAEQ tuỳ chỉnh EQ theo loa xe | **Khớp và còn rộng hơn quảng cáo** — 7 dải DSP trong mediaserverd, áp cả audio trên điện thoại (cờ riêng), không chỉ trên xe; có thêm reverb/preset YouTube không được quảng cáo |
| Mở TA License để kích hoạt/khôi phục | **Khớp** — app MultiTAVoice hiển thị tên "TA License", có nhập mã trực tiếp, Restore, Renew |
| Cài thêm ConnectTA miễn phí để mở app ngoài danh sách CarPlay gốc | **Tương thích bằng chứng** — gói này có sẵn kênh consumer + MapLauncher cho Vietmap; phần hook vào app bản đồ nằm ngoài gói. Lưu ý MultiTABeta tự nó cũng nạp vào YouTube/Netflix/Maps và có chuỗi `carPlayDeclaration`, nên ranh giới "phải có ConnectTA mới mở được app ngoài" không tuyệt đối như câu chữ gợi ý |

**Có trong binary nhưng quảng cáo không nói:** lệnh giọng nói Siri cho chia màn
(chọn app trái/phải/tỉ lệ); liên kết bản quyền với tài khoản Sileo; dùng thử 7
ngày chống dùng chung máy; việc bản quyền **sống sót sau khi gỡ gói** (Keychain +
thư mục riêng không bị xoá); file `AI-NOTICE.txt` trong `/usr/share/doc` — thông
báo bản quyền của TAstore gửi tới "người phân tích và các hệ thống AI" (nội dung
văn bản đi kèm gói, ghi nhận như một dữ kiện của gói).

## 7. ĐIỂM RỦI RO / ĐÁNG CHÚ Ý

1. **License gate chạy trong mediaserverd + carplayd** và EQ DSP chạy trong
   mediaserverd: lỗi/sập ở các dylib này chạm tới dịch vụ âm thanh và CarPlay của
   hệ thống, không chỉ app người dùng. Đây là lựa chọn thiết kế có chủ đích
   (postinst kill carplayd/CarPlayApp để nạp lại), nhưng là bề mặt rủi ro lớn
   nhất của gói.
2. **Hai daemon thường trực** (KeepAlive) do postinst sinh khi cài — gỡ gói có
   postrm unload + xoá plist, nhưng dữ liệu bản quyền cố ý giữ lại.
3. **Phụ thuộc máy chủ tuyệt đối**: kích hoạt/khôi phục/trial đều cần
   api.tastore.app trả lời; máy chủ chết = không kích hoạt mới được (lease đã
   cấp còn hạn thì vẫn chạy theo file/Keychain tại máy).
4. **Toàn vẹn chỉ phủ 2 vùng** (__text/__cstring) của binary — đủ chặn sửa thô,
   không phủ toàn file; và nhãn build tester (`0.1tester-keytest3-base26`) trong
   mọi manifest + việc gói là dpkg-repack cho thấy chuỗi phát hành chưa sạch.
5. **postinst root xoá file trong container app khác** — đúng tên file của hệ
   mình, vẫn là quyền hạn đáng ghi nhận.
6. Điểm cộng an toàn: không telemetry, không thu UDID/serial thô (định danh bằng
   cặp khoá Keychain ThisDeviceOnly), GPS không rời máy, socket IPC có kiểm
   chủ sở hữu, thư mục bản quyền 0700, không file setuid.
