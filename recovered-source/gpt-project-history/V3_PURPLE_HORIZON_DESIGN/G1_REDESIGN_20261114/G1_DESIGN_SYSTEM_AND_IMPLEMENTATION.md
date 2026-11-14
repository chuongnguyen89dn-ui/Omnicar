# DUOCAR V3 — PURPLE HORIZON / ORBIT & HORIZON — G1 COMPONENT SPECIFICATION
2026-11-14. Design owner: GPT. Implementation owner: Muse. Device acceptance: Nguyen.
STATUS: **23 new original vector composition artboards, mapping of 112 IDs and code contract DELIVERED; G1 awaiting Nguyen visual approval; runtime source / DEB / device PENDING.** No false claims of full functional proof.

## Why this is a new interface, not a color change
- **CarPlay:** old 5-button horizontal row → new **five 72-degree wedge radial control**; after selecting a function, **live slot target cards** appear under it, then call existing selector/handler. Center uses ORIGINAL purple italic D asset, unchanged. Old bar remains a rollback. Home one tap shows wheel (after protected seam approval), not iPhone settings. Native and hosted share ONE window/presenter in CarPlay.
- **Picker:** old unlabeled icon grid + narrow side column becomes **decision-oriented picker**: slot selector, display/source filter, independently selected candidate, Apply / Cancel. New visual hierarchy in exact original outer geometry; not the full-screen poster. A3 source catalog contains only \`id/name\`, so **NO invented genre filters**. Use \`Tất cả / CarPlay / Đã chọn\` (user approval needed because reference image names genre chips). Root panel must be opaque #100923 to avoid pane1/pane2 blur mismatch; do not blank underlying app.
- **CarPlay layout:** replace old anonymous ratio glyph/chips by **visually differentiated diagram presets** with true selection state; keep existing ratio menu container height 42pt and its original placement; 23 SVG may use scale-enlarged detail views for readability, NOT geometric authority.
- **iPhone:** old \`UITableViewStyleInsetGrouped\` navigation/list hierarchy becomes **new information architecture**: command dashboard with hero, split diagram, bento quick cards; layout canvas and preset chips; app catalog grouped tiles, live source; device metric tiles; customize visual workshop; Guide step timeline. Keep five root destinations \`Dashboard / Bố cục / Ứng dụng / Thiết bị / Tùy chỉnh\`. Retain underlying existing controllers, pref keys, action route and accessibility. A pure recolor of cells is automatic visual FAIL.
- **Brand:** one locked asset D italic purple. Night purple #070416 / #100923, lavender rims #DBB9FF, violet accent #A16EFF, content not faked; no other D drawn by AI.
- **Protected:** do not repaint external native/hosted app content, Apple CarPlay Dock/Home buttons, media chosen by user, Lề plugin, thermal safety red #FF0610, scene/window/Telex.
- **Proof:** every UI-owned surface is traceable to a P0 ID and one of 23 artboards; every actual call to existing function is covered by tests on the installed DEB. Until then "100%" is a **coverage design target**, never a device result.

## Design token single source of truth
| Token | Value | Usage |
|---|---|---|
| background.root | #070416 | only DuoCar-owned backgrounds |
| background.innerSheet | #100923 alpha 1 | picker/selector consistent native+hosted |
| face.base | #1B1138 | main surfaces |
| face.raised | #28194D | selected/raised controls |
| state.selected | #A16EFF | selection, gradients |
| stroke.lavender | #DBB9FF | interactive focus/hierarchy |
| text.primary | #F5F0FF | contrast |
| text.secondary | #C7B8E4 | secondary |
| state.danger | #FF4757 | destructive X; preserve thermal #FF0610 separately |
| state.success | #8DE5C9 | grounded success status only |

Typography system: Header 28/22 (CarPlay), large title 31 (iPhone), section 15–18, supporting 12–14; actual Dynamic Type measure and line fitting before G2, no hardcoded text outside safe. Cards corners 18–28 (new DuoCar elements only); existing pane/ratio/picker bounds/corners from G0 take precedence. Motion proposed 180–240ms easing, respect Reduce Motion; 4s old bar timer preserved as fallback, no duplicate radial hide timer; expand/deactivate should not animate through a stale scene.

## Component families with owner+state+handler contracts

| Family | G1 screens | Essential states | Implementation / callback |
|---|---|---|---|
| Orbit wheel | 05,06 | idle, pressed, active, disabled, dismissed, reopening | SCPCarSplit+Radial + SCPRadialControlView, 5 exact original selectors, action-first |
| Target strip | 05,06 | slot1/2/3, float, empty/disabled, changed while open | SCPRadialTargetStrip reads live pane + bundle + vc; check stale before dispatch |
| V3 picker sheet | 02,03 | pane1/2, filters, pending, apply, cancel, no apps, pinned | SCPCarSplit+Picker.m adapter; existing openApp:slot: delayed until Apply |
| Ratio diagram strip | 04 | active preset, tapped, disabled, drag | SCPCarSplit+RatioMenu.m, selector ratioPresetTapped, exact original frame |
| Handle capsule | 13 | native/hosted, idle/pressed/open/faded, double tap vs pan | +Chrome/+Zoom and ABHostBMethods; retain 34×12 and hosted 44×24 hit |
| Empty pane surface | 12 | truly empty, loading, unassigned, recover | SCPHomeWall/Picker, do not replace live scene |
| Fullscreen transition | 07 | split, expand, expanded, restoring, blocked | SCPFullscreenController, SCPPinchController, no logo/Dock in expanded |
| Keyboard skin | 08 | key idle/pressed, composing Telex, preview, error, hidden | ABKeyboard/ABKey, not an input engine rewrite |
| Startup frame | 09 | default, user media, connecting, error | SSSplash/SSStartupScreen, no scene claim change |
| Home icon | 11 | visible/hidden, pressed, reconnect, returns | SCPHomeLauncher, exact D asset, one-tap single owner |
| iPhone dashboard | 14 | connected/disconnected, state toggles, empty | OMCNativeSettings Dashboard: **new custom tableHeader + compositional cards**, existing model & actions |
| iPhone layout | 15 | current layout, two-pane preview, pinned, no active split | OMCNativeSettings kind1, diagram/preset strip, original keys |
| iPhone apps | 16 | source filter, empty, app available/unavailable | OMCNativeSettings AppsPage, true catalog, not fake apps |
| iPhone device | 17,20 | sampling, data, no data —, thermal (protected) | OMCNativeSettings kind5 + OMCDeviceVitalsController |
| iPhone customize | 18,21 | selected mode, toggle, details, vendor wrapper | OMCNativeSettings kind6; no hidden vendor code |
| iPhone prefs | 22 | master enabled, sections, nested, fail, respring | OMCRootListController / OMCNativeSettings, keys immutable |
| iPhone guide | 23 | first-time, returning, whatsnew, locale | UIKit timeline or compositional cards, no fake functionality |

### Critical interaction preservation not visible in concept art
**I. Layout panel entry preservation (blocking unless resolved):** current \`homeButtonTappedUnsafe\` and \`SCPHomeLauncherConsumeLaunch\` route to \`showLayoutPanelForApp:\`; the new wheel has only 5 pane actions, **none opens a layout chooser**. Replacing both Home callbacks would remove CarPlay layout selection / first-session entry unless another entry is built. G1 proposes a **secondary \`Bố cục\` command beside/below the wheel (NOT a sixth wedge)** and a **\`Bắt đầu chia màn\` empty-session row** routed to existing \`showLayoutPanelForApp:\` and \`layoutChosenID:\`. This is **additional access to a real existing feature**, not an invented action, and requires Nguyen approval of placement before G2. Muse must NOT remove original layout path before replacement is tested.
**II. Fullscreen:** source method \`runSoloForPane:\` is zoomedSlot (two-pane), and FS1 expands entire container without target. Mouse/touch state: chụm 2 ngón thu về only from true FS. Hence **wheel Full target action disabled with reason until single-pane targeted transaction proven**, not fake working via zoom.
**III. Native + hosted:** real hosted surface is SpringBoard ABHost window StatusBar+60; shared wheel must use existing CarPlay tray StatusBar+65 with pass-through hit. Don't add a transparent touch shield over all app pixels. New popup and existing tray/ratio/picker share one owner; only one open.
**IV. Brand & native content:** artboard shows placeholder labeled live app; NEVER ship a scene snapshot from artboard as actual app. Dock icons/music buttons on old mockups were illustrative and must not be generated into CarPlay system UI.
**V. Picker geometry:** original formula \`sheetW = cols*62+20\`, outer \`+150\`, \`sheetH=min(areaH-16,max(headerH+66,gridH+14+extra))\`; icon pitch 62×56, icon 38×38, cancel 32×32, corner24. G1 SVG artboard is **not exact pt**. Muse needs responsive composition inside those equations. If text/card footer does not fit, present measured alternative to Nguyen—do not silently enlarge sheet or drop controls.
**VI. Keyboard:** original \`panelH ≤ min(floor(H*.78),280)\`, \`keysView y=33\`, \`rowH=floor((panelH-5*(n-1))/n)\` and Telex engine untouched; skin can change independent of geometry.
**VII. Device data:** no fabricated 9:41, 86%, 34°C or YouTube/Maps runtime data; artboard placeholders — must bind source; use "—" if data missing.

## 23-screen gate registry, one SVG per concept
| Artboard | New information hierarchy & UI user sees | Source / protection |
|---|---|---|
| 01 | Split content with brand chrome edge, not phone/car scene mock | Layout/Chrome/hosted pass-through |
| 02 | Picker for pane1, target/source/candidate/Apply | Picker; 150pt sidebar & dynamic grid bound |
| 03 | Same face pane2, consistent dark material | Picker; hosted live-under & HL51 |
| 04 | Ratio visual presets with new preview glyphs | RatioMenu/Divider; 42pt bar |
| 05 | Native 5-sector wheel and slot target cards | +Zoom native single tap/Chrome; old bar fallback |
| 06 | Hosted exactly same wheel/target cards | ABHost notification→SCPCarSplit, one presenter |
| 07 | True fullscreen no wheel/logo/dock and pinch restore | FullscreenController/PinchController |
| 08 | Keyboard keycap skin and preview/hint | ABKeyboard; Telex/keyplane immutable |
| 09 | Startup horizon identity with original D | StartupScreen, user media preserved |
| 10 | Preserved thermal red edge, explicitly OUT OF REDESIGN | Thermal safety gate unchanged |
| 11 | DuoCar icon on system Home; no fake system chrome | SCPHomeLauncher, original logo |
| 12 | Empty-pane action when and ONLY when empty | SCPHomeWall/Picker |
| 13 | Different native and hosted handle display, same touch intent | Chrome/ABHostBMethods |
| 14 | iPhone dashboard hero + bento quick controls + real status | OMCNativeSettings Dashboard |
| 15 | iPhone layout interactive diagram and segmented preset | OMCNativeSettings kind1 |
| 16 | iPhone apps tiles sourced from real catalog | AppsPage |
| 17 | iPhone device data tiles/empty states | OMCNativeSettings kind5 |
| 18 | iPhone customize workshop + preference controls | OMCNativeSettings kind6 |
| 19 | iPhone startup media-preview settings | OMCNativeStartup |
| 20 | iPhone vital metrics, no fake source data | OMCDeviceVitalsController |
| 21 | Lề wrapper only, out-of-scope runtime | OMCLePrefsHost, cfg/ack protected |
| 22 | Detailed prefs with grouped cards, not old Settings list | OMCRootListController (P5 geometry unknown) |
| 23 | Guide as step timeline with real supported actions | Guide/WhatsNew |

## Strict DESIGN-NEW acceptance rubric (stop 'same old with purple')
For **each actually owned visible feature**, reviewers inspect five axes against authentic old screenshot (from verified installed binary): 
1. **Hierarchy changed:** there is a new compositional order or functional grouping, not a list tinted purple. Layout retained only when geometric/hit constraint mandates it, document that ID.
2. **Controls changed:** icon language, pressed/disabled/selected/focus states share one design system; one real existing callback per target.
3. **Information architecture changed:** dashboard hero / bento / pane-first picker / radial action-first; not duplicated settings rows with new backgrounds.
4. **Theme consistency:** same face pane1/pane2 native/hosted, fixed #100923 inner sheet, same actual D asset, no stock app content recolor.
5. **Runtime proof:** screenshot/video from the same DEB/hash/PID and geometry/hit regression; 5 actions×2 pane, cancel, no target confusion, keyboard/Full/live scene. A static SVG or green compile is NOT proof.

Result labels allowed: \`DESIGN DRAFT\`, \`G1 NGUYEN APPROVED\`, \`SOURCE IMPLEMENTED\`, \`LOCAL COMPILE PASS\`, \`RUNTIME VERIFIED\`, \`DEVICE PASS\`. No "100% hoàn thành" unless the final device-executed screen+behavior matrix passes.

## Muse work packages (GPT routes every code seam)
1. **UI-00** G0 geometry gate: compare source/DEB + 5 UNKNOWN, test same window; material/prototype no code.
2. **UI-01** radial + target strip + Home/dock/native/hosted handoff (use R0/approved two minimal protected hunks; preserve layout chooser!).
3. **UI-02** picker pending-selection + Apply/cancel, same face; filter only source-backed.
4. **UI-03** ratio/handle/split-state view components and parity.
5. **UI-04** iPhone five root custom compositions; retain app actions and pref keys.
6. **UI-05** iPhone nested: Startup/Vitals/Prefs/Guide; real locale and media.
7. **UI-06** keyboard/startup brand skin only; no engine rewrite.
8. **UI-07** source review + mirror/project compile, then requested DEB/vehicle QA. Full one-pane stays blocked until evidence.

Each package: approved SVG+component table → file:method/hunk diff → write source (Muse) → static render/stack check → compile (not device proof) → real DEB test with exact artifact. No new repo, no auto merge/CI/Sileo. GPT is responsible for design architecture + hunk review, Muse for implementation.
