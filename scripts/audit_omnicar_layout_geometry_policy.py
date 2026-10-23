#!/usr/bin/env python3
"""SHA-locked scene geometry invariant audit (DuoFace Native12 ↔ OmniCar).

Evidence from exact ARM64 instructions and ObjC call targets. This is NOT
an iPhone/car test, UI patch, alternative player, or released DEB.
Run from OmniCar checkout:
 python3 scripts/audit_omnicar_layout_geometry_policy.py \
  --duoface duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb \
  --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
  --output audit/omnicar_native12_verified_layout_policy_20261023.json
Requirements: Python3, dpkg-deb, capstone==5.0.7.
"""
from __future__ import annotations
import argparse
import json
from pathlib import Path
from capstone import Cs,CS_ARCH_ARM64,CS_MODE_ARM
from audit_v12_omnicar_geometry_machine import (
    checked_payload,arm64_slice,DUO_DEB_SHA,DUO_DYLIB_SHA,
    OMNI_DEB_SHA,OMNI_DYLIB_SHA,DUO,OMNI
)
from audit_v12_omnicar_scene_calls import audit_binary

# All addresses are ARM64-offsets into the original hash-pinned dylibs.
# All assertions fail-closed if a different build, wrong method boundary,
# incorrect expected selector or different original arithmetic is encountered.
ANCHORS={
  "omnicar":{
    "ABHost.layoutPane:":[
      (0xecec,"bl","bounds"),
      (0xecf0,"mov v8.16b, v2.16b",None),
      (0xecf4,"mov v9.16b, v3.16b",None),
      (0xed00,"fmov d0, #2.00000000",None),
      (0xed08,"b.mi",None),
      (0xed10,"b.mi",None),
      (0xed18,"bl","zoom"),
      (0xed1c,"mov v12.16b, v0.16b",None),
      (0xed70,"bl","setTransform:"),
      (0xed74,"fdiv d0, d8, d12",None),
      (0xed78,"frinta d10, d0",None),
      (0xed7c,"fdiv d0, d9, d12",None),
      (0xed80,"frinta d11, d0",None),
      (0xed94,"mov v2.16b, v10.16b",None),
      (0xed98,"mov v3.16b, v11.16b",None),
      (0xed9c,"bl","setFrame:"),
      (0xeda4,"mov v0.16b, v12.16b",None),
      (0xeda8,"mov v1.16b, v12.16b",None),
      (0xedac,"bl",None), # _CGAffineTransformMakeScale import
      (0xedc8,"bl","setTransform:"),
      (0xedcc,"fmov d1, #0.50000000",None),
      (0xedd0,"fmul d0, d8, d1",None),
      (0xedd4,"fmul d1, d9, d1",None),
      (0xeddc,"bl","setCenter:"),
      (0xefbc,"bl","effectiveOrientation:"),
      (0xf068,"mov x0, x19",None),
      (0xf06c,"mov v0.16b, v8.16b",None),
      (0xf070,"mov v1.16b, v9.16b",None),
      (0xf074,"bl","setSceneBox:"),
    ],
    "ABHost.setFrame:forApp:live:handle:passInsets:":[
      (0xfee8,"fminnm d0, d9, d8",None),
      (0xfeec,"fmov d1, #2.00000000",None),
      (0xff60,"tbnz",None),
      (0x100d8,"bl","sceneBox"),
      (0x100dc,"fcmp d0, d9",None),
      (0x100e0,"b.ne #0x10124",None),
      (0x100e4,"fcmp d1, d8",None),
      (0x100e8,"b.ne #0x10124",None),
      (0x10110,"fmov d1, #0.50000000",None),
      (0x10114,"fmul d0, d9, d1",None),
      (0x10118,"fmul d1, d8, d1",None),
      (0x1011c,"bl","setCenter:"),
      (0x10120,"b #0x10198",None),
      (0x10124,"mov x0, x21",None),
      (0x10128,"mov x2, x20",None),
      (0x1012c,"bl","layoutPane:"),
      (0x10160,"bl","effectiveOrientation:"),
    ],
    "ABHost.zoom":[
      (0xae60,"fdiv d8, d0, d1",None),
      (0xae74,"fmaxnm d0, d8, d0",None),
      (0xae78,"fmov d1, #1.00000000",None),
      (0xae80,"fcsel d0, d1, d0, gt",None),
    ],
  },
  "duoface":{
    "CBBridgedUIAppView.calculateNativeSizeForSlotRect:":[
      (0xacc28,"fcmp d2, #0.0",None),
      (0xacc30,"fcmp d3, #0.0",None),
      (0xacc38,"fadd d0, d2, d2",None),
      (0xacc40,"frinta s0, s0",None),
      (0xacc48,"fadd d1, d3, d3",None),
      (0xacc50,"frinta s1, s1",None),
    ],
    "CBBridgedUIAppView.updateLayout":[
      (0xacd00,"bl","calculateNativeSizeForSlotRect:"),
      (0xad03c,"fdiv d0, d8, d12",None),
      (0xad040,"fdiv d1, d11, d13",None),
      (0xad044,"fminnm d0, d0, d1",None),
      (0xad054,"fmov d1, #0.50000000",None),
      (0xad058,"fcsel d12, d0, d1, hi",None),
    ],
    "CBBridgedUIAppView.updateSceneSettingsFrame":[
      (0xad620,"bl","carPlayUsableBounds"),
      (0xad638,"bl","calculateNativeSizeForSlotRect:"),
    ],
    "CBBridgedUIAppView.refreshSceneLayout":[
      (0xade74,"bl","updateLayout"),
      (0xade84,"bl","updateSceneSettingsFrame"),
    ],
  }
}

def verify_method(arm:bytes, method_range:tuple, expected:list, methodcalls:dict):
    first,last=method_range
    dis=Cs(CS_ARCH_ARM64,CS_MODE_ARM)
    got={x.address:(x.mnemonic+" "+x.op_str).strip()
         for x in dis.disasm(arm[first:last],first)}
    if len(got)!=(last-first)//4:raise AssertionError("TRUNCATED_DISASSEMBLY")
    callmap={int(c["pc"],16):c for c in methodcalls.get("all_calls",[])}
    result=[]
    for pc,asm_prefix,selector in expected:
        actual=got.get(pc,"")
        if not actual.startswith(asm_prefix):
            raise AssertionError(f"INSTRUCTION_MISMATCH {pc:#x}: {actual!r} != {asm_prefix}")
        if selector is not None and callmap.get(pc,{}).get("selector")!=selector:
            raise AssertionError(f"SELECTOR_MISMATCH {pc:#x}: {callmap.get(pc)} != {selector}")
        result.append({"pc":hex(pc),"machine_instruction":actual,
                       "selector_verified":selector,
                       "evidence":"exact original decoded ARM64 + original ObjC call target"})
    return result

def run(duo:Path,omni:Path):
    d=arm64_slice(checked_payload(duo,DUO_DEB_SHA,"/DuoFaceDashboard.dylib",DUO_DYLIB_SHA))
    o=arm64_slice(checked_payload(omni,OMNI_DEB_SHA,"/OmniCarAppBridge.dylib",OMNI_DYLIB_SHA))
    result={"status":"STATIC_PINNED_GEOMETRY_CALL_AND_REGISTER_EVIDENCE__DEVICE_UNTESTED",
            "original_source_sha256":{"duoface":DUO_DEB_SHA,"omnicar":OMNI_DEB_SHA},
            "duoface":{},"omnicar":{},
            "proven":["OmniCar layoutPane copies UIView.bounds width/height to d8/d9; zero/too-small panes exit.",
                      "OmniCar logical UIView frame dimensions round(bounds.width/zoom), round(bounds.height/zoom).",
                      "OmniCar then applies CGAffineTransformMakeScale(zoom,zoom) and centers in the physical rectangle.",
                      "OmniCar setSceneBox: receives ORIGINAL bounds dimensions d8/d9, not calculated logical frame d10/d11.",
                      "OmniCar setFrame checks both old sceneBox dimensions and chooses center-only or layoutPane.",
                      "DuoFace has independent native-size 2x+float round and a min-axis fit computation."],
            "not_proven":["The live YouTube source view size, zoom preference, video playback controls and touch mapping.",
                          "Every static branch executes for the YouTube app.",
                          "That sceneBox describes SBSceneView referenceSize or causes the oversized controls.",
                          "Identical DuoFace Native12 YouTube UI without paired device measurements.",
                          "No runtime patch, installable DEB or public Sileo change."]
            }
    for label,arm,methods in (("duoface",d,DUO),("omnicar",o,OMNI)):
        calls=audit_binary(arm,methods)["methods"]
        for name,expected in ANCHORS[label].items():
            result[label][name]={"anchor_count":len(expected),
                                 "verified_anchors":verify_method(arm,methods[name],expected,calls[name])}
    result["invariants"]={
        "omnicar_logical_frame":"round_ties_away? No: ARM64 frinta rounds to integral with ties AWAY per FRINTA; d10=frinta(d8/d12), d11=frinta(d9/d12).",
        "omnicar_visual_transform":"CGAffineTransformMakeScale(d12,d12) applied to content UIView only",
        "omnicar_sceneBox":"setSceneBox:(d8,d9) from same bounds before logical division, inside a branch",
        "omnicar_fast_path":"if original sceneBox dimensions match incoming box dimensions then reposition center; if either mismatches call layoutPane",
        "duoface_native_size":"when positive slot dimensions, each doubled, float32 converted and rounded; ratio fit performed in updateLayout",
    }
    return result

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--duoface",required=True,type=Path)
    p.add_argument("--omnicar",required=True,type=Path)
    p.add_argument("--output",required=True,type=Path)
    args=p.parse_args()
    data=run(args.duoface,args.omnicar)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(data,indent=2,ensure_ascii=False)+"\n")
    for side in ("duoface","omnicar"):
        for name,item in data[side].items():
            print("GEOMETRY_VERIFIED",side,name,item["anchor_count"])
    print("OMNICAR_NATIVE12_SHA_PINNED_GEOMETRY_INVARIANTS_PASS__DEVICE_UNTESTED")

if __name__=="__main__":
    main()
