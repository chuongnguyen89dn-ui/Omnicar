#!/usr/bin/env python3
"""Read-only root-cause audit for production-tested 1.0.3-omnicar1 regression.
Methods and disassembly from SHA-pinned ORIGINAL DEB, not addon guesses.
"""
import hashlib,json,re,struct,subprocess,sys,tempfile
from pathlib import Path
from audit_original_edge_drag import parse
SHA="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
NAMES=("allPanes","slots","paneAtSlot:","paneCount","closeSlot:background:",
"afterPaneRemoved:","soloBundle:","hostSolo:","closeGoingHome:",
"tabParent","soloReturnedVC","soloHostedBundle","showRatioMenuForDivider:",
"hideRatioMenu","ratioMenu","dividerDoubleTapped:","dividerDoubleTapOn:",
"dividerTapped:","dividerTapOn:at:","setBarVisible:forPane:","layoutBarForPane:",
"handleTapped:","handleDoubleTapped:","rootDidLayout","appAreaInParent:",
"openRememberedPair","openSetupLayout:apps:","rebuildDividers",
"panesInReadingOrder","switchToLayout:","ratioTimer","ratioKnob",
"panelChoiceTapped:","panelChoiceTappedUnsafe:")
def inspect(src):
 b=Path(src).read_bytes()
 assert hashlib.sha256(b).hexdigest()==SHA
 with tempfile.TemporaryDirectory() as td:
  subprocess.run(["dpkg-deb","-x",str(src),td],check=True)
  f=Path(td)/"var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib"
  fat=f.read_bytes()
  for k in range(struct.unpack_from(">I",fat,4)[0]):
   cpu,sub,off,n,_=struct.unpack_from(">IIIII",fat,8+20*k)
   if cpu==0x100000c and sub==0:
    arm=fat[off:off+n];break
  else:raise ValueError("arm64 missing")
  methods=parse(arm)
  dumped=subprocess.check_output(["llvm-objdump","--macho","--arch=arm64","--disassemble",str(f)],text=True)
  asm={}
  for line in dumped.splitlines():
   mt=re.match(r"^\s*([0-9a-fA-F]+):\s*(.*)$",line)
   if mt:asm[int(mt.group(1),16)]=mt.group(2).strip()
  report={}
  only={pc:(cl,sel) for (cl,sel),pc in methods.items() if cl=="SCPCarSplit"}
  addresses=sorted(only.keys())
  for n in NAMES:
   pc=methods.get(("SCPCarSplit",n))
   if pc is None:
    report[n]={"available":False};continue
   nextpc=next((a for a in addresses if a>pc),pc+0x200)
   extent=min(nextpc,pc+0x340)
   instr=[{"pc":hex(a),"asm":asm[a]} for a in range(pc,extent,4) if a in asm]
   report[n]={"available":True,"pc":hex(pc),"instructions":instr}
  related=sorted([{"class":cl,"selector":sel,"pc":hex(addr)}
                  for (cl,sel),addr in methods.items() if
                  re.search(r"ratio|menu|handle|pane|solo|gesture|divider",sel,re.I)],
                 key=lambda item:(item["class"],item["selector"]))
  return {"original_sha256":SHA,"status":"ORIGINAL_STATIC_READ_ONLY_NO_DEVICE_CLAIM",
          "methods":report,"related_selectors":related}
if __name__=="__main__":
 if len(sys.argv)!=2:raise SystemExit("usage: python3 scripts/audit_issue_20261020.py exact_original_1.0.3.deb")
 print(json.dumps(inspect(sys.argv[1]),ensure_ascii=False,indent=2))
