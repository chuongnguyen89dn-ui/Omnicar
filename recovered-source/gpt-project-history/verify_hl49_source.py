#!/usr/bin/env python3
"""HL49 regression source gate. Intentionally checks public behavior
contracts and mirrors, not only implementation names copied from source.
This is NOT equivalent to visual device validation on CarPlay.
"""
from pathlib import Path
root=Path(__file__).resolve().parents[1]
project=root/"project";src=root/"src"
pairs=[
 ("OmniCarSplitScreen/SCPCarSplit+Picker.m","SplitScreenB/SCPCarSplit+Picker.m"),
 ("OmniCarSplitScreen/SCPCarSplit+Chrome.m","SplitScreenB/SCPCarSplit+Chrome.m"),
 ("OmniCarSplitScreen/SCPDeviceVitalsHUD.m","SplitScreenA/SCPDeviceVitalsHUD.m"),
 ("OmniCarSplitScreen/SCPVitalsPlacement.c","SplitScreenA/SCPVitalsPlacement.c"),
 ("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m"),
 ("OmniCarApp/OMCLePrefsHost.m","App/OMCLePrefsHost.m"),
 ("OmniCarLeExtension/DCLLeExtension.m","LeExtension/DCLLeExtension.m"),
 ("OmniCarLeExtension/DCLLeConfigBridge.m","LeExtension/DCLLeConfigBridge.m"),
 ("OmniCarPrefs/OMCCommon.m","Prefs/OMCPrefs/OMCCommon.m"),
 ("OmniCarPrefs/OMCCommon.h","Prefs/OMCPrefs/OMCCommon.h"),
 ("OmniCarPrefs/OMCOnboardingController.m","Prefs/OMCPrefs/OMCOnboardingController.m")
]
for a,b in pairs:
    p,q=project/a,src/b
    assert p.exists() and q.exists(),(p,q)
    assert p.read_bytes()==q.read_bytes(),f"mirror drift: {a} / {b}"

picker=(project/"OmniCarSplitScreen/SCPCarSplit+Picker.m").read_text()
chrome=(project/"OmniCarSplitScreen/SCPCarSplit+Chrome.m").read_text()
assert "picker.opaque = NO" in picker and "picker.layer.opaque = NO" in picker
assert "sheet.opaque = NO" in picker and "effectView.opaque = NO" in picker
assert "duocarHL49HostedSameWindowPicker" in picker
assert "duocarHL49HostedSameWindowPicker\",@NO" in picker
assert "duocarHL49LiveUnderSheet\",@NO" in picker
assert "duocarHL49OccupiedPickerClear\",@NO" in picker
assert "SCPHL49SameWindowPicker" in chrome
assert "pickerPaneTapped:" in picker and "removePickerSheet" in picker
assert "SCPApplyMeshBackdrop(effectView)" in picker
hud=(project/"OmniCarSplitScreen/SCPDeviceVitalsHUD.m").read_text()
assert "SCPVitalsNativeDockWindow" in hud
assert "self.host = dockWindow" in hud
assert "[dockWindow addSubview:panel]" in hud
assert "self.panel.window" in hud
assert "panel.userInteractionEnabled = NO" in hud
assert "native-dock-attached" in hud
assert "🔋%@\\n🌡%@" in hud
layout=(project/"OmniCarSplitScreen/SCPVitalsPlacement.c").read_text()
assert "margin=3.0, gap=5.0" in layout
assert "if (!collision && !intersects(candidate,in.app))" in layout
assert (root/"gpt-project-history/test_duocar_vitals_placement.c").is_file()

settings=(project/"OmniCarApp/OMCNativeSettings.m").read_text()
assert 'OMCRow(@"SPEEDBUBBLE",@"bubble"' in settings
assert "OMCLeOriginalPreferencesController()" in settings
app=(project/"OmniCarApp/OMCLePrefsHost.m").read_text()
assert "leTrafficGpsOffsetKph" in app
assert "leGpsStepper" not in settings
assert "notify_register_dispatch(DCLLeAck" in app
assert "notify_set_state(self.sendToken" in app
assert "DCLLeConfigPage" in app
assert "CWTrafficBubblePrefsController" not in app
assert "Đã đọc / xác nhận" in app
assert "DCLLeRows[]" in app and "{29," in app

bridge=(project/"OmniCarLeExtension/DCLLeConfigBridge.m").read_text()
assert "notify_register_dispatch(DCLReq" in bridge
assert "NSJSONSerialization" in bridge
assert "NSDataWritingAtomic" in bridge
assert 'dev.bechou.le.bubble/layout-v1.json' in bridge
assert "CFPreferencesAppSynchronize" in bridge
assert "dev.bechou.le.bubble.layout-changed" in bridge
assert "DCLModuleOrderArray" in bridge
assert "(raw>>48)!=0x4c45" in bridge
assert "DCLLeConfigStartBridge" in bridge
ext=(project/"OmniCarLeExtension/DCLLeExtension.m").read_text()
assert 'DCLLeConfigStartBridge()' in ext
assert 'CWTrafficOverlayController' in ext and 'CWCastBubbleController' in ext
assert "newOverlayPan" in ext and "newCastPan" in ext
assert "newOverlayPlace" in ext and "newCastPlace" in ext
assert "DCLTrafficNormalizeCenter" in ext
assert "DCLTrafficRestoreCenter" in ext
assert "setSpeedState:" not in ext
assert "setOverspeedExcess:" not in ext
assert "attachPan(" not in ext # no more competing gesture
assert "leTrafficGpsOffsetKph" in ext
assert "setSpeedText:" in ext

mk=(project/"OmniCarPrefs/Makefile").read_text()
for old in ("OMCSpeedBubbleController.m","SPPBubbleView.m","SPPGlassView.m",
            "SPPIconView.m","SPPSignView.m","SPPSoundDelegate.m"):
    assert old not in mk,old
assert "speedBubbleEnabled" not in (project/"OmniCarPrefs/OMCOnboardingController.m").read_text()
assert "SPPSpeak(" not in (project/"OmniCarPrefs/OMCCommon.m").read_text()
assert "SUBPROJECTS += OmniCarSpeedBubble" not in (project/"Makefile").read_text()
assert "DCLLeConfigBridge.m" in (project/"OmniCarLeExtension/Makefile").read_text()
assert (root/"gpt-project-history/patch_le024_speed_unit.py").is_file()
assert (root/"gpt-project-history/strip_speedbubble_assets.py").is_file()
print("HL49_SOURCE_CONTRACT_PASS",len(pairs),"mirror pairs; full config bridge; placement owners; Dock")
