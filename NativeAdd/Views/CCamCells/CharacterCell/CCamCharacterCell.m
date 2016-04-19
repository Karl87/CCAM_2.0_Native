//
//  CCam_m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import "CCamCharacterCell.h"
#import "Constants.h"
#import "CCamHelper.h"

@implementation CCamCharacterCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self layoutCharacterCell];
    }
    return self;
}
- (void)refreshProgress{
    
//    CGFloat progress = [[[DownloadHelper sharedManager].downloadInfos objectForKey:[NSString stringWithFormat:@"Character%@",_character.characterID]] floatValue];
//    NSLog(@"Cell progress = %f",progress);
//    
//    [_downloadProgress setHidden:NO];
//    
//    [_downloadProgress setProgress:progress animated:YES];
}
- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:_character.characterID object:nil];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)layoutCharacterCell{
    if(!_characterImage){
        _characterImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/8, self.bounds.size.height/8, self.bounds.size.width*3/4, self.bounds.size.height*3/4)];
        [_characterImage setBackgroundColor:[UIColor clearColor]];
        [_characterImage setContentMode:UIViewContentModeScaleAspectFill];
        [_characterImage setClipsToBounds:YES];
        [self.contentView addSubview:_characterImage];
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
}

@end
