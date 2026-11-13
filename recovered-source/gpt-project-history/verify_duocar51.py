#!/usr/bin/env python3
"""Final one-file DuoCar51 FAT binary audit. Must run on the actual
artifact after resigning LeBubble; never count a prior CI's log as proof.
"""
from pathlib import Path
import hashlib
import plistlib
import struct
import subprocess
import sys
import tempfile

assert len(sys.argv)==3,"usage: verify_duocar51.py dist/DuoCar51.deb LeOriginal0.2.4.deb"
le_original=Path(sys.argv[2]).resolve()
assert le_original.is_file()
deb=Path(sys.argv[1]).resolve()
assert deb.is_file() and deb.stat().st_size>1_500_000,deb
def run(*args):return subprocess.check_output(args,text=True).strip()
assert [run("dpkg-deb","-f",str(deb),key) for key in
        ("Package","Version","Architecture")] == [
    "com.chuong.duocar","1.0.3-le0244","iphoneos-arm64"]
assert "dev.bechou.le" in run("dpkg-deb","-f",str(deb),"Conflicts")
assert "firmware (<< 27.0)" in run("dpkg-deb","-f",str(deb),"Depends")
first=["DuoCarCore","DuoCarAppBridge","DuoCarCarProbe",
       "DuoCarSplitScreen","DuoCarStartupScreen","DCLLeExtension"]
vendor=["LeBubble","LeSupervisor","LeGoogleRelay","LeGuidanceRelay",
        "LeGofaSource","LeWazeSource","LeGoogleSource","LeSourceShown","LeGoogleMaps"]
def has_marker(data, marker):
    # Objective-C @"..." string literals are frequently emitted UTF-16LE,
    # while NSLog C-format strings are UTF-8. Test both representations.
    if isinstance(marker, bytes):
        marker=marker.decode("utf-8")
    return marker.encode("utf-8") in data or marker.encode("utf-16-le") in data

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
with tempfile.TemporaryDirectory(prefix="duocar51-verify-") as t:
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
        assert has_marker(data,"[le024-ext]")
        assert has_marker(data,"[le024-config]")
        assert has_marker(data,"repaired malformed modules"),"vendor schema repair missing"

    car=verify_fat(libs/"DuoCarSplitScreen.dylib")
    for sub,data in car.items():
        for candidate in ("[hl49-opaque]","[hl48-hosted-picker]","[hl49-pane]",
                          "[hl49-window-ab]","[hl51-dock] IN NATIVE DOCK SUBTREE"):
            print("HL51_MARKER_DIAG",hex(sub),candidate,has_marker(data,candidate),flush=True)
        assert has_marker(data,"[hl49-opaque]")
        assert has_marker(data,"[hl51-dock] IN NATIVE DOCK SUBTREE")
        assert has_marker(data,"[hl49-window-ab]")
        assert has_marker(data,"[fs1]"),"fullscreen engine binary missing"
        assert has_marker(data,"[pinch2]"),"pinch recognizer binary missing"
        assert has_marker(data,"[fs-vitals]"),"working fullscreen vitals bubble missing"
        assert has_marker(data,"[hl50-menu]"),"scene-preserve path absent"
        assert has_marker(data,"[hl51-menu] sheetHost="),"restored original menu owner missing"
        # HL51 explicitly defers zoom; restore HL50 ownership and verify
        # the old route is present, not a new untested HL8-only override.
        assert has_marker(data,"[hl13pinch] route=split-hosted-owners"),"HL50 pinch route missing"
        assert not has_marker(data,"[hl51-pinch]"),"deferred pinch patch leaked into build"
        assert has_marker(data,"[hl51-dock] NO SAFE RAIL"),"native free-rail check missing"

    app=jb/"Applications/DuoCar.app/DuoCar"
    verify_fat(app)
    assert has_marker(app.read_bytes(),"[le024-prefs]")
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
    # Preserve all Le 0.2.4 source/relay/vendor binaries byte-identically.
    # LeBubble is the only intentionally changed (unit patch + ad-hoc resign).
    pristine=root/"pristine-vendor"
    pristine.mkdir()
    subprocess.run(["dpkg-deb","-x",str(le_original),str(pristine)],check=True)
    original_libs=pristine/"var/jb/Library/MobileSubstrate/DynamicLibraries"
    for name in vendor:
        for suffix in (".plist",".dylib"):
            if name=="LeBubble" and suffix==".dylib":continue
            assert (libs/(name+suffix)).read_bytes()==(original_libs/(name+suffix)).read_bytes(),(
                "unexpected original vendor change",name,suffix)
    assert prefs.read_bytes()==(
        pristine/"var/jb/Library/PreferenceBundles/LePrefs.bundle/LePrefs").read_bytes()
    print("HL51_VENDOR_ORIGINAL_IDENTICAL: 8 vendor dylibs, 9 filters, LePrefs")

    for name in vendor:
        path=libs/(name+".plist")
        assert "Filter" in plistlib.loads(path.read_bytes())
    assert not (jb/"Library/PreferenceLoader/Preferences/Le.plist").exists()
sha=hashlib.sha256(deb.read_bytes()).hexdigest()
print("DUOCAR51_FINAL_FAT_PASS",sha,"bytes",deb.stat().st_size,
      "native Dock + menu markers / original Lề data + modified GPS unit / old SpeedBubble absent")
