// Tests the ACTUAL shared ABTelexApply linked from ABTelex.m, then exercises
// the exact delete-old-word/insert-new-word sequence ABKeyboard.typeCharacter
// uses for BOTH hosted and native. No duplicate/mock Telex implementation.
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
NSString *ABTelexApply(NSString *word, NSString *keyString);

static NSUInteger checks=0;
static void Fail(NSString *name, NSString *actual, NSString *expected) {
    fprintf(stderr,"TELEX_FAIL %s got=%s expected=%s\n",
        name.UTF8String,actual.UTF8String,expected.UTF8String);
    exit(1);
}
static void Check(NSString *label, NSString *actual, NSString *expected) {
    checks++;
    if (actual != expected && ![actual isEqualToString:expected])
        Fail(label,actual ?: @"(nil)",expected ?: @"(nil)");
}
static NSString *TypeLikeABKeyboard(NSString *keys, BOOL vietnamese) {
    NSMutableString *word=[NSMutableString string], *text=[NSMutableString string];
    for (NSUInteger i=0;i<keys.length;i++) {
        NSString *key=[keys substringWithRange:NSMakeRange(i,1)];
        NSString *result=(vietnamese && word.length+1<=11)
            ? ABTelexApply(word,key) : nil;
        BOOL letter=[[NSCharacterSet letterCharacterSet]
                     characterIsMember:[key characterAtIndex:0]];
        if (result) {
            // Same del:oldWordLen / text:replacement as ABKeyboard.
            NSUInteger previous=word.length;
            if (text.length<previous) {
                fprintf(stderr,"TELEX_BUFFER_UNDERFLOW at key=%lu\n",(unsigned long)i);
                exit(2);
            }
            [text deleteCharactersInRange:NSMakeRange(text.length-previous,previous)];
            [text appendString:result];
            [word setString:result];
        } else {
            [text appendString:key];
            if (letter) [word appendString:key]; else [word setString:@""];
        }
        checks++;
    }
    return text;
}
static void TestInput(NSString *keys, NSString *expected) {
    Check(keys,TypeLikeABKeyboard(keys,YES),expected);
}
int main(void) {
    @autoreleasepool {
        // Direct API checks: tones, family conversion, removal and escapes.
        Check(@"single-tone",ABTelexApply(@"a",@"s"),@"á");
        Check(@"tone-empty",ABTelexApply(@"",@"s"),nil);
        Check(@"tone-change",ABTelexApply(@"à",@"s"),@"á");
        Check(@"tone-remove",ABTelexApply(@"ạ",@"z"),@"a");
        Check(@"tone-capital",ABTelexApply(@"A",@"s"),@"Á");
        Check(@"nonmodifier",ABTelexApply(@"c",@"s"),nil);
        Check(@"negative-empty",ABTelexApply(@"c",@"x"),nil);
        Check(@"no-nonletter-crash",ABTelexApply(@"abc",@"/"),nil);
        Check(@"aa",ABTelexApply(@"a",@"a"),@"â");
        Check(@"dd",ABTelexApply(@"d",@"d"),@"đ");
        Check(@"aw",ABTelexApply(@"a",@"w"),@"ă");
        Check(@"uo+w",ABTelexApply(@"uo",@"w"),@"ươ");
        Check(@"repeat-tone",ABTelexApply(@"á",@"s"),@"as");
        // Full end-to-end composition and replacement, not a static
        // function signature or an independently reimplemented algorithm.
        TestInput(@"as",@"á");
        TestInput(@"af",@"à");
        TestInput(@"ar",@"ả");
        TestInput(@"ax",@"ã");
        TestInput(@"aj",@"ạ");
        TestInput(@"az",@"az");
        TestInput(@"asz",@"a");
        TestInput(@"aaf",@"ầ");
        TestInput(@"aas",@"ấ");
        TestInput(@"awf",@"ằ");
        TestInput(@"aws",@"ắ");
        TestInput(@"ees",@"ế");
        TestInput(@"oos",@"ố");
        TestInput(@"ows",@"ớ");
        TestInput(@"uws",@"ứ");
        TestInput(@"dd",@"đ");
        TestInput(@"DD",@"Đ");
        TestInput(@"ddd",@"dd");
        TestInput(@"dduowngf",@"đường");
        TestInput(@"tieengs",@"tiếng");
        TestInput(@"Tieengs",@"Tiếng");
        TestInput(@"VIEETJ",@"VIỆT");
        TestInput(@"nguyeenx",@"nguyễn");
        TestInput(@"bieets",@"biết");
        TestInput(@"ddaauf",@"đầu");
        TestInput(@"chaof",@"chào");
        TestInput(@"hoaf",@"hòa");
        TestInput(@"khoer",@"khỏe");
        TestInput(@"quas",@"quá");
        TestInput(@"giaf",@"già");
        TestInput(@"ngayf",@"ngày");
        TestInput(@"aass",@"âs");
        TestInput(@"afs",@"á");
        TestInput(@"awfz",@"ă");
        TestInput(@"tieengs Vieetj",@"tiếng Việt");
        Check(@"EN-unmodified",TypeLikeABKeyboard(@"as dd tieengs",NO),@"as dd tieengs");
        // Repeat each stress target to assert deterministic results.
        for(NSUInteger i=0;i<2000;i++){
            NSString *got=TypeLikeABKeyboard(@"tieengs Vieetj",YES);
            if (![got isEqualToString:@"tiếng Việt"]) Fail(@"repeat",got,@"tiếng Việt");
        }
        printf("HL43_TELEX_PASS actual shared ABTelexApply + key transport simulation; checks=%lu\n",
            (unsigned long)checks);
    }
    return 0;
}
