// ABTelex.m — _ABTelexApply (0x17538, 2452 B), the Vietnamese Telex
// engine used by the car keyboard (ABKeyboard typeCharacter:), with its
// classifier (sub_17ECC, 500 B) and character generator (sub_180C0,
// 284 B).
//
// RECOVERY STATUS — REMEDIATION ROUND 2 (supersedes the round-1 note):
//  * The 12x6 vowel tables below are VERBATIM from the binary's
//    __ustring section (byte-verified in the arm64 slice at 0x3267E:
//    12 NUL-terminated UTF-16 rows, stride 7 unichars, through
//    0x32726): each row is [plain, sắc, huyền, hỏi, ngã, nặng].
//  * The per-key branch tree is now FULLY TRANSCRIBED from the machine
//    code — the round-1 "dispatch level / standard Telex semantics"
//    reconstruction is gone. Evidence: capstone skipdata dumps with
//    full LC_FUNCTION_STARTS coverage — disasm/rem4_telex_apply.txt
//    (2452/2452 B, 613 insns), disasm/rem4_telex_classifier.txt
//    (500/500 B), disasm/rem4_telex_generator.txt (284/284 B).
//  * Verification: the transcribed logic, written as an independent
//    structured model, was diffed against a faithful ARM64 interpreter
//    executing the original IMP (Foundation calls modelled) over
//    253,908 (word, key) cases — 0 mismatches, including the cases
//    where the binary raises NSRangeException.
//  * The binary DIVERGES from standard Telex in several load-bearing
//    places. They are flagged inline as [DIVERGENCE n] and summarised
//    at the bottom of this header. They are transcribed as-is: this is
//    a recovery of the original engine, bugs included.
//    [D1] The backward scan's bound (x23) is not a vowel-cluster end:
//         it is the found vowel's index when found on the first probe,
//         otherwise the NUMBER of probes before the finding probe. The
//         tone-strip range, the modified-vowel target search, the
//         a/e/o loop and the w loop are all bounded by [base, bound)
//         and therefore only engage when the found vowel sits early
//         in the word with enough trailing characters; for the common
//         syllable shapes the range is empty.
//    [D2] Tone target fallback applies the tone at base+1 for any span
//         other than 1 or 2 — replacing a consonant there (its
//         classifier family defaults to 0, the 'a' family) or raising
//         NSRangeException when base+1 == word length. The exception
//         propagates to -[ABKeyboard keyTapped:], whose @catch logs
//         "ban phim xe: loi phim %@" and drops the keystroke.
//    [D3] The tone-strip loop rewrites non-vowels inside its range to
//         the plain 'a'-family character (family defaults to 0).
//    [D4] The 'd' rule operates on the FIRST character of the word,
//         not on the character just typed.
//    [D5] The a/e/o modifier loop is gated on bound > base, and for
//         key 'a' a consonant in the loop range spuriously matches
//         (its defaulted family 0 == fromFam) and becomes 'â'.
//    [D6] See the 'w' path: gated pair scan and descending loop, bare
//         'w' with no vowel appends ư/Ư at the end of the word.
//    [D7] Same-tone re-press (strip + literal key) and the a/e/o / w
//         undo-with-literal-append escapes only see tones/modifiers
//         inside [base, bound) — see [D1].
//    [D8] 'z' removes a tone only if one is found inside
//         [base, bound); otherwise the key falls through literally.

#import "AppBridgeB.h"
#include <wctype.h> // towlower (the binary calls ___tolower)

NSString *ABTelexApply(NSString *word, NSString *keyString);

// Family order as stored in the binary (index used by the classifier):
//   0 a   1 ă   2 â   3 e   4 ê   5 i   6 o   7 ô   8 ơ   9 u   10 ư   11 y
// In the binary the rows live in a dispatch_once-built NSArray
// (getter sub_1D5DC); the literals below are the same strings.
static NSString *const ABTelexFamilies[12] = {
    @"aáàảãạ", @"ăắằẳẵặ", @"âấầẩẫậ", @"eéèẻẽẹ", @"êếềểễệ", @"iíìỉĩị",
    @"oóòỏõọ", @"ôốồổỗộ", @"ơớờởỡợ", @"uúùủũụ", @"ưứừửữự", @"yýỳỷỹỵ",
};

// 'w'-path family mapping table at 0x2B404 in the binary (12 x u32,
// read verbatim; only the mask-0x743 indices 0,1,6,8,9,10 are ever
// dereferenced): a<->ă, o<->ơ, u<->ư.
static const NSInteger ABTelexWMap[12] = { 1, 0, 0, 0, 0, 0, 8, 0, 6, 10, 9, 0 };

// Classifier (sub_17ECC, 0x17ECC-0x180C0): for a character, returns YES
// when it belongs to one of the 12 families. On a hit ONLY, writes
// *familyOut = row index, *toneOut = position inside the row (the tone
// index), *caseOut = (the lowercased needle char != the original
// char). The search needle is [lowercaseString of the 1-char string]
// characterAtIndex:0 — or the original character when the lowercased
// string does not have length exactly 1. Any out pointer may be NULL.
static BOOL ABTelexClassify(unichar c, NSInteger *familyOut,
                            NSInteger *toneOut, BOOL *caseOut) {
    NSString *one = [NSString stringWithCharacters:&c length:1];
    NSString *lowered = [one lowercaseString];
    unichar needle = (lowered.length == 1) ? [lowered characterAtIndex:0] : c;
    NSString *needleStr = [NSString stringWithCharacters:&needle length:1];
    for (NSInteger f = 0; f < 12; f++) {
        NSRange r = [ABTelexFamilies[f] rangeOfString:needleStr];
        if (r.location != NSNotFound) {
            if (familyOut) *familyOut = f;
            if (toneOut) *toneOut = (NSInteger)r.location;
            if (caseOut) *caseOut = (needle != c);
            return YES;
        }
    }
    return NO;
}

// Classifier outs as the call sites see them: the binary pre-zeroes the
// out slots before every call, so a non-vowel reads back family 0,
// tone 0, case NO. Several branches rely on exactly that (see [D3],
// [D5]); do not "fix" this helper to skip non-vowels.
static void ABTelexOuts(unichar c, NSInteger *familyOut,
                        NSInteger *toneOut, BOOL *caseOut) {
    *familyOut = 0; *toneOut = 0; *caseOut = NO;
    ABTelexClassify(c, familyOut, toneOut, caseOut);
}

// Character generator (sub_180C0, 0x180C0-0x181DC): the character at
// (family, tone); when caseFlag is set, the uppercased form — but only
// if the uppercase string still has length exactly 1, otherwise the
// original character is kept.
static unichar ABTelexGen(NSInteger family, NSInteger tone, BOOL caseFlag) {
    unichar ch = [ABTelexFamilies[family] characterAtIndex:tone];
    if (caseFlag) {
        NSString *up = [[NSString stringWithCharacters:&ch length:1] uppercaseString];
        if (up.length == 1) ch = [up characterAtIndex:0];
    }
    return ch;
}

static void ABTelexReplaceChar(NSMutableString *w, NSInteger idx, unichar ch) {
    [w replaceCharactersInRange:NSMakeRange(idx, 1)
                     withString:[NSString stringWithCharacters:&ch length:1]];
}

// The tone-apply block at 0x17AAC (shared by every tone-target exit):
// classify the character at the target index (family/case outs
// pre-zeroed, tone out NULL in the binary) and replace it with the
// tone-bearing character of its family. An out-of-range index raises
// NSRangeException here in the original — see [D2].
static NSString *ABTelexApplyToneAt(NSMutableString *w, NSInteger target, NSInteger tone) {
    NSInteger fam, toneIgnored; BOOL cs;
    ABTelexOuts([w characterAtIndex:target], &fam, &toneIgnored, &cs);
    ABTelexReplaceChar(w, target, ABTelexGen(fam, tone, cs));
    return w;
}

// ABTelexApply(word, keyString) -> the new current-word string, or nil
// when the key does not transform the word (the caller then types it
// raw). Transcribed block by block from 0x17538-0x17ECC; address
// ranges in comments refer to disasm/rem4_telex_apply.txt.
NSString *ABTelexApply(NSString *word, NSString *keyString) {
    // ---- entry (0x17538-0x175C4) ----
    if (keyString.length != 1) return nil;                    // 0x17570
    unichar keyRaw = [keyString characterAtIndex:0];          // x25
    unichar key = [[keyString lowercaseString] characterAtIndex:0]; // x27
    NSMutableString *w = [word mutableCopy];                  // x22

    // ---- backward scan (0x175C8-0x17618) ----
    // x26 = index of the last vowel (mainIdx); x23 (scanBound) follows
    // the exact compiled bookkeeping of the original: the csinc at
    // 0x175FC sets it to the probe index ONLY when it is still negative
    // AND the probe found a vowel, and increments it by one otherwise;
    // the csel at 0x1760C records the probe index as the last vowel
    // whenever the (already updated) bound is >= 0; the loop continues
    // only while the bound is >= 0 and the probed char is NOT a vowel.
    // Net effect [DIVERGENCE 1]: mainIdx is the last vowel's index,
    // while scanBound is that same index when the vowel was found on
    // the first probe, and otherwise the NUMBER of probes made before
    // the finding probe (len-1 when no vowel exists).
    NSInteger cursor = (NSInteger)w.length;                   // x24
    NSInteger mainIdx = -1;                                   // x26
    NSInteger scanBound = -1;                                 // x23
    while (cursor > 0) {
        cursor--;
        BOOL isVowel = ABTelexClassify([w characterAtIndex:cursor], NULL, NULL, NULL);
        if (scanBound < 0 && isVowel) scanBound = cursor;
        else scanBound += 1;
        if (isVowel && scanBound >= 0) mainIdx = cursor;
        if (!(scanBound >= 0 && !isVowel)) break;
    }

    // ---- onset adjustment + end-of-range flag (0x1761C-0x176D0) ----
    // base (x24) starts at mainIdx. The qu-/gi- onset rules are only
    // consulted when (scanBound - mainIdx) >= 2, and each advances the
    // base past the main vowel: prev == 'q' (lowercased via the
    // binary's ___tolower, masked to 16 bits) with the main vowel's
    // family in {9, 10, 11} (u/ư/y), or prev == 'g' with family 5 (i).
    NSInteger base;                                           // x24
    BOOL endFlag;                                             // [sp+0x14]
    if (mainIdx < 0) {
        base = -1;
        endFlag = NO;                                         // 0x17698
    } else {
        base = mainIdx;
        if (mainIdx > 0 && (scanBound - mainIdx) >= 2) {
            unichar prev = (unichar)(towlower([w characterAtIndex:mainIdx - 1]) & 0xFFFF);
            NSInteger fam = 0; // out slot pre-zeroed in the binary
            ABTelexClassify([w characterAtIndex:mainIdx], &fam, NULL, NULL);
            if (prev == 'q' && (NSUInteger)(fam - 9) <= 2) base = mainIdx + 1;
            else if (prev == 'g' && fam == 5) base = mainIdx + 1;
        }
        endFlag = scanBound < (NSInteger)w.length;            // 0x176CC
    }

    // ---- dispatch on the lowercased key (0x176D4-0x1785C) ----
    // Tone keys: s=1 (sắc), f=2 (huyền), r=3 (hỏi), x=4 (ngã), j=5
    // (nặng); z is tone 0 in the strip slot (isZ). Entries at
    // 0x1781C (s), 0x17734 (f), 0x176F4 (r), 0x17874 (x), 0x17860 (j),
    // 0x17720 (z); every entry bails to nil when mainIdx < 0.
    NSInteger tone = -1;
    BOOL isZ = NO;
    switch (key) {
        case 's': tone = 1; break;
        case 'f': tone = 2; break;
        case 'r': tone = 3; break;
        case 'x': tone = 4; break;
        case 'j': tone = 5; break;
        case 'z': tone = 0; isZ = YES; break;
        default: break;
    }
    if (tone >= 0) {
        if (mainIdx < 0) return nil;
        // ---- tone-strip loop (0x17744-0x177DC) ----
        // For every index in [base, scanBound): remember the last
        // nonzero tone seen and rewrite the character with tone 0 of
        // its own family. [DIVERGENCE 3]: classifier outs are
        // pre-zeroed, so a non-vowel inside the range is rewritten to
        // the plain 'a' character. Skipped entirely when
        // scanBound <= base — the usual case [DIVERGENCE 1].
        NSInteger existingTone = 0;                           // w28
        if (scanBound > base) {
            for (NSInteger idx = base; idx != scanBound; idx++) {
                NSInteger fam, t; BOOL cs;
                ABTelexOuts([w characterAtIndex:idx], &fam, &t, &cs);
                if (t != 0) existingTone = t;
                ABTelexReplaceChar(w, idx, ABTelexGen(fam, 0, cs));
            }
        }
        // ---- 'z' (0x177E0-0x177F4): strip only — return the word
        // when a tone was actually stripped, else nil [DIVERGENCE 8].
        if (isZ) return existingTone != 0 ? w : nil;
        // ---- same tone again (0x17800-0x17818): the stripped word
        // plus the literal key string (original case preserved).
        if (existingTone == tone) {
            [w appendString:keyString];
            return w;
        }
        // ---- target selection (0x17888-0x17968) ----
        // First: the LAST index in [base, scanBound) whose family is
        // one of the modified families {1, 2, 4, 7, 8, 10} (mask
        // 0x596: ă â ê ô ơ ư) wins. The loop only runs when
        // scanBound > base (subs/b.ls at 0x17894).
        NSInteger span = scanBound - base;                    // x21
        if (span > 0) {
            NSInteger target = -1;
            for (NSInteger idx = base; idx != scanBound; idx++) {
                NSInteger fam = 0; // out slot pre-zeroed per iteration
                ABTelexClassify([w characterAtIndex:idx], &fam, NULL, NULL);
                if (fam <= 10 && ((0x596 >> fam) & 1)) target = idx;
            }
            if (target >= 0) return ABTelexApplyToneAt(w, target, tone);
        }
        // Otherwise the span decides: 1 -> base; 2 -> base+1 when the
        // scan bound stops short of the word end (endFlag) or the
        // 2-char substring at base, lowercased, is one of the
        // constant array @[@"oa", @"oe", @"uy"] at 0x394B0 — else
        // base; every other span (including the common span <= 0)
        // -> base+1 [DIVERGENCE 2].
        NSInteger target;
        if (span == 1) {
            target = base;                                    // 0x17964
        } else if (span == 2) {
            NSString *pair = [[w substringWithRange:NSMakeRange(base, 2)] lowercaseString];
            target = (endFlag || [pair isEqualToString:@"oa"] ||
                      [pair isEqualToString:@"oe"] || [pair isEqualToString:@"uy"])
                         ? base + 1 : base;
        } else {
            target = base + 1;                                // 0x17AA8
        }
        return ABTelexApplyToneAt(w, target, tone);
    }

    // ---- modifier keys a/e/o (0x179CC-0x17AA4) ----
    // fromFam/toFam per key from the csel chains at 0x179D0-0x179F8:
    // a: 0->2, e: 3->4, o: 6->7. The backward loop mutates its own
    // copy of scanBound down to (but not past) base and acts on the
    // FIRST character whose family is fromFam or toFam: fromFam is
    // rewritten to toFam; toFam is rewritten back to fromFam AND the
    // literal key string is appended (the undo escape). No match ->
    // nil. [DIVERGENCE 5]: the loop only runs when scanBound > base,
    // and for key 'a' a consonant in range reads family 0 == fromFam
    // and is rewritten to 'â'.
    if (key == 'a' || key == 'e' || key == 'o') {
        if (mainIdx < 0) return nil;
        NSInteger fromFam = (key == 'a') ? 0 : (key == 'e') ? 3 : 6;  // w26
        NSInteger toFam = (key == 'a') ? 2 : (key == 'e') ? 4 : 7;    // w21
        NSInteger j = scanBound;                              // x23, mutated
        while (j > base) {
            j--;
            NSInteger fam, t; BOOL cs;
            ABTelexOuts([w characterAtIndex:j], &fam, &t, &cs);
            if (fam == fromFam || fam == toFam) {
                ABTelexReplaceChar(w, j, ABTelexGen(fam == fromFam ? toFam : fromFam, t, cs));
                if (fam == toFam) [w appendString:keyString];
                return w;
            }
        }
        return nil;
    }

    // ---- 'w' key (0x17B3C-0x17DCC) ----
    if (key == 'w') {
        // No vowel anywhere (0x17C14): append the tone-0 family-10
        // character (ư, or Ư when the typed key was uppercase — the
        // case flag is literally (lowercased key != raw key)) at the
        // end of the word, and return it [DIVERGENCE 6].
        if (mainIdx < 0) {
            unichar ch = ABTelexGen(10, 0, key != keyRaw);
            [w appendString:[NSString stringWithCharacters:&ch length:1]];
            return w;
        }
        // Pair scan (0x17B4C-0x17BBC), only when base+1 < scanBound:
        // for consecutive positions (i, i+1) inside [base, scanBound),
        // family(u) == 9 followed by family 8 (ơ) or 6 (o) converts
        // the pair to (family 10, family 8) with each character's own
        // tone and case preserved — built in the binary with
        // stringWithFormat:@"%C%C" and a 2-char replace at 0x17CE8.
        if (base + 1 < scanBound) {
            for (NSInteger i = base; i + 1 != scanBound; i++) {
                NSInteger f1, t1, f2, t2; BOOL c1, c2;
                ABTelexOuts([w characterAtIndex:i], &f1, &t1, &c1);
                ABTelexOuts([w characterAtIndex:i + 1], &f2, &t2, &c2);
                if (f1 == 9 && (f2 == 8 || f2 == 6)) {
                    unichar pair[2] = { ABTelexGen(10, t1, c1), ABTelexGen(8, t2, c2) };
                    [w replaceCharactersInRange:NSMakeRange(i, 2)
                                     withString:[NSString stringWithCharacters:pair length:2]];
                    return w;
                }
            }
        }
        // Descending loop (0x17BC0-0x17C10, hit block 0x17D4C): from
        // scanBound-1 down to base, the first character whose family
        // is in mask 0x743 ({0, 1, 6, 8, 9, 10}) is rewritten through
        // the table at 0x2B404; when its original family is already a
        // modified one ({1, 8, 10}, mask 0x502) the literal key
        // string is appended as well (undo escape). No hit -> nil.
        NSInteger j = scanBound;                              // x23, mutated
        while (j > base) {
            j--;
            NSInteger fam, t; BOOL cs;
            ABTelexOuts([w characterAtIndex:j], &fam, &t, &cs);
            if (fam <= 10 && ((0x743 >> fam) & 1)) {
                ABTelexReplaceChar(w, j, ABTelexGen(ABTelexWMap[fam], t, cs));
                if ((1 << fam) & 0x502) [w appendString:keyString];
                return w;
            }
        }
        return nil;
    }

    // ---- 'd' key (0x1797C-0x179C8 and 0x17C5C-0x17C9C) ----
    // [DIVERGENCE 4]: everything happens at index 0 of the word.
    // When the first character is 'd' or 'D' ((c0 | 0x20) == 0x64) it
    // is replaced by đ (U+0111, for lowercase 'd') or Đ (U+0110) —
    // the constant strings at 0x36BB0/0x36BD0 in the binary. When it
    // is đ/Đ ((c0 & 0xFFFE) == 0x110) it is replaced by 'd'/'D'
    // (0x36BF0/0x36C10) AND the literal key string is appended (the
    // undo escape). Anything else, and the empty word, -> nil. (The
    // mainIdx < 0 case still reaches this path in the binary: the
    // dispatch has no vowel requirement for 'd'.)
    if (key == 'd') {
        if (w.length == 0) return nil;
        unichar c0 = [w characterAtIndex:0];
        if ((c0 | 0x20) == 0x64) {
            ABTelexReplaceChar(w, 0, c0 == 0x64 ? 0x111 : 0x110);
            return w;
        }
        if ((c0 & 0xFFFE) == 0x110) {
            ABTelexReplaceChar(w, 0, c0 == 0x111 ? 'd' : 'D');
            [w appendString:keyString];
            return w;
        }
        return nil;
    }

    // All other keys (0x17838-0x17858 fall-through): no transform.
    return nil;
}
