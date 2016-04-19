//
//  CCPhotoViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/20.
//
//

#import "CCPhotoViewController.h"
#import "TimelineCell.h"
#import "CCTimeLine.h"
#import "CCLike.h"
#import "CCComment.h"
#import "KLWebViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import "CCamRefreshHeader.h"

@interface CCPhotoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *timeline;
@property (nonatomic,strong) NSMutableArray *photos;
@end

@implementation CCPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _reloadIndexs = [NSMutableArray new];
    _photos = [NSMutableArray new];
    _timeline = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_timeline setDelegate:self];
    [_timeline setDataSource:self];
    [_timeline setBackgroundColor:CCamViewBackgroundColor];
    [_timeline setSeparatorColor:CCamViewBackgroundColor];
    if (self.hidesBottomBarWhenPushed) {
        [_timeline setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
    }else{
        [_timeline setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
    }
    [self.view addSubview:_timeline];
    CCamRefreshHeader *timelineHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(initPhotoPage)];
    timelineHeader.stateLabel.hidden = YES;
    timelineHeader.automaticallyChangeAlpha = YES;
    timelineHeader.lastUpdatedTimeLabel.hidden = YES;
    _timeline.mj_header = timelineHeader;
    [self initPhotoPage];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_reloadIndexs && [_reloadIndexs count]) {
        NSLog(@"*****%lu",(unsigned long)_reloadIndexs.count);
        [_timeline reloadRowsAtIndexPaths:_reloadIndexs withRowAnimation:UITableViewRowAnimationAutomatic];
        [_reloadIndexs removeAllObjects];
    }
}
- (void)initPhotoPage{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中...";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (!_photoID || [_photoID isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSLog(@"访问照片%@",_photoID);
    NSDictionary *parameters = @{@"id" :_photoID};
    [manager POST:CCamGetPhotoPageURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hide:YES];
        
        NSError *error;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSArray *receivePhotos =[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
    
        [_photos removeAllObjects];
        
        NSLog(@"当前用户有%ld张照片",[receivePhotos count]);
        if (!receivePhotos || ![receivePhotos count]) {
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
        [_timeline.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [_timeline.mj_header endRefreshing];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
