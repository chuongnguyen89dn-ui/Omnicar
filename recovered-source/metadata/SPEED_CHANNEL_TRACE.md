# SPEED CHANNEL TRACE — consumer of `com.anlai.omnicar/speed`

Wave-3 tracer deliverable. Question: who consumes the Darwin notification
`com.anlai.omnicar/speed`, listed as UNPROVEN in `metadata/IPC_MAP.md`
(line 102)?

## Conclusion (up front)

**NO CONSUMER EXISTS IN THIS PACKAGE.** The name is published by exactly
one function in `OmniCarSpeedBubble.dylib` and is never registered,
observed, or read — by any mechanism, static or dynamic — in any of the
8 binaries of OmniCar 1.0.3. It is a dead / outward-facing broadcast in
this version (see Interpretation at the end). Search coverage is stated
in full below; every candidate site found is listed with its verdict.

---

## 1. Publisher recap (proven, independently re-verified)

Source: `src/SpeedBubble/REPORT_A.md` lines 117 and 242; reconstruction in
`src/SpeedBubble/SPPBubble.m` lines 131–150. Re-verified against the
binary for this trace (disasm dump
`src/SpeedBubble/disasm/00017d64_-[SPPBubble_setSpeed_].txt`):

- **Publisher:** `-[SPPBubble setSpeed:]` @ **0x17d64**,
  OmniCarSpeedBubble.dylib, arm64 slice. SPPBubble is the display-side
  bubble class (SpringBoard side per REPORT_A).
- **Name string:** cstring VA **0x2edd4** (`__TEXT,__cstring`; fat file
  offsets 0x32dd4 arm64 / 0x80634 arm64e). It is a pure C string — no
  `__cfstring` wraps it anywhere.
- **Mechanics in `setSpeed:`:**
  - stores the raw value to the ivar at +0x10; early-returns if the demo
    timer is non-nil (publish suppressed during demo);
  - clamps: `min(v, 255)` for v ≥ 0 (`csel lo` vs 0xff @0x17d94–0x17d9c);
    v ≤ −1 collapses to 0xFFFF (65535) (`cmn`/`csel gt` @0x17da0–0x17da8;
    w9 loaded by MOVZ #0xFFFF @0x17da4) — 0xFFFF is the
    "invalid" sentinel;
  - deduplicates against a static last-published value at `__data`
    0x43790 (@0x17db0–0x17db8);
  - lazily `notify_register_check("com.anlai.omnicar/speed", &token)`
    @ **0x17dec**, token = static at `__bss` 0x439dc; if the token stays
    0 the publish is skipped;
  - `notify_set_state(token, clamped)` @ 0x17e00, then tail-call
    `notify_post("com.anlai.omnicar/speed")` @ **0x17e18**.
- **arm64e slice:** string VA 0x30634; the only code references are
  0x18830 and 0x1885c — the same register_check + post pair in the
  arm64e build of `setSpeed:`.

So the channel carries a state (clamped speed, 0xFFFF = invalid) plus a
post — the standard shape for a `notify_register_dispatch` /
`notify_get_state` consumer. None exists (below).

---

## 2. Search coverage (what was actually searched, and how)

All addresses arm64 slice unless stated. Ground truth tooling:
`verify/macho_truth.py` (fixup-aware Mach-O resolver) + Capstone 5.0.7;
xref data: `metadata/xref/*.json`. Tracer script kept at
`work/trace_speed.py`.

1. **Raw byte census, all 8 binaries, both slices.** The exact
   NUL-terminated byte string `com.anlai.omnicar/speed` occurs **only**
   in OmniCarSpeedBubble.dylib (fat offsets 0x32dd4, 0x80634). The
   other 7 binaries contain **zero** occurrences — not even as a prefix
   of a longer string. (Longer hits inside SpeedBubble and OmniCarPrefs
   are the distinct `com.anlai.omnicar/speedbubble.*` names.)
   Consequence: no other binary can name this channel statically at
   all; a consumer there would have to build the name at runtime
   (checked in step 5).
2. **Full reference scan of the string inside SpeedBubble (arm64).**
   - `__cfstring`: no entry's string pointer resolves to 0x2edd4.
   - Every 8-byte slot of every non-`__TEXT` section, decoded through
     the chained-fixups resolver: **no data pointer anywhere resolves
     to the string VA** — no channel table, no array entry, no struct
     field holds it.
   - Whole-`__text` Capstone scan for adrp+add / adrp+ldr computing
     the string VA: **exactly 2 hits — 0x17ddc and 0x17e08 — both
     inside the publisher** (register_check arg, notify_post arg).
   - arm64e slice, same scan: exactly 2 hits (0x18830, 0x1885c), same
     function.
3. **Package-wide registration census.** Enumerated every call site of
   every registration API that exists anywhere in the package —
   `notify_register_dispatch`, `notify_register_check`,
   `CFNotificationCenterAddObserver`, and
   `addObserverForName:object:queue:usingBlock:` — from the xref files,
   with each name argument statically resolved (table in §3).
   `notify_register_signal`, `notify_register_file_descriptor`, and
   `notify_check` are **not imported by any binary** in the package.
   **No site's name resolves to `com.anlai.omnicar/speed`.**
4. **Polling-consumer pattern** (register_check + get_state, no
   dispatch): every `notify_register_check` site in the package
   resolves to another name (§3), and a polling consumer still needs a
   registration call, which needs the name string — absent outside
   SpeedBubble (step 1) and referenced only by the publisher inside it
   (step 2). Closed.
5. **Dynamic construction.** Exhaustive census of every cstring
   containing `speed` in all 8 binaries, and every cfstring containing
   `omnicar` package-wide:
   - No `/speed` fragment, no `com.anlai.omnicar/%@`-style format
     string, no prefix/append pieces exist anywhere.
   - The only standalone cstring `speed` (SpeedBubble @0x2dfd1) sits in
     a data-field-key cluster — `maxspeed`, `max_speed`, `speed`,
     `currentspeed`, `current_speed` — i.e. source-app payload keys,
     not channel-name material.
   - The codebase's registration style (SPPDisplayBoot `sub_cc34`,
     CarPlayApp boot `sub_44a8`, all other modules) is literal-cstring
     registration only; there is no computed-name registration anywhere
     in the package.
6. **Unresolved-name observer sites, individually cleared:**
   - `_OMCCrashGuard` `addObserverForName:` @0x23500 / 0x23568
     (SpeedBubble's copy): the name arguments are GOT-imported system
     notification-name *variables* (UIScene/UIApplication lifecycle
     names, loaded via `ldr` from `__got`), not string literals — and
     the identical OMCCommon code ships in binaries that do not contain
     the `/speed` string at all. These are `NSNotificationCenter`
     registrations in any case, which Darwin `notify_post` does not
     deliver to.
   - `sub_5950` `addObserverForName:` @0x5e4c: name taken from an
     enumerated array of `UIScene*Notification` name objects.
   - `-[SPPBubble startOrientationTracking]` @0x1da20: UIDevice
     orientation `NSNotificationCenter` registration.
   - `PARTITION_A.txt` line ~115 lists `com.anlai.omnicar/speed` in a
     channel *inventory* sentence; adjudicated against the xref census
     — it is not a registration claim and no registration exists.
7. **Prefs bundle and app, checked specifically** (live-readout
   hypothesis): OmniCarPrefs contains no `/speed` string (only the
   `.demo` / `.resetlayout` names, which it *posts*), uses no notify
   registration for it, and its only Darwin post is
   `com.anlai.omnicar/prefschanged` @0x3f808. The OmniCar app binary
   contains no notify registration of any kind and no `/speed` string.

---

## 3. Candidate sites per binary (all registration sites; verdicts)

### OmniCarSpeedBubble.dylib — the only binary containing the string
`notify_register_dispatch` sites (all consumers in this binary):
| site | function | name | verdict |
|---|---|---|---|
| 0x4570 | sub_44a8 (CarPlayApp boot) | `…/speedbubble.opencar` | other channel |
| 0xcccc | sub_cc34 (SPPDisplayBoot) | `…/speedbubble.speed` | other channel (the internal packed-speed channel; consumer sub_cec4) |
| 0xccec | sub_cc34 | `…/speedbubble.demo` | other channel |
| 0xcd18 | sub_cc34 | `…/speedbubble.resetlayout` | other channel |
| 0xcd3c | sub_cc34 | `…/prefschanged` | other channel |
| 0xcd70 | sub_cc34 | `…/car.busy` | other channel |
| 0xce08 | sub_cc34 | `…/car.connected` | other channel |

`notify_register_check` sites: 0x529c `…/location` (SPPSpeedGPS,
publisher-side), 0x54ec `…/speedbubble.speed` (publisher-side), 0x6610
`…/speedbubble.source` (sub_65a8, consumer of the source channel via
get_state @0x65e8), 0xd0f0 `…/speedbubble.source` (publisher-side),
0x1cf24 `…/speedbubble.opencar` (publisher-side), 0x258b4 `…/lite`
(OMCCommon). **None names `…/speed`; the only references to that string
in the binary are the publisher's two (0x17ddc, 0x17e08).**

### OmniCarCore.dylib
register_dispatch: 0x47b4 `…/rescue`, 0x47d4 `…/car.connected`,
0x4868 `…/cleanram.now`; register_check 0xaf20 `…/lite`;
addObserverForName 0x4830 `…/url`, 0x70dc `…/log`. String absent.
**Verdict: no candidate.**

### OmniCarAppBridge.dylib
register_dispatch: 0x71bc `…/appbridge.apporient`, 0x71e0
`…/appbridge.keyboard`; register_check 0x684c / 0x6b1c (same two),
0x22098 `…/lite`; addObserverForName for `…/appbridge.orientation`,
`.key`, `.open`, `.frame`, `.shield`, `.close`, `.closeall`, `.knobs`,
`…/log`, `CarPlayIsConnectedDidChange`. String absent.
**Verdict: no candidate.**

### OmniCarSplitScreen.dylib
register_dispatch: 0x49fc and 0x48cac `…/prefschanged`;
register_check 0x158a0 `…/car.busy`, 0x53f5c `…/lite`;
addObserverForName for `…/appbridge.state`, `.handletap`, `.handledrag`,
`.baraction`, `.bardismiss`, `.knobtouch`, `…/splitscreen.native`,
`.ack`, `.ready`, `.kill`, `…/url`, `…/log`. String absent.
**Verdict: no candidate.**

### OmniCarStartupScreen.dylib
register_dispatch: 0x650c `…/startupscreen.weather.ready`, 0x75b8
`…/location`; register_check 0x6cc4 / 0x902c `…/startupscreen.style`,
0x1f978 `…/lite`; CFNotificationCenterAddObserver 0x754c
`…/startupscreen.audio.play`, 0x756c `…/startupscreen.audio.stop`,
0x7590 `…/startupscreen.weather.request`. String absent.
**Verdict: no candidate** (note: it consumes `…/location`, not speed).

### OmniCarCarProbe.dylib
register_check 0x8ecc `…/lite`; addObserverForName 0x5088 `…/log`.
String absent. **Verdict: no candidate.**

### OmniCarPrefs (bundle)
No notify registration calls; only Darwin post is
`…/prefschanged` @0x3f808, and posts of `…/speedbubble.demo` /
`…/speedbubble.resetlayout` (per its cstrings @0x63aa0 / 0x63ad8).
`/speed` string absent. **Verdict: no candidate — no live speed
readout in Settings.**

### OmniCar (app)
No notify/CFNotification registration sites at all. String absent.
**Verdict: no candidate.**

---

## 4. Final conclusion

**Consumer: NONE IN PACKAGE.** Within OmniCar 1.0.3,
`com.anlai.omnicar/speed` is a publish-only channel: `-[SPPBubble
setSpeed:]` (OmniCarSpeedBubble.dylib) maintains its notify state
(clamped speed, 0xFFFF = invalid, deduplicated, demo-suppressed) and posts
it, and no code in any of the 8 binaries — statically, through tables,
through polling, or through any dynamically constructed name —
registers for, observes, or reads it. Consequently there is no
consumer handler body to reconstruct, and no addendum source file is
produced by this trace.

The IPC map entry (`metadata/IPC_MAP.md` line 102) can be updated to:
publisher = SPPBubble `setSpeed:` (proven); consumer = **none in
package** (this trace).

**Interpretation (inference, marked as such):** the publish is most
plausibly an outward-facing surface for a component outside this DEB.
Two facts support reading it that way rather than as leftover debugging:
(i) the name is product-neutral (`…/speed`) unlike the feature-scoped
internal channel actually used inside the package (`…/speedbubble.speed`,
packed state, consumed by sub_cec4) — the internal need was already
served, so this second channel duplicates it for someone else;
(ii) the codebase demonstrably maintains cross-product channels — the
shared OMCCommon core reads the state of `com.anlai.omnicar/lite`
(`OMCLiteActive`, see `src/OMCCommon/OMCCommon_REPORT.md`), a channel
whose other endpoint likewise lives outside this module set. A future
version or a sibling anlai component remains free to register the name
and `notify_get_state` the clamped speed; nothing in 1.0.3 does.
