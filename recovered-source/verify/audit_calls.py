#!/usr/bin/env python3
"""audit_calls.py -- judge every annotated bl/b target in src/*/disasm/
against independent ground truth (macho_truth.py)."""
import os, re, sys, json, bisect
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from macho_truth import MachO
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN

# Tree root derived from this file's location: <root>/verify/audit_calls.py.
# The audit reads <root>/payload/ — recreate it from the original DEB at the
# repository root with: dpkg-deb -x <repo>/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb <root>/payload
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
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

LINE = re.compile(r"^\s*(0x[0-9a-fA-F]+|[0-9a-fA-F]+):?\s+(bl|b)\s+#0x([0-9a-fA-F]+)\s*;\s*(.+?)\s*$")

def parse_claim(text):
    t = text.split("|")[0].strip()
    t = re.sub(r"\s*\(sel=[^)]*\)\s*$", "", t)  # trailing "(sel=<enclosing>)" commentary
    t = re.sub(r"^(call\s+|CALL\s+|->\s*|import\s+|stub:\s*|sym:\s*|bind\s+)+", "", t)
    t = re.sub(r"^(stub|sym):\s*", "", t)
    m = re.match(r"^objc_stub\[(.+)\]$", t)
    if m: return ("selstub", m.group(1))
    m = re.match(r"^_?objc_msgSend\((.+)\)$", t)
    if m: return ("msgsend", m.group(1))
    m = re.match(r"^objc_msgSend:\s*(.+)$", t)
    if m: return ("msgsend", m.group(1).strip())
    if t.startswith("objc_msgSend$"):
        return ("selstub", t[len("objc_msgSend$"):])
    m = re.match(r"^objc_msgSend\s+sel=(.+)$", t)
    if m: return ("msgsend", m.group(1).strip())
    m = re.match(r"^objc_msgSend\s*\[(.+)\]$", t)
    if m: return ("msgsend", m.group(1).strip())
    m = re.match(r'^msgSend\s+"([^"]+)"$', t)
    if m: return ("msgsend", m.group(1))
    m = re.match(r"^msgSend\s+(\S+)$", t)
    if m: return ("msgsend", m.group(1))
    m = re.match(r"^sub_([0-9a-fA-F]+)$", t)
    if m: return ("sub", int(m.group(1), 16))
    if re.match(r"^[A-Za-z_$][A-Za-z0-9_$:.]*$", t):
        return ("sym", t)
    return ("other", t)

def sym_eq(a, b):
    if a == b: return "exact"
    if a.lstrip("_") == b.lstrip("_"): return "cosmetic"
    return None

_md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)

def selector_at_callsite(m, func_starts, callsite):
    """Track x1 back from callsite inside its function; if it was loaded
    from an __objc_selrefs slot, return that selector."""
    i = bisect.bisect_right(func_starts, callsite) - 1
    if i < 0: return None
    start = func_starts[i]
    if callsite - start > 0x8000: return None
    code = m.read(start, callsite - start)
    pages = {}
    x1_sel = None
    x1_state = "unknown"
    for ins in _md.disasm(code, start):
        mn, ops = ins.mnemonic, ins.op_str
        parts = [p.strip() for p in ops.split(",")]
        if mn == "adrp" and len(parts) == 2 and parts[1].startswith("#"):
            try: pages[parts[0]] = int(parts[1][1:], 16)
            except ValueError: pass
            if parts[0] == "x1": x1_state = "other"
        elif mn == "ldr" and len(parts) >= 2 and parts[0] == "x1":
            mm = re.match(r"\[(\w+)(?:, #(-?0x[0-9a-fA-F]+|\d+))?\]", parts[1])
            if mm and mm.group(1) in pages:
                off = int(mm.group(2), 16) if mm.group(2) else 0
                slot = pages[mm.group(1)] + off
                if m.in_section(slot, "__objc_selrefs"):
                    kind, name = m.slot_truth(slot)
                    if kind == "sel" and name:
                        x1_sel, x1_state = name, "sel"
                        continue
                x1_state = "other"
            else:
                x1_state = "other"
        elif mn in ("bl", "blr", "br", "b") :
            if mn == "bl": x1_state = "unknown"
        else:
            # any other write to x1 kills provenance
            if parts and parts[0] == "x1" and mn not in ("cmp", "cmn", "tst", "str", "stur"):
                x1_state = "other"
    return x1_sel if x1_state == "sel" else None

def main():
    results = {}
    for mod, binpath in MODULES.items():
        m = MachO(binpath)
        fstarts = m.func_starts
        if m.image_base and fstarts and fstarts[-1] < m.image_base:
            fstarts = [m.image_base + a for a in fstarts]
        ddir = os.path.join(ROOT, "src", mod, "disasm")
        stats = dict(files=0, lines=0, checked=0, correct=0, cosmetic=0, wrong=0,
                     imprecise=0, unresolvable=0, other=0, branch_ok=0, branch_bad=0)
        wrong_ex, other_ex = [], []
        if not os.path.isdir(ddir):
            results[mod] = dict(stats=stats, wrong=wrong_ex, note="no disasm dir")
            continue
        for fn in sorted(os.listdir(ddir)):
            fp = os.path.join(ddir, fn)
            if not os.path.isfile(fp): continue
            stats["files"] += 1
            try:
                lines = open(fp, errors="replace").read().splitlines()
            except OSError:
                continue
            for ln in lines:
                mm = LINE.match(ln)
                if not mm: continue
                stats["lines"] += 1
                cs = int(mm.group(1), 16)
                mn = mm.group(2)
                tgt = int(mm.group(3), 16)
                claim = parse_claim(mm.group(4))
                if claim[0] == "other":
                    stats["other"] += 1
                    if len(other_ex) < 8: other_ex.append((fn, cs, tgt, mm.group(4)))
                    continue
                tkind, tname = m.call_truth(tgt)
                is_branch_local = (mn == "b" and tkind == "text")
                verdict = None
                if tkind == "stub":
                    if claim[0] == "sym":
                        eq = sym_eq(claim[1], tname)
                        verdict = "correct" if eq == "exact" else ("cosmetic" if eq else "wrong")
                    elif claim[0] == "msgsend" and tname == "_objc_msgSend":
                        sel = selector_at_callsite(m, fstarts, cs)
                        if sel is None: verdict = "unresolvable"
                        else: verdict = "correct" if sel == claim[1] else "wrong"
                    elif claim[0] in ("msgsend", "selstub", "sub"):
                        verdict = "wrong"
                elif tkind == "selstub":
                    if claim[0] in ("selstub", "msgsend"):
                        verdict = "correct" if claim[1] == tname else "wrong"
                    elif claim[0] == "sym" and claim[1].lstrip("_") == "objc_msgSend":
                        verdict = "imprecise"
                    elif claim[0] in ("sym", "sub"):
                        verdict = "wrong"
                elif tkind == "defined":
                    if claim[0] == "sym":
                        eq = sym_eq(claim[1], tname)
                        verdict = "correct" if eq == "exact" else ("cosmetic" if eq else "wrong")
                    elif claim[0] == "sub":
                        verdict = "imprecise"
                    else:
                        verdict = "wrong"
                elif tkind == "text":
                    if claim[0] == "sub":
                        verdict = "correct" if claim[1] == tgt else "wrong"
                    else:
                        verdict = "wrong"
                if is_branch_local:
                    if verdict == "correct": stats["branch_ok"] += 1
                    elif verdict == "wrong": stats["branch_bad"] += 1
                    continue
                stats["checked"] += 1
                stats[verdict] += 1
                if verdict == "wrong" and len(wrong_ex) < 400:
                    truth_desc = tname if tname else ("sub_%x" % tgt)
                    if tkind == "stub" and claim[0] == "msgsend":
                        truth_desc = "_objc_msgSend(sel=%s)" % selector_at_callsite(m, fstarts, cs)
                    wrong_ex.append(dict(file=fn, site=hex(cs), target=hex(tgt),
                                         claim="%s:%s" % claim, truth="%s:%s" % (tkind, truth_desc)))
        results[mod] = dict(stats=stats, wrong=wrong_ex, other=other_ex)
        print("%-14s files=%3d annotated=%5d checked=%5d correct=%5d cosmetic=%3d wrong=%4d imprecise=%3d unresolv=%3d other=%3d branch(ok/bad)=%d/%d" % (
            mod, stats["files"], stats["lines"], stats["checked"], stats["correct"],
            stats["cosmetic"], stats["wrong"], stats["imprecise"], stats["unresolvable"],
            stats["other"], stats["branch_ok"], stats["branch_bad"]))
    json.dump(results, open(os.path.join(ROOT, "verify", "audit_calls.json"), "w"), indent=1)

if __name__ == "__main__":
    main()
