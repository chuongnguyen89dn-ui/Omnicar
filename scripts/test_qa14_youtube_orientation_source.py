#!/usr/bin/env python3
"""Guardrails before compiling any QA14 YouTube scene candidate.
Static assertions only, never substitute for real CarPlay runtime tests.
"""
from pathlib import Path
import hashlib
import re

root=Path(__file__).resolve().parents[1]
source=(root/"youtube-scene-qa14/src/OmniCarYouTubeScene.xm").read_text()
pack=(root/"scripts/assemble_qa14_youtube_scene_candidate.py").read_text()
plist=(root/"youtube-scene-qa14/OmniCarYouTubeScene.plist").read_text()
two=(root/"src/OmniCarDoubleTapFullscreen.xm").read_bytes()
timer=(root/"native-solo-timer/src/OmniCarNativeSoloTimer.xm").read_bytes()

assert hashlib.sha1(b"blob "+str(len(two)).encode()+b"\0"+two).hexdigest()=="93d8fa2e912029e33391e9834f07463bef39d037"
assert b"static const NSTimeInterval kOMCNativeIdleSeconds=4.0" in timer
assert "com.apple.UIKit" in plist and "Filter" in plist
assert '@"com.google.ios.youtube"' in source
assert 'isEqualToString:kOMCYTID' in source
assert source.count("%hook ABHost")==1
assert source.count("%orig")==3, "one original zoom + one original orientation + one original layoutPane"
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
assert "orientation_first_landscape_pinned" in pack
assert "- (NSInteger)effectiveOrientation:(id)pane" in source
assert "UIInterfaceOrientationLandscapeLeft" in source and "UIInterfaceOrientationLandscapeRight" in source
assert 'return state.orientation' in source
assert 'event=orientation-flip-rejected' in source
assert 'event=orientation-first-landscape-pinned' in source
assert 'objc_getAssociatedObject(pane,&kOMCYTOrientationStateKey)' in source
assert 'objc_setAssociatedObject(pane,&kOMCYTOrientationStateKey,nil' in source
assert '%hook UIViewController' not in source and '%hook UIWindow' not in source
assert "if(!gOMCInYoutubeLayout || gOMCLayoutNesting==0)return original" in source
assert "NSMethodSignature" in source and "methodReturnType[0]!='@'" in source
assert "strncpy" not in source
assert "account" not in source.lower().replace("youtube account, video title, url or media","")
assert "QA12_SHA256=" in pack and "QA12_PAYLOAD_FILES=180" in pack
assert "QA14_VERSION=\"1.0.3-omnicar14-youtube-orientation\"" in pack
assert '"sileo_published":False' in pack
assert "qa12_preserved_entries" in pack
assert "native12_2x_hypothesis_enabled" in pack
print("QA14_YOUTUBE_BUNDLE_SCOPED_FALLBACK_AND_NO_SPLIT_UI_HOOKS_STATIC_PASS")
print("QA14_QA12_PINNED_ORIENTATION_CANDIDATE_NO_SILEO_STATIC_PASS")
