#!/usr/bin/env python3
"""QA9 source gate for device-proven OmniCar Solo UIKit gesture-owner crash.

Run from OmniCar repository root. This test never patches the stable QA8 Solo.
"""
from pathlib import Path
import hashlib
import re

ORIGINAL=Path("solo/src/OmniCarSoloThreeDots.xm")
CANDIDATE=Path("solo/experimental-qa9/src/OmniCarSoloThreeDots.xm")
stable=ORIGINAL.read_bytes()
new=CANDIDATE.read_bytes()
def git_blob(data):
    return hashlib.sha1(b"blob "+str(len(data)).encode()+b"\0"+data).hexdigest()
assert git_blob(stable)=="9873b516c8c047fd03e0ea5c406375bfcc100f03", "QA8 stable source changed"
old=stable.decode()
s=new.decode()
source_prefix="// OmniCar native edge-close remains UNCHANGED. SOLO three-dots source-only stage."
new_prefix="// OmniCar QA9 isolated gesture ownership fix from verified QA8 CarPlay crash log.\n// Safe: rename UIGestureRecognizer subclass property 'owner' to 'soloState' to\n// avoid colliding with UIKit internal gesture owner mechanism. Stable QA8 untouched."
expected=old.replace(source_prefix,new_prefix)
expected=expected.replace("@property(nonatomic,weak) OMCSoloState *owner;\n@end\n@implementation OMCSoloWakeGesture", "@property(nonatomic,weak) OMCSoloState *soloState;\n@end\n@implementation OMCSoloWakeGesture")
expected=expected.replace("OMCSoloWake(self.owner);", "OMCSoloWake(self.soloState);")
expected=expected.replace("g.owner=s;g.cancelsTouchesInView=NO;", "g.soloState=s;g.cancelsTouchesInView=NO;")
assert s==expected, "QA9 changed more than the gesture property crash fix"
slice=s.split("@interface OMCSoloWakeGesture : UIGestureRecognizer",1)[1].split("@interface OMCSoloState : NSObject",1)[0]
assert "@property(nonatomic,weak) OMCSoloState *soloState;" in slice
assert not re.search(r"\bowner\b",slice), "UIGestureRecognizer subclass overrides reserved private owner"
assert "g.soloState=s;" in s
assert "a.owner=s;" in s and "@interface OMCSoloDotAction : NSObject" in s
assert "_isGestureOwningType:" not in s, "do not spoof UIKit private selectors"
assert "%hook UIWindow" not in s and "%hook UIView" not in s
assert old.count("%orig;")==s.count("%orig;")==3
print("QA9_SOLO_UIGESTURERECOGNIZER_OWNER_COLLISION_SOURCE_FIX_EXACT_PASS")
print("QA8_STABLE_SOLO_BLOB_UNCHANGED",git_blob(stable))
print("QA9_CANDIDATE_SOLO_BLOB",git_blob(new))
print("FIX_ONLY_GESTURE_OWNER_SELECTOR_RENAME__NO_DEVICE_TEST")
