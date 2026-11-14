#!/usr/bin/env python3
"""Reconstruct DuoCar Purple Horizon original design ZIP, verifying every chunk."""
from pathlib import Path
import hashlib
import json
import os
import sys
import zipfile

here = Path(__file__).resolve().parent
manifest = json.loads((here / "manifest.json").read_text(encoding="utf-8"))
out = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 else here.parent / manifest["filename"]
out.parent.mkdir(parents=True, exist_ok=True)
temporary = out.with_name(out.name + ".partial")
hasher = hashlib.sha256()
total = 0
with temporary.open("wb") as dest:
    for n, part in enumerate(manifest["parts"]):
        p = here / part["file"]
        body = p.read_bytes()
        assert len(body) == part["size"], f"Size mismatch: {p.name}"
        gitblob = hashlib.sha1(b"blob " + str(len(body)).encode("ascii") + bytes([0]) + body).hexdigest()
        assert gitblob == part["git_blob_sha1"], f"Git blob mismatch: {p.name}"
        dest.write(body)
        hasher.update(body)
        total += len(body)
    dest.flush()
    os.fsync(dest.fileno())
assert total == manifest["total_size"], f"Wrong ZIP size: {total}"
assert hasher.hexdigest() == manifest["sha256"], f"ZIP SHA-256 mismatch: {hasher.hexdigest()}"
assert zipfile.is_zipfile(temporary), "Reassembled file is not a valid ZIP"
with zipfile.ZipFile(temporary) as zf:
    assert zf.testzip() is None, "ZIP CRC failed"
os.replace(temporary,out)
print(f"OK {out}: {total} bytes, SHA-256 {hasher.hexdigest()}")
