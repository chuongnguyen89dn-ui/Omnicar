# TÍCH HỢP YTZ5 + GPT HOME LAUNCHER (ytz5hl1) — biên bản coordinator, 2026-11-09

## Khung
- Nền main khi ghép: `cbdaeab` (docs GPT trên nền records `3e25499`; source YTZ5 = `e6b50a4`).
- Phía GPT: nhánh `feature/omnicar-home-launcher`, 5 commit source (81e4b23, c4641f7, 14404b2, 1479711, tip `050eddb0`) trên đúng nền `3e25499`, 14 đường dẫn +893/−3. Hồ sơ bàn giao: `recovered-source/gpt-project-history/HOME_LAUNCHER_HANDOVER.md`.
- Nhánh tích hợp: `integrate/ytz5-home-launcher`.

## Bước 1 — Ghép: merge `c74c878`, 0 XUNG ĐỘT
- `git merge --no-ff origin/feature/omnicar-home-launcher` vào nhánh từ `cbdaeab`: tự khớp toàn bộ 14 đường dẫn, **không một hunk xung đột nào** — vì GPT làm trên đúng nền `3e25499` đã chứa các điểm của Muse, và main sau đó chỉ cộng docs.
- Điểm nóng đã kiểm tay sau merge (src): SCPHooks.m chứa đồng thời `noteCloseSource` ×5 (B5) và SCPHomeLauncher ×11 (GPT); SCPHomeApply.m giữ nguyên thân I5, lời gọi `SCPHomeLauncherAuditModel(...)` của GPT tại entry của `SCPLogInjectedIconState` (dòng 346); SCPAppIcons.m có lọc own-bundle của GPT trên nền ytz5.

## Bước 2 — Đo hai cây: cảnh báo §4 của GPT ĐÚNG; đã stage lại (commit `74635d1`)
Số đo thật trước staging (cây tích hợp):
- src SCPHomeApply.m = 543 dòng (YTZ5 539 + GPT +4); **project SCPHomeApply.m = 332 dòng, `SCPLogInjectedIconState` = 0** — bản tiền-YTZ5.
- Quét discriminator trên project: **toàn bộ YTZ5 vắng mặt** — kbstate=0 (ABInApp/BridgeWake), ABNativeKeyboardEnabled=0, bwHandleKbStateNote=0, ahCloseCleanup=0, noteCloseSource=0, hasContent=0 (Picker), blind=0 (SCPCarApps); BWInputStore.h và SCPHomeApply.h **không tồn tại** trong project/OmniCarSplitScreen. (Đối chứng: cây `~/workspace/omnicar-re/project` đã có đủ YTZ5 — phần staging vòng ytz5 chỉ diễn ra ở đó, không quay về push9; CI build từ push9 project nên bắt buộc sửa tại đây.)
- Các file project do GPT tự cung cấp (SCPHooks/SCPShared/SCPAppIcons/SCPHomeHooks/SCPHomeLauncher) có nội dung GPT nhưng SCPHooks project vẫn thiếu điểm B5 (noteCloseSource=0) vì GPT dựng bản project từ project cũ.
Xử lý: stage lại **20 file thuộc hai vòng** từ src đã ghép sang project (cả push9 lẫn omnicar-re) bằng đúng phép làm phẳng import đã dùng các vòng trước (`#import "../<Dir>/X"` → `#import "X"`), giữ nguyên dòng ghi chú lịch sử `[phase3 sync]` tại SCPHomeApply.m. Kết quả kiểm sau staging:
- diff src↔project của 20/20 file: **chỉ dòng import** (non-import diff = 0, kiểm độc lập lại ở Bước 3).
- File project do GPT cung cấp khớp byte-for-byte với bản stage (SCPShared/SCPAppIcons/SCPHomeHooks/SCPHomeLauncher không đổi nội dung khi stage).
- Hai cây src byte-identical (diff -rq sạch); Makefile SplitScreen phía omnicar-re cộng SCPHomeLauncher.m (chỉ lệch đúng dòng FILES so với push9).
- Discriminator trên project sau staging: đủ (kbstate ABInApp=8/BridgeWake=11, ABNativeKeyboardEnabled=2, bwHandleKbStateNote=5, pinchOffMigratedYtz5=3, kbunknown=3, ahCloseCleanup=1, noteCloseSource SCPCarSplit=8/SCPHooks=5, SCPLogInjectedIconState=3, SCPHomeLauncherAuditModel=1, hasContent=3, blind=2, EnsureInLibrary=2).
- Quét toàn module ngoài union: mọi file còn lại diff=0 giữa src và project; hai file project-only (SCPCarSplit+Relayout.m, SCPIntegrationShims.h) giữ nguyên.

## Bước 3 — Kiểm tĩnh độc lập (verify-ytz5hl.md): SHIP cho build FAT
- (A) Khẳng định GPT PASS 7/7, khẳng định lại trên cây project: guard ABI `strcmp(type,"v32@0:8@16@24")` SCPHomeLauncher.m:387-391 trước hook :392; original đúng 1 call site (:378); đăng ký library lookup-trước + `changed = (!hadDeclaration && hasDeclaration)` :144; SCPChosenPhoneApps chỉ lọc trong bộ nhớ (0 điểm ghi pref); SCPIsHostedApp trả NO sớm (SCPShared.m:158); tuyến mở gọi ahNoteActivity:AHSourceHome (:300) + showLayoutPanelForApp: (:303), 0 openURL/prefs:root, SCPSendDashboardEvent(1) toàn src vẫn đúng 2 điểm; diff phía GPT không chạm SCPCarSplit.m/AutoHide/BridgeWake/Picker/YTZ.
- (B) Nguyên vẹn YTZ5: parity method so với e6b50a4 = **0 mất / 0 lạ** (488 distinct cả hai phía; GPT chỉ cộng C function, 0 ObjC method; `bwHandleKbSyncNote:` đã vắng ngay tại e6b50a4 — miễn trừ §29.7 thuộc mốc ytz4→ytz5, vòng ghép không mất thêm); discriminator project 11/11; knob đúng 1 đảo cực (SCPCarSplit.m:2782, `!CGAffineTransformIsIdentity`); ENFORCE khoá mặc định hai phía, điểm nuốt duy nhất khi ==Enforce; pinch vắng pref = OFF + marker migration còn; 20/20 file non-import diff = 0.
- (C) `git diff --check` sạch. (D) Không duplicate symbol (Makefile 38 file/38 unique), không selector thiếu guard mới.

## Sự cố build cục bộ + fix tích hợp (commit `8a2c7aa`)
- Build module SplitScreen lần đầu FAIL duy nhất tại SCPHomeLauncher.m: header SCPShared.h:67/:79 xung đột nullability `-Werror`. Nguyên nhân (đọc từ source): SCPHomeLauncher.m là TU đầu tiên include cả SCPHomeCommon.h lẫn SCPShared.h; hai header khai trùng hai hàm với nullability ngược nhau — `SCPAppHasCarPlayUI`: SCPHomeCommon.h:38 ngầm _Nonnull (trong vùng NS_ASSUME) vs SCPShared.h:67 `_Nullable`; `SCPIsInjectedPhoneApp`: SCPHomeCommon.h:45 `_Nullable` vs SCPShared.h:79 ngầm _Nonnull.
- Fix tối thiểu, chỉ annotation, không đổi runtime: chuẩn cả hai về `_Nullable` (khớp định nghĩa thật: SCPShared.m:265 nil-tolerant; SCPAppIcons.m:108 `_Nullable`) tại SCPShared.h:79 và SCPHomeCommon.h:38, cộng comment ghi lý do; áp cho cả hai cây src/project. Sau fix: build sạch.

## Build cục bộ (trước CI)
- Toolchain: lại bị rollback (mất ldid + symlink ld.lld) → `~/bin/fix-toolchain.sh` foreground, smoke test đạt.
- Module OmniCarSplitScreen: build sạch; nm trên dylib: **14 symbol SCPHomeLauncher**, gồm `_SCPHomeLauncherEnsureInLibrary`, `_SCPHomeLauncherConsumeLaunch`, `_SCPHomeLauncherInstallTapHook` (positive control SCPCarSplit = 642 hit); chuỗi `home-launch` có mặt.
- Module OmniCarAppBridge: build sạch. Aggregate `make package FINALPACKAGE=1`: ra candidate `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` 1.041.356 B (bản cục bộ arm64, chỉ để kiểm biên dịch — không phải bản giao).

## Bước 4 — CI FAT: run 42622552103 SUCCESS (xác minh foreground qua jobs API)
- Đẩy nhánh integrate lên origin; merge vào ci-fat-test = `b8deff2` (sạch, 0 xung đột; workflow giữ nguyên). HEAD tích hợp phía source: tip nhánh integrate `8a2c7aa` (= cbdaeab → merge c74c878 → staging 74635d1 → nullability 8a2c7aa).
- Push ci-fat-test tự kích hoạt run 42622551174 — coordinator **cancel** run này để giữ một run chuẩn duy nhất; run dispatch thủ công **42622552103** (workflow 410962367, ref ci-fat-test): completed **success** — các step Build the package (arm64 + arm64e) / Verify FAT slices / Upload the FAT deb đều success (đọc trực tiếp từ jobs API, không qua poll nền).
- Artifact: `com.anlai.omnicar_1.0.3-rebuilt-ytz5hl1-fat_iphoneos-arm64.deb` tại `~/workspace/omnicar-re/handover/` — **1.245.714 B, SHA-256 `e28883b97c68ce0d0d0341499a6c33a0d2b1d9b2f32ef0f2d308595178cad594`**; members: debian-binary + control.tar.gz + data.tar.lzma (khớp các bản FAT trước).
- Kiểm binary hai lát (arm64 = arm64e trên mọi probe): OmniCarSplitScreen.dylib + OmniCarAppBridge.dylib đều FAT arm64+arm64e. SplitScreen mỗi lát: SCPHomeLauncher 10 chuỗi + symbol export `_SCPHomeLauncherEnsureInLibrary`, `_SCPLogInjectedIconState` (T); selector `bwHandleKbStateNote:` có ×1, `bwHandleKbSyncNote:` = 0 (miễn trừ §29.7 hiện hình đúng trên binary), `ahCloseCleanup` ×1, `noteCloseSource:` ×1, `showLayoutPanelForApp:` ×1, `pinchOffMigratedYtz5` ×1, chuỗi kênh `bridgewake.v1.kbstate` ×1, `home-launch` ×1, `iconstate` ×3. AppBridge mỗi lát: `appBridgeNativeKeyboard` ×1, `bridgewake.v1.kbstate` ×1, `drawnKeyboard` ×1, `ABKbSyncNoteEvent` ×1.
- Knob: vòng này không đổi SCPCarSplit.m ở đường knob (cả hai phía đều không chạm); kiểm tĩnh B3 xác nhận đúng 1 đảo cực tại source (SCPCarSplit.m:2782) — phép đếm eor trên binary đã thực hiện ở vòng ytz5 trên cùng đoạn code không đổi.

## Trạng thái cuối vòng
- Source-complete / static PASS (SHIP) / local-build PASS / CI FAT PASS. **PENDING-DEVICE nguyên vẹn**: icon OmniCar hiện + chạm mở panel trên xe; phím hosted native hiện/gõ/đóng; chuỗi kbstate trên xe; vòng đời AutoHide sau sửa; picker nhìn xuyên + ô trống vẫn đặc; A/B icon tầng model/dock. Nghiệm thu xe theo kịch bản 6 bước của GPT + phép thử Home launcher trong hồ sơ bàn giao.
