# AUTOHIDE — CÀI ĐẶT PHÍA CARPLAY PHẦN 2 (điểm gọi + nối owner wake)

Ngày: 2026-11-09. Phạm vi strand: các điểm gọi trong `SCPCarSplit.m`,
`SCPCarSplit+Chrome.m`, `SCPCarSplit+Layout.m`, `SCPCarSplit+Divider.m`,
nối owner trong `SCPCarSplit+BridgeWake.h/.m`, hằng kênh trong
`SCPShared.m`, cài đặt trong `SCPHooks.m`, TU trong `Makefile`.
Cả hai cây project/ + src/ — mirror `cmp` identical 8/8 file đã sửa.
Mọi tên method theo giao diện CHÍNH THỨC ở impl-autohide-car1.md §4
(khớp tuyệt đối, không tên giả định nào phải sửa):
`ahInstall`, `ahSessionStarted`, `ahSessionTeardown`,
`ahNoteActivity:` (AHSourceHostHandle/HostKnob/Home/DragEnd),
`ahNoteActWithKbActive:`, `ahRevealWithReason:` (AHRevealWake),
`ahSetSuspended:`, `ahReloadConfig`, `ahFaded`,
`ahApplyCurrentStateToView:`; phía BridgeWake thêm `bwHandleActPacket:`
+ hằng `SCPBridgeWakeAct`.

## 1. Điểm nối theo file (số dòng trên bản cuối, cây project/)

**SCPCarSplit.m**
- `:133` — `ahSessionStarted` trong `activateWithCount:`, ngay sau
  `self.active = YES` (:132) — xem mục 2.
- `:252` — `ahSessionTeardown` cạnh `bwSessionTeardown` trong
  `dashboardInvalidated` (chỉ cộng; dòng pinch detach + `fsSessionDidEnd`
  của FS1 giữ nguyên).
- `:2062` — `hostFrameInfo:` cộng `info[@"fade"] = @([self ahFaded])`
  ngay sau merge `hostBarInfoForPane:` (chỉ khi pane != nil — nhánh
  `if (!pane) return info;` ở trên không đổi). Key gốc nguyên công thức.
- `:2532` — F2: cuối `bridgeHandleTapped:` →
  `ahNoteActivity:AHSourceHostHandle` (đúng vị trí "cuối method" của
  bảng nối dây car1 §4.4).
- `:2651–2656` — `publishKnobsNow`: payload cộng `@"kfade":
  @([self ahFaded])` cạnh `@"knobs"`.
- `:2993` — cuối `refreshHomeButton`:
  `ahApplyCurrentStateToView:self.homeButton` (mục 3).
- `:3010` — F3: đầu `homeButtonTapped` →
  `ahNoteActivity:AHSourceHome`.

**SCPCarSplit+BridgeWake.m / .h**
- `bwRecomputeForPane:` (:300–310) — hợp phần faded: chỉ trong nhánh
  `barHidden`, `fadedEffective = !bwAutoHideEnabled || [self ahFaded]`;
  popup → UNKNOWN (như cũ); fadedEffective → HIDDEN; bar đã ẩn nhưng
  chưa mờ → VISIBLE (handle/knob/logo còn trên màn hình thì chưa phải
  HIDDEN; wake rơi vào cửa sổ này vẫn hiện bar theo đường chấp nhận và
  ack ngay). AutoHide tắt ⇒ fadedEffective = YES cố định ⇒ định nghĩa
  HIDDEN **y hệt wake1** (luật tương thích §3.3).
- `bwAutoHideEnabled` (static, mặc định YES) nạp trong
  `bwReloadModesAndRepublish` từ `OMCPref(@"bridgewake.autoHide")`
  (vắng = BẬT) + gọi `[self ahReloadConfig]` cùng nhịp (:397); dòng log
  modes cộng `autohide=%d`.
- `bwHandleWakePacket:` (:460) — trên đường chấp nhận, ngay sau
  `setBarVisible:YES forPane:`: `ahRevealWithReason:AHRevealWake`
  (một điểm gọi duy nhất, phủ cả hai nhánh VISIBLE-ack-ngay và
  HIDDEN→WAKING).
- `bwHandleActPacket:` (mới, :504) + receiver kênh act trong
  `bwInstallOwner` (:584, token `bwActRecvToken`): unpack → type ==
  BWTypeAct → `BWSlotForHash28` → gen khớp `bwGenBySlot` → bundle còn
  assigned + hosted (paneForBundle + slot + hostedPanes, cùng phép
  double-check của wake) → `ahNoteActWithKbActive:pkt.flag`. Handler
  **không phát bất cứ gói nào** (luật chống vòng §3.2.1).
- `bwSetExpandedActive:forBundle:` (:249) — `ahSetSuspended:active`
  cùng nhịp, trước vòng recompute.
- Header: khai `bwHandleActPacket:` + `extern SCPBridgeWakeAct`.

**SCPShared.m** (:37) — `SCPBridgeWakeAct =
"com.anlai.omnicar/bridgewake.v1.act"` cạnh 4 hằng cũ; chuỗi
byte-identical với phía ABInApp/ABChannelNames ở cả hai cây (đã grep
đối chiếu 4 vị trí).

**SCP Hooks/SCPHooks.m** (:803) — `[[SCPCarSplit shared] ahInstall]`
ngay sau `bwInstallOwner`, trước khối fs1. **Makefile** (:13) —
FILES cộng `SCPCarSplit+AutoHide.m` đúng 1 lần, cạnh BridgeWake TU.

**Chrome.m** (:298) — cuối `layoutBarForPane:`:
`ahApplyCurrentStateToView:pane.handle` (sau dòng bwRecompute sẵn có).
**Layout.m** (:536–542) — cuối `rebuildDividers`: áp-lại cho từng
divider + `divider.knob`. **Divider.m** — `endResize` (:66, sau chốt
`resizing = NO`, chỉ khi thật sự đang resize):
`ahNoteActivity:AHSourceDragEnd`; `remoteKnobTouch:` (:462, đầu thân
@try sau khi parse payload): `ahNoteActivity:AHSourceHostKnob`.

## 2. Điểm kích hoạt phiên cho `ahSessionStarted` (việc bổ sung 1)

`activateWithCount:` (SCPCarSplit.m) là đường kích hoạt duy nhất có
`self.active = YES` (grep toàn module: đúng 1 điểm). Gọi
`ahSessionStarted` tại **:133, ngay sau `self.active = YES` (:132)** và
sau khi `ensureContainer` đã thành công — phiên split vừa thật sự
thành active, đồng hồ mờ đầu tiên chạy từ mốc kích hoạt (điểm đo
§5.5.1: vào split không chạm → mờ sau 4,0 s). Nhánh return sớm ở đầu
hàm (split đã active, chỉ `raise` lại container) cố ý KHÔNG nối: đó
không phải cạnh bắt đầu phiên, phiên AutoHide đang chạy liên tục.

## 3. `refreshHomeButton` (việc bổ sung 2) + `removeHomeButton` (việc bổ sung 3)

- Bổ sung 2 ĐÃ LÀM: cuối `refreshHomeButton` (:2993)
  `ahApplyCurrentStateToView:self.homeButton` — button vừa tạo lại/
  định tâm nhận trạng thái mờ hiện hành, đúng điểm thiết kế §2.1.
- Bổ sung 3 — **KHÔNG CÓ helper để gọi, để ngỏ cho tích hợp phán:**
  `SCPCarSplit+AutoHide.h` (bản chính thức) liệt kê đúng 10 method
  (ahInstall, ahNoteActivity:, ahNoteActWithKbActive:,
  ahRevealWithReason:, ahSetSuspended:, ahFaded, ahReloadConfig,
  ahSessionStarted, ahSessionTeardown, ahApplyCurrentStateToView:) —
  **không có** method gỡ bản lưu opacity theo view. Theo lệnh, strand
  này không tự chế API mới và không sửa `removeHomeButton`.
  Đánh giá rủi ro còn lại (để tích hợp/GPT quyết): bản lưu là
  associated object gắn trên chính view + registry NSHashTable yếu —
  button bị huỷ thì bản lưu chết theo view, entry registry tự zero;
  `ahRevealBody:` khôi phục MỌI view trong registry kể cả view đã rời
  tập sơn; button tạo lại đi qua `ahApplyCurrentStateToView:` ở
  refreshHomeButton; cuối phiên `ahSessionTeardown` khôi phục toàn bộ.
  Khe hở hẹp duy nhất: một button bị removeHomeButton giữa lúc mờ rồi
  được gắn lại NGUYÊN object mà không qua refreshHomeButton — trong
  cây hiện tại không có đường nào như vậy (mọi lần gắn đều qua
  refreshHomeButton). Nếu GPT muốn khoá cứng, TU AutoHide cần thêm một
  method kiểu `ahForgetView:` — thuộc phần 1/tích hợp, không thuộc
  strand này.

## 4. Hai điểm để ngỏ ngoài phạm vi file của strand (ghi rõ, không tự mở rộng)

- **endPaneDrag:** bảng nối dây car1 §4.4 có feed `AHSourceDragEnd` tại
  kết thúc kéo pane, nhưng `endPaneDrag:` nằm ở
  `SCPCarSplit+Drag.m` — ngoài phạm vi file của strand này. Đã nối ở
  `endResize` (kéo divider). Tích hợp quyết: hoặc giao Drag.m cho một
  strand bổ sung, hoặc chấp nhận kéo pane không gài lại đồng hồ ở điểm
  buông (feed Began của cú kéo vẫn gài qua F1 như QA20).
- **Treo AutoHide khi solo hosted:** car1 §4.5 + thiết kế §4.1 yêu cầu
  phiên solo hosted cũng treo tương tự EXPANDED, nhưng solo không đi
  qua `bwSetExpandedActive:forBundle:` (đường `hostSolo:`/
  `endHostedSolo` trong SCPCarSplit.m — không nằm trong danh sách điểm
  của strand này) nên chưa có điểm gọi `ahSetSuspended:` cho solo.
  Lớp phòng thủ thứ hai đã có sẵn trong TU: tại thời điểm timer bắn,
  `soloHostedBundle != nil` → hoãn mờ (car1 §3). Thiếu duy nhất hành vi
  "vào solo khi đang mờ thì khôi phục trước" — tích hợp phán.

## 5. Cổng đã chạy (đo trên bản cuối)

- **Thân `setBarVisible:forPane:` nguyên vẹn:** trích thân hàm
  (signature → method kế tiếp) ở bản trước strand và bản cuối: md5
  `a79bc0d54d08d4040528c0489cea4eb0` **khớp tuyệt đối**.
- **Layout.m:** diff so với baseline chụp trước strand = đúng 2 hunk
  của strand này (import + đuôi rebuildDividers); hunk tham vấn FS1 ở
  `appAreaInParent:` (return qua `fsAreaForParent:`) nguyên vẹn từng
  dòng.
- **Timer gốc:** 0 tham chiếu `barTimer`/`trayTimer`/`ratioTimer`
  trong mọi dòng strand này thêm vào.
- **Superset hostFrameInfo:** dict literal gốc + merge
  hostBarInfo giữ nguyên; chỉ cộng 1 dòng key `fade`.
- **Mirror:** cmp identical 8/8 file (A: SCPCarSplit.m,
  SCPCarSplit+BridgeWake.m/.h, SCPShared.m, SCPHooks.m; B: Chrome.m,
  Layout.m, Divider.m). LƯU Ý: bản src/SplitScreenB của Chrome.m trước
  strand này THIẾU các điểm gọi [wake1] bwRecomputeForPane: mà bản
  project/ có (lệch mirror tồn dư từ vòng wake1, kèm một khác biệt
  ngoặc nhọn) — đã lấy bản project/ (cây build đã ship wake1) làm
  chuẩn khi mirror, nên src/ nay chứa cả các dòng wake1 đó; ghi tại
  đây để tích hợp biết đây là sửa lệch cũ, không phải nội dung mới.
- **Build module từ sạch:** `make clean && make` trong
  project/OmniCarSplitScreen (THEOS=~/theos, umask 022) — linking +
  signing thành công, dylib 1.270.496 B; chỉ còn cảnh báo cũ
  (SCPLibRoot -Wnonnull đã được Makefile hạ bằng -Wno-error=nonnull;
  ghi chú lld -multiply_defined). Kiểm strings trên dylib: kênh
  `bridgewake.v1.act` có mặt; selector ahSessionStarted /
  ahNoteActWithKbActive / ahApplyCurrentStateToView /
  bwHandleActPacket đều có mặt.
- Không tuyên bố hành vi trên xe — strand này không có bằng chứng
  runtime.
