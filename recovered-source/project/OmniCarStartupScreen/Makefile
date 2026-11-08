# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OmniCarStartupScreen
# Phase 2: real reconstructed sources replace the scaffold placeholder
# (OmniCarStartupScreen.m / OmniCarStartupScreen_ScaffoldAnchor is obsolete
# and is no longer in _FILES; the file itself is left on disk, unbuilt).
OmniCarStartupScreen_FILES = SSSplash.m SSStartupScreen.m SSStartupView.m SSStartupViewBuilders.m SSStartupViewScenesB.m
OmniCarStartupScreen_CFLAGS = -fobjc-arc
OmniCarStartupScreen_CFLAGS += -DOMC_MODULE_NAME='"StartupScreen"'
# Phase 2 warning demotions (mechanical, logged in project/logs/phase2-startupscreen.md):
#  - incomplete-implementation: the 12 superseded ss_build*/scene methods are declared in
#    SSStartupView.m's class extension but implemented by the (ScenesB)/(Builders)
#    categories in their own files — the warning is per-TU noise.
#  - deprecated-declarations: the binary-faithful sources use UIWindow.setScreen: and
#    +[CLLocationManager authorizationStatus], both deprecated-but-present in the 16.5 SDK.
#  - unused-function: SSGreetingLine / SSWeatherSymbolName in SSStartupView.m lost their
#    last in-TU callers when their structural bodies were superseded (their canonical
#    counterparts live in ScenesB); kept for the record, not deleted.
OmniCarStartupScreen_CFLAGS += -Wno-error=incomplete-implementation -Wno-error=deprecated-declarations -Wno-error=unused-function
OmniCarStartupScreen_LDFLAGS = -fuse-ld=lld
OMC_TARGET_NAME = OmniCarStartupScreen
include ../OMCCommon/OMCCommon.mk

include $(THEOS_MAKE_PATH)/tweak.mk
