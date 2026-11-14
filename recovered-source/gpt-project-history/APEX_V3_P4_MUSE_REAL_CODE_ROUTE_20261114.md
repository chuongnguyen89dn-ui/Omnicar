# DuoCar V3 P4 — GPT HUONG DAN MUSE DOI CODE THAT: 5-NUT BAR NGANG → VONG 5 CANH
Ngay: 2026-11-14. Source doi chieu: branch feature/duocar-apex-ui-muse-20261114 HEAD 2ba344590bf904c04ce1d703cc754b2dafe64a28.
Owner design, phan tich, code review: GPT. Muse: code va kiem tra. Nguyen: quyet dinh UX va device test. STATUS: CODE MAP + IMPLEMENTATION GUIDE; CHUA CODE RADIAL, CHUA BUILD, CHUA DEVICE PASS.
File SVG master wheeled: APEX_V3_P4_G1_RADIAL_WHEEL_20261114.svg; luong 5 action: APEX_V3_P4_G1_RADIAL_5_FLOWS_20261114.svg; chi tiet UX: APEX_V3_P4_G1_RADIAL_5_ACTIONS_MUSE_20261114.md.
Yeu cau: Dung mot SCPCarSplit shared, KHONG tao split/IPC engine thu hai. Moi sector chi CHON LENH (khong tac dong app), sau do hien THE O1/O2 co ten app that; chon the moi THUC THI lenh cho dung o. Layout 3 o can the thu ba; o trong disabled. Logo D nghieng tim la asset that, khong tu ve lai. Menu native/hosted chung visual factory.

## 1. BAN DO HAM — FILE / DONG / SUA TOI THIEU
NATIVE entry:
- project/OmniCarSplitScreen/SCPCarSplit+Chrome.m:170-193: tao handle; recognizers single-tap handleTapped, double-tap handleDoubleTapped, pan handlePanned. KHONG DUNG vao double-tap/pan.
- SCPCarSplit+Zoom.m:63-69: handleTapped dung paneForView(gr.view), hien tai goi setBarVisible(pane.bar.isHidden). Chuyen CHI nhanh single tap thanh goi method moi scpRadialToggleForPane(pane) khi feature enabled; con lai fallback old bar. Khong doi zoom.
- SCPCarSplit+Chrome.m:204-215: 5 button/selector theo dung thu tu: paneChoose, paneSolo, panePopOut, paneBackground, paneClose; 5×48pt width, bar height 52. Đây la TRUTH action, khong phai gioi han duong kinh wheel.
- SCPCarSplit+Chrome.m:316-368: setBarVisible quan ly 4s timer, callback, accent, bwRecompute, pushHostFrames. KHONG go bo code nay, giu fallback; khong de old bar visible va radial hit cung luc.

HOSTED entry:
- project/OmniCarAppBridge/ABHostBMethods.m:1336-1367: handle hosted pill 34x12, hit 44x24; tap/pan. ABHostBMethods.m:1005-1013 handleTapped chi post ABChanHandleTap {identifier: bundleID}. GIU NGUYEN notification va payload.
- project/OmniCarSplitScreen/SCPHooks.m:562-572: SCPBridgeHandleTapBlock lay string identifier va goi SCPCarSplit bridgeHandleTapped: (khong doi thanh dictionary).
- SCPCarSplit.m:2721-2740: bridgeHandleTapped phan biet double tap 0.35s, double tap toggleFloatSize/toggleZoomForPane; single tap moi goi setBarVisible. TOI THIEU CHI SUA NHANH else sau khi da phan biet doubleTap: thay call old bar bang scpRadialToggleForPane (fallback old bar neu flag OFF). GIU lastBridgeTapBundle/At va ahNoteActivity y nguyen. SCPCarSplit.m thuoc VUNG CAM: MUSE PHAI NOP DIFF/HUNK TUNG DONG DE GPT DUYET TRUOC, khong copy nguyen file hay swizzle de ne.
- ABHostBMethods.m:1175-1192 buildBarForPane da co 5 action; ABHostLaunch.m:335-350 emits replace/full/pop/bg/close; SCPHooks.m:576-579 va SCPCarSplit.m:2699-2715 dispatch ve CUNG split controller. GIU fallback bridge, KHONG TAO kenh action moi hoac dispatch 2 lan.

HOME entry:
- SCPHomeLauncher.m:466-505 SCPHomeLauncherConsumeLaunch da chong phone app launch va coalesce 0.65s, check live root, ahNoteActivity(Home). Sau guard, chi thay showLayoutPanelForApp call bang scpRadialPresentFromPane:nil neu feature on; flag off de nguyen. KHONG hijack Apple Home.
- SCPCarSplit.m:3350-3394 homeButtonTapped / homeButtonTappedUnsafe dang goi showLayoutPanelForApp khi tray khong mo. Muon logo DuoCar trong split vao wheel, de xuat minimal hunk tai else doi call sang cung radial presenter. File CAM: phai co bang huong dan diff/rollback va GPT duyet.
- Khong ngac nhien button Home System; chi logo DuoCar rieng, icon DuoCar CarPlay Home va dock.

POPUP/layers:
- SCPCarSplit+Chrome.m:392-440: panelOpen/popupOpen/closePopups chi biet tray/ratio/picker/bar. Can them state radialOpen theo mot owner: khi open can close existing picker/tray theo guard, khi closePopups phai dismiss radial. Chu y SCPFullscreenController tu choi expand neu popupOpen=YES, nen DISMISS wheel truoc request FS.
- SCPCarSplit+Chrome.m:updatePopupShield va SCPHooks.m:bar dismiss la noi co co che tap ngoai. R0 phai verify popup o tabParent, view/window order voi hosted, KHONG tu tang windowLevel, khong tao transparent window che app; hitTest ngoai wheel/the = pass-through, dialog khong duoc blank app.
- Wheel khong chi la anh SVG; Muse dung UIView/CAShapeLayer/UIControl 5 sector, center D asset, target cards co UIKit callbacks that.

## 2. 3 MODULE MOI DE MUSE TAO, FILE DUNG KHU VUC
- SCPRadialControlView.h/.m — render 5 wedge 72 do, 5 icon/action name, progress/pressed/disabled, tam D goc; CHI emit didSelectAction; khong lam close/kill.
- SCPRadialTargetStrip.h/.m — the O1/O2/O3, icon+localized name+bundle that tu split.slots, hien disabled reason; neu co float thi the floating app va dock-back the hien dung semantics. Khong tao 2 ban sao app hay screenshot gia.
- SCPCarSplit+Radial.h/.m — presenter/owner/dispatcher, du kien public selector: scpRadialPresentFromPane:, scpRadialToggleForPane:, scpRadialDismiss, scpRadialSelectAction:, scpRadialSelectTargetSlot:. Ten chi la de xuat, Muse phai map header va project/src.
- Dang ky 3 .m tai project/OmniCarSplitScreen/Makefile vao OmniCarSplitScreen_FILES. Mirror dung noi trong recovered-source/src theo mapping source that: +Chrome.m project -> src/SplitScreenA/, SCPCarDividerView.m project -> src/SplitScreenB/. Duong moi phai tim mirror tuong ung, khong doan nhom. AppBridge Makefile khong can them neu khong co code can thay.
- Render fallback: feature OFF giu nguyen old bar; feature ON ngan old bar receive hit. Khi disable feature/rollback, quay ngay ve code path old bar khong phai rebuild UI engine.

## 3. DISPATCH MAP DUOC GPT KIEM TREN SOURCE
1. Replace: trong SCPCarSplit+Panel.m:paneChoose: co guard slotIsPinned, showPickerForSlot. SCPCarSplit+Picker.m:pickerAppTapped: dang GOI openApp:slot: NGAY. Hinh 2 co state pending/selected/Ap dung; Muse phai them pending-selection adapter va chi goi openApp:slot: khi bam Ap dung. X huy khong duoc dang tai app khac. Dialog's target slot phai duoc pin.
2. Fullscreen: SCPCarSplit.m:runSoloForPane: voi >=2 pane chi goi toggleZoomForPane (local zoom, Dock khong duoc chung minh an). SCPFullscreenController.m:396-405 refuse neu zoomedSlot/solo/picker/popup; expand hien tai mo RONG CA container, khong chung minh chi app duoc chon. Full 1-o an Dock+logo la BLOCKER; Muse phai thiet ke transaction dung app + snap layout/scene + FS controller + pinch-in restore sau do chung minh, KHONG gan label FULL cho local zoom. Trong R1-R3 nut Full disabled+reason khi chua an toan. Pinch controller mode Enforce va cac gates phai kiem.
3. Float: SCPCarSplit+Zoom.m:popOutPane: va popOutBlockReason:. CHI mot floatPane, fresh pop di chuyen app ra, xoa slot goc va afterPaneRemoved co the relayout/solo; dang float ma chon app o khac se swap. Native compatibility CHUA PROVEN, khong tu enable vi storyboard demo co Google Maps.
4. Background: SCPCarSplit.m:runBackgroundForPane: => closeSlot:background:YES + toast. KHONG post kill; remaining pane co the solo theo afterPaneRemoved.
5. X Close: SCPCarSplit.m:runCloseForPane: => closeSlot:background:YES => killAppSoon: sau 0.6s. killAppSoon kiem reopen/pending truoc khi post SCPNoteKillApp, SpringBoard SCPSpringBoardHooks.m:SCPKillAppBlock terminate/FBS fallback. KHONG nham X voi BG. Khong add confirm thu 3, bam the app la chap thuan dong.

DISPATCH PSEUDOCODE (khong la patch san build):
   onSectorTap(action): pendingAction=action; renderActualTargetCards(slots); NO APP MUTATION.
   onTargetTap(slot, expectedBundle, expectedVC):
       pane = (slot==9 ? floatPane : paneAtSlot(slot));
       if (!pane || !pane.vc || bundle mismatch || vc mismatch) { refreshCards(); return; }
       closeRadialWithoutSceneMutation();
       switch(action):
         replace: if slotIsPinned then toast else showPickerForSlot(pane.slot)
         float: if popOutBlockReason nil then popOutPane(pane) else showReason
         bg: runBackgroundForPane(pane)
         close: runCloseForPane(pane)
         full: if unsafe -> DISABLED and no call; else single-owner fullscreen transaction
Luu snapshot bundle+vc theo model luc thuc su hien the; re-resolve ngay khi tap de phong reindex/reconnect/stale scene. Moi sector can hitbox hon hoac bang 44×44pt trong safe area; wheel co R tinh theo man that, khong phai bar 259×52. Overlay khong duoc tao nen trang che content hoac chuyen hit sang o khac.

## 4. KE HOACH MAU DIEM CHAY — MUSE NOP XONG LO NAO THI GPT KIEM LO DO
R0 READ ONLY: verify branch/head/dirty/jobs, popup window layer, protected file minimum hunks (bridgeHandleTapped: else; homeButtonTappedUnsafe else), source mirror/Makefile. Nop file:line before/after (1-3 lines), old/new call, fallback, test/rollback. Khong sua file cam truoc GPT phe hunk.
R1 UI ONLY: ve 5 wedge + D goc + target cards voi trang thai/safe hit; source renderer khong duoc goi action, screen R1 de chot.
R2 ROUTING: native single, hosted single, Home/dock/own-logo, common dispatcher; preserve doubleTap/pan, timers/autohide, no double events. Wired action Replace, Float, BG, X; Full disabled neu blocker.
R3 PICKER: Hinh 2 real cards/header/slot/filtered real catalog/pending Apply and cancel; cung face native/hosted, no blank underlying app, giu keyplane/scene.
R4 FS: prove selected-pane owner transaction + closed radial + hide Dock/logo + pinch-in restore split/ratio; FS method refuse reason/rollback and session logs; neu chua PASS giu disabled.
R5 compile/link locally if no concurrent job, project/src parity, source commit hunk, CI/DEB only by Nguyen subsequent authorization, device logs PID/build artifact/new binary before PASS.

## 5. CHUAN NGHIEM THU 5×2 + LY DO BLOCK
Nguon app from live model, khong fake YouTube/Maps. Native+hosted, O1/O2/third slot, float existing, single pane, pinned, invalid scene, cancel, close-on-last, reconnect, AutoHide/Wake, keyboard, Dock, split ratio. Doi app Apply dung slot; Float dung app; BG no kill; X kill guard 0.6; Full restored by pinch-in (khong can logo). User images = DESIGN; screenshot co PID, version, hash cua DEB moi la device evidence.
GPT huong dan va duyet code, Muse thi cong, Nguyen test. KHONG ghi code done/build/pass neu chi moi SVG/spec.
