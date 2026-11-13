# B — NHÓM NGUỒN GOFA & WAZE (LeGofaSource.dylib / LeWazeSource.dylib)

Phân tích tĩnh chỉ-đọc (không chạy binary/script) bằng llvm-objdump-18/llvm-nm-18 trên lát arm64, strings dump sẵn, và disassembly có mục tiêu (giải tham chiếu selref/CFString qua chained-fixup). Mọi kết luận gắn nhãn **[ĐÃ ĐO]** (có tên class/method/chuỗi/địa chỉ cụ thể) / **[SUY LUẬN]** / **[CHƯA RÕ]**.

Đối tượng:
- `LeGofaSource.dylib` (399.632 byte) — filter `LeGofaSource.plist`: Bundles = [`com.lumi.GOFA`] **[ĐÃ ĐO]**
- `LeWazeSource.dylib` (342.720 byte) — filter `LeWazeSource.plist`: Bundles = [`com.waze.iphone`] **[ĐÃ ĐO]**

---

## 1. Kiến trúc chung của cả hai dylib

- Cả hai dùng chung một lõi đặt tên **GVM** (tập symbol `GVM*` gần như giống hệt nhau trong cả hai binary: `GVMEncodeSourceOutput`, `GVMDecodeSourceOutput`, `GVMEncodeSample`, `GVMDecodeSample`, `GVMEncodeAlert`, `GVMDecodeAlert`, `GVMPublishSourceOutput`, `GVMReadSourceOutput`, `GVMObserveSourceOutput`, `GVMSelectOutputSource`…) cùng hai class ObjC tự định nghĩa: `GVMLocationSession` và `GVMOutputEndpoint` (ivar: `tokens`, `previous`, `previousCommit`, `previousSelection`, `published`). **[ĐÃ ĐO — llvm-nm]**
- Phần riêng từng app mang tiền tố **CW**: GOFA có `_CWGofaReadPayload`, `_CWGofaRoadObserve`, `_CWGofaRoadForget`; Waze có `_CWFindWazeLimitReader`, `_CWWazeLimitReaderAt/Index`, `_CWWazeAlertTypeForDescriptor`, `_CWWazeRoadObserve/Forget/EndStationaryHold/LastSampleUptime`. **[ĐÃ ĐO]**
- Luồng dữ liệu chung: hook/đọc dữ liệu trong process app chủ → dựng **payload dictionary** → chuẩn hoá thành **source-output dictionary** → **mã hoá vào các Darwin notify state (uint64)** → tiến trình khác (bong bóng) giải mã bằng chính các hàm `GVMDecode*` (bản gương của bộ mã hoá nằm ngay trong cùng các dylib này). **[ĐÃ ĐO — symbol + disasm]**
- Link: cả hai đều link CoreLocation, CydiaSubstrate; GOFA thêm Swift runtime + libc++ (phần reader viết bằng Swift). Không link NSURLSession, không import socket/XPC/CFNotificationCenter cho đường dữ liệu (xem §8). **[ĐÃ ĐO — INVENTORY + nm undefined]**

---

## 2. LeGofaSource — dữ liệu trích xuất từ GOFA (Q1)

| Loại dữ liệu | Có? | Bằng chứng |
|---|---|---|
| Tốc độ xe hiện tại | Có | Payload có mục `speed` gồm `speedTicks`, `speedKph`, `receivedAt` (GVMGofaOutput @0x6514 đọc các key này); đồng thời dylib tự chạy GPS riêng (xem §3.5) nên tốc độ còn lấy từ `CLLocation.speed` của chính nó. **[ĐÃ ĐO]** |
| Biển giới hạn tốc độ | Có | `GOFA.SpeedBoardModel` với property `currentAllowSpeed` và `nextAllowSpeedDatapoints`; payload có mục `speedLimit` gồm `limitTicks`, `limitKph`, `receivedAt`. **[ĐÃ ĐO]** |
| Điểm giới hạn sắp tới (datapoint) | Có | `GOFA.DatapointModel`, mảng `Swift.Array<GOFA.DatapointModel>`; các nhãn đọc được: `fixTicks`, `latitude`, `longitude`, `position2`, `distance2`, `position3`, `distance3`. **[ĐÃ ĐO]** |
| Biển báo / camera cảnh báo | Có | `GOFA.SignMessage`; payload có mục `signs[]` gồm các trường `sign`/`type`, `value`, `distance`, `distanceMeters`, `inForce`, `receivedAt`, kèm `signsTicks`. Bảng phân loại ~100 loại biển/cảnh báo dạng chuỗi (xem §5.3). **[ĐÃ ĐO]** |
| Làn đường | Có | Mục `lanes` gồm `lanesTicks`, `codes[]` (mỗi phần tử có `code`, `enabled`), `distance`/`distanceMeters`, `items`, `receivedAt`. **[ĐÃ ĐO]** |
| Hướng dẫn rẽ | Có (mức nhãn dữ liệu) | Trong vùng đọc payload xuất hiện các hằng hướng rẽ: `through`, `right`, `slight_right`, `sharp_right`, `left`, `slight_left`, `sharp_left`, `reverse`, cùng các nhãn `next`, `group`, `laneBoard`, `board`, `limitChanges`, `gosafe`, `identity`. **[ĐÃ ĐO là chuỗi/nhãn tồn tại; SUY LUẬN về vai trò: thuộc cấu trúc datapoint/board dẫn đường của GOFA]** |
| Vị trí GPS | Có | `latitude`/`longitude` trong datapoint; dylib tự duy trì phiên GPS riêng. **[ĐÃ ĐO]** |

---

## 3. LeGofaSource — cơ chế lấy dữ liệu (Q2)

### 3.1 Hook CLLocationManager (6 method) — [ĐÃ ĐO]
Hàm cài hook (vùng 0x5358–0x5560) gọi `_MSHookMessageEx` 6 lần trên cùng một class (classref bind ngoài, ngữ cảnh selector khẳng định là `CLLocationManager`); các selref đã giải ra nguyên văn:

| Selref | Selector bị hook |
|---|---|
| 0x24418 | `startUpdatingLocation` |
| 0x24420 | `stopUpdatingLocation` |
| 0x24428 | `setDelegate:` |
| 0x24430 | `setAllowsBackgroundLocationUpdates:` |
| 0x24438 | `setPausesLocationUpdatesAutomatically:` |
| 0x24440 | `setShowsBackgroundLocationIndicator:` |

Chuỗi log đi kèm: `"app requested standard GPS start"`, `"app requested standard GPS stop; forwarded"`, `"observing GPS delegate %@"` — tức tweak chặn các lệnh GPS của app để điều phối (lease), không chặn đứng. **[ĐÃ ĐO]**

### 3.2 Hook delegate GPS theo kiểu động — [ĐÃ ĐO]
Một helper (vùng 0x5d88–0x5ee0) lấy class thật của delegate hiện tại (`object_getClass`, `NSStringFromClass`), lấy method `locationManager:didUpdateLocations:` (selref 0x24450, đã giải nguyên văn), **kiểm tra type encoding** của method (phải bắt đầu bằng `v` và hai tham số đầu là object `@`,`@`) rồi mới `_imp_implementationWithBlock` + `_MSHookMessageEx`. Tức là nó hook thẳng lên class delegate của app (bất kể class đó tên gì), có kiểm tra chữ ký trước khi hook.

### 3.3 Hook GOFA.GofaLocationManager theo chữ ký — [ĐÃ ĐO]
`_CWGofaRoadObserve` (@0xbc3c):
- Tạo serial queue nhãn `"dev.bechou.le.gofa.road"` (`dispatch_queue_create` @0xbd38).
- `NSClassFromString(@"GOFA.GofaLocationManager")` (CFString @0x1fdb0, đã giải) → `class_copyMethodList` liệt kê **toàn bộ method** của class.
- Bỏ qua method có IMP trùng với IMP của `locationManager:didUpdateLocations:` (so sánh IMP @0xbda0).
- Với các method còn lại: lấy `method_getTypeEncoding`, so sánh với hằng `"v32@0:8@16@24"` (@0xbf68) — chỉ hook những method có chữ ký **void(self, id, id)**; hook bằng block qua `_imp_implementationWithBlock` + `_MSHookMessageEx` (@0xbfe4).
- Ngoài ra cài một **dispatch timer poll**: start sau 1 s (0x3b9aca00 ns), chu kỳ 100 ms (0x5f5e100 ns), leeway 1 s (`dispatch_source_set_timer` @0xbef8) — quét/đọc lại trạng thái board theo chu kỳ. **[ĐÃ ĐO hằng số]**

### 3.4 Reader payload bằng reflection (Swift) — [ĐÃ ĐO]
`_CWGofaReadPayload` (@0xf3f8, Swift `LeGofaSource.readPayload`) đọc cây đối tượng GOFA đã bắt được theo **nhãn property** (cơ chế mirror/KVC). Chi tiết ở §5.

### 3.5 Phiên GPS tự duy trì — [ĐÃ ĐO theo chuỗi log/format]
Dylib tự tạo `CLLocationManager` riêng + `CLBackgroundActivitySession` (`backgroundActivitySessionWithQueue:handler:`), kiểm tra `UIBackgroundModes`/`location`, và vận hành cơ chế "wake lease"/"location lease":
- `"selected source GPS started by wake lease"`, `"wake-owned source GPS released"`
- `"GOFA posted no board %.0f s into the location lease; its GPS restarted once for a new first fix app=%ld"` — nếu GOFA lâu không phát board, tweak **khởi động lại GPS của GOFA** (xem thêm §8).
- `"temporary location trial loaded; awaiting app GPS and visible Google Maps lease"`, `"location configuration active=%d running=%d app=%ld permission=%d distanceFilter=%.1f desiredAccuracy=%.1f background=%d paused=%d"`, `"gps callback age=%.1f count=%lu app=%ld"`.
- Nhận diện sự kiện nguồn qua 3 bundle id hằng: `vn.vietmap.live`, `com.lumi.GOFA`, `com.waze.iphone`; tên hiển thị `VietMap Live` / `Waze` / `GOFA`. **[ĐÃ ĐO]**

### 3.6 Kênh/đường khác phía nguồn vào
- Không thấy đọc file/cache của GOFA, không có URL/host nào (toàn bộ strings không có `http`). **[ĐÃ ĐO — grep strings + nm]**
- Có đăng ký quan sát các notification vòng đời app (`UIApplicationDidBecomeActiveNotification`, `UIApplicationWillEnterForegroundNotification`, `UISceneDidActivateNotification`, `UISceneWillEnterForegroundNotification` — import symbols). **[ĐÃ ĐO]**

---

## 4. LeWazeSource — dữ liệu trích xuất & cơ chế (Q1+Q2)

### 4.1 Dữ liệu trích xuất

| Loại dữ liệu | Có? | Bằng chứng |
|---|---|---|
| Tốc độ xe | Có | `GVMWazeOutput` @0x7354 dựng mục `speed` từ `speedTicks`, `speedKph`/`value`, `receivedAt`. **[ĐÃ ĐO]** |
| Giới hạn tốc độ | Có | Mục `speedLimit` từ `limitTicks`, `limitKph`/`value`, `receivedAt`; có hẳn bộ máy "LimitReader" riêng (xem 4.3). **[ĐÃ ĐO]** |
| Cảnh báo (camera/sự cố…) | Có | Mục `alerts[]` với các trường `ticks`, `type`/`value`, `distance`/`distanceMeters`, `receivedAt`. **[ĐÃ ĐO]** |
| Làn đường | **Không** | `GVMWazeOutput` không hề chạm key `lanes`; output Waze chỉ có speed/speedLimit/alerts. **[ĐÃ ĐO]** |
| Hướng dẫn rẽ | Không thấy trong output | Không có key guidance/turn trong GVMWazeOutput. **[ĐÃ ĐO trong phạm vi hàm output; CHƯA RÕ nếu có ở nhánh khác]** |
| Vị trí GPS | Có | Class nội bộ Waze `WSVLocationGPSPosition` với selector `initWithLongitude:latitude:altitudeMeters:speedMMSec:steering:accuracyMeters:timeSec:hasSteering:speedAccuracyMMsec:steeringAccuracy:` và type encoding `@92@0:8d16d24d32d40d48d56d64B72d76d84` xuất hiện trong vùng `CWWazeRoadObserve`. **[ĐÃ ĐO]** |

### 4.2 Hook CLLocationManager (7 method) — [ĐÃ ĐO]
Cùng mẫu với GOFA nhưng **7 hook** (selref đã giải nguyên văn): `startUpdatingLocation` (0x20418), `stopUpdatingLocation` (0x20420), `setDelegate:` (0x20430), `setAllowsBackgroundLocationUpdates:` (0x20438), `setPausesLocationUpdatesAutomatically:` (0x20440), `setShowsBackgroundLocationIndicator:` (0x20448), và thêm **`startUpdatingHeading`** (0x20428).
Tên liên quan trong strings: `WazeLocationManager`, `LocationManagerRecorder`, `LocationController`, ivar `_originalDelegate` — cho thấy cơ chế **đệ trình delegate** (ghi lại delegate gốc của Waze rồi chèn lớp ghi ở giữa). **[ĐÃ ĐO chuỗi/ivar; SUY LUẬN về vai trò từng class]**

### 4.3 LimitReader — đọc giới hạn tốc độ kiểu "đo theo build" — [ĐÃ ĐO cơ chế]
- Các hàm `_CWFindWazeLimitReader`, `_CWWazeLimitReaderAt`, `_CWWazeLimitReaderIndex` cùng một helper hook tổng quát (vùng 0xdb1c): duyệt method list của một class, `strcmp` type encoding với encoding đích, khớp thì `MSHookMessageEx` — tức **hook theo chữ ký**, đích cụ thể do bảng mô tả (descriptor) quyết định.
- Trong vùng RoadObserve xuất hiện: CFString UUID `90947E86-BFF2-3434-A28B-979C65DB8846`, tên file **`le-waze-limit-reader.plist`**, key `search`, và một UUID thứ hai `35B4D105-0B38-384E-A147-64709C604759` trong strings. **[ĐÃ ĐO]**
- Kiểm tra phiên bản app chủ qua `CFBundleShortVersionString`/`CFBundleVersion`; dòng log: `"%.3f background GPS: Waze build not measured (version %@, build %@); it starts when Waze is opened once"` — nghĩa là với build Waze chưa có số đo sẵn, cơ chế đo/đọc giới hạn chưa áp dụng được. **[ĐÃ ĐO]**
- **[SUY LUẬN]** File `le-waze-limit-reader.plist` là nơi lưu "số đo" (descriptor: class/selector/encoding hoặc offset) của LimitReader theo từng build Waze, khoá bởi UUID; nội dung chính xác của plist: **[CHƯA RÕ]**.
- `_CWWazeAlertTypeForDescriptor` (@0xc77c) ánh xạ descriptor cảnh báo của Waze → type chuẩn hoá; bằng chứng trực tiếp: nó tham chiếu icon name `icon_alerter_cam_red_light` của Waze. **[ĐÃ ĐO một ánh xạ mẫu + tên hàm]**; hằng `Waze.CommonCodeAlertId` cũng xuất hiện trong strings (định danh loại cảnh báo phía Waze). **[ĐÃ ĐO chuỗi]**

### 4.4 Điều hướng/GPS ownership — [ĐÃ ĐO symbol + tham chiếu]
Nhóm hàm `GVMInitializeWazeNavigation` @0x6868, `GVMWazeOwnsNavigation`, `GVMWazeTransferNavigation`, `GVMStopWazeNavigation`, `GVMWazeNavigationInitializing`; trong `GVMInitializeWazeNavigation` có tham chiếu CFString `LocationController` (class nội bộ của Waze) và việc đọc version của `com.waze.iphone`. **[SUY LUẬN]** Tweak "nhận quyền sở hữu" phiên dẫn đường/GPS của Waze để Waze vẫn cấp fix khi chạy nền theo lease của nguồn đã chọn; chi tiết từng bước: **[CHƯA RÕ]**.

### 4.5 Road observe của Waze
`_CWWazeRoadObserve` @0xc8c0 tạo queue nhãn `"dev.bechou.le.waze.road"` (disasm @0xca14), làm việc với `WSVLocationGPSPosition` và dựng sample (`ticks`, `speedKph` thấy trong vùng này). Có thêm các hàm `_CWWazeRoadEndStationaryHold`, `_CWWazeRoadLastSampleUptime` và tên `dev.bechou.le.waze.road.end-hold` — cơ chế giữ trạng thái khi xe đứng yên/hết đoạn đường. **[ĐÃ ĐO tên/hàm; vai trò end-hold: SUY LUẬN]**

---

## 5. Giao thức payload của GOFA (Q4 — phần trọng điểm)

### 5.1 Tầng 1 — Payload dictionary nội bộ (đầu ra của CWGofaReadPayload, đầu vào của GVMGofaOutput)
`GVMGofaOutput` (@0x6514) đọc payload bằng đúng các key sau — đây là **toàn bộ inventory key đã đo** từ disasm (thứ tự theo địa chỉ):

- `liveTicks` — nhịp sống/timestamp của payload.
- Mục tốc độ: `speedTicks`, `speedKph`, `receivedAt` → chuẩn hoá thành output `speed` (giá trị lấy theo chuỗi dự phòng `speedKph` → `value`).
- Mục giới hạn: `limitTicks`, `limitKph`, `receivedAt` → output `speedLimit` (dự phòng `limitKph` → `value`).
- Mục làn: `lanesTicks`, và dict `lanes` chứa `codes[]` (phần tử: `code`, `enabled`), `distance`, `distanceMeters`, `items`, `receivedAt` → output `lanes`.
- Mục biển báo: `signsTicks`, và mảng `signs[]` (phần tử: `sign`, `type`, `value`, `distance`, `distanceMeters`, `inForce`, `receivedAt`) → output `alerts`.
- Cuối hàm: gắn bundle `com.lumi.GOFA` và phát state vào tên `dev.bechou.le.gmaps.gofa-output` (tail-call `notify_set_state` @0x6510 của hàm liền trước/GofaOutput). **[ĐÃ ĐO key + tên kênh; cấu trúc lồng nhau chi tiết từng tầng: SUY LUẬN một phần]**

### 5.2 Tầng 0 — Nhãn property đọc từ đối tượng GOFA (reflection trong CWGofaReadPayload)
Các nhãn (label) mà reader tra trong cây đối tượng GOFA, đã giải từ disasm vùng 0xf3f8–0x10c00:

| Nhãn | Kiểu/đối tượng liên quan |
|---|---|
| `notificationSpeedBoard` | `GOFA.SpeedBoardModel` |
| `notificationNextBoard` | (board kế tiếp) |
| `notificationOtherBoard` | — |
| `pushOtherBoardToCarplay` | — |
| `notificationSignGosafe` | `GOFA.SignMessage` |
| `notificationLaneBoards` | — |
| `pushLaneBoardsValue` | — |
| `currentAllowSpeed` | field của SpeedBoardModel |
| `nextAllowSpeedDatapoints` | `Swift.Array<GOFA.DatapointModel>` |
| `board`, `limitChanges`, `gosafe`, `next`, `group`, `laneBoard`, `identity`, `fixTicks`, `latitude`, `longitude`, `position2`, `distance2`, `position3`, `distance3` | field của datapoint/board |

Sentinel lỗi khi không đọc được từng phần: `unreadable-point`, `unreadable-metadata`, `unreadable-lanes` — reader tách payload thành 3 phần **points / metadata / lanes** và ghi sentinel thay cho phần hỏng. **[ĐÃ ĐO]**

### 5.3 Bảng loại biển/cảnh báo (taxonomy) — [ĐÃ ĐO từ strings]
Reader/encoder dùng chung một bảng type dạng chuỗi, hai họ tên (kebab-case và tên artwork):
- Giới hạn tốc độ: `speed-limit`, và artwork `speed_limit_%lu.png` theo giá trị; liệt kê sẵn `speed_limit_10` … `speed_limit_110`.
- Camera: `camera`, `traffic_camera`/`traffic-camera`, `speed_limit_camera`, `speed-camera`, `camera_ai`/`camera-ai` (nhãn hiển thị `camera AI`), `penalty-camera`, `red-light-camera`, `bus-lane-cam`, `hov-camera`, `noise-camera`, `phone-camera`, `seatbelt-camera`, `distance-between-vehicles-camera`, `stop-sign-camera`, `dummy-camera`, `police`, `police-mobile-camera`.
- Hạn chế/khu vực: `residential-area` (`residential_area_in/out`, `residential-start/end`), `no-passing` (`no_passing_in/out`, `no-passing-start/end`), `rest-area`/`highway_rest_area`, `toll`, `toll-etc`, `restriction`, `no-entry` (+ biến thể left/right), các type cấm rẽ (`noLeftTurn`, `noRightTurn`, `noLeftTurnUTurn`, `noRightTurnUTurn`, `noUTurnLeft`, `noUTurnRight` và họ kebab tương ứng), `railway`, `tunnel`, `slow-down`, `stop-lane`, các type bắt buộc hướng (`mandatory-*`, `*TurnOnly`, `straightAheadOnly`…).
- Sự cố Waze-style: `accident`, `accident-minor`, `animal`, `assistance`, `bad-weather`, `blocked-lane`, `closure`, `cyclist`, `dangerous-curves`, `dangerous-intersection`, `emergency-vehicle`, `fork`, `hazard-*` (animals/broken-light/construction/object-on-road/pothole/roadkill/stopped/weather-flood/fog/hail/ice/snow), `highway-crosswalk`, `intersection`, `lanes-merging`, `left/right-lane-ending`, `left/right-shoulder-ending`, `both-shoulders-ending`, `merge`, `narrow-bridge`, `raised-crosswalk`, `school-zone`, `slippery-road`, `speed-bumps`, `topes`, `closed-lane-construction`, `closed-lane-crash`.
- Tên artwork PNG tương ứng từng type: `<type>.png` (ví dụ `penalty_camera.png`, `retrict_unknown.png` [nguyên văn, lỗi chính tả trong binary], `noEntry.png`…). **[ĐÃ ĐO]**

### 5.4 Sự kiện liên quan tới GOFA
- `dev.bechou.le.bubble.gofa-events` — kênh notify sự kiện cho thành phần bong bóng; được `notify_register_check` ngay trong `GVMRefreshLocationSession` @0x40ec (token lưu tại 0x249f0) và được tham chiếu lần nữa ở vùng 0x6360. Nội dung state/sự kiện cụ thể: **[CHƯA RÕ]**; **[SUY LUẬN]** là tín hiệu "nguồn GOFA còn sống/đã có board mới" phục vụ lease hiển thị.
- Tên định danh nguồn: sourceID dạng chuỗi `gofa` (cùng hệ với `vietmap-live`, `waze`), tên hiển thị `GOFA`, bundle `com.lumi.GOFA`. **[ĐÃ ĐO]**

---

## 6. Kênh gửi dữ liệu & định dạng trên dây (Q3 — dùng chung cả hai nguồn)

### 6.1 Phương tiện truyền: Darwin notify state — [ĐÃ ĐO]
Cả hai dylib import và dùng đủ bộ: `_notify_register_check`, `_notify_register_dispatch`, `_notify_set_state`, `_notify_get_state`, `_notify_post`, `_notify_cancel`. **Không** có file chia sẻ cho dữ liệu giao thông, **không** socket, **không** XPC (import `__swift_FORCE_LOAD_$_swiftXPC` chỉ là force-load runtime của Swift), **không** CFNotificationCenter. Toàn bộ dữ liệu nén vào **uint64 state** của các tên notify dưới đây, kèm `notify_post` để báo "có khung mới".

### 6.2 Danh mục tên kênh — [ĐÃ ĐO từ strings + disasm]
Khung dùng chung cho nguồn đang được chọn (state name là biến toàn cục đã giải nguyên văn):
- `dev.bechou.le.gmaps.speed` (`_GVMSpeedStateName` @0x1c990)
- `dev.bechou.le.gmaps.limit` (`_GVMLimitStateName` @0x1c998)
- `dev.bechou.le.gmaps.alert.first` (`_GVMFirstAlertStateName` @0x1c9a8)
- `dev.bechou.le.gmaps.alert.second` (`_GVMSecondAlertStateName` @0x1c9b0)
- `dev.bechou.le.gmaps.test.alert.first` / `dev.bechou.le.gmaps.test.alert.second` (biến test)
- `dev.bechou.le.gmaps.source.vietmap.request` (`_GVMSourceRequestName` @0x1c9a0)

Khung riêng từng nguồn (per-source), mẫu tên dạng format string:
- `dev.bechou.le.gmaps` + `.output.v1.%lu.%@` → `dev.bechou.le.gmaps.output.v1.<sourceID-số>.<field>`; các field thấy trong strings: `commit`, `selection`, `limit`, `alert.first`, `alert.first.value`, `alert.second`, `alert.second.value`, `lanes.first`, `lanes.second` (và `speed` theo cùng mẫu).
- `dev.bechou.le.gmaps` + `.output.v1.%lu.changed` → notify_post khi khung thay đổi (trong `GVMPublishSourceOutput` @0xa814: đọc `sourceID`, 4 lần `notify_set_state` cho speed/limit/alert.first/alert.second @0xa9d4–0xaa44, rồi `notify_post` @0xaab0). **[ĐÃ ĐO]**
- Mẫu tên phụ: `.source.selection`, `.source.%lu.request` (kênh yêu cầu một nguồn cụ thể xuất bản). **[ĐÃ ĐO]**

Tên riêng theo nguồn:
- `dev.bechou.le.gmaps.gofa-output` (state khung GOFA), `dev.bechou.le.gmaps.waze-output` (state khung Waze). **[ĐÃ ĐO]**
- `dev.bechou.le.bubble.gofa-events`, `dev.bechou.le.bubble.waze-events` (sự kiện cho bong bóng). **[ĐÃ ĐO]**

Phiên nền/vị trí:
- `dev.bechou.le.gmaps.background.location-session`, `dev.bechou.le.gmaps.background.location-source`, `dev.bechou.le.gmaps.background.shown.%u` (%u = id nguồn). **[ĐÃ ĐO]**

**Không phải kênh notify** (tránh nhầm khi làm bộ giải mã):
- `dev.bechou.le.gofa.road`, `dev.bechou.le.waze.road` là **nhãn dispatch queue** (`dispatch_queue_create`), đã kiểm chứng tại điểm gọi. **[ĐÃ ĐO]**
- `dev.bechou.le.waze.road.end-hold` — chỉ thấy dạng chuỗi; vai trò: **[CHƯA RÕ]**.

### 6.3 Định dạng payload chuẩn hoá (source-output dictionary) — [ĐÃ ĐO inventory key]
`GVMEncodeSourceOutput` @0x9584 / `GVMNormalizeSourceOutput` làm việc trên dict có các key:
`schemaVersion`, `sourceID` (`vietmap-live` | `gofa` | `waze`), `commit`, `selection`, `provider`, `kind`, `artworkID`, `speed` {`value`, `receivedAt`}, `speedLimit` {`value`, `receivedAt`}, `alerts[]` {`type`, `value`, `distance`, `provider`, `kind`, `artworkID`, `receivedAt`}, `lanes` {`items`, `distance`, `receivedAt`, phần tử có `code`, `enabled`}.

### 6.4 Mã hoá bit vào notify state — [ĐÃ ĐO từ disasm GVMEncode*]

**Sample (dùng cho cả speed và limit)** — `_GVMEncodeSample` @0xb488:
```
state = (ms << 10) | (1 << 9) | value
```
- `value`: số nguyên km/h, kiểm tra hợp lệ: là NSNumber (không phải BOOL), nguyên, 0 ≤ value ≤ 400 (hằng 400.0 @0xb554). Chiếm bit 0–8 (bit 9 là cờ "có dữ liệu" — decoder `_GVMDecodeSample` @0xb5f4 kiểm tra `tbz bit 9` trước khi đọc).
- `ms = floor(ticks_giây × 1000)` (hằng nhân 1000.0 @0x148b0), chiếm bit 10–63 (54 bit; giá trị giây đầu vào bị chặn < 18014398509481.984 @0x148f8 ≈ 2^54/1000).
- Phía giải mã: `ticks = (state >> 10) / 1000` (+ một base double do caller truyền — **[CHƯA RÕ]** base này là epoch hay mốc monotonic), và trong cả hai hàm giải mã đều xuất hiện hằng **5.0** — **[SUY LUẬN]** là cửa sổ "tươi" ~5 giây để loại dữ liệu cũ.

**Alert** — `_GVMEncodeAlert` @0xb770, phép đóng gói cuối @0xba0c–0xba14:
```
state = A | (B << 14) | (C << 21) | (D << 24)
```
- A = `fcvtzu(double)` — trường 14 bit ở bit 0–13. **[SUY LUẬN]** là `distance` (mét).
- B = giá trị 7 bit ở bit 14–20 (kết quả một helper chuyển đổi). **[SUY LUẬN]** là mã type/artwork của cảnh báo.
- C = giá trị 3 bit ở bit 21–23 (biến nội bộ x23). **[SUY LUẬN]** liên quan `kind`/`provider` (encoder đọc đúng các key `provider`, `kind`, `distance` @0xb81c–0xb854).
- D = `fcvtmu(double) << 24` — trường 40 bit ở bit 24–63. **[SUY LUẬN]** là ticks (ms) của cảnh báo.
- Ánh xạ chính xác A/B/C/D ↔ key dictionary: **[CHƯA RÕ]** ở mức từng trường (đã có hàm gương `_GVMDecodeAlert`/`_GVMDecodeAlertWithin` trong cùng binary để đối chiếu khi viết bộ giải mã).

**Lanes**: phát qua hai state `lanes.first` / `lanes.second` (tên đã đo). Bố cục bit: **[CHƯA RÕ]** (chưa disasm hàm mã hoá lanes trong vòng này).

---

## 7. File được chạm tới — [ĐÃ ĐO]
- Cả hai dylib import `NSFileHandle`, `NSFileManager`, `_NSTemporaryDirectory` và có selector `writeToFile:atomically:` / `writeData:` (strings Waze; cùng lõi với GOFA).
- **File log chẩn đoán phiên vị trí**: `le-gmaps-location-session.log` (trong thư mục tạm của app chủ), định dạng dòng `"%.3f %@"` (timestamp 3 số lẻ + thông điệp). Nội dung là log vận hành lease/GPS như các chuỗi ở §3.5 — dữ liệu giao thông **không** đi qua file này. **[ĐÃ ĐO tên/định dạng; vị trí tmp: SUY LUẬN từ NSTemporaryDirectory]**
- **Waze**: `le-waze-limit-reader.plist` — file riêng của cơ chế LimitReader (§4.3). **[ĐÃ ĐO tên; nội dung CHƯA RÕ]**
- Không thấy đường dẫn file/cache nào của app GOFA/Waze bị đọc. **[ĐÃ ĐO trong phạm vi strings]**

---

## 8. Hành vi ngoài lấy dữ liệu giao thông (Q5)

| Hành vi | Kết luận |
|---|---|
| Quảng cáo | **Không thấy.** Không có chuỗi/framework quảng cáo nào trong cả hai dylib. **[ĐÃ ĐO — grep strings]** |
| License/kích hoạt | **Không thấy** trong hai dylib này (không có chuỗi license/trial/premium/subscription; phần đó nếu có nằm ở thành phần khác của gói, ngoài phạm vi nhóm này). **[ĐÃ ĐO]** |
| Telemetry/analytics gửi ra ngoài | **Không.** Không URL/host, không import NSURLSession/socket; dữ liệu chỉ rời process qua Darwin notify nội bộ máy. **[ĐÃ ĐO]** |
| Sửa hành vi GPS của app chủ | **Có, đáng kể.** Hook 6–7 setter/start/stop của `CLLocationManager` (gồm `setAllowsBackgroundLocationUpdates:`, `setPausesLocationUpdatesAutomatically:`, `setShowsBackgroundLocationIndicator:`) để ép GPS chạy nền theo "lease"; tự tạo `CLBackgroundActivitySession`. **[ĐÃ ĐO]** |
| Thay delegate của app | **Có.** Hook `setDelegate:` + hook động lên class delegate thật; phía Waze có ivar `_originalDelegate` (đệ trình delegate). **[ĐÃ ĐO]** |
| Khởi động lại GPS của app chủ | **Có (GOFA).** Chuỗi log: GOFA lâu không phát board → GPS của nó bị khởi động lại một lần để lấy fix mới. **[ĐÃ ĐO]** |
| Nhận quyền phiên dẫn đường | **Có (Waze).** Nhóm `GVMWazeTransferNavigation`/`GVMWazeOwnsNavigation`/`GVMInitializeWazeNavigation` + class `LocationController` của Waze. **[ĐÃ ĐO symbol/tham chiếu; mức can thiệp chi tiết: SUY LUẬN]** |
| Ghi file trong container app | **Có.** Log chẩn đoán + (Waze) plist LimitReader — đều là file của tweak, không sửa file dữ liệu của app chủ (không có bằng chứng sửa cache/dữ liệu Waze/GOFA). **[ĐÃ ĐO]** |
| Chế độ test | Có kênh test cảnh báo `dev.bechou.le.gmaps.test.alert.first/second` trong cả hai dylib. **[ĐÃ ĐO]** |

---

## 9. Danh sách CHƯA RÕ (để vòng sau, nếu cần)
1. Ánh xạ từng trường bit A/B/C/D của alert-state ↔ key dictionary (`distance`/`type`/`kind`/`provider`) — cần đọc kỹ `_GVMDecodeAlert` đối chiếu.
2. Bố cục bit của hai state lanes (`lanes.first`/`lanes.second`).
3. Base double cộng thêm khi giải mã ticks của sample (epoch tuyệt đối hay mốc tương đối), và ngữ nghĩa chính xác của hằng 5.0 trong decoder.
4. Nội dung file `le-waze-limit-reader.plist` và vai trò của UUID thứ hai `35B4D105-0B38-384E-A147-64709C604759`; descriptor cụ thể (class/selector) của LimitReader trên từng build Waze.
5. Nội dung state của `dev.bechou.le.bubble.gofa-events` / `.waze-events` và của `dev.bechou.le.gmaps.gofa-output` / `.waze-output` (commit counter? timestamp?).
6. Vai trò của `dev.bechou.le.waze.road.end-hold`.
7. Cấu trúc lồng nhau chính xác từng tầng của payload dictionary GOFA ở tầng 1 (§5.1) — inventory key đã đủ, thứ tự/kiểu từng node cần đối chiếu thêm với phía tiêu thụ (LeBubble) khi viết bộ giải mã.
8. Lát arm64e chưa disasm đối chiếu (mặc định coi tương đương arm64; strings hai lát trùng nhau).
