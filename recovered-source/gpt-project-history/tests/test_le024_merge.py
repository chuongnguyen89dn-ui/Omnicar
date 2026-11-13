#!/usr/bin/env python3
"""Test actual DEB merge behavior using only artificial payload bytes."""
from __future__ import annotations
import hashlib
import importlib.util
from pathlib import Path
import plistlib
import subprocess
import tempfile

HERE=Path(__file__).resolve()
MODULE=HERE.parents[1]/"merge_le024_personal_deb.py"
spec=importlib.util.spec_from_file_location("merge_le024_personal_deb",MODULE)
assert spec and spec.loader
merger=importlib.util.module_from_spec(spec)
spec.loader.exec_module(merger)

def fixture(folder, pkg, version, role, collision=False):
    root=folder/("root_"+pkg.replace(".","_"))
    control=root/"DEBIAN/control"
    control.parent.mkdir(parents=True)
    control.write_text(
        f"Package: {pkg}\nVersion: {version}\nArchitecture: iphoneos-arm64\n"
        "Depends: firmware (>= 15.0), mobilesubstrate\n"
        "Maintainer: Fixture <fixture@example.invalid>\n"
        "Description: Artifact-only test\n",encoding="utf-8")
    libs=root/"var/jb/Library/MobileSubstrate/DynamicLibraries"
    libs.mkdir(parents=True)
    if role=="duocar":
        app=root/"var/jb/Applications/DuoCar.app/DuoCar"
        app.parent.mkdir(parents=True)
        app.write_bytes(b"fixture-program-[hl52-le-original] ORIGINAL LOADED CWTrafficBubblePrefsController")
        (libs/"DuoCarSpeedBubble.dylib").write_bytes(b"old-runtime")
    elif role=="le":
        for name in merger.LE_NAMES:
            (libs/(name+".dylib")).write_bytes(b"FAT-FIXTURE"+name.encode()*8)
            (libs/(name+".plist")).write_bytes(
                plistlib.dumps({"Filter":{"Bundles":["com.apple.CarPlayApp"]}}))
        prefs=root/"var/jb/Library/PreferenceBundles/LePrefs.bundle"
        prefs.mkdir(parents=True)
        (prefs/"LePrefs").write_bytes(b"original-vendor-prefs-fixture")
        (prefs/"Info.plist").write_bytes(plistlib.dumps({"CFBundleIdentifier":"dev.bechou.le.bubble.preferences"}))
        fonts=root/"var/jb/usr/share/le/gmaps/fonts"
        fonts.mkdir(parents=True)
        (fonts/"OFL.txt").write_bytes(b"test-font-license-fixture")
        loader=root/"var/jb/Library/PreferenceLoader/Preferences"
        loader.mkdir(parents=True)
        (loader/"Le.plist").write_bytes(plistlib.dumps({"PreferenceBundle":"LePrefs"}))
        postinst=root/"DEBIAN/postinst"
        postinst.write_text("#!/bin/sh\nexit 99\n",encoding="utf-8")
        postinst.chmod(0o755)
        if collision:
            (libs/"DCLLeExtension.dylib").write_bytes(b"unexpected collision")
    elif role=="extension":
        (libs/"DCLLeExtension.dylib").write_bytes(b"signed-extension-fixture")
        (libs/"DCLLeExtension.plist").write_bytes(
            plistlib.dumps({"Filter":{"Bundles":["com.apple.CarPlayApp"]}}))
    else: raise AssertionError(role)
    out=folder/(pkg+".deb")
    subprocess.run(["dpkg-deb","-b","--root-owner-group",str(root),str(out)],
                   check=True,stdout=subprocess.DEVNULL)
    return out

def must_reject(fn, fragment):
    try: fn()
    except RuntimeError as exc:
        assert fragment.lower() in str(exc).lower(),str(exc)
    else: raise AssertionError("Unsafe input was accepted")

def main():
    with tempfile.TemporaryDirectory(prefix="le024-package-test-") as temp:
        root=Path(temp)
        duo=fixture(root,"com.chuong.duocar","1.0.3-hl47","duocar")
        le=fixture(root,"dev.bechou.le","0.2.4","le")
        ext=fixture(root,"com.chuong.duocar.leextension","0.1","extension")
        sha=hashlib.sha256(le.read_bytes()).hexdigest()
        out=root/"combined.deb"
        result=merger.merge(duo,le,ext,out,sha,"1.0.3-le0241")
        assert out.is_file()
        assert result["vendor_files_byte_identical"]>=21
        expanded=root/"expanded"
        subprocess.run(["dpkg-deb","-x",str(out),str(expanded)],check=True)
        libs=expanded/"var/jb/Library/MobileSubstrate/DynamicLibraries"
        assert all((libs/(name+".dylib")).is_file() for name in merger.LE_NAMES)
        assert all((libs/(name+".plist")).is_file() for name in merger.LE_NAMES)
        assert (libs/"DCLLeExtension.dylib").is_file()
        assert not (libs/"DuoCarSpeedBubble.dylib").exists()
        assert (expanded/"var/jb/Library/PreferenceBundles/LePrefs.bundle/LePrefs").is_file()
        assert not (expanded/"var/jb/Library/PreferenceLoader/Preferences/Le.plist").exists()
        assert not (expanded/"DEBIAN/postinst").exists()
        control=subprocess.check_output(["dpkg-deb","-f",str(out)],text=True)
        assert "Conflicts: dev.bechou.le" in control
        assert "Replaces: dev.bechou.le" in control
        assert "firmware (<< 27.0)" in control
        # The previously accepted compatibility-only marker must now
        # be rejected: a signed package must contain the actual vendor
        # root loader class, not the old hand-written Lề table.
        old_version=fixture(root/"compat-only","com.chuong.duocar",
                            "1.0.3-hl47","duocar")
        legacy_app=root/"compat-only/root_com_chuong_duocar/var/jb/Applications/DuoCar.app/DuoCar"
        # Fixture's .deb was already created; repack a DELIBERATE bad
        # compatibility-only version and make sure merger rejects it.
        legacy_app.write_bytes(b"fixture-program-[le024-prefs]")
        wrong_root=root/"compat-only/root_com_chuong_duocar"
        subprocess.run(["dpkg-deb","-b","--root-owner-group",
                        str(wrong_root),str(old_version)],
                       check=True,stdout=subprocess.DEVNULL)
        must_reject(lambda:merger.merge(old_version,le,ext,
                     root/"legacy-host.deb",sha,"1.0.3-le0241"),
                    "authentic LePrefs.bundle loader")
        must_reject(lambda:merger.merge(duo,le,ext,root/"wrong-sha.deb",
                                     "00"*32,"1.0.3-le0241"),"SHA256 mismatch")
        invalid=fixture(root,"wrong.extension","0.1","extension")
        must_reject(lambda:merger.merge(duo,le,invalid,root/"wrong-package.deb",
                                     sha,"1.0.3-le0241"),"Wrong extension")
        alternate=root/"alternate"
        alternate.mkdir()
        colliding=fixture(alternate,"dev.bechou.le","0.2.4","le",True)
        collision_sha=hashlib.sha256(colliding.read_bytes()).hexdigest()
        must_reject(lambda:merger.merge(duo,colliding,ext,root/"collision.deb",
                                     collision_sha,"1.0.3-le0241"),"collision")
        print("DUOCAR_LE024_MERGE_TEST_PASS",result["vendor_files_byte_identical"])

if __name__=="__main__":main()
