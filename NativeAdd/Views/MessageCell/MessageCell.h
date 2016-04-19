//
//  MessageCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/28.
//
//

#import <UIKit/UIKit.h>
#import "CCMessage.h"

@interface MessageCell : UITableViewCell
@property (nonatomic,copy) CCMessage *message;
@property (nonatomic,weak) UIViewController *parent;
@end
