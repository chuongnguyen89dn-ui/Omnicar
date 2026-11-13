#!/usr/bin/env python3
"""HL45 source-only guard: instrument original visual layers, never mutate them.

Run from repository root after checking out feature/duocar-hl45-native-visual-probe-20261113:
    python3 recovered-source/gpt-project-history/verify_hl45_original_layer_probe.py

This is not a device/display test and is not a substitute for an iOS build.
"""
from pathlib import Path
import subprocess

ROOT=Path(__file__).resolve().parents[1]
PROJECT=ROOT/"project/OmniCarSplitScreen"
SRC=ROOT/"src/SplitScreenB"
BASE="44b737d95ae4b6721deeb03f7052ee40e8d7e2ea"

for file in ("SCPCarSplit+Picker.m","SCPCarSplit+Divider.m"):
    built=(PROJECT/file).read_bytes()
    mirrored=(SRC/file).read_bytes()
    assert built==mirrored, f"Source/build mismatch: {file}"

picker=(PROJECT/"SCPCarSplit+Picker.m").read_text()
divider=(PROJECT/"SCPCarSplit+Divider.m").read_text()
for token in (
    "void DCHL45OverlayTrace(",
    "[hl45-layer]",
    "presentationLayer", "bgA=%.2f", "winHidden=%d",
    '@"cover-fade-settled"', '@"picker-fade-settled"', '@"sheet-fade-settled"',
    '@"cover-added"', '@"cover-remove-request"', '@"cover-remove-complete"',
    '@"picker-presented"', '@"picker-remove-request"', '@"picker-remove-complete"',
    '@"sheet-new-attached"', '@"sheet-old-removed"',
    '@"sheet-remove-request"', '@"sheet-remove-complete"',
    '@"loader-added"', '@"loader-remove-request"', '@"loader-remove-complete"',
):
    assert token in picker, f"Missing probe: {token}"
for token in ('@"resize-begin-pre-cover"', '@"resize-end-released"',
              '@"resize-cleanup-deferred"', '@"resize-cleanup-start"'):
    assert token in divider, f"Missing divider probe: {token}"
for token in (
    "[pane.view insertSubview:cover aboveSubview:pane.host]",
    "[pane.view addSubview:picker]",
    "alpha:1.0]; // original @0x315ec..0x31624",
    "SCPApplyMeshBackdrop(effectView);",
    "[pane.view insertSubview:loader aboveSubview:pane.host]",
    "pane.cover = nil;", "pane.picker = nil;", "pane.loader = nil;",
):
    assert token in picker, f"Original layer path missing: {token}"
for token in ("SCPDispatchAfter(0.45,", "[self relayoutAnimated:NO pushScenes:NO]",
              "[s removeCoverFromPane:pane]"):
    assert token in divider, f"Original divider path missing: {token}"
# No UI object created by the read-only trace helper; delayed callbacks only sample UIKit.
trace=picker.split("// [hl45-layer] Observation only:",1)[1].split(
    "static NSString *SCPViewMeasureDesc(",1)[0]
for disallowed in ("alloc] init", "addSubview:", "insertSubview:",
                   "makeKeyAndVisible", "setHidden:", "removeFromSuperview",
                   "setAlpha:", ".hidden =", ".alpha =", "windowLevel ="):
    assert disallowed not in trace, f"Diagnostic mutates UI: {disallowed}"
# The only source changes since the frozen HL44 baseline are these four TUs
# plus THIS guard (not a hidden keyboard / Zoom / native scene rewrite).
git_root=ROOT.parent
proc=subprocess.run(
    ["git","-C",str(git_root),"diff","--name-only",BASE,"HEAD"],
    capture_output=True,text=True,check=True)
changed=set(filter(None,proc.stdout.splitlines()))
allowed={
    "recovered-source/project/OmniCarSplitScreen/SCPCarSplit+Picker.m",
    "recovered-source/src/SplitScreenB/SCPCarSplit+Picker.m",
    "recovered-source/project/OmniCarSplitScreen/SCPCarSplit+Divider.m",
    "recovered-source/src/SplitScreenB/SCPCarSplit+Divider.m",
    "recovered-source/gpt-project-history/verify_hl45_original_layer_probe.py",
}
assert changed and changed<=allowed, f"Unapproved source changes: {sorted(changed-allowed)}"
assert len(changed & allowed)>=4, f"Missing probe files: {sorted(changed)}"
print("HL45_SOURCE_PASS: four mirrored picker/divider files, original covers intact, diagnostic-only events")
print("NO BUILD/DEVICE PASS CLAIMED")
