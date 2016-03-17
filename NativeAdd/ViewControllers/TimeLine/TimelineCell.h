//
//  TimelineCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#import <UIKit/UIKit.h>
#import "CCTimeLine.h"

@interface TimelineCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) CCTimeLine *timeline;
@property (nonatomic,strong) UIView* cellBG;
@property (nonatomic,strong) UIImageView *profileImage;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *photoTime;
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIImageView *photoLomo;
@property (nonatomic,strong) UIImageView *photoSpotlight;
@property (nonatomic,strong) UIButton *photoTitle;
@property (nonatomic,strong) UILabel *contestDes;
@property (nonatomic,strong) UIImageView *privacySign;
@property (nonatomic,strong) UILabel *photoDes;
@property (nonatomic,strong) UIButton *photoInput;
@property (nonatomic,strong) UIButton *photoLike;
@property (nonatomic,strong) UIButton *photoMore;
@property (nonatomic,strong) UIView *likeBorder;
@property (nonatomic,strong) UIView *likeView;
@property (nonatomic,strong) UIButton *likesButton;
@property (nonatomic,strong) UIView *messageView;
@property (nonatomic,strong) UITableView *commentTable;
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSMutableArray *likes;
@property (nonatomic,strong) UIView *commentBorder;
@property (nonatomic,strong) UIButton *userButton;

@property (nonatomic,weak) UIViewController *parent;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^likeButtonBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^deleteBlock)(NSIndexPath *indexPath);
- (void)reloadComments;

@end
