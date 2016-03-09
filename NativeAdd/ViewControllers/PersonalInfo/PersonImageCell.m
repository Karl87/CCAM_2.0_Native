//
//  PersonImageCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/24.
//
//

#import "PersonImageCell.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>

const CGFloat imageSize = 80.0;

@implementation PersonImageCell{
    UIImageView *_userImage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpImageCell];
    }
    return self;
}

- (void)setUpImageCell{
    
    UIView *contentView = self.contentView;
    
    _userImage = [UIImageView new];
    [_userImage setBackgroundColor:[UIColor whiteColor]];
    [_userImage.layer setMasksToBounds:YES];
    [_userImage.layer setCornerRadius:imageSize/2];
    [contentView addSubview:_userImage];
    
    _userImage.sd_layout
    .topSpaceToView(contentView,5)
    .leftSpaceToView(contentView,10)
    .widthIs(imageSize)
    .heightIs(imageSize);
    
    [self setupAutoHeightWithBottomView:_userImage bottomMargin:5];
}
- (void)setInfo:(NSDictionary *)info{
    _info = info;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:[_info objectForKey:@"image_url"]]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
