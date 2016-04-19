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
#import "MLLinkLabel.h"
#import "CommentViewController.h"

@interface CommentCell ()<MLLinkLabelDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIImageView *profileImage;
@property (nonatomic,strong) MLLinkLabel *userName;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) MLLinkLabel *commentLabel;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIAlertView *deleteAlert;
@end

@implementation CommentCell

- (void)deleteComment{
    _deleteAlert = [[UIAlertView alloc] initWithTitle:Babel(@"提示") message:@"是否删除评论？" delegate:self cancelButtonTitle:Babel(@"取消") otherButtonTitles:Babel(@"删除"), nil];
    [_deleteAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _deleteAlert) {
        if (buttonIndex == 1) {
            if ([_parent isKindOfClass:[CommentViewController class]]) {
                CommentViewController *vc = (CommentViewController*)_parent;
                [vc deleteCommentWith:self.indexPath];
            }
        }
    }
}
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
    
    _userName = [MLLinkLabel new];
    _userName.dataDetectorTypes = MLDataDetectorTypeAll;
    _userName.allowLineBreakInsideLinks = YES;
    _userName.linkTextAttributes = nil;
    _userName.activeLinkTextAttributes = nil;
    [_userName setTextColor:CCamGrayTextColor];
    _userName.font = [UIFont boldSystemFontOfSize:14];
    _userName.delegate = self;
    [_userName setBeforeAddLinkBlock:^(MLLink *link) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:CCamGrayTextColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
    }];
    
    _timeLabel = [UILabel new];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [_timeLabel setTextColor:[UIColor lightGrayColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    _deleteButton = [UIButton new];
    [_deleteButton setBackgroundColor:[UIColor clearColor]];
    [_deleteButton setTitle:Babel(@"删除") forState:UIControlStateNormal];
    [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_deleteButton setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_deleteButton sizeToFit];
    [_deleteButton setHidden:YES];
    
    _commentLabel = [MLLinkLabel new];
    _commentLabel.dataDetectorTypes = MLDataDetectorTypeAll;
    _commentLabel.allowLineBreakInsideLinks = YES;
    _commentLabel.linkTextAttributes = nil;
    _commentLabel.activeLinkTextAttributes = nil;
    [_commentLabel setTextColor:CCamGrayTextColor];
    _commentLabel.font = [UIFont systemFontOfSize:13];
    _commentLabel.delegate = self;
    [_commentLabel setBeforeAddLinkBlock:^(MLLink *link) {
        if (link.linkType==MLLinkTypeOther) {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:CCamRedColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
        }else{
            link.linkTextAttributes = @{NSForegroundColorAttributeName:kDefaultLinkColorForMLLinkLabel};
        }
    }];

    
//    [_commentLabel setBackgroundColor:[UIColor clearColor]];
//    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
//    [_commentLabel setTextColor:CCamGrayTextColor];
//    [_commentLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    NSArray *views = @[_profileImage,_userName,_timeLabel,_commentLabel,_deleteButton];
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
    .rightSpaceToView(contentView,20)
    .topEqualToView(_profileImage)
    .heightIs(profileSize);
    
    _timeLabel.sd_layout
    .rightSpaceToView(contentView,10)
    .topEqualToView(_profileImage)
    .heightIs(profileSize);
    
    _deleteButton.sd_layout
    .rightSpaceToView(_timeLabel,10)
    .topEqualToView(_profileImage)
    .heightIs(profileSize);
    
    _commentLabel.sd_layout
    .leftEqualToView(_userName)
    .rightEqualToView(_timeLabel)
    .topSpaceToView(_profileImage,10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_commentLabel bottomMargin:10];
}
- (void)openUserPageWithID:(NSString*)userID andName:(NSString*)userName{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    userpage.userID = userID;
    userpage.vcTitle = userName;
    userpage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:userpage];

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
    [_deleteButton addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchUpInside];
    [_profileImage sd_setImageWithURL:[NSURL URLWithString:_comment.userImage] placeholderImage:nil];
    [_userName setText:_comment.userName];
    
    _userName.attributedText = [self generateTitleAttributedStringWithCommentItemModel:comment];
    
    if ([_comment.dateline isEqualToString:@"-1"]) {
        [_timeLabel setText:Babel(@"刚刚")];
    }else{
        NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:[_comment.dateline integerValue]];
        [_timeLabel setText:[self compareCurrentTime:timeDate]];
    }
    
    [_timeLabel sizeToFit];
    _timeLabel.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topEqualToView(_profileImage)
    .heightIs(profileSize)
    .widthIs(_timeLabel.frame.size.width+2);
    
    _deleteButton.sd_layout
    .rightSpaceToView(self.contentView,20+_timeLabel.frame.size.width)
    .topEqualToView(_profileImage)
    .heightIs(profileSize)
    .widthIs(_deleteButton.frame.size.width+2);
    
    if ([comment.userID isEqualToString:[[AuthorizeHelper sharedManager] getUserID]]) {
        if (!self.isDescription) {
            [_deleteButton setHidden:NO];
        }
    }else{
        [_deleteButton setHidden:YES];
    }
    
    _commentLabel.attributedText = [self generateAttributedStringWithCommentItemModel:comment];
//    [_commentLabel setText:_comment.comment];
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
#pragma mark - private actions

- (NSMutableAttributedString *)generateTitleAttributedStringWithCommentItemModel:(CCComment *)model
{
    NSString* name = model.userName;
    NSString* userid = model.userID;
    
    if (!name || !userid) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@""];
        return attString;
    }
    
    NSString *text = name;
    
//    text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", model.comment]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = CCamRedColor;
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userID} range:[text rangeOfString:model.userName]];
    
    return attString;
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(CCComment *)model
{
    NSString* name = model.userName;
    NSString* userid = model.userID;
    NSString *comment = model.comment;
    //    NSLog(@"fuck %@;%@;%@",name,userid,comment);
    
    if (!name || !userid || !comment) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@""];
        return attString;
    }
    
    NSString *text = @"";
    
    if (model.replyUserID.length && model.replyUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复 %@ : ", model.replyUserName]];
    }
    
    text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", model.comment]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = CCamRedColor;
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userID} range:[text rangeOfString:model.userName]];
    
    if (model.replyUserName) {
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.replyUserID} range:[text rangeOfString:model.replyUserName]];
    }
    
    return attString;
}


#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"LinkType:%lu",(unsigned long)link.linkType);
    NSLog(@"LinkText:%@", linkText);
    NSLog(@"LinkValue:%@", link.linkValue);
    
    if (link.linkType == MLLinkTypeOther) {
        [self openUserPageWithID:link.linkValue andName:linkText];
    }
    
//    if (_parent && [_parent isKindOfClass:[TimelineCell class]]&&link.linkType==MLLinkTypeOther) {
//        TimelineCell*cell = (TimelineCell*)_parent;
//        [cell openUserPageWithID:link.linkValue andName:linkText];
//    }
}
@end
