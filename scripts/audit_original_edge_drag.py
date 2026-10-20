#!/usr/bin/env python3
"""Reproducible read-only original DEB drag-to-edge audit; never runs maintainer scripts."""
from pathlib import Path
import hashlib, subprocess, tempfile, struct, sys, re, json
SHA="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
SELS={"dividerPan:state:location:translation:":0x2d210,
      "mainStackDividerPan:state:location:translation:ended:":0x2db68,
      "closeSlot:background:":0x1d9b8,"removePaneAt:background:":0x149a8,
      "afterPaneRemoved:":0x1db48,"soloBundle:":0x1e33c,
      "rebuildDividers":0x14600,"layoutBarForPane:":0x23b9c,
      "toggleZoomForPane:":0x251b0}
CALLS={0x2d6b4:"closeSlot",0x2e08c:"closeSlot",0x1da78:"removePane",
       0x1dad0:"afterPaneRemoved",0x14bf0:"normalizeFractions",
       0x14e48:"rebuildDividers",0x1dc0c:"soloBundle",
       0x1de90:"soloBundle",0x14734:"newDivider",
       0x252e4:"setZoomedSlot",0x2538c:"relayout",
       0x23c68:"setHidden"}
def cstr(buf,offset):
  if offset<0 or offset>=len(buf): raise ValueError("bad string offset")
  return buf[offset:buf.index(b"\0",offset)].decode("utf8","replace")
def parse(buf):
  u=lambda p:struct.unpack_from("<Q",buf,p)[0]
  i=lambda p:struct.unpack_from("<I",buf,p)[0]
  si=lambda p:struct.unpack_from("<i",buf,p)[0]
  MASK=(1<<48)-1
  found={}
  for clsref in range(0x7fd80,0x7fdd8,8):
    cl=u(clsref)&MASK;ro=u(cl+32)&MASK
    owner=cstr(buf,u(ro+24)&MASK)
    base=u(ro+32)&MASK
    if not base:continue
    size=i(base)&0xffff;cnt=i(base+4)
    if size!=12 or cnt>1000:raise ValueError("unexpected original objc_methlist")
    for j in range(cnt):
      e=base+8+size*j
      name=cstr(buf,u(e+si(e))&MASK)
      found[(owner,name)]=e+8+si(e+8)
  return found
def audit(path):
  blob=Path(path).read_bytes()
  assert hashlib.sha256(blob).hexdigest()==SHA,"wrong original DEB"
  with tempfile.TemporaryDirectory() as td:
    subprocess.run(["dpkg-deb","-x",str(path),td],check=True)
    binary=Path(td)/"var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib"
    fat=binary.read_bytes()
    assert struct.unpack_from(">I",fat)[0]==0xcafebabe
    slices=[struct.unpack_from(">IIIII",fat,8+20*x)
            for x in range(struct.unpack_from(">I",fat,4)[0])]
    arm64=next((fat[o:o+n] for cpu,sub,o,n,align in slices
                if cpu==0x0100000c and sub==0),None)
    assert arm64 is not None
    funcs=parse(arm64)
    for key,imp in SELS.items():assert funcs.get(("SCPCarSplit",key))==imp,(key,funcs.get(("SCPCarSplit",key)))
    dump=subprocess.run(["llvm-objdump","--macho","--arch=arm64","--disassemble",str(binary)],
                        check=True,capture_output=True,text=True).stdout
    asm={int(m[1],16):m[2] for line in dump.splitlines()
         if (m:=re.match(r"^\s*([0-9a-f]+):\s*(.*)$",line))}
    for adr,name in CALLS.items():assert re.search(r"\bbl\b",asm.get(adr,"")),(hex(adr),name)
    for adr,required in [(0x2d524,"[x8, #0x18]"),(0x2dee4,"[x8, #0x18]"),
                         (0x2de60,"#12.00000000"),(0x1470c,"#0x2")]:
      assert required in asm[adr],(hex(adr),asm[adr])
    vals={hex(addr):struct.unpack_from("<d",arm64,addr)[0]
          for addr in [0x6f018,0x6f1c0,0x6f1c8,0x6f1d8,0x6f1e0]}
    assert abs(vals["0x6f018"]-.12)<1e-12
    assert abs(vals["0x6f1c8"]-.04)<1e-12
    return {"source_sha256":SHA,"verified_native_methods":{k:hex(v) for k,v in SELS.items()},
      "verified_call_addresses":{hex(a):name for a,name in CALLS.items()},
      "original_doubles":vals,"status":"ORIGINAL_DEB_STATIC_ONLY_NO_PATCH_NO_BUILD"}
if __name__=="__main__":
  if len(sys.argv)!=2:raise SystemExit("usage: python3 scripts/audit_original_edge_drag.py <original.deb>")
  print(json.dumps(audit(Path(sys.argv[1])),indent=2))
