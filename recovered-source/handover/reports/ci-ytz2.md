# CI FAT — ytz2 (vòng sửa WO GPT sau fs1: act/renew/arbiter/diag/isSplit/probe)

Ngày: 2026-11-09. Loại việc: đồng bộ mirror + git + kích hoạt CI + kiểm chứng
FAT trên lát thin trích từ chính FAT. Nguồn: main `a763030` (ytz2 source),
ci-fat-test `5c5698f` (merge main).

## 0. Đồng bộ src/ + audit cmp 5 strand

Audit cmp toàn bộ 14 cặp file của 5 strand (fix-w-act-app, fix-wp-owner,
fix-p-diag, fix-y-issplit, fix-w-probe) giữa `project/` và mirror `src/`
(AppBridgeB / SplitScreenA / Prefs/OMCPrefs): **14/14 identical tại thời điểm
audit** — gồm cả 2 file strand D (`SCPCarSplit.m`, `ABYTZoom.m`) mà strand D
chỉ sửa ở cây project/ (bước tích hợp song song đã chép sang src/ trước đó).
Đã kiểm nội dung bản src/: `SCPCarSplit.m` chứa `info[@"split"]` /
`info[@"splitver"]` tại :2082–2083; `ABYTZoom.m` chứa kho session split +
`isSplit-fallback`, `panes.count` còn đúng 1 chỗ (:199, nhánh fallback).
Không cần chép thêm file nào. Strings Prefs (Resources, chỉ ở project/)
46 → 56 khoá theo fix-p-diag.

Git: rsync project/+src/ → push9-clone/recovered-source (loại packages/
.theos/*.deb/*.o), commit + push main = **`a7630303fbd9a1af705fbf880093185401c46dc0`**
(27 file). Ghi chú thao tác: clone đang checkout ở ci-fat-test nên commit
đầu (d3f091b) rơi vào nhánh đó; đã cherry-pick sang main (a763030) và dựng
lại ci-fat-test = merge main (**`5c5698f04f7b2e7721c1f1abfef36e97d8b533be`**),
push cả hai; `git diff origin/main origin/ci-fat-test -- project src` = 0
dòng, `splitver` có trong cây main đã push.

## 1. CI run

- Workflow `build-fat-macos.yml` (id 410962367), ref `ci-fat-test`,
  dispatch `gh workflow run 410962367 --ref ci-fat-test`.
- **Run id: 42583754018** (workflow_dispatch, headSha `5c5698f`) — theo dõi
  foreground bằng `gh run watch --exit-status` + truy vấn trực tiếp
  `gh run view`: status `completed`, conclusion **`success`**.
- URL: https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42583754018
- (Run 42583740997 do push kích hoạt, cùng headSha, chạy song song — không
  dùng; artifact lấy từ run dispatch.)
- Artifact: `omnicar-fat-deb`.

## 2. FAT

- Tên tại handover: `com.anlai.omnicar_1.0.3-rebuilt-ytz2-fat_iphoneos-arm64.deb`
- Kích thước: **1.221.708 B**. SHA-256:
  **`bb59ab5653540f21d915631213621c0158fc2850038f6d0959b3eca95087dc20`**
  (đo trên bản ở handover).
- ar members: `debian-binary` + `control.tar.gz` + `data.tar.lzma`. Control:
  Package `com.anlai.omnicar`, Version `1.0.3`, Architecture `iphoneos-arm64`.
- Lát thin: SplitScreen arm64 568.288 B / arm64e 584.912 B; AppBridge
  arm64 306.784 B / arm64e 306.784 B.

## 3. UUID hai lát (LC_UUID trên lát thin)

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 6455576C-45AB-3B1B-AABD-2D33D8EDA197 | 065A3258-4FFA-3768-9CD2-D33D7CB3AF93 |
| OmniCarAppBridge | 9B1C0F15-2E14-3D8A-9FF3-C4BC30630DA8 | 78BB268F-9ED5-3131-8B20-9A7B0A682350 |
| OmniCarCarProbe | 711616F5-BC48-3E8D-B7DD-08133716E35D | 12F9A8CA-0A3A-3437-A642-07CB1DFD6C49 |
| OmniCarCore | A2F474A6-3F8C-3DFE-9275-830CC446868A | 34B97B5E-344B-3E3B-BCD2-78F595242070 |
| OmniCarPrefs | DEB493EB-BB90-3CF6-B57C-1F438158BF62 | 30DCADE4-C716-3B65-A3EF-419B7470824B |
| OmniCarSpeedBubble | 90A991E2-F906-3E43-ABF2-8D4E79ACA3F7 | 9FDBA3A3-4900-3981-8DEC-3B2B2D4D3AC6 |
| OmniCarSplitScreen | 724DC492-CD5E-3F26-B3F3-E8AED501AE24 | 1C547C9D-9CBF-3D8B-A3F6-4CFE245AE013 |
| OmniCarStartupScreen | 1577E7F3-07E4-3B8C-ABC6-15A96006FC99 | 11D17B77-28C3-3BA4-9088-22FC0D149382 |

(Phương pháp trích lát đã đối chiếu chéo với llvm-lipo-18: cả hai lát cùng
cputype 0x0100000C, arm64 = subtype 0, arm64e = subtype 0x80000002; bảng
UUID của ytz1/fs1 tái lập đúng 16/16 trước khi đo ytz2.)

## 4. Kiểm hai lát (đo trên lát thin trích từ chính FAT này)

### 4.1 Kênh bridgewake + ytlease

`com.anlai.omnicar/bridgewake.v1.{state,query,wake,ack,act}`: mỗi chuỗi ×1
trong SplitScreen + AppBridge, cả hai lát (5/5 × 4 vị trí) — khớp fs1/ytz1.
`appbridge.ytlease` + `appbridge.ytleaseack`: có trong AppBridge cả hai lát
(×1 mỗi kênh); SplitScreen = 0 — phân bổ như ytz1.

### 4.2 Chuỗi MỚI của vòng WO — có mặt đúng vị trí, cả hai lát

| Chuỗi | SplitScreen | AppBridge | Prefs |
|---|---|---|---|
| `act-posted` | — | ×1 | — |
| `act-drop` (3 format: nosession/scene/target-unknown) | — | ×3 | — |
| `bw renew` (start/stop/tick) | ×3 | — | — |
| `[fs-diag]` | ×3 | — | — |
| `fullscreenDiagExpand` | ×2 | — | ×1 |
| `[probe]` / `[probe-foreign]` | ×4 / ×1 | — | — |
| `isSplit-fallback` | — | ×1 | — |
| `splitver` (producer SS / consumer AB) | ×1 | ×1 | — |

### 4.3 Cổng công tắc — đảo ngược đúng theo WO

- `fullscreenTestExpand`: **0 trong toàn bộ gói** (quét mọi file đã bung,
  binary + plist + strings) — bề mặt test fs1 không còn.
- `fullscreenDiagExpand`: có trong SplitScreen (controller) cả hai lát.
- **Binary Prefs chứa cả 3 khoá chẩn đoán trong CODE**: `fullscreenDiagExpand`
  ×1, `youtubeVirtualize` ×1, `bridgewake.pinchMode` ×1 — ở cả hai lát. Đây là
  cổng đã FAIL ở fs1 (specifier chỉ nằm trong plist không được trang nạp);
  ở ytz2 trang dựng bằng code nên khoá nằm trong chính binary.
- `youtubeVirtualize` trong AppBridge ×1 (điểm đọc kill-switch ABYTZoom);
  `bridgewake.pinchMode` trong SplitScreen ×1 (owner đọc mode).

### 4.4 publishKnobsNow — đúng 1 eor mỗi lát (SplitScreen)

- arm64: IMP 0x12770, khoảng 0x12770–0x12bbc (275 lệnh), **1 eor tại
  0x129dc**: `eor w2, w26, #1`.
- arm64e: IMP 0x130a8, khoảng 0x130a8–0x134f8 (276 lệnh), **1 eor tại
  0x13318**: `eor w2, w26, #1`.

Cùng dạng lệnh + cùng số lệnh trong khoảng như fs1/ytz1 (chỉ lệch địa chỉ
do code cộng thêm) — phép lật cực núm giữ nguyên.

### 4.5 g1 — dạng csel của appWithHash:changedOrientation:supportedMask: (AppBridge)

- arm64 (IMP 0x7464): `and x8, x21, #2` @0x7638 → `csel x8, xzr, x9, ne`
  @0x7660; cổng mask==0 @0x7668; sentinel `cmp x20, #0xff` @0x766c.
- arm64e (IMP 0x775c): cùng chuỗi tại 0x7934 / 0x795c; mask @0x7964;
  sentinel @0x7968.

Địa chỉ trùng ytz1 — cổng lease YZ ở đầu hàm và đường suy hướng không đổi.

### 4.6 Ngân sách hook sendEvent / MSHookMessageEx (SplitScreen)

- Source (theo đúng quy ước đếm của fs1): SCPHooks.m giữ nguyên 31 dòng
  MSHookMessageEx; SCPTouchProbe.m chứa đúng **1 lời gọi thật**
  (`MSHookMessageEx(UIApplication, sendEvent:)` tại :198; dòng còn lại là
  comment ở header) → toàn module **32 = 31 + 1** như thiết kế W4. Đếm
  nghiêm ngặt theo dạng lời gọi `MSHookMessageEx(` trên toàn module:
  fs1 = 30 (SCPHooks 29 + SCPSpringBoardHooks 1) → ytz2 = 31 (+1 probe).
- Binary: `_MSHookMessageEx` là import (undefined symbol) trong cả hai lát
  SplitScreen; tập `__objc_methname` của SplitScreen có thêm `sendEvent:`
  (xem 4.7) — dấu vết của hook probe trong binary.

### 4.7 Selector parity (tập chuỗi __objc_methname, cùng phương pháp ci-ytz1)

So với **FAT fs1** (cả hai lát cho cùng kết quả):

| Binary | fs1 | ytz2 | mất | thêm |
|---|---|---|---|---|
| OmniCar (app) | 119 | 119 | 0 | 0 |
| OmniCarPrefs | 1715 | 1715 | 0 | 0 |
| OmniCarCarProbe | 111 | 111 | 0 | 0 |
| OmniCarCore | 131 | 131 | 0 | 0 |
| OmniCarSpeedBubble | 793 | 793 | 0 | 0 |
| OmniCarStartupScreen | 728 | 728 | 0 | 0 |
| OmniCarSplitScreen | 1384 | 1387 | **4** | **7** |
| OmniCarAppBridge | 724 | 797 | **0** | **73** |

- SplitScreen mất đúng 4 = bề mặt test fs1 đã gỡ (`_prefsToken`,
  `_testSwitchLast`, `fsTestPrefsChanged`, `fsTestSwitchOn`) — như ytz1.
- SplitScreen thêm đúng 7, truy được từng nhóm của vòng WO:
  `_fsDiagPrefsToken`, `_fsDiagWant`, `fsDiagPrefsChanged` (đường [fs-diag]);
  `bwRenewMaintain`, `bwRenewTick:` (state renewal);
  `sendEvent:`, `valueWithPointer:` (probe SCPTouchProbe).
- AppBridge mất 0; +73 là toàn bộ bề mặt YZ của ytz1 (không đổi so với
  ytz1). Sửa act của vòng này nằm trong thân hàm tĩnh sẵn có nên không đổi
  tập methname — bằng chứng của nó là chuỗi ở 4.2.
- So với **FAT ytz1**: chỉ SplitScreen thay đổi (+7, mất 0); 7 binary còn
  lại identical từng chuỗi methname.

Markers (đếm chuỗi, hai lát như nhau): SS `[autohide]` 9→16 (nhóm reason
của `bwHandleActPacket:` viết lại + `reveal-applied`, theo fix-wp-owner),
`[wake1]` 13→16 (nhóm log renewal/arbiter của BridgeWake), `[pinch1]` 5,
`[fs1]` 16 — giữ nguyên; AB `[autohide]` 2→6 (= act-posted + 3 act-drop +
2 cũ), `[ytz]` 16→19 (+3: `isSplit-fallback`, `lease-lapse`,
`owner phien host` theo fix-y-issplit).

## 5. Kết luận mức

- Đồng bộ mirror: 14/14 identical; git main `a763030`, ci-fat-test `5c5698f`.
- CI: run 42583754018 SUCCESS (foreground-verified).
- FAT ytz2: **static PASS trên cả hai lát** cho mọi kiểm được giao (kênh
  bridgewake 5/5, ytlease 2 kênh, chuỗi mới act/renew/diag/probe/isSplit
  đủ vị trí, fullscreenTestExpand vắng toàn gói, 3 khoá chẩn đoán trong
  binary Prefs, knob 1-eor, g1 csel, parity đúng kỳ vọng, ngân sách hook
  32 theo quy ước fs1).
- Chưa có bằng chứng runtime/xe. ytz2 thay thế ytz1 (bản cách ly vì 3 lỗi
  WO) làm ứng viên giao duy nhất; nghiệm thu thuộc phiên xe theo kịch bản
  5 bước của WO (W5 → controller qua [fs-diag] → pinch DRY_RUN/ENFORCE →
  YTZ OFF/ON → Weather + núm).
