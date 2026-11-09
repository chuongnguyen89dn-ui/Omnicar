# probe-exit-fade — Đường thoát Home có nhạy với trạng thái mờ không?

Điều tra chỉ-đọc, cây nguồn `src/` (bản ytz4). Dữ kiện A/B từ xe
(Nguyen, phiên ytz4): thoát Home khi controls CÒN HIỆN → icon app được
chọn (YouTube) còn nguyên trên lưới Home; thoát Home khi controls ĐÃ
MỜ ẨN → icon MẤT. probe-fade-icon.md đã minh oan lớp sơn (danh sách
sơn đóng, không view sơn nào là tổ tiên của cell icon). Biên bản này
đọc đường thoát + đường áp Home để tìm điểm đọc trạng thái mờ.

## KẾT LUẬN NGẮN

**Không một quyết định nào trên đường thoát Home / áp thư viện đọc
một giá trị mà fade đã thay đổi** — đã rà toàn bộ: `closeGoingHome:`,
hai hook thoát của dashboard, `homePressedDuringSplit:`, họ ghép
declaration (SCPAppIcons), họ áp Home (SCPHomeApply /
SCPHomeIconModelLayout) và họ ẩn/hiện icon (SCPHomeVisibility). Mọi
quyết định chỉ đọc pref (`appBridgeApps`, settings Home, hai danh
sách hidden/shown) và trạng thái cấu trúc (active, pane.vc,
currentBaseViewController). Đồng thời phát hiện một RÒ TRẠNG THÁI có
thật trên đường thoát: `closeGoingHome:` **không bao giờ gọi khôi
phục sơn hay `ahSessionTeardown`** — thoát lúc đang mờ thì `ahFaded`
kẹt YES và các save opacity kẹt trên chrome của tweak sang cả phiên
sau; nhưng bán kính của nó theo code chỉ tới chrome/state của tweak,
không tới cell icon. Phần khớp A/B còn lại nằm ở bất đối xứng điểm
vào (sự kiện dashboard type 1) và cơ chế phía dashboard — ngoài cây
này, ghi ở §4, không kết án thay.

## 1) TRÌNH TỰ THOÁT ĐẦY ĐỦ (theo thứ tự gọi)

### 1.1 Các điểm vào `closeGoingHome:`

| Điểm vào | Vị trí | goHome |
|---|---|---|
| Sự kiện Home của dashboard (hook `_handleHomeEvent:`) | SCPHooks.m, sub_601c (~dòng 238–245) | NO |
| Dashboard dismiss về man chính (hook `dismissBaseViewControllerAnimated:`) — chỉ khi split active VÀ không còn base VC | SCPHooks.m, sub_66dc (~dòng 352–362) | NO |
| Dashboard trình bày một base toàn màn (hook presentBase) | SCPHooks.m:297, :313 | NO |
| Lệnh native "close" (kênh splitscreen.native) | SCPHooks.m:603 | YES |
| Đóng ô cuối → `afterPaneRemoved:` hết ô | SCPCarSplit.m:1597, :1607 | YES |
| `soloBundle:` (các nhánh đóng) | SCPCarSplit.m:2310, :2318, :2384 (YES); :2339 (NO) | cả hai |
| Nút thoát trên thanh ô (`exitTapped`) | SCPCarSplit.m:2447 | YES |

### 1.2 Thân `closeGoingHome:` (SCPCarSplit.m:1732–1773), đúng thứ tự

1. `if (!self.active) return;` + log `CarSplit: tat split (goHome=%d)`.
2. Snapshot `[scenevis] going-home` cho từng pane (trước mọi detach).
3. `[self hostCloseAll]` — đóng mọi app hosted phía ABHost.
4. Từng pane: huỷ `barTimer`; `detachVC:background:YES` nếu có vc;
   `pane.vc = nil; pane.bundleID = nil` (vô điều kiện); gỡ
   `pane.picker`.
5. `self.active = NO`; xoá `pending`; `[self publishBusy]`.
6. `removePickerSheet`, `hideRatioMenu`, `cancelPaneDrag`.
7. `removeCoverFromPane:` cho từng slot.
8. Tách container khỏi các property (`container/slots/fractions/
   dividers/floatPane = nil`); container được animate `alpha → 0`
   trong 0,2 s (block bất đồng bộ) rồi `removeFromSuperview` ở
   completion.
9. **Chỉ khi goHome=YES:** `SCPSendDashboardEvent(1, "SplitScreen:
   dong split")` (SCPCarSplit.m:1771).
10. Đuôi: `[self refreshAppTabSoon]` (0,35 s sau → `refreshAppTab`:
    `refreshHomeButton` + nâng tray/shield — Picker.m:1038–1052) và
    `[self publishKnobsSoon]`.

**Không có trong thân hàm:** khôi phục sơn, `ahSessionTeardown`,
`bwSessionTeardown`, bất kỳ lời gọi nào tới SCPAppIcons / SCPHomeApply
/ SCPHomeVisibility, gỡ declaration, hay áp lại thư viện. (Đối chiếu
bản `project/` cho cùng kết quả.)

### 1.3 Việc chạy quanh thân hàm ở hai hook thoát chính

- Hook Home event (sub_601c): chụp `wasActive` → `closeGoingHome:NO`
  → `homePressedDuringSplit:wasActive` (đọc `soloReturnedVC`,
  `soloHostedBundle`, `ignoreHomeOnce` — SCPCarSplit.m:1796–1805) →
  ORIGINAL `_handleHomeEvent:` chạy CUỐI.
- Hook dismiss (sub_66dc): `closeGoingHome:NO` (trước original) →
  `removeAppTab` trên MỌI đường (trước original) → original dismiss
  → `refreshAppTabSoon` (sau original).
- Sau khi original của dashboard chạy và home VC hiện: hook
  `viewDidAppear:` → `SCPHomeSetVisible(YES)` (chỉ playback của wall
  view — SCPHomeSettings.m:112–121); hook `viewDidLayoutSubviews` →
  `SCPHomeApply(self)` (SCPHooks.m:128–148).

### 1.4 Đường áp Home lúc về lưới (SCPHomeApply, SCPHomeApply.m:139)

Đọc `SCPHomeSettings()` (pref) rồi: chèn/gỡ wall view; nếu cỡ icon đổi
so với cache tĩnh → `SCPReLayoutIconLists` (`layoutIconsNow` từng
*IconListView); nếu khoá lưới (cột×hàng) đổi → `SCPHomeIconModelLayout`
(SCPHomeVisibility.m:164 — gọi `layout` trên iconModel của dashboard,
fallback `_handleAppLibraryRefresh`); đặt ẩn/hiện nhãn icon; hẹn khối
sync 1 s `SCPPublishCarAppsBlock` (chỉ ghi pref `homeScreenCarApps`
cho Settings, có guard `view.window`). **Ở lần về Home thông thường
(cỡ icon và khoá lưới không đổi) SCPHomeApply KHÔNG đụng icon model.**

### 1.5 Đường teardown khác — `dashboardInvalidated` (KHÔNG phải thoát Home)

SCPCarSplit.m:273–…: `removeAppTab`, `removeHomeButton`, rồi nhánh
active mới có `bwSessionTeardown` (BridgeWake.m:566) +
`ahSessionTeardown` + pinch detach + `fsSessionDidEnd`. Đây là đường
ngắt kết nối/invalidate — đường duy nhất ở cuối phiên có khôi phục
sơn (xem §3).

## 2) ĐIỂM NÀO ĐỌC GIÁ TRỊ BỊ FADE THAY ĐỔI? — KHÔNG ĐIỂM NÀO

Rà từng quyết định trên đường §1, input thật của nó:

- `closeGoingHome:` — đọc `self.active`, `pane.vc`, tham số `goHome`.
  Không đọc opacity, `ahFaded`, trạng thái BridgeWake, `barHidden`,
  hay `launcherHost`.
- `Hook_dismissBaseViewController` — đọc `split.active` +
  `currentBaseViewController` của dashboard. `Hook_handleHomeEvent`
  — đọc `split.active`. `homePressedDuringSplit:` /
  `dismissStuckBaseSoon` — đọc `soloReturnedVC`, `soloHostedBundle`,
  `ignoreHomeOnce`, `pane.vc`. Không input mờ nào.
- Ghép declaration — `SCPInjectDeclarationIfChosen`
  (SCPAppIcons.m:171–…): đọc DUY NHẤT tư cách "được chọn" từ pref
  `appBridgeApps` qua `SCPChosenPhoneApps()` (:117–122), cộng
  `_carPlayDeclaration`/`tags` của chính info và crash-guard pref.
  `SCPAddChosenAppsToLibrary` (:319) và khối refresh
  `SCPRefreshAppIconsBlock` (:370 — chỉ gỡ app khi app rời danh sách
  chọn trong pref) cùng một nguồn pref.
- Áp Home / layout model — §1.4: chỉ pref settings + cache tĩnh
  cỡ-icon/khoá-lưới/nhãn.
- Ẩn/hiện icon — `SCPIconHiddenOnCar` / `SCPIconForcedOnCar`
  (SCPHomeVisibility.m:146–172): chỉ hai pref `homeScreenHiddenApps`
  / `homeScreenShownApps`; app được ghép (injected) bị CẤM ẩn cứng
  (:154: `SCPIsInjectedPhoneApp` → return NO).
- Hai điểm đọc `[self ahFaded]` duy nhất ngoài AutoHide/BridgeWake là
  hai lần GHI PAYLOAD sang host: `info[@"fade"]` (SCPCarSplit.m:2113)
  và `@"kfade"` (SCPCarSplit.m:2732) — không consumer nào trên đường
  thoát/Home đọc chúng. Grep toàn cây: không nơi nào ĐỌC
  `layer.opacity` của homeButton/handle/divider để rẽ nhánh (chỉ có
  hai hàm ghi đã biết ở probe-fade-icon §1.3 và self-read của accent
  trong SCPCarDividerView.m:88, không liên quan).

Kết luận §2: trong code của tweak, trạng thái mờ **không phải là
input** của bất kỳ quyết định nào về icon/thư viện/dock trên đường
thoát. A/B của Nguyen không thể sinh ra từ một phép đọc trạng thái mờ
trong cây này.

## 3) VỊ TRÍ CỦA `ahRestoreAllPainted` TRONG TRÌNH TỰ THOÁT

`ahRestoreAllPainted` (SCPCarSplit+AutoHide.m:115) có đúng hai caller:
`ahRevealBody:` (:203 — đường reveal khi có hoạt động/wake) và
`ahSessionTeardown` (:344). `ahSessionTeardown` có đúng một caller ở
cuối phiên: `dashboardInvalidated` (SCPCarSplit.m:288).

Trên đường thoát Home (`closeGoingHome:`): **khôi phục sơn không bao
giờ chạy — không phải "sau" quyết định thư viện/dock, mà vắng mặt
hoàn toàn.** Cửa sổ hệ quả, nêu chính xác mức code chứng minh được:

- Thoát lúc đang mờ: các view đã sơn (handle/divider/knob của phiên,
  homeButton) mang nguyên save opacity 0 qua toàn bộ đường thoát;
  chrome của ô chết theo container (bước 8 §1.2), riêng **homeButton
  SỐNG SÓT** (chỉ `dashboardInvalidated` mới `removeHomeButton`) và
  giữ opacity 0 cho tới lần reveal/teardown tiếp theo — khớp dữ kiện
  xe "gọi lại logo thì hiện" (chạm vào nút vô hình → `homeButtonTapped`
  → `ahNoteActivity` → reveal khôi phục, SCPCarSplit.m:3083–3085).
- `ahFadedState` chỉ được gán NO tại AutoHide.m:192 (reveal) và :343
  (teardown); `ahSessionStarted` (:322–333) KHÔNG reset nó; timer còn
  sót tự vô hiệu vì `ahTimerFired:` guard `!self.active`
  (AutoHide.m:~159). Vậy một phiên thoát-bằng-closeGoingHome lúc đang
  mờ để lại `ahFaded = YES` kẹt sang phiên sau (ảnh hưởng
  `fadedEffective` của BridgeWake và việc một homeButton dựng lại bị
  sơn mờ ngay tại SCPCarSplit.m:3069) — RÒ TRẠNG THÁI có thật, kết án
  được ở tầng code, nhưng theo §2 không có đường nào từ nó tới cell
  icon YouTube. Ghi nhận là khiếm khuyết riêng, KHÔNG kết án là
  nguyên nhân mất icon.

## 4) CƠ CHẾ THAY THẾ CÒN LẠI KHỚP A/B (xếp hạng)

1. **Bất đối xứng sự kiện dashboard theo điểm vào (tweak-side có
   bằng chứng; hậu quả phía dashboard chưa phân định).** Thoát khi
   controls ĐÃ MỜ: thanh ô vô hình, đường thoát khả dụng là sự kiện
   Home / dismiss của dashboard → cả hai đều `closeGoingHome:NO` →
   **không** gửi `SCPSendDashboardEvent(1, "dong split")`. Thoát khi
   controls CÒN HIỆN: nút thoát trên thanh ô / đóng ô cuối nằm trong
   tầm tay → `closeGoingHome:YES` → sự kiện type 1 được gửi
   (SCPCarSplit.m:1771). Nếu dashboard dùng sự kiện type 1 đó làm mốc
   làm mới icon model/thư viện khi về Home, A/B khớp hoàn toàn. Việc
   dashboard có làm vậy không nằm trong code hệ thống — cây này không
   đọc được; xếp hạng 1 vì là khác biệt tweak-side DUY NHẤT đã chứng
   minh được giữa hai nhánh thoát, và nó tương quan đúng chiều với
   trạng thái mờ (mờ ⇒ chỉ còn đường NO).
2. **Dashboard tự quyết định cell lúc layout Home (hệ thống, chưa
   phân định).** Dạng gợi ý "view chủ đang opacity 0 nên bị dọn"
   KHÔNG khớp cấu trúc cây đã xác minh (probe-fade-icon §2): view bị
   sơn duy nhất trong cây dock là homeButton — nút lá, không chứa
   cell; cell YouTube nằm ở cây con của home VC/dockView, không tổ
   tiên nào bị sơn. Dạng còn đứng được: lúc home VC layout (hook
   `viewDidLayoutSubviews` chạy đúng cửa sổ container đang animate
   alpha→0 trong 0,2 s, và ngay sau `hostCloseAll` vừa teardown scene
   của app hosted), icon model của dashboard tự lọc theo trạng thái
   valid/hiện diện của app — toàn bộ nằm phía dashboard, không kết
   án thay, cần instrument phía [homelib] lúc về Home mới phân định
   được (dòng `event=new-library` / quyết định inject của cửa sổ
   thoát trong log phiên).
3. **Rò `ahFadedState` (§3)** — có thật ở tầng code nhưng bán kính
   chỉ tới chrome/state của tweak; xếp cuối vì không nối được tới
   icon bằng bất kỳ đường đọc nào.

## PHẦN CHƯA PHÂN ĐỊNH

- Chưa đối chiếu log phiên ytz4: chưa biết hai lần thoát của Nguyen
  đi qua điểm vào nào (log có `CarSplit: tat split (goHome=…)` phân
  định YES/NO ngay trong thân hàm) và cửa sổ thoát có dòng [homelib]
  nào cho com.google.ios.youtube không. Hai dữ kiện đó quyết định
  hạng 1 hay hạng 2 ở §4.
- Mọi hành vi của dashboard (icon model, app library) là code hệ
  thống ngoài cây tái tạo — biên bản này chỉ kết án phần tweak-side.
