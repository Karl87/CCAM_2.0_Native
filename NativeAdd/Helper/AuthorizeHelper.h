//
//  AuthorizeHelper.h
//  CCamNativeKit
//
//  Created by Karl on 2015/12/1.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface AuthorizeHelper : NSObject

+ (AuthorizeHelper*)sharedManager;

- (NSString *)getUserToken;
- (void)setUserToken:(NSString *)token;

- (void)callAuthorizeView;
- (void)dismissAuthorizeView;
//check token
- (BOOL)checkToken;
//logout
- (void)logout;
//social login
- (void)getSocialPlatformInfoWithTypeID:(NSString*)typeID shareType:(SSDKPlatformType)type isLogin:(BOOL)isLogin;
- (void)loginWithTypeID:(NSString *)typeID shareType:(SSDKPlatformType)type userInfo:(SSDKUser *)user isLogin:(BOOL)login;
//mobile login
- (void)mobileLoginWithPhone:(NSString*)phone password:(NSString*)password isLogin:(BOOL)login;
//mobile reset psw
- (void)mobileResetPasswordWithPhone:(NSString*)phone password:(NSString*)password;
@end
