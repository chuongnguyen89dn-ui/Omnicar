#!/usr/bin/env python3
"""diff_payload.py — compare a built .deb against the original OmniCar 1.0.3 payload.

Usage:
    diff_payload.py <built.deb> [--orig-deb <original.deb>] [--orig-tree <dir>]

Defaults: --orig-deb  <repo-root>/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb
                      (the original DEB ships at the root of the Omnicar
                      repository, one level above this recovered-source tree)
          --orig-tree none: the original DEB is extracted to a temp dir.
                      Pass --orig-tree <dir> to compare against a
                      pre-extracted payload tree instead.
All defaults are derived from this script's own location inside the
checkout; no machine-specific paths are baked in.

Compares:
  * DEBIAN control fields (per field),
  * the payload file set (paths present on one side only),
  * per-file SHA-256 for every common file; for *.plist/*.strings whose bytes
    differ, the parsed plist content is compared and reported
    (serialization-only vs real content difference),
  * for every Mach-O file: a structural fingerprint via the wave-1 parsers
    (metadata/tools/macho_scan.py + macho_objc.py) — slice architectures,
    ObjC class-name set, method count (own classes + categories),
    defined-symbol set — printed as a table.

Exit status is 0 when the comparison ran to completion; differences are
reported as data, not treated as tool failure.
"""
import argparse
import hashlib
import os
import plistlib
import subprocess
import sys
import tempfile

# Recovered-source tree root, derived from this file's location:
# <root>/project/tools/diff_payload.py -> <root>. Portable across checkouts.
RE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(RE, "metadata", "tools"))
from macho_scan import split_fat, parse_slice  # noqa: E402
from macho_objc import Slice  # noqa: E402

MACHO_MAGICS = {b"\xca\xfe\xba\xbe", b"\xca\xfe\xba\xbf",
                b"\xcf\xfa\xed\xfe", b"\xce\xfa\xed\xfe"}


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def is_macho(path):
    with open(path, "rb") as f:
        return f.read(4) in MACHO_MAGICS


def list_files(root):
    out = []
    for dirpath, _dirs, files in os.walk(root):
        for name in files:
            out.append(os.path.relpath(os.path.join(dirpath, name), root))
    return sorted(out)


def parse_control(text):
    fields, key = {}, None
    for line in text.splitlines():
        if line.startswith((" ", "\t")) and key:
            fields[key] += "\n" + line
        elif ":" in line:
            key, val = line.split(":", 1)
            fields[key.strip()] = val.strip()
        else:
            key = None
    return fields


def fingerprint(path):
    """Structural fingerprint of one Mach-O file (fat or thin)."""
    data = open(path, "rb").read()
    archs, classes, cats, defsyms = [], set(), set(), set()
    method_keys = set()  # (owner, kind, selector) — dedupes identical fat slices
    for _cpu, off, size in split_fat(data):
        scan = parse_slice(data, off)
        archs.append(scan["cpu"])
        sl = Slice(data[off:off + size], scan)
        for s in sl.symbols:
            if s["kind"] not in ("undefined", "stab"):
                defsyms.add(s["name"])
        ob = sl.parse_objc()
        for c in ob["classes"]:
            classes.add(c["name"])
            for m in c.get("methods") or []:
                method_keys.add((c["name"], "inst", m.get("name")))
            for m in c.get("class_methods") or []:
                method_keys.add((c["name"], "cls", m.get("name")))
        for cat in ob["categories"]:
            cats.add(cat.get("name"))
            owner = f"{cat.get('target')}({cat.get('name')})"
            for m in cat.get("instance_methods") or []:
                method_keys.add((owner, "inst", m.get("name")))
            for m in cat.get("class_methods") or []:
                method_keys.add((owner, "cls", m.get("name")))
    return {"archs": sorted(archs), "classes": sorted(classes),
            "categories": sorted(cats), "methods": len(method_keys),
            "defined_symbols": sorted(defsyms)}


def setdiff_summary(a, b, limit=8):
    only_a = sorted(set(a) - set(b))
    only_b = sorted(set(b) - set(a))
    txt = f"{len(only_a)} only in first, {len(only_b)} only in second"
    for name in only_a[:limit]:
        txt += f"\n      - {name}"
    for name in only_b[:limit]:
        txt += f"\n      + {name}"
    if len(only_a) > limit or len(only_b) > limit:
        txt += "\n      …"
    return txt


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("built_deb")
    ap.add_argument("--orig-deb", default=os.path.join(
        os.path.dirname(RE), "com.anlai.omnicar_1.0.3_iphoneos-arm64.deb"))
    ap.add_argument("--orig-tree", default=None,
                    help="pre-extracted original payload tree; default: "
                         "extract --orig-deb into a temp dir")
    args = ap.parse_args()

    tmp = tempfile.mkdtemp(prefix="diff_payload_")
    if args.orig_tree is None:
        args.orig_tree = os.path.join(tmp, "orig")
        subprocess.run(["dpkg-deb", "-x", args.orig_deb, args.orig_tree],
                       check=True)
    built_tree = os.path.join(tmp, "built")
    subprocess.run(["dpkg-deb", "-x", args.built_deb, built_tree], check=True)
    built_ctl = subprocess.run(["dpkg-deb", "-f", args.built_deb],
                               capture_output=True, text=True, check=True).stdout
    orig_ctl = subprocess.run(["dpkg-deb", "-f", args.orig_deb],
                              capture_output=True, text=True, check=True).stdout

    print("=" * 78)
    print(f"BUILT:    {args.built_deb}")
    print(f"ORIGINAL: {args.orig_deb}  (tree: {args.orig_tree})")
    print("=" * 78)

    print("\n--- DEBIAN control fields ---")
    bc, oc = parse_control(built_ctl), parse_control(orig_ctl)
    for key in sorted(set(bc) | set(oc)):
        if bc.get(key) == oc.get(key):
            print(f"  SAME  {key}")
        else:
            print(f"  DIFF  {key}: original={oc.get(key)!r} built={bc.get(key)!r}")

    bfiles, ofiles = list_files(built_tree), list_files(args.orig_tree)
    print("\n--- Payload file set ---")
    print(f"  original: {len(ofiles)} files; built: {len(bfiles)} files")
    for p in sorted(set(ofiles) - set(bfiles)):
        print(f"  MISSING in built:   {p}")
    for p in sorted(set(bfiles) - set(ofiles)):
        print(f"  EXTRA in built:     {p}")

    common = sorted(set(bfiles) & set(ofiles))
    identical, hash_diff, macho_rows = 0, [], []
    for rel in common:
        bp, op = os.path.join(built_tree, rel), os.path.join(args.orig_tree, rel)
        if is_macho(op) or is_macho(bp):
            if sha256(bp) == sha256(op):
                macho_rows.append((rel, None, None, "BYTES EQUAL"))
                identical += 1
            else:
                macho_rows.append((rel, fingerprint(op), fingerprint(bp), ""))
            continue
        if sha256(bp) == sha256(op):
            identical += 1
            continue
        note = "bytes differ"
        if rel.endswith((".plist", ".strings")):
            try:
                with open(bp, "rb") as f:
                    bpl = plistlib.load(f)
                with open(op, "rb") as f:
                    opl = plistlib.load(f)
                note = ("plist CONTENT equal (serialization differs)"
                        if bpl == opl else "plist CONTENT differs")
            except Exception as e:  # unparsable plist: report raw
                note = f"bytes differ (plist parse failed: {e})"
        hash_diff.append((rel, note))

    print("\n--- Common non-Mach-O files ---")
    print(f"  byte-identical: {identical - sum(1 for r in macho_rows if r[3] == 'BYTES EQUAL')}"
          f" of {len(common) - len(macho_rows)}")
    for rel, note in hash_diff:
        print(f"  DIFF  {rel}: {note}")
    if not hash_diff:
        print("  (no differences)")

    print("\n--- Mach-O structural comparison ---")
    print(f"  {'file':58s} {'archs (orig -> built)':28s} classes methods defsyms")
    for rel, ofp, bfp, verdict in macho_rows:
        name = os.path.basename(rel)
        if verdict == "BYTES EQUAL":
            print(f"  {name:58s} BYTES EQUAL")
            continue
        arch_s = ",".join(ofp["archs"]) + " -> " + ",".join(bfp["archs"])
        print(f"  {name:58s} {arch_s:28s} "
              f"{len(ofp['classes'])}->{len(bfp['classes'])}  "
              f"{ofp['methods']}->{bfp['methods']}  "
              f"{len(ofp['defined_symbols'])}->{len(bfp['defined_symbols'])}")
        if ofp["classes"] != bfp["classes"]:
            print(f"      classes: {setdiff_summary(ofp['classes'], bfp['classes'])}")
        if ofp["categories"] != bfp["categories"]:
            print(f"      categories: {setdiff_summary(ofp['categories'], bfp['categories'])}")
        if ofp["defined_symbols"] != bfp["defined_symbols"]:
            print(f"      defined symbols: {setdiff_summary(ofp['defined_symbols'], bfp['defined_symbols'])}")

    print("\n--- Summary ---")
    print(f"  files: {len(ofiles)} original / {len(bfiles)} built / {len(common)} common")
    print(f"  common files byte-identical: {identical}")
    print(f"  common non-Mach-O files differing: {len(hash_diff)}")
    print(f"  Mach-O files compared: {len(macho_rows)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
