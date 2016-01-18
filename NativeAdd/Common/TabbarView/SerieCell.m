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
    [_serieImage setFrame:CGRectMake(5, 2, self.bounds.size.width-10, self.bounds.size.height-4)];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setBackgroundColor:CCamViewBackgroundColor];
    if (self) {
        if (!_serieImage) {
            _serieImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_serieImage.layer setMasksToBounds:YES];
            [_serieImage.layer setCornerRadius:8.0];
            [self.contentView addSubview:_serieImage];
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
