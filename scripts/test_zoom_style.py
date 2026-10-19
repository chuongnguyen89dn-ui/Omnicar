"""Static v0.7.0 style and rollback gate. Not a device test."""
from pathlib import Path
s=Path("src/OmniCarDoubleTapFullscreen.xm").read_text()
for necessary in ["OMCZoomGlyph(BOOL expanded)","UIGraphicsBeginImageContextWithOptions","CGContextStrokePath(ctx)","CGFloat diameter=44.0","circleDiameter=MAX(29.0,MIN(36.0,nativeHeight*0.43))","button.backgroundColor=UIColor.clearColor","imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal","OMCToggleHost(self.split)","showRatioMenuForDivider:","hideRatioMenu","OMCChromeSetHidden(YES)","OMCChromeSetHidden(NO)"]:
    assert necessary in s,necessary
for wrong in ["OMCRescueAction","OMCScheduleRescue","OMCRefreshRescue","setZoomedSlot:","closeFloat:","endHostedSolo","panePopOut:","numberOfTapsRequired","dividerDoubleTapped:"]:
    assert wrong not in s,"unwanted rescue or touch hook: "+wrong
for h in [36,44,56,72,96]:
    d=max(29.,min(36.,h*.43))
    assert 29<=d<=36 and d<44
print("STATIC PASS: 0.5 Zoom behavior, no rescue, compact style")
