//
//  CCUserViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import "CCUserViewController.h"
#import <CoreText/CoreText.h>
#import "TimelineCell.h"
#import "TimelineCollectionCell.h"
#import "CCTimeLine.h"
#import "CCLike.h"
#import "CCComment.h"
#import "KLWebViewController.h"
#import "CCFollowerViewController.h"
#import "CCFollowViewController.h"
#import "PersonInfoViewController.h"
#import "SettingViewController.h"
#import "CCPhotoViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "CCamRefreshHeader.h"
#import "CCamRefreshFooter.h"

@interface CCUserViewController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UIScrollViewDelegate>

@property (nonatomic,strong) UIButton *topBtn;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong)UIScrollView *userBG;
@property (nonatomic,strong)UIView * userTopView;
@property (nonatomic,strong)UIImageView *userProfile;
@property (nonatomic,strong)UIButton *photoCount;
@property (nonatomic,strong)UIButton *followerBtn;
@property (nonatomic,strong)UIButton *followBtn;
@property (nonatomic,strong)UILabel *photoCountLab;
@property (nonatomic,strong)UILabel *followerLab;
@property (nonatomic,strong)UILabel *followLab;

@property (nonatomic,strong)UIButton *pageFuncBtn;
@property (nonatomic,strong)UIView *modeView;
@property (nonatomic,strong)UIButton *timelineBtn;
@property (nonatomic,strong)UIButton *flowBtn;
@property (nonatomic,strong) UITableView *timeline;
@property (nonatomic,strong) UICollectionView *photoCollection;
@property (nonatomic,strong) NSMutableArray *photos;

@property (nonatomic,strong) UIAlertView *deleteFollowAlert;
@property (nonatomic,assign) NSInteger ifFollow;
@end


@implementation CCUserViewController

- (void)reloadInfo{
    [_userBG.mj_header beginRefreshing];
}
- (void)returnTopPosition{
    [self userPageGoTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _timeline){// || scrollView == _photoCollection) {
        
//        NSLog(@"%f",scrollView.contentOffset.y);
        
        if (scrollView.contentOffset.y>-131 && scrollView.contentOffset.y<=0) {
            [_userTopView setCenter:CGPointMake(CCamViewWidth/2, 46-scrollView.contentOffset.y-131)];
            [_modeView setCenter:CGPointMake(CCamViewWidth/2, 93+19-scrollView.contentOffset.y-131)];
            [_timeline setContentInset:UIEdgeInsetsMake(131-scrollView.contentOffset.y, 0, _timeline.contentInset.bottom, 0)];
        }else if(scrollView.contentOffset.y <= -131){
            [_userTopView setCenter:CGPointMake(CCamViewWidth/2, 46)];
            [_modeView setCenter:CGPointMake(CCamViewWidth/2, 93+19)];
            [_timeline setContentInset:UIEdgeInsetsMake(131, 0, _timeline.contentInset.bottom, 0)];
        }else if(scrollView.contentOffset.y>0){
            [_userTopView setCenter:CGPointMake(CCamViewWidth/2, -39-46)];
            [_modeView setCenter:CGPointMake(CCamViewWidth/2, -19)];
            [_timeline setContentInset:UIEdgeInsetsMake(131, 0, _timeline.contentInset.bottom, 0)];
        }
    }else if (scrollView == _photoCollection){
        
        if (scrollView.contentOffset.y>-131 && scrollView.contentOffset.y<=0) {
            [_userTopView setCenter:CGPointMake(CCamViewWidth/2, 46-scrollView.contentOffset.y-131)];
            [_modeView setCenter:CGPointMake(CCamViewWidth/2, 93+19-scrollView.contentOffset.y-131)];
            [_photoCollection setContentInset:UIEdgeInsetsMake(131-scrollView.contentOffset.y, 0, _timeline.contentInset.bottom, 0)];
        }else if(scrollView.contentOffset.y <= -131){
            [_userTopView setCenter:CGPointMake(CCamViewWidth/2, 46)];
            [_modeView setCenter:CGPointMake(CCamViewWidth/2, 93+19)];
            [_photoCollection setContentInset:UIEdgeInsetsMake(131, 0, _timeline.contentInset.bottom, 0)];
        }else if(scrollView.contentOffset.y>0){
            [_userTopView setCenter:CGPointMake(CCamViewWidth/2, -39-46)];
            [_modeView setCenter:CGPointMake(CCamViewWidth/2, -19)];
            [_photoCollection setContentInset:UIEdgeInsetsMake(131, 0, _timeline.contentInset.bottom, 0)];
        }
    }
}
- (void)switchShowTimelineOrFlowCollection{
    if (_timeline.hidden) {
        _photoCollection.hidden = YES;
        _timeline.hidden = NO;
        [_timelineBtn setTintColor:CCamRedColor];
        [_flowBtn setTintColor:CCamViewBackgroundColor];
    }else if (_photoCollection.hidden){
        _timeline.hidden = YES;
        _photoCollection.hidden = NO;
        [_flowBtn setTintColor:CCamRedColor];
        [_timelineBtn setTintColor:CCamViewBackgroundColor];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_reloadIndexs && [_reloadIndexs count]) {
        NSLog(@"*****%lu",(unsigned long)_reloadIndexs.count);
        [_timeline reloadRowsAtIndexPaths:_reloadIndexs withRowAnimation:UITableViewRowAnimationAutomatic];
        [_reloadIndexs removeAllObjects];
    }
    
    if (_needUpdate) {
        
        [_userProfile setImage:nil];
        [_photoCount setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"提交照片")] forState:UIControlStateNormal];
        [_followerBtn setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"关注者")] forState:UIControlStateNormal];
        [_followBtn setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"关注")] forState:UIControlStateNormal];
        
        [_photos removeAllObjects];
        [_photoCollection reloadData];
        [_timeline reloadData];
        
        [_userBG.mj_header beginRefreshing];
        _needUpdate = NO;
    }
}
- (void)initUserUI{
    
    _needUpdate = NO;
    
    _titleLab = [UILabel new];
    [_titleLab setBackgroundColor:CCamRedColor];
    [_titleLab setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0]];
    [_titleLab setTextColor:[UIColor whiteColor]];
    [_titleLab setTextAlignment:NSTextAlignmentCenter];
    [_titleLab setFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.frame.size.height)];
    [self.navigationItem setTitleView:_titleLab];
    
    [_userBG setBackgroundColor:CCamRedColor];
    
    _userTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, 92)];
    [_userTopView setBackgroundColor:[UIColor whiteColor]];
    [_userBG addSubview:_userTopView];
    
    UIView *redBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, 46)];
    [_userTopView addSubview:redBg];
    [redBg setBackgroundColor:CCamRedColor];
    
    _userProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _userTopView.bounds.size.height-20, _userTopView.bounds.size.height-20)];
    [_userProfile.layer setMasksToBounds:YES];
    [_userProfile setBackgroundColor:CCamViewBackgroundColor];
    [_userProfile.layer setCornerRadius:_userProfile.bounds.size.height/2];
    [_userTopView addSubview:_userProfile];
    
    _pageFuncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pageFuncBtn setFrame:CGRectMake(25+_userProfile.bounds.size.width, 58, _userTopView.bounds.size.width-25-_userProfile.bounds.size.width-10, 24)];
    [_pageFuncBtn setTitle:@"" forState:UIControlStateNormal];
    [_pageFuncBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [_pageFuncBtn setBackgroundColor:CCamViewBackgroundColor];
    [_pageFuncBtn setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_pageFuncBtn.layer setMasksToBounds:YES];
    [_pageFuncBtn.layer setCornerRadius:5.0];
    [_pageFuncBtn addTarget:self action:@selector(pageFunction) forControlEvents:UIControlEventTouchUpInside];
    [_userTopView addSubview:_pageFuncBtn];
    
    _photoCount = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoCount setFrame:CGRectMake(_pageFuncBtn.frame.origin.x, 0, _pageFuncBtn.frame.size.width/3, 49)];
    [_photoCount.titleLabel setNumberOfLines:0];
    [_photoCount.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_photoCount setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_photoCount setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_photoCount setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"提交照片")] forState:UIControlStateNormal];
    [_photoCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userTopView addSubview:_photoCount];
    
    //    _photoCountLab = [UILabel new];
    //    [_photoCountLab setNumberOfLines:0];
    //    [_photoCountLab setTextAlignment:NSTextAlignmentCenter];
    //    [_photoCountLab setFrame:_photoCount.frame];
    //    [_photoCountLab setAttributedText:[self returnStrWithTitle:@"0" andSubtitle:@"提交照片"]];
    //    [_photoCountLab setUserInteractionEnabled:NO];
    //    [_userTopView addSubview:_photoCountLab];
    
    _followerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followerBtn setFrame:CGRectMake(_pageFuncBtn.frame.origin.x+_pageFuncBtn.frame.size.width/3, 0, _pageFuncBtn.frame.size.width/3, 49)];
    [_followerBtn.titleLabel setNumberOfLines:0];
    [_followerBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_followerBtn setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"关注者")] forState:UIControlStateNormal];
    [_followerBtn addTarget:self action:@selector(callFollowerPage) forControlEvents:UIControlEventTouchUpInside];
    [_followerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userTopView addSubview:_followerBtn];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followBtn setFrame:CGRectMake(_pageFuncBtn.frame.origin.x+_pageFuncBtn.frame.size.width*2/3, 0, _pageFuncBtn.frame.size.width/3, 49)];
    [_followBtn setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"关注者")] forState:UIControlStateNormal];
    [_followBtn.titleLabel setNumberOfLines:0];
    [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_followBtn addTarget:self action:@selector(callFollowPage) forControlEvents:UIControlEventTouchUpInside];
    [_userTopView addSubview:_followBtn];
    
    _modeView = [[UIView alloc] initWithFrame:CGRectMake(0, _userTopView.frame.origin.y+_userTopView.frame.size.height+1.0, CCamViewWidth, 38)];
    [_modeView setBackgroundColor:[UIColor whiteColor]];
    [_userBG addSubview:_modeView];
    
    _timelineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timelineBtn setImage:[[UIImage imageNamed:@"userList"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_timelineBtn setTintColor:CCamViewBackgroundColor];
    [_timelineBtn setFrame:CGRectMake(0, 0, 38, 38)];
    [_timelineBtn setCenter:CGPointMake(_userTopView.bounds.size.height/2+48, 19)];
    [_modeView addSubview:_timelineBtn];
    [_timelineBtn addTarget:self action:@selector(switchShowTimelineOrFlowCollection) forControlEvents:UIControlEventTouchUpInside];
    
    
    _flowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flowBtn setImage:[[UIImage imageNamed:@"userFlow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_flowBtn setTintColor:CCamRedColor];
    [_flowBtn setFrame:CGRectMake(0, 0, 38, 38)];
    [_flowBtn setCenter:CGPointMake(_userTopView.bounds.size.height/2, 19)];
    [_modeView addSubview:_flowBtn];
    [_flowBtn addTarget:self action:@selector(switchShowTimelineOrFlowCollection) forControlEvents:UIControlEventTouchUpInside];
}
- (void)initPhotoUI{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _photoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight) collectionViewLayout:flowLayout];
//    _photoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,_userTopView.frame.size.height+_modeView.frame.size.height+1 , CCamViewWidth, _userBG.frame.size.height-(_userTopView.frame.size.height+_modeView.frame.size.height+1)) collectionViewLayout:flowLayout];
    
    [_photoCollection registerClass:[TimelineCollectionCell class] forCellWithReuseIdentifier:@"timelineCollectionCell"];
    [_photoCollection setDelegate:self];
    [_photoCollection setDataSource:self];
    [_photoCollection setBackgroundColor:CCamViewBackgroundColor];
    
    _timeline  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight) style:UITableViewStylePlain];
    //    _timeline = [[UITableView alloc] initWithFrame:CGRectMake(0,_userTopView.frame.size.height+_modeView.frame.size.height+1 , CCamViewWidth, _userBG.frame.size.height-(_userTopView.frame.size.height+_modeView.frame.size.height+1)) style:UITableViewStylePlain];
    [_timeline setDelegate:self];
    [_timeline setDataSource:self];
    [_timeline setBackgroundColor:CCamViewBackgroundColor];
    [_timeline setSeparatorColor:CCamViewBackgroundColor];
    
    if (self.hidesBottomBarWhenPushed) {
        [_timeline setContentInset:UIEdgeInsetsMake(131, 0, 64, 0)];
        [_photoCollection setContentInset:UIEdgeInsetsMake(131, 0, 64, 0)];
    }else{
        [_timeline setContentInset:UIEdgeInsetsMake(131, 0, 64, 0)];
        [_photoCollection setContentInset:UIEdgeInsetsMake(131, 0, 64, 0)];
    }
    
    [_userBG addSubview:_photoCollection];
    [_userBG addSubview:_timeline];
    
    [_timeline setHidden:YES];
    
    CCamRefreshHeader *timelineHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(initUserPage)];
    timelineHeader.stateLabel.hidden = YES;
    timelineHeader.automaticallyChangeAlpha = YES;
    timelineHeader.lastUpdatedTimeLabel.hidden = YES;
//    timelineHeader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    [timelineHeader.arrowView setImage:nil];
//    timelineHeader.stateLabel.textColor = [UIColor whiteColor];
    _userBG.mj_header = timelineHeader;

//    _timeline.mj_header = timelineHeader;
    CCamRefreshFooter *timelineFooter = [CCamRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePhotos)];
    timelineFooter.refreshingTitleHidden = YES;
    timelineFooter.stateLabel.hidden = YES;
    timelineFooter.automaticallyChangeAlpha = YES;
    //    timelineFooter.automaticallyHidden = YES;
    _timeline.mj_footer = timelineFooter;
    
//    MJRefreshNormalHeader *collectionHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initUserPage)];
//    collectionHeader.automaticallyChangeAlpha = YES;
//    collectionHeader.lastUpdatedTimeLabel.hidden = YES;
//    _photoCollection.mj_header = collectionHeader;
    CCamRefreshFooter *collectionFooter = [CCamRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePhotos)];
    collectionFooter.automaticallyChangeAlpha = YES;
    collectionFooter.refreshingTitleHidden = YES;
    collectionFooter.stateLabel.hidden = YES;
//    [collectionFooter setTitle:@"加载更多照片" forState:MJRefreshStateIdle];
//    [collectionFooter setTitle:@"一大波照片正在赶来" forState:MJRefreshStateRefreshing];
//    [collectionFooter setTitle:@"亲，没有更多照片了" forState:MJRefreshStateNoMoreData];
    collectionFooter.hidden = NO;
//    collectionFooter.automaticallyHidden = NO;
    _photoCollection.mj_footer = collectionFooter;
    
    
    _timeline.emptyDataSetDelegate = self;
    _timeline.emptyDataSetSource = self;
    _timeline.tableFooterView = [UIView new];
    
    _photoCollection.emptyDataSetSource =self;
    _photoCollection.emptyDataSetDelegate = self;
    
    //    if (_userID) {
    //        if ([_userID isEqualToString:@""]) {
    //            _userID = [[AuthorizeHelper sharedManager] getUserID];
    //            [self initUserPage];
    //        }else{
    //            [self initUserPage];
    //        }
    //    }else{
    //        _userID = [[AuthorizeHelper sharedManager] getUserID];
    //        [self initUserPage];
    //    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _reloadIndexs = [NSMutableArray new];
    _photos = [NSMutableArray new];
    
    _userBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)];
    [_userBG setContentSize:CGSizeMake(CCamViewWidth, CCamViewHeight)];//-CCamNavigationBarHeight)];
    [_userBG setBackgroundColor:CCamViewBackgroundColor];
    [self.view addSubview:_userBG];
    
    [self initPhotoUI];
    [self initUserUI];
    
    if (self.showSetting) {
        UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(callSettingPage)];
        [self.navigationItem setRightBarButtonItem:setting];
        if (![[AuthorizeHelper sharedManager] checkToken]) {
            [[AuthorizeHelper sharedManager] callAuthorizeView];
        }else{
            _userID = [[AuthorizeHelper sharedManager] getUserID];
            [self initUserPage];
        }
    }else{
        [self initUserPage];
    }
    
    _topBtn = [UIButton new];
    [_topBtn setBackgroundColor:[UIColor clearColor]];
    [_topBtn setFrame:CGRectMake(0, 0, CCamNavigationBarHeight - 20, CCamNavigationBarHeight - 20)];
    [_topBtn setCenter:CGPointMake(self.navigationController.navigationBar.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2)];
    [_topBtn addTarget:self action:@selector(userPageGoTop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_topBtn];
    
}
- (void)userPageGoTop{
    if (_photos.count == 0) {
        return;
    }
    if (_photoCollection.hidden) {
        [_timeline scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [_photoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}
#pragma mark -empty data datasources
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"emptyDataLogo"];
}
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text;
//    
//    if (_showSetting || [_userID isEqualToString:[[AuthorizeHelper sharedManager] getUserID]]){
//        text =@"您还没有发布过照片";
//    }else if (_showSetting && [[AuthorizeHelper sharedManager] checkToken]) {
//       text= @"您还没有登录";
//    }else{
//        text = @"该用户还没有发布过照片";
//    }
//    
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    
//    if (_showSetting || [_userID isEqualToString:[[AuthorizeHelper sharedManager] getUserID]]){
//        text =@"您还没有发布过照片，马上拍一张吧";
//    }else
    if (_showSetting && ![[AuthorizeHelper sharedManager] checkToken]) {
        text= @"您还没有登录,无法获取您的照片";
    }else{
        if(_showSetting){
            text = @"您还没有发布过照片，马上拍一张吧";

        }else{
            text = @"该用户还没有发布过照片";
        }
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    NSAttributedString *string;
    
//    if (_showSetting || [_userID isEqualToString:[[AuthorizeHelper sharedManager] getUserID]]){
//        string = [[NSAttributedString alloc] initWithString:@"制作照片" attributes:attributes];
//    }else
    if (_showSetting && ![[AuthorizeHelper sharedManager] checkToken]) {
        string = [[NSAttributedString alloc] initWithString:Babel(@"登录") attributes:attributes];
    }else{
        if (_showSetting) {
            string = [[NSAttributedString alloc] initWithString:Babel(@"制作照片") attributes:attributes];

        }else{
            string = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
        }
    }
    
    return string;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return CCamViewBackgroundColor;
}
#pragma mark - empty data delegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    // Do something
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
//    if (_showSetting || [_userID isEqualToString:[[AuthorizeHelper sharedManager] getUserID]]){
//        UnitySendMessage(UnityController.UTF8String, "LoadEditScene", "");
//    }else
    if (_showSetting && ![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
    }else{
        if (_showSetting) {
            UnitySendMessage(UnityController.UTF8String, "LoadEditScene", "");
        }
    }
}
#pragma mark
- (NSMutableAttributedString *)returnStrWithTitle:(NSString *)mainTitle andSubtitle:(NSString *)subtitle{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",mainTitle,subtitle]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0] range:NSMakeRange(0, mainTitle.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mainTitle.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(mainTitle.length+1, subtitle.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(mainTitle.length+1, subtitle.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mainTitle.length+subtitle.length+1)];
    
    return str;
}
- (void)initPageFuncBtn{
    switch (_ifFollow) {
        case 0:
            //myself
            [_pageFuncBtn setBackgroundColor:CCamViewBackgroundColor];
            [_pageFuncBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_pageFuncBtn setTitle:Babel(@"编辑个人主页") forState:UIControlStateNormal];
            [_pageFuncBtn.layer setBorderColor:CCamViewBackgroundColor.CGColor];
            [_pageFuncBtn.layer setBorderWidth:0.5];
            break;
        case -1:
            //not followed
            [_pageFuncBtn setBackgroundColor:[UIColor whiteColor]];
            [_pageFuncBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
            [_pageFuncBtn setTitle:Babel(@"关注") forState:UIControlStateNormal];
            [_pageFuncBtn.layer setBorderColor:CCamRedColor.CGColor];
            [_pageFuncBtn.layer setBorderWidth:0.5];
            break;
        case 1:
            //followed
            [_pageFuncBtn setBackgroundColor:CCamYellowColor];
            [_pageFuncBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_pageFuncBtn setTitle:Babel(@"已关注") forState:UIControlStateNormal];
            [_pageFuncBtn.layer setBorderColor:CCamYellowColor.CGColor];
            [_pageFuncBtn.layer setBorderWidth:0.5];
            break;
        default:
            break;
    }
}
- (void)initUserPage{
    
    if (_showSetting && ![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        [_userBG.mj_header endRefreshing];
//        [_photoCollection.mj_header endRefreshing];
        return;
    }
    
    if (_showSetting) {
        _userID = [[AuthorizeHelper sharedManager] getUserID];
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"加载中");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSLog(@"访问用户%@主页",_userID);
    NSDictionary *parameters = @{@"memberid" :_userID,@"token":userToken};
    [manager POST:CCamGetUserHomePageURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hide:YES];
        
        NSError *error;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
       NSDictionary *receiveDic =[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        if(![GetValidString([receiveDic objectForKey:@"member"]) isEqualToString:@""]){
            
            NSString* state =[NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"member"]];
            
            NSLog(@"state = %@,length = %lu",state,(unsigned long)state.length);
            
            if (state.length ==1) {
                [[AuthorizeHelper sharedManager] loginStateError];
                return ;
            }
            
            [_titleLab setText:GetValidString([[receiveDic objectForKey:@"member"] objectForKey:@"name"])];
            [_userProfile sd_setImageWithURL:[NSURL URLWithString:[[receiveDic objectForKey:@"member"] objectForKey:@"image_url"]]];
            [_photoCount setAttributedTitle:[self returnStrWithTitle:[receiveDic objectForKey:@"workNums"] andSubtitle:Babel(@"提交照片")] forState:UIControlStateNormal];
            [_followerBtn setAttributedTitle:[self returnStrWithTitle:[receiveDic objectForKey:@"byfollowNum"] andSubtitle:Babel(@"关注者")] forState:UIControlStateNormal];
            [_followBtn setAttributedTitle:[self returnStrWithTitle:[receiveDic objectForKey:@"followNum"] andSubtitle:Babel(@"关注")] forState:UIControlStateNormal];
            _ifFollow = [[receiveDic objectForKey:@"ifFollow"] integerValue];
            [self initPageFuncBtn];
        }else{
            [_titleLab setText:@""];
            [_userProfile sd_setImageWithURL:[NSURL URLWithString:@""]];
            [_photoCount setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"提交照片")] forState:UIControlStateNormal];
            [_followerBtn setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"关注者")] forState:UIControlStateNormal];
            [_followBtn setAttributedTitle:[self returnStrWithTitle:@"0" andSubtitle:Babel(@"关注")] forState:UIControlStateNormal];
            _ifFollow = [[receiveDic objectForKey:@"ifFollow"] integerValue];
            [self initPageFuncBtn];
        }
        
        
        
        
        [_photos removeAllObjects];
        
        NSArray *receivePhotos = [receiveDic objectForKey:@"works"];
        NSLog(@"当前用户有%ld张照片",[receivePhotos count]);
        if (!receivePhotos || ![receivePhotos count]) {
            [_userBG.mj_header endRefreshing];
            [_photoCollection reloadData];
            [_timeline reloadData];
            return ;
        }
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        for (int i = 0; i<[receivePhotos count]; i++) {
            NSDictionary *timelineDic = [receivePhotos objectAtIndex:i];
            CCTimeLine *timeline = [NSEntityDescription insertNewObjectForEntityForName:@"CCTimeLine" inManagedObjectContext:context];
            [timeline initTimelineWith:timelineDic];
            if ([[timelineDic objectForKey:@"last_like"] isKindOfClass:[NSArray class]]) {
                NSArray *tempLikes = (NSArray *)[timelineDic objectForKey:@"last_like"];
                NSMutableArray *theLikes = [[NSMutableArray alloc] initWithCapacity:0];
                [theLikes removeAllObjects];
                for (int j = 0; j <tempLikes.count; j++) {
                    NSDictionary *tempLike = [tempLikes objectAtIndex:j];
                    CCLike * like = [NSEntityDescription insertNewObjectForEntityForName:@"CCLike" inManagedObjectContext:context];
                    [like initLikeWith:tempLike];
                    [theLikes addObject:like];
                }
                [timeline setLikes:[[NSOrderedSet alloc] initWithArray:theLikes]];
            }
            if ([[timelineDic objectForKey:@"comment"] isKindOfClass:[NSArray class]]) {
                NSArray *tempComments = (NSArray *)[timelineDic objectForKey:@"comment"];
                NSMutableArray *theComments = [[NSMutableArray alloc] initWithCapacity:0];
                [theComments removeAllObjects];
                for (int j = 0; j <tempComments.count; j++) {
                    NSDictionary *tempComment = [tempComments objectAtIndex:j];
                    CCComment * comment = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:context];
                    [comment initCommentWith:tempComment];
                    [theComments addObject:comment];
                }
                [timeline setComments:[[NSOrderedSet alloc] initWithArray:theComments]];
            }
            [_photos addObject:timeline];
        }
        
       
        [_timeline reloadData];
        
        [_photoCollection reloadData];
        
        [_userBG.mj_header endRefreshing];
        [_timeline.mj_footer setState:MJRefreshStateIdle];
//        [_photoCollection.mj_header endRefreshing];
        [_photoCollection.mj_footer setState:MJRefreshStateIdle];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [_userBG.mj_header endRefreshing];
        [_timeline.mj_footer setState:MJRefreshStateIdle];
//        [_photoCollection.mj_header endRefreshing];
        [_photoCollection.mj_footer setState:MJRefreshStateIdle];
        
    }];

}
- (void)loadMorePhotos{
    
    if (_photos.count == 0) {
        [_timeline.mj_footer endRefreshing];
        [_photoCollection.mj_footer endRefreshing];
        return;
    }
    
//    if ([_timeline.mj_footer isRefreshing] || [_photoCollection.mj_footer isRefreshing]) {
//        return;
//    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *userid = [[AuthorizeHelper sharedManager] getUserID];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSLog(@"访问用户%@主页",_userID);
    CCTimeLine *timelineObj = [_photos lastObject];
    NSDictionary *parameters = @{@"lastid":timelineObj.timelineID,@"memberid" :_userID,@"token":userToken};
    NSLog(@"%@",parameters);
    [manager POST:CCamGetMoreUserTimeLineURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (!receiveArray || ![receiveArray count]) {
            [_timeline.mj_footer endRefreshingWithNoMoreData];
            [_photoCollection.mj_footer endRefreshingWithNoMoreData];
            return ;
        }else{
            if ([receiveArray count]==0) {
                [_timeline.mj_footer endRefreshingWithNoMoreData];
                [_photoCollection.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        
        NSLog(@"%ld",(unsigned long)receiveArray.count);
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        
        
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* timelineDic = [receiveArray objectAtIndex:i];
            
            CCTimeLine *timeline =[NSEntityDescription insertNewObjectForEntityForName:@"CCTimeLine" inManagedObjectContext:context];
            [timeline initTimelineWith:timelineDic];
            
            if ([[timelineDic objectForKey:@"last_like"] isKindOfClass:[NSArray class]]) {
                NSArray *tempLikes = (NSArray *)[timelineDic objectForKey:@"last_like"];
                NSMutableArray *theLikes = [[NSMutableArray alloc] initWithCapacity:0];
                [theLikes removeAllObjects];
                for (int j = 0; j <tempLikes.count; j++) {
                    NSDictionary *tempLike = [tempLikes objectAtIndex:j];
                    CCLike * like = [NSEntityDescription insertNewObjectForEntityForName:@"CCLike" inManagedObjectContext:context];
                    [like initLikeWith:tempLike];
                    [theLikes addObject:like];
                }
                [timeline setLikes:[[NSOrderedSet alloc] initWithArray:theLikes]];
            }
            
            if ([[timelineDic objectForKey:@"comment"] isKindOfClass:[NSArray class]]) {
                NSArray *tempComments = (NSArray *)[timelineDic objectForKey:@"comment"];
                NSMutableArray *theComments = [[NSMutableArray alloc] initWithCapacity:0];
                [theComments removeAllObjects];
                for (int j = 0; j <tempComments.count; j++) {
                    NSDictionary *tempComment = [tempComments objectAtIndex:j];
                    CCComment * comment = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:context];
                    [comment initCommentWith:tempComment];
                    [theComments addObject:comment];
                }
                [timeline setComments:[[NSOrderedSet alloc] initWithArray:theComments]];
            }
            [_photos addObject:timeline];
        }
        [_photoCollection.mj_footer endRefreshing];
        [_timeline.mj_footer endRefreshing];
        
        [_timeline reloadData];
        
        [_photoCollection reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_timeline.mj_footer endRefreshing];
        [_photoCollection.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_photos count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"timelineCell";
    TimelineCell *cell = [[TimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    if (!cell.likeButtonBlock) {
        [cell setLikeButtonBlock:^(NSIndexPath *indexPath) {
            CCTimeLine *timeLine = (CCTimeLine*)[_photos objectAtIndex:indexPath.row];
            timeLine.liked = @"1";
            int likeCount = [timeLine.likeCount intValue]+1;
            timeLine.likeCount = [NSString stringWithFormat:@"%d",likeCount];
            NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
            CCLike *like = [NSEntityDescription insertNewObjectForEntityForName:@"CCLike" inManagedObjectContext:context];
            like.photoID = timeLine.timelineID;
            like.userID = [[AuthorizeHelper sharedManager] getUserID];
            like.userName = [[AuthorizeHelper sharedManager] getUserName];
            like.userImage = [[AuthorizeHelper sharedManager] getUserImage];
            like.dateline = @"-1";
            
            NSMutableArray *likes = [NSMutableArray new];
            [likes addObject:like];
            NSOrderedSet *likeSet = [timeLine.likes copy];
            for (CCLike * likey in likeSet) {
                [likes addObject:likey];
            }
            [timeLine setLikes:[[NSOrderedSet alloc] initWithArray:likes]];
            [weakSelf.timeline reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    
    if (!cell.deleteBlock) {
        [cell setDeleteBlock:^(NSIndexPath *indexPath) {
            [_photos removeObjectAtIndex:indexPath.row];
            [weakSelf.timeline beginUpdates];
            [weakSelf.timeline deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.timeline endUpdates];
            [weakSelf.timeline reloadData];
            [weakSelf.photoCollection reloadData];
        }];
    }
    
    if (!cell.privateBlock) {
        [cell setPrivateBlock:^(NSIndexPath *indexPath) {
            [weakSelf.timeline beginUpdates];
            [weakSelf.timeline reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.timeline endUpdates];
        }];
    }
    
    cell.timeline = (CCTimeLine*)[_photos objectAtIndex:indexPath.row];
    cell.parent = self;
    
    return cell;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    id timeline = [_photos objectAtIndex:indexPath.row];
    return [_timeline cellHeightForIndexPath:indexPath model:timeline keyPath:@"timeline" cellClass:[TimelineCell class] contentViewWidth:CCamViewWidth];
}
#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CCTimeLine *timeline = [_photos objectAtIndex:indexPath.row];
    CCPhotoViewController *photoView = [[CCPhotoViewController alloc] init];
    photoView.photoID = timeline.timelineID;
    photoView.vcTitle = [NSString stringWithFormat:@"%@",timeline.timelineUserName];
    photoView.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:photoView animated:YES];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer ;
    
    
    cellIdentifer= @"timelineCollectionCell";
    
    TimelineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    
    if (cell.photoImage == nil) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:img];
        cell.clipsToBounds = YES;
        cell.photoImage = img;
    }
    
    cell.timeline = [_photos objectAtIndex:indexPath.row];
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:cell.timeline.image_fullsize]];
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wh = (collectionView.bounds.size.width - 4)/3.0;
    
    return CGSizeMake(wh, wh);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}
#pragma mark - Follow User
- (void)callFollowPage{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    CCFollowViewController *follow = [[CCFollowViewController alloc] init];
    follow.userID = _userID;
    follow.vcTitle = [NSString stringWithFormat:@"%@%@",self.vcTitle,Babel(@"的关注列表")];
    follow.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:follow animated:YES];
}
- (void)callFollowerPage{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    CCFollowerViewController *follower = [[CCFollowerViewController alloc] init];
    follower.userID = _userID;
    follower.vcTitle = [NSString stringWithFormat:@"%@%@",self.vcTitle,Babel(@"的关注者列表")];
    follower.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:follower animated:YES];
}
- (void)callPersonalInfoPage{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    PersonInfoViewController * infoPage = [[PersonInfoViewController alloc] init];
    infoPage.parent = self;
    infoPage.vcTitle = Babel(@"编辑个人信息");
    [AuthorizeHelper sharedManager].personInfoVC = infoPage;
    infoPage.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:infoPage animated:YES];
}
- (void)callSettingPage{
    
//    if (![[AuthorizeHelper sharedManager] checkToken]) {
//        [[AuthorizeHelper sharedManager] callAuthorizeView];
//        return;
//    }
    
    SettingViewController *settingPage = [[SettingViewController alloc] init];
    settingPage.parent = self;
    settingPage.vcTitle = Babel(@"设置");
    settingPage.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:settingPage animated:YES];
}
#pragma mark - PageFunc
- (void)pageFunction{
    NSString *alertMsg = [NSString stringWithFormat:@"%@%@%@?",Babel(@"是否取消对"),self.vcTitle,Babel(@"的关注")];

    switch (_ifFollow) {
        case 0:
            //myself
            [self callPersonalInfoPage];
            break;
        case -1:
            //not followed
            [self followUser];
            break;
        case 1:
            //followed
            _deleteFollowAlert = [[UIAlertView alloc] initWithTitle:Babel(@"提示") message:alertMsg delegate:self cancelButtonTitle:Babel(@"保持关注") otherButtonTitles:Babel(@"取消关注"), nil];
            [_deleteFollowAlert show];
            break;
        default:
            break;
    }

}
- (void)followUser{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"关注用户中");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"bymemberid":_userID,@"token":userToken};
    [manager POST:CCamFollowURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *state =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",state);
        if ([state isEqualToString:@"1"]||[state isEqualToString:@"-2"]) {
            _ifFollow = 1;
            [hud hide:YES];
            [self initPageFuncBtn];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = Babel(@"关注失败");
            [hud hide:YES afterDelay:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"网络故障");
        [hud hide:YES afterDelay:1.0];
    }];

}
- (void)deleteFollowUser{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"取消关注中");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"bymemberid":_userID,@"token":userToken};
    [manager POST:CCamDeleteFollowURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *state =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",state);
        if ([state isEqualToString:@"1"]) {
            _ifFollow = -1;
            [hud hide:YES];
            [self initPageFuncBtn];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = Babel(@"取消关注失败");
            [hud hide:YES afterDelay:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"网络故障");
        [hud hide:YES afterDelay:1.0];
    }];

}
#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _deleteFollowAlert) {
        if (buttonIndex == 1) {
            [self deleteFollowUser];
        }
    }
}
@end
