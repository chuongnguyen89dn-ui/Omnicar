#!/usr/bin/env python3
"""HL58 code source contract: only OPTIONAL external Lề GPS/visibility.

Not a device pass. Run in CI checkout before real iOS FAT build.
"""
from pathlib import Path
import hashlib
root=Path(__file__).resolve().parents[1]
p=root/"project"
src=root/"src"
pairs={
    "OmniCarLeExtension/DCLLeExtension.m":"LeExtension/DCLLeExtension.m",
    "OmniCarLeExtension/DCLLeConfigBridge.m":"LeExtension/DCLLeConfigBridge.m",
    "OmniCarApp/OMCLePrefsHost.m":"App/OMCLePrefsHost.m",
    "OmniCarApp/OMCNativeSettings.m":"App/OMCNativeSettings.m",
    "OmniCarSplitScreen/SCPFullscreenVitalsBubble.m":"SplitScreenA/SCPFullscreenVitalsBubble.m",
    "OmniCarSplitScreen/SCPCarSplit+Picker.m":"SplitScreenB/SCPCarSplit+Picker.m",
}
for a,b in pairs.items():
    assert (p/a).read_bytes()==(src/b).read_bytes(),("mirror drift",a,b)
ext=(p/"OmniCarLeExtension/DCLLeExtension.m").read_text()
bridge=(p/"OmniCarLeExtension/DCLLeConfigBridge.m").read_text()
app=(p/"OmniCarApp/OMCLePrefsHost.m").read_text()
settings=(p/"OmniCarApp/OMCNativeSettings.m").read_text()
extMake=(p/"OmniCarLeExtension/Makefile").read_text()
appMake=(p/"OmniCarApp/Makefile").read_text()
rootMake=(p/"Makefile").read_text()
for marker in ("[hl58-external-le]","CWTrafficBubbleContent",
               "CWTrafficOverlayController","CWCastBubbleController",
               "leTrafficGpsOffsetKph","leBubbleMasterEnabled",
               "contentWithSnapshot:","DCLMaskView"):
    assert marker in ext,("missing runtime function",marker)
for marker in ("DCLLeConfigStartBridge()","DCLOverlayPlace",
               "DCLCastPlace","DCLCorrectSpeed"):
    assert marker in ext,marker
for forbidden in ("newOverlayPan","newCastPan","DCLTrafficSnapWhenNearEdge",
                  "DCLLePeerWindowChanged","CWLeFloatingStore",
                  "DCLLeOriginalStoreStart","DCLLeStateWriter",
                  "DCLLeWindowState","DCLLeStoreWire.h",
                  "DCLLeDeferredAttach"):
    assert forbidden not in ext,("old Le runtime interception",forbidden)
assert "DCLLeExtension_FILES = DCLLeExtension.m DCLLeConfigBridge.m" in extMake
assert "DCLLeOriginalStoreServer.m" not in extMake
assert "DCLLeStateWriter.c" not in extMake
assert "DCLTrafficCore.c" not in extMake
assert "DCLLeOriginalStoreClient.m" not in appMake
assert "OMCLePrefsHost.m" in appMake
assert "SUBPROJECTS += OmniCarSpeedBubble" not in rootMake
assert "SUBPROJECTS += OmniCarLeTraffic" not in rootMake
for marker in ("leBubbleMasterEnabled","leTrafficGpsOffsetKph",
               "key==4||key==27","DCLWriteAndVerify",
               "com.chuong.duocar/le024.visibility"):
    assert marker in bridge,marker
for forbidden in ("layout-v1.json","dev.bechou.le.bubble.layout-changed",
                  "leBubbleMasterMirror","CWWriteOwnedStateFile",
                  "DCLLeReadState","DCLLeOriginalStoreStart"):
    assert forbidden not in bridge,("vendor data modification",forbidden)
for marker in ("OMCLeCompatiblePreferencesController",
               "Bật/tắt bong bóng Lề cài riêng","Hiệu chỉnh GPS",
               "notify_register_dispatch","self.verified",
               "self.bridgeFailed"):
    assert marker in app,marker
assert "NSBundle" not in app and "CWTrafficBubblePrefsController" not in app
assert "DCLLeOriginalStoreClient" not in app
assert "Lề cài riêng" in settings
assert "OMCLeCompatiblePreferencesController()" in settings
assert '@"leOriginal"' not in settings
clock=(p/"OmniCarSplitScreen/SCPFullscreenVitalsBubble.m").read_text()
assert "self.overlayWindow.userInteractionEnabled=NO;" in clock
assert "status.userInteractionEnabled=NO;" in clock
assert "UIPanGestureRecognizer" not in clock
menu=(p/"OmniCarSplitScreen/SCPCarSplit+Picker.m").read_text()
assert "hl57OriginalOccupiedFace" in menu
assert "SCPApplyMeshBackdrop(effectView)" in menu
assert "DCLLeExtension" not in clock and "DCLLeExtension" not in menu
print("HL58_SOURCE_EXTERNAL_LÈ_ONLY_TWO_CONTROLS_PASS",len(pairs))
