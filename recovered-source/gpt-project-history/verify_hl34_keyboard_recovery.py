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
assert "ABKB104PlaceKeyboardWindow(keyboard,key,preflightPlane,when)" in ab
assert "ABKB104PlaceKeyboardWindow(UIWindow *keyboard" in hdr
assert "BOOL ABKB104PlaceKeyboardWindow(UIWindow *keyboard" in kb
# Exactly one direct UIKit keyboard.frame WRITE across active first-party
# in-app implementations. No 2nd scale/center/bounds writer.
assert len(re.findall(r"keyboard\.frame\s*=",kb))==1
assert len(re.findall(r"keyboard\.frame\s*=",ab))==0
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
assert "BOOL placed=keyboard && key" in ab
assert "ABKB104PlaceKeyboardWindow(keyboard,key,preflightPlane,when)" in ab
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
# HL36: native UIKit is the only built keyboard implementation.
# Historical ABKeyboard.m and ABTelex.m survive in source for reference,
# but neither is in the actual Theos compilation units.
manifest=(project/"OmniCarAppBridge/Makefile").read_text()
fileline=next(line for line in manifest.splitlines()
              if line.startswith("OmniCarAppBridge_FILES ="))
built=set(fileline.partition("=")[2].split())
assert "ABKeyboardTraits104.m" in built
assert "ABInApp.m" in built and "ABHostGeometry.m" in built
assert "ABKeyboard.m" not in built and "ABTelex.m" not in built
assert (project/"OmniCarAppBridge/ABKeyboard.m").is_file()
assert (project/"OmniCarAppBridge/ABTelex.m").is_file()
for legacy in ("ABKeyboard.m", "ABTelex.m"):
    assert (project/"OmniCarAppBridge"/legacy).read_bytes()==(src/"AppBridgeB"/legacy).read_bytes(),legacy
for banned in ("ABKeyBlock(", "ABKeyboardPublish(", "ABChanKey",
               "ABNotifyKeyboard", "ABBlankInputViewKey",
               "ABSuppressSystemKeyboard(", "ABRestoreBlankInputView("):
    assert banned not in ab, banned
for banned in ("ABKeyboardDispatch(", "ABNotifyKeyboard",
               "[[ABKeyboard shared]"):
    assert banned not in host, banned
assert 'NSClassFromString(@"ABKeyboard")' not in (project/"OmniCarAppBridge/ABHostLaunch.m").read_text()
assert 'performSelector:@selector(hideForApp:)' not in (project/"OmniCarAppBridge/ABHostLaunch.m").read_text()
assert "ABChanKey" not in (project/"OmniCarAppBridge/ABChannelNames.m").read_text()
assert "ABNotifyKeyboard" not in (project/"OmniCarAppBridge/ABChannelNames.m").read_text()
assert "ABChanKey" not in (project/"OmniCarAppBridge/AppBridgeB.h").read_text()
assert "ABTelexApply(" not in (project/"OmniCarAppBridge/AppBridgeB.h").read_text()
assert "ABKeyboardDispatch(" not in (project/"OmniCarAppBridge/ABIntegrationShims.h").read_text()
assert "[responder setInputView:" not in ab
assert "static const BOOL ABDrawnKb = NO" in ab
assert "[hl36-native-only] drawnKeyboard=1 ignored" in ab
assert "BWKbStateBecame()" in ab and "BWKbStateResignedDeferred()" in ab
assert "BWKbLocalSet(BWKbActive)" in ab and "BWKbLocalSet(BWKbInactive)" in ab
assert "ABKB104PlaceKeyboardWindow(keyboard,key,preflightPlane,when)" in ab
assert "ABKB104InstallIfAvailable()" in ab
assert 'ABNativeKbBegin(@"focus-became")' in ab
assert "ABKbSyncNoteEvent(bundleID, NO)" in (project/"OmniCarAppBridge/ABHostLaunch.m").read_text()
assert "ABNotifyAppOrient" in host
assert "KB104PositionedWindow" in kb
assert "keyboard.frame=target" in kb
# HL36: actual native UIKit keyplane must be compatible with the hosted
# remote keyboard window BEFORE a narrower scene revision is applied.
assert "CGRect keyplaneInWindow" in hdr
assert "CGRect keyplaneInWindow" in kb
assert "KB104PlaneFitsViewport" in kb
assert "planeKnown && !fits && (narrowing || !changed)" not in kb
assert "action=commit-one-owner-and-refresh-traits" in kb
assert "ABNativeKbScheduleUIKitReflow" in ab
assert "[responder reloadInputViews]" in ab
assert "ABNativeKbReflowTicket" in ab
assert "revision!=ABNativeKbGeometryRevision" in ab
assert "focus!=ABNativeKbFocusSerial" in ab
assert 'ABNativeKbObserve(@"post-uikit-reflow")' in ab
assert '"[hl38-keyplane] event=viewport-stale-plane' in kb
assert '"[hl38-keyplane] event=refresh-request' in kb
assert "ABKB104RequestUIKitKeyplaneUpdate" in kb
assert "ABKB104RequestUIKitKeyplaneUpdate" in hdr
assert "KB104Signature(starClass,setter,NO,3,'v','@',0)" in kb
assert 'NSSelectorFromString(@"updateKeyplaneName")' in kb
assert "((void (*)(id,SEL,id))objc_msgSend)(layout,setter,traits)" in kb
assert "KB104RefreshInProgress" in kb
assert "keyboard.windowScene.coordinateSpace.bounds" in ab
assert '"[hl38-keyplane] event=scene-layout-request' in ab
assert "ABKB104RequestUIKitKeyplaneUpdate(" in ab
assert 'requested?@"setScreenTraits":@"reloadInputViews-fallback"' in ab
assert "keyboard.transform=" not in kb+ab
assert "UIKeyboardLayoutStar.transform=" not in kb+ab
# Independent HL36 on-car specimens: matching WIDTH alone does not
# imply fit, because the keyplane can still have a positive x origin.
assert 25.5+371 > 371+1
assert 7.5+495 > 371+1
assert 25.5+371 <= 495+1
# Missing keyplane on window-visible is not a shrink failure; allow
# UIKit's first viewport placement while the keyplane is being built.
assert "if (planeKnown && !fits && (narrowing || !changed))" not in kb
assert "if (planeKnown && !fits)" in kb
assert len(re.findall(r"keyboard\.frame\s*=",kb))==1
# HL36: voice code is retained ONLY in source; the package must never
# compile assistant capture, UI, bubble, or typed command parser.
app_make=(project/"OmniCarApp/Makefile").read_text()
split_make=(project/"OmniCarSplitScreen/Makefile").read_text()
app_files=next(x for x in app_make.splitlines()
               if x.startswith("OmniCar_FILES =")).partition("=")[2].split()
split_files=next(x for x in split_make.splitlines()
                 if x.startswith("OmniCarSplitScreen_FILES =")).partition("=")[2].split()
assert not {"DCVoiceSession.m", "DCVoiceCommand.m"} & set(app_files)
assert not {"SCPVoiceBridge.m", "SCPVoiceBubbleView.m", "SCPVoiceNative.m",
            "SCPVoiceSpringAgent.m", "../OmniCarApp/DCVoiceCommand.m"} & set(split_files)
assert "Speech" not in next(x for x in app_make.splitlines()
                            if x.startswith("OmniCar_FRAMEWORKS =")).split()
assert "Speech" not in next(x for x in split_make.splitlines()
                            if x.startswith("OmniCarSplitScreen_FRAMEWORKS =")).split()
app=(project/"OmniCarApp/OMCAppDelegate.m").read_text()
settings=(project/"OmniCarApp/OMCNativeSettings.m").read_text()
info=(project/"OmniCarApp/Resources/Info.plist").read_text()
assert "DCVoice" not in app+settings
assert "voiceAssistantEnabled" not in settings
assert "voiceAppleOnlineEnabled" not in settings
assert "speedBubbleWarnVoice" in settings  # speed warnings are unrelated
assert "NSMicrophoneUsageDescription" not in info
assert "NSSpeechRecognitionUsageDescription" not in info
assert "NSPhotoLibraryUsageDescription" in info
for n in ("OMCAppDelegate.m", "OMCNativeSettings.m"):
    assert (project/"OmniCarApp"/n).read_bytes()==(src/"App"/n).read_bytes(),n
assert (project/"OmniCarApp/Resources/Info.plist").read_bytes()==(
        src/"App/Info.plist").read_bytes()
split_project=project/"OmniCarSplitScreen"
def no_voice_calls(path):
    body=path.read_text()
    runtime="\n".join(line.split("//",1)[0] for line in body.splitlines())
    assert not re.search(r"\b(?:SCPVoice|DCVoice)[A-Za-z0-9_]*\s*\(",runtime),path
    assert "SCPVoiceNative.h" not in runtime,path
    assert "SCPVoiceBridge.h" not in runtime,path
    assert "SCPVoiceSpringAgent.h" not in runtime,path
for name in ("SCPCarSplit.m", "SCPHooks.m", "SCPSpringBoardHooks.m",
             "SCPCarSplit+Picker.m", "SCPCarSplit+RatioMenu.m"):
    no_voice_calls(split_project/name)
assert "SCPNativeCommandBlock(n)" in (split_project/"SCPHooks.m").read_text()
assert "bwInstallOwner" in (split_project/"SCPHooks.m").read_text()
assert "SCPHomeLauncherDockSetVisible(YES" in (
    split_project/"SCPCarSplit.m").read_text()
print("HL36_NATIVE_VOICE_OFF_SOURCE_PASS: no drawn UI or voice assistant build; native UIKit and speed warning retained; DEVICE-PENDING")

