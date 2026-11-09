# IMPL FS1 — STRAND A: SCPFullscreenController + adapter chuyển tiếp

Trạng thái: **XONG** — source hoàn thiện, biên dịch riêng 0 lỗi / 0 cảnh
báo, cổng tự kiểm đạt. Đặc tả: design-fullscreen-fs1.md §1–§5, §9–§10.
Chưa nối keo (strand B), chưa vào Makefile (strand B), chưa build
module/candidate.

## File đã làm (cả hai cây, cmp identical)

| File | Việc | Dòng |
|---|---|---|
| `OmniCarSplitScreen/SCPFullscreenController.h` (MỚI) | Giao diện công khai của owner duy nhất | 84 dòng |
| `OmniCarSplitScreen/SCPFullscreenController.m` (MỚI) | Máy trạng thái + snapshot/txn + expand/restore/rollback/rút gọn + chrome nội bộ + reconcile + nhánh test | 560 dòng, 23.473 B |
| `OmniCarSplitScreen/SCPFullscreenAdapter.m` (viết lại thân) | Chuyển tiếp thuần §4.9; header + protocol giữ nguyên từng chữ | 55 dòng, 2.325 B |

## Controller — ánh xạ theo thiết kế

- **Máy + sở hữu duy nhất** (§4.1): phase Split/Expanding/Expanded/
  Restoring ở extension riêng (.m:78–99); snapshot một bản
  {_snapParent weak, _snapOriginalArea, _snapTargetArea,
  _snapPreviousClips, _snapTxn}; adapter/pinch/wake không giữ biến FS
  nào (adapter kiểm ở cổng dưới).
- **Cờ nội bộ vs trạng thái chốt**: `fsAreaForParent:` khóa trên cờ
  `_expandedFlag` (lật TRƯỚC relayout như state.expanded của QA20) ở
  hai phase Expanding/Expanded, trong khi `fsCommittedState` khóa
  trên phase đã chốt — EXPANDING báo Split, RESTORING báo Expanded
  (§4.1); chưa cài (process khác) → Unknown.
- **Snapshot + transaction** (§4.2): `_txnCounter` tăng đơn điệu; lệnh
  vào lúc Expanding/Restoring → từ chối `fs busy txn=<n>` + completion
  NO, không hàng đợi; retry restore mang txn, lệch txn/phase → bỏ.
- **Expand** (.m:262 `fsExpandWithCompletion:`): cổng vào từ chối êm
  theo thứ tự inactive → host-unavailable → zoomed → solo → picker →
  popup → tray (log `fs expand refused reason=…`, không tự dọn gì);
  snapshot chụp trước khi lật (original qua appAreaInParent: tiền-lật,
  target = window bounds trong parent như [XM :55], cả hai qua
  FSAreaValid > 50 pt); clips=NO; `relayoutAnimated:NO pushScenes:YES`
  + `rootDidLayout`; **xác nhận đọc lại**: container.frame ≈ target
  (±0,5 pt/thành phần) + superview == parent snapshot + window còn +
  active còn — lệch → log số đo `fs expand unconfirmed` + rollback.
  Chốt: chrome → `bwSetExpandedActive:YES forBundle:nil` →
  stateDidChange(Expanded) → completion YES.
- **Restore** (.m:394): hạ `_expandedFlag` TRƯỚC + khôi phục clips;
  cùng cặp lệnh relayout; xác nhận đối chiếu **diện tích gốc hiện
  hành** (appAreaInParent: tính lại lúc đó — vùng hiện hành thắng
  snapshot); sai → đúng 1 retry sau 0,05 s (SCPDispatchAfter,
  txn-guarded); vẫn sai → **chốt an toàn SPLIT**: khôi phục
  chrome/clips + bw NO + log `fs restore-unconfirmed` + completion NO
  — không EXPANDED giả (§9 nguyên tắc 3).
- **Rollback** (.m:357): hạ cờ → clips → relayout + rootDidLayout →
  chrome NO → bw NO → SPLIT + log số đo cuối.
- **Restore rút gọn** (.m:494 `fsSessionDidEnd`): KHÔNG relayout; vô
  hiệu txn (loại retry đang bay, pending completion trả NO); clips +
  chrome + bw NO; SPLIT. Đúng mẫu teardown setActive: của QA20 (§1.3).
- **Tham vấn diện tích** (.m:171 `fsAreaForParent:nativeArea:split:`):
  trả target CHỈ KHI cờ lên + phase ∈ {Expanding, Expanded} + parent
  == parent snapshot + split.active + target hợp lệ; ngoài ra trả
  native nguyên vẹn.
- **Chrome nội bộ** (.m:206/227/249): `fsChromeSweepAndHide` quét cửa
  sổ theo tên class DBStatusBarWindow/CARStatusBarWindow, ghi cờ
  hidden gốc lần đầu (NSMapTable yếu→mạnh), ẩn ngay cả cửa sổ xuất
  hiện muộn (reconcile quét lại); khôi phục = trả đúng cờ gốc từng cửa
  sổ rồi xoá bản ghi; không thấy cửa sổ → log `fs chrome FAILED
  no-window`, không latch, không chặn expand. Nút Home: ép hidden ở
  điểm chốt expand + ép lại mỗi reconcile; restore KHÔNG ép hiện (nhả
  theo R4); không gọi removeHomeButton ở đâu cả.
- **Reconcile** (.m:519 `fsDidLayout`): no-op trừ khi EXPANDED + txn
  snapshot còn sống + không re-entrant; !active → rút gọn;
  soloHostedBundle/zoomedSlot xuất hiện → log `fs external-override`
  + rút gọn (không gọi ngược hàm solo/zoom nào); frame lệch target →
  1 lần relayout + rootDidLayout rồi đo lại, vẫn lệch → rút gọn; cuối
  vòng ép lại chrome.
- **Phát wake** (§4.10): bwSetExpandedActive gọi tại đúng các điểm
  chốt — YES ở expand-confirmed; NO ở restore-confirmed,
  restore-unconfirmed, rollback, session-end. forBundle:nil (cờ toàn
  phiên).
- **[fs1-test]** (.m:112–158, mọi điểm đều đánh dấu `// [fs1-test]`):
  `fsInstallIfNeeded` đăng ký notify_register_dispatch trên
  SCPNotePrefsChanged (cùng kênh bwReloadModesAndRepublish dùng);
  đọc OMCPref `fullscreenTestExpand` (vắng = NO), chỉ hành động ở
  cạnh đổi giá trị (baseline lúc cài không hành động); lệnh test đi
  qua ĐÚNG fsRequestExpand/Restore (provenance `test`) — cùng cổng/
  txn/xác nhận như lệnh pinch (provenance `pinch` từ adapter); log
  nhánh test mang tiền tố [fs1-test].

## Giao diện công khai cho strand B dùng (SCPFullscreenController.h)

- `#import "SCPFullscreenController.h"` — header chỉ phụ thuộc
  Foundation/UIKit + SCPFullscreenAdapter.h (SCPFullscreenState).
- Cài đặt (__init_1, cạnh bwInstallOwner):
  `[[SCPFullscreenController shared] fsInstallIfNeeded];`
- Điểm tham vấn (§4.3, return duy nhất của appAreaInParent: trong
  SCPCarSplit+Layout.m):
  `return [[SCPFullscreenController shared] fsAreaForParent:parent nativeArea:area split:self];`
- Seam rootDidLayout: `[[SCPFullscreenController shared] fsDidLayout];`
- Teardown dashboardInvalidated:
  `[[SCPFullscreenController shared] fsSessionDidEnd];`
- Makefile: +1 TU `SCPFullscreenController.m` (adapter đã có sẵn
  trong FILES từ wake1).
- Adapter không cần keo thêm: nó tự đăng ký fsStateDidChange lúc
  -init và gọi +shared mỗi lần được hỏi.

## Cổng tự kiểm (đo trên bản cuối)

- Biên dịch riêng bằng clang-18 (SDK iPhoneOS16.5, -target
  arm64-apple-ios15.0, -fobjc-arc, -fno-modules, -include
  SCPIntegrationShims.h, flags tương đương module) với -Wall -Wextra:
  SCPFullscreenController.m **0 lỗi / 0 cảnh báo** (object 54.080 B);
  SCPFullscreenAdapter.m **0 lỗi / 0 cảnh báo** (object 14.480 B,
  llvm-nm: _OBJC_CLASS_$_SCPFullscreenAdapter defined, tham chiếu
  _OBJC_CLASS_$_SCPFullscreenController — đúng hình chuyển tiếp).
- Chuỗi cấm trong cả 4 file FS (controller .h/.m, adapter .h/.m):
  grep `OMCChromeSetHidden|runSoloForPane|toggleZoomForPane|`
  `dividerDoubleTapped|ratioPresetTapped` = **0** (kể cả trong
  comment — biên bản này là nơi duy nhất nhắc tên để ghi cổng).
- Adapter không biến trạng thái: grep ivar/static của FS trong
  SCPFullscreenAdapter.m = 0 (chỉ còn _stateDidChange là backing của
  property protocol).
- Hai cây mirror: cmp identical cho cả 3 file đã làm.
- bwSetExpandedActive: trong strand A chỉ controller gọi (adapter
  không gọi) — khớp cổng Gate 1 §10 "chỉ có controller gọi thêm
  ngoài owner".

## Hai điểm diễn giải đã chốt trong code (để tích hợp/GPT phán)

1. **Đi cửa sổ bằng connectedScenes thay cho UIApplication.windows**:
   design §2 viết "quét UIApplication.windows" — accessor phẳng đó
   deprecated từ iOS 15 và là cảnh báo duy nhất khi biên dịch. Bản cài
   dùng đúng idiom sẵn có của module (connectedScenes →
   UIWindowScene.windows, như -installIconLongPress
   SCPCarSplit.m:3249): cùng tập cửa sổ của process, quét theo tên
   class như thiết kế, 0 cảnh báo. Khác biệt hành vi: không có — tập
   cửa sổ là một.
2. **fsRestoreConfirmed đo trên parent hiện tại của container**:
   §4.5 bước 4 đối chiếu "diện tích gốc hiện hành"; bản cài tính
   appAreaInParent: trên superview hiện tại của container (bình
   thường chính là parent snapshot). Nếu container bị re-parent giữa
   chừng, phép đo theo parent thật — hướng an toàn (đo sự thật, không
   đo snapshot).

## Chưa kiểm (thuộc strand B / tích hợp / Gate 3)

- Nối keo 4 điểm ở trên + Makefile; build toàn module; parity
  selector so với wake1 trên candidate.
- Hành vi thật trên xe theo Gate 3 rút gọn của design §8 (expand/
  restore bằng công tắc test, 10 chu kỳ, ngắt CarPlay giữa EXPANDED,
  pinch-in ≥3 chu kỳ khi đã ở EXPANDED) — strand A không có bằng
  chứng runtime nào, không tuyên bố gì về runtime.
