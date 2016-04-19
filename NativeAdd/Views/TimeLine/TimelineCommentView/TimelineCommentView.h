//
//  TimelineCommentView.h
//  Unity-iPhone
//
//  Created by Karl on 2016/4/7.
//
//

#import <UIKit/UIKit.h>

@interface TimelineCommentView : UIView

@property (nonatomic,strong) UITableViewCell *parent;

- (void)setupCommentItemsArray:(NSArray*)comments;

@end
