#!/usr/bin/env python3
"""Guardrails before compiling any QA15 YouTube scene candidate.
Static assertions only, never substitute for real CarPlay runtime tests.
"""
from pathlib import Path
import hashlib
import re

root=Path(__file__).resolve().parents[1]
source=(root/"youtube-scene-qa15/src/OmniCarYouTubeScene.xm").read_text()
pack=(root/"scripts/assemble_qa15_native_reference_candidate.py").read_text()
plist=(root/"youtube-scene-qa15/OmniCarYouTubeScene.plist").read_text()
two=(root/"src/OmniCarDoubleTapFullscreen.xm").read_bytes()
timer=(root/"native-solo-timer/src/OmniCarNativeSoloTimer.xm").read_bytes()

assert hashlib.sha1(b"blob "+str(len(two)).encode()+b"\0"+two).hexdigest()=="93d8fa2e912029e33391e9834f07463bef39d037"
assert b"static const NSTimeInterval kOMCNativeIdleSeconds=4.0" in timer
assert "com.apple.UIKit" in plist and "Filter" in plist
assert '@"com.google.ios.youtube"' in source
assert 'isEqualToString:kOMCYTID' in source
assert source.count("%hook ABHost")==1
assert source.count("%orig")==3, "one original zoom + one unmodified orientation + one layoutPane"
for disallowed in (
    "%hook SCPCarSplit","%hook SCPCarDividerView",
    "soloBundle:","hostSolo:","closeGoingHome:",
    "closeSlot:","rootDidLayout","setActive:",
    "setHidden:","userInteractionEnabled=","setUserInteractionEnabled:",
    "setTransform:","setFrame:","setSceneBox:","updateSettingsWithBlock:",
    "MSHookMessageEx","com.anlai.omnicar/appbridge.frame",
):
    assert disallowed not in source,disallowed
assert "gOMCInYoutubeLayout=isYoutube" in source
assert "gOMCInYoutubeLayout=prior" in source
assert "gOMCLayoutNesting=priorDepth" in source
assert "if(!measured || physical.width<kOMCMinPaneDimension" in source
assert "return original" in source
assert "kOMCYTNative12CandidateScale=0.50" in source
assert "orientation-flip-rejected" not in source
assert "kOMCYTOrientationStateKey" not in source
assert 'sig.numberOfArguments!=(index==0?4:5)' in source
assert 'strncmp([sig getArgumentTypeAtIndex:2],"{CGSize=",8)' in source
assert 'original AppBridge implementation' in pack
assert "duoface_native_reference_orientation_candidate" in pack
assert "- (NSInteger)effectiveOrientation:(id)pane" in source
assert "setContentReferenceSize:withInterfaceOrientation:" in source
assert "setContentReferenceSize:withContentOrientation:andContainerOrientation:" in source
assert 'valueForKey:@"_deviceAppViewController"' in source
assert 'CGSizeMake(round(physical.width*2.0)' in source
assert 'OMCYTSendReference(device,native)' in source
assert 'OMCYTSendReference(appController,native)' in source
assert 'return %orig;' in source





assert '%hook UIViewController' not in source and '%hook UIWindow' not in source
assert "if(!gOMCInYoutubeLayout || gOMCLayoutNesting==0)return original" in source
assert "NSMethodSignature" in source and "methodReturnType[0]!='@'" in source
assert "strncpy" not in source
assert "account" not in source.lower().replace("youtube account, video title, url or media","")
assert "QA12_SHA256=" in pack and "QA12_PAYLOAD_FILES=180" in pack
assert "QA15_VERSION=\"1.0.3-omnicar15-native-reference\"" in pack
assert '"sileo_published":False' in pack
assert "qa12_preserved_entries" in pack
assert "native12_2x_hypothesis_enabled" in pack
print("QA15_YOUTUBE_BUNDLE_SCOPED_FALLBACK_AND_NO_SPLIT_UI_HOOKS_STATIC_PASS")
print("QA15_QA12_PINNED_ORIENTATION_CANDIDATE_NO_SILEO_STATIC_PASS")
