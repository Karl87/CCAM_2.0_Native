//
//  CCamFilterCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/6.
//
//

#import "CCamFilterCell.h"
#import "Constants.h"
@implementation CCamFilterCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *selectedBG = [[UIView alloc] initWithFrame:self.bounds];
        [selectedBG setBackgroundColor:CCamViewBackgroundColor];
        UIView *selectedSign = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2)];
        [selectedSign setBackgroundColor:CCamRedColor];
        [selectedBG addSubview:selectedSign];
        
        self.selectedBackgroundView = selectedBG;
        
    }
    return self;
}
- (void)layoutFilterCell{
    
    
    if (_filterImage == nil) {
        _filterImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width-2)];
        [_filterImage setBackgroundColor:[UIColor clearColor]];
        [_filterImage setContentMode:UIViewContentModeScaleAspectFill];
        [_filterImage setClipsToBounds:YES];
        [self.contentView addSubview:_filterImage];
    }
    
    if (_filterLabel == nil) {
        _filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.width-22, self.bounds.size.width, 20)];
        [_filterLabel setTextColor:[UIColor whiteColor]];
        [_filterLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [_filterLabel setTextAlignment:NSTextAlignmentCenter];
        [_filterLabel setBackgroundColor:[UIColor clearColor]];
        [_filterLabel setClipsToBounds:YES];
        [self.contentView addSubview:_filterLabel];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
