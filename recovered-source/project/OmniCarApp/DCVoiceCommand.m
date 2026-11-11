#import "DCVoiceCommand.h"

static NSString *DCVoiceNormalized(NSString *speech) {
    if (![speech isKindOfClass:NSString.class] || speech.length > 512) return @"";
    NSString *s = [[[speech lowercaseString]
        stringByReplacingOccurrencesOfString:@"đ" withString:@"d"]
        stringByFoldingWithOptions:NSDiacriticInsensitiveSearch
        locale:[NSLocale localeWithLocaleIdentifier:@"vi_VN"]];
    NSMutableString *clean = [NSMutableString stringWithCapacity:s.length];
    NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:
        @"abcdefghijklmnopqrstuvwxyz0123456789/ "];
    BOOL space = YES;
    for (NSUInteger i = 0; i < s.length; ++i) {
        unichar ch = [s characterAtIndex:i];
        if ([allowed characterIsMember:ch] && ch != ' ') {
            [clean appendFormat:@"%C", ch];
            space = NO;
        } else if (!space) {
            [clean appendString:@" "];
            space = YES;
        }
    }
    return [clean stringByTrimmingCharactersInSet:
        NSCharacterSet.whitespaceCharacterSet];
}
static BOOL DCVHas(NSString *t, NSString *part) {
    return [t rangeOfString:part].location != NSNotFound;
}
static BOOL DCVAny(NSString *t, NSArray<NSString *> *choices) {
    for (NSString *p in choices) if (DCVHas(t,p)) return YES;
    return NO;
}
static NSInteger DCVSide(NSString *t) {
    if (DCVAny(t,@[@"ben trai", @"o trai", @"left"])) return 0;
    if (DCVAny(t,@[@"ben phai", @"o phai", @"right"])) return 1;
    return -1;
}
static NSString *DCVBundle(NSString *t) {
    // Explicit aliases only; no arbitrary spoken bundle IDs, URLs or shell.
    if (DCVAny(t,@[@"youtube", @"you tube"])) return @"com.google.ios.youtube";
    if (DCVAny(t,@[@"google maps", @"google map"])) return @"com.google.Maps";
    if (DCVAny(t,@[@"apple maps", @"apple map"])) return @"com.apple.Maps";
    if (DCVAny(t,@[@"ban do", @"maps", @" map "])) return @"com.google.Maps";
    if (DCVHas(t,@"tiktok")) return @"com.ss.iphone.ugc.Ame";
    if (DCVHas(t,@"facebook")) return @"com.facebook.Facebook";
    if (DCVHas(t,@"zalo")) return @"vn.com.vng.zingalo";
    if (DCVHas(t,@"spotify")) return @"com.spotify.client";
    if (DCVAny(t,@[@"apple music", @"nhac apple"])) return @"com.apple.Music";
    return nil;
}
NSDictionary<NSString *, id> *DCVoiceParseCommand(
    NSString *transcript, NSSet<NSString *> *approvedBundles) {
    NSString *t = DCVoiceNormalized(transcript);
    if (!t.length) return nil;
    // No destructive/unsafe command family in v1.
    if (DCVAny(t,@[@"xoa", @"kill", @"tat app", @"tat het", @"respring",
                    @"xoa du lieu", @"reset", @"delete", @"shutdown"])) return nil;
    if (DCVAny(t,@[@"doi cho", @"hoan doi", @"dao vi tri", @"swap panes", @"swap"])) {
        return @{@"action":@"swap"};
    }
    if (DCVAny(t,@[@"yeu thich", @"favorite"])) {
        NSInteger index = DCVAny(t,@[@"so 1", @"mot", @"one", @"favorite 1", @"1"]) ? 1 :
            DCVAny(t,@[@"so 2", @"hai", @"two", @"favorite 2", @"2"]) ? 2 :
            DCVAny(t,@[@"so 3", @"ba", @"three", @"favorite 3", @"3"]) ? 3 : 0;
        return index > 0 ? @{@"action":@"fav", @"index":@(index)} : nil;
    }
    if (DCVAny(t,@[@"phong to o", @"thu gon o", @"zoom pane", @"zoom o"])) {
        NSInteger side = DCVSide(t);
        if (side < 0) {
            if (DCVAny(t,@[@"o 1", @"pane 1"])) side=0;
            else if (DCVAny(t,@[@"o 2", @"pane 2"])) side=1;
        }
        return side >= 0 ? @{@"action":@"zoom", @"pane":@(side+1)} : nil;
    }
    if (DCVAny(t,@[@"ti le", @"ty le", @"chia", @"ratio"])) {
        // Check explicit percentage pairs first; 20..80 and total 100 only.
        NSRegularExpression *re = [NSRegularExpression
            regularExpressionWithPattern:@"([2-8][0-9])\\s*/\\s*([2-8][0-9])"
                                 options:0 error:NULL];
        NSTextCheckingResult *match = [re firstMatchInString:t
            options:0 range:NSMakeRange(0, t.length)];
        if (match) {
            NSInteger left=[[t substringWithRange:[match rangeAtIndex:1]] integerValue];
            NSInteger right=[[t substringWithRange:[match rangeAtIndex:2]] integerValue];
            if (left+right==100 && left>=20 && left<=80)
                return @{@"action":@"ratio", @"r":@((double)left/100.0)};
            return nil;
        }
        if (DCVAny(t,@[@"sau muoi bon muoi", @"60 40"]))
            return @{@"action":@"ratio", @"r":@0.6};
        if (DCVAny(t,@[@"nam muoi nam muoi", @"50 50"]))
            return @{@"action":@"ratio", @"r":@0.5};
        if (DCVAny(t,@[@"bon muoi sau muoi", @"40 60"]))
            return @{@"action":@"ratio", @"r":@0.4};
    }
    if (DCVAny(t,@[@"bo cuc", @"chia", @"layout", @"split"])) {
        NSInteger layout = 0;
        if (DCVAny(t,@[@"13", @"chu l", @"large left"])) layout=13;
        else if (DCVAny(t,@[@"31", @"large right"])) layout=31;
        else if (DCVAny(t,@[@"3 o", @"ba o", @"3 panes", @"three panes"])) layout=3;
        else if (DCVAny(t,@[@"2 o", @"hai o", @"doi", @"2 panes", @"two panes"])) layout=2;
        if (layout) return @{@"action":@"layout", @"id":@(layout)};
    }
    if (DCVAny(t,@[@"mo ", @"open ", @"chay ", @"bat "])) {
        NSString *bundle = DCVBundle(t);
        if (!bundle || ![approvedBundles containsObject:bundle]) return nil;
        NSInteger side = DCVSide(t);
        // No target means ask existing auto-slot resolver; never invent one.
        return @{@"action":@"open", @"identifier":bundle, @"slot":@(side)};
    }
    return nil;
}
