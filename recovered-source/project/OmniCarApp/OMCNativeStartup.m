// HL26: Startup screen's full 44-item plist is interpreted as UIKit rows.
// Never instantiate PSListController, PSRootController or PSSpecifier in the iPhone app.
#import "OMCNativeSettings.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#import <math.h>

static NSArray *OMCStartupStyleKeys(void) {
    return @[@"STARTUPSCREEN_STYLE_VIDEO",@"STARTUPSCREEN_STYLE_LOGO",
             @"STARTUPSCREEN_STYLE_GREETING",@"STARTUPSCREEN_STYLE_WEATHER",
             @"STARTUPSCREEN_STYLE_ENGINE",@"STARTUPSCREEN_STYLE_WELCOME",
             @"STARTUPSCREEN_STYLE_PARTICLES",@"STARTUPSCREEN_STYLE_HUD",
             @"STARTUPSCREEN_STYLE_BRIEFING",@"STARTUPSCREEN_STYLE_LIQUID",
             @"STARTUPSCREEN_STYLE_RANDOM"];
}
static NSString *OMCStartupLabel(NSString *name) {
    return OMCNativeLocalized(name?:@"");
}
static NSString *OMCStartupText(NSString *vi,NSString *en) {
    return [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"vi"]?vi:en;
}
static void OMCStartupAlert(UIViewController *owner,NSString *text) {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:@"DuoCar" message:text
        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Đóng",@"Close")
        style:UIAlertActionStyleDefault handler:nil]];
    [owner presentViewController:a animated:YES completion:nil];
}
static NSString *OMCStartupVideos(void) {
    return [OMCNativeStartupDirectory() stringByAppendingPathComponent:@"Videos"];
}
static NSString *OMCStartupSounds(void) {
    return [OMCNativeStartupDirectory() stringByAppendingPathComponent:@"Sounds"];
}
static NSArray *OMCStartupVideoFiles(void) {
    NSArray *names=[NSFileManager.defaultManager contentsOfDirectoryAtPath:OMCStartupVideos() error:nil];
    NSMutableArray *result=[NSMutableArray array];
    for (NSString *name in names)
        if (![name hasPrefix:@"."] && [[name pathExtension] length]) [result addObject:name];
    [result sortUsingSelector:@selector(localizedStandardCompare:)];
    return result;
}
static NSString *OMCStartupSelectedVideo(void) {
    NSString *stored=OMCNativePref(@"startupScreenVideoName",@"");
    NSArray *files=OMCStartupVideoFiles();
    return [files containsObject:stored]?stored:files.firstObject;
}
static NSArray *OMCStartupRandomSet(void) {
    id p=OMCNativePref(@"startupScreenRandomSet",nil);
    NSMutableArray *out=[NSMutableArray array];
    if ([p isKindOfClass:NSArray.class]) for (id e in p) {
        NSInteger n=[e integerValue];
        if ([e isKindOfClass:NSNumber.class] && n>=0 && n<=9 &&
            ![out containsObject:@(n)]) [out addObject:@(n)];
    }
    if (!out.count)for(NSInteger i=0;i<10;i++)[out addObject:@(i)];
    return out;
}

@interface OMCNativeStartupPage : UITableViewController
    <UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic,strong) NSArray<NSDictionary *> *sections;
@property(nonatomic,strong) AVAudioPlayer *soundPlayer;
@property(nonatomic) NSInteger pickKind; // 0 video, 1 logo, 2 audio
@property(nonatomic,strong) UIScrollView *gallery;
@property(nonatomic,strong) UILabel *previewLabel;
@property(nonatomic,strong) UIImageView *previewImage;
@property(nonatomic) BOOL extracting;
@end

@implementation OMCNativeStartupPage
- (instancetype)init {
    if ((self=[super initWithStyle:UITableViewStyleInsetGrouped]))self.title=OMCStartupLabel(@"STARTUPSCREEN");
    return self;
}
- (NSInteger)style {
    NSInteger n=[OMCNativePref(@"startupScreenStyle",@0) integerValue];
    return n>=0&&n<=10?n:0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0,0,320,200)];
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(20,10,280,115)];
    img.contentMode=UIViewContentModeScaleAspectFit;
    img.backgroundColor=[UIColor secondarySystemGroupedBackgroundColor];
    img.layer.cornerRadius=14;
    img.clipsToBounds=YES;
    img.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [header addSubview:img];self.previewImage=img;
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(22,10,270,115)];
    label.numberOfLines=3;label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor secondaryLabelColor];
    label.font=[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    label.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [header addSubview:label];self.previewLabel=label;
    UIScrollView *gallery=[[UIScrollView alloc] initWithFrame:CGRectMake(0,137,320,53)];
    gallery.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    gallery.showsHorizontalScrollIndicator=NO;
    [header addSubview:gallery];self.gallery=gallery;
    self.tableView.tableHeaderView=header;
}
- (void)refreshGallery {
    for (UIView *v in self.gallery.subviews) [v removeFromSuperview];
    NSInteger current=[self style];
    NSArray *keys=OMCStartupStyleKeys();
    for (NSInteger i=0;i<keys.count;i++) {
        UIButton *b=[UIButton buttonWithType:UIButtonTypeSystem];
        b.frame=CGRectMake(8+104*i,4,100,44);b.tag=i;
        b.titleLabel.font=[UIFont systemFontOfSize:12 weight:i==current?UIFontWeightBold:UIFontWeightRegular];
        [b setTitle:OMCStartupLabel(keys[i]) forState:UIControlStateNormal];
        b.layer.cornerRadius=10;
        b.backgroundColor=i==current?[UIColor tertiarySystemFillColor]:UIColor.clearColor;
        [b addTarget:self action:@selector(styleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.gallery addSubview:b];
    }
    self.gallery.contentSize=CGSizeMake(8+104*keys.count,53);
    [self.gallery scrollRectToVisible:CGRectMake(MAX(0,104*current-52),0,100,50) animated:NO];
    NSString *text=OMCStartupLabel(keys[current]);
    NSString *preview=nil;
    if (current==1)preview=[OMCNativeStartupDirectory() stringByAppendingPathComponent:@"Logo/logo.png"];
    else if (current==0) {
        NSString *name=OMCStartupSelectedVideo();
        if (name)preview=[[[OMCStartupVideos() stringByAppendingPathComponent:@".frames"]
            stringByAppendingPathComponent:name] stringByAppendingPathComponent:@"00000.jpg"];
    }
    UIImage *image=preview?[UIImage imageWithContentsOfFile:preview]:nil;
    self.previewImage.image=image;
    self.previewLabel.text=image?@"":text;
    NSLog(@"[hl26-settings] page=startup style=%ld image=%d",(long)current,image!=nil);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self rebuild];
    [self refreshGallery];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];[self.soundPlayer stop];
}
- (void)styleSelected:(UIButton *)sender {
    if (OMCNativeSetPref(@"startupScreenStyle",@(sender.tag))){
        [self rebuild];[self refreshGallery];
    }
}
- (void)rebuild {
    NSString *path=[NSBundle.mainBundle pathForResource:@"FeatureStartupScreen" ofType:@"plist"];
    NSDictionary *schema=[NSDictionary dictionaryWithContentsOfFile:path?:@""];
    NSArray *items=[schema[@"items"] isKindOfClass:NSArray.class]?schema[@"items"]:@[];
    NSMutableArray *sections=[NSMutableArray array];
    NSMutableArray *rows=[NSMutableArray array];
    NSString *header=@"";
    NSInteger style=[self style];
    for (NSDictionary *row in items) {
        if (![row isKindOfClass:NSDictionary.class])continue;
        NSArray *styles=row[@"ssStyles"];
        if ([styles isKindOfClass:NSArray.class]) {
            // The restored plist marks the random chooser as ssStyles=9,
            // while runtime style index 9 is Liquid and index 10 is Random.
            // Do not leak random-style controls into Liquid.
            BOOL randomRow=[row[@"ssRandomStyle"] isKindOfClass:NSNumber.class] ||
                [row[@"label"] isEqualToString:@"STARTUPSCREEN_RANDOM_GROUP"];
            BOOL visible=randomRow?(style==10):[styles containsObject:@(style)];
            if (!visible)continue;
        }
        NSString *cell=row[@"cell"];
        if ([cell isEqualToString:@"PSGroupCell"]) {
            if (rows.count) [sections addObject:@{@"header":header,@"rows":[rows copy]}];
            header=row[@"label"]?:@"";
            rows=[NSMutableArray array];
        } else if (cell.length) [rows addObject:row];
    }
    if (rows.count) [sections addObject:@{@"header":header,@"rows":[rows copy]}];
    self.sections=sections;
    [self.tableView reloadData];
    NSLog(@"[hl26-settings] page=startup schema=%lu sections=%lu",
        (unsigned long)items.count,(unsigned long)sections.count);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)t {return self.sections.count;}
- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s {
    return [self.sections[s][@"rows"] count];
}
- (NSString *)tableView:(UITableView *)t titleForHeaderInSection:(NSInteger)s {
    return OMCStartupLabel(self.sections[s][@"header"]);
}
- (NSDictionary *)rowAt:(NSIndexPath *)p {return self.sections[p.section][@"rows"][p.row];}
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    NSDictionary *r=[self rowAt:p];NSString *type=r[@"cell"];
    NSString *key=r[@"key"];
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSString *label=r[@"label"];
    if ([r[@"id"] isEqualToString:@"birthday"]) label=@"STARTUPSCREEN_BIRTHDAY";
    cell.textLabel.text=OMCStartupLabel(label?:@"");
    cell.textLabel.numberOfLines=2;cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
    if ([type isEqualToString:@"PSSwitchCell"]) {
        UISwitch *sw=[UISwitch new];
        sw.on=[OMCNativePref(key,r[@"default"]?:@NO) boolValue];
        objc_setAssociatedObject(sw,@selector(switchChanged:),key,OBJC_ASSOCIATION_COPY_NONATOMIC);
        [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;
    } else if ([type isEqualToString:@"PSSliderCell"]) {
        cell.textLabel.text=OMCStartupLabel([key isEqualToString:@"startupScreenDuration"]
            ?@"STARTUPSCREEN_DURATION_GROUP":@"STARTUPSCREEN_VOLUME_GROUP");
        UISlider *slider=[[UISlider alloc] initWithFrame:CGRectMake(170,4,150,34)];
        slider.minimumValue=[r[@"min"] floatValue];slider.maximumValue=[r[@"max"] floatValue];
        slider.value=[OMCNativePref(key,r[@"default"]?:@0) floatValue];
        objc_setAssociatedObject(slider,@selector(sliderChanged:),r,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // Commit only once after the user finishes dragging, not on every frame.
        [slider addTarget:self action:@selector(sliderChanged:)
             forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        cell.accessoryView=slider;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.0f",slider.value];
    } else if ([type isEqualToString:@"PSEditTextCell"] ||
               [type isEqualToString:@"PSSegmentCell"] ||
               [type isEqualToString:@"PSLinkListCell"]) {
        id v=OMCNativePref(key,r[@"default"]?:@"");
        cell.detailTextLabel.text=[v description];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    } else if ([type isEqualToString:@"PSButtonCell"]){
        if (r[@"ssRandomStyle"]) {
            NSArray *set=OMCStartupRandomSet();
            cell.accessoryType=[set containsObject:r[@"ssRandomStyle"]]
                ?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        } else cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if ([r[@"isDestructive"] boolValue])cell.textLabel.textColor=UIColor.systemRedColor;
    } else if ([r[@"id"] isEqualToString:@"birthday"]) {
        cell.detailTextLabel.text=OMCNativePref(@"startupScreenBirthday",@"");
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)switchChanged:(UISwitch *)sw {
    NSString *key=objc_getAssociatedObject(sw,@selector(switchChanged:));
    if (!OMCNativeSetPref(key,@(sw.on))) {
        sw.on=!sw.on;OMCStartupAlert(self,OMCStartupText(@"Không lưu được.",@"Could not save."));
    }
}
- (void)sliderChanged:(UISlider *)sw {
    NSDictionary *r=objc_getAssociatedObject(sw,@selector(sliderChanged:));
    NSString *key=r[@"key"];
    NSInteger newValue=(NSInteger)roundf(sw.value);
    if (OMCNativeSetPref(key,@(newValue))) {
        // An accessory UISlider can be wrapped in private UIKit views.
        // Never cast superview.superview into a cell: it may be UITableView.
        UIView *parent=sw;
        while (parent && ![parent isKindOfClass:UITableViewCell.class])
            parent=parent.superview;
        if ([parent isKindOfClass:UITableViewCell.class])
            ((UITableViewCell *)parent).detailTextLabel.text=[NSString stringWithFormat:@"%ld",(long)newValue];
    }
}
- (void)editString:(NSDictionary *)row {
    NSString *key=row[@"key"];
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCStartupLabel(row[@"label"])
        message:nil preferredStyle:UIAlertControllerStyleAlert];
    [a addTextFieldWithConfigurationHandler:^(UITextField *f){
        f.text=OMCNativePref(key,@"");
        f.placeholder=OMCStartupLabel(row[@"placeholder"]);
    }];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Lưu",@"Save")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
            OMCNativeSetPref(key,a.textFields.firstObject.text?:@"");[self rebuild];
        }]];
    [self presentViewController:a animated:YES completion:nil];
}
- (void)pickSegment:(NSDictionary *)row {
    NSString *key=row[@"key"];
    NSArray *titles=row[@"validTitles"],*values=row[@"validValues"];
    if (titles.count!=values.count || !values.count) return;
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCStartupLabel(row[@"label"])
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSUInteger i=0;i<values.count;i++){
        id value=values[i];NSString *name=OMCStartupLabel(titles[i]);
        [a addAction:[UIAlertAction actionWithTitle:name
            style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
                OMCNativeSetPref(key,value);[self rebuild];
            }]];
    }
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    a.popoverPresentationController.sourceView=self.view;
    a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
    [self presentViewController:a animated:YES completion:nil];
}
- (void)pickVideo {
    NSArray *names=OMCStartupVideoFiles();
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCStartupText(@"Chọn video",@"Select video")
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *name in names) [a addAction:[UIAlertAction actionWithTitle:
        [name stringByDeletingPathExtension] style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
            OMCNativeSetPref(@"startupScreenVideoName",name);[self rebuild];[self refreshGallery];
        }]];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    a.popoverPresentationController.sourceView=self.view;
    a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
    [self presentViewController:a animated:YES completion:nil];
}
- (void)editBirthday {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:OMCStartupLabel(@"STARTUPSCREEN_BIRTHDAY")
        message:OMCStartupText(@"Nhập ngày theo định dạng MM-dd, ví dụ 12-25.",
            @"Enter MM-dd, e.g. 12-25.")
        preferredStyle:UIAlertControllerStyleAlert];
    [a addTextFieldWithConfigurationHandler:^(UITextField *f){
        f.text=OMCNativePref(@"startupScreenBirthday",@"");
        f.placeholder=@"MM-dd";
    }];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Xóa",@"Clear")
        style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act){
            OMCNativeSetPref(@"startupScreenBirthday",@"");[self rebuild];
        }]];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Lưu",@"Save")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
            NSString *s=a.textFields.firstObject.text?:@"";
            NSDateFormatter *f=[NSDateFormatter new];f.dateFormat=@"MM-dd";
            f.locale=[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            f.lenient=NO;
            if (!s.length || [f dateFromString:s]){
                OMCNativeSetPref(@"startupScreenBirthday",s);[self rebuild];
            }else OMCStartupAlert(self,OMCStartupText(@"Ngày không hợp lệ.",@"Invalid date."));
        }]];
    [self presentViewController:a animated:YES completion:nil];
}
- (void)randomToggle:(NSDictionary *)r {
    NSNumber *n=r[@"ssRandomStyle"];
    NSMutableArray *items=[OMCStartupRandomSet() mutableCopy];
    if ([items containsObject:n]) {
        if (items.count==1) {OMCStartupAlert(self,OMCStartupLabel(@"STARTUPSCREEN_RANDOM_KEEP_ONE"));return;}
        [items removeObject:n];
    } else [items addObject:n];
    [items sortUsingSelector:@selector(compare:)];
    OMCNativeSetPref(@"startupScreenRandomSet",items);[self rebuild];
}
- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)p {
    [t deselectRowAtIndexPath:p animated:YES];
    NSDictionary *row=[self rowAt:p];NSString *type=row[@"cell"];
    if ([type isEqualToString:@"PSEditTextCell"]) {[self editString:row];return;}
    if ([type isEqualToString:@"PSSegmentCell"]) {[self pickSegment:row];return;}
    if ([type isEqualToString:@"PSLinkListCell"]) {[self pickVideo];return;}
    if ([row[@"id"] isEqualToString:@"birthday"]) {[self editBirthday];return;}
    NSString *action=row[@"action"];
    if ([action isEqualToString:@"toggleRandomStyle:"]){[self randomToggle:row];return;}
    if ([action isEqualToString:@"addVideo"]){[self addVideo];return;}
    if ([action isEqualToString:@"previewVideo"]){[self previewVideo];return;}
    if ([action isEqualToString:@"deleteVideo"]){[self deleteVideo];return;}
    if ([action isEqualToString:@"chooseLogo"]){[self chooseLogo];return;}
    if ([action isEqualToString:@"deleteLogo"]){[self deleteLogo];return;}
    if ([action isEqualToString:@"chooseSound"]){[self openFiles:2];return;}
    if ([action isEqualToString:@"previewSound"]){[self previewSound];return;}
    if ([action isEqualToString:@"deleteSound"]){[self deleteSound];return;}
    if ([action isEqualToString:@"previewOccasion"]){[self previewOccasion];return;}
    NSLog(@"[hl26-settings] startup unknown-action=%@",action);
}
- (void)openFiles:(NSInteger)kind {
    self.pickKind=kind;
    UTType *type=kind==0?UTTypeMovie:(kind==1?UTTypeImage:UTTypeAudio);
    UIDocumentPickerViewController *picker=[[UIDocumentPickerViewController alloc]
        initForOpeningContentTypes:@[type] asCopy:YES];
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)openPhotos:(NSInteger)kind {
    self.pickKind=kind;
    UIImagePickerController *picker=[UIImagePickerController new];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes=@[(kind==0?UTTypeMovie:UTTypeImage).identifier];
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)chooseSource:(NSInteger)kind {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:nil
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupLabel(@"STARTUPSCREEN_FROM_PHOTOS")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){[self openPhotos:kind];}]];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupLabel(@"STARTUPSCREEN_FROM_FILES")
        style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){[self openFiles:kind];}]];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    a.popoverPresentationController.sourceView=self.view;
    a.popoverPresentationController.sourceRect=CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds),1,1);
    [self presentViewController:a animated:YES completion:nil];
}
- (void)addVideo {[self chooseSource:0];}
- (void)chooseLogo {[self chooseSource:1];}
- (void)documentPicker:(UIDocumentPickerViewController *)p didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url=urls.firstObject;
    if (!url) return;
    BOOL granted=[url startAccessingSecurityScopedResource];
    @try {
        if (self.pickKind==1) [self saveLogo:[UIImage imageWithContentsOfFile:url.path]];
        else if (self.pickKind==2) [self copySound:url];
        else [self copyVideo:url];
    } @finally {if (granted)[url stopAccessingSecurityScopedResource];}
}
- (void)imagePickerController:(UIImagePickerController *)p didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSInteger kind=self.pickKind;
    NSURL *url=kind==0?info[UIImagePickerControllerMediaURL]:info[UIImagePickerControllerImageURL];
    UIImage *image=kind==1?info[UIImagePickerControllerOriginalImage]:nil;
    [p dismissViewControllerAnimated:YES completion:^{
        if (kind==1) [self saveLogo:image?:[UIImage imageWithContentsOfFile:url.path]];
        else if (url) [self copyVideo:url];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)p {
    [p dismissViewControllerAnimated:YES completion:nil];
}
- (void)copyVideo:(NSURL *)url {
    if (self.extracting)return;
    NSString *folder=OMCStartupVideos();
    NSFileManager *fm=NSFileManager.defaultManager;
    [fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *name=url.lastPathComponent;
    if (![name.pathExtension length])name=[name stringByAppendingPathExtension:@"mov"];
    NSString *base=name.stringByDeletingPathExtension,*ext=name.pathExtension;
    NSString *dest=[folder stringByAppendingPathComponent:name];
    for (NSUInteger i=2;[fm fileExistsAtPath:dest]&&i<1000;i++) {
        name=[NSString stringWithFormat:@"%@ %lu.%@",base,(unsigned long)i,ext];
        dest=[folder stringByAppendingPathComponent:name];
    }
    NSError *error=nil;
    if (![fm copyItemAtURL:url toURL:[NSURL fileURLWithPath:dest] error:&error]) {
        OMCStartupAlert(self,error.localizedDescription?:@"Video copy failed");return;
    }
    [fm setAttributes:@{NSFilePosixPermissions:@0644} ofItemAtPath:dest error:nil];
    OMCNativeSetPref(@"startupScreenVideoName",name);
    [self extractFrames:name];
}
- (void)extractFrames:(NSString *)name {
    self.extracting=YES;
    UIAlertController *pending=[UIAlertController alertControllerWithTitle:@"DuoCar"
        message:OMCStartupLabel(@"STARTUPSCREEN_PREPARING")
        preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:pending animated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0),^{
        NSError *error=nil;
        BOOL passed=[self extractFramesForVideo:name error:&error];
        dispatch_async(dispatch_get_main_queue(),^{
            self.extracting=NO;
            [pending dismissViewControllerAnimated:YES completion:^{
                if (!passed) OMCStartupAlert(self,error.localizedDescription?:@"Video frame conversion failed");
                [self rebuild];[self refreshGallery];
            }];
        });
    });
}
- (BOOL)extractFramesForVideo:(NSString *)name error:(NSError **)error {
    NSFileManager *fm=NSFileManager.defaultManager;
    NSString *root=OMCStartupVideos();
    NSString *dir=[[[root stringByAppendingPathComponent:@".frames"]
        stringByAppendingPathComponent:name] copy];
    [fm removeItemAtPath:dir error:nil];
    if (![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:error])
        return NO;
    AVURLAsset *asset=[AVURLAsset URLAssetWithURL:
        [NSURL fileURLWithPath:[root stringByAppendingPathComponent:name]] options:nil];
    AVAssetTrack *track=[asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    AVAssetReader *reader=track?[AVAssetReader assetReaderWithAsset:asset error:error]:nil;
    if (!reader) {[fm removeItemAtPath:dir error:nil];return NO;}
    AVAssetReaderTrackOutput *output=[AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track
        outputSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)}];
    output.alwaysCopiesSampleData=NO;
    [reader addOutput:output];
    double duration=CMTimeGetSeconds(asset.duration),seconds=MIN(duration,60);
    if (!isfinite(seconds)||seconds<=0) seconds=5;
    reader.timeRange=CMTimeRangeMake(kCMTimeZero,CMTimeMakeWithSeconds(seconds,600));
    if (![reader startReading]) {
        if (error)*error=reader.error;
        [fm removeItemAtPath:dir error:nil];return NO;
    }
    CIContext *ctx=[CIContext contextWithOptions:nil];
    CGColorSpaceRef color=CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    CGAffineTransform tr=track.preferredTransform;
    CGImagePropertyOrientation orient=kCGImagePropertyOrientationUp;
    if (tr.a==0 && tr.b==1 && tr.c==-1 && tr.d==0)orient=kCGImagePropertyOrientationRight;
    else if(tr.a==0&&tr.b==-1&&tr.c==1&&tr.d==0)orient=kCGImagePropertyOrientationLeft;
    else if(tr.a==-1&&tr.b==0&&tr.c==0&&tr.d==-1)orient=kCGImagePropertyOrientationDown;
    NSUInteger count=0;double next=0;CMSampleBufferRef sample;
    BOOL diskOK=YES;
    while ((sample=[output copyNextSampleBuffer])!=NULL) {
        @autoreleasepool {
            double pts=CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sample));
            CVPixelBufferRef pix=CMSampleBufferGetImageBuffer(sample);
            if (pix && isfinite(pts) && pts+0.001>=next) {
                CIImage *img=[[CIImage imageWithCVPixelBuffer:pix] imageByApplyingCGOrientation:orient];
                CGRect ext=img.extent;
                double sc=MIN(1.0,2000.0/MAX(ext.size.width,ext.size.height));
                img=[img imageByApplyingTransform:CGAffineTransformMakeScale(sc,sc)];
                NSData *jpg=[ctx JPEGRepresentationOfImage:img colorSpace:color
                    options:@{(id)kCGImageDestinationLossyCompressionQuality:@0.85}];
                NSString *path=[dir stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%05lu.jpg",(unsigned long)count]];
                if (!jpg || ![jpg writeToFile:path atomically:NO]) {diskOK=NO;}
                else count++;
                next+=1.0/24.0;
            }
        }
        CFRelease(sample);
        if (!diskOK) { [reader cancelReading];break; }
    }
    CGColorSpaceRelease(color);
    if (!diskOK || count==0) {
        [fm removeItemAtPath:dir error:nil];return NO;
    }
    // Reproduce the optional movie audio.m4a contract used by the original
    // startup renderer. Export off the main thread; bound the wait to avoid a hang.
    if ([asset tracksWithMediaType:AVMediaTypeAudio].count) {
        AVAssetExportSession *exp=[AVAssetExportSession exportSessionWithAsset:asset
            presetName:AVAssetExportPresetAppleM4A];
        if (exp) {
            exp.outputURL=[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:@"audio.m4a"]];
            exp.outputFileType=AVFileTypeAppleM4A;
            exp.timeRange=CMTimeRangeMake(kCMTimeZero,CMTimeMakeWithSeconds(seconds,600));
            dispatch_semaphore_t done=dispatch_semaphore_create(0);
            [exp exportAsynchronouslyWithCompletionHandler:^{dispatch_semaphore_signal(done);}];
            long wait=dispatch_semaphore_wait(done,
                 dispatch_time(DISPATCH_TIME_NOW,20LL*NSEC_PER_SEC));
            if (wait) [exp cancelExport];
            if (wait || exp.status!=AVAssetExportSessionStatusCompleted)
                NSLog(@"[hl26-settings] startup video-audio-unavailable status=%ld",(long)exp.status);
        }
    }
    NSDictionary *info=@{@"version":@2,@"count":@(count),@"fps":@24};
    BOOL ok=[info writeToFile:[dir stringByAppendingPathComponent:@"info.plist"] atomically:YES];
    if (!ok) [fm removeItemAtPath:dir error:nil];
    NSLog(@"[hl26-settings] startup video-frames=%lu format=2 ok=%d",(unsigned long)count,ok);
    return ok;
}
- (void)previewVideo {
    NSString *name=OMCStartupSelectedVideo();
    if (!name) {OMCStartupAlert(self,OMCStartupLabel(@"STARTUPSCREEN_NO_VIDEO_PREVIEW"));return;}
    AVPlayerViewController *p=[AVPlayerViewController new];
    p.player=[AVPlayer playerWithURL:[NSURL fileURLWithPath:
         [OMCStartupVideos() stringByAppendingPathComponent:name]]];
    [self presentViewController:p animated:YES completion:^{[p.player play];}];
}
- (void)confirmDelete:(NSString *)title handler:(void(^)(void))handler {
    UIAlertController *a=[UIAlertController alertControllerWithTitle:title
        message:OMCStartupText(@"Thao tác này không thể hoàn tác.",@"This cannot be undone.")
        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Hủy",@"Cancel")
        style:UIAlertActionStyleCancel handler:nil]];
    [a addAction:[UIAlertAction actionWithTitle:OMCStartupText(@"Xóa",@"Delete")
        style:UIAlertActionStyleDestructive handler:^(UIAlertAction *act){handler();}]];
    [self presentViewController:a animated:YES completion:nil];
}
- (void)deleteVideo {
    NSString *name=OMCStartupSelectedVideo();
    if (!name)return;
    [self confirmDelete:name handler:^{
        NSFileManager *fm=NSFileManager.defaultManager;
        [fm removeItemAtPath:[OMCStartupVideos() stringByAppendingPathComponent:name] error:nil];
        [fm removeItemAtPath:[[OMCStartupVideos() stringByAppendingPathComponent:@".frames"]
            stringByAppendingPathComponent:name] error:nil];
        OMCNativeSetPref(@"startupScreenVideoName",[OMCStartupVideoFiles() firstObject]);
        [self rebuild];[self refreshGallery];
    }];
}
- (void)saveLogo:(UIImage *)image {
    if (!image||image.size.width<=0||image.size.height<=0){
        OMCStartupAlert(self,OMCStartupLabel(@"STARTUPSCREEN_LOGO_FAILED"));return;
    }
    double w=image.size.width*image.scale,h=image.size.height*image.scale;
    double fac=MIN(1.,1024./MAX(w,h));
    CGSize size=CGSizeMake(MAX(1,round(w*fac)),MAX(1,round(h*fac)));
    UIGraphicsImageRendererFormat *fmt=[UIGraphicsImageRendererFormat preferredFormat];fmt.scale=1;
    UIGraphicsImageRenderer *renderer=[[UIGraphicsImageRenderer alloc] initWithSize:size format:fmt];
    NSData *png=UIImagePNGRepresentation([renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx){
        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    }]);
    NSString *dir=[OMCNativeStartupDirectory() stringByAppendingPathComponent:@"Logo"];
    [NSFileManager.defaultManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path=[dir stringByAppendingPathComponent:@"logo.png"];
    if (![png writeToFile:path atomically:YES]){
        OMCStartupAlert(self,OMCStartupLabel(@"STARTUPSCREEN_LOGO_FAILED"));return;
    }
    [NSFileManager.defaultManager setAttributes:@{NSFilePosixPermissions:@0644} ofItemAtPath:path error:nil];
    [self refreshGallery];
}
- (void)deleteLogo {
    [self confirmDelete:OMCStartupLabel(@"STARTUPSCREEN_LOGO_DELETE") handler:^{
        [NSFileManager.defaultManager removeItemAtPath:
            [OMCNativeStartupDirectory() stringByAppendingPathComponent:@"Logo/logo.png"] error:nil];
        [self refreshGallery];
    }];
}
- (void)copySound:(NSURL *)url {
    NSError *error=nil;
    AVAudioPlayer *probe=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(!probe){OMCStartupAlert(self,error.localizedDescription?:@"Unsupported audio");return;}
    NSString *dir=OMCStartupSounds();
    [NSFileManager.defaultManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *name=url.lastPathComponent;
    if (!name.length)return;
    NSString *file=[dir stringByAppendingPathComponent:name];
    if ([NSFileManager.defaultManager fileExistsAtPath:file]){
        OMCStartupAlert(self,OMCStartupText(@"Đã có âm thanh trùng tên. Hãy đổi tên file trước khi nhập.",
            @"An audio file with this name already exists. Rename it first."));return;
    }
    if (![NSFileManager.defaultManager copyItemAtURL:url toURL:[NSURL fileURLWithPath:file] error:&error]) {
        OMCStartupAlert(self,error.localizedDescription?:@"Audio import failed");return;
    }
    [NSFileManager.defaultManager setAttributes:@{NSFilePosixPermissions:@0644} ofItemAtPath:file error:nil];
    OMCNativeSetPref(@"startupScreenSoundFile",name);[self rebuild];
}
- (void)previewSound {
    NSString *name=OMCNativePref(@"startupScreenSoundFile",@"");
    NSString *file=[OMCStartupSounds() stringByAppendingPathComponent:name.lastPathComponent];
    NSError *err=nil;
    AVAudioSession *session=AVAudioSession.sharedInstance;
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    self.soundPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:file] error:&err];
    if (!self.soundPlayer) {OMCStartupAlert(self,err.localizedDescription?:OMCStartupLabel(@"STARTUPSCREEN_SOUND_NONE"));return;}
    self.soundPlayer.volume=fminf(1,fmaxf(0,[OMCNativePref(@"startupScreenSoundVolume",@100) floatValue]/100));
    [self.soundPlayer play];
}
- (void)deleteSound {
    NSString *name=OMCNativePref(@"startupScreenSoundFile",@"");
    if (!name.length)return;
    [self confirmDelete:OMCStartupLabel(@"STARTUPSCREEN_SOUND_DELETE") handler:^{
        [NSFileManager.defaultManager removeItemAtPath:
            [OMCStartupSounds() stringByAppendingPathComponent:name.lastPathComponent] error:nil];
        [self.soundPlayer stop];self.soundPlayer=nil;
        OMCNativeSetPref(@"startupScreenSoundFile",nil);[self rebuild];
    }];
}
// The original preview selects the first upcoming day in the next 400 days.
// This UIKit page implements the real calendar selection; animated
// SSStartupView is still a separately tracked fidelity gap.
- (void)previewOccasion {
    NSString *birthday=OMCNativePref(@"startupScreenBirthday",@"");
    NSCalendar *greg=[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *chinese=[NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *tz=[NSTimeZone timeZoneForSecondsFromGMT:25200];
    greg.timeZone=tz;chinese.timeZone=tz;
    NSDate *day=[greg dateBySettingHour:12 minute:0 second:0
        ofDate:[NSDate date] options:0]?:[NSDate date];
    NSInteger event=1;
    for(NSInteger i=0;i<400;i++){
        NSDateComponents *g=[greg components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:day];
        NSDateComponents *c=[chinese components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:day];
        if(!c.isLeapMonth&&c.month==1&&c.day<4){event=1;break;}
        NSString *stamp=[NSString stringWithFormat:@"%02ld-%02ld",(long)g.month,(long)g.day];
        if([birthday isKindOfClass:NSString.class]&&birthday.length==5&&[stamp isEqualToString:birthday]){
            event=2;break;
        }
        if(g.month==1&&g.day==1){event=5;break;}
        if(g.month==12&&(g.day==24||g.day==25)){event=3;break;}
        if(!c.isLeapMonth&&c.month==8&&c.day==15){event=4;break;}
        NSDate *next=[greg dateByAddingUnit:NSCalendarUnitDay value:1 toDate:day options:0];
        if(!next)break;day=next;
    }
    NSArray *keys=@[@"STARTUPSCREEN_OCC_TET",@"STARTUPSCREEN_OCC_BIRTHDAY",
                    @"STARTUPSCREEN_OCC_XMAS",@"STARTUPSCREEN_OCC_MIDAUTUMN",
                    @"STARTUPSCREEN_OCC_NEWYEAR"];
    NSString *label=OMCStartupLabel(keys[MAX(0,MIN(4,event-1))]);
    NSString *message=[NSString stringWithFormat:OMCStartupLabel(@"STARTUPSCREEN_OCCASION_PREVIEW"),label];
    // UI proof is the selected event, not a pretend SSStartupView animation.
    self.previewImage.image=nil;
    self.previewLabel.text=label;
    OMCStartupAlert(self,message);
    NSLog(@"[hl26-settings] startup occasion-preview event=%ld",(long)event);
}
@end

UIViewController *OMCNativeStartupController(void) {
    return [OMCNativeStartupPage new];
}
