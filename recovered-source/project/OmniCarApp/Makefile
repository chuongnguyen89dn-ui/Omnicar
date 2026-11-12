# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

# [hl36-voice-off] Standalone assistant sources are preserved as historical
# material only. Do NOT compile DCVoiceSession / DCVoiceCommand or link Speech.
APPLICATION_NAME = OmniCar
OmniCar_FILES = main.m OMCAppDelegate.m OMCNativeSettings.m OMCNativeStartup.m
OmniCar_FRAMEWORKS = UIKit AVFoundation AVKit CoreMedia CoreImage CoreVideo ImageIO CoreGraphics QuartzCore UniformTypeIdentifiers
# Reuse the original real Root/Feature schemas and translations. Never copy Prefs Info.plist
# over the application's APPL Info.plist (historical HL16 regression).
OmniCar_RESOURCE_FILES = $(filter-out ../OmniCarPrefs/Resources/Info.plist,$(wildcard ../OmniCarPrefs/Resources/*))
OmniCar_CFLAGS = -fobjc-arc
OmniCar_LDFLAGS = -fuse-ld=lld

include $(THEOS_MAKE_PATH)/application.mk
