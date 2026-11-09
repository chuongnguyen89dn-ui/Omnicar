# BẢN BÀN GIAO TIỀN GIAO — BẢN TÍCH HỢP SAU WO GPT (ytz2, CHÍNH THỨC)

Trạng thái: **CHÍNH THỨC** — tích hợp + CI FAT + kiểm hai lát đã xong (biên bản integration-ytz2.md, ci-ytz2.md; PATCH_NOTES §24; ACCEPTANCE_YTZ2.md).
Danh tính bản giao: FAT `com.anlai.omnicar_1.0.3-rebuilt-ytz2-fat_iphoneos-arm64.deb`, 1.221.708 B, SHA-256 `bb59ab5653540f21d915631213621c0158fc2850038f6d0959b3eca95087dc20`; candidate local 1.021.310 B, SHA-256 `4737cfa93c2c5a6a7c7ade37a0b7731718f626bb267dd2d03cf6d9f54018d6ad`; CI run dispatch **42583754018** SUCCESS (headSha `5c5698f`); source main `a763030`.
Baseline bất biến: fs1 FAT SHA-256 `41bb5b8bf21f87926449070c881ae453daf2d311ab2c91295e531494ce4b8a82`.
Bản ytz1 FAT (`4caa2568…`, CI run 42581690791) chứa cả 3 lỗi GPT đã kết án — **cách ly, không giao**, bị ytz2 thay thế. Ghi đúng sự thật thao tác: lệnh dừng CI của coordinator tới SAU khi run ytz1 đã dispatch, nên run vẫn chạy xong và FAT vẫn ra lò trước khi bị cách ly.
Thang verdict: STATIC_PASS / RUNTIME_PASS / DEVICE_PASS / FAIL / BLOCKED / PENDING. Tĩnh PASS không đồng nghĩa chức năng đạt — mọi mục dưới đây đều chưa có DEVICE_PASS.

## 1. Bảng đường activity F1–F4 / ACT (sau vòng sửa WO)

| Đường | Cơ chế | Cổng hiện tại (sau sửa) | Bằng chứng tĩnh |
|---|---|---|---|
| F1 | `hitTest:` của SCPCarSplitView phía CarPlayApp (lọc Began theo khuôn QA20) → `ahNoteActivity:` | Không đổi; chỉ tính chạm phía CarPlay | impl-autohide-car1/car2 (fs1) |
| F2 | Callback từ phía host: `bridgeHandleTapped:` / `remoteKnobTouch:` → `ahNoteActivity:` | Không đổi | impl-autohide-car2 (fs1) |
| F3 | `homeButtonTapped` (chạm chính nút logo/Home) → `ahNoteActivity:` | Không đổi — đây là đường DUY NHẤT sống trên xe fs1 (chạm trúng logo thì hiện) | Báo cáo xe Nguyen 14:39 2026-11-09 |
| F4 | Gói `act` (BWTypeAct = 5, kênh `bridgewake.v1.act`) phát từ hook `sendEvent:` trong ABInApp tại điểm mở dãy chạm → owner `bwHandleActPacket:` → `ahNoteActWithKbActive:` → `ahNoteActivity:` | **ĐÃ SỬA (W2-A/W3):** phía app phát act theo **danh tính phiên đã xác thực** (`BWActSessionVerified`, đặt tại `BWOnStatePacket` khi gói state hợp lệ được chấp nhận — ABInApp.m:423; xoá tại `BWResetAll` :766), **không còn phụ thuộc độ tươi state 2,5 s**; trói scene: scene được host xác định qua lease YTZ (sceneID) hoặc scene của `ABKeyWindow()` — touch ngoài scene → không phát. Throttle 0,12 s giữ nguyên. Phía owner giữ nguyên kiểm hash/gen/phiên active/assignment/trạng thái slot. Act **không** cấp quyền nuốt | fix-w-act-app.md (8 hunk, harness codec 21/21); fix-wp-owner.md §1 |
| ACT-reveal | `ahNoteActivity:` → đang mờ thì `ahRevealBody:` khôi phục opacity đã lưu + `pushHostFramesLive:NO` (khoá `fade=NO` qua hostFrameInfo) → ABHost áp qua `applyFade:forPane:` / `setKnobsFade:` | Log mới: phía app mọi quyết định act có `t=` monotonic + `stateage=` + reason (`act-posted` / `act-drop-nosession` / `act-drop-scene` / `act-drop-target-unknown`); phía owner mọi điểm loại có reason riêng (`decode-fail` / `bad-hash` / `bad-gen` / `session-inactive` / `not-assigned` / `split-inactive`); reveal ghi `reveal-applied reason=… views=N` | fix-w-act-app.md; fix-wp-owner.md §1 |
| Quyền nuốt (tách riêng) | Máy suppression trong ABInApp (cổng `BWGatePass` + engine) | **Không đổi:** vẫn đòi state HIDDEN **tươi ≤ 2,5 s** (`BWFresh()` còn đúng 6 điểm gọi, tất cả thuộc đường nuốt/probe). Owner nay phát lại state mỗi **1,0 s** luân phiên từng pane hosted qua cùng poster `BWEmitStatePacket` (seq tăng, gen giữ nguyên) → độ cũ tối đa mỗi pane ≈ 1,03 s, kể cả 2 pane — suppression có state tươi sau khi ẩn lâu | fix-wp-owner.md §2; fix-w-act-app.md (grep kỷ luật) |
| Probe W4 | Hook `sendEvent:` **thụ động** phía CarPlayApp (TU `SCPTouchProbe`, gọi orig nguyên vẹn, không gọi API activity/reveal/nuốt nào) | Chỉ ghi `[probe]`/`[probe-foreign]`: scene (container/tray/foreign), pane trúng theo hình học, hosted/native, trọn/cụt chuỗi — dữ kiện để GPT quyết có dời feed activity về CarPlayApp hay không. **Quy ước đếm hook (chốt ở vòng này):** theo call-site thật toàn module SplitScreen = **31** (SCPHooks 29 + SCPSpringBoardHooks 1 + probe 1); baseline fs1 thật = 30 → delta đúng +1 = probe. Con số "32" trong biên bản strand là đếm dòng grep gồm cả comment (PATCH_NOTES §24.5(i)) | fix-w-probe.md; verify-arbiter-diag-probe.md (e) |

## 2. Bảng arbitration SPLIT / EXPANDED (vị từ phiên — P1 đã sửa)

Mô hình cũ (sai, đã gỡ): EXPANDED gắn với bundle — controller luôn truyền `forBundle:nil` còn arbiter đòi `pane.bundleID == bwExpandedBundle` → hàng EXPANDED không bao giờ mở, pinch-in chết. `isEqualToString:bwExpandedBundle` nay = 0 trên toàn BridgeWake.m.

Vị từ EXPANDED dùng chung cho cả `bwPinchAllowedForPane:` (cờ gói state) và `pinchDispositionForPane:` (đường bắn), cộng điểm promote HIDDEN→VISIBLE trong `bwRecomputeForPane:`:
`bwExpandedFlag && self.active && pane ∈ allPanes && !bwWakePendingBySlot[slot] && !self.resizing`
(`allPanes` có chủ đích: pane native của split hỗn hợp không thuộc hostedPanes nhưng là pane sống của phiên.)

**Caveat (ii) — điểm promote không nguyên văn cùng vị từ:** điểm promote trong `bwRecomputeForPane:` (BridgeWake.m:399–400) chỉ viết dạng rút gọn `state == BWStateHidden && bwExpandedFlag`, không lặp 4 toán hạng còn lại. Tương đương ngữ nghĩa nhờ các guard bao quanh đã thiết lập sẵn: `assigned` (:356) = `self.active ∧ bundle.length ∧ pane ∈ hostedPanes`; state HIDDEN chỉ tới được khi không wake-pending (nhánh WAKING :362 đứng trước) và không resizing (`resizing ⊂ transient` → UNKNOWN, :373–378). Khẳng định "cùng một vị từ" của strand đúng về ngữ nghĩa, không đúng nguyên văn tại điểm này — không phải lỗi hành vi (verify-arbiter-diag-probe.md (a) ghi chú 1; PATCH_NOTES §24.5(ii)). Bất đối xứng cấu trúc kèm theo: promote chỉ chạy cho pane hosted (state packet chỉ tồn tại cho pane hosted); hai hàm arbiter bao cả allPanes gồm native — đúng vai trò từng điểm.

| Trạng thái | Pinch-out | Pinch-in | Ghi chú |
|---|---|---|---|
| SPLIT + VISIBLE | Allowed (khi mode = ENFORCE) | — | Mode mặc định hiện là **DRY_RUN** (P4) — ENFORCE chỉ qua pref/control Chẩn đoán = 2, sau khi controller qua nghiệm thu độc lập |
| SPLIT + HIDDEN | BlockedHidden — **wake thắng** | — | Cờ gói `pinchAllowed` = 0 đồng thời (hai lớp độc lập) |
| EXPANDED (phiên) | — | **Allowed trên mọi pane còn sống của phiên** (native hay hosted, không cần bundle owner) | Thoát không phụ thuộc state VISIBLE/HIDDEN nữa |
| EXPANDED + pane bị xoá | hàng EXPANDED trượt ở cả hai hàm → INACTIVE / BlockedUnknown | — | Teardown gọi `bwSetExpandedActive:NO` dọn cờ phiên, không latch |
| Restore xong (kể cả timeout) | về hàng SPLIT thường ở cả hai hàm | — | Settle của controller là điểm duy nhất hạ cờ |

**Caveat (iii) — ranh giới của hàng "EXPANDED + pane bị xoá":** khẳng định "cờ rơi về INACTIVE" phụ thuộc recompute/teardown ĐÃ chạy cho pane bị xoá. Nếu `bwStateBySlot` của pane đó còn giữ VISIBLE cũ và recompute chưa chạy, disposition rơi về hàng SPLIT thường (VISIBLE → Allowed theo hàng thường, không phải hàng EXPANDED) — hành vi cũ, nằm ngoài bảng 6 trường hợp của WO, vòng này không đổi (verify-arbiter-diag-probe.md (a) ghi chú 2; PATCH_NOTES §24.5(iii)).

Đường thoát không phụ thuộc recognizer (P4): nhóm **Chẩn đoán** trong Cài đặt (dựng bằng code trong OMCSplitScreenController, section 6) — công tắc `fullscreenDiagExpand` (mặc định OFF): ON gọi đúng đường expand nội bộ của controller (provenance `diag`), OFF khi đang EXPANDED **luôn restore** kể cả không có cạnh đổi; kèm công tắc `youtubeVirtualize` (đối chứng Y2) và segment `bridgewake.pinchMode` 0/1/2 (mặc định 1 = Đo, khớp default owner). Binary Prefs chứa cả 3 khoá trong CODE (fix-p-diag.md).

## 3. YT-Zoom — kiểm độc lập vòng này

| Hạng mục | Kết quả | Bằng chứng |
|---|---|---|
| isSplit — nguồn sự thật | Vị từ tại SCPCarSplit.m:2082: `self.active && self.paneCount >= 2 && self.zoomedSlot == nil`. Hai hạng tử cuối là **nguyên văn** vị từ trình bày VERIFIED của module `-dividersVisible` (SCPCarSplit+Layout.m:270–273, @0x11b50); hạng tử `active` là cổng phiên (điểm đặt YES duy nhất SCPCarSplit.m:132); `paneCount` = `slots.count` (:445) | Đọc trực tiếp source |
| Vận chuyển | `split` + `splitver = @1` cộng trong builder `hostFrameInfo:pane:live:handle:` (:2082–2083), phủ cả 2 điểm phát (open :1896, frame :2013) | Đọc trực tiếp source |
| Phía host | `YZComputeIsSplit` (ABYTZoom.m:189) đọc kho session `YZSessionSplit` (ghi bởi `YZNoteSessionSplit` :167 qua observer open/frame :540); `panes.count` chỉ còn 1 chỗ (:199) trong fallback cho gói thiếu trường, mỗi lần fallback log `[ytz] isSplit-fallback` (throttle 5 s) | Đọc trực tiếp source |
| EXPANDED vs split | Controller FS **không bao giờ gán** `zoomedSlot` (chỉ đọc tại SCPFullscreenController.m:298/:540); gán chỉ tồn tại ở tính năng zoom (Zoom.m:29/:32, Relayout.m:53) → EXPANDED giữ `split = YES`, đúng ngữ nghĩa phiên | grep toàn module |
| 4 hash cấm ABHost | **MATCH cả 4** (SHA-256 thân hàm signature→`^}`, tự tính lại độc lập): setFrame (ABHostBMethods.m:629–665) `8606f40a…`; setBarVisible (:1126–1160) `3044b10d…`; setHandleVisible (:1224–1229) `409cfb14…`; setKnobs (:1453–1551) `b98a9f26…` | Tính lại từ source hiện tại |
| Lease/ack/heartbeat ngoài Y1+Y4 | Không đổi: TTL 3,0 s (ABYTLease.h:56), heartbeat 1,0 s, heal khi ack `expired` tối đa 3 lần, generation chỉ tăng khi nội dung đổi, grant/revoke qua prefschanged nguyên vẹn | Đọc ABYTZoom.m đối chiếu impl-ytz-host.md |
| Y4 instrument | Log `[ytz] lease-lapse: … gen=… heal=…` trong nhánh ack `expired` **trước** các guard (:456) + `[ytz] owner phien host: <uuid>` tại `YZRegisterHostLease` (:517). Quyết định KHÔNG restore snapshot khi hết hạn/đổi owner giữ nguyên (chưa đảo) | Đọc trực tiếp source |
| hostFrameInfo superset | Toàn bộ khoá hiện có: base 11 (`identifier, x, y, w, h, live, handle, pt, pl, pb, pr`) + hostBarInfo 4 (`bar, pop, popDim, single`) + `fade` (vòng AutoHide) + `split, splitver` (vòng này) + `r, corners, hx, front` + `ox, oy, ow, oh` + có điều kiện tabParent: `ax, ay, aw, ah` = 30 khoá (26 vô điều kiện theo pane). Vòng này chỉ CỘNG đúng 2 khoá; không khoá nào bị bớt/đổi tên/đổi công thức | Đọc toàn bộ builder :2042–2103 |

## 4. Bảng verdict từng track

| Track | Mức tĩnh (có bằng chứng) | Mức xe | Căn cứ / còn thiếu |
|---|---|---|---|
| AutoHide / Wake | **STATIC_PASS** — act tách freshness + trói scene, renewal 1,0 s, mọi điểm loại có reason; build sạch, harness 15/15 + 21/21 | **PENDING** (fs1 từng FAIL ở reveal: mờ được, gọi lại không được) | Nghiệm thu W5 chưa chạy: mờ 4 s / +10 s / +30 s chạm đều phải hiện; lặp với YouTube phát, Maps mở, bàn phím hoạt động; chạm màn hình iPhone không gọi nhầm; 10 chu kỳ không mất controls vĩnh viễn |
| Pinch Fullscreen | **STATIC_PASS** — arbiter EXPANDED theo phiên ở cả 3 điểm dùng, truy vết tĩnh 6 trường hợp (kèm caveat (ii)/(iii) ở mục 2); đường chẩn đoán + đường thoát độc lập recognizer; default DRY_RUN | **PENDING** | Controller chưa có bất kỳ bằng chứng xe nào. Ma trận P2 chưa chạy: 10 chu kỳ expand/restore qua công tắc chẩn đoán, đổi app giữa EXPANDED, ngắt CarPlay giữa EXPANDED, app chết giữa EXPANDED, dock/Home về đủ sau mọi teardown |
| YT-Zoom | **STATIC_PASS** — cơ chế lease + 6 điểm chặn + cổng tiêu thụ duy nhất đã kiểm tĩnh từ vòng ytz1; isSplit đã sửa và kiểm độc lập (mục 3) | **PENDING** | Chưa từng chạy trên xe. Đo Y2 chưa chạy: đối chứng OFF/ON cùng bản, YouTube + Maps native (split hỗn hợp), YouTube + hosted, YouTube solo, kéo divider; ack `applied` phải cho windows ≥ 1, mismatch = 0 |
| Weather | **STATIC_PASS** (kế thừa fixround7: cụm W1–W8, gradient 11 cặp màu; vòng này không sửa code weather) | **PENDING** | Tiêu chí GPT chưa được chấm trên xe: quyền Location = 0 → nhánh fallback, không kẹt in-flight, request sau chạy, mọi nhánh kết thúc đúng một lần |
| Núm divider | **STATIC_PASS** (sửa cực `publishKnobsNow` đã đo lại trên FAT ytz2: đúng 1 `eor` mỗi lát — arm64 @0x129dc, arm64e @0x13318 — cùng dạng lệnh như fs1/ytz1) | **PENDING** | Chấm xe trong phiên fs1 chưa có kết quả trả về (kích thước núm, chạm gần vạch vào được app) |

## 5. Giới hạn còn lại (không được gọi là PASS)

1. Sửa reveal là **source-proven, device-unproven** — toàn bộ nghiệm thu W5 nằm ở phiên xe ytz2; DRY_RUN đạt (nếu đạt) vẫn không phải QA180 ENFORCE.
2. Wake ENFORCE (nuốt chạm đầu) **chưa mở**: Gate 3–6 chưa từng chạy; renewal giải quyết độ tươi state nhưng nghiệm thu nuốt là vòng riêng.
3. Quyết định dời feed activity về CarPlayApp (W4) còn mở — phụ thuộc dữ kiện `[probe]` của phiên ytz2; nếu cả hai tầng đều mù với chạm hosted, giữ đường gọi lại bằng nút logo theo WO.
4. Cặp pinch trên ô hosted có tới được recognizer phía container hay không vẫn chưa đo (probe Gate 2 ở log fs1 chưa được trả về; probe W4 của ytz2 sẽ trả lời ở tầng CarPlayApp).
5. YT-Zoom: player có thể đọc hướng từ bề mặt ngoài bộ 6 điểm đã chặn (binary đóng) — thang leo Y3 (statusBarOrientation → host-only → đóng track) chưa dùng tới; VISUAL_ORIGINAL_COMPARISON vẫn PENDING (thiếu footage deb gốc cùng kịch bản).
6. Lease hết hạn/đổi owner: quyết định không restore snapshot cần đo Y4 riêng (heartbeat gián đoạn, hết hạn 3 s, restart app/host, tắt pref giữa fullscreen) trước khi kết luận không kẹt cửa sổ sai kích thước/hướng.
7. Bản sao weather phía Prefs (`OMCCommon.m`): GPT phán chỉ audit đọc, không sửa khi chưa có bằng chứng chức năng — audit chưa thực hiện.
8. `ahForgetView:` chưa tồn tại (khe hở lý thuyết khi removeHomeButton giữa lúc mờ; đánh giá rủi ro ~0, chờ GPT phán làm hay bỏ).
9. Comment tồn dư: ABChannels.m §7 còn câu mô tả `single` nuôi isSplit (nay chỉ còn nuôi fallback) — việc dọn comment, không ảnh hưởng hành vi.
10. Splash `contentView.userInteractionEnabled` [INFERRED] và 3 ô ivar playIntro phía xe (0xcb0/0xcc0/0xcc8) vẫn đỗ như các vòng trước.

## 6. Hồ sơ tiền giao theo WO — trạng thái

| Hạng mục WO yêu cầu | Trạng thái |
|---|---|
| Lỗi source đã sửa kèm file:line | Có — 5 biên bản fix-w-act-app / fix-wp-owner / fix-p-diag / fix-y-issplit / fix-w-probe + PATCH_NOTES §24.2 |
| Bảng F1–F4 + ACT | Có — mục 1 của bản này |
| Bảng arbitration SPLIT/EXPANDED | Có — mục 2 của bản này (kèm caveat (ii)/(iii)) |
| Kết quả nhận diện pair native/hosted | **Chưa có** — chờ log phiên xe (probe W4 + Gate 2) |
| Bằng chứng YT lease/apply/revoke | Tĩnh: có (mục 3). Xe: **chưa có** — chờ phiên đo Y2 |
| Kết quả Weather + núm | Tĩnh: có. Xe: **chưa có** |
| Báo cáo crash/.ips + log chưa giải thích | Chưa có phiên ytz2 — bổ sung sau phiên xe |
| SHA-256 + UUID hai lát của bản giao | **Có** — FAT 1.221.708 B, SHA-256 `bb59ab5653540f21d915631213621c0158fc2850038f6d0959b3eca95087dc20`; candidate 1.021.310 B, SHA-256 `4737cfa93c2c5a6a7c7ade37a0b7731718f626bb267dd2d03cf6d9f54018d6ad`; CI run 42583754018 SUCCESS, source `a763030`; bảng UUID 8 binary × 2 lát trong ACCEPTANCE_YTZ2.md / ci-ytz2.md §3 |
