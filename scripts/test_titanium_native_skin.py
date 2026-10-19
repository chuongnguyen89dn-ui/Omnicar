#!/usr/bin/env python3
"""Source-only (no DEB) color-only regression assertions.
Does NOT claim runtime/UI correctness until actual device QA.
"""
from pathlib import Path
s=Path("titanium/src/OmniCarGraphiteTitanium.xm").read_text()
w=Path(".github/workflows/build-graphite-titanium.yml").read_text()
assert "workflow_dispatch:" in w and "  push:" not in w, "Do not build on GitHub push"
for required in [
    "%hook SCPCarSplit", "newDividerAt:", "showRatioMenuForDivider:",
    "setupBarForPane:", "layoutBarForPane:", "setBarVisible:",
    "refreshPickerSheet", "rootDidLayout", "OMTThemeLayer",
    "OMTTranslate", "gradient.colors=existing", "shape.fillColor=",
    "shape.strokeColor=", "layer.borderColor=", "layer.shadowColor=",
    "74,79,128", "110,100,200", "167,139,250", "96,197,250",
    "94,221,182", "245,154,192", "155,135,248",
    "23,27,34", "53,61,70", "181,189,197",
    "120,185,200", "243,245,245",
]: assert required in s,required
for forbidden in [
    "homeButton", "refreshHomeButton", "OMCRescueAction",
    "%hook UIView", "%hook UIWindow", "%hook UIColor",
    "insertSublayer", "addSublayer", "CAGradientLayer layer",
    "cornerRadius=", "borderWidth=", ".frame=",
    "setFrame:", "setCornerRadius:", "setBorderWidth:",
    "setImage:", "OMTSurface", "appBridgeZoom",
    "DBStatusBarWindow", "CARStatusBarWindow"
]: assert forbidden not in s,forbidden
assert s.count("%orig") == 7
print("PASS: exact original RGB translations; no geometry/layout or new layers; no automatic DEB build")
