//
//  CCHomeVIewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/17.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCHomeViewController.h"
#import "KLNavigationController.h"
#import "TestViewController.h"
#import "KLWebViewController.h"

#import "lhScanQCodeViewController.h"

#import "CCEvent.h"
#import "CCSerie.h"

#import "NSString+KL.h"

@interface CCHomeViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(assign) BOOL needUpdate;

@property (nonatomic,strong) NSMutableArray *events;
@property (nonatomic,strong) NSMutableArray *series;

@property(nonatomic,strong) NSArray *eventList;
@property(nonatomic,strong) NSArray *serieList;

@property (nonatomic,strong) UIView *segmentView;
@property (nonatomic,strong) UIButton *eventButton;
@property (nonatomic,strong) UIButton *serieButton;
@property (nonatomic,strong) UIView *segmentSlider;

@end

@implementation CCHomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.needUpdate = YES;
    
    NSArray* segArray = @[@"Event",@"Serie"];
    
    _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 176, 44)];
    [_segmentView setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:_segmentView];
    
    _eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eventButton setFrame:CGRectMake(0, 0, 88, 44)];
    [_eventButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.]];
    [_eventButton setTitle:[segArray objectAtIndex:0] forState:UIControlStateNormal];
    [_eventButton setTitleColor:CCamGoldColor forState:UIControlStateNormal];
    [_eventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_eventButton setBackgroundColor:[UIColor clearColor]];
    [_eventButton addTarget:self action:@selector(eventBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_segmentView addSubview:_eventButton];
    
    _serieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_serieButton setFrame:CGRectMake(88, 0, 88, 44)];
    [_serieButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.]];
    [_serieButton setTitle:[segArray objectAtIndex:1] forState:UIControlStateNormal];
    [_serieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_serieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_serieButton setBackgroundColor:[UIColor clearColor]];
    [_serieButton addTarget:self action:@selector(serieBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_segmentView addSubview:_serieButton];

    _segmentSlider = [[UIView alloc] initWithFrame:CGRectMake(0, 41, 88, 3)];
    [_segmentSlider setBackgroundColor:[UIColor clearColor]];
    UIView *segmentSlider = [[UIView alloc] initWithFrame:CGRectMake(11, 0, 66, 3)];
    [segmentSlider setBackgroundColor:CCamGoldColor];
    [_segmentSlider addSubview:segmentSlider];
    [_segmentView addSubview:_segmentSlider];
    
    UIBarButtonItem * scanBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(callQRScan)];
    self.navigationItem.rightBarButtonItem = scanBtn;
    
    UIBarButtonItem *quitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(leaveNativeHome)];
    self.navigationItem.leftBarButtonItem = quitBtn;
    
    self.backgroundView = [self returnScrollViewWithFrame:CGRectMake(0, -CCamNavigationBarHeight, CCamViewWidth, CCamViewHeight+CCamNavigationBarHeight-10)
                                              contentSize:CGSizeMake(2*CCamViewWidth, 0)
                                               pageEnable:YES
                                                  bounces:NO
                                          backgroundColor:CCamViewBackgroundColor
                                               parentView:self.view];
    [self.backgroundView setShowsHorizontalScrollIndicator:NO];
    [self.backgroundView setDelegate:self];
    
    
    self.serieTable = [self returnTableViewWithFrame:CGRectMake(CCamViewWidth, 0, CCamViewWidth, CCamViewHeight)
                                               style:UITableViewStylePlain
                                      separatorStyle:UITableViewCellSeparatorStyleNone
                                     backgroundColor:CCamViewBackgroundColor
                                        contentInset:CCamScrollInset
                               scrollIndicatorInsets:CCamScrollInset
                                          parentView:self.backgroundView];
    
    self.eventTable = [self returnTableViewWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)
                                               style:UITableViewStylePlain
                                      separatorStyle:UITableViewCellSeparatorStyleNone
                                     backgroundColor:CCamViewBackgroundColor
                                        contentInset:CCamScrollInset
                               scrollIndicatorInsets:CCamScrollInset
                                          parentView:self.backgroundView];
    
//    self.serieTable.refresh = [self returnUIRefreshControlWithTintColor:CCamGoldColor
//                                                             initString:@" "
//                                                              textColor:CCamGoldColor
//                                                               textFont:[UIFont systemFontOfSize:11.0]
//                                                             parentView:self.serieTable
//                                                                 action:@selector(refreshSerie)];
//    
//    self.eventTable.refresh = [self returnUIRefreshControlWithTintColor:CCamGoldColor
//                                                       initString:@" "
//                                                        textColor:CCamGoldColor
//                                                         textFont:[UIFont systemFontOfSize:11.0]
//                                                       parentView:self.eventTable
//                                                           action:@selector(refreshEvent)];
    
    
    [self.eventTable setDelegate:self];
    [self.eventTable setDataSource:self];
    [self.serieTable setDelegate:self];
    [self.serieTable setDataSource:self];
    
    self.events = [[NSMutableArray alloc] initWithCapacity:0];
    self.series = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.events addObjectsFromArray:[[CoreDataHelper sharedManager] showStoreInfoWithEntity:@"CCEvent"]];
    
    [self.series addObjectsFromArray:[[CoreDataHelper sharedManager] showStoreInfoWithEntity:@"CCSerie"]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self viewDidAppearRefreshData];
}
#pragma mark - RefreshControl Methods

- (void)viewDidAppearRefreshData{
    
    if (!self.needUpdate) {
        return;
    }
    
//    if (!self.eventTable.refresh.refreshing) {
//        if (self.eventTable.contentOffset.y == -CCamNavigationBarHeight) {
//            [UIView animateWithDuration:0.25
//                                  delay:0
//                                options:UIViewAnimationOptionBeginFromCurrentState
//                             animations:^(void){
//                                 self.eventTable.contentOffset = CGPointMake(0, -self.eventTable.refresh.frame.size.height-CCamNavigationBarHeight);
//                             } completion:^(BOOL finished){
//                                 [self.eventTable.refresh beginRefreshing];
//                                 [self.eventTable.refresh sendActionsForControlEvents:UIControlEventValueChanged];
//                             }];
//
//        }
//    }
//    if (!self.serieTable.refresh.refreshing) {
//        if (self.serieTable.contentOffset.y ==-CCamNavigationBarHeight) {
//            [UIView animateWithDuration:0.25
//                                  delay:0
//                                options:UIViewAnimationOptionBeginFromCurrentState
//                             animations:^(void){
//                                 self.serieTable.contentOffset = CGPointMake(0, -self.serieTable.refresh.frame.size.height-CCamNavigationBarHeight);
//                             } completion:^(BOOL finished){
//                                 [self.serieTable.refresh beginRefreshing];
//                                 [self.serieTable.refresh sendActionsForControlEvents:UIControlEventValueChanged];
//                             }];
//            
//        }
//    }
    self.needUpdate = NO;
}

- (void)refreshSerie{
    
    [self setRefreshControlStateWithRefresh:self.serieTable.refresh andState:CCamUpdating];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"token" :token};
    
    [manager GET:CCamGetSerieURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSMutableArray * tempSeries = [[NSMutableArray alloc] initWithCapacity:0];
        [self.series removeAllObjects];
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* serieDic = [receiveArray objectAtIndex:i];
            CCSerie *serie = [[CCSerie alloc] init];
            [serie initSerieWith:serieDic];
            [tempSeries addObject:serie];
        }
        [self.series addObjectsFromArray:tempSeries];
        [self.serieTable reloadData];
        
        [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCSerie"];
        
        [[CoreDataHelper sharedManager] insertCoreDataWithType:@"CCSerie" andArray:tempSeries];
        
        receiveArray = nil;
        [tempSeries removeAllObjects];
        tempSeries = nil;
        
        [self setRefreshControlStateWithRefresh:self.serieTable.refresh andState:CCamUpdateSuccess];
        [self performSelector:@selector(serieRefreshEndAnimation) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setRefreshControlStateWithRefresh:self.serieTable.refresh andState:CCamUpdateFail];
        [self performSelector:@selector(serieRefreshEndAnimation) withObject:nil afterDelay:0.5];
    }];
}
- (void)refreshEvent{
    
    [self setRefreshControlStateWithRefresh:self.eventTable.refresh andState:CCamUpdating];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"token" :token};
    [manager GET:CCamGetEventURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSMutableArray * tempEvents = [[NSMutableArray alloc] initWithCapacity:0];
        [self.events removeAllObjects];
        
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* eventDic = [receiveArray objectAtIndex:i];
            CCEvent *event = [[CCEvent alloc] init];
            [event initEventWithData:eventDic];
            [tempEvents addObject:event];
        }
        [self.events addObjectsFromArray:tempEvents];
        [self.eventTable reloadData];
        
        [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCEvent"];
        
        [[CoreDataHelper sharedManager] insertCoreDataWithType:@"CCEvent" andArray:tempEvents];
        
        receiveArray = nil;
        [tempEvents removeAllObjects];
        tempEvents = nil;
        
        [self setRefreshControlStateWithRefresh:self.eventTable.refresh andState:CCamUpdateSuccess];
        [self performSelector:@selector(eventRefreshEndAnimation) withObject:nil afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self setRefreshControlStateWithRefresh:self.eventTable.refresh andState:CCamUpdateFail];
        [self performSelector:@selector(eventRefreshEndAnimation) withObject:nil afterDelay:0.5];
    }];
}
- (void)refreshFinish{
    [self.eventTable.refresh endRefreshing];
    [self.serieTable.refresh endRefreshing];
}
- (void)refreshFinishWith:(UIRefreshControl*)refresh{
    
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.eventTable) {
        return self.events.count;
    }else if (tableView == self.serieTable){
        return self.series.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.eventTable) {
        
        static NSString *identifier = @"HomeEventCell";
        
        CCEvent* event = (CCEvent*)[self.events objectAtIndex:indexPath.row];

        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

        UIImageView *cellBackground = [[UIImageView alloc] initWithFrame:cell.frame];
        [cellBackground sd_setImageWithURL:[NSURL URLWithString:event.eventImageURLCn] placeholderImage:[[UIImage alloc] init]];
        [cell setBackgroundView:cellBackground];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    
    }else if (tableView == self.serieTable){
    
        static NSString *identifier = @"HomeSerieCell";
        
        CCSerie* serie = (CCSerie*)[self.series objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView *cellBackground = [[UIImageView alloc] initWithFrame:cell.frame];
        [cellBackground sd_setImageWithURL:[NSURL URLWithString:[serie.image_List stringAddHost]] placeholderImage:[[UIImage alloc] init]];
        
        [cell setBackgroundView:cellBackground];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    
    }
    
    static NSString *identifier = @"DefaultTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id vc = nil;

    if (tableView == self.eventTable) {
        KLWebViewController *detail = [[KLWebViewController alloc] init];
        CCEvent * event = (CCEvent*)[self.events objectAtIndex:indexPath.row];
        detail.webURL = event.eventURL;
        detail.hidesBottomBarWhenPushed = YES;
        vc = detail;
    }else if (tableView == self.serieTable) {
        
    }
    
    
    if (vc != nil) {
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        self.navigationItem.backBarButtonItem=backItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (tableView == self.eventTable) {
        return CCamViewWidth*285/640;
    }else if (tableView == self.serieTable){
        return CCamViewWidth*150/640;
    }
    return 44;
}

#pragma mark - ScrollView Delegate 
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y<-10) {
        if (self.backgroundView.contentOffset.x == 0) {
            [self setRefreshControlStateWithRefresh:self.eventTable.refresh andState:CCamPullUpdate];
        }else{
            [self setRefreshControlStateWithRefresh:self.serieTable.refresh andState:CCamPullUpdate];
        }
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.backgroundView) {

        [_segmentSlider setFrame:CGRectMake(scrollView.contentOffset.x * _segmentView.frame.size.width /scrollView.contentSize.width, _segmentSlider.frame.origin.y, _segmentSlider.frame.size.width, _segmentSlider.frame.size.height)];
        [self setSegmentApprenceWithOffset:scrollView.contentOffset.x];
    }
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//
//{
//    if (scrollView == self.backgroundView){
//        [self setSegmentApprenceWithOffset:scrollView.contentOffset.x];
//    }
//}
- (void)setSegmentApprenceWithOffset:(CGFloat)offset{
    
    if (offset == 0) {
        [_eventButton setTitleColor:CCamGoldColor forState:UIControlStateNormal];
        [_eventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_serieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_serieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }else if (offset == CCamViewWidth){
        [_eventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_eventButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_serieButton setTitleColor:CCamGoldColor forState:UIControlStateNormal];
        [_serieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
}
#pragma mark - SetSegmentControl
- (void)eventBtnOnClick {
    [self.backgroundView setContentOffset:CGPointMake(0, self.backgroundView.contentOffset.y) animated:YES];
}
- (void)serieBtnOnClick {
    [self.backgroundView setContentOffset:CGPointMake(CCamViewWidth, self.backgroundView.contentOffset.y) animated:YES];
}
#pragma mark - SetRefreshControl
- (void)setRefreshControlStateWithRefresh:(UIRefreshControl*)refresh andState:(NSString*)state{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:state attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                           CCamGoldColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0], NSFontAttributeName, nil]];
}
- (void)serieRefreshEndAnimation{
    [self.serieTable.refresh endRefreshing];
}
- (void)eventRefreshEndAnimation{
    [self.eventTable.refresh endRefreshing];
}
#pragma mark - Call QR 
- (void)callQRScan{
    lhScanQCodeViewController * sqVC = [[lhScanQCodeViewController alloc]init];
    sqVC.setNavigationBar =YES;
    KLNavigationController * nVC = [[KLNavigationController alloc]initWithRootViewController:sqVC];
    [self presentViewController:nVC animated:YES completion:^{
        
    }];
}
#pragma mark - view
- (void)leaveNativeHome{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
