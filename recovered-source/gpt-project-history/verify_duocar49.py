#!/usr/bin/env python3
"""Final one-file DuoCar49 FAT binary audit. Must run on the actual
artifact after resigning LeBubble; never count a prior CI's log as proof.
"""
from pathlib import Path
import hashlib
import plistlib
import struct
import subprocess
import sys
import tempfile

assert len(sys.argv)==2,"usage: verify_duocar49.py dist/DuoCar49.deb"
deb=Path(sys.argv[1]).resolve()
assert deb.is_file() and deb.stat().st_size>1_500_000,deb
def run(*args):return subprocess.check_output(args,text=True).strip()
assert [run("dpkg-deb","-f",str(deb),key) for key in
        ("Package","Version","Architecture")] == [
    "com.chuong.duocar","1.0.3-le0242","iphoneos-arm64"]
assert "dev.bechou.le" in run("dpkg-deb","-f",str(deb),"Conflicts")
assert "firmware (<< 27.0)" in run("dpkg-deb","-f",str(deb),"Depends")
first=["DuoCarCore","DuoCarAppBridge","DuoCarCarProbe",
       "DuoCarSplitScreen","DuoCarStartupScreen","DCLLeExtension"]
vendor=["LeBubble","LeSupervisor","LeGoogleRelay","LeGuidanceRelay",
        "LeGofaSource","LeWazeSource","LeGoogleSource","LeSourceShown","LeGoogleMaps"]
def verify_fat(path):
    contents=path.read_bytes()
    assert contents[:4]==bytes.fromhex("cafebabe"),path
    n=struct.unpack_from(">I",contents,4)[0]
    assert n==2,(path,n)
    arches={}
    for j in range(n):
        cpu,sub,start,size,align=struct.unpack_from(">IIIII",contents,8+j*20)
        assert cpu==0x100000c
        assert sub in [0,0x80000002]
        data=contents[start:start+size]
        assert data[:4]==bytes.fromhex("cffaedfe")
        count=struct.unpack_from("<I",data,16)[0]
        off=32;code=0
        for _ in range(count):
            cmd,length=struct.unpack_from("<II",data,off)
            assert length>=8 and off+length<=len(data)
            if cmd==0x1d:
                position,signature=struct.unpack_from("<II",data,off+8)
                assert position+signature<=len(data)
                code=signature
            off+=length
        assert code>256,(path,sub,"unsigned")
        arches[sub]=data
    assert sorted(arches)==[0,0x80000002]
    return arches
with tempfile.TemporaryDirectory(prefix="duocar49-verify-") as t:
    root=Path(t)
    subprocess.run(["dpkg-deb","-x",str(deb),str(root)],check=True)
    jb=root/"var/jb"
    libs=jb/"Library/MobileSubstrate/DynamicLibraries"
    for name in first+vendor:
        verify_fat(libs/(name+".dylib"))
        assert (libs/(name+".plist")).is_file(),name
    bubble=verify_fat(libs/"LeBubble.dylib")
    for sub,data in bubble.items():
        assert b"km/h\x00" not in data,("LeBubble GPS unit still present",sub)
        assert b"    \x00" in data,("LeBubble GPS unit patch missing",sub)
    extended=verify_fat(libs/"DCLLeExtension.dylib")
    for sub,data in extended.items():
        assert b"[le024-ext]" in data
        assert b"[le024-config]" in data
    car=verify_fat(libs/"DuoCarSplitScreen.dylib")
    for sub,data in car.items():
        assert b"[hl49-opaque]" in data
        assert b"[vitals] native-dock-attached" in data
        assert b"[hl49-window-ab]" in data
    app=jb/"Applications/DuoCar.app/DuoCar"
    verify_fat(app)
    assert b"[le024-prefs]" in app.read_bytes()
    pref=jb/"Library/PreferenceBundles/DuoCarPrefs.bundle/DuoCarPrefs"
    verify_fat(pref)
    assert b"DCRSpeedBubbleController" not in pref.read_bytes()
    for p in (jb/"Applications/DuoCar.app",
              jb/"Library/PreferenceBundles/DuoCarPrefs.bundle"):
        assert not list(p.rglob("*SpeedBubble*")),list(p.rglob("*SpeedBubble*"))
    for old in ("OmniCarSpeedBubble","DuoCarSpeedBubble"):
        assert not (libs/(old+".dylib")).exists()
        assert not (libs/(old+".plist")).exists()
    prefs=jb/"Library/PreferenceBundles/LePrefs.bundle/LePrefs"
    verify_fat(prefs)
    for name in vendor:
        path=libs/(name+".plist")
        assert "Filter" in plistlib.loads(path.read_bytes())
    assert not (jb/"Library/PreferenceLoader/Preferences/Le.plist").exists()
sha=hashlib.sha256(deb.read_bytes()).hexdigest()
print("DUOCAR49_FINAL_FAT_PASS",sha,"bytes",deb.stat().st_size,
      "native Dock + menu markers / original Lề data + modified GPS unit / old SpeedBubble absent")
