//
//  TimelineCommentCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/20.
//
//

#import <UIKit/UIKit.h>
#import "CCComment.h"
#import "TimelineCell.h"

@interface TimelineCommentCell : UITableViewCell
@property (nonatomic,copy) CCComment *comment;
@property (nonatomic,weak) TimelineCell *parent;

@end
