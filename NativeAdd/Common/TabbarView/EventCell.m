//
//  EventCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/11.
//
//

#import "EventCell.h"
#import "Constants.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import "WLCircleProgressView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CCamHelper.h"

@interface EventCell ()
@property (nonatomic,strong) UIView *eventBG;
@property (nonatomic,strong) UIImageView *eventImage;
@property (nonatomic,strong) UIButton *eventTitle;
@property (nonatomic,strong) UIButton *eventPicNum;
@property (nonatomic,strong) UILabel *eventDescriptrion;
@property (nonatomic,strong) WLCircleProgressView *imageProgress;

@end
@implementation EventCell

- (void)setUpEventCell{
    
    UIView *contentView = self.contentView;
    
    _eventBG =[UIView new];
    [_eventBG.layer setMasksToBounds:YES];
    [_eventBG.layer setCornerRadius:10.0];
    [_eventBG setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:_eventBG];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_eventBG.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _eventBG.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _eventBG.layer.mask = maskLayer;
    
    
    _eventImage = [UIImageView new];
    [contentView addSubview:_eventImage];
   
    
    _imageProgress = [WLCircleProgressView viewWithFrame:CGRectMake(0, 0, 80, 80) circlesSize:CGRectMake(30, 5, 30, 5)];
    [_imageProgress setBackgroundColor:[UIColor clearColor]];
    _imageProgress.backCircle.shadowColor = [UIColor grayColor].CGColor;
    _imageProgress.backCircle.shadowRadius = 3;
    _imageProgress.backCircle.shadowOffset = CGSizeMake(0, 0);
    _imageProgress.backCircle.shadowOpacity = 1;
    _imageProgress.progressValue = 0.0;
    [contentView addSubview:_imageProgress];
    [_imageProgress setHidden:YES];
    
    _eventTitle = [UIButton new];
    [_eventTitle setBackgroundColor:[UIColor whiteColor]];
    [_eventTitle setImage:[UIImage imageNamed:@"joinEventIcon"] forState:UIControlStateNormal];
    [_eventTitle setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
//    [_eventTitle setBackgroundImage:[[[UIImage imageNamed:@"eventTitleBG"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_eventTitle setBackgroundColor:CCamRedColor];
    [_eventTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_eventTitle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_eventTitle setTintColor:CCamRedColor];
    [_eventTitle.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [contentView addSubview:_eventTitle];
    
    _eventPicNum = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eventPicNum setImage:[[UIImage imageNamed:@"eventHotBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_eventPicNum setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_eventPicNum setTitle:@"0" forState:UIControlStateNormal];
    [_eventPicNum setTintColor:CCamRedColor];
    [_eventPicNum setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_eventPicNum.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_eventPicNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [contentView addSubview:_eventPicNum];
    
    _eventDescriptrion = [UILabel new];
    [_eventDescriptrion setFont:[UIFont systemFontOfSize:13.0]];
    [_eventDescriptrion setTextColor:CCamGrayTextColor];
    [contentView addSubview:_eventDescriptrion];

}
- (void)setEvent:(CCEvent *)event{
    _event = event;
    UIView *contentView = self.contentView;
    contentView.backgroundColor = CCamViewBackgroundColor;
    
    
    _eventBG.sd_layout
    .leftSpaceToView(contentView,5)
    .rightSpaceToView(contentView,5)
    .topSpaceToView(contentView,5);
    
    _eventImage.sd_layout
    .leftSpaceToView(contentView,5)
    .rightSpaceToView(contentView,5)
    .topSpaceToView(contentView,5)
    .heightIs((CCamViewWidth-10)*288/640);
    
    _imageProgress.sd_layout
    .centerXEqualToView(_eventImage)
    .centerYEqualToView(_eventImage);
    
    _eventTitle.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(_eventImage,8);
    
    _eventPicNum.sd_layout
    .rightSpaceToView(contentView,15)
    .topSpaceToView(_eventImage,8);
    
    _eventDescriptrion.sd_layout
    .leftSpaceToView(contentView,15)
    .rightSpaceToView(contentView,15)
    .topSpaceToView(_eventTitle,8)
    .autoHeightRatio(0);
    
    [_imageProgress setHidden:NO];
    
    NSString *imageURL;
    NSString *eventNote;
    NSString *language = [[SettingHelper sharedManager] getCurrentLanguage];
    
    if ([language hasPrefix:@"zh-Hans"]) {
        imageURL = _event.eventImageURLCn;
        eventNote = _event.eventDescriptionCn;
    }else if ([language hasPrefix:@"zh-Hant"]){
        imageURL = _event.eventImageURLZh;
        eventNote = _event.eventDescriptionZh;
    }else{
        imageURL = _event.eventImageURLEn;
        eventNote = _event.eventDescriptionEn;
    }
    
    [_eventImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
        _imageProgress.progressValue =progress ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_imageProgress setHidden:YES];
    }];
    
    [_eventTitle setTitle:[NSString stringWithFormat:@"%@",_event.eventName] forState:UIControlStateNormal];
    [_eventTitle sizeToFit];
    _eventTitle.sd_layout.widthIs(_eventTitle.bounds.size.width+28);
    _eventTitle.sd_layout.heightIs(_eventTitle.bounds.size.height+8);
    
    [_eventPicNum setTitle:[NSString stringWithFormat:@"%@",_event.eventCount] forState:UIControlStateNormal];
    [_eventPicNum sizeToFit];
    _eventPicNum.sd_layout.widthIs(_eventTitle.bounds.size.width+4);
    _eventPicNum.sd_layout.heightIs(_eventTitle.bounds.size.height+4);
    
    [_eventDescriptrion setText:eventNote];
    _eventDescriptrion.sd_layout.maxHeightIs(MAXFLOAT);
    
    [self setupAutoHeightWithBottomView:_eventDescriptrion bottomMargin:16];

    _eventBG.sd_layout
    .topSpaceToView(contentView,5)
    .leftSpaceToView(contentView,5)
    .rightSpaceToView(contentView,5)
    .bottomSpaceToView(contentView,5);
    
    
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath *imageMaskPath = [UIBezierPath bezierPathWithRoundedRect:_eventImage.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *imageMaskLayer = [[CAShapeLayer alloc] init];
    imageMaskLayer.frame = _eventImage.bounds;
    imageMaskLayer.path = imageMaskPath.CGPath;
    _eventImage.layer.mask = imageMaskLayer;
    
    UIBezierPath *btnMaskPath = [UIBezierPath bezierPathWithRoundedRect:_eventTitle.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(_eventTitle.bounds.size.height/2, _eventTitle.bounds.size.height/2)];
    CAShapeLayer *btnMaskLayer = [[CAShapeLayer alloc] init];
    btnMaskLayer.frame = _eventTitle.bounds;
    btnMaskLayer.path = btnMaskPath.CGPath;
    _eventTitle.layer.mask = btnMaskLayer;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setUpEventCell];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
