//
//  TestDownloadTableViewCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/9.
//
//

#import "TestDownloadTableViewCell.h"

@implementation TestDownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.progress == nil) {
        UIProgressView * progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        [progress setProgressTintColor:[UIColor redColor]];
        [progress setTrackTintColor:[UIColor blueColor]];
        
        [self.contentView addSubview:progress];
        _progress = progress;
        [_progress setFrame:CGRectMake(100, 50, 100, 0)];
    }
}
//- (UIProgressView *)progress{
//    UIProgressView * progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    
//    [progress setProgressTintColor:[UIColor redColor]];
//    [progress setTrackTintColor:[UIColor blueColor]];
//    
//    [self.contentView addSubview:progress];
//    
//    return progress;
//}
@end
