// SBFlutter.m — SpeedBubble SOURCE-APP side (agent B, wave 2.5)
// Flutter method-channel interception: how speed-limit values are pulled
// out of a Flutter host app's platform messages (Vietmap in practice).
// OmniCarSpeedBubble.dylib (arm64). VERIFIED from disassembly unless
// marked. Dynamic selectors are used throughout the original because the
// dylib links no Flutter headers; missing pieces are reported through
// OMCMissingSelector inside @try/@catch (micro-detail INFERRED).

#import "SBSourceGlobals.h"
#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <objc/runtime.h>
#import <string.h>

typedef void (^SPPFlutterBinaryReply)(NSData *);
typedef void (^SPPFlutterBinaryMessageHandler)(NSData *, SPPFlutterBinaryReply);

BOOL SPPIsNumericString(NSString *s); // sub_7904, below
static void SPPExtract(id obj, NSString *key, int depth, int *limitOut,
                       NSString **keyOut, int *speedOut); // sub_733c

#pragma mark - sub_7904 SPPIsNumericString — VERIFIED

// YES iff length is 1..3 and every character is an ASCII digit.
BOOL SPPIsNumericString(NSString *s) {
    NSUInteger length = s.length;
    if (length < 1 || length > 3) {
        return NO;
    }
    for (NSUInteger i = 0; i < length; i++) {
        unichar c = [s characterAtIndex:i];
        if (c < '0' || c > '9') {
            return NO;
        }
    }
    return YES;
}

#pragma mark - sub_733c SPPExtract — VERIFIED (structure + constants)

// Recursive key/value miner over decoded Flutter method-call arguments.
//  - NSDictionary: recurse into each value, key = the entry key's
//    -description, depth + 1.
//  - NSArray: recurse into each element with the same key.
//  - NSString of length 2..8191 whose first character is '{' or '['
//    (tested as (c & 0xDF) == 0x5B): parsed as JSON and recursed into.
//  - Leaf: NSNumber -> intValue; NSString -> intValue when the trimmed
//    string is purely numeric (SPPIsNumericString), else INT_MIN;
//    anything else -> INT_MIN.
// Limit rule (lowercased key contains "limit", "maxspeed" or
// "max_speed"): an NSNull leaf or value 0 records limit 0; a value in
// 5..200 records that limit; the producing key is returned via keyOut.
// Speed rule: value <= 300 (unsigned test, so negatives/INT_MIN are
// excluded) and key == "speed" or lowercased key contains
// "currentspeed"/"current_speed" records *speedOut.
static void SPPExtract(id obj, NSString *key, int depth, int *limitOut,
                       NSString **keyOut, int *speedOut) {
    if (!obj || depth > 8) {
        return;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        for (id k in (NSDictionary *)obj) {
            SPPExtract(((NSDictionary *)obj)[k], [k description], depth + 1,
                       limitOut, keyOut, speedOut);
        }
        return;
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        for (id element in (NSArray *)obj) {
            SPPExtract(element, key, depth + 1, limitOut, keyOut, speedOut);
        }
        return;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *s = (NSString *)obj;
        NSUInteger length = s.length;
        if (length >= 2 && length <= 8191 &&
            ([s characterAtIndex:0] & 0xDF) == 0x5B) {
            NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
            id parsed = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:nil];
            if (parsed) {
                SPPExtract(parsed, key, depth + 1, limitOut, keyOut,
                           speedOut);
            }
            return;
        }
    }

    if (!key) {
        return;
    }
    int value;
    if ([obj isKindOfClass:[NSNumber class]]) {
        value = [(NSNumber *)obj intValue];
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSString *trimmed = [(NSString *)obj
            stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        value = SPPIsNumericString(trimmed) ? [trimmed intValue] : INT_MIN;
    } else {
        value = INT_MIN;
    }

    NSString *lowerKey = [key lowercaseString];
    if ([lowerKey containsString:@"limit"] ||
        [lowerKey containsString:@"maxspeed"] ||
        [lowerKey containsString:@"max_speed"]) {
        if (obj == [NSNull null] || value == 0) {
            *limitOut = 0;
            *keyOut = key;
        } else if (value >= 5 && value <= 200) {
            *limitOut = value;
            *keyOut = key;
        }
    }
    if ((uint32_t)value <= 300 &&
        ([key isEqualToString:@"speed"] ||
         [lowerKey containsString:@"currentspeed"] ||
         [lowerKey containsString:@"current_speed"])) {
        *speedOut = value;
    }
}

#pragma mark - sub_6aa0 SPPHandleFlutterMessage — VERIFIED

// Parses one intercepted message. Payloads of length 0 or > 4096 are
// dropped. Each known codec class (FlutterStandardMethodCodec, then
// FlutterJSONMethodCodec) is tried via NSClassFromString + the dynamic
// selectors sharedInstance / decodeMethodCall: / method / arguments.
// A one-per-(channel, method) discovery log (set capped at 299 entries)
// prints the arguments description, newlines flattened, truncated at
// 200 characters + "...". A changed extracted limit is committed to
// SPPFlutterLimit with the current time and a "channel/key" provenance
// string. (Trying stops at the first codec that yields a call whose
// method is an NSString — INFERRED.)
static void SPPHandleFlutterMessage(NSString *channel, NSData *data) {
    if (data.length == 0 || data.length > 4096) {
        return;
    }
    NSArray *codecNames = @[ @"FlutterStandardMethodCodec",
                             @"FlutterJSONMethodCodec" ];
    for (NSString *codecName in codecNames) {
        Class codecClass = NSClassFromString(codecName);
        if (!codecClass) {
            continue;
        }
        id codec = nil;
        id call = nil;
        @try {
            codec = [codecClass performSelector:
                                    NSSelectorFromString(@"sharedInstance")];
            call = [codec performSelector:NSSelectorFromString(
                                              @"decodeMethodCall:")
                               withObject:data];
        } @catch (id exception) {
            continue;
        }
        if (!call) {
            continue;
        }
        id method = nil;
        id arguments = nil;
        @try {
            method = [call performSelector:NSSelectorFromString(@"method")];
            arguments =
                [call performSelector:NSSelectorFromString(@"arguments")];
        } @catch (id exception) {
            continue;
        }
        if (![method isKindOfClass:[NSString class]]) {
            continue;
        }

        if (!SPPSeenChannelMethods) {
            SPPSeenChannelMethods = [NSMutableSet set];
        }
        NSString *seenKey =
            [NSString stringWithFormat:@"%@/%@", channel, method];
        if (![SPPSeenChannelMethods containsObject:seenKey] &&
            SPPSeenChannelMethods.count < 299) {
            [SPPSeenChannelMethods addObject:seenKey];
            NSString *desc = [[arguments description]
                stringByReplacingOccurrencesOfString:@"\n"
                                          withString:@" "];
            if (desc.length > 200) {
                desc = [[desc substringToIndex:200]
                    stringByAppendingString:@"..."];
            }
            SPPLog(@"kenh %@ %@: %@", channel, method, desc);
        }

        int limit = -1;
        int speed = -1; // extracted but unused at this call site (VERIFIED:
                        // sub_6aa0 passes &speed yet only reads the limit)
        NSString *foundKey = nil;
        SPPExtract(arguments, method, 0, &limit, &foundKey, &speed);
        if (foundKey &&
            (limit != SPPFlutterLimit || SPPFlutterLimitKey == nil)) {
            SPPLog(@"kenh: gioi han %d (%@ / %@)", limit, channel, foundKey);
            SPPFlutterLimit = limit <= 0 ? -1 : limit;
            SPPFlutterLimitTime = CFAbsoluteTimeGetCurrent();
            SPPFlutterLimitKey =
                [NSString stringWithFormat:@"%@/%@", channel, foundKey];
        }
        return;
    }
}

#pragma mark - sub_6968 wrapped handler — VERIFIED

// The block that replaces a wrapped channel handler. The message is
// copied and parsed on the main queue; the ORIGINAL handler is then
// always invoked with the ORIGINAL (message, reply) — interception is
// observational, it never swallows or alters traffic.
static SPPFlutterBinaryMessageHandler
SPPWrappedHandler(NSString *channel,
                  SPPFlutterBinaryMessageHandler original) {
    return ^(NSData *message, SPPFlutterBinaryReply reply) {
        NSData *copy = [message copy];
        if ([NSThread isMainThread]) {
            SPPHandleFlutterMessage(channel, copy);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                SPPHandleFlutterMessage(channel, copy);
            });
        }
        original(message, reply);
    };
}

#pragma mark - sub_67e0 SPPWrapHandler — VERIFIED

// Wrap decision. No wrap when channel or handler is nil, when the host
// is Wyn (index 3), or when the channel is in the once-built exclusion
// set {"vml_main_channel"} (sub_72f4 once-block). The set name in the
// original suggests the opposite ("watched"); the disassembly is
// unambiguous — membership SKIPS wrapping. Intent INFERRED: the known
// main channel is deliberately left alone (its traffic is presumably
// understood/handled, or too hot to log).
id SPPWrapHandler(id channel, id handler) {
    if (!channel || !handler) {
        return handler;
    }
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        SPPWatchedChannelExclusions =
            [NSSet setWithObjects:@"vml_main_channel", nil];
    });
    if (SPPHostIndex == 3 ||
        [SPPWatchedChannelExclusions containsObject:channel]) {
        return handler;
    }
    SPPLog(@"kenh: nghe %@", channel);
    return SPPWrappedHandler(channel, handler);
}
