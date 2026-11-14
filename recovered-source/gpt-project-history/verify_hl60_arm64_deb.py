#!/usr/bin/env python3
"""Check a real rootless DuoCar single-arm64 signed DEB for the HL59 car test."""
import hashlib
import os
import plistlib
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

def get(deb, field):
    return subprocess.check_output(["dpkg-deb", "-f", str(deb), field],
                                   text=True).strip()

def signed_arm64(path):
    data=path.read_bytes()
    assert len(data)>12000 and data[:4]==bytes.fromhex("cffaedfe"), ("not thin arm64",path,data[:4].hex())
    cpu,sub=struct.unpack_from("<II",data,4)
    assert cpu==0x0100000c and sub==0, ("wrong CPU subtype",path,sub)
    count=struct.unpack_from("<I",data,16)[0]
    off=32
    signed=False
    for _ in range(count):
        cmd,size=struct.unpack_from("<II",data,off)
        assert size>=8 and off+size<=len(data), ("bad load command",path)
        if cmd==0x1d:
            pos,span=struct.unpack_from("<II",data,off+8)
            assert pos>0 and span>128 and pos+span<=len(data)
            signed=True
        off+=size
    assert signed, ("not signed",path)
    return data

def verify(deb):
    assert deb.is_file()
    assert get(deb,"Package")=="com.chuong.duocar"
    assert get(deb,"Version")=="1.0.4-hl60cl1"
    assert get(deb,"Architecture")=="iphoneos-arm64"
    assert subprocess.run(["dpkg","--compare-versions","1.0.4-hl60cl1",
                           "gt","1.0.4-hl59cl1"]).returncode==0
    info=subprocess.check_output(["dpkg-deb","-f",str(deb)],text=True)
    assert all("dev.bechou.le" not in s for s in info.splitlines()
               if s.startswith(("Depends:","Conflicts:","Replaces:")))
    with tempfile.TemporaryDirectory(prefix="dc60cl-") as tmp:
        root=Path(tmp)/"root"
        subprocess.run(["dpkg-deb","-x",str(deb),str(root)],check=True)
        app=root/"var/jb/Applications/DuoCar.app/DuoCar"
        ext=root/"var/jb/Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.dylib"
        filt=ext.with_suffix(".plist")
        assert app.is_file() and ext.is_file() and filt.is_file()
        bundles=plistlib.loads(filt.read_bytes())["Filter"]["Bundles"]
        assert "com.apple.CarPlayApp" in bundles and "com.apple.springboard" in bundles
        count=0
        for file in root.rglob("*"):
            if not file.is_file():continue
            assert not file.is_symlink(),file
            low=file.relative_to(root).as_posix().lower()
            assert not any(n in low for n in ("dev.bechou.le","/leprefs.bundle/"))
            assert not low.startswith("var/jb/usr/share/le/")
            assert not low.endswith("/library/preferenceloader/preferences/le.plist")
            for vendor in ("lebubble","legooglemaps","legooglerelay","legooglesource",
                           "lewazesource","legofasource","lesupervisor",
                           "leguidancerelay","lesourceshown"):
                assert not low.endswith("/"+vendor+".dylib"),low
            data=file.read_bytes()
            assert data[:4] not in (bytes.fromhex("cafebabe"),bytes.fromhex("bebafeca"))
            if file==app or file.suffix==".dylib":
                signed_arm64(file)
                count+=1
        assert count>=7,("too few signed Mach-O",count)
        # Verify the two distinct payloads, not just package metadata.
        app_data=app.read_bytes()
        all_module_bytes=[
            p.read_bytes() for p in root.rglob("*.dylib") if p.is_file()
        ]
        def present(blob,marker):
            return marker.encode("utf-8") in blob or marker.encode("utf-16le") in blob
        assert present(app_data,"duocarThermalTest37Enabled"), "missing settings switch"
        assert any(present(b,"[hl60-thermal]") for b in all_module_bytes), "missing 37C warning"
        assert any(present(b,"duocarThermalTest37Enabled") for b in all_module_bytes), "missing CarPlay test preference"
        assert any(present(b,"thermaltest37.changed") for b in all_module_bytes), "missing CarPlay notify"
        payload=ext.read_bytes()
        for marker in ("[hl59-layer]","CWTrafficOverlayController",
                       "CWCastBubbleController","showAt:level:",
                       "setFront:forApp:","raiseLauncher",
                       "leTrafficGpsOffsetKph","leBubbleMasterEnabled"):
            assert marker.encode() in payload or marker.encode("utf-16le") in payload,marker
    print("DC60CL_THIN_ARM64_SIGNED_PASS",
          "signed_macho="+str(count),
          "bytes="+str(deb.stat().st_size),
          "sha256="+hashlib.sha256(deb.read_bytes()).hexdigest())

if __name__=="__main__":
    assert len(sys.argv)==2
    verify(Path(sys.argv[1]).resolve())
