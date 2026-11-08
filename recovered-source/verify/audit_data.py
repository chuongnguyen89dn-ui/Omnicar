#!/usr/bin/env python3
"""audit_data.py -- sample-check ldr-line data annotations (classref/selref/
got claims) in src/*/disasm/ against independent slot resolution."""
import os, re, sys, json, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from macho_truth import MachO

ROOT = os.path.expanduser("~/workspace/omnicar-re")
P = ROOT + "/payload/var/jb/"
MODULES = {
    "OMCCommon":     P + "Library/MobileSubstrate/DynamicLibraries/OmniCarCore.dylib",
    "App":           P + "Applications/OmniCar.app/OmniCar",
    "AppBridgeA":    P + "Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib",
    "AppBridgeB":    P + "Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib",
    "CarProbe":      P + "Library/MobileSubstrate/DynamicLibraries/OmniCarCarProbe.dylib",
    "Prefs":         P + "Library/PreferenceBundles/OmniCarPrefs.bundle/OmniCarPrefs",
    "SpeedBubble":   P + "Library/MobileSubstrate/DynamicLibraries/OmniCarSpeedBubble.dylib",
    "SplitScreenA":  P + "Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib",
    "SplitScreenB":  P + "Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib",
    "StartupScreen": P + "Library/MobileSubstrate/DynamicLibraries/OmniCarStartupScreen.dylib",
}

PATTERNS = [
    ("classref", re.compile(r"\[0x([0-9a-fA-F]+)\]\s+classref -> ([A-Za-z0-9_]+)")),
    ("selref",   re.compile(r"\[0x([0-9a-fA-F]+)\]\s+selref -> @(\S+)")),
    ("gotimp",   re.compile(r"\[0x([0-9a-fA-F]+)\]\s+[^;]*?\(= import (\S+)\)")),
    ("class",    re.compile(r"\[0x([0-9a-fA-F]+)\]\s+class:([A-Za-z0-9_]+)")),
    ("sel",      re.compile(r"\[0x([0-9a-fA-F]+)\]\s+sel:(\S+)")),
]
TRACK_PAT = re.compile(r"^\s*(0x[0-9a-fA-F]+|[0-9a-fA-F]+):?\s+(adrp|ldr)\s+(.+?)(?:\s*;\s*(.*))?$")
ANN_TRACK = [
    ("class", re.compile(r"^@CLASS\s+(\S+)")),
    ("got",   re.compile(r"^@GOT\s+(\S+)")),
    ("class", re.compile(r"^bind\s+_OBJC_CLASS_\$_(.+)$")),
    ("got",   re.compile(r"^bind\s+(\S+)$")),
]

def check(m, kind, claim, slot):
    tk, tv = m.slot_truth(slot)
    if kind in ("classref", "class"):
        return ("correct" if (tk == "class" and tv == claim) else
                ("unresolvable" if tv is None else "wrong")), tk, tv
    if kind in ("selref", "sel"):
        return ("correct" if (tk == "sel" and tv == claim) else
                ("unresolvable" if tv is None else "wrong")), tk, tv
    # got/import claims: symbol may come from la map, got bind, or stub-adjacent
    if tk == "got-sym":
        return (("correct" if tv == claim else "wrong")), tk, tv
    if tk == "bind":
        return (("correct" if tv == claim else "wrong")), tk, tv
    return ("unresolvable", tk, tv)

def main():
    random.seed(42)
    out = {}
    for mod, binpath in MODULES.items():
        m = MachO(binpath)
        ddir = os.path.join(ROOT, "src", mod, "disasm")
        found = []   # (kind, claim, slot, file)
        if os.path.isdir(ddir):
            for fn in sorted(os.listdir(ddir)):
                fp = os.path.join(ddir, fn)
                if not os.path.isfile(fp): continue
                pages = {}
                for ln in open(fp, errors="replace"):
                    for kind, pat in PATTERNS:
                        mm = pat.search(ln)
                        if mm:
                            found.append((kind, mm.group(2), int(mm.group(1), 16), fn))
                            break
                    tm = TRACK_PAT.match(ln)
                    if tm and tm.group(4):
                        ann = tm.group(4)
                        for kind, apat in ANN_TRACK:
                            am = apat.match(ann)
                            if am:
                                ops = tm.group(3)
                                ldr = re.match(r"(\w+), \[(\w+), #(-?0x[0-9a-fA-F]+|\d+)\]", ops)
                                if tm.group(2) == "ldr" and ldr and ldr.group(2) in pages:
                                    slot = pages[ldr.group(2)] + int(ldr.group(3), 16)
                                    found.append((kind, am.group(1), slot, fn))
                                break
                        if tm.group(2) == "adrp":
                            pm = re.match(r"(\w+), #(0x[0-9a-fA-F]+)", tm.group(3))
                            if pm: pages[pm.group(1)] = int(pm.group(2), 16)
                    elif tm and tm.group(2) == "adrp":
                        pm = re.match(r"(\w+), #(0x[0-9a-fA-F]+)", tm.group(3))
                        if pm: pages[pm.group(1)] = int(pm.group(2), 16)
        stats = {}
        wrong = []
        # full population for slot-printed kinds; cap tracked kinds at 200
        by_kind = {}
        for item in found: by_kind.setdefault(item[0], []).append(item)
        total_checked = 0
        for kind, items in by_kind.items():
            random.shuffle(items)
            cap = 200 if kind in ("class", "got") and len(items) > 400 else len(items)
            st = dict(found=len(items), sampled=0, correct=0, wrong=0, unresolvable=0)
            for _k, claim, slot, fn in items[:cap]:
                st["sampled"] += 1
                verdict, tk, tv = check(m, kind, claim, slot)
                st[verdict] += 1
                if verdict == "wrong" and len(wrong) < 25:
                    wrong.append(dict(file=fn, slot=hex(slot), claim="%s:%s" % (kind, claim),
                                      truth="%s:%s" % (tk, tv)))
            stats[kind] = st
            total_checked += st["sampled"]
        out[mod] = dict(stats=stats, wrong=wrong)
        print("%-14s %s" % (mod, {k: (v["found"], v["sampled"], v["correct"], v["wrong"], v["unresolvable"]) for k, v in stats.items()}))
    json.dump(out, open(os.path.join(ROOT, "verify", "audit_data.json"), "w"), indent=1)

if __name__ == "__main__":
    main()
