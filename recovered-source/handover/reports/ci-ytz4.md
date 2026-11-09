# CI FAT — ytz4 (vòng theo phán quyết GPT sau log ytz3: tín hiệu kb ba trạng thái có nguồn xác thực, gỡ ba ràng buộc AutoHide EXPANDED, instrument đường Home, snapshot lúc revoke YTZ)

Ngày: 2026-11-09. Loại việc: đồng bộ mirror + git + kích hoạt CI + kiểm chứng
FAT trên lát thin trích từ chính FAT. Nguồn: main `237098c`
(ytz4 source), ci-fat-test `aff33ed` (merge main).

## 0. Audit cmp mirror 4 strand

Audit cmp 15 cặp file của 4 strand (fix-hb-kb-host-autohide,
fix-k2-kb-app, fix-i2-homelib, fix-y2s-revokesnap) giữa `project/` và
mirror `src/`:

- **14/15 identical tại thời điểm audit** — không phải chép file nào:
  BridgeWake.m/.h, AutoHide.m, SCPShared.h/.m, SCPHooks.m
  (SplitScreenA); SCPAppIcons.m (SplitScreenC); ABHostGeometry.m,
  ABChannelNames.m, AppBridgeB.h, ABHost.h bản B, ABInApp.m,
  ABYTZoom.m (AppBridgeB); ABHostLaunch.m (AppBridgeA/src).
- **1 ngoại lệ đã biết, giữ nguyên theo thiết kế:** SCPHomeApply.m —
  diff duy nhất là dòng import 18: bản project ghi
  `"SCPHomeWallView.h"` kèm comment tự ghi "(src keeps the
  ../SplitScreenB/ path)", bản src ghi `"../SplitScreenB/SCPHomeWallView.h"`.
  Đây là phân kỳ đường dẫn có từ trước (ghi trong biên bản fix-i2);
  nội dung instrument +20/−0 hai phía khớp nhau. Chép đè project→src
  sẽ phá đường import tương đối của cây src nên KHÔNG chép.
- ABHost.h bản A (`src/AppBridgeA/src/`): khai báo `ABKbSyncNoteEvent`
  có mặt ×1 ở cả 3 bản (project, A, B) — nội dung đồng bộ theo văn
  phong riêng của file A như thiết kế fix-hb.

Kiểm dương tính trong source trước khi đồng bộ: `[homelib]`
SCPHooks.m ×5 dòng, SCPAppIcons.m ×12, SCPHomeApply.m ×5;
`[kb-sync]` BridgeWake.m ×3, ABHostGeometry.m ×1;
`[ytz-revoke-snap]` ×5 dòng + `[ytz-nextlayout]` ×4 + `prevRevoke` ×2
trong ABYTZoom.m; kênh mới `com.anlai.omnicar/appbridge.kbsync` định
nghĩa ở ABChannelNames.m (phía AppBridge) và SCPShared.m/.h (phía
SplitScreen).

Git: rsync project/+src/ → push9-clone/recovered-source (loại
packages/.theos/*.deb/*.o), commit + push main =
**`237098ca4aca17a1b997db6b7ea5a1a87a024849`** — đúng 31 file
(15 project + 16 src; ABHost.h tính 2 bản ở src), +1431/−80, không
thay đổi phụ. Merge main → ci-fat-test =
**`aff33ed4328170ecca35eaa1b2b774da950cab71`**, đã push;
`git diff origin/main origin/ci-fat-test -- recovered-source/project
recovered-source/src` = 0 dòng.

## 1. CI run

- Workflow `build-fat-macos.yml` (id 410962367), ref `ci-fat-test`,
  dispatch `gh workflow run 410962367 --ref ci-fat-test`
  (GH_TOKEN lấy từ remote URL của clone vào biến shell, không in ra).
- **Run dispatch: 42599165348** (workflow_dispatch, headSha `aff33ed`).
  Job build-fat: started 2026-11-09T10:12:25Z → completed 10:15:37Z,
  conclusion **success** — xác minh foreground bằng truy vấn trực
  tiếp jobs API + `gh run view` sau khi job hoàn tất.
- Ghi chú trung thực về đường đi: các truy vấn metadata quanh phút
  10:15 cho kết quả chập chờn (run view lúc báo completed lúc báo
  in_progress; danh sách artifact toàn repo từng hiện một artifact
  gán cho run push mà truy vấn trực tiếp theo id trả 404). Sự thật
  chốt bằng jobs API (build-fat completed/success, artifact count
  của run dispatch = 1) và bằng chính file deb tải về đo tại đĩa —
  không dựa vào bất kỳ output nền/poll nào.
- Run 42599156904 do push kích hoạt (cùng headSha) chạy song song —
  không dùng; artifact lấy từ run dispatch, đúng quy ước vòng trước.

## 2. FAT

- Tên tại handover: `com.anlai.omnicar_1.0.3-rebuilt-ytz4-fat_iphoneos-arm64.deb`
- Kích thước: **1.229.512 B**. SHA-256:
  **`53caff295b29c277a3db31c102f7817284345e573d0be3169ce4a6fccfe8a3a2`**
  (tự đo trên bản ở handover).
- ar members: `debian-binary` + `control.tar.gz` + `data.tar.lzma`.
  Control: Package `com.anlai.omnicar` / Version `1.0.3` /
  `iphoneos-arm64` / Installed-Size 5964 (bằng ytz3).
- Lát thin: AppBridge arm64 306.896 B / arm64e 306.896 B (ytz3:
  306.784 — +112 B mỗi lát); SplitScreen arm64 584.976 B / arm64e
  601.584 B (ytz3: 584.896 / 601.520). Sáu binary còn lại bằng ytz3
  từng byte-size — chỉ hai module có strand đụng mới đổi cỡ.

## 3. Hiệu chuẩn parser trên FAT ytz3 (trước khi đo ytz4)

Bộ parser Mach-O tự viết (macho_scan + macho_objc + macho_truth/
capstone) được chạy lại trên FAT ytz3 (bản ở handover, SHA
`c1872b93…` — tự trích lại từ deb vì cây /tmp/ytz3x còn sót là lát
thin của một bản khác, không dùng): tái lập **16/16 UUID** của
ci-ytz3; toàn bộ số chuỗi của ci-ytz3 ([probe-feed] 8, [touchset] 1,
[applib] 8, [scenevis] 1, snap{ 1, [probe] 4; SS [autohide] 16 /
[wake1] 16 / [fs-diag] 3 / [fs1] 16 / [pinch1] 5; AB [autohide] 6 /
[ytz] 19; StartupScreen [weather] 17; Prefs 3 khoá ×1; SS
fullscreenDiagExpand ×2 — cả hai lát); knob IMP 0x12f9c (275 lệnh,
eor @0x13208) / IMP 0x138e8 (276 lệnh, eor @0x13b58); g1 IMP
0x7464 / 0x775c kèm chuỗi idiom. Mọi số ytz4 dưới đây đo bằng đúng
bộ đã hiệu chuẩn đó, trên lát thin trích từ chính FAT ytz4.

## 4. UUID hai lát của FAT ytz4 (LC_UUID trên lát thin)

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | F5D89BD4-ECC2-360B-8C09-F1BF4FF18774 | 6708B147-F17D-30AE-9201-B72D64747522 |
| OmniCarAppBridge | 619B0A9A-D6B0-3D5F-A8EC-FC2F11F0099E | EF5B12F3-AF3A-3EDC-93E8-3EB302C8A2AC |
| OmniCarCarProbe | C0A9772A-801A-331A-A350-772C5BE2A3E9 | E6C46A44-CCEB-3A79-BF93-C0446A1CBE24 |
| OmniCarCore | CAC95506-92A2-3A0B-82E8-7597671B193E | 5AFCBF85-C5B5-3041-86C3-22D2F90839A1 |
| OmniCarPrefs | 1E88933B-2FB9-34B2-8BCD-D983C57EB041 | FBCC574B-B266-3907-BCDA-0183E5381D5C |
| OmniCarSpeedBubble | DD5FCE15-750D-3E4D-A53D-DF5771D7F2EB | B2244376-6D02-3916-B852-19A4E043DF88 |
| OmniCarSplitScreen | CEFDC89E-6DBD-3AF1-9A25-2CC8BE9B3EFB | 52D6F48D-A599-304C-AC15-FAAC71D100C2 |
| OmniCarStartupScreen | 72425650-9A99-3AE3-9097-D1198524AF17 | 6716BBD1-5CCF-3A8F-A49E-3B556D4857D9 |

## 5. Kiểm hai lát (đo trên lát thin trích từ chính FAT này)

### 5.1 Kênh (tên đầy đủ, đếm theo chuỗi nguyên)

- `com.anlai.omnicar/bridgewake.v1.{state,query,wake,ack,act}`:
  mỗi chuỗi ×1 trong SplitScreen + AppBridge, cả hai lát (5/5 × 4
  vị trí) — khớp ytz3.
- `com.anlai.omnicar/appbridge.ytlease` ×1 + `…/appbridge.ytleaseack`
  ×1: chỉ trong AppBridge cả hai lát; SplitScreen = 0 — như ytz3.
- **`com.anlai.omnicar/appbridge.kbsync` ×1 trong SplitScreen VÀ
  ×1 trong AppBridge, cả hai lát** (ytz3: 0 ở cả hai) — kênh mới của
  fix-hb nằm đúng hai module hai đầu đường đồng bộ kb.

### 5.2 Chuỗi mới của vòng này — đúng vị trí, cả hai lát

(Đếm = số cstring phân biệt CHỨA mẫu, cùng quy ước đã hiệu chuẩn;
cột ytz3 để đối chiếu.)

| Chuỗi | SplitScreen ytz3→ytz4 | AppBridge ytz3→ytz4 | Ghi chú |
|---|---|---|---|
| `[homelib]` | 0 → **5** | — | fix-i2: 5 format phân biệt (helper SCPHomeLibLogDecision + các điểm hooks/apply) |
| `[kb-sync]` | 0 → **3** | 0 → **1** | fix-hb: 3 format phía owner (BridgeWake.m), 1 format phía host (ABHostGeometry.m); phía app (fix-k2) không mang tag này — trạng thái ba trạng thái đi trong dòng probe kbKnown/kbActive |
| `[ytz-revoke-snap]` | — | 0 → **2** | fix-y2s: 2 format cho 2 đường (qua yzLeaseRevokeForPane: + đường mồ côi trong YZHandlePrefChanged) |
| `[ytz-nextlayout]` | — | 0 → **1** | fix-y2s: format one-shot ở đuôi YZPublish |
| `prevRevoke` | — | 0 → **1** | trường cộng trong format grant sẵn có |

Marker cũ không hồi quy (hai lát như nhau, từng số bằng ytz3): SS
`[probe-feed]` 8, `[touchset]` 1, `[applib]` 8, `[scenevis]` 1,
`snap{` 1, `[probe]` 4, `[autohide]` 16, `[wake1]` 16, `[fs-diag]` 3,
`[fs1]` 16, `[pinch1]` 5; AB `[autohide]` 6, `[ytz] ` 19;
StartupScreen `[weather]` 17.

### 5.3 Cổng công tắc chẩn đoán

- `fullscreenTestExpand`: **0 trong toàn bộ gói** (grep đệ quy mọi
  file đã bung của FAT ytz4).
- Binary Prefs chứa cả 3 khoá chẩn đoán ×1 mỗi lát:
  `fullscreenDiagExpand`, `youtubeVirtualize`, `bridgewake.pinchMode`.
- `fullscreenDiagExpand` trong SplitScreen ×2 mỗi lát (như ytz3).

### 5.4 publishKnobsNow — đúng 1 eor mỗi lát (SplitScreen)

- arm64: IMP **0x12f9c**, khoảng 0x12f9c–0x133e8 (275 lệnh),
  **1 eor tại 0x13208**: `eor w2, w26, #1`.
- arm64e: IMP **0x138e8**, khoảng 0x138e8–0x13d38 (276 lệnh),
  **1 eor tại 0x13b58**: `eor w2, w26, #1`.

Trùng ytz3 từng địa chỉ, từng số lệnh — phép lật cực núm không hề
dịch dù SplitScreen có thêm code kb-sync/homelib vòng này.

### 5.5 g1 — dạng csel của appWithHash:changedOrientation:supportedMask: (AppBridge)

- arm64: IMP **0x7470** (ytz3: 0x7464 — dịch +0xc), 181 lệnh; chuỗi
  idiom đủ: `and x8, x21, #2` → `csel x8, xzr, x9, ne` → sentinel
  `cmp x20, #0xff` → `csel x2, x8, x20, eq`; offset trong thân hàm
  của từng mắt xích bằng ytz3 (0x1d4 / 0x1fc / 0x208).
- arm64e: IMP **0x7768** (ytz3: 0x775c — dịch +0xc), 182 lệnh; cùng
  chuỗi idiom, cùng offset trong thân.

ABHostBMethods.m (nơi chứa appWithHash:) không bị strand nào đụng;
địa chỉ dịch +0xc là hệ quả chèn code phía trước trong cùng binary
(fix-hb ở ABHostGeometry/ABChannelNames), thân hàm giữ nguyên bố
cục — idiom là bằng chứng quyết định.

### 5.6 Selector parity (tập chuỗi __objc_methname, cùng phương pháp đã hiệu chuẩn)

So với **FAT ytz3** — cả hai lát cho cùng kết quả; mất/thêm là diff
theo TẬP TÊN:

| Binary | ytz3 | ytz4 | mất | thêm |
|---|---|---|---|---|
| OmniCar (app) | 119 | 119 | 0 | 0 |
| OmniCarPrefs | 1715 | 1715 | 0 | 0 |
| OmniCarCarProbe | 111 | 111 | 0 | 0 |
| OmniCarCore | 131 | 131 | 0 | 0 |
| OmniCarSpeedBubble | 793 | 793 | 0 | 0 |
| OmniCarStartupScreen | 728 | 728 | 0 (identical từng tên) | 0 |
| OmniCarSplitScreen | 1394 | 1397 | **0** | **3** |
| OmniCarAppBridge | 797 | 806 | **0** | **9** |

Delta truy được từng strand:

- SplitScreen +3, toàn bộ fix-hb: `bwHandleKbSyncNote:`,
  `bwKbEmitForPane:` (hai method mới của owner cho đường kbsync) +
  `unsignedIntValue` (selector tham chiếu khi đọc gói). Phần
  AutoHide của fix-hb (gỡ 3 ràng buộc EXPANDED) cộng **0** selector —
  sửa trong thân method sẵn có. fix-i2 cộng **0** — instrument thuần
  bằng log vào hook sẵn có, đúng thiết kế.
- AppBridge +9, toàn bộ fix-y2s: họ property `revokeSnapPending` /
  `revokeSnapAt` (2 chuỗi thuộc tính `TB,N,V_revokeSnapPending`,
  `Td,N,V_revokeSnapAt`; 2 tên ivar `_revokeSnapAt`,
  `_revokeSnapPending`; 2 getter; 2 setter) + `appendFormat:` (tham
  chiếu khi dựng trường snapshot). fix-hb phía AppBridge và fix-k2
  cộng **0** selector mới — kb host note là hàm C/kênh sẵn cộng,
  phía app tiêu thụ gói type 6 trong thân hàm sẵn có.

## 6. Kết luận mức

- Đồng bộ mirror: 14/15 identical + 1 ngoại lệ import đã biết (giữ
  nguyên theo thiết kế); git main `237098c`, ci-fat-test `aff33ed`.
- CI: run dispatch 42599165348 SUCCESS (job 3m12s,
  foreground-verified bằng jobs API sau khi hoàn tất).
- FAT ytz4: **static PASS trên cả hai lát** cho mọi kiểm được giao
  (kênh bridgewake 5/5, ytlease 2 kênh đúng tên, kbsync ×1 đúng hai
  module hai lát; chuỗi mới [homelib]/[kb-sync]/[ytz-revoke-snap]/
  [ytz-nextlayout] đúng vị trí và đúng số format của từng strand;
  fullscreenTestExpand vắng toàn gói; 3 khoá chẩn đoán trong binary
  Prefs; knob 1-eor mỗi lát trùng ytz3 từng địa chỉ; g1 idiom nguyên
  vẹn hai lát; parity vs ytz3 mất 0 ở mọi binary, delta +3 SS / +9
  AB truy hết vào fix-hb / fix-y2s).
- Chưa có bằng chứng runtime/xe. Nghiệm thu thuộc phiên xe kế tiếp:
  chuỗi nuốt kb ba trạng thái (Gate 3 vẫn đóng theo GPT), fade khi
  EXPANDED sau gỡ ba ràng buộc, ca guard ngược (popup mở → expand
  bị từ chối kèm snapshot), hiệu chuẩn pinch có chủ đích, và các
  dòng [homelib] đầu tiên từ đường Home thật.
