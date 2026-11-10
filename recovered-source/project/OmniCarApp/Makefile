# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = OmniCar
OmniCar_FILES = main.m OMCAppDelegate.m
OmniCar_FRAMEWORKS = UIKit
# [hl15-settings] Load the existing Prefs controllers inside the OmniCar app.
OmniCar_PRIVATE_FRAMEWORKS = Preferences
OmniCar_CFLAGS = -fobjc-arc
OmniCar_LDFLAGS = -fuse-ld=lld

include $(THEOS_MAKE_PATH)/application.mk
