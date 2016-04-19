//
//  CCStickerSetCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import "CCStickerSetCell.h"
#import "Constants.h"

@implementation CCStickerSetCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        
        if (!_stickerSetImage) {
            _stickerSetImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.height-4)];
            [_stickerSetImage setBackgroundColor:[UIColor clearColor]];
            [_stickerSetImage setContentMode:UIViewContentModeScaleAspectFit];
            [_stickerSetImage setClipsToBounds:YES];
            [self.contentView addSubview:_stickerSetImage];
        }
        
        UIView *selectedBG = [[UIView alloc] initWithFrame:self.bounds];
        [selectedBG setBackgroundColor:CCamExLightGrayColor];
        
        self.selectedBackgroundView = selectedBG;
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
@end