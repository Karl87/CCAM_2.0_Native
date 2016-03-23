//
//  SerieCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/11.
//
//

#import "SerieCell.h"
#import "Constants.h"
@implementation SerieCell
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_serieImage setFrame:CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10)];
    [_imageProgress setCenter:self.contentView.center];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setBackgroundColor:CCamViewBackgroundColor];
    if (self) {
        if (!_serieImage) {
            _serieImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_serieImage setBackgroundColor:[UIColor whiteColor]];
            [_serieImage.layer setMasksToBounds:YES];
            [_serieImage.layer setCornerRadius:10.0];
            [self.contentView addSubview:_serieImage];
        }
        
        if (!_imageProgress) {
            _imageProgress = [WLCircleProgressView viewWithFrame:CGRectMake(0, 0, 80, 80) circlesSize:CGRectMake(30, 5, 30, 5)];
            [_imageProgress setBackgroundColor:[UIColor clearColor]];
            _imageProgress.backCircle.shadowColor = [UIColor grayColor].CGColor;
            _imageProgress.backCircle.shadowRadius = 3;
            _imageProgress.backCircle.shadowOffset = CGSizeMake(0, 0);
            _imageProgress.backCircle.shadowOpacity = 1;
            _imageProgress.progressValue = 0.0;
            [self.contentView addSubview:_imageProgress];
            [_imageProgress setHidden:YES];
        }
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
