# HL46 — THỬ NGẮT LỚP CHE NATIVE (không đụng hosted, hoàn nguyên về HL45)

## Yêu cầu mới và lý do đổi hướng
Ngày 13/11/2026 Nguyen yêu cầu: "Nghi ngờ thì tạm tắt đi. Ko đc thì hoàn nguyên." Yêu cầu này **thay thế** hạn chế trước đây "chỉ đo, không thay đổi lớp gốc" của HL44/HL45 đối với riêng phép thử có thể đảo ngược. Mục tiêu: xử lý Waze/Maps **native đang nghe tiếng nhưng mất hình dưới menu chọn ứng dụng**, và native chỉ hiện logo khi kéo divider; hosted YouTube/TikTok vẫn hiện hình. Không khẳng định hai lớp gốc là nguyên nhân duy nhất; nếu sau khi bỏ che mà hình vẫn mất thì cần kiểm native scene/compositor sustain, không xóa bừa thêm lớp gốc.

Không sửa pickerSheet, loader, popup shield/tray window, native scene feed, pushSceneSizes, keyboard/Telex, Zoom, YTZ, AutoHide, Home/Dock, fullscreen, Voice, cấu trúc split/controller hoặc phần Muse. Không gộp thay đổi sang main, không build/ký/CI, không phát hành Sileo trong đợt sửa nguồn này.

## Nguồn và trạng thái mã
Một repo GitHub: chuongnguyen89dn-ui/Omnicar, cây thực thi recovered-source/. Nhánh mới: **feature/duocar-hl46-native-overlay-bypass-20261113**, được tạo đúng từ **HL45 HEAD 3a385c02f121eb6dcc6cf54ad1150ed3531ff1e6** (đã có HL45 lifecycle/opacity logs). Trước checkpoint source+checker HEAD **068544324278f7106f3e3de0ae6ed5547fb095d8**; hunk nguồn chủ yếu ở **dd45a34e**, **355d2a9a**, thêm bình luận ở **0229bdf1**/**06854432**, checker commit **8c65be61**.

Chỉ hai file Objective-C đã thay đổi:
- recovered-source/project/OmniCarSplitScreen/SCPCarSplit+Picker.m
- recovered-source/src/SplitScreenB/SCPCarSplit+Picker.m

Hai file nguồn khớp hoàn toàn, SHA blob GitHub **34950108e2d246964a49a895719ab8e0a040c1eb**. File kiểm source mới nằm trong đầu mối GPT đã có: recovered-source/gpt-project-history/verify_hl46_native_overlay_trial.py (Git blob **36a940a92832f0e17c6884c821996bd155165095**). Toàn bộ compare từ HL45 base khi xác minh cho ra **3 file khác** (hai picker và verifier), không sửa Divider.m hay bộ điều khiển scene/hosted.

### 1. Cover icon khi kéo: ngắt cho native
Tại SCPCarSplit (Picker) addCoverToPane: trước khi khởi tạo view, nếu `pane.vc != nil`, **không phải** `SCPHostedAppVC` theo `SCPVCIsHosted`, và pref `duocarHL46NativeCoverOff` là YES (default YES): không tạo `pane.cover`. Nếu tồn tại cover cũ thì nil property và remove oldCover + animation ngay. Log `[hl46-bypass] cover OFF slot=... mode=NATIVE` cùng `[hl45-layer] ev=hl46-cover-suppressed`. Ô hosted đi qua path gốc; không động đến `beginResize`, `endResize`, 0.45s delayed cleanup, `pushScenes:NO`, icon ghost kéo ô và event layout gốc. `markDismissSlot` sẽ không còn icon mark trên native nếu cover đã ngắt — đây là **ảnh hưởng dự kiến chỉ trong phép thử**, không được tự gọi UI PASS trước khi test. Lệnh gửi alpha cho `pane.cover` trong Drag.m vẫn nil-safe khi không có cover.

### 2. Picker nền khi mở chọn app: trong suốt cho native
Tại showPickerForSlot:, nếu `pane.vc != nil`, không là hosted theo `SCPVCIsHosted`, và pref `duocarHL46NativePickerClear` YES (default YES):
- Vẫn tạo/giữ `pane.picker` làm view, vẫn addSubview và giữ `UITapGestureRecognizer` để `pickerPaneTapped:` / sheet / Cancel / choose có đường nhận chạm như cũ.
- Chỉ đổi `picker.backgroundColor` thành `UIColor.clearColor`, ẩn dấu "+" trên native; nếu còn cover cũ thì gỡ riêng nó.
- Giữ `pickerSheet`, nền mesh và nút/menu gốc, không ngắt sheet. Ô trống và hosted vẫn có background alpha=1 theo gốc; pref OFF khôi phục path gốc cho cả native.
- Log `[hl46-bypass] picker CLEAR slot=... mode=NATIVE` và `[hl45-layer] ev=hl46-cover-detached-at-picker` khi có dữ liệu. Các `[hl45-layer]` event gốc vẫn còn.
Đây là thử nghiệm **thấy hình dưới menu**, không hứa thao tác native bên dưới picker vẫn nhận touch khi menu đang phủ.

### Hoàn nguyên nhanh và A/B
Hai pref công cụ thử nghiệm độc lập, không thêm công tắc vào app hay đè settings: `duocarHL46NativeCoverOff` (YES mặc định), `duocarHL46NativePickerClear` (YES mặc định). Chỉ khi pref tương ứng trả NO đường gốc mới chạy. Có thể tắt từng giả thuyết khi chuẩn bị build/test; sau thay pref cần tạo lại cover/menu để nhận trạng thái mới. Không có cơ chế tự phản hồi test xe hay tự bật lại sau khi đã kết thúc chat.

Hoàn nguyên **toàn bộ nhánh thử nghiệm** bằng cách không merge HL46; base chính xác vẫn là **3a385c02f121eb6dcc6cf54ad1150ed3531ff1e6**, hoặc revert hai hunk nguồn HL46 và checker, chỉ trên nhánh cần đảo. Không sao chép đè nguyên file từ bản gốc vì phiên tích hợp có thể đã đổi. HL45 chính vẫn nguyên vẹn.

## Kiểm chứng thực tế
Đã thực hiện bằng GitHub connector: `search_branches` xác nhận chưa có HL46, `create_branch` trả tên nhánh, `fetch_file` đọc cả hai picker và `update_file` bằng blob SHA thực tế; sau ghi hai cây có cùng blob SHA; `compare_commits` tính từ base cho đúng 3 file như trên. JS static contract PASS: native-only guard `pane.vc != nil && !SCPVCIsHosted`; cover guard trước alloc; picker clear + hidden "+" chỉ trong nhánh native; picker tap/gesture, sheet, nút gốc, nền opaque gốc, lifecycle cleanup, probe HL45 vẫn còn; Hosted classifier được đọc trực tiếp trong `SCPShared.m` và xác nhận `SCPVCIsHosted` chỉ true đối với `SCPHostedAppVC`. Divider/Drag/Panel và bộ điều khiển scene không bị sửa. Không thêm window, modal hay compositor engine.

Có tạo **source-only verifier** để chạy sau khi checkout thật: 
`python3 recovered-source/gpt-project-history/verify_hl46_native_overlay_trial.py`
Kiểm gồm mirror parity, original event contracts, no broad native/hosted contamination, source changes allowlist, baseref pinned. **Verifier đã commit nhưng chưa được chạy trong full git checkout**; không coi JS static check là Objective-C compilation/test xe.

**Chưa build / chưa ký DEB, chưa dispatch CI, chưa thử nghiệm runtime/xe, không có artifact và không có DEVICE PASS.** Không có checkout local Theos/iPhoneOS SDK đáng tin trong phiên này. Không có job mới do GPT khởi động. Muse giữ vai trò tích hợp và build/ký một DEB cuối, trừ khi Nguyen đổi phân công.

## Cổng test/đường ra quyết định
1. Trước một build được cho phép, kiểm current integration/main và run CI; chỉ cherry-pick/hunk 2 TUs HL46 từ nhánh này, không copy đè nguyên file. Chạy verifier trong checkout đầy đủ; compile ObjC/theos với SDK; xác minh package/version/arch/hash trên **chính DEB được giao**, không dựa vào nguồn.
2. Một phiên test xe cùng binary/PID: Waze hoặc Apple Maps native + YouTube hosted, mở menu app trên ô native (thấy nội dung dưới sheet hay không), Cancel, chọn app, kéo vạch qua lại/thả, kéo đổi chỗ; test hosted riêng để chắc menu gốc vẫn tốt. Log `[hl46-bypass]`, `[hl45-layer]`, `[scenevis]` ghép cùng PID/time; video xác nhận raster.
3. Nếu bỏ picker/cover mà native vẫn trống hoặc mất hình sau close/release: **FAIL về giải thuyết lớp che**, bật lại hai pref NO / hoàn nguyên HL46 ngay khi có kết quả; không sửa thêm lớp mới theo suy đoán. Điều tra scene/compositor sustain trong HL45 Option 1 với log mới. Nếu có hình nhưng menu không nhận chọn, mất touch hay hosted/other regression: cũng rollback, không gọi hoàn tất.
4. Nếu thành công, trước khi hợp nhất mã cần kiểm giữ split/dock, resize, picker, lifecycle, reconnect/restart. Cả hai giả thuyết đều chưa thể kết luận DEVICE PASS nếu thiếu video và đúng binary.

Trạng thái checkpoint: **SOURCE PATCHED / GITHUB CONFIRMED / STATIC CONTRACT PASS / NO BUILD / DEVICE PENDING**.


## 2026-11-13 -- REVIEW BEFORE BUILD: fixed A/B bug, pending risks

New user request: carefully review today's unbuilt changes. GitHub source read included HL44/HL45/HL46 Picker/Panel/Divider/Drag, SCPShared, old and new verifiers, standalone Vitals branch and workflow; NO Apple SDK, compile, CI dispatch or device test.

### Confirmed and fixed bug: two trial switches were not independent
Originally showPickerForSlot removed pane.cover unconditionally when native picker-clear was enabled, even when the native cover-off pref was disabled. That contaminated any picker-only experiment. Fixed on THIS HL46 branch in both Picker.m files: only remove an existing oldCover if OMCPref("duocarHL46NativeCoverOff", @YES) is YES. The new diagnostic includes coverRetained, and the two controls now have separate semantics.
Project commit b305994ff3f205dcc873689e85d5d0b23faee876; src mirror commit d1a0ebf9da54e4535034587a4a19c463df4360b8; Git blob both f75939ac41bbe0e9f77f05520dff456cc4188d62.
Policy matrix for an occupied native pane: pickerClear=0,coverOff=0 => original/original; (1,0) => transparent picker, existing cover retained; (0,1) => original opaque picker, resize cover suppressed; (1,1) => both visually bypassed. Empty and SCPHostedAppVC panes always use the original paths. No new view owner or scene engine.
Updated existing HL46 independent verifier script with explicit cover-removal guard, coverRetained log and the four policy combinations, commit 12b341da6501e03241ce9244754a27923d122ecf, blob 0d835f611dff3ebe1cbc5ee478f3a9b393e7fdac. Script still NOT executed in full checkout, tests are connector code checks only.

### Deep checks and precise unresolved risks
- Panel.paneChoose calls showPickerForSlot and refreshPickerSheetSoon. HL46 retains original picker view, its pickerPaneTapped gesture, the sheet with mesh face, Cancel/Choose and the other original lifecycles. A transparent overlay still intercepts native touches; preserving video is NOT equivalent to allowing live native interaction behind picker.
- Divider.beginResize still calls addCoverToPane for each slot; HL46 native-VC guard suppresses creation. Divider.endResize's delayed 0.45s cleanup/removeCoverFromPane is nil-safe. Drag.m's pane.cover.alpha sends are nil-safe too; pane dragGhost is a different original icon surface, which must be distinguished from resize cover in a car video.
- Divider's relayoutAnimated:NO pushScenes:NO remains unchanged while dragging. Native scene dimensions may stay stale or show stretched/frozen pixels despite removing cover; this hypothesis cannot be resolved statically and scene push policy was deliberately not changed without runtime data.
- Native-only classification uses pane.vc != nil and SCPVCIsHosted (isKindOfClass:SCPHostedAppVC). Pending/non-adopted native sessions lack the VC and are deliberately not bypassed; test must report mode and scene state. Original opaque loader exists on launch; showPickerForSlot calls removeLoaderFromPane before presenting picker.
- HL45 historical source checker enforces read-only changes and exact five-file diff vs HL44, thus MUST run on HL45, NOT unchanged on a HL46 experiment intentionally changing visuals. HL46's own verifier checks its source delta. If combining branches for final DEB, a dedicated integration gate is required; do not silently skip the older test.
- Existing .github/workflows/build-fat-macos.yml on both unbuilt branches still hardcodes HL37 version/deb names 1.0.3-hl37kbsync1 and historical gates; does NOT yet build a correct integrated HL46+vitals artifact as-is. Muse/build owner must reconcile workflow/version/artifact path/gates and HEAD before the authorized future one-DEB build.
- Vitals branch and HL46 are sibling feature branches from HL45. Neither contains the other's patch. Main is documentation-only; no code merge or device build. The test on car must use one exact-generation version/PID and video, not mix old HL42/HL43 logs.

### Status and decision gate
Source bug fixed and GitHub committed; actual Objective-C compilation, native visual touch, hosted regression, bubble window behavior, GPU/sensor accuracy and CarPlay test all PENDING. No CI, DEB, Sileo or deployment this round. If bypass does not improve native picture or causes touch regression, revert this HL46 experiment to its unchanged baseline commit 3a385c02f121eb6dcc6cf54ad1150ed3531ff1e6, then investigate scene/compositor sustain using HL45 logs rather than deleting more original layers.
