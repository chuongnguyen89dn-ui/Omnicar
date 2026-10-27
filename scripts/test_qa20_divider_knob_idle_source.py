#!/usr/bin/env python3
"""QA20 original-divider.knob coverage; don't change user-improved QA19 touch routing."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
old=(r/"native-solo-timer-qa19/src/OmniCarNativeSoloTimer.xm").read_text()
new=(r/"native-solo-timer-qa20/src/OmniCarNativeSoloTimer.xm").read_text()
qa7=(r/"idle/src/OmniCarIdleControls.xm").read_text()
asm=(r/"scripts/assemble_qa20_divider_knob_idle.py").read_text()
expected_old="""    // Hide the NATIVE divider visual (line and knob) together, retaining
    // its actual UIView and pointInside/drag/gesture interaction unchanged.
    id dividers=[split dividers];
    if([dividers isKindOfClass:NSArray.class])
        for(id divider in (NSArray *)dividers)
            OMCNativePaint(divider,s,s.visible);"""
expected_new="""    // Native original SCPCarDividerView has its OWN child knob UIView.
    // QA19 only painted the parent divider, so the independent circular
    // knob remained visible even though both pane three-dots auto-hid.
    // Paint BOTH objects without changing hit targets/pan or native state.
    // Do not touch split.ratioKnob: it belongs to the temporary popup.
    id dividers=[split dividers];
    if([dividers isKindOfClass:NSArray.class])
        for(id divider in (NSArray *)dividers) {
            OMCNativePaint(divider,s,s.visible);
            OMCNativePaint(OMCNativeGet(divider,@selector(knob)),s,s.visible);
        }"""
assert expected_old in old and expected_new in new
assert new.replace("QA20","QA19").replace(expected_new,expected_old)==old, "REJECT OTHER SOURCE CHANGES"
assert "OMCIdleGet(divider,@selector(knob))" in qa7, "QA7 VERIFIED KNOB ABI"
assert "NEVER touch split.ratioKnob" in qa7, "ratioKnob is not center circle"
assert new.count("OMCNativePaint(OMCNativeGet(divider,@selector(knob)),s,s.visible);")==1
assert "OMCNativePaint(divider,s,s.visible);" in new
assert "kOMCNativeIdleSeconds=4.0" in new
assert "CFSTR(\"com.anlai.omnicar.qa19.controls.activity\")" in new, "KEEP QA19 HOST NOTIFICATION"
assert 'OMCNativeSharedActivity(YES,"native-gesture-fallback")' in new
assert "UPDATES=(\"OmniCarNativeSoloTimer\",)" in asm
assert 'QA19_SHA256="af6585d750504c1194a756f6b7b3ea8244d53271d115a046380f63c607bde16b"' in asm
assert 'QA20_VERSION="1.0.3-omnicar20-divider-knob-idle"' in asm
assert '"native_host_broadcast_notification":"com.anlai.omnicar.qa19.controls.activity"' in asm
assert "host_dylib" not in asm
assert "QA19_FILES=182" in asm and "other_payload_identical" in asm
print("QA20_ORIGINAL_SCPCarDividerView_KNOB_INDEPENDENT_OPACITY_FIX_SOURCE_PASS")
print("QA20_EXACTLY_ONE_NATIVE_CODE_PATH_EDIT_AND_4S_WAKE_INTACT_PASS")
print("QA20_QA19_HOST_WIRE_AND_181_OTHER_PAYLOAD_ITEMS_PRESERVED_SOURCE_PASS")
