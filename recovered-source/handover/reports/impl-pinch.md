# IMPL PINCH — controller + probe + adapter rỗng (phần không chờ A1)

Ngày: 2026-11-09. Strand cài đặt phần A theo `design-pinch.md` (8 mục) +
giao diện phân xử của `design-bridgewake.md` §2/§4. Trạng thái A1:
**FULLSCREEN_ENTRY = BLOCKED** (`a1-fullscreen-entry.md`) — adapter
thân rỗng là trạng thái CUỐI của vòng này, không phải tạm chờ.

## 1. File đã tạo (2 cặp mới, cả hai cây, mirror identical — `cmp` = 0)

| File | Nội dung |
|---|---|
| `OmniCarSplitScreen/SCPFullscreenAdapter.h` (bản sao: `src/SplitScreenA/`) | `SCPFullscreenState` + protocol `SCPFullscreenControlling` nguyên hình dạng design §4.2 (dòng 25–43) + class `SCPFullscreenAdapter` (dòng 51) |
| `OmniCarSplitScreen/SCPFullscreenAdapter.m` | Thân rỗng có kỷ luật §4.3 — xem mục 3 |
| `OmniCarSplitScreen/SCPPinchController.h` | `SCPPinchMode` (dòng 38), `SCPArbiterDisposition` + `@protocol SCPPinchArbiter` nguyên hình §3.5 (dòng 48–65), `SCPPinchDeadKind` (dòng 71), `SCPPinchRecognizer` (dòng 79), `SCPPinchController` (dòng 95) |
| `OmniCarSplitScreen/SCPPinchController.m` | Recognizer + sổ cặp + máy nhận dạng + cổng + probe (28.080 B) |

Không sửa bất kỳ file chung nào (`SCPCarSplit.m`, `+Chrome.m`,
`+Divider.m`, `SCPHooks.m`, `ABInApp.m`, Makefile đều nguyên vẹn) —
mọi điểm chạm chung để lại cho bước tích hợp (mục 5).

## 2. Controller theo mục thiết kế

- **Recognizer** (`SCPPinchController.m:102`): subclass
  `UIGestureRecognizer`, tự theo dõi pha trong touchesBegan/Moved/
  Ended/Cancelled (`:179/:229/:337/:341`), không bao giờ rời trạng
  thái Possible — chỉ quan sát. Cấu hình bắt buộc §3.1 tại `:113-115`:
  `cancelsTouchesInView = NO`, `delaysTouchesBegan = NO`,
  `delaysTouchesEnded = NO`. Không delegate, không require-to-fail:
  recognizer không tranh chấp với recognizer của app/divider.
- **Sổ cặp + máy** (§3.2): pha IDLE→TRACKING→PAIRED→FIRED/DEAD
  (trong code: `SCPPairPhaseConcluded` = FIRED|DEAD, chờ mọi touch
  kết thúc rồi mới về IDLE). Hình thành cặp tại `scpFormPair` (`:147`):
  `dist0`/`mid0` lấy từ vị trí HIỆN TẠI của ngón 1 tại thời điểm ngón
  2 xuống; ánh xạ pane theo ĐIỂM BẮT ĐẦU của từng ngón. Ngón thứ ba →
  giết gesture, lý do `third-touch`. Ngưỡng tại Moved khi PAIRED
  (`:229`): out ≥ 1,10 / in ≤ 0,90 và `midDrift ≤ 0,6×distChange + 10`
  phải đúng CÙNG một Moved; tối đa 1 kết luận/gesture.
- **Ánh xạ điểm→pane** (§2.1, `scpPaneForStartPoint:` `:513`): thuật
  toán slots-walk của block `touched` — float kiểm trước và thắng
  (alpha > 0), slots quét theo thứ tự bỏ qua `alpha <= 0`, hit cuối
  thắng (block gốc không break). Cặp hợp lệ chỉ khi hai ngón cùng một
  pane; khác pane → chết `xpane`. Ngón trên divider/chrome → chết
  (`divider`/`chrome`), xem lệch L2 ở mục 4.
- **Điểm phát lệnh duy nhất + 5 cổng** (§3.3, `scpRecognizerDidCross:`
  `:578`), đúng thứ tự: (1) PINCH_MODE đọc từ `arbiter pinchMode`
  (không plist; arbiter nil → DRY_RUN; giá trị ngoài 0–2 → OFF);
  (2) trạng thái host đọc từ ADAPTER — SPLIT chỉ nhận out, EXPANDED
  chỉ nhận in; (3) phân xử wake qua `pinchDispositionForPane:
  touchesSuppressed:`; (4) chuỗi sạch = `!externalChainSuppressed`;
  (5) allowlist theo (bundleID, `SCPVCIsHosted(pane.vc)`), mặc định
  RỖNG (mọi app OFF). Sau cổng 5 còn kiểm lại phiên §2.2 (active +
  container.window + pane còn trong `allPanes`) trước khi gọi
  adapter. Chết cổng nào ghi lý do cổng đó (`mode-off` / `hoststate` /
  `hidden` / `arbiter-unknown` / `suppressed` / `not-allowlisted` /
  `session`). ENFORCE qua đủ cổng → đúng 1 lần gọi
  `requestExpand`/`requestRestore` kèm completion log.
- **Vòng đời** (§1.3): controller nhận lệnh từ ngoài —
  `attachIfNeeded` (`:407`, gắn recognizer vào container hiện hành,
  xử lý đúng việc ensureContainer tạo container MỚI mỗi lần),
  `detach` (`:423`, teardown + log tổng kết phiên), `syncArming`
  (`:434`, arm ⟺ active + container có window + recognizer đúng
  container; disarm thì reset TRƯỚC khi tắt enabled), `resetTracking`
  (`:451`). Reset (§3.4) tại `resetTrackingWithReason:` (`:345`):
  cancel/teardown/đổi phiên/container đổi bounds giữa gesture
  (recognizer tự kiểm bounds tại mỗi Moved) → cặp kết luận truncated,
  không bắn lệnh từ trạng thái vừa reset.
- **Probe Gate 2** (§6.1): mọi cặp kết luận đúng 1 dòng log
  `[pinch1] pair seq=… slot=… bundle=… scene=hosted|native dir=out|in
  dist0=… scale=… drift=… gates[m- h- a- c- l- s-] wouldPinch=0|1
  fired=0|1 reason=…` — chỉ khoảng cách/tỉ lệ/drift, KHÔNG tọa độ
  tuyệt đối. Bộ đếm phiên tách SPLIT/EXPANDED (bucket theo adapter
  lúc hình thành cặp): cặp COMPLETE ⟺ cả hai ngón được thấy trọn
  Began→Moved→Ended, không cancel/không xâm nhập/không reset; còn
  lại TRUNCATED. Tổng kết phiên log tại `detach`.

## 3. Adapter — thân rỗng là bản CUỐI của vòng (A1 = BLOCKED)

`SCPFullscreenAdapter.m:31-47`: `currentState` luôn
`SCPFullscreenStateUnknown`; `requestExpand…` (`:37`) /
`requestRestore…` (`:43`) log 1 dòng từ chối rồi completion(NO);
`stateDidChange` không bao giờ phát. Comment đầu file + điểm binding
ghi rõ: `A1=BLOCKED 2026-11-09, xem a1-fullscreen-entry.md`
(OMCToggleHost static, đúng 1 điểm gọi nội bộ `-[OMCZoomAction
pressed:]`; không kênh lệnh vào; không đường đọc expanded; cấm gọi
offset/selector đoán). Hệ quả tự khóa đúng thiết kế §4.3: cổng 2 của
máy pinch không bao giờ qua cho pinch-out → **PINCH ENFORCE không thể
arm ở vòng này**; controller/probe chạy DRY_RUN bình thường, không
cần sửa gì thêm để "tắt" pinch. Đường thoát dự phòng §5 vì vậy cũng
chưa kích hoạt điều kiện nghiệm thu (pinch-out ENFORCE đang bị cấm
bật bởi chính cổng 2).

## 4. Các điểm lệch thiết kế — cần tích hợp nối (không tự ý đổi)

- **L1 — protocol phân xử có thêm `pinchMode`.** design-pinch §3.5
  chốt 2 method (`pinchDispositionForPane:touchesSuppressed:`,
  `hostIsExpanded`); mode cũng phải đến từ owner (WO §IX /
  bridgewake §4: owner đọc prefs, app không đọc plist) nên
  `SCPPinchArbiter` (`SCPPinchController.h:59-65`) khai thêm
  `- (SCPPinchMode)pinchMode;`. Phía wake khi cài owner phải conform
  đủ 3 method này. Tên enum `SCPArbiterDisposition` và 2 method gốc
  giữ nguyên văn §3.5.
- **L2 — chết chrome/divider dùng thêm hit view.** Slots-walk thuần
  điểm (§2.1) không phân biệt được ngón bắt đầu trên handle/bar nằm
  TRONG khung hình học của pane. Controller kiểm thêm `touch.view`:
  ngón đáp lên divider hoặc chrome của pane (handle/bar/cover/
  loader/picker) → chết trước khi walk. Kiểm này chỉ GIẾT cặp, không
  bao giờ tạo ánh xạ — không thể mở rộng bề mặt pinch quá thiết kế.
- **L3 — `hostIsExpanded` của arbiter chưa được controller gọi.**
  Cổng 2 đọc trạng thái host trực tiếp từ adapter đúng chữ §3.3
  ("đọc từ adapter, mục 4"); bản sao phía arbiter phục vụ phân xử
  nội bộ của owner. Method vẫn giữ trong protocol (đúng §3.5); nếu
  tích hợp muốn controller đối chiếu thêm bản sao này thì là 1 dòng
  ở `scpRecognizerDidCross:`.
- **L4 — pha chờ sau reset.** §3.4 nói reset "về IDLE"; code đi qua
  pha Concluded (chờ mọi touch kết thúc) rồi mới IDLE — chính là
  cách §3.2 xử lý ngón thứ ba. Hệ quả bắt buộc: touch còn đang xuống
  không bao giờ lọt vào cặp mới sau reset.

## 5. Điểm keo tích hợp còn phải làm (ngoài phạm vi strand này)

1. **Makefile** module SplitScreen: thêm `SCPPinchController.m` +
   `SCPFullscreenAdapter.m` vào `OmniCarSplitScreen_FILES`.
2. **SCPHooks.m** (seam ~317-320, sau `rootDidLayout`): gọi
   `[[SCPPinchController shared] syncArming]`; tại seam teardown
   gọi `detach`.
3. **SCPCarSplit.m** (chỉ 2 dòng keo theo design §7): cuối
   `ensureContainer` → `attachIfNeeded`; trong
   `dashboardInvalidated` → `detach`. (Nếu seam SCPHooks đủ phủ cả
   hai thời điểm thì bỏ qua — strand wake cũng sửa file này, hợp
   nhất ở tích hợp.)
4. **Nối arbiter**: owner bridge-wake (SCPCarSplit+BridgeWake) conform
   `SCPPinchArbiter` và gán `[SCPPinchController shared].arbiter`;
   cập nhật `externalChainSuppressed` theo cờ chuỗi suppression hiện
   hành mà phía wake công bố (khi nghi ngờ đặt YES).
5. **Allowlist**: để rỗng cho tới sau Gate 2/Gate 3 trên xe; thêm
   từng (bundle, scene) bằng `allowBundle:hosted:` khi có nghiệm thu.

## 6. Cổng kiểm đã chạy (trên 2 file mới, chưa vào Makefile)

- Toolchain: clang-18 + SDK iPhoneOS16.5 sẵn có, không phải khôi phục.
- Biên dịch trực tiếp bằng clang-18, flags tương đương module
  (`-target arm64-apple-ios15.0 -fobjc-arc -fno-modules -fblocks
  -include SCPIntegrationShims.h -DOMC_MODULE_NAME='"SplitScreen"'
  -DOMC_NO_PERF_CLUSTER`): **0 lỗi, 0 cảnh báo** — cả với `-Wall
  -Wextra` lọc theo tên file mới (đường cơ sở `SCPCarSplitView.m`
  cùng flags cũng im lặng). Object: controller 91.000 B, adapter
  11.224 B.
- Bản sao cây `src/SplitScreenA/` biên dịch cùng flags (thêm
  `-I../SplitScreenB` cho SCPCarSplitView.h): sạch, object cùng kích
  thước; `cmp` 4/4 file giữa hai cây = identical.
- Link thử 2 object bằng `clang-18 -fuse-ld=lld -dynamiclib
  -undefined dynamic_lookup`: ra Mach-O arm64 dylib hợp lệ;
  `llvm-nm-18` thấy đủ 3 class `_OBJC_CLASS_$_SCPPinchRecognizer`,
  `$_SCPPinchController`, `$_SCPFullscreenAdapter`.
