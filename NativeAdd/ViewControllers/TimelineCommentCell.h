//
//  TimelineCommentCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/20.
//
//

#import <UIKit/UIKit.h>
#import "CCComment.h"

@interface TimelineCommentCell : UITableViewCell
@property (nonatomic,strong) CCComment *comment;
@property (nonatomic,strong) UIButton *userName;
@property (nonatomic,strong) UILabel *commentLabel;
- (void)layoutCommentCell;

@end
