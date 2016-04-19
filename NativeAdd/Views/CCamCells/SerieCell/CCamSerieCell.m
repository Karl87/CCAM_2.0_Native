//
//  CCamSerieCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import "CCamSerieCell.h"
#import "Constants.h"

@implementation CCamSerieCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *selectedBG = [[UIView alloc] initWithFrame:self.bounds];
        [selectedBG setBackgroundColor:CCamExLightGrayColor];
        
        self.selectedBackgroundView = selectedBG;
        if (_serieImage == nil) {
            _serieImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.height-4)];
            [_serieImage setBackgroundColor:[UIColor clearColor]];
            [_serieImage setContentMode:UIViewContentModeScaleAspectFit];
            [_serieImage setClipsToBounds:YES];
            [self.contentView addSubview:_serieImage];
        }
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
