# OmniCar vs DuoFace — external hosted-app SOLO menu lifetime, 20/10/2026

**Purpose:** user explicitly clarified that "SOLO" here is an **unsupported external iPhone app shown on CarPlay by the tweak's integrated app-host/bridge**, after the native split UI is closed. It is **NOT merely one of two split panes enlarged with a focusSlot**. DuoFace retains an accessible application picker/menu over the external solo app, whereas OmniCar edge-close loses its 3-dot/menu. Preserve this distinction before any further code patch.

## A. Checked immutable source evidence

- OmniCar original `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`; source owner `OmniCarSplitScreen.dylib`. CI read-only original owner scan run [39375694111](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39375694111), job 118473200701 SUCCESS; persistent artifact `audit/OmniCar_original_solo_persistent_control_20261020.json`.
- DuoFace real native v12 `DuoFaceDashboard.dylib` SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`, extracted **read-only** from `chuongnguyen89dn-ui/Duoface` pinned commit `8ac3d5080b067a7462a106d4410fe5547f9bbc8c`, `dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb`. Immutable original disassembler `DuoFace/scripts/v12_host_recovery.py`. Comparative CI [39376213917](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39376213917) SUCCESS with exact extracted SHA verification and original selectors; saved `audit/duoface-external-solo/CBWindow_multitasking_pill_and_picker.txt`. **No DuoFace repository modifications.**

## B. TWO different DuoFace ways of opening a menu: do not conflate

1. **Native split pane focus:** `CBBridgedSplitApp.slotPills`, `CBSlotPillView.onPillTapped` -> `CBBridgeManager.showAppPickerForSlot:` (`0x27fee4`). Only **IF** currentApp is a `CBBridgedSplitApp` with valid `focusedSlotIndex`, the manager first calls `restoreSplitAnimated:NO` at `0x27ff80` then opens picker. This split-specific path was already documented by `Duoface/docs/duoface-v12-native-split-focus-20261014.md`.
2. **External app SOLO / own host-window menu:** `CBBridgeManager.showAppPickerForSlot:` does **NOT require currentApp to be a split**: when it is NOT a `CBBridgedSplitApp`, its focus/restore branch is skipped and control reaches `CBWindow.showAppPickerForSlot:` at `0x27ffdc`. `CBWindow` owns the CarPlay `_rootWindow` (`0x20`), `_rootViewController` (`0x28`), `_contentView` (`0x30`), `_multitaskingPill` (`0x38`) and `_multitaskingOverlay` (`0x40`). `CBWindow.createWindows` IMP `0xb1064` sets up a root CarPlay window/view controller/content and separate multitasking overlay; `CBWindow.show` IMP `0xb1d98` makes the `_rootWindow` visible. `CBWindow.showAppPickerForSlot:` IMP `0xb25e4` asks `multitaskingOverlay` for `showAppPickerForSlot:parentView:` at `0xb2668`. **This is the host-window-owned menu route to emulate in OmniCar**, not necessarily a `CBSlotPillView` callback. The mere existence of `_multitaskingPill` does not prove exactly when/how its visible button is created; that needs a fuller construction audit/runtime trace. It does prove the pointer is a `CBWindow` property, **not a split-pane-only field**.

## C. OmniCar original contrasting lifecycle

- Original continuous drag to edge calls `SCPCarSplit.closeSlot:background:` IMP `0x1d9b8` -> `afterPaneRemoved:` `0x1db48` -> `soloBundle:` `0x1e33c`; conditionally `hostSolo:` `0x3f9c0`, or transfers `vc` to a single-app presentation. This is **destructive edge-close, NOT reversible focus**.
- `closeGoingHome:` IMP `0x21618` clears pane VC and bundleID, `setActive:NO`, `setContainer:nil`, `setSlots:nil`, `setDividers:nil`; original `layoutBarForPane:` hides `pane.handle` when pane.vc nil. **This directly explains loss of original 3dot.**
- Original `SCPCarPane.soloButton` `0xfaa8`, `setSoloButton:` `0xfab0`, `SCPCarSplit.runSoloForPane:` `0x288c0`, `showSoloCoverForBundle:` `0x20d8c`, `soloCover` and `soloHostedBundle`, `soloReturnedVC`, `launcherHost` exist. But `SCPCarPane.soloButton` is still PANE-owned; original method existence alone **does not prove it survives closeGoingHome**. Other native presentation owners may persist, but their actual view/window/process association is not yet verified.
- Current Omnicar QA2/QA3 `solo/src/OmniCarSoloThreeDots.xm` copies the old `pane.handle` artwork + stores pair app IDs/ratio, then tries to add a button to `SCPCarSplit.tabParent` (or `soloReturnedVC.view`). When that old owner is unmounted during teardown, the new button never appears. A more accurate design is an **independent host-window-owned control** with an explicit presentation-owner lifecycle, like DuoFace `CBWindow`.

## D. Implementation decision / next verified gates

- Keep user-confirmed **Zoom and left-right Swap fully unchanged**. Keep actual edge-close destructive route (user previously rejected replacing it with a different fake fullscreen gesture).
- Capture exact previous app IDs and fractions **before** `closeSlot`, then **after** native `hostSolo/soloBundle` transition find the actual live view/window hosting that app, owned by OmniCar/SpringBoard CarPlay scene (verify `windowScene` / source process / root view owner). Attach a tiny **pass-through** three-dot UI to that owner independent of `SCPCarSplit.container`/old pane, with stable retention and cleanup when SOLO ends. User taps dot -> host-owned menu -> original `openSetupLayout:apps:` restore pair + fractions only after original split has reactivated. Idle 4s and touch reveal are separate requirements.
- **Avoid** hooking all `UIWindow`, adding a generic global covering window, using an unrelated Apple dock view, or directly invoking DuoFace private classes in OmniCar. Need exact scene owner, process and runtime availability for each native OmniCar solo branch (hosted vs returned VC) before choosing attachment. Add scoped logging for `closeSlot`, `soloBundle:`, `hostSolo:`, `closeGoingHome:`, `endHostedSolo` and `soloCover/launcherHost/soloReturnedVC` weak refs if static analysis cannot show runtime state; do not infer cross-process state.
- **No code fix/DEB/Sileo in this audit.** Current Sileo QA3 package is 1.0.3-omnicar3 (separately improves hosted-pane handle 4s opacity), public-verifier run 39375190490 SUCCESS, **not user-tested in this turn**; user-reported previous shortcomings remain open until genuine scene-anchored SOLO menu and real hardware QA.

## Current success criteria

1. SOLO launched by pulling divider fully to edge **continues showing external hosted app**, no second OmniCar split pane.
2. Host-owned `…` exists on top of SOLO despite split owner teardown, autohides at 4s, any app touch reveals again without interrupting app control.
3. Tapping it opens a working menu and **restores exactly the old two app IDs and fractions**. No stray 3dot on Home/Apple dock/after solo ends.
4. Existing Zoom/Swap remains working with map on either side; map and hosted YouTube controls obey 4s idle.

Keep this note plus exact CI source evidence as handoff. No secrets.
