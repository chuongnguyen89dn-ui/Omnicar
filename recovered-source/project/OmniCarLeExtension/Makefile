# Experimentally extend an unmodified Le 0.2.4 installed inside a
# single personal-use DuoCar package. Produces signed extension DEB
# to be consumed by merge_le024_personal_deb.py, not a shipping tweak alone.
ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = DCLLeExtension
DCLLeExtension_FILES = DCLLeExtension.m ../OmniCarLeTraffic/DCLTrafficCore.c
DCLLeExtension_FRAMEWORKS = Foundation UIKit CoreFoundation QuartzCore CoreGraphics
DCLLeExtension_CFLAGS = -fobjc-arc -I../OmniCarLeTraffic -Wno-error=arc-performSelector-leaks
include $(THEOS_MAKE_PATH)/tweak.mk
