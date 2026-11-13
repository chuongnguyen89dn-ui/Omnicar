#!/usr/bin/env python3
"""Post-process the *combined* personal DuoCar test DEB:
- remove only the literal "km/h" (not numbers or road-limit metadata)
  used by LeBubble's GPS speed renderer, for BOTH universal slices;
- ad-hoc re-sign the changed LeBubble FAT dylib;
- ensure legacy SpeedBubble payload resources are absent.
Le source and other original vendor dylibs remain untouched.
"""
from pathlib import Path
import argparse
import hashlib
import plistlib
import struct
import subprocess
import tempfile
import shutil

def sh(*args):
    subprocess.run(args,check=True,stdout=subprocess.DEVNULL)
def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def check_fat(contents):
    magic, narch=struct.unpack_from(">II",contents,0)
    assert magic==0xcafebabe and narch==2,(hex(magic),narch)
    regions=[]
    for k in range(narch):
        cpu,sub,start,length,align=struct.unpack_from(">IIIII",contents,8+k*20)
        assert cpu==0x0100000c and sub in (0,0x80000002)
        assert start+length<=len(contents) and length>100_000
        regions.append((sub,start,length))
    assert len({s for s,_,__ in regions})==2
    return regions

def patch_one(file):
    contents=bytearray(file.read_bytes())
    patched=[]
    for subtype,start,length in check_fat(contents):
        part=contents[start:start+length]
        matches=part.count(b"km/h\x00")
        assert matches==1,(subtype,"expected one speed-unit literal",matches)
        location=part.index(b"km/h\x00")
        contents[start+location:start+location+4]=b"    "
        assert contents[start:start+length].count(b"km/h\x00")==0
        patched.append((subtype,location))
    file.write_bytes(contents)
    # The modified library must be signed AFTER modification; not before.
    sh("ldid","-S",str(file))
    signed=file.read_bytes()
    assert signed[:4]==bytes.fromhex("cafebabe")
    assert len(check_fat(signed))==2
    for subtype,start,length in check_fat(signed):
        assert signed[start:start+length].count(b"km/h\x00")==0
    return patched

def process(source,target,version):
    assert source.is_file() and not target.exists()
    with tempfile.TemporaryDirectory(prefix="duocar49-units-") as d:
        folder=Path(d)/"package"
        sh("dpkg-deb","-x",str(source),str(folder))
        sh("dpkg-deb","-e",str(source),str(folder/"DEBIAN"))
        libs=folder/"var/jb/Library/MobileSubstrate/DynamicLibraries"
        bubble=libs/"LeBubble.dylib"
        assert bubble.is_file() and (libs/"LeBubble.plist").is_file()
        signatures=patch_one(bubble)
        for old in ("DuoCarSpeedBubble","OmniCarSpeedBubble"):
            assert not (libs/(old+".dylib")).exists()
            assert not (libs/(old+".plist")).exists()
        for root in (folder/"var/jb/Applications/DuoCar.app",
                     folder/"var/jb/Library/PreferenceBundles/DuoCarPrefs.bundle"):
            assert root.is_dir()
            for item in root.rglob("*SpeedBubble*"):
                raise AssertionError(f"Old SpeedBubble resource leaked: {item}")
        control=folder/"DEBIAN/control"
        data=control.read_text()
        result=[]
        for line in data.splitlines():
            if line.startswith("Version:"):
                line=f"Version: {version}"
            result.append(line)
        control.write_text("\n".join(result)+"\n")
        sh("dpkg-deb","--build","--root-owner-group",str(folder),str(target))
        assert subprocess.check_output(["dpkg-deb","-f",str(target),"Version"],
                                       text=True).strip()==version
        print("DUOCAR49_LE_SPEED_UNIT_PATCH_PASS",signatures,
              "final_sha256",digest(target),"bytes",target.stat().st_size)

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--input",type=Path,required=True)
    ap.add_argument("--output",type=Path,required=True)
    ap.add_argument("--version",default="1.0.3-le0242")
    args=ap.parse_args()
    process(args.input,args.output,args.version)
if __name__=="__main__":main()
