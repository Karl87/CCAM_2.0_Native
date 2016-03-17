//
//  CommentCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//
#define profileSize 30.0

#import "CommentCell.h"
#import "Constants.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "CCUserViewController.h"
@interface CommentCell ()
@property (nonatomic,strong) UIImageView *profileImage;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *userButton;
@property (nonatomic,strong) UILabel *commentLabel;

@end

@implementation CommentCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCommentCell];
        
    }
    return self;
}
- (void)setUpCommentCell{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _profileImage = [UIImageView new];
    [_profileImage.layer setMasksToBounds:YES];
    [_profileImage.layer setCornerRadius:profileSize/2];
    
    _userName = [UILabel new];
    [_userName setBackgroundColor:[UIColor clearColor]];
    [_userName setTextAlignment:NSTextAlignmentLeft];
    [_userName setTextColor:CCamGrayTextColor];
    [_userName setFont:[UIFont boldSystemFontOfSize:14.0]];
    
    _timeLabel = [UILabel new];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [_timeLabel setTextColor:[UIColor lightGrayColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    _userButton = [UIButton new];
    [_userButton setBackgroundColor:[UIColor clearColor]];
    
    _commentLabel = [UILabel new];
    [_commentLabel setBackgroundColor:[UIColor clearColor]];
    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentLabel setTextColor:CCamGrayTextColor];
    [_commentLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    NSArray *views = @[_profileImage,_userName,_timeLabel,_userButton,_commentLabel];
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
    .heightIs(profileSize)
    .widthIs(200);
    
    _timeLabel.sd_layout
    .rightSpaceToView(contentView,10)
    .topEqualToView(_profileImage)
    .heightIs(profileSize)
    .widthIs(150);
    
    _userButton.sd_layout
    .leftEqualToView(_profileImage)
    .rightEqualToView(_userName)
    .topEqualToView(_profileImage)
    .heightIs(profileSize);
    
    _commentLabel.sd_layout
    .leftEqualToView(_userName)
    .rightEqualToView(_timeLabel)
    .topSpaceToView(_profileImage,10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_commentLabel bottomMargin:10];
}
- (void)callUserPage:(id)sender{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    userpage.userID = _comment.userID;
    userpage.vcTitle = _comment.userName;
    userpage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:userpage];
}
- (void)callOtherVC:(id)vc{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    _parent.navigationItem.backBarButtonItem=backItem;
    [_parent.navigationController pushViewController:vc animated:YES];
}
- (void)setComment:(CCComment *)comment{
    _comment = comment;
    [_userButton addTarget:self action:@selector(callUserPage:) forControlEvents:UIControlEventTouchUpInside];
    [_profileImage sd_setImageWithURL:[NSURL URLWithString:_comment.userImage] placeholderImage:nil];
    [_userName setText:_comment.userName];
    
    if ([_comment.dateline isEqualToString:@"-1"]) {
        [_timeLabel setText:Babel(@"刚刚")];
    }else{
        NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:[_comment.dateline integerValue]];
        [_timeLabel setText:[self compareCurrentTime:timeDate]];
    }
    
    [_commentLabel setText:_comment.comment];
    _commentLabel.sd_layout.maxHeightIs(MAXFLOAT);
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
@end
