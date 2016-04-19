//
//  CCFollowerViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//

#import "CCFollowerViewController.h"
#import "FollowCell.h"
#import "CCUserViewController.h"
@interface CCFollowerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *follows;
@property (nonatomic,strong) UITableView *followTable;

@end

@implementation CCFollowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _follows = [NSMutableArray new];
    _followTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_followTable setDelegate: self];
    [_followTable setDataSource:self];
    [self.view addSubview:_followTable];
    if (self.hidesBottomBarWhenPushed) {
        [_followTable setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
        
    }else{
        [_followTable setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
        
    }
    [self loadFollowers];
}
- (void)loadFollowers{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"memberid":_userID,@"token":userToken};
    [manager POST:CCamGetFollowerURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        if (receiveArray && [receiveArray count]) {
            [_follows addObjectsFromArray:receiveArray];
            [_followTable reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_follows count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"followCell";
    FollowCell *cell = [[FollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![cell isKindOfClass:[FollowCell class]]) {
        return;
    }
    FollowCell * followCell = (FollowCell*)cell;
    NSDictionary *user = [_follows objectAtIndex:indexPath.row];
    followCell.user = user;
    followCell.parent = self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    userpage.userID = [[_follows objectAtIndex:indexPath.row] objectForKey:@"memberid"];
    userpage.vcTitle = [[_follows objectAtIndex:indexPath.row] objectForKey:@"name"];
    userpage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:userpage];
}
- (void)callOtherVC:(id)vc{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
