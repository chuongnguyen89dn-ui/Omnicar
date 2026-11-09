# Điều tra — cơ chế ZOOM của YouTube (fullscreen trong player): phía app, phía OmniCar, bản đồ hàm

Chỉ-đọc. Nguồn: `work/fix-round5/audit-zoomrotate.md`, `audit-zoomtiming.md`, `audit-inapphook.md`;
PATCH_NOTES §20; dump gốc AppBridge (hai phía) + source `project/OmniCarAppBridge/ABInApp.m`,
`ABHostBMethods.m`, `ABHostGeometry.m`, `ABChannels.m`; log phiên fixround6
(`work/device-log-20261109-fixround6/session.txt`).

Quy ước bằng chứng: mọi khẳng định phía OmniCar đều có offset dump. Phía YouTube: app là binary
đóng, không có trong cây — phần "app làm gì" suy từ **bề mặt bridge nhìn thấy được** (hook nào bắn,
dòng log nào phát) và ghi rõ chỗ nào là suy luận về nội bộ UIKit/app.

---

## 1) Phía YouTube (app): bấm nút fullscreen trong player thì xảy ra gì

### 1.1 App không tự xoay gì cả — nó *tuyên bố* ý muốn hướng

Khi người dùng bấm biểu tượng phóng trong player, thay đổi bridge nhìn thấy được là: **tập hướng
app tuyên bố hỗ trợ thay đổi**. Lúc vào fullscreen, mask công bố là **24** (bit 8 + bit 16 =
LandscapeRight + LandscapeLeft); lúc thoát, mask quay về **2** (chỉ Portrait). Cơ chế tuyên bố là
máy hướng chuẩn của UIKit phía view controller:

- Player chuyển sang trạng thái fullscreen → view controller liên quan đổi giá trị trả về của
  `supportedInterfaceOrientations` / hướng ưu tiên trình bày;
- UIKit đáp bằng cách gọi `-[UIViewController setNeedsUpdateOfSupportedInterfaceOrientations]`
  (và đường fallback `+[UIViewController attemptRotationToDeviceOrientation]`);
- Nếu app chủ động xin hình học mới (iOS 16+), nó gọi
  `-[UIWindowScene requestGeometryUpdateWithPreferences:errorHandler:]` kèm preferences mang
  `interfaceOrientations`.

Trong các log đã thu, yêu cầu của YouTube đi **toàn bộ qua đường VC** (dòng `bao SpringBoard:
ma 255, mask ...` phía app; 44 dòng ở phiên fixround5), **không** qua đường scene-geometry
(dòng `app xin huong` = 0 trong mọi log — xem audit-inapphook: API đó app chỉ gọi khi nó tự xin
geometry update, YouTube trong các phiên này không gọi). Việc "xoay" thực tế do hệ thống/scene
thực hiện dựa trên tuyên bố đó — app chỉ đổi tuyên bố và sau đó **xếp lại giao diện theo hình học
mới được cấp**.

Quan sát phụ từ log fixround6: mỗi chu kỳ vào/thoát fullscreen gồm **một cặp yêu cầu cách nhau
~0,87 s**, cả hai được đáp giống hệt nhau (vào: mask 24 hai lần; thoát: mask 2 hai lần). Yêu cầu
thứ hai là app phát lại tuyên bố sau khi đã xử lý đáp án đầu — đây là mẫu quan sát được trong
log; nguyên nhân nội bộ chính xác phía app là suy luận.

### 1.2 Trên iOS gốc (không bị host): cửa sổ và khung xoay trong MỘT giao dịch

Trên điện thoại chạy trực tiếp, chuỗi là: app tuyên bố mask ngang → UIKit quyết định hướng mới →
window scene **xoay cả cửa sổ lẫn khung của nó trong một hoạt ảnh phối hợp duy nhất** (khung cửa
sổ từ dọc thành ngang, kích thước hoán trục, transform xoay áp cùng nhịp) → view controller nhận
`viewWillTransitionToSize:withTransitionCoordinator:` và xếp lại nội dung **bên trong cùng hoạt
ảnh đang xoay đó**. Vì hướng và kích thước thay đổi nguyên tử trong một transaction, không tồn
tại trạng thái trung gian "khung mới + hướng cũ" — mắt người thấy một vòng xoay liền mạch của cả
cửa sổ kèm nội dung.

### 1.3 Khi bị host trong ô split của OmniCar: chỉ có *giá trị hướng của scene* để lật

Scene của app lúc này là một FBScene bị host trong một ô (pane) có khung cố định trên màn hình
xe vốn đã ngang; **không tồn tại cửa sổ nào để hệ thống xoay** — khung ô do SpringBoard/CarPlay
quản, không đổi theo yêu cầu hướng (xem §2: đường xử lý yêu cầu hướng của gốc không chạm
pane.frame). Vì vậy khi app tuyên bố mask 24:

1. Bridge dịch mask → một **giá trị hướng** (4) và ghi vào trạng thái của pane;
2. Host áp lên scene một settings mới: **khung giữ nguyên**, kích thước logic hoán trục, và
   `interfaceOrientation` lật sang 4 (chuỗi đầy đủ ở §3);
3. App nhận thấy scene của mình "đã thành ngang" trong khi hộp chứa không hề xoay → app **tự
   chạy hoạt ảnh xếp lại giao diện của chính nó** bên trong hộp tĩnh: nội dung video chuyển lên
   trên, panel danh sách xuống dưới. Khoảnh khắc giữa hoạt ảnh đó — khung hình bắt được ở video
   fixround6 (~6,5 s) với poster nằm chéo — là hình đang xoay dở của app, không phải khung bị
   hệ thống xoay.

Nói gọn: trên iOS gốc, *hệ thống xoay khung kèm app*; bị host, *app tự xoay nội dung trong
khung đứng yên*. Vòng xoay/tumble nhìn thấy là hệ quả của khác biệt đó, cộng nhịp trễ của kênh
thương lượng hướng (§3).

### 1.4 Phân biệt: pinch zoom-to-fill trong player — cơ chế khác hẳn, không liên quan

Cử chỉ vuốt mở hai ngón *trên video* trong player (zoom-to-fill) chỉ đổi cách video lấp khung
trình chiếu (video gravity kiểu aspect-fill, cắt mép để lấp đầy). Nó **không** đổi tuyên bố
hướng, không xin geometry update, không đổi kích thước scene, và bridge **không nhìn thấy gì**
(không hook nào bắn, không dòng log nào phát). Mọi phân tích trong tài liệu này chỉ nói về nút
fullscreen đổi hướng; pinch zoom-to-fill nằm ngoài hoàn toàn.

---

## 2) Bản đồ hàm phía OmniCar gốc

Offset là của binary gốc (slice arm64) trừ khi ghi khác. "Một chu kỳ phóng" = một lần app
tuyên bố đổi hướng (vào hoặc thoát fullscreen) cho tới khi scene chốt hình học mới.

### 2.1 Phía app (ABInApp — dylib AppBridge chạy trong process app)

| Hàm (gốc) | Đầu vào → đầu ra | Vai trò trong chu kỳ |
|---|---|---|
| Installer + block nhận lệnh host — sub_4728 | NSDistributed `appbridge.orientation` {orientation, device, fps} theo bundleID → cài hook lười ở lần nhận đầu; ghi global hướng ép @0x3e7d0 | Cửa ngõ hai chiều: nhận hướng host áp xuống (mục ABPostOrientationToApp ở 2.2) và là nơi đăng ký mọi hook dưới đây |
| `ABHook_VCSetNeedsUpdate` — sub_5888 | `-[UIViewController setNeedsUpdateOfSupportedInterfaceOrientations]` được UIKit gọi → gọi orig, rồi nếu `ABForcedOrientation >= 1` thì lên lịch publish với field = **0xFF** (sentinel) | **Đường chính của YouTube**: app đổi tuyên bố → hook này biến nó thành yêu cầu gửi host |
| `ABHook_VCAttemptRotation` — sub_58C0 | `+[UIViewController attemptRotationToDeviceOrientation]` (class method, hook trên metaclass) → orig + publish sentinel 0xFF như trên | Đường fallback cùng đích với sub_5888 |
| `ABHook_SceneRequestGeometry` — sub_5734 | `-[UIWindowScene requestGeometryUpdateWithPreferences:errorHandler:]` do app tự gọi; hai cổng: forced >= 1 và preferences trả lời `interfaceOrientations` → tự suy đáp số, ghi global @0x3e9c8, log `app xin huong mask=%lu -> %lld`, publish **đáp số đã suy** (khác 0xFF) | Đường app chủ động xin geometry; YouTube không dùng trong các phiên đã thu (0 dòng log) nhưng là một trong ba nguồn của kênh |
| `ABOrientationDerivedFromMask` (thân trong sub_5734, quyết định @0x57b0–0x57c4) | mask → hướng: ưu tiên bit16 → 4, bit8 → 3, (mask>>1)&2; lệnh cuối `tst w0,#2; csel x9, xzr, x8, ne`: **bit 2 có mặt → 0**. Bảng: 24→4, 26→0, 30→0, 2→0 | Thuật toán suy dùng chung ý với phía host; cực bit-2 là điểm từng bị dựng ngược và đã sửa ở fixround6 |
| `ABHook_UIDeviceSetOrientation` — sub_5504 | `-[UIDevice setOrientation:animated:]` app gọi với giá trị tự chọn → publish giá trị **đã lọc**: gốc @0x553c–0x5544 (`csel …, lo` trên (v−3) <u 2) chỉ giữ {3, 4}, ngoài ra 0 | Nguồn thứ ba của kênh: app ra lệnh hướng trực tiếp thay vì tuyên bố mask |
| `ABSupportedOrientationMask` — sub_612c (+ tìm VC đệ quy sub_6498, sâu tối đa 12) | Cây view controller hiện tại của app → mask hỗ trợ *tại thời điểm publish* | Mask đóng gói đi kèm mọi publish đều lấy từ đây — host suy từ trạng thái app *hiện tại*, không từ trạng thái lúc bấm |
| `ABScheduleAppOrientationPublish` — sub_6750 | field (0xFF / đã suy / đã lọc) → huỷ block đang chờ (global @0x3e9d8), hẹn publish sau **0,25 s** (hằng `dispatch_time(0, 0x0EE6B280)` @0x67d0) | **Debounce**: gộp các tuyên bố dồn dập; là một thành phần trễ cố định của chu kỳ, gốc không có đường tắt khi zoom |
| `ABPublishAppOrientation` — sub_67fc | field + mask → `notify_set_state`: **state = (field & 0xFF) \| (mask & 0xFFFF) << 8 \| FNV1a(bundleID) << 24**, rồi `notify_post` kênh Darwin `appbridge.apporient`; log `bao SpringBoard: ma %lld, mask %lu` | Đóng gói số thuần (không dictionary) và phát yêu cầu lên SpringBoard |
| Block nhận `appbridge.orientation` (đuôi sub_4728) | {orientation, device, fps} từ host → đặt `ABForcedOrientation` (log `huong o %d, thiet bi gia %d`), reset ABAppOrientation = 0; nếu hướng đổi và mask của app chứa hướng đích → `_setRotatableViewOrientation:duration:0 force:1` lên view xoay được của key window; hẹn phát lại thông báo thiết bị giả ở +0,3 / +1,5 / +4,0 s (mảng hằng @0x393F0) | Cách host "áp" hướng xuống app ở thời điểm vào/rời ô; **chỉ** chạy ở launch-complete/teardown, không chạy theo fullscreen |

### 2.2 Phía host (ABHost — SpringBoard) và phía CarPlay (SCPCarSplit)

| Hàm (gốc) | Đầu vào → đầu ra | Vai trò trong chu kỳ |
|---|---|---|
| Callback Darwin `appbridge.apporient` — blk_apporient @0x92b4 | state số → `notify_get_state`, kiểm hash, bóc `changed = state & 0xFF`, `mask = (state >> 8) & 0xFFFF` → gọi appWithHash: | Cửa vào phía host của mọi yêu cầu hướng |
| `-[ABHost appWithHash:changedOrientation:supportedMask:]` — IMP @0xf6b0 | (hash, changed, mask) → tìm pane theo hash FNV (trượt thì log `apporient: khong co o cho hash`); chọn đáp số tại @0xf87c: **changed == 0xFF ? derived : changed**; ghi `requestedOrientation` (@0xf884, ivar +0x40); log `%@ doi yeu cau xoay (ma %d, mask %lu) -> scene huong %lld`; tail-call `nudgePane:` @0xf900 | **Trung tâm quyết định hướng**. Phép suy khi sentinel: ưu tiên 4 (bit16) > 3 (bit8) > 2 tại @0xf83c–0xf87c, cổng quyết định @0xf860 `cmp x8,#0` (x8 = mask & 2) → @0xf864 `csel x8, xzr, x9, ne` (bit 2 có mặt → 0), @0xf86c mask == 0 → 0. `setRequestedOrientation:` có **đúng một điểm ghi trong toàn binary** là ở đây — không seeding từ đường zoom/solo |
| `-[ABHost effectiveOrientation:]` — @0xf364 | pane → `requestedOrientation >= 1 ? requestedOrientation : pane.orientation` | Giá trị hướng hiệu lực mà layoutPane: thực áp; 0 từ phép suy nghĩa là "giữ hướng hiện tại của ô" |
| `-[ABHost nudgePane:]` — IMP @0xf9ac | pane → áp settings *chỉ-frame*: cỡ logic theo effectiveOrientation (hoán trục nếu 3..5) với thành phần thứ hai **trừ 1 pt** (block sub_fd98 chỉ gọi setFrame:); sau **+0,05 s** (hằng `0x02FAF080` @0xfbb8) chạy `layoutPane:` (block sub_fdf8) | Nhịp "gõ nhẹ" ép scene vẽ lại theo hướng mới trên **khung ô hiện tại** — hành động duy nhất mà một yêu cầu hướng gây ra; không chạm pane.frame, không đẩy solo, không cổng từ chối |
| `-[ABHost layoutPane:]` — IMP @0xec80 | pane → cỡ logic = box / zoom, hoán trục khi hướng ∈ 3..5 (@0xefc4–0xefd8, phép (o−3) ≤ 2 không dấu); ghi settings FBScene trong **một transaction** (block sub_f210: setFrame: → setInterfaceOrientation: → setBackgrounded: → setForeground:) | Nơi cặp {kích thước logic, interfaceOrientation} được áp nhất quán lên scene |
| `-[ABHost setFrame:forApp:live:handle:passInsets:]` — @0xfe68 (tiêu thụ bởi ABFrameBlock sub_8274) | payload khung từ CarPlay → animate khung box 0,25 s và gọi `layoutPane:` **đồng bộ ngay** khi sceneBox đổi | Nhịp 1 của các thay đổi *kích thước* (adopt/swap/solo): áp {cỡ mới + hướng đang lắng} nguyên tử; đường live=YES thì không gọi layoutPane |
| `ABPostOrientationToApp` — sub_e6b8 (source: ABHostGeometry.m) | (bundleID, orientation) → NSDistributed `appbridge.orientation` {orientation, device, fps} | Kênh host→app; **đúng 2 caller trong toàn binary**: @0xe600 trong sub_e57c (launch-complete, truyền pane.orientation) và @0x15620 (teardown, truyền −1). **Không** caller nào gắn với zoom hay fullscreen |
| Phía CarPlay: `bridgeBarAction:` → `runSoloForPane:` @0x288c0 / `toggleZoomForPane:` @0x251b0 → `relayoutAnimated:` @0x1b44c → `hostFrameInfo:` IMP @0x3d39c | thao tác trên thanh "..." / chạm đúp → payload khung {identifier, x/y/w/h, live, handle, insets, bar/pop/…, front, …} | Đường **solo của OmniCar** — nghi thức riêng, khác hẳn fullscreen nội bộ của player. Payload **không mang trường hướng nào theo thiết kế**: hướng luôn đi kênh apporient riêng. Toàn bộ SplitScreenB không chứa máy hướng nào (grep "Orientation" = ∅) |

---

## 3) Chu kỳ phóng hoàn chỉnh — dòng thời gian

### 3.1 Chế độ iOS gốc (app chạy trực tiếp trên điện thoại)

1. **t0** — Người dùng bấm nút fullscreen trong player.
2. Player VC đổi tuyên bố: mask hỗ trợ chuyển sang ngang (24).
3. UIKit gọi setNeedsUpdate/attemptRotation nội bộ, quyết định hướng đích.
4. Window scene xoay **cửa sổ + khung + transform trong một hoạt ảnh phối hợp**; VC nhận
   viewWillTransitionToSize: và xếp lại nội dung trong cùng hoạt ảnh.
5. Chốt: khung ngang, nội dung ngang — một transaction duy nhất, không trạng thái trung gian
   không nhất quán. Toàn bộ do hệ thống điều phối; không kênh phụ, không trễ thương lượng.

### 3.2 Chế độ bị host OmniCar (đo trên phiên fixround6, YouTube trong split với Maps)

Điều kiện đầu: 11:20:42.598 CarPlay nhận YouTube vào ô 0; 11:20:42.773 host tại
{{45, 0}, {297, 360}} (huong 1, zoom 0.80) — ô split, hướng lắng = 1.

**Vào fullscreen** (video: bấm nút phóng ở giây ~6, khớp mốc log 11:21:02):

1. **11:21:02.587 [YouTube]** — App đổi tuyên bố sang mask 24 → hook VC (sub_5888) lên lịch
   publish sentinel; sau debounce ≤ 0,25 s: `bao SpringBoard: ma 255, mask 24`.
2. **11:21:02.588 [SpringBoard]** — Callback apporient bóc gói → appWithHash: suy
   derived = 4 (mask 24, bit 2 vắng) → ghi requestedOrientation = 4 → log
   `doi yeu cau xoay (ma 255, mask 24) -> scene huong 4` → nudgePane:.
3. **Ngay sau đó** — nudgePane: áp settings chỉ-frame (cỡ logic hoán trục, −1 pt) trên khung
   ô **không đổi**; +0,05 s layoutPane: áp cặp nhất quán {cỡ logic hoán trục,
   interfaceOrientation 4} trong một transaction settings.
4. **~11:21:02.6 → ~11:21:03.4 [trong app]** — App thấy scene "thành ngang" trong hộp tĩnh
   {297, 360} → tự chạy hoạt ảnh xếp lại (video bắt được poster nằm chéo ở ~6,5 s, giao diện
   ngang — video trên, panel dưới — chốt ở ~7–8 s).
5. **11:21:03.455/456** — App phát lại mask 24 (phần hai của cặp ~0,87 s); host đáp 4 lần nữa
   — chu kỳ xác nhận, không đổi trạng thái.

**Thoát fullscreen** đối xứng: cặp mask 2 ở 11:21:06.619/620 và 11:21:07.492/493 → derived = 0
(bit 2 có mặt) → requestedOrientation = 0 → effectiveOrientation rơi về hướng của ô = 1 →
nudge + layoutPane áp lại hướng 1; app tự xếp lại về dạng dọc trong ô.

**Đối chiếu đường solo của OmniCar** (nghi thức khác): 11:24:36.614 host YouTube tại
{{45, 0}, {595, 360}} (huong 1, zoom 0.80) — khung đổi thật qua đường frame (setFrame: →
layoutPane: đồng bộ), hướng áp là giá trị đang lắng lúc đó (requestedOrientation ∈ {0, 1} sau
cửa sổ 11:21), không có thương lượng hướng nào chạy kèm.

### 3.3 Vì sao bị host lại có "nhịp"

Hướng và kích thước đi **hai kênh độc lập theo thiết kế gốc**: khung qua payload
hostFrameInfo (đồng bộ), hướng qua Darwin apporient (debounce 0,25 s + nudge 0,05 s). Mỗi
thay đổi vì thế tới scene theo nhịp riêng; phần xoay còn lại do app tự thực hiện trong hộp
không xoay. Ba thành phần trễ đo được trong một chu kỳ fullscreen nội bộ: debounce publish
≤ 0,25 s (app), nudge → layoutPane 0,05 s (host), hoạt ảnh xếp lại của chính app (~0,5–1 s —
phần lớn nhất và nằm ngoài bridge).

---

*Ghi chú trung thực: cực bit-2 trong hai phép suy từng bị bản dựng đảo ngược (host + app) và
đã sửa ở fixround6 — cơ chế trong tài liệu này là cơ chế của GỐC sau khi đối chiếu lại.
Kết luận của các strand liên quan (điều tra tĩnh đã đóng theo chốt GPT): không seeding, hằng
thời gian khớp gốc, gốc cũng lật hướng tại chỗ trong ô split; phân định thị giác cuối cùng
(VISUAL_ORIGINAL_COMPARISON) vẫn PENDING — cần footage DEB gốc cùng kịch bản.*
