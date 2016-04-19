//
//  CCDiscoveryViewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLCollectionViewController.h"
#import "CCamHelper.h"
@interface CCHomeViewController : KLCollectionViewController
@property (nonatomic,strong) NSMutableArray *reloadIndexs;

- (void)reloadMessageHeader;
- (void)returnTopPosition;
- (void)reloadInfo;
@end
