//
//  CCamAnimationCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import <UIKit/UIKit.h>
#import "CCAnimation.h"
@interface CCamAnimationCell : UICollectionViewCell
@property (nonatomic,strong) CCAnimation *animation;
@property (nonatomic,strong) UIImageView *animationImage;
@property (nonatomic,strong) UIView *mask;
@property (nonatomic,strong) UIActivityIndicatorView *loading;

- (void)UILoadingCharacter;
@end
