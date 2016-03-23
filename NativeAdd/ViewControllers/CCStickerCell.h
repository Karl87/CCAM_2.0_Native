//
//  CCStickerCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import <UIKit/UIKit.h>
#import "CCSticker.h"
#import <M13ProgressSuite/M13ProgressViewBorderedBar.h>


@interface CCStickerCell : UICollectionViewCell
@property (nonatomic,strong) CCSticker *sticker;
@property (nonatomic,strong) UIImageView *stickerImage;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UIImageView *stateImage;
@property (nonatomic,strong) M13ProgressViewBorderedBar *downloadProgress;

@property (nonatomic,strong) UIView *mask;
@property (nonatomic,strong) UIActivityIndicatorView *loading;

- (void)layoutStickerCell;
- (void)UILoadingSticker;

@end
