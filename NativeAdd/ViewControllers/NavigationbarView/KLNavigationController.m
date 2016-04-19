//
//  KLNavigationController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/18.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLNavigationController.h"

@implementation KLNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle

{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

@end
