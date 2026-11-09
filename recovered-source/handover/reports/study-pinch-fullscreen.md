# NGHIÊN CỨU: PINCH 2 NGÓN → FULLSCREEN CHO OMNICAR (trên source đã phục hồi)

> Chỉ-đọc, 2026-11-09. Nguồn: cây source phục hồi `~/workspace/omnicar-re/src/`,
> hồ sơ saga pinch `~/workspace/omnicar-pinch/` (feature/src, probe, redo/,
> FREEZE_VERDICT_200.md), MEMORY.md. Nhãn: **[GỐC]** = có trong binary 1.0.3 đã
> kiểm chứng; **[SAGA]** = cơ chế bản cộng thêm 21–46; **[ĐO]** = đã đo trên xe;
> **[CHƯA RÕ]** = chưa có bằng chứng.

## 0. Trước hết: ba nghĩa "fullscreen" khác nhau — không được trộn

| Nghĩa | Cơ chế | Trạng thái |
|---|---|---|
| (a) Một Ô chiếm toàn vùng split | `toggleZoomForPane:` của gốc: ô được zoom alpha 1, các ô còn lại alpha 0, split vẫn sống | **[GỐC]** |
| (b) Một APP độc chiếm, split kết thúc | `soloBundle:` của gốc: app hosted qua hostSolo (AppBridge toàn màn), app native trả VC về dashboard trình bày | **[GỐC]** |
| (c) Toàn bộ giao diện split phình lên đè dock CarPlay | `OMCToggleHost` của saga: nới frame CONTAINER từ appArea lên full window + ẩn chrome | **[SAGA]** — gốc **không có** hàm/class tương ứng (ghi chú đầu file `SCPCarSplit+Zoom.m`: binary 1.0.3 có 0 hit OMCZoomAction/OMCZoomState; dylib fullscreen riêng cũng không tồn tại trong 1.0.3) |

Yêu cầu gốc của Nguyen (07/11) là nghĩa (c) — "pinch bật/tắt toàn màn ẩn dock".
Bản đồ solo mà GPT/Muse đã phục hồi là (a)+(b). **Pinch sẽ kích nghĩa nào là
quyết định số 1 ở mục 5**; các mục dưới bám (a)/(b) vì đó là đường gốc, và ghi rõ
chỗ nào (c) không có đường gốc tương ứng.

## 1. Nghi thức solo/zoom của gốc — đầu-cuối

### 1.1 Hai hàm lõi (đều trong process CarPlayApp, lớp SCPCarSplit)

**`toggleZoomForPane:` @0x251b0** (`SplitScreenB/SCPCarSplit+Zoom.m:23`):
- Điều kiện vào: `self.active` (split đang chạy); `pane.vc != nil`;
  `pane.slot != 9` (ô float không zoom); `paneCount >= 2`.
- Hành vi: nếu `zoomedSlot == pane.slot` → xoá zoomedSlot (thu về); ngược lại
  đặt `zoomedSlot = @(slot)`. Log "phong to/thu nho o %d". Ẩn thanh của ô
  (`setBarVisible:NO`), rồi `relayoutAnimated:YES`.
- Trạng thái zoom = đúng một ivar `zoomedSlot` (NSNumber, nil = không zoom).
  Không có máy trạng thái phụ nào khác.

**`runSoloForPane:` @0x288c0** (`SplitScreenA/SCPCarSplit.m:3347`):
- Ẩn thanh trước. Nếu `pane != floatPane && paneCount >= 2` → uỷ cho
  `toggleZoomForPane:` (tức "solo" trong split nhiều ô CHÍNH LÀ zoom (a)).
- Ngược lại (ô đơn độc / ô float): `soloBundle:` @IMP 0x1e33c — kết thúc split:
  app hosted → `hostSolo:` @0x3f9c0 (AppBridge đưa toàn màn qua kênh frame);
  app native → detach VC, `closeGoingHome:`, dashboard
  `presentBaseViewController:` trình bày toàn màn; không ô nào giữ app →
  relaunch bằng launchInfo + cover + sự kiện dashboard sau 0,8 s.

**`relayoutAnimated:` @0x1b44c** (Layout): kiểm tra tính hợp lệ của zoomedSlot
(tự xoá nếu split không còn đủ điều kiện), áp frame/alpha cho mọi ô trong một
spring animation 0,45 s (damping 0,86) — ô không được zoom khi đang zoom thì
alpha 0 và tương tác đồng bộ theo alpha; cuối cùng đẩy scene size + host frame
sang phía SpringBoard (`hostFrameInfo:` @0x3d39c, payload frame **không mang
trường hướng** — đã chốt ở audit-zoomtiming).

### 1.2 Ai gọi được chúng — mọi cửa vào đều nằm ngoài process app

1. **Nút "Toàn màn" trên thanh của chính ô (CarPlay)**: `paneSolo:` @0x287b8
   (action của soloButton "hm_full" trong `SCPCarSplit+Chrome.m:206`) →
   `runSoloForPane:`.
2. **Thanh "..." phía SpringBoard cho app hosted**: nút trên thanh AB →
   `barFull:` → `postBarAction:@"full"` @0x13148 (ABHostLaunch.m:348) phát
   NSDistributedNotification `com.anlai.omnicar/appbridge.baraction`
   {action, identifier} → CarPlay nhận ở `SCPBridgeBarActionBlock`
   (SCPHooks.m:492) → `bridgeBarAction:forBundle:` @0x3f7f4: tra ô theo
   bundle (`paneForBundle:`), guard `active && pane`, action `full` →
   `runSoloForPane:` (cùng họ: replace/pop/bg/close).
3. **Chạm đôi lên tay cầm bridge**: `appbridge.handletap` → 
   `bridgeHandleTapped:` @0x3f65c: hai chạm cùng bundle cách < 0,35 s =
   double tap → `toggleZoomForPane:` (ô float → toggleFloatSize). Đây là
   tiền lệ gốc gần nhất với "cử chỉ kích zoom": cử chỉ được phía SpringBoard
   nhận diện (chạm lên chrome AB) rồi relay sang CarPlay.
4. **Chạm đôi trên ô phía CarPlay**: `handleDoubleTapped:` @0x25048 →
   `toggleZoomForPane:`.
5. **Kênh lệnh `splitscreen.native`** {action:"zoom", pane:N}: do phía
   SpringBoard phát qua `SCPPostNativeSplitRequest` (kèm cơ chế gửi lại khi
   màn xe sẵn sàng); nguồn gốc của lệnh là app điện thoại/URL scheme phía
   SpringBoard (SCPSpringBoardHooks.m:129-147). CarPlay nhận ở
   `SCPNativeCommandBlock` → `urlZoomPane:` @0x24ff0 →
   `toggleZoomForPane:`; mọi lệnh đều có `splitscreen.ack` trả về.

**Kết luận mục 1:** nghi thức solo/zoom là **nội bộ CarPlayApp 100%**. Các kênh
`appbridge.*` chạm tới nó chỉ có: `baraction` (từ thanh AB phía SpringBoard)
và `handletap` (chạm lên chrome AB). **Process app không có đường nào gọi
chúng trong gốc** — ABInApp không phát baraction/native, chỉ phát Darwin
`appbridge.apporient` + `appbridge.keyboard` (notify_set_state đóng gói số)
và NHẬN distributed `appbridge.orientation`/`appbridge.key`.

## 2. Điểm gắn pinch: chạm trên ô hosted thực ra đi đường nào

### 2.1 Địa hình chạm — đã có bằng chứng xe, không phải suy luận

- **[ĐO — bản 44, saga]** Chạm trên ô hosted **KHÔNG đi qua
  `-[UIApplication sendEvent:]` của process app**: trong một phiên split
  đang sống, relay trong app chỉ nhận đúng 1 bản ghi chạm, ngay lúc teardown
  (ghi trong comment HISTORY của feature/src/OmniCarDoubleTapFullscreen.xm
  và hồ sơ redo/). Tức mọi thiết kế "hook sendEvent: trong app để chặn/kết
  luận chạm" là **chết trên OmniCar** — khớp tiền lệ DuoFace QA176 (chặn
  phía host-SpringBoard cũng 0 hit: chạm vào scene được route theo scene
  thẳng tới app).
- **[ĐO — bản 21–35 + bản 32]** Tầng `sendEvent:` của **CarPlayApp** thì
  THẤY và GIỮ ĐƯỢC chạm trên ô hosted (cơ chế pinch-hold của saga chạy ở
  đây; bản 32 cổng host ăn 25+ chạm thường cũng tại tầng này). Chạm từ màn
  xe vào CarPlayApp qua cửa sổ dashboard, duyệt qua scene-host view rồi mới
  được hệ thống chuyển tiếp vào scene của app.
- **[ĐO — hằng ngày]** Bên trong process app, các recognizer CỦA CHÍNH APP
  vẫn nhận chạm bình thường qua đường phân phối của scene (app bấm/cuộn/
  cử chỉ nội bộ chạy được trên màn xe). Điểm mù chỉ là `UIApplication
  sendEvent:` — recognizer gắn trên view/window của app **không** phụ
  thuộc sendEvent:.

### 2.2 Ứng viên gắn trong ABInApp (dylib in-app)

Sự thật về ABInApp gốc (AppBridgeB/ABInApp.m + AppBridgeEntry.m):
- Dylib filter = {Bundles: [com.apple.UIKit]} → nạp vào MỌI process UIKit;
  ctor vai-app chạy trong mọi .app trừ 6 bundle loại trừ. Nhưng **toàn bộ
  hook chỉ cài LƯỜI** khi nhận thông báo distributed `appbridge.orientation`
  đầu tiên gửi đích danh bundle của app (block sub_4728) — tức chỉ khi app
  đang được host. Trước thời điểm đó ABInApp chỉ là hai observer nằm chờ.
- ABInApp **không có** recognizer nào, không hook sendEvent:; nó đã có sẵn
  `ABKeyWindow()` (sub_61D0 — cửa sổ key đầu tiên qua các scene) và biết
  trạng thái được-host qua ABForcedOrientation.

Ứng viên kỹ thuật: cài một `UIPinchGestureRecognizer` lên key window (hoặc
root view) trong cùng block cài hook lười sub_4728, gỡ/vô hiệu khi nhận
thông báo thả app (orientation −1). Hệ quả phạm vi:
- Chỉ phủ **app hosted** (đúng tập ABInApp sống). **Ô native không có
  process app riêng** — VC của nó nằm trong CarPlayApp — nên điểm gắn này
  **không bao giờ** thấy pinch trên ô native.
- Recognizer sẽ **tranh chấp** với recognizer của chính app trên cùng bề
  mặt scene (xem phân loại 2.3) — đây là rủi ro chính, không phải vấn đề
  "có thấy chạm hay không".

### 2.3 Phân loại theo nhóm app

- **TRỐNG (cử chỉ không ai dùng):**
  - App bản đồ **CarPlay native trên iOS 16**: đa chạm cho app dẫn đường
    chưa tồn tại (chỉ có từ iOS 26) — pinch là cử chỉ trống **[đã kiểm
    chứng, MEMORY 07/11]**. Trớ trêu: đây là nhóm trống nhất nhưng lại nằm
    ở ô native — nơi điểm gắn in-app không tới được; muốn bắt pinch ở đây
    phải dùng tầng CarPlayApp (mục 3, phương án C).
  - Phần lớn app nội dung hosted ở bề mặt chính (feed dọc 1 ngón: Facebook,
    TikTok ở màn feed) — 2 ngón không có ngữ nghĩa ở bề mặt chính.
- **XUNG ĐỘT (app đã có pinch riêng, đang sống trên cùng bề mặt):**
  - **YouTube**: pinch trong player = zoom-to-fill nội bộ (đổi video
    gravity), không phát tuyên bố hướng (invest-ytzoom). Recognizer gắn
    thêm sẽ đua: cả hai cùng nhận (nếu cho simultaneous) → video vừa zoom
    vừa toggle solo; hoặc trọng tài cướp ngẫu nhiên theo thứ tự cài.
  - **Maps/Waze khi được host bằng scene điện thoại** (App Bridge): giao
    diện điện thoại có pinch zoom bản đồ riêng và đang hoạt động — người
    dùng véo để zoom map sẽ toggle solo. (Khác hẳn bản native ở trên:
    cùng một app, hai scene, hai kết luận ngược nhau.)
  - Trình duyệt / app có WKWebView: pinch zoom trang là cử chỉ thật.
- **KHÔNG CHẮC:** app xem ảnh/video khác (pinch zoom ảnh trong viewer),
  game, app vẽ — ngữ nghĩa 2 ngón khác nhau theo từng app, không liệt kê
  tĩnh được. **[CHƯA RÕ]** theo từng bundle; chính sách mặc định cho nhóm
  này là một quyết định (mục 5).

## 3. Đường tín hiệu pinch → solo, độ trễ, chống cướp chạm

### 3.1 Ba phương án đường tín hiệu

**A. In-app → Darwin → SpringBoard → distributed `baraction` (đi theo tiền
lệ apporient):** ABInApp phát một kênh Darwin mới (đóng gói số kiểu
notify_set_state như sub_67fc: field | hash(bundle)<<24) → ABHost phía
SpringBoard nhận, tra bundle → phát distributed `appbridge.baraction`
{action:"full", identifier:bundle} → CarPlay `bridgeBarAction:` →
`runSoloForPane:`. Mọi mắt xích đều là cơ chế gốc đang chạy; chỉ có kênh
Darwin đầu là mới. Đích cuối dùng lại nguyên handler gốc, kể cả guard
`active && pane`.

**B. In-app phát thẳng distributed `baraction`:** tiền lệ gần: lệnh
`splitscreen.native` được phát từ phía app điện thoại và CarPlay thực thi
+ trả ack — đường app-process → distributed → CarPlay **tồn tại trong hệ
sinh thái này**. Nhưng ABInApp của gốc **không bao giờ phát** distributed
(chỉ nhận); việc phát từ process của app bên thứ ba bị host là **[CHƯA
RÕ]** trong codebase này (sandbox/độ tin cậy người gửi — CarPlay không
kiểm tra người gửi, ai phát đúng tên cũng kích được: đó cũng là một bề mặt
lạm dụng cần GPT phán).

**C. Không cần đường tín hiệu — nhận diện ngay trong CarPlayApp (đường
saga):** SCPCarSplit ở cùng process; recognizer tầng sendEvent: của
CarPlayApp thấy mọi chạm trên màn xe (kể cả ô native) và gọi thẳng hàm
toggle. Độ trễ tín hiệu = 0. Đây là phương án duy nhất phủ được ô native.

### 3.2 Độ trễ kỳ vọng

- Nhảy liên process: **[ĐO]** cặp log "cham thanh" (SpringBoard) ↔ "bridge
  handletap" (CarPlay) ở fixround4 lệch ~3–4 ms; đáp hướng app→host ~1 ms.
  Phương án A cộng hai nhảy ≈ vài ms — không đáng kể.
- Thành phần trễ thật nằm ở **quãng đường ngón tay**: recognizer chỉ được
  kết luận sau khi tỉ lệ khoảng cách hai ngón vượt ngưỡng (saga dùng
  1,10/0,90) — hàng trăm ms theo tay người, cộng spring relayout 0,45 s
  của gốc. Mọi phương án đều chung hai thành phần này; chênh lệch A/B/C
  (vài ms) là vô nghĩa so với chúng.

### 3.3 Chống cướp chạm — phần khó nhất, và saga đã trả giá để biết

- **Recognizer gắn trên view (phương án A/B):** không chặn được app ôm
  chạm trước. `cancelsTouchesInView = YES` chỉ huỷ chạm trong view SAU
  KHI recognizer đã nhận diện — mà nhận diện pinch cần ngón đã di chuyển,
  tức app có thể đã bắt đầu xử lý cặp chạm (YouTube bắt đầu zoom-to-fill).
  `delaysTouchesBegan = YES` giữ Began tới khi recognizer thắng/thua —
  nhưng nó trì hoãn **mọi** chạm kể cả 1 ngón (chạm thường bị chậm theo),
  và pinch chỉ "thua" khi chắc chắn không đủ 2 ngón. Không có cấu hình
  recognizer nào cho kết luận "2 ngón" ở thời điểm ngón thứ hai chạm
  xuống — kiến thức đó chỉ có ở tầng phân phối sự kiện.
- **Giữ cặp chạm ở tầng sendEvent: (phương án C, "Cách A" của saga):**
  engages ngay sự kiện ngón thứ hai Began, **giữ toàn bộ cặp** (không
  chuyển xuống app), đo tỉ lệ khoảng cách + phép thử chiếm ưu thế
  (midDrift ≤ 0,6 × distChange + 10 để phân biệt véo với kéo 2 ngón),
  ngưỡng 1,10 (ra) / 0,90 (vào) thì toggle một lần theo đúng hướng trạng
  thái hiện tại; cặp bị giữ thì bị tiêu thụ trọn — kể cả khi kết luận
  cuối là "không phải pinch", app mất cặp chạm đó (cái giá đã biết và đã
  được chấp nhận trong saga). Thao tác 1 ngón không bị đụng vì cơ chế giữ
  chỉ khởi động khi có ngón thứ hai.
- **Điều kiện an toàn rút từ verdict đóng băng (bắt buộc tôn trọng):**
  recognizer của saga 36–39 bị nghi ngờ chính vì **gắn recognizer từ bên
  trong đường dispatch của sendEvent:** (mutation danh sách phân phối
  giữa chừng) trên **mọi cửa sổ gồm cả cửa sổ bàn phím/alert**, bởi một
  dylib nạp vào **mọi process UIKit**. Ba yếu tố đó không được lặp lại
  (chi tiết mục 4).

## 4. Đối chiếu saga cũ: bản 21–35 làm khác gì, và cái gì vẫn chưa biết

### 4.1 Cách saga làm (bản 21–35, giữ nguyên tới 46)

- Pinch nằm trong **dylib phía host** (OmniCarDoubleTapFullscreen.dylib —
  dylib của QA20/GPT đóng trong các gói unified), chạy trong **CarPlayApp**.
  Không phải `UIPinchGestureRecognizer` gắn view: đó là **recognizer tự
  chế trong hook `-[UIApplication sendEvent:]`** ("Cách A" ở mục 3.3):
  theo dõi mọi touch start, ngón thứ hai chạm xuống là giữ cặp, đo tỉ lệ
  khoảng cách, qua ngưỡng thì gọi toggle **một lần rời rạc** (không resize
  liên tục theo ngón).
- Hàm được gọi là **`OMCToggleHost`** — cơ chế **saga tự chế**: nới frame
  container từ `appAreaInParent:` lên full bounds của cửa sổ, gọi
  `relayoutAnimated:NO pushScenes:YES` + `rootDidLayout`, ẩn/hiện chrome
  theo trạng thái `OMCZoomState` riêng của saga. Tức saga pinch thực hiện
  nghĩa (c) ở mục 0, bằng **giả lập hình học**, không đụng một hàm
  solo/zoom nào của gốc, và trạng thái zoom là trạng thái song song nằm
  ngoài SCPCarSplit (nguy cơ lệch trạng thái với split thật luôn tồn tại).
- Phần pinch của host được đội 200 kiểm: **instruction-identical từ
  pinch15 → pinch18** và host dylib **byte-identical giữa 39 ↔ 40** —
  pinch phía host không đổi qua biên đóng băng.

### 4.2 Các sự cố — ghi đúng mức bằng chứng

- **Bản 34 chết Home:** so sánh bundle id **phân biệt hoa-thường** trong
  phía phát trạng thái của cổng wake (không phải pinch) → Home bị coi là
  app lạ. Bản 35 sửa bằng lowercase trước khi so. Đã xác định, đã đóng.
- **Đóng băng bản 36/38 (và 39 theo báo cáo): CHƯA XÁC ĐỊNH.** Cuộc điều
  tra 200 agent (FREEZE_VERDICT_200.md) kết luận nguyên văn: **"Undecidable
  to proof on current evidence"**. Mọi khẳng định đơn-nhân đều bị bác:
  scope/filter (không đổi 35→38), recognizer tự thân, log I/O, timers,
  heartbeat, keyboard machinery, %ctor, host dylib (byte-identical, được
  minh oan), _cancelAllTouches tiền-%orig… Tổ hợp còn đứng vững duy nhất
  được xếp hạng **"best-supported, NOT proven"**: {dylib relay nạp vào
  **mọi** process UIKit × recognizer khoá **window-level** của cổng wake
  (OMRelayLockRecognizer — recognizer của LOGO, không phải của pinch)
  thực sự engages × việc gắn recognizer đó **từ bên trong đường dispatch
  của sendEvent:**}. Mọi lần đóng băng chỉ dựa trên báo cáo của Nguyen —
  **không tồn tại .ips/sysdiagnose nào**; bản 39 thậm chí không có log
  thiết bị. Artefact quyết định (một spin/hang .ips) chưa bao giờ thu
  được. **Không được đoán thêm.**

### 4.3 Có source gốc rồi thì khác gì

1. **Đích toggle là hàm gốc có trạng thái gốc:** `runSoloForPane:` /
   `toggleZoomForPane:` với `zoomedSlot` do chính SCPCarSplit sở hữu —
   bỏ được tầng giả lập frame + trạng thái song song của OMCToggleHost.
2. **Có sẵn cửa vào đích danh theo bundle:** `bridgeBarAction 'full'` —
   không cần phát minh IPC; mọi phương án tín hiệu đều đổ về handler gốc
   đã có guard.
3. **Địa hình chạm đã được đo thay vì đoán** (mục 2.1): app sendEvent =
   mù; tầng CarPlayApp = thấy hết; recognizer trong app = thấy qua scene
   nhưng phải tranh chấp. Saga từng tốn nhiều vòng vì chưa có bản đồ này.
4. **Ràng buộc đóng gói vẫn nguyên:** tính năng của Muse nằm ở dylib
   RIÊNG, dylib gốc giữ nguyên từng byte (luật cứng 08/11). Với source
   phục hồi, thêm một lựa chọn nữa cần phán quyết: sửa thẳng vào cây RE
   (làm cây mất tính "phục hồi trung thực") hay giữ add-on ngoài gọi cửa
   vào gốc — xem mục 5.

## 5. Các quyết định cần GPT/Nguyen chốt TRƯỚC khi đóng bất kỳ bản nào

1. **Ngữ nghĩa fullscreen của pinch** (mục 0): (a) zoom một ô của gốc,
   (b) solo của gốc, hay (c) toàn-màn-ẩn-dock kiểu saga — riêng (c) không
   có cơ chế gốc tương ứng, chọn (c) nghĩa là chấp nhận xây cơ chế mới.
2. **Tầng nhận diện:** CarPlayApp (phủ cả ô native + ô hosted, tiền lệ
   saga) hay in-app ABInApp (chỉ hosted, đúng luật "dylib riêng trong
   app" nhưng mù ô native)? Đây là đánh đổi phủ sóng ↔ xung đột (mục 2).
3. **Chính sách xung đột theo nhóm app:** YouTube (zoom-to-fill), Maps/
   Waze scene điện thoại (pinch map), trình duyệt (pinch trang) — pinch
   nhường app ở các bundle này, hay pinch của OmniCar thắng? Nhóm
   **[KHÔNG CHẮC]** còn lại: mặc định bật hay tắt theo bundle?
4. **Ràng buộc an toàn đóng băng (không thương lượng, rút từ verdict
   200):** cấm gắn recognizer từ bên trong dispatch của sendEvent:; cấm
   recognizer sống trên cửa sổ bàn phím/alert; dylib có recognizer sống
   không được nạp vào mọi process UIKit vô điều kiện. Thiết kế chọn phải
   chứng minh thoát cả ba yếu tố của tổ hợp bị nghi ngờ.
5. **Đường tín hiệu + chống phát trùng (nếu chọn in-app):** phương án A
   (qua SpringBoard relay) hay B (phát distributed thẳng — cần phán quyết
   về người-gửi-không-kiểm-chứng)? Toggle là hàm **có trạng thái**: một
   tín hiệu trùng = toggle hai lần = trở về cũ. Cần cửa sổ khử trùng
   (tiền lệ: debounce 0,25 s của apporient; cặp 0,35 s của handletap).
6. **Đối xứng pinch-vào:** với (a) đối xứng tự nhiên. Với (b)
   `soloBundle:` **không có nghịch đảo** — split đã kết thúc; pinch-vào
   lúc đang solo phải nghĩa là gì (mở lại split? không làm gì?) cần định
   nghĩa trước, không để recognizer tự quyết.
7. **Cái giá của giữ-cặp (nếu dùng Cách A):** cử chỉ 2 ngón không-phải-
   pinch (kéo 2 ngón, cuộn 2 ngón trong một số app) sẽ **mất cặp chạm**
   vì bị giữ rồi tiêu thụ. Chấp nhận toàn cục, hay chỉ giữ trong phạm vi
   nhóm app TRỐNG?
8. **Đóng gói:** add-on dylib riêng gọi cửa vào gốc (giữ cây RE trung
   thực + đúng luật byte-identical) hay sửa vào cây RE? Và thứ tự với
   các việc đang giữ (sửa núm vách ngăn đang chờ thả; quy tắc một phiên
   test gộp cho mỗi bản).
9. **Đo trước khi làm (quy tắc số 1):** ẩn số thực nghiệm duy nhất còn
   lại là recognizer gắn trong ABInApp trên key window có thực sự nổ —
   và trọng tài với recognizer của app ra sao — trên từng nhóm app.
   Một bản **đo chỉ-đọc** (recognizer chỉ ghi log, không toggle, không
   nuốt) trả lời được câu này trong một phiên; có nên bắt buộc vòng đo
   này trước mọi bản tính năng không?

---
*Hết nghiên cứu. Không một dòng code nào được sửa trong quá trình này.*
