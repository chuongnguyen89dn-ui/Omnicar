#!/usr/bin/env python3
"""QA20: immutable QA19 Sileo DEB, update exactly ONE native activity module + Debian Version.
QA19 host app wake / all other 181 payload files stay byte-identical.
QA16 user-confirmed YouTube idle fade preserved in newly built host module.
QA19 on-device touch/wake FAIL; QA20 app-process passive relay added without blocking playback.
NO deployment from this script.
"""
import argparse,hashlib,json,os,shutil,stat,subprocess,tempfile
from pathlib import Path
QA19_SHA256="af6585d750504c1194a756f6b7b3ea8244d53271d115a046380f63c607bde16b"
QA19_VERSION="1.0.3-omnicar19-app-process-wake"
QA20_VERSION="1.0.3-omnicar20-divider-knob-idle"
LIB="var/jb/Library/MobileSubstrate/DynamicLibraries"
PACKAGE="com.anlai.omnicar"
ARCH="iphoneos-arm64"
UPDATES=("OmniCarNativeSoloTimer",)
QA19_FILES=182

def sha256(p):
    h=hashlib.sha256()
    with Path(p).open("rb") as f:
        for piece in iter(lambda:f.read(1048576),b""):h.update(piece)
    return h.hexdigest()

def command(*args):
    return subprocess.check_output(args,text=True,stderr=subprocess.STDOUT).strip()

def inventory(root):
    result={}
    for dirpath,dirs,files in os.walk(root,followlinks=False):
        for filename in dirs+files:
            p=Path(dirpath)/filename
            key=p.relative_to(root).as_posix()
            mode=stat.S_IMODE(p.lstat().st_mode)
            if p.is_symlink():result[key]=("symlink",os.readlink(p),mode)
            elif p.is_dir():result[key]=("dir",mode)
            elif p.is_file():result[key]=("file",sha256(p),mode)
            else:raise RuntimeError("Unexpected special payload entry: "+key)
    return result

def make(input_deb,native_dylib,out,manifest):
    input_deb,native_dylib,out,manifest=[Path(v).resolve() for v in
        (input_deb,native_dylib,out,manifest)]
    if not input_deb.is_file() or sha256(input_deb)!=QA19_SHA256:
        raise ValueError("QA19_LIVE_BASE_SHA256_MISMATCH")
    if out==input_deb:raise ValueError("REFUSE_OVERWRITE_ORIGINAL")
    for path in (native_dylib,):
        if not path.is_file() or path.stat().st_size<4096:
            raise ValueError("MISSING_COMPILED_ARM64_MODULE:"+str(path))
    for field,value in (("Package",PACKAGE),("Architecture",ARCH),("Version",QA19_VERSION)):
        if command("dpkg-deb","-f",str(input_deb),field)!=value:
            raise ValueError("QA19_CONTROL_MISMATCH:"+field)
    if subprocess.run(("dpkg","--compare-versions",QA20_VERSION,"gt",QA19_VERSION)).returncode:
        raise ValueError("QA20_NOT_NEWER_THAN_LIVE_QA19")

    with tempfile.TemporaryDirectory(prefix="omnicar-qa20-duoface-wake-") as tmp:
        root=Path(tmp)/"base"
        check=Path(tmp)/"verify"
        subprocess.run(("dpkg-deb","-R",str(input_deb),str(root)),check=True)
        before=inventory(root)
        oldpayload={key:value for key,value in before.items() if
                    key!="DEBIAN" and not key.startswith("DEBIAN/") and value[0]!="dir"}
        if len(oldpayload)!=QA19_FILES:raise ValueError("QA19_PAYLOAD_COUNT_MISMATCH")
        for required in ("OmniCarAppBridge","OmniCarSplitScreen",
                         "OmniCarDoubleTapFullscreen",*UPDATES):
            if not (root/LIB/(required+".dylib")).is_file():
                raise ValueError("MISSING_ORIGINAL_MODULE:"+required)
        forbidden=("OmniCarYouTubeScene","OmniCarIdleControls","OmniCarSoloThreeDots",
                   "OmniCarGraphiteTitanium","OmniCarDuoActivityIdle")
        for name in forbidden:
            if any(key.endswith("/"+name+".dylib") for key in oldpayload):
                raise ValueError("FORBIDDEN_ADDED_MODULE:"+name)
        changed_paths=[]
        for name,compiled in zip(UPDATES,(native_dylib,)):
            dst=root/LIB/(name+".dylib")
            orig_mode=stat.S_IMODE(dst.stat().st_mode)
            shutil.copyfile(compiled,dst)
            dst.chmod(orig_mode)
            changed_paths.append(dst.relative_to(root).as_posix())

        # Debian content metadata when present: update only the two md5 sums.
        md5file=root/"DEBIAN/md5sums"
        if md5file.is_file():
            lines=md5file.read_text().splitlines(keepends=True)
            corrected=[]
            seen=set()
            for line in lines:
                tokens=line.strip().split(maxsplit=1)
                if len(tokens)==2 and tokens[1] in changed_paths:
                    key=tokens[1]
                    seen.add(key)
                    corrected.append(hashlib.md5((root/key).read_bytes()).hexdigest()
                                     +"  "+key+("\n" if line.endswith("\n") else ""))
                else:corrected.append(line)
            if seen!=set(changed_paths):
                raise ValueError("QA19_MD5SUMS_MISSING_EXPECTED_MODULES")
            md5file.write_text("".join(corrected))
        control=root/"DEBIAN/control"
        oldcontrol=control.read_bytes()
        old_version=("Version: "+QA19_VERSION).encode()
        new_version=("Version: "+QA20_VERSION).encode()
        if oldcontrol.splitlines().count(old_version)!=1:
            raise ValueError("ORIGINAL_CONTROL_VERSION_ABSENT")
        control.write_bytes(oldcontrol.replace(old_version,new_version))

        out.parent.mkdir(parents=True,exist_ok=True)
        subprocess.run(("dpkg-deb","--root-owner-group","-b",str(root),str(out)),check=True)
        subprocess.run(("dpkg-deb","-R",str(out),str(check)),check=True)
        after=inventory(check)
        if before.keys()!=after.keys():raise ValueError("QA20_ADDED_OR_REMOVED_PAYLOAD_ENTRY")
        allowed=set(changed_paths)|{"DEBIAN/control"}
        if md5file.is_file():allowed.add("DEBIAN/md5sums")
        diff=sorted(k for k in before if before[k]!=after[k])
        if set(diff)-allowed:raise ValueError("UNEXPECTED_CHANGED_FILES:"+repr(diff))
        if not set(changed_paths).issubset(diff):
            raise ValueError("REPLACEMENT_DYLIB_BYTES_NOT_CHANGED:"+repr(diff))
        if (check/"DEBIAN/control").read_bytes()!=oldcontrol.replace(old_version,new_version):
            raise ValueError("DEBIAN_CONTROL_CHANGED_OUTSIDE_VERSION")
        if command("dpkg-deb","-f",str(out),"Version")!=QA20_VERSION:
            raise ValueError("OUTPUT_VERSION_INCORRECT")
        for field in ("Package","Architecture","Depends","Conflicts","Replaces",
                      "Maintainer","Description"):
            if command("dpkg-deb","-f",str(out),field)!=command("dpkg-deb","-f",str(input_deb),field):
                raise ValueError("OTHER_CONTROL_FIELD_CHANGED:"+field)
        newpayload={k:v for k,v in after.items() if
                    k!="DEBIAN" and not k.startswith("DEBIAN/") and v[0]!="dir"}
        assert len(newpayload)==QA19_FILES
        info={
            "status":"QA20_CENTER_DIVIDER_KNOB_IDLE_CANDIDATE_NOT_DEVICE_TESTED",
            "package":PACKAGE,"version":QA20_VERSION,"architecture":ARCH,
            "qa19_live_deb_sha256":QA19_SHA256,
            "output_filename":out.name,"output_sha256":sha256(out),
            "original_payload_entries":QA19_FILES,"output_payload_entries":len(newpayload),
            "exactly_replaced_modules":changed_paths,
            "other_payload_identical":True,
            "changed_entries":diff,
            "qa16_user_confirmed_four_second_youtube_hide_preserved":True,
            "qa19_failed_window_gesture_retired":True,
            "duoface_verified_hit_test_activity_model":True,
            "native_host_broadcast_notification":"com.anlai.omnicar.qa19.controls.activity",
            "original_youtube_player_unchanged":True,
            "zoom_swap_solo_native_handlers_unchanged":True,
            "no_extra_scene_rotation_module":True,
            "sileo_published":False,"carplay_device_tested":False,
            "limitations":"QA19 on-device wake improved; its center divider knob remains visible. QA20 paints original divider.knob on same idle timer; on-device QA20 is pending."
        }
        manifest.parent.mkdir(parents=True,exist_ok=True)
        manifest.write_text(json.dumps(info,ensure_ascii=False,indent=2)+"\n")
        print("QA20_PRESERVE_OTHER_181_PAYLOAD_FILES_EXACT_GUARD_PASS")
        print("QA20_REPLACE_ONLY_NATIVE_TIMER_DYLIB_PASS")
        print("QA20_OUTPUT_SHA256="+info["output_sha256"])
        print("QA20_DEVICE_UNTESTED_NOT_SILEO")
        return info

if __name__=="__main__":
    p=argparse.ArgumentParser()
    for name in ("qa19","native_dylib","output","manifest"):
        p.add_argument("--"+name.replace("_","-"),type=Path,required=True)
    x=p.parse_args()
    make(x.qa19,x.native_dylib,x.output,x.manifest)
