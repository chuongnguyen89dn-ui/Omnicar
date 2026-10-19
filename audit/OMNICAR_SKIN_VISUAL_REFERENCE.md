# OmniCar original skin UI — visual guide from user's real screenshots

Date 2026-10-19. **Visual explanation only. No editable DEB/source code or Sileo modifications.** Hard limitation already approved: theme ONLY OmniCar-owned UI. Do not modify system CarPlay status/dock or third-party app contents.

## User complaint and delivered illustration

User requested direct, close-up pictures *inside the chat* rather than text/CSV alone: "Ko tập trung chi tiết các hình ảnh tại đây đc sao? Tôi ko hình dung đc nó là ntn". Three static annotated PNGs were created from the user's ORIGINAL CarPlay photographs, not AI-invented UI:

1. `/mnt/data/omnicar_skin_visual_guide/01_tong_quan_omnicar_anh_that.png` — photo of normal split Map+YouTube, labels 1..8: native three-choice selector, circular split knob, two pane three-dot pills, addon Zoom button, pane border/divider, Apple dock (EXCLUDED), YouTube content (EXCLUDED).
2. `/mnt/data/omnicar_skin_visual_guide/02_chi_tiet_cac_nut_omnicar.png` — 8 enlarged *photo crops*: three-choice selection, round handle, three-dot capsule, addon Zoom, native floating toolbar, three-dot+popup bar, mini floating window, split seam/border.
3. `/mnt/data/omnicar_skin_visual_guide/03_menu_noi_va_phan_khong_duoc_sua.png` — annotated photo of native popup bar/float scene and system dock excluded from theme.
4. `/mnt/data/omnicar_skin_audit/skin_original_assets_contact_sheet.png` — 15 original PNG file sheet (Settings/app branding only), previously generated.

**Privacy/storage caveat:** all four images are user-photo-derived. They were displayed as verified `sandbox:/mnt/data/...` links in the conversation but **not uploaded publicly to GitHub**, to avoid publishing user photographs/map context. These runtime files are not guaranteed available in future fresh environments. Original user photos are already attached within current project conversation; no photos repackaged into code repository.

## Labels / exact photo sources for future reconstruction

- Overview/crops source: `omnicar_current_landscape.png`, user screenshot (~1536x1152) already present as chat attachment. The true fullscreen/cropping original provides native menu from native OmniCar 1.0.3 and a large v0.5-looking Zoom addon. **Do not claim it depicts current v0.7 visuals**: it is the older photo used purely to identify ownership.
- Float bar/photo: `IMG_AA07BECB-075D-4FC3-BA67-D30775394A46.jpeg` rotated 90 degrees, cropped to center.
- Note that the colorful speed-limit circles overlapping map from other screenshot may be third-party GOFA or external overlays; they have not been definitively attributed to OmniCar. Avoid labeling them as native speed-bubble without a runtime check.
- Blue/teal labels mean OmniCar-generated view; lilac labels mean custom Zoom addon; amber mean Apple CarPlay dock / third-party UI, strictly excluded.
- The native UI's *actual owner selector* list and 22 allowed groups are preserved at `audit/OMNICAR_SKIN_MASTER_INDEX.md` and `audit/OMNICAR_SKIN_SURFACE_MATRIX.csv`, with original 15 PNG manifest at `audit/omnicar_1.0.3_assets.csv`.

## UI breakdown illustrated

| Native/UI widget in photographed screen | Skin-only variation that is technically possible, pending runtime proof |
| --- | --- |
| 3-button panel selecting split ratios | panel gradient, highlight ring, symbol ink, shadow, blur |
| Divider's white-and-blue round knob | visible-circle color, border, dot, shadow; drag/touch region retained |
| Per-pane vertical/horizontal three-dot capsule | capsule fill, three dots, line border/opacity; do not hook auto-hide here |
| Large custom Zoom circle | colors, diameter, glyph stroke; native Zoom action from 0.5 must remain |
| Thin border/seam dividing panes | border opacity, stroke, corner radii; no geometry change |
| Native full-pane and floating toolbar | pill glass material, in-menu icon, border and selected state; preserve all native actions |
| Floating preview mini-window | frame outline, corners, shadow; do not change the app-owned content |
| Apple dock and YouTube/Maps scene | **NEVER THEME**; not OmniCar-owned interface |

The contact sheet does not display the live controls: original DEB has only 15 packaging/Settings images, not ready-made skin graphics for popup/knob/divider. Other components (SpeedBubble and StartupScreen) are procedurally rendered in native dylibs, so need real screenshots from those states for comparably accurate photographic callouts, not invented mockups.

## Current status
- Visual annotation files created and manually opened/checked in the container; links supplied in conversation.
- Existing source/addon 0.7.0 kept intact (no rescue, no screenshot-based programming change).
- No theme palette approved; no theme compile/test on car; no release/Sileo action.
