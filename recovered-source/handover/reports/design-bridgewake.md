# THIẾT KẾ — OMNICAR BRIDGE WAKE (QA180 PORT) + TẦNG PHÂN XỬ PINCH/WAKE

Ngày: 2026-11-09. Loại việc: thiết kế chỉ-đọc — không sửa code, không build, không git.
Tài liệu này là đặc tả để 3 strand cài đặt (CarPlay / ABHost / ABInApp) làm theo không phải đoán.
Mọi điểm thiết kế bám bằng chứng của `work/wake-round/audit-runtime.md` (Gate 0) và
`work/fix-round6/design-logo-transfer.md` (máy QA180 + ánh xạ). Cập nhật phạm vi GPT (WO tích hợp
Pinch + Wake) đã được gộp: **hai công tắc độc lập PINCH_MODE / WAKE_MODE**, **một tầng phân xử chung
phía CarPlay**, **một điểm probe in-app duy nhất** cho cả hai tính năng (mục 5.3).

## 0. Ba câu hỏi mở của audit — đã chốt từ source

**Q2 — Process giữ vai chrome của SCPCarSplit: CarPlayApp, dứt khoát.**
Dylib SplitScreen nạp cả CarPlayApp lẫn SpringBoard (filter plist), nhưng cả hai constructor của
máy split — `__init_0` (0x44a8, SCPHooks.m:609) và `__init_1` (0x58b4, SCPHooks.m:714) — đều gate
`SCPHostIsCarPlayApp()` (SCPHooks.m:586, so `com.apple.CarPlayApp`) và *return* ngay ở process
khác. Toàn bộ SCPCarSplit/Chrome/bridge blocks chỉ sống ở CarPlayApp. `SCPSpringBoardHooks.m`
(ctor :170/:187) là đơn vị riêng cho phía SpringBoard (Home), **không** phải chủ chrome.
→ Chủ trạng thái (owner) đặt trong **CarPlayApp**, trong SCPCarSplit. Log r6 khớp: mọi hành động
split mang tag `[CarPlay:32249]`.

**Q3 — Đối số `handle` của hostFrameInfo = `!CGRectIsEmpty(frame)`, tại cả hai điểm gọi.**
- Điểm gọi 1 (khối +0,05 s sau hostApp, SCPCarSplit.m:~1882): `pane.hostHandle =
  !CGRectIsEmpty(frame)` rồi truyền `handle:pane.hostHandle`.
- Điểm gọi 2 (`-sendHostFrameForPane:live:`, SCPCarSplit.m:~1994): `BOOL handle =
  !CGRectIsEmpty(frame)` tại chỗ (comment trong source xác nhận: suy từ frame vừa tính, không
  phải từ cache của pane).
Nghĩa đúng của cờ này: **"pane hiện có khung host hợp lệ, khác rỗng"** — tức app hosted đang thực
sự được trình chiếu trong ô. Nó **không** mang nghĩa idle hay ẩn-theo-thời-gian; nó về 0 khi frame
rỗng (ô sụp/không trình chiếu/kết thúc gán). Đây là dữ kiện hiển thị hosted-handle liên-process
thật duy nhất ở tầng frame: phía ABHost, `setHandleVisible:(handle && !collapsed)` (ABHostBMethods.m:606)
biến nó thành `ABPane.handleHit.hidden`. Thiết kế dùng nó làm một đầu vào của HIDDEN (mục 1),
không bao giờ dùng nó một mình.

**Q4 — Transport của `hostPost:`: NSDistributedNotificationCenter, payload NSDictionary.**
`-hostPost:info:` (SCPCarSplit.m:1810) = `postNotificationName:object:nil userInfo:info`.
Toàn bộ họ `appbridge.*` (open/close/closeall/frame/state/shield/knobs/handletap/handledrag/
baraction/bardismiss/knobtouch — SCPShared.m:16–27, phía nhận là ABChan* trong
ABChannelNames.m:24–37) đều là NSDistributed. Thành ngữ Darwin đóng gói số là đường **riêng**:
`com.anlai.omnicar/car.busy` (publishBusy, SCPCarSplit.m:2543, notify_register_check/set_state/post),
`appbridge.keyboard` (ABKeyboardPublish, ABInApp.m:343) và `appbridge.apporient`
(ABPublishAppOrientation, ABInApp.m:451) — cả hai kênh sau dùng FNV-1a 32-bit của bundleID
(ABBundleHash, AppBridgeB.h:54) dịch <<24. Hệ quả thiết kế: bridgewake đi Darwin đóng gói số
theo đúng thành ngữ đã có (WO §III cho phép và yêu cầu ghi sơ đồ bit), **không** mượn các kênh
NSDistributed ở trên và tuyệt đối không đụng `appbridge.apporient` / `appbridge.orientation` /
`appbridge.keyboard` (WO §III + §VIII).

## 1. Định nghĩa HIDDEN trung thực trên bản rebuilt (B1) + chủ trạng thái

### 1.1 Tập controls thuộc phạm vi wake — theo đúng bản đồ 5 đối tượng của audit

| Đối tượng | Phía | Biến quyết định hiển thị (nguồn sự thật) | Tự ẩn theo idle? |
|---|---|---|---|
| `SCPCarPane.bar` (menu) | CarPlay | `pane.bar.isHidden` — đổi **chỉ** qua `setBarVisible:forPane:` (Chrome.m:313) + barTimer 4,0 s của chính nó (Chrome.m:329) | **Có — control duy nhất** |
| `SCPCarPane.handle` (pill "…") | CarPlay | `pane.handle.hidden = (pane.vc == nil)` tại `layoutBarForPane:` (Chrome.m:259); accent qua SCPApplyAccent trong setBarVisible | Không |
| `SCPCarDividerView.knob` | CarPlay | Không có trạng thái ẩn riêng cho wake: knob tồn tại khi divider tồn tại; bị publishKnobsNow bỏ qua khi `knob.isHidden` hoặc divider alpha < 0,5 (audit mục 3). `active` (SCPSetKnobActive) là trạng thái *chạm*, không phải hiển thị | Không |
| `ABPane.handleHit` (+ pill handle) | SpringBoard (gương hosted) | `handleHit.hidden = !(handle && !collapsed)` qua `setHandleVisible:forPane:` (ABHostBMethods.m:1184), dẫn bởi cờ `handle` của frame (= Q3) | Không (nô lệ theo frame) |
| `ABPane.bar` | SpringBoard (gương hosted) | host `setBarVisible:pop:dim:single:forApp:` (ABHostBMethods.m:1086) áp từ `hostBarInfo['bar'] = !pane.bar.isHidden` (SCPCarSplit.m:2103) | Theo bar phía CarPlay |

**Nói thẳng (không bịa):** trên bản rebuilt, hiện tượng "controls ẩn sau idle" mà DuoFace xử lý
bằng một trạng thái toàn cục **chỉ tồn tại ở một đối tượng duy nhất: thanh bar** (tự ẩn sau 4,0 s).
Handle và knob không tự ẩn ở đâu cả (audit Q5, âm tính có giới hạn trong phạm vi đã đọc). Vì vậy
HIDDEN của wake trên OmniCar **hẹp hơn DuoFace một cách có chủ đích và ghi rõ**: nó là trạng thái
của *bar + bối cảnh chrome quanh pane*, không phải "mọi controls biến mất". Thiết kế này **không**
tự chế thêm cơ chế fade idle cho handle/knob — đó là thay đổi hành vi ngoài WO; nếu GPT muốn, đó
là một work order riêng. Hệ quả thực dụng: cú chạm nội dung đầu tiên khi bar đã ẩn sẽ **hiện bar**
(hành vi wake), dù handle vốn luôn nhìn thấy — đúng với đích của `bridgeHandleTapped:` hiện nay
nhưng đi từ đường chạm nội dung thay vì chỉ từ handle.

### 1.2 Trạng thái wake theo pane (owner giữ, phía CarPlay)

Owner giữ **một trạng thái wake cho mỗi pane hosted** (không dùng cho pane native — pane native
không có process app tiêu thụ; trạng thái của chúng chỉ vào tầng phân xử ở mục 2). Các đầu vào thô
owner đọc trực tiếp trong process của mình, tại thời điểm tổng hợp:

- `assigned(p)` := pane thuộc `hostedPanes` (SCPCarSplit.m:2138) và `pane.bundleID != nil`.
- `live(p)` := `pane.hostHandle` — cache của Q3 trên pane (SCPCarPane.h:55), cập nhật ở cả hai
  điểm gọi hostFrameInfo; `live` = frame host khác rỗng.
- `barHidden(p)` := `pane.bar == nil || pane.bar.isHidden`.
- `transient(p)` := đang trong fade ẩn 0,18 s của bar (completion chưa chạy), hoặc split đang
  relayout (`relayoutAnimated:` đang chạy), hoặc pane vừa đổi gán trong < 0,25 s.
- `popup(p)` := `anyBarVisible` của các pane khác / ratio menu / tray đang mở (dữ kiện đã có:
  `anyBarVisible`, `popupOpen` trong SCPCarSplit).

Máy trạng thái (khớp WO §II) ánh xạ vào các đầu vào trên:

| Trạng thái | Điều kiện vào (owner tính) |
|---|---|
| `INACTIVE` | `!assigned(p)` — không gán hợp lệ: teardown, closeall, split tắt. Phát một lần khi rời trạng thái khác về đây |
| `UNKNOWN` | `assigned(p)` nhưng chưa có snapshot nhất quán: chưa từng tính `live` (chưa có frame info nào), hoặc `transient(p)`, hoặc vừa reconnect/chưa có xác nhận ABHost (mục 6) |
| `VISIBLE` | `assigned && live && !barHidden(p)` |
| `HIDDEN` | `assigned && live && barHidden(p) && !transient(p) && !popup(p)` |
| `WAKING` | Đã nhận wake hợp lệ cho pane này (mục 3), đã gọi đường hiện bar, đang chờ xác nhận ABHost hoặc hết hạn 1,0 s (mục 6) |

Quy tắc cứng rút từ WO §II: chỉ `HIDDEN` mới cho phép nuốt; `UNKNOWN`/`INACTIVE`/`WAKING` luôn
fail-open phía app. `bar.isHidden == YES` **một mình không bao giờ** đủ kết luận HIDDEN — bắt
buộc qua hàm tổng hợp này (đây là B1 ở dạng code).

### 1.3 Điểm tổng hợp + mọi sự kiện làm trạng thái đổi

Hàm tổng hợp duy nhất (mới): `-[SCPCarSplit bwRecomputeForPane:]` trong file mới
`SCPCarSplit+BridgeWake.m` (mục 7). Nó tính lại trạng thái từ các đầu vào §1.2, so với trạng thái
đã lưu trên pane (trường mới `bwState`), và **chỉ khi đổi** mới phát gói state (mục 3) + ghi log
`[do] bw state <bundle> <old>-><new> gen=<g> seq=<s>`. Các điểm gọi bắt buộc (mọi đường làm một
đầu vào đổi — liệt kê theo bằng chứng audit mục 5):

1. Cuối `setBarVisible:forPane:` — cả nhánh hiện, nhánh ẩn (tại thời điểm quyết định), **và**
   trong completion của fade ẩn (khi `bar.hidden = YES` thật sự落地) — bắt cả hai pha của ẩn.
2. `layoutBarForPane:` (Chrome.m:256) sau phép gán `handle.hidden = (vc == nil)` — gán pane đổi.
3. Điểm gán/teardown hosted: cuối đường hostApp (sau khối +0,05 s đặt `hostHandle/hostBar`),
   `teardownPane:`-tương ứng phía CarPlay, `endHostedSolo`, `hostClose:`/`hostCloseAll` đường
   CarPlay, `setActive:NO`.
4. `sendHostFrameForPane:live:` sau khi `pane.hostHandle` được gán lại (đầu vào `live` đổi).
5. `closePopups` / `hideBarsForTouchOn:` — chúng gọi setBarVisible nên đã phủ bởi (1); ghi rõ để
   strand cài đặt không thêm điểm trùng.
6. Sự kiện phân xử: EXPANDED đổi (mục 2), mode đổi (mục 4) — phát lại state cho mọi pane hosted.
7. Trả lời `query`: phát lại state của **mọi** pane hosted (mục 3.3), không đổi trạng thái.

Thế hệ gán (generation): owner giữ `bwGenBySlot[10]` trong SCPCarSplit; mỗi lần slot đổi bundle
được gán, hoặc teardown, hoặc split restart → `bwGenBySlot[slot]++` (khởi đầu 1). Gói state/wake/ack
mang gen của slot chứa bundle đó; phía app chỉ chấp nhận gói có gen bằng gen gần nhất đã thấy cho
chính nó — gói gen cũ bị bỏ (chống thông điệp cũ sau reconnect, WO §III.4).

## 2. Tầng phân xử Pinch/Wake (phía CarPlay — một nơi duy nhất nhìn cả hai)

Cả hai tính năng cùng đọc một bảng quyết định do owner tính; phía app **không** tự phân xử —
owner phát kết quả đã phân xử xuống trong gói state (mục 3): `state` (cho wake) + cờ
`pinchAllowed` (cho pinch) + hai mode. Điểm tính: `-[SCPCarSplit bwArbitrateForPane:]` trong
`SCPCarSplit+BridgeWake.m`, chạy lại mỗi lần `bwRecomputeForPane:` chạy.

### 2.1 Đầu vào EXPANDED — điểm chưa chốt, chờ strand A1

`layoutMode` ∈ {SPLIT, EXPANDED}. EXPANDED là trạng thái fullscreen của **cơ chế fullscreen QA20**
(không phải solo/zoom của gốc 1.0.3 — xem phân định ba nghĩa fullscreen ở
`study-pinch-fullscreen.md` mục 0). Owner chỉ giữ một đầu vào:

```objc
// Cung cấp bởi tầng fullscreen (strand A1 đang chứng minh entry của cơ chế QA20).
// Cho tới khi A1 chốt, giá trị mặc định là NO và bwArbitrate coi như SPLIT.
- (void)bwSetExpandedActive:(BOOL)active forBundle:(NSString *)bundleID;
- (BOOL)bwExpandedActive;   // toàn cục theo phiên fullscreen hiện hành
```

Thiết kế coi EXPANDED là *đầu vào trạng thái* của owner giống các đầu vào §1.2: ai đặt nó, đặt ở
đâu trong source QA20-đưa-sang, và nó đổi ở sự kiện nào — **chưa chốt, chờ A1**; mọi chỗ phụ
thuộc trong tài liệu này đều chỉ phụ thuộc vào BOOL trên, không phụ thuộc cơ chế bên dưới.

### 2.2 Bảng phân xử (nguyên văn tinh thần WO tích hợp)

| Điều kiện (owner tính) | Wake suppression | Pinch từ nội dung app |
|---|---|---|
| `layoutMode == EXPANDED` | **Vô hiệu** — owner phát state = VISIBLE (không bao giờ HIDDEN khi EXPANDED), app không nuốt | **Pinch-in ưu tiên**: `pinchAllowed = 1` bất kể allowlist; pinch-out không có nghĩa trong EXPANDED |
| `SPLIT` + pane `HIDDEN` | **Ưu tiên wake**: app được nuốt theo cổng §V khi WAKE_MODE = ENFORCE | **Không nhận**: `pinchAllowed = 0` — cử chỉ đầu thuộc về wake |
| `SPLIT` + pane `VISIBLE` | Không nuốt (state đã VISIBLE) | **Được phép nếu allowlist**: `pinchAllowed = (bundle ∈ bwPinchAllowlist)` |
| keyboard đang hoạt động / popup đang mở / cử chỉ native đang chạy / state ∈ {UNKNOWN, INACTIVE, WAKING} | **Fail-open** (không nuốt) | **Fail-open** (`pinchAllowed = 0`) |

Ghi chú ánh xạ điều kiện: "keyboard đang hoạt động" ở tầng owner = owner chưa có tín hiệu kb
riêng; điều kiện này được thực thi dứt khoát **phía app** (cổng §V/§VI ở mục 5) — owner chỉ đảm
bảo không phát HIDDEN khi `popup(p)` đúng, và phát `pinchAllowed = 0` khi `popup(p)`. "Cử chỉ
native đang chạy" = divider đang kéo / native pane đang nhận cử chỉ (tín hiệu đã có ở tầng
CarPlay: divider drag state) → owner phát `pinchAllowed = 0` + không đổi wake state.

### 2.3 Hai luật cách ly (không thương lượng)

- **Pinch không reset timer của wake:** đường xử lý pinch (cả ở owner lẫn phía app) **không**
  được gọi `setBarVisible:forPane:`, không gia hạn `pane.barTimer`, không phát activity kiểu
  QA19. Pinch thành công chỉ phát lệnh của riêng nó (đường của strand A2/A1), không chạm đường
  hiện bar.
- **Wake không phát lệnh pinch:** handler wake (mục 3) chỉ gọi đường hiện bar của Chrome; không
  bao giờ post kênh pinch, không gọi toggleZoom/solo. Hai handler không dùng chung mã ngoài
  tầng phân xử chỉ-đọc này.

## 3. IPC `bridgewake.v1` — Darwin đóng gói số

### 3.1 Bốn kênh (namespace theo WO: `com.anlai.omnicar/bridgewake.v1`)

| Kênh | Tên đầy đủ | Ai phát → ai nhận | Nội dung |
|---|---|---|---|
| state | `com.anlai.omnicar/bridgewake.v1.state` | Owner (CarPlay) → mọi app hosted + ABHost | Gói state đã phân xử (mục 2) cho một bundle |
| query | `com.anlai.omnicar/bridgewake.v1.query` | App mới nạp → owner | Xin phát lại state; app không tự mặc định hidden (WO §III.3) |
| wake | `com.anlai.omnicar/bridgewake.v1.wake` | App → owner (+ ABHost nghe để "vũ trang" xác nhận, mục 6) | Yêu cầu gọi controls, mang seq giao dịch |
| ack | `com.anlai.omnicar/bridgewake.v1.ack` | Hai chiều theo cờ role: owner → app (wake đã xử lý); ABHost → owner (chrome đã áp thật) | Xác nhận, echo seq của wake |

Mỗi process dùng một token `notify_register_check` riêng cho mỗi tên nó *phát* (đúng idiom
`ABKeyboardPublish`/`publishBusy`), và `notify_register_dispatch` trên main queue cho tên nó
*nhận*. Bên phát luôn `notify_set_state(token, gói)` **trước** `notify_post(tên)`. Bên nhận, khi
được đánh thức, đọc bằng `notify_get_state(token_nhận)`. **Cảnh báo nền tảng phải thiết kế
quanh:** mỗi tên Darwin có đúng **một ô uint64 dùng chung toàn hệ** — gói của pane/bundle này có
thể bị gói của pane/bundle khác ghi đè trước khi một app kịp đọc. Toàn bộ kỷ luật ở §3.3 tồn tại
vì sự thật này (đây cũng là nhiễu đã làm số đo bản 44 của saga không kết luận được — audit mục 6).

### 3.2 Sơ đồ bit (một layout thống nhất cho cả 4 kênh, gói trong uint64)

| Bit | Trường | Độ rộng | Giá trị |
|---|---|---|---|
| 63 | `v` (valid) | 1 | Luôn 1 ở gói hợp lệ. Ô trống/chưa từng set đọc ra 0 → `v=0` = không có gói |
| 62–35 | `hash` | 28 | 28 bit cao của FNV-1a 32-bit của bundleID: `ABBundleHash(bundle) >> 4` |
| 34–23 | `seq` | 12 | Số thứ tự phía gửi (xem kỷ luật dưới) |
| 22–11 | `gen` | 12 | Thế hệ gán của slot chứa bundle (§1.3), 1–4095, vòng modulo khi vượt |
| 10 | `flag` | 1 | Theo loại gói: state → `pinchAllowed` đã phân xử; ack → `role` (0 = owner→app, 1 = ABHost→owner); query/wake → 0 |
| 9–8 | `pinchMode` | 2 | 0=OFF, 1=DRY_RUN, 2=ENFORCE, 3=dự trữ (bên nhận coi như OFF) |
| 7–6 | `wakeMode` | 2 | Như trên |
| 5–3 | `state` | 3 | 0=INACTIVE, 1=UNKNOWN, 2=VISIBLE, 3=HIDDEN, 4=WAKING, 5–7 dự trữ (bên nhận coi như UNKNOWN) |
| 2–0 | `type` | 3 | 1=state, 2=query, 3=wake, 4=ack; 0 = không hợp lệ |

Kỷ luật trường:
- `state`/`wakeMode`/`pinchMode`/`flag=pinchAllowed` chỉ có nghĩa trong gói **type=state** (trừ
  `state` trong ack = trạng thái đã áp, mục 6). Trong query/wake, các trường này = 0 (trừ gen/seq/hash).
- `seq`: phía owner tăng đơn điệu cho mỗi lần phát state (dùng chung một bộ đếm của owner, modulo
  4096); phía app tăng cho mỗi **giao dịch wake** (một dãy chạm bị nuốt = một seq, dùng lại chính
  seq đó cho mọi phát lại — không có phát lại, xem mục 5.4). Ack **echo nguyên seq** của wake.
- `gen`: owner là nguồn duy nhất; app học gen từ gói state gần nhất của chính nó. Wake mang gen
  app đã thấy; owner bỏ qua wake có gen ≠ gen hiện tại của slot (thông điệp cũ sau reconnect).
- Bên nhận bỏ qua gói khi: `v=0`, `type` không khớp kênh, `hash` không phải của bundle mình
  (với owner/ABHost: hash không thuộc bundle đang được host), hoặc `gen` cũ hơn gen đã biết.

### 3.3 Phân tích collision + chống mất gói

- **Hash 28 bit:** xác suất hai bundle bất kỳ trùng hash ≈ 2^-28 ≈ 3,7×10^-9; số bundle đồng
  thời liên quan ≤ 4 (2 pane hosted + solo + float) → xác suất có bất kỳ cặp nào trùng ≈ C(4,2)
  × 2^-28 ≈ 2,2×10^-8. Hash chỉ là *địa chỉ lọc*, không phải xác thực; kể cả khi trùng, gen +
  seq + kiểm tra trạng thái ở owner (owner tra bundle thật theo pane, không tra theo hash) chặn
  hậu quả: owner nhận wake theo hash → owner **phải** đối chiếu bundle ứng viên với bundle đang
  gán ở slot mang gen đó; không khớp → bỏ. (Owner giữ bảng hash→bundle của các pane đang host
  để tra ngược; trùng hash giữa hai pane đang host đồng thời → owner phát hiện tại lúc gán và
  hạ cả hai pane xuống UNKNOWN — fail-open, ghi log. Xác suất coi như 0 nhưng luật phải có.)
- **Ô đơn latest-wins (rủi ro thật, khác hẳn hash):** hai gói state cho hai pane khác nhau phát
  sát nhau có thể làm một app đọc hụt gói của mình. Giảm thiểu (cả ba, bắt buộc): (i) owner phát
  state của các pane **cách nhau 30 ms** khi phát theo loạt (trả lời query / đổi EXPANDED / đổi
  mode) bằng một hàng đợi dispatch_after đơn giản; (ii) mọi app coi state là *có hạn tươi* 2,5 s
  (mục 5.2) — hụt gói → tự query lại, không đoán; (iii) owner phát lại toàn bộ state của mọi pane
  hosted mỗi khi có query từ bất kỳ app nào. Với ba lớp này, hụt gói chỉ gây fail-open tạm thời,
  không bao giờ gây nuốt sai.
- **Vòng phản hồi:** chỉ owner phát state; chỉ app phát wake/query; ack không bao giờ kích phát
  wake/state mới ngoài đúng một ack cho một wake (owner) và đúng một confirm cho một wake đã vũ
  trang (ABHost). Wake trùng seq+gen bị owner bỏ qua sau lần đầu (bảng đã-xử-lý giữ 16 seq gần
  nhất mỗi slot) → không tồn tại đường vòng vô hạn (WO §III.5).

### 3.4 Test vector (dùng chung cho strand cài đặt + unit test — tính bằng FNV-1a chuẩn của cây)

Hằng tham chiếu: `FNV1a32("com.google.ios.youtube") = 0xD3B4E0DF` → hash28 `0xD3B4E0D`;
`FNV1a32("vn.vietmap.live") = 0x2E775677` → hash28 `0x2E77567`.

| # | Gói (trường vào) | Số đóng gói (hex) | Giải mã kỳ vọng / hành vi bên nhận |
|---|---|---|---|
| V1 | state: yt, HIDDEN(3), wakeMode=DRY_RUN(1), pinchMode=OFF(0), flag=0, gen=7, seq=101 | `0xE9DA706832803859` | App YouTube: known=1, hidden=1, hai mode như trên; pinchAllowed=0 (đúng phân xử SPLIT+HIDDEN) |
| V2 | state: yt, VISIBLE(2), wakeMode=ENFORCE(2), pinchMode=ENFORCE(2), flag=1, gen=7, seq=102 | `0xE9DA706833003E91` | App YouTube: hidden=0; pinch được phép (flag=1) nếu pinchMode ENFORCE và cổng pinch thỏa |
| V3 | query: vietmap, gen=0, seq=1 (các trường state/mode = 0) | `0x973BAB3800800002` | Owner: phát lại state mọi pane hosted (cách nhau 30 ms); không đổi trạng thái |
| V4 | wake: yt, gen=7, seq=41 | `0xE9DA706814803803` | Owner: gen khớp slot của yt → xử lý một lần, vào WAKING, hiện bar |
| V5 | ack: owner→app, role=0, state=VISIBLE(2), yt, gen=7, seq=41 (echo V4) | `0xE9DA706814803814` | App YouTube: giao dịch 41 hoàn tất; engine về IDLE, chờ state VISIBLE đã phát riêng |
| V6 | ack: ABHost→owner, role=1, state=VISIBLE(2), yt, gen=7, seq=41 | `0xE9DA706814803C14` | Owner: xác nhận chrome đã áp → chốt VISIBLE cho pane, mới phát V5 + state |
| V7 | wake: yt, gen=6 (cũ), seq=42 | `0xE9DA706815003003` | Owner: gen 6 ≠ gen hiện tại 7 → **bỏ qua hoàn toàn**, không log lỗi (chỉ log đếm) |
| V8 | (không phải gói) ô state đọc ra `0` | — | Mọi bên nhận: `v=0` → không có gói; app giữ known=0 → fail-open |

Unit test bắt buộc (Gate 1): hàm đóng gói/giải mã ở cả hai module (mục 7) phải qua V1–V7 ở cả
hai chiều (pack ra đúng hex; unpack(V) ra đúng trường) và V8 ở chiều đọc.

## 4. Hai chế độ độc lập (WO §IX mở rộng cho WO tích hợp)

- Hai trường riêng trong mọi gói state: `wakeMode` (cho suppression) và `pinchMode` (cho pinch).
  Chúng **không** liên quan nhau: WAKE=ENFORCE + PINCH=OFF là tổ hợp hợp lệ và là tổ hợp nên dùng
  khi mới bật wake.
- Nguồn mode: **chỉ owner đọc** từ prefs của dự án (domain `com.anlai.omnicar`, hai key mới
  `bridgewake.wakeMode` / `bridgewake.pinchMode`, giá trị 0/1/2; vắng = **1 (DRY_RUN)**). Owner là
  process CarPlay của chính tweak — không phải app App Store — nên không vấp lỗi QA179. Owner
  nghe `SCPNotePrefsChanged` (đã có) → đọc lại → phát lại state cho mọi pane.
- Phía app **không bao giờ đọc plist/prefs**; mode duy nhất nó biết là từ gói state gần nhất.
  Chưa từng nhận gói state nào → mode hiệu dụng = DRY_RUN (chỉ ghi log probe, không nuốt, không
  pinch) — khớp luật "mặc định ban đầu DRY_RUN, tuyệt đối không tự bật ENFORCE".
- Đường về OFF/fail-open: teardown/reconnect/IPC lỗi → owner phát state `INACTIVE` kèm mode giữ
  nguyên (app tự fail-open theo state) và, khi lỗi là do chính owner, owner phát thêm một gói
  state `UNKNOWN` với cả hai mode = OFF. Phía app có đồng hồ tự vệ riêng: quá 2,5 s không có gói
  state tươi → mode hiệu dụng tụt về OFF cho mọi hành vi chặn/pinch (probe log cũng dừng, trừ
  dòng tổng kết), cho tới gói state hợp lệ tiếp theo.

## 5. Phía ABInApp — state client, probe gộp, suppression, keyboard guard

### 5.1 Điểm cài + điều kiện phiên hosted

- Mọi thứ của bridgewake phía app cài **lười trong `ABOrientationBlock`**, ngay sau danh sách
  MSHookMessageEx hiện có và trong cùng điều kiện `if (!ABHooksInstalled)` (ABInApp.m:86):
  (i) `MSHookMessageEx(UIApplication, @selector(sendEvent:), ABHook_SendEvent, &orig_SendEvent)`;
  (ii) đăng ký nhận Darwin `bridgewake.v1.state` + `bridgewake.v1.ack` (notify_register_dispatch,
  main queue); (iii) đăng ký observer bàn phím (mục 5.5); (iv) phát `query` lần đầu.
  Lý do giữ nguyên của nghiên cứu trước: block này chỉ chạy khi app thật sự được host (ngữ cảnh
  `ABForcedOrientation`), nên hook không tồn tại ở app chạy thường — probe không nhiễu ngoài phiên.
- `sessionValid` (dùng trong cổng §V) := hooks đã cài (đang trong ngữ cảnh hosted) **và** đã có
  ít nhất một gói state hợp lệ cho chính bundle này **và** gói đó còn tươi (≤ 2,5 s) **và** gen
  trong gói = gen owner đang dùng cho mình (app không có nguồn gen khác — gen "hiện tại" với app
  chính là gen của gói state tươi gần nhất; wake luôn mang gen đó).
- Phân biệt chạm màn xe với chạm màn hình iPhone (yêu cầu WO §IV, quyết ở Gate 2): probe ghi cho
  mỗi dãy: lớp của `touch.window`, `touch.window == ABKeyWindow()` hay không (helper đã có trong
  ABInApp), và `ABForcedOrientation` hiện hành. Luật phân loại ứng viên để Gate 2 kiểm chứng:
  dãy thuộc phiên hosted ⟺ app đang hosted (điều kiện cài) và mọi touch của dãy có window khác
  nil. Nếu Gate 2 cho thấy chạm iPhone vẫn lọt qua cùng đường này trong lúc CarPlay đang nối,
  `targetVerified` không đạt và suppression **không được bật** (ở lại DRY_RUN) — ghi rõ đây là
  tiêu chí chặn, không phải chi tiết cài đặt tùy ý.

### 5.2 State client

Biến phía app (file-scope trong ABInApp.m, cạnh các global 0x3E7D0–0x3E9E8 hiện có):
`BWState` (trạng thái đã giải mã của gói state gần nhất cho bundle mình), `BWGen`, `BWWakeMode`,
`BWPinchMode`, `BWPinchAllowed`, `BWStateRxAt` (mach_absolute_time lúc nhận), `BWKnown` (=
đã từng có gói hợp lệ trong phiên này). Hành vi:
- Nhận gói state (kênh state): lọc theo §3.2 (v/type/hash/gen không cũ hơn) → cập nhật các biến,
  `BWKnown = 1`.
- Hạn tươi: mọi quyết định chặn/pinch đều kiểm `now - BWStateRxAt ≤ 2,5 s`; quá hạn → coi như
  `UNKNOWN` + mode OFF (mục 4) và phát `query` (tối đa 1 query/2 s để không spam).
- Nhận ack (kênh ack, role=0): khớp seq với giao dịch đang SWALLOWING/FINISHED (mục 5.4).
- Tên kênh khai báo tại `ABChannelNames.m` (bản AppBridge) — 4 hằng `const char *` cạnh
  `ABNotifyKeyboard`/`ABNotifyAppOrient` (ABChannelNames.m:39–40), **không** đụng hai tên cũ.

### 5.3 Probe DRY_RUN — MỘT điểm quan sát cho cả wake và pinch (gộp theo cập nhật phạm vi)

`ABHook_SendEvent` là điểm quan sát **duy nhất**; nó nuôi hai bộ đánh giá độc lập trên cùng một
dãy chạm, và **luôn gọi `orig_SendEvent` đúng một lần** trong DRY_RUN (kể cả khi wakeMode/pinchMode
là DRY_RUN; khi cả hai đều OFF thì hook chỉ chuyển tiếp thuần, không ghi log — nhưng hook vẫn chỉ
tồn tại trong ngữ cảnh hosted như §5.1):

- **wouldSwallow**: kết quả của cổng suppression (mục 5.4) đánh giá ở Began như thể ENFORCE,
  nhưng không chặn.
- **wouldPinch**: 1 khi dãy có đúng 2 touch, khoảng cách giữa hai touch thay đổi > 10% trong
  đời dãy (tính từ vị trí touch nội bộ, **không ghi tọa độ ra log**), và phân xử hiện hành cho
  phép pinch trên nguyên tắc (`BWPinchAllowed` hoặc EXPANDED — qua các gói state đã nhận).
- Log mỗi dãy đóng (qua `OMCLogWrite(@"AppBridge", …)`, tiền tố `[do]`):
  `[do] bw probe seq=<n> ph B=<b> M=<m> E=<e> C=<c> dur=<s> hosted=<0/1> kb=<0/1/-> state=<S>
  wouldSwallow=<0/1> wouldPinch=<0/1> failopen=<reason|->`
  (`failopen` ∈ {mode, unknown, stale, kb, kbunknown, mixed, phone, notarget}).
- Trần chống ngập: 200 dãy/launch, sau đó tổng kết mỗi 30 s: tổng dãy, tổng wouldSwallow, tổng
  wouldPinch (hai bộ đếm riêng — đúng yêu cầu gộp probe).
- Trong DRY_RUN: không nuốt, không sửa UIEvent, không phát wake thật, không phát lệnh pinch.

### 5.4 Suppression engine (chỉ khi wakeMode = ENFORCE) — nguyên văn cổng WO §V

Điều kiện bắt đầu nuốt, đánh giá **một lần tại Began** của dãy:

```
enabled(wakeMode==ENFORCE) && sessionValid && targetVerified && known && hidden
&& !keyboardActive && !keyboardUnknown && !transitioning && !mixedTouches
```

Ánh xạ từng điều kiện sang biến của thiết kế này (strand cài đặt không được tự diễn giải lại):
`enabled` = `BWWakeMode==2`; `sessionValid` = §5.1; `targetVerified` = mọi touch của event
Began thuộc window đã xác minh theo luật §5.1 và dãy bắt đầu *sau* khi state đã known;
`known` = `BWKnown && còn tươi`; `hidden` = `BWState == HIDDEN`; `keyboardActive`/
`keyboardUnknown` = mục 5.5; `transitioning` = `BWState == WAKING` **hoặc** đang có giao dịch
wake chưa ack của chính dãy trước **hoặc** < 0,25 s kể từ lần đổi state gần nhất (chống nuốt
trên trạng thái đang lật); `mixedTouches` = event Began chứa > 1 touch, hoặc một dãy khác đang
được chuyển tiếp dở (đã Began qua orig) chưa kết thúc.

Máy chặn: `IDLE → SWALLOWING → FINISHED → IDLE`.
- Vào SWALLOWING: ghi lại tập touch của dãy (không giữ pointer quá Ended/Cancelled), **không**
  gọi orig cho event này và mọi event sau của cùng dãy — kể cả khi state lật sang VISIBLE giữa
  dãy (không bao giờ chuyển một dãy đang nuốt sang pass-through giữa chừng: UIKit sẽ nhận
  Moved/Ended mà không có Began). Phát **đúng một** wake (seq giao dịch mới) ngay tại Began.
- Trong SWALLOWING, một touch mới Began ngoài tập đã ghi → tình huống mixed không hỗ trợ: ghi
  log, tiếp tục nuốt trọn dãy đang giữ tới khi nó kết thúc, và **khóa suppression cho các dãy
  mới** cho tới khi nhận được gói state tươi tiếp theo (tự mở khóa khi đó).
- FINISHED: dãy đã Ended/Cancelled hết → chờ ack (role=0, seq khớp). Có ack → IDLE. Quá **1,5 s**
  không ack → ghi log timeout, về IDLE, và các dãy sau fail-open cho tới gói state tươi tiếp
  theo (không phát wake lặp trên Moved/Ended, không gia hạn gì — WO §V).
- Dãy đã qua orig ở Began (cổng không thỏa) thì **không bao giờ** bị chặn ở các pha sau.

### 5.5 Keyboard guard (WO §VI — không tái phạm QA178/QA179)

Trạng thái kb phía app là một enum `BWKbState ∈ {UNKNOWN, INACTIVE, ACTIVE}`:
- Tín hiệu **chính**: phiên first-responder sẵn có của AppBridge — `ABCurrentResponder != nil`
  (ABInApp.m:50), cập nhật bởi `ABResponderBecame` (298) / `ABResponderResigned` (305) qua các
  hook become/resign của UITextField/UITextView. Became → ACTIVE; Resigned khiến responder về
  nil → INACTIVE.
- Tín hiệu **phụ trợ**: observer `UIKeyboardWillShowNotification` / `UIKeyboardWillHideNotification`
  / `UIKeyboardDidChangeFrameNotification` đăng ký cùng điểm cài §5.1. Chỉ tính là bằng chứng
  "đang hiện" khi frame đích có `origin.y > 0 && origin.y < chiều cao màn hình` (loại frame
  parked) — mang nguyên bài học h1wake2 của DuoFace.
- **Cấm tuyệt đối**: suy kb từ sự *tồn tại* của `UIRemoteKeyboardWindow` hay quét cửa sổ (QA178:
  cửa sổ tồn tại thường trực trong app hosted → dương tính giả vĩnh viễn).
- **Lưu ý blank inputView**: AppBridge bịt bàn phím hệ thống bằng inputView rỗng
  (`ABSuppressSystemKeyboard`) và panel bàn phím thật nằm ở SpringBoard → thông báo bàn phím hệ
  thống **có thể không bắn** trong process app. Vì vậy: vắng thông báo **không** suy ra INACTIVE;
  chỉ responder mới hạ được ACTIVE xuống INACTIVE. Ngược lại, WillShow với frame hợp lệ trong
  khi responder == nil (đường nhập khác: search bar, input accessory) → coi là ACTIVE (lệch về
  phía an toàn: bớt nuốt).
- Mâu thuẫn/thiếu: kb = UNKNOWN khi chưa có bất kỳ tín hiệu nào kể từ lúc cài (trước chu kỳ
  Became/Resigned đầu tiên và chưa có WillShow/WillHide nào) → cổng §V chặn nuốt
  (`!keyboardUnknown`). Ngay khi có tín hiệu dứt khoát đầu tiên, kb rời UNKNOWN vĩnh viễn trong
  phiên (trừ reset ở mục 5.6).

### 5.6 Dọn dẹp khi release/teardown (phía app)

- Đăng ký thêm một observer NSDistributed trong `ABInstallInAppObservers` (ABInApp.m:239) cho
  `ABChanClose`/`ABChanCloseAll` (đã có tên sẵn) → handler `BWResetAll`: engine về IDLE và bỏ
  tập touch đang giữ (không phát gì thêm), `BWState = UNKNOWN`, `BWKnown = 0`, kb về UNKNOWN,
  hủy mọi dispatch_after đang chờ ack. Từ thời điểm đó mọi dãy mới fail-open cho tới khi có
  phiên hosted mới (hook sẽ được cài lại ở ABOrientationBlock của phiên sau).
- Wake đang chờ ack khi teardown đến: hủy chờ, không phát lại, không giữ latch — lần nối lại bắt
  đầu từ query như app mới nạp.

## 6. Phía ABHost — xác nhận chrome hosted (không tạo idle counter)

ABHost **không** quyết định trạng thái và **không** đếm idle; nó chỉ báo "đã áp thật" về owner.

- **Vũ trang (arm):** ABHost đăng ký nhận Darwin `bridgewake.v1.wake` cùng lúc với bootstrap host
  sẵn có (`ABChannels.m`). Khi thấy wake có hash thuộc một ABPane đang sống, nó ghi lại
  `{hash, gen, seq}` vào một ô chờ duy nhất cho bundle đó (wake mới ghi đè ô chờ cũ của cùng bundle).
- **Đọc snapshot đã áp:** ngay sau khi ABHost áp xong một frame cho bundle đó — điểm cuối của
  handler observer `appbridge.frame` trong `ABChannels.m` (observer tại :244) và đường
  `appbridge.open` (:203) — nó đọc trực tiếp trên ABPane tương ứng: `pane.handleHit.hidden`,
  `pane.bar.isHidden`, và số `ABKnobView` con hiện có của AB window (`knobViews.count`). Đây là
  ba dữ kiện "đã áp" duy nhất tồn tại (audit mục 5).
- **Phát confirm:** nếu có ô chờ khớp bundle và frame vừa áp đến trong vòng **800 ms** kể từ wake:
  phát `ack` với `role=1`, echo `gen`/`seq` của wake, và `state` := VISIBLE nếu
  `bar.isHidden == NO`, ngược lại UNKNOWN (ABHost không được tự kết luận HIDDEN — nó chỉ xác
  nhận cái nó vừa áp). Quá 800 ms không có frame → phát ack `role=1, state=UNKNOWN` (owner hiểu
  là không xác nhận được) rồi xóa ô chờ.
- **Phía owner khi nhận confirm:** confirm khớp (hash, gen, seq) với giao dịch WAKING hiện hành
  → nếu state=VISIBLE: chốt pane sang VISIBLE, phát gói state mới + `ack role=0` cho app (V6 →
  V5 ở §3.4). Nếu confirm UNKNOWN hoặc quá **1,0 s** chưa có confirm nào: owner hạ pane về
  UNKNOWN (không giữ WAKING), phát state UNKNOWN; app tự fail-open theo hạn tươi — không thử lại
  wake đó.
- Điểm đọc snapshot cần một accessor nhỏ phía ABHost: `-bwAppliedSnapshotForBundle:` đặt trong
  `ABHostBMethods.m` cạnh `setKnobs:`/`setHandleVisible:forPane:` (nơi các view đó được quản),
  trả `{handleHidden, barHidden, knobCount}`. ABHost không sửa hành vi áp frame hiện có ở bất
  kỳ điểm nào cho tính năng này.

## 7. Kế hoạch cài đặt theo file + cổng tĩnh Gate 1 tương ứng

Quy ước chung cho cả 3 strand: helper đóng gói dùng chung `BWPack/BWUnpack` viết dạng
`static inline` trong header `BridgeWakePack.h` — **hai bản giống hệt nhau** tại
`OmniCarSplitScreen/BridgeWakePack.h` và `OmniCarAppBridge/BridgeWakePack.h` (đúng tiền lệ cây
đã nhân bản `ABBundleHash`); tích hợp kiểm `diff` hai bản = 0. Hằng tên kênh cũng khai hai nơi:
`SCPShared.m` (SplitScreen) và `ABChannelNames.m` (AppBridge) — tích hợp kiểm khớp chuỗi.

### 7.1 Strand CarPlay (owner + phân xử + phát state) — process CarPlayApp
| File | Thay đổi |
|---|---|
| `OmniCarSplitScreen/SCPCarPane.h` | Thêm trường `bwState` (NSInteger), `bwGenSeen` không cần (gen ở split) |
| `OmniCarSplitScreen/SCPCarSplit.h` | Khai báo: `bwGenBySlot` (mảng 10 uint32), các method `bwRecomputeForPane:`, `bwEmitStateForPane:`, `bwHandleWake:`, `bwHandleAck:`, `bwSetExpandedActive:forBundle:`, `bwPinchAllowedForPane:` |
| `OmniCarSplitScreen/SCPCarSplit+BridgeWake.m` | **FILE MỚI** — toàn bộ owner: tổng hợp §1.3, phân xử §2, phát/nhận Darwin §3, đọc mode từ prefs §4, bảng đã-xử-lý wake, hàng đợi phát state cách 30 ms |
| `OmniCarSplitScreen/SCPCarSplit+Chrome.m` | Gọi `bwRecomputeForPane:` tại cuối `setBarVisible:forPane:` (nhánh hiện, nhánh ẩn) + trong completion fade ẩn; và cuối `layoutBarForPane:` |
| `OmniCarSplitScreen/SCPCarSplit.m` | Gọi recompute tại: đường hostApp (sau khối +0,05 s), `sendHostFrameForPane:live:`, `setActive:`, `hostClose:`/`hostCloseAll`, `endHostedSolo` |
| `OmniCarSplitScreen/SCPHooks.m` | Trong `__init_1` (chỉ CarPlayApp): đăng ký nhận Darwin query/wake/ack + observer prefs-changed cho owner (forward vào `[SCPCarSplit shared]`) |
| `OmniCarSplitScreen/SCPShared.m` | Thêm 4 hằng tên kênh bridgewake |
| `OmniCarSplitScreen/Makefile` | Thêm `SCPCarSplit+BridgeWake.m` |

**Gate 1 (CarPlay):** grep — `setBarVisible:forPane:` không bị sửa thân (chỉ thêm lời gọi ở
cuối/completion); không timer mới nào ngoài hàng đợi phát 30 ms và hạn WAKING 1,0 s; hai luật
cách ly §2.3 kiểm bằng grep đường pinch không chứa `setBarVisible`/barTimer (phần pinch do
strand khác, tích hợp kiểm); state chỉ phát từ `bwEmitStateForPane:` (grep `notify_post` của
kênh state chỉ xuất hiện trong file BridgeWake).

### 7.2 Strand ABHost (xác nhận) — process SpringBoard, module OmniCarAppBridge
| File | Thay đổi |
|---|---|
| `OmniCarAppBridge/ABChannels.m` | Đăng ký nhận Darwin wake (arm); ở cuối handler frame (:244) và open (:203): nếu có ô chờ khớp → đọc snapshot + phát confirm (mục 6) |
| `OmniCarAppBridge/ABHostBMethods.m` | Thêm `-bwAppliedSnapshotForBundle:` (đọc handleHit.hidden / bar.isHidden / knobViews.count từ ABPane + AB window) — không sửa các hàm áp frame sẵn có |
| `OmniCarAppBridge/ABChannelNames.m` | Thêm 4 hằng `const char *` kênh bridgewake (khớp chuỗi với SCPShared.m) |

**Gate 1 (ABHost):** diff — `setFrame:`/`setBarVisible:`/`setKnobs:` phía host **không đổi một
dòng**; ABHost không chứa biến đếm idle/timer mới nào (grep `bwIdle`/`NSTimer` trong phần mới =
0); ack role=1 là đường phát Darwin duy nhất được thêm phía host.

### 7.3 Strand ABInApp (client + probe + suppression + kb) — module OmniCarAppBridge
| File | Thay đổi |
|---|---|
| `OmniCarAppBridge/ABInApp.m` | (i) Thêm `orig_SendEvent` + `ABHook_SendEvent` (probe gộp §5.3 + engine §5.4), cài trong `ABOrientationBlock` sau danh sách hook hiện có; (ii) state client §5.2 + đăng ký state/ack + phát query; (iii) observer kb §5.5; (iv) observer close/closeall + `BWResetAll` §5.6 |
| `OmniCarAppBridge/ABChannelNames.m` | (Chung mục 7.2 — một strand sở hữu file này; strand ABInApp dùng hằng từ đó, không tự khai lại) |

**Gate 1 (ABInApp):** grep — `orig_SendEvent` được gọi **đúng một lần** trên mỗi đường đi không
nuốt và **0 lần** trên đường nuốt (kiểm bằng đọc code + test tĩnh cấu trúc); thân
`ABPublishAppOrientation`/`ABKeyboardPublish` và hai kênh cũ không đổi (diff theo hàm);
`sendEvent:` hook chỉ xuất hiện tại ABInApp.m trong toàn cây; không dòng nào đọc plist/prefs
trong phần mới; log probe không chứa tọa độ (grep các format string của phần mới không có
`locationInView`/tọa độ touch).

### 7.4 Tích hợp + Gate 1 chung
- `diff` hai bản `BridgeWakePack.h` = 0; chuỗi 4 tên kênh khớp giữa SCPShared.m và
  ABChannelNames.m; unit test vector §3.4 chạy pass ở cả hai module (harness test nhỏ biên dịch
  header pack trên VM, không liên quan bản build chính).
- Bảng hồi quy WO §VIII (orientation) chạy lại nguyên vẹn trên candidate: mask 24→4, mask 2→1,
  changed=0xFF → derived, changed khác sentinel → trực tiếp, debounce 0,25 s / nudge 0,05 s —
  kênh hướng không bị phần mới chạm vào (kiểm bằng diff các hàm ở §VIII + cổng g1/g2 của các vòng trước).
- Thứ tự đưa lên xe: candidate đầu tiên chỉ được để `wakeMode`/`pinchMode` ở mặc định DRY_RUN;
  Gate 2 (xe đỗ, probe) đạt mới bàn tới ENFORCE — đúng WO §IX/X, thiết kế này không tự mở cổng nào.
