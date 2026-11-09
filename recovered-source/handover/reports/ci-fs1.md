# CI FAT — fs1 (FS1 fullscreen controller + AutoHide)

Ngày: 2026-11-09. Loại việc: kích hoạt CI + kiểm chứng FAT trên binary trích ra.
Không commit/push thêm (source đã push sẵn bởi strand tích hợp).

## 1. Run

- Workflow: `build-fat-macos.yml` (id 410962367), ref `ci-fat-test`, headSha
  `c392db4f89d1a1d32f6606b5f6373b46edc15bc0` (main `5427920`).
- Dispatch: `gh workflow run 410962367 --ref ci-fat-test` lúc 2026-11-09T07:20:09Z.
- **Run id: 42578683063** (workflow_dispatch) — đã truy vấn foreground trực tiếp
  (`gh run view`): status `completed`, conclusion **`success`**, job build-fat 3m10s,
  đủ các bước Build package (arm64 + arm64e) / Verify FAT slices / Upload the FAT deb.
- URL: https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42578683063
- Run push-triggered song song trên cùng commit: 42578586477 (không dùng, như vòng wake1).
- Artifact: `omnicar-fat-deb` (id 13656058018, zip 1.201.168 B, chưa hết hạn).

## 2. FAT

- Tên workflow đặt trong artifact: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`.
- Tên giao bản tại handover: `com.anlai.omnicar_1.0.3-rebuilt-fs1-fat_iphoneos-arm64.deb`.
- Kích thước: **1.200.648 B**. SHA-256:
  **`41bb5b8bf21f87926449070c881ae453daf2d311ab2c91295e531494ce4b8a82`**
  (kiểm lại trên bản copy ở handover — khớp tuyệt đối).
- ar members: `debian-binary` + `control.tar.gz` + `data.tar.lzma` (đúng định dạng
  CI đã qua máy). Control: Package `com.anlai.omnicar`, Version `1.0.3`,
  Architecture `iphoneos-arm64`.
- Hai dylib đích đều FAT arm64 + arm64e: OmniCarSplitScreen.dylib 1.174.592 B,
  OmniCarAppBridge.dylib 584.400 B.

## 3. UUID hai lát (LC_UUID trên lát thin)

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCarSplitScreen | F286AD3F-5D2E-3466-BABE-4E572968A688 | 8F846579-1857-3D94-9D53-DA98E495AC2E |
| OmniCarAppBridge | 4853EB33-5BC8-3A11-9713-06A35FA57FD2 | D77C839F-9FE5-3ADD-BA13-AD9BC69CBD4C |

Kích thước lát thin: SS arm64 568.160 B / arm64e 584.768 B;
AB arm64 272.880 B / arm64e 289.488 B.

## 4. Kiểm hai lát (đo trên lát thin trích từ chính FAT này)

### 4.1 Kênh bridgewake — 5/5 ở cả hai binary, cả hai lát

`com.anlai.omnicar/bridgewake.v1.{state,query,wake,ack,act}`: mỗi chuỗi đúng 1
bản trong SplitScreen arm64, SplitScreen arm64e, AppBridge arm64, AppBridge
arm64e (4/4 vị trí × 5 kênh). Kênh `.act` (AutoHide) có mặt như thiết kế.

### 4.2 Markers

- SplitScreen (cả hai lát): `[fs1-test]` ×4, `[autohide]` ×9, `[wake1]` ×13,
  `[pinch1]` ×5.
- AppBridge (cả hai lát): `[autohide]` ×2 (log áp fade phía host), chuỗi
  `[bridgewake] host arm/ack …` và `[do] bw cai sendEvent probe` có mặt;
  `[fs1-test]`/`[pinch1]` = 0 (đúng phân bổ — hai marker này chỉ thuộc SplitScreen;
  tiền tố `[wake1]` là của owner phía CarPlay, AppBridge dùng họ `[do] bw`/`[bridgewake]`).

### 4.3 Kênh ytlease — vắng đúng kỳ vọng

`ytlease` và `youtubeVirtualize`: 0 trong cả 8 binary của payload và 0 trong
mọi plist/strings của gói. Bản fs1 đứng trước track YTZ — không rò code YTZ.

### 4.4 publishKnobsNow — đúng 1 eor mỗi lát (SplitScreen)

Khoảng hàm lấy từ IMP trong ObjC metadata (parser của dự án), đếm trên disasm
lọc đúng khoảng:

- arm64: IMP 0x126d4–0x12b20, 275 lệnh, **1 eor tại 0x12940**: `eor w2, w26, #0x1`.
- arm64e: IMP 0x1300c–0x1345c, 276 lệnh, **1 eor tại 0x1327c**: `eor w2, w26, #0x1`.

Cùng mã lệnh (42 03 00 52) ở hai lát — phép lật `!scaled` duy nhất của bản sửa
cực publishKnobsNow giữ nguyên trên FAT (không quay lại lỗi 2-eor của bản cũ).

### 4.5 g1 — dạng csel của appWithHash: (AppBridge, cả hai lát)

Chuỗi suy hướng khớp dạng đã chốt ở fixround6 (bit portrait có mặt → 0):

- arm64 (IMP 0x7460): `and x8, x21, #0x2` @0x75b8 → `cmp x8, #0x0` @0x75dc →
  `csel x8, xzr, x9, ne` @0x75e0; sau đó cổng mask==0 (`csel …, eq`) và cổng
  sentinel 0xFF (`cmp x20, #0xff` @0x75f0).
- arm64e (IMP 0x7758): cùng chuỗi tại 0x78b4 / 0x78d8 / 0x78dc, sentinel @0x78ec.

### 4.6 Selector parity so với FAT wake1 — chỉ thêm, mất 0

Baseline: FAT wake1 ở handover, SHA kiểm lại trên đĩa
`279005f45cb84d340e050461a46b4768fc4226c6edf80709af606004a9c3c2f1` (khớp hồ sơ ship).
Đếm cặp (class, selector) gồm cả class methods bằng cùng một parser cho hai bản:

| Binary | wake1 | fs1 | mất | thêm |
|---|---|---|---|---|
| SplitScreen arm64 | 620 | 664 | **0** | 44 |
| SplitScreen arm64e | 620 | 664 | **0** | 44 |
| AppBridge arm64 | 194 | 197 | **0** | 3 |
| AppBridge arm64e | 194 | 197 | **0** | 3 |

Tập selector của hai lát trong cùng binary: identical (symdiff = 0).
Phần thêm đúng phạm vi hai tính năng: SplitScreen +17 method `ah*` (AutoHide) +
`bwHandleActPacket:` + 24 method của SCPFullscreenController mới +
`SCPFullscreenAdapter -init` + 1 class method; AppBridge +3 method fade phía
host (`applyFade:forPane:`, `setKnobsFade:`, `ahRestorePaneForBundle:`).

## 5. Kết luận mức

- CI: run 42578683063 SUCCESS (foreground-verified).
- FAT fs1: **static PASS trên cả hai lát** cho mọi kiểm được giao (kênh 5/5,
  knob 1-eor, g1 csel, markers, ytlease vắng, parity chỉ-thêm).
- Chưa có bằng chứng runtime/xe — nghiệm thu thuộc phiên gộp fs1 (FS1 qua công
  tắc Prefs + AutoHide + Gate 2 wake + núm + Weather), không tuyên bố gì hơn.
