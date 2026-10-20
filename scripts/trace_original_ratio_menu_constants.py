#!/usr/bin/env python3
"""Read-only original OmniCar 1.0.3 ARM64 ratio-menu callsite report.

Run only with the SHA256-exact original 1.0.3 DEB. No package rebuild,
patching, app launches or device actions. Outputs caller register loads,
nearby instruction context and Objective-C selector when a call uses the
ordinary ARM64 objc_stub ADRP/LDR pattern.

Requires: dpkg-deb, llvm-objdump, Python stdlib.
Usage: python3 scripts/trace_original_ratio_menu_constants.py ORIGINAL.deb > report.json
"""
from __future__ import annotations

import hashlib
import json
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

SHA256 = "d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
LIB = "var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib"
LOADS = {0x2F858:22, 0x2FA14:21, 0x2FAC0:21, 0x2FB34:12, 0x2FB38:1, 0x2FB3C:18}
CALLS = {0x2F864:0x46A64, 0x2FB44:0x5AE20}


def fat_arm64(fat: bytes) -> bytes:
    if len(fat) < 8 or struct.unpack_from(">I",fat)[0] != 0xCAFEBABE:
        raise ValueError("expected original 32-bit-header FAT Mach-O")
    count = struct.unpack_from(">I", fat, 4)[0]
    for i in range(count):
        cpu, subtype, off, length, _align = struct.unpack_from(">IIIII", fat, 8+i*20)
        if cpu == 0x0100000C and subtype == 0:
            result = fat[off:off+length]
            if len(result)!=length or struct.unpack_from("<I",result)[0]!=0xFEEDFACF:
                raise ValueError("invalid ARM64 Mach-O slice")
            return result
    raise ValueError("ARM64 slice not found")


def macho_sections(buf: bytes) -> list[dict]:
    if len(buf)<32 or struct.unpack_from("<I",buf)[0]!=0xFEEDFACF:
        raise ValueError("invalid Mach-O")
    _magic,_cpu,_subtype,_filetype,ncmds,_szcmds,_flags,_reserved=struct.unpack_from("<IiiIIIII",buf)
    pos=32
    result=[]
    for _ in range(ncmds):
        cmd,cmdsize=struct.unpack_from("<II",buf,pos)
        if cmdsize<8 or pos+cmdsize>len(buf): raise ValueError("invalid load command")
        if cmd==0x19: # LC_SEGMENT_64
            nsects=struct.unpack_from("<I",buf,pos+64)[0]
            for j in range(nsects):
                k=pos+72+j*80
                if k+80>pos+cmdsize: raise ValueError("invalid section table")
                name=buf[k:k+16].split(b"\0",1)[0].decode("ascii","replace")
                seg=buf[k+16:k+32].split(b"\0",1)[0].decode("ascii","replace")
                addr,size,off=struct.unpack_from("<QQI",buf,k+32)
                result.append({"name":name,"segment":seg,"addr":addr,"size":size,"offset":off})
        pos+=cmdsize
    return result


def addr_to_offset(sections: list[dict],addr:int) -> int|None:
    for s in sections:
        if s["addr"]<=addr<s["addr"]+s["size"]:
            return s["offset"]+addr-s["addr"]
    return None


def sxt(v: int, bits: int) -> int:
    return v-(1<<bits) if v & (1<<(bits-1)) else v


def resolve_objc_selector(buf: bytes, sections:list[dict],target:int) -> str|None:
    """Resolve a simple objc_stub ADRP X1; LDR X1,[X1,#imm] selector ref.

    Unrecognized stub arrangements are explicitly left UNKNOWN; never infer
    a selector from an unrelated string or a nearby function address.
    """
    sec=next((s for s in sections if s["name"]=="__objc_stubs" and s["addr"]<=target<s["addr"]+s["size"]),None)
    if sec is None: return None
    k=addr_to_offset(sections,target)
    if k is None:return None
    pc=target
    base=None
    for q in range(0,20,4):
        if k+q+4>len(buf): break
        insn=struct.unpack_from("<I",buf,k+q)[0]
        rd=insn&31
        if (insn & 0x9F000000)==0x90000000 and rd==1:
            immhi=(insn>>5)&0x7FFFF
            immlo=(insn>>29)&3
            base=((pc+q)&~0xFFF)+sxt((immhi<<2)|immlo,21)*4096
        elif base is not None and (insn & 0xFFC00000)==0xF9400000:
            rt=insn&31
            rn=(insn>>5)&31
            if rn==1 and rt==1:
                selref=base+((insn>>10)&0xFFF)*8
                p=addr_to_offset(sections,selref)
                if p is None or p+8>len(buf):return None
                string_vm=struct.unpack_from("<Q",buf,p)[0] & ((1<<48)-1)
                c=addr_to_offset(sections,string_vm)
                if c is None or c>=len(buf): return None
                end=buf.find(b"\0",c,min(c+256,len(buf)))
                if end<0:return None
                return buf[c:end].decode("utf-8","replace")
    return None


def objc_methods(buf:bytes)->dict:
    # Reuse the original hash-pinned ARM64 relative ObjC method parser.
    from audit_original_edge_drag import parse
    return parse(buf)


def report(deb:Path)->dict:
    actual=hashlib.sha256(deb.read_bytes()).hexdigest()
    if actual!=SHA256:raise ValueError(f"wrong original DEB sha256: {actual}")
    with tempfile.TemporaryDirectory() as td:
        subprocess.run(["dpkg-deb","-x",str(deb),td],check=True)
        binary=Path(td)/LIB
        arm=fat_arm64(binary.read_bytes())
        sections=macho_sections(arm)
        methods=objc_methods(arm)
        assert methods.get(("SCPCarSplit","showRatioMenuForDivider:"))==0x2F614
        asm=subprocess.run(["llvm-objdump","--macho","--arch=arm64","--disassemble",str(binary)],
                           check=True,capture_output=True,text=True).stdout
        instructions={int(m.group(1),16):m.group(2).strip() for line in asm.splitlines()
          if (m:=re.match(r"^\s*([0-9a-fA-F]+):\s*(.*)$",line))}
        method_by_pc={pc:f"{owner}.{sel}" for (owner,sel),pc in methods.items()}
        targets=[]
        for callsite,expected in CALLS.items():
            inst=instructions.get(callsite,"")
            m=re.search(r"\bbl\s+0x([\da-fA-F]+)",inst)
            if m is None or int(m.group(1),16)!=expected:
                raise ValueError(f"unexpected branch at {callsite:#x}: {inst}")
            targets.append({"callsite":hex(callsite),"instruction":inst,"target":hex(expected),
                            "exact_objc_method":method_by_pc.get(expected),
                            "objc_selector_if_simple_stub":resolve_objc_selector(arm,sections,expected),
                            "target_section":next((f'{s["segment"]},{s["name"]}' for s in sections if s["addr"]<=expected<s["addr"]+s["size"]),None)})
        constants=[]
        for pc,val in LOADS.items():
            inst=instructions.get(pc,"")
            if not re.search(r"\b(fmov|ldr|mov)\b",inst):
                raise ValueError(f"expected numeric register load at {pc:#x}: {inst}")
            constants.append({"address":hex(pc),"expected_value_from_old_audit":val,"instruction":inst,
                              "context":[{"address":hex(k),"instruction":instructions[k]}
                                for k in range(pc-24,pc+56,4) if k in instructions]})
        return {"source_sha256":actual,"method":"SCPCarSplit.showRatioMenuForDivider:",
                "method_start":hex(methods[("SCPCarSplit","showRatioMenuForDivider:")]),
                "constants":constants,"known_branches":targets,"caution":"A load by itself does not prove icon or button sizing. Check dataflow and property setter.",
                "read_only":True,"packaged":False,"device_tested":False}


if __name__=="__main__":
    if len(sys.argv)!=2:raise SystemExit("usage: python3 scripts/trace_original_ratio_menu_constants.py ORIGINAL.deb")
    print(json.dumps(report(Path(sys.argv[1])),indent=2,ensure_ascii=False))
