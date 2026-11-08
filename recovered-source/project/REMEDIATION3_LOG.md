# Hotfix integration log (2026-11-08)

Scope: integrate the device-crash hotfix (AppBridge hook
originals wired, duplicate host installer removed, registrar
completed) plus the external review's round-2 source items
(OMCHasMethod signature, CADisplayLink hook targets, PID
read, closeApp:terminate: tail) into `project/`, rebuild
clean, re-verify per class, run the new hook-install count
check, restage with parity, update the handover documents,
refresh the publication staging tree.
Evidence files: `project/logs/hotfix-build.log`,
`project/logs/hotfix-perclass.txt`,
`project/logs/hotfix-diff.txt`,
`project/logs/hotfix-hookcount.txt`.

## 1. Toolchain

Verified before building: clang-18 18.1.3, ldid
2.1.4+16.g5b8581c (shim), `/usr/bin/ld.lld -> ld.lld-18`,
iPhoneOS16.5.sdk present. No rollback damage;
`~/bin/fix-toolchain.sh` not needed.

## 2. Sync src/ → project/

Preliminary pass had already synced the AppBridge host
hotfix (`AppBridgeEntry.m`, `ABHostGeometry.m`,
`ABChannels.m`, diff-verified). This pass synced the four
review-round-2 fixer files, each verified byte-identical
with `cmp` after copying:

- `src/AppBridgeB/AppBridgeB.h` → `project/OmniCarAppBridge/`
  (OMCHasMethod selector arg now `NSString *`)
- `src/AppBridgeB/ABInApp.m` → `project/OmniCarAppBridge/`
  (call site passes the NSString selector; CADisplayLink
  FPS setters hooked on the instance class, metaclass only
  for `+displayLinkWithTarget:selector:`)
- `src/AppBridgeA/src/ABHostLaunch.m` →
  `project/OmniCarAppBridge/` (closeApp:terminate: tail
  restored from the full method dump)
- `src/SplitScreenA/SCPSpringBoardHooks.m` →
  `project/OmniCarSplitScreen/` (pid read restored to the
  original's typed inline guarded send)

## 3. Clean build

`make clean` + `make package FINALPACKAGE=1`
(THEOS=~/theos, umask 022): **exit 0, 0 `error:` lines**,
all 8 components staged. Raw DEB
`com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`: 948,880 B.
Log: `logs/hotfix-build.log`.

## 4. Per-class verification (66 classes)

62/66 classes have identical selector sets; **zero classes
are missing any original selector**. The 4 exceptions are
the same built-side additive-only deltas as rounds 1–2
(SPPBubble +1, SSStartupView/StartupScreen +2,
OMCSplitScreenController +1, SSStartupView/Prefs +1).
OMCAppBridgeAppsController: **105 = 105** (explicitly
re-checked). Per-binary method totals: App 6→6, AppBridge
193→193, SplitScreen 480→480, StartupScreen 173→175,
Prefs 743→745. Full table: `logs/hotfix-perclass.txt`.

Aggregate diff (`diff_payload.py`, final restaged DEB):
files 176 = 176; non-Mach-O files **168/168
byte-identical**; 0 original defined symbols missing in
every binary. Record: `logs/hotfix-diff.txt`.

## 5. Hook-install count (new check)

Capstone count of MSHookMessageEx / MSHookFunction call
sites inside constructor extents of the built
OmniCarAppBridge.dylib (bounds from LC_FUNCTION_STARTS;
stubs resolved via `__la_symbol_ptr`; original counted the
same way via `__init_offsets` + `__got`, its MSHookFunction
call being a tail call):

- **Original** (ctor @0x6E08): 4 + 1 — host group once.
- **Pre-hotfix built** (round-2 DEB): two ctors
  (@0x42b0, @0x1bdc4) at 4 + 1 each — host group **twice**;
  `__mod_init_func` had 4 entries.
- **This build**: one ctor (@0x1cec4) at 4 + 1 — host
  group **once**; `__mod_init_func` has 3 entries. The
  disabled tree-A installer remains in `__text` as dead
  code (total `__text` bl sites unchanged, 21 + 2) but is
  no longer a registered constructor.

Record: `logs/hotfix-hookcount.txt`.

## 6. Parity restage + repackage

Phase-3 recipe (per-path modes from the original, payload
chown 501:20, Installed-Size from `du -sk` = 3524, control
from the original with Installed-Size replaced,
`dpkg-deb -Zxz`):

- Data tar: **202/202 entries, 0 differences** in
  mode/uid/gid/type vs the original.
- Control tar ownership normalised to 0:0 by dpkg-deb —
  the accepted deviation recorded since phase 3.
- **Rebuilt DEB: 949,028 B, SHA-256
  `ff4c9e7e7901e071b1897d0e8572f0f2c56d986888018219d2704fe327666798`**
  (supersedes round-2 `93cdcad9…`, 947,056 B).

## 7. Documents

- `handover/RECOVERY_STATUS.md`: section 9 appended
  (append-only; §§1–8 untouched). File is now 44,450 B
  (was 37,985 B); truncation-marker count 0; tail verified.
- Staging `README.md`: "Hotfix (2026-11-08)" paragraph
  added after the round-2 section with the new DEB SHA.

## 8. Staging refresh

Staging (`~/workspace/omnicar-push/recovered-source/`)
refreshed per component from the final omnicar-re tree
(`.theos` excluded; `project/packages/` contains only the
final rebuilt DEB): **4,777 files, 75,863,274 B** (count
includes this log). Tree-wide truncation-marker sweep over staging:
**empty**.

## 9. Open items (coordinator)

- Push the hotfix commit.
- Device retest, startup-first: install the hotfix DEB,
  respring, confirm SpringBoard stability, then run the
  acceptance groups. The causal link between the fixed
  defects and the four acceptance crashes is the leading
  explanation, not yet proven.
