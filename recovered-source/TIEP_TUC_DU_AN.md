# TIẾP TỤC DỰ ÁN — OmniCar 1.0.3: phục hồi mã nguồn (clean-room reverse engineering)

> Mục tiếp tục dự án duy nhất của toàn bộ quá trình xây lại mã nguồn OmniCar 1.0.3 từ binary gốc.
> Cập nhật lần cuối: **2026-11-09, sau khi giao fixround7**. Bản đang đứng: **fixround7 FAT** (mục 8).
> Hồ sơ chi tiết theo vòng nằm ở `handover/PATCH_NOTES.md` (§1–§21), `handover/RECOVERY_STATUS.md`,
> `handover/ACCEPTANCE_*.md`; biên bản điều tra nằm ở cây làm việc `work/`. Tài liệu này là bản tổng hợp để
> bất kỳ ai (Nguyen / GPT / Muse) mở ra là nắm được toàn bộ trạng thái mà không phải đọc lại từ đầu.

---

## 1. Nhiệm vụ và nguyên tắc bất biến

- **Đầu vào duy nhất:** DEB gốc chính hãng `com.anlai.omnicar 1.0.3`,
  SHA-256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.
  Phục hồi **chỉ từ binary đã kiểm chứng** — không tra mã nguồn công khai, không dùng lại executable gốc
  làm thành phần runtime của bản dựng.
- **Nhãn trung thực cho mọi hàm/khẳng định:** VERIFIED (đã đối chiếu dump) / INFERRED (suy ra, ghi rõ) /
  UNRECOVERED (chưa phục hồi được). Chỉ được nói "hoàn thiện" khi không còn executable gốc trong gói
  và không còn stub chức năng — và cuối cùng vẫn phải qua nghiệm thu xe thật.
- **Phân vai:** GPT phân tích độc lập + phán quyết thứ tự ưu tiên; Muse điều phối đội agent điều tra/sửa,
  tích hợp, đóng gói, kiểm cổng; Nguyen test trên xe và là phán quyết cuối cùng về hành vi.
- **Quy tắc số 1 (Nguyen, 07/11/2026): ĐỦ CƠ SỞ MỚI LÀM** — đọc source/dump thật của đúng cơ chế sắp sửa,
  đọc log và dữ kiện đo được; thiếu cơ sở thì việc hợp lệ duy nhất là đi tìm dữ liệu. Báo cáo luôn tách
  "có bằng chứng" khỏi "đang giả định".
- **Đóng gói:** Version trong control luôn là `1.0.3`; danh tính vòng chỉ nằm ở tên file và marker log
  `[fixroundN]`. Bản FAT (arm64 + arm64e) đóng bằng CI macOS; bản local VM chỉ arm64 (clang VM hạ arm64e).
  **Không publish Sileo** cho các bản RE (phán quyết GPT 08/11) — giao file FAT qua chat.
- **Kiểm chứng:** cổng kiểm chỉ có giá trị khi đo trên binary trích từ **chính DEB cuối cùng**;
  kết quả poll nền từng bịa run ID nhiều lần → mọi run/hash đều truy vấn trực tiếp ở foreground.
- **Test xe:** mỗi bản đúng **một phiên test gộp**; "log PASS" không bao giờ bằng "màn hình PASS".

## 2. Sự thật về bản gốc (đã kiểm chứng)

- Đúng **8 Mach-O**, tất cả FAT arm64 + arm64e (PAC00), min iOS 15.0. Bản gốc 1.0.3 **không có** dylib
  fullscreen riêng (khác hẳn bức tranh thời QA20).
- **66 class, 1.872 method** (Prefs nặng nhất: 743). Một lõi OMC dùng chung cho mọi module.
- Toàn bộ IPC bằng **Darwin notify — 41 kênh**; miền prefs `com.anlai.omnicar` — **53 key**.
- Hết hạn: epoch **1809104400** (01/05/2027), fail-open, dùng thời gian tin cậy.
- **Cơ chế lưới xe:** tuyên bố CarPlay tổng hợp (`CRCarPlayAppDeclaration`) được ghép vào thông tin của app
  đã chọn → app hiện trên lưới xe **mà không cần bật/tắt gì trong Cài đặt CarPlay gốc của iPhone**.
- Zoom: `clamp(pref/100, 0.6, 1.0)`, mặc định 80.
- Cây dự án gồm 4 module Theos chính: AppBridge, SplitScreen, StartupScreen, Prefs (+ Core dùng chung).


## 3. Môi trường làm việc

- **Thiết bị test duy nhất:** iPhone X, palera1n rootless, iOS 16.7.16. CarPlay qua adapter không dây
  CarCast; test cũng diễn ra tại nhà trên màn hình điện thoại mirror — số đo hình học từ ảnh/video
  **không đáng tin**, log mới là bằng chứng.
- **VM build:** Theos `~/theos`, SDK iPhoneOS16.5, clang-18. `/usr` của VM bị rollback lặng nhiều lần
  (mất clang/ldid/symlink) → trước mỗi build phải verify toolchain, hỏng thì chạy `~/bin/fix-toolchain.sh`.
  Gotcha Theos đã trả giá: `<TWEAK>_USE_MODULES := 0`, `<TWEAK>_LDFLAGS := -fuse-ld=lld`, `umask 022`;
  build **từng module** (make ở root có thể báo "Nothing to be done" với object cũ).
- **CI FAT:** workflow `build-fat-macos.yml` (id **410962367**), nhánh `ci-fat-test`; dispatch đúng một lần
  cho mỗi vòng; artifact chỉ lấy từ run dispatch đó (push cũng tự kích hoạt một run song song — không dùng).
- **Repo:** `chuongnguyen89dn-ui/Omnicar` (public). Nhánh `main` chứa cây `recovered-source/` (dự án này)
  và `logs/OmniCar.log` do Nguyen up sau mỗi phiên test ("Add files via upload"). Trước mọi lần đẩy phải
  `git fetch` — remote tiến lên bởi chính các lần up log đó.
- **Cây làm việc:** `~/workspace/omnicar-re/` (`src/`, `project/`, `handover/`, `metadata/`, `verify/`,
  `work/`); staging đẩy GitHub: `~/workspace/omnicar-push/recovered-source/`.

## 4. Dòng thời gian các vòng xây/sửa

### Giai đoạn dựng nền
- **Đếm và lập bản đồ:** 8 binary, 66 class / 1.872 method, 54 hook, 41 kênh notify, 53 key prefs;
  dựng khung 4 module biên dịch được.
- **Consolidated** (commit `e927796`): đối chiếu bản vá A1–A6 của GPT, khôi phục B1 `ensureContainer`
  + B2 `autoLaunch` từ binary gốc, sửa ABI C1–C4, thêm log chẩn đoán.

### Các vòng sửa crash và cổng
- **Portrait fix** (`935f35e`): địa chỉ mô tả TLS **đóng cứng từ binary gốc `0x87f60`** trong helper
  SCPGridDimension (dùng bởi cả 4 hook lưới icon) được thay bằng biến `__thread` khai báo trong source,
  khôi phục đúng cấu trúc exception và ngưỡng unsigned của gốc. Quét toàn cây theo lớp lỗi này (349 file):
  sửa thêm key associated-object `0x3E9E4` trong ABInApp và hai key StartupScreen chưa khởi tạo;
  Prefs sửa lỗi đối số format của log crash và khôi phục `shouldShow` của WhatsNew theo gốc (sub_198c4).
- **Arityfix** (`e12b022`): hai crash trên xe — SplitScreen SIGBUS ×9 do `OMCPref` khai 1 tham số nhưng
  hàm thật 2 tham số + sót retain ở selector `autoLaunch`; StartupScreen UAF do splash dùng `ASSIGN`
  trong khi gốc là `RETAIN_NONATOMIC`.
- **Gatefix** (`4dc819b`): app-info qua `sharedApplicationLibrary` (sub_4672c), các nhánh của
  `SCPIsHostedApp`, fallback proxy cho displayName, cổng phân số `1-ratio` và hình học panel bố cục.
- **Prefsround** (`0cd12b8`, FAT SHA `44019c7c…`): Prefs W1–W4 + ghi đo [W1]; sửa kiểu launch-info
  (SCPCarSplit:558); hình học splash Liquid (`_k/_ox/_oy`); khôi phục SpeedBubble phía xe (23 pt) và viết
  lại preview phía Prefs; `deleteSound` là lệch đơn-file có chủ đích theo phán quyết GPT.
- **CI fix** (`b60cd16`): Version trong cây bị trôi khỏi 1.0.3 làm workflow FAT đặt sai tên gói — đã cố định.
- **fixround2 — vòng G** (PATCH §17): các mục G từ Expanded Audit của GPT (hook safe-area, Home,
  sổ P2 sáu mục có nhãn ĐÃ SỬA / GIỮ KHÁC CÓ LÝ DO / CÒN MỞ cho từng mục).
- **fixround3** (`3202cb8`, FAT `77230019…`): cụm A/B/C + D1–D6 + E1/E2 + G. **Xe test THẤT BẠI:**
  thanh "..." không xuất hiện trên các ô app hosted; hình học picker vỡ; hầu hết app bản đồ "không mở
  được"; splash Lời chào rò thành phần thời tiết.


### Sau fixround3: ba đợt phân tích của GPT và các vòng 4–7
Từ log + ảnh phiên fixround3, GPT ra **Consolidated Repair Order (A–I)**, **Deep Function Wiring Audit
(N1–N14)** và bộ phân tích nguyên nhân 0814. Các vòng sau triển khai đúng các bộ này.

- **fixround4** (`84cd742` + bổ sung `89981a9`; FAT 1.157.608 B, SHA `6ab47eab…`, CI 42550858598):
  hợp đồng launch A; máy trạng thái hostedApp C; giao dịch swap F; solo-hidden H; picker cột phụ 150 pt
  + nhận ô vừa trống + khôi phục KVC cho recoverPending; splash LP-1/LP-2 (scene thời tiết rò vào Lời chào
  qua nhánh hiện-dữ-liệu; icon thời tiết sai slot ivar); wiring N1–N14 (bardismiss, knob convertPoint,
  công thức layout thanh, cover tag 77 + tắt tương tác, validSlot, raiseLauncher, đuôi bắt lỗi
  remoteKnobTouch, chữ ký SCPMissingSelector…).
  **Kết quả xe:** tiến bộ rõ (picker đúng hình, GOFA/Music nhận ô đúng scene, swap chạy, menu tỉ lệ mở và
  hết tự đóng hàng loạt, rò thời tiết ở splash hết; THIEU=0, exception=0) nhưng **thanh "..." của app
  hosted vẫn không hiện** và chữ splash vẫn chèn lên logo.
  Truy vết log: 73 cặp "cham thanh" (SpringBoard) ↔ "bridge handletap" (CarPlay) khớp 1-1 (~3–4 ms) —
  hit-test và cú nhảy thông báo được minh oan; điểm gãy nằm ở **khâu cuối phía SpringBoard**.
- **fixround5** (`860c8b6`; FAT 1.158.270 B, SHA `03010edc…`, CI 42556431536): sửa C-A + C-B của thanh
  host (mục 5) và khôi phục playIntro cả hai bản (xe + Prefs).
  **Kết quả xe: Nguyen xác nhận thanh "..." ĐÃ HOẠT ĐỘNG** trên các app từng hỏng. Còn lại: phần tử tròn ở
  mép phải vẫn nửa ẩn trong split hỗn hợp + vùng chạm quá lớn (→ núm vách ngăn, mục 5); YouTube phóng to
  bị xoay 180° trong ~0,7–1,3 giây (→ hai cổng hướng, mục 5); chữ splash chèn logo được kết luận là
  **thiết kế của gốc** (mục 5).
- **fixround6** (`278129f`; FAT 1.155.606 B, SHA `0ce8a4f7…`, CI 42560546579): chỉ sửa hai cổng suy
  hướng bit-2 (host + app) mà GPT bắt được.
  **Kết quả xe:** log xác nhận đáp số đã đúng (YouTube mask 24 → hướng 4 mọi lần) **nhưng vòng xoay vẫn
  còn** trên video. Strand truy thời gian/seeding kết luận cơ chế đã khớp gốc toàn bộ (mục 5) —
  GPT chốt: **đóng điều tra tĩnh**, mốc thị giác để PENDING (mục 6).
- **fixround7** (`cee2d21`; FAT 1.159.010 B, SHA `f2cc8ffe…`, CI 42564680212): Weather trọn cụm
  W1–W8 + gradient style 3, gộp sửa bộ lọc hướng {3,4}. Toàn bộ cổng trên candidate đạt, gồm hồi quy
  thanh hosted (h) và hai cổng hướng (g1/g2). **Đang chờ phiên xe nghiệm thu Weather** (mục 6).
- **wake1** (`a907505`; FAT 1.184.484 B, SHA `279005f4…`, CI 42573985624): vòng TÍNH NĂNG trên nền
  fixround7 — Bridge Wake (chủ trạng thái tổng hợp mới ở SCPCarSplit + xác nhận ABHost + relay/probe/
  suppression trong ABInApp, giao thức bridgewake.v1, hai mode độc lập mặc định DRY_RUN) + pinch
  recognizer/probe DRY_RUN với adapter rỗng + sửa cực publishKnobsNow. Gate 0/1 PASS tĩnh (parity
  mất 0/8, harness giao thức 38/38, núm đúng 1 eor ở cả hai slice). **Pinch BLOCKED tại cổng A1**
  (dylib fullscreen QA20 không có entry điều khiển hợp lệ — PATCH_NOTES §22.3). **Đang chờ MỘT phiên
  xe gộp:** Gate 2 dry-run + kiểm núm + nghiệm thu Weather của fixround7.

## 5. Các kết tội lớn — nguyên nhân và cách đóng

### 5.1 Thanh "..." của app hosted: hai lỗi chồng nhau ở khâu cuối (ĐÃ ĐÓNG trên xe)
Hàm gốc `-[ABHost setBarVisible:pop:dim:single:forApp:]` (@0x11868) bị phục hồi sai hai chỗ:
- **C-A — đảo cực điều kiện:** gốc chỉ chuyển trạng thái khi `isHidden == visible` (@0x11ab8–0x11ac8:
  `cmp w23,w0; b.ne → return; cbz w23 → hideBarForPane:`); bản dựng viết `!=` — mà thanh sinh ra với
  hidden=YES nên nhánh hiện **không bao giờ tới được**. Trên hàm này từng treo nhãn "VERIFIED" sai.
- **C-B — rơi lệnh `bar.alpha = 1`:** khối vào của gốc (sub_125C0 @0x125d4) đặt alpha 1 *trước*
  setTransform:; buildBar sinh alpha 0 và nhánh ẩn cố ý không khôi phục alpha → sửa C-A một mình thanh
  vẫn trong suốt.
GPT độc lập kết tội đúng hai điểm này từ chính DEB đã test; bản vá của hai phía tương đương từng ký tự.
Các hướng khác đã minh oan bằng bằng chứng: hostBarInfo khớp (không mang frame; hình học do host tính),
thứ tự z sạch (scene chèn một lần ở index 0, thanh nằm trên), app native dùng hàm trùng tên khác ở module
CarPlay nên luôn chạy — đó là lý do "native được, hosted không".


### 5.2 Hai cổng suy hướng bit-2: đảo cực ở cả hai phía (ĐÃ SỬA — xác nhận trên máy ở tầng giao thức)
Triệu chứng: YouTube hosted phóng lên solo thì hình **xoay đúng 180°** trong ~0,7–1,3 giây rồi mới đúng.
Một vòng audit đầu kết luận "mọi hàm đều khớp" — **kết luận đó đã bị rút lại chính thức** (PATCH §20.1):
audit kiểm sự hiện diện/chữ ký mà không truy cực của nhánh quyết định.
- **Phía host** — `appWithHash:changedOrientation:supportedMask:`: dãy gốc `and x8, x21, #2` →
  @0xf860 `cmp x8,#0` → @0xf864 `csel x8, xzr, x9, ne`: bit portrait (2) **có mặt → kết quả 0** (không
  đổi, rơi về hướng của ô); **vắng → hướng đã tính**. Bản dựng làm ngược. Bảng thật (changed=255):
  mask 24 → gốc **4**, ta (cũ) 0→rơi về 1; mask 26/30 → gốc **0**, ta (cũ) 4.
- **Phía app** — `ABOrientationDerivedFromMask` (ABInApp.m): gốc @0x57c0–0x57c4 `tst w0,#2; csel …` —
  bit có mặt → 0; bản dựng viết `if (!(mask & 2)) v = 0;` — ngược.
Đã sửa cả hai ở fixround6; bản release biên dịch ra **đúng dạng csel của gốc**; log xe vòng 6: mask 24 → 4
mọi lần, mask 2 → 1. Đây là lần đảo cực thứ ba và thứ tư trong dự án (sau C-A và publishKnobsNow) —
**cực của nhánh quyết định là bệnh tái phát số một**; từ đây cổng kiểm bắt buộc truy vết cực so với dump,
nhãn VERIFIED không còn được cấp cho nhánh chưa truy cực.

### 5.3 Vòng xoay YouTube fullscreen trong split: cơ chế của gốc (ĐIỀU TRA TĨNH ĐÃ ĐÓNG)
Video fixround6: bấm nút phóng trong player → hình xoay qua góc chéo ~1–1,5 giây rồi chốt dạng ngang.
Log cùng phiên: trong cả ba chu kỳ phóng, **khung ô không đổi một lần nào** (YouTube giữ ô split
{297, 360}); chỉ giá trị hướng của scene lật 1→4→1, mỗi chu kỳ hai yêu cầu cách ~0,87 giây, đều đáp
đúng bảng. Đây là fullscreen **nội bộ của app**: app xin hướng ngang, nhận 4, rồi tự xếp lại giao diện
trong khung đứng yên.
Strand truy dump chốt: gốc **không hề seeding** — `setRequestedOrientation:` có đúng một điểm ghi trong
toàn binary host (0xf884, trong chính appWithHash:); đường solo/zoom không bước nào nạp hướng trước.
Hằng thời gian khớp từng số: debounce gốc `0x0EE6B280` = 0,25 s; nudge `0x02FAF080` = 0,05 s. Kênh
hướng đóng gói **số thuần** qua notify_set_state (sub_67fc: `field | mask<<8 | hash(bundle)<<24`);
host dùng thẳng `changed` khi changed ≠ 0xFF (@0xf87c) — đường YouTube trong log đi qua sentinel 0xFF.
Bridge không có hook nào ở đường nút phóng của player. **Quyết định (GPT + Nguyen): không viết cơ chế
chống xoay, không ép solo, không đổi 0,25/0,05 s.** Phân định thị giác cuối cùng: mục 6.

### 5.4 "Logo tròn" = núm vách ngăn: đã kết tội, ĐANG GIỮ theo thứ tự đã chốt
Phần tử tròn ở mép phải là **núm của vách ngăn chia đôi** — cặp hai process: đĩa 14×14 phía CarPlay
(`layoutKnobOf:` @0x2c848, không nhận chạm) + gương **ABKnobView** phía SpringBoard (đĩa chạm 66×66,
nền alpha 0.012, chấm 14×14; chạm relay qua `appbridge.knobtouch`). SpeedBubble được minh oan (neo theo
cửa sổ màn xe, ẩn khi split bận — không thể bám vách ngăn).
- **Kết tội:** `publishKnobsNow` (@0x3ed84) phát phần tử "active" với **cực bị đảo** — gốc @0x3eff8
  `eor w2,w27,#1` phát `!CGAffineTransformIsIdentity(transform)` (chỉ YES khi đang bấm, scale 1.6);
  bản dựng tính `scaled = !IsIdentity` rồi phát `@(!scaled)`. Gương vì thế **kẹt active vĩnh viễn**:
  chấm phình 22,4 pt, và dấu chân chạm phình theo thành **~105,6×105,6 pt**. Log fixround5 có **118 dòng
  "cham tron vach"**, điểm chạm lệch tới ~96 pt khỏi tâm vách — các chạm định dành cho app gần vách bị
  nuốt thành chạm núm, khớp verdict của Nguyen. Split hỗn hợp nhìn nửa ẩn vì nửa hosted vẽ bằng gương
  phình sáng, nửa native vẽ bằng núm local nhỏ mờ.
- **Khả năng "bề mặt native che gương" đã bị LOẠI trên giấy** (strand audit-knob-layer, 09/11): gương là
  subview trực tiếp của cửa sổ AB (windowLevel StatusBar + 60,0) và được `bringSubviewToFront:` ở mọi
  lần reconcile (@0x14294); phía SpringBoard **không tồn tại** surface/pane đại diện nào của app native
  để mà che; frame gương tính theo tọa độ cửa sổ (convertPoint:toView:nil), không tổ tiên nào
  clipsToBounds với nó (clips của pane.box chỉ cắt con của box). Runtime ủng hộ: 118 chạm lệch tới
  ~96 pt sang phía native vẫn bị gương bắt và relay. Hệ quả: triệu chứng "mất hiển thị ở split hỗn hợp"
  chỉ còn **một** nguyên nhân đứng được — chính lỗi đảo cực này (lệch cỡ/sáng hai nửa). Sau khi sửa cực,
  đĩa phải liền; nếu vẫn nửa vòng thì nguyên nhân nằm ngoài cả hai giả thuyết hiện tại, phải lấy dữ
  kiện mới.
- **Trạng thái: GIỮ** — cực này từng được ghi trong audit vòng 2 mà không được triển khai qua các vòng
  3–5 (lỗi quy trình đã nhận). Bản sửa là bỏ một phép phủ định; không đụng z-order/vùng chạm (66×66 và
  phình 26 pt/cạnh của gốc là thiết kế). Chỉ vào bản khi GPT/Nguyen thả theo thứ tự bằng chứng.


### 5.5 Weather: đường trả lời phía SpringBoard chết trên máy người dùng (ĐÃ SỬA ở fixround7 — chờ xe)
Điều tra `audit-weather.md` kết tội cụm lệch trong phân hệ thời tiết của StartupScreen; log fixround5
đối chiếu khớp 100% ở điểm nặng nhất:
- **W5a/b/c — cụm nặng:** `SSAnswerWeatherRequest` (gốc sub_7d10): (a) gốc chỉ vào one-shot khi trạng
  thái quyền vị trí ∈ {3,4} (dạng `(status−3) unsigned`), còn lại đi đường dữ liệu đã lưu/IP — bản dựng
  vào bất kể, mà máy Nguyen status = 0 nên chết ngay; (b) gốc giữ đối tượng one-shot ở ô toàn cục mạnh
  @0x3b190 — bản dựng giữ bằng biến cục bộ yếu, giải phóng ngay khi hàm trả về; (c) timeout gốc 6 s chốt
  bằng vị trí cuối + dọn cờ — bản dựng 10 s [INFERRED] kiểm tham chiếu đã nil, **cờ in-flight kẹt vĩnh
  viễn**, mọi yêu cầu sau bị bỏ qua. Kèm ngưỡng fix cũ gốc 1800 s (ta 300), nhãn @"fresh CoreLocation".
- **Vừa:** W1 cache không giới hạn tuổi — gốc truyền **43200** (12 giờ) ở cả hai điểm đọc, không có
  guard ngày-tương-lai; W4a cổng refresh gốc hỏi SpringBoard cho status ∈ {0,1,2} (@0x64c8), ta chỉ
  NotDetermined; W4b retry gốc @[@2, @5] + bộ đếm thế hệ @0x3b19c, bỏ cuộc ở 10 s gọi completion(nil) —
  ta 1 lần 3 s không thế hệ; W8 điểm gọi refresh trong `start` gốc chỉ khi style == 3 hoặc 8 (@0x5e50).
- **Nhỏ:** W2 thiếu ứng viên cache ở NSTemporaryDirectory + fallback ghi khi ghi chính fail (@0xbfa4);
  W3 parse gốc trả **nil** khi thiếu nhiệt độ (ta trả dict thiếu, có thể ghi đè cache tốt), coerce gốc
  NSNumber-only (sub_ba08), fetch gốc kiểm HTTP 200; W4c apply gốc có guard `finished` + chuyển cảnh
  CrossDissolve 0,35 s (options 0x500000, thân block sub_68c4 = `[view reload]; [view layoutIfNeeded]`);
  W6 cửa sổ vị trí đã lưu gốc ≤ 86400 s và không tương lai; W7 IP fallback gốc timeout 4.0/4.0.
- **Gradient style 3:** thiếu hoàn toàn (0/11 mã màu). Đặc tả đã đo trọn: điểm chọn lại ở reload
  @0xd10c–0xd35c sau khi lưu `_sky`; helper sub_d6f0 dựng cặp CGColor chia 255,0 alpha 1; bảng màu:
  cat 0/2 → (2A7FD8, 9FD3FF); 1/3 → (02030A, 0B1230); 4 ngày → (4A5B70, 8D9BAD), 4 đêm → (10141F,
  2A3243); 5 → (5F6670, 9AA1AA); 6/7/8 → (1C2633, 33404F); 9 ngày → (5D6E86, B4C2D3), 9 đêm →
  (141B2A, 38445A).
- **Hai điểm audit ghi "chưa rõ" đã giải bằng đọc bytes slice gốc:** quyền file SaveCache @0x34e88 =
  **420 (0644)** — khớp bản ta; và một lệch audit chưa từng ghi: parse gốc luôn gán mặc định khi ép kiểu
  fail — **code → @0, isDay → @1** (@0x34e58/@0x34e70). Cả hai đã xử lý trong fixround7.
- **Khớp từ đầu:** LP-1 suy style; phân loại category (mask 0x0339FC7F, bảng nhảy 26 mục); định dạng
  nhiệt độ; buildWeather (icon vào _iconView 0xcc4 — bản sửa vòng 4 còn nguyên).

### 5.6 Bộ lọc hướng {3,4} phía app (ĐÃ SỬA ở fixround7, tách bạch khỏi vụ YouTube)
Hook `setOrientation` của gốc (sub_5504 @0x553c–0x5544) lọc bằng `csel …, lo` trên (value−3) <u 2 —
chỉ giữ **{3, 4}**, value 5 → 0. Bản dựng giữ `(orientation−3) <= 2` → lọt cả 5 (FaceUp): host sẽ lưu
hướng 5 không tồn tại và layoutPane coi là landscape. GPT tự kiểm trên repo và chốt dạng sửa
`(orientation == 3 || orientation == 4) ? orientation : 0`. Không có bằng chứng hướng 5 xuất hiện trong
phiên YouTube — hai việc không gộp nguyên nhân.

### 5.7 playIntro và splash: khôi phục + chốt "giống gốc là đúng"
- **playIntro** từng là biến thể gộp [INFERRED]: đã khôi phục theo lựa chọn `[self logoEffect]` (pref
  `startupScreenLogoEffect`) ở cả bản xe và bản Prefs (fixround5): effect 1 spring 1,1 s / trễ 0,1 /
  damping 0,7, scale đầu 0,5; effect 2 glow shadowOpacity 0,0→0,95 trong 1,2 s lặp vô hạn đảo chiều,
  opacity mô hình 0,6f, radius 7·max(unit,1), fade 0,9 s; nhánh còn lại scale 0,96, 1,2 s / trễ 0,05.
  Hằng bịa cũ (radius 32, opacity 0,8) đã gỡ. Hiệu số "damping 0,86" thuộc spring nhánh scene, không
  thuộc effect 1 — đã đính chính. Đuôi `!logoView` phía Prefs được sửa theo ivar đọc được từ binary
  Prefs; **đuôi phía xe còn đỗ** (ba slot 0xcb0/0xcc0/0xcc8 chưa ánh xạ — mục 7).
- **Splash Lời chào:** hình học khớp gốc 14/14 (poster logo.png AspectFill toàn khung; logo AspectFit
  căn giữa; chồng nhãn [giờ, tiêu đề, ngày] ghim giữa; font 30/10/6 ×s Rounded…). Đầu vào đã so byte:
  15 PNG trong bundle trùng hệt giữa hai deb; artwork thật là file runtime
  `/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png` do người dùng nạp qua Cài đặt, cả hai bản
  đọc cùng đường trên cùng máy. **Kết luận: chữ chèn lên logo là thiết kế của gốc** — chỉ thay đổi khi
  có lệnh tuỳ biến riêng. Rò thời tiết vào Lời chào (lỗi thật, nhánh LP-1/LP-2) đã sửa ở fixround4.

## 6. Nghiệm thu: hai mức và những gì còn chờ

- **Giao thức nghiệm thu:** chạy bản gốc trước, bản dựng sau, cùng kịch bản; 9 nhóm chấm
  ĐẠT / LỖI / CHƯA THỬ theo hành vi quan sát được của bản gốc. "Không crash" một mình không phải ĐẠT.
- **Hai mức phải phân biệt (GPT chốt 09/11):** *trung thực cơ chế* (các nhánh đã kiểm khớp gốc) và
  *trung thực thị giác* (trên xe nhìn có giống gốc không). Nhiều mục đã đạt mức một, chưa đạt mức hai.
- **VISUAL_ORIGINAL_COMPARISON = PENDING:** cần video DEB gốc chạy **cùng phiên bản YouTube, cùng thao
  tác bấm fullscreen, cùng cấu hình màn hình** để kết luận vòng xoay 1–1,5 giây có tồn tại ở gốc hay
  không. Nếu gốc cũng xoay như vậy → chấp nhận là giới hạn kiến trúc host-app của gốc, không còn là lỗi
  phục hồi. Nếu gốc mượt hơn → tìm khác biệt thật trước khi sửa, không đoán cơ chế mới. Trước khi có
  bằng chứng này: **không mở thêm vòng chỉnh xoay**.
- **Nghiệm thu Weather (fixround7) — điểm bắt buộc của GPT, chờ phiên xe:** với quyền vị trí = 0, yêu
  cầu phải đi đúng nhánh dự phòng; không kẹt in-flight; yêu cầu tiếp theo vẫn hoạt động; mọi nhánh
  thành công/lỗi/timeout kết thúc giao dịch **đúng một lần**. Cấu trúc đã đạt ở mức tĩnh; xe là phán
  quyết. Kịch bản: đặt style thời tiết trước khi kết nối → kết nối (splash hoàn tất, không treo) →
  ngắt/kết nối lại (lần hai vẫn hoàn tất) → trả style Lời chào.
- **Để dành chưa diễn tập:** bài kiểm hết hạn (epoch 1809104400), cứu crash có chủ đích, kiểm tải.


## 7. Đang giữ và đang mở (toàn bộ, tính đến sau wake1)

**Đang giữ theo thứ tự đã chốt (không tự động vào bản):**
- Núm vách ngăn: ĐÃ SỬA ở wake1 (mục 5.4; `@(!scaled)` → `@(scaled)`, cổng object + FAT hai slice
  đạt) — chỉ còn chờ kiểm chứng trên xe trong phiên gộp wake1.
- Đuôi `!logoView` của playIntro phía xe: ba slot ivar 0xcb0/0xcc0/0xcc8 chưa ánh xạ đủ tin cậy;
  nhánh không tới được sau reload bình thường; số dump đầy đủ ở `work/fix-round4/fix-playintro.md`.
- **cellClass** (OMCFeatureStatusCell ở specifier Prefs): giữ nhãn **UNVERIFIED** — UUID của crash
  chưa ghép được đúng binary; không sửa dựa trên suy đoán (GPT đồng thuận).

**Đang mở:**
- **Pinch Fullscreen: BLOCKED tại cổng A1** (vòng wake1) — dylib fullscreen QA20 không có entry điều
  khiển hợp lệ từ ngoài (OMCToggleHost static, đúng một điểm gọi nội bộ; kênh chrome một chiều;
  không đường đọc expanded). Trong bản wake1 chỉ có recognizer + probe DRY_RUN + adapter rỗng khóa
  ENFORCE. Mở lại khi GPT phát hành dylib mới có entry + đường đọc trạng thái đã kiểm chứng (MD5
  mới, kiểm lại A1 từ đầu). Báo cáo: `reports/a1-fullscreen-entry.md`, PATCH_NOTES §22.3.
- **Wake Gate 2–6: chờ MỘT phiên xe gộp** (kịch bản trong ACCEPTANCE_WAKE1): dry-run đếm
  wouldSwallow/wouldPinch + phân loại phone, phân bố ba kết cục ack, kiểm núm, và nghiệm thu
  Weather của fixround7 gộp cùng phiên. ENFORCE của wake chỉ được bàn sau khi Gate 2 đạt.
- Bản sao Weather phía Prefs (`OMCCommon.m`) — module riêng, chưa rà theo cụm W (phát hiện ở vòng 7).
- SSSplash init: gốc đặt `contentView.userInteractionEnabled = YES` (@0x57d0); cây ghi NO kèm nhãn
  INFERRED — vi mục chờ xử lý.
- HSPreview: danh sách icon dải trái UNRECOVERED. prefsbubble: 1 điểm font INFERRED.
  SSFavIconForBundleID: trùng lặp static. pickAppForKey:title: còn lệch + frame nút sao chép section 5
  (audit D1–D4). D2: quan sát độ phủ section của reloadCard:. E2: đường URL cleanram + nhánh dispatch
  `feature` của Core còn INFERRED. §17G còn sót: quan sát cổng ss_drawCanvas; hai dòng nhà máy nhãn
  Prefs 147–148 INFERRED; kẹp maxWidth≤0 của ss_label.
- Thứ tự khai báo `_wetMask` trong header (trung tính về hành vi). Helper accent sub_24794: bằng chứng
  yếu hơn các mục khác (khôi phục từ giải mã của báo cáo tích hợp, không phải dump trong cây).
- 10 mục còn lại của audit điểm vòng 2 ngoài publishKnobsNow. Tham số OMCStyleHeaderFooter + 7 lệch
  chữ ký (danh sách §14). 52 lệch mã hoá kiểu lành tính (Expanded Audit của GPT), gồm kiểu trả về của
  ss_addCanvas (nội bộ, nhất quán phía gọi). Bảng ss_sceneColors chưa so trọn (style 3 ghi đè — không
  ảnh hưởng Weather).
- Các vụ tử vong oan `CarPlayTemplateUIHost` (shortcut-buttons.ips): chỉ xét lại nếu còn tái diễn.
- Các nhóm nghiệm thu §9 ngoài các phiên đã chạy; ba bài kiểm để dành ở mục 6.

## 8. Ảnh chụp trạng thái hiện tại (2026-11-09, ~13:45)

- **Bản đứng:** `com.anlai.omnicar_1.0.3-rebuilt-wake1-fat_iphoneos-arm64.deb` — 1.184.484 byte,
  SHA-256 `279005f45cb84d340e050461a46b4768fc4226c6edf80709af606004a9c3c2f1`; candidate local
  994.274 B `12d41e98…`; CI run dispatch **42573985624** success (workflow 410962367).
  Các bản trước: fixround7 `f2cc8ffe…`, fixround6 `0ce8a4f7…`, fixround5 `03010edc…`,
  fixround4 `6ab47eab…`, fixround3 `77230019…`, prefsround `44019c7c…`, gatefix `1132c3a8…`,
  arityfix `d61dc7ba…`. **Baseline rollback:** fixround7 FAT + gói hợp nhất QA20.
- **Git:** main — ship wake1 source `a907505`; ci-fat-test `21e1b95`.
  Log xe mới nhất trên repo: commit `9f20d83` (phiên fixround6, 878 dòng). Phiên wake1 chưa diễn ra.
- **Đã đóng trên xe:** thanh "..." hosted (fixround5). **Đã đóng ở tầng giao thức:** hai cổng hướng
  (log fixround6). **Đóng điều tra tĩnh:** fullscreen YouTube (mục 5.3). **Static PASS:** wake
  Gate 0/1 (PATCH_NOTES §22). **BLOCKED:** pinch tại cổng A1. **Chờ xe:** phiên gộp wake1
  (Gate 2 dry-run + kiểm núm) và Weather (fixround7).

## 9. Kỷ luật quy trình đã đúc kết từ dự án này

1. **Cực của nhánh quyết định là bệnh tái phát** (C-A, publishKnobsNow, hai cổng hướng — bốn lần đảo
   cực trong khi audit xung quanh đều "khớp"). Cổng kiểm phải truy vết cực của đúng nhánh quyết định
   so với dump; nhãn VERIFIED đặt trên nhánh chưa truy cực là nhãn sai.
2. **Truy vào thân helper dùng chung:** hằng ở điểm gọi khớp không minh oan được thân helper (bài học D6).
3. **Chỉ tin cổng đo trên DEB cuối cùng** và truy vấn trực tiếp (run ID/hash từ poll nền từng bị bịa).
4. **Ảnh/video là gợi ý để đọc log, không phải bằng chứng** — nhưng verdict của Nguyen trên media của
   chính anh đến nay luôn đúng; không được làm mềm các verdict đó.
5. **Ghi file dài theo đoạn nhỏ và kiểm lại** (sự cố marker "[truncated]" bị nướng vào file khi agent
   viết từ bản đọc bị cắt): sau mỗi lần ghi phải kiểm dung lượng + đuôi file + grep marker = 0.
6. **Một phiên test gộp cho mỗi bản**; báo cáo dùng "đã sửa và build" — "hoàn thiện" chỉ sau nghiệm thu.

---
*Hết mục tiếp tục. Khi có vòng mới: cập nhật mục 4 (dòng thời gian), mục 7 (mở/đóng), mục 8 (ảnh chụp)
và PATCH_NOTES như thường lệ.*
