# OmniCar theme art direction shortlist — UNAPPROVED

Date: 2026-10-19. Scope: **only OmniCar-drawn UI plus package-owned logos, backgrounds, and themed graphical assets.** This is design research, NOT an implemented theme or CarPlay real screenshot.

## Status / explicit user decisions
- Latest user feedback: **"Tôi vx chưa chốt đc cái theme nào ra hồn"** (has not chosen any worthwhile theme). No palette is approved. Do not present a random AI render or selected theme as accepted.
- Previous user directive: focus on **all skins including logo and multiple themed backgrounds**, not isolated button recolors. Current focus is theme design; **pause Force Dark Mode**, which is a distinct later feature.
- Strict existing boundary: do not alter Apple CarPlay system dock/statusbar/launcher or UI/content of YouTube/Maps/Waze/GOFA, no geometry/action/gesture changes. Preserve v0.7.0 Zoom functional base with **no 0.6 rescue button**.
- Rejected demos before this discussion changed the entire CarPlay scene or invent UI; do not use as canonical source. User also requested genuinely original/runtime-captured screens, not speculative reconstruction.

## Cohesive design directions — DISCUSSION OPTIONS ONLY, not approvals

Each candidate must be demonstrated on the *same real OmniCar CarPlay screenshot*, only recoloring OmniCar-owned controls while keeping app and Apple chrome pixels untouched, and on a separate asset/brand board for owned logos and splash/backgrounds.

### A. Obsidian Burgundy — executive luxury (red/black, NOT neon sports)
- Core palette: obsidian `#101216`, burgundy `#762638`, champagne accent `#BFA578`, ivory foreground `#EDE9E3`, subtle dark panel `#242128`.
- Materials: smoky black glass for **OmniCar-owned** floating menus; subtle lacquer burgundy active controls; champagne hairline border. No bright glow and no bright saturated red behind text. Optional extremely fine leather/velvet texture on OmniCar start background only, **not** behind maps/video/host app windows.
- Logo system: restrained geometric Omnicar `O` monogram, wine-black or champagne stamped metal, one-color variant for small icons; app icon logo exactly scaled. Backgrounds: clean splash with logo, muted gradient behind OmniCar picker/sheets and solid/glass fallback on tiny menus; never wallpaper the native CarPlay dock or hosted app scene.
- Appropriate if user wants tasteful luxury and earlier red-black preference. Need day-mode text contrast review.

### B. Graphite Titanium — OEM premium, understated technology
- Core palette: charcoal `#171B22`, gunmetal `#353D46`, titanium `#B5BDC5`, subdued ice-blue `#78B9C8`, off-white text `#F3F5F5`.
- Materials: satin/brushed aluminum bordering, smoked semi-transparent glass, thin cool highlights, minimal shadows; avoids decorative red glow. OEM-like icon strokes and consistent small-control contrast.
- Logo: silver metallic OmniCar `O` or division emblem, monochrome light/dark variants for small sizes. Backgrounds: dark graphite gradient for OmniCar startup, subtle brushed texture only in large OmniCar-owned panels and splash, none over map or YouTube.
- Appropriate if matching a Mazda/CarPlay dashboard coherently matters more than visual impact.

### C. Grand Touring Walnut — elegant cabin warmth
- Core palette: espresso `#201A19`, saddle `#6C4535`, satin bronze `#BD956A`, parchment `#EADDC9`, charcoal `#25201D`.
- Materials: warm tinted glass controls, soft bronze edge, matte leather textures used **only** on startup/sheets owned by OmniCar. Very light walnut grain only on large backgrounds, never on small controls, to avoid visual clutter.
- Logo: gold/bronze monogram, debossed cream/brown app icon variant. Backgrounds: executive espresso-to-saddle ombre in startup and OmniCar-specific full panel areas.
- Appropriate for a more original interior-style theme, but requires contrast check under bright sunlight.

## One theme must be a complete coordinated asset family

For whichever theme the user *eventually* approves, prepare:
1. Visual identity: primary/secondary logo, logo dark/light/monochrome, app icon, Settings/package icons at exact existing dimensions (@2x/@3x).
2. OmniCar-owned backgrounds: startup splash image, splash gradient, native OmniCar-owned popup/picker/tray background/texture variants (including low-texture fallback); DO NOT paint system CarPlay or the third-party app scene.
3. OmniCar split UI: 3-choice ratio selector, central circle, three-dot pills, home/two-square OmniCar button, divider, borders, pane menu, floating window outlines.
4. OmniCar AppBridge-owned controls and keyboard, where view ownership confirmed at runtime.
5. OmniCar native speed bubble and HUD warning variants, retaining road-readable contrast.
6. Addon v0.7 Zoom ring, fill, and legible glyph; do not change actions, positions or hit target.
7. Daytime visibility vs night-time, selected/pressed/disabled states, minimum symbol/contrast/blur guidelines.

## Visual QA gate — before implementing any code
- Provide 3 **side-by-side photo-edit concepts based on the exact same user-supplied REAL CarPlay screenshot**, with an immutable background for system dock and hosted apps.
- Concepts must be clearly labeled as *edited concept*, **not** original runtime pixels, and should use precise mask areas known to be OmniCar-owned. Prefer near-zero modification of unidentified UI areas.
- Provide a separate identity/background board (logos, startup wallpapers and material swatches) because these are design assets, not present in the live split controls.
- Ask user to evaluate which direction is closer and what is unsatisfactory. **Do not assume any is selected.**
- Only after approval translate the theme into tokens in `skin/omnicar_tokens_template.json` and scoped UI style hooks, ship independent test DEB with CI. **No Sileo changes.**

## Current repo state
- Latest known functional addon v0.7.0 remains unchanged; no new skin source, imagery, DEB, build, deploy or live device test in this design note.
- This design note is a design brief; **hex colors above are proposals, not recovered original colors or approved final values**.
