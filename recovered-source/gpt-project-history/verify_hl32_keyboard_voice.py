#!/usr/bin/env python3
"""HL32 source/policy gates; never mislabel CI source PASS as car-device PASS."""
from pathlib import Path
import math
R=Path(__file__).resolve().parents[1]
P=R/"project"
S=R/"src"
pairs=[
 ("OmniCarAppBridge/ABInApp.m","AppBridgeB/ABInApp.m"),
 ("OmniCarAppBridge/ABKeyboardTraits104.m","AppBridgeB/ABKeyboardTraits104.m"),
 ("OmniCarAppBridge/ABKeyboardTraits104.h","AppBridgeB/ABKeyboardTraits104.h"),
 ("OmniCarSplitScreen/SCPVoiceSpringAgent.m","SplitScreenA/SCPVoiceSpringAgent.m"),
 ("OmniCarSplitScreen/SCPVoiceNative.m","SplitScreenA/SCPVoiceNative.m"),
]
for a,b in pairs:
    assert (P/a).read_bytes()==(S/b).read_bytes(),(a,b)
ab=(P/"OmniCarAppBridge/ABInApp.m").read_text()
kb=(P/"OmniCarAppBridge/ABKeyboardTraits104.m").read_text()
mk=(P/"OmniCarAppBridge/Makefile").read_text()
voice=(P/"OmniCarSplitScreen/SCPVoiceSpringAgent.m").read_text()
bubble=(P/"OmniCarSplitScreen/SCPVoiceNative.m").read_text()
settings=(P/"OmniCarApp/OMCNativeSettings.m").read_text()
assert "ABKeyboardTraits104.m" in mk
assert 'keyboard.transform = CGAffineTransformMakeScale(' not in ab
assert 'CGAffineTransformMakeScale(scale, scale)' not in ab
assert "ABKB104SetHostGeometry(" in ab
assert "ABKB104NoteWindowWidth(target.size.width)" in ab
assert "ABKB104RefreshLayout(star)" in ab
assert "keyboard.frame = target" in ab
assert "layoutWidthMatches" in ab
assert "ABNativeKbRestore(" in ab and 'ev=restore' in ab
assert "revision < ABNativeKbGeometryRevision" in ab
assert "ABKB104InstallIfAvailable();" in ab
assert "setKeyboardName:" in kb and "setKeyboardName:appearance:" in kb
assert "setKeyplaneName:" in kb and 'letters' in kb
assert "traitsWithScreen:orientation:" in kb and "keyboardScreenReferenceSize" in kb
assert "setKeyboardWidth:" in kb and "setIdiomToEmulate:" in kb
assert "KB104Signature(" in kb and "KB104Eligible()" in kb
assert 'UIKeyboardLayoutStar showKeyboard' not in kb
assert "BKSHIDServicesIsHardwareKeyboardAttached" not in kb
assert "layout.transform =" not in ab
assert "layout.center =" not in ab
# Independent counterexamples from real iOS16.7.16 HL23/HL30 device logs.
# 744 / 375 crossed the old 1.6 cap; the new source must not cap it.
assert 744/375>1.6
assert "scale <= 1.6" not in ab
# Physical to logical scene points: one and only one host zoom.
for physical,logical,zoom in [(297,371,.8),(396,495,.8),(500,625,.8),(744,930,.8)]:
    assert abs(physical-logical*zoom)<=1
# PCM, not just engine start, must establish "listening" on CarPlay.
assert '[owner sendState:@"listening" detail:@"pcm-confirmed"' in voice
assert '[self sendState:@"requesting" detail:@"awaiting-first-pcm"' in voice
assert 'event=no-pcm-frames' in voice
assert "owner.generation!=generation || !owner.listening" in voice
assert 'no-pcm-frames' in bubble and 'isEqualToString:@"requesting"' in bubble
assert "event=permission-block" in voice
assert "SFSpeechRecognizerAuthorizationStatusAuthorized" in voice
assert "AVAudioSessionRecordPermissionGranted" in voice
assert "self.request.requiresOnDeviceRecognition=localOnly" in voice
assert 'voiceAppleOnlineEnabled' in settings
assert 'voiceAppleOnlineEnabled' in voice
assert "event=tts-started" in voice and "AVSpeechSynthesizer" in voice
assert "DCVoiceParseCommand(text,approved)" in voice
assert "event=owner-dispatch" in voice
assert 'event=owner-ack' in voice
for blocked in ("TCC.db","--grant-tcc","cboptimize_helper","DuoNaviDashboard.dylib","setuid","INSERT OR REPLACE INTO access"):
    assert blocked not in voice+bubble+kb,blocked
print("HL32_SOURCE_CONTRACT_PASS: 5 pairs, keyboard gestures untouched, audio gate waits PCM; BUILD/DEVICE UNKNOWN")
