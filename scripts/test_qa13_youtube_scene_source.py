#!/usr/bin/env python3
"""Guardrails before compiling any QA13 YouTube scene candidate.
Static assertions only, never substitute for real CarPlay runtime tests.
"""
from pathlib import Path
import hashlib
import re

root=Path(__file__).resolve().parents[1]
source=(root/"youtube-scene/src/OmniCarYouTubeScene.xm").read_text()
pack=(root/"scripts/assemble_qa13_youtube_scene_candidate.py").read_text()
plist=(root/"youtube-scene/OmniCarYouTubeScene.plist").read_text()
two=(root/"src/OmniCarDoubleTapFullscreen.xm").read_bytes()
timer=(root/"native-solo-timer/src/OmniCarNativeSoloTimer.xm").read_bytes()

assert hashlib.sha1(b"blob "+str(len(two)).encode()+b"\0"+two).hexdigest()=="93d8fa2e912029e33391e9834f07463bef39d037"
assert b"static const NSTimeInterval kOMCNativeIdleSeconds=4.0" in timer
assert "com.apple.UIKit" in plist and "Filter" in plist
assert '@"com.google.ios.youtube"' in source
assert 'isEqualToString:kOMCYTID' in source
assert source.count("%hook ABHost")==1
assert source.count("%orig")==2, "one original zoom + one original layoutPane"
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
assert "if(!gOMCInYoutubeLayout || gOMCLayoutNesting==0)return original" in source
assert "NSMethodSignature" in source and "methodReturnType[0]!='@'" in source
assert "strncpy" not in source
assert "account" not in source.lower().replace("youtube account, video title, url or media","")
assert "QA12_SHA256=" in pack and "QA12_PAYLOAD_FILES=180" in pack
assert "QA13_VERSION=\"1.0.3-omnicar13-youtube-scene\"" in pack
assert '"sileo_published":False' in pack
assert "qa12_preserved_entries" in pack
assert "native12_2x_hypothesis_enabled" in pack
print("QA13_YOUTUBE_BUNDLE_SCOPED_FALLBACK_AND_NO_SPLIT_UI_HOOKS_STATIC_PASS")
print("QA13_QA12_PINNED_CANDIDATE_ONLY_NO_SILEO_STATIC_PASS")
