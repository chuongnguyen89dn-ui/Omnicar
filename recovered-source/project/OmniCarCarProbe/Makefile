# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OmniCarCarProbe
OmniCarCarProbe_FILES = OmniCarCarProbe.m
OmniCarCarProbe_CFLAGS = -fobjc-arc
# Phase 1: the reconstruction deliberately calls performSelector: with
# runtime-built selectors (OMCCarLaunchInfo); keep the ARC leak analysis
# as a warning instead of an error.
OmniCarCarProbe_CFLAGS += -Wno-error=arc-performSelector-leaks
# Phase 1: four static libroot-fallback helpers in the TU are unused in
# this binary's copy (kept for parity with the shared core text).
OmniCarCarProbe_CFLAGS += -Wno-error=unused-function
OmniCarCarProbe_LDFLAGS = -fuse-ld=lld
# PHASE-1 DEVIATION (see BUILD_PHASE1_LOG.md, BLOCKER-CORE-CARPROBE):
# src/CarProbe/OmniCarCarProbe.m is a single translation unit that embeds
# its own copy of the OMC core, so the shared unit is NOT appended here
# (appending it would duplicate ~21 symbols at link). Dedupe = phase 2.

include $(THEOS_MAKE_PATH)/tweak.mk
