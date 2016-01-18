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
@end
