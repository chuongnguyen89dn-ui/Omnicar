# CI FAT — ytz3 (vòng sửa sau log ytz2 theo WO GPT: guard FS theo popup đang hoạt động, feed activity cho ô native + đo touch-set, instrument mất icon/ô trắng, instrument weather request→answer)

Ngày: 2026-11-09. Loại việc: đồng bộ mirror + git + kích hoạt CI + kiểm chứng
FAT trên lát thin trích từ chính FAT. Nguồn: main `36135b8` (ytz3 source),
ci-fat-test `dd47375` (merge main).

## 0. Audit cmp mirror 4 strand

Audit cmp 8 cặp file của 4 strand (fix-g-fsguard, fix-np-nativefeed,
fix-i-iconwhite, fix-w-weatherinst) giữa `project/` và mirror `src/`:
**8/8 identical tại thời điểm audit** — không cần chép file nào.

| File (project/) | Mirror (src/) |
|---|---|
| OmniCarSplitScreen/SCPFullscreenController.m | SplitScreenA/ |
| OmniCarSplitScreen/SCPTouchProbe.m | SplitScreenA/ |
| OmniCarSplitScreen/SCPTouchProbe.h | SplitScreenA/ |
| OmniCarSplitScreen/SCPCarApps.m | SplitScreenC/ |
| OmniCarSplitScreen/SCPCarSplit.m | SplitScreenA/ |
| OmniCarStartupScreen/SSSplash.m | StartupScreen/ |
| OmniCarStartupScreen/SSStartupScreen.m | StartupScreen/ |
| OmniCarStartupScreen/SSStartupView.m | StartupScreen/ |

Kiểm dương tính trong source trước khi đồng bộ: `snap{` ×1
(SCPFullscreenController.m); `[probe-feed]` ×8 + `[touchset]` ×3 dòng
(SCPTouchProbe.m); `[applib]` (SCPCarApps.m) + `[scenevis]` (SCPCarSplit.m);
`[weather]` ở cả 3 file StartupScreen.

Git: rsync project/+src/ → push9-clone/recovered-source (loại packages/
.theos/*.deb/*.o), commit + push main =
**`36135b8a355626a2d57103624d16cbcda6ebe273`** (đúng 16 file = 8 file strand
× 2 cây, không thay đổi phụ). Merge main → ci-fat-test =
**`dd4737522539d450a7024f22e6ef696d9f1a35b9`**, đã push;
`git diff origin/main origin/ci-fat-test -- recovered-source/project
recovered-source/src` = 0 dòng.

## 1. CI run

- Workflow `build-fat-macos.yml` (id 410962367), ref `ci-fat-test`,
  dispatch `gh workflow run 410962367 --ref ci-fat-test`.
- **Run id: 42590500247** (workflow_dispatch, headSha `dd47375`) — theo dõi
  foreground bằng `gh run watch --exit-status` + truy vấn trực tiếp
  `gh run view`: status `completed`, conclusion **`success`**
  (2026-11-09T09:03:53Z → 09:07:17Z, job build-fat 3m20s).
- URL: https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42590500247
- (Run 42590486920 do push kích hoạt, cùng headSha, chạy song song — không
  dùng; artifact lấy từ run dispatch.)
- Artifact: `omnicar-fat-deb`.

## 2. FAT

- Tên tại handover: `com.anlai.omnicar_1.0.3-rebuilt-ytz3-fat_iphoneos-arm64.deb`
- Kích thước: **1.224.728 B**. SHA-256:
  **`c1872b936a01969418b68cc5f69e1bd72639a1f5e2e2f1da16132edcfc6bcf3f`**
  (đo trên bản ở handover).
- ar members: `debian-binary` + `control.tar.gz` + `data.tar.lzma`. Control:
  Package `com.anlai.omnicar`, Version `1.0.3`, Architecture
  `iphoneos-arm64`, Installed-Size 5964.
- Lát thin: SplitScreen arm64 584.896 B / arm64e 601.520 B; AppBridge
  arm64 306.784 B / arm64e 306.784 B (bằng ytz2 — AppBridge không đổi vòng
  này); StartupScreen arm64 280.528 B / arm64e 280.528 B.

## 3. UUID hai lát (LC_UUID trên lát thin)

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | DE2614F0-4855-3FA8-A4FD-352B173F0EBB | 14BBAD21-39E2-3687-ADD8-7C862A6384FE |
| OmniCarAppBridge | EC296AC0-2DEB-3D8B-A6EE-18F31F6844F0 | CDA16254-3BCB-3229-8E1D-FEE91A63FF9E |
| OmniCarCarProbe | 0692373B-5B2C-3722-AE3C-B8930EB13958 | 418F189C-89CD-35C2-AFF7-3EE3F8FA9ED6 |
| OmniCarCore | 72FDDB4D-C760-31B2-97BE-8DBD66DD7430 | 9B83B007-04CF-3CEF-BF6A-C36A9F7B11CC |
| OmniCarPrefs | 2A9E1D10-A996-390D-8B43-341AEAF0F307 | 88F1CD91-A094-36FA-A5A8-DE19178A4560 |
| OmniCarSpeedBubble | 4D817904-657E-3059-B54C-8611E79BC6F5 | EEC75E69-68AD-368A-81A1-CA29D993AB91 |
| OmniCarSplitScreen | CA7EFC72-4882-31F5-86F7-4292AD57D330 | 4947C6C1-80F4-313E-90F2-1648E8D29E64 |
| OmniCarStartupScreen | 19CDA773-E7EA-3F5E-B5FB-2DA26A5D6629 | 431CD8C1-B6CB-3B36-A373-F350FB6394F3 |

Phương pháp đo (parser Mach-O tự viết) đã **hiệu chuẩn trên FAT ytz2 trước
khi đo ytz3**: tái lập đúng 16/16 UUID của ci-ytz2, toàn bộ bảng methname,
IMP publishKnobsNow + khoảng hàm + địa chỉ eor (cả hai lát) và IMP g1 (cả
hai lát) — gồm cả giải mã con trỏ DYLD chained-fixup của lát arm64e (đích
là 36 bit thấp). Số ytz3 dưới đây đo bằng đúng bộ đã hiệu chuẩn đó.

## 4. Kiểm hai lát (đo trên lát thin trích từ chính FAT này)

### 4.1 Kênh bridgewake + ytlease (tên đầy đủ)

`com.anlai.omnicar/bridgewake.v1.{state,query,wake,ack,act}`: mỗi chuỗi ×1
trong SplitScreen + AppBridge, cả hai lát (5/5 × 4 vị trí) — khớp ytz2.
`com.anlai.omnicar/appbridge.ytlease` ×1 + `…/appbridge.ytleaseack` ×1:
chỉ trong AppBridge cả hai lát; SplitScreen = 0 — phân bổ như ytz2.

### 4.2 Chuỗi MỚI của vòng này — có mặt đúng vị trí, cả hai lát

| Chuỗi | SplitScreen | StartupScreen | Ghi chú |
|---|---|---|---|
| `[probe-feed]` | ×8 | — | khớp 8 format của fix-np |
| `[touchset]` | ×1 | — | 1 format dòng sự kiện tập touch |
| `[applib]` | ×8 | — | khớp 8 format của fix-i |
| `[scenevis]` | ×1 | — | 1 format, nhiều điểm gọi |
| `snap{` | ×1 | — | format snapshot từ chối của fix-g |
| `[weather]` | — | ×17 | khớp 17/17 format của fix-w |
| `[probe]` | ×4 | — | giữ nguyên như ytz2 |

Marker cũ không hồi quy (cả hai lát như nhau): SS `[autohide]` 16,
`[wake1]` 16, `[fs-diag]` 3, `[fs1]` 16, `[pinch1]` 5; AB `[autohide]` 6,
`[ytz]` 19 — từng số khớp FAT ytz2.

### 4.3 Cổng công tắc chẩn đoán

- `fullscreenTestExpand`: **0 trong toàn bộ gói** (grep đệ quy mọi file đã
  bung, binary + plist + strings) — bề mặt test fs1 không quay lại.
- **Binary Prefs chứa cả 3 khoá chẩn đoán trong CODE**: `fullscreenDiagExpand`
  ×1, `youtubeVirtualize` ×1, `bridgewake.pinchMode` ×1 — ở cả hai lát.
- `fullscreenDiagExpand` trong SplitScreen ×2 mỗi lát (controller đọc pref
  + listener [fs-diag]).

### 4.4 publishKnobsNow — đúng 1 eor mỗi lát (SplitScreen)

- arm64: IMP 0x12f9c, khoảng 0x12f9c–0x133e8 (275 lệnh), **1 eor tại
  0x13208**: `eor w2, w26, #1`.
- arm64e: IMP 0x138e8, khoảng 0x138e8–0x13d38 (276 lệnh), **1 eor tại
  0x13b58**: `eor w2, w26, #1`.

Cùng số lệnh trong khoảng như ytz2 (275/276) — phép lật cực núm giữ
nguyên; địa chỉ dịch do code cộng thêm của vòng này trong cùng binary.

### 4.5 g1 — dạng csel của appWithHash:changedOrientation:supportedMask: (AppBridge)

- arm64 (IMP **0x7464**, trùng ytz2): `and x8, x21, #2` → `csel x8, xzr, x9,
  ne`; cổng mask==0; sentinel `cmp x20, #0xff` — đủ cả chuỗi.
- arm64e (IMP **0x775c**, trùng ytz2): cùng chuỗi tại các địa chỉ tương ứng.

AppBridge không bị strand nào đụng ở vòng này; IMP và chuỗi lệnh giữ
nguyên từng địa chỉ so với ytz2 là bằng chứng độc lập.

### 4.6 Selector parity (tập chuỗi __objc_methname, cùng phương pháp đã hiệu chuẩn)

So với **FAT ytz2** — đếm theo lát, cả hai lát cho cùng kết quả; cột mất/
thêm là diff theo TẬP TÊN (đo trên lát arm64, lát arm64e cùng delta):

| Binary | ytz2 | ytz3 | mất | thêm |
|---|---|---|---|---|
| OmniCar (app) | 119 | 119 | 0 | 0 |
| OmniCarPrefs | 1715 | 1715 | 0 | 0 |
| OmniCarCarProbe | 111 | 111 | 0 | 0 |
| OmniCarCore | 131 | 131 | 0 | 0 |
| OmniCarSpeedBubble | 793 | 793 | 0 | 0 |
| OmniCarStartupScreen | 728 | 728 | 0 (identical từng tên) | 0 |
| OmniCarAppBridge | 797 | 797 | 0 (identical từng tên) | 0 |
| OmniCarSplitScreen | 1387 | 1394 | **0** | **7** |

SplitScreen thêm đúng 7, truy được từng strand:
- fix-g (2): `fsRefusalSnapshot:`, `fsTraySurfaceBusy:` — hai helper
  private của SCPFullscreenController.
- fix-np (5): `convertPoint:toCoordinateSpace:`, `valueWithCGPoint:`,
  `CGPointValue`, `pointerValue`, `timestamp` — selector tham chiếu cho
  quy đổi tọa độ screen-space + bản ghi touch-set trong SCPTouchProbe.
- fix-i (0): chỉ cộng lời gọi log vào thân hàm sẵn có — không selector mới,
  đúng tính chất instrument thuần.
- fix-w thuộc StartupScreen: tập tên identical ytz2 (chỉ cộng log + counter
  tĩnh) — khớp tính chất instrument thuần của strand đó.

## 5. Kết luận mức

- Đồng bộ mirror: 8/8 identical; git main `36135b8`, ci-fat-test `dd47375`.
- CI: run 42590500247 SUCCESS (foreground-verified).
- FAT ytz3: **static PASS trên cả hai lát** cho mọi kiểm được giao (kênh
  bridgewake 5/5, ytlease 2 kênh đúng tên đầy đủ, chuỗi mới
  probe-feed/touchset/applib/scenevis/snap{/weather đủ vị trí và đúng số
  format của từng strand, fullscreenTestExpand vắng toàn gói, 3 khoá chẩn
  đoán trong binary Prefs, knob 1-eor mỗi lát, g1 nguyên vẹn, parity vs
  ytz2 mất 0 ở mọi binary và delta +7 của SplitScreen truy hết vào 2
  strand fix-g/fix-np).
- Chưa có bằng chứng runtime/xe. ytz3 thay thế ytz2 làm ứng viên giao duy
  nhất; nghiệm thu thuộc phiên xe kế tiếp (test controller sạch sau khi
  đóng picker hoàn toàn, feed native lúc controls mờ, đọc [touchset] khi
  pinch thử, và các dòng [applib]/[scenevis]/[weather] mới là đầu vào cho
  các câu hỏi còn mở của GPT).
