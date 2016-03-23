//
//  SettingHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import "SettingHelper.h"
#import "CCamHelper.h"

#import <UMengAnalytics/MobClick.h>
#import "UMessage.h"
#import "Constants.h"

@implementation SettingHelper
+ (SettingHelper*)sharedManager
{
    static dispatch_once_t pred;
    static SettingHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (NSString*)getSettingAttributeWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:key]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setSettingAttributeWithKey:(NSString *)key andValue:(NSString *)value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (!value) {
        value = @"";
    }
    [userDefaults setObject:value forKey:key];
}
- (NSString*)getCurrentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}
#pragma mark - UMessage delegate
- (void)initUMessage:(NSDictionary *)launchOptions{
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMessageKey launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(iOS8)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
}
- (void)registerDeviceToken:(NSData *)deviceToken{
    [UMessage registerDeviceToken:deviceToken];
    NSString *tokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                           stringByReplacingOccurrencesOfString: @">" withString: @""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[AuthorizeHelper sharedManager] setDeviceToken:tokenStr];
}
- (void)unregisterForRemoteNotifications{
    [UMessage unregisterForRemoteNotifications];
}
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UMessage didReceiveRemoteNotification:userInfo];
}
- (void)setUmessageAlias:(NSString *)alias type:(NSString*)type{
    [UMessage setAlias:alias type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
        
    }];
}
- (void)setUmessageShowWhenAppRuning:(BOOL)show{
    [UMessage setAutoAlert:show];
}
- (void)setUmessageChannel:(NSString *)channel{
    [UMessage setChannel:channel];
}
#pragma mark - UMengAnalytics
- (void)initUMengAnalytics{
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if([identifier isEqualToString:@"com.icm.c-cam"]){
       [MobClick startWithAppkey:UMengKey reportPolicy:BATCH channelId:@"AppStore"];
    }else{
       [MobClick startWithAppkey:UMengKey reportPolicy:BATCH channelId:@"Enterprise"];
    }
    [MobClick setEncryptEnabled:YES];
    [MobClick setCrashReportEnabled:YES];
}
- (void)analyticsUserSignInWithUserID:(NSString *)userid provider:(NSString *)provider{
    if ([provider isEqualToString:@""]) {
        [MobClick profileSignInWithPUID:userid];
    }else{
        [MobClick profileSignInWithPUID:userid provider:provider];
    }
}
- (void)analyticsUserSignOut{
    [MobClick profileSignOff];
}
@end
