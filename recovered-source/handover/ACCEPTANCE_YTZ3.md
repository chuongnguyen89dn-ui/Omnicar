# ACCEPTANCE — ytz3 (bản FAT từ CI macOS; vòng sửa sau log phiên ytz2 theo phán quyết GPT)

Mọi số liệu dưới đây đo trên CHÍNH file được giao hoặc
trích từ biên bản CI của chính bản này (ci-ytz3), không
lấy từ candidate của các vòng trước. Phán quyết phiên
ytz2 là căn cứ của vòng này nằm ở PATCH_NOTES §25.1;
kết luận tray-guard bị thu hồi nằm ở §25.2.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-ytz3-fat_iphoneos-arm64.deb`
- Kích thước: 1.224.728 byte
- SHA-256: `c1872b936a01969418b68cc5f69e1bd72639a1f5e2e2f1da16132edcfc6bcf3f`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42590500247**
  (workflow_dispatch), conclusion **success** (theo dõi foreground +
  truy vấn trực tiếp), head ci-fat-test `dd47375`; nguồn main
  `36135b8a355626a2d57103624d16cbcda6ebe273`.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-ytz3_iphoneos-arm64.deb`,
  1.027.106 byte, SHA-256
  `b6c5f32864eed1d471632b1bcb73708553c7100adf8443e791d044400f5e9414`
  (chỉ để truy vết).
- Baseline bất biến: ytz2 FAT `bb59ab56…`. Bản **ytz1 vẫn CÁCH LY**
  (PATCH_NOTES §24.1) — KHÔNG cài bản này.
- Nội dung vòng (PATCH_NOTES §25.3): (G) guard fullscreen đổi từ
  vị từ tồn-tại-window sang vị từ nội-dung-đang-mở + snapshot ở
  cả 6 điểm từ chối; (NP) feed activity cho ô native tại
  CarPlayApp (quy đổi screen-space, cổng 7 nấc, gọi đúng đường
  F1) + đo tập touch `[touchset]` chống trùng; (I) instrument
  hẹp `[applib]` / `[scenevis]` cho mất icon + ô trắng;
  (W) instrument `[weather]` request→answer→display bằng hai
  bộ đếm log-only (kênh request không mang id). YT-Zoom giữ
  nguyên bản sửa đã DEVICE PASS ở phiên ytz2.

## Bảng cổng

| Cổng | Trạng thái | Căn cứ / số liệu |
|---|---|---|
| 0 — Phán quyết GPT sau log ytz2 | **PASS** | GPT đọc trực tiếp hai log + source tại `0bf3273`: sửa guard trước mọi test lại; duyệt feed tại CarPlayApp nhưng không bê nguyên classifier của probe; chưa duyệt ghép cặp pinch; hiệu chỉnh phạm vi kết luận weather; ENFORCE giữ đóng |
| 1 — Static integration (candidate) | **PASS** | Candidate 1.027.106 B `b6c5f328…`: parity 0 mất ở 8/8 thành phần, SplitScreen +7 đúng thiết kế; g1/g2/h(C-A+C-B)/f diff = 0; knob 1 eor; 4 hash cấm MATCH; hostFrameInfo 30 key; hook 31 call-site không tăng; chuỗi mới đủ số format; diff instrument thuần cộng (integration-ytz3) |
| 1 — Static integration (FAT, hai lát) | **PASS** | FAT 1.224.728 B `c1872b93…`: bridgewake 5/5 × 2 binary × 2 lát; ytlease 2 kênh phía AppBridge × 2 lát; chuỗi mới đúng số format mỗi lát ([probe-feed] ×8, [touchset] ×1, [applib] ×8, [scenevis] ×1, snap{ ×1, [weather] ×17); fullscreenTestExpand = 0 toàn gói; 3 khoá chẩn đoán trong CODE của binary Prefs × 2 lát; knob đúng 1 eor × 2 lát; parity vs FAT ytz2: SplitScreen 1387 → 1394 mất 0, 7 binary còn lại identical từng tên (ci-ytz3) |
| Kiểm độc lập | **PASS** | verify-ytz3: (a) guard khẳng định + ranh giới snapshot; (b) feed khẳng định, một lệch mô tả thứ tự cổng không đổi tập quyết định; (c) instrument thuần cộng 163/0 trên 5 file; (d) phán rủi ro gen của feed: chức năng ≈ 0, đối chiếu chỉ bằng timestamp (PATCH_NOTES §25.3) |
| 2–5 — Xe (controller sạch / native wake / touchset / YTZ OFF dài / hồi quy) | **PENDING** | Chưa chạy phiên nào trên bản này — kịch bản 5 bước ở dưới |

## Bảng verdict từng track

| Track | STATIC | RUNTIME | DEVICE | Căn cứ / điều kiện còn thiếu |
|---|---|---|---|---|
| FS controller (guard mới) | **STATIC_PASS** | PENDING | PENDING | Bước 1: ca đóng-hẳn-phải-chạy + ca mở-thật-phải-chặn; ma trận 10 chu kỳ / disconnect / app crash của P2 vẫn chưa chạy ở bất kỳ bản nào |
| Wake — ô native (feed mới) | **STATIC_PASS** | PENDING | PENDING | Bước 2: fade → chạm ô native → `[probe-feed] fired` → reveal-applied; phiên ytz2 đã kết án đường cũ (16 + 25 Began, 0 reveal) |
| Wake — ô hosted (act F4) | **STATIC_PASS** (kế thừa) | — | **DEVICE PASS** (phiên ytz2) | 32/32 act khép kín, reveal 17/17; ENFORCE (nuốt chạm đầu, Gate 3) vẫn KHOÁ theo GPT |
| Pinch (đo touchset) | **STATIC_PASS** | PENDING | PENDING | Bước 3 chỉ THU DỮ KIỆN: đội phân tích đọc `[touchset]` phân định contact độc lập vs biểu diễn trùng; quyết định kiến trúc thuộc GPT sau dữ kiện này |
| YT-Zoom | **STATIC_PASS** (kế thừa) | — | **DEVICE PASS** (phiên ytz2) | Chỉ còn đối chứng OFF dài ở bước 4 (phiên trước mới 0,5 s) |
| Weather (instrument) | **STATIC_PASS** | PENDING | PENDING | Bước 5: chuỗi `[weather]` req#→ans#→applied→display phải khép được theo thứ tự trong log của chính phiên; kết luận hiển thị chỉ chấm khi chuỗi khép |
| Núm divider | **STATIC_PASS** (kế thừa) | PENDING | PENDING | Phiên ytz2 NO DATA (0 dòng payload); chấm bằng quan sát xe ở bước 5 hoặc chờ GPT phán instrument payload |
| Mất icon / ô trắng (instrument) | **STATIC_PASS** | PENDING | PENDING | Bước 5: đọc `[applib] live-grid-read` omni= + `[scenevis] going-home`/`verify` từ log phiên này để khoanh vùng cơ chế |

Không mục nào được gọi là PASS ở cấp cao hơn bằng chứng hiện có.
ENFORCE (wake lẫn pinch) vẫn đóng theo phán quyết GPT.

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0.

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | DE2614F0-4855-3FA8-A4FD-352B173F0EBB | 14BBAD21-39E2-3687-ADD8-7C862A6384FE |
| OmniCarAppBridge | EC296AC0-2DEB-3D8B-A6EE-18F31F6844F0 | CDA16254-3BCB-3229-8E1D-FEE91A63FF9E |
| OmniCarCarProbe | 0692373B-5B2C-3722-AE3C-B8930EB13958 | 418F189C-89CD-35C2-AFF7-3EE3F8FA9ED6 |
| OmniCarCore | 72FDDB4D-C760-31B2-97BE-8DBD66DD7430 | 9B83B007-04CF-3CEF-BF6A-C36A9F7B11CC |
| OmniCarPrefs | 2A9E1D10-A996-390D-8B43-341AEAF0F307 | 88F1CD91-A094-36FA-A5A8-DE19178A4560 |
| OmniCarSpeedBubble | 4D817904-657E-3059-B54C-8611E79BC6F5 | EEC75E69-68AD-368A-81A1-CA29D993AB91 |
| OmniCarSplitScreen | CA7EFC72-4882-31F5-86F7-4292AD57D330 | 4947C6C1-80F4-313E-90F2-1648E8D29E64 |
| OmniCarStartupScreen | 19CDA773-E7EA-3F5E-B5FB-2DA26A5D6629 | 431CD8C1-B6CB-3B36-A373-F350FB6394F3 |

## Tag log của vòng (để đối chiếu trong phiên)

- `[probe-feed]` — quyết định feed native tại CarPlayApp:
  `fired pane=slotK(<bundle native>)` hoặc
  `drop-<reason>` (inactive / unconverted / display /
  systemregion / popup(<sub>) / notassigned / hosted),
  kèm `t=` monotonic + `epoch=` (epoch của probe —
  KHÔNG phải gen của owner, xem PATCH_NOTES §25.3).
- `[touchset]` — tập touch đang sống sau mỗi event làm
  đổi tập: `active=N` + từng record (ptr / win / raw /
  scr / pane / evB). Đầu vào phân định pinch của GPT.
- `snap{…}` — hậu tố snapshot trên MỌI dòng refuse của
  FS controller: tw / twh / to (trayOverlay) / tray /
  picker / ratio / dg (dragGhost) / toast / rz / fc /
  phase. Đọc kèm reason= để phân định chặn đúng/oan.
- `[applib]` — live-grid-read (count + omni của lưới
  gốc) / bridged-rebuild / drop chosen-not-installed /
  drop library-walk + tally (duplicate)/(no-carplay-ui) /
  build picker-native / picker-chosen /
  publish-for-settings.
- `[scenevis]` — <event> bundle= slot= scene= attached=
  inHost= hidden= alpha= window=; event: attach /
  detach(-bg) / scene-destroyed / verify / pane-remove /
  invalidate / going-home / host-attach / host-state-*.
- `[weather]` — req# (phía CarPlayApp) và ans# (phía
  SpringBoard), tương quan theo THỨ TỰ + timestamp
  (kênh không mang id): begin / ask-springboard /
  retry-post / timeout-no-answer / answer-received /
  applied / display category=; phía SB: darwin-received /
  begin / dropped reason=in-flight / fetch-begin
  source= / answered-without-weather / ready-posted;
  warming mang nhãn `source=warming-cache (internal
  startup call, NOT a CarPlay request)` và không có
  dòng req# nào; cache khởi tạo mang nhãn
  `source=initial-cache (NOT a request answer)`.
- Các tag của ytz2 giữ nguyên: `[autohide]`, `[wake1]`,
  `[probe]` / `[probe-foreign]`, `[fs-diag]`, `[fs1]`,
  `[pinch1]`, `[ytz]`.

## Kịch bản nghiệm thu một phiên

Chuẩn bị: cài bản FAT này (thay ytz2 như mọi vòng; KHÔNG
cài ytz1 cách ly). Mặc định khi cài: wake/pinch DRY_RUN,
AutoHide BẬT, YT-Zoom BẬT. Nhóm **Chẩn đoán** ở cuối
trang Cài đặt → OmniCar → Chia màn hình (section 6):
công tắc `fullscreenDiagExpand` (tắt), công tắc
`youtubeVirtualize` (bật), segment `bridgewake.pinchMode`
(nấc giữa = Đo). Toàn bộ năm bước chạy trong MỘT phiên
kết nối (trừ các bước ngắt–nối lại có chủ đích), log +
.ips (nếu có) up vào logs/ của repo sau phiên.

**Bước 1 — Controller sạch (kiểm guard trước mọi thứ
khác).** Vào split hai ô (tỉ lệ khác 50:50 cũng được),
segment pinchMode để **Off (0)**:
1. Mở picker chọn app một lần rồi **đóng HOÀN TOÀN**
   (chờ sheet biến mất hẳn). Gạt `fullscreenDiagExpand`
   ON: expand **PHẢI chạy** — log `fs expand confirmed`,
   dock + Home + status bar ẩn đúng, hai ô giữ tỉ lệ.
   Đây là ca kết án của guard cũ: bản ytz2 chặn ca này
   bằng `reason=tray` (đúng hay oan không phân định
   được — §25.2); bản này nếu còn chặn, dòng refuse có
   `snap{…}` để đọc trạng thái thật tại chỗ.
2. Tắt công tắc: `fs restore confirmed`, frame +
   clipping trở lại đúng, không `unconfirmed`/`rollback`.
3. Mở lại picker và **để nó đang mở**, gạt công tắc ON:
   expand phải **vẫn bị chặn** (reason picker/popup) —
   guard mới không được thả ca này.
4. Nếu thời gian cho phép: lặp ON/OFF vài chu kỳ; một
   lần ngắt CarPlay giữa EXPANDED rồi nối lại → về
   SPLIT sạch, dock không kẹt ẩn. (Ma trận P2 đầy đủ —
   10 chu kỳ, đổi app/xoá ô/app chết giữa EXPANDED —
   vẫn còn nợ từ các vòng trước; chạy được phần nào
   ghi phần đó, không tách phiên riêng.)

**Bước 2 — Native wake (feed mới).** Vào split có ít
nhất một ô **native** (Maps/Music/GOFA):
1. Chờ controls mờ hẳn (4 s). Chạm ngay vào nội dung ô
   native: controls phải hiện lại; log có
   `[probe-feed] fired pane=slotK(<bundle native>)` →
   `reveal-applied reason=activity`. Đây là ca đã FAIL
   hai lần ở phiên ytz2 (16 + 25 Began, 0 reveal).
2. Chờ mờ, để thêm 10 s, chạm ô native: vẫn phải hiện.
   Chờ mờ, để thêm 30 s, chạm: vẫn phải hiện.
3. Đối chứng loại trừ: chạm trong lúc popup đang mở →
   log `drop-popup(<sub>)`, controls KHÔNG hiện (đúng);
   chạm ô hosted → `drop-hosted` và đường act F4 lo
   (act-posted → reveal như phiên ytz2); chạm góc
   dưới-trái (vùng Home) → `drop-systemregion` và máy
   thoát Home là ĐÚNG thiết kế, không phải lỗi feed.
4. Phiên toàn-native: dựng 2 ô native, chờ mờ, chạm ô
   native — controls phải hiện ngay trong phiên (chuỗi
   hậu quả của phiên ytz2 — kẹt mờ → thoát góc → mất
   icon — phải bị cắt ở mắt đầu tiên này).

**Bước 3 — Touchset (chỉ thu dữ kiện pinch).** Segment
pinchMode = **Đo (1)**. Pinch ra/vào tự nhiên vài lần
trên ô native và vài lần trên ô hosted, xen vài lần
chạm một ngón thường. KHÔNG chấm lệnh thật nào ở bước
này (DRY_RUN không bắn lệnh): log `[touchset]` +
`[probe-feed]` của phiên là đầu vào để đội phân tích
phân định có 2 contact độc lập đồng thời cùng ô hay
chỉ có biểu diễn trùng qua window — GPT quyết kiến
trúc pinch (ghép cặp tại CarPlayApp hay đường khác)
SAU dữ kiện này. Nếu pinch tình cờ trông như có tác
dụng thị giác, ghi lại mốc thời gian, không kết luận.

**Bước 4 — Đối chứng YTZ OFF dài (sửa caveat phiên
trước).**
1. Tắt `youtubeVirtualize` trong nhóm Chẩn đoán và
   **giữ OFF ít nhất 10 giây** (phiên ytz2 chỉ giữ
   được 0,5 s — không tính). Mở YouTube hosted, bấm
   fullscreen trong player: hành vi hướng phải còn
   nguyên như fixround7 (đối chứng OFF).
2. Bật lại công tắc, mở YouTube ở split hỗn hợp
   (YouTube hosted + Maps native): log lease phải
   mang `split=1`, KHÔNG có `isSplit-fallback`; bấm
   fullscreen: ack `applied` windows=1 mismatch=0,
   video nằm đúng trong ô (chấm lại nhanh — track
   này đã DEVICE PASS ở phiên ytz2, bước này chỉ
   đóng nốt đối chứng OFF).

**Bước 5 — Hồi quy weather / icon / ô trắng + núm.**
1. Weather: để splash hiển thị và yêu cầu thời tiết
   chạy tự nhiên lúc kết nối. KHÔNG chấm hiển thị từ
   cảm tính: sau phiên, đọc log — một request thật
   phải để lại chuỗi khép được theo thứ tự:
   `[weather] req#N begin` → `ask-springboard` →
   (SB) `request received` → `ans#M begin` →
   `fetch-begin source=` → dòng fetch gốc
   updated/failed → `ready-posted` → (CP)
   `answer-received for req#N` → `applied req#N
   temp=… isDay=…` → `display category=…`. Các dòng
   `source=warming-cache` là giao dịch nội bộ lúc
   khởi động, không tính là request. Chuỗi khép +
   nhiệt độ/gradient khớp category ngày/đêm trên màn
   mới chấm được mục này.
2. Icon + ô trắng: sau bước 2.4 (phiên toàn-native)
   và các lần thoát Home trong phiên, kiểm icon
   OmniCar còn trên lưới/dock gốc không; nếu có ô
   nào trắng, ghi mốc thời gian. Sau phiên, đội phân
   tích ghép `[applib] live-grid-read` (omni= lật
   1→0 ở mốc nào, danh sách nào mất nó trước) +
   `[scenevis] going-home` / `verify` (khung đúng
   nhưng attached/inHost/hidden/alpha/window ra sao)
   để khoanh cơ chế — vòng này chỉ instrument, chưa
   sửa đường Home thật (SCPHooks/SCPAppIcons/
   SCPHomeApply nằm ngoài phạm vi, chờ GPT mở vòng).
3. Núm divider: núm trở về kích thước thường khi
   thả, phình đúng khi bấm; chạm cách vạch vài cm
   phải vào được app. Chấm bằng quan sát (log không
   có payload núm — giữ nguyên sự thật NO DATA của
   phiên ytz2 cho tới khi có phán quyết instrument).
4. Hồi quy chung: thanh "..." của app hosted mở/đóng
   bình thường; solo/split/swap; nút Home; splash
   chào (trừ phần nhiệt độ chấm ở mục 1).

## Điều kiện mở ENFORCE (sau phiên này)

- **Wake ENFORCE (nuốt chạm đầu, ngữ nghĩa QA180):**
  vẫn KHOÁ theo GPT. Gate 3 là nuốt cú chạm đầu —
  bằng chứng hiện có (kể cả khi bước 2 đạt) mới
  chứng minh đường activity/reveal; log còn
  `failopen=kbunknown`, điều kiện suppression chưa
  hoàn tất bằng chứng. Feed native vòng này không
  nuốt chạm nào.
- **Pinch ENFORCE:** mặc định DRY_RUN (P4). Chỉ bàn
  khi: controller đạt bước 1 (độc lập), dữ kiện
  `[touchset]` ở bước 3 cho thấy đường hình thành
  cặp khả thi, và GPT phán kiến trúc. Không tự bật
  segment Enforce trong phiên này.

## Còn mở (không thuộc nghiệm thu phiên này)

- Ba đề xuất chờ GPT (PATCH_NOTES §25.5): accessor
  gen chỉ-đọc ở BridgeWake.h; vòng instrument/sửa
  đường Home thật cho cơ chế mất icon; chở
  generation qua notify state cho kênh
  weather.request.
- Kiến trúc pinch: chờ dữ kiện `[touchset]` của
  chính phiên này + phán quyết GPT.
- VISUAL_ORIGINAL_COMPARISON: vẫn PENDING (thiếu
  footage deb gốc cùng kịch bản).
- Đo Y4 đầy đủ (heartbeat gián đoạn, restart
  app/host, đổi owner lease): chưa chạy.
- Snapshot ở đường unconfirmed của FS controller:
  chưa có (chỉ 6 điểm refuse ở cổng vào) — cộng
  thêm nếu GPT yêu cầu.
- Bản sao Weather phía Prefs (OMCCommon.m): GPT
  phán chỉ audit đọc, không sửa khi chưa có bằng
  chứng chức năng. ahForgetView: chờ GPT phán.

## Trạng thái

- ytz3: SOURCE HOÀN THIỆN + STATIC PASS (candidate +
  FAT hai lát). Mọi verdict xe: PENDING cho tới khi
  Nguyen chạy phiên 5 bước trên và log được phân tích.
- QA20 vẫn là bản dùng hằng ngày của Nguyen. ytz1
  CÁCH LY — không cài. Rollback: ytz2 FAT / fs1 FAT /
  fixround7 FAT / gói hợp nhất QA20.
