# MAP-M3 — BẢN ĐỒ AUTOHIDE ↔ SỰ THẬT KB

Strand M3, chỉ-đọc. Không sửa file nguồn nào. Mọi `file:line` đọc từ HEAD thật
`38735c5` của cây `~/workspace/push9-clone/recovered-source/src/` (đường dẫn
dưới đây tương đối với `src/`).

Sự kiện mẫu (log phiên ytz4): **17:32:24.190** host post kb `active=1`, owner
đã nhận (kb-sync), nhưng **17:32:28.079** controls vẫn fade.
Phán quyết GPT cần kiểm chứng: *kb-sync cập nhật TRẠNG THÁI nhưng khoá
AutoHide còn phụ thuộc gói act.* → **Đúng, và điểm đứt xác định được chính
xác ở mục 1.3.**

---

## 1) Đường dây hiện tại của ca 17:32

### 1.1 (a) Bản ghi kb của owner cập nhật ở đâu

**Điểm hiện tại (file:line):**

- Nguồn phát phía host (SpringBoard, tiến trình ABHost):
  `AppBridgeB/ABHostGeometry.m:86-97` — `ABKbSyncPost` post
  NSDistributedNotification `com.anlai.omnicar/appbridge.kbsync`
  (`SplitScreenA/SCPShared.m:28` = `SCPNoteBridgeKbSync`), payload
  `{identifier, kbactive, kbsession, kbsource="host-keyboard-session"}`.
  Mọi mở/đóng funnel qua `ABKbSyncNoteEvent`
  (`ABHostGeometry.m:99-113`): mở → `abKbSessionCounter++`, ghi
  `abKbLiveBundle/abKbLiveSession` (file statics ngay trên
  `ABKbSyncPost:86`, toàn cục phía host — host chỉ giữ MỘT phiên phím
  sống); đóng → chỉ xoá bản ghi sống khi bundle đóng đúng là bundle
  đang giữ phiên, post kèm id của phiên bị đóng (0 nếu app đóng không
  giữ phiên).
  Các điểm gọi funnel: `ABKeyboardDispatch` show
  `ABHostGeometry.m:228` / hide `:222`; CarPlay disconnect `:259`;
  snapshot lúc open `ABKbSyncSnapshotForApp` `ABHostGeometry.m:120-125`
  (gọi từ `ABOpenBlock` `:365`); teardown `closeApp:terminate:` vòng
  qua dispatch nên post riêng tại `AppBridgeA/src/ABHostLaunch.m:261`.
- Đăng ký nhận phía owner: `SplitScreenA/SCPCarSplit+BridgeWake.m:887-892`
  (`addObserverForName:SCPNoteBridgeKbSync` trong `bwInstallOwner`).
- Handler: **`bwHandleKbSyncNote:` — `SCPCarSplit+BridgeWake.m:302-338`**:
  - `:304-307` đọc `identifier` → `bundle`, `kbactive` → `active`,
    `kbsession` → `session`. **Trường `kbsource` trong payload KHÔNG
    được đọc và KHÔNG được lưu** — chuỗi `source=host-keyboard-session`
    trong log là hardcode ở cả hai đầu post/log.
  - `:309-313` tìm slot bằng **so chuỗi** `bwBundleBySlot[s]` ==
    bundle; không khớp slot nào → drop có log `[kb-sync] drop
    not-assigned` (`:315-321`).
  - `:323-325` ghi bản ghi theo slot — khai báo tại
    `SCPCarSplit+BridgeWake.m:88-90`:
    `bwKbKnownBySlot[slot] = YES` (:323, trường **known**),
    `bwKbActiveBySlot[slot] = active` (:324, trường **active**),
    `bwKbSessionBySlot[slot] = session` (:325, trường **session**,
    `uint32_t`). Ba mảng `[10]` keyed theo `SCPCarPane.slot`.
  - `:320-322,326-336` nếu đổi → log `[kb-sync] change … known=1` và
    phát ngay gói kb cho app qua `bwKbEmitForPane:` (`:336`).
- Phát lại owner → app: `bwKbEmitForPane:` (`BridgeWake.m:285-292`) →
  `BWEmitKbPacket` (`BridgeWake.m:190-203`): gói **type 6**
  (`BWTypeKbSync = 6`, `BridgeWake.m:97`) trên kênh Darwin
  `bridgewake.v1.state`, bits 9-8 mang `known/active`, dùng chung
  token + chung seq đơn điệu `bwStateSeq` với gói state. Các điểm phát
  khác: renewal 1.0 s `bwRenewTick` (`BridgeWake.m:394`) và trả lời
  query `bwHandleQueryPacket` (`BridgeWake.m:658-660`).
- Bên nhận duy nhất của bản ghi này là phía app (cổng suppression):
  `BWOnKbPacket` — `AppBridgeB/ABInApp.m:448-455` lưu
  `BWKbOwnerKnown/BWKbOwnerActive/BWKbOwnerRxAt`.

**Nguyên nhân liên quan ca 17:32:** đường này hoàn chỉnh và đã chạy
(log kb-sync có mặt) — nhưng đầu ra của nó chỉ tới (i) bản ghi
`bwKb*BySlot` và (ii) gói type 6 cho app. **Không có cạnh nào từ bản
ghi này vào AutoHide**: `grep bwKb` trong
`SCPCarSplit+AutoHide.m/.h` = 0 hit; `bwHandleKbSyncNote:` không gọi
bất kỳ hàm `ah*` nào.

**Điểm sẽ sửa:** xem mục 3 — cổng fade phải đọc chính bản ghi này.

**Trạng thái trước/sau (mục này):** trước = bản ghi đúng, cập nhật
đúng lúc 17:32:24.190 (`known=1, active=1`), nhưng là dữ kiện "chết"
đối với fade; sau (theo đặc tả, mục 3) = bản ghi là đầu vào trực tiếp
của cổng fade.

### 1.2 (b) AutoHide kb-hold đọc TỪ ĐÂU

**Điểm hiện tại (file:line):**

- Hàm cổng: **`ahFadeBlockedReason` — `SCPCarSplit+AutoHide.m:140-157`**,
  chỉ được đánh giá tại thời điểm timer bắn (`ahTimerFired:`
  `AutoHide.m:159-184`, gọi cổng ở `:164`). Mọi hạng tử, theo thứ tự:
  1. `"solo"` — `self.soloHostedBundle != nil` (`:146`);
  2. `"kbhold"` — `ahKbHoldState` còn hạn (`:147-150`): nếu
     `ahKbHoldState == YES && CACurrentMediaTime() < ahKbHoldExpiry`
     → chặn; nếu hết hạn → tự xoá `ahKbHoldState = NO` tại `:149` rồi
     rơi xuống hạng tử tiếp;
  3. `"surface-open"` — `popupOpen || pickerSheet != nil ||
     ratioMenu != nil || (tray != nil && !trayOverlay)` (`:151-154`);
  4. `"dragging"` — `self.resizing || self.dragGhost != nil` (`:155`);
  5. `nil` → fade chạy: `ahFadedState = YES` + `ahPaintCurrentSet`
     (`AutoHide.m:173-183`).
  **Cổng KHÔNG đọc `bwKbKnownBySlot/bwKbActiveBySlot/bwKbSessionBySlot`,
  KHÔNG đọc slot, KHÔNG đọc assignment nào.**
- Biến giữ hold: `ahKbHoldState` (`AutoHide.m:39`, `static BOOL`) và
  `ahKbHoldExpiry` (`AutoHide.m:43`, `static CFTimeInterval`);
  hằng timeout `kAHKbHoldSeconds = 10.0` (`AutoHide.m:32`); nhịp idle
  `kAHIdleSeconds = 4.0` (`AutoHide.m:31`), timer một phát
  `ahArmTimer` (`AutoHide.m:127-134`); bị chặn thì log
  `[autohide] fade deferred (<reason>)` và arm lại 4.0 s
  (`AutoHide.m:165-171`).
- Đường đặt/xoá hold DUY NHẤT: **`ahNoteActWithKbActive:` —
  `AutoHide.m:242-258`**: `kbActive=YES` → `ahKbHoldState = YES`,
  `ahKbHoldExpiry = now + 10.0` (`:251-253`); `kbActive=NO` →
  `ahKbHoldState = NO` (`:254-255`); sau đó luôn gọi
  `ahNoteActivity:AHSourceApp` (`:257`).
- Caller duy nhất của nó: **`bwHandleActPacket:` —
  `BridgeWake.m:799`**: `[self ahNoteActWithKbActive:pkt.flag]`.
  Trước đó handler kiểm (`BridgeWake.m:752-799`): unpack/type
  `BWTypeAct` (:754), hash → slot qua `BWSlotForHash28`, **gen phải
  bằng gen sống của slot** (`:770`, drop `bad-gen`), `self.active`,
  pane còn assigned + hosted, state slot ≠ INACTIVE; log
  `act-accepted … kb=%d` tại `:796-798`.
- `pkt.flag` (bit 10 của gói act — `BridgeWakePack.h` phần layout:
  act packet → flag = kbActive) được tính phía app tại
  **`BWPostAct` — `ABInApp.m:322-333`**, dòng `:327-329`:
  `flag = (BWKbEffective(NULL, NULL) == BWKbActive)`.
  `BWKbEffective` (`ABInApp.m:465-484`): local ACTIVE thắng; không
  thì snapshot owner còn tươi (≤ 3.5 s, `BWKbOwnerFreshWindow`
  `ABInApp.m:431`); còn lại **UNKNOWN**. Hệ quả mã hoá: 1 bit này gộp
  ba trạng thái thành hai — `UNKNOWN` và `INACTIVE` **cùng cho
  flag=0**.
- Điều kiện phát act (mắt xích quyết định của ca này): act chỉ post
  từ **`BWActOnSequenceStart` — `ABInApp.m:368-410`**, được gọi đúng
  một chỗ: đường Began của hook `sendEvent:` (`ABInApp.m:762`), với
  các cổng: `BWActSessionVerified` phải YES (`:371`), touch phải
  thuộc hosted scene (`BWActHostedScene`, `:377-397`), throttle
  0.12 s trong `BWPostAct` (`:324`). **Mở phím không sinh touch
  Began nào trong app hosted; gõ trên panel phím phía xe thì thao
  tác phím về app qua kênh action phân tán của ABKeyboard, không qua
  chuỗi touch `sendEvent:`** → trong suốt phiên phím, nguồn act có
  thể hoàn toàn im lặng.

**Nguyên nhân:** hold là một BOOL toàn cục được *lấy mẫu theo sự
kiện chạm*, không phải trạng thái suy ra từ bản ghi kb. ACTIVE đã
biết ở owner vẫn không tự nó đặt được hold.

**Điểm sẽ sửa:** mục 3.

**Trạng thái trước/sau (mục này):** trước = cổng đọc
`ahKbHoldState/ahKbHoldExpiry` (toàn cục, do act nuôi); sau = cổng
đọc bản ghi kb theo assignment (mục 3), act thoái về vai trò activity
thuần.

### 1.3 Kết luận cơ chế — vì sao ACTIVE đã biết vẫn fade sau ~4 s

Dòng thời gian dựng lại từ code (phần đánh dấu *suy ra* là phép trừ
thời gian, không phải dòng log đọc trực tiếp):

1. ~17:32:24.08 (*suy ra*: 28.079 − 4.0 s idle) — activity cuối arm
   timer 4.0 s (`ahArmTimer`, `AutoHide.m:127-134`).
2. 17:32:24.190 — host post kb `active=1` → `bwHandleKbSyncNote:`
   ghi `known=1, active=1, session=N` (`BridgeWake.m:323-325`) →
   phát type 6 cho app. **AutoHide không được chạm tới.**
3. Trong cửa sổ 24.19 → 28.08 không có gói act `flag=1` nào qua được
   `bwHandleActPacket:` (mở phím/gõ phím xe không sinh Began trong
   app — mục 1.2), nên `ahKbHoldState` vẫn NO (hoặc hold cũ đã hết
   hạn 10 s và bị xoá tại `AutoHide.m:149`).
4. 17:32:28.079 — `ahTimerFired:` → `ahFadeBlockedReason`: solo NO,
   **kbhold NO** → các hạng tử sau cũng NO → `nil` → fade
   (`AutoHide.m:173-183`). Δ = 3.889 s ≈ đúng một chu kỳ idle.

**Điểm đứt chính xác:** giữa điểm ghi `BridgeWake.m:323-325`
(`bwKb*BySlot`) và điểm đọc `AutoHide.m:147` (`ahKbHoldState`) —
**không tồn tại đường code nào nối hai điểm này**. Cầu nối duy nhất
là bit flag của gói act (`ABInApp.m:328` → `BridgeWake.m:799` →
`AutoHide.m:242`), và cầu này (i) lấy mẫu theo sự kiện chạm chứ
không theo trạng thái, (ii) gộp UNKNOWN vào 0, (iii) im lặng đúng
trong phiên phím. Phán quyết GPT **đúng nguyên văn**.

---

## 2) BOOL toàn cục — ai giữ trạng thái kb-hold, ai xoá được của ai

**Điểm hiện tại (file:line) — kê toàn bộ biến/field giữ kb-hold /
kb-state ở cả ba TU:**

| Biến | Vị trí | Phạm vi |
|---|---|---|
| `ahKbHoldState` (BOOL) | `AutoHide.m:39` | **TOÀN CỤC** — một cho cả phiên split, không slot/assignment |
| `ahKbHoldExpiry` (CFTimeInterval) | `AutoHide.m:43` | **TOÀN CỤC** — đi cặp với trên |
| `ahFadedState`, `ahSuspendedState` | `AutoHide.m:37-38` | Toàn cục (đúng thiết kế: bộ controls là một set chung, `ahPaintCurrentSet` `AutoHide.m:103-111`) |
| `bwKbKnownBySlot[10]`, `bwKbActiveBySlot[10]`, `bwKbSessionBySlot[10]` | `BridgeWake.m:88-90` | **Theo slot** — hình dạng đúng, nhưng không có consumer ở AutoHide |
| `BWKb` (tri-state local), `BWKbOwnerKnown/BWKbOwnerActive/BWKbOwnerRxAt`, `BWKbLocalChangedAt` | `ABInApp.m:174`, `:420-422`, `:435` | Theo *tiến trình app* (mỗi app hosted một bản riêng — không lẫn nhau, nhưng cũng chỉ thoát ra ngoài qua bit act) |
| `abKbLiveBundle/abKbLiveSession/abKbSessionCounter` | `ABHostGeometry.m` (statics ngay trên `:86`) | Toàn cục phía host — host chỉ có một phiên phím sống tại một thời điểm (đúng bản chất panel) |

**Câu hỏi của strand: phiên nhập liệu của app A đóng có xoá được
hold của app B theo code hiện tại không? — CÓ, và không cần phiên A
"đóng" thật:**

- Đường xoá đích danh: bất kỳ gói act hợp lệ nào của app A với
  `flag=0` đều chạy `bwHandleActPacket:` (`BridgeWake.m:799`) →
  `ahNoteActWithKbActive:NO` → **`ahKbHoldState = NO`
  (`AutoHide.m:254-255`)** — xoá vô điều kiện, không hỏi hold do ai
  arm, không hỏi slot nào.
- `flag=0` của A xuất hiện ngay cả khi A chỉ là UNKNOWN (mục 1.2:
  UNKNOWN ≡ INACTIVE ≡ 0): một cái chạm thường trong app A (kb của A
  chưa từng mở) cũng đủ giết hold mà phiên phím của B đang cần.
- Chiều ngược cũng toàn cục: act `flag=1` của A arm hold chặn fade
  cho *toàn bộ* controls (mọi ô), kể cả khi B không hề nhập liệu —
  hệ quả nhẹ hơn nhưng cùng một gốc: hold không gắn assignment.
- Đường xoá khác: hết hạn 10 s tự xoá tại cổng (`AutoHide.m:149`) và
  `ahSessionTeardown` xoá (`AutoHide.m:345`) — hai đường này đúng
  phạm vi (hết hạn / hết phiên split).

**Nguyên nhân:** hold được mô hình hoá là BOOL phiên-split trong
khi sự thật kb là theo (slot, assignment, session).

**Điểm sẽ sửa:** hold suy ra từ bản ghi theo slot (mục 3) — xoá
"theo A" chỉ còn có thể xảy ra khi bản ghi của *chính assignment đó*
chuyển INACTIVE.

**Trạng thái trước/sau:** trước = 1 BOOL toàn cục, mọi act `flag=0`
hợp lệ đều xoá được; sau = không còn biến hold toàn cục để xoá —
mỗi assignment giữ bằng chính bản ghi của nó.

**Cách kiểm tra:** tĩnh — `grep ahKbHoldState` sau sửa phải = 0 ở
đường cổng (hoặc chỉ còn dạng theo slot); xe — hai ô cùng hosted,
mở phím ở ô B, chạm thường ở ô A: controls không được fade trong
phiên phím của B.

---

## 3) Điểm sửa theo đặc tả

### 3.1 Cổng fade đọc TRỰC TIẾP bản ghi kb theo assignment đang sống

- **Hàm sẽ đọc:** `ahFadeBlockedReason` (`AutoHide.m:140`) — giữ
  nguyên vị trí cổng (chỉ đánh giá lúc timer bắn, cùng kỷ luật
  defer-arm-lại ở `AutoHide.m:165-171`).
- **Bản ghi sẽ đọc:** `bwKbKnownBySlot/bwKbActiveBySlot` theo slot
  của từng pane đang sống. Rào kỹ thuật phải nói rõ: ba mảng này là
  **file statics của TU BridgeWake** (`BridgeWake.m:88-90`) — AutoHide
  TU hiện *không nhìn thấy* chúng và **chưa tồn tại accessor nào**
  export ra ngoài (grep toàn cây: mọi lần đọc `bwKb*` đều nằm trong
  `SCPCarSplit+BridgeWake.m`). Điểm sửa bắt buộc kèm một accessor
  mới phía BridgeWake (vd `bwKbActiveForPane:` /
  `bwAnyLiveAssignmentKbActive`), khai báo ở
  `SCPCarSplit+BridgeWake.h` — cùng tiền lệ `ahFaded` là input
  chỉ-đọc xuyên TU cho owner (`SCPCarSplit+AutoHide.h:88-92`).
- **Điều kiện ACTIVE giữ controls, diễn đạt lại:**
  > `kbhold` ⟺ ∃ pane ∈ `hostedPanes` (assignment đang sống) mà
  > `bwKbKnownBySlot[pane.slot] == YES && bwKbActiveBySlot[pane.slot] == YES`.
  > `known=0` (UNKNOWN) → **không giữ** (fail-open, mục 5).
  > `known=1, active=0` → không giữ.
  Hạng tử `"kbhold"` giữ nguyên vị trí thứ hai trong cổng (sau
  `"solo"`, trước `"surface-open"`/`"dragging"`).
- Sau sửa, `ahNoteActWithKbActive:` thoái khỏi vai trò giữ hold:
  act chỉ còn là activity F4 (`ahNoteActivity:AHSourceApp`) — bit
  flag của act không còn consumer nào ở cổng. (Giữ handler
  `bwHandleActPacket:` nguyên kỷ luật gen/hash — nó vẫn là nguồn
  activity hợp lệ.)

### 3.2 Hold theo PHIÊN NHẬP LIỆU của từng assignment

- **Mở phiên:** chuyển đổi bản ghi của slot sang ACTIVE tại
  `bwHandleKbSyncNote:` (nhánh `changed`, `BridgeWake.m:320-336`) —
  từ thời điểm đó cổng (3.1) tự giữ, không cần biến hold riêng,
  không còn hạn 10 s nhân tạo: phiên sống bao lâu, giữ bấy lâu
  (đúng bất biến của đặc tả; hạn 10 s `kAHKbHoldSeconds`
  `AutoHide.m:32` là cơ chế của mô hình act và mất lý do tồn tại).
- **Đóng phiên:** gói kbsync `active=0` **xác thực** cho chính slot
  đó — host post kèm id phiên bị đóng (`ABHostGeometry.m:99-113`),
  owner đối chiếu `session` với `bwKbSessionBySlot[slot]` (điều
  kiện xác thực này hiện chưa được kiểm — xem mục 4) → bản ghi
  thành `known=1, active=0` → cổng hết giữ *của assignment đó*,
  các assignment khác không bị đụng.
- **Bắt đầu idle mới tại đóng phiên — hiện có đường như vậy KHÔNG?**
  **Không.** `bwHandleKbSyncNote:` không gọi AutoHide ở bất kỳ
  nhánh nào; chuyển ACTIVE→INACTIVE trong bản ghi hiện không sinh
  bất kỳ tác động nào lên `ahLastActivityAt`/`ahTimerRef`. Đường
  gần nhất đang tồn tại là đường act: `ahNoteActWithKbActive:NO`
  → `ahNoteActivity:` (`AutoHide.m:257` → `:232-240`) có arm lại
  timer — nhưng nó chạy theo chạm của app, toàn cục, và không gắn
  với sự kiện đóng phiên.
  **Điểm sẽ sửa:** trong `bwHandleKbSyncNote:`, tại chuyển đổi
  `active 1→0` của một slot, gọi một entry mới phía AutoHide (vd
  `ahNoteKbSessionEndedForSlot:`) làm đúng hai việc: (i) không còn
  giữ cho slot đó (tự suy ra từ bản ghi nếu theo 3.1), (ii) đóng dấu
  `ahLastActivityAt = now` + `ahArmTimer` — idle 4.0 s *mới* tính từ
  lúc đóng phím, không phải từ activity trước khi mở phím (tránh
  fade tức thì ngay khi đóng phím vì đồng hồ cũ đã quá hạn), cũng
  không phải 10 s đuôi hold như mô hình act.

**Trạng thái trước/sau (mục 3):**

| | Trước (HEAD 38735c5) | Sau (đặc tả) |
|---|---|---|
| Nguồn của cổng | `ahKbHoldState` toàn cục ← act flag | `bwKb*BySlot` của assignment đang sống |
| Mở phiên giữ | chỉ khi act flag=1 tới kịp + 10 s/lần refresh | ngay khi bản ghi = ACTIVE, suốt phiên |
| Đóng phiên | act flag=0 của *bất kỳ* app nào, hoặc hết hạn 10 s | INACTIVE xác thực của *chính* assignment |
| Idle sau đóng | không có mốc riêng (đồng hồ từ activity cuối, có thể đã quá hạn → fade gần như tức thì khi hold rơi) | idle 4.0 s mới từ mốc đóng phiên |
| UNKNOWN | gộp thành flag=0 → xoá hold của người khác | không giữ, không xoá gì — fail-open (mục 5) |

**Cách kiểm tra:** tĩnh — cổng tham chiếu accessor kb theo slot;
handler kbsync có nhánh chuyển 1→0 gọi entry AutoHide; không còn
đường ghi hold từ act. Xe — kịch bản GPT bước 3 (mục 6).

---

## 4) Reset theo assignment — gen, reset UNKNOWN, snapshot cũ

### 4.1 Gen tăng ở đâu; ca gán lại CÙNG bundle CÙNG slot

**Điểm hiện tại (file:line):**

- Điểm tăng gen DUY NHẤT cho assignment thường:
  **`bwRecomputeForPane:` — `BridgeWake.m:470-472`**:
  ```objc
  if (![bundle ?: @"" isEqualToString:bwBundleBySlot[slot] ?: @""]) {
      bwGenBySlot[slot] = bwGenBySlot[slot] ? BWGenNext(bwGenBySlot[slot]) : 1;
  ```
  `BWGenNext` = `gen % 4095 + 1` (`BridgeWake.m:115`); assignment
  đầu tiên của slot = 1. Điều kiện là **so chuỗi bundle**: chỉ khi
  chuỗi bundle của pane *khác* chuỗi đang lưu trong
  `bwBundleBySlot[slot]` tại thời điểm recompute chạy.
- Điểm tăng gen thứ hai: `bwSessionTeardown` (`BridgeWake.m:571-582`):
  mọi slot đã biết đều `BWGenNext` (`:574`), bundle → nil (`:577`).
- Các điểm gán phía `SCPCarSplit.m`: hosted `hostApp:inPane:`
  (`:1902`; `pane.bundleID = nil` `:1907`, `pane.bundleID = bundleID`
  `:1916`), native attach (`pane.bundleID = bundle` `:1172`), các
  điểm clear `:1146`, `:1547`, `:1747`. Các điểm gọi recompute liên
  quan: `hostClose:` (`:1877-1878`), block +0.05 s của `hostApp:`
  (`:1947`), `:2044`, `:2065`.
- **Trả lời ca cùng-bundle cùng-slot: KHÔNG tăng gen.** `hostApp:inPane:`
  nil hoá rồi gán lại *cùng một chuỗi* bundle; `bwBundleBySlot[slot]`
  không hề bị nil hoá ở giữa, nên khi `bwRecomputeForPane:` chạy
  (block +0.05 s, `:1947`), phép so tại `BridgeWake.m:470` cho kết
  quả *bằng* → không bump, không reset kb. Hệ quả: **snapshot kb của
  assignment trước sống sót sang assignment mới** cùng bundle/slot —
  sai với nguyên tắc "snapshot thuộc về một cặp (bundle,
  assignment)". (Gen chỉ bump trong ca này nếu tình cờ có một lần
  recompute chạy đúng lúc `pane.bundleID == nil` — không có điểm gọi
  nào được nối vào các điểm clear `:1547/:1747` để đảm bảo điều đó;
  `hostClose:` `:1878` recompute *trước* khi bundle bị clear.)
- **Điểm sẽ sửa:** bump gen (và reset kb) phải gắn với *sự kiện gán*
  chứ không với *delta chuỗi*: tại các điểm gán trong
  `SCPCarSplit.m` (`hostApp:inPane:` `:1902-1916`, attach `:1172`)
  cần một thông báo assignment-mới tường minh cho owner (vd
  `bwNoteAssignmentForPane:`), hoặc owner tự bump khi thấy pane đi
  qua trạng thái unassign→assign dù chuỗi không đổi. Tiêu chí chấp
  nhận: gán lại cùng bundle cùng slot → gen tăng đúng 1, kb về
  UNKNOWN.

### 4.2 Bản ghi kb reset UNKNOWN ở những trigger nào (hiện tại — toàn bộ)

Đúng hai trigger phía owner:

1. Khối đổi bundle trong `bwRecomputeForPane:` —
   `BridgeWake.m:478-480`: `known=NO, active=NO, session=0`
   (đi kèm bump gen `:471` — và vì vậy cũng **không** chạy trong ca
   cùng-bundle ở 4.1).
2. `bwSessionTeardown` — `BridgeWake.m:580-582`: mọi slot đã biết.

Ngoài ra không còn trigger nào: không reset khi pane close lẻ
(`hostClose:` không reset kb nếu bundle chưa đổi), không reset khi
snapshot quá già (owner không có khái niệm tuổi của bản ghi — khác
phía app, nơi snapshot hết tươi sau 3.5 s tại `ABInApp.m:431,474-475`).
Phía app, bản sao kb bị xoá tại `BWResetAll` (`ABInApp.m:884-906`,
đường close/closeall) — đó là bản sao phía app, không phải bản ghi
owner.

### 4.3 Snapshot cũ vô hiệu bằng cơ chế gì; gói cũ có cập nhật được phiên mới không

Chia theo từng chân truyền — kết quả **không đồng đều**:

| Chân | Cơ chế kiểm | Gói cũ (gen/session cũ) cập nhật phiên mới? |
|---|---|---|
| act (app → owner) | hash → slot + **`pkt.gen == bwGenBySlot[slot]`** (`BridgeWake.m:770`) + pane còn assigned/hosted | **Không** — drop `bad-gen` |
| wake / ack (app/host → owner) | cùng kỷ luật gen (`BridgeWake.m:671`, `:810`) + seq transaction | **Không** |
| kb type 6 (owner → app) | `BWGenAccept` phía app (`ABInApp.m:448-450`: bằng hoặc tiến trong modulo 4096) | **Không** (gen cũ bị drop) |
| **kbsync (host → owner)** | **chỉ so chuỗi bundle** với `bwBundleBySlot` (`BridgeWake.m:309-313`) | **CÓ — lỗ hổng** |

Chi tiết lỗ hổng kbsync: payload kbsync **không mang gen**
(`ABHostGeometry.m:88-93` chỉ có identifier/kbactive/kbsession/
kbsource), và handler **không kiểm thứ tự session**: ba dòng ghi
`BridgeWake.m:323-325` là vô điều kiện — biến `changed`
(`:320-322`) chỉ quyết định log + phát lại, không quyết định ghi.
Kịch bản hỏng cụ thể: đóng phiên N (post `active=0, session=N`) bị
trễ, tới *sau* post mở phiên N+1 (`active=1, session=N+1`) của cùng
bundle → bản ghi bị ghi đè thành `known=1, active=0, session=N` —
owner tin phím đã đóng trong khi phiên N+1 đang sống; theo cổng đặc
tả (mục 3) lỗi này sẽ trực tiếp làm fade giữa phiên nhập liệu.
Phía host, funnel có kỷ luật riêng (đóng chỉ xoá bản ghi sống khi
đúng bundle — `ABHostGeometry.m:105-111`) nhưng kỷ luật đó không
bảo vệ thứ tự đến phía owner.

**Điểm sẽ sửa:** handler kbsync phải từ chối `session` không tiến
(`session <= bwKbSessionBySlot[slot]` khi bản ghi đã known và
session đã lưu ≠ 0, trừ snapshot mở assignment mới sau reset —
reset đưa session lưu về 0 nên snapshot hợp lệ vẫn qua), và/hoặc
kbsync mang thêm gen của assignment để kiểm như act. Đây là điều
kiện tiên quyết trước khi cổng fade được phép tin bản ghi (mục 3):
chuyển cổng sang đọc bản ghi mà không vá chân này là chuyển điểm
đứt từ "không nối" sang "nối bằng dữ kiện có thể bị ghi đè cũ".

**Cách kiểm tra (mục 4):** tĩnh — đọc lại handler: có điều kiện
session/gen trước ba dòng ghi; có đường bump gen cho ca
cùng-bundle. Xe — đóng app khỏi ô rồi gán lại chính app đó vào
chính ô đó, chưa mở phím: log phải cho gen tăng + bản ghi kb
UNKNOWN (không phải ACTIVE/INACTIVE sót từ assignment trước).

---

## 5) Đối chiếu nguồn mới — sau khi panel vẽ tắt, kb tới owner bằng đường nào TRONG CÂY HIỆN CÓ

Phạm vi mục này: chỉ liệt kê transport *đang tồn tại trong cây*,
không đề xuất kênh mới. "Panel vẽ" = panel bàn phím tự vẽ ABKeyboard
phía ABHost (SpringBoard).

### 5.1 Kê mọi kênh app → owner / host → owner đang tồn tại và dữ kiện kb mỗi kênh mang được

| # | Kênh | Tiến trình → tiến trình | File:line | Dữ kiện kb HIỆN mang được |
|---|---|---|---|---|
| 1 | Darwin `bridgewake.v1.act` (type 5) | app hosted → owner (CarPlayApp) | tên kênh `SCPShared.m:38` / `ABInApp.m:124`; phát `BWPostAct` `ABInApp.m:322-333`; nhận `bwHandleActPacket:` `BridgeWake.m:752-799` | **1 bit duy nhất**: flag = `BWKbEffective == ACTIVE` tại thời điểm post. UNKNOWN bị gộp thành 0; chỉ post tại Began của chuỗi touch, throttle 0.12 s |
| 2 | Darwin `bridgewake.v1.query` (type 2) | app → owner | phát `BWSendQuery` `ABInApp.m:271-278`; nhận `bwHandleQueryPacket:` `BridgeWake.m:~646-661` | **Không mang kb lên**: gói chỉ có hash/seq/gen. Nó *kích* owner phát ngược state + kb type 6 xuống app (`:658-660`) — chiều kb là owner → app |
| 3 | Darwin `bridgewake.v1.state` + gói kb type 6 | owner → app (chiều xuống) | `BWEmitKbPacket` `BridgeWake.m:190-203`; nhận `BWOnKbPacket` `ABInApp.m:448-455` | Mang đủ known/active — nhưng cho **cổng suppression phía app**, không phải đầu vào của owner/AutoHide |
| 4 | NSDistributed `appbridge.kbsync` | ABHost (SpringBoard) → owner (CarPlayApp) | post `ABHostGeometry.m:86-97`; nhận `BridgeWake.m:302-338`, đăng ký `:887-892` | **Đủ nhất**: `{identifier, kbactive, kbsession, kbsource}` — NHƯNG nguồn của nó là *phiên panel tự vẽ*: chuỗi sản xuất là responder phía app → `ABKeyboardPublish` (Darwin `appbridge.keyboard`: shown/type/return/hash, `ABInApp.m:1782-1799`, gọi từ `ABResponderBecame/Resigned` `:1731-1755`) → `ABKeyboardDispatch` (`ABHostGeometry.m:208-235`) show/hide **panel ABKeyboard** → `ABKbSyncNoteEvent`. Nó quan sát vòng đời panel tự vẽ, không quan sát bàn phím hệ thống nào |
| 5 | NSDistributed `appbridge.state` (host funnel) | ABHost → CarPlayApp | `ABPostStateToApp` `ABHostGeometry.m:60-65`; consumer `SCPHooks.m:530-535` → `hostedApp:state:` `SCPCarSplit.m:1976` | `{identifier, state ∈ ready/failed/gone}` — **0 trường kb** |
| 6 | Các funnel host → car còn lại: `appbridge.handletap/handledrag/baraction/bardismiss/knobtouch` | ABHost → CarPlayApp | hằng số `SCPShared.m:23-27`; đăng ký `SCPHooks.m:830-838` | Sự kiện activity/chạm — **0 trường kb** |
| 7 | `hostPost:` (funnel chiều car → host: open/frame/close/knobs/shield…) | CarPlayApp → ABHost | `SCPCarSplit.m:1867-1870` | Chiều ngược; không phải nguồn kb cho owner |
| — | Quan sát phím *hệ thống* phía app: `UIKeyboard*Notification` | nội bộ tiến trình app | `BWKbFrameNote` `ABInApp.m:566-571`, `BWKbHideNote` `:573-577`, setter `BWKbLocalSet` `:436-440`; hooks responder `:1731-1755` | Quan sát này **không có đường ra khỏi tiến trình app** ngoài bit act của kênh #1. Chính comment trong cây đã cảnh báo độ tin cậy của nó khi hosted: "the car keyboard lives in SpringBoard behind a blank inputView, so the system notifications may not fire at all in this process" (`ABInApp.m:562-565`) |

### 5.2 Kết luận nguồn

**Trong cây hiện có, KHÔNG có nguồn quan sát bàn phím hệ thống nào
chảy vào cổng này.** Nguồn kb xác thực duy nhất (kênh #4) đo vòng
đời của chính panel tự vẽ: `ABKeyboardDispatch` là điểm quản lý
panel đó, và mọi post kbsync đều treo trên show/hide/snapshot của
nó. (Ghi nhận giới hạn đọc: tại HEAD `38735c5`, trong các file thuộc
phạm vi strand này **không thấy công tắc/pref nào tắt panel
ABKeyboard** — điểm cắt "panel vẽ tắt" nằm ngoài cây/phạm vi đã đọc;
kết luận dưới đây đúng với mọi điểm cắt nằm trên chuỗi
dispatch → show/hide của ABKeyboard, vì đó là nơi duy nhất sinh
kbsync.)

Hệ quả vận hành theo đặc tả — **ghi là hệ quả đã biết, không phải
lỗi mới phát hiện**:

- Khi panel tự vẽ tắt và app dùng bàn phím hệ thống/gốc: không còn
  post kbsync nào cho các chuyển đổi mở/đóng (chỉ còn snapshot lúc
  open, `ABHostGeometry.m:120-125`, cho `known=1, active=0` tại thời
  điểm gán — hoặc UNKNOWN hẳn nếu cả snapshot cũng theo panel mà
  tắt). Bản ghi owner đứng yên ở **UNKNOWN** (hoặc INACTIVE-đứng-yên).
- Cổng fade theo đặc tả (mục 3.1) đọc UNKNOWN → **không giữ —
  fail-open**: AutoHide fade bình thường sau 4.0 s idle ngay cả khi
  người dùng đang nhập liệu bằng phím hệ thống. Đây là hành vi đã
  được đặc tả chấp nhận tường minh (UNKNOWN không bao giờ được đọc
  thành INACTIVE-có-bảo-đảm, và cũng không được bịa thành ACTIVE).
- Cùng nguyên tắc phía app: suppression giữ **UNKNOWN → fail-open**
  (`BWKbEffective` trả UNKNOWN khi không có bằng chứng tươi —
  `ABInApp.m:465-484`; cổng nuốt chỉ chặn khi có ACTIVE/known thật).
- Nói cách khác: sau khi panel vẽ tắt, tính năng "kb giữ controls"
  **tắt một cách trung thực** cho tới khi có một nguồn quan sát phím
  hệ thống thật được nối vào — strand này không bịa nguồn đó, và
  đặc tả không cho phép suy đoán thay thế.

---

## 6) Cách kiểm tra tổng

**Tĩnh (trên cây, trước/sau sửa):**

1. `grep -n "bwKb" SCPCarSplit+AutoHide.m` — trước: 0 hit (điểm
   đứt). Sau: cổng phải tham chiếu accessor kb theo slot.
2. `grep -n "ahKbHoldState" SCPCarSplit+AutoHide.m` — sau: không
   còn là đầu vào của cổng (hoặc chỉ còn dạng theo assignment).
3. Đọc `bwHandleKbSyncNote:` — sau: có kiểm session/gen trước khi
   ghi (`:323-325`) và có nhánh chuyển ACTIVE→INACTIVE gọi entry
   reset-idle của AutoHide.
4. Đọc `bwRecomputeForPane:` + điểm gán `SCPCarSplit.m:1902-1916` —
   sau: ca gán lại cùng bundle cùng slot vẫn tăng gen + reset kb
   UNKNOWN.
5. `bwHandleActPacket:` giữ nguyên kỷ luật gen/hash; act không còn
   consumer hold nào (`ahNoteActWithKbActive:` hoặc biến mất, hoặc
   chỉ còn chuyển tiếp activity).

**Xe (kịch bản GPT, gộp một phiên):**

- **Bước 3a — phím mở quá 4 s, controls vẫn hiện:** mở app hosted,
  mở phím (panel tự vẽ — nguồn kb đang có), không chạm thêm; quá
  4.0 s (và quá cả 10 s để loại đuôi hold cũ) controls vẫn hiện.
  Log kỳ vọng: `[kb-sync] change … active=1` → (nếu timer bắn)
  `[autohide] fade deferred (kbhold)` lặp theo chu kỳ — và **không**
  có `[autohide] fade` khi phím còn mở. (Bản hiện tại tại đúng bước
  này cho `[autohide] fade` sau ~4 s — chính là ca 17:32.)
- **Bước 3b — đóng phím, AutoHide chạy lại:** đóng phím → log
  `[kb-sync] change … active=0` + mốc reset idle mới → `[autohide]
  fade` sau ~4.0 s kể từ lúc đóng (không fade tức thì, không chờ
  10 s hold cũ).
- **Bước 4 — cùng assignment, đường đánh thức sau đóng phím:** sau
  khi fade ở 3b, chạm đầu lên vùng app/controls của *chính
  assignment đó*: đường wake/act hiện hữu phải nuốt chạm đầu + hiện
  controls (log `act-accepted` / reveal tương ứng), chứng minh việc
  nối cổng vào bản ghi không phá đường đánh thức vốn có; kèm kiểm
  phụ của mục 2: trong lúc một ô khác đang mở phím, chạm thường ở ô
  này không được làm fade controls.

---

## Nhãn

**SOURCE-PROVEN** — cho phần chẩn đoán (mục 1, 2, 4, 5): mọi khẳng
định đều trỏ tới file:line đọc trực tiếp từ HEAD `38735c5`; điểm đứt
kb-sync ↔ AutoHide, tính toàn cục của hold và đường xoá chéo-app,
ca cùng-bundle không tăng gen, và lỗ hổng không-kiểm-gen/session
của chân kbsync đều chứng minh được từ source. Phán quyết GPT về ca
17:32:24.190 → 17:32:28.079 được xác nhận nguyên văn.

**PENDING-DEVICE** — cho phần điểm sửa (mục 3): đây là strand
chỉ-đọc, chưa build bản sửa, chưa test xe; hiệu lực của cổng-đọc-bản-ghi
chỉ chốt được bằng kịch bản bước 3/bước 4 ở mục 6 trên xe thật.
Riêng điểm cắt "panel vẽ tắt" ở mục 5 không nằm trong cây tại HEAD
này — kết luận fail-open-UNKNOWN là hệ quả đã biết theo đặc tả,
không phụ thuộc vào điểm cắt cụ thể.

Không có mục nào STUCK: mọi câu hỏi của strand đều trả lời được từ
source trong cây.
