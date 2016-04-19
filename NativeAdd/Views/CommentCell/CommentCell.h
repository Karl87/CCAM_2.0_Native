//
//  CommentCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//

#import <UIKit/UIKit.h>
#import "CCComment.h"

@interface CommentCell : UITableViewCell
@property (nonatomic,copy) CCComment *comment;
@property (nonatomic,weak) UIViewController *parent;
@property (nonatomic,assign) BOOL isDescription;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
