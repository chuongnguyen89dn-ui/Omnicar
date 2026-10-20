#!/usr/bin/env python3
"""Read-only owner audit: OmniCar floating dual-tile / native dock button.

Accepts ONLY original SHA-verified 1.0.3 package. Does not execute package
maintainer scripts, alter binaries, build a DEB or touch system UI.
"""
from pathlib import Path
import hashlib, json, re, struct, subprocess, sys, tempfile
from audit_original_edge_drag import parse
SHA="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
Q=re.compile(r"home|dock|dashboard|launcher|float|tab|switch|layout|attach|overlay|button|split|statusbar",re.I)
def macho_arm64(b):
    if len(b)<8 or struct.unpack_from(">I",b)[0]!=0xcafebabe:
        raise ValueError("not original fat Mach-O")
    n=struct.unpack_from(">I",b,4)[0]
    for k in range(n):
        cpu,sub,o,sz,_=struct.unpack_from(">IIIII",b,8+20*k)
        if cpu==0x0100000c and sub==0:
            out=b[o:o+sz]
            if struct.unpack_from("<I",out)[0]!=0xfeedfacf:
                raise ValueError("not ARM64 Mach-O")
            return out
    raise ValueError("no ARM64 original slice")

def run(path):
    data=Path(path).read_bytes()
    assert hashlib.sha256(data).hexdigest()==SHA,"wrong OmniCar 1.0.3 DEB hash"
    with tempfile.TemporaryDirectory() as d:
        subprocess.run(["dpkg-deb","-x",str(path),d],check=True)
        root=Path(d)/"var/jb/Library/MobileSubstrate/DynamicLibraries"
        owner=root/"OmniCarSplitScreen.dylib"
        assert owner.exists(),"missing original split dylib"
        fat=owner.read_bytes()
        b=macho_arm64(fat)
        methods=parse(b)
        entries=sorted([{"class":cl,"selector":selector,"arm64_imp":hex(pc)}
                        for (cl,selector),pc in methods.items() if Q.search(cl+"."+selector)],
                       key=lambda a:(a["class"],a["selector"]))
        # Save representative symbol declarations from all six original dylibs.
        binaries=[]
        for lib in sorted(root.glob("*.dylib")):
            raw=lib.read_bytes()
            hits=[]
            for match in re.finditer(rb"[ -~]{5,180}",raw):
                value=match.group(0).decode("ascii","replace")
                if Q.search(value) and len(value)<144 and (
                    "Home" in value or "Dock" in value or "Dashboard" in value or
                    "home" in value or "dock" in value or "dashboard" in value or
                    "Launcher" in value):
                    hits.append(value)
            binaries.append({"file":lib.name,"size":len(raw),
                             "strings":list(dict.fromkeys(hits))[:100]})
        asm=subprocess.run(["llvm-objdump","--macho","--arch=arm64","--disassemble",str(owner)],
                           text=True,capture_output=True,check=True).stdout
        instructions={}
        for line in asm.splitlines():
            mat=re.match(r"^\s*([0-9a-fA-F]+):\s*(.*)$",line)
            if mat:instructions[int(mat[1],16)]=mat[2]
        candidates={}
        for (cl,sel),pc in methods.items():
            if not Q.search(sel) or not Q.search(sel):continue
            if not re.search(r"home|dock|dashboard|launcher|float|tab|statusbar",sel,re.I):continue
            if cl not in ("SCPCarSplit","SCPCarRoot","SCPCarDashboard","SCPCarPane"):continue
            instr=[{"pc":hex(a),"instruction":instructions[a]}
                   for a in range(pc,pc+0x100,4) if a in instructions]
            candidates[cl+"."+sel]={"imp":hex(pc),"first_256_bytes":instr}
        return {"status":"ORIGINAL_DEB_READONLY_UI_OWNER_AUDIT__NO_RUNTIME_CLAIM",
                "source_sha256":SHA,"observed_photo":"User screenshot: round dual-blue-rect glyph at upper-right Dashboard search tile while left CarPlay dock shows app grid",
                "split_methods_count":len(methods),"matching_objc_methods":entries,
                "selected_method_disassembly":candidates,
                "original_dylib_button_related_strings":binaries,
                "limitations":"No runtime view tree or user touch trace; static names and nearby instructions cannot alone prove placement changes or ownership in Apple CarPlay app."}
if __name__=="__main__":
    if len(sys.argv)!=2:raise SystemExit("usage: python3 scripts/audit_dashboard_dual_tile_owner.py original.deb")
    print(json.dumps(run(sys.argv[1]),ensure_ascii=False,indent=2))
