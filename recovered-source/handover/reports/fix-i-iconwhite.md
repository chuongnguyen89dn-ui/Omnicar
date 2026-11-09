# FIX-I — Instrument hẹp: mất icon OmniCar + ô trắng (WO GPT mục 4a)

Mức đạt: **source complete / build PASS / static PASS** (chưa có bằng chứng xe — instrument này chính là để tạo bằng chứng đó).
Phạm vi: CHỈ cộng log, không đổi hành vi. File sửa: `SCPCarApps.m`, `SCPCarSplit.m` (cả hai cây project/ + src/, cmp identical).
Bundle của chính OmniCar: **`com.anlai.omnicar.app`** (CFBundleIdentifier trong `src/App/Info.plist`, đã đọc trực tiếp).

## 1. Bản đồ đường app-library (đọc từ source, không suy đoán)

### 1a. Danh sách app cho picker/split — NẰM trong hai file được giao
- **Nguồn:** `SCPCarPlayAppInfos()` (SCPCarApps.m) = thư viện hệ thống (`sharedApplicationLibrary` → `allInstalledApplications`, lọc `SCPAppHasCarPlayUI`) **gộp** với lưới Home đang sống qua `SCPCarHomeBundles()` (đọc IconListView trong cây window). `SCPChosenPhoneAppInfos()` = `SCPBridgedChosenApps()` (pref `appBridgeApps` ∩ app đã cài, cache 60 s) ∩ LSApplicationWorkspace.
- **Sự kiện dựng/dựng lại:** mỗi lần picker mở (`SCPCarSplit+Picker.m:339` gọi cả hai builder — file không được giao, nhưng builder nằm ở đây nên log phủ được); `-[SCPCarSplit publishCarPlayApps]` (SCPCarSplit.m:2606, gọi từ SCPHooks.m:349 lúc màn xe hiện) cho phía Settings; cache bridged bị vô hiệu bởi Darwin `prefschanged` + hết hạn 60 s.
- **Điểm lọc:** library-walk loại trùng + loại không-Có-CarPlayUI; bridged loại app-đã-chọn-nhưng-không-còn-cài.
- OmniCar (`com.anlai.omnicar.app`) có nằm trong các nguồn này hay không: từ nay mỗi lần dựng đều có cờ `omni=` trong log (mục 2) — phiên tới đọc là biết nó rời danh sách ở builder nào, mốc nào.

### 1b. Lưới Home gốc (nơi icon biến mất) — KHÔNG nằm trong hai file được giao
Vị trí thật, chỉ ghi nhận, **không instrument** theo đúng phạm vi:
- Hook `+[DashBoard _newApplicationLibrary]` và `-[DBApplicationInfo _loadFromProxy:]`: **SCPHooks.m:56/72** (cài tại :630–633).
- Họ tiêm app: **SCPAppIcons.m** — `SCPAddChosenAppsToLibrary` (thêm proxy app đã chọn vào library), `SCPInjectDeclarationIfChosen` (ghép `CRCarPlayAppDeclaration`), `SCPRefreshAppIconsBlock` (**gỡ** proxy bằng `removeApplicationProxy:` cho app hết được chọn, debounce 0,8 s qua `SCPRefreshAppIconsSoon`), máy trạng thái crash-guard `SCPAppIconsBeginInjection`.
- Đồng bộ trình bày lưới (cỡ icon/tên/layout): **SCPHomeApply.m** (`SCPHomeApply` + `SCPPublishCarAppsBlock` sub_4c438).
- Phần duy nhất của đường này nằm trong file được giao là **reader**: `SCPCarHomeBundles()` đọc trực tiếp nội dung lưới gốc đang sống — dòng `[applib] live-grid-read` là thăm dò trực tiếp icon OmniCar còn trên lưới hay không tại các mốc dựng picker.

## 2. Các điểm [applib] đã cộng (SCPCarApps.m trừ dòng cuối)

| Điểm | Vị trí | Nội dung |
|---|---|---|
| Hằng self-bundle + helper | SCPCarApps.m:41 | `com.anlai.omnicar.app` |
| `live-grid-read` | SCPCarApps.m:125 (trong `SCPCarHomeBundles`) | count + omni của lưới gốc tại thời điểm đọc |
| `drop chosen-not-installed` | SCPCarApps.m:280 | bundles đã chọn nhưng không còn cài (wanted − result) |
| `bridged-rebuild` | SCPCarApps.m:287 | mỗi lần cache bridged dựng lại: count + omni (cache hit không log) |
| tally drop | SCPCarApps.m:323/326 | pre-check thuần đọc tại 2 điểm `continue` sẵn có: `(duplicate)` / `(no-carplay-ui)` |
| `drop library-walk` + `build picker-native` | SCPCarApps.m:345/349 | danh sách bị loại + count/omni/fromGrid/omniFromGrid (phân biệt OmniCar vào danh sách nhờ library hay nhờ lưới) |
| `build picker-chosen` | SCPCarApps.m:361/384 | feature-off (count=0) và bản dựng thường: count + omni |
| `build publish-for-settings` | SCPCarSplit.m:2666 | tại `publishCarPlayApps`: count + omni của danh sách gửi sang Settings |

## 3. Các điểm [scenevis] đã cộng (SCPCarSplit.m)

Helper chỉ-đọc `SCPSceneVisLog` (SCPCarSplit.m:56): một dòng `[scenevis] <event> bundle= slot= scene=<id|?|nil> attached= inHost= hidden= alpha= window=` — attached = có scene object (`SCPSceneOfVC`); inHost = view của VC đang nằm trong `pane.host`; lifecycle của scene được đại diện bằng scene id + attached (FBScene không có getter trạng thái rẻ hơn tại các điểm này). Sự kiện vòng đời (force) không bao giờ bị throttle; `verify` và `host-state-*` throttle 1 s/(event, bundle).

| Event | Vị trí | Ý nghĩa |
|---|---|---|
| `attach` | :1173 (`adopt:slot:`) | scene native vừa reparent vào pane |
| `detach` / `detach-bg` | :1206 (`detachVC:background:`, TRƯỚC khi detach chạm vào view) | gỡ VC khỏi pane |
| `scene-destroyed` | :1266 (nhánh match) | scene của pane bị huỷ |
| `verify` | :1343 (cạnh dòng "scene … that = …" sẵn có) | trạng thái VIEW cạnh verdict khung scene — điểm phân định ô trắng: khung đúng nhưng hidden=1/inHost=0/window=0 sẽ lộ ở đây |
| `pane-remove` | :1538 (`removePaneAt:`) | pane bị xoá |
| `invalidate` | :285 (`dashboardInvalidated`, mọi pane, trước teardown) | snapshot lúc dashboard chết |
| `going-home` | :1736 (`closeGoingHome:`, mọi pane, trước detach) | snapshot đúng điểm thoát Home của sự cố |
| `host-attach` | :1917 (`hostApp:inPane:`) | app hosted vào pane (scene=nil là đúng: scene nằm phía SpringBoard) |
| `host-state-<state>` | :1990 (`hostedApp:state:`) | đáp trạng thái từ host (ready/failed/…) |

## 4. Cổng

- **Build SplitScreen sạch PASS**: `make clean && make` exit 0, link + ký xong, dylib 1.316.256 B. Warnings: chỉ warnings cũ (performSelector-leak :68, -Wnonnull ở teardown :309–311, unused `SCPDynamicLabelColor`...) — **0 warning trong các dòng cộng thêm**.
- **Diff thuần cộng**: đối chiếu với mirror trước-sửa (trạng thái gốc): SCPCarApps.m diff 68 dòng / SCPCarSplit.m 66 dòng, **số dòng bị xoá = 0 ở cả hai**. Mọi dòng cộng là: lời gọi `OMCLogWrite`, helper chỉ-đọc, biến tally cục bộ, và 2 lần gọi thêm vị từ thuần đọc (`SCPAppHasCarPlayUI` — SCPShared.m:260, chỉ guarded-get; `OMCFeatureEnabled` — cùng hàm cổng sẵn có trong chính builder). Không dòng điều kiện/return/gán trạng thái nào bị đụng.
- **Mirror**: sau khi chép, `cmp` identical cả hai cặp (SplitScreenC/SCPCarApps.m, SplitScreenA/SCPCarSplit.m).
- **Binary**: dylib chứa đủ 8 format `[applib]` + 1 format `[scenevis]` (strings đã kiểm).

## 5. Cách đọc log phiên tới

- **Icon:** tìm chuỗi `[applib] build reason=live-grid-read … omni=` — mốc omni chuyển 1→0 (và các dòng build/drop cùng mốc) cho biết icon rời lưới gốc khi nào và danh sách nào mất nó trước; `publish-for-settings`/`picker-native` cho phía picker.
- **Ô trắng:** tại mốc trắng, ghép dòng `CarSplit: scene … that = …` (khung) với `[scenevis] verify` gần nhất của bundle đó: attached/inHost/hidden/alpha/window phân định "scene sống nhưng view không trình bày" với "scene chết/không gắn".
