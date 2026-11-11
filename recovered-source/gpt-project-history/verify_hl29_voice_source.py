#!/usr/bin/env python3
"""Voice integration contract checks before rebrand/build. Not a device test."""
from pathlib import Path
import plistlib

ROOT=Path(__file__).resolve().parents[1]
project=ROOT/"project"
src=ROOT/"src"
pairs=[
 ("OmniCarApp/DCVoiceCommand.m","App/DCVoiceCommand.m"),
 ("OmniCarApp/DCVoiceCommand.h","App/DCVoiceCommand.h"),
 ("OmniCarApp/DCVoiceSession.m","App/DCVoiceSession.m"),
 ("OmniCarApp/DCVoiceSession.h","App/DCVoiceSession.h"),
 ("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m"),
 ("OmniCarApp/OMCAppDelegate.m","App/OMCAppDelegate.m"),
 ("OmniCarApp/Resources/Info.plist","App/Info.plist"),
 ("OmniCarSplitScreen/SCPVoiceBridge.m","SplitScreenA/SCPVoiceBridge.m"),
 ("OmniCarSplitScreen/SCPVoiceBridge.h","SplitScreenA/SCPVoiceBridge.h"),
 ("OmniCarSplitScreen/SCPCarSplit+Panel.m","SplitScreenB/SCPCarSplit+Panel.m"),
]
for a,b in pairs:
    assert (project/a).read_bytes()==(src/b).read_bytes(),(a,b)

settings=(project/"OmniCarApp/OMCNativeSettings.m").read_text()
delegate=(project/"OmniCarApp/OMCAppDelegate.m").read_text()
voice=(project/"OmniCarApp/DCVoiceSession.m").read_text()
parser=(project/"OmniCarApp/DCVoiceCommand.m").read_text()
bridge=(project/"OmniCarSplitScreen/SCPVoiceBridge.m").read_text()
panel=(project/"OmniCarSplitScreen/SCPCarSplit+Panel.m").read_text()
hooks=(project/"OmniCarSplitScreen/SCPHooks.m").read_text()
make_app=(project/"OmniCarApp/Makefile").read_text()
make_car=(project/"OmniCarSplitScreen/Makefile").read_text()
info=plistlib.loads((project/"OmniCarApp/Resources/Info.plist").read_bytes())

# Speech permissions must be obtained by app only; TCC vendor bypass is forbidden.
assert info.get("NSMicrophoneUsageDescription")
assert info.get("NSSpeechRecognitionUsageDescription")
assert "Speech" in make_app and "DCVoiceSession.m DCVoiceCommand.m" in make_app
assert "SFSpeechRecognizer requestAuthorization" in voice
assert "requestRecordPermission:" in voice
assert "SFSpeechAudioBufferRecognitionRequest" in voice
assert "AVAudioEngine" in voice
assert "requiresOnDeviceRecognition=YES" in voice
assert 'voiceAppleOnlineEnabled",@NO' in voice
assert 'voiceAssistantEnabled",@NO' in voice
assert 'voiceAssistantLanguage",@"vi-VN"' in voice
assert "12*NSEC_PER_SEC" in voice
assert "stopListening" in voice and "self.generation" in voice
assert "self.ownsAudioSession" in voice
assert "[hl29-voice]" in voice
assert all(bad not in voice for bad in ("--grant-tcc","TCC.db","chatgpt.com","api.openai.com","generativelanguage.googleapis.com"))
assert "AVAudioSessionInterruptionNotification" in voice
assert "UIApplicationDidEnterBackgroundNotification" in voice
assert "voiceAppBackgrounded:" in voice
assert "UIApplicationStateActive" in voice and "UIApplicationStateActive" in delegate
assert '"com.anlai.omnicar/voice.request"' in delegate
assert '"com.anlai.omnicar/voice.action"' in voice
assert '"com.anlai.omnicar/voice.ack"' in voice
assert 'voiceAssistantEnabled",@NO' in settings
assert 'voiceAppleOnlineEnabled",@NO' in settings
assert "DCVoiceCreateController()" in settings
assert "DCVoiceParseCommand(phrase,approved)" in voice
assert '@"appBridgeApps", @"splitScreenCarPlayApps"' in voice

# The original UI layouts, pinch, keyboard, Settings and Respring are
# not rewritten; voice is a single footer button in original scroll.
assert 'addTarget:self action:NSSelectorFromString(@"dcVoiceRequest:")' in panel
assert 'scroll.contentSize = CGSizeMake(104.0 + maxChoices * 84.0' in panel
assert "self.tray = panel;" in panel
assert "SCPVoiceBridge.m" in make_car
assert "SCPVoiceInstall();" in hooks
assert 'DCVoiceLastID' in bridge and 'fabs(now-sent.doubleValue)>8.0' in bridge
assert "now-DCVoiceLastReceiveAt<0.5" in bridge
assert 'OMCPref(@"voiceAssistantEnabled",@NO)' in bridge
assert "[SCPPrefs enabled]" in bridge
assert "isCarPlayApp:bundle" in bridge
assert "split.paneCount==2" in bridge
assert "DCVoiceAllow(command,split)" in bridge
for expected in ('"open"', '"layout"', '"fav"', '"ratio"', '"swap"', '"zoom"'):
    assert expected in parser and expected in bridge
for forbidden in ('"closeApp"', '"kill"', '"respring"', '"openURL"'):
    assert ('[action isEqualToString:'+forbidden+')') not in bridge,forbidden
assert 'stringByReplacingOccurrencesOfString:@"đ" withString:@"d"' in parser
assert '"do not "' in parser and '"khong "' in parser
assert 'approvedBundles containsObject:bundle' in parser
assert '"com.google.ios.youtube"' in parser
assert '"[hl28-kbmerge]"' in (ROOT/"gpt-project-history/verify_duocar_payload.py").read_text()
print("HL29_VOICE_SOURCE_PASS",len(pairs),"parity pairs",
      "no-vendor-binary no-user-api no-TCC-bypass iPhone-foreground speech")
