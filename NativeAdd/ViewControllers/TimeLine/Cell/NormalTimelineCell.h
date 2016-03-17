//
//  NormalTimelineCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/10.
//
//

#import <UIKit/UIKit.h>
#import "CCTimeLine.h"

@interface NormalTimelineCell : UITableViewCell

@property (nonatomic,strong) CCTimeLine *timeline;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^likeButtonBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^commentButtonBlock)(NSIndexPath *indexPath);

@property (nonatomic,weak) UIViewController *parent;

@end
