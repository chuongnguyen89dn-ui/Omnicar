#!/usr/bin/env python3
"""Read-only original OmniCar 1.0.3 UI scene/frame/transform audit.

Traces sender SCPCarSplit -> receiver ABHost from the immutable original DEB.
No injected hooks, preference writes, code patches, installation or Sileo.
"""
import argparse
import hashlib
import json
import re
import struct
import subprocess
import tempfile
from pathlib import Path

DEB_SHA="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
LIB_DIR=Path("var/jb/Library/MobileSubstrate/DynamicLibraries")
METHODS={
 "OmniCarAppBridge.dylib":{
  "ABHost.zoom":(0xae20,0xae94),
  "ABHost.openApp:frame:":(0xb8a0,0xbccc),
  "ABHost.layoutPane:":(0xec80,0xf0a0),
  "ABHost.effectiveOrientation:":(0xf364,0xf54c),
  "ABHost.setFrame:forApp:live:handle:passInsets:":(0xfe68,0x101b0),
 },
 "OmniCarSplitScreen.dylib":{
  "SCPCarSplit.hostFrameForPane:":(0x3ca0c,0x3cd60),
  "SCPCarSplit.hostBarInfoForPane:":(0x3cd60,0x3d1e4),
  "SCPCarSplit.hostPassInsetsForPane:":(0x3d1e4,0x3d39c),
  "SCPCarSplit.hostFrameInfo:pane:live:handle:":(0x3d39c,0x3dfac),
  "SCPCarSplit.sendHostFrameForPane:live:":(0x3dfac,0x3e490),
 },
}
KEYWORDS=("CGAffineTransformMakeScale", "CGAffineTransformIdentity", "_updateReferenceSize",
          "setBounds:", "setFrame:", "setTransform:", "setAffineTransform:", "setCenter:",
          "setNeedsLayout", "layoutIfNeeded", "sizeClass", "traitCollection",
          "sceneBox", "referenceSize", "passInsets", "orientation", "layoutPane:")
SYSTEM_EVENTS=("com.anlai.omnicar/appbridge.frame","com.anlai.omnicar/appbridge.open")

def sha256(p):
 h=hashlib.sha256()
 with Path(p).open("rb") as f:
  for chunk in iter(lambda:f.read(1048576),b""):h.update(chunk)
 return h.hexdigest()

def fat_arm64(data):
 if len(data)<8 or struct.unpack_from(">I",data,0)[0]!=0xcafebabe:
  raise ValueError("Expected unmodified fat Mach-O")
 n=struct.unpack_from(">I",data,4)[0]
 if n>8:raise ValueError("Unexpected FAT headers")
 for i in range(n):
  cpu,sub,offset,size,_=struct.unpack_from(">IIIII",data,8+20*i)
  if cpu==0x0100000c and sub==0:
   return data[offset:offset+size]
 raise ValueError("Missing ARM64 slice")

def parse_disassembly(text):
 pattern=re.compile(r"^\s*([0-9a-fA-F]+):\s*(.+)$")
 d={}
 for line in text.splitlines():
  m=pattern.match(line)
  if m:d[int(m.group(1),16)]=m.group(2).strip()
 return d

def audit(deb):
 if sha256(deb)!=DEB_SHA:raise ValueError("Unverified original DEB")
 with tempfile.TemporaryDirectory(prefix="omnicar-scene-readonly-") as td:
  root=Path(td)
  subprocess.run(["dpkg-deb","-x",str(Path(deb).resolve()),str(root)],check=True)
  libraries={}
  for filename,methods in METHODS.items():
   path=root/LIB_DIR/filename
   data=path.read_bytes()
   arm=fat_arm64(data)
   out=subprocess.check_output(["llvm-objdump","--macho","--arch=arm64",
                                "--disassemble",str(path)],text=True)
   decoded=parse_disassembly(out)
   windows={}
   for name,(start,end) in methods.items():
    lines=[{"pc":hex(pc),"asm":decoded[pc]} for pc in range(start,end,4) if pc in decoded]
    if not lines or lines[0]["pc"]!=hex(start):
     raise AssertionError(f"Invalid exact original method offset: {filename} {name}")
    callsites=[v for v in lines if re.search(r"\b(?:bl|blr|br)\b",v["asm"])]
    matches=[v for v in lines if any(w.lower() in v["asm"].lower() for w in KEYWORDS)]
    windows[name]={"start":hex(start),"end_exclusive":hex(end),
                   "instruction_count":len(lines),"calls":callsites,
                   "layout_symbol_matches":matches,"full_disassembly":lines}
   strings=re.findall(rb"[\x20-\x7e]{5,}",arm)
   signals=sorted({s.decode("ascii","replace") for s in strings if
                any(k.lower().encode("ascii") in s.lower() for k in
                    ("referenceSize","appBridgeZoom","appBridgeOrientation","sceneBox",
                     "layoutPane","updateReferenceSize","appbridge.frame","appbridge.open",
                     "setFrame:forApp","setupHandleForPane","hostHandle","effectiveOrientation"))})
   libraries[filename]={"fat_sha256":hashlib.sha256(data).hexdigest(),
                        "arm64_size":len(arm),
                        "selected_strings":signals,
                        "methods":windows}
  a=libraries["OmniCarAppBridge.dylib"]["methods"]
  b=libraries["OmniCarSplitScreen.dylib"]["methods"]
  scale=a["ABHost.layoutPane:"]["layout_symbol_matches"]
  if not any("CGAffineTransformMakeScale" in e["asm"] for e in scale):
   raise AssertionError("Expected CGAffineTransformMakeScale path absent: verify symbol/address")
  if not a["ABHost.setFrame:forApp:live:handle:passInsets:"]["calls"]:
   raise AssertionError("setFrame native method not decoded")
  return {"status":"ORIGINAL_MACHINE_CODE_READ_ONLY_NOT_LIVE_SCENE_MEASUREMENT",
          "input_deb_sha256":DEB_SHA,"libraries":libraries,
          "proven_scope":"ABHost has scale transform and frame/orientation code; SCPCarSplit sends host frame.",
          "not_proven":"Actual YouTube scene bounds, live zoom, native size class, 3-dot ownership or exact wrong frame are not observable from the DEB alone.",
          "next":"Observe bundle-scoped YouTube/another bridged app bounds, ABHost sceneBox and referenceSize before changing compositor or user app."}

def selftest():
 demo="  000000000000ec80: aa bb cc dd  bl  0x12 ; symbol stub for: _CGAffineTransformMakeScale\n  000000000000ec84: aa bb cc dd  fdiv d0, d1, d2\n"
 got=parse_disassembly(demo)
 assert 0xec80 in got and "MakeScale" in got[0xec80]
 assert not parse_disassembly("unrelated")
 print("APPBRIDGE_SCENE_AUDIT_SELFTEST_PASS")

if __name__=="__main__":
 cli=argparse.ArgumentParser()
 cli.add_argument("original",nargs="?",type=Path)
 cli.add_argument("--output",type=Path)
 cli.add_argument("--selftest",action="store_true")
 x=cli.parse_args()
 if x.selftest:selftest()
 else:
  if not x.original or not x.output:cli.error("original and --output are required")
  info=audit(x.original)
  x.output.parent.mkdir(parents=True,exist_ok=True)
  x.output.write_text(json.dumps(info,ensure_ascii=False,indent=2),encoding="utf8")
  for lib,item in info["libraries"].items():
   print("MACHO_FILE",lib,item["fat_sha256"])
   for name,method in item["methods"].items():
    print("SCENE_OWNER",name,"calls",len(method["calls"]),
          "matches",len(method["layout_symbol_matches"]))
    for z in method["layout_symbol_matches"]:
     print("  UI_PATH",z["pc"],z["asm"])
  print("ORIGINAL_OMNICAR_APPBRIDGE_FRAME_SCENE_STATIC_AUDIT_PASS")
