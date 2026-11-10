# KÊNH DARWIN + KHÓA PREFS ỨNG VIÊN MỚI — OMNICAR 1.0.5

Phương pháp: trích toàn bộ chuỗi (strings -a, gộp mọi slice) của từng Mach-O ở cả hai bản,
so tập hợp 1.0.5 với 1.0.3. "Mới" = xuất hiện ở 1.0.5 và không xuất hiện trong BẤT KỲ binary nào của 1.0.3.
Đây là dữ liệu thô phục vụ tra cứu — mục B là khóa ỨNG VIÊN (lọc theo mẫu camelCase), chưa phải xác nhận từng khóa đều là khóa prefs thật.

## A. KÊNH DARWIN — toàn bộ ở 1.0.5: 54 · mới so với 1.0.3: 10 · mất: 0

Mẫu trích: chuỗi khớp `com.anlai.omnicar[/.]...` trong strings của binary.
Cột "Binary chứa" = các Mach-O 1.0.5 có chứa chuỗi kênh.

| Kênh | Mới ở 1.0.5? | Binary chứa (1.0.5) |
|---|---|---|
| `com.anlai.omnicar.app` | đã có ở 1.0.3 | AppBridge, Prefs |
| `com.anlai.omnicar.appbridge` | **MỚI** | AppBridge |
| `com.anlai.omnicar.log` | đã có ở 1.0.3 | AppBridge, Core, SpeedBubble, SplitScreen, StartupScreen |
| `com.anlai.omnicar.perf` | đã có ở 1.0.3 | AppBridge, Core, SpeedBubble, SplitScreen, StartupScreen |
| `com.anlai.omnicar.startupscreen.decode` | đã có ở 1.0.3 | StartupScreen |
| `com.anlai.omnicar/appbridge.apporient` | đã có ở 1.0.3 | AppBridge |
| `com.anlai.omnicar/appbridge.baraction` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.bardismiss` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.carlaunch` | **MỚI** | AppBridge |
| `com.anlai.omnicar/appbridge.close` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.closeall` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.frame` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.handledrag` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.handletap` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.handlewake` | **MỚI** | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.key` | đã có ở 1.0.3 | AppBridge |
| `com.anlai.omnicar/appbridge.keyboard` | đã có ở 1.0.3 | AppBridge |
| `com.anlai.omnicar/appbridge.knobs` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.knobtouch` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.open` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.orientation` | đã có ở 1.0.3 | AppBridge |
| `com.anlai.omnicar/appbridge.shield` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/appbridge.size` | **MỚI** | AppBridge |
| `com.anlai.omnicar/appbridge.state` | đã có ở 1.0.3 | AppBridge, SplitScreen |
| `com.anlai.omnicar/car.area` | **MỚI** | SpeedBubble, SplitScreen |
| `com.anlai.omnicar/car.busy` | đã có ở 1.0.3 | SpeedBubble, SplitScreen |
| `com.anlai.omnicar/car.connected` | đã có ở 1.0.3 | AppBridge, Core, SpeedBubble, SplitScreen, StartupScreen |
| `com.anlai.omnicar/cleanram.now` | đã có ở 1.0.3 | Core |
| `com.anlai.omnicar/license.activate` | **MỚI** | Core, Prefs |
| `com.anlai.omnicar/license.done` | **MỚI** | Core, Prefs |
| `com.anlai.omnicar/license.probe` | **MỚI** | Core, Prefs |
| `com.anlai.omnicar/license.trial` | **MỚI** | Core, Prefs |
| `com.anlai.omnicar/lite` | đã có ở 1.0.3 | AppBridge, Core, SpeedBubble, SplitScreen, StartupScreen |
| `com.anlai.omnicar/location` | đã có ở 1.0.3 | SpeedBubble, StartupScreen |
| `com.anlai.omnicar/log` | đã có ở 1.0.3 | AppBridge, Core, SpeedBubble, SplitScreen, StartupScreen |
| `com.anlai.omnicar/prefschanged` | đã có ở 1.0.3 | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `com.anlai.omnicar/rescue` | đã có ở 1.0.3 | AppBridge, Core, SpeedBubble, SplitScreen, StartupScreen |
| `com.anlai.omnicar/speed` | đã có ở 1.0.3 | Prefs, SpeedBubble |
| `com.anlai.omnicar/speedbubble.demo` | đã có ở 1.0.3 | Prefs, SpeedBubble |
| `com.anlai.omnicar/speedbubble.opencar` | đã có ở 1.0.3 | SpeedBubble |
| `com.anlai.omnicar/speedbubble.resetlayout` | đã có ở 1.0.3 | Prefs, SpeedBubble |
| `com.anlai.omnicar/speedbubble.source` | đã có ở 1.0.3 | SpeedBubble |
| `com.anlai.omnicar/speedbubble.speed` | đã có ở 1.0.3 | SpeedBubble |
| `com.anlai.omnicar/splash` | **MỚI** | AppBridge, SplitScreen, StartupScreen |
| `com.anlai.omnicar/splitscreen.ack` | đã có ở 1.0.3 | SplitScreen |
| `com.anlai.omnicar/splitscreen.kill` | đã có ở 1.0.3 | SplitScreen |
| `com.anlai.omnicar/splitscreen.native` | đã có ở 1.0.3 | SplitScreen |
| `com.anlai.omnicar/splitscreen.ready` | đã có ở 1.0.3 | SplitScreen |
| `com.anlai.omnicar/startupscreen.audio.play` | đã có ở 1.0.3 | StartupScreen |
| `com.anlai.omnicar/startupscreen.audio.stop` | đã có ở 1.0.3 | StartupScreen |
| `com.anlai.omnicar/startupscreen.style` | đã có ở 1.0.3 | StartupScreen |
| `com.anlai.omnicar/startupscreen.weather.ready` | đã có ở 1.0.3 | StartupScreen |
| `com.anlai.omnicar/startupscreen.weather.request` | đã có ở 1.0.3 | StartupScreen |
| `com.anlai.omnicar/url` | đã có ở 1.0.3 | Core, OmniCarApp, SplitScreen |

Kênh có ở 1.0.3 nhưng mất ở 1.0.5: **không có**.

Ghi chú: `com.anlai.omnicar.appbridge` (dạng chấm, không gạch chéo) là chuỗi định danh đứng độc lập;
chưa đủ cơ sở khẳng định đó là tên kênh Darwin — các kênh mới còn lại đều có dạng gạch chéo rõ ràng.

## B. KHÓA PREFS ỨNG VIÊN MỚI (camelCase) — 140 khóa

Lọc: chuỗi mới toàn cục (không có trong bất kỳ binary 1.0.3 nào), khớp mẫu `^[a-z][a-zA-Z0-9]{4,49}$`
và chứa ít nhất một chữ hoa. Danh sách có thể lẫn tên selector/ivar — giữ nguyên để tra cứu, không lược bỏ.

| Khóa ứng viên | Binary chứa (1.0.5) |
|---|---|
| `acquireDisplayPower` | AppBridge |
| `activateButton` | Prefs |
| `activateTapped` | Prefs |
| `activatedAt` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `allTouches` | AppBridge |
| `appBridgeAppOptions` | AppBridge, Prefs, SplitScreen |
| `appBridgeBlankHook` | AppBridge |
| `appBridgeBlankHookCrashed` | AppBridge |
| `appBridgeBlankHookPending` | AppBridge |
| `appBridgeDisplayPower` | AppBridge |
| `appBridgeSceneOrientationLock` | AppBridge |
| `appBridgeSpringBoardCrashed` | AppBridge |
| `appBridgeSpringBoardPending` | AppBridge |
| `appID` | AppBridge |
| `appOptions` | Prefs |
| `applicationState` | AppBridge |
| `applySplashGate` | AppBridge |
| `appsPage` | Prefs |
| `areaBounds` | SpeedBubble |
| `armReplyTimer` | Prefs |
| `armedAt` | SplitScreen |
| `bridgeWake` | SplitScreen |
| `buyCard` | Prefs |
| `cAu63` | Prefs |
| `carArea` | SpeedBubble |
| `carPlay` | Prefs |
| `contactDeveloper` | Prefs |
| `copyContactEmail` | Prefs |
| `copyDeviceCode` | Prefs |
| `dU55u` | Prefs |
| `dZZVP` | SplitScreen |
| `deviceCode` | Prefs |
| `deviceCodeLabel` | Prefs |
| `dismissLicenseGate` | Prefs |
| `displayPowerAssertion` | AppBridge |
| `displayRows` | Prefs |
| `displaySection` | Prefs |
| `doneToken` | Prefs |
| `dwiMa` | SplitScreen |
| `e0Aek` | Prefs |
| `effectivePolicyForAppDeclaration` | SplitScreen |
| `enteredForeground` | Prefs |
| `entryCard` | Prefs |
| `errorLabel` | Prefs |
| `fitToViewArea` | StartupScreen |
| `fitTries` | StartupScreen |
| `fl8E0d` | SpeedBubble |
| `gE2bVM6O` | SplitScreen |
| `handleDrop` | AppBridge |
| `handleTimer` | SplitScreen |
| `handlesShown` | SplitScreen |
| `hitMaxY` | SplitScreen |
| `homeHit` | SplitScreen |
| `homePage` | Prefs |
| `iconColumnsForCurrentOrientation` | SplitScreen |
| `iconImageFrame` | SplitScreen |
| `iconRowsForCurrentOrientation` | SplitScreen |
| `interfaceOrientation` | AppBridge |
| `isNavigationBarHidden` | Prefs |
| `knobDragging` | SplitScreen |
| `knobWatchdog` | SplitScreen |
| `knobsVisible` | SplitScreen |
| `largeDetent` | Prefs |
| `lastKnobs` | AppBridge |
| `lastValidate` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `launcherHorizontal` | SplitScreen |
| `layoutVertical` | SplitScreen |
| `licenseKeyPending` | Core, Prefs |
| `licenseProbe` | Core, Prefs |
| `licenseResult` | Core, Prefs |
| `loggedKind` | SplitScreen |
| `loggedKindSize` | SplitScreen |
| `m38Un` | Prefs |
| `mediumDetent` | Prefs |
| `minSide` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `moAGK` | StartupScreen |
| `navBarWasHidden` | Prefs |
| `nrashGuard` | Core |
| `onTouch` | SplitScreen |
| `onTouchEnd` | AppBridge |
| `openFacebook` | Prefs |
| `openZalo` | Prefs |
| `operatingSystemVersion` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `pendingTrial` | Prefs |
| `phoneSize` | Prefs |
| `phoneUI` | Prefs, SplitScreen |
| `pn5Qy` | SpeedBubble |
| `presentLicenseGate` | Prefs |
| `presentingViewController` | Prefs |
| `probeIfNeeded` | Prefs |
| `probeState` | Prefs |
| `probeTimer` | Prefs |
| `releaseDisplayPower` | AppBridge |
| `removeButton` | Prefs |
| `removeTapped` | Prefs |
| `replyArrived` | Prefs |
| `replyTimer` | Prefs |
| `respringButton` | Prefs |
| `screenKind` | SplitScreen |
| `separatorColor` | Prefs |
| `sheetPresentationController` | Prefs |
| `showBuy` | Prefs |
| `showHandlesForTouch` | SplitScreen |
| `showLicense` | Prefs |
| `showZoom` | Prefs |
| `showsDisplay` | Prefs |
| `soloHostedAt` | SplitScreen |
| `speedBubbleCalibKmh` | Prefs, SpeedBubble |
| `splashGen` | AppBridge |
| `startupPage` | Prefs |
| `statusIcon` | Prefs |
| `statusSub` | Prefs |
| `stopAnimating` | Prefs |
| `strongToWeakObjectsMapTable` | SplitScreen |
| `supportsTemplates` | SplitScreen |
| `systemOrangeColor` | Prefs |
| `thanksPage` | Prefs |
| `tickTimer` | Prefs |
| `trialButton` | Prefs |
| `trialCard` | Prefs |
| `trialProgress` | Prefs |
| `trialSpinner` | Prefs |
| `trialTapped` | Prefs |
| `turrentLanguage` | Core |
| `updateRespringButton` | Prefs |
| `vFh3q` | Prefs |
| `viewIfLoaded` | StartupScreen |
| `watchSoloLaunch` | SplitScreen |
| `watchSplash` | AppBridge |
| `wideRatio` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `x3vNp` | SplitScreen |
| `zPo2d` | Prefs |
| `zStatusCell` | Prefs |
| `zoomFloor` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `zoomHi` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `zoomLabel` | Prefs |
| `zoomLo` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `zoomPref` | AppBridge |
| `zoomUsed` | AppBridge |
| `zoomValue` | Prefs |

## C. CHUỖI DẠNG CHẤM MỚI (ứng viên khóa/kênh phụ) — 18 chuỗi

Chuỗi mới toàn cục dạng `a.b[.c]` (không tính tiền tố com.anlai.* đã liệt kê ở mục A).

| Chuỗi | Binary chứa (1.0.5) |
|---|---|
| `apps.iphone` | Prefs |
| `cart.fill` | Prefs |
| `checkmark.seal.fill` | Prefs |
| `com.google.ios.youtube` | AppBridge |
| `com.palera1n` | Prefs, SplitScreen |
| `dH.n` | SplitScreen |
| `doc.on.doc` | Prefs |
| `ellipsis.circle` | Prefs |
| `heart.fill` | Prefs |
| `hourglass.bottomhalf.filled` | Prefs |
| `hw.machine` | AppBridge, Core, Prefs, SpeedBubble, SplitScreen, StartupScreen |
| `iphone.slash` | Prefs |
| `k.ogT` | SplitScreen |
| `key.fill` | Prefs |
| `lock.fill` | Prefs |
| `org.palera1n` | Prefs, SplitScreen |
| `plusminus.circle.fill` | Prefs |
| `wifi.exclamationmark` | Prefs |
