# HỒ SƠ SÂU — HỆ THỐNG BẢN QUYỀN ONLINE CỦA OMNICAR 1.0.5

Lập 2026-11-10, chỉ đọc (strings + metadata ObjC + plist), không chạy
binary. Nguồn: payload 1.0.5 `~/workspace/omnicar-105/payload/`
(5 dylib + Prefs + app companion). 1.0.3 không có bất kỳ thành phần nào
của hệ này (đã đối chiếu vòng trước).

Quy ước: **[BẰNG CHỨNG]** = chuỗi/metadata đọc trực tiếp từ binary,
chép nguyên văn. **[SUY RA]** = kết luận suy từ cụm bằng chứng, ghi rõ
căn cứ. Mọi chuỗi xuất hiện 2 lần trong strings (2 slice arm64/arm64e)
chỉ ghi một lần.

## 1. KIẾN TRÚC TỔNG THỂ

- [BẰNG CHỨNG] "Động cơ" bản quyền nằm trong **lõi OMC dùng chung**,
  được nhúng tĩnh vào **cả 5 dylib** (Core, AppBridge, SpeedBubble,
  SplitScreen, StartupScreen): mỗi dylib đều chứa nguyên khối strings
  gồm URL máy chủ, từ điển mã lỗi, các trường token và bộ hàm IOKit
  đọc định danh. Core không có class ObjC nào cho bản quyền (quét
  metadata: 0 class) → engine viết bằng C/hàm tự do trong lõi chung.
- [BẰNG CHỨNG] Phía Cài đặt có 2 class ObjC mới trong binary Prefs:
  `OMCLicenseController` (instance size 160, 19 ivar) và
  `OMCLicenseBuyController` (1 ivar `_deviceCode`).
- [SUY RA — căn cứ §2/§11] Luồng vận hành: Prefs **không tự gọi mạng**.
  Prefs ghi khóa prefs `licenseKeyPending` rồi phát kênh Darwin
  `license.activate`/`license.trial`/`license.probe`; tiến trình
  runtime mang lõi Core (SpringBoard/CarPlayApp) nhận kênh, gọi máy
  chủ, ghi kết quả vào khóa `licenseResult`, phát `license.done`;
  Prefs nghe `license.done` (method `replyArrived`) và có timer chờ
  trả lời — hết giờ thì báo lỗi `LICENSE_ERR_timeout` = "No answer
  from OmniCar. Respring and try again." (tức "OmniCar" ở đây là phần
  runtime, không phải máy chủ).

## 2. GIAO THỨC MÁY CHỦ

### 2.1 Đầu mối
- [BẰNG CHỨNG] URL gốc duy nhất, có trong cả 6 binary (5 dylib +
  Prefs): `https://omnicar-license.omnicar-tweak.workers.dev`
  (nền tảng Cloudflare Workers).
- [BẰNG CHỨNG] Phương thức và định dạng: strings `POST`,
  `application/json`, `content-type` nằm ngay cụm license trong Core;
  log lỗi HTTP theo mẫu `http %ld %@` (mã trạng thái + thông điệp).
- [BẰNG CHỨNG] **Không tồn tại chuỗi đường dẫn endpoint** (path) nào
  trong bất kỳ binary nào: quét toàn bộ strings của 7 binary, mọi
  chuỗi bắt đầu bằng `/` đều là đường dẫn filesystem; quét bổ sung
  UTF-16LE trên Core cũng không có. [SUY RA] Client POST thẳng tới
  URL gốc và **hành động được phân biệt bằng trường trong thân JSON /
  ngữ cảnh kênh Darwin** (activate/trial/probe), không bằng path.

### 2.2 Chống giả mạo câu trả lời — phong bì có chữ ký
- [BẰNG CHỨNG] Core nhập các symbol: `_SecKeyCreateWithData`,
  `_SecKeyVerifySignature`, `_kSecAttrKeyTypeECSECPrimeRandom`,
  `_kSecAttrKeyClassPublic`, `_kSecAttrKeySizeInBits`,
  `_kSecKeyAlgorithmECDSASignatureMessageX962SHA256`, `_CC_SHA256`,
  `initWithBase64EncodedString:options:` → câu trả lời của máy chủ
  được **ký ECDSA trên đường cong P-256 với SHA-256**, client kiểm
  bằng khóa công khai ghim sẵn; dữ liệu mã hoá Base64.
- [BẰNG CHỨNG] Vốn từ phong bì trong cụm license (mọi dylib):
  `envelope:`, `decrypt`, `noenvelope` (không có phong bì), `noenc`
  (không giải mã được), `noexp` (không có hạn), `unlock` (mở khoá
  thành công), log mẫu `lic %@, unlock %@` và `trial %@, unlock %@`.
  Lỗi phía người dùng tương ứng: `LICENSE_ERR_badtoken`.
- [BẰNG CHỨNG] Giờ tin cậy: strings `HEAD`, `https://www.apple.com/`,
  `Date`, định dạng `EEE, dd MMM yyyy HH:mm:ss zzz`, locale
  `en_US_POSIX`, khóa `trustedTime` → client lấy **giờ từ header Date
  của apple.com** để chống lùi đồng hồ máy khi xét hạn token/trial
  (cơ chế trustedTime đã có từ 1.0.3, nay phục vụ thêm bản quyền).

### 2.3 Trường dữ liệu (JSON / bản ghi)
[BẰNG CHỨNG] Cụm trường quanh engine trong Core (nguyên văn, theo thứ
tự strings): `token`, `lastValidate`, `trial`, `udid`, `activatedAt`,
`reported`, `expires`, `kind`, `active`, `state`, `error`, `date`,
`cached`, `stale`, `unlock`. Phía Prefs, bản ghi kết quả
`licenseResult` mang các trường con đã thấy: `state`, `error`, `date`.
[SUY RA] Đây là từ điển của bản ghi bản quyền đã giải mã: loại
(`kind`: bản quyền thật / dùng thử qua cờ `trial`), hạn (`expires`),
thời điểm kích hoạt (`activatedAt`), lần kiểm tra gần nhất
(`lastValidate`), thiết bị gắn kèm (`udid`), cờ đã báo cáo
(`reported`), cờ cache cũ (`stale`, `cached`).

## 3. TỪ ĐIỂN MÃ TRẠNG THÁI / LỖI CỦA MÁY CHỦ

[BẰNG CHỨNG] Toàn bộ mã ngắn nằm trong cụm license của mọi dylib;
Prefs ánh xạ mã → khóa chữ `LICENSE_ERR_<mã>` (chuỗi `LICENSE_ERR_`
được nối động với mã trong binary Prefs):

| Mã | Chuỗi hiển thị EN (nguyên văn) | VI |
|---|---|---|
| `bad_key` | "Key not found or revoked." | "Mã không đúng hoặc đã bị thu hồi." |
| `key_used` | "This key is already used on another device." | "Mã này đã dùng trên máy khác." |
| `trial_used` | "This device has already used its trial." | "Máy này đã dùng thử rồi." |
| `trial_closed` | "Trials are paused. Try again later." | "Tạm ngưng cấp dùng thử. Thử lại sau." |
| `nodevice` | "Could not read this device's identity." | "Không đọc được định danh máy." |
| `network` | "No connection to the server. Check the internet and try again." | "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." |
| `server` | "Server error. Try again later." | "Máy chủ trả lời lỗi. Thử lại sau." |
| `rate` | "Too many requests. Wait a few minutes." | "Thao tác quá nhanh. Đợi vài phút rồi thử lại." |
| `badtoken` | "Could not verify the server's answer. Update OmniCar and try again." | "Không xác minh được câu trả lời. Cập nhật OmniCar rồi thử lại." |
| `timeout` | "No answer from OmniCar. Respring and try again." (sinh phía client — xem §1) | "OmniCar không trả lời. Respring rồi thử lại." |

[BẰNG CHỨNG] Mã trạng thái nội bộ khác trong cụm (không có khóa
LICENSE_ERR_ riêng → dùng cho logic/trạng thái, không báo lỗi trực
tiếp): `nolicense`, `noenvelope`, `noenc`, `noexp`, `expired`,
`haskey`, `used`, `found`, `eligible`, `unknown`, `reported`,
`reason`. Chuỗi log phía Core: `lic check%@: khong hop le -> khoa`
(kiểm tra không hợp lệ → khoá) và biến thể có hậu tố ` (force)`.

## 4. DÙNG THỬ (TRIAL)

- [BẰNG CHỨNG] Điều kiện theo chữ chính chủ: `LICENSE_TRIAL_NOTE` =
  "Try every feature free for 1 day. One trial per device." / "Dùng
  thử miễn phí đủ tính năng trong 1 ngày. Mỗi máy một lần."; nút
  `LICENSE_TRIAL_BUTTON` = "Try free for 1 day".
- [BẰNG CHỨNG] Việc "mỗi máy một lần" do **máy chủ** giữ: lỗi
  `trial_used` trả về khi thiết bị (theo udid — §8) đã dùng thử; máy
  chủ cũng có thể **đóng cửa trial toàn hệ** (`trial_closed`).
  [SUY RA] Xoá app/cài lại không xin được trial mới vì dấu nằm phía
  server theo định danh máy.
- [BẰNG CHỨNG] Luồng client: Prefs `trialTapped` → đặt cờ ivar
  `_pendingTrial` → phát Darwin `com.anlai.omnicar/license.trial` →
  Core gọi máy chủ → token về có `kind`/`trial` + `expires`; Prefs báo
  `LICENSE_TRIAL_STARTED` = "Trial started!". Chuỗi log Core:
  `trial %@, unlock %@`.
- [BẰNG CHỨNG] Đếm ngược hiển thị ngay trên trang kích hoạt: ba mẫu
  chuỗi `LICENSE_STATUS_TRIAL_DAYS` "Trial · %ld days left",
  `LICENSE_STATUS_TRIAL_HOURS` "…%ld hours left",
  `LICENSE_STATUS_TRIAL_MINUTES` "…%ld minutes left", cộng
  `LICENSE_STATUS_TRIAL_ENDS` "Ends %@" — và UI có hẳn một thanh tiến
  trình `trialProgress` (UIProgressView) cùng `tickTimer` cập nhật
  theo thời gian thực trong `OMCLicenseController`.
- [BẰNG CHỨNG] Hết trial: trạng thái chuyển `LICENSE_STATUS_EXPIRED`
  = "Trial ended" / "Hết hạn dùng thử", biểu tượng `hourglass` /
  `hourglass.bottomhalf.filled`; các cổng tính năng (§6) đóng như
  chưa kích hoạt.

## 5. ÂN HẠN OFFLINE (GRACE)

- [BẰNG CHỨNG] Bản ghi bản quyền lưu trường `lastValidate` (lần kiểm
  chứng thành công gần nhất) và cờ `stale` / `cached` trong từ điển
  engine; log Core có mẫu bắt đầu `stale `.
- [BẰNG CHỨNG] Trạng thái người dùng riêng cho ân hạn:
  `LICENSE_STATUS_GRACE` = "Not checked with the server for a long
  time. Go online." / "Lâu chưa kiểm tra được máy chủ. Hãy kết nối
  mạng.", biểu tượng SF Symbol `wifi.exclamationmark` (khác hẳn các
  trạng thái khoá cứng). [SUY RA] Thiết kế: token đã ký còn hạn thì
  tính năng **vẫn mở** khi mất mạng; chỉ khi quá lâu không kiểm chứng
  lại được mới bị nhắc/đánh dấu GRACE — ân hạn là trạng thái mềm,
  không phải khoá ngay.
- [BẰNG CHỨNG ÂM] **Thời lượng ân hạn không có trong strings** (không
  hằng số/chuỗi nào nêu số giờ/ngày). Muốn có con số phải dịch ngược
  hàm kiểm tra — ngoài phạm vi vòng quét strings này.

## 6. ĐIỂM GÁC TRONG TỪNG TÍNH NĂNG

[BẰNG CHỨNG] Mỗi module quyết định bằng cùng một phép kiểm tra của lõi
(log Core: `lic check%@: khong hop le -> khoa`). Ba module có dòng log
cổng riêng, đều gắn thẻ vòng phát triển "(4.1)" còn sót trong bản
thương mại (mỗi dòng có 2 bản — 2 slice):

| Module | Dòng log nguyên văn | Hành vi khi chưa kích hoạt |
|---|---|---|
| AppBridge | `chua kich hoat (4.1) -> khong host %@` | Không host app được chọn lên xe |
| SplitScreen | `CarSplit: thieu du lieu ban quyen (4.1) -> khong chia man` | Không chia màn hình |
| StartupScreen | `chua kich hoat (4.1) -> bo qua man khoi dong` | Bỏ qua màn chào |
| SpeedBubble | *(không có dòng log cổng riêng trong strings)* | [SUY RA] cổng chạy im lặng — engine vẫn nhúng đầy đủ (URL + từ điển lỗi có trong binary) nhưng nhà phát triển không gắn log riêng như 3 module kia |
| Core | `lic check%@: khong hop le -> khoa` | Phép kiểm tra chung + nơi gọi máy chủ |

[BẰNG CHỨNG] Điều kiện mở cổng suy từ từ điển trạng thái: token hợp
lệ (chữ ký đúng, `udid` khớp máy, chưa qua `expires`) **hoặc** trial
còn hạn **hoặc** đang trong ân hạn (§5) → mở; `nolicense` / token hỏng
(`LICENSE_STATUS_BAD`) / sai máy (`WRONGDEVICE`) / hết hạn → đóng.
[BẰNG CHỨNG] Gỡ bản quyền tại máy (`LICENSE_DEACTIVATE_CONFIRM`):
"Features stop until you activate again. The key stays bound to this
device." — gỡ chỉ xoá phía máy, key **vẫn gắn với máy ở phía server**
(kích hoạt lại bằng chính key đó được; `LICENSE_STATUS_HASKEY` =
"This device already has a key. Enter it again.").

## 7. HAI MÃ BĂM GHIM SẴN (SHA-256) — KIỂM TRA TOÀN VẸN

- [BẰNG CHỨNG] Cả 5 dylib chứa 2 hằng hex 64 ký tự (Prefs và app
  companion không có):
  `e8663a8b360c85c9b151e354d7bc62262e5b18edada7bc80c52cb32095ee972c`
  và `d6407325dca6ec9f864dfc7b0906930015a702318f851a9d7c30782fdfd4ba08`.
  Trong strings chúng nằm kề: `/Library/PreferenceBundles/OmniCarPrefs.bundle`,
  `PackageIcon.png`, <hash 1>, `logo@3x.png`, <hash 2>.
- [BẰNG CHỨNG] Tự kiểm chứng 2026-11-10: SHA-256 của
  `PackageIcon.png` trong gói 1.0.5 = đúng hash 1; SHA-256 của
  `logo@3x.png` = đúng hash 2.
- [SUY RA] Các module runtime **tự kiểm tra 2 file ảnh của Prefs
  bundle còn nguyên bản** (chống thay/sửa bundle Cài đặt — nơi chứa
  trang kích hoạt). Đây là lớp chống can thiệp phụ, độc lập với chữ ký
  ECDSA của token (§2.2). Hệ quả phụ đáng chú ý: thay logo/icon của
  Prefs bundle bằng bản tuỳ biến có thể làm phép kiểm tra này lệch.

## 8. ĐỊNH DANH THIẾT BỊ & "MÃ MÁY"

- [BẰNG CHỨNG] Engine đọc qua IOKit (`IOServiceMatching`,
  `IOServiceGetMatchingService`, `IORegistryEntryCreateCFProperty`,
  dịch vụ `IOPlatformExpertDevice`): trường `IOPlatformSerialNumber`
  (số seri máy) và `IOPlatformUUID`; cộng `hw.machine` (mã kiểu máy,
  qua sysctl) và trường `udid` trong bản ghi/token. Mẫu chuỗi nối
  định danh: `%@|%@|%@`.
- [BẰNG CHỨNG] Chuỗi UUID toàn 0 `00000000-0000-0000-0000-000000000000`
  nằm trong Core ngay trước khối license → giá trị dự phòng khi không
  đọc được UUID; đọc hỏng định danh → lỗi `nodevice`.
- [BẰNG CHỨNG] "Mã máy" phía người dùng: mục `LICENSE_DEVICE_TITLE` =
  "Device code" / "Mã máy", ghi chú "Tap to copy. Send it when you ask
  for support."; bấm là copy (`copyDeviceCode`, thông báo
  `LICENSE_DEVICE_COPIED` = "Copied %@"). Cả hai controller Prefs đều
  có method `deviceCode` — trang mua cũng hiển thị mã máy để người mua
  gửi cho người bán.
- [SUY RA — căn cứ: `_CC_SHA256` + mẫu định dạng `%02x` + chuỗi nối
  `%@|%@|%@` cùng cụm] Mã máy hiển thị nhiều khả năng là **dạng rút
  gọn/băm của bộ định danh** (seri|UUID|kiểu máy) chứ không phải seri
  thô; công thức chính xác không khôi phục được từ strings.

## 9. PHÍA CÀI ĐẶT (PREFS)

### 9.1 Mục ở trang gốc (Root.plist — [BẰNG CHỨNG] nguyên văn)
```json
{"label": "LICENSE_GROUP", "cell": "PSGroupCell"}
{"cell": "PSButtonCell", "id": "license", "label": "LICENSE",
 "symbol": "key.fill", "symbolColor": "#2563EB", "action": "showLicense"}
{"cell": "PSButtonCell", "id": "contact", "label": "CONTACT",
 "symbol": "envelope.fill", "symbolColor": "#34C759", "action": "contactDeveloper"}
```
Nhóm "Bản quyền" nằm giữa nhóm Hỗ trợ và nhóm Nhà phát triển; hàng
Liên hệ ở cuối trang. Không có action `omnicar://` nào cho bản quyền
(URL scheme chỉ có splitscreen — [BẰNG CHỨNG] quét toàn bộ).

### 9.2 `OMCLicenseController` — trang kích hoạt
[BẰNG CHỨNG — metadata ObjC, slice arm64] Method nghiệp vụ (bỏ các
getter/setter thuộc tính UI thuần):
`viewDidLoad`, `viewWillAppear:`, `viewWillDisappear:`, `dealloc`,
`enteredForeground`, `probeState`, `probeIfNeeded`, `refresh`,
`deviceCode`, `copyDeviceCode`, `showBuy`, `setBusy:`, `armReplyTimer`,
`trialTapped`, `activateTapped`, `removeTapped`, `replyArrived`,
`showError:`, `textFieldShouldReturn:` (khai báo
`UITextFieldDelegate`).
Ivar đáng chú ý: `_doneToken` (int — mã bắt tay chờ `license.done`),
`_pendingTrial`, `_probing`, `_busy`, 3 timer (`_replyTimer`,
`_probeTimer`, `_tickTimer`), các thẻ UI `_entryCard`, `_trialCard`,
`_buyCard`, `_trialProgress`, `_field` (ô nhập key), `_activateButton`,
`_removeButton`, `_trialButton`, `_statusIcon/_statusLabel/_statusSub`,
`_errorLabel`, `_deviceCodeLabel`, 2 spinner.
→ Trang có 3 thẻ: nhập key / dùng thử / mua; tự thăm dò trạng thái
khi mở trang và khi app quay lại foreground; đếm ngược trial chạy
bằng tickTimer.

### 9.3 `OMCLicenseBuyController` — trang mua
[BẰNG CHỨNG — metadata ObjC] Method đầy đủ: `viewDidLoad`, `close`,
`openContact:`, `openZalo`, `openFacebook`, `deviceCode`,
`setDeviceCode:`, `.cxx_destruct`; ivar duy nhất `_deviceCode`.
Đầu mối liên hệ [BẰNG CHỨNG — strings toàn cục]:
`https://zalo.me/0707570363`, `https://m.me/hoang.an.605213`,
email `omnicartweak@gmail.com` (mục Liên hệ: `CONTACT_EMAIL`,
`CONTACT_COPY`).

### 9.4 Ánh xạ trạng thái → biểu tượng (SF Symbol)
[BẰNG CHỨNG — cụm strings trong Prefs]
| Trạng thái | Khóa chữ | Symbol |
|---|---|---|
| Đã kích hoạt | LICENSE_STATUS_OK | `checkmark.seal.fill` |
| Đang kiểm tra | LICENSE_STATUS_CHECKING | `ellipsis.circle` |
| Chưa kích hoạt | LICENSE_STATUS_NONE | `lock.fill` |
| Hết trial | LICENSE_STATUS_EXPIRED | `hourglass` / `hourglass.bottomhalf.filled` |
| Ân hạn offline | LICENSE_STATUS_GRACE | `wifi.exclamationmark` |
| Sai thiết bị | LICENSE_STATUS_WRONGDEVICE | `iphone.slash` |
| Bản quyền hỏng | LICENSE_STATUS_BAD | `exclamationmark.triangle.fill` |
| Đã có key trên máy | LICENSE_STATUS_HASKEY | (hiển thị kèm hướng dẫn nhập lại) |

### 9.5 Luồng mua (nguyên văn EN — VI ở Phụ lục)
- Giá: `LICENSE_BUY_PRICE` "99,000₫" · `LICENSE_BUY_UNIT`
  "/ 1 key · 1 iPhone" · 4 quyền lợi: "Pay once, use forever" /
  "Every feature, free updates" / "Move it to a new iPhone" /
  "Friendly setup help".
- 3 bước: "Message us on Zalo or Facebook below" → "Pay by bank
  transfer as instructed" → "Get your key, paste it in the key box
  and tap Activate". Tên Facebook bán: `LICENSE_BUY_FB_NAME` =
  "Hoàng An". Mua số lượng: `LICENSE_BUY_BULK` "Buying several keys" +
  "Contact us for a better price".
- Định dạng key: `LICENSE_PLACEHOLDER` =
  `OMC-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX` (tiền tố OMC- + 8
  nhóm 4 ký tự). Lời dặn: `LICENSE_FOOTER` "Keep your key to activate
  again after a restore."
- Mục Ủng hộ đi kèm họ này (DONATE_*): [BẰNG CHỨNG] `DONATE_EMPTY` =
  "Ways to donate are coming in a future update…" và `DONATE_FOOTER`
  "…nothing in OmniCar is locked." → trang ủng hộ là khung để sẵn,
  chưa có phương thức thanh toán trong 1.0.5.

## 10. KÊNH DARWIN & KHÓA PREFS THEO MODULE SỞ HỮU

[BẰNG CHỨNG] Miền prefs `com.anlai.omnicar` (kênh `prefschanged`
chung). Kênh Darwin (tiền tố đầy đủ `com.anlai.omnicar/`):

| Kênh / khóa | Nơi xuất hiện | Vai trò [BẰNG CHỨNG + SUY RA] |
|---|---|---|
| `license.activate` | Core, Prefs | Prefs → runtime: yêu cầu kích hoạt key đang chờ |
| `license.trial` | Core, Prefs | Prefs → runtime: yêu cầu bắt đầu dùng thử |
| `license.probe` | Core, Prefs | Hai chiều: thăm dò trạng thái bản quyền hiện tại |
| `license.done` | Core, Prefs | Runtime → Prefs: đã có kết quả (Prefs chờ qua `replyArrived`/`_doneToken`) |
| khóa `licenseKeyPending` | Core, Prefs | Key người dùng vừa nhập, chờ runtime xử lý |
| khóa `licenseResult` | Core, Prefs | Bản ghi kết quả (trường con: `state`, `error`, `date`) |
| khóa `licenseProbe` | Core, Prefs | Dấu/yêu cầu thăm dò đang chờ |

[BẰNG CHỨNG] Cả 5 dylib đều **chứa** engine (gác cổng tại chỗ, §6)
nhưng chỉ Core + Prefs mang 4 kênh Darwin trên trong strings — khớp
kiến trúc §1: runtime qua Core làm đầu mối mạng, Prefs làm giao diện.
[BẰNG CHỨNG] Thư mục dữ liệu mới của toàn gói (không riêng bản
quyền): `/var/mobile/Library/OmniCar`; cụm `write` + `decrypt` kề
phong bì → [SUY RA] token/bản ghi sau giải mã được ghi xuống đây
hoặc vào prefs để các tiến trình cùng đọc.

## 11. NHỮNG GÌ STRINGS KHÔNG TRẢ LỜI ĐƯỢC
- Thời lượng ân hạn offline chính xác (số giờ/ngày) — cần dịch ngược.
- Việc máy chủ phân biệt activate/trial/probe bằng trường JSON nào —
  client không để lại chuỗi path/trường riêng ngoài từ điển §2.3.
- Công thức chính xác của "mã máy" hiển thị (§8 mới ở mức nguyên liệu).
- Khóa công khai EC ghim sẵn nằm dạng dữ liệu nhị phân, không trích
  nguyên văn từ strings được.

---
Nguồn trung gian: `~/workspace/omnicar-105/audit/deep/strings105/`
(strings thô 7 binary) · phân tích ObjC bằng bộ công cụ của dự án RE
(`~/workspace/omnicar-re/metadata/tools/macho_objc.py`).

## PHỤ LỤC — TOÀN BỘ KHÓA CHỮ BẢN QUYỀN (Localizable.strings, nguyên văn)

| Khóa | EN | VI |
|---|---|---|
| CONTACT | Contact | Liên hệ |
| CONTACT_COPIED | omnicartweak@gmail.com copied | Đã sao chép omnicartweak@gmail.com |
| CONTACT_COPY | Copy address | Sao chép địa chỉ |
| CONTACT_EMAIL | Send email | Gửi email |
| DONATE | Donate | Ủng hộ tác giả |
| DONATE_BODY | OmniCar is made by one person in their spare time. If it has been useful on your drives, a coffee goes a long way toward keeping it going. | OmniCar do một người làm, trong những giờ rảnh. Nếu OmniCar có ích trên những chuyến đi của bạn, một ly cà phê là lời động viên rất lớn để OmniCar tiếp tục tốt hơn. |
| DONATE_COPIED | %@ copied | Đã sao chép %@ |
| DONATE_EMPTY | Ways to donate are coming in a future update. Feedback and bug reports through Send log help just as much. | Cách ủng hộ sẽ có trong bản cập nhật tới. Góp ý và báo lỗi qua Gửi log cũng là một cách ủng hộ rất quý. |
| DONATE_FOOTER | Tap an item to copy the number. Donations are voluntary; nothing in OmniCar is locked. | Chạm một mục để sao chép số. Ủng hộ là tự nguyện, OmniCar không khoá tính năng nào. |
| DONATE_TITLE | Thank you | Cảm ơn bạn |
| LICENSE | Activate OmniCar | Kích hoạt OmniCar |
| LICENSE_ACTIVATE | Activate | Kích hoạt |
| LICENSE_ACTIVATED | Activated. Thank you! | Đã kích hoạt. Cảm ơn bạn! |
| LICENSE_ACTIVATING | Activating… | Đang kích hoạt… |
| LICENSE_BODY | One key works on one device. | Một mã bản quyền dùng cho một máy. |
| LICENSE_BUY | Buy a licence key | Mua key bản quyền |
| LICENSE_BUY_BULK | Buying several keys | Mua nhiều key |
| LICENSE_BUY_BULK_NOTE | Contact us for a better price | Liên hệ để nhận giá ưu đãi |
| LICENSE_BUY_CLOSE | Close | Đóng |
| LICENSE_BUY_CONTACT_HEAD | MESSAGE TO BUY | NHẮN ĐỂ MUA |
| LICENSE_BUY_FB_NAME | Hoàng An | Hoàng An |
| LICENSE_BUY_HOW_HEAD | HOW TO BUY | CÁCH MUA |
| LICENSE_BUY_PERK1 | Pay once, use forever | Trả một lần, dùng vĩnh viễn |
| LICENSE_BUY_PERK2 | Every feature, free updates | Đủ mọi tính năng, cập nhật miễn phí |
| LICENSE_BUY_PERK3 | Move it to a new iPhone | Đổi được sang iPhone mới |
| LICENSE_BUY_PERK4 | Friendly setup help | Hỗ trợ cài đặt tận tình |
| LICENSE_BUY_PRICE | 99,000₫ | 99.000đ |
| LICENSE_BUY_PRICE_HEAD | PRICE | GIÁ |
| LICENSE_BUY_STEP1 | Message us on Zalo or Facebook below | Nhắn Zalo hoặc Facebook bên dưới |
| LICENSE_BUY_STEP2 | Pay by bank transfer as instructed | Chuyển khoản theo hướng dẫn |
| LICENSE_BUY_STEP3 | Get your key, paste it in the key box and tap Activate | Nhận key, dán vào ô nhập mã rồi bấm Kích hoạt |
| LICENSE_BUY_UNIT | / 1 key · 1 iPhone | / 1 key · 1 iPhone |
| LICENSE_DEACTIVATE | Remove licence from this device | Gỡ bản quyền khỏi máy này |
| LICENSE_DEACTIVATE_CONFIRM | Features stop until you activate again. The key stays bound to this device. | Tính năng sẽ dừng tới khi kích hoạt lại. Mã vẫn gắn với máy này. |
| LICENSE_DEVICE_COPIED | Copied %@ | Đã copy %@ |
| LICENSE_DEVICE_NOTE | Tap to copy. Send it when you ask for support. | Bấm để copy. Gửi mã này khi cần hỗ trợ. |
| LICENSE_DEVICE_TITLE | Device code | Mã máy |
| LICENSE_EMPTY | Enter your key first | Nhập mã bản quyền trước |
| LICENSE_ERR_bad_key | Key not found or revoked. | Mã không đúng hoặc đã bị thu hồi. |
| LICENSE_ERR_badtoken | Could not verify the server's answer. Update OmniCar and try again. | Không xác minh được câu trả lời. Cập nhật OmniCar rồi thử lại. |
| LICENSE_ERR_key_used | This key is already used on another device. | Mã này đã dùng trên máy khác. |
| LICENSE_ERR_network | No connection to the server. Check the internet and try again. | Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại. |
| LICENSE_ERR_nodevice | Could not read this device's identity. | Không đọc được định danh máy. |
| LICENSE_ERR_rate | Too many requests. Wait a few minutes. | Thao tác quá nhanh. Đợi vài phút rồi thử lại. |
| LICENSE_ERR_server | Server error. Try again later. | Máy chủ trả lời lỗi. Thử lại sau. |
| LICENSE_ERR_timeout | No answer from OmniCar. Respring and try again. | OmniCar không trả lời. Respring rồi thử lại. |
| LICENSE_ERR_trial_closed | Trials are paused. Try again later. | Tạm ngưng cấp dùng thử. Thử lại sau. |
| LICENSE_ERR_trial_used | This device has already used its trial. | Máy này đã dùng thử rồi. |
| LICENSE_FOOTER | Keep your key to activate again after a restore. | Giữ mã để kích hoạt lại sau khi khôi phục máy. |
| LICENSE_GROUP | License | Bản quyền |
| LICENSE_LATER | Later | Để sau |
| LICENSE_PLACEHOLDER | OMC-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XXXX | (giống EN) |
| LICENSE_REMOVE | Remove | Gỡ |
| LICENSE_STATUS_BAD | Stored licence is damaged. Activate again. | Bản quyền trên máy bị hỏng. Kích hoạt lại. |
| LICENSE_STATUS_CHECKING | Checking… | Đang kiểm tra… |
| LICENSE_STATUS_EXPIRED | Trial ended | Hết hạn dùng thử |
| LICENSE_STATUS_GRACE | Not checked with the server for a long time. Go online. | Lâu chưa kiểm tra được máy chủ. Hãy kết nối mạng. |
| LICENSE_STATUS_HASKEY | This device already has a key. Enter it again. | Máy này đã có mã. Nhập lại mã để kích hoạt. |
| LICENSE_STATUS_NONE | Not activated | Chưa kích hoạt |
| LICENSE_STATUS_OK | Activated | Đã kích hoạt |
| LICENSE_STATUS_TRIAL_DAYS | Trial · %ld days left | Đang dùng thử · còn %ld ngày |
| LICENSE_STATUS_TRIAL_ENDS | Ends %@ | Hết hạn %@ |
| LICENSE_STATUS_TRIAL_HOURS | Trial · %ld hours left | Đang dùng thử · còn %ld giờ |
| LICENSE_STATUS_TRIAL_MINUTES | Trial · %ld minutes left | Đang dùng thử · còn %ld phút |
| LICENSE_STATUS_WRONGDEVICE | This licence belongs to another device | Bản quyền này thuộc máy khác |
| LICENSE_TITLE | Activate OmniCar | Kích hoạt OmniCar |
| LICENSE_TRIAL_BUTTON | Try free for 1 day | Dùng thử 1 ngày |
| LICENSE_TRIAL_NOTE | Try every feature free for 1 day. One trial per device. | Dùng thử miễn phí đủ tính năng trong 1 ngày. Mỗi máy một lần. |
| LICENSE_TRIAL_STARTED | Trial started! | Đã bắt đầu dùng thử! |
| LICENSE_TRIAL_STARTING | Starting… | Đang bắt đầu… |
| LICENSE_TRIAL_TITLE | No key yet? | Chưa có mã? |
