# Điều tra — cơ chế zoom/fullscreen YouTube trong DuoFace: vì sao MƯỢT, đối chiếu OmniCar

Chỉ-đọc. Track riêng do Nguyen mở 2026-11-09.
Nguồn đọc trực tiếp: cây source DuoFace QA180 `~/workspace/duoface-qa180/src/`
(`DFSceneHost.m`, `DFSceneOrientationPolicy.m`, `DFYouTubeOrientationRelay.m`,
`DFYouTubeOrientationVirtualization.m`, `DFYouTubeHostState.h`, `DFHostedMapRenderSize.h`,
`DFAppViewportRelay.m`); hồ sơ deb gốc `~/workspace/deb-ho-so/duoface-goc-1.0.4-1/HO_SO.md`
(bảng hook của binary gốc); bản đồ OmniCar: `work/fix-round6/invest-ytzoom.md`.

Mức bằng chứng ghi theo từng khẳng định: **[SRC]** = đọc trực tiếp source QA180;
**[DEB]** = census hook của binary DuoFace gốc trong hồ sơ deb; **[SUY]** = suy luận về nội bộ
app đóng (YouTube) từ bề mặt cơ chế — không khẳng định quá dữ kiện này.

---

## 0) KẾT LUẬN — DuoFace thuộc trường hợp (d): XOAY BỊ ẢO HOÁ ĐI, KHÔNG AI XOAY CẢ

DuoFace không đáp lại cú bấm fullscreen bằng một hành động hình học nào. Thay vào đó, cả hệ
thống được dựng để **hướng ngang không bao giờ tồn tại** đối với YouTube bị host:

- Mọi truy vấn hướng của app đều bị trả lời **Portrait (1)**: mask hỗ trợ của view controller,
  `interfaceOrientation` của window scene, `orientation` của device — và mọi lệnh xoay cửa sổ
  đều bị viết lại thành Portrait trước khi chạm UIKit thật. **[SRC]**
- Phía SpringBoard, scene handle của app bị host chỉ "hỗ trợ" orientation 1, và kích thước
  tham chiếu của scene do host áp đặt. Settings của FBScene: frame = kích thước logic của ô,
  `interfaceOrientation` bị giữ ở 1 (nếu đo thấy 2..4 thì sửa về 1 trong cùng transaction). **[SRC]**
- Kích thước cửa sổ của app do host cấp qua một "lease" (hợp đồng trạng thái) và relay trong
  process app **tự tay đặt lại frame/bounds của cửa sổ** về đúng kích thước đó. **[SRC]**

Hệ quả: khi người dùng bấm fullscreen trong player, YouTube không thể xoay — tuyên bố ngang
của nó bị chặn ngay trong process của chính nó. Player chuyển fullscreen **bên trong cửa sổ
hiện có** (vốn có hình dạng của ô trên màn xe), nên thứ mắt thấy là video nở ra lấp ô, không
có giao dịch xoay nào ở bất kỳ tầng nào để mà "lộn". **[SUY về nội bộ player; cơ chế chặn là SRC]**

Phân loại theo 4 trường hợp của đề bài:

- (a) Host cho scene thay đổi hình học thật khi fullscreen — **KHÔNG** theo nghĩa đáp-tap:
  host có ghi frame cho FBScene, nhưng là frame của ô (kích thước logic cố định theo ô) trong
  các commit hình học định kỳ/do layout của chính DuoFace, không phải phản ứng với cú bấm
  fullscreen, và không kèm rotate.
- (b) Host áp transform lên bề mặt hosted — **CÓ nhưng là hạ tầng đứng yên, không phải đáp án
  fullscreen**: view của app được đặt ở kích thước logic = ô × 2 rồi surface scale 0,5 bằng
  `CGAffineTransform` để trình bày (mọi app bị host, mọi lúc). **[SRC]**
- (c) Host đáp tuyên bố fullscreen bằng phình ô/solo tạm — **LOẠI**: trong giao thức
  host↔app không tồn tại sự kiện "fullscreen" nào (xem §2); DuoFace có fullscreen riêng của
  nó (Dock zoom, thao tác trên chrome của DuoFace — `DFDockZoomCoordinator`), đó là cử chỉ
  của người dùng trên UI DuoFace, không phải phản ứng với player của app.
- (d) Cơ chế khác — **ĐÚNG**: ảo hoá hướng (orientation virtualization) + ghim portrait +
  cấp kích thước cửa sổ theo lease. Đây cũng là kiến trúc của DuoFace gốc thương mại:
  bảng hook trong hồ sơ deb gốc chứa đúng các điểm hook này (mục §5). **[DEB]**

---

## 1) Truy vết một chu kỳ fullscreen YouTube trong DuoFace (ô split)

### 1.1 Trạng thái nền trước khi bấm (điều kiện để chu kỳ "không có gì xảy ra")

Ngay khi scene được host và đủ điều kiện sở hữu (đúng scene, đúng owner, đang hiện),
`DFSceneSurface` (view bề mặt trong SpringBoard, `DFSceneHost.m`) làm ba việc đứng yên:

1. **Đăng ký chính sách hướng** (`registerOwnedOrientationForDeviceController:`): cài
   `DFSceneOrientationPolicy` — hook trên `SBDeviceApplicationSceneHandle
   -_mainSceneSupportsInterfaceOrientation:` trả lời YES **chỉ cho orientation 1** đối với
   scene handle đã đăng ký; hook trên `SBDeviceApplicationSceneViewController
   -setContentReferenceSize:withInterfaceOrientation:` (và bản 3 đối số) **thay kích thước
   đề xuất bằng kích thước logic của host** (tham số hướng giữ nguyên của Apple). **[SRC]**
2. **Commit hình học scene** (`commitSceneGeometry:`, debounce trailing-edge 0,09 s):
   gọi các setter kích thước tham chiếu với (logical, Portrait[, Portrait]), rồi
   `-[FBScene updateSettingsWithBlock:]`: setFrame: = {0, 0, logicalW, logicalH} (chỉ khi
   khác hiện tại); riêng YouTube: nếu orientation hiện tại của settings ∈ 2..4 thì
   setInterfaceOrientation: = 1 trong cùng block ("portrait repair"). Không bao giờ ghi
   hướng ngang. `logical = ô × 2,0` cho mọi app bị host (`DFHostedLogicalSizeForBundle`). **[SRC]**
3. **Phát lease cho app** (`publishYouTubeState`, throttle 0,30 s): NSDistributedNotification
   `com.duoface.youtube.host-state.v1`, payload {version 2, bundleIdentifier, owner (UUID),
   sceneIdentifier, generation, issuedAt, active, width, height, **orientation = 1**,
   isSplit}. width/height = kích thước logic của ô **đã commit** (đang kéo divider thì chỉ
   gia hạn kích thước cũ, không phát hình học chưa commit). **[SRC]**

Phía app (dylib nạp riêng vào process YouTube; chỉ iOS 16, chỉ đúng bundle
`com.google.ios.youtube`): `DFYouTubeOrientationRelay` nhận lease (kiểm owner/sceneID/tuổi
≤ 3 s), `DFYouTubeOrientationVirtualization` cài 6 hook MSHookMessageEx (xem bảng §3) và
relay chạy `apply` (mục 1.3). App từ thời điểm này sống trong một "cửa sổ portrait" có kích
thước do host cấp, dù cửa sổ đó có hình dạng ngang hay dọc. **[SRC]**

### 1.2 Cú bấm fullscreen — theo từng tầng

1. **Trong app**: player đổi ý định sang ngang theo máy UIKit chuẩn (cùng đường VC như phía
   OmniCar: VC đổi supported mask / setNeedsUpdate). Nhưng mọi bề mặt nó chạm vào đều đã bị
   thay đáp án: `supportedInterfaceOrientations` và `__supportedInterfaceOrientations` của
   mọi VC trả **Portrait mask** chừng nào lease còn sống; `UIWindowScene.interfaceOrientation`
   của scene được thuê trả **Portrait**; `UIDevice.orientation` trả **Portrait**;
   `-[UIWindow _rotateWindowToOrientation:...]` bị thay đối số thành Portrait rồi mới gọi
   IMP gốc; `-[UIWindow _setRotatableViewOrientation:duration:force:]` bị thay thành
   Portrait + force=YES. Tuyên bố mask 24 vì thế **không bao giờ rời khỏi process app** —
   không kênh nào mang nó lên host (khác hẳn OmniCar, nơi hook VC là điểm *phát* yêu cầu). **[SRC]**
2. **Phía host khi bấm**: **không có gì được gửi và không có gì thay đổi.** Giao thức
   host↔app chỉ có 3 kênh: state (host→app, lease), request (app→host, app xin cấp lease —
   chỉ bắn khi app trở nên active), ack (app→host, đo đạc/nhịp tim). Không kênh nào mang sự
   kiện fullscreen; host tiếp tục gia hạn lease cùng kích thước theo nhịp poll 0,35 s. **[SRC]**
3. **Thứ mắt thấy**: player thực hiện chuyển fullscreen trong cửa sổ hiện hữu — cửa sổ có
   đúng hình dạng ô (ở split màn xe, ô là vùng ngang), video nở lấp cửa sổ. Không transaction
   xoay ở scene, không hoán trục kích thước logic, không hoạt ảnh tự-xoay-trong-hộp-tĩnh kiểu
   OmniCar. Đây là phần **[SUY]** về nội bộ YouTube (binary đóng), nhưng là hệ quả trực tiếp
   duy nhất khớp với bề mặt đã chặn ở bước 1 và với kết quả mượt Nguyen báo.
4. **Thoát fullscreen**: đối xứng — vẫn không sự kiện nào rời app; lease không đổi.

### 1.3 Khi nào hình học THẬT SỰ đổi: DuoFace đổi kích thước ô (không phải player xin)

Divider bị kéo / solo / restore do người dùng thao tác trên chrome DuoFace:

1. `layoutSubviews` → `layoutScene`: tầng UI cập nhật **ngay** (view app đặt ở kích thước
   logic mới, transform scale về ô hiện tại); commit FBScene bị debounce 0,09 s. **[SRC]**
2. Commit xong → `publishYouTubeState` với width/height mới và isSplit mới
   (`setSplitMode:forHostedView:` phát lại lease ngay cả khi chỉ đổi split/solo). **[SRC]**
3. Relay phía app thấy width/height/isSplit đổi → `apply`: cập nhật lease ảo hoá; với từng
   cửa sổ thuộc scene (level normal, có root VC, không phải keyboard/text-effects, kể cả cửa
   sổ nội bộ qua `+allWindowsIncludingInternalWindows:`): chụp snapshot {frame, bounds,
   orientation} lần đầu, gọi API riêng `_rotateWindowToOrientation:Portrait
   updateStatusBar:NO duration:0 skipCallbacks:YES`, đặt `frame = bounds = {0,0,lease}`,
   layoutIfNeeded. Nếu sau đó root VC vẫn báo orientation ≠ 1 và đang split: sau 0,12 s phát
   một lần `setNeedsUpdateOfSupportedInterfaceOrientations` +
   `requestGeometryUpdateWithPreferences:`(mask Portrait) như một cú đọc-lại/đánh giá-lại —
   đây là lần duy nhất phía DuoFace *chủ động* gọi API geometry của iOS 16, và nó xin
   **Portrait**, ngược chiều với đường geometry của OmniCar. **[SRC]**
4. Relay trả ack `app-reflow-measured` (số cửa sổ đã áp, kích thước đo lại, số mismatch…)
   để host ghi log đối chiếu. Khi host thu hồi lease (active=NO) hoặc đổi owner, relay khôi
   phục đúng snapshot cửa sổ đã chụp; riêng trường hợp lease *hết hạn lặng* thì QA175 chủ
   đích **không** khôi phục (tránh giật ngược chống lại hình học host đã chốt). **[SRC]**

Ngân sách trễ của một lần đổi kích thước ô: debounce commit 0,09 s + throttle phát lease
0,30 s + apply trong app gần như tức thời (xoay 0 s, skip callbacks). Không có thành phần
nào tương đương "hoạt ảnh tự xếp lại 0,5–1 s" của OmniCar vì không có xoay để xếp lại.

---

## 2) Bản đồ thành phần và giao thức

### 2.1 Phía SpringBoard (host) — `DFSceneHost.m` + `DFSceneOrientationPolicy.m`

| Thành phần | Vai trò trong cơ chế |
|---|---|
| `DFSceneSurface` (UIView bề mặt ô) | Chủ sở hữu vòng đời scene bị host; giữ `committedReferenceSize`, `splitUIVisible`, owner UUID |
| `commitSceneGeometry:` | Ghi kích thước tham chiếu (logical, Portrait) qua setter của scene VC; `updateSettingsWithBlock:`: frame = logical, sửa orientation về 1 cho YouTube khi lệch 2..4 |
| `publishYouTubeState` | Phát lease (mục 1.1.3); chỉ phát kích thước đã commit; throttle 0,30 s; revoke khi mất sở hữu/ẩn |
| `DFSceneOrientationPolicy` | Hook `_mainSceneSupportsInterfaceOrientation:` → chỉ 1; hook 2 setter `setContentReferenceSize:` → thay kích thước bằng provider của host. Chỉ cài khi có scene đủ điều kiện, fail-closed nếu ABI lạ |
| `layoutScene` | Trình bày tức thời: view app ở kích thước logical, surface scale 0,5 (logical = ô × 2, `DFHostedViewportScaleForBundle` = 0,50 cho mọi bundle) |
| `setSplitMode:forHostedView:` | Nguồn sự thật split/solo cho trường isSplit của lease — do chrome DuoFace gọi, không suy từ kích thước ô |

### 2.2 Phía app YouTube — `DFYouTubeOrientationRelay.m` + `DFYouTubeOrientationVirtualization.m`

6 hook ảo hoá (chỉ hoạt động khi lease hợp lệ: đúng bundle, đúng sceneIdentifier, tuổi ≤ 3 s,
orientation lease = 1, thread chính; ngoài lease thì gọi IMP gốc nguyên vẹn): **[SRC]**

| Hook (class / selector) | Đáp án khi lease sống |
|---|---|
| `UIViewController supportedInterfaceOrientations` | Portrait mask |
| `UIViewController __supportedInterfaceOrientations` | Portrait mask |
| `UIWindowScene interfaceOrientation` (đúng scene được thuê) | Portrait |
| `UIDevice orientation` | Portrait (device) |
| `UIWindow _rotateWindowToOrientation:updateStatusBar:duration:skipCallbacks:` | Thay orientation → Portrait, giữ nguyên các đối số còn lại, gọi gốc |
| `UIWindow _setRotatableViewOrientation:duration:force:` | Thay orientation → Portrait, force = YES, gọi gốc |

Relay: nhận lease qua NSDistributedNotificationCenter; `apply` đặt lại cửa sổ theo lease
(xoay-về-portrait 0 s skipCallbacks + gán frame/bounds + layout), chụp/khôi phục snapshot,
ack đo đạc về host; timer 0,5 s canh hết hạn lease. Không hook sendEvent cho mục đích hướng,
không spoof vòng đời, không xoay device toàn cục (ghi rõ trong source). Ngoài ra còn một cơ
chế tổng quát riêng cho app đủ điều kiện khác: `DFAppViewportRelay` — host phát kích thước
viewport qua Darwin notify đóng gói số, app tự đặt lại frame cửa sổ khi scene màn-hình-ngoài
của nó khớp kích thước host; **không** đụng orientation — không phải cơ chế YouTube ở đây.

### 2.3 Giao thức host↔app (YouTube)

| Kênh (NSDistributedNotificationCenter) | Chiều | Nội dung |
|---|---|---|
| `com.duoface.youtube.host-state.v1` | host → app | Lease v2: owner, sceneIdentifier, generation, issuedAt, active, orientation=1, width, height, isSplit |
| `com.duoface.youtube.host-request.v1` | app → host | {bundleIdentifier} — xin cấp/gia hạn lease (khi app active) |
| `com.duoface.youtube.host-ack.v1` | app → host | Đo đạc: phase (app-reflow-measured, geometry-request-issued/rejected, scene-id-unmatched…), số cửa sổ, mismatch, nhịp frame-clock |

Chống phát lại: state phải mới hơn stamp mới nhất đã nhận, hạn dùng 3 s, đổi owner/scene thì
reset; host chỉ revoke được lease của chính owner đó.

---

## 3) Bảng delta từng mắt xích: OmniCar ↔ DuoFace

| Mắt xích | OmniCar (theo invest-ytzoom) | DuoFace |
|---|---|---|
| App tuyên bố mask 24 | Hook VC phía app **đóng gói và phát lên host** (sentinel 0xFF qua Darwin `appbridge.apporient`, debounce 0,25 s) | Tuyên bố bị **chặn trong app**: supported mask bị trả về Portrait, mask 24 không bao giờ rời process |
| Ai quyết định hướng | Host suy từ mask → giá trị hướng (24 → 4) và ghi `requestedOrientation` | Không ai suy hướng ngang: chính sách scene chỉ nhận 1; lease luôn mang orientation = 1 |
| Settings scene | Một transaction: frame **giữ nguyên**, kích thước logic **hoán trục**, interfaceOrientation = 4 | Transaction: frame = kích thước logic của ô (**không hoán trục**), interfaceOrientation giữ/sửa = 1 |
| Khung ô khi fullscreen | Đứng yên theo thiết kế (hướng đi kênh riêng, khung đi kênh frame riêng) | Đứng yên — nhưng vì *không có gì cần đổi*: cửa sổ app đã có đúng kích thước ô từ trước |
| Phía app áp dụng | Host áp hướng xuống app chỉ ở launch-complete/teardown (`appbridge.orientation`, đúng 2 caller); app tự xếp lại giao diện trong hộp tĩnh → **tumble** | Relay duy trì liên tục: cửa sổ bị đặt lại theo lease mỗi khi lease đổi; lệnh xoay nào cũng bị viết lại thành Portrait |
| Đường geometry iOS 16 (`requestGeometryUpdateWithPreferences:`) | App không dùng trong các phiên đã thu; nếu dùng, app xin và bridge suy đáp án từ mask của app | App-side relay **chủ động gọi xin Portrait** khi đọc lại thấy VC vẫn lệch (chỉ split, trễ 0,12 s) |
| Kênh host↔app | Darwin notify, state đóng gói số (field/mask/hash), NSDistributed cho hướng ép | NSDistributed dictionary có owner/scene/generation/hạn 3 s (source ghi rõ: không đóng gói số Darwin, không đọc file ngoài sandbox) |
| Phạm vi | Một cơ chế hướng chung cho **mọi** app bị host | Chính sách scene (portrait + kích thước) cho app đủ điều kiện; ảo hoá đầy đủ **chỉ YouTube** (lease + relay riêng theo bundle) |
| Trễ một chu kỳ fullscreen | 0,25 s debounce + 0,05 s nudge + 0,5–1 s app tự hoạt ảnh | Không có chu kỳ thương lượng; đổi kích thước ô: 0,09 s debounce + 0,30 s throttle phát lease |
| Kết quả thị giác | Hình lộn vòng trong ô (video fixround6) | Video nở lấp ô, không xoay (theo báo cáo của Nguyen; cơ chế ở trên giải thích được) |

---

## 4) Đối chiếu với DuoFace gốc (hồ sơ deb) — kiến trúc này không phải QA180 tự chế

Bảng census hook của binary DuoFace gốc trong `HO_SO.md` (phần điều tra "Native12") chứa
đúng các điểm can thiệp mà source QA180 cài lại theo kiểu first-party: **[DEB]**

- Phía app: `UIViewController supportedInterfaceOrientations` IMP 0x2acc04;
  `__supportedInterfaceOrientations` 0x2acc60; `UIWindow _setRotatableViewOrientation:
  duration:force:` 0x2acef4; `UIWindow _rotateWindowToOrientation:updateStatusBar:duration:
  skipCallbacks:` 0x2acfd8; `UIWindowScene interfaceOrientation` 0x2ad7f0;
  `UIDevice orientation` 0x2ad8d0; thêm `UIApplication statusBarOrientation` và các hook
  `UIDevice setOrientation:` mà bản QA180 **không** cài lại (QA180 ghi rõ không xoay device
  toàn cục — khác biệt có chủ đích, không phải thiếu sót của phép đọc).
- Phía SpringBoard: `SBDeviceApplicationSceneViewController setContentReferenceSize:
  withInterfaceOrientation:` 0x2c895c và bản 3 đối số 0x2c8a50;
  `SBDeviceApplicationSceneHandle _mainSceneSupportsInterfaceOrientation:` 0x2c8b4c —
  khớp một-một với ba hook của `DFSceneOrientationPolicy`.
- Chính source QA180 cũng ghi chú đối chiếu này (comment dẫn offset gốc 0x2acc04/0x2acc60/
  0x2ad7f0/0x2ad8d0/0x2acfd8/0x2acef4 và audit `sideplay/audit/native12-083-rotation-…`),
  và ghi một bằng chứng log thật của bản .88: root controller vẫn báo orientation = 3 sau
  một lần gọi API xoay riêng thành công trong scene portrait = 1 — chính là lý do tồn tại
  bước đọc-lại geometry ở mục 1.3.3. **[SRC — lời ghi trong source về log thiết bị cũ]**

## 5) Mức bằng chứng và phần CHƯA có dữ kiện — phép đo sẽ chốt

Đã chứng minh ở mức source/hồ sơ: toàn bộ cơ chế chặn hướng + lease + áp cửa sổ (§1–§3).
Chưa có dữ kiện tĩnh, không đoán — các phép đo trên xe DuoFace sau sẽ chốt:

1. **Cú bấm fullscreen có thật là "không sự kiện" ở tầng bridge không**: host YouTube trong
   DuoFace (QA180), mở log `/var/mobile/Library/Logs/DuoFaceSceneHost.log`, bấm fullscreen
   rồi thoát. Kỳ vọng theo cơ chế: **không** dòng `resize`, **không** ack
   `app-reflow-measured` mới quanh mốc bấm (chỉ heartbeat gia hạn lease cùng kích thước);
   ack định kỳ cho `virtualization.leaseActive = 1`, `hooks = 6`. Nếu ngược lại có reflow
   tại mốc bấm, kết luận §0 phải sửa.
2. **Player nở lấp cửa sổ hay xin một bề mặt riêng**: cùng phiên đo 1, kèm quay màn hình xe:
   đối chiếu thời điểm video nở với (không) thay đổi width/height trong lease gần nhất —
   nếu video nở mà lease đứng yên, khẳng định [SUY] ở §0/§1.2 được nâng thành đã đo.
3. **Hình dạng ô có quyết định cảm giác "fullscreen đúng" không**: đo ở split (ô hẹp) và
   solo (ô rộng): cơ chế không đổi, nhưng video lấp ô hẹp sẽ khác ô rộng — đây là giới hạn
   cảm nhận, không phải lỗi cơ chế; ghi nhận để thiết kế bản OmniCar không hứa quá.
4. **Độ trễ khi DuoFace tự đổi kích thước ô lúc video đang fullscreen**: kéo divider giữa
   lúc đang xem fullscreen, đo khoảng từ nhả kéo tới ack `app-reflow-measured`
   (kỳ vọng ≈ 0,09 s debounce + ≤ 0,30 s throttle + apply) và mắt xem có giật khung không.

Hệ quả cho track thiết kế bản tương đương trên OmniCar (ngoài phạm vi điều tra này, chỉ
ghi điểm nối): mắt xích quyết định nằm **phía app** (chặn tuyên bố + duy trì lease cửa sổ),
không nằm ở phép suy hướng phía host; ABInApp của OmniCar đã có sẵn điểm cài hook VC và
kênh hai chiều — nhưng hợp đồng lease, chính sách portrait phía scene của SpringBoard và
relay đặt-lại-cửa-sổ đều là thành phần mới phải thiết kế, và nó xung đột trực tiếp với
triết lý hiện tại của kênh `appbridge.apporient` (phát tuyên bố lên host để host suy) —
hai cơ chế không thể cùng quyết định hướng cho cùng một app.
