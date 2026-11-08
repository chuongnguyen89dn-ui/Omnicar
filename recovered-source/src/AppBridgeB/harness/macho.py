#!/usr/bin/env python3
"""Minimal Mach-O arm64 (chained fixups) analysis harness for OmniCarAppBridge.
Reads the fat binary, extracts the arm64 slice, resolves:
 - function starts (LC_FUNCTION_STARTS)
 - symtab defined/undefined symbols
 - __got chained-bind slots -> import names
 - __objc_selrefs / __objc_classrefs chained rebases -> names
 - __cfstring literals
 - __stubs and __objc_stubs targets
 - adrp+add/ldr literal address resolution helpers for the disassembler
"""
import json, struct, sys

PATH = "/home/hatch/workspace/omnicar-re/payload/var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.dylib"

def u32(b,o): return struct.unpack_from("<I", b, o)[0]
def u64(b,o): return struct.unpack_from("<Q", b, o)[0]
def cstr(b,o,maxlen=8192):
    e = b.find(b"\x00", o, o+maxlen)
    if e < 0: e = o+maxlen
    return b[o:e].decode("utf-8", "replace")

class Slice:
    def __init__(self, data, base):
        self.d = data; self.base = base
        self.sections = {}          # (seg,name) -> dict(addr,size,offset)
        self.sec_by_addr = []       # (addr, addr+size, seg, name, offset)
        self.symbols = {}           # name -> value (defined)
        self.undef = []             # undefined symbol names in symtab order
        self.all_syms = []          # (name, value, n_type, n_sect)
        self.fixups = None
        self.func_starts = []
        self.got_import = {}        # got slot vmaddr -> import name
        self.parse()

    def parse(self):
        d, b = self.d, self.base
        ncmds = u32(d, b+16)
        off = b + 32
        symtab = dysym = None
        for _ in range(ncmds):
            cmd, size = u32(d, off) & 0x7fffffff, u32(d, off+4)
            if cmd == 0x34:  # LC_DYLD_CHAINED_FIXUPS
                self.fixups = (u32(d, off+8), u32(d, off+12))
            elif cmd == 0x2:  # LC_SYMTAB
                symtab = (u32(d, off+8), u32(d, off+12), u32(d, off+16), u32(d, off+20))
            elif cmd == 0xb:  # LC_DYSYMTAB
                dysym = struct.unpack_from("<18I", d, off+8)
            elif cmd == 0x26:  # LC_FUNCTION_STARTS
                self.func_starts = self._func_starts(u32(d, off+8), u32(d, off+12))
            elif cmd in (0x1, 0x19):  # LC_SEGMENT(_64)
                seg = cstr(d, off+8, 16)
                nsects = u32(d, off+64)
                so = off + 72
                for i in range(nsects):
                    name = cstr(d, so+80*i, 16); sseg = cstr(d, so+80*i+16, 16)
                    addr, sz = u64(d, so+80*i+32), u64(d, so+80*i+40)
                    foff = u32(d, so+80*i+48)
                    self.sections[(sseg, name)] = dict(addr=addr, size=sz, offset=foff)
                    self.sec_by_addr.append((addr, addr+sz, sseg, name, foff))
            off += size
        if symtab:
            symoff, nsyms, stroff, strsize = symtab
            for i in range(nsyms):
                o = self.base + symoff + i*16
                n_strx, n_type, n_sect = u32(d, o), d[o+4], d[o+5]
                val = u64(d, o+8)
                name = cstr(d, self.base+stroff+n_strx) if n_strx else ""
                self.all_syms.append((name, val, n_type, n_sect))
                if n_type & 0x0e == 0x0 and name:
                    self.undef.append(name)
                elif name and n_sect:
                    self.symbols[name] = val
        self._parse_fixups_imports()

    def _func_starts(self, dataoff, datasize):
        d, b = self.d, self.base
        starts, addr, o = [], 0, b+dataoff
        end = o + datasize
        while o < end:
            shift = 0; delta = 0
            while True:
                byte = d[o]; o += 1
                delta |= (byte & 0x7f) << shift; shift += 7
                if not (byte & 0x80): break
            addr += delta
            if delta == 0: break
            starts.append(addr)
        return starts

    def _parse_fixups_imports(self):
        if not self.fixups: return
        d, b = self.d, self.base
        dataoff, _ = self.fixups
        hdr = b + dataoff
        starts_off, imports_off, symbols_off = u32(d, hdr+4), u32(d, hdr+8), u32(d, hdr+12)
        imports_count = u32(d, hdr+16)
        self.fixup_imports = []
        for i in range(imports_count):
            entry = u32(d, hdr + imports_off + i*4)
            so = entry >> 9  # validated empirically: 241/241 names match undefined symtab
            self.fixup_imports.append(cstr(d, hdr + symbols_off + so))

    # ---- address helpers (vmaddr == slice-relative file offset here) ----
    def read(self, vmaddr, size):
        return self.d[self.base+vmaddr : self.base+vmaddr+size]
    def u64v(self, vmaddr): return u64(self.d, self.base+vmaddr)
    def u32v(self, vmaddr): return u32(self.d, self.base+vmaddr)
    def cstrv(self, vmaddr, maxlen=8192): return cstr(self.d, self.base+vmaddr, maxlen)
    def section_of(self, vmaddr):
        for a, e, seg, name, foff in self.sec_by_addr:
            if a <= vmaddr < e: return (seg, name)
        return None

    def chained(self, vmaddr):
        """Decode the raw chained-fixup pointer stored at vmaddr.
        Returns ('bind', import_name) | ('rebase', target_vmaddr) | ('raw', val)."""
        v = self.u64v(vmaddr)
        if v >> 63 & 1:  # bind (validated empirically on __got: low16 = ordinal)
            ordinal = v & 0xffff
            if ordinal < len(self.fixup_imports):
                return ("bind", self.fixup_imports[ordinal])
            return ("bind?", ordinal)
        if v != 0:  # rebase: target vmaddr in low 36 bits (validated on __objc_selrefs)
            return ("rebase", v & 0xfffffffff)
        return ("raw", v)

def load():
    data = open(PATH, "rb").read()
    nfat = struct.unpack_from(">I", data, 4)[0]
    for i in range(nfat):
        o = 8 + i*20
        cputype, cpusub, off, size, align = struct.unpack_from(">IIIII", data, o)
        if cputype == 0x0100000c and cpusub & 0xff != 2:  # arm64 (not arm64e subtype 2 check below)
            pass
        if cputype == 0x0100000c and (cpusub & 0x00ffffff) in (0, 1):
            return Slice(data, off)
    # fallback: arm64 is first slice with cpu arm64 and subtype 0/1; else slice 0 heuristics
    raise SystemExit("arm64 slice not found")

if __name__ == "__main__":
    s = load()
    print("func_starts:", len(s.func_starts), "first/last:", hex(s.func_starts[0]), hex(s.func_starts[-1]))
    print("defined syms:", len(s.symbols), "undef:", len(s.undef))
    print("fixup imports:", len(s.fixup_imports))
    # resolve __got
    got = s.sections[("__DATA_CONST", "__got")]
    for i in range(got["size"]//8):
        va = got["addr"] + i*8
        kind, val = s.chained(va)
        if kind == "bind": s.got_import[va] = val
    print("got imports resolved:", len(s.got_import))
    for va, name in list(s.got_import.items())[:10]:
        print(hex(va), name)
