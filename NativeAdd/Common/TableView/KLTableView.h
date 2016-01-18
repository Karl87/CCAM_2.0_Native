//
//  KLTableView.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/18.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@interface KLTableView : UITableView

@property (nonatomic,strong) MJRefreshNormalHeader *refresh;

@end
