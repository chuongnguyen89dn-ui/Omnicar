//  SCPRadialControlView.m
//  DuoCar V3 P4/G2 — OmniCarSplitScreen.dylib
//
//  Geometry (G1 contract D): five sectors of 72 deg each, sector 0
//  (Replace) centred straight up (-90 deg), order clockwise. Drawn arc
//  is 70 deg (2 deg visual gap between neighbours); the HIT wedge is
//  the full 72 deg so adjacent sectors never overlap and no dead ring
//  appears between them. Sectors are the annulus from core radius
//  0.34R to R; inside the core is the centre-logo tap target, outside
//  R the view does not claim the point at all (pointInside:), so the
//  app content around the popup keeps its touches.
//
//  Theme (G1 contract D, solid colours — no blur, no mesh): face
//  #1B1138, raised/pressed #28194D, selected #A16EFF, rim #DBB9FF,
//  primary text #F5F0FF, secondary #C7B8E4, centre face #100923.
//  Close uses the UI warning colour #FF4757 (NOT the thermal red).

#import "SCPRadialControlView.h"
#import <QuartzCore/QuartzCore.h>

static const NSInteger kSCPRadialSectorCount = 5;
static const CGFloat kSCPRadialCoreRatio = 0.34;   // core radius = 0.34R
static const CGFloat kSCPRadialDrawnSpan = 70.0;   // degrees actually painted
static const CGFloat kSCPRadialDisabledAlpha = 0.38;

static UIColor *SCPRadialColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}
static UIColor *SCPRadialFaceColor(void)     { return SCPRadialColor(0x1B, 0x11, 0x38, 1.0); }
static UIColor *SCPRadialRaisedColor(void)   { return SCPRadialColor(0x28, 0x19, 0x4D, 1.0); }
static UIColor *SCPRadialActiveColor(void)   { return SCPRadialColor(0xA1, 0x6E, 0xFF, 0.85); }
static UIColor *SCPRadialRimColor(CGFloat a) { return SCPRadialColor(0xDB, 0xB9, 0xFF, a); }
static UIColor *SCPRadialPrimaryColor(void)  { return SCPRadialColor(0xF5, 0xF0, 0xFF, 1.0); }
static UIColor *SCPRadialSecondaryColor(void){ return SCPRadialColor(0xC7, 0xB8, 0xE4, 1.0); }
static UIColor *SCPRadialWarningColor(void)  { return SCPRadialColor(0xFF, 0x47, 0x57, 1.0); }
static UIColor *SCPRadialCenterColor(void)   { return SCPRadialColor(0x10, 0x09, 0x23, 1.0); }

static NSString *SCPRadialTitleForAction(SCPRadialAction action)
{
    switch (action) {
        case SCPRadialActionReplace:    return @"Đổi ứng dụng";
        case SCPRadialActionFull:       return @"Toàn màn";
        case SCPRadialActionPop:        return @"Cửa sổ nổi";
        case SCPRadialActionBackground: return @"Chạy nền";
        case SCPRadialActionClose:      return @"Tắt ứng dụng";
    }
    return @"";
}

static NSString *SCPRadialSymbolForAction(SCPRadialAction action)
{
    // All names verified present since iOS 13; nil is handled by the
    // caller (label-only sector), so a missing glyph can never crash.
    switch (action) {
        case SCPRadialActionReplace:    return @"arrow.triangle.2.circlepath";
        case SCPRadialActionFull:       return @"arrow.up.left.and.arrow.down.right";
        case SCPRadialActionPop:        return @"square.on.square";
        case SCPRadialActionBackground: return @"moon.zzz";
        case SCPRadialActionClose:      return @"xmark";
    }
    return nil;
}

// Centre angle (radians, UIKit coords: 0 = +x, positive = clockwise
// because y grows downward) for a sector; sector 0 points straight up.
static CGFloat SCPRadialCenterAngle(NSInteger sector)
{
    return (CGFloat)(-M_PI_2 + sector * (2.0 * M_PI / kSCPRadialSectorCount));
}

@interface SCPRadialControlView ()
@property (nonatomic, strong, readwrite) UIImageView *centerLogoView;
@end

@implementation SCPRadialControlView {
    CGFloat _diameter;
    NSMutableArray<CAShapeLayer *> *_sectorLayers;
    NSMutableArray<UIView *> *_sectorContents;
    NSMutableArray<UILabel *> *_reasonLabels;
    NSMutableArray<NSNumber *> *_enabled;
    CAShapeLayer *_outerRimLayer;
    UIView *_centerView;
    NSNumber *_selectedAction;   // nil = nothing selected
    NSInteger _pressedSector;    // -1 = none
    BOOL _pressedCenter;
}

- (instancetype)initWithDiameter:(CGFloat)diameter
{
    self = [super initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    if (self) {
        _diameter = diameter;
        _pressedSector = -1;
        _sectorLayers = [NSMutableArray array];
        _sectorContents = [NSMutableArray array];
        _reasonLabels = [NSMutableArray array];
        _enabled = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;

        for (NSInteger i = 0; i < kSCPRadialSectorCount; i++) {
            SCPRadialAction action = (SCPRadialAction)i;
            BOOL isClose = (action == SCPRadialActionClose);
            UIColor *ink = isClose ? SCPRadialWarningColor() : SCPRadialPrimaryColor();
            [_enabled addObject:@YES];

            CAShapeLayer *sector = [CAShapeLayer layer];
            sector.fillColor = SCPRadialFaceColor().CGColor;
            sector.strokeColor = SCPRadialRimColor(0.40).CGColor;
            sector.lineWidth = 1.0;
            [self.layer addSublayer:sector];
            [_sectorLayers addObject:sector];

            // Non-interactive content cluster (icon + title + reason),
            // centred on the annulus mid-radius; hit-testing is polar
            // math on the wheel itself, never on these subviews.
            UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 56)];
            content.userInteractionEnabled = NO;
            content.backgroundColor = [UIColor clearColor];

            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(30, 1, 20, 20)];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            UIImage *image = [UIImage systemImageNamed:SCPRadialSymbolForAction(action)];
            if (image != nil) {
                icon.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                icon.tintColor = ink;
            } else {
                icon.hidden = YES; // fallback: label only
            }
            [content addSubview:icon];

            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(2, 23, 76, 22)];
            title.text = SCPRadialTitleForAction(action);
            title.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightSemibold];
            title.textColor = ink;
            title.textAlignment = NSTextAlignmentCenter;
            title.numberOfLines = 2;
            title.adjustsFontSizeToFitWidth = YES;
            title.minimumScaleFactor = 0.7;
            [content addSubview:title];

            UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(2, 45, 76, 10)];
            reason.font = [UIFont systemFontOfSize:8.5];
            reason.textColor = SCPRadialSecondaryColor();
            reason.textAlignment = NSTextAlignmentCenter;
            reason.numberOfLines = 1;
            reason.adjustsFontSizeToFitWidth = YES;
            reason.minimumScaleFactor = 0.7;
            reason.hidden = YES;
            [content addSubview:reason];
            [_reasonLabels addObject:reason];

            [self addSubview:content];
            [_sectorContents addObject:content];
        }

        _outerRimLayer = [CAShapeLayer layer];
        _outerRimLayer.fillColor = [UIColor clearColor].CGColor;
        _outerRimLayer.strokeColor = SCPRadialRimColor(0.55).CGColor;
        _outerRimLayer.lineWidth = 1.0;
        [self.layer addSublayer:_outerRimLayer];

        CGFloat coreDiameter = _diameter * kSCPRadialCoreRatio;
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, coreDiameter, coreDiameter)];
        _centerView.backgroundColor = SCPRadialCenterColor();
        _centerView.layer.cornerRadius = coreDiameter * 0.5;
        _centerView.layer.borderColor = SCPRadialRimColor(0.55).CGColor;
        _centerView.layer.borderWidth = 1.0;
        _centerView.userInteractionEnabled = NO;
        [self addSubview:_centerView];

        _centerLogoView = [[UIImageView alloc] initWithFrame:CGRectInset(_centerView.bounds,
                                                                          coreDiameter * 0.16,
                                                                          coreDiameter * 0.16)];
        _centerLogoView.contentMode = UIViewContentModeScaleAspectFit;
        _centerLogoView.userInteractionEnabled = NO;
        [_centerView addSubview:_centerLogoView];

        [self scp_layoutWheel];
    }
    return self;
}

// (Re)build every path/frame from the current diameter. Called once at
// init; the wheel is a fixed-size popup, so no relayout is expected.
- (void)scp_layoutWheel
{
    CGFloat radius = _diameter * 0.5;
    CGPoint center = CGPointMake(radius, radius);
    CGFloat coreRadius = radius * kSCPRadialCoreRatio;
    CGFloat halfSpan = (CGFloat)(kSCPRadialDrawnSpan * M_PI / 180.0) * 0.5;

    for (NSInteger i = 0; i < kSCPRadialSectorCount; i++) {
        CGFloat mid = SCPRadialCenterAngle(i);
        CGFloat start = mid - halfSpan;
        CGFloat end = mid + halfSpan;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
        [path addArcWithCenter:center radius:coreRadius startAngle:end endAngle:start clockwise:NO];
        [path closePath];
        _sectorLayers[i].path = path.CGPath;

        CGFloat midRadius = radius * (kSCPRadialCoreRatio + 1.0) * 0.5;
        UIView *content = _sectorContents[i];
        content.center = CGPointMake(center.x + midRadius * (CGFloat)cos(mid),
                                     center.y + midRadius * (CGFloat)sin(mid));
    }

    UIBezierPath *rim = [UIBezierPath bezierPathWithArcCenter:center
                                                       radius:radius - 0.5
                                                   startAngle:0
                                                     endAngle:(CGFloat)(2.0 * M_PI)
                                                    clockwise:YES];
    _outerRimLayer.path = rim.CGPath;
    _centerView.center = center;
}

- (void)scp_refreshSectorFills
{
    for (NSInteger i = 0; i < kSCPRadialSectorCount; i++) {
        UIColor *fill = SCPRadialFaceColor();
        if (_selectedAction != nil && _selectedAction.integerValue == i) {
            fill = SCPRadialActiveColor();
        }
        if (_pressedSector == i) {
            fill = SCPRadialRaisedColor();
        }
        _sectorLayers[i].fillColor = fill.CGColor;
    }
}

#pragma mark - Configuration

- (void)setAction:(SCPRadialAction)action enabled:(BOOL)enabled reason:(NSString *)reason
{
    if (action < 0 || action >= kSCPRadialSectorCount) {
        return;
    }
    _enabled[action] = @(enabled);
    CGFloat alpha = enabled ? 1.0 : (CGFloat)kSCPRadialDisabledAlpha;
    _sectorLayers[action].opacity = (float)alpha;
    _sectorContents[action].alpha = alpha;
    UILabel *reasonLabel = _reasonLabels[action];
    if (!enabled && reason.length > 0) {
        reasonLabel.text = reason;
        reasonLabel.hidden = NO;
    } else {
        reasonLabel.text = nil;
        reasonLabel.hidden = YES;
    }
    if (!enabled && _pressedSector == action) {
        _pressedSector = -1;
        [self scp_refreshSectorFills];
    }
}

- (void)setSelectedAction:(NSNumber *)action
{
    _selectedAction = action;
    [self scp_refreshSectorFills];
}

#pragma mark - Polar hit-testing

// Returns the sector index for a point, -1 for the centre core,
// -2 for outside the wheel (or in no-man's land).
- (NSInteger)scp_sectorAtPoint:(CGPoint)point
{
    CGFloat radius = _diameter * 0.5;
    CGFloat dx = point.x - radius;
    CGFloat dy = point.y - radius;
    CGFloat r = (CGFloat)hypot(dx, dy);
    if (r > radius) {
        return -2;
    }
    if (r <= radius * kSCPRadialCoreRatio) {
        return -1;
    }
    CGFloat angle = (CGFloat)atan2(dy, dx);
    CGFloat rel = angle + (CGFloat)M_PI_2; // sector 0 starts at top
    while (rel < 0) {
        rel += (CGFloat)(2.0 * M_PI);
    }
    while (rel >= (CGFloat)(2.0 * M_PI)) {
        rel -= (CGFloat)(2.0 * M_PI);
    }
    NSInteger sector = (NSInteger)floor(rel / ((CGFloat)(2.0 * M_PI) / kSCPRadialSectorCount));
    if (sector < 0) {
        sector = 0;
    }
    if (sector >= kSCPRadialSectorCount) {
        sector = kSCPRadialSectorCount - 1;
    }
    return sector;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // Only the disc itself claims touches; everything outside R falls
    // through to the app content below the popup.
    return [self scp_sectorAtPoint:point] != -2;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    NSInteger hit = [self scp_sectorAtPoint:point];
    _pressedCenter = (hit == -1);
    if (hit >= 0 && [_enabled[hit] boolValue]) {
        _pressedSector = hit;
    } else {
        _pressedSector = -1;
    }
    [self scp_refreshSectorFills];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    NSInteger hit = [self scp_sectorAtPoint:point];
    NSInteger next = (hit >= 0 && [_enabled[hit] boolValue]) ? hit : -1;
    if (next != _pressedSector) {
        _pressedSector = next;
        [self scp_refreshSectorFills];
    }
    if (hit != -1) {
        _pressedCenter = NO;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    NSInteger hit = [self scp_sectorAtPoint:point];
    NSInteger pressed = _pressedSector;
    BOOL wasCenter = _pressedCenter;
    _pressedSector = -1;
    _pressedCenter = NO;
    [self scp_refreshSectorFills];
    if (wasCenter && hit == -1) {
        [self.delegate radialViewDidTapCenter:self];
    } else if (pressed >= 0 && hit == pressed) {
        [self.delegate radialView:self didSelectAction:(SCPRadialAction)pressed];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    _pressedSector = -1;
    _pressedCenter = NO;
    [self scp_refreshSectorFills];
}

@end
