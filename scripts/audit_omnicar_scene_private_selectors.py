#!/usr/bin/env python3
"""Decode verified original OmniCar AppBridge's private CFString selectors.

Static/immutable only: NSSelectorFromString selectors used by ABHost.layoutPane
for the source application scene and host/viewport geometry. Values are never
guessed from method names. The 1.0.3 DEB/dylib SHA256 must match originals.

Run from the original OmniCar repository checkout:
 python3 scripts/audit_omnicar_scene_private_selectors.py \
  --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
  --output audit/omnicar_original_private_scene_selectors_20261023.json
Requires dpkg-deb, Python3, capstone==5.0.7. No device, patch or Sileo.
"""
from __future__ import annotations
import argparse
import json
import struct
from pathlib import Path
from capstone import Cs,CS_ARCH_ARM64,CS_MODE_ARM
from capstone.arm64 import ARM64_OP_IMM
from audit_v12_omnicar_geometry_machine import checked_payload,arm64_slice,OMNI_DEB_SHA,OMNI_DYLIB_SHA
from audit_v12_omnicar_scene_calls import sections_and_stubs,nearby_selref

# original hash-pinned ABHost.layoutPane: (0xec80..0xf0a0)
LAYOUT_START=0xec80
LAYOUT_END=0xf0a0
TARGETS=[
    {"load":"0xef00","cfstr":"0x36130","as_selector":"0xef08",
     "responds":"0xef18","send":"0xef28","objc_receiving_register":"x25"},
    {"load":"0xef58","cfstr":"0x36150","as_selector":"0xef60",
     "responds":"0xef70","send":"0xef80","objc_receiving_register":"x27"},
    {"load":"0xefe4","cfstr":"0x36170","as_selector":"0xefec",
     "responds":"0xeffc","send":"0xf048","objc_receiving_register":"x25"},
]

def cf_string(arm:bytes,sections:dict,pc:int) -> dict:
    sec=sections.get("__cfstring")
    if not sec or not sec["start"]<=pc<sec["end"] or \
       (pc-sec["start"])%32 or pc+32>len(arm):
        raise ValueError("NOT_ALIGNED_STATIC_CFSTRING "+hex(pc))
    flags=struct.unpack_from("<Q",arm,pc+8)[0]
    offset=struct.unpack_from("<Q",arm,pc+16)[0]
    length=struct.unpack_from("<Q",arm,pc+24)[0]
    if offset>=len(arm) or length>512:
        raise ValueError("BAD_CFSTRING_BOUNDARY "+hex(pc))
    if flags&0x10:
        if offset+length*2>len(arm):raise ValueError("BAD_UTF16_CFSTRING")
        value=arm[offset:offset+length*2].decode("utf-16le")
    else:
        if offset+length>len(arm):raise ValueError("BAD_ASCII_CFSTRING")
        value=arm[offset:offset+length].decode("utf-8")
    if not value or not all(32<=ord(x)<127 for x in value):
        raise ValueError("UNEXPECTED_PRIVATE_SELECTOR_CONTENT "+repr(value))
    return {"cfstring_object_pc":hex(pc),"string_data_pc":hex(offset),
            "length":length,"flags":hex(flags),"decoded_exact_selector":value}

def check_selectors(arm:bytes):
    sections,imports=sections_and_stubs(arm)
    dis=Cs(CS_ARCH_ARM64,CS_MODE_ARM);dis.detail=True
    ins=list(dis.disasm(arm[LAYOUT_START:LAYOUT_END],LAYOUT_START))
    if len(ins)!=(LAYOUT_END-LAYOUT_START)//4:raise ValueError("METHOD_TRUNCATED")
    bypc={x.address:x for x in ins}
    output=[]
    for spec in TARGETS:
        cfp=int(spec["cfstr"],16);loadpc=int(spec["load"],16)
        a=bypc[loadpc]
        if a.mnemonic!="adrp" or a.op_str!="x0, #0x36000":
            raise ValueError("UNEXPECTED_CFSTRING_PAGE "+hex(loadpc))
        addition=bypc[loadpc+4]
        if addition.mnemonic!="add" or addition.op_str!=f"x0, x0, #{cfp-0x36000:#x}":
            raise ValueError("UNEXPECTED_CFSTRING_POINTER "+hex(loadpc+4)+" "+addition.op_str)
        detail=cf_string(arm,sections,cfp)
        for k,sym in [("as_selector","_NSSelectorFromString"),
                      ("responds","_objc_opt_respondsToSelector"),
                      ("send","_objc_msgSend")]:
            pc=int(spec[k],16)
            at=bypc[pc]
            if at.mnemonic!="bl" or at.operands[0].type!=ARM64_OP_IMM:
                raise ValueError("NO_CALL_AT "+hex(pc))
            imported=imports.get(at.operands[0].imm)
            if imported!=sym:raise ValueError("IMPORTED_CALL_MISMATCH "+hex(pc)+" "+str(imported))
        index=next(i for i,x in enumerate(ins) if x.address==int(spec["send"],16))
        code=[{"pc":hex(x.address),"asm":x.mnemonic+" "+x.op_str}
              for x in ins[max(0,index-11):min(len(ins),index+9)]]
        output.append({**spec,**detail,"call_context":code,
                       "evidence":"verified original CFString value + exact NSSelectorFromString/objc_responds/objc_msgSend branches"})
    # Also resolve additional NSSelectorFromString offsets if present in the same method.
    generic=[]
    for i,x in enumerate(ins):
        if x.mnemonic!="bl" or x.operands[0].type!=ARM64_OP_IMM:
            continue
        if imports.get(x.operands[0].imm)!="_NSSelectorFromString":continue
        generic.append(hex(x.address))
    if len(generic)!=len(TARGETS):
        raise ValueError("ADDITIONAL_UNDOCUMENTED_PRIVATE_SELECTOR_SENDS "+str(generic))
    return {"status":"IMMUTABLE_OMNICAR_PRIVATE_SCENE_SELECTORS_STATIC_DEVICE_UNTESTED",
            "original_deb_sha256":OMNI_DEB_SHA,
            "original_appbridge_sha256":OMNI_DYLIB_SHA,
            "method":"ABHost.layoutPane:",
            "method_range":["0xec80","0xf0a0"],
            "original_cfstrings_and_dynamic_selectors":output,
            "all_NSSelectorFromString_calls":generic,
            "limits":["Static exact original CFString only; no live YouTube scene values.",
                      "RespondsToSelector branch may skip actual send when receiver lacks private method.",
                      "Not proof any particular selector executes for YouTube; no patch/DEB/Sileo."]
            }

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--omnicar",required=True,type=Path)
    p.add_argument("--output",required=True,type=Path)
    a=p.parse_args()
    b=checked_payload(a.omnicar,OMNI_DEB_SHA,"/OmniCarAppBridge.dylib",OMNI_DYLIB_SHA)
    result=check_selectors(arm64_slice(b))
    a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.write_text(json.dumps(result,indent=2,ensure_ascii=False)+"\n")
    for entry in result["original_cfstrings_and_dynamic_selectors"]:
        print("ORIGINAL_SBSCENE_PRIVATE_SELECTOR",
              entry["as_selector"],entry["decoded_exact_selector"],
              entry["cfstring_object_pc"])
    print("OMNICAR_SHA_PINNED_PRIVATE_SCENE_SELECTOR_MAP_PASS__DEVICE_UNTESTED")

if __name__=="__main__":
    main()
