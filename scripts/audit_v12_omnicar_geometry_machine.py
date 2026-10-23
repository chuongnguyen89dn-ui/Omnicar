#!/usr/bin/env python3
"""Immutable DuoFace Native12 ↔ original OmniCar AppBridge ARM64 geometry audit.

Reads checked original DEB packages. NEVER patches binaries or imports DuoFace into OmniCar.
Report: complete method instruction listings with focused arithmetic / branch / call indexes.
Run:
 python3 scripts/audit_v12_omnicar_geometry_machine.py \
   --duoface duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb \
   --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
   --output audit/native12_vs_omnicar_yt_scene_arm64_20261023.json
Requires: python3, dpkg-deb, capstone==5.0.7. Device test is OUT OF SCOPE.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import struct
import subprocess
import tarfile
from pathlib import Path

DUO_DEB_SHA = "8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a"
DUO_DYLIB_SHA = "bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce"
OMNI_DEB_SHA = "d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
OMNI_DYLIB_SHA = "d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79"
# Exclusive ends: next verified IMP or bounded original method window.
DUO = {
 "CBBridgedUIAppView.calculateNativeSizeForSlotRect:": (0xacc28,0xacc6c),
 "CBBridgedUIAppView.updateLayout": (0xacc6c,0xad5bc),
 "CBBridgedUIAppView.updateSceneSettingsFrame": (0xad5bc,0xade4c),
 "CBBridgedUIAppView.updateSceneFrame": (0xade4c,0xade58),
 "CBBridgedUIAppView.refreshSceneLayout": (0xade58,0xadf30),
 "CBBridgeManager.renderSizeForBundleID:": (0x24c920,0x24d118),
 "CBBridgedSplitApp.updateScale:forSlot:": (0x108dd8,0x108f28),
}
OMNI = {
 "ABHost.zoom": (0xae20,0xae94),
 "ABHost.layoutPane:": (0xec80,0xf0a0),
 "ABHost.effectiveOrientation:": (0xf364,0xf54c),
 "ABHost.setFrame:forApp:live:handle:passInsets:": (0xfe68,0x101b0),
}
# ARM64 floating instructions, scalar integer arithmetic, and branching are
# deliberately indexed, NOT decoded into an invented UI geometry formula.
FLOAT_PREFIXES=("fadd","fsub","fmul","fdiv","fneg","fabs","fmax","fmin","fcmp","fcsel","fcvt","frint","scvtf","ucvtf","fmadd","fmsub")
GEOM_PREFIXES=("add","sub","mul","madd","msub","sdiv","udiv","lsl","lsr","asr","cmp","csel")
BRANCH_PREFIXES=("b.","cbz","cbnz","tbz","tbnz","bl","blr","ret")

def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def checked_payload(deb: Path, expected_deb: str, suffix: str, expected_blob: str) -> bytes:
    source = deb.read_bytes()
    actual = sha256(source)
    if actual != expected_deb:
        raise ValueError(f"REFUSE_SOURCE_SHA {deb}: {actual} != {expected_deb}")
    proc = subprocess.Popen(["dpkg-deb","--fsys-tarfile",str(deb.resolve())],stdout=subprocess.PIPE)
    found = []
    try:
        assert proc.stdout is not None
        with tarfile.open(fileobj=proc.stdout, mode="r|") as archive:
            for info in archive:
                if info.name.endswith(suffix) and info.isfile():
                    stream=archive.extractfile(info)
                    if stream is None:
                        raise RuntimeError("DEB_MEMBER_UNREADABLE")
                    found.append(stream.read())
        if proc.wait()!=0:
            raise RuntimeError("DPKG_DEB_TAR_FAILURE")
    finally:
        if proc.poll() is None:
            proc.kill()
            proc.wait()
    if len(found)!=1:
        raise ValueError(f"EXPECTED_ONE_DYLIB {suffix}, found {len(found)}")
    if sha256(found[0])!=expected_blob:
        raise ValueError(f"REFUSE_DYLIB_SHA {suffix}: {sha256(found[0])}")
    return found[0]

def arm64_slice(binary: bytes) -> bytes:
    if len(binary)<8 or struct.unpack_from(">I",binary,0)[0]!=0xcafebabe:
        raise ValueError("EXPECTED_VERIFIED_FAT_MACHO")
    n=struct.unpack_from(">I",binary,4)[0]
    if not 1<=n<=8: raise ValueError("BAD_FAT_HEADER_COUNT")
    for i in range(n):
        cpu,sub,start,size,_=struct.unpack_from(">IIIII",binary,8+20*i)
        if cpu==0x0100000c and sub==0:
            if start+size>len(binary): raise ValueError("BAD_ARM64_SLICE_RANGE")
            return binary[start:start+size]
    raise ValueError("ARM64_SLICE_NOT_FOUND")

def method_windows(binary: bytes, methods: dict) -> dict:
    from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM
    arm=arm64_slice(binary)
    dis=Cs(CS_ARCH_ARM64,CS_MODE_ARM)
    report={}
    for method,(start,end) in methods.items():
        if start<0 or end>len(arm) or start>=end or (end-start)%4:
            raise ValueError(f"OUT_OF_RANGE_OR_UNALIGNED {method}")
        instructions=list(dis.disasm(arm[start:end],start))
        if len(instructions)!=(end-start)//4 or instructions[0].address!=start:
            raise RuntimeError(f"UNDECODED_MACHINE_CODE {method}")
        allins=[{"pc":f"0x{x.address:x}","asm":f"{x.mnemonic} {x.op_str}".strip()} for x in instructions]
        fp=[x for x in allins if x["asm"].split()[0].startswith(FLOAT_PREFIXES)]
        geom=[x for x in allins if x["asm"].split()[0].startswith(GEOM_PREFIXES)]
        branches=[x for x in allins if x["asm"].split()[0].startswith(BRANCH_PREFIXES)]
        report[method]={
            "start":f"0x{start:x}","end_exclusive":f"0x{end:x}",
            "instruction_count":len(allins),"fp_arithmetic":fp,
            "integer_geometry_candidates":geom,"branches_and_calls":branches,
            "full_disassembly":allins,
            "caution":"Static instructions only; no validated runtime YouTube frame, scene orientation, native size or user-event path."
        }
    return report

def audit(duo:Path, omni:Path) -> dict:
    if not duo.is_file() or not omni.is_file():
        raise FileNotFoundError("EXPECTED_ORIGINAL_REPO_DEB_MISSING")
    duo_binary=checked_payload(duo,DUO_DEB_SHA,"/DuoFaceDashboard.dylib",DUO_DYLIB_SHA)
    omni_binary=checked_payload(omni,OMNI_DEB_SHA,"/OmniCarAppBridge.dylib",OMNI_DYLIB_SHA)
    r={
        "status":"READ_ONLY_NATIVE12_OMNIBRIDGE_ARM64_DISASSEMBLY_DEVICE_UNTESTED",
        "source_sha256":{"duoface_deb":DUO_DEB_SHA,"duoface_dashboard":DUO_DYLIB_SHA,
                         "omnicar_deb":OMNI_DEB_SHA,"omnicar_appbridge":OMNI_DYLIB_SHA},
        "duoface":method_windows(duo_binary,DUO),
        "omnicar":method_windows(omni_binary,OMNI),
        "limits":["DuoFace scene equations not inferred merely from method name",
                  "No measured YouTube app view/reference size on device",
                  "No patch, no packaging, no Sileo publication, no runtime claim"]
    }
    return r

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--duoface",type=Path,required=True)
    p.add_argument("--omnicar",type=Path,required=True)
    p.add_argument("--output",type=Path,required=True)
    x=p.parse_args()
    data=audit(x.duoface,x.omnicar)
    x.output.parent.mkdir(parents=True,exist_ok=True)
    x.output.write_text(json.dumps(data,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    for owner in ("duoface","omnicar"):
        for name,record in data[owner].items():
            print(f"MACHINE_GEOMETRY_METHOD owner={owner} method={name} "
                  f"arm64_ins={record['instruction_count']} fp={len(record['fp_arithmetic'])} "
                  f"intgeom={len(record['integer_geometry_candidates'])} "
                  f"branch={len(record['branches_and_calls'])}")
            # One compact evidence line per floating-point instruction.
            for event in record["fp_arithmetic"][:24]:
                print(f"  FP {owner} {name} {event['pc']} {event['asm']}")
    print("NATIVE12_OMNICAR_ORIGINAL_SHA_PINNED_MACHINE_CODE_AUDIT_PASS__DEVICE_UNTESTED")

if __name__=="__main__":
    main()
