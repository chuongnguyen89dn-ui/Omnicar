# VERIFY_MAPS_SPOTCHECK — 15 rows re-derived from the binaries

Verifier #2 (wave 3), 2026-11-08. Rows chosen as a spread across
IPC_MAP.md, PREFS_MAP.md, HOOK_MAP.md; each re-derived with the
verifier's own capstone pass + 0-based resolver
(`verify/macho_truth.py`), never from `metadata/xref/*.json`.

**RESULT: 15/15 rows agree. 0 disagreements.** (Two PREFS rows were
confirmed on their read/write attribution; their "code default" column
was not re-derived — noted per row.)

## IPC_MAP (6/6)

| # | Row | Re-derivation |
|---|---|---|
| I1 | `…/appbridge.keyboard` posted by AppBridge sub_6ad4 @0x6c28 | @"com.anlai.omnicar/appbridge.keyboard" loaded @0x6c24 → `_notify_post` @0x6c28 ✓ (set_state @0x6c0c in the same function also matches the map's state column) |
| I2 | `…/car.connected` posted by Core sub_9bc0 @0x9fe0 | name loaded @0x9fdc → `_notify_post` @0x9fe0 ✓ |
| I3 | `…/speedbubble.source` set_state by SpeedBubble sub_d088 @0xd0c8, payload 255 | `mov w1, #0xff` @0xd0c0 → `_notify_set_state` @0xd0c8 ✓; `_notify_post` of the name @0xd0dc also as mapped ✓ |
| I4 | `…/prefschanged` posted by Prefs _OMCRescueRestore @0x7c38 | verified during the Prefs module check: SetAppValue ×3 → Synchronize → `_notify_post` @0x7c38 ✓ |
| I5 | `…/rescue` observed by Core sub_46f0 @0x47b4 | name loaded @0x4794 → `_notify_register_dispatch` @0x47b4 ✓ |
| I6 | `…/startupscreen.weather.request` posted by StartupScreen SSSplash -[refreshWeather] @0x657c | name loaded @0x6578 → `_notify_post` @0x657c ✓ |

## PREFS_MAP (5/5)

| # | Row | Re-derivation |
|---|---|---|
| P1 | `appBridgeZoom` read by AppBridge ABHost -[zoom] | key ref @0xae38 inside the method, `_OMCPref` call @0xae44 ✓ (default @80 column not re-derived) |
| P2 | `appBridgeApps` read by SplitScreen _SCPChosenPhoneApps | key ref @0x9a84, `_OMCPref` call @0x9a8c ✓ |
| P3 | `diagCar` written by Core sub_9bc0 | key ref @0xa370 → `CFPreferencesSetAppValue` @0xa380 ✓ |
| P4 | `carProfilesEnabled` read by CarProbe sub_7b6c | key ref @0x8354, `_OMCPref` call @0x8360 ✓ (default kCFBooleanFalse column not re-derived) |
| P5 | `appBridgeKeyboardLang` written by AppBridge ABKeyboard -[keyTapped:] | key ref @0x1d0d4 → `CFPreferencesSetAppValue` @0x1d0e0 ✓ |

## HOOK_MAP (4/4)

| # | Row | Re-derivation |
|---|---|---|
| H1 | SplitScreen sub_58b4 @0x5a30: DBDashboardRootViewController `presentBaseViewController:animated:launchSource:completion:` → sub_636c, orig @0x88068 | selref @0x5a1c = the claimed selector; x2 → 0x636c; x3 → 0x88068; `_MSHookMessageEx` @0x5a30 ✓ |
| H2 | SplitScreen sub_44a8 @0x4550: metaclass of DashBoard `_newApplicationLibrary` → sub_4af0, orig @0x87fb0 | `_OMCCarClass` call then `_object_getClass` (metaclass ✓); selref = `_newApplicationLibrary`; x2 → 0x4af0; x3 → 0x87fb0; `_MSHookMessageEx` @0x4550 ✓ |
| H3 | AppBridge sub_4728 @0x4814: UIWindow `_setRotatableViewOrientation:duration:force:` → sub_543c, orig @0x3e958 | selref = claimed selector; x2 → 0x543c; x3 → 0x3e958; `_MSHookMessageEx` @0x4814 ✓ |
| H4 | SpeedBubble sub_5950 @0x5ac0: CLLocationManager `startUpdatingLocation` → sub_5fac, orig @0x43808 | selref = `startUpdatingLocation`; x2 → 0x5fac; x3 → 0x43808; call @0x5ac0 resolves via LC_DYSYMTAB to `_MSHookMessageEx` — the row sits in the map's MSHookMessageEx section ✓. (Caution for readers: the module agent's *pre-regeneration* dump labelled stub 0x27bfc `_MSHookFunction`; that label is void per ANNOTATION_AUDIT, and both the symtab and the argument shape — class + SEL — prove MessageEx.) |
