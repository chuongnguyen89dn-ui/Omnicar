# BUILD PHASE 2 LOG — OmniCar 1.0.3 reconstruction, integration

Date: 2026-11-08. Scope: sync the completed `src/` reconstructions into
`project/`, resolve every phase-1 blocker/seam, produce a FULL clean
build of all 8 components, diff the payload against the original, and
package the rebuilt DEB. Per-module detail lives in
`logs/phase2-<module>.md`; this log is the aggregate record.

## Toolchain state (verified before building, and again at aggregate)

- `which clang-18` → /usr/bin/clang-18; `dpkg -l clang-18` → ii
  1:18.1.3-1ubuntu1. `which ldid` → /usr/local/bin/ldid (shim present).
  `readlink /usr/bin/ld.lld` → ld.lld-18 ✓. SDK iPhoneOS16.5 at ~/theos.
- Verdict: HEALTHY — `~/bin/fix-toolchain.sh` was NOT needed.
- All builds under `umask 022`, THEOS=~/theos, `make package
  FINALPACKAGE=1` for the aggregate (Version field is exactly `1.0.3`).
- Known structural difference (not a failure): VM clang-18 silently
  degrades arm64e→arm64, so all rebuilt binaries are arm64-only while
  the originals are FAT arm64+arm64e. Device target (iPhone X) is
  arm64; arm64e parity requires a toolchain that truly emits arm64e.

## Aggregate result

- Root `make clean` + `make package FINALPACKAGE=1`: **EXIT 0, zero
  errors**, all 8 subprojects compiled, linked, stripped, signed and
  staged (logs/phase2-aggregate2.log; the first aggregate run is
  logs/phase2-aggregate.log — identical except the StartupScreen
  accessor completion below landed between them).
- Per-component results (each also built standalone to PASS during the
  phase): OmniCarApp PASS (fingerprint exact), OmniCarCore PASS,
  OmniCarCarProbe PASS, OmniCarAppBridge PASS, OmniCarSpeedBubble PASS,
  OmniCarSplitScreen PASS, OmniCarStartupScreen PASS, OmniCarPrefs PASS
  (fingerprint exact).

## Seam resolutions (by brief item)

1. **OMCCommon** — shared unit `src/OMCCommon/` is authoritative and is
   what every consumer links (Core, AppBridge, SpeedBubble,
   StartupScreen, SplitScreen via OMCCommon.mk, per-module
   `-DOMC_MODULE_NAME`, `_OMCLogWrite` variant mechanism retained).
   AppBridgeA's OMCCore.m remains EXCLUDED from _FILES (wrong defaults
   NO / deadline 1809216000 vs the unit's YES / 1809104400). CarProbe
   does not link the unit (its file is the core TU). Prefs keeps its own
   OMCCommon.m (7 colliding symbols by design). Final synced checksums
   (src == project, verified at aggregate): OMCCommon.c
   md5 `cb8afa107945c29cc2bce1befb999feb`, OMCCommon.h
   `951b0e341f3ba79ff0d6f0802525d79e`, OmniCarCore.c
   `0745df2dd618343d559895fb90b33509`.
2. **Core re-check — BOTH deltas are REAL in the Core binary; both were
   src transcription drops, now fixed in src/OMCCommon/OMCCommon.c:**
   (a) sub_9814 session-stop teardown HAS the `if (gPerfSessionObject)`
   guard (0x9868 ldr / 0x986c cbz skips 0x9870–0x9984 to the diagCar
   tail) — fix: teardown wrapped in the guard, diagCar tail outside.
   (b) sub_9bc0 apply branch HAS the skip when `carProfileCurrent`
   isEqual: the new key (0xa6cc bl isEqual:, tbnz → name/lastSeen path,
   skipping the apply loop + log) — fix: existing-entry branch is now
   `else if (![currentKey isEqual:profileKey])`. Neither is a
   per-binary variant.
3. **AppBridge** — ABPane.m, completed ABKeyboard.m (755 lines) and
   ABHostBMethods.m all in _FILES. Zoom: src already carried the
   corrected floor **0.6** (@80 default, /100.0) — no edit needed; the
   0.3 survived only in the stale phase-1 project copy, overwritten by
   sync. ABMissingSelector.m verified (void return, format
   `@"THIEU METHOD: %@ khong co %@ -> bo qua"`) and added to _FILES.
   Basename clash resolved: B's constants TU is
   **ABChannelNames.m** in the project; A's handlers TU keeps
   ABChannels.m (all 14 ABChan* + 2 ABNotify* verified defined in the
   built dylib). Header visibility: phase-1 ABChromeViews.h sufficed
   (verified verbatim against the fresh in-file interfaces); no further
   extraction needed. ABHost's two @implementation blocks cannot both be
   plain implementations (proven: duplicate OBJC_CLASS/METACLASS/IVAR
   symbols on a toy build) → project copy of ABHostBMethods.m uses
   `@implementation ABHost (ModuleB)`, bodies verbatim; 8 selectors
   exist in both halves and B's bodies are effective under category
   precedence (flagged for adjudication — see gaps). carDisconnected
   keeps its INFERRED label (A's copy).
   **Closure pass (after the first AppBridge build): all 21 DECL_ONLY
   bodies reconstructed VERIFIED from the binary** — ABKey
   paint:/setHighlighted:/layoutSubviews (the key factory calls
   [key paint:NO]; these were comment-only) and 18 ABHost methods
   (ensureWindow … paneOfBarButton:), plus their helpers (ABCarDisplay,
   ABApplyAccent, ABMakeBarButton, ABSetBarButtonContent,
   ABResolveSelectorName, ABInvokeIdentityGetter, ABCheckCast, the
   pass-through hitTest IMP). Evidence-settled divergences:
   ABKey.accent is CAGradientLayer* (not BOOL); -buildBarForPane:
   returns UIView* (not void). dropWindowIfEmpty's IMP is a single
   `ret` — a genuine no-op, annotated.
4. **SplitScreen** — A+B+C merged flat. Perf-cluster hoist done in the
   project copy of SCPPerfTelemetry.m: `static` removed from
   OMCFlushPerfStats, OMCAutoLiteEvaluate and 32 shared state vars;
   SCPSessionCore.m's externs link (one rename:
   gStatMemPeakMB→gStatMemMB). Structural note: OMCCommon.c's own
   static copy of the sampler machinery coexists in the same binary
   without collision (_OMCCrashGuard binds to the static copy);
   dedupe is a coordinator decision, not taken. B's post-finisher files
   are in (Divider dismiss correction, SCPHomeWallView applySettings:
   block, RatioMenu glyph rewrite). Malformed QA20-era declarations at
   SCPCarSplit.h:237–242 REMOVED (selectors absent from 1.0.3).
   SCPCarSplit+Divider.m:32 fixed to `@(1.0 / 3.0)`. Name choice:
   **SCPKnobFaceView wins** — the binary factory @0x35cec loads style
   11 (SystemUltraThinMaterialLight), matching the Divider body;
   Chrome's SCPBlurEffectView (style 13) was deleted and all call sites
   unified. SCPIconModelClass is defined (SCPHooks.m); C's hook bodies
   de-static'd with unified Orig slots; SCPHomeApply declared. Header
   collisions: SCPCarSplit.h = A's interface (property sets verified
   identical) + pruned B categories; SCPCarPane.h = B's copy. Handoff
   folder not compiled, except -relayoutAnimated:/-relayoutAnimated:
   pushScenes: extracted into a new SCPCarSplit+Relayout.m (nothing
   else implements them). Link closure beyond the brief: 6 extern
   placeholders transcribed from fresh dumps into SCPShared.m
   (SCPMissingSelector @0x4f330, SCPInfoBool, SCPAppHasCarPlayUI,
   SCPAppIconForBundle, SCPResetDetachedView, SCPLayoutElementKey),
   6 name unifications, 3 census-UNCLAIMED Panel-called methods
   transcribed (exitKeepBundle/exitTapped:/atHomeScreen), signature
   corrections (favoriteApps:, afterPaneRemoved:, insertPaneAt:,
   soloBundle:), and an empty @implementation SCPCarPane added
   (accessors auto-synthesize; verified in the dylib).
5. **SpeedBubble** — SBOpenCar.m EXCLUDED from _FILES (pointer note;
   canonical constructor = SPPDisplayBoot.m). All phase-2 + micro-fix
   results synced (token globals, 3-arg _OMCMissingSelector + the 3
   added -sourceAppState log calls, SBScan contract edits, glow
   getters, bit-17 `limit>=0 ? 2:0`, 0xFFFF sentinel). Census @property
   completions in project copies, generated from objc.json: 54
   declarations (SPPBubble 31, SPPOverspeed 18, SPPGlassView 3,
   SPPIconView 2, +10 interface completions); SPPOverspeed ivar types
   aligned to the binary encodings. New project-only
   SBIntegrationTables.m defines SPPAppNames/BundleIds/ShortNames
   (values traced to SPPBubble.m + SBSourceGlobals.h; in the binary
   they are unnamed __objc_arrayobj constants). 12 `_OMC*→OMC*` alias
   defines added to SBIntegrationShims.h (A-side sources used Mach-O
   symbol spelling as C identifiers).
6. **StartupScreen** — placeholder replaced by the 5 real TUs.
   SSStartupViewBuilders.m supersedes 6 structural ss_build* bodies;
   SSStartupViewScenesB.m supersedes 6 more (ss_sceneColors,
   buildGreetingWithDate:period:, buildWeatherWithPeriod:, ss_gaugeAt:…,
   ss_buildEngine, ss_buildWelcome) — all 12 neutralised in the project
   copy of SSStartupView.m with naming comments, declarations retained.
   ss_applyEngine SUBSTITUTED with the corrected body (pure fractions,
   easeInOutCubic sweep, no *max, no 0.62/0.71; canonical owner =
   SSStartupView.m). One prose-vs-dump discrepancy resolved per the
   dump: the wobble term computes only for t > 2.3 (fcmp/b.le
   @0x141c4), not t ≤ 2.3 as the closure prose said. ss_addMote:
   replaced by the proven 56-byte record-by-value signature
   (SSMoteRecord{int64 kind; double f1..f6}) at declaration +
   implementation. Header nits fixed (@class forward; _stackMaxWidth
   retyped to NSArray<NSLayoutConstraint*>*, and ScenesB's buildWeather
   now actually stores the 4 constraints). Verifier-#6 fixes verified
   present (style+1 publish + consumer, 60.0 duration, numberOfLoops,
   ss_setGauge raw semantics, 1000.0/0.4 constants). OMCRealPath shim:
   OMCCommon keeps its libroot path layer static, so SSStartupScreen.m's
   project copy defines OMCRealPath with the core's verified
   dlopen/fallback semantics (the one new body in this subproject;
   delete if the core ever exports it).
   **Accessor completion (post-first-aggregate fix):** the first diff
   showed SSSplash at 11 method keys vs the original's 51 — the
   reconstruction declares the ivars but no @properties, so no
   accessors were synthesized. 20 @property declarations (verbatim
   from objc.json: window/style/imageView/startView/screen/framesDir/
   frameCount/fps/loop/buffer/decodeQueue/decoding/queuedFrames/
   shownFrames/failedFrames/startTime/displayLink/finished/endReason/
   shownAt) were added to SSSplash's @interface in the project copy of
   SSStartupScreen.h. Verified: SSSplash key set SET-IDENTICAL to the
   original (51=51), all 20 property attribute strings byte-identical,
   all 20 ivars identical (type/offset/size), instance_size 152=152.
7. **Prefs** — current src synced (56 files). Verified in source: hud
   is NSArray with the fill-once SSSampleHudItems logic (SSSampleHudItems
   defined, SSStartupView.m:191, 5-item body); ss_buildHud fallback
   line present; the 3 OMCStartupScreenController.m typos are FIXED
   IN SRC; _OMCSwitchColor = `[UIColor systemGreenColor]` tail-call;
   FeatureStartupScreen = 44 items and the project Resources plist is
   SHA-256-identical to the payload original. Prefs still does NOT
   take the shared unit. New link completions (project copies):
   frameworks += ImageIO/CoreImage/CoreVideo; `SSPrefsTrimmedString`
   defined using exactly the semantics its src header comment
   specifies (it was extern-only, defined nowhere in the repo);
   storage definitions for the 3 SPP audio globals
   (SPPSavedAudioCategory/Options, SPPActiveSoundCount — extern-only
   in src). Phase-1 fixes 21–27 (PSSpecifier imports, protocol lists,
   etc.) are STILL owed in src and were re-applied to project copies.
   BLOCKER-PREFS-OMCICON stands as a flagged assumption (3 calls
   completed with `, nil`; src carries no resolution).
8. **Census-driven gaps** — handled where they surfaced: SpeedBubble
   accessors (§5), SSSplash accessors (§6), SCPCTouchWatch needed NO
   additions (B's header declares both block properties; synthesis
   covers them), ABKeyboard/ABKey needed none (completed source
   declares all 16+8 properties in-file). Remaining census "unclaimed"
   rows are bookkeeping (see census section) unless a future link
   error proves otherwise.

## src/ edits made this phase (complete list)

- `src/OMCCommon/OMCCommon.c` — the two Core re-check corrections
  (§2a guard wrap, §2b isEqual: skip). No other src edits: the zoom
  0.6 correction turned out to be already present in src; the AppBridge
  closure wrote its 21 reconstructed bodies + helper functions into
  `src/AppBridgeB/ABKeyboard.m` / `src/AppBridgeB/ABHostBMethods.m`
  (module reconstruction, evidence in logs/phase2-appbridge.md) and
  settled ABKey.accent / -buildBarForPane: types in src headers.
  Everything else was project-copy work, logged per module.

## Diff vs original (tools/diff_payload.py, logs/phase2-diff.txt)

- Control fields: ALL SAME except Installed-Size (6160 → 3456;
  expected — the rebuilt payload is smaller: arm64-only binaries).
  Version exactly `1.0.3`.
- Payload file set: 176 original / 176 built / 176 common.
  **Non-Mach-O files: 168 of 168 byte-identical, 0 differing** (all
  resources ship byte-for-byte from the original, per
  RESOURCE_PROVENANCE.md).
- Mach-O fingerprints (classes orig→built, methods orig→built,
  defined symbols orig→built; **0 original defined symbols missing in
  every binary**):
  | Binary | Classes | Methods | Defsyms | Note |
  |---|---|---|---|---|
  | OmniCar (app) | 1→1 | 6→6 | 4→4 | exact |
  | OmniCarCore | 0→0 | 0→0 | 21→22 | +_kOMCPrefsDomain |
  | OmniCarCarProbe | 0→0 | 0→0 | 20→20 | exact |
  | OmniCarAppBridge | 8→8 | 193→200 | 38→73 | +7 = (ModuleB) category duplicates of the 8 shared selectors, counted separately |
  | OmniCarSpeedBubble | 9→9 | 277→278 | 46→99 | +1 extra method (hideIfShownWithReason:now:state:) from src as delivered |
  | OmniCarSplitScreen | 11→11 | 480→481 | 70→216 | +1 net; B's 8 category names counted as categories |
  | OmniCarStartupScreen | 8→8 | 173→175 | 41→151 | +2 = Builders helper extras (ss_festiveIcon:, ss_festiveLabelsWithTitle:…); selector-level 0 missing |
  | OmniCarPrefs | 29→29 | 743→743 | 100→112 | exact method count |
  Defsym surpluses are expected (originals are stripped; FINALPACKAGE
  strip keeps global symbols here) and are not behavioural claims.
- Arch: arm64+arm64e → arm64 everywhere (VM toolchain limit, above).

## Ownership / mode parity (dpkg-deb -c + tar-header audit)

Raw Theos staging carried mixed `0/root` and `0/65534` ownership
(the phase-1 bản-43 failure mode), so the final DEB was re-staged and
repacked explicitly. Tar-header audit of the FINAL artifact vs the
original: file set identical (202/202 entries), **mode diffs: 0**,
every rebuilt entry uid/gid **0:20** with uname/gname **root/wheel**.
(The original's own headers carry uid 501 — its build machine's user —
with root/wheel names; the rebuilt normalises uid to 0 per the phase-1
rule. Gid 20 and all modes match exactly.) Full listings:
logs/phase2-parity.txt. Cosmetic note: the final control tar has a
single `control` member (the original also carries a `.` dir entry);
control file content is identical apart from Installed-Size.

## Rebuilt DEB

- Theos artifact: `project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`
  (dm.pl output, control.tar.gz + data.tar.lzma).
- **FINAL deliverable** (same payload/control, ownership normalised,
  packaged with `dpkg-deb -Zxz` semantics — xz tar members assembled
  with explicit 0:20 root/wheel headers):
  [com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb](sandbox://workspace/omnicar-re/project/packages/com.anlai.omnicar_1.0.3_iphoneos-arm64-rebuilt.deb)
  **SHA256 `4ea9ca781541eef632b29468e130a60d4d015be2ffc1442b06c0bae7e77a1a34`**, 928,320 bytes,
  members: debian-binary, control.tar.xz, data.tar.xz. Validated with
  dpkg-deb -I/-c and by the diff run above.

## Coverage census re-run (metadata/tools/coverage_census.py)

Final src/ state (universe = 3,280 functions: 1,872 ObjC methods +
1,408 C functions). Claimed-once / stub / unclaimed per binary:

| Binary | Total | Claimed | Stub | Unclaimed |
|---|---|---|---|---|
| OmniCar | 9 | 6 | 0 | 3 |
| OmniCarCore | 103 | 76 | 0 | 27 |
| OmniCarAppBridge | 383 | 197 | 2 | 94 |
| OmniCarCarProbe | 82 | 52 | 0 | 10 |
| OmniCarSpeedBubble | 495 | 277 | 1 | 213 |
| OmniCarSplitScreen | 880 | 469 | 11 | 166 |
| OmniCarStartupScreen | 352 | 186 | 0 | 145 |
| OmniCarPrefs | 976 | 803 | 0 | 166 |

Movement vs the mid-reconstruction census: AppBridge claimed
148→197 (the 21 closure bodies + ABPane/ABMissingSelector),
SplitScreen 429→469, Prefs 801→803. The remaining "unclaimed" rows
are dominated by the two documented bookkeeping classes — C helper
functions whose behaviour IS reconstructed inside a host file but
without an address annotation binding them, and compiler-synthesised
`.cxx_destruct` methods — NOT by missing bodies; the link builds and
the per-binary fingerprints above are the functional evidence. Full
tables regenerated into metadata/FUNCTION_SOURCE_MAP.tsv and
metadata/COVERAGE_GAPS.md (run log: logs/phase2-census.log).

## Definitive remaining-gaps list (for the final recovery report)

STUB-UNRECOVERED bodies (explicit markers in source):
1. SplitScreen `SCPSceneOfVC` (sub_1ab70) — retained stub.
2. SplitScreen `sub_d324` (SCPDiagDump.m diagnostic tree walker) —
   retained stub.
3. SplitScreen `soloBundle:` — the real solo-exit body is NOT
   transcribed (A's body was a wrong-ABI INFERRED stub); project copy
   carries an explicitly marked STUB-UNRECOVERED with the dump
   reference.
4. AppBridge `ABSetBarButtonContent` glyph-drawing block @0x168B0
   (2,356 B of bezier geometry not transcribed — bar-button icons
   render blank; surrounding flow VERIFIED).
5. AppBridge `ABResolveSelectorName` (sub_D9B0): its three candidate
   NSArray constants are chained-fixup data, elements unrecovered
   (needle passed as sole candidate; hierarchy scan covers the rest).
6. AppBridge `setupLiveAppViewForPane:`: the `_currentMode` value
   object at __DATA 0x395D0 — single assignment omitted rather than
   guessed.
7. SpeedBubble constant arrays @0x3ce30 (mesh locations) and
   @0x3ce60 (font feature settings) — genuinely undecodable, marked
   STUB-UNRECOVERED.
8. StartupScreen `ss_applyMotes` — still decodes the legacy 48-byte
   structural record shape while the writers now emit the proven
   56-byte record; the real consumer core (sub_10d50) is UNRECOVERED
   (annotated in source).

INFERRED / adjudication-pending:
9. AppBridgeA `carDisconnected` body — INFERRED-labelled.
10. ABHost duplicate-selector pairs (8): +shared (A also initialises
    `panes`; B does not), carDisconnected (strategies differ),
    appWithHash:… completeness — BOTH halves preserved and compiled;
    B effective under category precedence. Needs a coordinator/
    verifier ruling on which reconstruction is authoritative.
11. SplitScreen `hostPassInsetsForPane:` — A's NSDictionary* body
    kept, B's header said UIEdgeInsets, the @0x3d1e4 dump shows
    geometry; needs its own adjudication.
12. SplitScreen SCPLayoutElementKey — true ABI is a BOOL predicate;
    A's display-layout hook fetches `identifier` inline; its dedupe
    logic remains A's INFERRED model.
13. SplitScreen↔Prefs: SCPPrefs `favorite:` dict shape in the Prefs
    subproject ({layout, apps, name}) diverges from the binary's
    ({name, left, right, third, layout}) — noted by the SplitScreen
    merge; belongs to the Prefs module.
14. SpeedBubble REPORT_A items 2–6 residues: numberColor full
    style×state matrix, applyColor: tail-branch discriminators, demo
    synthetic speed curve (helper sub_1a710), nine small layout
    helpers' roles (partly resolved), SPPPassThrough layout.
15. SpeedBubble SPPGlassView: the synthesized -corner getter reads
    `_corner`, which the custom INFERRED -setCorner: never writes
    (flagged, unverified in the binary).
16. Prefs BLOCKER-PREFS-OMCICON: 3 OMCIcon calls completed with
    `, nil` (assumption — if the originals passed a real color, the
    rendered icons differ).
17. Prefs: `SSPrefsTrimmedString` and the 3 SPP audio globals were
    extern-only in src and defined at integration (string helper per
    its own verified header-comment semantics). Phase-1 fixes 21–27
    and the SSSplash @property completion (§6) are applied in project
    copies but still OWED in src.
18. StartupScreen: inherited D11 `size: 3.0` label sites untouched;
    OMCRealPath is defined in the StartupScreen TU because the shared
    unit keeps its path layer static (delete if the core exports it).
19. SplitScreen perf machinery exists twice in the rebuilt binary
    (hoisted TU copies + OMCCommon.c's static twins) — no symbol
    collision and _OMCCrashGuard binds to the static copy, matching
    neither a proven dedupe nor a proven duplication in the original;
    coordinator decision pending.
20. arm64e: absent from every rebuilt binary (VM clang-18 limit).
    Behavioural equivalence is therefore claimed for arm64 only, and
    only to the extent of the static/structural checks above — NO
    device run has been performed in this phase.
