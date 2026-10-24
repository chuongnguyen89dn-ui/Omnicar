TARGET := iphone:clang:latest:15.0
ARCHS := arm64
THEOS_PACKAGE_SCHEME := rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := OmniCarYouTubeHandleIdle
OmniCarYouTubeHandleIdle_FILES := src/OmniCarYouTubeHandleIdle.xm
OmniCarYouTubeHandleIdle_CFLAGS := -fobjc-arc -Wall -Wextra
OmniCarYouTubeHandleIdle_FRAMEWORKS := UIKit Foundation QuartzCore CoreFoundation
INSTALL_TARGET_PROCESSES := SpringBoard CarPlayApp

include $(THEOS_MAKE_PATH)/tweak.mk
