#!/usr/bin/env python3
"""HL48 + personal Le 0.2.4 source contracts.
No claim of CarPlay visual PASS; real DEB and vehicle checks come later.
"""
from pathlib import Path

root=Path(__file__).resolve().parents[1]
project=root/"project"
src=root/"src"
pairs=[
 ("OmniCarSplitScreen/SCPCarSplit+Picker.m","SplitScreenB/SCPCarSplit+Picker.m"),
 ("OmniCarSplitScreen/SCPVitalsPlacement.c","SplitScreenA/SCPVitalsPlacement.c"),
 ("OmniCarSplitScreen/SCPDeviceVitalsHUD.m","SplitScreenA/SCPDeviceVitalsHUD.m"),
 ("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m"),
 ("OmniCarApp/OMCLePrefsHost.m","App/OMCLePrefsHost.m"),
 ("OmniCarApp/OMCLePrefsHost.h","App/OMCLePrefsHost.h"),
 ("OmniCarLeExtension/DCLLeExtension.m","LeExtension/DCLLeExtension.m"),
 ("OmniCarLeTraffic/DCLTrafficCore.c","LeTraffic/DCLTrafficCore.c"),
 ("OmniCarLeTraffic/DCLTrafficCore.h","LeTraffic/DCLTrafficCore.h")
]
for a,b in pairs:
    p,q=project/a,src/b
    assert p.is_file() and q.is_file(),(p,q)
    assert p.read_bytes()==q.read_bytes(),(p,q,"mirrored code drift")

picker=(project/"OmniCarSplitScreen/SCPCarSplit+Picker.m").read_text()
assert "BOOL hl48HostedPicker = (pane.vc != nil && SCPVCIsHosted(pane.vc)" in picker
assert "duocarHL48HostedPickerClear" in picker
assert "picker.backgroundColor = UIColor.clearColor;" in picker
assert "if (hl46NativePicker || hl48HostedPicker) label.hidden = YES" in picker
assert "SCPApplyMeshBackdrop(effectView);" in picker # original chooser preserved
assert "action:@selector(pickerPaneTapped:)" in picker
assert "if (hl46NativePicker)" in picker
assert "pane.cover = nil" in picker # only native old guard
layout=(project/"OmniCarSplitScreen/SCPVitalsPlacement.c").read_text()
assert "margin=3.0, gap=5.0" in layout
assert "badgeW=horizontal?124.0:fmin(rail.w-2*margin,43.0)" in layout
assert "if (!collision && !intersects(candidate,in.app))" in layout
test=(root/"gpt-project-history/test_duocar_vitals_placement.c").read_text()
assert "real.dock=(SCPVitalsRect){0,124.6667,45,111.0}" in test
assert "check(real,1,0)" in test and "check(real,0,0)" in test

aggregate=(project/"Makefile").read_text()
assert "SUBPROJECTS += OmniCarSpeedBubble" not in aggregate
assert "SUBPROJECTS += OmniCarLeTraffic" not in aggregate # prototype not shipped
assert "SUBPROJECTS += OmniCarLeExtension" not in aggregate # separate signed input
settings=(project/"OmniCarApp/OMCNativeSettings.m").read_text()
assert '@"SPEEDBUBBLE", @"bubble"' in settings
assert '@"leGpsStepper", @"leTrafficGpsOffsetKph"' in settings
assert 'control.minimumValue=-5;' in settings and 'control.maximumValue=5;' in settings
assert "OMCLeOriginalPreferencesController()" in settings
app_make=(project/"OmniCarApp/Makefile").read_text()
assert "OMCLePrefsHost.m" in app_make
host=(project/"OmniCarApp/OMCLePrefsHost.m").read_text()
assert "CWTrafficBubblePrefsController" in host
assert 'Library/PreferenceBundles/LePrefs.bundle' in host
assert "OMCLeOriginalPreferencesAvailable" in host

extension=(project/"OmniCarLeExtension/DCLLeExtension.m").read_text()
assert "CWTrafficBubbleContent" in extension
assert "CWTrafficBubbleView" in extension
assert "leTrafficGpsOffsetKph" in extension
assert "leTrafficPositionX" in extension and "leTrafficPositionY" in extension
assert "getNumber(text,&raw)" in extension
assert "setSpeedText:" in extension
assert "DCLTrafficNormalizeCenter" in extension
assert "DCLTrafficRestoreCenter" in extension
assert "if (*oldIMP) return YES;" in extension
assert "setSpeedState:" not in extension # do not override unknown vendor semantics
assert "setOverspeedExcess:" not in extension
assert "Le-external" not in aggregate
assert (project/"OmniCarLeExtension/DCLLeExtension.plist").is_file()
assert (project/"OmniCarLeExtension/control").is_file()
assert (root/"gpt-project-history/merge_le024_personal_deb.py").is_file()
print("HL48_LE024_SOURCE_CONTRACT_PASS",len(pairs), "mirrored pairs")
