# STRAND M5 — BẢN ĐỒ ICON: ĐO ĐƯỢC TỚI ĐÂU

Chỉ-đọc. Không sửa file nguồn, không sửa cơ chế, vòng này **không** sửa event-1.
Mọi instrument đề xuất dưới đây là log-only.

- Cây trích dẫn: `~/workspace/push9-clone/recovered-source/src/` tại **HEAD thật `38735c5bef6dc22ca9cb11f4e894725ce494be41`** (kiểm bằng `git rev-parse HEAD` khi viết biên bản này; commit trên cùng `38735c5 ytz4 session records…`).
- File chính: `SplitScreenC/SCPAppIcons.m`, `SplitScreenC/SCPHomeApply.m`, `SplitScreenC/SCPHomeHooks.m`, `SplitScreenA/SCPHooks.m`, `SplitScreenA/SCPCarSplit.m`; phụ: `SplitScreenC/SCPCarApps.m`, `SplitScreenC/SCPHomeVisibility.m`, `SplitScreenC/SCPDiagDump.m`, `SplitScreenA/SCPShared.m`, `SplitScreenB/SCPCarSplit+Layout.m`, `SplitScreenB/SCPCarSplit+Zoom.m`, `SplitScreenB/SCPCarSplit+Picker.m`.
- Ghi chú cây: `SCPHomeApply.m` ở cây project khác cây `src` đúng 1 dòng import (dòng 18, thích ứng layout) — nội dung còn lại identical; mọi trích dẫn trong biên bản này theo cây `src`, ở đó dòng 18 là `#import "../SplitScreenB/SCPHomeWallView.h"`.
- Thuật ngữ: "cell" trong lưới Home CarPlay **không** phải `UITableViewCell`. Đối tượng view của một icon trong code đã chạm là view có class name kết thúc `IconView` (`SBIconView` / `CARIconView` / `DBIconView`); đối tượng model của một icon là icon object trong `model → lists → icons`. Hai tầng này **chưa có đường nối theo bundle nào trong code hiện tại** — đó là khoảng mù trung tâm của strand này (§2, §4c).

Kết luận 1 dòng: **tầng model + library đọc được tốt ở cả 3 thời điểm; tầng cell/view của đúng một bundle injected thì chưa đọc được ở bất kỳ thời điểm nào bằng code hiện có** — không phải vì property không tồn tại trên `UIView`, mà vì chưa có điểm nào trong code lấy được *đúng view của bundle đó* để đọc property lên.

---

## 1) Cây dock/lưới ĐANG SỐNG đọc được từ CarPlayApp ở đâu

### 1.1 Mọi đối tượng cây sống mà code hiện ĐÃ chạm tới

| # | Đối tượng / class | Điểm chạm (file:line) | Đường lấy đối tượng | Cái đọc được tại điểm đó |
|---|---|---|---|---|
| 1 | Home VC — `DBDashboardHomeViewController` | `SplitScreenA/SCPHooks.m:128` (`Hook_HomeVC_initWithEnvironment`, orig trước, `SCPSetHomeViewController(result ?: self)` sau); lưu weak tại `SplitScreenC/SCPAppIcons.m:29,303-305` (`SCPHomeVCWeak`); bản apply lưu riêng `SCPApplyHomeVCWeak` tại `SplitScreenC/SCPHomeApply.m:141` | Hook `initWithEnvironment:` (installer `SCPHooks.m:683-691`) | Chính VC sống; là gốc của 2 đường đọc lưới khác nhau (xem 1.3) |
| 2 | Home VC `.view` → cây `*IconListView` | `SplitScreenC/SCPHomeApply.m:79-85` (`SCPCollectIconListViews`, đệ quy theo class-name suffix `IconListView`), dùng tại `:97` (re-layout), `:210` (label), `:253` (publish walk) | Từ `SCPHomeApply(homeVC)` — hook `viewDidLayoutSubviews` gọi orig rồi mới apply: `SplitScreenA/SCPHooks.m:134-137` | Danh sách các `IconListView` **đang nằm trong view tree của home VC** tại thời điểm layout/appear |
| 3 | Icon **model**: `listView.model → lists → icons` | `SplitScreenC/SCPHomeApply.m:255-263` (`SCPPublishCarAppsBlock`: `model` qua `SCPHomeSafePerform(listView,@"model")`, `lists`, `icons`, bundle qua `applicationBundleID` tại `:263`) | Từ (2) | Bundle của **mọi** icon trong model — nhưng xem lọc injected tại §4/§5 |
| 4 | Icon model của home VC: `homeVC.iconModel` / KVC `_iconModel` | `SplitScreenC/SCPHomeVisibility.m:165-167` (`SCPHomeIconModelLayout`) | `SCPHomeVCWeak` → `iconModel` | Chỉ gọi `layout` lên model (`:168-175`); **không** liệt kê icon nào từ đường này |
| 5 | Icon object đơn lẻ + hook quyết định hiện/ẩn: `-[<icon model> isIconVisible:]` | Thân hook `SplitScreenC/SCPHomeHooks.m:139-150` (`SCPHook_IsIconVisible`); installer `SplitScreenA/SCPHooks.m:730-731` trên class do `SCPIconModelClass()` chọn (`SCPHooks.m:655-…`: `DBIconModel` → `SBHIconModel` → `SBIconModel`); bundle của icon đọc tại `SplitScreenC/SCPHomeVisibility.m:67-75` (`applicationBundleID`/`leafIdentifier`) | Hệ thống tự gọi khi dashboard quyết định icon có visible không | Tại thời điểm hệ thống hỏi: icon object + bundle + kết quả visible cuối (sau `SCPIconHiddenOnCar`/`SCPIconForcedOnCar`) — **đây là điểm chạm icon-đơn-lẻ duy nhất ở tầng quyết định**, nhưng hiện không log theo bundle injected |
| 6 | Icon **view** (`*IconView`): chỉ 2 điểm chạm, đều không theo bundle | (a) `SplitScreenC/SCPHomeApply.m:115-136` (`SCPApplyLabelHidden`: đệ quy view tree, khớp suffix `IconView`, đọc/ghi `isLabelHidden`/`setLabelHidden:`); (b) hook `-[SBIconView setLabelHidden:]` `SplitScreenC/SCPHomeHooks.m:129-136`; (c) meta-hook `+maxLabelSizeForIconImageSize:` trên `CARIconView`/`DBIconView`, installer `SplitScreenA/SCPHooks.m:747-751` | Đệ quy từ home view (a) hoặc hệ thống gọi setter (b) | Label-hidden của **mọi** IconView theo lượt quét — không điểm nào đọc `icon` property của view, không điểm nào gắn view ↔ bundle |
| 7 | View→icon (hit-test, không phải liệt kê): `SCPWalkerSafeGet(v,@"icon")` | `SplitScreenA/SCPCarSplit.m` trong `-iconLongPressedUnsafe:` (đi lên từ hit view tới `press.view.superview`, lấy `icon` rồi `SCPWalkerIconBundleID(icon)`); walker bundle tại `SplitScreenC/SCPCarApps.m:74-85` (`applicationBundleID`/`leafIdentifier`/`bundleIdentifier`) | Long-press trên `*IconListView` do `installLongPressIn:depth:` gắn (`SCPCarSplit.m`, walker cửa sổ tại `-installIconLongPress`) | Chứng minh **đường view→icon→bundle tồn tại trên từng view con** khi có hit view cụ thể; chưa từng được dùng để liệt kê toàn lưới theo bundle |
| 8 | Application library (`DashBoard _newApplicationLibrary` / `sharedApplicationLibrary`) | Dựng: hook `SplitScreenA/SCPHooks.m:86-105` (`Hook_newApplicationLibrary`, orig trước); đọc lại: `SplitScreenC/SCPAppIcons.m:329-332` (`SCPHomeVCWeak.library`, fallback `[UIApplication sharedApplication] sharedApplicationLibrary`), `SplitScreenC/SCPHomeApply.m:269-276`, `SplitScreenC/SCPCarApps.m:48-57` | Dashboard / UIApplication | `allInstalledApplications` (đếm được — `[homelib] … count=` tại `SCPHooks.m:97-105`, helper đếm `:74-84`), `applicationInfoForBundleIdentifier:` |
| 9 | `DBApplicationInfo` từng app | Hook `SplitScreenA/SCPHooks.m:108-124` (`Hook_loadFromProxy:`, **orig chạy trước**, `SCPInjectDeclarationIfChosen(self)` sau); thân inject `SplitScreenC/SCPAppIcons.m:151-…` | Hệ thống load info | `bundleIdentifier` (`SCPAppIcons.m:152`), `_carPlayDeclaration`, `tags`, `bundleURL`, và khi inject lần đầu: `isHidden`/`isInstalled`/`presentsFullScreen` (`SCPAppIcons.m` vùng cuối inject, log `AppIcons: chen … hidden=%d installed=%d fullScreen=%d`) |
| 10 | Dashboard + root VC | `SplitScreenA/SCPShared.m:53-63`: `SCPDashboardObject()` = `UIApplication._currentDashboard`; `SCPDashboardRootViewController()` = `dashboard.rootViewController`; `currentBaseViewController` đọc tại hook dismiss `SplitScreenA/SCPHooks.m:347-…` và `SCPCarSplit.m` (`SCPCurrentBaseViewController`) | UIApplication | Root VC sống của dashboard — gốc của đường dock (mục 11) và của T3 (§2) |
| 11 | **Dock**: `rootVC.appDockViewController` → `.view` | `SplitScreenA/SCPCarSplit.m:3160-3172` (`dockClusterInParent:`: `SCPGuarded(root,@"appDockViewController")` tại `:3162`, `view` tại `:3163`, `dockView.window` `:3164`, `isHidden` `:3165`); các lần dùng khác cùng mẫu: `:3218-3219` (`launcherCenterInParent:`), `:3268-3271` (`setDockShift:`), `:3287-3289` (`dockHostForRect:inParent:`); phía B: `SplitScreenB/SCPCarSplit+Layout.m:419-466` (probe `appDockViewController`, dock view, `window`, `isHidden`, frame) | `SCPDashboardRootViewController()` (mục 10) | **Dock view + window của dock đọc được**: `dockView.window != nil`, `dockView.isHidden`, `bounds`/`frame` quy đổi tọa độ, `transform.ty`. Đây là dock của **dashboard** (dải chứa nút Home/launcher của tweak), không phải lưới icon Home — hai cây khác nhau, đừng trộn |
| 12 | Mọi `UIWindow` của mọi `UIWindowScene` | `SplitScreenC/SCPCarApps.m:116-123` (`SCPCarHomeBundles`: `connectedScenes → windows → SCPWalkerWalkView`); cùng mẫu tại `SplitScreenC/SCPDiagDump.m` (tail của `SCPDumpAppLibraryOnce`: windows → `SCPDiagWalkIcons`) và `SCPCarSplit.m -installIconLongPress` | `UIApplication.connectedScenes` | Cửa sổ **của chính process CarPlayApp** — xem 1.3 vì sao đường này mù |

Điểm hiện tại → khoảng mù → điểm đo sẽ thêm (mục 1):

- **Hiện tại:** có 2 gốc cây sống khác nhau: (A) home VC giữ weak (`SCPHomeVCWeak`/`SCPApplyHomeVCWeak`) — đường của publish walk; (B) `connectedScenes/windows` — đường của live-grid reader. Chỉ (A) đã từng cho ra dữ kiện lưới có nội dung trong log (publish walk); (B) cho `count=0` 5/5 (ytz3) và tiếp tục không phân định được ở ytz4.
- **Điểm đo sẽ thêm (instrument, không sửa cơ chế):** một hàm đọc chung `[m5-grid]` chạy tại các thời điểm §2, đi **cả hai gốc trên cùng một lần gọi** và log cả hai kết quả cạnh nhau: `rootA=homeVC lists=<n> icons=<n> bundles=[…] | rootB=scenes=<n> windows=<n> lists=<n> icons=<n>` kèm `homeVC=%p viewWindow=%p`. Trước: hai reader nằm ở hai ngữ cảnh, hai thời điểm, không đối chiếu được. Sau (chỉ về khả năng quan sát): mỗi mốc đo tự cho biết gốc nào mù, thay vì suy từ hai phiên/log khác nhau.

### 1.2 Window của dock truy cập được qua đường nào — trả lời gọn

`SCPDashboardObject()` (`SCPShared.m:53-57`, `UIApplication` → `_currentDashboard`) → `rootViewController` (`:59-63`) → `SCPGuarded(root, @"appDockViewController")` (`SCPCarSplit.m:3162`) → `SCPGuarded(dockVC, @"view")` (`:3163`) → `dockView.window` (`:3164`). Điều kiện sống đã có sẵn trong code: `dockClusterInParent:` trả `CGRectNull` khi `!window || dockView.isHidden` (`:3165`); `dockHostForRect:inParent:` trả `nil` khi `!dockWindow` (`:3289-3290`). Tức **window của dock là đọc được và đã được code dùng làm cổng hợp lệ** — nhưng đối tượng ở cuối đường này là dock view của dashboard, **không chứa icon model của lưới Home**; muốn đọc icon phải rẽ qua home VC (mục 1.1 #1–#3), không đi qua dock.

### 1.3 Vì sao live-grid reader vòng trước mù — đọc lại code reader đó

Reader là `SCPCarHomeBundles()` — `SplitScreenC/SCPCarApps.m:116-127`, log `[applib] build reason=live-grid-read count=%lu omni=%d` tại `:124-126`. Ba khác biệt cụ thể so với cây sống thật, đều đọc được từ code:

1. **Gốc khác:** reader bắt đầu từ `[UIApplication sharedApplication].connectedScenes → windows` (`:118-121`) rồi đệ quy **view tree của window** tìm class suffix `IconListView` (`SCPWalkerWalkView`, `:98-110`). Cây sống mà publish walk đọc được lại bắt đầu từ `homeVC.view` (`SCPHomeApply.m:247-253`: `SCPApplyHomeVCWeak` → `view` → `SCPCollectIconListViews`). Reader không bao giờ chạm `SCPHomeVCWeak`/`SCPApplyHomeVCWeak`.
2. **Điều kiện khớp chặt hơn ở tầng model:** trong walker, một `IconListView` được tính **chỉ khi** `view.model → lists → icons` cho ra bundle (`:100-105`); nhánh `folder` của walker đọc `SCPWalkerSafeGet(view,@"folder")` — lấy folder **từ view**, trong khi publish walk và diag walk lấy model từ view rồi mới đi tiếp (diag: `model → folder → lists`, `SCPDiagDump.m` `SCPDiagWalkIcons`). Nếu `model`/`lists` không trả qua đúng getter trên đối tượng view mà walker đang đứng, walker lặng lẽ cho 0 — không có log phân biệt "không thấy list view" với "thấy list view nhưng model rỗng".
3. **Không có mốc dương tính trong cùng lần đọc:** log của reader chỉ có `count` + `omni` tổng (`:124-126`). `count=0` do đó tương thích với ít nhất 3 thế giới khác nhau: (i) không scene/window nào của process này chứa `IconListView`; (ii) có list view nhưng `model/lists/icons` không resolve; (iii) lưới thật đang sống ở cây home VC nhưng không nằm dưới window mà `connectedScenes` liệt kê tại thời điểm gọi (reader chỉ được gọi như merge-source khi dựng picker — `SCPCarApps.m:335`, trong `SCPCarPlayAppInfos()` — tức thời điểm/ngữ cảnh dựng picker, không phải thời điểm Home đang hiện). Code reader không ghi scene count / window count / list-view count nên **không tự bác bỏ được giả thuyết nào**.

Hệ quả đã ghi ở các biên bản trước và giữ nguyên ở đây: dòng `[homelib] event=apply-published` tại `SCPHomeApply.m:319-325` cũng mù với app injected theo cách khác — `found` được thu **sau** bộ lọc `if (SCPIsInjectedPhoneApp(bid)) continue;` (`:267-268`), và `omni=` chỉ mẫu riêng `com.anlai.omnicar.app` **trước** bộ lọc (`:255,264-266`). Nên `count` của apply-published không bao giờ là bằng chứng presence/absence của một bundle injected bất kỳ (YouTube là ví dụ đã gặp: 0 lần remove, decision cuối vẫn `inject`, mà apply-published vẫn không đọc được nó).

- **Điểm đo sẽ thêm:** `[m5-grid]` như 1.1, cộng riêng cho gốc B ba bộ đếm trung gian `scenes/windows/listViews` và một dòng `modelNil=<n>` — để `count=0` lần sau tự khai nó mù ở tầng nào. Trạng thái trước: `count=0` không hợp lệ làm bằng chứng. Sau: `count=0` kèm `listViews=0` = mù gốc B (reader-fail); `listViews>0, modelIcons=0` = mù tầng model; `modelIcons>0, bundle vắng` mới là vắng thật ở tầng model (trạng thái (b), §4).

---

## 2) Bảng trường × thời điểm cho mỗi app injected

Thời điểm:

- **T1 — trước close, lúc vào `closeGoingHome:`**: đầu thân hàm, `SplitScreenA/SCPCarSplit.m:1732-1737` (sau `if (!self.active) return;`, log `tat split (goHome=%d)` tại `:1734`, trước `hostCloseAll`/detach ở `:1738` trở đi; tại đây đã có sẵn một snapshot log-only cùng vị trí: vòng `SCPSceneVisLog(@"going-home",…)` `:1735-1736` — nhưng đó là scene của **pane**, không phải icon lưới).
- **T2 — sau close, cuối `closeGoingHome:`**: `SCPCarSplit.m` cuối thân hàm (sau `self.active = NO`, `slots/container/floatPane` đã nil, fade 0.2 s đã lên lịch, `SCPSendDashboardEvent(1,…)` chỉ khi `goHome`, `refreshAppTabSoon`/`publishKnobsSoon` ở đuôi). Lưu ý bất đối xứng: tại T2, `pane.vc`/`pane.bundleID` đã bị nil vô điều kiện trong vòng detach (`:1744-1752`) và `self.slots = nil` — **mọi thứ thuộc split đã mất**, nhưng home VC/library/icon model **không** thuộc split, không bị hàm này đụng tới.
- **T3 — sau handler Home gốc**: xem phân tích hook ngay dưới bảng.

Phân tích T3 (điểm bắt "sau original"):

- `Hook_handleHomeEvent` — `SplitScreenA/SCPHooks.m:237-246`: thứ tự là **close trước, original sau chót**: `wasActive` chụp tại `:240`, `closeGoingHome:NO` tại `:241`, `homePressedDuringSplit:` tại `:242`, rồi orig `_handleHomeEvent:` mới chạy tại `:245` (cả trên đường @catch). Vậy **bên trong hook này không tồn tại thời điểm "sau original"** trừ đúng 1 điểm: câu lệnh ngay sau lời gọi orig ở `:245` (hiện là cuối hàm — chỗ trống tự nhiên cho instrument T3-Home, không cần hook mới).
- Điểm sau-original **đã tồn tại sẵn** cho home VC: `Hook_HomeVC_viewDidAppear` — `SCPHooks.m:138-142`: orig chạy trước (`:139`), `SCPHomeSetVisible(YES)` sau (`:140`). Nhưng hook này **không** gọi `SCPHomeApply` (apply chỉ được gọi từ `viewDidLayoutSubviews`, `SCPHooks.m:134-137` — cũng orig-trước-apply-sau) và không đọc lưới. `viewDidDisappear:` tương tự tại `:143-147`.
- Điểm sau-original khác đã hook: `Hook_RootVC_viewDidAppear` (`SCPHooks.m`, orig trước, rồi 2 block trễ +3.0 s: `publishCarPlayApps` + `carScreenAppeared` + `SCPAppIconsCarScreenOK()`; +7.0 s: `SCPDumpAppLibraryOnce()`) — là mốc trễ có sẵn gần nhất phía root VC, nhưng là của root VC, không phải home VC.
- `Hook_dismissBaseViewController` (`SCPHooks.m:347-…`): orig nằm **giữa** hook (sau `removeAppTab`), `refreshAppTabSoon` chạy sau orig — một điểm sau-original nữa, chỉ tới được khi đường về Home đi qua dismiss base VC.

### Bảng (mỗi ô: ĐỌC ĐƯỢC — điểm đọc / KHÔNG — lý do)

Trong bảng, "bundle injected" = bundle thuộc `SCPChosenPhoneApps()` (`SCPAppIcons.m:…` `appBridgeApps` + gate `appBridge`) và/hoặc đã vào `SCPInjectedAppsSet()` (`SCPIsInjectedPhoneApp`, `SCPAppIcons.m`).

| Trường | T1 (vào closeGoingHome:) | T2 (cuối closeGoingHome:) | T3 (sau handler Home gốc) |
|---|---|---|---|
| Bundle id của icon (tầng model) | **ĐỌC ĐƯỢC** — publish walk mẫu: `SCPHomeApply.m:255-263` (`model→lists→icons→applicationBundleID`); walker mẫu: `SCPCarApps.m:77-85,88-92`. Điều kiện: lấy được home VC (weak còn sống) — chưa có dòng nào đọc nó **tại T1** hiện nay | **ĐỌC ĐƯỢC** (cùng đường như T1) — close không đụng home VC/model; nhưng phải tự giữ danh sách bundle cần tra **từ trước**, vì `slots/pending` của split đã nil/xoá tại T2 | **ĐỌC ĐƯỢC** — cùng đường; cộng điểm chạm quyết định: hook `isIconVisible:` (`SCPHomeHooks.m:139`) được hệ thống gọi trong quá trình handler gốc dựng lại lưới — log tại đó là dữ kiện T3 sớm nhất theo từng icon |
| Identity của info (`DBApplicationInfo`): có declaration injected không, `tags` chứa `OmniCarAppBridge` không | **ĐỌC ĐƯỢC** — qua library: `applicationInfoForBundleIdentifier:` (`SCPAppIcons.m:276-…` trong `SCPAddChosenAppsToLibrary`; `SCPHomeApply.m:271-276`), rồi `bundleIdentifier`/`_carPlayDeclaration`/`tags` như `SCPInjectDeclarationIfChosen` đọc tại `SCPAppIcons.m:152-175` | **ĐỌC ĐƯỢC** — library không thuộc split; đường như T1 | **ĐỌC ĐƯỢC** — như T1; cộng `Hook_loadFromProxy` (`SCPHooks.m:108-124`) nếu handler gốc load lại info: log `[homelib] event=loadFromProxy … injected=%d` đã có sẵn |
| Thuộc tính info: `isHidden` / `isInstalled` / `presentsFullScreen` | **ĐỌC ĐƯỢC từng lần khi info vừa inject** — code đã đọc đúng 3 trường này tại `SCPAppIcons.m` (khối log `chen … hidden=%d installed=%d fullScreen=%d` sau khi ghi declaration). Ngoài thời điểm inject: đọc lại được qua info từ library bằng cùng getter — **chưa có điểm đọc nào làm việc này tại T1/T2/T3** | Như T1 (qua library) — chưa có điểm đọc | Như T1 — chưa có điểm đọc |
| Icon có trong icon model của lưới không (presence tầng model) | **ĐỌC ĐƯỢC** — đếm/so bundle trong walk ở trên; mẫu gần nhất đang chạy thật: publish walk `SCPHomeApply.m:253-281` (nhưng bản thân nó **loại** injected khỏi `found` — phải đọc presence **trước** bộ lọc `:267-268` như cách `homelibOmniOnGrid` mẫu tại `:255,264-266`) | **ĐỌC ĐƯỢC** — cùng walk | **ĐỌC ĐƯỢC** — cùng walk tại điểm sau-orig (§T3); đây là thời điểm đầu tiên presence phản ánh lưới **sau khi** handler gốc xử lý Home |
| `isIconVisible:` — hệ thống có cho icon hiện không | **ĐỌC ĐƯỢC khi hệ thống hỏi** — hook `SCPHomeHooks.m:139-150` (orig + `SCPIconHiddenOnCar`/`SCPIconForcedOnCar`); không chủ động gọi được theo yêu cầu tại T1 (nó là callback) | Như T1 — chỉ khi dashboard tự hỏi lại | **ĐỌC ĐƯỢC và đúng ngữ nghĩa nhất** — handler gốc dựng lại lưới sẽ hỏi; instrument log tại hook này (theo bundle, kèm kết quả cuối) cho dữ kiện "dashboard có định hiện icon này không" |
| **Cell/view của đúng bundle đó**: đối tượng `*IconView` | **KHÔNG** — không có đường model→view hay view→bundle dạng liệt kê trong code đã chạm. Chỉ có: quét mọi `*IconView` không theo bundle (`SCPHomeApply.m:115-136`) và view→icon theo hit-test (`SCPCarSplit.m -iconLongPressedUnsafe:`). Thiếu mắt nối | **KHÔNG** — cùng lý do; thêm: tại T2 mọi tham chiếu split đã nil nên càng không còn đường phụ qua pane | **KHÔNG** — như T1; home VC có xuất hiện lại cũng không tự sinh mắt nối model↔view |
| Cell: `hidden` (`isHidden`) | **KHÔNG theo bundle** — property đọc được trên bất kỳ `UIView` nào (mẫu: dump `SCPHomeApply.m:54-62` ghi `hidden=%d` cho mọi view trong cây; dock check `SCPCarSplit.m:3165`), nhưng không có view-của-bundle để đọc lên | **KHÔNG theo bundle** — như T1 | **KHÔNG theo bundle** — như T1 |
| Cell: `alpha` / `layer.opacity` | **KHÔNG theo bundle** — `alpha` đã được code đọc trên view khác (vd điều kiện `view.alpha < 0.05` trong `SCPFindHomeGlyph`, `SCPCarSplit.m` vùng home/dock; container fade `container.alpha = 0` tại đuôi `closeGoingHome:` là của container split, không phải cell). `layer.opacity`: **không có điểm đọc nào trong các file đã rà** cho icon view | **KHÔNG theo bundle** | **KHÔNG theo bundle** |
| Cell: `frame` / bounds | **KHÔNG theo bundle** — frame đọc được dạng dump toàn cây (`SCPDumpViewTree`, `SCPHomeApply.m:54-62`, nhưng là one-shot `done` static tại `:66-…` `SCPDiagHomeTreeOnce`, chỉ chạy khi có wallpaper source) — không gắn bundle, không chạy theo mốc T1/T2/T3 | **KHÔNG theo bundle** | **KHÔNG theo bundle** |
| Cell: `window` (attached / có window không, `view.window`, `superview` chain) | **KHÔNG theo bundle** — mẫu đọc `window` đã có cho đối tượng khác: home view (`SCPHomeApply.m:250`: publish block bail khi `!view.window`), dock view (`SCPCarSplit.m:3164`). Cho cell của một bundle: không có đối tượng để đọc | **KHÔNG theo bundle** | **KHÔNG theo bundle** |
| Trạng thái lưới tổng: số list view / số icon model | **ĐỌC ĐƯỢC** — `SCPCollectIconListViews` (`SCPHomeApply.m:79-85`) + walk đếm; đây là **mốc dương tính** phân biệt mù/vắng (§4a) | **ĐỌC ĐƯỢC** | **ĐỌC ĐƯỢC** |

- **Điểm hiện tại → nguyên nhân:** nửa trên của bảng (model/library/info) đọc được vì code đã có đủ getter guarded (`SCPHomeSafeGet/SafePerform`, `SCPWalkerSafeGet`) và đủ gốc đối tượng (home VC weak, library, dashboard). Nửa dưới (cell) không đọc được **duy nhất vì thiếu mắt nối bundle↔view**, không phải vì thiếu getter cho property.
- **Điểm đo sẽ thêm (instrument):**
  1. `[m5-icon] t=T1|T2|T3 phase=… bundle=<bid> inModel=0/1/NA infoPresent=0/1 declOurs=0/1 isVisAsked=… lists=<n> modelIcons=<n> rootA=<ok/nil> rootB=<ok/nil>` — một dòng/bundle/mốc, `NA` bắt buộc khi gốc đọc fail (không được ghi 0 thay NA).
  2. Log phụ tại `SCPHook_IsIconVisible` (`SCPHomeHooks.m:139`): chỉ khi `SCPIsInjectedPhoneApp(bid)` — `bundle + result cuối + hiddenOnCar/forcedOnCar`.
  3. **Điểm hook mới duy nhất mà strand này kết luận là cần** (chưa có trong code): liệt kê subview của từng `IconListView` tại T1/T2/T3, với mỗi subview khớp suffix `IconView` thì thử đường đã tồn tại `view → icon` (mẫu hit-test `SCPWalkerSafeGet(v,@"icon")` của `-iconLongPressedUnsafe:`) để lấy bundle; khớp bundle thì mới đọc `hidden/alpha/layer.opacity/frame/window/superview!=nil`. Đây là instrument đo, không sửa cơ chế — nhưng phải ghi rõ: **cho tới khi điểm này tồn tại và cho ra dữ kiện trên xe, mọi ô cell trong bảng giữ nguyên KHÔNG**.
- **Trạng thái trước/sau (chỉ khả năng quan sát):** trước — model đọc rời rạc ở các ngữ cảnh khác nhau (publish walk lúc apply, reader lúc dựng picker, decision lúc load info), cell mù toàn phần. Sau (nếu thêm 1+2) — model/info/presence đọc được **đồng thời tại cả 3 mốc trên cùng một gốc**, đủ để phân định §4a/§4b; cell vẫn mù cho tới khi có (3).

---

## 3) Nguồn gọi `closeGoingHome:` — mọi điểm vào (grep toàn cây `src`, trừ `disasm/`)

Định nghĩa: `SplitScreenA/SCPCarSplit.m:1732` (`-closeGoingHome:(BOOL)goHome`, early-return khi `!active` tại `:1733` — **mọi lần gọi khi split không active đều là no-op không log**, điểm mù phụ cần nhớ khi đếm sự kiện trên log).

| # | Nguồn | Điểm gọi (file:line) | goHome | Phân loại | Ghi được nguồn tại điểm đo bằng gì — hiện có / cần thêm |
|---|---|---|---|---|---|
| 1 | Home hệ thống qua hook `DBDashboard -_handleHomeEvent:` | `SplitScreenA/SCPHooks.m:241` (trong `Hook_handleHomeEvent`, `:237-246`) | **NO** | Home hệ thống | Hiện có: `wasActive` chụp trước (`:240`) + thứ tự hook. **Không** có trường "source" trong `closeGoingHome:` — phân biệt được với nguồn khác chỉ nhờ log của hook nằm sát trước. Instrument tối thiểu: tham số/log `src=home-hook` tại điểm gọi này |
| 2 | Gọi đệ quy nội bộ của dashboard: hook `presentBaseViewController:` — đường @catch (adopt ném exception) | `SplitScreenA/SCPHooks.m:297` | NO | Mở app/base VC toàn màn (ném lỗi) | Hiện có: `SCPExceptionLog("presentBaseViewController (adopt)")` sát trước. Cần `src=present-catch` nếu muốn đếm máy-đọc-được |
| 3 | Cùng hook trên — đường không-adopt, không ném | `SplitScreenA/SCPHooks.m:313` | NO | Mở app khác toàn màn thay split | Hiện có: log `CarSplit: DashBoard mo %@ toan man -> tat split` ngay trước (`:310-312`) — mang cả VC. Cần `src=present-notadopted` |
| 4 | Hook `dismissBaseViewControllerAnimated:` khi không còn base VC | `SplitScreenA/SCPHooks.m:360` (điều kiện `!base` tại `:355-…`) | NO | Dismiss base VC về dashboard home | Hiện có: log `CarSplit: DashBoard ve man chinh -> tat split` sát trước. Cần `src=dismiss-nobase` |
| 5 | Lệnh native từ SpringBoard: `splitscreen.native` action `close` | `SplitScreenA/SCPHooks.m:603` (trong `SCPNativeCommandBlock`) | **YES** | Lệnh ngoài (URL/native command) — không phải Home vật lý | Hiện có: log `CarSplit: yeu cau %@` in toàn `userInfo` trước dispatch. Cần `src=native-close` |
| 6 | `afterPaneRemoved:` — hết pane, không còn float pane | `SplitScreenA/SCPCarSplit.m:1597` | YES | Đóng ô cuối (qua `afterPaneRemoved:`) | Hiện có: tham số `bundle` của `afterPaneRemoved:` + log `dong o …` của `closeSlot:` tại `:1577-1579` khi đi qua `closeSlot:`. Cần `src=afterpane-empty` |
| 7 | `afterPaneRemoved:` — còn 1 pane nhưng pane đó không có bundle và không có candidate pending slot 0 | `SplitScreenA/SCPCarSplit.m:1607` | YES | Đóng ô cuối (biến thể suy biến) | Hiện có: rất ít — không có log riêng ngay trước điểm này. **Đây là điểm gọi khó quy nguồn nhất nếu chỉ nhìn log `tat split (goHome=1)`**; cần `src=afterpane-degenerate` |
| 8 | `soloBundle:` — bundle nil | `SplitScreenA/SCPCarSplit.m:2310` | YES | Mở app khác / solo (suy biến) | Log của `soloBundle:` không in ở nhánh nil này trước khi close. Cần `src=solo-nil` |
| 9 | `soloBundle:` — app hosted (AppBridge) đi solo | `SplitScreenA/SCPCarSplit.m:2318` (giữa `hostSolo:` `:2317` và reset `ignoreHomeOnce` `:2319`) | YES | Thoát-kèm-giữ-app (hosted) | Hiện có: log `chi giu %@ (app iPhone) -> App Bridge toan man` tại `:2313-2314` + `ignoreHomeOnce` bao quanh — dấu hiệu nhận diện mạnh. Cần `src=solo-hosted bundle=` |
| 10 | `soloBundle:` — app native, có pane VC sống → trả VC cho dashboard present lại | `SplitScreenA/SCPCarSplit.m:2339` | **NO** | Thoát-kèm-giữ-app (native) — **trông giống Home ở `goHome` nhưng không phải** | Hiện có: log `tra %@ cho DashBoard trinh bay toan man` sau đó. Cần `src=solo-native-return bundle=` |
| 11 | `soloBundle:` — không pane nào giữ app, dựng lại launch info | `SplitScreenA/SCPCarSplit.m:2384` | YES | Thoát-kèm-giữ-app (relaunch) | Hiện có: ngữ cảnh `soloBundle:` + block relaunch +0.8 s sau đó. Cần `src=solo-relaunch bundle=` |
| 12 | `exitTapped` — nút thoát của tweak, khi không có app để giữ | `SplitScreenA/SCPCarSplit.m:2447` (trong `-exitTapped`, `:2438-2454`); nút gắn tại `SplitScreenB/SCPCarSplit+Panel.m:359` (`exit` button → `@selector(exitTapped)`) | YES | **Nút thoát của tweak** | Hiện có: log riêng rất rõ `CarSplit: nut thoat -> thoat chia man…` tại `:2443-2445`, và khi có keep-bundle thì đi `soloBundle:keep` tại `:2446` (→ thành nguồn 9/10/11, **không** gọi thẳng close). Cần `src=exit-nokeep` |
| 13 | (Gián tiếp, không phải điểm gọi thẳng) `closeSlot:` ô cuối / `closeFloat:` hết ô / picker huỷ ô cuối | `closeSlot:` → `afterPaneRemoved:` tại `SCPCarSplit.m:1579`; `SplitScreenB/SCPCarSplit+Zoom.m` (`closeFloat:` → `afterPaneRemoved:bundle` khi còn active và hết pane); `SplitScreenB/SCPCarSplit+Picker.m` (huỷ picker ô → `afterPaneRemoved:nil`) | qua #6/#7 | Đóng ô cuối | Nguồn gốc thật nằm 1 tầng trên `afterPaneRemoved:`; `afterPaneRemoved:` nhận `bundle` của pane bị gỡ (trừ đường picker/zoom truyền `nil`) — instrument tại入口 `closeGoingHome:` không thấy được tầng này, phải log tại入口 `afterPaneRemoved:` nếu cần phân biệt |

**Kết luận §3:**

- Tham số `goHome` **không** đủ để quy nguồn: `goHome=NO` gồm cả Home hệ thống (#1), present/dismiss dashboard (#2–#4) và solo-native-return (#10); `goHome=YES` gồm native-close, afterPane, solo và exitTapped. Tương quan "mất icon sau thoát tương quan `goHome=NO` 5/5" của phiên trước vì vậy **chỉ thu hẹp về nhóm { #1, #2, #3, #4, #10 }**, chưa phải là "Home hệ thống" — #10 đặc biệt nguy hiểm vì nó là thoát-có-chủ-đích của tweak mà mang `goHome=NO`.
- Caller trực tiếp: Objective-C không cho sẵn caller; thứ gần nhất hiện có là các log sát-trước không đồng nhất (một số nguồn có, #7/#8 không có). 
- **Điểm sửa tối thiểu cho instrument (không sửa cơ chế):** thêm **một** tham số nguồn dạng hằng chuỗi tại mọi điểm gọi — thực dụng nhất: đổi chữ ký nội bộ thành `closeGoingHome:source:` *hoặc* (ít xâm lấn hơn, giữ nguyên chữ ký gốc của binary) đặt một biến thread-local/global `SCPLastCloseSource` ngay trước mỗi lời gọi trong bảng trên + log nó trong dòng `tat split` sẵn có tại `SCPCarSplit.m:1734`, mở rộng thành `tat split (goHome=%d src=%@ bundle-focus=%@)`. Đồng thời log tại入口 khi `!active` (early-return `:1733`) — hiện các lần gọi no-op **vô hình** trên log.
- **Trạng thái trước/sau:** trước — nguồn chỉ suy được bằng ghép log thủ công, 2/13 nguồn vô hình. Sau — mỗi sự kiện close có `src=` máy-đọc-được; tương quan goHome↔mất icon mới nâng lên thành tương quan **nguồn**↔mất icon được.

---

## 4) Ba trạng thái theo đặc tả GPT — map tới dòng log sẽ ghi

Định dạng dòng đề xuất (một họ duy nhất, log-only): `[m5-icon] t=<T1|T2|T3> src=<§3> bundle=<bid> state=<BLIND|ABSENT|PRESENT-CELL-…> …`.

### (a) Không tìm được đối tượng để đọc — "mù" ≠ "vắng"

- **Điểm hiện tại:** cả hai reader hiện hành đều gộp mù và vắng vào một số 0: live-grid reader `count=0` (`SCPCarApps.m:124-126`), apply-published `count=` loại injected (`SCPHomeApply.m:319-325`).
- **Log sẽ ghi:** `state=BLIND rootA=<nil-view|nil-window|no-listview|model-nil> rootB=<no-scene|no-window|no-listview|model-nil> lists=<n|NA> modelIcons=<n|NA>` — bắt buộc có ít nhất một mã lý do mù và `NA` thay vì `0` cho mọi bộ đếm không lấy được. Quy tắc đọc: **chỉ khi `lists>0 && modelIcons>0` mà bundle vắng thì mới được sang trạng thái (b)**; mọi trường hợp còn lại mà bundle không xuất hiện đều là (a).
- **Kiểm tra tĩnh:** grep dòng instrument — không nhánh nào log `state=ABSENT` khi chưa qua cổng `lists>0 && modelIcons>0`.

### (b) Tìm được cây/model nhưng icon VẮNG trong đó

- **Điểm hiện tại:** presence tầng model đọc được (§2) nhưng chưa có dòng nào ghi presence-của-injected tại 3 mốc; publish walk còn chủ động loại injected (`SCPHomeApply.m:267-268`).
- **Log sẽ ghi:** `state=ABSENT lists=<n>0 modelIcons=<m>0 inModel=0 infoPresent=<0/1> declOurs=<0/1> libDecision=<decision [homelib] cuối của bundle>` — kèm 2 trường library/info để phân biệt "vắng khỏi model nhưng info/library vẫn còn + declaration vẫn ours" (vắng ở tầng trình bày model) với "vắng cả ở library" (vắng ở tầng inject — khi đó `[homelib]` phải có `remove`/`lib-skip-*` tương ứng, đối chiếu `SCPAppIcons.m:286-352`).
- **Ý nghĩa giới hạn:** (b) chỉ khẳng định vắng **trong model của các `IconListView` lấy từ home VC tại mốc đó**. Nó không khẳng định dashboard không giữ icon ở model khác/bộ nhớ khác (xem §5).

### (c) Icon có trong model nhưng CELL bị ẩn / bị tháo

- **Điểm hiện tại — trả lời thẳng câu hỏi của đặc tả:** đường model→cell **chưa tồn tại** trong code đã chạm. Bằng chứng âm tính từ rà soát: (i) mọi điểm chạm `*IconView` (`SCPHomeApply.m:115-136`, `SCPHomeHooks.m:129-150`) đều không đọc property `icon` của view và không so bundle; (ii) mọi điểm đọc model (`SCPHomeApply.m:255-263`, `SCPCarApps.m:88-105`, `SCPDiagDump.m` `SCPDiagWalkIcons`) đều dừng ở icon object, không đi tiếp sang view; (iii) đường view→icon duy nhất (`-iconLongPressedUnsafe:`, `SCPCarSplit.m`) đi từ **hit view của một cú chạm giữ**, không liệt kê.
- **Log sẽ ghi (chỉ sau khi có điểm hook liệt kê mới ở §2):** `state=PRESENT-CELL-OK` hoặc một trong `PRESENT-CELL-HIDDEN hidden=<0/1> alpha=<f> opacity=<f> frame=<rect> window=<0/1> attached=<superview!=nil> viewClass=<cls> inLists=<n>`; khi chưa có điểm hook đó, dòng trung thực duy nhất được phép ghi là `state=PRESENT-CELL-UNKNOWN reason=no-model-to-cell-path` — **không** được suy "cell ổn" từ việc model có icon, và không được suy "cell bị ẩn" từ việc mắt người không thấy icon.
- **Trạng thái trước/sau:** trước — (c) là khoảng mù toàn phần (nhãn STUCK ở §6). Sau khi thêm điểm liệt kê — (c) mới đo được; đó là việc của vòng instrument tiếp theo, không phải kết luận của biên bản này.

---

## 5) Giới hạn khẳng định — phần nằm NGOÀI tầm đọc của tiến trình này

1. **Chuỗi dashboard dựng lại cell sau Home nằm ngoài tầm đọc hiện tại.** Sau khi orig `_handleHomeEvent:` chạy (`SCPHooks.m:245`), việc dashboard có tạo/huỷ/tái dùng `IconView` nào, theo thứ tự nào, từ model nào, diễn ra trong code gốc của CarPlayApp mà **không hook nào hiện tại quan sát ở tầng cell**: các hook sau-original đang có (home VC `viewDidAppear:`/`viewDidLayoutSubviews`, root VC `viewDidAppear:`) chỉ chạm mức VC/layout/apply, không chạm cell. T3 trong §2 vì vậy đo được *hậu quả ở tầng model* sau handler gốc, **không** đo được *quá trình dựng cell* — khoảng mù này chỉ đóng bằng điểm hook tầng cell (§4c), không đóng bằng thêm log ở tầng model.
2. **Process khác là mù tuyệt đối:** mọi instrument `[homelib]`/`[applib]`/`[m5-*]` chỉ chạy trong process nạp dylib này (`proc=` tại `SCPAppIcons.m:123-127`, `SCPHooks.m:56-60` — phiên ytz4 đã xác nhận họ Home chạy trong CarPlayApp). Quyết định/hành vi ở SpringBoard hay process khác không xuất hiện trong các dòng này; vắng mặt trên log CarPlayApp không phải bằng chứng không xảy ra ở nơi khác.
3. **Kỷ luật 1 (giữ nguyên từ các vòng trước):** `count=0` của một reader **không hợp lệ** (gốc/ngữ cảnh/thời điểm không chứng minh đọc trúng cây sống — §1.3) **không phải bằng chứng icon bị xoá**. Muốn kết án "bị xoá khỏi model" phải có đồng thời: mốc dương tính cùng reader/gốc cho count>0 ở bundle khác, và bundle đích vắng — tức điều kiện cổng của §4b.
4. **Kỷ luật 2:** "không có `remove`" (toàn phiên `[homelib] decision=remove` = 0; đường remove duy nhất trong code là `SCPRefreshAppIconsBlock`, `SCPAppIcons.m:340-355`, chỉ chạy khi danh sách chosen đổi và bundle rời chosen set) **không chứng minh toàn bộ thư viện vô tội**: nó chỉ minh oan đúng một hành động (`removeApplicationProxy:` qua đường refresh đó). Library/model còn có thể mất icon qua: dựng lại library mới (`Hook_newApplicationLibrary` — info được load lại từ proxy, declaration phải inject lại qua `Hook_loadFromProxy`; một lần load trượt/không-chosen-tại-thời-điểm-đó cho kết quả vắng mà không cần remove), lọc visible (`isIconVisible:`), hoặc cơ chế gốc của dashboard — cả ba đều không phát dòng `remove`.
5. **Kỷ luật 3:** `decision=inject` cuối cùng của một bundle (vd YouTube ở phiên ytz4) chỉ chứng minh declaration đã ghi lên **info object tại lần load đó**. Nó không chứng minh icon object từ info đó đã vào model của lưới đang hiện, càng không chứng minh cell đã được dựng/hiện — ba tầng info → model → cell là ba khẳng định riêng, phải đo riêng (§2, §4).
6. **Thời gian thực:** T1/T2 cách nhau bởi chính thân `closeGoingHome:` (detach + fade 0.2 s bất đồng bộ — container `removeFromSuperview` trong completion). Một đọc tại T2 "ngay cuối hàm" vẫn sớm hơn completion của fade; trạng thái view trong cửa sổ 0.2 s đó **chưa** có mốc đo — nếu cần, thêm mốc T2b = trong completion block của animation (log-only, cùng hàm).

---

## 6) Cách kiểm tra

### Tĩnh (trên cây `src` HEAD `38735c5`, không cần xe)

1. `grep -rn "closeGoingHome" src --include=*.m` → phải ra đúng 13 hàng của §3 (12 điểm gọi thẳng + định nghĩa `:1732`); thiếu/thừa là biên bản này sai hoặc cây đã đổi.
2. Đọc `SCPHooks.m:237-246` → xác nhận orig `_handleHomeEvent:` là câu lệnh cuối của hook (T3 = sau dòng đó).
3. Đọc `SCPHomeApply.m:253-268` → xác nhận `homelibOmniOnGrid` mẫu **trước** bộ lọc injected và `found` thu **sau** bộ lọc — mẫu presence-đúng-duy-nhất hiện có.
4. `grep -rn "IconView" src/SplitScreenA src/SplitScreenC --include=*.m` → xác nhận không điểm nào đọc property `icon` của một `IconView` theo bundle (ngoại lệ duy nhất được phép: hit-test `-iconLongPressedUnsafe:`).
5. Khi instrument `[m5-icon]` được thêm (vòng sau): kiểm tĩnh 3 điều — (i) không lời gọi nào ngoài `OMCLogWrite` trong các điểm đo; (ii) mọi nhánh mù log `NA`/mã lý do, không log `0`; (iii) `state=ABSENT` chỉ phát sau cổng `lists>0 && modelIcons>0`.

### Xe — Bước 5 theo kịch bản GPT: A/B thoát lúc hiện / thoát lúc mờ, với instrument cell

Điều kiện tiên quyết: instrument §2 (1)+(2) và §3 (`src=`) đã vào bản đo; phần cell (§2 mục 3) nếu chưa vào thì kịch bản vẫn chạy nhưng ô cell giữ `PRESENT-CELL-UNKNOWN` và verdict cell là PENDING-DEVICE/STUCK, không suy.

1. **Chuẩn bị:** split đang mở, app bản đồ injected (bundle đích, ghi rõ bundle trong log phiên) hiện trên lưới Home khi về Home lần 1 — chụp mốc thời gian + dòng `[m5-icon] t=T3 state=…` làm mốc dương tính nền.
2. **Ca A — thoát lúc controls/icon ĐANG HIỆN:** từ split, thoát bằng đúng 1 nguồn đã chọn trước (ưu tiên nguồn Home hệ thống #1), về Home, chờ ≥ 2 s. Đọc chuỗi `T1 → T2 → T3` của bundle đích: kỳ vọng phân định được (a)/(b)/(c) tại T3.
3. **Ca B — thoát lúc controls ĐANG MỜ (sau fade/idle):** lặp lại y hệt, cùng nguồn thoát, chỉ khác trạng thái mờ tại thời điểm thoát. So A↔B trên cùng các trường: `inModel`, `isIconVisible`-result, (cell nếu có).
4. **Đối chứng nguồn:** lặp 1 ca với nguồn #12 (`exitTapped`, `goHome=YES`) — nếu mất icon chỉ xảy ra ở nhóm `src=home-hook/present/dismiss/solo-native-return` mà không ở `exitTapped`, tương quan mới là theo **nguồn**, không còn là theo `goHome`.
5. **Tiêu chí verdict:** mất icon trên màn hình chỉ được kết án tầng nào khi dòng `[m5-icon]` cùng mốc chỉ đúng tầng đó: T3 `ABSENT` → tầng model; T3 `PRESENT-CELL-HIDDEN/…window=0` → tầng cell; T3 `PRESENT-CELL-OK` mà mắt vẫn không thấy → khoảng mù §5.1 (dashboard dựng/trình bày) — ghi PENDING, không kết án thêm. Mọi ca có `state=BLIND` ở bất kỳ mốc nào: ca đó **vô hiệu**, không tính vào tương quan.

---

## 7) Nhãn theo nhóm trường

| Nhóm trường | Nhãn | Lý do |
|---|---|---|
| Bundle id của icon — tầng model (`applicationBundleID`/`leafIdentifier`) | **SOURCE-PROVEN** | Hai đường đọc độc lập đã có trong code và đã chạy: publish walk `SCPHomeApply.m:263`, walker `SCPCarApps.m:77-85`; bundle của icon đơn lẻ tại `SCPHomeVisibility.m:67-75` |
| Presence trong icon model tại T1/T2/T3 | **SOURCE-PROVEN** (khả năng đọc) / **PENDING-DEVICE** (giá trị tại 3 mốc của ca mất icon) | Đường đọc proven như trên, nhưng chưa điểm đo nào ghi nó **tại** T1/T2/T3 trong một ca mất icon thật |
| Library/info: presence, `_carPlayDeclaration` ours, `tags`, decision `[homelib]` | **SOURCE-PROVEN** | `SCPAppIcons.m:151-…` (inject + journal quyết định `:110-147`), `SCPHooks.m:86-124` (new-library + loadFromProxy kèm log ytz4 đã chạy trên xe) |
| Info `isHidden`/`isInstalled`/`presentsFullScreen` ngoài thời điểm inject | **PENDING-DEVICE** | Getter proven tại thời điểm inject (`SCPAppIcons.m`, khối log `chen …`); đọc lại tại T1/T2/T3 cần instrument — chưa có điểm đọc |
| `isIconVisible:` result theo bundle injected | **PENDING-DEVICE** | Hook proven (`SCPHomeHooks.m:139-150`) nhưng không log theo bundle; giá trị trong ca mất icon chưa từng được ghi |
| Nguồn gọi close (`src=`) | **PENDING-DEVICE** (sau instrument tối thiểu §3) / hiện tại mới **SOURCE-PROVEN về danh sách điểm gọi** | Danh sách 13 điểm là tĩnh-proven; quy nguồn trên log hiện tại không máy-đọc-được, 2 điểm vô hình (#7, #8) và các lần gọi no-op khi `!active` vô hình |
| Dock view/window (`appDockViewController → view.window/isHidden/frame`) | **SOURCE-PROVEN** | `SCPCarSplit.m:3160-3172` + 3 điểm dùng khác cùng mẫu; nhưng dock ≠ lưới icon — proven cho dock, không suy sang icon |
| Cell của đúng bundle: đối tượng `*IconView` | **STUCK** | Không tồn tại đường model→cell hay liệt-kê-view→bundle trong code đã chạm (§4c); cần điểm hook liệt kê mới — ngoài phạm vi "đo bằng code hiện có" |
| Cell: `hidden` / `alpha` / `layer.opacity` / `frame` / `window` / attached — **theo bundle** | **STUCK** | Property đều đọc được trên `UIView` nói chung (mẫu dump/dock proven), nhưng không có đối tượng cell-của-bundle để đọc lên; `layer.opacity` thêm nữa là chưa có bất kỳ điểm đọc nào trong các file đã rà |
| Quá trình dashboard dựng lại cell sau orig `_handleHomeEvent:` | **STUCK** (khoảng mù §5.1) | Không hook tầng cell nào tồn tại; T3 chỉ đo hậu quả tầng model |
| Live-grid reader gốc `connectedScenes/windows` (`SCPCarHomeBundles`) | **STUCK như một đầu đo** — không dùng làm bằng chứng nữa cho tới khi có bộ đếm trung gian §1.3 | `count=0` 5/5 (ytz3) + tiếp tục không phân định (ytz4); code không ghi tầng mù |

---

*Biên bản chỉ-đọc, viết từ source HEAD `38735c5`. Không file nguồn nào bị sửa. Không khẳng định nào trong biên bản này về nguyên nhân mất icon — phạm vi duy nhất là: trường nào đo được, ở đâu, lúc nào, và trường nào chưa.*
