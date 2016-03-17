//
//  KLWebViewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/23.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLViewController.h"
#import "CCEvent.h"
@interface KLWebViewController : KLViewController

@property (nonatomic,copy) NSString * webURL;
@property (nonatomic,strong) CCEvent *event;
@end
