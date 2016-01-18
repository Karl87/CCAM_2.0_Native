//
//  KLTableViewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/17.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLViewController.h"
#import "KLTableView.h"

@interface KLTableViewController : KLViewController

- (KLTableView*)returnTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle backgroundColor:(UIColor*)backgroundColor contentInset:(UIEdgeInsets)contentInset scrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets parentView:(UIView*)parentView;
@end
