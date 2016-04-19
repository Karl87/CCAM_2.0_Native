//
//  ViewHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import <Foundation/Foundation.h>

#import "CCHomeViewController.h"
#import "CCUserViewController.h"

@interface ViewHelper : NSObject

+ (ViewHelper*)sharedManager;
- (UIViewController *)getCurrentVC;



@end