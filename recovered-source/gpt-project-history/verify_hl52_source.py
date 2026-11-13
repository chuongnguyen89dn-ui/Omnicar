#!/usr/bin/env python3
"""HL52 pre-build safety contracts; menu proven in DuoCar51, zoom deferred.
These assert SOURCE invariants only, never claim device/runtime PASS.
"""
from pathlib import Path
import hashlib
root=Path(__file__).resolve().parents[1]
project=root/"project";src=root/"src"
pairs=[
 ("OmniCarSplitScreen/SCPCarSplit+Picker.m","SplitScreenB/SCPCarSplit+Picker.m"),
 ("OmniCarSplitScreen/SCPCarSplit+Chrome.m","SplitScreenB/SCPCarSplit+Chrome.m"),
 ("OmniCarSplitScreen/SCPDeviceVitalsHUD.m","SplitScreenA/SCPDeviceVitalsHUD.m"),
 ("OmniCarSplitScreen/SCPFullscreenVitalsBubble.m","SplitScreenA/SCPFullscreenVitalsBubble.m"),
 ("OmniCarSplitScreen/SCPVitalsPlacement.c","SplitScreenA/SCPVitalsPlacement.c"),
 ("OmniCarApp/OMCLePrefsHost.m","App/OMCLePrefsHost.m"),
 ("OmniCarApp/OMCLePrefsHost.h","App/OMCLePrefsHost.h"),
 ("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m"),
 ("OmniCarLeExtension/DCLLeExtension.m","LeExtension/DCLLeExtension.m"),
 ("OmniCarLeExtension/DCLLeConfigBridge.m","LeExtension/DCLLeConfigBridge.m"),
 ("OmniCarPrefs/OMCCommon.m","Prefs/OMCPrefs/OMCCommon.m"),
 ("OmniCarPrefs/OMCOnboardingController.m","Prefs/OMCPrefs/OMCOnboardingController.m"),
]
for a,b in pairs:
    p,q=project/a,src/b
    assert p.is_file() and q.is_file(),(a,b)
    assert p.read_bytes()==q.read_bytes(),f"project/src drift: {a}"

picker=(project/"OmniCarSplitScreen/SCPCarSplit+Picker.m").read_text()
chrome=(project/"OmniCarSplitScreen/SCPCarSplit+Chrome.m").read_text()
assert 'duocarHL49HostedSameWindowPicker",@YES' in picker
assert 'duocarHL49OccupiedPickerClear",@YES' in picker
assert 'duocarHL49LiveUnderSheet",@YES' in picker
assert 'duocarHL50PreserveHostedSceneOnMenu",@YES' in picker
assert "[hl50-picker-cover] DETACHED" in picker
assert "[hl50-menu] NO-RELAYER" in picker
assert "picker.opaque = NO" in picker and "picker.layer.opaque = NO" in picker
assert picker.index('}   // VERIFIED @0x315ec-0x3160c') < picker.index('// [hl49-opaque]')
assert "if(window==nil && !(hl49SameWindow && pane.vc && SCPVCIsHosted(pane.vc)))" in picker
assert "SCPHL49SameWindowPicker(self)" in chrome
assert "duocarHL51RestoreOriginalMenuWindow" in picker
assert "[hl51-menu] sheetHost=" in picker
assert "[self sendHostFrameForPane:pane live:NO]" in picker
assert "pickerPaneTapped:" in picker and "SCPApplyMeshBackdrop(effectView)" in picker
assert "removePickerSheet" in picker and "pickerSheetPane" in picker

hud=(project/"OmniCarSplitScreen/SCPDeviceVitalsHUD.m").read_text()
assert "SCPVitalsNativeDockView" in hud
assert "SCPVitalsDockSlot" in hud
assert "SCPVitalsCollectControls" in hud
assert "SCPVitalsNativeHostForTarget" in hud
assert "compactBattery" in hud
assert "SCPVitalsDockSlot" in hud
assert "dock-view-mismatch" in hud
assert "[nativeHost addSubview:panel]" in hud
assert "panel.userInteractionEnabled=NO" in hud
assert "SCPVitalsNativeDockWindow" not in hud
assert "[dockWindow addSubview:panel]" not in hud
assert "native-dock-attached" not in hud
assert "root UIWindow" in hud
assert "[hl51-dock] IN NATIVE DOCK SUBTREE" in hud
assert "[SCPFullscreenController shared] fsCommittedState" in hud

# [hl51] Source-only regression gates. These assert the old 0x0 menu
# geometry and the tight 45x111 icon-only Dock search are not
# reintroduced. Pinch stays byte-for-byte HL50; device pixels need Nguyen.
core=(project/"OmniCarSplitScreen/SCPCarSplit.m").read_text()
src_core=(src/"SplitScreenA/SCPCarSplit.m").read_text()
def frame_body(s):
    a=s.index("- (CGRect)hostFrameForPane:")
    b=s.index("- (CGRect)holeForPane:",a)
    return s[a:b]
assert frame_body(core)==frame_body(src_core),"hostFrameForPane mirror diverged"
frame=frame_body(core)
assert "duocarHL51KeepHostedImageDuringPicker" in frame
assert "if (pane.picker && !keepHostedImage) return CGRectZero;" in frame
assert "keepHostedImage && self.pickerSheetPane == pane" in frame
assert "if (pane.picker) return CGRectZero;" not in frame
assert "duocarHL51RestoreOriginalMenuWindow" in picker
assert 'return [OMCPref(@"duocarHL49HostedSameWindowPicker",@YES) boolValue];' in picker

# Nguyen's 2026-11-13 explicit scope change: NO zoom/pinch fix
# in DuoCar51. Validate byte-exact Git blob identities against DuoCar50;
# do NOT require an unproven exclusive HL8 route from earlier HL51 work.
def git_blob_sha(p):
    data=p.read_bytes()
    return hashlib.sha1(b"blob "+str(len(data)).encode()+b"\0"+data).hexdigest()
unchanged_pinch_sources={
    project/"OmniCarSplitScreen/SCPCarSplit+BridgeWake.m":"ae224b57daab6bc4e2f021d6541c87f8e418b8e4",
    src/"SplitScreenA/SCPCarSplit+BridgeWake.m":"b3391020e044fe949d52ff33941b4b7a3c184507",
    project/"OmniCarSplitScreen/SCPTouchProbe.m":"e75823f0bcd5fc79d58215d39059f4edac45bba8",
    project/"OmniCarAppBridge/ABInApp.m":"c09a9fab823f1bf55d7d3fc82162f91a1a7dd195",
}
for path,expected in unchanged_pinch_sources.items():
    assert git_blob_sha(path)==expected,("zoom source changed",str(path))
bw=(project/"OmniCarSplitScreen/SCPCarSplit+BridgeWake.m").read_text()
bw_src=(src/"SplitScreenA/SCPCarSplit+BridgeWake.m").read_text()
for item in (bw,bw_src):
    assert "duocarHL51RestoreHL8HostPinch" not in item
    assert "[hl51-pinch]" not in item
    assert "bwHostedPinchFallback = fallback ? [fallback boolValue] : YES;" in item
assert "BWPinchMode" in (project/"OmniCarAppBridge/ABInApp.m").read_text()
assert "SCPHostPinchObserve" in (project/"OmniCarSplitScreen/SCPTouchProbe.m").read_text()
assert "[hl51-dock] NO SAFE RAIL" in hud
assert "statusBarViewController" in hud and "_statusBarViewController" in hud
assert "SCPVitalsBlock(blocked,cluster,rail,4.0);" in hud
assert "SCPVitalsCandidateVisible" in hud
assert "panel.userInteractionEnabled=NO" in hud

ext=(project/"OmniCarLeExtension/DCLLeExtension.m").read_text()
assert "if(originalOverlayPan)originalOverlayPan(o,sel,g);" in ext
assert "if(originalCastPan)originalCastPan(o,sel,g);" in ext
assert ext.index("if(originalOverlayPan)originalOverlayPan(o,sel,g);") < ext.index("freePan(o,g);")
assert "DCLDragDeltaKey" in ext
assert "DCLLeScreenGeometry" in ext and "DCLLeMoveSurface" in ext
assert "DCLLeCompactVendorWindow" in ext and '@"CWTrafficWindow"' in ext
assert "w.frame=frame;" in ext,"small Le native hit window is not moved"
assert "fromCoordinateSpace:w.screen.coordinateSpace" in ext,"Le free drag not normalized from screen"
assert "toCoordinateSpace:w.screen.coordinateSpace" in ext
assert "[hl52-free-xy] BEGIN" in ext and "[hl52-free-xy] END" in ext
assert "[hl52-free-xy] BAD GEOMETRY" in ext
assert "gesture.view.window.screen!=w.screen" in ext
assert "if(originalOverlayPan)originalOverlayPan(o,sel,g);" in ext
assert "if(originalCastPan)originalCastPan(o,sel,g);" in ext
assert "attachPan(" not in ext,"second pan recognizer forbidden"
assert "if(bounds.size.width<200||bounds.size.height<150)return NO;" not in ext
assert "originalCastPlace(o,sel,frame)" in ext
assert "static void (*originalCastPlace)(id,SEL,CGRect);" in ext
assert "method_getTypeEncoding(m)" in ext and '"{CGRect="' in ext
assert "attachPan(" not in ext
assert "setSpeedState:" not in ext and "setOverspeedExcess:" not in ext
assert "setSpeedText:" in ext and "DCLTrafficClampGpsOffset" in ext

bridge=(project/"OmniCarLeExtension/DCLLeConfigBridge.m").read_text()
assert "DCLNormalizedModules" in bridge
assert 'item[@"id"]' in bridge and 'item[@"enabled"]' in bridge
assert '"id":identifier' in bridge or '@"id":identifier' in bridge
assert "DCLMigrateMalformedVendorModules" in bridge
assert ".duocar49-broken.bak" in bridge
assert 'BOOL isLayout=(key<=13 || key==29)' in bridge
assert "NSDataWritingAtomic" in bridge
assert "dev.bechou.le.bubble.layout-changed" in bridge
assert "DCLModuleOrderArray" in bridge
assert "DCLLeConfigStartBridge" in bridge
assert 'dev.bechou.le.bubble/layout-v1.json' in bridge

app=(project/"OmniCarApp/OMCLePrefsHost.m").read_text()
assert "DCLLeConfigPage" in app
assert "notify_register_dispatch(DCLLeAck" in app
assert "notify_set_state(self.sendToken" in app
assert "didReceive:(uint64_t)packet" in app
assert "Đã đọc / xác nhận Lề" in app
assert "leTrafficGpsOffsetKph" not in app or "Hiệu chỉnh tốc độ GPS thực" in app
assert 'step.minimumValue=[kind isEqualToString:@"offset"]?0' in app
assert 'step.maximumValue=[kind isEqualToString:@"offset"]?10' in app

# HL52 exact scope and no-regression checks against code tested in DuoCar51.
# These guard source only; correct UI pixels and device persistence still
# require a new signed DEB plus a stopped-car test session.
for p,expected in {
    "OmniCarSplitScreen/SCPCarSplit+Picker.m":"54bb81ed63cedb36bc5a06931fcb998cba4eb761",
    "OmniCarSplitScreen/SCPCarSplit.m":"6cf2fdd20eaac3680eac685b5f9d3b415efc4723",
    "OmniCarSplitScreen/SCPCarSplit+BridgeWake.m":"ae224b57daab6bc4e2f021d6541c87f8e418b8e4",
    "OmniCarLeExtension/DCLLeConfigBridge.m":"e84572d1f95728e79ac85bc9ffc9f8d57e230fce",
}.items():
    assert git_blob_sha(project/p)==expected,("HL51 regression in",p)
# Latest user geometry preference: show ONLY text/icons without any grey
# background and search after icon cluster to avoid CarPlay's clock.
assert "CGRectGetMaxY(cluster)+7.0" in hud
assert "panel.backgroundColor=UIColor.clearColor;" in hud
assert "label.backgroundColor=UIColor.clearColor;" in hud
assert "panel.layer.cornerRadius=0.0;" in hud
assert "panel.userInteractionEnabled=NO" in hud
assert "colorWithWhite:0 alpha:0.28" not in hud
# Directly route existing SPEEDBUBBLE Settings entry to authentic
# LePrefs.bundle. Do not mislabel DuoCar's extra GPS/free-drag rows.
assert "CWTrafficBubblePrefsController" in app
assert "bundle.principalClass" in app
assert "[bundle loadAndReturnError:&error]" in app
assert "[hl52-le-original] ORIGINAL LOADED" in app
assert "extras.extrasOnly=YES" in app
assert "Lề • Chưa nạp bản gốc" not in app
settings=(project/"OmniCarApp/OMCNativeSettings.m").read_text()
assert "[self.navigationController pushViewController:OMCLeOriginalPreferencesController() animated:YES];return;" in settings
assert '@"leCompat"' in settings
assert "OMCLeCompatiblePreferencesController()" in settings
assert '@"Tùy chỉnh riêng DuoCar cho Lề"' in settings
# No changes to existing menu, native fullscreen and pinch engine.
mk=(project/"OmniCarPrefs/Makefile").read_text()
for forbidden in ("OMCSpeedBubbleController.m", "SPPBubbleView.m",
                  "SPPGlassView.m","SPPIconView.m","SPPSignView.m"):
    assert forbidden not in mk,forbidden
assert "SUBPROJECTS += OmniCarSpeedBubble" not in (project/"Makefile").read_text()
assert "DCLLeConfigBridge.m" in (project/"OmniCarLeExtension/Makefile").read_text()
assert (root/"gpt-project-history/strip_speedbubble_assets.py").is_file()
assert (root/"gpt-project-history/patch_le024_speed_unit.py").is_file()

# No changes to the already proven fullscreen *engine*. The Dock and
# Le integrations were changed instead. Record exact baseline hashes in CI.
# SHA-256 pinned to source exactly as verified on HL49 -> HL48: no
# edit to either the pinch engine or existing working fullscreen bubble.
protected={
 "SCPPinchController.m":"a5e94145bb8fc56abc37140faac06ece7933b7d76bf46bb0eaa75c9e04e63d18",
 "SCPFullscreenController.m":"62a0703aefd8f41c416bc684ebcfd8dd2ce72f239cea5dcb212fa5dea1fc3932",
 "SCPFullscreenVitalsBubble.m":"0e45da1e5307717eb108464855d1690f21e109b78340d0e0757b79e69d038ff7",
 "SCPCarSplit+Relayout.m":"831391349790159f91a3e19387c8b412da3b017585f39ba86465117c43274bc0",
}
for file,expected in protected.items():
    p=project/"OmniCarSplitScreen"/file
    actual=hashlib.sha256(p.read_bytes()).hexdigest()
    assert actual==expected,(file,"fullscreen source was altered",actual,expected)
    print("HL51_PROTECTED_FULLSCREEN",file,actual)
print("HL52_SOURCE_GATE_PASS",len(pairs),"byte mirrors; real LePrefs root; transparent Dock under icons; free XY on native hit window; menu and pinch unchanged; DEVICE PENDING")
