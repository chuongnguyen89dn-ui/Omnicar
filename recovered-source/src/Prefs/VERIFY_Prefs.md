# VERIFY_Prefs — independent verification of Prefs_REPORT.md (Agent A scope)

Verifier #2 (wave 3), 2026-11-08. All evidence re-derived from the original
binary `OmniCarPrefs` (payload) with the verifier's own capstone pass +
0-based chained-fixups resolver (`verify/macho_truth.py`). Nothing was
taken from the module agent's dumps.

**COUNTS: claimed-verified (A scope) = 7 classes / 100 methods + 42 C
functions, all tagged VERIFIED | headline claim-groups independently
checked = 14 | confirmed = 12 | downgraded = 0 | wrong = 2 |
undeclared stubs found = 0.**

## Confirmed (firsthand)

1. **Expiry computation — every sub-claim exact.** `_OMCExpired` @0x54bb0
   (252 B, my own disassembly): expired iff
   `max(now, trustedTime) >= deadline`; `trustedTime` read via
   `CFPreferencesCopyAppValue(@"trustedTime", @"com.anlai.omnicar")`,
   NSNumber-checked, `fcsel` max; positive result latched in a static
   byte (recomputed while false). Deadline block (dispatch_once invoke
   @0x55694 — the exact address the report names): literal
   `@"2027-04-30"`, `NSDateFormatter` with locale `en_US_POSIX`,
   `timeZoneForSecondsFromGMT:` **25200** (GMT+7), format `yyyy-MM-dd`,
   then `fadd` of the `__const` double at 0x66560 = **86400.0** →
   expiry instant 2027-05-01 00:00:00 GMT+7. Fail-open when the parsed
   deadline ≤ 0, as reported.
2. **`_OMCEnabled`** @0x18c50: expired → NO; else pref `enabled`,
   nil → YES. Exact.
3. **Specifier sources.** Payload plists parsed directly: Root.plist =
   **15 items** with the reported structure (rescueGroup/rescue button,
   conflictsGroup/conflictsRow, APPS group + links to
   OMCAppBridgeAppsController with cellClass OMCAppBridgeAppsLinkCell
   and OMCHomeScreenController, empty FEATURES group id `features`,
   PROFILES link, SUPPORT + showGuide/whatsNew, DEV + sendLog).
   Feature plists carry `featureOrder` **10 / 20 / 30**
   (StartupScreen / SpeedBubble / SplitScreen) as claimed. The 16
   plist-declared keys reconcile exactly (14 in FeatureStartupScreen +
   the two feature `*Enabled` switches).
4. **Preference-key table — 12 keys xref'd with my own scanner**
   (cfstring/cstring VA → adrp/add refs → enclosing function):
   `enabled` (read _OMCEnabled, written -[masterToggled:]),
   `trustedTime` (read _OMCExpired only), `language`
   (_OMCCurrentLanguage / -[setLanguage:]), `rescueFeatures`
   (_OMCRescueFeatures / _OMCRescueRestore), `rescueDate`
   (_OMCDiagSections + _OMCRescueRestore; **also** read in
   _OMCDiagChecks — one read site more than A's table lists, an
   undercount, not an error), `appBridgeApps` (read inside
   -[OMCAppBridgeAppsLinkCell refreshCellContentsWithSpecifier:] —
   the ref sits in an interior function-start chunk of that method;
   written by B's -[OMCAppBridgeAppsController storeChoices]),
   `diagCar` (DiagSections/DiagChecks/ShareReport), `diagPerf`
   (DiagChecks/ShareReport), `diagLastCrash` (_OMCDiagChecks — the read
   the calibrated PREFS_MAP misses is real; A's evidence stands),
   `splitScreenEnabled` (direct refs only in B's controller, consistent
   with A's featureKey indirection), `splitScreenLastLeft`,
   `com.anlai.omnicar/prefschanged` (11 posting functions incl.
   _OMCRescueRestore and -[masterToggled:]).
   **`setLanguage:` does NOT post prefschanged — confirmed by absence**
   (it references `language` + the domain, never the notify name).
5. **Per-car profile keys: 14/14 exact.** The `_OMCProfileKeys` constant
   array decoded from `__objc_arraydata` @0x7f6a0 matches the report's
   list verbatim (splitScreenLastLeft … appBridgeZoom).
6. **Conflicts rule table: exact.** Arraydata @0x7e9f0 =
   CarBridge/carbridge, DuoDash/duodash, TrueDash/truedash,
   CarPlayEnable/carplayenable. Supporting arrays also verified:
   car-name keys [modelName, name, vehicleName, accessoryName, model],
   manufacturer keys, loader ids (ellekit, mobilesubstrate,
   com.opa334.libhooker, org.coolstar.libhooker, com.ex.substitute),
   nav-app names + bundle ids, killall paths — all as reported in §6.
7. **`_OMCRescueRestore` @0x7af8 — instruction-level match:** iterates
   _OMCRescueFeatures, writes `<feature>Enabled` via
   CFPreferencesSetAppValue, deletes `rescueFeatures` and `rescueDate`,
   CFPreferencesAppSynchronize, notify_post(prefschanged) @0x7c38.
8. **Stub honesty:** no `STUB` markers needed and none hidden — a scan
   of A's six hand-written files finds **zero** one-line constant-return
   bodies. The two declared caveats are genuinely marked in source
   (OMCCardColor's unrecovered hex constants at OMCCommon.m:285–295;
   DiagChecks threshold note). 0 undeclared stubs.

## Wrong (route back to the Prefs agent)

W1. **FeatureStartupScreen.plist item count.** Report §2 says
   "(40 items, statically declared)". The payload plist has **44
   items**. (The class→plist assignment itself is correct.)

W2. **`_OMCSwitchColor` reconstruction is wrong in address and body.**
   Source (OMCCommon.m:296–297) claims `0x1806c`, "12-byte tail-call
   into accent colour path", body `return OMCAccentColor();`.
   Truth: the symbol `_OMCSwitchColor` is at **0x17fd8**, is in
   LC_FUNCTION_STARTS, and is a 12-byte tail-call to
   `[UIColor systemGreenColor]` (adrp classref UIColor; b
   selstub systemGreenColor). 0x1806c is not a function start — it is a
   `colorWithWhite:alpha:` call site inside an unnamed function at
   0x1800c. The [VERIFIED] tag on this body must be removed and the
   body replaced. Blast radius: grep shows the error did NOT propagate
   to src/OMCCommon, src/SpeedBubble or src/SplitScreen* — it is
   confined to the Prefs copy of the shared core.

## Not verified

- Prefs-B (22 classes / 637 methods): **PrefsB_REPORT.md does not exist
  yet**, so the conditional B verification could not run. In particular
  the `appBridgeApps` element encoding (A defers it to B's controller)
  remains unverified; my xref confirms B's `storeChoices` is the writer
  and A's LinkCell the counter, nothing more.
- A's call-graph-level (not instruction-level) items — applySupportState
  internals, OMCHeaderCard drawing, Diag threshold ladders — were taken
  as honestly graded by A and not re-derived.
