//
//  AuthorizeHelper.h
//  CCamNativeKit
//
//  Created by Karl on 2015/12/1.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizeHelper : NSObject

+ (AuthorizeHelper*)sharedManager;

- (void)callAuthorizeView;
- (void)dismissAuthorizeView;

@end
