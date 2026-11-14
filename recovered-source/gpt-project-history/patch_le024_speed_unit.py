#!/usr/bin/env python3
"""HL54 personal Lề 0.2.4: remove ALL visible 'km/h' literals in the one DEB.

Patches ONLY __TEXT/__cstring ASCII and __TEXT/__ustring UTF-16LE in Le*
Mach-O binaries and LePrefs.bundle, in both arm64 and arm64e slices.
Keeps string lengths and JSON/speed/posted-limit structures unchanged.
Every modified executable is signed AFTER patching; independent final DEB
verification must check both signatures and the absence of units.
Only use this on a verified original Lề 0.2.4 merge, never on arbitrary DEBs.
"""
from pathlib import Path
import argparse
import hashlib
import struct
import subprocess
import tempfile

ASCII=b"km/h"
UTF16="km/h".encode("utf-16le")
FOUR=b"    "
FOUR16="    ".encode("utf-16le")
# Counts per architecture of the original Lề 0.2.4 DEB.
# Tested against both signed FAT slices of the real DuoCar53 payload.
# LeBubble from the unpatched vendor must still have its original ASCII unit.
EXPECTED={
    "LeBubble":(1,4),
    "LeGoogleMaps":(1,3),
    "LeGoogleRelay":(0,3),
    "LeGoogleSource":(0,3),
    "LeGofaSource":(0,3),
    "LeWazeSource":(0,3),
    "LeSupervisor":(0,0),
    "LeGuidanceRelay":(0,0),
    "LeSourceShown":(0,0),
    "LePrefs":(1,12),
}
PATCHED=frozenset(name for name,counts in EXPECTED.items()
                  if sum(counts)>0)

def sh(*args):
    subprocess.run(args,check=True,stdout=subprocess.DEVNULL)
def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def check_fat(contents):
    assert len(contents)>=48,"short FAT header"
    magic,narch=struct.unpack_from(">II",contents,0)
    assert magic==0xcafebabe and narch==2,(hex(magic),narch)
    regions=[]
    for i in range(narch):
        cpu,sub,off,length,align=struct.unpack_from(">IIIII",contents,8+i*20)
        assert cpu==0x0100000c and sub in (0,0x80000002)
        assert off>0 and length>10000 and off+length<=len(contents)
        assert contents[off:off+4]==bytes.fromhex("cffaedfe")
        regions.append((sub,off,length))
    assert len({x[0] for x in regions})==2
    assert regions[0][1]+regions[0][2] <= regions[1][1] or (
           regions[1][1]+regions[1][2] <= regions[0][1])
    return regions

def macho_sections(part):
    ncmds=struct.unpack_from("<I",part,16)[0]
    cursor=32
    sections=[]
    for _ in range(ncmds):
        cmd,size=struct.unpack_from("<II",part,cursor)
        assert size>=8 and cursor+size<=len(part),"invalid Mach-O load command"
        if cmd==0x19: # LC_SEGMENT_64
            count=struct.unpack_from("<I",part,cursor+64)[0]
            entry=cursor+72
            assert entry+count*80<=cursor+size
            for index in range(count):
                s,seg,addr,span,offset,*_=struct.unpack_from(
                    "<16s16sQQIIIIIIII",part,entry+index*80)
                sections.append((offset,offset+span,
                    seg.partition(b"\0")[0].decode("ascii"),
                    s.partition(b"\0")[0].decode("ascii")))
        cursor+=size
    return sections

def patch_units(path,name):
    data=bytearray(path.read_bytes())
    counts=[]
    for arch,start,length in check_fat(data):
        part=bytearray(data[start:start+length])
        sections=macho_sections(part)
        per_kind=[]
        for needle,replacement,section_name in (
            (ASCII,FOUR,"__cstring"),(UTF16,FOUR16,"__ustring")):
            positions=[]
            at=0
            while True:
                at=part.find(needle,at)
                if at<0:break
                owners=[(seg,sec) for lo,hi,seg,sec in sections
                        if lo<=at and at+len(needle)<=hi]
                assert owners==[("__TEXT",section_name)],(
                    name,hex(arch),"unexpected location",hex(at),owners)
                positions.append(at)
                at+=len(needle)
            for index in positions:
                part[index:index+len(needle)]=replacement
            per_kind.append(len(positions))
        assert tuple(per_kind)==EXPECTED[name],(
            name,hex(arch),"vendor literal count changed",per_kind,
            EXPECTED[name])
        assert ASCII not in part and UTF16 not in part,(
            name,hex(arch),"unit leaked after patch")
        data[start:start+length]=part
        counts.append((hex(arch),tuple(per_kind)))
    path.write_bytes(data)
    if name in PATCHED:
        sh("ldid","-S",str(path)) # original fat code signatures now invalid
    signed=path.read_bytes()
    for arch,start,length in check_fat(signed):
        part=signed[start:start+length]
        assert ASCII not in part and UTF16 not in part,(name,hex(arch))
        if name in PATCHED:
            cursor=32
            seen=False
            for _ in range(struct.unpack_from("<I",part,16)[0]):
                cmd,size=struct.unpack_from("<II",part,cursor)
                if cmd==0x1d: # LC_CODE_SIGNATURE
                    offset,span=struct.unpack_from("<II",part,cursor+8)
                    assert span>128 and offset+span<=len(part)
                    seen=True
                cursor+=size
            assert seen,(name,hex(arch),"unsigned after patch")
    return counts

def process(source,target,version):
    assert source.is_file() and not target.exists()
    with tempfile.TemporaryDirectory(prefix="duocar54-all-le-units-") as folder_name:
        folder=Path(folder_name)/"package"
        sh("dpkg-deb","-x",str(source),str(folder))
        sh("dpkg-deb","-e",str(source),str(folder/"DEBIAN"))
        jb=folder/"var/jb"
        libs=jb/"Library/MobileSubstrate/DynamicLibraries"
        summary={}
        for name in EXPECTED:
            path=(jb/"Library/PreferenceBundles/LePrefs.bundle/LePrefs"
                  if name=="LePrefs" else libs/(name+".dylib"))
            assert path.is_file(),path
            summary[name]=patch_units(path,name)
        assert (libs/"LeBubble.plist").is_file()
        for name in ("DuoCarSpeedBubble","OmniCarSpeedBubble"):
            assert not (libs/(name+".dylib")).exists()
            assert not (libs/(name+".plist")).exists()
        for root in (jb/"Applications/DuoCar.app",
                     jb/"Library/PreferenceBundles/DuoCarPrefs.bundle"):
            assert root.is_dir()
            assert not list(root.rglob("*SpeedBubble*"))
        control=folder/"DEBIAN/control"
        lines=[]
        for line in control.read_text().splitlines():
            if line.startswith("Version:"):
                line="Version: "+version
            lines.append(line)
        control.write_text("\n".join(lines)+"\n")
        sh("dpkg-deb","--build","--root-owner-group",str(folder),str(target))
        assert subprocess.check_output(
            ["dpkg-deb","-f",str(target),"Version"],text=True
        ).strip()==version
        print("HL54_ALL_LE_KMH_REMOVED_SIGNED_FAT_PASS",
              summary,"sha256",digest(target),"bytes",target.stat().st_size)
def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--input",type=Path,required=True)
    ap.add_argument("--output",type=Path,required=True)
    ap.add_argument("--version",default="1.0.3-le0247")
    args=ap.parse_args()
    process(args.input,args.output,args.version)
if __name__=="__main__":
    main()
