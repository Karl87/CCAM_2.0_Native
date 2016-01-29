//
//  ShareHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import <Foundation/Foundation.h>

@interface ShareHelper : NSObject
+ (ShareHelper*)sharedManager;
- (void)initShareSDK;
@end
