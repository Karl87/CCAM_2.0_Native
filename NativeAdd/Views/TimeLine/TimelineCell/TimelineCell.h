//
//  TimelineCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#import <UIKit/UIKit.h>
#import "CCTimeLine.h"

@interface TimelineCell : UITableViewCell

@property (nonatomic,strong) CCTimeLine *timeline;

@property (nonatomic,weak) UIViewController *parent;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^likeButtonBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^deleteBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^privateBlock)(NSIndexPath *indexPath);

- (void)reloadComments;
- (void)openUserPageWithID:(NSString*)userID andName:(NSString*)userName;
- (void)callCommentPage:(id)sender;
@end
