//
//  KLCollectionCell.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPhoto.h"

@interface KLCollectionCell : UICollectionViewCell
@property (nonatomic,strong) CCPhoto *photo;
@property (nonatomic,strong) UIImageView * avatar;
@property (nonatomic,strong) UIImageView * workImage;
//@property (nonatomic,strong) UILabel *likeCount;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *pictureNote;
@property (nonatomic,strong) UIButton *likeButton;
@end
