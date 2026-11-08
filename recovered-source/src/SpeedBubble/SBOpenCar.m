// SBOpenCar.m — RETIRED in the phase-2 dedupe (wave 3). DEFINES NOTHING.
//
// This file held agent B's reconstruction of __init_0 @0x44a8 and its
// notify handler sub_45b4 (the CarPlayApp "opencar" boundary). The
// CANONICAL copy is in SPPDisplayBoot.m (SPPDisplayInitCarPlay +
// SPPHandleOpenCarNotification).
//
// Why: in the phase-2 pass both drafts were diffed element-by-element
// against a fresh capstone disassembly of the binary (all names via
// verify/macho_truth.py). Neither draft matched outright — B was right
// on the out_token pointer, the index fallback semantics, the library
// receiver (the application, not the dashboard) and the DBEvent type
// literal 4; A was right on the per-step respondsToSelector guards,
// the module-first _OMCMissingSelector call shape and the log
// strings; BOTH were wrong on the combined pre-check + combined log
// line, the 3-argument _OMCMissingSelector, _OMCCarClass (vs
// objc_getClass) and the unconditional final "CarPlay: mo %@" log.
// The canonical text in SPPDisplayBoot.m follows the binary on every
// one of those points. The full diff table is in REPORT_A.md,
// "Phase-2 compile fix" section.
//
// This file is kept (rather than deleted) so the module file list and
// the partition record stay intact; the integration Makefile should
// DROP it from the build's file list, since it defines no symbols.
