// OMCHSPreview.h — reconstructed interface (evidence: metadata objc dump)
#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface OMCHSPreview : UIView
{
    B _names;  // offset None
    B _video;  // offset None
    @"NSArray" _items;  // offset None
    @"UIImage" _wallpaper;  // offset None
    q _size;  // offset None
    q _blur;  // offset None
    q _dim;  // offset None
    q _cols;  // offset None
    q _rows;  // offset None
}
@property (T@"NSArray",C,N,V_items) id items;
@property (T@"UIImage",&,N,V_wallpaper) id wallpaper;
@property (Tq,N,V_size) id size;
@property (Tq,N,V_blur) id blur;
@property (Tq,N,V_dim) id dim;
@property (Tq,N,V_cols) id cols;
@property (Tq,N,V_rows) id rows;
@property (TB,N,V_names) id names;
@property (TB,N,V_video) id video;
@end
