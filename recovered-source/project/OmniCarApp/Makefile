# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = OmniCar
OmniCar_FILES = main.m OMCAppDelegate.m ../OmniCarPrefs/OMCCommon.m ../OmniCarPrefs/OMCAppBridgeAppsController.m ../OmniCarPrefs/OMCCarProfilesController.m ../OmniCarPrefs/OMCCardPage.m ../OmniCarPrefs/OMCCells.m ../OmniCarPrefs/OMCFeatureListController.m ../OmniCarPrefs/OMCHSPreview.m ../OmniCarPrefs/OMCHeaderCard.m ../OmniCarPrefs/OMCHomeScreenController.m ../OmniCarPrefs/OMCOnboardingController.m ../OmniCarPrefs/OMCRootListController.m ../OmniCarPrefs/OMCSSStyleTileCell.m ../OmniCarPrefs/OMCSpeedBubbleController.m ../OmniCarPrefs/OMCSplitPreview.m ../OmniCarPrefs/OMCSplitScreenAppPickerController.m ../OmniCarPrefs/OMCSplitScreenController.m ../OmniCarPrefs/OMCStartupScreenController.m ../OmniCarPrefs/OMCWhatsNewController.m ../OmniCarPrefs/SPPBubbleView.m ../OmniCarPrefs/SPPGlassView.m ../OmniCarPrefs/SPPIconView.m ../OmniCarPrefs/SPPSignView.m ../OmniCarPrefs/SPPSoundDelegate.m ../OmniCarPrefs/SSCanvasView.m ../OmniCarPrefs/SSFade.m ../OmniCarPrefs/SSGauge.m ../OmniCarPrefs/SSLinkTarget.m ../OmniCarPrefs/SSStartupView.m
OmniCar_FRAMEWORKS = UIKit AVFoundation CoreMedia QuartzCore CoreGraphics AVKit UniformTypeIdentifiers ImageIO CoreImage CoreVideo
# [hl16-settings] Compile the actual Prefs controllers into the iPhone application.
# Never depend on dlopen of /var/jb/Library/PreferenceBundles in the app sandbox.
# [hl16b-appinfo] HL16 incorrectly copied the Prefs bundle Info.plist
# into OmniCar.app, changing the app identifier to com.anlai.omnicar.prefs
# and the executable to OmniCarPrefs. That breaks iPhone app launch and
# the CarPlay Home launcher (whose OwnID is com.anlai.omnicar.app).
# Keep Theos default OmniCarApp/Resources (correct app Info.plist), and
# copy the ACTUAL feature/localisation assets one by one. RESOURCE_FILES
# copies each .lproj directory itself; Info.plist from Prefs is excluded.
OmniCar_RESOURCE_FILES = $(filter-out ../OmniCarPrefs/Resources/Info.plist,$(wildcard ../OmniCarPrefs/Resources/*))
OmniCar_CFLAGS += -I../OmniCarPrefs -include ../OmniCarPrefs/PrefsIntegrationShims.h
OmniCar_USE_MODULES = 0
# [hl15-settings] Load the existing Prefs controllers inside the OmniCar app.
OmniCar_PRIVATE_FRAMEWORKS = Preferences
OmniCar_CFLAGS += -fobjc-arc -Wno-error=arc-performSelector-leaks -Wno-error=incompatible-pointer-types -Wno-error=unused-getter-return-value
OmniCar_LDFLAGS = -fuse-ld=lld

include $(THEOS_MAKE_PATH)/application.mk
