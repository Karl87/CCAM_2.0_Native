//
//  CCStickerCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import "CCStickerCell.h"
#import "Constants.h"

@implementation CCStickerCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self layoutStickerCell];

    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)UILoadingSticker{
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
- (void)layoutStickerCell{
    if(!_stickerImage){
        _stickerImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/8, self.bounds.size.height/8, self.bounds.size.width*3/4, self.bounds.size.height*3/4)];
        [_stickerImage setBackgroundColor:[UIColor clearColor]];
        [_stickerImage setContentMode:UIViewContentModeScaleAspectFill];
        [_stickerImage setClipsToBounds:YES];
        [self.contentView addSubview:_stickerImage];
    }
    
    if (!_stateImage) {
        _stateImage = [[UIImageView alloc] init];
        [_stateImage setFrame:CGRectMake(0, 0, 16, 16)];
        [_stateImage setBackgroundColor:[UIColor clearColor]];
        [_stateImage setCenter:CGPointMake(self.bounds.size.width-self.bounds.size.height/8-13, self.bounds.size.height-self.bounds.size.height/8-13)];
        [self.contentView addSubview:_stateImage];
    }
    
    if (!_downloadProgress) {
         _downloadProgress  = [[M13ProgressViewBorderedBar alloc] initWithFrame:CGRectMake(self.bounds.size.width/8, self.bounds.size.width*7/8+2, self.bounds.size.width*3/4, self.bounds.size.width/8-4)];
        [_downloadProgress setProgressDirection:M13ProgressViewBorderedBarProgressDirectionLeftToRight];
        [_downloadProgress setCornerType:M13ProgressViewBorderedBarCornerTypeCircle];
        [_downloadProgress setPrimaryColor:CCamRedColor];
        [_downloadProgress setSecondaryColor:CCamRedColor];
        [_downloadProgress setSuccessColor:CCamRedColor];
        [_downloadProgress setFailureColor:CCamRedColor];
        [self.contentView addSubview:_downloadProgress];
    }
    
    if (!_mask) {
        _mask = [UIView new];
        [_mask setFrame:_stickerImage.frame];
        [self.contentView addSubview:_mask];
        [_mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
        [_mask setHidden:YES];
    }
    
    if (!_loading) {
        _loading = [UIActivityIndicatorView new];
        [_loading setFrame:CGRectMake(0, 0, 44, 44)];
        [self.contentView addSubview:_loading];
        [_loading setCenter:self.contentView.center];
        [_loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_loading setTintColor:CCamRedColor];
        _loading.hidesWhenStopped = YES;
    }
}
@end
