#!/usr/bin/env python3
"""Inspect the exact signed HL48 DuoCar + Lề 0.2.4 ONE-DEB artifact."""
import hashlib
import pathlib
import plistlib
import struct
import subprocess
import sys
import tempfile

assert len(sys.argv)==2, "Usage: verify_hl48_le024_payload.py DuoCar48.deb"
deb=pathlib.Path(sys.argv[1]).resolve()
assert deb.is_file() and deb.stat().st_size>1_500_000, deb
def field(name):
    return subprocess.check_output(["dpkg-deb","-f",str(deb),name],text=True).strip()
assert [field(x) for x in ("Package","Version","Architecture")] == [
    "com.chuong.duocar","1.0.3-le0241","iphoneos-arm64"]
depends=field("Depends")
assert "firmware (<< 27.0)" in depends
assert "dev.bechou.le" in field("Conflicts")
assert "dev.bechou.le" in field("Replaces")

first_party=["DuoCarCore","DuoCarAppBridge","DuoCarCarProbe",
             "DuoCarSplitScreen","DuoCarStartupScreen"]
vendor=["LeBubble","LeSupervisor","LeGoogleRelay","LeGuidanceRelay",
        "LeGofaSource","LeWazeSource","LeGoogleSource",
        "LeSourceShown","LeGoogleMaps"]
def thin_signature(path,arch,tmp):
    part=tmp/(path.name+"-"+arch)
    subprocess.run(["lipo","-thin",arch,str(path),"-output",str(part)],
                   check=True,stdout=subprocess.DEVNULL)
    data=part.read_bytes()
    assert data[:4]==bytes.fromhex("cffaedfe"),(path,arch,"not Mach-O64")
    _,cpu,sub,_,ncmds,_,_,_=struct.unpack_from("<IiiIIIII",data,0)
    assert cpu==0x0100000c
    assert sub&0xffffff==(2 if arch=="arm64e" else 0), (path,arch,sub)
    pos=32
    signature=0
    for _ in range(ncmds):
        cmd,sz=struct.unpack_from("<II",data,pos)
        assert sz>=8 and pos+sz<=len(data)
        if cmd==0x1d:
            where,howbig=struct.unpack_from("<II",data,pos+8)
            assert where+howbig<=len(data),(path,arch)
            signature=howbig
        pos+=sz
    return signature,data

with tempfile.TemporaryDirectory(prefix="hl48-le024-verify-") as d:
    tmp=pathlib.Path(d)
    root=tmp/"payload"
    subprocess.run(["dpkg-deb","-x",str(deb),str(root)],check=True)
    jb=root/"var"/"jb"
    libs=jb/"Library/MobileSubstrate/DynamicLibraries"
    for forbidden in ("DuoCarSpeedBubble","OmniCarSpeedBubble"):
        for ext in (".dylib",".plist"):
            assert not (libs/(forbidden+ext)).exists(),forbidden
    assert (jb/"Library/PreferenceBundles/LePrefs.bundle/LePrefs").is_file()
    assert not (jb/"Library/PreferenceLoader/Preferences/Le.plist").exists()
    assert (jb/"Applications/DuoCar.app/DuoCar").is_file()
    assert (jb/"Library/PreferenceBundles/DuoCarPrefs.bundle/DuoCarPrefs").is_file()
    first=[libs/(n+".dylib") for n in first_party]
    first.extend([jb/"Applications/DuoCar.app/DuoCar",
                  jb/"Library/PreferenceBundles/DuoCarPrefs.bundle/DuoCarPrefs",
                  libs/"DCLLeExtension.dylib"])
    originals=[libs/(n+".dylib") for n in vendor]
    for name in vendor:
        filt=libs/(name+".plist")
        assert filt.is_file(),filt
        data=plistlib.loads(filt.read_bytes())
        assert "Filter" in data and "Bundles" in data["Filter"]
    for path in first+originals:
        assert path.is_file(),path
        arches=set(subprocess.check_output(["lipo","-archs",str(path)],text=True).split())
        assert arches=={"arm64","arm64e"},(path,arches)
        for arch in ("arm64","arm64e"):
            size,source=thin_signature(path,arch,tmp)
            if path in first:
                assert size>500,(path,arch,"missing code signature",size)
            # The original vendor binary is copied byte-identically; report
            # original signature size rather than resigning or editing it.
            if path.name=="DuoCarSplitScreen.dylib":
                for key in (b"[hl48-hosted-picker]",b"[vitals]",b"[fs-vitals]",
                            b"[hl46-bypass]",b"[hl45-layer]"):
                    assert key in source,(key,path,arch)
            if path.name=="DCLLeExtension.dylib":
                assert b"[le024-ext]" in source,(path,arch)
            if path.name=="DuoCar":
                assert b"[le024-prefs]" in source,(path,arch)
            print("HL48_FAT",path.name,arch,"signed_bytes",size)
    assert len(first)==8 and len(originals)==9
    assert (libs/"DCLLeExtension.plist").is_file()
    assert plistlib.loads((libs/"DCLLeExtension.plist").read_bytes())["Filter"]["Bundles"]
    print("HL48_ORIGINAL_LE_LIBRARIES",len(originals),
          "ORIGINAL_PREFS",1,"FIRST_PARTY",len(first))
print("DUOCAR48_ONE_DEB_SIGNED_FAT_VERIFIED",
      "bytes",deb.stat().st_size,
      "SHA256",hashlib.sha256(deb.read_bytes()).hexdigest())
