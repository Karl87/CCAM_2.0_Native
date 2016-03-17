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
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshEvent)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _eventTable.refresh = header;
    _eventTable.mj_header = _eventTable.refresh;

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
        [_eventTable.refresh endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [_eventTable.refresh endRefreshing];
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
        
        [cell.eventImage setContentMode:UIViewContentModeScaleAspectFit];
        [cell.eventImage sd_setImageWithURL:[NSURL URLWithString:event.eventImageURLCn] placeholderImage:[[UIImage alloc] init]];

        [cell.eventTitle setTitle:[NSString stringWithFormat:@"  # %@ #    ",event.eventName] forState:UIControlStateNormal];
        [cell.eventTitle sizeToFit];
        [cell.eventTitle setCenter:CGPointMake(cell.eventTitle.frame.size.width/2+5, cell.eventImage.frame.size.height+5+cell.eventTitle.frame.size.height/2)];
        
        [cell.eventPicNum setTitle:event.eventCount forState:UIControlStateNormal];
        [cell.eventPicNum sizeToFit];
        [cell.eventPicNum setCenter:CGPointMake(cell.bounds.size.width-15-cell.eventPicNum.bounds.size.width/2, cell.eventImage.frame.size.height+5+cell.eventPicNum.frame.size.height/2)];
        
        [cell.eventDescriptrion setText:event.eventDescription];
        
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
    return (CCamViewWidth-10)*285/640+50;
}

@end
