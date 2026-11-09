# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OmniCarAppBridge
OmniCarAppBridge_FILES = ABChannels.m ABChannelNames.m ABHostLaunch.m ABChromeViews.m ABHostBMethods.m ABHostGeometry.m ABInApp.m ABKeyboard.m ABTelex.m AppBridgeEntry.m ABPane.m ABMissingSelector.m ABYTZoom.m
# Phase 2 file notes:
# - ABChannelNames.m is module B's ABChannels.m (the channel-name
#   constants TU), renamed in this project copy only: module A's
#   ABChannels.m (handlers/bootstrap TU) keeps the basename.
# - OMCCore.m is present in this directory but deliberately NOT in
#   _FILES: it is module A's local copy of the OMC core; the shared unit
#   (../OMCCommon/OMCCommon.c, appended by OMCCommon.mk) is the one
#   built. Its logic disagreements with the shared unit are listed in
#   BUILD_PHASE1_LOG.md (BLOCKER-CORE-APPBRIDGE). ABMissingSelector,
#   which A had parked inside OMCCore.m, is built from its own extracted
#   TU (ABMissingSelector.m, module B phase 2).
OmniCarAppBridge_CFLAGS = -fobjc-arc
OmniCarAppBridge_CFLAGS += -DOMC_MODULE_NAME='"AppBridge"'
# Phase 1 integration: shims header (NSDistributedNotificationCenter) +
# demote reconstruction-style warnings that Theos' -Werror promotes.
# -Wincomplete-implementation: ABHost's methods are split across two
# @implementation blocks (module A file + module B file) by design.
OmniCarAppBridge_CFLAGS += -include ABIntegrationShims.h
OmniCarAppBridge_CFLAGS += -Wno-error=format -Wno-error=nonnull -Wno-error=incompatible-pointer-types -Wno-error=incomplete-implementation
# Phase 1: module A's implementations spell two appWithHash: parameters
# (int / unsigned long long) differently from module B's header
# (NSInteger / NSUInteger). The @implementation's encoding is what the
# binary carries; the header spelling war is a phase-2 tidy-up.
OmniCarAppBridge_CFLAGS += -Wno-error=mismatched-parameter-types
OmniCarAppBridge_CFLAGS += -Wno-error=unused-variable
# Phase 2: ABHostBMethods.m is a category implementation in the project
# copy (see the note at its @implementation) — its methods intentionally
# coexist with ABHostLaunch.m's class implementation.
OmniCarAppBridge_CFLAGS += -Wno-error=objc-protocol-method-implementation
OmniCarAppBridge_LDFLAGS = -fuse-ld=lld
OMC_TARGET_NAME = OmniCarAppBridge
include ../OMCCommon/OMCCommon.mk

include $(THEOS_MAKE_PATH)/tweak.mk
