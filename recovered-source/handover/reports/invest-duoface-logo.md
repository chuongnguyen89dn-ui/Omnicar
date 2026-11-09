# ĐIỀU TRA CHỈ-ĐỌC — Cơ chế nút logo DuoFace (wake/gọi logo khi controls đang ẩn)

Ngày điều tra: 2026-11-09. Phạm vi: chỉ đọc hồ sơ dự án của Nguyen trên đĩa, không sửa/build/git.
Mọi khẳng định gắn nguồn [file]. Ký hiệu: SB = SpringBoard (process host), relay = dylib sống trong process app được host.

## 0. Chuẩn hành vi (Nguyen chốt)

- Chuẩn chốt 04/11/2026 21:47, theo DuoNavi: **controls đang ẩn → cú chạm đầu CHỈ hiện logo/controls và bị nuốt (không thực thi chức năng tại điểm chạm); controls đang hiện → chạm đi qua bình thường** [~/MEMORY.md, mục "Chạm đánh thức logo"].
- Lưu ý độ tin cậy của "chuẩn DuoNavi": luật nuốt của DuoNavi là **suy luận từ quét tĩnh hồ sơ deb** (05/11), không phải deb chứng minh động — ghi trong hồ sơ đối chứng 06/11 [~/memory/2026-11-06.md, mục "Phạm vi bằng chứng của quyết định khắc phục 06/11"]. Cơ chế dưới đây là của **chính DuoFace** (các bản QA177→QA180) và đã có verdict xe thật.

## 1. Cơ chế đầu–cuối (bản đạt: QA180 `0.0.180~h1wake3`)

### 1.1 Ai nắm trạng thái ẩn/hiện và phát đi bằng cách nào

- **Chủ trạng thái là phía host**: `DFNative12Chrome` (process SB) — nơi duy nhất tính được controls có đang hiện hay không. Trong nền QA171 đã đọc tại mã: `noteUserActivity` đặt `controlsUntil = now + 4.0` (và `borderUntil = now + 2.0`) rồi gọi `layoutControls`, kèm `dispatch_after` 4,05s dọn lại; trong `layoutControls`, `controlsVisible = panActive || logoTouchPending || now <= controlsUntil` [~/memory/2026-11-06.md, mục "Cơ chế ẩn/hiện controls của nền 171 đã đọc tại mã"]. Tức trạng thái ẩn/hiện là **giá trị suy ra ngay trong `layoutControls`**, không nằm ở biến độc lập nào khác.
- **Phát trạng thái (h1wake3)**: host post đúng một trong hai Darwin notification **NGAY khi `layoutControls` đổi trạng thái**: `com.duoface.controls188.hidden` hoặc `com.duoface.controls188.shown`; đồng thời host đăng ký nhận `com.duoface.controls188.query` — mỗi lần nhận query thì post lại notification tương ứng trạng thái hiện tại (cơ chế hỏi/đáp để relay lấy trạng thái ban đầu) [~/memory/2026-11-06.md, mục trích work order QA180; ~/MEMORY.md mục QA180: "host-side phát hidden/shown NGAY khi layoutControls đổi", "trạng thái qua Darwin `com.duoface.controls188.hidden/.shown/.query`, KHÔNG đọc plist"].
- Phía host trong bản h1wake1, phần publish nằm ở file đi kèm `DFH1Wake188.m` **swizzle `start`/`stop`/`layoutControls` của `DFNative12Chrome`** (file Chrome gốc giữ byte-identical với nền 171): đăng ký wake DF156; khi có wake thì kiểm tra độ tươi + chống trùng rồi gọi `noteUserActivity`; và publish trạng thái ẩn/hiện [~/memory/2026-11-06.md, mục "Code local hoàn thiện… `~/workspace/h1wake1-work/out/`"].

### 1.2 Cú chạm đầu khi đang ẩn bị xử lý ở đâu và bị nuốt ra sao

- **Điểm xử lý nằm trong process của app được host**, tại hook **`-[UIApplication sendEvent:]`** do relay cài vào. Đây là kết luận rút từ thất bại QA176: chạm vào nội dung scene được route thẳng tới scene của app (kênh input theo scene), **không qua hit-test UIKit của cửa sổ slot trong SB** — mọi điểm chặn phía SB đều không thấy cú chạm (mục 3.1). Hướng QA177 chốt: "lấy tín hiệu chạm từ phía app" [~/workspace/duoface-audit/TONG_HOP_QA177.md, Vấn đề 1; ~/memory/2026-11-03.md dòng 69–71].
- Ở bản gốc H1 (QA177), hook này **chỉ-đọc**: IMP gốc chạy trước, hook chỉ đọc pha Began, throttle 250ms, bộ đếm cộng dồn, rồi gửi tín hiệu chạm về host qua mailbox DF156 (mục 1.3) [~/memory/2026-11-03.md dòng 71, 929].
- Từ **h1wake1**, cùng header `DFAppTouch177.h` được thêm **cổng nuốt ngay tại hook đó**: khi cổng thỏa (mục 1.4), relay **không chuyển tiếp trọn dãy chạm đầu tới Ended/Cancelled** — tức app không nhận được dãy chạm đó — và **chỉ phát tín hiệu wake** về host; gói bị nuốt bỏ qua throttle 0,25s; trạng thái không rõ thì **fail-open** (chạy như H1 chỉ-đọc: chạm đi qua, vẫn phát tín hiệu) [~/memory/2026-11-06.md, mục "Code local hoàn thiện…"]. Record chạm ghi trường `swallowed=0/1` (marker `qa188-h1-app-touch-wake`) [~/memory/2026-11-06.md, mục test xe QA178/QA179].
- Host nhận wake → `df177HandleAppTouch` (trong `DFNative12Chrome`) → gọi `noteUserActivity` → `controlsUntil = now + 4.0`, `layoutControls` tính lại `controlsVisible = YES` → logo/controls hiện [~/memory/2026-11-03.md dòng 957 (bản đồ receiver 172R); ~/memory/2026-11-06.md mục nền 171].

### 1.3 App phía trong biết trạng thái bằng cơ chế hỏi/đáp nào

- **Đẩy (push)**: relay đăng ký nhận hai Darwin notification `com.duoface.controls188.hidden` / `com.duoface.controls188.shown` do host post khi `layoutControls` đổi; relay **giữ bit hidden/shown ngay trong process của mình** (không đọc file) [~/MEMORY.md mục QA180; ~/memory/2026-11-06.md mục work order QA180].
- **Hỏi (query/response)**: khi relay chưa biết trạng thái (mới nạp / mất đồng bộ), relay post `com.duoface.controls188.query`; host nhận query thì post lại `.hidden` hoặc `.shown` theo trạng thái hiện tại của nó [~/memory/2026-11-06.md, quote work order: "đăng ký nhận `com.duoface.controls188.query`: mỗi lần nhận query thì post lại notification tương ứng trạng thái hiện tại"].
- **Chiều ngược (app → host) cho tín hiệu chạm/wake**: hộp thư **DF156** — Darwin notify mang payload nén vào notify state; payload chạm gồm {bundle, count, ts}, throttle gửi 250ms. Chiều app→SB của DF156 đã được chứng minh trên máy từ QA176 (kbdiag: app ghi, SB đọc, 9 bản ghi) [~/memory/2026-11-03.md dòng 70]. Phía Chrome đăng ký wake tên `DF177TouchWakeName` trong `start` [~/memory/2026-11-03.md dòng 957].

### 1.4 Điều kiện cổng phía app (nuốt hay cho qua)

Cổng nằm trong relay, đánh giá tại hook `sendEvent:` cho dãy chạm đầu. Record wake của h1wake3 ghi đủ ba đầu vào của cổng trong trường `gate`: `known=<0/1> hidden=<0/1> kb=<0/1>` [~/memory/2026-11-06.md, mục trích work order QA180]. Nuốt chỉ khi **đồng thời**:

- **known = 1** — relay đang *biết chắc* trạng thái ẩn/hiện (đã nhận ít nhất một thông báo hidden/shown qua đẩy hoặc qua query/response). known = 0 → fail-open, không nuốt. Đây là bit mà bản h1wake1/2 gán cho hàm `DF188RefreshControlsHidden()`: hàm này chỉ set Known=YES khi đọc được key `ControlsHidden188` từ plist (xem thất bại 3.3) [~/memory/2026-11-06.md dòng 341].
- **hidden = 1** — controls hiện đang ẩn theo bit relay giữ trong process (nguồn: thông báo của host từ `layoutControls`). hidden = 0 (đang hiện) → chạm đi qua bình thường.
- **kb = 0 (không có phiên bàn phím)** — relay không được nuốt khi app đang trong phiên bàn phím, để cú chạm gõ phím/chạm vào trường nhập không bị ăn mất. Điều kiện này viết trong code h1wake1 là `!DF177KbComputeVisible()` (quét cửa sổ trong process); sang h1wake2 đổi thành **trạng thái phiên bàn phím** tại relay: bắt `UIKeyboardWillShow/HideNotification` + quét ban đầu chỉ tính frame bàn phím đã dựng với `origin.y > 0`, loại frame parked; h1wake3 **giữ nguyên** cổng phiên bàn phím của 179 [~/memory/2026-11-06.md, các mục test xe QA178 và QA179 h1wake2].

### 1.5 Chạm thứ hai đi qua bằng cách nào

- Sau cú chạm đầu bị nuốt, host đã gọi `noteUserActivity` → controls chuyển sang hiện và host post `com.duoface.controls188.shown` → bit trong relay lật thành hidden = 0. Từ đó cổng không thỏa nữa: hook `sendEvent:` chuyển tiếp mọi dãy chạm xuống app như bình thường (các record lúc này ghi `swallowed=0`) [suy ra trực tiếp từ chuỗi 1.2–1.4; log QA180: 35 record `swallowed=0` được hồ sơ diễn giải là "chạm bình thường khi controls đang hiện", ~/memory/2026-11-06.md dòng 346].
- Controls tự ẩn lại sau ~4s không hoạt động (`controlsUntil = now + 4.0`, dọn ở 4,05s) → host post `.hidden` → chu kỳ nuốt-chạm-đầu lặp lại [~/memory/2026-11-06.md, mục nền 171].

## 2. Danh sách hàm / hook / kênh liên quan (trích đúng tên từ hồ sơ)

| Tên | Ở đâu / process | Vai trò |
|---|---|---|
| `-[UIApplication sendEvent:]` (hook) | relay, trong process app được host | Điểm quan sát + điểm nuốt duy nhất sống trên xe: H1 chỉ-đọc (gốc chạy trước, đọc Began); h1wake+ thêm cổng nuốt tại đây [memory 03/11 d.71; 06/11 mục h1wake1] |
| `DFAppTouch177.h` | header chung, biên dịch vào cả hai relay | Chứa bộ gửi phía app (H1) + cổng nuốt (h1wake1) [memory 03/11 d.957; 06/11 d.275] |
| `DF177InstallAppTouchHook(bundle)` | gọi trong constructor của relay DF154 và relay YouTube | Cài hook `sendEvent:` + bộ gửi tín hiệu chạm cho đúng bundle [memory 03/11 d.957] |
| `DF155GeneralAppStateRelay.dylib` (class `DF154GeneralAppStateRelay`, file `DF154GeneralAppStateRelay.m`) | tiêm vào **14 app pilot** (gồm Maps, Waze) | Relay chung mang H1/cổng nuốt vào các app pilot [duoface-audit/TONG_HOP_DEB_VA_LOI.md; BISECT_PHIM_171_185.md] |
| relay YouTube riêng (`DFYouTubeOrientationRelay.m`) | process YouTube (YouTube **không** thuộc DF155) | Mang cùng bộ gửi qua header chung `DFAppTouch177.h` vì YouTube ngoài phạm vi DF155 [memory 03/11 d.70] |
| DF156 (mailbox Darwin, `DF156DarwinMailbox.h`) | kênh app → SB | Vận chuyển tín hiệu chạm/wake {bundle, count, ts}, throttle 250ms; một writer mỗi chiều [memory 03/11 d.70; duoface-audit/BAO_CAO_QUET_AZ_DUONAVI_VS_QA185.md d.72] |
| `DF177TouchWakeName` | đăng ký trong `start` của Chrome | Tên wake phía host cho tín hiệu chạm H1 [memory 03/11 d.957] |
| `DFNative12Chrome` (process SB) | host | Chủ trạng thái controls; receiver của wake; nơi `layoutControls` tính `controlsVisible` [memory 06/11 mục nền 171] |
| `noteUserActivity` | `DFNative12Chrome` | Đặt `controlsUntil = now + 4.0`, `borderUntil = now + 2.0`, gọi `layoutControls`, hẹn dọn sau 4,05s — hành động "đánh thức" phía host [memory 06/11 mục nền 171] |
| `layoutControls` | `DFNative12Chrome` | Nơi suy ra `controlsVisible = panActive \|\| logoTouchPending \|\| now <= controlsUntil`; điểm host phát hidden/shown khi trạng thái đổi (h1wake3) [memory 06/11; MEMORY.md mục QA180] |
| `df177HandleAppTouch` | `DFNative12Chrome` | Handler khi wake tới: gọi `noteUserActivity` nguyên dạng của nền 171 [memory 03/11 d.957] |
| `DFH1Wake188.m` (companion, host) | swizzle `start`/`stop`/`layoutControls` của `DFNative12Chrome` | Đăng ký wake DF156 (kiểm độ tươi + chống trùng → `noteUserActivity`); publish trạng thái controls: h1wake1 ghi plist key `ControlsHidden188` + post `com.duoface.controls188.state`; h1wake3 thay bằng cặp hidden/shown + trả lời query [memory 06/11 d.275 + mục work order QA180] |
| `com.duoface.controls188.hidden` / `.shown` / `.query` | Darwin notify, host ↔ relay | Kênh trạng thái của h1wake3: đẩy khi đổi + hỏi/đáp lấy trạng thái ban đầu [MEMORY.md mục QA180] |
| `com.duoface.controls188.state` | Darwin notify (chỉ h1wake1) | Kênh trạng thái đời đầu, đi kèm plist — bị thay ở h1wake3 [memory 06/11 d.275] |
| `DF188RefreshControlsHidden()` | relay | Đọc key `ControlsHidden188` trong `/var/mobile/Library/Preferences/com.duoface.nativehost.qa177.plist` để set bit Known — **điểm gãy của 178/179**, bị loại khỏi cổng ở h1wake3 [memory 06/11 d.341; mục work order QA180] |
| `DF177AppTouchEnabled()` | relay | Trả YES kể cả khi không đọc được plist (v=nil → YES) nên đường wake vẫn chạy ở 178/179 trong khi Known không bao giờ YES — hai hàm đọc cùng một plist nhưng xử lý lỗi ngược nhau [memory 06/11 d.341] |
| `DF177KbComputeVisible()` | relay (chỉ h1wake1) | Tính "bàn phím đang hiện" bằng quét `UIRemoteKeyboardWindow` — gây dương tính giả vĩnh viễn trong app được host (mục 3.2); bị thay bằng cổng phiên bàn phím ở h1wake2 [memory 06/11 mục đọc log 178] |
| `AppTouchRecall177` | key kill-switch trong plist qa177 | Vắng mặt = bật; cả hai phía (relay/host) đọc trực tiếp — thuộc H1 gốc [memory 03/11 d.71] |
| Marker log `qa177-app-touch` / `qa177-recall` | relay → host | Đếm chạm quan sát được / lần gọi lại thành công (recall chỉ ghi khi ẩn→hiện) [memory 03/11 d.71, d.106] |
| Marker log `qa188-h1-app-touch-wake` (trường `swallowed=`, về sau thêm `gate`) / `qa188-h1-controls-state` (trường `hidden=`) | relay / host | Bằng chứng định lượng cho cổng nuốt và lớp publish trạng thái ở các bản h1wake [memory 06/11 các mục test xe] |

## 3. Bằng chứng xe thật và các thất bại trên đường

### 3.0 QA176 — điểm chặn phía SB chết (nền của mọi thiết kế sau)
- QA176 H1 nối ở phía SB: H1(a) subscribe `DFSceneHostDidObserveTouchNotification` → `realAppTouched:` trong Chrome; H1(b) gắn observer thụ động vào mọi cửa sổ Chrome trong `makeWindow:` [~/memory/2026-11-03.md dòng 37, 274].
- Test xe FAIL: toàn log **0 dòng `qa120-hosted-touch-hit`** và **0 dòng `media-pane-hit-test-target`** dù có chạm thật trong pane (9 bản ghi bàn phím Maps). Dòng qa120 không bị throttle → `DFSceneSurface.hitTest` **không bao giờ chạy khi dùng thật**; thông báo `DFSceneHostDidObserveTouchNotification` post từ chính hitTest đó nên không bao giờ phát; recognizer cửa sổ cũng không thấy chạm route-theo-scene [~/workspace/duoface-audit/TONG_HOP_QA177.md, Vấn đề 1].

### 3.1 QA177 H1 — PASS lần đầu (phần "gọi lại", chưa có nuốt)
- Bản `0.0.177~apptouch1`; Nguyen test xe 03/11/2026 07:35, báo H1 PASS — "khắc phục được việc gọi lại logo di chuyển", gọi lại được kể cả khi logo đã dời vị trí [~/memory/2026-11-03.md dòng 98–101].
- Log xác nhận (export `DuoFaceAudit 3.txt`): **20 dòng `qa177-app-touch`** từ cả Maps (`com.google.Maps`) lẫn YouTube (`com.google.ios.youtube`), bộ đếm cộng dồn tăng dần, **+ 6 dòng `qa177-recall`** — chứng minh bộ gửi trong relay YouTube riêng cũng chạy thật, không chỉ nhóm DF155 [~/memory/2026-11-03.md dòng 106, 276].
- H1 sau đó được port nguyên văn vào nền QA171 thành QA172 `logorecall1` (4 mảnh: `DFAppTouch177.h` mới; sender trong `DF154GeneralAppStateRelay.m`; sender trong `DFYouTubeOrientationRelay.m`; receiver trong `DFNative12Chrome.m`) [~/memory/2026-11-03.md dòng 957; ~/MEMORY.md mục chạm logo]. Hai nhánh phụ trên nền 172: wakefix1 FAIL xe; wakefix2 chưa test xe rồi bị hoàn nguyên (05/11) [~/MEMORY.md mục chạm logo].

### 3.2 QA178 `0.0.178~h1wake1` — gọi được logo, nuốt không kích hoạt lần nào (dương tính giả bàn phím)
- Test xe (~18:15 06/11): gọi được logo nhưng **cú chạm vẫn ăn vào app đồng thời** [~/memory/2026-11-06.md, mục test xe QA178].
- Đọc log phiên (`DuoFaceAudit 6.txt`, main @ `ed7e2c1125`): lớp publish phía host **không lỗi** — marker `qa188-h1-controls-state` lật `hidden=1`/`hidden=0` đúng từng chu kỳ; nhưng **cả 14/14 record `qa188-h1-app-touch-wake`** (Facebook 12, Maps 2) đều `swallowed=0` [~/memory/2026-11-06.md, mục đọc log 178].
- Thủ phạm chốt từ code + log: điều kiện nuốt là `DF188ControlsHiddenKnown && DF188ControlsHidden && !DF177KbComputeVisible()`. `DF177KbComputeVisible()` vay snapshot báo cáo bàn phím cũ: cửa sổ `UIRemoteKeyboardWindow` nào không ẩn trong danh sách quét đều tính là "bàn phím đang hiện". Trong app được host, cửa sổ này **tồn tại thường trực** ở trạng thái h0/alpha 1.0 với frame dựng sẵn kể cả khi không có bàn phím trên màn hình (bằng chứng: chính các dòng kbdiag trong cùng log) → cổng tưởng lúc nào cũng đang gõ phím, **tự ngắt vĩnh viễn ở mọi app** [~/memory/2026-11-06.md, mục đọc log 178].

### 3.3 QA179 `0.0.179~h1wake2` — FAILED 0/24; nguyên nhân gốc là sandbox của plist, không phải bàn phím
- GPT triển khai theo hướng đã chốt: trạng thái **phiên bàn phím** tại relay (`UIKeyboardWillShow/HideNotification` + quét ban đầu chỉ tính frame đã dựng `origin.y > 0`, loại frame parked). Muse diff trực tiếp file cổng `DFAppTouch177.h` nhánh 179 so với 178: GPT triển khai đúng thiết kế, phần còn lại không đổi [~/memory/2026-11-06.md, mục QA179 h1wake2].
- Test xe vẫn FAILED: chạm vẫn click xuyên vào app. Log (`DuoFaceAudit 7.txt`, main @ `949b91f561`): **0/24 record `qa188-h1-app-touch-wake` có `swallowed=1`** (YouTube, Waze, Facebook); marker `qa188-h1-controls-state` phía host vẫn lật hidden=1/0 đúng chu kỳ [~/memory/2026-11-06.md, mục QA179; ~/MEMORY.md mục TEST XE QA178–QA180].
- **Nguyên nhân gốc xác định ở mức code** (thay thế kết luận "thủ phạm là cổng kb" của phiên 178 — kb chỉ còn nghi phạm phụ): `DF177AppTouchEnabled()` trả YES khi **không** đọc được plist (v=nil → YES) nên đường wake vẫn chạy bình thường trong relay; trong khi `DF188RefreshControlsHidden()` chỉ set Known=YES khi đọc được key `ControlsHidden188`. File `/var/mobile/Library/Preferences/com.duoface.nativehost.qa177.plist` **nằm ngoài sandbox của app App Store**, mà cả 4 app đã test (Facebook, Maps, YouTube, Waze) đều là app App Store → **Known không bao giờ YES trong relay → cổng nuốt không đóng ở cả 178 lẫn 179** [~/memory/2026-11-06.md dòng 341; ~/MEMORY.md mục TEST XE].

### 3.4 QA180 `0.0.180~h1wake3` — ĐẠT cả hợp đồng (verdict xe + log)
- Thay đổi duy nhất so với 179: **kênh truyền trạng thái** — bỏ đọc plist ở phía relay, chuyển sang cặp Darwin hidden/shown + query/response; relay giữ bit trong process; giữ nguyên H1, cơ chế nuốt và cổng phiên bàn phím của 179; record wake ghi thêm trường `gate` [~/memory/2026-11-06.md, mục STATE CHANGE QA180].
- **Nguyen báo 06/11/2026 ~20:47: ĐÃ SỬA ĐƯỢC LỖI GỌI LOGO** — chạm đầu chỉ gọi logo, không còn click xuyên vào app; mục logo A1→A2 coi như ĐẠT [~/memory/2026-11-06.md, mục QA180; ~/MEMORY.md mục TEST XE].
- Muse đọc log khép hồ sơ (~20:50, `DuoFaceAudit 8.txt`, main @ `8b232ebff7`, build `0.0.180~h1wake3`): **12 record `swallowed=1`** (Waze + Facebook, nhiều chu kỳ liên tiếp), **35 record `swallowed=0`** (chạm bình thường khi controls đang hiện), trường `gate` cho thấy **known=1** — kênh Darwin notify chạy đúng thiết kế [~/memory/2026-11-06.md dòng 346; ~/MEMORY.md mục TEST XE].

## 4. Điều kiện tiên quyết kiến trúc (nêu dạng điều kiện, theo đúng hồ sơ)

1. **Phải có dylib relay sống trong process của chính app được host.** Phạm vi hiện diện quyết định app nào gọi lại được: DF155 phủ 14 app pilot (gồm Maps, Waze); YouTube ngoài DF155 nên phải có relay riêng mang cùng header; **app không có relay nào (GOFA, app thứ ba khác) thì không gọi lại được nút** — nêu thẳng ở Bước 0 QA177 [~/memory/2026-11-03.md dòng 70].
2. **Điểm quan sát/nuốt chạm phải nằm trong process app**, vì chạm vào nội dung scene được route theo scene thẳng tới app, không qua hit-test cửa sổ slot phía host — điểm chặn phía host đã chết trên xe ở QA176 (mục 3.0).
3. **Trạng thái ẩn/hiện phải phát từ đúng điểm host đổi layout**: host là chủ trạng thái và phải phát hidden/shown ngay tại `layoutControls` — nơi `controlsVisible` được suy ra — để bit phía relay không lệch pha với hình thật [~/MEMORY.md mục QA180; ~/memory/2026-11-06.md mục nền 171].
4. **Kênh trạng thái phải xuyên được sandbox của app App Store**: file plist dùng chung trong `/var/mobile/Library/Preferences` không đọc được từ trong app → kênh khả thi là Darwin notify (đẩy) + query/response (lấy trạng thái ban đầu), relay giữ bit trong process (bài học 3.3).
5. **Kênh phải hai chiều và có hỏi/đáp**: app → host mang tín hiệu chạm/wake (DF156); host → app mang trạng thái (hidden/shown); cộng query/response để relay mới nạp hoặc mất đồng bộ vẫn lấy được trạng thái hiện tại thay vì đoán.
6. **Cổng nuốt phải fail-open khi không biết trạng thái**: known là điều kiện bắt buộc — trạng thái không rõ thì cho chạm qua như H1 chỉ-đọc, không nuốt mù (thiết kế h1wake1) [~/memory/2026-11-06.md, mục h1wake1-work].
7. **Trạng thái bàn phím phải đo bằng phiên (session) tại relay**, không bằng sự hiện diện của cửa sổ bàn phím: trong app được host cửa sổ remote keyboard tồn tại thường trực với frame dựng sẵn — quét cửa sổ cho dương tính giả vĩnh viễn (bài học 3.2); bản đạt dùng WillShow/Hide + frame origin.y > 0 (bài học 3.3).
8. **Phía host phải coi wake là hoạt động người dùng thật**: handler wake gọi `noteUserActivity` để gia hạn cửa sổ hiện controls (`controlsUntil = now + 4.0`) và layout lại — nếu host chỉ ghi nhận mà không đổi layout thì logo không hiện dù cổng phía app đúng [~/memory/2026-11-06.md, mục nền 171].

## 5. Nguồn đã đọc

- `~/MEMORY.md` — mục "Chạm đánh thức logo (Nguyen chốt 04/11/2026 21:47…)" và mục "TEST XE QA178–QA180 (06/11)".
- `~/memory/2026-11-03.md` — thiết kế H1 QA176/QA177, Bước 0, verdict test máy QA177, bản đồ port 172R.
- `~/memory/2026-11-06.md` — thiết kế h1wake1, đọc log QA178, QA179 h1wake2 + nguyên nhân gốc sandbox, work order và verdict QA180 h1wake3.
- `~/workspace/duoface-audit/TONG_HOP_QA177.md` — Vấn đề 1: nguồn tín hiệu SB chết, hướng đổi sang phía app.
- `~/workspace/duoface-audit/BUOC0_QA180.md` — cấu trúc relay DF154/DF156 (`DF154GeneralAppStateRelay.m`, `DF156DarwinMailbox.h`, `DF155PilotAppScope.h`).
- `~/workspace/duoface-audit/BAO_CAO_QUET_AZ_DUONAVI_VS_QA185.md`, `BISECT_PHIM_171_185.md`, `TONG_HOP_DEB_VA_LOI.md` — kiến trúc 10 dylib theo process, phạm vi DF155 14 app, DF156 một writer mỗi chiều, hook `sendEvent:` là delta duy nhất của relay ở QA177.
- `~/workspace/deb-ho-so/duonavi-1.0.3-12/HO_SO.md` và `duoface-goc-1.0.4-1/HO_SO.md` — chỉ dùng để đối chiếu vai trò tài sản logo; chuẩn nuốt của DuoNavi trong hồ sơ dự án được ghi là suy luận từ quét tĩnh (mục 0).
