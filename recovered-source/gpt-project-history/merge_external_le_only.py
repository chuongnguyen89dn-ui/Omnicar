#!/usr/bin/env python3
"""HL58 packer: ONLY a signed DuoCar base + signed DuoCar compatibility shim.

No Le 0.2.4 vendor binaries/fonts/LePrefs are redistributed. This package
can be installed alone; installing the independent dev.bechou.le_0.2.4 DEB
later provides the actual speed bubble. Neither package should own the
other's files. A package upgrade from the old bundled DC57 naturally removes
its previously owned vendor files; no script deletes user config/state.
"""
from pathlib import Path
import argparse
import hashlib
import os
import shutil
import subprocess
import tempfile

EXPECTED_EXTENSION={
    "var/jb/Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.dylib",
    "var/jb/Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.plist",
}
VENDOR_MODULES={
    "LeBubble","LeGoogleMaps","LeGoogleRelay","LeGoogleSource","LeWazeSource",
    "LeGofaSource","LeSupervisor","LeGuidanceRelay","LeSourceShown",
}

def sh(*argv):
    subprocess.run([str(x) for x in argv],check=True,stdout=subprocess.DEVNULL)

def field(deb,key):
    return subprocess.check_output(
        ["dpkg-deb","-f",str(deb),key],text=True).strip()

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def files(folder):
    result=[]
    for root,dirs,names in os.walk(folder,followlinks=False):
        for name in dirs+names:
            file=Path(root)/name
            if file.is_symlink():raise RuntimeError("Symlink unsupported: "+str(file))
            if file.is_file():result.append(file.relative_to(folder).as_posix())
    return sorted(result)

def no_vendor(path):
    s=path.lower()
    if s.startswith("var/jb/usr/share/le/"):
        return False
    if "/leprefs.bundle/" in s or s.endswith("/leprefs.bundle"):
        return False
    if s.endswith("library/preferenceloader/preferences/le.plist"):
        return False
    if "dev.bechou.le" in s:
        return False
    for name in VENDOR_MODULES:
        if s.endswith(("/"+name+".dylib").lower()) or \
           s.endswith(("/"+name+".plist").lower()):
            return False
    return True

def patch_control(control,version,installed_bytes):
    old=control.read_text().splitlines()
    result=[]
    in_old_speed_description=False
    for line in old:
        # Old OmniCar control advertised a built-in 9-style traffic renderer;
        # HL58 ships NONE of that. Preserve other feature descriptions.
        if line==" SPEED BUBBLE":
            in_old_speed_description=True
            result.extend([
                " EXTERNAL LE SPEED BUBBLE (OPTIONAL)",
                "  - Lề 0.2.4 is installed independently; no vendor code shipped",
                "  - DuoCar offers GPS +/-10 and show/hide switch only",
            ])
            continue
        if in_old_speed_description:
            if line==" .":
                in_old_speed_description=False
                result.append(line)
            continue
        name,separator,val=line.partition(":")
        if separator and not line[0].isspace() and name in (
             "Version","Installed-Size","Conflicts","Replaces","Depends"):
            if name in ("Conflicts","Replaces"):
                entries=[entry.strip() for entry in val.split(",") if entry.strip()]
                entries=[entry for entry in entries
                         if entry.split(" ",1)[0]!="dev.bechou.le"]
                if entries:result.append(name+": "+", ".join(entries))
            elif name=="Depends":
                items=[x.strip() for x in val.split(",") if x.strip()]
                items=[x for x in items if x.split(" ",1)[0]!="dev.bechou.le"]
                if items:result.append(name+": "+", ".join(items))
            continue
        result.append(line)
    assert "Package: com.chuong.duocar" in result
    assert "Architecture: iphoneos-arm64" in result
    result.append("Version: "+version)
    result.append("Installed-Size: "+str((installed_bytes+1023)//1024))
    control.write_text("\n".join(result)+"\n")
    for line in result:
        if line.startswith(("Conflicts:","Replaces:","Depends:")):
            assert "dev.bechou.le" not in line

def merge(base,extension,output,version):
    assert version=="1.0.4-hl58",version
    assert output!=base and output!=extension and not output.exists()
    for deb in (base,extension):
        assert deb.is_file() and deb.stat().st_size>100
        assert field(deb,"Architecture")=="iphoneos-arm64"
    assert field(base,"Package")=="com.chuong.duocar"
    assert field(extension,"Package")=="com.chuong.duocar.leextension"
    with tempfile.TemporaryDirectory(prefix="dc58-external-vendor-") as tmp:
        baseFolder=Path(tmp)/"base"
        extFolder=Path(tmp)/"extension"
        checkFolder=Path(tmp)/"check"
        sh("dpkg-deb","-x",base,baseFolder)
        sh("dpkg-deb","-e",base,baseFolder/"DEBIAN")
        sh("dpkg-deb","-x",extension,extFolder)
        original=files(baseFolder)
        addon=files(extFolder)
        assert set(addon)==EXPECTED_EXTENSION,(
            "Unexpected extension payload",addon)
        assert all(no_vendor(x) for x in original),(
            "Vendor Le still in original DuoCar base",
            [x for x in original if not no_vendor(x)])
        for name in EXPECTED_EXTENSION:
            target=baseFolder/name
            assert not target.exists(),("Duplicate signed path",name)
            target.parent.mkdir(parents=True,exist_ok=True)
            shutil.copy2(extFolder/name,target)
        app=baseFolder/"var/jb/Applications/DuoCar.app/DuoCar"
        shim=baseFolder/"var/jb/Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.dylib"
        assert app.is_file() and shim.is_file()
        assert b"DuoCar" in app.read_bytes()
        # 2 methods in shim; original Le is dynamically loaded by name
        # if independent dev.bechou.le is installed on device.
        data=shim.read_bytes()
        assert b"CWTrafficBubbleContent" in data or \
               "CWTrafficBubbleContent".encode("utf-16le") in data
        total=sum(p.stat().st_size for p in baseFolder.rglob("*")
                  if p.is_file())
        patch_control(baseFolder/"DEBIAN/control",version,total)
        output.parent.mkdir(parents=True,exist_ok=True)
        sh("dpkg-deb","--build","--root-owner-group",baseFolder,output)
        sh("dpkg-deb","-x",output,checkFolder)
        actual=files(checkFolder)
        # dpkg-deb -e put DEBIAN/control under the staging root, while
        # dpkg-deb -x extracts DATA only. Control is verified separately.
        original_data={path for path in original if not path.startswith("DEBIAN/")}
        expected=original_data|EXPECTED_EXTENSION
        assert set(actual)==expected,(
            "Output has missing or unexpected DATA paths",
            sorted(set(actual)^expected))
        assert all(no_vendor(x) for x in actual),(
            "VENDOR_PAYLOAD_LEAKED",[x for x in actual if not no_vendor(x)])
        for name in EXPECTED_EXTENSION:
            assert sha(checkFolder/name)==sha(extFolder/name),(
                "signed shim changed",name)
        assert field(output,"Version")==version
        controlText=subprocess.check_output(
            ["dpkg-deb","-f",str(output)],text=True)
        for line in controlText.splitlines():
            if line.startswith(("Conflicts:","Replaces:","Depends:")):
                assert "dev.bechou.le" not in line
        assert subprocess.run(["dpkg","--compare-versions",version,
                               "gt","1.0.3-le0249"]).returncode==0
        print("HL58_VENDOR_DETACHED_PACKET_PASS",
             "sha256="+sha(output),"bytes="+str(output.stat().st_size),
             "owned_paths="+str(len(actual)),"vendor_paths=0",
             "optional_lè_separate=YES")

def main():
    cli=argparse.ArgumentParser()
    cli.add_argument("--duocar",required=True,type=Path)
    cli.add_argument("--extension",required=True,type=Path)
    cli.add_argument("--output",required=True,type=Path)
    cli.add_argument("--version",default="1.0.4-hl58")
    a=cli.parse_args()
    merge(a.duocar.resolve(),a.extension.resolve(),a.output.resolve(),
          a.version)
if __name__=="__main__":
    main()
