# TÍCH HỢP ytz3 — vòng sửa sau log (4 strand GPT WO) — Gate-1 tĩnh

Ngày: 2026-11-09. Phạm vi: mirror + build sạch + cổng cũ/mới trên
candidate LOCAL arm64. Không git, không CI (CI FAT là strand riêng).
Đầu vào: fix-g-fsguard.md, fix-np-nativefeed.md, fix-i-iconwhite.md,
fix-w-weatherinst.md (cùng thư mục). Baseline so sánh: candidate ytz2
(project/packages/com.anlai.omnicar_1.0.3-ytz2_iphoneos-arm64.deb,
1,021,310 B, SHA-256 4ce2c123…) và source ytz2 tại commit a763030
(đọc từ clone push9, chỉ-đọc).

## 1. Mirror project/ ↔ src/ — 9/9 GIỐNG HỆT, không phải sửa

| File | Kết quả |
|---|---|
| SCPFullscreenController.m (SplitScreen ↔ SplitScreenA) | identical |
| SCPFullscreenController.h | identical |
| SCPTouchProbe.m | identical |
| SCPTouchProbe.h | identical |
| SCPCarApps.m (SplitScreen ↔ SplitScreenC) | identical |
| SCPCarSplit.m | identical |
| SSSplash.m (StartupScreen) | identical |
| SSStartupScreen.m | identical |
| SSStartupView.m | identical |

## 2. Toolchain + build

Toolchain kiểm trước build: NGUYÊN VẸN (không cần fix-toolchain):
clang-18 = Ubuntu clang 18.1.3 (1:18.1.3-1ubuntu1); ldid tại
/usr/local/bin/ldid; /usr/bin/ld.lld -> ld.lld-18; dpkg có
clang-18/lld-18/fakeroot; ~/theos + SDK iPhoneOS16.5 đầy đủ.

`make clean` + `make package FINALPACKAGE=1` (umask 022,
THEOS=~/theos): EXIT=0, 0 dòng `error:` (warning = các warning cũ
đã biết). Candidate:

- Tên: com.anlai.omnicar_1.0.3-ytz3_iphoneos-arm64.deb
- Đường dẫn: project/packages/com.anlai.omnicar_1.0.3-ytz3_iphoneos-arm64.deb
- Size: 1,027,106 B — SHA-256:
  b6c5f32864eed1d471632b1bcb73708553c7100adf8443e791d044400f5e9414
- ar members: debian-binary + control.tar.gz + data.tar.lzma
- control vs ytz2: KHÁC DUY NHẤT Installed-Size 3748 -> 3764
  (Package/Version/Architecture/Depends giống hệt).
- Dylib đổi size: SplitScreen 639,888 -> 656,640 (+16,752);
  StartupScreen 299,680 -> 299,744 (+64); 4 dylib còn lại và
  Prefs/app giữ nguyên size.

## 3. Cổng cũ (trên DEB đã bung, ytz3 vs ytz2)

### 3.1 File list: 176 = 176 file, diff danh sách đã sort = RỖNG.

### 3.2 Parity selector (unique __objc_methname) — 0 MẤT ở cả 8

| Thành phần | ytz2 | ytz3 | Mất | Thêm |
|---|---|---|---|---|
| App | 120 | 120 | 0 | 0 |
| AppBridge | 798 | 798 | 0 | 0 |
| CarProbe | 117 | 117 | 0 | 0 |
| Core | 137 | 137 | 0 | 0 |
| Prefs (bundle) | 1719 | 1719 | 0 | 0 |
| SpeedBubble | 794 | 794 | 0 | 0 |
| SplitScreen | 1388 | 1395 | 0 | +7 |
| StartupScreen | 730 | 730 | 0 | 0 |

SplitScreen +7 (đúng các selector vòng này cần): CGPointValue,
convertPoint:toCoordinateSpace:, fsRefusalSnapshot:,
fsTraySurfaceBusy:, pointerValue, timestamp, valueWithCGPoint:.

### 3.3 g1/g2/h/f (AppBridge, arm64) — PASS, địa chỉ + dạng y hệt ytz2

- g1, -[ModuleB appWithHash:changedOrientation:supportedMask:]
  IMP 0x7e34 (209 lệnh, diff toàn hàm so ytz2 = 0): @0x8078 cmp x8,#0
  -> @0x807c csel x8,xzr,x9,ne; @0x8080 cmp x25,#0 -> @0x8084 csel
  x8,xzr,x8,eq; @0x8088 cmp x21,#0xff -> @0x808c csel x2,x8,x21,eq.
- g2 (hàm suy orientation chứa @0x18348, funcstart 0x18274, 95
  lệnh, diff = 0): @0x18348 tst x0,#2 -> @0x1834c csel x9,x8,xzr,eq;
  phía trước cùng idiom tst #0x10 @0x1833c.
- h C-A, setBarVisible:pop:dim:single:forApp: IMP 0xc1a4 (IMP kế
  0xce28): @0xc438 cmp w0,w22 -> b.ne. h C-B (khối @0xcdc8 cùng
  IMP): @0xcde8 fmov d0,#1.0 -> @0xcdec bl -> @0xce14 bl. Cả hai
  khối diff so ytz2 = 0.
- f (hàm chứa @0x5fb0, 0x5d84..0x6470, diff = 0): @0x5fb0 sub
  x8,x24,#3 -> @0x5fb4 cmp x8,#2 -> @0x5fb8 csel x2,xzr,x24,lo
  (lọc {3,4} nguyên vẹn).

### 3.4 Knob: publishKnobsNow — PASS

IMP ytz3 0x16504 (ytz2 0x15bcc), 356 lệnh cả hai, ĐÚNG 1 eor:
@0x16868 `eor w2, w27, #1` (ytz2 cùng dạng @0x15f30).

### 3.5 Bốn hash thân hàm ABHost (cả 2 cây giống nhau) — PASS

- setFrame:forApp:live:handle:passInsets: (ABHostBMethods.m:629-665)
  8606f40a1ebf5ecad131ae276a227220a02c0e20c2a2c5c1ec2dbef0398341ef
- setBarVisible:pop:dim:single:forApp: (:1126-1160)
  3044b10d090281f54db3271da2117c36c69c8e616cda24d2485f5877f812ba38
- setHandleVisible:forPane: (:1224-1229)
  409cfb1447cb968976562e6a2e2a6f28cec7cdb6d1e13cb3e6f5ad1a27208a58
- setKnobs: (:1453-1551)
  b98a9f2611e0ef11849d0b4d26a2cb9209892eb31cc9cb526c340f1b7b41ecc4

### 3.6 hostFrameInfo superset + điểm ghi orientation — PASS

Builder -hostFrameInfo:pane:live:handle: (SCPCarSplit.m:2091):
11 key gốc (identifier/x/y/w/h/live/handle/pt/pl/pb/pr) + 4 key
hostBarInfo (bar/pop/popDim/single) + fade + split + splitver +
r/corners/hx/front + ox/oy/ow/oh + ax/ay/aw/ah (khi có tabParent)
= đủ 30 key của ytz2, không mất key nào; `split` vẫn tính từ
presentation predicate active && paneCount>=2 && zoomedSlot==nil
(:2131), splitver=@1 (:2132).
Điểm ghi requestedOrientation CÓ GIÁ TRỊ duy nhất:
ABHostBMethods.m:607 trong appWithHash:; ABYTZoom.m chỉ gán 0 tại
:324/:368 (dọn lease — nguyên trạng ytz2).

### 3.7 Kênh Darwin — nguyên vẹn, giống ytz2 từng chuỗi

bridgewake.v1.{state,query,wake,ack,act}: mỗi kênh x1 trong CẢ
AppBridge và SplitScreen (ytz2 = ytz3). ytlease:
com.anlai.omnicar/appbridge.ytlease + ...ytleaseack, mỗi x1 trong
AppBridge (SplitScreen không chứa — đúng như ytz2).

## 4. Cổng mới vòng này

### 4.1 Chuỗi trong binary đã bung — PASS toàn bộ

SplitScreen.dylib (đếm format trong __cstring):
- [probe-feed]: 8 format (drop-inactive, drop-unconverted,
  drop-display, drop-systemregion, drop-popup(%@), drop-notassigned,
  drop-hosted, fired) — mỗi x1.
- [touchset]: 1 format.
- [applib]: 8 format (live-grid-read, bridged-rebuild,
  chosen-not-installed, library-walk, picker-native, picker-chosen
  x2 dạng, publish-for-settings).
- [scenevis]: 1 format dùng chung mọi event.
- snap{: 1 format —
  snap{tw=%d twh=%@ to=%d tray=%d picker=%d ratio=%d dg=%d
  toast=%d rz=%d fc=%d phase=%ld}.
- Marker cũ còn nguyên: [probe] 3, [fs-diag] 3, [fs1] 16,
  [pinch1] 5.

StartupScreen.dylib: [weather] = ĐÚNG 17 format (req begin /
ask-springboard / retry-post / timeout-no-answer / answer-received
/ applied / direct-fix / none / initial-cache / warming-cache /
ans begin / dropped in-flight / fetch-begin / ready-posted /
answered-without-weather / darwin-received / display) — khớp
17/17 của fix-w.

### 4.2 Vị từ guard cũ = 0 trong source controller

grep `trayWindow || split.trayOverlay` (dạng trần) trong
SCPFullscreenController.m: 0 hit. trayOverlay chỉ còn xuất hiện ở
helper snapshot (:305, đọc-để-log) và comment giải thích (:274,
:296) — không còn là điều kiện chặn.

### 4.3 MSHookMessageEx SplitScreen — 31, KHÔNG tăng

Source call-site: SCPHooks.m 29 + SCPSpringBoardHooks.m 1 +
SCPTouchProbe.m 1 = 31 (các dòng comment nhắc tên hàm không chứa
dấu ngoặc nên không lẫn vào đếm). Binary: gọi tới stub
_MSHookMessageEx = 30 bl + 1 b (tail) = 31, y hệt ytz2 (địa chỉ
stub đổi 0x614bc -> 0x6421c do binary lớn lên).

### 4.4 Diff thuần cộng của 2 strand instrument — PASS

Đối chiếu source hiện tại với baseline ytz2 (commit a763030, đọc
chỉ-đọc từ clone push9):

| File | Xoá | Thêm | Biên bản strand |
|---|---|---|---|
| SCPCarApps.m | 0 | +57 | 0 xoá (68 dòng diff) |
| SCPCarSplit.m | 0 | +55 | 0 xoá (66 dòng diff) |
| SSSplash.m | 0 | +26 | +26, 0 xoá |
| SSStartupScreen.m | 0 | +18 | +18, 0 xoá |
| SSStartupView.m | 0 | +7 | +7, 0 xoá |

Ba file Weather khớp số TUYỆT ĐỐI; hai file fix-i khớp khẳng định
0-xoá (số dòng thêm thuần nhỏ hơn con số "dòng diff" của strand vì
strand đếm cả dòng ngữ cảnh/hunk — nội dung thêm là đúng các điểm
[applib]/[scenevis] đã kê). Ngoài phạm vi instrument:
SCPTouchProbe.m +326/-0; SCPTouchProbe.h +13/-3 (chỉ comment vai
trò); SCPFullscreenController.m +62/-11 (thay vị từ + gắn snapshot
vào các dòng log từ chối — đúng phạm vi fix-g).

## 5. Truy vết tĩnh vòng này

### 5.1 Guard (SCPFullscreenController.m, fsExpand...)

Chuỗi vị từ hiện tại: inactive -> host-unavailable -> zoomed ->
solo -> pickerSheet (:349, reason=picker) -> [split popupOpen]
(:350, reason=popup; popupOpen = panelOpen || anyBarVisible,
Chrome.m:393-394, panelOpen :388 = tray||ratioMenu||pickerSheet)
-> fsTraySurfaceBusy: (:351, reason=tray). Helper fsTraySurfaceBusy:
(:287) = dragGhost != nil HOẶC trayWindow còn toast tag 0x5c9b.
Mọi điểm từ chối đều kèm fsRefusalSnapshot: (:299; gắn tại :327,
:334, :355, :369, :460, :474).

- (a) Picker mở -> đóng hẳn -> expand QUA ĐƯỢC nhánh tray:
  removePickerSheet (Picker.m:647) gán pickerSheet = nil ngay đầu
  (:651), tray/ratioMenu/dragGhost đều nil, không toast ->
  :349 không chặn, panelOpen = NO, fsTraySurfaceBusy = NO. Cửa sổ
  tray giữ lại (ẩn) và trayOverlay=YES dính KHÔNG còn tham gia vị
  từ. (Nếu thanh bar đang hiện, :350 chặn reason=popup — lý do
  khác, hợp lệ, đúng ghi chú fix-g.)
- (b) Popup mở THẬT -> vẫn chặn: pickerSheet != nil -> :349
  reason=picker; tray/ratioMenu mở -> panelOpen -> :350
  reason=popup; drag ghost/toast -> :351 reason=tray.

### 5.2 Feed (SCPTouchProbe.m, SCPProbeFeedEvaluate :268)

Thứ tự cổng đúng brief GPT mục 2, mỗi cổng một dòng drop:
active (:273 drop-inactive) -> đổi tọa độ được (:280
drop-unconverted; đổi touch.window -> screen space) -> cùng màn
CarPlay (:287 drop-display: touchScreen == screen của
split.container.window) -> vùng hệ thống (:294 drop-systemregion:
DBStatusBarWindow mọi điểm + góc Home 48pt mọi cửa sổ) -> popup
(:302 drop-popup(sub): picker/tray/traywindow/ratio/drag/resize)
-> pane còn gán sống theo hình học screen-space (:311
drop-notassigned) -> pane hosted (:318 drop-hosted, F4 tự lo) ->
FIRED. Nhãn foreign KHÔNG phải cổng. Điểm gọi ahNoteActivity:
DUY NHẤT trong TU: :324 `[split ahNoteActivity:AHSourceContainer]`
(2 hit còn lại là comment :15 và :55). Không nuốt/không chặn chạm:
hook gọi orig trước, sự kiện nguyên vẹn (theo fix-np, mã nguồn
đã đọc). Hai khoảng API fix-np đã tự khai và giữ nguyên khi tích
hợp: (1) nguồn gắn nhãn AHSourceContainer (chưa có tag riêng cho
probe — muốn có phải sửa header AutoHide); (2) "generation" là
epoch của probe neo trên container/window/active (bwGenBySlot nằm
file-static trong BridgeWake, không lộ ra) — epoch in trong MỌI
dòng [probe-feed].

## 6. Giới hạn trung thực của vòng tích hợp này

- Candidate LOCAL arm64-only (VM hạ arm64e); parity/địa chỉ trên
  là slice arm64. Bản FAT hai lát thuộc strand CI riêng.
- Weather: req# <-> ans# tương quan theo THỨ TỰ + THỜI GIAN (kênh
  request không mang id — sự thật giao thức fix-w đã đọc từ mã);
  chuỗi [weather] đầy đủ chỉ chứng minh được khi có log máy.
- Toast còn trên tray window = "bận" theo đúng định nghĩa idle của
  chính module (hideTrayWindowIfIdle); bỏ term này là sửa 1 dòng
  nếu GPT phán khác.
- Chưa có kết quả máy: feed native, guard sau sửa, touchset dedupe,
  applib/scenevis, weather — tất cả chờ phiên test gộp trên xe.

## 7. Verdict Gate-1 (tĩnh)

PASS toàn bộ: mirror 9/9; build sạch; parity 0 mất (+7 đúng thiết
kế); g1/g2/h/f + knob + 4 hash + superset + sole-writer + kênh:
nguyên vẹn; cổng mới: đủ chuỗi/số đếm; diff instrument thuần
cộng. Candidate sẵn sàng cho strand CI FAT. Trạng thái tổng:
source complete / static PASS — device PASS do Nguyen test quyết.
