# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OmniCarCore
OmniCarCore_FILES = OmniCarCore.c
OmniCarCore_CFLAGS = -fobjc-arc
OmniCarCore_LDFLAGS = -fuse-ld=lld
OMC_TARGET_NAME = OmniCarCore
include ../OMCCommon/OMCCommon.mk

include $(THEOS_MAKE_PATH)/tweak.mk
