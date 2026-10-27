# OmniCar QA19 — application touch event relay (2026-10-27)

## Device report superseding QA18
User reports QA18's hidden controls cannot be recalled reliably; touching video/application area interacts ONLY with hosted app, NOT with split dots/divider. QA18 on-device **one-tap FAIL**. QA18 build, Sileo deploy and SHA verification were successful but did not prove this behavior.

## Original evidence and pinpointed omission
- DuoFace Native12 original `CBBridgedUIAppView.hitTest:withEvent:` and `CBSplitContainerView.hitTest:withEvent:` send shared `noteUserActivity` even before normal hitTest; central blinking session wakes its controls.
- OmniCar QA18 original `SCPCarSplitView.hitTest` and ABHost `ABPane.box` gesture observer see only their own UIKit view hierarchy; a forwarded touch within remote hosted app can bypass both. The user's observed symptom supports this mismatch but no process-level device trace confirms exact touch owner.
- Independent confirmed bug: QA18 native `OMCNativeTimerTouch.touchesBegan` only woke its own split instead of broadcasting shared activity. QA19 connects to `OMCNativeSharedActivity(YES,...)`.
- Enlarging/overlaying an invisible hitbox would steal native YouTube/Maps touches. **Do not implement that**.

## QA19 targeted source changes
- New native and host modules copied from QA18 R2 and revised with new QA19-only Darwin key. On original native gesture fallback, call ONE native global wake+broadcast instead of pane-local wake.
- Host module has an independently initialized **passive** `UIApplication.sendEvent:` observation in app processes, excluding the CarPlayApp/SpringBoard/backboardd/UIKit and WebKit helpers. Always call `%orig` FIRST, inspect only touch phase Began, broadcast activity to all controls. Do not capture/change target or app gesture, player, external scene, animation, rotation, fullscreen, dock, ratio pan, swap or solo.
- One tap in app/process can wake all native handles and divider and active ABHost YouTube handles by synchronized Darwin notification. Existing four-second fade and QA16 user-confirmed hide logic preserved.
- QA19 app-process hook is runtime UNVERIFIED. It can also observe phone-app taps during an active CarPlay session. Native only reveals controls for an active OmniCar split; host only reveals currently tracked ABPane YouTube controls. Before claiming fixed, verify `[OmniCarUnifiedWakeQA19] event=app-input-relay-installed`, `event=activity-published source=app-process-touch`, `event=native-all-controls-revealed` and `event=youtube-handle-revealed` on device. If app dispatch is routed elsewhere, do NOT invent another overlay.
- Base immutable QA18 R2 Sileo DEB SHA256: `06c7ae70ebc518e2a6f9dbd3ff181ecb1461329005d74b6ff78b27dbcb4135cf`; archive in `dist/candidates/omnicar-qa18-duoface-unified-wake-r2/`. Package updates exactly two rootless .dylib payload entries and control version, other 180 unchanged.
- Distinct QA19 candidate version: `1.0.3-omnicar19-app-process-wake`. Reproducible scripts: `scripts/assemble_qa19_passive_app_input_wake.py`, `scripts/test_qa19_passive_wake_source.py`; CI `.github/workflows/build-qa19-passive-app-input-wake.yml`. Compile/package and Sileo public verification separate from *physical device PASS*.

## Actual acceptance on parked car
Open YouTube+Maps split, allow two dots/divider to hide after four seconds. One tap anywhere on visible YouTube video **not over the original three-dot** must immediately reveal BOTH pane menus and native divider, while preserving original YouTube play/scroll response. Repeat on map, both pane combinations, Zoom, Swap, divider pan, Solo, exit and crash check. This still must be tested on a real CarPlay display after Sileo delivery.
