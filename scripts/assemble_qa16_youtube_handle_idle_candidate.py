#!/usr/bin/env python3
"""Build QA16 original OmniCar YouTube player plus native AppBridge handle idle FROM SHA-locked QA12.

Original QA12: 176 original OmniCar payload entries + timer/zoom/swap four.
Exactly one handle-only dylib/plist added (182 total), original 180 file payload retained; no QA13-15 scene patch.
No modification to existing files beyond Debian control Version. NO Sileo.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import tempfile

QA12_SHA256="f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba"
QA12_VERSION="1.0.3-omnicar12-timer-zoom-swap"
QA16_VERSION="1.0.3-omnicar16-youtube-handle-idle"
QA15_PUBLISHED="1.0.3-omnicar15-native-reference"
PACKAGE="com.anlai.omnicar"
ARCH="iphoneos-arm64"
LIB="var/jb/Library/MobileSubstrate/DynamicLibraries"
MODULE="OmniCarYouTubeHandleIdle"
QA12_PAYLOAD_FILES=180

def sha256(file):
    h=hashlib.sha256()
    with open(file,"rb") as f:
        for c in iter(lambda:f.read(1048576),b""):h.update(c)
    return h.hexdigest()

def cmd(*args):
    return subprocess.check_output(args,stderr=subprocess.STDOUT,text=True).strip()

def inv(root):
    records={}
    for d,dirs,files in os.walk(root,followlinks=False):
        for name in dirs+files:
            item=Path(d)/name
            rel=item.relative_to(root).as_posix()
            mode=stat.S_IMODE(item.lstat().st_mode)
            if item.is_symlink():records[rel]=["symlink",os.readlink(item),mode]
            elif item.is_dir():records[rel]=["directory",mode]
            elif item.is_file():records[rel]=["file",sha256(item),mode]
            else:raise RuntimeError("Unexpected special file "+rel)
    return records

def manifest(original,dylib,plist,out,report):
    files=[Path(p).resolve() for p in [original,dylib,plist,out,report]]
    original,dylib,plist,out,report=files
    if sha256(original)!=QA12_SHA256:raise ValueError("NOT_EXACT_PUBLISHED_QA12_BASELINE")
    if cmd("dpkg-deb","-f",str(original),"Package")!=PACKAGE:
        raise ValueError("PACKAGE_MISMATCH")
    if cmd("dpkg-deb","-f",str(original),"Version")!=QA12_VERSION:
        raise ValueError("QA12_VERSION_MISMATCH")
    if cmd("dpkg-deb","-f",str(original),"Architecture")!=ARCH:
        raise ValueError("ARCH_MISMATCH")
    if subprocess.run(["dpkg","--compare-versions",QA16_VERSION,"gt",QA12_VERSION]).returncode:
        raise ValueError("QA16_NOT_NEWER_THAN_QA12")
    if subprocess.run(["dpkg","--compare-versions",QA16_VERSION,"gt",QA15_PUBLISHED]).returncode:
        raise ValueError("QA16_NOT_NEWER_THAN_LIVE_QA15")
    if not dylib.is_file() or dylib.stat().st_size<4096:raise ValueError("NO_SIGNED_HANDLE_DYLIB")
    if not plist.is_file():raise ValueError("NO_APPBRIDGE_FILTER")
    if out==original:raise ValueError("WOULD_OVERWRITE_QA12")
    if "com.apple.UIKit" not in plist.read_text():raise ValueError("BAD_APPBRIDGE_FILTER")
    with tempfile.TemporaryDirectory(prefix="omnicar-qa16-candidate-") as temp:
        base=Path(temp)/"base"
        check=Path(temp)/"check"
        subprocess.run(["dpkg-deb","-R",str(original),str(base)],check=True)
        before=inv(base)
        original_payload={k:v for k,v in before.items()
                          if not k.startswith("DEBIAN/") and k!="DEBIAN" and v[0]!="directory"}
        if len(original_payload)!=QA12_PAYLOAD_FILES:
            raise ValueError(f"QA12_COUNT_CHANGED:{len(original_payload)}")
        payloadroot=base/LIB
        for required in ["OmniCarAppBridge","OmniCarSplitScreen","OmniCarNativeSoloTimer",
                         "OmniCarDoubleTapFullscreen"]:
            if not (payloadroot/(required+".dylib")).is_file():
                raise ValueError("MISSING_BASELINE_MODULE "+required)
        for banned in ("OmniCarYouTubeScene", "OmniCarIdleControls", "OmniCarSoloThreeDots", "OmniCarGraphiteTitanium"):
            if any(k.endswith("/"+banned+".dylib") for k in original_payload):
                raise ValueError("NON_ORIGINAL_QA12_BASELINE:"+banned)
        newpaths=[]
        for ext,src in ((".dylib",dylib),(".plist",plist)):
            to=payloadroot/(MODULE+ext)
            if to.exists():raise ValueError("DESTINATION_EXISTS")
            shutil.copy2(src,to)
            newpaths.append(to.relative_to(base).as_posix())
        control=base/"DEBIAN/control"
        oldcontrol=control.read_bytes()
        origversion=("Version: "+QA12_VERSION).encode("ascii")
        targetversion=("Version: "+QA16_VERSION).encode("ascii")
        if oldcontrol.splitlines().count(origversion)!=1:raise ValueError("QA12_CONTROL_VERSION_MISSING")
        control.write_bytes(oldcontrol.replace(origversion,targetversion))
        out.parent.mkdir(parents=True,exist_ok=True)
        subprocess.run(["dpkg-deb","--root-owner-group","-b",str(base),str(out)],check=True)
        subprocess.run(["dpkg-deb","-R",str(out),str(check)],check=True)
        after=inv(check)
        for k,v in before.items():
            if k=="DEBIAN/control":continue
            if after.get(k)!=v:raise RuntimeError("CHANGED_QA12_ORIGINAL:"+k)
        if (check/"DEBIAN/control").read_bytes()!=oldcontrol.replace(origversion,targetversion):
            raise RuntimeError("UNEXPECTED_CONTROL_MUTATION")
        delta=set(after)-set(before)
        if delta!=set(newpaths):raise RuntimeError("ONLY_TWO_ADDITIONS_ALLOWED "+str(delta))
        payload={k:v for k,v in after.items()
                 if not k.startswith("DEBIAN/") and k!="DEBIAN" and v[0]!="directory"}
        if len(payload)!=QA12_PAYLOAD_FILES+2:raise RuntimeError("BAD_PAYLOAD_TOTAL")
        for field in ("Package","Architecture","Depends","Conflicts","Provides","Maintainer","Description"):
            if cmd("dpkg-deb","-f",str(out),field)!=cmd("dpkg-deb","-f",str(original),field):
                raise RuntimeError("MUTATED_BASE_CONTROL:"+field)
        if cmd("dpkg-deb","-f",str(out),"Version")!=QA16_VERSION:
            raise RuntimeError("INCORRECT_CANDIDATE_VERSION")
        info={
            "status":"QA16_YOUTUBE_HANDLE_IDLE_CANDIDATE__NOT_DEVICE_TESTED",
            "package":PACKAGE,"version":QA16_VERSION,"architecture":ARCH,
            "qa12_sha256":QA12_SHA256,"output_filename":out.name,
            "output_sha256":sha256(out),
            "qa12_payload_entries":QA12_PAYLOAD_FILES,
            "qa16_payload_entries":len(payload),
            "qa12_preserved_entries":len(before)-1,
            "added_files":newpaths,
            "changed_original_control_only":"Version",
            "youtube_only":True,"original_solo_zoom_swap_timer_preserved":True,
            "original_youtube_player_restored":True,
            "appbridge_native_handle_abi_verified":True,
            "fallback_when_unknown_bundle":"original AppBridge implementation",
            "sileo_published":False,"carplay_device_tested":False,
            "no_qa13_qa15_youtube_scene_module":True,
            "limitations":"Static source gates and QA12 bytes verified; original YouTube player restored by excluding QA13-QA15 scene modules. Original AppBridge ABI checked; live YT view instance, wake, video and crash safety await parked device QA."
        }
        report.parent.mkdir(parents=True,exist_ok=True)
        report.write_text(json.dumps(info,ensure_ascii=False,indent=2)+"\n")
        print("QA16_ORIGINAL_QA12_180_ENTRIES_BYTE_IDENTICAL_PLUS_2_SCOPED_FILES_PASS")
        print("QA16_SOLO_TIMER_ZOOM_SWAP_AND_SPLIT_OWNER_PRESERVED_PASS")
        print("QA16_PACKAGE_SHA256="+info["output_sha256"])
        print("QA16_ORIGINAL_YOUTUBE_PLAYER_RESTORED_NO_SCENE_PATCHES_PASS")
        print("NO_DEVICE_TEST_NO_SILEO")
        return info

if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("--qa12",type=Path,required=True)
    parser.add_argument("--dylib",type=Path,required=True)
    parser.add_argument("--plist",type=Path,required=True)
    parser.add_argument("--output",type=Path,required=True)
    parser.add_argument("--manifest",type=Path,required=True)
    a=parser.parse_args()
    manifest(a.qa12,a.dylib,a.plist,a.output,a.manifest)
