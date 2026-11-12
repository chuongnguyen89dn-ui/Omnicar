#!/bin/sh
# Build ONE ARM64 DEB on an existing Theos+iPhoneOS SDK+ldid VM. No GitHub CI.
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT="$ROOT/project"
THEOS="$HOME/theos"
export THEOS
export THEOS_PACKAGE_SCHEME=rootless
export ARCHS=arm64
if [ ! -f "$THEOS/makefiles/common.mk" ]; then
  echo "BLOCKED: Theos missing at $THEOS" >&2
  exit 2
fi
if [ ! -d "$THEOS/sdks" ] || [ -z "$(find "$THEOS/sdks" -maxdepth 2 -type d -name 'iPhoneOS*.sdk' -print -quit)" ]; then
  echo "BLOCKED: iPhoneOS SDK missing" >&2
  exit 2
fi
if ! command -v ldid >/dev/null 2>&1; then
  if [ -z "$(find "$THEOS" -maxdepth 7 -type f -name ldid -print -quit)" ]; then
    echo "BLOCKED: ldid signing tool missing" >&2
    exit 2
  fi
fi
python3 "$SCRIPT_DIR/verify_hl40_drawn_all.py"
python3 "$SCRIPT_DIR/rebrand_duocar.py"
make -C "$PROJECT" clean
make -C "$PROJECT" package FINALPACKAGE=1
DEB="$PROJECT/packages/com.chuong.duocar_1.0.3-hl40drawall1_iphoneos-arm64.deb"
if [ ! -f "$DEB" ]; then
  echo "BLOCKED: arm64 DEB not produced: $DEB" >&2
  exit 3
fi
python3 "$SCRIPT_DIR/verify_duocar_payload.py" "$DEB"
sha256sum "$DEB"
printf 'READY_FOR_DEVICE_TEST %s\n' "$DEB"
