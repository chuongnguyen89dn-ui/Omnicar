# BUILD GUIDE — OmniCar 1.0.3 reconstructed source project

How to build the reconstructed OmniCar 1.0.3 (`com.anlai.omnicar`,
rootless, `iphoneos-arm64`) from the sources in this tree, and how to
prove the result against the original package.

Reference input (the ONLY binary evidence for this project — never mix
in any other build, e.g. QA20 or any Muse repack):

- `input/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`
- SHA-256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`
  (verified before extraction; re-verify before trusting any payload
  comparison).

Steps whose exact commands/output the final integration build had not
yet confirmed were marked [PENDING FINAL BUILD]. **All such markers
were resolved by Integration Phase 3 (2026-11-08)** — see §8 and
`project/BUILD_PHASE3_LOG.md`.

---

## 0. Tree layout (what you are working with)

| Path | Contents |
|---|---|
| `input/` | The original DEB (hash above). |
| `payload/` | Extracted original payload (176 files) — the comparison baseline. |
| `inventory/` | `manifest.tsv` (177 rows) + `INVENTORY.md` — full payload inventory. |
| `metadata/` | Per-binary Mach-O/ObjC metadata, calibrated xref data, cross-module maps (`IPC_MAP.md`, `PREFS_MAP.md`, `HOOK_MAP.md`), coverage + audit files. |
| `src/<Module>/` | The reconstructed sources + one report per module. |
| `project/` | The aggregate Theos project (this is what you build). |
| `project/tools/diff_payload.py` | Payload-diff harness (see §6). |
| `verify/` | Ground-truth Mach-O resolver used by the verifiers. |
| `handover/` | This guide, `DEVICE_VERIFY_PLAN.md`, `RECOVERY_STATUS.md`. |

## 1. Verify the toolchain FIRST (VM `/usr` rolls back silently)

This VM loses parts of `/usr` on rollback without any warning. Before
every build session, check all four:

```sh
which clang-18          # must print /usr/bin/clang-18
dpkg -l clang-18        # must show an installed entry
which ldid              # must print /usr/local/bin/ldid
readlink /usr/bin/ld.lld   # must print ld.lld-18
```

If anything is missing, run the standing repair script **once, in the
foreground**:

```sh
~/bin/fix-toolchain.sh
```

It reinstalls clang-18/lld-18/llvm-18/fakeroot via apt, restores the
`/usr/bin/ld.lld -> ld.lld-18` symlink, reinstalls ldid
`v2.1.4+16.g5b8581c` plus its /tmp-signing shim, and ends with a
compile+link smoke test (`clang-18 -fuse-ld=lld`). Do not build until
the smoke test passes. (This exact rollback was found and repaired
again during the scaffold stage — see `project/BUILD_PREP_REPORT.md`
§1.)

Fixed environment facts:

- Theos at `~/theos`; SDK `~/theos/sdks/iPhoneOS16.5.sdk`.
- `TARGET = iphone:clang:16.5:15.0` (originals: min iOS 15.0, SDK 16.4 —
  the 16.5 SDK skew is cosmetic, see §7).
- `THEOS_PACKAGE_SCHEME = rootless`.
- Build with `umask 022` (the workspace setgid/umask otherwise produces
  DEBIAN dirs dpkg-deb rejects).

## 2. Project structure and the plug-in contract

`project/` is an aggregate Theos project: master `Makefile` + `control`
(byte copy of the original DEBIAN/control) + `layout/` (PreferenceLoader
entry) + one subproject per original binary:

| Subproject | Builds | Reconstructed sources plug in from |
|---|---|---|
| `OmniCarApp/` (application) | `OmniCar.app` | `src/App/` |
| `OmniCarCore/` (tweak) | `OmniCarCore.dylib` | `src/OMCCommon/` (`OmniCarCore.c` + shared unit) |
| `OmniCarAppBridge/` (tweak) | `OmniCarAppBridge.dylib` | `src/AppBridgeA/` **and** `src/AppBridgeB/` (merge — §3) |
| `OmniCarCarProbe/` (tweak) | `OmniCarCarProbe.dylib` | `src/CarProbe/` |
| `OmniCarSpeedBubble/` (tweak) | `OmniCarSpeedBubble.dylib` | `src/SpeedBubble/` |
| `OmniCarSplitScreen/` (tweak) | `OmniCarSplitScreen.dylib` | `src/SplitScreenA/` + `src/SplitScreenB/` + `src/SplitScreenC/` (merge — §3) |
| `OmniCarStartupScreen/` (tweak) | `OmniCarStartupScreen.dylib` | `src/StartupScreen/` |
| `OmniCarPrefs/` (bundle) | `OmniCarPrefs.bundle` | `src/Prefs/` (A + B halves) |
| `OMCCommon/` | — (not packaged) | `src/OMCCommon/` — source-shared unit |

Plug-in contract per subproject: delete the placeholder `.m` (each is
marked `// SCAFFOLD PLACEHOLDER` and names its `src/<Module>/`), then
list the module's reconstructed `.m`/`.c` files in `<Name>_FILES` in
that subproject's Makefile. Install paths, substrate filter plists,
resources and `control` are already final in the scaffold.

**OMCCommon is an include unit, not a binary** — matching the original,
where the same 20-function OMC\* C core is statically compiled into
every dylib and no OMCCommon binary exists. Each consumer Makefile sets
`OMC_TARGET_NAME` and includes `../OMCCommon/OMCCommon.mk`, which
appends `OMCCommon.c` to the consumer's `_FILES`.

- **[CONFIRMED — phase 3]** `_OMCLogWrite` variant wiring: the core
  reproduces the original's one divergent shared function from a single
  source — Core builds *without* `-DOMC_MODULE_NAME`; the other five
  dylibs build *with* `-DOMC_MODULE_NAME='"<ModuleName>"'`
  (`"AppBridge"`, `"SplitScreen"`, `"SpeedBubble"`, `"CarProbe"`,
  `"StartupScreen"`). Phase 3 confirmed every consumer Makefile
  carries the define (clean build, `project/logs/phase3-build-final2.log`;
  all six dylibs link with 0 original symbols missing).

## 3. Two-agent (and three-agent) module merges

Three binaries were reconstructed by more than one agent; their halves
must be merged against the agents' partition lists, not by eye:

- **AppBridge** = `src/AppBridgeA/` (host/lifecycle/channels) +
  `src/AppBridgeB/` (in-app side, keyboard/Telex, geometry). Overlap
  declarations are documented in `src/AppBridgeB/AppBridgeB_REPORT.md`
  §9 and in `ABHost.h`.
- **SplitScreen** = `src/SplitScreenA/` (251 methods: lifecycle, hooks,
  prefs) + `src/SplitScreenB/` (229 methods: layout/zoom/divider/picker)
  + `src/SplitScreenC/` (98 C functions: Home/icon injection family).
  A↔B partition is exact (251 + 229 = 480). B also left a `handoff/`
  folder of B-decoded A-owned methods — reconcile names there (e.g.
  C renamed A's placeholder `SCPChosenPhoneAppCount` →
  `SCPChosenPhoneAppInfos`).
- **SpeedBubble** = display side (REPORT_A sources) + source-app side
  (B sources) + two closure files (`SBScanHelpers.m`,
  style-geometry in `SPPBubbleView.m`). **Known duplicate to dedupe:**
  `__init_0` @0x44a8 + sub_45b4 exist in both A's `SPPDisplayBoot.m`
  and B's `SBOpenCar.m`; the evidence (no-op outside CarPlayApp;
  registers the dashboard-open handler) puts the canonical copy on the
  display side under B's own tie-break rule. Also apply the three
  `SBScan.m` contract edits listed in the scan-closure addendum
  (delete the `SPPCandidatesSummary` extern; correct the
  `SPPColorView` and `SPPScanPostCommit` comments) and the two
  verifier-#4 fixes (see `handover/RECOVERY_STATUS.md`, "Fix queue").

## 4. Build

```sh
export THEOS=~/theos
cd ~/workspace/omnicar-re/project
umask 022
make package FINALPACKAGE=1
```

**[CONFIRMED — phase 3]** — this exact invocation succeeds end-to-end
from a clean tree with the real sources (log:
`project/logs/phase3-build-final2.log`, exit 0, 0 errors, all 8
components).

Known failure modes on this VM (all already handled in the scaffold
Makefiles — listed so a regression is recognisable):

| Symptom | Cause / fix |
|---|---|
| `unrecognised emulation mode: llvm` at link | Theos picked GNU ld → every binary subproject carries `<Name>_LDFLAGS = -fuse-ld=lld`. |
| `llvm-lipo: error: … have the same architecture arm64` | clang-18 silently emits arm64 for the arm64e slice → `ARCHS = arm64` everywhere (see §7.1). |
| libc++ module failure at `include_next <stdint.h>` | Add `<Name>_USE_MODULES = 0` to the affected subproject (recorded contingency; the placeholder build did not need it). |
| dpkg-deb refuses the DEBIAN dir modes | Build under `umask 022`. |

## 5. Packaging (the shipped format is NOT Theos's raw output)

Theos/dm.pl emits **LZMA** compression. The deliverable DEB must be
repacked from the Theos staging tree with **xz**, the format this
project ships:

```sh
fakeroot dpkg-deb -b -Zxz <staging-tree> <output.deb>
```

(The scaffold artifact built this way:
`project/packages/com.anlai.omnicar_1.0.3-scaffold_iphoneos-arm64.deb`,
SHA-256 `6ec13c70…` — placeholder binaries, packaging proof only.)

Two mandatory pre-pack steps:

1. **Drop `Installed-Size` from the project `control`.** The verbatim
   copy carries the original's `Installed-Size: 6160`; dm.pl appends
   its own computed value, producing a duplicate field that
   `dpkg-deb -f` tolerates but `dpkg-deb -b` rejects. Theos always
   regenerates it — dropping the field loses nothing.
2. **Ownership/mode parity pass.** Originals are `root/wheel` (0:20);
   VM builds come out `root/root` (0:0), and some staging dirs inherit
   the workspace setgid bit. Under fakeroot before packing:
   `chown -R 0:20`, dirs 0755, plain files 0644, binaries 0755.
   This is not cosmetic: a payload with wrong uid/gid/mode has already
   shipped as a completely inert build once in this project's history
   (2026-11-07). Verify with a `dpkg-deb -c` listing comparison against
   the original DEB — not with hashes alone.

Sanity-check the finished artifact: `file <deb>` must show **xz**
control/data members.

## 6. Verify the build against the original

```sh
python3 project/tools/diff_payload.py <built.deb>
# defaults: --orig-deb input/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb
#           --orig-tree payload/
```

The harness compares: control fields field-by-field; the payload file
set; per-file SHA-256 (with a plist content-vs-serialisation
distinction for `.plist`/`.strings`); and per-Mach-O structural
fingerprints from the wave-1 parsers (slice architectures, ObjC
class-name set, deduplicated method count, defined-symbol set).
Byte-identical binaries are **not** required and are not expected
(layout differs); structural equivalence is the criterion.

Harness self-test (already run on the original vs itself): file set
176 = 176, all 13 control fields SAME, 168/168 resources byte-identical,
8/8 binaries BYTES EQUAL — so any diff it reports on a rebuilt package
is real.

Structural targets the final build must converge to
(from `metadata/COVERAGE_v1.md`):

| Binary | Classes | Methods (own classes) | Notes |
|---|---:|---:|---|
| OmniCar (app) | 1 | 6 | |
| OmniCarCore | 0 | 0 | 21 defined `_OMC*` symbols |
| OmniCarCarProbe | 0 | 0 | 20 defined `_OMC*` symbols |
| OmniCarAppBridge | 8 | 193 | |
| OmniCarSplitScreen | 11 | 480 | |
| OmniCarSpeedBubble | 9 | 277 | |
| OmniCarStartupScreen | 8 | 173 | |
| OmniCarPrefs | 29 | 743 | principal class `OMCRootListController` |

Plus the §5 `dpkg-deb -c` owner/mode comparison. **[PENDING FINAL
BUILD]** — record the final harness output and the parity listing in
the handover package next to the build log.

## 7. Known differences vs the original (expected, explainable)

1. **arm64-only vs FAT arm64+arm64e (PAC00).** Proven toolchain
   limitation of this VM: clang-18 silently degrades arm64e→arm64 and
   the universal merge fails (lipo error, scaffold build log 2). The
   Makefiles set `ARCHS = arm64` with an explanatory comment. Re-enable
   arm64e on a toolchain that truly emits it (real Xcode clang). The
   iPhone X test device is arm64, so device verification is unaffected.
2. **SDK skew.** Built against SDK 16.5 vs the original's 16.4 —
   expect cosmetic load-command differences only; the harness's
   class/method/symbol comparison is unaffected.
3. **`Installed-Size`** is Theos-recomputed from the staged payload;
   it will differ from the original's 6160.
4. **Ownership** is `root/root` until the §5 parity pass makes it
   `root/wheel` (0:20).
5. **Resources are byte-identical by construction**: all 168
   non-executable files were copied from the verified payload and
   SHA-256-checked against `inventory/manifest.tsv` — full list in
   `project/RESOURCE_PROVENANCE.md`. No original executable is copied:
   all 8 Mach-O files are rebuilt from `src/`.
6. **Code signature** will be the local ldid ad-hoc signature, not the
   original's signing identity (the originals carry code-signing
   strings naming their unsigned build artifacts, e.g.
   `OmniCarCore.dylib.1e69ddd5.unsigned`).

## 8. Confirmation checklist — ALL ITEMS CONFIRMED (Integration Phase 3, 2026-11-08)

- [x] Full clean-tree `make package FINALPACKAGE=1` log (success, all
      8 subprojects with real sources):
      `project/logs/phase3-build-final2.log` (exit 0, 0 errors).
- [x] The `OMC_MODULE_NAME` wiring of §2 in all six dylib subprojects.
- [x] The merges of §3 completed (incl. the SpeedBubble `__init_0`
      dedupe and the `SBScan.m` / verifier-#4 fix queue — applied in
      phase 2 and carried into the canonical `src/` in phase 3).
- [x] xz repack done (`dpkg-deb -Zxz`); control `Installed-Size` was
      NOT dropped but set to the computed payload size (3071) — the
      one deliberate deviation from the draft wording of this item,
      matching phase-2 practice; every other control field is
      identical to the original.
- [x] Ownership/mode parity pass applied: 202/202 entries, 0 diffs
      (modes + uid 501 + gid 20, compared numerically via tar).
- [x] Final `diff_payload.py` output: file set 176 = 176, resources
      168/168 byte-identical, 0 original defined symbols missing in
      every binary; method counts — App 6=6, AppBridge 193=193,
      CarProbe 0=0, Core 0=0, SpeedBubble 277→278 (+1 additive),
      SplitScreen 480=480, StartupScreen 173→175 (+2 helpers the
      original inlines), Prefs 743=743. Full output reproduced in
      `project/BUILD_PHASE3_LOG.md`.
- [x] Final rebuilt DEB: `project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb`,
      SHA-256 `9a593ed2649c2da95e703c81fa121e01116911cea6efea65b6a9d99b93537170`,
      933,260 bytes.
