#!/usr/bin/env python3
"""macho_objc.py - stage 2: chained-fixups-aware Objective-C metadata extraction.

Pure stdlib (Python 3). Parses one Mach-O file (fat or thin) and emits JSON with,
per slice:
  - fixups: pointer format per segment + chained-fixups import symbol names
  - symbols: full LC_SYMTAB table (name/type/defined/external/value)
  - exports: names from LC_DYLD_EXPORTS_TRIE (if present)
  - objc: imageinfo flags, classes (name, superclass, ivars, properties,
    instance+class methods with type encodings, adopted protocols),
    categories, defined protocols, referenced classes (classrefs),
    selector references (selrefs, deduplicated)
Pointer decoding implements dyld chained fixups formats 1 (ARM64E),
2 (64_UNRESTRICTED) and 6 (64_OFFSET) per <mach-o/fixup-chains.h>:
  ARM64E: bit63=bind, bit62=auth; rebase target = low36 | (high8<<36);
          auth-rebase target = low36; bind ordinal = low8 (auth-bind: low16).
  64_OFFSET: bit63=bind (ordinal low16); rebase = image_base + low36.
Method lists support both classic (24-byte) and relative/small (12-byte,
entsizeAndFlags & 0x80000000) entry formats.

Usage: macho_objc.py <macho-file> > out.json
Validation counters (e.g. unresolvable pointers) are reported in the JSON
under "warnings" so consumers can judge extraction quality. Nothing is
silently dropped.

Empirical notes (verified on the OmniCar 1.0.3 payload, 2026-11-08):
- dyld_chained_fixups_header has SEVEN u32 fields (no symbols_count);
  imports are u32 dyld_chained_import {lib:8, weak_import:1, name_offset:23}.
- These lld-built images carry ONE chained-starts entry whose pointer
  format applies image-wide (segment_offset = file offset where the
  chained region starts; the starts-array index does NOT match the ObjC
  segments), so decode_ptr falls back to the image's single format.
- USERLAND24 (fmt 12): bind bit62 (ordinal = low 24 bits; auth bind =
  low 16 bits, addend above); auth rebase bit63-only, target = low 27
  bits with diversity at bits 27..42; plain rebase target = low 43 bits.
  Rebase targets are image-base-relative offsets (base added back), which
  only matters for the MH_EXECUTE app (base 0x100000000).
  Auth-rebase targets cross-checked against the arm64 slice (isa/data
  pointers match arm64 targets + a constant slice delta).
- Superclass fields are direct binds (_OBJC_CLASS_$_X). Several OmniCar
  classes bind semantically surprising superclasses (e.g. SCPCButton ->
  NSSortDescriptor, SCPCarSplitView -> NSMutableArray); the encoding is
  identical in both slices, so it is reported as-is, not "corrected".
"""
import json
import struct
import sys

sys.path.insert(0, __file__.rsplit("/", 1)[0])
from macho_scan import split_fat, parse_slice, cstr  # noqa: E402


def u32(b, o):
    return struct.unpack_from("<I", b, o)[0]


def i32(b, o):
    return struct.unpack_from("<i", b, o)[0]


def u64(b, o):
    return struct.unpack_from("<Q", b, o)[0]


def u16(b, o):
    return struct.unpack_from("<H", b, o)[0]


class Slice:
    def __init__(self, data, scan):
        self.data = data  # slice bytes (offsets are slice-relative)
        self.scan = scan
        self.base = scan.get("image_base") or 0
        self.sections = {(s["seg"], s["name"]): s for s in scan["sections"]}
        self.segments = []  # (vmaddr, vmsize, fileoff, filesize, name)
        for lc in scan["load_commands"]:
            if lc["cmd"].startswith("LC_SEGMENT_64"):
                self.segments.append((lc["vmaddr"], lc["vmsize"], lc["fileoff"], lc["filesize"], lc["segname"]))
        self.warnings = []
        self.imports = []          # chained-fixups import symbol names (index = ordinal-1)
        self.seg_ptr_format = {}   # seg index -> pointer format
        self._parse_fixups_header()
        # lld emits ONE chained-starts entry for the whole image (anchored at an
        # arbitrary segment index, segment_offset = start of the chained region),
        # so a single distinct format applies image-wide. dyld's per-segment
        # lookup still wins when an image genuinely mixes formats.
        fmts = set(self.seg_ptr_format.values())
        self.default_fmt = fmts.pop() if len(fmts) == 1 else None
        self.symbols = self._parse_symtab()
        self.exports = self._parse_exports_trie()

    # ---------- address helpers ----------
    def va_to_off(self, va):
        for vmaddr, _vmsize, fileoff, filesize, _name in self.segments:
            if vmaddr <= va < vmaddr + filesize:
                return fileoff + (va - vmaddr)
        return None

    def read(self, va, size):
        off = self.va_to_off(va)
        if off is None:
            return None
        return self.data[off:off + size]

    def read_u64(self, va):
        b = self.read(va, 8)
        return None if b is None or len(b) < 8 else struct.unpack("<Q", b)[0]

    def read_u32(self, va):
        b = self.read(va, 4)
        return None if b is None or len(b) < 4 else struct.unpack("<I", b)[0]

    def read_cstr(self, va, maxlen=8192):
        off = self.va_to_off(va)
        if off is None:
            return None
        return cstr(self.data, off, maxlen)

    def seg_index_of(self, va):
        for i, (vmaddr, vmsize, _fo, _fs, _n) in enumerate(self.segments):
            if vmaddr <= va < vmaddr + vmsize:
                return i
        return None

    def section_bytes(self, seg, name):
        s = self.sections.get((seg, name))
        if not s:
            return None, None
        return s, self.data[s["offset"]:s["offset"] + s["size"]]

    # ---------- chained fixups ----------
    def _parse_fixups_header(self):
        doff = None
        for lc in self.scan["load_commands"]:
            if lc["cmd"].startswith("LC_DYLD_CHAINED_FIXUPS"):
                doff = lc["dataoff"]
        if doff is None:
            return
        d = self.data
        # dyld_chained_fixups_header has SEVEN u32 fields (no symbols_count):
        # fixups_version, starts_offset, imports_offset, symbols_offset,
        # imports_count, imports_format, symbols_format.
        (_ver, starts_off, imports_off, symbols_off, imports_count,
         imports_format, _symbols_format) = struct.unpack_from("<7I", d, doff)
        # imports (format 1 = DYLD_CHAINED_IMPORT): 4-byte entries
        # { lib:8, weak_import:1, name_offset:23 } - validated empirically:
        # imports table size == imports_count*4 and ends exactly at symbols_off.
        self.imports_format = imports_format
        for i in range(imports_count):
            raw = u32(d, doff + imports_off + i * 4)
            name_off = (raw >> 9) & ((1 << 23) - 1)
            self.imports.append(cstr(d, doff + symbols_off + name_off))
        # starts_in_image: seg_count u32, then seg_count u16 offsets
        starts_base = doff + starts_off
        seg_count = u32(d, starts_base)
        for i in range(seg_count):
            rel = u16(d, starts_base + 4 + i * 2)
            if rel == 0:
                continue
            seg_starts = starts_base + rel
            # dyld_chained_starts_in_segment { u32 size; u16 page_size; u16 pointer_format;
            #   u64 segment_offset; u32 max_valid_pointer; u16 page_count; u16 page_start[] }
            _size, _page_size, ptr_format = struct.unpack_from("<IHH", d, seg_starts)
            self.seg_ptr_format[i] = ptr_format

    def decode_ptr(self, raw, storage_va):
        """Return (kind, value): kind in {'null','ptr','bind'}; value = vmaddr or symbol name."""
        if raw == 0:
            return ("null", 0)
        fmt = self.seg_ptr_format.get(self.seg_index_of(storage_va))
        if fmt is None:
            fmt = self.default_fmt if self.default_fmt is not None else 1
        if fmt in (7, 9):  # ARM64E_KERNEL / ARM64E_USERLAND: same value layout as ARM64E
            fmt = 1
        if fmt == 12:  # DYLD_CHAINED_PTR_ARM64E_USERLAND24 (fixup-chains.h):
            # bind: bit62=1, ordinal = low 24 bits (auth bind, bit63 too: low 16);
            # auth rebase: bit63 only, target = low 27 bits, diversity above;
            # plain rebase: target = low 43 bits. Auth-rebase targets
            # cross-checked against the arm64 slice (isa/data pointers match
            # arm64 targets + a constant slice delta).
            if (raw >> 62) & 1:
                if (raw >> 63) & 1:
                    return ("bind", self._import_name(raw & 0xFFFF))
                return ("bind", self._import_name(raw & 0xFFFFFF))
            if (raw >> 63) & 1:
                return ("ptr", self.base + (raw & ((1 << 27) - 1)))
            return ("ptr", self.base + (raw & ((1 << 43) - 1)))
        if fmt == 1:  # DYLD_CHAINED_PTR_ARM64E
            is_bind = (raw >> 63) & 1
            is_auth = (raw >> 62) & 1
            if is_bind:
                ordinal = (raw & 0xFFFF) if is_auth else (raw & 0xFF)
                return ("bind", self._import_name(ordinal))
            if is_auth:
                return ("ptr", raw & ((1 << 36) - 1))
            target = (raw & ((1 << 36) - 1)) | (((raw >> 36) & 0xFF) << 36)
            return ("ptr", target)
        if fmt == 6:  # DYLD_CHAINED_PTR_64_OFFSET
            if (raw >> 63) & 1:
                return ("bind", self._import_name(raw & 0xFFFF))
            return ("ptr", self.base + (raw & ((1 << 36) - 1)))
        if fmt == 2:  # DYLD_CHAINED_PTR_64_UNRESTRICTED
            if (raw >> 63) & 1:
                return ("bind", self._import_name(raw & 0xFFFF))
            return ("ptr", raw & ((1 << 48) - 1))
        # unknown format: assume raw vmaddr
        return ("ptr", raw)

    def _import_name(self, ordinal):
        if 1 <= ordinal <= len(self.imports):
            return self.imports[ordinal - 1]
        self.warnings.append(f"bind ordinal {ordinal} out of range (imports={len(self.imports)})")
        return f"<ordinal {ordinal}>"

    def ptr_at(self, va):
        """Decode the pointer stored at vmaddr `va`."""
        raw = self.read_u64(va)
        if raw is None:
            return ("null", 0)
        return self.decode_ptr(raw, va)

    def ptr_field(self, base_va, index):
        return self.ptr_at(base_va + index * 8)

    # ---------- symbols ----------
    def _parse_symtab(self):
        st = self.scan.get("symtab")
        if not st:
            return []
        out = []
        d = self.data
        for i in range(st["nsyms"]):
            so = st["symoff"] + i * 16
            n_strx, n_type, n_sect, n_desc, n_value = struct.unpack_from("<IBBHQ", d, so)
            name = cstr(d, st["stroff"] + n_strx) if n_strx else ""
            if n_type & 0xE0:  # stab debug entry
                kind = "stab"
            elif n_type & 0x0E == 0x0:
                kind = "undefined"
            elif n_type & 0x0E == 0x2:
                kind = "absolute"
            elif n_type & 0x0E == 0xE:
                kind = "defined_sect"
            elif n_type & 0x0E == 0xA:
                kind = "indirect"
            else:
                kind = f"type{n_type & 0x0E:#x}"
            out.append({"name": name, "kind": kind, "external": bool(n_type & 0x01),
                        "sect": n_sect, "desc": n_desc, "value": n_value})
        return out

    def _parse_exports_trie(self):
        node = None
        for lc in self.scan["load_commands"]:
            if lc["cmd"].startswith("LC_DYLD_EXPORTS_TRIE"):
                node = (lc["dataoff"], lc["datasize"])
        di = self.scan.get("dyld_info")
        if node is None and di and di["export_size"]:
            node = (di["export_off"], di["export_size"])
        if node is None:
            return []
        start, size = node
        blob = self.data[start:start + size]
        out = []

        def uleb(off):
            result = 0
            shift = 0
            while True:
                byte = blob[off]
                off += 1
                result |= (byte & 0x7F) << shift
                shift += 7
                if not (byte & 0x80):
                    return result, off

        def walk(off, prefix):
            term_size, p = uleb(off)
            if term_size:
                _flags, p2 = uleb(p)
                _addr, _p3 = uleb(p2)
                out.append(prefix)
                p = p + term_size
            else:
                p = off + 1 if blob[off] == 0 else p
                # when term_size==0, p already sits right after the 0 byte if encoded as single 0
                p = off + 1
            nchild = blob[p]
            p += 1
            for _ in range(nchild):
                end = blob.index(b"\x00", p)
                label = blob[p:end].decode("utf-8", "replace")
                child_off, _ = uleb(end + 1)
                walk(child_off, prefix + label)
                # advance past this child's label+offset: recompute
                _o, p = uleb(end + 1)
                p = end + 1 + (p - (end + 1)) + len(_uleb_bytes(blob, end + 1))
            return

        def _uleb_bytes(b, off):
            n = 0
            while b[off + n] & 0x80:
                n += 1
            return b[off:off + n + 1]

        # Simpler iterative re-walk to avoid bookkeeping bugs above:
        out.clear()

        def walk2(off, prefix):
            term_size, p = uleb(off)
            if term_size:
                out.append(prefix)
            p = off + 1 if term_size == 0 else p + term_size - 0  # children count location
            # children count is located after the terminal payload:
            if term_size:
                q = off
                _ts, q = uleb(q)
                q += term_size
                p = q
            else:
                p = off + 1
            nchild = blob[p]
            p += 1
            for _ in range(nchild):
                end = blob.index(b"\x00", p)
                label = blob[p:end].decode("utf-8", "replace")
                child_off, p2 = uleb(end + 1)
                walk2(child_off, prefix + label)
                p = p2

        try:
            walk2(0, "")
        except Exception as e:  # noqa: BLE001
            self.warnings.append(f"exports trie parse failed: {e}")
            return out
        return sorted(set(out))

    # ---------- ObjC structures ----------
    def parse_method_list(self, va):
        """Return list of {name, types, imp} or None."""
        if not va:
            return None
        hdr = self.read(va, 8)
        if hdr is None:
            return None
        entsize_flags, count = struct.unpack_from("<II", hdr)
        relative = bool(entsize_flags & 0x80000000)
        entsize = entsize_flags & 0x0000FFFC
        methods = []
        body = va + 8
        if relative:
            if entsize == 0:
                entsize = 12
            for i in range(count):
                eva = body + i * entsize
                raw = self.read(eva, 12)
                if raw is None:
                    break
                name_off, types_off, imp_off = struct.unpack_from("<iii", raw)
                # name: offset (from field addr) to a selref slot -> decode -> string
                sel = None
                slot_va = eva + name_off
                kind, val = self.ptr_at(slot_va)
                if kind == "ptr":
                    sel = self.read_cstr(val)
                if sel is None:
                    sel = self.read_cstr(slot_va)
                    if sel is not None:
                        self.warnings.append(f"relative method list @{va:#x}: direct-string fallback used")
                types = self.read_cstr(eva + 4 + types_off)
                imp = eva + 8 + imp_off
                methods.append({"name": sel, "types": types, "imp": imp})
        else:
            if entsize == 0:
                entsize = 24
            for i in range(count):
                eva = body + i * entsize
                _k1, name_va = self.ptr_field(eva, 0)
                _k2, types_va = self.ptr_field(eva, 1)
                _k3, imp_va = self.ptr_field(eva, 2)
                methods.append({
                    "name": self.read_cstr(name_va) if isinstance(name_va, int) else name_va,
                    "types": self.read_cstr(types_va) if isinstance(types_va, int) else types_va,
                    "imp": imp_va,
                })
        return methods

    def parse_ivars(self, va):
        if not va:
            return None
        hdr = self.read(va, 8)
        if hdr is None:
            return None
        entsize, count = struct.unpack_from("<II", hdr)
        if entsize == 0:
            entsize = 32
        out = []
        for i in range(count):
            eva = va + 8 + i * entsize
            _k, off_ptr = self.ptr_field(eva, 0)
            _k, name_va = self.ptr_field(eva, 1)
            _k, type_va = self.ptr_field(eva, 2)
            tail = self.read(eva + 24, 8)
            align, size = struct.unpack_from("<II", tail) if tail else (None, None)
            offset_val = self.read_u32(off_ptr) if isinstance(off_ptr, int) and off_ptr else None
            out.append({"name": self.read_cstr(name_va) if isinstance(name_va, int) else name_va,
                        "type": self.read_cstr(type_va) if isinstance(type_va, int) else type_va,
                        "offset": offset_val, "alignment": align, "size": size})
        return out

    def parse_properties(self, va):
        if not va:
            return None
        hdr = self.read(va, 8)
        if hdr is None:
            return None
        entsize, count = struct.unpack_from("<II", hdr)
        if entsize == 0:
            entsize = 16
        out = []
        for i in range(count):
            eva = va + 8 + i * entsize
            _k, name_va = self.ptr_field(eva, 0)
            _k, attr_va = self.ptr_field(eva, 1)
            out.append({"name": self.read_cstr(name_va) if isinstance(name_va, int) else name_va,
                        "attributes": self.read_cstr(attr_va) if isinstance(attr_va, int) else attr_va})
        return out

    def parse_protocol(self, va, depth=0):
        if not va or depth > 2:
            return None
        _k, name_va = self.ptr_field(va, 1)
        name = self.read_cstr(name_va) if isinstance(name_va, int) else name_va
        proto = {"name": name, "va": va}
        if depth == 0:
            for label, idx in (("instance_methods", 3), ("class_methods", 4),
                               ("optional_instance_methods", 5), ("optional_class_methods", 6)):
                k, ml_va = self.ptr_field(va, idx)
                proto[label] = self.parse_method_list(ml_va) if k == "ptr" and ml_va else None
            k, props_va = self.ptr_field(va, 7)
            proto["instance_properties"] = self.parse_properties(props_va) if k == "ptr" and props_va else None
            k, plist_va = self.ptr_field(va, 2)
            proto["adopted"] = self.parse_protocol_list(plist_va) if k == "ptr" and plist_va else None
        return proto

    def parse_protocol_list(self, va):
        if not va:
            return None
        cnt = self.read_u64(va)
        if cnt is None or cnt > 512:
            return None
        out = []
        for i in range(cnt):
            k, p_va = self.ptr_field(va + 8, i)
            if k == "ptr" and p_va:
                p = self.parse_protocol(p_va, depth=1)
                out.append(p["name"] if p else None)
            elif k == "bind":
                out.append(p_va)
        return out

    def class_name_at(self, class_va, seen=None):
        """Name of class struct at class_va (no deep parse)."""
        if seen is None:
            seen = set()
        if class_va in seen:
            return None
        seen.add(class_va)
        _k, data_va = self.ptr_field(class_va, 4)
        if not isinstance(data_va, int) or not data_va:
            return None
        ro_va = data_va & ~7
        _k, name_va = self.ptr_field(ro_va, 3)
        return self.read_cstr(name_va) if isinstance(name_va, int) else None

    def parse_class(self, class_va):
        """Full parse of a class + its metaclass (class methods)."""
        result = {"va": class_va}
        k, isa_va = self.ptr_field(class_va, 0)
        result["isa_kind"] = k
        k, super_va = self.ptr_field(class_va, 1)
        if k == "bind":
            result["superclass"] = super_va.replace("_OBJC_CLASS_$_", "") if isinstance(super_va, str) else super_va
            result["superclass_ref"] = "external"
        elif k == "ptr" and super_va:
            result["superclass"] = self.class_name_at(super_va)
            result["superclass_ref"] = "internal"
        else:
            result["superclass"] = None
        _k, data_va = self.ptr_field(class_va, 4)
        if not isinstance(data_va, int) or not data_va:
            result["error"] = "no class_ro"
            return result
        ro_va = data_va & ~7
        result.update(self._parse_class_ro(ro_va, is_meta=False))
        # metaclass for class methods/properties
        if isinstance(isa_va, int) and isa_va:
            _k, mdata_va = self.ptr_field(isa_va, 4)
            if isinstance(mdata_va, int) and mdata_va:
                meta = self._parse_class_ro(mdata_va & ~7, is_meta=True)
                result["class_methods"] = meta.get("methods")
                result["class_properties"] = meta.get("properties")
        return result

    def _parse_class_ro(self, ro_va, is_meta):
        out = {}
        hdr = self.read(ro_va, 16)
        if hdr is None:
            return out
        flags, istart, isize, _res = struct.unpack_from("<IIII", hdr)
        out["ro_flags"] = flags
        out["instance_start"] = istart
        out["instance_size"] = isize
        _k, name_va = self.ptr_field(ro_va, 3)
        if not is_meta:
            out["name"] = self.read_cstr(name_va) if isinstance(name_va, int) else name_va
        _k, ml_va = self.ptr_field(ro_va, 4)
        out["methods"] = self.parse_method_list(ml_va) if isinstance(ml_va, int) and ml_va else None
        _k, pl_va = self.ptr_field(ro_va, 5)
        if not is_meta:
            out["protocols"] = self.parse_protocol_list(pl_va) if isinstance(pl_va, int) and pl_va else None
        _k, iv_va = self.ptr_field(ro_va, 6)
        if not is_meta:
            out["ivars"] = self.parse_ivars(iv_va) if isinstance(iv_va, int) and iv_va else None
        _k, pr_va = self.ptr_field(ro_va, 8)
        out["properties"] = self.parse_properties(pr_va) if isinstance(pr_va, int) and pr_va else None
        return out

    def parse_objc(self):
        objc = {"imageinfo": None, "classes": [], "categories": [], "protocols": [],
                "classrefs": [], "selrefs": []}
        s, b = self.section_bytes("__DATA_CONST", "__objc_imageinfo")
        if b is None:
            s, b = self.section_bytes("__DATA", "__objc_imageinfo")
        if b and len(b) >= 8:
            ver, flags = struct.unpack_from("<II", b)
            objc["imageinfo"] = {"version": ver, "flags": flags}
        # classes
        for segname in ("__DATA_CONST", "__DATA"):
            s, b = self.section_bytes(segname, "__objc_classlist")
            if b:
                n = len(b) // 8
                for i in range(n):
                    k, class_va = self.decode_ptr(struct.unpack_from("<Q", b, i * 8)[0], s["addr"] + i * 8)
                    if k == "ptr" and class_va:
                        objc["classes"].append(self.parse_class(class_va))
                break
        # categories
        for segname in ("__DATA_CONST", "__DATA"):
            s, b = self.section_bytes(segname, "__objc_catlist")
            if b:
                n = len(b) // 8
                for i in range(n):
                    k, cat_va = self.decode_ptr(struct.unpack_from("<Q", b, i * 8)[0], s["addr"] + i * 8)
                    if k != "ptr" or not cat_va:
                        continue
                    cat = {}
                    _k, name_va = self.ptr_field(cat_va, 0)
                    cat["name"] = self.read_cstr(name_va) if isinstance(name_va, int) else name_va
                    ck, cls_va = self.ptr_field(cat_va, 1)
                    if ck == "bind":
                        cat["target"] = cls_va.replace("_OBJC_CLASS_$_", "") if isinstance(cls_va, str) else cls_va
                    elif ck == "ptr" and cls_va:
                        cat["target"] = self.class_name_at(cls_va)
                    _k, im_va = self.ptr_field(cat_va, 2)
                    cat["instance_methods"] = self.parse_method_list(im_va) if isinstance(im_va, int) and im_va else None
                    _k, cm_va = self.ptr_field(cat_va, 3)
                    cat["class_methods"] = self.parse_method_list(cm_va) if isinstance(cm_va, int) and cm_va else None
                    _k, pl_va = self.ptr_field(cat_va, 4)
                    cat["protocols"] = self.parse_protocol_list(pl_va) if isinstance(pl_va, int) and pl_va else None
                    _k, ip_va = self.ptr_field(cat_va, 5)
                    cat["instance_properties"] = self.parse_properties(ip_va) if isinstance(ip_va, int) and ip_va else None
                    objc["categories"].append(cat)
                break
        # protocols defined
        for segname in ("__DATA_CONST", "__DATA"):
            s, b = self.section_bytes(segname, "__objc_protolist")
            if b:
                n = len(b) // 8
                for i in range(n):
                    k, p_va = self.decode_ptr(struct.unpack_from("<Q", b, i * 8)[0], s["addr"] + i * 8)
                    if k == "ptr" and p_va:
                        objc["protocols"].append(self.parse_protocol(p_va))
                break
        # classrefs
        for segname in ("__DATA", "__DATA_CONST"):
            s, b = self.section_bytes(segname, "__objc_classrefs")
            if b:
                n = len(b) // 8
                for i in range(n):
                    k, v = self.decode_ptr(struct.unpack_from("<Q", b, i * 8)[0], s["addr"] + i * 8)
                    if k == "bind":
                        objc["classrefs"].append({"name": v.replace("_OBJC_CLASS_$_", "") if isinstance(v, str) else v, "external": True})
                    elif k == "ptr" and v:
                        objc["classrefs"].append({"name": self.class_name_at(v), "external": False})
                break
        # selrefs
        for segname in ("__DATA", "__DATA_CONST"):
            s, b = self.section_bytes(segname, "__objc_selrefs")
            if b:
                n = len(b) // 8
                sels = set()
                for i in range(n):
                    k, v = self.decode_ptr(struct.unpack_from("<Q", b, i * 8)[0], s["addr"] + i * 8)
                    if k == "ptr" and v:
                        sel = self.read_cstr(v)
                        if sel:
                            sels.add(sel)
                    elif k == "bind" and isinstance(v, str):
                        sels.add(v)
                objc["selrefs"] = sorted(sels)
                break
        return objc


def main():
    path = sys.argv[1]
    data = open(path, "rb").read()
    out = {"file": path, "size": len(data), "slices": []}
    for cpu, off, size in split_fat(data):
        scan = parse_slice(data, off)
        scan["slice_cpu"] = cpu
        scan["slice_offset"] = off
        scan["slice_size"] = size
        sl = Slice(data[off:off + size], scan)
        entry = {
            "cpu": cpu,
            "slice_offset": off,
            "slice_size": size,
            "pointer_formats": {str(k): v for k, v in sl.seg_ptr_format.items()},
            "imports_count": len(sl.imports),
            "imports": sl.imports,
            "symbols": sl.symbols,
            "exports": sl.exports,
            "objc": sl.parse_objc(),
            "warnings": sl.warnings,
        }
        out["slices"].append(entry)
    json.dump(out, sys.stdout, indent=1)


if __name__ == "__main__":
    main()
