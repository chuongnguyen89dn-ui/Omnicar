# OMCCommon is a source-shared unit, not a packaged subproject: it is
# compiled into each consumer through OMCCommon.mk (see OMCCommon.h for
# the evidence).  This Makefile only provides a standalone syntax check:
#   make -C OMCCommon check
check:
	clang -fsyntax-only -I. OMCCommon.c && echo "OMCCommon syntax OK"
.PHONY: check
