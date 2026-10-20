# OmniCar QA7 — vì sao YouTube có UI và nút ba chấm khác các ứng dụng khác?

Ngày 2026-10-20, chỉ điều tra/read-only. **KHÔNG sửa bản QA7 đang chạy, không đóng DEB, không phát hành Sileo.**

## Báo cáo thiết bị thực từ người dùng

- Sau nâng cấp `1.0.3-omnicar7`: **OmniCar mở trở lại**; hai ứng dụng bản đồ chia màn hình với thanh chia đầy đủ; nút điều khiển của hai bản đồ và các ứng dụng khác **tự ẩn được**; **chỉ YouTube không ẩn** theo cơ chế yêu cầu.
- Người dùng còn cảm thấy giao diện YouTube trong OmniCar không tự nhiên và nghi có lớp UI riêng.
- Đây là QA7 device-PASS từng phần: launch, map+map divider, native idle cho maps/others. **Không** tự động suy ra mọi thao tác/YouTube host đã PASS; không sửa khả năng chia đôi, host hay Zoom/Swap đang ổn định.
- Lỗi nghiêm trọng QA6 đã xác nhận trước đó: crash khi mở và mất thanh chia, nên tuyệt đối không đưa lại QA6 `hostedPanes`/ `hostHandle` áp opacity chưa xác nhận.

## Bằng chứng đọc trực tiếp trong repo (không suy đoán tên class)

1. Original binary read-only audit `audit/OmniCar_verified_ui_class_owner_skin_hooks_20261019.md`: trong `OmniCarAppBridge.dylib` có Objective-C `ABHost -buildBarForPane:`, `-layoutBarForPane:`, `-setupHandleForPane:`; có `ABPane.bar` và `ABPane.handle`. Đây là **nhóm owner UI riêng** với `SCPCarSplit` và `SCPCarPane.handle` của `OmniCarSplitScreen.dylib`.
2. `audit/OmniCar_YouTube_AppBridge_scaling_20261019.md` đã giải nén/đọc original DEB SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`, chứng minh `OmniCarAppBridge.dylib` có `ABHost.openApp:frame:`, `layoutPane:`, `zoom`, `setFrame:forApp:live:handle:passInsets:`, `SBSceneView._updateReferenceSize:andOrientation:`; prefs `appBridgeZoom` clamp **0.6...1.0** và `appBridgeOrientation`. `OmniCarSplitScreen.dylib` gửi frame thông qua `hostFrameInfo:pane:live:handle:` và `sendHostFrameForPane:live:`. AppBridge plist lọc `com.apple.UIKit`, còn split plist lọc CarPlayApp/SpringBoard: hai vùng quyền sở hữu khác nhau. Binary static search **chưa tìm thấy chỉnh sửa chuyên biệt bằng chuỗi `com.google.ios.youtube`**, không thể chứng minh nó có/không có quy tắc bundle gián tiếp.
3. Đọc mã `main` QA7 2026-10-20: `src/OmniCarDoubleTapFullscreen.xm` blob `93d8fa2e912029e33391e9834f07463bef39d037` chỉ hook `SCPCarSplit`; `src/OmniCarChrome.xm` blob `a4b94c7c9c91475eb5879efee2ed13a7f8463dc6` hook statusbar; `titanium/src/OmniCarGraphiteTitanium.xm` blob `eee57c369ee95ba31c83f4f046c10042067d4179` hook `SCPCarSplit`; `solo/src/OmniCarSoloThreeDots.xm` blob `9873b516c8c047fd03e0ea5c406375bfcc100f03` hook `SCPCarSplit`; `idle/src/OmniCarIdleControls.xm` blob `20f8bd5aa99d72453ec5f0c0839c8e0410ef3827` hook `SCPCarSplit`, `SCPCarDividerView`. **Không module QA7 nào trực tiếp hook `ABHost`/`ABPane`.**
4. QA7 idle `OMCIdleApply` lặp `split.allPanes` + `paneAtSlot:0..2`, áp `layer.opacity=0` chỉ lên `SCPCarPane.handle` và divider knob, không enumerates `ABPane.handle`; gesture wake nhận `split.container` và `tabParent`, không có xác minh nhận chạm trong scene YouTube từ xa. Bản gốc `SCPCarSplit.setBarVisible:forPane:` dùng `barTimer` 4s để ẩn thanh `bar`, **khác `handle` 3 chấm** (`audit/OmniCar_native_controls_idle_visibility_20261019.md`).
5. QA6 từng thử đánh vào `SCPCarPane.hostHandle` và `split.hostedPanes` qua `OMCIdlePaintPaneHandles`. Đây vẫn KHÔNG phải bằng chứng `ABPane.handle` đã được xử lý đúng. QA6 crash ngay lúc vào OmniCar và mất divider trên máy người dùng; chưa có stack trace nên chưa kết luận chính xác lệnh gây crash.

## Đánh giá nguyên nhân, tách hai hiện tượng

- **Nút 3 chấm YouTube không tự ẩn:** *Giả thuyết ưu tiên*, nút YouTube nhìn thấy thuộc lớp App Bridge (`ABPane.handle` hoặc `SCPCarPane.hostHandle` có quan hệ bridge riêng), không nằm trong cùng tập nút `SCPCarPane.handle` mà QA7 idle quản lý. Đã xác minh **có tồn tại hai hệ owner**; **chưa chứng minh bằng runtime nút trên màn hình chính là instance nào**, hay tại sao app khác có thể ẩn. Không được kết luận chắc là YouTube tự tạo thanh 3 chấm, vì đó có thể là OmniCar AppBridge.
- **Giao diện YouTube quá lớn/bố cục lạ:** khả năng khác biệt `sceneBox`, reference size, orientation và `appBridgeZoom` của scene iPhone bị đưa vào ô CarPlay hẹp; UIKit/ứng dụng bố trí theo kích thước scene. Đây là nhánh *layout*, không đồng nhất với lỗi fade. Chưa có cấu hình/zoom thực tế của iPhone nên không khẳng định YouTube được sửa riêng hoặc bị tweak bên ngoài.

## Hướng điều tra an toàn — không tạo lại lỗi QA6

1. Giữ **nguyên QA7**; không thay `SCPCarSplit` splitter/divider/Zoom, không thêm global `UIWindow` overlay, không sửa application playback/UI YouTube.
2. Từ bản gốc original DEB, đọc sâu selector + disassembly owner `ABHost.setupHandleForPane:`, `ABHost.layoutBarForPane:`, `ABHost.buildBarForPane:`, `ABPane.handle`, `ABPane.bar` và đường liên lạc `SCPCarSplit.hostBarInfoForPane:`, `hostFrameInfo:pane:live:handle:`. Ghi selector/IMP và đường đi state/visibility/owner một cách kiểm chứng được; chưa chứng minh hệ thống native có idle timer cho `ABPane.handle`.
3. Nếu cần thăm dò thiết bị, chỉ thiết kế **log-only owner-scoped QA** không đổi UI trên ứng dụng đang dùng, ghi ở thời điểm mở/chia, sau 4s và sau chạm: bundleID; lớp thực tế của nút `•••`; `SCPCarPane.handle`/ `hostHandle` và `ABPane.handle`; window/scene, frame, `UIView.hidden`, `CALayer.opacity`, parent/owner; `ABHost.zoom`, `appBridgeOrientation`, `sceneBox`. Không ghi dữ liệu tài khoản YouTube/tên video.
4. Chỉ khi owner thực sự được xác nhận mới cân nhắc nối idle về đúng owner với restore/tap-wake tại chính host-pane event path. Cần build ứng viên QA riêng, kiểm thử thật cả YouTube+map và map+map **trước** khi thay QA7 Sileo.
5. Điều kiện thành công: YouTube host 3-dot tự ẩn và hiện lại khi chạm, hai bản đồ có thanh chia/menu, 2 ứng dụng khác không hồi quy, YouTube phát bình thường, Zoom/Swap hoạt động, không crash ngay khi mở.

Nguồn đối chiếu UIKit Scene: https://developer.apple.com/documentation/uikit/transitioning-to-the-uikit-scene-based-life-cycle ; CarPlay Scene: https://developer.apple.com/documentation/carplay/displaying-content-in-carplay . Đây là cơ sở kiến trúc tổng quát, không phải bằng chứng triển khai riêng của OmniCar.

**TRẠNG THÁI**: verified source/doc evidence; no new patch/build/workflow/run/device instrumentation/Sileo deploy. Phải phân biệt dự đoán về nút YouTube với thực nghiệm UI trên xe.

## 2026-10-20 — Audit zoom 0,6–1,0 theo loại ứng dụng

Evidence: read-only workflow 39398158085 job 118545931967 SUCCESS; script scripts/audit_appbridge_zoom_comparison.py; immutable original DEB SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd. The persisted machine report is audit/OmniCar_AppBridge_global_zoom_compare_20261020.json (artifact commit cfd3885e7086f84eedbc6eb06e346eae4b54319b).

Verified ABI: ABHost.zoom (ARM64 0xae20–0xae90) calls _OMCPrefsSync at 0xae30, then _OMCPref at 0xae44; divides by numeric 100.0 at 0xae58–0xae60; clamps lower bound 0.6 at 0xae70–0xae74 and upper bound 1.0 at 0xae78–0xae80. One shared appBridgeZoom accessor has NO bundle argument. Actual value on user's iPhone is not available.

| Case | AppBridge.zoom applies? | Why UI may differ |
|---|---|---|
| YouTube hosted as iPhone app | Same shared 0.6–1.0 clamp | Own responsive scene + host frame/size/orientation |
| TikTok / other iPhone app via AppBridge | Same global clamp when routed through same ABHost | Different app-specific layout and orientation |
| Google/Apple Maps running native CarPlay scene | Not this AppBridge zoom | Native CarPlay UI sizing |
| Map app forced via OmniCar iPhone AppBridge | Same global clamp | Host framing still differs from native CarPlay |

Original preference plist scan returned no appBridgeZoom/appBridgeOrientation per-app entries. AppBridge arm64 strings include appBridgeZoom, appBridgeOrientation and splitScreenPaneOrientation; they do NOT contain direct strings com.google.ios.youtube, com.google.Maps, com.apple.Maps, com.zhiliaoapp.musically. These absences are LIMITED static evidence, not proof of no dynamic bundle-based exceptions or external installed tweaks. Frame/orientation methods ABHost.layoutPane: and ABHost.effectiveOrientation: do exist. No measured YouTube-specific 0.6 or 1.0 is warranted.

Practical conclusion: shared numeric zoom is unlikely to explain why ONLY YouTube three-dot remains visible. The visual difference may come from its AppBridge scene or ABPane.handle / SCPCarPane.hostHandle ownership, which was not proven at runtime. Preserve QA7. No runtime hooks, DEB, device test or Sileo change in this analysis.

## 2026-10-20 — Ảnh thực tế nút Pause/Previous/Next YouTube

- User provided original chat attachment `IMG_B59176A9-84AE-40FF-8F5D-FC9B71621862.jpeg`, file viewed by the assistant in current conversation, 1080×1440 pixels; physical **iPhone in landscape on a table**, visible YouTube player while paused/overlay active. Image was NOT uploaded to public GitHub or saved as a repo file (do not pretend another chat has the bytes). It shows prominent blue circular Previous, Pause and Next controls over a relatively small center video region; video progress bar, Settings gear and fullscreen arrows, plus an active playlist/mix panel below. These playback controls belong visually to the YouTube media player, not the 3-dot OmniCar pane trigger.
- **User's latest observation**: `giao diện app [YouTube] không đúng`, `các nút play next cảm giác to hơn`; explicit comparison with baseline *not yet provided*, do not label pixel sizes definitely abnormal from one photograph. YouTube naturally uses a large transport overlay when paused/tapped. The image is a physical phone, NOT by itself proof of the actual CarPlay headunit viewport. Need clarify whether phone photo depicts YouTube when connected to OmniCar and whether the same YouTube version looks different with CarPlay disconnected.
- Separate hypotheses, do NOT conflate: (A) actual YouTube playback overlay is rendered by the application's UI; OmniCar AppBridge changes `sceneBox`, `_updateReferenceSize:andOrientation:`, host frame, `CGAffineTransformMakeScale` in ABHost.layoutPane: (machine report `audit/OmniCar_AppBridge_global_zoom_compare_20261020.json` around `0xed70–0xedac`) and orientation, which may alter the perceived relative control-to-video scale. This has NOT been verified with actual frame and user zoom values. (B) separate 3-dot that does not auto-hide is an OmniCar/AppBridge native pane handle (`ABPane.handle` / `SCPCarPane.hostHandle`) and does NOT correspond to the transport buttons pictured.
- **Next safe A/B test on parked setup**: same YouTube video, same pause/overlay UI on iPhone *without* CarPlay vs *with* OmniCar connected, same device and app version, then separately compare hosted YouTube in CarPlay split and solo, preferably a photo of both states. Record `appBridgeZoom`, `appBridgeOrientation`, scene/reference bounds and host pane dimensions before suggesting any change; ensure no changes to original video player. Keep QA7 and Sileo unchanged, do not reinstate QA6 hostHandle/hostedPanes global fade. If only YouTube seems larger, investigate aspect ratio, layout/scene and UIKit size class rather than blanket-zooming all apps.
