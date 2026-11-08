# OmniCar 1.0.3 — Recovered Source

Full source reconstruction of the OmniCar 1.0.3 jailbreak tweak
(package `com.anlai.omnicar`, version `1.0.3`, architecture
`iphoneos-arm64`), recovered from the original DEB by static analysis
(disassembly-level reconstruction). No original executable is kept as
a runtime component: every binary in the rebuilt package is compiled
from the source in this folder.

Input DEB: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` (at this
repository's root), SHA-256
`d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.

## Start here

- `handover/RECOVERY_STATUS.md` — final recovery report: what is
  verified, what is inferred, the definitive remaining-gaps list
  (G1–G8), and the verification scope.
- `handover/BUILD_GUIDE.md` — how to build the project and reproduce
  the rebuilt DEB.
- `handover/DEVICE_VERIFY_PLAN.md` — on-device behaviour verification
  plan (no device run has been performed yet; all verification so far
  is structural/static).

## Layout

- `src/` — canonical reconstructed source, one folder per component
  (App, AppBridgeA/B, OMCCommon, Prefs, SpeedBubble, SplitScreenA/B/C,
  StartupScreen, CarProbe), each with its module report and disassembly
  evidence.
- `project/` — the Theos project (8 subprojects) generated from
  `src/`; builds the full package. Build logs in `project/logs/`,
  phase reports in `project/BUILD_PHASE*.md`.
- `project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb`
  — the rebuilt DEB from the final clean build, SHA-256
  `9a593ed2649c2da95e703c81fa121e01116911cea6efea65b6a9d99b93537170`.
- `inventory/` — full payload inventory of the original DEB.
- `metadata/` — code maps (IPC, prefs, hooks), the function→source
  coverage census (`FUNCTION_SOURCE_MAP.tsv`, 3,280 functions), and
  the Mach-O/ObjC parsers used.
- `verify/` — the calibrated ground-truth resolver used by every
  verifier pass.

## Final state (2026-11-08)

- Clean build of all 8 components, 0 errors.
- Rebuilt payload vs original: 176/176 files, 168 non-executable
  resources byte-identical, 0 original defined symbols missing,
  method counts exact for App (6), AppBridge (193), SplitScreen
  (480), Prefs (743); remaining deltas are documented and explained.
- True stub count: 0 in every module.
- Known limits: the local build is arm64-only (the VM's Ubuntu
  clang-18 silently degrades arm64e); building this same source with
  Xcode on macOS (e.g. GitHub Actions) produces the FAT arm64+arm64e
  binaries like the original. Behavioural equivalence is not yet
  proven on a real device — see the verification plan above.

## Remediation (2026-11-08, second commit)

An external review of the first publication found the handover
report cut short, the coverage census unadjudicated, INFERRED
pockets in SplitScreen presentation logic, and the fresh-checkout
build unproven. All four were closed:

- `handover/RECOVERY_STATUS.md` restored in full (section 7 is the
  remediation addendum); the cut-short first edition is recorded in
  its integrity note.
- The census was adjudicated row by row
  (`metadata/CENSUS_ADJUDICATION.md`): of 675 unclaimed rows, 664
  are bookkeeping and 11 were genuinely missing bodies — all 11
  have since been reconstructed from the binary, so the genuinely
  missing count is now 0.
- Per-class method parity (not just per-binary totals): 62 of 66
  classes have identical method sets; the 4 exceptions are
  built-side additive methods only, named in
  `project/REMEDIATION_LOG.md`. OMCAppBridgeAppsController is
  105/105.
- A fresh clone of this repo built clean outside the analysis
  workspace; the verification tools now derive their paths from
  their own location.
- Rebuilt DEB (this commit): SHA-256
  `c7ce84830778b49e4ca5733c59e10da99293ef07bbaccfb1ff6d273bd1c33ef9`,
  947,168 bytes; data-tar parity vs the original 202/202 entries,
  0 differences.

## Remediation round 2 (2026-11-08, third commit)

A second external review found the tray window's touch mechanism
omitted (not merely condensed), remaining unverified material in
gaps G4–G7, and the fresh-checkout evidence stale. All are closed —
see `handover/RECOVERY_STATUS.md` section 8 and
`project/REMEDIATION2_LOG.md`:

- `trayWindowForParent:` rewritten in full: the window is a
  `UIRootSceneWindow` re-classed into a runtime `SCPCPass_`
  subclass whose `hitTest:withEvent:` returns nil for
  self-hits, so the tray's empty areas are touch-transparent.
- G4 closed: `ABTelexApply` transcribed branch-for-branch and
  diffed against the original IMP over 253,908 interpreter cases
  (0 mismatches); the AppBridge host tails line-read to their
  ends. G5 closed (verdict ii): the original carries one
  perf/session cluster — the reconstruction's duplicate copy is
  now excluded from the SplitScreen target by a build guard, and
  the built dylib verifies with exactly one cluster (queue-label
  and `diagPerf` string sites both 1, matching the original).
  G7 closed: every remaining INFERRED pocket line-read; none
  remains inferred. Panel placeholder rebuilt with the separate
  dash sublayer and the proven `@[@3, @3]` pattern.
- Rebuilt DEB (this commit): SHA-256
  `93cdcad934ea5b363665c69051c1368c40143c163e0919b1310a36e503a162bd`,
  947,056 bytes; data-tar parity vs the original 202/202 entries,
  0 differences; per-class parity re-verified (62/66 exact, zero
  classes missing selectors).
- FAT (arm64+arm64e) build: `ci/build-fat-macos.yml` in this
  folder is a ready-to-run GitHub Actions workflow for a macOS
  runner; the coordinator places it under `.github/workflows/`.
  **Executed and PASSED on 2026-11-08** (branch `ci-fat-test`,
  run 42459179466, commit `b35f8cc`): on a macos-15 runner the
  build engaged arm64e (dry-run + 100 arm64e compile lines) and
  the workflow's own acceptance step verified with `lipo -info`
  that all 6 dylibs, the Prefs binary and the app binary are
  FAT `arm64 arm64e`; the produced FAT DEB is 1,121,484 bytes
  (artifact `omnicar-fat-deb` on that run). Evidence:
  `project/logs/fat-macos-run3.md`. Two runner-level failures
  preceded the pass and are documented there (an unsupported
  macos-14 pool configuration, and Xcode clang rejecting the
  Linux-only `-fuse-ld=lld` Makefile flag, which the workflow
  strips in its own checkout only). Gap G1 is therefore closed
  by execution, not by environment argument.
- Fresh-checkout proof at this commit: a clean clone of commit
  `fcfc202747a7d0f6824363e3a6adb33d52d4c375` built with exit 0
  and reproduced the final profile — Prefs 743 → 745, all other
  binaries at their documented counts, 0 original symbols
  missing. The bound evidence (commit SHA + build log + diff +
  produced-DEB SHA-256 `050fb437…`) is in
  `project/logs/final-fresh-checkout/`.

## Hotfix (2026-11-08)

Acceptance round 1 on a real device crash-looped SpringBoard
(four identical SIGABRT reports at startup). Root cause class,
found by external review and re-verified in-tree: the
AppBridge SpringBoard host hooks were broken at the contract
level — all five installers passed NULL for the original IMP
(the `applicationDidFinishLaunching:` original was never
called at all), and the parallel A/B reconstructions each
installed the same five hooks, so the group was chained
twice. The five originals are now wired, the launch original
is called first, tree A's duplicate installer is disabled,
and the registrar registers all six channels as the original
does. A further review round fixed an `OMCHasMethod`
signature mismatch, CADisplayLink hook targets (metaclass vs
instance class), a pid read through an `id`-returning helper,
and restored the `closeApp:terminate:` tail. A tree-wide
hook-contract audit found the defect class confined to that
one group (56 other install sites clean) — see
`handover/RECOVERY_STATUS.md` section 9 and
`project/REMEDIATION3_LOG.md`. Rebuilt DEB (this commit):
SHA-256
`ff4c9e7e7901e071b1897d0e8572f0f2c56d986888018219d2704fe327666798`,
949,028 bytes; per-class parity re-verified (62/66 exact,
zero classes missing selectors); built-binary hook count now
matches the original (host group installed once, was twice).
Causation of the device crashes is to be proven by the
startup-first device retest.
