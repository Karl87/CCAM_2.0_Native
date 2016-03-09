//
//  CCamSerieContentSurfaceView.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/8.
//
//

#import "CCamSerieContentSurfaceView.h"
#import "Constants.h"

@implementation CCamSerieContentSurfaceView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        
        if (!_surfaceBG) {
            _surfaceBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            [_surfaceBG setBackgroundColor:[UIColor whiteColor]];
            [_surfaceBG setContentMode:UIViewContentModeScaleAspectFill];
            [_surfaceBG setClipsToBounds:YES];
            [self addSubview:_surfaceBG];
        }
        
        if (!_surfaceMask) {
            _surfaceMask = [[UIView alloc] initWithFrame:_surfaceBG.frame];
            [_surfaceMask setBackgroundColor:[UIColor colorWithWhite:0 alpha:1.0]];
            [_surfaceMask setAlpha:0.6];
            [self addSubview:_surfaceMask];
        }
        
        if (!_surfaceImage) {
            _surfaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-86, self.bounds.size.height/2 - 33, 66, 66)];
            [_surfaceImage setContentMode:UIViewContentModeScaleAspectFit];
            [self addSubview:_surfaceImage];
            [_surfaceImage setBackgroundColor:[UIColor clearColor]];
        }
        if (!_surfaceButton) {
            _surfaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_surfaceButton setBackgroundColor:CCamRedColor];
            [_surfaceButton setTitle:@"免费下载" forState:UIControlStateNormal];
            [_surfaceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
//            [_surfaceButton setFrame:CGRectMake(self.bounds.size.width/2+10, self.bounds.size.height/2 - 15, 100, 30)];
            [_surfaceButton setFrame:CGRectMake(0,0, 200, 44)];
            [_surfaceButton setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
            [_surfaceButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_surfaceButton.layer setMasksToBounds:YES];
            [_surfaceButton.layer setCornerRadius:8.0];
            [self addSubview:_surfaceButton];
            [_surfaceButton setHidden:YES];
        }
        if (!_surfaceProgress) {
            _surfaceProgress  = [[M13ProgressViewImage alloc] initWithFrame:CGRectMake(self.bounds.size.width/2+10, self.bounds.size.height/2 - 10, 100, 20)];
            [_surfaceProgress setProgressImage:[UIImage imageNamed:@"serieDownloadProgress"]];
            [_surfaceProgress setProgressDirection:M13ProgressViewImageProgressDirectionLeftToRight];
            [_surfaceProgress setProgress:0.8 animated:NO];
            [self addSubview:_surfaceProgress];
            [_surfaceProgress setHidden:YES];
        }
    }
    return self;
}

@end
