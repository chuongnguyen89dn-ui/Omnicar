#!/bin/sh
# Cross-platform directional pinch guard; no iOS SDK required.
set -eu
cd "$(dirname "$0")/../.."
out="$(mktemp "${TMPDIR:-/tmp}/hl53-pinch.XXXXXX")"
trap 'rm -f "$out"' EXIT HUP INT TERM
cc -std=c11 -Wall -Wextra -Werror -pedantic \
  gpt-project-history/tests/test_hl53_pinch_direction.c -lm -o "$out"
"$out"
