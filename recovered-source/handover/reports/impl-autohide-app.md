# AUTOHIDE — PHÍA ABINAPP: PHÁT GÓI ACT (impl)

Strand ABInApp của vòng AutoHide (design-autohide.md §3.2.1 + §5.3). Phạm vi:
chỉ ABInApp.m + BridgeWakePack.h bản AppBridge, cả hai cây project/ + src/,
mirror identical (cmp = 0 cho cả hai file sau sửa).

## Đã cài

### BridgeWakePack.h (bản AppBridge)
- Enum type: thêm `BWTypeAct = 5` (giá trị trống đầu tiên sau ack = 4;
  6–7 vẫn dự trữ). Comment layout/kỷ luật trường cập nhật tương ứng:
  flag của gói act = kbActive, các trường state/mode = 0.
- Danh sách kênh trong comment đầu file thêm kênh thứ 5
  `com.anlai.omnicar/bridgewake.v1.act` (app → owner).
- Test vector bổ sung nguyên văn design-autohide §3.2.1:
  V9 act yt seq=1 gen=7 flag=0 → `0xE9DA706800803805`;
  V10 act yt seq=2 gen=7 flag=1 → `0xE9DA706801003C05`.

### ABInApp.m
- `BWNameAct = "com.anlai.omnicar/bridgewake.v1.act"` — static file-local
  cạnh 4 tên kênh sẵn có (cùng idiom wake1; chuỗi đúng §3.2.1).
- Statics mới: `BWActToken`, `BWActSeq` (seq đơn điệu phía app, mod 4096),
  `BWLastActAt` (mốc throttle).
- Hàm mới `BWPostAct()` (ngay sau `BWPostWake`): throttle **0,12 s**;
  token riêng theo idiom `notify_register_check` (như ABKeyboardPublish);
  đóng gói `BWPackFields(BWOwnHash28(), ++BWActSeq, BWGen, kbActive,
  0, 0, 0, BWTypeAct)` rồi `notify_set_state` + `notify_post`. `kbActive`
  = `BWKb == BWKbActive` — trạng thái keyboard guard sẵn có của ABInApp
  (phiên first-responder/frame, §5.5 design-bridgewake) tại thời điểm phát.
  Gói không mang nội dung chạm nào (không toạ độ, không số ngón).
- Điểm gọi duy nhất: trong `BWHandleTouchEvent`, tại khối mở dãy
  (sequence start — đường Began), sau khi chốt các sự thật của dãy và
  **trước** đánh giá cổng `BWGatePass`/mọi quyết định nuốt:
  `if (BWFresh()) BWPostAct();`. Điều kiện phát = sessionValid theo đúng
  §5.1 design-bridgewake ánh xạ lên sự thật state client sẵn có
  (`BWKnown && còn tươi ≤ 2,5 s` = `BWFresh()`; gen mang theo là BWGen —
  gen của gói state tươi gần nhất) — **không thêm tiêu chí mới**. Dãy bị
  nuốt vẫn phát act (nó là cú chạm phát wake); act phát ở mọi WAKE_MODE
  kể cả OFF/DRY_RUN vì AutoHide độc lập với suppression.

## Kỷ luật không đụng (chứng minh bằng diff)

Diff ABInApp.m so với bản wake1 đã ship (push9-clone, commit a907505):
**thêm thuần — 0 dòng sửa, 0 dòng xoá.** Đường nuốt (suppression engine),
đường probe, `BWGatePass`, `BWBeginSwallow`, hook sendEvent: nguyên vẹn
từng dòng. Không thêm hook mới nào.

## Cổng đã chạy

- **Harness vector trên header cuối: 23/23 PASS ở cả hai bản**
  (project/ + src/): hash FNV-1a yt/vm + hash28, V1–V7 pack+unpack,
  V8 (ô 0 → invalid), **V9/V10 pack+unpack khớp hex thiết kế từng số**.
  V1–V8 không đổi so với wake1.
- **Build module OmniCarAppBridge từ sạch:** compile/link/ký xong;
  ABInApp.m **0 warning**; dylib mới 538.856 B (wake1: 538.544 B);
  chuỗi `bridgewake.v1.act` có mặt trong dylib (strings = 1).
- **Grep cổng:** `MSHookMessageEx(UIApplication, sendEvent:)` đúng **1**
  điểm cài trong ABInApp.m; điểm gọi `orig_SendEvent` đúng **1** (dòng
  583); `sendEvent` chỉ tồn tại trong ABInApp.m ở toàn module AppBridge.

## Để lại cho tích hợp

- Chuỗi `bridgewake.v1.act` phía ABHost khai trong ABChannelNames.m
  (strand ABHost song song) — tại thời điểm bản này land, ABChannelNames.m
  mới có 4 hằng; tích hợp đối chiếu byte-identical với static phía
  ABInApp như 4 kênh cũ.
- Diff BridgeWakePack.h AppBridge vs bản SplitScreen (strand CarPlay
  đang mở rộng song song từ cùng đặc tả §3.2.1) phải = 0 ở tích hợp;
  harness hai module chạy lại V1–V10 trên bản cuối.
