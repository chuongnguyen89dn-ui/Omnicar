#!/usr/bin/env python3
"""macho_truth.py -- INDEPENDENT ground-truth resolver for the OmniCar RE audit.

Written by the rolling verifier. Resolves, straight from the original
binaries (arm64 slice):
  * __stubs entry address -> imported symbol name (LC_DYSYMTAB indirect table)
  * __objc_stubs entry address -> selector string (stub decode + selref chase)
  * any VA -> defined symbol name (LC_SYMTAB)
  * selref/classref slot VA -> pointed-to VA (dyld chained fixups decode,
    formats 1/2/6/12, layouts per <mach-o/fixup-chains.h>)

No module agent's dump or annotation is consulted anywhere in this file.
"""
import struct
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN

CPU_ARM64 = 0x0100000C


def split_fat(data):
    if struct.unpack(">I", data[:4])[0] != 0xCAFEBABE:
        return [(0, len(data))]
    n = struct.unpack(">I", data[4:8])[0]
    out = []
    for i in range(n):
        ct, cs, off, size, _al = struct.unpack(">IIIII", data[8 + i * 20:28 + i * 20])
        out.append((ct, cs, off, size))
    return out


class MachO:
    def __init__(self, path, want_e=False):
        self.data = open(path, "rb").read()
        base = None
        for ent in split_fat(self.data):
            if len(ent) == 4:
                ct, cs, off, _size = ent
                if ct == CPU_ARM64 and (cs == 2) == want_e:
                    base = off
                    break
            else:
                base = ent[0]
                break
        if base is None:
            raise ValueError("no arm64 slice in " + path)
        self.base = base
        d, b = self.data, base
        self.image_base = 0
        ncmds = struct.unpack_from("<I", d, b + 16)[0]
        p = b + 32
        self.sections = []          # dicts
        self.segments = []
        self.symtab = []            # (name, type, value)
        self.indirect = []
        self.func_starts = []
        self.fixups_off = self.fixups_size = 0
        self.imports = []           # chained-fixups import symbol names
        self.ptr_format = None
        for _ in range(ncmds):
            cmd, cmdsize = struct.unpack_from("<II", d, p)
            if cmd == 0x19:  # LC_SEGMENT_64
                segname = d[p + 8:p + 24].split(b"\0")[0].decode()
                vmaddr, vmsize, fileoff, filesize = struct.unpack_from("<QQQQ", d, p + 24)
                nsec = struct.unpack_from("<I", d, p + 64)[0]
                self.segments.append(dict(name=segname, vmaddr=vmaddr, vmsize=vmsize,
                                          fileoff=fileoff, filesize=filesize))
                if segname == "__TEXT":
                    self.image_base = vmaddr
                q = p + 72
                for _j in range(nsec):
                    name = d[q:q + 16].split(b"\0")[0].decode()
                    sseg = d[q + 16:q + 32].split(b"\0")[0].decode()
                    addr, size, off = struct.unpack_from("<QQI", d, q + 32)
                    flags, r1, r2 = struct.unpack_from("<III", d, q + 64)
                    self.sections.append(dict(seg=sseg, name=name, addr=addr, size=size,
                                              off=off, flags=flags, r1=r1, r2=r2))
                    q += 80
            elif cmd == 0x2:  # LC_SYMTAB
                symoff, nsyms, stroff, _strsize = struct.unpack_from("<IIII", d, p + 8)
                for i in range(nsyms):
                    strx, typ, _sec, _desc, val = struct.unpack_from("<IBBHQ", d, b + symoff + i * 16)
                    nm = ""
                    if strx:
                        end = d.index(b"\0", b + stroff + strx)
                        nm = d[b + stroff + strx:end].decode("utf8", "replace")
                    self.symtab.append((nm, typ, val))
            elif cmd == 0xB:  # LC_DYSYMTAB
                f = struct.unpack_from("<18I", d, p + 8)
                indoff, nind = f[12], f[13]
                self.indirect = list(struct.unpack_from("<%dI" % nind, d, b + indoff))
            elif cmd == 0x26:  # LC_FUNCTION_STARTS
                doff, dsize = struct.unpack_from("<II", d, p + 8)
                addr = 0
                q = b + doff
                end = q + dsize
                while q < end:
                    shift = 0
                    while True:
                        byte = d[q]; q += 1
                        addr += (byte & 0x7F) << shift
                        shift += 7
                        if not (byte & 0x80):
                            break
                    if addr:
                        self.func_starts.append(addr)
                self.func_starts.sort()
            elif cmd == 0x80000034:  # LC_DYLD_CHAINED_FIXUPS
                self.fixups_off, self.fixups_size = struct.unpack_from("<II", d, p + 8)
            p += cmdsize
        self._parse_fixups()
        self._build_maps()

    # ---------- chained fixups ----------
    def _parse_fixups(self):
        if not self.fixups_off:
            return
        d, b = self.data, self.base + self.fixups_off
        (_ver, starts_off, _imports_off, _symbols_off, imports_cnt,
         imports_fmt, _sym_fmt) = struct.unpack_from("<7I", d, b)
        # imports: format 1 entries are u32 {lib:8, weak:1, name_offset:23}
        sym_pool = b + _symbols_off
        imp_base = b + _imports_off
        for i in range(imports_cnt):
            v = struct.unpack_from("<I", d, imp_base + i * 4)[0]
            noff = (v >> 9) & 0x7FFFFF
            end = d.index(b"\0", sym_pool + noff)
            self.imports.append(d[sym_pool + noff:end].decode("utf8", "replace"))
        # starts_in_image: u32 offset per segment; lld images here carry one
        # entry whose pointer format applies image-wide (empirical, wave-1).
        starts_base = b + starts_off
        from collections import Counter
        fmts = Counter()
        nseg = len(self.segments)
        for i in range(nseg):
            off = struct.unpack_from("<I", d, starts_base + i * 4)[0]
            if off:
                _sz, ps, fmt = struct.unpack_from("<IHH", d, starts_base + off)
                # sanity: real entries have a plausible page size; lld images
                # here also expose one bogus entry (fmt 0, page size 0x18).
                if fmt and ps in (0x40, 0x100, 0x1000, 0x4000):
                    fmts[fmt] += 1
        if fmts:
            self.ptr_format = fmts.most_common(1)[0][0]

    def decode_ptr(self, raw):
        """Decode one on-disk pointer slot value -> (kind, value)
        kind: 'rebase' (value = VA), 'bind' (value = import name), 'raw'."""
        fmt = self.ptr_format
        if fmt in (7, 9):
            fmt = 1
        if fmt == 12:  # USERLAND24
            if raw >> 62 == 0 and (raw >> 63) & 1 == 0:
                return ("rebase", self.image_base + (raw & ((1 << 43) - 1)))
            if (raw >> 63) & 1 and not (raw >> 62) & 1:
                return ("rebase", self.image_base + (raw & ((1 << 27) - 1)))
            if (raw >> 62) & 1:
                ordv = raw & 0xFFFFFF
                return ("bind", self.imports[ordv] if ordv < len(self.imports) else "?ord%d" % ordv)
            return ("raw", raw)
        if fmt == 1:  # ARM64E
            bind = (raw >> 63) & 1
            auth = (raw >> 62) & 1
            if bind:
                ordv = (raw & 0xFFFF) if auth else (raw & 0xFF)
                return ("bind", self.imports[ordv] if ordv < len(self.imports) else "?ord%d" % ordv)
            if auth:
                return ("rebase", self.image_base + (raw & ((1 << 36) - 1)))
            tgt = (raw & ((1 << 36) - 1)) | (((raw >> 54) & 0xFF) << 36)
            return ("rebase", self.image_base + tgt if self.image_base else tgt)
        if fmt == 6:  # 64_OFFSET
            if (raw >> 63) & 1:
                ordv = raw & 0xFFFF
                return ("bind", self.imports[ordv] if ordv < len(self.imports) else "?ord%d" % ordv)
            return ("rebase", self.image_base + (raw & ((1 << 36) - 1)))
        if fmt == 2:  # 64_UNRESTRICTED
            if (raw >> 63) & 1:
                ordv = raw & 0xFFFF
                return ("bind", self.imports[ordv] if ordv < len(self.imports) else "?ord%d" % ordv)
            return ("rebase", raw & ((1 << 62) - 1))
        return ("raw", raw)

    # ---------- maps ----------
    def _build_maps(self):
        self.defined = {}
        for nm, typ, val in self.symtab:
            if val and (typ & 0x0E) == 0x0E and nm:  # N_SECT defined
                self.defined.setdefault(val, nm)
        self.stub_map = {}
        for s in self.sections:
            if s["name"] == "__stubs" and s["r2"]:
                n = s["size"] // s["r2"]
                for i in range(n):
                    si = self.indirect[s["r1"] + i] if s["r1"] + i < len(self.indirect) else 0xFFFFFFFF
                    if si != 0xFFFFFFFF and si < len(self.symtab):
                        self.stub_map[s["addr"] + i * s["r2"]] = self.symtab[si][0]
        self._objc_stub_map = None

    def sec(self, name):
        for s in self.sections:
            if s["name"] == name:
                return s
        return None

    def va_off(self, va):
        for seg in self.segments:
            if seg["vmaddr"] <= va < seg["vmaddr"] + seg["filesize"]:
                return self.base + seg["fileoff"] + (va - seg["vmaddr"])
        return None

    def read(self, va, n):
        off = self.va_off(va)
        return self.data[off:off + n] if off is not None else b""

    def read_u64(self, va):
        return struct.unpack("<Q", self.read(va, 8))[0]

    def cstr(self, va, maxlen=512):
        off = self.va_off(va)
        if off is None:
            return None
        end = self.data.index(b"\0", off, off + maxlen)
        return self.data[off:end].decode("utf8", "replace")

    def resolve_ptr_at(self, va):
        return self.decode_ptr(self.read_u64(va))

    # ---------- objc selector stubs ----------
    def objc_stub_map(self):
        """__objc_stubs entry VA -> selector string (decoded by hand)."""
        if self._objc_stub_map is not None:
            return self._objc_stub_map
        out = {}
        sec = self.sec("__objc_stubs")
        if sec:
            md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
            # stubs are 12 bytes in these images (adrp, ldr, b) -- detect by
            # walking: entries begin where an adrp into __objc_selrefs occurs.
            va = sec["addr"]
            end = va + sec["size"]
            code = self.read(va, sec["size"])
            entries = []
            cur = None
            for ins in md.disasm(code, va):
                if ins.mnemonic == "adrp" and ins.op_str.startswith("x1,"):
                    cur = ins.address
                if cur is not None and ins.mnemonic == "ldr" and ", [x1" in ins.op_str:
                    # selref slot va
                    page = None
                    for j in md.disasm(self.read(cur, ins.address - cur + 4), cur):
                        if j.mnemonic == "adrp":
                            page = int(j.op_str.split("#")[1], 16) if "#" in j.op_str else None
                    off = 0
                    if "#" in ins.op_str:
                        try:
                            off = int(ins.op_str.rsplit("#", 1)[1].rstrip("]"), 16)
                        except ValueError:
                            off = 0
                    if page is not None:
                        slot = page + off
                        kind, val = self.resolve_ptr_at(slot)
                        sel = self.cstr(val) if kind == "rebase" else None
                        entries.append((cur, sel))
                    cur = None
            for a, sel in entries:
                if sel:
                    out[a] = sel
            self._stub_size = None
            if len(entries) >= 2:
                diffs = [entries[i + 1][0] - entries[i][0] for i in range(len(entries) - 1)]
                if diffs and all(x == diffs[0] for x in diffs):
                    self._stub_size = diffs[0]
        self._objc_stub_map = out
        return out

    # ---------- data-slot truth (classref / selref / got / la_symbol_ptr) ----------
    def la_map(self):
        if getattr(self, "_la_map", None) is None:
            out = {}
            for s in self.sections:
                if s["name"] == "__la_symbol_ptr":
                    n = s["size"] // 8
                    for i in range(n):
                        si = self.indirect[s["r1"] + i] if s["r1"] + i < len(self.indirect) else 0xFFFFFFFF
                        if si != 0xFFFFFFFF and si < len(self.symtab):
                            out[s["addr"] + i * 8] = self.symtab[si][0]
                if s["name"] == "__objc_classrefs":
                    pass
            self._la_map = out
        return self._la_map

    def in_section(self, va, name):
        s = self.sec(name)
        return s is not None and s["addr"] <= va < s["addr"] + s["size"]

    def class_name_at(self, class_va):
        """Name of the ObjC class whose class struct sits at class_va."""
        data_raw = self.read_u64(class_va + 32)
        kind, data = self.decode_ptr(data_raw)
        if kind != "rebase":
            return None
        ro = data & 0x00007FFFFFFFFFF8
        nkind, nval = self.resolve_ptr_at(ro + 24)
        if nkind != "rebase":
            return None
        return self.cstr(nval)

    def slot_truth(self, va):
        """What a data slot at VA refers to.
        Returns (kind, name): kind in sel/class/got-sym/bind."""
        la = self.la_map()
        if va in la:
            return ("got-sym", la[va])
        if self.in_section(va, "__objc_selrefs"):
            kind, val = self.resolve_ptr_at(va)
            if kind == "rebase":
                return ("sel", self.cstr(val))
            return ("sel", None)
        if self.in_section(va, "__objc_classrefs"):
            kind, val = self.resolve_ptr_at(va)
            if kind == "bind":
                return ("class", val.replace("_OBJC_CLASS_$_", ""))
            if kind == "rebase":
                return ("class", self.class_name_at(val))
            return ("class", None)
        kind, val = self.resolve_ptr_at(va)
        if kind == "bind":
            return ("got-sym", val)
        if kind == "rebase":
            return ("ptr", hex(val))
        return ("raw", None)

    def call_truth(self, target):
        """Ground truth for a bl/b target VA.
        Returns (kind, name): kind in stub/selstub/defined/text."""
        if target in self.stub_map:
            return ("stub", self.stub_map[target])
        om = self.objc_stub_map()
        if target in om:
            return ("selstub", om[target])
        if target in self.defined:
            return ("defined", self.defined[target])
        return ("text", None)
