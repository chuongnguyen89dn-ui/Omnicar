# OmniCar 1.0.3 COLOR CALLS → Graphite Titanium: source-only change

2026-10-19. **User explicitly: scan original DEB and apply Titanium COLOR edits to source, DO NOT BUILD/EXPORT DEB yet.** This commit MUST NOT automatically trigger CI.

## Verified ORIGINAL binary and scan

Original input com.anlai.omnicar_1.0.3_iphoneos-arm64.deb; SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd. Disassembly of ARM64 OmniCarSplitScreen dylib, original Objective-C selector references resolved from the native `__objc_stubs` and `__objc_selrefs`. Scanner reconstructed 6,111 ObjC method invocation selector callsites for 264 identified original methods. COLOR/SKIN subset: 186 style-related method calls, 90 `colorWithRed/White` constructors, 78 complete decoded channel sets; 12 constructions remain dynamic/branch-dependent and cannot be assigned a fixed color from this static scan. These counts refer to the original SplitScreen dylib only, NOT a claim to have completely decoded all six other plugins.

Reproducible local evidence (original DEB available to the current conversation): `/mnt/data/scan_orig_objc_calls.py`, `/mnt/data/omnicar_forensic/original_objc_selector_calls.csv`, `/mnt/data/omnicar_forensic/map_original_color_calls.py`, `/mnt/data/omnicar_forensic/original_color_callsite_map.csv`. This version of repo audit contains verified representative addresses; raw large CSV can be regenerated from source original DEB and the scripts, not inferred from image samples.

## Callsite-level OWNERS, original color and source role

| Original selector owner | Binary addresses | Native call/proven original channels | Replacement color role |
|---|---|---|---|
| `newDividerAt:` | 0x2c5b0–0x2c5c8 → `colorWithRed`, followed by `CGColor` and `setShadowColor:` 0x2c5fc | shadow RGB(110,100,200) #6E64C8 | ice accent #78B9C8 (shadow only) |
| `showRatioMenuForDivider:` | 0x2fafc → `colorWithWhite:alpha:` then 0x2fb14 `setBackgroundColor:` | native white alpha .95 (for menu element branch) | graphite #171B22, SAME alpha |
| `showRatioMenuForDivider:` | 0x303a0 `colorWithRed`, 0x303b8 `setTintColor:` | native RGB(74,79,128) #4A4F80 | titanium icon #B5BDC5 |
| `showRatioMenuForDivider:` | 0x305ac creates native gradient; 0x305e0 sets type, 0x3063c/0x3067c/0x306c0/0x30704/0x3073c creates colors; 0x30784 `setColors:` | original **CONIC** gradient RGB #A78BFA / #60C5FA / #5EDDB6 / #F59AC0 / #A78BFA | existing gradient stops → gunmetal / graphite / gunmetal / graphite / gunmetal; preserve conic type, positions, frame |
| `showRatioMenuForDivider:` | 0x307c0 creates shape; 0x307d4 `setFillColor:`; 0x30804 `setStrokeColor:`; 0x30844 `insertSublayer:atIndex:` | underlying CAShapeLayer style with stroke black, native shape | change only matched existing shape stroke/fill colors, do NOT add layer/rewrite path |
| `showRatioMenuForDivider:` | 0x30994 `colorWithRed` then 0x309cc `setShadowColor:` | RGB(155,135,248) #9B87F8 | titanium #B5BDC5 (preserve alpha) |
| `setupBarForPane:` | 0x22b64 → 0x22b80 `setBackgroundColor:`; 0x22c10 → 0x22c44 `setBorderColor:` | white .35 background; white .55 outline | dark graphite same alpha; silver outline same alpha |
| `setupBarForPane:` | 0x22cc8 / 0x22e50 / 0x22ed0 `colorWithRed` | RGB(74,79,128), used across native action button paths | titanium silver glyph/tint |
| `setupBarForPane:` | 0x23078 `colorWithRed` | RGB(255,90,95) #FF5A5F | **PRESERVED** red safety/dismiss action |
| `setBarVisible:forPane:` | 0x24810 → 0x2482c native white .35 background; 0x248f0 original RGB(74,79,128) | panel surface & action appearance | graphite and titanium |
| `buildPickerSheetForPane:` | 0x33c28 → 0x33c60 `setShadowColor:` | #6E64C8 native picker shadow | ice accent |
| `buildPickerSheetForPane:` | 0x33e48 / 0x33eac → 0x33f38 `setColors:` | #4A4F80 via native gradient colors | gunmetal stops |
| `buildPickerSheetForPane:` | 0x34024 / 0x340c8 native `colorWithWhite:alpha:` then `setBackgroundColor:` / `setBorderColor:` | white .35 background / white .70 border | graphite/silver, same alpha |
| `refreshHomeButton` | 0x4212c original RGB(74,79,128) | original Home/logo owner **EXCLUDED ENTIRELY** | untouched |

Additional confirmed original literal colors in `OmniCarSplitScreen.dylib`: #A78BFA, #60C5FA, #5EDDB6, #F59AC0, #9B87F8, #6E64C8, #4A4F80, #5DB4F6, #6E78FF, #EEF0FB, #E8EAFA. Preserve #FF5A5F alert/dismiss semantics. Do not indiscriminately swap UIKit's all-system `UIColor` calls.

## Exact changes to color source, no geometry

Modified `titanium/src/OmniCarGraphiteTitanium.xm`: removed generic `OMTSurface` and **removed injection of new CAGradientLayer**. Instead `OMTTranslate` matches only verified original native RGB values and role (surface/gradient/ink/outline/shadow), retains native alpha, applies replacements **to existing UIColor, native CAGradientLayer.colors, CAShapeLayer fill/stroke, CALayer border/background/shadow and OmniCar text/tint where original values match**. Colors Graphite #171B22, Gunmetal #353D46, Silver #B5BDC5, Ice #78B9C8, White #F3F5F5. Native per-control class-scoped hook only (`SCPCarSplit` original selector owners). Excluded original Home/logo, Apple dock, app content. Native conic gradient/type/direction/locations unchanged. No frame/bounds/shape/cornerRadius/borderWidth/lineWidth/gesture/action changes. Zoom addon remains separate and unmodified by this COLOR-ONLY work.

Added regression test asserting native palette and forbidden layout modifications. **Set `.github/workflows/build-graphite-titanium.yml` trigger to `workflow_dispatch` ONLY**, specifically to respect user's **chưa đóng deb**. Do not trigger the workflow manually without request. `titanium/control` package currently unchanged at compiled v0.2 because no build has been made; next version bump only when build is requested.

## Limitations before on-device QA

This is **source-level color translation**, not a compiled binary result and not evidence of actual CarPlay colors. Native dynamically computed colors/12 unresolved constructors and other libs AppBridge/SpeedBubble/Startup are not fully mapped in this pass. Native UI must still be compared when user later approves testing, but no user measurement or SkinProbe is currently required to edit colors.
