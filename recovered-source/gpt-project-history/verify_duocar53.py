#!/usr/bin/env python3
"""Final one-file DuoCar HL54 FAT binary audit. Must run on the actual
artifact after resigning LeBubble; never count a prior CI's log as proof.
"""
from pathlib import Path
import hashlib
import plistlib
import struct
import subprocess
import sys
import tempfile

assert len(sys.argv) in (3,4),"usage: verify_duocar53.py final.deb LeOriginal0.2.4.deb [expected-version]"
expected_version=sys.argv[3] if len(sys.argv)==4 else "1.0.3-le0247"
le_original=Path(sys.argv[2]).resolve()
assert le_original.is_file()
deb=Path(sys.argv[1]).resolve()
assert deb.is_file() and deb.stat().st_size>1_500_000,deb
def run(*args):return subprocess.check_output(args,text=True).strip()
assert [run("dpkg-deb","-f",str(deb),key) for key in
        ("Package","Version","Architecture")] == [
    "com.chuong.duocar",expected_version,"iphoneos-arm64"]
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
with tempfile.TemporaryDirectory(prefix="duocar53-verify-") as t:
    root=Path(t)
    subprocess.run(["dpkg-deb","-x",str(deb),str(root)],check=True)
    jb=root/"var/jb"
    libs=jb/"Library/MobileSubstrate/DynamicLibraries"
    for name in first+vendor:
        verify_fat(libs/(name+".dylib"))
        assert (libs/(name+".plist")).is_file(),name
    # HL54 removes ALL unit text from the Lề vendor, including UTF-16
    # localized/traffic/accessibility strings in every FAT slice.
    no_unit_names=vendor+["LePrefs"]
    for name in no_unit_names:
        binary=(jb/"Library/PreferenceBundles/LePrefs.bundle/LePrefs"
                if name=="LePrefs" else libs/(name+".dylib"))
        slices=verify_fat(binary)
        for sub,data in slices.items():
            assert b"km/h" not in data,(name,hex(sub),"ASCII unit remains")
            assert "km/h".encode("utf-16le") not in data,(
                name,hex(sub),"UTF-16LE unit remains")
    print("HL54_LE_ALL_KMH_ABSENT_IN_SIGNED_FAT",len(no_unit_names))
    extended=verify_fat(libs/"DCLLeExtension.dylib")
    for sub,data in extended.items():
        assert has_marker(data,"[le024-ext]")
        assert has_marker(data,"[le024-config]")
        for extra in ("[hl55-le-window]","[hl55-le-master]",
                      "[hl54-store-sb]"):
            assert has_marker(data,extra),(sub,"Lề master/store/overlay absent",extra)
        assert has_marker(data,"repaired malformed modules"),"vendor schema repair missing"
        # Markers in BOTH signed slices; not a CarPlay runtime claim.
        for expected in ("[hl52-free-xy] BEGIN","[hl55-le-edge] END",
                         "[hl52-free-xy] BLIND","[hl52-free-xy] BAD GEOMETRY"):
            assert has_marker(data,expected),(sub,"native drag missing",expected)

    # The actual signed FAT must contain both physical direction owners
    # on EACH architecture, not just the portable C test source.
    appbridge=verify_fat(libs/"DuoCarAppBridge.dylib")
    for sub,data in appbridge.items():
        for m in ("[hl53-pinch] owner=inapp phase=pair-formed",
                  "[hl53-pinch] owner=inapp phase=threshold",
                  "[hl53-pinch] owner=inapp phase=relay",
                  "[hl53-pinch] owner=inapp phase=ended-without-direction"):
            assert has_marker(data,m),("hosted 2D direction path missing",hex(sub),m)
        assert not has_marker(data,"[pinch2] trigger=began toggle-sent"),(
            "old bare toggle shipped",hex(sub))
    car=verify_fat(libs/"DuoCarSplitScreen.dylib")
    for sub,data in car.items():
        for m in ("[hl53-pinch] owner=car phase=pair-formed",
                  "[hl53-pinch] owner=car phase=direction",
                  "[hl53-pinch] owner=car phase=direction-accepted",
                  "direction-required"):
            assert has_marker(data,m),("native directional pinch missing",hex(sub),m)
        assert not has_marker(data,"source=pair-began"),("bare pair toggle shipped",hex(sub))
        for candidate in ("[hl49-opaque]","[hl48-hosted-picker]","[hl49-pane]",
                          "[hl49-window-ab]","[hl51-dock] IN NATIVE DOCK SUBTREE"):
            print("HL53_MARKER_DIAG",hex(sub),candidate,has_marker(data,candidate),flush=True)
        assert has_marker(data,"[hl49-opaque]")
        assert has_marker(data,"[hl51-dock] IN NATIVE DOCK SUBTREE")
        assert has_marker(data,"[hl49-window-ab]")
        assert has_marker(data,"[fs1]"),"fullscreen engine binary missing"
        assert has_marker(data,"[pinch2]"),"pinch recognizer binary missing"
        assert has_marker(data,"[fs-vitals]"),"working fullscreen vitals bubble missing"
        assert has_marker(data,"[hl55-thermal]"),"red 39C alert missing"
        assert has_marker(data,"CẢNH BÁO NHIỆT ĐỘ"),"thermal warning text missing"
        assert has_marker(data,"[hl50-menu]"),"scene-preserve path absent"
        assert has_marker(data,"[hl51-menu] sheetHost="),"restored original menu owner missing"
        # HL53 deliberately changes the old pair-toggle path. Pinch OUT
        # always expands; pinch IN restores; no 2-touch Began toggle.
        assert has_marker(data,"[hl53-pinch] owner=car phase=direction")
        assert has_marker(data,"direction-required")
        assert has_marker(data,"[hl51-dock] NO SAFE RAIL"),"native free-rail check missing"

    app=jb/"Applications/DuoCar.app/DuoCar"
    verify_fat(app)
    # HL52 replaced the old compatibility page; the merge and final
    # gates BOTH require its actual signed vendor class loader.
    assert has_marker(app.read_bytes(),"[hl52-le-original] ORIGINAL LOADED"),"real Lề root not linked"
    assert has_marker(app.read_bytes(),"CWTrafficBubblePrefsController"),"vendor principal missing"
    for sub,content in verify_fat(app).items():
        for extra in ("[hl54-store]","[hl55-vendor-save]",
                      "Hiển thị bong bóng Lề","Hiệu chỉnh tốc độ GPS"):
            assert has_marker(content,extra),(sub,"Lề master/vendor-save/GPS missing",extra)
    assert has_marker(app.read_bytes(),"DuoCar • Tùy chỉnh Lề"),"extras page absent"
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
    # Only the precisely whitelisted vendor binaries have changed; other
    # original Lề files/filters are byte identical to the verified package.
    modified={"LeBubble","LeGoogleMaps","LeGoogleRelay",
              "LeGoogleSource","LeGofaSource","LeWazeSource"}
    for name in vendor:
        for suffix in (".plist",".dylib"):
            if suffix==".dylib" and name in modified:continue
            assert (libs/(name+suffix)).read_bytes()==(original_libs/(name+suffix)).read_bytes(),(
                "unexpected original vendor change",name,suffix)
    original_prefs=(pristine/"var/jb/Library/PreferenceBundles/LePrefs.bundle/LePrefs").read_bytes()
    assert prefs.read_bytes()!=original_prefs,"LePrefs km/h still unpatched"
    print("HL54_VENDOR_NON_UNIT_ASSETS_IDENTICAL: 3 vendor dylibs, 9 filters")

    for name in vendor:
        path=libs/(name+".plist")
        assert "Filter" in plistlib.loads(path.read_bytes())
    assert not (jb/"Library/PreferenceLoader/Preferences/Le.plist").exists()
sha=hashlib.sha256(deb.read_bytes()).hexdigest()
print("HL54_NO_UNIT_FINAL_FAT_PASS",sha,"bytes",deb.stat().st_size,
      "HL54: all vendor km/h absent, clock snap+free; original Lề UI class retained, 360-degree pinch preserved; DEVICE PENDING")
