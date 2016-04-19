//
//  TimelineCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#define profileSize 36.0
#define likeviewSize 40.0

#import "TimelineCell.h"
#import "TimelineCommentCell.h"

#import "Constants.h"
#import "CCamHelper.h"
#import "CCComment.h"
#import "CCLike.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <SDAutoLayout/UIView+SDAutoLayout.h>

#import "KLWebViewController.h"
#import "CCUserViewController.h"
#import "CCPhotoViewController.h"
#import "CommentViewController.h"
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>

#import "ShareViewController.h"

#import "WLCircleProgressView.h"

#import "TimelineCommentView.h"

@interface TimelineCell ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,ShareViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate>

@property (nonatomic,strong) UIView* cellBG;

@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIImageView *photoLomo;
@property (nonatomic,strong) UIImageView *photoMark;
@property (nonatomic,strong) UIImageView *privacySign;

@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *photoTime;
@property (nonatomic,strong) UILabel *shareSign;

@property (nonatomic,strong) UIButton *photoTitle;
@property (nonatomic,strong) UIButton *photoInput;
@property (nonatomic,strong) UIButton *photoLike;
@property (nonatomic,strong) UIButton *photoMore;
@property (nonatomic,strong) UIButton *likesButton;
@property (nonatomic,strong) UIButton *userButton;
@property (nonatomic,strong) UIButton *followButton;

@property (nonatomic,strong) UIAlertView *deleteAlert;

@property (nonatomic,strong) UIView *likeView;
@property (nonatomic,strong) UIView *likesDivider;
@property (nonatomic,strong) UIView *commentsDivider;

@property (nonatomic,strong) TimelineCommentView *commentView;
@property (nonatomic,strong) TimelineCommentView *photoDes;
@property (nonatomic,strong) WLCircleProgressView *photoProgress;

@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSMutableArray *likes;
@property (nonatomic,strong) NSMutableArray *timelineDes;
@end

@implementation TimelineCell

- (void)setUpTimelineCell{
    
    _comments = [NSMutableArray new];
    _timelineDes = [NSMutableArray new];
    
    _likes = [NSMutableArray new];
    
    _cellBG = [UIView new];
    [_cellBG setBackgroundColor:[UIColor whiteColor]];
    [_cellBG.layer setMasksToBounds:YES];
    [_cellBG.layer setCornerRadius:8.0];
    
    _avatar = [UIImageView new];
    [_avatar.layer setMasksToBounds:YES];
    [_avatar.layer setCornerRadius:profileSize/2];
    
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
    
    _followButton = [UIButton new];
    [_followButton setBackgroundColor:[UIColor whiteColor]];
    [_followButton setTitle:Babel(@"关注") forState:UIControlStateNormal];
    [_followButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_followButton setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_followButton.layer setBorderColor:CCamRedColor.CGColor];
    [_followButton.layer setBorderWidth:1.0];
    [_followButton setHidden:YES];
    
    _photo = [UIImageView new];
    
    _photoLomo = [UIImageView new];
    [_photoLomo setBackgroundColor:[UIColor clearColor]];
    [_photoLomo setContentMode:UIViewContentModeScaleToFill];
    [_photoLomo setImage:[UIImage imageNamed:@"timelineLomo"]];
    [_photoLomo setHidden:YES];
    
    _photoMark  = [UIImageView new];
    [_photoMark setBackgroundColor:[UIColor clearColor]];
    [_photoMark setContentMode:UIViewContentModeCenter];
    [_photoMark setImage:[UIImage imageNamed:@"timelineSpotlight"]];
    [_photoMark setHidden:YES];
    
    _photoProgress = [WLCircleProgressView viewWithFrame:CGRectMake(0, 0, 100, 100) circlesSize:CGRectMake(30, 5, 30, 5)];
    [_photoProgress setBackgroundColor:[UIColor clearColor]];
    _photoProgress.backCircle.shadowColor = [UIColor grayColor].CGColor;
    _photoProgress.backCircle.shadowRadius = 3;
    _photoProgress.backCircle.shadowOffset = CGSizeMake(0, 0);
    _photoProgress.progressValue = 0.0;
    _photoProgress.backCircle.shadowOpacity = 1;
    
    _photoTitle = [UIButton new];
    [_photoTitle setBackgroundColor:[UIColor whiteColor]];
    [_photoTitle setImage:[UIImage imageNamed:@"joinEventIcon"] forState:UIControlStateNormal];
    [_photoTitle setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_photoTitle setBackgroundColor:CCamRedColor];
    [_photoTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_photoTitle setTintColor:CCamRedColor];
    [_photoTitle.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    _likeView = [UIView new];
//    [_likeView setBackgroundColor:[UIColor orangeColor]];
    
    _likesButton = [UIButton new];
    [_likesButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_likesButton setImage:[[UIImage imageNamed:@"littleLikeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_likesButton setTintColor:CCamRedColor];
    [_likesButton setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_likesButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_likeView addSubview:_likesButton];
    
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
    
    _shareSign = [UILabel new];
    [_shareSign setBackgroundColor:[UIColor whiteColor]];
    [_shareSign setTextColor:CCamRedColor];
    [_shareSign setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_shareSign setTextAlignment:NSTextAlignmentCenter];
    [_shareSign setHidden:YES];
    
    _photoDes = [TimelineCommentView new];
    _commentView = [TimelineCommentView new];
    
    _likesDivider = [UIView new];
    [_likesDivider setBackgroundColor:CCamViewBackgroundColor];
    [_likesDivider setHidden:YES];
    
    _commentsDivider = [UIView new];
    [_commentsDivider setBackgroundColor:CCamViewBackgroundColor];
    [_commentsDivider setHidden:YES];
    
    NSArray *views = @[_cellBG,_avatar,_userName,_userButton,_photoTime,_privacySign,_followButton,_photo,_photoLomo,_photoMark,_photoInput,_photoLike,_photoMore,_shareSign,_likeView,_photoTitle,_photoDes,_commentView,_photoProgress,_likesDivider,_commentsDivider];
    [self.contentView sd_addSubviews:views];

    UIView *contentView = self.contentView;

    _avatar.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(contentView,15)
    .heightIs(profileSize)
    .widthIs(profileSize);
    
    _userName.sd_layout
    .leftSpaceToView(_avatar,10)
    .topEqualToView(_avatar)
    .widthIs(200)
    .heightIs(profileSize/2);
    
    _photoTime.sd_layout
    .leftEqualToView(_userName)
    .bottomEqualToView(_avatar)
    .widthIs(200)
    .heightIs(15);
    
    _userButton.sd_layout
    .leftEqualToView(_avatar)
    .rightEqualToView(_userName)
    .topEqualToView(_avatar)
    .heightIs(profileSize);
    
    _privacySign.sd_layout
    .rightSpaceToView(contentView,20)
    .centerYEqualToView(_avatar)
    .widthIs(10)
    .heightIs(15);
    
    _followButton.sd_layout
    .rightSpaceToView(contentView,20)
    .centerYEqualToView(_avatar);

    _photoTitle.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(_avatar,5);
    
    _photo.sd_layout
    .leftSpaceToView(contentView,5)
    .rightSpaceToView(contentView,5)
    .topSpaceToView(_photoTitle,5)
    .heightEqualToWidth();
    
    _photoProgress.sd_layout
    .centerXEqualToView(_photo)
    .centerYEqualToView(_photo);
    
    _photoLomo.sd_layout
    .leftEqualToView(_photo)
    .rightEqualToView(_photo)
    .bottomEqualToView(_photo)
    .heightIs(90);
    
    _photoMark.sd_layout
    .rightEqualToView(_photo)
    .bottomEqualToView(_photo)
    .widthIs(122).heightIs(72);
    
    _photoLike.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(_photo,5)
    .heightIs(44)
    .widthIs(44);
    
    _photoInput.sd_layout
    .leftSpaceToView(_photoLike,10)
    .topEqualToView(_photoLike)
    .heightIs(44)
    .widthIs(44);
    
    _photoMore.sd_layout
    .rightSpaceToView(contentView,15)
    .topEqualToView(_photoLike)
    .heightIs(44)
    .widthIs(44);
    
    _shareSign.sd_layout
    .rightSpaceToView(_photoMore,10)
    .centerYEqualToView(_photoMore);
    
    _likeView.sd_layout
    .leftSpaceToView(contentView,30)
    .rightSpaceToView(contentView,15)
    .topSpaceToView(_photoLike,0);
    
    _photoDes.sd_layout
    .leftSpaceToView(contentView,25)
    .rightSpaceToView(contentView,25)
    .topSpaceToView(_likeView, 0);
    
    _commentView.sd_layout
    .leftSpaceToView(contentView,25)
    .rightSpaceToView(contentView,25)
    .topSpaceToView(_photoDes, 0);
    
    _cellBG.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(5, 5, 5, 5));
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
    detail.webURL = _timeline.timelineContestURL;//[NSString stringWithFormat:@"http://www.c-cam.cc/index.php/First/Photo/index/contestid/%ld.html",(long)btn.tag];
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
- (void)openUserPageWithID:(NSString *)userID andName:(NSString *)userName{
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
    userpage.userID = [NSString stringWithFormat:@"%ld",(long)btn.tag];
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
    commentPage.title = Babel(@"照片评论");
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
- (void)reloadDes{
    [_timelineDes removeAllObjects];
    if (![_timeline.timelineDes isEqualToString:@""]) {
        CCComment* des = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:[[CoreDataHelper sharedManager] managedObjectContext]];
        des.userID = _timeline.timelineUserID;
        des.userName = _timeline.timelineUserName;
        des.comment = _timeline.timelineDes;
        [_timelineDes addObject:des];
    }
}
- (void)setTimeline:(CCTimeLine *)timeline{
    
    __weak __typeof(self) weakSelf = self;
    
    _timeline = timeline;
    
    _photoDes.frame = CGRectZero;
    _commentView.frame = CGRectZero;
    
    [self reloadDes];
    [_photoDes setupCommentItemsArray:_timelineDes];
    _photoDes.parent = self;
    
    [self reloadComments];
    [_commentView setupCommentItemsArray:_comments];
    _commentView.parent = self;
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_timeline.timelineUserImage] placeholderImage:nil];
    
    [_userName setText:_timeline.timelineUserName];
    
    [_photoProgress setHidden:NO];
    
    [_photo sd_setImageWithURL:[NSURL URLWithString:_timeline.image_fullsize] placeholderImage:nil options:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
        weakSelf.photoProgress.progressValue =progress ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.photoProgress setHidden:YES];
    }];
    
    NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:[_timeline.dateline integerValue]];
    [_photoTime setText:[self compareCurrentTime:timeDate]];
    
    [_userButton addTarget:self action:@selector(callUserPage:) forControlEvents:UIControlEventTouchUpInside];
    
    if(_indexPath.row==0&&![_timeline.timelineContestID isEqualToString:@"-1"]&&[_timeline.timelineUserID isEqualToString:[[AuthorizeHelper sharedManager] getUserID]]){
        [_shareSign setText:[NSString stringWithFormat:@"%@ ➜",Babel(@"马上分享")]];
        [_shareSign sizeToFit];
        [_shareSign setFrame:CGRectMake(0, 0, _shareSign.frame.size.width+18, _shareSign.frame.size.height+10)];
        [_shareSign.layer setCornerRadius:_shareSign.frame.size.height/2];
        [_shareSign.layer setMasksToBounds:YES];
        [_shareSign.layer setBorderColor:CCamRedColor.CGColor];
        [_shareSign.layer setBorderWidth:1.0];
        _shareSign.sd_layout
        .centerYEqualToView(_photoMore)
        .rightSpaceToView(_photoMore,0)
        .heightIs(_shareSign.frame.size.height)
        .widthIs(_shareSign.frame.size.width);
        [_shareSign setHidden:NO];
    }else{
        [_shareSign setHidden:YES];
    }
    
    if (![_timeline.timelineContestID isEqualToString:@"-1"]) {
        [_privacySign setHidden:YES];
    }
    
    if(_privacySign.hidden && [_timeline.followed isEqualToString:@"0"]&&![_timeline.timelineUserID isEqualToString:[[AuthorizeHelper sharedManager] getUserID]]){
        [_followButton setHidden:NO];
        [_followButton sizeToFit];
        _followButton.sd_layout
        .rightSpaceToView(self.contentView,20)
        .centerYEqualToView(_avatar)
        .widthIs(_followButton.frame.size.width+14)
        .heightIs(_followButton.frame.size.height+2);
        [_followButton.layer setCornerRadius:5.0];//_followButton.frame.size.height/2];
        [_followButton addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([_timeline.checked isEqualToString:@"3"]) {
        _photoLomo.hidden = NO;
        _photoMark.hidden = NO;
    }
    
    if (![_timeline.cNameCN isEqualToString:@""]&&![_timeline.cNameCN isEqualToString:@"<null>"]) {
        [_photoTitle setTitle:[NSString stringWithFormat:@"%@",_timeline.cNameCN] forState:UIControlStateNormal];
        [_photoTitle sizeToFit];
        [_photoTitle addTarget:self action:@selector(callContestWeb:) forControlEvents:UIControlEventTouchUpInside];
        _photoTitle.sd_layout.widthIs(_photoTitle.bounds.size.width+28);
        _photoTitle.sd_layout.heightIs(_photoTitle.bounds.size.height+8);
        
    }else{
        _photoTitle.hidden = YES;
        _photoTitle.sd_layout.heightIs(0).topSpaceToView(_avatar,0);
        _photo.sd_layout.topSpaceToView(_photoTitle,5);
    }
    
    if ([_timeline.liked isEqualToString:@"1"]) {
        [_photoLike setTintColor:CCamRedColor];
    }else{
        [_photoLike setTintColor:[UIColor lightGrayColor]];
    }
    
    UIView *bottomView;
    
    if (_timeline.likes && [_timeline.likes count]&& [_timeline.likes count]>0 && [_timeline.likeCount intValue] !=0) {
        [_likes removeAllObjects];
        for (CCLike * like in _timeline.likes) {
            [_likes addObject:like];
        }
        _likeView.sd_layout
        .heightIs(likeviewSize);
        bottomView = _likeView;
        
        _likesDivider.sd_layout
        .leftEqualToView(_likeView)
        .rightEqualToView(_likeView)
        .topEqualToView(_likeView)
        .heightIs(0.5);
        
        _likesDivider.hidden = NO;
    }else{
        _likeView.hidden = YES;
        _likeView.sd_layout.heightIs(0);
        bottomView = _photoLike;
        
        _likesDivider.hidden = YES;

    }
    
    if (_timelineDes.count || _comments.count) {
        _commentsDivider.sd_layout
        .leftEqualToView(_likeView)
        .rightEqualToView(_likeView)
        .bottomEqualToView(_likeView)
        .heightIs(0.5);
        
        _commentsDivider.hidden = NO;
    }else{
        _commentsDivider.hidden = YES;
    }
    
    if (!_timelineDes.count) {
        _photoDes.fixedWidth = @0;
        _photoDes.fixedHeight = @0;
        _commentView.sd_layout.topSpaceToView(_likeView, 0);
    } else {
        _photoDes.fixedHeight = nil;
        _photoDes.fixedWidth = nil;
        _photoDes.sd_layout.topSpaceToView(_likeView, 0);
        bottomView = _photoDes;
    }
    
    
    
    if (!_comments.count) {
        _commentView.fixedWidth = @0;
        _commentView.fixedHeight = @0;
        if (!_timelineDes.count) {
            _commentView.sd_layout.topSpaceToView(_likeView, 0);
        } else {
            _commentView.sd_layout.topSpaceToView(_photoDes, 0);
        }
    } else {
        _commentView.fixedHeight = nil;
        _commentView.fixedWidth = nil;
        if (!_timelineDes.count) {
            _commentView.sd_layout.topSpaceToView(_likeView, 0);
        } else {
            _commentView.sd_layout.topSpaceToView(_photoDes, 0);
        }
        bottomView = _commentView;
    }
    
    if (bottomView == self.commentView) {
        [self setupAutoHeightWithBottomView:bottomView bottomMargin:20];
 
    }else if (bottomView == self.photoDes){
        [self setupAutoHeightWithBottomView:bottomView bottomMargin:20];

    }else if (bottomView == self.likeView){
        [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];

    }else if (bottomView == self.photoLike){
        [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];

    }
    
    
    [self reloadLikes];
}
- (NSString *)retureBool:(BOOL)state{
    if (state) {
        return @"YES";
    }else{
        return @"NO";
    }
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

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath *btnMaskPath = [UIBezierPath bezierPathWithRoundedRect:_photoTitle.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(_photoTitle.bounds.size.height/2, _photoTitle.bounds.size.height/2)];
    CAShapeLayer *btnMaskLayer = [[CAShapeLayer alloc] init];
    btnMaskLayer.frame = _photoTitle.bounds;
    btnMaskLayer.path = btnMaskPath.CGPath;
    _photoTitle.layer.mask = btnMaskLayer;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reloadComments{
    if(!_comments){
    }
    [_comments removeAllObjects];
    for (CCComment * comment in _timeline.comments) {
        [_comments insertObject:comment atIndex:0];
    }
    if ([_timeline.commentCount intValue]>5) {
        CCComment* commentCount = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:[[CoreDataHelper sharedManager] managedObjectContext]];
        commentCount.userID = @"count";
        commentCount.userName = [NSString stringWithFormat:@"%@%@%@",Babel(@"全部"),_timeline.commentCount,Babel(@"条评论")];
        commentCount.comment = @"";
        [_comments insertObject:commentCount atIndex:0];
        
    }
}
- (void)reloadLikes{
    
    __weak __typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.likesButton setTitle:[NSString stringWithFormat:@" %@",weakSelf.timeline.likeCount] forState:UIControlStateNormal];
        [weakSelf.likesButton sizeToFit];
        [weakSelf.likesButton setFrame:CGRectMake(0, 0, weakSelf.likesButton.frame.size.width+2, likeviewSize)];
        
        
        for (int likeIndex = 0; likeIndex<_likes.count; likeIndex++) {
            
            CGFloat size = likeviewSize-14;
            
            UIImageView *likeImage = [UIImageView new];
            [likeImage setBackgroundColor:CCamViewBackgroundColor];
            [likeImage setFrame:CGRectMake(0, 0, size, size)];
            [likeImage.layer setMasksToBounds:YES];
            [likeImage.layer setCornerRadius:size/2];
            [weakSelf.likeView addSubview:likeImage];
            [likeImage setCenter:CGPointMake(weakSelf.likesButton.center.x+weakSelf.likesButton.frame.size.width/2+(likeIndex+1)*10+(likeIndex*2+1)*size/2, weakSelf.likesButton.center.y)];
            
            UIButton *likeBtn = [UIButton new];
            [likeBtn setBackgroundColor:[UIColor clearColor]];
            
            [likeBtn setFrame:CGRectMake(0, 0, size, size)];
            [weakSelf.likeView addSubview:likeBtn];
            [likeBtn setCenter:CGPointMake(weakSelf.likesButton.center.x+weakSelf.likesButton.frame.size.width/2+(likeIndex+1)*10+(likeIndex*2+1)*size/2, weakSelf.likesButton.center.y)];
            CCLike *like = (CCLike*)[weakSelf.likes objectAtIndex:likeIndex];
            
            [likeImage sd_setImageWithURL:[NSURL URLWithString:like.userImage]];
            
            [likeBtn setTag:likeIndex];
            [likeBtn addTarget:self action:@selector(callLikeUserPage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    });
    
}
//#pragma mark - UITableView Delegate and Datasource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    if ([_timeline.commentCount intValue]>5) {
//        if (section == 0) {
//            return 1;
//        }else{
//            return [_comments count];
//        }
//    }else{
//        return [_comments count];
//    }
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([_timeline.commentCount intValue]>5) {
//        return 2;
//    }else{
//        return 1;
//    }
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if ([_timeline.commentCount intValue]>5 && indexPath.section == 0 &&indexPath.row ==0) {
//        static NSString *identifier = @"ShowAllCommentCell";
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
//        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
//        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
//        [cell.textLabel setText:[NSString stringWithFormat:@"%@%@%@",Babel(@"全部"),_timeline.commentCount,Babel(@"条评论")]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        cell.textLabel.sd_layout
//        .leftSpaceToView(cell.contentView,10)
//        .rightSpaceToView(cell.contentView,10)
//        .centerYEqualToView(cell.contentView)
//        .heightIs(30);
//        
//        return cell;
//    }
//    
//    static NSString *identifier = @"TimelineCommentCell";
//    TimelineCommentCell *cell = [[TimelineCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    cell.comment = [_comments objectAtIndex:indexPath.row];
//    cell.parent = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (![[AuthorizeHelper sharedManager] checkToken]) {
//        [[AuthorizeHelper sharedManager] callAuthorizeView];
//        return;
//    }
//    
//    if ([_timeline.commentCount intValue]>5 && indexPath.section == 0 &&indexPath.row ==0) {
//        [self callCommentPage:nil];
//    }else{
//        CCComment *comment = (CCComment*)[_comments objectAtIndex:indexPath.row];
//        CCUserViewController *userpage = [[CCUserViewController alloc] init];
//        userpage.userID = comment.userID;
//        userpage.vcTitle = comment.userName;
//        userpage.hidesBottomBarWhenPushed = YES;
//        [self callOtherVC:userpage];
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    if ([_timeline.commentCount intValue]>5 && indexPath.section == 0 &&indexPath.row ==0) {
//        return 30;
//    }else{
//        id comment = [_comments objectAtIndex:indexPath.row];
//        return [_commentTable cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[TimelineCommentCell class] contentViewWidth:CCamViewWidth];
//    }
//    
//}

#pragma mark - UIActionsheet Delegate
- (void)callMoreActionSheet{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    if (!_shareSign.hidden) {
        [_shareSign setHidden:YES];
    }
    
    
    if ([[[AuthorizeHelper sharedManager] getUserID]isEqualToString:_timeline.timelineUserID]) {
        [[ShareHelper sharedManager] callShareViewIsMyself:YES delegate:self timeline:_timeline timelineCell:self indexPath:_indexPath onlyShare:NO shareImage:NO];
    }else{
        [[ShareHelper sharedManager] callShareViewIsMyself:NO delegate:self timeline:_timeline timelineCell:self indexPath:_indexPath onlyShare:NO shareImage:NO];
    }
    
    return;
}
- (void)dissmisShareViewWith:(NSIndexPath *)indexPath{
    NSLog(@"%ld-%ld打开了ShareView",(long)indexPath.section,(long)indexPath.row);
}
- (void)shareViewBtnClickWithType:(NSString *)type andTitle:(NSString *)title isShareImage:(BOOL)isShare{
    NSLog(@"%@:%@",type,title);
    if ([type isEqualToString:@"Option"]) {
        
        if ([title isEqualToString:Babel(@"删除照片")]){
            [self deletePhoto];
        }else if ([title isEqualToString:Babel(@"下载照片")]){
            [self savePhoto];
        }else if ([title isEqualToString:Babel(@"管理员工具")]){
            KLWebViewController *admin = [[KLWebViewController alloc] init];
            admin.webURL = [NSString stringWithFormat:@"http://www.c-cam.cc/index.php/First/Robot/Pdetail/workid/%@/token/%@.html",_timeline.timelineID,[[AuthorizeHelper sharedManager] getUserToken]];
            admin.vcTitle = Babel(@"管理员工具");
            admin.isAdmin = YES;
            admin.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
            backItem.title=@"";
            _parent.navigationItem.backBarButtonItem=backItem;
            [_parent.navigationController pushViewController:admin animated:YES];
        }
    }else if ([type isEqualToString:@"Share"]){
        
        if ([title isEqualToString:Babel(@"复制链接")]){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _timeline.shareURL;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parent.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = Babel(@"已复制链接到粘贴板");
            [hud hide:YES afterDelay:1.0];
            return;
        }
        
        if ([_timeline.shareURL isEqualToString:@""]) {
            _timeline.shareURL = @"http://www.c-cam.cc";
        }
        if ([_timeline.shareTitle isEqualToString:@""]) {
            _timeline.shareTitle = Babel(@"角色相机");
        }
        if ([_timeline.shareSubTitle isEqualToString:@""]) {
            //            _timeline.shareSubTitle = [NSString stringWithFormat:@"请为%@的照片点赞",_timeline.timelineUserName];
        }
        if (isShare) {
            //分享照片
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                _timeline.image_fullsize];
            if ([title isEqualToString:Babel(@"微信")]){
                type = UMShareToWechatSession;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.wechatSessionData.title =_timeline.shareTitle;
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"朋友圈")]){
                type = UMShareToWechatTimeline;
                
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _timeline.shareTitle;
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"新浪微博")]){
                type = UMShareToSina;
                
                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:_timeline.image_fullsize];
                
                [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@ %@",_timeline.shareSubTitle,_timeline.shareURL] shareImage:nil socialUIDelegate:self];
                
                [UMSocialSnsPlatformManager getSocialPlatformWithName:type].snsClickHandler(_parent,[UMSocialControllerService defaultControllerService],YES);
                
            }else if ([title isEqualToString:Babel(@"QQ")]){
                type = UMShareToQQ;
                [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
                [UMSocialData defaultData].extConfig.qqData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.qqData.title =_timeline.shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"QQ空间")]){
                type = UMShareToQzone;
                [UMSocialData defaultData].extConfig.qzoneData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.qzoneData.title =_timeline.shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"Facebook")]){
                
                type = UMShareToFacebook;
                
                
                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:_timeline.image_fullsize];
                
                [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@ %@",_timeline.shareSubTitle,_timeline.shareURL] shareImage:nil socialUIDelegate:self];
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToFacebook].snsClickHandler(_parent,[UMSocialControllerService defaultControllerService],YES);
            }

        }else{
            //分享链接
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                _timeline.image_fullsize];
            if ([title isEqualToString:Babel(@"微信")]){
                type = UMShareToWechatSession;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.wechatSessionData.title =_timeline.shareTitle;
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"朋友圈")]){
                type = UMShareToWechatTimeline;
                
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _timeline.shareTitle;
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"新浪微博")]){
                type = UMShareToSina;
                
                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:_timeline.image_fullsize];
                
                [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@ %@",_timeline.shareSubTitle,_timeline.shareURL] shareImage:nil socialUIDelegate:self];
                
                [UMSocialSnsPlatformManager getSocialPlatformWithName:type].snsClickHandler(_parent,[UMSocialControllerService defaultControllerService],YES);
                
            }else if ([title isEqualToString:Babel(@"QQ")]){
                type = UMShareToQQ;
                [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                [UMSocialData defaultData].extConfig.qqData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.qqData.title =_timeline.shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"QQ空间")]){
                type = UMShareToQzone;
                [UMSocialData defaultData].extConfig.qzoneData.url = _timeline.shareURL;
                [UMSocialData defaultData].extConfig.qzoneData.title =_timeline.shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:_timeline.shareSubTitle image:nil location:nil urlResource:urlResource presentedController:_parent completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }else if ([title isEqualToString:Babel(@"Facebook")]){
                
                type = UMShareToFacebook;
                
                
                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:_timeline.image_fullsize];
                
                [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@ %@",_timeline.shareSubTitle,_timeline.shareURL] shareImage:nil socialUIDelegate:self];
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToFacebook].snsClickHandler(_parent,[UMSocialControllerService defaultControllerService],YES);
            }
        }
        
    }
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _deleteAlert) {
        if (buttonIndex == 1) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString *photoID = _timeline.timelineID;
            NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
            NSDictionary *parameters = @{@"workid" :photoID,@"token":token};
            [manager POST:CCamDeletePhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"---->%@",result);
                if ([result isEqualToString:@"1"]) {
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = Babel(@"照片删除成功");
                    [hud hide:YES afterDelay:1.0];
                    
                    if (self.deleteBlock) {
                        self.deleteBlock(self.indexPath);
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = Babel(@"网络故障");
                [hud hide:YES afterDelay:1.0];
            }];
        }
    }
}
- (void)deletePhoto{
    
    _deleteAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片删除之后将无法恢复，请您三思，如果您不希望其他人看到这张照片，可以将照片设为仅自己可以见" delegate:self cancelButtonTitle:@"我再想想" otherButtonTitles:@"删除照片", nil];
    [_deleteAlert show];
    
    
}
- (void)reportPhoto{
    
    __weak __typeof(self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSDictionary *parameters = @{@"workid" :photoID};
    [manager GET:CCamReportPhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"report %@:result %@",photoID,result);
        weakSelf.timeline.report = @"1";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.timeline.report = @"0";
    }];
}
- (void)cancelReportPhoto{
    
    __weak __typeof(self) weakSelf = self;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSDictionary *parameters = @{@"workid" :photoID};
    [manager GET:CCamCancelReportPhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"cancel Report %@:result %@",photoID,result);
        weakSelf.timeline.report = @"0";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.timeline.report = @"1";
    }];
}

- (void)savePhoto{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parent.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText =Babel(@"下载照片中");
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:_timeline.image_fullsize]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                hud.progress = (float)receivedSize/expectedSize;
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (error) {
                                   hud.mode = MBProgressHUDModeText;
                                   hud.labelText = Babel(@"照片下载失败");
                                   [hud hide:YES afterDelay:1.0];
                               }
                               
                               if (image && finished) {
                                   hud.mode = MBProgressHUDModeIndeterminate;
                                   hud.labelText = Babel(@"保存照片至系统相册");
                                   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                               }
                           }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:_parent.navigationController.view];
    hud.mode = MBProgressHUDModeText;
    if (error) {
        hud.labelText = Babel(@"保存照片失败");
        [hud hide:YES afterDelay:1.0];
    }else{
        hud.labelText = Babel(@"保存照片成功");
        [hud hide:YES afterDelay:1.0];
    }
}
- (void)followUser{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    if (!_timeline) {
        return;
    }
    
    if ([_timeline.followed isEqualToString:@"1"]) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [_followButton setBackgroundColor:CCamYellowColor];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followButton setTitle:Babel(@"已关注") forState:UIControlStateNormal];
    [_followButton sizeToFit];
    _followButton.sd_layout
    .rightSpaceToView(self.contentView,20)
    .centerYEqualToView(_avatar)
    .widthIs(_followButton.frame.size.width+14)
    .heightIs(_followButton.frame.size.height+2);
    [_followButton.layer setBorderColor:CCamYellowColor.CGColor];

    _timeline.followed = @"1";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"bymemberid":_timeline.timelineUserID,@"token":userToken};
    [manager POST:CCamFollowURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *state =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",state);
        if (![state isEqualToString:@"1"]&&![state isEqualToString:@"-2"]) {
            [weakSelf.followButton setBackgroundColor:[UIColor whiteColor]];
            [weakSelf.followButton setTitleColor:CCamRedColor forState:UIControlStateNormal];
            [weakSelf.followButton setTitle:Babel(@"关注") forState:UIControlStateNormal];
            [weakSelf.followButton sizeToFit];
            weakSelf.followButton.sd_layout
            .rightSpaceToView(self.contentView,20)
            .centerYEqualToView(_avatar)
            .widthIs(_followButton.frame.size.width+14)
            .heightIs(_followButton.frame.size.height+2);
            [weakSelf.followButton.layer setBorderColor:CCamRedColor.CGColor];
            
            weakSelf.timeline.followed = @"0";

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
- (void)likePhoto{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    if (!_timeline) {
        return;
    }
    
    if ([_timeline.liked isEqualToString:@"1"]) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
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
            [weakSelf.photoLike setTintColor:CCamPhotoSegLightGray];
            weakSelf.timeline.liked = @"0";
            [[AuthorizeHelper sharedManager] loginStateError];
        }else if ([likeResult isEqualToString:@"-2"]){
            NSLog(@"likephoto result is has been liked!");
        }else{
            NSLog(@"likephoto result is unknown!");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.photoLike setBackgroundImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        weakSelf.timeline.liked = @"0";
    }];
}
//#pragma mark
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"timeline"]) {
//        NSLog(@"FFFFFFFFFFFFFFFFFFF");
//    }
//}
@end
