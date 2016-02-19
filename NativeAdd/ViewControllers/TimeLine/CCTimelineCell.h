//
//  CCTimelineCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/19.
//
//

#import <UIKit/UIKit.h>
#import "CCTimeLine.h"

@interface CCTimelineCell : UITableViewCell

@property (nonatomic,strong) CCTimeLine *timeline;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@end
