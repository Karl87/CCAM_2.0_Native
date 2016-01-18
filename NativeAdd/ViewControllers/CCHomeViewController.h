//
//  CCHomeVIewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/17.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLTableViewController.h"

@interface CCHomeViewController : KLTableViewController

@property (nonatomic,strong) UIScrollView* backgroundView;
@property (nonatomic,strong) KLTableView* serieTable;
@property (nonatomic,strong) KLTableView* eventTable;

@end
