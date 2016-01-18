//
//  CCamSegmentCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import "CCamSegmentCell.h"
#import "Constants.h"

@implementation CCamSegmentCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:CCamSegmentColor];
        UIView* selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        UIView* littleBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-3, self.bounds.size.width, 3)];
        [littleBar setBackgroundColor:CCamRedColor];
        [selectView addSubview:littleBar];
        [selectView setBackgroundColor:CCamSegmentColor];
        [self setSelectedBackgroundView:selectView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_titleLabel == nil) {
        [self titleLabel];
    }
}
- (UILabel *)titleLabel{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:17.]];
    [self.contentView addSubview:_titleLabel];
    return _titleLabel;
}
@end
