#!/usr/bin/env python3
"""Reproducible READ-ONLY ARM64 timer audit of *original* OmniCar 1.0.3.
Requires dpkg-deb, llvm-objdump, original DEB. Never patch any dylib.
Run: python3 scripts/audit_original_omnicar_timers.py /path/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb
"""
import hashlib
import json
import plistlib
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

CHECKSUM="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
# Owner, load instruction addr, NSTimer call addr, interval and repeating.
CALLS={
 "ratioMenu":("OmniCarSplitScreen.dylib","showRatioMenuForDivider:",0x2ff78,0x2ff88,4,False),
 "paneBar":("OmniCarSplitScreen.dylib","setBarVisible:forPane:",0x24424,0x24434,4,False),
 "appTray":("OmniCarSplitScreen.dylib","restartTrayTimer",0x3bca4,0x3bcb4,4,False),
 "trustedTimeSync":("OmniCarCore.dylib","_OMCTrustedTimeStart",0x4524,0x452c,21600,True),
 "expiryWatch":("OmniCarCore.dylib","_OMCTrustedTimeStart",0x4544,0x4550,60,True)
}
def insn(asm,adr):
    lines=re.findall(r"^\s*"+f"{adr:x}"+r":[^\n]*",asm,re.M)
    assert len(lines)==1,(adr,len(lines))
    return lines[0].strip()
def inspect(original):
    assert hashlib.sha256(original.read_bytes()).hexdigest()==CHECKSUM,"Wrong package/hash"
    with tempfile.TemporaryDirectory() as d:
        subprocess.run(["dpkg-deb","-x",str(original),d],check=True)
        root=Path(d)
        dylibs=root/"var/jb/Library/MobileSubstrate/DynamicLibraries"
        asm={}
        for binary in sorted({c[0] for c in CALLS.values()}):
            asm[binary]=subprocess.run(["llvm-objdump","--macho","--arch=arm64",
              "--disassemble",str(dylibs/binary)],check=True,
              text=True,capture_output=True).stdout
        results=[]
        for label,(binary,owner,load,call,seconds,repeat) in CALLS.items():
            inst=insn(asm[binary],load)
            target=insn(asm[binary],call)
            assert "bl\t" in target,(label,target)
            if seconds==4:assert "fmov\td0, #4.00000000" in inst,inst
            elif seconds==21600:assert "ldr\td0, [x8, #0xab0]" in inst,inst
            elif seconds==60:assert "#0x404e000000000000" in inst,inst
            results.append(dict(label=label,binary=binary,owner=owner,seconds=seconds,
                repeats=repeat,load_addr=f"0x{load:x}",call_addr=f"0x{call:x}",
                load=inst,call=target))
        startup=root/"var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/FeatureStartupScreen.plist"
        items=plistlib.loads(startup.read_bytes())["items"]
        pref=lambda key:next(x for x in items if x.get("key")==key)
        assert b"2027-04-30" in (dylibs/"OmniCarCore.dylib").read_bytes()
        assert b"trustedTime" in (dylibs/"OmniCarCore.dylib").read_bytes()
        core=asm["OmniCarCore.dylib"]
        assert "_OMCExpired" in insn(core,0x44b8)
        assert "_OMCExpired" in insn(core,0x4674)
        assert "_OMCExpired" in insn(core,0x65a8)
        # Mach-O fat arm64 slice begins at offset 0x4000 for *this hashed original*.
        raw=(dylibs/"OmniCarCore.dylib").read_bytes()
        assert struct.unpack_from("<d",raw,0x4000+0xfab0)[0]==21600
        data=dict(original_sha256=CHECKSUM,method="static original ARM64 disassembly",
             ui_timers=results[:3],core_repeating_timers=results[3:],
             splash=dict(default_seconds=pref("startupScreenDuration")["default"],
                         min_seconds=pref("startupScreenDuration")["min"],
                         max_seconds=pref("startupScreenDuration")["max"],
                         play_full_video_default=pref("startupScreenPlayFull")["default"],
                         tap_to_skip_default=pref("startupScreenTapToSkip")["default"]),
             expiry=dict(check="_OMCExpired",deadline_literal="2027-04-30",
                         trusted_time_pref="trustedTime",
                         domain="com.anlai.omnicar",
                         expiry_check_addr="0xc414",
                         first_check="0x44b8",repeat_check="0x4674",
                         gate_check="0x65a8",
                         note="No evidence of specific user-device expiry state or UI visibility."))
        return data
if __name__=="__main__":
    if len(sys.argv)!=2:raise SystemExit("Usage: audit_original_omnicar_timers.py ORIGINAL.deb")
    print(json.dumps(inspect(Path(sys.argv[1])),indent=2,ensure_ascii=False))
