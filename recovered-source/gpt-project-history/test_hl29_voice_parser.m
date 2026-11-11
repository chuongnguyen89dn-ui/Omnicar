// Link actual production parser with macOS Foundation in CI.
#import <Foundation/Foundation.h>
#import "../project/OmniCarApp/DCVoiceCommand.h"
static NSUInteger checks=0;
static void Check(NSString *text, NSSet *approved, NSDictionary *expected) {
    NSDictionary *actual=DCVoiceParseCommand(text,approved);
    if ((actual==nil)!=(expected==nil) || (actual && ![actual isEqual:expected])) {
        NSLog(@"HL29_VOICE_PARSER_FAIL input=%@ expected=%@ got=%@",text,expected,actual);
        exit(1);
    }
    ++checks;
}
int main(void) {
    @autoreleasepool {
        NSSet *all=[NSSet setWithArray:@[@"com.google.ios.youtube",
          @"com.google.Maps",@"com.ss.iphone.ugc.Ame",@"com.facebook.Facebook"]];
        NSSet *none=[NSSet set];
        Check(@"Mở YouTube bên trái",all,@{@"action":@"open",
            @"identifier":@"com.google.ios.youtube",@"slot":@0});
        Check(@"mo YouTube ben phai",all,@{@"action":@"open",
            @"identifier":@"com.google.ios.youtube",@"slot":@1});
        Check(@"Mở Google Maps bên trái",all,@{@"action":@"open",
            @"identifier":@"com.google.Maps",@"slot":@0});
        Check(@"Mở TikTok",all,@{@"action":@"open",
            @"identifier":@"com.ss.iphone.ugc.Ame",@"slot":@(-1)});
        Check(@"Mở Facebook",all,@{@"action":@"open",
            @"identifier":@"com.facebook.Facebook",@"slot":@(-1)});
        Check(@"Đổi chỗ hai ô",none,@{@"action":@"swap"});
        Check(@"chia 60/40",none,@{@"action":@"ratio",@"r":@0.6});
        Check(@"Chia 50/50",none,@{@"action":@"ratio",@"r":@0.5});
        Check(@"Chia 2 ô",none,@{@"action":@"layout",@"id":@2});
        Check(@"Chia 3 ô",none,@{@"action":@"layout",@"id":@3});
        Check(@"Bố cục chữ L",none,@{@"action":@"layout",@"id":@13});
        Check(@"Phóng to ô bên phải",none,@{@"action":@"zoom",@"pane":@2});
        Check(@"Bố cục yêu thích số 1",none,@{@"action":@"fav",@"index":@1});
        // Independent negative tests. No arbitrary app, negative command,
        // spoofed URL, stale/unmatched slot or invalid ratio may be parsed.
        for (NSString *bad in @[
           @"Mở YouTube bên trái", @"Không mở YouTube",
           @"Đừng mở TikTok", @"Mở YouTube bên trái và bên phải",
           @"Chia 15/85", @"Chia 90/10", @"Chia 25/25",
           @"Tắt hết app", @"Respring", @"Xoá dữ liệu",
           @"Open http://example.com", @"Chạy shell",
           @"Cấp quyền hệ thống", @"Mở ứng dụng bí ẩn",
           @"Mở URL", @"Chạy lệnh Siri" ]) {
            Check(bad,none,nil);
        }
        Check(@"Không mở YouTube",all,nil);
        Check(@"Mở Facebook bên trái và bên phải",all,nil);
        NSLog(@"HL29_VOICE_PARSER_PASS checks=%lu", (unsigned long)checks);
    }
    return 0;
}
