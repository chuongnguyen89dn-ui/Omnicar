#!/usr/bin/env python3
"""Offline static and C geometry contract for DuoCar fullscreen-only status bubble.

Invoked on a real full checkout:
  python3 recovered-source/gpt-project-history/verify_duocar_vitals_static.py
NO Theos or signing. Does NOT establish runtime/vehicle correctness.
"""
from pathlib import Path
import subprocess
import tempfile
import os

ROOT=Path(__file__).resolve().parents[1]
PROJECT=ROOT/"project"
SRC=ROOT/"src"
PAIRS=[
    ("OMCCommon/OMCDeviceVitals.h","OMCCommon/OMCDeviceVitals.h"),
    ("OMCCommon/OMCDeviceVitals.m","OMCCommon/OMCDeviceVitals.m"),
    ("OmniCarSplitScreen/SCPVitalsPlacement.h","SplitScreenA/SCPVitalsPlacement.h"),
    ("OmniCarSplitScreen/SCPVitalsPlacement.c","SplitScreenA/SCPVitalsPlacement.c"),
    ("OmniCarSplitScreen/SCPFullscreenVitalsBubble.h","SplitScreenA/SCPFullscreenVitalsBubble.h"),
    ("OmniCarSplitScreen/SCPFullscreenVitalsBubble.m","SplitScreenA/SCPFullscreenVitalsBubble.m"),
    ("OmniCarSplitScreen/SCPFullscreenController.h","SplitScreenA/SCPFullscreenController.h"),
    ("OmniCarSplitScreen/SCPFullscreenController.m","SplitScreenA/SCPFullscreenController.m"),
    ("OmniCarApp/OMCDeviceVitalsController.h","App/OMCDeviceVitalsController.h"),
    ("OmniCarApp/OMCDeviceVitalsController.m","App/OMCDeviceVitalsController.m"),
    ("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m"),
]
for p,q in PAIRS:
    a,b=PROJECT/p,SRC/q
    assert a.is_file() and b.is_file(), (a,b)
    assert a.read_bytes()==b.read_bytes(), f"source/project drift: {p} vs {q}"
    
split=(PROJECT/"OmniCarSplitScreen/SCPCarSplit.m").read_text()
src_split=(SRC/"SplitScreenA/SCPCarSplit.m").read_text()
for s in (split,src_split):
    assert "SCPDeviceVitalsHUD" not in s, "Non-fullscreen Dock HUD still attached"
    assert "SCPVitalsLiveDockFrame" not in s
    assert "SCPVitalsLauncherFrame" not in s
fs=(PROJECT/"OmniCarSplitScreen/SCPFullscreenController.m").read_text()
bubble=(PROJECT/"OmniCarSplitScreen/SCPFullscreenVitalsBubble.m").read_text()
settings=(PROJECT/"OmniCarApp/OMCNativeSettings.m").read_text()
sampler=(PROJECT/"OMCCommon/OMCDeviceVitals.m").read_text()
layout=(PROJECT/"OmniCarSplitScreen/SCPVitalsPlacement.c").read_text()
make_split=(PROJECT/"OmniCarSplitScreen/Makefile").read_text()
make_app=(PROJECT/"OmniCarApp/Makefile").read_text()

assert "SCPFullscreenVitalsBubble.h" in fs
assert "fsFireStateDidChange:(SCPFullscreenState)state" in fs
assert "showForConfirmedFullscreenInParent:parent" in fs
assert "showForConfirmedFullscreenInParent:split.container.superview" in fs
assert "SCPFullscreenVitalsBubble shared] stop" in fs
assert "if (_fsStateDidChange) _fsStateDidChange(state)" in fs # preserve pinch adapter
assert "fsChromeSetHidden:YES" in fs and "fsChromeSetHidden:NO" in fs
assert "SCPFullscreenBubblePlace" not in fs
assert "SCPVitalsFullscreenBubblePlace" in bubble
assert "SCPFullscreenStateExpanded" in bubble
assert "parent convertRect:parent.window.bounds fromView:parent.window" in bubble
assert "userInteractionEnabled = NO" in bubble
assert "NSDateFormatterShortStyle" in bubble
assert "NSSystemTimeZoneDidChangeNotification" in bubble
assert "NSCurrentLocaleDidChangeNotification" in bubble
assert "UIApplicationSignificantTimeChangeNotification" in bubble
assert 'OMCPref(@"duocarFullscreenVitalsEnabled", @YES)' in bubble
assert "@\"duocarFullscreenVitalsEnabled\",@YES" in settings
assert '@"duocarVitalsEnabled",@NO' not in settings
assert "SCPVitalsFullscreenBubblePlace" in layout
assert "SCPFullscreenVitalsBubble.m" in make_split
assert "SCPDeviceVitalsHUD.m" not in make_split
assert "SCPVitalsPlacement.c" in make_split
assert "OMCDeviceVitals.m" in make_split and "OMCDeviceVitals.m" in make_app
assert "OMCDeviceVitalsController.m" in make_app
assert "IOKitLib.h" not in sampler and "dlsym" in sampler
assert "temperatureUnitsVerified" in sampler and "gpuTemperatureVerified" in sampler
assert " IOKit" not in make_split and " IOKit" not in make_app
print("FS_VITALS_SOURCE_MIRRORS_GATE_PASS",len(PAIRS))

cc=os.environ.get("CC","clang")
test=ROOT/"gpt-project-history/test_duocar_vitals_placement.c"
assert test.is_file()
with tempfile.TemporaryDirectory(prefix="fs-vitals-") as tmp:
    binary=Path(tmp)/"fs-vitals-geometry"
    args=[cc,"-std=c11","-Wall","-Wextra","-Werror","-pedantic",
          "-I"+str(PROJECT/"OmniCarSplitScreen"),
          str(PROJECT/"OmniCarSplitScreen/SCPVitalsPlacement.c"),str(test),
          "-lm","-o",str(binary)]
    subprocess.run(args,cwd=ROOT,check=True)
    subprocess.run([str(binary)],cwd=ROOT,check=True)
print("FS_VITALS_FULLSCREEN_GEOMETRY_TEST_PASS")
