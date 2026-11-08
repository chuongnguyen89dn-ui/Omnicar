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
