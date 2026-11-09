# THIẾT KẾ FS1 — FULLSCREEN ẨN DOCK TỰ DỰNG (chỉ-đọc, 2026-11-09)

> Yêu cầu (Nguyen chốt 13:49): **chỉ pinch 2 ngón** — pinch-out →
> fullscreen ẩn dock, pinch-in → restore. Không nút fullscreen, không
> nút đổi app trái/phải; trigger duy nhất là `SCPPinchController`.
> Kiến trúc (GPT chốt): `SCPFullscreenController` là **chủ trạng thái
> duy nhất**; adapter chỉ chuyển tiếp; staging nghiệm thu controller
> trước bằng đường kích hoạt độc lập với pinch.
> Nguồn kỹ thuật chính: source tham khảo trong repo
> `src/OmniCarDoubleTapFullscreen.xm` + `src/OmniCarChrome.xm`
> (bản tại push9-clone, md5 `282cf59a…` / `0b63b081…`, trùng bản repo
> main). `a1-fullscreen-entry.md` (A1) là đối chiếu tĩnh trên binary.
> Nhãn: **[XM]** = source tham khảo; **[SRC]** = source rebuilt;
> **[A1]** = báo cáo A1; **[FS1]** = quyết định thiết kế này.

## 0. Vì sao không đưa nguyên binary QA20 vào gói

Binary đưa vào được và hook tương thích — A1 §2 đã kiểm: 6 selector
hook trên SCPCarSplit đều có trong census gốc và header rebuilt, chữ
ký khớp. Nhưng fullscreen trong binary đó **không có tay nắm cho
pinch**:

- `OMCToggleHost` là hàm static (@0x4524), **điểm gọi duy nhất**
  trong toàn binary là `-[OMCZoomAction pressed:]` @0x44a8 — nút
  zoom trong menu hai nút của chính dylib (A1 §3.1–3.2). Nút/action
  chỉ tồn tại sau khi menu tỉ lệ đã mở ≥ 1 lần; pinch đứng ngoài
  menu không chạm được vào nó.
- Trạng thái `expanded` nằm sau associated object với khóa là địa
  chỉ tĩnh nội bộ của dylib (ô 0x14ab8) — không getter, không class
  method, không kênh truy vấn (A1 §3.5). Kiến trúc GPT chốt (mục 4)
  đòi controller **xác nhận** được EXPANDED thật và phát trạng thái
  thật cho wake owner — binary không cho đọc, nên không đối chiếu
  được.
- Nút/menu/swap là đúng phần Nguyen vừa loại khỏi phạm vi, và GPT
  cấm mang theo (menu Zoom/Swap, hook `ratioPresetTapped:` /
  `dividerDoubleTapped:`) — đưa binary vào là đưa cả những phần đó.

→ Kết luận: cơ chế host của QA20 (snapshot/restore/can thiệp diện
tích/chrome) đã đọc được trọn vẹn từ source tham khảo, nên **cài
lại bằng code của mình trong module SplitScreen của rebuilt**, nơi
pinch gọi được qua `SCPFullscreenControlling`. Binary QA20 ở ngoài
gói (wake1 Gate 1 đã xác minh gói không chứa nó — giữ nguyên).

## 1. Bản đồ cơ chế QA20 — từ source tham khảo

### 1.1 Toggle: `OMCToggleHost` [XM :91]

Điều kiện vào: `split.active` = YES; `container.superview` =
`parent` tồn tại và `parent.window != nil`. Sai → bỏ qua, có log
(`skip reason=inactive` / `host-unavailable`).

Nhánh expand (state.expanded đang NO):

1. `original = [split appAreaInParent:parent]` — gọi **trước** khi
   lật state, nên hook diện tích (mục 1.2) vẫn trả diện tích gốc.
2. `target = OMCWindowBoundsInParent(parent)` [XM :55] =
   `[parent convertRect:window.bounds fromView:window]` — toàn bộ
   cửa sổ trong hệ toạ độ parent, **không** trừ dock, không trừ
   status-bar insets.
3. Cả hai rect phải qua `OMCAreaValid` [XM :50] (finite, mỗi chiều
   > 50 pt) — sai → bỏ qua.
4. Snapshot vào state (associated object trên split, `OMCState`
   [XM :42]): `layoutParent = parent` (weak), `previousClipsToBounds
   = parent.clipsToBounds`, `originalArea = original`.
5. `expanded = YES`; `parent.clipsToBounds = NO` (để container
   phình ra không bị parent cắt).
6. `[split relayoutAnimated:NO pushScenes:YES]` rồi
   `[split rootDidLayout]` — rootDidLayout thấy frame container ≠
   appArea (hook giờ trả target) nên tự đặt lại frame + relayout.
   Thứ tự này là cốt lõi: **toggle không tự đặt frame container**;
   nó đổi *nguồn diện tích* rồi để đường layout sẵn có kéo theo.
7. `OMCChromeSetHidden(YES)` (mục 2).

Nhánh restore (expanded đang YES): `expanded = NO` **trước**;
`layoutParent.clipsToBounds = previousClipsToBounds`;
`layoutParent = nil`; relayout + rootDidLayout (hook trả lại diện
tích gốc → container co về); `OMCChromeSetHidden(NO)`. Cả hai chiều
đều không animation (`animated:NO`).

### 1.2 Can thiệp diện tích: hook `appAreaInParent:` [XM, %hook SCPCarSplit]

```objc
CGRect native = %orig;
state = associated(split);
if (OMCInNativeSwap || !state || !state.expanded || !parent ||
    parent != state.layoutParent || ![self active]) return native;
target = OMCWindowBoundsInParent(parent);
return OMCAreaValid(target) ? target : native;
```

Năm điều kiện bảo vệ: chỉ khi expanded; chỉ cho **đúng parent đã
snapshot**; chỉ khi split còn active; target không hợp lệ → rơi về
native. Mọi caller khác / parent khác nhận diện tích gốc nguyên
vẹn. Đây là mẫu cho điểm phối hợp duy nhất ở mục 4.3.

### 1.3 Teardown rút gọn: hook `setActive:` [XM, %hook]

Khi deactivate (và không trong native swap): nếu expanded →
`expanded = NO`, khôi phục clips trên layoutParent, `layoutParent
= nil`, `OMCChromeSetHidden(NO)` — **không relayout** (split đang
chết, không còn gì để layout). Log
`split-deactivate-chrome-restored`. Mục 4.6 kế thừa đúng mẫu này.

### 1.4 Phần bị loại khỏi phạm vi (không mang sang)

- Menu hai nút Zoom/Swap (`OMCInstallTwoActionMenu` [XM :300],
  `OMCHideMenuControls` [XM :278], glyph, cover) và hai action
  class — Nguyen loại; GPT cấm.
- Hook `ratioPresetTapped:` (chặn 3 preset gốc) và hook
  `dividerDoubleTapped:` (nghỉ hưu đường double-tap gốc) — chỉ tồn
  tại để bảo vệ menu thay thế; không menu thì không cần.
- Luồng swap native (`OMCSwapUsingNativeCallback`, cờ
  `OMCInNativeSwap`, phát chrome quanh swap, re-assert sau
  200 ms) — GPT cấm thao tác native swap. Chỉ giữ lại **một bài
  học**: trong lúc swap, hook diện tích ép về native rồi khôi phục
  expanded sau — tức cơ chế gốc thừa nhận thao tác lạ giữa chừng
  phải hoặc đi qua diện tích gốc, hoặc bị trạng thái fullscreen
  theo sau dọn lại. FS1 dùng biến thể thụ động ở mục 4.8 (theo
  thực tế, không tranh).

### 1.5 Đối chiếu A1 ↔ source

Khớp: toggle static + 1 điểm gọi; snapshot/restore/chrome như A1
§4 mô tả; kênh chrome một chiều; state thuần bộ nhớ. Một lệch đã
giải quyết: A1 §4 ghi nhánh expand có gọi `OMCHideMenuControls` —
kiểm cả hai biến thể source trong workspace (repo main và
`feature/`): thân `OMCToggleHost` của cả hai **không** gọi hàm đó
(nó chỉ được gọi trong hook show/hide menu). Lệch nằm ở đường menu
đã loại — không ảnh hưởng cơ chế host, ghi nhận và đóng.

## 2. `OMCChromeSetHidden` — định nghĩa, owner, ABI, và ánh xạ

**Định nghĩa** [XM `OmniCarChrome.xm` :69]: hàm C
`void OMCChromeSetHidden(BOOL)` — file `OmniCarDoubleTapFullscreen
.xm` chỉ khai `extern` (dòng 8). Thân hàm: `NSCAssert` main thread;
(1) đường trực tiếp tại chỗ — nếu process hiện tại đã quan sát
được cửa sổ status bar thì gọi `OMCApplyChromeVisibility(hidden)`
ngay; (2) **luôn** post NSDistributedNotification
`com.anlai.omnicar.zoom.chrome.v1` (:8) với userInfo
`{version:@1, hidden:@(BOOL)}`.

**Bên nhận + cơ chế áp** [XM Chrome]: `OMCChromeEntry` (:118) chỉ
cài trong process có bundle ∈ {`com.apple.carplayapp`,
`com.apple.carplay`, `com.apple.dashboard`} — tức **cùng họ
process với host** (CarPlayApp/dashboard), không phải SpringBoard.
Receiver kiểm version/hidden rồi về main queue gọi
`OMCApplyChromeVisibility`. Cửa sổ đích được *phát hiện thụ động*:
hook `layoutSubviews` trên `DBStatusBarWindow` (ưu tiên) hoặc
`CARStatusBarWindow` (:85/:93, cài bởi `OMCTryInstallChrome` :99 có
retry) ghi mỗi instance vào hash table yếu qua `OMCRecordWindow`
(:21). `OMCApplyChromeVisibility` (:32):

- Ẩn: nếu **chưa quan sát được cửa sổ nào → log FAILED và không
  chốt trạng thái ẩn** (không latch). Ngược lại: với mỗi cửa sổ,
  ghi lại `hidden` gốc (chỉ lần đầu), đặt `window.hidden = YES`;
  cửa sổ xuất hiện sau, khi đang ẩn, được ghi gốc + ẩn ngay tại
  `OMCRecordWindow`.
- Hiện: khôi phục **đúng cờ hidden gốc đã ghi** cho từng cửa sổ,
  xoá bản ghi. Không ép `hidden = NO` mù.

**Owner binary**: dylib `OmniCarDoubleTapFullscreen.dylib` của
QA20; ký hiệu exported duy nhất liên quan là `_OMCChromeSetHidden`
(A1 §3.4, `T` @0xa798). **ABI**: hàm C, một đối số BOOL, void,
bắt buộc main thread.

**Hiệu quả trong bản rebuilt: bằng không, và cấm tham chiếu.**
Gói rebuilt không chứa dylib QA20 (Gate 1 wake1 đã xác minh);
không binary nào trong cây định nghĩa ký hiệu này. Source tham
khảo có `extern` không tạo ra owner — gọi/dlsym tới nó trong bản
mới là neo vào một dylib không nạp. Strand cài đặt **không được**
để lại bất kỳ tham chiếu nào tới `OMCChromeSetHidden` trong FS1
(Gate 1 tĩnh, mục 10).

**Ánh xạ tương đương bằng cơ chế của chính rebuilt** [FS1] —
hàm nội bộ `fsChromeSetHidden(BOOL)` của controller (mục 4.7),
cùng module SplitScreen, cùng process CarPlayApp:

| QA20 | FS1 |
|---|---|
| Post distributed + receiver cùng họ process | Gọi trực tiếp trong process — bỏ hop distributed (người gửi và người nhận là một process trong topology rebuilt; giữ kênh chỉ thêm bề mặt lạc phiên) |
| Phát hiện cửa sổ bằng hook layoutSubviews | Quét `UIApplication.windows` theo tên class `DBStatusBarWindow`/`CARStatusBarWindow` tại thời điểm expand + mỗi vòng reconcile (mục 4.8). Chênh lệch hành vi duy nhất: cửa sổ sinh ra *giữa hai vòng reconcile* được ẩn trễ tối đa một vòng layout — dashboard layout diễn ra liên tục khi có thay đổi, và rootDidLayout là nhịp có sẵn |
| Ghi gốc lần đầu + khôi phục đúng cờ gốc | Giữ nguyên kỷ luật (bản đồ yếu→mạnh theo cửa sổ) |
| Không cửa sổ → FAILED, không latch | Giữ nguyên: log `fs chrome FAILED no-window`, trạng thái ẩn chrome ghi là *chưa đạt* — nhưng **không** chặn expand (diện tích là phần chính; chrome status bar là phần phụ) — khác QA20 ở mức hệ quả, ghi rõ: QA20 cũng không chặn toggle vì chrome, nó chỉ log |
| Chỉ ẩn cửa sổ status bar | Cộng thêm một phần tử phía CarPlayApp mà QA20 đạt bằng hình học: nút Home/launcher của chính rebuilt (mục 3) — QA20 không cần ẩn nó vì thời QA20 cơ chế nút đó không nằm trong vùng phình; ở rebuilt nút neo tại dock nên phải xử lý tường minh |

## 3. Ánh xạ đòn bẩy sang cây rebuilt

| Đòn bẩy | Rebuilt [SRC] | Vai trò trong FS1 |
|---|---|---|
| Nguồn diện tích | `-[SCPCarSplit appAreaInParent:]` `SCPCarSplit+Layout.m:407` — tính R từ contentView, trừ status insets + phần chồng dock (`appDockViewController`) | Điểm phối hợp duy nhất (mục 4.3). Mọi frame container đều bắt đầu từ đây: `ensureContainer` (`SCPCarSplit.m:336`) gán frame, `rootDidLayout` đối chiếu |
| Kéo theo layout | `rootDidLayout` `SCPCarSplit.m:197`: active + frame ≠ appArea → gán frame + `relayoutAnimated:NO` | Đường kéo theo có sẵn, đúng như QA20 dựa vào. FS1 không tự đặt frame container ở bất kỳ đâu |
| Phân frame ô | `relayoutAnimated:pushScenes:` `SCPCarSplit+Relayout.m:36`; `frameForSlot:` `+Layout.m:126` suy từ `container.bounds` | Hai ô + tỉ lệ tự co giãn theo container; divider/knob layout theo sau. Không sửa |
| Ô hosted | relayout gọi `pushHostFramesLive:` → `sendHostFrameForPane:` `SCPCarSplit.m:1993` → `hostFrameInfo:` (:2035) post `appbridge.frame` | Frame scene phía SpringBoard tự theo khi container phình — **không cần kênh mới**. Lưu ý `hostFrameInfo` cũng nhúng `ax/ay/aw/ah` = appArea hiện hành → ABHost nhận đúng vùng đã phình |
| Solo bridge | `setFullscreenBridgeHidden:bundle:` `SCPCarSplit.m:2459` | **Không dùng**: đây là đường tray-che-solo (post frame Zero cho bundle solo), không phải điều khiển fullscreen; đụng vào sẽ phá solo |
| Dock gốc (stock) | dock view của `appDockViewController`; `appAreaInParent:` trừ phần chồng của nó | Ẩn bằng **hình học**: vùng phình (window bounds) phủ lên dải dock — đúng cách QA20 (source không hề chạm dock view). Dự phòng có tên ở mục 4.7 |
| Nút Home của rebuilt | `refreshHomeButton` `SCPCarSplit.m:2830` (neo tại `launcherCenterInParent:`/`dockClusterInParent:` :3065, host = dock host hoặc tabParent); `removeHomeButton` :2982 kéo theo `setDockShift:0` :3171 | FS1 ẩn bằng cờ hidden + vòng reconcile ép lại (mục 4.7). **Không** dùng removeHomeButton (tác dụng phụ lên dockShift + bookkeeping launcher) |
| Gương SpringBoard | ABHost window + handle/knob/bar mirror qua `hostBarInfoForPane:` `SCPCarSplit.m:2116` | **Không đụng**: gương đi theo info sẵn có. Bar/handle của ô vẫn theo cơ chế ẩn 4 s / wake như wake1 — quan hệ với EXPANDED định tại mục 5 |
| Cửa sổ status bar | Chưa có bất kỳ tham chiếu nào trong cây (grep `DBStatusBarWindow`/`CARStatusBarWindow` = 0) | Bề mặt mới duy nhất, nằm trọn trong controller (mục 4.7) |

## 4. `SCPFullscreenController` — chủ trạng thái duy nhất

### 4.1 Sở hữu và máy trạng thái

File mới `SCPFullscreenController.h/.m` trong module
`OmniCarSplitScreen` (cả hai cây `project/` + `src/`). Singleton,
chỉ sống ở **CarPlayApp** (cài tại điểm keo `__init_1` trong
`SCPHooks.m`, cùng điểm với `bwInstallOwner`; ở SpringBoard class
tồn tại nhưng không bao giờ được cài/tham vấn — container
dashboard không tồn tại ở đó). Mọi entry point đều về main queue.

```
SPLIT → EXPANDING → EXPANDED → RESTORING → SPLIT
              \______ lỗi ______→ rollback → SPLIT
```

- Controller là nơi **duy nhất** giữ: trạng thái máy, snapshot,
  cờ expanded đã chốt, bản đồ khôi phục chrome, transaction hiện
  hành. Adapter không giữ biến fullscreen nào (mục 4.9); pinch
  controller không giữ (nó chỉ đọc qua adapter + arbiter như
  wake1); wake owner không giữ — nó nhận qua
  `bwSetExpandedActive:forBundle:` do controller phát.
- `currentState` cho bên ngoài = **trạng thái đã chốt**: EXPANDING
  vẫn báo Split, RESTORING vẫn báo Expanded, cho tới khi xác nhận
  xong (mục 4.4/4.5). Chỉ khi controller không tồn tại (process
  không cài) mới là Unknown — khớp ngữ nghĩa protocol hiện hữu.

### 4.2 Snapshot + transaction

Snapshot (một bản, thuộc controller, tương ứng `OMCZoomState`
gọn lại — bỏ toàn bộ trường menu/swap):

```objc
SCPFSSnapshot {
  UIView *layoutParent;      // weak — parent đã snapshot
  CGRect  originalArea;      // appArea gốc tại thời điểm expand
  CGRect  targetArea;        // window bounds trong parent
  BOOL    previousClips;     // layoutParent.clipsToBounds gốc
  uint64  txn;               // transaction đang sở hữu snapshot
}
```

Kỷ luật transaction (theo GPT): bộ đếm `fsTxn` tăng đơn điệu.
Mỗi request expand/restore mở một transaction; **lệnh mới trong
khi máy đang ở EXPANDING/RESTORING bị từ chối ngay** (completion
NO, log `fs busy txn=<n>`) — không hàng đợi, không hai lệnh đồng
thời. Mọi callback trễ (reconcile, retry) đều mang txn và bị bỏ
nếu txn ≠ transaction hiện hành. Provenance của transaction
(`pinch` / `test` / `teardown`) chỉ phục vụ log — không phải
trạng thái song song.

### 4.3 Điểm phối hợp diện tích — một, và chỉ một

Trong thân `appAreaInParent:` (`+Layout.m:407`), tại **điểm
return duy nhất**, cộng đúng một lần tham vấn:

```objc
CGRect area = <thân gốc, không đổi>;
return [[SCPFullscreenController shared]
        fsAreaForParent:parent nativeArea:area split:self];
```

`fsAreaForParent:nativeArea:split:` trả `targetArea` **chỉ khi**
đồng thời: máy == EXPANDED (đã chốt); `parent == snapshot.
layoutParent`; `split.active`; `OMCAreaValid(targetArea)` (chép
ngưỡng > 50 pt của [XM :50]). Ngoài ra trả `nativeArea` nguyên
vẹn. Đây là bản dịch trực tiếp của hook [XM 1.2] thành method
cùng module tự tham vấn — **không hook runtime, không phụ thuộc
thứ tự nạp** (điểm GPT yêu cầu). Ghi nhận trung thực về fidelity:
thân hàm gốc giữ nguyên từng phép tính; khi không expanded, giá
trị trả về bằng gốc theo từng bit; dòng tham vấn là cộng thêm có
cổng, đúng vị thế của các dòng keo `[wake1]`/`[pinch1]` đã có
trong cây. Controller lấy `originalArea` bằng cách gọi chính
`appAreaInParent:` **trước** khi lật trạng thái (như [XM :104]) —
không tồn tại đường "đọc raw" thứ hai.

### 4.4 Chuỗi expand

`requestExpandWithCompletion:` (qua adapter hoặc đường test):

1. Cổng vào: máy == SPLIT; `split.active`; container có
   superview `parent`, `parent.window != nil`; không
   `zoomedSlot`, không `soloHostedBundle`, không picker/popup/
   tray đang mở (bảo toàn mục 6 — từ chối êm, completion NO,
   log lý do; **không** tự đóng/dọn bất kỳ thứ nào trong số đó).
2. Mở transaction; chụp snapshot (originalArea qua appArea
   trước-lật; targetArea = window bounds trong parent như
   [XM :55]); cả hai qua OMCAreaValid — sai → đóng transaction,
   completion NO.
3. Máy = EXPANDING; `parent.clipsToBounds = NO`.
4. `relayoutAnimated:NO pushScenes:YES` + `rootDidLayout`
   (đúng cặp lệnh [XM :127–128]).
5. **Xác nhận thật** (GPT: relayout xong không đủ) — đọc lại:
   `container.frame` bằng targetArea (sai số ≤ 0,5 pt mỗi thành
   phần); `container.superview == snapshot.layoutParent`;
   `parent.window != nil`; `split.active` vẫn YES.
6. Đạt → áp chrome (mục 4.7); phát `bwSetExpandedActive:YES`;
   bắn `stateDidChange(Expanded)`; máy = EXPANDED; completion
   YES. Không đạt → **rollback** (mục 4.6bis): completion NO.

### 4.5 Chuỗi restore

1. Cổng vào: máy == EXPANDED (hoặc EXPANDING bị yêu cầu huỷ →
   đi rollback). Mở transaction.
2. Máy = RESTORING; **hạ cờ expanded của controller trước**
   (điểm tham vấn diện tích từ đây trả native — như [XM] restore
   lật state trước); khôi phục `layoutParent.clipsToBounds =
   previousClips` nếu parent còn sống.
3. `relayoutAnimated:NO pushScenes:YES` + `rootDidLayout`.
4. Xác nhận: `container.frame` bằng **diện tích gốc hiện hành**
   (`appAreaInParent:` vừa tính lại — bằng `originalArea` trong
   trường hợp thường; nếu dashboard tự đổi vùng trong lúc
   expanded, vùng hiện hành thắng và snapshot bị bỏ, không ép về
   rect cũ). Sai → thử lại đúng một lần sau 0,05 s (dashboard có
   thể đang giữa layout); vẫn sai → **chốt an toàn**: máy =
   SPLIT, chrome khôi phục hết, phát `bwSetExpandedActive:NO`,
   log `fs restore-unconfirmed` — thà báo SPLIT + log lỗi còn
   hơn báo EXPANDED giả (nguyên tắc mục 9).
5. Đạt → khôi phục chrome (mục 4.7); phát
   `bwSetExpandedActive:NO`; `stateDidChange(Split)`; xoá
   snapshot; máy = SPLIT; completion YES.

### 4.6 Rollback và restore rút gọn

- **Rollback** (expand lỗi giữa chừng): hạ cờ expanded; khôi
  phục clips; relayout + rootDidLayout; khôi phục chrome (nếu đã
  áp phần nào); phát NO; máy = SPLIT; giữ log đầy đủ các giá trị
  đo được. Sau rollback hệ phải đo lại được: frame container =
  diện tích gốc hiện hành, clips = previousClips.
- **Restore rút gọn** (phiên chết — mẫu hook `setActive:` [XM
  1.3]): khi `dashboardInvalidated` (điểm keo đã có cho
  wake/pinch trong `SCPCarSplit.m:236` — FS cộng một dòng
  `[controller fsSessionDidEnd]`) hoặc khi reconcile phát hiện
  `!split.active` lúc đang EXPANDED: **không relayout**; hạ cờ;
  khôi phục clips nếu parent còn sống; khôi phục chrome; phát
  NO; máy = SPLIT; xoá snapshot.

### 4.7 Chrome phía FS — tập phần tử và kỷ luật

Tập chrome FS sở hữu (chỉ những phần tử này):

1. **Cửa sổ status bar** (`DBStatusBarWindow` /
   `CARStatusBarWindow`): `fsChromeSetHidden` theo ánh xạ mục
   2 — quét cửa sổ theo tên class tại lúc áp + mỗi reconcile;
   bản đồ ghi-gốc yếu→mạnh; ẩn = ghi gốc rồi `hidden = YES`;
   khôi phục = trả đúng cờ gốc từng cửa sổ. Không thấy cửa sổ
   nào → log FAILED, không latch (nhưng không chặn expand).
2. **Nút Home/launcher của rebuilt** (`split.homeButton`): khi
   EXPANDED đặt `hidden = YES`; `refreshHomeButton`
   (`SCPCarSplit.m:2830`) chạy trong mọi `rootDidLayout` có thể
   dựng lại/nâng nút — vòng reconcile (mục 4.8) ép lại hidden
   sau mỗi layout, cùng triết lý enforcement liên tục của hook
   layoutSubviews phía QA20. Khi restore: **không ép hiện** —
   nhả về trục hiển thị của SPLIT (mục 5, luật R4).
3. **Dock stock**: ẩn bằng hình học phủ (mục 3) — không chạm
   vào dock view. *Dự phòng có tên*: nếu nghiệm thu staging
   (mục 8) cho thấy dock view nổi **trên** container đã phình
   (z-order ngược với tiền lệ QA20 trên xe của Nguyen), phương
   án dự phòng là đưa dock view vào cùng kỷ luật ghi-gốc/ẩn/
   khôi phục như cửa sổ status bar — chỉ kích hoạt khi có bằng
   chứng xe, không cài sẵn theo đoán.

Không thuộc tập FS: thanh bar/handle/knob của ô, gương ABHost —
trục mờ-idle sở hữu (mục 5).

### 4.8 Vòng reconcile — `fsDidLayout`

Điểm keo đã tồn tại: seam `rootDidLayout` trong `SCPHooks.m`
(nơi pinch gọi `syncArming`) — FS cộng một lời gọi
`[controller fsDidLayout]`. Mỗi vòng, khi máy ∈ {EXPANDED}:

- Xác nhận lại: `container.frame` còn bằng targetArea; lệch →
  thử kéo về bằng relayout + rootDidLayout đúng một lần; vẫn
  lệch → coi như bị override bên ngoài thắng: đi restore rút
  gọn về SPLIT (theo thực tế, không tranh — bài học swap ở
  1.4).
- Phát hiện override: `soloHostedBundle != nil` hoặc
  `zoomedSlot != nil` xuất hiện trong lúc EXPANDED (lệnh solo/
  zoom đi đường bridge/UI khác) → restore rút gọn về SPLIT +
  log `fs external-override` (hai cơ chế không cùng sở hữu vùng
  trình bày; FS nhường, không gọi ngược bất kỳ hàm solo/zoom
  nào).
- Phát hiện `!split.active` → restore rút gọn (mục 4.6).
- Ép lại chrome: quét cửa sổ status bar mới xuất hiện; ép
  `homeButton.hidden` nếu đang EXPANDED.
- Mọi kiểm tra đều mang txn hiện hành; transaction đã đóng thì
  vòng reconcile là no-op.

### 4.9 Adapter — lớp chuyển tiếp thuần

`SCPFullscreenAdapter.m` **viết lại thân** (protocol giữ nguyên
từng chữ — pinch controller không sửa):

- `currentState` → ánh xạ trạng thái đã chốt của controller
  (mục 4.1); controller chưa cài (process khác) → Unknown.
- `requestExpandWithCompletion:` /
  `requestRestoreWithCompletion:` → chuyển thẳng cho
  controller, completion là completion của controller (đã qua
  xác nhận thật ở 4.4/4.5).
- `stateDidChange` → adapter đăng ký nghe sự kiện chốt của
  controller một lần lúc khởi tạo và phát lại nguyên trạng.
- Adapter không khai báo biến trạng thái fullscreen nào; kiểm
  chứng bằng grep ở Gate 1 (mục 10).

### 4.10 Phát trạng thái cho wake owner

Tại hai điểm chốt (expand đạt / restore đạt / rollback / rút
gọn), controller gọi trực tiếp
`[[SCPCarSplit shared] bwSetExpandedActive:<BOOL> forBundle:nil]`
— cùng module, không qua adapter. `forBundle:nil` = cờ toàn
phiên theo đúng header `SCPCarSplit+BridgeWake.h` (bwExpanded
Active là trạng thái toàn cục của phiên fullscreen hiện hành).
Từ đây bảng phân xử bridgewake §2.2 hàng EXPANDED có nguồn thật:
owner phát VISIBLE, suppression tắt, pinchAllowed = 1.

## 5. Ranh giới EXPANDED ↔ trục mờ-idle (autohide) — điểm phối hợp duy nhất

> Phạm vi mục này: chỉ nêu ranh giới. Thiết kế autohide (ẩn
> handle/knob/logo theo idle như QA20, ghép wake DuoFace) là của
> strand riêng và phải khớp theo đúng năm luật dưới đây.

Hai trục độc lập: **trục FS** (SPLIT/EXPANDED — controller này
sở hữu) và **trục mờ-idle** (hiển thị chrome theo idle — wake
owner + autohide sở hữu). Tập phần tử không giao nhau, trừ nút
Home (luật R4 xử lý riêng):

- **R1 — EXPANDED thắng ở tầng phân xử.** Vào EXPANDED, trạng
  thái phân xử của mọi ô ép về VISIBLE bất kể vị trí của timer
  mờ (đã có sẵn trong bridgewake §2.2 hàng 1; FS1 chỉ cấp nguồn
  thật cho nó qua mục 4.10). Wake suppression vô hiệu toàn cục
  trong EXPANDED.
- **R2 — Timer mờ không chạy trong EXPANDED.** Trạng thái mờ-
  idle bị **đóng băng** (treo, không reset, không hết hạn) suốt
  thời gian EXPANDED: autohide không được ẩn thêm, không được
  hiện lại, không phát wake trong EXPANDED. Ngược lại FS không
  đụng một biến nào của trục mờ: không gọi `setBarVisible:`,
  không gia hạn `barTimer` (luật cách ly bridgewake §2.3 giữ
  nguyên).
- **R3 — Tập ẩn của FS không chứa phần tử của trục mờ.** FS ẩn
  cửa sổ status bar + nút Home + phủ dock bằng hình học (mục
  4.7). Bar/handle/knob/logo của ô và gương ABHost thuộc trục
  mờ toàn quyền — FS không ghi hidden/opacity của chúng ở bất
  kỳ thời điểm nào, kể cả lúc expand/restore.
- **R4 — Bàn giao nút Home theo chiều nhả, không ép.** Nút Home
  là phần tử chung duy nhất. Vào EXPANDED: FS ép ẩn (nó neo tại
  dock, nằm trong vùng bị phủ/mờ). Ra EXPANDED (điểm chốt
  restore, sau khi owner đã recompute theo EXPANDED=NO): FS
  **nhả** nút về giá trị trục mờ hiện đang phán quyết (đang
  VISIBLE thì nút hiện theo `refreshHomeButton` tự nhiên; đang
  HIDDEN thì giữ ẩn) — FS không tự đặt lại `hidden = NO` theo
  snapshot của mình. Cửa sổ status bar thì ngược lại: không
  thuộc trục mờ nên FS khôi phục đúng cờ gốc đã ghi (mục 4.7).
- **R5 — Hệ quả pinch tại ranh giới.** SPLIT + mờ-HIDDEN:
  pinch-out bị wake thắng (phân xử có sẵn) — cử chỉ đầu thuộc
  wake; pinch-out chỉ mở khi controls VISIBLE. EXPANDED +
  "controls đã ẩn" là trạng thái **không tồn tại** theo R1+R2,
  nên pinch-in trong EXPANDED luôn đi được — đây là đáp án cho
  ca "pinch-in khi controls đã ẩn" trong ma trận GPT: nó chỉ có
  thể xảy ra ở SPLIT, và ở SPLIT đáp án thiết kế là wake-trước.

## 6. Tương tác với cơ chế sẵn có + bảo toàn (GPT §6)

**Cổng vào expand** (mục 4.4 bước 1) từ chối khi: ô đang zoom
(`zoomedSlot`), đang solo hosted (`soloHostedBundle`), picker/
popup/tray đang mở, split không active. Từ chối = không làm gì
cả — FS không bao giờ đóng picker, kết thúc solo, hay huỷ zoom
thay người dùng.

**Trong lúc EXPANDED:**

- Đổi/đóng/mở app trong ô: đi đường layout thường; mọi relayout
  đều tính frame từ `container.bounds` đã phình và frame hosted
  tự đẩy lại qua `pushHostFramesLive:` — FS không can thiệp.
  App hosted chết/restart: hostClose/hostApp chạy như thường;
  vòng reconcile xác nhận lại frame là đủ.
- Lệnh solo/zoom lọt vào từ đường bridge (`bridgeBarAction` —
  vd bar mirror phía SpringBoard) trong lúc EXPANDED: FS không
  chặn được ở đầu vào (không hook — cấm), nên xử lý ở reconcile
  theo luật theo-thực-tế (mục 4.8): nhường vùng, về SPLIT an
  toàn, log. Không bao giờ gọi `runSoloForPane:` /
  `toggleZoomForPane:` từ FS — kể cả để "dọn đường".

**Bảng bảo toàn** — FS chỉ đổi: vùng trình bày của toàn split
(qua một điểm tham vấn), `clipsToBounds` của parent (có khôi
phục), cờ hidden của cửa sổ status bar (có ghi gốc), hidden của
nút Home (theo R4). Không đổi: hai ô + tỉ lệ (`fractions`
nguyên), scene ownership, Maps/YouTube native/hosted, touch/
scroll/keyboard (kênh `appbridge.keyboard` không đụng), divider
pan, zoom-ô + solo hiện hữu (chỉ bị từ chối *cạnh tranh*, không
sửa), picker, Home/dock khi ở SPLIT, giao thức orientation
fixround6/7 (kênh `appbridge.apporient` / hai hook VC — ngoài
phạm vi tuyệt đối).

## 7. Đường thoát khỏi EXPANDED

**Chính — pinch-in qua recognizer trên container** (luận cấu
trúc, chờ Gate 3 kiểm): recognizer của `SCPPinchController` gắn
trên chính container. Khi EXPANDED: container vẫn là cùng một
view đó, chỉ lớn lên thành window bounds; các ô là con của nó,
frame suy từ `container.bounds`; `hitTest` của
`SCPCarSplitView` duyệt toàn cây con như cũ → cặp chạm trên ô
vẫn đi qua container → recognizer tổ tiên vẫn nhận đủ
Began/Moved/Ended. Những gì FS ẩn nằm **ngoài** cây container
(cửa sổ status bar là cửa sổ riêng; dock bị phủ chứ không gỡ;
nút Home bị ẩn nhưng không phải tổ tiên của ô) — không thứ nào
cắt đường chạm tới ô. Điều kiện arm của recognizer (split
active + container có window) vẫn đúng trong EXPANDED;
`syncArming` không biết và không cần biết trạng thái FS. Cổng 2
của pinch đọc adapter: EXPANDED → chỉ nhận pinch-in; phân xử
hàng EXPANDED cho pinchAllowed = 1 (mục 5 R1/R5).

**Độc lập với chạm — đường thoát của giai đoạn staging:** công
tắc test ở Prefs (mục 8) tắt là restore, không phụ thuộc đường
chạm nào còn sống.

**Cuối cùng — teardown:** ngắt CarPlay / dashboard invalidate
luôn restore rút gọn (mục 4.6). Đây là tầng cuối, không tính là
đường thoát đạt chuẩn cho ENFORCE.

**Khoá ENFORCE pinch** (kế thừa design-pinch §5.3, cụ thể hoá):
chỉ arm khi (a) controller đạt nghiệm thu staging (mục 8) —
expand/restore đúng trên xe; và (b) tại chính staging đó,
pinch-in (vẫn DRY_RUN về mode, nhưng đường adapter đã thật) —
không: pinch-in ở staging được kiểm bằng cách bật công tắc test
để vào EXPANDED rồi pinch-in phải restore được ≥ 3 chu kỳ liên
tiếp, cộng 1 lần ngắt CarPlay giữa EXPANDED khôi phục sạch.
Thiếu một trong hai → PINCH_MODE tối đa DRY_RUN.

## 8. Staging — nghiệm thu controller trước, pinch sau (GPT §7)

**Candidate FS1-test** gồm: controller + adapter chuyển tiếp +
điểm tham vấn diện tích + keo cài đặt/reconcile/teardown +
đường kích hoạt test dưới đây. **PINCH_MODE giữ DRY_RUN** trong
candidate này (pref vắng = DRY_RUN theo bridgewake §4); wake
giữ nguyên hành vi wake1.

**Đường kích hoạt độc lập — công tắc test trong Prefs:**

- Khoá plist: `fullscreenTestExpand` (BOOL) trong domain
  `com.anlai.omnicar`; mặc định **vắng = NO**.
- Mặt UI: một `PSSwitchSpecifier` trong
  `OmniCarPrefs/Resources/FeatureSplitScreen.plist`, nhóm riêng
  ghi rõ "TEST — Fullscreen (chỉ dùng nghiệm thu)", default
  false. (Đường dự phòng nếu strand Prefs chậm: ghi khoá trực
  tiếp vào plist domain — controller không phân biệt nguồn ghi.)
- Controller nghe đúng kênh sẵn có `SCPNotePrefsChanged`
  (Darwin `com.anlai.omnicar/prefschanged`, `SCPShared.m:10` —
  cùng kênh `bwReloadModesAndRepublish` đang dùng): khoá thành
  YES → `requestExpand` (provenance `test`); thành NO →
  `requestRestore`. Lệnh test đi qua cùng cổng vào/txn/xác
  nhận như lệnh pinch — không đường tắt riêng trong controller.
- **Gỡ bỏ**: xoá specifier + nhánh quan sát khoá trong
  controller (một điểm duy nhất, đánh dấu `// [fs1-test]`).
  Đường pinch không tham chiếu gì tới khoá test nên gỡ không
  ảnh hưởng. Candidate sau staging không chứa specifier.

**Gate 3 rút gọn cho controller (trên xe, Wake/Pinch chưa
ENFORCE):**

1. Bật công tắc → vùng split phình đúng window bounds: cả hai
   ô phóng theo, tỉ lệ giữ nguyên, divider/knob theo đúng vị
   trí tương đối; dock + status bar biến mất; nút Home biến
   mất.
2. Trong EXPANDED: chạm/cuộn/gõ phím trong cả ô native và ô
   hosted bình thường; frame hosted khớp ô (không lệch hình).
3. Tắt công tắc → container về đúng frame trước expand;
   clips/ cờ status bar / nút Home / dock trở lại đúng trạng
   thái trước; log chốt `fs expand confirmed` / `fs restore
   confirmed` (không có `unconfirmed` / `rollback`).
4. 10 chu kỳ bật/tắt liên tiếp: không lệch frame tích luỹ,
   không kẹt trạng thái.
5. Đang EXPANDED: đóng một app, mở app khác; ngắt CarPlay →
   kết nối lại: split ở SPLIT sạch, dock/status bar bình
   thường (ma trận mục 9).

## 9. Ma trận crash/rollback — controller phải tự xử (GPT §7)

| Trường hợp | Hành vi controller |
|---|---|
| 10 lần expand/restore liên tiếp | Mỗi chu kỳ là transaction riêng, snapshot chụp mới; xác nhận từng lần (4.4/4.5). Không tái dùng snapshot cũ; không tích luỹ lệch (kiểm ở Gate 3 staging mục 8.4) |
| Đổi app khi đang fullscreen | Không hành động: relayout thường trong vùng đã phình; reconcile xác nhận frame. Đổi app qua đường solo/zoom → override: về SPLIT an toàn (4.8) |
| Ngắt CarPlay khi đang fullscreen | `dashboardInvalidated` → restore rút gọn (4.6): clips + chrome + phát NO, không relayout. Phiên mới luôn bắt đầu SPLIT (state thuần bộ nhớ — như [XM]) |
| App hosted chết / restart giữa chừng | Đường hostClose/hostApp gốc xử lý; FS chỉ reconcile frame. Hosted chết không được kéo FS về SPLIT cũng không giữ EXPANDED giả — frame là sự thật duy nhất |
| Split vô hiệu khi đang fullscreen | Như ngắt CarPlay: glue teardown hoặc reconcile thấy `!active` → restore rút gọn |
| Home/dock sau mọi teardown | Restore rút gọn luôn gồm khôi phục chrome (status bar đúng cờ gốc, nút Home nhả theo R4) + clips. Kiểm chứng tại Gate 3 staging: sau ngắt, dock/status bar/Home bình thường |
| Pinch-in khi controls đã ẩn | Theo R5: ở EXPANDED trạng thái này không tồn tại (R1+R2) → pinch-in luôn mở. Ở SPLIT + HIDDEN thì wake thắng — không phải lỗi, là thiết kế |
| Expand thất bại giữa chừng (parent mất window, rect không hợp lệ, xác nhận lệch) | Rollback đầy đủ (4.6): hệ đo lại được như trước lệnh, completion NO, log kèm số đo |
| Restore không xác nhận được | Một retry 0,05 s → chốt an toàn về SPLIT + khôi phục chrome/clips + log lỗi (4.5) — không giữ nhãn EXPANDED |
| Hai lệnh expand/restore chồng nhau (pinch + test cùng lúc) | Lệnh đến sau bị từ chối `fs busy` (4.2); callback quá hạn bị txn loại |

**Nguyên tắc lỗi (không thương lượng):**

1. Không bao giờ để `clipsToBounds` sai sau bất kỳ đường ra
   nào — clips nằm trong snapshot và mọi đường (restore,
   rollback, rút gọn) đều qua một điểm khôi phục duy nhất.
2. Không bao giờ để dock/status bar còn ẩn sau khi split kết
   thúc — teardown là một trong các đường khôi phục ở nguyên
   tắc 1, cộng kiểm chứng staging.
3. Không bao giờ báo EXPANDED giả — EXPANDED chỉ tồn tại sau
   xác nhận frame (4.4 bước 5); mọi mơ hồ đều rơi về SPLIT +
   log.

## 10. Kế hoạch theo file + cổng tĩnh

**Strand A — controller + adapter** (file mới + viết lại):

| File | Việc |
|---|---|
| `OmniCarSplitScreen/SCPFullscreenController.h/.m` (mới, 2 cây) | Máy trạng thái, snapshot/txn, chuỗi expand/restore/rollback/rút gọn, `fsAreaForParent:nativeArea:split:`, `fsChromeSetHidden` + bản đồ ghi gốc, `fsDidLayout`, `fsSessionDidEnd`, nhánh test `[fs1-test]` nghe `SCPNotePrefsChanged` |
| `OmniCarSplitScreen/SCPFullscreenAdapter.m` (viết lại thân) | Chuyển tiếp thuần theo 4.9; header giữ nguyên |

**Strand B — điểm phối hợp + keo** (sửa tối thiểu, một người):

| File | Việc |
|---|---|
| `SCPCarSplit+Layout.m` | Đúng một dòng tham vấn tại return của `appAreaInParent:` (4.3) |
| `SCPHooks.m` | Keo: `__init_1` cài controller (cạnh `bwInstallOwner`); seam `rootDidLayout` cộng `fsDidLayout` (cạnh `syncArming` của pinch) |
| `SCPCarSplit.m` | Keo: `dashboardInvalidated` cộng `fsSessionDidEnd` cạnh hai dòng keo wake/pinch sẵn có |
| `Makefile` module | +1 TU (controller) |

**Strand C — staging** (gỡ được toàn bộ):

| File | Việc |
|---|---|
| `OmniCarPrefs/Resources/FeatureSplitScreen.plist` | +1 switch specifier `fullscreenTestExpand`, default false, nhóm TEST |

**Gate 1 tĩnh cho FS1** (trên candidate đã bung, như wake1):
tham vấn trong `appAreaInParent:` xuất hiện đúng 1 lần; grep
`OMCChromeSetHidden` / `runSoloForPane:` / `toggleZoomForPane:`
/ `dividerDoubleTapped` / `ratioPresetTapped` trong các file
FS = 0; adapter không chứa biến trạng thái (grep ivar/static);
`bwSetExpandedActive` chỉ có controller gọi thêm ngoài owner;
selector parity so với wake1 mất 0; hai cây mirror identical.

**Điểm chưa biết — chỉ staging trên xe mới chốt được** (không
đoán trong thiết kế): (i) z-order dock view so với container đã
phình trên đầu xe của Nguyen (tiền lệ QA20: phủ được; dự phòng
ở 4.7 mục 3); (ii) trên iOS 16.7.16 cửa sổ status bar thuộc
class `DBStatusBarWindow` hay `CARStatusBarWindow`, và có
instance sống trong CarPlayApp lúc split active không — quét
theo cả hai tên, log kết quả ở lần expand đầu; (iii) window
bounds trong parent có đúng là vùng Nguyen gọi là "toàn màn"
trên đầu xe của anh (khuôn hình CarCast mirror có thể letterbox
— phán quyết bằng mắt của anh tại staging, không bằng số đo
ảnh).

---
*Hết thiết kế FS1. Trạng thái: thiết kế — chưa cài đặt. Thứ tự
tiếp theo theo GPT: strand A/B/C → candidate FS1-test (pinch
DRY_RUN) → Gate 3 rút gọn trên xe → mới mở đường ENFORCE pinch.*
