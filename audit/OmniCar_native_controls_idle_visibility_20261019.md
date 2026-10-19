# OmniCar 1.0.3 — native control inactivity auto-hide audit

Checked 2026-10-19. Scope: original source package `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`. Binary `/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib` ARM64 Mach-O. Static disassembly, no runtime hook or UI change in this audit.

## User clarification

Auto-hide after **3 seconds of inactivity** is required BOTH in normal split view and fullscreen. Applies to each pane's tiny three-dot handle, the two-squares view-restoration launcher/button when present, and to the CarPlay dock where user indicated. Touch anywhere should show controls temporarily, without changing underlying layout/swap/touch targets. Inactive full-screen and normal modes must be evaluated separately to avoid hiding an essential restore action permanently.

## Verified static code paths

- `SCPCarSplit -setBarVisible:forPane:` IMP ARM64 **0x241fc** handles per-pane UI bar visibility. On the YES branch it invalidates old `barTimer` (selector call at 0x24244/0x24254), schedules `NSTimer scheduledTimerWithTimeInterval:repeats:block:` at **0x24434**, passing **4.0 seconds** (`fmov d0,#4.0` at **0x24424**) and `repeats=NO`. Timer callback at **0x24bac**, call at **0x24bf8**, invokes `setBarVisible:forPane:` with `w2=0` (hidden). Therefore a **native 4-second automatic hide for per-pane bars already exists** in original OmniCar. It is not the requested 3 seconds.
- `SCPCarSplit -hideBarsForTouchOn:` IMP **0x25558** iterates `allPanes`, checks current `bar` visibility and the touch's relationship to each pane `handle`, then calls `setBarVisible:forPane:` with false at **0x256ec**. Native touch-based hide exists. `SCPCarSplit -handleTapped:` IMP **0x253e4** calls `setBarVisible:forPane:` (at 0x25464), so per-pane bar feedback is present in normal operation, not exclusive to fullscreen.
- **Separate UI ownership:** `SCPCarSplit -refreshHomeButton` IMP **0x41be4**, `-homeButtonTapped` IMP **0x43514**, `-removeHomeButton` IMP **0x434a8** manage the two-squares/launcher-style control. Examination of `refreshHomeButton` did not identify an inactivity timer analogous to `barTimer`; code contains position, visibility and launcher-host logic, but **automatic hide after 3 seconds for this specific control is NOT established**.
- `SCPCarSplit -restartTrayTimer` IMP **0x3bc20** separately creates a **4-second** timer at **0x3bcb4** to collapse the app tray. This is not a home-button/three-dot/dock inactivity controller.
- The CarPlay system dock/status chrome is **not** a per-pane bar. Current standalone Zoom addon `src/OmniCarChrome.xm` hides/restores chrome on explicit Zoom transitions (the source does not implement a global idle timer). It is unsafe to claim original OmniCar's barTimer also hides Apple CarPlay dock.
- Original `OmniCarSplitScreen.dylib` has no confirmed **unified** 3-second activity timer coupling all of: native per-pane bars, fullscreen two-squares launcher, and native CarPlay dock. This audit cannot prove no other hidden system-provided auto-hide (runtime behavior may vary). User photos show the controls visible, not a measured 3-second continuous no-touch test.

## Evidence reproduction (Linux + llvm-objdump)
```bash
dpkg-deb -x com.anlai.omnicar_1.0.3_iphoneos-arm64.deb omnicar103/root
llvm-objdump --macho --disassemble --arch=arm64 omnicar103/root/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib > omnicar103/arm64-disasm.txt
# Use original ARM64 IMP table and inspect 0x241fc..0x2462c, 0x24bac..0x24c18, 0x25558..0x257e8, 0x41be4..0x426f8, 0x3bc20..0x3bd78.
# Confirm objc selector for call 0x5a600 via __objc_stubs (selref -> scheduledTimerWithTimeInterval:repeats:block:).
```

## Next steps (not executed)
1. Preserve per-pane `setBarVisible:forPane:`; adapt native show→auto-hide from 4 to requested 3 seconds in normal mode **without changing existing touch/drag gestures**.
2. Determine concrete owning views and state for the full-screen launcher/two-squares control, three-dot handles and CarPlay status chrome. A three-second coordinator must not permanently hide the only way to exit fullscreen; a touch-to-reveal or a native safe-area hotspot must remain available.
3. Implement shared activity tracking for split and fullscreen, scoped to CarPlay UI and installed only while OmniCar is active; reset when a genuine UI interaction occurs, ignore video playback as user input, avoid repeated hide/show when scene is detached; restore native state on exit/respring.
4. Device QA: both layouts, no touching 3 seconds → intended controls hidden; tap → reveal; tap two-squares returns split; no regression to ratio drag, native menu, Zoom 0.5.0, host applications and chrome. Validate dock behavior separately from OmniCar custom chrome.

**State: ANALYSIS VERIFIED STATIC ONLY. No executable edits, CI, new DEB, device tests or Sileo changes in this audit.**

## 2026-10-19 — Correction: user says three-dot controls never disappear; addon causality

- Important clarification: `SCPCarPane` has distinct `handle` and `bar` properties, while native `setBarVisible:forPane:` schedules the 4s `barTimer` for the EXPANDED per-pane `bar`. The original audit mistakenly implied the always-visible THREE-DOT handle itself should vanish after 4 seconds. Native handle auto-hide was NOT confirmed from binary and SHOULD NOT be claimed. Current user's observation that the tiny three-dot pill stays visible is compatible with this distinction.
- Source confirmed on main for addon v0.5.0: `src/OmniCarDoubleTapFullscreen.xm` hooks only `showRatioMenuForDivider:`, `hideRatioMenu`, `setActive:`, and `appAreaInParent:` and adds one separate Zoom button on the native menu; it does NOT override `setBarVisible:forPane:`, `handleTapped:`, `hideBarsForTouchOn:`, `barTimer`, `refreshHomeButton`, or `homeButtonTapped`. Therefore there is NO direct addon interception of the original hide/show bar path.
- `src/OmniCarChrome.xm` alters CarPlay statusbar window hidden flags upon explicit Zoom enter/exit and has startup class-hook retry timers, NOT an inactivity auto-hide loop. So the dock behavior may be addon-influenced at Zoom boundaries but it has no 3-second idle hide implementation.
- Current inference: most likely the always-visible tiny three-dot handles (and the dedicated two-square launcher) are original OmniCar baseline behavior, not something the addon broke. This remains an inference, not a controlled A/B device test.
- To isolate quickly: at a PARKED head unit remove ONLY the addon package `com.anlai.omnicar.doubletapfullscreen` (leave base `com.anlai.omnicar` installed), respring if needed, wait 6-8 seconds without touch and inspect whether three-dot handles/two-squares remain. Then compare with addon 0.5.0. Alternatively collect live `[OmniCarZoom]`/`[OmniCarZoomChrome]` logs. No removal or runtime test has been performed by assistant.
- User's updated requirement is to ADD a shared 3s inactivity hide/reveal policy to split AND fullscreen; do not blindly change the native 4-second expanded-menu timer expecting the persistent three-dot handles to disappear.
