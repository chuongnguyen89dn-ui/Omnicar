# CÀI ĐẶT WAKE — PHÍA CARPLAY (owner + phân xử) — [wake1]

Ngày: 2026-11-09. Strand CarPlay theo `design-bridgewake.md` §0–§4 + §6/§7.1.
Trạng thái: **source xong, build module sạch, cổng tĩnh §7.1 (phần CarPlay) đạt,
unit test vector §3.4 đạt 19/19**. Chưa tích hợp candidate, chưa lên xe.

## EXPANDED — hệ quả A1 (BLOCKED)

`a1-fullscreen-entry.md` kết luận FULLSCREEN_ENTRY = BLOCKED: dylib QA20
không vào candidate, **không có nguồn nào cấp trạng thái expanded trong vòng
này**. Interface `bwSetExpandedActive:forBundle:` / `bwExpandedActive` vẫn
cài đúng thiết kế §2.1 làm điểm nối tương lai; đầu vào giữ mặc định NO (SPLIT)
vĩnh viễn trong vòng này, nên hàng EXPANDED của bảng phân xử §2.2 không bao
giờ kích hoạt trên xe cho tới khi có producer hợp lệ.

## File thay đổi (cả hai cây, cmp identical — xem cuối)

### MỚI: `OmniCarSplitScreen/BridgeWakePack.h`
Bản module này của header dùng chung §3: layout uint64 nguyên văn §3.2,
`BWPackFields`/`BWUnpack`, `BWBundleHash` (FNV-1a, cùng thuật toán
ABBundleHash), luật chuẩn hoá (mode 3 → OFF, state 5–7 → UNKNOWN), bảng
vector V1–V8 chép nguyên văn §3.4 ở cuối file. Lõi pack thuần C
(`BW_PACK_NO_FOUNDATION` tắt phần NSString) để harness Gate 1 chạy trên VM.
Tích hợp diff với bản AppBridge: phải = 0.

### MỚI: `OmniCarSplitScreen/SCPCarSplit+BridgeWake.h`
Khai báo category `(BridgeWake)` + 4 extern tên kênh. Lý do không khai trong
SCPCarSplit.h/SCPCarPane.h: phạm vi file của strand giới hạn ở TU mới + các
điểm gọi; hệ quả là **trạng thái owner theo slot (gồm `bwGenBySlot[10]` và
bwState) nằm ở file statics trong TU BridgeWake, khóa theo `pane.slot`
0..9** thay vì ivar mới. Hành vi khớp thiết kế; tích hợp muốn dời vào header
chính thì chỉ là di chuyển khai báo.

### MỚI: `OmniCarSplitScreen/SCPCarSplit+BridgeWake.m` (521 dòng)
- Statics + helpers: dòng 28–105 (`bwGenBySlot[10]` dòng 30; vòng seq đã xử
  lý 16/slot §3.3 kèm đếm chống khớp giả seq 0).
- Phát state: `BWEmitStatePacket` tĩnh dòng 111 — **cặp
  notify_set_state/notify_post duy nhất cho kênh state trong module**;
  `bwEmitStateForPane:` dòng 169 là method công khai duy nhất dẫn vào đó;
  `BWForceOffBroadcast` (§4, lỗi phía owner) dòng 130 dùng chung đường này.
- Hàng đợi phát cách 30 ms (§3.3(i)): dòng 137–167 (`bwQueueEmitForPane:`,
  drain).
- Phân xử §2: `bwPopupForPane:` dòng 194, `bwPinchAllowedForPane:` dòng 202,
  `bwSetExpandedActive:forBundle:` dòng 217, `bwExpandedActive` dòng 227.
- Tổng hợp §1.3: `bwRecomputeForPane:` dòng 231–309.
- `bwSessionTeardown` dòng 311; modes §4 `bwReloadModesAndRepublish` dòng 337.
- Giao thức vào: `bwHandleQueryPacket:` 364, `bwHandleWakePacket:` 372,
  `bwHandleAckPacket:` 442; `bwInstallOwner` dòng 481 (đăng ký nhận
  query/wake/ack + prefschanged, main queue, notify_get_state trong block).

### `OmniCarSplitScreen/SCPShared.m`
- Dòng 33–36: 4 hằng `const char *` kênh bridgewake.v1 (state/query/wake/ack),
  chuỗi khớp §3.1 từng byte; khai báo extern ở SCPCarSplit+BridgeWake.h.

### `OmniCarSplitScreen/SCPCarSplit+Chrome.m` (chỉ thêm lời gọi + import dòng 20)
- Dòng 296: cuối `layoutBarForPane:` (§1.3 điểm 2).
- Dòng 336: cuối nhánh hiện của `setBarVisible:forPane:` (§1.3 điểm 1).
- Dòng 358: trong completion fade ẩn, cạnh `pushHostFramesLive:NO` (§1.3 điểm 1).
- Dòng 361: ngay sau lệnh animate của nhánh ẩn — thời điểm quyết định ẩn,
  fade đang bay → recompute ra transient/UNKNOWN (§1.3 điểm 1).
- **Thân `setBarVisible:forPane:` không sửa gì khác** (gate §7.1 đạt — xem dưới).

### `OmniCarSplitScreen/SCPCarSplit.m` (chỉ thêm lời gọi + import dòng 26)
- Dòng 247: `dashboardInvalidated` ngay sau `self.active = NO` →
  `bwSessionTeardown` (điểm "setActive:NO" của §1.3 nhóm 3).
- Dòng 1823: `hostClose:`; dòng 1831: vòng hostedPanes trong `hostCloseAll`;
  dòng 1985: `endHostedSolo` (nhóm 3).
- Dòng 1891: khối +0,05 s của `hostApp:inPane:` sau khi cache hostHandle/hostBar
  (nhóm 3).
- Dòng 2006: cuối `sendHostFrameForPane:live:` sau khi hostHandle được gán lại
  (§1.3 điểm 4).

### `OmniCarSplitScreen/SCPHooks.m` (chỉ __init_1 + import dòng 17)
- Dòng 784: cuối `SCPInitDashboardHooks` → `[[SCPCarSplit shared] bwInstallOwner]`.

### `OmniCarSplitScreen/Makefile`
- Dòng 13: thêm `SCPCarSplit+BridgeWake.m` vào FILES.

## Ánh xạ quyết định cài đặt (điểm thiết kế mơ hồ → cách chốt, để GPT kiểm toán)

1. **`assigned(p)`** gồm thêm `self.active`: thiết kế §1.2 viết assigned =
   thuộc hostedPanes + bundleID != nil; nhưng điểm "setActive:NO" bắt buộc
   trạng thái INACTIVE *ổn định* sau teardown — nếu không tính `active`,
   recompute chạy trong phần còn lại của dashboardInvalidated sẽ lật pane về
   VISIBLE/HIDDEN. Đã gồm `self.active` và ghi rõ ở đây.
2. **`liveSeen`** suy từ dữ kiện có sẵn: `!CGRectIsNull(pane.hostFrame)` —
   hostFrame là CGRectNull từ lúc cài pane tới khi có frame info đầu tiên
   (khối +0,05 s hoặc sendHostFrameForPane:), đúng nghĩa "chưa từng tính live".
3. **transient fade** phát hiện tại chỗ: trong fade ẩn, `bar.isHidden` còn NO
   nhưng model `bar.alpha == 0` (khối animations đã chạy đồng bộ) → transient.
   Không cần biến phụ; completion khôi phục alpha = 1 rồi mới recompute.
4. **`popup(p)`** = `panelOpen` (tray/ratioMenu/pickerSheet) **hoặc** bar của
   pane *khác* đang hiện. Không dùng `popupOpen` vì nó gồm bar của chính pane
   qua anyBarVisible — sẽ cấm pinch đúng ở hàng SPLIT+VISIBLE.
5. **Phát lại khi packet đổi hình**: recompute phát khi *chữ ký phát* (state +
   pinchAllowed + 2 mode + gen) đổi, không chỉ khi state đổi — nếu không, đổi
   mode/EXPANDED mà state đứng yên sẽ không bao giờ tới app (§1.3 điểm 6).
   Query vẫn ép phát lại qua hàng đợi (§1.3 điểm 7).
6. **Wake khi state == VISIBLE**: vẫn gọi đường hiện bar (gia hạn timer 4 s —
   đúng luật §2.3 "handler wake chỉ gọi đường hiện bar") và ack role=0 ngay,
   *không* mở giao dịch WAKING: setBarVisible:YES khi bar đã hiện không đẩy
   frame (wasHidden = NO) nên ABHost không có frame để confirm trong 800 ms,
   mở giao dịch chỉ tổ nhận confirm UNKNOWN oan. Khi state == HIDDEN mới mở
   WAKING + hạn 1,0 s (§6). Wake ở state khác (UNKNOWN/WAKING/INACTIVE) bị bỏ
   + đếm — fail-open phía app theo hạn ack 1,5 s của nó.
7. **Allowlist pinch** đọc từ pref `bridgewake.pinchAllowlist` (mảng chuỗi;
   vắng = rỗng = không app nào được pinch) — thiết kế §2.2 chỉ đặt tên tập
   `bwPinchAllowlist`; nguồn này khớp luật mặc định-tắt của GPT (quyết định
   A4) và cùng cơ chế prefs với hai mode.
8. **Hai luật cách ly §2.3**: TU mới không chứa đường pinch nào; handler wake
   chỉ gọi `setBarVisible:YES` (grep: đúng 1 lời gọi setBarVisible trong file,
   dòng 409), không đụng barTimer trực tiếp, không gọi solo/zoom (grep
   toggleZoom/soloBundle/runSolo/orientation/keyboard/apporient = 0).

## Test vector §3.4 (Gate 1 — harness C trên VM, header thật)

Harness biên dịch `BridgeWakePack.h` (lõi C) bằng clang-18 trên VM và kiểm:
hash tham chiếu yt = 0xD3B4E0DF, vm = 0x2E775677; pack V1–V7 khớp hex thiết kế
từng vector (0xE9DA706832803859 / …3E91 / 0x973BAB3800800002 / …3803 / …3814 /
…3C14 / …3003); unpack cả 7 hex literal ra đúng trường; V8 unpack(0) →
valid=0; mode 3 → OFF, state 7 → UNKNOWN. **Kết quả: 19/19 PASS**
(harness: /tmp/bwtest2/test.c, chạy lại bất cứ lúc nào).

## Build

Toolchain kiểm trước: clang-18 ✓, ldid ✓, /usr/bin/ld.lld → ld.lld-18 ✓,
Theos ✓ (không phải khôi phục). `make clean; make` module OmniCarSplitScreen:
**sạch** — SCPCarSplit+BridgeWake.m biên dịch 0 warning riêng (các warning còn
lại đều có từ trước ở file khác); dylib 1.103.208 B (nền trước sửa 1.074.536 B);
strings trong dylib chứa đủ 4 tên kênh bridgewake.v1 + các format [wake1].

## Cổng tĩnh §7.1 (phần CarPlay) — kết quả đo trên cây sau sửa

- `notify_post(SCPBridgeWakeState)`: **1** chỗ, trong SCPCarSplit+BridgeWake.m;
  không file nào khác trong module tham chiếu kênh state ngoài SCPShared.m
  (nơi định nghĩa chuỗi).
- NSTimer mới: **0** trong TU mới. SCPDispatchAfter chỉ có 2 hạn: 0,03 s (hàng
  đợi phát) và 1,0 s (hạn WAKING §6) — đúng hai ngoại lệ thiết kế cho phép.
- Thân `setBarVisible:forPane:`: chỉ thêm 3 lời gọi (nhánh hiện, sau animate
  nhánh ẩn, trong completion) — không câu lệnh gốc nào bị sửa/xoá.
- Đường orientation/keyboard/hostPost: hiện hữu: **không đụng** (diff các file
  sửa chỉ gồm các dòng liệt kê ở trên).
- Hai cây: BridgeWakePack.h, SCPCarSplit+BridgeWake.h,
  SCPCarSplit+BridgeWake.m, SCPShared.m, SCPCarSplit.m, SCPHooks.m —
  **cmp identical** project/ ↔ src/SplitScreenA/. SCPCarSplit+Chrome.m và
  Makefile không tồn tại ở cây src (cây src chỉ giữ tập con file của đợt
  khôi phục A) nên chỉ sửa ở project/ — tích hợp lưu ý khi đối chiếu hai cây.

## Còn mở cho tích hợp / strand khác

- diff BridgeWakePack.h với bản AppBridge (strand ABInApp) phải = 0; nếu lệch,
  lấy bản này làm chuẩn (đã qua vector) hoặc báo lại.
- Chuỗi 4 kênh ở ABChannelNames.m phải khớp SCPShared.m dòng 33–36.
- EXPANDED chưa có producer (A1 BLOCKED) — xem mục đầu.
- Chưa candidate, chưa Gate 2; modes mặc định DRY_RUN đúng §4/§IX (vắng pref =
  1) — candidate đầu không được đặt pref ENFORCE.
