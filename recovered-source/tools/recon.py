import sys, json, struct
sys.path.insert(0, 'metadata/tools')
from macho_scan import split_fat, parse_slice
from macho_objc import Slice

for name in ('OmniCarStartupScreen','OmniCarCarProbe'):
    path = f'payload/var/jb/Library/MobileSubstrate/DynamicLibraries/{name}.dylib'
    data = open(path,'rb').read()
    for cpu, off, size in split_fat(data):
        if cpu != 'arm64': continue
        scan = parse_slice(data, off)
        sl = Slice(data[off:off+size], scan)
        print(f"===== {name} (arm64) fmt={sl.seg_ptr_format} default={sl.default_fmt}")
        for (seg,sec),s in sorted(sl.sections.items(), key=lambda kv: kv[1]['addr']):
            print(f"  {seg},{sec} addr={s['addr']:#x} size={s['size']} off={s['offset']}")
        # mod_init_func
        for segname in ('__DATA_CONST','__DATA','__DATA_DIRTY'):
            s,b = sl.section_bytes(segname,'__mod_init_func')
            if b:
                print(f"  __mod_init_func in {segname}: {len(b)//8} entries")
                for i in range(len(b)//8):
                    k,v = sl.decode_ptr(struct.unpack_from('<Q',b,i*8)[0], s['addr']+i*8)
                    print(f"    init[{i}] -> {k} {v if isinstance(v,str) else hex(v)}")
        # stub size probe
        s,b = sl.section_bytes('__TEXT','__objc_stubs')
        if b:
            print(f"  __objc_stubs: {len(b)} bytes; first 64 bytes: {b[:64].hex()}")
        s,b = sl.section_bytes('__TEXT','__stubs')
        if b:
            print(f"  __stubs: {len(b)} bytes ({len(b)/12 if len(b)%12==0 else len(b)/16} entries guess)")
