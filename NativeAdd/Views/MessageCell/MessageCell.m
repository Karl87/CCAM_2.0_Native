//
//  MessageCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/28.
//
//

#define profileSize 44.0

#import "MessageCell.h"
#import "Constants.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "CCUserViewController.h"

@interface MessageCell ()

@property (nonatomic,strong) UIImageView *profileImage;
@property (nonatomic,strong) UIButton *userName;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *messageImage;
@end

@implementation MessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpMessageCell];
        
    }
    return self;
}
- (void)setUpMessageCell{
    _profileImage = [UIImageView new];
    [_profileImage.layer setMasksToBounds:YES];
    [_profileImage.layer setCornerRadius:profileSize/2];
    
    _messageImage = [UIImageView new];
    
    _userName = [UIButton new];
    [_userName setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_userName.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    _messageLabel = [UILabel new];
    [_messageLabel setBackgroundColor:[UIColor clearColor]];
    [_messageLabel setTextAlignment:NSTextAlignmentLeft];
    [_messageLabel setTextColor:CCamGrayTextColor];
    [_messageLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    _timeLabel = [UILabel new];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [_timeLabel setTextColor:[UIColor lightGrayColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    NSArray *views = @[_profileImage,_userName,_timeLabel,_messageLabel,_messageImage];
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    UIView *contentView = self.contentView;
    
    _profileImage.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,7)
    .heightIs(profileSize)
    .widthIs(profileSize);
    
    _userName.sd_layout
    .leftSpaceToView(_profileImage,10)
    .topEqualToView(_profileImage)
    .heightIs(10);
    
    _messageImage.sd_layout
    .rightSpaceToView(contentView,10)
    .topEqualToView(_profileImage)
    .heightIs(60)
    .widthIs(60);
    
    _messageLabel.sd_layout
    .leftEqualToView(_userName)
    .rightSpaceToView(_messageImage,10)
    .topSpaceToView(_userName,0)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .leftEqualToView(_userName)
    .topSpaceToView(_messageLabel,5).heightIs(15).widthIs(150);
    
    [self setupAutoHeightWithBottomViewsArray:@[_timeLabel] bottomMargin:5];
}
- (void)setMessage:(CCMessage *)message{
    _message = message;
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [_userName setTitle:_message.messageUserName forState:UIControlStateNormal];
    [_userName sizeToFit];
    _userName.sd_layout.widthIs(_userName.bounds.size.width+2);
    [_profileImage sd_setImageWithURL:[NSURL URLWithString:_message.messageUserImage]];
    [_messageImage  sd_setImageWithURL:[NSURL URLWithString:_message.messagePhoto]];
    [_messageLabel setText:_message.message];
    
    if ([_message.messageType isEqualToString:@"2"]) {
        
    }else if ([_message.messageType isEqualToString:@"3"]) {
        [_userName setTitle:Babel(@"系统消息") forState:UIControlStateNormal];
        [_userName sizeToFit];
        _userName.sd_layout.widthIs(_userName.bounds.size.width+2);
        [_profileImage setImage:[UIImage imageNamed:@"ccam"]];
        [_messageLabel setText:Babel(@"棒棒哒，您的作品被选为精选！")];
    }else if ([_message.messageType isEqualToString:@"4"]) {
        [_userName setTitle:Babel(@"系统消息") forState:UIControlStateNormal];
        [_userName sizeToFit];
        _userName.sd_layout.widthIs(_userName.bounds.size.width+2);
        [_profileImage setImage:[UIImage imageNamed:@"ccam"]];
    }else if ([_message.messageType isEqualToString:@"5"]) {
        [_messageLabel setText:Babel(@"赞了你的照片！")];
    }else if ([_message.messageType isEqualToString:@"6"]){
        if (![_message.messageURL isEqualToString:@""]) {
            [_userName setTitle:Babel(@"系统消息") forState:UIControlStateNormal];
            [_userName sizeToFit];
            _userName.sd_layout.widthIs(_userName.bounds.size.width+2);
            [_profileImage setImage:[UIImage imageNamed:@"ccam"]];
        }
    }
    
    NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:[_message.creatTime integerValue]];
    [_timeLabel setText:[self compareCurrentTime:timeDate]];
    _messageLabel.sd_layout.maxHeightIs(MAXFLOAT);//.minHeightIs(15);
}
-(NSString *) compareCurrentTime:(NSDate*) compareDate{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:Babel(@"刚刚")];
    }else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld%@",temp,Babel(@"分钟前")];
    }else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld%@",temp,Babel(@"小时前")];
    }else if((temp = temp/24) <7){
        result = [NSString stringWithFormat:@"%ld%@",temp,Babel(@"天前")];
    }
    //    else if((temp = temp/30) <12){
    //        result = [NSString stringWithFormat:@"%ld月前",temp];
    //    }
    else{
        //        temp = temp/12;
        //        result = [NSString stringWithFormat:@"%ld年前",temp];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    
    return  result;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
