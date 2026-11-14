#!/usr/bin/env python3
"""Host regression: optional external Lề DEB must NEVER own vendor runtime."""
from pathlib import Path
import importlib.util
import os
import subprocess
import sys
import tempfile

root=Path(__file__).resolve().parents[2] # tests/ -> gpt-project-history/ -> recovered-source/
script=root/"gpt-project-history/merge_external_le_only.py"
spec=importlib.util.spec_from_file_location("hl58merge",script)
mod=importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
def shell(*a):
    subprocess.run(a,check=True,stdout=subprocess.DEVNULL)
def control(path,name,version="0.1"):
    d=path/"DEBIAN"
    d.mkdir(parents=True)
    (d/"control").write_text(
        "Package: "+name+"\nVersion: "+version+
        "\nArchitecture: iphoneos-arm64\nMaintainer: Test\nDescription: QA\n"
        "Depends: mobilesubstrate\nConflicts: dev.bechou.le, carspeed\n"
        "Replaces: dev.bechou.le\n")
def payload(folder,name,data):
    path=folder/"var/jb"/name
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_bytes(data)
def create(path,target):
    shell("dpkg-deb","--build","--root-owner-group",path,target)

with tempfile.TemporaryDirectory(prefix="hl58-synthetic-") as t:
    tmp=Path(t)
    base=tmp/"base"
    addon=tmp/"addon"
    base.mkdir()
    addon.mkdir()
    control(base,"com.chuong.duocar","1.0.3-hl47")
    control(addon,"com.chuong.duocar.leextension","0.2.0")
    payload(base,"Applications/DuoCar.app/DuoCar",b"HEADER DuoCar TEST")
    payload(addon,"Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.dylib",
            b"CWTrafficBubbleContent TEST")
    payload(addon,"Library/MobileSubstrate/DynamicLibraries/DCLLeExtension.plist",
            b"test plist")
    baseDeb=tmp/"base.deb"
    extDeb=tmp/"extension.deb"
    output=tmp/"DC58.deb"
    create(base,baseDeb)
    create(addon,extDeb)
    mod.merge(baseDeb,extDeb,output,"1.0.4-hl58")
    assert output.is_file()
    assert mod.field(output,"Version")=="1.0.4-hl58"
    data=subprocess.check_output(["dpkg-deb","-f",str(output)],text=True)
    assert "dev.bechou.le" not in data
    assert "carspeed" in data
    # Deny attempts to accidentally embed vendor Lề when an older base
    # or cached package stashes a third-party runtime in our root.
    payload(base,"Library/MobileSubstrate/DynamicLibraries/LeBubble.dylib",
            b"vendor")
    replaced=tmp/"newbase.deb"
    create(base,replaced)
    try:
        mod.merge(replaced,extDeb,tmp/"rejected.deb","1.0.4-hl58")
    except AssertionError:
        pass
    else:
        raise AssertionError("Vendor Le accidentally bundled")
    # Reject a companion addon shipping a foreign LePrefs bundle.
    payload(addon,"Library/PreferenceBundles/LePrefs.bundle/LePrefs",
            b"vendor")
    newExt=tmp/"bad-ext.deb"
    create(addon,newExt)
    try:
        mod.merge(baseDeb,newExt,tmp/"rejected2.deb","1.0.4-hl58")
    except AssertionError:
        pass
    else:
        raise AssertionError("Unapproved vendor addon file copied")
print("HL58_OPTIONAL_LE_PACKAGE_CONTRACT_HOST_PASS")
