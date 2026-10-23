TARGET := iphone:clang:latest:15.0
ARCHS := arm64
THEOS_PACKAGE_SCHEME := rootless
include $(THEOS)/makefiles/common.mk
TWEAK_NAME := OmniCarYouTubeScene
OmniCarYouTubeScene_FILES := src/OmniCarYouTubeScene.xm
OmniCarYouTubeScene_CFLAGS := -fobjc-arc -Wall -Wextra
OmniCarYouTubeScene_FRAMEWORKS := UIKit Foundation QuartzCore
INSTALL_TARGET_PROCESSES := CarPlayApp SpringBoard
include $(THEOS_MAKE_PATH)/tweak.mk
