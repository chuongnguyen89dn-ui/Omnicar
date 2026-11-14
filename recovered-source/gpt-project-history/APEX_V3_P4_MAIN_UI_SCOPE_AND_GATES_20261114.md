# DUOCAR V3 P4 — MASTER PLAN: 100% GIAO DIEN CHINH, KHONG CHI LA RADIAL
Ngay: 2026-11-14. Repo chuongnguyen89dn-ui/Omnicar, branch feature/duocar-apex-ui-muse-20261114.
Owner: GPT thiet ke component, xac minh code, duyet hunks; Muse viet source/build theo cong; Nguyen chot hinh/xe.
STATUS: SCOPE & HANDOFF ONLY. 23 preview SVG va master ZIP da co, chua co G1 chi tiet 112/112, chua source G2 toan dien, chua co Device Pass.

## 1. NGUON DU LIEU DUOC DOI CHIEU
- User lock Issue #1 comment 6878846745: giao dien chinh DuoCar THIET KE MOI 100% khong duoc sao chep OmniCar chi thay mau. Cung mau/material Native/Hosted, O1=O2; giu geometry/hit original, khong reskin 3rd-party app. Logo D nghieng tim goc, Purple Horizon.
- Scope lock Issue #1 comment 6879117968: CHI UI CHINH, khong doi bubble, vendor Le, thermal warning, voice/noi dung phu. Telex/input/scene/AutoHide/wake/position must be preserved.
- V3_PURPLE_HORIZON_DESIGN/screens/ da luu 23 SVG preview (01-13 CarPlay, 14-23 iPhone). ZIP master 13,200,777 bytes gom 18 parts + manifest/reassemble script trong V3_PURPLE_HORIZON_DESIGN/master-zip-parts, SHA256 934747e09e3bb0d339f999558e543708227c59e8b88433b6c9cca4137009f73d. Cac SVG review KHONG la man chay. Khoi phuc master tren Muse VM va checksum truoc khi su dung.
- APEX_V3_P0_BANG_PHU_20261114.md = 112 surface/state IDs; APEX_V3_P1_BAN_DO_HUNK_20261114.md = 12 BL backlog and 13 decisions; APEX_V3_P4_G0_AUDIT_20261114.md = binary audit 23 geometry pairs match, 5 UNKNOWN, 5 declared DIFF and other rows no geometry.
- Radial giao #6880065311 va Muse ACK #6880097257 chi la MOT HANG MUC, khong the duoc coi la 100% toan UI. New source map APEX_V3_P4_MUSE_REAL_CODE_ROUTE_20261114.md.
- Hai anh IMG_8236/8237 user cho la reference idea. Hinh 1 6 sector tuong tuong da BI BAC; thay bang 5 LENH THAT. Hinh 2 menu card app/slot/filter/Apply la contract G1 can chot geometry va data.

## 2. NHOM MAN HINH PHAI THIET KE MOI + DANG CHO G1 COMPONENT
CarPlay:
- 01 split native/hosted: doi component skin & hierarchy split presentation, selected/loading/unassigned, same native-hosted tone; khong doi scene.
- 02/03 picker native+hosted: sheet tim dem cung mau, header, segmented slot, app cards, filter neu catalog co du lieu, pending selection + Apply/cancel. Phai fit outer geometry G0, no black/blank content.
- 04 ratio/knob: visual moi, active/drag states, giu divider/knob hit/tile positions va ratio computation.
- 05/06 control menu: bar ngang cu OBSOLETE, thay VONG 5 sector + target cards; no fake HUD/Settings/Bo cuc controls from AI. Method-by-method source map doc rieng.
- 07 fullscreen: logo/Wheel/Dock an, gesture pinch-in restore; phan bubble/status phu khong code lai.
- 08 keyboard: skin/glyph/preview theo V3, giu full Telex layout/touch, native keyplane/resize runtime; KHONG thay logic ban phim.
- 09 Startup: splash/brand D goc, states load/error, khong doi scene/media cua user.
- 11 Home: icon D original va Home/dock one tap to real same wheel, no app Settings.
- 12/13 empty pane/handle: placeholder/loader/ghost/knob/handle and AutoHide visual, hit size unchanged.
iPhone:
- 14-18: Dashboard, Bo cuc, Ung dung, Thiet bi, Tuy chinh. TAI THIET KE hierarchy/card/navigation, KHONG chi mau; giu 5 tab da co tren OMCNativeSettings.m va actual data/controllers.
- 19/20/22/23: trang con Startup, Device readings, cai dat/Prefs legacy, Guide/WhatsNew, item/card/header/toggle/slider/modal/empty/loading/disconnected/error; cac thong tin khong co du lieu la dash, khong la so demo.
- 10 thermal, 21 Le va cac bubble/HUD vendor phu: GIU NGUYEN behavior existing, scope P4 ngoai code changes tru khi control UI chinh su dung.

## 3. MOI COMPONENT PHAI CO G1-READY ART + SOURCE
Giao tung ID P0 theo file/method/constructor/hit, both BEFORE from grounded original binary/device when possible and AFTER different composition, exact known pt bounds/hit, icon asset source, fonts/colors, no hidden replacement.
Required states: normal, pressed, selected, disabled+reason, loading, empty, hidden/AutoHide, small/large screen, native/hosted equivalence; interaction diagram, callback path, reconnect regression, rollback. UNKNOWN geometry trong G0 phai giu UNKNOWN den khi Muse do; khong bịa.
Token: root #070416, sheet #100923 alpha 1, face #1B1138, raised #28194D, active #A16EFF, rim #DBB9FF, primary #F5F0FF, secondary #C7B8E4. Mot common theme factory car native+hosted. Red thermal #FF0610 protected.
KHONG chuyen bitmap concept thanh ui app; UIView/sections/hit that, compiled source and device screenshot phai khop G1 sau duyet.

## 4. PHAN LO VA PHAN VAI KHONG DE MUSE TU DOAN
Track A — radial/controller/picker (Muse da ACK scope R0–R5): GPT code map trong doc cap doi. Muse nop R0 protected hunk, GPT duyet; Muse code R1–R4, compile R5, phan biet pass source vs runtime. Gate Full may remain disabled until verified.
Track B — toan UI chinh con lai: GPT tiep tuc cung cap component-by-component design G1 cho 112 ID trong scope + crossreference master 23 screens; Muse chi duoc phan tich source, file:hunk, freeze geometry truoc khi Nguyen duyet G1. Mot khi duyet, Muse edit tung component, screenshot, verify native-hosted/phone, commit rollback units; khong auto code tu cai poster.
Priority: wheel+picker (new UX), CarPlay handle/ratio/split, iPhone 5 root hierarchy, nested phone screens, keyboard skin, startup/branding. Moi phase co hai columns "ART G1 approved" va "REAL SOURCE G2 / device evidence"; khong gop.
Final: no automatic CI/DEB/merge or Sileo without instruction. One final DEB after G2 proof and Nguyen authorizes, device test all major CarPlay+iPhone surfaces. Build success not visual proof.

## 5. CHECKPOINT
Baseline before doc write: branch 2ba344590bf904c04ce1d703cc754b2dafe64a28. 23 preview screens/master ZIP+P0/P1/G0 verified; Muse ACK radial #6880097257 only.
Chua co: G1 approved 112 per-component art, other UI G2 implementation, runtime/device PASS; radial source not yet developed per latest Muse ACK.
Blocking: FS1 selected-pane full vs zoomedSlot, overlay stacking native-hosted, protected SCPCarSplit.m minimal hunk, 5 G0 UNKNOWN, unapproved visual screen states.
Next: Muse R0 detailed diff/risk; GPT approves protected hunks and produces further G1 component sheets; Muse code after approval. Newest user request clarifies GPT owns exact code guidance, Muse should NOT infer routing from SVG alone.
