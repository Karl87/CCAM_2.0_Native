//
//  ShareHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import "ShareHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "ShareViewController.h"

@interface ShareHelper ()
@property (nonatomic,strong) UIWindow * shareWindow;
@property (nonatomic,strong) ShareViewController *shareView;

@end

@implementation ShareHelper
+ (ShareHelper*)sharedManager
{
    static dispatch_once_t pred;
    static ShareHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (void)initShareSDK{
    [ShareSDK registerApp:@"76f976b22c31"
     
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformTypeFacebook)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"879416201"
                                           appSecret:@"d0622fbb1ac78e0bf0d43263a84597f4"
                                         redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb0bc0ae7d90dc61e"
                                       appSecret:@"f898d8973add85934790c35260748a84"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104554620"
                                      appKey:@"WknCGrPLmV4sFqPU"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             case SSDKPlatformTypeFacebook:
                 [appInfo        SSDKSetupFacebookByApiKey:@"366856386836374"
                                                 appSecret:@"b872811651cf238a6fdcc349a66125be"
                                                  authType:SSDKAuthTypeBoth];
                 break;
            default:
                 break;
         }
     }];
}
- (void)callShareViewIsMyself:(BOOL)myself delegate:(id)delegate timeline:(CCTimeLine *)timeline indexPath:(NSIndexPath *)indexPath{
    if (!_shareWindow) {
        _shareWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_shareWindow setUserInteractionEnabled:YES];
        [_shareWindow setWindowLevel:UIWindowLevelNormal +1];
        
        ShareViewController * ani = [[ShareViewController alloc] init];
        ani.myself = myself;
        ani.delegate = delegate;
        ani.timeline = timeline;
        ani.indexPath = indexPath;
        _shareView = ani;
        [_shareWindow setRootViewController:_shareView];
    }
    [_shareWindow makeKeyAndVisible];
}

- (void)dismissShareView{
    [_shareWindow setHidden:YES];
    [_shareWindow removeFromSuperview];
//    [_shareWindow resignKeyWindow];
    _shareView = nil;
    _shareWindow = nil;
    NSLog(@"1st round window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
    [[UIApplication sharedApplication].windows[0] setUserInteractionEnabled:YES];
    NSLog(@"2nd round window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);

}
@end
