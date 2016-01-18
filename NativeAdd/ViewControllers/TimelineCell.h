//
//  TimelineCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#import <UIKit/UIKit.h>

@interface TimelineCell : UITableViewCell
@property (nonatomic,strong) UIView* cellBG;
@property (nonatomic,strong) UIImageView *profileImage;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIButton *photoTitle;
@property (nonatomic,strong) UILabel *photoDes;
@property (nonatomic,strong) UIButton *photoInput;
@property (nonatomic,strong) UIButton *photoLike;
@property (nonatomic,strong) UIButton *photoMore;
@property (nonatomic,strong) UIView *likeView;
@property (nonatomic,strong) UIView *messageView;
@end
