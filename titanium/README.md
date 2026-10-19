# OmniCar Graphite Titanium: native skin candidate v0.1.0

A REAL Theos/Logos skin tweak that changes native OmniCar view/layer appearance,
not a static screenshot. Original OmniCar 1.0.3 and Zoom 0.7.0 untouched.

Exact graphite palette: #171B22; #353D46; #B5BDC5; #78B9C8; #F3F5F5.

Actual native targets: ratio menu, divider and knob, per-pane three-dot
handle and expanded action bar, OmniCar-owned home button and picker.
Implemented on verified SCPCarSplit selectors, native control accessors.
No generic UIView/UIColor hooks, scene layout/touch changes, Apple dock,
system statusbar or hosted YouTube/Maps content styling.

CANDIDATE scope is split UI only; logo PNGs, startup art, HUD and AppBridge
have NOT yet been modified. Do not claim a full theme or hardware success.
Original app-native creation order may require follow-up native class
inspection to achieve pixel-perfect rendering; screen QA is essential.

Testing: install via package manager manually as independent addon, keep
OmniCar 1.0.3 and Zoom 0.7 installed. Verify ratio menu, handle drag,
float, app picker, per-pane bar, home and fullscreen recovery. If any
regression, remove only com.anlai.omnicar.graphitetitanium.
No publishing to Sileo.
