#!/usr/bin/env python3
"""QA19 static source guards; physical CarPlay user validation is still required."""
import hashlib
from pathlib import Path
r=Path(__file__).resolve().parents[1]
n=(r/"native-solo-timer-qa19/src/OmniCarNativeSoloTimer.xm").read_text()
h=(r/"youtube-handle-qa19/src/OmniCarYouTubeHandleIdle.xm").read_text()
a=(r/"scripts/assemble_qa19_passive_app_input_wake.py").read_text()
def gitsha(b): return hashlib.sha1(b"blob "+str(len(b)).encode()+b"\0"+b).hexdigest()
assert gitsha((r/"src/OmniCarDoubleTapFullscreen.xm").read_bytes())=="93d8fa2e912029e33391e9834f07463bef39d037"
assert gitsha((r/"src/OmniCarChrome.xm").read_bytes())=="a4b94c7c9c91475eb5879efee2ed13a7f8463dc6"
assert 'OMCNativeSharedActivity(YES,"native-gesture-fallback")' in n
assert 'if(touches.count) OMCNativeTimerWake(self.nativeSplit);' not in n
assert 'OMCNativeSharedActivity(YES,"original-split-hitTest")' in n
assert "%hook SCPCarSplitView" in n and "return nativeTarget;" in n
assert h.count("%hook UIApplication")==1
assert "- (void)sendEvent:(UIEvent *)event {\n    %orig;" in h
assert 'touch.phase==UITouchPhaseBegan' in h
assert 'if(began)OMCYTWakeAll(@"app-process-touch");' in h
assert '[source isEqualToString:@"app-process-touch"]' in h
assert "%init(OMCYTAppProcessTouchRelay);" in h
assert "OMCYTShouldObserveAppTouches" in h
assert "kOMCYTIdleSeconds=4.0" in h and "kOMCNativeIdleSeconds=4.0" in n
assert "com.anlai.omnicar.qa19.controls.activity" in n and "com.anlai.omnicar.qa19.controls.activity" in h and "com.anlai.omnicar.qa19.controls.activity" in a
assert 'QA18_SHA256="06c7ae70ebc518e2a6f9dbd3ff181ecb1461329005d74b6ff78b27dbcb4135cf"' in a
assert 'QA19_VERSION="1.0.3-omnicar19-app-process-wake"' in a
assert 'UPDATES=("OmniCarNativeSoloTimer","OmniCarYouTubeHandleIdle")' in a
assert "QA18_FILES=182" in a and "other_payload_identical" in a
assert "OMCYTIsSmallControl" in h and "@selector(handleHit)" in h and "OMCYTNativeVisibility" in h
assert "gOMCYTTrackedPanes addObject:pane" in h and "gOMCNativeSplits addObject:split" in n
assert "CFNotificationCenterPostNotification" in n and "CFNotificationCenterPostNotification" in h
for forbidden in ("%hook UIWindow","%hook UIView","setContentReferenceSize","setTransform:","setUserInteractionEnabled:"):
    assert forbidden not in n and forbidden not in h,forbidden
for lifecycle in ("soloBundle:","hostSolo:","closeGoingHome:","closeSlot:"):
    assert not any(f"- (void){lifecycle}" in x for x in (n,h)),lifecycle
print("QA19_PASSIVE_APP_PROCESS_SEND_EVENT_ORIGINAL_EVENT_PRESERVED_SOURCE_PASS")
print("QA19_NATIVE_GESTURE_GLOBAL_WAKE_AND_FOUR_SECOND_IDLE_SOURCE_PASS")
print("QA19_IMMUTABLE_QA18_ONLY_TWO_DYLIBS_REPACK_SOURCE_PASS")
