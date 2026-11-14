#!/usr/bin/env python3
"""HL54 GPS correction slider: static source and feature-isolation gate.
This does NOT certify iOS build, LePrefs vendor save, or in-car runtime.
"""
from pathlib import Path

root=Path(__file__).resolve().parents[1]
project=root/"project"
src=root/"src"
def mirrored(p,s):
    one=(project/p).read_bytes()
    two=(src/s).read_bytes()
    assert one==two,("project/src mirror drift",p,s)
    return one.decode("utf-8")

app=mirrored("OmniCarApp/OMCLePrefsHost.m","App/OMCLePrefsHost.m")
settings=mirrored("OmniCarApp/OMCNativeSettings.m","App/OMCNativeSettings.m")
bridge=mirrored("OmniCarLeExtension/DCLLeConfigBridge.m","LeExtension/DCLLeConfigBridge.m")
core=mirrored("OmniCarLeTraffic/DCLTrafficCore.c","LeTraffic/DCLTrafficCore.c")
assert "if(self.extrasOnly && key==27)return [self gpsSliderCell];" in app
assert "slider.minimumValue=-10.0f;" in app
assert "slider.maximumValue=10.0f;" in app
assert 'left.text=@"−10 km/h";' in app
assert 'middle.text=@"0";' in app
assert 'right.text=@"+10 km/h";' in app
assert 'self.gpsPendingRaw=raw;' in app
assert "self.gpsPendingRaw=-1;" in app
assert 'slider.continuous=YES;' in app
assert 'UIControlEventTouchUpInside|UIControlEventTouchUpOutside' in app
assert "if(!slider.tracking)[self gpsSliderEnded:slider];" in app
preview=app.split("- (void)gpsSliderChanged:",1)[1].split("- (void)gpsSliderEnded:",1)[0]
assert "[self enqueueKey:" not in preview,"GPS gesture preview must not spam IPC"
release=app.split("- (void)gpsSliderEnded:",1)[1].split("- (void)gpsSliderCancelled:",1)[0]
assert release.count("[self enqueueKey:27 value:raw];")==1
assert "if(self.bridgeFailed||raw==lastRequested)return;" in release
assert 'if(key==27) return raw<=20?@((NSInteger)raw-10):nil;' in bridge
assert 'if(key==27)return (NSUInteger)MAX(0,MIN(20,[obj integerValue]+10));' in bridge
assert 'if (requested < -10) return -10;' in core
assert 'if (requested > 10) return 10;' in core
assert '@"Tùy chỉnh thêm: GPS ±10, kéo tự do"' in settings
assert "DCLLeConfigPage *extras" in app
assert "extras.extrasOnly=YES;" in app
assert "if(self.extrasOnly) return @[@[@0],@[@4],@[@27,@28]];" in app
assert "for(NSNumber *key in @[@0,@4,@27,@28])" in app
assert "if(!confirmed) {" in app, "no stale-source value may be selectable"
assert "DCLLeFetchCanonicalLayout(&snapshot)" in app
assert "DCLLeHydrateAppLayout(page.binary,snapshot)" in app
assert "canonical READ MISSING" in bridge
assert "bundle.principalClass" in app
assert "CWTrafficBubblePrefsController" in app
# The existing speed compensation changes only speedText; not the vendor
# posted-speed-limit, source sample, radar/road-sign or navigation content.
extension=mirrored("OmniCarLeExtension/DCLLeExtension.m","LeExtension/DCLLeExtension.m")
assert "DCLTrafficClampGpsOffset" in extension and "setSpeedText:" in extension
assert "setOverspeedExcess:" not in extension
assert '"dev.bechou.le.bubble.layout-changed"' in bridge
print("HL54_GPS_SLIDER_SOURCE_PASS range=-10..10 step=1 mirrors=4 originalUI=preserved")
