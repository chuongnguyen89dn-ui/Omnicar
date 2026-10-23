#!/usr/bin/env python3
"""Read-only evidence for original OmniCar SBSceneView reference-size hook.

Verify immutable original OmniCar 1.0.3 DEB and OmniCarAppBridge.dylib,
inspect Mach-O __objc_selrefs, __cstring, references and imported hook calls.
NO instrumentation, injection, DEB build, device action or Sileo publication.

Run in Omnicar repo root (Ubuntu CI):
  python3 scripts/audit_omnicar_sbscene_reference_hook.py \
    --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
    --output audit/omnicar_original_sbscene_reference_hook_20261023.json
Requires Python3, dpkg-deb, capstone==5.0.7.
"""
from __future__ import annotations
import argparse
import json
import re
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM
from capstone.arm64 import ARM64_OP_IMM, ARM64_OP_MEM, ARM64_OP_REG
from audit_v12_omnicar_geometry_machine import (
    checked_payload, arm64_slice, OMNI_DEB_SHA, OMNI_DYLIB_SHA,
)
from audit_v12_omnicar_scene_calls import sections_and_stubs

SELECTORS = (
    "_updateReferenceSize:andOrientation:", "setSceneBox:", "sceneBox",
    "effectiveOrientation:", "setTransform:", "setFrame:", "layoutPane:",
)
TEXT_NEEDLES = (
    b"SBSceneView", b"_updateReferenceSize:andOrientation:",
    b"appBridgeZoom", b"appBridgeOrientation",
    b"com.anlai.omnicar/appbridge.frame",
)
HOOK_NEEDLES = ("MSHookMessageEx", "LHHookMessage", "objc_getClass",
                "MSHookFunction", "objc_msgSend", "class_getInstanceMethod")

def cstring(arm: bytes, pos: int) -> str | None:
    if not 0 <= pos < len(arm): return None
    stop=arm.find(b"\0",pos,min(len(arm),pos+240))
    if stop<=pos: return None
    b=arm[pos:stop]
    if not all(32 <= x < 127 for x in b): return None
    return b.decode("ascii")

def refs_from_arm(arm: bytes, sections:dict, target_set:set[int]):
    """Locate statically constructed literal/selref addresses; no runtime guesses."""
    start=sections["__text"]["start"]
    end=sections["__text"]["end"]
    d=Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    d.detail=True
    ins=list(d.disasm(arm[start:end],start))
    if len(ins)!=(end-start)//4:raise ValueError("UNDECODABLE_TEXT")
    references=[]
    for i,op in enumerate(ins):
        if op.mnemonic not in ("adrp","adr") or len(op.operands)<2:continue
        if op.operands[0].type!=ARM64_OP_REG or op.operands[1].type!=ARM64_OP_IMM:continue
        dest=op.reg_name(op.operands[0].reg)
        page=op.operands[1].imm
        if op.mnemonic=="adr":
            if page in target_set:
                references.append((i,i,page,dest,"adr"))
            continue
        for j in range(i+1,min(i+10,len(ins))):
            nextop=ins[j]
            if nextop.mnemonic in ("bl","blr","ret","br","b") or nextop.mnemonic.startswith(("b.","cbz","cbnz","tbz","tbnz")):
                break
            if nextop.mnemonic in ("add","ldr","ldur") and len(nextop.operands)>=2:
                a,b=nextop.operands[:2]
                if a.type!=ARM64_OP_REG:continue
                if nextop.mnemonic=="add" and len(nextop.operands)>=3:
                    if b.type!=ARM64_OP_REG or nextop.reg_name(b.reg)!=dest or nextop.operands[2].type!=ARM64_OP_IMM:
                        continue
                    target=page+nextop.operands[2].imm
                elif b.type==ARM64_OP_MEM and nextop.reg_name(b.mem.base)==dest:
                    target=page+b.mem.disp
                else:continue
                if target in target_set:
                    references.append((i,j,target,dest,nextop.mnemonic))
                if nextop.reg_name(a.reg)==dest:
                    break
            elif (nextop.mnemonic.startswith(("mov","adrp","adr","ldp")) and
                    nextop.operands and nextop.operands[0].type==ARM64_OP_REG and
                    nextop.reg_name(nextop.operands[0].reg)==dest):
                break
    return ins,references

def analyze(original:Path):
    raw=checked_payload(original,OMNI_DEB_SHA,"/OmniCarAppBridge.dylib",OMNI_DYLIB_SHA)
    arm=arm64_slice(raw)
    sections, imports=sections_and_stubs(arm)
    strings=[]
    # Restrict search to known static strings; don't export arbitrary app data.
    for needle in TEXT_NEEDLES:
        positions=[x.start() for x in re.finditer(re.escape(needle),arm)]
        strings.extend({"needle":needle.decode(),"pc":hex(i),
                        "section":next((n for n,s in sections.items() if s["start"]<=i<s["end"]),"outside")}
                       for i in positions[:20])
    if not any(x["needle"]=="_updateReferenceSize:andOrientation:" for x in strings):
        raise ValueError("EXPECTED_ORIGINAL_REFERENCE_SIZE_SELECTOR_STRING_MISSING")
    wanted={x["pc"] for x in strings if x["needle"] in ("SBSceneView","_updateReferenceSize:andOrientation:")}
    addr_to_name={int(x["pc"],16):"string:"+x["needle"] for x in strings
                  if x["needle"] in ("SBSceneView","_updateReferenceSize:andOrientation:")}
    selected=[]
    sel_section=sections.get("__objc_selrefs")
    if sel_section:
        for at in range(sel_section["start"],sel_section["end"],8):
            if at+8>len(arm):break
            ptr=struct.unpack_from("<Q",arm,at)[0]
            if ptr>=len(arm):ptr &= (1<<48)-1
            value=cstring(arm,ptr)
            if value in SELECTORS:
                selected.append({"selector":value,"selref_pc":hex(at),
                                 "selector_pc":hex(ptr)})
                if value=="_updateReferenceSize:andOrientation:":
                    addr_to_name[at]="selref:"+value
    instructions,xrefs=refs_from_arm(arm,sections,set(addr_to_name))
    refs=[]
    for i,j,target,reg,kind in xrefs[:150]:
        start=max(0,i-6);end=min(len(instructions),j+14)
        context=[{"pc":hex(x.address),"asm":x.mnemonic+" "+x.op_str}
                 for x in instructions[start:end]]
        refs.append({"literal":addr_to_name[target],"target_pc":hex(target),
                     "begin_pc":hex(instructions[i].address),"use_pc":hex(instructions[j].address),
                     "register":reg,"instruction_kind":kind,
                     "context":context})
    identified_imports={hex(a):n for a,n in imports.items()
                        if any(t.lower() in n.lower() for t in HOOK_NEEDLES)}
    calls=[]
    for k,ins in enumerate(instructions):
        if ins.mnemonic!="bl" or not ins.operands or ins.operands[0].type!=ARM64_OP_IMM:
            continue
        destination=ins.operands[0].imm
        if destination not in imports: continue
        symbol=imports[destination]
        if not any(t.lower() in symbol.lower() for t in HOOK_NEEDLES): continue
        calls.append({"pc":hex(ins.address),"import":symbol,
                      "target":hex(destination),
                      "nearby":[{"pc":hex(x.address),"asm":x.mnemonic+" "+x.op_str}
                                for x in instructions[max(0,k-10):min(len(instructions),k+4)]]})
    return {
        "status":"ORIGINAL_OMNICAR_SBSCENEVIEW_STATIC_REFERENCE_AUDIT_DEVICE_UNTESTED",
        "original_deb_sha256":OMNI_DEB_SHA,
        "original_appbridge_sha256":OMNI_DYLIB_SHA,
        "reference_size_strings":strings,
        "selected_selector_refs":selected,
        "reference_size_selector_selref_count":sum(
            x["selector"]=="_updateReferenceSize:andOrientation:" for x in selected),
        "class_or_selector_address_references":refs,
        "interesting_import_stubs":identified_imports,
        "interesting_import_calls":calls[:120],
        "limitations":[
            "Reference strings and static instruction xrefs are not runtime observations.",
            "No assertion that private hook ran for YouTube; unknown dynamic selectors remain unresolved.",
            "May not resolve dlsym/indirect hook registration or pointers signed/bound at runtime.",
            "No QA12 change, no DEB build, no Sileo publication, no live device measurement.",
        ]
    }

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--omnicar",type=Path,required=True)
    p.add_argument("--output",type=Path,required=True)
    args=p.parse_args()
    result=analyze(args.omnicar)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    print("SBSCENE_SELREF_COUNT",result["reference_size_selector_selref_count"])
    print("SBSCENE_STATIC_XREF_COUNT",len(result["class_or_selector_address_references"]))
    print("SBSCENE_IMPORT_CALL_COUNT",len(result["interesting_import_calls"]))
    for ref in result["class_or_selector_address_references"][:16]:
        print("SBSCENE_XREF",ref["literal"],ref["begin_pc"],ref["use_pc"])
    for call in result["interesting_import_calls"][:16]:
        print("SBSCENE_IMPORT_CALL",call["pc"],call["import"])
    print("OMNICAR_SHA_LOCKED_SBSCENE_REFERENCE_STATIC_AUDIT_PASS__DEVICE_UNTESTED")

if __name__=="__main__":
    main()
