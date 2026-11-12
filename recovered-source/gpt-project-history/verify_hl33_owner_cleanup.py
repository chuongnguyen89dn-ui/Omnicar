#!/usr/bin/env python3
"""HL33 independent source contracts and HL32 device counterexamples.
This is NOT a device-level keyboard/touch/CarAudio/pass-through proof.
"""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
P=ROOT/"project"; S=ROOT/"src"
pairs=[
 ("OmniCarAppBridge/ABInApp.m","AppBridgeB/ABInApp.m"),
 ("OmniCarAppBridge/ABKeyboardTraits104.m","AppBridgeB/ABKeyboardTraits104.m"),
 ("OmniCarAppBridge/ABKeyboardTraits104.h","AppBridgeB/ABKeyboardTraits104.h"),
 ("OmniCarAppBridge/ABHostGeometry.m","AppBridgeB/ABHostGeometry.m"),
 ("OmniCarSplitScreen/SCPVoiceNative.m","SplitScreenA/SCPVoiceNative.m"),
 ("OmniCarSplitScreen/SCPVoiceSpringAgent.m","SplitScreenA/SCPVoiceSpringAgent.m"),
 ("OmniCarSplitScreen/SCPCarSplit+Picker.m","SplitScreenB/SCPCarSplit+Picker.m"),
 ("OmniCarSplitScreen/SCPCarSplit+RatioMenu.m","SplitScreenB/SCPCarSplit+RatioMenu.m"),
]
for a,b in pairs:
    assert (P/a).read_bytes()==(S/b).read_bytes(),(a,b)
ab=(P/"OmniCarAppBridge/ABInApp.m").read_text()
tr=(P/"OmniCarAppBridge/ABKeyboardTraits104.m").read_text()
host=(P/"OmniCarAppBridge/ABHostGeometry.m").read_text()
native=(P/"OmniCarSplitScreen/SCPVoiceNative.m").read_text()
agent=(P/"OmniCarSplitScreen/SCPVoiceSpringAgent.m").read_text()
picker=(P/"OmniCarSplitScreen/SCPCarSplit+Picker.m").read_text()
ratio=(P/"OmniCarSplitScreen/SCPCarSplit+RatioMenu.m").read_text()
split=(P/"OmniCarSplitScreen/SCPCarSplit.m").read_text()
# HL32 device counterexample: outer keyplane 495pt at x7.5 overflows
# clip 495, while inner automatic 480pt ends at x487.5 (in clip).
clipRight=495.; planeX=7.5; planeW=495.; automaticW=480.
assert planeX+planeW>clipRight and planeX+automaticW<=clipRight
# The geometry callback no longer touches any keyboard window's
# frame/transform. Do NOT call a missing keyplane a dead responder.
for bad in ("ABNativeKbFit(","ABNativeKbRestore(",
            'keyboard.frame = target','keyboard.transform =',
            "keyplane-timeout-rollback","ABNativeKbHasOriginal",
            "ABNativeKbOriginalTransform","ABNativeKbOriginalBounds"):
    assert bad not in ab,bad
assert "static void ABNativeKbObserve(" in ab
assert "ABKB104InspectClips(keyboard)" in ab
assert "ABKB104RestoreClips(@\"did-hide\")" in ab
assert "ABKB104SetHostGeometry(NO,0,0,0,0,0,0)" in ab
assert 'ABNativeKbObserve(@"host-packet")' in ab
assert "ABNativeKbObserveLayout" in ab and "AB27FindKeyplane" in ab
assert "kbLogicalH" in host and "kbPhysicalH" in host
assert 'info[@"kbLogicalH"]' in ab and 'info[@"kbPhysicalH"]' in ab
assert "if (KB104Hosted && !valid)" in tr
assert tr.index("KB104ValidWidth(KB104LogicalW) ? KB104LogicalW") < tr.index("KB104ValidWidth(KB104WindowW) ? KB104WindowW")
assert "UIInputSetContainerView.layoutSubviews" in tr
assert "UIInputSetHostView.layoutSubviews" in tr
assert "KB104UnclipOwnedView" in tr and "KB104ClipSnapshots" in tr
assert "ABKB104RestoreClips" in tr and "didMoveToWindow" in tr
assert "KB104Signature(" in tr and "KB104Eligible()" in tr
assert "UIKeyboardLayoutStar.transform" not in tr
# No second split engine or picker window takeover.
assert 'UIRootSceneWindow' in native and 'DCHL33VoicePassHit' in native
assert "DCHL33Pass_" in native and "SCPCPassHitTest" not in native
assert "voiceWindow.hidden=!visible" in native
assert "window.windowLevel=UIWindowLevelStatusBar+64.0" in native
assert "voiceWindow" in native and "[host addSubview:bubble]" not in native
assert "CGRect inOverlay" not in native  # no hidden coordinate shortcuts
assert "fromWindow:host.window" in native
assert "SCPVoiceBubbleUpdate(self)" in picker and ratio
assert "trayWindowForParent:" in picker
assert "self.trayWindow" in split
assert "SCPVoiceBubbleDetach(self)" in split
# PCM-arrived != voice energy; no other agent or vendor secret.
assert "DC33MeasureBuffer(buffer)" in agent
assert "DC33TotalSamples" in agent and "DC33AboveLow" in agent
assert "event=voice-energy" in agent and "event=voice-verdict" in agent
assert "event=voice-format" in agent and "event=voice-session" in agent
assert "DC33RouteSignature" in agent
assert "if (low>32 && __sync_bool_compare_and_swap" in agent
assert "pcm-confirmed" not in agent
assert "setPreferredSampleRate:48000" in agent
assert "AVAudioSessionCategoryOptionAllowAirPlay" in agent
assert "SFSpeechRecognizerAuthorizationStatusAuthorized" in agent
assert "AVAudioSessionRecordPermissionGranted" in agent
assert "no-input-energy" in native and "no-input-energy" in agent
assert "event=owner-dispatch" in agent and "event=owner-ack" in agent
assert "event=tts-started" in agent and "AVSpeechSynthesizer" in agent
for prohibited in ("TCC.db","--grant-tcc","cboptimize_helper",
                   "apiKey=","DuoNaviDashboard.dylib"):
    assert prohibited not in agent+native+tr,prohibited
print("HL33_SOURCE_GATES_PASS: 8 src/project mirrors, no old keyboard writers, independent bubble, native PCM energy; DEVICE PENDING")
