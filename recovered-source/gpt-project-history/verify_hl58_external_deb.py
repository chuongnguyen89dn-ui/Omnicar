#!/usr/bin/env python3
"""Verify actual signed FAT DC58 payload, NOT source-only claims."""
from pathlib import Path
import argparse
import hashlib
import os
import plistlib
import struct
import subprocess
import tempfile

MODULES={"LeBubble","LeGoogleMaps","LeGoogleRelay","LeGoogleSource",
         "LeWazeSource","LeGofaSource","LeSupervisor","LeGuidanceRelay",
         "LeSourceShown"}
def field(path,key):
    return subprocess.check_output(["dpkg-deb","-f",str(path),key],
                                   text=True).strip()
def has(blob,s):
    return s.encode() in blob or s.encode("utf-16le") in blob
def machos(path):
    data=path.read_bytes()
    assert len(data)>20000,("Missing executable",path)
    magic,narch=struct.unpack_from(">II",data,0)
    assert magic==0xcafebabe and narch==2,(path,hex(magic),narch)
    by_sub={}
    for i in range(narch):
        cpu,sub,start,length,align=struct.unpack_from(">IIIII",data,8+i*20)
        assert cpu==0x0100000c and sub in (0,0x80000002) and sub not in by_sub
        assert start>0 and length>=12000 and start+length<=len(data)
        blob=data[start:start+length]
        assert blob[:4]==bytes.fromhex("cffaedfe")
        ncommands=struct.unpack_from("<I",blob,16)[0]
        where=32
        signed=False
        for _ in range(ncommands):
            cmd,size=struct.unpack_from("<II",blob,where)
            assert size>=8 and where+size<=len(blob)
            if cmd==0x1d:
                offset,span=struct.unpack_from("<II",blob,where+8)
                assert offset>=0 and span>128 and offset+span<=len(blob)
                signed=True
            where+=size
        assert signed,("unsigned FAT",path,sub)
        by_sub[sub]=blob
    assert len(by_sub)==2
    return by_sub

def check(deb):
    assert field(deb,"Package")=="com.chuong.duocar"
    assert field(deb,"Version")=="1.0.4-hl58"
    assert field(deb,"Architecture")=="iphoneos-arm64"
    all_fields=subprocess.check_output(["dpkg-deb","-f",str(deb)],text=True)
    for line in all_fields.splitlines():
        if line.startswith(("Depends:","Conflicts:","Replaces:")):
            assert "dev.bechou.le" not in line,line
    assert subprocess.run(["dpkg","--compare-versions","1.0.4-hl58",
                            "gt","1.0.3-le0249"]).returncode==0
    with tempfile.TemporaryDirectory(prefix="dc58-audit-") as scratch:
        root=Path(scratch)/"package"
        subprocess.run(["dpkg-deb","-x",str(deb),str(root)],check=True)
        owned=[]
        for top,dirs,names in os.walk(root,followlinks=False):
            for name in names:
                file=Path(top)/name
                assert not file.is_symlink()
                rel=file.relative_to(root).as_posix()
                low=rel.lower()
                assert not low.startswith("var/jb/usr/share/le/"),rel
                assert not "/leprefs.bundle/" in low,rel
                assert not "dev.bechou.le" in low,rel
                assert not low.endswith("/library/preferenceloader/preferences/le.plist"),rel
                for n in MODULES:
                    assert not low.endswith(("/"+n+".dylib").lower()),rel
                    assert not low.endswith(("/"+n+".plist").lower()),rel
                owned.append(file)
        p=root/"var/jb/"
        app=p/"Applications/DuoCar.app/DuoCar"
        ext=p/"Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.dylib"
        filter=p/"Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.plist"
        assert app.is_file() and ext.is_file() and filter.is_file()
        filt=plistlib.loads(filter.read_bytes())
        bundles=filt.get("Filter",{}).get("Bundles",[])
        assert "com.apple.CarPlayApp" in bundles
        assert "com.apple.springboard" in bundles
        signed=0
        for file in owned:
            if file.suffix==".dylib" or file==app or (
                file.suffix=="" and os.access(file,os.X_OK) and file.stat().st_size>20000):
                if file.read_bytes()[:4]==bytes.fromhex("cafebabe"):
                    slices=machos(file)
                    signed+=len(slices)
        assert signed>=12,("missing FAT signed module",signed)
        for subtype,blob in machos(ext).items():
            for marker in ("[hl58-external-le]","[hl58-external-le-config]",
                           "CWTrafficBubbleContent","CWTrafficOverlayController",
                           "CWCastBubbleController","leTrafficGpsOffsetKph",
                           "leBubbleMasterEnabled"):
                assert has(blob,marker),(subtype,"shim marker",marker)
            for forbidden in ("[hl55-le-edge]","[hl56-hosted-layer]",
                              "DCLTrafficSnapWhenNearEdge","DCLLeOriginalStoreStart",
                              "DCLLeWindowState","panned:"):
                assert not has(blob,forbidden),("unwanted vendor pan/scene hook",forbidden)
        for subtype,blob in machos(app).items():
            for marker in ("Lề cài riêng","Hiệu chỉnh GPS","Bật/tắt bong bóng"):
                assert has(blob,marker),("missing UI",subtype,marker)
            for forbidden in ("CWTrafficBubblePrefsController",
                              "[hl56-config-source]","DCLLeHydrateAppLayout"):
                assert not has(blob,forbidden),("old bundled LePrefs UI",forbidden)
        print("HL58_EXTERNAL_LE_OPTIONAL_FAT_SIGNED_PASS",
              "signed_slices="+str(signed),"vendor_asset_count=0",
              "bytes="+str(deb.stat().st_size),
              "sha256="+hashlib.sha256(deb.read_bytes()).hexdigest())
def main():
    a=argparse.ArgumentParser()
    a.add_argument("deb",type=Path)
    args=a.parse_args()
    check(args.deb.resolve())
if __name__=="__main__":
    main()
