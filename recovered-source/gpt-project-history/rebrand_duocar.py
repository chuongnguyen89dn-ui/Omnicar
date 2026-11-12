#!/usr/bin/env python3
"""Rebrand the HL21 build tree to DuoCar BEFORE compiling.

No Mach-O byte patching, no alteration of existing signed DEBs, and no migration
of the legacy preference domain. No automatic removal/conflict with old package: owner will uninstall manually.
Run from the repository root:
  python3 recovered-source/gpt-project-history/rebrand_duocar.py
"""
from __future__ import annotations

import codecs
import os
from pathlib import Path
import plistlib
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project"
SOURCE = ROOT / "src"
assert PROJECT.is_dir() and SOURCE.is_dir(), (PROJECT, SOURCE)

# Longest/specific forms first. Replacing OMC class and helper identifiers in
# ALL source files is necessary because Objective-C selectors, keys and shared
# C symbols must agree across the eight separately compiled executables.
REPLACEMENTS = [
    ("com.anlai.omnicar", "com.chuong.duocar"),
    ("COM.ANLAI.OMNICAR", "COM.CHUONG.DUOCAR"),
    ("OmniCar", "DuoCar"),
    ("OMNICAR", "DUOCAR"),
    ("omnicar", "duocar"),
    ("Omnicar", "Duocar"),
    ("omniCar", "duoCar"),
    ("OMC", "DCR"),
    ("omc", "dcr"),
    ("Omc", "Dcr"),
]
ORIGINAL_MARKERS = tuple(k for k,_ in REPLACEMENTS)
LEGACY_PKG = "com.anlai." + "omni" + "car"  # control-only safety exception
NEW_PKG = "com.chuong.duocar"
TEXT_EXTENSIONS = {
    ".m", ".mm", ".h", ".c", ".cpp", ".cc", ".hpp", ".mk", ".py",
    ".txt", ".md", ".json", ".xml", ".sh", ".strings", ".stringsdict",
    ".entitlements", ".pch", ".xcconfig", ".yml", ".yaml", ".ini",
    ".cfg", ".html", ".css", ".js", ".swift", ".def", ".inc", ".modulemap",
}
TEXT_BASENAMES = {"Makefile", "control", "rules", "postinst", "prerm", "postrm", "preinst"}
REPORT = {"files_changed": 0, "paths_changed": 0, "plist_changed": 0, "text_changed": 0, "visited": 0}

def change(text: str) -> str:
    for old, new in REPLACEMENTS:
        text = text.replace(old, new)
    return text

def change_tree(obj):
    if isinstance(obj, str):
        return change(obj)
    if isinstance(obj, list):
        return [change_tree(v) for v in obj]
    if isinstance(obj, tuple):
        return tuple(change_tree(v) for v in obj)
    if isinstance(obj, dict):
        return {change_tree(k): change_tree(v) for k,v in obj.items()}
    return obj

def decode_text(data: bytes, suffix: str):
    if data.startswith(codecs.BOM_UTF16_LE) or data.startswith(codecs.BOM_UTF16_BE):
        return data.decode("utf-16"), "utf-16"
    if data.startswith(codecs.BOM_UTF8):
        return data.decode("utf-8-sig"), "utf-8-sig"
    if suffix in (".strings", ".stringsdict") and data[:100].count(b"\0") > 10:
        return data.decode("utf-16-le"), "utf-16-le"
    return data.decode("utf-8"), "utf-8"

def rewrite_file(path: Path):
    if path.is_symlink():
        raise RuntimeError(f"Unexpected symlink under renamed source tree: {path}")
    data = path.read_bytes()
    REPORT["visited"] += 1
    # Read *binary* property lists structurally; an ASCII regex in bplist00
    # would corrupt offset tables or leave embedded CF strings unchanged.
    # Localizations use bplist00 even with the .strings extension, not just .plist.
    if data.startswith(b"bplist00"):
        obj = plistlib.loads(data)
        changed = change_tree(obj)
        if changed != obj:
            path.write_bytes(plistlib.dumps(changed, fmt=plistlib.FMT_BINARY, sort_keys=False))
            REPORT["files_changed"] += 1
            REPORT["plist_changed"] += 1
        return
    if path.suffix in (".plist", ".strings", ".stringsdict") and (data.startswith(b"<?xml") or data.startswith(b"\xef\xbb\xbf<?xml")):
        obj = plistlib.loads(data)
        changed = change_tree(obj)
        if changed != obj:
            path.write_bytes(plistlib.dumps(changed, fmt=plistlib.FMT_XML, sort_keys=False))
            REPORT["files_changed"] += 1
            REPORT["plist_changed"] += 1
        return
    if path.suffix in TEXT_EXTENSIONS or path.name in TEXT_BASENAMES:
        try:
            text, encoding = decode_text(data, path.suffix)
        except UnicodeDecodeError:
            if b"omnicar" in data.lower() or b"OMC" in data:
                raise RuntimeError(f"Unparsed binary with legacy identifier: {path}")
            return
        rewritten = change(text)
        if rewritten != text:
            path.write_bytes(rewritten.encode(encoding))
            REPORT["files_changed"] += 1
            REPORT["text_changed"] += 1
        return
    # Binary resources (PNG, compiled blobs) are never hex-edited in place.
    # Any legacy string found inside one is a hard failure, not a silent leak.
    lowered = data.lower()
    if b"omnicar" in lowered or b"com.anlai." + b"omni" + b"car" in lowered:
        raise RuntimeError(f"Untransformed branded binary asset: {path}")

# Rewrite build inputs, not archives/disassemblies/old signed DEBs.
# Keeping forensic sources out of the active rename is intentional.
PROJECT_MODULES = (
    "OMCCommon", "OmniCarApp", "OmniCarCore", "OmniCarAppBridge",
    "OmniCarCarProbe", "OmniCarSpeedBubble", "OmniCarSplitScreen",
    "OmniCarStartupScreen", "OmniCarPrefs", "layout",
)
ACTIVE_SRC_EXT = {".m", ".mm", ".h", ".c", ".cpp", ".cc", ".hpp", ".mk", ".plist", ".strings"}
ACTIVE_SRC_FILES = {"Makefile"}

def path_sources():
    sources = [PROJECT/"Makefile", PROJECT/"control"]
    for name in PROJECT_MODULES:
        folder = PROJECT/name
        assert folder.is_dir(), folder
        sources += [p for p in folder.rglob("*") if p.is_file()]
    for folder in SOURCE.iterdir():
        if not folder.is_dir():
            continue
        for item in folder.iterdir():
            if item.is_file() and (item.suffix in ACTIVE_SRC_EXT or item.name in ACTIVE_SRC_FILES):
                sources.append(item)
            if item.is_dir() and item.name == "Resources":
                sources += [p for p in item.rglob("*") if p.is_file()]
    return sorted(set(sources), key=str)

def rename_build_paths():
    # Rename the same scope as path_sources, including packaging layout.
    roots = [PROJECT/name for name in PROJECT_MODULES]
    for folder in SOURCE.iterdir():
        if folder.is_dir() and (folder/"Resources").is_dir():
            roots.append(folder/"Resources")
    for folder in roots:
        for path in sorted(folder.rglob("*"), key=lambda p:(len(p.parts),str(p)), reverse=True):
            name = change(path.name)
            if name != path.name:
                target = path.with_name(name)
                if target.exists():
                    raise RuntimeError(f"Path collision: {path} -> {target}")
                path.rename(target)
                REPORT["paths_changed"] += 1
        name = change(folder.name)
        if name != folder.name:
            target = folder.with_name(name)
            if target.exists():
                raise RuntimeError(f"Path collision: {folder} -> {target}")
            folder.rename(target)
            REPORT["paths_changed"] += 1
    for folder in SOURCE.iterdir():
        if folder.is_dir():
            for path in [p for p in folder.iterdir() if p.is_file() and p.suffix in ACTIVE_SRC_EXT]:
                name = change(path.name)
                if name != path.name:
                    target=path.with_name(name)
                    if target.exists():
                        raise RuntimeError(f"Path collision: {path} -> {target}")
                    path.rename(target)
                    REPORT["paths_changed"] += 1
    # No archive or historical source directory is renamed.

def update_control():
    file = PROJECT / "control"
    content = file.read_text()
    lines = content.splitlines()
    out=[]
    found_conflicts=False
    for line in lines:
        if line.startswith("Replaces:"):
            # A separately identified app must never overwrite other package files.
            continue
        if line.startswith("Package:"):
            line = "Package: " + NEW_PKG
        if line.startswith("Name:"):
            line = "Name: DuoCar"
        if line.startswith("Version:"):
            line = "Version: 1.0.3-hl34nativeowner"
        if line.startswith("Maintainer:"):
            line = "Maintainer: DuoCar Project"
        if line.startswith("Author:"):
            line = "Author: DuoCar Project"
        if line.startswith("Conflicts:"):
            # Retain the source's preexisting unrelated tweak incompatibilities,
            # but NEVER make Sileo demand removal of the old package.
            found_conflicts = True
            old = [x.strip() for x in line.partition(":")[2].split(",") if x.strip() and x.strip() != LEGACY_PKG]
            if not old:
                continue
            line = "Conflicts: " + ", ".join(old)
        out.append(line)
    file.write_text("\n".join(out).rstrip()+"\n",encoding="utf-8")
    assert LEGACY_PKG not in file.read_text(), "Old package must NOT be a Conflicts/Replaces dependency"
    assert "Package: " + NEW_PKG + "\n" in file.read_text()

def verify_no_legacy():
    # Verify only the build input set and the install layout, not archived
    # disassembly or historical .deb files from the original research repo.
    after_files = [PROJECT/"Makefile", PROJECT/"control"]
    after_files += [p for dirname in PROJECT_MODULES for p in
                    (PROJECT/change(dirname)).rglob("*") if p.is_file()]
    for folder in SOURCE.iterdir():
        if folder.is_dir():
            after_files += [p for p in folder.iterdir()
                            if p.is_file() and p.suffix in ACTIVE_SRC_EXT]
            resources = folder/"Resources"
            if resources.is_dir():
                after_files += [p for p in resources.rglob("*") if p.is_file()]
    for path in after_files:
        if "omnicar" in str(path.relative_to(ROOT)).lower():
            raise RuntimeError(f"Legacy name leaked in build path: {path}")
        data = path.read_bytes()
        if b"omnicar" in data.lower() or "OmniCar".encode("utf-16-le") in data:
            raise RuntimeError(f"Legacy OmniCar content in build source: {path}")
        if path.suffix in (".m", ".mm", ".h", ".c", ".cpp", ".mk",".plist"):
            if b"OMC" in data or b"omc" in data:
                raise RuntimeError(f"Old abbreviated OMC identifier in: {path}")
    c = (PROJECT/"control").read_text()
    assert "Package: com.chuong.duocar" in c
    assert LEGACY_PKG not in c
    assert "Replaces:" not in c
    print("DUOCAR_REBRAND_BUILD_INPUTS_VERIFIED",len(after_files))

for path in path_sources():
    rewrite_file(path)
rename_build_paths()
update_control()
verify_no_legacy()
print("DUOCAR_SOURCE_REBRAND_PASS",REPORT)
print("Package=com.chuong.duocar; App=DuoCar; PreferenceBundle=DuoCarPrefs; URL=duocar://")
print("No legacy package Conflicts/Replaces; the owner manually removes the old tweak")
