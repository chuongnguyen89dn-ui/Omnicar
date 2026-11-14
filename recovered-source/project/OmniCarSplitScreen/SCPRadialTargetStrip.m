//  SCPRadialTargetStrip.m
//  DuoCar V3 P4/G2 — OmniCarSplitScreen.dylib
//
//  Layout: cards share the strip width equally with 8 pt gaps, fixed
//  height 56 pt (inside the G1 48–60 pt card band, hit area >= 44 pt).
//  Card face is the shared solid sheet colour #100923 alpha 1.0 — never
//  a blur over the app below — with rim #DBB9FF; the floating-window
//  card swaps its rim to the accent #A16EFF. Disabled cards dim to
//  0.42 and stay silent (no delegate). A disabled card shows its
//  disabledReason in the subtitle slot so the driver sees WHY (G1 C3);
//  an empty slot shows "Trống".

#import "SCPRadialTargetStrip.h"

static const CGFloat kSCPStripHeight = 56.0;
static const CGFloat kSCPStripGap = 8.0;
static const CGFloat kSCPStripDisabledAlpha = 0.42;

static UIColor *SCPStripColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}
static UIColor *SCPStripFaceColor(void)      { return SCPStripColor(0x10, 0x09, 0x23, 1.0); }
static UIColor *SCPStripRimColor(void)       { return SCPStripColor(0xDB, 0xB9, 0xFF, 0.55); }
static UIColor *SCPStripAccentColor(void)    { return SCPStripColor(0xA1, 0x6E, 0xFF, 1.0); }
static UIColor *SCPStripPrimaryColor(void)   { return SCPStripColor(0xF5, 0xF0, 0xFF, 1.0); }
static UIColor *SCPStripSecondaryColor(void) { return SCPStripColor(0xC7, 0xB8, 0xE4, 1.0); }

@implementation SCPRadialTargetItem
@end

@implementation SCPRadialTargetStrip {
    NSArray<SCPRadialTargetItem *> *_items;
}

- (instancetype)initWithItems:(NSArray<SCPRadialTargetItem *> *)items width:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(0, 0, width, kSCPStripHeight)];
    if (self) {
        _items = [items copy];
        self.backgroundColor = [UIColor clearColor];

        NSInteger count = (NSInteger)_items.count;
        if (count > 0) {
            CGFloat cardWidth = (width - kSCPStripGap * (CGFloat)(count - 1)) / (CGFloat)count;
            for (NSInteger i = 0; i < count; i++) {
                SCPRadialTargetItem *item = _items[i];
                UIView *card = [[UIView alloc] initWithFrame:CGRectMake((cardWidth + kSCPStripGap) * (CGFloat)i,
                                                                          0, cardWidth, kSCPStripHeight)];
                card.backgroundColor = SCPStripFaceColor();
                card.layer.cornerRadius = 14.0;
                card.layer.borderWidth = 1.0;
                card.layer.borderColor = (item.isFloatCard ? SCPStripAccentColor()
                                                           : SCPStripRimColor()).CGColor;
                card.clipsToBounds = YES;
                if (!item.enabled) {
                    card.alpha = (CGFloat)kSCPStripDisabledAlpha;
                }

                UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 28, 28)];
                icon.contentMode = UIViewContentModeScaleAspectFill;
                icon.clipsToBounds = YES;
                icon.layer.cornerRadius = 7.0;
                icon.image = item.icon;
                icon.hidden = (item.icon == nil);
                [card addSubview:icon];

                CGFloat textX = (item.icon != nil) ? 46.0 : 12.0;
                CGFloat textWidth = cardWidth - textX - 10.0;

                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(textX, 9, textWidth, 18)];
                title.text = item.title;
                title.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
                title.textColor = SCPStripPrimaryColor();
                title.numberOfLines = 1;
                title.lineBreakMode = NSLineBreakByTruncatingTail;
                [card addSubview:title];

                UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(textX, 29, textWidth, 16)];
                subtitle.font = [UIFont systemFontOfSize:11.0];
                subtitle.textColor = SCPStripSecondaryColor();
                subtitle.numberOfLines = 1;
                subtitle.lineBreakMode = NSLineBreakByTruncatingTail;
                if (!item.enabled && item.disabledReason.length > 0) {
                    subtitle.text = item.disabledReason;
                } else if (item.appName.length > 0) {
                    subtitle.text = item.appName;
                } else {
                    subtitle.text = @"Trống";
                    subtitle.alpha = 0.6;
                }
                [card addSubview:subtitle];

                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(scp_cardTapped:)];
                card.tag = i;
                card.userInteractionEnabled = YES;
                [card addGestureRecognizer:tap];
                [self addSubview:card];
            }
        }
    }
    return self;
}

- (void)scp_cardTapped:(UITapGestureRecognizer *)recognizer
{
    NSInteger index = recognizer.view.tag;
    if (index < 0 || index >= (NSInteger)_items.count) {
        return;
    }
    SCPRadialTargetItem *item = _items[index];
    if (!item.enabled) {
        return; // disabled cards stay silent
    }
    [self.delegate targetStrip:self didSelectItem:item];
}

@end
