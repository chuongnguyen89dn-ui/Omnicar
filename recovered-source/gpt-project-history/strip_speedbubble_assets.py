#!/usr/bin/env python3
"""Delete ONLY abandoned SpeedBubble assets from disposable Theos input.
The real DuoCar UIKit "Bong bóng tốc độ" entry is in NativeSettings.m,
not in FeatureSpeedBubble.plist; NEVER remove that entry.
"""
from pathlib import Path
import sys
project=Path(sys.argv[1] if len(sys.argv)>1 else "recovered-source/project").resolve()
assert project.is_dir()
n=0
for candidate in project.rglob("*"):
    if not candidate.is_file():continue
    if "Resources" not in candidate.parts:continue
    name=candidate.name
    if (name=="FeatureSpeedBubble.plist" or
        name.startswith("SpeedBubbleIcon") or
        name=="SpeedBubble.strings"):
        candidate.unlink();n+=1
        print("LEGACY_SPEED_ASSET_REMOVED",candidate.relative_to(project))
assert n>0,"No old SpeedBubble resources found; verify packaging"
print("LEGACY_SPEED_RESOURCES_PURGED",n)
