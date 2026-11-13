#!/usr/bin/env python3
"""Locally merge ALREADY-SIGNED DuoCar, original Lề 0.2.4 and a signed
DuoCar-specific extension into one personal-use DEB.

Never changes any Le binary bytes or runs any vendor maintainer script.
Does not grant permission to redistribute third-party binary code.
"""
from __future__ import annotations
import argparse
import hashlib
import os
from pathlib import Path
import plistlib
import shutil
import subprocess
import sys
import tempfile

LE_SHA256 = "98a234f404987d5958bc80a19e0ed62d34ca2b39d4ef6e798bfd3314e2cb4770"
LE_NAMES = ("LeBubble", "LeGoogleRelay", "LeSupervisor", "LeGuidanceRelay",
            "LeGofaSource", "LeWazeSource", "LeGoogleSource",
            "LeSourceShown", "LeGoogleMaps")
OLD = ("DuoCarSpeedBubble", "OmniCarSpeedBubble")

def cmd(*argv):
    return subprocess.check_output(argv, text=True, stderr=subprocess.STDOUT).strip()

def digest(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for data in iter(lambda: f.read(1024*1024), b""):
            h.update(data)
    return h.hexdigest()

def require(condition, message):
    if not condition:
        raise RuntimeError(message)

def field(deb, key):
    return cmd("dpkg-deb", "-f", str(deb), key)

def jb(root, tail):
    return root / "var/jb" / tail

def files(root):
    paths = []
    for folder, dirs, names in os.walk(root, followlinks=False):
        for item in dirs + names:
            p = Path(folder) / item
            require(not p.is_symlink(), f"Symlink needs manual review: {p}")
            if p.is_file():
                paths.append(p.relative_to(root))
    return sorted(paths)

def add(source, target):
    require(not target.exists() and not target.is_symlink(),
            f"Collision: {target}")
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)

def update_control(path, version, installed_kib):
    lines = path.read_text(encoding="utf-8").splitlines()
    require("Package: com.chuong.duocar" in lines,
            "Wrong base package")
    require("Architecture: iphoneos-arm64" in lines,
            "Wrong architecture")
    keep, conflicts, replaces = [], [], []
    for line in lines:
        key, colon, value = line.partition(":")
        if colon and not line[:1].isspace() and key in (
                "Version", "Installed-Size", "Conflicts", "Replaces"):
            if key == "Conflicts":
                conflicts.extend(x.strip() for x in value.split(",") if x.strip())
            if key == "Replaces":
                replaces.extend(x.strip() for x in value.split(",") if x.strip())
            continue
        keep.append(line)
    keep.extend([f"Version: {version}",
                 f"Installed-Size: {installed_kib}"])
    # A standalone Le package must not own the same dylib paths simultaneously.
    keep.append("Conflicts: " + ", ".join(sorted(set(conflicts+["dev.bechou.le"]))))
    keep.append("Replaces: " + ", ".join(sorted(set(replaces+["dev.bechou.le"]))))
    require(not any("com.anlai.omnicar" in line for line in keep
                    if line.startswith(("Conflicts:", "Replaces:"))),
            "Do not force-remove old OmniCar")
    path.write_text("\n".join(keep).rstrip()+"\n", encoding="utf-8")

def merge(duo, le, extension, output, le_sha, version):
    for p in (duo, le, extension):
        require(p.is_file() and p.stat().st_size > 100,
                f"Missing/invalid DEB: {p}")
        require(field(p, "Architecture") == "iphoneos-arm64",
                f"Wrong architecture: {p}")
    require(digest(le) == le_sha.lower(),
            "Le DEB SHA256 mismatch: refuse to merge altered vendor bytes")
    require(field(duo, "Package") == "com.chuong.duocar",
            "Wrong DuoCar base")
    require(field(le, "Package") == "dev.bechou.le" and
            field(le, "Version") == "0.2.4",
            "Expected original Le 0.2.4")
    require(field(extension, "Package") == "com.chuong.duocar.leextension",
            "Wrong extension")

    with tempfile.TemporaryDirectory(prefix="duocar-le024-") as tmp:
        base, vendor, addon = [Path(tmp)/n for n in ("base", "vendor", "addon")]
        for deb, dest in ((duo, base), (le, vendor), (extension, addon)):
            subprocess.run(["dpkg-deb", "-x", str(deb), str(dest)], check=True)
        subprocess.run(["dpkg-deb", "-e", str(duo),
                        str(base/"DEBIAN")], check=True)
        app = jb(base, "Applications/DuoCar.app/DuoCar")
        require(app.is_file() and b"[le024-prefs]" in app.read_bytes(),
                "DuoCar must be recompiled with the original LePrefs host")
        libs = jb(vendor, "Library/MobileSubstrate/DynamicLibraries")
        ext_libs = jb(addon, "Library/MobileSubstrate/DynamicLibraries")
        for name in LE_NAMES:
            require((libs/(name+".dylib")).is_file() and
                    (libs/(name+".plist")).is_file(),
                    f"Missing Le dylib/filter: {name}")
        prefs = jb(vendor, "Library/PreferenceBundles/LePrefs.bundle/LePrefs")
        require(prefs.is_file(), "LePrefs executable missing")
        for name in ("DCLLeExtension.dylib", "DCLLeExtension.plist"):
            require((ext_libs/name).is_file(), f"Missing signed extension: {name}")
        for plist in list(libs.glob("Le*.plist")) + [
                ext_libs/"DCLLeExtension.plist"]:
            with plist.open("rb") as fh:
                require(isinstance(plistlib.load(fh), dict),
                        f"Invalid filter plist: {plist}")

        for name in OLD:
            for suffix in (".dylib", ".plist"):
                legacy = jb(base, "Library/MobileSubstrate/DynamicLibraries/"
                            +name+suffix)
                if legacy.exists():
                    legacy.unlink()

        # Keep ALL original vendor runtime/resources, except the duplicate
        # Settings.app launcher. LePrefs itself stays unmodified in the bundle.
        exclude = Path("var/jb/Library/PreferenceLoader/Preferences/Le.plist")
        retained = []
        for rel in files(vendor):
            if rel == exclude:
                continue
            require(rel.parts[:2] == ("var", "jb"),
                    f"Unexpected rootful vendor path: {rel}")
            add(vendor/rel, base/rel)
            retained.append(rel)
        for rel in files(addon):
            require(rel.parts[:2] == ("var", "jb"),
                    f"Unexpected rootful addon path: {rel}")
            add(addon/rel, base/rel)

        total = sum(p.stat().st_size for p in base.rglob("*") if p.is_file())
        update_control(base/"DEBIAN/control", version, (total+1023)//1024)
        output.parent.mkdir(parents=True, exist_ok=True)
        require(not output.exists(), f"Won't overwrite: {output}")
        subprocess.run(["dpkg-deb", "--build", "--root-owner-group",
                        str(base), str(output)], check=True,
                       stdout=subprocess.DEVNULL)

        inspected = Path(tmp)/"inspect"
        subprocess.run(["dpkg-deb", "-x", str(output), str(inspected)],
                       check=True)
        for rel in retained:
            require(digest(inspected/rel) == digest(vendor/rel),
                    f"Le asset modified: {rel}")
        for name in OLD:
            require(not jb(inspected,
                "Library/MobileSubstrate/DynamicLibraries/"+name+".dylib").exists(),
                "Old SpeedBubble unexpectedly shipped")
        require(field(output, "Package") == "com.chuong.duocar" and
                field(output, "Version") == version,
                "Final DEB control wrong")
        return {
            "file": str(output), "sha256": digest(output),
            "size": output.stat().st_size,
            "vendor_files_byte_identical": len(retained),
            "vendor_deb_sha256": digest(le),
            "original_le_machos": 10,
        }

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    for name in ("duocar", "le", "extension", "output"):
        ap.add_argument("--"+name, type=Path, required=True)
    ap.add_argument("--personal-use", action="store_true")
    ap.add_argument("--le-sha256", default=LE_SHA256)
    ap.add_argument("--version", default="1.0.3-le0241")
    args = ap.parse_args()
    if not args.personal_use:
        ap.error("--personal-use required; vendor redistribution permission unknown")
    if not args.version.startswith("1.0.3-le024"):
        ap.error("Invalid integrated version")
    result = merge(args.duocar.resolve(), args.le.resolve(),
                   args.extension.resolve(), args.output.resolve(),
                   args.le_sha256, args.version)
    for key, value in result.items():
        print(f"{key}: {value}")
    print("DUOCAR_LE024_MERGE_VERIFIED")

if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, subprocess.CalledProcessError) as exc:
        print("DUOCAR_LE024_MERGE_FAIL:", exc, file=sys.stderr)
        raise SystemExit(1)
