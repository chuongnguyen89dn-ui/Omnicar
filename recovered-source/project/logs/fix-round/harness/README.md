# Harness — OmniCar reconstruction fix round 2 (§8 E2)

Host-side C harness (Linux, **no ObjC runtime**) that **executes real logic
transcribed** from the current (just-fixed) reconstruction sources. Every
transcription in `harness.c` carries a file:line citation to the source
expression it was copied from; line numbers below were verified by reading
the current files for this round.

## Build & run (exact commands used)

```
clang-18 -std=c11 -Wall -Wextra -o harness harness.c
./harness > results.txt        # exit code 0
```

Compiler: Ubuntu clang 18.1.3 (`clang-18`). Full stdout is in `results.txt`.

## Result summary

| Test | Checks | Result |
|---|---|---|
| 1a keyboard IPC round-trip | 133 | PASS |
| 1b apporient IPC round-trip | 120 | PASS |
| 2 orientation clamp | 7 | PASS |
| 3 unblank (fake scheduler) | 11 | PASS |
| 4 hook-chain guard simulation | 3 | PASS |
| **Total** | **274 assertions, 0 failures** | **PASS** |

## Transcription citations

- **FNV-1a 32** — `src/AppBridgeB/AppBridgeB.h:54-61` (`ABBundleHash`):
  basis `0x811C9DC5`, prime `0x01000193`, loop
  `h = (h ^ (uint8_t)*s) * prime` over the bundle ID's NUL-terminated
  UTF-8 bytes; NULL input returns the basis. Transcribed exactly,
  including the byte handling.
- **Keyboard sender (pack)** — `src/AppBridgeB/ABInApp.m:341-349`
  (`ABKeyboardPublish`, sub_6AD4): `state = 0`; only when shown,
  `state = 1`, `state |= (keyboardType & 0x7F) << 1` (line 345),
  `state |= (returnKeyType & 0xFF) << 8` (line 347); always
  `state |= (uint64_t)ABBundleHash(bundleID) << 24` (line 349).
- **Keyboard receiver (unpack)** — `src/AppBridgeB/ABHostGeometry.m:153,
  159-164` (`ABKeyboardDispatch`, sub_93B0): `hash = state >> 24`;
  `(state & 1) == 0` → hide, else show with
  `keyboardType = (state >> 1) & 0x7F`,
  `returnType = (state >> 8) & 0xFF`. In the harness the show/hide outcome
  is returned as an effect enum so each case asserts **exactly one**
  effect (show XOR hide). The `bundleForHash:` lookup and the
  `@try/@catch` shell are host plumbing, not decode logic, and are not
  transcribed.
- **App-orient sender (pack)** — `src/AppBridgeB/ABInApp.m:450-452`
  (`ABPublishAppOrientation`, sub_67FC):
  `state = (orientationField & 0xFF) | (mask & 0xFFFF) << 8 |
  ABBundleHash(bundleID) << 24`. The mask argument stands in for
  `ABSupportedOrientationMask()` (line 449) — host state, not packing.
- **App-orient receiver (unpack)** — `src/AppBridgeB/ABHostGeometry.m:
  143-145` (`ABAppOrientDispatch`, sub_92B4): `hash = state >> 24`,
  `orientation = state & 0xFF`, `mask = (state >> 8) & 0xFFFF`.
- **Orientation clamp** — `src/AppBridgeB/ABHostGeometry.m:383-385`
  (`ABHook_SBSceneViewRefSize`, sub_7764): the entire logic is
  `if (orientation > 4) orientation = 3;` — a signed `NSInteger`
  comparison, so −1 and 4 pass through unchanged.
- **Unblank** — `src/AppBridgeB/ABHostGeometry.m:393-402`
  (`ABHook_ScreenBlanked`, sub_777C): if `blanked == 1 &&
  [[ABHost shared] count] > 0`, call `orig(1)` immediately and schedule
  `orig(0)` after `dispatch_time(0, 1000000000)` = 1.0 s, then return;
  otherwise forward `orig(blanked)` once. In the harness `orig` is a
  recorder and `dispatch_after` a fake scheduler driven by fake time;
  `[[ABHost shared] count]` is the `g_hosted_count` parameter.

## What each test executed

### Test 1a — keyboard round-trip (133 checks, PASS)
Cases: shown ∈ {0,1} × (keyboardType, returnType) ∈ {(0,0), (1,1), (7,3),
(127,255)} × 4 bundles = 32 packed states. Each state is packed with the
transcribed sender expressions and unpacked with the transcribed receiver
expressions; the test asserts the hash and shown flag round-trip exactly,
that the receiver produces exactly one effect (show iff shown, else hide),
and that the type fields round-trip. One faithful-source nuance: the sender
packs the type fields **only when shown** (`ABInApp.m:342-348`), so for
shown = 0 cases the assertion is that the decoded type fields are 0 (they
were never transmitted), while shown/hash still round-trip exactly.

FNV-1a32 hashes printed by the harness for the chosen bundles:

| Bundle | FNV-1a32 | Top byte (bits 24–31) |
|---|---|---|
| `com.apple.mobilesafari` | `0x9A8FFE74` | `0x9A` |
| `com.google.maps` | `0x53DCBA70` | `0x53` |
| `com.spotify.client` | `0x4A83D793` | `0x4A` |
| `com.microsoft.Office.Outlook` | `0x539EEF77` | `0x53` |

**Non-zero top byte:** all four picks qualify — no adjustment was needed.
The designated regression bundle is `com.apple.mobilesafari`
(`0x9A8FFE74`, top byte `0x9A`): its hash occupies packed bits 24–55, so
the top byte lands at packed bits 48–55 — exactly the range the historical
wrong decoders broke. The harness explicitly asserts that decoding its
packed state (shown=1, type=7, return=3) with the old wrong expressions
does **not** recover the hash — `(uint32_t)state = 0x7400030F`,
`(uint32_t)(state >> 32) = 0x009A8FFE`, `(uint32_t)(state >> 40) =
0x00009A8F`, all ≠ `0x9A8FFE74` — while the correct `state >> 24` does.

### Test 1b — apporient round-trip (120 checks, PASS)
Cases: orientation ∈ {0,1,3,4,6} × mask ∈ {0, 26, 30, 65535} × 2 bundles
(`com.apple.mobilesafari`, `com.google.maps` — the first has a non-zero
top-byte hash) = 40 packed states; orientation, mask and hash all assert
exact round-trip through the transcribed expressions.

### Test 2 — orientation clamp (7 checks, PASS)
Vector {−1, 0, 1, 2, 3, 4, 5} → {−1, 0, 1, 2, 3, 4, 3} using the exact
transcribed signed comparison `orientation > 4`.

### Test 3 — unblank with fake scheduler (11 checks, PASS)
(a) blank=1, hosted=2 → immediately exactly `[orig(1)@0.0]`, nothing at
+0.5 s, `orig(0)@1.0` appended at +1.0 s, nothing further.
(b) blank=1, hosted=0 → single plain forward `orig(1)`, nothing scheduled.
(c) blank=0, hosted=2 → single plain forward `orig(0)`, nothing scheduled.

### Test 4 — hook-chain simulation (3 checks, PASS) — GUARD LOGIC ONLY
This test executes the **transcribed guard logic (control flow)**, not the
ObjC code itself:

- Installer once-guard transcribed from `ABHostGeometry.m:415-419`:
  file-scope static `ABHooksInstalledOnce`; `if (…Once) return;` then the
  flag is set **before** the install body.
- Registrar structure transcribed from `ABHostGeometry.m:95-105,133`
  (`ABSpringBoardReady`): the orig IMP is invoked at the top on **every**
  call (line 100); the registrar body sits inside its own function-local
  static once-guard (lines 103–105, closed at line 133).

Drive: install ×2, ready ×3 → asserted install body ran 1×, orig ran 3×,
registrar body ran 1×.

**Static-only disclaimer:** the substrate-level chaining itself
(`MSHookMessageEx` / `MSHookFunction` calls, class/method verification,
type-encoding gates inside `ABInstallSpringBoardHooks`) did **not** run
here and remains **static / binary-evidence verified**. The binary-side
reference is the previous round's hook-count evidence,
`project/logs/hotfix-hookcount.txt` (built binary: one hook-installing
ctor, 4× `MSHookMessageEx` + 1× `MSHookFunction`, matching the original).

## What is static-only overall
Only the four logic areas above executed (as faithful C transcriptions).
Everything else in the two source files — ObjC message dispatch, notify
transport (`notify_set_state`/`notify_get_state`/`notify_post`), the
`bundleForHash:` pane lookup, GCD queues, logging, and all other hooks —
was not executed and is covered only by the reconstruction's existing
static/binary evidence.
