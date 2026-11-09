# CI FAT — ytz1 (pinch sống ENFORCE + YT-Zoom ảo hoá hướng)

Ngày: 2026-11-09. Loại việc: merge + kích hoạt CI + kiểm chứng FAT trên lát thin
trích từ chính FAT. Nguồn: main `0c5da2e` (ytz1 source).

## 1. Merge + Run

- Merge main (`0c5da2e`) vào `ci-fat-test` (từ `c392db4`) →
  **`fa159097aaef3ae3b38906bade5bb64d9ead8ab5`**, đã push.
- Workflow: `build-fat-macos.yml` (id 410962367), ref `ci-fat-test`.
- Dispatch: `gh workflow run 410962367 --ref ci-fat-test` lúc 2026-11-09T07:48:57Z.
- **Run id: 42581690791** (workflow_dispatch, headSha `fa15909`) — truy vấn
  foreground trực tiếp (`gh run view`): status `completed`, conclusion
  **`success`**, job build-fat `success`, 07:48:57Z → 07:52:43Z.
- URL: https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42581690791
- Artifact: `omnicar-fat-deb` (zip 1.210.869 B, chưa hết hạn).

## 2. FAT

- Tên trong artifact: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`.
- Tên tại handover: `com.anlai.omnicar_1.0.3-rebuilt-ytz1-fat_iphoneos-arm64.deb`.
- Kích thước: **1.210.344 B**. SHA-256:
  **`4caa2568d6ef9d145a609ca92e82f30591da45a729688d3d86cfdb7bd1c186a1`**
  (đo trên bản ở handover).
- ar members: `debian-binary` + `control.tar.gz` + `data.tar.lzma` (đúng định
  dạng CI đã qua máy). Control: Package `com.anlai.omnicar`, Version `1.0.3`,
  Architecture `iphoneos-arm64`.
- Hai dylib đích đều FAT arm64 + arm64e: OmniCarSplitScreen.dylib 1.158.000 B,
  OmniCarAppBridge.dylib 634.464 B.

## 3. UUID hai lát (LC_UUID trên lát thin)

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 3126BF32-FDB9-3A41-876F-E7068B64155E | 82F5F15F-9D1A-3B6F-8673-0D688495065E |
| OmniCarAppBridge | 674A9E79-B695-3E66-91ED-8C6AE7F09862 | 9C1BDCC8-0D45-3782-9D46-F242FA2FACDB |
| OmniCarCarProbe | 0D3EDB7E-81C5-3DE9-9606-3C2E9624EEB4 | AA7C4834-47D2-362F-AB95-08679D2E22CC |
| OmniCarCore | 8A9AB72E-4E0E-3191-A818-8005F48749D7 | 3D93EE11-9966-384F-B37F-50CEE04022C9 |
| OmniCarPrefs | 7681B81E-8AE2-382E-9ED4-9D833A96B975 | 76D5FA02-A996-3F5F-B21E-2052CECD3151 |
| OmniCarSpeedBubble | C068475E-A1DF-3492-A39C-C9BF6F0499C6 | 78DA1015-1C51-31AC-8772-A9B440664F07 |
| OmniCarSplitScreen | 7F074C1D-049A-3687-8646-DC16748197FE | 180C9921-E697-3AEB-B3FF-EB8040ECC511 |
| OmniCarStartupScreen | 2EB13EE1-0EC5-3B3C-A4FB-D755070CF460 | CD14E425-B023-3209-9DD5-4ED2A3238CCA |

Kích thước lát thin: SS arm64 568.144 B / arm64e 568.176 B;
AB arm64 306.768 B / arm64e 306.784 B.

## 4. Kiểm hai lát (đo trên lát thin trích từ chính FAT này)

### 4.1 Kênh bridgewake — 5/5 ở cả hai binary, cả hai lát

`com.anlai.omnicar/bridgewake.v1.{state,query,wake,ack,act}`: mỗi chuỗi đúng 1
bản trong SplitScreen arm64, SplitScreen arm64e, AppBridge arm64, AppBridge
arm64e (4/4 vị trí × 5 kênh) — khớp FAT fs1.

### 4.2 Kênh ytlease — có trong AppBridge, cả hai lát

`com.anlai.omnicar/appbridge.ytlease` ×1 và `.../appbridge.ytleaseack` ×1
trong AppBridge arm64 + arm64e. SplitScreen: `ytlease` = 0 cả hai lát (đúng
phân bổ — máy lease sống phía AppBridge).

### 4.3 Markers [ytz] — đủ hai phía (host + app) trong AppBridge

16 format `[ytz]` ở mỗi lát AppBridge, khớp danh mục integration-ytz1:
phía host 6 (lease cap / gia han / thu hoi / chan apporient / sua residue /
ack phase) + phía app 10 (lease nhan / ao hoa BAT / ao hoa TAT / relay ap ×2 /
tieu thu tuyen bo / doc lai 0.12s / lease hong / cai may ao hoa / khong co
__supportedInterfaceOrientations). SplitScreen: `[ytz]` = 0.

Markers cũ giữ nguyên từng số so với FAT fs1 ở mọi vị trí hai lát:
`[autohide]` SS=9/AB=2, `[wake1]` SS=13, `[pinch1]` SS=5, `[fs1]` SS=16.

### 4.4 Cổng vắng mặt — [fs1-test] + fullscreenTestExpand

`[fs1-test]` = 0 và `fullscreenTestExpand` = 0 trong **cả 16 lát** của 8 binary
và trong mọi file không-phải-binary của gói (plist/strings sạch) — bề mặt
staging đã gỡ hẳn theo lệnh 14:37, đúng trạng thái "không công tắc".

### 4.5 publishKnobsNow — đúng 1 eor mỗi lát (SplitScreen)

Khoảng hàm từ IMP trong ObjC metadata (parser của dự án), đếm trên disasm
capstone lọc đúng khoảng:

- arm64: IMP 0x126d4–0x12b20, 275 lệnh, **1 eor tại 0x12940**: `eor w2, w26, #1`.
- arm64e: IMP 0x1300c–0x1345c, 276 lệnh, **1 eor tại 0x1327c**: `eor w2, w26, #1`.

Trùng tuyệt đối địa chỉ + dạng lệnh với FAT fs1 — phép lật cực núm giữ nguyên.

### 4.6 g1 — dạng csel của appWithHash:changedOrientation:supportedMask: (AppBridge)

Chuỗi suy hướng y hệt FAT fs1 (chỉ lệch địa chỉ do cổng lease mới ở đầu hàm —
nhìn thấy call + rẽ nhánh sớm trước khối suy tại 0x7634/0x7930):

- arm64 (IMP 0x7464): `and x8, x21, #2` @0x7638 → `cmp x8, #0` @0x765c →
  `csel x8, xzr, x9, ne` @0x7660; cổng mask==0 `csel x8, xzr, x8, eq` @0x7668;
  cổng sentinel `cmp x20, #0xff` @0x766c.
- arm64e (IMP 0x775c): cùng chuỗi tại 0x7934 / 0x7958 / 0x795c; mask @0x7964;
  sentinel @0x7968.

### 4.7 Selector parity so với FAT fs1 — cùng phương pháp (tập chuỗi __objc_methname)

| Binary | fs1 | ytz1 | mất | thêm |
|---|---|---|---|---|
| OmniCar (app) | 119 | 119 | 0 | 0 |
| OmniCarPrefs | 1715 | 1715 | 0 | 0 |
| OmniCarCarProbe | 111 | 111 | 0 | 0 |
| OmniCarCore | 131 | 131 | 0 | 0 |
| OmniCarSpeedBubble | 793 | 793 | 0 | 0 |
| OmniCarStartupScreen | 728 | 728 | 0 | 0 |
| OmniCarSplitScreen | 1384 | 1380 | **4** | 0 |
| OmniCarAppBridge | 724 | 797 | **0** | **73** |

(Số áp dụng cho cả arm64 lẫn arm64e — hai lát cho cùng một kết quả.)

- SplitScreen mất đúng 4 = bề mặt test đã gỡ: `_prefsToken`, `_testSwitchLast`,
  `fsTestPrefsChanged`, `fsTestSwitchOn` — khớp kỳ vọng −4 từng tên.
- AppBridge mất 0; thêm 73 chuỗi, toàn bộ thuộc bề mặt YZ mới: 6 method `yz*`
  (`yzEffectiveOrientation:`, `yzLeaseActiveForBundle:`, `yzLeaseGrantForPane:`,
  `yzLeaseNoteLayoutForPane:`, `yzLeaseRevokeForPane:reason:`,
  `yzLogAppOrientBlockedForPane:hash:`) + accessor của lease record
  (generation/width/height/active/contentDirty/expiryHeals/lastPostAt/
  pubWidth/pubHeight/pubActive/pubIsSplit/pubSceneID/hasPublished + setter/
  ivar/attribute strings) + selref ngoài mà code YZ gọi (UUID, UUIDString,
  windowScene, interfaceOrientation, scheduledTimerWithTimeInterval:…).
  Ghi chú đếm: con số "+60" ở integration-ytz1 là số **method định nghĩa**
  trên candidate local (654→714, pipeline VM); trên FAT, phép đếm tập chuỗi
  (cùng phương pháp cho cả hai FAT) cho **+73 chuỗi / mất 0** — nhất quán
  "chỉ thêm, thuộc YZ", không có thêm bất ngờ.

## 5. Kết luận mức

- CI: run 42581690791 SUCCESS (foreground-verified).
- FAT ytz1: **static PASS trên cả hai lát** cho mọi kiểm được giao (kênh
  bridgewake 5/5, ytlease 2 kênh, markers [ytz] đủ hai phía, vắng mặt
  [fs1-test]/fullscreenTestExpand, knob 1-eor, g1 csel, parity đúng kỳ vọng).
- Chưa có bằng chứng runtime/xe — nghiệm thu pinch bắn thật + YT-Zoom thuộc
  phiên đo của Nguyen (kịch bản §8.3 design-ytzoom), không tuyên bố gì hơn.
