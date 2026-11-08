# Final-commit fresh-checkout verification — EVIDENCE

This bundle was produced from a clean clone at the commit below.
Nothing was built in any pre-existing working tree: clone, build,
and diff all ran inside the fresh checkout.

## Identity

- Repository: https://github.com/chuongnguyen89dn-ui/Omnicar.git
- Commit (asserted): `fcfc202747a7d0f6824363e3a6adb33d52d4c375`
  (`git rev-parse HEAD` in the clone printed exactly this SHA;
  commit subject: "Remediation round 2: … RECOVERY_STATUS section 8")
- Clone path: `~/workspace/final-fresh-check`
- Build tree used: `<clone>/recovered-source/project`
- Date of run: 2026-11-08 (Asia/Ho_Chi_Minh)

## Toolchain state (verified before building; no fix needed)

- clang-18: `/usr/bin/clang-18`, Ubuntu clang 18.1.3 (dpkg: installed)
- ldid: `/usr/local/bin/ldid` (present)
- `/usr/bin/ld.lld` -> `ld.lld-18`
- Theos: `~/theos`; SDK `~/theos/sdks/iPhoneOS16.5.sdk` present
- `~/bin/fix-toolchain.sh` was NOT needed this run.

## Build

- Command: `export THEOS=~/theos; umask 022; make package FINALPACKAGE=1`
- **Build exit code: 0** (`BUILD_EXIT=0`, last line of `build.log`;
  zero lines matching "error" in the log)
- Full log: `build.log` in this bundle (70,875 bytes).

## Diff (clone's own `project/tools/diff_payload.py`, defaults;
## original resolved by the tool itself at the clone's repo root)

Full output: `diff.txt` in this bundle. Headline numbers, verbatim
from the tool's summary:

```
  files: 176 original / 176 built / 176 common
  common files byte-identical: 168
  common non-Mach-O files differing: 0
  Mach-O files compared: 8
```

Per-binary classes / methods (original -> built), as printed:

| binary | classes | methods | original defsyms missing |
|---|---|---|---|
| OmniCar | 1->1 | 6->6 | 0 |
| OmniCarAppBridge.dylib | 8->8 | 193->193 | 0 |
| OmniCarCarProbe.dylib | 0->0 | 0->0 | 0 |
| OmniCarCore.dylib | 0->0 | 0->0 | 0 |
| OmniCarSpeedBubble.dylib | 9->9 | 277->278 (+1 documented additive) | 0 |
| OmniCarSplitScreen.dylib | 11->11 | 480->480 | 0 |
| OmniCarStartupScreen.dylib | 8->8 | 173->175 (+2 documented inlined helpers) | 0 |
| OmniCarPrefs | 29->29 | **743->745** | 0 |

- **Prefs reads 743 -> 745 at this final commit** — superseding the
  stale 743->743 figure in the previous round's fresh-checkout log,
  which had been produced from an older commit's tree.
- Per-class spot proof (same parsers, `perclass-OMCAppBridgeAppsController.txt`):
  `OMCAppBridgeAppsController` method keys **105 original / 105 built**,
  selector sets identical (0 only in original, 0 only in built).
- Only control-field difference on this raw Theos deb:
  `Installed-Size` original 6160 vs built 3524 — expected; the
  shipped parity-restaged artifact corrects it.
- Archs read `arm64,arm64e -> arm64` on every binary — the
  documented VM clang limitation (gap G1), not a checkout defect.

## Artifact produced by THIS clone build

- File: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`
  (aggregate deb written by the clone build into
  `<clone>/recovered-source/project/packages/`)
- **SHA-256: `050fb4373d62b3e5a7e9502a1ff155aa9a4d8e0dd0724bbcf602392209b33a00`**
- Size: **946,628 bytes**
- This raw Theos deb's hash is expected to differ from the shipped
  parity-restaged artifact (`93cdcad9…`); the binding that matters
  is: this hash <- this build <- commit `fcfc2027…` above.

## Bundle contents

- `EVIDENCE.md` — this record
- `build.log` — full build log (`BUILD_EXIT=0` on its last line)
- `diff.txt` — full `diff_payload.py` output
- `perclass-OMCAppBridgeAppsController.txt` — per-class proof
