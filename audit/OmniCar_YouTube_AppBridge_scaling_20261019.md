# OmniCar 1.0.3 — YouTube UI phóng to trong App Bridge (static audit)

Thời điểm: 2026-10-19. Phạm vi: phân tích riêng hiện tượng YouTube UI oversized/không giống iPhone trên màn CarPlay; **không sửa source, package hay Zoom đang hoạt động**. Người dùng đã xác nhận addon 0.5.0 có nút Zoom và chức năng hoạt động, nhưng style quá lớn/không hài hòa; việc chỉnh giao diện này còn pending.

## Bằng chứng từ DEB gốc đã đọc

Đầu vào: \`com.anlai.omnicar_1.0.3_iphoneos-arm64.deb\`, SHA256 \`d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd\`.

- \`/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib\`: 613,376 bytes fat Mach-O arm64/arm64e. Injection plist: \`Filter.Bundles = ["com.apple.UIKit"]\`. Điều này khác với các hook chính của \`OmniCarSplitScreen.dylib\` (CarPlayApp/SpringBoard).
- \`OmniCarSplitScreen.dylib\`: giao diện 2–3 ô, callouts \`com.anlai.omnicar/appbridge.frame\`, \`com.anlai.omnicar/appbridge.open\`, \`hostFrameInfo:pane:live:handle:\`, \`sendHostFrameForPane:live:\`; chuyển khung một pane tới App Bridge.
- \`OmniCarAppBridge.dylib\` has ObjC \`ABHost\` methods \`zoom\` (arm64 IMP \`0xae20\`), \`openApp:frame:\` (\`0xb8a0\`), \`layoutPane:\` (\`0xec80\`), \`effectiveOrientation:\` (\`0xf364\`), \`setFrame:forApp:live:handle:passInsets:\` (\`0xfe68\`), properties \`sceneBox\`, \`orientation\`, \`frame\` and a hook named \`SBSceneView -_updateReferenceSize:andOrientation:\`.
- The binary preference key \`appBridgeZoom\` is at offset \`0x29798\` in extracted arm64 slice and \`appBridgeOrientation\` at \`0x29821\`. A log string says \`host %@ tai %@ (huong %lld, zoom %.2f)\`.
- Static disassembly \`ABHost -zoom\`, arm64 \`0xae20..0xae90\`: \`_OMCPrefsSync\` → \`_OMCPref\` → float conversion → divide by **100.0** (\`0x4059000000000000\`) → clamp minimum at **0.6** (double at \`0x2b210\`) → clamp maximum **1.0**. Thus supported output is \`0.6…1.0\`, assuming the code path executes. **Actual stored preference/default on the user's device was not captured**, so do not assume it is 100%.
- Source binary inspection (strings) did not find a \`com.google.ios.youtube\` or other explicit YouTube-specific size/layout patch. That supports a **general iPhone App Bridge implementation** rather than a specially modified YouTube UI, but does not prove no indirect bundle-ID logic exists.
- \`OmniCarAppBridge.plist\` scope \`com.apple.UIKit\`, \`OmniCarSplitScreen.plist\` scope \`com.apple.CarPlayApp\` + \`com.apple.springboard\`; separate process ownership matters to layout.

## Conclusion bounded by evidence

**Primary hypothesis (strong):** OmniCar brings the *iPhone YouTube scene* to a split CarPlay pane. Bridge forces pane frame/reference size, orientation and zoom. YouTube's own adaptive UI lays out according to the injected scene/size class. Physical pane is much smaller than a full iPhone view but app content may retain phone-like sizes, yielding oversized controls, text or clipped views. User screenshot showing YouTube Premium and large text is consistent. This is mainly an **App Bridge scaling / size-class compatibility issue**, with the YouTube app's responsive behavior as a secondary factor; not evidence that YouTube was corrupted or edited.

**NOT established:** exact root cause on user's phone (live \`appBridgeZoom\`, orientation, source sceneBox/renderSize, target hostFrame, image/video clipping measurements not logged). No runtime experiment comparing same YouTube build in iPhone vs split was done; also cannot conclusively exclude another YouTube tweak affecting its UI.

## Correct follow-up if user wants a fix

1. **Do not modify** native OmniCar UI menus, split gestures, dock/fullscreen handling or addon 0.5.0 while diagnosing app scene scaling; preserve current state.
2. On the device (when parked), capture \`appBridgeZoom\`, \`appBridgeOrientation\`, \`splitScreenPaneOrientation\`, \`ABHost.frame\`, \`sceneBox\`, \`effectiveOrientation:\`, host frame, the YouTube bundle ID and whether other bridged apps display the same symptom.
3. Compare YouTube full-screen (no split) vs narrow split pane, YouTube phone UI vs CarPlay; if only pane-size mismatch, implement a per-app \`sceneBox\`/referenceSize scaling policy for YouTube or adjust built-in App Bridge zoom. Do not blanket-scale all apps or change native YouTube app assets.
4. Verify actual framebuffer dimensions, safe-area, orientation, touch mapping and UI scaling on real CarPlay. Preserve other apps and the split divider UX.
5. Regression: verify YouTube responsive layout, video playback controls/touch, transitions between 2-pane/fullscreen/restore, all other apps not affected. Only then build new independent candidate, no Sileo.

## Repro commands

\`\`\`bash
dpkg-deb -I com.anlai.omnicar_1.0.3_iphoneos-arm64.deb
dpkg-deb -x com.anlai.omnicar_1.0.3_iphoneos-arm64.deb /tmp/omni103scan
strings -a /tmp/omni103scan/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib | grep -Ei 'appBridgeZoom|appBridgeOrientation|_updateReferenceSize|setFrame:forApp|sceneBox|openApp:frame:'
\`\`\`

Verified extraction on local container and native Mach-O arm64 disassembly using \`llvm-objdump --macho --disassemble\`; measurements are static analysis not a real-device pass.
