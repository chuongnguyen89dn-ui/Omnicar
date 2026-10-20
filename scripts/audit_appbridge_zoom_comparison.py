#!/usr/bin/env python3
"""Read-only native OmniCar 1.0.3 global AppBridge zoom analysis; no app execution."""
import argparse,hashlib,json,plistlib,re,struct,subprocess,tempfile
from pathlib import Path
EXPECTED="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
RANGES={"ABHost.zoom":(0xae20,0xaea0),"ABHost.openApp:frame:":(0xb8a0,0xb9c0),
 "ABHost.layoutPane:":(0xec80,0xedb0),"ABHost.effectiveOrientation:":(0xf364,0xf490),
 "ABHost.setFrame:forApp:live:handle:passInsets:":(0xfe68,0xffe0)}
PREFS=("appBridgeZoom","appBridgeOrientation","splitScreenPaneOrientation")
BUNDLES=("com.google.ios.youtube","com.google.Maps","com.apple.Maps","com.zhiliaoapp.musically")
def arm64_slice(b):
    magic,count=struct.unpack_from(">II",b)
    assert magic==0xcafebabe,(hex(magic),count)
    for k in range(count):
        cpu,sub,off,n,align=struct.unpack_from(">IIIII",b,8+20*k)
        if cpu==0x100000c and sub==0:return b[off:off+n]
    raise RuntimeError("missing arm64")
def audit(deb):
    assert hashlib.sha256(deb.read_bytes()).hexdigest()==EXPECTED,"original DEB mismatch"
    with tempfile.TemporaryDirectory() as td:
        root=Path(td)
        subprocess.run(["dpkg-deb","-x",str(deb),td],check=True)
        lib=root/"var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib"
        assert lib.exists()
        fat=lib.read_bytes()
        arm=arm64_slice(fat)
        strings=[s.decode("ascii","replace") for s in re.findall(rb"[\x20-\x7e]{4,}",arm)]
        matched=sorted(set(s for s in strings if any(x.lower() in s.lower() for x in PREFS)))
        bundle_hits={b:any(b.lower() in s.lower() for s in strings) for b in BUNDLES}
        matched_plists=[]
        for p in root.rglob("*.plist"):
            try:obj=plistlib.loads(p.read_bytes())
            except Exception:continue
            stack=[("",obj)]
            while stack:
                prefix,v=stack.pop()
                if isinstance(v,dict):
                    stack.extend((prefix+"."+str(k),val) for k,val in v.items())
                elif isinstance(v,list):
                    stack.extend((prefix+"["+str(i)+"]",val) for i,val in enumerate(v))
                elif any(x.lower() in (prefix+" "+str(v)).lower() for x in PREFS):
                    matched_plists.append({"file":p.relative_to(root).as_posix(),"key":prefix,"value":str(v)[:256]})
        injected={}
        for name in ("OmniCarAppBridge","OmniCarSplitScreen"):
            path=root/("var/jb/Library/MobileSubstrate/DynamicLibraries/"+name+".plist")
            injected[name]=plistlib.loads(path.read_bytes()) if path.exists() else None
        dump=subprocess.check_output(["llvm-objdump","--macho","--arch=arm64","--disassemble",str(lib)],text=True)
        ins={}
        for line in dump.splitlines():
            m=re.match(r"^\s*([0-9a-fA-F]+):\s*(.*)$",line)
            if m:ins[int(m.group(1),16)]=m.group(2).strip()
        fragments={name:[{"pc":hex(x),"asm":ins[x]} for x in range(start,end,4) if x in ins]
            for name,(start,end) in RANGES.items()}
        constants={}
        for n in (.6,1.,100.):
            token=struct.pack("<d",n)
            constants[str(n)]=[hex(m.start()) for m in re.finditer(re.escape(token),arm)][:25]
        return {"status":"ORIGINAL_DEB_STATIC_ONLY_NOT_A_LIVE_PER_APP_PROFILE",
          "source_sha256":EXPECTED,"appbridge_binary_sha256":hashlib.sha256(fat).hexdigest(),
          "strings_with_shared_bridge_pref_keys":matched,
          "app_bundle_literals_found_in_binary":bundle_hits,
          "pref_entries_in_original_plists":matched_plists,
          "tweak_injection_filter_plists":injected,
          "zoom_double_literal_offsets":constants,
          "arm64_disassembly_selected_ABHost_methods":fragments,
          "careful_interpretation":[
            {"case":"Native CarPlay map (if native)","ABHost zoom":"Not applicable","app-specific effect":"Native CarPlay scene geometry"},
            {"case":"YouTube through AppBridge","ABHost zoom":"One shared zoom accessor clamps .6 to 1.0","app-specific effect":"Reference size, host frame, orientation, responsive YouTube UI"},
            {"case":"TikTok/other iPhone app through AppBridge","ABHost zoom":"Same shared accessor when same bridge path","app-specific effect":"Its own scene/layout differs from YouTube"},
            {"case":"Map launched through AppBridge","ABHost zoom":"Same shared accessor when bridged","app-specific effect":"Not same as native CarPlay Maps"}
          ],
          "limitation":"The original package cannot reveal live individual device preference values, current app zoom, or other installed tweaks; no bundle-specific override proven by this scan."}
if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("deb",type=Path)
    parser.add_argument("--out",type=Path,required=True)
    args=parser.parse_args()
    d=audit(args.deb)
    args.out.parent.mkdir(parents=True,exist_ok=True)
    args.out.write_text(json.dumps(d,ensure_ascii=False,indent=2),encoding="utf8")
    assert d["strings_with_shared_bridge_pref_keys"]
    assert d["arm64_disassembly_selected_ABHost_methods"]["ABHost.zoom"]
    print("APPBRIDGE_GLOBAL_ZOOM_READONLY_AUDIT_PASS")
    print("PREF_ENTRIES",json.dumps(d["pref_entries_in_original_plists"],ensure_ascii=False)[:9000])
    print("BUNDLE_LITERALS",json.dumps(d["app_bundle_literals_found_in_binary"]))
    print("SHARED_KEYS",json.dumps(d["strings_with_shared_bridge_pref_keys"]))
    print("ABHOST_ZOOM")
    for t in d["arm64_disassembly_selected_ABHost_methods"]["ABHost.zoom"]:print(t["pc"],t["asm"])
