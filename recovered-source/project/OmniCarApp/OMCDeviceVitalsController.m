// DuoCar standalone iPhone settings page; shares the on-car sampler.
#import "OMCDeviceVitalsController.h"
#import "OMCDeviceVitals.h"

@interface OMCVitalsPage : UIViewController
@property(nonatomic,strong) UILabel *battery;
@property(nonatomic,strong) UILabel *temperature;
@property(nonatomic,strong) UILabel *thermal;
@property(nonatomic,strong) UILabel *source;
@property(nonatomic,strong) NSTimer *refreshTimer;
@end

@implementation OMCVitalsPage

- (UILabel *)lineWithSize:(CGFloat)size strong:(BOOL)strong {
    UILabel *label = [UILabel new];
    label.font = strong ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    label.textColor = UIColor.labelColor;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentNatural;
    label.adjustsFontForContentSizeCategory = YES;
    return label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pin và nhiệt độ";
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    UIStackView *stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 20;
    stack.alignment = UIStackViewAlignmentFill;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    self.battery = [self lineWithSize:22 strong:YES];
    self.temperature = [self lineWithSize:22 strong:YES];
    self.thermal = [self lineWithSize:17 strong:NO];
    self.source = [self lineWithSize:14 strong:NO];
    self.source.textColor = UIColor.secondaryLabelColor;
    [stack addArrangedSubview:self.battery];
    [stack addArrangedSubview:self.temperature];
    [stack addArrangedSubview:self.thermal];
    [stack addArrangedSubview:self.source];
    [self.view addSubview:stack];
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [stack.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:24],
        [stack.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-24],
        [stack.topAnchor constraintEqualToAnchor:guide.topAnchor constant:24]
    ]];

    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeSystem];
    [refresh setTitle:@"Làm mới" forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(updateVitals) forControlEvents:UIControlEventTouchUpInside];
    refresh.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    refresh.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:refresh];
    [NSLayoutConstraint activateConstraints:@[
        [refresh.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [refresh.topAnchor constraintEqualToAnchor:stack.bottomAnchor constant:24]
    ]];
    [self updateVitals];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateVitals];
    [self.refreshTimer invalidate];
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:12.0
        target:self selector:@selector(updateVitals) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (void)dealloc {
    [self.refreshTimer invalidate];
}

- (void)updateVitals {
    NSDictionary *sample = OMCDeviceVitalsSample();
    NSNumber *battery = [sample[@"batteryPercent"] isKindOfClass:NSNumber.class]
        ? sample[@"batteryPercent"] : nil;
    NSString *batteryStatus = sample[@"batteryState"];
    NSString *charging = [batteryStatus isEqualToString:@"charging"]
        ? @" • Đang sạc" : [batteryStatus isEqualToString:@"full"]
        ? @" • Đã đầy" : @"";
    self.battery.text = battery
        ? [NSString stringWithFormat:@"🔋 Pin iPhone: %ld%%%@", (long)battery.integerValue, charging]
        : @"🔋 Pin iPhone: Chưa có dữ liệu";

    NSNumber *temp = [sample[@"temperatureCelsius"] isKindOfClass:NSNumber.class]
        ? sample[@"temperatureCelsius"] : nil;
    NSString *kind = sample[@"temperatureKind"];
    NSString *name = [kind isEqualToString:@"battery"]
        ? @"Nhiệt độ pin (tham khảo)" : @"Nhiệt độ cảm biến (tham khảo)";
    self.temperature.text = temp
        ? [NSString stringWithFormat:@"🌡 %@: ~%.1f°C",name,temp.doubleValue]
        : @"🌡 Nhiệt độ °C: Không đọc được cảm biến";
    self.thermal.text = [NSString stringWithFormat:@"Mức nhiệt iOS: %@",
        OMCDeviceVitalsThermalDescription(sample[@"thermalState"])];
    self.source.text = [NSString stringWithFormat:
        @"Nguồn: %@\n"
        @"Đơn vị/hiệu chuẩn cảm biến chưa được xác minh trên thiết bị. "
        @"Không phải nhiệt độ GPU. Không suy ra °C từ mức nhiệt iOS.\n"
        @"Tự làm mới mỗi 12 giây.",
        sample[@"temperatureSource"]];
}

@end

UIViewController *OMCDeviceVitalsController(void) {
    return [OMCVitalsPage new];
}
