# verify-arbiter-diag-probe — KIỂM ĐỘC LẬP 2: ARBITER / DIAG / PROBE (chỉ đọc)

Ngày: 2026-11-09. Kiểm chéo độc lập các khẳng định của `fix-wp-owner.md`, `fix-p-diag.md`, `fix-w-probe.md` — đối chiếu trực tiếp source cây `project/` (+ mirror `src/`) và binary trong candidate `com.anlai.omnicar_1.0.3-ytz2_iphoneos-arm64.deb`. Không sửa file nào. Lệch với biên bản strand được ghi nguyên trạng, không tự hoà giải.

## (a) Arbiter EXPANDED theo phiên — ĐẠT (2 ghi chú)

Bằng chứng gốc: `grep isEqualToString:bwExpandedBundle` trên `SCPCarSplit+BridgeWake.m/.h` = **0 hit** (cả project/ và src/). `bwExpandedBundle` chỉ còn khai báo (BridgeWake.m:55, comment ghi "LOG ONLY") và gán ở setter (:323) — không còn điểm đọc nào trên đường phân xử.

Ba điểm đã sửa:

| Điểm | Vị trí | Vị từ EXPANDED |
|---|---|---|
| `bwPinchAllowedForPane:` (cờ gói) | BridgeWake.m:307–310 | `bwExpandedFlag && self.active && [[self allPanes] containsObject:pane] && !bwWakePendingBySlot[pane.slot] && !self.resizing` → YES (sau 2 guard slot/bundle :298–299) |
| `pinchDispositionForPane:touchesSuppressed:` | BridgeWake.m:788–791 | **giống hệt từng toán hạng** → `SCPArbiterPinchAllowed` |
| promote trong `bwRecomputeForPane:` | BridgeWake.m:399–400 | `state == BWStateHidden && bwExpandedFlag` → VISIBLE |

**Ghi chú 1 (điểm 3 không nguyên văn cùng vị từ):** điểm promote chỉ viết `bwExpandedFlag`, không lặp 4 toán hạng còn lại. Tương đương ngữ nghĩa nhờ guard bao quanh đã thiết lập sẵn: `assigned` (:356) = `self.active ∧ bundle.length ∧ pane ∈ hostedPanes`; state HIDDEN chỉ tới được khi không wake-pending (nhánh WAKING :362 đứng trước) và không resizing (`resizing ⊂ transient` → UNKNOWN, :373–378). Khẳng định "cùng một vị từ" của strand đúng về ngữ nghĩa, không đúng nguyên văn tại điểm 3. Không phải lỗi hành vi; ghi để GPT biết dạng thật của code. (Bất đối xứng cấu trúc kèm theo: promote chỉ chạy cho pane hosted vì state packet chỉ tồn tại cho pane hosted; hai hàm arbiter bao cả allPanes gồm native — đúng vai trò từng điểm.)

**Truy vết lại 6 trường hợp WO trên code hiện tại** — khẳng định cột "Sau" của bảng fix-wp-owner §3 cho cả 6:
1. *Expanded, bundle owner = nil:* hàng EXPANDED đứng trước mọi kiểm state ở cả hai hàm (:307 trước :313; :788 trước switch :792) → cờ YES / disp Allowed, không phụ thuộc state. ✔
2. *Hỗn hợp native + hosted:* pane native ∈ allPanes → qua hàng EXPANDED ở cả hai hàm (hàm cờ thêm điều kiện bundle.length — pane native có bundleID). ✔
3. *Hai hosted:* từng pane đánh giá độc lập qua cùng vị từ. ✔
4. *Đổi pane:* vị từ đọc membership của pane object trong allPanes, không đọc bundle — pane mới qua, pane bị gỡ không. ✔
5. *Pane bị xoá khi expanded:* pane ∉ allPanes → hàng EXPANDED trượt ở cả hai hàm. ✔ **Ghi chú 2 (ranh giới):** phần "cờ rơi về INACTIVE" trong biên bản phụ thuộc recompute/teardown đã chạy cho pane bị xoá; nếu `bwStateBySlot` còn giữ VISIBLE cũ, disposition rơi vào hàng SPLIT thường (VISIBLE → Allowed theo hàng thường, không phải hàng EXPANDED) — hành vi cũ ngoài phạm vi bảng WO, vòng này không đổi.
6. *Restore sau timeout:* setter :322 gán thẳng `bwExpandedFlag = active` mỗi lần gọi; settle restore gọi OFF → cả hai hàm về hàng SPLIT, không latch. ✔

Cột "Trước" của bảng strand là khẳng định lịch sử — không kiểm chứng lại được từ cây hiện tại, nằm ngoài phạm vi kiểm này. Mirror: BridgeWake.m/.h `cmp` identical project/ ↔ src/SplitScreenA/.

## (b) Default pinch — ĐẠT

- Static init: BridgeWake.m:46 `bwPinchMode = BWModeDryRun`.
- Reload: BridgeWake.m:476 — pref `bridgewake.pinchMode` vắng → `BWModeDryRun` (có pref thì tôn trọng, clamp 0–2 tại :476; getter :753–756 chỉ clamp, không gán mặc định khác). Không còn điểm nào đặt ENFORCE làm mặc định.
- Prefs: segment `bridgewake.pinchMode` `def:1` (OMCSplitScreenController.m:400–404) = DRY_RUN theo mã hoá 0/1/2 dùng chung. Hai phía nhất quán — lệch default mà fix-p-diag §5 cảnh báo (trang hiện "Đo" trong khi owner ENFORCE) **đã được đóng** bởi strand owner.

## (c) [fs-diag] controller — ĐẠT

- **Chỉ đọc pref:** `OMCPref(` trong SCPFullscreenController.m xuất hiện đúng 2 lần (:125 nền lúc cài, :150 trong handler) — cả hai là đọc. Grep API ghi (`CFPreferencesSetAppValue`, `storeValue:`, set NSUserDefaults) = **0**; hit duy nhất của mẫu grep rộng là `[_chromeOriginals setObject:forKey:]` :231 — dictionary trong bộ nhớ lưu cờ chrome gốc, không phải pref.
- **Level safety (OFF khi EXPANDED vẫn restore dù lỡ cạnh):** `fsDiagPrefsChanged` :151–158 — `want == _fsDiagWant` (không cạnh) mà `!want && _phase == SCPFSPhaseExpanded` vẫn gọi `fsRequestRestore…provenance:@"diag"`. ✔
- **Cùng đường với pinch:** adapter gọi `fsRequestExpandWithCompletion:provenance:@"pinch"` / Restore tương ứng (SCPFullscreenAdapter.m:51,56); diag gọi đúng hai method đó với `provenance:@"diag"` (Controller.m:164,166) → cùng cổng bận/trạng thái (:278/:285), cùng txn và xác nhận read-back (:359). ✔

## (d) Prefs nhóm Chẩn đoán — ĐẠT

- **Đăng ký section:** `numberOfSections` 6→7 (OMCSplitScreenController.m:145); rows: `case 6: return 3` (:154), các case 0–5 giữ nguyên giá trị (:149–161); header/footer chỉ cộng nhánh `section == 6` (:170/:178); height: section 6 cộng vào luật 60 pt sẵn có (:215); luật mờ `ip.section >= 2` áp cho section 6 như 2–5, điều kiện không sửa. Sections 0–5 không đổi hành vi.
- **Ba control, đúng idiom trang:** (a) `switchForKey:@"fullscreenDiagExpand" def:NO` (:378); (b) `switchForKey:@"youtubeVirtualize" def:YES` (:389); (c) `segmentForKey:@"bridgewake.pinchMode" … def:1` (:400–404). Đường persist đã truy tận gốc: `switchForKey:`/`segmentForKey:` (OMCCardPage.m:114/:129) → `omcSwitchChanged:`/`omcSegmentChanged:` → `storeValue:forKey:` = `CFPreferencesSetAppValue(OMC_PREFS_DOMAIN)` + `CFPreferencesAppSynchronize` + `notify_post(OMC_PREFS_CHANGED_NOTIFICATION)`, kèm hook `prefChanged:` — đúng idiom mọi control khác của trang.
- **Binary chứa 3 khoá:** trích Prefs bundle từ chính candidate ytz2 (`var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/OmniCarPrefs`): `fullscreenDiagExpand` ×1, `youtubeVirtualize` ×1, `bridgewake.pinchMode` ×1. Binary debug của strand C (`.theos/obj/debug/OmniCarPrefs.bundle/OmniCarPrefs`) cũng đủ 3 khoá ×1.

## (e) Probe — ĐẠT về chất; con số "32" KHÔNG khớp phép đếm call-site

- **Orig gọi trước, nguyên vẹn:** `Hook_UIApplication_sendEvent` (SCPTouchProbe.m:185–193): `orig_UIApplication_sendEvent(self, _cmd, event)` tại :186 trước mọi quan sát; quan sát chạy sau trong `@try/@catch`. ✔
- **Không gọi API cấm:** grep `ahNoteActivity|ahReveal|bwHandle|BWPostAct|ahNote*|swallow` trên SCPTouchProbe.m/.h = 0 lời gọi (hit duy nhất: comment header SCPTouchProbe.h:8 mô tả điều probe KHÔNG làm). Tương tác với split chỉ đọc: `[split allPanes]`, `[split vertical]`, container/trayWindow. Mirror identical. ✔
- **Đúng 1 hook mới:** call site duy nhất SCPTouchProbe.m:198–200 (`UIApplication sendEvent:`). ✔
- **LỆCH CON SỐ — ghi rõ, không hoà giải:** fix-w-probe §6 và cổng các vòng trước dùng số "31 → 32". Đếm call-site nghiêm ngặt trên source hiện tại cho kết quả khác:

| File | grep-line (kể cả comment) | call site thật |
|---|---|---|
| SCPHooks.m | 31 (có 2 dòng comment :2, :614) | **29** |
| SCPSpringBoardHooks.m | 2 (1 comment :169) | **1** (:175) |
| SCPHomeHooks.m | 1 (comment) | 0 |
| SCPTouchProbe.m | 2 (1 comment :5) | **1** (:198) |
| **Tổng module** | — | **31** |

  Tức con số nền "31" của các vòng trước là grep-line của riêng SCPHooks.m — vừa tính thừa 2 dòng comment, vừa bỏ qua call thật ở SCPSpringBoardHooks.m. Kết luận kiểm: **thêm đúng 1 hook là ĐẠT**; con số tuyệt đối "toàn module 32" **KHÔNG đạt** theo phép đếm call-site (số đúng: 31). Đây là lệch quy ước đếm giữa biên bản strand và source, không phải thừa/thiếu hook.

## Tổng bảng

| Mục | Kết quả |
|---|---|
| (a) Arbiter EXPANDED theo phiên, 3 điểm + truy vết 6 ca | ĐẠT — ghi chú: điểm promote dạng rút gọn (tương đương nhờ guard bao); ranh giới ca 5 phụ thuộc recompute |
| (b) Default pinch DRY_RUN hai phía nhất quán | ĐẠT |
| (c) fs-diag chỉ đọc pref / level-safety / cùng đường pinch | ĐẠT |
| (d) Nhóm Chẩn đoán: idiom persist + sections 0–5 nguyên + binary 3 khoá | ĐẠT |
| (e) Probe thụ động, orig trước, +1 hook | ĐẠT về chất — **KHÔNG khớp con số "32"** (call-site thật toàn module = 31) |

Mức đạt của biên bản này: kiểm tĩnh độc lập trên source + binary candidate — không phải bằng chứng xe.
