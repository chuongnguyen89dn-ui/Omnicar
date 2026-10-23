#!/usr/bin/env python3
"""SHA-pinned exact selectors referenced by ORIGINAL DuoFace Native12 and OmniCar.

Focus on original scene/rotation control: method-owned Objective-C selector
references, surrounding ARM64 register loads, matching call instructions.
Cross-reference with our QA13/14 failure, without claiming live iPhone events.

Unlike previous nearest-x1 callsite heuristics, record EVERY direct __objc_selrefs
ADRP+LDR pairing to any register and reconstruct conservative basic-block x1
provenance (no fabricated source matches). Dylibs/DEBs remain byte-unchanged.
"""
from __future__ import annotations
import argparse,json
from pathlib import Path
from capstone import Cs,CS_ARCH_ARM64,CS_MODE_ARM
from capstone.arm64 import ARM64_OP_REG,ARM64_OP_MEM,ARM64_OP_IMM
from audit_v12_omnicar_geometry_machine import (
    checked_payload,arm64_slice,DUO_DEB_SHA,DUO_DYLIB_SHA,
    OMNI_DEB_SHA,OMNI_DYLIB_SHA,DUO,OMNI)
from audit_v12_omnicar_scene_calls import (
    sections_and_stubs,selector_pointer,section_for)

DUO_METHODS=[
 "CBBridgedUIAppView.updateSceneSettingsFrame",
 "CBBridgedUIAppView.refreshSceneLayout",
 "CBBridgedUIAppView.updateLayout",
 "CBBridgedUIAppView.calculateNativeSizeForSlotRect:",
 "CBBridgedSplitApp.updateScale:forSlot:",
 "CBBridgeManager.renderSizeForBundleID:",
]
OMNI_METHODS=[
 "ABHost.effectiveOrientation:","ABHost.layoutPane:",
 "ABHost.setFrame:forApp:live:handle:passInsets:",
]
FOCUS=("orient","rotat","scene","frame","viewport","reference",
       "window","bounds","video","render","size","transform",
       "interface","content","client","display","landscape","device")
def rn(ins, operand):
    return ins.reg_name(operand.reg) if operand.type==ARM64_OP_REG else None

def load_xrefs(arm:bytes,sec:dict,instructions:list):
    """All verified selector slot references where ADRP target is the base register.

    Search only within the same straight-line block (break on calls/branches),
    and ensure base not overwritten in the interval. This does NOT assume any
    dynamic call executes, nor silently fill unknown ObjC selector values.
    """
    refs=[]
    for i,ins in enumerate(instructions):
        if ins.mnemonic not in ("ldr","ldur") or len(ins.operands)<2: continue
        dst,src=ins.operands[:2]
        if dst.type!=ARM64_OP_REG or src.type!=ARM64_OP_MEM:continue
        dest=rn(ins,dst);base=ins.reg_name(src.mem.base)
        if not dest or not dest.startswith("x"):continue
        if src.mem.index:continue
        for k in range(i-1,max(-1,i-31),-1):
            prev=instructions[k]
            if prev.mnemonic in ("bl","blr","ret","br","b") or \
                prev.mnemonic.startswith(("b.","cbz","cbnz","tbz","tbnz")):
                break
            # A previous write to base breaks the address provenance.
            if prev.operands and prev.operands[0].type==ARM64_OP_REG and \
               rn(prev,prev.operands[0])==base:
                if prev.mnemonic=="adrp" and len(prev.operands)>1 and \
                   prev.operands[1].type==ARM64_OP_IMM:
                    slot=int(prev.operands[1].imm)+int(src.mem.disp)
                    val=selector_pointer(arm,sec,slot)
                    if val is not None:
                        refs.append({
                            "ldr_pc":hex(ins.address),"adrp_pc":hex(prev.address),
                            "destination_register":dest,"base_register":base,
                            "selector_slot":hex(slot),"selector":val,
                            "near_context":[{"pc":hex(t.address),"asm":t.mnemonic+" "+t.op_str}
                                            for t in instructions[max(0,k-2):i+1]]
                        })
                break
    return refs

def conservative_calls(insns,refmap,imports):
    """Report x1 selector only if derivable within same uninterrupted code block.

    Clear register state at all possible basic-block labels or branch/call
    boundaries. x19+ callee-saved values may survive a call, but conservatively
    drop all on call; other layers show direct references even when this is empty.
    """
    known={}
    calls=[]
    for i,ins in enumerate(insns):
        pc=hex(ins.address)
        op=ins.mnemonic
        if op.startswith(("b.","cbz","cbnz","tbz","tbnz")) or op in ("b","br","ret","blr"):
            known.clear()
            continue
        if op=="bl":
            target=(ins.operands[0].imm if ins.operands and
                    ins.operands[0].type==ARM64_OP_IMM else None)
            prev=known.get("x1")
            if prev:
                calls.append({"pc":pc,"target":hex(target) if target is not None else None,
                              "selector":prev["selector"],
                              "load_pc":prev["ldr_pc"],
                              "confidence":"same-linear-block register-propagation",
                              "import":imports.get(target)})
            known.clear()
            continue
        dest=rn(ins,ins.operands[0]) if ins.operands else None
        if dest is None or not dest.startswith("x"):continue
        if pc in refmap:
            known[dest]=refmap[pc]
        elif op=="mov" and len(ins.operands)>1:
            src=rn(ins,ins.operands[1])
            if src in known:known[dest]=known[src]
            else:known.pop(dest,None)
        else:
            known.pop(dest,None)
    return calls

def method_report(arm:bytes,sec:dict,imports:dict,name:str,start:int,end:int):
    dis=Cs(CS_ARCH_ARM64,CS_MODE_ARM);dis.detail=True
    insns=list(dis.disasm(arm[start:end],start))
    if len(insns)!=(end-start)//4:raise ValueError("UNDECODED_METHOD "+name)
    all_refs=load_xrefs(arm,sec,insns)
    bypc={r["ldr_pc"]:r for r in all_refs}
    all_calls=conservative_calls(insns,bypc,imports)
    focus_refs=[x for x in all_refs if any(v in x["selector"].lower() for v in FOCUS)]
    focus_calls=[x for x in all_calls if any(v in x["selector"].lower() for v in FOCUS)]
    return {"pc_range":[hex(start),hex(end)],"instructions":len(insns),
            "all_resolved_selector_loads":all_refs,
            "all_resolved_selector_calls":all_calls,
            "focused_loads":focus_refs,"focused_calls":focus_calls,
            "all_unique_selectors":sorted(set(x["selector"] for x in all_refs))}

def report(duo:Path,omni:Path):
    out={"status":"ORIGINAL_DUOFACE_OMNICAR_SCENE_SELECTOR_STATIC_ONLY__DEVICE_UNTESTED",
         "sources":{"duoface_deb_sha256":DUO_DEB_SHA,"omnicar_deb_sha256":OMNI_DEB_SHA,
                    "duoface_dylib_sha256":DUO_DYLIB_SHA,"omnicar_dylib_sha256":OMNI_DYLIB_SHA},
         "duoface":{},"omnicar":{},
         "limitations":["Static original selector references, not executed runtime event paths.",
                        "Direct ADRP/SELREF only; dynamic NSSelectorFromString and register aliasing can be missing.",
                        "No claim DuoFace video landscape handling duplicated into OmniCar.",
                        "No new DEB/Sileo/iPhone CarPlay test or player orientation measurement."]}
    for side,path,debsha,dylibsha,suffix,methods,focus in [
      ("duoface",duo,DUO_DEB_SHA,DUO_DYLIB_SHA,"/DuoFaceDashboard.dylib",DUO,DUO_METHODS),
      ("omnicar",omni,OMNI_DEB_SHA,OMNI_DYLIB_SHA,"/OmniCarAppBridge.dylib",OMNI,OMNI_METHODS)]:
        arm=arm64_slice(checked_payload(path,debsha,suffix,dylibsha))
        sec,imports=sections_and_stubs(arm)
        out[side]["__objc_selrefs"]=sec.get("__objc_selrefs")
        out[side]["__objc_methname"]=sec.get("__objc_methname")
        out[side]["methods"]={}
        for name in focus:
            out[side]["methods"][name]=method_report(arm,sec,imports,name,*methods[name])
        if side=="duoface":
            # Immutable original explicitly calls these at verified offsets.
            root=out[side]["methods"]["CBBridgedUIAppView.refreshSceneLayout"]
            root["known_hardcoded_arm64_sequence"]=[
                "0xade74 objc_msgSend updateLayout",
                "0xade84 objc_msgSend updateSceneSettingsFrame"]
    return out

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--duoface",required=True,type=Path)
    p.add_argument("--omnicar",required=True,type=Path)
    p.add_argument("--output",required=True,type=Path)
    a=p.parse_args()
    v=report(a.duoface,a.omnicar)
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.write_text(json.dumps(v,ensure_ascii=False,indent=2)+"\n")
    for side in ("duoface","omnicar"):
        for name,m in v[side]["methods"].items():
            print("ORIGINAL_SELECTOR_AUDIT",side,name,
                  "loads",len(m["all_resolved_selector_loads"]),
                  "calls",len(m["all_resolved_selector_calls"]))
            for x in m["focused_loads"][:55]:
                print("  SCENE_LOAD",x["ldr_pc"],x["destination_register"],
                      x["selector"],x["selector_slot"])
            for x in m["focused_calls"][:30]:
                print("  SCENE_CALL",x["pc"],x["selector"])
    print("ORIGINAL_DUOFACE_OMNICAR_ORIENTATION_SELECTOR_PROVENANCE_PASS__DEVICE_UNTESTED")

if __name__=="__main__":main()
