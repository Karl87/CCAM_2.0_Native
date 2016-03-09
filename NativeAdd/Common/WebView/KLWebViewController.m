//
//  KLWebViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/23.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLWebViewController.h"

#import "VBFPopFlatButton.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "CCamHelper.h"
#import "HXEasyCustomShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "CCPhotoViewController.h"
//#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "WebViewJavascriptBridge.h"

@interface KLWebViewController () <UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) UIActivityIndicatorView *webLoading;
@property (nonatomic,strong) UIRefreshControl *refresh;
@property (nonatomic,strong) VBFPopFlatButton *backBtn;
@property (nonatomic,strong) VBFPopFlatButton *forwardBtn;
@property (nonatomic,strong) UIButton *topBtn;

@property (nonatomic,strong) UIAlertView *openCameraAlert;

@property (nonatomic,strong) WebViewJavascriptBridge *bridge;
@end

@implementation KLWebViewController

- (void)webOpenCameraWithContestInfo:(id)info{
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        return;
    }
    
    NSString *serieid = @"";
    NSString *matchid = @"";
//    NSString *openType = @"";
    if([info isKindOfClass:[NSMutableDictionary class]]){
        NSLog(@"contestid:%@",[info objectForKey:@"contestid"]);
        NSLog(@"serie:%@",[info objectForKey:@"serieid"]);
        serieid  = [NSString stringWithFormat:@"%@",[info objectForKey:@"serieid"]];
        matchid =[NSString stringWithFormat:@"%@",[info objectForKey:@"contestid"]];
//        openType =[NSString stringWithFormat:@"%@",[info objectForKey:@"open_type"]];
        
    }
    
    [[DataHelper sharedManager] setTargetSerie:serieid];
    NSString *str = [NSString stringWithFormat:@"是否前往制作页面，\n制作照片参加当前活动？"];
    _openCameraAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"暂时不要" otherButtonTitles:@"前往制作", nil];
    [_openCameraAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==_openCameraAlert) {
        if (buttonIndex==1) {
            UnitySendMessage(UnityController.UTF8String, "LoadEditScene", "");
        }else{
            [[DataHelper sharedManager] setTargetSerie:@""];
        }
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:CCamViewBackgroundColor];
    
    
    _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topBtn setBackgroundColor:[UIColor clearColor]];
    [_topBtn setFrame:CGRectMake(0, 0, CCamNavigationBarHeight - 20, CCamNavigationBarHeight - 20)];
    [_topBtn setCenter:CGPointMake(self.navigationController.navigationBar.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2)];
    [_topBtn addTarget:self action:@selector(webGoTop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_topBtn];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,CCamViewWidth,CCamViewHeight+20)];
    [_webView setBackgroundColor:CCamViewBackgroundColor];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    if (self.hidesBottomBarWhenPushed) {
        [_webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 64+20, 0)];
        
    }else{
        [_webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
        
    }
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    //web call login
    [self.bridge registerHandler:@"call_newweb" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"call_log called: %@", data);
        
        NSString *url = @"";
        NSString *title = @"";
        if([data isKindOfClass:[NSMutableDictionary class]]){
            url  = [NSString stringWithFormat:@"%@",[data objectForKey:@"url"]];
            title =[NSString stringWithFormat:@"%@",[data objectForKey:@"title"]];
        }
        KLWebViewController *detail = [[KLWebViewController alloc] init];
        detail.webURL = url;
        detail.vcTitle = title;
        detail.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        self.navigationItem.backBarButtonItem=backItem;
        [self.navigationController pushViewController:detail animated:YES];
        responseCallback(@"Response from call_newweb");
    }];
    //web call login
    [self.bridge registerHandler:@"call_login" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"call_login called: %@", data);
        [[AuthorizeHelper sharedManager] callAuthorizeView];
        responseCallback(@"Response from call_login");
    }];
    //web call camera
    [self.bridge registerHandler:@"call_camera" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"call_login called: %@", data);
        [self webOpenCameraWithContestInfo:data];
        responseCallback(@"Response from call_camera");
    }];
    //web call album
    [self.bridge registerHandler:@"call_album" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"call_login called: %@", data);
        
        if (![[AuthorizeHelper sharedManager] checkToken]) {
            [[AuthorizeHelper sharedManager] callAuthorizeView];
            return;
        }
        
        NSString *serieid = @"";
        NSString *matchid = @"";
        if([data isKindOfClass:[NSMutableDictionary class]]){
            serieid  = [NSString stringWithFormat:@"%@",[data objectForKey:@"serieid"]];
            matchid =[NSString stringWithFormat:@"%@",[data objectForKey:@"contestid"]];
        }
        
        NSString *str = [NSString stringWithFormat:@"打开相册，系列%@，比赛%@",serieid,matchid];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];

        
        responseCallback(@"Response from call_album");
    }];
    //web call share
    [_bridge registerHandler:@"call_share" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"call_share called: %@", data);
        if (![[AuthorizeHelper sharedManager] checkToken]) {
            [[AuthorizeHelper sharedManager] callAuthorizeView];
            return;
        }
        
        NSString *type = @"";
        NSString *photourl = @"";
        NSString *title = @"";
        NSString *urlimage = @"";
        NSString *content = @"";
        NSString *url = @"";
        if([data isKindOfClass:[NSMutableDictionary class]]){
            type  = [NSString stringWithFormat:@"%@",[data objectForKey:@"type"]];
            photourl =[NSString stringWithFormat:@"%@",[data objectForKey:@"photourl"]];
            title  = [NSString stringWithFormat:@"%@",[data objectForKey:@"title"]];
            urlimage =[NSString stringWithFormat:@"%@",[data objectForKey:@"urlimage"]];
            content  = [NSString stringWithFormat:@"%@",[data objectForKey:@"content"]];
            url =[NSString stringWithFormat:@"%@",[data objectForKey:@"url"]];

        }
        
        NSString *str = [NSString stringWithFormat:@"分享类型%@，分享图片链接%@，链接标题%@，链接图片%@，链接副标题%@，链接%@",type,photourl,title,urlimage,content,url];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];

        
        responseCallback(@"Response from call_share");
    }];
    //web call other page
    [_bridge registerHandler:@"call_photo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"call_photo called: %@", data);
        if (![[AuthorizeHelper sharedManager] checkToken]) {
            [[AuthorizeHelper sharedManager] callAuthorizeView];
            return;
        }
        NSString *workid = @"";
        if([data isKindOfClass:[NSMutableDictionary class]]){
            workid = [NSString stringWithFormat:@"%@",[data objectForKey:@"workid"]];
        }
        
        CCPhotoViewController *userpage = [[CCPhotoViewController alloc] init];
        userpage.photoID = workid;
        userpage.vcTitle = @"照片详情";
        userpage.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        self.navigationItem.backBarButtonItem=backItem;
        [self.navigationController pushViewController:userpage animated:YES];        responseCallback(@"Response from call_photo");
    }];
    
    [_bridge registerHandler:@"call_user" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"call_user called: %@", data);
        if (![[AuthorizeHelper sharedManager] checkToken]) {
            [[AuthorizeHelper sharedManager] callAuthorizeView];
            return;
        }
        NSString *memberid = @"";
        if([data isKindOfClass:[NSMutableDictionary class]]){
            memberid = [NSString stringWithFormat:@"%@",[data objectForKey:@"memberid"]];
        }
        
        CCUserViewController *userpage = [[CCUserViewController alloc] init];
        userpage.userID = memberid;
        userpage.vcTitle = @"用户详情";
        userpage.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        self.navigationItem.backBarButtonItem=backItem;
        [self.navigationController pushViewController:userpage animated:YES];
        responseCallback(@"Response from call_user");
    }];
    
//    UIToolbar *toolBar  =[[ UIToolbar alloc] initWithFrame:CGRectMake(0, CCamViewHeight-CCamTabBarHeight, CCamViewWidth, CCamTabBarHeight)];
//    if(iOS8){
//        [toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView * blur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        [blur setFrame:CGRectMake(0, 0, CCamViewWidth, CCamTabBarHeight)];
//        [toolBar addSubview:blur];
//    }else{
//        [toolBar setBarTintColor:CCamBarTintColor];
//    }
//    [toolBar setTintColor:CCamGoldColor];
//    [self.view addSubview:toolBar];
    
    UIBarButtonItem * refreshBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(callMoreActivityViewController)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    MJRefreshNormalHeader *webHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(webRefresh)];
    webHeader.automaticallyChangeAlpha = YES;
    webHeader.lastUpdatedTimeLabel.hidden = YES;
    _webView.scrollView.mj_header = webHeader;

    
    [_webView.scrollView setDelegate:self];
    NSLog(@"%@",self.webURL);
    NSURL *url = [NSURL URLWithString:self.webURL];
    NSString *body = [NSString stringWithFormat: @"token=%@",[[AuthorizeHelper sharedManager] getUserToken]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest: request];

}
- (void)callMoreActivityViewController{
//    NSString *string = self.vcTitle;
//    NSURL *URL = [NSURL URLWithString:self.webURL];
//    
//    KLActivity *act1 = [[KLActivity alloc]initWithImage:[UIImage imageNamed:@"wechatIcon"] URL:self.webURL title:@"1" shareContentArray:[NSArray new]];
//    
//    KLActivity *act2 = [[KLActivity alloc]initWithImage:[UIImage imageNamed:@"weiboIcon"] URL:self.webURL title:@"2" shareContentArray:[NSArray new]];
//    NSArray *apps = @[act1,act2];
//    
//    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:apps];
//    activityViewController.title = @"haha";
//    activityViewController.view.tintColor =CCamRedColor;
//    UIActivityTypeAddToReadingList
//    UIActivityTypeAirDrop
//    UIActivityTypeAssignToContact
//    UIActivityTypeCopyToPasteboard
//    UIActivityTypeMail
//    UIActivityTypeMessage
//    UIActivityTypeOpenInIBooks
//    UIActivityTypePostToFacebook
//    UIActivityTypePostToFlickr
//    UIActivityTypePostToTencentWeibo
//    UIActivityTypePostToTwitter
//    UIActivityTypePostToVimeo
//    UIActivityTypePostToWeibo
//    UIActivityTypePrint
//    UIActivityTypeSaveToCameraRoll
    
//    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact,UIActivityTypeOpenInIBooks,UIActivityTypePostToFacebook,UIActivityTypePostToFlickr,UIActivityTypePostToTencentWeibo,UIActivityTypePostToTwitter,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypePostToFacebook];
//    [self.navigationController presentViewController:activityViewController
//                                       animated:YES
//                                     completion:^{
//                                         // ... 
//                                     }];
    
    NSArray *shareAry = @[@{@"image":@"wechatIcon",
                            @"title":@"微信"},
                          @{@"image":@"wechatIcon",
                            @"title":@"微信朋友圈"},
                          @{@"image":@"weiboIcon",
                            @"title":@"新浪微博"},
                          @{@"image":@"qqIcon",
                            @"title":@"QQ"},
                          @{@"image":@"facebookIcon",
                            @"title":@"Facebook"},
                          @{@"image":@"wechatIcon",
                            @"title":@"复制链接"},
                          @{@"image":@"wechatIcon",
                            @"title":@"刷新"},
                          @{@"image":@"wechatIcon",
                            @"title":@"举报"}];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, headerView.frame.size.width, 11)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:99/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    label.text = @"网页由 mp.weixin.qq.com 提供";
    [headerView addSubview:label];
    
    HXEasyCustomShareView *shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:shareAry firstCount:5];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    [shareView setShareAry:shareAry delegate:self];
    shareView.middleLineLabel.frame = CGRectMake(10, shareView.middleLineLabel.frame.origin.y, shareView.frame.size.width-20, shareView.middleLineLabel.frame.size.height);
    shareView.showsHorizontalScrollIndicator = NO;
    [self.navigationController.view addSubview:shareView];
    
}
#pragma mark HXEasyCustomShareViewDelegate

- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    NSLog(@"当前点击:%@",title);
    
    if ([title isEqualToString:@"复制链接"]) {
        
        NSString *url = _webView.request.URL.absoluteString;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:url delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webURL;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"链接已复制！"];
        [hud hide:YES afterDelay:1.0];
        
    }else if ([title isEqualToString:@"刷新"]){
        [_webView.scrollView.mj_header beginRefreshing];
    }else if ([title isEqualToString:@"举报"]){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"暂时无法举报网页！"];
        [hud hide:YES afterDelay:1.0];
        
    }else{
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.vcTitle
                                         images:[UIImage imageNamed:@"shareIcon"]
                                            url:[NSURL URLWithString:self.webURL]
                                          title:self.vcTitle
                                           type:SSDKContentTypeWebPage];
        
        //进行分享
        SSDKPlatformType shareType;
        
        if ([title isEqualToString:@"微信"]) {
            shareType = SSDKPlatformSubTypeWechatSession;
            [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                            NSLog(@"分享成功！");
                            break;
                        case SSDKResponseStateCancel:
                            NSLog(@"取消分享！");
                            break;
                        case SSDKResponseStateFail:
                            NSLog(@"分享失败！");
                            break;
                        default:
                            break;
                    }
                }
            }];
        }else if ([title isEqualToString:@"微信朋友圈"]){
            shareType = SSDKPlatformSubTypeWechatTimeline;
            [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                            NSLog(@"分享成功！");
                            break;
                        case SSDKResponseStateCancel:
                            NSLog(@"取消分享！");
                            break;
                        case SSDKResponseStateFail:
                            NSLog(@"分享失败！");
                            break;
                        default:
                            break;
                    }
                }
            }];
        }else if ([title isEqualToString:@"新浪微博"]){
            shareType = SSDKPlatformTypeSinaWeibo;
            [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                if (error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                            NSLog(@"分享成功！");
                            break;
                        case SSDKResponseStateCancel:
                            NSLog(@"取消分享！");
                            break;
                        case SSDKResponseStateFail:
                            NSLog(@"分享失败！");
                            break;
                        default:
                            break;
                    }
                }
            }];
        }else if ([title isEqualToString:@"QQ"]){
            shareType = SSDKPlatformSubTypeQQFriend;
            [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                            NSLog(@"分享成功！");
                            break;
                        case SSDKResponseStateCancel:
                            NSLog(@"取消分享！");
                            break;
                        case SSDKResponseStateFail:
                            NSLog(@"分享失败！");
                            break;
                        default:
                            break;
                    }
                }
            }];
        }else if ([title isEqualToString:@"Facebook"]){
            shareType = SSDKPlatformTypeFacebook;
            [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                if (error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                            NSLog(@"分享成功！");
                            break;
                        case SSDKResponseStateCancel:
                            NSLog(@"取消分享！");
                            break;
                        case SSDKResponseStateFail:
                            NSLog(@"分享失败！");
                            break;
                        default:
                            break;
                    }
                }
            }];
        }
        
        
    }
    
    [shareView removeFromSuperview];
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
//    [_webView.scrollView setContentOffset:CGPointMake(0, -CCamNavigationBarHeight-CCamTabBarHeight-10) animated:YES];
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
    NSLog(@"Should Start Web%@",request.URL.absoluteString);
//    [_webLoading startAnimating];
    [self manageWebControlButtons];

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"Start load web%@",_webView.request.URL.absoluteString);
    [_webLoading startAnimating];
    [self setRefreshControlStateWithRefresh:_refresh andState:CCamUpdatingPage];
    [self manageWebControlButtons];
    [self webProgressAnimationWithType:@"Start"];
    [self showWebPageLoadingStatus];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"Load finish web%@",_webView.request.URL.absoluteString);
    [_webLoading stopAnimating];
    [self setRefreshControlStateWithRefresh:_refresh andState:CCamUpdatePageSuccess];
    [self performSelector:@selector(refreshEndAnimation) withObject:nil afterDelay:1.0];
    [self manageWebControlButtons];
    [self webProgressAnimationWithType:@"End"];
    [self showWebPageLoadingStatus];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, CCamNavigationBarHeight+20, 0)];
    [_webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, CCamNavigationBarHeight+20, 0)];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"Load error web%@",_webView.request.URL.absoluteString);
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
