// BWInputStore.h — [ytz5] authenticated per-slot input-session store
// (package YTZ5, strand B5). Pure C99, header-only, no Foundation —
// the Gate harness compiles this header standalone and exercises the
// exact API below; the bridgewake owner (SplitScreenA,
// SCPCarSplit+BridgeWake.m) keeps its single instance in a file
// static and is the only writer in production code.
//
// Model: one slot per split pane (0..9, float pane = 9). A slot's
// identity is the (hash, gen) pair of its CURRENT assignment — the
// owner re-Assigns on EVERY assignment lifecycle event (new assign,
// re-assign of the same bundle, teardown), so a report that names an
// older gen, a foreign hash, a superseded session, or a non-advancing
// seq can never rewrite the live record. A record is only believed
// while it is fresh: BW_KB_FRESH_WINDOW seconds after its last
// accepted report it decays back to UNKNOWN — never to a remembered
// INACTIVE. UNKNOWN is a real third state and is never collapsed.

#ifndef BW_INPUT_STORE_H
#define BW_INPUT_STORE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

// Three-state kb truth (return domain of BWInputSlotStateAt).
enum {
    BW_KB_UNKNOWN  = 0,
    BW_KB_INACTIVE = 1,
    BW_KB_ACTIVE   = 2
};

// Freshness window in seconds: a report older than this no longer
// proves anything about the slot (state reads UNKNOWN, and a
// different session may take the slot over).
#define BW_KB_FRESH_WINDOW 3.5

// Report verdicts (return domain of BWInputSlotReport).
enum {
    BW_OK          = 0, // accepted; record updated
    BW_R_BADHASH   = 1, // report's hash != the slot's assigned hash
    BW_R_BADGEN    = 2, // report's gen != the slot's assigned gen
    BW_R_BADSESSION= 3, // another session holds the slot and its last
                        // report is still fresh
    BW_R_STALESEQ  = 4, // same session, seq did not advance
    BW_R_NOASSIGN  = 5  // slot has no live assignment (hash == 0)
};

typedef struct {
    uint32_t hash;       // hash28 of the assigned bundle; 0 = unassigned
    uint32_t gen;        // assignment generation of (hash)
    uint32_t session;    // registered input-session id; 0 = none registered
    uint64_t lastSeq;    // seq of the last accepted report
    int      state;      // BW_KB_* (UNKNOWN until the first accepted report)
    double   lastReport; // `now` of the last accepted report
    bool     hasReport;  // an accepted report exists for this assignment
} BWInputSlot;

typedef struct {
    BWInputSlot slots[10];
} BWInputStore;

static inline int BWInputSlotIndexOK(int slot) {
    return slot >= 0 && slot < 10;
}

// Zero the whole store: every slot unassigned and UNKNOWN.
static inline void BWInputStoreInit(BWInputStore *store) {
    if (!store) return;
    memset(store, 0, sizeof(*store));
    for (int i = 0; i < 10; i++) store->slots[i].state = BW_KB_UNKNOWN;
}

// Assignment lifecycle event: the slot takes identity (hash, gen).
// The previous record and the previous session registration are
// wiped — the slot is UNKNOWN until a report for THIS assignment
// arrives.
static inline void BWInputSlotAssign(BWInputStore *store, int slot,
                                     uint32_t hash, uint32_t gen) {
    if (!store || !BWInputSlotIndexOK(slot)) return;
    BWInputSlot *s = &store->slots[slot];
    s->hash = hash;
    s->gen = gen;
    s->session = 0;
    s->lastSeq = 0;
    s->state = BW_KB_UNKNOWN;
    s->lastReport = 0;
    s->hasReport = false;
}

// Teardown: the assignment ends. Identity cleared (hash = 0), record
// wiped, slot UNKNOWN; any later report is BW_R_NOASSIGN until the
// next Assign.
static inline void BWInputSlotClear(BWInputStore *store, int slot) {
    if (!store || !BWInputSlotIndexOK(slot)) return;
    BWInputSlot *s = &store->slots[slot];
    s->hash = 0;
    s->gen = 0;
    s->session = 0;
    s->lastSeq = 0;
    s->state = BW_KB_UNKNOWN;
    s->lastReport = 0;
    s->hasReport = false;
}

// Validate and record one input-session report. wireState is the
// reporter's boolean wire value: nonzero = keyboard ACTIVE, zero =
// INACTIVE. `now` is the receiver's clock (same epoch as the `now`
// later passed to BWInputSlotStateAt / BWInputAggregate).
//
// Session discipline:
//  - no session registered yet (slot session == 0): the report
//    registers its session implicitly and is accepted;
//  - a DIFFERENT session: rejected BW_R_BADSESSION while the
//    registered session's last report is still fresh (<= window);
//    once stale, the new session takes over — it registers and its
//    seq becomes the baseline (no stale-seq check against the old
//    session's seq);
//  - the SAME session: seq must strictly advance, else
//    BW_R_STALESEQ.
// On acceptance: state = wire ? ACTIVE : INACTIVE, lastReport = now,
// lastSeq = seq, hasReport = true.
static inline int BWInputSlotReport(BWInputStore *store, int slot,
                                    uint32_t hash, uint32_t gen,
                                    uint32_t session, uint64_t seq,
                                    int wireState, double now) {
    if (!store || !BWInputSlotIndexOK(slot)) return BW_R_NOASSIGN;
    BWInputSlot *s = &store->slots[slot];
    if (s->hash == 0) return BW_R_NOASSIGN;
    if (hash != s->hash) return BW_R_BADHASH;
    if (gen != s->gen) return BW_R_BADGEN;
    if (s->session != 0 && session != s->session) {
        // Foreign session: only a stale incumbent can be displaced.
        if (s->hasReport && (now - s->lastReport) <= BW_KB_FRESH_WINDOW)
            return BW_R_BADSESSION;
        // Takeover: fall through and accept; seq baseline resets to
        // this report's seq in the accept path below.
    } else if (s->session != 0 && session == s->session) {
        if (s->hasReport && seq <= s->lastSeq) return BW_R_STALESEQ;
    }
    // Accept (first registration, same-session advance, or takeover).
    s->session = session;
    s->state = wireState ? BW_KB_ACTIVE : BW_KB_INACTIVE;
    s->lastReport = now;
    s->lastSeq = seq;
    s->hasReport = true;
    return BW_OK;
}

// The slot's believable state at `now`: UNKNOWN when nothing was
// ever reported for the current assignment, and UNKNOWN again once
// the last report is older than the freshness window. Reading never
// mutates the record (owner re-emission must not refresh freshness).
static inline int BWInputSlotStateAt(const BWInputStore *store, int slot,
                                     double now) {
    if (!store || !BWInputSlotIndexOK(slot)) return BW_KB_UNKNOWN;
    const BWInputSlot *s = &store->slots[slot];
    if (!s->hasReport) return BW_KB_UNKNOWN;
    if ((now - s->lastReport) > BW_KB_FRESH_WINDOW) return BW_KB_UNKNOWN;
    return s->state;
}

// Aggregate over the hosted slots. `hosted` is a per-slot flag array
// parallel to BWInputStore.slots (hosted[i] != 0 = slot i is a live
// hosted assignment); `n` is the number of entries to consider
// (clamped to 10). Returns:
//   2 — at least one hosted slot is ACTIVE at `now`;
//   1 — no ACTIVE, but at least one hosted slot is UNKNOWN at `now`;
//   0 — every hosted slot is freshly INACTIVE (or none is hosted).
static inline int BWInputAggregate(const BWInputStore *store,
                                   const int *hosted, int n, double now) {
    if (!store || !hosted) return 0;
    if (n > 10) n = 10;
    int anyUnknown = 0;
    for (int i = 0; i < n; i++) {
        if (!hosted[i]) continue;
        int st = BWInputSlotStateAt(store, i, now);
        if (st == BW_KB_ACTIVE) return 2;
        if (st == BW_KB_UNKNOWN) anyUnknown = 1;
    }
    return anyUnknown ? 1 : 0;
}

#ifdef __cplusplus
}
#endif

#endif // BW_INPUT_STORE_H
