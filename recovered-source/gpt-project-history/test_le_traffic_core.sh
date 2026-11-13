#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
ROOT="project/OmniCarLeTraffic"
clang -std=c11 -Wall -Wextra -Werror -I"$ROOT" "$ROOT/DCLTrafficCore.c" \
  gpt-project-history/tests/test_le_traffic_core.c -lm -o /tmp/test-le-traffic-core
/tmp/test-le-traffic-core
