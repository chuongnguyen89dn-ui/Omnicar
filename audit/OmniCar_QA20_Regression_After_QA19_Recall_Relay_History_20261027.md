# OmniCar 27-10-2026 — Regression history after QA19 wake/recall patch: YouTube + center round knob fade

## User's latest physical evidence (the only device truth)
User identifies reproducible A/B: center circular divider knob hides normally if running two non-YouTube apps; when YouTube is opened it does NOT hide. The user additionally specifically dates the onset to **after** changing the control recall/wake command, not just QA20. QA19 improved recall, QA20 knob hide attempt still fails in YouTube. Both pane '...' controls had previously been reported to fade. Do not treat all old YouTube 3-dot controls and the center divider knob as one object.

## Reconstructed timeline FROM persisted history (NOT inferred from binary alone)
1. QA7, 2026-10-20: `tiep tuc du an.md` checkpoint "QA7 map+map split works and native menu/knob/3dot visually autohides", while **YouTube 3-dot did NOT auto-hide** because its AppBridge pane handle is separate. Prior map/map knob hide was real device observation; **not** proof center knob hid with YouTube.
2. QA16, 2026-10-24: user explicitly said "Xác nhận ẩn đc rồi. Nhưng gọi lại khó quá". `tiep tuc du an.md` ~1399 identifies *YouTube hosted three-dot* four-second hide **device PASS**, but first-tap wake FAIL. This statement alone does **not** prove the separate center round divider knob's fade on a YouTube pane.
3. QA17: window-based touch wake added, device still FAIL (tiny target). QA18: original split `hitTest` shared native/host activity plus Darwin, device first-tap still FAIL on YouTube content.
4. **QA19, 2026-10-27: decisive code change FOR RECALL** in `youtube-handle-qa19/src/OmniCarYouTubeHandleIdle.xm` adds `%hook UIApplication -sendEvent:` in broadly selected application processes (not explicitly scoped to YouTube/onscreen CarPlay), calls `%orig` FIRST, and for any `UIEventTypeTouches` with a `UITouchPhaseBegan` invokes `OMCYTWakeAll(@"app-process-touch")`. QA18 host source has **NO UIApplication sendEvent hook**. QA19 native `OMCNativeTimerTouch.touchesBegan` also changes from `OMCNativeTimerWake(self.nativeSplit)` to `OMCNativeSharedActivity(YES,"native-gesture-fallback")`. These are the two wake-behavior deltas; host input relay is the largest new app-scoped path.
5. QA19 user reports recall improved, but center circular knob persistent. QA20 adds `OMCNativePaint(OMCNativeGet(divider,@selector(knob)),s,s.visible)` but YouTube-specific problem persists while other app pairs now fade the knob. Therefore a missing getter was NOT the complete fix.

## CONFIRMED exact backward path (potential native timer reset)
- QA19/QA20 host `OMCYTWakeAll(@"app-process-touch")` iterates tracked YouTube panes, **then publishes** Darwin `com.anlai.omnicar.qa19.controls.activity` if source is `app-process-touch` or `host-pane-local-touch`, with 0.12-second throttle. Crucially, the Darwin publish branch is **not conditional on a nonempty tracked-pane set or verified active CarPlay window**. This is source-confirmed unscoped activity, not evidence that YouTube actually fires phantom touches.
- QA20 native `OMCNativeReceivedActivity` handles Darwin and calls `OMCNativeSharedActivity(NO,"darwin")`, then for each active `SCPCarSplit` calls `OMCNativeTimerWake`.
- `OMCNativeTimerWake` calls `OMCNativeSchedule`, which **invalidates the existing NSTimer and starts another 4-second timer**. Hence if one process sends repeated input-activity signals with intervals <4 seconds, the central knob NEVER reaches its fade callback. This is a **provable conditional consequence** of the code, not proof that signals occurred on this particular phone.
- The host has its own YouTube 4-second handle timer and also re-arms on shared Darwin; because the user says two dots still fade, **a repeated broadcast hypothesis must be reconciled with dot behavior**. Do not declare the relay the sole root cause without showing actual event rate. The other viable case is the native timer fires but YouTube re-creates/repaints the independent knob or exposes a different view/owner.

## READ-ONLY forensic verification/next diagnostic — discriminate, do not guess
Compare a QUIET 7–10-second YouTube+Map session and quiet two-other-app session on physical CarPlay using existing QA20 logs:
- `[OmniCarUnifiedWakeQA19] event=activity-published source=app-process-touch`
- `[OmniCarUnifiedWakeQA20] event=activity-published source=native-gesture-fallback` or `source=original-split-hitTest`
- `[OmniCarNativeSoloTimer] event=hide-two-pane-menus-and-divider`
- `[OmniCarUnifiedWakeQA20] event=native-all-controls-revealed`
- `[OmniCarYTHandleIdleQA19] event=idle4-hide app=youtube`

Interpretation:
A. Many `activity-published` events continuing without finger touch, `hide-two-pane...` absent → false/duplicated wake reset; scope original QA19 relay or use verified touch owner before patching any visibility/geometry.
B. `hide-two-pane...` occurs but circle remains → 4s timer works; inspect **actual visible** SCPCarDividerView.knob pointer, layer opacity/hidden, parent/window and any AppBridge ABKnobView, detect native owner replacement/repainting, without modifying layout or gestures.
C. `hide-two-pane...` absent, no activity events → native state inactive, timer not installed/runloop/stop; inspect `setActive` and `rootDidLayout` at live moment, and whether YouTube is in actual split or external SOLO.

## Precise engineering decision
- Do NOT undo QA19 host wake wholesale: user reports first-tap recall improved. Do NOT blindly add another `divider.knob` paint or reinterpret `SCPCarPane.hostHandle` BOOL as UIView (QA6 unsafe ABI). Do NOT change YouTube scene, player, Solo/Zoom/Swap, split resize or Apple Dock.
- The probable **regression introduction point** is QA19's new broad `UIApplication.sendEvent` -> Darwin -> native timer rearm. Code causal graph established; event existence/frequency on device NOT yet established.
- Before QA21 Sileo build, obtain above brief device event timestamps or implement bounded log-only probes for timer generation/active split/actual view instance. Gate only the verified false activity or wrong owner; leave real first touch as a synchronized wake and idle auto-hide 4s. Test both YouTube+Map and Map+Map to prevent new regression.
- QA20 current Sileo artifact SHA `405faaafad91948796cf2578b5d8238a1466cd6f4fe3a5c3888a500ca8c6eb19` remains installed version. No new source, DEB, Sileo release or direct-device test in this audit.
