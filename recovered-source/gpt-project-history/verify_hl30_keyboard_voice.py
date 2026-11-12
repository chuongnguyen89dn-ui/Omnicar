#!/usr/bin/env python3
"""HL30 prebuild source safety gates. Cannot establish CarPlay pixels, touch or TCC."""
from pathlib import Path
import re

root=Path(__file__).resolve().parents[1]
project=root/"project"
src=root/"src"

pairs=[
 ("OmniCarAppBridge/ABInApp.m","AppBridgeB/ABInApp.m"),
 ("OmniCarSplitScreen/SCPVoiceNative.m","SplitScreenA/SCPVoiceNative.m"),
 ("OmniCarSplitScreen/SCPVoiceNative.h","SplitScreenA/SCPVoiceNative.h"),
 ("OmniCarSplitScreen/SCPVoiceBridge.m","SplitScreenA/SCPVoiceBridge.m"),
 ("OmniCarSplitScreen/SCPCarSplit+Panel.m","SplitScreenB/SCPCarSplit+Panel.m"),
]
for left,right in pairs:
    a=(project/left).read_bytes()
    b=(src/right).read_bytes()
    assert a==b,("src/project mismatch",left,right)

ab=(project/"OmniCarAppBridge/ABInApp.m").read_text()
native=(project/"OmniCarSplitScreen/SCPVoiceNative.m").read_text()
header=(project/"OmniCarSplitScreen/SCPVoiceNative.h").read_text()
bridge=(project/"OmniCarSplitScreen/SCPVoiceBridge.m").read_text()
panel=(project/"OmniCarSplitScreen/SCPCarSplit+Panel.m").read_text()
split=(project/"OmniCarSplitScreen/SCPCarSplit.m").read_text()
hooks=(project/"OmniCarSplitScreen/SCPHooks.m").read_text()
make=(project/"OmniCarSplitScreen/Makefile").read_text()
parser=(project/"OmniCarApp/DCVoiceCommand.m").read_text()
version=(root/"gpt-project-history/rebrand_duocar.py").read_text()

# Reproduce the measured regression CONTRACT rather than trusting a fit log.
# Log 2026-11-11 21:35 showed visible FB keyboard keyplane wider than its
# already-fitted UIWindow at 371 -> 495 -> 371, OUTSIDE-CLIP.
assert '[hl30-kbviewport]' in ab
assert 'CGAffineTransformMakeScale(scale, scale)' in ab
assert 'sourceW = UIScreen.mainScreen.bounds.size.width' in ab
assert 'keyboard.bounds = CGRectMake(0, 0, sourceW, sourceH)' in ab
assert 'ABNativeKbOriginalTransform' in ab
assert 'ABNativeKbOriginalBounds' in ab
assert 'ABNativeKbOriginalCenter' in ab
assert 'ABNativeKbRestore(@"host-release")' in ab
assert 'ABNativeKbRestore(@"focus-resigned")' in ab
assert 'ABNativeKbRestore(@"window-replaced")' in ab
assert 'ABNativeKbRestore(@"projection-guard")' in ab
assert 'if (ABNativeKbFit(why, 0))' in ab
assert 'if (found)' in ab and '++ABNativeKbEpoch;' in ab
assert 'ABNativeKbObserveLayout' in ab
assert 'return applied && layoutObserved && planeInsideClip;' in ab
assert 'planeInsideClip = !CGRectIsNull(planeRect)' in ab
assert 'ABNativeKbRestore(@"keyplane-timeout-rollback")' in ab
assert 'fallback=system-native outcome=NOT-PROVEN' in ab
assert 'AB27FindKeyplane' in ab
assert 'AB25ProbeKeyboardSurface' in ab
assert 'UIKeyboardLayoutStar.transform =' not in ab
assert 'reloadInputViews]' not in ab
assert 'host-frame-settled' not in ab

# HL31: CarPlay handles presentation and typed owner commands; SpringBoard
# owns microphone, on-device/cloud opt-in speech and spoken feedback.
agent=(project/"OmniCarSplitScreen/SCPVoiceSpringAgent.m").read_text()
spring=(project/"OmniCarSplitScreen/SCPSpringBoardHooks.m").read_text()
bubble=(project/"OmniCarSplitScreen/SCPVoiceBubbleView.m").read_text()
assert (project/"OmniCarSplitScreen/SCPVoiceSpringAgent.m").read_bytes() == (src/"SplitScreenA/SCPVoiceSpringAgent.m").read_bytes()
assert (project/"OmniCarSplitScreen/SCPVoiceSpringAgent.h").read_bytes() == (src/"SplitScreenA/SCPVoiceSpringAgent.h").read_bytes()
assert "SCPVoiceBubbleUpdate(SCPCarSplit *split)" in native
assert "SCPVoiceBubbleDetach(SCPCarSplit *split)" in native
assert "SCPVoiceNativeToggle(SCPCarSplit *split)" in native
assert "SCPVoiceNativeToggle(self)" in bridge
assert "BOOL SCPVoiceDispatchLocalCommand(NSDictionary *command)" in bridge
assert "BOOL SCPVoiceExecute(NSDictionary *command)" in bridge
assert 'voice.capture.state' in bridge
assert "SCPVoiceHandleRemoteState(note.userInfo)" in bridge
assert "SCPVoiceHandleRemoteState(NSDictionary *packet)" in native
assert "event=carplay-bubble-hit owner=existing-split" in native
assert "event=agent-state" in native
assert "SCPVoiceSpringAgent.m" in make
assert "SCPVoiceSpringInstall();" in spring
assert "SCPVoiceSpringInstall(void)" in agent
assert "AVAudioEngine" in agent and "AVAudioSession" in agent
assert "SFSpeechAudioBufferRecognitionRequest" in agent
assert "shouldReportPartialResults=YES" in agent
assert "AVAudioSessionRecordPermissionGranted" in agent
assert "SFSpeechRecognizerAuthorizationStatusAuthorized" in agent
assert "springboard-tcc-denied" in agent
assert "requestID" in agent and "DCVoiceParseCommand(text,approved)" in agent
assert "AVSpeechSynthesizer" in agent and "speakUtterance:utterance" in agent
assert "event=tts-started" in agent and "event=tts-finished" in agent
assert "event=pcm-frames" in agent and "event=stt-partial" in agent
assert "event=owner-ack" in agent
assert "SCPVoiceBubbleDetach(self)" in split
assert "SCPVoiceBubbleUpdate(self)" in split
assert "SCPVoiceBubbleUpdate([SCPCarSplit shared])" in hooks
assert "[UIButton buttonWithType:" not in native
assert "AVAudioEngine" not in native
assert "SFSpeechRecognizer" not in native
assert "windowLevel" not in native
assert "DCVoiceParseCommand" in agent
assert "1.0.3-hl31voiceagent" in version
assert all(t not in agent+native for t in
    ("TCC.db","--grant-tcc","api.openai.com","chatgpt.com",
     "DuoNaviDashboard.dylib","apiKey="))
assert all(key in parser for key in
    ('@"swap"', '@"ratio"', '@"layout"', '@"open"'))
print("HL31_VOICE_CAPTURE_TTS_SOURCE_CONTRACT_PASS, compile-test pending, device-proven=NO")
