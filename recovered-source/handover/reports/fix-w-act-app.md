# FIX-W — PHÍA APP (ABInApp): TÁCH ACT KHỎI ĐỘ TƯƠI STATE + TRÓI SCENE

WO GPT khắc phục tổng hợp sau fs1, phần ABInApp (W1/W2-A/W3 phía app).
File duy nhất sửa: `project/OmniCarAppBridge/ABInApp.m` + mirror
`src/AppBridgeB/ABInApp.m` (cmp identical sau sửa). Mức đạt:
**source complete / build PASS / static PASS** — chưa có bằng chứng xe.

## Lỗi đã sửa (đối chiếu source)

Đường phát act cũ: `if (BWFresh()) BWPostAct();` tại điểm mở dãy của
`BWHandleTouchEvent` — act chỉ phát khi bản sao state còn tươi ≤ 2,5 s.
Owner chỉ phát state khi thay đổi/query, nên sau khi controls đã mờ
lâu, chính cú chạm cần gọi lại mang state cũ → không phát act → owner
không nhận activity → không reveal. Khớp báo cáo xe fs1 của Nguyen
(chỉ bấm trúng nút logo — handler sống ở CarPlayApp — mới gọi lại
được). Đây là lỗi điều kiện sống của đường wake phía app; phía owner
(nhận/giải mã/reveal) thuộc strand song song, không thuộc file này.

## Các hunk (8 hunk, file:line theo bản cuối)

1. **:28** — `#import <mach/mach_time.h>` (phục vụ W1).
2. **:60–61** — forward declaration cho trói scene: `YZSceneCandidateID`
   + khai báo tentative `YZLeaseSceneID` (định nghĩa khởi tạo duy nhất
   vẫn nằm ở khối statics YZ phía dưới; YZ section không đổi một dòng).
3. **:152–154** — statics mới: `BWActSessionVerified` (cờ danh tính
   phiên riêng cho act) + `BWActSetFail`/`BWActPostFail` (đếm lỗi
   notify của đường act).
4. **:198–205** — `BWActNowMs()`: mach_absolute_time → ms (monotonic).
5. **:262–375** — lõi sửa:
   - `BWPostAct` (:291): giữ nguyên throttle 0,12 s và nội dung gói;
     đổi chữ ký thành `BOOL BWPostAct(int*, int*)` — trả YES khi thật
     sự đã phát, thu mã trạng thái của `notify_set_state`/`notify_post`
     và tăng bộ đếm fail tương ứng.
   - `BWActHostedScene()` (:316) — W3: scene được host xác định theo
     thứ tự thẩm quyền: (a) lease YT-Zoom đã ghim sceneID → scene có
     candidate id khớp (`YZSceneCandidateID`, cơ chế sẵn có của YZ);
     (b) ngược lại: scene của `ABKeyWindow()` — cùng cửa sổ mà cổng
     nuốt dùng để xác minh target (sub_61D0). Lease nêu tên scene mà
     process không tìm thấy → trả nil (target-unknown).
   - `BWActOnSequenceStart(began)` (:336) — quyết định act tại Began:
     chưa session-verified → log `act-drop-nosession`; không xác định
     được scene được host hoặc có touch không cửa sổ →
     `act-drop-target-unknown`; touch thuộc scene khác (màn hình
     iPhone) → `act-drop-scene`; qua hết → `BWPostAct` và log
     `act-posted` kèm `set=`/`post=`/bộ đếm fail. Mọi dòng log đều có
     tiền tố `[autohide]`, stamp monotonic ms `t=`, và `stateage=` =
     tuổi bản sao state tại Began (ms; −1 khi chưa từng nhận) — log xe
     sẽ phân định được "hook nhận chạm nhưng state cũ" (act-posted với
     stateage lớn) khỏi "chưa từng xác thực phiên" (drop-nosession).
6. **:423** — `BWOnStatePacket`: đặt `BWActSessionVerified = YES` tại
   đúng điểm chấp nhận gói (valid + hash của chính bundle + gen được
   nhận — cùng điểm đặt `BWKnown = YES`). Đây là W2-A: cơ sở phát act
   = danh tính phiên đã xác thực, không phụ thuộc độ tươi.
7. **:629** — điểm gọi trong `BWHandleTouchEvent`: thay
   `if (BWFresh()) BWPostAct();` bằng `BWActOnSequenceStart(began);`
   (vẫn ở khối mở dãy, TRƯỚC đánh giá cổng nuốt — dãy bị nuốt vẫn tính
   activity; comment tại chỗ đã viết lại theo cơ sở mới).
8. **:766** — `BWResetAll`: `BWActSessionVerified = NO` khi phiên đóng
   (cùng điểm xoá `BWKnown`).

## Kỷ luật không đụng (bằng chứng grep/diff)

- Suppression giữ nguyên toàn bộ: `BWFresh()` còn đúng 6 điểm gọi, tất
  cả thuộc đường nuốt/probe — `BWEffectiveWakeMode` (:224),
  `BWEffectivePinchMode` (:228), `BWGatePass` (:483),
  `BWProbeLogging` (:549), báo cáo mode tại mở dãy (:633), kích
  `BWQueryIfStale` (:644). `BWGatePass`/`BWBeginSwallow`/engine nuốt/
  hook sendEvent: diff = 0 dòng.
- Đường YTZ: diff = 0 dòng trong toàn YZ section (chỉ ĐỌC
  `YZLeaseSceneID`/`YZSceneCandidateID` qua forward declaration).
- BridgeWakePack.h: không sửa; gói act vẫn V9/V10 nguyên layout.

## Cổng đã chạy

- **Build module OmniCarAppBridge từ sạch**: exit 0; biên dịch lại
  riêng ABInApp.m: 0 warning/0 error (cờ -Werror của module); dylib
  chứa đủ 4 chuỗi act mới (`act-posted`, `act-drop-nosession`,
  `act-drop-scene`, `act-drop-target-unknown`). Lần build đầu gặp
  clang bus-error tại ABYTZoom.m do một strand khác build Prefs đồng
  thời trên cùng VM (hết tài nguyên) — chờ strand đó xong, build lại
  sạch hoàn toàn; không liên quan source.
- **Harness codec** (C độc lập trên BridgeWakePack.h, clang-18):
  21/21 PASS — 2 hash tham chiếu + V1–V7 pack/unpack hai chiều + V8
  (ô 0 → invalid) + V9/V10 (gói act) hai chiều.
- **Mirror**: cmp project/ vs src/ = identical.
- **Diff vs baseline fs1**: đúng 8 hunk liệt kê trên; phần code (lọc
  comment) khớp từng dòng với mô tả.

## Để lại

- Phía owner phải khớp: owner tiếp tục kiểm hash/gen/assignment/phiên
  khi nhận act (strand owner song song) — phía app không tự cấp quyền
  gì thêm: act không mang nội dung chạm, không ảnh hưởng quyền nuốt.
- W4 của WO (probe sendEvent phía CarPlayApp) chỉ mở khi log xe cho
  thấy ABInApp không nhận touch; instrumentation ở bản này là đầu vào
  cho quyết định đó: nếu log có `act-posted` quanh mốc chạm mà controls
  vẫn không hiện → gãy ở phía owner/host, không phải phía app.
- Nghiệm thu W5 (mờ 4 s/10 s/30 s vẫn gọi lại được; chạm iPhone không
  gọi nhầm) chờ phiên xe trên bản tích hợp.
