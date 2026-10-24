# QA18 — one physical touch shows **all** OmniCar controls (DuoFace Native12 original ABI comparison)

Date: 2026-10-24. The user's requirements are **not** "tap only the YouTube three-dot": one tap anywhere in the split interface must instantly reveal **both panes' handles and the native divider/knob together**, including the AppBridge YouTube pane. They all hide again after 4 seconds without user activity.

## Real on-device test history

- QA16: user confirms YouTube three-dot **autohides** after 4 seconds, but wake is too hard.
- QA17: Sileo delivery SHA verified, but user confirms wake is **still not working reliably except near tiny original handle**. Do not call it a runtime success. Its isolated ABHost.window gesture-receiver hypothesis failed in real use.
- QA18: source and CI build candidate; real device **not yet tested**.

## Machine-code proof (strict SHA pins)

DuoFace v12 original `DuoFaceDashboard.dylib` SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`, original OmniCar 1.0.3 DEB SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`. Workflows `40055111163`, `40055146844`, `40055282966` ran read-only and all **SUCCESS**. Original audit data under `audit/OmniCar_DuoFace_original_touch_routing_20261024.json` and `audit/OmniCar_DuoFace_Original_Touch_IPC_20261024.json`.

| Owner/method | Actual ARM64 IMP | Decisive behavior |
|---|---|---|
| DuoFace `CBBridgedUIAppView.hitTest:withEvent:` | 0xac940 | Before super hitTest, looks up bridge manager current app and calls `noteUserActivity` |
| DuoFace `CBSplitContainerView.hitTest:withEvent:` | 0x10182c | Calls the shared `splitApp.noteUserActivity` **before** superclass hitTest, regardless of which pill was tapped |
| DuoFace `CBSplitContainerView.touchesBegan:withEvent:` | 0x1018e8 | Calls the same split-wide note activity |
| DuoFace `CBBridgedSplitApp.noteUserActivity` | 0x10c378 | Uses 0.25s debounce, calls `startBlinkingSession` shared UI handler |
| OmniCar `SCPCarSplitView.hitTest:withEvent:` | 0xe88c | The correct original split UI hitTest owner, already has original `touched` callback in hitTest |
| OmniCar `SCPCTouchWatch.hitTest:withEvent:` | 0xf36c | Another original hitTest owner with `outside/exempt` callbacks; not a generic global UIWindow |
| OmniCar `ABHost.outsideTouched` | 0x12e08 | Iterates AppBridge panes and **HIDES** their bars; **must NOT** be used as one-tap reveal! |
| OmniCar `ABShieldView.touchesBegan:withEvent:` | 0xa4c4 | Posts original outside-touched notification and calls ABHost outsideTouched; also not a reveal |

**Root architectural mismatch:** QA16 and QA17 relied on independent per-pane gesture recognizers and timers; real YouTube touches need not reach those recognizers. DuoFace instead records touch activity at the *original split/app container hit-test entry point*, and one central controller wakes all controls. Simply widening a tiny hitbox or hooking ABHost.outsideTouched cannot implement this behavior.

## QA18 patch (no UI redesign)

- `native-solo-timer-qa18/src/OmniCarNativeSoloTimer.xm`: retains original QA12 4-second native timer. Hooks ONLY original `SCPCarSplitView.hitTest:withEvent:`, calls `%orig` then checks active split/bounds/touch Began. Immediately invokes `OMCNativeTimerWake` for all active native split controls (`allPanes.handle` + `dividers`), plus posts activity notification.
- `youtube-handle-qa18/src/OmniCarYouTubeHandleIdle.xm`: starts from user-**PASS** QA16 handle hide instead of device-**FAIL** QA17 window recognizer. Tracks all active YouTube `ABPane` objects; Darwin center notification triggers `OMCYTWakeAll` (both panes if YouTube in both), restoring layer opacity and restarting four-second timer. Touch in original host control also announces same shared activity to native.
- Cross-process notification key `com.anlai.omnicar.qa18.controls.activity`. Receivers never echo notification, preventing infinite cross-process loops. Shared native and host timers reset together; per-process guard ensures only active visible controls are touched. Limited to original CarPlayApp/SpringBoard and UIKit AppBridge injection filters.
- Do **not** alter `UIApplication.sendEvent:`, `UIWindow.sendEvent:`, any native `Solo` lifecycle, dock/car window geometry, scene reference size/orientation, native divider drag, Zoom/Swap or original video player.
- Package uses immutable publicly verified QA17 DEB as input SHA `9d0edc8942e93e282d5130927697fb0b84a7ddcb993b616359fdd455eb0967b0` and **replaces only two** modules `OmniCarNativeSoloTimer.dylib` and `OmniCarYouTubeHandleIdle.dylib` in original 182-entry payload. The other 180 files must compare byte-for-byte. New version `1.0.3-omnicar18-duoface-unified-wake`.

## Important limitations and acceptance

Static ARM64 evidence identifies the matching original view's hitTest and legitimate per-pane controls, but **does not show which UIApplication process physically receives each actual touch on the user's car display**. A GitHub Actions ARM64 build and Sileo hash comparison cannot prove touches were routed. QA18 still needs actual parked-device test.

Pass criteria: open YouTube and Maps side by side, let two dots/divider fade after 4 seconds. Tap **once** in the YouTube video or map body away from the tiny dot: **both** dots + native divider should appear immediately while **the same tap still works in YouTube/Maps**, without requiring hitting any invisible button. After another 4 seconds idle they hide again. Repeat YouTube in both panes, map+map, drag resize, Zoom/Swap, original Solo, video, SpringBoard stability. If fail, inspect `[OmniCarUnifiedWakeQA18] event=activity-published source=original-split-hitTest`, `event=native-all-controls-revealed`, `event=youtube-handle-revealed` before any new speculative hook.

Never mark runtime test PASS before the user confirms.
