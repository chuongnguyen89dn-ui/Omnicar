#!/usr/bin/env python3
"""HL46 native-only visual bypass regression gate (SOURCE ONLY, NOT DEVICE PASS).

Usage from a checked-out Omnicar repo:
    python3 recovered-source/gpt-project-history/verify_hl46_native_overlay_trial.py
Compare against pinned HL45 rather than an unrelated main or original source.
"""
from pathlib import Path
import subprocess

REPO = Path(__file__).resolve().parents[2]
ROOT = REPO / "recovered-source"
BASE = "3a385c02f121eb6dcc6cf54ad1150ed3531ff1e6"
PROJECT = ROOT / "project/OmniCarSplitScreen/SCPCarSplit+Picker.m"
SRC = ROOT / "src/SplitScreenB/SCPCarSplit+Picker.m"
text = PROJECT.read_text()
assert PROJECT.read_bytes() == SRC.read_bytes(), "Project/src picker drift"

# Negative probes catch accidental broad "make all panes transparent".
assert text.count('BOOL hl46NativeCover = (pane.vc != nil && !SCPVCIsHosted(pane.vc)') == 1
assert text.count('BOOL hl46NativePicker = (pane.vc != nil && !SCPVCIsHosted(pane.vc)') == 1
assert '[OMCPref(@"duocarHL46NativeCoverOff", @YES) boolValue]' in text
assert '[OMCPref(@"duocarHL46NativePickerClear", @YES) boolValue]' in text
cover = text.split('- (void)addCoverToPane:(SCPCarPane *)pane', 1)[1].split(
    '- (void)removeCoverFromPane:', 1)[0]
picker = text.split('- (void)showPickerForSlot:(int)slot', 1)[1].split(
    '- (void)removePickerFromPane:', 1)[0]
assert cover.index("if (hl46NativeCover)") < cover.index('UIView *cover = [[UIView alloc]')
assert 'DCHL45OverlayTrace(self,@"hl46-cover-suppressed"' in cover
assert '[oldCover removeFromSuperview]' in cover
assert 'if (hl46NativePicker)' in picker
assert 'picker.backgroundColor = UIColor.clearColor;' in picker
assert 'if (hl46NativePicker) label.hidden = YES;' in picker
assert 'BOOL removeNativeCover = (oldCover != nil &&' in picker
assert '[OMCPref(@"duocarHL46NativeCoverOff", @YES) boolValue]' in picker
assert 'if (removeNativeCover)' in picker
assert 'coverRetained=%d' in picker
assert picker.index('if (removeNativeCover)') < picker.index(
    'DCHL45OverlayTrace(self,@"hl46-cover-detached-at-picker"')
# The policy matrix must always yield independently selectable
# picker-clear/cover-suppress for native, never modifying hosted/empty.
def policy(has_vc, hosted, picker_switch, cover_switch):
    native = has_vc and not hosted
    return (native and picker_switch, native and cover_switch)
for has_vc, hosted in ((False, False), (False, True), (True, True)):
    for picker_switch in (False, True):
        for cover_switch in (False, True):
            assert policy(has_vc,hosted,picker_switch,cover_switch) == (False,False)
for picker_switch in (False, True):
    for cover_switch in (False, True):
        assert policy(True,False,picker_switch,cover_switch) == (
            picker_switch,cover_switch)
# Old HL45 read-only verifier must NOT be run unmodified on HL46:
# it intentionally restricts the diff to five HL45 files from HL44,
# while HL46 legitimately adds its own checker and two runtime changes.

# Original interaction and diagnose/cleanup must survive.
for token in (
    '[pane.view insertSubview:cover aboveSubview:pane.host]',
    '[pane.view addSubview:picker]', 'action:@selector(pickerPaneTapped:)',
    'DCHL45OverlayTrace(self,@"picker-presented"',
    'DCHL45OverlayTrace(self,@"cover-added"',
    'DCHL45ScheduleTrace(self,@"cover-fade-settled"',
    'DCHL45ScheduleTrace(self,@"picker-fade-settled"',
    '[self refreshPickerSheetSoon]',
    'SCPApplyMeshBackdrop(effectView);',
    'pane.cover = nil;', 'pane.picker = nil;',
    'alpha:1.0]; // original @0x315ec..0x31624',
):
    assert token in text, "Original picker/cover lifecycle lost: "+token

# The only runtime modifications, relative to pinned HL45, are mirrored
# Picker TUs. Diagnostic file and docs may be added; Divider, scene, keyboard,
# Zoom, AutoHide, YTZ, AppBridge, Home and native feed stay untouched.
result = subprocess.run(
    ["git", "-C", str(REPO), "diff", "--name-only", BASE, "HEAD"],
    text=True, capture_output=True, check=True)
modified = set(filter(None, result.stdout.splitlines()))
allowed = {
    "recovered-source/project/OmniCarSplitScreen/SCPCarSplit+Picker.m",
    "recovered-source/src/SplitScreenB/SCPCarSplit+Picker.m",
    "recovered-source/gpt-project-history/verify_hl46_native_overlay_trial.py",
    "recovered-source/gpt-project-history/HL46_NATIVE_OVERLAY_BYPASS_TRIAL_20261113.md",
}
assert modified <= allowed, "Unexpected HL46 paths: "+repr(modified-allowed)
assert all(path in modified for path in (
    "recovered-source/project/OmniCarSplitScreen/SCPCarSplit+Picker.m",
    "recovered-source/src/SplitScreenB/SCPCarSplit+Picker.m")), modified

orig = subprocess.run(
    ["git", "-C", str(REPO), "show",
     BASE+":recovered-source/project/OmniCarSplitScreen/SCPCarSplit+Picker.m"],
    text=True, capture_output=True, check=True).stdout
assert "hl46NativeCover" not in orig and "hl46NativePicker" not in orig
print("HL46_NATIVE_ONLY_OVERLAY_SOURCE_PASS")
print("Not compiled; visual preservation and touch require a matching on-car DEB.")
