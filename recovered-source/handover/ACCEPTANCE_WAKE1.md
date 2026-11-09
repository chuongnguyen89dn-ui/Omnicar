# ACCEPTANCE — wake1 (bản FAT từ CI macOS)

Mọi số liệu dưới đây đo trên CHÍNH file được giao, không lấy từ
candidate local hay biên bản của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-wake1-fat_iphoneos-arm64.deb`
- Kích thước: 1.184.484 byte
- SHA-256: `279005f45cb84d340e050461a46b4768fc4226c6edf80709af606004a9c3c2f1`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42573985624**
  (workflow_dispatch), conclusion **success** (truy vấn trực tiếp),
  head ci-fat-test `21e1b95`; nguồn main `a907505`. Hồ sơ nền
  Gate 0 cố định ở commit `9424aea` (reports/).
- Nội dung vòng (PATCH_NOTES §22): (1) WAKE — cơ chế chạm đầu
  gọi controls theo mẫu QA180: chủ trạng thái SCPCarSplit
  (CarPlayApp) tổng hợp HIDDEN mới, ABHost xác nhận chrome đã
  áp qua ack, ABInApp giữ relay sendEvent + probe + suppression;
  giao thức Darwin đóng gói số bridgewake.v1 (4 kênh, layout
  uint64, 8 test vector); hai mode PINCH_MODE/WAKE_MODE độc
  lập, mặc định DRY_RUN. (2) PINCH — recognizer trên container
  + probe DRY_RUN + adapter fullscreen RỖNG (đích QA20 bị
  BLOCKED ở cổng A1). (3) NÚM — sửa cực publishKnobsNow
  (patch riêng WO §VII).
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-wake1_iphoneos-arm64.deb`,
  994.274 byte, SHA-256
  `12d41e98160bbbb2371bb755562c0085b18c9700a78e2c12b012de86c826e38f`
  (chỉ để truy vết).
- Xác minh tĩnh: Gate 1 trên candidate (selector parity mất
  0/8; hồi quy g1/g2/h/f đạt; publishKnobsNow đúng 1 eor;
  khoá pinch ENFORCE ở mức máy; sendEvent: chỉ ở AppBridge;
  0 dylib lạ trong gói) và trên bản FAT cả hai slice: chuỗi
  bridgewake.v1.* đủ 4/4 ở SplitScreen + AppBridge × arm64/
  arm64e; publishKnobsNow đúng 1 eor × 2 slice; g1 dạng csel
  × 2 slice; adapter currentState = `mov x0,#0; ret` × 2
  slice. Đây là "đã kiểm tra tĩnh", không phải PASS hành vi.

## Bảng Gate 0–7 (WO tích hợp Pinch + Wake)

| Gate | Trạng thái | Căn cứ / điều kiện |
|---|---|---|
| 0 — Audit chỉ đọc | **PASS** | audit-runtime (kiểm kê, bản đồ 5 đối tượng, phân định sendEvent, xác minh núm hai slice) + strand A1 + hồ sơ commit 9424aea |
| 1 — Static integration | **PASS** | Đo trên candidate đã bung + FAT hai slice (§22.6, §22.7) |
| 2 — Dry-run | **PENDING** | Chờ phiên xe gộp ở dưới: đếm wouldSwallow/wouldPinch, phân loại phone, phân bố ack |
| 3 — Pinch độc lập | **BLOCKED tại A1** | Không có entry điều khiển fullscreen QA20 (§22.3); ENFORCE bị khoá ở mức máy — không phải mục chấm của phiên tới |
| 4 — Wake độc lập (ENFORCE) | **PENDING** | Chỉ được bàn sau khi Gate 2 đạt; phiên tới chạy DRY_RUN, không nuốt thật |
| 5 — Hai tính năng cùng bật | **PENDING** | Phụ thuộc Gate 3/4 |
| 6 — Stress / lifecycle | **PENDING** | Sau Gate 5 |
| 7 — Bàn giao | **GÓI NÀY** | PATCH_NOTES §22 + acceptance này + reports vòng wake; DEVICE_PASS chưa tuyên |

## Trạng thái từng phần

- **Wake:** source hoàn thiện + static PASS. Mặc định
  DRY_RUN (không pref nào được đặt sẵn trong bản): phiên xe
  tới chỉ QUAN SÁT — probe tính wouldSwallow/wouldPinch và
  ghi log, không nuốt chạm, không đổi hành vi.
- **Pinch:** BLOCKED tại A1. Trong bản có recognizer +
  probe DRY_RUN (log `[pinch1]`) và adapter rỗng khoá
  ENFORCE ở mức máy. Mở lại cổng chỉ khi phía nguồn GPT
  công bố entry điều khiển có kiểm chứng + đường đọc trạng
  thái expanded và phát hành dylib mới (MD5 mới — A1 kiểm
  lại từ đầu).
- **Núm publishKnobsNow:** ĐÃ SỬA — cổng object, candidate
  và FAT hai slice đều đạt (đúng 1 eor trên đường
  IsIdentity → payload). Còn chờ kiểm trên xe trong phiên
  gộp: gương về đúng kích thước ở split hỗn hợp, chạm gần
  vách tới được app, phản hồi bấm đúng chiều.
- **Weather fixround7:** vẫn PENDING (§21.3) — gộp vào
  chính phiên test của bản này (phần B của kịch bản).
- **VISUAL_ORIGINAL_COMPARISON:** vẫn PENDING (§21.4).

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0 (LC_BUILD_VERSION).

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 235DB91C-30B9-3784-9FEA-7C5C25B15B99 | 546266C6-4831-31F8-A890-FA7A53C4DCBE |
| OmniCarPrefs | 40079C87-4DB6-364C-A30E-B27B47A5E425 | 78071D11-652E-3265-BDC1-68888AC8CED7 |
| OmniCarAppBridge.dylib | 4338A40E-2693-3C9B-9EB0-B3525BD221BD | E8AA2DCD-FDB2-39E2-BB40-FD98EDDB9594 |
| OmniCarCarProbe.dylib | 154B01F4-6189-3EA8-ADE9-0470AB2A2CB9 | C999E467-A230-320E-AA2B-09460FD46513 |
| OmniCarCore.dylib | FFCF5A1A-A466-3C8C-8670-33278F90B448 | 072039B6-243B-3391-91C5-BDDD98EC25F5 |
| OmniCarSpeedBubble.dylib | 1920A1D4-0EF0-30FB-91D4-A1A3464FB408 | AFE47CE5-ACE3-3A34-88E8-FF921F98576C |
| OmniCarSplitScreen.dylib | C78FA2DD-59ED-3395-A455-63AB3BDE2AB3 | 53828BDE-6825-32A0-8FF0-310A0855093F |
| OmniCarStartupScreen.dylib | DD1DFC7F-9401-3C67-ABDC-FB128C38B8E8 | 1ED0D6A9-8992-332A-A170-93D8D7BC24C0 |

## Tag log của vòng (để đối chiếu trong phiên)

- `[wake1]` — owner phía CarPlay (state, wake, ack, confirm
  timeout).
- `[bridgewake]` — ABHost phía SpringBoard (vũ trang ô chờ,
  ack role=1).
- `[do] bw probe …` / `[do] bw nuot day: …` / `[do] bw ack
  seq=…` — ABInApp trong process app hosted.
- `[pinch1] pair …` — recognizer pinch phía CarPlay (bộ đếm
  complete/truncated tách SPLIT/EXPANDED).

## Kịch bản nghiệm thu gộp một phiên

Chuẩn bị: cài bản FAT này (thay fixround7 như mọi vòng).
KHÔNG cần đặt pref nào — cả hai mode mặc định DRY_RUN,
allowlist pinch rỗng. Ở DRY_RUN bản này không nuốt chạm,
không đổi hành vi; mục đích phiên là THU SỐ cho Gate 2,
kiểm núm, và nghiệm thu Weather còn treo.

Phần A — Wake/Pinch dry-run (Gate 2), xe đỗ:
1. Kết nối CarPlay, mở YouTube (hosted) vào split. Đợi
   controls ẩn hẳn (thanh bar tự ẩn sau ~4 s). Chạm MỘT
   lần vào vùng video: hành vi phải như bình thường
   (chạm đi qua app), và log có dòng `[do] bw probe` với
   wouldSwallow=1, state=H. Nếu wouldSwallow=0 kèm reason
   `phone`/`notarget` hàng loạt thì ghi nhận lại (luật
   targetVerified — điểm diễn giải §22.8 mục 2).
2. Khi controls đang HIỆN: chạm vùng video lần nữa —
   log phải ghi wouldSwallow=0.
3. CarPlay vẫn đang nối: chạm trên màn hình iPHONE (mở
   app trên điện thoại). Dãy này không được bị ghi nhận
   là chạm hosted (phân loại phone) — tiêu chí chặn của
   Gate 2.
4. Mở ô có bàn phím trong app hosted, gõ vài chữ: bàn
   phím hoạt động bình thường; các dãy khi kb active
   phải có wouldSwallow=0 trong log.
5. Pinch hai ngón ra/vào trên ô YouTube và trên ô Maps
   hosted: không đổi hành vi (không fullscreen, không
   mất cặp chạm); log `[pinch1]` đếm cặp complete/
   truncated ở SPLIT; `[do] bw probe` ghi wouldPinch
   theo cờ pinchAllowed (mặc định 0).
6. Lặp bước 1–2 với Maps (hosted) ở ô còn lại.

Phần B — Weather fixround7 (gộp, vẫn PENDING từ §21):
đặt style màn hình khởi động là THỜI TIẾT (3 hoặc 8)
trước khi kết nối, giữ quyền Vị trí như hiện tại (0).
Kết nối: splash phải chạy hết, không treo (yêu cầu đi
nhánh dự phòng, kết thúc đúng một lần). Ngắt rồi kết nối
lại: lần hai cũng hoàn tất (không kẹt in-flight). Nếu có
dữ liệu: nhiệt độ hiện + gradient đổi theo category
ngày/đêm. Xong trả style về Lời chào, kết nối lại một
lần xác nhận splash Lời chào như cũ.

Phần C — Núm vách ngăn:
ở split hỗn hợp (một ô native + một ô hosted), quan sát
điểm tròn ở vách: sau bản sửa, gương phía SpringBoard
không còn kẹt active — điểm về kích thước thường khi
không bấm (trước đây phình ~22 pt, vùng chạm ~105 pt).
Chạm vào vùng gần vách phải tới được app như bình
thường; bấm giữ vách thì điểm phình đúng lúc bấm và nhỏ
lại khi thả.

Hồi quy (cùng phiên): thanh "..." hosted mở đủ 5 nút;
menu tỉ lệ, swap, solo, picker như cũ; YouTube
fullscreen trong player giữ đáp số hướng như fixround6
(mask 24 → huong 4) — vòng xoay thị giác KHÔNG thuộc
mục chấm; ngắt–nối lại CarPlay giữa phiên không kẹt
trạng thái, không crash (có .ips thì giữ lại).

Log + .ips (nếu có) up vào logs/ của repo sau phiên. Số
cần đọc từ log: tỉ lệ wouldSwallow đúng kỳ vọng ở A1/A2;
số dãy bị phân loại `phone`; số "wake confirm timeout"
(log `[wake1]`) — hop ABHost có kịp ngân sách 800 ms /
1,0 s không; phân bố ba kết cục ack (role=0 đúng seq /
ack-timeout phía app / owner unconfirmed→UNKNOWN); bộ
đếm cặp complete/truncated của `[pinch1]` ở SPLIT.

## Còn mở (không thuộc nghiệm thu phiên này)

- Gate 3 (Pinch ENFORCE): BLOCKED tại A1 (§22.3).
- Gate 4–6: sau Gate 2.
- Bản sao Weather phía Prefs (OMCCommon.m) chưa rà;
  đuôi !logoView playIntro phía xe; cellClass UNVERIFIED
  (§22.9).

## Trạng thái

DEVICE_TEST = PENDING. Bản này đã sửa và build — chưa
được gọi là hoàn thiện cho tới khi nghiệm thu trên xe
theo kịch bản gộp ở trên, trọng tâm: (1) Gate 2 dry-run
— wouldSwallow đúng ở cả hai trạng thái controls, chạm
iPhone không bị phân loại nhầm, bàn phím không bị nuốt;
(2) núm về đúng kích thước + vùng chạm ở split hỗn hợp;
(3) Weather quyền vị trí = 0 hoàn tất không treo ở cả
hai lần kết nối liên tiếp.
