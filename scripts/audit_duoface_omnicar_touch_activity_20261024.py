#!/usr/bin/env python3
"""Original SHA-pinned OmniCar touch owner and IPC route; compare with archived DuoFace v12 proof.
READ ONLY: never patch original DEBs, inject a process or deploy.
"""
import argparse,hashlib,json,re,subprocess,tempfile
from pathlib import Path
from audit_original_youtube_handle_owner_20261024 import (read_objc_classes,ORIGINAL_SHA)
from audit_omnicar_appbridge_scene import fat_arm64,parse_disassembly,decode_objc_stub

LIBS={
  "OmniCarAppBridge":{
    "ABHost":("outsideTouched","handleTapped:","setupHandleForPane:","setupLiveAppViewForPane:",
              "ensureWindow","window","carWindow","setFrame:forApp:live:handle:passInsets:",
              "revealPane:","layoutPane:","setHandleVisible:forPane:","init"),
    "ABPane":("box","handle","handleHit","appViewController","bundleID"),
    "ABShieldView":("touchesBegan:withEvent:",),
    "ABKnobView":("touchesBegan:withEvent:",)
  },
  "OmniCarSplitScreen":{
    "SCPCarSplit":("bridgeOutsideTouched","bridgeHandleTapped:","handleTapped:",
                  "sendHostFrameForPane:live:","hostPost:info:","rootDidLayout",
                  "hideBarsForTouchOn:","setBarVisible:forPane:","setActive:",
                  "container","tabParent","allPanes","hostedPanes"),
    "SCPCarPane":("view","handle","hostHandle","bundleID"),
    "SCPCarSplitView":("hitTest:withEvent:",),
    "SCPCTouchWatch":("hitTest:withEvent:",),
    "SCPCarDividerView":("touchesBegan:withEvent:",)
  }
}

def trace(arm,methods,ins,selectors):
    entries=sorted((int(v["imp"],16),k) for k,v in methods.items())
    out={}
    for selector in selectors:
        if selector not in methods:
            out[selector]={"status":"NOT_IN_ORIGINAL_BINARY"}
            continue
        m=methods[selector];pc=int(m["imp"],16)
        stop=min((address for address,_ in entries if address>pc),default=pc+0x500)
        # Restrict output to actual original method bounds, cap to 0x900.
        stop=min(stop,pc+0x900)
        trace=[];calls=[]
        for at in range(pc,stop,4):
            asm=ins.get(at,"")
            if not asm:continue
            item={"pc":hex(at),"asm":asm}
            trace.append(item)
            match=re.search(r"\bbl\s+(?:0x)?([0-9a-f]+)",asm)
            if match:
                addr=int(match.group(1),16)
                decoded=decode_objc_stub(arm,addr)
                signal={"pc":hex(at),"target":hex(addr)}
                if decoded.get("status")=="selector-mapped":signal["selector"]=decoded["selector"]
                if "symbol stub for:" in asm:signal["symbol"]=asm.split("symbol stub for:",1)[1].strip()
                calls.append(signal)
        out[selector]={"imp":m["imp"],"types":m["types"],"calls":calls,
                       "instruction_count":len(trace),
                       "instructions":trace if selector in (
                           "outsideTouched","bridgeOutsideTouched",
                           "hitTest:withEvent:","touchesBegan:withEvent:",
                           "bridgeHandleTapped:","handleTapped:",
                           "setupLiveAppViewForPane:","ensureWindow",
                           "setBarVisible:forPane:") else trace[:50]}
    return out

def audit(deb):
    b=deb.read_bytes()
    actual=hashlib.sha256(b).hexdigest()
    if actual!=ORIGINAL_SHA:raise ValueError("Original DEB SHA mismatch; refusing unpinned package")
    result={"status":"ORIGINAL_DUOFACE_TOUCH_ROUTE_COMPARISON_STATIC_ONLY",
            "original_omnicar_deb_sha256":actual,"scope":LIBS,"modules":{}}
    with tempfile.TemporaryDirectory(prefix="touch-duoface-omni-") as td:
        subprocess.run(["dpkg-deb","-x",str(deb.resolve()),td],check=True)
        root=Path(td)/"var/jb/Library/MobileSubstrate/DynamicLibraries"
        for lib,owners in LIBS.items():
            file=root/(lib+".dylib")
            arm=fat_arm64(file.read_bytes())
            ins=parse_disassembly(subprocess.check_output(
                ["llvm-objdump","--macho","--arch=arm64","--disassemble",str(file)],text=True))
            catalog=read_objc_classes(arm)
            allTouchClasses={}
            for cls,mm in catalog.items():
                matched=sorted(x for x in mm if any(y in x.lower() for y in
                  ("touchesbegan","hittest:","outside","noteuseractivity","sendevent:")))
                if matched:allTouchClasses[cls]=matched
            result["modules"][lib]={
                "binary_sha256":hashlib.sha256(file.read_bytes()).hexdigest(),
                "interesting_touch_owner_classes":allTouchClasses,
                "owners":{cls:trace(arm,catalog[cls],ins,sels) for cls,sels in owners.items()}
            }
    # Human-verifiable specific API, not a claim all app touches traverse it.
    a=result["modules"]["OmniCarAppBridge"]["owners"]["ABHost"]
    b=result["modules"]["OmniCarSplitScreen"]["owners"]["SCPCarSplit"]
    for key in ("outsideTouched","setupLiveAppViewForPane:","window"):
        assert "imp" in a[key],key
    for key in ("bridgeOutsideTouched","rootDidLayout","container"):
        assert "imp" in b[key],key
    return result

if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("original",type=Path)
    parser.add_argument("--output",required=True,type=Path)
    args=parser.parse_args()
    result=audit(args.original)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2))
    for lib,val in result["modules"].items():
        print("TOUCH_ORIGINAL_MODULE",lib,val["binary_sha256"])
        print("TOUCH_METHOD_CLASSES",lib,json.dumps(val["interesting_touch_owner_classes"]))
        for owner,methods in val["owners"].items():
            for name,entry in methods.items():
                print("TOUCH_ORIGINAL_METHOD",lib,owner,name,entry.get("imp"),
                      entry.get("types"),"selectors",
                      ",".join(x["selector"] for x in entry.get("calls",[]) if "selector" in x))
    print("ORIGINAL_OMNICAR_AND_DUOFACE_TOUCH_ACTIVITY_ROUTE_STATIC_AUDIT_PASS")
