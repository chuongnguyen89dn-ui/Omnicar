# TIẾP TỤC DỰ ÁN — OmniCar 1.0.3: phục hồi mã nguồn (clean-room reverse engineering)

> Mục tiếp tục dự án duy nhất của toàn bộ quá trình xây lại mã nguồn OmniCar 1.0.3 từ binary gốc.
> Cập nhật lần cuối: **2026-11-09, sau khi giao fixround7**. Bản đang đứng: **fixround7 FAT** (mục 8).
> Hồ sơ chi tiết theo vòng nằm ở `handover/PATCH_NOTES.md` (§1–§21), `handover/RECOVERY_STATUS.md`,
> `handover/ACCEPTANCE_*.md`; biên bản điều tra nằm ở cây làm việc `work/`. Tài liệu này là bản tổng hợp để
> bất kỳ ai (Nguyen / GPT / Muse) mở ra là nắm được toàn bộ trạng thái mà không phải đọc lại từ đầu.

---

## Phân công bổ sung GPT — 2026-11-09

Theo Nguyen: GPT trực tiếp triển khai icon của chính OmniCar trên lưới CarPlay Home trong cây recovered-source/, ở nhánh code riêng dự kiến feature/omnicar-home-launcher. Muse tiếp tục YTZ5 và tích hợp/build/ký một DEB cuối. Phân vai này bổ sung/thay thế vai trò chỉ-cố-vấn của GPT ở mục 1 đối với riêng phần Home launcher; không thay đổi quyền sở hữu phần Muse.

- Hồ sơ chuyên đề GPT: [gpt-project-history/README.md](gpt-project-history/README.md).
- Mục này chỉ lưu phân công và điểm tiếp nối; chưa tạo nhánh code, chưa sửa chức năng hoặc build. Đọc hồ sơ chuyên đề bản mới nhất để biết tiến độ; không suy trạng thái mã nguồn từ phân công.


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
- **fs1** (`5427920`; FAT 1.200.648 B, SHA `41bb5b8b…`, CI 42578683063): vòng TÍNH NĂNG trên nền
  wake1 — GPT **mở lại A1 theo phương án 2** cùng ngày: không chờ dylib mới của GPT nữa mà **tự dựng
  controller fullscreen** trong cây rebuilt (SCPFullscreenController là chủ duy nhất của snapshot +
  trạng thái expanded; adapter thành lớp chuyển tiếp thuần; đúng 1 dòng tham vấn tại return của
  `appAreaInParent:`; chrome ẩn bằng hàm nội bộ — `OMCChromeSetHidden` thuộc dylib QA20, cấm tham
  chiếu; dylib QA20 chỉ ở archive, không vào gói). Controller vòng này nghiệm thu qua **công tắc test
  `fullscreenTestExpand`** trong Prefs, pinch giữ DRY_RUN. Cộng **AutoHide** (lệnh gộp của Nguyen:
  ẩn hoàn toàn controls sau 4,0 s idle theo cơ chế mờ opacity của QA20 — chỉ `layer.opacity`, hit
  target còn sống — cho handle/divider/knob/logo và các gương phía host qua key `fade`/`kfade`; gói
  `act` mới trên bridgewake nuôi feed từ app hosted; HIDDEN của wake từ vòng này = barHidden ∧
  faded). Gate 1 PASS trên candidate (parity mất 0 so với cả r7 và wake1, 4 thân ABHost cấm sửa khớp
  hash, khoá pinch ENFORCE ở mức cấu trúc) và kiểm hai lát trên FAT đạt (kênh bridgewake 5/5, núm
  1 eor × 2 lát, parity vs FAT wake1 mất 0 ở cả 4 lát). **Đang chờ MỘT phiên xe gộp:** staging
  controller FS + 6 điểm đo AutoHide + Gate 2 wake + kiểm núm + nghiệm thu Weather của fixround7.
- **ytz1 — BẢN CÁCH LY, không giao** (vòng "nối pinch luôn" theo lệnh Nguyen 14:37: pinch mặc định
  ENFORCE, gỡ staging, YTZ mặc định BẬT; candidate 1.013.910 B, SHA `119d6108…`; source `0c5da2e`;
  FAT 1.210.344 B, SHA `4caa2568…`, CI 42581690791): fs1 lên xe cho hai phát hiện (nhóm TEST không
  hiện vì trang Prefs dựng bằng code không nạp plist; AutoHide mờ được nhưng gọi lại bằng chạm nội
  dung không được), rồi GPT kiểm toán source và kết án 3 lỗi — act bị cổng tươi state 2,5 s tự khoá
  đường gọi lại; pinch-in KHÔNG THỂ xảy ra (controller truyền `forBundle:nil`, arbiter đòi khớp
  bundle); isSplit của YT-Zoom suy từ số hosted pane nên sai ở split hỗn hợp. GPT không duyệt
  ENFORCE mặc định và ra WO khắc phục tổng hợp. Ghi đúng sự thật: lệnh dừng CI của ytz1 tới sau khi
  run đã dispatch nên FAT vẫn ra lò — nằm cách ly, bị ytz2 thay thế (PATCH_NOTES §24.1).
- **Chốt vai trò + ba quy tắc vận hành (trưa–chiều 09/11, khoảng 14:31–15:05) [ĐÃ CHỐT]:**
  (i) **Vai trò cuối:** GPT chỉ cố vấn/kiểm toán/phán quyết — KHÔNG thực thi; **Muse là người
  thực thi duy nhất**; Nguyen là người test xe duy nhất. Bản thảo/tóm tắt gửi GPT được giao
  **TRONG CHAT** — một tài liệu bàn giao từng được đẩy lên GitHub (commit `66efef2`) và bị Nguyen
  ra lệnh gỡ ngay (commit gỡ `f5f7e2f`); hồ sơ dự án vẫn lên GitHub như thường lệ, hai thứ tách
  bạch. (ii) **QUY TẮC MỘT DEB (Nguyen ra lệnh 14:39):** không giao deb lắt nhắt nữa — mọi mục
  đang chờ gộp vào ĐÚNG MỘT deb (anh nói rõ tải deb lắt nhắt rất mất công); từ đây mọi vòng đều
  giao một bản gộp duy nhất. (iii) **Lỗi công tắc prefs (phát hiện 14:31):** trang Chia màn
  hình được `OMCSplitScreenController` dựng 100% bằng code, không bao giờ nạp
  `FeatureSplitScreen.plist` — hai strand của vòng fs1 đã cộng công tắc test vào plist chết đó
  nên công tắc không hiện (chi tiết kỹ thuật ở PATCH_NOTES §24.1). Nguyen phản ứng với công tắc
  staging (14:35–14:37, "Mắc j nó phải qua công tắc?") rồi chọn "Bỏ staging, nối pinch luôn"
  (nguồn gốc của bản ytz1 trên); hệ quả về sau: GPT đưa pinch về **DRY_RUN** (P4) và chỉ giữ
  công tắc chẩn đoán trong bản ytz2. (iv) **Tăng agent song song (lệnh 15:05):** Nguyen ra lệnh
  tăng số agent làm việc đồng thời cho nhanh nhưng vẫn bảo đảm độ chính xác — mẫu áp dụng từ đó:
  các strand song song, mỗi agent một chủ file, kiểm độc lập riêng, một đầu mối đối hoà trước
  khi giao.
- **ytz2** (`a763030`; FAT 1.221.708 B, SHA `bb59ab56…`, CI 42583754018): vòng KHẮC PHỤC theo WO GPT
  trên nền fs1/ytz1 — 5 strand theo chủ file: phía app tách act khỏi độ tươi state (danh tính phiên
  đã xác thực + trói scene, suppression không đổi); phía owner thêm state renewal 1,0 s + log reason
  từng điểm loại act + arbiter EXPANDED **theo phiên** ở cả 3 điểm dùng (bắt thêm điểm promote) +
  pinch mặc định về DRY_RUN theo P4; nhóm **Chẩn đoán** dựng bằng code trong Prefs (công tắc
  `fullscreenDiagExpand` = đường kiểm thử controller độc lập + đường thoát không phụ thuộc
  recognizer; công tắc `youtubeVirtualize`; segment pinchMode 0/1/2); isSplit lấy từ trạng thái
  trình bày thật qua trường `split`/`splitver` trong hostFrameInfo; probe `sendEvent:` thụ động
  phía CarPlayApp để phân định đường chạm hosted. Hai lượt kiểm độc lập + kiểm độc lập YZ (4 hash
  cấm MATCH) đều đạt ở mức tĩnh; hiệu chỉnh quy ước đếm hook: call-site thật toàn module = 31
  (baseline 30, delta đúng +1 = probe) — con số "32" các vòng trước là đếm dòng grep gồm comment.
  Gate 1 PASS trên candidate và kiểm hai lát trên FAT đạt (3 khoá chẩn đoán nằm trong CODE của
  binary Prefs — đúng cổng fs1 đã fail; `fullscreenTestExpand` vắng toàn gói; núm 1 eor × 2 lát).
  **Phiên xe ĐÃ chạy** (log upload `0bf3273`, ba đội phân tích song song): YTZ **DEVICE PASS**
  (caveat: đối chứng OFF mới 0,5 s); wake hosted **PASS** đường activity/reveal (act 32/32,
  reveal 17/17); wake native **FAIL kết án** (fade → 16 + 25 Began trên ô native, 0 reveal —
  không agent trong process native); chuỗi 2-native là hậu quả của khe native chứ không phải lỗi
  gán ô; weather bị GPT thu hẹp phạm vi (riêng cửa sổ ytz2: 5 giao dịch warming); núm NO DATA;
  kết luận "guard tray chặn đúng" bị GPT bác bằng source và thu hồi (PATCH_NOTES §25.1–25.2).
  Vòng sửa sau log là ytz3 ngay dưới.
- **ytz3** (`36135b8`; FAT 1.224.728 B, SHA `c1872b93…`, CI 42590500247): vòng SỬA SAU LOG theo
  phán quyết GPT — 4 strand + 1 kiểm độc lập: (G) guard fullscreen đổi sang vị từ nội-dung-đang-mở
  (con trỏ tray/pickerSheet/ratioMenu nil-hoá đầu đường đóng; `trayOverlay` là cờ dính Panel.m:188,
  bị loại khỏi guard) + snapshot `snap{…}` ở 6/6 điểm từ chối; (NP) feed activity cho ô native tại
  CarPlayApp (quy đổi screen-space qua coordinateSpace có tên, cổng 7 nấc, gọi đúng đường F1
  `ahNoteActivity:` — không nuốt, không chặn chạm native) + đo tập touch `[touchset]` chống trùng
  cho quyết định kiến trúc pinch của GPT; gen của feed là epoch của probe (gen owner `bwGenBySlot`
  file-static không đọc được — kiểm độc lập phán rủi ro chức năng ≈ 0, đối chiếu chỉ bằng
  timestamp); (I) instrument `[applib]`/`[scenevis]` cho mất icon + ô trắng (đường Home thật ở
  SCPHooks/SCPAppIcons/SCPHomeApply — ngoài phạm vi vòng này, chỉ ghi vị trí); (W) instrument
  `[weather]` request→answer→display bằng 2 bộ đếm log-only req#/ans# (kênh request là notify
  trần, không mang id). Static PASS cả candidate lẫn FAT hai lát (parity SplitScreen +7/0 mất;
  hai strand instrument thuần cộng 163 dòng/0 xoá). **Phiên xe ĐÃ chạy** (16:18–16:50, log upload
  `9be396b`, ba đội phân tích B1/B2/B3 — phán quyết đầy đủ ở PATCH_NOTES §26): FS controller +
  guard **DEVICE PASS** (ca bắt buộc của GPT trọn 2 lần; 16 refusal đều state-based, reason
  tray/picker/popup = 0); feed native **DEVICE PASS** (fired 41, chuỗi quyết định 6/6 — khe
  native của ytz2 đã đóng ở tầng cơ chế); act hosted 26/26; YTZ **DEVICE PASS** + đối chứng OFF
  hợp lệ đầu tiên (11,121 s — bệnh gốc tái hiện trên đường gốc, cấp lại dọn residue 4→0);
  AutoHide khi EXPANDED **FAIL kỳ vọng của Nguyen** (0 fade / ≈961 s expanded — hai khoá treo đã
  chỉ đích danh, chờ GPT phán gỡ); Gate 3 còn duy nhất vật cản tín hiệu kb phía app (không xác
  định 38/38, wouldSwallow 0/38); bàn phím chốt Maps **native** (H2 chứng minh); touchset 62/62
  biểu diễn trùng; đầu đọc icon mù (live-grid-read count=0 ở 5/5); weather 0 request thật; PID
  CarPlay đổi 3 lần, 0 chữ ký crash. Sáu điểm chờ GPT ở PATCH_NOTES §26.10. ENFORCE (wake +
  pinch) vẫn đóng theo GPT.
- **ytz4** (`237098c`; FAT 1.229.512 B, SHA `53caff29…`, CI 42599165348): vòng SỬA THEO PHÁN
  QUYẾT GPT sau phiên ytz3 (PATCH_NOTES §27) — 4 strand + tích hợp + kiểm độc lập: (HB+K2) tín
  hiệu kb **ba trạng thái có nguồn xác thực** thay cho đề xuất bị GPT bác (bắt lỗi giặt nguồn:
  flag act ở `ABInApp.m:297` cho 0 cả khi Unknown, owner ở `BridgeWake.m:652–654` chỉ dùng lại
  flag đó — "kb=0 của owner" không phải phép đo độc lập): phía host, phiên phím hosted thật ở
  `ABKeyboardDispatch` funnel mọi mở/đóng qua `ABKbSyncNoteEvent` lên kênh mới
  `appbridge.kbsync` (hiệu chỉnh topo: hostFrameInfo do SCPCarSplit dựng, ABHost tiêu thụ —
  kb không đi qua đó; hostFrameInfo giữ 30 key); owner giữ bản ghi 3 trạng thái theo slot
  (reset UNKNOWN đúng hai điểm đổi assignment) và phát gói kb **type 6** (bit9=kbKnown,
  bit8=kbActive) chung token/seq với gói state; phía app `BWKbEffective` chỉ cho INACTIVE từ
  snapshot owner còn tươi (ngưỡng **3,5 s**), act-flag nay chỉ phát bằng chứng ACTIVE dương.
  Kiểm chéo layout ở tích hợp **KHỚP tuyệt đối** bằng C core dùng chung — hai bộ vector của
  hai strand chỉ khác tham số seq/gen; harness app 16/16. (HB) gỡ đủ **BA ràng buộc**
  AutoHide-EXPANDED: bỏ suspend trong `bwSetExpandedActive:`, bỏ hạng tử "expanded" trong
  `ahFadeBlockedReason`, bỏ phép nâng HIDDEN→VISIBLE trong `bwRecomputeForPane:` — điểm thứ
  ba chính là hạng tử mà phân tích vòng trước phán NGƯỢC (ghi thẳng trong §27.3); hosted-solo
  giữ nguyên; pinch-in giữ độc lập fade. (I2) instrument `[homelib]` trên đường Home thật:
  sự thật process là toàn bộ họ Home gated `SCPHostIsCarPlayApp()` — chạy trong **CarPlayApp,
  không phải SpringBoard** (mọi dòng in `proc=` tại runtime); OMNI miễn throttle. (Y2S)
  `[ytz-revoke-snap]` + `[ytz-nextlayout]` cho revoke YTZ — GPT chấp nhận đối chứng OFF (giá
  trị 4 là bệnh gốc trên đường gốc, không phải residue của YTZ) và KHÔNG cho layout cưỡng
  bức; `lastDecl=unavailable` là trường trung thực cố định. GPT cũng chốt: ca guard NGƯỢC
  (popup mở → expand bị từ chối kèm snapshot) là bắt buộc ở phiên ytz4; pinch hiệu chuẩn có
  chủ đích, chưa park; ngữ nghĩa fullscreen hiện tại (mặt split phủ kín, hai ô giữ tỉ lệ)
  GIỮ cho vòng này. Kiểm độc lập khẳng định (a)–(d) kèm **2 lệch phụ ghi nguyên** (§27.5):
  consumer `appbridge.keyboard` thứ hai ở `ABChannels.m:358` giải hash sai packing nên chết
  trong thực tế (rác tái tạo có từ trước — chờ GPT quyết dọn/giữ); reset UNKNOWN phía owner
  kích theo chuỗi bundle đổi (gán lại cùng bundle cùng slot không reset — giảm nhẹ: snapshot
  re-post khi app mở lại + hết tươi 3,5 s). Static PASS candidate + FAT hai lát (parity SS
  +3, AB +9, 0 mất). **Phiên xe CHƯA chạy** — kịch bản ở ACCEPTANCE_YTZ4 (fullscreen fade /
  ca guard ngược / chuỗi suppression mức wouldSwallow / hiệu chuẩn pinch / hồi quy). Gate 3
  vẫn ĐÓNG: sửa tín hiệu kb xong vẫn phải đo nuốt trọn chuỗi theo đúng lời GPT.
- **Phiên xe ytz4** (log upload `8db6471`; verdict đầy đủ PATCH_NOTES §28;
  analysis-ytz4-final + 4 strand ở handover/reports/): **CẢNH BÁO hai thế hệ binary trong
  cùng hai file log** — tag ytz4 chỉ xuất hiện từ CarPlay PID 35998 lúc 17:23:48, phần
  trước là binary cũ chữ ký ytz3; mọi verdict lấy phạm vi 17:23:48 → 17:44:31. **DEVICE
  PASS:** FS + ca guard NGƯỢC trọn (chuỗi 7 giây 17:28:14 → 17:28:20.989, snapshot
  `picker=1`; ON 9/OFF 10, expand/restore confirmed 3/3, refusal 13 state-based) — mục
  fullscreen đóng nghiệm thu; fade khi EXPANDED (E3 136,6 s fade+reveal khép; suspend
  tại expand 0/3 so với 13/13 ở ytz3); KB transport — giặt nguồn ĐÃ ĐÓNG (kbSrc=owner
  42/48 probe, kbAge max 3131 ms, 18/18 post mở/đóng khớp owner ≤3 ms) và wouldSwallow=1
  ×8 đúng tổ hợp known=1/active=0/owner/state=H; feed native hồi quy (fired 86, chuỗi
  14/14, act 54/54) + W2 xuất hiện lần đầu (stateage max 8092 ms, 12/54 ca >2500 ms);
  YTZ (ack 51/51, mask 24 lọt 0). **NO DATA:** chuỗi suppression trọn — thiếu đúng 3 mắt
  do thứ tự phiên (probe quyết định 17:32:24.119 xảy ra TRƯỚC khi phím mở
  17:32:24.190; cửa sổ overlap HIDDEN+kb ACTIVE 17:32:28–34 có 0 probe; gõ 0 dòng; sau
  đóng phím 0 probe cùng assignment) → Gate 3 chờ kịch bản phiên sau ép 3 mắt, không
  phải FAIL; OFF control YTZ (không tắt pref); pinch — hiệu chuẩn đánh dấu KHÔNG được
  thực hiện (0 episode ≥2 s), touchset 101/101 duplicate; weather/knob lần thứ ba
  (req# = 0, payload knob = 0); nguyên nhân chuyển PID (crash grep sạch). **Icon
  YouTube hai tầng:** trong-split CHƯA PHÂN ĐỊNH ở tầng cell dashboard (sơn mờ minh oan
  ở source theo probe-fade-icon; `[homelib]` youtube chỉ có inject 17:42:37, remove = 0;
  đường apply mù với app injected); sau-thoát — tương quan đường thoát KHỚP log trên 11
  sự kiện: ĐÃ MỜ ⇒ goHome=NO 5/5 (sự kiện mất icon 17:44:20.347 `goHome=0`), goHome=1 ⇒
  đang HIỆN 2/2, chiều ngược không tuyệt đối (4/6 HIỆN vẫn NO); cơ chế hạng 1 của
  probe-exit-fade (đường NO thiếu `SCPSendDashboardEvent(1)` ở `SCPCarSplit.m:1771` +
  không khôi phục sơn khi thoát) khớp log, nhưng bước dashboard làm rớt cell chưa chứng
  minh và event-1 là nguyên nhân hay dấu hiệu còn mở; thư viện KHÔNG bị kết án (0 chuyển
  1→0, decision cuối vẫn inject 17:43:41.217); phụ: `ahFadedState` rò phiên — khiếm
  khuyết riêng bán kính chrome, chờ duyệt sửa. **Phím tự vẽ ảnh 2→3: KẾT ÁN che khuất
  z-order** (giữa hai ảnh chỉ 1 hide 17:32:34.308, 0 show mới; khung đóng băng tại show
  theo probe-kb-frame). **Hai thay đổi theo lệnh trực tiếp của Nguyen chờ gộp deb sau**
  (§28.11): tấm nền bảng chọn app ở ô đích thành trong suốt khi ô có app (probe-picker-
  cover: `Picker.m:171–176`; gốc cũng trắng — customisation vượt gốc); cộng 1 dòng log
  rect phím tại show (carAppArea + panel frame — hiện không dòng nào ghi).
- **Diễn biến TRONG phiên ytz4 (17:20–17:31) — bối cảnh và lệnh picker [LỆNH ĐÃ CHỐT]:**
  sau khi nhận deb + kịch bản 5 bước, Nguyen hỏi làm rõ liên tiếp ("test mấy cái đó làm j
  vậy?", "Picker là cái j", "ca guard ngược (bắt buộc) này là j") — bài học ghi nhận: kịch bản
  phải viết bằng tên nút/thứ nhìn thấy trên màn xe, không dùng jargon. Ba mục 1/3/5 của kịch
  bản là dùng bình thường — log tự ghi; chỉ 2 việc chủ động: ca guard ngược (10 giây) và hiệu
  chuẩn pinch. **17:27 Nguyen chụp ảnh báo tấm nền chọn app phủ trắng ô đích** (ô YouTube
  hosted trắng trơn, ô GOFA vẫn hiện); **17:28 phép phân định đóng dấu X: app quay lại nguyên
  vẹn ngay** → chỉ bị che, scene không bị tháo. **17:30 LỆNH CỦA NGUYEN:** mở menu chọn app
  thì nội dung ô đích phải VẪN HIỆN như phía GOFA — điều tra chỉ-đọc ngay sau đó
  (probe-picker-cover, đã ghi ở §28.11): vùng trắng là `pane.picker`, gốc 1.0.3 cũng trắng
  (binary-verified) → lệnh này là customisation vượt gốc, sửa tối thiểu tại `Picker.m:171–176`.
- **Diễn biến TRONG phiên ytz4 (17:32–17:48) — dữ kiện gốc của Nguyen [DỮ KIỆN XE — verdict
  ở §28]:** **17:32–17:33 ba ảnh bàn phím** trong lúc tìm kiếm YouTube (phím lớn đúng thiết
  kế / phím nhỏ lệch phải / phím bị bó vào khung nhỏ giữa ô) + chất vấn "mỗi app mỗi giao
  diện phím", "bó không theo tỉ lệ chia ô", "càng làm càng gây lỗi" — kết án sau từ log:
  ảnh 3 là che khuất z-order (§28.6); đính chính của Muse: đã nói sai "log ghi khung phím"
  (không dòng nào ghi rect — đã grep khẳng định). **17:35 Nguyen chất vấn phím tự vẽ trong
  giao diện chia** → điều tra probe-kb-frame kết luận: ABKeyboard là MỘT đường duy nhất của
  ABHost cho mọi app hosted, solo và chia ô như nhau; SCPCarSplit không có đường phím riêng.
  **17:41–17:42 Nguyen báo mất icon YouTube trên thanh dock** (lần này là app hosted/được
  chọn, không phải hai app hệ thống như các lần trước); **17:44 anh quan sát trực tiếp:
  controls ẩn thì icon cũng ẩn theo, gọi lại logo thì icon hiện lại**; **17:48 phép A/B do
  anh tự đo: thoát Home lúc logo CHƯA ẩn → còn icon bên ngoài; thoát lúc ĐÃ ẩn → mất icon**
  — đây là dữ kiện gốc của Nguyen, là biến phân định sắc nhất của vụ icon; verdict đối chiếu
  log ở §28.9 (sau-thoát: ĐÃ MỜ ⇒ goHome=NO 5/5).
- **Thảo luận thiết kế bàn phím (17:58–18:00) [ĐÃ BỊ THAY THẾ bởi lệnh 18:01]:** trước lệnh
  chốt, Muse trình hai lựa chọn cho phím tự vẽ trong split — (a) bám theo ô của app đang gõ
  (khuyến nghị của Muse), (b) giữ nguyên gốc trải đáy cả hai ô — kèm trả lời hai câu hỏi của
  Nguyen: **app native KHÔNG vẽ phím được** (phím tự vẽ cần hợp đồng trong-app: tắt phím hệ
  thống + báo phiên nhập + nhận ký tự; app native không chạy thành phần đó, ô chữ thuộc
  template hệ thống của CarPlay); **phím tự vẽ thu nhỏ được** — chiều cao = 78% chiều cao cửa
  sổ xe, trần 280; bề rộng = vùng trừ 12, sàn 200. Toàn bộ thảo luận này bị thay thế bởi lệnh
  ngay sau đó, chỉ giữ làm bối cảnh quyết định.
- **Lệnh bỏ bàn phím tự vẽ (Nguyen, 18:01) [LỆNH ĐÃ CHỐT]:** không vẽ phím ở BẤT KỲ app nào
  — tất cả về phím gốc CarPlay/hệ thống; **code và dữ liệu phím vẽ giữ nguyên lưu lại khi
  cần**. Hệ quả đã nêu ngay lúc đó: nguồn bằng chứng kb của Gate 3 thay đổi (phiên phím host
  qua funnel sẽ câm). Lệnh này thay thế hẳn câu hỏi phím bám ô ở mục trên và mục "1 dòng log
  rect phím" của §28.11 chỉ còn ý nghĩa phục vụ đường lui.
- **Bản thảo gửi GPT (Muse soạn, 18:02) [ĐÃ GỬI TRONG CHAT]:** danh sách lỗi hiện tại
  L1–L7 (mất icon hai tầng; `ahFadedState` rò phiên; bỏ phím vẽ theo lệnh; tấm nền picker;
  chuỗi suppression thiếu 3 mắt; pinch NO DATA lần ba; weather/knob NO DATA lần ba) + hai
  lệch phụ §27.5 + phương án sửa của Muse cho từng mục + gói deb gộp đề xuất + 5 câu hỏi
  chờ GPT phán. Cấu trúc bản thảo: đã làm gì / kết quả / đang kẹt ở đâu — theo đúng chuẩn
  Nguyen đã chốt cho bản thảo gửi GPT.
- **Work order + ĐẶC TẢ THI CÔNG của GPT (18:10 + 18:13) [ĐÃ NHẬN — GO kèm đặc tả]:** gói
  sửa tổng hợp trên nền ytz4, 7 mục (vòng đời AutoHide bắt buộc; bỏ phím vẽ kèm sửa nguồn
  kb; nối nguồn kb vào AutoHide — lỗi đã có bằng chứng ở log 17:32:24.192/17:32:28.079;
  picker nhìn xuyên; icon chỉ instrument đúng tầng và **STOP event-1 ở đường goHome=NO**;
  consumer phím cũ bảo đảm bất hoạt; giữ ổn định FS/YTZ/feed native, pinch park, weather/knob
  PENDING) + nghiệm thu một phiên 6 bước đúng thứ tự; Wake ENFORCE chưa bật mặc định. Đặc tả
  thi công siết: lập bản đồ thay đổi TRƯỚC khi sửa; AutoHide sửa bằng cleanup vòng đời chứ
  không reset BOOL; bàn phím tách quyết định sản phẩm khỏi tính khả thi (phải báo trước build:
  phím hosted dự kiến hiện ở màn nào, căn cứ source nào, điểm nào chỉ kiểm được trên xe);
  AutoHide dùng cùng sự thật kb; icon chỉ đo + sửa lỗi vòng đời đã chứng minh; cổng trước
  build. **Hai điểm GPT sửa Muse:** (1) không giao thẳng cách nối nguồn kb mới khi chưa xác
  định nó quan sát được bàn phím hosted thực tế hay không; (2) chuẩn bằng chứng icon —
  "không có dòng remove" KHÔNG chứng minh toàn bộ thư viện vô tội, và `count=0` của reader
  không hợp lệ không phải bằng chứng icon bị xoá (câu "thư viện vô tội" trong §28.9 phải đọc
  trong giới hạn này).
- **Bản đồ thay đổi Pha 1 (18:21) [XONG — CHANGE_MAP_YTZ5.md + map-m1..m5 ở handover/reports/]:**
  phát hiện chính: điểm chèn cleanup AutoHide đúng là sau guard `SCPCarSplit.m:1733`, trước
  `hostCloseAll` :1737, cấm `ahRevealBody:` trên đường đóng; marker sở hữu inputView
  `ABBlankInputViewKey` đã tồn tại nên phục hồi chọn lọc làm được; **điểm đứt kb của ca 17:32
  chỉ chính xác** — owner ghi bản ghi theo slot (BridgeWake.m:323–325) nhưng cổng fade chỉ đọc
  biến toàn cục `ahKbHoldState/ahKbHoldExpiry` (AutoHide.m:140–157, grep `bwKb` = 0), act
  flag=0 của app A xoá vô điều kiện hold của app B, gen chỉ tăng khi chuỗi bundle đổi, chân
  host→owner của kb-sync không mang gen; bẫy picker: biểu thức hasContent phải chụp sau
  Picker.m:161 trước :162–163 (chụp tại :171 luôn YES oan cho ô trống); **trần đo icon =
  model/dock — cell của một bundle không đọc được ở cả 3 mốc**. Khả thi bàn phím tách 3 loại:
  source-proven (gốc chỉ suppress inputView, không đụng keyboard window); suy luận có căn cứ
  (scene qua `mainDisplaySceneManager` → phím hệ thống dự kiến hiện màn xe trong khung ô);
  chỉ-xe-mới-biết (iOS có dựng phím cho scene host chéo display không). **ĐIỂM VƯỚNG W1
  [lúc đó CHỜ PHÁN]:** tắt panel làm chết funnel — nguồn duy nhất nuôi bản ghi kb của owner —
  trong cây chưa có nguồn quan sát phiên nhập liệu nào khác; build ngay thì kb = UNKNOWN →
  AutoHide fail-open → bước 3 kịch bản GPT không đạt theo cấu trúc. Kèm W3 (pinch default
  trong source là DRY_RUN, khác chữ OFF) và W5 (cell vẫn mù).
- **Phán quyết của GPT (18:45) [ĐÃ CHỐT — GO thi công, không cần xin lại]:** chọn **W1(c)** —
  duyệt vận chuyển trạng thái **PHIÊN NHẬP LIỆU** từ app về owner (bản ghi theo từng
  assignment: bundle/hash + generation + source session + sequence + UNKNOWN/INACTIVE/ACTIVE;
  ACTIVE chỉ sau khi xác nhận nhận focus thành công; chuyển focus giữa hai ô nhập trong cùng
  app không tạo INACTIVE giả; INACTIVE chỉ từ xác nhận không còn phiên nhập trong phạm vi đã
  xác thực; không dữ kiện → UNKNOWN; **không log nội dung người dùng gõ**; observer cửa sổ
  phím chỉ là bằng chứng bổ sung, sự tồn tại của cửa sổ không phải bằng chứng ACTIVE). **W2
  khép cả đường đi:** owner cấp danh tính assignment hiện hành, app echo đúng danh tính đó;
  đóng rồi mở lại cùng bundle/cùng slot phải tạo generation mới; owner loại gói sai
  assignment/gen/source-session/sequence cũ và log reason; độ tươi neo vào **báo cáo của
  nguồn** — owner re-emit mỗi giây KHÔNG được gia hạn giả, nguồn hết hạn → UNKNOWN. Sửa câu
  kb-sync đóng: tắt panel chỉ **vô hiệu nguồn host-panel**, không kết luận phiên nhập của app
  đã kết thúc. Cổng `appBridgeNativeKeyboard` được duyệt nhưng **app nhận cấu hình qua
  bridge, không đọc trực tiếp CFPreferences**. M3: flag act mất quyền quyết định kb; UNKNOWN
  của assignment hosted **giữ controls hiện + ghi lý do** trong gói nghiệm thu này. M1:
  cleanup duyệt; solo đặt suspend SAU cleanup theo chế độ đích. Picker GO theo bản đồ (guard
  ô trống bắt buộc). Icon: log PRESENT-MODEL / ABSENT-MODEL / BLIND (không ghi PRESENT-CELL
  khi chưa đọc được cell); chưa thêm event-1. Pinch **mặc định OFF** (W3) và giá trị DRY_RUN
  lưu cũ không được âm thầm giữ pinch. Consumer phím trong `#if 0` giữ nguyên. **Bốn ca cấu
  trúc phải có bằng chứng trước build:** chuyển responder A→B cùng app; hai app cùng phiên
  nhập — đóng một không giải hold kia; gán lại cùng bundle/slot — gói phiên cũ bị loại; mất
  nguồn báo cáo → UNKNOWN, không gia hạn giả.
- **Nhắc hồ sơ + quy tắc vận hành mới (Nguyen, 19:00–19:05) [QUY TẮC MỚI — đã ghi §7]:**
  Nguyen phát hiện từ trưa nay chưa có commit lịch sử nào và ra lệnh bổ sung ngay, kèm hai
  chỉnh: lịch sử phải đọc ra được **từng mốc thành công cái gì / thất bại cái gì** (nhãn
  verdict tường minh theo mốc, không chôn trong câu văn); và phạm vi rà soát là **từ trưa nay
  tới giờ**, không chỉ từ commit gần nhất — đợt commit này là kết quả của lệnh đó (kiểm kê độ
  phủ ở báo cáo kèm commit).
- **Vòng ytz5 — trạng thái thi công [ĐANG THI CÔNG]:** đội thi công đang chạy theo hợp đồng
  giao thức kbstate (kênh object NSDistributed mới `com.anlai.omnicar/bridgewake.v1.kbstate`,
  lõi C99 dùng chung `BWInputStore.h` cho owner + harness, định dạng gói 64-bit KHÔNG đổi).
  Build/CI [CHƯA — chưa có candidate, chưa có SHA]; phiên xe nghiệm thu [CHƯA]. Chi tiết
  quyết định/phán quyết/bản đồ: PATCH_NOTES §29.

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


## 7. Đang giữ và đang mở (toàn bộ, tính đến vòng ytz5 đang thi công — sau phán quyết GPT 18:45 ngày 09/11)

**Quy tắc hồ sơ (Nguyen ra lệnh 19:00–19:05 ngày 09/11, sau khi phát hiện lịch sử chưa được
commit từ trưa):** MỌI cuộc làm việc liên quan tới chỉnh sửa hay quyết định về dự án đều phải
commit lịch sử **NGAY trong khối công việc đó** — không dồn tới cuối vòng; chỉ trao đổi thông
thường mới được miễn. Lịch sử phải đọc ra được **từng mốc thành công cái gì / thất bại cái
gì** — nhãn verdict tường minh theo mốc (DEVICE PASS / FAIL / NO DATA / ĐANG THI CÔNG /
CHỜ PHÁN), không chôn verdict trong câu văn.

**Đang giữ theo thứ tự đã chốt (không tự động vào bản):**
- Núm vách ngăn: ĐÃ SỬA ở wake1 (mục 5.4; `@(!scaled)` → `@(scaled)`, cổng object + FAT hai slice
  đạt) — chỉ còn chờ kiểm chứng trên xe trong phiên gộp wake1.
- Đuôi `!logoView` của playIntro phía xe: ba slot ivar 0xcb0/0xcc0/0xcc8 chưa ánh xạ đủ tin cậy;
  nhánh không tới được sau reload bình thường; số dump đầy đủ ở `work/fix-round4/fix-playintro.md`.
- **cellClass** (OMCFeatureStatusCell ở specifier Prefs): giữ nhãn **UNVERIFIED** — UUID của crash
  chưa ghép được đúng binary; không sửa dựa trên suy đoán (GPT đồng thuận).

**Đang mở:**
- **Pinch Fullscreen: phán quyết BLOCKED tại cổng A1 (vòng wake1) ĐÃ BỊ THAY THẾ (superseded)**
  bởi quyết định của Nguyen + GPT mở lại A1 theo phương án 2 (2026-11-09): không chờ dylib mới của
  GPT nữa — fullscreen được **tự dựng** thành SCPFullscreenController trong cây rebuilt (vòng fs1,
  PATCH_NOTES §23). Kết luận A1 về dylib QA20 giữ nguyên giá trị (vẫn không có entry hợp lệ; dylib
  chỉ ở archive, không vào gói nào). Pinch không còn BLOCKED: recognizer + adapter chuyển tiếp đã
  nối vào controller thật. Cập nhật sau fs1/ytz1/ytz2: vòng ytz1 từng nối pinch ENFORCE làm mặc
  định, nhưng GPT kiểm toán phát hiện pinch-in **chết hẳn** (arbiter đòi khớp bundle trong khi
  controller luôn truyền nil) — đã sửa arbiter theo **phiên fullscreen** ở cả 3 điểm dùng tại vòng
  ytz2 (PATCH_NOTES §24). Theo phán quyết P4 của GPT, mặc định trong bản ytz2 quay về **DRY_RUN**;
  ENFORCE mở qua segment Chẩn đoán trong cùng bản SAU khi controller qua nghiệm thu độc lập
  (bước 2–3 của ACCEPTANCE_YTZ2: controller đạt qua [fs-diag] + pinch-in thoát được trên cả hai
  loại ô + 1 lần ngắt CarPlay giữa EXPANDED sạch). Báo cáo nền: `reports/a1-fullscreen-entry.md`,
  PATCH_NOTES §22.3 (lịch sử), §23 (cách đóng mới) và §24 (sửa arbiter).
- **FS controller staging + AutoHide: phiên fs1 đã chạy dở và kết án hai lỗi** — công tắc test
  `fullscreenTestExpand` không bao giờ hiện (trang Prefs dựng bằng code, không nạp plist chứa
  specifier) và đường gọi lại controls sau khi mờ chết ở phía chạm nội dung. Cả hai đã sửa ở vòng
  ytz2 (nhóm Chẩn đoán dựng bằng code + đường [fs-diag]; act tách khỏi cổng tươi state + trói
  scene + state renewal — PATCH_NOTES §24). Nay chờ **MỘT phiên xe theo thứ tự 5 bước của WO**
  (kịch bản trong ACCEPTANCE_YTZ2). **Phiên ytz2 đã chạy:** bước 1 đạt phía hosted (act 32/32,
  reveal 17/17) nhưng FAIL phía native — mắt gãy nằm ngoài kịch bản gốc (không agent trong
  process native); bước 2 không chạy được vì guard chặn 100% (kết luận chặn-đúng đã thu hồi,
  §25.2). ytz3 đã sửa cả hai (guard vị từ nội dung + feed native tại CarPlayApp). **Phiên ytz3
  ĐÃ chấm lại: cả hai ĐẠT** — controller sạch DEVICE PASS (bước 1: ca bắt buộc của GPT trọn 2
  lần, refusal 16/16 state-based) và feed native DEVICE PASS (bước 2: chuỗi 6/6) — PATCH_NOTES
  §26.1–26.2. Điểm treo cùng cụm: AutoHide bị treo trọn khi EXPANDED (0 fade / ≈961 s expanded;
  hai khoá treo ở `SCPCarSplit+BridgeWake.m:331` + `SCPCarSplit+AutoHide.m:141`) — Nguyen yêu
  cầu logo/controls tự ẩn như ở split; chờ GPT phán gỡ cả hai khoá (§26.4, §26.10(ii)).
  **Cập nhật vòng ytz4:** GPT phán phải gỡ **BA** ràng buộc (khoá thứ ba là phép nâng
  HIDDEN→VISIBLE trong `bwRecomputeForPane:` mà phân tích vòng trước phán ngược) — **đã gỡ đủ
  ba ở ytz4** (PATCH_NOTES §27.3; hosted-solo giữ nguyên theo lệnh GPT; pinch-in giữ độc lập
  fade). Chờ phiên ytz4 chấm lại trên xe (ACCEPTANCE_YTZ4 bước 1: vào EXPANDED để yên ≥10 s,
  controls phải tự mờ; bước 2 là ca guard NGƯỢC bắt buộc của GPT — popup đang mở → expand bị
  từ chối kèm snapshot picker=1). **Phiên ytz4 ĐÃ chấm: cả hai DEVICE PASS** (PATCH_NOTES
  §28.1–28.2): ca guard ngược khép trọn 17:28:14 → 17:28:20.989 (snapshot `picker=1`,
  đóng hẳn thì expand confirmed) — mục fullscreen đóng nghiệm thu ở các ca đã chạy; fade
  EXPANDED chạy thật (E3 136,6 s fade+reveal khép; suspend tại expand 0/3 so với 13/13 ở
  ytz3). Cụm này ĐÓNG, trừ phát hiện phụ `ahFadedState` rò phiên ở §28.9 (bán kính chrome,
  chờ duyệt sửa).
- **Wake Gate 2–6: Gate 2 đã chạy ở phiên ytz2** — phía hosted đạt, phía native fail kết án;
  dữ kiện [probe] cho thấy CarPlayApp THẤY Began trên ô native (140 ca gán ô) nhưng nhãn scene
  không dùng được (117/140 foreign qua _UISystemGestureWindow) → **GPT đã phán W4: đặt feed
  tại CarPlayApp, khóa theo gán ô hình học** — đã cài ở ytz3 (PATCH_NOTES §25.3) và **phiên
  ytz3 ĐÃ chấm ĐẠT ở bước 2** (fired 41, chuỗi fade→Began→reveal trọn 6/6,
  PATCH_NOTES §26.2). ENFORCE của wake (Gate 3 — nuốt cú chạm đầu) vẫn KHOÁ theo GPT, nhưng vật
  cản nay thu về ĐÚNG MỘT điểm: tín hiệu kb phía app không xác định ở 38/38 dòng probe (owner
  ghi kb=0 ở 26/26 act-accepted; failopen kbunknown ×4 đều ở state=H) → wouldSwallow 0/38; độ
  tươi state không còn là vật cản (stateage max 987 ms; ca phân định W2 >2,5 s vẫn chưa từng
  xảy ra ở cả hai phiên). Chờ GPT phán §26.10(i) — gồm cả ca phím native vô hình với cổng
  (kb=1 không hề xuất hiện ở phiên ytz3). **Cập nhật vòng ytz4:** GPT đã phán (PATCH_NOTES
  §27.1(i)) — bác cả hai phương án vòng trước đề xuất (kb mặc định biết-0 phía app; chở kb của
  owner — phương án sau bị kết án GIẶT NGUỒN vì flag act cho 0 cả khi Unknown) và ra lệnh tín
  hiệu ba trạng thái có nguồn xác thực. **Đã làm ở ytz4** (§27.2): kênh `appbridge.kbsync` từ
  funnel của phiên phím host thật, bản ghi owner 3 trạng thái theo slot, gói type 6, phía app
  `BWKbEffective` + ngưỡng tươi 3,5 s + instrument kbKnown/kbActive/kbSrc/kbAge. **Gate 3 vẫn
  ĐÓNG** — nay chờ đúng một thứ: bằng chứng chuỗi suppression trọn (nuốt → chạm kế → nhập
  liệu → teardown) đo ở phiên ytz4 mức wouldSwallow (ACCEPTANCE_YTZ4 bước 3).
  **Phiên ytz4 (PATCH_NOTES §28.3–28.5): tầng transport ĐÃ ĐÓNG** — kbSrc=owner 42/48
  probe, kbAge max 3131 ms, 18/18 post mở/đóng khớp owner ≤3 ms; wouldSwallow=1 ×8 đúng
  tổ hợp; W2 xuất hiện lần đầu (stateage max 8092 ms, 12/54 ca >2500 ms; 8 ca dương đều
  trên state tươi). **Nhưng chuỗi trọn vẫn NO DATA, thiếu đúng 3 mắt do thứ tự phiên**
  (§28.4): probe quyết định xảy ra TRƯỚC khi phím mở; cửa sổ overlap HIDDEN+kb ACTIVE có
  0 probe; không có gõ chữ; sau đóng phím 0 probe cùng assignment. Gate 3 nay chờ kịch
  bản phiên sau ÉP 3 mắt đó (chạm trong lúc phím mở → gõ → đóng phím chạm lại) rồi GPT
  phán — mọi điều kiện tiên quyết khác đều đã có số đạt.
- **Điểm diễn giải vòng ytz2 đã ghi vào hồ sơ (PATCH_NOTES §24.5), không tự hoà giải:** điểm
  promote HIDDEN→VISIBLE dùng vị từ phiên dạng rút gọn (tương đương nhờ guard bao quanh); ca
  pane-bị-xoá-khi-expanded còn ranh giới phụ thuộc recompute đã chạy hay chưa (rơi về hàng SPLIT
  thường — hành vi cũ, ngoài bảng WO); mô tả điểm BWFresh :633 phía app đã sửa lại đúng cơ chế
  (hiệu chỉnh wouldSwallow khi wakeMode=Off).
- **ahForgetView: cho removeHomeButton** (vòng fs1 để ngỏ, PATCH_NOTES §23.7 mục 2): header của
  TU AutoHide không có method gỡ bản lưu opacity theo view; đánh giá rủi ro thực tế gần như
  không có (bản lưu chết theo view + registry yếu + nút luôn tạo lại qua refreshHomeButton đã có
  áp-lại sơn). GPT muốn khóa cứng thì thêm method kiểu `ahForgetView:` ở TU AutoHide.
- **Comment tồn dư trong SCPPinchController** (cổng 2, ~:590–594): vẫn mô tả adapter rỗng thời
  A1-BLOCKED trong khi code đã đọc trạng thái thật của controller qua adapter chuyển tiếp — chỉ
  chữ là cũ, code đúng; tác giả strand pinch/GPT cập nhật khi tiện.
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
- **Pinch sau phiên ytz2 — chết ở tầng HÌNH THÀNH CẶP, kiến trúc chờ dữ kiện:** mọi summary của
  recognizer đều complete=0 truncated=0 và probe phía app wouldPinch 0/124 — đường pinch không
  đi tới tầng phân xử. GPT hiệu chỉnh cách đọc: mỗi dòng chain của probe là thống kê của MỘT
  UITouch (không phải toàn gesture) nên "chuỗi đơn" không chứng minh vắng đa chạm; và có bằng
  chứng biểu diễn TRÙNG của một contact qua hai window (15:37:57.243/.246 cùng điểm {15,222.5})
  phải chống đếm trùng. ytz3 đã cộng phép đo `[touchset]` (tập touch theo con trỏ: window, điểm
  raw + screen-space, ô, event.timestamp); GPT quyết kiến trúc (ghép cặp tại CarPlayApp hay
  đường khác) SAU dữ kiện phiên ytz3. **Dữ kiện phiên ytz3 ĐÃ CÓ (PATCH_NOTES §26.7):** 62
  snapshot active=2 và 62/62 là biểu diễn TRÙNG của một contact (0 cặp evB khác nhau, 0 cặp hai
  điểm bắt đầu) — ghép cặp ngây thơ sẽ cho 62 pinch giả; khử trùng theo (evB + điểm bắt đầu +
  window) là điều kiện tiên quyết đã có số. Nhưng trong CẢ HAI phiên không ghi được một pinch
  hai-ngón-thật nào để hiệu chuẩn. **GPT đã phán (§27.1(vi)): hiệu chuẩn có chủ đích** —
  kịch bản đánh dấu (1 ngón yên / 1 ngón kéo / 2 ngón yên cùng ô / tách / chụm, mỗi động tác
  cách ~5 s) ở ACCEPTANCE_YTZ4 bước 4; chưa park, chưa đổi kiến trúc. Chưa recognizer trong
  app, ENFORCE vẫn đóng. **Phiên ytz4 (PATCH_NOTES §28.7): hiệu chuẩn đánh dấu KHÔNG được
  thực hiện** (0 episode chạm ≥2 s) — touchset vẫn 101/101 duplicate, mẫu thứ ba liên
  tiếp toàn trùng; kiến trúc vẫn chưa quyết được, chờ một phiên có hiệu chuẩn thật.
  **THAY THẾ bởi phán quyết GPT 18:45 (vòng ytz5): pinch PARK — mặc định OFF** (vắng pref →
  OFF; giá trị DRY_RUN lưu cũ từ các vòng trước không được âm thầm giữ pinch — áp cấu hình
  test có mục tiêu, không xoá toàn bộ prefs). Trạng thái "chờ hiệu chuẩn" ở trên KHÔNG còn
  hiệu lực: hiệu chuẩn không còn là việc chờ bắt buộc; kiến trúc vẫn chưa quyết (giữ nguyên
  kết luận dữ kiện), ENFORCE vẫn khoá, không ghép record trùng thành hai ngón.
- **Ba đề xuất chờ GPT sau vòng ytz3 (PATCH_NOTES §25.5):** (i) accessor gen chỉ-đọc trong
  `SCPCarSplit+BridgeWake.h` để feed native tương quan gen thật của owner (hiện dùng epoch của
  probe); (ii) vòng instrument/sửa tại đường Home thật — `SCPHooks.m` (hook
  `_newApplicationLibrary`/`_loadFromProxy:`), `SCPAppIcons.m`, `SCPHomeApply.m` — cho cơ chế
  mất icon OmniCar khỏi lưới gốc: log phiên ytz2 không chứa cơ chế này, ytz3 mới instrument
  phía picker/split + đầu dò `live-grid-read`, KHÔNG coi mất icon là tự khỏi theo sửa wake.
  **Cập nhật vòng ytz4: GPT ĐÃ DUYỆT mở phạm vi này** — instrument `[homelib]` đã vào ytz4
  trên đúng ba file đó (PATCH_NOTES §27.4; sự thật process: họ Home chạy trong CarPlayApp);
  phần SỬA cơ chế vẫn chờ dữ kiện `[homelib]` của phiên ytz4; **dữ kiện phiên ytz4 ĐÃ CÓ
  (PATCH_NOTES §28.9): thư viện KHÔNG bị kết án** — youtube 0 chuyển 1→0, remove = 0,
  decision cuối vẫn inject; mất icon sau-thoát tương quan với ĐƯỜNG THOÁT (ĐÃ MỜ ⇒
  goHome=NO 5/5 trên 11 sự kiện log; cơ chế hạng 1 probe-exit-fade khớp log) và tầng
  trong-split chưa phân định ở tầng cell dashboard — đường apply cũng mù với app
  injected (`SCPHomeApply.m:319–325`) nên bước tiếp cần instrument phía cell/apply cho
  app injected, hoặc GPT chấp nhận mức tương quan đường-thoát hiện có; **GPT ĐÃ PHÁN
  18:10–18:45: STOP event-1 (không gửi vô điều kiện ở đường goHome=NO — đường Home thật còn
  chạy handler gốc, chưa chứng minh cần thêm giao dịch); vòng ytz5 chỉ instrument ở tầng
  model/dock (log PRESENT-MODEL / ABSENT-MODEL / BLIND, gắn `src=` tại các điểm close) và
  sửa lỗi vòng đời AutoHide đã chứng minh TRƯỚC, rồi lặp lại phép A/B thoát-lúc-hiện /
  thoát-lúc-mờ; chỉ sửa cơ chế dashboard khi bắt được điểm cell mất hoặc không được dựng
  lại. Chuẩn bằng chứng cũng được GPT siết lại 18:13: "không có remove" không chứng minh
  toàn bộ thư viện vô tội; `count=0` của reader mù không phải bằng chứng mất icon**;
  (iii) chở generation qua notify state của kênh `weather.request` (hiện là notify trần không
  mang id; instrument ytz3 tương quan req#↔ans# theo thứ tự + timestamp — mẫu
  notify_register_dispatch/notify_get_state có sẵn ở kênh location cùng file).
- **Sáu điểm của §26.10 — GPT ĐÃ PHÁN SAU PHIÊN YTZ3 (PATCH_NOTES §27.1), trạng thái hiện
  hành:** (i) tín hiệu kb → Gate 3: bác cả hai phương án cũ (gồm kết án giặt nguồn), lệnh tín
  hiệu ba trạng thái có xác thực — **đã làm ở ytz4**; **phiên ytz4: transport DEVICE PASS
  (§28.3) nhưng chuỗi suppression còn thiếu 3 mắt NO DATA (§28.4)** — Gate 3 chờ kịch bản
  phiên sau ép 3 mắt đó; (ii) AutoHide EXPANDED: gỡ **BA** ràng buộc (không phải hai) — **đã gỡ ở
  ytz4**, **phiên ytz4 DEVICE PASS (§28.2) — ĐÓNG**; (iii) revoke YTZ: chấp nhận đối chứng OFF, **KHÔNG** layout cưỡng
  bức, chỉ cộng snapshot — **đã làm ở ytz4** (`[ytz-revoke-snap]`/`[ytz-nextlayout]`); R2 vẫn
  giữ nguyên trạng thái đã chỉ đích danh ở source, snapshot nay đo được cả cỡ nên phiên sau
  đối chiếu được; (iv) đường Home thật: **đã duyệt + đã instrument ở ytz4** (`[homelib]`,
  process = CarPlayApp); (v) pinch: **hiệu chuẩn có chủ đích** ở phiên ytz4 (kịch bản đánh dấu
  ở ACCEPTANCE_YTZ4 bước 4), chưa park, chưa đổi kiến trúc; (vi) ngữ nghĩa fullscreen: **GIỮ**
  mặt split phủ kín cho vòng này và ghi rõ trong hướng dẫn test — một ô bung kín là chức năng
  khác, chưa mở. **Hai lệch phụ mới chờ GPT (PATCH_NOTES §27.5):** consumer
  `appbridge.keyboard` thứ hai ở `ABChannels.m:358` chết trong thực tế (dọn hay giữ); biên
  reset UNKNOWN khi gán lại cùng bundle cùng slot (đóng ở tầng owner hay chấp nhận giảm nhẹ
  hiện có). Đề xuất §25.5(i) accessor gen vẫn mở (feed tiếp tục dùng epoch của probe);
  §25.5(iii): phiên ytz3 không phát sinh request weather thật nào (0 dòng req#) nên chuỗi
  request→answer→display vẫn chưa có bằng chứng dù instrument đã sẵn.
  **Cập nhật vòng ytz5 (lệnh Nguyen 18:01 + WO/đặc tả GPT 18:10/18:13 + phán quyết 18:45 —
  PATCH_NOTES §29; ĐANG THI CÔNG):** mục (i) bị thay thế ở tầng nguồn — tín hiệu kb của
  ytz4 (funnel phiên phím host) bị thay bằng **vận chuyển trạng thái PHIÊN NHẬP LIỆU
  app→owner (W1(c))** vì lệnh bỏ phím vẽ làm funnel câm; kèm W2 (identity/echo, gen mới
  khi gán lại cùng bundle/slot, độ tươi neo báo cáo nguồn). Mục (ii) cộng **cleanup vòng
  đời** ở đường đóng split (dừng timer, khôi phục sơn trước khi tháo view, reset trạng
  thái phiên; session mới bắt đầu VISIBLE) + cổng fade đọc bảng phiên nhập liệu theo
  assignment (flag act mất quyền quyết định; UNKNOWN của hosted giữ controls ở gói này).
  Bàn phím: **bỏ phím tự vẽ ở mọi app theo lệnh Nguyen** — một cổng thống nhất
  (`appBridgeNativeKeyboard`, app nhận cấu hình qua bridge), code phím vẽ giữ nguyên làm
  đường lui; phím hosted hiện ở màn nào là mục nghiệm thu riêng trên xe, không gọi là "đã
  về phím gốc" cho tới khi đo được. Mục (v) pinch: đã thay bằng PARK/OFF (xem bullet pinch
  ở trên). Consumer `appbridge.keyboard` trong `#if 0`: GPT chốt GIỮ NGUYÊN, không sửa
  packing; biên reset UNKNOWN cùng-bundle cùng-slot của §27.5 được đóng bằng cơ chế gen
  mới của W2 trong cùng vòng này.
- **Núm divider — verdict PENDING diện NO DATA:** log phiên ytz2 có 0 dòng payload
  publishKnobsNow/scaled= (mọi dòng "knob" là cặp fade AutoHide). Chờ GPT phán: khôi phục
  instrument payload hay chốt bằng quan sát xe (kịch bản ACCEPTANCE_YTZ3 bước 5 chấm quan sát).
  **Phiên ytz4 vẫn payload = 0 (lần thứ ba liên tiếp; 69 dòng "knob" toàn sổ fade)** —
  gộp vào quyết định chung với weather (instrument hay bỏ tiêu chí), PATCH_NOTES §28.10.
- Các nhóm nghiệm thu §9 ngoài các phiên đã chạy; ba bài kiểm để dành ở mục 6.

## 8. Ảnh chụp trạng thái hiện tại (2026-11-09, ~20:12)

- **Bản test đứng hiện hành:** `com.anlai.omnicar_1.0.3-rebuilt-ytz5hl1-fat_iphoneos-arm64.deb` — 1.245.714 byte,
  SHA-256 `e28883b97c68ce0d0d0341499a6c33a0d2b1d9b2f32ef0f2d308595178cad594`; CI run dispatch
  **42622552103** success (workflow 410962367) — bản tích hợp YTZ5 + icon Home (PATCH §29.9),
  CHƯA nghiệm thu xe.
  **Bản dùng hằng ngày của Nguyen vẫn là gói hợp nhất QA20** — ytz4 là bản nghiệm thu hiện hành.
  **Bản cách ly — không cài:** ytz1 FAT 1.210.344 B `4caa2568…` (CI 42581690791).
  Các bản trước: ytz4 `53caff29…`, ytz3 `c1872b93…`, ytz2 `bb59ab56…`, fs1 `41bb5b8b…`, wake1 `279005f4…`,
  fixround7 `f2cc8ffe…`, fixround6 `0ce8a4f7…`, fixround5 `03010edc…`, fixround4 `6ab47eab…`,
  fixround3 `77230019…`, prefsround `44019c7c…`, gatefix `1132c3a8…`, arityfix `d61dc7ba…`.
  **Baseline rollback:** ytz3 FAT + ytz2 FAT + fs1 FAT + fixround7 FAT + gói hợp nhất QA20.
- **Git:** main — source ytz5 `e6b50a4` + hồ sơ §29 tại `3e25499`/`cbdaeab`; nhánh
  `feature/omnicar-home-launcher` tip GPT `050eddb0`; nhánh `integrate/ytz5-home-launcher`
  tip `8a2c7aa`; ci-fat-test `b8deff2`; hồ sơ tích hợp §29.9 đi cùng commit này.
- **Vòng ytz5 + tích hợp Home launcher [ĐÃ XONG — PATCH §29.7 + §29.9]:** 4 strand song song theo hợp đồng
  giao thức kbstate (kênh object NSDistributed `com.anlai.omnicar/bridgewake.v1.kbstate` +
  lõi C99 `BWInputStore.h` dùng chung owner/harness; định dạng gói 64-bit không đổi): cổng
  bỏ phím vẽ + reporter phiên nhập liệu phía AppBridge; bản ghi kb owner + cổng fade đọc
  bảng phiên + cleanup vòng đời AutoHide + pinch OFF/migration + `src=` close phía
  SplitScreen; picker trong suốt; instrument icon tầng model/dock. Commit nguồn đi cùng
  đợt push này. **Candidate local:** `com.anlai.omnicar_1.0.3-ytz5_iphoneos-arm64.deb`
  1.036.636 B, SHA-256 `2d1cf435…`. **Harness 24/24 PASS; kiểm tĩnh PASS mọi cổng trừ
  parity** (mất đúng 1 method `bwHandleKbSyncNote:` — consumer kbsync cũ bị thay có chủ
  đích theo hợp đồng W2, coordinator đã miễn trừ tại §29.7, chờ GPT phán cuối). Commit
  nguồn YTZ5: `e6b50a4`. **TÍCH HỢP + DEB tổng hợp ĐÃ XONG (§29.9):** GPT bàn giao tip
  `050eddb0` (19:53); merge vào nhánh integrate `c74c878` (0 xung đột) + staging hai cây
  `74635d1` + fix nullability tích hợp `8a2c7aa`; kiểm tĩnh độc lập SHIP; CI run
  42622552103 success; DEB tổng hợp duy nhất ytz5hl1 FAT 1.245.714 B `e28883b9…`. (Run
  CI dispatch trước lệnh 19:15 — 42615117251 — vẫn không tính là bản bàn giao như đã ghi
  ở §29.7.)
- **Đã đóng trên xe:** thanh "..." hosted (fixround5); **YT-Zoom** (phiên ytz2 + đối chứng OFF
  hợp lệ ở phiên ytz3; ytz4 ack 51/51 giữ PASS); **wake hosted** đường activity/reveal (phiên
  ytz2); **wake native** qua feed CarPlayApp (phiên ytz3; ytz4 hồi quy PASS); **FS controller +
  guard** (phiên ytz3; **phiên ytz4 ca guard NGƯỢC đạt — mục fullscreen ĐÓNG**); **fade khi
  EXPANDED** (phiên ytz4); **kb transport ba trạng thái** (phiên ytz4 — giặt nguồn đã đóng,
  wouldSwallow=1 ×8). **Static PASS:** wake Gate 0/1 (§22); FS1 + AutoHide Gate 1 (§23); WO
  khắc phục (§24); vòng sửa sau log ytz2 (§25); phán quyết phiên ytz3 (§26); vòng theo phán
  quyết GPT sau ytz3 (§27); phán quyết phiên ytz4 (§28); bản đồ thi công ytz5 (§29).
- **GPT: KHÔNG còn mục chờ phán.** Toàn bộ danh sách mở của §28.12 + §27.5 đã được chốt ở
  work order 18:10 + đặc tả thi công 18:13 + phán quyết 18:45: Gate 3 chờ kịch bản ép 3 mắt
  ở phiên nghiệm thu ytz5 (định nghĩa lại theo nguồn phiên nhập liệu mới); icon — STOP
  event-1, instrument model/dock + sửa vòng đời trước rồi lặp A/B; pinch — PARK, mặc định
  OFF; `ahFadedState` — đóng bằng cleanup vòng đời của vòng này; weather/knob — giữ PENDING,
  không chặn gói UI, không xoá tiêu chí; consumer `appbridge.keyboard` chết — giữ nguyên;
  biên reset UNKNOWN cùng-bundle cùng-slot — đóng bằng cơ chế gen của W2.
- **Chờ theo thứ tự:** (1) ~~thi công ytz5 + harness + kiểm tĩnh~~ XONG (xem trên);
  (2) ~~GPT bàn giao icon Home → ghép → build MỘT deb gộp~~ XONG (§29.9);
  (3) MỘT phiên xe nghiệm
  thu 6 bước theo work order (vòng đời AutoHide → picker → phím hosted hiện/gõ/đóng + AutoHide
  giữ khi nhập → đường đánh thức sau đóng phím → A/B icon với instrument → hồi quy nhanh;
  nếu tiện: splash + núm cho hai mục PENDING); (4) Gate 3 vẫn **ĐÓNG** — Wake ENFORCE chưa
  bật mặc định, chỉ mở khi chuỗi suppression trọn + GPT phán.
- **Vẫn mở:** bước phía dashboard làm rớt cell icon chưa chứng minh (vòng này chỉ đo tới
  model/dock, cell không đọc được — không coi là đã tìm thấy điểm mất cell); phím hệ thống
  của app hosted hiện ở màn nào — PENDING-DEVICE, nghiệm thu riêng; nguyên nhân đổi PID giữa
  phiên (0 chữ ký crash — NO DATA); VISUAL_ORIGINAL_COMPARISON = PENDING.

**Cập nhật 20:34–20:41 (phiên xe ytz5hl1 — BÁO CÁO TẠI XE của Nguyen, LOG CHƯA UP):**
bước 1 icon Home **TẠM ỔN**; bước 2 vòng đời AutoHide **TẠM ỔN**; bước 3 picker nhìn
xuyên **THẤT BẠI** (chờ log `[picker] hasContent=` phân định nhánh); bước 4 phím gốc
hosted **THẤT BẠI** — phím không hề hiện trên màn xe (đúng tầng xe của khả thi 3 tầng
đã khai trước build; chờ log `[kbstate]` phân định); bước 5 reveal **ĐẠT**, nuốt vẫn
chế độ Đo; bước 6 A/B icon **TẠM ỔN**; bước 7 kịch bản viết chưa rõ nghĩa — lỗi trình
bày của Muse, mục phụ không chặn. Chi tiết đầy đủ: PATCH_NOTES **29.10**.
**Hai vấn đề/lệnh mới của Nguyen:** (a) gọi lại 1 chạm vẫn click app — Gate 3 chưa từng
được BẬT trên xe ở dự án này dù cơ chế có và wouldSwallow đo đúng 8/8 ở ytz4, mẫu QA180
của DuoFace đã đạt trên cùng xe; Muse đề xuất bật ENFORCE cho app hosted ở bản sau
(fail-open; native ngoài phạm vi kiến trúc) — **ngược phán quyết Gate 3 hiện hành, chờ
Nguyen chốt lệnh + GPT tham vấn**, chưa thi công. (b) PINCH — **ĐÍNH CHÍNH (Nguyen bắt
đúng, Muse nhận lỗi):** pinch ĐÃ thành công trên xe ở bản 21–35 (nền QA20) bằng
recognizer tuỳ biến TRONG app hosted; số touchset 101/101 "trùng" là **artefact vị trí
đo phía CarPlayApp** (1 chạm ghi ở 2 cửa sổ), không phải giới hạn màn xe; quyết định
PARK pinch + phép hiệu chuẩn đều dựa trên số đo sai vị trí này. Kế hoạch: recognizer
trong ABInApp (ô hosted) → tín hiệu về host → FS controller hiện có; chờ GPT phán điểm
giao tiếp (kênh tín hiệu, thứ tự với wake hook, hành vi khi controls ẩn/EXPANDED).
**Chờ:** log phiên (Nguyen up một lần) → phân tích picker/kbstate/home-launch/iconstate;
miễn trừ parity `bwHandleKbSyncNote:` vẫn chờ GPT phán cuối; weather/knob +
VISUAL_ORIGINAL_COMPARISON giữ PENDING.
**Cập nhật 20:43 (chẩn đoán pinch của Nguyen — PATCH §29.11):** nguyên nhân pinch chưa
thành công theo Nguyen là **app chạy quá nhiều** — hai ngón lọt xuống app hosted, app xử
lý cảm ứng riêng (cuộn/zoom) tranh chấp cử chỉ thay vì chuyển fullscreen sạch. Hai cơ
chế khắc phục chờ GPT tham vấn trước khi thi công: (1) **ngăn cảm ứng 2 ngón xuống app**
bằng recognizer trong app + `cancelsTouchesInView` (cơ chế đã thành công ở bản 21–35;
điểm chặn phải nằm trong tiến trình app vì chạm hosted đi đường scene, không qua
`sendEvent:` của CarPlayApp nên chặn ở host không nhốt được app); (2) **lớp phủ vô hình**
hứng chạm trước (nhận xét cơ chế chưa kết luận: phủ phía host không hứng được chạm của
scene hosted — khác tiến trình/render; phủ trong app hứng được cả chạm 1 ngón nên phải
tự chuyển tiếp, phức tạp hơn recognizer). Kèm chờ phán: thứ tự pinch vs wake-swallow tại
cùng điểm chạm + hành vi khi controls ẩn / đang EXPANDED.
**Cập nhật ~21:00 (phân tích log phiên ytz5hl1 — PATCH §29.12):** log đã up (commit
`5e745bc`), 5 strand phân tích + đối hoà xong (`handover/reports/analysis-ytz5hl1-final.md`).
Verdict log thay verdict miệng: bước 1 icon Home ĐẠT tầng log (11 chạm thật mở panel;
tầng model NO-DATA vì reader BLIND cả phiên — giới hạn W5); bước 2 vòng đời AutoHide ĐẠT
(thoát lúc mờ → mở lại hiện đủ, không rò faded-state); bước 3 picker THẤT BẠI ở **nhánh (b)**
— phép bắt occupancy đúng (hasContent=1 cả 2 lần mở), placeholder vô tội, lớp phủ là phần tử
khác: nghi phạm `pane.cover` (không có log) / shield popup (dựng đúng 2 mốc mở), cần 1 dòng
đo alpha/superview để kết án đích danh; bước 4 phím gốc hosted THẤT BẠI ở **nhánh (i)** —
cổng native xác nhận trên thiết bị, chuỗi kbstate KHÉP trọn vòng (accept 1.425/reject 5,
fade giữ đúng lúc ACTIVE), phím hệ thống **không dựng trên màn xe cho scene hosted** — tầng
xe, bridge vô tội. Gate 3: lần đầu có **4 ca would=1 sạch** ở điều kiện đầy đủ; tiêu chuẩn
"HIDDEN + kb ACTIVE" hoá ra bị chính thiết kế kb-hold chặn về cấu trúc (kb mở ⇒ controls
luôn hiện) — cần GPT phán lại tiêu chuẩn; 1 ca bất thường seq=45 nghi race với nhịp reveal.
GPT đã phán quyết Gate3/pinch/keyboard/picker ở commit `5ae47da` (trên báo cáo miệng);
§29.12 đã đối chiếu: log xác nhận hướng phím drawn, hai tiền đề (a)/(b) của Gate 3 đã có
trong log, điều tra picker đã có kết quả tầng log. Chờ: thi công theo phán quyết ở vòng
tiếp; miễn trừ `bwHandleKbSyncNote:` vẫn chờ GPT; weather/knob + VISUAL PENDING.

**Cập nhật vòng hl2 (sau lệnh Nguyen 21:11 — PATCH §29.13):** năm mảng theo phán quyết GPT đã thi công xong trong MỘT bản gộp: K6 phím tự vẽ về làm mặc định cho app hosted (kèm migration một lần cho pref cũ =1; native giữ opt-in; kbstate không đụng); P6 picker gắn đúng một dòng đo `[picker-measure]` (audit source không kết án được lớp phủ — shield bị bác, cover chưa chứng minh); F6 nhãn snap `to` sửa thành `trayOverlay` (cờ dính, không thuộc predicate); W6 pinch bằng recognizer thật trong app hosted + kênh relay scoped mới, owner validate rồi gọi FS controller sẵn có, legacy giữ khoá bằng tách pref; G6 Gate 3 mở ở phạm vi THỬ đúng một bundle (YouTube) qua packet theo pane, toàn cục vẫn DRY_RUN, hai kill-switch pref. Hai sửa thẳng hàng của coordinator khi tích hợp: kb UNKNOWN phải chặn pinch (ruling §1) và đồng hồ trường `t` của relay pinch (app uptime vs owner epoch — lệch là mọi relay bị reject stale). Phát hiện cấu trúc: merge tích hợp ytz5hl chưa từng về main — đã merge `711f89a` (0 xung đột), từ nay main là cây tích hợp đầy đủ. Nhánh dock-retirement của GPT (`39a42f2`) được ghép SAU 5 mảng theo đúng thứ tự Nguyen dặn: cherry-pick sạch `76538c2`, parity miễn trừ rỗng (loại bỏ bằng cổng, không xoá code). Sự cố đã ghi nguyên trạng ở §29.13: output exec nền bịa kết luận CI (đã bác, chỉ tin foreground); run CI đầu bị GitHub huỷ khi kẹt queued đúng 15 phút; re-dispatch `42637337416` SUCCESS 9/9; rollback /usr giữa phiên làm mất clang/llvm (phép kiểm lát FAT làm bằng parser Python + capstone, positive control ytz5hl1). Sản phẩm: `com.anlai.omnicar_1.0.3-rebuilt-hl2-fat_iphoneos-arm64.deb`, 1.252.660 B, SHA-256 `9250ea0108ebd59b07b49ebf7d9cb07c4c6debbf4ef6932ed935ac740fd403b2`, knob đúng 1 eor ở cả hai lát. Trạng thái: source-complete / static PASS / local-build PASS / CI FAT PASS — chờ đúng MỘT phiên xe gộp (kịch bản ở cuối §29.13).
**Cập nhật ~22:19 (phiên xe hl2 — BÁO CÁO TẠI XE của Nguyen, LOG CHƯA UP — PATCH §29.15):**
ba verdict mức màn hình trên bản hl2 (`9250ea01`): (1) **Picker THẤT BẠI tiếp có phân định
mới** — mở menu vẫn ẩn nội dung ở app KHÔNG hỗ trợ CarPlay (hosted), app native thì bình
thường; dòng `[picker-measure]` chờ log kết án lớp phủ. (2) **Gate 3 trial YouTube THẤT
BẠI** — chạm gọi logo vẫn dính app, video YouTube bị phát, cú chạm không bị nuốt dù ô
YouTube thuộc phạm vi thử ENFORCE; chờ log phân định (mode của ô / điều kiện phía app /
fail-open nào đã mở). (3) **Pinch RẤT KHÓ nhận** — rất nhiều lần mới zoom RA được 1 lần
(tổng 1–2 lần chiều bung), zoom VỀ không được lần nào; nguyên nhân chưa rõ, chờ log
`[pinch2]` phân định (ngưỡng quá khắt khe với đường chạm CarCast / đường chụm vào lúc
EXPANDED bị chặn oan / tín hiệu bị owner loại hoặc FS từ chối thu). Hệ quả quy trình:
**hl3 GIỮ dispatch CI** — chờ log phiên hl2 để gộp fix pinch + Gate-3 theo bằng chứng vào
CÙNG bản hl3, vẫn một deb giao xe.

**Cập nhật vòng hl3 (lệnh Nguyen 22:14 — PATCH §29.14):** cổng phím đã lật về NATIVE KHOÁ CỨNG cho app hosted (commit source `5eac902`): host không còn đọc pref, migration hl2 bị xoá và marker của nó vô hiệu, payload luôn drawnKeyboard=0 (mode=native-locked-hl3), phía app khôi phục mặc định native của ytz5 và bỏ qua mọi payload drawn=1. Đây là lệnh trực tiếp của Nguyen GHI ĐÈ phán quyết drawn-mặc định của GPT và mảng K6 của hl2; hệ quả native không hiện phím cho app hosted (đã chứng minh ở §29.12) là điều Nguyen đã biết và vẫn chốt — quyết định của chủ dự án. kbstate giữ nguyên; pinch/Gate-3/picker/dock của hl2 không đụng. Trạng thái: source-complete — ĐÓNG GÓI GIỮ LẠI theo lệnh 22:19+ (sự cố điều phối: sync ci-fat-test + dispatch đã chạy lúc 22:19:14, ngay trước khi lệnh giữ tới; artifact không tải, không giao — chi tiết ở §29.14). Chờ fix pinch/Gate-3 theo log phiên hl2 gộp vào cùng build hl3 rồi mới dispatch lại — vẫn một deb giao xe.

**Cập nhật 22:21 (đối chiếu pinch hl2 vs bản thành công 21–35 — PATCH §29.16):** Nguyen hỏi
"Có làm đúng với bản thành công trước đây không?" — trả lời: **KHÔNG**. Pinch hl2 khác mẫu
21–35 ở 4 điểm cốt tử: (1) kích hoạt chờ ngưỡng tỉ lệ khoảng cách 1.10/0.90 + điều kiện
mid-drift thay vì **Began ngay khi ngón thứ hai chạm**; (2) thông số lấy từ
SCPPinchController của bản gốc 1.0.3 thay vì dùng cơ chế đã chứng minh làm đặc tả; (3) thêm
cổng chặn (SPLIT+HIDDEN không bao giờ nhận, kb UNKNOWN chặn, owner validate 6 lớp) trong
khi bản thành công gần như không có cổng giữa ngón chạm và hành động; (4) phân hướng theo
hình học cử chỉ (tách = bung, chụm = thu) thay vì **toggle theo trạng thái fullscreen hiện
tại** — hỏng lệch một chiều đúng triệu chứng phiên xe hl2 (bung 1–2 lần, thu 0 lần). Kết
luận ghi hồ sơ: **lỗi chọn sai mẫu thiết kế khi thi công hl2**, dù Nguyen đã chỉ đúng mẫu
21–35 lúc 20:39 cùng ngày; không phải giới hạn xe/phần cứng. Hướng sửa đã chốt: làm lại
pinch theo mẫu 21–35 (Began khi ngón 2 chạm + cancelsTouchesInView + toggle theo trạng
thái; bỏ ngưỡng khỏi điều kiện kích hoạt), gộp vào hl3 đang giữ CI cùng sửa cổng phím;
picker + Gate-3 trial vẫn chờ log phiên hl2 phân định.

**Cập nhật 22:24 (đối chiếu wake OmniCar vs DuoFace QA180 — PATCH §29.17):** Nguyen chất vấn: gọi logo 1 chạm qua bao nhiêu vòng rồi chưa xong; DuoFace rất khó mà đã làm được; có làm đúng mẫu DuoFace không. Trả lời đã xác minh: chuỗi vòng là wake1 → ytz1–ytz5 → ytz5hl1 → hl2 trial; phần **HIỆN logo đạt từ lâu**, phần **NUỐT chưa từng đạt trên xe** ở dự án này (4 phiên DRY_RUN có ca dương tính; hl2 là ENFORCE thật đầu tiên, chỉ 1 app, và thất bại mức màn hình). Khác QA180 `h1wake3` (đã đạt trên cùng xe, 12 swallowed=1) ở 2 điểm cốt tử: (a) QA180 host **ĐẨY hidden/shown ngay khi đổi** qua Darwin, app giữ biến local, **không có khái niệm độ tươi**; BridgeWake đóng gói định kỳ + freshness/gen/seq nên app có lúc quyết trên trạng thái cũ (các ca would=0 vì stale ở mọi phiên). (b) QA180 đọc điều kiện phím **tại chỗ trong app** (`!kbSession` của chính nó); OmniCar cho sự thật phím **đi vòng app → host → owner → gói type-6 → app** — laundering/gen/stale của ytz2–ytz4 đều sinh ở vòng này; kbstate (ytz5) sửa được nguồn đo nhưng đường nuốt vẫn qua owner. Hệ quả quy trình: QA180 chốt xong mở cổng đo trên xe; bên này giữ DRY_RUN vì chuỗi bằng chứng của giao thức tự sinh không khép. **Lệnh tái cấu trúc đã chuyển vào build hl3 đang giữ CI:** đẩy hidden/shown + biến local phía app (bỏ freshness khỏi đường nuốt); điều kiện phím lấy trực tiếp từ reporter kbstate tại chỗ trong app (owner/kbstate giữ cho AutoHide + chẩn đoán); ENFORCE giữ phạm vi trial hosted + kill-switch.

**Cập nhật 22:29 (phân tích log phiên hl2 — PATCH §29.18):** Đội 5 strand + đối hoà xong (biên bản `handover/reports/analysis-hl2-final.md` + s1–s5). **Gate-3 kết án đích danh:** cú chạm lọt tại cổng app vì veto freshness `stale` (4 episode 1-ngón, age 2605–9009 ms; wouldSwallow 0/157, nuốt thật 0) — host cấp ENFORCE và packet tới app đều vô tội; đúng điểm hl3 (`45e629b`) đã gỡ, log ủng hộ trực tiếp. **Pinch giải phẫu xong:** 165 cặp, bung trọn đường 4 lần (miệng nói 1–2 — log thắng), thu 0 lần chết 100% tại recognizer vì nhãn committed phía app không theo FS thật (76 wrong-dir đều ở cửa sổ EXPANDED mà committed vẫn `split`; 13 badstate cùng gốc; owner/FS không nghẽn) + 65 cặp (39%) chết lúc formation vì stale — mục sau **chưa xác nhận hl3 đã gỡ ở đường pinch** (L4), phải kiểm trước đóng gói. **Picker:** dòng đo chụp TRƯỚC trình bày (picker super=nil, trayWin còn ẩn) → không kết án được lớp phủ; hasContent vô tội lần 3; phải gắn đo lại sau trình bày (L5/L6). **Phím drawn ở hl2 vận hành sạch** (panel 3/3, kbstate khép, AutoHide giữ đúng) — log không kết án drawn; về native là lệnh 22:14 của Nguyen. Hồi quy AutoHide/YTZ/feed/Home/dock đều LOG-CONFIRMED; snapshot app tụt seq (L7) và heartbeat hậu-teardown 291 reject (L8) ghi vào danh sách. Danh sách lỗi đầy đủ **L1–L10** ở §29.18 là đầu vào soạn cho GPT tham vấn hướng khắc phục.

**Cập nhật bổ sung build hl3 (lệnh 22:22 + 22:24 — PATCH §29.14 bổ sung, đối chiếu §29.16/§29.17):** hai làm lại đã gộp vào build đang giữ. (1) PINCH theo đúng mẫu 21–35 (commit `0df7e0f`): xoá engine ngưỡng tỉ lệ/drift khỏi đường kích hoạt (hl2 chọn sai mẫu — xe hl2: out 1–2 lần, in 0 lần), recognizer bắn toggle NGAY TẠI BEGAN theo trạng thái committed (SPLIT→bung, EXPANDED→thu); bất biến GPT + trọng tài cặp + owner giữ nguyên. (2) WAKE về dạng QA180 h1wake3 (commit `45e629b`, chỉ phía app): host đã phát change-driven nên không sửa; cổng nuốt quyết định bằng trạng thái ĐÃ CHỐT từ lần đẩy + kb LOCAL first-hand — bỏ veto freshness và đường kb đi vòng qua owner khỏi quyết định (nguồn gốc của mọi ca stale/laundering các phiên trước); thực thi ENFORCE đọc mode đã chốt của gói, phạm vi trial YouTube không đổi; query giữ làm tự lành; probe ghi `dsrc=local-push`. Trạng thái: source-complete — ĐÓNG GÓI VẪN GIỮ, chờ Muse chính chốt sau chẩn đoán Gate-3/picker từ log hl2.

**Cập nhật sửa L4 (kiểm pinch còn cổng freshness — PATCH §29.19):** kiểm source hl3 xác nhận **CÓ**: trọng tài cặp pinch `ABPinchPairDecision` vẫn giữ veto `!BWFresh()`/`!BWKnown` + kb qua đường vòng `BWKbEffective` nguyên văn từ hl2 (việc làm lại `0df7e0f` không đụng tầng này) — đúng cơ chế giết 65/165 cặp ở formation (§29.18 L4). Đã sửa (commit `dcafe71`, chỉ `ABInApp.m` × 2 cây): bỏ hai veto, quyết định theo **latch tại chỗ** như đường nuốt sau `45e629b`; "known" = danh tính thuần, reason mới `latch-missing`; kb đổi nguồn sang **`BWKb` local** nhưng **giữ bất biến GPT** (ACTIVE chặn, UNKNOWN vẫn chặn — chỉ đổi nguồn, không đổi luật). Kiểm tĩnh: thân hàm 0 lời gọi `BWFresh(`/`BWKbEffective(`; build cục bộ PASS, discriminator có trong binary. **ĐÓNG GÓI VẪN GIỮ** — chờ gộp nốt L5/L6 (picker) + L8 theo §29.18.

**Cập nhật 23:26+ (hoàn thành hl3 không chờ GPT — PATCH §29.20):** GPT lỗi hệ thống đợt này; Nguyen lệnh Muse tự quyết hai điểm treo và hoàn thành deb trong phiên. (1) **L5/L6 picker:** phép đo gắn lại **SAU trình bày** — `[picker-measure2]` `phase=presented` ở cuối `buildPickerSheetForPane:` + `close-choose`/`close-cancel`; chỉ đo, `[picker-measure]` cũ giữ nguyên làm bản ghi điểm bắt; giả thuyết chờ số: tray window toàn màn (640×360, level ≈1065) nếu mang nền đặc sau khi hiện sẽ che đúng vùng ô hosted (nội dung hosted composite trong bề mặt host), scene native render riêng nên thoát. (2) **L8:** gộp sửa — `BWKbReporterLive` dừng reporter khi mất assignment (clear ở `BWResetAll` hoặc khi state im lặng > 5 s trong heartbeat; hồi sinh khi state packet được chấp nhận), funnel post duy nhất, owner không sửa; kỳ vọng reject `noassignment` sau tháo ô ≤ ~5 (so với 291). Kiểm toàn diện độc lập **10/10 PASS** (parity vs hl2 mất đúng 1 method có miễn trừ §29.14; knob `publishKnobsNow` đúng 1 eor #1 cả cục bộ lẫn đối chứng ytz5hl1; launcher 10/10 hai phía). Commit nguồn `eb92411`. Đóng gói: sync ci-fat-test từ `eb92411` và dispatch lại — run dispatch sớm 22:19 (`42643457617`, từ main cũ `fc88f38`) artifact **không dùng**; kết quả CI/FAT ở §29.20 bổ sung.

**Cập nhật 06:41+ 10/11 (hl4 — gỡ lớp trọng tài pinch về mẫu 21–35 — PATCH §29.22):** Nguyen lệnh "làm giống" = giống hệt cơ chế thành công: hl3 vẫn giữ hàm trọng tài cặp `ABPinchPairDecision` không có ở bản 21–35 — điểm sai kỳ này. Đã sửa (commit nguồn `c9a2a1f`): XOÁ HẲN hàm trọng tài khỏi source (recognizer là caller duy nhất), recognizer bắn tín hiệu **toggle dir=0** ngay tại Began (payload giữ hash/gen/session/seq cho owner validate vận chuyển; đường phát không còn điều kiện nào), owner `bwHandlePinchNote:` lật `SCPFullscreenAdapter` theo `currentState` thật (log `toggle-applied from=…`); `badstate` cho dir=0 chỉ còn nghĩa currentState Unknown. Kiểm tĩnh + build cục bộ hai module PASS, discriminator binary đạt cả hai phía. ĐÓNG GÓI GIỮ — deb hl4 chờ Muse chính chốt gộp (log hl3: picker + rà nuốt).

**Cập nhật 06:36 10/11 (phiên xe hl3 — BÁO CÁO TẠI XE của Nguyen, LOG CHƯA UP — PATCH §29.21):** bản hl3 (SHA `6fe29160`) đã test xe, verdict mức màn hình: (1) **Gọi logo/NUỐT trên YouTube HOẠT ĐỘNG** — lần đầu tiên phần NUỐT đạt trên xe ở dự án này (cổng latch + kb local dạng QA180, trial YouTube); chờ log đếm swallowed + kiểm nuốt nhầm. (2) App hosted khác vẫn bị click vào app — đúng phạm vi trial (chỉ YouTube ENFORCE); điều kiện mở rộng ENFORCE cho mọi hosted đã đủ theo lộ trình, chờ kiểm nuốt nhầm từ log trước khi mở. (3) **Pinch THẤT BẠI tiếp** — rất khó dùng, bung đúng 1 lần, thu 0 lần; lệch một chiều lặp lại dù đã Began-trigger + gỡ freshness (L4); nguyên nhân chưa rõ, chờ census `[pinch2]` trong log. (4) Phím không hiện ở app không hỗ trợ CarPlay — hệ quả đã biết của lệnh khoá phím gốc 22:14, không phải hồi quy; mục cơ chế vẫn mở (tham vấn Phần 3 mục 4). (5) Picker vẫn che nội dung ô hosted — `[picker-measure2]` sau-trình-bày trong log phiên này là bằng chứng chờ đọc để kết án lớp phủ. Trạng thái chờ: Nguyen up log hl3 → phân tích 3 lát (pinch census / picker measure2 / wake swallowed + nuốt nhầm) → hồ sơ đối chiếu.

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

**Cập nhật 10/11 (phân tích log phiên hl3 — ĐÃ ĐỐI CHIẾU LOG — PATCH §29.23):** đọc trọn 6.891 dòng hl3 (file .log nhỏ là đoạn cuối sau xoay log, không mất đoạn). **Nuốt YouTube ĐẠT ở mức log: 12 ca swallowed, nuốt nhầm = 0 → ĐIỀU KIỆN MỞ RỘNG ENFORCE CHO MỌI APP HOSTED ĐẠT** (5 ca Facebook would=1 đang bị giữ ở DRY_RUN); vết kèm L1 ack timeout 7/12 ở PID re-host + L2 latch tụt tối đa 18 seq. **Pinch kết án 2 tầng:** YouTube chết 100% tại cổng kbunknown của trọng tài (7/7 cặp); chiều thu chết 100% tại owner badstate vì nhãn committed không bao giờ lật EXPANDED (52/52 dòng = split, reject 25/26) — cả hai đang sửa ở hl4 §29.22, chờ phiên sau kiểm chứng. **Picker vẫn NO-DATA kết án:** measure2 giống hệt hosted/native, trayWin bg alpha=0 (giả thuyết nền đặc bị bác); thiếu bg của sheet — ứng viên duy nhất còn đứng — chờ GPT phán phép đo bổ sung. kbstate: reject 291→12 (L8 đạt), nhưng reporter-stop dừng sớm oan 16/19 (L7). Hồi quy sạch: restored 29 ms sau thoát-mờ, act lệch 0, không đổi PID, weather/knob NO-DATA phiên 5.

---
*Hết mục tiếp tục. Khi có vòng mới: cập nhật mục 4 (dòng thời gian), mục 7 (mở/đóng), mục 8 (ảnh chụp)
và PATCH_NOTES như thường lệ.*
