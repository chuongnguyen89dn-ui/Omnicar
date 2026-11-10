import hashlib
import pathlib
import struct
import subprocess
import sys
from tempfile import TemporaryDirectory

if len(sys.argv) != 2:
    raise SystemExit('usage: python3 verify_hl13_deb.py <path.deb>')
p = pathlib.Path(sys.argv[1])
assert p.is_file() and p.stat().st_size > 100000, 'No verified DEB file'
sha = hashlib.sha256(p.read_bytes()).hexdigest()
fields = subprocess.check_output(['dpkg-deb', '--field', str(p), 'Package', 'Version', 'Architecture'], text=True)
assert 'com.anlai.omnicar' in fields
assert '1.0.3-hl13pinch' in fields, fields
assert 'iphoneos-arm64' in fields, fields

names = ['OmniCarCore', 'OmniCarAppBridge', 'OmniCarCarProbe', 'OmniCarSpeedBubble', 'OmniCarSplitScreen', 'OmniCarStartupScreen']

def parse_fat(data):
    magic = struct.unpack_from('>I', data)[0]
    assert magic in (0xcafebabe, 0xcafebabf), f'FAT header bad: {magic:#x}'
    n = struct.unpack_from('>I', data, 4)[0]
    assert n >= 2
    is64 = magic == 0xcafebabf
    recsize = 32 if is64 else 20
    archs = []
    for i in range(n):
        off = 8 + recsize*i
        if is64:
            cputype, subtype, offset, size, align, reserved = struct.unpack_from('>IIQQII', data, off)
        else:
            cputype, subtype, offset, size, align = struct.unpack_from('>IIIII', data, off)
        if cputype != 0x100000c:
            continue
        assert 0 < offset and size > 1000 and offset+size <= len(data)
        blob = data[offset:offset+size]
        assert blob[:4] == b'\xcf\xfa\xed\xfe', 'not MH_MAGIC_64'
        ncmds, sizeofcmds = struct.unpack_from('<II', blob, 16)
        cursor = 32
        signed = False
        for _ in range(ncmds):
            cmd, cmdsize = struct.unpack_from('<II', blob, cursor)
            assert cmdsize >= 8 and cursor+cmdsize <= len(blob)
            if cmd == 0x1d:
                dataoff, datasize = struct.unpack_from('<II', blob, cursor + 8)
                signed = bool(datasize and dataoff+datasize <= len(blob))
            cursor += cmdsize
        archs.append((subtype & 0xff, signed, blob))
    assert {subtype for subtype,signed,blob in archs} == {0,2}, f'wrong ARM64 subtypes: {[x[0] for x in archs]}'
    return archs

with TemporaryDirectory(prefix='hl13-verify-') as d:
    subprocess.check_call(['dpkg-deb', '--extract', str(p), d])
    root = pathlib.Path(d)/'var/jb/Library/MobileSubstrate/DynamicLibraries'
    for dylib in names:
        path = root/(dylib+'.dylib')
        assert path.exists(), path
        archs = parse_fat(path.read_bytes())
        for subtype, signed, blob in archs:
            assert signed, f'unsigned {dylib} subtype={subtype}'
            if dylib == 'OmniCarAppBridge':
                for marker in [b'[hl11kb]', b'ev=native-fit', b'ev=restore', b'ev=reload-input-views', b'[hl8diag]', b'[pinch2] trigger=began toggle-sent dir=0']:
                    assert marker in blob, f'AppBridge {subtype} missing marker {marker}'
            if dylib == 'OmniCarSplitScreen':
                for marker in [b'[hl8diag]', b'native-logo-owned', b'fs-hidden-save', b'fs-hidden-restore', b'ev=picker-host', b'ev=shield-host', b'dock-category', b'dock-readback', b'dock-tap', b'dock-lifecycle', b'active-model', b'dock-category-not-other', b'[hl13pinch]', b'route=inapp-hosted', b'route=split-hosted-owners', b'hostedPinchFallback']:
                    assert marker in blob, f'SplitScreen {subtype} missing marker {marker}'
        print(f'{dylib}: arm64+arm64e, signed, markers checked')
print('Package/Version/Architecture:\n' + fields.strip())
print('Filename:', p.name)
print('Size:', p.stat().st_size)
print('SHA256:', sha)
print('RESULT: artifact structure PASS; car UI/ABI runtime not proven')
