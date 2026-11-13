# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = OmniCarPrefs
OmniCarPrefs_FILES = OMCCommon.m OMCAppBridgeAppsController.m OMCCarProfilesController.m OMCCardPage.m OMCCells.m OMCFeatureListController.m OMCHSPreview.m OMCHeaderCard.m OMCHomeScreenController.m OMCOnboardingController.m OMCRootListController.m OMCSSStyleTileCell.m OMCSplitPreview.m OMCSplitScreenAppPickerController.m OMCSplitScreenController.m OMCStartupScreenController.m OMCWhatsNewController.m SSCanvasView.m SSFade.m SSGauge.m SSLinkTarget.m SSStartupView.m
OmniCarPrefs_INSTALL_PATH = /Library/PreferenceBundles
OmniCarPrefs_FRAMEWORKS = UIKit
# Phase 1 integration: the reconstructed sources use AVFoundation
# (startup-screen video), CoreMedia (CMTime), QuartzCore (gradient
# layers) and CoreGraphics directly; the scaffold listed UIKit only.
OmniCarPrefs_FRAMEWORKS += AVFoundation CoreMedia QuartzCore CoreGraphics AVKit UniformTypeIdentifiers
# Phase 2 integration: the synced OMCStartupScreenController.m imports
# <ImageIO/...> and <CoreImage/...> directly (frame extraction:
# CIContext/CIImage, kCGImageDestinationLossyCompressionQuality,
# kCVPixelBufferPixelFormatTypeKey via CoreVideo).
OmniCarPrefs_FRAMEWORKS += ImageIO CoreImage CoreVideo
OmniCarPrefs_PRIVATE_FRAMEWORKS = Preferences
OmniCarPrefs_CFLAGS = -fobjc-arc
# Phase 1 integration: the Theos vendor Preferences headers are modular;
# with modules on, files that use self.specifier without importing
# <Preferences/PSSpecifier.h> fail ("must be imported from module").
# Recorded VM contingency: build this subproject with modules off.
OmniCarPrefs_USE_MODULES = 0
# Phase 1 integration: private-framework class shims (see header).
OmniCarPrefs_CFLAGS += -include PrefsIntegrationShims.h
# Phase 1 integration: the reconstruction deliberately calls
# performSelector under @try in several controllers (same demotion as
# the other subprojects).
OmniCarPrefs_CFLAGS += -Wno-error=arc-performSelector-leaks
# Phase 1 integration: B controllers assign viewWithTag: (UIView*) results
# to typed locals (UISlider*); same demotion class as AppBridge.
OmniCarPrefs_CFLAGS += -Wno-error=incompatible-pointer-types
# Phase 1 integration: B sources use dot-syntax for void method calls
# (e.g. layer.removeAllAnimations); demote that diagnostic class too.
OmniCarPrefs_CFLAGS += -Wno-error=unused-getter-return-value
OmniCarPrefs_LDFLAGS = -fuse-ld=lld
# PHASE-1 DEVIATION (see BUILD_PHASE1_LOG.md, BLOCKER-CORE-PREFS): the
# shared OMCCommon unit is NOT appended here. Prefs-A's own OMCCommon.m
# (in _FILES above) carries the Prefs binary's core copy PLUS ~25
# Prefs-only helpers in the same file, and 7 of its symbols collide with
# the shared unit (one, OMCLogoMeshImage, with a different signature).
# Dedupe = phase-2 decision; differences are listed in the phase-1 log.

include $(THEOS_MAKE_PATH)/bundle.mk
