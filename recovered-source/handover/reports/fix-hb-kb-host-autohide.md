# FIX-HB — WO GPT vòng ytz4: ba ràng buộc AutoHide-EXPANDED + nguồn kb phía host/owner

Mức đạt: **source complete / build PASS / static PASS** (chưa có bằng chứng xe).
Gate 3 vẫn ĐÓNG theo GPT — strand này chỉ sửa tín hiệu kb và gỡ ràng buộc
AutoHide; việc đo nuốt trọn chuỗi thuộc vòng nghiệm thu sau.

## File đã đụng (project/ + mirror src/, cmp identical 10/10 cặp)

Phần 1 + owner Phần 2 (SplitScreen):
- `OmniCarSplitScreen/SCPCarSplit+BridgeWake.m` (+ `src/SplitScreenA/`)
- `OmniCarSplitScreen/SCPCarSplit+BridgeWake.h` (chỉ comment: sửa câu
  "no pane aggregates to HIDDEN" đã sai + ghi hợp đồng gói kb type 6)
- `OmniCarSplitScreen/SCPCarSplit+AutoHide.m`
- `OmniCarSplitScreen/SCPShared.h` / `SCPShared.m` — CHỈ cộng hằng số
  kênh `SCPNoteBridgeKbSync` (constants file của module, đúng kỷ luật
  "mỗi module giữ chuỗi kênh ở constants file của mình").

Phía ABHost Phần 2 (AppBridge):
- `OmniCarAppBridge/ABHostGeometry.m` — điểm quản lý phiên phím sống
  (`ABKeyboardDispatch`) + disconnect + snapshot lúc open.
- `OmniCarAppBridge/ABHostLaunch.m` — điểm ẩn phím ở teardown
  (`closeApp:terminate:`) vốn vòng qua dispatch.
- `OmniCarAppBridge/ABChannelNames.m` + `AppBridgeB.h` — CHỈ cộng hằng
  số/extern `ABChanKbSync`.
- `OmniCarAppBridge/ABHost.h` — CHỈ cộng khai báo `ABKbSyncNoteEvent`
  (bản src module A `src/AppBridgeA/src/ABHost.h` cộng cùng khai báo
  theo văn phong file A; bản B `src/AppBridgeB/ABHost.h` identical).

KHÔNG đụng: `BridgeWakePack.h` (cả 4 bản giữ nguyên từng bit — md5
`17c004e0627fb3f9967e2321695a7b27` ×4), ABInApp.m, ABKeyboard.m,
SCPCarSplit.m, SCPFullscreenController/Adapter.

## PHẦN 1 — Gỡ đủ ba ràng buộc AutoHide-EXPANDED

### (1) `bwSetExpandedActive:` không còn suspend (BridgeWake.m:440)
Trước: thân hàm gọi `[self ahSetSuspended:active]` kèm comment
"[autohide] EXPANDED suspends the fade machine". Sau: lời gọi và cơ
chế đó bị xoá; giữ nguyên `bwExpandedFlag`, `bwExpandedBundle`, dòng
log `[wake1] bw expanded ON/OFF` và vòng `bwRecomputeForPane:` cho
mọi ô hosted. Đường treo hosted-solo ở SCPCarSplit.m:2019/2039 gọi
`ahSetSuspended:` trực tiếp — không thuộc file này, không bị ảnh
hưởng (kiểm ở mục Cổng).

### (2) `ahFadeBlockedReason` bỏ hạng tử expanded (AutoHide.m:140)
Trước: dòng đầu `if ([self bwExpandedActive]) return "expanded";`.
Sau: hạng tử bị xoá hẳn (kể cả chuỗi literal — grep `"expanded"`
trong thân hàm = 0). GIỮ NGUYÊN: `"solo"`, `"kbhold"` (giữ chỗ vì
bàn phím), `"surface-open"` (popup/picker/ratio/tray — khoá popup),
`"dragging"` (resizing/dragGhost — khoá dragging).

### (3) `bwRecomputeForPane:` bỏ phép nâng HIDDEN→VISIBLE (BridgeWake.m:~521)
Trước:
```objc
if (state == BWStateHidden && bwExpandedFlag)
    state = BWStateVisible;
```
Sau: khối bị xoá, thay bằng comment ghi rõ ngữ nghĩa mới. Đang
EXPANDED mà controls đã fade thì state tính ra tới được HIDDEN và
gói state phát đi nói HIDDEN — suppression phía app hết sai ngữ
nghĩa. Comment ở BridgeWake.h (bwSetExpandedActive) đã sửa tương ứng.

### Kiểm bắt buộc 1 — pinch-in độc lập trạng thái fade: ĐẠT bằng truy vết source
- `bwPinchAllowedForPane:` và `pinchDispositionForPane:` đều có hàng
  EXPANDED theo PHIÊN: `bwExpandedFlag && self.active && pane ∈
  allPanes && !bwWakePendingBySlot[slot] && !self.resizing` → cho
  phép, và hàng này RETURN TRƯỚC mọi lần đọc `bwStateBySlot` (hàng
  duy nhất mà (3) có thể đổi giá trị đầu vào).
- Cả ba điểm đã gỡ đều không nằm trên đường arbiter đọc: (1) là lời
  gọi sang AutoHide, (2) là cổng của timer fade, (3) chỉ ghi vào
  `bwStateBySlot` — giá trị mà hàng EXPANDED không hề tham chiếu.
- `grep ahFaded|ahSuspended|ahSetSuspended` trong
  SCPPinchController.m = **0 hit**: controller không đọc trạng thái
  fade/suspend ở bất kỳ đâu.
⇒ Thoát EXPANDED bằng pinch-in giữ nguyên quyền độc lập với fade.

### Kiểm bắt buộc 2 — chuỗi fade khi EXPANDED chạy đủ như split
`ahArmTimer` chỉ chặn khi `!installed/!enabled/!active/ahSuspendedState`;
EXPANDED nay không đặt suspended (chỉ solo đặt) → timer chạy →
`ahTimerFired:` (không bị no-op vì suspended) → `ahFadeBlockedReason`
(solo/kbhold/surface-open/dragging còn nguyên, expanded đã bỏ) →
`ahPaintCurrentSet` → `bwRecomputeForPane:` từng ô hosted → HIDDEN
tới được (điểm 3) → gói state HIDDEN phát → activity (F1/F4/feed)
vào `ahNoteActivity:` (không còn bị suspended nuốt) → `ahRevealBody:`.
Marker kỳ vọng sau sửa: `[wake1] bw expanded ON` **không còn**
`[autohide] suspend` đi kèm vì expanded; cặp suspend/resume chỉ còn
xuất hiện quanh chuyển hosted-solo. Giữa hai marker expanded phải
thấy `[autohide] fade`, `bw state …->HIDDEN`, `reveal-applied` như
ở split.

## PHẦN 2 — Nguồn kb xác thực phía host + phát về app

### Hiệu chỉnh topo (đọc từ source — khác giả định trong ngoặc của WO)
`hostFrameInfo` do **SCPCarSplit dựng và gửi** (SCPCarSplit.m:2091,
post qua `hostPost:` lên `appbridge.frame`), **ABHost tiêu thụ**
(ABFrameBlock, ABHostGeometry.m). Chiều ABHost→owner thật là họ kênh
NSDistributedNotificationCenter host→car (`appbridge.state`,
`handletap`, `handledrag`, `baraction`… — ABHost post, SCPHooks phía
xe observe). Trường kb được cộng trên ĐÚNG chân đó bằng một kênh mới
cùng họ: **`com.anlai.omnicar/appbridge.kbsync`** (hằng số hai phía:
`ABChanKbSync` / `SCPNoteBridgeKbSync`), payload dict
`{identifier, kbactive, kbsession, kbsource="host-keyboard-session"}`.

### Phía host — đối tượng phiên và các điểm phát (ABHostGeometry.m)
Điểm quản lý phiên thật: `ABKeyboardDispatch` (consumer của Darwin
`appbridge.keyboard`): state bit0=shown + hash → bundle →
`showForApp:`/`hideForApp:` lên ABKeyboard. TU này giữ bản ghi phiên
sống duy nhất (`abKbLiveBundle`, `abKbLiveSession`, bộ đếm phiên
tăng mỗi lần mở; đóng báo id của phiên bị đóng, 0 nếu app đóng
không giữ phiên). Mọi mở/đóng funnel qua `ABKbSyncNoteEvent`:
- dispatch show → post active=1 + session mới (ABHostGeometry.m:228);
- dispatch hide → post active=0 + session bị đóng (:222);
- teardown `closeApp:terminate:` (ABHostLaunch.m:261) — điểm ẩn này
  vòng qua dispatch nên có post riêng qua cùng funnel;
- CarPlay disconnect (force `hideForApp:nil`, ABHostGeometry.m:259)
  → post đóng cho bundle đang giữ phiên trước khi teardown;
- snapshot ban đầu: `ABOpenBlock` (:365) post `ABKbSyncSnapshotForApp`
  cho app vừa (re)open — active chỉ khi app đó đang giữ phiên sống.
Mỗi post log `[kb-sync] host post … source=host-keyboard-session`.

### Phía owner — lưu trữ ba trạng thái + phát gói type 6 (BridgeWake.m)
- Bản ghi theo slot: `bwKbKnownBySlot/bwKbActiveBySlot/bwKbSessionBySlot[10]`.
  known=NO = **UNKNOWN**; không một đường nào mặc định UNKNOWN thành
  INACTIVE. Giá trị cũ phía owner (flag của gói act, `BWKb ==
  BWKbActive` — cho 0 cả khi BWKbUnknown, ABInApp.m:297 →
  BridgeWake.m đường act cũ) **không bao giờ** được phát lại thành
  tri thức kb: nguồn duy nhất là kbsync từ host.
- `bwHandleKbSyncNote:` (BridgeWake.m:302): khớp bundle với slot
  đang giữ (`bwBundleBySlot`); bundle không thuộc slot nào → drop có
  log `[kb-sync] drop not-assigned`. Cập nhật bản ghi; đổi → log
  `[kb-sync] change … source=host-keyboard-session` + phát ngay.
- Reset về UNKNOWN tại đúng hai điểm đổi assignment: khối gen
  bookkeeping trong `bwRecomputeForPane:` (bundle đổi → gen tăng) và
  `bwSessionTeardown` (mọi assignment kết thúc). Snapshot thuộc về
  một cặp (bundle, assignment) duy nhất — đúng yêu cầu GPT "gắn
  bundle/assignment của phiên; thiếu snapshot hoặc mất đồng bộ thì
  UNKNOWN". Bất kỳ bằng chứng ACTIVE hợp lệ nào (kbsync active=1)
  đều ghi known=1/active=1 và chặn suppression ở phía app theo hợp
  đồng gói dưới đây.
- Poster `BWEmitKbPacket` (BridgeWake.m:190): kênh state
  `bridgewake.v1.state`, dùng CHUNG register-check token
  `bwStateSendToken` và CHUNG bộ đếm seq đơn điệu `bwStateSeq` với
  `BWEmitStatePacket` (comment "ONLY poster" ở poster cũ đã sửa cho
  đúng sự thật hai poster/một token/một seq).

### Hợp đồng gói kb (cho strand phía app đối chiếu)
- **type = 6** — giá trị chưa dùng đầu tiên trong bảng type của
  BridgeWakePack.h (0 invalid, 1 state, 2 query, 3 wake, 4 ack,
  5 act; 7 reserved). Khai báo tại chỗ `BWTypeKbSync` trong
  BridgeWake.m để cả hai bản BridgeWakePack.h giữ identical vòng
  này; việc cộng enum `BWTypeKb` vào cả hai bản header là việc của
  vòng tích hợp/app-side.
- Header giữ nguyên kỷ luật state: bit63 valid, bits62–35 hash28
  của bundle ô, bits34–23 seq (chung, đơn điệu), bits22–11 gen =
  gen assignment hiện hành của slot.
- Payload theo type: **bit 9 = kbKnown, bit 8 = kbActive** (vị trí
  bits 9–8 vốn là pinchMode ở gói state — gói kb định nghĩa lại
  theo type); flag(bit10)/wakeMode/state = 0.
- Gói state cũ và vector harness V1–V10 **không đổi một bit** —
  chứng minh ở mục Cổng bằng chính C core của dự án.
- Phát tại: (i) phiên phím mở/đóng (tức thì, từ handler kbsync);
  (ii) app query (`bwHandleQueryPacket:` phát thêm gói kb cho đúng
  app vừa query, ngoài việc re-emit state như cũ); (iii) vòng renew
  1.0 s — `bwRenewTick:` phát gói kb cho từng ô hosted cùng vòng
  quay với state.
- Log `[kb-sync]`: mỗi thay đổi của ô (change), mỗi lần phát (emit,
  trong poster), mỗi drop (not-assigned) — đều kèm
  `source=host-keyboard-session` ở phía owner; phía host có dòng
  post tương ứng.

## CỔNG

### Build
- OmniCarSplitScreen: `make clean && make` exit 0, dylib ký xong.
- OmniCarAppBridge: `make clean && make` exit 0, dylib ký xong.
- Warning ở các file đã sửa: **0**. Mọi warning còn lại đều pre-existing
  ở file không đụng (SCPHooks/SCPCarSplit/Chrome: nonnull/unused;
  ABHostLaunch.m:41/182/199/316: incomplete-implementation và
  closeAllExcept:nil — code gốc, không phải dòng cộng :261) và
  warning linker `-multiply_defined` cũ.
- Chuỗi mới có trong binary: SplitScreen dylib chứa `[kb-sync]` ×3
  format (emit/change/drop); AppBridge dylib chứa `appbridge.kbsync`
  + `[kb-sync] host post`.

### Grep
- `ahSetSuspended` — lời gọi thật còn đúng: định nghĩa
  AutoHide.m:269 (+ bounce main-thread), `SCPCarSplit.m:2019`
  (YES, vào hosted-solo), `SCPCarSplit.m:2039` (NO, ra solo),
  khai báo AutoHide.h:87. BridgeWake.m: **0 lời gọi** (chỉ còn 1
  lần nhắc trong comment giải thích việc đã gỡ).
- Hạng tử expanded trong `ahFadeBlockedReason`: `grep '"expanded"'`
  trong thân hàm = **0**.
- Phép nâng theo cờ expanded: `grep "BWStateHidden && bwExpandedFlag"`
  = **0**. `bwExpandedFlag` còn lại chỉ ở: statics, setter/getter,
  và hai hàng EXPANDED của arbiter (đúng thiết kế phiên).
- Pinch controller đọc fade/suspend: 0 hit (xem Kiểm 1).

### Vector giải gói (C core BridgeWakePack.h, BW_PACK_NO_FOUNDATION)
Hồi quy: V1 = `0xE9DA706832803859` PASS; V9 = `0xE9DA706800803805`
PASS; V10 = `0xE9DA706801003C05` PASS (đóng gói bằng BWPackFields
rồi so hằng số — state/act không đổi một bit).
Gói kb đóng tay (bundle com.google.ios.youtube, hash28 0xD3B4E0D,
gen=3) → giải ra đúng từng trường:
- known=1 active=1, seq=7 → `0xE9DA706803801B06`: valid=1, seq=7,
  gen=3, bits9-8=3 (known=1, active=1), type=6. ✓
- known=1 active=0, seq=8 → `0xE9DA706804001A06`: bits9-8=2
  (known=1, active=0), type=6. ✓
- known=0 (UNKNOWN) seq=9 → `0xE9DA706804801806`: bits9-8=0,
  type=6 — app đọc known=0 là UNKNOWN, không phải inactive. ✓

### Mirror
10/10 cặp project↔src identical (cmp): BridgeWake.m/.h, AutoHide.m,
SCPShared.h/.m, ABHostGeometry.m, ABChannelNames.m, AppBridgeB.h,
ABHost.h (bản B), ABHostLaunch.m. ABHost.h bản A cộng cùng khai báo
theo văn phong riêng của file A (hai header A/B vốn khác nhau từ
trước, không phải cặp identical).

## Giới hạn / để lại cho vòng sau
- Phía app (ABInApp) chưa tiêu thụ type 6 trong strand này — hợp
  đồng gói ở trên là đầu vào cho strand app-side; Gate 3 vẫn đóng
  cho tới khi có nghiệm thu nuốt trọn chuỗi theo phán quyết GPT.
- Snapshot lúc open chỉ phát khi app (re)open qua ABChanOpen; owner
  mất tiến trình (CarPlayApp respring) giữa một phiên phím đang sống
  mà app không open lại thì ô đó giữ UNKNOWN — đúng hướng an toàn
  GPT đã định (thiếu snapshot = UNKNOWN), không tự suy INACTIVE.
- Kênh state là một word dùng chung: gói kb và gói state xen nhau
  theo (type, hash) như kỷ luật kênh hiện hành; seq chung giữ thứ
  tự đơn điệu cho cả hai loại.
