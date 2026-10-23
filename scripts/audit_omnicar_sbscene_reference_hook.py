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
from audit_v12_omnicar_scene_calls import sections_and_stubs, nearby_selref

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

def adrp_add_value(instructions: list, call_index: int, register: str) -> int | None:
    """Recover immediate pointer constructed immediately before a hook register call."""
    for j in range(call_index-1,max(-1,call_index-10),-1):
        at=instructions[j]
        if (at.mnemonic!="add" or len(at.operands)!=3 or
                at.operands[0].type!=ARM64_OP_REG or
                at.reg_name(at.operands[0].reg)!=register or
                at.operands[1].type!=ARM64_OP_REG or
                at.reg_name(at.operands[1].reg)!=register or
                at.operands[2].type!=ARM64_OP_IMM):
            continue
        for k in range(j-1,max(-1,j-5),-1):
            prev=instructions[k]
            if (prev.mnemonic=="adrp" and prev.operands[0].type==ARM64_OP_REG and
                    prev.reg_name(prev.operands[0].reg)==register and
                    prev.operands[1].type==ARM64_OP_IMM):
                return prev.operands[1].imm+at.operands[2].imm
    return None

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
    # Recover the precise SBSceneView selector installation site, hook entry and
    # saved original IMP pointer. Matching includes objc_getClass + selector
    # reference + imported MSHookMessageEx; never infer from a log string alone.
    sel_uses={int(r["use_pc"],16) for r in refs
              if r["literal"]=="selref:_updateReferenceSize:andOrientation:"}
    cls_uses={int(r["use_pc"],16) for r in refs
              if r["literal"]=="string:SBSceneView"}
    hook_regs=[]; hook_bodies=[]
    for i,op in enumerate(instructions):
        if (op.mnemonic!="bl" or not op.operands or
                op.operands[0].type!=ARM64_OP_IMM or
                imports.get(op.operands[0].imm)!="_MSHookMessageEx"):
            continue
        pc=op.address
        matching_sel=[v for v in sel_uses if 0<pc-v<=0x28]
        matching_cls=[v for v in cls_uses if 0<pc-v<=0x40]
        if not matching_sel or not matching_cls: continue
        c=matching_cls[-1] if len(matching_cls)==1 else max(matching_cls)
        # One objc_getClass call between literal class reference and hook call.
        classcalls=[x.address for x in instructions[max(0,i-16):i]
                    if x.mnemonic=="bl" and x.operands and
                    x.operands[0].type==ARM64_OP_IMM and
                    imports.get(x.operands[0].imm)=="_objc_getClass" and
                    c<x.address<min(matching_sel)]
        if not classcalls:continue
        hook_fn=adrp_add_value(instructions,i,"x2")
        orig_slot=adrp_add_value(instructions,i,"x3")
        if hook_fn is None or orig_slot is None:continue
        if not sections["__text"]["start"]<=hook_fn<sections["__text"]["end"]:
            raise ValueError("HOOK_REPLACEMENT_NOT_IN_TEXT")
        hook_regs.append({"class":"SBSceneView","selector":"_updateReferenceSize:andOrientation:",
                          "class_string_pc":hex(c),"class_lookup_pc":hex(classcalls[-1]),
                          "selector_load_pc":hex(max(matching_sel)),"register_call_pc":hex(pc),
                          "register_import":"_MSHookMessageEx",
                          "replacement_function_pc":hex(hook_fn),
                          "saved_original_imp_slot":hex(orig_slot),
                          "proof":"static x0 class,x1 SEL,x2 replacement,x3 original-slot setup"})
        hook_d=Cs(CS_ARCH_ARM64,CS_MODE_ARM); hook_d.detail=True
        inspected=list(hook_d.disasm(arm[hook_fn:min(len(arm),hook_fn+0x900)],hook_fn))
        # The very first unconditional terminal instruction bounds THIS tiny
        # trampoline; disassembly beyond it would conflate unrelated methods.
        tail_index=next((j for j,x in enumerate(inspected)
                         if x.mnemonic in ("ret","br")),None)
        if tail_index is None:raise ValueError("UNBOUNDED_REFERENCE_HOOK")
        span=inspected[:tail_index+1]
        calls_in_hook=[]
        for t,ins in enumerate(span):
            if ins.mnemonic not in ("bl","blr"): continue
            target=ins.operands[0].imm if ins.operands and ins.operands[0].type==ARM64_OP_IMM else None
            direct_import=imports.get(target) if target is not None else None
            inline_sel,_=nearby_selref(arm,sections,span,t)
            stub_sel=None
            if target is not None:
                secname=next((n for n,r in sections.items()
                              if r["start"]<=target<r["end"]),"")
                if secname=="__objc_stubs":
                    stub_ins=list(hook_d.disasm(arm[target:target+28],target))
                    ix=next((j for j,z in enumerate(stub_ins) if z.mnemonic in
                             ("br","ret","b","blr")),len(stub_ins))
                    stub_sel,_=nearby_selref(arm,sections,stub_ins,ix)
            calls_in_hook.append({"pc":hex(ins.address),"target":hex(target) if target is not None else None,
                                  "import":direct_import,"selector":stub_sel or inline_sel})
        exclusive=span[-1].address+4
        hook_bodies.append({"entry":hex(hook_fn),"end_exclusive":hex(exclusive),
                            "boundary_note":"first terminal ret/br, verifies handler only; later functions excluded",
                            "instruction_count":len(span),
                            "ret_pcs":[hex(x.address) for x in span if x.mnemonic=="ret"],
                            "terminal_instruction":span[-1].mnemonic+" "+span[-1].op_str,
                            "branch_register_x3_original_slot_matches":(
                                len(span)>=2 and span[1].mnemonic=="ldr" and
                                "#0xa08" in span[1].op_str and
                                orig_slot==0x3ea08 and span[-1].mnemonic=="br" and
                                span[-1].op_str=="x3"),
                            "x2_value_policy_asm_only":[
                                {"pc":hex(x.address),"asm":x.mnemonic+" "+x.op_str}
                                for x in span if x.mnemonic in ("cmp","mov","csel")],
                            "callers":calls_in_hook,
                            "instructions":[{"pc":hex(x.address),"asm":x.mnemonic+" "+x.op_str}
                                            for x in span]})
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
        "hook_registration":hook_regs,
        "hook_function_windows":hook_bodies,
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
    print("SBSCENE_VERIFIED_REGISTRATION_COUNT",len(result["hook_registration"]))
    for reg in result["hook_registration"]:
        print("SBSCENE_REGISTER",reg["register_call_pc"],reg["replacement_function_pc"],reg["saved_original_imp_slot"])
    for body in result["hook_function_windows"]:
        print("SBSCENE_HANDLER",body["entry"],"ret",body["ret_pcs"][:8])
        for call in body["callers"][:32]:
            print("SBSCENE_HANDLER_CALL",call["pc"],call["selector"],call["import"])
    for ref in result["class_or_selector_address_references"][:16]:
        print("SBSCENE_XREF",ref["literal"],ref["begin_pc"],ref["use_pc"])
    for call in result["interesting_import_calls"][:16]:
        print("SBSCENE_IMPORT_CALL",call["pc"],call["import"])
    print("OMNICAR_SHA_LOCKED_SBSCENE_REFERENCE_STATIC_AUDIT_PASS__DEVICE_UNTESTED")

if __name__=="__main__":
    main()
