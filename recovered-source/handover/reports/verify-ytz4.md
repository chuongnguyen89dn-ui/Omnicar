# VERIFY-YTZ4 — Kiểm độc lập vòng ytz4 (chỉ-đọc)

Người kiểm: agent kiểm độc lập, không sửa file nào. Cây kiểm:
`project/` tại trạng thái sau vòng ytz4 (mirror `src/` đối chiếu ở cuối);
diff (c)/(d) lấy trong `~/workspace/push9-clone`, baseline `36135b8`
(ytz3) → `origin/main` = `237098c` (ytz4 source). Mọi khẳng định dưới
đây đọc từ source/diff hiện tại, không dựa vào biên bản strand.

## (a) Ba ràng buộc AutoHide-EXPANDED — KHẲNG ĐỊNH cả ba

**(1) `bwSetExpandedActive:` không còn suspend — ĐÚNG.**
`SCPCarSplit+BridgeWake.m:440-456`: thân hàm chỉ đặt
`bwExpandedFlag`/`bwExpandedBundle`, log `[wake1] bw expanded`, và
chạy `bwRecomputeForPane:` cho mọi ô hosted. Không còn lời gọi
`ahSetSuspended:` (chỉ còn một đoạn comment giải thích việc đã gỡ).
Toàn module, các điểm `ahSetSuspended:` còn lại: định nghĩa +
bounce main-thread (`SCPCarSplit+AutoHide.m:273-276`), khai báo
(`SCPCarSplit+AutoHide.h:87`), và đúng hai lời gọi ở
`SCPCarSplit.m:2019` (YES — vào hosted-solo) / `:2039` (NO — ra
solo). Tức suspension còn lại đúng và chỉ là đường hosted-solo.

**(2) `ahFadeBlockedReason` không còn hạng tử expanded — ĐÚNG, và
bốn khoá còn đủ.** `SCPCarSplit+AutoHide.m:140-157`, thứ tự thực tế:
`solo` (soloHostedBundle != nil) → `kbhold` (ahKbHoldState còn hạn)
→ `surface-open` (popupOpen || pickerSheet || ratioMenu || tray
không-overlay — khoá popup) → `dragging` (resizing || dragGhost).
Không có hạng tử nào đọc `bwExpandedActive`/cờ expanded.

**(3) `bwRecomputeForPane:` không còn phép nâng HIDDEN→VISIBLE theo
EXPANDED — ĐÚNG.** Thân hàm (`BridgeWake.m:460-563`) không còn khối
`if (state == BWStateHidden && bwExpandedFlag) state = BWStateVisible;`
(grep mẫu đó = 0); `bwExpandedFlag` trong TU này chỉ còn ở: statics,
setter/getter, và hai hàng EXPANDED của arbiter.

**Truy vết: EXPANDED + faded thì state tới được HIDDEN ở điều kiện
nào.** Từ thân `bwRecomputeForPane:`: pane phải (i) assigned —
`self.active` && bundle có && pane ∈ hostedPanes; (ii) không có wake
transaction mở trên slot (bwWakePendingBySlot = NO, nếu có thì
WAKING); (iii) không transient — hostFrame khác null, hostHandle
sống, bar không ở pha fade-out (alpha 0 mà chưa hidden), không
resizing, assignment đã qua 0,25 s; (iv) **barHidden** (pane.bar nil
hoặc hidden) — HIDDEN vẫn cần thanh menu của chính ô đã xuống theo
timer riêng của nó, fade một mình chưa đủ; (v) fadedEffective = YES
(`ahFaded` khi AutoHide bật; = YES theo định nghĩa khi AutoHide
tắt); (vi) không popup cho pane đó (bwPopupForPane → UNKNOWN). Thêm
một cổng fail-open độc lập: trùng hash28 với ô hosted khác →
UNKNOWN. EXPANDED không xuất hiện trong bất kỳ điều kiện nào trên —
đang expanded mà (i)–(vi) đủ thì state = **BWStateHidden** và gói
state phát đi nói HIDDEN.

**Pinch-in độc lập fade — ĐÚNG bằng đọc thân hàm.**
`bwPinchAllowedForPane:` (`BridgeWake.m:415-438`): hàng EXPANDED
(`bwExpandedFlag && self.active && pane ∈ allPanes &&
!bwWakePendingBySlot[slot] && !self.resizing` → YES) đứng TRƯỚC
dòng đọc `bwStateBySlot` đầu tiên (`!= BWStateVisible`).
`pinchDispositionForPane:touchesSuppressed:` (`:935-968`): cùng
hàng EXPANDED (→ SCPArbiterPinchAllowed) đứng trước `switch
(bwStateBySlot[pane.slot])`. Cả hai khoá theo cờ phiên + danh sách
allPanes, không theo bundle. `SCPPinchController.m`: grep
`ahFaded|ahSuspended` = **0 hit** — controller không đọc trạng
thái fade/suspend ở bất kỳ đâu.

## (b) KB xác thực — KHẲNG ĐỊNH, hai ghi chú ở cuối mục

**Nguồn host là phiên phím thật.** Điểm quản lý phiên duy nhất là
`ABKeyboardDispatch` (`ABHostGeometry.m:209-232`) — consumer của
Darwin `appbridge.keyboard`, chính là nơi gọi
`ABKeyboard showForApp:`/`hideForApp:` cho app. Mọi sự kiện qua
funnel `ABKbSyncNoteEvent` (`:99-113`, giữ bản ghi sống duy nhất
`abKbLiveBundle`/`abKbLiveSession`, bộ đếm phiên tăng mỗi lần mở):
dispatch show → post active=1 (`:228`); dispatch hide → post
active=0 (`:222`); teardown `closeApp:terminate:`
(`ABHostLaunch.m:261`, sau đúng lệnh hide của nó); disconnect —
`ABCarPlayChanged` post đóng cho bundle đang giữ phiên trước khi
teardown (`ABHostGeometry.m:257-259`). Snapshot ban đầu:
`ABOpenBlock` gọi `ABKbSyncSnapshotForApp(app)` (`:365`) — active
chỉ khi app đó đang giữ phiên sống. Kênh hai phía khớp chuỗi:
`com.anlai.omnicar/appbridge.kbsync` (SCPShared.m:28 =
ABChannelNames.m:38).

**Bản ghi owner ba trạng thái, nguồn duy nhất là kbsync.**
`bwKbKnownBySlot/bwKbActiveBySlot/bwKbSessionBySlot[10]`
(`BridgeWake.m:88-90`); known=NO là UNKNOWN. Điểm ghi bản ghi:
`bwHandleKbSyncNote:` (`:302-338`) — khớp bundle với
`bwBundleBySlot`, bundle không thuộc slot nào → drop có log
`[kb-sync] drop not-assigned`; cập nhật + log `change` kèm
`source=host-keyboard-session` + phát ngay khi đổi. Phát gói:
`BWEmitKbPacket` (`:190-205`) + `bwKbEmitForPane:` (`:285-292`),
tại ba điểm: đổi phiên (handler), query của chính app đó
(`bwHandleQueryPacket:` `:660` — theo đúng slot của hash gói
query), và vòng renew 1,0 s (`bwRenewTick:`). Poster dùng chung
token `bwStateSendToken` và chung bộ đếm seq `bwStateSeq` với
poster state.

**Không đường nào suy kb của owner từ act-flag.** Grep mọi điểm
ghi `bwKb*`: chỉ handler kbsync + hai điểm reset (dưới). Handler
act (`bwHandleActPacket:` `:750-800`) đọc `pkt.flag` duy nhất để
log `kb=%d` và gọi `[self ahNoteActWithKbActive:pkt.flag]` — đó là
cơ chế kb-hold của AutoHide (hoãn fade, design-autohide §4.2, có
từ các vòng trước), KHÔNG ghi vào bản ghi kb-sync và không được
phát lại thành tri thức kb. Biểu thức bị GPT kết án
(`BWKb == BWKbActive` cho 0 cả khi Unknown) không còn nuôi bất kỳ
bản ghi owner nào.

**Reset UNKNOWN.** (i) Đổi assignment: khối gen bookkeeping trong
`bwRecomputeForPane:` (`:478-480`) — bundle của slot đổi → known=NO,
active=NO, session=0. (ii) `bwSessionTeardown` (`:580-582`) — mọi
slot có bundle đều reset. (iii) Phía app: `BWResetAll` xoá snapshot
owner (`ABInApp.m:901-906`). Cộng cơ chế hết tươi phía app (dưới),
ba điểm này đủ cho các đường đổi assignment/teardown hiện có.
**Ghi chú biên (không tự hoà giải):** reset (i) kích hoạt theo
chuỗi bundle đổi; gán lại CÙNG bundle vào cùng slot trong một phiên
đang sống không kích hoạt nó. Giảm nhẹ có sẵn: host post snapshot
lại mỗi lần app (re)open (ABOpenBlock) và snapshot phía app hết
tươi sau 3,5 s → UNKNOWN. Ghi để GPT biết, không coi là đã xử lý
ở tầng owner.

**Phía app — `BWKbEffective` không có mặc định UNKNOWN→INACTIVE ở
bất kỳ nhánh nào** (đọc từng nhánh, `ABInApp.m:465-488`):
1. `BWKb == BWKbActive` (nguồn cục bộ) → ACTIVE, src=local, age =
   tuổi của lần đổi cục bộ.
2. Ngược lại, nếu snapshot owner còn tươi (RxAt > 0 và tuổi ≤
   3,5 s — `BWKbOwnerFreshWindow`, `:431`): src=owner; owner
   known=1 → ACTIVE/INACTIVE theo active; owner known=0 → giữ
   **UNKNOWN** (sync sống, nội dung chưa biết — ghi đúng bản chất).
3. Ngoài hai nhánh: UNKNOWN, src=none, age=−1.
Hệ quả đáng ghi: trạng thái INACTIVE cục bộ (vd responder đã
resign) tự nó KHÔNG bao giờ hiện thành effective INACTIVE — chỉ
snapshot owner còn tươi known=1/active=0 mới cho INACTIVE. Điểm
Unknown→Inactive duy nhất trong TU là `BWKbHideNote` (`:573-576`):
có thông báo ẩn phím thật + không có first responder hiện hành
mới hạ — và theo hệ quả trên, lần hạ đó không tự nó đổi được
effective state. Cổng `BWGatePass` (`:604-606`): ACTIVE → fail
`kb`; UNKNOWN → fail `kbunknown`; chỉ known-inactive đi tiếp.
Điểm phát flag của gói act (`:328`) nay là
`BWKbEffective(...) == BWKbActive` — bit chỉ 1 khi có bằng chứng
ACTIVE dương tính. Nhận gói kb (`BWOnKbPacket` `:448-456`): khớp
hash28 của chính app + `BWGenAccept`; bit active bị bỏ khi
known=0; gói kb không tự nâng BWGen/BWKnown.
**Log nguồn thắng:** latch ở đầu sequence (`:746-751`) chụp
(Known, Active, Src, Age) từ chính `BWKbEffective(&kbSrc, &kbAge)`;
dòng close in `kbKnown=%d kbActive=%d kbSrc=%s kbAge=%ld`
(`:686`).

**Layout gói kb hai phía — khớp, kiểm bằng C core thật của dự án.**
Hai bản `BridgeWakePack.h` cmp identical. Đóng gói bằng đúng lời
gọi của owner (`BWPackFields(hash28, seq, gen, NO,
kbField=(known?2:0)|(active?1:0), 0, 0, type=6)`, type giữ local
hai phía: `BWTypeKbSync=6` owner / `BWTypeKbState=6` app), giải
bằng `BWUnpack` + phép trích của app (bit9 = pinchMode>>1 =
known; bit8 = pinchMode&1 = active, bị known gác):
- known=1, active=1, seq=7, gen=3 → `0xE9DA706803801B06`: valid=1,
  hash28=0xD3B4E0D, seq=7, gen=3, flag=0, bits9-8=3, wm=0, state=0,
  type=6 → app đọc known=1, active=1. ✓
- known=1, active=0, seq=8, gen=3 → `0xE9DA706804001A06`: bits9-8=2
  → known=1, active=0. ✓
- known=0, seq=9, gen=3 → `0xE9DA706804801806`: bits9-8=0 →
  UNKNOWN. ✓ (Gói lỗi known=0 mà bit active=1: app vẫn đọc
  active=0 — phép gác known hoạt động.)
- Bộ vector của strand app (gen=7): seq=1 k=1 a=1 →
  `0xE9DA706800803B06`; seq=2 k=1 a=0 → `0xE9DA706801003A06` —
  khớp hằng số hai biên bản độc nhau. ✓
- Hồi quy: V1 `0xE9DA706832803859`, V9 `0xE9DA706800803805`,
  V10 `0xE9DA706801003C05` — đóng gói lại bằng cùng core, khớp
  từng bit. ✓

**Ghi chú lệch phụ (không tự hoà giải) — một consumer thứ hai của
kênh `appbridge.keyboard`.** `ABChannels.m:358-369` (cùng target
OmniCarAppBridge theo Makefile) đăng ký thêm một
`notify_register_dispatch` cho cùng kênh Darwin, hide-only, KHÔNG
qua funnel kbsync. Đọc kỹ thì consumer này **chết trong thực tế**:
nó giải hash bằng `(uint32_t)state` (32 bit thấp), trong khi
packing của phía gửi đã kiểm chứng (`ABInApp.m:1780`) là
`shown | type<<1 | return<<8 | FNV1a(bundle)<<24` — 32 bit thấp là
hỗn hợp cờ + 8 bit thấp của hash, không thể bằng một FNV-1a-32 đầy
đủ của pane nào (trừ trùng hợp ~2^-24), nên `bundleForHash:` trả
nil và block không làm gì. Consumer có hiệu lực duy nhất là
`ABKeyboardDispatch` (đọc `state >> 24`, khớp packing). Kết luận
mục (b) không đổi — nguồn kb là phiên host thật và funnel là đường
duy nhất có hiệu lực — nhưng đăng ký thừa này là rác tái tạo có từ
trước vòng ytz4, nên được ghi tại đây để GPT/coordinator biết,
không xoá hộ.

## (c) Thuần cộng — KHẲNG ĐỊNH

Diff `36135b8 → 237098c`, đếm dòng theo file:
- **I2:** `SCPHooks.m` **+48/−0**; `SCPAppIcons.m` **+58/−0**;
  `SCPHomeApply.m` **+20/−0**. Đọc mọi hunk: phần cộng chỉ gồm
  (i) các helper thuần đọc phục vụ log — `SCPHomeLibProcDesc`
  (tên process/bundle), `SCPHomeLibSafeGet` (getter qua
  objc_msgSend có respondsToSelector + @try gác), cache dedup log
  `SCPHomeLibDecisionCache` (dictionary tĩnh của riêng instrument);
  (ii) lời gọi `SCPHomeLibLogDecision` đặt cạnh các điểm quyết
  định có sẵn (skip-not-chosen / skip-already-ours /
  skip-real-declaration / inject / lib-skip-present /
  remove-skip-no-proxy); (iii) ở SCPHomeApply: một cờ cục bộ
  `homelibOmniOnGrid` được set trong vòng walk có sẵn + một dòng
  log post-apply. Không dòng cộng nào ghi vào thư viện/proxy/vật
  thể ngoài instrument: rà `removeObject/addObject/setObject/
  postNotification` trên toàn bộ phần cộng — hai hit objc_msgSend
  duy nhất đều là getter đọc. **Thuần cộng log.**
- **Y2S:** `ABYTZoom.m` **+134/−2**. Hai dòng bị xoá là đúng hai
  dòng của format-string log grant cũ
  (`@"[ytz] lease cap gen=%lu size=%gx%g split=%d"` + dòng đối số
  `rec.pubIsSplit ? 1 : 0]);`), được thay bằng format nới rộng
  cộng hậu tố `%@`/`prevRevoke=%.2fs` — đúng ngoại lệ đề bài cho
  phép. Ngoài ra 0 sửa thân hàm (xem mục (d).

## (d) YZ/YTZ ổn định — KHẲNG ĐỊNH

- **ABYTZoom:** ngoài instrument Y2S, không đổi hành vi. Phần cộng
  gồm: hai helper thuần đọc (`YZSettingsOrientationString` — đọc
  settings qua chuỗi selector có respondsToSelector + @try, trả
  chuỗi; `YZSnapshotFields` — định dạng các trường đọc từ rec/pane);
  hai thuộc tính bookkeeping của riêng instrument trên lease record
  (`revokeSnapAt`, `revokeSnapPending`, khai báo tại ABYTZoom.m:70-71);
  ba điểm log (`[ytz-revoke-snap]` ở revoke + đường orphan-pref,
  one-shot `[ytz-nextlayout]` ở cuối `YZPublish`, hậu tố
  `prevRevoke=` ở log grant). Payload của `YZPublish`, thứ tự
  grant (layoutPane commit trước publish), thân revoke (không
  layout cưỡng bức — đúng phán quyết GPT) đều nguyên vẹn: các điểm
  cộng nằm SAU lời post/publish hiện hữu hoặc trong log. Hai thuộc
  tính bookkeeping chỉ được instrument tự ghi/đọc để canh one-shot
  log; không trường lease thật nào (active/gen/size/split) bị điểm
  cộng chạm tới.
- **ABInApp:** 14 hunk của diff đều nằm trong vùng kb/wake/act
  (statics kb, BWPostAct flag, khối snapshot/effective kb,
  BWKbFrameNote, BWGatePass, latch instrument ở BWHandleTouchEvent,
  BWResetAll, BWKbLocalSet ở ABResponderBecame/Resigned). **Không
  hunk nào chạm các hàm ảo hoá YZ** (YZOnLease /
  YZExitVirtualization / các bề mặt relay / ack) — vùng đó không
  xuất hiện trong diff. Phần YZ của ABInApp giữ nguyên hành vi.

## Mirror

cmp project/ ↔ src/: BridgeWake.m, AutoHide.m (SplitScreenA),
ABInApp.m, ABYTZoom.m, ABHostGeometry.m (AppBridgeB), ABHostLaunch.m
(bản AppBridgeA), SCPHooks.m (SplitScreenA), SCPAppIcons.m
(SplitScreenC) — **identical**. SCPHomeApply.m: hai bản chỉ khác
đúng dòng import `SCPHomeWallView.h` (đường phẳng của project vs
`../SplitScreenB/` của src — quy ước phase-3 có từ trước vòng
này); cả hai đều mang instrument [homelib] (7 hit mỗi bản).

## Kết luận tổng

(a) đủ ba ràng buộc, pinch-in độc lập fade — khẳng định.
(b) kb có nguồn xác thực từ phiên phím host thật, ba trạng thái
không sụp, layout gói khớp hai phía bằng C core — khẳng định, kèm
hai ghi chú không hoà giải: consumer `appbridge.keyboard` thứ hai
ở ABChannels.m (chết trong thực tế) và biên reset khi gán lại cùng
bundle cùng slot. (c) I2 + Y2S thuần cộng trong ngoại lệ đã cho —
khẳng định. (d) ngoài instrument, YZ hai phía không đổi hành vi —
khẳng định. Mức: static PASS; bằng chứng xe chưa có (Gate 3 vẫn
đóng theo GPT).
