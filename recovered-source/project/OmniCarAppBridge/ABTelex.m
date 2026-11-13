// [hl43-shared-telex] Single Vietnamese input engine used by ABKeyboard
// for BOTH hosted and native CarPlay. Replaces recovered binary's documented
// D1-D8 defects; the byte-faithful legacy implementation is preserved in Git
// before this commit (blob 50e132bd8cda2372ee5a264903cb8c821f2e3991).
// Self-contained Foundation implementation allows running actual function
// with clang -fobjc-arc -framework Foundation in macOS GitHub CI.
#import <Foundation/Foundation.h>

// Each family: unaccented, sac, huyen, hoi, nga, nang.
// All characters are single NFC UTF-16 code units (Vietnamese precomposed).
static NSArray<NSString *> *ABTVowels(void) {
    static NSArray<NSString *> *rows;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        rows = @[@"aáàảãạ", @"ăắằẳẵặ", @"âấầẩẫậ",
                 @"eéèẻẽẹ", @"êếềểễệ", @"iíìỉĩị",
                 @"oóòỏõọ", @"ôốồổỗộ", @"ơớờởỡợ",
                 @"uúùủũụ", @"ưứừửữự", @"yýỳỷỹỵ"];
    });
    return rows;
}

static BOOL ABTFind(unichar character, NSUInteger *family,
                    NSUInteger *tone, BOOL *uppercase) {
    NSString *original = [NSString stringWithCharacters:&character length:1];
    NSString *lowercase = [original lowercaseString];
    if (lowercase.length != 1) return NO;
    unichar lower = [lowercase characterAtIndex:0];
    NSArray<NSString *> *rows = ABTVowels();
    for (NSUInteger f=0; f<rows.count; f++) {
        NSString *row=rows[f];
        for (NSUInteger t=0; t<6; t++) {
            if ([row characterAtIndex:t] != lower) continue;
            if (family) *family=f;
            if (tone) *tone=t;
            if (uppercase) *uppercase=(character!=lower);
            return YES;
        }
    }
    return NO;
}

static NSString *ABTLetter(NSUInteger family, NSUInteger tone, BOOL uppercase) {
    NSArray<NSString *> *rows=ABTVowels();
    if (family>=rows.count || tone>=6) return nil;
    NSString *lower=[rows[family] substringWithRange:NSMakeRange(tone,1)];
    return uppercase ? [lower uppercaseString] : lower;
}
static NSString *ABTReplace(NSString *word, NSUInteger index, NSString *letter) {
    if (index>=word.length || !letter.length) return nil;
    NSMutableString *result=[word mutableCopy];
    [result replaceCharactersInRange:NSMakeRange(index,1) withString:letter];
    return result;
}
static NSUInteger ABTTonePosition(NSString *word) {
    NSMutableArray<NSNumber *> *indices=[NSMutableArray array];
    NSInteger lastModified=-1;
    for (NSUInteger i=0; i<word.length; i++) {
        NSUInteger f=0;
        if (!ABTFind([word characterAtIndex:i],&f,NULL,NULL)) continue;
        NSString *previous=i ? [[word substringWithRange:NSMakeRange(i-1,1)]
                                 lowercaseString] : @"";
        // In qu- and gi-, the u/i is an onset, not the tone-bearing vowel.
        if (([previous isEqualToString:@"q"] && (f==9 || f==10)) ||
            ([previous isEqualToString:@"g"] && f==5))
            continue;
        [indices addObject:@(i)];
        if (f==1 || f==2 || f==4 || f==7 || f==8 || f==10)
            lastModified=(NSInteger)i;
    }
    if (!indices.count) return NSNotFound;
    if (lastModified>=0) return (NSUInteger)lastModified;
    if (indices.count>=3) return indices[indices.count-2].unsignedIntegerValue;
    if (indices.count==1) return indices[0].unsignedIntegerValue;
    NSUInteger first=indices[0].unsignedIntegerValue;
    NSUInteger last=indices[1].unsignedIntegerValue;
    NSUInteger f0=0,f1=0;
    ABTFind([word characterAtIndex:first],&f0,NULL,NULL);
    ABTFind([word characterAtIndex:last],&f1,NULL,NULL);
    // In unmodified diphthongs ai/ao/au/ay/ei/eo/oi/ou/uy,
    // accent the nucleus rather than the final glide.
    if (f1==5 || f1==9 || f1==11 ||
        (f1==6 && (f0==0 || f0==3)) ||
        (f0==6 && (f1==0 || f1==3)))
        return first; // modern tone placement: hòa, khỏe, chào
    return last;
}

NSString *ABTelexApply(NSString *word, NSString *keyString) {
    if (![word isKindOfClass:[NSString class]] ||
        ![keyString isKindOfClass:[NSString class]] ||
        keyString.length!=1 || word.length>64) return nil;
    NSString *lowercase=[keyString lowercaseString];
    if (lowercase.length!=1) return nil;
    unichar key=[lowercase characterAtIndex:0];
    // Source word is normally already NFC; normalize for deterministic
    // vowel lookup while always emitting composed Vietnamese characters.
    NSString *w=[word precomposedStringWithCanonicalMapping];

    NSInteger newTone=-1;
    switch (key) {
        case 's': newTone=1; break;
        case 'f': newTone=2; break;
        case 'r': newTone=3; break;
        case 'x': newTone=4; break;
        case 'j': newTone=5; break;
        case 'z': newTone=0; break;
        default: break;
    }
    if (newTone>=0) {
        NSUInteger target=ABTTonePosition(w);
        if (target==NSNotFound) return nil;
        NSMutableString *plain=[w mutableCopy];
        NSUInteger oldTone=0;
        for (NSUInteger i=0;i<plain.length;i++) {
            NSUInteger fam=0,tone=0;BOOL upper=NO;
            if (!ABTFind([plain characterAtIndex:i],&fam,&tone,&upper)) continue;
            if (tone) {
                oldTone=tone;
                [plain replaceCharactersInRange:NSMakeRange(i,1)
                    withString:ABTLetter(fam,0,upper)];
            }
        }
        if (key=='z') return oldTone ? plain : nil;
        if (oldTone==(NSUInteger)newTone) {
            [plain appendString:keyString]; // same-tone double press escapes
            return plain;
        }
        NSUInteger fam=0;BOOL upper=NO;
        if (!ABTFind([plain characterAtIndex:target],&fam,NULL,&upper))
            return nil;
        return ABTReplace(plain,target,ABTLetter(fam,(NSUInteger)newTone,upper));
    }

    // Telex dd -> đ, ddd -> dd. Only target the onset, not interior d.
    if (key=='d' && w.length) {
        unichar c=[w characterAtIndex:0];
        if (c=='d' || c=='D')
            return ABTReplace(w,0,c=='D' ? @"Đ" : @"đ");
        if (c==0x0110 || c==0x0111) {
            NSMutableString *undone=[ABTReplace(w,0,c==0x0110 ? @"D" : @"d")
                                     mutableCopy];
            [undone appendString:keyString];
            return undone;
        }
    }

    // Doubled vowels: aa->â, ee->ê, oo->ô; 3rd press unrolls.
    if (key=='a' || key=='e' || key=='o') {
        NSUInteger base=key=='a' ? 0 : (key=='e' ? 3 : 6);
        NSUInteger modified=key=='a' ? 2 : (key=='e' ? 4 : 7);
        for (NSInteger i=(NSInteger)w.length-1;i>=0;i--) {
            NSUInteger fam=0,tone=0;BOOL upper=NO;
            if (!ABTFind([w characterAtIndex:(NSUInteger)i],&fam,&tone,&upper))
                continue;
            if (fam==base)
                return ABTReplace(w,(NSUInteger)i,ABTLetter(modified,tone,upper));
            if (fam==modified) {
                NSMutableString *undone=[ABTReplace(w,(NSUInteger)i,
                                            ABTLetter(base,tone,upper)) mutableCopy];
                [undone appendString:keyString];
                return undone;
            }
        }
    }

    // aw->ă, ow->ơ, uw->ư; "uo" + w -> "ươ".
    if (key=='w') {
        for (NSInteger i=(NSInteger)w.length-1;i>0;i--) {
            NSUInteger left=0,lt=0,right=0,rt=0;
            BOOL lu=NO,ru=NO;
            if (!ABTFind([w characterAtIndex:(NSUInteger)(i-1)],&left,&lt,&lu) ||
                !ABTFind([w characterAtIndex:(NSUInteger)i],&right,&rt,&ru))
                continue;
            if (left==9 && (right==6 || right==8)) {
                NSMutableString *result=[w mutableCopy];
                NSString *replacement=[NSString stringWithFormat:@"%@%@",
                                        ABTLetter(10,lt,lu),ABTLetter(8,rt,ru)];
                [result replaceCharactersInRange:NSMakeRange((NSUInteger)(i-1),2)
                                      withString:replacement];
                return result;
            }
        }
        for (NSInteger i=(NSInteger)w.length-1;i>=0;i--) {
            NSUInteger fam=0,tone=0;BOOL upper=NO;
            if (!ABTFind([w characterAtIndex:(NSUInteger)i],&fam,&tone,&upper))
                continue;
            NSUInteger other=NSNotFound;
            if (fam==0) other=1; else if(fam==6) other=8;
            else if (fam==9) other=10;
            else if (fam==1) other=0; else if(fam==8) other=6;
            else if (fam==10) other=9;
            if (other==NSNotFound) continue;
            NSMutableString *result=[ABTReplace(w,(NSUInteger)i,
                                       ABTLetter(other,tone,upper)) mutableCopy];
            if (fam==1 || fam==8 || fam==10)
                [result appendString:keyString]; // modifier undo
            return result;
        }
        if (!w.length) return [keyString isEqualToString:lowercase] ? @"ư" : @"Ư";
    }
    return nil; // non-Telex key falls through to ordinary insertion
}
