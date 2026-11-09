# NOTE(arm64e): original binaries are FAT arm64+arm64e. On THIS VM, clang-18 silently
# emits arm64 for the arm64e slice and the universal merge fails (llvm-lipo error in
# logs/scaffold-build-2.log), so ARCHS is arm64-only here. Re-add arm64e on a
# toolchain that truly emits arm64e.
ARCHS = arm64
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OmniCarSplitScreen
# Phase 2: full A+B+C merge (see logs/phase2-splitscreen.md).
OmniCarSplitScreen_FILES = SCPCarSplit.m SCPHooks.m SCPPrefs.m SCPShared.m SCPSmallClasses.m SCPSpringBoardHooks.m SCPPerfTelemetry.m SCPSessionCore.m SCPCButton.m SCPCTouchWatch.m SCPCarDividerView.m SCPCarSplit+Chrome.m SCPCarSplit+BridgeWake.m SCPCarSplit+AutoHide.m SCPPinchController.m SCPFullscreenController.m SCPFullscreenAdapter.m SCPTouchProbe.m SCPCarSplit+Divider.m SCPCarSplit+Drag.m SCPCarSplit+Layout.m SCPCarSplit+Panel.m SCPCarSplit+Picker.m SCPCarSplit+RatioMenu.m SCPCarSplit+Zoom.m SCPCarSplit+Relayout.m SCPCarSplitView.m SCPCarTabView.m SCPHomeWallView.m SCPAppIcons.m SCPCarApps.m SCPDiagDump.m SCPHomeApply.m SCPHomeHooks.m SCPHomeSettings.m SCPHomeVisibility.m SCPLibRoot.m
OmniCarSplitScreen_FRAMEWORKS = UIKit Foundation QuartzCore AVFoundation CoreGraphics
OmniCarSplitScreen_CFLAGS = -fobjc-arc
OmniCarSplitScreen_CFLAGS += -DOMC_MODULE_NAME='"SplitScreen"'
# G5 (rem4): the original binary carries the perf/session cluster ONCE;
# SCPPerfTelemetry.m + SCPSessionCore.m are this target's single instance,
# so the shared unit is compiled without its own copy (OMCCommon.c guard).
OmniCarSplitScreen_CFLAGS += -DOMC_NO_PERF_CLUSTER
# Phase 1 integration: NSDistributedNotificationCenter shims.
OmniCarSplitScreen_CFLAGS += -include SCPIntegrationShims.h
OmniCarSplitScreen_CFLAGS += -Wno-error=nonnull -Wno-error=incomplete-implementation -Wno-error=mismatched-parameter-types
OmniCarSplitScreen_CFLAGS += -Wno-error=arc-performSelector-leaks -Wno-error=unused-variable -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=objc-protocol-method-implementation
OmniCarSplitScreen_LDFLAGS = -fuse-ld=lld
OMC_TARGET_NAME = OmniCarSplitScreen
include ../OMCCommon/OMCCommon.mk

include $(THEOS_MAKE_PATH)/tweak.mk
