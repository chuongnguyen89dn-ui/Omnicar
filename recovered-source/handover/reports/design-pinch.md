# THIẾT KẾ PHẦN A — PINCH FULLSCREEN (chỉ-đọc, 2026-11-09)

> Đầu vào: `study-pinch-fullscreen.md` (địa hình chạm, 3 nghĩa fullscreen, saga),
> `audit-runtime.md` (kiểm kê, bản đồ đối tượng), source rebuilt
> `project/OmniCarSplitScreen/`. Mọi quyết định của GPT đã khóa — tài liệu này
> không bàn lại, chỉ cụ thể hoá tới mức strand cài đặt không phải đoán.
> Nhãn: **[SRC]** = đọc trực tiếp từ source rebuilt kèm file:line;
> **[ĐO]** = bằng chứng xe/saga; **[A1]** = chờ kết quả strand A1.

## 0. Các khoá đã chốt mà thiết kế phải tôn trọng (tóm tắt)

- Đích = fullscreen-ẩn-dock của QA20 (nghĩa (c)); **cấm** đường
  `appbridge.baraction` 'full' (nó gọi `runSoloForPane:` = solo, sai nghĩa).
- Nhận diện ưu tiên tầng CarPlayApp; in-app chỉ là điểm probe dự phòng.
- **Không** giữ cặp từ Began kiểu Cách A: cặp không đủ bằng chứng phải
  nguyên vẹn cho app. Hệ quả thiết kế (mục 3): recognizer là
  *quan sát–rồi–bắn lệnh*, không bao giờ withholding.
- Ngưỡng: out ≥ 1,10; in ≤ 0,90; midDrift ≤ 0,6×distChange + 10; tối đa
  1 lệnh/gesture; không ghép cặp xuyên window/scene; reset khi
  cancel/teardown/đổi scene/mất CarPlay.
- Allowlist app+scene; YouTube / Maps / Waze hosted / WebView / chưa xác
  minh = OFF mặc định. PINCH_MODE độc lập WAKE_MODE.
- Phân xử: EXPANDED → pinch-in ưu tiên + wake suppression tắt;
  SPLIT+HIDDEN → wake thắng, không nhận pinch từ nội dung;
  SPLIT+VISIBLE → pinch nếu allowlist.

## 1. Điểm gắn recognizer phía CarPlayApp

### 1.1 Điểm gắn: chính `SCPCarSplitView` (container của split)

Gắn một **custom recognizer** (subclass `UIGestureRecognizer`, tự theo dõi
pha theo từng touch — lý do ở mục 3.1) lên view container:

- `SCPCarSplitView` là *root container view của toàn bộ layout split*
  **[SRC]** `SCPCarSplitView.h` (subclass UIView, ivar duy nhất là block
  `touched`); instance thuộc sở hữu của singleton qua
  `-[SCPCarSplit container]` **[SRC]** `SCPCarSplit.h:47`.
- Container được tạo và gắn vào cây view của dashboard trong
  `-[SCPCarSplit ensureContainer]` **[SRC]** `SCPCarSplit.m:280-335`:
  superview là parent của `baseContainerView` của
  `DBDashboardRootViewController`, frame = `appAreaInParent:`. Mọi pane
  (`pane.view`), mọi divider và float pane đều là con/cháu của container
  này — không tồn tại bề mặt split nào nằm ngoài nó.
- Container **chỉ tồn tại trên cửa sổ màn xe trong process CarPlayApp**.
  Process CarPlayApp không nhận chạm từ màn iPhone (chạm điện thoại đi
  đường SpringBoard/app — xem mục 2.3), nên mọi touch tới được recognizer
  này mặc nhiên là touch CarPlay.

### 1.2 Vì sao điểm này nhận đủ Began/Moved/Ended của cùng một cặp

Chuỗi bằng chứng, không suy luận trần:

1. `-[SCPCarSplitView hitTest:withEvent:]` **[SRC]**
   `SCPCarSplitView.m:14-19` chuyển super và — mỗi khi hit test tìm được
   view đích cho một touch event — gọi block `touched(point, hitView)`.
   Tức **mọi touch đáp xuống bất kỳ đâu trong container đều duyệt qua
   hitTest của chính container**: đường phân phối sự kiện của UIKit cho
   cửa sổ này đi qua container trước khi tới view con.
2. Recognizer gắn trên một view tổ tiên nhận các touch có hit view nằm
   trong cây con của nó (cơ chế chuẩn của UIKit gesture delivery). Hit
   view của pane hosted là scene-host view — vẫn là con của container
   trong cùng cửa sổ CarPlayApp — nên cặp touch trên ô hosted nằm trong
   phạm vi theo dõi của recognizer gắn ở container, kể cả khi app tự có
   recognizer riêng trên bề mặt scene (hai recognizer cùng nhận, không
   ai bị mù — đúng bản chất "tranh chấp" đã ghi ở study mục 2.3, và là
   lý do allowlist tồn tại).
3. **[ĐO]** Tầng phân phối sự kiện của CarPlayApp thấy và giữ được chạm
   trên ô hosted (saga bản 21–35 + 32, study mục 2.1). Recognizer ở
   container đứng *dưới* tầng đó trong cùng đường phân phối (hitTest →
   recognizer → view đích), không phụ thuộc `UIApplication sendEvent:` —
   điểm mù đã đo của process app không liên quan tới điểm gắn này.
4. **[ĐO]** Nhảy liên process không tham gia: recognizer, `SCPCarSplit`
   và (theo A1) adapter đều trong CarPlayApp — độ trễ tín hiệu = 0
   (study mục 3.1 phương án C).

### 1.3 Gắn/gỡ theo vòng đời — không một recognizer nào sống vô điều kiện

| Sự kiện | Hành động | Neo nguồn |
|---|---|---|
| `ensureContainer` thành công (container vừa tạo + addSubview) | Tạo controller (mục 7), gắn recognizer vào container | `SCPCarSplit.m:280-335` **[SRC]** |
| Split active bật (`active` = YES, `+[SCPCarSplit shared]`) | Controller arm (bắt đầu theo dõi; vẫn bị PINCH_MODE + phân xử chặn ở tầng quyết định) | `SCPCarSplit.h:31,98` **[SRC]** |
| `active` = NO / phiên kết thúc | Disarm + reset tracking (mục 3.4) | như trên |
| `dashboardInvalidated` (teardown toàn phiên) | Gỡ recognizer khỏi container, huỷ controller | `SCPCarSplit.h:105` **[SRC]** |
| Container đổi frame/bounds (relayout, expand/restore của QA20 làm container phình/co) | Reset tracking giữa chừng (mục 3.4) — tỉ lệ khoảng cách đo trong toạ độ container phải cùng một hệ quy chiếu từ đầu tới cuối gesture | hệ quả hình học |
| Mất CarPlay / dashboard root biến mất | Tương đương teardown: gỡ + reset | — |

Điểm neo cài đặt cụ thể để strand tích hợp dùng: seam hook sẵn có trong
`SCPHooks.m` (đoạn ~317-320 đã gọi `[[SCPCarSplit shared] rootDidLayout]`
sau orig) + hai điểm gọi keo ở `ensureContainer` và `dashboardInvalidated`
— chi tiết phân quyền file ở mục 7.

### 1.4 Các cấm tuyệt đối — thiết kế thoát cả ba theo cấu trúc

- **Không trong dispatch của `sendEvent:`**: recognizer gắn ở thời điểm
  vòng đời phiên (bảng 1.3), chạy trên đường gesture delivery chuẩn của
  UIKit. Không hook `sendEvent:` ở bất kỳ tầng nào cho pinch.
- **Không keyboard/alert window**: view đích là container split do chính
  dự án sở hữu; cửa sổ bàn phím và alert thuộc cửa sổ khác, không phải
  tổ tiên/hậu duệ của container — recognizer không thể thấy chúng.
- **Không nạp vô điều kiện**: controller chỉ tồn tại khi container tồn
  tại và chỉ arm khi split active; process khác (kể cả SpringBoard, nơi
  dylib SplitScreen cũng nạp) không có container dashboard →
  controller không bao giờ được tạo ở đó.

## 2. Nhận diện phiên / scene / app

### 2.1 Cặp chạm thuộc ô nào, app nào

Ánh xạ điểm → pane dùng lại đúng thuật toán đã có trong block `touched`
của container **[SRC]** `SCPCarSplit.m:305-322`: duyệt `self.slots`,
bỏ qua pane có `pane.view.alpha <= 0`, kiểm
`CGRectContainsPoint(pv.frame, point)` trong toạ độ container; float
pane kiểm trước và thắng nếu điểm nằm trong nó. Mỗi pane cho sẵn:

- `bundleID` **[SRC]** `SCPCarPane.h:42` — khoá chính cho allowlist.
- `slot` (41), `vc` (43), `view` (44) — phân biệt scene native (VC nằm
  trong CarPlayApp) với scene hosted (đường AppBridge host) bằng cùng
  kiểm `SCPVCIsHosted(pane.vc)` mà `hostedPanes` đã dùng
  **[SRC]** audit-runtime §2 (`SCPCarSplit.m:2138`). Allowlist khóa
  theo **(bundleID, loại scene)** — cùng một app (Maps) có hai kết
  luận ngược nhau tuỳ scene (study mục 2.3), nên bundle đơn thuần là
  không đủ.

Quy tắc cặp: tại thời điểm cặp hình thành (mục 3), lấy điểm bắt đầu của
**từng** ngón trong toạ độ container, ánh xạ độc lập. Cặp chỉ hợp lệ
khi cả hai ngón ánh xạ về **cùng một pane**; khác pane → không phải
gesture của một bề mặt → loại (đây là dạng cụ thể của khoá "không ghép
cặp xuyên scene": hai pane trong cùng container vẫn là hai scene khác
nhau). Ngón bắt đầu ngoài mọi pane (divider, vùng chrome, float che)
→ cặp loại, trừ khi cả hai ngón cùng bắt đầu trên divider — trường hợp
đó thuộc gesture của divider (đã có pan/double-tap riêng **[SRC]**
`SCPCarSplit+Divider.m:80,364`), pinch controller không xử lý.

### 2.2 Phiên hợp lệ

Controller chỉ quyết định khi đồng thời: split `active` = YES;
container còn trong cửa sổ (`container.window != nil`); pane ánh xạ
được còn thuộc về assignment hiện tại (pane còn trong `slots` tại thời
điểm bắn lệnh — kiểm lại lần cuối trước khi gọi adapter, vì assignment
có thể đổi giữa gesture). Mất một điều kiện → fail-open im lặng (log ở
DRY_RUN), không lệnh.

### 2.3 Chạm iPhone vs chạm CarPlay

Phân biệt ở **ranh giới process**, không cần suy luận hình học:

- Recognizer sống trong CarPlayApp, gắn trên view thuộc cửa sổ màn xe.
  Sự kiện chạm trên màn hình iPhone không bao giờ được phân phối vào
  cửa sổ đó — chúng thuộc SpringBoard/app trên điện thoại. Mọi touch
  recognizer này thấy đều là touch CarPlay theo cấu trúc.
- Kiểm phụ tại thời điểm arm: `container.window` phải là cửa sổ của
  dashboard xe (cùng cửa sổ mà `ensureContainer` đã gắn vào cây của
  `DBDashboardRootViewController`). Nếu container không có window
  hoặc window đổi khác → disarm.
- Điểm probe dự phòng in-app (mục 6) thì ngược lại: nó nằm trong
  process app và phải tự phân biệt bằng trạng thái được-host — đó là
  lý do nó chỉ là dự phòng/đo, không phải điểm quyết định.

## 3. Máy nhận dạng

### 3.1 Vì sao custom recognizer, không phải UIPinchGestureRecognizer

`UIPinchGestureRecognizer` không cho: danh tính/pha của từng touch,
điểm bắt đầu của từng ngón (cần cho quy tắc cùng-pane ở 2.1 và cho
midDrift theo cặp), hay thời điểm ngón 2 chạm xuống (cần cho phân xử
ngón-lệch-thời-gian ở 3.3). Controller vì vậy dùng subclass
`UIGestureRecognizer` tự ghi sổ trong `touchesBegan/Moved/Ended/
Cancelled`. Cấu hình bắt buộc, không thương lượng:

- `cancelsTouchesInView = NO`, `delaysTouchesBegan = NO`,
  `delaysTouchesEnded = NO` — recognizer **không giữ, không huỷ,
  không trì hoãn** bất kỳ touch nào. Nó là người quan sát chạy song
  song trên đường phân phối; app nhận cặp nguyên vẹn trong mọi
  trường hợp, kể cả gesture mà nó kết luận là pinch (hệ quả đã chấp
  nhận của khoá "không giữ cặp": trên bề mặt allowlist — nơi app
  không có pinch riêng — việc app cũng nhận cặp là vô hại; trên bề
  mặt có pinch riêng thì app đó không nằm trong allowlist).

### 3.2 Sổ theo dõi cặp và trạng thái

Trạng thái nội bộ (reset theo 3.4):

- `t1, t2`: hai UITouch đầu tiên (theo thứ tự Began) mà điểm bắt đầu
  ánh xạ về cùng một pane hợp lệ. Touch thứ ba xuất hiện → huỷ theo
  dõi gesture hiện tại (không bắn lệnh), chờ mọi touch kết thúc.
- `pane`: pane chung đã khoá + `bundleID` + loại scene tại Began.
- `dist0`: khoảng cách hai ngón tại thời điểm ngón 2 Began (lấy vị
  trí hiện tại của t1 lúc đó, không phải vị trí Began gốc của t1 —
  ngón 1 có thể đã trượt trước khi ngón 2 xuống).
- `mid0`: trung điểm của cặp tại cùng thời điểm đó.
- `fired`: đã bắn lệnh cho gesture này hay chưa (tối đa 1 lệnh).

Trạng thái máy: `IDLE → TRACKING (1 ngón) → PAIRED (đủ cặp, chưa qua
ngưỡng) → FIRED | DEAD (loại) → IDLE (khi mọi touch đã kết thúc)`.

Tại mỗi Moved khi đang PAIRED, tính `dist`, `scale = dist/dist0`,
`distChange = |dist − dist0|`, `midDrift = |mid − mid0|` (Euclid).
Điều kiện hình học (cả hai phải đúng cùng lúc):

- Hướng ra: `scale ≥ 1,10`; hướng vào: `scale ≤ 0,90`.
- Chiếm ưu thế: `midDrift ≤ 0,6 × distChange + 10` (phân biệt véo
  với kéo/xoay hai ngón — thuật toán saga, study mục 3.3).

### 3.3 Điểm phát lệnh duy nhất và phân xử với Wake

Lệnh chỉ được phát tại **một điểm**: lần Moved đầu tiên mà điều kiện
hình học (3.2) thoả, sau khi qua đủ các cổng dưới đây theo thứ tự —
trúng cổng nào thì chết ở cổng đó, ghi lý do (DRY_RUN log cả khi qua):

1. **PINCH_MODE**: OFF → không theo dõi từ đầu; DRY_RUN → chạy hết
   máy, ghi `wouldPinch` thay vì bắn; ENFORCE → được bắn.
2. **Trạng thái host**: đang SPLIT thì chỉ xét pinch-out; đang
   EXPANDED (đọc từ adapter, mục 4) thì chỉ xét pinch-in. Lệnh ngược
   trạng thái = không hợp lệ.
3. **Phân xử Wake** (hỏi owner phân xử dùng chung — interface ở 3.5):
   - SPLIT + controls HIDDEN → **chết**: pinch từ nội dung app không
     được nhận. Đây cũng là đáp án cho ngón-lệch-thời-gian: nếu ngón 1
     xuống khi HIDDEN, Wake xử lý ngón 1 theo luật của nó; khi ngón 2
     xuống sau đó, cặp vẫn bị cổng này chặn vì trạng thái tại thời
     điểm *hình thành cặp* là HIDDEN — recognizer không cần (và
     không được) giữ ngón 1 để "chờ" pinch. Nếu Wake đã nuốt ngón 1
     (chuỗi bị suppression giữ), cặp càng không hợp lệ: một touch
     thuộc chuỗi bị giữ không bao giờ được tính vào cặp (cổng 4).
   - SPLIT + controls VISIBLE → qua.
   - EXPANDED → wake suppression đã tắt theo phân xử; pinch-in qua.
   - Trạng thái không rõ/UNKNOWN → chết (fail-open cả hai phía).
4. **Chuỗi sạch**: cả t1, t2 đều không thuộc chuỗi đang bị wake
   suppression giữ, không thuộc native gesture đang chạy (divider
   pan, handle pan — controller kiểm qua trạng thái mà owner phân
   xử công bố), không bắt đầu từ keyboard/popup (điểm bắt đầu ánh
   xạ về pane nội dung là điều kiện cần — 2.1 đã loại chrome).
5. **Allowlist**: (bundleID, loại scene) có trong allowlist ENFORCE
   đã kiểm thử. Ngoài allowlist → chết (DRY_RUN vẫn ghi wouldPinch
   kèm lý do `not-allowlisted` để có số liệu mở rộng danh sách).

Qua đủ 5 cổng → gọi adapter (mục 4) đúng một lần, đặt `fired = YES`.

### 3.4 Reset

Reset toàn bộ sổ (về IDLE, xoá t1/t2/dist0/mid0/fired) khi: bất kỳ
touch nào của cặp Cancelled; teardown phiên; đổi scene/assignment
(slots thay đổi bản chất); mất CarPlay; container đổi bounds giữa
gesture (1.3); hoặc mọi touch đã Ended và trạng thái không còn
TRACKING. Không bắn lệnh từ trạng thái vừa reset.

### 3.5 Interface phân xử (điểm chạm duy nhất với phần Wake)

Controller không tự biết trạng thái controls; nó hỏi owner phân xử
dùng chung của vòng wake qua một interface hẹp (phía wake sở hữu
định nghĩa chi tiết trong `design-bridgewake.md`; ở đây chỉ chốt
hình dạng phía pinch cần):

```objc
typedef NS_ENUM(NSInteger, SCPArbiterDisposition) {
    SCPArbiterPinchAllowed,        // SPLIT+VISIBLE, hoặc EXPANDED cho pinch-in
    SCPArbiterPinchBlockedHidden,  // SPLIT+HIDDEN — wake thắng
    SCPArbiterPinchBlockedUnknown // trạng thái không rõ / keyboard / popup / native gesture
};
- (SCPArbiterDisposition)pinchDispositionForPane:(SCPCarPane *)pane
                               touchesSuppressed:(BOOL)anyTouchSuppressed;
- (BOOL)hostIsExpanded;  // chuyển tiếp từ adapter (mục 4), owner phân xử giữ bản sao trạng thái này
```

`anyTouchSuppressed` do controller tự biết từ sổ của nó kết hợp cờ
mà phía wake công bố cho chuỗi hiện tại; khi nghi ngờ → coi như YES
(chết ở cổng 4).

## 4. Giao diện adapter tới bộ điều khiển fullscreen QA20

### 4.1 Nguyên tắc: protocol trước, binding sau

Entry điều khiển của dylib QA20 **chưa biết** — strand A1 đang chứng
minh (OMCToggleHost là hàm static trong source tham chiếu; không
được giả định export). Thiết kế vì vậy chốt một **protocol trừu
tượng** ở phía CarPlay; controller (mục 3) chỉ nói chuyện với
protocol này. Binding cụ thể (selector/kênh nào của QA20) do A1
quyết và chỉ thay thân của adapter, không thay một dòng nào của
controller hay của phân xử.

### 4.2 Hình dạng interface (chốt)

```objc
typedef NS_ENUM(NSInteger, SCPFullscreenState) {
    SCPFullscreenStateUnknown = 0,  // không đọc được — mọi quyết định fail-open
    SCPFullscreenStateSplit,
    SCPFullscreenStateExpanded
};

@protocol SCPFullscreenControlling <NSObject>
/// Đọc đồng bộ trạng thái hiện tại. Unknown nếu A1 không tìm được
/// đường đọc an toàn — cấm đoán từ trạng thái nội bộ song song.
- (SCPFullscreenState)currentState;
/// Yêu cầu mở fullscreen (chỉ hợp lệ khi currentState == Split).
/// completion: YES = giao diện đã thực sự đổi (khớp máy trạng thái
/// A6: EXPANDING → EXPANDED chỉ xác nhận khi UI đổi xong).
- (void)requestExpandWithCompletion:(void (^)(BOOL applied))completion;
/// Yêu cầu phục hồi về split (chỉ hợp lệ khi currentState == Expanded).
- (void)requestRestoreWithCompletion:(void (^)(BOOL applied))completion;
/// Gọi mỗi khi trạng thái đổi từ bất kỳ nguồn nào (kể cả người dùng
/// tự thoát bằng cơ chế riêng của QA20 — adapter phải nghe được
/// thay đổi không do mình gây ra, nếu A1 tìm thấy tín hiệu đó;
/// nếu không có tín hiệu, owner phân xử phải chấp nhận trạng thái
/// có thể cũ và định kỳ đối chiếu ở các điểm vòng đời phiên).
@property (nonatomic, copy, nullable) void (^stateDidChange)(SCPFullscreenState newState);
@end
```

### 4.3 Nơi sống

- File mới `SCPFullscreenAdapter.h/.m` trong module
  `OmniCarSplitScreen` (cùng process CarPlayApp với controller và
  với dylib QA20 khi nó nạp). Class `SCPFullscreenAdapter` implement
  protocol; cách nó gọi QA20 nằm kín trong file này.
- Nếu A1 kết luận **BLOCKED** (không entry an toàn): adapter vẫn
  được cài với thân rỗng có kỷ luật — `currentState` luôn Unknown,
  mọi request trả completion(NO) — và hệ quả tự động: cổng 2 ở 3.3
  không bao giờ qua cho pinch-out, PINCH ENFORCE không thể arm.
  Không cần sửa controller để "tắt" pinch; thiết kế tự khoá.
- Adapter **không** tạo máy trạng thái expanded thứ hai cạnh tranh
  với QA20: `currentState` là bản đọc từ nguồn của QA20 (theo A1),
  không phải biến tự duy trì theo lệnh mình đã gửi. Bản sao trạng
  thái mà owner phân xử giữ (3.5) chỉ là cache phục vụ quyết định,
  nguồn sự thật vẫn là adapter.

## 5. Đường thoát dự phòng khi EXPANDED (A6)

### 5.1 Vấn đề phải trả lời trước khi bật pinch-out ENFORCE

Khi host đã EXPANDED, container phình lên toàn cửa sổ và chrome bị
ẩn theo cơ chế QA20. Nếu cặp pinch-in không tới được recognizer
(khung hình đổi làm đường phân phối khác đi, hoặc recognizer bị
disarm nhầm), người dùng phải còn đường thoát **đã kiểm chứng** —
không phụ thuộc vào chính pinch.

### 5.2 Các ứng viên (xếp theo mức độc lập với pinch)

1. **Cơ chế thoát riêng của chính QA20 — double-tap divider.**
   Dylib QA20 là "DoubleTapFullscreen": cử chỉ gốc của nó là chạm
   đôi lên divider để toggle fullscreen [SAGA]. Nếu A1 xác nhận cử
   chỉ đó vẫn hoạt động trong trạng thái EXPANDED (divider còn
   trong cây view và còn nhận chạm khi chrome đã ẩn — lưu ý tín
   hiệu ẩn thật của QA20 là opacity của divider, view không bị gỡ
   khỏi hierarchy theo hồ sơ saga), đây là đường thoát dự phòng
   chính: độc lập với recognizer mới, đã có tiền lệ dùng thật.
   *Điều kiện nghiệm thu: A1 nêu được bằng chứng tĩnh + Gate 3
   kiểm trên xe ở trạng thái EXPANDED.*
   Lưu ý tránh nhầm: `dividerDoubleTapped:` của **bản rebuilt**
   **[SRC]** `SCPCarSplit+Divider.m:364` là *đổi chỗ hai ô* (swap),
   không phải thoát fullscreen — hai cơ chế double-tap cùng tồn tại
   trên cùng divider là một điểm A1 phải phân định (QA20 hook đè
   lên class nào, thứ tự hook ra sao).
2. **Wake-theo-chạm của QA20 (activity → hiện chrome).** QA20 có
   timer/relay riêng sơn lại handle/divider/knob khi có activity
   (audit-runtime §1b). Khi chrome hiện lại, các nút trên thanh
   (gồm đường về split qua UI thường ngày) chạm được. Ứng viên này
   phụ thuộc QA20 còn nguyên cơ chế activity — A1 kiểm kê đã xác
   nhận chúng là một phần của gói QA20.
3. **Ngắt/kết nối lại CarPlay hoặc thoát split** — đường thoát
   thô cuối cùng (teardown phá mọi trạng thái). Chỉ ghi nhận là
   tầng cuối, **không** tính là đường thoát đạt chuẩn cho Gate 3.

### 5.3 Khoá cứng

**Pinch-out ENFORCE bị cấm bật** cho tới khi ít nhất ứng viên 1
hoặc 2 được A1 chứng minh tĩnh *và* Gate 3 (pinch độc lập, Wake
OFF) kiểm chứng trên xe ở trạng thái EXPANDED: vào được bằng
pinch-out thì phải ra được bằng đường dự phòng mà không cần
pinch-in. Chưa có → PINCH_MODE tối đa DRY_RUN, dù recognizer và
adapter đều đã xong.

## 6. Probe Gate 2 (DRY_RUN) — hai điểm đo

### 6.1 Điểm CarPlayApp (điểm chính, thuộc controller này)

PINCH_MODE = DRY_RUN: máy nhận dạng (mục 3) chạy đầy đủ, thay lệnh
bằng một dòng log qua `OMCLogWrite(@"SplitScreen", …)` tại điểm
phát lệnh duy nhất (3.3) và tại mỗi lần cặp chết ở một cổng. Trường
bắt buộc mỗi gesture kết thúc (kể cả bị loại):

- `seq` (số thứ tự gesture trong phiên), `pane slot`, `bundleID`,
  loại scene (hosted/native);
- `dist0`, `scaleMax` (hoặc `scaleMin` cho hướng vào), `midDrift`
  tại thời điểm kết luận, hướng (out/in);
- kết luận từng cổng: mode / host-state / arbiter / clean-chain /
  allowlist → `wouldPinch = 0/1` + lý do chết đầu tiên;
- đếm tổng kết phiên: số cặp đủ Began/Moved/Ended trọn vẹn / số cặp
  cụt (chứng minh điểm gắn thấy đủ cặp — câu hỏi Gate 2 của WO);
  đếm riêng cho trạng thái SPLIT và EXPANDED (không suy diễn qua
  lại giữa hai trạng thái).

Không log toạ độ tuyệt đối của touch (chỉ khoảng cách/tỉ lệ/trung
điểm tương đối), không log nội dung app.

### 6.2 Điểm in-app (dự phòng — chỉ nêu yêu cầu giao diện)

Điểm quan sát in-app dùng chung điểm với probe của wake (hook
`sendEvent:` trong ABInApp do phía wake thiết kế —
`design-bridgewake.md`). Phía pinch chỉ đặt yêu cầu:

- Probe đó phải xuất được, theo từng dãy chạm: số touch đồng thời
  tối đa, các mốc Began/Ended theo touch, và một bộ đếm suy ra
  `wouldPinch` tương đương (cặp cùng scene + tỉ lệ suy từ hai mốc
  — chấp nhận độ chính xác thấp hơn điểm CarPlayApp).
- Kết quả của điểm này chỉ dùng để *đối chiếu* (in-app có thấy
  touch ở hosted scene không — câu hỏi dự phòng của WO A2), không
  bao giờ là căn cứ bắn lệnh: điểm quyết định duy nhất là
  CarPlayApp (quyết định đã khóa: ưu tiên CarPlayApp).
- Nếu điểm in-app mâu thuẫn điểm CarPlayApp (thấy cặp mà CarPlayApp
  không thấy, hoặc ngược lại), ghi vào biên bản Gate 2 như một
  phát hiện — không tự đổi điểm quyết định.

## 7. Kế hoạch cài đặt theo file (phân quyền chống đụng)

Nguyên tắc: strand pinch **không sửa** `SCPCarSplit.m`,
`SCPCarSplit+Chrome.m`, `ABInApp.m` — đó là đất của strand wake.
Mọi điểm chạm chung đi qua đúng một bước tích hợp cuối.

**File mới (strand pinch sở hữu toàn quyền):**

| File | Nội dung |
|---|---|
| `SCPPinchController.h/.m` | Custom recognizer + sổ cặp + máy nhận dạng (mục 3) + probe log (mục 6.1). Chỉ phụ thuộc: `SCPCarSplit` (đọc slots/container/active), `SCPCarPane`, protocol adapter (mục 4), interface phân xử (3.5). |
| `SCPFullscreenAdapter.h/.m` | Protocol `SCPFullscreenControlling` + class adapter; thân binding QA20 điền sau A1 (mục 4.3). |

**File chỉ đụng ở bước tích hợp (một người, một lần):**

| File | Thay đổi tối thiểu |
|---|---|
| `SCPHooks.m` | Gọi keo: sau seam `rootDidLayout` sẵn có (~317-320) + điểm teardown — tạo/gỡ controller theo vòng đời (bảng 1.3). Không logic pinch ở đây. |
| `SCPCarSplit.m` | **Chỉ khi bắt buộc**: nếu seam ở SCPHooks không đủ cho `ensureContainer`, thêm đúng một lời gọi keo `[[SCPPinchController shared] attachIfNeeded]` ở cuối `ensureContainer` và một ở `dashboardInvalidated`. Ngoài hai dòng keo này, strand pinch không sửa file này; nếu wake strand cũng sửa `SCPCarSplit.m` trong cùng vòng, hai dòng keo được hợp nhất ở bước tích hợp, không ai tự ý thêm. |
| Makefile của module | Thêm 2 file mới vào danh sách biên dịch. |

**Không đụng:** `SCPCarSplitView.h/.m` (hitTest/touched giữ nguyên —
recognizer không cần sửa view), `SCPCarSplit+Divider.m` (gesture
divider là của gốc/QA20, pinch không giành), toàn bộ AppBridge.

**Thứ tự triển khai đề xuất:** adapter (thân rỗng kỷ luật) →
controller + probe (DRY_RUN chạy được ngay, không phụ thuộc A1)
→ binding adapter khi A1 xong → cổng ENFORCE mở sau Gate 2 (đo)
và Gate 3 (thoát dự phòng, mục 5.3).

---
*Hết thiết kế phần A. Các điểm còn mở duy nhất là những gì đã ghi
[A1]: entry/đường đọc trạng thái của QA20 và phân định double-tap
divider QA20 ↔ rebuilt — cả hai nằm ở strand A1, không ở tài liệu
này.*
