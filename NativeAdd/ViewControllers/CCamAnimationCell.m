//
//  CCamAnimationCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import "CCamAnimationCell.h"

@implementation CCamAnimationCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
@end
