# FIX-W / W4 — PROBE THỤ ĐỘNG sendEvent PHÍA CarPlayApp — BIÊN BẢN

Mức đạt: **source complete / build PASS / static PASS** (chưa có bằng chứng xe — probe chính là công cụ tạo bằng chứng đó).

## 1. Đã tạo gì

| Thành phần | Vị trí |
|---|---|
| TU mới `SCPTouchProbe.h` (982 B) | `project/OmniCarSplitScreen/` + mirror `src/SplitScreenA/` (cmp identical) |
| TU mới `SCPTouchProbe.m` (9.538 B) | như trên |
| Điểm cài trong `SCPHooks.m` | import 1 dòng (dòng 21) + khối cài 6 dòng ở cuối `SCPInitDashboardHooks`, ngay sau `fsInstallIfNeeded` — diff so với baseline fs1 (push9) = **chỉ hai hunk này** |
| Makefile SplitScreen | + `SCPTouchProbe.m` vào `OmniCarSplitScreen_FILES` (1 từ) |

Không đụng: `SCPCarSplit+BridgeWake.m`, `SCPCarSplit+AutoHide.m`, `SCPPinchController.m`, `SCPFullscreenController.m`, `ABInApp.m` (chỉ ĐỌC header của SCPCarSplit/SCPCarPane/SCPShared để dùng API sẵn có).

## 2. Cơ chế — đúng một hook, thụ động tuyệt đối

- `SCPTouchProbeInstall()` được gọi từ `SCPInitDashboardHooks` — constructor đã qua cổng `SCPHostIsCarPlayApp()` + crash guard, nên probe **chỉ tồn tại trong process CarPlayApp**. Hàm cài có cờ idempotent.
- Hook duy nhất: `MSHookMessageEx(UIApplication, @selector(sendEvent:))`. Replacement: **gọi orig TRƯỚC, nguyên vẹn**, rồi mới quan sát trong `@try/@catch` — lỗi probe không thể chạm vào đường delivery. Không hủy touch, không đổi hitTest target, không cài recognizer, không giữ event.
- Chỉ xử lý `UIEventTypeTouches`; các event khác bỏ qua không log.

## 3. Phân loại scene (cơ chế nhận diện của chính module)

`splitWindow = [SCPCarSplit shared].container.window` (cửa sổ dashboard chứa split container):

| Điều kiện | scene | prefix log |
|---|---|---|
| `touch.window == splitWindow` | `carplay` | `[probe]` |
| `touch.window == split.trayWindow` | `carplay-aux` | `[probe]` |
| `touch.window == nil` hoặc container chưa có window | `unknown` | `[probe-foreign]` |
| cửa sổ khác | `foreign` | `[probe-foreign]` |

Class của window **luôn** được log (`win=<class>`) để một window bất ngờ vẫn phán được từ log thay vì đoán trong code. Chạm foreign/unknown không bao giờ được quy thành input CarPlay.

## 4. Phân loại pane + chuỗi chạm

- Điểm chạm: `[touch locationInView:nil]` (tọa độ window). Quét `[split allPanes]` (slots + floatPane): pane trúng = pane đầu tiên mà `pane.view ?: pane.host` chứa điểm (qua `convertPoint:fromView:nil` + `CGRectContainsPoint(bounds)` — hình học layout hiện tại, chỉ đọc). Log kèm `slot<k>`, bundle, `hosted|native` (qua `SCPVCIsHosted(pane.vc)` — cùng phép phân loại `hostedPanes` dùng), và phía L/R hoặc T/B theo tâm pane so với tâm container trên trục layout (`[split vertical]`).
- Trong window CarPlay nhưng không trúng pane nào → `pane=outside` (chrome/divider/dashboard).
- Chuỗi: theo dõi theo con trỏ UITouch — Began ghi 1 dòng đầy đủ + mở record; Moved chỉ đếm; Ended/Cancelled đóng record và ghi 1 dòng `[probe] chain … began/moved/ended/cancelled … complete=0/1 dur=…`. Phase tới mà không có Began → đếm `orphans` + dòng `chain-orphan` (chuỗi cụt cũng là dữ kiện). Mọi dòng có `t=` monotonic (mach_absolute_time, cùng idiom SCPPerfTelemetry) và `seq` tăng đơn điệu theo Began; dòng cài đặt ghi pid.

## 5. Log trả lời câu hỏi W4 như thế nào

Câu hỏi: *CarPlayApp có thấy Began trên ô hosted không?*

- **CÓ (đường CarPlayApp sống):** trong log có dòng `[probe] began … scene=carplay active=1 … pane=slot<k> (<bundle> hosted)` tại các mốc Nguyen chạm vào nội dung app hosted, kèm dòng `chain … complete=1` — tức sendEvent của CarPlayApp nhận trọn chuỗi mà điểm rơi nằm trong hình chữ nhật của ô hosted. Đó là cơ sở để GPT cân nhắc dời feed activity về CarPlayApp (W4).
- **KHÔNG:** các cú chạm lên ô hosted không sinh dòng `began` nào với `pane=…hosted` (chỉ có began trên chrome/native/outside, hoặc `chain-orphan` không Began) trong khi ABInApp cũng không thấy → cả hai tầng đều mù với chạm hosted; giữ đường gọi lại bằng nút gốc theo WO.
- Phân biệt được với nhiễu: chạm từ scene khác process/window lạ rơi vào `[probe-foreign]`, không lẫn vào kết luận.

Giới hạn trung thực của phép đo: probe kết luận ở **mức hình chữ nhật của ô** (điểm rơi ∈ rect của pane hosted trong window CarPlay), không khẳng định view đích hit-test là chính bề mặt scene — đó là đúng granular mà WO W4 yêu cầu để quyết dời feed hay không. Phân loại đọc trạng thái layout tại thời điểm ngay sau orig trong cùng call stack; phase là thuộc tính của touch, không bị thứ tự gọi orig làm đổi.

## 6. Cổng kiểm chứng (đo trên cây + binary vừa build)

- Build SplitScreen từ sạch (`make clean && make`, THEOS + SDK 16.5): **exit 0**, `SCPTouchProbe.m` biên dịch **0 warning**, dylib link + ký xong (`.theos/obj/debug/OmniCarSplitScreen.dylib`, 1.292.624 B).
- MSHookMessageEx: `SCPHooks.m` giữ nguyên **31**; TU probe chứa đúng **1** lời gọi (SCPTouchProbe.m:198) → toàn module **32 = 31 + 1**, đúng ngân sách W4. Binary có import `_MSHookMessageEx` và đủ 5 dòng format `[probe]`/`[probe-foreign]`/chain/install + format Began.
- Kỷ luật thụ động bằng grep: trong `SCPTouchProbe.m/.h` **không tồn tại** bất kỳ lời gọi API activity/reveal/swallow nào (`ahNoteActivity`, `ahReveal`, `bwHandle*`, `BWPostAct` = 0); các từ "reveals/swallows" chỉ xuất hiện 1 lần trong comment của header mô tả điều probe KHÔNG làm.
- Diff `SCPHooks.m` vs baseline đã giao (push9 recovered-source): chỉ import + khối cài (xem §1).
- Mirror: `src/SplitScreenA/SCPHooks.m`, `SCPTouchProbe.h/.m` cmp identical với project.

## 7. Để lại cho tích hợp / GPT

- Probe luôn bật khi bản chứa nó chạy (không pref tắt) — đúng tính chất bản đo một phiên; khi GPT quyết dời feed hoặc đóng W4, gỡ = bỏ TU khỏi Makefile + bỏ điểm cài (2 hunk).
- Nếu log cho thấy scene=`unknown` xuất hiện lúc split đang active (container.window nil tại thời điểm chạm), đó là dấu hiệu container bị detach — cần đối chiếu log layout trước khi kết luận âm tính.
