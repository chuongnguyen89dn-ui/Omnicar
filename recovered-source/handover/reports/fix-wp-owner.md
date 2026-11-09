# fix-wp-owner — sửa phía OWNER theo WO GPT sau fs1 (W1 log act + W2 renewal + P1 arbiter phiên + P4 default)

Ngày: 2026-11-09. Nguồn lệnh: "OMNICAR — WORK ORDER KHẮC PHỤC TỔNG HỢP SAU FS1" (GPT audit đối chiếu source), các mục W1/W2 (phần owner), P1, P4.
Phạm vi file của strand: `SCPCarSplit+BridgeWake.m/.h`, `SCPCarSplit+AutoHide.m` (module OmniCarSplitScreen, cả hai cây project/ + src/SplitScreenA). Không đụng SCPFullscreenController.m, SCPCarSplit.m, SCPHooks.m, ABInApp.m.
Mức đạt: **source complete / build PASS / static PASS** — chưa có bằng chứng xe.

## 1. W1 — bwHandleActPacket: mọi điểm loại đều có reason riêng

`bwHandleActPacket:` (BridgeWake.m) viết lại toàn bộ: trước đây 5 điểm loại đều `return` câm. Nay mỗi điểm log một dòng `[autohide]` với reason riêng, theo đúng thứ tự kiểm của WO W2 phía owner:

| Điểm loại | reason | Điều kiện |
|---|---|---|
| gói không hợp lệ / sai type | `decode-fail` | `!pkt.valid \|\| pkt.type != BWTypeAct` (log kèm raw/valid/type) |
| hash không khớp bundle nào đang giữ | `bad-hash` | `BWSlotForHash28 < 0` |
| gen cũ (trước reconnect/reassign) | `bad-gen` | `pkt.gen != bwGenBySlot[slot]` (log gen + gen hiện tại) |
| phiên split không active | `session-inactive` | `!self.active` |
| pane không còn assignment/hosted | `not-assigned` | pane nil / lệch slot / không thuộc `hostedPanes` |
| slot ở trạng thái INACTIVE dù pane còn đó | `split-inactive` | `bwStateBySlot[slot] == BWStateInactive` (cửa guard cho cửa sổ chưa kịp aggregate) |

Khi chấp nhận: log `[autohide] act-accepted bundle=… kb=%d seq=%u -> ahNoteActivity` rồi mới gọi `ahNoteActWithKbActive:` (đường vào `ahNoteActivity:` — điểm 6 trong checklist W1 của WO được trả lời ngay trên cùng dòng log). Kiểm tương đương hành vi: điểm `session-inactive` trước đây lọt qua owner nhưng chết ở guard `!self.active` trong `ahNoteActivity:` — nay loại sớm hơn kèm reason, kết quả cuối như nhau, chỉ có thêm bằng chứng.

Phía AutoHide: `ahRevealBody:` (AutoHide.m) đổi log `reveal reason=%s` thành **`reveal-applied reason=%s views=%lu`** — `views` = số view phía CarPlay còn giữ bản lưu opacity tại thời điểm reveal (đếm TRƯỚC khi khôi phục, qua associated object của chính TU này). Điểm nối gương host: `ahRevealBody:` vẫn gọi `pushHostFramesLive:NO` ngay sau khôi phục — đó là tay trao có sẵn để host nhận `fade=NO` qua khoá `fade` của hostFrameInfo; việc áp lên gương thuộc strand host/kênh frame, strand này chỉ ghi nhận điểm nối tồn tại, không sửa.

## 2. W2 — State renewal phía owner (1,0 s, luân phiên theo pane)

Thêm vào BridgeWake.m (mục `#pragma mark - State renewal (WO W2)`):

- `bwRenewTimer` (file static) + hai method riêng `bwRenewMaintain` / `bwRenewTick:` (khai trong interface private đầu file, đúng khuôn AutoHidePrivate).
- **Chu kỳ 1,0 s** (< 2,5 s freshness). Mỗi tick: với MỖI pane hosted, `bwQueueEmitForPane:` — gói đi qua emit queue giãn 30 ms như mọi emission khác, nên trong cùng một chu kỳ hai pane hosted được phát LUÂN PHIÊN (word của pane A, 30 ms sau word của pane B, mỗi word mang hash28 của chính pane đó). Hệ quả chống coalescing: kênh state chỉ có một word dùng chung, nhưng không pane nào bị pane kia ghi đè quá hạn tươi — staleness tối đa của mỗi pane ≈ 1,0 s + 30 ms ≪ 2,5 s.
- **Nội dung không đổi**: emission đi qua đúng poster duy nhất `BWEmitStatePacket` (bwEmitStateForPane đóng gói state ĐÃ LƯU + gen hiện tại) → **seq tăng** theo cơ chế sẵn có, **gen giữ nguyên**, ngữ nghĩa state không đổi. Renewal không recompute, không đổi trạng thái nào.
- **Vòng đời cùng session**: `bwRenewMaintain` (idempotent, tự hop main thread) được gọi ở cuối `bwRecomputeForPane:` (mọi thay đổi assignment/session đều qua đây — pane hosted đầu tiên xuất hiện thì timer start, mất pane hosted cuối thì stop) và trong `bwSessionTeardown` (stop). Điều kiện chạy: `bwInstalled && self.active && hostedPanes.count > 0`. Tick tự dừng nếu điều kiện mất giữa chừng.
- Log: `bw renew start (1.0s)` / `bw renew stop`, và mỗi tick một dòng `bw renew panes=N hashes=%07x,…` (hash rút gọn của từng pane) — cộng với dòng `bw emit …` sẵn có của poster, log đọc được chính xác pane nào được gia hạn lúc nào.

Mục đích duy nhất đúng như WO: suppression phía app có state đủ tươi sau khi controls ẩn lâu. Phần tách điều kiện act/suppression phía app (W2-A/B) và giới hạn scene của F4 (W3) thuộc strand ABInApp — không nằm trong file của strand này.

## 3. P1 — Arbiter EXPANDED theo PHIÊN (gỡ mô hình bundle)

Gốc lỗi (đúng như WO): controller luôn gọi `bwSetExpandedActive:YES forBundle:nil` (fullscreen là của toàn split — SCPFullscreenController.m:306), trong khi arbiter đòi `bundle == bwExpandedBundle` (nil) → hàng EXPANDED không bao giờ mở.

Đã sửa **ba** điểm dùng equality đó (điểm thứ ba là cùng một lỗi mô hình ở tầng aggregate, không sửa thì state vẫn sai dù arbiter đúng):

1. `bwPinchAllowedForPane:` — hàng EXPANDED (cờ gói state).
2. `pinchDispositionForPane:touchesSuppressed:` — hàng EXPANDED (đường bắn của pinch controller).
3. `bwRecomputeForPane:` — điểm promote HIDDEN→VISIBLE khi expanded: nay `state == HIDDEN && bwExpandedFlag` → VISIBLE cho **mọi** pane của phiên (trước đây chỉ pane trùng bundle — tức không pane nào).

Hai hàm arbiter dùng **cùng một vị từ EXPANDED** (nhất quán theo yêu cầu WO): `bwExpandedFlag && self.active && pane ∈ allPanes && !bwWakePendingBySlot[slot] && !self.resizing`. `allPanes` (không phải `hostedPanes`) là có chủ đích: pane native trong split hỗn hợp không thuộc hostedPanes nhưng vẫn là pane sống của phiên — pinch controller cũng phân giải pane từ allPanes và re-check session bằng allPanes. `bwExpandedBundle` giữ lại làm biến ghi/log duy nhất (setter vẫn lưu + log như cũ), comment ở cả .m và .h đã ghi rõ ngữ nghĩa mới: EXPANDED là trạng thái phiên, arbitration không so bundle nữa.

Truy vết tĩnh 6 trường hợp của WO (cờ = bwPinchAllowedForPane:, disp = pinchDispositionForPane:):

| # | Trường hợp | Trước | Sau (cờ / disp) |
|---|---|---|---|
| 1 | Expanded, không bundle owner (nil) | cờ = NO luôn; disp chỉ Allowed tình cờ khi state VISIBLE, **BlockedHidden khi HIDDEN** — đúng lúc cần thoát fullscreen nhất | YES / Allowed — xác định theo phiên, không phụ thuộc state |
| 2 | Split hỗn hợp native + hosted | pane native không bao giờ qua hàng EXPANDED | cả hai pane: YES / Allowed (native qua allPanes) |
| 3 | Hai hosted | cả hai đều NO (nil ≠ mọi bundle) | từng pane độc lập: YES / Allowed |
| 4 | Đổi pane (swap/reassign) | phụ thuộc bundle sau đổi có khớp giá trị đã lưu | không đọc bundle nữa: pane object còn trong allPanes là qua; pane thay mới cũng qua, pane bị gỡ thì không (xem #5) |
| 5 | Pane bị xoá khi expanded | equality với bundle đã xoá vẫn có thể đúng trên giấy tờ | pane ∉ allPanes → hàng EXPANDED trượt ở cả hai hàm; cờ rơi về state INACTIVE → NO, disp → BlockedUnknown; teardown của split còn gọi bwSetExpandedActive:NO dọn cờ phiên |
| 6 | Restore sau timeout | — | controller settle ở restore (kể cả đường timeout) → bwSetExpandedActive:NO → bwExpandedFlag = NO → cả hai hàm trở về hàng SPLIT thường, không latch |

Guard transition: khi đang có wake transaction mở trên slot hoặc đang kéo divider, hàng EXPANDED nhường cho các hàng thường ở cả hai hàm (cờ: state WAKING ≠ VISIBLE → NO; disp: WAKING → BlockedUnknown) — hai hàm không mâu thuẫn ở bất kỳ tổ hợp nào ở trên.

## 4. P4 — pinchMode mặc định trở lại DRY_RUN (supersede theo WO)

- Static init `bwPinchMode`: `BWModeEnforce` → `BWModeDryRun`; `bwReloadModesAndRepublish`: nhánh pref vắng `… : BWModeEnforce` → `… : BWModeDryRun`. wakeMode giữ DRY_RUN nguyên văn.
- Đây là **supersede có ghi lý do ngay trong code**: mặc định ENFORCE của vòng impl-pinch-wiring (lệnh "nối pinch luôn" của Nguyen) bị phán quyết audit của GPT thay thế — lý do ghi trong comment: pinch-in từng chết ở arbiter bundle + controller chưa có nghiệm thu độc lập trên xe. ENFORCE vẫn tới được trong **chính bản này** qua pref tường minh `bridgewake.pinchMode` = 2 (0/1/2 đều được tôn trọng như cũ) — khớp yêu cầu "một DEB, bật từng tính năng trong cùng bản".

## 5. Cổng đã chạy (đo trên bản cuối, hai cây)

- **Build** SplitScreen từ sạch (THEOS=~/theos, umask 022, toolchain verify clang-18/ldid/ld.lld-18 trước): `make clean && make` exit 0; dylib 1.277.160 B; **0 warning** trong BridgeWake.m/AutoHide.m (các warning còn lại là cũ ở SCPCarSplit.m/SCPCarApps.m, ngoài phạm vi).
- **Harness BridgeWakePack** (C độc lập, BW_PACK_NO_FOUNDATION, header của module): **15/15 PASS** (FNV ×2, V1–V7 pack khớp hex, V8 invalid, V9/V10 pack + round-trip, BWTypeAct == 5). Header pack không bị vòng này đụng — layout gói không đổi.
- **Grep**: `isEqualToString:bwExpandedBundle` trên BridgeWake.m = **0** (cả hai cây); `bwExpandedBundle` chỉ còn khai báo + gán ở setter.
- **Mirror**: 3 file đã sửa `cmp` identical từng cặp project/ ↔ src/SplitScreenA/.
- **Diff từng hunk** (đối chiếu bản trước vòng này trong push9-clone): BridgeWake.m 11 hunk (interface private; statics mode/expanded + renew timer; khối renewal; hàng EXPANDED ở bwPinchAllowedForPane:; promote ở bwRecompute + maintain ở cuối; maintain ở teardown; comment + default ở reload; bwHandleActPacket viết lại; hàng EXPANDED ở disposition) — BridgeWake.h 1 hunk (doc bwSetExpandedActive) — AutoHide.m 1 hunk (ahRevealBody).

## Ngoài phạm vi strand này (không tự xử, để coordinator/GPT xếp)

- W2 phần app (tách điều kiện act khỏi freshness 2,5 s), W3 (giới hạn scene của F4), W4 (probe CarPlayApp): thuộc strand ABInApp/SplitScreen-glue khác.
- P2 của WO (lệnh test controller độc lập qua công tắc chẩn đoán trong Prefs): nằm ở SCPFullscreenController.m + Prefs — cả hai đều ngoài file sở hữu của strand này.
- Nghiệm thu xe W5 + ma trận P2/P4: phiên của Nguyen; strand này không tuyên bố gì về hành vi trên xe.
