# IMPL — WAKE phía ABHost (xác nhận chrome) — strand ABHost

Theo design-bridgewake.md §3 + §6 + §7.2. Chỉ sửa 3 file được giao, ở cả hai
cây (project/OmniCarAppBridge/ ↔ src/AppBridgeA|B/), mirror identical (cmp ✓).

## 1. Đã cài những gì

**ABChannelNames.m** (:47–50, thêm thuần) — 4 hằng Darwin bridgewake.v1:
`ABNotifyBWState/BWQuery/BWWake/BWAck` =
`com.anlai.omnicar/bridgewake.v1.{state,query,wake,ack}` (khớp chuỗi §3.1;
tích hợp đối chiếu với SCPShared.m phía SplitScreen).

**ABHostBMethods.m** (:1199, thêm thuần, ngay sau setHandleVisible:forPane:) —
accessor MỚI `-bwAppliedSnapshotForBundle:`: trả
`{handleHidden, barHidden, knobCount}` đọc thẳng từ trạng thái ĐÃ ÁP:
`pane.handleHit.hidden`, `pane.bar.isHidden`, `self.knobViews.count`.
Không tính lại, không suy trạng thái; bundle không được host → nil.
Quy ước sự thật-view: view bar/handle chưa tồn tại → hidden=YES (báo cáo
"không có gì đang hiện", để luật §6 cho ra UNKNOWN chứ không phải VISIBLE giả).

**ABChannels.m** — mục §5 mới (:461–596) + khai báo extern/category (:20–34)
+ một dòng gọi đăng ký trong ABHostProcessInit khi process là SpringBoard (:64):
- `BWRegisterHostConfirm` (:564): `notify_register_dispatch` kênh wake trên
  main queue. Gói wake hợp lệ (v=1, type=3) có hash28 khớp một ABPane đang
  sống (quét panes, `(ABBundleIDHash(bundleID) >> 4) == hash28`) → vũ trang
  ô chờ duy nhất cho bundle `{hash, gen, seq, at}` (wake mới ghi đè ô cũ).
- `BWObserveApplied` (:550): observer riêng cho `appbridge.open` /
  `appbridge.frame`; chỉ khi có ô chờ khớp bundle mới làm tiếp.
- `BWFrameApplied` (:542) + `BWAnswerSlot` (:518): frame đến trong ≤800 ms →
  đọc snapshot, phát ack role=1 (flag=1) echo đúng gen/seq của wake,
  state=VISIBLE khi `barHidden==NO`, ngược lại UNKNOWN. Quá 800 ms (đường
  dispatch_after hết hạn, hoặc frame đến muộn) → ack role=1 state=UNKNOWN.
  Ô chờ bị xóa TRƯỚC khi phát ack → mỗi wake tối đa một ack (exactly-once);
  expiry kiểm gen+seq khớp ô hiện tại nên không ack nhầm wake đã bị ghi đè.
- `BWEmitHostAck` (:504): đường phát Darwin duy nhất được thêm phía host —
  `notify_register_check` một lần, `notify_set_state` trước `notify_post`
  (đúng idiom ABKeyboardPublish của cây).
- Đóng gói: `BWPackFields` file-local theo đúng layout §3.2 (mode=0 trong
  ack — chỉ `state` có nghĩa, đúng kỷ luật trường của §3.2).

ABHost không có bộ đếm idle, không NSTimer, không tự quyết HIDDEN ở bất kỳ
điểm nào (kể cả khi snapshot cho barHidden=YES, ack vẫn là UNKNOWN).

## 2. Một điểm lệch cây-vs-thiết kế — cần tích hợp/GPT biết

§6 trỏ "điểm cuối handler observer appbridge.frame (ABChannels.m :244) và
appbridge.open (:203)". Trong cây hiện tại, hai handler ở ABChannels.m là
bản tham chiếu nằm trong `#if 0` (installer trùng đã vô hiệu hoá); handler
SỐNG là ABFrameBlock/ABOpenBlock trong ABHostGeometry.m — file KHÔNG thuộc
phạm vi strand này, và cổng §7.2 cấm sửa thân setFrame:/setBarVisible:/
setKnobs:. Giải pháp trong phạm vi: đăng ký observer riêng trên cùng hai
thông báo (cùng center, cùng main queue) rồi cộng MỘT hop dispatch_async
trên main queue trước khi đọc snapshot — khối handler của registrar được
xếp hàng trong cùng vòng phân phối, nên hop bảo đảm snapshot được đọc
SAU khi frame đã áp thật, đúng ngữ nghĩa "điểm cuối của handler" của §6,
mà không đụng một dòng nào của handler hiện hữu. Hệ quả cần lưu ý khi
nghiệm thu: độ trễ xác nhận cộng thêm một vòng main-queue (không đáng kể
so với ngân sách 800 ms).

Hai quyết định phạm vi liên quan:
- `BridgeWakePack.h` không được tạo ở strand này (ngoài 3 file được giao):
  đóng gói nằm file-local trong ABChannels.m, layout giống hệt §3.2 và đã
  qua test vector (mục 3). Tích hợp có thể thay bằng header dùng chung sau.
- extern của ABNotifyBWWake/BWAck khai báo cục bộ trong ABChannels.m (:24–25)
  vì AppBridgeB.h (nhà extern canonical) ngoài phạm vi; strand ABInApp cần
  hằng thì tự khai extern tương tự hoặc tích hợp bổ sung vào AppBridgeB.h.

## 3. Cổng tĩnh §7.2 — kết quả đo trên bản cuối

- Thân 4 hàm cổng (trích theo chữ ký → dấu `}` cột 0, SHA-256 trước/sau):
  setBarVisible: 3044b10d… = 3044b10d… ✓; setFrame: 8606f40a… = 8606f40a… ✓;
  setHandleVisible: 409cfb14… = 409cfb14… ✓; setKnobs: b98a9f26… = b98a9f26… ✓.
  (setBarVisible:/setHandleVisible: nguyên vẹn từng dòng như lệnh cấm.)
- diff toàn file so với baseline: ABHostBMethods.m và ABChannelNames.m và
  ABChannels.m đều THÊM THUẦN (0 dòng bị xóa/sửa; ABChannels +160 dòng).
- grep NSTimer/bwIdle trong 2 file chính = 0/0 ✓. Kênh appbridge.* hiện hữu
  không bị đụng (diff thêm thuần chứng minh).
- Test vector §3.4 (harness C biên dịch hàm production nguyên văn):
  FNV yt/vm khớp hằng tham chiếu; V6 (gói ack production phát) =
  0xE9DA706814803C14 PASS; V4 (giải mã wake theo đúng phép trích của
  handler) PASS; V1/V2/V3/V5/V7 trên layout đầy đủ PASS; V8 (ô 0 → v=0,
  bị loại) PASS.
- Build module OmniCarAppBridge từ sạch (THEOS, umask 022): compile/link/ký
  xong; ABChannels.m 0 cảnh báo; dylib 512.192 B chứa đủ 4 chuỗi bridgewake,
  selector `bwAppliedSnapshotForBundle:` và 2 dòng log [bridgewake].
- Mirror 3 cặp file project↔src: cmp identical ✓.

Chưa kiểm được ở strand này (thuộc cổng sau): khớp chuỗi kênh với
SCPShared.m phía SplitScreen (strand CarPlay chưa nạp tại thời điểm ghi),
hành vi ack trên máy thật (Gate 2 của WO).
