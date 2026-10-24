#!/usr/bin/env python3
"""2026-10-24 read-only ARM64 DuoFace Native12 vs original OmniCar touch-owner forensic.
Exact SHA pins. Extract only immutable DEB payloads. Does NOT build/install a tweak.
"""
import argparse
import hashlib
import json
import re
import subprocess
import tempfile
from pathlib import Path
from audit_original_youtube_handle_owner_20261024 import read_objc_classes
from audit_omnicar_appbridge_scene import fat_arm64, parse_disassembly, decode_objc_stub

ORIGINAL_OMNI_DEB_SHA="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
ORIGINAL_DUO_DASHBOARD_SHA="bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce"
DYNAMIC=Path("var/jb/Library/MobileSubstrate/DynamicLibraries")
DUO_TARGETS={
 "CBBridgedUIAppView":("hitTest:withEvent:","touchesBegan:withEvent:","layoutSubviews"),
 "CBSplitContainerView":("hitTest:withEvent:","touchesBegan:withEvent:"),
 "CBBridgedSplitApp":("noteUserActivity","startBlinkingSession"),
 "CBBridgedUIApp":("noteUserActivity","showNotchPillSession"),
}
OMNI_TARGETS={
 "ABHost":("window","carWindow","ensureWindow","setupLiveAppViewForPane:",
           "outsideTouched","setHandleVisible:forPane:","setupHandleForPane:",
           "layoutBarForPane:","layoutPane:","paneFor:","revealPane:"),
 "ABPane":("box","handleHit","handle","bundleID","appViewController"),
}

def sha(data):return hashlib.sha256(data).hexdigest()

def inspect(dylib,targets,label):
    fat=dylib.read_bytes()
    arm=fat_arm64(fat)
    catalog=read_objc_classes(arm)
    dis=subprocess.check_output(["llvm-objdump","--macho","--arch=arm64",
                                 "--disassemble",str(dylib)],text=True)
    instructions=parse_disassembly(dis)
    owners={}
    for cls,names in targets.items():
        methods=catalog.get(cls,{})
        if not methods:raise AssertionError(f"{label}: missing owner class {cls}")
        found={}
        addresses=sorted(int(t["imp"],16) for t in methods.values())
        for name in names:
            m=methods.get(name)
            if m is None:
                found[name]={"MISSING":True}
                continue
            pc=int(m["imp"],16)
            nextpc=next((p for p in addresses if p>pc),pc+0x450)
            cap=0x220 if name in ("startBlinkingSession","showNotchPillSession",
                                "layoutPane:","setupLiveAppViewForPane:") else 0x430
            end=min(nextpc,pc+cap)
            lines=[]
            selcalls=[]
            for addr in range(pc,end,4):
                line=instructions.get(addr)
                if not line:continue
                if re.search(r"\b(?:bl|b|br|blr)\b",line):
                    callmatch=re.search(r"\bbl\s+(?:0x)?([0-9a-f]+)\b",line)
                    if callmatch:
                        tar=int(callmatch.group(1),16)
                        resolved=decode_objc_stub(arm,tar)
                        if resolved.get("status")=="selector-mapped":
                            selcalls.append({"pc":hex(addr),"selector":resolved["selector"]})
                lines.append(f"{addr:#x}: {line}")
            found[name]={"imp":m["imp"],"types":m["types"],
                          "original_call_selectors":selcalls,
                          "instructions":lines}
        owners[cls]=found
    touch_classes={}
    for cls,methods in catalog.items():
        tokens=[name for name in methods if
                any(k in name for k in
                    ("touchesBegan:","hitTest:withEvent:","sendEvent:",
                     "outsideTouched","gestureRecognizer:shouldReceiveTouch:"))]
        if tokens:touch_classes[cls]={key:methods[key] for key in tokens}
    return {"status":"READ_ONLY_ORIGINAL_ARM64_STATIC_ONLY",
            "label":label,"binary_fat_sha256":sha(fat),
            "owner_methods":owners,"all_touch_owner_selectors":touch_classes}

def main():
    cli=argparse.ArgumentParser()
    cli.add_argument("omni_deb",type=Path)
    cli.add_argument("duo_dashboard_dylib",type=Path)
    cli.add_argument("--output",type=Path,required=True)
    args=cli.parse_args()
    if sha(args.omni_deb.read_bytes())!=ORIGINAL_OMNI_DEB_SHA:
        raise ValueError("Unexpected original OmniCar DEB bytes")
    if sha(args.duo_dashboard_dylib.read_bytes())!=ORIGINAL_DUO_DASHBOARD_SHA:
        raise ValueError("Unexpected original DuoFace Native12 dashboard bytes")
    with tempfile.TemporaryDirectory(prefix="qa17-duo-omni-touch-original-") as td:
        subprocess.run(["dpkg-deb","-x",str(args.omni_deb.resolve()),td],check=True)
        omni=inspect(Path(td)/DYNAMIC/"OmniCarAppBridge.dylib",OMNI_TARGETS,
                     "OmniCar AppBridge 1.0.3 original")
        duo=inspect(args.duo_dashboard_dylib,DUO_TARGETS,
                    "DuoFace Native12 ORIGINAL")
    assert duo["owner_methods"]["CBBridgedUIAppView"]["touchesBegan:withEvent:"]["imp"]=="0xaca6c"
    assert omni["owner_methods"]["ABHost"]["setHandleVisible:forPane:"]["imp"]=="0x137cc"
    assert duo["all_touch_owner_selectors"],"No DuoFace touch-related classes"
    assert omni["owner_methods"]["ABHost"]["outsideTouched"]["imp"],"No original host touch callback"
    data={
     "status":"DUOFACE_NATIVE12_VS_OMNICAR_ORIGINAL_TOUCH_ROUTING_STATIC_ONLY_NO_DEVICE_TOUCH_TRACE",
     "duoface_dashboard_sha256":ORIGINAL_DUO_DASHBOARD_SHA,
     "original_omnicar_deb_sha256":ORIGINAL_OMNI_DEB_SHA,
     "duoface":duo,"omnicar":omni,
     "limits":"ObjC ARM64 disassembly cannot prove per-user live UIWindow/hit hierarchy or which first tap reached ABHost. QA17 device wake FAIL reported; do not falsely say runtime cause verified.",
    }
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(data,ensure_ascii=False,indent=2))
    for label,owner in (("DUOFACE",duo),("OMNICAR",omni)):
        print(label,"FAT_SHA256",owner["binary_fat_sha256"])
        for cls,methods in owner["owner_methods"].items():
            for name,rec in methods.items():
                print("ORIGINAL_METHOD",label,cls,name,rec.get("imp"),
                      rec.get("types"),
                      "calls",",".join(x["selector"] for x in rec.get("original_call_selectors",[])))
        print("ORIGINAL_TOUCH_CLASSES",label,
              json.dumps({c:list(ms) for c,ms in owner["all_touch_owner_selectors"].items()}))
    print("ORIGINAL_DUOFACE_APP_TOUCH_VS_OMNICAR_ABHOST_OWNER_FORENSIC_PASS__NO_PATCH")
if __name__=="__main__":main()
