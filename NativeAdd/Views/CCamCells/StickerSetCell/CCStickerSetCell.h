//
//  CCStickerSetCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import <UIKit/UIKit.h>
#import "CCStickerSet.h"
@interface CCStickerSetCell : UICollectionViewCell
@property (nonatomic,strong) CCStickerSet *stickerSet;
@property (nonatomic,strong) UIImageView *stickerSetImage;
@end
