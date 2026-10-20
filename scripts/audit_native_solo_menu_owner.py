#!/usr/bin/env python3
"""Read-only original OmniCar solo control forensic, compared with DuoFace v12.

Only exact SHA256-pinned original 1.0.3 .deb, never an addon or QA build.
Produces static ARM64 ObjC method-local instruction windows for split and pane
solo owners. Does not execute tweak, modify DEB, build, or install.
"""
from pathlib import Path
import hashlib,json,re,struct,subprocess,sys,tempfile
from audit_original_edge_drag import parse
SHA="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
SPLIT=("closeSlot:background:","afterPaneRemoved:","soloBundle:","hostSolo:",
       "paneSolo:","runSoloForPane:","showSoloCoverForBundle:",
       "hideSoloCover","closeGoingHome:","endHostedSolo","openRememberedPair",
       "openSetupLayout:apps:","launcherHost","tabParent","appAreaInParent:",
       "soloHostedBundle","soloReturnedVC","soloCover","soloHostedFrame",
       "hostedPanes","allPanes","paneAtSlot:","layoutBarForPane:",
       "setBarVisible:forPane:","hostBarInfoForPane:","hostFrameInfo:pane:live:handle:")
PANE=("soloButton","setSoloButton:","handle","hostHandle","setHandle:",
      "setHostHandle:","bundleID","vc")
def audit(p):
    src=Path(p)
    assert src.exists()
    assert hashlib.sha256(src.read_bytes()).hexdigest()==SHA, "wrong immutable DEB"
    with tempfile.TemporaryDirectory() as td:
        subprocess.run(["dpkg-deb","-x",str(src),td],check=True)
        dylib=Path(td)/"var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib"
        fat=dylib.read_bytes()
        arm=None
        assert struct.unpack_from(">I",fat,0)[0]==0xcafebabe
        for n in range(struct.unpack_from(">I",fat,4)[0]):
            cpu,sub,off,size,_=struct.unpack_from(">IIIII",fat,8+20*n)
            if cpu==0x100000c and sub==0:
                arm=fat[off:off+size];break
        assert arm is not None
        methods=parse(arm)
        text=subprocess.check_output(["llvm-objdump","--macho","--arch=arm64","--disassemble",str(dylib)],text=True)
        asm={}
        for line in text.splitlines():
            m=re.match(r"^\s*([0-9a-fA-F]+):\s*(.*)$",line)
            if m:asm[int(m.group(1),16)]=m.group(2).strip()
        result={}
        for cl, names in (("SCPCarSplit",SPLIT),("SCPCarPane",PANE)):
            addresses=sorted(pc for (name,_),pc in methods.items() if name==cl)
            cls={}
            for selector in names:
                pc=methods.get((cl,selector))
                if pc is None:
                    cls[selector]={"exists":False};continue
                limit=min(next((a for a in addresses if a>pc),pc+0x500),pc+0x650)
                instructions=[{"pc":hex(x),"insn":asm[x]} for x in range(pc,limit,4) if x in asm]
                cls[selector]={"exists":True,"imp":hex(pc),"instructions":instructions}
            result[cl]=cls
        return {"sha256":SHA,"status":"READ_ONLY_ORIGINAL_SOLO_OWNERS_NOT_DEVICE_VERIFIED",
                "duoface_reference":"DuoFace Native12 CBSlotPillView/CBBridgeManager showAppPickerForSlot: first restoreSplitAnimated:NO",
                "owners":result}
if __name__=="__main__":
    if len(sys.argv)!=2: raise SystemExit("usage: python3 scripts/audit_native_solo_menu_owner.py ORIGINAL1.0.3.deb")
    print(json.dumps(audit(sys.argv[1]),ensure_ascii=False,indent=2))
