//
//  TestAnimationViewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/30.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLViewController.h"

@interface CCLaunchViewController : KLViewController
@property (nonatomic,strong) NSString *dismissType;
- (void)smsTimerCount:(NSInteger)second;

@end
