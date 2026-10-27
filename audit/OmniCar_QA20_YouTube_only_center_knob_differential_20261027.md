# QA20: Native center round knob hides with two non-YouTube apps but NOT when YouTube opens — differential regression

Date: 2026-10-27. Repo `chuongnguyen89dn-ui/Omnicar`, branch `main`. User is testing Sileo version `1.0.3-omnicar20-divider-knob-idle`.

## NEW PHYSICAL CARPLAY REPORT (USER, unambiguous)
- With **two other apps (not YouTube)** in OmniCar split view: the **center circular divider knob DOES auto-hide**.
- When opening **YouTube**, that **same center circular knob DOES NOT auto-hide**.
- Previous QA19 user report: return/show controls is easier, both per-pane three-dot handles fade, but center knob didn't.
- This is an A/B observation; exact YouTube mode (playing video vs YouTube home), runtime view pointers, opacity, and touch timers not captured. Do not invent them.
- This observation supersedes the general QA19/QA20 statement that the knob never fades in any app combination. Do not claim QA20 is functionally complete.

## Verified existing source and binary evidence
1. `native-solo-timer-qa20/src/OmniCarNativeSoloTimer.xm` has a 4.0s timer. At timeout `OMCNativeSchedule` sets `state.visible=NO` and calls `OMCNativeApply`. This iterates `SCPCarSplit.allPanes` for native pane.handle and `SCPCarSplit.dividers` for both divider UIView **and its** `SCPCarDividerView.knob`; `OMCNativePaint` sets `layer.opacity=0.0f`. Only a matched view is painted. Success with two non-YouTube apps confirms at least one real split case reaches the correct visible knob; fails under YouTube, so a simply missing knob getter or globally broken four-second timer is no longer an adequate diagnosis.
2. This exact QA20 source has no YouTube bundle check in native hide traversal, and *does not* hook `SCPCarDividerView` layout/knob reset methods; repeat native `rootDidLayout` invokes `OMCNativeApply`, but `layoutBarForPane:` repaints only the pane.handle, **not** knob. It also does not instrument view pointer/owner changes or log each divider and knob's `opacity` at timeout. Therefore the source by itself cannot prove **why** YouTube causes persistent visual knob.
3. QA19/QA20 preserve separate `OmniCarYouTubeHandleIdle.dylib` in AppBridge / `com.apple.UIKit` processes. `ABPane.handle` / `ABPane.handleHit` belong to `ABHost`, a different owner from native `SCPCarDividerView.knob`. Original SHA-pinned ARM64 audit `audit/OmniCar_DuoFace_Original_Touch_IPC_20261024.json` identifies `ABHost` / `ABKnobView` / `ABPane` vs `SCPCarSplit` / `SCPCarDividerView` in separate dylibs. That **does not prove** the persistent center round control is ABKnobView; it must be traced on the device.
4. QA19 AppBridge global touch relay `youtube-handle-qa19/src/OmniCarYouTubeHandleIdle.xm` forwards `UITouchPhaseBegan` activity over `com.anlai.omnicar.qa19.controls.activity`. The native QA20 receiver always restarts the four-second timer on a received activity. Repeated real/synthesized activity while YouTube is open **could** keep the knob visible, but there is **no evidence of repeated touches** and genuine video frames are not UITouch events. Cannot conclude this explanation.
5. Older `idle/src/OmniCarIdleControls.xm` additionally hooks native `SCPCarSplit.newDividerAt:`, `SCPCarDividerView.touchesBegan/Ended/Cancelled` and `SCPCarSplit.hideRatioMenu`; QA20 source does **not** contain these hooks. They were not safely reused due to past crash/regression history, and their mere presence is **not proof** of solving the YouTube-specific mismatch. Original `SCPCarSplit.ratioKnob` is **not** the normal divider round knob.

## Distinguishing hypotheses (NOT device-confirmed)
- H1: Native 4s callback fires under YouTube but YouTube/AppBridge changes or re-creates the actual displayed knob or layer afterward; `SCPCarSplit.dividers`/knob getter at timer time may not reference the visible knob.
- H2: YouTube mode produces repeated activity signals or native split activation/layout lifecycle resets so the 4s callback does not execute or exits inactive.
- H3: The apparent round control comes from an AppBridge mirror/alternate owner rather than the native divider; needs live runtime identity.
All 3 remain UNTESTED, and none justifies a blind new visibility hook or a promise of fixed behavior.

## Already deployed QA20 live source and existing logs
- QA20 immutable DEB SHA256 `405faaafad91948796cf2578b5d8238a1466cd6f4fe3a5c3888a500ca8c6eb19` (OmniCar Actions `40447971247` build SUCCESS, publisher `40448533707`/Pages SUCCESS, public byte verifier `40448218202` SUCCESS), **device YouTube knob FAIL**.
- Existing useful messages: `[OmniCarNativeSoloTimer] event=hide-two-pane-menus-and-divider`, `[OmniCarUnifiedWakeQA20] event=activity-published source=...`, `event=native-all-controls-revealed`, `[OmniCarYTHandleIdleQA19] event=idle4-hide app=youtube`. Compare timestamps in YouTube+Maps and Maps+Maps with no touch for >6s. These indicate timer/relay, not physical knob owner.
- If timer fires but circle persists, log-only diagnostic must capture *actual* instance, class, pointer, window, parent, knob.layer.opacity/hidden, divider count before/at/after hide, with one read-only host-side check for ABKnobView; no account/video data.
- If timer is repeatedly reset, correlate with actual QA19 `activity-published` log and native active states; do not suppress genuine YouTube app touches to force fade.

## Guardrails and next action
- Keep QA19's user-reported improved **one-tap reveal**, QA20's working fade for two non-YouTube apps, YouTube original player, Zoom/Swap/Solo, divider pan, dock and app scene unchanged.
- No new DEB/release until live owner or callback reset is distinguishable from actual evidence (existing QA20 logs or a narrowly scoped diagnostic). Do not repeat QA19->QA20 guess that adding `divider.knob` alone solves every host combination.
- Acceptance: with **YouTube + another app**, center round knob AND both three-dot menus fade after 4s; tap any app shows all, while YouTube playback and center divider drag continue; verify two-other-app baseline remains good.
