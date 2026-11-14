#!/bin/sh
# HL54 source + host-C gates; does NOT compile iOS/UIKit or test on a car.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
cc -std=c11 -Wall -Wextra -Werror -pedantic \
  -I"$ROOT/project/OmniCarLeTraffic" \
  "$ROOT/project/OmniCarLeTraffic/DCLTrafficCore.c" \
  "$ROOT/gpt-project-history/tests/test_le_traffic_core.c" \
  -lm -o "$TMP/hl54-gps-core"
"$TMP/hl54-gps-core"
python3 "$ROOT/gpt-project-history/verify_hl54_gps_slider.py"
