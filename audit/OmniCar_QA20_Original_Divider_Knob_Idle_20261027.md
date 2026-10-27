# QA20 — fix real center circular divider knob staying visible in QA19 (2026-10-27)

## Device evidence
User reports QA19 has **improved** showing both three-dot handles after touch, and both pane menus automatically fade, **BUT the single round knob at the center divider does not auto-hide**. Do not regress QA19 touch-to-wake behavior.

## Actual root cause — verified against existing source / original ABI
- `native-solo-timer-qa19/src/OmniCarNativeSoloTimer.xm` `OMCNativeApply()` calls `OMCNativePaint(divider,s,s.visible)` for each `[split dividers]`, but NEVER reads the **actual original** independent `SCPCarDividerView.knob`.
- Original disassembly `audit/OmniCar_DuoFace_Original_Touch_IPC_20261024.json` confirms `SCPCarDividerView.touchesBegan:withEvent:` invokes `knob` and manipulates that actual view/layer.
- Pre-existing first implementation `idle/src/OmniCarIdleControls.xm` already explicitly painted `OMCIdleGet(divider,@selector(knob))`. It also warns the `SCPCarSplit.ratioKnob` is a DIFFERENT short-lived ratio popup knob. Therefore using `ratioKnob` to hide the main round handle would be wrong.
- This is a definite **missing opacity target** in QA19 source. The precise layout/visibility on user's CarPlay still needs device validation.

## Minimal patch
- `native-solo-timer-qa20/src/OmniCarNativeSoloTimer.xm`: in `OMCNativeApply`, paint both divider UIView and `OMCNativeGet(divider,@selector(knob))` using the SAME `s.visible` / original four-second timer. On wake restore both original `layer.opacity` values via `OMCNativePaint`. Do not set `hidden`, `userInteractionEnabled`, `frame`, geometry or replace the native drag gestures. Preserve native touch hit tests and original 4s inactivity policy.
- Preserve **exact existing** `com.anlai.omnicar.qa19.controls.activity` Darwin IPC so original QA19 host YouTube handles stay synchronized. Do not rebuild or replace `OmniCarYouTubeHandleIdle.dylib`, whose QA19 one-tap wake improved per user.
- New artifact is single unified rootless Sileo upgrade `1.0.3-omnicar20-divider-knob-idle`. Assembly `scripts/assemble_qa20_divider_knob_idle.py` SHALL check immutable QA19 input SHA256 `af6585d750504c1194a756f6b7b3ea8244d53271d115a046380f63c607bde16b`, rebuild only `OmniCarNativeSoloTimer.dylib`, verify **181 other payload files identical** with SHA inventory and unchanged original DEBIAN fields. QA19 host player/YouTube, Solo, Zoom, Swap, divider pan, dock stay bit-identical.
- Static guard `scripts/test_qa20_divider_knob_idle_source.py` requires exact one-code-path diff with QA19 and provenance of getter in QA7 source. CI `.github/workflows/build-qa20-divider-knob-idle.yml` does ARM64 build and archive; Sileo publication/pinned checksum and parked-car test are separate.
- **QA20 device test pending**: both menu buttons PLUS center round knob and divider line must disappear together after 4s idle; one touch anywhere in the video/map calls ALL back immediately; native knob can still drag split ratio, Zoom/Swap menu works, SOLO restore and Dock unchanged. Any failure should be recorded, NOT called PASS due to CI.


## 2026-10-27 QA20 first publisher failure and verified single-assertion correction

- First publisher `carplaydsp` workflow `40448198523` failed at job `122004406527`, step `Complete APT repository index and Release (additional independent packages)`, after the QA20 DEB had passed exact SHA check. Actual log at `2026-10-27T04:12:37Z` asserted `entry['Version']=='1.0.3-omnicar19-app-process-wake'` and also hardcoded QA19 Filename/SHA even though the APT entry correctly contained QA20 `1.0.3-omnicar20-divider-knob-idle`. Thus no Pages deploy occurred in the first run.
- Verified fix on publisher `chuongnguyen89dn-ui/carplaydsp/.github/workflows/build.yml`: replace ONLY 3 stale OmniCar package index assertions to expect QA20 Version, Filename, and SHA `405faaafad91948796cf2578b5d8238a1466cd6f4fe3a5c3888a500ca8c6eb19`. GitHub commit `3c133cef10fe398e8d2078b8580d2e7363c43406`, read back SHA verified. No unrelated DuoFace/DuoNavi publisher checks touched.
- New actual publisher run `40448533707` and YAML actionlint `40448533753` started; lint SUCCESS at 2026-10-27 04:13 UTC. Publisher build/deploy still in_progress when last inspected. Independent public SHA verifier OmniCar `40448218202` in_progress, waiting for correct Pages content. Do not claim installed, delivered, or on-device PASS until workflows finish.
