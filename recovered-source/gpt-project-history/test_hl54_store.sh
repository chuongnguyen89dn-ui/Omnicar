#!/bin/sh
# Host-only fault/rollback tests for the HL54 owner writer (not iOS build/device proof).
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HERE/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
${CC:-clang} -std=c11 -Wall -Wextra -Werror -D_GNU_SOURCE \
  -fsanitize=address,undefined -fno-omit-frame-pointer -g \
  -I"$ROOT/project/OmniCarLeExtension" \
  "$ROOT/project/OmniCarLeExtension/DCLLeStateWriter.c" \
  "$HERE/tests/test_hl54_store.c" -o "$TMP/hl54-store"
"$TMP/hl54-store"
