//
//  CCDiscoveryViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCHomeViewController.h"

#import "CCPhoto.h"

#import <MJRefresh/MJRefresh.h>
#import "TimelineCell.h"
#import "TimelineTopCell.h"

#import "CCTimeLine.h"
#import "CCComment.h"
#import "CCLike.h"

#import "CCPhotoViewController.h"
#import "KLWebViewController.h"
#import "CCPhotoViewController.h"

#import "MessageViewController.h"

#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>

#import "lhScanQCodeViewController.h"
#import "KLNavigationController.h"

@interface CCHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate,KLCollectionLayoutDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(assign) BOOL needUpdate;

@property (nonatomic,strong) UIScrollView *backgroundView;
@property (nonatomic,strong) UIScrollView *photoBGView;
@property (nonatomic,strong) UITableView *timeline;
@property (nonatomic,strong) KLCollectionView *selectionCollection;
@property (nonatomic,strong) KLCollectionView *popularCollection;
@property (nonatomic,strong) KLCollectionView *lastCollection;
@property (nonatomic,strong) KLCollectionLayout *selectionLayout;
@property (nonatomic,strong) KLCollectionLayout *popularLayout;
@property (nonatomic,strong) KLCollectionLayout *lastLayout;

@property (nonatomic,strong) NSMutableArray *lastPhotos;
@property (nonatomic,strong) NSMutableArray *popularPhotos;
@property (nonatomic,strong) NSMutableArray *selectionPhotos;

@property (nonatomic,strong) NSMutableArray *timeLines;

@property (nonatomic,strong) UIView *photoSegView;
@property (nonatomic,strong) NSMutableArray *photoSegItems;

@property (nonatomic,strong) UIView *segmentView;
@property (nonatomic,strong) NSMutableArray *segmegtItems;
@property (nonatomic,strong) UIView *segmentSlider;


@end

@implementation CCHomeViewController
static NSString *const MJCollectionViewCellIdentifier = @"color";

- (void)returnTopPosition{
    
    if (_backgroundView.contentOffset.x == 0) {
        if ([_timeLines count]&&[_timeLines count]>0) {
            [_timeline scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else{
        if (_photoBGView.contentOffset.x == 0){
            if ([_selectionPhotos count]&&[_selectionPhotos count]>0) {
                [_selectionCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        }else if (_photoBGView.contentOffset.x == CCamViewWidth){
            if ([_popularPhotos count]&&[_popularPhotos count]>0) {
                [_popularCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        }else if (_photoBGView.contentOffset.x == CCamViewWidth*2){
            if ([_lastPhotos count]&&[_lastPhotos count]>0) {
                [_lastCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        }
    }
}


- (void)loadMessage{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    MessageViewController *message = [[MessageViewController alloc] init];
    message.vcTitle = NSLocalizedString(@"消息", @"");
    message.showLastest = NO;
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}
- (void)loadNewMessage{
    
    [MessageHelper sharedManager].messageCount = @"0";
    [self reloadMessageHeader];
    
    MessageViewController *message = [[MessageViewController alloc] init];
    message.vcTitle = NSLocalizedString(@"消息", @"");
    message.showLastest = YES;
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    _reloadIndexs = [NSMutableArray new];
    
    UIBarButtonItem *messageBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"messageIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(loadMessage)];
    [self.navigationItem setRightBarButtonItem:messageBtn];
    
    self.needUpdate = YES;
    
//    self.loadingSelection = NO;
//    self.loadingPopular = NO;
//    self.loadingLast = NO;
    
    NSArray* segArray = @[NSLocalizedString(@"订阅", @""),NSLocalizedString(@"广场", @"")];
    _segmegtItems = [NSMutableArray new];
    
    NSString *language = [[SettingHelper sharedManager] getCurrentLanguage];
    
    if ([language hasPrefix:@"zh"]) {
         _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamSegItemWidth*segArray.count, CCamSegItemHeight)];
    }else{
         _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamSegItemWidthEn*segArray.count, CCamSegItemHeight)];
    }
    
   
    [_segmentView setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:_segmentView];
    
    for (int i = 0 ; i <segArray.count; i++) {
        UIButton *segButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([language hasPrefix:@"zh"]) {
            [segButton setFrame:CGRectMake(CCamSegItemWidth*i, 0, CCamSegItemWidth, CCamSegItemHeight)];
        }else{
            [segButton setFrame:CGRectMake(CCamSegItemWidthEn*i, 0, CCamSegItemWidthEn, CCamSegItemHeight)];
        }
        
        
        [segButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.]];
        [segButton setTitle:[segArray objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [segButton setBackgroundColor:[UIColor clearColor]];
        [segButton setTag:i];
        [segButton addTarget:self action:@selector(homeSegItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentView addSubview:segButton];
        [_segmegtItems addObject:segButton];
    }
    if ([language hasPrefix:@"zh"]) {
        _segmentSlider = [[UIView alloc] initWithFrame:CGRectMake(0, CCamSegItemHeight-CCamSegSliderHeight-5, CCamSegItemWidth, CCamSegSliderHeight)];
        [_segmentSlider setBackgroundColor:[UIColor clearColor]];
        UIView *segmentSlider = [[UIView alloc] initWithFrame:CGRectMake((CCamSegItemWidth-CCamSegSliderWidth)/2, 0, CCamSegSliderWidth, CCamSegSliderHeight)];
        [segmentSlider setBackgroundColor:[UIColor whiteColor]];
        [_segmentSlider addSubview:segmentSlider];
        [_segmentView addSubview:_segmentSlider];
    }else{
        _segmentSlider = [[UIView alloc] initWithFrame:CGRectMake(0, CCamSegItemHeight-CCamSegSliderHeight-5, CCamSegItemWidthEn, CCamSegSliderHeight)];
        [_segmentSlider setBackgroundColor:[UIColor clearColor]];
        UIView *segmentSlider = [[UIView alloc] initWithFrame:CGRectMake((CCamSegItemWidthEn-CCamSegSliderWidthEn)/2, 0, CCamSegSliderWidthEn, CCamSegSliderHeight)];
        [segmentSlider setBackgroundColor:[UIColor whiteColor]];
        [_segmentSlider addSubview:segmentSlider];
        [_segmentView addSubview:_segmentSlider];
    }
    
    
    self.selectionPhotos = [NSMutableArray new];
    self.popularPhotos = [NSMutableArray new];
    self.lastPhotos = [NSMutableArray new];
    
    self.timeLines = [NSMutableArray new];
    
    self.selectionLayout = [[KLCollectionLayout alloc] init];
    self.popularLayout = [[KLCollectionLayout alloc] init];
    self.lastLayout = [[KLCollectionLayout alloc] init];
    
    self.backgroundView = [self returnScrollViewWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight-64)
                                              contentSize:CGSizeMake(2*CCamViewWidth, 0)
                                               pageEnable:YES
                                                  bounces:NO
                                          backgroundColor:CCamViewBackgroundColor
                                               parentView:self.view];
    [self.backgroundView setShowsHorizontalScrollIndicator:NO];
    [self.backgroundView setDelegate:self];
    
    self.photoBGView = [self returnScrollViewWithFrame:CGRectMake(CCamViewWidth, 0, CCamViewWidth, CCamViewHeight-64) contentSize:CGSizeMake(3*CCamViewWidth, 0) pageEnable:YES bounces:NO backgroundColor:CCamViewBackgroundColor parentView:self.backgroundView];
    [self.photoBGView setShowsHorizontalScrollIndicator:NO];
    [self.photoBGView setDelegate:self];
    
    self.timeline = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight-64) style:UITableViewStylePlain];
    [self.timeline setBackgroundColor:CCamViewBackgroundColor];
    [self.timeline setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
    [self.timeline setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 49, 0)];
    [self.timeline setDelegate:self];
    [self.timeline setDataSource:self];
    [self.timeline setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [_timeline registerClass:[TimelineTopCell class] forCellReuseIdentifier:@"topCell"];
    [_timeline registerClass:[TimelineCell class] forCellReuseIdentifier:@"timelineCell"];
    
    [self.backgroundView addSubview:self.timeline];
    
    self.selectionCollection = [self returnCollectionViewWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight-64)
                                                            layout:self.selectionLayout
                                                    layoutDelegate:self
                                                   backgroundColor:CCamViewBackgroundColor
                                                      contentInset:UIEdgeInsetsMake(44, 0, 49, 0)
                                             scrollIndicatorInsets:UIEdgeInsetsMake(44, 0, 49, 0)
                                                          delegate:self
                                                        dataSource:self
                                                         cellClass:[KLCollectionCell class]
                                                        Identifier:@"DiscoveryCell"
                                                        parentView:self.photoBGView];
    
    self.popularCollection = [self returnCollectionViewWithFrame:CGRectMake(CCamViewWidth, 0, CCamViewWidth, CCamViewHeight-64)
                                                            layout:self.popularLayout
                                                    layoutDelegate:self
                                                   backgroundColor:CCamViewBackgroundColor
                                                      contentInset:UIEdgeInsetsMake(44, 0, 49, 0)
                                             scrollIndicatorInsets:UIEdgeInsetsMake(44, 0, 49, 0)
                                                          delegate:self
                                                        dataSource:self
                                                         cellClass:[KLCollectionCell class]
                                                        Identifier:@"DiscoveryCell"
                                                        parentView:self.photoBGView];
    
    self.lastCollection = [self returnCollectionViewWithFrame:CGRectMake(CCamViewWidth*2, 0, CCamViewWidth, CCamViewHeight-64)
                                                            layout:self.lastLayout
                                                    layoutDelegate:self
                                                   backgroundColor:CCamViewBackgroundColor
                                                      contentInset:UIEdgeInsetsMake(44, 0, 49, 0)
                                             scrollIndicatorInsets:UIEdgeInsetsMake(44, 0, 49, 0)
                                                          delegate:self
                                                        dataSource:self
                                                         cellClass:[KLCollectionCell class]
                                                        Identifier:@"DiscoveryCell"
                                                        parentView:self.photoBGView];
    
    CCamRefreshHeader *selectHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshSelection)];
    selectHeader.stateLabel.hidden = YES;
    selectHeader.automaticallyChangeAlpha = YES;
    selectHeader.lastUpdatedTimeLabel.hidden = YES;
    _selectionCollection.mj_header = selectHeader;
    CCamRefreshHeader *popularHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPopular)];
    popularHeader.stateLabel.hidden = YES;
    popularHeader.automaticallyChangeAlpha = YES;
    popularHeader.lastUpdatedTimeLabel.hidden = YES;
    _popularCollection.mj_header = popularHeader;
    CCamRefreshHeader *lastHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshLast)];
    lastHeader.stateLabel.hidden = YES;
    lastHeader.automaticallyChangeAlpha = YES;
    lastHeader.lastUpdatedTimeLabel.hidden = YES;
    _lastCollection.mj_header = lastHeader;
    
    CCamRefreshFooter *selectFooter = [CCamRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSelection)];
    selectFooter.stateLabel.hidden = YES;
    selectFooter.refreshingTitleHidden = YES;
    selectFooter.automaticallyChangeAlpha = YES;
    _selectionCollection.mj_footer = selectFooter;
    
    CCamRefreshFooter *popluarFooter = [CCamRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePopular)];
    popluarFooter.refreshingTitleHidden = YES;
    popluarFooter.stateLabel.hidden = YES;
    popluarFooter.automaticallyChangeAlpha = YES;
    _popularCollection.mj_footer = popluarFooter;
    
    CCamRefreshFooter *lastFooter = [CCamRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreLast)];
    lastFooter.refreshingTitleHidden = YES;
    lastFooter.stateLabel.hidden = YES;
    lastFooter.automaticallyChangeAlpha = YES;
    _lastCollection.mj_footer = lastFooter;
    
    CCamRefreshHeader *timelineHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTimeline)];
    timelineHeader.stateLabel.hidden = YES;
    timelineHeader.automaticallyChangeAlpha = YES;
    timelineHeader.lastUpdatedTimeLabel.hidden = YES;
    _timeline.mj_header = timelineHeader;

    
    
    CCamRefreshFooter *timelineFooter = [CCamRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTimeline)];
    timelineFooter.stateLabel.hidden  = YES;
    timelineFooter.refreshingTitleHidden = YES;
    timelineFooter.automaticallyChangeAlpha = YES;
    _timeline.mj_footer = timelineFooter;

    _photoSegView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, CCamViewWidth, 44)];
    [_photoSegView setBackgroundColor:CCamViewBackgroundColor];
    [self.view addSubview:_photoSegView];
    
    NSArray *photoSegArray = @[NSLocalizedString(@"精选", @""),NSLocalizedString(@"热门", @""),NSLocalizedString(@"最新", @"")];
    _photoSegItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    float photoSegWidth = (CCamViewWidth - photoSegArray.count +1)/photoSegArray.count;
    
    for (int i = 0; i<photoSegArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = i;
        [button setFrame:CGRectMake((photoSegWidth+1)*i, 2, photoSegWidth, 40)];
        [button setTitle:[photoSegArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:CCamPhotoSegLightGray forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:CCamPhotoSegDarkGray forState:UIControlStateNormal];
        }
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [button addTarget:self action:@selector(segItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photoSegView addSubview:button];
        [_photoSegItems addObject:button];
        UIView *divierBG = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x+photoSegWidth, 2, 1, 40)];
        [divierBG setBackgroundColor:[UIColor whiteColor]];
        [_photoSegView addSubview:divierBG];
        UIView *divier = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x+photoSegWidth, 12, 1, 20)];
        [divier setBackgroundColor:CCamPhotoSegLightGray];
        [_photoSegView addSubview:divier];
    }
    [self loadLocalData];
    if ([iOSBindingManager sharedManager].showLauchScreen) {
//        [self performSelector:@selector(loadLocalData) withObject:nil afterDelay:3.0];
        [self performSelector:@selector(autoRefreshData) withObject:nil afterDelay:3.5];
    }else{
        
    }
    
    
}
- (void)loadLocalData{
    [self loadLocalTimeline];
    [self loadLocalPhotoWithOrder:@"selection"];
    [self loadLocalPhotoWithOrder:@"like"];
    [self loadLocalPhotoWithOrder:@""];
}
- (void)autoRefreshData{
    [self viewDidAppearRefreshData];
    [[MessageHelper sharedManager] initTimer];
    [[MessageHelper sharedManager] updateMessage];
    [iOSBindingManager sharedManager].showLauchScreen = NO;
}
- (void)loadTimeline{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"token" :token};
    
    NSLog(@"%@",parameters);
    
    [manager POST:CCamGetTimeLineURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       
        NSString *result =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"%@",result);
        if ([result isEqualToString:@"-1"]||[result isEqualToString:@"false"]) {
            [[AuthorizeHelper sharedManager] loginStateError];
            return;
        }
        
        [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCTimeLine"];

        [_timeline reloadData];
        
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
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
                    if (![context save:&error]) {
                        NSLog(@"保存失败");
                    }
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
                    if (![context save:&error]) {
                        NSLog(@"保存失败");
                    }
                }
                [timeline setComments:[[NSOrderedSet alloc] initWithArray:theComments]];
            }
            
            if (![context save:&error]) {
                NSLog(@"保存失败");
            }
        }
        [_timeline.mj_header endRefreshing];
        [self loadLocalTimeline];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_timeline.mj_header endRefreshing];
    }];
}
- (void)loadMoreTimeline{
    
    if ([_timeLines count] == 0) {
        [_timeline.mj_footer endRefreshing];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    CCTimeLine *lastTimeline = (CCTimeLine*)[_timeLines lastObject];
    NSString *lastID = lastTimeline.timelineID;
    NSLog(@"%@",lastID);
    
    if(!lastID){
        [_timeline.mj_footer endRefreshing];
        [_timeLines removeAllObjects];
        [_timeline reloadData];
        return;
    }
    
    NSDictionary *parameters = @{@"token" :token,@"lastid":lastID};
    [manager POST:CCamGetMoreTimeLineURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
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
                    if (![context save:&error]) {
                        NSLog(@"保存失败");
                    }
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
                    if (![context save:&error]) {
                        NSLog(@"保存失败");
                    }
                }
                [timeline setComments:[[NSOrderedSet alloc] initWithArray:theComments]];
            }
            
            if (![context save:&error]) {
                NSLog(@"保存失败");
            }
        }

        [_timeline.mj_footer endRefreshing];
        [self loadLocalTimeline];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_timeline.mj_footer endRefreshing];

    }];
}
- (void)loadLocalTimeline{
    NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CCTimeLine" inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *infos = [context executeFetchRequest:request error:&error];
    if ([infos count] == 0) {
        NSLog(@"本地无数据，需要联网同步数据");
        return;
    }else{
        NSLog(@"本地数据库读取%lu个朋友圈",(unsigned long)infos.count);
    }
    
    [self.timeLines removeAllObjects];
    [self.timeLines addObjectsFromArray:[context executeFetchRequest:request error:&error]];
    
    NSLog(@"=========>本地朋友圈数%lu",(unsigned long)self.timeLines.count);
    [self.timeline reloadData];
}
- (void)refreshSelection{
    [self loadDiscoveryWithRefresh:YES
                             order:@"selection"
                            lastid:@""
                          lastlike:@""
                               ids:@""];
}
- (void)refreshPopular{
    [self loadDiscoveryWithRefresh:YES
                             order:@"like"
                            lastid:@""
                          lastlike:@""
                               ids:@""];
}
- (void)refreshLast{
    [self loadDiscoveryWithRefresh:YES
                             order:@""
                            lastid:@""
                          lastlike:@""
                               ids:@""];
}
- (void)loadMoreSelection{
    [self loadDiscoveryWithRefresh:NO
                             order:@"selection"
                            lastid:[self returnParameterWithType:@"lastid" andOrder:@"selection"]
                          lastlike:@""
                               ids:@""];
}
- (void)loadMorePopular{
    [self loadDiscoveryWithRefresh:NO
                             order:@"like"
                            lastid:[self returnParameterWithType:@"lastid" andOrder:@"like"]
                          lastlike:[self returnParameterWithType:@"lastlike" andOrder:@"like"]
                               ids:[self returnParameterWithType:@"ids" andOrder:@"like"]];
}
- (void)loadMoreLast{
    [self loadDiscoveryWithRefresh:NO
                             order:@""
                            lastid:[self returnParameterWithType:@"lastid" andOrder:@""]
                          lastlike:@""
                               ids:@""];
}
- (NSString*)returnParameterWithType:(NSString*)type andOrder:(NSString*)order{
    
    NSString *parameter = @"";
    
    CCPhoto *photo;
    
    if ([type isEqualToString:@"lastid"]) {
        if ([order isEqualToString:@"selection"]) {
            photo = (CCPhoto*)[self.selectionPhotos lastObject];
        }else if ([order isEqualToString:@"like"]){
            photo = (CCPhoto*)[self.popularPhotos lastObject];
        }else{
            photo = (CCPhoto*)[self.lastPhotos lastObject];
        }
        parameter = photo.photoID;
    }else if ([type isEqualToString:@"lastlike"]){
        if ([order isEqualToString:@"like"]) {
            photo = (CCPhoto*)[self.popularPhotos lastObject];
            parameter =  photo.like;
        }
    }else if ([type isEqualToString:@"ids"]){
        if ([order isEqualToString:@"like"]) {
            for (int i = 0; i<self.popularPhotos.count; i++) {
                
                CCPhoto *photoForHot = (CCPhoto*)[self.popularPhotos objectAtIndex:i];
                if (i == self.popularPhotos.count-1) {
                    parameter = [NSString stringWithFormat:@"%@%@",parameter,photoForHot.photoID];
                }else{
                    parameter = [NSString stringWithFormat:@"%@%@,",parameter,photoForHot.photoID];
                }
            }
        }
    }
    
    return parameter;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![iOSBindingManager sharedManager].showLauchScreen) {
        [self autoRefreshData];
    }

    if (_reloadIndexs && [_reloadIndexs count]) {
        NSLog(@"*****%lu",(unsigned long)_reloadIndexs.count);
        [_timeline reloadRowsAtIndexPaths:_reloadIndexs withRowAnimation:UITableViewRowAnimationAutomatic];
        [_reloadIndexs removeAllObjects];
    }
    
}
- (void)reloadInfo{
    [_timeline.mj_header beginRefreshing];
    [_selectionCollection.mj_header beginRefreshing];
    [_popularCollection.mj_header beginRefreshing];
    [_lastCollection.mj_header beginRefreshing];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidAppearRefreshData{
    if (!self.needUpdate) {
        return;
    }
    [_timeline.mj_header beginRefreshing];
    [_selectionCollection.mj_header beginRefreshing];
    [_popularCollection.mj_header beginRefreshing];
    [_lastCollection.mj_header beginRefreshing];
    
    self.needUpdate = NO;
}
- (void)collectionCellUserPage:(id)sender{
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    UIButton *likeButton = (UIButton*)sender;
    
    KLCollectionCell *collectionCell = (KLCollectionCell*)[[likeButton superview] superview];
    
    NSLog(@"memberid:%@",collectionCell.photo.userID);
    NSLog(@"name:%@",collectionCell.photo.userName);
    
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    userpage.userID = collectionCell.photo.userID;
    userpage.vcTitle = collectionCell.photo.userName;
    userpage.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:userpage animated:YES];
}
- (void)collectionCellPhotoPage:(id)sender{
    
    UIButton *likeButton = (UIButton*)sender;
    
    KLCollectionCell *collectionCell = (KLCollectionCell*)[[likeButton superview] superview];
    
    NSLog(@"photoid:%@",collectionCell.photo.photoID);

    CCPhotoViewController *photoView = [[CCPhotoViewController alloc] init];
    photoView.photoID = collectionCell.photo.photoID;
    photoView.vcTitle = [NSString stringWithFormat:@"%@",collectionCell.photo.userName];
    photoView.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:photoView animated:YES];
}
- (void)likePhoto:(id)sender{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    UIButton *likeButton = (UIButton*)sender;
    
    KLCollectionCell *collectionCell = (KLCollectionCell*)[[likeButton superview] superview];
   
    if (!collectionCell) {
        return;
    }else{
        if (!collectionCell.photo) {
            return;
        }
    }
   
    if ([collectionCell.photo.liked isEqualToString:@"1"]) {
        return;
    }
    
    [likeButton setTintColor:CCamRedColor];
    NSLog(@"%@",collectionCell.photo.userName);
    collectionCell.photo.liked = @"1";
    collectionCell.photo.like = [NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue+1];
    [collectionCell.likeButton setTitle:collectionCell.photo.like forState:UIControlStateNormal];
    [collectionCell.likeButton sizeToFit];
    [collectionCell.likeButton setFrame:CGRectMake(0, 0, collectionCell.likeButton.frame.size.width+2, 44)];
    [collectionCell.likeButton setCenter:CGPointMake(collectionCell.bounds.size.width-10-collectionCell.likeButton.frame.size.width/2, collectionCell.userName.center.y)];
    
    NSDictionary *parameters = @{@"token":[[AuthorizeHelper sharedManager] getUserToken],@"workid":collectionCell.photo.photoID};
    NSLog(@"Request parmeters is %@",parameters);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CCamLikePhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *likeResult = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",likeResult);
        if ([likeResult isEqualToString:@"1"]) {
            NSLog(@"likephoto result is successed!");
            
        }else if ([likeResult isEqualToString:@"-1"]){
            NSLog(@"likephoto result is failed!");
            [likeButton setTintColor:CCamPhotoSegLightGray];
            collectionCell.photo.liked = @"0";
            collectionCell.photo.like = [NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue-1];
            [collectionCell.likeButton setTitle:collectionCell.photo.like forState:UIControlStateNormal];
            [collectionCell.likeButton sizeToFit];
            [collectionCell.likeButton setFrame:CGRectMake(0, 0, collectionCell.likeButton.frame.size.width+2, 44)];
            [collectionCell.likeButton setCenter:CGPointMake(collectionCell.bounds.size.width-10-collectionCell.likeButton.frame.size.width/2, collectionCell.userName.center.y)];
            [[AuthorizeHelper sharedManager] loginStateError];
        }else if ([likeResult isEqualToString:@"-2"]){
            NSLog(@"likephoto result is has been liked!");
            collectionCell.photo.like = [NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue-1];
            [collectionCell.likeButton setTitle:collectionCell.photo.like forState:UIControlStateNormal];
            [collectionCell.likeButton sizeToFit];
            [collectionCell.likeButton setFrame:CGRectMake(0, 0, collectionCell.likeButton.frame.size.width+2, 44)];
            [collectionCell.likeButton setCenter:CGPointMake(collectionCell.bounds.size.width-10-collectionCell.likeButton.frame.size.width/2, collectionCell.userName.center.y)];
        }else{
            NSLog(@"likephoto result is unknown!");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [likeButton setBackgroundImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        collectionCell.photo.liked = @"0";
        collectionCell.photo.like = [NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue-1];
        [collectionCell.likeButton setTitle:collectionCell.photo.like forState:UIControlStateNormal];
        [collectionCell.likeButton sizeToFit];
        [collectionCell.likeButton setFrame:CGRectMake(0, 0, collectionCell.likeButton.frame.size.width+2, 44)];
        [collectionCell.likeButton setCenter:CGPointMake(collectionCell.bounds.size.width-10-collectionCell.likeButton.frame.size.width/2, collectionCell.userName.center.y)];
    }];
    

}

- (void)loadLocalPhotoWithOrder:(NSString*)order{
    NSError *error;
    NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
    NSEntityDescription *entityObj = [NSEntityDescription entityForName:@"CCPhoto" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"photoDataType = '%@'",order]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entityObj];
    [request setPredicate:predicate];
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if ([order isEqualToString:@"selection"]) {
        [self.selectionPhotos removeAllObjects];
        [self.selectionPhotos addObjectsFromArray:datas];
        NSLog(@"### Selection photoes count = %lu",(unsigned long)self.selectionPhotos.count);
        [self.selectionCollection reloadData];
        
    }else if ([order isEqualToString:@"like"]){
        [self.popularPhotos removeAllObjects];
        [self.popularPhotos addObjectsFromArray:datas];
        NSLog(@"### Popular photoes count = %lu",(unsigned long)self.popularPhotos.count);
        [self.popularCollection reloadData];
        
    }else{
        [self.lastPhotos removeAllObjects];
        [self.lastPhotos addObjectsFromArray:datas];
        NSLog(@"### Lastest photoes count = %lu",(unsigned long)self.lastPhotos.count);
        [self.lastCollection reloadData];
    }

}

- (void)loadDiscoveryWithRefresh:(BOOL)refresh order:(NSString*)order lastid:(NSString*)lastid lastlike:(NSString*)lastlike ids:(NSString*)ids{
    
    
    NSString *url;
    NSDictionary *parameters;
    
    if (refresh) {
        url = CCamGetDiscoveryURL;
        parameters = @{@"order":order,@"token":[[AuthorizeHelper sharedManager] getUserToken]};
    }else{
        url = CCamGetDiscoveryMoreURL;
        
        if (!lastid||[lastid isKindOfClass:[NSNull class]]) {
            if([order isEqualToString:@"selection"]){
                [_selectionCollection.mj_footer endRefreshing];
                return;
            }else if ([order isEqualToString:@"like"]){
                [_popularCollection.mj_footer endRefreshing];
                return;
            }else{
                [_lastCollection.mj_footer endRefreshing];
                return;
            }
        }
        
        if ([order isEqualToString:@"like"]) {
            parameters = @{@"order":order,@"lastid":lastid,@"lastlike":lastlike,@"ids":ids,@"token":[[AuthorizeHelper sharedManager] getUserToken]};
        }else{
            parameters = @{@"order":order,@"lastid":lastid,@"token":[[AuthorizeHelper sharedManager] getUserToken]};
        }
    }
    
    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        if (![[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error] isKindOfClass:[NSArray class]]) {
            
            return ;
        }
        
        NSArray * receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        NSMutableArray *tempPhotos = [NSMutableArray new];
        
        
        
        NSLog(@"Arrive photos count = %lu",(unsigned long)tempPhotos.count);
        
        if (refresh) {
            
            NSEntityDescription *entityObj = [NSEntityDescription entityForName:@"CCPhoto" inManagedObjectContext:context];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"photoDataType = '%@'",order]];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setIncludesPropertyValues:NO];
            [request setEntity:entityObj];
            [request setPredicate:predicate];
            
            NSArray *datas = [context executeFetchRequest:request error:&error];
            NSLog(@"动画数量为%lu",(unsigned long)[datas count]);
            if (!error && datas && [datas count])
            {
                for (CCPhoto *obj in datas){
                    [context deleteObject:obj];
                }
            }
            
            for (int i = 0; i < receiveArray.count; i++) {
                NSDictionary* photoDic = [receiveArray objectAtIndex:i];
                CCPhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"CCPhoto" inManagedObjectContext:context];
                [photo initPhotoWith:photoDic];
                photo.photoDataType = [order copy];
                [tempPhotos addObject:photo];
                if (![context save:&error]) {
                    NSLog(@"照片保存失败%@",photo.photoID);
                }
            }
            
            if ([order isEqualToString:@"selection"]) {
                [self.selectionCollection.mj_header endRefreshing];
                
            }else if ([order isEqualToString:@"like"]){
                [self.popularCollection.mj_header endRefreshing];
                
            }else{
                [self.lastCollection.mj_header endRefreshing];
            }
            
            [self loadLocalPhotoWithOrder:order];
        }else{
            
            for (int i = 0; i < receiveArray.count; i++) {
                NSDictionary* photoDic = [receiveArray objectAtIndex:i];
                CCPhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"CCPhoto" inManagedObjectContext:context];
                [photo initPhotoWith:photoDic];
                photo.photoDataType = [order copy];
                [tempPhotos addObject:photo];
                if (![context save:&error]) {
                    NSLog(@"照片保存失败%@",photo.photoID);
                }

            }
            
            if ([order isEqualToString:@"selection"]) {
                [self.selectionPhotos addObjectsFromArray:tempPhotos];
                NSLog(@"$$$ Selection photoes count = %lu",(unsigned long)self.selectionPhotos.count);
                [self.selectionCollection.mj_footer endRefreshing];
                [self.selectionCollection reloadData];
            }else if ([order isEqualToString:@"like"]){
                [self.popularPhotos addObjectsFromArray:tempPhotos];
                NSLog(@"$$$ Popular photoes count = %lu",(unsigned long)self.popularPhotos.count);
                [self.popularCollection.mj_footer endRefreshing];
                [self.popularCollection reloadData];
            }else{
                [self.lastPhotos addObjectsFromArray:tempPhotos];
                NSLog(@"$$$ Lastest photoes count = %lu",(unsigned long)self.lastPhotos.count);
                [self.lastCollection.mj_footer endRefreshing];
                [self.lastCollection reloadData];
            }
        }
        
        
        receiveArray = nil;
        [tempPhotos removeAllObjects];
        tempPhotos = nil;
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (refresh) {
            if ([order isEqualToString:@"selection"]) {
                [self.selectionCollection.mj_header endRefreshing];
            }else if ([order isEqualToString:@"like"]){
                [self.popularCollection.mj_header endRefreshing];
            }else{
                [self.lastCollection.mj_header endRefreshing];
            }
            
        }else{
            if ([order isEqualToString:@"selection"]) {
                [self.selectionCollection.mj_footer endRefreshing];
            }else if ([order isEqualToString:@"like"]){
                [self.popularCollection.mj_footer endRefreshing];
            }else{
                [self.lastCollection.mj_footer endRefreshing];
            }
        }
    }];
}

#pragma mark - CollectionView Delegate
- (CGFloat)collectionLayout:(KLCollectionLayout*)layout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath{
   
    if (layout == self.selectionLayout) {
        NSString * note = @"";
        CCPhoto * photo =[_selectionPhotos objectAtIndex:indexPath.row];
        if (photo.photoDescription != nil && [photo.photoDescription isKindOfClass:[NSString class]]) {
            note = photo.photoDescription;
        }
        if (note.length == 0) {
            return width + 44;
        }else{
            CGRect textRect = [note boundingRectWithSize:CGSizeMake(width-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
            return width + 44 + textRect.size.height + 10;
        }
    }
    else if (layout == self.popularLayout) {
        NSString * note = @"";
        CCPhoto * photo = [_popularPhotos objectAtIndex:indexPath.row];
        if (photo.photoDescription != nil && [photo.photoDescription isKindOfClass:[NSString class]]) {
            note = photo.photoDescription;
        }
        if (note.length == 0) {
            return width + 44;
        }else{
            CGRect textRect = [note boundingRectWithSize:CGSizeMake(width-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
            return width + 44 + textRect.size.height + 10;
        }
    }
    else if (layout == self.lastLayout) {
        NSString*note= @"";
        CCPhoto * photo = [_lastPhotos objectAtIndex:indexPath.row];
        if (photo.photoDescription != nil && [photo.photoDescription isKindOfClass:[NSString class]]) {
            note = photo.photoDescription;
        }
        if (note.length == 0) {
            return width + 44;
        }else{
            CGRect textRect = [note boundingRectWithSize:CGSizeMake(width-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
            return width + 44 + textRect.size.height + 10;
        }
    }
    
    return width + 44;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.selectionCollection) {
        return self.selectionPhotos.count;
    }else if (collectionView == self.popularCollection){
        return self.popularPhotos.count;
    }else if (collectionView == self.lastCollection) {
        return self.lastPhotos.count;
    }
    
    return 0;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoveryCell" forIndexPath:indexPath];
//    CCPhoto*photo;
    
    if (collectionView == self.selectionCollection) {
        cell.photo = (CCPhoto*)[self.selectionPhotos objectAtIndex:indexPath.row];
    }else if (collectionView == self.popularCollection){
        cell.photo = (CCPhoto*)[self.popularPhotos objectAtIndex:indexPath.row];
    }else if (collectionView == self.lastCollection) {
        cell.photo = (CCPhoto*)[self.lastPhotos objectAtIndex:indexPath.row];
    }
    
//    cell.photo = photo;
    
    [cell setBackgroundColor:[UIColor whiteColor]];
//    [cell.layer setMasksToBounds:YES];
//    [cell.layer setCornerRadius:5.0];
    
    [cell.workImage setBackgroundColor:CCamViewBackgroundColor];
    [cell.workImage sd_setImageWithURL:[NSURL URLWithString:cell.photo.imageMiddle] placeholderImage:nil];
    [cell.workImage setContentMode:UIViewContentModeScaleAspectFit];
    
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:cell.photo.userImage] placeholderImage:nil];
    
    [cell.userName setText:cell.photo.userName];
    [cell.userName setFont:[UIFont boldSystemFontOfSize:14.0]];
    [cell.userName setTextColor:CCamGrayTextColor];
    
    [cell.pictureNote setText:cell.photo.photoDescription];
    [cell.pictureNote setFont:[UIFont systemFontOfSize:11.0]];
    [cell.pictureNote setTextColor:CCamGrayTextColor];
    [cell.pictureNote setNumberOfLines:0];
    CGRect textRect = [cell.pictureNote.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
    [cell.pictureNote setFrame:CGRectMake(8, cell.frame.size.width + 22 +20, cell.frame.size.width-16, textRect.size.height)];
    
    [cell.likeButton setTitle:cell.photo.like forState:UIControlStateNormal];
    [cell.likeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [cell.likeButton setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [cell.likeButton setImage:[[UIImage imageNamed:@"likeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    if ([cell.photo.liked isEqualToString:@"1"]) {
        [cell.likeButton setTintColor:CCamRedColor];
    }else{
        [cell.likeButton setTintColor:CCamPhotoSegLightGray];
    }
    [cell.likeButton sizeToFit];
    [cell.likeButton setFrame:CGRectMake(0, 0, cell.likeButton.frame.size.width+2, 44)];
    [cell.likeButton setCenter:CGPointMake(cell.bounds.size.width-10-cell.likeButton.frame.size.width/2, cell.userName.center.y)];
    [cell.likeButton addTarget:self action:@selector(likePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.userButton addTarget:self action:@selector(collectionCellUserPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.imageButton addTarget:self action:@selector(collectionCellPhotoPage:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    CCPhoto*photo = [[CCPhoto alloc] init];
//    
//    if (collectionView == self.selectionCollection) {
//        NSLog(@"Collection is selection");
//        photo = [self.selectionPhotos objectAtIndex:indexPath.row];
//      
//    }else if (collectionView == self.popularCollection) {
//        NSLog(@"Collection is hot");
//        photo = [self.popularPhotos objectAtIndex:indexPath.row];
//       
//    }else if (collectionView == self.lastCollection){
//        NSLog(@"Collection is new");
//        photo = [self.lastPhotos objectAtIndex:indexPath.row];
//        
//    }
//
//    CCPhotoViewController *photoView = [[CCPhotoViewController alloc] init];
//    photoView.photoID = photo.workid;
//    photoView.vcTitle = [NSString stringWithFormat:@"%@",photo.name];
//    photoView.hidesBottomBarWhenPushed = YES;
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
//    backItem.title=@"";
//    self.navigationItem.backBarButtonItem=backItem;
//    [self.navigationController pushViewController:photoView animated:YES];
}

//#pragma mark - ScrollView Delegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    
////    NSLog(@"%f",scrollView.contentOffset.y);
////    NSLog(@"%f",scrollView.frame.size.height);
////    NSLog(@"%f",scrollView.contentSize.height);
//    /**
//     *  关键-->
//     *  scrollView一开始并不存在偏移量,但是会设定contentSize的大小,所以contentSize.height永远都会比contentOffset.y高一个手机屏幕的
//     *  高度;上拉加载的效果就是每次滑动到底部时,再往上拉的时候请求更多,那个时候产生的偏移量,就能让contentOffset.y + 手机屏幕尺寸高大于这
//     *  个滚动视图的contentSize.height
//     */
//    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
//        
////        NSLog(@"%d %s",__LINE__,__FUNCTION__);
//        
//        if (scrollView == self.selectionCollection) {
////            [self loadMoreSelection];
////            [self.selectionLoading startAnimating];
//        }else if (scrollView == self.popularCollection){
////            [self loadMorePopular];
////            [self.popularLoading startAnimating];
//        }else if (scrollView == self.lastCollection){
////            [self loadMoreLast];
////            [self.lastLoading startAnimating];
//        }
//
//    }
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.photoBGView) {
//        
//        [_segmentSlider setFrame:CGRectMake(scrollView.contentOffset.x * _segmentView.frame.size.width /scrollView.contentSize.width, _segmentSlider.frame.origin.y, _segmentSlider.frame.size.width, _segmentSlider.frame.size.height)];
        
        
        if (scrollView.contentOffset.x == 0) {
            if (self.selectionPhotos.count == 0) {
                if (![_selectionCollection.mj_header isRefreshing]) {
                    [_selectionCollection.mj_header beginRefreshing];            }
                }
            [self setSegmentApprenceWithOffset:scrollView.contentOffset.x];
        }else if (scrollView.contentOffset.x == CCamViewWidth){
            if (self.popularPhotos.count == 0) {
                if (![_popularCollection.mj_header isRefreshing]) {
                    [_popularCollection.mj_header beginRefreshing];            }
                }
            [self setSegmentApprenceWithOffset:scrollView.contentOffset.x];
        }else if (scrollView.contentOffset.x == CCamViewWidth*2){
            if (self.lastPhotos.count == 0) {
                if (![_lastCollection.mj_header isRefreshing]) {
                    [_lastCollection.mj_header beginRefreshing];
                }
            }
            [self setSegmentApprenceWithOffset:scrollView.contentOffset.x];
        }
    }else if (scrollView == self.backgroundView){
        [_segmentSlider setFrame:CGRectMake(scrollView.contentOffset.x * _segmentView.frame.size.width /scrollView.contentSize.width, _segmentSlider.frame.origin.y, _segmentSlider.frame.size.width, _segmentSlider.frame.size.height)];
        [_photoSegView setCenter:CGPointMake(_photoSegView.center.x,-64+64*(scrollView.contentOffset.x/CCamViewWidth)+22)];
//        [_photoSegView setFrame:CGRectMake(0, -64+69*(scrollView.contentOffset.x/CCamViewWidth), _photoSegView.frame.size.width, _photoSegView.frame.size.height)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.photoBGView) {
        [self setPhotoSegmentApprenceWithOffset:scrollView.contentOffset.x];
        if (scrollView.contentOffset.x == 0) {
            if (self.selectionPhotos.count == 0) {
                if ([_selectionCollection.mj_header isRefreshing]) {
                    return;
                }
                [_selectionCollection.mj_header beginRefreshing];
            }
        }else if (scrollView.contentOffset.x == CCamViewWidth){
            if (self.popularPhotos.count == 0) {
                if ([_popularCollection.mj_header isRefreshing]) {
                    return;
                }
                [_popularCollection.mj_header beginRefreshing];
            }
        }else if (scrollView.contentOffset.x == CCamViewWidth*2){
            if (self.lastPhotos.count == 0) {
                if ([_lastCollection.mj_header isRefreshing]) {
                    return;
                }
                [_lastCollection.mj_header beginRefreshing];
            }
        }
    }else if (scrollView == self.backgroundView){
        [self setSegmentApprenceWithOffset:scrollView.contentOffset.x];
    }
}
- (void)setPhotoSegmentApprenceWithOffset:(CGFloat)offset{
    
    for (UIButton *segItem in self.photoSegItems) {
        if (segItem.tag == offset/CCamViewWidth) {
            [segItem setTitleColor:CCamPhotoSegDarkGray forState:UIControlStateNormal];
            [segItem setTitleColor:CCamPhotoSegDarkGray forState:UIControlStateHighlighted];
        }else{
            [segItem setTitleColor:CCamPhotoSegLightGray forState:UIControlStateNormal];
            [segItem setTitleColor:CCamPhotoSegLightGray forState:UIControlStateHighlighted];
        }
    }
}
- (void)setSegmentApprenceWithOffset:(CGFloat)offset{
    
    for (UIButton *segItem in self.segmegtItems) {
        if (segItem.tag == offset/CCamViewWidth) {
            [segItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [segItem setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }else{
            [segItem setTitleColor:CCamExLightGrayColor forState:UIControlStateNormal];
            [segItem setTitleColor:CCamExLightGrayColor forState:UIControlStateHighlighted];
        }
    }
}
#pragma mark - SegmentControl
- (void)segItemOnClick:(id)sender{
    for (UIButton *btn in _photoSegItems) {
        [btn setTitleColor:CCamPhotoSegLightGray forState:UIControlStateNormal];
    }
    
    UIButton *button  = (UIButton*)sender;
    [button setTitleColor:CCamPhotoSegDarkGray forState:UIControlStateNormal];

    [self.photoBGView setContentOffset:CGPointMake(CCamViewWidth*button.tag, self.backgroundView.contentOffset.y) animated:NO];
}
- (void)homeSegItemOnClick:(id)sender{
    UIButton *button  = (UIButton*)sender;
    [self.backgroundView setContentOffset:CGPointMake(CCamViewWidth*button.tag, self.backgroundView.contentOffset.y) animated:NO];
}
#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if(section == 0){
//        return 1;
//    }
    
    return [_timeLines count];//1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//2;//[_timeLines count];
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
            CCTimeLine *timeLine = (CCTimeLine*)[_timeLines objectAtIndex:indexPath.row];
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
            [_timeLines removeObjectAtIndex:indexPath.row];
            [weakSelf.timeline beginUpdates];
            [weakSelf.timeline deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.timeline endUpdates];
            [weakSelf.timeline reloadData];
        }];
    }
    
    if (!cell.privateBlock) {
        [cell setPrivateBlock:^(NSIndexPath *indexPath) {
            [weakSelf.timeline beginUpdates];
            [weakSelf.timeline reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.timeline endUpdates];
        }];
    }
    
    cell.timeline = (CCTimeLine*)[_timeLines objectAtIndex:indexPath.row];
    cell.parent = self;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)callContestWeb:(id)sender{
    UIButton *btn = (UIButton*)sender;
    KLWebViewController *detail = [[KLWebViewController alloc] init];
    detail.webURL = [NSString stringWithFormat:@"http://www.c-cam.cc/index.php/First/Photo/index/contestid/%ld.html",(long)btn.tag];
    detail.vcTitle =btn.currentTitle;
    detail.hidesBottomBarWhenPushed = YES;
    
    id vc = nil;
    vc = detail;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([[MessageHelper sharedManager].messageCount isEqualToString:@"0"]) {
        return 0;
    }else{
        return 44;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CCamViewWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        id timeline = [_timeLines objectAtIndex:indexPath.row];
        return [_timeline cellHeightForIndexPath:indexPath model:timeline keyPath:@"timeline" cellClass:[TimelineCell class] contentViewWidth:CCamViewWidth];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *identifier = @"header";
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    [view setFrame:CGRectMake(0, 0, CCamViewWidth, 44)];
    
    UIButton* btn = [UIButton new];
    [btn setFrame:CGRectMake(0, 0, CCamViewWidth, 44)];
//    [btn.layer setCornerRadius:5.0];
//    [btn.layer setBorderColor:CCamRedColor.CGColor];
//    [btn.layer setBorderWidth:0.5];
//    [btn.layer setMasksToBounds:YES];
    [view addSubview:btn];
    [btn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [btn setTitle:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"您有", @""),[MessageHelper sharedManager].messageCount,NSLocalizedString(@"条新消息",@"")] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loadNewMessage) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}
- (void)reloadMessageHeader{
    [_timeline beginUpdates];
    [_timeline reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_timeline endUpdates];
}
@end
