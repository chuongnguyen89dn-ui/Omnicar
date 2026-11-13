#!/usr/bin/env python3
"""Inspect the ACTUAL HL47 signed FAT DEB (not build logs/source) for 8 binaries."""
from __future__ import annotations
import hashlib
import pathlib
import plistlib
import struct
import subprocess
import sys
import tempfile

deb = pathlib.Path(sys.argv[1]).resolve()
version = "1.0.3-hl47menudockfat1"
assert deb.is_file() and deb.stat().st_size > 100000, f"No build: {deb}"
def field(key):
    return subprocess.check_output(["dpkg-deb", "-f", str(deb), key], text=True).strip()
assert [field(k) for k in ("Package","Version","Architecture")] == [
    "com.chuong.duocar",version,"iphoneos-arm64"]
meta = subprocess.check_output(["dpkg-deb","-f",str(deb)],text=True).lower()
assert "com.anlai.omnicar" not in meta
assert "replaces:" not in meta and "breaks:" not in meta

def signed_thin(data, name, arch):
    assert data[:4] == bytes.fromhex("cffaedfe"), (name,arch,"not MachO64")
    _,cpu,sub,_,ncmds,_,_,_ = struct.unpack_from("<IiiIIIII",data,0)
    assert cpu == 0x0100000c, (name,arch,"wrong CPU")
    subtype = sub & 0xffffff
    assert subtype == (2 if arch == "arm64e" else 0), (name,arch,subtype)
    offset = 32
    signature = 0
    for _ in range(ncmds):
        cmd,cmdsize = struct.unpack_from("<II",data,offset)
        assert cmdsize >= 8 and offset + cmdsize <= len(data), (name,arch)
        if cmd == 0x1d:
            dataoff,datasize = struct.unpack_from("<II",data,offset+8)
            assert dataoff + datasize <= len(data), (name,arch)
            signature = datasize
        offset += cmdsize
    assert signature > 500,(name,arch,"unsigned",signature)
    return signature

with tempfile.TemporaryDirectory(prefix="duocar-hl47-fat-") as tmp:
    root=pathlib.Path(tmp)
    subprocess.run(["dpkg-deb","-x",str(deb),str(root)],check=True)
    jb=root/"var/jb"
    lib=jb/"Library/MobileSubstrate/DynamicLibraries"
    files=[
        ("Core",lib/"DuoCarCore.dylib"),
        ("AppBridge",lib/"DuoCarAppBridge.dylib"),
        ("CarProbe",lib/"DuoCarCarProbe.dylib"),
        ("SpeedBubble",lib/"DuoCarSpeedBubble.dylib"),
        ("Split",lib/"DuoCarSplitScreen.dylib"),
        ("Startup",lib/"DuoCarStartupScreen.dylib"),
        ("Prefs",jb/"Library/PreferenceBundles/DuoCarPrefs.bundle/DuoCarPrefs"),
        ("App",jb/"Applications/DuoCar.app/DuoCar"),
    ]
    for name,path in files:
        assert path.is_file(), f"Missing component: {path}"
        arches=subprocess.check_output(["lipo","-archs",str(path)],text=True).split()
        assert len(arches)==2 and set(arches)=={"arm64","arm64e"},(name,arches)
        for arch in ("arm64","arm64e"):
            thin=root/(name+"-"+arch)
            subprocess.run(["lipo","-thin",arch,str(path),"-output",str(thin)],check=True)
            data=thin.read_bytes()
            signature=signed_thin(data,name,arch)
            if name=="Split":
                for marker in (b"[hl45-layer]",b"[hl46-bypass]",b"[vitals]",b"[fs-vitals]"):
                    assert marker in data,(name,arch,"missing",marker)
            if name=="AppBridge":
                for marker in (b"[hl43-cancel]",b"[hl42-native-plane]",b"[pinch2]"):
                    assert marker in data,(name,arch,"missing",marker)
            if name=="App":
                assert b"/Speech.framework/" not in data,(name,arch,"voice restored")
            print("SIGNED_FAT_PASS",name,arch,subtype if False else "",
                  "code-signature-size",signature)
    info=plistlib.loads((jb/"Applications/DuoCar.app/Info.plist").read_bytes())
    assert info.get("CFBundleIdentifier")=="com.chuong.duocar.app",info
    assert info.get("CFBundlePackageType")=="APPL"
    assert "NSSpeechRecognitionUsageDescription" not in info
    assert "NSMicrophoneUsageDescription" not in info
    for name,_ in files:
        pass
print("HL47_SIGNED_FAT_DEB_PASS",deb,hashlib.sha256(deb.read_bytes()).hexdigest())
