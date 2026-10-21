#!/usr/bin/env python3
"""QA12 emergency correction: original native Solo + native timer + Zoom/Swap.

The user requires Zoom and left/right Swap retained; QA11 incorrectly omitted them.
All 176 original files are byte-identical; only Debian Version changes;
add exactly 2 separate signed modules (timer and 2-action Zoom/Swap), 4 files.
No custom SOLO addon or experimental idle addon.
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

ORIGINAL_SHA256="d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
PACKAGE="com.anlai.omnicar"
VERSION="1.0.3-omnicar12-timer-zoom-swap"
ORIG_VERSION="1.0.3"
ARCH="iphoneos-arm64"
NATIVE_DIR="var/jb/Library/MobileSubstrate/DynamicLibraries"
MODULE="OmniCarNativeSoloTimer"
ZOOM_MODULE="OmniCarDoubleTapFullscreen"
ORIGINAL_PAYLOAD_COUNT=176

def sha256(path):
    h=hashlib.sha256()
    with Path(path).open("rb") as f:
        for chunk in iter(lambda:f.read(1048576),b""):h.update(chunk)
    return h.hexdigest()

def cmd(*args):
    return subprocess.check_output(args,text=True,stderr=subprocess.STDOUT).strip()

def inventory(root):
    items={}
    for directory,subdirs,files in os.walk(root,followlinks=False):
        for name in subdirs+files:
            file=Path(directory)/name
            key=file.relative_to(root).as_posix()
            m=file.lstat()
            mode=stat.S_IMODE(m.st_mode)
            if file.is_symlink():items[key]=["link",os.readlink(file),mode]
            elif file.is_dir():items[key]=["dir",mode]
            elif file.is_file():items[key]=["file",sha256(file),mode]
            else:raise RuntimeError(f"Unexpected special file {key}")
    return items

def verify_original(deb):
    if sha256(deb)!=ORIGINAL_SHA256:raise ValueError("Wrong exact original OmniCar DEB")
    expected={"Package":PACKAGE,"Version":ORIG_VERSION,"Architecture":ARCH}
    for field,value in expected.items():
        if cmd("dpkg-deb","-f",str(deb),field)!=value:raise ValueError(f"Original {field} mismatch")

def assemble(original,timer,plist,zoom,zoom_plist,out,manifest):
    original=original.resolve()
    timer=timer.resolve()
    plist=plist.resolve()
    zoom=zoom.resolve()
    zoom_plist=zoom_plist.resolve()
    out=out.resolve()
    verify_original(original)
    if not timer.is_file() or timer.stat().st_size<4096:raise ValueError("Missing native signed ARM64 timer dylib")
    if not plist.is_file():raise ValueError("Missing timer filter plist")
    if not zoom.is_file() or zoom.stat().st_size<4096:raise ValueError("Missing signed Zoom+Swap arm64 dylib")
    if not zoom_plist.is_file():raise ValueError("Missing Zoom/Swap filter plist")
    if out==original:raise ValueError("Never overwrite original DEB")
    if subprocess.run(["dpkg","--compare-versions",VERSION,"gt","1.0.3-omnicar11-native-solo-timer"]).returncode:
        raise RuntimeError("New version not newer than current QA10 Sileo")

    with tempfile.TemporaryDirectory(prefix="omnicar-original-solo-only-") as temp:
        stage=Path(temp)/"stage"
        later=Path(temp)/"check"
        subprocess.run(["dpkg-deb","-R",str(original),str(stage)],check=True)
        before=inventory(stage)
        baseline_payload={
            key:value for key,value in before.items()
            if not key.startswith("DEBIAN/") and key!="DEBIAN" and value[0]!="dir"
        }
        if len(baseline_payload)!=ORIGINAL_PAYLOAD_COUNT:
            raise ValueError(f"Expected 176 native ORIGINAL files, got {len(baseline_payload)}")
        dest=stage/NATIVE_DIR
        if not (dest/"OmniCarSplitScreen.dylib").exists():
            raise RuntimeError("Original Solo split owner missing")
        for prior in ("OmniCarSoloThreeDots","OmniCarIdleControls",
                      "OmniCarDuoActivityIdle","OmniCarDoubleTapFullscreen",
                      "OmniCarGraphiteTitanium"):
            if (dest/(prior+".dylib")).exists():
                raise RuntimeError(f"Unsafe experimental addon already in original: {prior}")
        additions=[]
        for name,suffix,source in (
            (MODULE,".dylib",timer),(MODULE,".plist",plist),
            (ZOOM_MODULE,".dylib",zoom),(ZOOM_MODULE,".plist",zoom_plist)):
            target=dest/(name+suffix)
            if target.exists():raise RuntimeError("Destination collision with original")
            shutil.copy2(source,target)
            additions.append(target.relative_to(stage).as_posix())

        control=stage/"DEBIAN/control"
        orig_control=control.read_bytes()
        old=f"Version: {ORIG_VERSION}".encode("ascii")
        new=f"Version: {VERSION}".encode("ascii")
        if orig_control.splitlines().count(old)!=1:
            raise RuntimeError("Original control has unexpected Version stanza")
        control.write_bytes(orig_control.replace(old,new))
        out.parent.mkdir(parents=True,exist_ok=True)
        subprocess.run(["dpkg-deb","--root-owner-group","-b",str(stage),str(out)],check=True)
        subprocess.run(["dpkg-deb","-R",str(out),str(later)],check=True)
        after=inventory(later)
        for key,value in before.items():
            if key=="DEBIAN/control":continue
            if after.get(key)!=value:
                raise RuntimeError(f"Original entry modified: {key}")
        if (later/"DEBIAN/control").read_bytes()!=orig_control.replace(old,new):
            raise RuntimeError("Changed original control beyond Version")
        new_files=set(after)-set(before)
        if new_files!=set(additions):
            raise RuntimeError(f"Unexpected added files: {new_files!r}")
        payload={
            key:value for key,value in after.items()
            if not key.startswith("DEBIAN/") and key!="DEBIAN" and value[0]!="dir"
        }
        if len(payload)!=ORIGINAL_PAYLOAD_COUNT+4:
            raise RuntimeError("Must have exactly 180 payload entries")
        for module in (MODULE,ZOOM_MODULE):
            for suffix in (".dylib",".plist"):
                if sum(key.endswith("/"+module+suffix) for key in payload)!=1:
                    raise RuntimeError(f"Missing or duplicate {module}{suffix}")
        if any(other in key for key in payload for other in (
                "OmniCarSoloThreeDots", "OmniCarIdleControls","OmniCarDuoActivityIdle",
                "OmniCarGraphiteTitanium")):
            raise RuntimeError("Old QA7–QA9 addon unexpectedly present")
        for key,value in (("Package",PACKAGE),("Version",VERSION),("Architecture",ARCH)):
            if cmd("dpkg-deb","-f",str(out),key)!=value:
                raise RuntimeError(f"Bad {key} in packaged DEB")
        for field in ("Package","Architecture","Depends","Conflicts","Provides","Maintainer","Description"):
            if cmd("dpkg-deb","-f",str(out),field)!=cmd("dpkg-deb","-f",str(original),field):
                raise RuntimeError(f"Original metadata field changed: {field}")
        info={
            "status":"ORIGINAL_SOLO_UNTOUCHED_176_ORIGINAL_FILES_PLUS_TIMER_ZOOM_SWAP",
            "package":PACKAGE,"version":VERSION,"architecture":ARCH,
            "original_sha256":ORIGINAL_SHA256,"output_filename":out.name,
            "output_sha256":sha256(out),"original_payload_file_count":ORIGINAL_PAYLOAD_COUNT,
            "final_payload_file_count":len(payload),"unchanged_original_entries":len(before)-1,
            "added_native_files":additions,"changed_original_control_only":"Version",
            "original_solo_untouched":True,
            "legacy_qa7_qa8_qa9_addons_excluded":True,
            "zoom_swap_actions_restored":True,"original_zoom_swap_source_blob":"93d8fa2e912029e33391e9834f07463bef39d037",
            "sileo_published":False,"carplay_device_tested":False,
            "limitations":"Original native Solo unchanged. Zoom/Swap two-action module restored; multiple split hooks require real parked-car verification."
        }
        manifest.parent.mkdir(parents=True,exist_ok=True)
        manifest.write_text(json.dumps(info,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
        print("OMNICAR_QA12_ORIGINAL_SOLO_AND_ALL_176_NATIVE_FILES_UNCHANGED_PASS")
        print("OMNICAR_QA12_ONE_TIMER_AND_ONE_ZOOM_SWAP_DYLIB_NO_LEGACY_SOLO_PASS")
        print("OMNICAR_QA12_VERSION_GREATER_THAN_QA11_PASS")
        print("OMNICAR_QA12_SOLO_TIMER_ZOOM_SWAP_SHA256="+info["output_sha256"])
        print("NO_SILEO_NO_DEVICE_TEST")
if __name__=="__main__":
    ap=argparse.ArgumentParser()
    ap.add_argument("--original",type=Path,required=True)
    ap.add_argument("--timer",type=Path,required=True)
    ap.add_argument("--plist",type=Path,required=True)
    ap.add_argument("--zoom",type=Path,required=True)
    ap.add_argument("--zoom-plist",type=Path,required=True)
    ap.add_argument("--output",type=Path,required=True)
    ap.add_argument("--manifest",type=Path,required=True)
    args=ap.parse_args()
    assemble(args.original,args.timer,args.plist,args.zoom,args.zoom_plist,args.output,args.manifest)
