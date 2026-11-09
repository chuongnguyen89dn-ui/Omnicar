# AUTOHIDE — CÀI ĐẶT PHÍA CARPLAY PHẦN 1 (TU mới + F1 + header pack)

Ngày: 2026-11-09. Phạm vi strand: file mới `SCPCarSplit+AutoHide.h/.m`,
điểm F1 trong `SCPCarSplitView.m`, mở rộng `BridgeWakePack.h` (bản
SplitScreen). Cả hai cây project/ + src/ — mirror `cmp` identical 4/4 file.
Không đụng SCPCarSplit.m / SCPHooks.m / SCPCarSplit+BridgeWake.m / Makefile.

## 1. Đã giao

**`SCPCarSplit+AutoHide.h/.m`** (6.241 / 12.684 B) — controller theo
design-autohide §3:
- Một NSTimer 4,0 s toàn phiên (`kAHIdleSeconds`), độc lập tuyệt đối với
  barTimer/trayTimer/ratioTimer (grep: không một tham chiếu ghi/huỷ nào;
  ba timer gốc chỉ xuất hiện trong comment kỷ luật).
- Trạng thái trong file statics: `ahFaded` toàn cục + registry view đã sơn
  (NSHashTable yếu). Sơn đúng kỷ luật §2.5: **chỉ `layer.opacity`**, lưu
  opacity gốc per-view bằng associated object, sơn lại không ghi đè bản
  lưu, khôi phục trả đúng bản lưu rồi xoá. Grep kỷ luật: 0 phép gán
  `.hidden` / `.alpha` / `userInteractionEnabled` trong code mới.
- Tập sơn phía CarPlay: `handle` của mọi pane (`allPanes`), **cả divider
  lẫn `divider.knob`** (hai bản lưu riêng — bài học QA20), `homeButton`.
  Loại trừ tường minh: `ratioKnob` (chỉ xuất hiện trong comment loại trừ),
  `pane.bar`, `launcherHost`.
- Bắn timer → kiểm cổng §4.2 (mục 3 dưới) → đặt faded, sơn, ép
  `pushHostFramesLive:NO` + `publishKnobsSoon`, `bwRecomputeForPane:` cho
  mọi pane hosted. Log `[autohide] fade last=<src> idle=<s>`.
- Hiện lại dùng chung một thân (`ahRevealBody:`): khôi phục **mọi** view
  trong registry (kể cả view đã rời tập sơn — pane đóng giữa lúc mờ,
  homeButton bị thay), ép push frame/knob, recompute, log
  `[autohide] reveal reason=<...>`.
- Pref `bridgewake.autoHide`: vắng = **BẬT**; tắt giữa lúc mờ → khôi phục
  toàn bộ ngay + dừng timer (`ahReloadConfig`, đọc qua `OMCPref`).

**`SCPCarSplitView.m`** — F1: đúng một điểm chèn sau khi đã có `hit`
(không sửa câu lệnh gốc nào, `hit` trả nguyên): bộ lọc Began nguyên văn
QA20/thiết kế — `event.type == UIEventTypeTouches` ∧ điểm trong bounds ∧
`self.window != nil` ∧ tồn tại touch pha Began với `touch.window ==
self.window` → `[[SCPCarSplit shared] ahNoteActivity:AHSourceContainer]`.

**`BridgeWakePack.h`** (bản SplitScreen, 8.439 B): thêm `BWTypeAct = 5`
(6–7 vẫn dự trữ), ghi chú layout cho act (flag = kbActive, state/mode = 0)
và hai vector **V9 = 0xE9DA706800803805**, **V10 = 0xE9DA706801003C05**.
V1–V8 và toàn bộ hàm pack/unpack **không đổi một ký tự**.

## 2. Cổng đã chạy (đo trên bản cuối)

- Harness vector trên header đã mở rộng, biên dịch riêng cho cả hai cây:
  **15/15 PASS** — hash FNV khớp, V1–V7 pack khớp hex, V8 invalid,
  V9/V10 pack khớp + unpack round-trip đúng từng trường, `BWTypeAct == 5`.
- Biên dịch clang-18 (SDK iPhoneOS16.5, flags tương đương module:
  -fobjc-arc, -include SCPIntegrationShims.h, bộ -Wno-error của Makefile):
  `SCPCarSplit+AutoHide.m` exit 0, **0 cảnh báo** ở cả `-Wall` và
  `-Wall -Wextra`; `SCPCarSplitView.m` exit 0, 0 cảnh báo. Object là
  Mach-O arm64 hợp lệ; 25 symbol category AutoHide có mặt; selref
  `ahNoteActivity:` có mặt trong object của SCPCarSplitView.

## 3. Điều kiện không-mờ tại thời điểm bắn (§4.2) — đã cài

Đánh giá chỉ khi timer bắn; chặn thì log `fade deferred (<lý do>)` và gài
lại 4,0 s, không bỏ chu kỳ:
- `bwExpandedActive` (đọc qua header BridgeWake — giao diện sẵn có) → `expanded`;
- `soloHostedBundle != nil` → `solo` (lớp phòng thủ thứ hai cạnh ahSetSuspended);
- kbHold còn hạn → `kbhold` (hold tự hết hạn 10 s, xoá lười tại điểm kiểm);
- `popupOpen` ∨ `pickerSheet` ∨ `ratioMenu` ∨ (tray lên không overlay) → `surface-open`;
- `resizing` ∨ `dragGhost != nil` → `dragging`.

## 4. Giao diện công khai cho phần 2 (điểm chờ — chưa nối)

Phần 2 (chủ SCPCarSplit.m / SCPHooks.m / SCPCarSplit+BridgeWake.m /
Makefile) nối các điểm sau — toàn bộ đã có sẵn trong header:
1. **Makefile**: thêm `SCPCarSplit+AutoHide.m` vào FILES; **SCPHooks.m
   `__init_1`**: gọi `[split ahInstall]` ngay sau `bwInstallOwner`.
2. **Kích hoạt phiên**: gọi `ahSessionStarted` tại điểm split thành
   active (đối tác của `ahSessionTeardown` cạnh `bwSessionTeardown` ở
   dashboardInvalidated). **Quan trọng**: thiếu điểm này, lần mờ đầu tiên
   của phiên trễ tới activity đầu tiên — điểm đo §5.5.1 (vào split không
   chạm 4 s) sẽ trượt. `ahReloadConfig` cố ý không gài lại khi pref
   không đổi (kỷ luật QA20: layout lặp lại không reset timer).
3. **Payload**: `hostFrameInfo:` cộng `info[@"fade"] = @([self ahFaded])`;
   `publishKnobsNow` cộng `@"kfade"` cạnh `@"knobs"`.
4. **Feed F2/F3**: cuối `bridgeHandleTapped:` →
   `ahNoteActivity:AHSourceHostHandle`; `remoteKnobTouch:` →
   `AHSourceHostKnob`; `homeButtonTapped` → `AHSourceHome`; kết thúc kéo
   divider/pane (endResize/endPaneDrag) → `AHSourceDragEnd`.
5. **BridgeWake**: `bwRecomputeForPane:` cộng hợp phần
   `fadedEffective = enabled ? [self ahFaded] : YES` (§3.3);
   `bwHandleWakePacket:` trên đường chấp nhận gọi
   `ahRevealWithReason:AHRevealWake`; kênh `act` (hằng
   `bridgewake.v1.act` ở SCPShared.m) + `bwHandleActPacket:` kiểm
   hash/gen xong chuyển `ahNoteActWithKbActive:flag`;
   `bwSetExpandedActive:forBundle:` gọi `ahSetSuspended:` cùng nhịp
   (vào EXPANDED = YES, ra = NO; phiên solo hosted cũng treo tương tự);
   `bwReloadModesAndRepublish` gọi thêm `ahReloadConfig`.
6. **Áp-lại sơn cho view sinh muộn** (mẫu QA20 paint-at-layout):
   cuối `layoutBarForPane:` → `ahApplyCurrentStateToView:pane.handle`;
   cuối `rebuildDividers` → cho divider + knob; cuối `refreshHomeButton`
   → cho homeButton.

## 5. Ghi chú / lệch nhỏ

- `ahNoteActWithKbActive:` là ranh giới nhận act của TU này: việc đăng
  ký receiver + kiểm hash/gen của gói act thuộc TU BridgeWake theo đúng
  §5.1 của thiết kế (file của phần 2) — strand này không tự đăng ký kênh
  thứ hai trong TU AutoHide để tránh hai chủ kênh.
- Thêm `ahSessionStarted` ngoài danh sách method của thiết kế §5.1
  (thiết kế chỉ nêu ahSessionTeardown): đây là đối tác vòng đời tối
  thiểu để đồng hồ đầu tiên tồn tại; không đổi ngữ nghĩa nào của thiết kế.
- EXPANDED tại điểm bắn được đọc qua `bwExpandedActive` (đầu vào owner
  đã có) cộng cờ treo `ahSuspendedState` do phần 2 đẩy — hai lớp độc lập
  như §4.1 yêu cầu.
