#!/usr/bin/env python3
"""HL31 source contract: original-behavior-mapped first-party bubble only.
This checks structural regressions, not live CarPlay hit-testing or audio TCC.
"""
from pathlib import Path
root=Path(__file__).resolve().parents[1]
project=root/"project/OmniCarSplitScreen"
src=root/"src/SplitScreenA"
for name in ("SCPVoiceBubbleView.h","SCPVoiceBubbleView.m","SCPVoiceNative.m"):
    assert (project/name).read_bytes()==(src/name).read_bytes(), name+" source/project mismatch"
bubble=(project/"SCPVoiceBubbleView.m").read_text()
head=(project/"SCPVoiceBubbleView.h").read_text()
native=(project/"SCPVoiceNative.m").read_text()
mk=(project/"Makefile").read_text()
split=(project/"SCPCarSplit.m").read_text()
hooks=(project/"SCPHooks.m").read_text()
assert "SCPVoiceBubbleView.m" in mk and "SCPVoiceNative.m" in mk
assert "SCPVoiceBubbleView" in native
assert "static UIButton *DCVoiceButton" not in native
assert "[UIButton buttonWithType:" not in native
assert "UIWindow new" not in bubble and "windowLevel" not in bubble
assert "UIWindow new" not in native
assert "initWithBoundaryBounds:" in head and "updateBoundaryBounds:" in head
assert 'DuoCar.voiceBubble.left' in bubble and 'DuoCar.voiceBubble.normalizedY' in bubble
assert "saveAIBubblePositionIsLeft:" not in bubble # no private/vendor calls
assert "UIPanGestureRecognizer" in bubble
assert "UITapGestureRecognizer" in bubble
assert "requireGestureRecognizerToFail:pan" in bubble
assert "handleTap:" in bubble and "handlePan:" in bubble
assert "snapToNearestEdgeAnimated:" in bubble
assert "onBubbleTapped" in bubble and "onBubbleTapped" in native
assert "onPositionChanged" in bubble
assert "[self wakeBubble]" in bubble
assert "restartIdleTimer" in bubble and "dimBubble" in bubble
assert "setVoiceState:" in head and "SCPVoiceBubbleStateListening" in head
assert "SCPVoiceBubbleStateError" in head
assert "SCPVoiceBubbleStateThinking" in head
assert "SCPVoiceBubbleStateSpeaking" in head
assert "gestureRecognizer:" in bubble and "pointInside:" in bubble
assert "SCPVoiceNativeToggle(owner)" in native
assert 'event=carplay-bubble-hit owner=existing-split' in native
assert 'event=carplay-permission-block' in native
assert 'event=carplay-audio-started' in native
assert "SCPVoiceBubbleDetach(self)" in split
assert "SCPVoiceBubbleUpdate(self)" in split
assert "SCPVoiceBubbleUpdate([SCPCarSplit shared])" in hooks
assert "split.tray!=nil || split.pickerSheet!=nil" in native
assert "split.resizing || split.dragGhost!=nil" in native
assert "SCPVoiceDispatchLocalCommand(command)" in native
assert "TCC.db" not in bubble and "TCC.db" not in native
assert "--grant-tcc" not in native and "--grant-tcc" not in bubble
print("HL31_BUBBLE_SOURCE_CONTRACT_PASS, device-proven=NO, mic-authorization=BLOCKED")
