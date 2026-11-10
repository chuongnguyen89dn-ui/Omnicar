#!/usr/bin/env python3
"""Verify the exact HL14 DEB, not a loose build-tree dylib.

Usage: python3 verify_hl14_deb.py /path/to/com.anlai.omnicar_1.0.3-hl14kbpicker_iphoneos-arm64.deb
Requires dpkg-deb. Checks headers/architecture/signature payload/embedded HL8-HL14 markers.
It does NOT prove runtime UI layout, keyboard keyplane behavior or signature trust.
"""
import hashlib
import pathlib
import struct
import subprocess
import sys
from tempfile import TemporaryDirectory

assert len(sys.argv) == 2, "pass one DEB path"
p = pathlib.Path(sys.argv[1])
assert p.is_file() and p.stat().st_size > 100000, "missing/truncated package"
fields = subprocess.check_output(
    ["dpkg-deb", "--field", str(p), "Package", "Version", "Architecture"],
    text=True,
)
for value in ("com.anlai.omnicar", "1.0.3-hl14kbpicker", "iphoneos-arm64"):
    assert value in fields, (value, fields)

def get_slices(data):
    header = struct.unpack_from(">I", data)[0]
    assert header in (0xcafebabe, 0xcafebabf), "not a FAT Mach-O"
    n = struct.unpack_from(">I", data, 4)[0]
    is64 = header == 0xcafebabf
    stride = 32 if is64 else 20
    found = {}
    for i in range(n):
        pos = 8 + stride * i
        if is64:
            cpu, subtype, offset, size, align, reserved = struct.unpack_from(">IIQQII", data, pos)
        else:
            cpu, subtype, offset, size, align = struct.unpack_from(">IIIII", data, pos)
        if cpu != 0x100000c:
            continue
        assert 0 < offset and size > 1000 and offset + size <= len(data)
        image = data[offset:offset + size]
        assert image[:4] == b"\xcf\xfa\xed\xfe", "not MH_MAGIC_64"
        commands = struct.unpack_from("<I", image, 16)[0]
        off = 32
        signature = False
        for _ in range(commands):
            cmd, length = struct.unpack_from("<II", image, off)
            assert length >= 8 and off + length <= len(image)
            if cmd == 0x1d:  # LC_CODE_SIGNATURE
                sig_at, sig_size = struct.unpack_from("<II", image, off + 8)
                signature = bool(sig_size and sig_at + sig_size <= len(image))
            off += length
        assert signature, "missing Mach-O code signature payload"
        found[subtype & 0xff] = image
    assert set(found) == {0, 2}, "arm64 + arm64e are both required"
    return found

libnames = ("OmniCarCore", "OmniCarAppBridge", "OmniCarCarProbe",
            "OmniCarSpeedBubble", "OmniCarSplitScreen", "OmniCarStartupScreen")
bridge_markers = (b"[hl8diag]", b"[hl11kb]", b"[pinch2] trigger=began toggle-sent dir=0",
                  b"[hl14kb] ev=native-fit", b"[hl14kb] ev=restore",
                  b"ev=geometry-recv source=original-orientation-channel",
                  b"ev=reload-input-views reason=layout-not-settled",
                  b"[hl14kb] ev=geometry-push")
split_markers = (b"[hl8diag]", b"native-logo-owned", b"fs-hidden-save",
                 b"fs-hidden-restore", b"ev=picker-host", b"ev=shield-host",
                 b"[hl13pinch]", b"route=inapp-hosted", b"hostedPinchFallback",
                 b"[hl14-picker]", b"[hl14-floating]", b"dock-hosted-readback",
                 b"dock-readback", b"dock-tap")
with TemporaryDirectory(prefix="hl14-verify-") as temp:
    subprocess.check_call(["dpkg-deb", "--extract", str(p), temp])
    base = pathlib.Path(temp) / "var/jb/Library/MobileSubstrate/DynamicLibraries"
    for lib in libnames:
        dylib = base / (lib + ".dylib")
        assert dylib.is_file(), str(dylib)
        for subtype, image in get_slices(dylib.read_bytes()).items():
            markers = bridge_markers if lib == "OmniCarAppBridge" else (
                split_markers if lib == "OmniCarSplitScreen" else ()
            )
            for marker in markers:
                assert marker in image, (lib, subtype, marker)
        print(lib + ": two signed slices PASS")
print(fields.strip())
print("Size:", p.stat().st_size)
print("SHA256:", hashlib.sha256(p.read_bytes()).hexdigest())
print("PASS: binary structure only; DEVICE/PICKER/KEYBOARD pixel NOT PROVEN")
