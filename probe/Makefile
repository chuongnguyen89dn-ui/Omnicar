TARGET := iphone:clang:latest:15.0
ARCHS := arm64
THEOS_PACKAGE_SCHEME := rootless
include $(THEOS)/makefiles/common.mk
TWEAK_NAME := OmniCarSkinProbe
OmniCarSkinProbe_FILES := OmniCarSkinProbe.xm
OmniCarSkinProbe_CFLAGS := -fobjc-arc -Wall -Wextra
OmniCarSkinProbe_FRAMEWORKS := UIKit Foundation QuartzCore
INSTALL_TARGET_PROCESSES := CarPlayApp SpringBoard
include $(THEOS_MAKE_PATH)/tweak.mk
