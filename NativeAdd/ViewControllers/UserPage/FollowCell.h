//
//  FollowCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//

#import <UIKit/UIKit.h>

@interface FollowCell : UITableViewCell
@property (nonatomic,copy) NSDictionary *user;
@property (nonatomic,strong) UIImageView *profile;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIButton *funcBtn;
@property (nonatomic,weak) UIViewController *parent;
@end
