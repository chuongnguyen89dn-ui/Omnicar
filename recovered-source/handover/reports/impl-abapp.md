# CÀI ĐẶT WAKE — PHÍA ABINAPP (relay + probe + suppression)

Ngày: 2026-11-09. Theo đặc tả `design-bridgewake.md` §3–§5 + §7.3.
Trạng thái: source xong, build module sạch, cổng tĩnh §7.3 đạt. Chưa
đóng candidate, chưa đẩy git (gom vòng wake như các strand khác).

## File đã sửa (chỉ trong phạm vi strand)

| File | Thay đổi |
|---|---|
| `project/OmniCarAppBridge/ABInApp.m` + `src/AppBridgeB/ABInApp.m` | Toàn bộ phần dưới; hai cây mirror identical (`cmp` = 0). 585 → 1.132 dòng |
| `project/OmniCarAppBridge/BridgeWakePack.h` + `src/AppBridgeB/BridgeWakePack.h` | FILE MỚI: codec BWPack/BWUnpack `static inline` theo §3.2; hai bản identical (`cmp` = 0) |

ABInApp.m — 8 điểm chạm, ngoài ra không đổi một dòng gốc nào:
1. `#import "BridgeWakePack.h"`.
2. Section BridgeWake mới (trước ABOrientationBlock): hằng tên kênh
   (file-local, xem "Điểm diễn giải" 1), state client, kb guard,
   suppression engine, probe, hook, install, reset.
3. `ABOrientationBlock`: gọi `BWInstallBridgeWake()` trong cùng khối
   one-shot `!ABHooksInstalled`, sau danh sách hook hiện có (§5.1).
4. `ABResponderBecame`: thêm 1 dòng `BWKb = BWKbActive;` sau
   ABKeyboardPublish — tín hiệu kb CHÍNH (§5.5).
5. `ABResponderResigned`: thêm 1 dòng `BWKb = BWKbInactive;` trong
   nhánh responder-hiện-tại-về-nil — nơi duy nhất hạ ACTIVE (§5.5).
6. `ABInstallInAppObservers`: observer `ABChanClose` (object=bundleID)
   + `ABChanCloseAll` (object=nil) → `BWResetAll` (§5.6).

`ABPublishAppOrientation` / `ABKeyboardPublish` / bộ lọc orientation
{3,4} (`ABHook_UIDeviceSetOrientation`, nay ở dòng 920) — KHÔNG đổi.

## Nội dung đã cài (đối chiếu §5)

- **§5.1 cài lười**: hook `-[UIApplication sendEvent:]` (giữ
  `orig_SendEvent`), đăng ký nhận state+ack (notify_register_dispatch,
  main queue), observer bàn phím, phát query lần đầu — tất cả trong
  ABOrientationBlock. `sessionValid` = đã cài + có gói hợp lệ + còn
  tươi + gen khớp (gen duy nhất app biết là gen của gói tươi gần nhất).
- **§5.2 state client**: biến đúng danh sách thiết kế (BWState, BWGen,
  BWWakeMode, BWPinchMode, BWPinchAllowed, BWStateRxAt, BWKnown); hạn
  tươi 2,5 s; quá hạn → mode hiệu dụng OFF + fail-open; query lại tối
  đa 1 lần/2 s (kích hoạt ở đầu dãy khi thấy stale/unknown). Lọc gói:
  v/type/hash/gen theo §3.2 (gen cũ hơn theo modulo-4096 bị bỏ; giá trị
  dự trữ: state 5–7 → UNKNOWN, mode 3 → OFF). Gói state tươi = điều
  kiện mở khóa cho cả mixed-lock lẫn ack-latch (§5.4).
- **§5.3 probe gộp**: MỘT điểm quan sát `ABHook_SendEvent` nuôi hai bộ
  đếm độc lập. wouldSwallow = cổng §5.4 đánh giá tại Began "như thể
  ENFORCE"; wouldPinch = dãy có đúng 2 touch + khoảng cách hai touch
  đổi > 10% trong đời dãy (tính từ location nội bộ, KHÔNG log tọa độ)
  + `BWPinchAllowed` của phân xử. Log đóng dãy đúng format thiết kế:
  `[do] bw probe seq=<n> ph B=.. M=.. E=.. C=.. dur=<s> hosted=<0/1>
  kb=<0/1/-> state=<I/U/V/H/W> wouldSwallow=<0/1> wouldPinch=<0/1>
  failopen=<reason|->`. Trần 200 dãy/launch; vượt trần → bộ đếm tổng
  kết mỗi 30 s (`[do] bw probe summary 30s ...`). DRY_RUN: luôn gọi
  orig đúng 1 lần, không sửa UIEvent, không phát wake/lệnh pinch.
- **§5.4 suppression**: máy IDLE→SWALLOWING→FINISHED→IDLE. Cổng chép
  nguyên ánh xạ thiết kế: `enabled(wakeMode==ENFORCE) && sessionValid
  && targetVerified && known && hidden && !keyboardActive &&
  !keyboardUnknown && !transitioning && !mixedTouches`. Nuốt trọn dãy
  tới Ended/Cancelled, không chuyển pass-through giữa chừng kể cả khi
  state lật VISIBLE; một wake/dãy (txn seq riêng, log `[do] bw nuot
  day: txn=.. probe=..`); ack role=0 khớp seq → hoàn tất (log
  `[do] bw ack seq=..`); quá 1,5 s không ack → log timeout,
  BWFailOpenLatch tới gói state tươi kế tiếp; touch mới Began giữa
  dãy đang nuốt → hấp thụ vào dãy đang giữ (không dãy nào bị giao nửa
  chừng), log mixed, khóa suppression tới state tươi kế tiếp. Dãy đã
  qua orig ở Began không bao giờ bị chặn ở pha sau.
- **§5.5 keyboard guard**: chính = ABCurrentResponder qua
  Became/Resigned; phụ = WillShow/DidChangeFrame chỉ tính khi frame
  đích có `0 < origin.y < chiều cao màn hình`; WillHide chỉ hạ
  UNKNOWN→INACTIVE khi không có responder (vắng thông báo KHÔNG hạ
  ACTIVE — blank inputView). Không một dòng nào quét/tồn tại
  UIRemoteKeyboardWindow.
- **§5.6 dọn dẹp**: `BWResetAll` — engine về IDLE, bỏ tập touch, hủy
  chờ ack, state/known/gen/kb về gốc, hai khóa mở.
- **§4 mode**: chỉ từ gói state; chưa có gói → tư thế DRY_RUN cho
  probe; stale → OFF. Không đọc plist/prefs ở bất cứ đâu trong phần mới.

## Điểm diễn giải (ghi rõ để tích hợp/Gate 2 phán)

1. **Tên kênh**: ABChannelNames.m thuộc strand ABHost (§7.2) và chưa
   có hằng bridgewake khi strand này chạy, nên ABInApp.m giữ 4 tên
   kênh dạng `static const char *` file-local, chuỗi đúng §3.1. Khi
   strand ABHost land, tích hợp có thể thay bằng extern dùng chung —
   giá trị chuỗi phải khớp từng byte.
2. **targetVerified / reason `phone`**: luật ứng viên §5.1 được cài
   chặt ở mức: mọi touch Began phải có window != nil (thiếu →
   `notarget`) và bằng ABKeyWindow() hiện hành (khác → `phone`,
   wouldSwallow=0). Đây là chiều fail-open; nếu dữ kiện Gate 2 cho
   thấy chạm hosted thật rơi vào window không-key, DRY_RUN sẽ hiện
   wouldSwallow=0/phone và luật phải nới TRƯỚC khi bật ENFORCE —
   đúng vai trò cổng chặn của Gate 2, không phải chi tiết tùy ý.
3. **failopen**: state != HIDDEN (kể cả WAKING) là pass-through bình
   thường → `failopen=-`, không phải lỗi. Ack-timeout latch báo
   reason `stale` (state không còn đáng tin cho suppression). Khi gói
   state ghi wakeMode=OFF (còn tươi), wouldSwallow=0 với reason
   `mode`. Thứ tự ưu tiên reason: unknown → stale → kb → kbunknown →
   mixed → notarget/phone.
4. **BWKbHideNote**: WillHide chỉ là "tín hiệu dứt khoát đầu tiên" để
   rời UNKNOWN khi không có responder; nó không bao giờ hạ ACTIVE
   (responder là tín hiệu chính duy nhất được hạ, theo §5.5).

## Kiểm chứng

- **Codec**: harness C độc lập (`/tmp/bwtest.c`, clang-18) chạy trên
  chính header này: V1–V7 pack ra đúng hex của §3.4 và unpack ra đúng
  trường cả hai chiều; V8 (ô 0 / v=0) bị loại; masking không tràn
  trường. 17/17 PASS.
- **Build**: toolchain kiểm trước (clang-18, ldid, ld.lld→ld.lld-18
  đủ, không phải khôi phục). `make clean && make` module
  OmniCarAppBridge: exit 0, ABInApp.m biên dịch 0 warning, link + ký
  xong; dylib mới 538.544 B chứa đủ 4 tên kênh bridgewake.v1 + format
  probe nguyên văn.
- **Cổng tĩnh §7.3 (phần ABInApp)**: `orig_SendEvent` — đúng 1 điểm
  gọi (dòng 554), 1 khai báo IMP, 1 đăng ký hook; đường nuốt gọi 0
  lần. `sendEvent` xuất hiện duy nhất tại ABInApp.m trong toàn cây
  (grep project/ + src/ = 0 chỗ khác). Phần mới: không OMCPref/plist
  (chỉ 1 dòng comment nhắc "không đọc"); `locationInView` chỉ ở 2
  dòng tính khoảng cách (294–295), không nằm trong bất kỳ format log
  nào. Thân ABPublishAppOrientation/ABKeyboardPublish không đổi;
  bộ lọc {3,4} nguyên vẹn.
- Chưa kiểm: cổng hai-slice trên bản FAT + diff BridgeWakePack.h với
  bản phía SplitScreen (strand CarPlay chưa land file này khi kiểm) —
  thuộc bước tích hợp của vòng wake.
