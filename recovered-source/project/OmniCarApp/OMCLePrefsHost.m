// HL58: DuoCar controls ONLY two optional features of a separately
// installed Lề (dev.bechou.le 0.2.4). We do NOT load original LePrefs,
// impersonate its settings, draw a traffic bubble, or reset vendor JSON.
// All writes are ACKed by our SpringBoard owner (not vendor-owned state).
#import "OMCLePrefsHost.h"
#import "OMCApexStyle.h"
#import <UIKit/UIKit.h>
#import <notify.h>
#import <stdint.h>
#import <math.h>

static const char *const DCLReq="com.chuong.duocar/le024.cfg";
static const char *const DCLAck="com.chuong.duocar/le024.ack";
BOOL OMCLeOriginalPreferencesAvailable(void) {
    NSFileManager *fm=NSFileManager.defaultManager;
    return [fm fileExistsAtPath:
      @"/var/jb/Library/MobileSubstrate/DynamicLibraries/LeBubble.dylib"] ||
           [fm fileExistsAtPath:
      @"/Library/MobileSubstrate/DynamicLibraries/LeBubble.dylib"];
}
@interface DCLLeStandaloneControls : UITableViewController
@property(nonatomic,strong) NSMutableArray<NSDictionary *> *queue;
@property(nonatomic,strong) NSMutableSet<NSNumber *> *verified;
@property(nonatomic,strong) NSMutableDictionary<NSNumber *,NSNumber *> *values;
@property(nonatomic,strong) UILabel *status;
@property(nonatomic) int sendToken,ackToken;
@property(nonatomic) NSUInteger seq;
@property(nonatomic) BOOL busy,bridgeFailed;
@property(nonatomic,strong) NSTimer *timeout;
@end
@implementation DCLLeStandaloneControls
- (instancetype)init {
    if((self=[super initWithStyle:UITableViewStyleInsetGrouped])){
        _sendToken=-1;_ackToken=-1;
        _queue=[NSMutableArray array];
        _verified=[NSMutableSet set];
        _values=[@{@4:@1,@27:@10} mutableCopy];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"DuoCar • Lề cài riêng";
    self.tableView.backgroundColor=OMCApexSurfaceRoot();
    UILabel *message=[[UILabel alloc]initWithFrame:CGRectMake(0,0,330,68)];
    message.font=[UIFont systemFontOfSize:12];
    message.textAlignment=NSTextAlignmentCenter;
    message.numberOfLines=3;
    message.textColor=OMCApexTextSecondary();
    message.text=OMCLeOriginalPreferencesAvailable()?
        @"Đã phát hiện Lề riêng. Đang đọc hai công tắc DuoCar…":
        @"Chưa phát hiện Lề riêng. Có thể lưu lựa chọn trước; hiệu lực khi Lề được cài và nạp lại.";
    self.tableView.tableHeaderView=message;
    self.status=message;
    __weak typeof(self) weakSelf=self;
    int result=notify_register_dispatch(DCLAck,&_ackToken,
          dispatch_get_main_queue(),^(int token) {
        DCLLeStandaloneControls *owner=weakSelf;
        uint64_t packet=0;
        if(owner && notify_get_state(token,&packet)==NOTIFY_STATUS_OK)
            [owner didReceive:packet];
    });
    if(result!=NOTIFY_STATUS_OK ||
       notify_register_check(DCLReq,&_sendToken)!=NOTIFY_STATUS_OK) {
        self.bridgeFailed=YES;
        self.status.text=@"Chưa kết nối được SpringBoard. Không thể lưu.";
        [self.tableView reloadData];
        return;
    }
    for(NSNumber *key in @[@4,@27])
        [self.queue addObject:@{@"key":key,@"read":@YES,@"raw":@0}];
    [self nextRequest];
}
- (void)dealloc {
    [self.timeout invalidate];
    if(self.sendToken>=0)notify_cancel(self.sendToken);
    if(self.ackToken>=0)notify_cancel(self.ackToken);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    (void)table;return 2;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    (void)table;(void)section;return 1;
}
- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
    (void)table;
    return section==0?@"Bật/tắt bong bóng Lề":@"Hiệu chỉnh tốc độ GPS";
}
- (NSString *)tableView:(UITableView *)table titleForFooterInSection:(NSInteger)section {
    (void)table;
    return section==0?
      @"Chỉ ẩn/hiện bong bóng của Lề cài riêng. Không can thiệp nguồn VietMap/Waze, bố cục, kéo hay cặp mép của Lề.":
      @"Thanh trượt −10 đến +10, bước 1. Chỉ cộng vào số tốc độ đang chạy; biển giới hạn tốc độ giữ nguyên. Cần Lề riêng 0.2.4 và nạp lại SpringBoard/CarPlay để có hiệu lực.";
}
- (void)tableView:(UITableView *)table willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    (void)table;(void)section;
    if([view isKindOfClass:UITableViewHeaderFooterView.class])
        ((UITableViewHeaderFooterView *)view).textLabel.textColor=OMCApexTextSecondary();
}
- (void)tableView:(UITableView *)table willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    (void)table;(void)section;
    if([view isKindOfClass:UITableViewHeaderFooterView.class])
        ((UITableViewHeaderFooterView *)view).textLabel.textColor=OMCApexTextSecondary();
}
- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)index {
    (void)table;return index.section==1?112.0:52.0;
}
- (UITableViewCell *)tableView:(UITableView *)table
         cellForRowAtIndexPath:(NSIndexPath *)index {
    BOOL ready=!self.bridgeFailed &&
       [self.verified containsObject:@(index.section==0?4:27)];
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=OMCApexSurface1();
    if(index.section==0) {
        cell.textLabel.text=@"Hiển thị bong bóng";
        cell.textLabel.textColor=OMCApexTextPrimary();
        UISwitch *sw=[UISwitch new];
        sw.onTintColor=OMCApexTeal();
        sw.on=[self.values[@4] boolValue];
        sw.enabled=ready;
        sw.accessibilityLabel=@"Bật/tắt bong bóng Lề cài riêng";
        [sw addTarget:self action:@selector(masterChanged:)
            forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;
        return cell;
    }
    UILabel *label=[UILabel new];
    label.text=@"Hiệu chỉnh GPS";
    label.textColor=OMCApexTextPrimary();
    label.font=[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    UILabel *value=[UILabel new];
    int raw=[self.values[@27] intValue];
    value.text=[NSString stringWithFormat:@"%+d km/h",MAX(-10,MIN(10,raw-10))];
    value.tag=5827;
    value.font=[UIFont monospacedDigitSystemFontOfSize:15
                                           weight:UIFontWeightSemibold];
    value.textColor=OMCApexAccent();
    UIStackView *title=[[UIStackView alloc]
                        initWithArrangedSubviews:@[label,value]];
    title.axis=UILayoutConstraintAxisHorizontal;
    title.distribution=UIStackViewDistributionEqualSpacing;
    UISlider *slider=[UISlider new];
    slider.minimumTrackTintColor=OMCApexTeal();
    slider.maximumTrackTintColor=OMCApexSurface3();
    slider.minimumValue=-10;slider.maximumValue=10;
    slider.value=raw-10;slider.enabled=ready;
    slider.accessibilityLabel=@"Bù tốc độ GPS đang chạy";
    slider.accessibilityValue=value.text;
    slider.continuous=YES;
    [slider addTarget:self action:@selector(gpsChanged:)
          forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(gpsEnded:)
          forControlEvents:(UIControlEventTouchUpInside|
                            UIControlEventTouchUpOutside)];
    UILabel *left=[UILabel new];left.text=@"−10";
    UILabel *zero=[UILabel new];zero.text=@"0";
    UILabel *right=[UILabel new];right.text=@"+10";
    for(UILabel *l in @[left,zero,right]) {
        l.font=[UIFont monospacedDigitSystemFontOfSize:11
                                                weight:UIFontWeightRegular];
        l.textColor=OMCApexTextSecondary();
    }
    UIStackView *marks=[[UIStackView alloc]
           initWithArrangedSubviews:@[left,zero,right]];
    marks.axis=UILayoutConstraintAxisHorizontal;
    marks.distribution=UIStackViewDistributionEqualSpacing;
    UIStackView *stack=[[UIStackView alloc]
           initWithArrangedSubviews:@[title,slider,marks]];
    stack.axis=UILayoutConstraintAxisVertical;stack.spacing=4;
    stack.translatesAutoresizingMaskIntoConstraints=NO;
    [cell.contentView addSubview:stack];
    [NSLayoutConstraint activateConstraints:@[
      [stack.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
      [stack.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16],
      [stack.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor]
    ]];
    return cell;
}
- (void)enqueueKey:(NSUInteger)key raw:(NSUInteger)raw {
    if(self.bridgeFailed||![self.verified containsObject:@(key)])return;
    for(NSInteger i=(NSInteger)self.queue.count-1;i>=0;i--) {
        NSDictionary *q=self.queue[(NSUInteger)i];
        if([q[@"key"] unsignedIntegerValue]==key && ![q[@"read"] boolValue] &&
           (self.busy==NO || i>0)) [self.queue removeObjectAtIndex:(NSUInteger)i];
    }
    [self.queue addObject:@{@"key":@(key),@"raw":@(raw),@"read":@NO}];
    [self nextRequest];
}
- (void)masterChanged:(UISwitch *)sw {
    [self enqueueKey:4 raw:(sw.isOn?1:0)];
}
- (void)gpsChanged:(UISlider *)slider {
    int offset=(int)lround(slider.value);
    UIView *item=slider.superview;
    while(item && ![item isKindOfClass:UITableViewCell.class])item=item.superview;
    UILabel *value=(UILabel *)[item viewWithTag:5827];
    if([value isKindOfClass:UILabel.class])
        value.text=[NSString stringWithFormat:@"%+d km/h",offset];
}
- (void)gpsEnded:(UISlider *)slider {
    [self enqueueKey:27 raw:(NSUInteger)((int)lround(slider.value)+10)];
}
- (void)nextRequest {
    if(self.busy || self.bridgeFailed || !self.queue.count)return;
    NSDictionary *req=self.queue.firstObject;
    NSUInteger key=[req[@"key"] unsignedIntegerValue];
    BOOL query=[req[@"read"] boolValue];
    NSUInteger raw=[req[@"raw"] unsignedIntegerValue]&0xffff;
    self.seq=(self.seq+1)&0xffff;
    uint64_t payload=(UINT64_C(0x4c45)<<48)|
        ((uint64_t)self.seq<<32)|
        ((uint64_t)(key|(query?0x8000:0))<<16)|raw;
    self.busy=YES;
    if(notify_set_state(self.sendToken,payload)!=NOTIFY_STATUS_OK ||
       notify_post(DCLReq)!=NOTIFY_STATUS_OK) {
        [self failWithMessage:@"SpringBoard không nhận lệnh; chưa lưu."];
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self.timeout invalidate];
    self.timeout=[NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO
          block:^(NSTimer *t) {
        (void)t;
        [weakSelf failWithMessage:@"Không nhận được xác nhận từ SpringBoard."];
    }];
}
- (void)failWithMessage:(NSString *)message {
    if(!self.busy)return;
    self.busy=NO;self.bridgeFailed=YES;
    [self.timeout invalidate];self.timeout=nil;
    [self.queue removeAllObjects];
    self.status.text=message;
    [self.tableView reloadData];
}
- (void)didReceive:(uint64_t)packet {
    if(!self.busy || !self.queue.count || (packet>>48)!=0xac49 ||
       ((packet>>32)&0xffff)!=self.seq)return;
    NSDictionary *req=self.queue.firstObject;
    NSUInteger key=[req[@"key"] unsignedIntegerValue];
    if(((packet>>16)&0xffff)!=key)return;
    BOOL ok=(packet&0x8000)==0;
    int raw=(int)(packet&0x3fff);
    self.busy=NO;
    [self.timeout invalidate];self.timeout=nil;
    [self.queue removeObjectAtIndex:0];
    if(!ok) {
        [self failWithMessage:@"Lệnh Lề không được xác nhận. Giá trị cũ được giữ."];
        self.bridgeFailed=YES;
        self.status.text=@"Cài đặt không lưu; dữ liệu đã xác nhận trước đó vẫn được giữ.";
        [self.tableView reloadData];
        return;
    }
    [self.verified addObject:@(key)];
    self.values[@(key)]=@(raw);
    [self.tableView reloadData];
    if(!self.queue.count)self.status.text=OMCLeOriginalPreferencesAvailable()?
        @"Đã lưu cài đặt DuoCar. Lề cài riêng tự quản lý giao diện và nguồn.":
        @"Đã lưu hai lựa chọn DuoCar. Cài Lề riêng 0.2.4 để áp dụng.";
    [self nextRequest];
}
@end
UIViewController *OMCLeCompatiblePreferencesController(void){
    return [DCLLeStandaloneControls new];
}
UIViewController *OMCLeOriginalPreferencesController(void){
    // Historical navigation ABI; no embedded LePrefs UI in DuoCar anymore.
    return [DCLLeStandaloneControls new];
}
