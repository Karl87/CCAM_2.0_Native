//
//  CCEventViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/11.
//
//

#import "CCEventViewController.h"
#import "CCEvent.h"
#import "EventCell.h"
#import <MJRefresh/MJRefresh.h>
#import "KLWebViewController.h"
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>

#import "CCamRefreshHeader.h"

@interface CCEventViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) BOOL needUpdate;
@property (nonatomic,strong) NSMutableArray *events;
@property (nonatomic,strong) KLTableView *eventTable;

@end

@implementation CCEventViewController
- (void)reloadInfo{
    [_eventTable.mj_header beginRefreshing];
}
- (void)returnTopPosition{
    [_eventTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.needUpdate = YES;
    
    self.eventTable = [self returnTableViewWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)
                                               style:UITableViewStylePlain
                                      separatorStyle:UITableViewCellSeparatorStyleNone
                                     backgroundColor:CCamViewBackgroundColor
                                        contentInset:CCamScrollInset
                               scrollIndicatorInsets:CCamScrollInset
                                          parentView:self.view];

    [_eventTable setSeparatorColor:CCamViewBackgroundColor];
    
    CCamRefreshHeader *header = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshEvent)];
    header.stateLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _eventTable.mj_header = header;

    [self.eventTable setDelegate:self];
    [self.eventTable setDataSource:self];
    
    self.events = [NSMutableArray new];
    [self getLocalEventsInfo];

    UIBarButtonItem *test = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(testWeb)];
    [self.navigationItem setLeftBarButtonItem:test];
}
- (void)testWeb{
    KLWebViewController *detail = [[KLWebViewController alloc] init];
    detail.webURL = @"http://cc1.c-cam.cc:8001/index.php/Api_new/Index/test_interface.html";
    detail.hidesBottomBarWhenPushed = YES;
    
    id vc = nil;
    vc = detail;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self viewDidAppearRefreshData];
}
- (void)viewDidAppearRefreshData{
    if (!self.needUpdate) {
        return;
    }
    [_eventTable.mj_header beginRefreshing];
    self.needUpdate = NO;
}
- (void)getLocalEventsInfo{
    [_events removeAllObjects];
    NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CCEvent" inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *infos = [context executeFetchRequest:request error:&error];
    if ([infos count] == 0) {
        NSLog(@"本地无活动数据，需要联网同步数据");
        return;
    }else{
        NSLog(@"本地数据库读取%lu个活动",(unsigned long)infos.count);
    }
    
    [_events addObjectsFromArray:infos];
    [_eventTable reloadData];
}
- (void)refreshEvent{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"token" :token};
    [manager GET:CCamGetEventURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCEvent"];
        
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* eventDic = [receiveArray objectAtIndex:i];
            CCEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"CCEvent" inManagedObjectContext:context];
            [event initEventWith:eventDic];
            if (![context save:&error]) {
//                NSLog(@"角色%@保存失败",event.eventName);
            }
        }
        
        NSLog(@"%ld",(unsigned long)[_events count]);
        
        [self getLocalEventsInfo];
        [_eventTable.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [_eventTable.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.events.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.eventTable) {
        
        static NSString *identifier = @"EventCell";
        
        CCEvent* event = (CCEvent*)[self.events objectAtIndex:indexPath.row];
        
        EventCell *cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.event = event;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    static NSString *identifier = @"DefaultTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCEvent* event = (CCEvent*)[self.events objectAtIndex:indexPath.row];
    KLWebViewController *detail = [[KLWebViewController alloc] init];
    detail.webURL = event.eventURL;
    detail.vcTitle = event.eventName;
    detail.event = event;
    detail.hidesBottomBarWhenPushed = YES;
    
    id vc = nil;
    vc = detail;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    id event = [_events objectAtIndex:indexPath.row];
    return [_eventTable cellHeightForIndexPath:indexPath model:event keyPath:@"event" cellClass:[EventCell class] contentViewWidth:CCamViewWidth];
}

@end
