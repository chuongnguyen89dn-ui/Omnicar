#!/usr/bin/env python3
"""Verify actual signed DuoCar HL43 shared Telex + native Cancel ARM64 package."""
import hashlib
import json
import pathlib
import plistlib
import struct
import subprocess
import sys
import tempfile

deb = pathlib.Path(sys.argv[1]).resolve()
assert deb.is_file(), f"Missing file: {deb}"
blob = deb.read_bytes()
sha = hashlib.sha256(blob).hexdigest()
def field(name):
    return subprocess.check_output(["dpkg-deb", "-f", str(deb), name], text=True).strip()

fields = [field(k) for k in ("Package", "Version", "Architecture")]
assert fields == ["com.chuong.duocar", "1.0.3-hl43telex1", "iphoneos-arm64"], fields
control_text=subprocess.check_output(["dpkg-deb","-f",str(deb)],text=True)
assert "com.anlai.omnicar" not in control_text.lower(), "Old package referenced by dependency metadata"
assert not any(line.startswith(("Replaces:","Breaks:")) for line in control_text.splitlines()), "Unexpected forced package replacement"

def fat_slices(data):
    magic = data[:4]
    # The user requested this diagnostic as a single ARM64 slice, not FAT.
    assert magic == bytes.fromhex("cffaedfe"), "HL40 diagnostic must be thin ARM64"
    entries = []
    for subtype, thin in [(0, data)]:
        assert thin[:4] == bytes.fromhex("cffaedfe"), "Expected little-endian 64-bit Mach-O"
        _, cputype, _, _, ncmds, _, _, _ = struct.unpack_from("<IiiIIIII", thin, 0)
        assert cputype == 0x0100000c, "Not arm64"
        command = 32
        sig = None
        for _ in range(ncmds):
            cmd, cmdsize = struct.unpack_from("<II", thin, command)
            assert cmdsize >= 8
            if cmd == 0x1d:  # LC_CODE_SIGNATURE
                dataoff, datasize = struct.unpack_from("<II", thin, command + 8)
                assert dataoff + datasize <= len(thin)
                sig = datasize
            command += cmdsize
        assert sig is not None and sig > 500, "Missing signed payload"
        entries.append((subtype & 0xffffff, sig, thin))
    assert len(entries) == 1 and entries[0][0] == 0, "Expected arm64 only"
    return entries

with tempfile.TemporaryDirectory() as folder:
    subprocess.run(["dpkg-deb", "-x", str(deb), folder], check=True)
    root = pathlib.Path(folder) / "var/jb"
    dylib = root / "Library/MobileSubstrate/DynamicLibraries"
    components = {
        "DuoCarCore.dylib": [],
        "DuoCarAppBridge.dylib": ["[hl40-original-keyboard]", "[hl40-native-drawn]", "[hl41-native-host]", "[hl41-native-key]", "[hl42-native-plane]", "[hl43-cancel]", "[hl36-kbsync]", "[hl8diag]", "[pinch2] trigger=began toggle-sent dir=0"],
        "DuoCarCarProbe.dylib": [],
        "DuoCarSpeedBubble.dylib": [],
        "DuoCarSplitScreen.dylib": [ "[hl27-respring] stage=observer-ready", "[hl27-respring] stage=accepted", "[hl27-respring] stage=terminate-self", "[hl8diag]", "[hl13pinch]", "[hl21-floating]", "[hl21-legacy-picker]", "[hl22-original]", "[picker-face]", "[home-launch]"],
        "DuoCarStartupScreen.dylib": [],
        "DuoCar.app/DuoCar": [ "[hl26-settings] gate=uikit-tab-ready", "[hl26-settings] gate=app-root-launched", "[hl26-settings] page=startup", "[hl27-settings] gate=original-root-cards", "[hl27-respring] stage=request-sent", "[hl27-respring] stage=ack-timeout"],
        "DuoCarPrefs.bundle/DuoCarPrefs": [],
    }
    reports = []
    for name, markers in components.items():
        if name.startswith("DuoCar.app"):
            p = root / "Applications" / "DuoCar.app" / "DuoCar"
        elif name.startswith("DuoCarPrefs.bundle"):
            p = root / "Library/PreferenceBundles/DuoCarPrefs.bundle/DuoCarPrefs"
        else:
            p = dylib / name
        assert p.is_file(), f"Missing {p}"
        slices = fat_slices(p.read_bytes())
        for subtype, sig, code in slices:
            for marker in markers:
                assert marker.encode() in code, f"Missing {marker} in {name} subtype={subtype}"

            # HL40: check the ACTUAL signed ARM64 binary, not only source lists.
            # Exact terminated identifiers avoid false positives from native
            # ABKeyboardTraits104 and the unrelated speed-warning feature.
            retired = {
                "DuoCarAppBridge.dylib": [],
                "DuoCarSplitScreen.dylib": [
                    b"SCPVoiceBubbleView\x00", b"SCPVoiceSpringSession\x00",
                    b"SCPVoiceBubbleUpdate\x00", b"SCPVoiceSpringInstall\x00",
                    b"/voice.capture.request\x00", b"/voice.capture.state\x00",
                    b"/voice.action\x00", b"/voice.ack\x00"],
                "DuoCar.app/DuoCar": [
                    b"DCVoiceViewController\x00", b"DCVoiceCreateController\x00",
                    b"DCVoiceHandleCarRequest\x00", b"/voice.request\x00"],
            }.get(name, [])
            for retired_identifier in retired:
                assert retired_identifier not in code, (
                    f"Retired HL36 feature is still present in {name} "
                    f"subtype={subtype}: {retired_identifier!r}")
            if name in ("DuoCarAppBridge.dylib", "DuoCarSplitScreen.dylib",
                        "DuoCar.app/DuoCar"):
                assert b"/Speech.framework/" not in code, (
                    f"Speech framework still linked in {name} subtype={subtype}")
        reports.append({"name": name, "slices": [{"subtype": subtype, "signature_size": sig} for subtype,sig,_ in slices]})
    info = plistlib.loads((root / "Applications/DuoCar.app/Info.plist").read_bytes())
    assert info.get("CFBundleIdentifier") == "com.chuong.duocar.app"
    assert info.get("CFBundlePackageType") == "APPL"
    # HL26 app owns the full UIKit settings page resources, not Settings.app.
    assert info.get("NSPhotoLibraryUsageDescription"), "Photo picker permission missing"
    # HL36 voice is out of the product; do not ship assistant permissions.
    assert "NSSpeechRecognitionUsageDescription" not in info, "Voice permission leaked"
    assert "NSMicrophoneUsageDescription" not in info, "Microphone permission leaked"
    schemes = [s for u in info.get("CFBundleURLTypes", []) for s in u.get("CFBundleURLSchemes", [])]
    assert "duocar" in schemes, schemes
    app_dir = root / "Applications/DuoCar.app"
    for name, count in [("Root.plist",15),("FeatureStartupScreen.plist",44),
                        ("FeatureSplitScreen.plist",2),("FeatureSpeedBubble.plist",2)]:
        res = app_dir / name
        assert res.is_file(), f"App-owned resource missing: {name}"
        rows = plistlib.loads(res.read_bytes()).get("items", [])
        assert len(rows) == count, (name,len(rows),count)
    binary = (app_dir / "DuoCar").read_bytes()
    assert b"prefs:root=DuoCar" not in binary and b"prefs:root=OmniCar" not in binary, "App still opens Settings.app"
    # Full payload audit, including all FAT binaries, preference/localization
    # resources, filenames, app metadata and injected filter plists.
    checked = 0
    for path in root.rglob("*"):
        if "omnicar" in str(path.relative_to(root)).lower():
            raise AssertionError(f"Legacy path leaked: {path}")
        if not path.is_file():
            continue
        checked += 1
        data = path.read_bytes()
        if b"omnicar" in data.lower():
            raise AssertionError(f"Legacy bytes leaked in file: {path}")
        if any(name.encode("utf-16-le") in data for name in ("OmniCar", "omnicar", "OMNICAR")):
            raise AssertionError(f"Legacy UTF16 bytes leaked in file: {path}")
    assert checked >= 100, checked
    loader = root / "Library/PreferenceLoader/Preferences/DuoCarPrefs.plist"
    assert loader.is_file(), "DuoCar PreferenceLoader metadata missing"
    bundle = plistlib.loads((root/"Library/PreferenceBundles/DuoCarPrefs.bundle/Info.plist").read_bytes())
    assert bundle.get("CFBundleIdentifier") == "com.chuong.duocar.prefs", bundle
    assert bundle.get("CFBundleExecutable") == "DuoCarPrefs", bundle
    assert info.get("CFBundleExecutable") == "DuoCar", info
    assert info.get("CFBundleName") == "DuoCar", info
    assert info.get("CFBundleDisplayName") == "DuoCar", info
    schemes=[str(s).lower() for v in info.get("CFBundleURLTypes",[]) for s in v.get("CFBundleURLSchemes",[])]
    assert "duocar" in schemes and "omnicar" not in schemes,schemes
    print(json.dumps({
        "deb": str(deb), "sha256": sha, "size": len(blob),
        "package_fields": fields, "app_id": info.get("CFBundleIdentifier"),
        "payload_files_checked": checked, "binaries": reports, "gate": "HL43_SHARED_TELEX_PACKAGE_BINARY_PASS / DEVICE-PENDING"
    }, indent=2))
