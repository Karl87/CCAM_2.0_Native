//
//  EventCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/11.
//
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
@property (nonatomic,strong) UIView *eventBG;
@property (nonatomic,strong) UIImageView *eventImage;
@property (nonatomic,strong) UIButton *eventTitle;
@property (nonatomic,strong) UIButton *eventPicNum;
@property (nonatomic,strong) UILabel *eventDescriptrion;
@end
