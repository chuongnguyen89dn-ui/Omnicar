#!/usr/bin/env python3
"""Standalone source/build-contract gate for DuoCar battery/thermal prototype.

DOES NOT claim binary integration or device-pass. Run from any cwd:
    python3 recovered-source/gpt-project-history/verify_duocar_vitals_static.py
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
    ("OmniCarSplitScreen/SCPDeviceVitalsHUD.h","SplitScreenA/SCPDeviceVitalsHUD.h"),
    ("OmniCarSplitScreen/SCPDeviceVitalsHUD.m","SplitScreenA/SCPDeviceVitalsHUD.m"),
    ("OmniCarSplitScreen/SCPVitalsPlacement.h","SplitScreenA/SCPVitalsPlacement.h"),
    ("OmniCarSplitScreen/SCPVitalsPlacement.c","SplitScreenA/SCPVitalsPlacement.c"),
    ("OmniCarApp/OMCDeviceVitalsController.h","App/OMCDeviceVitalsController.h"),
    ("OmniCarApp/OMCDeviceVitalsController.m","App/OMCDeviceVitalsController.m"),
    ("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m"),
]

for p,q in PAIRS:
    a,b=PROJECT/p,SRC/q
    assert a.is_file() and b.is_file(), (a,b)
    assert a.read_bytes()==b.read_bytes(), f"build/src drift {p} != {q}"

split=(PROJECT/"OmniCarSplitScreen/SCPCarSplit.m").read_text()
src_split=(SRC/"SplitScreenA/SCPCarSplit.m").read_text()
for piece in (
    "SCPVitalsLiveDockFrame(parent)",
    "homeFrame:self.homeGlyph",
    "SCPVitalsLauncherFrame(self, parent)",
    "dashboardInvalidated {",
    "[[SCPDeviceVitalsHUD shared] stop]",
    "SCPVitalsLiveDockFrame(vitalsParent)",
):
    assert piece in split and piece in src_split, piece
assert "dockFrame:[self dockClusterInParent:" not in split
assert "dockFrame:[self dockClusterInParent:" not in src_split

hud=(PROJECT/"OmniCarSplitScreen/SCPDeviceVitalsHUD.m").read_text()
settings=(PROJECT/"OmniCarApp/OMCNativeSettings.m").read_text()
sampler=(PROJECT/"OMCCommon/OMCDeviceVitals.m").read_text()
make_split=(PROJECT/"OmniCarSplitScreen/Makefile").read_text()
make_app=(PROJECT/"OmniCarApp/Makefile").read_text()
assert "SCPVitalsPlace(in)" in hud
assert "userInteractionEnabled = NO" in hud
assert 'OMCPref(@"duocarVitalsEnabled", @NO)' in hud
assert '@"duocarVitalsEnabled",@NO' in settings
assert '"OMCDeviceVitalsController.h"' in settings
assert "OMCVitalsIOKitAPI" in sampler and "dlsym" in sampler
assert "IOKitLib.h" not in sampler
assert "temperatureUnitsVerified" in sampler and "gpuTemperatureVerified" in sampler
assert "SCPVitalsPlacement.c" in make_split and "OMCDeviceVitals.m" in make_split
assert "OMCDeviceVitalsController.m" in make_app and "OMCDeviceVitals.m" in make_app
assert " IOKit" not in make_split and " IOKit" not in make_app
print("DUOCAR_VITALS_SOURCE_AND_MIRRORS_PASS",len(PAIRS))

test=ROOT/"gpt-project-history/test_duocar_vitals_placement.c"
layout=PROJECT/"OmniCarSplitScreen/SCPVitalsPlacement.c"
assert test.is_file() and layout.is_file()
cc=os.environ.get("CC", "clang")
with tempfile.TemporaryDirectory(prefix="duocar-vitals-gate-") as temp:
    binary=Path(temp)/"check"
    compile=[
        cc, "-std=c11", "-Wall", "-Wextra", "-Werror", "-pedantic",
        "-I"+str(PROJECT/"OmniCarSplitScreen"),
        str(layout), str(test), "-lm", "-o", str(binary)
    ]
    subprocess.run(compile,check=True,cwd=ROOT)
    subprocess.run([str(binary)],check=True,cwd=ROOT)
print("DUOCAR_VITALS_HOST_LAYOUT_PASS")
