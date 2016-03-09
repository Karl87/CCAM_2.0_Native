//
//  TimelineCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#define profileSize 36.0

#import "TimelineCell.h"
#import "TimelineCommentCell.h"

#import "Constants.h"
#import "CCamHelper.h"
#import "CCComment.h"
#import "CCLike.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "HXEasyCustomShareView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDAutoLayout/UIView+SDAutoLayout.h>

#import "KLWebViewController.h"
#import "CCUserViewController.h"
#import "CCCommentViewController.h"
#import "CCPhotoViewController.h"
#import "CommentViewController.h"
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>

#import "ShareViewController.h"

@interface TimelineCell ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,ShareViewDelegate>

@end

@implementation TimelineCell

- (void)setUpTimelineCell{
    
//    [self addObserver:self forKeyPath:@"timeline" options:NSKeyValueObservingOptionNew context:nil];
    
    _cellBG = [UIView new];
    [_cellBG setBackgroundColor:[UIColor whiteColor]];
    [_cellBG.layer setMasksToBounds:YES];
    [_cellBG.layer setCornerRadius:8.0];
    
    _profileImage = [UIImageView new];
    [_profileImage.layer setMasksToBounds:YES];
    [_profileImage.layer setCornerRadius:profileSize/2];
    
    _userButton = [UIButton new];
    [_userButton setBackgroundColor:[UIColor clearColor]];
    
    _userName = [UILabel new];
    [_userName setTextColor:CCamGrayTextColor];
    [_userName setFont:[UIFont systemFontOfSize:15.0]];
    [_userName setTextAlignment:NSTextAlignmentLeft];
    
    _photoTime = [UILabel new];
    [_photoTime setTextColor:[UIColor lightGrayColor]];
    [_photoTime setFont:[UIFont systemFontOfSize:10.0]];
    [_photoTime setTextAlignment:NSTextAlignmentLeft];
    
    _privacySign = [UIImageView new];
    [_privacySign setBackgroundColor:[UIColor whiteColor]];
    [_privacySign setImage:[[UIImage imageNamed:@"privacyIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_privacySign setTintColor:CCamRedColor];
    
    _photo = [UIImageView new];
    
    _photoTitle = [UIButton new];
    [_photoTitle setBackgroundColor:[UIColor whiteColor]];
    [_photoTitle setImage:[UIImage imageNamed:@"joinEventIcon"] forState:UIControlStateNormal];
    [_photoTitle setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_photoTitle setBackgroundImage:[[[UIImage imageNamed:@"eventTitleBG"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_photoTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_photoTitle setTintColor:CCamRedColor];
    [_photoTitle.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    _contestDes = [UILabel new];
    [_contestDes setBackgroundColor:[UIColor whiteColor]];
    [_contestDes setFont:[UIFont systemFontOfSize:10.0]];
    [_contestDes setNumberOfLines:0];
    [_contestDes setTextColor:CCamGrayTextColor];
    [_contestDes setTextAlignment:NSTextAlignmentLeft];
    
    _likeBorder = [UIView new];
    [_likeBorder setBackgroundColor:CCamViewBackgroundColor];
    _likeView = [UIView new];
//    _likeView.backgroundColor = [UIColor grayColor];
    _likesButton = [UIButton new];
    [_likesButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_likesButton setImage:[[UIImage imageNamed:@"littleLikeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_likesButton setTintColor:CCamRedColor];
    [_likesButton setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_likesButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [_likeView addSubview:_likesButton];
    
    _photoDes = [UILabel new];
    [_photoDes setBackgroundColor:[UIColor whiteColor]];
    [_photoDes setFont:[UIFont systemFontOfSize:12.0]];
    [_photoDes setNumberOfLines:0];
    [_photoDes setTextColor:CCamGrayTextColor];
    [_photoDes setTextAlignment:NSTextAlignmentLeft];
//    [_photoDes setBackgroundColor:[UIColor yellowColor]];
    
    _photoInput = [UIButton new];
    [_photoInput addTarget:self action:@selector(callCommentPage:) forControlEvents:UIControlEventTouchUpInside];
    [_photoInput setImage:[[UIImage imageNamed:@"commentIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_photoInput setTintColor:[UIColor lightGrayColor]];
    
    _photoLike = [UIButton new];
    [_photoLike setImage:[[UIImage imageNamed:@"likeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_photoLike setTintColor:[UIColor lightGrayColor]];
    [_photoLike addTarget:self action:@selector(likePhoto) forControlEvents:UIControlEventTouchUpInside];

    
    _photoMore = [UIButton new];
    [_photoMore setImage:[[UIImage imageNamed:@"moreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_photoMore setTintColor:[UIColor lightGrayColor]];
    [_photoMore addTarget:self action:@selector(callMoreActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    _commentBorder = [UIView new];
    [_commentBorder setBackgroundColor:CCamViewBackgroundColor];
    
    _commentTable = [UITableView new];
    [_commentTable setBounces:NO];
    [_commentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_commentTable setBackgroundColor:[UIColor blueColor]];
    
    NSArray *views = @[_cellBG,_profileImage,_userName,_userButton,_photoTime,_privacySign,_photo,_photoInput,_photoLike,_photoMore,_likeBorder,_likeView,_contestDes,_photoTitle,_commentBorder,_photoDes,_commentTable];
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    UIView *contentView = self.contentView;
    
    _profileImage.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(contentView,15)
    .heightIs(profileSize)
    .widthIs(profileSize);
    
    _userName.sd_layout
    .leftSpaceToView(_profileImage,10)
    .topEqualToView(_profileImage)
    .widthIs(200)
    .heightIs(profileSize/2);
    
    _photoTime.sd_layout
    .leftEqualToView(_userName)
    .bottomEqualToView(_profileImage)
    .widthIs(200)
    .heightIs(15);
    
    _userButton.sd_layout
    .leftEqualToView(_profileImage)
    .rightEqualToView(_userName)
    .topEqualToView(_profileImage)
    .heightIs(profileSize);
    
    _privacySign.sd_layout
    .rightSpaceToView(contentView,20)
    .centerYEqualToView(_profileImage)
    .widthIs(10)
    .heightIs(15);
    
    _photoTitle.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(_profileImage,10)
    .heightIs(20);
    
    _contestDes.sd_layout
    .leftSpaceToView(_photoTitle,10)
    .rightSpaceToView(contentView,10)
    .bottomEqualToView(_photoTitle)
    .heightIs(20);
    
    _photo.sd_layout
    .leftSpaceToView(contentView,5)
    .rightSpaceToView(contentView,5)
    .topSpaceToView(_photoTitle,10)
    .heightEqualToWidth();
    
    _photoLike.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(_photo,5)
    .heightIs(profileSize)
    .widthIs(profileSize);
    
    _photoInput.sd_layout
    .leftSpaceToView(_photoLike,10)
    .topEqualToView(_photoLike)
    .heightIs(profileSize)
    .widthIs(profileSize);
    
    _photoMore.sd_layout
    .rightSpaceToView(contentView,10)
    .topEqualToView(_photoLike)
    .heightIs(profileSize)
    .widthIs(profileSize);
    
    _likeBorder.sd_layout
    .leftSpaceToView(contentView,15)
    .rightSpaceToView(contentView,10)
    .topSpaceToView(_photoLike,0)
    .heightIs(0.5);
    
    _likeView.sd_layout
    .leftSpaceToView(contentView,20)
    .rightSpaceToView(contentView,10)
    .topSpaceToView(_likeBorder,0)
    .heightIs(0);
    
    _commentBorder.sd_layout
    .leftSpaceToView(contentView,15)
    .rightSpaceToView(contentView,10)
    .topSpaceToView(_likeView,0)
    .heightIs(0.5);
    
    _photoDes.sd_layout
    .leftSpaceToView(contentView,20)
    .rightSpaceToView(contentView,20)
    .topSpaceToView(_commentBorder,10)
    .autoHeightRatio(0);
    
    _commentTable.sd_layout
    .leftSpaceToView(contentView,10)
    .rightSpaceToView(contentView,10)
    .topSpaceToView(_photoDes,5)
    .heightIs(5);

//    [self setupAutoHeightWithBottomViewsArray:@[_photoLike,_likeView,_photoTitle,_photoDes,_commentTable] bottomMargin:15];
    [self setupAutoHeightWithBottomView:_commentTable bottomMargin:25];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpTimelineCell];

    }
    return self;
}
- (void)callContestWeb:(id)sender{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    UIButton *btn = (UIButton*)sender;
    KLWebViewController *detail = [[KLWebViewController alloc] init];
    detail.webURL = [NSString stringWithFormat:@"http://www.c-cam.cc/index.php/First/Photo/index/contestid/%ld.html",(long)btn.tag];
    detail.vcTitle =btn.currentTitle;
    detail.hidesBottomBarWhenPushed = YES;
    
    [self callOtherVC:detail];
}
- (void)callLikeUserPage:(id)sender{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    UIButton *button = (UIButton *)sender;
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    CCLike *like = (CCLike*)[_likes objectAtIndex:button.tag];
    userpage.userID = like.userID;
    userpage.vcTitle = like.userName;
    userpage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:userpage];
}
- (void)callUserPage:(id)sender{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    userpage.userID = _timeline.timelineUserID;
    userpage.vcTitle = _timeline.timelineUserName;
    userpage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:userpage];
}
- (void)callCommentUserPage:(id)sender{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    UIButton *btn = (UIButton*)sender;
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    userpage.userID = [NSString stringWithFormat:@"%ld",btn.tag];
    userpage.vcTitle = btn.currentTitle;
    userpage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:userpage];
}
- (void)callCommentPage:(id)sender{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    if ([self.parent isKindOfClass:[CCHomeViewController class]]) {
        CCHomeViewController *home = (CCHomeViewController *)self.parent;
        [home.reloadIndexs addObject:self.indexPath];
    }else if ([self.parent isKindOfClass:[CCUserViewController class]]){
        CCUserViewController *user = (CCUserViewController *)self.parent;
        [user.reloadIndexs addObject:self.indexPath];
    }else if ([self.parent isKindOfClass:[CCPhotoViewController class]]){
        CCPhotoViewController *photo = (CCPhotoViewController *)self.parent;
        [photo.reloadIndexs addObject:self.indexPath];
    }
    
    CommentViewController *commentPage = [[CommentViewController alloc] init];
    commentPage.photoID = _timeline.timelineID;
    commentPage.timeline = _timeline;
    commentPage.title = @"照片评论";
    commentPage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:commentPage];
}
- (void)callOtherVC:(id)vc{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    _parent.navigationItem.backBarButtonItem=backItem;
    [_parent.navigationController pushViewController:vc animated:YES];
}
- (void)setCellUI{
    
}
- (void)setTimeline:(CCTimeLine *)timeline{
    _timeline = timeline;
    
    [_userButton addTarget:self action:@selector(callUserPage:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![_timeline.cNameCN isEqualToString:@""]&&![_timeline.cNameCN isEqualToString:@"<null>"]) {
        [_photoTitle setTitle:[NSString stringWithFormat:@"%@",_timeline.cNameCN] forState:UIControlStateNormal];
        [_photoTitle sizeToFit];
        [_photoTitle setTag:[_timeline.timelineContestID intValue]];
        [_photoTitle addTarget:self action:@selector(callContestWeb:) forControlEvents:UIControlEventTouchUpInside];
        _photoTitle.sd_layout.widthIs(_photoTitle.bounds.size.width+24);
        _photoTitle.sd_layout.heightIs(_photoTitle.bounds.size.height+4);
        
//        NSString *endTime = [_timeline.dateEnd stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//        
//        if ([_timeline.countDown isEqualToString:@"-1"]) {
//            [_contestDes setText:[NSString stringWithFormat:@"* 比赛已结束，结果于%@日公布",endTime]];
//        }else if([_timeline.countDown intValue]>0){
//            [_contestDes setText:[NSString stringWithFormat:@"* 比赛还有%@天结束，结果于%@日公布",_timeline.countDown,endTime]];
//        }else if([_timeline.countDown intValue]==0){
//            [_contestDes setText:[NSString stringWithFormat:@"* 比赛即将结束，结果于%@日公布",endTime]];
//        }else{
//            [_contestDes setText:@""];
//        }
//        
//        [_contestDes sizeToFit];
//        _contestDes.sd_layout.bottomEqualToView(_photoTitle);
        
    }else{
        _photoTitle.sd_layout.heightIs(0);
        _photoTitle.hidden = YES;
        
        _contestDes.sd_layout.heightIs(0);
        _contestDes.hidden = YES;
        
        _photo.sd_layout
        .topSpaceToView(_profileImage,10);
    }
    
    if (![_timeline.timelineContestID isEqualToString:@"-1"]) {
        [_privacySign setHidden:YES];
    }
    
    [_profileImage sd_setImageWithURL:[NSURL URLWithString:_timeline.timelineUserImage] placeholderImage:nil];
    [_userName setText:_timeline.timelineUserName];
    [_photo sd_setImageWithURL:[NSURL URLWithString:_timeline.image_fullsize] placeholderImage:nil];
    NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:[_timeline.dateline integerValue]];
    [_photoTime setText:[self compareCurrentTime:timeDate]];
    

    if ([_timeline.liked isEqualToString:@"1"]) {
        [_photoLike setTintColor:CCamRedColor];
    }else{
        [_photoLike setTintColor:[UIColor lightGrayColor]];
    }
    
    if(!_likes){
        _likes = [NSMutableArray new];
    }
    [_likes removeAllObjects];
    for (CCLike * like in _timeline.likes) {
        [_likes addObject:like];
    }
    [self reloadLikes];
    
    if ([_likes count] == 0||[_timeline.likeCount intValue]==0) {
        _likeBorder.sd_layout
        .heightIs(0);
        _likeView.sd_layout
        .heightIs(0);
        _likeBorder.hidden = YES;
        _likeView.hidden = YES;
    }else{
        _likeBorder.sd_layout
        .heightIs(0.5);
        _likeView.sd_layout
        .heightIs(60);
    }
    
    if (![_timeline.timelineDes isEqualToString:@""]) {
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",_timeline.timelineUserName,_timeline.timelineDes]];
        [str addAttribute:NSForegroundColorAttributeName value:CCamRedColor range:NSMakeRange(0,_timeline.timelineUserName.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(0,_timeline.timelineUserName.length)];
        [_photoDes setAttributedText:str];
        [_photoDes setAttributedText:str];
        _photoDes.sd_layout.maxHeightIs(MAXFLOAT).minHeightIs(15);
    }else{
        _photoDes.sd_layout.topSpaceToView(_commentBorder,0).maxHeightIs(0).minHeightIs(0);
        _photoDes.hidden = YES;
    }
    
    if (_timeline.comments && [_timeline.comments count]&& [_timeline.comments count]>0 && [_timeline.commentCount intValue] !=0) {
//        _commentTable.sd_layout
//        .topSpaceToView(_photoDes,0)
//        .heightIs(0);
    }else{
        [_commentTable setHidden:YES];
    }
    
    [self reloadComments];
    
    if ([_comments count]==0) {
        _commentTable.sd_layout.heightIs(0).topSpaceToView(_photoDes,0);
    }else{
        if ([_timeline.commentCount intValue]>5) {
            
            CGFloat tableHeight = 0.0;
            for (int i= 0; i<_comments.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                id comment = [_comments objectAtIndex:indexPath.row];
                CGFloat cellHeight = [_commentTable cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[TimelineCommentCell class] contentViewWidth:CCamViewWidth];
//                NSLog(@"%f",cellHeight);
                tableHeight += cellHeight;
            }
            tableHeight+=30.0;
            _commentTable.sd_layout.heightIs(tableHeight);
            
        }else{
            CGFloat tableHeight = 0.0;
            for (int i= 0; i<_comments.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                id comment = [_comments objectAtIndex:indexPath.row];
                CGFloat cellHeight = [_commentTable cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[TimelineCommentCell class] contentViewWidth:CCamViewWidth];
//                NSLog(@"%f",cellHeight);
                tableHeight += cellHeight;
            }
            _commentTable.sd_layout.heightIs(tableHeight);
        }

    }
    
    if (_photoTitle.hidden && _photoDes.hidden && _commentTable.hidden) {
        _commentBorder.hidden = YES;
        _commentBorder.sd_layout.topSpaceToView(_likeView,0);
        
    }
    
    _cellBG.sd_layout
    .topSpaceToView(self.contentView,5)
    .leftSpaceToView(self.contentView,5)
    .rightSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5);
}
-(NSString *) compareCurrentTime:(NSDate*) compareDate{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if((temp = temp/24) <7){
        result = [NSString stringWithFormat:@"%ld天前",temp];
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

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reloadComments{
    if(!_comments){
        _comments = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_comments removeAllObjects];
    for (CCComment * comment in _timeline.comments) {
        [_comments insertObject:comment atIndex:0];
    }
    [_commentTable setDataSource:self];
    [_commentTable setDelegate:self];
    [_commentTable reloadData];
    
}
- (void)reloadLikes{

    dispatch_async(dispatch_get_main_queue(), ^{
        [_likesButton setTitle:[NSString stringWithFormat:@" %@ 个人赞过",_timeline.likeCount] forState:UIControlStateNormal];
        [_likesButton sizeToFit];
        [_likesButton setFrame:CGRectMake(0, 0, _likesButton.frame.size.width+2, 60)];
        
        
        for (int likeIndex = 0; likeIndex<_likes.count; likeIndex++) {
            
            UIImageView *likeImage = [UIImageView new];
            [likeImage setBackgroundColor:CCamViewBackgroundColor];
            [likeImage setFrame:CGRectMake(0, 0, 36, 36)];
            [likeImage.layer setMasksToBounds:YES];
            [likeImage.layer setCornerRadius:18.0];
            [_likeView addSubview:likeImage];
            [likeImage setCenter:CGPointMake(_likesButton.center.x+_likesButton.frame.size.width/2+(likeIndex+1)*10+(likeIndex*2+1)*18, _likesButton.center.y)];
            
            UIButton *likeBtn = [UIButton new];
            [likeBtn setBackgroundColor:[UIColor clearColor]];
            
            [likeBtn setFrame:CGRectMake(0, 0, 36, 36)];
//            [likeBtn.layer setMasksToBounds:YES];
//            [likeBtn.layer setCornerRadius:18.0];
            [_likeView addSubview:likeBtn];
            [likeBtn setCenter:CGPointMake(_likesButton.center.x+_likesButton.frame.size.width/2+(likeIndex+1)*10+(likeIndex*2+1)*18, _likesButton.center.y)];
            CCLike *like = (CCLike*)[_likes objectAtIndex:likeIndex];
            
            [likeImage sd_setImageWithURL:[NSURL URLWithString:like.userImage]];
            
            [likeBtn setTag:likeIndex];
            [likeBtn addTarget:self action:@selector(callLikeUserPage:) forControlEvents:UIControlEventTouchUpInside];
        }
    
    });
    
}
#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_timeline.commentCount intValue]>5) {
        if (section == 0) {
            return 1;
        }else{
            return [_comments count];
        }
    }else{
        return [_comments count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_timeline.commentCount intValue]>5) {
        return 2;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_timeline.commentCount intValue]>5 && indexPath.section == 0 &&indexPath.row ==0) {
        static NSString *identifier = @"ShowAllCommentCell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setText:[NSString stringWithFormat:@"所有%@条评论",_timeline.commentCount]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *identifier = @"TimelineCommentCell";
    TimelineCommentCell *cell = [[TimelineCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.comment = [_comments objectAtIndex:indexPath.row];
    cell.parent = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    if ([_timeline.commentCount intValue]>5 && indexPath.section == 0 &&indexPath.row ==0) {
        [self callCommentPage:nil];
    }else{
        CCComment *comment = (CCComment*)[_comments objectAtIndex:indexPath.row];
        CCUserViewController *userpage = [[CCUserViewController alloc] init];
        userpage.userID = comment.userID;
        userpage.vcTitle = comment.userName;
        userpage.hidesBottomBarWhenPushed = YES;
        [self callOtherVC:userpage];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([_timeline.commentCount intValue]>5 && indexPath.section == 0 &&indexPath.row ==0) {
        return 30;
    }else{
        id comment = [_comments objectAtIndex:indexPath.row];
        return [_commentTable cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[TimelineCommentCell class] contentViewWidth:CCamViewWidth];
    }
    
}

#pragma mark - UIActionsheet Delegate
- (void)callMoreActionSheet{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    if ([[[AuthorizeHelper sharedManager] getUserID]isEqualToString:_timeline.timelineUserID]) {
        [[ShareHelper sharedManager] callShareViewIsMyself:YES delegate:self timeline:_timeline indexPath:_indexPath];
    }else{
        [[ShareHelper sharedManager] callShareViewIsMyself:NO delegate:self timeline:_timeline indexPath:_indexPath];
    }
    
    return;
}
- (void)dissmisShareViewWith:(NSIndexPath *)indexPath{
    NSLog(@"%ld-%ld打开了ShareView",(long)indexPath.section,(long)indexPath.row);
}
- (void)shareViewBtnClickWithType:(NSString *)type andTitle:(NSString *)title isShareImage:(BOOL)isShare{
    NSLog(@"%@:%@",type,title);
    if ([type isEqualToString:@"Option"]) {

        if ([title isEqualToString:@"删除照片"]){
            [self deletePhoto];
        }else if ([title isEqualToString:@"下载照片"]){
            [self savePhoto];
        }
    }else if ([type isEqualToString:@"Share"]){
        
        if ([title isEqualToString:@"复制链接"]){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _timeline.shareURL;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parent.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"已复制链接到粘贴版";
            [hud hide:YES afterDelay:1.0];
            return;
        }
        
        NSArray* imageArray = @[_timeline.image_fullsize];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        if ([_timeline.shareURL isEqualToString:@""]) {
            _timeline.shareURL = @"http://www.c-cam.cc";
        }
        if ([_timeline.shareTitle isEqualToString:@""]) {
            _timeline.shareTitle = @"角色相机";
        }
        if ([_timeline.shareSubTitle isEqualToString:@""]) {
            _timeline.shareSubTitle = [NSString stringWithFormat:@"请为%@的照片点赞",_timeline.timelineUserName];
        }
        
        if (isShare) {
            [shareParams SSDKSetupShareParamsByText:_timeline.shareSubTitle
                                             images:imageArray
                                                url:[NSURL URLWithString:_timeline.shareURL]
                                              title:_timeline.shareTitle
                                               type:SSDKContentTypeImage];
            
        }else{
            [shareParams SSDKSetupShareParamsByText:_timeline.shareSubTitle
                                             images:imageArray
                                                url:[NSURL URLWithString:_timeline.shareURL]
                                              title:_timeline.shareTitle
                                               type:SSDKContentTypeAuto];
        }
        
        SSDKPlatformType shareType;
        
        if ([title isEqualToString:@"微信"]){
           shareType = SSDKPlatformSubTypeWechatSession;
        }else if ([title isEqualToString:@"朋友圈"]){
            shareType = SSDKPlatformSubTypeWechatTimeline;
        }else if ([title isEqualToString:@"新浪微博"]){
            shareType = SSDKPlatformTypeSinaWeibo;
            [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                if (!error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                            NSLog(@"分享成功！");
                            break;
                        case SSDKResponseStateCancel:
                            NSLog(@"取消分享！");
                            break;
                        case SSDKResponseStateFail:
                            NSLog(@"分享失败！");
                            break;
                        default:
                            break;
                    }
                }else{
                    NSLog(@"%@",error.description);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:error.description delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    [ShareSDK cancelAuthorize:shareType];
                }
            }];
            return;
        }else if ([title isEqualToString:@"QQ"]){
            shareType = SSDKPlatformSubTypeQQFriend;
        }else if ([title isEqualToString:@"QQ空间"]){
            shareType = SSDKPlatformSubTypeQZone;
        }else if ([title isEqualToString:@"Facebook"]){
           shareType = SSDKPlatformTypeFacebook;
        }
        [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (!error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                        NSLog(@"分享成功！");
                        break;
                    case SSDKResponseStateCancel:
                        NSLog(@"取消分享！");
                        break;
                    case SSDKResponseStateFail:
                        NSLog(@"分享失败！");
                        break;
                    default:
                        break;
                }
            }else{
                NSLog(@"%@",error.description);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:error.description delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
            }
        }];

    }
}

- (void)deletePhoto{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"workid" :photoID,@"token":token};
    [manager POST:CCamDeletePhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---->%@",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)reportPhoto{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSDictionary *parameters = @{@"workid" :photoID};
    [manager GET:CCamReportPhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"report %@:result %@",photoID,result);
        self.timeline.report = @"1";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.timeline.report = @"0";
    }];
}
- (void)cancelReportPhoto{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSDictionary *parameters = @{@"workid" :photoID};
    [manager GET:CCamCancelReportPhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"cancel Report %@:result %@",photoID,result);
        self.timeline.report = @"0";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.timeline.report = @"1";
    }];
}

- (void)savePhoto{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parent.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"下载图片中...";
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:_timeline.image_fullsize]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                hud.progress = (float)receivedSize/expectedSize;
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (error) {
                                   hud.mode = MBProgressHUDModeText;
                                   hud.labelText = @"照片下载失败";
                                   [hud hide:YES afterDelay:1.0];
                               }
                               
                               if (image && finished) {
                                   hud.mode = MBProgressHUDModeIndeterminate;
                                   hud.labelText = @"保存图片中...";
                                   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                               }
                           }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:_parent.navigationController.view];
    hud.mode = MBProgressHUDModeText;
    if (error) {
        hud.labelText = @"照片保存失败";
        [hud hide:YES afterDelay:1.0];
    }else{
        hud.labelText = @"照片已保存";
        [hud hide:YES afterDelay:1.0];
    }
}

- (void)likePhoto{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    if ([_timeline.liked isEqualToString:@"1"]) {
        return;
    }
    
    [_photoLike setTintColor:CCamRedColor];
    _timeline.liked = @"1";
    
    NSDictionary *parameters = @{@"token":[[AuthorizeHelper sharedManager] getUserToken],@"workid":_timeline.timelineID};
    NSLog(@"Request parmeters is %@",parameters);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CCamLikePhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *likeResult = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",likeResult);
        if ([likeResult isEqualToString:@"1"]) {
            NSLog(@"likephoto result is successed!");
            if (self.likeButtonBlock) {
                self.likeButtonBlock(self.indexPath);
            }

        }else if ([likeResult isEqualToString:@"-1"]){
            NSLog(@"likephoto result is failed!");
            [_photoLike setTintColor:CCamPhotoSegLightGray];
            _timeline.liked = @"0";
        }else if ([likeResult isEqualToString:@"-2"]){
            NSLog(@"likephoto result is has been liked!");
        }else{
            NSLog(@"likephoto result is unknown!");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_photoLike setBackgroundImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        _timeline.liked = @"0";
    }];
}
//#pragma mark
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"timeline"]) {
//        NSLog(@"FFFFFFFFFFFFFFFFFFF");
//    }
//}
@end
