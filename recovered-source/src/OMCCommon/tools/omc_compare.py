#!/usr/bin/env python3
"""Compare one OMC* function across two binaries, normalized for relocation.

Canonical token stream per instruction:
  - mnemonic + register operands kept verbatim
  - adrp        -> 'adrp <resolved description of target address>'
  - b/bl target -> stub import name / ObjC selector / exported symbol name;
                   local targets canonicalized as 'LOC' + the target's own
                   canonical-stream hash (recursive, depth-limited), so the
                   same helper in two binaries maps to the same token when
                   its body matches
  - other immediates kept (small constants are semantic), except PC-relative
    add/sub immediates paired with a preceding adrp (handled by tracking the
    adrp result per register and resolving the final address)
  - loads/stores from adrp-formed addresses -> resolved description tokens

Verdicts per function:
  IDENTICAL-NORMALIZED  token streams equal
  DIVERGENT             token streams differ (first divergence reported)
Raw byte equality is also reported for reference.
"""
import sys, hashlib, json
sys.path.insert(0, '.')
from omc_disasm import Image
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN
from capstone.arm64 import ARM64_OP_IMM, ARM64_OP_REG, ARM64_OP_MEM

md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
md.detail = True

_hash_cache = {}

def local_token(img, va, depth):
    """Canonical hash token for a local (non-exported) function body."""
    key = (img.path, va, depth)
    if key in _hash_cache:
        return _hash_cache[key]
    _hash_cache[key] = 'LOC...'  # recursion guard
    toks = canon_stream(img, va, depth)
    h = 'LOC#' + hashlib.sha1('|'.join(toks).encode()).hexdigest()[:10]
    _hash_cache[key] = h
    return h

import re, struct
def norm_data(desc):
    # per-binary static layout offsets are not semantic: strip them
    return re.sub(r'(__bss|__data)\+0x[0-9a-f]+', r'\1', desc)

def desc_for(img, addr, depth):
    """Semantic description of a data/code address for cross-binary compare."""
    sn = img.sec_name_of(addr)
    if sn and '__objc_arrayobj' in sn:
        try:
            cnt = img.sl.read_u64(addr + 8)
            kind, buf = img.ptr_at2(addr + 16)
            elems = []
            for i in range(cnt):
                k2, p = img.ptr_at2(buf + 8 * i)
                elems.append(img.cfstrings[p][0] if p in img.cfstrings else '?')
            return 'ARR[' + ','.join(repr(e) for e in elems) + ']'
        except Exception:
            return 'ARR?'
    if sn and '__objc_intobj' in sn:
        sec = img.section('__DATA_CONST', '__objc_intobj')
        if sec and (addr - sec['addr']) % 24 == 0:
            v = struct.unpack('<q', img.sl.read(addr + 16, 8))[0]
            return f'NUM[{v}]'
        return 'NUM?'
    if sn and sn.startswith('__TEXT,__const'):
        raw = img.sl.read(addr, 8)
        return 'TCONST[' + (raw.hex() if raw else '?') + ']'
    if sn and '__const' in sn and img.sl.read(addr, 8):
        # possible block literal: isa bind to __NSConcreteGlobalBlock
        k, v = img.ptr_at2(addr)
        if k == 'bind' and 'NSConcreteGlobalBlock' in str(v):
            inv = img.sl.read_u64(addr + 16) & ((1 << 36) - 1)
            return 'BLOCK->' + target_token(img, inv, depth, None)
        raw = img.sl.read(addr, 8)
        return 'DCONST[' + raw.hex() + ']'
    if addr in img.fstart_set or (sn and sn.startswith('__TEXT,__text')):
        return 'CODE->' + target_token(img, addr, depth, None)
    return norm_data(img.resolve_va(addr))

def target_token(img, va, depth, cur=None):
    if cur is not None and cur[0] <= va < cur[0] + cur[1]:
        return f'BR+{va - cur[0]:#x}'
    if va in img.stub_names:
        return 'stub:' + img.stub_names[va]
    if va in img.objc_stub_sel:
        return 'sel:' + img.objc_stub_sel[va]
    if va in img.sym_at:
        return 'sym:' + img.sym_at[va]
    if va in img.fstart_set:
        if depth <= 0:
            return 'LOC(deep)'
        return local_token(img, va, depth - 1)
    return f'va:{va:#x}'

def _rk(name):
    return 'x' + name[1:] if name.startswith('w') and name[1:].isdigit() else name

def canon_stream(img, va, depth=2, dispmap=None):
    sl = img.sl
    data = sl.read(va, img.func_size(va))
    cur = (va, len(data))
    toks = []
    adrp_val = {}   # reg -> page va, for resolving following add/ldr
    for insn in md.disasm(data, va):
        m = insn.mnemonic
        ops = insn.operands
        parts = [m]
        consumed = False
        if m == 'adrp' and len(ops) == 2 and ops[1].type == ARM64_OP_IMM:
            adrp_val[_rk(insn.reg_name(ops[0].reg))] = ops[1].imm
            parts.append(insn.reg_name(ops[0].reg))
            parts.append('PAGE')
            toks.append(' '.join(parts))
            continue
        if m in ('b', 'bl', 'br', 'blr') :
            for o in ops:
                if o.type == ARM64_OP_IMM:
                    parts.append(target_token(img, o.imm, depth, cur))
                elif o.type == ARM64_OP_REG:
                    parts.append(insn.reg_name(o.reg))
            toks.append(' '.join(parts))
            continue
        if m.startswith('b.') or m in ('cbz', 'cbnz', 'tbz', 'tbnz'):
            for o in ops:
                if o.type == ARM64_OP_IMM:
                    parts.append(f'BR+{o.imm - va:#x}' if cur[0] <= o.imm < cur[0] + cur[1] else 'BR')
                elif o.type == ARM64_OP_REG:
                    parts.append(insn.reg_name(o.reg))
                else:
                    parts.append(str(o.imm))
            toks.append(' '.join(parts))
            continue
        # generic: resolve adrp+add / adrp+ldr address formation
        for o in ops:
            if o.type == ARM64_OP_REG:
                parts.append(insn.reg_name(o.reg))
            elif o.type == ARM64_OP_MEM:
                base = insn.reg_name(o.mem.base) if o.mem.base else ''
                if _rk(base) in adrp_val:
                    addr = adrp_val[_rk(base)] + o.mem.disp
                    desc = desc_for(img, addr, depth)
                    if dispmap is not None:
                        dispmap.setdefault(o.mem.disp, desc)
                    parts.append('[' + desc + ']')
                    consumed = True
                else:
                    parts.append(f'[{base}+{o.mem.disp}]')
            elif o.type == ARM64_OP_IMM:
                # add/sub with adrp base register as first source operand
                if m in ('add', 'sub') and len(ops) >= 2 and ops[1].type == ARM64_OP_REG \
                        and _rk(insn.reg_name(ops[1].reg)) in adrp_val:
                    addr = adrp_val[_rk(insn.reg_name(ops[1].reg))] + (o.imm if m == 'add' else -o.imm)
                    parts.append(desc_for(img, addr, depth))
                    consumed = True
                else:
                    parts.append(f'#{o.imm}')
            else:
                parts.append(insn.op_str)
        toks.append(' '.join(parts))
        # --- adrp tracking hygiene ---
        if m in ('bl', 'blr'):
            for r in list(adrp_val):
                if r[1:].isdigit() and int(r[1:]) <= 18:
                    del adrp_val[r]
        elif m == 'add' and len(ops) == 3 and ops[1].type == ARM64_OP_REG \
                and _rk(insn.reg_name(ops[1].reg)) in adrp_val and ops[2].type == ARM64_OP_IMM:
            adrp_val[_rk(insn.reg_name(ops[0].reg))] = adrp_val[_rk(insn.reg_name(ops[1].reg))] + ops[2].imm
        elif m == 'mov' and len(ops) == 2 and ops[1].type == ARM64_OP_REG \
                and _rk(insn.reg_name(ops[1].reg)) in adrp_val:
            adrp_val[_rk(insn.reg_name(ops[0].reg))] = adrp_val[_rk(insn.reg_name(ops[1].reg))]
        elif ops and ops[0].type == ARM64_OP_REG and m not in (
                'str', 'strb', 'strh', 'stp', 'ldp', 'cmp', 'cmn', 'tst', 'b', 'bl', 'blr', 'ret', 'nop'):
            adrp_val.pop(_rk(insn.reg_name(ops[0].reg)), None)
    return toks

def compare(path_a, path_b, names):
    ia, ib = Image(path_a), Image(path_b)
    out = {}
    for nm in names:
        va_a = ia.def_syms.get(nm)
        va_b = ib.def_syms.get(nm)
        if va_a is None or va_b is None:
            out[nm] = {'present_a': va_a is not None, 'present_b': va_b is not None}
            continue
        raw_a = ia.func_bytes(va_a)
        raw_b = ib.func_bytes(va_b)
        ma, mb = {}, {}
        ta = canon_stream(ia, va_a, dispmap=ma)
        tb = canon_stream(ib, va_b, dispmap=mb)
        slot_note = None
        if ta != tb:
            # second pass: rewrite raw [reg+disp] MEM tokens whose displacement
            # is a known classref/selref/got slot in the same binary
            def rewrite(toks, dmap):
                out = []
                for t in toks:
                    mm = re.search(r'\[(\w+)\+(\d+)\]$', t)
                    if mm and mm.group(1) not in ('sp', 'fp', 'x29') and int(mm.group(2)) in dmap:
                        t = t[:mm.start()] + '[' + dmap[int(mm.group(2))] + ']'
                    out.append(t)
                return out
            ta2, tb2 = rewrite(ta, ma), rewrite(tb, mb)
            if ta2 == tb2:
                slot_note = 'equal after classref-slot resolution (tracker merge-point artifact)'
                ta, tb = ta2, tb2
        div = None
        if ta != tb:
            for i, (x, y) in enumerate(zip(ta, tb)):
                if x != y:
                    div = {'index': i, 'a': x, 'b': y}
                    break
            if div is None:
                div = {'index': min(len(ta), len(tb)), 'a': '<end>' if len(ta) <= len(tb) else ta[len(tb)], 'b': '<end>' if len(tb) <= len(ta) else tb[len(ta)]}
        out[nm] = {
            'va_a': hex(va_a), 'va_b': hex(va_b),
            'size_a': len(raw_a), 'size_b': len(raw_b),
            'raw_identical': raw_a == raw_b,
            'normalized_identical': ta == tb,
            'slot_resolution_note': slot_note,
            'tokens_a': len(ta), 'tokens_b': len(tb),
            'first_divergence': div,
        }
    return out

if __name__ == '__main__':
    names = sys.argv[3:]
    res = compare(sys.argv[1], sys.argv[2], names)
    print(json.dumps(res, indent=1))
