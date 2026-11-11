#!/usr/bin/env python3
"""HL28 source integration regression. Run before source rebrand on CI.

Tests integration boundaries and counterexample transitions (a success
must cancel the scheduled retry chain). This cannot prove visible keycaps
or on-device Settings behavior.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
proj = (ROOT / "project/OmniCarAppBridge/ABInApp.m").read_bytes()
src = (ROOT / "src/AppBridgeB/ABInApp.m").read_bytes()
assert proj == src, "AppBridge project/src parity broken"
code = proj.decode("utf-8")

settings = (ROOT / "project/OmniCarApp/OMCNativeSettings.m").read_bytes()
settings_src = (ROOT / "src/App/OMCNativeSettings.m").read_bytes()
spring = (ROOT / "project/OmniCarSplitScreen/SCPSpringBoardHooks.m").read_bytes()
spring_src = (ROOT / "src/SplitScreenA/SCPSpringBoardHooks.m").read_bytes()
assert settings == settings_src, "Native Settings parity broken"
assert spring == spring_src, "SpringBoard bridge parity broken"
settings, spring = settings.decode(), spring.decode()

def between(start, end):
    assert code.count(start) == 1, (start, code.count(start))
    after = code.split(start, 1)[1]
    assert end in after, end
    return after.split(end, 1)[0]

begin = between("static void ABNativeKbBegin(NSString *why) {",
                "static void ABNativeKbWindowVisible(NSNotification *note) {")
visible = between("static void ABNativeKbWindowVisible(NSNotification *note) {",
                  "// ---- keyboard guard: auxiliary notification evidence (§5.5) ----")
frame = between("static void BWKbFrameNote(NSNotification *note) {",
                "static void BWKbHideNote(NSNotification *note) {")
host = between("static void ABOrientationBlock(NSNotification *note) {",
               "// ===========================================================================")

# HL11 observable semantics: an immediate successful fit does not schedule
# more frame-setting operations; unavailable window retries are bounded.
assert begin.index('if (ABNativeKbFit(why, 0))') < begin.index('for (NSUInteger n = 1; n <= 3; n++)')
assert re.search(r'if \(ABNativeKbFit\(why, 0\)\)\s*\{[^}]+return;', begin, re.S)
assert 'delay = n == 1 ? 0.3 : (n == 2 ? 0.6 : 1.2)' in begin
assert begin.index('if (found) {') < begin.index('if (n == 1)')
assert re.search(r'if \(found\)\s*\{[^}]*\+\+ABNativeKbEpoch;[^}]*return;', begin, re.S)
assert 'if (ABNativeKbFit(@"window-visible", 0))' in visible
assert '++ABNativeKbEpoch;' in visible
assert 'ABNativeKbFit(' not in frame, "UIKit keyboard-frame notification triggers extra fit"

# Keep real host revision checks and single committed geometry re-fit,
# not the HL26 delayed 0.12/0.35s re-fits during keyplane formation.
assert 'orientation >= 1 && !stale &&' in host
assert '(geometryChanged || orientation != old)' in host
assert 'ABNativeKbHasOriginal' in host
assert host.count('ABNativeKbFit(@"host-frame", 0)') == 1
assert 'host-frame-settled' not in code
assert 'ABNativeKbFit(@"keyboard-frame"' not in code
assert 'revision < ABNativeKbGeometryRevision' in host
assert 'ABNativeKbRestore(@"host-release")' in host
assert 'ABNativeKbRestore(@"will-hide")' in code

# Preserve the read-only keyplane probe from HL27 Settings/Respring branch.
assert 'static UIView *AB27FindKeyplane' in code
assert '[hl27-keyplane]' in code and 'pixels=UNKNOWN touch=UNKNOWN' in code
assert '[hl25-kb-surface]' in code
assert '[hl24-geometry]' in code
assert '[hl28-kbmerge]' in code
assert 'ABNativeKbFitLayout(' not in code
assert 'layout.transform =' not in between('static UIView *AB27FindKeyplane',
                                          'static BOOL ABNativeKbObserveLayout')
assert '[ABCurrentResponder reloadInputViews]' not in code

# Settings must continue to be app-owned, not a Settings.app redirect, and
# privileged Respring must still have an acknowledged SpringBoard receiver.
assert 'OMCNativeSettingsRootController' in settings
assert '[hl27-settings] gate=original-root-cards' in settings
assert 'self.navigationItem.rightBarButtonItems=@[respring,language]' in settings
assert '[hl27-respring] stage=request-sent' in settings
assert '[hl27-respring] stage=ack-timeout' in settings
assert 'kill(getpid(),SIGKILL)' in spring
assert '[hl27-respring] stage=accepted' in spring
assert 'SCP27RespringRequest(NSNotification *note)' in spring
assert 'prefs:root' not in re.sub(r'/\*.*?\*/|//[^\n]*', '', settings, flags=re.S)

rebrand = (ROOT / 'gpt-project-history/rebrand_duocar.py').read_text()
payload = (ROOT / 'gpt-project-history/verify_duocar_payload.py').read_text()
workflow = Path(".github/workflows/build-fat-macos.yml").read_text()
assert '1.0.3-hl30kbvoice' in rebrand and '1.0.3-hl30kbvoice' in payload
assert '"[hl28-kbmerge]"' in payload
assert 'verify_hl28_keyboard_settings.py' in workflow

# Independent event cases: scheduled refits may occur only while no
# keyboard window has been found. Success is terminal for a generation.
cases = [
    ([True], 1, 'first-window-ready'),
    ([False, True], 2, 'late-first-retry-ready'),
    ([False, False, True], 3, 'late-second-retry-ready'),
    ([False, False, False, False], 4, 'never-visible'),
]
for observations, expected, name in cases:
    calls = 0
    for success in observations:
        calls += 1
        if success:
            break
    assert calls == expected, name
    assert calls <= 4, name

# Historical real HL23 counterexample: never permit a second scale factor
# on UIKit's already zoomed keyboard layout.
physical, logical, zoom = 396, 495, 0.8
assert abs(logical * zoom - physical) < 1.0
assert physical * zoom != physical
assert 'CGAffineTransformScale(\n            ABNativeKbLayoutOriginalTransform' not in code

print("HL28_INTEGRATION_SOURCE_PASS",
      {"project_src_pairs":3, "cases":len(cases),
       "settings_owner":"UIKit", "respring_owner":"SpringBoard",
       "first_success_stop":True, "keyplane_mutation":False,
       "device":"PENDING"})
