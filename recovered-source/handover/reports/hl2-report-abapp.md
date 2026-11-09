# HL2-ABAPP — báo cáo strand phía app hosted (ABInApp)

File duy nhất đã sửa: `recovered-source/src/AppBridgeB/ABInApp.m` (baseline main bcf10e6; 2257 → 2750 dòng).
Không sửa `BridgeWakePack.h` (chỉ đọc), không sửa cây `project/`, không git.
Nguồn sự thật đã đọc trước khi sửa: `YTZ5HL1_GATE3_PINCH_RULING_20261109.md` (§1 pinch, §2 ba bất biến, §4 Gate 3, §5 phím),
`YTZ5HL1_LOG_REVIEW_20261109.md` (§4 phím, §5 xung đột Gate3/pinch + lỗ ABKeyWindow nil), source thật của
`ABInApp.m` (BWGatePass, BWHandleTouchEvent, BWBeginSwallow, kbstate reporter, payload drawnKeyboard,
blank inputView, publish panel, ABKeyWindow, snapshot statics) và `SCPPinchController.m` (SplitScreenA, chỉ đọc).

---

## PHẦN 0 — BẢN ĐỒ THAY ĐỔI (hàm → nguyên nhân → điểm sửa → trước/sau → phép kiểm)

### K6 — mặc định phím phía app

| # | Hàm / điểm | Nguyên nhân | Trước | Sau | Phép kiểm |
|---|---|---|---|---|---|
| K6-1 | `ABDrawnKb` (static, ~ABInApp.m:528) | Ruling §5 + log review §4: mặc định phải là DRAWN; bản K5 để absent = native nên phím native không hiện trên xe mà app vẫn câm panel | `static BOOL ABDrawnKb = NO; // native` | `static BOOL ABDrawnKb = YES; // drawn (default)` + static mới `ABDrawnKbGateSeen` | grep binary/source: `ABDrawnKb = YES`; xe: chưa nhận payload nào, mở ô nhập trong app hosted → responder bị blank inputView + panel publish chạy (xem marker K6-4) |
| K6-2 | `ABDrawnKbNoteFrameInfo` (ABInApp.m:533) | Đường flip cũ: field vắng/không phải NSNumber bị ép thành `drawn=NO` → payload orientation không mang field cũng lật app sang native | `BOOL drawn = [v isKindOfClass:NSNumber] ? [v boolValue] : NO;` | Field không phải NSNumber → `return` (giữ cache); chỉ NSNumber tường minh mới nói: `1` = drawn, `0` = native. Native chỉ đạt được bằng `drawnKeyboard=0` tường minh | Đọc hunk; log: payload vắng field không sinh dòng flip nào, cache giữ drawn |
| K6-3 | `ABDrawnKbNoteFrameInfo` — nhánh flip drawn→native | Cơ chế K5 giữ nguyên (chỉ marker restore inputView theo `ABBlankInputViewKey`) | Giữ nguyên từng dòng | Giữ nguyên; dòng log cũ `[ytz5-k5] cong lat native: phuc hoi inputView theo marker` vẫn đúng nghĩa sau thay đổi | grep `[ytz5-k5] cong lat native` còn 1 chỗ, nằm trong nhánh `wasDrawn && !drawn` |
| K6-4 | Marker 3 mắt (bổ sung tối thiểu, mắt nào thiếu mới thêm) | Yêu cầu WO: marker app nhận gate / responder became / publish phải đủ để truy một phiên | (a) gate: chỉ có log khi flip→native; (b) became: không có log `[ytz5-k5]`; (c) publish: đã có log `ban phim xe:` trong `ABKeyboardPublish` nhưng không mang tag `[ytz5-k5]` | (a) lần nhận explicit đầu tiên: `[ytz5-k5] gate nhan drawnKeyboard=%d (explicit, cached=%d)` (ABInApp.m:543) + flip native→drawn: `[ytz5-k5] cong lat drawn: ...` (:566); (b) `ABResponderBecame`: `[ytz5-k5] responder became drawn=%d class=%@` (:2406); (c) `ABKeyboardPublish` sau `notify_post`: `[ytz5-k5] publish shown=%d drawn=1` (:2489) | grep cả 3 chuỗi trong binary; phiên xe đúng phải thấy đủ trình tự gate → became → publish |
| K6-5 | Comment tại `ABSuppressSystemKeyboard` (:2385) và `ABKeyboardPublish` (:2464) | Comment K5 ghi "chỉ drawn khi bridge nói rõ =1" — sai luật mới, để lại sẽ đánh lừa người đọc sau | Comment cũ | Comment sửa: cache DRAWN mặc định, native chỉ sau explicit 0; hành vi code hai hàm này KHÔNG đổi (vẫn gate bằng `ABDrawnKeyboardActive()`) | Đọc hunk — chỉ comment |
| K6-6 | Flip native→drawn giữa phiên | Giới hạn đã biết của K5 (không kích hoạt lại responder đang focus) — WO lệnh giữ nguyên | Không force | Giữ nguyên không force; chỉ thêm log marker K6-4(a). Suppression áp từ become kế tiếp, panel từ publish kế tiếp | Đọc code: không có resign/become nào được thêm |

Không đụng kbstate transport: `BWKbStatePost/Became/ResignedDeferred/Heartbeat` nguyên vẹn.

### W6 — pinch recognizer trong app + relay

| # | Hàm / điểm | Nguyên nhân | Trước | Sau | Phép kiểm |
|---|---|---|---|---|---|
| W6-1 | Class mới `ABPinchGestureRecognizer : UIGestureRecognizer` (ABInApp.m:1050 interface, :1065 implementation) — một TU, không file mới | Ruling §1: chọn recognizer thật trong app hosted; cấm sendEvent-tự-chế, cấm lớp phủ. `SCPPinchRecognizer` phía CarPlayApp không đổi state khỏi Possible + `cancelsTouchesInView=NO` nên không hủy được chạm trong app | Không tồn tại | Subclass với `cancelsTouchesInView=YES, delaysTouchesBegan=NO, delaysTouchesEnded=NO` (init); import `<UIKit/UIGestureRecognizerSubclass.h>` (:28) để set `state` | grep binary: tên class `ABPinchGestureRecognizer`; grep 3 property trong init |
| W6-2 | `ABPinchTryAttach` (:1303) / `ABPinchDetach` (:1316) + điểm gọi | Recognizer chỉ sống trên cửa sổ hosted thật khi assignment sống | Không có | Attach vào `ABKeyWindow()` — đúng cửa sổ `BWGatePass` xác thực — khi `BWKnown` (đã có state packet chấp nhận cho bundle này); thử attach tại `BWOnStatePacket` sau accept (:741) và tại sequence start trong `BWHandleTouchEvent` (:1384); tháo trong `BWResetAll` (:1553). Forward decl :168-169 | Log `[pinch2] attached` / `[pinch2] detached`; detach đi cùng teardown assignment |
| W6-3 | `ABPinchPairDecision` (:983) — arbitration tại pair formation | Bất biến §2 + điều kiện ruling §1, đọc từ snapshot packet mới nhất (`BWKnown/BWFresh 2.5s/BWGen đã qua BWGenAccept/BWPinchAllowed/BWPinchMode/BWState/BWKbEffective`) | Không có (chỉ có probe wouldPinch thụ động) | Block khi: unknown / stale / state ∉ {VISIBLE,HIDDEN} / `!pinchAllowed` (HIDDEN+allowed=0 → reason `split-hidden` = bất biến 1: SPLIT+HIDDEN không bao giờ nhận, kể cả wake fail-open; state khác + allowed=0 → `notallowed`) / kb ACTIVE (reason `kbactive`; kb UNKNOWN **fail-open cho pinch** — khác Gate 3 có chủ đích) / mode OFF. DRY_RUN → cặp dry-run; ENFORCE → cặp enforce. Mọi điều kiện latch tại formation, không convert giữa chừng | Log `[pinch2] blocked gid=… reason=…`; SPLIT+HIDDEN hai ngón → blocked split-hidden, app nhận chạm bình thường |
| W6-4 | `-touchesBegan:` của recognizer | "ĐÚNG 2 touch cùng cửa sổ → Began ngay" | — | Đếm touch có `window == self.view` (cửa sổ hosted); đúng 2 → form pair: `gid = ++BWPinchGidCounter`, latch d0/mid0/committed/stateSeq; ENFORCE → `state = Began` ngay (UIKit tự hủy touches đã giao cho view app nhờ cancels=YES); DRY_RUN → chỉ log `[pinch2] would-fire pair …` không Began/không hủy/không bắn; blocked → cặp chết, log blocked. Ngón thứ 3 → Cancelled (cặp enforce) / chết (cặp possible) | Xe/log: `[pinch2] began gid=` chỉ khi ENFORCE đủ điều kiện; hai-ngón tap thường trên pane ENFORCE bị consume = đánh đổi ruling §1 đã ghi |
| W6-5 | `-touchesMoved:` — ngưỡng + drift | Tái dùng hằng pinch cũ (xem Phần 2) | — | ratio = d/d0; out ≥ 1.10 chỉ khi committed = SPLIT, in ≤ 0.90 chỉ khi committed = EXPANDED (committed suy ra ở W6-3: EXPANDED ⇔ HIDDEN+pinchAllowed); sai hướng → Cancelled/would-fire-suppressed. Drift chưa đạt → tiếp tục Changed, Moved sau còn cơ hội. ENFORCE: mỗi Moved kiểm lại snapshot — điều kiện mất (stale/kb active/committed flip) → `state = Cancelled` + log, reset qua `-reset` | Log `[pinch2] cancelled … reason=` / cặp pan (drift lớn) không bắn lệnh nào |
| W6-6 | `ABPinchRelayFire` (:1024) — relay về host | Ruling §1: IPC scoped mới, kỷ luật kbstate; host là FS owner duy nhất | Không có | NSDistributedNotification, name chính xác `com.anlai.omnicar/bridgewake.v1.pinch`, object = bundle id của chính app; payload keys: `hash` (NSNumber, `BWOwnHash28()`), `gen` (`BWGen` tại lúc bắn), `session` (`BWKbSession()` — mint 1 lần/load như kbstate), `seq` (`BWPinchReportSeq`, monotone riêng theo nguồn, first = 1), `gid`, `dir` (1 = out/expand, 2 = in/restore), `t` (`BWNow()` systemUptime — cùng đồng hồ kbstate reporter). Chỉ bắn 1 lần/gesture (`abFired`), bắn xong `state = Ended`. Không post khi `!BWKnown` (cùng luật kbstate) | grep chuỗi channel + 7 key; log `[pinch2] recognized dir=%ld ratio=%.3f state=%s committed=%@ seq=%llu gid=%lu gen=%lu stateSeq=%lu` đủ truy 1 lệnh |
| W6-7 | `-abTouchesFinished:` / `-reset` | Kết thúc sạch, không bắn khi cặp tan sớm | — | Cặp Began/Changed tan trước khi bắn → log `[pinch2] pair-end … fired=0` + `state = Failed`; cặp Possible (dry-run/blocked) tự clear book tại chỗ (UIKit không gọi reset cho Possible); Ended/Cancelled/Failed → UIKit gọi `-reset` clear book | Không có relay nào sau pair-end |

Cấm tuân thủ: không `delaysTouchesBegan` (một ngón không bị trì hoãn), không tự gọi `touchesCancelled` của app, không phát UIEvent giả, không sendEvent-tự-chế, không lớp phủ, không FS engine mới.

### G6 — cổng wake phía app (`BWGatePass`, ABInApp.m:791 — giữ toàn bộ fail-open hiện hữu)

| # | Điểm | Nguyên nhân | Trước | Sau | Phép kiểm |
|---|---|---|---|---|---|
| G6-i | Vòng kiểm window trong `BWGatePass` (:833-847) | GPT chỉ đích danh (log review §5): `if (key && t.window != key)` — `ABKeyWindow() == nil` thì không touch nào bị loại, cổng qua trống | `if (key && t.window != key) return NO(phone)`; key nil → rơi xuống return YES | `if (!key) { reason = @"nokeywindow"; return NO; }` đặt trước vòng lặp; trong vòng: `if (t.window != key) return NO(phone)` vô điều kiện. Fail-open: chạm vẫn đi qua app, chỉ không nuốt | Probe: phiên không key window → `wouldSwallow=0 failopen=nokeywindow` |
| G6-ii | Sau check `BWState == BWStateHidden`, trước kb guard (:800-818) | Bất biến 3 + ruling §2: EXPANDED + AutoHide HIDDEN — owner cho `pinchAllowed=1` ở EXPANDED bất kể BWState, cổng cũ chỉ nhìn HIDDEN nên nuốt ngón 1 của pinch-in, ngón 2 bị hút vào held chain | Không kiểm pinchAllowed/pinchMode | `if (BWPinchAllowed && BWPinchMode == BWModeEnforce) { reason = @"pinchin"; log [gate3] …; return NO; }`. **Lập luận chỉ-EXPANDED:** owner `bwPinchAllowedForPane:` (SCPCarSplit+BridgeWake.m) cấp pinchAllowed ở SPLIT **chỉ khi VISIBLE**, ở EXPANDED **bất kể BWState** → snapshot HIDDEN mà allowed=1 không thể là SPLIT (SPLIT+HIDDEN luôn allowed=0 và vẫn bị nuốt bình thường); bắt thêm ENFORCE để DRY_RUN/OFF không bao giờ vô hiệu hóa wake | Probe EXPANDED+HIDDEN: `wouldSwallow=0 failopen=pinchin` + dòng `[gate3] bw gate yield pinch-in: state=H pinchAllowed=1 pinchMode=enforce stateSeq=%lu`; SPLIT+HIDDEN (allowed=0) vẫn `wouldSwallow=1` |
| G6-iii | `BWOnStatePacket` (:723-724), statics mới (:138-144, :231-233), latch tại `BWHandleTouchEvent` (:1354-1358), dòng log trong `BWCloseSequence` (:910-921) | Truy ca seq=45: HIDDEN+fresh mà would=0 đúng nhịp reveal — cần biết quyết định dùng snapshot nào, snapshot bao nhiêu tuổi, state đã lật bao nhiêu lần | Probe chỉ có `state=<letter>` của lúc start; seq của state packet bị bỏ đi khi unpack; không có flip counter | Static `BWStateSeq` = `p.seq` của state packet chấp nhận mới nhất; static `BWStateFlipCount` tăng trong `BWOnStatePacket` mỗi lần `st != BWState` (gồm snapshot đầu khác Unknown); cả hai reset trong `BWResetAll` (đầu phiên hosted mới = 0). Tại sequence start latch `BWSeqStateSeqAtStart / BWSeqStateAgeAtStart` (ms từ `BWStateRxAt`, −1 nếu chưa known) ` / BWSeqStateFlipsAtStart`; dòng probe thêm `stateSeq=%lu stateAgeMs=%ld stateFlips=%lu`. **Không sửa cơ chế nuốt vì ca này** (đúng WO) | grep `stateSeq=`/`stateAgeMs=`/`stateFlips=` trong dòng `[do] bw probe`; ca reveal: stateAgeMs nhỏ + stateFlips vừa tăng = quyết định dùng snapshot ngay sau lật state (gate có chặn riêng bằng `BWStateChangedAt < 0.25s` sẵn có) |

Giữ nguyên: mặc định wake toàn cục vẫn DRY_RUN (app chỉ nuốt khi packet nói Enforce — cơ chế sẵn có ở caller `BWHandleTouchEvent`), mọi fail-open cũ (unknown/stale/kb/kbunknown/mixed/transient/notarget/phone/mode), không `@available`, phong cách log giữ nguyên.

---

## PHẦN 1 — TÓM TẮT HUNK (file:dòng, theo file sau sửa)

- `ABInApp.m:28` — thêm `#import <UIKit/UIGestureRecognizerSubclass.h>`.
- `ABInApp.m:138-144` — statics `BWStateSeq`, `BWStateFlipCount` [hl2-g6].
- `ABInApp.m:163-169` — forward decl `ABPinchTryAttach/ABPinchDetach` [hl2-w6].
- `ABInApp.m:231-233` — statics latch probe `BWSeqStateSeqAtStart/AgeAtStart/FlipsAtStart` [hl2-g6].
- `ABInApp.m:510-571` — khối K5 gate viết lại luật HL2-K6: `ABDrawnKb = YES` (:528), `ABDrawnKbGateSeen` (:529), `ABDrawnKbNoteFrameInfo` chỉ nhận explicit NSNumber (:533-571), marker gate + marker flip drawn (:543, :566); nhánh restore→native giữ nguyên.
- `ABInApp.m:710-742` — `BWOnStatePacket`: ghi `BWStateSeq = p.seq` (:724), `BWStateFlipCount++` khi đổi state (:723), gọi `ABPinchTryAttach()` sau accept (:741).
- `ABInApp.m:791-855` — `BWGatePass`: arbitration pinch-in [gate3] (:800-818), sửa lỗ key-window nil (:833-847).
- `ABInApp.m:894-924` — `BWCloseSequence`: dòng probe thêm `stateSeq/stateAgeMs/stateFlips` (:910-921).
- `ABInApp.m:940-1323` — section [hl2-w6] mới: channel + counters (:966-970), `ABPinchPairDecision` (:983), `ABPinchRelayFire` (:1024), `ABPinchGestureRecognizer` interface/implementation (:1050/:1065 — init :1067, touchesBegan :1103, touchesMoved :1176, abTouchesFinished :1259, reset :1285), `ABPinchTryAttach` (:1303), `ABPinchDetach` (:1316).
- `ABInApp.m:1354-1358` — `BWHandleTouchEvent`: latch provenance snapshot tại sequence start; `:1384` gọi `ABPinchTryAttach()`.
- `ABInApp.m:1514-1554` — `BWResetAll`: reset `BWStateSeq/BWStateFlipCount` (:1550-1551), gọi `ABPinchDetach()` (:1553).
- `ABInApp.m:2383-2398` — `ABSuppressSystemKeyboard`: chỉ sửa comment luật gate.
- `ABInApp.m:2399-2416` — `ABResponderBecame`: marker `[ytz5-k5] responder became …` (:2406).
- `ABInApp.m:2463-2496` — `ABKeyboardPublish`: sửa comment luật gate + marker `[ytz5-k5] publish shown=%d drawn=1` sau notify_post (:2489).

Kiểm tĩnh đã chạy: cân bằng ngoặc `{}`/`()`/`[]` toàn file sau khi strip comment/string = khớp; không có `@available`; mọi chuỗi discriminator dưới đây grep thấy trong source.

## PHẦN 2 — DISCRIMINATOR (grep binary/source) + HẰNG TÁI DÙNG

Discriminator:
- Class: `ABPinchGestureRecognizer`
- Channel: `com.anlai.omnicar/bridgewake.v1.pinch`
- Log W6: `[pinch2]` — kèm `recognized dir=`, `would-fire`, `began gid=`, `blocked gid=`, `cancelled gid=`, `attached`, `detached`
- Log G6-ii: `[gate3] bw gate yield pinch-in:` + reason probe `failopen=pinchin`
- Log G6-i: reason probe `failopen=nokeywindow`
- Log G6-iii: trường probe `stateSeq=`, `stateAgeMs=`, `stateFlips=`
- Log K6: `[ytz5-k5] gate nhan drawnKeyboard=`, `[ytz5-k5] cong lat drawn:`, `[ytz5-k5] responder became drawn=`, `[ytz5-k5] publish shown=` (và dòng cũ `[ytz5-k5] cong lat native:` giữ nguyên)
- Comment tag trong source: `[hl2-k6]`, `[hl2-w6]`, `[hl2-g6]`

Hằng ngưỡng tái dùng từ pinch cũ — nguồn `src/SplitScreenA/SCPPinchController.m`, `-[SCPPinchRecognizer touchesMoved:withEvent:]`:
- out cross `scale >= 1.10` — SCPPinchController.m:256
- in cross `scale <= 0.90` — SCPPinchController.m:257
- mid-drift `drift <= 0.6 * distChange + 10.0` với `distChange = fabs(dist - dist0)` — SCPPinchController.m:246-258 (điều kiện tại :258)
- cặp suy biến `dist0 <= 0.01` không có scale — SCPPinchController.m:~243 (kiểm trong touchesMoved của SCP; bản này áp tại formation cho ENFORCE và tại Moved)
- d0/mid0 lấy tại thời điểm ngón 2 chạm xuống từ vị trí hiện tại của cả hai ngón — cùng luật `scpFormPair` của SCP

## PHẦN 3 — RỦI RO MỞ

1. **EXPANDED+VISIBLE không phân biệt được với SPLIT+VISIBLE phía app** (packet không có bit expanded — BridgeWakePack.h chỉ có flag pinchAllowed + pinchMode + state). Hệ quả: pinch-in khi EXPANDED mà controls đang VISIBLE bị cổng hướng phía app chặn như wrong-dir (không bắn); pinch-out ở ca đó nếu vượt ngưỡng sẽ bắn expand thừa và phải nhờ host FS gate loại. Ca tranh chấp chính EXPANDED+HIDDEN đã được xử đúng cả ở G6-ii lẫn W6. Muốn hết hẳn cần host cấp thêm quan hệ EXPANDED tường minh trong packet — việc của strand host/header, ABAPP không tự sửa header (đã ghi nhận tại comment `ABPinchPairDecision`).
2. **Strand host phải có receiver cho `bridgewake.v1.pinch`** (validate hash/gen/session/seq/gid, dedup 1 lệnh/gesture, gọi SCPFullscreenAdapter) — phía app chỉ phát; nếu host chưa nhận, log `[pinch2] recognized` xuất hiện mà FS không chạy. Payload đã đủ trường để host validate chéo.
3. **Attach phụ thuộc `ABKeyWindow()`** — cùng điểm mù với wake gate: nếu key window lúc packet tới chưa phải cửa sổ hosted (đa scene), recognizer có thể gắn nhầm cửa sổ key đầu tiên; retry tại sequence start giảm rủi ro nhưng không xóa hẳn. Log `[pinch2] attached window=%p` là điểm đối chiếu khi test xe.
4. **Đánh đổi ruling §1**: Began ngay khi đủ điều kiện sẽ hủy mọi cử chỉ hai ngón khác (tap/pan hai ngón) trên pane ENFORCE — đã được ruling chấp nhận, cần Nguyen xác nhận trên xe.
5. **Freshness 2.5s trong lúc pinch dài**: Moved kiểm lại snapshot mỗi lần; state renew của owner (~1-2s/pane) bình thường giữ fresh, nhưng nếu owner ngừng renew giữa cử chỉ, cặp bị Cancelled thay vì bắn — fail-safe có chủ đích, sẽ thấy qua `[pinch2] cancelled reason=stale`.
6. **K6 phía host là điều kiện cần**: app chỉ về native khi nhận explicit `drawnKeyboard=0`; nếu strand host vẫn giữ absent→native ở phía nó và không stamp field, app nay giữ DRAWN — đúng phán quyết §5 (DRAWN là mặc định bản hồi phục), nhưng hai phía phải khớp nhau ở bản tích hợp.
7. Chưa build/ký ở strand này (theo phân công); kiểm chứng dừng ở đọc-lại hunk + cân bằng cú pháp tĩnh. Cần bản tích hợp build + 1 phiên xe gộp (Gate 3 ba mắt, pinch hai chiều, phím drawn) mới kết luận DEVICE.
