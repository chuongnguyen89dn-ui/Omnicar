# HL2-VERIFY — Kiểm tĩnh độc lập (chỉ đọc)

- Cây kiểm: `~/workspace/push9-clone/recovered-source/src/`
- Baseline: HEAD `bcf10e665d3089f6e034a44253ff7fcbf3fbb161` (bcf10e6)
- Phương pháp: `git diff HEAD -- recovered-source/src`, `git show HEAD:<path>`, grep trên working tree. Không sửa file, không build, không commit.
- Diff tổng: 6 file, +862/−32. Cả 3 sửa thẳng của coordinator trong ABInApp.m (khối kb của `ABPinchPairDecision`, comment/`t` epoch trong `ABPinchRelayFire`) nằm trong diff và được tính là thay đổi hợp lệ của vòng.
- File ngoài phạm vi: `recovered-source/handover/THAM_VAN_DUOFACE_LOGO_YOUTUBE_ZOOM.md` (untracked, không thuộc diff src — không kiểm).

## Bảng kết luận

| # | Mục | Kết luận |
|---|-----|----------|
| 1 | Parity method (6 file) | **PASS** — không mất method nào |
| 2 | Discriminator trong source | **FAIL (hẹp)** — 10/12 chuỗi có mặt nguyên văn; 2 chuỗi `failopen=pinchin` / `failopen=nokeywindow` KHÔNG có nguyên văn trong source (chỉ được ghép lúc runtime — xem chi tiết) |
| 3a | Wake toàn cục vẫn DRY_RUN, Enforce chỉ qua packet pane trial | **PASS** (kèm lưu ý: trial mặc định BẬT cho bundle mặc định) |
| 3b | kbstate không đổi handler/transport (owner) + reporter (app) ngoài K6 | **PASS** |
| 3c | Pinch một chủ bắn — hai nguồn pref tách nhau | **PASS** |
| 3d | Picker: hasContent + đường clear placeholder không đổi | **PASS** |
| 3e | Không `@available` trong dòng thêm | **PASS** |
| 4 | Nhất quán giao tiếp pinch (kênh/keys/đồng hồ/TTL/kb) | **PASS** |
| 5 | `git diff --check` | **PASS** — sạch, exit 0 |

---

## 1. PARITY METHOD — PASS

Cách trích: dòng bắt đầu bằng `- (` / `+ (` ở cột 0 hoặc sau khoảng trắng (đếm theo từng dòng chữ ký đầu), đối chiếu HEAD ↔ working bằng Counter. Bổ sung cho 2 file không dùng ObjC-method làm bề mặt chính (ABHostGeometry, ABInApp dùng C function/hook kiểu MSHook): đếm thêm C-function definition.

| File | HEAD | Working | Mất | Thêm |
|------|------|---------|-----|------|
| ABHostBMethods.m | 43 | 43 | — | — |
| ABHostGeometry.m | 0 ObjC / 28 C-func | 0 ObjC / 28 C-func | — | — |
| ABInApp.m | 0 ObjC / 119 C-func* | 9 ObjC / 125 C-func* | — | xem dưới |
| SCPCarSplit+BridgeWake.m | 32 | 34 | — | `bwHandlePinchNote:` (1 method: 1 dòng khai báo + 1 dòng định nghĩa) |
| SCPFullscreenController.m | 23 | 23 | — | — |
| SCPCarSplit+Picker.m | 34 | 34 | — | — (chỉ thêm static C helper, không phải ObjC method) |

\* Đếm C-func tính cả forward-declaration + definition nên có trùng tên; so Counter vẫn cho lost = ∅ ở mọi file.

### Method/function THÊM (toàn bộ)

ABInApp.m — class mới `ABPinchGestureRecognizer` (9 ObjC method, working line):
- `- (instancetype)init` :1080
- `- (void)abClearPair` :1095
- `- (double)abDistance:(CGPoint *)midOut` :1109
- `- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event` :1118
- `- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event` :1189
- `- (void)abTouchesFinished:(NSSet<UITouch *> *)touches cancelled:(BOOL)cancelled` :1271
- `- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event` :1291
- `- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event` :1295
- `- (void)reset` :1299

ABInApp.m — C function mới (duy nhất theo tên): `ABPinchTryAttach`, `ABPinchDetach`, `ABPinchPairDecision`, `ABPinchRelayFire` (mỗi hàm có forward-decl/định nghĩa nên bộ đếm thô ghi nhận 6 entry thêm: TryAttach ×2, Detach ×2, PairDecision ×1, RelayFire ×1).

SCPCarSplit+BridgeWake.m:
- `- (void)bwHandlePinchNote:(NSNotification *)note;` — khai báo trong interface BridgeWakePrivate (diff @@ -30)
- `- (void)bwHandlePinchNote:(NSNotification *)note {` — định nghĩa (working :545)
- C helper mới (không phải ObjC method): `static void BWEmitModesForBundle(...)` :210

SCPCarSplit+Picker.m:
- C helper mới: `static NSString *SCPViewMeasureDesc(UIView *view)` :95

### Method MẤT: **không có ở bất kỳ file nào.** PASS.

Ghi chú: ở Picker, tổng số occurrence `- (`/`+ (` thô là 35 ở cả hai bản — occurrence thứ 35 là dấu trừ số học `CGRectGetMidX(area) - (sheetW + 150.0) * 0.5` (HEAD :433 / working :475), không phải method; đếm chữ ký ở đầu dòng cho 34 = 34.

---

## 2. DISCRIMINATOR — FAIL (hẹp: 2/12 chuỗi không có nguyên văn)

Grep trên `recovered-source/src` (`.m` + `.h`):

| Chuỗi | Kết quả | Bằng chứng |
|-------|---------|-----------|
| `appBridgeNativeKeyboardDrawnRestoredHl2` | ✅ 3 | ABHostBMethods.m:93 (đọc marker), :99 (log migration), :102 (ghi marker qua CFPreferences) |
| `[pinch2]` | ✅ 17 | ABInApp.m:1055, 1133, 1160, 1169, 1176, 1183, 1201, 1235, 1241, 1258, 1278, 1325, 1332; SCPCarSplit+BridgeWake.m:558, 603, 614, 620 |
| `[gate3]` | ✅ 4 | ABInApp.m:813; SCPCarSplit+BridgeWake.m:372 (comment), :380, :978 |
| `[picker-measure]` | ✅ 2 | SCPCarSplit+Picker.m:92 (comment), :212 (dòng log thật) |
| `trayOverlay=%d` | ✅ 1 | SCPFullscreenController.m:311 |
| `ABPinchGestureRecognizer` | ✅ 5 | ABInApp.m:28 (import comment), :1063 (@interface), :1078 (@implementation), :1314, :1320 |
| `com.anlai.omnicar/bridgewake.v1.pinch` | ✅ 3 | ABInApp.m:950 (comment), :966 (BWPinchChannel); SCPCarSplit+BridgeWake.m:138 (BWPinchNoteName) |
| `failopen=pinchin` | ❌ **0 — vắng nguyên văn** | xem dưới |
| `failopen=nokeywindow` | ❌ **0 — vắng nguyên văn** | xem dưới |
| `stateFlips=` | ✅ 1 | ABInApp.m:910 (`stateFlips=%lu` trong format probe) |
| `bridgewake.gate3TrialBundle` | ✅ 2 | SCPCarSplit+BridgeWake.m:958 (comment), :965 (đọc pref) |
| `bridgewake.pinchInApp` | ✅ 4 | SCPCarSplit+BridgeWake.m:58, :206 (comment), :962 (comment), :973 (đọc pref) |

### Hai chuỗi failopen — lệch hình thức, không lệch hành vi

Trong source, format là tách rời:
- ABInApp.m:911 — `"wouldSwallow=%d wouldPinch=%d failopen=%@"`, đối số `BWSeqFailOpen ? BWSeqFailOpen : @"-"` (:923).
- ABInApp.m:811 — `BWGatePass`: `*reason = @"pinchin"` (nhánh HIDDEN + pinchAllowed + pinchMode ENFORCE).
- ABInApp.m:840 — `BWGatePass`: `*reason = @"nokeywindow"` (nhánh `!key`).
- `BWSeqFailOpen = reason` được latch tại `BWHandleTouchEvent` (diff @@ -910: `BWSeqFailOpen = reason;` — dòng ngữ cảnh, không đổi).

Hệ quả: **dòng log runtime sẽ in đúng `failopen=pinchin` / `failopen=nokeywindow`** khi hai nhánh đó chạy, nhưng grep chuỗi liền trên source thì không thấy. Theo đúng tiêu chí đề bài ("grep từng chuỗi" trong source) → 2 mục này FAIL; coordinator quyết định chấp nhận dạng ghép-runtime hay yêu cầu đổi format thành literal.

### `to=%d` trong snap của SCPFullscreenController

- Trong `recovered-source/src/SplitScreenA/SCPFullscreenController.m`: **vắng** — format mới ở :311 là `snap{tw=%d twh=%@ trayOverlay=%d tray=%d picker=%d ratio=%d dg=%d ...`. ✅ đúng yêu cầu.
- Toàn `recovered-source/src`: không còn occurrence nào của `to=%d`.
- Ngoài phạm vi src (ghi rõ theo đề bài, không tự kết luận FAIL cho mục này): vẫn còn ở bản sao project `recovered-source/project/OmniCarSplitScreen/SCPFullscreenController.m:302` và trong tài liệu cũ `recovered-source/handover/reports/integration-ytz3.md:135`. Cả hai đều không nằm trong diff của vòng hl2.

---

## 3. BẤT BIẾN GATE

### 3a. Wake toàn cục DRY_RUN; Enforce chỉ qua packet pane trial — PASS

Phía owner (SCPCarSplit+BridgeWake.m):
- :52 — `static NSInteger bwWakeMode = BWModeDryRun; // §4: absent = DRY_RUN` (không đổi).
- :929 (trong `bwReloadModesAndRepublish`) — `bwWakeMode = w ? MIN(MAX([w integerValue], 0), 2) : BWModeDryRun;` với `w = OMCPref(@"bridgewake.wakeMode", nil)` :907 (không đổi trong diff). Absent → DRY_RUN, không thành Enforce.
- Điểm ghi `bwWakeMode` duy nhất là :929. Mọi đường phát packet thường dùng `bwWakeMode` nguyên trạng (vd teardown :881–882, không đổi).
- Đường Enforce duy nhất cho wakeMode packet: helper mới `BWEmitModesForBundle` :210–217 — `*wmOut = trial ? BWModeEnforce : bwWakeMode;` :214, trong đó `trial = bwGate3TrialEnabled && bwGate3TrialBundle.length > 0 && [bundle isEqualToString:bwGate3TrialBundle]` :212–213. Helper được dùng ở cả hai điểm phát: `bwEmitStateForPane:` (:365) và phép tính emission-signature ở `bwRecomputeForPane:` (:849) — nhất quán, không có đường Enforce nào khác.

Phía app (ABInApp.m):
- App không đọc pref wake nào: grep `OMCPref`/`CFPreferences` trong ABInApp.m chỉ trúng 1 dòng comment (:513, "This side NEVER reads CFPreferences for the gate").
- :133 — `static NSInteger BWWakeMode = BWModeDryRun;` (không đổi); `BWResetAll` đặt lại `BWWakeMode = BWModeDryRun` (không đổi); giá trị chỉ bị ghi đè bởi `BWOnStatePacket` từ packet (`BWWakeMode = BWNormMode(p.wakeMode)`).
- `BWEffectiveWakeMode` (:270–272): fresh → `BWWakeMode`, stale → OFF. Không có mặc định Enforce phía app.

**Lưu ý coordinator (không phải FAIL theo tiêu chí, nhưng là sự thật của source):** scope trial tự nó mặc định BẬT — `bwReloadModesAndRepublish` :958–976: pref `bridgewake.gate3TrialBundle` absent/malformed → `bwGate3TrialBundle = @"com.google.ios.youtube"` (:970); pref kill-switch `bridgewake.gate3Trial` absent → `bwGate3TrialEnabled = YES`. Tức khi không đặt pref nào, pane YouTube vẫn nhận packet wakeMode=ENFORCE trong khi mọi pane khác giữ DRY_RUN toàn cục. Đúng mô hình "Enforce chỉ qua packet của pane trial", nhưng "trial" không phải opt-in bằng pref bundle.

### 3b. kbstate — PASS

Phía owner (SCPCarSplit+BridgeWake.m):
- Handler `bwHandleKbStateNote:` (định nghĩa :479) — **không có hunk nào chạm thân hàm**. Kênh `BWKbStateNoteName = @"com.anlai.omnicar/bridgewake.v1.kbstate"` :128–129 — không đổi. Khối đăng ký observer kbstate (:1239–1243) — không đổi (chỉ xuất hiện làm ngữ cảnh).
- Các điểm diff *kề* kbstate, đều không đổi hành vi kbstate:
  1. Thêm khai báo `bwHandlePinchNote:` ngay dưới khai báo `bwHandleKbStateNote:` trong interface private (diff @@ -30) — thêm method mới, không sửa khai báo/handler kbstate.
  2. Thêm hằng `BWPinchNoteName` + bookkeeping pinch ngay sau `BWKbStateNoteName` (diff @@ -116) — hằng kbstate giữ nguyên.
  3. Thêm khối đăng ký observer cho `BWPinchNoteName` ngay sau khối kbstate trong hàm cài đặt (diff @@ -1035) — observer kbstate cũ giữ nguyên từng dòng.
  4. Thân `bwHandlePinchNote:` mới *tham chiếu* kỷ luật kbstate trong comment và đọc `bwInputStore.slots[slot].session` (chỉ đọc) để đối chiếu session — không ghi, không sửa store/handler kbstate.

Phía app (ABInApp.m):
- Reporter kbstate thật — `BWKbStatePost` :619, `BWKbStateBecame` :642, `BWKbStateResignedDeferred` :654, heartbeat/renewal quanh :672–675 — **không hunk nào chạm**; kênh/định dạng gói kbstate giữ nguyên. `BWKbEffective` (:486–510) cũng không đổi thân (hunk gần nhất nằm ở section drawn-keyboard phía dưới nó).
- Các điểm diff chạm vùng kb/kb-adjacent phía app — tất cả đều là điểm K6 đã khai hoặc log/marker, không đổi hành vi reporter kbstate:
  1. Section gate cache K6: `ABDrawnKb` mặc định `NO → YES` (:528), `ABDrawnKbNoteFrameInfo` đổi luật (chỉ NSNumber tường minh mới nói; absent/mistyped giữ cache) + marker log "gate nhan" — đây là cache `drawnKeyboard` từ frame-info, không phải kênh kbstate.
  2. `ABSuppressSystemKeyboard`: chỉ sửa comment (thân giữ nguyên điều kiện `!ABDrawnKeyboardActive()`).
  3. `ABResponderBecame`: thêm 1 dòng log marker K6 trước lời gọi cũ; `BWKbStateBecame()` / `BWKbLocalSet(...)` giữ nguyên.
  4. `ABKeyboardPublish` (kênh panel `appbridge.keyboard`, khác kênh kbstate): chỉ sửa comment + thêm 1 dòng log marker sau `notify_post` — payload/điều kiện phát giữ nguyên.
  5. Code pinch mới chỉ *đọc* `BWKbEffective(...)` và *dùng lại* `BWKbSession()` / `BWOwnHash28()` để đóng gói payload pinch — không sửa các hàm đó.

### 3c. Pinch một chủ bắn — hai nguồn pref tách nhau — PASS

- Đường legacy (CarPlayApp recognizer qua arbiter): `bwPinchMode` đọc từ pref `bridgewake.pinchMode` — :908 `id p = OMCPref(@"bridgewake.pinchMode", nil);`, :930 `bwPinchMode = p ? MIN(MAX([p integerValue], 0), 2) : BWModeOff;` (absent = OFF), kèm migration một lần :915–929 (marker `bridgewake.pinchOffMigratedYtz5`: stored ≠ 0 → ghi 0). Arbiter đọc qua accessor :1274–1275 (`bwPinchMode` → `SCPPinchMode`). Các dòng này **không đổi** trong diff.
- Đường mới (in-app): biến riêng `bwPinchInAppMode` (:64, init `BWModeEnforce`), đọc từ pref riêng `bridgewake.pinchInApp` :973–976 — absent = ENFORCE, 0 = OFF, 1 = DRY_RUN, khác = ENFORCE. Nó **chỉ** chảy vào packet pinchMode qua `BWEmitModesForBundle` (`*pmOut = bwPinchInAppMode` :215); comment :964–965 trong diff ghi rõ "the legacy bwPinchMode above is untouched" và code khớp: không có phép gán nào giữa hai biến, không dùng chung pref key.
- Phía app: `BWPinchMode` của app lấy từ packet (`BWOnStatePacket`), tức đối với pane hosted nó phản ánh nguồn pinchInApp do owner đóng gói; recognizer legacy nằm ở process CarPlayApp và đọc `bwPinchMode` — hai chủ bắn không dùng chung một biến/pref. PASS.

### 3d. Picker — PASS

Trong SCPCarSplit+Picker.m, diff chỉ có đúng 2 hunk:
1. Thêm static helper `SCPViewMeasureDesc` :91–107 (chỉ đọc thuộc tính view để mô tả).
2. Trong `showPickerForSlot:`: thêm comment + **một** dòng log `[picker-measure]` :198–223, chèn *sau* phép gán `picker.backgroundColor` và *trước* `picker.autoresizingMask`.

Không đổi, có bằng chứng dòng (working tree):
- Định nghĩa `BOOL hasContent = (pane.vc != nil || [self slotOccupied:pane.slot]);` :180 — dòng ngữ cảnh trong diff, không có dấu +/−.
- Đường clear của placeholder: `picker.backgroundColor = hasContent ? [UIColor clearColor] : [UIColor colorWithRed:0.933... alpha:1.0]` :192–197 — không đổi; log cũ `[picker] hasContent=%d` :191 giữ nguyên.
- Không hunk nào chạm `removePickerFromPane:`, `markPickerPanes` (đường clear border của placeholder), `addCoverToPane:`/`removeCoverFromPane:`.

### 3e. `@available` trong dòng thêm — PASS

`git diff HEAD | grep '^+' | grep '@available'` → không kết quả.

---

## 4. NHẤT QUÁN GIAO TIẾP PINCH — PASS

Đối chiếu `ABPinchRelayFire` (ABInApp.m, định nghĩa :1037) ↔ `bwHandlePinchNote:` (SCPCarSplit+BridgeWake.m, định nghĩa :545):

| Khía cạnh | Phía app | Phía owner | Khớp |
|-----------|----------|------------|------|
| Tên kênh | `BWPinchChannel = @"com.anlai.omnicar/bridgewake.v1.pinch"` ABInApp.m:966; post qua NSDistributedNotificationCenter, object = bundleIdentifier | `BWPinchNoteName = @"com.anlai.omnicar/bridgewake.v1.pinch"` BridgeWake.m:137–138; đăng ký observer :1249–1254 | ✅ từng byte |
| Keys payload | dict :1041–1048: `hash, gen, session, seq, gid, dir, t` (đúng 7 key) | đọc :549–556 `hash/gen/session/seq/gid/dir` + :566–568 `t` (đúng 7 key, không key lạ hai phía) | ✅ |
| Đồng hồ của `t` | `@([[NSDate date] timeIntervalSince1970])` ABInApp.m:1048 — epoch giây tường. Comment :1025–1038 ghi rõ đây là sửa thẳng của coordinator: app `BWNow()` nội bộ là `systemUptime` (:239–240) và **không** được dùng cho `t` | `BWNow()` = `[NSDate date].timeIntervalSince1970` BridgeWake.m:174 | ✅ cùng epoch |
| TTL owner | — | BridgeWake.m:569 — `if (t <= 0 \|\| fabs(now - t) > 1.0) { reject("stale"); }` → cửa sổ ±1.0 s (1000 ms), khớp comment thiết kế :541–542 | ✅ |
| Điều kiện kb phía app | `ABPinchPairDecision` ABInApp.m:1008–1014: `kbEffPinch == BWKbActive` → Block (`kbactive`); `kbEffPinch != BWKbInactive` (tức UNKNOWN) → Block (`kbunknown`); chỉ `BWKbInactive` mới đi tiếp tới kiểm mode | — | ✅ ACTIVE và UNKNOWN đều Block, chỉ INACTIVE qua |

Kiểm thêm trong cùng hàm (không lệch): `ABPinchPairDecision` còn block khi `!BWKnown` / `!BWFresh()` / state ngoài {Visible, Hidden} / `!BWPinchAllowed`; owner kiểm độc lập badhash/badgen/badsession/dup/staleseq/badstate trước khi gọi adapter — hai tầng không mâu thuẫn.

---

## 5. `git diff --check` — PASS

`git diff --check HEAD -- recovered-source/src` → không output, exit code 0. Sạch (không trailing whitespace / conflict marker / lỗi khoảng trắng) trên toàn bộ diff 6 file.

---

## Tổng kết cho coordinator

- **PASS:** 1, 3a, 3b, 3c, 3d, 3e, 4, 5.
- **FAIL duy nhất (mục 2, hẹp):** hai chuỗi `failopen=pinchin` và `failopen=nokeywindow` không tồn tại nguyên văn trong source — chúng là kết quả ghép runtime của format `failopen=%@` (ABInApp.m:911) với reason `@"pinchin"` (:811) / `@"nokeywindow"` (:840). Log thực tế trên xe sẽ in đúng hai chuỗi đó; nếu tiêu chí nghiệm thu là grep source thì cần sửa format, nếu là grep log thì đã đạt.
- **Lưu ý (không FAIL):** (i) trial Gate 3 mặc định bật cho `com.google.ios.youtube` khi không có pref nào (BridgeWake.m:970 + kill-switch absent = YES) — Enforce vẫn chỉ qua packet pane trial, global vẫn DRY_RUN; (ii) `to=%d` còn sót ở bản sao ngoài src: `recovered-source/project/OmniCarSplitScreen/SCPFullscreenController.m:302` và `recovered-source/handover/reports/integration-ytz3.md:135`.
- Method mất: **0**. Method/function thêm: 9 ObjC method (ABPinchGestureRecognizer) + 1 ObjC method (bwHandlePinchNote:) + 4 C function pinch phía app + 2 C helper (BWEmitModesForBundle, SCPViewMeasureDesc).
