#!/usr/bin/env python3
"""Emergency Omnicar QA9 device-failure recovery: keep ALL original QA7 payload bytes.

Repacks exact SHA-pinned 1.0.3-omnicar7 DEB with only Debian Version changed.
This does not edit any dylib, filter plist, maintainer script, or application file.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import stat
import subprocess
import tempfile

ORIGINAL_SHA = "fad7e4923f576d248c16ac2b6153b14680ac60116d3316642043edacb8cbdfee"
OLD_VERSION = "1.0.3-omnicar7"
RECOVERY_VERSION = "1.0.3-omnicar10-recovery"
PACKAGE = "com.anlai.omnicar"
ARCH = "iphoneos-arm64"
ORIGINAL_COUNT = 184  # 176 original package + exactly 8 native additions

def command(*args):
    return subprocess.check_output(args, text=True, stderr=subprocess.STDOUT).strip()

def sha(path):
    h=hashlib.sha256()
    with Path(path).open("rb") as f:
        for chunk in iter(lambda:f.read(2**20),b""):h.update(chunk)
    return h.hexdigest()

def tree(root):
    result={}
    for parent,dirs,files in os.walk(root,followlinks=False):
        for name in dirs+files:
            p=Path(parent)/name
            rel=p.relative_to(root).as_posix()
            info=p.lstat()
            mode=stat.S_IMODE(info.st_mode)
            if p.is_symlink():sig=["symlink",os.readlink(p),mode]
            elif p.is_file():sig=["file",sha(p),mode]
            elif p.is_dir():sig=["dir",mode]
            else:raise RuntimeError(f"Unexpected special file in package: {rel}")
            result[rel]=sig
    return result

def build(original,output,manifest_file):
    if sha(original)!=ORIGINAL_SHA:raise RuntimeError("QA7 original DEB checksum mismatch; STOP")
    for version,file in [(OLD_VERSION,original)]:
        if command("dpkg-deb","-f",str(file),"Package")!=PACKAGE:raise RuntimeError("Wrong package")
        if command("dpkg-deb","-f",str(file),"Version")!=version:raise RuntimeError("Wrong source version")
        if command("dpkg-deb","-f",str(file),"Architecture")!=ARCH:raise RuntimeError("Wrong arch")
    if subprocess.run(["dpkg","--compare-versions",RECOVERY_VERSION,"gt","1.0.3-omnicar9-gestureqa"]).returncode:
        raise RuntimeError("Recovery not higher than broken QA9 in apt/dpkg ordering")

    with tempfile.TemporaryDirectory(prefix="omnicar-qa7-recovery-") as temp:
        root=Path(temp)/"unpack"
        recovered=Path(temp)/"verify"
        subprocess.run(["dpkg-deb","-R",str(original),str(root)],check=True)
        before=tree(root)
        payload={k:v for k,v in before.items() if not (k=="DEBIAN" or k.startswith("DEBIAN/")) and v[0]!="dir"}
        if len(payload)!=ORIGINAL_COUNT:raise RuntimeError(f"QA7 payload count changed: {len(payload)}")
        modules=("OmniCarDoubleTapFullscreen","OmniCarIdleControls","OmniCarSoloThreeDots","OmniCarGraphiteTitanium")
        for name in modules:
            for ext in (".dylib",".plist"):
                path=f"var/jb/Library/MobileSubstrate/DynamicLibraries/{name}{ext}"
                if path not in payload:raise RuntimeError(f"Missing verified QA7 module: {path}")
        if any("OmniCarDuoActivityIdle." in k for k in payload):
            raise RuntimeError("Accidental stacking of QA8/QA9 experiment")

        control=root/"DEBIAN/control"
        original_control=control.read_bytes()
        old=f"Version: {OLD_VERSION}".encode()
        new=f"Version: {RECOVERY_VERSION}".encode()
        lines=original_control.splitlines()
        if lines.count(old)!=1:raise RuntimeError("Noncanonical source package control")
        control.write_bytes(original_control.replace(old,new))
        change=tree(root)
        for name in before:
            if name!="DEBIAN/control" and before[name]!=change[name]:
                raise RuntimeError(f"Unexpected source modification: {name}")
        output.parent.mkdir(parents=True,exist_ok=True)
        subprocess.run(["dpkg-deb","--build","--root-owner-group",str(root),str(output)],check=True)
        subprocess.run(["dpkg-deb","-R",str(output),str(recovered)],check=True)
        after=tree(recovered)
        if before.keys()!=after.keys():raise RuntimeError("Recovery file paths differ from original QA7")
        bad=[k for k in before if k!="DEBIAN/control" and before[k]!=after[k]]
        if bad:raise RuntimeError(f"QA7 bytes/links/modes differ: {bad[:20]}")
        recovered_control=(recovered/"DEBIAN/control").read_bytes()
        if recovered_control!=original_control.replace(old,new):
            raise RuntimeError("Changed control data beyond Debian Version")
        if command("dpkg-deb","-f",str(output),"Version")!=RECOVERY_VERSION:
            raise RuntimeError("Recovery version mismatch")
        for field in ("Package","Architecture","Depends","Conflicts","Provides","Maintainer","Description"):
            if command("dpkg-deb","-f",str(original),field)!=command("dpkg-deb","-f",str(output),field):
                raise RuntimeError(f"Changed package metadata field: {field}")
        manifest={
            "status":"VERIFIED_QA7_IDENTICAL_PAYLOAD_AND_MAINTAINER_SCRIPTS",
            "package":PACKAGE,"version":RECOVERY_VERSION,"architecture":ARCH,
            "base_QA7_version":OLD_VERSION,"base_QA7_sha256":ORIGINAL_SHA,
            "qa9_user_test":"FAILED_ON_DEVICE_UNSPECIFIED_SYMPTOM",
            "output_filename":output.name,"output_sha256":sha(output),
            "payload_file_count":len(payload),"verified_unchanged_noncontrol_entries":len(before)-1,
            "changed_control_field_only":"Version","sileo_published":False,
            "recovery_tested_on_carplay":False,
            "limitations":"QA7 has known hard-to-wake map menu controls and missing YouTube solo dot; not a full fix."
        }
        manifest_file.parent.mkdir(parents=True,exist_ok=True)
        manifest_file.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+"\n")
        print("OMNICAR_QA7_PAYLOAD_IDENTICAL_OLD_SOLO_AND_IDLE_RESTORED_PASS")
        print("OMNICAR_QA10_DPKG_VERSION_MONOTONIC_PASS")
        print("OMNICAR_QA10_RECOVERY_SHA256="+manifest["output_sha256"])
        print("OMNICAR_QA10_RECOVERY_NOT_DEVICE_TESTED_NOT_SILEO")
if __name__=="__main__":
    ap=argparse.ArgumentParser()
    ap.add_argument("--original",type=Path,required=True)
    ap.add_argument("--output",type=Path,required=True)
    ap.add_argument("--manifest",type=Path,required=True)
    args=ap.parse_args()
    build(args.original,args.output,args.manifest)
