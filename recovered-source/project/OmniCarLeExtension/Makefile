# HL58 optional standalone Lề companion. This package contains ONLY
# DuoCar's GPS speedText adjustment and Lề visual ON/OFF gate.
# Original Lề runtime is NEVER included; no vendor library is copied.
ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = DCLLeExtension
DCLLeExtension_FILES = DCLLeExtension.m DCLLeConfigBridge.m
DCLLeExtension_FRAMEWORKS = Foundation UIKit CoreFoundation
DCLLeExtension_CFLAGS = -fobjc-arc -Wno-error=arc-performSelector-leaks
include $(THEOS_MAKE_PATH)/tweak.mk
