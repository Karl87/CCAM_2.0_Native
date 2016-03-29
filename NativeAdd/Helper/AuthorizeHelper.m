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
#import "KLWebViewController.h"
#import "KLNavigationController.h"
#import "PersonInfoViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import <CommonCrypto/CommonDigest.h>
#import "CCamHelper.h"

@interface AuthorizeHelper ()

@property (nonatomic,strong) UIWindow * authorizeWindow;
@property (nonatomic,strong) CCLaunchViewController *authorizeView;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger smsTimeCount;


@end

@implementation AuthorizeHelper

- (void)startSmsTimer{
    
    _smsTimeCount = 30;
    
    if (_timer) {
        if (![_timer isValid]) {
            NSLog(@"取消Timer暂停");
            [_timer fire];
        }
    }else{
        NSLog(@"初始化Timer");
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(smsTimerCount) userInfo:nil repeats:YES];
    }
    
}
- (void)smsTimerCount{
    _smsTimeCount = _smsTimeCount-1;
    if (_smsTimeCount == -1) {
        [_timer invalidate];
    }else{
        if (_authorizeView) {
            [_authorizeView smsTimerCount:_smsTimeCount];
        }
    }
    
}
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
- (void)loginStateError{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = Babel(@"登录状态失效，请重新登录");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:CCamLogoutURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
//        if ([jsonStr isEqualToString:@"1"]) {
            hubMessage = Babel(@"登出成功");
            [self setUserToken:@""];
            [self setUserID:@""];
            
            [self callAuthorizeView];
//        }else{
//            hubMessage = Babel(@"登出失败");
//        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0f];
    }];

}
- (void)logout{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = Babel(@"登出角色相机中");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:CCamLogoutURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
//        if ([jsonStr isEqualToString:@"1"]) {
            hubMessage = Babel(@"登出成功");
            [self setUserToken:@""];
            [self setUserID:@""];
            
            if ([MessageHelper sharedManager].tabVC) {
                [[MessageHelper sharedManager].tabVC reloadWhenLogin];
            }
            
//        }else{
//            hubMessage = Babel(@"登出失败");
//        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
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
- (NSString *)getDeviceToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"devicetoken"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setDeviceToken:(NSString *)deviceToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceToken forKey:@"devicetoken"];
    NSLog(@"%@",[self getDeviceToken]);
}
- (void)updateDeviceToken{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSString *deviceToken = [[AuthorizeHelper sharedManager] getDeviceToken];
    NSDictionary *parameters =@{@"device_token":deviceToken,@"token":token};
    [manager GET:CCamUpdateDeviceToeknURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
- (NSString *)getUserName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"username"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setUserName:(NSString *)name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:@"username"];
    NSLog(@"%@",[self getUserName]);
    
}
- (NSString *)getUserImage{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"userimage"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setUserImage:(NSString *)image{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:image forKey:@"userimage"];
    NSLog(@"%@",[self getUserImage]);
    
}
- (NSString *)getUserGroup{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"usergroup"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setUserGroup:(NSString *)group{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:group forKey:@"usergroup"];
    NSLog(@"%@",[self getUserGroup]);
}
- (NSString *)getUserZone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"userzone"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setUserZone:(NSString *)zone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:zone forKey:@"userzone"];
    NSLog(@"%@",[self getUserZone]);
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
    
    if (!_authorizeView || !_authorizeWindow) {
        return;
    }
    
    NSString *type = @"";
    if (_authorizeView.dismissType) {
        type = _authorizeView.dismissType;
    }
    
    [_authorizeWindow setHidden:YES];
    [_authorizeWindow removeFromSuperview];
    [_authorizeWindow resignKeyWindow];
    _authorizeView = nil;
    _authorizeWindow = nil;
    NSLog(@"window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
    
    if ([type isEqualToString:@"agreement"]) {
        if ([MessageHelper sharedManager].tabVC) {
            [self callAgreement:[MessageHelper sharedManager].tabVC];
        }
    }else if ([type isEqualToString:@"userinfo"]){
        if ([MessageHelper sharedManager].tabVC) {
            [self callPersonnalInfo:[MessageHelper sharedManager].tabVC];
        }
    }
}
-(void)callPersonnalInfo:(UITabBarController*)tab{
    PersonInfoViewController *person = [[PersonInfoViewController alloc] init];
    person.vcTitle = Babel(@"完善用户信息");
    person.setNavigationBar = YES;
    self.personInfoVC = person;
    KLNavigationController *nv = [[KLNavigationController alloc] initWithRootViewController:person];
    [tab presentViewController:nv animated:YES completion:nil];
}
- (void)callAgreement:(UITabBarController *)tab{
    KLWebViewController *agree = [[KLWebViewController alloc] init];
    agree.webURL = CCamAgreementURL;
    agree.vcTitle = Babel(@"角色相机用户协议");
    agree.setNavigationBar = YES;
    KLNavigationController *nv = [[KLNavigationController alloc] initWithRootViewController:agree];
    [tab presentViewController:nv animated:YES completion:nil];
}
- (void)getSocialPlatformInfoWithTypeID:(NSString*)typeID shareType:(NSString*)type isLogin:(BOOL)isLogin{
    
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:type  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hud.labelText = @"获取信息";
    NSString *platForm = @"";
    
    if ([type isEqualToString:UMShareToWechatSession]) {
        platForm = Babel(@"微信");
    }else if ([type isEqualToString:UMShareToQQ]) {
        platForm = Babel(@"QQ");
    }else if ([type isEqualToString:UMShareToSina]) {
        platForm = Babel(@"新浪微博");
    }else if ([type isEqualToString:UMShareToFacebook]) {
        platForm = Babel(@"Facebook");
    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    
    NSLog(@"type %@",type);

//    if ([AuthorizeHelper sharedManager].authorizeView) {
//        NSLog(@"1");
//    }else{
//        NSLog(@"0");
//    }
    
    snsPlatform.loginClickHandler([AuthorizeHelper sharedManager].authorizeView,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        NSLog(@"%@",response.message);

        if (response.responseCode == UMSResponseCodeSuccess) {
            
            [hud hide:YES];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:type];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self loginWithTypeID:typeID shareType:type userInfo:snsAccount isLogin:isLogin];
        }else{
            hud.labelText = [NSString stringWithFormat:@"%@%@",platForm,Babel(@"登录失败")];
            [hud hide:YES afterDelay:1.0f];
        }
    });
}
- (void)loginWithTypeID:(NSString *)typeID shareType:(NSString*)type userInfo:(UMSocialAccountEntity *)user isLogin:(BOOL)login{

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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = Babel(@"登录角色相机中");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters;
    
    type_id = typeID;
    head_url = user.iconURL;
    _token = CCamTestToken;
    account_id = user.usid;
    NSLog(@"UID:%@",user.usid);
    
    if ([type isEqualToString:UMShareToWechatSession]) {
        wechat_name = user.userName;
        wechatunion_id = user.unionId;
        platForm = Babel(@"微信");
        NSLog(@"WECHAT UNIONID:%@",wechatunion_id);
        if (login) {
            parameters = @{@"login":@"0",@"type_id":type_id,@"account_code":account_id,@"head_url":head_url,@"wechat_name":wechat_name,@"unionid":wechatunion_id};
        }else{
            parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"wechat_name":wechat_name,@"token":_token,@"unionid":wechatunion_id};
        }
    }else if ([type isEqualToString:UMShareToQQ]) {
        QQ_name = user.userName;
        platForm = Babel(@"QQ");
        if (login) {
            parameters = @{@"login":@"0",@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"QQ_name":QQ_name};
        }else{
            parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"QQ_name":QQ_name,@"token":_token};
        }
    }else if ([type isEqualToString:UMShareToSina]) {
        weibo_name = user.userName;
        platForm = Babel(@"新浪微博");
        if (login) {
            parameters = @{@"login":@"0",@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"weibo_name":weibo_name};
        }else{
            parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"weibo_name":weibo_name,@"token":_token};
        }
    }else if ([type isEqualToString:UMShareToFacebook]) {
        facebook_name = user.userName;
        platForm = Babel(@"Facebook");
        if (login) {
            parameters = @{@"login":@"0",@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"facebook_name":facebook_name};
        }else{
            parameters = @{@"type_id":type_id,@"account_code": account_id,@"head_url":head_url,@"facebook_name":facebook_name,@"token":_token};
        }
        
    }

    if (parameters) {
        NSLog(@"%@",parameters);
    }else{
        NSLog(@"%@",parameters);
    }
    
    
    [manager POST:CCamLoginURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if (jsonStr.length>3) {
            
            if (login) {
                NSError *error;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                
                NSString *stateMessage =[jsonDic objectForKey:@"status"] ;
                NSString *userToken =[jsonDic objectForKey:@"token"];
                NSString *userID = [jsonDic objectForKey:@"memberid"];
                NSString *groupID = [jsonDic objectForKey:@"groupid"];
                NSString *userZone = [jsonDic objectForKey:@"country"];
                NSString *userName = [jsonDic objectForKey:@"membername"];
                NSString *userImage = [jsonDic objectForKey:@"head_img"];
                
                NSLog(@"用户登录信息:\n--->登录状态:%@\n--->TOKEN:%@\n--->ID:%@\n--->GROUP:%@\n--->COUNTRY:%@",stateMessage,userToken,userID,groupID,userZone);
                
                if ([stateMessage isEqualToString:@"1"] || [stateMessage isEqualToString:@"2"]) {
                    hubMessage = Babel(@"登录成功");//[NSString stringWithFormat:@"%@登录角色相机成功!",platForm];
                }else if ([stateMessage isEqualToString:@"3"]){
                    hubMessage = Babel(@"账号关联成功");
                }
                NSLog(@"%@",userToken);
                [[AuthorizeHelper sharedManager] setUserToken:userToken];
                [[AuthorizeHelper sharedManager] setUserID:userID];
                [[AuthorizeHelper sharedManager] setUserGroup:groupID];
                [[AuthorizeHelper sharedManager] setUserZone:userZone];
                [[AuthorizeHelper sharedManager] setUserName:userName];
                [[AuthorizeHelper sharedManager] setUserImage:userImage];
                
                [self updateDeviceToken];
                
                if (_webVC) {
                    
                    if ([_webVC isKindOfClass:[KLWebViewController class]]) {
                        KLWebViewController*webVC = (KLWebViewController*)_webVC;
                        [webVC refreshWebPage];
                    }
                    
                }
                [self performSelector:@selector(dismissAuthorizeView) withObject:nil afterDelay:1.0];
            }else{
                hubMessage = Babel(@"账号关联成功");
                if (_personInfoVC) {
                    if ([_personInfoVC isKindOfClass:[PersonInfoViewController class]]) {
                        PersonInfoViewController *person = (PersonInfoViewController*)_personInfoVC;
                        [person getPersonalInfo];
                    }
                }
            }
        }else{
            if ([jsonStr isEqualToString:@"-1"] || [jsonStr isEqualToString:@"-4"]) {
                hubMessage = Babel(@"登录失败");
            }else if ([jsonStr isEqualToString:@"-2"]){
                hubMessage = Babel(@"已绑定其他账号");
            }else if ([jsonStr isEqualToString:@"-3"]){
                hubMessage = Babel(@"登录状态失效，请重新登录");
            }else if ([jsonStr isEqualToString:@"-5"]){
                hubMessage = Babel(@"该手机号码尚未注册");
            }else if ([jsonStr isEqualToString:@"-6"]){
                hubMessage = Babel(@"密码错误");
            }else if ([jsonStr isEqualToString:@"-7"]){
                hubMessage = Babel(@"该手机号码已注册或关联其他账号");
            }
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        if ([MessageHelper sharedManager].tabVC) {
            [[MessageHelper sharedManager].tabVC reloadWhenLogin];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0f];
    }];

}
- (void)mobileLoginWithPhone:(NSString *)phone password:(NSString *)password isLogin:(BOOL)login{
    
    
    NSLog(@"%@",phone);
    NSLog(@"%@",password);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_authorizeView.view animated:YES];
//    hud.labelText = @"注册角色相机中";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    if (login) {
        parameters = @{@"type_id": @"1",@"login":@"1",@"account_code": phone,@"password":[self md5:password]};
    }else{
        parameters = @{@"type_id": @"1",@"account_code": phone,@"password":[self md5:password]};
    }
    
    
    [manager POST:CCamLoginURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if (jsonStr.length>3) {
            
            NSError *error;
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            NSString *stateMessage =[jsonDic objectForKey:@"status"] ;
            NSString *userToken =[jsonDic objectForKey:@"token"];
            NSString *userID = [jsonDic objectForKey:@"memberid"];
            NSString *groupID = [jsonDic objectForKey:@"groupid"];
            NSString *userZone = [jsonDic objectForKey:@"country"];
            NSString *userName = [jsonDic objectForKey:@"membername"];
            NSString *userImage = [jsonDic objectForKey:@"head_img"];
            
            NSLog(@"用户登录信息:\n--->登录状态:%@\n--->TOKEN:%@\n--->ID:%@\n--->GROUP:%@\n--->COUNTRY:%@\n--->Name:%@\n--->Image:%@",stateMessage,userToken,userID,groupID,userZone,userName,userImage);
            
            if ([stateMessage isEqualToString:@"1"] || [stateMessage isEqualToString:@"2"]) {
                hubMessage = Babel(@"登录成功");//[NSString stringWithFormat:@"%@登录角色相机成功!",platForm];
            }else if ([stateMessage isEqualToString:@"3"]){
                hubMessage = Babel(@"账号关联成功");
            }
            NSLog(@"%@",userToken);
            [[AuthorizeHelper sharedManager] setUserToken:userToken];
            [[AuthorizeHelper sharedManager] setUserID:userID];
            [[AuthorizeHelper sharedManager] setUserGroup:groupID];
            [[AuthorizeHelper sharedManager] setUserZone:userZone];
            [[AuthorizeHelper sharedManager] setUserName:userName];
            [[AuthorizeHelper sharedManager] setUserImage:userImage];
            
            [self updateDeviceToken];
            
            if (_webVC) {
                
                if ([_webVC isKindOfClass:[KLWebViewController class]]) {
                    KLWebViewController*webVC = (KLWebViewController*)_webVC;
                    [webVC refreshWebPage];
                }
                
            }
            if (!login) {
                _authorizeView.dismissType = @"userinfo";
            }
            [self performSelector:@selector(dismissAuthorizeView) withObject:nil afterDelay:1.0];
            
            if ([MessageHelper sharedManager].tabVC) {
                [[MessageHelper sharedManager].tabVC reloadWhenLogin];
            }
           
        }else{
            if ([jsonStr isEqualToString:@"-1"] || [jsonStr isEqualToString:@"-4"]) {
                hubMessage = Babel(@"登录失败");
            }else if ([jsonStr isEqualToString:@"-2"]){
                hubMessage = Babel(@"已绑定其他账号");
            }else if ([jsonStr isEqualToString:@"-3"]){
                hubMessage = Babel(@"登录状态失效，请重新登录");
            }else if ([jsonStr isEqualToString:@"-5"]){
                hubMessage = Babel(@"该手机号码尚未注册");
            }else if ([jsonStr isEqualToString:@"-6"]){
                hubMessage = Babel(@"密码错误");
            }else if ([jsonStr isEqualToString:@"-7"]){
                hubMessage = Babel(@"该手机号码已注册或关联其他账号");
            }
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0f];
    }];
}
- (void)mobileResetPasswordWithPhone:(NSString *)phone password:(NSString *)password{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_authorizeView.view animated:YES];
    hud.labelText = Babel(@"修改密码中");
    
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
            hubMessage = Babel(@"密码修改失败");
        }else if ([jsonStr isEqualToString:@"1"]) {
            hubMessage = Babel(@"密码修改成功");
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0f];
    }];
}
- (void)unbindPlatformWithTypeID:(NSString *)typeID{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"token": [self getUserToken],@"type_id":typeID};
    
    [manager POST:CCamUnbindURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if ([jsonStr isEqualToString:@"-9"]) {
            hubMessage = Babel(@"唯一绑定账号，无法解除");
        }else {
            hubMessage = Babel(@"账号解除绑定成功");
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        
        if (_personInfoVC) {
            if ([_personInfoVC isKindOfClass:[PersonInfoViewController class]]) {
                PersonInfoViewController *person = (PersonInfoViewController*)_personInfoVC;
                [person getPersonalInfo];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
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
