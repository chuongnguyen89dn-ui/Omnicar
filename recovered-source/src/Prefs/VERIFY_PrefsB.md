# VERIFY_PrefsB — independent verification (verifier #4, wave 3)

All disassembly below is my own (capstone 5.0.7 over the arm64 slice of
`payload/.../OmniCarPrefs.bundle/OmniCarPrefs`), names resolved only
through `verify/macho_truth.py` (0-based). No agent dump was used as
evidence.

**Counts: headline claims spot-checked 6 | confirmed 5 | wrong-in-part
1 (app-picker delayed block) | appBridgeApps format confirmed |
superclasses 22/22 MATCH | downgraded 0 | undeclared stubs 0.**

## (a) `appBridgeApps` storage format — CONFIRMED

The pref holds a **plain `NSArray` of `NSString` bundle identifiers** —
no per-element dictionary, encoding or wrapping (contrast
`homeScreenCarApps`, which is an array of {id,name,off} dicts).

- Write — `-[OMCAppBridgeAppsController storeChoices]` @0x1e920 (my
  dump): builds an NSMutableArray; fast-enumerates the phoneApps ivar
  (array of app dicts); for each dict takes `objectForKeyedSubscript:`
  with the cfstring @0x753e8 = **"id"**; if the chosen set (ivar at
  ivar-offset slot 0x8ee74) `containsObject:` that id, the id string
  itself is `addObject:`-ed; the array is then written via the shared
  write helper sub_1cda0 with key cfstring @0x76928 =
  **"appBridgeApps"**. Same function writes the hidden/shown sets
  (sorted with `compare:`, selref @0x8c388 resolved) under
  "homeScreenHiddenApps" (@0x79208) / "homeScreenShownApps"
  (@0x79228) — all exactly as in B's `storeChoices`.
- Read — helper sub_1b510 (called from `loadState` @0x1cde8; result
  feeds `+[NSMutableSet setWithArray:]` into the same chosen ivar):
  `CFPreferencesAppSynchronize("com.anlai.omnicar")`, raw copy of key
  "appBridgeApps" via sub_1cd84, `objc_opt_isKindOfClass` against
  classref @0x8e960 = **NSArray** (slot_truth), falling back to the
  `___NSArray0__struct` empty-array singleton (GOT @0x741a0) when the
  stored value is not an array.
- B's report §3 line ("array of ids, written by storeChoices") and the
  `OMCAppBridgeAppsPref()` / `OMCPrefArray(@"appBridgeApps")` usage in
  the source are accurate.

## (b) Superclasses of all 22 B classes — 22/22 MATCH

I decoded every class struct in OmniCarPrefs myself (classlist ->
struct +8, bind names stripped of `_OBJC_CLASS_$_`, rebase targets
named via the class RO). The full 29-class truth table reproduces
ANNOTATION_AUDIT's addendum / SUPERCLASS_SWEEP values; for B's 22:

| Class | Binary truth | B declares | |
|---|---|---|---|
| OMCAppBridgeAppsController | PSViewController | PSViewController | ✓ |
| OMCStartupScreenController | OMCFeatureListController | OMCFeatureListController | ✓ |
| SSStartupView | UIView | UIView | ✓ |
| OMCSpeedBubbleController | OMCCardPage | OMCCardPage | ✓ |
| SPPBubbleView | UIView | UIView | ✓ |
| OMCOnboardingController | UIViewController | UIViewController | ✓ |
| OMCSplitScreenController | OMCCardPage | OMCCardPage | ✓ |
| OMCHSPreview | UIView | UIView | ✓ |
| OMCCarProfilesController | PSViewController | PSViewController | ✓ |
| OMCSplitScreenAppPickerController | PSViewController | PSViewController | ✓ |
| SSFade | NSObject | NSObject | ✓ |
| SSGauge | NSObject | NSObject | ✓ |
| OMCSSStyleTileCell | UICollectionViewCell | UICollectionViewCell | ✓ |
| OMCWhatsNewController | UIViewController | UIViewController | ✓ |
| SPPIconView | UIView | UIView | ✓ |
| OMCSplitPreview | UIView | UIView | ✓ |
| SPPGlassView | UIView | UIView | ✓ |
| SPPSignView | UIView | UIView | ✓ |
| SPPSoundDelegate | NSObject | NSObject | ✓ |
| SSLinkTarget | NSObject | NSObject | ✓ |
| SSCanvasView | UIView | UIView | ✓ |
| OMCHomeScreenController | OMCAppBridgeAppsController | OMCAppBridgeAppsController | ✓ |

None of the 18 wave-1-corrupted superclass names survives in B's
source. (Method-count reconciliation, for the record: PARTITION_B's
637 = instance methods; B's final per-class figures sum to 643 =
637 + the 6 class methods, and 100 A + 637 + 6 = 743 total. Consistent.)

## (c) Six headline claims spot-checked

1. **App picker: dynamic-key write + 250 ms delayed pop —
   CONFIRMED except one WRONG detail (phantom second write).**
   `-[OMCSplitScreenAppPickerController tableView:didSelectRowAtIndexPath:]`
   @0x37444 (my dump): key = `[[self specifier] propertyForKey:@"key"]`
   (@0x76fc8), guarded by an NSString kind check; value = the row's
   `rowsInSection:` dict's `@"id"` (or nil for section 0); written by
   sub_37698 = B's `SSPickSetPref` (`CFPreferencesSetAppValue` +
   `CFPreferencesAppSynchronize`, domain `com.anlai.omnicar`);
   `notify_post("com.anlai.omnicar/prefschanged")` (cstring @0x611b1);
   reloadData + the parent `reloadSpecifier:` dance via
   NSSelectorFromString — all as B reconstructs. The delayed block is
   scheduled with `dispatch_time(0, 0x0EE6B280)` — w1 built as
   `mov #0xb280; movk #0xee6, lsl #16` = **250,000,000 ns = 250 ms**
   ✓ — and `dispatch_after` on the main queue (GOT @0x7403a0).
   **But the block invoke @0x37714 does ONLY
   `popViewControllerAnimated:YES`** on the one captured object (the
   controller, block field +0x20): no `SSPickSetPref`, no kind check,
   no second capture for key/value. B's source
   (OMCSplitScreenAppPickerController.m lines 217–222) adds a second
   `SSPickSetPref(key, value)` inside the block and comments "The
   binary writes the value a second time after 250 ms and pops" —
   **the binary writes exactly once**. Fix: delete the
   `if ([value isKindOfClass:[NSString class]]) SSPickSetPref(key,
   value);` line inside the dispatch_after block and correct the
   comment (250 ms delay applies to the pop only).

2. **SpeedBubble warnMode v1->v2 migration — CONFIRMED.**
   In `-[OMCSpeedBubbleController viewDidLoad]` @0x25bd4 (my dump):
   `prefForKey:@"speedBubbleWarnModeV2" def:false` -> boolValue;
   `tbnz` skips the whole migration when true. Otherwise
   `prefForKey:@"speedBubbleWarnMode" def:nil` -> integerValue,
   `cmp #2; b.ne` skips unless == 2, then
   `CFPreferencesSetAppValue("speedBubbleWarnMode", @0x802b0,
   "com.anlai.omnicar")` — @0x802b0 is an NSConstantIntegerNumber
   whose value field I read as **3** — then SetAppValue of
   "speedBubbleWarnModeV2" = kCFBooleanTrue and
   `CFPreferencesAppSynchronize`. Keys resolved from cfstrings
   @0x7a168/@0x7a188. Exactly B's reconstruction (old 2 -> 3, V2 flag
   set, one-way).

3. **StartupScreen frame extractor — CONFIRMED.**
   `-[OMCStartupScreenController extractFramesForVideo:error:progress:]`
   @0x41cc4 (my dump): `AVAssetReader assetReaderWithAsset:error:`,
   track-output settings dictionary built @0x41f1c–0x41f3c as
   { kCVPixelBufferPixelFormatTypeKey : intobj @0x80418 } where the
   `__objc_intobj` entry @0x80418 holds **1111970369 = 0x42475241
   ('BGRA')** ✓; duration capped by `fminnm` against the double
   60.0 (`mov x8, #0x404e000000000000`) and wrapped with
   `CMTimeMakeWithSeconds(..., 600)` + `CMTimeRangeMake` ✓ ("first
   min(duration, 60) s"); the final info dictionary @0x42384–0x423ec
   is `dictionaryWithObjects:forKeys:count:3` with keys resolved as
   **fps / count / version** (@0x76c68/@0x76c08/@0x77128) and values
   intobj @0x80430 = **24**, `[NSNumber
   numberWithUnsignedInteger:frameCount]`, intobj @0x80448 = **2** —
   i.e. info.plist = {fps: 24, count: N, version: 2} ✓, matching B's
   `{@"version": @2, @"count": @(frame), @"fps": @24}`. (Scope note:
   the per-frame 24 fps thinning comparison itself was not re-derived
   line-by-line; every hard constant in the claim was.)

4. **whatsNewSeen written WITHOUT notify — CONFIRMED.**
   `+[OMCWhatsNewController markSeen]` @0x19b8c (my dump, 60 bytes):
   `CFPreferencesSetAppValue` with key cfstring @0x78f88 =
   **"whatsNewSeen"**, value cfstring @0x75c28 = **"1.0.3"**, domain
   @0x75028 = "com.anlai.omnicar", then a tail call to
   `CFPreferencesAppSynchronize`. The whole body contains **no**
   notify_post and no CFNotificationCenter post. B's claim and the
   version literal are exact.

5. **Home/AppBridge sliders write live with NO sync/notify — CONFIRMED.**
   `-[OMCAppBridgeAppsController sliderMoved:]` @0x21f50 (my dump,
   344 bytes) contains exactly one pref call: a raw
   `CFPreferencesSetAppValue` @0x22074, followed by `updatePreview` —
   no `CFPreferencesAppSynchronize`, no `notify_post` anywhere in the
   body. The commit path `sliderDone:` @0x220a8 instead routes through
   the two-argument write helper sub_21eb8 with a `numberWithLong:`
   value — the contrast B describes (drag = SetAppValue only;
   touch-up = full helper) is real.

6. **OMCHomeScreenController -layoutPage = return YES — CONFIRMED.**
   @0x24b40 the entire method is 8 bytes: `mov w0, #1; ret`
   (next function start 0x24b48). B's note that the index's
   "4244-byte method" was an artifact of adjacent statics is
   consistent with LC_FUNCTION_STARTS.

## Stub honesty

`grep` over all 22 B class files finds **zero** `STUB-UNRECOVERED`
markers — consistent with B's declaration that none were needed — and
the only trivial body in the set is `-layoutPage { return YES; }`,
which is the verified binary truth (item 6). B's INFERRED pockets are
declared in PrefsB_REPORT.md §4 and marked inline; none of my six
spot-checks landed in a pocket B had marked VERIFIED and found it
fabricated — the single error (item 1's phantom re-write) sits in a
method B labelled VERIFIED and is listed above with its fix.
