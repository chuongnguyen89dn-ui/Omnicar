#!/usr/bin/env python3
"""Safely test assembly control/guard logic WITHOUT an original OmniCar package."""
from pathlib import Path
from tempfile import TemporaryDirectory
import importlib.util

path=Path("scripts/assemble_unified_omnicar.py")
spec=importlib.util.spec_from_file_location("omnicar_assembler",path)
m=importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)

original = ("Package: com.anlai.omnicar\n"
    "Name: Original OmniCar\nVersion: 1.0.3\nArchitecture: iphoneos-arm64\n"
    "Depends: mobilesubstrate\nDescription: original payload preserved\n")
adjusted=m.update_control(original)
assert "Package: com.anlai.omnicar" in adjusted
assert "Version: 1.0.3-omnicar4" in adjusted
assert "Depends: mobilesubstrate" in adjusted
assert "Description: original payload preserved" in adjusted
assert "Conflicts: " in adjusted
for obsolete in m.OBSOLETE_ADDONS:
    assert obsolete in adjusted,obsolete
assert m.VERSION=="1.0.3-omnicar4"
assert len(m.MODULES)==4
assert {t[0] for t in m.MODULES}=={
"OmniCarDoubleTapFullscreen","OmniCarIdleControls","OmniCarSoloThreeDots","OmniCarGraphiteTitanium"}
try:
    m.update_control(original.replace("Version: 1.0.3","Version: 1.0.4"))
except ValueError:
    pass
else:
    raise AssertionError("unverified base version accepted")
with TemporaryDirectory() as d:
    d=Path(d)
    fake=d/"fake_omnicar.deb"
    fake.write_bytes(b"not the correct original package")
    try:
        m.assemble(fake,Path("."),d/"output.deb")
    except ValueError as e:
        assert "SHA256 MISMATCH" in str(e),str(e)
    else:
        raise AssertionError("fake original package was accepted")
    assert not (d/"output.deb").exists()
    # Theos output includes two real dylibs + a dSYM DWARF mirror.
    # Only the post-link/sign at obj/debug/<name>.dylib is eligible.
    root=d/"build"
    name="OmniCarDoubleTapFullscreen"
    signed=root/".theos"/"obj"/"debug"/(name+".dylib")
    intermediate=root/".theos"/"obj"/"debug"/"arm64"/(name+".dylib")
    dwarf=root/".theos"/"obj"/"debug"/"arm64"/(name+".dylib.dSYM")/"Contents"/"Resources"/"DWARF"/(name+".dylib")
    for candidate in (signed,intermediate,dwarf):
        candidate.parent.mkdir(parents=True,exist_ok=True)
        candidate.write_bytes(b"synthetic-native-dylib" * 300)
    assert m.choose_signed_dylib(root,Path("."),name)==signed
    signed.unlink()
    try:
        m.choose_signed_dylib(root,Path("."),name)
    except ValueError as err:
        assert "ONE final signed" in str(err)
    else:
        raise AssertionError("selected intermediate or dSYM without final signed dylib")
print("UNIFIED_ASSEMBLER_STATIC_PASS__WRONG_ORIGINAL_REJECTED__NO_DEB_BUILT")
