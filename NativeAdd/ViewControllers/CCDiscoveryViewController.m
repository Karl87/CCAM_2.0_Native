//
//  CCDiscoveryViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCDiscoveryViewController.h"
#import "CCPhoto.h"

#import <MJRefresh/MJRefresh.h>
#import "TimelineCell.h"
#import "TimelineTopCell.h"

#import "CCTimeLine.h"

//test
#import "TestDetailViewController.h"
#import "lhScanQCodeViewController.h"
#import "KLNavigationController.h"

@interface CCDiscoveryViewController () <UICollectionViewDataSource,UICollectionViewDelegate,KLCollectionLayoutDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(assign) BOOL needUpdate;
@property(assign) BOOL loadingSelection;
@property(assign) BOOL loadingPopular;
@property(assign) BOOL loadingLast;

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

@implementation CCDiscoveryViewController
static NSString *const MJCollectionViewCellIdentifier = @"color";

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.needUpdate = YES;
    
    self.loadingSelection = NO;
    self.loadingPopular = NO;
    self.loadingLast = NO;
    
    NSArray* segArray = @[@"订阅",@"广场"];
    _segmegtItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamSegItemWidth*segArray.count, CCamSegItemHeight)];
    [_segmentView setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:_segmentView];
    
    for (int i = 0 ; i <segArray.count; i++) {
        UIButton *segButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segButton setFrame:CGRectMake(CCamSegItemWidth*i, 0, CCamSegItemWidth, CCamSegItemHeight)];
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
    
    _segmentSlider = [[UIView alloc] initWithFrame:CGRectMake(0, CCamSegItemHeight-CCamSegSliderHeight-5, CCamSegItemWidth, CCamSegSliderHeight)];
    [_segmentSlider setBackgroundColor:[UIColor clearColor]];
    UIView *segmentSlider = [[UIView alloc] initWithFrame:CGRectMake((CCamSegItemWidth-CCamSegSliderWidth)/2, 0, CCamSegSliderWidth, CCamSegSliderHeight)];
    [segmentSlider setBackgroundColor:[UIColor whiteColor]];
    [_segmentSlider addSubview:segmentSlider];
    [_segmentView addSubview:_segmentSlider];
    
    self.selectionPhotos = [[NSMutableArray alloc] initWithCapacity:0];
    self.popularPhotos = [[NSMutableArray alloc] initWithCapacity:0];
    self.lastPhotos = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.timeLines = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.selectionPhotos addObjectsFromArray:[[CoreDataHelper sharedManager] showStoreInfoWithEntity:@"CCSelectionPhoto"]];
    [self.popularPhotos addObjectsFromArray:[[CoreDataHelper sharedManager] showStoreInfoWithEntity:@"CCHotPhoto"]];
    [self.lastPhotos addObjectsFromArray:[[CoreDataHelper sharedManager] showStoreInfoWithEntity:@"CCNewPhoto"]];
    
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
    
    MJRefreshNormalHeader *selectHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshSelection)];
    selectHeader.automaticallyChangeAlpha = YES;
    selectHeader.lastUpdatedTimeLabel.hidden = YES;
    _selectionCollection.mj_header = selectHeader;
    MJRefreshNormalHeader *popularHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPopular)];
    popularHeader.automaticallyChangeAlpha = YES;
    popularHeader.lastUpdatedTimeLabel.hidden = YES;
    _popularCollection.mj_header = popularHeader;
    MJRefreshNormalHeader *lastHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshLast)];
    lastHeader.automaticallyChangeAlpha = YES;
    lastHeader.lastUpdatedTimeLabel.hidden = YES;
    _lastCollection.mj_header = lastHeader;
    
    MJRefreshAutoNormalFooter *selectFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSelection)];
    selectFooter.automaticallyChangeAlpha = YES;
    _selectionCollection.mj_footer = selectFooter;
    
    MJRefreshAutoNormalFooter *popluarFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePopular)];
    popluarFooter.automaticallyChangeAlpha = YES;
    _popularCollection.mj_footer = popluarFooter;
    
    MJRefreshAutoNormalFooter *lastFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreLast)];
    lastFooter.automaticallyChangeAlpha = YES;
    _lastCollection.mj_footer = lastFooter;
    
    MJRefreshNormalHeader *timelineHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTimeline)];
    timelineHeader.automaticallyChangeAlpha = YES;
    timelineHeader.lastUpdatedTimeLabel.hidden = YES;
    _timeline.mj_header = timelineHeader;
    
    MJRefreshAutoNormalFooter *timelineFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTimeline)];
    timelineFooter.automaticallyChangeAlpha = YES;
    _timeline.mj_footer = timelineFooter;

    _photoSegView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, CCamViewWidth, 44)];
    [_photoSegView setBackgroundColor:CCamViewBackgroundColor];
    [self.view addSubview:_photoSegView];
    
    NSArray *photoSegArray = @[@"精选",@"热门",@"最新"];
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
        UIView *divierBG = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x+photoSegWidth, 0, 1, 44)];
        [divierBG setBackgroundColor:[UIColor whiteColor]];
        [_photoSegView addSubview:divierBG];
        UIView *divier = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x+photoSegWidth, 12, 1, 20)];
        [divier setBackgroundColor:CCamPhotoSegLightGray];
        [_photoSegView addSubview:divier];
    }
    
    
    [self loadLocalTimeline];
}

- (void)loadTimeline{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = CCamTestToken;
    NSDictionary *parameters = @{@"token" :token};
    [manager GET:CCamGetTimeLineURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCTimeLine"];

        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"%ld",(unsigned long)receiveArray.count);
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* timelineDic = [receiveArray objectAtIndex:i];
            
            CCTimeLine *timeline =[NSEntityDescription insertNewObjectForEntityForName:@"CCTimeLine" inManagedObjectContext:context];
            [timeline initTimelineWith:timelineDic];
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = CCamTestToken;
    CCTimeLine *lastTimeline = (CCTimeLine*)[_timeLines lastObject];
    NSString *lastID = lastTimeline.timelineID;
    NSDictionary *parameters = @{@"token" :token,@"lastid":lastID};
    [manager GET:CCamGetTimeLineURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"%ld",(unsigned long)receiveArray.count);
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* timelineDic = [receiveArray objectAtIndex:i];
            
            CCTimeLine *timeline =[NSEntityDescription insertNewObjectForEntityForName:@"CCTimeLine" inManagedObjectContext:context];
            [timeline initTimelineWith:timelineDic];
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
        parameter = photo.workid;
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
                    parameter = [NSString stringWithFormat:@"%@%@",parameter,photoForHot.workid];
                }else{
                    parameter = [NSString stringWithFormat:@"%@%@,",parameter,photoForHot.workid];
                }
            }
        }
    }
    
    return parameter;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self viewDidAppearRefreshData];
}
- (void)viewDidAppearRefreshData{
    if (!self.needUpdate) {
        return;
    }
//    [_timeline.mj_header beginRefreshing];
    [_selectionCollection.mj_header beginRefreshing];
    [_popularCollection.mj_header beginRefreshing];
    [_lastCollection.mj_header beginRefreshing];
    
    self.needUpdate = NO;


    
}
//- (void)autonAnimationRefreshPhotosWithType:(NSString*)type{
//    if ([type isEqualToString:@"selection"]) {
//        if (!self.selectionCollection.refresh.refreshing) {
//            if (self.selectionCollection.contentOffset.y == -CCamNavigationBarHeight) {
//                [UIView animateWithDuration:0.25
//                                      delay:0
//                                    options:UIViewAnimationOptionBeginFromCurrentState
//                                 animations:^(void){
//                                     self.selectionCollection.contentOffset = CGPointMake(0, -self.selectionCollection.refresh.frame.size.height-CCamNavigationBarHeight);
//                                 } completion:^(BOOL finished){
//                                     [self.selectionCollection.refresh beginRefreshing];
//                                     [self.selectionCollection.refresh sendActionsForControlEvents:UIControlEventValueChanged];
//                                 }];
//                
//            }
//        }
//    }else if ([type isEqualToString:@"like"]){
//        if (!self.popularCollection.refresh.refreshing) {
//            if (self.popularCollection.contentOffset.y == -CCamNavigationBarHeight) {
//                [UIView animateWithDuration:0.25
//                                      delay:0
//                                    options:UIViewAnimationOptionBeginFromCurrentState
//                                 animations:^(void){
//                                     self.popularCollection.contentOffset = CGPointMake(0, -self.popularCollection.refresh.frame.size.height-CCamNavigationBarHeight);
//                                 } completion:^(BOOL finished){
//                                     [self.popularCollection.refresh beginRefreshing];
//                                     [self.popularCollection.refresh sendActionsForControlEvents:UIControlEventValueChanged];
//                                 }];
//                
//            }
//        }
//
//    }else if ([type isEqualToString:@""]){
//        if (!self.lastCollection.refresh.refreshing) {
//            if (self.lastCollection.contentOffset.y == -CCamNavigationBarHeight) {
//                [UIView animateWithDuration:0.25
//                                      delay:0
//                                    options:UIViewAnimationOptionBeginFromCurrentState
//                                 animations:^(void){
//                                     self.lastCollection.contentOffset = CGPointMake(0, -self.lastCollection.refresh.frame.size.height-CCamNavigationBarHeight);
//                                 } completion:^(BOOL finished){
//                                     [self.lastCollection.refresh beginRefreshing];
//                                     [self.lastCollection.refresh sendActionsForControlEvents:UIControlEventValueChanged];
//                                 }];
//                
//            }
//        }
//
//    }
//}
- (void)likePhoto:(id)sender{
    
    UIButton *likeButton = (UIButton*)sender;
    
    KLCollectionCell *collectionCell = (KLCollectionCell*)[[likeButton superview] superview];
    
   
    if ([collectionCell.photo.liked isEqualToString:@"1"]) {
        return;
    }
    
    [likeButton setTintColor:CCamRedColor];
    [collectionCell.likeButton setTitle:[NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue+1] forState:UIControlStateNormal];
    NSLog(@"%@",collectionCell.photo.name);
    collectionCell.photo.liked = @"1";
    collectionCell.photo.like = [NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue+1];
    
    NSDictionary *parameters = @{@"token":CCamTestToken,@"workid":collectionCell.photo.workid};
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
            [collectionCell.likeButton setTitle:[NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue-1] forState:UIControlStateNormal];
            collectionCell.photo.liked = @"0";
            collectionCell.photo.like = [NSString stringWithFormat:@"%d",collectionCell.photo.like.intValue-1];
        }else if ([likeResult isEqualToString:@"-2"]){
            NSLog(@"likephoto result is has been liked!");
        }else{
            NSLog(@"likephoto result is unknown!");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [likeButton setBackgroundImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        collectionCell.photo.liked = @"0";
    }];
    

}
- (void)loadDiscoveryWithRefresh:(BOOL)refresh order:(NSString*)order lastid:(NSString*)lastid lastlike:(NSString*)lastlike ids:(NSString*)ids{
    
    if ([order isEqualToString:@"selection"]) {
        if (self.loadingSelection) return;
        self.loadingSelection = YES;
        if (!refresh) {
//            [self.selectionLoading startAnimating];
        }
    }else if ([order isEqualToString:@"like"]){
        if (self.loadingPopular) return;
        self.loadingPopular = YES;
        if (!refresh) {
//            [self.popularLoading startAnimating];
        }
    }else{
        if (self.loadingLast) return;
        self.loadingLast = YES;
        if (!refresh) {
//            [self.lastLoading startAnimating];
        }
    }
    
    
    NSString *url;
    NSDictionary *parameters;
    
    if (refresh) {
        url = CCamGetDiscoveryURL;
        parameters = @{@"order":order,@"token":CCamTestToken};
    }else{
        url = CCamGetDiscoveryMoreURL;
        if ([order isEqualToString:@"like"]) {
            parameters = @{@"order":order,@"lastid":lastid,@"lastlike":lastlike,@"ids":ids,@"token":CCamTestToken};
        }else{
            parameters = @{@"order":order,@"lastid":lastid,@"token":CCamTestToken};
        }
    }
    
    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        
        if (![[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error] isKindOfClass:[NSArray class]]) {
            return ;
        }
        
        NSArray * receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        NSMutableArray *tempPhotos = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* photoDic = [receiveArray objectAtIndex:i];
            CCPhoto *photo = [[CCPhoto alloc] init];
            [photo initPhotoWithData:photoDic];
            [tempPhotos addObject:photo];
        }
        
        NSLog(@"Arrive photos count = %lu",(unsigned long)tempPhotos.count);
        
        if (refresh) {
            
            if ([order isEqualToString:@"selection"]) {
                [self.selectionPhotos removeAllObjects];
                [self.selectionPhotos addObjectsFromArray:tempPhotos];
                NSLog(@"### Selection photoes count = %lu",(unsigned long)self.selectionPhotos.count);
                [self.selectionCollection.mj_header endRefreshing];
                [self.selectionCollection reloadData];
                [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCSelectionPhoto"];
                [[CoreDataHelper sharedManager] insertCoreDataWithType:@"CCSelectionPhoto" andArray:self.selectionPhotos];
            }else if ([order isEqualToString:@"like"]){
                [self.popularPhotos removeAllObjects];
                [self.popularPhotos addObjectsFromArray:tempPhotos];
                NSLog(@"### Popular photoes count = %lu",(unsigned long)self.popularPhotos.count);
                [self.popularCollection.mj_header endRefreshing];
                [self.popularCollection reloadData];
                [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCHotPhoto"];
                [[CoreDataHelper sharedManager] insertCoreDataWithType:@"CCHotPhoto" andArray:self.popularPhotos];
            }else{
                [self.lastPhotos removeAllObjects];
                [self.lastPhotos addObjectsFromArray:tempPhotos];
                NSLog(@"### Lastest photoes count = %lu",(unsigned long)self.lastPhotos.count);
                [self.lastCollection.mj_header endRefreshing];
                [self.lastCollection reloadData];
                [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCNewPhoto"];
                [[CoreDataHelper sharedManager] insertCoreDataWithType:@"CCNewPhoto" andArray:self.lastPhotos];
            }
            
        }else{
            
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
        
        [self resetRequestStateWithType:order];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self resetRequestStateWithType:order];

    }];
}
- (void)resetRequestStateWithType:(NSString*)order{
    if ([order isEqualToString:@"selection"]) {
        self.loadingSelection = NO;
//        [self.selectionCollection.refresh endRefreshing];
//        [self.selectionLoading stopAnimating];
    }else if ([order isEqualToString:@"like"]){
        self.loadingPopular = NO;
//        [self.popularLoading stopAnimating];
//        [self.popularCollection.refresh endRefreshing];
    }else{
        self.loadingLast = NO;
//        [self.lastLoading stopAnimating];
//        [self.lastCollection.refresh endRefreshing];
    }
}
#pragma mark - CollectionView Delegate
- (CGFloat)collectionLayout:(KLCollectionLayout*)layout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath{
   
    if (layout == self.selectionLayout) {
        NSString * note = @"";
        CCPhoto * photo = (CCPhoto*)[self.selectionPhotos objectAtIndex:indexPath.row];
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
        CCPhoto * photo = (CCPhoto*)[self.popularPhotos objectAtIndex:indexPath.row];
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
        CCPhoto * photo = (CCPhoto*)[self.lastPhotos objectAtIndex:indexPath.row];
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
    CCPhoto*photo;
    
    if (collectionView == self.selectionCollection) {
        photo = (CCPhoto*)[self.selectionPhotos objectAtIndex:indexPath.row];
    }else if (collectionView == self.popularCollection){
        photo = (CCPhoto*)[self.popularPhotos objectAtIndex:indexPath.row];
    }else if (collectionView == self.lastCollection) {
        photo = (CCPhoto*)[self.lastPhotos objectAtIndex:indexPath.row];
    }
    
    cell.photo = photo;
    
    [cell setBackgroundColor:[UIColor whiteColor]];
//    [cell.layer setMasksToBounds:YES];
//    [cell.layer setCornerRadius:5.0];
    
    [cell.workImage setBackgroundColor:CCamViewBackgroundColor];
    [cell.workImage sd_setImageWithURL:[NSURL URLWithString:cell.photo.middle_img] placeholderImage:nil];
    [cell.workImage setContentMode:UIViewContentModeScaleAspectFit];
    
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:cell.photo.image_url] placeholderImage:nil];
    
    [cell.userName setText:cell.photo.name];
    [cell.userName setFont:[UIFont boldSystemFontOfSize:14.0]];
    [cell.userName setTextColor:CCamGrayTextColor];
    
    [cell.pictureNote setText:cell.photo.photoDescription];
    [cell.pictureNote setFont:[UIFont systemFontOfSize:11.0]];
    [cell.pictureNote setTextColor:CCamGrayTextColor];
    CGRect textRect = [cell.pictureNote.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
    [cell.pictureNote setFrame:CGRectMake(5, cell.frame.size.width + 22 +20, cell.frame.size.width-10, textRect.size.height)];
    
//    [cell.likeCount setText:cell.photo.like];
//    [cell.likeCount setFont:[UIFont systemFontOfSize:11.0]];
//    [cell.likeCount setTextColor:CCamGrayTextColor];
//    CGRect likeRect = [cell.likeCount.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
//    [cell.likeCount setFrame:CGRectMake(cell.frame.size.width-8-likeRect.size.width, cell.likeCount.frame.origin.y, likeRect.size.width, likeRect.size.height)];
    
    [cell.likeButton setTitle:cell.photo.like forState:UIControlStateNormal];
    [cell.likeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [cell.likeButton setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [cell.likeButton setImage:[[UIImage imageNamed:@"likeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
//    [cell.likeButton setFrame:CGRectMake(cell.likeButton.frame.origin.x - likeRect.size.width - 5, cell.likeButton.frame.origin.y, cell.likeButton.frame.size.width, cell.likeButton.frame.size.height)];
    
    if ([cell.photo.liked isEqualToString:@"1"]) {
        [cell.likeButton setTintColor:CCamRedColor];
    }else{
        [cell.likeButton setTintColor:CCamPhotoSegLightGray];
    }
    [cell.likeButton sizeToFit];
    [cell.likeButton setCenter:CGPointMake(cell.bounds.size.width-10-cell.likeButton.frame.size.width/2, cell.userName.center.y)];
    [cell.likeButton addTarget:self action:@selector(likePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CCPhoto*photo = [[CCPhoto alloc] init];
    
    if (collectionView == self.selectionCollection) {
        NSLog(@"Collection is selection");
        photo = [self.selectionPhotos objectAtIndex:indexPath.row];
      
    }else if (collectionView == self.popularCollection) {
        NSLog(@"Collection is hot");
        photo = [self.popularPhotos objectAtIndex:indexPath.row];
       
    }else if (collectionView == self.lastCollection){
        NSLog(@"Collection is new");
        photo = [self.lastPhotos objectAtIndex:indexPath.row];
        
    }
    NSLog(@"Choose item %ld",(long)indexPath.row);
    NSLog(@"username is %@",photo.workid);
    NSLog(@"username is %@",photo.name);
    NSLog(@"description is %@",photo.photoDescription);
    NSLog(@"like is %@",photo.like);
    NSLog(@"like status is %@",photo.liked);

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
    UIButton *button  = (UIButton*)sender;
    [self.photoBGView setContentOffset:CGPointMake(CCamViewWidth*button.tag, self.backgroundView.contentOffset.y) animated:NO];
}
- (void)homeSegItemOnClick:(id)sender{
    UIButton *button  = (UIButton*)sender;
    [self.backgroundView setContentOffset:CGPointMake(CCamViewWidth*button.tag, self.backgroundView.contentOffset.y) animated:NO];
}
#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_timeLines count]+1;//1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[_timeLines count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0){// && indexPath.row == 0) {
        static NSString *identifier = @"topCell";
        TimelineTopCell * cell = [[TimelineTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.message setText:@"您有3000条未读消息"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *identifier = @"timelineCell";
        TimelineCell *cell = [[TimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.profileImage setImage:[UIImage imageNamed:@"icon132"]];
        [cell.userName setText:@"角色相机"];
        [cell.photo setImage:[UIImage imageNamed:@"test.jpg"]];
        [cell.photoTitle setTitle:@"#角色相机#" forState:UIControlStateNormal];
        [cell.photoDes setText:@"我是一段描述"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CCTimeLine *timeLine = (CCTimeLine*)[_timeLines objectAtIndex:indexPath.row-1];
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:timeLine.timelineUserImage] placeholderImage:nil];
        [cell.userName setText:timeLine.timelineUserName];
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:timeLine.image_contest] placeholderImage:nil];
        [cell.photoDes setText:timeLine.timelineDes];
        
        return cell;
    }
    
    static NSString *identifier = @"DefaultTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell isKindOfClass:[TimelineCell class]]) {
//        TimelineCell *tCell = (TimelineCell*)cell;
//        CCTimeLine *timeLine = (CCTimeLine*)[_timeLines objectAtIndex:indexPath.row-1];
//        [tCell.profileImage sd_setImageWithURL:[NSURL URLWithString:timeLine.timelineUserImage] placeholderImage:nil];
//        [tCell.userName setText:timeLine.timelineUserName];
//        [tCell.photo sd_setImageWithURL:[NSURL URLWithString:timeLine.image_fullsize] placeholderImage:nil];
//        [tCell.photoDes setText:timeLine.timelineDes];
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//
//{
//    if (section == 0) {
//        return 0;
//    }else{
//        return 44;
//    }
//    
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.row == 0){//(indexPath.section==0&& indexPath.row == 0) {
        return 44;
    }else{
        return 154+30+CCamViewWidth+44;
    }
    
    return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    static NSString *identifier = @"header";
//    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
//
//    [view setFrame:CGRectMake(0, 0, CCamViewWidth, 44)];
//    
//    UIView *place = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 22, 22)];
//    [place setBackgroundColor:CCamRedColor];
//    [view addSubview:place];
//    
//    return view;
//}
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
//    view.tintColor = [UIColor clearColor];
//}
@end
