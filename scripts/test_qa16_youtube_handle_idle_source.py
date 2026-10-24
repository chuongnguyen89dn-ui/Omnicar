#!/usr/bin/env python3
"""QA16 static guards. Original OmniCar YouTube player, ABI-safe host-handle-only idle.
These are NOT on-device touch/playback safety tests.
"""
from pathlib import Path
import hashlib
import json
root=Path(__file__).resolve().parents[1]
source=(root/"youtube-handle-qa16/src/OmniCarYouTubeHandleIdle.xm").read_text()
make=(root/"youtube-handle-qa16/Makefile").read_text()
plist=(root/"youtube-handle-qa16/OmniCarYouTubeHandleIdle.plist").read_text()
pack=(root/"scripts/assemble_qa16_youtube_handle_idle_candidate.py").read_text()
baseline=json.loads((root/"dist/candidates/omnicar-original-1.0.3-omnicar12-timer-zoom-swap/BUILD-MANIFEST.json").read_text())
timer=(root/"native-solo-timer/src/OmniCarNativeSoloTimer.xm").read_bytes()
zoom=(root/"src/OmniCarDoubleTapFullscreen.xm").read_bytes()
sha1=lambda b:hashlib.sha1(f"blob {len(b)}\0".encode()+b).hexdigest()
assert sha1(zoom)=="93d8fa2e912029e33391e9834f07463bef39d037"
assert sha1(timer)=="8c22067b376c467b0d1c86d1e378b712ef44a32e"
assert baseline["original_payload_file_count"]==176 and baseline["final_payload_file_count"]==180
assert baseline["output_sha256"]=="f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba"
assert "OmniCarYouTubeHandleIdle" in make and "arm64" in make
assert "com.apple.UIKit" in plist
assert 'kOMCYTBundle=@"com.google.ios.youtube"' in source
assert "OMCYTReadObject(pane,@selector(bundleID))" in source
assert "signature.methodReturnType[0]!='@'" in source
assert source.count("%hook ABHost")==1 and source.count("%orig;")==2
assert "setHandleVisible:(BOOL)visible forPane:(id)pane" in source
assert "OMCYTView(pane,@selector(handleHit))" in source
assert "OMCYTView(pane,@selector(handle))" in source
assert "OMCYTObserve(state,box,NO)" in source
assert "OMCYTObserve(state,hit,YES)" in source
assert "gesture.cancelsTouchesInView=NO" in source
assert "UIGestureRecognizerStateFailed" in source
assert "scheduledTimerWithTimeInterval:kOMCYTIdleSeconds" in source
assert "kOMCYTIdleSeconds=4.0" in source
assert "else OMCYTApply(pane); // native relayout must NOT reset" in source
assert "OMCYTIsSmallControl" in source and "OMCYTRestoreAll(state)" in source
assert "OMCYTNativeVisibility(pane,visible)" in source
for forbidden in (
    "%hook SCPCarSplit","%hook SCPCarPane","%hook UIView","%hook UIWindow",
    "hostedPanes","setContentReferenceSize","effectiveOrientation",
    "setInterfaceOrientation","setSceneBox:","setTransform:","setFrame:",
    "setUserInteractionEnabled:","setHidden:","soloBundle:","closeSlot:",
    "closeGoingHome:","appBridgeZoom","OMCChromeSetHidden",
    "UIWindow alloc","valueForKey:"):
    assert forbidden not in source,forbidden
# hostHandle is BOOL in ORIGINAL ARM64. Never message it as an object.
assert "selector(hostHandle)" not in source
assert 'QA16_VERSION="1.0.3-omnicar16-youtube-handle-idle"' in pack
assert "QA15_PUBLISHED" in pack and "QA16_NOT_NEWER_THAN_LIVE_QA15" in pack
assert "QA12_SHA256" in pack and "QA12_PAYLOAD_FILES=180" in pack
assert "NON_ORIGINAL_QA12_BASELINE" in pack and '"OmniCarYouTubeScene"' in pack
assert '"original_youtube_player_restored":True' in pack
assert '"appbridge_native_handle_abi_verified":True' in pack
assert '"sileo_published":False' in pack
print("QA16_NATIVE_ABPANE_HANDLE_ONLY_AND_ABI_BOOL_SAFE_SOURCE_PASS")
print("QA16_ORIGINAL_PLAYER_QA12_ZOOM_SWAP_TIMER_UNMODIFIED_GUARD_PASS")
