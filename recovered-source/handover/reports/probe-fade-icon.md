# probe-fade-icon — Cơ chế mờ (AutoHide) có sơn trúng icon dock không?

Điều tra chỉ-đọc, cây nguồn `src/` (bản ytz4). Dữ kiện xe: phiên ytz4,
17:41–17:42 icon YouTube trên thanh dock biến mất; 17:44 Nguyen quan sát
trực tiếp "controls ẩn (fade logo) thì icon cũng ẩn theo".

## KẾT LUẬN NGẮN

**Sơn mờ KHÔNG THỂ chạm tới icon dock qua cây view — bị minh oan ở tầng
cơ chế.** Toàn bộ thời gian chạy CarPlay/AppBridge chỉ có ĐÚNG HAI hàm
ghi `layer.opacity` (grep toàn cây, xem §1.3), và mọi view chúng sơn đều
là chrome lá (tay nắm / divider / knob / nút logo phía CarPlay; handle /
handleHit / knob phía host) — **không view nào là tổ tiên của một cell
icon dock**. Icon dock là cell của dashboard nằm trong cây con của
`appDockViewController.view`; nút logo được sơn là một nút lá nằm ở
nhánh anh em, dưới một TỔ TIÊN CHUNG là host của dock — sơn một nút lá
không lan sang nhánh anh em.

Tương quan thời gian Nguyen thấy (fade ⇒ icon mất) là tương quan thật
cần đối chiếu log, nhưng nếu icon mất thật, thủ phạm phải nằm ở họ
thư viện icon ([homelib] — inject/remove declaration), không phải lớp
sơn. Điểm phân định nằm ở §4.

## 1) DANH SÁCH SƠN CHÍNH XÁC

### 1.1 Phía CarPlay (SCPCarSplit+AutoHide.m)

Hàm sơn duy nhất: `AHPaintView` (AutoHide.m:74) — ghi
`view.layer.opacity = 0.0f` (dòng 83), lưu giá trị gốc vào associated
object (chỉ lưu LẦN ĐẦU, không bao giờ ghi đè save đã có, dòng 78–82);
khôi phục ghi lại đúng giá trị đã lưu (dòng 85) và xoá save. Không đụng
`hidden`/`alpha`/`userInteractionEnabled` ở bất kỳ đâu trong TU.

Danh sách sơn tại thời điểm fade (`ahPaintCurrentSet`, AutoHide.m:101–109),
theo đúng thứ tự:
1. `pane.handle` của từng pane (`[self allPanes]`, dòng 103);
2. từng `divider` rồi `divider.knob` của nó (dòng 105–106);
3. `self.homeButton` — nút logo (dòng 108).

Loại trừ tường minh trong code (AutoHide.m:96–100): `self.ratioKnob`,
`pane.bar` (timer gốc riêng), và **`launcherHost`** — chính khung chứa
nút logo — KHÔNG bị sơn, vì nó "may hold other dock-cluster elements;
only the button itself is ours to paint".

Khôi phục: `ahRestoreAllPainted` (AutoHide.m:115–118) duyệt registry
yếu `ahPaintedViews` (mọi view TU này từng sơn trong phiên, kể cả view
đã rời paint set) — thứ tự không xác định (NSHashTable), giá trị khôi
phục là save của từng view.

Điểm sơn phụ (cùng danh sách, không thêm view lạ): `ahApplyCurrentStateToView:`
(AutoHide.m:351–359) áp trạng thái fade hiện hành lên MỘT view vừa dựng
lại lúc layout — 4 caller duy nhất: divider (SCPCarSplit+Layout.m:540),
divider.knob (Layout.m:541), pane.handle (SCPCarSplit+Chrome.m:298),
homeButton (SCPCarSplit.m:3069).

Cờ fade được đẩy sang phía host ở cùng nhịp fade/reveal: key `fade`
trong hostFrameInfo (SCPCarSplit.m:2113) và key `kfade` cạnh `knobs`
(SCPCarSplit.m:2727–2732).

### 1.2 Phía host (AppBridge — ABHost áp, không tự quyết)

Kênh: ABChannels.m:644–672 (observer riêng trên appbridge.open/.frame/
.knobs; close/closeall khôi phục không qua hop, dòng 677–695).
Hàm sơn duy nhất: `AHHostPaintView`/`AHHostRestoreView`
(ABHostBMethods.m:1291/1301; ghi opacity tại 1298/1306). Danh sách sơn:
- `applyFade:forPane:` (ABHostBMethods.m:1341): chỉ `pane.handle` và
  `pane.handleHit` của ĐÚNG pane đó (dòng 1358–1359), và chỉ khi handle
  đang hiện thật (nativeVisible); handle bị frame lấy đi thì khôi phục
  + ghi fade=NO (dòng 1350–1356).
- `setKnobsFade:` (ABHostBMethods.m:1381): mọi view trong
  `self.knobViews` (dòng 1388).

Không có view dock nào ở phía host: ABPane là pane của app hosted
(box/handle/bar của app trong ô), knob là chấm kéo chia — cả hai đều
nằm trong cửa sổ xe của ABHost, không chứa icon.

### 1.3 Tính đóng của danh sách (bằng chứng phủ định)

Grep `layer.opacity =` trên toàn bộ `src/**/*.m`: ngoài hai hàm trên,
chỉ còn animation của splash trong Prefs/StartupScreen (process khác,
không chạy trên màn xe lúc chia). **Không tồn tại đường ghi opacity
thứ ba** trong runtime CarPlay/AppBridge — danh sách sơn là đóng theo
xây dựng, không phải theo quan sát.

## 2) CÂY VIEW CỦA VÙNG DOCK

- Nút logo: dựng ở SCPCarSplit.m:3040–3069. Host chứa nó: ở chế độ
  "bare" là chính `parent` (tabParent); còn lại là
  `dockHostForRect:inParent:` (SCPCarSplit.m:3044).
- `dockHostForRect:inParent:` (SCPCarSplit.m:3285–3313): đi LÊN từ
  `appDockViewController.view` (dockView) qua chuỗi superview, trả về
  tổ tiên ĐẦU TIÊN có rect màn hình chứa rect của nút (và không rộng
  quá nửa parent); nút được gắn vào đó (`[host addSubview:]`,
  SCPCarSplit.m:3052), host đó được ghi vào `self.launcherHost`
  (dòng 3065). `raiseLauncher` (SCPCarSplit.m:3144–3155) chỉ nâng NÚT,
  không nâng host.
- Icon dock nằm ở đâu: các icon là cell của dashboard (họ SBIconView
  trong *IconListView) nằm TRONG cây con của dockView — bằng chứng
  trong cây: `installLongPressIn:depth:` (SCPCarSplit.m:3347+) quét
  mọi *IconListView trong mọi cửa sổ; `dockClusterInParent:`
  (SCPCarSplit.m:3159+) và `SCPDumpDockTree` chỉ ĐỌC cây dock.
  Tweak không tạo view cho icon dock và không giữ tham chiếu sơn nào
  tới chúng.
- Icon của app được chọn (YouTube) hiện trên xe qua cơ chế nào:
  **cell của dashboard**, không phải view của tweak —
  `SCPInjectDeclarationIfChosen()` (SplitScreenC/SCPAppIcons.m:15–16,
  178) ghép một `CRCarPlayAppDeclaration` tổng hợp vào info của app
  trong thư viện của dashboard; dashboard tự dựng cell của nó (cùng
  cơ chế khiến app hiện trên lưới xe). Việc thêm/gỡ nằm ở họ
  SCPAppIcons/SCPHomeApply — chính là họ [homelib] đã instrument ở
  vòng ytz4.
- Quan hệ tổ tiên: homeButton và một cell icon dock có TỔ TIÊN CHUNG
  GẦN NHẤT là host H ở trên (H = dockView hoặc một tổ tiên của
  dockView): homeButton là con trực tiếp của H; icon nằm sâu trong
  nhánh dockView dưới H. **Không view nào thuộc danh sách sơn (§1) là
  tổ tiên của icon**; ngược lại icon cũng không nằm dưới homeButton.
  Sơn opacity lan xuống cây con của view bị sơn — homeButton không có
  cây con nào ngoài lớp glyph của chính nó.
- Điểm đụng dock duy nhất khác của tweak: `setDockShift:`
  (SCPCarSplit.m:3266) ghi `transform` tịnh tiến lên dockView — dời
  TOÀN BỘ dải dock cùng lúc (không phải từng icon), do vị trí launcher
  điều khiển, không liên quan fade.

## 3) DELTA YTZ4 — KHI NÀO FADE / HIDDEN NAY TỚI ĐƯỢC MÀ YTZ3 KHÔNG

Điều kiện fade trong SPLIT thường: KHÔNG ĐỔI so với ytz3 (timer 4.0 s;
`ahFadeBlockedReason`, AutoHide.m:140–157, vẫn chặn solo / kbhold /
surface-open / dragging như cũ; suspension solo giữ nguyên —
SCPCarSplit.m:2019 bật, :2039 tắt; BridgeWake.m không còn caller
ahSetSuspended nào). Toàn bộ delta nằm ở EXPANDED:

1. `bwSetExpandedActive:` (SCPCarSplit+BridgeWake.m:440–453) **không
   còn gọi `ahSetSuspended:`** → vào fullscreen, máy fade không bị
   treo nữa: timer tiếp tục chạy và fade BẮN THẬT khi idle 4 s trong
   EXPANDED. (Ytz3: 0 fade trong ~961 s expanded — số đo phiên ytz3.)
2. Hạng tử `"expanded"` đã gỡ khỏi `ahFadeBlockedReason`
   (AutoHide.m:141–146 ghi chú [ytz4-hb]) → cổng lúc timer bắn không
   còn chặn vì expanded.
3. Phép nâng HIDDEN→VISIBLE trong `bwRecomputeForPane:` đã xoá
   (BridgeWake.m:521–531): trong EXPANDED, ô có barHidden ∧ faded nay
   tổng hợp thành **HIDDEN thật** (định nghĩa đầy đủ tại
   BridgeWake.m:496–519: `barHidden = pane.bar == nil || isHidden`;
   `fadedEffective = !bwAutoHideEnabled || [self ahFaded]`). Ytz3 ép
   VISIBLE trong expanded bất kể fade.

Tổ hợp được hỏi riêng — ô hosted vừa đóng bàn phím / vừa đổi gán:
- Đóng bàn phím: `ahKbHoldState` (AutoHide.m:140–157) chặn fade tối đa
  10 s sau act kb cuối — cơ chế có từ thiết kế AutoHide, ytz4 KHÔNG
  đổi; tín hiệu kb xác thực mới (type 6) chỉ thay NGUỒN của act, không
  thay điều kiện fade.
- Đổi gán: gen++ đặt kb về UNKNOWN (BridgeWake.m:473–481) — ảnh hưởng
  cổng wake, không ảnh hưởng fade. Đổi gán/layout có thể khiến handle/
  divider/homeButton dựng lại bị sơn ngay theo trạng thái fade đang
  có (ahApplyCurrentStateToView, §1.1) — hành vi có từ vòng wake1,
  không phải delta ytz4.

Hệ quả cho dữ kiện 17:41–17:44: nếu lúc đó session ở EXPANDED, đây là
tình huống fade MỚI của ytz4 (cả sơn lẫn state HIDDEN); nếu ở SPLIT
thường, fade lúc 17:41–42 chạy đúng điều kiện ytz3. Log phân định bằng
dòng `[wake1] bw expanded ON/OFF` (BridgeWake.m:444).

## 4) LOG ĐỐI CHIẾU MỐC 17:41–17:44

Các dòng ghi thời điểm fade áp/khôi phục (chuỗi nguyên văn):
- Fade bắn (phía CarPlay): `[autohide] fade last=%s idle=%.2f`
  (AutoHide.m:182) — có mốc giờ theo log, KHÔNG liệt kê view.
- Bị chặn: `[autohide] fade deferred (%s)` (AutoHide.m:169) — lý do
  solo/kbhold/surface-open/dragging.
- Khôi phục: `[autohide] reveal-applied reason=%s views=%lu`
  (AutoHide.m:209) — reason ∈ activity/wake/unsuspend/prefoff; views
  là SỐ LƯỢNG view có save, không có danh tính view.
- Phía host, THEO TỪNG BUNDLE: `[autohide] host fade applied bundle=%@`
  / `[autohide] host fade restored bundle=%@`
  (ABHostBMethods.m:1370) và `[autohide] host knob fade applied/restored`
  (ABHostBMethods.m:1385). Dòng host fade của bundle
  com.google.ios.youtube nói về handle/handleHit của pane YouTube —
  KHÔNG phải icon dock của YouTube.
- State: `[wake1] bw state %@ %@->%@ gen=%u` (BridgeWake.m:551) —
  mốc chuyển sang HIDDEN của từng bundle.
- Cây dock thật của phiên: `DIAG cay dai dock:` (SCPCarSplit.m:3321,
  dump một lần/phiên) — xác minh host của homeButton trong đúng phiên
  đó nếu cần.

Log có ghi view bị sơn không? **Không ở phía CarPlay** (chỉ đếm ở
reveal); phía host ghi theo bundle nhưng là handle của pane. Vì danh
sách sơn đã đóng theo xây dựng (§1.3), việc thiếu danh tính view trong
log không làm yếu kết luận minh oan: không dòng log nào có thể chỉ ra
một view sơn thứ ba vì không tồn tại hàm ghi thứ ba.

Dòng phân định cho ICON (khi log ytz4 lên): họ `[homelib]`
(SplitScreenC/SCPAppIcons.m:141 — `decision=%@ bundle=%@`, gồm các
decision inject/remove/skip-*; SCPHomeApply ghi trạng thái sau áp).
Đọc cửa sổ 17:41–17:44: nếu có decision remove/không-inject lại cho
com.google.ios.youtube sát mốc mất icon → họ thư viện kết án, fade chỉ
trùng giờ (fade xảy ra đúng các lúc idle — cùng lúc người dùng ngừng
chạm và quan sát thấy icon mất). Nếu cửa sổ đó KHÔNG có dòng [homelib]
nào cho YouTube mà icon vẫn mất → tầng hiển thị cell của dashboard nằm
ngoài cả hai cơ chế đã đọc, cần instrument riêng; kết luận đó cũng phải
ghi là chưa phân định, không đổ cho fade.

## PHẦN CHƯA PHÂN ĐỊNH

- Chưa có log phiên ytz4 trong tay lúc điều tra: chưa biết 17:41–42
  session ở SPLIT hay EXPANDED, và chưa đọc được [homelib] của cửa sổ
  đó. Kết luận §1–§2 là tầng cơ chế (đọc từ source); kết án sự kiện
  17:41 phải chờ log.
- Bài toán "icon mất" ở các phiên trước (reader [applib] mù, count=0)
  thuộc họ thư viện — vòng ytz4 đã instrument đúng họ đó; biên bản này
  không mở lại phần đó.
