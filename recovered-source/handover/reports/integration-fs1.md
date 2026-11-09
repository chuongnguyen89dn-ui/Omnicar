# TÍCH HỢP FS1 + AUTOHIDE — 3 điểm nối cuối + chuẩn hoá + candidate + Gate 1

Ngày: 2026-11-09. Nguồn việc: design-fullscreen-fs1 §10,
design-autohide §5.4, impl-fs-controller / impl-fs-glue /
impl-fs-prefs / impl-autohide-car1 / impl-autohide-car2 (§3–§4 điểm
ngỏ) / impl-autohide-host / impl-autohide-app. Trạng thái: **source
tích hợp xong, candidate arm64 đóng xong, Gate 1 tĩnh trên candidate
ĐẠT toàn bộ mục kiểm**. Chưa CI FAT, chưa đẩy git, chưa lên xe.

## Candidate

- Path: `project/packages/com.anlai.omnicar_1.0.3-fs1_iphoneos-arm64.deb`
- Size: **1.006.126 B** (wake1: 994.274 B; +11.852 B = FS + AutoHide);
  SHA-256: `0a9f76b34bae40d118123c2a8251bd29635e597a8d8c4cac31337901e829a755`
- Đóng bằng Theos `make package FINALPACKAGE=1` tại gốc project sau
  `make clean; make` toàn bộ (toolchain kiểm trước: clang-18, ldid,
  ld.lld→ld.lld-18, SDK 16.5 — đủ, không khôi phục; build 0 error,
  không warning nào chạm file FS/AutoHide/Drag/ABChannelNames).
- control: `dpkg-deb -f` đối chiếu wake1 — **identical trừ
  Installed-Size** (3696 vs 3660). Package/Version 1.0.3/Depends giữ
  nguyên. Định dạng member lzma như mọi candidate local + bản FAT đã
  qua máy. arm64-only (VM hạ arm64e); FAT chờ CI.

## 1. Ba điểm nối còn thiếu (chỉ cộng; baseline chụp tại /tmp/fs1-integ-baseline/)

Cả hai cây, mirror cmp identical sau sửa; diff so baseline toàn cộng:

| Điểm | File:line (project/) | Nội dung |
|---|---|---|
| (a) Feed kết thúc kéo pane | `SCPCarSplit+Drag.m` :11 (import) + :202 | `ahNoteActivity:AHSourceDragEnd` ở cuối `endPaneDrag:` — phễu kéo pane tự feed, không phụ thuộc feed có guard `resizing` của `endResize` (đường khác có thể đã tiêu thụ). `ahNoteActivity:` idempotent, không log theo feed → feed trùng vô hại. `cancelPaneDrag` vẫn dựa vào feed của `endResize` như thiết kế |
| (b) Treo AutoHide khi solo hosted | `SCPCarSplit.m` hostSolo: +1 dòng sau `soloHostedBundle = bundleID`; endHostedSolo +1 dòng sau `= nil` | `[self ahSetSuspended:YES]` (TU tự khôi phục mờ trước khi solo tiếp quản — §4.1) / `[self ahSetSuspended:NO]` (resume + đồng hồ 4,0 s mới). Hai hàm này là phễu set/clear duy nhất của `soloHostedBundle` trong phiên sống; `dashboardInvalidated` xoá ivar trực tiếp nhưng `ahSessionTeardown` cùng method reset cả `ahSuspendedState` + timer nên trạng thái treo không rò qua phiên |
| (c) Hằng kênh act phía AppBridge | `ABChannelNames.m` :53 (+ cập nhật comment "four"→"five") | `ABNotifyBWAct = "com.anlai.omnicar/bridgewake.v1.act"` — byte-identical với SCPShared.m + static của ABInApp; ABHost không tiêu thụ act, hằng tồn tại cho đủ registry (đúng vai trò strand ABHost đã ghi) |

## 2. Chuẩn hoá

- **BridgeWakePack.h**: hai bản module lệch thật nhưng **chỉ ở
  comment** (danh sách kênh + cách diễn đạt V9/V10; code-only diff =
  0 ngoài vệt trắng). Chuẩn hoá theo tiền lệ wake1: lấy bản
  SplitScreen làm chuẩn chép identical — **4 vị trí md5
  `17c004e0627fb3f9967e2321695a7b27`** (project×2 + src×2).
- **Harness vector trên header cuối** (clang-18, include path từng
  module): **15/15 PASS ở cả hai module** — hash yt/vm, V1–V10 pack
  khớp hex thiết kế (V9 `0xE9DA706800803805`, V10
  `0xE9DA706801003C05`), unpack round-trip V9/V10, V8 invalid,
  `BWTypeAct == 5`.
- **Chuỗi 5 kênh** `bridgewake.v1.{state,query,wake,ack,act}`:
  byte-equal tại cả 3 nơi định nghĩa (SCPShared.m / ABChannelNames.m
  / statics ABInApp.m), mỗi chuỗi đúng 3 lần ở cây project, cây src
  tương ứng cmp identical.
- **Makefile**: SplitScreen FILES có đủ `SCPFullscreenController.m`
  + `SCPFullscreenAdapter.m` + `SCPCarSplit+AutoHide.m` (mỗi TU đúng
  1 lần); AppBridge không cần TU mới (host/app đều vào TU sẵn có) và
  FILES chứa đủ ABChannels/ABHostBMethods/ABInApp/ABChannelNames.

## 3. Gate 1 trên candidate (bung DEB ra kiểm; baseline r7 FAT lát arm64 + wake1 candidate)

| Cổng | Kết quả | Bằng chứng |
|---|---|---|
| Selector parity 8 thành phần vs r7 **và** vs wake1 | **PASS — mất 0** | __objc_methname: AppBridge 705→716→**725** (+9 AutoHide host: applyFade:forPane:, setKnobsFade:, ahRestorePaneForBundle: + refs); SplitScreen 1093→1317→**1385** (+68: bề mặt ah*/fs*/bwHandleActPacket: + ivar controller + refs); 6 thành phần còn lại +0 so wake1 |
| Danh sách file / dylib lạ | **PASS** | File list ≡ wake1 (176 file); đúng 6 dylib chuẩn; 0 file QA19/QA20/DoubleTap/YouTubeHandle/NativeSolo; Prefs plist trong gói có switch `fullscreenTestExpand` default **false** |
| g1 — host appWithHash csel | **PASS** | AppBridge @0x7fb4 `and x8,x24,#0x2` → @0x7fd8 `cmp x8,#0` → @0x7fdc `csel x8,xzr,x9,ne`; mask==0 → 0 (@0x7fe4); sentinel @0x7fe8 `cmp x21,#0xff` → `csel eq` |
| g2 — app derivation csel | **PASS** | @0x173bc–173d4 ưu tiên bit 0x10→4, 0x8→3; @0x173d8 `tst x0,#0x2` → @0x173dc `csel x9,x8,xzr,eq` (bit portrait có mặt → 0) |
| h — host-bar C-A | **PASS** | setBarVisible (ABHost, IMP 0xc130) @0xc3c4 `cmp w0,w22` → @0xc3c8 `b.ne` thoát: chỉ chuyển khi isHidden == visible |
| h — host-bar C-B | **PASS** | Block vào @0xcd60: `fmov d0,#1.0` @0xcd74 → setAlpha: @0xcd78 → nạp transform từ capture → setTransform: @0xcda0 (alpha=1 TRƯỚC transform, đúng sub_125C0 gốc) |
| f — lọc orientation {3,4} | **PASS** | @0x17038 `sub x8,x21,#0x3` → `cmp #0x2` → @0x17040 `csel x8,x21,xzr,lo`, sau cổng forced>=1 |
| publishKnobsNow đúng 1 eor | **PASS** | IMP 0x15ad0–0x16060 (SplitScreen): đúng **1** `eor` @0x15e34 `eor w2,w27,#0x1`, w27 = kết quả IsIdentity → payload = !IsIdentity |
| Thân cấm sửa — ABHost 4 hàm | **PASS** | SHA-256 trích thân trên cây cuối khớp tuyệt đối giá trị đã công bố: setFrame `8606f40a…`, setBarVisible `3044b10d…`, setHandleVisible `409cfb14…`, setKnobs `b98a9f26…` |
| Thân cấm sửa — Chrome setBarVisible:forPane: | **PASS** (xem điểm diễn giải 1) | Thân hiện tại **byte-identical** với thân trong cây wake1 đã ship (push9 @a907505) dưới cùng một công thức trích |
| hostFrameInfo superset | **PASS** | Dict gốc 11 key + merge hostBarInfo {bar,pop,popDim,single} + extras {r,corners,hx,front,ox,oy,ow,oh,ax,ay,aw,ah} giữ nguyên công thức; cộng đúng 1 key `fade`; publishKnobsNow {knobs} + {kfade}; `handle` không bị mã hoá mờ |
| Kỷ luật sơn AutoHide | **PASS** | SCPCarSplit+AutoHide.m: **0** phép gán `.hidden=`/`.alpha=`/`userInteractionEnabled=`; ABHostBMethods.m: `layer.opacity` chỉ ghi tại 2 dòng — 1258 (trong AHHostPaintView) + 1266 (trong AHHostRestoreView); các dòng [autohide] cộng thêm toàn module: 0 phép gán cấm |
| Chuỗi cấm / điểm gọi FS | **PASS** | `OMCChromeSetHidden` = 0 trong source SplitScreen; runSoloForPane:/toggleZoomForPane:/dividerDoubleTapped/ratioPresetTapped trong file FS/AutoHide/Pinch = 0 (định nghĩa gốc ở Zoom.m/SCPCarSplit.m không bị code tính năng gọi); tham vấn `fsAreaForParent:` trong Layout.m đúng **1** điểm tại return của appAreaInParent:; `bwSetExpandedActive:` — ngoài định nghĩa ở BridgeWake, chỉ SCPFullscreenController gọi (5 điểm chốt §4.10) |
| Adapter thuần chuyển tiếp | **PASS** | SCPFullscreenAdapter.m (59 dòng): 0 static/ivar trạng thái FS; currentState → `fsCommittedState`, request* → controller với provenance `pinch`, stateDidChange re-emit nguyên văn |
| Khoá pinch ENFORCE | **PASS** | Điểm gọi requestExpand/Restore duy nhất nằm trong `if (mode == SCPPinchModeEnforce && wouldPinch)` (SCPPinchController.m:630), wouldPinch = đủ 5 cổng + session re-check; mode từ pref owner, `bwPinchMode` init DRY_RUN, pref vắng → DRY_RUN (:382), allowlist mặc định rỗng; entry của controller chỉ có 2 caller: adapter (pinch) + nhánh `[fs1-test]` nội bộ controller; gói không chứa pref đặt sẵn nào (grep pinchMode chỉ trúng dylib) |
| sendEvent kỷ luật | **PASS** | Chuỗi `sendEvent:` có mặt ở đúng **1/8** binary (AppBridge); MSHookMessageEx cài sendEvent đúng 1 điểm (ABInApp.m:592); `orig_SendEvent` đúng 1 điểm gọi (:583) — gói act không thêm hook |
| Kênh + markers trong binary | **PASS** | 5 chuỗi bridgewake có mặt ở cả SplitScreen + AppBridge; `kfade`/`faded` có mặt ở AppBridge; markers: [fs1-test] SS=4, [autohide] SS=9/AB=2, [pinch1] SS=5, [wake1] SS=13 (= wake1), `[do] bw` AB=7 (= wake1); chuỗi pref fullscreenTestExpand / bridgewake.autoHide / .pinchMode / .wakeMode có mặt ở SplitScreen |
| Ba timer gốc | **PASS** | AutoHide TU nhắc barTimer/trayTimer/ratioTimer đúng 1 lần — trong comment kỷ luật "never touches"; các hunk cộng của vòng này không chứa tham chiếu ghi/huỷ nào tới ba timer |
| Hai cây mirror | **PASS** | Toàn bộ cặp file tính năng (16 cặp SplitScreen + 5 cặp AppBridge, gồm 3 file tích hợp vừa sửa + BridgeWakePack.h×2 module) cmp identical; SCPCarSplitView.m mirror thật ở src/SplitScreenB — identical |

## 4. Điểm diễn giải còn lại cho GPT

1. **md5 thân Chrome setBarVisible:** car2 công bố `a79bc0d5…`
   nhưng không tái lập được bằng bất kỳ biến thể trích xuất nào tại
   tích hợp (sig→method kế: `23e58032…`; sig→`}` cột 0: `f9466329…`).
   Dưới MỘT công thức nhất quán, thân trong cây wake1 đã ship và
   thân hiện tại cho cùng md5 `23e58032…` và diff trực tiếp =
   identical → cổng đạt theo ý nghĩa (thân không đổi một byte từ
   wake1). Lệch là ở công thức trích của car2, không ở code; đề nghị
   GPT ghi nhận để các vòng sau dùng một công thức chung.
2. **removeHomeButton / ahForgetView:** giữ nguyên trạng car2 §3 —
   header chính thức không có method gỡ bản lưu theo view, tích hợp
   không tự chế API. Đánh giá rủi ro của car2 (bản lưu chết theo
   view + registry yếu + refreshHomeButton luôn áp-lại) giữ nguyên;
   GPT muốn khoá cứng thì cần một method mới ở TU AutoHide.
3. **Comment cũ ở cổng 2 của SCPPinchController** (~:590–594) vẫn mô
   tả adapter rỗng thời A1-BLOCKED ("state is always Unknown…") —
   code đã đọc trạng thái thật của controller qua adapter, chỉ
   comment là tồn dư wake round. Không sửa tại tích hợp (file thuộc
   strand pinch); GPT/tác giả strand cập nhật khi tiện.
4. **Bất đối xứng solo ở dashboardInvalidated** (xoá ivar trực tiếp,
   không qua endHostedSolo): an toàn vì ahSessionTeardown reset cả
   cờ treo + timer trong cùng method — ghi tại đây để khỏi bị đọc
   thành thiếu điểm nối.
5. **Candidate local arm64-only**: các kiểm hai-lát (chuỗi
   bridgewake từng lát, eor publishKnobsNow từng lát, csel g1 từng
   lát) phải chạy lại trên bản FAT của CI như vòng wake1.
6. Câu hỏi runtime Gate 2 của wake1 (hop ABHost, targetVerified,
   phân bố ack, probe pinch) + điểm đo FS1 staging (công tắc
   fullscreenTestExpand) + 6 điểm đo AutoHide §5.5 giữ nguyên cho
   phiên xe gộp — tích hợp không tự quyết.
