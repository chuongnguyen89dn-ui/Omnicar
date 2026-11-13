# New, isolated Le-style traffic surface for DuoCar. Not yet listed in the
# aggregate project/Makefile: source providers, lanes, signs, Google Maps card
# and controller integration must pass their checks before any package build.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DCLTraffic
DCLTraffic_FILES = DCLTrafficCore.c DCLTrafficSampler.m DCLTrafficOverlay.m
DCLTraffic_FRAMEWORKS = UIKit Foundation QuartzCore CoreGraphics
DCLTraffic_CFLAGS = -fobjc-arc -Wall
DCLTraffic_LDFLAGS = -fuse-ld=lld

include $(THEOS_MAKE_PATH)/tweak.mk
