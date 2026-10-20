#!/usr/bin/env python3
"""Assemble ONE original-content OmniCar 1.0.3+ patch DEB after builds.

This program DOES NOT download or alter the original DEB; it REQUIRES the
verified original user package with its original SHA256. It copies all original
files and DEBIAN maintainer scripts, replacing only DEBIAN/control version
metadata and adding four independently compiled/signed own-name tweak modules.

Usage from Omnicar repo root:
 python3 scripts/assemble_unified_omnicar.py \
   --original /path/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
   --build-root . --output /tmp/omnicar-unified.deb

Preconditions: Theos ARM64 compiled: root make clean all and make -C
idle/solo/titanium clean all. Not Sileo publishing or device verification.
"""
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

EXPECTED_ORIGINAL_SHA256 = "d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd"
PACKAGE = "com.anlai.omnicar"
VERSION = "1.0.3-omnicar1"
ROOTLESS_LIB = Path("var/jb/Library/MobileSubstrate/DynamicLibraries")
MODULES = (
    ("OmniCarDoubleTapFullscreen", ".", "OmniCarDoubleTapFullscreen.plist"),
    ("OmniCarIdleControls", "idle", "idle/OmniCarIdleControls.plist"),
    ("OmniCarSoloThreeDots", "solo", "solo/OmniCarSoloThreeDots.plist"),
    ("OmniCarGraphiteTitanium", "titanium", "titanium/OmniCarGraphiteTitanium.plist"),
)
OBSOLETE_ADDONS = (
    "com.anlai.omnicar.doubletapfullscreen",
    "com.anlai.omnicar.graphitetitanium",
    "com.anlai.omnicar.skinprobe",
)


def sha256(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(2 ** 20), b""):
            h.update(block)
    return h.hexdigest()


def command(*args):
    return subprocess.check_output(args, text=True).strip()


def parse_control(text):
    result = {}
    for line in text.splitlines():
        if line and not line.startswith(" ") and ":" in line:
            key, value = line.split(":", 1)
            result[key] = value.strip()
    return result


def update_control(contents):
    """Keep every original stanza and field, changing just Version/Conflicts."""
    d = parse_control(contents)
    if d.get("Package") != PACKAGE or d.get("Architecture") != "iphoneos-arm64" or d.get("Version") != "1.0.3":
        raise ValueError("Not the original OmniCar package control")
    if not re.search(r"(?m)^Version: 1\.0\.3\s*$", contents):
        raise ValueError("Unexpected original version control formatting")
    contents = re.sub(r"(?m)^Version: 1\.0\.3\s*$", "Version: " + VERSION, contents)
    if "Conflicts" in d:
        original_conflicts = [x.strip() for x in d["Conflicts"].split(",") if x.strip()]
        merged = list(dict.fromkeys(original_conflicts + list(OBSOLETE_ADDONS)))
        contents = re.sub(r"(?m)^Conflicts:.*$", "Conflicts: " + ", ".join(merged), contents)
    else:
        contents = contents.rstrip("\n") + "\nConflicts: " + ", ".join(OBSOLETE_ADDONS) + "\n"
    return contents


def choose_signed_dylib(root, project, name):
    search_root = root / project / ".theos"
    if not search_root.is_dir():
        raise FileNotFoundError(f"Compile missing: {search_root}")
    # Theos keeps intermediate per-arch .dylib copies and DWARF .dSYM
    # mirrors. The top-level obj/debug or obj/release dylib is the
    # final merged/signed output. Never fail because intermediates exist
    # and never pick an unverified .dSYM mirror.
    final_outputs = [
        search_root / "obj" / mode / (name + ".dylib")
        for mode in ("release", "debug")
        if (search_root / "obj" / mode / (name + ".dylib")).is_file()
    ]
    if len(final_outputs) != 1:
        raise ValueError(
            f"Expected ONE final signed Theos dylib for {name}, "
            f"found {final_outputs}; do not use per-arch or dSYM intermediates"
        )
    result = final_outputs[0]
    if result.stat().st_size < 4096:
        raise ValueError("Native dylib suspiciously short: " + str(result))
    return result


def list_files(root):
    return {p.relative_to(root).as_posix(): sha256(p) for p in root.rglob("*") if p.is_file()}


def assemble(original, build_root, output):
    original = original.resolve()
    build_root = build_root.resolve()
    output = output.resolve()
    if not original.is_file():
        raise FileNotFoundError("Original v1.0.3 DEB not provided: " + str(original))
    original_hash = sha256(original)
    if original_hash != EXPECTED_ORIGINAL_SHA256:
        raise ValueError("Original OmniCar DEB SHA256 MISMATCH; refuse to modify: " + original_hash)
    if output == original:
        raise ValueError("Output must not overwrite original DEB")
    compiled = {}
    for name, project, plist in MODULES:
        dylib = choose_signed_dylib(build_root, project, name)
        filter_file = build_root / plist
        if not filter_file.is_file():
            raise FileNotFoundError(str(filter_file))
        compiled[name] = (dylib, filter_file)
    with tempfile.TemporaryDirectory(prefix="omnicar-unified-") as tmp:
        staging = Path(tmp) / "root"
        subprocess.run(["dpkg-deb", "-R", str(original), str(staging)], check=True)
        control_file = staging / "DEBIAN" / "control"
        original_control = control_file.read_text(encoding="utf-8")
        updated_control = update_control(original_control)
        base_hashes = list_files(staging)
        control_file.write_text(updated_control, encoding="utf-8")
        target = staging / ROOTLESS_LIB
        if not target.is_dir() or not (target / "OmniCarSplitScreen.dylib").is_file():
            raise ValueError("Original rootless OmniCarSplitScreen owner missing")
        injected = []
        for name, (dylib, plist) in compiled.items():
            for source in (dylib, plist):
                filename = name + (".dylib" if source == dylib else ".plist")
                destination = target / filename
                if destination.exists():
                    raise ValueError("Collision with original package payload: " + str(destination))
                shutil.copy2(source, destination)
                injected.append(destination.relative_to(staging).as_posix())
        output.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(["dpkg-deb", "--root-owner-group", "-b", str(staging), str(output)], check=True)
        if command("dpkg-deb", "-f", str(output), "Package") != PACKAGE:
            raise ValueError("Wrong output Package")
        if command("dpkg-deb", "-f", str(output), "Version") != VERSION:
            raise ValueError("Wrong output Version")
        if command("dpkg-deb", "-f", str(output), "Architecture") != "iphoneos-arm64":
            raise ValueError("Wrong output Architecture")
        # Validate all ORIGINAL file bytes unchanged (except DEBIAN/control).
        with tempfile.TemporaryDirectory(prefix="omnicar-verify-") as v:
            extracted = Path(v)
            subprocess.run(["dpkg-deb", "-R", str(output), str(extracted)], check=True)
            after = list_files(extracted)
        for path, original_hash in base_hashes.items():
            if path != "DEBIAN/control" and after.get(path) != original_hash:
                raise ValueError("Original file changed unexpectedly: " + path)
        changes = set(after).difference(base_hashes)
        if changes != set(injected):
            raise ValueError("Unexpected added/deleted files: " + repr(changes ^ set(injected)))
    return {"status": "PACKAGE_BUILT_NOT_DEVICE_TESTED", "package": PACKAGE,
            "version": VERSION, "architecture": "iphoneos-arm64",
            "base_sha256": EXPECTED_ORIGINAL_SHA256,
            "output": str(output), "output_sha256": sha256(output),
            "retained_original_files": len(base_hashes)-1,
            "added_native_files": injected,
            "conflicts_old_addons": list(OBSOLETE_ADDONS),
            "tested_on_carplay": False, "published_sileo": False}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--original", required=True, type=Path)
    parser.add_argument("--build-root", default=".", type=Path)
    parser.add_argument("--output", required=True, type=Path)
    arguments = parser.parse_args()
    try:
        print(json.dumps(assemble(arguments.original, arguments.build_root, arguments.output),
                         indent=2, ensure_ascii=False))
    except (ValueError, FileNotFoundError, subprocess.CalledProcessError) as error:
        print(f"OMNICAR_UNIFIED_BUILD_BLOCKED: {error}", file=sys.stderr)
        sys.exit(2)
