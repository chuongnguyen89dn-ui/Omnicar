# TÍCH HỢP ytz4 — vòng phán quyết GPT sau phiên ytz3 — Gate-1 tĩnh

Ngày: 2026-11-09. Phạm vi: tương thích kb hai phía + mirror + build
sạch + cổng cũ/mới trên candidate LOCAL arm64. Không git, không CI
(CI FAT là strand riêng). Đầu vào: fix-hb-kb-host-autohide.md,
fix-k2-kb-app.md, fix-i2-homelib.md, fix-y2s-revokesnap.md (cùng thư
mục). Baseline: candidate ytz3 (project/packages/
com.anlai.omnicar_1.0.3-ytz3_iphoneos-arm64.deb, 1,027,106 B) và
source ytz3 tại commit 36135b8 (đọc chỉ-đọc từ clone push9).

## 1. CỔNG SỐ 1 — TƯƠNG THÍCH KB HAI PHÍA: KHỚP TUYỆT ĐỐI, không phải sửa

### 1.1 Hai phía dùng CHUNG một C core — theo cấu trúc, không phải hai bản sao song song

- `BridgeWakePack.h` có 4 bản (project × 2 module + src × 2 cây),
  md5 cả bốn = `17c004e0627fb3f9967e2321695a7b27` — identical từng bit.
- Phía app: `ABInApp.m:24` `#import "BridgeWakePack.h"`, gói state/kb
  vào qua `BWUnpack(raw)` (ABInApp.m:521) rồi rẽ nhánh
  `if (p.type == BWTypeKbState) { BWOnKbPacket(p); return; }` (:523).
  Layout giải mã phía app LÀ layout của core dùng chung.
- Hằng số type giữ local hai phía nhưng cùng một giá trị: host
  `static const uint8_t BWTypeKbSync = 6` (SCPCarSplit+BridgeWake.m:97);
  app `enum { BWTypeKbState = 6 }` (ABInApp.m:417).

### 1.2 Ánh xạ trường kb — nghịch đảo chính xác nhau

- PHÁT (host, BWEmitKbPacket, BridgeWake.m:190-198):
  `kbField = (kbKnown ? 0x2 : 0) | (kbActive ? 0x1 : 0)` rồi
  `BWPackFields(hash28, seq, gen, flag=NO, pinchMode=kbField,
  wakeMode=0, state=0, type=6)`.
  → bit 9 = kbKnown, bit 8 = kbActive (vị trí pinchMode), còn lại 0.
- THU (app, BWOnKbPacket, ABInApp.m:448-458) trên BWPacket đã BWUnpack:
  `known = (p.pinchMode >> 1) & 1` (bit 9);
  `active = known && (p.pinchMode & 1)` (bit 8, bị bỏ khi known=0).
  Đúng phép nghịch của kbField, gồm cả kỷ luật gói lỗi (known=0 mà
  bit active=1 → active bị bỏ — ca K3 của strand app).

### 1.3 Chứng minh bằng số — đóng gói lại qua core thật

Harness C biên dịch bằng clang-18 với `BW_PACK_NO_FOUNDATION`, include
CHÍNH header của dự án (chạy riêng với bản header của SplitScreen và
bản của AppBridge — kết quả hai lần giống hệt nhau):
- Hồi quy core: V1 = 0xE9DA706832803859, V9 = 0xE9DA706800803805,
  V10 = 0xE9DA706801003C05 — PASS cả ba (state/act không đổi một bit).
- Cả 5 word kb của hai strand đều tái lập ĐÚNG từ bộ tham số đã khai,
  và BWUnpack + phép trích của BWOnKbPacket cho lại đúng từng trường
  (valid=1, hash28=0xD3B4E0D, flag=0, wakeMode=0, state=0, type=6):

| Word | seq | gen | pm | kbKnown | kbActive | Nguồn |
|---|---|---|---|---|---|---|
| 0xE9DA706803801B06 | 7 | 3 | 3 | 1 | 1 | host |
| 0xE9DA706804001A06 | 8 | 3 | 2 | 1 | 0 | host |
| 0xE9DA706804801806 | 9 | 3 | 0 | 0 | 0 (UNKNOWN) | host |
| 0xE9DA706800803B06 | 1 | 7 | 3 | 1 | 1 | app K1 |
| 0xE9DA706801003A06 | 2 | 7 | 2 | 1 | 0 | app K2 |

- Đóng gói CÙNG một bộ tham số (hash28 yt, seq=7, gen=3, known=1,
  active=1) theo mô tả của cả hai phía → cùng một word
  0xE9DA706803801B06, IDENTICAL.
- Gói lỗi pm=1 (known=0, bit active=1): app đọc known=0/active=0 — PASS.

**Phán quyết:** hai bộ vector khác nhau CHỈ vì tham số khác nhau
(host chạy gen=3 với seq 7/8/9; harness app chạy gen=7 với seq 1/2).
Layout — header valid/hash28/seq/gen, type=6, bit9=kbKnown,
bit8=kbActive — khớp tuyệt đối ở mọi trường. Không có lệch layout,
không phải sửa phía app.

## 2. Mirror project/ ↔ src/ — không lệch do strand, không phải chép

15 cặp file của 4 strand cmp identical: BridgeWake.m/.h, AutoHide.m,
SCPShared.h/.m (SplitScreenA); SCPHooks.m (SplitScreenA),
SCPAppIcons.m (SplitScreenC); ABInApp.m, ABYTZoom.m, ABHostGeometry.m,
ABChannelNames.m, AppBridgeB.h, ABHost.h-bản-B (AppBridgeB);
ABHostLaunch.m (AppBridgeA/src). Hai khác biệt ĐỨNG TỪ TRƯỚC, không
phải lệch của vòng này, giữ nguyên cả hai phía:
- SCPHomeApply.m: khác đúng 1 dòng import (:18 — project dùng đường
  phẳng có chú thích `[phase3 sync]`, src giữ `../SplitScreenB/`);
  toàn bộ phần còn lại (gồm mọi dòng I2 cộng) identical.
- ABHost.h bản A (src/AppBridgeA/src): vốn khác bản B từ các vòng
  trước (không phải cặp mirror); khai báo `ABKbSyncNoteEvent` có mặt
  ở cả 3 bản header (project, B, A — mỗi bản 1 lần).

## 3. Toolchain + build + candidate

Toolchain kiểm trước: nguyên vẹn, không cần fix — clang-18
18.1.3-1ubuntu1; ldid /usr/local/bin/ldid; /usr/bin/ld.lld ->
ld.lld-18; dpkg có clang-18/lld-18/fakeroot; ~/theos + SDK
iPhoneOS16.5. `make clean && make package FINALPACKAGE=1`
(umask 022, THEOS=~/theos): EXIT=0, 0 dòng `error:`.

Candidate:
- `com.anlai.omnicar_1.0.3-ytz4_iphoneos-arm64.deb`
- Size: **1,031,204 B** — SHA-256:
  **27ecedd4039c986262a051ad459d8dfe49881d1981ded82f7d27fd1fd98b9bbb**
- ar members: debian-binary + control.tar.gz + data.tar.lzma.
- control: IDENTICAL ytz3 từng dòng (Package com.anlai.omnicar,
  Version 1.0.3, iphoneos-arm64, Installed-Size 3764).
- Dylib đổi size: AppBridge 342,992 -> 343,184 (+192);
  SplitScreen 656,640 -> 656,816 (+176); StartupScreen giữ nguyên.

## 4. Cổng cũ (trên DEB đã bung, ytz4 vs ytz3)

### 4.1 File list: 179 = 179 mục, diff danh sách đã sort = RỖNG.

### 4.2 Parity selector (unique __objc_methname) — 0 MẤT ở cả 8

| Thành phần | ytz3 | ytz4 | Mất | Thêm |
|---|---|---|---|---|
| App | 120 | 120 | 0 | 0 |
| AppBridge | 798 | 807 | 0 | +9 |
| CarProbe | 117 | 117 | 0 | 0 |
| Core | 137 | 137 | 0 | 0 |
| Prefs | 1719 | 1719 | 0 | 0 |
| SpeedBubble | 794 | 794 | 0 | 0 |
| SplitScreen | 1395 | 1398 | 0 | +3 |
| StartupScreen | 730 | 730 | 0 | 0 |

AppBridge +9 truy hết vào Y2S: revokeSnapPending / revokeSnapAt +
hai setter + hai ivar + hai type-encoding (property của
ABYTLeaseRecord) và `appendFormat:` (dựng chuỗi snapshot). Phía app
của kb (K2) dùng hàm C static nên không thêm selector — đúng thiết kế.
SplitScreen +3: `bwHandleKbSyncNote:`, `bwKbEmitForPane:` (owner kb
của HB) + `unsignedIntValue` (selector hệ thống được code mới tham
chiếu).

### 4.3 g1/g2/h/f + knob (arm64) — PASS, hàm không đổi

Phương pháp: IMP lấy từ method-list walk (positive control: IMP ytz3
tái lập đúng 0x7e34 g1 / 0xc1a4 h / 0x16504 knob của biên bản ytz3);
so dòng lệnh đã chuẩn hoá (bỏ displacement bộ nhớ, trang adrp, đích
nhảy — giữ nguyên immediate của idiom) giữa ytz3 và ytz4:
- g1 appWithHash: IMP 0x7e34 -> 0x7e40; 209 lệnh hai phía, diff = 0.
  Ba idiom còn nguyên trong ytz4: cmp x8,#0 -> csel x8,xzr,x9,ne;
  cmp x25,#0 -> csel x8,xzr,x8,eq; cmp x21,#0xff -> csel x2,x8,x21,eq.
- g2 (hàm suy orientation): idiom tst x0,#0x10 ... tst x0,#2 ->
  csel x9,x8,xzr,eq là hit DUY NHẤT ở cả hai bản (ytz3 @0x18274 —
  khớp funcstart biên bản cũ; ytz4 @0x185d8); 95 lệnh, diff = 0.
- h setBarVisible: IMP 0xc1a4 -> 0xc1b0; 266 lệnh, diff = 0
  (C-A/C-B nguyên vẹn theo cấu trúc).
- f (lọc {3,4}): idiom sub x8,x24,#3 -> cmp x8,#2 ->
  csel x2,xzr,x24,lo hit duy nhất @0x5d84 ở cả hai bản; 443 lệnh,
  diff = 0.
- knob publishKnobsNow (SplitScreen): IMP 0x16504 cả hai bản;
  356 lệnh, diff = 0; **đúng 1 eor** `eor w2, w27, #1` cả hai bản.

### 4.4 Bốn hash cấm ABHost (sha256 thân hàm source) — PASS cả 4

Công thức (suy ngược và kiểm chéo): sha256 của khoảng dòng nối bằng
\n cộng \n cuối. Trên ABHostBMethods.m hiện tại (hai cây identical):
setFrame (629-665) 8606f40a…, setBarVisible (1126-1160) 3044b10d…,
setHandleVisible (1224-1229) 409cfb14…, setKnobs (1453-1551)
b98a9f26… — khớp tuyệt đối 4/4 giá trị đã ghi ở các vòng trước.

### 4.5 hostFrameInfo — 30 key, KHÔNG đổi (kb đi kênh riêng, đúng dự báo)

Trích từ builder -hostFrameInfo:pane:live:handle: (SCPCarSplit.m:2091)
+ hostBarInfo merge (:2107): 11 gốc (identifier/x/y/w/h/live/handle/
pt/pl/pb/pr) + 4 bar (bar/pop/popDim/single) + fade + split +
splitver + r/corners/hx/front + ox/oy/ow/oh + ax/ay/aw/ah = **30 key,
tập giống hệt ytz3**. `split` vẫn từ presentation predicate
(:2131: active && paneCount>=2 && zoomedSlot==nil), splitver=@1
(:2132). Không key kb nào trong frame info — kb đi kênh
appbridge.kbsync riêng (mục 5.1).
Điểm ghi requestedOrientation CÓ GIÁ TRỊ vẫn duy nhất
ABHostBMethods.m:607; ABYTZoom chỉ gán 0 (:428, :477 — hai điểm dọn
lease, đã dịch dòng do Y2S cộng).

### 4.6 Kênh Darwin trong binary — nguyên vẹn + kênh mới

bridgewake.v1.{state,query,wake,ack,act}: mỗi kênh x1 trong CẢ
AppBridge và SplitScreen, ytz3 = ytz4. ytlease + ytleaseack: chỉ
AppBridge (x1 mỗi kênh theo tên đầy đủ), SplitScreen không chứa —
y hệt ytz3.

## 5. Cổng mới vòng này

### 5.1 Kênh kb-sync + type kb — PASS
- Chuỗi `com.anlai.omnicar/appbridge.kbsync`: AppBridge x1,
  SplitScreen x1 trong candidate ytz4; ytz3 = 0 cả hai.
- Type kb = 6 cả hai phía (mục 1): host BWTypeKbSync,
  app BWTypeKbState — cùng giá trị trên cùng kênh state.

### 5.2 Ba ràng buộc AutoHide-EXPANDED đã gỡ — PASS ở source
- `ahSetSuspended` trong SCPCarSplit+BridgeWake.m: **0 lời gọi**
  (chỉ còn 1 lần nhắc trong comment :449 ghi việc đã gỡ). Toàn
  module, điểm gọi thật còn lại: định nghĩa AutoHide.m:273 (+ bounce
  main-thread :276) và HAI điểm hosted-solo SCPCarSplit.m:2019
  (YES) / :2039 (NO) — solo giữ nguyên theo lệnh GPT.
- Hạng tử expanded trong ahFadeBlockedReason: thân hàm hiện tại
  chỉ còn "solo" / "kbhold" / "surface-open" / "dragging" —
  **không còn return "expanded"** (chữ expanded chỉ nằm trong
  comment giải thích). Khoá popup/dragging/bàn phím giữ nguyên.
- Khối nâng HIDDEN->VISIBLE theo cờ expanded:
  grep `BWStateHidden && bwExpandedFlag` toàn module = **0**.

### 5.3 Chuỗi instrument mới trong binary đúng module — PASS
- SplitScreen: `[homelib]` đúng **5 format** (new-library,
  loadFromProxy, decision, OMNI, apply-published) — khớp 5/5 của
  fix-i2; `[kb-sync]` 3 format (emit/change/drop).
- AppBridge: `[kb-sync]` 1 format (host post); `[ytz-revoke-snap]`
  2 format, `[ytz-nextlayout]` 1 format, `prevRevoke=` 1,
  `lastDecl=unavailable` 1 — khớp fix-y2s. Tất cả = 0 ở ytz3.

### 5.4 MSHookMessageEx SplitScreen — 31, KHÔNG tăng
Source call-site: 31 (SCPHooks.m + SCPSpringBoardHooks.m +
SCPTouchProbe.m — I2 chỉ cộng log trong hook sẵn có). Binary:
30 bl + 1 b (tail) vào stub _MSHookMessageEx ở cả hai bản
(ytz3 stub 0x6421c — khớp biên bản ytz3; ytz4 stub 0x651f8).

### 5.5 Diff I2/Y2S so baseline ytz3 (commit 36135b8) — thuần cộng
- I2: SCPHooks.m **+48/-0**, SCPAppIcons.m **+58/-0**,
  SCPHomeApply.m **+20/-0** — khớp tuyệt đối tự khai của strand.
- Y2S: ABYTZoom.m **+134/-2**; hai dòng "-" đã đọc tận nơi: là hai
  nửa của ĐÚNG MỘT format-string của lời gọi log grant cũ
  (`"[ytz] lease cap gen=%lu size=%gx%g split=%d"` + dòng đóng) bị
  nới thành `split=%d%@` để cộng trường prevRevoke — không câu lệnh
  nào bị xoá/sửa. Thuần cộng về hành vi.
- (Ngoài yêu cầu thuần cộng, ghi để đối chiếu: HB/K2 sửa hành vi
  nên có xoá theo thiết kế — BridgeWake.m +172/-14, ABInApp.m
  +159/-18, AutoHide.m +9/-3; ba dòng "-" của AutoHide đã đọc tận
  nơi: dòng `return "expanded"` + 2 dòng comment của nó, đúng điểm
  GPT ra lệnh gỡ.)

## 6. Giới hạn trung thực của vòng tích hợp này
- Candidate LOCAL arm64-only (VM hạ arm64e); mọi số parity/địa chỉ
  ở trên là lát arm64. Bản FAT hai lát thuộc strand CI riêng.
- Cổng kb ở §1 là tương thích TĨNH (core + harness trên VM). Gate 3
  vẫn ĐÓNG theo GPT: chưa có bằng chứng xe về chuỗi nuốt trọn
  (nuốt -> chạm kế vào app -> nhập liệu -> teardown).
- [homelib] và [ytz-revoke-snap] là instrument: giá trị của chúng
  nằm ở log phiên xe kế, không phải ở vòng tĩnh này.

## 7. Verdict Gate-1 (tĩnh)
PASS toàn bộ: Cổng số 1 kb khớp tuyệt đối (chứng minh bằng core
thật, không phải sửa); mirror không lệch do strand; build sạch;
parity 0 mất (+9/+3 đúng thiết kế); g1/g2/h/f + knob + 4 hash +
hostFrameInfo 30 key + điểm ghi orientation duy nhất + kênh cũ:
nguyên vẹn; cổng mới: kbsync hai module, ba ràng buộc EXPANDED đã
gỡ ở source, chuỗi instrument đúng module/đúng số, hook 31 không
tăng, diff I2/Y2S thuần cộng. Candidate sẵn sàng cho strand CI FAT.
Trạng thái tổng: source complete / static PASS — device PASS do
Nguyen test quyết.
