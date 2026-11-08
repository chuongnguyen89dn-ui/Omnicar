# SpeedBubbleB_REPORT — OmniCarSpeedBubble.dylib, SOURCE-APP side

Agent B (wave 2.5), 2026-11-08. Scope: everything that runs inside the
four speed-source apps (Vietmap `vn.vietmap.live`, GOFA `com.lumi.GOFA`,
Waze `com.waze.iphone`, Wyn `com.wynauto.wyn`) in
`OmniCarSpeedBubble.dylib` (649,808 B, arm64 slice analysed; arm64e
surface identical per wave-1 validation).

Deliverables in this folder: `SBSourceGlobals.h`, `SPPSpeedGPS.h/.m`,
`SBPublish.m`, `SBSourceHooks.m`, `SBFlutter.m`, `SBScan.m`,
`SBOpenCar.m` (boundary), `PARTITION_B.txt`. Disassembly dumps (agent
A's, regenerated set) in `disasm/`.

## Method — how names were resolved (read this before trusting anything)

Three independent resolutions were used, and they agree:

1. **My own LC_DYSYMTAB parse** of `__stubs` (154 entries) — every call
   target I cite was checked against it directly.
2. **The calibrated xref** (`metadata/xref/OmniCarSpeedBubble.json`,
   LC_DYSYMTAB-voted, delta = +1 over wave-1): I diffed all 47 classref
   labels in my functions' dumps against its per-call-site class names —
   **2 disagreements, both slot 0x42f60** (see Corrections).
3. **The verifier's ground-truth resolver** (`verify/macho_truth.py`,
   `slot_truth`): I resolved all 24 classref slots my reconstruction
   relies on — **24/24 match the names used in my source** (NSBundle,
   NSString, UIApplication@0x42f60, SPPSpeedGPS@0x42f68, NSHashTable,
   CLLocationManager, NSArray, NSTimer, NSThread, NSSet, NSMutableSet,
   NSDictionary, NSJSONSerialization, NSNull, NSNumber, NSCharacterSet,
   NSNotificationCenter, NSOperationQueue, NSMutableArray,
   NSMutableString, UIWindowScene, UIWindow, UILabel, NSScanner).
   The verifier's audit (`metadata/ANNOTATION_AUDIT.md`) independently
   confirms the off-by-one adjudication and the corrected superclass
   list (SPPSpeedGPS → NSObject).

Selector names come from `__objc_stubs` decoding and are unaffected by
the import bug. The audit certifies the current dumps' call annotations
8,476/8,476; data-slot annotations have 10 known-wrong slots (below).

## 1. Host detection and per-app hook table

Detection (ctor `__init_1` @0x5950, VERIFIED): index of
`[[NSBundle mainBundle] bundleIdentifier]` in the constant array
`[vn.vietmap.live, com.lumi.GOFA, com.waze.iphone, com.wynauto.wyn]`.
`NSNotFound` → the constructor returns immediately and installs
**nothing** (so in SpringBoard/CarPlayApp/any other process this ctor is
inert; the host-index global keeps its default 0). No feature gate, no
crash-guard on this path. Log: `loaded into %@ (%@)` (display name,
bundle id).

Hook *installation* is identical for all four hosts; differentiation is
entirely by `SPPHostIndex` gates at run time:

| Hook | Mechanism | Vietmap (0) | GOFA (1) | Waze (2) | Wyn (3) |
|---|---|---|---|---|---|
| `CLLocationManager -startUpdatingLocation` → sub_5fac | MSHookMessageEx | ✓ | ✓ | ✓ (gated¹) | ✓ (gated¹) |
| `CLLocationManager -stopUpdatingLocation` → sub_5fdc | MSHookMessageEx | ✓ | ✓ | ✓ | ✓ |
| `FlutterEngine setMessageHandlerOnChannel:binaryMessageHandler:taskQueue:` → sub_6638 | MSHookMessageEx, only if the class exists AND implements it | ✓ (Flutter) | only if Flutter present | only if Flutter present | installed, but wrapping disabled² |
| `FlutterEngine setMessageHandlerOnChannel:binaryMessageHandler:` → sub_671c | MSHookMessageEx, fallback variant | ✓ fallback | idem | idem | idem |
| `UIAccessibilityIsSwitchControlRunning` → sub_79ac (returns YES) | MSHookFunction on the `dlsym(RTLD_DEFAULT, …)` address | ✓ | ✓ | ✓ | ✓ |
| UIScene lifecycle observers (4) → republish | NSNotificationCenter blocks | ✓ | ✓ | ✓ | ✓ |
| 0.3 s scan timer (starts +4 s) | NSTimer block | ✓ | ✓ | ✓ (gated¹) | ✓ (gated¹) |

¹ Gate = `SPPSourceIsActive()` (sub_65a8): hosts 0–1 always active;
hosts 2–3 publish only while the Darwin state of
`com.anlai.omnicar/speedbubble.source` equals their host index.
² Wrap decision (sub_67e0) refuses to wrap any channel when host == 3,
and refuses channel `vml_main_channel` on every host.

**No hooks on any app-specific internal class exist in this dylib.**
All per-app behaviour flows through the four generic mechanisms above.

Premise corrections to the task text (proven, not opinion):
- The CLLocationManager hooks use **MSHookMessageEx**, not
  MSHookFunction. MSHookFunction is used exactly once, for
  UIAccessibilityIsSwitchControlRunning.
- That function is found via **dlsym(RTLD_DEFAULT, …)**, not dlopen.
- The ×1e9 multiplication near the constructor is
  `dispatch_time(DISPATCH_TIME_NOW, seconds * 1e9)` — seconds→ns for the
  +2 s/+6 s/+12 s Switch-Control notification kicks. A second 1e9
  constant in the scan (sub_7a84) is an initial min-distance sentinel
  (1e9 as a double), unrelated.

## 2. The four data paths out of a source app

1. **Own GPS (all hosts).** The app's CL start/stop calls are routed
   (main queue) into `SPPSpeedGPS appManager:running:`. While ≥ 1 app
   manager runs, SPPSpeedGPS runs a private CLLocationManager
   (BestForNavigation, no distance filter, automotive activity,
   background updates iff the host declares the `location` background
   mode). Shutdown lags the last app stop by a 20 s token-guarded delay.
   Fixes are filtered (age ≤ 3 s, accuracy 0–100 m, ≤ 300 km/h) and
   published immediately.
2. **Flutter channel mining (Flutter hosts).** Wrapped handlers copy
   each message, decode it on the main queue with
   FlutterStandardMethodCodec / FlutterJSONMethodCodec (dynamic
   selectors), and recursively mine the arguments (depth ≤ 8, JSON
   strings re-parsed) for limit/speed keys. The original handler is
   always called with the original arguments — interception is
   observational. Only the limit is consumed (the extractor's speed
   out-parameter is written by sub_733c but ignored by sub_6aa0 —
   VERIFIED). A Flutter limit stays authoritative for 600 s.
3. **Screen scan (all hosts).** A 0.3 s timer (full scan every 20 s)
   reads the app's own UI: UIKit label tree first, cached labels next,
   the accessibility tree as fallback (see §4). Scan limits are trusted
   for 2 s, scan speeds likewise. This is why the ctor forces
   Switch Control on: it populates the AX tree.
4. **Publication.** One packed Darwin-notify state (§3) plus a coarse
   location channel. No files, no distributed notifications on this
   side (proven by xref over the source-app range).

## 3. Publication format (VERIFIED)

Channel `com.anlai.omnicar/speedbubble.speed`, `notify_set_state` +
`notify_post`, on every accepted GPS fix and every scan tick:

```
bits  0..7   limit clamped 0..255 (negative limit -> 0 in this field)
bits  8..15  speed clamped 0..255
bits 16..31  meta = (hostIndex << 3) + sceneCode
                    + (limit >= 0 ? 2 : 0) + (speed >= 0 ? 1 : 0)
sceneCode    = 4 iff on the main thread some foreground-active scene's
               session role does NOT contain "InstrumentCluster", else 0
```

Channel `com.anlai.omnicar/location` (own-GPS fixes only):
state = `(int64)llround(lat*100) << 32 | (uint32)llround(lon*100)`,
gated to accuracy 0–5000 m and ≥ 3.0 s between posts. Mechanics
VERIFIED; purpose (≈0.01° grid position for the display side) INFERRED.

Channel `com.anlai.omnicar/speedbubble.source` is only READ here
(arbitration, §1). Its writer is not in this module's range — display
side (agent A / coordinator): OPEN ITEM, already flagged in A's
partition ("A documents the consume format; B documents the publish
format" — for .source the roles invert).

## 4. sub_7a84 — the scan engine (9,780 B, read in full)

Entry: `SPPScanScreen(BOOL fullScan)` from the 0.3 s tick.

**Window selection.** Candidates: (1) from each UIWindowScene, the key
window, else the first window with a rootViewController; (2) from each
foreground-active non-window scene responding to the dynamic selector
`carWindow`, that UIWindow. First candidate drives the label path.

**Label path** (when the recursively collected view list is non-empty).
For each text-bearing view: sign container =
`sub_a938(view, @"Limit") ?: (view, @"MaxSpeed") ?: (view, @"SpeedSign")`
(speed-only sources use `@"CurrentSpeed"` / `@"Speedometer"`). The
container's superview chain is climbed for a near-square frame
(width ≥ 24, ≤ 140, |w−h| ≤ 3.0, corner-radius vs min(w,h)·0.5 − 2).
Classification: colour of the container's colour view
(`getRed:green:blue:alpha:`) — r > 0.55, g < 0.45, b < 0.45 → kind 1
(limit); r < 0.45, b > 0.5 → kind 2 (speed); else a descendant UILabel
containing "km" also gives kind 2. Every candidate is appended to a
debug string ` %@(f%.0f %@%@)` (text, font size, class, suffix
` gioi-han` / ` toc-do` / ` vong`). Largest-font label per role wins;
winners are cached (speed → weak global @0x437e8, limit → strong
@0x437f0) and their `text intValue`s become the result.

**Cached path** (collection empty, caches present): re-reads the cached
views (`sub_afb4` on the root, `sub_b0ec` on the weak aux view @0x437f8,
whose window/hidden state is checked).

**AX path** (collection empty): per candidate window,
`sub_b878(window, elements, seenSet, 0)` collects
`{@"t": text, @"f": NSValue(CGRect)}` dicts under a **40 ms deadline**
(globals @0x43888/@0x43890; overrun logged at most every 20 s:
`speed scan: duyet AX qua 40ms -> dung giua chung (%lu phan tu)`).
Pass 1: elements passing `sub_bf50` whose lowercase text contains
"km" — NSScanner-extracted integers (≤ 999) before "km": last =
speed, second-to-last in 5..200 = limit. Pass 2 (spatial): the purely
numeric element (sub_7904 test) closest (hypot of midpoints) to the
anchor = speed; a 5..200 numeric element in the same row band
(|ΔmidY| ≤ 1.2 × max height, nearest ΔmidX) = limit. Full scans dump
`AX %lu phan tu:` + ≤ 25 digit-bearing elements
` "%@"@(%.0f,%.0f %.0fx%.0f)`.

**Commit (shared tail).** speed ≤ 300 (unsigned) → `scanSpeed`
@0x436bc + time @0x43880; limit in 5..200 → `scanLimit` @0x436b4 +
time @0x43828; a negative limit with the cached speed view gone
commits −1 (clears a stale limit). Full-scan logs:
`speed scan: toc do=%d gioi han=%d; ung vien:%@` (label path),
`speed scan (AX, %lu cua so, trung %@): toc do=%d gioi han=%d; %@`,
`speed scan (view app, %@): toc do=%d gioi han=%d` (cached path).

Fidelity inside sub_7a84: structure, order, constants, strings and
commit writes VERIFIED; exact float-predicate directions in the
corner-radius test and parts of the font-contest bookkeeping are
INFERRED (register flow admits two readings); the per-window AX loop
break condition is INFERRED.

## 5. Per-function evidence / status

| Addr | Name used | Status | Evidence |
|---|---|---|---|
| 0x44a8 | __init_0 (SBOpenCar.m) | VERIFIED¹ | disasm; slot_truth 0x42f60 |
| 0x45b4 | SPPOpenCarHandler | VERIFIED¹ (guard layout INFERRED) | disasm |
| 0x4a70 | +[SPPSpeedGPS shared] | VERIFIED | objc.json IMP + disasm |
| 0x4ab4 | once block | VERIFIED | block map |
| 0x4ae0 | appManager:running: | VERIFIED | disasm |
| 0x4cac | scheduleStop | VERIFIED | disasm (20 s = 0x4a817c800 ns) |
| 0x4d44 | stop-delay block | VERIFIED | disasm |
| 0x4e18/0x4e20 | thunks | VERIFIED | 8 B tail-calls |
| 0x4e28 | start | VERIFIED | disasm |
| 0x4ffc | stop | VERIFIED | disasm |
| 0x50c0 | didUpdateLocations | VERIFIED (clock call INFERRED) | disasm |
| 0x538c | SPPKmhFromLocation | VERIFIED | disasm |
| 0x5498 | SPPPublishSpeed | VERIFIED (lazy register_check INFERRED) | disasm + xref |
| 0x5734 | SPPCurrentLimit | VERIFIED | disasm (600 s / 2 s windows) |
| 0x5798 | didFailWithError | VERIFIED | disasm |
| 0x583c–0x5950 | accessors + .cxx_destruct | VERIFIED | objc.json ivar offsets |
| 0x5950 | __init_1 (ctor) | VERIFIED | disasm + xref |
| 0x5fac/0x5fdc | CL replacements | VERIFIED | disasm |
| 0x600c | SPPStartScan | VERIFIED (timer factory sel INFERRED) | block map + disasm |
| 0x6098 | SPPScanTick | VERIFIED (lastScanTime store INFERRED) | disasm |
| 0x63f0 | SPPRouteAppManager | VERIFIED | disasm |
| 0x64d8 | SPPHandleAppManager | VERIFIED | disasm |
| 0x65a8 | SPPSourceIsActive | VERIFIED | disasm |
| 0x6638/0x671c | Flutter replacements | VERIFIED | disasm + selectors |
| 0x67e0 | SPPWrapHandler | VERIFIED (intent of exclusion INFERRED) | disasm |
| 0x6968 | wrapped handler block | VERIFIED | disasm |
| 0x6aa0 | SPPHandleFlutterMessage | VERIFIED (codec early-exit INFERRED) | disasm |
| 0x7264/7270/7298/72c0 | block copy/dispose/dispatch helpers | VERIFIED (roles) | block map |
| 0x72f4 | once block (exclusion set) | VERIFIED | disasm |
| 0x733c | SPPExtract | VERIFIED | disasm (depth ≤ 8, JSON re-parse) |
| 0x7904 | SPPIsNumericString | VERIFIED | disasm (len 1–3, digits) |
| 0x79ac | SwitchControl replacement | VERIFIED | 8 B: return YES |
| 0x79b4 | kick block | VERIFIED | disasm |
| 0x7a10 | republish block | VERIFIED | disasm |
| 0x7a24 | scene observer block | VERIFIED | disasm (+0.5 s repeat) |
| 0x7a74 | block assign thunk | VERIFIED | 16 B |
| 0x7a84 | SPPScanScreen | VERIFIED structure (§4) | full read, 2,448 lines |
| 0xa0b8 sub_a0b8 | SPPCollectViews | contract VERIFIED, body **NOT-RECOVERED** | call sites in sub_7a84 |
| 0xa2c4 sub_a2c4 | SPPCandidatesSummary | contract VERIFIED, body **NOT-RECOVERED** | call sites |
| 0xa530 sub_a530 | SPPScanPostCommit | contract VERIFIED, body **NOT-RECOVERED** | call sites |
| 0xa938 sub_a938 | SPPFindSignContainer | contract VERIFIED, body **NOT-RECOVERED** | call sites (5 identifier strings) |
| 0xaa4c sub_aa4c | SPPColorView | contract VERIFIED, body **NOT-RECOVERED** | call site |
| 0xafb4 sub_afb4 | SPPExtractFromCachedRoot | contract VERIFIED, body **NOT-RECOVERED** | call sites |
| 0xb0ec sub_b0ec | SPPExtractFromCachedView | contract VERIFIED, body **NOT-RECOVERED** | call site |
| 0xb878 sub_b878 | SPPCollectAXElements | contract VERIFIED, body **NOT-RECOVERED** | call site + deadline globals |
| 0xbf50 sub_bf50 | SPPAXTextIsCandidate | contract VERIFIED, body **NOT-RECOVERED** | call sites |
| 0x4000–0x44a8 | libroot trampolines | CEDED (shared infra, both agents agree) | PARTITION_A/B |

¹ Dual-claimed by agent A — coordinator to keep one canonical copy.

## 6. Corrections and annotation findings

**To wave-1 metadata**: SPPSpeedGPS superclass `NSRunLoop` → **NSObject**
(raw bind ordinal 267 → imports[267] under the calibrated 0-based
decode; audit addendum confirms). All other wave-1 "surprising
superclasses" in this binary are the same artifact (audit lists them).

**To agent A's dumps** (current, regenerated set — call annotations are
audit-clean; these are data-slot issues):
- Slot **0x42f60 labelled `NSString` is UIApplication** — affects my
  range at sub_45b4, sub_5498 and sub_7a84 (×5 total in the binary).
  Root cause (mine, from my own parse): the dump annotator's
  next-slot heuristic; macho_objc's `ptr_at` is off by one import the
  other way. My source used UIApplication from the start (semantic +
  calibrated xref + slot_truth all agree).
- Loads of the int globals @0x436a8/0x436ac/0x436b0/0x436b4/436bc are
  annotated `(= import ___objc_personality_v0)` / `<ordinal 65535>` in
  the dumps — display garbage; `verify/macho_truth.py` raw reads show
  plain `0xFFFFFFFF` (−1) data words (the audit flags 0x436b0 the same
  way). My source treats them as `int` globals initialised to −1.
- `[0x42000] selref -> @fileURLWithPath:` annotations on fast-
  enumeration state loads, and `(= import _class_copyPropertyList)` at
  sub_6968 @0x6a34 (really a block invoke-pointer deref), are likewise
  display artifacts; I did not rely on them.
- The audit's remaining wrong slots (0x43030, 0x43068, 0x43078,
  0x430d0, 0x43118, 0x43198, GOT 0x392d8/0x398d8/0x43440) are all in
  display-side code — **none fall in my claimed range and none of my
  statements rest on them**.
- The pre-regeneration SpeedBubble dumps (stub mislabels listed in the
  audit, e.g. 0x27ff8 as `_objc_registerClassPair`) were NOT used: my
  stub map came from my own LC_DYSYMTAB parse, and it matches the
  audit's truth table on every entry I checked (incl. 0x27bf0
  _MSHookFunction, 0x27bfc _MSHookMessageEx, 0x27dc4 _dispatch_time,
  0x27de8 _dlsym).

**To my own task premise**: CL hooks = MSHookMessageEx; UIAccessibility
symbol via dlsym; ×1e9 = dispatch_time ns conversion (see §1).

## 7. Open items for the coordinator

1. Writer of the `speedbubble.source` arbitration state — not in this
   dylib's source-app range; presumably SPPBubble (agent A) or
   OMCCommon. Needed to complete the Waze/Wyn story.
2. Bodies of the nine ≥ 0xa0b8 scan helpers (contracts in §5) — a
   follow-up pass over sub_a0b8…sub_c70c could close them; A explicitly
   leaves the whole range to B.
3. __init_0/sub_45b4 canonical copy (A vs B) and OMCCrashGuard
   polarity (my INFERRED proceed-on-YES).
4. Who writes aux cached view @0x437f8 (read in sub_7a84's cached
   path; no writer in my range) — likely one of the ≥ 0xa0b8 helpers.

---

## Scan-helper closure addendum (wave 3, closure pass)

Written by the closure agent, 2026-11-08. All nine bodies were
reconstructed from FRESH capstone dumps (own tooling:
`tools/closure_dis.py`; every name resolved through the verifier's
`verify/macho_truth.py`, never through agent A's annotations).
Dumps: `disasm/closure/`. Source: `SBScanHelpers.m` / `.h`, including
the seven file-local helpers the nine depend on (sub_ae3c, sub_b214,
sub_b4f0, sub_b720, sub_c018, sub_c204, sub_c70c — also fully read and
reconstructed there). No STUB-UNRECOVERED was needed anywhere.

### @0x437f8 writer verdict (open item 3 — RESOLVED)

**The writer is sub_a2c4** — at 0xa464–0xa470 it executes
`objc_storeWeak(&0x437f8, view)` with the first candidate-window image
view that yields a reading, immediately before returning that reading.
Proof of uniqueness: the whole binary contains exactly two
`objc_storeWeak` call sites (grep over all dumps): sub_7a84 @0x87a8 →
0x437e8 (SPPCachedSpeedView) and sub_a2c4 @0xa470 → 0x437f8. No other
function in the dylib writes the aux cache.

### Per-function verdicts

**sub_a0b8 SPPCollectViews — CLOSED.** Recursive pre-order collector
with a hard depth gate (depth > 40: the call does nothing, not even
recursion). A view is added iff it is a UILabel, its `text` passes
SPPIsNumericString (sub_7904), and it passes the on-screen gate
sub_ae3c (has a window; itself and every ancestor !hidden with
alpha ≥ 0.05; window-space frame > 4 pt in both dimensions and
intersecting the window's bounds). Consistent with B's contract; the
ae3c gate and the numeric-text condition are the precise form of
"collect root + descendants".

**sub_a2c4 — CLOSED; §5 CONTRACT CONTRADICTED.** It is not
`SPPCandidatesSummary` and does not return a string. Body: for each
candidate window it collects visible UIImageViews with images
(sub_c018: hidden/alpha<0.05 prune, depth ≤ 45, ≤ 300 cap), keeps
those passing sub_ae3c, and returns the FIRST SPPExtractFromCachedView
value ≥ 0, storing that view into SPPCachedAuxView @0x437f8 on the way
out; returns −1 (mov w23, #-1 @0xa45c) when nothing yields. Caller
evidence in sub_7a84: call sites 0x9574 and 0x9794 pass the candidates
array and consume the result as an int — @0x9578–0x959c the result is
moved to w19 and range-tested arithmetically (`sub w8, w19, #0xc9;
cmn w8, #0xc4`, the 5..200 window) next to the SPPScanSpeed commit;
@0x9794–0x97a8 it is stored to the limit local and sign-tested
(`tbz w8, #0x1f`). No format-string call consumes it, so the §4
statement that this result fills the AX log line's `trung %@` field
cannot stand as written; whatever fills `%@` there is a different
value in sub_7a84 (outside this closure's scope). Renamed
SPPFindAuxImageValue in SBScanHelpers.h; SBScan.m's extern
`id SPPCandidatesSummary(NSArray *)` must be deleted.

**sub_a530 SPPScanPostCommit — CLOSED; §5 ROLE CONTRADICTED.** The
body performs no bookkeeping and writes no scan state: for each
candidate window it walks the tree with sub_c204 (technology set =
class names containing Flutter/RCT/Mapbox/MGL/Vietmap/Unity/GMS/
MTKView/Metal; quoted label texts, ≤ 49, truncated to 30 chars;
image entries `name(w×h@x,y)`, ≥ 12×12, ≤ 59) and sub_c70c ("related"
views whose lowercase class name contains limit/speed/sign/traffic/
warning, ≤ 24 entries, formatted
` %@(<x>,<y> <w>x<h> so=<sub_afb4 value>[ anh][ ax="<label>"])`),
then emits ONE OMCLogWrite (the only externally visible call, @0xa784)
with format
`chan doan %@ (%.0fx%.0f): cong nghe=[%@] chu=[%@] anh=[%@] view lien quan:%@`,
falling back to ` (khong co)` for an empty dump. Callers (sub_7a84
@0x9624 gated on the full-scan flag, and @0x97b0) ignore the result;
the function returns void. Accurate description: full-scan per-window
diagnostic logger. The name SPPScanPostCommit is kept in the source
only because SBScan.m calls it by that name.

**sub_a938 SPPFindSignContainer — CLOSED; mechanism refined past the
contract.** The identifier is matched against the ancestors' CLASS
NAMES, not any accessibility identifier: starting at the view's
superview (the view itself is never tested), each ancestor's
`NSStringFromClass(objc_opt_class(cur))` is searched with
`rangeOfString:options:` (options = 1, NSCaseInsensitiveSearch) and
the first ancestor whose class name contains the identifier is
returned; at most 6 ancestors are tested (counter `cmp w23, #4 /
b.ls` after each climb), else nil. Call semantics in sub_7a84 are
unaffected, but any reader reasoning from "accessibility identifier"
would misunderstand why the five identifier strings work: the host
apps' sign views carry them in their class names.

**sub_aa4c SPPColorView — CLOSED; §5/SBScan.m CONTRACT CONTRADICTED.**
It returns a **UIColor\***, not "the colour-bearing view", and the
second parameter is a recursion depth (the sole caller, sub_7a84
@0x8118, passes `w1 = 0`; the return value is consumed by
`getRed:green:blue:alpha:` @0x8154). Search order: (1) own layer —
borderWidth ≥ 1.0 (`fcmp d0, #1.0; b.ge`) and borderColor non-NULL →
`[UIColor colorWithCGColor:borderColor]`; (2) layer.sublayers — first
CAShapeLayer (slot 0x43030, macho_truth-resolved) with lineWidth
≥ 1.0 and strokeColor non-NULL → its colour; (3) recurse into
subviews SKIPPING UILabels at depth + 1; depth == 3 or nil view →
nil.

**sub_afb4 SPPExtractFromCachedRoot — CLOSED.** nil root → −1.
Otherwise sub_b214 recursively finds the winning label (subtree
pruned at hidden or alpha < 0.05 nodes; a UILabel whose
whitespace-trimmed text passes SPPIsNumericString wins iff no current
best or its font pointSize is strictly greater; descent stops at
depth == 7), and the result is the winner's trimmed `text intValue`,
or −1 when there is no winner. Matches the contract.

**sub_b0ec SPPExtractFromCachedView — CLOSED.** nil view or nil
`-image` → −1 (the binary fetches `-image` twice — presence check,
then use). Otherwise a three-stage fallback, each stage the parser
sub_b4f0, first result ≥ 0 wins: (1) the image NAME carved from
`-[UIImage description]` by sub_b720 (text between `named(` and `)`,
then stripped through the first `": "`); (2) `accessibilityIdentifier`;
(3) `accessibilityLabel`. sub_b4f0 itself: lowercase; require one of
the constant keywords {limit, speed, max, toc, bien, sign, kmh}; then
NSScanner-walk all integers and return the LAST inside 5..200
(`(v-5) < 0xc4` unsigned), else −1. Matches the contract, with the
parser and the name-extraction now explicit.

**sub_b878 SPPCollectAXElements — CLOSED.** Matches the contract;
exact gates now pinned, in order: nil element; depth > 80; out count
> 600; seen count > 4000; SPPAXOverran already set; deadline —
`CFAbsoluteTimeGetCurrent() > SPPAXDeadline` sets SPPAXOverran and
stops the whole walk. Seen-testing uses
`[NSValue valueWithNonretainedObject:]` wrappers and an already-seen
element returns before any child walk. Text assembly: accessibility-
Label then Value (NSString-kind, non-empty only) joined with one
space; an element is emitted iff text is non-empty AND (it is not a
UIView OR isAccessibilityElement); frame = accessibilityFrame when
responded to, else CGRectZero; dict is `@{@"t": [text copy],
@"f": [NSValue valueWithCGRect:]}` (keys VERIFIED by cfstring read).
Children: accessibilityElements when a non-empty NSArray, else
accessibilityElementAtIndex: for counts 1..399, and — always, for
UIViews — the subviews as well.

**sub_bf50 SPPAXTextIsCandidate — CLOSED.** Lowercase the text,
delete every space (`stringByReplacingOccurrencesOfString:@" "
withString:@""`), then require one of `km/h`, `kmh`, `km/g`
(cfstrings VERIFIED). Note the sharpening vs §4's summary: a bare
"km" does NOT pass this gate — the contains-"km" test in pass 1 is
sub_7a84's own, applied after this gate.

### Required fix in agent B's files (for the coordinator)

SBScan.m's helper-contract block (lines ~34–56) needs three edits to
compile against SBScanHelpers.m without lying: delete the
`SPPCandidatesSummary` declaration (replaced by SPPFindAuxImageValue,
int return); correct SPPColorView's comment (returns UIColor*,
parameter is depth); correct SPPScanPostCommit's comment (diagnostic
logger, not bookkeeping). All other declarations match as-is.

---

## Verifier-#4 fix addendum

Applied after independent verification (evidence: src/SpeedBubble/
VERIFY_SpeedBubble.md — verifier #4's own disassembly via
verify/macho_truth.py; no contradiction found on any point):

1. **Bit-17 polarity (§3 of this report + SBPublish.m).** The meta term
   was written `(limit < 0 ? 2 : 0)`; the binary producer sub_5498
   @0x5660–0x5668 (`cmp w20, #0; mov w11, #2; csel x11, xzr, x11, lt`)
   yields 2 when limit >= 0 and 0 when limit < 0. Bit 17 is a
   limit-VALID flag (set iff limit >= 0), matching the consumer sub_cec4
   and REPORT_A.md / SPPDisplayBoot.m (both already correct, untouched).
   Corrected: the §3 formula above, the SBPublish.m code, and its header
   comment — a negative limit is signalled by bit 17 being CLEAR (the
   limit byte itself is clamped to 0).
2. **-[SPPBubble setSpeed:] sentinel (SPPBubble.m).** A negative speed
   publishes 0xFFFF (65535), not -1: the clamp at 0x17d64 loads w9 by
   MOVZ #0xFFFF @0x17da4. Corrected: the clamp expression and its header
   comment in SPPBubble.m, plus the consequential instance in the
   -feedWarning comment ("publishes -1" -> "publishes 0xFFFF" — the
   clearing path assigns self.speed = -1 through this same setter).
   The same sentinel correction was applied to
   metadata/SPEED_CHANNEL_TRACE.md; that document's "no consumer in
   package" conclusion is unaffected and otherwise untouched.

---

## Phase-2 compile fix (wave 3) — SBScan.m contract edits + dedupe note

Written by the phase-2 fix agent, 2026-11-08, applying the three
edits this report's scan-closure addendum required so SBScan.m
compiles against SBScanHelpers.m truthfully:

1. **SPPCandidatesSummary deleted.** SBScan.m's extern block no
   longer declares `id SPPCandidatesSummary(NSArray *)`. In its
   place: `extern int SPPFindAuxImageValue(NSArray *candidates);`
   with the corrected contract (int reading, -1 when none, sole
   writer of SPPCachedAuxView @0x437f8). The fidelity comment's
   "trung %@" attribution was corrected with it: the filler of the
   AX log line's `trung %@` field is now marked NOT-RECOVERED in
   SBScan.m (the closure pass proved sub_a2c4's int result is
   consumed arithmetically at the commit sites 0x9574/0x9794, not
   logged). The stale "helper bodies NOT-RECOVERED" notes in
   SBScan.m's header and SPPScanScreen body now point at
   SBScanHelpers.m.
2. **SPPColorView corrected.** Declaration is now
   `extern UIColor *SPPColorView(id container, int depth);` — the
   return is the sign's UIColor*, and parameter 2 is the recursion
   depth (callers pass 0), not "unused". A combined-declaration
   check (SBScanHelpers.h + the three corrected externs in one TU)
   passes with no conflicting-types diagnostics.
3. **SPPScanPostCommit comment corrected.** It is a full-scan
   diagnostic logger (one OMCLogWrite per candidate window) with
   no bookkeeping and no state writes; the name is kept only
   because SBScan.m's call structure uses it.

Dedupe (B side): agent B's SBOpenCar.m (__init_0 + sub_45b4) is
retired to a pointer note; the canonical copy lives in
SPPDisplayBoot.m, rewritten to the binary on every contested point.
Two of B's readings were adopted into the canonical text (library
receiver = the application; DBEvent type literal 4), as were B's
index-fallback semantics; B's out_token existed but as a static —
the binary uses a stack local in __init_0 and frame locals / two
__bss globals in sub_cc34. Full A-vs-B-vs-binary table: REPORT_A.md,
"Phase-2 compile fix" section.
