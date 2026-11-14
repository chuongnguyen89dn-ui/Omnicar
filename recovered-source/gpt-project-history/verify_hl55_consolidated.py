#!/usr/bin/env python3
"""HL55 consolidation gate for the exact project/src source, NOT vehicle pass.

Run with full repo checkout. Reject partial fixes before even starting Theos.
Vendor ABI and CarPlay scene ownership remain device validation items.
"""
from pathlib import Path
import hashlib
root=Path(__file__).resolve().parents[1]
project=root/"project"
src=root/"src"
mirror={
    "OmniCarSplitScreen/SCPFullscreenVitalsBubble.m":"SplitScreenA/SCPFullscreenVitalsBubble.m",
    "OmniCarSplitScreen/SCPThermalAlarm.h":"SplitScreenA/SCPThermalAlarm.h",
    "OmniCarSplitScreen/SCPDeviceVitalsHUD.m":"SplitScreenA/SCPDeviceVitalsHUD.m",
    "OmniCarLeTraffic/DCLTrafficCore.h":"LeTraffic/DCLTrafficCore.h",
    "OmniCarLeTraffic/DCLTrafficCore.c":"LeTraffic/DCLTrafficCore.c",
    "OmniCarLeExtension/DCLLeExtension.m":"LeExtension/DCLLeExtension.m",
    "OmniCarLeExtension/DCLLeConfigBridge.m":"LeExtension/DCLLeConfigBridge.m",
    "OmniCarLeExtension/DCLLeOriginalStoreServer.h":"LeExtension/DCLLeOriginalStoreServer.h",
    "OmniCarLeExtension/DCLLeOriginalStoreServer.m":"LeExtension/DCLLeOriginalStoreServer.m",
    "OmniCarLeExtension/DCLLeStoreWire.h":"LeExtension/DCLLeStoreWire.h",
    "OmniCarLeExtension/DCLLeStateWriter.h":"LeExtension/DCLLeStateWriter.h",
    "OmniCarLeExtension/DCLLeStateWriter.c":"LeExtension/DCLLeStateWriter.c",
    "OmniCarApp/OMCLePrefsHost.m":"App/OMCLePrefsHost.m",
}
files={}
for p,q in mirror.items():
    one=(project/p).read_bytes()
    other=(src/q).read_bytes()
    assert one==other,("project/src drift",p,q)
    files[p]=one.decode()
app=files["OmniCarApp/OMCLePrefsHost.m"]
ext=files["OmniCarLeExtension/DCLLeExtension.m"]
bridge=files["OmniCarLeExtension/DCLLeConfigBridge.m"]
server=files["OmniCarLeExtension/DCLLeOriginalStoreServer.m"]
writer=files["OmniCarLeExtension/DCLLeStateWriter.c"]
clock=files["OmniCarSplitScreen/SCPFullscreenVitalsBubble.m"]
dock=files["OmniCarSplitScreen/SCPDeviceVitalsHUD.m"]
geometry=files["OmniCarLeTraffic/DCLTrafficCore.c"]
thermal=files["OmniCarSplitScreen/SCPThermalAlarm.h"]
client=(project/"OmniCarApp/DCLLeOriginalStoreClient.m").read_text()
assert (project/"OmniCarApp/DCLLeStoreWire.h").read_bytes()==(project/"OmniCarLeExtension/DCLLeStoreWire.h").read_bytes()
assert (src/"App/DCLLeStoreWire.h").read_bytes()==(project/"OmniCarApp/DCLLeStoreWire.h").read_bytes()
assert '#import "DCLLeStoreWire.h"' in client
assert "../OmniCarLeExtension/DCLLeStoreWire.h" not in client
appMake=(project/"OmniCarApp/Makefile").read_text()
extMake=(project/"OmniCarLeExtension/Makefile").read_text()
fs=(project/"OmniCarSplitScreen/SCPFullscreenController.m").read_bytes()
# This was the SHA256 of the real HL53/HL54 fullscreen ENGINE; all new
# warning and compact-visual paths belong in independent modules.
assert hashlib.sha256(fs).hexdigest()=="62a0703aefd8f41c416bc684ebcfd8dd2ce72f239cea5dcb212fa5dea1fc3932"
assert "DCLLeOriginalStoreClient.m" in appMake
assert "DCLLeOriginalStoreServer.m" in extMake
assert "DCLLeStateWriter.c" in extMake
assert "DCLLeInstallOriginalStoreHook(binary)" in app
assert "bundle.principalClass" in app
assert "DCLLeOriginalStoreStart();" in ext
assert 'if(self.extrasOnly) return @[@[@4],@[@27,@28]];' in app
assert 'for(NSNumber *key in @[@4,@27,@28])' in app
assert '[self enqueueKey:(int)sender.tag value:sender.on?1:0]' in app
assert 'if(self.extrasOnly && key==27)return [self gpsSliderCell];' in app
assert 'slider.minimumValue=-10.0f;' in app
assert 'slider.maximumValue=10.0f;' in app
assert 'if(key==27) return raw<=20?@((NSInteger)raw-10):nil;' in bridge
assert 'if(key==4 && [after respondsToSelector:@selector(boolValue)])' in bridge
assert 'CFSTR("leBubbleMasterMirror")' in bridge
assert 'CFSTR("leBubbleMasterMirror")' in server
assert '[master isKindOfClass:NSNumber.class]' in server
assert 'DCLLeJSONAccept' not in server  # make sure no invented other handler
assert 'DCLJSONAccept(DCLPending)' in server
assert 'DCLLeWriteStateAtomically(DCLVendorDirectory,"layout-v1.json"' in server
assert "DCL_LE_RAW_LIMIT" in server and "DCLLeCRC32" in server
assert "DCLLeFrame(DCL_LE_MAGIC_ACK" in server
assert '"layout-v1.json"' in client
assert 'DCLBrokerWrite(data)' in client
assert "MSHookFunction" in client and "CWWriteOwnedStateFile" in client
assert "HOOK_OFF" in client
assert "f56bbe586853690204bbc2ada5ea6385dacb6bd96b50becd4251a2f93e89f83b" in client
assert 'strcmp(name,"layout-v1.json")!=0' in writer
assert "O_NOFOLLOW" in writer and "DCLCheckOwner(&st,1)" in writer
assert "fsync(fd)" in writer and "renameat(" in writer
assert "DCLVerify(dirfd,name,bytes,count)" in writer
assert 'layout-v1.json.duocar54-previous.bak' in (root/"gpt-project-history/tests/test_hl54_store.c").read_text()
assert "DCLTrafficSnapWhenNearEdge" in geometry
assert "DCLTrafficSnapWhenNearEdge" in ext
assert "DCLTrafficClampCenter" in ext
assert "DCLLeCompactVendorWindow(w)" in ext
assert 'window.windowLevel=UIWindowLevelStatusBar+62.0' in ext
assert '"leBubbleMasterMirror"' in ext
assert 'doc[@"bubbleEnabled"]' in ext
assert '"dev.bechou.le.bubble.layout-changed"' in ext
assert "window.userInteractionEnabled=NO" in ext
assert "window.hidden=YES" in ext
assert "DCLLastOverlayOwner" in ext and "DCLLastCastOwner" in ext
assert "if(originalOverlayPan)originalOverlayPan(o,sel,g);" in ext
assert "if(originalCastPan)originalCastPan(o,sel,g);" in ext
assert "attachPan(" not in ext
assert "SCPThermalAlarmStep" in thermal
assert "tempC < 39.0" in thermal and "tempC <= 37.5" in thermal
assert "s->consecutiveHot>=2 && s->armed" in thermal
assert "SCPThermalAlarmStep(&_thermalAlarm" in clock
assert "SCPThermalAlarmStep(&_thermalGate" in dock
assert 'BOOL isBattery=[sample[@"temperatureKind"] isEqualToString:@"battery"]' in clock
assert 'BOOL batterySource=[sample[@"temperatureKind"] isEqualToString:@"battery"]' in dock
assert "thermalCurtainUntil=now+5.0" in clock
assert "thermalWarningWindow" in dock
assert "return nil; // cannot intercept app" in dock
assert "DCFVPassHitTest" in clock
assert '@"⚠️ CẢNH BÁO NHIỆT ĐỘ' in clock and '@"⚠️ CẢNH BÁO NHIỆT ĐỘ' in dock
assert 'width = fmin(208.0,usableWidth)' in clock
assert 'timeWidth = MIN(74.0' in clock
assert '@"🔋%@ 🌡%@"' in clock
assert "SCPFullscreenStateExpanded" in clock
assert 'temperatureUnitsVerified": @NO' in (project/"OMCCommon/OMCDeviceVitals.m").read_text()
assert 'gpuTemperatureVerified": @NO' in (project/"OMCCommon/OMCDeviceVitals.m").read_text()
assert "overspeedBlink" not in thermal and "overspeedExcess" not in thermal
print("HL55_CONSOLIDATED_SOURCE_GATE_PASS mirrors=%d thermal39/store/bubble-onoff/edge/clock/pinch preserved (DEVICE NOT TESTED)"%len(mirror))
