#!/usr/bin/env python3
"""Original OmniCar scene updateSettingsWithBlock capture and ARM64 code.

Investigate exact block pointer passed by ABHost.layoutPane to
scene.updateSettingsWithBlock:; static SHA-locked original 1.0.3.
All inputs read-only. No patch, DEB, Sileo or live device state.
"""
from __future__ import annotations
import argparse,json
from pathlib import Path
from capstone import Cs,CS_ARCH_ARM64,CS_MODE_ARM
from capstone.arm64 import ARM64_OP_IMM
from audit_v12_omnicar_geometry_machine import checked_payload,arm64_slice,OMNI_DEB_SHA,OMNI_DYLIB_SHA
from audit_v12_omnicar_scene_calls import sections_and_stubs,nearby_selref
from audit_omnicar_scene_private_selectors import check_selectors,cf_string

BLOCK_PC=0xf210
CAPTURE_START=0xf004
CAPTURE_END=0xf04c
INSPECTION_END=0xf364

def audit(arm:bytes)->dict:
    sec,imports=sections_and_stubs(arm)
    owner=check_selectors(arm)
    third=owner["original_cfstrings_and_dynamic_selectors"][2]
    assert third["decoded_exact_selector"]=="updateSettingsWithBlock:"
    assert third["send"]=="0xf048"
    d=Cs(CS_ARCH_ARM64,CS_MODE_ARM);d.detail=True
    setup=list(d.disasm(arm[CAPTURE_START:CAPTURE_END],CAPTURE_START))
    bypc={x.address:x for x in setup}
    anchors={
      0xf01c:"adrp x8, #0xf000",
      0xf020:"add x8, x8, #0x210",
      0xf024:"adrp x9, #0x34000",
      0xf028:"add x9, x9, #0x920",
      0xf02c:"stp x8, x9, [sp, #0x28]",
      0xf030:"stp d12, d12, [sp, #0x38]",
      0xf034:"stp d13, d10, [sp, #0x48]",
      0xf038:"str x24, [sp, #0x58]",
      0xf03c:"add x2, sp, #0x18",
      0xf040:"mov x0, x25",
      0xf044:"mov x1, x26",
      0xf048:"bl #0x247ac"
    }
    for pc,expected in anchors.items():
        ins=bypc.get(pc)
        actual=ins.mnemonic+" "+ins.op_str if ins else ""
        if actual!=expected:raise ValueError(f"BLOCK_CAPTURE_REGRESSION {pc:#x}: {actual} != {expected}")
    sec_text=sec["__text"]
    if not sec_text["start"]<=BLOCK_PC<sec_text["end"]:raise ValueError("BLOCK_POINTER_OUTSIDE_TEXT")
    allins=list(d.disasm(arm[BLOCK_PC:INSPECTION_END],BLOCK_PC))
    if len(allins)!=(INSPECTION_END-BLOCK_PC)//4:raise ValueError("BLOCK_INSPECTION_INCOMPLETE")
    calls=[]
    for i,op in enumerate(allins):
        if op.mnemonic not in ("bl","blr"):continue
        target=op.operands[0].imm if op.operands and op.operands[0].type==ARM64_OP_IMM else None
        imported=imports.get(target)
        sl,_=nearby_selref(arm,sec,allins,i)
        os=sec.get("__objc_stubs")
        if target is not None and os and os["start"]<=target<os["end"]:
            stub=list(d.disasm(arm[target:target+28],target))
            cut=next((j for j,x in enumerate(stub) if x.mnemonic in ("br","ret","b","blr")),len(stub))
            st,_=nearby_selref(arm,sec,stub,cut)
            sl=st or sl
        calls.append({"pc":hex(op.address),"target":hex(target) if target is not None else None,
                      "import":imported,"selector_candidate":sl})
    return {
      "status":"PINNED_OMNICAR_SCENE_SETTINGS_BLOCK_STATIC_AUDIT_DEVICE_UNTESTED",
      "source_deb_sha256":OMNI_DEB_SHA,"source_appbridge_sha256":OMNI_DYLIB_SHA,
      "owner":"ABHost.layoutPane:","receiver_private_selector":"updateSettingsWithBlock:",
      "owner_block_capture_pc_range":[hex(CAPTURE_START),hex(CAPTURE_END)],
      "invoke_function_pc":hex(BLOCK_PC),
      "block_descriptor_pointer_pc":"0x34920",
      "captured_value_registers":["d12","d12","d13","d10","x24"],
      "block_invoke_passing":"0xf03c x2 receives stack block; 0xf048 sends updateSettingsWithBlock:",
      "capture_instructions":[{"pc":hex(i.address),"asm":i.mnemonic+" "+i.op_str} for i in setup],
      "bounded_inspection_window":[hex(BLOCK_PC),hex(INSPECTION_END)],
      "bounded_block_instructions":[{"pc":hex(i.address),"asm":i.mnemonic+" "+i.op_str} for i in allins],
      "candidate_ret_pcs":[hex(i.address) for i in allins if i.mnemonic=="ret"],
      "block_region_calls":calls,
      "limits":["Bounded window is not proof of single block function length.",
                "Captured values are static registers not YouTube device measurements.",
                "Private selector path may be skipped if receiver does not respond.",
                "No patch, DEB build, Sileo publish or real-device test."]
    }

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--omnicar",required=True,type=Path)
    p.add_argument("--output",required=True,type=Path)
    a=p.parse_args()
    raw=checked_payload(a.omnicar,OMNI_DEB_SHA,"/OmniCarAppBridge.dylib",OMNI_DYLIB_SHA)
    result=audit(arm64_slice(raw))
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+"\n")
    print("SCENE_UPDATE_SELECTOR",result["receiver_private_selector"])
    print("SCENE_UPDATE_BLOCK_POINTER",result["invoke_function_pc"])
    print("SCENE_UPDATE_CAPTURED_REGISTERS",",".join(result["captured_value_registers"]))
    for c in result["block_region_calls"][:45]:
        print("SCENE_UPDATE_BLOCK_CALL",c["pc"],c["import"],c["selector_candidate"])
    print("OMNICAR_SCENE_SETTINGS_BLOCK_SHA_PINNED_STATIC_PASS__DEVICE_UNTESTED")

if __name__=="__main__":
    main()
