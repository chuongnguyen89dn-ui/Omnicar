#!/usr/bin/env python3
"""Check exactly-once activity wiring between immutable original ABI and candidate.
Static source assertions ONLY; ARM64 compile and device QA are separate gates.
"""
from pathlib import Path
import json

root=Path(__file__).resolve().parent.parent
abi=json.loads((root/"audit/OmniCar_live_regressions_native_abi_20261020.json").read_text())
assert abi["original_sha256"]=="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
seen={(d["class"],d["selector"]):d["imp"] for d in abi["divider_view_methods"]}
for name in ["view","vc","handle","hostHandle","bundleID"]:
    assert ("SCPCarPane",name) in seen, name
assert seen[("SCPCarPane","view")]=="0xf920"
assert seen[("SCPCarPane","vc")]=="0xf8e8"
splits={d["selector"]:d["pc"] for d in abi["related_selectors"] if d["class"]=="SCPCarSplit"}
for key in ["allPanes","handleTapped:","dividerTapped:","paneForView:"]:
    assert key in splits, key

stable=(root/"idle/src/OmniCarIdleControls.xm").read_text()
candidate=(root/"idle/experimental-duoface/src/OmniCarDuoActivityIdle.xm").read_text()
required=[
    "OMCIdleGet(pane,@selector(view))",
    "OMCIdleGet(pane,@selector(vc))",
    "OMCIdleAttachPaneActivity",
    "content.window!=root.window",
    "observer.cancelsTouchesInView=NO",
    "observer.delaysTouchesBegan=NO",
    "observer.delaysTouchesEnded=NO",
    "OMCIdleNoteUserActivity",
    "now-s.lastActivity>=0.25",
    "static void OMCIdleHideWithNativeMenu",
    "event=menu-closed-grace-time",
    "OMCIdleNoteUserActivity(split);",
    "NSArray<UIView *> *prior",
    "NSArray<UIView *> *owners",
    "if(gesture)[view removeGestureRecognizer:gesture]",
]
for term in required:
    assert term in candidate,term
for bad in ["@selector(hostedPanes)","@selector(hostHandle)","%hook UIWindow","%hook UIView",
            "gesture.cancelsTouchesInView=YES","numberOfTapsRequired=2"]:
    assert bad not in candidate,bad
assert stable.count("%orig;")==candidate.count("%orig;")==10
assert "OMCIdleAttachPaneActivity" not in stable
assert "static void OMCIdleHideWithNativeMenu" in stable
print("OMNICAR_DUOFACE_OWNER_ACTUAL_ABI_VIEW_VC_AND_TOUCH_PIPELINE_SOURCE_PASS")
print("SCPCarPane.view",seen[("SCPCarPane","view")],"vc",seen[("SCPCarPane","vc")])
print("split allPanes",splits["allPanes"],"handleTapped",splits["handleTapped:"],
      "dividerTapped",splits["dividerTapped:"])
print("QA7 untouched; alternative links pane.view -> activity owner -> wake; native menus unchanged")
