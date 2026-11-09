# GPT — Bàn giao Home Launcher của CHÍNH OmniCar (2026-11-09, Asia/Ho_Chi_Minh)

> **Trạng thái: SOURCE-COMMITTED / STATIC-CHECK-PASS / BUILD CHƯA CHẠY / DEVICE PENDING.**
> Không gọi tính năng đã hiện trên xe. Muse là người hợp nhất YTZ5 + GPT vào MỘT DEB rồi build/ký theo lệnh của Nguyen. Không merge vào main và không dispatch CI từ phía GPT.

## 1. Nguồn sự thật / phạm vi

- Repository **duy nhất**: `chuongnguyen89dn-ui/Omnicar`. Cây thi công `recovered-source/`; đầu mối chung `recovered-source/TIEP_TUC_DU_AN.md`; lịch sử GPT `recovered-source/gpt-project-history/README.md`.
- Main khi tạo nhánh: `3e25499d62cb471e0aa468871535182eb7abaec8` (2026-11-09; YTZ5 của Muse đã có trên main, commit nguồn `e6b50a4`).
- Nhánh code **đã tồn tại và kiểm trực tiếp**: `feature/omnicar-home-launcher`. Tạo trước khi GPT ghi code, tip nền đúng main `3e25499d`; GPT **không tạo lại** nhánh.
- Bốn commit source liên tiếp, GitHub connector trả thành công:
  1. `81e4b23cadda2ecfc59b7c616a40250acd191366`: app/library/declaration/model/launch cơ bản.
  2. `c4641f7891a4b7f8998943f4e57a3adf5a789344`: hook callback chạm thật, đúng ABI iOS16; đo trước/sau close bằng điểm Muse đã có.
  3. `14404b2c9cf8ea31fad80ebe57b8dd2140599870`: import tương thích hai cây + `string.h` + log danh tính chạm.
  4. **TIP mã bàn giao** `1479711ed7e33405bb16de2687fe08ec78214567`: chống chọn nhầm OmniCar làm hosted phone app từ preferences cũ.
- Kết quả GitHub compare `3e25499d...feature/omnicar-home-launcher`: **ahead=4, behind=0**, tổng 14 đường dẫn thay đổi (trong đó 4 file mới vì có cặp `src/project`). Đây là dữ kiện GitHub, không phải local checkout hoặc build.
- Không động nguồn DuoFace; chỉ **đọc** lịch sử QA134–146 để chốt đúng đường Home; không copy mã độc quyền DuoNavi/DuoDash hoặc mã tham khảo CarSurf.

## 2. Đối chiếu lịch sử DuoFace — tránh lặp sai lầm

Dữ kiện thực từ `chuongnguyen89dn-ui/Duoface` (repo **tham khảo**, không phải repo thi công):
- QA135 Log15 iOS16.7.16: `FBSApplicationLibrary -addApplicationProxy:withOverrideURL:` có ABI `v32@0:8@16@24`, còn việc app đã nằm trong thư viện **không** chứng minh icon Home hiện.
- QA136 Log16: reconcile=6 thông tin app nhưng **không có icon**; thiếu `DBApplicationInfo` declaration/policy, icon model và đường launch. Vì vậy bản GPT tách `library`, `declaration`, `model`, `tap`.
- QA137 Log17: **`+[DashBoard _newApplicationLibrary]` hiện diện trong CarPlayApp**; `CARApplication` không hiện diện ở process đã đo. GPT dùng hook DashBoard + `DBApplicationInfo _loadFromProxy:` vốn đã có trong OmniCar, không giả định `CARApplication`.
- QA141/142: user xác nhận 6 icon app đã xuất hiện nhưng chạm **không mở**; không được coi injection = launch.
- QA142 Log21: `-[DBDashboardHomeViewController iconManager:launchIconForIconView:]` **có mặt**, chữ ký thật **`v32@0:8@16@24`**; overload `iconManager:launchIcon:` không có. GPT thêm hook đúng chữ ký đó với kiểm `method_getTypeEncoding` trước khi install.
- QA138 cũ: thay entitlement toàn cục gây đệ quy/crash SpringBoard/CarPlay; **không sử dụng entitlement spoof** trong phần GPT.
- QA143 (app khác ngoài Home mở nhầm split DuoFace) bị user bác, nhưng đây là **icon của CHÍNH OmniCar**, yêu cầu riêng hiện tại của Nguyen chính là mở **panel bố cục/split**. Không áp dụng hành vi standalone của app ngoài Home vào icon OmniCar.

Nguồn khảo sát: `Duoface/sideplay/audit/carplay-home-icons-20261031/`, `Duoface/sideplay/audit/qa137-real-log17-20261031/`, `Duoface/sideplay/audit/qa142-log21-home-click-20261031/`, `Duoface/sideplay/audit/qa144-standalone-home-20261031/`. Phân biệt log xe DuoFace quá khứ với bằng chứng runtime OmniCar (chưa có cho tính năng mới).

## 3. Thiết kế đã chốt và code đã ghi

**Danh tính tuyệt đối**: `com.anlai.omnicar.app` (trong app Info.plist binary và AppDelegate của dự án); icon resource `OmniCarApp/Resources/AppIcon60x60@2x.png`, `@3x.png`. Không thay Info.plist, icon của app, ký entitlement hay cài đặt iPhone.

- **Module mới**: `src/SplitScreenC/SCPHomeLauncher.{h,m}` cùng bản build-root `project/OmniCarSplitScreen/SCPHomeLauncher.{h,m}`. Bản `src` dùng import `../SplitScreenA/`, bản `project` dùng import phẳng — đây là sai khác chỉ để đáp ứng cây thư mục.
- **Đăng ký thư viện**: `SCPHomeLauncherEnsureInLibrary`, được gọi từ `SCPHooks.m:Hook_newApplicationLibrary` sau original. Tìm `DBApplicationInfo` hiện hữu trước; chỉ thêm `LSApplicationProxy` của đúng self-bundle có `appState.isValid`, gọi `addApplicationProxy:withOverrideURL:` của library **hiện tại**; không thêm trùng.
- **Declaration**: `SCPHomeLauncherInjectInfo` khi `DBApplicationInfo _loadFromProxy:` và sau library lookup. Chỉ self-bundle; giữ nguyên declaration có sẵn; khi thiếu, tạo `CRCarPlayAppDeclaration` theo contract `SCPAppIcons.m` (supportsMaps YES, supportsTemplates NO), ghi `_carPlayDeclaration` + tag `OmniCarHomeLauncher` + `_valid` khi cần; không thay on-disk entitlements. Đây là **implementation candidate**, phải kiểm thực tế iOS/CarPlay policy trên xe.
- **Model**: `SCPHomeHooks.m:SCPHook_IsIconVisible` có cổng riêng cho own-bundle khi splitScreen enabled; còn lại **giữ đường original** cho native và phone injected. `SCPHomeLauncherAuditModel` đi `SCPHomeVCWeak.view → *IconListView → model.lists.icons`, log `BLIND / ABSENT-MODEL / PRESENT-MODEL`, và chỉ log cell khi đọc được *IconView của đúng bundle. Không coi model hoặc library là chứng minh pixel/tap.
- **Chạm**: `SCPHomeLauncherInstallTapHook` gọi trong constructor Home đã có; kiểm ABI đúng `v32@0:8@16@24` rồi hook `DBDashboardHomeViewController iconManager:launchIconForIconView:`. Đọc identifier của iconView/icon qua các getter object ABI `@16@0:8`; **chỉ** own-bundle bị consume, mọi app khác và unknown gọi **original đúng một lần**. Các hook launch-info và `DBDashboard _launchAppWithInfo:` cũ có dự phòng same-bundle.
- **Tuyến mở**: `SCPHomeLauncherConsumeLaunch` gom nhiều callback trong ~0,65 s; kiểm feature và live CarPlay root; chạy `SCPCarSplit shared → showLayoutPanelForApp:` (panel bố cục **đang tồn tại**, cùng split controller của nút dock), có `ahNoteActivity:AHSourceHome` như nút dock. Không `openURL`, không `prefs:root=OmniCar`, không tạo session engine thứ hai, không phát Dashboard event-1.
- **Chặn nhầm hosted**: `SCPChosenPhoneApps` lọc own bundle khỏi `appBridgeApps` chỉ trong bộ nhớ, **không xoá preference**. `SCPShared.m:SCPIsHostedApp` có return NO sớm cho own-bundle, kể cả prefs cũ còn chứa.
- **Vòng đời**: reconcile khi Home xuất hiện và prefs changed; audit sau Home event và Home layout; dùng đúng lời gọi `SCPLogInjectedIconState` của **YTZ5** ở `src/SplitScreenC/SCPHomeApply.m` để thêm audit own-bundle trước/sau đóng (không sửa thân `SCPCarSplit.m` của Muse). Nút dock gốc không bị sửa.

**File/hunk thực tế đã thay** (tất cả dưới `recovered-source/`):
- A: `src/SplitScreenA/SCPHooks.m` (constructor, library/info, Home lifecycle, launch callbacks, prefs, after Home); `src/SplitScreenA/SCPShared.m` (một nhánh self-bundle).
- C: `src/SplitScreenC/SCPAppIcons.m` (lọc own khỏi chosen AppBridge); `src/SplitScreenC/SCPHomeHooks.m` (own visibility); `src/SplitScreenC/SCPHomeApply.m` (gọi audit tại entry của instrument YTZ5); module mới `SCPHomeLauncher.h/.m`.
- Project flat: `project/OmniCarSplitScreen/SCPHooks.m`, `SCPShared.m`, `SCPAppIcons.m`, `SCPHomeHooks.m`, module mới `SCPHomeLauncher.h/.m`, `Makefile` (thêm `SCPHomeLauncher.m` vào `OmniCarSplitScreen_FILES`).
- **KHÔNG sửa** `SCPCarSplit.m`, AutoHide, BridgeWake, Picker, YTZ, keyboard, feed native, scene/window geometry, SpringBoard, Prefs hoặc app resources.

## 4. Bằng chứng kiểm tại chỗ và ranh giới chưa chứng minh

Đã trực tiếp kiểm qua GitHub connector:
1. `main`/branch thật và Actions runs, phân biệt run YTZ5 **42615117251 success trước phân công** và **42615107515 cancelled** — GPT không chạy CI mới.
2. Mọi thay đổi chuỗi hunk chỉ áp khi **anchor xuất hiện đúng 1 lần** trong file đã fetch theo branch (tránh overwrite nguyên file).
3. Static contract assertions trong khi tạo commit: own-bundle được lọc AppBridge; original fallback cho app khác còn nguyên; không chạm `SCPCarSplit.m`/Muse’s AutoHide; không `openURL`/event-1; own panel reuse; trạng thái model 3 nhãn; module mới `src/project` khớp ngoại trừ import hợp đồng cây; callback Home có runtime ABI guard.
4. GitHub `create_tree`, `create_commit`, `update_ref` trả thành công cho cả 4 commit; `fetch_file` đọc lại mã module sau commit; `compare_commits` ahead 4/behind 0 cho nhánh.
5. Bản `project/OmniCarApp/Resources/Info.plist` là **binary plist**, GitHub fetch UTF-8 thất bại, đã xác minh qua base64 rằng self-bundle là `com.anlai.omnicar.app`; không sửa file binary.
6. Thử lệnh `git ls-remote` từ local container thất bại do **không DNS github.com**. Không có local checkout/toolchain Theos đã xác nhận; không lấy đường VM của Muse như môi trường GPT.

**Chưa kiểm**: compile/link module mới bằng SDK iOS; chữ ký/architecture hash DEB cuối; runtime iOS CarPlay `CRCarPlayAppDeclaration`/policy; hiện cell/icon trên xe; chạm mở panel; dock ổn; AutoHide/close/reconnect/restart. Vì vậy **KHÔNG phải BUILD PASS, RUNTIME PASS hay DEVICE PASS**.

**Khoảng trống `src/project` trước GPT đã quan sát**: dự án `src/SplitScreenC/SCPHomeApply.m` YTZ5 có ~540 dòng và `SCPLogInjectedIconState`, còn `project/OmniCarSplitScreen/SCPHomeApply.m` trên main chỉ ~333 dòng; `src/SplitScreenA/SCPCarSplit.m` và `project` cũng khác do YTZ5. Không được copy phiên `project` cũ đè YTZ5, cũng không được nói hai cây toàn bộ giống nhau. Muse phải stage/merge theo build source thật trước khi build.

## 5. Bàn giao tích hợp cho Muse (không tạo DEB thứ hai)

1. Đối chiếu nhánh `feature/omnicar-home-launcher` tip `1479711ed7e33405bb16de2687fe08ec78214567` với main nguồn YTZ5. Lấy **hunk riêng** ở A/C và module mới, tránh chép nguyên `SCPHooks.m` bản project cũ phủ lên YTZ5. Chú ý `SCPHomeApply.m` chỉ bổ sung lời gọi audit tại entry `SCPLogInjectedIconState`; giữ nguyên toàn bộ phần Muse.
2. Staging `src` → `project` theo hợp đồng project/Makefile thật, kiểm compile đã link module `SCPHomeLauncher.m`; confirm ký, version, arch và hash trên CHÍNH artifact tích hợp, không dựa artifact pre-order `42615117251`.
3. Chạy kiểm soát tĩnh trên artifact/cùng commit: `git diff --check`; không duplicate symbol, no missing selector without guard; kiểm method signature `v32@0:8@16@24` của máy đích, log `[home-launch]`. Regression các app native, app AppBridge, picker, YTZ5/kb, AutoHide, Home/dock.
4. Chỉ build/ký **một DEB tổng hợp** khi source của cả hai phần cùng nền. **Không** merge main, dispatch thêm CI, deploy Sileo hoặc nhắn Muse bên ngoài theo quyền GPT. Nguyen là người test xe.

**Phép thử xe theo thứ tự dễ làm:** vào Home CarPlay thấy đúng **một** icon OmniCar → chạm icon phải ra ngay bảng **Bố cục/Yêu thích/Gần đây**, không mở iPhone Settings → nút dock vẫn hoạt động → mở split và thoát Home lúc logo đang hiện → thử lại khi logo đã mờ → chuyển qua app khác rồi quay lại → ngắt nối CarPlay và thử lại → restart process và thử lại. Dùng chung log session/PID/artifact, không trộn hai DEB.

**Marker đọc lỗi**:
- `[home-launch] phase=library status=added-to-real-library`: chỉ chứng minh FBS library, **không** icon.
- `phase=declaration status=injected`: khai báo gắn trong `DBApplicationInfo`, không phải scene thật.
- `phase=model state=BLIND`: không đủ đầu đo; **không được** kết luận icon vắng. `ABSENT-MODEL` / `PRESENT-MODEL` chỉ tầng model. `ownCells`/ `attached` phụ thuộc lấy được đúng cell.
- `phase=tap-gate status=installed`: hook được cài; không chứng minh user bấm.
- `phase=home-callback observedBundle=com.anlai.omnicar.app`: callback nhận đúng danh tính; `phase=tap status=routed-existing-panel`: code đã gọi panel, vẫn cần Nguyen xác nhận UI.
- Nếu có icon nhưng không chạm: phân định từ `home-callback` và method ABI, không tiếp tục thêm proxy; nếu không có icon: xem library/declaration/model; nếu panel không mở dù routed: điều tra `tabParent/tray` hiện hành, không tạo split engine mới.

**Hoàn nguyên:** không cherry-pick 4 commit GPT (hoặc revert các commit đúng thứ tự nếu đã tích hợp); nguồn Muse YTZ5 và dock nguyên vẹn. Không xoá dữ liệu, không thay preference lưu trên iPhone. Đây là checkpoint theo sự kiện; công việc dừng ở cổng **integrate/build/test**, không phải tác vụ chạy nền.
