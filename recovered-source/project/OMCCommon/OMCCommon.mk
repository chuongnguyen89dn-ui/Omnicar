# OMCCommon — shared-unit include snippet.
# Consumer Makefiles set, BEFORE including this file:
#   OMC_TARGET_NAME = <their Theos instance name>   (e.g. OmniCarCore)
#   OMCCommon_PATH  = ../OMCCommon                  (default)
# This appends the unit's source to the consumer's _FILES and adds the
# unit's directory to its header search path, so the OMC* core is
# statically linked into the consumer binary — the same layout the
# original package uses (core embedded in every dylib, no OMCCommon
# binary installed).
OMCCommon_PATH ?= ../OMCCommon
$(eval $(OMC_TARGET_NAME)_FILES += $(OMCCommon_PATH)/OMCCommon.c)
$(eval $(OMC_TARGET_NAME)_CFLAGS += -I$(OMCCommon_PATH))
# Phase 1: OMCCommon.c / OmniCarCore.c are Objective-C sources despite the
# .c extension (see OMCCommon.h) — force the language for every consumer.
$(eval $(OMC_TARGET_NAME)_CFLAGS += -x objective-c)
