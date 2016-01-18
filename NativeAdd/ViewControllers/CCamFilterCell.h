//
//  CCamFilterCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/6.
//
//

#import <UIKit/UIKit.h>

@interface CCamFilterCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *filterImage;
@property (nonatomic,strong) UILabel *filterLabel;
- (void)layoutFilterCell;
@end
