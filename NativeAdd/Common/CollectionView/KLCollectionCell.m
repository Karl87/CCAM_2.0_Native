//
//  KLCollectionCell.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLCollectionCell.h"
#import "Constants.h"

@implementation KLCollectionCell

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _photo = [[CCPhoto alloc] init];
        _workImage = [[UIImageView alloc] init];
        _avatar = [[UIImageView alloc] init];
//        _likeCount = [[UILabel alloc] init];
        _userName  = [[UILabel alloc] init];
        _pictureNote = [[UILabel alloc] init];
        _likeButton = [[UIButton alloc] init];
        
        [self.contentView addSubview:_workImage];
        [self.contentView addSubview:_avatar];
        [self.contentView addSubview:_userName];
//        [self.contentView addSubview:_likeCount];
        [self.contentView addSubview:_pictureNote];
        [self.contentView addSubview:_likeButton];
    }
    
    return self;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    _workImage.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.width);
    
    _likeButton.frame = CGRectMake(layoutAttributes.frame.size.width - 18 - 8, layoutAttributes.frame.size.width + 16, 18, 15);
//    _likeCount.frame = CGRectMake(layoutAttributes.frame.size.width - 18, layoutAttributes.frame.size.width + 16, 0, 0);
    
    _avatar.frame = CGRectMake(8, layoutAttributes.frame.size.width - 30, 40, 40);
    [_avatar.layer setShadowColor:[UIColor whiteColor].CGColor];
    [_avatar.layer setMasksToBounds:YES];
    [_avatar.layer setCornerRadius:CGRectGetHeight([_avatar bounds])/2];
    [_avatar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_avatar.layer setBorderWidth:2.0];
    
    _userName.frame = CGRectMake(8, layoutAttributes.frame.size.width + 15, layoutAttributes.frame.size.width*2/3, 18);
    
}
@end
