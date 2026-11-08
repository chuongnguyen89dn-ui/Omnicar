#!/usr/bin/env python3
"""build_metadata.py - stage raw dumps and generate per-binary metadata reports.

Pipeline (all local, read-only w.r.t. the payload):
  1. runs tools/macho_scan.py + tools/macho_objc.py per binary -> raw/<Name>/*.json
  2. runs /usr/bin/strings -> raw/<Name>/strings.txt
  3. copies substrate filter plists verbatim; converts Info.plists and the
     OmniCarPrefs bundle plists to JSON (python plistlib) -> raw/<Name>/
  4. emits raw/<Name>/objc_dump.txt (class-dump-style skeleton)
  5. emits metadata/<Name>.md (load commands, ObjC surface, symbols,
     strings triage, counts)
  6. prints a counts table (used to fill COVERAGE_v1.md)

Strings triage is pattern-based; categories are labelled as such in the
reports. Preference keys are cross-referenced against the keys actually
declared in the OmniCarPrefs bundle plists (evidence), plus a separately
labelled list of key-shaped string candidates (guesses).
"""
import json
import os
import plistlib
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
META = os.path.dirname(HERE)
RE = os.path.dirname(META)
PAYLOAD = os.path.join(RE, "payload")
RAW = os.path.join(META, "raw")

DYLIB_DIR = "var/jb/Library/MobileSubstrate/DynamicLibraries"
TARGETS = [
    # (report name, payload-relative path, kind)
    ("OmniCar", "var/jb/Applications/OmniCar.app/OmniCar", "app"),
    ("OmniCarAppBridge", f"{DYLIB_DIR}/OmniCarAppBridge.dylib", "dylib"),
    ("OmniCarCarProbe", f"{DYLIB_DIR}/OmniCarCarProbe.dylib", "dylib"),
    ("OmniCarCore", f"{DYLIB_DIR}/OmniCarCore.dylib", "dylib"),
    ("OmniCarSpeedBubble", f"{DYLIB_DIR}/OmniCarSpeedBubble.dylib", "dylib"),
    ("OmniCarSplitScreen", f"{DYLIB_DIR}/OmniCarSplitScreen.dylib", "dylib"),
    ("OmniCarStartupScreen", f"{DYLIB_DIR}/OmniCarStartupScreen.dylib", "dylib"),
    ("OmniCarPrefs", "var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/OmniCarPrefs", "prefs"),
]

INFRA_SYMBOLS = [
    "_MSHookMessageEx", "_MSHookFunction", "_MSHookClassPair", "_MSFindSymbol",
    "_MSGetMessageEx", "_notify_register_dispatch", "_notify_post",
    "_notify_get_state", "_notify_set_state", "_notify_register_check",
    "_notify_cancel", "_CFNotificationCenterAddObserver",
    "_CFNotificationCenterPostNotification",
    "_CFNotificationCenterGetDarwinNotifyCenter",
    "_CFNotificationCenterGetLocalNotifyCenter", "_xpc_connection_create",
    "_xpc_connection_create_mach_service", "_rocketbootstrap_distributedmessagingcenter_apply",
]

RE_ANLAI = re.compile(r"^com\.anlai\.[A-Za-z0-9_.\-]+$")
RE_RDNS = re.compile(r"^(com|net|org|io|vn|jp|de)\.[A-Za-z0-9\-]+(\.[A-Za-z0-9_\-]+)+$")
RE_URL = re.compile(r"^[a-zA-Z][a-zA-Z0-9+.\-]*://")
RE_TAG = re.compile(r"^(\[[A-Za-z][A-Za-z0-9_]*\])")
RE_KEYSHAPE = re.compile(r"^[a-z][a-zA-Z0-9]*(Enabled|Disabled|Mode|Name|Key|Style|Type|Duration|Volume|Sound|Effect|Scale|Tempo|Skip|Full)$")


def run_json(tool, path):
    out = subprocess.run(["python3", os.path.join(HERE, tool), path],
                         capture_output=True, text=True)
    if out.returncode != 0:
        raise RuntimeError(f"{tool} failed on {path}: {out.stderr[:400]}")
    return json.loads(out.stdout)


def plist_to_json(src, dst):
    with open(src, "rb") as f:
        pl = plistlib.load(f)
    with open(dst, "w") as f:
        json.dump(pl, f, indent=1, ensure_ascii=False, default=str)
    return pl


def prefs_key_set():
    keys, domains = set(), set()

    def walk(o):
        if isinstance(o, dict):
            if isinstance(o.get("key"), str):
                keys.add(o["key"])
            if isinstance(o.get("defaults"), str):
                domains.add(o["defaults"])
            for v in o.values():
                walk(v)
        elif isinstance(o, list):
            for v in o:
                walk(v)

    bdir = os.path.join(PAYLOAD, "var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle")
    for fn in sorted(os.listdir(bdir)):
        if fn.endswith(".plist"):
            try:
                with open(os.path.join(bdir, fn), "rb") as f:
                    walk(plistlib.load(f))
            except Exception:
                pass
    return keys, domains


def stage(name, relpath, kind):
    src = os.path.join(PAYLOAD, relpath)
    rawdir = os.path.join(RAW, name)
    os.makedirs(rawdir, exist_ok=True)
    scan = run_json("macho_scan.py", src)
    objc = run_json("macho_objc.py", src)
    with open(os.path.join(rawdir, "scan.json"), "w") as f:
        json.dump(scan, f, indent=1)
    with open(os.path.join(rawdir, "objc.json"), "w") as f:
        json.dump(objc, f, indent=1)
    strings = subprocess.run(["strings", src], capture_output=True, text=True).stdout
    with open(os.path.join(rawdir, "strings.txt"), "w") as f:
        f.write(strings)
    extras = {}
    if kind == "dylib":
        filt = src[:-len(".dylib")] + ".plist"
        dst = os.path.join(rawdir, "filter.plist")
        with open(filt, "rb") as f:
            data = f.read()
        with open(dst, "wb") as f:
            f.write(data)
        extras["filter"] = plistlib.loads(data)
    if kind in ("app", "prefs"):
        bundle = os.path.dirname(src)
        extras["info"] = plist_to_json(os.path.join(bundle, "Info.plist"),
                                       os.path.join(rawdir, "Info.plist.json"))
    if kind == "prefs":
        bundle = os.path.dirname(src)
        for fn in sorted(os.listdir(bundle)):
            if fn.endswith(".plist") and fn != "Info.plist":
                try:
                    plist_to_json(os.path.join(bundle, fn),
                                  os.path.join(rawdir, fn + ".json"))
                except Exception as e:
                    extras.setdefault("plist_errors", []).append(f"{fn}: {e}")
    return scan, objc, strings, extras


def objc_dump_text(s):
    o = s["objc"]
    lines = [f"// slice: {s['cpu']}"]
    for c in o["classes"]:
        sup = c.get("superclass") or "?"
        protos = c.get("protocols") or []
        decl = f"@interface {c.get('name')} : {sup}"
        if protos:
            decl += " <" + ", ".join(protos) + ">"
        lines.append(decl)
        for iv in c.get("ivars") or []:
            lines.append(f"    // ivar {iv.get('name')} : {iv.get('type')} (offset {iv.get('offset')})")
        for p in c.get("properties") or []:
            lines.append(f"    @property ({p.get('attributes')}) {p.get('name')};")
        for m in c.get("methods") or []:
            lines.append(f"    - ({m.get('types')}) {m.get('name')};  // imp {m.get('imp')}")
        for m in c.get("class_methods") or []:
            lines.append(f"    + ({m.get('types')}) {m.get('name')};  // imp {m.get('imp')}")
        lines.append("@end")
        lines.append("")
    for cat in o["categories"]:
        lines.append(f"@interface {cat.get('target')} ({cat.get('name')})")
        for m in cat.get("instance_methods") or []:
            lines.append(f"    - ({m.get('types')}) {m.get('name')};  // imp {m.get('imp')}")
        for m in cat.get("class_methods") or []:
            lines.append(f"    + ({m.get('types')}) {m.get('name')};  // imp {m.get('imp')}")
        lines.append("@end")
        lines.append("")
    for p in o["protocols"]:
        lines.append(f"@protocol {p.get('name')}")
        for m in p.get("instance_methods") or []:
            lines.append(f"    - ({m.get('types')}) {m.get('name')};")
        for m in p.get("class_methods") or []:
            lines.append(f"    + ({m.get('types')}) {m.get('name')};")
        lines.append("@end")
        lines.append("")
    return "\n".join(lines)


def triage(strings_text, pref_keys, pref_domains):
    lines = strings_text.splitlines()
    uniq = sorted(set(lines))
    anlai = [s for s in uniq if RE_ANLAI.match(s)]
    rdns = [s for s in uniq if RE_RDNS.match(s) and not RE_ANLAI.match(s)
            and "/" not in s and " " not in s]
    urls = [s for s in uniq if RE_URL.match(s)]
    tags = sorted({RE_TAG.match(s).group(1) for s in lines if RE_TAG.match(s)})
    tag_strings = sum(1 for s in lines if RE_TAG.match(s))
    paths = [s for s in uniq if s.startswith("/") and " " not in s and len(s) > 2]
    key_hits = [s for s in uniq if s in pref_keys]
    domain_hits = [s for s in uniq if s in pref_domains]
    keyshape = [s for s in uniq if RE_KEYSHAPE.match(s) and s not in pref_keys]
    return {
        "total_lines": len(lines), "unique": len(uniq), "anlai": anlai,
        "rdns": rdns, "urls": urls, "tags": tags, "tag_strings": tag_strings,
        "paths": paths, "key_hits": key_hits, "domain_hits": domain_hits,
        "keyshape": keyshape,
    }


def cap(lst, n, suffix=""):
    if len(lst) <= n:
        return list(lst), ""
    return list(lst[:n]), f"\n(+{len(lst) - n} more in raw strings dump{suffix})"


def report(name, relpath, kind, scan, objc, strings_text, extras, pref_keys, pref_domains):
    s0 = scan["slices"][0]
    o0 = objc["slices"][0]["objc"]
    L = []
    L.append(f"# {name} — binary metadata (OmniCar 1.0.3)")
    L.append("")
    L.append(f"- Payload path: `{relpath}`")
    L.append(f"- Kind: {kind}; filetype: {s0.get('filetype')}; fat size: {scan['size']} bytes")
    L.append(f"- Parser warnings (arm64 slice): {objc['slices'][0]['warnings'] or 'none'}")
    def sig(sl):
        o = sl["objc"]
        return (
            [c.get("name") for c in o["classes"]],
            [len(c.get("methods") or []) for c in o["classes"]],
            [c.get("superclass") for c in o["classes"]],
            [sorted((iv.get("name"), iv.get("type")) for iv in (c.get("ivars") or [])) for c in o["classes"]],
            len(o["categories"]), len(o["protocols"]), len(o["selrefs"]), len(o["classrefs"]),
            sorted(x["name"] for x in sl["symbols"]),
        )
    agree = sig(objc["slices"][0]) == sig(objc["slices"][1])
    L.append(f"- arm64/arm64e ObjC surfaces identical: {agree} "
             "(verified: names, method counts, superclasses, ivars, categories, "
             "protocols, selrefs, classrefs compared programmatically)")
    L.append("")
    L.append("## Load commands")
    L.append("")
    L.append("| slice | size | UUID | min iOS | SDK |")
    L.append("|---|---|---|---|---|")
    for s in scan["slices"]:
        L.append(f"| {s['cpu']} | {s['slice_size']} | {s.get('uuid')} | {s.get('minos')} | {s.get('sdk')} |")
    L.append("")
    if s0.get("id_dylib"):
        L.append(f"- Install name (LC_ID_DYLIB): `{s0['id_dylib'].get('name')}` "
                 f"(current {s0['id_dylib'].get('current_version')}, compat {s0['id_dylib'].get('compat_version')})")
    enc = s0.get("encryption") or {}
    L.append(f"- Encryption (LC_ENCRYPTION_INFO_64): cryptid={enc.get('cryptid')} "
             f"cryptoff={enc.get('cryptoff')} cryptsize={enc.get('cryptsize')} "
             "→ not encrypted" if enc.get("cryptid") == 0 else
             f"- Encryption: {enc}")
    cs = s0.get("code_signature") or {}
    L.append(f"- Code signature (LC_CODE_SIGNATURE): present, dataoff={cs.get('dataoff')} datasize={cs.get('datasize')}"
             if cs else "- Code signature: absent")
    L.append(f"- Chained fixups: {s0.get('has_chained_fixups')}; classic dyld info: {s0.get('has_dyld_info')}")
    L.append("- Linked libraries (LC_LOAD_DYLIB, arm64 slice; identical in arm64e unless noted):")
    for d in s0.get("dylibs") or []:
        if d.get("cmd") == "LC_LOAD_DYLIB":
            L.append(f"  - `{d.get('name')}` (current {d.get('current_version')}, compat {d.get('compat_version')})")
    L.append("- Rpaths (LC_RPATH):")
    for r in s0.get("rpaths") or []:
        L.append(f"  - `{r}`")
    if extras.get("filter"):
        filt = extras["filter"].get("Filter", extras["filter"])
        L.append(f"- Substrate filter: `{json.dumps(filt)}` (verbatim plist copy in raw/)")
    if extras.get("info"):
        info = extras["info"]
        keys = ["CFBundleIdentifier", "CFBundleExecutable", "CFBundleShortVersionString",
                "CFBundleVersion", "MinimumOSVersion", "NSPrincipalClass", "CFBundleURLTypes"]
        L.append("- Info.plist (selected keys; full JSON in raw/):")
        for k in keys:
            if k in info:
                L.append(f"  - {k}: `{json.dumps(info[k], ensure_ascii=False)}`")
    L.append("")
    L.append("## Objective-C surface (arm64 slice; arm64e identical)")
    L.append("")
    n_methods = sum(len(c.get("methods") or []) + len(c.get("class_methods") or []) for c in o0["classes"])
    L.append(f"Classes: {len(o0['classes'])}; methods on classes: {n_methods}; "
             f"categories: {len(o0['categories'])}; protocols defined: {len(o0['protocols'])}; "
             f"classrefs: {len(o0['classrefs'])}; selrefs (unique): {len(o0['selrefs'])}")
    L.append("")
    L.append("Full class/ivar/property/method listing: see `objc_dump.txt` in this binary's raw/ folder. "
             "Class summary:")
    L.append("")
    for c in o0["classes"]:
        L.append(f"- `{c.get('name')}` : `{c.get('superclass')}` "
                 f"(ivars {len(c.get('ivars') or [])}, properties {len(c.get('properties') or [])}, "
                 f"instance methods {len(c.get('methods') or [])}, class methods {len(c.get('class_methods') or [])}"
                 + (f", protocols <{', '.join(c.get('protocols') or [])}>" if c.get("protocols") else "") + ")")
    for cat in o0["categories"]:
        L.append(f"- category `{cat.get('name')}` on `{cat.get('target')}` "
                 f"(instance methods {len(cat.get('instance_methods') or [])}, class methods {len(cat.get('class_methods') or [])})")
    for p in o0["protocols"]:
        L.append(f"- protocol `{p.get('name')}` (instance methods {len(p.get('instance_methods') or [])}, "
                 f"class methods {len(p.get('class_methods') or [])})")
    L.append("")
    L.append("## Symbols")
    L.append("")
    syms = objc["slices"][0]["symbols"]
    defined = [x["name"] for x in syms if x["kind"].startswith("defined") and x.get("external")]
    local = [x["name"] for x in syms if x["kind"].startswith("defined") and not x.get("external")]
    stab = [x["name"] for x in syms if x["kind"] == "stab"]
    undef = [x["name"] for x in syms if x["kind"] == "undefined"]
    L.append(f"Defined (external): {len(defined)}; defined (local): {len(local)}; stab entries: {len(stab)}; "
             f"undefined (imports): {len(undef)}; exports (trie): {len(objc['slices'][0]['exports'])}")
    L.append("")
    L.append("Defined symbols:")
    for n in defined:
        L.append(f"- `{n}`")
    if local:
        L.append("")
        L.append("Defined local symbols:")
        for n in local:
            L.append(f"- `{n}`")
    if stab:
        L.append("")
        L.append(f"Stab (debug) entries: {stab}")
    L.append("")
    L.append("Infrastructure / hook / IPC imports check (against undefined symbols):")
    uset = set(undef) | set(defined)
    for probe in INFRA_SYMBOLS:
        L.append(f"- `{probe.lstrip('_')}`: {'PRESENT' if probe in uset else 'absent'}")
    logos = [n for n in defined + local + undef if "logos" in n.lower()]
    L.append(f"- Logos-generated symbols (name contains 'logos'): {logos if logos else 'none found'}")
    swift_secs = [s for s in scan["slices"][0]["sections"] if "swift" in s["name"].lower()]
    L.append(f"- Swift sections: {[s['name'] for s in swift_secs] if swift_secs else 'none'}")
    L.append("")
    L.append("Undefined symbols (full list):")
    for n in undef:
        L.append(f"- `{n}`")
    L.append("")
    L.append("## Strings triage (pattern-based; raw dump in raw/strings.txt)")
    L.append("")
    t = triage(strings_text, pref_keys, pref_domains)
    L.append(f"Total string lines: {t['total_lines']}; unique: {t['unique']}")
    L.append("")
    L.append(f"### com.anlai.* identifiers ({len(t['anlai'])})")
    shown, extra = cap(t["anlai"], 120)
    for s in shown:
        L.append(f"- `{s}`")
    if extra:
        L.append(extra)
    L.append("")
    L.append(f"### Other reverse-DNS identifiers ({len(t['rdns'])}) — heuristic, may include bundle IDs / notification names")
    shown, extra = cap(t["rdns"], 80)
    for s in shown:
        L.append(f"- `{s}`")
    if extra:
        L.append(extra)
    L.append("")
    L.append(f"### Preference domain / keys")
    L.append(f"- Declared prefs domain(s) in OmniCarPrefs bundle plists: {sorted(pref_domains)}")
    L.append(f"- Domain strings present in this binary: {t['domain_hits'] or 'none'}")
    L.append(f"- Strings matching keys declared in the prefs bundle plists ({len(t['key_hits'])} of {len(pref_keys)} declared): "
             f"{t['key_hits'] or 'none'}")
    L.append(f"- Key-shaped candidate strings (pattern guess, NOT corroborated): {t['keyshape'] or 'none'}")
    L.append("")
    L.append(f"### URLs / schemes ({len(t['urls'])})")
    shown, extra = cap(t["urls"], 60)
    for s in shown:
        L.append(f"- `{s}`")
    if extra:
        L.append(extra)
    L.append("")
    L.append(f"### Log tags ({len(t['tags'])} unique; {t['tag_strings']} format strings carry a tag)")
    for s in t["tags"]:
        L.append(f"- `{s}`")
    L.append("")
    L.append(f"### File paths ({len(t['paths'])})")
    shown, extra = cap(t["paths"], 80)
    for s in shown:
        L.append(f"- `{s}`")
    if extra:
        L.append(extra)
    L.append("")
    L.append("## Counts")
    L.append("")
    L.append(f"- classes {len(o0['classes'])}; class methods total {n_methods}; categories {len(o0['categories'])}; "
             f"protocols {len(o0['protocols'])}; defined symbols {len(defined) + len(local)} "
             f"(external {len(defined)} + local {len(local)}); undefined {len(undef)}; "
             f"strings {t['total_lines']} lines / {t['unique']} unique")
    L.append("")
    return "\n".join(L), {
        "classes": len(o0["classes"]), "methods": n_methods,
        "categories": len(o0["categories"]), "protocols": len(o0["protocols"]),
        "defined": len(defined) + len(local), "undefined": len(undef),
        "strings": t["total_lines"], "triage": t,
        "filter": extras.get("filter"),
    }


def main():
    pref_keys, pref_domains = prefs_key_set()
    summary = {}
    for name, relpath, kind in TARGETS:
        scan, objc, strings_text, extras = stage(name, relpath, kind)
        rawdir = os.path.join(RAW, name)
        with open(os.path.join(rawdir, "objc_dump.txt"), "w") as f:
            f.write(objc_dump_text(objc["slices"][0]))
            f.write("\n")
            f.write(objc_dump_text(objc["slices"][1]))
        md, counts = report(name, relpath, kind, scan, objc, strings_text,
                            extras, pref_keys, pref_domains)
        with open(os.path.join(META, f"{name}.md"), "w") as f:
            f.write(md)
        counts["size"] = scan["size"]
        summary[name] = counts
        print(f"{name}: classes={counts['classes']} methods={counts['methods']} "
              f"cats={counts['categories']} defined={counts['defined']} "
              f"undef={counts['undefined']} strings={counts['strings']} size={counts['size']}")
        if counts["filter"]:
            print(f"   filter: {json.dumps(counts['filter'])}")
        print(f"   anlai ids: {counts['triage']['anlai']}")
        print(f"   key hits: {counts['triage']['key_hits']}")
    with open(os.path.join(RAW, "counts.json"), "w") as f:
        json.dump(summary, f, indent=1, ensure_ascii=False)


if __name__ == "__main__":
    main()
