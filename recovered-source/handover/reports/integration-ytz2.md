# TÍCH HỢP VÒNG WO GPT → CANDIDATE "ytz2" — mirror + build + toàn bộ cổng tĩnh + bảng bằng chứng tiền giao

Ngày: 2026-11-09. Nguồn lệnh: WO "KHẮC PHỤC TỔNG HỢP SAU FS1" (GPT)
+ điều phối coordinator. Phạm vi bước này: mirror src/, build toàn dự
án từ sạch, candidate local, cổng tĩnh trên DEB đã bung, bảng bằng
chứng tĩnh. **Không git, không CI ở bước này** (agent khác phụ trách
đồng bộ/push/CI FAT song song). Mức đạt: **source complete / build
PASS / static PASS** — chưa có bằng chứng xe cho mọi tính năng mới
của vòng này.

## Candidate

- Path: `project/packages/com.anlai.omnicar_1.0.3-ytz2_iphoneos-arm64.deb`
- Size: **1.021.310 B**; SHA-256:
  `4737cfa93c2c5a6a7c7ade37a0b7731718f626bb267dd2d03cf6d9f54018d6ad`
- Members: `debian-binary` + `control.tar.gz` + `data.tar.lzma`
  (khuôn CI như mọi candidate local). arm64-only (VM hạ arm64e);
  FAT hai lát là việc của strand CI.
- control: diff với ytz1 — **chỉ khác Installed-Size** (3712 → 3748).
  Package/Version/Depends giữ nguyên.
- Danh sách file trong gói: **identical ytz1** (đếm bằng
  `find . -type f` trong payload đã bung: **176 file** cả hai bản,
  diff = 0 dòng).

## 1. Mirror src/ (việc 1)

Strand fix-y-issplit chỉ sửa cây project/. Đối chiếu cmp toàn bộ file
của cả 5 strand (13 cặp project/ ↔ src/):

| Cặp file | Trước đồng bộ | Sau |
|---|---|---|
| OmniCarAppBridge/ABYTZoom.m ↔ AppBridgeB/ | **DIFF** (98 dòng diff) | identical |
| OmniCarSplitScreen/SCPCarSplit.m ↔ SplitScreenA/ | **DIFF** (thiếu khối split/splitver :2065–2083) | identical |
| ABInApp.m ↔ AppBridgeB/ (fix-w-act-app) | identical | identical |
| SCPCarSplit+BridgeWake.{h,m}, SCPCarSplit+AutoHide.{h,m} ↔ SplitScreenA/ (fix-wp-owner) | identical | identical |
| SCPFullscreenController.{h,m} ↔ SplitScreenA/, OMCSplitScreenController.m ↔ Prefs/OMCPrefs/ (fix-p-diag) | identical | identical |
| SCPHooks.m, SCPTouchProbe.{h,m} ↔ SplitScreenA/ (fix-w-probe) | identical | identical |

Đã chép project/ → src/ đúng 2 file lệch (chiều project là canonical:
bản project chứa đủ marker `isSplit-fallback`/`lease-lapse`/`splitver`,
bản src cũ không có). Sau chép: **13/13 cặp identical**.
Ghi chú cấu trúc: cây src/ **không có Makefile** ở mọi module (mirror
chỉ gồm source) — Makefile SplitScreen ở project/ đã chứa
`SCPTouchProbe.m` (:13) ✓. Resources Prefs (SplitScreen.strings
en/vi = **56 khoá** mỗi ngôn ngữ) chỉ tồn tại ở project/ như các vòng
trước ✓.

## 2. Build (việc 2)

- Toolchain verify trước: clang-18 `1:18.1.3-1ubuntu1` ✓;
  `/usr/bin/ld.lld` → `ld.lld-18` ✓; ldid tại `/usr/local/bin/ldid`
  ✓; SDK `~/theos/sdks/iPhoneOS16.5.sdk` ✓ — không cần khôi phục.
- `make clean` (obj dir về 0) → `make` tại gốc project (umask 022,
  THEOS=~/theos): **exit 0, 0 error**. Warning chỉ ở file cũ không
  thuộc vòng này (SCPCarSplit+Relayout.m, ABHostLaunch.m,
  SSStartupView*.m, SCPCarSplit+Layout.m) — cùng mặt warning các
  vòng trước.
- Kích thước dylib vừa build (arm64): AppBridge 637.088 B;
  SplitScreen 1.293.152 B; Prefs bundle binary 1.278.208 B.
- `make package FINALPACKAGE=1`: exit 0 → candidate ở trên.

## 3. Cổng tĩnh trên DEB đã bung (việc 3) — baseline fs1 VÀ ytz1

Phương pháp parity: tập chuỗi duy nhất của section `__objc_methname`
(trích bằng parser Mach-O, cùng phương pháp các vòng fs1/ytz1; số
fs1 tái lập đúng: AppBridge 725, SplitScreen 1385). Phương pháp
disasm: capstone trên IMP lấy từ bản đồ (class/category, selector)
của chính binary.

### 3.1 Selector parity — 8 thành phần

| Thành phần | fs1 | ytz1 | ytz2 | vs fs1 | vs ytz1 |
|---|---|---|---|---|---|
| App | 120 | 120 | 120 | 0/0 | 0/0 |
| AppBridge | 725 | 798 | 798 | mất 0, +73 | **identical** |
| CarProbe | 117 | 117 | 117 | 0/0 | 0/0 |
| Core | 137 | 137 | 137 | 0/0 | 0/0 |
| Prefs | 1719 | 1719 | 1719 | 0/0 | 0/0 |
| SpeedBubble | 794 | 794 | 794 | 0/0 | 0/0 |
| SplitScreen | 1385 | 1381 | 1388 | mất 4*, +7 | mất 0, +7 |
| StartupScreen | 730 | 730 | 730 | 0/0 | 0/0 |

\* 4 selector mất vs fs1 = `_prefsToken`, `_testSwitchLast`,
`fsTestPrefsChanged`, `fsTestSwitchOn` — toàn bộ bề mặt [fs1-test]
đã gỡ ở vòng ytz1 theo lệnh 14:37 (chủ đích, đã ghi ở
integration-ytz1 §6.1; không phải mất ở vòng này).
+7 của SplitScreen vs cả hai baseline = đúng bề mặt vòng WO:
`_fsDiagPrefsToken`, `_fsDiagWant`, `fsDiagPrefsChanged` (P2 diag),
`bwRenewMaintain`, `bwRenewTick:` (W2 renewal), `sendEvent:`
(selector của probe W4), `valueWithPointer:` (helper probe dùng).
+73 của AppBridge vs fs1 = bề mặt YZ của vòng ytz1 (lease record,
yzEffectiveOrientation:, yzLease* — ytz2 identical ytz1, vòng này
không thêm selector nào phía AppBridge: các sửa W-act/Y là trong
thân hàm + chuỗi log).

### 3.2 Hồi quy g1 / g2 / h / f

| Cổng | Kết quả | Bằng chứng thô (ytz2) |
|---|---|---|
| g1 — host appWithHash: csel | **PASS** | IMP `appWithHash:changedOrientation:supportedMask:` = 0x7e34 (bằng ytz1); @0x8078 `cmp x8,#0` → @0x807c `csel x8,xzr,x9,ne`; @0x8080 `cmp x25,#0` → @0x8084 csel eq; sentinel @0x8088 `cmp x21,#0xff` → @0x808c `csel x2,x8,x21,eq` — từng lệnh khớp ytz1 |
| g2 — app derivation csel | **PASS** | @0x18348 `tst x0,#0x2` → @0x1834c `csel x9,x8,xzr,eq` (ytz1: 0x18340/0x18344 — dịch +8 do thân ABInApp thêm code act, cùng dạng: bit portrait có mặt → 0) |
| h C-A — bar transition polarity | **PASS** | IMP `setBarVisible:pop:dim:single:forApp:` = 0xc1a4; @0xc438 `cmp w0,w22` → `b.ne` — chỉ chuyển khi isHidden == visible, khớp ytz1 từng địa chỉ |
| h C-B — entrance alpha=1 trước transform | **PASS** | Trong cùng IMP: @0xcde8 `fmov d0,#1.0` → bl @0xcdec → bl @0xce14 (đúng vị trí/khuôn ytz1; địa chỉ stub đích dịch 0x2dc10 → 0x2e424 do layout __stubs đổi) |
| f — lọc orientation {3,4} | **PASS** | @0x5fb0 `sub x8,x24,#0x3` → `cmp x8,#0x2` → `csel x2,xzr,x24,lo` — đúng địa chỉ và dạng như ytz1. (Một hit thứ hai cùng idiom @0x17f4c `sub x8,x21,#3 → cmp #2 → csel x8,x21,xzr,lo` — idiom lọc khoảng của helper suy hướng, ghi thô để đối chiếu) |

### 3.3 Núm divider — publishKnobsNow đúng 1 eor

**PASS.** IMP: fs1 0x15ad0 / ytz1 0x15ad0 / ytz2 **0x15bcc** (dịch do
SCPCarSplit.m thêm khối split/splitver). Quét toàn thân hàm tới IMP
kế (356 lệnh, ret duy nhất @0x16154): đúng **1** `eor` —
@0x15f30 `eor w2, w27, #1` — cùng dạng fs1/ytz1 (payload =
!IsIdentity).

### 3.4 Bốn hash cấm ABHost (source, cả hai cây)

**PASS — MATCH cả 4** (SHA-256 thân hàm signature → dòng `^}`,
tính độc lập trên cây cuối; project/ và src/AppBridgeB cho cùng giá
trị từng hàm):

| Hàm | Vị trí ABHostBMethods.m | SHA-256 |
|---|---|---|
| setFrame:forApp:live:handle:passInsets: | :629–665 | `8606f40a1ebf5ecad131ae276a227220a02c0e20c2a2c5c1ec2dbef0398341ef` |
| setBarVisible:pop:dim:single:forApp: | :1126–1160 | `3044b10d0902…` (prefix khớp giá trị đã công bố) |
| setHandleVisible:forPane: | :1224–1229 | `409cfb1447cb…` |
| setKnobs: | :1453–1551 | `b98a9f2611e0…` |

### 3.5 hostFrameInfo superset (nay gồm fade + split/splitver)

**PASS.** Builder `hostFrameInfo:pane:live:handle:` (SCPCarSplit.m
:2042+): literal gốc 11 khoá (`identifier, x, y, w, h, live, handle,
pt, pl, pb, pr`) + `hostBarInfoForPane:` + `fade` (:2064) +
**`split`/`splitver` (:2082–2083, cộng vòng này)** + `r, corners,
hx, front` + `ox/oy/ow/oh` + `ax/ay/aw/ah`. Mọi khoá cũ giữ nguyên
tên/công thức — vòng này chỉ CỘNG 2 khoá. Binary: chuỗi `splitver`
có trong SplitScreen ×1 và AppBridge ×1 (xem §4-YZ).

### 3.6 Điểm ghi requestedOrientation duy nhất

**PASS.** Toàn module AppBridge: điểm ghi giá trị DUY NHẤT từ kênh
apporient vẫn là ABHostBMethods.m:607 trong `appWithHash:`
(`found.requestedOrientation = (changed == 0xFF) ? derived : changed;`);
ABYTZoom.m:324 và :368 **chỉ gán 0** (repair + đai lease);
ABPane.m:52 là @synthesize accessor. Không điểm ghi mới.

### 3.7 Kênh + markers hồi quy

- 5 kênh `bridgewake.v1.{state,query,wake,ack,act}`: mỗi chuỗi ×1
  trong AppBridge và ×1 trong SplitScreen ✓ (khớp fs1/ytz1).
- Chuỗi ytlease/ytleaseack + markers [ytz] phía AppBridge: nguyên
  vẹn (parity AppBridge identical ytz1 ở §3.1).

## 4. Cổng MỚI của vòng WO (việc 4) — truy trên source + binary

### 4.1 ACT (W1/W2-A/W3 phía app)

| Kiểm | Kết quả | Bằng chứng thô |
|---|---|---|
| Đường phát act không còn phụ thuộc BWFresh | **PASS** | Điểm gọi duy nhất trong `BWHandleTouchEvent` (ABInApp.m:629) là `BWActOnSequenceStart(began);` — không còn `if (BWFresh()) BWPostAct();`. Thân `BWActOnSequenceStart` (:336–375) + `BWPostAct` (:291) không chứa BWFresh (toàn file: BWFresh chỉ ở 6 điểm suppression + 2 dòng comment mô tả luật cũ :149/:277) |
| 4 chuỗi lý do act trong binary AppBridge | **PASS** | `act-posted` ×1, `act-drop-nosession` ×1, `act-drop-scene` ×1, `act-drop-target-unknown` ×1 (ytz1: cả 4 = 0) |
| Suppression vẫn qua BWFresh — đếm điểm gọi phía app | **PASS = 6** | :224 BWEffectiveWakeMode, :228 BWEffectivePinchMode, :483 BWGatePass, :549 BWProbeLogging, :633 báo cáo mode tại mở dãy, :644 BWQueryIfStale — tất cả thuộc đường nuốt/probe, không điểm nào thuộc đường act |
| Phía owner: mọi điểm loại act có reason | **PASS** | Chuỗi trong SplitScreen binary: `decode-fail` ×1, `bad-hash` ×1, `bad-gen` ×1, `session-inactive` ×1, `not-assigned` ×1, `split-inactive` ×1, `act-accepted` ×1, `reveal-applied` ×1 (log ahRevealBody kèm views=) |

### 4.2 Renewal state (W2 phía owner)

**PASS.** Source: `bwRenewTimer` + `bwRenewMaintain`/`bwRenewTick:`
trong SCPCarSplit+BridgeWake.m; timer lập tại :252
`scheduledTimerWithTimeInterval:1.0` (< 2,5 s freshness). Binary
SplitScreen: chuỗi `bw renew` ×3 (start/stop/tick kèm hashes).
Selector `bwRenewMaintain` + `bwRenewTick:` có trong parity (§3.1).

### 4.3 Arbiter EXPANDED theo phiên (P1) + chẩn đoán (P2/P4)

| Kiểm | Kết quả | Bằng chứng thô |
|---|---|---|
| `isEqualToString:bwExpandedBundle` trong BridgeWake.m | **PASS = 0** | grep cả hai cây = 0; `bwExpandedBundle` chỉ còn khai báo + gán ở setter (biến ghi/log) |
| Vị từ EXPANDED chung hai hàm | **PASS** | `bwPinchAllowedForPane:` (BridgeWake.m:307–310) và `pinchDispositionForPane:` (:788–791) dùng NGUYÊN VĂN cùng vị từ: `bwExpandedFlag && self.active && [[self allPanes] containsObject:pane] && !bwWakePendingBySlot[pane.slot] && !self.resizing`; điểm promote HIDDEN→VISIBLE khi expanded cũng theo cờ phiên (:399) |
| Chuỗi [fs-diag] + khoá fullscreenDiagExpand trong SplitScreen binary | **PASS** | `[fs-diag]` ×3, `fullscreenDiagExpand` ×2 (ytz1: 0/0) |
| Binary Prefs (CODE) chứa đủ 3 khoá | **PASS** | `fullscreenDiagExpand` ×1, `youtubeVirtualize` ×1, `bridgewake.pinchMode` ×1 trong OmniCarPrefs của candidate (ytz1: cả 3 = 0 theo chủ đích vòng trước; vòng này WO yêu cầu có trở lại làm công tắc runtime trong cùng một DEB) |
| pinchMode default = DRY_RUN (static init + reload) | **PASS** | Static init BridgeWake.m:46 `bwPinchMode = BWModeDryRun`; reload :476 nhánh pref vắng → `BWModeDryRun` (wakeMode :45/:475 cùng DRY_RUN) |
| Segment Prefs mặc định khớp | **PASS = 1** | OMCSplitScreenController.m:400–404: `segmentForKey:@"bridgewake.pinchMode" … def:1` (1 = Dry run — khớp default owner vừa sửa; lệch default vòng trước đã được fix-wp-owner xử lý) |

### 4.4 YZ isSplit (Y1)

| Kiểm | Kết quả | Bằng chứng thô |
|---|---|---|
| `panes.count` chỉ còn ở nhánh fallback | **PASS** | ABYTZoom.m toàn file đúng **1** hit: :199 `if (host.panes.count <= 1) return NO;` — nằm trong `YZComputeIsSplit` SAU dòng log fallback; đường chính :190 `if (YZSessionSplitKnown) return YZSessionSplitValue;` không tham chiếu panes |
| Chuỗi isSplit-fallback trong binary | **PASS** | AppBridge: `isSplit-fallback` ×1 (ytz1: 0); kèm `lease-lapse` ×1 và `owner phien host` ×1 (instrument Y4) |
| Chuỗi split/splitver ở cả hai phía | **PASS** | SplitScreen: `splitver` ×1, `split` ×47; AppBridge: `splitver` ×1, `split` ×12 |

### 4.5 Probe W4 (CarPlayApp sendEvent)

| Kiểm | Kết quả | Bằng chứng thô |
|---|---|---|
| MSHookMessageEx trong module SplitScreen | **PASS có ghi chú đếm (xem dưới)** | Binary candidate: **30 bl + 1 tail-b = 31 điểm gọi** tới stub `_MSHookMessageEx` (đếm bằng capstone + bản đồ __stubs/indirect; đối chứng dương: _objc_msgSend = 7196 điểm). Baseline cùng phương pháp: fs1 = 29 bl + 1 tail = 30; ytz1 = 30. **Delta ytz2 − ytz1 = đúng +1 = hook probe.** Source: SCPHooks.m 29 call thật + SCPSpringBoardHooks.m:175 1 call + SCPTouchProbe.m:198 1 call = 31 ✓ khớp binary |
| Chuỗi [probe] trong binary | **PASS** | SplitScreen: `[probe]` ×4 + `[probe-foreign]` ×1 (5 format log: install/began/chain/chain-orphan/foreign) |
| Probe không gọi API activity/reveal/swallow | **PASS** | grep SCPTouchProbe.{m,h}: `ahNoteActivity`/`ahReveal`/`bwHandle`/`BWPostAct` = 0 lời gọi; hit duy nhất là câu comment trong header mô tả điều probe KHÔNG làm ("never reveals, never swallows") |

**Ghi chú đếm cho coordinator/GPT (số thô để đối chiếu):** con số
"32" trong biên bản fix-w-probe là đếm theo DÒNG grep
(SCPHooks.m 31 dòng — trong đó 2 dòng là comment :2/:614 — cộng 1
lời gọi của probe), chưa tính SCPSpringBoardHooks.m. Đếm call-site
thật: source 31 = binary 31. Khác biệt thuần túy do phương pháp
đếm; kết luận thực chất của cổng — **đúng MỘT hook mới (probe) được
thêm vào module** — giữ nguyên ở cả hai phương pháp.

### 4.6 Phân bổ sendEvent theo process

| Binary | Chuỗi `sendEvent:` | Hook | Process |
|---|---|---|---|
| OmniCarAppBridge.dylib | ×1 | ABInApp — 1 hook / 1 orig call (source ABInApp.m:600 cài, :591 gọi orig — không đổi vòng này) | process app được host |
| OmniCarSplitScreen.dylib | ×1 | SCPTouchProbe — hook sendEvent thứ hai của gói | **CarPlayApp** (chỉ cài khi SCPHostIsCarPlayApp) |
| 6 binary còn lại | 0 | — | — |

Đúng mô hình WO W4: hai hook ở hai process khác nhau; hook phía
CarPlayApp là probe thụ động (gọi orig trước, không nuốt/đổi đích).

## 5. Bảng bằng chứng tiền giao (phần tĩnh làm được theo WO)

### 5.1 Bảng F1–F4 / ACT — đường activity gọi lại controls

| Đường | Điểm phát (source, cây cuối) | Cổng hiện tại | Điểm nhận / tác dụng | Trạng thái tĩnh |
|---|---|---|---|---|
| F1 — hitTest container | SCPCarSplitView.m:32 → `ahNoteActivity:AHSourceContainer` | Không cổng (mọi hitTest phía CarPlay) | AutoHide: ahNoteActivity: (SCPCarSplit+AutoHide.m:222) → ahRevealBody: (:186) nếu đang mờ | Nguyên vẹn từ fs1 |
| F2 — chạm handle host | SCPCarSplit.m:2553 (bridgeHandleTapped:) + remoteKnobTouch: → `ahNoteActivity:AHSourceHostHandle` | Không cổng | Như F1 | Nguyên vẹn từ fs1 |
| F3 — chạm nút logo/Home | SCPCarSplit.m:3031 (homeButtonTapped) → `ahNoteActivity:AHSourceHome` | Không cổng | Như F1 — đường Nguyen xác nhận sống trên xe fs1 | Nguyên vẹn từ fs1 |
| F4/ACT — gói act từ process app | ABInApp.m:629 `BWActOnSequenceStart(began)` → :336 quyết định → :291 `BWPostAct` (throttle 0,12 s) → Darwin `bridgewake.v1.act` | **MỚI (vòng này):** (a) phiên đã xác thực danh tính — `BWActSessionVerified` đặt tại điểm chấp nhận state packet (ABInApp.m:423), KHÔNG còn điều kiện tươi 2,5 s; (b) trói scene W3 — scene được host theo lease YZ hoặc ABKeyWindow, sai scene → drop có reason | Owner SCPCarSplit+BridgeWake.m `bwHandleActPacket:`: kiểm decode/hash/gen/session/assignment/state với 6 reason riêng → `ahNoteActWithKbActive:` (AutoHide.m:238) → ahNoteActivity: → ahRevealBody: log `reveal-applied … views=N` + `pushHostFramesLive:NO` đẩy `fade=NO` xuống gương host | **STATIC_PASS** — hành vi xe = PENDING (nghiệm thu W5) |
| ACT drop reasons (log xe sẽ đọc) | app: `act-drop-nosession` / `act-drop-scene` / `act-drop-target-unknown`; owner: `decode-fail` / `bad-hash` / `bad-gen` / `session-inactive` / `not-assigned` / `split-inactive`; thành công: `act-posted` (app) + `act-accepted` (owner) | Mỗi dòng kèm stamp monotonic ms + `stateage=` phía app | Phân định được cả 7 điểm loại của checklist W1 bằng log | STATIC_PASS |

Suppression (quyền nuốt) tách riêng hẳn đường act: vẫn đòi
BWFresh() ở 6 điểm (§4.1) + state gia hạn 1,0 s phía owner (§4.2) để
state đủ tươi khi controls ẩn lâu — đúng W2-A/B của WO.

### 5.2 Bảng arbitration SPLIT / EXPANDED (vị từ phiên mới)

Truy trên source cây cuối (BridgeWake.m) — hai hàm dùng nguyên văn
một vị từ EXPANDED: `bwExpandedFlag && self.active && pane ∈
allPanes && !bwWakePendingBySlot[slot] && !self.resizing`.

| Trường hợp | bwPinchAllowedForPane: (cờ gói) | pinchDispositionForPane: (đường bắn) |
|---|---|---|
| SPLIT + VISIBLE + không popup/drag | theo state + allowlist (vắng = YES) | Allowed |
| SPLIT + HIDDEN | NO (state ≠ VISIBLE) | **BlockedHidden — wake thắng** |
| SPLIT + UNKNOWN/INACTIVE/WAKING | NO | BlockedUnknown (fail-open) |
| EXPANDED, bundle owner = nil (controller luôn gọi forBundle:nil) | **YES** (theo phiên) | **Allowed — pinch-in mở** |
| EXPANDED, split hỗn hợp native+hosted | YES cho cả hai pane (native qua allPanes) | Allowed cả hai |
| EXPANDED, hai hosted | YES từng pane độc lập | Allowed |
| EXPANDED, đổi pane (swap/reassign) | theo pane object còn trong allPanes — không đọc bundle | như cờ |
| EXPANDED, pane bị xoá | pane ∉ allPanes → trượt hàng EXPANDED; state INACTIVE → NO | BlockedUnknown |
| EXPANDED nhưng wake txn đang mở trên slot / đang kéo divider | hàng EXPANDED nhường (guard !bwWakePending / !resizing) | nhường tương ứng — hai hàm không mâu thuẫn |
| Restore xong (kể cả đường timeout) | controller settle → bwSetExpandedActive:NO → cờ phiên tắt → về hàng SPLIT thường, không latch | như cờ |

### 5.3 Trạng thái từng track (thang WO)

| Track | STATIC | RUNTIME | DEVICE | Ghi chú |
|---|---|---|---|---|
| AutoHide/Wake — sửa đường gọi lại (W1–W3) | **STATIC_PASS** | PENDING | PENDING | Chờ nghiệm thu W5 trên xe (mờ 4 s/10 s/30 s vẫn gọi lại; chạm iPhone không gọi nhầm). ENFORCE nuốt chạm: chưa mở (wakeMode default DRY_RUN) — không gọi DRY_RUN là đạt chuẩn QA180 |
| Probe W4 (đo đường chạm hosted) | **STATIC_PASS** | PENDING | PENDING | Probe chính là công cụ tạo bằng chứng runtime cho quyết định dời feed; chưa có log xe |
| Pinch + Fullscreen controller (P1–P4) | **STATIC_PASS** | PENDING | PENDING | pinchMode default đã về DRY_RUN trong cùng DEB; ENFORCE mở bằng segment Prefs sau khi controller đạt nghiệm thu độc lập qua [fs-diag] (P2) — ma trận 10 chu kỳ/disconnect/app-crash chưa chạy |
| YT-Zoom isSplit (Y1) + instrument (Y4) | **STATIC_PASS** | PENDING | PENDING | Trường hợp kết án: YouTube hosted + Maps native — log phải có lease `split=1` và KHÔNG có `isSplit-fallback`. Đối chứng OFF/ON bằng switch Prefs trong cùng DEB (Y2) |
| Weather (fixround7, W1–W8) | STATIC_PASS (từ vòng r7) | PENDING | PENDING | Không đụng ở vòng này; nghiệm thu bắt buộc (perm=0 → fallback, không kẹt in-flight, 2 phiên liên tiếp) chưa có xe |
| Núm divider (publishKnobsNow) | **STATIC_PASS** | PENDING | PENDING | 1 eor đo lại trên candidate này (§3.3); chấm xe chưa có |

Không mục nào được gọi là PASS ở cấp cao hơn bằng chứng hiện có.

## 6. Điểm diễn giải để lại cho coordinator / GPT

1. **Số hook MSHookMessageEx "32" vs 31**: xem ghi chú đếm ở
   §4.5 — chênh lệch do đếm dòng grep (tính cả comment) ở biên bản
   strand; call-site thật source = binary = 31, delta vòng này
   đúng +1 (probe). Cần GPT/coordinator chốt một phương pháp đếm
   duy nhất cho các vòng sau.
2. **Candidate local arm64-only**: mọi cổng hai-lát (eor/g1/g2
   từng lát, parity từng lát, UUID) phải chạy lại trên FAT của
   strand CI như các vòng trước — ngoài phạm vi bước này.
3. **File list 176 vs con số 179 ở integration-ytz1**: khác phương
   pháp đếm (ytz1 đếm cả thư mục/mục phụ trong payload); ở vòng
   này cả hai candidate được đếm bằng cùng một lệnh
   (`find . -type f`) → 176 = 176, diff 0 — kết luận "identical"
   không đổi.
4. **handover-ytz2-draft.md** đã tồn tại trong thư mục work (của
   luồng song song) — biên bản này là bản tích hợp độc lập; mọi số
   liệu trên đều đo lại từ candidate/source ở bước này, không chép
   từ draft.
5. Rollback: baseline bất biến fs1 FAT (SHA `41bb5b8b…`) và QA20
   không bị đụng; candidate này thay thế ytz1 làm ứng viên tích
   hợp duy nhất chờ CI FAT + nghiệm thu xe.
