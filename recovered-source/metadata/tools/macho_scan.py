#!/usr/bin/env python3
"""macho_scan.py - stage 1: fat split, load-command + section + symtab inventory.

Pure stdlib. Usage: macho_scan.py <macho-file>
Prints JSON describing each slice: header, load commands (decoded subset),
sections, and symbol counts. Load-command constants per <mach-o/loader.h>.
"""
import json
import struct
import sys

MH_MAGIC_64 = 0xFEEDFACF
LC_REQ_DYLD = 0x80000000

LC_NAMES = {
    0x1: "LC_SEGMENT", 0x2: "LC_SYMTAB", 0x3: "LC_SYMSEG", 0x4: "LC_THREAD",
    0x5: "LC_UNIXTHREAD", 0x6: "LC_LOADFVMLIB", 0x7: "LC_IDFVMLIB", 0x8: "LC_IDENT",
    0x9: "LC_FVMFILE", 0xA: "LC_PREPAGE", 0xB: "LC_DYSYMTAB", 0xC: "LC_LOAD_DYLIB",
    0xD: "LC_ID_DYLIB", 0xE: "LC_LOAD_DYLINKER", 0xF: "LC_ID_DYLINKER",
    0x10: "LC_PREBOUND_DYLIB", 0x11: "LC_ROUTINES", 0x12: "LC_SUB_FRAMEWORK",
    0x13: "LC_SUB_UMBRELLA", 0x14: "LC_SUB_CLIENT", 0x15: "LC_SUB_LIBRARY",
    0x16: "LC_TWOLEVEL_HINTS", 0x17: "LC_PREBIND_CKSUM", 0x18: "LC_LOAD_WEAK_DYLIB",
    0x19: "LC_SEGMENT_64", 0x1A: "LC_ROUTINES_64", 0x1B: "LC_UUID",
    0x1C: "LC_RPATH", 0x1D: "LC_CODE_SIGNATURE", 0x1E: "LC_SEGMENT_SPLIT_INFO",
    0x1F: "LC_REEXPORT_DYLIB", 0x20: "LC_LAZY_LOAD_DYLIB", 0x21: "LC_ENCRYPTION_INFO",
    0x22: "LC_DYLD_INFO", 0x23: "LC_LOAD_UPWARD_DYLIB", 0x24: "LC_VERSION_MIN_MACOSX",
    0x25: "LC_VERSION_MIN_IPHONEOS", 0x26: "LC_FUNCTION_STARTS",
    0x27: "LC_DYLD_ENVIRONMENT", 0x28: "LC_MAIN", 0x29: "LC_DATA_IN_CODE",
    0x2A: "LC_SOURCE_VERSION", 0x2B: "LC_DYLIB_CODE_SIGN_DRS",
    0x2C: "LC_ENCRYPTION_INFO_64", 0x2D: "LC_LINKER_OPTION",
    0x2E: "LC_LINKER_OPTIMIZATION_HINT", 0x2F: "LC_VERSION_MIN_TVOS",
    0x30: "LC_VERSION_MIN_WATCHOS", 0x31: "LC_NOTE", 0x32: "LC_BUILD_VERSION",
    0x33: "LC_DYLD_EXPORTS_TRIE", 0x34: "LC_DYLD_CHAINED_FIXUPS", 0x35: "LC_FILESET_ENTRY",
}
FILETYPES = {1: "OBJECT", 2: "EXECUTE", 6: "DYLIB", 8: "BUNDLE"}


def u32(b, o):
    return struct.unpack_from("<I", b, o)[0]


def cstr(b, o, maxlen=4096):
    end = b.find(b"\x00", o, o + maxlen)
    if end < 0:
        end = o + maxlen
    return b[o:end].decode("utf-8", "replace")


def cpu_name(cputype, subtype):
    if cputype == 0x0100000C:  # CPU_TYPE_ARM64; subtype may carry LIB64/caps bits
        st = subtype & 0x00FFFFFF
        if st == 2:
            return "arm64e"
        if st == 1:
            return "arm64_v8"
        return "arm64"
    if cputype == 0x01000007:
        return "x86_64"
    return hex(cputype)


def split_fat(data):
    """Yield (cpu_name, offset, size) slices."""
    magic_be = struct.unpack_from(">I", data, 0)[0]
    if magic_be in (0xCAFEBABE, 0xCAFEBABF):
        is64 = magic_be == 0xCAFEBABF
        n = struct.unpack_from(">I", data, 4)[0]
        off = 8
        out = []
        for _ in range(n):
            if is64:
                cputype, subtype, offset, size, align, _res = struct.unpack_from(">IIQQII", data, off)
                off += 32
            else:
                cputype, subtype, offset, size, align = struct.unpack_from(">IIIII", data, off)
                off += 20
            out.append((cpu_name(cputype, subtype), offset, size))
        return out
    return [("thin", 0, len(data))]


def parse_slice(data, base):
    """Parse one Mach-O 64 slice starting at file offset `base`."""
    magic = u32(data, base)
    assert magic == MH_MAGIC_64, f"not MH_MAGIC_64: {magic:#x}"
    (cputype, subtype, filetype, ncmds, _sizeofcmds, _flags, _res) = struct.unpack_from("<IiiIIII", data, base + 4)
    info = {
        "cpu": cpu_name(cputype, subtype),
        "filetype": FILETYPES.get(filetype, str(filetype)),
        "ncmds": ncmds,
        "load_commands": [],
        "sections": [],
        "dylibs": [],
        "rpaths": [],
        "id_dylib": None,
        "uuid": None,
        "minos": None,
        "sdk": None,
        "encryption": None,
        "code_signature": None,
        "has_chained_fixups": False,
        "has_dyld_info": False,
        "dyld_info": None,
        "exports_trie": False,
        "symtab": None,
        "image_base": None,
    }
    off = base + 32
    for _ in range(ncmds):
        cmd, cmdsize = struct.unpack_from("<II", data, off)
        base_cmd = cmd & ~LC_REQ_DYLD
        name = LC_NAMES.get(base_cmd, hex(cmd))
        entry = {"cmd": name + ("|REQ_DYLD" if cmd & LC_REQ_DYLD else "")}
        if base_cmd == 0x19:  # LC_SEGMENT_64
            segname = data[off + 8:off + 24].split(b"\x00")[0].decode()
            vmaddr, vmsize, fileoff, filesize, _maxp, _initp, nsects, _sflags = struct.unpack_from("<QQQQiiII", data, off + 24)
            entry.update({"segname": segname, "vmaddr": vmaddr, "vmsize": vmsize,
                          "fileoff": fileoff, "filesize": filesize, "nsects": nsects})
            if info["image_base"] is None and segname == "__TEXT":
                info["image_base"] = vmaddr
            soff = off + 72
            for _i in range(nsects):
                sname = data[soff:soff + 16].split(b"\x00")[0].decode()
                sgname = data[soff + 16:soff + 32].split(b"\x00")[0].decode()
                addr, size, offset, _al, _reloff, _nreloc, sflags, _r1, _r2, _r3 = struct.unpack_from("<QQIIIIIIII", data, soff + 32)
                info["sections"].append({"seg": sgname, "name": sname, "addr": addr,
                                         "size": size, "offset": offset, "flags": sflags})
                soff += 80
        elif base_cmd in (0xC, 0x18, 0x1F, 0x20, 0x23):  # dylib-ish loads
            stroff = u32(data, off + 8)
            _ts, cur, compat = struct.unpack_from("<III", data, off + 12)
            info["dylibs"].append({"cmd": name, "name": cstr(data, off + stroff),
                                   "current_version": f"{cur >> 16}.{(cur >> 8) & 0xFF}.{cur & 0xFF}",
                                   "compat_version": f"{compat >> 16}.{(compat >> 8) & 0xFF}.{compat & 0xFF}"})
        elif base_cmd == 0xD:  # LC_ID_DYLIB
            stroff = u32(data, off + 8)
            _ts, cur, compat = struct.unpack_from("<III", data, off + 12)
            info["id_dylib"] = {"name": cstr(data, off + stroff),
                                "current_version": f"{cur >> 16}.{(cur >> 8) & 0xFF}.{cur & 0xFF}",
                                "compat_version": f"{compat >> 16}.{(compat >> 8) & 0xFF}.{compat & 0xFF}"}
        elif base_cmd == 0x1B:  # LC_UUID
            raw = data[off + 8:off + 24]
            h = raw.hex()
            info["uuid"] = f"{h[0:8]}-{h[8:12]}-{h[12:16]}-{h[16:20]}-{h[20:32]}".upper()
        elif base_cmd == 0x32:  # LC_BUILD_VERSION
            platform, minos, sdk, _ntools = struct.unpack_from("<IIII", data, off + 8)
            info["minos"] = f"{minos >> 16}.{(minos >> 8) & 0xFF}.{minos & 0xFF}"
            info["sdk"] = f"{sdk >> 16}.{(sdk >> 8) & 0xFF}.{sdk & 0xFF}"
            entry["platform"] = platform
        elif base_cmd == 0x25:  # LC_VERSION_MIN_IPHONEOS
            ver, sdk = struct.unpack_from("<II", data, off + 8)
            info["minos"] = f"{ver >> 16}.{(ver >> 8) & 0xFF}.{ver & 0xFF}"
            info["sdk"] = f"{sdk >> 16}.{(sdk >> 8) & 0xFF}.{sdk & 0xFF}"
        elif base_cmd == 0x2C:  # LC_ENCRYPTION_INFO_64
            coff, csize, cid, _pad = struct.unpack_from("<IIII", data, off + 8)
            info["encryption"] = {"cryptoff": coff, "cryptsize": csize, "cryptid": cid}
        elif base_cmd == 0x21:  # LC_ENCRYPTION_INFO
            coff, csize, cid = struct.unpack_from("<III", data, off + 8)
            info["encryption"] = {"cryptoff": coff, "cryptsize": csize, "cryptid": cid}
        elif base_cmd == 0x1C:  # LC_RPATH
            stroff = u32(data, off + 8)
            entry["path"] = cstr(data, off + stroff)
            info["rpaths"].append(entry["path"])
        elif base_cmd == 0x22:  # LC_DYLD_INFO / LC_DYLD_INFO_ONLY
            info["has_dyld_info"] = True
            vals = struct.unpack_from("<10I", data, off + 8)
            info["dyld_info"] = {"rebase_off": vals[0], "rebase_size": vals[1],
                                 "bind_off": vals[2], "bind_size": vals[3],
                                 "weak_bind_off": vals[4], "weak_bind_size": vals[5],
                                 "lazy_bind_off": vals[6], "lazy_bind_size": vals[7],
                                 "export_off": vals[8], "export_size": vals[9]}
        elif base_cmd == 0x34:  # LC_DYLD_CHAINED_FIXUPS
            info["has_chained_fixups"] = True
            doff, dsize = struct.unpack_from("<II", data, off + 8)
            entry["dataoff"] = doff
            entry["datasize"] = dsize
        elif base_cmd == 0x33:  # LC_DYLD_EXPORTS_TRIE
            info["exports_trie"] = True
            doff, dsize = struct.unpack_from("<II", data, off + 8)
            entry["dataoff"] = doff
            entry["datasize"] = dsize
        elif base_cmd == 0x2:  # LC_SYMTAB
            symoff, nsyms, stroff, strsize = struct.unpack_from("<IIII", data, off + 8)
            info["symtab"] = {"symoff": symoff, "nsyms": nsyms, "stroff": stroff, "strsize": strsize}
        elif base_cmd == 0x1D:  # LC_CODE_SIGNATURE
            doff, dsize = struct.unpack_from("<II", data, off + 8)
            info["code_signature"] = {"dataoff": doff, "datasize": dsize}
        info["load_commands"].append(entry)
        off += cmdsize
    if info["symtab"]:
        st = info["symtab"]
        defined = undef = local = 0
        for i in range(st["nsyms"]):
            so = base + st["symoff"] + i * 16
            _n_strx, n_type, _n_sect, _n_desc, _n_value = struct.unpack_from("<IBBHQ", data, so)
            if n_type & 0x0E == 0x0:
                undef += 1
            else:
                defined += 1
            if not (n_type & 0x01):
                local += 1
        info["sym_counts"] = {"total": st["nsyms"], "defined": defined, "undefined": undef, "local": local}
    return info


def main():
    path = sys.argv[1]
    data = open(path, "rb").read()
    out = {"file": path, "size": len(data), "slices": []}
    for cpu, off, size in split_fat(data):
        s = parse_slice(data, off)
        s["slice_cpu"] = cpu
        s["slice_offset"] = off
        s["slice_size"] = size
        out["slices"].append(s)
    json.dump(out, sys.stdout, indent=1)


if __name__ == "__main__":
    main()
