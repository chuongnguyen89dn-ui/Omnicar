# ACCEPTANCE — ytz2 (bản FAT từ CI macOS; vòng khắc phục tổng hợp sau fs1 theo WO GPT)

Mọi số liệu dưới đây đo trên CHÍNH file được giao hoặc
trích từ biên bản CI của chính bản này (ci-ytz2), không
lấy từ candidate của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-ytz2-fat_iphoneos-arm64.deb`
- Kích thước: 1.221.708 byte
- SHA-256: `bb59ab5653540f21d915631213621c0158fc2850038f6d0959b3eca95087dc20`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42583754018**
  (workflow_dispatch), conclusion **success** (theo dõi foreground +
  truy vấn trực tiếp), head ci-fat-test `5c5698f`; nguồn main
  `a7630303fbd9a1af705fbf880093185401c46dc0`.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-ytz2_iphoneos-arm64.deb`,
  1.021.310 byte, SHA-256
  `4737cfa93c2c5a6a7c7ade37a0b7731718f626bb267dd2d03cf6d9f54018d6ad`
  (chỉ để truy vết).
- Baseline bất biến: fs1 FAT `41bb5b8b…`. Bản **ytz1 bị CÁCH LY**
  theo WO GPT (FAT 1.210.344 B, SHA-256 `4caa2568…`, CI run
  42581690791): chứa cả ba lỗi source GPT đã kết án — KHÔNG cài
  bản này; lệnh dừng CI của coordinator tới sau khi run đã
  dispatch xong nên FAT vẫn ra lò, hồ sơ ghi đúng sự thật đó
  (PATCH_NOTES §24.1).
- Nội dung vòng (PATCH_NOTES §24): sửa ba lỗi source GPT kết án
  trên fs1 — (W) đường gọi lại AutoHide: act tách khỏi cổng độ
  tươi state 2,5 s (phát theo danh tính phiên đã xác thực +
  trói đúng scene CarPlay), owner phát lại state mỗi 1,0 s
  luân phiên từng pane hosted, mọi điểm loại act/reveal có log
  reason riêng, probe sendEvent thụ động phía CarPlayApp;
  (P) arbiter pinch EXPANDED theo PHIÊN ở cả ba điểm dùng
  (pinch-in hết chết vì bundle nil), pinch mặc định về
  DRY_RUN, đường kiểm thử controller độc lập qua nhóm Chẩn
  đoán trong Prefs (dựng bằng code) + đường thoát không phụ
  thuộc recognizer; (Y) isSplit của YT-Zoom lấy từ trạng
  thái trình bày thật của SCPCarSplit qua trường split/
  splitver trong hostFrameInfo + instrument lease-lapse/
  owner-change. Weather và núm giữ nguyên như fs1.

## Bảng cổng

| Cổng | Trạng thái | Căn cứ / số liệu |
|---|---|---|
| 0 — Kiểm toán GPT (đối chiếu source) | **PASS** | Ba lỗi kết án bằng file:line trên source đã push (ABInApp.m:505; SCPFullscreenController.m:306 vs BridgeWake.m:231/:320/:658; ABYTZoom.m:151); WO khắc phục tổng hợp là căn cứ của vòng |
| 1 — Static integration (candidate) | **PASS** | Candidate 1.021.310 B `4737cfa9…`: parity — 6/8 thành phần identical fs1, AppBridge mất 0, SplitScreen mất đúng 4 bề mặt [fs1-test] đã gỡ ở ytz1 + cộng 7 bề mặt WO; hồi quy g1/g2/h(C-A+C-B)/f PASS; hostFrameInfo superset PASS; điểm ghi requestedOrientation duy nhất; mirror 13/13 identical (integration-ytz2) |
| 1 — Static integration (FAT, hai lát) | **PASS** | FAT 1.221.708 B `bb59ab56…`: bridgewake 5/5 × 2 binary × 2 lát; ytlease 2 kênh phía AppBridge × 2 lát; chuỗi mới act/renew/[fs-diag]/[probe]/isSplit-fallback đủ vị trí × 2 lát; fullscreenTestExpand = 0 toàn gói; 3 khoá chẩn đoán trong CODE của binary Prefs × 2 lát; knob đúng 1 eor × 2 lát (arm64 @0x129dc, arm64e @0x13318); g1 csel × 2 lát; parity vs FAT fs1 khớp kỳ vọng (ci-ytz2 §4) |
| Kiểm độc lập | **PASS** | verify-wake-act (5/5 mục ĐẠT), verify-arbiter-diag-probe ((a)–(d) ĐẠT; (e) đạt về chất, lệch quy ước đếm hook — §24.5(i)), kiểm độc lập YZ (đọc lại source + tính lại 4 hash cấm: MATCH cả 4) |
| 2–6 — Xe (W5 / P2 / pinch / Y2 / Weather / núm) | **PENDING** | Chưa chạy phiên nào trên bản này — kịch bản 5 bước ở dưới |

## Bảng verdict từng track (thang WO)

| Track | STATIC | RUNTIME | DEVICE | Căn cứ / điều kiện còn thiếu |
|---|---|---|---|---|
| AutoHide / Wake (sửa đường gọi lại) | **STATIC_PASS** | PENDING | PENDING | Bước 1 (W5) của kịch bản: mờ 4 s / +10 s / +30 s chạm đều hiện; các ca YouTube/Maps/bàn phím; chạm iPhone không gọi nhầm; 10 chu kỳ |
| Probe W4 (đo đường chạm) | **STATIC_PASS** | PENDING | PENDING | Log [probe] của chính phiên bước 1–3 trả lời CarPlayApp có thấy Began trên ô hosted không |
| Pinch + FS controller | **STATIC_PASS** | PENDING | PENDING | Bước 2 (P2 qua [fs-diag]) rồi bước 3 (DRY_RUN → ENFORCE); ma trận 10 chu kỳ / disconnect / app crash chưa chạy |
| YT-Zoom (isSplit đã sửa) | **STATIC_PASS** | PENDING | PENDING | Bước 4 (Y2): đối chứng OFF/ON; ca kết án YouTube hosted + Maps native — lease split=1, không isSplit-fallback, windows ≥ 1, mismatch = 0 |
| Weather (fixround7) | STATIC_PASS (kế thừa) | PENDING | PENDING | Bước 5: quyền Location = 0 → fallback, không kẹt in-flight, hai phiên liên tiếp, mọi nhánh kết thúc đúng một lần |
| Núm divider | **STATIC_PASS** | PENDING | PENDING | Bước 5: núm đúng kích thước khi bấm/thả, chạm gần vạch vào được app — giữ sửa cực đã đo 1 eor × 2 lát |

Không mục nào được gọi là PASS ở cấp cao hơn bằng chứng hiện có.
DRY_RUN đạt (nếu đạt) vẫn không phải QA180 ENFORCE.

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0.

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 6455576C-45AB-3B1B-AABD-2D33D8EDA197 | 065A3258-4FFA-3768-9CD2-D33D7CB3AF93 |
| OmniCarAppBridge | 9B1C0F15-2E14-3D8A-9FF3-C4BC30630DA8 | 78BB268F-9ED5-3131-8B20-9A7B0A682350 |
| OmniCarCarProbe | 711616F5-BC48-3E8D-B7DD-08133716E35D | 12F9A8CA-0A3A-3437-A642-07CB1DFD6C49 |
| OmniCarCore | A2F474A6-3F8C-3DFE-9275-830CC446868A | 34B97B5E-344B-3E3B-BCD2-78F595242070 |
| OmniCarPrefs | DEB493EB-BB90-3CF6-B57C-1F438158BF62 | 30DCADE4-C716-3B65-A3EF-419B7470824B |
| OmniCarSpeedBubble | 90A991E2-F906-3E43-ABF2-8D4E79ACA3F7 | 9FDBA3A3-4900-3981-8DEC-3B2D4D3AC6 |
| OmniCarSplitScreen | 724DC492-CD5E-3F26-B3F3-E8AED501AE24 | 1C547C9D-9CBF-3D8B-A3F6-4CFE245AE013 |
| OmniCarStartupScreen | 1577E7F3-07E4-3B8C-ABC6-15A96006FC99 | 11D17B77-28C3-3BA4-9088-22FC0D149382 |

## Tag log của vòng (để đối chiếu trong phiên)

- `[autohide]` — phía app: `act-posted` (kèm `t=`, `stateage=`,
  mã notify), `act-drop-nosession` / `act-drop-scene` /
  `act-drop-target-unknown`; phía owner: `act drop reason=`
  (`decode-fail` / `bad-hash` / `bad-gen` / `session-inactive` /
  `not-assigned` / `split-inactive`), `act-accepted`,
  `reveal-applied reason=… views=N`; các tag fade/reveal của
  fs1 giữ nguyên.
- `[wake1]` — cộng `bw renew start (1.0s)` / `bw renew stop` /
  `bw renew panes=N hashes=…` (state renewal 1,0 s).
- `[probe]` / `[probe-foreign]` — probe W4 phía CarPlayApp:
  began đầy đủ (scene/pane/hosted|native/t=/seq) + dòng tổng
  kết chain (complete/dur).
- `[fs-diag]` — listener + lệnh expand/restore provenance
  `diag` của controller; các mốc `fs expand confirmed` /
  `fs restore confirmed` / `unconfirmed` / `fs busy` như fs1.
  Tag `[fs1-test]` và khoá `fullscreenTestExpand` KHÔNG còn
  tồn tại trong bản này.
- `[pinch1]` — recognizer pinch như fs1 (mode mặc định nay
  là DRY_RUN).
- `[ytz]` — cộng `isSplit-fallback` (chỉ xuất hiện khi gói
  thiếu trường split — ca kết án Y2 không được có dòng này),
  `lease-lapse: … gen=… heal=…`, `owner phien host: <uuid>`.

## Kịch bản nghiệm thu một phiên — đúng thứ tự 5 bước của WO

Chuẩn bị: cài bản FAT này (thay fs1 như mọi vòng; KHÔNG cài
ytz1 cách ly). Mặc định khi cài: wake/pinch DRY_RUN, AutoHide
BẬT, YT-Zoom BẬT. Nhóm **Chẩn đoán** nằm ở cuối trang Cài đặt
→ OmniCar → Chia màn hình (section 6): công tắc
`fullscreenDiagExpand` (tắt), công tắc `youtubeVirtualize`
(bật), segment `bridgewake.pinchMode` (nấc giữa = Đo).
Toàn bộ năm bước chạy trong MỘT phiên kết nối (trừ các bước
ngắt–nối lại có chủ đích), log + .ips (nếu có) up vào logs/
của repo sau phiên. Không bật mọi ENFORCE ngay từ bước đầu.

**Bước 1 — AutoHide + Wake DRY_RUN (W5).** Xe đang đỗ.
Vào split hai ô (một native + một hosted):
1. Chờ controls mờ hẳn (4 s), chạm ngay vào nội dung ô
   hosted: controls phải hiện lại; log có `act-posted` →
   `act-accepted` → `reveal-applied`.
2. Chờ mờ, để thêm 10 s, chạm: vẫn phải hiện.
3. Chờ mờ, để thêm 30 s, chạm: vẫn phải hiện.
4. Lặp các ca trên khi: YouTube đang phát trong ô hosted;
   Maps đang mở; bàn phím đang hoạt động (gõ trong ô có
   nhập liệu — bàn phím mở quá 4 s không được mờ, và sau
   khi đóng bàn phím đường gọi lại vẫn sống).
5. Trong lúc CarPlay đang kết nối, chạm màn hình iPhone:
   controls xe KHÔNG được gọi nhầm (log phía app có
   `act-drop-scene` là bằng chứng đúng).
6. 10 chu kỳ mờ/hiện liên tiếp: không lần nào controls
   mất vĩnh viễn; chạm trúng vị trí nút logo vô hình vẫn
   là đường dự phòng sống.
Chấm RIÊNG hai mức: DRY_RUN (chạm vào app đồng thời gọi
controls) — đạt ở bước này; ENFORCE (chạm đầu chỉ gọi
controls, chạm kế mới vào app) — CHƯA chấm ở phiên này.

**Bước 2 — Fullscreen controller trực tiếp, Pinch OFF (P2).**
Đặt segment pinchMode về **Off (0)** để recognizer không
can thiệp. Vào split hai ô tỉ lệ khác 50:50:
1. Bật `fullscreenDiagExpand`: split phình đúng window
   bounds — hai ô giữ tỉ lệ, dock + Home + status bar ẩn
   đúng; chụp frame trước/sau; log chốt `fs expand confirmed`.
2. Đang EXPANDED: chạm/cuộn/gõ trong cả ô native và ô
   hosted — vị trí chạm phải đúng hình.
3. Tắt công tắc: restore trả đúng frame + clipping trước
   expand; log chốt `fs restore confirmed`, không
   `unconfirmed`/`rollback`. (Tắt công tắc khi đang
   EXPANDED cũng chính là kiểm đường thoát không phụ
   thuộc recognizer.)
4. Lặp bật/tắt 10 chu kỳ. Trong các chu kỳ: đổi app giữa
   EXPANDED; xoá một ô giữa EXPANDED; ngắt CarPlay giữa
   EXPANDED rồi nối lại → về SPLIT sạch, dock không kẹt
   ẩn; để một app hosted chết giữa EXPANDED → không treo.
Controller đạt bước này mới sang bước 3.

**Bước 3 — Pinch DRY_RUN rồi ENFORCE (P3/P4).**
1. Segment pinchMode = **Đo (1)**: pinch ra/vào trên ô
   native và ô hosted — log `[pinch1]` đếm pair
   complete/truncated tách SPLIT/EXPANDED, `[probe]` cho
   biết CarPlayApp có thấy Began trên ô hosted không;
   không lệnh thật nào được bắn.
2. Khi đường restore ở bước 2 đã đạt: segment = **Enforce
   (2)**. Pinch-out vào fullscreen; **pinch-in thoát được
   trên cả hai ô** (đây là ca kết án của lỗi nil-bundle);
   controls đang ẩn (HIDDEN) thì pinch-out không được
   giành quyền của wake; đang EXPANDED thì pinch-in luôn
   mở. Nếu pinch-in có bất kỳ lần nào không thoát được:
   đường thoát không phụ thuộc recognizer — đổi segment
   pinchMode sang bất kỳ nấc nào khác (mỗi lần đổi đều
   phát prefschanged; handler chẩn đoán thấy công tắc
   expand đang OFF trong khi máy đang EXPANDED sẽ tự
   restore theo level safety), hoặc bật rồi tắt công tắc
   `fullscreenDiagExpand`. Sau khi thoát được, đặt segment
   về Off và giữ nguyên log của phiên cho GPT phán.

**Bước 4 — YT-Zoom OFF đối chứng, sau đó ON (Y2).**
1. Tắt `youtubeVirtualize` trong nhóm Chẩn đoán, mở
   YouTube hosted, bấm fullscreen trong player: hành vi
   hướng phải còn nguyên như fixround7 (đối chứng).
2. Bật lại công tắc: mở YouTube, log phải có lease được
   cấp (đúng bundle, đúng kích thước ô) và ack `applied`
   với windows ≥ 1, mismatch = 0; bấm fullscreen: video
   nằm đúng trong ô, không lộn hình.
3. Ca kết án của vòng: YouTube hosted + Maps **native**
   (split hỗn hợp) — log lease phải mang `split=1` và
   KHÔNG có dòng `isSplit-fallback`. Thêm: YouTube +
   hosted app; YouTube solo; kéo divider đổi kích thước
   giữa lúc đang fullscreen.
4. Tắt công tắc giữa phiên: lease bị thu hồi, đường
   hướng fixround7 hoạt động lại. Để lease hết hạn tự
   nhiên (ngắt kết nối quá 3 s rồi nối lại): không cửa
   sổ nào kẹt sai kích thước/hướng (đo Y4).

**Bước 5 — Weather, núm divider và hồi quy toàn bộ.**
1. Weather (tiêu chí bắt buộc của GPT): đặt quyền
   Location = 0 → yêu cầu thời tiết đầu phải đi đúng
   nhánh fallback, splash không treo; ngắt/nối lại
   CarPlay → yêu cầu thứ hai vẫn hoạt động; mọi
   transaction kết thúc đúng một lần (không kẹt
   in-flight). Có dữ liệu thì nhiệt độ + gradient đúng
   category ngày/đêm.
2. Núm divider: núm trở về kích thước thường khi thả,
   phình đúng khi bấm; chạm cách vạch vài cm phải vào
   được app (không bị vành núm nuốt).
3. Hồi quy: thanh "..." của app hosted mở/đóng bình
   thường; solo/split/swap; nút Home; splash chào. Riêng
   cảnh YouTube xoay ở mức fixround7 (khi YTZ tắt) không
   chấm thêm ở phiên này — YTZ chấm ở bước 4.

## Điều kiện mở ENFORCE (sau phiên này)

- **Pinch ENFORCE:** mặc định trong bản là DRY_RUN (P4).
  Chỉ coi là mở khi: controller đạt bước 2, pinch-in
  thoát được ở bước 3 trên cả hai loại ô, và có 1 lần
  ngắt CarPlay giữa EXPANDED sạch. Việc bật do Nguyen
  quyết qua segment Chẩn đoán — không có bản build riêng.
- **Wake ENFORCE (nuốt chạm đầu, ngữ nghĩa QA180):** vẫn
  KHOÁ trong bản này (wakeMode mặc định DRY_RUN; state
  renewal 1,0 s đã giải quyết độ tươi nhưng nghiệm thu
  nuốt là vòng riêng Gate 3–6, không gộp vào phiên này).

## Còn mở (không thuộc nghiệm thu phiên này)

- Quyết định dời feed activity về CarPlayApp (W4): chờ
  dữ kiện `[probe]` của chính phiên này.
- VISUAL_ORIGINAL_COMPARISON: vẫn PENDING (thiếu footage
  deb gốc cùng kịch bản).
- Đo Y4 đầy đủ (heartbeat gián đoạn, restart app/host,
  đổi owner): mới có ca hết hạn ở bước 4.4.
- Bản sao Weather phía Prefs (OMCCommon.m): GPT phán chỉ
  audit đọc, không sửa khi chưa có bằng chứng chức năng.
- ahForgetView: (khe hở lý thuyết khi removeHomeButton
  giữa lúc mờ) — chờ GPT phán làm hay bỏ.

## Trạng thái

- ytz2: SOURCE HOÀN THIỆN + STATIC PASS (candidate + FAT
  hai lát). Mọi verdict xe: PENDING cho tới khi Nguyen
  chạy phiên 5 bước trên và log được phân tích.
- QA20 vẫn là bản dùng hằng ngày của Nguyen. ytz1 CÁCH
  LY — không cài. Rollback: fs1 FAT / fixround7 FAT /
  gói hợp nhất QA20.
