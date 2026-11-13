#!/usr/bin/env python3
"""HL43 source-only isolation contract: shared Telex + native Cancel; device separate."""
from pathlib import Path
import hashlib
import plistlib
ROOT=Path(__file__).resolve().parents[1]
P=ROOT/"project/OmniCarAppBridge"
S=ROOT/"src"
PAIRS=[
("ABHostBMethods.m","AppBridgeB/ABHostBMethods.m"),
("ABHostGeometry.m","AppBridgeB/ABHostGeometry.m"),
("ABHostLaunch.m","AppBridgeA/src/ABHostLaunch.m"),
("ABInApp.m","AppBridgeB/ABInApp.m"),
("ABChannelNames.m","AppBridgeB/ABChannelNames.m"),
("AppBridgeB.h","AppBridgeB/AppBridgeB.h"),
("AppBridgeEntry.m","AppBridgeB/AppBridgeEntry.m"),
("ABNativeDrawnTA.m","AppBridgeB/ABNativeDrawnTA.m"),
("ABKeyboard.m","AppBridgeB/ABKeyboard.m"),
("ABTelex.m","AppBridgeB/ABTelex.m"),
]
for a,b in PAIRS:
    assert (P/a).read_bytes()==(S/b).read_bytes(),(a,b)
def text(name):return (P/name).read_text()
def sha(raw):return hashlib.sha1(b"blob "+str(len(raw)).encode()+b"\0"+raw).hexdigest()
telex=text("ABTelex.m") if "text" in globals() else (P/"ABTelex.m").read_text()
assert sha((P/"ABTelex.m").read_bytes())!="50e132bd8cda2372ee5a264903cb8c821f2e3991"
assert 'NSString *ABTelexApply(NSString *word, NSString *keyString)' in telex
assert 'ABTTonePosition(' in telex
assert 'scanBound' not in telex
assert 'autorelease' not in telex
assert 'precomposedStringWithCanonicalMapping' in telex
keyboard=text("ABKeyboard.m")
# Verify the entirety of the 1.0.3 keyboard UI source is unchanged,
# except the FIVE narrow native adapters. Undo adapters and hash.
ADAPTERS=[
('''
// [hl40-native-drawn] Two tiny process-specific adapters; every original
// keycap, Telex, layout and preview method is kept byte-for-byte otherwise.
extern UIWindow *DC40NativeKeyboardHostWindow(void);
extern BOOL DC40NativeKeyboardRouteKey(NSString *action, NSUInteger del, NSString *text);
''',''),
('    // [hl40-native-drawn] Native has a different authenticated ACK owner.\n'
 '    // The original hosted appbridge.key route remains unchanged below.\n'
 '    if (DC40NativeKeyboardRouteKey(action,del,text)) return;\n',''),
('    UIWindow *carWindow = DC40NativeKeyboardHostWindow();\n'
 '    if (!carWindow) carWindow = [[ABHost shared] carWindow];',
 '    UIWindow *carWindow = [[ABHost shared] carWindow];'),
('    CGRect area = (container == DC40NativeKeyboardHostWindow())\n'
 '        ? CGRectZero : [ABHost shared].carAppArea;',
 '    CGRect area = [ABHost shared].carAppArea;'),
('''// -hideTapped: [hl43] ALWAYS dismiss the panel immediately for both
// native and hosted. Never lock this control to conceal a native keyplane.
// The remote action is dispatched first and logged separately.
- (void)hideTapped {
    [self send:@"dismiss" del:0 text:nil];
    [self hideForApp:nil];
}''','''// -hideTapped (0x1D244): send:@"dismiss" del:0 text:nil, then
// hideForApp:nil (force hide).
- (void)hideTapped {
    [self send:@"dismiss" del:0 text:nil];
    [self hideForApp:nil];
}'''),
]
for current,original in ADAPTERS:
    assert keyboard.count(current)==1,"unexpected ABKeyboard change"
    keyboard=keyboard.replace(current,original,1)
assert sha(keyboard.encode())=="4eadc1c424a12b5d9de1411c33aa6360bd3985c1"
make=text("Makefile")
units=next(v.split("=",1)[1].split() for v in make.splitlines() if v.startswith("OmniCarAppBridge_FILES ="))
for component in ["ABKeyboard.m","ABTelex.m","ABNativeDrawnTA.m","ABInApp.m",
                  "ABHostGeometry.m","AppBridgeEntry.m"]:
    assert component in units, component
host=text("ABHostBMethods.m");geo=text("ABHostGeometry.m")
app=text("ABInApp.m");native=text("ABNativeDrawnTA.m")
entry=text("AppBridgeEntry.m");channels=text("ABChannelNames.m")
assert 'OMCPref(@"appBridgeZoom", @80)' in host
assert "return NO;" in host.split("BOOL ABNativeKeyboardEnabled(void)")[1].split("BOOL ABDrawnKeyboardEnabled")[0]
assert "static const BOOL ABDrawnKb = YES" in app
for token in ["ABSuppressSystemKeyboard(self)","ABRestoreBlankInputView(responder)",
              "ABKeyboardPublish(YES, responder)","ABKeyboardPublish(NO, nil)",
              "ABKeyBlock(n)","ABForcedOrientation < 1 || !ABDrawnKb"]:
    assert token in app,token
assert 'ABChanKey         = @"com.anlai.omnicar/appbridge.key"' in channels
assert 'ABNotifyKeyboard = "com.anlai.omnicar/appbridge.keyboard"' in channels
assert "ABKeyboardDispatch(int token)" in geo
assert "paneFor:bundleID" in geo
assert "notify_register_dispatch(ABNotifyKeyboard" in geo
assert "[[ABKeyboard shared] hideForApp:nil]" in geo
assert "[[ABKeyboard shared] hideForApp:bundleID]" in text("ABHostLaunch.m")
for role in ['@"com.apple.CarPlayApp"','@"com.apple.CarPlayTemplateUIHost"']:
    assert role in entry
assert "DC40NativePresenterStart();" in geo
assert "DC40NativePresenterStart();" not in entry
assert "DC40NativeClientStart(bundleID);" in entry
assert entry.index("DC40NativeClientStart(bundleID);")<entry.index("if ([excluded containsObject:bundleID])")
for token in ["DC40NativeClientStart(NSString *bundle)","DC40NativePresenterStart(void)",
              "DC40NativeKeyboardHostWindow(void)","DC40NativeKeyboardRouteKey(NSString *action",
              "DC40CarInput(","DC40ClientBegin(","DC40ClientEnd(","DC40ClientReceive(",
              "DC40ClientAck(","DC40PresenterAck(","DC40PresenterFocus(","DC40ClientScan(",
              "DC40FindResponder(","if (seq!=DC40ClientSeq+1) return",
              "if (seq==DC40ClientSeq)","DC40Queue.count>=128",
              
              "DC40Focus","DC40Command","DC40Ack",
              "DC41TFBecome(","DC41TVBecome(","DC41PrearmInput(",
              "DC42TFResign(","DC42TVResign(","DC42VisibleKeyboardWindows(",
              "DC43TriggerRealSearchCancel(","DC43OwningSearchBar(",
              "DC42VisibleKeyboardWindows(",
              "SpringBoard panel=","DC40CurrentNonce",
              ]:
    assert token in native,token
assert "if (ABForcedOrientation >= 1) return NO" in native
assert "scene.screen != [UIScreen mainScreen]" in native
for dead in ['UIWindowLevelAlert+2.0','initWithWindowScene:scene','DC40Window.hidden=NO','DC40OverlayWindow : UIWindow']:
    assert dead not in native,dead
assert '[[ABKeyboard shared] hideForApp:formerOwner]' in native
assert 'DC42NativeHideWaitForFocusEnd' not in native
assert 'DC42NativeHideWaitForFocusEnd' not in text("ABKeyboard.m")
assert '[self send:@"dismiss" del:0 text:nil];\n    [self hideForApp:nil];' in text("ABKeyboard.m")
assert '[hl43-cancel]' in native and 'search-complete nonce=' in native
assert 'cancelInvoked=%d resignCalled=%d resignReturned=%d stillFocused=%d' in native
assert 'UIKeyboardDidShowNotification' in native and 'UIKeyboardDidHideNotification' in native
assert 'if (ok) DC40ClientEnd(field)' in native
assert 'resignReturned=resignCalled ? [candidate resignFirstResponder] : NO' in native
assert "DC40OwnedBlank=blank" in native
assert "[candidate reloadInputViews]" in native
assert "[input insertText:str]" in native
assert "[input deleteBackward]" in native
for forbidden in ["keyboard.frame=","UIRemoteKeyboardWindow.frame",
                  "UIKeyboardLayoutStar.transform","UIKeyboardLayoutStar.frame"]:
    assert forbidden not in native,forbidden
plist=plistlib.loads((P/"OmniCarAppBridge.plist").read_bytes())
assert "com.apple.UIKit" in plist["Filter"]["Bundles"]
assert "1.0.3-hl43telex1" in (ROOT/"gpt-project-history/rebrand_duocar_hl43.py").read_text()
print("HL43_SOURCE_PASS shared Telex repaired, native Cancel/Return traced, original hide restored; DEVICE_PENDING")
