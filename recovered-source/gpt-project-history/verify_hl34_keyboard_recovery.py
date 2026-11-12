#!/usr/bin/env python3
"""HL34 recovery contracts against two measured *different* failures:
HL32 resized/rolled back a live keyplane; HL33 had NO viewport writer
while the drawn keyboard was permanently disabled. These tests are
static, never a substitute for car screen/touch evidence.
"""
from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
project=root/"project"
src=root/"src"
pairs=[
("OmniCarAppBridge/ABInApp.m","AppBridgeB/ABInApp.m"),
("OmniCarAppBridge/ABKeyboardTraits104.m","AppBridgeB/ABKeyboardTraits104.m"),
("OmniCarAppBridge/ABKeyboardTraits104.h","AppBridgeB/ABKeyboardTraits104.h"),
("OmniCarAppBridge/ABHostGeometry.m","AppBridgeB/ABHostGeometry.m"),
("OmniCarSplitScreen/SCPVoiceSpringAgent.m","SplitScreenA/SCPVoiceSpringAgent.m"),
("OmniCarSplitScreen/SCPVoiceNative.m","SplitScreenA/SCPVoiceNative.m"),
]
for a,b in pairs:
    assert (project/a).read_bytes()==(src/b).read_bytes(),(a,b)
ab=(project/"OmniCarAppBridge/ABInApp.m").read_text()
kb=(project/"OmniCarAppBridge/ABKeyboardTraits104.m").read_text()
hdr=(project/"OmniCarAppBridge/ABKeyboardTraits104.h").read_text()
host=(project/"OmniCarAppBridge/ABHostGeometry.m").read_text()
mode=(project/"OmniCarAppBridge/ABHostBMethods.m").read_text()
agent=(project/"OmniCarSplitScreen/SCPVoiceSpringAgent.m").read_text()
# Preexisting forced native mode must not silently disable BOTH owners.
assert "return YES;" in mode[mode.index("BOOL ABNativeKeyboardEnabled"):mode.index("BOOL ABDrawnKeyboardEnabled")]
assert "return !ABNativeKeyboardEnabled()" in mode
assert "ABKB104PlaceKeyboardWindow(keyboard,key,when)" in ab
assert "ABKB104PlaceKeyboardWindow(UIWindow *keyboard" in hdr
assert "BOOL ABKB104PlaceKeyboardWindow(UIWindow *keyboard" in kb
# Exactly one direct UIKit keyboard.frame WRITE across active first-party
# in-app implementations. No 2nd scale/center/bounds writer.
assert len(re.findall(r"keyboard\\.frame\\s*=",kb))==1
assert len(re.findall(r"keyboard\\.frame\\s*=",ab))==0
for token in ["ABNativeKbFit(", "ABNativeKbRestore(", 
              "keyplane-timeout-rollback", "keyboard.transform =",
              "UIKeyboardLayoutStar.transform =","layout.transform ="]:
    assert token not in ab,token
assert "CGAffineTransformMakeScale(scale, scale)" not in ab
assert "KB104PositionedWindow" in kb and "KB104OriginalWindowFrame" in kb
assert "KB104LastPositionedFrame" in kb and "KB104HasFrameSnapshot" in kb
assert "KB104CloseEnough(before,KB104LastPositionedFrame)" in kb
assert "ABKB104RestoreKeyboardWindow" in kb
assert "KB104PositionedWindow=nil" in kb
for reason in ('@"did-hide"', '@"host-release"', '@"host-close"', '@"host-close-all"'):
    assert 'ABKB104RestoreKeyboardWindow('+reason+')' in ab,reason
assert "KB104KeyboardWindow" in kb and "ABKB104InspectClips" in ab
assert "KB104UnclipOwnedView" in kb
assert "if (keyboard && key)" in ab
assert "if (keyboard && key && star)" not in ab
assert "if (win.isKeyWindow || !key) key=win" in ab
# The HL33 regression changed a keyboard screen reference HEIGHT into
# PANE height; that must never be repeated. Only width can be changed.
rf=kb[kb.index("static CGSize KB104Reference("):kb.index("static void KB104Hook(")]
assert "original.width=wanted" in rf
assert "original.height=" not in rf
assert "KB104LogicalH" not in rf
# A zero packet from scene animation must not revoke a valid assignment.
assert "keep-committed-geometry=1" in ab
assert "revision < ABNativeKbGeometryRevision" in ab
assert "kbLogicalH" in host and "kbPhysicalH" in host
# No TCC changes, no audio owner rerouting by a keyboard-only recovery.
assert "DC33MeasureBuffer(buffer)" in agent
assert "event=voice-verdict" in agent
for forbidden in ("TCC.db","--grant-tcc","cboptimize_helper","setuid"):
    assert forbidden not in kb+ab+agent
# Independent historical counterexamples: HL32's 744pt display failed
# 1.6 cap, and HL33 lacked any compositor placement in native-only mode.
assert 744/375>1.6
assert 7.5+480<=495<7.5+495
print("HL34_SOURCE_CONTRACT_PASS: singular window owner, retained native gate, no arbitrary ref height; DEVICE-PENDING")
