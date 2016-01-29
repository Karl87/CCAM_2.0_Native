//
//  TimelineCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#import <UIKit/UIKit.h>
#import "CCTimeLine.h"
#import "MLEmojiLabel.h"

@interface TimelineCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) CCTimeLine *timeline;
@property (nonatomic,strong) UIView* cellBG;
@property (nonatomic,strong) UIImageView *profileImage;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *photoTime;
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIButton *photoTitle;
@property (nonatomic,strong) UILabel *photoDes;
@property (nonatomic,strong) UIButton *photoInput;
@property (nonatomic,strong) UIButton *photoLike;
@property (nonatomic,strong) UIButton *photoMore;
@property (nonatomic,strong) UIView *likeView;
@property (nonatomic,strong) MLEmojiLabel *likeLabel;
@property (nonatomic,strong) UIView *messageView;
@property (nonatomic,strong) UITableView *commentTable;
@property (nonatomic,strong) NSMutableArray *comments;
- (void)reloadComments;
- (void)layoutTimelineCell;
- (void)setLikeLabelText;

@end
