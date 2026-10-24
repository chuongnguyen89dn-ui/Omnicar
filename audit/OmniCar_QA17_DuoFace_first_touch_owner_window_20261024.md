# QA17 — First touch reveals the original YouTube host handle (DuoFace v12 comparison)

Date: 2026-10-24 (Asia/Ho_Chi_Minh). Target OmniCar rootless CarPlay version `1.0.3-omnicar17-window-touch-wake`.

## User-device before/after
- QA16: user **confirmed YouTube three-dot disappears after 4 seconds**, but **touch-to-reveal is difficult**, unlike DuoFace's immediate screen tap. This is a real device observation, NOT just a static conclusion.
- QA17: implementation is code + CI build verified; **actual first-tap wake/device playback/crash status remains unverified until user tests**.

## Independent original DuoFace ARM64 evidence

Read-only extracted original `DuoFaceDashboard.dylib` (pinned SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`), persistent machine disassembly:
`audit/duoface-idle-controls/DuoFace_v12_native_idle_and_control_owner.txt` blob `f1960191d1a490e34c8f351c6079dc6f5cbd5c54`.

- `-[CBBridgedUIAppView touchesBegan:withEvent:]` ARM64 IMP **0xaca6c**: executes superclass event path via `objc_msgSendSuper2` at 0xacaa4; obtains `CBBridgeManager.sharedInstance` (0xacabc) then `currentApp` (0xacad4); checks `respondsToSelector:noteUserActivity` (0xacafc) and invokes `noteUserActivity` at 0xacb2c. **This responds to a touch in the hosted APP VIEW, not merely clicking the hidden pill.**
- `-[CBBridgedSplitApp noteUserActivity]` ARM64 IMP **0x10c378** checks main thread, `CACurrentMediaTime` at 0x10c3c4; debounces activity at **0.25 second** by comparing time delta at 0x10c3d8–0x10c3e0; calls `startBlinkingSession` at 0x10c3f0.
- DuoFace's actual UI wake behavior is rooted in **receiving app-view touch activity**; native selectors and control owner are fundamentally different from OmniCar's AppBridge. Copying `CBBridgeManager`/DuoFace private calls into OmniCar would be wrong.

## Actual QA16 OmniCar cause at implementation level

`youtube-handle-qa16/src/OmniCarYouTubeHandleIdle.xm` attaches an immediate-fail, noncanceling `OMCYTObserveTouch` to `ABPane.box` and `ABPane.handleHit`; the remote hosted YouTube touch may not traverse that local parent responder/gesture tree, so the timer fades successfully but the user must find the tiny original hit area to restore. This explanation is a **testable routing hypothesis**, not a device pointer/hit-test trace.

## QA17 fix, preserving DuoFace behavior without foreign classes

`youtube-handle-qa17/src/OmniCarYouTubeHandleIdle.xm`:
- Only two `ABHost` hooks: original `setHandleVisible:forPane:` and `layoutBarForPane:`, call `%orig` first.
- Restrict to original `ABPane.bundleID == com.google.ios.youtube`.
- Retain proven QA16 original 4.0s `ABPane.handle`/`handleHit` CALayer fade, original accessibility/hit view and content untouched.
- Register an **additional PASSIVE** UIKit touch observer on `ABHost.window` ONLY when the actual `ABPane.box` belongs to that exact same UIWindow. A touch at `UITouchPhaseBegan` inside `[box convertRect:box.bounds toView:hostWindow]` (clipped to host window) calls `OMCYTWakeFrom(pane,@"owner-window")` immediately.
- Existing local box/hit observers still present as fallback. `gesture.cancelsTouchesInView=NO`, `delaysTouchesBegan=NO`, `delaysTouchesEnded=NO`, gesture always transitions `UIGestureRecognizerStateFailed` so it cannot consume or redirect the original click.
- On original `setHandleVisible:NO`, stop timer, restore layer opacity, remove observer from owner window. Owner UIWindow is NOT subclassed/hooked globally and no overlay view is added.
- Does **not** hook `UIWindow.sendEvent:`, `UIApplication.sendEvent:`, `SCPCarSplit`, `SCPCarPane`, scene/rotation/zoom, CarPlay Dock, Solo/drag, nor video player.
- Logs: `[OmniCarYTHandleIdleQA17] event=owner-window-observer-attached`, `event=idle4-hide`, `event=touch-reveal app=youtube source=owner-window`.

## Repro/QA and limitations

CI workflow `.github/workflows/build-qa17-window-touch-wake-candidate.yml`, run `40052717110` **SUCCESS** job `120748694352`. Immutable original-payload QA12 DEB SHA `f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba`. QA17 output saved `dist/candidates/omnicar-qa17-window-touch-wake/com.anlai.omnicar_1.0.3-omnicar17-window-touch-wake_iphoneos-arm64.deb`, SHA256 **`9d0edc8942e93e282d5130927697fb0b84a7ddcb993b616359fdd455eb0967b0`**; 180 original QA12 files byte-identical + two scoped host addon files. Sileo publication is separate and requires confirming GitHub Pages build/deploy and independent download SHA check.

**Device acceptance while parked:** open YouTube+Map, wait 4s and confirm YouTube `…` hidden (QA16 already user-PASS). Single TAP anywhere in **YouTube app pane**, not only on hidden dot; expect dot to return immediately without needing a second tap; playback and scroll must still work. Also test both panes, native Maps, divider drag, Zoom/Swap, Solo, video rotation and no SpringBoard crash. If dots fail to reveal, collect `owner-window-observer-attached`, `idle4-hide` and `touch-reveal` events to see whether window owner or touch frame matching failed; do not guess another hook.

No user private media/account text, cookies or IDs logged.

## 2026-10-24 — QA17 device WAKE FAIL; original DuoFace re-audit reveals MISSED hitTest path

**User device confirmed:** QA17 YouTube dots still very difficult to reveal (tiny hit area); tap anywhere DOES NOT reveal. Mark QA17 WAKE = FAIL, while QA16/QA17 4-second HIDE = PASS. No new QA18 package at this audit checkpoint.

**Verified exact original ARM64:** GitHub Actions run 40055111163 SUCCESS; immutable DuoFace Native12 Dashboard SHA256 bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce, immutable OmniCar original 1.0.3 DEB SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd. Machine report audit/OmniCar_DuoFace_original_touch_routing_20261024.json Git blob 0c7703a0a66d3828143a5e3db5b83c261a83f620 read back.

**MAJOR correction compared to earlier QA17 design:**
1. DuoFace original -[CBBridgedUIAppView hitTest:withEvent:] IMP 0xac940 calls CBBridgeManager.sharedInstance, currentApp, respondsToSelector:noteUserActivity, invokes noteUserActivity at **0xac9f8 BEFORE** forwarding to superclass hitTest at **0xaca28**. Thus user activity is detected during HIT TEST, not merely in touchesBegan after gesture dispatch.
2. DuoFace original -[CBSplitContainerView hitTest:withEvent:] IMP 0x10182c calls splitApp.noteUserActivity at **0x101884**, BEFORE forwarding superclass hitTest at **0x1018b4**. DuoFace has both app-view and full split-container activation pathways.
3. DuoFace original -[CBSplitContainerView touchesBegan:withEvent:] IMP 0x1018e8 also calls noteUserActivity at 0x10193c. Original CBBridgedUIAppView.touchesBegan IMP 0xaca6c calls noteUserActivity at 0xacb2c. CBBridgedSplitApp.noteUserActivity IMP 0x10c378 debounces 0.25 seconds then invokes startBlinkingSession. **Two-stage hitTest + touchesBegan owner delivery explains why original DuoFace can reveal on first tap without tiny pill.**
4. OmniCar original AppBridge has NO ABHost hitTest:withEvent: and NO ABHost touchesBegan:withEvent:. The only original AppBridge classes implementing touchesBegan are ABShieldView (0xa4c4) and ABKnobView (0xa90c), neither is the full original YouTube pane. ABHost.outsideTouched IMP 0x12e08 sends setShieldOn:NO, hideBarForPane: and removes shield: this is a HIDE command, not the DuoFace reveal activity path.
5. Verified ABHost.window getter IMP 0x166cc = object ivar at 0x10; ABHost.carWindow IMP 0xf3d0 uses ensureWindow and window; ABPane.box getter IMP 0xa190 returns object; ABPane.handleHit getter 0xa300 returns object. This is ABI static evidence, NOT a proof of live CarPlay touch routing.

**Conclusion:** QA17's passive UIGestureRecognizer on owner UIWindow was NOT structurally equivalent to DuoFace: it depends on post-hit-test UIKit touch delivery in a remote app scene. DuoFace proactively calls activity during hitTest before target dispatch. A narrowly scoped non-rendering, pass-through UIView whose hitTest first calls wake and then RETURNS NIL (allows untouched underlying app hit target to handle touch) inside ABPane.box is an implementation candidate. Avoid global UIWindow/UIView hooks, new CarPlay windows, scene/player layout changes, event interception, or unsupported private DuoFace methods. Add event/pane safety gates and verify on device before claiming fixed.
