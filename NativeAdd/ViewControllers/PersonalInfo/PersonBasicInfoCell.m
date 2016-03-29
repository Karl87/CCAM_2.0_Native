//
//  PersonBasicInfoCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/24.
//
//

#import "PersonBasicInfoCell.h"
#import "Constants.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>

const CGFloat imageSize = 20.0;

@implementation PersonBasicInfoCell{
    UIImageView *_typeImage;
    UILabel * _typeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpInfoCell];
    }
    return self;
}

- (void)setUpInfoCell{
    
    UIView *contentView = self.contentView;
    
    _typeImage = [UIImageView new];
    [_typeImage setBackgroundColor:[UIColor whiteColor]];
    [_typeImage.layer setMasksToBounds:YES];
    [_typeImage.layer setCornerRadius:imageSize/2];
    [contentView addSubview:_typeImage];
    
    _typeLabel = [UILabel new];
    [_typeLabel setBackgroundColor:[UIColor whiteColor]];
    [_typeLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_typeLabel setTextColor:CCamGrayTextColor];
    [contentView addSubview:_typeLabel];
    
    _typeImage.sd_layout
    .topSpaceToView(contentView,12)
    .leftSpaceToView(contentView,10)
    .widthIs(imageSize)
    .heightIs(imageSize);
    
    _typeLabel.sd_layout
    .leftSpaceToView(_typeImage,10)
    .topSpaceToView(contentView,5)
    .rightSpaceToView(contentView,10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[_typeImage,_typeLabel] bottomMargin:5];
//    [self setupAutoHeightWithBottomView:_typeLabel bottomMargin:5];
}
- (void)setInfo:(NSDictionary *)info{
    _info = info;
    if ([_type isEqualToString:@"nickName"]) {
        [_typeImage setImage:[UIImage imageNamed:@"infoNickName"]];
        [_typeLabel setText:[_info objectForKey:@"name"]];
        if ([[_info objectForKey:@"name"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"请填写您的昵称")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"gender"]){
        [_typeImage setImage:[UIImage imageNamed:@"infoGender"]];
        
        if ([[_info objectForKey:@"sex"] isEqualToString:@"1"]) {
            [_typeLabel setText:Babel(@"男")];

        }else if ([[_info objectForKey:@"sex"] isEqualToString:@"2"]) {
            [_typeLabel setText:Babel(@"女")];

        }else if ([[_info objectForKey:@"sex"] isEqualToString:@"3"]) {
            [_typeLabel setText:Babel(@"保密")];

        }
        if ([[_info objectForKey:@"sex"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"请选择您的性别")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"birth"]){
        [_typeImage setImage:[UIImage imageNamed:@"infoBirth"]];
        [_typeLabel setText:[_info objectForKey:@"birthday"]];
        if ([[_info objectForKey:@"birthday"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"请填写您的生日")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"des"]){
        [_typeImage setImage:[UIImage imageNamed:@"infoDes"]];
        [_typeLabel setText:[_info objectForKey:@"description"]];
        if ([[_info objectForKey:@"description"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"请填写您的简介")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"trueName"]){
        [_typeImage setImage:[UIImage imageNamed:@"infoTrueName"]];
        [_typeLabel setText:[_info objectForKey:@"consignee_name"]];
        if ([[_info objectForKey:@"consignee_name"] isEqualToString:@""]) {
            [_typeLabel setText:@"请填写收奖人姓名"];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"trueMobile"]){
        [_typeImage setImage:[UIImage imageNamed:@"infoMobile"]];
        [_typeLabel setText:[_info objectForKey:@"consignee_phone"]];
        if ([[_info objectForKey:@"consignee_phone"] isEqualToString:@""]) {
            [_typeLabel setText:@"请填写收奖人手机号码"];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"trueAddress"]){
        [_typeImage setImage:[UIImage imageNamed:@"infoAddress"]];
        [_typeLabel setText:[_info objectForKey:@"consignee_local"]];
        if ([[_info objectForKey:@"consignee_local"] isEqualToString:@""]) {
            [_typeLabel setText:@"请填写收奖人地址"];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"bandMobile"]){
        [_typeImage setImage:[UIImage imageNamed:@"infoMobile"]];
        [_typeLabel setText:[_info objectForKey:@"phone"]];
        if ([[_info objectForKey:@"phone"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"尚未绑定")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"bandWechat"]){
        [_typeImage setImage:[[UIImage imageNamed:@"wechatIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_typeImage setTintColor:CCamRedColor];        [_typeLabel setText:[_info objectForKey:@"wechat_name"]];
        if ([[_info objectForKey:@"wechat_name"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"尚未绑定")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"bandWeibo"]){
        [_typeImage setImage:[[UIImage imageNamed:@"weiboIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_typeImage setTintColor:CCamRedColor];        [_typeLabel setText:[_info objectForKey:@"weibo_name"]];
        if ([[_info objectForKey:@"weibo_name"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"尚未绑定")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"bandQQ"]){
        [_typeImage setImage:[[UIImage imageNamed:@"qqIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_typeImage setTintColor:CCamRedColor];        [_typeLabel setText:[_info objectForKey:@"QQ_name"]];
        if ([[_info objectForKey:@"QQ_name"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"尚未绑定")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }else if ([_type isEqualToString:@"bandFacebook"]){
        [_typeImage setImage:[[UIImage imageNamed:@"facebookIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_typeImage setTintColor:CCamRedColor];
        [_typeLabel setText:[_info objectForKey:@"facebook_name"]];
        if ([[_info objectForKey:@"facebook_name"] isEqualToString:@""]) {
            [_typeLabel setText:Babel(@"尚未绑定")];
            [_typeLabel setTextColor:CCamViewBackgroundColor];
        }
    }
    _note = _typeLabel.text;

    _typeLabel.sd_layout.minHeightIs(34);
    _typeLabel.sd_layout.maxHeightIs(MAXFLOAT);
}
- (void)setType:(NSString *)type{
    _type = type;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
