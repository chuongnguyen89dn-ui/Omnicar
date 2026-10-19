# OmniCar original 1.0.3 DEB — comprehensive skin resource inventory

Date: 2026-10-19. STATIC AUDIT ONLY. Original DEB and current 0.7.0 addon unchanged; no Sileo publishing.

## Source and complete extracted file count
- Original input: com.anlai.omnicar_1.0.3_iphoneos-arm64.deb
- Verified original SHA256: d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd
- Original DEB size: 1,306,228 bytes.
- Extracted regular files: **176**; **15 PNG**, **139 translation .strings**, **14 .plist**, **6 .dylib**, **2 executables** (OmniCar app and OmniCarPrefs binary).
- No separate .car catalog, .xcassets, .svg, .jpg, .jpeg, .webp, .gif or .heic files in package.
- Direct binary scan for PNG and JPEG magic in all 8 Mach-O files found zero embedded raw PNG/JPEG signatures. This does not rule out procedural or compressed resources of other forms.
- All fifteen PNGs decode as RGBA; grouped into **six logical image families**. Full paths, pixel dimensions, size and SHA256 appear in [omnicar_1.0.3_assets.csv](omnicar_1.0.3_assets.csv).

## All image families (Settings / app icons, NOT the visible CarPlay split skin)
| Family | Sizes found | Purpose |
| --- | --- | --- |
| AppIcon60x60 | @2x 120x120; @3x 180x180 | Icon of standalone OmniCar.app |
| PackageIcon | 256x256 | Package icon in OmniCarPrefs.bundle |
| icon | 29x29, 58x58, 87x87 | Main Settings row icon |
| logo | 64x64, 128x128, 192x192 | OmniCar branded logo in preferences |
| SpeedBubbleIcon | 29x29, 58x58, 87x87 | Icon for settings feature, NOT live speed bubble face |
| StartupScreenIcon | 29x29, 58x58, 87x87 | Settings feature icon, NOT animation frames |

All 15 actual images are compiled into a visual contact sheet in the active container at /mnt/data/omnicar_skin_audit/skin_original_assets_contact_sheet.png. The contact sheet is TEMPORARY, not claimed saved to GitHub; the CSV and committed script allow reconstruction from the original DEB.

## UI rendered at runtime: ownership and skin mechanism

| Feature to theme | Actual binary; UI classes and selectors confirmed by strings/ObjC metadata | Rendering & scope |
| --- | --- | --- |
| Split screen pane borders/divider/round knob, 3-layout ratio selector, three-dot buttons, popup toolbar, floating window, home/two-square icon and tray | OmniCarSplitScreen.dylib; SCPCarSplit, SCPCarPane, SCPCarSplitView, SCPCarDividerView, setupBarForPane:, layoutBarForPane:, showRatioMenuForDivider:, refreshHomeButton | Created via UIView, UIButton, UIBezierPath, UIColor, CAShapeLayer, CAGradientLayer. Re-theme UI objects/layers; no matching PNG resource to replace. |
| App Bridge side controls / keyboard / interaction panel | OmniCarAppBridge.dylib; ABBarButton, ABBoxView, ABKnobView, ABPane, ABKeyboard, ABShieldView | Dynamically rendered controls and system symbols. Do not alter app scene scaling/touch mapping when applying a skin. |
| Live HUD speed bubble and speed-limit badge (9 look modes) | OmniCarSpeedBubble.dylib; SPPBubbleView, SPPGlassView, SPPSignView, SPPIconView, methods buildStyle:, renderStyle, applyColors | Live gradients, shape paths, texts, symbols and app icon from installed app; no nine image assets in package. |
| Startup animations, vehicle/gauge/weather UI | OmniCarStartupScreen.dylib; SSCanvasView, SSGauge, SSSplash, SSStartupView | Live Core Animation/Bezier paths, gradients, SF Symbols. Optional user video/photo comes from the device, not this package. |
| Settings UI and categories | OmniCarPrefs.bundle/OmniCarPrefs, Root.plist and Feature...plists | PreferenceLoader cells using labels, icon paths and featureSymbol / symbol properties. Some use built-in SF Symbols. |
| Shared low-level drawing functions and default preferences | OmniCarCore.dylib | CoreGraphics color/gradient functions, settings; not a separate bitmap theme. |
| Connection/status probing | OmniCarCarProbe.dylib | No relevant skin controls identified. |
| Standalone iPhone app entry | Applications/OmniCar.app/OmniCar | Bundled app icon, basic view layout. |

App screenshots also include Apple CarPlay dock/status bar, Google/Vietmap/Waze maps, YouTube and other hosted-app content. These pixels do NOT originate as assets in OmniCar's DEB. Only the enclosing OmniCar controls can be re-skinned safely from this project.

## Feasibility and safe implementation

Full **OmniCar-only** skin replacement is feasible with a separate theme layer using targeted hooks to the app-specific classes, not simply swapping PNG files. Build a shared theme definition with text/icon size, color palette, gradient stops, corner radius, border/shadow, and contrast, then hook the creation/layout path for each native control. Preserve all existing actions, gesture recognizers, viewport sizes, pane geometry, dock-state handling and the existing menu Zoom 0.7.0. A system-wide UIColor/UIView modification could affect iOS and other apps; do NOT do that.

An initial skin pass should target SCPCarSplit UI (3-choice panel, circular knob, floating menu, small dots, borders) because that is what the user has been evaluating visually. The 15 Settings icons can then be updated separately. The 9 HUD styles and startup screen require procedural style support, not 9 replacement PNGs.

## Reproduction and checks actually performed

In environment /mnt/data:
1. sha256sum original DEB PASS.
2. dpkg-deb -I then dpkg-deb -x into /mnt/data/omnicar_skin_audit/extracted PASS.
3. Python pathlib counted all extracted files and extensions; Pillow decoded every PNG and measured sizes/mode.
4. plistlib successfully parsed PreferenceLoader Root and feature plists, including featureSymbol and symbol settings icons.
5. strings -a ran against all 6 dylibs, plus app and preference executables to inventory class names, UI rendering classes and style selectors.
6. Scanned each Mach-O for PNG/JPEG signature occurrences; zero observed.
7. Tested local equivalent of the committed scripts/audit_skin_assets.py to regenerate file manifest plus optional contact sheet. Only static file auditing; NO skin DEB produced or tested on device.

Re-run on another machine:
- dpkg-deb -x ORIGINAL.deb /tmp/omnicar-original
- python3 scripts/audit_skin_assets.py --root /tmp/omnicar-original --out /tmp/omnicar-skin-audit

**Next decision:** Before changing code, agree what skin scope and visual style are wanted. Default should preserve current 0.7.0 Zoom and not touch the native app contents or Sileo.
