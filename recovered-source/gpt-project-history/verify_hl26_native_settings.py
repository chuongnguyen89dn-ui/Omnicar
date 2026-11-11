#!/usr/bin/env python3
"""Source-only pre-build guard for native DuoCar iPhone Settings (HL26).

Execute BEFORE rebrand_duocar.py mutates the staged OmniCar project in CI:
  python3 recovered-source/gpt-project-history/verify_hl26_native_settings.py

This checker is NOT a compiler and cannot prove iPhone/vehicle behavior.
"""
from __future__ import annotations

import plistlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project"
SOURCE = ROOT / "src"

files = ("OMCAppDelegate.m", "OMCNativeSettings.m", "OMCNativeSettings.h",
         "OMCNativeStartup.m")
for f in files:
    project=(PROJECT / "OmniCarApp" / f).read_bytes()
    src=(SOURCE / "App" / f).read_bytes()
    assert project==src, f"src/project mismatch: {f}"

delegate=(PROJECT / "OmniCarApp" / "OMCAppDelegate.m").read_text()
native=(PROJECT / "OmniCarApp" / "OMCNativeSettings.m").read_text()
startup=(PROJECT / "OmniCarApp" / "OMCNativeStartup.m").read_text()
makefile=(PROJECT / "OmniCarApp" / "Makefile").read_text()
resource=PROJECT / "OmniCarPrefs" / "Resources"
appinfo=plistlib.load((PROJECT / "OmniCarApp" / "Resources" / "Info.plist").open("rb"))

# Remove comments before checking executable code for the old Settings.app route.
without_comments=re.sub(r"/\*.*?\*/|//[^\n]*", "", delegate, flags=re.S)
assert 'prefs:root' not in without_comments, "Settings.app deep-link reintroduced"
assert "OMCNativeSettingsRootController()" in delegate
assert "application:(UIApplication *)application openURL:" in delegate
assert "NSDistributedNotificationCenter" in delegate
assert "UITabBarController *root" in native
assert "#import <Preferences/" not in native+startup
assert "PSRootController" not in without_comments
assert "NSClassFromString(@\"OMCRootListController\")" not in delegate
assert 'kOMCNativeDomain=@"com.anlai.omnicar"' in native
assert 'kOMCNativeChanged="com.anlai.omnicar/prefschanged"' in native
assert "notify_post(kOMCNativeChanged)" in native
assert "home catalog=BLIND no-changes-allowed" in native
assert "setContentReferenceSize:" not in delegate+native+startup
assert 'OMCNativeSetPref(@"appBridgeApps"' in native
assert 'OMCNativeSetPref(@"homeScreenHiddenApps"' in native
assert 'OMCNativeSetPref(@"homeScreenShownApps"' in native
assert "OMCNativeStartupController()" in native
assert "FeatureStartupScreen" in startup
assert "AVAssetReader" in startup
assert '@"fps":@24' in startup
assert "audio.m4a" in startup
# Negative gates are critical: HL19/HL20 could still render a wrapper while
# handing most taps back to Settings.app or writing keys the engine never reads.
assert 'NSSelectorFromString(@"bundleIdentifier")' in native
assert 'NSSelectorFromString(@"applicationIdentifier")' not in native
assert '@"Left",@"Right",@"Third"' in native
assert 'stringByAppendingFormat:@"App%ld"' not in native
assert '"speedBubbleLook",@0,@[@0,@1,@2,@3,@4,@5,@6,@7,@8]' in native
assert '"speedBubbleSizeCar",100,60,220' in native
assert '"speedBubbleSizePhone",100,60,220' in native
assert "OMCNativePendingRescue" in native
assert 'OMCNativeSetPref(@"rescueFeatures",nil)' in native
assert "home catalog=BLIND no-changes-allowed" in native
assert "homeUseVideo:" in native and "homeUseImage:" in native
assert "replaceItemAtURL:" in native, "Existing Home video must be preserved on staging failure"
assert "OMCNativeStartupDirectory" in startup
assert "BOOL randomRow=" in startup and "style==10" in startup
assert "NSCalendarIdentifierChinese" in startup and "i<400" in startup
assert "AVAudioSessionCategoryPlayback" in startup
assert "indexPathForCell:(UITableViewCell *)sw.superview.superview" not in startup
assert "OMCNativeStartupController()" in native
assert "OMCNativeCurrentLanguage" in native
assert '@"Car"' in native and '@"Localizable"' in native
assert '@"language",nil' in native
assert 'dictionaryWithContentsOfFile:path' in native
assert 'if(!self.onPick)' in native and 'nativeIDs' in native
assert "OMCNativeActiveConflicts" in native
assert "UIAccessibilityPostNotification" in native
assert "homeWallpaperOptions" in native
assert "imagePickerController:(" in native
assert "AVAssetExportPreset1280x720" in native

for f in files:
    assert f in makefile or f.endswith(".h"), f"Makefile missing {f}"
assert re.search(r"^OmniCar_RESOURCE_FILES\s*=",makefile,re.M), "App resources not staged"
assert "filter-out ../OmniCarPrefs/Resources/Info.plist" in makefile, "Prefs Info would overwrite APPL"

assert appinfo["CFBundlePackageType"]=="APPL"
assert appinfo["CFBundleIdentifier"]=="com.anlai.omnicar.app"
assert appinfo["CFBundleExecutable"]=="OmniCar"
assert "omnicar" in appinfo["CFBundleURLTypes"][0]["CFBundleURLSchemes"]
assert appinfo.get("NSPhotoLibraryUsageDescription"), "UIImagePickerController privacy key required"

root=plistlib.load((resource/"Root.plist").open("rb"))
startup_pl=plistlib.load((resource/"FeatureStartupScreen.plist").open("rb"))
split_pl=plistlib.load((resource/"FeatureSplitScreen.plist").open("rb"))
bubble_pl=plistlib.load((resource/"FeatureSpeedBubble.plist").open("rb"))
assert len(root["items"])==15
assert len(startup_pl["items"])==44
assert len(split_pl["items"])==2
assert len(bubble_pl["items"])==2
assert {r.get("detail") for r in root["items"] if r.get("detail")}>={
    "OMCAppBridgeAppsController","OMCHomeScreenController","OMCCarProfilesController"}
root_actions={r.get("action") for r in root["items"] if r.get("action")}
root_handlers={"rescueRestore":"confirmRescue","sendLog":'@"logs"',
               "showGuide":'@"guide"',"showWhatsNew":'@"whatsnew"'}
assert root_actions==set(root_handlers), root_actions
for original, native_token in root_handlers.items():
    assert native_token in native, f"Unmapped Root action: {original}"
actions={r.get("action") for r in startup_pl["items"] if r.get("action")}
for action in sorted(actions):
    assert f'[action isEqualToString:@"{action}"]' in startup, f"Unmapped startup action: {action}"
style_groups=[tuple(r.get("ssStyles",())) for r in startup_pl["items"] if "ssStyles" in r]
assert (9,) in style_groups, "Random style source marker changed"
assert any(r.get("label")=="STARTUPSCREEN_RANDOM_GROUP" and r.get("ssStyles")==[9]
           for r in startup_pl["items"]), "Random group source changed"
for key in ("startupScreenVideoName","startupScreenDuration","startupScreenRandomSet",
            "startupScreenSoundFile","startupScreenBirthday"):
    assert key in startup, f"Startup binding missing {key}"
print("HL26_SOURCE_GUARDS_PASS","Root",len(root["items"]),
      "Startup",len(startup_pl["items"]),"actions",len(actions),
      "project_src_pairs",len(files),"UIKit_only",True)
