# OmniCar — Zoom icon below circular divider knob

**Approved UI on 2026-10-19.** A single tap on the divider's circular knob still opens the original three-choice ratio/layout menu **above** the circle. The new feature adds exactly one circular Zoom icon **beneath** that circle, centered on the same divider line. Its light blue/white styling should match the original menu; no original buttons/actions are replaced.

## Candidate 0.3.0
The addon package `com.anlai.omnicar.doubletapfullscreen` retains its ID solely to upgrade prior test versions 0.1 and 0.2. It hooks the existing `SCPCarSplit.showRatioMenuForDivider:` **after** the native method, creating a sibling Zoom control aligned from the live `ratioKnob`; `hideRatioMenu` removes this one extra control. **No double-tap gesture is installed or overridden.**

Zoom toggles a host geometry request using the `appAreaInParent:` hook and native relayout. This is *not yet proven* to hide Apple CarPlay chrome or work perfectly on the vehicle; static compilation alone is not a device test. Debug labels: `[OmniCarZoom] event=hook-installed|menu-unavailable|knob-unavailable|button-installed|zoom-button-pressed|expand-request|restore-request`.

Build workflow `.github/workflows/build-candidate.yml` runs macos-15 / Theos SDK / ldid; DEB and SHA256 are kept under `dist/candidates/menuzoom-0.3.0/` in this repository only. **Never publish to Sileo.**

Test on parked vehicle: original three choices; knob single tap; drag ratio; added icon below knob; fullscreen toggle and reverse; active apps remain running. If it fails, uninstall only addon `com.anlai.omnicar.doubletapfullscreen` and keep OmniCar base package installed.

See [handoff](tiep%20tuc%20du%20an.md) and [audit](audit/OmniCar_1.0.3_doubletap_fullscreen_20261019.md).


## Device report — 0.4.0 failed to show the icon
The user photo at 17:01 (19 Oct 2026) shows `OmniCar Menu Zoom and Chrome 0.4.0` installed in Sileo but **no additional Zoom control** below the native circular handle. Existing menu and circle are visible. 0.4.0 is a device-reported visibility FAIL.

Candidate 0.5.0 changes **only the UI placement/visibility logic**, retaining the same independent addon and untouched three native menu controls. Previous code anchored to `menu.superview` and skipped the button when its rectangle extended beyond that split parent's bounds; also called `OMCAreaValid(menuRect)` that rejected menu heights of 50 pt or less. 0.5.0 uses the real `UIWindow` coordinate space (panel and circle both converted consistently) and accepts any nonempty finite menu rectangle, with a window bounds diagnostic. Static regression tests simulate a compact ratio menu near the edge of a clipped split parent.

Important: these two source-level guards are **plausible causes** of the missing icon, not validated on device. Only a new vehicle photo/log can establish why the 0.4.0 icon did not appear or whether 0.5.0 fixes it. Fullscreen chrome also remains unverified by a real Zoom press. Do not publish to Sileo.
