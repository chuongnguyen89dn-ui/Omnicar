# ACCEPTANCE — fs1 (bản FAT từ CI macOS)

Mọi số liệu dưới đây đo trên CHÍNH file được giao, không lấy từ
candidate local hay biên bản của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-fs1-fat_iphoneos-arm64.deb`
- Kích thước: 1.200.648 byte
- SHA-256: `41bb5b8bf21f87926449070c881ae453daf2d311ab2c91295e531494ce4b8a82`
  (kiểm lại trên bản copy ở handover — khớp tuyệt đối)
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42578683063**
  (workflow_dispatch), conclusion **success** (truy vấn foreground
  trực tiếp), head ci-fat-test `c392db4`; nguồn main `5427920`.
  Run push-triggered 42578586477 trên cùng commit không dùng.
- Nội dung vòng (PATCH_NOTES §23): (1) FS1 — controller fullscreen
  ẩn dock TỰ DỰNG trong cây rebuilt (quyết định GPT mở lại A1,
  phương án 2): SCPFullscreenController là chủ duy nhất của
  snapshot + trạng thái expanded, adapter là lớp chuyển tiếp
  thuần, một dòng tham vấn tại return của appAreaInParent:,
  chrome ẩn bằng hàm nội bộ (OMCChromeSetHidden của QA20 cấm
  tham chiếu — không có chủ trong rebuilt), nghiệm thu vòng này
  qua công tắc test `fullscreenTestExpand` trong Prefs; pinch
  vẫn DRY_RUN, ENFORCE khoá cho tới khi đủ điều kiện ở cuối tài
  liệu này. (2) AUTOHIDE — ẩn hoàn toàn controls sau 4,0 s idle
  theo cơ chế mờ opacity của QA20 (chỉ layer.opacity, hit
  target còn sống khi mờ) cho handle mọi pane + divider + knob
  + logo phía CarPlay và các gương ABPane.handle/handleHit +
  ABKnobView phía SpringBoard (key fade/kfade); gói act mới
  trên bridgewake (kênh thứ 5, BWTypeAct = 5) nuôi feed từ app
  hosted; HIDDEN của wake từ vòng này = barHidden ∧ faded;
  pref bridgewake.autoHide vắng = BẬT.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-fs1_iphoneos-arm64.deb`,
  1.006.126 byte, SHA-256
  `0a9f76b34bae40d118123c2a8251bd29635e597a8d8c4cac31337901e829a755`
  (chỉ để truy vết).
- Xác minh tĩnh: Gate 1 trên candidate (selector parity mất
  0/8 so với cả r7 và wake1; hồi quy g1/g2/h(C-A+C-B)/f đạt;
  publishKnobsNow đúng 1 eor; 4 thân ABHost cấm sửa khớp
  SHA-256 đã công bố; hostFrameInfo superset — chỉ cộng fade,
  knobs chỉ cộng kfade; kỷ luật sơn đạt; khoá pinch ENFORCE ở
  mức cấu trúc — lệnh expand/restore chỉ tồn tại trong nhánh
  đủ 5 cổng; sendEvent: chỉ ở AppBridge; 0 dylib lạ trong gói)
  và trên bản FAT cả hai lát: kênh bridgewake 5/5 ở
  SplitScreen + AppBridge × arm64/arm64e; publishKnobsNow
  đúng 1 eor × 2 lát; g1 dạng csel × 2 lát; markers đúng
  phân bổ; ytlease/youtubeVirtualize vắng tuyệt đối; selector
  parity so với FAT wake1 mất 0 ở cả 4 lát. Đây là "đã kiểm
  tra tĩnh", không phải PASS hành vi.

## Bảng cổng

| Cổng | Trạng thái | Căn cứ / điều kiện |
|---|---|---|
| 0 — Audit chỉ đọc | **PASS** (vòng wake) | audit-runtime + strand A1 + hồ sơ commit 9424aea; vòng fs1 đứng trên cùng nền audit, không audit lại |
| 1 — Static integration | **PASS** | Đo trên candidate đã bung (§23.5) + FAT hai lát (§23.6, ci-fs1) |
| FS — Controller staging (Gate 3 rút gọn) | **PENDING** | Chờ phần A của kịch bản gộp: công tắc fullscreenTestExpand, 5 điểm của thiết kế §8 |
| FS — Pinch ENFORCE | **KHOÁ** | Chỉ mở khi đủ 3 điều kiện ở mục "Điều kiện mở ENFORCE pinch"; phiên này pinch giữ DRY_RUN |
| AutoHide | **PENDING** | Chờ phần B của kịch bản gộp: 6 điểm đo §5.5 của thiết kế |
| 2 — Wake dry-run | **PENDING** | Chờ phần C (kịch bản từ ACCEPTANCE_WAKE1, không đổi) |
| Weather fixround7 | **PENDING** | Chờ phần D (vẫn treo từ §21; kịch bản từ ACCEPTANCE_WAKE1) |
| Núm publishKnobsNow | **PENDING** | ĐÃ SỬA từ wake1, cổng tĩnh đạt ở cả wake1 và fs1; chờ kiểm trên xe — phần E |
| 3–6 — Pinch/Wake ENFORCE, stress | **PENDING / KHOÁ** | Sau Gate 2 và sau nghiệm thu controller |

## Trạng thái từng phần

- **FS1 controller:** source hoàn thiện + static PASS. Trong
  bản này controller chỉ nhận lệnh từ hai caller: adapter
  (pinch — đang DRY_RUN nên không phát lệnh thật) và nhánh
  [fs1-test] qua công tắc Prefs. Mọi lệnh đều qua cùng cổng
  vào/txn/xác-nhận-đọc-lại; lỗi → rollback về SPLIT, không
  EXPANDED giả, không kẹt dock ẩn.
- **AutoHide:** source hoàn thiện + static PASS, mặc định
  BẬT (pref bridgewake.autoHide vắng = BẬT). Ở WAKE_MODE =
  DRY_RUN (mặc định hiện tại) tính năng đạt parity QA20:
  sau 4,0 s idle toàn bộ nút mờ hẳn; chạm đầu sau mờ vừa vào
  app vừa gọi controls hiện lại. Ngữ nghĩa "chạm đầu không
  click app" (QA180) chỉ thật khi wake qua cổng ENFORCE
  riêng — không gộp nhãn.
- **Wake:** giữ nguyên trạng thái wake1 (source hoàn thiện +
  static PASS, DRY_RUN). Định nghĩa HIDDEN từ vòng này đầy
  đủ hơn nhờ đầu vào faded của AutoHide; luật tương thích:
  AutoHide tắt ⇒ HIDDEN quay về đúng định nghĩa wake1.
- **Pinch:** recognizer + probe DRY_RUN như wake1; đích
  fullscreen không còn BLOCKED — đã có controller tự dựng,
  ENFORCE khoá chờ nghiệm thu controller (xem điều kiện ở
  cuối).
- **Núm / Weather:** giữ nguyên trạng thái — đã sửa ở mức
  tĩnh, chờ cùng phiên xe này phán quyết.

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0 (LC_BUILD_VERSION).

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 3D0A671A-CCE0-33B3-9359-198525517934 | F262FF8E-CA6D-33D2-870F-9A61A465D5E2 |
| OmniCarPrefs | 28C8CE6F-62D7-3ABA-A6FF-7AA911F5E63E | 495F3BAE-6C18-31ED-926E-66E075BD81F6 |
| OmniCarAppBridge.dylib | 4853EB33-5BC8-3A11-9713-06A35FA57FD2 | D77C839F-9FE5-3ADD-BA13-AD9BC69CBD4C |
| OmniCarCarProbe.dylib | 4B8814A2-F2FE-378A-B407-E0A181F7B8EA | 97E26B8F-9D55-388C-A65F-8068B88B2837 |
| OmniCarCore.dylib | 25DBA15A-826B-3618-BE2B-23104F7B53A8 | 6605F0CA-862A-395B-B266-4AAB923690DB |
| OmniCarSpeedBubble.dylib | 8E7E40E9-198F-323C-A003-0E513820B6E2 | E1247020-13DD-3D1F-9BFF-7FD08598DD6E |
| OmniCarSplitScreen.dylib | F286AD3F-5D2E-3466-BABE-4E572968A688 | 8F846579-1857-3D94-9D53-DA98E495AC2E |
| OmniCarStartupScreen.dylib | F18E09A8-A778-3B72-ACA0-A97E1CC0AB78 | 8A77C812-906D-3254-A286-ACEDF95A8A52 |

## Tag log của vòng (để đối chiếu trong phiên)

- `[fs1-test]` — nhánh công tắc test của controller (expand/
  restore theo pref fullscreenTestExpand) + các mốc
  `fs expand confirmed` / `fs restore confirmed` /
  `fs expand unconfirmed` / `fs restore-unconfirmed` /
  `fs busy` / `fs external-override` / `fs chrome FAILED`.
- `[autohide]` — controller phía CarPlay (`fade`,
  `fade deferred`, `reveal src=…`, suspend/resume, teardown)
  và phía host (`[autohide] host fade applied|restored`).
- `[wake1]` / `[bridgewake]` / `[do] bw probe …` — như
  ACCEPTANCE_WAKE1 (Gate 2).
- `[pinch1] pair …` — recognizer pinch (DRY_RUN; đếm
  complete/truncated tách SPLIT/EXPANDED).

## Kịch bản nghiệm thu gộp một phiên (tóm tắt)

Chuẩn bị: cài bản FAT này (thay wake1 như mọi vòng). Hai
mode wake/pinch giữ mặc định DRY_RUN; AutoHide mặc định
BẬT; mở sẵn trang Cài đặt → OmniCar → Split Screen để tới
được nhóm "TEST — Fullscreen" ở Phần A. Toàn bộ năm phần
chạy trong MỘT phiên kết nối (trừ các bước ngắt–nối lại có
chủ đích trong từng phần), log + .ips (nếu có) up vào
logs/ của repo sau phiên.

Phần A — FS controller staging (Gate 3 rút gọn, thiết kế
FS1 §8):
1. Vào split hai ô (một native + một hosted, giữ tỉ lệ
   khác 50:50). Bật công tắc `fullscreenTestExpand` trong
   Prefs: vùng split phình đúng window bounds — cả hai ô
   phóng theo, tỉ lệ giữ nguyên, divider/knob ở đúng vị
   trí tương đối; dock + status bar biến mất; nút Home
   biến mất. Log phải chốt `fs expand confirmed`.
2. Đang EXPANDED: chạm/cuộn/gõ phím trong cả ô native và
   ô hosted — phải bình thường; frame hosted khớp ô
   (không lệch hình/chạm).
3. Tắt công tắc: container về đúng frame trước expand;
   clips, cờ status bar, nút Home, dock trở lại đúng
   trạng thái trước; log chốt `fs restore confirmed`,
   không có `unconfirmed`/`rollback`/`fs busy`.
4. Lặp bật/tắt 10 chu kỳ liên tiếp: không lệch frame tích
   luỹ, không kẹt trạng thái. TRONG các chu kỳ này, thực
   hiện thêm: pinch-in (hai ngón thu vào) ít nhất 3 lần
   khi đang ở EXPANDED do công tắc tạo — ghi lại kết quả
   quan sát được (số liệu cho điều kiện mở ENFORCE).
5. Đang EXPANDED: đóng một app, mở app khác; rồi ngắt
   CarPlay giữa EXPANDED → kết nối lại: split ở SPLIT
   sạch, dock/status bar/Home bình thường (đây là lần
   ngắt-sạch cho điều kiện mở ENFORCE).

Phần B — AutoHide (6 điểm đo, thiết kế AutoHide §5.5;
WAKE_MODE giữ DRY_RUN):
1. Mờ đủ và mờ hết: vào split hai pane (một native, một
   hosted), không chạm 4,0 s → ảnh chụp: handle cả hai
   pane, divider + knob, logo/Home đều biến mất; log có
   đúng một dòng `fade`, độ trễ từ activity cuối ≈ 4,0 s.
   Thanh bar (nếu đang mở) tự đóng theo timer riêng —
   ghi riêng, không gộp verdict.
2. Chạm đầu sau mờ: chạm nội dung pane hosted → app NHẬN
   cú chạm VÀ toàn bộ controls hiện lại cùng khoảnh khắc;
   log: act tới owner → `reveal src=app`. Chạm vào tay
   nắm VÔ HÌNH phía CarPlay và phía host → vẫn mở được
   bar (chứng minh hit target sống khi mờ).
3. Gương hosted đồng bộ: khi mờ, ABPane handle + ABKnobView
   mờ cùng nhịp phía CarPlay; khi hiện, log/snapshot phía
   host báo `faded` khớp trạng thái owner — không có
   trường hợp một phía mờ một phía hiện kéo dài quá một
   nhịp push frame.
4. Không mờ sai lúc: mở ratio menu để yên quá 4,0 s →
   không mờ; kéo divider giữ quá 4,0 s → không mờ giữa cú
   kéo, buông tay thì đồng hồ tính lại từ lúc buông; mở
   bàn phím trong app hosted, gõ quá 4,0 s → không mờ
   giữa phiên gõ.
5. Phối hợp FS1: vào EXPANDED khi đang mờ → xuất phát từ
   trạng thái sạch (không còn lớp mờ cũ); ở EXPANDED quá
   4,0 s → AutoHide không bắn; ra EXPANDED → hiện đầy đủ,
   mờ lại chỉ sau 4,0 s idle mới.
6. Không kẹt mờ: 10 chu kỳ mờ/hiện liên tiếp (chạm–chờ–
   chạm); đổi app giữa lúc đang mờ; ngắt CarPlay giữa lúc
   đang mờ rồi kết nối lại → không trường hợp nào controls
   mất vĩnh viễn hoặc opacity lưu sai (accent của handle,
   scale active của knob vẫn đúng sau khi hiện lại).

Phần C — Wake Gate 2 dry-run: chạy nguyên kịch bản Phần A
của ACCEPTANCE_WAKE1 (YouTube hosted: wouldSwallow=1 khi
controls ẩn/state=H, =0 khi đang hiện; chạm trên màn hình
iPhone phải phân loại `phone`; bàn phím hoạt động bình
thường và wouldSwallow=0 khi kb active; pinch chỉ ghi
log; lặp với Maps hosted). Số cần đọc từ log giữ nguyên:
tỉ lệ wouldSwallow đúng kỳ vọng, số dãy `phone`, số
"wake confirm timeout" (hop ABHost có kịp ngân sách
800 ms / 1,0 s không), phân bố ba kết cục ack, bộ đếm
cặp `[pinch1]` ở SPLIT.

Phần D — Weather fixround7: chạy nguyên kịch bản Phần B
của ACCEPTANCE_WAKE1 (style thời tiết 3/8 đặt trước khi
kết nối, quyền Vị trí = 0: splash chạy hết không treo,
yêu cầu đi nhánh dự phòng và kết thúc đúng một lần; ngắt
→ kết nối lại lần hai vẫn hoàn tất, không kẹt in-flight;
có dữ liệu thì nhiệt độ + gradient ngày/đêm đúng; trả
style Lời chào và kết nối lại xác nhận).

Phần E — Núm vách ngăn: chạy nguyên kịch bản Phần C của
ACCEPTANCE_WAKE1 (split hỗn hợp: điểm tròn về kích thước
thường khi không bấm, chạm gần vách tới được app, bấm
giữ thì phình đúng lúc bấm và nhỏ lại khi thả).

Hồi quy (cùng phiên): thanh "..." hosted mở đủ 5 nút;
menu tỉ lệ, swap, solo, picker như cũ; YouTube fullscreen
trong player giữ đáp số hướng như fixround6 (mask 24 →
huong 4) — vòng xoay thị giác KHÔNG thuộc mục chấm
(VISUAL_ORIGINAL_COMPARISON vẫn PENDING); thoái hoá khi
pref bridgewake.autoHide = OFF: hành vi thị giác và định
nghĩa HIDDEN phải đo được bằng đúng wake1; ngắt–nối lại
giữa phiên không kẹt trạng thái, không crash (có .ips thì
giữ lại).

## Điều kiện mở ENFORCE pinch

Pinch ENFORCE chỉ được mở khi ĐỦ cả ba: (1) controller
đạt nghiệm thu staging ở Phần A; (2) ≥ 3 lần pinch-in
khôi phục thành công từ EXPANDED do công tắc test tạo ra
trong chính staging đó (Phần A bước 4); (3) 1 lần ngắt
CarPlay giữa EXPANDED sạch (Phần A bước 5). Thiếu một
điều kiện → pinch giữ DRY_RUN, không ngoại lệ.

## Còn mở (không thuộc nghiệm thu phiên này)

- Wake Gate 3–6 (ENFORCE): sau Gate 2.
- ahForgetView: cho removeHomeButton — để ngỏ cho GPT
  (§23.7 mục 2, rủi ro đã đánh giá gần 0).
- Comment tồn dư thời A1-BLOCKED trong SCPPinchController
  (§23.7 mục 3) — chỉ chữ, code đúng.
- VISUAL_ORIGINAL_COMPARISON = PENDING; bản sao Weather
  phía Prefs (OMCCommon.m) chưa rà; đuôi !logoView
  playIntro phía xe; cellClass UNVERIFIED (§23.8).
- Track YT-ZOOM (ảo hoá hướng YouTube): đã có điều tra +
  thiết kế + công tắc Prefs ở mức hồ sơ (reports/), code
  CHƯA vào bản này — vòng riêng sau.

## Trạng thái

DEVICE_TEST = PENDING. Bản này đã sửa và build — chưa
được gọi là hoàn thiện cho tới khi nghiệm thu trên xe
theo kịch bản gộp ở trên, trọng tâm: (1) FS controller
staging qua công tắc test — expand đúng window bounds và
giữ tỉ lệ, restore về đúng frame/cờ, 10 chu kỳ không
lệch, ngắt giữa EXPANDED sạch; (2) AutoHide — mờ hết sau
4,0 s kể cả gương hosted, chạm đầu hiện lại đúng, không
mờ sai lúc, không kẹt mờ; (3) Gate 2 dry-run + núm +
Weather như đã treo từ wake1/fixround7. QA20 vẫn là bản
dùng hằng ngày — bản này là bản nghiệm thu.
