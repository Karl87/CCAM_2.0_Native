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
        _workImage = [[UIImageView alloc] init];
        _avatar = [[UIImageView alloc] init];
        _userName  = [[UILabel alloc] init];
        _pictureNote = [[UILabel alloc] init];
        _likeButton = [[UIButton alloc] init];
        _imageButton = [UIButton new];
        [_imageButton setBackgroundColor:[UIColor clearColor]];
        _userButton = [UIButton new];
        [_userButton setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_workImage];
        [self.contentView addSubview:_avatar];
        [self.contentView addSubview:_userName];
        [self.contentView addSubview:_pictureNote];
        [self.contentView addSubview:_likeButton];
        
        [self.contentView addSubview:_imageButton];
        [self.contentView addSubview:_userButton];
    }
    
    return self;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    _workImage.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.width);
    [_imageButton setFrame:CGRectMake(15, 15, layoutAttributes.frame.size.width-30, layoutAttributes.frame.size.width-30)];
    
    _likeButton.frame = CGRectMake(layoutAttributes.frame.size.width - 18 - 8, layoutAttributes.frame.size.width + 16, 18, 15);
    
    _avatar.frame = CGRectMake(8, layoutAttributes.frame.size.width - 30, 40, 40);
    [_avatar.layer setShadowColor:[UIColor whiteColor].CGColor];
    [_avatar.layer setMasksToBounds:YES];
    [_avatar.layer setCornerRadius:CGRectGetHeight([_avatar bounds])/2];
    [_avatar.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_avatar.layer setBorderWidth:2.0];
    
    [_userButton setFrame:CGRectMake(8, layoutAttributes.frame.size.width - 30, 60, 60)];
    
    _userName.frame = CGRectMake(8, layoutAttributes.frame.size.width + 15, layoutAttributes.frame.size.width*2/3, 18);
    
}
@end
