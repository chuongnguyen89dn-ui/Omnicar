#!/usr/bin/env python3
"""HL61 thermal visual source contract (does not establish device result)."""
from pathlib import Path
p=Path(__file__).resolve().parents[2]
module=p/"project/OmniCarSplitScreen"
mirror=p/"src/SplitScreenA"
for name in ("SCPThermalEdgeWarning.h","SCPDeviceVitalsHUD.m",
             "SCPFullscreenVitalsBubble.m"):
    assert (module/name).read_bytes()==(mirror/name).read_bytes(),name
view=(module/"SCPThermalEdgeWarning.h").read_text(encoding="utf-8")
hud=(module/"SCPDeviceVitalsHUD.m").read_text(encoding="utf-8")
full=(module/"SCPFullscreenVitalsBubble.m").read_text(encoding="utf-8")
gate=(module/"SCPThermalAlarm.h").read_text(encoding="utf-8")
settings=(p/"project/OmniCarApp/OMCNativeSettings.m").read_text(encoding="utf-8")
assert "LÀM MÁT THIẾT BỊ CỦA BẠN" in view
assert "CABasicAnimation" in view and "hl61-thermal-edge-glow" in view
assert "surface.backgroundColor=UIColor.clearColor" in view
assert "outer.layer.borderWidth=7.0" in view
assert "surface.userInteractionEnabled=NO" in view
for code in (hud,full):
    assert "SCPThermalEdgeWarningCreate(" in code
    assert "[hl61-thermal-ui]" in code
    assert "GIẢ LẬP — KHÔNG PHẢI NHIỆT THẬT" not in code
    assert "CẢNH BÁO NHIỆT ĐỘ" not in code
    assert "Ngưỡng 37°C" not in code
    assert "curtain.backgroundColor=[UIColor colorWithRed" not in code
    assert "thermaltest37.changed" in code
assert "win.userInteractionEnabled=NO" in hud and "return nil; // cannot intercept" in hud
assert "self.overlayWindow.userInteractionEnabled=NO" in full
assert "tempC>=37.0" in gate
assert "duocarThermalTest37Enabled" in settings
assert (p/"project/OmniCarApp/OMCNativeSettings.m").read_bytes()==(p/"src/App/OMCNativeSettings.m").read_bytes()
print("HL61_RED_EDGE_TRANSPARENT_CENTER_ONLY_SOURCE_PASS")
