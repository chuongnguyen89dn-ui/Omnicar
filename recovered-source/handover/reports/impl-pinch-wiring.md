# Nối pinch luôn + gỡ staging — biên bản cài đặt

Ngày: 2026-11-09. Lệnh gốc: Nguyen 14:36–14:37 — "Bỏ staging, nối pinch
luôn" (chọn phương án 3; trước đó: "Mắc j nó phải qua công tắc? Mày tạo
thêm vào j cho bẩn và rối cài đặt?"). Hệ quả thực thi: không còn công tắc
test nào ở bất kỳ đâu; pinch là tính năng sống mặc định; YT-Zoom cũng bật
mặc định. Mức báo cáo: source complete / build PASS / static PASS — chưa
có bằng chứng xe.

## 0. Dọn dẹp strand công tắc bị huỷ giữa chừng

Strand sửa công tắc vào code trang Cài đặt ĐÃ land trước khi bị huỷ
(biên bản impl-prefs-switch-fix.md). Đã kiểm và **gỡ sạch**:

- `OMCSplitScreenController.m` (cả hai cây): diff so với bản gốc trong
  push9-clone cho thấy đúng 5 chỗ cộng của strand đó (comment đầu file,
  `return 6` → `return 8` ở `numberOfSectionsInTableView:`, case 6/7 ở
  `numberOfRowsInSection:`, header/footer section 6/7, nhánh cell
  section 6/7 chứa `fullscreenTestExpand`/`youtubeVirtualize`). Đã khôi
  phục nguyên văn từ bản gốc push9; `grep` hai khoá trong file = 0,
  hai cây `cmp` identical, header `.h` vốn không đổi.
- File `impl-prefs-switch-fix.md` giữ nguyên như hồ sơ lịch sử của một
  việc đã bị Nguyen bãi bỏ; nó KHÔNG còn mô tả trạng thái code hiện tại.

## 1. Pinch sống mặc định (module SplitScreen)

### 1.1 Owner — `SCPCarSplit+BridgeWake.m`

- **Mode**: `bwReloadModesAndRepublish` — `bridgewake.pinchMode` VẮNG →
  `BWModeEnforce` (dòng 390); static init `bwPinchMode` cũng đổi sang
  `BWModeEnforce` (dòng 41) để trạng thái tiền-nạp khớp. Pref tường minh
  vẫn thắng (kẹp 0–2): ai đặt 0/1 vẫn tắt/dry-run được. **Wake mode
  không đụng**: `bridgewake.wakeMode` vắng → `BWModeDryRun` (dòng 389),
  nguyên văn.
- **Allowlist pref** (`bwPinchAllowedForPane:`, phân xử cho cờ
  `pinchAllowed` trong gói state): pref vắng/không-phải-array →
  `bwPinchAllowlist = nil` (dòng 401) và mắt cuối của hàm trả
  `bwPinchAllowlist ? containsObject : YES` (dòng 240) — mọi pane đủ
  điều kiện đều qua; pref có mặt (kể cả mảng rỗng) thì membership quyết
  định như cũ. Log modes in `allowlist=all` khi nil để log không mơ hồ.

### 1.2 Cổng 5 của pinch controller — `SCPPinchController.m/.h`

§A4 có HAI bề mặt allowlist: pref của owner (mục 1.1, cho cờ gói state)
và danh sách (bundle, scene) trong bộ nhớ của chính controller (cổng 5
của điểm bắn, `allowBundle:hosted:` — **không có caller nào trong toàn
module**, impl-pinch §5.5 chủ đích để rỗng chờ nghiệm thu từng app).
Giữ nguyên cổng này thì đường pinch vẫn chết ở `not-allowlisted` dù
mode đã ENFORCE — mâu thuẫn trực tiếp với lệnh nối pinch. Đã sửa đúng
một mắt, theo cùng ngữ nghĩa như pref:

- `isAllowlistedBundle:hosted:` (dòng 488): danh sách RỖNG → YES (không
  hạn chế); danh sách có phần tử → membership quyết định.
  `allowBundle:hosted:` vẫn là đường thu hẹp lại theo từng app+scene.
- Các comment §A4 ở `.m` (init, pragma Allowlist, cổng 5) và `.h`
  (khối Allowlist, property adapter) đã viết lại cho khớp; comment cổng
  2 tồn dư thời A1-BLOCKED ("adapter rỗng… ENFORCE không bao giờ bắn")
  cũng được thay bằng mô tả đúng thời fs1 — đây là comment tích hợp
  vòng fs1 đã ghi nhận là tồn dư, nay nằm ngay trên đường vừa nối nên
  sửa luôn, code không đổi ở mắt đó.

### 1.3 Truy vết tĩnh toàn đường (cấu hình mặc định: không pref nào đặt)

| Mắt | File:line | SPLIT+VISIBLE | SPLIT+HIDDEN |
|---|---|---|---|
| Recognizer gắn container | `SCPCarSplit.m:345` (attachIfNeeded ở ensureContainer) + `SCPPinchController.m:260` (cross → fire point) | cặp hình thành khi 2 ngón cùng pane; ngưỡng out ≥ 1.10 / in ≤ 0.90, drift ≤ 0.6·Δdist + 10 (`.m:256–258`) | như cột trái |
| Tracking sống | `SCPPinchController.m:183,464` `scpTrackingEnabled` = armed ∧ mode ≠ OFF | mode = ENFORCE (mặc định mới) → sống | sống (nhận dạng vẫn chạy; chết ở cổng 3) |
| Cổng 1 mode | `.m:593` qua `scpCurrentMode` `.m:457` → arbiter `pinchMode` `SCPCarSplit+BridgeWake.m:630` → `bwPinchMode` | ENFORCE → qua | qua (mode không phân biệt state) |
| Cổng 2 hướng/state | `.m:601–604`: adapter.currentState (`SCPFullscreenAdapter.m:46` → `fsCommittedState` `SCPFullscreenController.m:120`) | Split ∧ pinch-out → qua; Expanded ∧ pinch-in → qua | Split ∧ pinch-out → qua (state FS vẫn Split — HIDDEN là state của wake, không phải của FS) |
| Cổng 3 phân xử | `.m:606–610` → `pinchDispositionForPane:` `BridgeWake.m:653` | `BWStateVisible` → `SCPArbiterPinchAllowed` (trừ popup/resizing → BlockedUnknown, fail-open) | `BWStateHidden` → `SCPArbiterPinchBlockedHidden` → **CHẾT, lý do `hidden` — wake thắng** |
| Cổng 4 chuỗi sạch | `.m:612`: `externalChainSuppressed` (glue `BWPublishChainSuppressed`, BridgeWake.m) | không giao dịch WAKING nào mở → qua | qua khi không có wake đang giữ chuỗi |
| Cổng 5 allowlist | `.m:615` → `isAllowlistedBundle:` `.m:488` | danh sách rỗng → YES (mục 1.2) | không tới được (đã chết ở cổng 3) |
| Tái kiểm phiên | `.m:619–621`: split.active ∧ container có window ∧ pane còn assigned | qua | — |
| Điểm bắn | `.m:636` `mode == Enforce && wouldPinch` → đúng MỘT lệnh: out → `adapter requestExpand…` `.m:639`, in → `requestRestore…` `.m:644` | **BẮN** | không bắn |
| Adapter → controller | `SCPFullscreenAdapter.m:51/56` (provenance `@"pinch"`) → `fsRequestExpand…` `SCPFullscreenController.m:216` / `fsRequestRestore…` `:336` | vào máy FS (cổng vào §4.4/§4.5 của controller tự quyết) | — |
| Cờ gói state (bề mặt app) | `bwPinchAllowedForPane:` `BridgeWake.m:226`, mắt VISIBLE `:235`, mắt allowlist `:240` | `pinchAllowed = 1` | state ≠ VISIBLE → trả NO từ `:235` (trừ hàng EXPANDED `:231` — pinch-in luôn mở) |

Luật an toàn giữ nguyên, không mắt nào bị nới: SPLIT+HIDDEN pinch bị
chặn ở cổng 3 VÀ cờ gói = 0; EXPANDED → pinch-in mở ở cả disposition
(hàng đầu) lẫn cờ gói; keyboard/popup/transitioning → fail-open
(popup/resizing ở disposition + `bwPopupForPane:`; WAKING/UNKNOWN/
INACTIVE → BlockedUnknown); một lệnh mỗi cử chỉ (điểm bắn duy nhất +
máy cặp của recognizer); **pinch không reset timer wake** — đường bắn
không gọi `setBarVisible:`, không đụng timer nào của wake (chỉ báo
settle qua `bwSetExpandedActive:` như thiết kế fs1); wake không phát
lệnh pinch (§2.3 isolation trong `bwHandleWakePacket:` nguyên vẹn).

Điểm diễn giải giữ lại có chủ đích: `scpCurrentMode` khi arbiter == nil
vẫn trả DRY_RUN (failsafe "owner chưa cài thì chỉ probe") — arbiter do
`bwInstallOwner` gán ở `__init_1` nên trên tiến trình sống mắt này
không quyết định; mặc định tính năng do owner quyết, đúng một chủ.

## 2. Gỡ nhánh [fs1-test] — `SCPFullscreenController.m/.h`

- Xoá: hai ivar (`_prefsToken`, `_testSwitchLast`); observer
  `notify_register_dispatch` trên SCPNotePrefsChanged trong
  `fsInstallIfNeeded` (nay chỉ còn đặt cờ + 1 dòng log `[fs1]`);
  hai method `fsTestSwitchOn` / `fsTestPrefsChanged` (đường lệnh test
  duy nhất ngoài adapter); `#import <notify.h>` (hết người dùng);
  mọi log `[fs1-test]`.
- Controller từ nay CHỈ nhận lệnh qua adapter (provenance `pinch`) và
  các đường nội bộ (teardown/reconcile). Không hằng/logic test nào
  thành dead code sót lại: `OMCPref` hết được dùng trong file (import
  SCPCommon.h giữ cho OMCLogWrite), provenance `"test"` không còn
  producer nào (doc ở `.h` đã sửa thành `"pinch" / "teardown"`).
- QUYẾT ĐỊNH về marker: xoá hẳn `[fs1-test]`, KHÔNG đổi tên — mọi log
  của controller vốn đã mang tiền tố `[fs1]` ở từng dòng; thêm marker
  riêng cho nhánh đã chết chỉ gây nhiễu grep nghiệm thu.

## 3. YTZ mặc định BẬT — `ABYTZoom.m`

- `YZPrefEnabled()` (dòng ~104): `OMCPref(ABYTPrefVirtualize, @NO)` →
  `@YES`, comment viết lại: vắng = BẬT; khoá `youtubeVirtualize` chỉ
  còn là kill-switch khi đặt NO tường minh. Không logic lease nào khác
  đổi (grant/revoke/heartbeat/ack nguyên văn). Đây là điểm đọc pref
  DUY NHẤT của tính năng (grep toàn project: ngoài `ABYTZoom.m` không
  còn tham chiếu nào trong code — comment ở `ABChannels.m:710` đã diễn
  đạt lại để không nêu tên khoá).

## 4. Dọn Prefs về nguyên trạng

- `FeatureSplitScreen.plist`: khôi phục từ bản sao lưu gốc của vòng
  prefs (`/tmp/fs1-prefs-backup/`, đã đối chiếu: đúng 2 items
  [group, splitScreenEnabled]) — gỡ cả 4 item FS lẫn 2 item YTZ;
  round-trip plistlib: 2 items, magic bplist00 giữ nguyên (file là bản
  gốc từng byte).
- `SplitScreen.strings` en + vi: khôi phục từ cùng bản sao lưu — 46
  khoá/file; 6 khoá đã thêm (SPLITSCREEN_FS_TEST_* ×3,
  SPLITSCREEN_YTZ_TEST_* ×3) gỡ hết; đã kiểm 46 khoá chung identical
  từng giá trị với bản hiện tại trước khi ghi đè (chỉ cộng, không sửa
  khoá gốc nào).

## 5. Cổng đã chạy (đo trên bản cuối, cả hai cây project/ + src/)

- **Mirror**: 7 file code đã sửa (BridgeWake, PinchController .m/.h,
  FullscreenController .m/.h, ABYTZoom, ABChannels) + controller Prefs
  khôi phục: `cmp` identical từng cặp project ↔ src.
- **Build từ sạch** (`make clean && make`, THEOS=~/theos, umask 022;
  toolchain đã verify clang-18/ldid/ld.lld-18):
  OmniCarSplitScreen exit 0; OmniCarAppBridge exit 0 (dylib 619.392 B;
  warnings chỉ ở ABHostLaunch/ABHostBMethods — warning cũ, file đã sửa
  không sinh warning nào); OmniCarPrefs exit 0, 0 lỗi.
- **Grep**: `fullscreenTestExpand` = 0 (code + plist + strings, hai
  cây); `youtubeVirtualize` chỉ còn trong ABYTZoom.m (điểm đọc pref —
  đúng luật giữ); `[fs1-test]` = 0 trong SplitScreen hai cây; binary
  Prefs: 0 lần xuất hiện của cả hai khoá + `[fs1-test]`; dylib
  SplitScreen: `[fs1-test]` = 0, dòng log cài đặt mới có mặt; dylib
  AppBridge: `youtubeVirtualize` ×1 (điểm đọc).
- **Harness BridgeWake**: header không bị vòng này đụng (3 bản
  cmp-identical); harness C độc lập (BW_PACK_NO_FOUNDATION) chạy lại
  trên header của cả SplitScreen và AppBridge: **15/15 PASS** (hash
  FNV ×2, V1–V7 pack khớp hex, V8 invalid, V9/V10 pack + round-trip,
  BWTypeAct == 5). Đổi giá trị mode mặc định không đổi layout gói.

## Còn mở (ngoài phạm vi, không tự xử)

- Nghiệm thu xe cho pinch sống (lần đầu pinch bắn thật trên xe) và
  YT-Zoom mặc định bật — thuộc phiên đo của Nguyen/GPT.
- Đóng gói lại (candidate/CI FAT) chứa thay đổi này: chưa làm ở vòng
  này — bản fs1 đã giao KHÔNG có các thay đổi trên (nó vẫn cần công
  tắc test cho FS và pinch vẫn DRY_RUN).
