# VERIFY_AppBridgeA — independent verification (A half: catalog / launch / channels)

Verifier: rolling verifier #1 (wave 2.5), 2026-11-08. Method: verifier's own
capstone disassembly of `OmniCarAppBridge.dylib` (arm64 slice); ground truth
from `verify/macho_truth.py` (LC_DYSYMTAB for stubs, hand-decoded selector
stubs, 0-based chained-fixups decode). The agent's dumps were used only to
locate what to check, never as evidence.

## The §2 tooling correction — CONFIRMED (one number wrong)

The wave-1 parser's 1-based bind decode (`imports[ordinal - 1]` in
`macho_objc.py::_import_name`) is real, and the report's three semantic
anchors hold independently: stub 0x242C0 **is** `_CFPreferencesCopyAppValue`
(LC_DYSYMTAB, fixup-independent — and `_OMCPref` at 0x1D680 calls it with
(key, domain)); global-block isa ordinal 179 = `__NSConcreteGlobalBlock`;
cfstring isa ordinal 180 = `___CFConstantStringClassReference` (both match
my parsed imports table exactly). The corrected superclasses in §2 also
match my decode 8/8 (ABBoxView/ABShieldView/ABKnobView → UIView,
ABBarButton/ABKey → UIButton, ABPane/ABHost/ABKeyboard → NSObject).
One inaccuracy: anchor 3's absolute index "imports[181]" does not match the
payload's chained-fixups imports table (there `_CFPreferencesCopyAppValue`
is index 57 and `_CFPreferencesAppSynchronize` is 56 — the *relative* −1
claim is right, the printed index belongs to some other enumeration).
Documentation slip only; the correction itself is correct and the module's
names check out everywhere.

## Headline claims

| Claim | Verdict |
|---|---|
| §0.1 No dashboard-library/catalog hooks, no picker UI in this binary | **CONFIRMED** — `newApplicationLibrary` / `ApplicationLibrary` absent from the string table; the lone `CARApplication` cstring (0x2A845) is referenced only inside `_OMCCarClass` (0x1E490), i.e. a class-name resolution, not a library hook; `DBApplication*` traces reduce to the disclosed launch-info factory. All 5 SpringBoard-ctor hook sites and the app-process ctor's registrations were enumerated independently (below) |
| §0.2 Eligibility decided only in `openApp:frame:` (empty id / feature off / no CarPlay display), no chosen-apps or entitlement check | **CONFIRMED** — gate sequence re-traced at 0xB8A0: `_OMCFeatureEnabled` (0xB8F8) → log `tat trong Cai dat -> khong host %@` (0xB99C) → `ensureWindow` (0xB9C0) → log `xe chua ket noi -> khong host %@` (0xBD28); failure also posts state (ABPostAppState) and logs `host %@ that bai: %@` on exception; success logs `host %@ tai %@ (huong %lld, zoom %.2f)` |
| §0.3 / §3 `appBridgeApps` does not exist; chosen-apps list not read by AppBridge | **CONFIRMED** — string absent from the full string table |
| §3 domain `com.anlai.omnicar` via CFPreferences | **CONFIRMED** — `_OMCPref` (0x1D680) = `_CFPreferencesCopyAppValue(key, domain-cfstring)` with csel default; `_OMCPrefsSync` (0x1D674) = tail-call `_CFPreferencesAppSynchronize(domain)`; domain cfstring at 0x37070 |
| §3 feature keys `enabled`, `<name>Enabled` | **CONFIRMED** — `_OMCEnabled` (0x1D6E8): `_OMCExpired` gate → `OMCPref(@"enabled")` → `boolValue`; `_OMCFeatureEnabled` (0x1D744): `_OMCEnabled` gate → `stringByAppendingString:@"Enabled"` → `OMCPref` → `boolValue`. Source in OMCCore.m is exact |
| §5 SpringBoard ctor hook table (5 rows) | **CONFIRMED, all five, instruction-exact** — ctor 0x6E08: `SpringBoard / applicationDidFinishLaunching:` repl 0x7004 orig slot 0x3E9F0; `SBSuspendedUnderLockManager / _shouldBeBackgroundUnderLockForScene:withSettings:` repl 0x72BC orig 0x3E9F8; `FBScene / updateSettings:withTransitionContext:completion:` repl 0x74B4 orig 0x3EA00; `SBSceneView / _updateReferenceSize:andOrientation:` repl 0x7764 orig 0x3EA08; `dlsym("BKSDisplayServicesSetScreenBlanked")` at 0x6F5C with repl 0x777C and orig slot 0x3EA10 loaded immediately after |

## Per-function verdicts (A scope, report §6)

**CONFIRMED by independent re-trace** (call sequence + constants + strings
compared against the submitted source):
`__mod_init_1` (0x6E08, see §5 above); `_OMCPrefsSync`, `_OMCPref`,
`_OMCEnabled`, `_OMCFeatureEnabled` (above); `_OMCHasMethod` (0x1E384:
`_OMCCarClass`, `hasPrefix:`/`substringFromIndex:` prefix parsing,
`NSSelectorFromString`, `class_getClassMethod`/`class_getInstanceMethod`);
`_OMCCarClass` (0x1E438); `_OMCCheckHooks` (0x1E580: spec parsing
`componentsSeparatedByString:` on `%@=%@` entries, `_OMCHasMethod` checks,
diag dict keys `total`/`missing`/`ios`, and the key-construction strings
`diagHooks.` + `%@%@@%@` — consistent with the report's INFERRED label for
the written key `diagHooks.AppBridge`); `_OMCCarLaunchInfo` (0x1EE50:
**zero in-binary call sites**, proven by exhaustive bl/b scan of `__text`;
`DBApplicationLaunchInfo` + `launchInfoForApplication:` strings present as
claimed); `ABHost +shared` (dispatch_once trampoline), `hostsApp:`
(enumeration + `isEqualToString:`), `paneFor:` (same scan, exercised via
`frameOfApp:`), `frameOfApp:` (`paneFor:` → `box` → `frame`), `zoom`
(clamp floor double at 0x2B210 = **0.6** exactly as claimed; percent/100
semantics match the `zoom %.2f` host log), `openApp:frame:` (above, incl.
`_OMCPrefsSync`/`_OMCPref` reads at 0xB9F8/0xBA0C and the 2.5 s
`dispatch_after` — constant piece `mov w1, #0xF900` at 0xBC48, i.e.
2,500,000,000 ns — posting `ready`), `ABPostAppState` (sub_BED4: posts
`com.anlai.omnicar/appbridge.state` via `postNotificationName:object:userInfo:`,
object nil), `bundleForHash:` (FNV-1a **exact**: prime built at 0xF47C
`mov w25,#0x193; movk w25,#0x100,lsl#16` = 0x01000193, basis at 0xF4D0
`mov w27,#0x9DC5; movk w27,#0x811C,lsl#16` = 0x811C9DC5, loop
`h=(h^byte)*prime` — source matches), `appWithHash:changedOrientation:supportedMask:`
(both log strings byte-exact: `apporient: khong co o cho hash %llu`,
`%@ doi yeu cau xoay (ma %d, mask %lu) -> scene huong %lld`;
`setRequestedOrientation:` then `effectiveOrientation:`), `postBarAction:from:`
(`paneOfBarButton:`, log `thanh nut %@: %@`, dict keys `identifier`/`action`,
name `com.anlai.omnicar/appbridge.baraction`), `barReplace:` (string
`replace` → `postBarAction:from:`; the other four wrappers are identical
16-byte trampolines with the claimed action strings), `closeAll`
(tail-pattern to `closeAllExcept:`), channel blocks **open** (0x783C:
`openApp:frame:` then appliers `setPassInsets:forApp:`,
`setBarVisible:pop:dim:single:forApp:`, `setHole:forApp:`,
`setCornerRadius:corners:forApp:`, `setHandleOffset:forApp:`,
`setFront:forApp:`, `setCarAppArea:`; keys `identifier/bar/pop/popDim/single/corners/front`;
@try/@catch with log `open loi %@\n%@`) and **frame** (0x8274:
`setFrame:forApp:live:handle:passInsets:` + same appliers; log
`frame loi %@`) — both match ABChannels.m and the §4 payload tables.

**DOWNGRADED — 1:**
- `carDisconnected` (0x163E8): report says "VERIFIED skeleton" and the
  skeleton is right (knobViews `makeObjectsPerformSelector:` +
  `removeAllObjects`, pane teardown, window dropped, log
  `xe ngat -> bo %lu o`). But the submitted source body loops
  `[self closeApp:…terminate:NO]` per pane, while the binary **inlines**
  the teardown (`teardownPane:`, `setHidden:`, `setWindow:`) with **no**
  per-pane `dong %@` log and **no** ABKeyboard hide. The source version
  would produce side effects the binary does not. Source body downgraded
  to **INFERRED** (skeleton confirmed, routing differs).

**Labels honest (not counted as verified claims):** `_OMCExpired`,
`_OMCLiteActive`, `_OMCCarWireless`, `_OMCCrashGuard` unit, log unit,
i18n/profile/perf units, `_OMCMissingSelector` are marked INFERRED/MAPPED
in both report and source; the one concrete constant the source does embed
for `_OMCExpired` (deadline 1809216000.0) is fenced as "(INFERRED value)"
in the source comment and §6 — treat it as unproven. `_ABMissingSelector`:
head VERIFIED / log tail INFERRED, as labelled. §7's NOT-RECOVERED list is
genuine: the comment-only `if (terminate) { … }` block in `closeApp:terminate:`
corresponds exactly to declared item §7.3 and contains no fabricated code.

**Minor documentation slips (no behavioural impact):** §2 anchor-3 index
(above); ABHostLaunch.m's closeApp comment cites "report §5" for a row that
lives in §6; the appWithHash source comment names the B-side continuation
`layoutPane:` where the binary's next call is `nudgePane:` (both are B
methods; the A source itself calls neither).

## Stub honesty

No STUB/TODO/FIXME markers in the five source files, and no fabricated
bodies: every function the report calls VERIFIED has a substantive body
that matches the binary per the traces above; every gap is declared in §7
and mirrored by comments (not code) in the source.

## Summary

A-scope table rows ≈ 38 / claimed-verified **28** / confirmed **27** /
downgraded **1** (`carDisconnected` source body → INFERRED) / wrong **0**
at function level (3 documentation slips listed) / undeclared-stubs **0**.
The remaining INFERRED/MAPPED rows (10) carry honest labels. B-scope bodies
(ABPane, ABKeyboard, hosting internals, ctor 0x44A8 handler bodies) were
not verified here — they are AppBridgeB's deliverable, and the A/B
partition in §1 matches the binary's class inventory (8 classes).
