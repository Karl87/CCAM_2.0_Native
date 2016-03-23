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
#import <MBProgressHUD/MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"

#import "CCamRefreshHeader.h"

@interface KLWebViewController () <UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) UIActivityIndicatorView *webLoading;
@property (nonatomic,strong) UIRefreshControl *refresh;
@property (nonatomic,strong) VBFPopFlatButton *backBtn;
@property (nonatomic,strong) VBFPopFlatButton *forwardBtn;
@property (nonatomic,strong) UIButton *topBtn;

@property (nonatomic,strong) UIAlertView *openCameraAlert;
@property (nonatomic,strong) UIAlertView *openAlbumAlert;

@property (nonatomic,strong) WebViewJavascriptBridge *bridge;
@property (nonatomic,strong) CCTimeLine *timeline;

@property (nonatomic,strong) NSString *contestSerieID;
@property (nonatomic,strong) NSString *contestID;
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
    NSString *str = Babel(@"是否前往制作页面，制作照片参加当前活动？");
    _openCameraAlert = [[UIAlertView alloc] initWithTitle:Babel(@"提示") message:str delegate:self cancelButtonTitle:Babel(@"暂时不要") otherButtonTitles:Babel(@"前往制作"), nil];
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
- (void)returnWhenPresentSelf{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:CCamViewBackgroundColor];
    
    if ([self.navigationController.viewControllers count]==1) {
        UIBarButtonItem * dismissBtn = [[UIBarButtonItem alloc] initWithTitle:Babel(@"完成") style:UIBarButtonItemStylePlain target:self action:@selector(returnWhenPresentSelf)];
        self.navigationItem.leftBarButtonItem = dismissBtn;

    }
    
    
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
        
        _contestID = matchid;

        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:Babel(@"参加比赛") delegate:self cancelButtonTitle:Babel(@"取消") destructiveButtonTitle:nil otherButtonTitles:Babel(@"从相册选择"),Babel(@"拍照"), nil];
        [actionsheet showInView:self.view];
        
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
        
        BOOL shareImage;
        if ([type isEqualToString:@"url"]) {
            shareImage = NO;
        }else{
            shareImage = YES;
        }
        
        _timeline = nil;
        
        CCTimeLine *timeline =[NSEntityDescription insertNewObjectForEntityForName:@"CCTimeLine" inManagedObjectContext:[[CoreDataHelper sharedManager] managedObjectContext]];
        timeline.image_fullsize = photourl;
        timeline.image_share = urlimage;
        timeline.shareURL = url;
        timeline.shareTitle = title;
        timeline.shareSubTitle = content;
        
        _timeline = timeline;
        
        [[ShareHelper sharedManager] callShareViewIsMyself:NO delegate:self timeline:_timeline timelineCell:nil indexPath:nil onlyShare:YES shareImage:shareImage];
        
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
        userpage.vcTitle = Babel(@"照片详情");
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
        userpage.vcTitle = @"";
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
    CCamRefreshHeader *webHeader = [CCamRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(webRefresh)];
    webHeader.stateLabel.hidden = YES;
    webHeader.automaticallyChangeAlpha = YES;
    webHeader.lastUpdatedTimeLabel.hidden = YES;
    _webView.scrollView.mj_header = webHeader;

    
    [_webView.scrollView setDelegate:self];
    NSLog(@"%@",self.webURL);
//    NSURL *url = [NSURL URLWithString:self.webURL];
//    NSString *body = [NSString stringWithFormat: @"token=%@",[[AuthorizeHelper sharedManager] getUserToken]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
//    [request setHTTPMethod: @"POST"];
//    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
//    [_webView loadRequest: request];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
}
- (void)dissmisShareViewWith:(NSIndexPath *)indexPath{
    NSLog(@"%ld-%ld打开了ShareView",(long)indexPath.section,(long)indexPath.row);
}
- (void)shareViewBtnClickWithType:(NSString *)type andTitle:(NSString *)title isShareImage:(BOOL)isShare{
    NSLog(@"%@:%@",type,title);
    if([type isEqualToString:@"Share"]){
        
        if ([title isEqualToString:Babel(@"复制链接")]){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _timeline.shareURL;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = Babel(@"已复制链接到粘贴板");
            [hud hide:YES afterDelay:1.0];
            return;
        }
        
        NSArray* imageArray = @[_timeline.image_fullsize];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        if ([_timeline.shareURL isEqualToString:@""]) {
            _timeline.shareURL = @"http://www.c-cam.cc";
        }
        if ([_timeline.shareTitle isEqualToString:@""]) {
            _timeline.shareTitle = Babel(@"角色相机");
        }
        if ([_timeline.shareSubTitle isEqualToString:@""]) {
//            _timeline.shareSubTitle = [NSString stringWithFormat:@"请为%@的照片点赞",_timeline.timelineUserName];
        }
        
        if (isShare) {
            [shareParams SSDKSetupShareParamsByText:_timeline.shareSubTitle
                                             images:imageArray
                                                url:[NSURL URLWithString:_timeline.shareURL]
                                              title:_timeline.shareTitle
                                               type:SSDKContentTypeImage];
            
        }else{
            [shareParams SSDKSetupShareParamsByText:_timeline.shareSubTitle
                                             images:imageArray
                                                url:[NSURL URLWithString:_timeline.shareURL]
                                              title:_timeline.shareTitle
                                               type:SSDKContentTypeAuto];
        }
        
        SSDKPlatformType shareType;
        
        if ([title isEqualToString:Babel(@"微信")]){
            shareType = SSDKPlatformSubTypeWechatSession;
        }else if ([title isEqualToString:Babel(@"朋友圈")]){
            shareType = SSDKPlatformSubTypeWechatTimeline;
        }else if ([title isEqualToString:Babel(@"新浪微博")]){
            shareType = SSDKPlatformTypeSinaWeibo;
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",_timeline.shareSubTitle,_timeline.shareURL]
                                             images:imageArray
                                                url:[NSURL URLWithString:_timeline.shareURL]
                                              title:_timeline.shareTitle
                                               type:SSDKContentTypeAuto];
            [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                if (!error) {
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
                }else{
                    NSLog(@"%@",error.description);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:error.description delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    [ShareSDK cancelAuthorize:shareType];
                }
            }];
            return;
        }else if ([title isEqualToString:Babel(@"QQ")]){
            shareType = SSDKPlatformSubTypeQQFriend;
        }else if ([title isEqualToString:Babel(@"QQ空间")]){
            shareType = SSDKPlatformSubTypeQZone;
        }else if ([title isEqualToString:Babel(@"Facebook")]){
            shareType = SSDKPlatformTypeFacebook;
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",_timeline.shareSubTitle,_timeline.shareURL]
                                             images:imageArray
                                                url:[NSURL URLWithString:_timeline.shareURL]
                                              title:_timeline.shareTitle
                                               type:SSDKContentTypeAuto];
            [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                if (!error) {
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
                }else{
                    NSLog(@"%@",error.description);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:error.description delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    [ShareSDK cancelAuthorize:shareType];
                }
            }];
            return;
        }
        [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (!error) {
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
            }else{
                NSLog(@"%@",error.description);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:error.description delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
    }
}
- (void)callMoreActivityViewController{
    
    NSString *photourl = @"";
    NSString *title = @"";
    NSString *urlimage = @"";
    NSString *content = @"";
    NSString *url = @"";
    
    _timeline = nil;
    
    CCTimeLine *timeline =[NSEntityDescription insertNewObjectForEntityForName:@"CCTimeLine" inManagedObjectContext:[[CoreDataHelper sharedManager] managedObjectContext]];
    
    if (_event) {
        title  = _event.shareTitle;
        urlimage =_event.shareImage;
        content  = _event.shareSubtitle;
        url =_event.eventURL;
    }else{
        title  = Babel(@"角色相机");
        urlimage = @"";
        content  = @"";
        url =_webURL;
    }
    
    timeline.image_fullsize = photourl;
    timeline.image_share = urlimage;
    timeline.shareURL = url;
    timeline.shareTitle = title;
    timeline.shareSubTitle = content;
    
    _timeline = timeline;
    
    [[ShareHelper sharedManager] callShareViewIsMyself:NO delegate:self timeline:_timeline timelineCell:nil indexPath:nil onlyShare:YES shareImage:NO];

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
#pragma mark - join contest with album
- (void)uploadPhotoWith:(UIImage *)albumImage{
    
    
    
    
}
#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.allowsEditing = YES;
            // 设置导航默认标题的颜色及字体大小
            picker.navigationBar.tintColor = [UIColor blackColor];
            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
            [self presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
        
    }else if (buttonIndex == 1){
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            // 设置导航默认标题的颜色及字体大小
            picker.navigationBar.tintColor = [UIColor blackColor];
            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
            [self presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];}];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%@",info);
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    
//    [self uploadPhotoWith:image];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = Babel(@"发布照片中");
    
    NSDictionary *parameters= @{@"token":[[AuthorizeHelper sharedManager] getUserToken],@"contestid":_contestID,@"description":@"",@"characterid":@""};
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:CCamSubmitPhotoURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"submit.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"%f",uploadProgress.fractionCompleted);
                          hud.progress = (float)uploadProgress.fractionCompleted;
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          
                          hud.mode = MBProgressHUDModeText;
                          hud.labelText = Babel(@"发布照片失败");
                          [hud hide:YES afterDelay:2.0];
                          
                          
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          
                          hud.mode = MBProgressHUDModeText;
                          hud.labelText = Babel(@"发布照片成功");
                          [hud hide:YES afterDelay:1.0];
                      }
                  }];
    
    [uploadTask resume];
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}
@end
