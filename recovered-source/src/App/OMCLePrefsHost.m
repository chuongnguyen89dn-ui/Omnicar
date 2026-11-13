// DuoCar's in-app Lề settings. The original LePrefs controller cannot
// atomically write Le's globally-owned JSON from DuoCar's app sandbox.
// Every row here uses an ACKed 64-bit request to the mobile SpringBoard
// receiver in DCLLeConfigBridge; never show a fake "saved" success.
#import "OMCLePrefsHost.h"
#import <UIKit/UIKit.h>
#import <notify.h>
#import <math.h>
#import <stdint.h>

static const char *const DCLLeReq="com.chuong.duocar/le024.cfg";
static const char *const DCLLeAck="com.chuong.duocar/le024.ack";
typedef struct {int key;const char *name;const char *kind;int def;
               const char *choices; } DCLLeRow;
static const DCLLeRow DCLLeRows[] = {
 {0,"Nguồn dữ liệu GPS / biển báo","choice",0,"VietMap Live|GOFA|Waze"},
 {1,"Tự đánh thức app nguồn","bool",0,NULL},
 {2,"Tự đóng nguồn sau ngắt CarPlay","bool",0,NULL},
 {3,"Cách hiện trên CarPlay","choice",0,"Maps + bong bóng|Chỉ Maps|Chỉ bong bóng|Ngoại trừ Dashboard"},
 {4,"Bật bong bóng giao thông","bool",1,NULL},
 {5,"Hiện trên CarPlay toàn màn","bool",1,NULL},
 {6,"Hiện trên iPhone","bool",0,NULL},
 {7,"Kiểu hiển thị","choice",0,"Lề (Halo)|Classic"},
 {8,"Bố cục bong bóng","choice",0,"Góc|Cạnh|Dải ngang|Thu gọn"},
 {9,"Nền bong bóng","choice",0,"Asphalt|Paint|Glass|Haze|Trong suốt"},
 {10,"Độ đậm nền","percent",85,NULL},
 {11,"Kích thước bong bóng","scale",100,NULL},
 {12,"Nhấp nháy khi quá tốc","bool",1,NULL},
 {13,"Các thành phần giao thông","modules",31,NULL},
 {14,"Thẻ Maps toàn màn","bool",1,NULL},
 {15,"Thẻ Maps Dashboard","bool",1,NULL},
 {16,"Thẻ Maps trên iPhone","bool",0,NULL},
 {17,"Vị trí thẻ Maps toàn màn","choice",1,"Trên trái|Trên phải|Dưới trái|Dưới phải"},
 {18,"Vị trí thẻ Maps Dashboard","choice",1,"Trên trái|Trên phải|Dưới trái|Dưới phải"},
 {19,"Vị trí thẻ Maps iPhone","choice",1,"Trên trái|Trên phải|Dưới trái|Dưới phải"},
 {20,"Cỡ thẻ Maps toàn màn","scale",100,NULL},
 {21,"Cỡ thẻ Maps Dashboard","scale",100,NULL},
 {22,"Cỡ thẻ Maps iPhone","scale",100,NULL},
 {23,"Bố cục thẻ Maps iPhone","choice",0,"Tự động|Ngang|Dọc"},
 {24,"Vệt sáng vượt tốc","choice",1,"Tắt|Google Maps|CarPlay"},
 {25,"Vị trí thẻ iPhone X","percent",0,NULL},
 {26,"Vị trí thẻ iPhone Y","percent",0,NULL},
 {27,"Hiệu chỉnh tốc độ GPS thực","offset",5,NULL},
 {28,"Kéo bong bóng tự do (X/Y)","bool",1,NULL},
 {29,"Sắp xếp mảnh bong bóng","order",0,NULL}
};
static const NSUInteger DCLCount=sizeof(DCLLeRows)/sizeof(DCLLeRows[0]);
static NSArray<NSString *> *DCLModules(void) {
    return @[@"Số tốc độ", @"Biển giới hạn", @"Icon nguồn",
             @"Làn đường", @"Biển sắp tới"];
}
static NSArray<NSNumber *> *DCLPermutation(int rank) {
    NSMutableArray *left=[NSMutableArray arrayWithArray:@[@0,@1,@2,@3,@4]];
    NSMutableArray *out=[NSMutableArray array];
    for(int remaining=5;remaining>=1;remaining--) {
        int fact=1;for(int k=2;k<remaining;k++)fact*=k;
        NSUInteger index=(NSUInteger)(rank/fact);
        if(index>=left.count)index=left.count-1;
        [out addObject:left[index]];[left removeObjectAtIndex:index];
        rank %= fact;
    }
    return out;
}
static int DCLRank(NSArray<NSNumber *> *order) {
    NSMutableArray *left=[NSMutableArray arrayWithArray:@[@0,@1,@2,@3,@4]];
    int rank=0;
    for(int n=0;n<5;n++) {
        NSUInteger idx=[left indexOfObject:order[n]];
        if(idx==NSNotFound)return 0;
        int f=1;for(int k=2;k<5-n;k++)f*=k;
        rank+=(int)idx*f;
        [left removeObjectAtIndex:idx];
    }
    return rank;
}
static NSString *DCLDescription(const DCLLeRow *row,int raw) {
    NSString *kind=[NSString stringWithUTF8String:row->kind];
    if([kind isEqualToString:@"bool"])return raw?@"Bật":@"Tắt";
    if([kind isEqualToString:@"choice"]) {
        NSArray *all=[[NSString stringWithUTF8String:row->choices] componentsSeparatedByString:@"|"];
        return (raw>=0 && raw<(int)all.count)?all[(NSUInteger)raw]:@"?";
    }
    if([kind isEqualToString:@"offset"])
        return [NSString stringWithFormat:@"%+d",raw-5];
    if([kind isEqualToString:@"percent"] || [kind isEqualToString:@"scale"])
        return [NSString stringWithFormat:@"%d%%",raw];
    if([kind isEqualToString:@"modules"]) {
        int count=__builtin_popcount((unsigned)raw & 31);
        return [NSString stringWithFormat:@"%d/5 mục",count];
    }
    if([kind isEqualToString:@"order"])return @"Nhấn để sắp xếp";
    return @"";
}
@interface DCLLeConfigPage : UITableViewController
@property(nonatomic,strong) NSMutableDictionary<NSNumber *,NSNumber *> *values;
@property(nonatomic,strong) NSMutableArray<NSDictionary *> *queue;
@property(nonatomic) int sendToken,ackToken;
@property(nonatomic) NSUInteger seq;
@property(nonatomic) BOOL busy;
@property(nonatomic,strong) NSTimer *deadline;
@property(nonatomic) BOOL bridgeFailed;
@property(nonatomic,strong) UILabel *message;
@end

@implementation DCLLeConfigPage
- (instancetype)init {
    if((self=[super initWithStyle:UITableViewStyleInsetGrouped])) {
        _values=[NSMutableDictionary dictionary];_queue=[NSMutableArray array];
        _sendToken=-1;_ackToken=-1;
        for(NSUInteger n=0;n<DCLCount;n++)_values[@(n)]=@(DCLLeRows[n].def);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Lề • Bong bóng tốc độ";
    self.tableView.backgroundColor=UIColor.systemGroupedBackgroundColor;
    UILabel *status=[[UILabel alloc]initWithFrame:CGRectMake(0,0,320,52)];
    status.textAlignment=NSTextAlignmentCenter;
    status.font=[UIFont systemFontOfSize:12];
    status.numberOfLines=2;
    status.text=@"Đang đọc cài đặt Lề qua SpringBoard…";
    self.tableView.tableHeaderView=status; self.message=status;
    __weak typeof(self) weakSelf=self;
    int result=notify_register_dispatch(DCLLeAck,&_ackToken,
                  dispatch_get_main_queue(),^(int token){
        typeof(self) owner=weakSelf;
        if(!owner)return;
        uint64_t reply=0;
        if(notify_get_state(token,&reply)==NOTIFY_STATUS_OK)
            [owner didReceive:reply];
    });
    if(result!=NOTIFY_STATUS_OK ||
       notify_register_check(DCLLeReq,&_sendToken)!=NOTIFY_STATUS_OK) {
        self.bridgeFailed=YES;
        status.text=@"Không tạo được kênh Lề. Các cài đặt chưa được thay đổi.";
        return;
    }
    for(NSUInteger n=0;n<DCLCount;n++)
        [self.queue addObject:@{@"key":@(n),@"read":@YES,@"value":@0}];
    [self nextRequest];
}
- (void)dealloc {
    [self.deadline invalidate];
    if(self.sendToken>=0)notify_cancel(self.sendToken);
    if(self.ackToken>=0)notify_cancel(self.ackToken);
}
- (NSArray<NSArray<NSNumber *> *> *)groups {
    return @[
     @[@0,@1,@2,@3],
     @[@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@29,@28],
     @[@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26],
     @[@27]];
}
- (NSArray<NSString *> *)titles {
    return @[@"Nguồn dữ liệu", @"Bong bóng nổi và cảnh báo",
             @"Thẻ trong Google Maps", @"Tốc độ thực xe đang chạy"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    (void)table;return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    (void)table;return self.groups[(NSUInteger)section].count;
}
- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
    (void)table;return self.titles[(NSUInteger)section];
}
- (NSString *)tableView:(UITableView *)table titleForFooterInSection:(NSInteger)section {
    (void)table;
    if(section==3)return @"Chỉ cộng/trừ vào số GPS đang chạy, không đổi biển giới hạn. 0 là không hiệu chỉnh.";
    if(section==1)return @"Lề giữ cơ chế biển báo, làn đường, cảnh báo và nguồn hiện có. Kéo bong bóng tới mọi vị trí an toàn.";
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    int key=self.groups[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row].intValue;
    const DCLLeRow *row=&DCLLeRows[key];
    int value=[self.values[@(key)] intValue];
    cell.textLabel.text=[NSString stringWithUTF8String:row->name];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.detailTextLabel.font=[UIFont monospacedDigitSystemFontOfSize:13 weight:UIFontWeightMedium];
    NSString *kind=[NSString stringWithUTF8String:row->kind];
    if([kind isEqualToString:@"bool"]) {
        UISwitch *sw=[UISwitch new];sw.on=value!=0;sw.tag=key;
        [sw addTarget:self action:@selector(toggled:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;
    } else if([kind isEqualToString:@"offset"] ||
              [kind isEqualToString:@"scale"] ||
              [kind isEqualToString:@"percent"]) {
        cell.detailTextLabel.text=DCLDescription(row,value);
        UIStepper *step=[UIStepper new];step.tag=key;
        step.minimumValue=[kind isEqualToString:@"offset"]?0:
                          [kind isEqualToString:@"scale"]?50:0;
        step.maximumValue=[kind isEqualToString:@"offset"]?10:
                          [kind isEqualToString:@"scale"]?200:100;
        step.stepValue=[kind isEqualToString:@"offset"]?1:5;
        step.value=value;
        step.continuous=NO;
        [step addTarget:self action:@selector(stepped:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=step;
    } else {
        cell.detailTextLabel.text=DCLDescription(row,value);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)enqueueKey:(int)key value:(int)value {
    if(self.bridgeFailed)return;
    [self.queue addObject:@{@"key":@(key),@"value":@(value),@"read":@NO}];
    [self nextRequest];
}
- (void)toggled:(UISwitch *)sender {[self enqueueKey:(int)sender.tag value:sender.on?1:0];}
- (void)stepped:(UIStepper *)sender {
    [self enqueueKey:(int)sender.tag value:(int)lround(sender.value)];
}
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
    int key=self.groups[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row].intValue;
    const DCLLeRow *row=&DCLLeRows[key];
    NSString *kind=[NSString stringWithUTF8String:row->kind];
    if([kind isEqualToString:@"choice"]) {
        UIAlertController *menu=[UIAlertController alertControllerWithTitle:
              [NSString stringWithUTF8String:row->name] message:nil
                                               preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *choices=[[NSString stringWithUTF8String:row->choices]
                                                  componentsSeparatedByString:@"|"];
        for(NSUInteger i=0;i<choices.count;i++) {
            NSUInteger index=i;
            [menu addAction:[UIAlertAction actionWithTitle:choices[i]
                style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                  (void)action;
                  [self enqueueKey:key value:(int)index];
                }]];
        }
        [menu addAction:[UIAlertAction actionWithTitle:@"Hủy"
             style:UIAlertActionStyleCancel handler:nil]];
        if(menu.popoverPresentationController)
            menu.popoverPresentationController.sourceView=[table cellForRowAtIndexPath:indexPath];
        [self presentViewController:menu animated:YES completion:nil];
    } else if([kind isEqualToString:@"modules"]) {
        NSMutableString *text=[NSMutableString string];
        int mask=[self.values[@(13)] intValue];
        NSArray *all=DCLModules();
        UIAlertController *menu=[UIAlertController alertControllerWithTitle:@"Các thành phần"
          message:@"Tắt/bật từng mục (Lề gốc giữ thứ tự)."
          preferredStyle:UIAlertControllerStyleActionSheet];
        for(NSUInteger i=0;i<all.count;i++) {
            int k=(int)i;
            NSString *label=[NSString stringWithFormat:@"%@ %@",
                 (mask & (1<<i))?@"✓":@"○",all[i]];
            [menu addAction:[UIAlertAction actionWithTitle:label
               style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 (void)action;
                 int newMask=[self.values[@(13)] intValue] ^ (1<<k);
                 [self enqueueKey:13 value:newMask];
               }]];
            [text appendFormat:@"%@ ",all[i]];
        }
        [menu addAction:[UIAlertAction actionWithTitle:@"Hủy" style:UIAlertActionStyleCancel handler:nil]];
        if(menu.popoverPresentationController)
            menu.popoverPresentationController.sourceView=[table cellForRowAtIndexPath:indexPath];
        [self presentViewController:menu animated:YES completion:nil];
    } else if([kind isEqualToString:@"order"]) {
        NSArray *order=DCLPermutation([self.values[@(29)] intValue]);
        UIAlertController *menu=[UIAlertController alertControllerWithTitle:@"Thứ tự mảnh"
            message:@"Đưa từng mục lên đầu; các lần chọn tiếp theo giữ thứ tự của các mục còn lại."
            preferredStyle:UIAlertControllerStyleActionSheet];
        for(NSNumber *number in order) {
            NSNumber *first=number;
            [menu addAction:[UIAlertAction actionWithTitle:DCLModules()[first.integerValue]
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                (void)action;
                NSMutableArray *all=[order mutableCopy];
                [all removeObject:first];
                [all insertObject:first atIndex:0];
                [self enqueueKey:29 value:DCLRank(all)];
            }]];
        }
        [menu addAction:[UIAlertAction actionWithTitle:@"Hủy"
                  style:UIAlertActionStyleCancel handler:nil]];
        if(menu.popoverPresentationController)
            menu.popoverPresentationController.sourceView=[table cellForRowAtIndexPath:indexPath];
        [self presentViewController:menu animated:YES completion:nil];
    }
}
- (void)nextRequest {
    if(self.busy||self.bridgeFailed||self.queue.count==0)return;
    self.busy=YES;
    NSDictionary *req=self.queue.firstObject;
    NSUInteger key=[req[@"key"] unsignedIntegerValue];
    BOOL query=[req[@"read"] boolValue];
    NSUInteger raw=[req[@"value"] unsignedIntegerValue]&0xffff;
    self.seq=(self.seq+1)&0xffff;
    uint64_t packet=(UINT64_C(0x4c45)<<48)|((uint64_t)self.seq<<32)|
      ((uint64_t)(key | (query?0x8000:0))<<16)|raw;
    if(notify_set_state(self.sendToken,packet)!=NOTIFY_STATUS_OK ||
       notify_post(DCLLeReq)!=NOTIFY_STATUS_OK) {
        [self failedRequest:@"Không thể gửi thay đổi tới SpringBoard."];
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self.deadline invalidate];
    self.deadline=[NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer *t){
        (void)t;[weakSelf failedRequest:@"Lề không phản hồi: cài đặt chưa được xác nhận."];
    }];
}
- (void)failedRequest:(NSString *)reason {
    if(!self.busy)return;
    NSDictionary *req=self.queue.firstObject;
    BOOL writing=req && ![req[@"read"] boolValue];
    self.busy=NO;self.bridgeFailed=YES;
    [self.deadline invalidate];self.deadline=nil;
    [self.queue removeAllObjects];
    self.message.text=reason;
    if(writing)[self showFailure:reason];
}
- (void)showFailure:(NSString *)reason {
    if(!self.view.window)return;
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Chưa lưu"
        message:reason preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceive:(uint64_t)packet {
    if((packet>>48)!=0xac49 || !self.busy || !self.queue.count ||
       ((packet>>32)&0xffff)!=self.seq)return;
    NSDictionary *request=self.queue.firstObject;
    NSUInteger key=[request[@"key"] unsignedIntegerValue];
    if(((packet>>16)&0xffff)!=key)return;
    BOOL query=[request[@"read"] boolValue];
    BOOL ok=(packet & 0x8000)==0;
    int raw=(int)(packet & 0x3fff);
    [self.deadline invalidate];self.deadline=nil;
    [self.queue removeObjectAtIndex:0];
    self.busy=NO;
    if(ok) {
        self.values[@(key)]=@(raw);
        if(!self.queue.count)self.message.text=@"Đã đọc / xác nhận Lề qua SpringBoard";
        [self.tableView reloadData];
        NSLog(@"[le024-config-ui] %@ key=%lu value=%d ACK",query?@"read":@"write",
              (unsigned long)key,raw);
        [self nextRequest];
    } else {
        if(!query)[self showFailure:@"Lề chưa ghi được cấu hình; lựa chọn cũ được giữ."];
        self.message.text=@"Không lưu được Lề; kiểm tra cấu hình quyền SpringBoard.";
        [self nextRequest];
    }
}
@end

BOOL OMCLeOriginalPreferencesAvailable(void) {
    return [[NSFileManager defaultManager] fileExistsAtPath:
       @"/var/jb/Library/PreferenceBundles/LePrefs.bundle/LePrefs"] ||
       [[NSFileManager defaultManager] fileExistsAtPath:
       @"/Library/PreferenceBundles/LePrefs.bundle/LePrefs"];
}
UIViewController *OMCLeOriginalPreferencesController(void) {
    // Show the in-app, ACKed configuration rather than load the vendor's
    // global-file writer into a sandbox where it cannot persist settings.
    NSLog(@"[le024-prefs] opening ACKed configuration owned by SpringBoard");
    return [[DCLLeConfigPage alloc] init];
}
