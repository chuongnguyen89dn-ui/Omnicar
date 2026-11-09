# VERIFY ĐỘC LẬP 1 — WAKE/ACT (chỉ-đọc)

Ngày: 2026-11-09. Vai trò: kiểm độc lập, không sửa file nào, không tự
hoà giải lệch với strand tích hợp — lệch (nếu có) ghi nguyên văn.
Đối tượng kiểm:
- Source: `project/OmniCarAppBridge/ABInApp.m` (1.915 dòng, md5
  `ce13902b…`), `project/OmniCarSplitScreen/SCPCarSplit+BridgeWake.m`
  (805 dòng), `project/OmniCarSplitScreen/SCPCarSplit+AutoHide.m`
  (355 dòng). Mirror `src/` của cả 3 file: `cmp` identical từng cặp
  (tự kiểm lại, khớp tuyên bố của các strand).
- Binary: `project/.theos/obj/debug/arm64/OmniCarAppBridge.dylib`
  (628.592 B, build 2026-11-09 08:04:47 UTC) +
  `OmniCarSplitScreen.dylib` (1.276.440 B, 08:04:56 UTC) — build tổng
  ở root, SAU cả hai strand sửa; đối chiếu chéo bản module riêng của
  strand (`OmniCarAppBridge/.theos/…` 08:02:43 UTC,
  `OmniCarSplitScreen/.theos/…` 08:01:46 UTC): kết quả chuỗi như nhau.
Giới hạn: không disassemble truy vết lời gọi trong binary (mức binary
= hiện diện chuỗi log + thời gian build); không kiểm hành vi xe.

## (a) Đường phát act phía app — ĐẠT

| Điểm kiểm | Bằng chứng |
|---|---|
| Điểm gọi act duy nhất, không qua BWFresh | `ABInApp.m:629` `BWActOnSequenceStart(began);` — trong khối mở dãy (điều kiện `!BWSeqActive && began.count > 0`, :609), đứng TRƯỚC `BWGatePass` (:631) và trước mọi BWFresh của handler |
| Thân hai hàm act không chứa BWFresh | `BWActOnSequenceStart` :336–375 và `BWPostAct` :291–307 đọc toàn thân: 0 lần `BWFresh`. Grep toàn file: `BWFresh` chỉ ở :149 (comment), :216 (định nghĩa), :224/:228/:483/:549/:633/:644 (điểm gọi — xem (b)), :277 (comment) |
| Cờ phiên đặt tại điểm chấp nhận gói state | `BWActSessionVerified` khai báo :152; đặt YES tại :423 trong `BWOnStatePacket`, sau 4 lớp kiểm liên tiếp: valid/type (:410–411) → `type == BWTypeState` (:412) → `hash28 == BWOwnHash28()` (:413) → `BWGenAccept(p.gen)` (:414); cùng điểm đặt `BWKnown = YES` (:422) |
| Cờ phiên xoá khi phiên đóng | `BWResetAll` :766 `BWActSessionVerified = NO;`, cùng khối xoá `BWKnown = NO` (:765) |

## (b) Các điểm gọi BWFresh còn lại phía app — ĐẠT (đúng 6, không điểm nào trên đường act)

| # | Vị trí | Thuộc đường | Nội dung |
|---|---|---|---|
| 1 | :224 `BWEffectiveWakeMode` | mode | stale → `BWModeOff` |
| 2 | :228 `BWEffectivePinchMode` | mode | stale → `BWModeOff` |
| 3 | :483 `BWGatePass` | nuốt | `reason = @"stale"`, trả NO |
| 4 | :549 `BWProbeLogging` | probe | stale → chỉ còn bản tổng kết 30 s |
| 5 | :633 `BWHandleTouchEvent` | nuốt/probe | `BWSeqWouldSwallow && BWKnown && BWFresh() && BWWakeMode == BWModeOff` → huỷ wouldSwallow, reason `@"mode"` (đứng SAU điểm gọi act :629) |
| 6 | :644 `BWHandleTouchEvent` | query | `if (!BWFresh()) BWQueryIfStale();` |

Đường act hoàn chỉnh: :629 → `BWActOnSequenceStart` (:336) →
`BWPostAct` (:291) — không mắt nào chạm BWFresh. Quyền nuốt vẫn bị
khoá bởi freshness qua `BWGatePass` + hai helper mode như trước.

## (c) Trói scene W3 — ĐẠT

`BWActHostedScene` (:316–333), thứ tự thẩm quyền đúng như WO:
1. `YZLeaseSceneID.length > 0` → quét `connectedScenes`, scene có
   `YZSceneCandidateID` khớp lease thì trả scene đó; quét hết không
   thấy → trả **nil** (không rơi xuống nhánh key-window).
2. Ngược lại → `ABKeyWindow().windowScene` (key window nil → nil).

`BWActOnSequenceStart` (:344–366) áp dụng fail-closed:
- `hosted == nil` → `unknown` → log `act-drop-target-unknown`, return,
  **không phát**.
- Touch bất kỳ `!t.window` → `unknown` → cùng nhánh drop.
- Touch có `windowScene != hosted` → `foreign` → log `act-drop-scene`,
  return, **không phát** (đây là nhánh chạm màn hình iPhone).
- Chỉ khi MỌI touch trong `began` đều có window và thuộc hosted
  scene mới tới `BWPostAct` (:367) + log `act-posted`.

Binary: cả 4 chuỗi `[autohide] act-posted / act-drop-nosession /
act-drop-scene / act-drop-target-unknown` (kèm `t=%llu stateage=%ld`)
có mặt trong `OmniCarAppBridge.dylib`.

## (d) Phía owner — ĐẠT

**bwHandleActPacket:** (`SCPCarSplit+BridgeWake.m:605–657`) — đủ 6
reason loại riêng, đúng thứ tự kiểm, mỗi điểm `return` kèm log
`[autohide] act drop reason=…`:
`decode-fail` :611 (`!pkt.valid || type != BWTypeAct`) → `bad-hash`
:618 (`BWSlotForHash28 < 0`) → `bad-gen` :625 (`pkt.gen !=
bwGenBySlot[slot]`, log cả gen hiện tại) → `session-inactive` :632
(`!self.active`) → `not-assigned` :638 (pane nil / `pane.slot !=
slot` / không thuộc `hostedPanes`) → `split-inactive` :646
(`bwStateBySlot[slot] == BWStateInactive`). Chấp nhận: log
`act-accepted … -> ahNoteActivity` :652 rồi gọi
`ahNoteActWithKbActive:` :654. Handler không post gì ra ngoài
(anti-loop giữ nguyên).

**State renewal (W2):**
- `bwRenewMaintain` :243–261: điều kiện chạy
  `bwInstalled && self.active && hostedPanes.count > 0`; start khi
  thoả + chưa có timer, stop (invalidate + nil) khi mất điều kiện.
  Timer `scheduledTimerWithTimeInterval:1.0 … repeats:YES` :252–254.
- `bwRenewTick:` :263–282: mất điều kiện → gọi lại maintain để tự
  dừng; còn điều kiện → vòng qua MỌI pane hosted gọi
  `bwQueueEmitForPane:` + log `bw renew panes=N hashes=…`.
- Vòng đời: maintain được gọi ở cuối `bwRecomputeForPane:` (:432) và
  trong `bwSessionTeardown` (:457, comment tại chỗ: "session over ->
  renewal stops").
- **Poster duy nhất**: `BWEmitStatePacket` (:133–148) là cặp
  `notify_set_state`/`notify_post` duy nhất cho kênh state (hai
  `notify_post` còn lại ở :569/:682 thuộc kênh ACK, token khác). Mọi
  đường state — `bwEmitStateForPane:` (:206), teardown (:450),
  force-off (:155) — đều funnel qua hàm này. Renewal đi:
  tick → `bwQueueEmitForPane:` (:195) → queue giãn 30 ms
  (`BWEmitDrain` :180–193, dedupe theo bundle) → `bwEmitStateForPane:`
  → poster.
- **Seq tăng, gen giữ**: seq tăng ngay trong poster :138
  `bwStateSeq = (bwStateSeq + 1) & 0xFFF`; gen truyền vào từ
  `bwGenBySlot[slot]` tại :213 — đường renewal không gán
  `bwGenBySlot` ở bất cứ đâu (gen chỉ đổi ở teardown/assignment).
- Quan sát (không phải lệch): vì dedupe theo bundle, nếu một emission
  thường đang chờ sẵn trong queue thì tick không xếp thêm bản trùng;
  độ cũ biên lý thuyết của mỗi pane ≈ 1,0 s + 30 ms × (số pane − 1),
  vẫn ≪ ngưỡng tươi 2,5 s.
- Binary: `[wake1] bw renew start (1.0s)` / `bw renew stop` /
  `bw renew panes=%lu hashes=%@` + cả 6 chuỗi reason + `act-accepted`
  có mặt trong `OmniCarSplitScreen.dylib`.

## (e) ahRevealBody + tay trao fade xuống host — ĐẠT

`SCPCarSplit+AutoHide.m:186–207`:
- Guard `if (!ahFadedState) return;` (:187) — không faded thì không
  reveal, không log.
- Đếm `restored` = số view còn giữ bản lưu opacity (associated
  object) **trước** khi khôi phục (:196–198).
- Thứ tự: `ahRestoreAllPainted` → **`pushHostFramesLive:NO` (:200)**
  → `publishKnobsSoon` → `bwRecomputeForPane:` từng pane hosted →
  log `[autohide] reveal-applied reason=%s views=%lu` (:204–206).
- Tay trao `fade` còn nguyên ở cả hai chiều: đường reveal (:200) và
  đường fade (:173, ngay sau `ahPaintCurrentSet`).
- Chuỗi đầy đủ truy được: `bwHandleActPacket:` (BridgeWake.m:654) →
  `ahNoteActWithKbActive:` (AutoHide.m:238) → `ahNoteActivity:`
  (:253, nguồn `AHSourceApp`) → `ahRevealBody:AHRevealActivity`
  (:232 khi đang faded).
- Binary: chuỗi `reveal-applied reason=%s views=%lu` có mặt trong
  `OmniCarSplitScreen.dylib`.

## Kết luận + ghi nhận lệch

Cả 5 mục (a)–(e): **ĐẠT** ở mức source + hiện diện binary. Không mục
nào tuyên bố về hành vi trên xe — nghiệm thu W5 vẫn là việc của
phiên xe trên bản tích hợp.

Lệch so với biên bản strand: **không phát hiện lệch nội dung nào.**
Số dòng mọi hunk trong `fix-w-act-app.md` (BWPostAct :291,
BWActHostedScene :316, BWActOnSequenceStart :336, set cờ :423, điểm
gọi :629, reset :766; BWFresh tại :224/:228/:483/:549/:633/:644)
khớp từng dòng với source hiện tại; các điểm của `fix-wp-owner.md`
(6 reason, renewal 1,0 s, maintain tại recompute/teardown,
reveal-applied) đều truy được nguyên văn.

Một khác biệt MÔ TẢ (không phải lệch kết luận), ghi nguyên để strand
tích hợp tự đối chiếu: `fix-w-act-app.md` gọi điểm BWFresh :633 là
"báo cáo mode tại mở dãy" — đọc code thì chính xác hơn là: hiệu
chỉnh `BWSeqWouldSwallow` khi gói state ra lệnh `wakeMode == Off`
(reason `@"mode"`), một phép sửa trên đường nuốt/probe, đứng sau
điểm phát act. Phân loại đường (nuốt/probe, không phải act) không
đổi.
