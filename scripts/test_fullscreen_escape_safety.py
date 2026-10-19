"""OmniCar safety build guard — NOT proof of runtime behavior on device."""
from pathlib import Path

src=Path("src/OmniCarDoubleTapFullscreen.xm").read_text()
assert "OMCRescueAction" in src
assert 'event=pressed nativeZoom=' in src
assert "OMCChromeSetHidden(NO);" in src, "Dock restore must always be available"
assert "closeFloat:NO" in src and "endHostedSolo" in src
assert "toggleZoomForPane:pane" in src
assert "UIButton *rescueButton" in src
assert "if (state.expanded) OMCToggleHost(split)" in src
assert 'OMCScheduleRescue((SCPCarSplit *)self)' in src
assert 'UIWindow *window=[split container].window' in src
assert "if (!shouldShow) { OMCRemoveRescue(split); return; }" in src
assert "if (!active) {" in src and "OMCRemoveRescue((SCPCarSplit *)self);" in src
assert "[window bringSubviewToFront:b]" in src
assert "numberOfTapsRequired" not in src
assert "dividerDoubleTapped:" not in src

# When in a native zoom, floating or solo-host mode, fallback must remain
# even if the original three-dot handle still exists.
def should_show(expanded=False, zoomed=False, floating=False, solo=False,
                panes=2, native_handles_visible=True):
    special=expanded or zoomed or floating or solo
    return special or (panes>0 and not native_handles_visible)

for kw in (dict(expanded=True),dict(zoomed=True),dict(floating=True),dict(solo=True),
           dict(panes=2,native_handles_visible=False)):
    assert should_show(**kw)
assert not should_show(), "normal split with native controls must not show extra exit"
assert not should_show(panes=0), "inactive/empty normal mode must not create overlay"
print("STATIC_ONLY: fullscreen escape safety state matrix PASS")
