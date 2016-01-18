//
//  KLWebViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/23.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLWebViewController.h"

//#import "UIColor+FlatColors.h"
#import "VBFPopFlatButton.h"

@interface KLWebViewController () <UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) UIActivityIndicatorView *webLoading;
@property (nonatomic,strong) UIRefreshControl *refresh;
@property (nonatomic,strong) VBFPopFlatButton *backBtn;
@property (nonatomic,strong) VBFPopFlatButton *forwardBtn;
@property (nonatomic,strong) UIButton *topBtn;
@end

@implementation KLWebViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topBtn setBackgroundColor:[UIColor clearColor]];
    [_topBtn setFrame:CGRectMake(0, 0, CCamNavigationBarHeight - 20, CCamNavigationBarHeight - 20)];
    [_topBtn setCenter:CGPointMake(self.navigationController.navigationBar.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2)];
    [_topBtn addTarget:self action:@selector(webGoTop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_topBtn];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -CCamNavigationBarHeight, CCamViewWidth, CCamViewHeight+CCamNavigationBarHeight)];
    [_webView setBackgroundColor:CCamViewBackgroundColor];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    UIToolbar *toolBar  =[[ UIToolbar alloc] initWithFrame:CGRectMake(0, CCamViewHeight-CCamTabBarHeight, CCamViewWidth, CCamTabBarHeight)];
    if(iOS8){
        [toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * blur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blur setFrame:CGRectMake(0, 0, CCamViewWidth, CCamTabBarHeight)];
        [toolBar addSubview:blur];
    }else{
        [toolBar setBarTintColor:CCamBarTintColor];
    }
    [toolBar setTintColor:CCamGoldColor];
    [self.view addSubview:toolBar];
    
    UIBarButtonItem * refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(webRefresh)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    
    VBFPopFlatButton *backBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(CCamViewWidth/3 -15, 12, 30, 30) buttonType:buttonBackType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    backBtn.lineThickness = 2;
    [backBtn setTintColor:CCamGoldColor forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [backBtn setEnabled:NO];
    [backBtn addTarget:self
                action:@selector(webGoBack)
      forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:backBtn];
    self.backBtn = backBtn;
    
    VBFPopFlatButton *forwardBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(CCamViewWidth*2/3 - 15, 12, 30, 30) buttonType:buttonForwardType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    forwardBtn.lineThickness = 2;
    [forwardBtn setTintColor:CCamGoldColor forState:UIControlStateNormal];
    [forwardBtn setTintColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [forwardBtn setEnabled:NO];
    [forwardBtn addTarget:self
                action:@selector(webGoForward)
      forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:forwardBtn];
    self.forwardBtn = forwardBtn;

    UIActivityIndicatorView *webLoading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CCamViewWidth/2-15, 12, 30, 30)];
    [toolBar addSubview:webLoading];
    self.webLoading = webLoading;
    
    
    UIRefreshControl *refresh = [self returnUIRefreshControlWithTintColor:CCamGoldColor
                                                               initString:@" "
                                                                textColor:CCamGoldColor
                                                                 textFont:[UIFont systemFontOfSize:11.0]
                                                               parentView:nil
                                                                   action:@selector(webRefresh)];
    _refresh = refresh;
    [_webView.scrollView addSubview:_refresh];
    [_webView.scrollView setContentInset:UIEdgeInsetsMake(CCamNavigationBarHeight, 0, CCamTabBarHeight, 0)];
    [_webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(CCamNavigationBarHeight, 0, CCamTabBarHeight, 0)];
    [_webView.scrollView setDelegate:self];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self webProgressAnimationWithType:@"Over"];
}
- (void)webGoTop{
    NSLog(@"GoTop!");
    [_webView.scrollView setContentOffset:CGPointMake(0, -CCamNavigationBarHeight-CCamTabBarHeight-10) animated:YES];
}
- (void)webGoBack{
    NSLog(@"GoBack!");
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}
- (void)webGoForward{
    NSLog(@"GoForward!");
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}
- (void)webStopLoad{
    NSLog(@"StopLoad!");
    [_webView stopLoading];
}
- (void)webRefresh{
    NSLog(@"RefreshPage!");
    [_webView reload];
}
- (void)webRefreshAnimation{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         self.webView.scrollView.contentOffset = CGPointMake(0, -_refresh.frame.size.height-CCamNavigationBarHeight);
                     } completion:^(BOOL finished){
                         [_refresh beginRefreshing];
                         [_refresh sendActionsForControlEvents:UIControlEventValueChanged];
                     }];
}
- (void)webProgressAnimationWithType:(NSString*)type{
    if ([type isEqualToString:@"Start"]) {
//        [self.navigationController setSGProgressPercentage:arc4random()%(61)+20 andTintColor:CCamGoldColor];
    }else if ([type isEqualToString:@"Loading"]){
    
    }else if ([type isEqualToString:@"End"]){
//        [self.navigationController finishSGProgress];
    }else if ([type isEqualToString:@"Fail"]){
//        [self.navigationController cancelSGProgress];
    }else if ([type isEqualToString:@"Over"]){
    
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"Should Start Web");
//    [_webLoading startAnimating];
    [self manageWebControlButtons];

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"Start load web");
    [_webLoading startAnimating];
    [self setRefreshControlStateWithRefresh:_refresh andState:CCamUpdatingPage];
    [self manageWebControlButtons];
    [self webProgressAnimationWithType:@"Start"];
    [self showWebPageLoadingStatus];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"Load finish web");
    [_webLoading stopAnimating];
    [self setRefreshControlStateWithRefresh:_refresh andState:CCamUpdatePageSuccess];
    [self performSelector:@selector(refreshEndAnimation) withObject:nil afterDelay:1.0];
    [self manageWebControlButtons];
    [self webProgressAnimationWithType:@"End"];
    [self showWebPageLoadingStatus];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"Load error web");
    [_webLoading stopAnimating];
    [self setRefreshControlStateWithRefresh:_refresh andState:CCamUpdatePageFail];
    [self performSelector:@selector(refreshEndAnimation) withObject:nil afterDelay:1.0];
    [self manageWebControlButtons];
    [self webProgressAnimationWithType:@"Fail"];
    [self showWebPageLoadingStatus];
}
- (void)manageWebControlButtons{
    if ([_webView canGoForward]) {
        [self.forwardBtn setEnabled:YES];
    }else{
        [self.forwardBtn setEnabled:NO];
    }
    if ([_webView canGoBack]) {
        [self.backBtn setEnabled:YES];
    }else{
        [self.backBtn setEnabled:NO];
    }
}
- (NSString*)showWebPageLoadingStatus{
    if ([_webView isLoading]) {
        NSLog(@"OnLoading!");
        return @"OnLoading!";
    }else{
        NSLog(@"NotOnLoading!");
        return @"NotOnLoading!";
    }
    return @"Unknown";
}
#pragma mark - SetRefreshControl
- (void)setRefreshControlStateWithRefresh:(UIRefreshControl*)refresh andState:(NSString*)state{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:state attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                           CCamGoldColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0], NSFontAttributeName, nil]];
}
- (void)refreshEndAnimation{
    [_refresh endRefreshing];
}
#pragma mark - ScrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y<-10) {
        [self setRefreshControlStateWithRefresh:_refresh andState:CCamPullRefreshPage];
    }
}
@end
