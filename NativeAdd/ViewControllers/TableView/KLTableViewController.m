//
//  KLTableViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/17.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLTableViewController.h"

@interface KLTableViewController ()

@end

@implementation KLTableViewController

- (KLTableView*)returnTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle backgroundColor:(UIColor*)backgroundColor contentInset:(UIEdgeInsets)contentInset scrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets parentView:(UIView*)parentView{
    
    KLTableView *tableView = [[KLTableView alloc] initWithFrame:rect style:style];
    [tableView setContentInset:contentInset];
    [tableView setScrollIndicatorInsets:scrollIndicatorInsets];
    [tableView setSeparatorStyle:separatorStyle];
    [tableView setBackgroundColor:backgroundColor];
    [parentView addSubview:tableView];
    
    return tableView;
}



@end
