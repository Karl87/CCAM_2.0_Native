//
//  AuthorizeHelper.m
//  CCamNativeKit
//
//  Created by Karl on 2015/12/1.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "AuthorizeHelper.h"
#import <pop/POP.h>
#import <UIKit/UIKit.h>

#import "CCLaunchViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import <CommonCrypto/CommonDigest.h>
#import "CCamHelper.h"

@interface AuthorizeHelper ()

@property (nonatomic,strong) UIWindow * authorizeWindow;
@property (nonatomic,strong) CCLaunchViewController *authorizeView;
@end

@implementation AuthorizeHelper

+ (AuthorizeHelper*)sharedManager
{
    static dispatch_once_t pred;
    static AuthorizeHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{ _sharedInstance = [[self alloc] init]; } );
    return _sharedInstance;
}
- (BOOL)checkToken{
    if ([self getUserToken] !=nil && ![[self getUserToken] isEqualToString:@""] && ![[self getUserToken] isEqualToString:@"null"] && ![[self getUserToken] isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

- (void)logout{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[ViewHelper sharedManager] getCurrentVC].view animated:YES];
    hud.labelText = @"登出角色相机中";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:CCamLogoutURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if ([jsonStr isEqualToString:@"1"]) {
            hubMessage = @"登出成功!";
            [self setUserToken:@""];
            [self setUserID:@""];
        }else{
            hubMessage = @"登出失败!";
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:@"网络故障"];
        [hud hide:YES afterDelay:1.0f];
    }];
}
- (NSString *)getUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"userid"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setUserID:(NSString *)userid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userid forKey:@"userid"];
    NSLog(@"%@",[self getUserID]);
}
- (NSString *)getUserToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"usertoken"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setUserToken:(NSString *)token{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"usertoken"];
    NSLog(@"%@",[self getUserToken]);
}
- (void)callAuthorizeView{
    if (_authorizeWindow == nil) {
        _authorizeWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_authorizeWindow setWindowLevel:UIWindowLevelNormal +1];
        
        CCLaunchViewController * ani = [[CCLaunchViewController alloc] init];
        _authorizeView = ani;
        [_authorizeWindow setRootViewController:_authorizeView];
    }
    [_authorizeWindow makeKeyAndVisible];
}

- (void)dismissAuthorizeView{
    [_authorizeWindow removeFromSuperview];
    [_authorizeWindow resignKeyWindow];
    _authorizeView = nil;
    _authorizeWindow = nil;
    NSLog(@"window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
}
- (void)getSocialPlatformInfoWithTypeID:(NSString*)typeID shareType:(SSDKPlatformType)type isLogin:(BOOL)isLogin{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_authorizeView.view animated:YES];
    hud.labelText = @"获取信息";
    NSString *platForm = @"";
    switch (type) {
        case SSDKPlatformTypeWechat:
            platForm = @"微信";
            break;
        case SSDKPlatformTypeQQ:
            platForm = @"QQ";
            break;
        case SSDKPlatformTypeSinaWeibo:
            platForm = @"新浪微博";
            break;
        case SSDKPlatformTypeFacebook:
            platForm = @"Facebook";
            break;
        default:
            break;
    }
    
    [ShareSDK getUserInfo:type
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
               if (state == SSDKResponseStateSuccess){
                   NSLog(@"%@",user);
                   hud.labelText = [NSString stringWithFormat:@"%@登录成功",platForm];
                   [hud hide:YES];
                   [self loginWithTypeID:typeID shareType:type userInfo:user isLogin:YES];
               }else{
                   hud.labelText = [NSString stringWithFormat:@"%@登录失败",platForm];
                   NSLog(@"%@",error);
                   [hud hide:YES afterDelay:1.0f];
               }
               
           }];

    
}
- (void)loginWithTypeID:(NSString *)typeID shareType:(SSDKPlatformType)type userInfo:(SSDKUser *)user isLogin:(BOOL)login{
    NSString *head_url =@"";
    NSString *wechat_name= @"";
    NSString *weibo_name = @"";
    NSString *QQ_name =@"";
    NSString *facebook_name = @"";
    NSString *type_id = @"";
    NSString *account_id = @"";
    NSString *wechatunion_id = @"";
    NSString *_token = @"";
    NSString *platForm = @"";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_authorizeView.view animated:YES];
    hud.labelText = @"登陆角色相机中";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters;
    
    type_id = typeID;
    head_url = user.icon;
    _token = CCamTestToken;
    account_id = user.uid;
    NSLog(@"UID:%@",user.uid);
    switch (type) {
        case SSDKPlatformTypeWechat:
            wechat_name = user.nickname;
            wechatunion_id = [user.rawData objectForKey:@"unionid"];
            platForm = @"微信";
            NSLog(@"WECHAT UNIONID:%@",wechatunion_id);
            if (login) {
                parameters = @{@"login":@"0",@"type_id":type_id,@"account_code":account_id,@"head_url":head_url,@"wechat_name":wechat_name,@"unionid":wechatunion_id};
            }else{
                parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"wechat_name":wechat_name,@"token":_token,@"unionid":wechatunion_id};
            }
            break;
        case SSDKPlatformTypeQQ:
            QQ_name = user.nickname;
            platForm = @"QQ";
            if (login) {
                parameters = @{@"login":@"0",@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"QQ_name":QQ_name};
            }else{
                parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"QQ_name":QQ_name,@"token":_token};
            }
            break;
        case SSDKPlatformTypeSinaWeibo:
            weibo_name = user.nickname;
            platForm = @"新浪微博";
            if (login) {
                parameters = @{@"login":@"0",@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"weibo_name":weibo_name};
            }else{
                parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"weibo_name":weibo_name,@"token":_token};
            }
            break;
        case SSDKPlatformTypeFacebook:
            facebook_name = user.nickname;
            platForm = @"Facebook";
            if (login) {
                parameters = @{@"login":@"0",@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"facebook_name":facebook_name};
            }else{
                parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"facebook_name":facebook_name,@"token":_token};
            }
            break;
        default:
            break;
    }

    
    [manager POST:CCamLoginURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if (jsonStr.length>3) {
            NSError *error;
            NSArray *jsonAry = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            NSString *stateMessage =[NSString stringWithFormat:@"%@",jsonAry[0]] ;
            NSString *userToken =[NSString stringWithFormat:@"%@",jsonAry[1]];
            NSString *userID = [NSString stringWithFormat:@"%@",jsonAry[2]];
            
            if ([stateMessage isEqualToString:@"1"] || [stateMessage isEqualToString:@"2"]) {
                hubMessage = @"登录角色相机成功!";//[NSString stringWithFormat:@"%@登录角色相机成功!",platForm];
            }else if ([stateMessage isEqualToString:@"3"]){
                hubMessage = @"账号关联成功!";
            }
            NSLog(@"%@",userToken);
            [[AuthorizeHelper sharedManager] setUserToken:userToken];
            [[AuthorizeHelper sharedManager] setUserID:userID];
            
            [self performSelector:@selector(dismissAuthorizeView) withObject:nil afterDelay:1.0];
        }else{
            if ([jsonStr isEqualToString:@"-1"] || [jsonStr isEqualToString:@"-4"]) {
                hubMessage = @"登录失败!";
            }else if ([jsonStr isEqualToString:@"-2"]){
                hubMessage = @"已绑定其他账号!";
            }else if ([jsonStr isEqualToString:@"-3"]){
                hubMessage = @"登录状态失效,请重新登录!";
            }else if ([jsonStr isEqualToString:@"-5"]){
                hubMessage = @"手机号码错误!";
            }else if ([jsonStr isEqualToString:@"-6"]){
                hubMessage = @"密码错误!";
            }else if ([jsonStr isEqualToString:@"-7"]){
                hubMessage = @"手机号码已注册或关联!";
            }
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:@"网络故障"];
        [hud hide:YES afterDelay:1.0f];
    }];

}
- (void)mobileLoginWithPhone:(NSString *)phone password:(NSString *)password isLogin:(BOOL)login{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_authorizeView.view animated:YES];
    hud.labelText = @"注册角色相机中";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"type_id": @"1",@"login":@"1",@"account_code": phone,@"password":[self md5:password]};
    
    [manager POST:CCamLoginURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if (jsonStr.length>3) {
            NSError *error;
            NSArray *jsonAry = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            NSString *stateMessage =[NSString stringWithFormat:@"%@",jsonAry[0]] ;
            NSString *userToken =[NSString stringWithFormat:@"%@",jsonAry[1]];
            NSString *userID = [NSString stringWithFormat:@"%@",jsonAry[2]];
            
            if ([stateMessage isEqualToString:@"1"] || [stateMessage isEqualToString:@"2"]) {
                hubMessage = @"登录角色相机成功!";//[NSString stringWithFormat:@"%@登录角色相机成功!",platForm];
            }else if ([stateMessage isEqualToString:@"3"]){
                hubMessage = @"账号关联成功!";
            }
            NSLog(@"%@",userToken);
            [[AuthorizeHelper sharedManager] setUserToken:userToken];
            [[AuthorizeHelper sharedManager] setUserID:userID];
            [self performSelector:@selector(dismissAuthorizeView) withObject:nil afterDelay:1.0];
        }else{
            if ([jsonStr isEqualToString:@"-1"] || [jsonStr isEqualToString:@"-4"]) {
                hubMessage = @"登录失败!";
            }else if ([jsonStr isEqualToString:@"-2"]){
                hubMessage = @"已绑定其他账号!";
            }else if ([jsonStr isEqualToString:@"-3"]){
                hubMessage = @"登录状态失效,请重新登录!";
            }else if ([jsonStr isEqualToString:@"-5"]){
                hubMessage = @"手机号码错误!";
            }else if ([jsonStr isEqualToString:@"-6"]){
                hubMessage = @"密码错误!";
            }else if ([jsonStr isEqualToString:@"-7"]){
                hubMessage = @"手机号码已注册或关联!";
            }
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:@"网络故障"];
        [hud hide:YES afterDelay:1.0f];
    }];
}
- (void)mobileResetPasswordWithPhone:(NSString *)phone password:(NSString *)password{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_authorizeView.view animated:YES];
    hud.labelText = @"修改密码中";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"phone": phone,@"password":[self md5:password]};
    
    [manager POST:CCamResetPswURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if ([jsonStr isEqualToString:@"-2"]) {
            hubMessage = [NSString stringWithFormat:@"手机号码%@\n尚未注册",phone];
        }else if ([jsonStr isEqualToString:@"-1"]) {
            hubMessage = @"修改密码失败!";
        }else if ([jsonStr isEqualToString:@"1"]) {
            hubMessage = @"修改密码成功!";
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:@"网络故障"];
        [hud hide:YES afterDelay:1.0f];
    }];
}
- (NSString *)md5:(NSString*)str
{
    const char* character = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(character, strlen(character), result);
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [md5String appendFormat:@"%02x",result[i]];
    }
    return md5String;
}
@end
