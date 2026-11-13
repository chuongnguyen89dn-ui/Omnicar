# HL50 — DuoCar49 device failure recovery (2026-11-13)



## Product decision / evidence

Nguyen tested DuoCar49 1.0.3-le0242 (CI 43392091835, source 5d1347408904eaf934b629dc07810eff759e1880, DEB SHA256 839730f7d2562fe8da2f21d972d6a7be2debbdc7b8da289f7878dc0ae26fa42b). DEVICE FAIL: hosted picker black/blank, Le bubble lacks speed/limit/lane and cannot move freely, two-finger ZOOM to fullscreen fails (NOT just Dock hiding), battery/heat is visible but outside proper Dock position. Earlier Le settings cannot save. No 39C red alert in scope (postponed). Keep native/hosted split, keyboard, original Lề sources and warnings, wake, fullscreen bubble, dock icons.



## Source of truth and authentic binary audit

Single repo chuongnguyen89dn-ui/Omnicar, work tree recovered-source/project and recovered-source/src, branch feature/duocar-hl50-restore-runtime-20261113 created from audited HL49 branch d4817fc2e1c42e687320c85536e843827263b63e. Old HL48 DEB SHA256 969897ecbc04f83eab9e29aa18218b621d9cebd6476dc3f654361ee3cf5b7ef0 was also DEVICE FAIL. Original OmniCar 1.0.3 DEB in main repository root: SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd. Original Lề 0.2.4 DEB at deb-scans/le-0.2.4/dev.bechou.le_0.2.4_iphoneos-arm64.deb SHA256 98a234f404987d5958bc80a19e0ed62d34ca2b39d4ef6e798bfd3314e2cb4770.

Original inputs fetched through GitHub Actions forensic run 43395844302 artifact 14023355654 HL50SourceReference SHA256 8ba66ec01d1cc101834c024de59ae8f909b821247cad8fc6121255f45a384740. Downloaded with connector, unpacked in container at /mnt/data/hl50src/forensic; verified original DEBs independently using sha256sum and dpkg-deb. Local git ls-remote failed DNS, so all source changes done through GitHub connector guarded branch commits and readback.

Read main deb-scans/le-0.2.4/{D_PREFS_GOI,A_HIEN_THI_RELAY,B_NGUON_GOFA_WAZE,C_NGUON_VIETMAP_GMAPS}. Original vendor bubble.modules is array of dictionaries containing id + enabled; DuoCar49 wrote STRING array, a confirmed schema bug. Le original has overlay panned: VM0x15674, place VM0x1167c, Cast panned: VM0x29250, place: VM0x28740 with CGRect argument. Data source Le modules and filters remain byte-identical across original and DuoCar49 except modified LeBubble speed-unit string.



## Source changes applied on isolated HL50 branch (no main merge)

1. recovered-source/project/OmniCarLeExtension/DCLLeExtension.m and src/LeExtension mirror: native CWTrafficOverlayController/CWCastBubbleController panned: handler ALWAYS called once first, then addon applies bounded free X/Y using gesture location and owner window, backed by normalized stored coordinates. No extra pan recognizer or replacement of vendor gesture; safer for CarPlay fullscreen gestures.

2. DCLLeConfigBridge.m and mirror: DCLNormalizedModules/DCLModuleArray preserve vendor dictionaries, enabled, order and unknown keys. On encountering DuoCar49 malformed string-array modules at SpringBoard start, backup exact file to layout-v1.json.duocar49-broken.bak before repair, notify native Le. Root/Bubble options 0..13+29 route to original layout-v1.json; Google Maps options 14..26 to original Maps CFPreferences. ACK/readback remains for in-app UI.

3. SCPDeviceVitalsHUD.m and mirror: restored REAL native Dock view ownership, not the entire dock UIWindow; uses native interactive subview/icon rects to find a free place INSIDE Dock with strict frame match. Passive hit-test (userInteractionEnabled NO), preserved battery/temp sampler and fullscreen-vitals bubble. No second UIWindow or split engine; refuses unsafe placement rather than drawing over app.

4. SCPCarSplit+Picker.m and mirror: occupied hosted menu uses SAME-CONTAINER surface, opaque flags disabled, translucent sheet, detaches stale resize cover only on explicit picker open; avoids unnecessary hosted remote-scene relayout/pushHostFramesLive which might black the app. Original native/empty slot handling and Cancel/Choose remain. This is a source-level fix hypothesis, not DEVICE PASS.

5. protect SCPPinchController.m, SCPFullscreenController.m, SCPFullscreenVitalsBubble.m and SCPCarSplit+Relayout.m exact SHA256 from prior working source; verify_hl50_source.py asserts these. Existing pinched fullscreen state machine not rewritten. User's zoom is genuinely BROKEN on HL49 and requires on-car retest.

6. Retire original OmniCar SpeedBubble runtime and resources while preserving single settings entry leading to Lề. Existing gps speed unit patch only touches literal km/h in two LeBubble slices, then re-signs; no posted limit or vendor overspeed-state modifications.



## CI, checkpoints, remaining gates

Single build workflow .github/workflows/build-hl50-restore-fat.yml for new branch, target output DuoCar50.deb version 1.0.3-le0243 signed arm64+arm64e; one package, conflicts standalone dev.bechou.le. Path trigger typo in initial workflow fixed by commit abe6edf95db11c8289efb3dc63e23b688e933f79; run 43398566381 started. At last audit it passed source, original OmniCar/Le hash, C tests, synthetic merging, Theos tooling and build-input cleaning; compiling DuoCar FAT. Build result pending when initially saved. verify_duocar50.py checks signed actual final DEB, zoom/menu/Dock markers and byte-identity of original vendor payload except current-speed unit patch.

Runtime/vehicle evidence STILL MISSING. For actual package run PID/version+timestamp test: pinch zoom expand/restore, Dock icon tap + pin/temp in native dock, picker Facebook/YouTube live video and Cancel/Choose, Le GPS source/wake, alert/lanes/limit, free drag X/Y and persistence, original full-screen bubble after pinched zoom, reattach/restart. No online deployment, main merge or Sileo publication. Original vendor public redistribution license unproven: private testing only.

Rollback to earlier known accepted HL47 and original vendor Lề, NOT device-failed HL48/HL49. Keep their hashes and artifacts for diff. This checkpoint is durable only if GitHub create_file/update_file acknowledges and readback confirms.
