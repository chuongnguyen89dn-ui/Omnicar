# THIẾT KẾ — AUTOHIDE: ẨN HOÀN TOÀN CONTROLS SAU IDLE (QA20) + WAKE 1 CHẠM (QA180)

Ngày: 2026-11-09. Loại việc: thiết kế chỉ-đọc — không sửa code, không build, không git.
Lệnh gốc: Nguyen chốt 2026-11-09 13:53 — "Thanh menu tự ẩn. Thứ tôi cần là nó phải ẩn
hoàn toàn các nút trên màn hình. Gọi lại 1 chạm không click app như DuoFace. Xem lại
bản QA20 có làm ẩn. Ghép với DuoFace thành tính năng mới của OmniCar hiện tại."

Tài liệu này là đặc tả để các strand cài đặt làm theo không phải đoán. Bằng chứng nền:
`audit-runtime.md` (Gate 0: bản đồ 5 đối tượng + kết luận gốc 1.0.3 **không có** idle-hide
ngoài thanh bar), `design-bridgewake.md` §1–§2 (định nghĩa HIDDEN hiện tại của wake1 —
tài liệu này cấp đúng đầu vào còn thiếu cho nó), và source hai add-on QA19/QA20 trong repo
(`~/workspace/push9-clone/native-solo-timer-qa20/src/OmniCarNativeSoloTimer.xm`,
`~/workspace/push9-clone/youtube-handle-qa19/src/OmniCarYouTubeHandleIdle.xm`).

## 0. Chốt thiết kế trong một đoạn

Dựng một controller mờ mới `SCPCarSplit+AutoHide` trong module SplitScreen (process
CarPlayApp, cùng nơi với owner wake): **một timer idle 4,0 s duy nhất cho toàn phiên split**,
feed activity từ các điểm chạm có sẵn trong source rebuilt, sơn `layer.opacity = 0` (lưu
giá trị gốc, khôi phục khi hiện) lên toàn bộ controls phía CarPlay (handle từng pane,
divider + knob, homeButton/logo). Phía SpringBoard không tự sinh trạng thái: trạng thái mờ
đi xuống ABHost qua **key `fade` mở rộng trong hostFrameInfo** (cho ABPane.handle/handleHit)
và **key `kfade` cạnh key `knobs`** (cho ABKnobView) — ABHost chỉ áp sơn như QA19 đã làm.
Trạng thái mờ là một **đầu vào hẹp** cấp cho owner wake theo đúng mẫu `bwSetExpandedActive:`
đã có: `bwRecomputeForPane:` cộng thêm hợp phần `faded` vào HIDDEN. Chạm đầu sau khi mờ:
ở DRY_RUN nó vừa tới app vừa gọi controls hiện lại (đúng parity QA20); ở ENFORCE nó bị
ABInApp nuốt và chỉ gọi controls hiện lại (đúng QA180). Không đụng barTimer/trayTimer/
ratioTimer, không đụng thân `setBarVisible:forPane:`, không dùng `hidden`/`alpha` để mờ.

## 1. Cơ chế QA20 đã chứng minh trên xe (đọc từ source, không suy)

### 1.1 Khung cơ chế chung của cả hai add-on

| Hạng mục | QA20 (`OmniCarNativeSoloTimer.xm`, phía native) | QA19 (`OmniCarYouTubeHandleIdle.xm`, phía hosted) |
|---|---|---|
| Process | CarPlayApp + SpringBoard (filter plist; thực chất chỉ sống ở CarPlayApp — nơi có SCPCarSplit active) | Mọi process UIKit (filter `com.apple.UIKit`); phần sơn chỉ chạy trong process giữ ABHost |
| Đồng hồ | **Một** NSTimer 4,0 s (`kOMCNativeIdleSeconds = 4.0`), không lặp, theo từng split (state là associated object trên SCPCarSplit) | NSTimer 4,0 s (`kOMCYTIdleSeconds = 4.0`), không lặp, **theo từng pane** (associated object trên ABPane) |
| Cách ẩn | `view.layer.opacity = 0.0f` — **mờ về 0 hẳn**, không mờ một phần. Giá trị opacity gốc được lưu (associated object trên từng view) và khôi phục nguyên trị khi hiện | Giống hệt: `layer.opacity = 0.0f`, lưu trong `savedOpacity` (NSMapTable theo view), khôi phục nguyên trị |
| Animation | **Không có.** Gán trực tiếp, hiệu lực tức thì (comment trong source: "Cosmetic CALayer change ONLY") | Không có. Gán trực tiếp |
| Điều cấm (cả hai đều ghi trong source) | Không đụng `hidden`, `alpha`, `userInteractionEnabled`, frame, recognizer gốc — vì vậy **hit target vẫn sống khi đang mờ**: chạm vào tay nắm vô hình vẫn bấm được | Giống hệt ("Do NOT set hidden/alpha/userInteractionEnabled: original hit target remains tappable") |
| Vòng đời | `setActive:NO` → dừng: invalidate timer, khôi phục opacity mọi view đã sơn, gỡ recognizer. Relayout (`rootDidLayout`/`layoutBarForPane:`) **không** reset timer; view sinh sau được sơn theo trạng thái hiện hành tại `layoutBarForPane:` | `setHandleVisible:NO` từ gốc (nativeVisible=NO) → dừng + khôi phục toàn bộ. `layoutBarForPane:` chỉ re-apply, không reset timer |

### 1.2 Nguồn activity — liệt kê từng nguồn và kênh

**QA20 (mọi nguồn đều dẫn về một hàm `OMCNativeSharedActivity(publish, reason)`):**
1. **`SCPCarSplitView hitTest:withEvent:`** — nguồn chính. Sau `%orig` (trả nguyên hit
   target), nếu event là touches, điểm nằm trong bounds, view có window, và có ít nhất
   một touch ở pha **Began** thuộc cùng window → activity. Comment ghi rõ đây là cùng
   điểm vào với DuoFace (`CBSplitContainerView.hitTest`) và chạy **trước khi** event
   được giao cho app remote/hosted.
2. **`SCPCarSplit handleTapped:` / `dividerTapped:`** — sau `%orig` → activity.
3. **Recognizer quan sát thụ động** (`OMCNativeTimerTouch`: `cancelsTouchesInView = NO`,
   `delaysTouchesBegan/Ended = NO`, tự đặt `state = Failed` ngay sau Began) gắn lên
   **container** và **tabParent** — nguồn dự phòng ("native-gesture-fallback") cho các
   chạm không qua hitTest của split view.
4. **Kênh Darwin `com.anlai.omnicar.qa19.controls.activity`** (CFNotificationCenter,
   DeliverImmediately) — nhận → wake tại chỗ với publish=NO (không phát lại, chống vòng
   lặp). Đây là kênh **dùng chung cả hai add-on**.

**QA19 (hàm `OMCYTWakeAll(source)`):**
5. **Recognizer thụ động trên `ABPane.box`** (nội dung) và trên **`ABPane.handleHit`**
   (tay nắm) trong SpringBoard → Began → wake mọi pane đang theo dõi + phát kênh Darwin
   ở trên (source `host-pane-local-touch`).
6. **Relay trong process app:** hook `-[UIApplication sendEvent:]` — `%orig` chạy
   **trước, không nuốt gì**; có touch Began → phát kênh Darwin (source
   `app-process-touch`). Trong process app, `OMCYTWakeAll` không sơn gì (không có
   ABPane ở đó); toàn bộ tác dụng của nó là tiếng gọi activity liên-process.
7. Nhận kênh Darwin → wake (không phát lại).

**Kỷ luật kênh (cả hai):** phát có **throttle 0,12 s** (mốc thời gian toàn cục phía
phát); phía nhận không bao giờ phát lại từ đường nhận → không tồn tại vòng phản hồi.
Mọi activity đều làm hai việc nguyên tử: hiện lại (chỉ khi đang mờ) + **gài lại đồng hồ
4,0 s** — kể cả khi đang hiện, vì đồng hồ tính từ activity cuối.

### 1.3 Đối tượng được sơn — từng process

**QA20, phía CarPlay (trong `OMCNativeApply`):**
- `pane.handle` của **mọi** pane trong `allPanes` (cả native lẫn hosted — handle phía
  CarPlay tồn tại cho cả hai loại pane).
- **Mỗi divider**: chính view divider **và** `divider.knob` của nó — hai đối tượng sơn
  riêng, hai giá trị lưu riêng. Comment trong source ghi đây là sửa cho khiếm khuyết
  QA19: chỉ sơn divider cha thì knob tròn độc lập vẫn hiện.
- **Loại trừ tường minh:** `split.ratioKnob` (thuộc popup tỉ lệ tạm thời) — không sơn.
- Không sơn: pane.bar (menu), homeButton/launcher, tray, popup. QA20 không hề có khái
  niệm sơn menu — menu tự quản bằng timer riêng của gốc (xem §2.1 quan hệ với bar).

**QA19, phía SpringBoard (trong `OMCYTApply`) — chỉ pane YouTube:**
- `ABPane.handle` (pill thị giác) và `ABPane.handleHit` (vùng chạm 44×24) — sơn cả hai
  (nếu là hai view khác nhau), để cả hình lẫn vùng chạm cùng mờ.
- Điều kiện bảo vệ của QA19: chỉ sơn view "control nhỏ" (5–160 × 5–100 pt, không phải
  box, không phải tổ tiên của box) — biện pháp phòng thủ khi hook vào binary lạ.
  Bản rebuilt **không cần** lớp bảo vệ này (ABPane là class của chính cây, hình học đã
  biết: hit 44×24, pill 34×12 — audit mục 2), chỉ giữ kiểm nil/loại view.
- Điều kiện sống: chỉ áp khi `nativeVisible` = YES, tức cờ `handle` theo frame của gốc
  đang bật cho pane đó (xem §2.2). Gốc tắt handle → QA19 dừng hẳn và khôi phục.

### 1.4 Điều kiện không ẩn — phần QA20/QA19 có và phần chúng không có (nói thẳng)

Có trong source (đã chứng minh):
- Split không active → timer không bắn, wake không tác dụng; teardown khôi phục sạch.
- QA19: pane không còn được gốc cho hiện handle (`nativeVisible` = NO) → không mờ.
- Relayout/đổi frame **không** reset đồng hồ (chống nhấp nháy khi layout chạy lại).

**Không có** trong QA20/QA19 — không được ghi là "QA20 đã chứng minh":
- Không cổng popup/menu đang mở (chúng không sơn menu/popup nên không cần).
- Không cổng bàn phím (không có tín hiệu kb nào trong hai file).
- Không cổng đang kéo divider: một cú kéo dài quá 4,0 s tính từ Began cuối có thể làm
  timer bắn giữa cú kéo — QA20 chấp nhận điều này vì Began của cú kéo đã gài lại đồng
  hồ và thao tác kéo thực tế hiếm khi đứng yên 4 s. Các cổng này ở §4.2 là **thiết kế
  mới của bản rebuilt**, có lý do riêng từng cổng, không mượn danh QA20.

### 1.5 Điểm tổng quát hoá so với QA19 (phải ghi rõ khi cài đặt)

QA19 chỉ làm cho **một** bundle (YouTube, hằng `kOMCYTBundle`) vì nó là bản vá theo
app. Tính năng mới áp cho **mọi pane hosted**: trạng thái mờ phía host là theo từng
ABPane nhưng do owner phía CarPlay quyết định toàn cục (một trạng thái mờ của cả phiên
split, §3.1), nên phía ABHost không cần hằng bundle, không cần state theo app — nó chỉ
áp giá trị `fade` owner gửi xuống cho pane đó (cùng cách nó áp cờ `handle` hôm nay).
Đây là thay đổi phạm vi có chủ đích theo lệnh của Nguyen ("ẩn hoàn toàn các nút trên
màn hình"), không phải hành vi QA19 nguyên văn.

## 2. Kiểm kê phần tử trên bản rebuilt + đường mang trạng thái mờ

### 2.1 Phía CarPlay (process CarPlayApp — nơi controller sống)

| Phần tử | Chủ sở hữu / điểm sinh | Đường điều khiển hiện hữu | Đường sơn mờ (thiết kế này) |
|---|---|---|---|
| `SCPCarPane.handle` (pill "…", 34×12) | `setupBarForPane:` (SCPCarSplit+Chrome.m:~161); `hidden = (vc == nil)` tại `layoutBarForPane:` (Chrome.m:259); accent qua `SCPApplyAccent` (Chrome.m:88 — chỉ đụng sublayer gradient + `shadowOpacity`, **không** đụng `layer.opacity` → không xung đột với sơn) | Không có đường mờ nào; `layoutBarForPane:` là điểm layout lại duy nhất | Sơn trực tiếp `layer.opacity` bởi AutoHide TU (cùng process). Điểm áp-lại cho handle sinh/layout muộn: cuối `layoutBarForPane:` — đúng mẫu QA20 sơn tại `layoutBarForPane:` |
| `SCPCarDividerView` (thân vạch) + `divider.knob` (chấm tròn 14×14) | `rebuildDividers` / `layoutKnobOf:` (SCPCarSplit+Layout.m:574); active (scale 1,6×) bởi `SCPSetKnobActive` (SCPCarDividerView.m:~48) — transform, không đụng opacity | `publishKnobsNow` (SCPCarSplit.m:~2625) bỏ qua knob khi `knob.isHidden` hoặc `divider.alpha < 0,5` — sơn bằng `layer.opacity` không chạm hai điều kiện này (alpha ≠ layer.opacity) nên gương knob không bị ảnh hưởng phụ | Sơn cả hai đối tượng, lưu riêng từng view (đúng bài học QA20 §1.3). Điểm áp-lại: cuối `rebuildDividers` |
| `homeButton` (nút Home/logo) + `launcherHost` (view chứa) | `refreshHomeButton` (SCPCarSplit.m:~2882–2973): tạo `UIButton` qua `SCPLauncherButton`, gắn vào launcher host; `removeHomeButton` (SCPCarSplit.m:2983) huỷ khi root/tabParent mất hoặc tính năng tắt. Property: SCPCarSplit.h:86–87 | Không có đường mờ nào. QA20 **không** sơn phần tử này — đây là phần tử Nguyen nêu đích danh ("logo") nên thiết kế này bổ sung, ghi rõ là mở rộng ngoài QA20 | Sơn **chỉ `homeButton`** (không sơn launcherHost — host có thể chứa phần tử khác của cụm dock). Điểm áp-lại: cuối `refreshHomeButton` sau khi button đã tạo/định tâm; `removeHomeButton` xoá luôn bản lưu opacity của button đó |
| `SCPCarPane.bar` (menu 5 nút) | `setupBarForPane:` (Chrome.m:~245), sinh `hidden = YES` | **Đã có timer riêng:** `setBarVisible:forPane:` (Chrome.m:313) gài `pane.barTimer` 4,0 s (Chrome.m:329) | **Không sơn, không đụng.** Quan hệ hai đồng hồ ở §3.1: bar tự ẩn bằng cơ chế gốc; AutoHide không sơn bar, không gài lại barTimer, không gọi setBarVisible (giữ luật cách ly §2.3 của design-bridgewake). HIDDEN của wake yêu cầu **cả hai** đã ẩn — xem §3.3 |

Ghi chú phạm vi CarPlay: tray, ratio menu, picker sheet, popup shield **không** thuộc
tập sơn — chúng là bề mặt tương tác đang mở, và §4.2 dùng chính sự hiện diện của chúng
làm điều kiện không-mờ.

### 2.2 Truy vết đầy đủ cờ `handle` theo frame (audit mới chạm bề mặt — chốt tại đây)

**Phía sinh (CarPlay):** cờ này **không phải** trạng thái lưu trữ; nó được **suy ra tại
chỗ từ hình học** ở đúng hai điểm gọi `hostFrameInfo:frame pane:live:handle:`:
- Điểm gọi 1 — khối +0,05 s sau `hostApp` (SCPCarSplit.m:1890–1892):
  `pane.hostHandle = !CGRectIsEmpty(frame)` rồi truyền `handle:pane.hostHandle` vào gói
  `appbridge.open`.
- Điểm gọi 2 — `-sendHostFrameForPane:live:` (SCPCarSplit.m:1993): `BOOL handle =
  !CGRectIsEmpty(frame)` tính tại chỗ từ frame vừa tính (không đọc cache), gói vào
  `appbridge.frame`.
Trong đó `frame = [self hostFrameForPane:pane]` (SCPCarSplit.m:~2078) trả `CGRectZero`
khi bất kỳ điều kiện nào đúng: split không active; pane không có vc; `pane.picker` đang
lên; `pane.view.alpha < 0,5`; bề rộng < 20 pt; pane không có window; tray đang phủ
(không overlay); picker sheet đang phủ; ratio menu cắt vào hình pane. Nói cách khác cờ
`handle` = **"ô này hiện có khung trình chiếu hợp lệ"** — nó đã gộp sẵn các trạng thái
che phủ, và nó về 0 vì hình học chứ không bao giờ vì idle (đúng kết luận Q3 của
design-bridgewake §0).

**Đóng gói:** `hostFrameInfo:` (SCPCarSplit.m:2035) dựng dict nền 11 key
(`identifier, x, y, w, h, live, handle, pt, pl, pb, pr`), rồi merge `hostBarInfoForPane:`
(`bar, pop, popDim, single` — SCPCarSplit.m:2103) và thêm `r, corners, hx, front,
ox/oy/ow/oh, ax/ay/aw/ah`. Transport: `hostPost:` = NSDistributedNotificationCenter,
payload NSDictionary (design-bridgewake §0/Q4). Cadence phát: **theo sự kiện** —
`pushHostFramesLive:` (SCPCarSplit.m:2165) gọi `sendHostFrameForPane:` cho mọi pane
hosted, được gọi từ các điểm layout/bar/popup/zoom (~15 điểm gọi trong cây: Chrome,
Divider, Panel, Picker, RatioMenu, Relayout, Zoom) cộng gói `open` lúc gán ô. **Không**
có nhịp frame liên tục: giữa hai sự kiện layout, không có gói frame nào được phát.

**Phía áp (SpringBoard):** handler `appbridge.frame` (ABChannels.m:~262) đọc đúng các
key cố định `x, y, w, h, pt, pl, pb, pr, live, handle` → gọi
`-[ABHost setFrame:forApp:live:handle:passInsets:]` (ABHostBMethods.m:599):
`collapsed := MIN(w,h) < 2,0`; `box.hidden = collapsed`; rồi
`[self setHandleVisible:(handle && !collapsed) forPane:pane]` (ABHostBMethods.m:606) →
`handleHit.hidden = !visible` + định tâm + bringSubviewToFront (ABHostBMethods.m:1184).
Handler `appbridge.open` đi cùng đường áp frame ban đầu.

**Hệ quả thiết kế (quan trọng):** vì cờ `handle` mang nghĩa hình học và là điều kiện
sống của cả QA19 (`nativeVisible`), trạng thái mờ **tuyệt đối không** được mã hoá bằng
cách ép `handle = NO`: phía ABHost sẽ hiểu ô đã sụp, và mọi logic nô lệ theo cờ này
(handleHit.hidden, các đường stop) chạy sai nghĩa. Trạng thái mờ phải đi bằng **key
riêng cộng thêm** trong cùng dict (§2.4), và phía ABHost phải giữ hai sự thật độc lập:
`nativeVisible` (từ `handle && !collapsed`, như hôm nay) và `faded` (từ key mới) —
sơn chỉ áp khi cả hai cùng đúng, đúng cấu trúc QA19.

### 2.3 Phía SpringBoard (gương hosted — ABHost chỉ áp, không tự sinh)

| Phần tử | Chủ sở hữu / điểm sinh | Đường điều khiển hiện hữu | Đường sơn mờ (thiết kế này) |
|---|---|---|---|
| `ABPane.handle` (pill 34×12) + `ABPane.handleHit` (vùng chạm 44×24) | `setupHandleForPane:` (ABHostBMethods.m:1151); hiện/ẩn bởi `setHandleVisible:forPane:` (ABHostBMethods.m:1184) nô lệ theo cờ frame (§2.2); chạm hit → `handleTapped:` (ABHostBMethods.m:845) post `appbridge.handletap` | Không có đường mờ nào | Sơn cả hai view bằng `layer.opacity` + lưu/khôi phục (mẫu QA19 §1.3), qua method mới `-applyFade:forPane:` trong ABHostBMethods.m; chỉ áp khi `nativeVisible` (cờ frame gần nhất) = YES. Giá trị `fade` đến từ key mới trong gói frame/open (§2.4) |
| `ABKnobView` (đĩa 66×66 + chấm 14×14, subview trực tiếp của AB window) | `setKnobs:` (ABHostBMethods.m:~1240) reconcile theo spec `[x, y, active, index?]` từ kênh `appbridge.knobs` (handler ABChannels.m:304–310, payload dict `{knobs: [...]}`); không có trạng thái ẩn riêng — có mặt trong spec = hiện | Spec do `publishKnobsNow`/`publishKnobsSoon` (SCPCarSplit.m:~2600–2650) phát, coalesce theo nhịp main-queue, chỉ khi active + có pane hosted + không tray | Sơn `layer.opacity` của từng knobView. Giá trị mờ đi bằng **key `kfade` đặt cạnh key `knobs`** trong cùng payload dict. `setKnobs:` phải áp mờ hiện hành cho knob **sinh sau** (sinh ra đã mờ nếu đang faded) — lưu trạng thái mờ toàn cục phía host trong statics của ABHostBMethods |

Ghi chú ABKnobView: phần hoạt ảnh active của `setKnobs:` đụng `center`, transform của
knob và các sublayer của chấm (gradient `omcAccent`) — không ghi `layer.opacity` của
chính knobView (đã đọc thân hàm khi thiết kế). Cổng tĩnh ở §5.4 khoá điều này: ngoài
helper sơn, `setKnobs:` không được xuất hiện phép gán opacity nào khác.

### 2.4 Đường mang trạng thái mờ xuống ABHost — so sánh và quyết định

| Ứng viên | Đánh giá | Kết luận |
|---|---|---|
| **(a) Key mới trong hostFrameInfo** — `info[@"fade"] = @(faded)` cho mọi pane thật | Đi cùng đúng gói đã mang cờ `handle` và `hostBarInfo`; theo từng pane nên ABHost áp nguyên tử cùng nhịp với setFrame (không lệch pha handle/fade); **tự chữa đồng bộ**: mọi lần push frame (layout, bar, popup, zoom…) đều mang giá trị mờ hiện hành — ABHost không thể kẹt trạng thái cũ; gói `open` lúc gán ô cũng qua hostFrameInfo nên pane sinh giữa lúc đang mờ nhận đúng trạng thái ngay | **CHỌN cho handle/handleHit** |
| **(b) Key cạnh trong payload knobs** — `@{@"knobs": specs, @"kfade": @(faded)}` | Kênh knobs là kênh duy nhất đã mang dữ kiện knob; payload vốn là dict nên thêm key anh em không phá parser (handler hiện chỉ đọc `@"knobs"`); nhịp phát (publishKnobsSoon) do owner chủ động gọi được tại thời điểm đổi mờ | **CHỌN cho ABKnobView** |
| **(c) Kênh NSDistributed riêng** (vd `appbridge.chrome`) | Tách bạch nhưng: thêm một observer + vòng đời mới phía ABHost; rủi ro lệch đồng bộ thật — mờ đổi lúc chưa có pane hosted thì ABHost không có gì để áp, pane mở sau phải có luật phát lại; hai sự thật (kênh riêng + frame) có thể mâu thuẫn mà không có điểm phân xử | **Loại** — (a)+(b) tự chữa theo nhịp sẵn có, (c) phải tự chế cơ chế đồng bộ lại |

Kỷ luật cộng thêm: key mới là **cộng thuần** — mọi key gốc của hostFrameInfo giữ
nguyên tên/giá trị/ngữ nghĩa (cổng tĩnh §5.4 kiểm superset); phía ABHost khi **không
thấy** key `fade`/`kfade` (gói từ bản cũ hơn) mặc định coi = NO (không mờ) — tương
thích ngược một chiều, fail-open về phía hiện. `hostSolo:` (SCPCarSplit.m:~1940) dựng
dict frame bằng tay với `handle = @NO` và không qua hostFrameInfo: **không** thêm key
vào đường này — phiên solo hosted thuộc diện treo AutoHide (§4.1) và gương của nó vốn
đã không có handle.

### 2.5 Cơ chế sơn — kỷ luật chung cho cả hai process (rút từ QA20/QA19)

1. Chỉ sơn bằng `layer.opacity`; **cấm** gán `hidden`, `alpha`, `userInteractionEnabled`
   trong mọi code mới của tính năng này (cổng tĩnh grep ở §5.4). Hệ quả bắt buộc phải
   giữ: mọi hit target đang mờ vẫn chạm được — đây là điều làm cú chạm đầu sau khi mờ
   tới được cả app (DRY_RUN) lẫn các tay nắm vô hình (handleTapped vẫn chạy).
2. Mỗi view được sơn đều có **giá trị lưu riêng**: associated object trên view (mẫu
   QA20) hoặc NSMapTable yếu→mạnh theo view (mẫu QA19). Sơn khi đã có bản lưu thì
   không ghi đè bản lưu (giữ opacity gốc thật); hiện lại = trả đúng bản lưu rồi xoá.
3. Mọi đường teardown (split tắt, pane đóng, button bị huỷ, ABHost teardown pane)
   đều phải khôi phục trước khi view chết — không để view nào mang opacity 0 rò sang
   phiên/layout khác, và không để adapter/owner báo trạng thái mờ giả.
4. Không animation ở cả hai chiều (khớp QA20/QA19): mờ và hiện đều tức thì. Mọi hiệu
   ứng chuyển cảnh của bar (fade 0,18 s của Chrome) là của bar, không liên quan.

## 3. Chủ trạng thái + timer + feed activity

### 3.1 Controller duy nhất phía SCPCarSplit — quan hệ với ba timer 4,0 s sẵn có

File mới: `SCPCarSplit+AutoHide.h/.m` (module OmniCarSplitScreen), category trên
SCPCarSplit, trạng thái giữ trong **file statics của TU này** (đúng tiền lệ wake1 giữ
state owner trong statics của SCPCarSplit+BridgeWake.m): `ahFaded` (BOOL), `ahTimer`
(NSTimer), `ahSuspended` (BOOL — §4), `ahKbHold` (BOOL — §4.2), registry các view đã
sơn để khôi phục hàng loạt. Cài một lần bởi `-[SCPCarSplit ahInstall]` gọi từ cùng
điểm keo `__init_1` của SCPHooks.m ngay sau `bwInstallOwner` (CarPlayApp only — cùng
gate process với owner).

- **Một timer duy nhất cho toàn phiên split** (không theo pane — khác QA19, giống
  QA20): NSTimer một lần 4,0 s trên main runloop. Activity → nếu đang mờ thì hiện lại
  (khôi phục toàn bộ phía CarPlay + ép phát xuống host, xem §3.4), rồi **luôn** gài
  lại timer từ đầu. Timer bắn → nếu đủ điều kiện §4.2 thì đặt `ahFaded = YES`, sơn
  toàn bộ phía CarPlay, ép `pushHostFramesLive:NO` + `publishKnobsSoon` để gương
  phía host nhận `fade`/`kfade` trong cùng nhịp, rồi gọi `bwRecomputeForPane:` cho
  mọi pane hosted (đầu vào HIDDEN vừa đổi, §3.3).
- **Quan hệ với ba timer sẵn có — không phá, không gộp:** `pane.barTimer` (Chrome,
  cho menu của từng pane), `trayTimer` (Picker), `ratioTimer` (RatioMenu) giữ nguyên
  chủ, nguyên chu kỳ, nguyên điểm gài. Timer AutoHide là timer **thứ tư độc lập**,
  chỉ quản opacity của controls; nó không gài lại, không huỷ, không đọc ba timer kia.
  Hai đồng hồ bar/AutoHide cùng mốc 4,0 s nhưng chạy từ các sự kiện gần nhau chứ
  không khoá pha: HIDDEN của wake chỉ đạt khi **cả hai** đã bắn (§3.3) — độ lệch pha
  vài trăm ms là chấp nhận được và đã được mô hình `transient` của wake1 hấp thụ.
- Vòng đời: timer chỉ chạy khi split active. `setActive:NO` / `dashboardInvalidated`
  (cùng điểm gọi `bwSessionTeardown`, SCPCarSplit.m:247) → `ahSessionTeardown`:
  invalidate timer, khôi phục mọi opacity đã sơn cả hai phía (phía host: lần push
  frame teardown vốn đã đưa handle về hình học; bản lưu phía ABHost được khôi phục
  trong đường teardown pane của chính ABHost — strand ABHost phải nối điểm này),
  `ahFaded = NO`.

### 3.2 Feed activity — từng điểm, bám điểm đã chứng minh của QA20/QA19

Đầu vào duy nhất của controller: `-[SCPCarSplit ahNoteActivity:(AHACTSource)src]`
(main queue; gọi khi đang không active = no-op). Các điểm feed — tất cả là **điểm gọi
cộng thêm** tại cuối/kề các hàm có sẵn, không sửa câu lệnh gốc nào (đúng kỷ luật các
điểm gọi của wake1 ở §1.3 design-bridgewake):

**Phía CarPlay (trong process):**
- **F1 — `SCPCarSplitView hitTest:withEvent:` (SCPCarSplitView.m:14).** Điểm tương
  đương 1-1 với nguồn chính của QA20 (cùng IMP @0xe88c của gốc). Cộng **một** câu
  lệnh sau khi đã có `hit`: nếu `event.type == UIEventTypeTouches`, điểm trong
  bounds, view có window, và tồn tại touch pha Began với `touch.window == self.window`
  (nguyên bộ lọc của QA20) → `ahNoteActivity(AHSourceContainer)`. Không dùng block
  `touched` sẵn có (SCPCarSplit.m:309) — block đó là code gốc đã kiểm chứng
  (hideBarsForTouchOn + focus), không chồng việc lên nó.
- **F2 — Chạm chrome phía host quay về CarPlay:** `bridgeHandleTapped:`
  (SCPCarSplit.m:2490, nhận `appbridge.handletap` từ ABPane.handleHit) và
  `remoteKnobTouch:` (SCPCarSplit+Divider.m, nhận `appbridge.knobtouch` từ
  ABKnobView) → feed. Hai đường này vốn đã là "tiếng gọi" của các tay nắm vô hình
  phía SpringBoard; chúng chứng minh hit target mờ vẫn sống mà không cần ABHost tự
  quan sát thêm (§3.2 phía host).
- **F3 — `homeButtonTapped` (SCPCarSplit.m:2991):** cú chạm vào logo vô hình (nằm
  ngoài container, trong launcher host) → feed. Các chạm trên tabParent ngoài
  container và ngoài homeButton (vùng dashboard trống) **không** có feed — chấp
  nhận: chúng không tác động UI nào, và QA20 cũng phải nhờ recognizer dự phòng mới
  thấy chúng; bản rebuilt chủ đích không thêm recognizer mới (xem F5).

**Liên process (từ app hosted):**
- **F4 — Gói `act` mới trên namespace bridgewake** (xem §3.2.1): ABInApp phát khi
  thấy Began trong phiên hosted hợp lệ; owner nhận trong TU BridgeWake rồi chuyển
  `ahNoteActivity(AHSourceApp)`. Đây là đường thay cho relay sendEvent của QA19 —
  khác ở chỗ relay của ta nằm trong hook sendEvent **đã tồn tại** của wake1
  (ABInApp.m:563, điểm probe §5.3 design-bridgewake), không thêm hook thứ hai.

**Phía SpringBoard: không có feed nào.** ABHost không quan sát chạm, không tự hiện —
nó chỉ áp `fade`/`kfade` owner gửi (giữ nguyên tắc §6 của design-bridgewake: ABHost
không tự sinh trạng thái). QA19 cần recognizer trên box vì state của nó sống ở
SpringBoard; state của ta sống ở CarPlay nên hai recognizer đó là thừa. Khoảng trống
chấp nhận và ghi rõ: cú chạm rơi vào phần box **ngoài** bề mặt app (letterbox/hole)
không tới app cũng không tới container — QA19 bắt được loại chạm này, ta thì không;
nó là chạm vào vùng chết không tác động UI, cú chạm nội dung kế tiếp vẫn gọi controls
hiện lại bình thường.

**F5 — Điều không làm (nêu để khỏi ai thêm sau):** không gắn recognizer quan sát mới
lên container/tabParent/box như QA20/QA19. QA20/QA19 buộc phải làm vậy vì chúng hook
vào binary lạ không sửa được; bản rebuilt sở hữu source nên F1–F4 phủ đúng các bề mặt
chúng phủ, bằng điểm gọi trực tiếp, ít máy móc hơn.

#### 3.2.1 Gói `act` — mở rộng bridgewake.v1 có kỷ luật

- Kênh mới: `com.anlai.omnicar/bridgewake.v1.act` (tên thứ 5, cùng namespace; khai
  trong SCPShared.m phía SplitScreen và ABChannelNames.m phía AppBridge — hai chuỗi
  phải byte-identical, cổng diff như bốn kênh cũ).
- Loại gói mới: `BWTypeAct = 5` trong BridgeWakePack.h (3 bit type: 0 invalid,
  1 state, 2 query, 3 wake, 4 ack — 5 là giá trị trống đầu tiên; 6–7 vẫn dự trữ).
  Cả hai bản BridgeWakePack.h (SplitScreen + AppBridge) phải identical sau sửa —
  giữ nguyên kỷ luật wake1 (tích hợp diff = 0, harness chạy lại toàn bộ vector).
- Trường của gói act: `v, hash, gen` như luật chung; `seq` tăng đơn điệu phía app;
  `flag` = **kbActive** (§4.2); các trường state/mode = 0. Owner bỏ qua gói act khi
  hash không thuộc bundle đang host hoặc gen cũ (cùng luật chống lạc phiên như wake).
- Throttle phía phát: **0,12 s** (số của QA19/QA20 đã qua xe). Owner nhận act không
  phát lại bất cứ gói nào vì act (chống vòng lặp, cùng luật §3.3 design-bridgewake).
- Test vector bổ sung (đã tính bằng đúng công thức §3.2, tái lập V1 khớp trước khi
  tính): **V9** — act, YouTube (hash28 `0xD3B4E0D`), seq=1, gen=7, flag=0 →
  `0xE9DA706800803805`; **V10** — act, YouTube, seq=2, gen=7, flag=1 (kbActive) →
  `0xE9DA706801003C05`. Strand ABInApp + strand CarPlay đều phải qua V9/V10 ở cả hai
  chiều pack/unpack trong harness của mình, cộng đủ V1–V8 cũ không đổi.

### 3.3 Đầu vào hẹp cho owner wake — HIDDEN cuối cùng cũng đầy đủ

Mẫu có sẵn: EXPANDED đi vào owner qua `bwSetExpandedActive:forBundle:` /
`bwExpandedActive` (SCPCarSplit+BridgeWake.h) — một BOOL, một chiều, owner chỉ đọc.
AutoHide đi vào bằng đúng mẫu đó, nhưng vì mờ là trạng thái **của chính SCPCarSplit**
(không phải tầng ngoài như fullscreen), hình thức là một accessor chỉ-đọc trong cùng
module, khai ở SCPCarSplit+AutoHide.h: `- (BOOL)ahFaded;` — `bwRecomputeForPane:`
đọc nó như một đầu vào thô nữa, cạnh `assigned/live/barHidden/transient/popup`
(§1.2 design-bridgewake). Không ai ngoài AutoHide TU được ghi trạng thái này.

Định nghĩa HIDDEN mới (thay dòng HIDDEN trong bảng §1.2 của design-bridgewake):

```
HIDDEN(p) := assigned(p) && live(p) && barHidden(p) && fadedEffective
             && !transient(p) && !popup(p)
fadedEffective := autohideEnabled ? ahFaded : YES
```

- Khi AutoHide **bật**: HIDDEN lần đầu tiên có nghĩa đen đầy đủ như DuoFace — bar đã
  đóng **và** handle đã mờ **và** knob đã mờ **và** logo đã mờ (bốn hợp phần do một
  `ahFaded` toàn cục bảo chứng, vì controller sơn tất cả trong một lần bắn timer).
- Khi AutoHide **tắt** (kill-switch §3.5): `fadedEffective = YES` cố định → HIDDEN
  quay về **đúng định nghĩa wake1** (bar-only). Đây là luật tương thích bắt buộc:
  tắt tính năng mờ không được âm thầm đổi ngữ nghĩa wake đã nghiệm thu ở wake1.
- `bwRecomputeForPane:` phải được gọi cho mọi pane hosted tại **cả hai** thời điểm
  đổi mờ (bắn timer và hiện lại) — AutoHide TU là bên gọi (nó ở cùng process, gọi
  thẳng method của category BridgeWake; không cần gói tin nội bộ).
- EXPANDED vẫn thắng tuyệt đối như §2.2 design-bridgewake: đang EXPANDED owner phát
  VISIBLE bất kể `ahFaded` (và §4.1 còn treo cả AutoHide khi EXPANDED).

### 3.4 Hai đường hiện lại — phân biệt rõ

1. **Hiện do activity (đường thường, mọi mode):** bất kỳ feed F1–F4 nào tới khi đang
   mờ → controller khôi phục opacity phía CarPlay, ép `pushHostFramesLive:NO` +
   `publishKnobsSoon` (mang `fade = NO`/`kfade = NO` xuống gương), đặt `ahFaded = NO`,
   gọi recompute, gài lại timer. Đây là hành vi QA20 nguyên bản: chạm nào cũng gọi
   controls dậy, kể cả cú chạm đang được app xử lý đồng thời (DRY_RUN).
2. **Hiện do wake (đường ENFORCE):** khi `bwHandleWakePacket:` (SCPCarSplit+
   BridgeWake.m:389) chấp nhận một wake hợp lệ (đúng gen, đúng trạng thái, chưa xử
   lý) và vào WAKING + gọi đường hiện bar như wake1 đã làm, nó gọi thêm **một** lệnh
   `[self ahRevealWithReason:AHRevealWake]` — chính là đường (1) trừ việc gài lại
   timer (wake đã là activity mạnh nhất; gài lại vẫn đúng nên dùng chung thân hàm,
   chỉ khác log). Không có đường hiện thứ ba; ABHost confirm (ack role=1) của wake1
   giữ nguyên vai trò xác nhận chrome đã áp — từ vòng này snapshot của nó có thêm
   sự thật `faded` (§5.2) để log Gate 2 đọc được cả hai lớp.

### 3.5 Cấu hình

- Pref mới: `bridgewake.autoHide` (BOOL) trong cùng miền prefs mà owner đã đọc
  (`bwReloadModesAndRepublish` là điểm nạp lại — AutoHide đọc cùng nhịp qua
  SCPNotePrefsChanged, không tự đăng ký kênh prefs riêng). **Vắng pref = BẬT**: đây
  là tính năng sản phẩm Nguyen vừa chốt, không phải suppression — nó thuần thị giác
  và đảo ngược được bằng bất kỳ cú chạm nào, nên mặc định an toàn là bật.
- Tắt pref khi đang mờ → khôi phục toàn bộ ngay + dừng timer (không để trạng thái
  mờ mồ côi khi chủ nhân của nó đã bị tắt).
- Log: tiền tố `[autohide]` trên OMCLogWrite, tối thiểu các mốc: `fade` (kèm nguồn
  activity cuối + độ trễ kể từ activity cuối), `reveal src=<...>`, `suspend/resume`,
  `teardown`. Đây là các dòng log mà phiên đo §5.5 đối chiếu.

## 4. Phân xử với FS1 (fullscreen) + Wake + Pinch

### 4.1 EXPANDED thắng trạng thái mờ — máy mờ treo hoàn toàn khi fullscreen

- Vào EXPANDED (owner nhận qua `bwSetExpandedActive:forBundle:` như đã thiết kế cho
  FS1): tại cùng điểm đó owner gọi `[self ahSetSuspended:YES]`. AutoHide khi bị treo:
  invalidate timer; nếu đang mờ thì **khôi phục toàn bộ trước** (fullscreen phải bắt
  đầu từ trạng thái thị giác đã biết — cơ chế FS tự quản việc ẩn dock/chrome của nó,
  không chồng lên lớp mờ của AutoHide); `ahFaded` giữ NO trong suốt EXPANDED.
- Ra EXPANDED về SPLIT: `ahSetSuspended:NO` → bắt đầu **visible** với đồng hồ 4,0 s
  gài mới từ thời điểm ra (không mờ tức thì, không mang nợ thời gian của trước khi
  vào fullscreen).
- Phiên **solo hosted** (`soloHostedBundle != nil`, đường `hostSolo:`) xếp cùng
  loại với EXPANDED: treo AutoHide trong suốt phiên solo, khôi phục nếu đang mờ khi
  vào, gài mới khi ra. Lý do: solo là trình bày toàn-màn đã có cơ chế cover riêng
  (`soloCover`), và gương của nó vốn không có handle (`handle = @NO`).
- Hệ quả cho wake: trong EXPANDED/solo, HIDDEN không bao giờ đạt (owner đã phát
  VISIBLE theo §2.2 design-bridgewake; thêm `ahFaded = NO` làm hợp phần `faded` cũng
  sai) — hai lớp khoá độc lập, khớp bảng phân xử đã chốt.

### 4.2 Điều kiện không mờ — chỉ đánh giá tại thời điểm timer bắn

Timer bắn không đồng nghĩa được mờ. Tại thời điểm bắn, controller kiểm (mọi điều
kiện đều là sự thật sẵn có trong SCPCarSplit, không tín hiệu mới):
- `popupOpen` = YES (publishShield đã dùng sự thật này) **hoặc** tray đang lên
  (`self.tray` và không overlay) **hoặc** picker sheet/ratio menu đang mở (đúng tập
  điều kiện làm `hostFrameForPane:` trả zero) → **không mờ**; gài lại timer 4,0 s
  (đánh giá lại sau, không bỏ hẳn chu kỳ).
- `self.resizing` = YES (đang kéo divider) hoặc đang kéo pane (drag ghost sống) →
  không mờ; cú kéo tự nó đã là activity liên tục nhưng pha Moved không qua feed
  Began — đây là cổng **mới** so với QA20 (§1.4), lý do: không được sơn chính divider
  đang nằm dưới ngón tay người dùng sang opacity 0 giữa cú kéo. Kết thúc kéo
  (endResize/endPaneDrag) là điểm feed bổ sung để gài lại đồng hồ từ lúc buông tay.
- **Bàn phím đang hoạt động (kbHold):** gói act mang `flag = kbActive` lấy từ trạng
  thái phiên kb phía app (cùng sự thật §5.5 design-bridgewake dùng cho keyboard
  guard: first-responder session, không suy từ cửa sổ). Owner nhận act với
  kbActive=1 → đặt `ahKbHold = YES` và coi như activity; act với kbActive=0 → gỡ
  hold. Timer bắn trong lúc kbHold → không mờ, gài lại sau 4,0 s (hold tự hết hạn
  nếu 10 s không có act làm mới — chống kẹt khi app chết giữa phiên gõ). QA20/QA19
  không có cổng này (§1.4); cổng được thêm vì bản rebuilt đã có sẵn tín hiệu kb đã
  kiểm chứng, và mờ tay nắm giữa phiên gõ gây nhấp nháy khi người dùng chạm qua lại
  giữa bàn phím và nội dung.

### 4.3 Luật pinch đối với đồng hồ mờ

- **Cặp pinch là activity theo nghĩa chung, không phải theo nghĩa riêng.** Các ngón
  của pinch là chạm thật trên container → chúng đi qua feed F1 (Began) như mọi cú
  chạm, nên chúng gài lại đồng hồ và — nếu đang mờ — gọi controls hiện lại. Đây là
  đúng hành vi QA20 (feed của nó không phân biệt được pinch với chạm thường).
- **Controller pinch không tự phát activity.** SCPPinchController không gọi
  `ahNoteActivity`, không gọi `setBarVisible:`, không gài lại barTimer — giữ nguyên
  luật cách ly §2.3 của design-bridgewake. Không tồn tại đường "pinch → tiếng gọi
  activity riêng" nào trong thiết kế này.
- Hệ quả phân xử (khớp bảng §2.2 đã chốt, không đổi): đang mờ (HIDDEN) thì
  `pinchAllowed = 0` — cử chỉ hai ngón bắt đầu trong trạng thái mờ bị tính là cử
  chỉ gọi-dậy: Began đầu tiên hiện controls, pinch không được nhận diện thành lệnh
  fullscreen trong cử chỉ đó. Muốn pinch-out phải bắt đầu khi controls đang hiện.
  Pinch bắt đầu khi đang hiện: Began gài lại đồng hồ → thời điểm bắn mờ nhất là
  4,0 s sau đó, trong khi một cử chỉ pinch kết thúc trong chưa đầy 4,0 s → **timer
  không thể bắn giữa một cặp pinch đang hình thành**. An toàn theo cấu trúc, không
  cần cổng riêng cho pinch.

### 4.4 Mức hoàn chỉnh của tính năng theo WAKE_MODE (nói thẳng)

| Tổ hợp | Hành vi trên xe | Mức |
|---|---|---|
| AutoHide BẬT + WAKE_MODE = DRY_RUN (mặc định hiện tại) | Sau 4,0 s idle, **toàn bộ** nút mờ hẳn (đúng QA20). Chạm đầu tiên sau khi mờ: **vẫn vào app** (không nuốt — DRY_RUN theo thiết kế wake) đồng thời gọi toàn bộ controls hiện lại. Đây là parity đầy đủ với QA20+QA19, và là mức tính năng này **tự nó hoàn chỉnh** mà không cần wake đổi mode | Hoàn chỉnh mức QA20 |
| AutoHide BẬT + WAKE_MODE = ENFORCE (chỉ khi wake qua đủ Gate của WO) | Chạm đầu trong pane hosted bị ABInApp nuốt trọn dãy, phát wake → owner hiện bar + AutoHide hiện toàn bộ controls; app **không nhận** cú chạm đó; chạm kế tiếp đi bình thường. Đây mới là ngữ nghĩa DuoFace QA180 ("gọi lại 1 chạm không click app") | Hoàn chỉnh mức QA180 — phụ thuộc cổng nghiệm thu của wake, AutoHide không tự mở cổng đó |
| AutoHide BẬT + PINCH_MODE bất kỳ | Không đổi hai mức trên. Pinch chỉ bị ảnh hưởng qua phân xử §4.3 | — |

Nói cách khác: AutoHide **không** phụ thuộc ENFORCE để có giá trị — nó hoàn thiện
phần "ẩn hoàn toàn" của lệnh Nguyen ngay ở DRY_RUN, và nó cấp cho wake phần còn
thiếu để ENFORCE (khi được nghiệm thu riêng) có một HIDDEN đúng nghĩa đen.

## 5. Kế hoạch theo file + cổng tĩnh + điểm đo trên xe

### 5.1 Strand CarPlay (module OmniCarSplitScreen — cả hai cây project/ + src/)

**File mới:**
- `SCPCarSplit+AutoHide.h` — interface: `ahInstall`, `ahNoteActivity:`,
  `ahRevealWithReason:`, `ahSetSuspended:`, `ahFaded` (chỉ-đọc cho owner),
  `ahSessionTeardown`.
- `SCPCarSplit+AutoHide.m` — controller (statics, timer, sơn/khôi phục phía
  CarPlay, feed receiver phía owner cho gói act được TU BridgeWake chuyển vào —
  xem điểm nối dưới), đọc pref `bridgewake.autoHide` cùng nhịp
  `bwReloadModesAndRepublish`.

**Điểm gọi cộng thêm (không sửa câu lệnh gốc):**
- `SCPCarSplitView.m` — F1: một câu feed trong `hitTest:withEvent:` sau khi có hit
  (bộ lọc Began nguyên văn QA20). View lấy split qua `[SCPCarSplit shared]`, nil thì
  no-op.
- `SCPCarSplit.m` — `hostFrameInfo:` cộng key `@"fade"` tại đoạn merge (sau
  `hostBarInfoForPane:`, chỉ khi pane != nil); `publishKnobsNow` cộng `@"kfade"`
  cạnh `@"knobs"` trong payload; F2 tại `bridgeHandleTapped:`; F3 tại
  `homeButtonTapped`; gọi `ahSessionTeardown` cạnh `bwSessionTeardown` trong
  `dashboardInvalidated`.
- `SCPCarSplit+Chrome.m` — áp-lại sơn tại cuối `layoutBarForPane:` (handle).
- `SCPCarSplit+Layout.m` — áp-lại sơn tại cuối `rebuildDividers` (divider + knob).
- `SCPCarSplit+Divider.m` — F2 tại `remoteKnobTouch:`; feed + hết-treo-kéo tại
  `endResize`/điểm kết thúc kéo divider.
- `SCPCarSplit+BridgeWake.m` — (i) `bwRecomputeForPane:` cộng hợp phần
  `fadedEffective` (§3.3); (ii) `bwHandleWakePacket:` gọi `ahRevealWithReason:`
  trên đường chấp nhận (§3.4); (iii) đăng ký receiver cho kênh `act` trong
  `bwInstallOwner` + handler `bwHandleActPacket:` chỉ làm hai việc: kiểm
  hash/gen, chuyển owner → `ahNoteActivity:` (kèm kbHold từ flag); (iv)
  `bwSetExpandedActive:forBundle:` gọi `ahSetSuspended:` cùng nhịp (§4.1);
  (v) `bwReloadModesAndRepublish` nạp lại cả pref AutoHide.
- `SCPShared.m` — hằng tên kênh `bridgewake.v1.act`; `SCPHooks.m` — gọi `ahInstall`
  sau `bwInstallOwner` trong `__init_1`; `Makefile` — thêm TU AutoHide.
- `BridgeWakePack.h` (bản SplitScreen) — `BWTypeAct = 5`.

### 5.2 Strand ABHost (module OmniCarAppBridge — ABChannels.m + ABHostBMethods.m)

- `ABChannelNames.m` — hằng tên kênh `bridgewake.v1.act` (byte-identical với
  SCPShared.m — cổng diff như bốn kênh cũ). Strand này **không** đăng ký nhận kênh
  act (ABHost không tiêu thụ act); hằng tồn tại để ABInApp (cùng module) phát.
- `BridgeWakePack.h` (bản AppBridge) — `BWTypeAct = 5`, identical với bản
  SplitScreen sau tích hợp.
- `ABChannels.m` — handler `appbridge.frame`: đọc thêm `ui[@"fade"]` (vắng = NO) và
  truyền xuống; handler `appbridge.open`: cùng đường áp frame ban đầu phải mang
  fade theo (kiểm cấu trúc handler open hiện hành — nó gọi openApp trước, strand
  phải nối fade vào đúng điểm áp handle của open); handler `appbridge.knobs`: đọc
  thêm `note.userInfo[@"kfade"]` (vắng = NO) → `-[ABHost setKnobsFade:]`.
- `ABHostBMethods.m` — (i) mở rộng `setFrame:forApp:live:handle:passInsets:` bằng
  tham số fade **hoặc** method áp riêng `-applyFade:forPane:` được setFrame gọi sau
  `setHandleVisible:` (chọn một, ghi vào biên bản; hành vi khi fade vắng phải bằng
  bản hiện tại); (ii) statics phía host: `ahHostFadeByPane` (fade gần nhất theo
  pane) + bản lưu opacity theo view (NSMapTable, mẫu QA19) + `ahHostKnobFade`
  toàn cục; (iii) `setKnobs:` áp `ahHostKnobFade` cho knob sinh mới, và method mới
  `-setKnobsFade:` quét sơn/khôi phục mọi knobView hiện có; (iv) teardown pane:
  khôi phục mọi bản lưu của pane trước khi view bị huỷ; (v)
  `bwAppliedSnapshotForBundle:` cộng key `faded` (sự thật đã áp, phục vụ ack/log —
  không đổi ngữ nghĩa ack hiện tại).
- Kỷ luật phía host: chỉ áp khi `nativeVisible` (kết quả `handle && !collapsed`
  của lần setFrame gần nhất) = YES; frame mới với `handle` = NO → khôi phục bản lưu
  của pane đó và ghi fade = NO (đúng QA19 stop).

### 5.3 Strand ABInApp (module OmniCarAppBridge — ABInApp.m)

- Trong hook sendEvent **đã tồn tại** (cài tại ABInApp.m:563, cùng điểm probe của
  wake1): tại đường Began, khi phiên hosted hợp lệ theo đúng các sự thật state
  client sẵn có (sessionValid — không thêm tiêu chí mới), phát gói act:
  token riêng theo idiom `notify_register_check` (như `ABKeyboardPublish`),
  `notify_set_state(token, BWPack(act))` rồi `notify_post(bridgewake.v1.act)`.
- Throttle **0,12 s** phía phát (mốc thời gian tĩnh trong TU). `flag` = trạng thái
  kbActive hiện hành của §5.5 design-bridgewake (first-responder session) tại thời
  điểm phát.
- Kỷ luật: act phát **cả khi WAKE_MODE = DRY_RUN/OFF** (AutoHide là tính năng độc
  lập với suppression — giống relay QA19 phát bất kể cổng nuốt); act không bao giờ
  mang nội dung chạm (không toạ độ, không số ngón — chỉ hash/gen/seq/flag); đường
  nuốt của suppression engine **không đổi một dòng** vì act (act nằm ở đường quan
  sát Began trước quyết định nuốt, và dãy bị nuốt vẫn phải tính là activity — nó
  chính là cú chạm phát wake).
- Unit test phía strand: harness pack/unpack qua V9/V10 + V1–V8 không đổi.

### 5.4 Tích hợp + cổng tĩnh chung (đo trên candidate cuối, như kỷ luật wake1)

1. Hai bản BridgeWakePack.h identical (diff = 0); harness hai module qua V1–V10.
2. Chuỗi `bridgewake.v1.act` byte-identical ở SCPShared.m / ABChannelNames.m;
   có mặt trong cả hai slice của SplitScreen + AppBridge trên bản FAT.
3. Grep kỷ luật sơn: mọi code mới của tính năng chỉ chứa gán `layer.opacity` —
   **0** phép gán `.hidden =`, `.alpha =`, `userInteractionEnabled` trong các hunk
   mới (trừ các dòng gốc có sẵn).
4. Thân `setBarVisible:forPane:` (Chrome) và các thân hàm gốc đã khoá ở wake1 giữ
   nguyên từng dòng (hash như cổng §7 của wake1); `hostFrameInfo:` — tập key gốc là
   **tập con** của tập key mới, giá trị các key gốc không đổi công thức.
5. Ba timer gốc không bị đụng: grep `barTimer`/`trayTimer`/`ratioTimer` trong diff
   chỉ xuất hiện ở các dòng đọc (nếu có), không ở phía gán/huỷ.
6. Selector parity hai module so với wake1: chỉ **thêm** (ah*, bwHandleActPacket:,
   applyFade/setKnobsFade phía host), không mất selector nào; `sendEvent` vẫn chỉ
   tồn tại một hook duy nhất trong AppBridge (ABInApp) — act không tạo hook mới.
7. Khoá an toàn: pref `bridgewake.autoHide` = OFF hoặc AutoHide suspended → hành vi
   thị giác và định nghĩa HIDDEN đo được bằng đúng wake1 (cổng hồi quy tĩnh: đường
   `fadedEffective` rẽ đúng theo pref).

### 5.5 Điểm đo trên xe — gộp vào đúng một phiên (theo kỷ luật một phiên gộp)

Điều kiện nền: bản FAT chứa AutoHide, WAKE_MODE giữ DRY_RUN (mặc định), PINCH giữ
nguyên trạng thái của vòng FS1. Các điểm đo, mỗi điểm ghi mốc log `[autohide]` /
`[wake1]` / `[do] bw probe` đối chiếu ảnh chụp màn hình xe:

1. **Mờ đủ và mờ hết:** vào split hai pane (một native, một hosted), không chạm
   4,0 s → ảnh: handle cả hai pane, divider + knob, logo/home đều biến mất; log:
   dòng `fade` xuất hiện một lần, độ trễ từ activity cuối ≈ 4,0 s. Thanh bar (nếu
   đang mở) tự đóng theo timer riêng của nó — ghi riêng, không gộp verdict.
2. **Chạm đầu sau mờ (DRY_RUN):** chạm vào nội dung pane hosted → app **nhận** cú
   chạm (hành vi trong app xảy ra) **và** toàn bộ controls hiện lại trong cùng
   khoảnh khắc; log: act tới owner → `reveal src=app`. Chạm vào tay nắm **vô hình**
   phía CarPlay và phía host → vẫn mở được bar (chứng minh hit target sống).
3. **Gương hosted đồng bộ:** trong cùng phiên, khi mờ: ABPane handle + ABKnobView
   mờ cùng nhịp với phía CarPlay (ảnh chụp vùng ô hosted + vùng vạch ngăn); khi
   hiện: snapshot ack/log phía host báo `faded` khớp trạng thái owner — không có
   trường hợp một phía mờ một phía hiện kéo dài quá một nhịp push frame.
4. **Không mờ sai lúc:** mở ratio menu rồi để yên quá 4,0 s → không mờ; kéo divider
   giữ quá 4,0 s → không mờ giữa cú kéo, buông tay thì đồng hồ tính lại từ lúc
   buông; mở bàn phím trong app hosted và gõ quá 4,0 s → không mờ giữa phiên gõ.
5. **FS1 phối hợp** (nếu bản gộp có FS1): vào EXPANDED khi đang mờ → controls của
   FS xuất phát từ trạng thái sạch (không còn lớp mờ cũ); ở EXPANDED quá 4,0 s →
   AutoHide không bắn; ra EXPANDED → hiện đầy đủ, mờ lại chỉ sau 4,0 s idle mới.
6. **Không kẹt mờ:** lặp 10 chu kỳ mờ/hiện liên tiếp (chạm–chờ–chạm), đổi app giữa
   lúc đang mờ, ngắt CarPlay giữa lúc đang mờ rồi kết nối lại → không trường hợp
   nào controls mất vĩnh viễn hoặc opacity bị lưu sai (accent của handle, scale
   active của knob vẫn đúng sau khi hiện lại).

### 5.6 Rủi ro + câu hỏi mở (ghi để GPT/Nguyen phán, không tự quyết trong thiết kế)

- **R1 — Độ trễ hiện lại phía host.** Đường hiện phía host đi qua NSDistributed
  (push frame sau activity). QA19 hiện tại chỗ trong SpringBoard nên tức thì hơn.
  Nếu đo ở §5.5 điểm 3 thấy lệch nhịp gây khó chịu, phương án dự phòng là ABHost
  được phép hiện **tại chỗ** khi nhận tiếng gọi handletap/knobtouch do chính nó
  phát (chỉ hiện, không mờ tại chỗ) — chưa đưa vào thiết kế chính vì nó phá nguyên
  tắc một-chủ-trạng-thái; chỉ mở khi có số đo.
- **R2 — hostFrameInfo là code gốc đã VERIFIED.** Cộng key là thay đổi tối thiểu
  nhưng vẫn là thay đổi vào một IMP đã đóng dấu; cổng superset §5.4.4 là điều kiện
  bắt buộc, và strand CarPlay phải ghi diff của riêng hàm này vào biên bản.
- **R3 — kbHold phía owner** phụ thuộc act đều đặn từ app đang gõ. Nếu app hosted
  không cài được hook ABInApp (bundle bị loại trừ khỏi vai app — 6 bundle ở
  AppBridgeEntry) thì phiên gõ của nó không sinh act; khi đó cổng kb không có tác
  dụng cho app đó và hành vi quay về đúng QA20 (không cổng kb). Chấp nhận, ghi rõ.
- **R4 — Mặc định BẬT của pref** là quyết định sản phẩm theo lệnh Nguyen; nếu GPT
  muốn staging kiểu DRY_RUN (chỉ log, không sơn) cho vòng đầu, controller chỉ cần
  thêm một giá trị pref trung gian — thiết kế không khoá cứng điểm này.
