// OMCStartupScreenController.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCStartupScreenController : OMCFeatureListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    B _extracting;  // offset None
    q _pickKind;  // offset None
    @"UIView" _previewHeader;  // offset None
    @"UIView" _previewShadow;  // offset None
    @"SSStartupView" _preview;  // offset None
    d _previewWidth;  // offset None
    @"UILabel" _galleryTitle;  // offset None
    @"UILabel" _galleryHint;  // offset None
    @"UICollectionView" _gallery;  // offset None
    @"UIStackView" _birthdayView;  // offset None
    @"UIDatePicker" _birthdayPicker;  // offset None
    @"UIButton" _birthdayClear;  // offset None
    @"AVAudioPlayer" _soundPlayer;  // offset None
}
@property (TB,N,V_extracting) id extracting;
@property (Tq,N,V_pickKind) id pickKind;
@property (T@"UIView",&,N,V_previewHeader) id previewHeader;
@property (T@"UIView",&,N,V_previewShadow) id previewShadow;
@property (T@"SSStartupView",&,N,V_preview) id preview;
@property (Td,N,V_previewWidth) id previewWidth;
@property (T@"UILabel",&,N,V_galleryTitle) id galleryTitle;
@property (T@"UILabel",&,N,V_galleryHint) id galleryHint;
@property (T@"UICollectionView",&,N,V_gallery) id gallery;
@property (T@"UIStackView",&,N,V_birthdayView) id birthdayView;
@property (T@"UIDatePicker",&,N,V_birthdayPicker) id birthdayPicker;
@property (T@"UIButton",&,N,V_birthdayClear) id birthdayClear;
@property (T@"AVAudioPlayer",&,N,V_soundPlayer) id soundPlayer;
@property (TQ,R) id hash;
@property (T#,R) id superclass;
@property (T@"NSString",R,C) id description;
@property (T@"NSString",?,R,C) id debugDescription;
@end
