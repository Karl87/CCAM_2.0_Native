//
//  ViewHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import "ViewHelper.h"

@implementation ViewHelper

+ (ViewHelper*)sharedManager
{
    static dispatch_once_t pred;
    static ViewHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
@end
