//
//  CCamSubmitContestCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/5.
//
//

#import "CCamSubmitContestCell.h"
#import "Constants.h"
@implementation CCamSubmitContestCell
- (void)drawRect:(CGRect)rect{
    if (_cellBG == nil) {
        _cellBG = [[UIView alloc] initWithFrame:self.bounds];
        [_cellBG setBackgroundColor:[UIColor whiteColor]];
        UIImageView *cellCircle = [[UIImageView alloc] init];
        [cellCircle setBackgroundColor:[UIColor clearColor]];
        [cellCircle setImage:[[UIImage imageNamed:@"submitCircle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [cellCircle setTintColor:CCamGrayTextColor];
        [cellCircle setFrame:CGRectMake(self.bounds.size.width-50, 12, 20, 20)];
        [_cellBG addSubview:cellCircle];
        self.backgroundView = _cellBG;

    }
    if (_cellSelBG == nil) {
        _cellSelBG = [[UIView alloc] initWithFrame:self.bounds];
        [_cellSelBG setBackgroundColor:CCamBackgoundGrayColor];
        UIImageView *cellSelCircle = [[UIImageView alloc] init];
        [cellSelCircle setBackgroundColor:[UIColor clearColor]];
        [cellSelCircle setImage:[[UIImage imageNamed:@"submitCircle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [cellSelCircle setTintColor:CCamRedColor];
        [cellSelCircle setFrame:CGRectMake(self.bounds.size.width-50, 12, 20, 20)];
        [_cellSelBG addSubview:cellSelCircle];
        UIImageView *cellSelDot = [[UIImageView alloc] init];
        [cellSelDot setBackgroundColor:[UIColor clearColor]];
        [cellSelDot setImage:[[UIImage imageNamed:@"submitDot"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [cellSelDot setTintColor:CCamRedColor];
        [cellSelDot setFrame:CGRectMake(self.bounds.size.width-50, 12, 20, 20)];
        [_cellSelBG addSubview:cellSelDot];
        
        self.selectedBackgroundView = _cellSelBG;
    }
}
- (void)layoutCell{
    
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
