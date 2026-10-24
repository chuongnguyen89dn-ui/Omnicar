#!/usr/bin/env python3
"""STATIC ONLY: DuoFace-v12 hitTest activity parity, OmniCar ABI and release packaging gates.
Needs real iPhone CarPlay QA for first tap and original video/UI interactions.
"""
import hashlib
from pathlib import Path
root=Path(__file__).resolve().parents[1]
N=(root/"native-solo-timer-qa18/src/OmniCarNativeSoloTimer.xm").read_text()
H=(root/"youtube-handle-qa18/src/OmniCarYouTubeHandleIdle.xm").read_text()
B=(root/"scripts/assemble_qa18_duoface_global_wake_candidate.py").read_text()
NF=(root/"native-solo-timer-qa18/Makefile").read_text()
HF=(root/"youtube-handle-qa18/Makefile").read_text()
np=(root/"native-solo-timer-qa18/OmniCarNativeSoloTimer.plist").read_text()
hp=(root/"youtube-handle-qa18/OmniCarYouTubeHandleIdle.plist").read_text()
def blobsha(b):return hashlib.sha1(f"blob {len(b)}\0".encode()+b).hexdigest()
assert blobsha((root/"src/OmniCarDoubleTapFullscreen.xm").read_bytes())=="93d8fa2e912029e33391e9834f07463bef39d037"
assert blobsha((root/"src/OmniCarChrome.xm").read_bytes())=="a4b94c7c9c91475eb5879efee2ed13a7f8463dc6"
assert "com.apple.CarPlayApp" in np and "com.apple.springboard" in np
assert "com.apple.UIKit" in hp
assert "arm64" in NF and "arm64" in HF
assert "CoreFoundation" in NF and "CoreFoundation" in HF
assert "SCPCarSplitView" in N and "%hook SCPCarSplitView" in N
assert "- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event" in N
assert "UIView *nativeTarget=%orig;" in N and "return nativeTarget;" in N
assert "objc_getAssociatedObject(self,&kOMCNativeRootActivityKey)" in N
assert "CGRectContainsPoint(self.bounds,point)" in N and "event.type==UIEventTypeTouches" in N
assert "touch.phase==UITouchPhaseBegan" in N
assert "OMCNativeSharedActivity(YES,\"original-split-hitTest\")" in N
assert "for(SCPCarSplit *split in gOMCNativeSplits.allObjects)" in N
assert "OMCNativeTimerWake(split)" in N and "OMCNativeApply(split)" in N
assert "s.visible=YES;" in N and "OMCNativeSchedule(s);" in N
assert "gOMCNativeSplits addObject:split" in N
assert "gOMCNativeSplits removeObject:split" in N
assert "OMCNativeReceivedActivity" in N
assert "CFNotificationCenterAddObserver" in N
assert "CFNotificationCenterPostNotification" in N
assert "kOMCNativeIdleSeconds=4.0" in N

assert 'kOMCYTBundle=@"com.google.ios.youtube"' in H
assert "OMCYTIsSmallControl" in H and "@selector(handleHit)" in H
assert "signature.methodReturnType[0]!='@'" in H
assert "OMCYTReceivedSharedActivity" in H
assert "CFNotificationCenterAddObserver" in H
assert "CFNotificationCenterPostNotification" in H
assert "for(id pane in gOMCYTTrackedPanes.allObjects)" in H
assert "[gOMCYTTrackedPanes removeObject:pane]" in H
assert "OMCYTApply(pane)" in H and "OMCYTSchedule(state)" in H
assert "kOMCYTIdleSeconds=4.0" in H
assert H.count("%hook ABHost")==1 and H.count("%orig;")==2
assert "owner-window-observer-attached" not in H # QA17 on-device FAILED, intentionally retired.

NAME="com.anlai.omnicar.qa18.controls.activity"
assert NAME in N and NAME in H and NAME in B
assert 'QA17_SHA256="9d0edc8942e93e282d5130927697fb0b84a7ddcb993b616359fdd455eb0967b0"' in B
assert 'QA18_VERSION="1.0.3-omnicar18-duoface-unified-wake"' in B
assert 'UPDATES=("OmniCarNativeSoloTimer","OmniCarYouTubeHandleIdle")' in B
assert "QA17_FILES=182" in B and "QA18_ADDED_OR_REMOVED_PAYLOAD_ENTRY" in B
assert "OTHER_CONTROL_FIELD_CHANGED" in B and "QA18_NOT_NEWER_THAN_LIVE_QA17" in B
for forbidden in (
    "%hook UIApplication","%hook UIWindow","%hook UIView",
    "hostedPanes","@selector(hostHandle)","setSceneBox:","setInterfaceOrientation:",
    "setContentReferenceSize","setTransform:","setUserInteractionEnabled:"):
    assert forbidden not in N and forbidden not in H, forbidden
for lifecycle in ("soloBundle:","hostSolo:","closeGoingHome:","closeSlot:"):
    assert not any(f"- (void){lifecycle}" in x for x in (N,H)), lifecycle
print("QA18_DUOFACE_ORIGINAL_HITTEST_FIRST_TOUCH_ALL_NATIVE_CONTROLS_ABI_SAFE_SOURCE_PASS")
print("QA18_CROSS_PROCESS_NOTIFICATION_WAKE_ALL_APPBRIDGE_PANES_FOUR_SECOND_TIMER_PASS")
print("QA18_QA16_USER_PASS_HIDE_AND_QA17_FAILED_WINDOW_RETIRED_PASS")
print("QA18_PAYLOAD_SHA_LOCKED_ONLY_TWO_DYLIBS_CHANGED_GATE_PASS")
