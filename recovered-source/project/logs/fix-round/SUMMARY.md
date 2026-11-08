# SUMMARY — fix round 2 finishing integration (E3), 2026-11-08

## Build
- Toolchain: clang-18 18.1.3, ldid shim → ldid-real
  2.1.4+16.g5b8581c, /usr/bin/ld.lld → ld.lld-18,
  iPhoneOS16.5.sdk present. fix-toolchain.sh NOT needed.
- Clean build (`make clean` + `make package FINALPACKAGE=1`,
  umask 022): **exit 0, 0 `error:` lines** (`build.log`).
- Raw DEB: com.anlai.omnicar_1.0.3_iphoneos-arm64.deb,
  949,390 B, SHA-256
  e44efdfb77f9fc201cec33512056a78ed60df2009ce043cdd4a151f77dd3bfeb
  (superseded by the parity-restaged candidate below; its
  staged payload is byte-identical to the candidate's).

## Per-class parity (`perclass.txt`)
- **62/66 classes exact, 0 classes missing any selector.**
- Prefs 743→745, OMCAppBridgeAppsController 105=105,
  SplitScreen 480=480, AppBridge 193=193.
- The 4 exceptions are the same additive-only deltas as prior
  rounds (SPPBubble +1, SSStartupView/StartupScreen +2,
  OMCSplitScreenController +1, SSStartupView/Prefs +1).

## Aggregate diff (`diff.txt`, against the candidate DEB)
- Files 176 = 176; non-Mach-O **168/168 byte-identical**;
  **0 original defined symbols missing** in any binary.
- Only control diff: Installed-Size 6160 → 3528 (computed).

## Hook count (`hookcount.txt`)
- Exactly ONE host installer: `_ABInstallSpringBoardHooks`
  @0x12b24 with **4× MSHookMessageEx + 1× MSHookFunction**;
  the ctor @0x1be58 calls it and has 0 direct sites.
- In-app installer (separate, expected): 13× MSHookMessageEx.
- ABChannels dead copies **ABSENT** from the binary: total
  __text sites 17+1, down from the hotfix build's 21+2.

## Static checks (`static-checks.txt`) — all PASS
- (i) PASS — one live installer definition; ABChannels MSHook
  calls all inside #if 0 (372–411).
- (ii) PASS — no `, NULL)` MSHook calls in live AppBridge code
  (remaining `, NULL)` hits are Telex classifier calls).
- (iii) PASS — `elided` grep over src/ = 0.
- (iv) PASS — unblank handler non-empty; closeApp:terminate:
  terminate branch contains the FBSSystemService call.
- (v) PASS — FPS setters on the instance class, only
  +displayLinkWithTarget:selector: on the metaclass.
- (vi) PASS — pid read is the typed objc_msgSend send, not
  SCPGuardedSend.
- (vii) PASS — no variadic OMCLogWrite declaration (only
  declaration is the 2-argument form, OMCCommon.h:111; raw
  `...` hits are comments / a macro / a doc note).
- (viii) PASS — OMCRescueAnnounce has all six full Vietnamese
  literals; no @"O"/@"C" single-letter literals.

## Harness
- `harness/results.txt`: **274 assertions, 0 failures — PASS**
  (pre-existing E2 evidence in this directory, cited).

## UUID findings (`uuid-manifest.txt`)
- Original AppBridge arm64: 81ef5920-bb7a-37e8-b953-d88453f2ea89
- FAT hotfix AppBridge arm64: c1d34cc2-62c6-3b11-97e4-9317a7951558
  → **NO MATCH** with crash-log UUID 4c4c4461-5555-3144-a17f-f759d99c2ab7.
- 93cdcad9… search: **FOUND** — 4 SHA-verified identical copies
  of the round-2 rebuilt DEB in clone checkouts
  (push3-clone, push4-clone, push5-clone, final-fresh-check,
  each `recovered-source/project/packages/...-rebuilt.deb`).
  Its AppBridge arm64 UUID = 4c4c4461-5555-3144-a17f-f759d99c2ab7
  → **MATCH** with the crash-log UUID. The .ips files belong
  to the round-2 build, not the FAT hotfix build.
  (A backgrounded first sweep returned a garbled pointer to an
  unrelated file; it was discarded and the search re-verified
  in the foreground over 3,575 workspace .deb files.)
- This build (candidate) AppBridge arm64:
  4c4c4413-5555-3144-a192-3f49022cb8b1

## Candidate DEB (Step 4)
- `project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb`
  — the only file in project/packages/.
- **948,844 B, SHA-256
  d1502121ffe13a7b49c275db841d9b586a5458dfc53d86ab30f9703724ebe4ef**
- Parity restage: `dpkg-deb -Zxz`, Installed-Size 3528,
  data tar **202/202 entries, 0 differences** in
  mode/uid/gid/type (audit normalised for the `./`-prefixed
  tar name form dpkg-deb emits, the same form as every prior
  rebuilt DEB; per-entry values identical).
- Packaging note: the raw DEB and the two ancient
  scaffold/debug DEBs were removed from project/packages/ so
  it holds only the candidate, per the work order.

## Docs
- `handover/PATCH_NOTES.md` (new): 11,120 B.
- `handover/RECOVERY_STATUS.md` §10 appended: 44,450 → 48,629 B.
- Staging README fix-round-2 paragraph + staging refresh:
  see the staging tree (counts in the E3 report).

## Status
- **DEVICE_TEST = PENDING.** No device run this round.
