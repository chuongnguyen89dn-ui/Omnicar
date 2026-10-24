# QA6 failure and YouTube-only 4-second non-hide — original ARM64 evidence (2026-10-24)

## CRITICAL corrected interpretation — `SCPCarPane.hostHandle` is a scalar FLAG, not a UIView

Immutable original DEB: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.

Already archived machine disassembly: `audit/OmniCar_original_solo_persistent_control_20261020.json` (GitHub blob `...`; see direct repository blob for canonical SHA). Exact original ARM64:

```asm
SCPCarPane.handle @0xf990:
  0xf990  ldr  x0, [x0, #0x30]
  0xf994  ret
SCPCarPane.hostHandle @0xfb68:
  0xfb68 ldrb w0, [x0, #0x8]
  0xfb6c ret
SCPCarPane.setHostHandle: @0xfb70:
  0xfb70 strb w2, [x0, #0x8]
  0xfb74 ret
```

**CONFIRMED** from instruction forms: `handle` retrieves an object pointer, while `hostHandle` retrieves/stores one **byte** (boolean/mode flag). Therefore **`hostHandle` is NOT the visible YouTube three-dot UIView**; prior descriptions of it as an independent visual object were wrong. Its Objective-C type encoding is being independently checked by the new `scripts/audit_original_youtube_handle_owner_20261024.py` forensic.

**REAL QA6 source mistake:** historical `idle/src/OmniCarIdleControls.xm` blob `ed20b1c7d7ac251f4b59e2eec1244df6b4cb8468` at commit `7f6e45fbaf556256012d84906413e67001cd1fc0` executes:

```objc
id hosted=OMCIdleGet(pane,@selector(hostHandle)); // WRONG: BOOL cast to ObjC id
OMCIdlePaintControl(hosted,visible);               // may message pointer 0x1
```

`OMCIdlePaintControl` then uses `[object isKindOfClass:[UIView class]]`. **If `hostHandle=YES`, messaging address `0x1` can crash SpringBoard/CarPlay process.** This is a concrete ABI-level bug and plausible cause of QA6 device crash; there is not yet a matching .ips stack confirming the exact faulting instruction, so mark causal attribution **STRONGLY SUPPORTED, NOT DEVICE STACK-PROVEN**. QA7 correctly reverted this unsafe source and restored user-reported map+YouTube split stability.

## Original YouTube visual owner and actual installed timer

- The ORIGINAL `OmniCarAppBridge.dylib` has `ABPane.handle` object property plus `ABHost.setupHandleForPane:`, `ABHost.layoutBarForPane:` and `ABHost.buildBarForPane:`. AppBridge manages the hosted iPhone application's UI; visual identity of the LIVE YouTube three-dot remains unproven without runtime view/log.
- `OmniCarSplitScreen.dylib` uses `SCPCarPane.handle` for normal split pane chrome, with `SCPCarSplit.layoutBarForPane:` and `handleTapped:`.
- The ACTUALLY PACKAGED QA12–15 timer is `OmniCarNativeSoloTimer.dylib` from `native-solo-timer/src/OmniCarNativeSoloTimer.xm` blob `8c22067b376c467b0d1c86d1e378b712ef44a32e`. In `OMCNativeApply`, it enumerates `[split allPanes]`, calls `OMCNativeGet(pane,@selector(handle))` and paints the divider. There is **NO** `ABPane.handle`/AppBridge injection or enumeration, and no YouTube-specific handler. `OMCNativeSchedule` runs a 4s nonrepeating timer; `setActive:NO` stops it in SOLO.
- A double tap changing the YouTube/player/Omni zoom proves some independent gesture works but **does not prove the timer targets that same view**. Original binary has `SCPCarSplit.handleDoubleTapped:` IMP `0x25048`, separate from `handleTapped:` IMP `0x253e4`; YouTube may own an additional native player double-tap not measured here.
- User has device-proven map/other handles fade while YouTube stays visible. Under that same split session, this establishes a practical visibility-coverage mismatch: the timer fires for native split views, not the YouTube-rendered host handle.

## Important safe engineering decision

**NEVER** reuse QA6's `hostHandle` cast-to-`id`, `hostedPanes` speculative painting or generic UIWindow overlay. Correct next route is:
1. Complete SHA-pinned original ARM64 `ABHost/ABPane` method owner/call-graph audit (Actions workflow `audit-original-youtube-handle-owner.yml`).
2. Capture LIVE `ABPane.handle` and native `SCPCarPane.handle` view/window/frame/hidden/opacity/parent in YouTube+map; correlate with 4-second timer event. An isolated, log-only and ABI-guarded diagnostic is acceptable; no touch/intercept/geometry change.
3. After confirming live owner, implement a **single per-owner opacity + touch-wake** path on QA12 preserving original video player, divider, native Solo, Zoom/Swap, map and Dock. Do not change AppBridge scene rotation/zoom again (QA13–15 failed on device).
4. Build rootless arm64, source-test, verify payload SHA and publish via current CarPlayDSP Sileo source for parked device QA. No new DEB, Sileo, runtime verification has happened in this forensic report.

Status: **new substantial original code evidence found; no patched binary, no CI final outcome or real-device confirmation here**.
