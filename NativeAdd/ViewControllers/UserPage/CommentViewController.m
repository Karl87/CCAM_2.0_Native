//
//  CommentViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//

#import "CommentViewController.h"
#import "MessageTextView.h"
#import "CommentCell.h"
#import "CCComment.h"
#import <MJRefresh/MJRefresh.h>
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Constants.h"
#import "AFHTTPSessionManager.h"
#import "CCamHelper.h"

@interface CommentViewController ()
@property (nonatomic, strong) UIWindow *pipWindow;
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,assign) BOOL noMoreData;
@property (nonatomic,strong) CCComment *topComment;
@end

@implementation CommentViewController

- (id)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}
- (void)textInputbarDidMove:(NSNotification *)note
{
    if (!_pipWindow) {
        return;
    }
    
    CGRect frame = self.pipWindow.frame;
    frame.origin.y = [note.userInfo[@"origin"] CGPointValue].y - 60.0;
    
    self.pipWindow.frame = frame;
}
- (void)togglePIPWindow:(id)sender
{
    if (!_pipWindow) {
        [self showPIPWindow:sender];
    }
    else {
        [self hidePIPWindow:sender];
    }
}

- (void)showPIPWindow:(id)sender
{
    CGRect frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60.0, 0.0, 50.0, 50.0);
    frame.origin.y = CGRectGetMinY(self.textInputbar.frame) - 60.0;
    
    _pipWindow = [[UIWindow alloc] initWithFrame:frame];
    _pipWindow.backgroundColor = [UIColor blackColor];
    _pipWindow.layer.cornerRadius = 10.0;
    _pipWindow.layer.masksToBounds = YES;
    _pipWindow.hidden = NO;
    _pipWindow.alpha = 0.0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_pipWindow];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _pipWindow.alpha = 1.0;
                     }];
}

- (void)hidePIPWindow:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _pipWindow.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         _pipWindow.hidden = YES;
                         _pipWindow = nil;
                     }];
}
- (void)commonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputbarDidMove:) name:SLKTextInputbarDidMoveNotification object:nil];
    
    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[MessageTextView class]];
    
#if DEBUG_CUSTOM_TYPING_INDICATOR
    // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
    [self registerClassForTypingIndicatorView:[TypingIndicatorView class]];
#endif
}
- (void)prepareTopComment{
    NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
    _topComment = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:context];
    _topComment.commentID = @"";
    _topComment.photoID = _timeline.timelineID;
    _topComment.userID = _timeline.timelineUserID;
    _topComment.userName = _timeline.timelineUserName;
    _topComment.dateline = _timeline.dateline;
    _topComment.replyID = @"";
    _topComment.userImage = _timeline.timelineUserImage;
    _topComment.comment = _timeline.timelineDes;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noMoreData = NO;
    
    if (![_timeline.timelineDes isEqualToString:@""]) {
        [self prepareTopComment];
    }
    
    _comments = [NSMutableArray new];
    // SLKTVC's configuration
    self.bounces = YES;
    self.shakeToClearEnabled = NO;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = YES;
    self.inverted = NO;
    
    [self.rightButton setTitle:Babel(@"发布") forState:UIControlStateNormal];
    [self.textView setPlaceholder:Babel(@"说点什么吧...")];
    self.textInputbar.autoHideRightButton = NO;
    self.textInputbar.maxCharCount = 140;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
#if !DEBUG_CUSTOM_TYPING_INDICATOR
    self.typingIndicatorView.canResignByTouch = YES;
#endif
    
//    MJRefreshNormalHeader *commentHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
//    commentHeader.automaticallyChangeAlpha = YES;
//    commentHeader.lastUpdatedTimeLabel.hidden = YES;
//    self.tableView.mj_header = commentHeader;
//    MJRefreshAutoNormalFooter *commentFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
//    commentFooter.automaticallyChangeAlpha = YES;
//    self.tableView.mj_footer = commentFooter;
    self.tableView.separatorColor = CCamViewBackgroundColor;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"commentCell"];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"topCommentCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"loadCommentCell"];

    [self loadComments];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                [_comments insertObject:commentObj atIndex:0];
            }
            [self.tableView reloadData];
        }
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:Babel(@"评论加载失败")];
        [hud hide:YES afterDelay:1.0];
        
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    }];
}
- (void)loadMoreComments{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"一大波评论正在赶来...";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    CCComment *lastComment = [_comments firstObject];
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
                [_comments insertObject:commentObj atIndex:0];
            }
            [hud hide:YES];
            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
        }else{
            [hud setMode:MBProgressHUDModeText];
            [hud setLabelText:Babel(@"已显示全部评论")];
            [hud hide:YES afterDelay:1.0];
            _noMoreData = YES;
            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];

//            [self.tableView.mj_footer endRefreshing];
//            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.tableView.mj_footer endRefreshing];
//        [self.tableView.mj_header endRefreshing];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if ([_timeline.timelineDes isEqualToString:@""]) {
            return 0;
        }
        return 1;
    }else if (section ==1){
        return 1;
    }else{
       return _comments.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"topCommentCell";
        CommentCell *cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else if (indexPath.section ==1){
        static NSString *identifier = @"loadCommentCell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:Babel(@"加载更多评论")];

        if (_noMoreData) {
            [cell.textLabel setText:Babel(@"已显示全部评论")];
        }
        return cell;
    }
    
    static NSString *identifier = @"commentCell";
    CommentCell *cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        CommentCell * commentCell = (CommentCell*)cell;
        commentCell.comment = _topComment;
        commentCell.parent = self;
        cell.transform = self.tableView.transform;
    }else if (indexPath.section ==1){
        
    }else{
        CommentCell * commentCell = (CommentCell*)cell;
        CCComment *comment = [_comments objectAtIndex:indexPath.row];
        commentCell.comment = comment;
        commentCell.parent = self;
        cell.transform = self.tableView.transform;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        return 44;
    }else if (indexPath.section ==0){
        return [self.tableView cellHeightForIndexPath:indexPath model:_topComment keyPath:@"comment" cellClass:[CommentCell class] contentViewWidth:CCamViewWidth];
    }
    
    id comment = [_comments objectAtIndex:indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[CommentCell class] contentViewWidth:CCamViewWidth];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 && _noMoreData == NO) {
        [self loadMoreComments];
    }
}
- (void)callOtherVC:(id)vc{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}


#pragma mark - UITextViewDelegate Methods

- (void)didPressRightButton:(id)sender{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *comment = [NSString stringWithFormat:@"%@",[self.textView.text copy]];
    NSDictionary *parameters = @{@"workid":_photoID,@"comment":comment,@"token":[[AuthorizeHelper sharedManager] getUserToken]};
    NSLog(@"%@",parameters);
    [manager POST:CCamSendCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
        CCComment *commentObj = [NSEntityDescription insertNewObjectForEntityForName:@"CCComment" inManagedObjectContext:context];
        commentObj.commentID = @"";
        commentObj.photoID = @"";
        commentObj.userID = [[AuthorizeHelper sharedManager] getUserID];
        commentObj.userName = [[AuthorizeHelper sharedManager] getUserName];
        commentObj.dateline = @"-1";
        commentObj.replyID = @"";
        commentObj.userImage = [[AuthorizeHelper sharedManager] getUserImage];
        commentObj.comment = comment;
        
        [_comments addObject:commentObj];
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_comments count]-1 inSection:2];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        int commentCount = [_timeline.commentCount intValue]+1;
        _timeline.commentCount = [NSString stringWithFormat:@"%d",commentCount];
        
        NSMutableArray *timelineComments = [NSMutableArray new];
        [timelineComments insertObject:commentObj atIndex:0];
        NSOrderedSet *timelineCommentSet = [_timeline.comments copy];
        for (CCComment * co in timelineCommentSet) {
            [timelineComments addObject:co];
        }
        [_timeline setComments:[[NSOrderedSet alloc] initWithArray:timelineComments]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:Babel(@"评论失败")];
        [hud hide:YES afterDelay:1.0];
    }];
    [self.textView refreshFirstResponder];
    [super didPressRightButton:sender];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

//- (BOOL)textView:(SLKTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
//}

//- (BOOL)textView:(SLKTextView *)textView shouldOfferFormattingForSymbol:(NSString *)symbol
//{
//    if ([symbol isEqualToString:@">"]) {
//        
//        NSRange selection = textView.selectedRange;
//        
//        // The Quote formatting only applies new paragraphs
//        if (selection.location == 0 && selection.length > 0) {
//            return YES;
//        }
//        
//        // or older paragraphs too
//        NSString *prevString = [textView.text substringWithRange:NSMakeRange(selection.location-1, 1)];
//        
//        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:[prevString characterAtIndex:0]]) {
//            return YES;
//        }
//        
//        return NO;
//    }
//    
//    return [super textView:textView shouldOfferFormattingForSymbol:symbol];
//}

//- (BOOL)textView:(SLKTextView *)textView shouldInsertSuffixForFormattingWithSymbol:(NSString *)symbol prefixRange:(NSRange)prefixRange
//{
//    if ([symbol isEqualToString:@">"]) {
//        return NO;
//    }
//    
//    return [super textView:textView shouldInsertSuffixForFormattingWithSymbol:symbol prefixRange:prefixRange];
//}


#pragma mark - Lifeterm

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

@end
