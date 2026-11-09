# THIẾT KẾ — YT-ZOOM: ẢO HOÁ HƯỚNG CHO YOUTUBE BỊ HOST (mẫu DuoFace) TRÊN OMNICAR

Ngày: 2026-11-09. Loại việc: thiết kế chỉ-đọc — không sửa code, không build, không git.
Lệnh gốc: Nguyen mở track riêng 2026-11-09 13:59 — "điều tra cơ chế zoom YouTube của
DuoFace rồi thiết kế bản tương đương cho OmniCar".
Nền bằng chứng: `invest-duoface-ytzoom.md` (kết luận (d): DuoFace ảo hoá hướng — ghim
portrait 3 tầng + lease kích thước cửa sổ; mask 24 không bao giờ rời process app; giao
thức host↔app không tồn tại sự kiện fullscreen) và `work/fix-round6/invest-ytzoom.md`
(bản đồ cơ chế hướng OmniCar hiện tại). Mọi điểm can thiệp phía OmniCar trong tài liệu
này đều đọc trực tiếp từ cây rebuilt `project/OmniCarAppBridge/`.

Mức bằng chứng: **[DF-SRC]** = source DuoFace QA180 đã đọc; **[DF-DEB]** = census hook
binary DuoFace gốc trong hồ sơ deb; **[OMC]** = source rebuilt OmniCar đọc trực tiếp
(có file:line); **[GOC]** = hành vi binary gốc OmniCar đã chứng minh ở các vòng trước;
**[SUY]** = suy luận, chưa có dữ kiện trực tiếp; **[DO]** = chỉ chốt được bằng đo trên xe.

Ràng buộc cứng của đề bài: (1) CLEAN-ROOM — cơ chế tương đương bằng kiến trúc/tên gọi
OmniCar, không chép source/định danh của DuoFace; các điểm hook UIKit là sự thật bề mặt
công khai thì dùng được. (2) Giao thức hướng fixround6/7 giữ nguyên cho mọi app khác và
cho chính YouTube khi không được host/không kích hoạt ảo hoá. (3) Không dùng lại ba kênh
`appbridge.apporient`, `appbridge.orientation`, `appbridge.keyboard` cho lease.
(4) Phạm vi v1: chỉ YouTube; kiến trúc không chặn mở rộng sau.

## 0. Chốt thiết kế trong một đoạn

Dựng cơ chế **ảo hoá hướng** cho đúng một bundle (`com.google.ios.youtube`) theo đúng
nguyên lý DuoFace đã chứng minh: khi YouTube được host vào ô, **hướng ngang không bao
giờ tồn tại** ở bất kỳ tầng nào — ABHost (SpringBoard) ghim settings scene ở orientation
1 và không hoán trục kích thước; ABHost cấp một **lease** (hợp đồng trạng thái có hạn
3 s, heartbeat 1 s) mang kích thước logic đã commit của ô xuống process YouTube;
ABInApp trong process YouTube, **chỉ khi lease còn hợp lệ**, trả lời mọi truy vấn hướng
bằng Portrait, viết lại mọi lệnh xoay cửa sổ thành Portrait, và tự đặt lại cửa sổ theo
lease mỗi khi kích thước ô đổi. Tuyên bố mask 24 của player bị **tiêu thụ tại chỗ** trong
process app (không publish lên `appbridge.apporient`), và phía host có một cổng thứ hai
tại `appWithHash:` chặn mọi gói apporient lọt qua cho pane đang ảo hoá. Lease vắng/hết
hạn/thu hồi → mọi hook trở về IMP gốc ngay tại lần gọi kế tiếp, đường r6 trở lại nguyên
vẹn — không trạng thái latch nào giữ app ở portrait. Cú bấm fullscreen vì thế không còn
là một "sự kiện" ở bất kỳ tầng nào: player nở video trong cửa sổ hiện hữu vốn đã có đúng
hình dạng ô — hết tumble theo đúng cơ chế DuoFace. **[DF-SRC cho nguyên lý; OMC cho
điểm nối; DO cho kết quả thị giác cuối cùng]**

## 1. Nguyên lý đích và điều KHÔNG làm

- Đích là **không có gì xảy ra** ở mốc bấm fullscreen: không transaction xoay, không
  hoán trục, không thương lượng hướng. Mọi khác biệt so với OmniCar hiện tại nằm ở
  trạng thái đứng yên TRƯỚC khi bấm (portrait bị ghim + cửa sổ theo lease), không nằm
  ở phản ứng với cú bấm. [DF-SRC §1.1–§1.2]
- KHÔNG làm: đáp-tap bằng hành động hình học (phình ô/solo tạm khi player xin ngang) —
  trường hợp (c) đã bị điều tra loại hẳn [DF-SRC §0]; KHÔNG sửa phép suy hướng r6
  (mask 24 → 4 vẫn đúng cho mọi app không ảo hoá) [GOC]; KHÔNG đụng pinch zoom-to-fill
  trong player — đó là video-gravity nội bộ, bridge không nhìn thấy và không liên quan
  [GOC, invest-ytzoom §1.4]; KHÔNG hook `UIDevice setOrientation:` kiểu xoay device
  toàn cục và KHÔNG hook `UIApplication statusBarOrientation` ở v1 — cả hai đều là
  điểm DuoFace GỐC có nhưng QA180 chủ đích bỏ, và cơ chế vẫn đạt [DF-DEB + DF-SRC §4].
  (`statusBarOrientation` chỉ quay lại qua cửa phương án dự phòng §10.)

## 2. Ánh xạ 3 tầng DuoFace → thành phần OmniCar (tổng quan)

| Tầng DuoFace [DF-SRC] | Thành phần OmniCar tương đương | Thay đổi |
|---|---|---|
| (i) Chính sách scene phía SpringBoard: scene handle chỉ "hỗ trợ" orientation 1; setter kích thước tham chiếu bị thay bằng kích thước host; commit settings sửa orientation 2..4 → 1 trong cùng transaction | ABHost ghi settings FBScene qua `ABSceneSettingsApply` — được gọi từ `layoutPane:` (và bản chỉ-frame từ `nudgePane:`) [OMC ABHostBMethods.m:642, 686, 724]. Quyết định hướng tập trung tại `appWithHash:` — điểm ghi DUY NHẤT của `requestedOrientation` [OMC :562; GOC] | Thêm cổng tại `appWithHash:` + ghim hướng hiệu lực = 1 cho pane đang lease tại đúng 2 điểm tiêu thụ `effectiveOrientation:` (`layoutPane:` :705, `nudgePane:` :729) + một transaction sửa lúc cấp lease. **Không thêm hook SpringBoard mới nào** (lý do §3.3) |
| (ii) Lease host→app: NSDistributed dict {owner, sceneIdentifier, generation, hạn 3 s, active, orientation=1, width, height, isSplit}; throttle phát 0,30 s; poll gia hạn 0,35 s | Kênh NSDistributed MỚI `appbridge.ytlease` (object = bundleID, mẫu địa chỉ hoá của `ABChanOrientation`) do ABHost phát; kích thước = kích thước logic ABHost vừa commit trong `layoutPane:` | Mới hoàn toàn (§4). Khác DuoFace: danh tính theo **bundle** thay vì sceneIdentifier (kiến trúc OmniCar vốn bundle-scoped ở mọi kênh); sceneIdentifier vẫn được mang theo khi host có sẵn (§5.4) |
| (iii) Tầng app: 6 hook ảo hoá chỉ sống khi lease hợp lệ + relay đặt lại cửa sổ theo lease + ack đo đạc | ABInApp đã có sẵn hạ tầng: cài hook lười trong `ABOrientationBlock` [OMC ABInApp.m:655], 2/6 bề mặt đã được hook với ngữ nghĩa thương lượng, 3 hook "báo cáo" là điểm tiêu thụ tuyên bố | Thêm 4 hook trả-lời + đổi thứ tự ưu tiên của 2 hook sẵn có khi lease sống + câm 3 hook báo cáo khi lease sống + relay cửa sổ mới (§5) |

Điểm neo vòng đời có sẵn hai phía, không phải chế: phía host, launch-complete tại
`setupLiveAppViewForPane:` (khối afterLaunch: `ABPostOrientationToApp` :1673 →
`layoutPane:` → reveal/ready) là nơi pane bắt đầu sống thật; `teardownPane:` :1519
(post orientation −1 tại :1528) là nơi pane chết. Phía app, `ABOrientationBlock` là
điểm cài một-lần mọi hook trong app (BridgeWake đã neo cùng chỗ) [OMC].

## 3. Tầng (i) — chính sách portrait phía scene (ABHost)

### 3.1 Đường ghi settings hiện tại (sự thật, không sửa ở tầng này)

- `-[ABHost layoutPane:]` (ABHostBMethods.m:686): tính `logical = round(box/zoom)`,
  hoán trục khi hướng hiệu lực ∈ 3..5, rồi `ABSceneSettingsApply` ghi MỘT transaction
  `updateSettingsWithBlock:` = {setFrame: {0,0,logical}, setInterfaceOrientation:,
  setBackgrounded: NO, setForeground: YES} (:642–661).
- `-[ABHost nudgePane:]` (:724): ghi settings chỉ-frame (kích thước theo cùng luật
  hoán trục, thành phần thứ hai −1 pt), +0,05 s gọi lại `layoutPane:`. Caller duy nhất
  của `nudgePane:` là `appWithHash:` (:581) [OMC — grep toàn module].
- `-[ABHost appWithHash:changedOrientation:supportedMask:]` (:562): tiêu thụ gói
  `appbridge.apporient` (consumer `ABAppOrientDispatch`, ABHostGeometry.m:149), suy
  hướng từ mask (cực bit-2 đã sửa ở fixround6), ghi `pane.requestedOrientation`, gọi
  `nudgePane:`. Đây là điểm ghi duy nhất của `requestedOrientation` trong toàn binary
  [GOC] — cổng chặn duy nhất cần thiết phía host nằm ở đây.
- `pane.orientation` (hướng "lắng" của ô) được ghi một lần tại `openApp:` từ pref
  `appBridgeOrientation` (mặc định @1; giá trị 3/4 bị zero hoá) [OMC ABHostLaunch.m:176–179].

### 3.2 Ba can thiệp (toàn bộ chính sách scene của v1)

1. **Cổng tiêu thụ tại `appWithHash:`** — ngay đầu hàm, trước phép suy: nếu pane đích
   đang có lease sống (hàm kiểm `yzLeaseActiveForBundle:` của TU mới §9) → **không**
   ghi `requestedOrientation`, **không** gọi `nudgePane:`, ghi log `[ytz]` (throttle
   theo pane, §8.2) rồi return. Mọi đường r6 khác trong hàm giữ nguyên từng dòng —
   cổng chỉ chạy khi lease sống, tức chỉ với YouTube đang ảo hoá.
2. **Ghim hướng hiệu lực tại 2 điểm tiêu thụ** — `layoutPane:` (:705) và `nudgePane:`
   (:729) hiện cùng đọc `[self effectiveOrientation:pane]`. Đổi thành đọc qua một
   helper của TU mới: `yzEffectiveOrientation:` — trả **1** nếu pane đang lease sống,
   ngoài ra trả đúng `[self effectiveOrientation:pane]`. Hệ quả tự động: không hoán
   trục (1 ∉ 3..5), settings ghi orientation 1, tại cả transaction đầy đủ lẫn nhịp
   nudge. Ngoài lease, hành vi bit-exact như hiện tại.
3. **Transaction sửa tại thời điểm cấp lease** — khi lease được cấp cho một pane đã
   sống (đã từng nhận hướng r6 trước đó, `requestedOrientation` có thể đang = 4 và
   settings đang ngang): issuer xoá `pane.requestedOrientation = 0` rồi gọi một lần
   `layoutPane:` — transaction này chính là "portrait repair" của DuoFace ánh xạ sang
   OmniCar: frame về kích thước logic không hoán trục + orientation 1 trong cùng một
   `updateSettingsWithBlock:`. Sau đó issuer mới phát lease (app chỉ kích hoạt ảo hoá
   khi scene đã portrait thật — thứ tự không thể đảo). Tại mọi lần phát lease sau đó,
   issuer kiểm tra lại: nếu `requestedOrientation != 0` trong lúc lease sống (không
   thể xảy ra khi cổng 1 đứng vững — đây là đai dự phòng) → lặp lại bước sửa và ghi
   log cảnh báo.

### 3.3 Điểm cố ý KHÔNG thêm — và lý do

- **Không hook `SBDeviceApplicationSceneHandle _mainSceneSupportsInterfaceOrientation:`**
  (điểm DuoFace dùng để scene handle chỉ nhận 1): trong kiến trúc OmniCar, hướng của
  scene bị host do ABHost làm **người ghi duy nhất** qua `layoutPane:`/`nudgePane:`
  [GOC + OMC §3.1]; không có đường SpringBoard nội bộ nào khác tự xoay scene bị host
  trong các phiên đã đo — scene được trình bày bên trong ABBoxView và settings của nó
  là giá trị ABHost sở hữu. Thêm hook này là thêm bề mặt rủi ro vào class hệ thống mà
  không có mắt xích quyết định nào cần nó. **[SUY ở mức kiến trúc — phép đo §8.3 mục 1
  sẽ lộ nếu sai: nếu scene từng tự về hướng ≠ 1 trong lúc lease sống, log ack phía app
  (§4.4) và dòng settings tại `layoutPane:` sẽ cho thấy, và hook này là bước leo
  thang đã định danh sẵn.]**
- **Không hook `setContentReferenceSize:` / không đổi `ABHook_SBSceneViewRefSize`**
  (sub_7764, đang clamp orientation > 4 → 3 cho SBSceneView): DuoFace phải thay kích
  thước tại setter đó vì đó là đường kích thước của nó; OmniCar áp kích thước trực
  tiếp bằng FBScene settings trong `layoutPane:` — quyền kích thước đã ở phía host.
  Hook sub_7764 giữ nguyên, không gán thêm vai trò.

## 4. Tầng (ii) — kênh lease

### 4.1 Tên kênh (mới, không dùng lại ba kênh bị cấm)

| Tên | Vận chuyển | Chiều | Vai trò |
|---|---|---|---|
| `com.anlai.omnicar/appbridge.ytlease` | NSDistributed, object = bundleID đích | ABHost → app | Lease (trạng thái đầy đủ) |
| `com.anlai.omnicar/appbridge.ytleaseack` | NSDistributed, object = bundleID nguồn | app → ABHost | Ack đo đạc + xin cấp (phase, §4.4) |

Hai tên khai tại `ABChannelNames.m` cạnh các `ABChan*` hiện có [OMC :26–39] và là
hằng `NSString *const` mới (`ABChanYTLease`, `ABChanYTLeaseAck`); phía app dùng bản
sao file-local theo đúng tiền lệ BridgeWake (integration diff hai bản = 0). Chọn
NSDistributed + dictionary thay vì Darwin đóng gói số: lease mang chuỗi (owner,
sceneID) và số đo thập phân — cùng lý do `ABChanOrientation` dùng dictionary trong
khi `apporient`/`keyboard` (chỉ số nguyên nhỏ) mới đóng gói [OMC ABChannelNames.m:11–17].

### 4.2 Payload lease (v1)

```
{ version: @1, owner: <NSString UUID>, generation: <NSNumber>,
  issuedAt: <NSNumber, giây epoch>, active: <BOOL>, orientation: @1,
  width: <double>, height: <double>, isSplit: <BOOL>,
  sceneID: <NSString, CHỈ khi host có — §5.4> }
```

- `owner`: UUID sinh một lần khi registrar SpringBoard chạy (`ABSpringBoardReady`,
  ABHostGeometry.m:89) — định danh phiên ABHost. SpringBoard respring = owner mới.
- `generation`: tăng **chỉ khi nội dung đổi** (active, width, height, isSplit, sceneID);
  heartbeat giữ nguyên generation. Bắt đầu từ 0 ở mỗi owner.
- `issuedAt`: đồng hồ tường của cùng một thiết bị — hai process so tuổi được trực tiếp
  (DuoFace dùng cùng cách [DF-SRC §2.3]). Hạn dùng: **3,0 s** kể từ issuedAt.
- `width/height`: kích thước logic **đã commit** của ô — lấy từ chính transaction
  `layoutPane:` vừa ghi (§4.3), không bao giờ là kích thước đang kéo dở/live — đúng
  luật DuoFace "chỉ phát kích thước đã commit" [DF-SRC §1.1].
- `isSplit`: suy phía host = (số pane đang host > 1) ∧ ¬(cờ `single` gần nhất của
  pane đó — ABHost nhận `single` trong mọi gói frame qua `ABFrameBlock` →
  `setBarVisible:...single:forApp:` [OMC ABHostGeometry.m:237]). Trường này chỉ điều
  khiển bước đọc-lại §5.5 phía app; sai lệch của nó không phá cơ chế chính. **[SUY —
  điểm suy `single` là diễn giải của thiết kế, chưa có phép đo riêng]**

### 4.3 Nhịp phát và điểm phát (phía ABHost, TU mới §9)

- **Phát tại `layoutPane:`**: cuối thân `layoutPane:`, sau khi transaction settings
  đã ghi, issuer được gọi với đúng hai local vừa commit (`logical` sau ghim — với
  pane đang lease thì không hoán trục — và hướng đã dùng). Đây là nguồn sự thật duy
  nhất của kích thước lease: lease không bao giờ lệch khỏi settings thật quá một
  nhịp layout. Phát có **throttle nội dung 0,30 s** [DF-SRC]: nếu nội dung không đổi
  và lần phát trước < 0,30 s → bỏ qua (heartbeat lo phần gia hạn).
- **Heartbeat 1,0 s**: một NSTimer lặp trong TU lease, chỉ chạy khi có ≥ 1 lease
  đang sống; mỗi nhịp tái phát lease hiện hành (cùng generation, issuedAt mới).
  1,0 s so với hạn 3,0 s = dung sai mất 2 nhịp liên tiếp mà app chưa hết hạn —
  đây là thành phần DuoFace làm bằng poll 0,35 s/throttle 0,30 s [DF-SRC]; OmniCar
  chọn 1,0 s vì NSDistributed là kênh đắt hơn Darwin và hạn 3 s cho đủ biên. **[SUY
  về con số 1,0 — chốt bằng đo §8.3 mục 7: không được có lần hết-hạn-oan nào trong
  một phiên xem dài.]**
- **Phát ngay không throttle**: cấp lần đầu, thu hồi (active = NO), đổi owner.

### 4.4 Điều kiện cấp / gia hạn / thu hồi

| Sự kiện | Hành động của issuer |
|---|---|
| Launch-complete của pane YouTube (khối afterLaunch, ABHostBMethods.m:1673) và pref đang BẬT | Cấp: sửa residue (§3.2.3) nếu cần → phát lease active, gen theo nội dung |
| `layoutPane:` commit cho pane đang lease (đổi kích thước ô: kéo divider dứt điểm, solo, swap) | Phát lại với width/height mới, gen++ (throttle 0,30 s) |
| Nhịp heartbeat 1,0 s | Gia hạn mọi lease sống (issuedAt mới, gen giữ nguyên) |
| Nhận ack phase = `request` (§4.5) cho pane đang host + pref BẬT | Phát lease ngay (bỏ throttle) — chữa race app sống dậy trước khi host cấp |
| `teardownPane:` (trước dòng post orientation −1 :1528) / `closeApp:` / `carDisconnected` | Thu hồi: phát lease active = NO (không throttle), xoá trạng thái lease của pane, dừng heartbeat nếu hết lease |
| Pref `youtubeVirtualize` bị TẮT giữa phiên (§8.1) | Thu hồi mọi lease như trên; cổng `appWithHash:` tự mở lại vì lease không còn sống |
| Pref được BẬT giữa phiên, pane YouTube đang host | Cấp ngay tại sự kiện prefschanged, không chờ layout kế tiếp |

Điều kiện cấp luôn gồm đủ ba: pref BẬT ∧ bundle == `com.google.ios.youtube` ∧ pane
đang tồn tại trong `ABHost.panes`. Không cấp cho pane chưa launch-complete (kích
thước chưa commit lần đầu) — điểm neo launch-complete ở bảng trên lo điều này.

### 4.5 Kênh ack/request (app → host)

Payload: `{ identifier, phase, generation, windows, width, height, mismatch }`.

- phase `request`: app đang được host (đã nhận `appbridge.orientation` ≥ 1) nhưng
  không có lease hợp lệ — phát throttle 2 s. Đây là đường chữa race duy nhất phía app
  được phép "nói" — nó không mang dữ kiện hướng nào.
- phase `applied`: sau mỗi lần relay áp lease có nội dung đổi (§5.4): `windows` = số
  cửa sổ đã đặt lại, `width/height` = kích thước cửa sổ đo lại sau áp, `mismatch` =
  số cửa sổ không đạt kích thước lease. Đây là bằng chứng đo của phiên xe (§8.3):
  host chỉ ghi log `[ytz] ack ...`, không hành động gì thêm.
- phase `revoked` / `expired`: app báo đã rời ảo hoá và vì sao — host ghi log; nếu là
  `expired` trong lúc pane còn host và pref còn BẬT, host phát lại lease ngay (vòng
  tự chữa có giới hạn: tối đa 3 lần liên tiếp cho cùng một pane, sau đó chỉ còn
  heartbeat — chống vòng lặp phát/nhận khi hai phía bất đồng về đồng hồ).

### 4.6 Luật chấp nhận phía app (chống lạc phiên)

App giữ bộ ba (owner, generation, issuedAt) của lease mới nhất đã nhận. Một lease đến
được chấp nhận khi: object khớp bundle của chính app (địa chỉ hoá lo sẵn) ∧
version == 1 ∧ orientation == 1 ∧ issuedAt không cũ hơn issuedAt đã chấp nhận của
cùng owner ∧ tuổi ≤ 3,0 s. Đổi owner: chỉ chấp nhận khi lease hiện hành đã hết hạn
hoặc lease mới có generation == 0 kèm issuedAt tươi (dấu hiệu phiên host mới) — khi
chấp nhận đổi owner thì reset toàn bộ trạng thái ảo hoá trước khi áp (mẫu DuoFace:
đổi owner/scene thì reset [DF-SRC §2.3]). Lease thiếu khoá / sai kiểu → bỏ qua + log
`[ytz] lease hong`, không đổi trạng thái. active = NO từ đúng owner hiện hành = thu
hồi hợp lệ, hiệu lực ngay.

## 5. Tầng (iii) — phía app (ABInApp): chặn tuyên bố + relay cửa sổ

### 5.1 Điều kiện sống và điểm cài

- **Điều kiện sống duy nhất của ảo hoá là lease hợp lệ** (§4.6). App không đọc pref,
  không đọc plist (bài học QA179, cùng luật BridgeWake [OMC ABInApp.m:88]).
- **Chỉ cài trong process YouTube**: toàn bộ máy YZ (observer lease + 4 hook mới +
  trạng thái) chỉ tồn tại khi bundle của process == `com.google.ios.youtube`. Mọi
  app khác: không observer, không hook mới, không một dòng code YZ nào chạy.
- Observer lease đăng ký tại `ABInstallInAppObservers` (cùng nơi BridgeWake đăng ký
  observer close/closeall [OMC ABInApp.m:833]) với điều kiện bundle ở trên — lease có
  thể tới trước cả gói orientation đầu tiên; app lưu lease lại, chưa áp gì.
- 4 hook trả-lời mới cài trong khối one-shot của `ABOrientationBlock` [OMC :655],
  ngay sau `BWInstallBridgeWake()` (:731) và dưới cùng điều kiện bundle — tức chỉ
  tồn tại trong phiên được host, đúng tiền lệ wake. Nếu lease đã nằm chờ từ trước,
  kích hoạt ngay sau cài. Teardown: `BWResetAll()` đã được gọi tại observer
  close/closeall (:841) — YZ đăng ký reset của mình cạnh đó (`YZResetAll()`): rời
  ảo hoá + khôi phục snapshot (§5.4) + xoá lease đã lưu.

### 5.2 Sáu bề mặt trả-lời — đối chiếu DuoFace × OmniCar trên iOS 16.7.16

| # | Bề mặt (UIKit) | DuoFace | OmniCar hiện tại [OMC] | Thiết kế v1 |
|---|---|---|---|---|
| 1 | `UIViewController -supportedInterfaceOrientations` | Hook → Portrait mask [DF-SRC/DEB] | Chưa hook (chỉ bị **đọc** bởi `ABSupportedOrientationMask()` :1058) | **Thêm hook**: lease sống → trả `UIInterfaceOrientationMaskPortrait` (2); ngoài lease → IMP gốc. Cài không điều kiện thêm (method công khai, luôn tồn tại) |
| 2 | `UIViewController -__supportedInterfaceOrientations` | Hook → Portrait mask [DF-SRC/DEB] | Chưa hook | **Thêm hook**, cùng đáp án #1. Cài có guard tồn tại method (mẫu `OMCHasMethod`/class_getInstanceMethod như khối cài hiện tại :695) — selector private, vắng thì bỏ qua + log, không crash |
| 3 | `UIWindowScene -interfaceOrientation` | Hook (đúng scene được thuê) → Portrait [DF-SRC/DEB] | Chưa hook | **Thêm hook**: lease sống ∧ self là scene được thuê (§5.4) → trả 1; ngoài ra IMP gốc. Property công khai từ iOS 13, tồn tại chắc chắn trên 16.7.16 [SUY mức "chắc chắn" theo bề mặt API công khai] |
| 4 | `UIDevice -orientation` | Hook → Portrait [DF-SRC/DEB] | **Đã hook** `ABHook_UIDeviceOrientation` (:977): ABAppOrientation > 0 → nó; else ABDeviceFake; else gốc | **Đổi ưu tiên khi lease sống**: kiểm lease trước mọi thứ → trả 1. Ngoài lease: thân hàm giữ nguyên từng dòng |
| 5 | `UIWindow -_rotateWindowToOrientation:updateStatusBar:duration:skipCallbacks:` | Hook → thay đối số thành Portrait [DF-SRC/DEB] | Chưa hook | **Thêm hook**: lease sống → thay orientation = 1, giữ nguyên 3 đối số còn lại, gọi gốc; ngoài lease → gọi gốc nguyên vẹn. Guard tồn tại method khi cài |
| 6 | `UIWindow -_setRotatableViewOrientation:duration:force:` | Hook → Portrait + force = YES [DF-SRC/DEB] | **Đã hook** `ABHook_UIWindowSetRotatable` (:996): thay bằng hướng hiệu lực của máy thương lượng | **Đổi ưu tiên khi lease sống**: orientation = 1, **force = YES** (số của DuoFace — ép view chốt portrait kể cả khi UIKit tưởng đã đúng [DF-SRC]); ngoài lease: thân hàm giữ nguyên |

Tổng kết đếm hook cho log verdict: 6 bề mặt trả-lời (2 sẵn có chuyển nghĩa theo lease
+ 4 mới) — khớp con số `hooks = 6` của DuoFace. Ba hook **báo cáo** sẵn có
(`setNeedsUpdateOfSupportedInterfaceOrientations`, `requestGeometryUpdateWithPreferences:`,
`UIDevice setOrientation:animated:`) không nằm trong 6 bề mặt này; chúng thuộc cơ chế
phân xử §6 (bị câm khi lease sống), không phải bề mặt trả-lời.

Nhận định đủ/thừa/thiếu trên iOS 16.7.16: bộ 6 của DuoFace được chứng minh trên đúng
thế hệ iOS 16 (QA180 chạy iOS 16; census binary gốc chứa cả 6 IMP) [DF-SRC §4,
DF-DEB] — đó là bằng chứng chuyển giao mạnh nhất hiện có, nhưng bề mặt player của
YouTube là binary đóng: việc bộ 6 **đủ** cho player trên OmniCar là **[SUY]**, chỉ
phép đo §8.3 mục 1 mới nâng lên đã chứng. Không điểm nào trong 6 là thừa theo bằng
chứng DuoFace; điểm nghi thừa nhất là #2 (bản private của #1) — vẫn giữ vì DuoFace
gốc lẫn QA180 đều cài và chi phí của nó bằng 0 khi guard đúng. Điểm có thể thiếu đã
định danh sẵn ở §10 (statusBarOrientation) — không cài ở v1 theo đúng lựa chọn của
QA180 [DF-SRC §4].

### 5.3 Kích hoạt / rời ảo hoá (máy trạng thái phía app)

- **Vào**: lease hợp lệ đầu tiên (§4.6) → đặt trạng thái `YZActive = YES`, chụp
  mốc generation; nếu nội dung lease khác trạng thái cửa sổ hiện hành → chạy relay
  áp (§5.4). Các hook trả-lời bắt đầu đáp theo lease từ thời điểm này — vì mọi hook
  đều kiểm `YZActive ∧ lease còn tươi` **tại thời điểm được gọi**, không có cửa sổ
  chuyển đổi nào cần đồng bộ thêm.
- **Đổi nội dung lease** (width/height/isSplit/sceneID đổi, gen tăng): relay áp lại.
  Heartbeat (cùng gen, issuedAt mới): chỉ gia hạn mốc tươi, không áp gì.
- **Thu hồi hợp lệ** (active = NO, đúng owner): rời ảo hoá + **khôi phục snapshot**
  cửa sổ (§5.4) + ack phase `revoked`.
- **Hết hạn lặng** (watchdog §5.6 thấy tuổi lease > 3,0 s): rời ảo hoá nhưng
  **KHÔNG khôi phục snapshot** — chủ đích theo QA175 [DF-SRC §1.3]: hình học host
  đã chốt có thể đã đi xa, giật ngược cửa sổ về snapshot cũ là tệ hơn. Sau khi rời:
  ack phase `expired` + bắt đầu xin lease lại (phase `request`, throttle 2 s) chừng
  nào còn được host. Đường r6 tự trở lại từ tuyên bố kế tiếp của app.
- **Đổi owner** (§4.6): reset sạch (coi như thu hồi không khôi phục) rồi áp lease mới.

### 5.4 Relay đặt-lại-cửa-sổ theo lease

Chạy trên main queue mỗi khi relay áp (vào ảo hoá, đổi kích thước/split):

1. **Chọn scene được thuê**, theo 3 tầng, ghi log tầng đã khớp (`match=id|single|key|none`):
   (a) lease có `sceneID` → duyệt các UIWindowScene đang kết nối, đọc định danh
   FBScene của scene qua đường key-path được bảo vệ (@try + kiểm respondsToSelector,
   mẫu `ABSceneOfPane` [OMC ABHostBMethods.m:663]) và khớp chuỗi; (b) không có
   sceneID hoặc không khớp → nếu app có đúng một UIWindowScene có cửa sổ, dùng nó;
   (c) còn lại → scene của key window (`ABKeyWindow()` sẵn có [OMC ABInApp.m:1047]).
   Không tầng nào khớp → không áp, ack với `windows = 0, mismatch = -1` (dữ kiện đo,
   không phải lỗi im lặng). Việc định danh FBScene đọc được từ trong app hay không
   là **[SUY — chờ đo]**: tầng (a) là thử đầu tiên, (b)/(c) là đường lui đã thiết kế
   sẵn chứ không phải vá sau.
2. **Chọn cửa sổ** trong scene đó: windowLevel == normal, có rootViewController,
  không thuộc lớp cửa sổ bàn phím/text-effects (lọc theo tên class — mẫu lọc của
   DuoFace [DF-SRC §1.3], áp bằng tên class của OmniCar tự đặt cho bộ lọc của mình).
3. **Snapshot lần đầu** cho mỗi cửa sổ (trước khi sửa): {frame, bounds} — lưu theo
   cửa sổ; snapshot chỉ bị ghi đè khi cửa sổ chưa từng được chụp trong phiên lease
   hiện hành.
4. **Áp**: với từng cửa sổ — gọi API xoay riêng `_rotateWindowToOrientation:`(1,
   updateStatusBar: NO, duration: 0, skipCallbacks: YES) qua IMP gốc của hook #5
   (đi thẳng UIKit, không qua lớp publish nào), rồi `frame = bounds = {0, 0, width,
   height}` của lease, rồi `layoutIfNeeded`. Thứ tự xoay-trước-gán-khung theo đúng
   trình tự relay DuoFace [DF-SRC §1.3].
5. **Đo lại + ack**: đếm cửa sổ đã áp; đo lại bounds của từng cửa sổ, `mismatch` =
   số cửa sổ lệch kích thước lease > 1 pt; phát ack phase `applied` (§4.5).

### 5.5 Bước đọc-lại sau áp (0,12 s, chỉ khi split)

Sau khi relay áp, nếu cửa sổ đích vẫn "tin" hướng ≠ 1 (đọc qua bề mặt riêng mà relay
vừa dùng — cửa sổ nào còn lệch thì ghi log), và lease báo `isSplit` = YES: sau
**0,12 s** [DF-SRC] phát đúng một lần: `setNeedsUpdateOfSupportedInterfaceOrientations`
lên root VC (hook báo cáo đang bị câm §6 nên không publish gì — chỉ là cú đánh thức
UIKit đọc lại đáp án Portrait từ hook #1/#2) + gọi **IMP gốc** của
`requestGeometryUpdateWithPreferences:errorHandler:` với preferences mang mask
Portrait trên scene được thuê (đi thẳng UIKit, vòng qua hook để không phát sinh báo
cáo — xem §6). Đây là lần duy nhất phía app chủ động gọi API geometry iOS 16, và nó
xin Portrait — ngược chiều đường geometry của r6, đúng như DuoFace [DF-SRC §1.3].
Nhu cầu thật của bước này trên OmniCar là **[SUY]** (nó sinh ra từ một log thiết bị
cũ của DuoFace [DF-SRC §4]); giữ vì chi phí thấp và có log riêng để phiên đo phán
nó có từng bắn hay không.

### 5.6 Watchdog hết hạn

Timer 0,5 s [DF-SRC] trong TU app: kiểm tuổi lease; quá 3,0 s → rời ảo hoá theo
nhánh hết-hạn-lặng (§5.3). Timer chỉ là cơ chế dọn dẹp cho các đường không có hook
nào được gọi (app đứng yên) — **tính đúng của các đáp án không phụ thuộc timer**:
mọi hook trả-lời tự kiểm tuổi lease tại thời điểm gọi, nên lease vừa hết hạn thì
đáp án gốc trở lại ngay ở lần gọi đầu tiên sau đó, kể cả khi timer chưa bắn.

## 6. Phân xử xung đột với kênh `appbridge.apporient`

Nguyên tắc: **một app tại một thời điểm chỉ có một chủ quyết định hướng.** Khi lease
sống, chủ là ảo hoá; ngoài lease, chủ là r6. Hai cổng độc lập chặn tuyên bố ở cả hai
phía của kênh, để không phía nào phải tin phía kia đã chặn:

### 6.1 Cổng phía app — ba hook báo cáo bị câm khi lease sống

Ba điểm hiện đang publish lên `appbridge.apporient` [OMC ABInApp.m]:
`ABHook_VCSetNeedsUpdate` (:1029, publish sentinel 0xFF),
`ABHook_SceneRequestGeometry` (:1013, publish đáp số đã suy),
`ABHook_UIDeviceSetOrientation` (:966, publish giá trị đã lọc {3,4}) — qua
`ABScheduleAppOrientationPublish` (debounce 0,25 s, :1079).

Thiết kế: mỗi hook kiểm lease **trước** phần publish — lease sống → gọi IMP gốc (với
`setOrientation:animated:` thì gọi gốc và không ghi `ABAppOrientation`), **không**
lên lịch publish, thêm đúng một dòng log `[ytz] tieu thu tuyen bo (lease song)` có
throttle. Ngoài lease: thân hàm giữ nguyên từng dòng, kể cả debounce và đóng gói.
`ABAppOrientation` bị đóng băng trong suốt lease (không ai ghi) — hai hook trả-lời
#4/#6 cũng không đọc nó khi lease sống (ưu tiên lease đứng trước, §5.2), nên khi
lease rời, giá trị cũ của nó chỉ còn là dữ kiện r6 quá khứ và sẽ bị ghi đè bởi tuyên
bố kế tiếp theo đúng luật r6 hiện tại.

### 6.2 Cổng phía host — `appWithHash:` (§3.2.1)

Dù app đã câm, gói apporient vẫn có thể tới host từ: tuyên bố phát ra **trước** khi
lease kích hoạt còn đang nằm trong debounce 0,25 s; một process khác cùng bundle
(không có); hoặc lỗi phía app. Cổng tại `appWithHash:` (§3.2.1) là đai thứ hai: pane
đang lease sống → gói bị tiêu thụ, không ghi `requestedOrientation`, không nudge.
Vì `appWithHash:` là điểm ghi duy nhất [GOC], hai cổng này là đủ để khẳng định:
**trong lúc lease sống, không đường nào ghi được hướng ngang cho pane đó** — đây là
khẳng định cấu trúc, kiểm được bằng grep/diff ở cổng tĩnh §9, không cần đo xe.

### 6.3 Hysteresis — chuyển đổi không rung

- **Vào ảo hoá**: ngay ở lease hợp lệ đầu tiên — không cần lease thứ hai xác nhận.
  Cấp lease là hành động có chủ đích của host (đã qua transaction sửa §3.2.3), không
  phải tín hiệu nhiễu.
- **Ở trong**: heartbeat 1,0 s ≪ hạn 3,0 s ⇒ mất 1–2 nhịp heartbeat liên tiếp vẫn
  không rời. Generation chỉ tăng khi nội dung đổi nên nhịp layout dồn dập không tạo
  dao động trạng thái.
- **Ra**: chỉ bởi đúng ba nguyên nhân — thu hồi tường minh (active = NO), hết hạn
  3,0 s (tức host đã im lặng ≥ 3 nhịp heartbeat: host chết, pane chết, hoặc pref đã
  tắt mà gói thu hồi bị mất), đổi owner. Không có đường ra nào theo "nội dung tuyên
  bố của app" — app không thể tự làm lease rung bằng cách tuyên bố qua lại.
- **Trở về r6 nguyên vẹn**: khi rời ảo hoá, mọi hook trả-lời tự quay về IMP gốc ở
  lần gọi kế tiếp (kiểm tại thời điểm gọi §5.6); phía host, cổng `appWithHash:` mở
  ngay khi lease không còn sống và `requestedOrientation` đang = 0 (đã xoá lúc cấp)
  nên tuyên bố ngang đầu tiên sau đó đi trọn đường r6 như chưa từng có ảo hoá:
  publish (debounce 0,25 s) → suy 4 → nudge → layoutPane hoán trục. Không cần bước
  "gỡ cài đặt" nào — hooks vẫn nằm đó nhưng trong suốt. **[Cấu trúc: OMC; DO: mục 7
  của phiên đo §8.3 kiểm chứng bằng pref OFF giữa chừng.]**

## 7. An toàn

- **YouTube trên màn hình iPhone (không được host)**: không bị đụng — ở mức cấu
  trúc, không phải mức hành vi. Hook trong app chỉ cài bên trong `ABOrientationBlock`,
  mà block đó chỉ chạy khi host phát `appbridge.orientation` cho app đã được nhận
  vào ô [OMC ABInApp.m:655 + ABHostGeometry.m:39]; observer lease không tự nó cài
  hook nào. Chưa từng được host ⇒ process YouTube không có một hook YZ nào, lease
  cũng không bao giờ được cấp cho bundle không có pane. **[OMC]**
- **Trường hợp đồng thời** (cùng một process YouTube vừa được host lên xe, vừa đang
  mở trên màn iPhone — host đã biết trường hợp này tồn tại [OMC ABHostBMethods.m:
  teardown kiểm frontmost]): các bề mặt theo-scene (#3, relay) chỉ chạm scene được
  thuê; nhưng #1/#2/#4 là bề mặt cấp process — trong lúc lease sống, scene iPhone
  của cùng app cũng đọc được đáp án Portrait. Đây là **giới hạn chấp nhận có ghi
  rõ**, cùng hình dạng với DuoFace (hook của nó cũng cấp process, gác bằng lease
  [DF-SRC §2.2]); scene iPhone của một app đang bị host thực tế đang ở nền/không
  tương tác. **[SUY về tính vô hại — phiên đo không bắt buộc mục này; nếu Nguyen
  dùng song song thật và thấy vướng, đó là dữ kiện mở lại thiết kế, không phải lỗi
  cài đặt.]**
- **App hosted khác** (Maps, Waze, …): lease chỉ cấp cho đúng một bundle (§4.4) và
  máy YZ chỉ cài trong process YouTube (§5.1) — hai lớp độc lập cùng kết luận: app
  khác giữ nguyên r6, kể cả khi chúng tuyên bố mask 24 trong cùng phiên. Phiên đo
  §8.3 mục 5 kiểm chứng hồi quy này.
- **Bàn phím**: không đụng. Kênh `appbridge.keyboard`, máy ABKeyboard và inputView
  trắng của ABInApp nằm ngoài phạm vi; YZ không đọc, không ghi, không đổi thứ tự
  cài hook nào của chúng. Lưu ý giao nhau duy nhất: relay §5.4 loại cửa sổ bàn
  phím/text-effects khỏi tập đặt lại — là loại trừ, không phải can thiệp.
- **Lỗi lease**: gen cũ / issuedAt cũ / owner lạ / payload thiếu khoá → bỏ qua
  nguyên trạng + log (§4.6), không trạng thái nào đổi. Hết hạn giữa lúc đang xem
  fullscreen: đáp án hook trở về gốc ngay lần gọi kế tiếp (§5.6) — hệ quả tệ nhất
  là player tuyên bố lại và r6 đáp như hiện nay (tumble như bản hiện tại), **không
  tồn tại trạng thái kẹt portrait**, vì không hook nào latch đáp án của mình.

## 8. Staging

### 8.1 Công tắc

- Pref mới: **`youtubeVirtualize`** (BOOL, domain `com.anlai.omnicar`), **vắng =
  TẮT** — phiên đầu chỉ bật khi Nguyen chủ đích bật để đo. Đây là staging switch,
  không phải kill-switch chôn trong code: sau khi nghiệm thu, việc lật mặc định
  thành BẬT là một quyết định riêng của Nguyen/GPT, thiết kế không tự làm.
- **Chỉ ABHost đọc pref này** (qua `OMCPrefsSync()` + `OMCPref` — đúng mẫu đọc pref
  phía host [OMC ABHostBMethods.m:528]) tại: điểm cấp lease, sự kiện prefschanged,
  và mỗi lần nhận ack `request`. Phía app không đọc (§5.1).
- Prefs specifier: PSSwitchCell theo đúng mẫu switch test của FS1 (strand C đã
  chứng minh đường ống: specifier mang `PostNotification =
  com.anlai.omnicar/prefschanged`, phía nhận không cần khai báo thêm) — đặt ở trang
  FeatureSplitScreen nhóm TEST cạnh `fullscreenTestExpand`, key = `youtubeVirtualize`,
  default = false, nhãn ghi rõ là công tắc nghiệm thu YT-ZOOM. ABHost đăng ký nghe
  chính Darwin `com.anlai.omnicar/prefschanged` trong registrar để bật/tắt lease
  giữa phiên mà không cần cắm lại CarPlay.
- Tắt pref giữa phiên = thu hồi (§4.4) + cổng apporient mở lại: toàn bộ tính năng
  biến mất trong một nhịp thông báo, không cần respring.

### 8.2 Log markers (tiền tố `[ytz]`, qua OMCLogWrite như mọi marker vòng này)

Phía host (ABHost): `lease cap gen=<n> size=<WxH> split=<0|1>` · `lease gia han` (chỉ
log khi đổi nhịp, không log từng heartbeat) · `lease thu hoi ly do=pref|teardown|disconnect`
· `chan apporient: pane dang ao hoa (hash=<h>)` (throttle 1 dòng / 5 s / pane) ·
`sua residue: requestedOrientation <cu> -> 0` · `ack phase=<p> windows=<n> mismatch=<m>`.
Phía app (ABInApp): `lease nhan gen=<n> owner=<short> size=<WxH>` · `ao hoa BAT hooks=6
match=<id|single|key|none>` · `ao hoa TAT ly do=revoke|expiry|owner|close` ·
`relay ap: windows=<n> mismatch=<m>` · `tieu thu tuyen bo (lease song)` (throttle) ·
`doc lai 0.12s: da phat` · `lease hong: <ly do>`.

### 8.3 Kế hoạch ĐO — đúng một phiên gộp (mẫu số đọc bằng log + mắt, marker ở §8.2)

Điều kiện nền: bản FAT chứa YT-ZOOM, WAKE/PINCH giữ nguyên trạng thái vòng FS1,
AutoHide giữ nguyên; YouTube + một app hosted có xoay ngang thật (kiểm hồi quy) sẵn
sàng. Các mục theo thứ tự, verdict từng mục ghi riêng:

1. **Đối chứng TẮT**: pref OFF, host YouTube vào split, bấm fullscreen → hành vi r6
   hiện tại (log có `doi yeu cau xoay (ma 255, mask 24) -> scene huong 4`, mắt thấy
   tumble như bản hiện tại). Đây là mốc đối chứng của cả phiên — nếu mục này đã
   khác hiện tại thì bản dựng có hồi quy trước khi bật tính năng, dừng phiên.
2. **Bật giữa phiên**: bật pref (không cắm lại xe) → log host `lease cap ...`, log
   app `ao hoa BAT hooks=6 match=<...>`; nếu trước đó YouTube đã từng xoay ngang
   trong phiên, phải thấy `sua residue` và một transaction về portrait.
3. **Fullscreen khi đang host (mục quyết định)**: bấm fullscreen trong player →
   kỳ vọng mắt: video nở lấp ô, **không lộn vòng**, không khựng; kỳ vọng log quanh
   mốc bấm: **không** dòng `doi yeu cau xoay` cho YouTube, **không** dòng
   `bao SpringBoard: ma 255`, có thể có `tieu thu tuyen bo` + heartbeat lease cùng
   kích thước. Thoát fullscreen → đối xứng, vẫn không sự kiện hướng nào.
4. **Kéo divider giữa lúc đang fullscreen**: kéo và nhả → log: lease gen tăng với
   kích thước mới, ack `applied` với `mismatch=0`; mắt: video bám kích thước ô mới,
   không xoay, độ trễ cảm nhận ≈ nhịp commit frame + ≤ 0,3 s. Vào solo (nghi thức
   OmniCar) rồi bấm fullscreen lần nữa → cùng kỳ vọng, `isSplit` trong lease = 0.
5. **Hồi quy app khác**: đưa app hosted có xoay ngang vào ô, cho nó tuyên bố ngang
   → log phải có trọn đường r6 (`doi yeu cau xoay ... -> scene huong 4`) và hành vi
   như fixround7; không dòng `[ytz]` nào nhắc bundle đó.
6. **YouTube trên iPhone**: đóng YouTube khỏi xe (close), mở trên màn iPhone, dùng
   bình thường + bấm fullscreen trong player trên điện thoại → hành vi gốc của máy,
   không portrait bị ghim, không dòng `[ytz]` mới nào trong log app.
7. **Thu hồi giữa chừng**: host lại YouTube, vào fullscreen, rồi **tắt pref giữa
   lúc đang xem** → log `lease thu hoi ly do=pref` + `ao hoa TAT ly do=revoke` +
   snapshot được khôi phục; bấm thoát/rồi vào lại fullscreen → đường r6 trở lại
   (tumble như mục 1) — đây là bằng chứng fall-back sống, không phải lỗi. Bật lại
   pref → lease cấp lại, mục 3 lặp lại được. Thêm: để yên xem fullscreen liên tục
   ≥ 3 phút → không dòng `ao hoa TAT ly do=expiry` nào xuất hiện (heartbeat đủ).

## 9. Kế hoạch theo file (cho vòng cài đặt sau — tài liệu này không cài)

Mọi thay đổi ở cả hai cây `project/` + `src/`, mirror identical (cmp từng file).

**File mới:**
- `OmniCarAppBridge/ABYTZoom.m` (+ khai báo trong `AppBridgeB.h` hoặc header riêng
  `ABYTZoom.h`): phía host — trạng thái lease theo pane, issuer + heartbeat +
  pref reader + `yzLeaseActiveForBundle:` + `yzEffectiveOrientation:pane:` + đăng
  ký observer ack/prefschanged; phía app — trạng thái lease của process, observer
  lease, relay §5.4, watchdog §5.6, `YZActive()`/`YZResetAll()`. Một TU hai vai theo
  đúng cách module đã chứa cả hai vai trong cùng các file B.
- Chuỗi tên kênh: hằng tại `ABChannelNames.m` (host) + bản sao file-local trong
  phần app của ABYTZoom.m (tiền lệ BridgeWake; integration diff = 0).

**Điểm chạm cộng thêm vào file sẵn có (chỉ cộng/cành điều kiện, không viết lại thân):**
- `ABHostBMethods.m`: cổng đầu `appWithHash:` (§3.2.1); `layoutPane:` — đọc hướng
  qua `yzEffectiveOrientation:` tại :705 + gọi issuer ở cuối thân với 2 local đã
  commit; `nudgePane:` — đọc hướng qua helper tại :729; `teardownPane:` — gọi thu
  hồi lease ngay trước :1528.
- `ABHostGeometry.m`: registrar `ABSpringBoardReady` — đăng ký observer ack +
  prefschanged của YZ (2 điểm cộng); sinh `owner` UUID.
- `ABInApp.m`: khối one-shot của `ABOrientationBlock` — gọi cài YZ sau
  `BWInstallBridgeWake()` (:731, điều kiện bundle YouTube); cành lease-đứng-trước
  trong `ABHook_UIDeviceOrientation` và `ABHook_UIWindowSetRotatable`; cành câm
  publish trong 3 hook báo cáo (§6.1); `ABInstallInAppObservers` — observer lease
  (điều kiện bundle) + `YZResetAll()` cạnh `BWResetAll()` (:841).
- `OmniCarAppBridge/Makefile`: +1 TU. `OmniCarPrefs`: specifier §8.1 (strand riêng
  theo mẫu FS1-C).

**Cổng tĩnh đề xuất (đo trên candidate cuối, kỷ luật như wake1):**
1. Ba kênh cấm: diff của tính năng chứa 0 tham chiếu mới tới chuỗi
   `appbridge.apporient` / `appbridge.orientation` / `appbridge.keyboard` ngoài các
   điểm chạm đã liệt kê ở trên (vốn chỉ *đọc điều kiện*, không phát/đổi payload).
2. `appWithHash:`: diff chỉ gồm khối cổng ở đầu; phép suy + cực bit-2 không đổi một
   ký tự. `ABSceneSettingsApply`, `ABPublishAppOrientation`, `ABOrientationDerivedFromMask`:
   hash thân hàm khớp bản wake1.
3. `layoutPane:`/`nudgePane:`: ngoài 2 điểm đọc helper + 1 điểm gọi issuer, thân
   hàm không đổi; `setFrame:forApp:...` không đổi.
4. ABInApp: `orig_SendEvent` vẫn đúng 1 điểm gọi; hook sendEvent vẫn đúng 1; 4 hook
   mới chỉ tồn tại trong process YouTube (grep điều kiện bundle tại điểm cài);
   parity selector của module: chỉ thêm, không mất.
5. Hai bản chuỗi kênh YZ byte-identical; cả 2 kênh mới xuất hiện trong slice arm64
   và arm64e của đúng dylib AppBridge trên bản FAT.
6. `youtubeVirtualize` chỉ được đọc trong ABYTZoom.m phía host (grep toàn cây:
   0 điểm đọc trong code phía app).

## 10. Bằng chứng tổng hợp, kết luận khả thi, rủi ro và dự phòng

**Đã chứng:** nguyên lý ảo hoá + bộ 6 bề mặt + lease 3 s + kỷ luật revoke/khôi phục
của DuoFace [DF-SRC toàn bộ; DF-DEB đối chiếu binary gốc]; toàn bộ điểm nối phía
OmniCar — điểm ghi hướng duy nhất, 2 điểm tiêu thụ hướng hiệu lực, đường ghi settings
một transaction, điểm cài hook lười trong app, tiền lệ kênh NSDistributed theo bundle
[OMC, trích file:line ở §2–§6]; hành vi r6 hiện tại và cực bit-2 đã sửa [GOC].
**Suy luận:** bộ 6 đủ cho player YouTube trên ngăn xếp OmniCar; heartbeat 1,0 s đủ
giữ lease sống; phép suy `isSplit` phía host; định danh FBScene đọc được từ trong
app (có 2 tầng lui thay thế); hook scene-handle của DuoFace không cần phía OmniCar.
**Chờ đo xe:** kết quả thị giác mục 3 (không tumble) — mục đích tồn tại của track;
đủ/thiếu của bộ 6; tầng khớp scene nào thắng; bước đọc-lại 0,12 s có cần thật.

**Kết luận khả thi: LÀM ĐƯỢC**, với độ tin cậy phân tầng rõ rệt — tầng host + lease
là chắc chắn ở mức cấu trúc (mọi can thiệp nằm trên điểm ghi/điểm đọc duy nhất đã
chứng minh, kiểm tĩnh được hoàn toàn); tầng app là tin cậy cao theo tiền lệ cùng thế
hệ iOS nhưng chỉ chốt được bằng phiên đo §8.3. Thiết kế giữ mọi đường lui mở: tính
năng tắt bằng một pref, mọi hook trong suốt khi không có lease, và không một dòng
nào của đường r6 bị viết lại.

**Rủi ro lớn nhất:** player YouTube trên iOS 16.7.16 đọc hướng từ một bề mặt nằm
ngoài bộ 6 — ví dụ chỉ tin đáp án geometry của scene (khi đó settings đã ghim
portrait phía host có thể vẫn cứu được phần lớn), hoặc một bề mặt riêng như
status-bar orientation — khiến video không lộn nữa nhưng tỉ lệ/khung vẫn sai, hoặc
player từ chối vào fullscreen "ngang" theo cách của nó. Rủi ro này không nhìn thấy
được bằng đọc tĩnh (binary đóng) và là lý do phiên đo đặt mục 3 làm mục quyết định
với mốc đối chứng mục 1 đi trước.

**Phương án dự phòng theo bậc** (chỉ leo khi bậc trước có dữ kiện đo):
(a) Bổ sung bề mặt còn thiếu theo đúng điểm đo chỉ ra — ứng viên đã định danh:
    `UIApplication statusBarOrientation` (điểm DuoFace gốc có, QA180 bỏ — chỉ thêm
    lại khi log/mắt cho thấy player đọc nó), hoặc cổng class-method
    `attemptRotationToDeviceOrientation` (đã có hook báo cáo — chuyển thành điểm
    tiêu thụ khi lease sống).
(b) Chế độ host-đơn-độc: giữ cổng `appWithHash:` + ghim settings, bỏ tầng app —
    tuyên bố bị tiêu thụ, scene ở portrait, video chạy trong bố cục portrait của
    player bên trong ô. Hết tumble nhưng không phải "fullscreen nở lấp" — chỉ nhận
    nếu đo cho thấy nó tốt hơn hiện trạng một cách rõ ràng.
(c) Đóng track bằng bằng chứng: nếu cả (a)/(b) đều không đạt và phép đối chứng bản
    gốc (VISUAL_ORIGINAL_COMPARISON vốn đang PENDING) cho thấy bản gốc 1.0.3 cũng
    lộn vòng như vậy, thì tumble là hành vi của chính bản gốc — ghi kết luận đó và
    dừng, không đắp thêm cơ chế.
