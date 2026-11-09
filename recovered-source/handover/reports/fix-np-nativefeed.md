# FIX-NP — Probe tiến hoá: feed activity cho ô native + đo tập touch chống trùng (WO GPT mục 2+3)

Mức đạt: **source complete / build PASS / static PASS** (chưa có bằng chứng xe).
File duy nhất sửa: `project/OmniCarSplitScreen/SCPTouchProbe.m` (9.538 → 24.825 B) + `.h` (chỉ cập nhật comment vai trò); mirror `src/SplitScreenA/` cmp identical cả hai file. Không đụng AutoHide/BridgeWake/Picker/FS controller.

## Phần A — Feed native (SCPProbeFeedEvaluate, SCPTouchProbe.m:268)

Đường gọi: hook `sendEvent:` giữ nguyên (orig chạy trước, event nguyên vẹn, quan sát trong @try/@catch) → tại mỗi Began, SAU dòng phân loại [probe] cũ, chạy `SCPProbeFeedEvaluate` → nếu qua đủ cổng thì gọi **đúng đường F1**: `[split ahNoteActivity:AHSourceContainer]` (SCPTouchProbe.m:324 — lời gọi ahNoteActivity duy nhất của TU). KHÔNG nuốt, KHÔNG chặn, KHÔNG reveal trực tiếp; ahNoteActivity tự guard (installed/enabled/active/suspended) và tự về main queue.

**Điểm thiếu API (ghi theo lệnh):** (1) `ahNoteActivity:` đã public trong SCPCarSplit+AutoHide.h nên gọi được ngay — nhưng enum `AHActivitySource` không có giá trị riêng cho feed probe-native; dùng `AHSourceContainer` (F1) là đường public gần nhất về ngữ nghĩa (Began phía CarPlayApp ở mức container). Hệ quả: trường "last source" nội bộ của AutoHide sẽ đọc là container; attribution chính xác (ô/bundle/window) nằm ở dòng `[probe-feed] fired` của probe. Muốn tách tag riêng phải sửa SCPCarSplit+AutoHide.h — ngoài phạm vi file của strand này, để coordinator/GPT quyết. (2) Generation: xem dưới đây.

**Quy đổi tọa độ (mới, SCPProbeTouchScreenPoint / SCPProbeViewScreenRect):** điểm chạm: `locationInView:touch.window` → `touch.window.coordinateSpace` → `window.screen.coordinateSpace`. Hình ô: `convertRect:bounds toView:nil` (vào chính window của view đó — cùng một window theo cấu trúc, không phải chuyển giữa hai window) → coordinateSpace của window đó → screen space. Giao nhau chỉ trong screen space. Classifier cũ (`locationInView:nil` + `convertPoint:fromView:nil` xuyên window) giữ nguyên cho log [probe] — hai kết quả cùng xuất hiện trong log để đối chiếu.

**Nguồn generation:** `bwGenBySlot` là file-static trong SCPCarSplit+BridgeWake.m, header không phơi ra → TU này KHÔNG đọc được (điểm thiếu đã ghi). Gen dùng thay thế: **epoch phiên của probe** (`SCPProbeFeedEpoch`) neo trên trạng thái SCPCarSplit: tăng khi identity của `split.container` hoặc cửa sổ của nó đổi (phiên mới dựng container mới qua ensureContainer) và khi `active` rơi (cạnh teardown dashboardInvalidated). Mọi đầu vào còn lại (pane còn gán — đọc `[split allPanes]` live cùng lượt, screen, popup) đều đọc tại chỗ trong cùng một pass, nên một quyết định không bao giờ mang gen lệch với trạng thái đã tính. Epoch in trong mọi dòng [probe-feed].

**Định nghĩa vùng hệ thống (loại):** (a) window identity: class `DBStatusBarWindow` (đúng quy ước sẵn có của module, cf. SCPFullscreenController.m:227) — loại ở mọi điểm; (b) góc Home theo hình học screen space: hình vuông 48×48 pt ở góc dưới-trái của `screen.bounds` — các điểm thoát trong log mẫu {12.5–23.5, 217–226} trên màn cao 240 pt đều nằm trong vùng này; áp cho MỌI window (bắt cả biểu diễn trùng qua _UISystemGestureWindow).

**Vị từ popup (khớp strand guard FS + Picker.m):** `pickerSheet != nil` (removePickerSheet nil đồng bộ ngay khi đóng, Picker.m:658) → `tray != nil` → `trayWindow != nil && !trayWindow.hidden` (hideTrayWindowIfIdle chỉ ẩn window khi tray/ratioMenu/pickerSheet/dragGhost đều nil — window còn hiện ⇒ còn overlay) → `ratioMenu != nil` → `dragGhost != nil` → `resizing`. Tên sub-condition in trong reason `drop-popup(<sub>)`.

**Bảng cổng phát** (đúng thứ tự trong code; mọi quyết định đều log `[probe-feed] t=<monotonic> epoch=<n> …`):
| # | Cổng | Drop reason |
|---|---|---|
| 1 | split.active | drop-inactive |
| 2 | touch có window/screen để quy đổi | drop-unconverted |
| 3 | touch.screen == screen chứa container (màn CarPlay) | drop-display |
| 4 | vùng hệ thống (DBStatusBarWindow / góc Home 48×48) | drop-systemregion |
| 5 | popup/overlay đang hoạt động (vị từ trên) | drop-popup(sub) |
| 6 | điểm thuộc ô theo quy đổi screen-space, ô còn gán live, có bundle | drop-notassigned |
| 7 | ô hosted → F4 sở hữu, không phát trùng | drop-hosted |
| — | nhãn foreign/_UISystemGestureWindow | KHÔNG phải cổng — vẫn là ứng viên đầy đủ nếu thuộc ô |
| ✔ | ô native qua đủ cổng | **fired** → ahNoteActivity:AHSourceContainer |

## Phần B — Đo tập touch (chỉ đo, SCPProbeTouchSet*)

Mỗi UITouch đang sống có một record theo con trỏ: `win` (class của window), `raw` (điểm trong window của touch), `scr` (điểm screen-space đã quy đổi), `pane` (gán ô bằng chính resolver screen-space của Phần A), `evB`/`evL` (event.timestamp tại Began / tại phase cuối), `tB`/`tL` (monotonic). Began thêm, Moved cập nhật điểm/ô/timestamp, Ended/Cancelled gỡ. Mỗi EVENT làm thay đổi tập → đúng một dòng `[touchset] t=<mono> ev=<event.timestamp> active=N [ptr=… win=… raw={…} scr={…} pane=slotK(bundle) evB=…] …` (thứ tự theo tB). Cách đọc chống trùng: 2 biểu diễn của 1 contact (ca mẫu 15:37:57.243/.246, cùng điểm {15,222.5}, hai window) sẽ hiện thành 2 record với scr gần bằng nhau và evB lệch mili giây; 2 contact độc lập thật sẽ khác điểm scr rõ rệt. Probe KHÔNG ghép cặp, KHÔNG bắn lệnh, KHÔNG recognizer mới — quyết định chuyển điểm ghép cặp lên CarPlayApp để dành cho GPT khi có dữ kiện này.

## Cổng kiểm

- Build module SplitScreen từ sạch (`make clean && make`, THEOS=~/theos, umask 022): **exit 0, 0 error**; SCPTouchProbe.m biên dịch không warning (warnings còn lại là cũ ở Layout/RatioMenu/Relayout). Dylib 1.299.664 B chứa đủ chuỗi: `[probe-feed]` ×8 format, `[touchset]` ×1 (kiểm dương tính trên binary).
- MSHookMessageEx: lời gọi trong TU vẫn đúng **1** (:524; hit còn lại là comment :5) — tổng hook module không tăng (31 call-site như vòng trước).
- grep kỷ luật: TU không chứa lời gọi ahReveal*/cancel/swallow nào (hit duy nhất là từ "swallows" trong comment); lời gọi activity duy nhất là `ahNoteActivity:` :324.
- Mirror: `cp` + `cmp` — project/ ≡ src/SplitScreenA/ cho cả .m và .h; kiểm `grep "\[truncated"` = 0 cả hai file nguồn.

## Để lại cho vòng xe / GPT

- Lượt test sạch đầu tiên phải cho thấy: chạm ô native lúc controls đang mờ → `[probe-feed] fired pane=slotK(<bundle native>)` rồi `[autohide] reveal-applied reason=activity` — đó là chuỗi kết án feed sống. Các dòng drop-* theo reason cho biết cổng nào ăn nếu chưa đạt.
- Dữ kiện [touchset] của các lần pinch thử (nấc Đo) là đầu vào cho quyết định kiến trúc pinch của GPT (mục 3 WO): có 2 contact độc lập đồng thời cùng ô hay chỉ có biểu diễn trùng.
