//
//  SettingHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import <Foundation/Foundation.h>

@interface SettingHelper : NSObject
+ (SettingHelper*)sharedManager;
- (NSString*)getSettingAttributeWithKey:(NSString*)key;
- (void)setSettingAttributeWithKey:(NSString*)key andValue:(NSString*)value;

- (NSString *)getCurrentLanguage;

- (void)initUMengAnalytics;
- (void)analyticsUserSignInWithUserID:(NSString*)userid provider:(NSString*)provider;
- (void)analyticsUserSignOut;

- (void)initUMessage:(NSDictionary*)launchOptions;
- (void)registerDeviceToken:(NSData*)deviceToken;
- (void)unregisterForRemoteNotifications;
- (void)didReceiveRemoteNotification:(NSDictionary*)userInfo;
- (void)setUmessageAlias:(NSString *)alias type:(NSString*)type;
- (void)setUmessageShowWhenAppRuning:(BOOL)show;
- (void)setUmessageChannel:(NSString*)channel;
@end
