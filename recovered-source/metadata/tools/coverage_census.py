#!/usr/bin/env python3
"""Coverage census: automated function->source accounting for the OmniCar 1.0.3
reconstruction (wave 3). Builds the universe of functions from the wave-1
metadata, scans the reconstructed sources for claims, and emits:

  metadata/FUNCTION_SOURCE_MAP.tsv   one row per universe function
  metadata/COVERAGE_GAPS.md          per-binary counts, unclaimed + multiple lists

Universe (arm64 slice only; sources annotate arm64 offsets):
  * ObjC methods: metadata/raw/<Binary>/objc.json, slices[cpu=arm64].objc.classes[]
    -> (class, '-', selector) from .methods, (class, '+', selector) from
    .class_methods. Protocols and categories contribute nothing (0 categories
    exist in all 8 binaries; protocol method lists are not implementations).
  * C functions: metadata/xref/<Binary>.json .functions[] entries whose name
    does NOT parse as "Class -[sel]" / "Class +[sel]" (those parse back to
    exactly the objc method set in every binary). Name is either a symbol
    ("_OMCPref") or "sub_<hex offset>". Addresses are normalised by
    subtracting 0x100000000 for the OmniCar app (MH_EXECUTE base), 0 elsewhere.

Claim rules (a claim binds a universe item to a source file). Only .m/.h/.c/.mm
files under src/ are scanned; disasm/, tools/, generated/ folders and
*.md/*.txt are excluded (generated/ holds machine-generated skeleton headers,
not reconstruction source).
  * Folder->binary attribution by top-level folder under src/:
      App->OmniCar, AppBridgeA/AppBridgeB->OmniCarAppBridge,
      CarProbe->OmniCarCarProbe, Prefs->OmniCarPrefs,
      SpeedBubble->OmniCarSpeedBubble,
      SplitScreenA/SplitScreenB/SplitScreenC->OmniCarSplitScreen,
      StartupScreen->OmniCarStartupScreen,
      OMCCommon->shared unit: symbol claims apply to EVERY binary whose xref
      contains that symbol; address claims apply per binary by address.
  * Method DEF claim: a method definition (signature terminated by '{')
    inside an @implementation block for that class (category ignored).
  * Method PROP claim: an @property declaration inside an @interface block
    for that class claims the getter selector (property name or getter=
    attribute) and, unless readonly, the setter (set<Name>: or setter=
    attribute). Covers accessor-only classes reconstructed as properties.
  * Method DECL claim: a method declaration (signature terminated by ';')
    inside an @interface block. If a method has only DECL claims its status
    is DECL_ONLY, not CLAIMED.
  * C symbol claim: a definition of the bare symbol name (leading '_'
    stripped) -- a `NAME(...)` occurrence in a .m/.c file whose closing
    paren is followed by '{', or a prototype in a .h file -- or an explicit
    annotation `NAME @ 0xADDR` in any scanned file whose address holds that
    symbol (or a sub_ entry) in the attributed binary.
  * C address claims, any of:
      - a `sub_<hex>` token or an `@0x<hex>` / `@ 0x<hex>` token anywhere in
        a file attributed to that binary (block-invoke functions are
        sub_<hex> entries; a mention in the file hosting the parent function
        is their legitimate claim, per project convention);
      - a bare `0x<hex>` token inside a comment (the `// 0x42ac` annotation
        style), or an address range `0x<lo>-0x<hi>` on a definition line or
        within the 3 lines above a definition, which claims every universe
        function start inside the range.
    Address claims only register when the address is a universe C-function
    start of the attributed binary, so data addresses/constants in comments
    cannot create false claims. Address claims from the shared unit
    (src/OMCCommon/) bind only OmniCarCore — the unit's annotated offsets
    are Core's; its cross-binary claims are the symbol claims.
  * A claim is stub-flagged if the claimed definition's own body span (or,
    for token claims, the token's line) contains 'STUB-UNRECOVERED'.

Statuses: CLAIMED (one claiming module, at most one definition),
CLAIMED_MULTIPLE (duplicate definitions in >1 file, or claims spanning >1
module folder — a header @property plus the .m definition in the SAME module
is one claim, not a multiple), EXPECTED_MULTIPLE (the OMCCommon pattern:
claimed by the shared unit src/OMCCommon/ plus exactly one module copy),
CLAIMED_STUB (single claim, stub-flagged), DECL_ONLY, UNCLAIMED.

Reproduce:  python3 metadata/tools/coverage_census.py
"""
import json, os, re, glob
from collections import defaultdict, Counter

ROOT = os.path.expanduser('~/workspace/omnicar-re')
META = os.path.join(ROOT, 'metadata')
SRC = os.path.join(ROOT, 'src')

BINARIES = ['OmniCar', 'OmniCarCore', 'OmniCarAppBridge', 'OmniCarCarProbe',
            'OmniCarSpeedBubble', 'OmniCarSplitScreen', 'OmniCarStartupScreen',
            'OmniCarPrefs']
FOLDER2BIN = {
    'App': 'OmniCar', 'AppBridgeA': 'OmniCarAppBridge',
    'AppBridgeB': 'OmniCarAppBridge', 'CarProbe': 'OmniCarCarProbe',
    'Prefs': 'OmniCarPrefs', 'SpeedBubble': 'OmniCarSpeedBubble',
    'SplitScreenA': 'OmniCarSplitScreen', 'SplitScreenB': 'OmniCarSplitScreen',
    'SplitScreenC': 'OmniCarSplitScreen', 'StartupScreen': 'OmniCarStartupScreen',
}
SHARED_FOLDER = 'OMCCommon'
BASE = {'OmniCar': 0x100000000}
STUB = 'STUB-UNRECOVERED'

# ---------------------------------------------------------------- universe
def build_universe():
    uni = {}
    for b in BINARIES:
        oj = json.load(open(os.path.join(META, 'raw', b, 'objc.json')))
        sl = [s for s in oj['slices'] if s['cpu'] == 'arm64'][0]
        methods = {}
        for c in sl['objc']['classes']:
            for m in (c.get('methods') or []):
                methods[(c['name'], '-', m['name'])] = m['imp']
            for m in (c.get('class_methods') or []):
                methods[(c['name'], '+', m['name'])] = m['imp']
        xr = json.load(open(os.path.join(META, 'xref', b + '.json')))
        base = BASE.get(b, 0)
        cfuncs = {}
        for f in xr['functions']:
            if re.match(r'.+? [-+]\[.*\]$', f['name']):
                continue
            cfuncs[f['addr'] - base] = f['name']
        uni[b] = {'methods': methods, 'cfuncs': cfuncs}
    return uni

# ---------------------------------------------------------------- scanning
def strip_comments(text):
    """Remove // and /* */ comments, preserving strings/chars and newlines
    (line numbers stay aligned with the original)."""
    out, i, n = [], 0, len(text)
    state = None
    while i < n:
        ch = text[i]
        nxt = text[i + 1] if i + 1 < n else ''
        if state is None:
            if ch == '/' and nxt == '/':
                state = 'line'; out.append(' '); i += 2; continue
            if ch == '/' and nxt == '*':
                state = 'block'; out.append(' '); i += 2; continue
            if ch == '"':
                state = 'str'
            elif ch == "'":
                state = 'chr'
            out.append(ch); i += 1; continue
        if state == 'line':
            if ch == '\n':
                state = None; out.append(ch)
            i += 1; continue
        if state == 'block':
            if ch == '*' and nxt == '/':
                state = None; out.append(' '); i += 2; continue
            out.append('\n' if ch == '\n' else ' ')
            i += 1; continue
        out.append(ch)
        if ch == '\\' and i + 1 < n:
            out.append(text[i + 1]); i += 2; continue
        if (state == 'str' and ch == '"') or (state == 'chr' and ch == "'"):
            state = None
        i += 1
    return ''.join(out)

def parse_selector(sig):
    sig = sig.strip().lstrip('+-').strip()
    m = re.match(r'\([^)]*\)\s*', sig)
    if m:
        sig = sig[m.end():]
    parts = re.findall(r'([A-Za-z_][A-Za-z0-9_]*)\s*:', sig)
    if parts:
        return ''.join(p + ':' for p in parts)
    m = re.search(r'([A-Za-z_][A-Za-z0-9_]*)', sig)
    return m.group(1) if m else None

def scan_file(path):
    raw = open(path, encoding='utf-8', errors='replace').read()
    clean = strip_comments(raw)
    raw_lines = raw.split('\n')
    res = {'defs': {}, 'decls': set(), 'props': set(), 'cdefs': {},
           'cprotos': set(),
           'addr_claims': {}, 'ranges': [], 'annot_sym': set()}
    is_header = path.endswith('.h')

    def line_of(pos):
        return clean.count('\n', 0, pos)

    def span_stub_lines(start_line, brace_pos):
        """Line span of the body starting at brace_pos (in clean text)."""
        depth = 0
        j = brace_pos
        while j < len(clean):
            c = clean[j]
            if c == '{':
                depth += 1
            elif c == '}':
                depth -= 1
                if depth == 0:
                    break
            j += 1
        end_line = line_of(j)
        seg = '\n'.join(raw_lines[start_line:end_line + 1])
        return STUB in seg, end_line

    def bind_bare_hex(def_line, stub_flag):
        """Bare 0x<hex> tokens / ranges on the def line or up to 3 lines
        above it (annotation comments) become address claims."""
        lo = max(0, def_line - 3)
        seg_lines = raw_lines[lo:def_line + 1]
        seg_stub = stub_flag or any(STUB in l for l in seg_lines)
        for l in seg_lines:
            for m in re.finditer(r'0x([0-9a-fA-F]+)\s*-\s*0x([0-9a-fA-F]+)', l):
                res['ranges'].append((int(m.group(1), 16),
                                      int(m.group(2), 16), seg_stub))
            for m in re.finditer(r'\b0x([0-9a-fA-F]{3,6})\b', l):
                a = int(m.group(1), 16)
                res['addr_claims'][a] = res['addr_claims'].get(a, False) or seg_stub

    def scan_sigs(blk, blk_off, cls, want):
        for m in re.finditer(r'(?m)^\s*([-+])\s*\(', blk):
            j = m.end(); depth = 1; end = None
            while j < len(blk):
                c = blk[j]
                if c == '(':
                    depth += 1
                elif c == ')':
                    depth -= 1
                elif depth == 0 and c in '{;':
                    end = (j, c); break
                j += 1
            if not end:
                continue
            sel = parse_selector(blk[m.start():end[0]])
            if not sel:
                continue
            if want == 'def' and end[1] == '{':
                abspos = blk_off + m.start()
                dline = line_of(abspos)
                stub, _ = span_stub_lines(dline, blk_off + end[0])
                key = (cls, m.group(1), sel)
                res['defs'][key] = res['defs'].get(key, False) or stub
                bind_bare_hex(dline, stub)
            elif want == 'decl' and end[1] == ';':
                res['decls'].add((cls, m.group(1), sel))

    for m in re.finditer(r'@implementation\s+([A-Za-z_][A-Za-z0-9_]*)'
                         r'(?:\s*\([^)]*\))?', clean):
        end = clean.find('@end', m.end())
        if end == -1:
            end = len(clean)
        scan_sigs(clean[m.end():end], m.end(), m.group(1), 'def')
    for m in re.finditer(r'@interface\s+([A-Za-z_][A-Za-z0-9_]*)'
                         r'(?:\s*:\s*[A-Za-z_][A-Za-z0-9_]*)?'
                         r'(?:\s*\([^)]*\))?', clean):
        cls = m.group(1)
        end = clean.find('@end', m.end())
        if end == -1:
            end = len(clean)
        blk = clean[m.end():end]
        scan_sigs(blk, m.end(), cls, 'decl')
        for pm in re.finditer(r'@property\s*(?:\(([^)]*)\))?\s*([^;]+);', blk):
            attrs = pm.group(1) or ''
            decl = pm.group(2).strip()
            nm = re.search(r'([A-Za-z_][A-Za-z0-9_]*)\s*$',
                           decl.replace('*', ' '))
            if not nm:
                continue
            name = nm.group(1)
            gm = re.search(r'getter\s*=\s*([A-Za-z_][A-Za-z0-9_:]*)', attrs)
            res['props'].add((cls, '-', gm.group(1) if gm else name))
            if 'readonly' not in attrs:
                sm = re.search(r'setter\s*=\s*([A-Za-z_][A-Za-z0-9_:]*)', attrs)
                setter = sm.group(1) if sm else \
                    'set' + name[0].upper() + name[1:] + ':'
                res['props'].add((cls, '-', setter))

    # C named-function definitions / header prototypes
    for m in re.finditer(r'\b([A-Za-z_][A-Za-z0-9_]*)\s*\(', clean):
        name = m.group(1)
        if name in ('if', 'for', 'while', 'switch', 'sizeof', 'return'):
            continue
        j = m.end(); depth = 1
        while j < len(clean) and depth:
            if clean[j] == '(':
                depth += 1
            elif clean[j] == ')':
                depth -= 1
            j += 1
        k = j
        while k < len(clean) and clean[k] in ' \t\r\n':
            k += 1
        if k < len(clean) and clean[k] == '{':
            dline = line_of(m.start())
            stub, _ = span_stub_lines(dline, k)
            res['cdefs'][name] = res['cdefs'].get(name, False) or stub
            bind_bare_hex(dline, stub)
        elif is_header and k < len(clean) and clean[k] == ';':
            # header prototype: a declaration claim (strength 1), tracked
            # separately from definitions
            res['cprotos'].add(name)

    # token claims from raw text, line-accurate stub flags
    for ln, l in enumerate(raw_lines):
        lstub = STUB in l
        for m in re.finditer(r'\bsub_([0-9a-fA-F]+)\b', l):
            a = int(m.group(1), 16)
            res['addr_claims'][a] = res['addr_claims'].get(a, False) or lstub
        for m in re.finditer(r'@\s*0x([0-9a-fA-F]+)\b', l):
            a = int(m.group(1), 16)
            res['addr_claims'][a] = res['addr_claims'].get(a, False) or lstub
        for m in re.finditer(r'(_?[A-Za-z_][A-Za-z0-9_]*)\s*@\s*0x([0-9a-fA-F]+)', l):
            res['annot_sym'].add((m.group(1), int(m.group(2), 16)))
        # bare hex tokens inside comments (// line comments, trailing
        # comments, and /* */ / * continuation lines): the
        # "// 0x42d0 — fallback ..." annotation style
        ci = l.find('//')
        stripped = l.lstrip()
        in_comment = ci != -1 or stripped.startswith('*') or \
            stripped.startswith('/*')
        if in_comment:
            seg = l[ci:] if ci != -1 else l
            for m in re.finditer(r'\b0x([0-9a-fA-F]{3,6})\b', seg):
                a = int(m.group(1), 16)
                res['addr_claims'][a] = \
                    res['addr_claims'].get(a, False) or lstub
    return res

# ---------------------------------------------------------------- main
def main():
    uni = build_universe()
    sym2bin = defaultdict(set)
    for b in BINARIES:
        for addr, name in uni[b]['cfuncs'].items():
            if name.startswith('_'):
                sym2bin[name[1:]].add(b)

    files = []
    for path in sorted(glob.glob(os.path.join(SRC, '**', '*.*'), recursive=True)):
        rel = os.path.relpath(path, SRC)
        parts = rel.split(os.sep)
        if any(p in ('disasm', 'tools', 'generated') for p in parts):
            continue
        if os.path.splitext(path)[1] not in ('.m', '.h', '.c', '.mm'):
            continue
        files.append((rel, parts[0], path))

    scans = {rel: (folder, scan_file(path)) for rel, folder, path in files}

    # claims[(bin, kind, key)] -> {file: [stub, strength]}
    # strength: 2 = definition (method def / C def), 1 = property or
    # address/annotation claim.
    claims = defaultdict(dict)
    decl_claims = defaultdict(set)    # (bin, 'method', key) -> {file}

    def add(binary, kind, key, rel, stub, strength):
        cur = claims[(binary, kind, key)]
        old = cur.get(rel)
        if old is None:
            cur[rel] = [stub, strength]
        else:
            old[0] = old[0] or stub
            old[1] = max(old[1], strength)

    for rel, (folder, sc) in scans.items():
        shared = (folder == SHARED_FOLDER)
        targets = BINARIES if shared else [FOLDER2BIN[folder]]
        for key, stub in sc['defs'].items():
            for b in targets:
                if key in uni[b]['methods']:
                    add(b, 'method', key, rel, stub, 2)
        for key in sc['props']:
            for b in targets:
                if key in uni[b]['methods']:
                    add(b, 'method', key, rel, False, 1)
        for key in sc['decls']:
            for b in targets:
                if key in uni[b]['methods']:
                    decl_claims[(b, 'method', key)].add(rel)
        for name, stub in sc['cdefs'].items():
            if shared:
                for b in sym2bin.get(name, ()):
                    add(b, 'cfunc', ('sym', name), rel, stub, 2)
            else:
                for b in targets:
                    if name in {n[1:] for n in uni[b]['cfuncs'].values()
                                if n.startswith('_')}:
                        add(b, 'cfunc', ('sym', name), rel, stub, 2)
        for name in sc['cprotos']:
            if shared:
                for b in sym2bin.get(name, ()):
                    add(b, 'cfunc', ('sym', name), rel, False, 1)
            else:
                for b in targets:
                    if name in {n[1:] for n in uni[b]['cfuncs'].values()
                                if n.startswith('_')}:
                        add(b, 'cfunc', ('sym', name), rel, False, 1)
        # Address claims from the shared unit bind only OmniCarCore: the
        # unit's annotated offsets are Core's (its symbol claims, above,
        # are the cross-binary ones).
        addr_targets = ['OmniCarCore'] if shared else targets
        for b in addr_targets:
            cfuncs = uni[b]['cfuncs']
            for addr, stub in sc['addr_claims'].items():
                if addr in cfuncs:
                    add(b, 'cfunc', ('addr', addr), rel, stub, 1)
            for lo, hi, stub in sc['ranges']:
                for addr in cfuncs:
                    if lo <= addr <= hi:
                        add(b, 'cfunc', ('addr', addr), rel, stub, 1)
            for (nm, addr) in sc['annot_sym']:
                if addr in cfuncs:
                    bare = nm[1:] if nm.startswith('_') else nm
                    truth = cfuncs[addr]
                    if truth == nm or truth == '_' + bare or \
                            truth.startswith('sub_'):
                        add(b, 'cfunc', ('addr', addr), rel, False, 1)

    def status_of(got, is_cfunc, shared_sym=False):
        """got: {file: [stub, strength]} -> (status, files)"""
        files_ = sorted(got)
        if not files_:
            return 'UNCLAIMED', files_
        stub = any(v[0] for v in got.values())
        modules = {f.split(os.sep)[0] for f in files_}
        ndefs = sum(1 for v in got.values() if v[1] == 2)
        if is_cfunc and shared_sym and len(modules) == 2:
            return 'EXPECTED_MULTIPLE', files_
        if ndefs >= 2 or len(modules) >= 2:
            return 'CLAIMED_MULTIPLE', files_
        if stub:
            return 'CLAIMED_STUB', files_
        return 'CLAIMED', files_

    rows = []
    for b in BINARIES:
        for (cls, sign, sel) in sorted(uni[b]['methods']):
            key = (b, 'method', (cls, sign, sel))
            got = claims.get(key, {})
            status, files_ = status_of(got, False)
            if status == 'UNCLAIMED' and decl_claims.get(key):
                status, files_ = 'DECL_ONLY', sorted(decl_claims[key])
            rows.append([b, 'method', '%s %s[%s]' % (cls, sign, sel), '',
                         ';'.join(files_), status])
        for addr, name in sorted(uni[b]['cfuncs'].items()):
            got = {}
            keys = [('addr', addr)]
            if name.startswith('_'):
                keys.append(('sym', name[1:]))
            shared_sym = False
            for kk in keys:
                for f, v in claims.get((b, 'cfunc', kk), {}).items():
                    if kk[0] == 'sym' and \
                            f.split(os.sep)[0] == SHARED_FOLDER:
                        shared_sym = True
                    if f in got:
                        got[f][0] = got[f][0] or v[0]
                        got[f][1] = max(got[f][1], v[1])
                    else:
                        got[f] = list(v)
            status, files_ = status_of(got, True, shared_sym)
            rows.append([b, 'cfunc', '0x%x' % addr, name,
                         ';'.join(files_), status])

    with open(os.path.join(META, 'FUNCTION_SOURCE_MAP.tsv'), 'w') as fh:
        fh.write('binary\tkind\tkey\tsymbol\tsource_files\tstatus\n')
        for r in rows:
            fh.write('\t'.join(r) + '\n')
    write_gaps(rows)
    for b in BINARIES:
        print(b, dict(Counter(r[5] for r in rows if r[0] == b)))

def write_gaps(rows):
    lines = []
    lines.append('# COVERAGE GAPS — automated function→source census')
    lines.append('')
    lines.append('Generated by `metadata/tools/coverage_census.py` '
                 '(re-runnable; every count below is its direct output, '
                 'from `metadata/FUNCTION_SOURCE_MAP.tsv`).')
    lines.append('')
    lines.append('> **PROVISIONAL — StartupScreen:** the StartupScreen module '
                 'agent was still running when this census was taken; its '
                 'sources under `src/StartupScreen/` are a partial snapshot '
                 'and every StartupScreen gap below must be re-checked after '
                 'that agent lands.')
    lines.append('')
    lines.append('## Claim-matching rules (summary)')
    lines.append('')
    lines.append('- Universe: arm64 slice only. Methods from '
                 '`metadata/raw/<Binary>/objc.json` classes (instance + class '
                 'methods; protocols/categories contribute nothing — there '
                 'are 0 categories in all 8 binaries). C functions from '
                 '`metadata/xref/<Binary>.json` entries not named as methods '
                 '(symbol names or `sub_<hex>`); app addresses normalised '
                 'by −0x100000000.')
    lines.append('- Scanned files: `.m/.h/.c/.mm` under `src/`, excluding '
                 '`disasm/`, `tools/` and `generated/` folders '
                 '(`generated/` = machine-generated skeleton headers).')
    lines.append('- Folder→binary attribution: App→OmniCar; '
                 'AppBridgeA+AppBridgeB→OmniCarAppBridge; '
                 'SplitScreenA+B+C→OmniCarSplitScreen; the rest by module '
                 'name. `src/OMCCommon/` is the shared unit: its symbol '
                 'claims apply to every binary containing that symbol.')
    lines.append('- A file claims a method if it contains a method '
                 '**definition** in an `@implementation` of that class, or '
                 'an **@property** in its `@interface` claiming the '
                 'getter/setter. `@interface` declarations alone give '
                 'DECL_ONLY.')
    lines.append('- A file claims a C function if it **defines** the symbol '
                 '(definition-with-body in .m/.c; a .h prototype is a '
                 'declaration-strength claim), annotates `NAME @ 0xADDR` '
                 'for its address, mentions `sub_<hex>` / `@0x<hex>` '
                 'anywhere, or carries a bare `0x<hex>` token inside a '
                 'comment (or a `0x<lo>-0x<hi>` range near a definition). '
                 'Address claims register only when the address is a '
                 'universe C-function start of that binary. Address claims '
                 'from the shared unit bind only OmniCarCore (its annotated '
                 'offsets are Core\'s); its cross-binary claims are the '
                 'symbol claims.')
    lines.append('- Block-invoke functions are `sub_<hex>` entries; a '
                 'mention in the file hosting the parent function is their '
                 'legitimate claim.')
    lines.append('- The 20-function OMCCommon set claimed by the shared unit '
                 '(`src/OMCCommon/`) plus exactly one module copy = '
                 'EXPECTED_MULTIPLE, shared unit canonical.')
    lines.append('- CLAIMED_STUB = the single claim\'s own definition span '
                 '(or token line) carries a `STUB-UNRECOVERED` marker. '
                 'CLAIMED_MULTIPLE = duplicate definitions in >1 file, or '
                 'claims spanning >1 module folder; a header @property plus '
                 'the .m definition in the same module counts as one claim.')
    lines.append('- Expected artefacts in the unclaimed list: '
                 '`- [.cxx_destruct]` methods are compiler-synthesised '
                 'under ARC and are not written in any source; '
                 '`__mh_execute_header` (OmniCar, 0x0) is the Mach-O header '
                 'symbol, not a function.')
    lines.append('')
    lines.append('## Per-binary counts')
    lines.append('')
    lines.append('| Binary | Total | Methods | C funcs | Claimed once | '
                 'Claimed stub | Expected multiple | Multiple | Decl-only | '
                 'Unclaimed |')
    lines.append('|---|---|---|---|---|---|---|---|---|---|')
    for b in BINARIES:
        br = [r for r in rows if r[0] == b]
        c = Counter(r[5] for r in br)
        nm = sum(1 for r in br if r[1] == 'method')
        nc = sum(1 for r in br if r[1] == 'cfunc')
        lines.append('| %s | %d | %d | %d | %d | %d | %d | %d | %d | %d |' %
                     (b, len(br), nm, nc, c['CLAIMED'], c['CLAIMED_STUB'],
                      c['EXPECTED_MULTIPLE'], c['CLAIMED_MULTIPLE'],
                      c['DECL_ONLY'], c['UNCLAIMED']))
    lines.append('')
    lines.append('## Known seams')
    lines.append('')
    def seam(binary, addr, label):
        hit = [r for r in rows if r[0] == binary and r[1] == 'cfunc'
               and r[2] == '0x%x' % addr]
        if hit:
            r = hit[0]
            lines.append('- **%s** (`%s` %s, %s): status **%s** — %s' %
                         (label, binary, r[2], r[3], r[5],
                          r[4] or '(no claiming file)'))
        else:
            lines.append('- **%s**: address 0x%x not in %s universe' %
                         (label, addr, binary))
    seam('OmniCarSplitScreen', 0x54448,
         'SplitScreen sub_54448 (OMCPerfTicker creation chain head)')
    seam('OmniCarSplitScreen', 0x53f90,
         'SplitScreen sub_53f90 (caller in the PerfTicker chain)')
    seam('OmniCarSplitScreen', 0x48da0,
         'SplitScreen block invoke sub_48da0 (UIColor-by-style block)')
    seam('OmniCarSplitScreen', 0x1ab70,
         'SplitScreen SCPSceneOfVC (sub_1ab70, declared stub)')
    seam('OmniCarSpeedBubble', 0x44a8,
         'SpeedBubble __init_0 @0x44a8 (claimed by both A and B — known)')
    seam('OmniCarSpeedBubble', 0x45b4,
         'SpeedBubble sub_45b4 (claimed by both A and B — known)')
    lines.append('')
    lines.append('## Unclaimed — full list')
    for b in BINARIES:
        un = [r for r in rows if r[0] == b and
              r[5] in ('UNCLAIMED', 'DECL_ONLY')]
        lines.append('')
        lines.append('### %s (%d)' % (b, len(un)))
        lines.append('')
        for r in un:
            sym = (' ' + r[3]) if r[3] else ''
            extra = (' — decl-only in ' + r[4]) if r[5] == 'DECL_ONLY' else ''
            lines.append('- `%s`%s [%s]%s' % (r[2], sym, r[5], extra))
    lines.append('')
    lines.append('## Claimed by multiple files — full list')
    for b in BINARIES:
        mu = [r for r in rows if r[0] == b and
              r[5] in ('CLAIMED_MULTIPLE', 'EXPECTED_MULTIPLE')]
        lines.append('')
        lines.append('### %s (%d)' % (b, len(mu)))
        lines.append('')
        for r in mu:
            sym = (' ' + r[3]) if r[3] else ''
            lines.append('- `%s`%s [%s]: %s' % (r[2], sym, r[5], r[4]))
    lines.append('')
    open(os.path.join(META, 'COVERAGE_GAPS.md'), 'w').write('\n'.join(lines))

if __name__ == '__main__':
    main()
