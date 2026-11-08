#!/usr/bin/env python3
"""Build IPC_MAP.md / PREFS_MAP.md / HOOK_MAP.md from metadata/xref/*.json.

Every row in the proven tables is backed by a call-site record produced by
xref_run.py (capstone linear abstract interpretation): a notification or
preference name is only 'proven' when the argument register at the call
site resolves to a constant string / value. Anything else lands in the
explicit unresolved lists. Nothing is guessed.
"""
import glob
import os
import json
import plistlib
import re
import sys
from collections import defaultdict

# Tree root derived from this file's location:
# <root>/metadata/tools/build_maps.py -> <root>. Portable across checkouts.
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def load_all():
    bins = {}
    for f in sorted(glob.glob(f"{ROOT}/metadata/xref/*.json")):
        d = json.load(open(f))
        d["_funcnames"] = {fn["addr"]: fn["name"] for fn in d["functions"]}
        d["_byfunc"] = defaultdict(list)
        for c in d["calls"]:
            d["_byfunc"][c["func"]].append(c)
        bins[d["binary"]] = d
    return bins


def arg(c, r):
    v = c["args"].get(r)
    if not isinstance(v, dict):
        return None
    if isinstance(v.get("v"), str) and v["v"].startswith("<ordinal"):
        return {"t": "unknown"}
    return v


def name_of(v):
    """Constant-string name from an argument value, else None."""
    if v and v.get("t") in ("cfstr", "cstr"):
        return v["v"]
    return None


def rv(v, d=None):
    """Render an abstract argument value compactly."""
    if not v or v.get("t") in (None, "unknown"):
        return "—"
    t = v["t"]
    if t == "cfstr":
        return f'@"{v["v"]}"'
    if t == "cstr":
        return f'"{v["v"]}"'
    if t == "imm":
        n = v["v"]
        return f"{n} ({n:#x})" if abs(n) > 9 else str(n)
    if t == "addr":
        if v.get("what"):
            return v["what"]
        return f"{v['v']:#x}"
    if t == "class":
        return v["v"]
    if t == "intobj":
        return f"@{v['v']}"
    if t == "doubleobj":
        return f"@{v['v']!r}"
    if t == "sel":
        return f"@selector({v['v']})"
    if t == "importptr":
        s = str(v["v"])
        return "—" if s.startswith("<ordinal") else s
    if t == "callret":
        return f"← {v['v']}"
    if t == "loadfrom":
        return f"*({v['v']:#x})"
    return str(v)


def fn(d, c):
    return c.get("func_name") or d["_funcnames"].get(c["func"], f"sub_{c['func']:x}")


def site(c):
    return f"{c['site']:#x}"


def target_name(d, c):
    """Resolved function name for internal call targets."""
    t = c.get("target")
    if isinstance(t, int):
        return d["_funcnames"].get(t, f"sub_{t:x}")
    return t


# ---------------------------------------------------------------- IPC map
NOTIFY_APIS = {
    "_notify_post", "_notify_register_dispatch", "_notify_register_check",
    "_notify_get_state", "_notify_set_state", "_notify_cancel",
    "_notify_is_valid_token",
}


def build_ipc(bins):
    posts = defaultdict(list)          # name -> [(bin, func, site)]
    reg_dispatch = defaultdict(list)   # name -> [(bin, func, site, handler)]
    reg_check = defaultdict(list)      # name -> [(bin, func, site)]
    set_state = defaultdict(list)      # name -> [(bin, func, site, payload)]
    get_state = defaultdict(list)      # name -> [(bin, func, site)]
    slots = {}                         # (bin, slot) -> (name, kind)
    unresolved = []                    # (bin, api, func, site, why)
    token_unjoined = []                # set/get with unjoinable token

    posts = defaultdict(list)          # name -> [(bin, func, site)]
    reg_dispatch = defaultdict(list)   # name -> [(bin, func, site, handler)]
    reg_check = defaultdict(list)      # name -> [(bin, func, site)]
    set_state = defaultdict(list)      # name -> [(bin, func, site, payload)]
    get_state = defaultdict(list)      # name -> [(bin, func, site)]
    slots = {}                         # (bin, slot) -> (name, kind)
    unresolved = []                    # (bin, api, func, site, why)
    token_unjoined = []                # set/get with unjoinable token
    handler_names = {}                 # (bin, invoke addr) -> name

    # Pass 1: registrations (a set_state may precede its register_check in
    # the same lazy-init function, so slots must be collected first).
    for bname, d in bins.items():
        for c in d["calls"]:
            t = c.get("target")
            if t not in ("_notify_register_dispatch", "_notify_register_check"):
                continue
            nm = name_of(arg(c, "x0"))
            slotv = arg(c, "x1")
            slot = slotv["v"] if slotv and slotv.get("t") == "addr" else None
            if nm:
                if slot is not None:
                    slots[(bname, slot)] = (nm, t)
                if t == "_notify_register_dispatch":
                    blk = arg(c, "x3")
                    handler = "—"
                    if blk and blk.get("t") == "addr":
                        inv = d["blocks"].get(str(blk["v"]))
                        if inv is not None:
                            handler = (f"block @{blk['v']:#x} → invoke "
                                       f"{d['_funcnames'].get(inv, f'sub_{inv:x}')} "
                                       f"@{inv:#x}")
                            handler_names[(bname, inv)] = nm
                        else:
                            handler = f"block @{blk['v']:#x} (invoke unresolved)"
                    reg_dispatch[nm].append((bname, fn(d, c), site(c), handler))
                else:
                    reg_check[nm].append((bname, fn(d, c), site(c)))
            else:
                unresolved.append((bname, t, fn(d, c), site(c),
                                   f"name arg = {rv(arg(c, 'x0'), d)}"))

    # Pass 2: posts and token-based state calls.
    for bname, d in bins.items():
        for c in d["calls"]:
            t = c.get("target")
            if t == "_notify_post":
                nm = name_of(arg(c, "x0"))
                if nm:
                    posts[nm].append((bname, fn(d, c), site(c)))
                else:
                    unresolved.append((bname, t, fn(d, c), site(c),
                                       f"name arg = {rv(arg(c, 'x0'), d)}"))
            elif t in ("_notify_set_state", "_notify_get_state", "_notify_cancel"):
                tok = arg(c, "x0")
                joined = None
                via_handler = False
                if tok and tok.get("t") == "loadfrom":
                    joined = slots.get((bname, tok["v"]))
                if not joined and (bname, c["func"]) in handler_names:
                    # A register_dispatch handler receives its token as the
                    # block argument; a get/set_state on it inside the
                    # handler belongs to that registration.
                    joined = (handler_names[(bname, c["func"])], "handler")
                    via_handler = True
                if joined:
                    nm2 = joined[0]
                    note = " (token = handler block arg)" if via_handler else ""
                    if t == "_notify_set_state":
                        set_state[nm2].append((bname, fn(d, c), site(c),
                                               rv(arg(c, "x1"), d) + note))
                    elif t == "_notify_get_state":
                        get_state[nm2].append((bname, fn(d, c), site(c) + note))
                else:
                    token_unjoined.append((bname, t, fn(d, c), site(c),
                                           f"token arg = {rv(tok, d)}"))
            elif t == "_notify_is_valid_token":
                token_unjoined.append((bname, t, fn(d, c), site(c), "n/a"))

    # CFNotificationCenter (Darwin center) posts / observers
    cf_posts = defaultdict(list)
    cf_obs = defaultdict(list)
    for bname, d in bins.items():
        for c in d["calls"]:
            t = c.get("target")
            if t == "_CFNotificationCenterPostNotification":
                nm = name_of(arg(c, "x1"))
                if nm:
                    cf_posts[nm].append((bname, fn(d, c), site(c),
                                         rv(arg(c, "x4"), d)))
                else:
                    unresolved.append((bname, t, fn(d, c), site(c),
                                       f"name arg = {rv(arg(c, 'x1'), d)}"))
            elif t == "_CFNotificationCenterAddObserver":
                nm = name_of(arg(c, "x3"))
                cb = arg(c, "x2")
                cbname = "—"
                if cb and cb.get("t") == "addr":
                    cbname = d["_funcnames"].get(cb["v"], f"{cb['v']:#x}")
                if nm:
                    cf_obs[nm].append((bname, fn(d, c), site(c), cbname))
                else:
                    unresolved.append((bname, t, fn(d, c), site(c),
                                       f"name arg = {rv(arg(c, 'x3'), d)}"))

    # NSDistributedNotificationCenter via msgsend in functions that
    # reference the class-name string; second tier = same selectors with
    # com.anlai.omnicar/* names in other functions.
    dist_posts = defaultdict(list)
    dist_obs = defaultdict(list)
    dist_posts2 = defaultdict(list)
    dist_obs2 = defaultdict(list)
    for bname, d in bins.items():
        dist_funcs = set()
        for c in d["calls"]:
            for v in c["args"].values():
                if isinstance(v, dict) and v.get("v") == "NSDistributedNotificationCenter":
                    dist_funcs.add(c["func"])
        for c in d["calls"]:
            sel = c.get("sel")
            if sel in ("postNotificationName:object:userInfo:",
                       "postNotificationName:object:"):
                nm = name_of(arg(c, "x2"))
                if not nm:
                    continue
                row = (bname, fn(d, c), site(c), rv(arg(c, "x4"), d))
                (dist_posts if c["func"] in dist_funcs else dist_posts2)[nm].append(row)
            elif sel == "addObserver:selector:name:object:":
                nm = name_of(arg(c, "x4"))
                if not nm:
                    continue
                row = (bname, fn(d, c), site(c), rv(arg(c, "x3"), d))
                (dist_obs if c["func"] in dist_funcs else dist_obs2)[nm].append(row)
            elif sel == "addObserverForName:object:queue:usingBlock:":
                nm = name_of(arg(c, "x2"))
                if not nm:
                    unresolved.append(
                        (bname, sel, fn(d, c), site(c),
                         f"name arg = {rv(arg(c, 'x2'), d)}"))
                    continue
                blk = arg(c, "x5")
                detail = "block handler"
                if blk and blk.get("t") == "addr":
                    inv = d["blocks"].get(str(blk["v"]))
                    if inv is not None:
                        detail = (f"block @{blk['v']:#x} → invoke "
                                  f"{d['_funcnames'].get(inv, f'sub_{inv:x}')} "
                                  f"@{inv:#x}")
                    else:
                        detail = f"block @{blk['v']:#x} (invoke unresolved)"
                row = (bname, fn(d, c), site(c), detail)
                if c["func"] in dist_funcs:
                    dist_obs[nm].append(row)
                elif nm.startswith("com.anlai.") or "omnicar" in nm:
                    dist_obs2[nm].append(row)

    names = sorted(set(posts) | set(reg_dispatch) | set(reg_check) |
                   set(set_state) | set(get_state))
    L = []
    L.append("# IPC_MAP — OmniCar 1.0.3 inter-process communication map\n")
    L.append("Generated by `metadata/tools/build_maps.py` from capstone xref "
             "records (`metadata/xref/*.json`, engine: `metadata/tools/xref_run.py`). "
             "A name is listed as PROVEN only when the argument register at the "
             "actual call site resolves to a constant string. Token-based "
             "state calls (`notify_set_state`/`notify_get_state`) are joined "
             "to a registration through the token slot address: the "
             "`notify_register_*` call in the same binary that writes that "
             "slot. Import names in every binary were validated against "
             "LC_DYSYMTAB indirect symbols (ordinal calibration delta +1, "
             "unanimous on 1,478 checked slots across the 8 binaries).\n")

    L.append("## 1. Darwin notifications (libnotify: notify_post / notify_register_*)\n")
    L.append(f"{len(names)} distinct proven names.\n")
    L.append("| Name | Posted by | Observed (register_dispatch → handler) | Self-check (register_check) | State written (set_state: payload) | State read (get_state) |")
    L.append("|---|---|---|---|---|---|")
    for nm in names:
        def fmt(rows, extra=None):
            out = []
            for r in rows:
                s = f"{r[0]} · {r[1]} @ {r[2]}"
                if extra:
                    s += f" · {extra(r)}"
                out.append(s)
            return "<br>".join(out) if out else "—"
        L.append("| `{}` | {} | {} | {} | {} | {} |".format(
            nm,
            fmt(posts.get(nm, [])),
            fmt(reg_dispatch.get(nm, []), lambda r: r[3]),
            fmt(reg_check.get(nm, [])),
            fmt(set_state.get(nm, []), lambda r: f"payload {r[3]}"),
            fmt(get_state.get(nm, []))))
    L.append("")

    L.append("## 2. CFNotificationCenter — Darwin notify center\n")
    cfnames = sorted(set(cf_posts) | set(cf_obs))
    if cfnames:
        L.append("| Name | Posted by (deliverImmediately arg) | Observed by (callback) |")
        L.append("|---|---|---|")
        for nm in cfnames:
            p = "<br>".join(f"{r[0]} · {r[1]} @ {r[2]} · deliverImmediately={r[3]}"
                            for r in cf_posts.get(nm, [])) or "—"
            o = "<br>".join(f"{r[0]} · {r[1]} @ {r[2]} · cb {r[3]}"
                            for r in cf_obs.get(nm, [])) or "—"
            L.append(f"| `{nm}` | {p} | {o} |")
    else:
        L.append("No CFNotificationCenter post/observer call sites with constant names.")
    L.append("")

    L.append("## 3. NSDistributedNotificationCenter (proven: the posting/observing "
             "function itself references the `NSDistributedNotificationCenter` class string)\n")
    dnames = sorted(set(dist_posts) | set(dist_obs))
    L.append("| Name | Posted by (userInfo arg) | Observed by (selector / block handler) |")
    L.append("|---|---|---|")
    for nm in dnames:
        p = "<br>".join(f"{r[0]} · {r[1]} @ {r[2]} · userInfo={r[3]}"
                        for r in dist_posts.get(nm, [])) or "—"
        o = "<br>".join(f"{r[0]} · {r[1]} @ {r[2]} · {r[3]}"
                        for r in dist_obs.get(nm, [])) or "—"
        L.append(f"| `{nm}` | {p} | {o} |")
    L.append("")
    L.append("### 3b. Same selectors, `com.anlai.omnicar/*` name proven at the call site, "
             "but the center class is not referenced inside the same function "
             "(center obtained elsewhere — distributed vs. local center unproven per site)\n")
    d2 = sorted(set(dist_posts2) | set(dist_obs2))
    if d2:
        L.append("| Name | Posted by | Observed by |")
        L.append("|---|---|---|")
        for nm in d2:
            p = "<br>".join(f"{r[0]} · {r[1]} @ {r[2]}" for r in dist_posts2.get(nm, [])) or "—"
            o = "<br>".join(f"{r[0]} · {r[1]} @ {r[2]}" for r in dist_obs2.get(nm, [])) or "—"
            L.append(f"| `{nm}` | {p} | {o} |")
    else:
        L.append("None.")
    L.append("")

    L.append("## 4. Unresolved notify call sites (name argument is not a constant string)\n")
    if unresolved:
        L.append("| Binary | API | Function | Site | Blocker |")
        L.append("|---|---|---|---|---|")
        for r in sorted(unresolved):
            L.append(f"| {r[0]} | `{r[1]}` | {r[2]} | {r[3]} | {r[4]} |")
    else:
        L.append("None.")
    L.append("")
    L.append("## 5. State/token call sites that could not be joined to a registration\n")
    L.append("These `notify_set_state` / `notify_get_state` / `notify_cancel` "
             "sites carry a token that is not a load from a slot written by a "
             "`notify_register_*` call in the same binary (immediate token, "
             "token passed in from a caller, or tracker lost the value). "
             "They are listed, not guessed.\n")
    if token_unjoined:
        L.append("| Binary | API | Function | Site | Token arg |")
        L.append("|---|---|---|---|---|")
        for r in sorted(token_unjoined):
            L.append(f"| {r[0]} | `{r[1]}` | {r[2]} | {r[3]} | {r[4]} |")
    else:
        L.append("None.")
    L.append("")

    proven = set(names) | set(cfnames) | set(dnames) | set(d2)
    L.append("## 6. UNPROVEN names (string exists in a binary; no call site references it as a notification name)\n")
    pat = re.compile(r"com\.anlai\.omnicar[/:][\w.+/-]*")
    found = defaultdict(set)
    for bname, d in bins.items():
        for v in d["cfstrings"].values():
            for m in pat.findall(v):
                found[m].add(bname)
        try:
            txt = open(f"{ROOT}/metadata/raw/{bname}/strings.txt",
                       errors="replace").read()
        except OSError:
            txt = ""
        for m in pat.findall(txt):
            if len(m) < 120:
                found[m].add(bname)
    unp = sorted(n for n in found if n not in proven)
    if unp:
        L.append("| String | Present in |")
        L.append("|---|---|")
        for nm in unp:
            L.append(f"| `{nm}` | {', '.join(sorted(found[nm]))} |")
    else:
        L.append("None — every `com.anlai.omnicar/*` string is backed by a call site.")
    L.append("")
    L.append("Note: §6 is a string-inventory scan; entries may be log text, "
             "URL routes inside the app label, or names used through APIs "
             "outside this map's scope — presence here means only 'not proven "
             "as a notification name by a notify/CFNotificationCenter/"
             "distributed-center call site'.")
    return "\n".join(L) + "\n", {
        "darwin_names": len(names), "cf_names": len(cfnames),
        "dist_names": len(dnames), "unresolved": len(unresolved),
        "token_unjoined": len(token_unjoined), "unproven": len(unp)}


# ---------------------------------------------------------------- prefs map
PREFS_BUNDLE = (f"{ROOT}/payload/var/jb/Library/PreferenceBundles/"
                "OmniCarPrefs.bundle")


def plist_declared():
    """key -> (plist file, declared default repr) from the Prefs bundle."""
    out = {}
    for pf in sorted(glob.glob(f"{PREFS_BUNDLE}/*.plist")):
        try:
            pl = plistlib.load(open(pf, "rb"))
        except Exception:
            continue
        items = pl.get("items", []) if isinstance(pl, dict) else []
        for it in items:
            if isinstance(it, dict) and isinstance(it.get("key"), str):
                dflt = it.get("default", it.get("defaultValue"))
                out[it["key"]] = (pf.split("/")[-1],
                                  None if dflt is None else repr(dflt))
    return out


def build_prefs(bins):
    declared = plist_declared()
    readers = defaultdict(lambda: defaultdict(set))   # key -> bin -> funcs
    writers = defaultdict(lambda: defaultdict(set))
    defaults = defaultdict(set)                       # key -> rendered defaults
    domains = defaultdict(set)                        # key -> domains
    syncs = defaultdict(set)                          # bin -> funcs calling AppSynchronize
    unresolved = []

    for bname, d in bins.items():
        for c in d["calls"]:
            tname = target_name(d, c) if c["kind"] == "internal" else c.get("target")
            t = c.get("target")
            if tname == "_OMCPref" or t == "_OMCPref":
                key = name_of(arg(c, "x0"))
                if key:
                    readers[key][bname].add(fn(d, c))
                    defaults[key].add(rv(arg(c, "x1"), d))
                    domains[key].add("com.anlai.omnicar")
                else:
                    unresolved.append((bname, "OMCPref", fn(d, c), site(c),
                                       f"key arg = {rv(arg(c, 'x0'), d)}"))
            elif t == "_CFPreferencesCopyAppValue":
                if fn(d, c) == "_OMCPref":
                    continue  # OMCPref's own body: key is its parameter
                key, dom = name_of(arg(c, "x0")), name_of(arg(c, "x1"))
                if key:
                    readers[key][bname].add(fn(d, c))
                    if dom:
                        domains[key].add(dom)
                else:
                    unresolved.append((bname, t, fn(d, c), site(c),
                                       f"key arg = {rv(arg(c, 'x0'), d)}"))
            elif t == "_CFPreferencesSetAppValue":
                key, dom = name_of(arg(c, "x0")), name_of(arg(c, "x2"))
                if key:
                    val = arg(c, "x1")
                    tag = " (removal: value NULL)" if (
                        val and val.get("t") == "imm" and val.get("v") == 0) else ""
                    writers[key][bname].add(fn(d, c) + tag)
                    if dom:
                        domains[key].add(dom)
                else:
                    unresolved.append((bname, t, fn(d, c), site(c),
                                       f"key arg = {rv(arg(c, 'x0'), d)}"))
            elif t in ("_CFPreferencesCopyMultiple", "_CFPreferencesSetMultiple"):
                unresolved.append((bname, t, fn(d, c), site(c),
                                   "bulk API — key set is an array argument, "
                                   "not expanded by this pass"))
            elif t == "_CFPreferencesAppSynchronize":
                syncs[bname].add(fn(d, c))

    keys = sorted(set(readers) | set(writers) | set(declared))
    L = []
    L.append("# PREFS_MAP — OmniCar 1.0.3 preference key map\n")
    L.append("Generated by `metadata/tools/build_maps.py` from capstone xref "
             "records (`metadata/xref/*.json`).\n")
    L.append("How reads work (proven from OmniCarCore disassembly, "
             "`_OMCPref` @ 0x6534, identical shared-core copy in every "
             "dylib): `id OMCPref(NSString *key, id defaultValue)` = "
             "`CFPreferencesCopyAppValue(key, @\"com.anlai.omnicar\") ?: "
             "defaultValue`. So every `_OMCPref` call site below is a proven "
             "read of its key argument in domain `com.anlai.omnicar`, and "
             "the call's second argument is the code-supplied default. "
             "Direct `CFPreferencesCopyAppValue` / `CFPreferencesSetAppValue` "
             "call sites are listed with their literal domain argument "
             "(always `com.anlai.omnicar` where resolvable). Writes with "
             "value NULL delete the key and are marked *(removal)*.\n")
    L.append(f"{len(keys)} distinct keys ({len(declared)} plist-declared, "
             f"{len([k for k in keys if k not in declared])} code-only).\n")
    L.append("| Key | In plist? (file · declared default) | Read by | Written by | Code defaults (OMCPref arg 2) |")
    L.append("|---|---|---|---|---|")
    for k in keys:
        pl = "—"
        if k in declared:
            f_, dv = declared[k]
            pl = f"yes · {f_}" + (f" · default {dv}" if dv is not None else " · no default")
        rd = "<br>".join(f"{b}: {', '.join(sorted(fs))}"
                         for b, fs in sorted(readers.get(k, {}).items())) or "—"
        wr = "<br>".join(f"{b}: {', '.join(sorted(fs))}"
                         for b, fs in sorted(writers.get(k, {}).items())) or "—"
        df = "<br>".join(sorted(defaults.get(k, set()))) or "—"
        L.append(f"| `{k}` | {pl} | {rd} | {wr} | {df} |")
    L.append("")
    L.append("## CFPreferencesAppSynchronize call sites (flush points)\n")
    L.append("| Binary | Functions calling AppSynchronize |")
    L.append("|---|---|")
    for b in sorted(syncs):
        L.append(f"| {b} | {', '.join(sorted(syncs[b]))} |")
    L.append("")
    L.append("## Unresolved preference call sites (dynamic key or bulk API)\n")
    if unresolved:
        L.append("| Binary | API | Function | Site | Blocker |")
        L.append("|---|---|---|---|---|")
        for r in sorted(unresolved):
            L.append(f"| {r[0]} | `{r[1]}` | {r[2]} | {r[3]} | {r[4]} |")
    else:
        L.append("None.")
    L.append("")
    only_plist = [k for k in declared if k not in readers and k not in writers]
    L.append("## Reconciliation notes\n")
    L.append(f"- Plist-declared keys with no constant-key code call site: "
             f"{', '.join(f'`{k}`' for k in only_plist) if only_plist else 'none'}. "
             "The one pref-reading helper whose key is computed rather than "
             "constant is `_OMCFeatureEnabled` (one unresolved site per "
             "dylib, see the unresolved list); feature `…Enabled` keys are "
             "the plausible reads through it — that attribution is an "
             "inference from the helper's name/role, not a proven row.")
    wo = [k for k in writers if k not in readers]
    L.append(f"- Keys written but never read at a proven site: "
             f"{', '.join(f'`{k}`' for k in wo) if wo else 'none'}.")
    ro = [k for k in readers if k not in writers and k not in declared]
    L.append(f"- Code-only keys read but never written at a proven site "
             f"(external writer — e.g. edited plist or another process): "
             f"{', '.join(f'`{k}`' for k in ro) if ro else 'none'}.")
    doms = set()
    for v in domains.values():
        doms |= v
    L.append(f"- Domains seen at proven call sites: "
             f"{', '.join(f'`{x}`' for x in sorted(doms))}.")
    L.append("- The Prefs bundle UI writes through PreferenceLoader "
             "(PSSpecifiers in the plists write the same domain directly); "
             "those writes are declared by the plist rows above, not by "
             "call sites in the Prefs executable.")
    return "\n".join(L) + "\n", {
        "keys": len(keys), "declared": len(declared),
        "unresolved": len(unresolved)}


# ---------------------------------------------------------------- hook map
def _preceding(d, c, targets, want_args=("x0", "x1")):
    """Nearest earlier call in the same function to one of `targets`."""
    best = None
    for o in d["_byfunc"].get(c["func"], []):
        if o["site"] < c["site"] and o.get("target") in targets:
            if best is None or o["site"] > best["site"]:
                best = o
    return best


def _func_name_at(d, v):
    if v and v.get("t") == "addr":
        return (d["_funcnames"].get(v["v"], f"sub_{v['v']:x}"),
                f"{v['v']:#x}")
    return None


def _car_class(d, c):
    """Resolve an OMCCarClass("Name") call preceding the hook site."""
    prev = _preceding(d, c, {"_OMCCarClass"})
    if prev:
        s = name_of(arg(prev, "x0"))
        if s:
            return s
    return None


def build_hooks(bins):
    msg_rows = []
    fun_rows = []
    unresolved = []
    counts = defaultdict(lambda: [0, 0])

    for bname, d in bins.items():
        for c in d["calls"]:
            t = c.get("target")
            if t == "_MSHookMessageEx":
                counts[bname][0] += 1
                cls_v, sel_v = arg(c, "x0"), arg(c, "x1")
                cls = None
                if cls_v:
                    if cls_v.get("t") == "class":
                        cls = cls_v["v"]
                    elif cls_v.get("t") == "callret" and cls_v.get("v") == "_object_getClass":
                        prev = _preceding(d, c, {"_object_getClass"})
                        inner_v = arg(prev, "x0") if prev else None
                        if inner_v and inner_v.get("t") == "callret" and inner_v.get("v") == "_OMCCarClass":
                            s = _car_class(d, c)
                            inner = (f'{s} (via OMCCarClass("{s}"))' if s
                                     else "OMCCarClass() result")
                        elif inner_v and inner_v.get("t") == "callret":
                            inner = f"{inner_v['v']}() result"
                        else:
                            inner = rv(inner_v, d)
                        cls = f"metaclass of ({inner})"
                    elif cls_v.get("t") == "callret" and cls_v.get("v") == "_OMCCarClass":
                        s = _car_class(d, c)
                        cls = (f'{s} (via OMCCarClass("{s}"))' if s
                               else "OMCCarClass() result")
                    elif cls_v.get("t") == "callret":
                        cls = f"{cls_v['v']}() result"
                    elif cls_v.get("t") in ("addr", "loadfrom"):
                        cls = rv(cls_v, d)
                sel = sel_v["v"] if sel_v and sel_v.get("t") == "sel" else None
                rep = _func_name_at(d, arg(c, "x2"))
                if cls and sel and rep:
                    msg_rows.append((bname, fn(d, c), site(c), cls, sel,
                                     f"{rep[0]} @ {rep[1]}",
                                     rv(arg(c, "x3"), d)))
                else:
                    unresolved.append((bname, t, fn(d, c), site(c),
                                       f"class={rv(cls_v, d)} sel={rv(sel_v, d)} "
                                       f"repl={rv(arg(c, 'x2'), d)}"))
            elif t == "_MSHookFunction":
                counts[bname][1] += 1
                tgt_v = arg(c, "x0")
                tgt = None
                if tgt_v:
                    if tgt_v.get("t") == "importptr":
                        tgt = tgt_v["v"]
                    elif tgt_v.get("t") == "addr":
                        fa = _func_name_at(d, tgt_v)
                        tgt = f"{fa[0]} @ {fa[1]}" if fa else rv(tgt_v, d)
                    elif tgt_v.get("t") == "callret" and tgt_v.get("v") in ("_dlsym", "_MSFindSymbol"):
                        prev = _preceding(d, c, {"_dlsym", "_MSFindSymbol"})
                        sym = name_of(arg(prev, "x1")) if prev else None
                        img = rv(arg(prev, "x0"), d) if prev else "—"
                        tgt = (f"{tgt_v['v']}({img}, \"{sym}\")"
                               if sym else f"{tgt_v['v']}() result")
                    elif tgt_v.get("t") == "callret":
                        tgt = f"{tgt_v['v']}() result"
                rep = _func_name_at(d, arg(c, "x1"))
                if tgt and rep:
                    fun_rows.append((bname, fn(d, c), site(c), tgt,
                                     f"{rep[0]} @ {rep[1]}",
                                     rv(arg(c, "x2"), d)))
                else:
                    unresolved.append((bname, t, fn(d, c), site(c),
                                       f"target={rv(tgt_v, d)} "
                                       f"repl={rv(arg(c, 'x1'), d)}"))
    L = []
    L.append("# HOOK_MAP — OmniCar 1.0.3 substrate hook installation map\n")
    L.append("Generated by `metadata/tools/build_maps.py` from capstone xref "
             "records (`metadata/xref/*.json`). Each row is one "
             "`MSHookMessageEx` / `MSHookFunction` call site whose target "
             "arguments resolve from the selref/classref/dataflow at that "
             "site. Sites that do not fully resolve are in the unresolved "
             "list at the end — never guessed.\n")
    tot = {b: tuple(v) for b, v in counts.items()}
    L.append("Call-site counts (resolved + unresolved): " +
             ", ".join(f"{b}: MSHookMessageEx ×{v[0]}, MSHookFunction ×{v[1]}"
                       for b, v in sorted(tot.items()) if v != (0, 0)) + ".\n")
    L.append("## MSHookMessageEx\n")
    L.append("| Binary | Installed from (function @ site) | Class | Selector | Replacement IMP | Orig-IMP storage |")
    L.append("|---|---|---|---|---|---|")
    for r in sorted(msg_rows):
        L.append(f"| {r[0]} | {r[1]} @ {r[2]} | {r[3]} | `{r[4]}` | {r[5]} | {r[6]} |")
    L.append("")
    L.append("## MSHookFunction\n")
    if fun_rows:
        L.append("| Binary | Installed from (function @ site) | Target function | Replacement | Orig-ptr storage |")
        L.append("|---|---|---|---|---|")
        for r in sorted(fun_rows):
            L.append(f"| {r[0]} | {r[1]} @ {r[2]} | {r[3]} | {r[4]} | {r[5]} |")
    else:
        L.append("No fully-resolved MSHookFunction sites.")
    L.append("")
    L.append("## Unresolved hook call sites\n")
    if unresolved:
        L.append("| Binary | API | Function | Site | Blocker |")
        L.append("|---|---|---|---|---|")
        for r in sorted(unresolved):
            L.append(f"| {r[0]} | `{r[1]}` | {r[2]} | {r[3]} | {r[4]} |")
    else:
        L.append("None.")
    L.append("")
    L.append("Notes: 'metaclass of (X)' = the class argument is the result "
             "of `object_getClass(X)` at the nearest preceding call in the "
             "same installer function, i.e. a class-method hook. "
             "`OMCCarClass()` is the shared-core helper that resolves the "
             "current CarPlay-related class at runtime; hooks through it "
             "target class methods/instance methods of that runtime class.")
    return "\n".join(L) + "\n", {
        "msg_rows": len(msg_rows), "fun_rows": len(fun_rows),
        "unresolved": len(unresolved)}


def main():
    bins = load_all()
    for builder, outname in ((build_ipc, "IPC_MAP.md"),
                             (build_prefs, "PREFS_MAP.md"),
                             (build_hooks, "HOOK_MAP.md")):
        text, stats = builder(bins)
        path = f"{ROOT}/metadata/{outname}"
        with open(path, "w") as f:
            f.write(text)
        print(outname, stats)


if __name__ == "__main__":
    main()
