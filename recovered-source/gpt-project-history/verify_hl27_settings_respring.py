#!/usr/bin/env python3
"""HL27 source invariants: original Settings root, confirmed Respring bridge
and read-only keyboard keyplane probe. This is NOT iPhone/vehicle QA.
Run before rebrand on macOS workflow or any Python 3 checkout.
"""
from pathlib import Path
import plistlib
import re

ROOT=Path(__file__).resolve().parents[1]
PROJECT=ROOT/"project"
SRC=ROOT/"src"
pairs=[
 ("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m"),
 ("OmniCarApp/OMCNativeSettings.h","App/OMCNativeSettings.h"),
 ("OmniCarApp/OMCAppDelegate.m","App/OMCAppDelegate.m"),
 ("OmniCarApp/OMCNativeStartup.m","App/OMCNativeStartup.m"),
 ("OmniCarSplitScreen/SCPSpringBoardHooks.m","SplitScreenA/SCPSpringBoardHooks.m"),
 ("OmniCarAppBridge/ABInApp.m","AppBridgeB/ABInApp.m"),
]
files={}
for a,b in pairs:
    left=(PROJECT/a).read_bytes()
    right=(SRC/b).read_bytes()
    assert left==right,(a,b,"project/src divergence")
    files[a]=left.decode("utf-8")
native=files["OmniCarApp/OMCNativeSettings.m"]
spring=files["OmniCarSplitScreen/SCPSpringBoardHooks.m"]
keyboard=files["OmniCarAppBridge/ABInApp.m"]
delegate=files["OmniCarApp/OMCAppDelegate.m"]
assert "UITabBarController *root" in native
assert '[hl27-settings] gate=original-root-cards' in native
assert 'OMCRow(@"APPS",@"apps"' in native
assert 'OMCRow(@"HOME_SCREEN",@"home"' in native
assert native.index('OMCRow(@"STARTUPSCREEN",@"startup"')<native.index('OMCRow(@"SPEEDBUBBLE",@"bubble"')<native.index('OMCRow(@"SPLITSCREEN",@"split"')
assert 'self.tableView.tableHeaderView=header' in native
assert 'self.navigationItem.rightBarButtonItems=@[respring,language]' in native
assert 'OMCNativeSetPref(@"enabled",@(wanted))' in native
assert 'OMCNativeSetPref(@"language",code)' in native
assert "OMCNativeSettingsRootController()" in delegate
assert "prefs:root" not in re.sub(r"/\*.*?\*/|//[^\n]*","",delegate,flags=re.S)
# A confirmed user request starts from iPhone. No SBS private selector is
# called by the sandboxed app; an ACK is needed to know SpringBoard received it.
assert 'com.anlai.omnicar/respring.request' in native
assert 'com.anlai.omnicar/respring.ack' in native
assert '[hl27-respring] stage=request-sent' in native
assert '[hl27-respring] stage=ack-timeout' in native
assert "SBSRelaunchAction" not in native
assert 'kill(getpid()' not in native
assert 'SCP27RespringRequest(NSNotification *note)' in spring
assert 'com.anlai.omnicar/respring.request' in spring
assert 'com.anlai.omnicar/respring.ack' in spring
assert 'stage=observer-ready' in spring
assert 'stage=accepted' in spring
assert 'stage=terminate-self' in spring
assert 'isEqualToString:@"com.apple.springboard"' in spring
assert 'nonce.length==36' in spring
assert 'fabs(now-stamp.doubleValue)<12.0' in spring
assert 'kill(getpid(),SIGKILL)' in spring
# Probe is confined to geometry. Never alter UIKit keyplane transform.
assert 'AB27FindKeyplane' in keyboard
assert '[hl27-keyplane]' in keyboard
assert 'pixels=UNKNOWN touch=UNKNOWN' in keyboard
assert '[keyboard hitTest:' not in keyboard
assert "layout.transform =" not in keyboard[keyboard.index("static UIView *AB27FindKeyplane"):keyboard.index("static BOOL ABNativeKbObserveLayout")]
assert "setContentReferenceSize" not in keyboard
# The original Root/plist schemas are unchanged. The implemented order is
# grounded in explicit featureOrder values, not an arbitrary redesign.
prefs=PROJECT/"OmniCarPrefs"/"Resources"
features=[]
for name in ("FeatureStartupScreen","FeatureSpeedBubble","FeatureSplitScreen"):
    data=plistlib.load((prefs/(name+".plist")).open("rb"))
    features.append((data["featureOrder"],name))
assert features==[(10,"FeatureStartupScreen"),(20,"FeatureSpeedBubble"),(30,"FeatureSplitScreen")],features
root=plistlib.load((prefs/"Root.plist").open("rb"))
assert len(root["items"])==15
rebrand=(ROOT/"gpt-project-history"/"rebrand_duocar.py").read_text()
assert "1.0.3-hl31bubbleaudit" in rebrand
print("HL27_SOURCE_PASS",{"project_src_pairs":len(pairs),"root":15,"features":features,"springboard_only":True,"keyplane_read_only":True})
