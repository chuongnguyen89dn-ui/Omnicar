# IMPL — AutoHide, ABHost side (applied fade on the hosted mirrors)

Strand: ABHost (SpringBoard, OmniCarAppBridge + AppBridgeB mirror).
Spec: `design-autohide.md` §2 (esp. §2.2/§2.3/§2.4/§2.5) + §5.2.
Status: **source complete; static gates PASS; module builds clean
locally. Device verification pending** (rides the combined AutoHide
car session; nothing about this strand is device-proven yet).

## What was implemented

ABHost never decides fade. It applies the keys the CarPlay owner
rides on the packets it already sends, and reports the APPLIED fact
back through the BridgeWake snapshot:

| Surface | Key | Applied to |
|---|---|---|
| `appbridge.open` / `appbridge.frame` userInfo | `fade` | `ABPane.handle`, `ABPane.handleHit` |
| `appbridge.knobs` userInfo (beside `knobs`) | `kfade` | every live `ABKnobView` in `self.knobViews` |
| `bwAppliedSnapshotForBundle:` result | `faded` (new) | reads the per-bundle APPLIED record |

Missing key = NO (`[nil boolValue]`) → no fade, fail-open to visible,
identical behaviour to the pre-AutoHide host; every later packet
re-sends the key, so the host cannot stick in a stale fade (§2.4
self-healing). The `handle` flag was never touched — it keeps its
geometry meaning (`!CGRectIsEmpty`); fade rides its own key (§2.2).

## §5.2(i) choice: separate apply method

The design offered two options for computing `nativeVisible`: extend
`setFrame:`'s ABHostBMethods part, or a separate `-applyFade:forPane:`
reached after the frame packet is applied. **Chosen: the separate
method** — the brief forbids editing `setFrame:`'s body, and the
method can read the APPLIED native truth directly:
`nativeVisible := pane.handleHit && !pane.handleHit.hidden`, which is
exactly the result of the last `setFrame:`'s
`setHandleVisible:(handle && !collapsed)` call for that packet.

## Files changed (both trees, `cmp` identical)

`ABChannels.m` (596 → 683 lines) and `ABHostBMethods.m`
(1582 → 1753 lines), in `project/OmniCarAppBridge/` and mirrored to
`src/AppBridgeA/src/ABChannels.m` / `src/AppBridgeB/ABHostBMethods.m`.

### ABChannels.m — additions + one registration call

- Category declaration `@interface ABHost (AutoHideApply)` (the three
  methods live in ABHostBMethods.m; ABHost.h predates the feature —
  same precedent as the BridgeWake category).
- Forward declaration `AHRegisterHostApply` + its call in
  `ABHostProcessInit`, inside the existing SpringBoard branch next to
  `BWRegisterHostConfirm()`. This is the ONLY modified pre-existing
  line in either file besides the snapshot comment (see diff census).
- New §6 at end of file: own observers on the three channels
  (`AHObserveFadeChannel`) + close/closeall hygiene observers.
  **Deviation, forced by file scope and identical to the wake
  round's:** the LIVE frame/open/knobs handlers are in
  `ABHostGeometry.m` (ABFrameBlock/ABOpenBlock/ABKnobsBlock), which
  is outside this strand's files; the #if 0 reference copies inside
  ABChannels.m are dead. So — exactly the §5 BridgeWake pattern —
  this TU registers its OWN observers on the same distributed
  notifications and takes one extra main-queue hop, so the
  registrar's handler (enqueued in the same delivery round) has
  applied the packet before the key is handed to ABHost. The
  close/closeall observers deliberately run WITHOUT the hop:
  restore-before-teardown is best-effort (see teardown note below).

### ABHostBMethods.m — additions + the one sanctioned key

- Strand statics block inserted before `bwAppliedSnapshotForBundle:`:
  `AHHostSavedOpacities()` (NSMapTable, weak view keys / strong
  values — QA19's shape), `AHHostFadeByPane()` (owner-requested),
  `AHHostAppliedFadeByPane()` (APPLIED fact), `AHHostKnobFadeState`,
  and the paint/restore helpers `AHHostPaintView` / `AHHostRestoreView`.
- `bwAppliedSnapshotForBundle:`: return dict gains
  `@"faded": @(AHHostPaneAppliedFade(bundleID))` — a read of the
  APPLIED record, never a recomputation from owner keys (§5.2). Its
  doc comment was extended by two lines to name the new key.
- Three new methods after the snapshot (bodies are new code only):
  - `-applyFade:(BOOL)fade forPane:(ABPane *)pane` — if
    `!nativeVisible`: restore both handle views, record requested =
    applied = NO (**QA19's stop rule**, §5.2; the packet that
    revives the handle carries the key again). Else fade → paint
    handle + handleHit, applied = YES; !fade → restore both,
    applied = NO. Logs `[autohide] host fade applied|restored
    bundle=%@` (OMCLogWrite "AppBridge") on applied transitions only.
  - `-setKnobsFade:(BOOL)fade` — paints/restores every view in
    `self.knobViews`. Called after the registrar's `setKnobs:`
    reconcile (one hop), so knobs BORN by that reconcile are painted
    in the same pass; on restore it also sweeps the save table for
    any `ABKnobView` reconciled away while faded that still holds a
    saved opacity. Logs knob transitions.
  - `-ahRestorePaneForBundle:(NSString *)bundleID` — teardown
    hygiene: restores the pane's handle saves and clears its fade
    records. If teardown wins the race the lookup just misses: the
    weak-keyed save table self-cleans with the dead views and a
    re-open builds fresh handle views at full opacity, so an
    opacity-0 view cannot leak into a later session.

## Painting discipline (§2.5) — verified in the added lines

- `layer.opacity` is written in exactly two places, both helpers:
  `AHHostPaintView` (saves the view's current opacity first — only
  if no save exists, so the FIRST save is always the true original —
  then sets `0.0f`) and `AHHostRestoreView` (restores the saved
  value verbatim, drops the save). No animation in either direction.
- Zero assignments to `.hidden`, `.alpha`, or `userInteractionEnabled`
  in any added line (grep over the full diff's `+` lines: NONE).
  Faded handles keep live hit targets — that is what makes the
  wake-touch work. (`handleHit.hidden` is READ in applyFade: — it is
  the applied nativeVisible truth, not a write.)
- Documented exclusions untouched (§2.3): home button (no process
  surface in ABHost), tray/bar/logo (SpringBoard has no view for
  them), solo panes (hostSolo:'s hand-built dict carries no `fade`
  key → reads NO → no paint, matching §4.1 suspension).

## Gates

**Forbidden-body hashes** (signature → first `^}$`, SHA-256;
captured BEFORE editing; identical in both trees, and identical to
the values the wake round published for the same bodies):

| Body | Before = After |
|---|---|
| `setFrame:forApp:live:handle:passInsets:` | `8606f40a1ebf5ecad131ae276a227220a02c0e20c2a2c5c1ec2dbef0398341ef` |
| `setBarVisible:pop:dim:single:forApp:` | `3044b10d090281f54db3271da2117c36c69c8e616cda24d2485f5877f812ba38` |
| `setHandleVisible:` | `409cfb1447cb968976562e6a2e2a6f28cec7cdb6d1e13cb3e6f5ad1a27208a58` |
| `setKnobs:` | `b98a9f2611e0ef11849d0b4d26a2cb9209892eb31cc9cb526c340f1b7b41ecc4` |

`setKnobs:` still contains no `layer.opacity` write of its own —
the design's static gate on that body holds.

**Diff census** (vs the wake1-synced copies in push9-clone, which the
baseline hashes prove were byte-identical to the pre-edit tree):
ABHostBMethods.m +173/−2 — the two removed lines are the snapshot
doc-comment lines extended to name `faded` (the return-dict change
itself is a pure insertion). ABChannels.m: one removed line — the
one-line `if (…) BWRegisterHostConfirm();` became a braced block
adding the `AHRegisterHostApply();` call. Everything else in both
files is pure insertion. Mirrors: `cmp` identical in both trees.

**Build** (toolchain verified intact first — clang-18, ldid, ld.lld
symlink, SDK 16.5 all present; no fix-toolchain run needed):
`make clean && make` in `project/OmniCarAppBridge`, exit 0, 0
errors; ABChannels.m 0 warnings; no warning references the new code
region of ABHostBMethods.m (remaining warnings are the pre-existing
category/nonnull set). The built dylib contains the three new IMPs
(`-[ABHost(ModuleB) applyFade:forPane:]`, `setKnobsFade:`,
`ahRestorePaneForBundle:`), the `kfade` and `faded` key strings, and
the `[autohide] host …` log formats.

## Scope notes for integration

- Design §5.2 also lists, under the ABHost heading, the
  `ABChannelNames.m` constant for the new `act` channel and
  `BWTypeAct = 5` in AppBridge's `BridgeWakePack.h`. This strand's
  brief covers only ABChannels.m + ABHostBMethods.m, and ABHost
  never consumes `act` (activity is the owner's input) — those two
  items belong to the ABInApp / integration strands; both
  BridgeWakePack.h copies must still end up identical.
- Until the CarPlay strand lands the sender side (`fade` in
  `hostFrameInfo`, `kfade` in `publishKnobsNow`), every packet reads
  fade = NO and this host behaves exactly like the wake1 host —
  safe to integrate in any order.
- The wake ack now carries `faded`, which is what lets the owner's
  HIDDEN conjunction (§3.3: `barHidden ∧ fadedEffective`) confirm
  against APPLIED state instead of assuming the paint happened.
