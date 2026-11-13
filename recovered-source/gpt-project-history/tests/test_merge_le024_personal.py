#!/usr/bin/env python3
"""Synthetic DEB test: no original vendor content is involved."""
import hashlib
from pathlib import Path
import plistlib
import subprocess
import sys
import tempfile

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from merge_le024_personal_deb import LE_NAMES,merge

def fixture(root,package,version,kind):
    base=root/("stage-"+kind)
    control=base/"DEBIAN/control"
    control.parent.mkdir(parents=True)
    control.write_text("Package: "+package+"\nVersion: "+version+
                       "\nArchitecture: iphoneos-arm64\nMaintainer: Test <test@example.com>\n"
                       "Description: Synthetic test DEB\n",encoding="utf-8")
    lib=base/"var/jb/Library/MobileSubstrate/DynamicLibraries"
    lib.mkdir(parents=True)
    if kind=="duocar":
        app=base/"var/jb/Applications/DuoCar.app/DuoCar"
        app.parent.mkdir(parents=True)
        app.write_bytes(b"Test app [le024-prefs] marker")
        (lib/"DuoCarSpeedBubble.dylib").write_bytes(b"retired")
    if kind=="le":
        for name in LE_NAMES:
            (lib/(name+".dylib")).write_bytes(b"vendor-test-"+name.encode())
            (lib/(name+".plist")).write_bytes(plistlib.dumps(
                {"Filter":{"Bundles":["com.apple.CarPlayApp"]}}))
        pref=base/"var/jb/Library/PreferenceBundles/LePrefs.bundle"
        pref.mkdir(parents=True)
        (pref/"LePrefs").write_bytes(b"LePrefs synthetic bytes")
        (pref/"Info.plist").write_bytes(plistlib.dumps({"CFBundleIdentifier":"dev.bechou.le.bubble.preferences"}))
        font=base/"var/jb/usr/share/le/gmaps/fonts"
        font.mkdir(parents=True)
        (font/"OFL.txt").write_text("Fixture font license")
        loader=base/"var/jb/Library/PreferenceLoader/Preferences"
        loader.mkdir(parents=True)
        (loader/"Le.plist").write_bytes(plistlib.dumps({"name":"Le"}))
    if kind=="extension":
        (lib/"DCLLeExtension.dylib").write_bytes(b"Signed extension fixture")
        (lib/"DCLLeExtension.plist").write_bytes(plistlib.dumps(
            {"Filter":{"Bundles":["com.apple.CarPlayApp","com.apple.springboard"]}}))
    deb=root/(kind+".deb")
    subprocess.run(["dpkg-deb","-b","--root-owner-group",str(base),str(deb)],
                   check=True,stdout=subprocess.DEVNULL)
    return deb

with tempfile.TemporaryDirectory(prefix="test-le-") as td:
    root=Path(td)
    duo=fixture(root,"com.chuong.duocar","1.0.3-hl47","duocar")
    le=fixture(root,"dev.bechou.le","0.2.4","le")
    ext=fixture(root,"com.chuong.duocar.leextension","0.1","extension")
    out=root/"duocar.deb"
    source_hash=hashlib.sha256(le.read_bytes()).hexdigest()
    result=merge(duo,le,ext,out,source_hash,"1.0.3-le0241")
    assert result["vendor_files_byte_identical"]==21,result
    payload=root/"payload"
    subprocess.run(["dpkg-deb","-x",str(out),str(payload)],check=True)
    lib=payload/"var/jb/Library/MobileSubstrate/DynamicLibraries"
    assert all((lib/(name+".dylib")).is_file() for name in LE_NAMES)
    assert (lib/"DCLLeExtension.dylib").is_file()
    assert not (lib/"DuoCarSpeedBubble.dylib").exists()
    assert not (payload/"var/jb/Library/PreferenceLoader/Preferences/Le.plist").exists()
    assert (payload/"var/jb/Library/PreferenceBundles/LePrefs.bundle/LePrefs").exists()
    ctl=subprocess.check_output(["dpkg-deb","-f",str(out)],text=True)
    for required in ("Conflicts: dev.bechou.le","Replaces: dev.bechou.le","firmware (<< 27.0)"):
        assert required in ctl
    try:
        merge(duo,le,ext,root/"bad.deb","tamperedhash","1.0.3-le0241")
    except RuntimeError as exc:
        assert "SHA256 mismatch" in str(exc)
    else:
        raise AssertionError("Tampered Le SHA must be rejected")
print("LE024_MERGER_FIXTURE_PASS: 21 vendor assets, original filters and control retained")
