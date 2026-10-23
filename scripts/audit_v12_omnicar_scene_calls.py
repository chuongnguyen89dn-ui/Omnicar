#!/usr/bin/env python3
"""Read-only ObjC callsite map: SHA-pinned DuoFace Native12 vs original OmniCar.

Builds on audit_v12_omnicar_geometry_machine.py, preserving its exact DEB/dylib
SHA checks. Maps ARM64 BL targets via Mach-O indirect symbol tables and decodes
nearby x1 ObjC selector references where possible. Static evidence only.
Run:
 python3 scripts/audit_v12_omnicar_scene_calls.py \
   --duoface duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb \
   --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
   --output audit/native12_vs_omnicar_scene_selector_calls_20261023.json
Requires dpkg-deb and capstone==5.0.7. No hooking, patching or deployment.
"""
from __future__ import annotations
import argparse
import json
import struct
from pathlib import Path
from collections import Counter
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM
from capstone.arm64 import ARM64_OP_IMM, ARM64_OP_MEM, ARM64_OP_REG
from audit_v12_omnicar_geometry_machine import (
    checked_payload, arm64_slice, DUO, OMNI,
    DUO_DEB_SHA, DUO_DYLIB_SHA, OMNI_DEB_SHA, OMNI_DYLIB_SHA,
)

FOCUS = ("scene", "frame", "reference", "size", "bounds", "layout",
         "scale", "orientation", "transform", "host", "window",
         "update", "setcenter", "touch", "render")

def sections_and_stubs(arm: bytes) -> tuple[dict, dict]:
    """Decode section metadata and the LC_DYSYMTAB indirect symbol stub table.

    This audit requires identity __TEXT VMaddr/fileoff mapping, verified below.
    An unresolvable imported call is preserved as a numeric address, not guessed.
    """
    if len(arm)<32 or struct.unpack_from("<I",arm,0)[0]!=0xfeedfacf:
        raise ValueError("EXPECTED_MACHO_64")
    ncmd=struct.unpack_from("<I",arm,16)[0]
    if not 1<=ncmd<=200: raise ValueError("INVALID_MACHO_COMMANDS")
    sec={}; symoff=nsyms=stroff=indirectoff=None; off=32
    for _ in range(ncmd):
        if off+8>len(arm): raise ValueError("MACHO_TRUNCATED_CMDS")
        cmd,cmdsize=struct.unpack_from("<II",arm,off)
        if cmdsize<8 or off+cmdsize>len(arm): raise ValueError("MACHO_BAD_COMMAND_SIZE")
        if cmd==0x19:
            vmaddr,vmsize,fileoff,filesize=struct.unpack_from("<QQQQ",arm,off+24)
            if vmaddr!=fileoff: raise ValueError("UNSUPPORTED_NONIDENTITY_VM_FILE_MAPPING")
            nsect=struct.unpack_from("<I",arm,off+64)[0]
            for i in range(nsect):
                e=off+72+80*i
                if e+80>off+cmdsize: raise ValueError("MACHO_SECTION_OUT_OF_CMD")
                sname=arm[e:e+16].split(b"\0")[0].decode("ascii","replace")
                addr,size=struct.unpack_from("<QQ",arm,e+32)
                flags=struct.unpack_from("<I",arm,e+64)[0]
                reserved1,reserved2=struct.unpack_from("<II",arm,e+68)
                sec[sname]={"start":addr,"end":addr+size,"type":flags&0xff,
                            "reserved1":reserved1,"reserved2":reserved2}
        elif cmd==0x2:
            symoff,nsyms,stroff,_=struct.unpack_from("<IIII",arm,off+8)
        elif cmd==0xb:
            indirectoff=struct.unpack_from("<I",arm,off+56)[0]
        off+=cmdsize
    if "__text" not in sec: raise ValueError("MACHO_TEXT_SECTION_MISSING")
    imports={}
    if None not in (symoff,nsyms,stroff,indirectoff):
        for sname,s in sec.items():
            if s["type"]!=8: continue # S_SYMBOL_STUBS
            stride=s["reserved2"]
            if not 4<=stride<=64: continue
            for j in range((s["end"]-s["start"])//stride):
                indirect_pc=indirectoff+4*(s["reserved1"]+j)
                if indirect_pc+4>len(arm): continue
                n=struct.unpack_from("<I",arm,indirect_pc)[0]
                if n>=nsyms or n&0xc0000000: continue
                symbol_pc=symoff+16*n
                if symbol_pc+16>len(arm): continue
                stridx=struct.unpack_from("<I",arm,symbol_pc)[0]
                pos=stroff+stridx
                if pos>=len(arm): continue
                end=arm.find(b"\0",pos,min(len(arm),pos+240))
                if end<pos: continue
                imports[s["start"]+j*stride]=arm[pos:end].decode("ascii","replace")
    return sec,imports

def section_for(sec:dict, pc:int) -> str:
    for name, item in sec.items():
        if item["start"]<=pc<item["end"]:return name
    return "other"

def selector_pointer(arm:bytes, sec:dict, selref:int) -> str|None:
    item=sec.get("__objc_selrefs")
    if not item or not item["start"]<=selref<item["end"] or selref+8>len(arm):
        return None
    p=struct.unpack_from("<Q",arm,selref)[0]
    if p>=len(arm):p&=(1<<48)-1
    allowed=("__objc_methname","__cstring")
    if not any(sec.get(t,{}).get("start",1)>0 and
               sec[t]["start"]<=p<sec[t]["end"] for t in allowed):
        return None
    end=arm.find(b"\0",p,min(len(arm),p+180))
    if end<=p:return None
    name=arm[p:end].decode("ascii","replace")
    return name if all(32<=ord(c)<127 for c in name) else None

def nearby_selref(arm:bytes,sec:dict, instructions:list, index:int) -> tuple[str|None,str|None]:
    """Straight-line nearby ADRP + LDR x1, no intervening call or branch.

    The result is an x1 callsite candidate, not proof of actual runtime path.
    """
    begin=max(0,index-18)
    for j in range(index-1,begin-1,-1):
        if instructions[j].mnemonic in ("bl","blr","ret","b","br") or \
           instructions[j].mnemonic.startswith(("b.","cbz","cbnz","tbz","tbnz")):
            begin=j+1;break
    candidates=[]
    for j in range(begin,index):
        ins=instructions[j]
        if ins.mnemonic not in ("ldr","ldur") or len(ins.operands)<2:continue
        a,b=ins.operands[:2]
        if a.type!=ARM64_OP_REG or ins.reg_name(a.reg)!="x1" or b.type!=ARM64_OP_MEM:
            continue
        base=ins.reg_name(b.mem.base)
        for k in range(j-1,begin-1,-1):
            prev=instructions[k]
            if prev.mnemonic=="adrp" and len(prev.operands)>1 and \
               prev.operands[0].type==ARM64_OP_REG and \
               prev.reg_name(prev.operands[0].reg)==base and \
               prev.operands[1].type==ARM64_OP_IMM:
                pc=prev.operands[1].imm+b.mem.disp
                name=selector_pointer(arm,sec,pc)
                if name:candidates.append((j,name,hex(pc)))
                break
    return (candidates[-1][1],candidates[-1][2]) if candidates else (None,None)

def audit_binary(arm:bytes,methods:dict) -> dict:
    sec,imports=sections_and_stubs(arm)
    dis=Cs(CS_ARCH_ARM64,CS_MODE_ARM);dis.detail=True
    result={}
    for name,(start,end) in methods.items():
        instructions=list(dis.disasm(arm[start:end],start))
        if len(instructions)!=(end-start)//4:
            raise RuntimeError("METHOD_DISASSEMBLY_INCOMPLETE "+name)
        calls=[]
        for i,ins in enumerate(instructions):
            if ins.mnemonic not in ("bl","blr"):continue
            target=(ins.operands[0].imm if ins.operands and ins.operands[0].type==ARM64_OP_IMM else None)
            imp=imports.get(target) if target is not None else None
            target_section=section_for(sec,target) if target is not None else "indirect-register"
            inline_selector,selref=nearby_selref(arm,sec,instructions,i)
            stub_selector=None
            if target is not None and target_section=="__objc_stubs":
                small=list(dis.disasm(arm[target:min(target+32,len(arm))],target))
                stub_selector,_=nearby_selref(arm,sec,small,len(small))
            selector=stub_selector or inline_selector
            kind=("objc_stub_selector" if stub_selector else
                  "inline_x1_selector_candidate" if inline_selector else
                  "imported_symbol" if imp else "unresolved")
            relevant=bool(selector and any(x in selector.lower() for x in FOCUS))
            context=[{"pc":hex(v.address),"asm":(v.mnemonic+" "+v.op_str).strip()}
                     for v in instructions[max(0,i-5):i+1]]
            calls.append({"pc":hex(ins.address),"target":hex(target) if target is not None else None,
                          "target_section":target_section,"import":imp,"selector":selector,
                          "selref":selref,"evidence_kind":kind,
                          "scene_relevant":relevant,"preceding_instructions":context})
        counts=Counter(c["selector"] for c in calls if c["selector"])
        result[name]={"range":[hex(start),hex(end)],"call_count":len(calls),
                      "identified_selector_count":sum(counts.values()),
                      "selectors_by_frequency":dict(counts.most_common()),
                      "scene_related_calls":[c for c in calls if c["scene_relevant"]],
                      "all_calls":calls}
    return {"methods":result,"imports_decoded":len(imports),
            "sections_present":sorted(sec),
            "note":"Static x1 selector candidates may not be live runtime send targets; no scene values or device observation."}

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--duoface",type=Path,required=True)
    p.add_argument("--omnicar",type=Path,required=True)
    p.add_argument("--output",type=Path,required=True)
    a=p.parse_args()
    d=checked_payload(a.duoface,DUO_DEB_SHA,"/DuoFaceDashboard.dylib",DUO_DYLIB_SHA)
    o=checked_payload(a.omnicar,OMNI_DEB_SHA,"/OmniCarAppBridge.dylib",OMNI_DYLIB_SHA)
    duo=audit_binary(arm64_slice(d),DUO)
    omni=audit_binary(arm64_slice(o),OMNI)
    report={"status":"STATIC_SHA_PINNED_OBJC_CALLSITE_EVIDENCE_DEVICE_UNTESTED",
            "input_sha256":{"duoface":DUO_DEB_SHA,"omnicar":OMNI_DEB_SHA},
            "duoface":duo,"omnicar":omni,
            "limitations":["Read-only machine code; not proof YouTube executes a path.",
                           "Unresolved selector/import remains unresolved, not guessed.",
                           "No QA12 change, DEB build, Sileo publish, or CarPlay run."]}
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    for owner,group in (("duoface",duo),("omnicar",omni)):
        for name,record in group["methods"].items():
            print("SCENE_CALLSITE owner="+owner+" method="+name+
                  " calls="+str(record["call_count"])+
                  " selectors="+str(record["identified_selector_count"])+
                  " scene_related="+str(len(record["scene_related_calls"])))
            for call in record["scene_related_calls"][:20]:
                print("  SCENE_CALL "+call["pc"]+" target="+str(call["target"])+
                      " selector="+str(call["selector"]))
    print("NATIVE12_OMNI_SHA_LOCKED_SELECTOR_CALLSITE_STATIC_AUDIT_PASS__DEVICE_UNTESTED")

if __name__=="__main__":
    main()
