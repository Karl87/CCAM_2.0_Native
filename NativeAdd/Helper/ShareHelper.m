//
//  ShareHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import "ShareHelper.h"

@implementation ShareHelper
+ (ShareHelper*)sharedManager
{
    static dispatch_once_t pred;
    static ShareHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
@end
