#!/usr/bin/env python3
"""gen_headers.py - emit .h skeletons from disasm/classes.json into
src/Prefs/OMCPrefs/generated/ for manual consolidation."""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
CLS = json.loads((HERE.parent / "disasm" / "classes.json").read_text())
OUT = HERE.parent / "OMCPrefs" / "generated"
OUT.mkdir(parents=True, exist_ok=True)

OBJC_TYPE = {
    "@": "id", "#": "Class", ":": "SEL", "B": "BOOL", "c": "char", "i": "int",
    "s": "short", "l": "long", "q": "long long", "C": "unsigned char",
    "I": "unsigned int", "S": "unsigned short", "L": "unsigned long",
    "Q": "unsigned long long", "f": "float", "d": "double", "v": "void",
    "*": "char *", "^v": "void *",
}


def decode_type(enc, i=0):
    """very small ObjC type-encoding decoder for signatures"""
    if i >= len(enc):
        return "id", i
    c = enc[i]
    if c == "@":
        if i + 1 < len(enc) and enc[i + 1] == '"':
            j = enc.index('"', i + 2)
            return enc[i + 2:j] + " *", j + 1
        return "id", i + 1
    if c == "{":
        depth = 0
        j = i
        while j < len(enc):
            if enc[j] == "{":
                depth += 1
            elif enc[j] == "}":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        name = enc[i + 1:j].split("=")[0]
        return name, j + 1
    if c == "[":
        j = enc.index("]", i)
        return "/* array */ void *", j + 1
    if c == "^":
        _, j = decode_type(enc, i + 1)
        return "void *", j
    if c in OBJC_TYPE:
        return OBJC_TYPE[c], i + 1
    return "id", i + 1


def method_sig(m):
    types = m.get("type", "")
    sel = m["name"]
    parts = sel.split(":")
    if not types:
        return f"- (void){sel};"
    # parse return + arg types
    toks = []
    i = 0
    while i < len(types):
        t, i = decode_type(types, i)
        # skip offset digits
        while i < len(types) and types[i].isdigit():
            i += 1
        toks.append(t)
    ret = toks[0] if toks else "void"
    args = toks[3:] if len(toks) > 3 else []
    if not sel.endswith(":"):
        return f"- ({ret}){sel};"
    out = []
    for idx, p in enumerate(parts):
        if p == "":
            continue
        at = args[idx] if idx < len(args) else "id"
        out.append(f"{p}:({at})arg{idx}")
    return f"- ({ret})" + " ".join(out) + ";"


for name, info in sorted(CLS.items()):
    lines = [f"// {name}.h — reconstructed interface (evidence: metadata objc dump)",
             "#import <UIKit/UIKit.h>", "#import <Preferences/PSListController.h>",
             "#import <Preferences/PSSpecifier.h>", "#import <Preferences/PSTableCell.h>",
             ""]
    sup = info.get("superclass") or "NSObject"
    prot = info.get("protocols") or []
    decl = f"@interface {name} : {sup}"
    if prot:
        decl += " <" + ", ".join(prot) + ">"
    lines.append(decl)
    ivars = info.get("ivars") or []
    if ivars:
        lines.append("{")
        for iv in ivars:
            lines.append(f"    {iv.get('type','id')} {iv['name']};  // offset {iv.get('offset')}")
        lines.append("}")
    for p in info.get("properties") or []:
        attrs = p.get("attributes", "")
        lines.append(f"@property ({attrs}) {p.get('type','id')} {p['name']};")
    for m in info.get("class_methods") or []:
        lines.append("+ " + method_sig(m)[2:])
    for m in info.get("methods") or []:
        lines.append(method_sig(m))
    lines.append("@end")
    (OUT / f"{name}.h").write_text("\n".join(lines) + "\n")
print("wrote", len(CLS), "headers")
