# VERIFY-YTZ5HL — Kiểm tĩnh độc lập, CHỈ-ĐỌC (không sửa file/commit nào ngoài biên bản này)

Cây kiểm: `~/workspace/push9-clone`, branch `integrate/ytz5-home-launcher`,
HEAD `74635d1998c21ed15cf1fb3063ece6ce09cdbfbc` (merge `c74c878` + staging
`74635d1`) — `git rev-parse HEAD` khớp đề bài. Đối chiếu: YTZ5 `e6b50a4`,
nền chung `3e25499`, tip GPT `050eddb0`. Mức bằng chứng: TĨNH (source+git)
— chưa có bằng chứng xe; module tự ghi "PENDING-DEVICE" (SCPHomeLauncher.m:9).

## (A) Khẳng định GPT — trên cây SRC, khẳng định lại trên cây PROJECT

**A1 Hook tap có ABI guard TRƯỚC khi install — PASS.**
`src/SplitScreenC/SCPHomeLauncher.m:381-395` `SCPHomeLauncherInstallTapHook`:
lấy `method_getTypeEncoding` (:386), `strcmp(type,"v32@0:8@16@24")!=0` →
log `abi-unavailable` + `return` (:387-391), CHỈ SAU ĐÓ mới
`MSHookMessageEx` (:392-393). Project: cùng file:387/:392, nội dung khớp
(B6). Trích đoạn cốt lõi: `if (!type || strcmp(type, "v32@0:8@16@24") != 0)
{ … return; } MSHookMessageEx(homeVC, action, (IMP)SCPHomeTapReplacement, …)`.

**A2 Chỉ own-bundle bị consume; khác/unknown → original ĐÚNG 1 lần — PASS.**
Handler `SCPHomeTapReplacement` (:362-379): `if (IsBundle(bundle) &&
ConsumeLaunch(...)) { log consumed; return; }` — ngoài nhánh đó, lời gọi
original duy nhất toàn file là :378 `if (SCPHomeTapOriginal)
SCPHomeTapOriginal(homeVC, action, manager, iconView);`
`grep -c "SCPHomeTapOriginal(homeVC"` = **1** (các hit khác: khai báo :323,
guard install :382, out-param :393, log :395). `ConsumeLaunch` tự trả NO
sớm khi không phải own (:275). Project khẳng định lại: :378 duy nhất.

**A3 EnsureInLibrary không thêm trùng + promotion đặt changed=YES — PASS.**
`SCPHomeLauncher.m:125-168`: lookup `applicationInfoForBundleIdentifier:`
trước (:129-135); có info sẵn → KHÔNG add, chỉ `InjectInfo`, và
`changed = (!hadDeclaration && hasDeclaration)` (:141-145, project :144),
`return changed` → `Reconcile` refresh model khi `added` (:255-263:
`_handleAppLibraryRefresh` có guard respondsToSelector). Chỉ khi info=nil
mới đi đường `addApplicationProxy:withOverrideURL:` (:150-157).

**A4 SCPChosenPhoneApps chỉ lọc trong bộ nhớ — PASS.**
`src/SplitScreenC/SCPAppIcons.m:94-105`: đọc `OMCPref(@"appBridgeApps")`,
`NSMutableSet setWithArray:` (bản sao), `[ids removeObject:
SCPHomeLauncherBundleIdentifier()]` (:101), return set. Trong thân hàm:
0 điểm ghi prefs/xoá pref. Điểm ghi pref duy nhất của file là hàm riêng
`SCPHomePrefSet` (:77-82, có từ nền, không bị hàm này gọi).

**A5 SCPIsHostedApp trả NO sớm cho own-bundle — PASS.**
`src/SplitScreenA/SCPShared.m:154-159`: sau guard nil, dòng đầu tiên của
logic: `if (SCPHomeLauncherIsBundle(bundleID)) return NO;` — trước cả
`OMCFeatureEnabled`/injected/carplay check. Project: `SCPShared.m:158` cùng dòng.

**A6 Tuyến mở dùng panel sẵn có, không đường cấm — PASS.**
`ConsumeLaunch` (:274-313): `[split ahNoteActivity:AHSourceHome]` (:300;
enum tại `SCPCarSplit+AutoHide.h:42`) + `[split showLayoutPanelForApp:
split.active ? nil : [split fullscreenAppBundle]]` (:303-304). Selector
tồn tại thật: khai báo `SCPCarSplit.h:379` (SplitScreenA), định nghĩa
`SCPCarSplit+Panel.m:179` (SplitScreenB). Cấm kỵ: `grep openURL|prefs:root|
SCPSendDashboardEvent` trên SCPHomeLauncher.m/.h cả src lẫn project =
**NONE**. Event-1 toàn SplitScreen src: `grep -rn "SCPSendDashboardEvent(1"`
= đúng **2 điểm** như ytz5 — `SCPCarSplit.m:162` (mở split) và `:1811`
(`closeGoingHome:` sau `if (goHome)`).

**A7 GPT không chạm nút dock/các file cấm — PASS.**
`git diff --stat/--name-only 3e25499..050eddb0`: 14 file, +893/−3, chỉ:
Makefile, SCPAppIcons.m, SCPHomeHooks.m, SCPHomeLauncher.h/.m (mới),
SCPHooks.m, SCPShared.m, SCPHomeApply.m (bản src+project tương ứng).
`grep -Ei "SCPCarSplit\.m|AutoHide|BridgeWake|Picker|YTZ|keyboard|feed"`
trên name-only = **NONE-FORBIDDEN-NAME**.

## (B) Nguyên vẹn YTZ5

**B1 Parity method — PASS (kèm làm rõ số đo).**
Phương pháp: trích định nghĩa ObjC method bằng regex `^\s*[-+]\([^)]*\)`
trên mọi `.m` thuộc SplitScreenA/B/C + AppBridgeA/src + AppBridgeB, chuẩn
hoá selector theo keyword, đếm theo (selector × file); cây nền lấy bằng
`git archive e6b50a4 recovered-source/src` ra `/tmp/ytz5base`, chạy cùng
script hai phía. Kết quả: nền **488 distinct / 531 tổng**, cây tích hợp
**488 / 531**; only-new = **0**, only-base = **0** (selector-only: 453 = 453).
Lý do không có method cộng thêm: module GPT cộng **0 ObjC method** — toàn
bộ là C function (10 public: BundleIdentifier, IsBundle, Enabled,
IsOwnIcon, InjectInfo, EnsureInLibrary, AuditModel, Reconcile,
ConsumeLaunch, InstallTapHook) + chèn lời gọi vào thân method sẵn có.
`bwHandleKbSyncNote:`: `grep` = **0 ở CẢ HAI cây** — method này đã mất
ngay tại commit YTZ5 `e6b50a4` (so với ytz4), là mất mát duy nhất và đã
được miễn trừ tại §29.7 (`TIEP_TUC_DU_AN.md:753`: "mất đúng 1 method
bwHandleKbSyncNote: — consumer kbsync cũ bị thay có chủ đích… coordinator
đã miễn trừ tại §29.7"). Tức: so với e6b50a4 không mất thêm method nào;
không có mất mát nào ngoài diện miễn trừ. Đọc chặt chữ đề bài ("mất đúng
1 so với e6b50a4") thì số đo là 0 — chênh lệch này là do mốc miễn trừ nằm
ở ytz4→ytz5, không phải do vòng ghép này.

**B2 Discriminator trên cây PROJECT (bản build) — PASS, đủ 11/11.**
Đếm `grep -n` trong `project/`: kbstate — ABInApp.m 8 hit (kênh :555
`com.anlai.omnicar/bridgewake.v1.kbstate`) + SCPCarSplit+BridgeWake.m 11
hit (:115); `ahCloseCleanup` SCPCarSplit.m:1769 (lời gọi) + `noteCloseSource`
8 hit (định nghĩa :1743); `SCPLogInjectedIconState` SCPHomeApply.m 3 hit
(định nghĩa :343) + `SCPHomeLauncherAuditModel` :346; `hasContent`
SCPCarSplit+Picker.m 3 hit (:162); `ABNativeKeyboardEnabled`
ABHostBMethods.m 2 hit (định nghĩa :64); `blind` SCPCarApps.m 2 hit
(`blind=1` :131); `SCPHomeLauncherEnsureInLibrary` SCPHomeLauncher.m 2 hit
(định nghĩa :125); `SCPHomeLauncherConsumeLaunch` 2 hit (định nghĩa :274).

**B3 Knob — PASS (kèm ghi chú vị trí file).**
`publishKnobsNow` KHÔNG nằm trong `SCPCarSplit+Layout.m` (grep = 0) —
định nghĩa thật ở `src/SplitScreenA/SCPCarSplit.m:2766-2795`. Trên đường
đó, phép đảo cực duy nhất: `BOOL scaled =
!CGAffineTransformIsIdentity(knob.transform);` (:2782), comment :2778-2780
ghi đúng bản binary: `eor w2, w27, #1` trên kết quả IsIdentity, nuôi thẳng
`numberWithBool:` — không negation thứ hai. Đếm theo pattern vòng
verify-ytz5 (eor trên IsIdentity trong publishKnobsNow) = **đúng 1**.
Project khẳng định lại: SCPCarSplit.m:2778/:2782 y hệt.

**B4 ENFORCE vẫn khoá mặc định — PASS.**
BridgeWake (src): `bwWakeMode = BWModeDryRun` (:51); reader :745
`w ? clamp : BWModeDryRun`. ABInApp: `BWWakeMode = BWModeDryRun` (:132),
`BWEffectiveWakeMode` chưa biết gói → DRY_RUN (:251). Điểm nuốt duy nhất:
ABInApp.m:921 `if (BWSeqWouldSwallow && BWEffectiveWakeMode() ==
BWModeEnforce) { BWBeginSwallow… }` — `grep -c` mẫu so sánh Enforce = **1**
(cả src lẫn project).

**B5 Pinch vắng pref = OFF + marker migration còn — PASS.**
BridgeWake: `bwPinchMode = BWModeOff` (:52); reader :746 `p ? clamp :
BWModeOff`; migration :731-744 — marker `bridgewake.pinchOffMigratedYtz5`
vắng thì ghi pinchMode=0 một lần + đặt marker. Project: marker tại
:60/:731/:740, cùng reader.

**B6 src ↔ project — PASS.**
Kiểm độc lập đủ **20 file** thuộc hai vòng (ABHostBMethods.m,
ABHostGeometry.m, ABInApp.m, BWInputStore.h, SCPAppIcons.m, SCPCarApps.m,
SCPCarSplit+AutoHide.h/.m, SCPCarSplit+BridgeWake.h/.m,
SCPCarSplit+Picker.m, SCPCarSplit.h, SCPCarSplit.m, SCPHomeApply.h/.m,
SCPHomeHooks.m, SCPHomeLauncher.h/.m, SCPHooks.m, SCPShared.m): diff sau
khi loại dòng `#import/#include` = **0 cho cả 20/20**. 5 file mẫu đọc diff
thô trực tiếp: SCPCarSplit.m (1 dòng import :30), SCPCarSplit+BridgeWake.m
(1 dòng :22), SCPHomeApply.m (1 dòng :20), SCPHooks.m (1 dòng :22) — đều
chỉ khác đường dẫn import phẳng; ABInApp.m diff thô = **0** (identical).
SCPHomeLauncher.m raw diff = 8 dòng, toàn bộ là import.

## (C) git diff --check — PASS (sạch)

`git diff --check cbdaeab..HEAD` → exit **0**, không output.
`git diff --check cbdaeab` (worktree) → exit **0**. Worktree chỉ có 1 file
untracked có sẵn từ trước (`handover/THAM_VAN_DUOFACE_LOGO_YOUTUBE_ZOOM.md`),
không thuộc diff.

## (D) Phát hiện ngoài danh mục — PASS, không có vấn đề

- **Duplicate symbol: không.** Trong cây project `OmniCarSplitScreen`,
  mỗi public symbol của SCPHomeLauncher (10 symbol ở B1) chỉ có **1 file
  định nghĩa** (SCPHomeLauncher.m); các file khác (SCPAppIcons/SCPHooks/
  SCPShared/SCPHomeApply/SCPHomeHooks) chỉ là điểm gọi. Mọi helper static
  (`HLog`, `BundleOf`, `Inspect`, `OwnID`, `OwnTag`, `SetDeclBool`,
  `InstalledOwnProxy`, `SCPHomeTap*`) — `grep -l` trên toàn bộ `.m` của
  SplitScreen + AppBridge project: chỉ xuất hiện trong SCPHomeLauncher.m.
  Tên generic (`HLog`/`Inspect`/`BundleOf`) là `static` nên không thể
  trùng liên kết dù nơi khác có tên giống. Module định nghĩa **0 ObjC
  method** → không thể trùng selector định nghĩa với
  `OmniCarSplitScreen_FILES`; Makefile: 38 file, 38 unique, 0 trùng,
  SCPHomeLauncher.m có mặt đúng 1 lần.
- **Selector không guard mới: không thấy.** Mọi selector động trong
  SCPHomeLauncher.m đều có chốt: `respondsToSelector` ×9
  (applicationProxyForIdentifier:/isValid qua SetDeclBool/setter checks/
  lookup/add/_handleAppLibraryRefresh), getter qua `SCPHomeTypedGetter`
  tự kiểm encoding `"@16@0:8"` trước khi gọi (:329-330), và hook tap kiểm
  encoding `"v32@0:8@16@24"` (A1). Không selector lạ nào được gọi trần.

## KẾT LUẬN: **SHIP** (cho build FAT — ở cổng tĩnh)

Lý do từng tiêu chí cứng: parity — không mất method nào ngoài diện miễn
trừ §29.7 đã chốt từ vòng YTZ5, GPT cộng 0 ObjC method (B1); knob — đúng
1 eor/đảo cực trên publishKnobsNow (B3); mặc định an toàn — ENFORCE khoá
DRY_RUN hai phía + điểm nuốt duy nhất khi Enforce (B4), pinch vắng pref
= OFF + migration còn nguyên (B5); tuyến Home mới — chỉ own-bundle bị
consume, original forward đúng 1 lần, ABI guard trước hook, không
openURL/prefs:root/event-1 mới (A1/A2/A6); GPT không chạm file cấm (A7);
src ↔ project lệch 0 ngoài import trên 20/20 file nên bản build mang đúng
bản đã kiểm (B6); diff --check sạch (C); không trùng symbol/selector
không guard (D).
Giới hạn của verdict: đây là kiểm TĨNH — hành vi runtime của Home
launcher trên xe (hiện icon, tap thật) vẫn PENDING-DEVICE như chính
module ghi nhận, phải chờ test xe gộp một lần mới kết luận được.
