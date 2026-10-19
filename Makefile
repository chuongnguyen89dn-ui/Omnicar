TARGET := iphone:clang:latest:15.0
ARCHS := arm64
THEOS_PACKAGE_SCHEME := rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := OmniCarDoubleTapFullscreen
OmniCarDoubleTapFullscreen_FILES := src/OmniCarDoubleTapFullscreen.xm src/OmniCarChrome.xm
OmniCarDoubleTapFullscreen_CFLAGS := -fobjc-arc -Wall -Wextra
OmniCarDoubleTapFullscreen_FRAMEWORKS := UIKit Foundation QuartzCore
INSTALL_TARGET_PROCESSES := SpringBoard

include $(THEOS_MAKE_PATH)/tweak.mk
