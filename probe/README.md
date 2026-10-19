# Read-only OmniCar Native Skin Probe 0.1.0

This diagnostic only collects UIKit/CALayer **actual runtime metadata** for OmniCar
menu, ratio knob, 3-dot handles, pane action bar and independent Zoom button.
No paints, changes to UIWindow, gestures, actions, or app content.
No system dock or screenshot capture. No Sileo.

**Important original baseline:** disable/remove the previous Graphite Titanium
0.2.0 styling tweak before measuring ORIGINAL native colors. Keep separate Zoom
0.7.0 if you need its actual frame and gradient measured alongside originals.
Install this probe manually as a standalone addon, respring, reconnect parked
CarPlay, **open native three-choice selector** and pane action bar. In Filza
open /var/mobile/Documents/OmniCarSkinProbe.txt and send the text.
If file write is denied, use system logs tagged [OmniCarSkinProbe].
The file is overwritten on later events; keep the menu-open snapshot.
Remove only this probe after measurement. Runtime not yet verified on device.

Report lists owner root class, frame/bounds/windowRect in UIKit points,
background/tint RGB, CALayer border/shape/gradient and selected state. Logs
do not contain user app text, location, map, media or identifiers.
