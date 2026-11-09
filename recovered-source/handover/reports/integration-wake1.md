# TÍCH HỢP WAKE1 — keo pinch + đối chiếu giao thức + candidate + Gate 1

Ngày: 2026-11-09. Nguồn việc: impl-carplay.md / impl-abhost.md /
impl-abapp.md / impl-pinch.md (mục điểm keo + lệch), design-bridgewake
§7, design-pinch §7. Trạng thái: **source tích hợp xong, candidate
arm64 đóng xong, Gate 1 trên candidate ĐẠT toàn bộ mục kiểm**. Chưa
CI FAT, chưa đẩy git, chưa lên xe (Gate 2).

## Candidate

- Path: `project/packages/com.anlai.omnicar_1.0.3-wake1_iphoneos-arm64.deb`
- Size: **994.274 B**; SHA-256:
  `12d41e98160bbbb2371bb755562c0085b18c9700a78e2c12b012de86c826e38f`
- Đóng bằng Theos `make package FINALPACKAGE=1` tại gốc project sau
  `make clean; make` toàn bộ subproject (toolchain kiểm trước: clang-18,
  ldid, ld.lld→ld.lld-18, Theos — đủ, không khôi phục). control:
  Package com.anlai.omnicar, Version **1.0.3** (giữ nguyên), Arch
  iphoneos-arm64. Tên file mang hậu tố `-wake1` theo quy ước vòng.
- Ghi nhận định dạng: `file(1)` báo `data compression lzma`
  (debian-binary + control.tar.gz + data.tar.lzma) — đây là format
  dm.pl của chính pipeline này, **identical với mọi candidate local
  fixround3–7 và với member format của bản FAT đã qua máy**; không
  phải zst (bẫy dpkg-deb mặc định không dính vì đóng bằng dm.pl).
- arm64-only như mọi candidate local (VM hạ arm64e→arm64); bản FAT
  chờ CI ở bước sau.

## 1. Keo pinch (điểm keo của impl-pinch §5 + lệch L1)

Mọi file sửa đều mirror project ↔ src (cmp identical sau sửa).

- **Makefile** (project/OmniCarSplitScreen/Makefile, cây src không có
  Makefile): FILES thêm `SCPPinchController.m SCPFullscreenAdapter.m`
  ngay sau `SCPCarSplit+BridgeWake.m`.
- **SCPHooks.m**: +1 import (SCPPinchController.h); trong
  `Hook_RootVC_viewDidLayoutSubviews`, sau seam `rootDidLayout` sẵn
  có (~:321): 1 lời gọi `[[SCPPinchController shared] syncArming]`
  trong @try riêng (design-pinch §7).
- **SCPCarSplit.m** (đúng 2 dòng keo cho phép): +1 import; cuối
  `ensureContainer` (chỉ nhánh dựng container MỚI — điểm duy nhất
  container tươi tồn tại xác định được, seam layout ở SCPHooks không
  bảo đảm thời điểm này) → `attachIfNeeded`; trong
  `dashboardInvalidated`, ngay sau `bwSessionTeardown` → `detach`.
- **Arbiter (lệch L1)**: `SCPCarSplit+BridgeWake.h` — category
  `(BridgeWake)` khai conformance `<SCPPinchArbiter>` + 3 method.
  `SCPCarSplit+BridgeWake.m`:
  - `pinchMode` ← static `bwPinchMode` của owner (pref
    bridgewake.pinchMode, §4; ngoài 0–2 → OFF).
  - `hostIsExpanded` ← `bwExpandedFlag` (đầu vào §2.1; vòng này luôn
    NO vì A1 BLOCKED).
  - `pinchDispositionForPane:touchesSuppressed:` ← ánh xạ thuần từ
    trạng thái bw đã lưu theo slot: EXPANDED của bundle →
    Allowed; HIDDEN → BlockedHidden; VISIBLE → BlockedUnknown nếu
    popup/resizing, ngược lại Allowed; INACTIVE/UNKNOWN/WAKING →
    BlockedUnknown. Allowlist KHÔNG được hỏi ở đây (cổng 5 là của
    controller, theo (bundle, scene); allowlist pref của owner chỉ
    nuôi cờ pinchAllowed trong gói state cho probe phía app — hai bề
    mặt khác nhau, giữ nguyên như thiết kế).
  - Gán arbiter tại cuối `bwInstallOwner`:
    `[SCPPinchController shared].arbiter = self`.
  - **externalChainSuppressed / touchesSuppressed — quyết định tích
    hợp (ghi theo lệnh cấm bịa kênh):** KHÔNG tồn tại tín hiệu
    liên-process "chuỗi đang bị nuốt" nào nhìn thấy được từ
    CarPlayApp. Sự thật tương đương phía owner: một giao dịch wake
    đang mở trên slot (`bwWakePendingBySlot`) — khi đó state của
    pane chính là WAKING và chuỗi phía app đang bị suppression giữ.
    Vì vậy: (a) helper tĩnh `BWPublishChainSuppressed()` duy trì
    `controller.externalChainSuppressed = (có bất kỳ slot nào đang
    WAKING)`, gọi tại đúng 5 điểm mở/đóng giao dịch: mở WAKING trong
    bwHandleWakePacket, đóng bởi ack trong bwHandleAckPacket, đóng
    bởi hạn 1,0 s, bwSessionTeardown, và bwInstallOwner (giá trị đầu
    NO); (b) trong `pinchDispositionForPane:`, tham số
    touchesSuppressed (cờ do controller tự duy trì cho cổng 4 của
    chính nó) không cần đáp án riêng từ owner — trạng thái WAKING đã
    lưu ánh xạ sẵn sang BlockedUnknown, phủ đúng cùng sự thật.
- Allowlist của controller: giữ RỖNG (impl-pinch §5.5) — không app
  nào qua được cổng 5 ở vòng này, đúng mặc định-tắt của GPT A4.

## 2. Đối chiếu giao thức

- **BridgeWakePack.h**: hai bản module LỆCH thật, không chỉ văn bản —
  API khác nhau (SplitScreen: `BWPackFields` + `BWUnpack` trả struct
  + helper hash/normalise; AppBridge: `BWPack` + `BWUnpack(raw,&out)`).
  Chuẩn hoá: lấy **bản SplitScreen làm chuẩn** (bản đầy đủ hơn, đã qua
  vector 19/19 của strand CarPlay) chép identical vào cả 4 vị trí
  (project×2 + src×2, md5 `055f1005465c9f5dfbfdb84f7a0cb57b`). Phía
  AppBridge chỉ phải adapt ABInApp.m: `BWPack(` → `BWPackFields(`
  (2 điểm, thứ tự đối số giữ nguyên), `BWUnpack(raw,&p)` → struct
  (2 điểm, điều kiện loại gói: `!p.valid || p.type == BWTypeInvalid`),
  `p.hash` → `p.hash28` (2 điểm). ABChannels.m không import header
  (pack file-local) nên không đụng.
- **Harness vector trên header cuối** (/tmp/bw-harness-final/test.c,
  biên dịch bằng clang-18 với include path của TỪNG module):
  **38/38 PASS ở cả hai** — hash tham chiếu yt/vm, pack V1–V7 khớp
  hex §3.4, unpack 7 hex literal ra đúng trường, V8 (ô 0 → valid=0),
  luật chuẩn hoá mode 3→OFF / state 5–7→UNKNOWN, và **hằng V6 phía
  ABHost**: công thức pack file-local trong ABChannels.m (6 đối số,
  modes=0 theo kỷ luật trường §3.2) cho ra đúng
  `0xE9DA706814803C14` và bit-identical với header chuẩn trên toàn bộ
  miền state×flag kiểm thử.
- **Chuỗi 4 kênh** `com.anlai.omnicar/bridgewake.v1.{state,query,
  wake,ack}`: byte-equal ở cả 3 nơi định nghĩa (SCPShared.m:33–36,
  ABChannelNames.m:47–50, statics trong ABInApp.m:104–107) — kiểm
  bằng grep đối chiếu từng chuỗi. Hàm băm khớp nhau: ABBundleHash /
  ABBundleIDHash / BWBundleHashCString đều là FNV-1a (offset
  0x811C9DC5, prime 0x01000193) — hash28 hai đầu tương thích.

## 3. Gate 1 trên candidate (bung DEB ra kiểm, không kiểm object rời)

Baseline đối chiếu: fixround7 FAT `f2cc8ffe…` (lát arm64 trích bằng
llvm-lipo cho các cổng cần lát mỏng).

| Cổng | Kết quả | Bằng chứng |
|---|---|---|
| Selector parity vs r7 (8 thành phần) | **PASS — mất 0** | __objc_methname: AppBridge 705→716, SplitScreen 1093→1317, còn lại chỉ +selref Foundation. Thêm vào đúng bề mặt wake/pinch + `bwAppliedSnapshotForBundle:` + `sendEvent:` (tham chiếu hook) |
| Danh sách file / dylib lạ | **PASS** | File list candidate ≡ baseline; đúng 6 dylib chuẩn; 0 file QA19/QA20/DoubleTap/YouTubeHandle/NativeSolo |
| g1 — host appWithHash csel | **PASS** | Candidate AppBridge @0x7878 `and x8,x24,#0x2` → @0x789c `cmp x8,#0` → @0x78a0 `csel x8, xzr, x9, ne`; ưu tiên 4>3>(mask>>1)&2; changed @0x78ac `cmp #0xff` → @0x78b0 csel eq (derived/trực tiếp) |
| g2 — app derivation csel | **PASS** | @0x15f58 `tst x0,#0x2` → @0x15f5c `csel x9, x8, xzr, eq` (bit có mặt → 0); ngay trước log "app xin huong" |
| h — host-bar C-A | **PASS** | setBarVisible @0xbc7c isHidden → @0xbc88 `cmp w0, w22` → @0xbc8c `b.ne` thoát: chỉ chuyển khi isHidden == visible |
| h — host-bar C-B | **PASS** | Block vào @0xc618: @0xc638 `fmov d0,#1.0` → @0xc63c setAlpha: → @0xc664 setTransform: (alpha=1 TRƯỚC transform) |
| f — lọc orientation {3,4} | **PASS** | Hook setOrientation @0x15bb8 `sub x8,x21,#0x3` → @0x15bbc `cmp #0x2` → @0x15bc0 `csel x8, x21, xzr, lo`; trước log "app setOrientation %lld -> %lld" |
| publishKnobsNow (candidate SplitScreen) | **PASS** | Hàm 0x159e0–0x15f20 chứa **đúng 1 eor**: @0x15d44 `eor w2, w27, #0x1`, w27 = kết quả IsIdentity (@0x15cf0 `mov x27,x0`) đi thẳng vào numberWithBool: — payload = !IsIdentity, khớp dạng lệnh gốc hai slice |
| Khoá pinch ENFORCE | **PASS** | Adapter `currentState` @0x2f9e4 = `mov x0,#0; ret` (Unknown vô điều kiện). Điểm bắn `scpRecognizerDidCross:` @0x2f1fc đọc `currentState` @0x2f31c + hỏi `pinchDispositionForPane:touchesSuppressed:` @0x2f3a4 TRƯỚC mọi requestExpand/Restore — đường ENFORCE bắt buộc qua cổng adapter; cổng 2 (hostOK) không bao giờ qua khi state Unknown |
| sendEvent chỉ ở AppBridge | **PASS** | Chuỗi `sendEvent:` xuất hiện duy nhất ở OmniCarAppBridge.dylib (1); 7 binary còn lại = 0 |
| Kênh cũ nguyên vẹn + kênh mới có mặt | **PASS** | AppBridge còn đủ appbridge.apporient/.orientation/.keyboard; bridgewake.v1.* đủ 4 chuỗi ở SplitScreen + AppBridge (3 module nguồn: SCPShared / ABChannelNames / statics ABInApp — hai dylib đích) |
| Selector mới lạ/nửa vời | **PASS** | Mọi selector mới đều hoặc có IMP định nghĩa trong candidate (bw*, arbiter trio, pinch controller/adapter, attach/detach/syncArming, bwAppliedSnapshotForBundle: @imp 0xd0c0) hoặc là selector UIKit/Foundation chuẩn được tham chiếu (allTouches, phase, CGRectValue, systemUptime…); không tên lạ, không typo |
| Hai cây mirror | **PASS** | Mọi file đã sửa cmp identical project ↔ src (kể cả ABChannels.m ở src/AppBridgeA/src/) |

Modes mặc định trong candidate: không pref nào được đặt sẵn —
owner đọc pref vắng = DRY_RUN cho cả wakeMode/pinchMode (§4/§IX),
candidate đầu không thể tự ENFORCE.

## 4. Tóm tắt keo file:line (bản project; src mirror identical)

| File | Điểm |
|---|---|
| OmniCarSplitScreen/Makefile:13 | + `SCPPinchController.m SCPFullscreenAdapter.m` vào FILES |
| OmniCarSplitScreen/SCPHooks.m:18 | + import SCPPinchController.h |
| OmniCarSplitScreen/SCPHooks.m (Hook_RootVC_viewDidLayoutSubviews) | + lời gọi syncArming sau rootDidLayout |
| OmniCarSplitScreen/SCPCarSplit.m:27 | + import SCPPinchController.h |
| SCPCarSplit.m (cuối ensureContainer) | + `attachIfNeeded` (1 dòng keo) |
| SCPCarSplit.m (dashboardInvalidated, sau bwSessionTeardown) | + `detach` (1 dòng keo) |
| OmniCarSplitScreen/SCPCarSplit+BridgeWake.h:8 | + import SCPPinchController.h; category khai `<SCPPinchArbiter>` + 3 method |
| SCPCarSplit+BridgeWake.m:19 | + import; helper `BWPublishChainSuppressed` (sau BWForceOffBroadcast); 5 điểm gọi (install/wake-open/ack-close/deadline/teardown); gán arbiter trong bwInstallOwner; mục `#pragma mark - Pinch arbitration` ở cuối @implementation (pinchMode / hostIsExpanded / pinchDispositionForPane:touchesSuppressed:) |
| OmniCarAppBridge/BridgeWakePack.h | thay bằng bản chuẩn SplitScreen (identical 4 vị trí) |
| OmniCarAppBridge/ABInApp.m:206,219,257–260,279–283 | adapt codec sang API chuẩn (BWPackFields / BWUnpack struct / hash28) |

## 5. Câu hỏi runtime để lại cho Gate 2 (không tự quyết ở tích hợp)

1. **Hop ABHost có kịp ngân sách không**: xác nhận chrome phía ABHost
   cộng một hop main-queue trước khi đọc snapshot (impl-abhost) — trên
   xe phải đo: wake → ack role=1 về trong 800 ms và owner chốt
   VISIBLE trong hạn WAKING 1,0 s; đếm tỉ lệ "wake confirm timeout"
   trong log [wake1].
2. **targetVerified chặt tới đâu**: luật ứng viên phía app (impl-abapp
   điểm 2) đòi mọi touch Began thuộc ABKeyWindow() hiện hành, khác →
   reason `phone`, wouldSwallow=0. Gate 2 phải trả lời: chạm hosted
   thật trên YouTube/Maps có rơi vào window không-key không — nếu có,
   DRY_RUN sẽ hiện wouldSwallow=0/phone hàng loạt và luật phải nới
   TRƯỚC khi bàn ENFORCE.
3. **Phân bố ack**: tỉ lệ ba kết cục của một giao dịch wake trên xe —
   ack role=0 đúng seq (hoàn tất sạch) / ack-timeout phía app (1,5 s,
   latch fail-open) / owner unconfirmed→UNKNOWN — và ack role=1 từ
   ABHost có echo đúng gen/seq trong điều kiện hai pane hosted đồng
   thời (ô state Darwin dùng chung toàn hệ, §3.3).
4. **Probe pinch điểm CarPlay**: recognizer trên container có thấy đủ
   Began/Moved/Ended của cùng một cặp ở SPLIT không (bộ đếm
   complete/truncated của [pinch1]) — điều kiện tiên quyết của mọi
   bàn luận pinch ENFORCE sau này; EXPANDED chưa đo được (chưa có
   producer, A1 BLOCKED).
5. **wouldPinch phía app**: probe gộp trong ABInApp có ghi nhận dãy
   hai ngón trên hosted scene không, và cờ pinchAllowed từ owner
   (allowlist pref, mặc định rỗng) có giữ wouldPinch=0 như thiết kế
   ở SPLIT+VISIBLE không.
