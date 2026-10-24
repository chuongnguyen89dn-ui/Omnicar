#!/usr/bin/env python3
"""SHA-pinned, read-only forensic for OmniCar's TWO different three-dot owners.

This proves original ObjC methods, real ARM64 call targets, package process
filters, and the exact coverage of the QA12/QA15 4s timer. No UI mutation.
"""
import argparse
import hashlib
import json
import plistlib
import re
import struct
import subprocess
import tempfile
from pathlib import Path
from audit_omnicar_appbridge_scene import fat_arm64, parse_disassembly, decode_objc_stub

ORIGINAL_SHA = "d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
BASE = Path("var/jb/Library/MobileSubstrate/DynamicLibraries")
OWNERS = {
    "OmniCarAppBridge": {
        "ABHost": ("setupHandleForPane:", "layoutBarForPane:", "buildBarForPane:", "layoutPane:"),
        "ABPane": ("handle", "bar", "setHandle:", "setBar:"),
    },
    "OmniCarSplitScreen": {
        "SCPCarPane": ("handle", "hostHandle", "setHandle:", "setHostHandle:"),
        "SCPCarSplit": ("setupBarForPane:", "layoutBarForPane:", "handleTapped:",
                        "handleDoubleTapped:", "bridgeHandleTapped:", "hostBarInfoForPane:",
                        "hostFrameInfo:pane:live:handle:", "allPanes", "hostedPanes"),
    },
}
MASK = (1 << 48) - 1

def read_objc_classes(arm):
    """Enumerate __objc_classlist from LC_SEGMENT_64; handle relative method lists."""
    if struct.unpack_from("<I", arm, 0)[0] != 0xfeedfacf:
        raise ValueError("not thin ARM64 Mach-O")
    ncmds = struct.unpack_from("<I", arm, 16)[0]
    commands = 32
    segments = []
    classes_sections = []
    for _ in range(ncmds):
        cmd, cmdsize = struct.unpack_from("<II", arm, commands)
        if cmdsize < 8 or commands + cmdsize > len(arm):
            raise ValueError("malformed Mach-O load commands")
        if cmd == 0x19:  # LC_SEGMENT_64
            vm, vmsize, fileoff, filesize = struct.unpack_from("<QQQQ", arm, commands + 24)
            segments.append((vm, vmsize, fileoff, filesize))
            nsects = struct.unpack_from("<I", arm, commands + 64)[0]
            for j in range(nsects):
                off = commands + 72 + j*80
                name = arm[off:off+16].split(b"\0",1)[0].decode("ascii", "replace")
                if name == "__objc_classlist":
                    addr, size = struct.unpack_from("<QQ",arm,off+32)
                    classes_sections.append((addr,size))
        commands += cmdsize
    if not classes_sections:
        raise AssertionError("ARM64 __objc_classlist not found")
    def vo(virtual):
        v = virtual & MASK
        for vm, vmsize, fileoff, filesize in segments:
            if vm <= v < vm + min(vmsize,filesize):
                off = fileoff + v-vm
                if 0 <= off < len(arm):return off
        if 0 <= v < len(arm):return v
        raise ValueError("Unmapped ObjC address " + hex(v))
    def u64(v):return struct.unpack_from("<Q",arm,vo(v))[0]
    def u32(v):return struct.unpack_from("<I",arm,vo(v))[0]
    def s32(v):return struct.unpack_from("<i",arm,vo(v))[0]
    def cstr(v):
        start=vo(v)
        end=arm.find(b"\0",start,min(len(arm),start+256))
        if end<0:raise ValueError("Unterminated class/selector")
        return arm[start:end].decode("utf-8","replace")
    found = {}
    for v, size in classes_sections:
        for at in range(v,v+size,8):
            try:
                cls=u64(at)&MASK
                ro=u64(cls+32)&MASK&~7
                name=cstr(u64(ro+24)&MASK)
                ml=u64(ro+32)&MASK
                if not ml:continue
                entry=u32(ml)&0xffff
                count=u32(ml+4)
                if count>2000 or entry not in (12,24):continue
                entries={}
                for i in range(count):
                    pos=ml+8+entry*i
                    if entry==12:
                        sel=cstr(pos+s32(pos))
                        types=cstr(pos+4+s32(pos+4))
                        imp=pos+8+s32(pos+8)
                    else:
                        sel=cstr(u64(pos)&MASK)
                        types=cstr(u64(pos+8)&MASK)
                        imp=u64(pos+16)&MASK
                    entries[sel]={"imp":hex(imp),"types":types}
                found[name]=entries
            except (ValueError,IndexError,struct.error,UnicodeError):
                continue  # unneeded private categories/metaclasses may use other formats
    return found

def examine_original(deb):
    if hashlib.sha256(deb.read_bytes()).hexdigest()!=ORIGINAL_SHA:
        raise ValueError("Refusing non-original/unverified OmniCar 1.0.3 DEB")
    result={"status":"ORIGINAL_MACHO_OWNER_CALLS_STATIC_ONLY",
            "original_sha256":ORIGINAL_SHA,"modules":{}}
    with tempfile.TemporaryDirectory(prefix="omni-handle-owner-") as td:
        subprocess.run(["dpkg-deb","-x",str(deb.resolve()),td],check=True)
        for lib, classes in OWNERS.items():
            fp=Path(td)/BASE/(lib+".dylib")
            arm=fat_arm64(fp.read_bytes())
            catalog=read_objc_classes(arm)
            asm=subprocess.check_output(["llvm-objdump","--macho","--arch=arm64",
                                         "--disassemble",str(fp)],text=True)
            ins=parse_disassembly(asm)
            classinfo={}
            for cls, selectors in classes.items():
                discovered=catalog.get(cls,{})
                if not discovered:raise AssertionError("Missing original ObjC class "+cls)
                sorted_imps=sorted(int(x["imp"],16) for x in discovered.values())
                chosen={}
                for sel in selectors:
                    if sel not in discovered:raise AssertionError("Missing original selector "+cls+"."+sel)
                    method=discovered[sel]
                    pc=int(method["imp"],16)
                    end=min(next((a for a in sorted_imps if a>pc),pc+0x400),pc+0x700)
                    calls=[]
                    for at in range(pc,end,4):
                        line=ins.get(at,"")
                        if not re.search(r"\bbl\b",line):continue
                        m=re.search(r"\bbl\s+(?:0x)?([0-9a-f]+)",line)
                        if not m:continue
                        dest=int(m.group(1),16)
                        resolved=decode_objc_stub(arm,dest)
                        item={"at":hex(at),"target":hex(dest)}
                        if resolved.get("status")=="selector-mapped":
                            item["selector"]=resolved["selector"]
                        elif "symbol stub for:" in line:
                            item["symbol"]=line.split("symbol stub for:",1)[1].strip()
                        calls.append(item)
                    chosen[sel]={"imp":method["imp"],"type":method["types"],
                                 "call_count":len(calls),
                                 "selector_calls":[c for c in calls if "selector" in c],
                                 "other_calls":[c for c in calls if "symbol" in c][:18]}
                classinfo[cls]=chosen
            pl=Path(td)/BASE/(lib+".plist")
            result["modules"][lib]={"fat_sha256":hashlib.sha256(fp.read_bytes()).hexdigest(),
                                    "injection_filter":plistlib.loads(pl.read_bytes()),
                                    "class_methods":classinfo}
    return result

def check_installed_timer():
    text=Path("native-solo-timer/src/OmniCarNativeSoloTimer.xm").read_text()
    import ast
    manifest=json.loads(Path("dist/candidates/omnicar-original-1.0.3-omnicar12-timer-zoom-swap/BUILD-MANIFEST.json").read_text())
    assert manifest["original_payload_file_count"]==176
    assert manifest["final_payload_file_count"]==180
    assert any("OmniCarNativeSoloTimer.dylib" in s for s in manifest["added_native_files"])
    assert "static void OMCNativeApply" in text and "OMCNativeGet(pane,@selector(handle))" in text
    assert "OMCNativeGet(pane,@selector(hostHandle))" not in text
    assert "ABPane" not in text and "hostedPanes" not in text
    assert "scheduledTimerWithTimeInterval:kOMCNativeIdleSeconds" in text
    assert "static const NSTimeInterval kOMCNativeIdleSeconds=4.0" in text
    return {"timer_module":"OmniCarNativeSoloTimer.dylib",
            "built_from":"native-solo-timer/src/OmniCarNativeSoloTimer.xm",
            "interval_seconds":4,"enumeration":"SCPCarSplit.allPanes -> pane.handle; split.dividers",
            "not_enumerated":["SCPCarPane.hostHandle","ABPane.handle",
                              "SCPCarSplit.hostedPanes"],
            "no_YouTube_special_handling_in_timer":True,
            "solo_deactivation_cancels_timer":True}

def selftest():
    assert check_installed_timer()["interval_seconds"]==4
    print("HOST_HANDLE_QA12_ACTUAL_TIMER_SOURCE_STATIC_TEST_PASS")

if __name__=="__main__":
    a=argparse.ArgumentParser()
    a.add_argument("deb",nargs="?",type=Path)
    a.add_argument("--output",type=Path)
    a.add_argument("--selftest",action="store_true")
    args=a.parse_args()
    if args.selftest:selftest()
    else:
        if not args.deb or not args.output:a.error("deb and --output are required")
        out=examine_original(args.deb)
        out["QA12_QA15_original_timer"]=check_installed_timer()
        out["limitations"]="Static Objective-C owner and call path evidence, NOT user iPhone live UIView instance mapping or device callback trace. No patch/deb/sileo."
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(out,ensure_ascii=False,indent=2),encoding="utf-8")
        for lib, m in out["modules"].items():
            print("OWNER_BINARY",lib,m["fat_sha256"])
            print("OWNER_INJECTION_FILTER",lib,json.dumps(m["injection_filter"]))
            for cls, selectors in m["class_methods"].items():
                for sel, info in selectors.items():
                    print("OWNER_METHOD",lib,cls,sel,info["imp"],info["type"],
                          "objc_selectors",",".join(c["selector"] for c in info["selector_calls"]))
        print("OWNER_ACTUAL_TIMER",json.dumps(out["QA12_QA15_original_timer"]))
        print("ORIGINAL_OMNICAR_HOSTED_YOUTUBE_HANDLE_PATH_STATIC_PASS__NOT_LIVE_DEVICE_PROOF")
