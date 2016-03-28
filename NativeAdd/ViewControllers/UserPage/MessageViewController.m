//
//  MessageViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/26.
//
//

#import "MessageViewController.h"
#import "CCMessage.h"
#import "MessageCell.h"
#import <MJRefresh/MJRefresh.h>
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "CCUserViewController.h"
#import "KLWebViewController.h"
#import "CCPhotoViewController.h"

#import "CCamRefreshFooter.h"
#import "CCamRefreshHeader.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *messages;
@property (nonatomic,strong) UITableView *message;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messages = [NSMutableArray new];
    
    _message = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_message];
    [_message setBackgroundColor:CCamViewBackgroundColor];
    [_message setDataSource:self];
    [_message setDelegate:self];
    [_message setSeparatorColor:CCamViewBackgroundColor];
    [_message registerClass:[MessageCell class] forCellReuseIdentifier:@"messageCell"];
    if (self.hidesBottomBarWhenPushed) {
        [_message setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
        
    }else{
        [_message setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
        
    }
    CCamRefreshHeader *messageHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAllMessage)];
    messageHeader.automaticallyChangeAlpha = YES;
    messageHeader.lastUpdatedTimeLabel.hidden = YES;
    messageHeader.stateLabel.hidden = YES;
    _message.mj_header = messageHeader;
    CCamRefreshFooter *messageFooter = [CCamRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage)];
    messageFooter.automaticallyChangeAlpha = YES;
    messageFooter.automaticallyHidden = YES;
    messageFooter.refreshingTitleHidden = YES;
    messageFooter.stateLabel.hidden = YES;
//    [messageFooter setTitle:@"更多消息" forState:MJRefreshStateIdle];
//    [messageFooter setTitle:@"一大波消息正在赶来" forState:MJRefreshStateRefreshing];
//    [messageFooter setTitle:@"亲，没有更多消息了" forState:MJRefreshStateNoMoreData];
    _message.mj_footer = messageFooter;
    
    
    
   
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_showLastest) {
        [self loadUnreadMessage];
    }else{
        [self loadAllMessage];
    }
}
- (void)loadUnreadMessage{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"token":[[AuthorizeHelper sharedManager] getUserToken],@"ifread":@"0"};
    [manager POST:CCamGetUserMessageURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [_messages removeAllObjects];
        
        NSError *error;
        NSArray *receiveAry =[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (!receiveAry || ![receiveAry count]) {
            [self loadAllMessage];
            [_message.mj_header endRefreshing];
            return ;
        }
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];

        for (int i = 0; i<receiveAry.count; i++) {
            NSDictionary *messageDic = [receiveAry objectAtIndex:i];
            CCMessage *message = [NSEntityDescription insertNewObjectForEntityForName:@"CCMessage" inManagedObjectContext:context];
            [message initMessageWith:messageDic];
            [_messages addObject:message];
            
            NSLog(@"ID：%@",message.messageID);
            NSLog(@"--- 类型：%@",message.messageType);
        }
        [_message reloadData];
        [_message.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_message.mj_header endRefreshing];

    }];

}
- (void)loadAllMessage{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"token":[[AuthorizeHelper sharedManager] getUserToken]};
    [manager POST:CCamGetUserMessageURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [_messages removeAllObjects];
        
        NSError *error;
        NSArray *receiveAry =[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (!receiveAry || ![receiveAry count]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = Babel(@"您还没有收到过消息");
            [hud hide:YES afterDelay:2.0];
            [_message.mj_header endRefreshing];
            return ;
        }
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        
        for (int i = 0; i<receiveAry.count; i++) {
            NSDictionary *messageDic = [receiveAry objectAtIndex:i];
            CCMessage *message = [NSEntityDescription insertNewObjectForEntityForName:@"CCMessage" inManagedObjectContext:context];
            [message initMessageWith:messageDic];
            [_messages addObject:message];
            
        }
        [_message reloadData];
        [_message.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_message.mj_header endRefreshing];
        
    }];
}
- (void)loadMoreMessage{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (_messages.count == 0) {
        return;
    }
    
    CCMessage *lastMessage =(CCMessage *)[_messages lastObject];
    NSString *lastID = lastMessage.messageID;
    NSDictionary *parameters = @{@"token":[[AuthorizeHelper sharedManager] getUserToken],@"lastid":lastID};
    [manager POST:CCamGetMoreUserMessageURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        NSError *error;
        NSArray *receiveAry =[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (!receiveAry || ![receiveAry count]) {
            [_message.mj_footer endRefreshing];
            [_message.mj_footer setState:MJRefreshStateNoMoreData];
            return ;
        }
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        
        for (int i = 0; i<receiveAry.count; i++) {
            NSDictionary *messageDic = [receiveAry objectAtIndex:i];
            CCMessage *message = [NSEntityDescription insertNewObjectForEntityForName:@"CCMessage" inManagedObjectContext:context];
            [message initMessageWith:messageDic];
            [_messages addObject:message];
        }
        [_message reloadData];
        [_message.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_message.mj_footer endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messages.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"messageCell";
    MessageCell *cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![cell isKindOfClass:[MessageCell class]]) {
        return;
    }
    MessageCell * messageCell = (MessageCell*)cell;
    CCMessage *message = [_messages objectAtIndex:indexPath.row];
    messageCell.message = message;
    messageCell.parent = self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id message = [_messages objectAtIndex:indexPath.row];
    return [_message cellHeightForIndexPath:indexPath model:message keyPath:@"message" cellClass:[MessageCell class] contentViewWidth:CCamViewWidth];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //修改
    CCMessage *message = [_messages objectAtIndex:indexPath.row];
    if ([message.messageType isEqualToString:@"4"]) {
        KLWebViewController *detail = [[KLWebViewController alloc] init];
        detail.webURL = [NSString stringWithFormat:@"http://www.c-cam.cc/index.php/First/Contest/rule/contestid/%@/app/1.html",message.contestID];
        detail.vcTitle = Babel(@"活动详情");
        detail.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        self.navigationItem.backBarButtonItem=backItem;
        [self.navigationController pushViewController:detail animated:YES];
        return;
    }else if ([message.messageType isEqualToString:@"6"]){
        if (![message.messageURL isEqualToString:@""]) {
            KLWebViewController *detail = [[KLWebViewController alloc] init];
            detail.webURL = message.messageURL;
            detail.vcTitle = @"";
            detail.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
            backItem.title=@"";
            self.navigationItem.backBarButtonItem=backItem;
            [self.navigationController pushViewController:detail animated:YES];
            return;
        }
    }
    CCPhotoViewController *photoView = [[CCPhotoViewController alloc] init];
    photoView.photoID = message.photoID;
    photoView.vcTitle = Babel(@"照片详情");
    photoView.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:photoView animated:YES];
    return;
}
- (void)callOtherVC:(id)vc{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
