# BUILD PREP REPORT — OmniCar 1.0.3 reconstruction scaffold (wave 2.5)

Scope of this stage: project scaffold + payload-diff harness only. No feature
source was written and nothing under `src/<Module>/` was touched. All
placeholders are build scaffolding, explicitly marked, and are **not**
reconstruction results.

## 1. Toolchain — state found, actions taken

The VM had suffered another silent `/usr` rollback when this stage started:

| Check | At start | After fix |
|---|---|---|
| `which clang-18` / `dpkg -l clang-18` | missing | `/usr/bin/clang-18` (1:18.1.3-1ubuntu1) |
| `which ldid` | missing | `/usr/local/bin/ldid` (v2.1.4+16.g5b8581c + /tmp-signing shim) |
| `readlink /usr/bin/ld.lld` | missing | `ld.lld-18` |

Action taken: ran `~/bin/fix-toolchain.sh` (foreground, per the standing
recipe) — it reinstalled clang-18/lld-18/llvm-18/fakeroot via apt, restored
the `ld.lld` symlink and the ldid shim, and its built-in smoke test
(`clang-18 -fuse-ld=lld` compile+link) passed.

Build environment: Theos at `~/theos`, SDK `iPhoneOS16.5.sdk`,
`TARGET = iphone:clang:16.5:15.0` (original binaries: min iOS 15.0, SDK 16.4),
`THEOS_PACKAGE_SCHEME = rootless`, builds run with `umask 022` and
`make package FINALPACKAGE=1`.

## 2. Project layout (`~/workspace/omnicar-re/project/`, 203 files excl. `.theos/`)

Aggregate Theos project; master `Makefile` + `control` + `layout/` at the
root, one subproject per original binary:

| Subproject | Theos type | Builds | Reconstructed source plugs in from |
|---|---|---|---|
| `OmniCarApp/` | application | `OmniCar.app` | `src/App/` (main.m, OMCAppDelegate.h/.m) |
| `OmniCarCore/` | tweak | `OmniCarCore.dylib` + filter plist | `src/OMCCommon/` (Core = shared core + `_OMCTrustedTimeStart`) |
| `OmniCarAppBridge/` | tweak | `OmniCarAppBridge.dylib` + filter | `src/AppBridgeA/` **and** `src/AppBridgeB/` (two agents — see §5) |
| `OmniCarCarProbe/` | tweak | `OmniCarCarProbe.dylib` + filter | `src/CarProbe/` |
| `OmniCarSpeedBubble/` | tweak | `OmniCarSpeedBubble.dylib` + filter | `src/SpeedBubble/` |
| `OmniCarSplitScreen/` | tweak | `OmniCarSplitScreen.dylib` + filter | `src/SplitScreenA/` **and** `src/SplitScreenB/` (two agents — see §5) |
| `OmniCarStartupScreen/` | tweak | `OmniCarStartupScreen.dylib` + filter | `src/StartupScreen/` |
| `OmniCarPrefs/` | bundle (`/Library/PreferenceBundles`) | `OmniCarPrefs.bundle` | `src/Prefs/` |
| `OMCCommon/` | source-shared unit (not packaged) | — | `src/OMCCommon/` |

Plug-in contract per subproject: delete the placeholder `.m`, list the
module's reconstructed `.m`/`.c` files in `<Name>_FILES` in its Makefile.
Everything else (install paths, filters, resources, control) is already
final.

Layout decisions:

- **OMCCommon is an include/link unit, not a binary.** Wave-1 metadata
  evidence: the same OMC\* C core is statically compiled into every original
  dylib and no `OMCCommon` binary exists in the package. Consumers set
  `OMC_TARGET_NAME` and `include ../OMCCommon/OMCCommon.mk`, which appends
  `OMCCommon.c` to their `_FILES` and adds the include path — the core ends
  up statically linked into each binary, mirroring the original. (A static
  `.a` subproject is a drop-in alternative; it was not chosen because Theos
  library subprojects stage an installable artifact and the include model
  cannot accidentally add a file to the package.)
- **Filters**: each tweak dir holds the original `<Name>.plist` filter
  (byte copy); `instance/tweak.mk` stages it next to the dylib. Verified in
  the built deb.
- **Resources**: app Info.plist + icons in `OmniCarApp/Resources/`; the whole
  prefs-bundle resource tree (plists, PNGs, 14 `.lproj` dirs, 139 `.strings`)
  in `OmniCarPrefs/Resources/`; the PreferenceLoader entry plist in
  `layout/Library/PreferenceLoader/Preferences/`. 168 files copied, every
  SHA-256 re-verified against `inventory/manifest.tsv` during the copy —
  see `RESOURCE_PROVENANCE.md`.
- **control**: byte copy of the original `DEBIAN/control` at project root
  (all fields: package, version, arch, depends, conflicts, replaces, icon…).
  One interaction to know: the file contains `Installed-Size: 6160` and
  Theos/dm.pl appends its own computed value, so the *staged* control has a
  duplicate field. `dpkg-deb -f` tolerates it (the Theos deb reports the
  computed value); `dpkg-deb -b` rejects it. Recommendation for final
  integration: drop `Installed-Size` from the project control (Theos always
  regenerates it; no information is lost). Kept byte-exact in this stage per
  instructions; the xz repack below dedupes it.
- **Modes normalized at scaffold time**: copied resources were chmodded to
  0644 / dirs 0755 in the project tree (the VM payload extraction had left
  several at 0660, which on device would be unreadable by non-root
  processes). Built deb verified: plists/strings 0644, binaries 0755.

## 3. Payload-diff harness — `tools/diff_payload.py`

Usage: `python3 tools/diff_payload.py <built.deb> [--orig-deb …] [--orig-tree …]`
(defaults: the verified original deb + `payload/` tree).

It compares: control fields per field; payload file set; per-file SHA-256
(with a plist-content fallback: byte-different `.plist`/`.strings` are parsed
and reported as *serialization-only* vs *content* differences); and for every
Mach-O a structural fingerprint from the wave-1 parsers
(`metadata/tools/macho_scan.py` + `macho_objc.py`): slice architectures,
ObjC class-name set, method count (own classes + categories, deduplicated
across fat slices by (owner, kind, selector)), defined-symbol set.

Validation of the harness itself:

- **Self-test (original deb vs itself)**: file set 176 = 176, all 13 control
  fields SAME, 168/168 resources byte-identical, all 8 Mach-O BYTES EQUAL.
- **Fingerprint cross-check** against `metadata/COVERAGE_v1.md`: AppBridge
  8 classes / 193 methods, SplitScreen 11 / 480, SpeedBubble 9 / 277,
  Prefs 29 / 743 — exact matches, so the structural numbers it prints for a
  rebuilt binary are directly comparable to the coverage table.

## 4. Scaffold build — attempts and result

| Log | Outcome |
|---|---|
| `logs/scaffold-build-1.log` | FAIL at link: Theos used GNU `ld` ("unrecognised emulation mode: llvm"). Fix (standing recipe): `<Name>_LDFLAGS = -fuse-ld=lld` added to all 8 binary subprojects. |
| `logs/scaffold-build-2.log` | FAIL at universal merge — **the arm64e evidence**: `llvm-lipo: error: …OmniCar (arm64) and …OmniCar (arm64e) have the same architecture arm64`. This VM's clang-18 silently emits arm64 for the arm64e slice, exactly as previously recorded. Decision per stage instructions: `ARCHS = arm64` everywhere (with an explanatory comment in each Makefile); arm64e recorded as a known difference (§5). |
| `logs/scaffold-build-3.log` | FAIL fast: my own Makefile patch had put prose (with `:`/`()`) on the `ARCHS =` line, which make parsed as a rule. Fixed by moving the text into `#` comments. No toolchain involvement. |
| `logs/scaffold-build-4.log` | **SUCCESS** (after the mode normalization of §2): full aggregate `make package` — app, 6 tweaks, prefs bundle all compiled/linked/staged. Theos's raw output is kept at `logs/theos-lzma-output-2.deb`. |

Compression: dm.pl emits **LZMA** (same as the original deb, but not what
this project ships). The stage artifact was therefore repacked from the
Theos staging tree with `fakeroot dpkg-deb -b -Zxz`, using the finished
deb's control with the duplicate `Installed-Size` removed (kept value:
Theos-computed 1688):

- **Artifact**: `packages/com.anlai.omnicar_1.0.3-scaffold_iphoneos-arm64.deb`
  — `control.tar.xz`, data compression **xz**;
  SHA-256 `6ec13c70e8e2c5092b78d6f666585c4029a29e9b8baad6f058291f0d1ff63bc0`.

Harness result on the final artifact (`logs/diff-scaffold-final.txt`):

- File set: **176 built = 176 original, zero missing, zero extra.**
- Control: every field SAME except `Installed-Size` (6160 → 1688; Theos
  recomputes from the staged payload — placeholder binaries are far smaller
  than the originals).
- Resources: **168/168 byte-identical.**
- Mach-O: placeholders are structurally near-empty **by design** — each
  dylib exports exactly `_OMCCommonPlaceholderVersion` + its scaffold anchor
  (which proves the OMCCommon unit linked into every consumer), Prefs has
  its 1 placeholder class `OMCRootListController` (the original's principal
  class), the app has none yet. The per-binary original targets the final
  build must converge to are the COVERAGE numbers (App 1 cls/6 m,
  Core 0/0 + 21 defsyms, CarProbe 0/0 + 20, AppBridge 8/193, SplitScreen
  11/480, SpeedBubble 9/277, StartupScreen 8/173, Prefs 29/743).

## 5. Known differences and risks for the final build

1. **arm64e missing (toolchain limitation, proven — not a project bug).**
   Originals are FAT arm64+arm64e (PAC00); everything built on this VM is
   arm64-only because clang-18 degrades arm64e→arm64 (lipo evidence in
   build-2 log; previously recorded on 2026-11-06 for DuoFace builds).
   Effect: the rebuilt package will not be installable-equivalent on
   arm64e-only setups until rebuilt on a toolchain that truly emits arm64e
   (real Xcode clang or a fixed LLVM). iPhone X (the test device) is arm64,
   so device verification is unaffected. The Makefiles carry a comment
   saying exactly this where `ARCHS` is set.
2. **Two-agent modules must be merged by hand at integration.**
   `OmniCarAppBridge` takes sources from `src/AppBridgeA/` + `src/AppBridgeB/`
   and `OmniCarSplitScreen` from `src/SplitScreenA/` + `src/SplitScreenB/`.
   Risks: duplicate class/helper definitions across the halves, and the
   partition seam (each agent was told to list exactly which classes/methods
   it covered vs left — reconcile against those lists and against the
   harness's class/method counts, not by eye).
3. **Ownership metadata differs.** Built files are `root/root` (0:0);
   originals are `root/wheel` (0:20). Some staging directories can also
   inherit the workspace setgid bit (observed `drwxr-sr-x` on `var/`).
   Content and modes are right; for the final deb, add a pre-pack pass
   (under fakeroot: `chown -R 0:20`, dirs 0755) — a payload with wrong
   uid/gid/mode has already burned this project once (inert build, 2026-11-07),
   so the final harness run should be paired with a `dpkg-deb -c` mode/owner
   comparison, not hashes alone.
4. **`Installed-Size` in the project control** — see §2: drop it at final
   integration so dm.pl's appended value is the only one and a direct
   `dpkg-deb -b -Zxz` repack needs no dedupe step.
5. **Theos modules flag contingency**: if the reconstructed sources hit the
   clang-18 libc++ module failure seen on this VM before
   (`include_next <stdint.h>`), add `<Name>_USE_MODULES = 0` to the affected
   subproject (recorded fix, 2026-11-07). The placeholder build did not need
   it.
6. **Placeholder behaviors are non-functional by design**: the app
   placeholder calls `UIApplicationMain` with a nil delegate (black screen);
   the prefs placeholder loads the original `Root.plist` specifiers with no
   actions implemented; tweak placeholders export only an anchor symbol and
   install no hooks. The scaffold deb proves packaging, not behavior — it
   must not be treated as a test build for the car.
7. **SDK skew**: built against SDK 16.5 vs original SDK 16.4 — expect
   cosmetic load-command differences (SDK version fields) in the final
   structural diff; the harness's class/method/symbol comparison is
   unaffected.

## 6. Deliverables of this stage

- `project/` — aggregate Theos project (8 subprojects + OMCCommon unit +
  `layout/` + byte-exact `control`), placeholder sources clearly marked.
- `project/RESOURCE_PROVENANCE.md` — all 168 copied resources with SHA-256.
- `project/tools/diff_payload.py` — payload-diff harness (self-tested).
- `project/packages/com.anlai.omnicar_1.0.3-scaffold_iphoneos-arm64.deb` —
  Theos raw output kept at `logs/theos-lzma-output-2.deb`.
- `project/logs/` — build logs 1–4 and harness outputs
  (`diff-scaffold-1.txt`, `diff-scaffold-xz.txt`, `diff-scaffold-final.txt`).
