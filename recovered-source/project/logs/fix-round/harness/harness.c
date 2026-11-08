/* harness.c - host-side C harness (Linux clang, NO ObjC runtime) that
 * executes REAL logic transcribed from the CURRENT fix-round-2 sources.
 * Every transcription carries a file:line citation (line numbers verified
 * by reading the files for this round). See README.md for what ran and
 * what is static-only.
 */
#include <stdio.h>
#include <stdint.h>

static int g_checks = 0, g_fails = 0;
#define CHECK(cond, ...) do { g_checks++; if (!(cond)) { g_fails++; \
    printf("  FAIL: "); printf(__VA_ARGS__); printf("\n"); } } while (0)

/* ---- FNV-1a 32 ---------------------------------------------------------
 * Transcribed EXACTLY from src/AppBridgeB/AppBridgeB.h:54-61
 * (ABBundleHash). The ObjC original reads bundleID.UTF8String and loops
 * over its NUL-terminated bytes as (uint8_t)*s; this C version takes the
 * same NUL-terminated byte string. Basis 0x811C9DC5, prime 0x01000193:
 *   while (*s) { h = (h ^ (uint8_t)*s) * 0x01000193u; s++; }
 * If s is NULL the original returns the basis unchanged; mirrored here.
 */
static uint32_t ABBundleHash_c(const char *s) {
    uint32_t h = 0x811C9DC5u;
    if (s) {
        while (*s) { h = (h ^ (uint8_t)*s) * 0x01000193u; s++; }
    }
    return h;
}

/* ---- Keyboard sender (pack) --------------------------------------------
 * Transcribed from src/AppBridgeB/ABInApp.m:341-349 (ABKeyboardPublish,
 * sub_6AD4): state starts 0; only when shown: state = 1, then
 * state |= (keyboardType & 0x7F) << 1 (line 345) and
 * state |= (returnKeyType & 0xFF) << 8 (line 347); always
 * state |= (uint64_t)ABBundleHash(bundleID) << 24 (line 349).
 * notify_register_check / notify_set_state / notify_post are transport,
 * not logic, and are not transcribed.
 */
static uint64_t pack_keyboard(int shown, int kb_type, int ret_type,
                              const char *bundle) {
    uint64_t state = 0;
    if (shown) {
        state = 1;
        state |= (uint64_t)(kb_type & 0x7F) << 1;
        state |= (uint64_t)(ret_type & 0xFF) << 8;
    }
    state |= (uint64_t)ABBundleHash_c(bundle) << 24;
    return state;
}

/* ---- Keyboard receiver (unpack) ------------------------------------------
 * Transcribed from src/AppBridgeB/ABHostGeometry.m:153,159-164
 * (ABKeyboardDispatch, sub_93B0): hash = state >> 24 (line 153);
 * (state & 1) == 0 -> hide (lines 159-160), else show with
 * keyboardType = (state >> 1) & 0x7F and returnType = (state >> 8) &
 * 0xFF (lines 162-164). The bundleForHash lookup and @try/@catch shell
 * are host plumbing; the decode and the single show-XOR-hide outcome
 * are transcribed as an effect enum so tests can count effects
 * (exactly one per state).
 */
typedef enum { EFF_NONE = 0, EFF_SHOW, EFF_HIDE } kb_effect;
typedef struct { uint64_t hash; int shown; int kb_type; int ret_type;
                 kb_effect effect; } kb_decoded;
static kb_decoded unpack_keyboard(uint64_t state) {
    kb_decoded d;
    d.hash = (state >> 24);
    d.kb_type = (int)((state >> 1) & 0x7F);
    d.ret_type = (int)((state >> 8) & 0xFF);
    if ((state & 1) == 0) { d.shown = 0; d.effect = EFF_HIDE; }
    else                  { d.shown = 1; d.effect = EFF_SHOW; }
    return d;
}

/* ---- App-orient sender (pack) ------------------------------------------
 * Transcribed from src/AppBridgeB/ABInApp.m:450-452
 * (ABPublishAppOrientation, sub_67FC):
 *   state = ((uint64_t)orientationField & 0xFF)
 *         | ((uint64_t)(mask & 0xFFFF) << 8)
 *         | ((uint64_t)ABBundleHash(bundleID) << 24);
 * The mask parameter stands in for ABSupportedOrientationMask()
 * (ABInApp.m:449) - host state, not packing logic.
 */
static uint64_t pack_apporient(int64_t orient_field, unsigned mask,
                               const char *bundle) {
    uint64_t state = ((uint64_t)orient_field & 0xFF)
                   | ((uint64_t)(mask & 0xFFFF) << 8)
                   | ((uint64_t)ABBundleHash_c(bundle) << 24);
    return state;
}

/* ---- App-orient receiver (unpack) ----------------------------------------
 * Transcribed from src/AppBridgeB/ABHostGeometry.m:143-145
 * (ABAppOrientDispatch, sub_92B4): hash = state >> 24,
 * orientation = state & 0xFF, mask = (state >> 8) & 0xFFFF.
 */
typedef struct { uint64_t hash; uint64_t orient; uint64_t mask; } ao_decoded;
static ao_decoded unpack_apporient(uint64_t state) {
    ao_decoded d;
    d.hash = (state >> 24);
    d.orient = (state & 0xFF);
    d.mask = ((state >> 8) & 0xFFFF);
    return d;
}

/* ---- Orientation clamp ---------------------------------------------------
 * Transcribed from src/AppBridgeB/ABHostGeometry.m:383-385
 * (ABHook_SBSceneViewRefSize, sub_7764): the whole logic is
 *   if (orientation > 4) orientation = 3;
 * a SIGNED comparison on NSInteger (long here), so -1 and 4 pass
 * through unchanged. The call through orig_SBSceneView is transport.
 */
static long clamp_orientation(long orientation) {
    if (orientation > 4) orientation = 3;
    return orientation;
}

/* ---- Unblank (screen-blanked hook) -----------------------------------------
 * Transcribed from src/AppBridgeB/ABHostGeometry.m:393-402
 * (ABHook_ScreenBlanked, sub_777C):
 *   if (blanked == 1 && [[ABHost shared] count] > 0) {
 *       orig_ScreenBlanked(1);
 *       dispatch_after(dispatch_time(0, 1000000000), main, ^{ orig(0); });
 *       return;
 *   }
 *   orig_ScreenBlanked(blanked);
 * 1000000000 ns = 1.0 s. orig and dispatch_after are replaced by fakes:
 * fake_orig records (seq, arg, fake_time); the fake scheduler queues the
 * delayed orig(0) and fires it when the test advances fake time.
 * g_hosted_count stands in for [[ABHost shared] count].
 */
static double g_now = 0.0;
static struct { int seq; int arg; double t; } g_orig_log[32];
static int g_orig_n = 0;
static void fake_orig(int arg) {
    g_orig_log[g_orig_n].seq = g_orig_n;
    g_orig_log[g_orig_n].arg = arg;
    g_orig_log[g_orig_n].t = g_now;
    g_orig_n++;
}
static struct { double fire_at; int arg; int done; } g_sched[32];
static int g_sched_n = 0;
static void fake_dispatch_after_orig0_after_1s(void) {
    g_sched[g_sched_n].fire_at = g_now + 1.0;
    g_sched[g_sched_n].arg = 0;
    g_sched[g_sched_n].done = 0;
    g_sched_n++;
}
static void advance_time(double dt) {
    double target = g_now + dt;
    for (int i = 0; i < g_sched_n; i++) {
        if (!g_sched[i].done && g_sched[i].fire_at <= target + 1e-9) {
            g_sched[i].done = 1;
            g_now = g_sched[i].fire_at;
            fake_orig(g_sched[i].arg);
        }
    }
    g_now = target;
}
static int g_hosted_count = 0;
static void hook_screen_blanked(int blanked) {
    if (blanked == 1 && g_hosted_count > 0) {
        fake_orig(1);
        fake_dispatch_after_orig0_after_1s();
        return;
    }
    fake_orig(blanked);
}

/* ---- Hook-chain guard simulation (TEST 4) ---------------------------------
 * Transcribed GUARD LOGIC ONLY (control flow), from:
 *  (i) ABInstallSpringBoardHooks, src/AppBridgeB/ABHostGeometry.m:415-419:
 *      file-scope static ABHooksInstalledOnce (line 415);
 *      if (ABHooksInstalledOnce) return;  (line 418)
 *      ABHooksInstalledOnce = YES;        (line 419, set BEFORE install)
 *      ... install body ...
 *  (ii) ABSpringBoardReady, src/AppBridgeB/ABHostGeometry.m:95-105,133:
 *      orig IMP called FIRST on EVERY call (line 100), then the registrar
 *      body inside its own function-local static once-guard: static
 *      ABRegistrarRegistered (line 103), if (!ABRegistrarRegistered)
 *      { ABRegistrarRegistered = YES; (line 105) ...body... } closed at
 *      line 133.
 * MSHookMessageEx calls / registrations are replaced by counters.
 * This executes the transcribed control flow, NOT the ObjC code; see
 * README.md for the static-only disclaimer.
 */
static int fake_install_count = 0, fake_orig_count = 0, fake_registrar_count = 0;
static int ABHooksInstalledOnce_sim; /* mirrors file-scope static, line 415 */
static void sim_install(void) {
    if (ABHooksInstalledOnce_sim) return;
    ABHooksInstalledOnce_sim = 1; /* set BEFORE install body, line 419 */
    fake_install_count++;         /* install body */
}
static void sim_ready(void) {
    fake_orig_count++;            /* orig first, every call, line 100 */
    static int ABRegistrarRegistered_sim; /* function-local, line 103 */
    if (!ABRegistrarRegistered_sim) {
        ABRegistrarRegistered_sim = 1;    /* line 105 */
        fake_registrar_count++;           /* registrar body */
    }
}

/* ============================ TEST 1a: keyboard ============================ */
static const char *KB_BUNDLES[] = {
    "com.apple.mobilesafari",
    "com.google.maps",
    "com.spotify.client",
    "com.microsoft.Office.Outlook",
};
static void test_keyboard(void) {
    int c0 = g_checks, f0 = g_fails;
    static const int types[4][2] = {{0,0},{1,1},{7,3},{127,255}};
    printf("TEST 1a keyboard round-trip\n");
    for (int b = 0; b < 4; b++) {
        uint32_t h = ABBundleHash_c(KB_BUNDLES[b]);
        printf("  bundle %-30s FNV1a32=0x%08X top-byte=0x%02X\n",
               KB_BUNDLES[b], h, (h >> 24) & 0xFF);
    }
    for (int b = 0; b < 4; b++) {
        uint32_t want_hash = ABBundleHash_c(KB_BUNDLES[b]);
        for (int s = 0; s < 2; s++) {
            for (int t = 0; t < 4; t++) {
                int kt = types[t][0], rt = types[t][1];
                uint64_t st = pack_keyboard(s, kt, rt, KB_BUNDLES[b]);
                kb_decoded d = unpack_keyboard(st);
                CHECK(d.hash == want_hash,
                      "kb hash bundle=%s shown=%d", KB_BUNDLES[b], s);
                CHECK(d.shown == s, "kb shown bundle=%s shown=%d",
                      KB_BUNDLES[b], s);
                /* exactly ONE effect: show XOR hide, never none */
                CHECK(d.effect == (s ? EFF_SHOW : EFF_HIDE),
                      "kb effect bundle=%s shown=%d", KB_BUNDLES[b], s);
                if (s) {
                    /* sender packs type fields only when shown
                       (ABInApp.m:342-348) */
                    CHECK(d.kb_type == kt && d.ret_type == rt,
                          "kb types bundle=%s kt=%d rt=%d got %d/%d",
                          KB_BUNDLES[b], kt, rt, d.kb_type, d.ret_type);
                } else {
                    CHECK(d.kb_type == 0 && d.ret_type == 0,
                          "kb hidden types must decode 0, bundle=%s",
                          KB_BUNDLES[b]);
                }
            }
        }
    }
    /* Regression: bundle with non-zero hash TOP byte breaks the old
     * wrong decoders. com.apple.mobilesafari hash 0x9A8FFE74 (top 0x9A):
     * its hash occupies packed bits 24..55, top byte at bits 48..55. */
    {
        const char *bundle = "com.apple.mobilesafari";
        uint32_t h = ABBundleHash_c(bundle);
        CHECK(((h >> 24) & 0xFF) != 0, "regression bundle top byte is 0");
        uint64_t st = pack_keyboard(1, 7, 3, bundle);
        uint32_t old_u32  = (uint32_t)st;
        uint32_t old_sh32 = (uint32_t)(st >> 32);
        uint32_t old_sh40 = (uint32_t)(st >> 40);
        printf("  regression: true=0x%08X (uint32)state=0x%08X "
               "state>>32=0x%08X state>>40=0x%08X correct=0x%llX\n",
               h, old_u32, old_sh32, old_sh40,
               (unsigned long long)(st >> 24));
        CHECK(old_u32 != h, "old (uint32_t)state decoder must differ");
        CHECK(old_sh32 != h, "old >>32 decoder must differ");
        CHECK(old_sh40 != h, "old >>40 decoder must differ");
        CHECK((st >> 24) == h, "correct >>24 decoder must equal hash");
    }
    printf("TEST 1a: %s (%d checks, %d failures)\n",
           (g_fails == f0) ? "PASS" : "FAIL", g_checks - c0, g_fails - f0);
}

/* ============================ TEST 1b: apporient =========================== */
static void test_apporient(void) {
    int c0 = g_checks, f0 = g_fails;
    static const int orients[5] = {0, 1, 3, 4, 6};
    static const unsigned masks[4] = {0, 26, 30, 65535};
    static const char *bundles[2] = {"com.apple.mobilesafari",
                                     "com.google.maps"};
    printf("TEST 1b apporient round-trip\n");
    for (int b = 0; b < 2; b++)
        printf("  bundle %-30s FNV1a32=0x%08X top-byte=0x%02X\n",
               bundles[b], ABBundleHash_c(bundles[b]),
               (ABBundleHash_c(bundles[b]) >> 24) & 0xFF);
    for (int b = 0; b < 2; b++) {
        uint32_t want_hash = ABBundleHash_c(bundles[b]);
        for (int o = 0; o < 5; o++) {
            for (int m = 0; m < 4; m++) {
                uint64_t st = pack_apporient(orients[o], masks[m], bundles[b]);
                ao_decoded d = unpack_apporient(st);
                CHECK(d.hash == want_hash, "ao hash bundle=%s", bundles[b]);
                CHECK(d.orient == (uint64_t)orients[o],
                      "ao orient bundle=%s o=%d", bundles[b], orients[o]);
                CHECK(d.mask == (uint64_t)masks[m],
                      "ao mask bundle=%s m=%u", bundles[b], masks[m]);
            }
        }
    }
    printf("TEST 1b: %s (%d checks, %d failures)\n",
           (g_fails == f0) ? "PASS" : "FAIL", g_checks - c0, g_fails - f0);
}

/* ============================ TEST 2: clamp ================================ */
static void test_clamp(void) {
    int c0 = g_checks, f0 = g_fails;
    static const long in[7]  = {-1, 0, 1, 2, 3, 4, 5};
    static const long exp[7] = {-1, 0, 1, 2, 3, 4, 3};
    printf("TEST 2 orientation clamp\n");
    for (int i = 0; i < 7; i++) {
        long got = clamp_orientation(in[i]);
        printf("  clamp(%ld) = %ld (expected %ld)\n", in[i], got, exp[i]);
        CHECK(got == exp[i], "clamp %ld -> %ld, want %ld", in[i], got, exp[i]);
    }
    printf("TEST 2: %s (%d checks, %d failures)\n",
           (g_fails == f0) ? "PASS" : "FAIL", g_checks - c0, g_fails - f0);
}

/* ============================ TEST 3: unblank ============================== */
static void reset_unblank(void) { g_orig_n = 0; g_sched_n = 0; g_now = 0.0; }
static void test_unblank(void) {
    int c0 = g_checks, f0 = g_fails;
    printf("TEST 3 unblank (fake scheduler)\n");
    /* (a) blank=1, hosted=2 -> [orig(1)] now, [orig(0)] at +1.0 s */
    reset_unblank(); g_hosted_count = 2;
    hook_screen_blanked(1);
    CHECK(g_orig_n == 1 && g_orig_log[0].arg == 1 && g_orig_log[0].t == 0.0,
          "3a immediate must be exactly [orig(1)@0.0], n=%d", g_orig_n);
    CHECK(g_sched_n == 1, "3a exactly one scheduled entry, n=%d", g_sched_n);
    advance_time(0.5);
    CHECK(g_orig_n == 1, "3a nothing before 1.0 s, n=%d", g_orig_n);
    advance_time(0.5); /* now exactly 1.0 s */
    CHECK(g_orig_n == 2 && g_orig_log[1].arg == 0 && g_orig_log[1].t == 1.0,
          "3a at 1.0 s must append orig(0)@1.0, n=%d", g_orig_n);
    advance_time(5.0);
    CHECK(g_orig_n == 2, "3a nothing else ever, n=%d", g_orig_n);
    printf("  3a sequence: [orig(%d)@%.1f, orig(%d)@%.1f]\n",
           g_orig_log[0].arg, g_orig_log[0].t,
           g_orig_log[1].arg, g_orig_log[1].t);
    /* (b) blank=1, hosted=0 -> single plain forward orig(1) */
    reset_unblank(); g_hosted_count = 0;
    hook_screen_blanked(1);
    CHECK(g_orig_n == 1 && g_orig_log[0].arg == 1,
          "3b single forward orig(1), n=%d", g_orig_n);
    CHECK(g_sched_n == 0, "3b nothing scheduled, n=%d", g_sched_n);
    advance_time(2.0);
    CHECK(g_orig_n == 1, "3b still one call after advance, n=%d", g_orig_n);
    /* (c) blank=0, hosted=2 -> single plain forward orig(0) */
    reset_unblank(); g_hosted_count = 2;
    hook_screen_blanked(0);
    CHECK(g_orig_n == 1 && g_orig_log[0].arg == 0,
          "3c single forward orig(0), n=%d", g_orig_n);
    CHECK(g_sched_n == 0, "3c nothing scheduled, n=%d", g_sched_n);
    advance_time(2.0);
    CHECK(g_orig_n == 1, "3c still one call after advance, n=%d", g_orig_n);
    printf("TEST 3: %s (%d checks, %d failures)\n",
           (g_fails == f0) ? "PASS" : "FAIL", g_checks - c0, g_fails - f0);
}

/* ============================ TEST 4: guards =============================== */
static void test_guards(void) {
    int c0 = g_checks, f0 = g_fails;
    printf("TEST 4 hook-chain guard simulation (transcribed logic only)\n");
    sim_install(); sim_install();
    sim_ready(); sim_ready(); sim_ready();
    printf("  install body=%d (want 1), orig=%d (want 3), registrar=%d "
           "(want 1)\n", fake_install_count, fake_orig_count,
           fake_registrar_count);
    CHECK(fake_install_count == 1, "install body ran %d x", fake_install_count);
    CHECK(fake_orig_count == 3, "orig ran %d x", fake_orig_count);
    CHECK(fake_registrar_count == 1, "registrar ran %d x", fake_registrar_count);
    printf("TEST 4: %s (%d checks, %d failures)\n",
           (g_fails == f0) ? "PASS" : "FAIL", g_checks - c0, g_fails - f0);
}

int main(void) {
    printf("OmniCar fix-round-2 harness (transcribed logic, host C11)\n");
    test_keyboard();
    test_apporient();
    test_clamp();
    test_unblank();
    test_guards();
    printf("TOTAL: %d assertions, %d failures -> %s\n",
           g_checks, g_fails, g_fails ? "FAIL" : "PASS");
    return g_fails ? 1 : 0;
}
