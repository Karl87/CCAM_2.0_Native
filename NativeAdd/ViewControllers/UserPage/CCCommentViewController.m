//
//  CCCommentViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//

#define CellReuseIdentifier @"commentCell"

#import "CCCommentViewController.h"
#import "CommentCell.h"
#import "CCComment.h"
#import <MJRefresh/MJRefresh.h>
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface CCCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView* commentsTable;
@property (nonatomic,strong)NSMutableArray *comments;
@end

@implementation CCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _comments = [NSMutableArray new];
    
    _commentsTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_commentsTable setBackgroundColor:[UIColor clearColor]];
    [_commentsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_commentsTable setDelegate: self];
    [_commentsTable setDataSource:self];
    [self.view addSubview:_commentsTable];
    [_commentsTable registerClass:[CommentCell class] forCellReuseIdentifier:CellReuseIdentifier];
    if (self.hidesBottomBarWhenPushed) {
        [_commentsTable setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
        
    }else{
        [_commentsTable setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
        
    }
    MJRefreshNormalHeader *commentHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadComments)];
    commentHeader.automaticallyChangeAlpha = YES;
    commentHeader.lastUpdatedTimeLabel.hidden = YES;
    _commentsTable.mj_header = commentHeader;
    MJRefreshAutoNormalFooter *commentFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    commentFooter.automaticallyChangeAlpha = YES;
    _commentsTable.mj_footer = commentFooter;
    [self loadComments];
}
- (void)loadComments{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"workid":_photoID};
    [manager POST:CCamGetCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        [_comments removeAllObjects];
        if (receiveArray && [receiveArray count]) {
             NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
            for (int i = 0; i < receiveArray.count; i++) {
                NSDictionary* commentDic = [receiveArray objectAtIndex:i];
                CCComment *commentObj = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:context];
                [commentObj initCommentWith:commentDic];
                [_comments addObject:commentObj];
            }
            [_commentsTable reloadData];
        }
        [_commentsTable.mj_header endRefreshing];
        [_commentsTable.mj_footer setState:MJRefreshStateIdle];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"评论加载失败"];
        [hud hide:YES afterDelay:1.0];
        
        [_commentsTable.mj_header endRefreshing];
        [_commentsTable.mj_footer setState:MJRefreshStateIdle];
    }];
}
- (void)loadMoreComments{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    CCComment *lastComment = [_comments lastObject];
    NSDictionary *parameters = @{@"workid":_photoID,@"lastid":lastComment.commentID};
    NSLog(@"%@",parameters);
    [manager POST:CCamGetCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (receiveArray && [receiveArray count]) {
            NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
            for (int i = 0; i < receiveArray.count; i++) {
                NSDictionary* commentDic = [receiveArray objectAtIndex:i];
                CCComment *commentObj = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:context];
                [commentObj initCommentWith:commentDic];
                [_comments addObject:commentObj];
            }
            [_commentsTable reloadData];
            [_commentsTable.mj_footer endRefreshing];
        }else{
            [_commentsTable.mj_footer endRefreshing];
            [_commentsTable.mj_footer setState:MJRefreshStateNoMoreData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_commentsTable.mj_footer endRefreshing];
    }];
}
- (void)sendComment{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _comments.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = CellReuseIdentifier;
    CommentCell *cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![cell isKindOfClass:[CommentCell class]]) {
        return;
    }
    CommentCell * commentCell = (CommentCell*)cell;
    CCComment *comment = [_comments objectAtIndex:indexPath.row];
    commentCell.comment = comment;
    commentCell.parent = self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id comment = [_comments objectAtIndex:indexPath.row];
    return [_commentsTable cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[CommentCell class] contentViewWidth:CCamViewWidth];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CCUserViewController *userpage = [[CCUserViewController alloc] init];
//    userpage.userID = [[_follows objectAtIndex:indexPath.row] objectForKey:@"memberid"];
//    userpage.vcTitle = [[_follows objectAtIndex:indexPath.row] objectForKey:@"name"];
//    userpage.hidesBottomBarWhenPushed = YES;
//    [self callOtherVC:userpage];
}
- (void)callOtherVC:(id)vc{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
