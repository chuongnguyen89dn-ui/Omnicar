# TÍCH HỢP YT-ZOOM → CANDIDATE "ytz1" — build + cổng tĩnh trên candidate

Ngày: 2026-11-09. Nguồn việc: design-ytzoom.md (§9 kế hoạch file +
6 cổng tĩnh), impl-ytz-host.md, impl-ytz-app.md, impl-ytz-prefs.md,
impl-ytz-fix-available.md; baseline đối chiếu = candidate fs1
(com.anlai.omnicar_1.0.3-fs1_iphoneos-arm64.deb, SHA `0a9f76b3…`)
theo integration-fs1.md. **Không git, không CI ở vòng này.**

Hai cập nhật phạm vi trong lúc làm (lệnh Nguyen, đã thực thi đúng
thứ tự): (1) bản đầu lệnh chờ strand sửa công tắc test vào CODE
Prefs (impl-prefs-switch-fix.md) — strand đó land lúc 14:37;
(2) ngay sau đó Nguyen 14:37 **huỷ toàn bộ hướng công tắc** ("Bỏ
staging, nối pinch luôn"): cổng "binary Prefs chứa 2 key công tắc"
bị huỷ bỏ, thay bằng việc chờ impl-pinch-wiring.md (pinch mặc định
ENFORCE + allowlist vắng = mọi pane + gỡ nhánh [fs1-test] + YTZ
mặc định BẬT khi pref vắng + dọn plist về 2 items + khôi phục
controller Prefs về nguyên trạng) rồi mới build. Candidate dưới
đây đóng từ cây SAU pinch-wiring; strand công tắc đã bị wiring
gỡ sạch (xem §5).

## Candidate

- Path: `project/packages/com.anlai.omnicar_1.0.3-ytz1_iphoneos-arm64.deb`
- Size: **1.013.910 B**; SHA-256:
  `119d6108ec4d9498a2950140a84cdbe6f2f507ae6c34bc6ba0710ab785de353d`
- Đóng bằng Theos `make package FINALPACKAGE=1` tại gốc project
  sau `make clean; make` toàn bộ (toolchain verify trước: clang-18,
  ldid, ld.lld→ld.lld-18, SDK 16.5 — đủ, không khôi phục; build
  0 error; warning duy nhất là các warning cũ ở ABHostLaunch.m /
  SSStartupView.m, ngoài phạm vi tính năng).
- control: `diff` với fs1 — **identical trừ Installed-Size**
  (3696 → 3712). Package/Version/Depends giữ nguyên. Member lzma
  như mọi candidate local. arm64-only (VM hạ arm64e); FAT chờ CI.
- Danh sách file trong gói: **identical fs1 (179 file)**; đúng 6
  dylib chuẩn, 0 dylib QA19/QA20/lạ.

## 1. Kiểm hợp nhất hợp đồng lease (§1 của đề bài)

| Kiểm | Kết quả | Bằng chứng |
|---|---|---|
| ABYTLease.h là nguồn hợp đồng DUY NHẤT | **PASS** | Kênh/khoá/phase/hằng chỉ định nghĩa tại ABYTLease.h (2 bản: project/OmniCarAppBridge + src/AppBridgeB, cmp identical). ABYTZoom.m dùng hằng header 38 lần, ABInApp.m 33 lần; grep định nghĩa tĩnh trùng (kênh/khoá/phase) trong hai file = 0 |
| ABYTZoom.h vắng mặt | **PASS** | `find project src -name ABYTZoom.h` = 0 (đã xoá cả hai cây ở vòng host; category ABHost (YTZoom) khai cục bộ trong ABYTZoom.m + ABHostBMethods.m) |
| Chuỗi ytlease/ytleaseack byte-equal mọi vị trí định nghĩa | **PASS** | Literal đầy đủ `com.anlai.omnicar/appbridge.ytlease` / `...ytleaseack` chỉ xuất hiện tại ABYTLease.h:21–22 (cả hai cây); ABChannels.m chỉ nhắc trong comment §7 |
| Makefile AppBridge có TU ABYTZoom.m | **PASS** | project/OmniCarAppBridge/Makefile:12 — FILES chứa ABYTZoom.m đúng 1 lần |
| Mirror hai cây | **PASS** | cmp identical: ABYTLease.h, ABYTZoom.m, ABHostBMethods.m, ABChannelNames.m, ABInApp.m (↔ src/AppBridgeB), ABChannels.m (↔ src/AppBridgeA/src) |
| Specifier youtubeVirtualize trong plist đóng gói | **THAY ĐỔI theo lệnh 14:37** | Strand ytz-prefs đã thêm specifier (default false) nhưng pinch-wiring đã GỠ theo lệnh bỏ staging: plist đóng gói cuối = **2 items** (xem §4). Trạng thái cuối là chủ đích của lệnh mới, không phải thiếu sót |

## 2. Cổng trên binary trích từ candidate (baseline fs1 cùng phương pháp đo)

Phương pháp trích __objc_methname bằng llvm-objdump-18 đã đối
chứng tái lập đúng số của integration-fs1 trên candidate fs1
(publishKnobsNow IMP 0x15ad0, eor tại 0x15e34 — khớp từng địa chỉ).

| Cổng | Kết quả | Bằng chứng |
|---|---|---|
| Selector parity 8 thành phần vs fs1 | **PASS có ngoại lệ chủ đích** | AppBridge 654→**714** (+60 bề mặt YZ, mất 0); CarProbe/Core/SpeedBubble/StartupScreen/App/Prefs **identical từng selector**; SplitScreen 1239→1235: mất ĐÚNG 4 = `_prefsToken`, `_testSwitchLast`, `fsTestPrefsChanged`, `fsTestSwitchOn` — toàn bộ bề mặt [fs1-test] bị gỡ theo lệnh 14:37 (§4, điểm diễn giải 1) |
| g1 — host appWithHash csel | **PASS** | AppBridge appWithHash IMP 0x7e34: @0x8078 `cmp x8,#0` → @0x807c `csel x8,xzr,x9,ne`; mask==0 → 0 (@0x8080/8084 csel eq); sentinel @0x8088 `cmp x21,#0xff` → @0x808c csel eq. Khác fs1 chỉ ở cấp phát thanh ghi (x25 thay x24) |
| g2 — app derivation csel | **PASS** | @0x18340 `tst x0,#0x2` → @0x18344 `csel x9,x8,xzr,eq` (bit portrait có mặt → 0) |
| h — host-bar C-A | **PASS** | setBarVisible (IMP 0xc1a4) @0xc438 `cmp w0,w22` → @0xc43c `b.ne`: chỉ chuyển khi isHidden == visible |
| h — host-bar C-B | **PASS** | Block vào @0xcde4–0xce14: nạp selector setAlpha: → @0xcde8 `fmov d0,#1.0` → @0xcdec bl setAlpha: → nạp transform → @0xce14 bl setTransform: (alpha=1 TRƯỚC transform) |
| f — lọc orientation {3,4} | **PASS** | @0x5fb0 `sub x8,x24,#0x3` → @0x5fb4 `cmp x8,#0x2` → @0x5fb8 `csel x2,xzr,x24,lo` |
| publishKnobsNow đúng 1 eor | **PASS** | IMP 0x15ad0 (SplitScreen): đúng **1** eor @0x15e34 `eor w2,w27,#0x1` — cùng địa chỉ/dạng với fs1, payload = !IsIdentity |
| 5 kênh bridgewake + act | **PASS** | `bridgewake.v1.{state,query,wake,ack,act}` mỗi chuỗi ×1 ở cả SplitScreen + AppBridge (khớp fs1) |
| Markers fs1 | **PASS (trừ [fs1-test] — xem §4)** | [autohide] SS=9/AB=2, [wake1] SS=13, [pinch1] SS=5 — khớp fs1 từng số; [fs1] SS=16 (log controller nay mang tiền tố này) |
| 4 thân ABHost cấm sửa | **PASS** | SHA-256 trích thân (signature → `}` độc lập) trên cây cuối khớp TUYỆT ĐỐI giá trị đã công bố: setFrame `8606f40a1ebf…`, setBarVisible `3044b10d0902…`, setHandleVisible `409cfb1447cb…`, setKnobs `b98a9f2611e0…` |
| Điểm ghi requestedOrientation duy nhất | **PASS** | grep toàn module: ABHostBMethods.m:607 trong appWithHash: (điểm ghi giá trị DUY NHẤT từ kênh apporient) + ABYTZoom.m:276/:320 **chỉ gán 0** (repair + đai layout của máy lease) + ABPane.m:52 @synthesize (accessor) |
| ytlease + markers [ytz] | **PASS** | Cả 2 chuỗi kênh có mặt trong AppBridge; 16 format [ytz] gồm đủ 6 format phía host (lease cap/gia han/thu hoi/chan apporient/sua residue/ack phase) + phía app (lease nhan/ao hoa BAT/ao hoa TAT/relay ap ×2/tieu thu tuyen bo/doc lai 0.12s/lease hong/cai may ao hoa) |
| 3 kênh cấm trong code YZ mới | **PASS** | grep ABYTZoom.m + khối YZ của ABInApp.m + ABYTLease.h: 0 tham chiếu CODE tới appbridge.apporient/orientation/keyboard — chỉ còn tên trong comment mô tả luật cấm (header ABYTLease.h:11–12, comment hook ABInApp) |
| sendEvent kỷ luật | **PASS** | Source: cài hook đúng 1 điểm (ABInApp.m:600), orig_SendEvent đúng 1 điểm gọi (:591). Binary: chuỗi `sendEvent:` có mặt ở đúng 1/8 binary (AppBridge), SplitScreen = 0 |
| FS adapter/controller nguyên vẹn | **PASS** | Selector fsCommittedState, fsRequestExpand/RestoreWithCompletion:provenance:, requestExpand/RestoreWithCompletion:, scpRecognizerDidCross:, pinchDispositionForPane:touchesSuppressed:, isAllowlistedBundle:hosted: đều có trong SplitScreen ytz1 |

## 3. Kiểm tĩnh phân xử (đọc đường code, file:line)

**Phía app — 3 hook báo cáo bị câm khi lease sống** (ABInApp.m):
- `ABHook_UIDeviceSetOrientation` :1544 — nhánh :1549
  `if (YZActive())`: gọi IMP gốc nguyên vẹn → `YZNoteConsumed()`
  → return. Không ghi `ABAppOrientation`, không
  `ABScheduleAppOrientationPublish` (cả hai chỉ ở đường dưới :1554+).
- `ABHook_SceneRequestGeometry` :1617 — nhánh :1621: gọi IMP gốc
  với preferences của chính app → consumed → return; không suy,
  không ghi, không publish.
- `ABHook_VCSetNeedsUpdate` :1641 — IMP gốc chạy trước (đúng ngữ
  nghĩa gốc), :1645 `if (YZActive()) { YZNoteConsumed(); return; }`
  chặn trước `ABScheduleAppOrientationPublish(0xFF)` :1646.
- `ABHook_VCAttemptRotation` không có nhánh YZ — đúng thiết kế
  (chỉ là bậc leo thang §10a, ngoài v1).

**Phía host — cổng chặn trước điểm ghi** (ABHostBMethods.m):
method `appWithHash:` :579 → cổng :598–601
`if ([self yzLeaseActiveForBundle:found.bundleID]) { …log…; return; }`
đứng TRƯỚC phép suy :603–606 và điểm ghi :607 + `nudgePane:` :612.
Hai cổng độc lập nhau đúng thiết kế §6.2; cổng host tự đủ vì
appWithHash: là điểm ghi duy nhất (mục §2 ở trên).

## 4. Cổng cộng thêm theo lệnh 14:37 (bỏ staging, nối pinch luôn)

**Truy vết pinch ở cấu hình mặc định (0 pref đặt)** — source (đã
đối chiếu trực tiếp trên cây cuối) + binary:

| Mắt | Bằng chứng | SPLIT+VISIBLE | SPLIT+HIDDEN |
|---|---|---|---|
| Mode mặc định | SCPCarSplit+BridgeWake.m:41 init `bwPinchMode = BWModeEnforce`; :390 nạp lại: pref vắng → BWModeEnforce (wakeMode :389 vắng → DryRun, KHÔNG đổi) | ENFORCE | ENFORCE |
| Cổng 3 phân xử | SCPPinchController.m:606–610 → `pinchDispositionForPane:` SCPCarSplit+BridgeWake.m:662 `BWStateHidden → SCPArbiterPinchBlockedHidden` ("wake wins") | Visible → Allowed | **BlockedHidden — chết tại đây** |
| Cờ gói state phía app | `bwPinchAllowedForPane:` BridgeWake.m:226–241: EXPANDED → YES (pinch-in ưu tiên); state ≠ VISIBLE → NO; popup/resizing → NO; allowlist nil → YES (mắt cuối :240) | `pinchAllowed = 1` | `pinchAllowed = 0` |
| Cổng 5 allowlist của controller | SCPPinchController.m:488 `isAllowlistedBundle:hosted:` — danh sách trong bộ nhớ rỗng → YES (không caller nào nạp thêm ở mặc định) | qua | không tới được |
| Điểm bắn | SCPPinchController.m:636 `mode == Enforce && wouldPinch` → requestExpand (:639) / requestRestore (:644) qua adapter (selector + format log `[pinch1] pair … gates[…] fired=%d reason=%@` có trong binary) | **BẮN** | không bắn |

Kết luận truy vết: **THÔNG tại SPLIT+VISIBLE, CHẶN tại
SPLIT+HIDDEN** ở cấu hình mặc định — chặn bằng hai lớp độc lập
(disposition phía CarPlay + cờ 0 trong gói state phía host), và
việc chặn KHÔNG phụ thuộc wake ENFORCE: owner luôn tính/phát
state bất kể wakeMode; wakeMode chỉ quyết định đường nuốt phía
app. EXPANDED → pinch-in vẫn mở ở cả hai lớp như thiết kế fs1.

**Các cổng vắng mặt (absence gates):**
- `[fs1-test]`: **0** trong SplitScreen binary; **0** trong source
  cả hai cây (ngoài artifact .theos cũ, đã xoá bởi make clean).
  Nhánh test đã gỡ hẳn (ivar/observer/method — xem parity §2).
- `fullscreenTestExpand`: **0 file** trong toàn bộ gói đã trích;
  0 trong source hai cây.
- Plist đóng gói `FeatureSplitScreen.plist`: **đúng 2 items**
  [PSGroupCell, splitScreenEnabled] — bản gốc khôi phục từng byte.
- `youtubeVirtualize`: trong toàn gói chỉ tồn tại **1 nơi** —
  chuỗi trong OmniCarAppBridge.dylib tại điểm đọc kill-switch
  `YZPrefEnabled()` ABYTZoom.m:109–112
  (`OMCPref(ABYTPrefVirtualize, @YES)` — vắng = **BẬT**, chỉ tắt
  khi pref đặt NO tường minh). Source: điểm đọc DUY NHẤT là
  ABYTZoom.m (grep toàn project/src ngoài .theos); không còn
  specifier/UI nào mang khoá này.
- Binary Prefs: `fullscreenTestExpand` = 0, `youtubeVirtualize`
  = 0 (controller đã khôi phục nguyên trạng — cổng ở §5).

## 5. Ghi việc chờ + cổng bị huỷ

- Vòng này đã **chờ impl-prefs-switch-fix.md land** (14:37) theo
  lệnh chờ ban đầu, rồi **chờ tiếp impl-pinch-wiring.md land**
  theo lệnh thay thế của Nguyen cùng 14:37; build/đóng gói chỉ
  chạy sau khi biên bản thứ hai land và đã đối chiếu các khẳng
  định của nó trên cây (defaults :41/:389/:390/:401, cổng 5 :488,
  điểm bắn :636, plist 2 items, controller Prefs khôi phục —
  grep 2 khoá = 0, cmp mirror identical).
- Cổng "binary OmniCarPrefs chứa `fullscreenTestExpand` +
  `youtubeVirtualize`" (đặt ra ở lệnh chờ đầu): **BỊ HUỶ BỎ**
  theo lệnh 14:37 — không còn công tắc nào hết theo chủ đích.
  Kết quả đo thực tế trên candidate cuối được ghi ở §4 theo
  chiều ngược: cả hai khoá **vắng** trong binary Prefs (0/0),
  khớp trạng thái "không công tắc" mà lệnh yêu cầu.

## 6. Điểm diễn giải còn lại cho GPT

1. **Parity SplitScreen mất 4 selector** là hệ quả trực tiếp của
   lệnh gỡ [fs1-test] (2 ivar + 2 method test), không phải hồi
   quy. Mọi selector tính năng (FS controller/adapter, pinch,
   AutoHide, BridgeWake) giữ nguyên — đã liệt kê ở §2.
2. **Khoá pinch ENFORCE của vòng fs1 đã bị lệnh 14:37 thay thế**:
   pinch giờ bắn thật ở mặc định. Các khoá an toàn còn lại đều đã
   truy vết ở §4: HIDDEN chặn hai lớp, popup/resizing/
   transitioning fail-open, một lệnh mỗi cử chỉ, EXPANDED chỉ
   pinch-in. Nghiệm thu xe cho pinch bắn thật là việc của phiên
   đo (wiring §"Còn mở"), tích hợp không tự quyết.
3. **Một literal đọc khoá ack**: ABYTZoom.m:464 đọc
   `note.userInfo[@"identifier"]` bằng literal thay vì hằng
   `ABYTLeaseAckKeyIdentifier` của header (và các nhãn
   `YZLogBad(@"version")` phía app là chuỗi log chẩn đoán). Đây là
   *điểm dùng*, không phải định nghĩa trùng — hợp đồng vẫn một
   nguồn; ghi lại để GPT phán có cần siết về hằng số cho đồng
   nhất hay không.
4. **Tắt YTZ sau lệnh bỏ công tắc**: không còn UI switch;
   kill-switch `youtubeVirtualize = NO` chỉ đặt được bằng đường
   pref ngoài giao diện (hoặc gỡ tính năng ở vòng sau). Đây là
   hệ quả chủ đích của lệnh "không công tắc nào hết".
5. **Wake vẫn DRY_RUN mặc định** — wiring không đụng wakeMode.
   Gate 2/ENFORCE của wake vẫn chờ nghiệm thu xe như cũ; pinch
   mặc định ENFORCE không kéo theo thay đổi nào ở đường nuốt.
6. **Candidate local arm64-only**: các kiểm hai-lát (ytlease
   từng lát, eor publishKnobsNow từng lát, csel g1 từng lát,
   parity từng lát) phải chạy lại trên bản FAT của CI như vòng
   fs1/wake1.
7. Mức báo cáo của vòng này: **source complete / static PASS /
   build PASS** — chưa có bằng chứng runtime; phiên đo §8.3 của
   design-ytzoom (7 mục, đối chứng pref-OFF nay thay bằng đối
   chứng kill-switch NO) là bước chốt tiếp theo.
