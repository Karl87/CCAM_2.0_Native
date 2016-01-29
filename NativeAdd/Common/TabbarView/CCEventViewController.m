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

@interface CCEventViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) BOOL needUpdate;
@property (nonatomic,strong) NSMutableArray *events;
@property (nonatomic,strong) KLTableView *eventTable;

@end

@implementation CCEventViewController

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

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshEvent)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _eventTable.refresh = header;
    _eventTable.mj_header = _eventTable.refresh;

    [self.eventTable setDelegate:self];
    [self.eventTable setDataSource:self];
    
    self.events = [[NSMutableArray alloc] initWithCapacity:0];
    [self.events addObjectsFromArray:[[CoreDataHelper sharedManager] showStoreInfoWithEntity:@"CCEvent"]];
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
- (void)refreshEvent{
    
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
        
        NSLog(@"%ld",(unsigned long)[_events count]);
        
        [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCEvent"];
        [[CoreDataHelper sharedManager] insertCoreDataWithType:@"CCEvent" andArray:tempEvents];
        
        receiveArray = nil;
        [tempEvents removeAllObjects];
        tempEvents = nil;
        
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
        
        
        [cell.eventImage sd_setImageWithURL:[NSURL URLWithString:event.eventImageURLCn] placeholderImage:[[UIImage alloc] init]];

        [cell.eventTitle setTitle:[NSString stringWithFormat:@"  # %@ #    ",event.eventName] forState:UIControlStateNormal];
        [cell.eventTitle sizeToFit];
        [cell.eventTitle setCenter:CGPointMake(cell.eventTitle.frame.size.width/2+5, cell.eventImage.frame.size.height+5+cell.eventTitle.frame.size.height/2)];
        
        [cell.eventPicNum setTitle:@"2016" forState:UIControlStateNormal];
        [cell.eventPicNum sizeToFit];
        [cell.eventPicNum setCenter:CGPointMake(cell.bounds.size.width-15-cell.eventPicNum.bounds.size.width/2, cell.eventImage.frame.size.height+5+cell.eventPicNum.frame.size.height/2)];
        
        [cell.eventDescriptrion setText:@"奖品拉杆箱，倒计时10天"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    static NSString *identifier = @"DefaultTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return (CCamViewWidth-10)*285/640+50;
}

@end
