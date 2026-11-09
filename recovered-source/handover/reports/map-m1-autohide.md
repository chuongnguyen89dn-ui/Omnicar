# STRAND M1 — BẢN ĐỒ AUTOHIDE LIFECYCLE (cleanup vòng đời khi đóng split)

- Loại việc: **chỉ-đọc** — bản đồ thay đổi cho vòng sửa sau. Không sửa file nguồn nào trong strand này.
- Cây nguồn: `~/workspace/push9-clone/recovered-source/src/`, git HEAD **`38735c5bef6dc22ca9cb11f4e894725ce494be41`** (kiểm bằng `git rev-parse HEAD` tại thời điểm đọc). Mọi `file:line` dưới đây trích từ HEAD này bằng grep/read trực tiếp, **không** chép số dòng từ tài liệu cũ.
- File chính: `SplitScreenA/SCPCarSplit+AutoHide.m` (361 dòng), `SplitScreenA/SCPCarSplit.m` (3523 dòng), `SplitScreenA/SCPCarSplit+BridgeWake.m` (963 dòng). File phụ: `SplitScreenA/SCPHooks.m`, `AppBridgeB/ABHostBMethods.m` (chỉ phần fade phía host).
- Viết tắt đường dẫn: `AH` = `SplitScreenA/SCPCarSplit+AutoHide.m`, `CS` = `SplitScreenA/SCPCarSplit.m`, `BW` = `SplitScreenA/SCPCarSplit+BridgeWake.m`, `HK` = `SplitScreenA/SCPHooks.m`, `ABH` = `AppBridgeB/ABHostBMethods.m`. Dòng ghi đầy đủ `AH:190` = dòng 190 của file đó.

## Tóm tắt chốt (đọc trước)

1. `ahSessionTeardown` (cleanup AutoHide duy nhất hiện có) có **đúng một caller trong toàn cây**: `CS:288`, nằm trong `dashboardInvalidated` — đường ngắt kết nối xe. Đường đóng split thường (`closeGoingHome:`, 12 call site) **không gọi teardown ở bất kỳ đâu** → thoát split lúc đang mờ là rò toàn bộ trạng thái phiên (faded, sơn opacity 0, kb-hold, timer chờ) sang phiên sau.
2. Sửa đúng KHÔNG phải "chỉ reset BOOL": phải chạy cleanup có ngữ nghĩa teardown (dừng timer + phục hồi opacity gốc từ registry + xoá faded/kb-hold) **ở đầu `closeGoingHome:`**, khi mọi view của phiên còn truy cập được qua tập hiện tại — trước `hostCloseAll` (`CS:1737`) và rất xa trước điểm `dividers = nil` (`CS:1763`).
3. **Không được** dùng `ahRevealBody:` trên đường đóng: nó phát frame/knob packet + re-aggregate BridgeWake cho phiên đang chết, và kể cả ở dạng wrapper nó còn arm lại timer; đồng thời nó *không* dọn timer/kb-hold/suspended (xem §4).
4. Có **một bẫy thứ tự bắt buộc phải xử lý khi sửa**: caller `soloBundle:` hosted gọi `hostSolo:` (đặt `ahSuspendedState = YES`) *trước* `closeGoingHome:` (`CS:2316–2318`) — cleanup mù kiểu teardown (reset cả suspended) sẽ phá trạng thái treo hợp lệ của phiên solo sống sót sau khi split đóng. Cleanup trên đường đóng phải giữ `ahSuspendedState` khi `soloHostedBundle != nil` (xem §3.3).
5. `ahSessionStarted` (`AH:323`) xác minh lại từ HEAD: **không reset bất kỳ trạng thái phiên nào** — chỉ đóng dấu activity + arm timer. Mọi thứ cleanup bỏ sót ở đường đóng đều được phiên mới kế thừa nguyên vẹn (xem §5).

---

## §1 — Đường đóng split hiện tại: `closeGoingHome:` và mọi caller

### 1.1 Thứ tự bước thật của `closeGoingHome:` — `CS:1732–1774`

Điểm hiện tại (đọc nguyên văn `CS:1732–1774`):

| Bước | Dòng | Hành động | View của phiên còn truy cập được? |
|---|---|---|---|
| 0 | `CS:1733` | Guard `if (!self.active) return;` | — |
| 1 | `CS:1734` | Log `CarSplit: tat split (goHome=%d)` | đầy đủ |
| 2 | `CS:1735–1736` | Snapshot scenevis `going-home` cho mọi pane — trước mọi detach | đầy đủ: `allPanes` (handle), `self.dividers` (+knob), `self.homeButton` đều sống |
| 3 | `CS:1737` | `[self hostCloseAll]` → `CS:1882–1887`: post `SCPNoteBridgeCloseAll` (trừ solo: `except: soloHostedBundle`) + `bwRecomputeForPane:` cho mọi hosted pane | hosted VC còn gắn; **tại đây `ahFaded` vẫn = giá trị của phiên (nếu đang mờ là YES)** → recompute này đọc `ahFaded` tại `BW:514` khi tính `fadedEffective` |
| 4 | `CS:1738–1750` | Vòng pane: `barTimer` invalidate/nil; `detachVC:background:YES` nếu có `vc` (`CS:1741–1743`); `pane.vc = nil`, `pane.bundleID = nil` vô điều kiện; `pane.picker removeFromSuperview` + nil | Sau vòng này: `vc`/`bundleID` đã mất. Handle/divider/homeButton **chưa** bị đụng — `detachVC:` (`CS:1200–1229`) chỉ tháo view của VC (`willMoveToParent`/`removeFromSuperview`/`removeFromParent` + `SCPResetDetachedView` khôi phục **alpha của VC view**, `CS:1216–1225`) — nó KHÔNG khôi phục `layer.opacity` của handle/divider/knob/homeButton do AutoHide sơn |
| 5 | `CS:1751` | `self.active = NO` | Từ đây mọi cổng `self.active` (timer arm, activity feed) đóng |
| 6 | `CS:1752–1758` | `pending` clear, `publishBusy`, `removePickerSheet`, `hideRatioMenu`, `cancelPaneDrag`, `removeCoverFromPane:` cho `self.slots`, `resizing = NO` | `slots`/`dividers` vẫn còn cho tới bước 7 |
| 7 | `CS:1759–1765` | Giữ container vào biến local, rồi `self.container = nil; self.slots = nil; self.fractions = nil; self.dividers = nil; self.floatPane = nil; self.floatClosing = NO` | **Đường ranh tháo hẳn**: sau dòng `CS:1761–1763`, divider/knob chỉ còn với tới được qua registry yếu `ahPaintedViews`; handle chỉ còn qua subtree của container local; `allPanes` (đi qua slots) coi như rỗng |
| 8 | `CS:1766–1770` | Animation 0.2 s `container.alpha = 0`, completion mới `removeFromSuperview` | Subtree container còn sống nhờ biến local + animation block cho tới khi completion chạy; sau đó view có thể dealloc → entry yếu trong `ahPaintedViews` tự biến mất, restore thành **im lặng bỏ qua** |
| 9 | `CS:1771–1773` | `goHome` → dashboard event type 1; `refreshAppTabSoon`; **`publishKnobsSoon`** | `publishKnobsNow` (`CS:2704–2733`) post `kfade = @([self ahFaded])` tại `CS:2732` — nếu chưa cleanup, packet đóng phiên này mang `kfade = YES` (xem §2.3) |

Những thứ `closeGoingHome:` **không hề gọi** (grep toàn thân hàm `CS:1732–1774` khẳng định vắng mặt): `ahSessionTeardown`, `bwSessionTeardown`, `removeHomeButton`, `fsSessionDidEnd`, pinch `detach`. Đặc biệt `homeButton` **không bị tháo/không bị nil** ở đường này — nút logo sơn opacity 0 vẫn nằm nguyên trong `launcherHost`/dock host sau khi split đóng (đối chiếu: `dashboardInvalidated` gọi `removeHomeButton` ở `CS:273`).

→ Nguyên nhân gốc của lỗi "thoát lúc mờ → mở lại thiếu logo/handle/divider": không phải sơn sai, mà là **đường đóng chính không có cleanup AutoHide nào cả**, trong khi view bị sơn (nhất là `homeButton`) sống sót qua lần đóng.

### 1.2 Mọi caller của `closeGoingHome:` (chỉ tính call site trong code, không tính comment)

Grep `closeGoingHome` trên toàn `src/` cho 12 call site thật, chia 2 file:

**Trong `CS`:**

| # | Dòng | Hàm chứa | Tham số | Ghi chú |
|---|---|---|---|---|
| 1 | `CS:1597` | `afterPaneRemoved:` — `paneCount == 0`, không có float pane | YES | đóng ô cuối → đóng split |
| 2 | `CS:1607` | `afterPaneRemoved:` — nhánh `paneCount == 1` rơi xuống cuối | YES | |
| 3 | `CS:2310` | `soloBundle:` — `bundleID == nil` | YES | |
| 4 | `CS:2318` | `soloBundle:` — hosted: `hostSolo:` ở `CS:2316` **trước**, kẹp `ignoreHomeOnce` | YES | ⚠ bẫy suspended — §3.3 |
| 5 | `CS:2339` | `soloBundle:` — native có pane đích (đã `detachVC:background:NO` ở `CS:2338`) | NO | |
| 6 | `CS:2384` | `soloBundle:` — đường relaunch (không pane sống giữ app) | YES | |
| 7 | `CS:2447` | `exitTapped` — active và không có bundle giữ lại | YES | nút thoát của người dùng |

**Trong `HK` (hook):**

| # | Dòng | Hook | Tham số | Ghi chú |
|---|---|---|---|---|
| 8 | `HK:241` | `_handleHomeEvent:` — `wasActive` thì đóng, sau đó luôn `homePressedDuringSplit:` | NO | phím Home hệ thống |
| 9 | `HK:297` | `presentBaseViewController` — nhánh `@catch` khi adopt ném exception | NO | |
| 10 | `HK:313` | `presentBaseViewController` — không adopt, không throw | NO | dashboard mở app toàn màn |
| 11 | `HK:360` | `dismissBaseViewController` — active và không còn base VC | NO | dashboard về màn hình chính |
| 12 | `HK:603` | handler action phân tán `@"close"` | YES | lệnh đóng từ xa |

→ Đây là đường thoát **thường nhật** (Home, nút thoát, đóng ô cuối, dashboard trình bày app, lệnh close), không phải ca biên. Nghiệm thu GPT "thoát lúc mờ" đi qua một trong 12 điểm này.

### 1.3 `ahSessionTeardown` được gọi từ đâu — `dashboardInvalidated` có phải caller duy nhất?

**Có — khẳng định bằng grep toàn cây.** Mọi lần xuất hiện của `ahSessionTeardown` trong `src/`:

- Khai báo: `SplitScreenA/SCPCarSplit+AutoHide.h:113`.
- Định nghĩa + self-dispatch khi lệch thread: `AH:335`, `AH:338`.
- **Call site duy nhất: `CS:288`** — trong `dashboardInvalidated` (`CS:271–313`), nhánh `if (self.active)`, theo thứ tự: `self.active = NO` (`CS:286`) → `bwSessionTeardown` (`CS:287`) → `ahSessionTeardown` (`CS:288`) → pinch detach (`CS:289`) → `fsSessionDidEnd` (`CS:290`), rồi mới tháo container đồng bộ ở `CS:307–311`.

`dashboardInvalidated` tự nó cũng chỉ có một caller: `HK:249` (`Hook_invalidate` — hook `DBDashboard -invalidate`, tức ngắt kết nối/mất dashboard). Hai hàm `closeGoingHome:` và `dashboardInvalidated` **không gọi lẫn nhau** — hai đường đóng rời nhau hoàn toàn.

Kết luận §1: trạng thái trước = cleanup chỉ tồn tại trên đường ngắt kết nối (hiếm); đường đóng thường (12 caller) trần trụi. Trạng thái sau khi sửa = cả hai đường đều đi qua cleanup (idempotent — §6 — nên nếu một phiên đóng bằng `closeGoingHome:` rồi dashboard invalidate tới sau, lần teardown thứ hai là no-op an toàn; lưu ý `dashboardInvalidated` chỉ gọi teardown khi `self.active` — `CS:282` — nên sau `closeGoingHome:` nó sẽ *không* gọi lại, và điều đó đúng vì cleanup đã chạy ở đường đóng).

Cách kiểm tra tĩnh: `grep -rn "ahSessionTeardown" src/` — trước sửa: 1 call site (`CS:288`). Sau sửa: phải có thêm call site (hoặc hàm cleanup mới) reachable từ `closeGoingHome:`; discriminator: `grep -n "closeGoingHome" -A…` thân hàm chứa lời gọi cleanup trước dòng `hostCloseAll`.

---

## §2 — Các hàm AutoHide nguyên văn: teardown dọn gì, thiếu gì

### 2.1 Bảng định vị từng hàm (đọc từ HEAD)

| Hàm | Vị trí | Vai trò |
|---|---|---|
| Statics phiên | `AH:34–45` | `ahInstalled`, `ahConfigKnown`, `ahEnabled`, `ahFadedState` (37), `ahSuspendedState` (38), `ahKbHoldState` (39), `ahTimerRef` (40), `ahLastActivityAt` (41), `ahLastSource` (42), `ahKbHoldExpiry` (43), `ahPaintedViews` (44, weak `NSHashTable`), `ahSavedOpacityKey` (45) |
| `AHPaintView(view, faded)` | `AH:74–90` (static C) | Sơn: lưu opacity gốc vào associated object (chỉ khi chưa có save — không ghi đè, `AH:78–82`), cộng view vào `ahPaintedViews`, đặt `layer.opacity = 0`. Khôi phục: trả opacity đã lưu, xoá associated object, gỡ khỏi registry (`AH:84–89`); không có save → no-op |
| `ahPaintCurrentSet` | `AH:101–109` | Sơn tập hiện tại: `pane.handle` mọi pane (`allPanes`), mọi `divider` + `divider.knob`, `self.homeButton`. Loại trừ có chủ đích: `ratioKnob`, `pane.bar`, `launcherHost` |
| `ahRestoreAllPainted` | `AH:115–118` | Duyệt `ahPaintedViews.allObjects` (bản sao) và `AHPaintView(view, NO)` cho từng view — khôi phục cả view đã rời tập hiện tại |
| `ahInvalidateTimer` | `AH:122–125` | `[ahTimerRef invalidate]; ahTimerRef = nil;` |
| `ahArmTimer` | `AH:127–134` | Invalidate trước, rồi arm 4.0 s nếu `ahInstalled && ahEnabled && self.active && !ahSuspendedState` |
| `ahFadeBlockedReason` | `AH:140–157` | Cổng lúc timer fire — xem §7 (KHÔNG ĐỤNG) |
| `ahTimerFired:` | `AH:159–185` | `ahTimerRef = nil`; bail nếu `!ahEnabled || !active || suspended || faded` (`AH:162`); deferred thì re-arm (`AH:170`); đạt: `ahFadedState = YES` (`AH:173`), sơn tập hiện tại, `pushHostFramesLive:NO` + `publishKnobsSoon` + `bwRecomputeForPane:` mọi hosted pane |
| `ahRevealBody:` | `AH:190–211` | Xem §4 |
| `ahSessionStarted` | `AH:323–333` | Xem §5 |
| `ahSessionTeardown` | `AH:335–349` | Xem §2.2 |
| `ahApplyCurrentStateToView:` | `AH:351–359` | `AHPaintView(view, ahFadedState)` — điểm sơn-lại-tại-dựng: `CS:3069` (homeButton ở cuối `refreshHomeButton`), `SplitScreenB/SCPCarSplit+Chrome.m:298` (handle), `SplitScreenB/SCPCarSplit+Layout.m:540–541` (divider + knob) |

### 2.2 `ahSessionTeardown` hiện dọn những gì — `AH:335–349` nguyên văn rút gọn

```objc
- (void)ahSessionTeardown {            // AH:335
    if (![NSThread isMainThread]) { dispatch_async(main, ^{ [self ahSessionTeardown]; }); return; }  // AH:336–340
    [self ahInvalidateTimer];          // AH:341 → dừng timer idle, ahTimerRef = nil
    BOOL wasFaded = ahFadedState;      // AH:342
    ahFadedState = NO;                 // AH:343
    [self ahRestoreAllPainted];       // AH:344 → khôi phục opacity gốc mọi view trong registry
    ahKbHoldState = NO;                // AH:345
    ahSuspendedState = NO;             // AH:346
    OMCLogWrite(... @"[autohide] teardown faded=%d", wasFaded);  // AH:347–348
}
```

**Đã dọn (đủ cho phần lõi):** timer idle (dừng + nil) ✔; cờ faded ✔; opacity gốc của mọi view đã sơn (qua registry, không lệ thuộc tập hiện tại) ✔; kb-hold ✔; suspended ✔; có log discriminator `teardown faded=%d` ✔.

### 2.3 Teardown còn THIẾU / chưa trọn so với yêu cầu cleanup vòng đời

Từng mục: điểm hiện tại → nguyên nhân → hệ quả:

1. **`ahKbHoldExpiry` không được reset.** Static ở `AH:43`, được gán ở `AH:253` (arm hold +10 s); teardown `AH:345` chỉ xoá `ahKbHoldState`, không chạm expiry. → Nguyên nhân: thiếu dòng. Hệ quả *tiềm ẩn* (không phải lỗi đang cháy): chừng nào `ahKbHoldState == NO`, cổng `AH:147` short-circuit nên expiry cũ vô hại; nhưng trạng thái phiên sau teardown không "sạch theo nghĩa đen" — nếu một đường tương lai set hold mà không set expiry, deadline cũ sống lại. Cleanup đúng phải xoá cả hai cùng nhau.
2. **`ahLastActivityAt` / `ahLastSource` không được reset.** `AH:41–42`; teardown không chạm. `ahSessionStarted` có đóng dấu lại `ahLastActivityAt` (`AH:330`) nên mốc thời gian tự lành; `ahLastSource` chỉ được ghi ở `AH:235` khi có activity thật → log fade đầu tiên của phiên mới có thể ghi tên nguồn của phiên trước (`AH:182–184`). Mức độ: log/cosmetic, nhưng là "tham chiếu phiên cũ" đúng nghĩa đen — cleanup trọn phải reset (activity = 0 / source mặc định).
3. **Registry không được xoá tường minh.** Không có `[ahPaintedViews removeAllObjects]` ở đâu trong `AH` (grep khẳng định). Registry tự rỗng *theo hệ quả*: `ahRestoreAllPainted` (`AH:115–118`) khôi phục từng view và nhánh restore của `AHPaintView` gỡ view khỏi registry (`AH:88`). → Sau một teardown trọn, registry rỗng trên thực tế. Nhưng tính chất này mong manh: view nào có entry mà *không còn save* sẽ kẹt lại trong registry (theo code hiện tại entry chỉ được thêm cùng lúc với save — `AH:78–82` — nên ca này chưa xảy ra; ghi nhận là bất biến ngầm, không phải lỗi). Cleanup không cần thêm `removeAllObjects` bắt buộc; nếu thêm, phải đặt **sau** `ahRestoreAllPainted`, tuyệt đối không thay thế nó (xoá registry trước restore = mất đường khôi phục opacity).
4. **Không phát tín hiệu mirror — có chủ đích, và là lý do điểm chèn phải đứng trước các packet đóng.** Teardown không gọi `pushHostFramesLive:`/`publishKnobsSoon`/`bwRecomputeForPane:` (khác hẳn `ahRevealBody:` — §4). Phía host tự dọn theo kênh đóng riêng: `ABH:1409–1418` `ahRestorePaneForBundle:` (kênh close/closeall gọi trước `teardownPane:`), và knob host theo `setKnobsFade:` (`ABH:1381–1400`) khi nhận packet `kfade`. Hệ quả ràng buộc thứ tự trên đường `closeGoingHome:`:
   - `hostCloseAll` (`CS:1737`) post closeall → phía ABHost khôi phục handle của pane — phần này tự chạy bất kể cleanup.
   - Nhưng packet **knob cuối** của đường đóng là `publishKnobsSoon` ở `CS:1773` với `kfade = @([self ahFaded])` (`CS:2732`): nếu cleanup chưa chạy trước dòng này, packet mang `kfade = YES` → `AHHostKnobFadeState` phía host giữ YES, knob mirror ở opacity 0 sang phiên sau (packet knob đầu phiên sau mới tự lành). **Đây là bằng chứng cứng thứ hai (sau homeButton) rằng cleanup phải chạy sớm trong `closeGoingHome:`, không phải ở đuôi hàm.**
   - Tương tự `fade` trong `hostFrameInfo` (`CS:2113`): mọi frame push xảy ra trong lúc đóng (detach/hostCloseAll recompute) đều đọc `ahFaded` tại thời điểm đó.
5. **Không có guard `ahInstalled`.** Teardown chạy được cả khi chưa install (statics tồn tại độc lập; `ahRestoreAllPainted` duyệt `nil`/rỗng là no-op an toàn). Không phải lỗi — nhưng điểm chèn mới không cần tự thêm guard này.

### 2.4 Đối chiếu yêu cầu cleanup (đề bài) ↔ hiện trạng teardown

| Yêu cầu | Teardown hiện tại |
|---|---|
| Dừng timer | ✔ `AH:341` |
| Phục hồi opacity gốc TRƯỚC khi tháo view | ✔ về cơ chế (`AH:344` + registry) — nhưng chỉ đúng nếu *điểm gọi* đứng trước tháo view; trên đường invalidate, `removeHomeButton` ở `CS:273` chạy **trước** teardown ở `CS:288` (nút đã `removeFromSuperview` + property nil — khôi phục vẫn tới được nút qua registry yếu chừng nào object còn sống; object nút vừa bị property thả, nếu không còn ai giữ nó có thể dealloc trước `CS:288` và entry tự mất — nút chết thì không rò, nút còn sống thì restore trúng. Ghi nhận: thứ tự invalidate hiện tại *chấp nhận được nhờ registry*, nhưng điểm chèn mới ở đường đóng phải đứng trước cả detach chứ không học theo thứ tự này) |
| Dọn tham chiếu phiên | ◐ gần đủ: thiếu `ahKbHoldExpiry`, `ahLastActivityAt`, `ahLastSource` (mục 1–2 trên) |
| Reset faded / kb-hold / suspended | ✔ cả ba (`AH:343/345/346`) — nhưng reset suspended vô điều kiện là **bẫy** ở đường đóng (§3.3) |

---

## §3 — Điểm chèn cleanup đúng trên đường đóng

### 3.1 Điểm chỉ đích danh

**Chèn lời gọi cleanup ngay sau guard `CS:1733`, cùng nhịp với log/snapshot ở `CS:1734–1736`, và bắt buộc TRƯỚC `hostCloseAll` ở `CS:1737`.**

Lý do, từng ý bám vào thứ tự §1.1:

- Tại điểm này tập sơn hiện tại còn nguyên vẹn và truy cập được *trực tiếp* (không phải qua registry yếu): `allPanes` → handle, `self.dividers` → divider + knob, `self.homeButton` — cả ba nguồn của `ahPaintCurrentSet` (`AH:101–109`) đều sống. Restore qua registry (`AH:344`) ở đây là restore trên view đang gắn trong hierarchy, kiểm chứng được ngay.
- Đứng trước `hostCloseAll` (`CS:1737`) → lần `bwRecomputeForPane:` trong đó (`CS:1885–1886`) và mọi frame push kéo theo đều đọc `ahFaded == NO` (`BW:514`, `CS:2113`): trạng thái đóng không bị nhuộm HIDDEN/faded oan.
- Đứng trước vòng detach (`CS:1738–1750`) → đúng yêu cầu "phục hồi opacity gốc TRƯỚC khi tháo view": không view nào rời hierarchy trong trạng thái opacity 0 + save treo.
- Đứng rất xa trước `CS:1761–1763` (nil slots/dividers) và trước `publishKnobsSoon` đuôi (`CS:1773`) → packet knob cuối mang `kfade = NO` (§2.3 mục 4), phía host nhả knob mirror.
- `self.active` tại điểm này vẫn YES — cleanup không phụ thuộc `active` (teardown không đọc nó), nhưng mọi hệ quả phụ (recompute/publish trong phần còn lại của hàm) diễn ra trong trạng thái faded đã sạch.

**Các điểm chèn SAI, nói rõ để vòng sửa không chọn nhầm:**

- *Sau vòng detach, trước `CS:1751`*: handle/divider vẫn còn nhưng VC đã detach trong lúc `ahFaded` còn YES — mọi packet/recompute trong detach mang fade cũ; muộn vô ích.
- *Sau `CS:1751` / cuối hàm (sau `CS:1765`)*: `dividers`/`slots` đã nil — chỉ còn đường registry yếu; view trong subtree container có thể đã dealloc sau animation completion (`CS:1768–1770`) nếu chèn bất đồng bộ; `publishKnobsSoon` đuôi đã post với `kfade` cũ nếu chèn sau `CS:1773`.
- *Trong `dashboardInvalidated` thêm lần nữa*: không tới được 12 caller của `closeGoingHome:` (§1.3) — sai đường.

### 3.2 Hình thức cleanup sẽ sửa

Không gọi nguyên `ahRevealBody:` (§4). Hai lựa chọn hợp lệ cho vòng sửa, theo thứ tự ưu tiên:

- **(A) Tái dùng `ahSessionTeardown` + sửa bẫy suspended (§3.3) + bổ sung các reset thiếu (§2.3 mục 1–2).** Ít bề mặt mới nhất; log discriminator `[autohide] teardown faded=%d` dùng chung cho cả hai đường đóng — khi đọc log xe, teardown xuất hiện ở *mọi* lần thoát split là dấu hiệu đúng.
- **(B) Hàm cleanup riêng cho đường đóng** (vd `ahCloseCleanup`) gọi các bước con đã có (`ahInvalidateTimer` + `ahFadedState = NO` + `ahRestoreAllPainted` + xoá kb-hold/expiry) và *không* đụng suspended khi solo còn sống. Chỉ chọn (B) nếu (A) phải phình điều kiện khó đọc.

Trạng thái trước/sau tại điểm chèn (phiên đang mờ là ca quyết định):

| Trạng thái | Trước sửa | Sau sửa |
|---|---|---|
| `ahFadedState` khi vào `hostCloseAll` | YES | NO |
| Opacity handle/divider/knob/homeButton lúc detach | 0 (save còn treo trong associated object + registry) | Đã khôi phục giá trị gốc; associated object đã xoá; registry rỗng |
| `ahTimerRef` | Timer idle của phiên cũ vẫn chờ fire (tự chết vô hại khi fire vì `!active` — `AH:162` — nhưng còn sống qua thời điểm đóng) | Đã invalidate + nil tại điểm chèn |
| `ahKbHoldState` / expiry | Giữ nguyên qua lần đóng | NO / 0 |
| Packet `kfade` ở `CS:1773` | YES | NO |
| Log | Không có dòng autohide nào trên đường đóng | `[autohide] teardown faded=1` (nếu chọn A) ngay tại điểm đóng |

### 3.3 ⚠ Bẫy thứ tự suspended — ràng buộc bắt buộc của điểm chèn

Điểm hiện tại: `hostSolo:` đặt `self.soloHostedBundle = bundleID` (`CS:2018`) rồi `[self ahSetSuspended:YES]` (`CS:2019` → `ahSuspendedState = YES`, `AH:280`). Caller hosted của `soloBundle:` gọi theo thứ tự `hostSolo:` (`CS:2316`) → `closeGoingHome:YES` (`CS:2318`). Tức là **khi `closeGoingHome:` bắt đầu, đã tồn tại một phiên solo hosted vừa được treo AutoHide một cách hợp lệ**, và phiên solo đó *sống sót* qua lần đóng split này (nó chính là lý do đóng). `endHostedSolo` (`CS:2035–2045`) là nơi gỡ treo về sau (`ahSetSuspended:NO` ở `CS:2039`).

Nguyên nhân nguy hiểm: `ahSessionTeardown` reset `ahSuspendedState = NO` vô điều kiện (`AH:346`). Nếu vòng sửa gọi thẳng teardown ở đầu `closeGoingHome:` thì riêng caller #4 (`CS:2318`) sẽ bị: vừa suspend xong bị unsuspend → khi solo đang chạy, timer có thể arm lại ở các đường resume và cổng `solo` trong `ahFadeBlockedReason` (`AH:146`) là chốt chặn còn lại duy nhất — làm mỏng một lớp bảo vệ có chủ đích (§4.1 của thiết kế: solo suspend là trạng thái vòng đời, không phải cặn phiên split).

Điểm sẽ sửa (ràng buộc, chọn một):
- Cleanup trên đường đóng **chỉ reset `ahSuspendedState` khi `self.soloHostedBundle == nil`** tại điểm chèn; hoặc
- Lưu `BOOL keepSuspended = (self.soloHostedBundle != nil)` trước teardown và khôi phục sau — kém sạch hơn cách trên; hoặc
- Trong biến thể (B): cleanup đường đóng không chạm suspended, để `endHostedSolo`/`dashboardInvalidated` sở hữu việc gỡ treo.

Kiểm tra tĩnh cho ràng buộc này: đọc call site `CS:2316–2318` cạnh điểm chèn; discriminator — thân cleanup reachable từ `closeGoingHome:` không chứa gán `ahSuspendedState = NO` vô điều kiện, hoặc chứa điều kiện `soloHostedBundle`.

Cách kiểm tra xe bổ sung cho riêng bẫy này: vào solo hosted từ split → AutoHide không được tự chạy trong solo (không fade, không log `[autohide] fade` khi solo đang đứng) — giữ nguyên hành vi hiện tại.

---

## §4 — Vì sao KHÔNG được gọi `ahRevealBody:` trên đường đóng

Định vị: `ahRevealBody:` ở `AH:190–211`; các caller hợp lệ hiện tại chỉ có `AH:236` (activity), `AH:267` (qua wrapper `ahRevealWithReason:`), `AH:287` (unsuspend), `AH:317` (pref off). Từng tác dụng phụ khiến nó sai trên đường đóng:

1. **Cổng thoát sớm làm nó không phải cleanup.** `AH:191`: `if (!ahFadedState) return;` — khi phiên *không* mờ, nó không làm gì cả: timer chờ vẫn chạy, kb-hold vẫn giữ. Cleanup vòng đời phải vô điều kiện; reveal là hàm có điều kiện theo trạng thái hình ảnh.
2. **Nó không dọn ba thứ cleanup bắt buộc.** Trong thân `AH:190–211` không có `ahInvalidateTimer`, không xoá `ahKbHoldState`/`ahKbHoldExpiry`, không xoá `ahSuspendedState`. Ngay cả khi nó khôi phục sơn xong, phiên đóng vẫn để lại timer + hold (timer tự arm lại được qua wrapper — mục 5).
3. **Phát frame packet cho pane đang chết:** `AH:204` `[self pushHostFramesLive:NO]` → `CS:2246–2250`: `sendHostFrameForPane:live:` cho **mọi** hosted pane + `publishShield` + `refreshShieldHoles`. Trên đường đóng, `hostCloseAll` đang/đã ra lệnh đóng các pane này (`CS:1737`/`CS:1883`); một đợt frame "hiện hình" chen vào giữa tiến trình đóng là packet mồ côi — phía host nhận frame cho pane đang teardown, shield holes được dựng lại cho phiên đã chết. Nếu chèn trước `hostCloseAll` thì thứ tự thành reveal-frames → closeall (thừa một vòng publish toàn pane); chèn sau thì thành closeall → reveal-frames (sai thứ tự thật sự).
4. **Phát knob packet:** `AH:205` `[self publishKnobsSoon]` → post bất đồng bộ `appbridge.knobs` với `kfade` (`CS:2688–2695`, `CS:2731–2732`). Packet này thừa (đuôi `closeGoingHome:` đã có `publishKnobsSoon` ở `CS:1773`) và nếu cleanup chọn teardown-ngữ-nghĩa thì packet đuôi tự mang `kfade = NO` đúng lúc — không cần reveal để "báo" phía host.
5. **Đăng lại trạng thái BridgeWake:** `AH:206–207` `bwRecomputeForPane:` cho mọi hosted pane — re-aggregate + có thể queue state packet (`bwQueueEmitForPane:` qua `BW:460+`, emit khi signature đổi) và `bwRenewMaintain`. Trên đường đóng, trạng thái đúng để phát là *kết thúc phiên*, không phải một lần tính lại VISIBLE/HIDDEN cho pane sắp mất; recompute này còn đọc `pane.bar`/hostFrame giữa lúc teardown đang tháo. (Đường invalidate làm đúng thứ tự ngược lại: `bwSessionTeardown` phát INACTIVE ở `CS:287` *trước* `ahSessionTeardown` ở `CS:288`, và teardown AutoHide không tự phát gì thêm.)
6. **Wrapper của nó arm lại timer:** ai sửa mà với tới API công khai `ahRevealWithReason:` (`AH:260–271`) sẽ dính `AH:270` `[self ahArmTimer]` — nếu điểm gọi đứng trước `CS:1751` (`active` còn YES, chưa suspended) thì một timer 4.0 s mới được đặt cho phiên đang đóng; nó fire sau khi đóng và chỉ vô hại nhờ cổng `!active` ở `AH:162` — tức là để lại đúng loại "timer sót" mà cleanup phải loại trừ.
7. **Ô nhiễm bằng chứng:** `AH:208–210` log `[autohide] reveal-applied reason=… views=…` — một lần đóng sẽ giả dạng một lần reveal trong log, phá discriminator khi điều tra xe (reveal = người dùng/chạm đánh thức; teardown = vòng đời).

Phần duy nhất của reveal trùng với cleanup là `ahFadedState = NO` (`AH:192`) + `ahRestoreAllPainted` (`AH:203`) — hai bước đó teardown cũng có (`AH:343–344`), cộng thêm dọn timer/hold. **Kết luận: cleanup = ngữ nghĩa teardown, không phải reveal.**

Cách kiểm tra tĩnh: thân cleanup trên đường đóng (sau sửa) — `grep` không thấy `ahRevealBody`/`ahRevealWithReason` reachable từ `closeGoingHome:`; và log một lần thoát split không xuất hiện `reveal-applied` do đường đóng sinh ra.

---

## §5 — Session start: xác minh rò `ahFadedState` từ HEAD + mọi trạng thái kế thừa

### 5.1 Xác minh lại khẳng định "chỉ gán NO tại hai điểm"

Grep `ahFadedState` trên `AH` (HEAD 38735c5) — mọi phép gán:

| Dòng | Phép gán | Ngữ cảnh |
|---|---|---|
| `AH:37` | `= NO` | Khởi tạo static (một lần, nạp TU) |
| `AH:173` | `= YES` | `ahTimerFired:` — fade thật |
| `AH:192` | `= NO` | `ahRevealBody:` — và bị cổng `AH:191` chặn khi không mờ |
| `AH:343` | `= NO` | `ahSessionTeardown` — caller duy nhất ở đường invalidate (§1.3) |

Ngoài ra chỉ có *đọc*: `AH:162, 191(kiểm), 236, 287, 298 (ahFaded), 317, 342, 358`. **Khẳng định của phiên trước đứng vững tại HEAD này**: ngoài init, `ahFadedState` chỉ về NO qua reveal hoặc teardown.

### 5.2 `ahSessionStarted` — `AH:323–333` nguyên văn rút gọn

```objc
- (void)ahSessionStarted {             // AH:323
    if (![NSThread isMainThread]) { dispatch_async(main, ^{ [self ahSessionStarted]; }); return; }
    if (!ahInstalled) return;          // AH:329
    ahLastActivityAt = CACurrentMediaTime();  // AH:330
    [self ahArmTimer];                 // AH:331
    OMCLogWrite(... @"[autohide] session start");  // AH:332
}
```

Caller duy nhất: `CS:167` trong `activateWithCount:` — ngay sau `self.active = YES` (`CS:166`), trước `setPaneCount:`/relayout. Hàm này **không** reset faded, **không** khôi phục registry, **không** xoá kb-hold/suspended. Điểm reset đúng vì vậy KHÔNG nằm ở session start (sửa ở start là vá triệu chứng: opacity đã sơn trên view của phiên trước — nhất là `homeButton` còn sống — vẫn phải được *khôi phục*, chỉ reset cờ ở start sẽ làm mất save gốc: lần restore sau đọc associated object cũ trên view bị dùng lại, hoặc view mới bị `ahApplyCurrentStateToView:` xử lý theo cờ đã reset trong khi view cũ vẫn opacity 0). Reset đúng = **ở đường đóng** (§3), để session start luôn bắt đầu từ trạng thái đã sạch; `ahSessionStarted` giữ nguyên vai trò đóng dấu + arm.

### 5.3 Mọi trạng thái phiên mới kế thừa nếu đường đóng không cleanup (ca: thoát lúc đang mờ qua `closeGoingHome:`)

| # | Trạng thái rò | Điểm bằng chứng | Hệ quả ở phiên mới |
|---|---|---|---|
| 1 | `ahFadedState = YES` | Không ai gán NO trên đường đóng (§5.1); start không reset (§5.2) | `hostFrameInfo` phát `fade = YES` từ packet đầu (`CS:2113`); `publishKnobsNow` phát `kfade = YES` (`CS:2732`); `bwRecomputeForPane:` tính `fadedEffective` theo cờ cũ (`BW:514`) → pane bị tổng hợp HIDDEN oan |
| 2 | Sơn tại-dựng theo cờ cũ | `ahApplyCurrentStateToView:` (`AH:351–359`) đọc `ahFadedState`; điểm gọi `CS:3069` (homeButton, cuối `refreshHomeButton` — **số dòng thật tại HEAD là 3069**, kiểm lại đúng như đề bài gợi ý), `SplitScreenB/SCPCarSplit+Chrome.m:298` (handle), `SplitScreenB/SCPCarSplit+Layout.m:540–541` (divider/knob) | View **mới dựng** của phiên mới bị sơn opacity 0 ngay tại lúc dựng — đây là cơ chế trực tiếp làm "mở lại split → logo/handle/divider không hiện" dù view cũ đã chết |
| 3 | `homeButton` cũ còn sống + còn mờ | `closeGoingHome:` không gọi `removeHomeButton` (§1.1); nút không nằm trong container bị tháo | Nếu phiên mới giữ lại cùng object nút (đường keep của `refreshHomeButton`, `CS:2923+`), nó hiện lên với opacity 0 và save gốc vẫn treo; chỉ một activity/reveal hợp lệ mới gỡ được |
| 4 | Registry `ahPaintedViews` + associated save còn sót | `AH:44`, `AH:79–81`; không restore trên đường đóng | View còn sống (homeButton, view trong subtree chưa dealloc) giữ opacity 0 + save; view đã chết tự rơi khỏi registry yếu (không rò sang view mới — save nằm trên chính object cũ). Nguy cơ phụ: nếu sau này có ai "chỉ reset cờ" ở start, các save này thành mồ côi không ai khôi phục |
| 5 | `ahKbHoldState = YES` + `ahKbHoldExpiry` tương lai | Gán ở `AH:252–253`; teardown là nơi xoá duy nhất (`AH:345`) ngoài nhánh `kbActive=0` (`AH:255`) và tự hết hạn trong cổng (`AH:149`) | Fade đầu phiên mới bị defer với lý do `kbhold` cho tới khi expiry cũ qua (tối đa ~10 s kể từ act cuối phiên trước) — log `[autohide] fade deferred (kbhold)` ở phiên mới là dấu vết nhận diện |
| 6 | `ahSuspendedState` còn YES | Chỉ gỡ ở `AH:346` (teardown), `ahSetSuspended:NO` qua `endHostedSolo` (`CS:2039`) | Nếu phiên đóng trong lúc suspended mà solo chủ sở hữu nó cũng đã mất (không qua `endHostedSolo`), `ahArmTimer` ở start bị cổng `AH:129` chặn → phiên mới **không bao giờ tự mờ** và không có log lỗi. (Ca solo-còn-sống là hợp lệ — §3.3; ca rò là khi solo đã chết mà treo còn.) |
| 7 | Timer idle chờ fire | `ahTimerRef` (`AH:40`) không invalidate trên đường đóng | Mức độ nhẹ nhất: `ahSessionStarted` → `ahArmTimer` invalidate timer cũ trước khi arm (`AH:128`) nên timer sót không sống qua được session start; trước start, nó fire một lần và tự chết tại cổng `!active` (`AH:162`). Vẫn phải dọn ở đường đóng vì cleanup đúng nghĩa không để callback của phiên cũ tồn tại sau khi phiên kết thúc |
| 8 | `ahLastSource` cũ | `AH:42`, chỉ ghi ở `AH:235` | Log fade đầu phiên mới ghi sai tên nguồn activity của phiên trước (cosmetic, nhưng làm nhiễu điều tra) |

Trạng thái sau khi sửa (cleanup ở §3 chạy): phiên mới kế thừa `faded = NO`, registry rỗng, không save treo, `kbHold = NO / expiry = 0`, timer nil, suspended chỉ còn YES khi có solo sống sở hữu nó. `ahSessionStarted` không cần thêm reset nào — và bản đồ này khuyến nghị **không** thêm reset-cờ ở start như một "lớp bảo hiểm", vì nó che giấu đúng loại rò save/registry ở mục 3–4 (cờ sạch mà view vẫn mờ là trạng thái tệ hơn cờ bẩn).

Cách kiểm tra tĩnh: `grep -n "ahFadedState =" AH` — sau sửa, tập phép gán không đổi cũng được (cleanup dùng teardown sẵn có), nhưng phải chứng minh được đường đi `closeGoingHome:` → (cleanup) bằng grep call site; cộng discriminator phụ: không xuất hiện phép gán `ahFadedState = NO` mới trong `ahSessionStarted`.

---

## §6 — Idempotency: gọi cleanup lặp có an toàn không

Đánh giá trên cleanup hiện có (`ahSessionTeardown`, `AH:335–349`) và các hàm nó chạm:

| Điểm | Dòng | Gọi lần 2 có an toàn? | Lý do |
|---|---|---|---|
| `ahInvalidateTimer` trên timer đã nil/đã invalidate | `AH:122–125` | ✔ an toàn | `invalidate` trên nil là no-op; gán nil lặp vô hại |
| `ahFadedState = NO` / `ahKbHoldState = NO` / `ahSuspendedState = NO` lặp | `AH:343/345/346` | ✔ an toàn | Gán BOOL thuần |
| `ahRestoreAllPainted` trên registry đã rỗng | `AH:115–118` | ✔ an toàn | Duyệt `allObjects` rỗng = không vòng lặp; và nhánh restore của `AHPaintView` (no-save → no-op, `AH:84–89`) chặn khôi phục trùng trên từng view |
| Log teardown lặp | `AH:347–348` | ✔ vô hại | Chỉ thêm dòng `[autohide] teardown faded=0` |
| Thread re-dispatch của teardown | `AH:336–340` | ✔ an toàn, một lưu ý | Gọi ngoài main → hop async rồi chạy trọn một lần trên main. Lưu ý cho điểm chèn: nếu `closeGoingHome:` được gọi ngoài main (hiện tại các caller đều ở main-queue/hook context), cleanup sẽ chạy *sau* theo hàng đợi trong khi thân hàm đóng tiếp tục chạy đồng bộ — thứ tự "trước hostCloseAll" chỉ được bảo đảm khi caller ở main thread, đúng như mọi teardown hiện hữu khác trong TU này vẫn giả định |

**Các điểm KHÔNG idempotent / không an toàn quanh cleanup — phải tránh khi sửa:**

1. **`closeGoingHome:` tự nó được bảo vệ bởi guard `CS:1733`** (`!active` → return): gọi đóng hai lần thì lần hai thoát ngay — cleanup đặt sau guard sẽ không chạy hai lần qua chính hàm này. ✔ theo thiết kế.
2. **Chuỗi đóng nối tiếp `closeGoingHome:` → `dashboardInvalidated`**: sau `closeGoingHome:`, `active == NO` nên nhánh chứa teardown của invalidate (`CS:282–288`) không chạy — không có lần cleanup thứ hai từ đường đó. Ngược lại `dashboardInvalidated` → `closeGoingHome:`: invalidate đã teardown + `active = NO`, `closeGoingHome:` return ở guard. Cả hai chiều đều sạch — cleanup mới không tạo double-run trong thực tế.
3. **`removeHomeButton` lặp** (`CS:3076–3081`): an toàn (`removeFromSuperview` trên view không superview/nil-receiver đều no-op, nil hoá lặp, `setDockShift:0` lặp) — nhưng nó **không thuộc cleanup này**; đừng lôi nó vào đường đóng để "tiện" (nó đổi hành vi gốc của `closeGoingHome:` vốn giữ homeButton — ngoài phạm vi M1).
4. **`ahRevealBody:` lặp**: lần hai tự chặn ở `AH:191` nên *không crash*, nhưng lần một đã phát đủ tác dụng phụ §4 — "an toàn khi lặp" không cứu được "sai ngay lần đầu".
5. **Điểm thật sự không an toàn: cleanup đặt SAU khi view đã tháo.** `ahRestoreAllPainted` đi qua registry **yếu** (`AH:44`): gọi sau `CS:1761–1763` + completion của animation (`CS:1768–1770`) thì entry của view đã dealloc biến mất — restore thành no-op im lặng (không lỗi, nhưng opacity của view *còn sống sót độc lập* như homeButton thì vẫn khôi phục được, còn view chết thì không cần). Tức là cleanup muộn không nguy hiểm kiểu crash, mà nguy hiểm kiểu *tưởng đã dọn*: log vẫn in `teardown faded=1` trong khi một phần restore đã bị bỏ qua lặng lẽ. Đây là lý do §3 chốt điểm chèn sớm thay vì "đặt đâu cũng được miễn trước khi hàm trả về".
6. **`ahSetSuspended:` có cổng tự chặn lặp** (`AH:279`: state bằng nhau → return) nhưng cleanup ở §3.3 không được dùng nó để "sửa" suspended sau teardown (gọi `ahSetSuspended:YES` lại sẽ arm/không-arm theo cổng và phát log suspend thừa) — xử lý bằng điều kiện tại điểm cleanup như §3.3 đã chốt.

Kết luận §6: teardown hiện tại **idempotent theo cấu trúc**; rủi ro lặp nằm ở điểm chèn sai vị trí (mục 5) và ở bẫy suspended (§3.3), không nằm trong thân teardown.

Cách kiểm tra tĩnh: sau sửa, mô phỏng hai chuỗi bằng đọc code — `closeGoingHome:` hai lần liên tiếp; `closeGoingHome:` rồi `dashboardInvalidated` — và khẳng định cleanup chạy đúng một lần hiệu lực, lần còn lại bị guard chặn (`CS:1733` / `CS:282`).

---

## §7 — Giữ nguyên theo đặc tả — KHÔNG ĐỤNG

Các điểm sau nằm trong bản đồ chỉ để vòng sửa tránh phạm vào; mọi thay đổi ở đây là ngoài phạm vi M1:

1. **AutoHide chạy trong EXPANDED (không treo, không chặn).**
   - `AH:141–145`: comment chốt việc xoá expanded-block theo phán quyết ytz4 — `ahFadeBlockedReason` cố ý *không* còn nhánh expanded.
   - `BW:440–454` (`bwSetExpandedActive:forBundle:`): call `ahSetSuspended:` cũ đã bị gỡ; comment `BW:446–453` ghi rõ EXPANDED không còn suspend fade machine.
   - `BW:460+` trong `bwRecomputeForPane:` — đoạn bỏ promote HIDDEN→VISIBLE khi expanded (comment tại vùng `BW:523–531` của file): pane đã mờ trong expanded tổng hợp thành HIDDEN.
   - → KHÔNG thêm lại suspend/block theo expanded ở bất kỳ điểm nào của vòng sửa này; cleanup ở §3 không được khoá theo trạng thái expanded.
2. **Khoá popup / bề mặt mở:** `AH:151–154` — `popupOpen` hoặc `pickerSheet != nil` hoặc `ratioMenu != nil` hoặc `tray != nil && !trayOverlay` → trả `"surface-open"`; hậu quả ở `ahTimerFired:` là defer + re-arm (`AH:164–171`), không huỷ chu kỳ.
3. **Khoá dragging/resizing:** `AH:155` — `resizing || dragGhost != nil` → `"dragging"`, cùng cơ chế defer.
4. **Các khoá lân cận cùng hàm, cũng giữ nguyên:** solo (`AH:146` → `"solo"`), kb-hold chưa hết hạn (`AH:147–150` → `"kbhold"`, tự xoá khi hết hạn ở `AH:149`).
5. **Kỷ luật sơn:** chỉ `layer.opacity`, save/restore từng view, không `hidden`/`alpha`/`userInteractionEnabled`, không animation — `AH:74–90` + đầu file `AH:1–19`. Cleanup khôi phục qua đúng cơ chế save này, không viết đường khôi phục riêng.
6. **Phía host (chỉ tham chiếu):** `ABH:1341–1372` `applyFade:forPane:`, `ABH:1381–1400` `setKnobsFade:`, `ABH:1409–1418` `ahRestorePaneForBundle:` — đã có vòng đời đóng riêng (close/closeall); M1 không sửa phía host. Điểm tiếp xúc duy nhất là yêu cầu thứ tự packet ở §2.3 mục 4 (kfade của packet knob cuối đường đóng).

---

## Phụ lục — Bảng discriminator tổng (cho vòng sửa + nghiệm thu)

**Tĩnh (grep/đọc tại HEAD sau sửa):**

- `grep -rn "ahSessionTeardown" src/` → thêm ≥1 đường reachable từ `closeGoingHome:` (trực tiếp hoặc qua hàm cleanup mới).
- Thân `closeGoingHome:` (`CS:1732–1774` sau sửa): lời gọi cleanup xuất hiện **trước** dòng `hostCloseAll` và trước mọi `detachVC`.
- `grep -n "ahRevealBody\|ahRevealWithReason" src/SplitScreenA/*.m` → không có call site mới nào từ đường đóng.
- Cleanup đường đóng: không gán `ahSuspendedState = NO` vô điều kiện (điều kiện `soloHostedBundle` — §3.3); có xoá `ahKbHoldExpiry` cùng `ahKbHoldState` (§2.3.1).
- `ahFadeBlockedReason` (`AH:140–157`), đoạn expanded của `BW:440–454`/`bwRecomputeForPane:`: diff = 0 (§7).
- Log kỳ vọng khi thoát lúc mờ: đúng một dòng `[autohide] teardown faded=1` tại thời điểm đóng; **không** có `reveal-applied` do đường đóng sinh ra; packet knob cuối phiên mang `kfade = NO` (đọc qua log host `[autohide] host knob fade restored` nếu phía host ghi nhận thay đổi).

**Xe (nghiệm thu GPT, một lần gộp):**

- Thoát split **lúc đang mờ** → mở lại split → logo/handle/divider **hiện đủ ngay**, sau **4 s** không hoạt động mới ẩn; chạm đầu tiên sau khi mở lại không bị "nuốt" bởi reveal của phiên cũ.
- Ca phụ bắt buộc kèm theo (bẫy §3.3): từ split giữ một app hosted đi solo → trong solo, AutoHide không tự chạy (không fade giữa solo); thoát solo về split → fade hoạt động bình thường với đồng hồ 4 s mới.

---

## Nhãn kết luận

**SOURCE-PROVEN** — cho toàn bộ bản đồ: mọi khẳng định trên đều đọc/grep trực tiếp từ HEAD `38735c5` tại thời điểm viết (thứ tự `closeGoingHome:` `CS:1732–1774`, 12 caller, caller duy nhất của teardown `CS:288`, thân teardown `AH:335–349`, các phép gán `ahFadedState` `AH:37/173/192/343`, điểm sơn-tại-dựng `CS:3069` đã kiểm lại số dòng thật). Không có ý nào trong 7 mục bị STUCK.

**PENDING-DEVICE** — cho phần sửa và nghiệm thu: strand này chỉ-đọc, chưa có dòng code nào được thay đổi và chưa có lần chạy xe nào kiểm chứng hành vi sau sửa; tiêu chí xe ở phụ lục (thoát lúc mờ → mở lại hiện đủ, 4 s mới ẩn; ca solo phụ) phải chờ bản sửa + một lần test gộp trên xe mới kết luận được.
