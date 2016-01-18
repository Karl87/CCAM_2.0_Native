//
//  EventCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/11.
//
//

#import "EventCell.h"
#import "Constants.h"
@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_eventBG setFrame:CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10)];
    [_eventImage setFrame:CGRectMake(0, 0, _eventBG.bounds.size.width, _eventBG.bounds.size.height-40)];
    [_eventTitle setCenter:CGPointMake(_eventTitle.frame.size.width/2+5, _eventImage.frame.size.height+5+_eventTitle.frame.size.height/2)];
    
    [_eventPicNum setCenter:CGPointMake(self.bounds.size.width-15-_eventPicNum.bounds.size.width/2, _eventImage.frame.size.height+5+_eventPicNum.frame.size.height/2)];
    
    [_eventDescriptrion setFrame:CGRectMake(5, _eventBG.bounds.size.height-16, 300, 16)];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setBackgroundColor:CCamViewBackgroundColor];
    if (self) {
        if (!_eventBG) {
            _eventBG  = [[UIView alloc] initWithFrame:CGRectZero];
            [_eventBG setBackgroundColor:[UIColor whiteColor]];
            [self.contentView addSubview:_eventBG];
            [_eventBG.layer setMasksToBounds:YES];
            [_eventBG.layer setCornerRadius:8.0];
        }
        if (!_eventImage) {
            _eventImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_eventBG addSubview:_eventImage];
        }
        if (!_eventTitle) {
            _eventTitle = [UIButton buttonWithType:UIButtonTypeCustom];
            [_eventTitle setBackgroundImage:[[[UIImage imageNamed:@"eventTitleBG"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_eventTitle setTitle:@"event" forState:UIControlStateNormal];
            [_eventTitle setTintColor:CCamRedColor];
            [_eventTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_eventTitle.titleLabel setFont:[UIFont italicSystemFontOfSize:11.0]];
            [_eventBG addSubview:_eventTitle];
        }
        if (!_eventPicNum) {
            _eventPicNum = [UIButton buttonWithType:UIButtonTypeCustom];
            [_eventPicNum setImage:[[UIImage imageNamed:@"eventHotBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_eventPicNum setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
            [_eventPicNum setTitle:@"0" forState:UIControlStateNormal];
            [_eventPicNum setTintColor:CCamRedColor];
            [_eventPicNum setTitleColor:CCamRedColor forState:UIControlStateNormal];
            [_eventPicNum.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [_eventBG addSubview:_eventPicNum];
        }
        if (!_eventDescriptrion) {
            _eventDescriptrion = [[UILabel alloc] initWithFrame:CGRectMake(5, _eventBG.bounds.size.height-16, 300, 16)];
//            [_eventDescriptrion setBackgroundColor:CCamRedColor];
            [_eventDescriptrion setFont:[UIFont systemFontOfSize:9.0]];
            [_eventDescriptrion setTextColor:CCamGrayTextColor];
            [_eventBG addSubview:_eventDescriptrion];
        }
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
