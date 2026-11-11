#!/usr/bin/env python3
"""Independent static inspection of the actual HL21 DEB; never DEVICE PASS."""
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
assert fields == ["com.anlai.omnicar", "1.0.3-hl21restored", "iphoneos-arm64"], fields

def fat_slices(data):
    magic = data[:4]
    assert magic in (bytes.fromhex("cafebabe"), bytes.fromhex("cafebabf")), magic.hex()
    fat64 = magic == bytes.fromhex("cafebabf")
    n = struct.unpack_from(">I", data, 4)[0]
    assert n == 2, f"Expected 2 architectures, got {n}"
    pos = 8
    entries = []
    for _ in range(n):
        if fat64:
            cpu, subtype, offset, size, align, reserved = struct.unpack_from(">IIQQII", data, pos)
            pos += 32
        else:
            cpu, subtype, offset, size, align = struct.unpack_from(">IIIII", data, pos)
            pos += 20
        assert offset + size <= len(data)
        thin = data[offset:offset+size]
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
    assert {a[0] for a in entries} == {0, 2}, "Expected arm64 and arm64e"
    return entries

with tempfile.TemporaryDirectory() as folder:
    subprocess.run(["dpkg-deb", "-x", str(deb), folder], check=True)
    root = pathlib.Path(folder) / "var/jb"
    dylib = root / "Library/MobileSubstrate/DynamicLibraries"
    components = {
        "OmniCarCore.dylib": [],
        "OmniCarAppBridge.dylib": ["[hl8diag]", "[hl11kb]", "ev=native-fit", "ev=restore", "[pinch2] trigger=began toggle-sent dir=0"],
        "OmniCarCarProbe.dylib": [],
        "OmniCarSpeedBubble.dylib": [],
        "OmniCarSplitScreen.dylib": ["[hl8diag]", "[hl13pinch]", "[hl21-floating]", "[hl21-legacy-picker]", "[picker-face]", "[home-launch]"],
        "OmniCarStartupScreen.dylib": [],
        "OmniCar.app/OmniCar": [],
        "OmniCarPrefs.bundle/OmniCarPrefs": [],
    }
    reports = []
    for name, markers in components.items():
        if name.startswith("OmniCar.app"):
            p = root / "Applications" / "OmniCar.app" / "OmniCar"
        elif name.startswith("OmniCarPrefs.bundle"):
            p = root / "Library/PreferenceBundles/OmniCarPrefs.bundle/OmniCarPrefs"
        else:
            p = dylib / name
        assert p.is_file(), f"Missing {p}"
        slices = fat_slices(p.read_bytes())
        for subtype, sig, code in slices:
            for marker in markers:
                assert marker.encode() in code, f"Missing {marker} in {name} subtype={subtype}"
        reports.append({"name": name, "slices": [{"subtype": subtype, "signature_size": sig} for subtype,sig,_ in slices]})
    info = plistlib.loads((root / "Applications/OmniCar.app/Info.plist").read_bytes())
    assert info.get("CFBundleIdentifier") == "com.anlai.omnicar.app"
    assert info.get("CFBundlePackageType") == "APPL"
    print(json.dumps({
        "deb": str(deb), "sha256": sha, "size": len(blob),
        "package_fields": fields, "app_id": info.get("CFBundleIdentifier"),
        "binaries": reports, "gate": "STATIC/PACKAGE PASS, NOT DEVICE PASS"
    }, indent=2))
