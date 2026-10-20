# Original OmniCar SOLO three-dot restore — SOURCE ONLY, no DEB

Approved requirement 2026-10-20: keep native destructive edge-close. When only the surviving app is SOLO, connect a visually identical native 3-dot control and provide an option to restore the previous two-app split. Do NOT replace edge drag with reversible Zoom or add a rescue/fullscreen button.

## Verified native ABI

- SCPCarSplit.closeSlot:background: v24@0:8i16B20 IMP 0x1d9b8
- SCPCarSplit.closeGoingHome: v20@0:8B16 IMP 0x21618
- SCPCarSplit.openSetupLayout:apps: v28@0:8i16@20 IMP 0x3ab7c
- SCPCarSplit.layoutID 0x11080, tabParent 0x366dc, soloHostedBundle 0x45bb4
- Original openSetupLayout code already contains inactive split activation, endHostedSolo, setPaneCount and openApp:slot:; this is the original re-entry path, NOT custom recreation of app hosts.

## Implemented source-only technique

Before native closeSlot deletes a two-pane split, save both ordered app bundle IDs, native layoutID and fractions. Also capture native surviving SCPCarPane.handle by CALayer rendering, preserving its actual dimensions, dots, border and colors. The existing pane.handle cannot be unhidden after solo clears pane.vc and container; a solo-owned copy is required.

After native closeGoingHome, attach a button displaying ONLY the original three-dot bitmap inside verified OmniCar tabParent (not UIWindow/system dock or other app view) if hostSolo or returned VC state is present. It opens one action 'Khôi phục chia màn hình', calling original openSetupLayout:apps: and attempting to restore original fraction array when native 2 panes have returned. This may relaunch an app closed by the original gesture. Reuses the 4-second idle and passive touch-to-wake policy. The solo three-dot is a **small matching button**, not a new full-screen control or unrelated skin.

## Honest limitations

No guarantee that tabParent remains a mounted native view after every solo path; no fallback onto other apps/system UIWindow. Separately hosted app touch events may bypass the passive owner gesture. It handles two-pane solo transitions; three-pane-to-two-pane remains native split. The original App/Zoom/Style/Close menu cannot be retained because native SCPCarPane and VC are destroyed; solo menu provides only restore. Actual CarPlay device QA is needed. Nothing compiled, packaged or published; source is staged for eventual ONE com.anlai.omnicar upgrade DEB.

QA: two app split, drag either side to edge, original remaining app still SOLO, same native-looking 3dot in content area, touch reveals for 4 sec, tap to show restore choice, select restores pair and ratios; check same app IDs and no Apple Dock/Home overlay, gestures, zoom, 4s split idle, repeat; test returned-VC and hosted-solo branches.