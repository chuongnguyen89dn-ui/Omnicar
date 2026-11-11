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
assert 'AB27FindKeyplane' in ab
assert 'AB25ProbeKeyboardSurface' in ab
assert 'UIKeyboardLayoutStar.transform =' not in ab
assert 'reloadInputViews]' not in ab
assert 'host-frame-settled' not in ab

# One actual CarPlay button, no separate window/split owner.
assert 'SCPVoiceBubbleUpdate(SCPCarSplit *split)' in native
assert 'SCPVoiceBubbleDetach(SCPCarSplit *split)' in native
assert 'SCPVoiceNativeToggle(SCPCarSplit *split)' in native
assert 'SCPVoiceNativeToggle(self)' in bridge
assert '[button addTarget:split action:@selector(dcVoiceRequest:)' in native
assert 'dcVoiceRequest:' not in panel
assert 'SCPVoiceBubbleUpdate(self)' in split
assert 'SCPVoiceBubbleDetach(self)' in split
assert 'SCPVoiceBubbleUpdate([SCPCarSplit shared])' in hooks
assert 'SCPVoiceNative.m' in make
assert 'DCVoiceCommand.m' in make
assert ' Speech' in make
assert 'SCPVoiceNativeToggle' in header
assert 'UIWindow new' not in native
assert 'windowLevel' not in native

# Own-process, permission-gated input; never copy DuoNavi binary or grant TCC.
assert 'SFSpeechRecognizer authorizationStatus' in native
assert 'AVAudioSession.sharedInstance.recordPermission' in native
assert 'NSMicrophoneUsageDescription' in native
assert 'NSSpeechRecognitionUsageDescription' in native
assert 'AVAudioSessionRecordPermissionGranted' in native
assert 'SFSpeechRecognizerAuthorizationStatusAuthorized' in native
assert 'voiceAppleOnlineEnabled",@NO' in native
assert 'voiceAssistantEnabled",@NO' in native
assert 'SFSpeechAudioBufferRecognitionRequest' in native
assert 'requiresOnDeviceRecognition=YES' in native
assert 'AVAudioEngine' in native
assert 'self.generation' in native and '12*NSEC_PER_SEC' in native
assert 'DCVoiceParseCommand(utterance,allowed)' in native
assert 'DCVoiceAllow(command,split)' in bridge
assert 'now-DCVoiceLastReceiveAt<0.5' in bridge
assert all(needle not in native for needle in
           ('TCC.db','--grant-tcc','SiriInvocation','api.openai.com',
            'apiKey=','chatgpt.com','DuoNaviDashboard.dylib'))
assert '1.0.3-hl30kbvoice' in version
assert all(key in parser for key in
           ('@"swap"', '@"ratio"', '@"layout"', '@"open"'))

print("HL30_SOURCE_CONTRACT_PASS",
      len(pairs),"byte-parity pairs",
      "keyboard-viewport + CarPlay-bubble + TCC-safe speech",
      "device-proven=NO")
