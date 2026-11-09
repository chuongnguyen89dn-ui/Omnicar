# HL2-SPLIT — báo cáo strand thi công (P6 picker / F6 cờ 'to' / W6 đầu nhận pinch / G6 trial Gate 3)

Ngày: 2026-11-09 · Baseline main bcf10e6 · Cây sửa: `~/workspace/push9-clone/recovered-source/src/`
Phạm vi file đã chạm: `SplitScreenB/SCPCarSplit+Picker.m`, `SplitScreenA/SCPCarSplit+BridgeWake.m`, `SplitScreenA/SCPFullscreenController.m`.
KHÔNG chạm: `SCPCarSplit.m`, `SCPPinchController.m` (chỉ đọc), `SCPFullscreenAdapter.h/.m` (chỉ đọc), `SCPCarSplit+BridgeWake.h` (không cần — handler mới khai báo trong interface Private của .m). Không chạy git, không sửa cây project/.

Nguồn sự thật đã đọc trước khi sửa: `YTZ5HL1_GATE3_PINCH_RULING_20261109.md` (§1–§3, §6), `YTZ5HL1_LOG_REVIEW_20261109.md` (§3, §5), biên bản phiên `analysis-s2-picker.md` (nhánh (b), nghi phạm (b1)/(b2)), `analysis-s5-wake.md` §3 (ca seq=45 + FS snap to=1), PATCH_NOTES §29.12, và source thật của cả 5 file đích + `BridgeWakePack.h` + `SplitScreenC/BWInputStore.h` + `SCPCTouchWatch.m` + `SCPCarSplit+Chrome.m` (updatePopupShield) + các điểm gọi cover (Divider/Panel/RatioMenu).

---

## BẢN ĐỒ THAY ĐỔI (khai trước thi công, đã thi công đúng bản đồ này)

### P6 — Picker (chỉ `SplitScreenB/SCPCarSplit+Picker.m`)
- Audit toàn bộ: `showPickerForSlot:` (~155–209), `addCoverToPane:` (~114–139), `buildPickerSheetForPane:` (~326+), `trayWindowForParent:`, `updatePopupShield` (Chrome.m), `SCPKnobFaceView`/`SCPApplyMeshBackdrop`, vòng đời `pane.cover`/`pane.picker`.
- Nếu kết án được 1 phần tử → sửa đúng phần tử đó. Nếu không → gắn ĐÚNG MỘT dòng đo `[picker-measure]` trong `showPickerForSlot:` ngay sau điểm bắt hasContent (sau khi `picker.backgroundColor` đã gán, cùng khối thẳng không rẽ nhánh). **Kết quả audit: KHÔNG kết án được → đi nhánh gắn đo** (xem kết luận P6).

### F6 — Cờ 'to' (chỉ `SplitScreenA/SCPFullscreenController.m`)
- Truy trường `to` trong `fsRefusalSnapshot:` về nguồn sinh. Nếu là lỗi ghi log → sửa tầng LOG. **Kết quả: `to` = `split.trayOverlay`, KHÔNG phải đầu vào predicate → đổi nhãn `to=` thành `trayOverlay=` trong dòng snap + chú thích nói rõ không phải đầu vào guard** (xem kết luận F6).

### W6 — Đầu nhận pinch phía owner (chỉ `SplitScreenA/SCPCarSplit+BridgeWake.m`)
- Đăng ký observer NSDistributed cho đúng tên `com.anlai.omnicar/bridgewake.v1.pinch` tại `bwInstallOwner`, cùng chỗ với observer kbstate.
- Handler `bwHandlePinchNote:` validate theo kỷ luật kbstate/BWInputStore: hash→assignment sống, gen hiện tại, session theo BWInputStore (giới hạn nêu rõ khi chưa có), seq tăng nghiêm ngặt theo (hash,gen,session), dedup (gid,seq), TTL |now−t| ≤ 1000 ms.
- Đạt → gọi SCPFullscreenAdapter (qua instance adapter chung của SCPPinchController — cùng bề mặt legacy từng dùng): dir=out chỉ khi committed=SPLIT, dir=in chỉ khi committed=EXPANDED; còn lại reject `badstate`, không bắn.
- Log `[pinch2] owner accept/reject reason=...` (badhash/badgen/badsession/staleseq/stale/badstate/dup) + completion applied.
- Legacy: chỉ đọc `SCPPinchController.m`, xác minh cơ chế khoá; sửa điểm bắn legacy CHỈ khi chưa bị khoá. **Kết quả: legacy đã bị khoá bởi migration pref → không sửa** (xem mục cơ chế legacy).

### G6 — Packet trial Gate 3 + packet pinchMode (chỉ `SplitScreenA/SCPCarSplit+BridgeWake.m`)
- Đọc đường soạn packet: state packet vốn được soạn **theo từng pane, địa chỉ bằng hash28 của bundle pane đó** (`bwEmitStateForPane:` → `BWEmitStatePacket` → `BWPackFields(hash28,...)`), KHÔNG phải một gói broadcast mù cho mọi app → override theo pane khả thi, không đổi định dạng gói.
- Thêm helper `BWEmitModesForBundle` dùng chung cho cả điểm pack (`bwEmitStateForPane:`) và điểm tính emission-signature (`bwRecomputeForPane:`), để thay đổi trial/pinchInApp tự kích hoạt re-emit như thay đổi state.
- Pref đọc tại `bwReloadModesAndRepublish`: `bridgewake.gate3TrialBundle` (vắng → mặc định `com.google.ios.youtube`; chuỗi rỗng → tắt trial), kill-switch `bridgewake.gate3Trial` (vắng → bật, 0 → tắt).
- Packet của pane trial: trường wakeMode = ENFORCE; pane khác giữ `bwWakeMode` toàn cục (absent = DRY_RUN, không đổi).
- Packet pinchMode của pane hosted đặt theo pref `bridgewake.pinchInApp`: vắng → ENFORCE, 1 → DRY_RUN, 0 → OFF. Điểm đặt: `BWEmitModesForBundle` (áp tại `bwEmitStateForPane:`).
- Log `[gate3]` khi phát packet trial tại thay đổi assignment/state/mode (theo emission signature) + bộ đếm mọi packet trial; thêm 1 dòng `[gate3]` cấu hình tại mỗi lần reload pref (install/prefs-changed, không theo heartbeat).

---

## KẾT LUẬN AUDIT P6 — KHÔNG kết án được bằng source → đã gắn đúng một dòng đo

Giữ nguyên `hasContent` + đường clear của placeholder (dữ kiện xe: hasContent=1 cả 2 lần mở).

Căn cứ theo dòng source (số dòng theo file trước khi sửa):

1. **`pane.cover` (nghi phạm b1) — cấu trúc khớp, hiện diện KHÔNG chứng minh được.** `addCoverToPane:` (Picker.m:114–139): view phủ toàn `pane.view.bounds`, `backgroundColor` = rgb(0.9333, 0.9412, 0.9843) alpha 1.0 — đúng hằng màu đặc của placeholder, `insertSubview:aboveSubview:pane.host`, fade alpha 0→1 trong 0.12 s, `userInteractionEnabled = NO`, không phát log nào. NHƯNG các đường gọi add cover chỉ có: `Divider beginResize` (kéo divider), `RatioMenu` show và `Panel` tray — hai đường sau **chỉ khi `trayWindowForParent:` trả nil** (window == nil). Hai lần mở đo được trên xe, sheet ở cửa sổ riêng ("cua so rieng" → window != nil) nên hai đường đó không add cover trong cấu hình đó; không có bằng chứng source nào cho thấy cover được add ngay trước/trong `showPickerForSlot:`. Cover rò rỉ từ một lần resize/ratio-menu trước đó vẫn là khả năng (remove chỉ ở endResize +0.45 s / hideRatioMenu / collapseAppTray / vòng dọn ở SCPCarSplit.m:1797) nhưng source không kết án được.
2. **Shield của popup (nghi phạm b2) — bị source BÁC về mặt thị giác.** `pickerShield` (property riêng của picker) luôn bị đặt nil trong `buildPickerSheetForPane:` và không nơi nào gán view thật — nó không phải lớp che. Shield sống thật là `popupShield` do `updatePopupShield` (Chrome.m:425+) quản: một `SCPCTouchWatch` với `backgroundColor = white alpha 0.02`, `hitTest` luôn trả nil (SCPCTouchWatch.m), và layer mask even-odd chỉ vẽ NGOÀI các lỗ exempt — alpha 0.02 không thể tạo mảng trắng đặc người dùng thấy. Nó đúng là dựng tại thời điểm mở picker (khớp log "shield host" +0,39 s) nhưng chỉ chặn/ghi nhận chạm, không che hình.
3. **Sheet + mesh backdrop — chỉ phủ vùng sheet.** `buildPickerSheetForPane:` (Picker.m:326+): `effectView = SCPKnobFaceView()` + `SCPApplyMeshBackdrop` (Chrome.m:38–50, contentView clear + mesh image) có frame = `sheet.bounds`; sheet là cửa sổ/cụm ở giữa area, không phủ toàn ô.
4. **`trayWindowForParent:`** — window nền `clearColor`, level StatusBar+65, hitTest pass-through ở vùng trống; không phải lớp đặc.

→ Vì không phần tử nào bị source kết án đích danh, đã gắn **đúng một dòng đo** `[picker-measure]` trong `showPickerForSlot:` ngay sau điểm bắt hasContent (sau gán `picker.backgroundColor`, cùng khối thẳng): ghi alpha/hidden/superview/frame/backgroundColor (dạng r,g,b,a) của **cover, picker, sheet, cả hai shield (popupShield + pickerShield)** và **frame/level/hidden của trayWindow**. Lần mở xe tiếp theo sẽ kết án được: cover alpha=1 + superview=pane.view ⇒ (b1); cover nil mà vẫn trắng ⇒ loại cover, soi tiếp sheet/shield theo số đo.

Ràng buộc giữ nguyên: đường solid của ô trống không đổi, sheet/nút chọn giữ hit target + backdrop, `updatePopupShield` không đổi (shield vẫn chặn chạm ngoài sheet qua SCPCTouchWatch).

## KẾT LUẬN F6 — 'to' là `trayOverlay`: cờ hosting-mode dính, KHÔNG phải đầu vào của predicate → sửa tầng LOG

- Sinh từ đâu: `fsRefusalSnapshot:` (SCPFullscreenController.m) pack `(int)split.trayOverlay` vào nhãn `to=`.
- `trayOverlay` là gì: property BOOL của SCPCarSplit, được đặt **một lần duy nhất** tại `SCPCarSplit+Panel.m:188` — `self.trayOverlay = (window != nil)` khi panel layout được host — và **không bao giờ reset** trong toàn cây (grep toàn src: chỉ 1 điểm gán). Nó là cờ "panel đang/đã được host kiểu overlay-window", dùng ở `SCPCarSplit.m:2216` (appArea) và `AutoHide.m:175`, **không xuất hiện trong predicate expand/restore nào** của FS controller.
- Predicate thật của expand (SCPFullscreenController.m, `fsExpandWithCompletion:`): phase (busy/state), `split.active`, container/parent/window, `zoomedSlot`, `soloHostedBundle`, `pickerSheet`, `popupOpen`, `fsTraySurfaceBusy:` (dragGhost + toast tag 0x5c9b). Chính comment [fix-g] trong file đã ghi trayOverlay là "sticky hosting-mode flag… NOT an open/closed signal". Năm lần refused trong log ytz5hl1 có lý do thật là `state=SPLIT` (restore ×3) và `reason=inactive` (expand ×2) — `to=1` chỉ là cờ dính luôn bật sau lần host panel đầu tiên, trùng hợp 5/5.
- Sửa: nhãn trong dòng snap đổi `to=%d` → `trayOverlay=%d` + mở rộng comment của `fsRefusalSnapshot:` nêu rõ không phải đầu vào guard. Thứ tự/giá trị các trường khác trong snap giữ nguyên; không đụng predicate.

## CƠ CHẾ LEGACY-PINCH ĐÃ XÁC MINH (W6)

- Đường bắn cũ: `SCPPinchController.scpRecognizerDidCross:` (SCPPinchController.m) — điểm bắn duy nhất — chỉ gọi adapter khi `mode == SCPPinchModeEnforce && wouldPinch`. Mode lấy qua arbiter = `bwPinchMode` của owner, tức pref `bridgewake.pinchMode`.
- Khoá hiện hành (đã xác minh trong source `bwReloadModesAndRepublish`): **[ytz5] migration một lần** — nếu marker `bridgewake.pinchOffMigratedYtz5` vắng mặt, mọi giá trị pinchMode đã lưu ≠ 0 bị ghi đè về 0 (CFPreferencesSetAppValue) đúng một lần, kèm dòng `[pinch1] legacy pinchMode overridden to OFF (ytz5)`; absent → OFF. Đối chiếu log xe ytz5hl1: `bw modes … pinch=0` ×9 và `wouldPinch=0` 34/34 probe — legacy OFF suốt phiên.
- Kết luận: khi pinch trong-app hoạt động (packet pinchMode = ENFORCE theo `bridgewake.pinchInApp`, G6), legacy KHÔNG thể bắn trùng vì mode của nó vẫn OFF theo pref riêng `bridgewake.pinchMode`. **Một chủ bắn duy nhất được bảo đảm bằng tách nguồn pref**: legacy ← `bridgewake.pinchMode` (mặc định/migration = OFF), in-app ← `bridgewake.pinchInApp` (mặc định ENFORCE). Không sửa SCPPinchController.m (sửa thừa bị cấm; strand được phép sửa file này chỉ để vô hiệu khi chưa khoá — điều kiện không xảy ra).
- Lỗ hổng còn lại (ghi nhận, không tự ý sửa): nếu người dùng chủ động đặt `bridgewake.pinchMode=2` SAU migration, legacy sẽ sống lại song song với relay trong-app. Khi đó FS controller vẫn chống lệnh trùng ở tầng transaction (phase busy/state refuse + adapter chỉ nhận lệnh khớp committed state), nhưng hai nguồn cùng bắn là cấu hình người dùng tự chọn, không phải mặc định.

## W6 — CHI TIẾT THI CÔNG

- Kênh: observer NSDistributed trên `BWPinchNoteName = @"com.anlai.omnicar/bridgewake.v1.pinch"` đăng ký trong `bwInstallOwner` ngay sau observer kbstate (cùng NSOperationQueue mainQueue).
- Payload đọc: `hash, gen, session, seq, gid, dir, t`.
- Thứ tự validate trong `bwHandlePinchNote:`:
  1. `badhash` — hash = 0 hoặc không khớp assignment đang sống nào (`BWSlotForHash28` trên `bwBundleBySlot`, cùng cơ chế reverse-lookup của wake/act).
  2. `badgen` — gen ≠ `bwGenBySlot[slot]` hiện tại.
  3. `stale` — thiếu `t` hoặc |now − t| > 1.0 s (TTL 1000 ms; hai tiến trình cùng đồng hồ thiết bị).
  4. `badsession` — BWInputStore đã có session cho assignment này (từ kbstate) còn tươi (≤ BW_KB_FRESH_WINDOW 3.5 s) và session của note khác nó. **Giới hạn nêu rõ**: owner không có nguồn session độc lập cho assignment ngoài kbstate; app chưa từng báo kbstate cho assignment hiện tại ⇒ chưa có session để đối chiếu, khi đó session của note trở thành khoá sắp xếp (cùng gen + seq + TTL) và dòng accept ghi `sessrc=note` (có đối chiếu được thì `sessrc=store`) — giới hạn nhìn thấy được ngay trong log.
  5. `dup` — (gid, seq) trùng lệnh đã accept gần nhất của slot; `staleseq` — cùng khoá (gen, session) mà seq không tăng nghiêm ngặt. Đổi (gen, session) ⇒ baseline mới (giống kỷ luật takeover của BWInputSlotReport).
  6. `badstate` — pane không còn assigned/hosted, hoặc dir/state không khớp: dir=1 yêu cầu committed = SPLIT, dir=2 yêu cầu committed = EXPANDED (đọc qua `adapter.currentState` = `fsCommittedState`); pending (EXPANDING/RESTORING map về Split/Expanded theo §4.1 nhưng lệnh vào sẽ bị chính FS controller refuse ở phase-gate và completion ghi applied=0), unknown, dir lạ ⇒ không bắn.
- Accept: ghi book (gen/session/lastSeq/lastGid) TRƯỚC khi bắn, log `[pinch2] owner accept …`, gọi `[adapter requestExpandWithCompletion:]` / `requestRestoreWithCompletion:` trên instance adapter chung của `[SCPPinchController shared]` (SCPFullscreenAdapter → SCPFullscreenController, provenance "pinch"); completion log `[pinch2] owner expand/restore applied=%d gid=…`.
- kbstate handler không bị đụng; không @available; không đổi BridgeWakePack.

## G6 — CHI TIẾT THI CÔNG

- Kiến trúc packet: **địa chỉ theo pane bằng hash28** (mỗi state packet mang hash của đúng một bundle và app chỉ nhận packet khớp hash của mình) ⇒ override wakeMode theo pane nằm trọn trong `bwEmitStateForPane:`, không cần gói riêng, không đổi định dạng BridgeWakePack 64-bit. (Trường hợp "broadcast một gói cho mọi app" không xảy ra ở tầng pack: kênh Darwin là kênh chung nhưng mỗi post chỉ chứa một word địa chỉ theo hash — app khác hash sẽ bỏ qua.)
- Điểm đặt pinchMode packet: `BWEmitModesForBundle` → dùng tại `bwEmitStateForPane:` (pack) và `bwRecomputeForPane:` (signature). Trước đây packet pm = `bwPinchMode` toàn cục; nay pm của packet = `bwPinchInAppMode`. `bwPinchMode` vẫn giữ nguyên vai trò cho arbiter/legacy (xem mục legacy) và cho hai đường phát đặc biệt KHÔNG qua `bwEmitStateForPane:` — teardown (`bwSessionTeardown` phát INACTIVE bằng mode toàn cục) và `BWForceOffBroadcast` (ép OFF/OFF khi owner lỗi): cả hai cố ý giữ nguyên, trial/pinch-in-app không được sống sót qua teardown hay đường fail-open.
- Trial chỉ áp khi: kill-switch bật (vắng = bật) VÀ bundle của pane == trial bundle (vắng = `com.google.ios.youtube`, chuỗi rỗng = không bundle nào). wakeMode toàn cục không đổi cho mọi pane khác.
- Log `[gate3]`: (1) dòng cấu hình tại mỗi `bwReloadModesAndRepublish` (`trial bundle=… enabled=… packetPinch=…`); (2) dòng `trial packet …` khi shape packet trial thay đổi (assignment/state/mode — theo `bwGate3TrialSigBySlot`), kèm `count=` là tổng số packet trial đã phát (đếm mọi lần phát, log chỉ khi đổi shape → vòng renew 1.0 s không spam).

## TÓM TẮT HUNK (file:dòng, số dòng sau khi sửa)

**SplitScreenB/SCPCarSplit+Picker.m**
- :92–113 — helper tĩnh mới `SCPViewMeasureDesc` (mô tả đo alpha/hidden/superview/frame/bg).
- :195–225 (trong `showPickerForSlot:`, ngay sau gán `picker.backgroundColor`) — đúng MỘT dòng log `[picker-measure]` + comment kết luận audit.

**SplitScreenA/SCPFullscreenController.m**
- :295–311 — comment `fsRefusalSnapshot:` bổ sung kết luận F6; format snap: `to=%d` → `trayOverlay=%d`. Không đổi predicate, không đổi trường khác.

**SplitScreenA/SCPCarSplit+BridgeWake.m**
- :31 — khai báo `bwHandlePinchNote:` trong interface Private.
- :56–66 — statics G6 (bwGate3TrialBundle/Enabled, bwPinchInAppMode, bwGate3TrialSigBySlot, bwGate3TrialEmitCount).
- :128–150 — hằng `BWPinchNoteName` + statics book W6 theo slot (gen/session/lastSeq/lastGid/has).
- :196–218 — helper `BWEmitModesForBundle`.
- :355–389 — `bwEmitStateForPane:` dùng mode theo pane + đếm/log `[gate3]` trial.
- :840–855 — `bwRecomputeForPane:` tính signature bằng cùng mode theo pane.
- :520–625 — `bwHandlePinchNote:` (validate + accept/reject `[pinch2]` + gọi adapter).
- :955–980 — `bwReloadModesAndRepublish:` đọc 3 pref G6 + log `[gate3]` cấu hình.
- :1240–1255 — `bwInstallOwner:` đăng ký observer kênh pinch cạnh kbstate.

**Không sửa**: SCPPinchController.m, SCPFullscreenAdapter.h/.m, SCPCarSplit+BridgeWake.h, SCPCarSplit.m.

## KIỂM CHỨNG TĨNH

- `clang-18 -fsyntax-only` (SDK iPhoneOS16.5, target arm64-apple-ios16.0, ARC): `SCPFullscreenController.m` sạch hoàn toàn. `SCPCarSplit+BridgeWake.m`: chỉ còn 2 lỗi `NSDistributedNotificationCenter` undeclared — **cả hai cùng một identifier, một ở đăng ký kbstate CÓ TỪ TRƯỚC và một ở đăng ký pinch mới** (môi trường check thiếu khai báo mà bản build thật có; mã mới dùng đúng idiom của mã cũ). `SCPCarSplit+Picker.m`: các lỗi đều ở mã gốc do include-order của phép check ad-hoc (interface SCPCarSplit của module A che của B); **không lỗi nào rơi vào dòng đã thêm** (đã grep riêng theo khoảng dòng 92–120 và 195–225: sạch). Chưa build deb — việc build thuộc coordinator.

## DISCRIMINATOR (grep trong binary sau build)

- `[pinch2]` — 4 format string trong BridgeWake.m: `owner reject reason=%s`, `owner accept`, `owner expand applied=%d`, `owner restore applied=%d`.
- `[gate3]` — 2 format string: `trial bundle=%@ enabled=%d packetPinch=%ld` (reload) và `trial packet bundle=%@ slot=%ld wm=ENFORCE` (phát packet).
- `[picker-measure]` — format string `slot=%d hasContent=%d cover{%@} picker{%@}` trong Picker.m.
- F6: chuỗi snap mới `trayOverlay=%d` có mặt và `to=%d` vắng mặt trong SCPFullscreenController (grep source: `to=%d` = 0).

## RỦI RO MỞ

1. **P6 chưa kết án**: cần đúng 1 lần mở picker trên xe với bản có `[picker-measure]` mới chốt được (b1) cover rò hay nguyên nhân khác (vd scene/host bị mờ ở tầng khác — log phiên trước cho thấy không có [scenevis] nào trong cửa sổ mở picker). Nếu cover bị kết án, hướng sửa đã rõ ràng buộc: gỡ/không-add cover cho pane khi mở picker mà vẫn giữ đường solid của ô trống.
2. **W6 session**: khi app chưa báo kbstate cho assignment hiện tại, session không đối chiếu được phía owner (`sessrc=note`) — relay vẫn được giữ bởi gen + seq + TTL + hash-assignment + state-gate, nhưng đây là mắt xích yếu nhất của W6; phía app (strand APP) nên bảo đảm kbstate/pinch dùng cùng session id để khi kbstate đã chảy, `sessrc=store` khoá chặt.
3. **W6 đồng hồ**: TTL dùng `t` của app so với đồng hồ owner — cùng thiết bị nên khớp; nếu strand APP gửi `t` bằng đồng hồ monotonic thay vì wall-clock thì mọi relay sẽ `stale` — cần đối chiếu khi ghép hai strand (payload spec của đề bài ghi `t` không nói rõ loại đồng hồ; handler hiện kỳ vọng giây epoch như kbstate/BWNow).
4. **G6 ↔ app**: packet pm đổi nguồn từ `bridgewake.pinchMode` sang `bridgewake.pinchInApp` — phía app đọc bits 9–8 như cũ nên tương thích dây, nhưng mọi ghi chép/vận hành cũ nói "pinchMode trong packet" nay phải hiểu là pinchInApp; `bw modes` log vẫn in pinch= của legacy, dòng `[gate3]` in packetPinch= riêng để phân biệt.
5. **Gate 3 ENFORCE thật**: trial chỉ đổi trường wakeMode trong packet của YouTube; mắt (c) của phán quyết (orig_SendEvent thật sự bị bỏ qua) chỉ nghiệm thu được trên xe với bản ENFORCE — strand này không tự tuyên bố DEVICE PASS.
6. **F6**: các công cụ/log cũ grep theo `to=` sẽ không khớp nữa — khi đọc log bản mới dùng `trayOverlay=`.
