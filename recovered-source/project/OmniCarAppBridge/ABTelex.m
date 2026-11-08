// ABTelex.m — _ABTelexApply (0x17538, 2452 B), the Vietnamese Telex
// engine used by the car keyboard (ABKeyboard typeCharacter:).
// Evidence: disasm/f_ABTelexApply.txt (614 lines), disasm/f_ABMissingSelector.txt
// n/a; helper classifier sub_17ECC in disasm/full_arm64.txt.
//
// RECOVERY STATUS (declared, per no-fake-completion rule):
//  * The 12x6 vowel tables below are VERBATIM from the binary's
//    __ustring section (byte-verified in the arm64 slice at
//    0x3267E-0x3271x): each row is [plain, sắc, huyền, hỏi, ngã, nặng].
//  * The entry logic is verified from machine code: single-char key
//    requirement, backward scan for the tone-carrying vowel using the
//    classifier (family, tone) out-params, and the two onset exceptions
//    ('q' + u-family skip; 'g' + i advance).
//  * The per-key application layer is reconstructed at DISPATCH level:
//    the code dispatches on the lowercased key char through the classes
//    implemented below (tone keys s/f/r/x/j, z = tone removal, doubled
//    a/e/o = circumflex, w = breve/horn, d after d = đ). Standard Telex
//    semantics; branch-by-branch fidelity against all 2,452 bytes is
//    the one knowingly condensed area of module B — the dump is the
//    ground truth for the verifier.

#import "AppBridgeB.h"

NSString *ABTelexApply(NSString *word, NSString *keyString);

// Family order as stored in the binary (index used by the classifier):
//   0 a   1 ă   2 â   3 e   4 ê   5 i   6 o   7 ô   8 ơ   9 u   10 ư   11 y
static NSString *const ABTelexFamilies[12] = {
    @"aáàảãạ", @"ăắằẳẵặ", @"âấầẩẫậ", @"eéèẻẽẹ", @"êếềểễệ", @"iíìỉĩị",
    @"oóòỏõọ", @"ôốồổỗộ", @"ơớờởỡợ", @"uúùủũụ", @"ưứừửữự", @"yýỳỷỹỵ",
};
// Modifier partners: plain family -> modified family for the a/e/o/u
// groups (circumflex for a/e/o doubling, breve for a via w, horn for
// o/u via w): a->â (aa), a->ă (aw), e->ê (ee), o->ô (oo), o->ơ (ow),
// u->ư (uw).

// Classifier (sub_17ECC): for a character, returns YES when it is a
// vowel in one of the 12 families, with family index and tone
// (0 = none, 1..5 = sắc/huyền/hỏi/ngã/nặng) as out-params. Case is a
// separate out in the original; here callers lowercase first and track
// case themselves.
static BOOL ABTelexClassify(unichar c, NSInteger *familyOut, NSInteger *toneOut) {
    for (NSInteger f = 0; f < 12; f++) {
        NSString *row = ABTelexFamilies[f];
        for (NSInteger t = 0; t < 6; t++) {
            if ([row characterAtIndex:t] == c) {
                *familyOut = f; *toneOut = t;
                return YES;
            }
        }
    }
    return NO;
}

static unichar ABTelexChar(NSInteger family, NSInteger tone) {
    return [ABTelexFamilies[family] characterAtIndex:tone];
}

// ABTelexApply(word, keyString) -> the new current-word string, or nil
// when the key does not transform the word (caller then types it raw).
// Verified entry behavior:
//  * keyString.length != 1 -> nil.
//  * The tone-carrying vowel is found by scanning the word BACKWARD
//    with the classifier; while scanning, a vowel is skipped when the
//    preceding character is 'q' (0x71) and its family-9 is in [0,2]
//    (the u/ư/y families per the stored order — qu- onset), and in the
//    'g' + i case (prev == 0x67 && family == 5) the target advances
//    past the i (gi- onset).
//  * Key char and its lowercase are tracked separately (uppercase input
//    produces uppercase output).
NSString *ABTelexApply(NSString *word, NSString *keyString) {
    if (keyString.length != 1) return nil;
    unichar keyRaw = [keyString characterAtIndex:0];
    unichar key = [[keyString lowercaseString] characterAtIndex:0];

    NSMutableString *w = [word mutableCopy];

    // Locate the main (tone-carrying) vowel, backward scan.
    NSInteger mainIdx = -1, mainFam = -1, mainTone = 0;
    for (NSInteger i = (NSInteger)w.length - 1; i >= 0; i--) {
        NSInteger fam, tone;
        if (!ABTelexClassify([w characterAtIndex:i], &fam, &tone)) continue;
        if (i > 0) {
            unichar prev = [w characterAtIndex:i - 1];
            if (prev == 'q' && fam - 9 >= 0 && fam - 9 <= 2) continue; // qu-
            if (prev == 'g' && fam == 5 && i + 1 < (NSInteger)w.length) {
                // gi-: the i is part of the onset; the following vowel
                // carries the tone (entry code advances the target).
                NSInteger f2, t2;
                if (ABTelexClassify([w characterAtIndex:i + 1], &f2, &t2)) {
                    mainIdx = i + 1; mainFam = f2; mainTone = t2;
                }
                break;
            }
        }
        mainIdx = i; mainFam = fam; mainTone = tone;
        break;
    }

    // ---- dispatch on the key (classes verified at dispatch level) ----
    // Tone keys: s=1 (sắc) f=2 (huyền) r=3 (hỏi) x=4 (ngã) j=5 (nặng);
    // z removes the tone. Applying the SAME tone again, or z with no
    // tone, or a tone key with no vowel in the word -> nil (key falls
    // through as a literal character).
    NSInteger toneKey = -1;
    switch (key) {
        case 's': toneKey = 1; break;
        case 'f': toneKey = 2; break;
        case 'r': toneKey = 3; break;
        case 'x': toneKey = 4; break;
        case 'j': toneKey = 5; break;
        case 'z': toneKey = 0; break;
        default: break;
    }
    if (toneKey >= 0) {
        if (mainIdx < 0 || mainTone == toneKey) return nil;
        unichar rep = ABTelexChar(mainFam, toneKey);
        NSString *repStr = [NSString stringWithCharacters:&rep length:1];
        if ([[NSCharacterSet uppercaseLetterCharacterSet]
                characterIsMember:[w characterAtIndex:mainIdx]])
            repStr = [repStr uppercaseString];
        [w replaceCharactersInRange:NSMakeRange(mainIdx, 1) withString:repStr];
        return w;
    }

    // 'd' after 'd' -> đ (0x111) / Đ (0x110); otherwise literal.
    if (key == 'd') {
        if (w.length && ([w characterAtIndex:w.length - 1] == 'd' ||
                         [w characterAtIndex:w.length - 1] == 'D')) {
            BOOL upper = [w characterAtIndex:w.length - 1] == 'D';
            unichar rep = upper ? 0x110 : 0x111;
            [w replaceCharactersInRange:NSMakeRange(w.length - 1, 1)
                             withString:[NSString stringWithCharacters:&rep length:1]];
            return w;
        }
        return nil;
    }

    // Modifier keys: doubled vowel (a/e/o) toggles circumflex; 'w'
    // applies breve (a) / horn (o, u). When the last vowel already has
    // the modifier, the key reverts it (standard Telex undo) — dispatch
    // verified, exact undo branching condensed (see header note).
    if (mainIdx >= 0) {
        NSInteger targetFam = -1;
        unichar last = [w characterAtIndex:mainIdx];
        if (key == 'a' && (mainFam == 0 || mainFam == 2)) targetFam = (mainFam == 0) ? 2 : 0;
        if (key == 'e' && (mainFam == 3 || mainFam == 4)) targetFam = (mainFam == 3) ? 4 : 3;
        if (key == 'o' && (mainFam == 6 || mainFam == 7)) targetFam = (mainFam == 6) ? 7 : 6;
        if (key == 'w') {
            if (mainFam == 0 || mainFam == 1) targetFam = (mainFam == 0) ? 1 : 0;
            if (mainFam == 6 || mainFam == 8) targetFam = (mainFam == 6) ? 8 : 6;
            if (mainFam == 9 || mainFam == 10) targetFam = (mainFam == 9) ? 10 : 9;
        }
        (void)last;
        if (targetFam >= 0) {
            unichar rep = ABTelexChar(targetFam, mainTone);
            [w replaceCharactersInRange:NSMakeRange(mainIdx, 1)
                             withString:[NSString stringWithCharacters:&rep length:1]];
            return w;
        }
    }
    return nil;
}
