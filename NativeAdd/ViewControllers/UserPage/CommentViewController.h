//
//  CommentViewController.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//

#import <SlackTextViewController/SLKTextViewController.h>
#import "CCTimeLine.h"

@interface CommentViewController : SLKTextViewController
@property (nonatomic,copy) NSString *photoID;
@property (nonatomic,strong) CCTimeLine *timeline;

@end
