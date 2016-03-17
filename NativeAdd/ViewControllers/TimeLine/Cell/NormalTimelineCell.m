//
//  NormalTimelineCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/10.
//
//

#define userImageSize 36.0
#define marginUserImage 15.0

#import "NormalTimelineCell.h"

#import "Constants.h"
#import "CCamHelper.h"
#import "CCComment.h"
#import "CCLike.h"

#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "NormalTimelineCommentView.h"

@interface NormalTimelineCell ()

@property (nonatomic,strong) UIView *bg;

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,strong) UIButton *userName;
@property (nonatomic,strong) UILabel *photoTime;
@property (nonatomic,strong) UIImageView *photoPrivacy;

@property (nonatomic,strong) UIButton *contestName;
@property (nonatomic,strong) UILabel *contestNote;

@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIImageView *photoLomo;
@property (nonatomic,strong) UIImageView *photoMark;

@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *moreBtn;

@property (nonatomic,strong) UIView *likeBorder;
@property (nonatomic,strong) UIButton *likeMark;
@property (nonatomic,strong) UIView *likeView;

@property (nonatomic,strong) UIView *commentBorder;
@property (nonatomic,strong) UILabel *photoNote;
@property (nonatomic,strong) UIButton *commentCount;
@property (nonatomic,strong) NormalTimelineCommentView *commentView;

@property (nonatomic,strong) NSMutableArray *views;

@property (nonatomic,strong) NSMutableArray *likes;
@property (nonatomic,strong) NSMutableArray *comments;

@end


@implementation NormalTimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setUpCell{
    
    _views = [NSMutableArray new];
    _likes = [NSMutableArray new];
    _comments = [NSMutableArray new];
    
    _bg = [UIView new];
    [_bg setBackgroundColor:[UIColor whiteColor]];
    [_bg.layer setMasksToBounds:YES];
    [_bg.layer setCornerRadius:8.0];
    [_views addObject:_bg];
    
    _userImage = [UIImageView new];
    [_userImage setBackgroundColor:CCamViewBackgroundColor];
    [_userImage.layer setMasksToBounds:YES];
    [_userImage.layer setCornerRadius:userImageSize/2];
    [_views addObject:_userImage];
    
    _userName = [UIButton new];
    [_userName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_userName setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_userName setTitleColor:CCamViewBackgroundColor forState:UIControlStateHighlighted];
    [_userName.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_views addObject:_userName];
    
    _photoTime = [UILabel new];
    [_photoTime setTextColor:[UIColor lightGrayColor]];
    [_photoTime setFont:[UIFont systemFontOfSize:10.0]];
    [_photoTime setTextAlignment:NSTextAlignmentLeft];
    [_views addObject:_photoTime];
    
    _photoPrivacy = [UIImageView new];
    [_photoPrivacy setBackgroundColor:[UIColor whiteColor]];
    [_photoPrivacy setImage:[[UIImage imageNamed:@"privacyIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_photoPrivacy setTintColor:CCamRedColor];
    [_views addObject:_photoPrivacy];
    
    _photo = [UIImageView new];
    [_views addObject:_photo];
    
    _photoLomo = [UIImageView new];
    [_photoLomo setBackgroundColor:[UIColor clearColor]];
    [_photoLomo setContentMode:UIViewContentModeScaleToFill];
    [_photoLomo setImage:[UIImage imageNamed:@"timelineLomo"]];
    [_views addObject:_photoLomo];
    
    _photoMark  = [UIImageView new];
    [_photoMark setBackgroundColor:[UIColor clearColor]];
    [_photoMark setContentMode:UIViewContentModeCenter];
    [_photoMark setImage:[UIImage imageNamed:@"timelineSpotlight"]];
    [_views addObject:_photoMark];
    
    _contestName = [UIButton new];
    [_contestName setBackgroundColor:[UIColor whiteColor]];
    [_contestName setImage:[UIImage imageNamed:@"joinEventIcon"] forState:UIControlStateNormal];
    [_contestName setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_contestName setBackgroundImage:[[[UIImage imageNamed:@"eventTitleBG"] stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_contestName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_contestName setTintColor:CCamRedColor];
    [_contestName.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_views addObject:_contestName];
    
    _contestNote = [UILabel new];
    [_contestNote setBackgroundColor:[UIColor whiteColor]];
    [_contestNote setFont:[UIFont systemFontOfSize:10.0]];
    [_contestNote setNumberOfLines:0];
    [_contestNote setTextColor:CCamGrayTextColor];
    [_contestNote setTextAlignment:NSTextAlignmentLeft];
    [_views addObject:_contestNote];
    
    _commentBtn = [UIButton new];
    [_commentBtn addTarget:self action:@selector(callCommentPage:) forControlEvents:UIControlEventTouchUpInside];
    [_commentBtn setImage:[[UIImage imageNamed:@"commentIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_commentBtn setTintColor:[UIColor lightGrayColor]];
    [_views addObject:_commentBtn];
    
    _likeBtn = [UIButton new];
    [_likeBtn setImage:[[UIImage imageNamed:@"likeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_likeBtn setTintColor:[UIColor lightGrayColor]];
    [_likeBtn addTarget:self action:@selector(likePhoto) forControlEvents:UIControlEventTouchUpInside];
    [_views addObject:_likeBtn];
    
    _moreBtn = [UIButton new];
    [_moreBtn setImage:[[UIImage imageNamed:@"moreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_moreBtn setTintColor:[UIColor lightGrayColor]];
    [_moreBtn addTarget:self action:@selector(callMoreActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [_views addObject:_moreBtn];
    
    _likeBorder = [UIView new];
    [_likeBorder setBackgroundColor:CCamViewBackgroundColor];
    [_views addObject:_likeBorder];
    
    _likeView = [UIView new];
    [_views addObject:_likeView];
    
    _likeMark = [UIButton new];
    [_likeMark setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_likeMark setImage:[[UIImage imageNamed:@"littleLikeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_likeMark setTintColor:CCamRedColor];
    [_likeMark setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_likeMark.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [_likeView addSubview:_likeMark];
    [_views addObject:_likeMark];
    
    _commentBorder = [UIView new];
    [_commentBorder setBackgroundColor:CCamViewBackgroundColor];
    [_views addObject:_commentBorder];
    
    _photoNote = [UILabel new];
    [_photoNote setBackgroundColor:[UIColor whiteColor]];
    [_photoNote setFont:[UIFont systemFontOfSize:12.0]];
    [_photoNote setNumberOfLines:0];
    [_photoNote setTextColor:CCamGrayTextColor];
    [_photoNote setTextAlignment:NSTextAlignmentLeft];
    [_views addObject:_photoNote];
    
    _commentCount = [UIButton new];
    [_commentCount setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_commentCount setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_commentCount setTitleColor:CCamViewBackgroundColor forState:UIControlStateHighlighted];
    [_commentCount.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_views addObject:_commentCount];
    
    _commentView = [NormalTimelineCommentView new];
    [_views addObject:_commentView];
    
    [self sd_addSubviews:_views];
    
    UIView *contentView = self.contentView;
    
    _userImage.sd_layout
    .leftSpaceToView (contentView,marginUserImage)
    .topSpaceToView (contentView,marginUserImage)
    .heightIs(userImageSize)
    .widthIs(userImageSize);
    
    _userName.sd_layout
    .leftSpaceToView(_userImage,10)
    .topEqualToView(_userImage);
    
    _photoTime.sd_layout
    .leftEqualToView(_userName)
    .bottomEqualToView(_userImage)
    .heightIs(15)
    .autoHeightRatio(0);
    
    _photoPrivacy.sd_layout
    .rightSpaceToView(contentView,20)
    .centerYEqualToView(_userImage)
    .widthIs(10)
    .heightIs(15);
    
    _contestName.sd_layout
    .leftEqualToView(_userImage)
    .topSpaceToView(_userImage,10)
    .heightIs(20);
    
    _photo.sd_layout
    .leftSpaceToView(contentView,5)
    .rightSpaceToView(contentView,5)
    .topSpaceToView(_contestName,10)
    .heightEqualToWidth();
    
    _photoLomo.sd_layout
    .leftEqualToView(_photo)
    .rightEqualToView(_photo)
    .bottomEqualToView(_photo)
    .heightIs(90);
    
    _photoMark.sd_layout
    .rightEqualToView(_photo)
    .bottomEqualToView(_photo)
    .widthIs(122)
    .heightIs(72);
    
    _likeBtn.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(_photo,5)
    .heightIs(44)
    .widthIs(44);
    
    _commentBtn.sd_layout
    .leftSpaceToView(_likeBtn,10)
    .centerYEqualToView(_likeBtn)
    .heightIs(44)
    .widthIs(44);
    
    _moreBtn.sd_layout
    .rightSpaceToView(contentView,10)
    .centerYEqualToView(_likeBtn)
    .heightIs(44)
    .widthIs(44);
    
    _likeBorder.sd_layout
    .leftEqualToView(_userImage)
    .rightSpaceToView(contentView,15)
    .topSpaceToView(_likeBtn,0)
    .heightIs(0.5);
    
    _likeView.sd_layout
    .leftEqualToView(_likeBorder)
    .rightEqualToView(_likeBorder)
    .topSpaceToView(_likeBorder,0);

    _commentBorder.sd_layout
    .leftEqualToView(_userImage)
    .rightSpaceToView(contentView,15)
    .topSpaceToView(_likeView,0)
    .heightIs(0.5);
    
    _photoNote.sd_layout
    .leftEqualToView(_commentBorder)
    .rightEqualToView(_commentBorder)
    .topSpaceToView(_commentBorder,10)
    .autoHeightRatio(0);
    
    _commentCount.sd_layout
    .leftEqualToView(_commentBorder)
    .topSpaceToView(_photoNote,10);
    
    _commentView.sd_layout
    .leftEqualToView(_commentBorder)
    .rightEqualToView(_commentBorder)
    .topSpaceToView(_commentCount,10);
}

- (void)setTimeline:(CCTimeLine *)timeline{
    _timeline = timeline;
    
    if (_timeline == nil) {
        //显示没有图像
    }
    
    [_comments removeAllObjects];
//    for (CCComment * comment in _timeline.comments) {
//        [_comments insertObject:comment atIndex:0];
//    }
    _commentView.frame = CGRectZero;
    
//    if (_comments.count) {
//        [_commentView setUpWithComments:_comments];
//    }
    
    [_userImage sd_setImageWithURL:[NSURL URLWithString:_timeline.timelineUserImage] placeholderImage:nil];
    
    [_userName setTitle:_timeline.timelineUserName forState:UIControlStateNormal];
    [_userName sizeToFit];
    _userName.sd_layout.widthIs(_userName.frame.size.width+2);
    
    NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:[_timeline.dateline integerValue]];
    [_photoTime setText:[self compareCurrentTime:timeDate]];
    [_photoTime sizeToFit];
    
    if (![_timeline.timelineContestID isEqualToString:@"-1"]) {
        [_photoPrivacy setHidden:YES];
    }
    
    [_photo sd_setImageWithURL:[NSURL URLWithString:_timeline.image_fullsize] placeholderImage:nil];

    if (![_timeline.cNameCN isEqualToString:@""]&&![_timeline.cNameCN isEqualToString:@"<null>"]) {
        [_contestName setTitle:[NSString stringWithFormat:@"%@",_timeline.cNameCN] forState:UIControlStateNormal];
        [_contestName sizeToFit];
        [_contestName setTag:[_timeline.timelineContestID intValue]];
        [_contestName addTarget:self action:@selector(callContestWeb:) forControlEvents:UIControlEventTouchUpInside];
        _contestName.sd_layout.widthIs(_contestName.bounds.size.width+24);
        _contestName.sd_layout.heightIs(_contestName.bounds.size.height+4);
    }else{
        [_contestName setHidden:YES];
        _photo.sd_layout
        .topSpaceToView(_userImage,10);
    }
    
    if ([_timeline.liked isEqualToString:@"1"]) {
        [_likeBtn setTintColor:CCamRedColor];
    }else{
        [_likeBtn setTintColor:[UIColor lightGrayColor]];
    }
    
    [_likes removeAllObjects];
    for (CCLike * like in _timeline.likes) {
        [_likes addObject:like];
    }
    
    if ([_likes count] == 0||[_timeline.likeCount intValue]==0) {
        [_likeBorder setHidden:YES];
        [_likeView setHidden:YES];
        _commentBorder.sd_layout
        .topSpaceToView(_likeBtn,0);
    }else{
        _likeView.sd_layout.heightIs(60);
        [self reloadLikes];
    }
    
    if (![_timeline.timelineDes isEqualToString:@""]) {
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",_timeline.timelineUserName,_timeline.timelineDes]];
        [str addAttribute:NSForegroundColorAttributeName value:CCamRedColor range:NSMakeRange(0,_timeline.timelineUserName.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(0,_timeline.timelineUserName.length)];
        [_photoNote setAttributedText:str];
        _photoNote.sd_layout.maxHeightIs(MAXFLOAT).minHeightIs(15);
    }else{
        _photoNote.hidden = YES;
        _commentCount.sd_layout
        .topSpaceToView(_commentBorder,10);
    }
    
    if (!_comments.count || _comments.count ==0) {
        _commentCount.fixedWith = @0;
        _commentCount.fixedHeight = @0;
        _commentView.fixedWith = @0;
        _commentView.fixedHeight = @0;
        _commentView.sd_layout.topSpaceToView(_commentBorder,0);
    }else{
        if ([_timeline.commentCount intValue]>5) {
            _commentCount.fixedWith = nil;
            _commentCount.fixedHeight = nil;
            _commentView.fixedWith = nil;
            _commentView.fixedHeight = nil;
            [_commentCount setTitle:_timeline.commentCount forState:UIControlStateNormal];
            [_commentCount sizeToFit];
            _commentCount.sd_layout.widthIs(_commentCount.frame.size.width+2);
            _commentView.sd_layout.topSpaceToView(_commentCount,10);
        }else{
            _commentCount.fixedWith = nil;
            _commentCount.fixedHeight = nil;
            _commentView.sd_layout.topSpaceToView(_commentBorder,10);
        }
    }
    
    UIView *bottomView;
    
    if (_comments.count == 0 && _likes.count ==0 && [_timeline.timelineDes isEqualToString:@""]) {
        bottomView = _likeBtn;
    }else if (_comments.count == 0 && _likes.count !=0 && [_timeline.timelineDes isEqualToString:@""]){
        bottomView = _likeView;
    }else if (_comments.count == 0 && _likes.count ==0 && ![_timeline.timelineDes isEqualToString:@""]){
        bottomView = _photoNote;
    }else if (_comments.count != 0 && _likes.count ==0 && [_timeline.timelineDes isEqualToString:@""]){
        bottomView = _commentView;
    }else if (_comments.count != 0 && _likes.count !=0 && [_timeline.timelineDes isEqualToString:@""]){
        bottomView = _commentView;
    }else if (_comments.count != 0 && _likes.count ==0 && ![_timeline.timelineDes isEqualToString:@""]){
        bottomView = _commentView;
    }else if (_comments.count == 0 && _likes.count !=0 && ![_timeline.timelineDes isEqualToString:@""]){
        bottomView = _photoNote;
    }else if (_comments.count != 0 && _likes.count !=0 && ![_timeline.timelineDes isEqualToString:@""]){
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}

- (void)reloadLikes{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_likeMark setTitle:[NSString stringWithFormat:@" %@ 个人赞过",_timeline.likeCount] forState:UIControlStateNormal];
        [_likeMark sizeToFit];
        [_likeMark setFrame:CGRectMake(0, 0, _likeMark.frame.size.width+2, 60)];
        
        
        for (int likeIndex = 0; likeIndex<_likes.count; likeIndex++) {
            
            UIImageView *likeImage = [UIImageView new];
            [likeImage setBackgroundColor:CCamViewBackgroundColor];
            [likeImage setFrame:CGRectMake(0, 0, 36, 36)];
            [likeImage.layer setMasksToBounds:YES];
            [likeImage.layer setCornerRadius:18.0];
            [_likeView addSubview:likeImage];
            [likeImage setCenter:CGPointMake(_likeMark.center.x+_likeMark.frame.size.width/2+(likeIndex+1)*10+(likeIndex*2+1)*18, _likeMark.center.y)];
            
            UIButton *likeBtn = [UIButton new];
            [likeBtn setBackgroundColor:[UIColor clearColor]];
            
            [likeBtn setFrame:CGRectMake(0, 0, 36, 36)];
            [_likeView addSubview:likeBtn];
            [likeBtn setCenter:CGPointMake(_likeMark.center.x+_likeMark.frame.size.width/2+(likeIndex+1)*10+(likeIndex*2+1)*18, _likeMark.center.y)];
            CCLike *like = (CCLike*)[_likes objectAtIndex:likeIndex];
            
            [likeImage sd_setImageWithURL:[NSURL URLWithString:like.userImage]];
            
            [likeBtn setTag:likeIndex];
            [likeBtn addTarget:self action:@selector(callLikeUserPage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    });
    
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
    }else{
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    
    return  result;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
