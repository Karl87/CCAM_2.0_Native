//
//  TimelineFullCollectionViewCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/4/14.
//
//

#import <UIKit/UIKit.h>
#import "CCTimeLine.h"

@interface TimelineFullCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) CCTimeLine *timeline;

@property (nonatomic,weak) UIViewController *parent;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^likeButtonBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^deleteBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^privateBlock)(NSIndexPath *indexPath);
- (void)setUpTimelineCell;
- (void)reloadComments;
- (void)openUserPageWithID:(NSString*)userID andName:(NSString*)userName;
- (void)callCommentPage:(id)sender;
@end
