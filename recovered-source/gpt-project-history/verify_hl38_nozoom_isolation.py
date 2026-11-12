#!/usr/bin/env python3
"""HL38 zoom=1 A/B: fail unless only the global hosted AppBridge zoom is bypassed.

This checks source invariants, NOT runtime keycap visibility/touch.
Run before rebrand, from any cwd: python3 recovered-source/gpt-project-history/verify_hl38_nozoom_isolation.py
"""
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parent.parent
project = ROOT / "project"
source = ROOT / "src"

def git_blob_sha(path: Path) -> str:
    data = path.read_bytes()
    return hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()

def check_mirror(rel_p: str, rel_s: str, expected_blob: str | None = None) -> str:
    p, s = project / rel_p, source / rel_s
    a, b = p.read_bytes(), s.read_bytes()
    assert a == b, f"src/project diverged: {rel_p} vs {rel_s}"
    sha = git_blob_sha(p)
    if expected_blob:
        assert sha == expected_blob, f"out-of-scope edit: {rel_p} {sha} != {expected_blob}"
    return a.decode("utf-8")

host = check_mirror("OmniCarAppBridge/ABHostBMethods.m", "AppBridgeB/ABHostBMethods.m")
head = host.split("- (double)zoom {", 1)
assert len(head) == 2
body, rest = head[1].split("\n}\n", 1)
assert body.count("return 1.0;") == 1
assert "[hl38-nozoom-ab] event=appbridge-zoom-bypass z=1.000" in body
assert 'OMCPref(@"appBridgeZoom"' not in body
assert "OMCPrefsSync();" in body
assert host.count("CGAffineTransformMakeScale(z, z)") == 1
assert 'CGSizeMake(round(boxSize.width / z), round(boxSize.height / z))' in host
assert "ABSceneSettingsApply(scene, logical, orient)" in host
assert "return;" in host.split("if (live) {", 1)[1].split("\n    }", 1)[0]
assert "setContentReferenceSize:withInterfaceOrientation:" in host
# No private setter enabled by this A/B; existing probe remains read-only.
assert "probe-interface-abi-matches-NOT-CALLED" in host
check_mirror("OmniCarAppBridge/ABYTZoom.m", "AppBridgeB/ABYTZoom.m",
             "c54b4c7a91ad9aa6a8535d08d0d63123ba746913")
keyboard = check_mirror("OmniCarAppBridge/ABInApp.m", "AppBridgeB/ABInApp.m",
                        "2cd399c74d07efc845d19eefffbdf83390734666")
assert "[hl36-kbsync]" in keyboard
for name, expected in (
    ("SCPCarSplit+Picker.m", "2639a69e9504b901f877697490c6dba57e2e1bbb"),
    ("SCPCarSplit+RatioMenu.m", "f79e05150ba574308449694094ee67b40e20e89b"),
    ("SCPCarSplit+Divider.m", "274d0b9dde1129c0155d8cb0509354fa0787875f"),
):
    txt = check_mirror(f"OmniCarSplitScreen/{name}", f"SplitScreenB/{name}", expected)
    if name.endswith("+Picker.m"):
        assert "[hl22-original] picker-pane-opacity=1.0" in txt
        assert "picker.backgroundColor" in txt
    if name.endswith("+RatioMenu.m"):
        assert "[self addCoverToPane:pane]" in txt
# Two baseline A/B width relationships; NOT a keyboard reflow assertion.
assert round(297 / 1.0) == 297
assert round(297 / 0.8) == 371
assert round(198 / 1.0) == 198
assert round(198 / 0.8) == 248
print("HL38_NOZOOM_ISOLATION_SOURCE_PASS mirrors=6/6 baseline-menu/pinch/keyboard=unchanged zoom=1.0 runtime=NOT_PROVEN")
