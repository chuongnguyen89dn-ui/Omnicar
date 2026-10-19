"""Static geometric regression for one Zoom control below native split selector.
This is NOT an on-device CarPlay test and cannot prove view ownership.
"""
from pathlib import Path
import math

src = Path("src/OmniCarDoubleTapFullscreen.xm").read_text()
assert "UIWindow *parent=menu.window" in src, "Zoom parent must be the native menu's real UIWindow"
assert "CGRectGetMidX(menuRect)" in src
assert "OMCAreaValid(menuRect)" not in src, "A 40pt menu must be accepted"
assert "event=not-enough-space" not in src, "Old split-parent clipping guard must be gone"
assert "dividerDoubleTapped:" not in src, "Do not change native double tap"
assert "numberOfTapsRequired" not in src, "Do not install additional gestures"

def proposed(menu, window):
    x, y, w, h = menu
    ww, wh = window
    assert w > 0 and h > 0
    diameter = max(46.0, min(62.0, h * .70))
    cx = x + w / 2
    circle_bottom = y + h + 12 + min(52.0, h * .55)
    frame = (cx - diameter/2, circle_bottom + 12, diameter, diameter)
    return frame

examples = [
    ((470, 160, 220, 46), (960, 540), 250),
    ((220, 170, 190, 42), (800, 460), 230),
    ((320, 155, 180, 38), (780, 440), 230),
]
for menu, window, old_split_parent_height in examples:
    x, y, w, h = proposed(menu, window)
    assert all(math.isfinite(v) for v in (x, y, w, h))
    assert abs(x + w/2 - (menu[0] + menu[2]/2)) < 0.01
    assert y > menu[1] + menu[3] + 12, (menu, (x,y,w,h))
    assert y + h < window[1], (menu,window,(x,y,w,h))
    # Critical failure mode seen in the 0.4 source: proposed button
    # may extend outside narrow native pane but still fits full window.
    assert y + h > old_split_parent_height, (menu,(x,y,w,h))
print("STATIC_ONLY: 3 window-coordinate menu Zoom regressions PASS; actual runtime placement UNVERIFIED")
