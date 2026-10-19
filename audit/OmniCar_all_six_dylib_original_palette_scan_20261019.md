# FULL ORIGINAL OMNICAR DEB / SIX DYLIB UI COLOR SCAN

Scan date 2026-10-19. **Static extraction from ORIGINAL compiled binaries, no candidate DEB build.** Original package com.anlai.omnicar_1.0.3_iphoneos-arm64.deb SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd.

Scan method: extract all FAT Mach-O ARM64 slices in original DEB; disassemble original __text with llvm-objdump; parse relative ObjC `__objc_methlist` method names and `__objc_stubs` selector references to map real native ObjC calls to owner methods; inspect `colorWithRed:green:blue:alpha:` and `colorWithWhite:alpha:` float data-flow backward from d0–d3 including literal double loads and preserved d8–d15. Preserve unresolved branch values explicitly; do not extrapolate to specific shape without original setter/owner path.

## Summary by binary

| Original dylib | Confirmed style-related ObjC calls | Color constructors | Complete static argument sets | Theming status in SOURCE |
|---|---:|---:|---:|---|
| OmniCarSplitScreen.dylib | 272 | 90 | 82 | Existing native control COLOR-ONLY hooks updated; no new layers or geometry |
| OmniCarAppBridge.dylib | 155 | 53 | 46 | Palette extracted, no AppBridge hooks added yet |
| OmniCarSpeedBubble.dylib | 309 | 110 | 96 | Palette extracted, no speed-warning color changes applied yet |
| OmniCarStartupScreen.dylib | 226 | 75 | 53 | Palette extracted, no startup hooks added yet |
| OmniCarCore.dylib | 1 | 1 | 1 | No UI surfaces identified for skin |
| OmniCarCarProbe.dylib | 1 | 1 | 1 | No skin UI; exclude |
| **TOTAL** | **964** | **330** | **279** | **Static-first scan, not device UI QA** |

Unresolved **51** constructor argument sets (330-279) may contain context-dependent color decisions and branching and MUST NOT be treated as known exact RGB. All 964 invocations include CGColor/getter and other nearby style methods and are not all distinct color assignments. The original 15 PNG are separate app/Settings brand assets; no HTML/CSS or standalone CarPlay menu image atlas.

## Colors grounded to original library and owner method

**SplitScreen**: `newDividerAt:` #6E64C8 shadow; `showRatioMenuForDivider:` #4A4F80 native icon tint, native CONIC gradient #A78BFA → #60C5FA → #5EDDB6 → #F59AC0 → #A78BFA, shadow #9B87F8. `setupBarForPane:` native white(.35) background, white(.55) border, #4A4F80 button tint, red #FF5A5F original close/danger color. `buildPickerSheetForPane:` #6E64C8 shadow, #4A4F80 gradient. More detail and addresses in `audit/OmniCar_original_to_Titanium_color_calls_20261019.md`.

**AppBridge**: Native `buildBarForPane:` references #4A4F80 (4 constructors), #6E64C8 (2), #FF5A5F (1). `setupHandleForPane:` #4A4F80; `buildPanel` #4A4F80 (3), #6E64C8 (1). Overall AppBridge original colors additionally #9B87F8, #5DB4F6, #E8EAFA, white. These are candidates for matching accent/bg/foreground, but preserve original scene geometry and content; no source hooks added for this module yet.

**SpeedBubble**: Native `buildStyle:` / `renderStyle` create multiple palettes; #4A4F80, #A78BFA, #9B87F8, #60C5FA, #5EDDB6, #5DB4F6 appear as accents; other source hues #A6DDFD, #FEC4D8, #50/46/10, etc. Also warning red #FF5A5F, #E5262D and warning amber #FFB340 / #FFD58A. **Do not recolor speed/limit warning semantic red, amber, or green without explicit design and safety validation.** Current Titanium source does not hook SpeedBubble at all.

**StartupScreen**: Different startup scenes intentionally use distinct sky/vehicle/weather palettes, e.g. `ss_buildSky`: whites, amber #FFF0B4, #FFDC78, #B4BED2, #DDE6FF, darker #1E2837 and #0B0B0D. `ss_buildWelcome` has blue-white #A0D2FF; `ss_buildHud` #78DCFF / #AAEBFF, `ss_buildFestive` blue #3C5AC8 mixed with gold/amber colors. Not an existing unified Titanium theme; no native startup style hook written or activated yet. Scoped decisions required to avoid painting over user photo/video background and semantic overlays.

**Core / CarProbe**: no original skin-owned visual surface proven. Found only single #E8EAFA color construction in each, out of scope.

## Sourced per-library Titanium palette plan

| Original colors | Titanic COLOR-ONLY candidate | Notes |
|---|---|---|
| #4A4F80 (74,79,128) | #B5BDC5 icon/outline; #353D46 original surface | Role-based existing-color translation |
| #6E64C8 (110,100,200) | #78B9C8 accent/shadow | Preserve original alpha |
| #A78BFA / #60C5FA / #5EDDB6 / #F59AC0 original ratio selector conic gradient | #353D46 / #171B22 / #353D46 / #171B22 | Keep ORIGINAL conic type, locations, frames |
| #9B87F8 (155,135,248) | #B5BDC5 | Native border/shadow |
| #5DB4F6 / #6E78FF (blue UI) | #78B9C8 | Native focus tint |
| #EEF0FB / #E8EAFA pale original surfaces | #353D46 backgrounds, #F3F5F5 legible text | Role-dependent |
| #FF5A5F / #E5262D alert red, #FFB340 / #FFD58A amber | **UNCHANGED** | Preserve safety semantics |

Graphite Titanium target values: graphite #171B22, gunmetal #353D46, silver #B5BDC5, ice #78B9C8, offwhite #F3F5F5. **This is a palette conversion specification and code changes for original SplitScreen only**, not yet applied to Startup/SpeedBubble or app branding assets.

## Implementation / verification

- `titanium/src/OmniCarGraphiteTitanium.xm`: updated original-layer color transformation. No insertion of new gradient; native conic CAGradientLayer colors remapped in place preserving all geometry, type and stop positions; native CAShapeLayer fill/stroke, CALayer border/shadow remapped only if matching original values. Explicitly preserve red close/warning colors; original Home/logo and CarPlay dock excluded; Zoom size is a separate request.
- Picker app icon images stay unchanged. The same native ratio menu and pane control **template UIImageView tints** are eligible for existing UIColor recolor only, without altering image assets. Selected/normal/highlighted/disabled UIButton text states handled without resizing.
- `scripts/test_titanium_native_skin.py`: static regression rejects layer creation, new geometry/size, global UIKit hooks, Home/logo and automatic build. `.github/workflows/build-graphite-titanium.yml` intentionally **manual-dispatch only**.
- Counts and color palette above are from original compiled DEB (not generated preview). **No source for AppBridge/SpeedBubble/Startup compiled or painted; no CI build or on-device QA during this request.** Next phase: identify exact original class/UI hierarchy in these modules, then write their native color-only hooks. Do not overstate progress.
