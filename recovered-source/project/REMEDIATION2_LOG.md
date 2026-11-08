# Remediation round 2 — integration log (2026-11-08)

Scope: integrate the round-2 source repairs (tray mechanism,
G4 Telex + host tails, G5 single-cluster verdict + build fix,
G7 pocket closures, panel placeholder) into `project/`, rebuild
clean, re-verify per class, restage with parity, update the
handover documents, refresh the publication staging tree.
Evidence files: `project/logs/remediation2-build.log`,
`project/logs/remediation2-perclass.txt`,
`project/logs/remediation2-diff.txt`.

## 1. Toolchain

Verified before building: clang-18 18.1.3, ldid
2.1.4+16.g5b8581c, `/usr/bin/ld.lld -> ld.lld-18`,
iPhoneOS16.5.sdk present. No rollback damage;
`~/bin/fix-toolchain.sh` not needed.

## 2. G5 build fix (structural change)

Problem: the original SplitScreen binary carries the
perf/session cluster ONCE (it is SCPPerfTelemetry.m +
SCPSessionCore.m), but the reconstruction also compiled the
shared `src/OMCCommon/OMCCommon.c` — which contains its own
copy of the cluster — into the SplitScreen target, so the
round-1 built dylib carried the cluster twice.

Fix: `src/OMCCommon/OMCCommon.c` now wraps the cluster span
(perf statics, sampler cluster, car-probing helpers,
OMCDiagCarRecordConnect, OMCOnScreenConnected /
OMCOnScreenDisconnected) in `#ifndef OMC_NO_PERF_CLUSTER`.
Under the guard's `#else`, only the two session entry points
that OMCCrashGuard calls are declared `extern`; in the
SplitScreen binary they resolve to SCPSessionCore.m (the
single instance). `project/OmniCarSplitScreen/Makefile`
adds `-DOMC_NO_PERF_CLUSTER` to that target only. All other
consumers of the shared unit (Core, AppBridge, SpeedBubble,
StartupScreen) compile the full section unchanged.

Built-binary verification (capstone code-site counting: the
original is FAT, so raw string counts are meaningless — the
metric is the number of adrp/add sites that materialise each
string, i.e. how many compiled copies reference it):

- queue label `com.anlai.omnicar.perf`: original arm64 =
  **1 site** (@0x52f8c, inside the queue-creation function);
  round-1 built = 2 sites; round-2 built = **1 site**.
- `diagPerf` __cfstring: original = **1 site** (@0x54de4,
  inside the flush function); round-1 built = 2 sites;
  round-2 built = **1 site**.

Built OmniCarSplitScreen.dylib: 520,832 B (round-1 build:
537,264 B; −16,432 B of duplicated cluster code).

## 3. Sync src/ → project/

Round-2 changed files were identified by mtime against
REMEDIATION_LOG.md and copied to their project counterparts;
all copies verified byte-identical with `cmp`: OMCCommon.c,
ABHostLaunch.m, ABHostGeometry.m, ABInApp.m, ABTelex.m,
OmniCarCarProbe.m, SCPPerfTelemetry.m, SCPCarSplit+Panel.m,
SCPCarSplit+Picker.m, SSStartupViewBuilders.m. (Report files
and `rem4_*.txt` dumps live only in `src/`.)

## 4. Clean build

`make clean` + `make package FINALPACKAGE=1` (THEOS=~/theos,
umask 022): **exit 0, 0 `error:` lines**, all 8 components
staged. Only diagnostics: benign ld64.lld `-multiply_defined`
obsolescence warnings. Log: `logs/remediation2-build.log`.

## 5. Per-class verification (66 classes)

62/66 classes have identical selector sets; **zero classes
are missing any original selector**. The 4 exceptions are
built-side additive-only, identical to round 1:

- SPPBubble (SpeedBubble) 103 → 104 (`+hideIfShownWithReason:now:state:`)
- SSStartupView (StartupScreen) 71 → 73 (two festive helpers)
- OMCSplitScreenController (Prefs) 37 → 38 (`+gestureSwitchChanged:`)
- SSStartupView (Prefs) 71 → 72 (`+gradientLayer`)

OMCAppBridgeAppsController: **105 = 105, selector sets
equal** (explicitly re-checked). Per-binary totals: App 6→6,
AppBridge 193→193, SplitScreen 480→480, StartupScreen
173→175, Prefs 743→745. Full table:
`logs/remediation2-perclass.txt`.

## 6. Aggregate diff (diff_payload.py, final rebuilt DEB)

Files 176 = 176; non-Mach-O files **168/168 byte-identical**;
0 original defined symbols missing in every binary
(built-side surplus symbols are the documented strip-level
artefacts plus the SCPPerfTelemetry/SCPSessionCore externs).
An earlier run of the same diff against the raw Theos DEB
differed only in Installed-Size; the recorded
`logs/remediation2-diff.txt` is the run against the final
restaged DEB below.

## 7. Parity restage + repackage

Phase-3 recipe (per-path modes from the original, payload
chown 501:20, Installed-Size from `du -sk` = 3524, control
copied from the original with Installed-Size replaced,
`dpkg-deb -Zxz`):

- Data tar: **202/202 entries, 0 differences** in
  mode/uid/gid/type vs the original.
- Control tar: modes match (755/644); ownership normalised
  to 0:0 by dpkg-deb — the accepted deviation recorded in
  round 1.
- **Rebuilt DEB: 947,056 B, SHA-256
  `93cdcad934ea5b363665c69051c1368c40143c163e0919b1310a36e503a162bd`**
  (round 1: 947,168 B, `c7ce8483…`).

## 8. Documents

- `handover/RECOVERY_STATUS.md`: section 8 appended
  (append-only; §§1–7 untouched). File is now 37,985 B
  (was 28,400 B); truncation-marker count 0; tail verified.
- Staging `README.md`: round-2 paragraph added to the
  Remediation section with the new DEB SHA.
- `ci/build-fat-macos.yml` written to staging (NOT under
  `.github/` — the coordinator places it): workflow
  `build-fat-macos`, macos-14, Theos + iPhoneOS16.5.sdk
  install, `ARCHS="arm64 arm64e"` build with `make -n`
  evidence step, `lipo -info` acceptance over the 6 dylibs
  + Prefs binary, artifact `omnicar-fat-deb`. YAML validated.

## 9. Staging refresh

Staging (`~/workspace/omnicar-push/recovered-source/`)
refreshed per component from the final omnicar-re tree
(`.theos` excluded; `project/packages/` contains only the
final rebuilt DEB): **4,765 files, 74,306,724 B** before
this log file is copied in (4,766 files after). Tree-wide
truncation-marker sweep over staging `.md` files: **empty**.

## 10. Open items (coordinator)

- Push + fresh-checkout verification at the final commit
  (GPT round-2 point 3: record commit SHA + build log +
  artifact hash together; Prefs must read 743→745).
- Place `ci/build-fat-macos.yml` under `.github/workflows/`,
  run the FAT build on the `ci-fat-test` branch, and record
  the `lipo` evidence (the local VM cannot produce arm64e).
- Behavioural equivalence remains unproven (no device run;
  `handover/DEVICE_VERIFY_PLAN.md`).
