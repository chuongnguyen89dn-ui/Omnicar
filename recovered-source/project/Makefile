# OmniCar 1.0.3 — reconstructed-source project (aggregate).
# SCAFFOLD stage: subprojects currently build placeholder sources; each
# placeholder names the src/<Module>/ directory that replaces it.
export THEOS_PACKAGE_SCHEME = rootless
# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
export ARCHS = arm64
export TARGET = iphone:clang:16.5:15.0

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += OmniCarApp
SUBPROJECTS += OmniCarCore
SUBPROJECTS += OmniCarAppBridge
SUBPROJECTS += OmniCarCarProbe
SUBPROJECTS += OmniCarSpeedBubble
SUBPROJECTS += OmniCarSplitScreen
SUBPROJECTS += OmniCarStartupScreen
SUBPROJECTS += OmniCarPrefs

include $(THEOS_MAKE_PATH)/aggregate.mk
