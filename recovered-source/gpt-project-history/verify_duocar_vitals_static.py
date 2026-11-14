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
    assert "SCPFullscreenVitalsBubble" not in s, "split path must not own fullscreen bubble"
    close=s.split("- (void)closeGoingHome:(BOOL)goHome {",1)[1].split("- (void)homePressedDuringSplit:",1)[0]
    # Muse-owned YTZ/AutoHide checkpoints must remain before the new FS teardown.
    assert close.index('SCPLogInjectedIconState(@"before-close", src)') < close.index("[self ahCloseCleanup];")
    assert close.index("[self ahCloseCleanup];") < close.index("[[SCPFullscreenController shared] fsSessionDidEnd];")
    assert close.index("[[SCPFullscreenController shared] fsSessionDidEnd];") < close.index("[self hostCloseAll];")
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
assert "overlay convertRect:host.bounds fromWindow:host" in bubble
assert "CGRectIntersection(mapped,overlay.bounds)" in bubble
assert "self.overlayWindow.screen != host.screen" in bubble
assert "userInteractionEnabled = YES" in bubble
assert "DCFVPassHitTest" in bubble and "isDescendantOfView:bubble" in bubble
assert "UIRootSceneWindow" in bubble and "initWithDisplayConfiguration:" in bubble
assert "window.windowLevel = UIWindowLevelStatusBar + 64.0" in bubble
assert "SCPVitalsBubbleBoundCenter" in bubble and "SCPVitalsBubbleEdgeCenter" in bubble
assert "SCPVitalsBubbleSelectDockPosition" in bubble and "SCPVitalsBubbleRestoreDockPosition" in bubble
assert "UIPanGestureRecognizer" in bubble and "pan.maximumNumberOfTouches = 1" in bubble
assert "[fs-vitals] drag %@ edge=" in bubble
assert "DCFVEdgeKey" in bubble and "DCFVYKey" in bubble
assert "DCFVDockedKey" in bubble and "DCFVXKey" in bubble
assert 'self.edgeDocked?@"snap":@"free"' in bubble
assert "self.pill.center=[self storedBubbleCenter];" in bubble
assert "static const CGFloat DCFVMargin = 3.0;" in bubble
assert "self.pill.alpha = 1.0" in bubble
assert "self.overlayWindow.hidden = YES" in bubble and "sourceWindow != host" in bubble
assert "idleTimer" not in bubble and "dimBubble" not in bubble
assert "userInteractionEnabled = NO" not in bubble
assert "SCPVoiceBubbleView" not in bubble and "SCPVoiceNative" not in bubble
assert "SCPDeviceVitalsHUD" not in bubble and "SCPFullscreenVitalsBubble.m" in make_split
assert "NSDateFormatterShortStyle" in bubble
assert "NSSystemTimeZoneDidChangeNotification" in bubble
assert "NSCurrentLocaleDidChangeNotification" in bubble
assert "UIApplicationSignificantTimeChangeNotification" in bubble
assert 'OMCPref(@"duocarFullscreenVitalsEnabled",@YES)' in bubble
assert "@\"duocarFullscreenVitalsEnabled\",@YES" in settings
assert '@"duocarVitalsEnabled",@NO' not in settings
assert "SCPVitalsFullscreenBubblePlace" in layout
assert "SCPFullscreenVitalsBubble.m" in make_split
# HL54 must preserve the existing Dock vitals module while the fullscreen
# clock bubble remains a separately gated owner. Source absence from
# SCPCarSplit.m is checked above; a compiled Dock module is not a duplicate.
assert "SCPDeviceVitalsHUD.m" in make_split
assert "SCPVitalsPlacement.c" in make_split
assert "OMCDeviceVitals.m" in make_split and "OMCDeviceVitals.m" in make_app
assert "OMCDeviceVitalsController.m" in make_app
assert "IOKitLib.h" not in sampler and "dlsym" in sampler
assert "temperatureUnitsVerified" in sampler and "gpuTemperatureVerified" in sampler
assert " IOKit" not in make_split and " IOKit" not in make_app
print("FS_VITALS_DRAG_PASS_THROUGH_SOURCE_GATE_PASS",len(PAIRS))

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
print("FS_VITALS_FULLSCREEN_DRAG_GEOMETRY_TEST_PASS")

# HL54: the real clock-bubble geometry is tested independently against
# the current project C, not a hand-copied approximation.
clock_test=ROOT/"gpt-project-history/test_hl54_clock_docking.c"
assert clock_test.is_file()
with tempfile.TemporaryDirectory(prefix="hl54-clock-docking-") as tmp:
    binary=Path(tmp)/"hl54-clock"
    args=[cc,"-std=c11","-Wall","-Wextra","-Werror","-pedantic",
          "-I"+str(PROJECT/"OmniCarSplitScreen"),
          str(PROJECT/"OmniCarSplitScreen/SCPVitalsPlacement.c"),
          str(clock_test),"-lm","-o",str(binary)]
    subprocess.run(args,cwd=ROOT,check=True)
    subprocess.run([str(binary)],cwd=ROOT,check=True)
print("HL54_FULLSCREEN_CLOCK_NEAR_EDGE_FREE_XY_TEST_PASS")
