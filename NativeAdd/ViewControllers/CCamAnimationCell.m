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
- (void)UILoadingCharacter{
    if (_mask) {
        [_mask setHidden:NO];
        if (_loading) {
            [_loading startAnimating];
        }
    }
    [self performSelector:@selector(UIEndLoading) withObject:nil afterDelay:0.5];
}
- (void)UIEndLoading{
    if (_mask) {
        [_mask setHidden:YES];
        if (_loading) {
            [_loading stopAnimating];
        }
    }
}
@end
