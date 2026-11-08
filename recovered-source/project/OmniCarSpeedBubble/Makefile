# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OmniCarSpeedBubble
# SBOpenCar.m is EXCLUDED from _FILES (phase 2): after the phase-2 dedupe it is a
# pointer note defining nothing — the canonical __init_0 / opencar constructor lives
# in SPPDisplayBoot.m (SPPDisplayInitCarPlay + SPPHandleOpenCarNotification). Keeping
# it in _FILES would only compile an empty TU; the file stays on disk so the module
# file list / partition record stays intact (see src/SpeedBubble/REPORT_A.md phase-2 §2).
OmniCarSpeedBubble_FILES = SBFlutter.m SBPublish.m SBScan.m SBScanHelpers.m SBSourceHooks.m SPPBubble.m SPPBubbleView.m SPPDisplayBoot.m SPPOverspeed.m SPPPrefs.m SPPSpeedGPS.m SPPViews.m SPPWarningSound.m SPPWindowFactory.m SBIntegrationTables.m
OmniCarSpeedBubble_CFLAGS = -fobjc-arc
OmniCarSpeedBubble_CFLAGS += -DOMC_MODULE_NAME='"SpeedBubble"'
# Phase 1 integration: private-selector shims + ARC performSelector
# analysis demoted (the reconstruction deliberately sends runtime-built
# selectors; same treatment as CarProbe).
OmniCarSpeedBubble_CFLAGS += -include SBIntegrationShims.h
OmniCarSpeedBubble_CFLAGS += -Wno-error=arc-performSelector-leaks
# Phase 2: SPPGlassView's custom -setCorner: (reconstructed, INFERRED body)
# writes layer.cornerRadius, not the _corner ivar backing the synthesized
# -corner getter added in the @property census — demote, do not rewrite it.
OmniCarSpeedBubble_CFLAGS += -Wno-error=unused-property-ivar
OmniCarSpeedBubble_LDFLAGS = -fuse-ld=lld
OMC_TARGET_NAME = OmniCarSpeedBubble
include ../OMCCommon/OMCCommon.mk

include $(THEOS_MAKE_PATH)/tweak.mk
