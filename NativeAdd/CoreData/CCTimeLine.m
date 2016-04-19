//
//  CCTimeLine.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//

#import "CCTimeLine.h"
#import "CCComment.h"
#import "CCLike.h"
#import "Constants.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern const CGFloat maxContentLabelHeight;

@implementation CCTimeLine
@synthesize shouldShowMoreButton = _shouldShowMoreButton;

- (void)initTimelineWith:(NSDictionary *)dic{
    self.checked = GetValidString([dic objectForKey:@"checked"]);
    self.shareURL = GetValidString([dic objectForKey:@"shareurl"]);
    self.shareTitle = GetValidString([dic objectForKey:@"sharetitle"]);
    self.shareSubTitle = GetValidString([dic objectForKey:@"sharesubtitle"]);
    self.dateline = GetValidString([dic objectForKey:@"dateline"]);
    self.cNameZH = GetValidChar([dic objectForKey:@"zh_name"]);
    self.cNameEN = GetValidChar([dic objectForKey:@"en_name"]);
    self.cNameCN = GetValidChar([dic objectForKey:@"cname"]);
    self.timelineID = GetValidString([dic objectForKey:@"workid"]);
    self.image_contest = GetValidString([dic objectForKey:@"contest"]);
    self.image_fullsize = GetValidString([dic objectForKey:@"big_img"]);
    self.timelineUserID = GetValidString([dic objectForKey:@"memberid"]);
    self.image_share = GetValidString([dic objectForKey:@"share_img"]);
    self.timelineDes = GetValidString([dic objectForKey:@"description"]);
    self.likeCount = GetValidString([dic objectForKey:@"like"]);
    self.commentCount = GetValidString([dic objectForKey:@"comment_count"]);
    self.timelineUserName = GetValidString([dic objectForKey:@"name"]);
    self.timelineUserImage = GetValidString([dic objectForKey:@"image_url"]);
    self.timelineContestID = GetValidString([dic objectForKey:@"contestid"]);
    self.ranking = GetValidString([dic objectForKey:@"ranking"]);
    NSString *countDown = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"countdown"] intValue]];
    self.countDown = GetValidString(countDown);
    NSString *likeState = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"liked"] intValue]];
    self.liked = GetValidString(likeState);
    NSString *followState = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"follow"] intValue]];
    self.followed = GetValidString(followState);
    self.report = GetValidString([dic objectForKey:@"Report"]);
    self.dateStart = GetValidString([dic objectForKey:@"start_date"]);
    self.dateEnd = GetValidString([dic objectForKey:@"end_date"]);
    self.timelineContestURL = GetValidString([dic objectForKey:@"contest_url"]);
}
//- (NSString *)timelineDes{
//    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
//    CGRect textRect = [self.timelineDes boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
//    if (textRect.size.height > maxContentLabelHeight) {
//        _shouldShowMoreButton = YES;
//    } else {
//        _shouldShowMoreButton = NO;
//    }
//    
//    return self.timelineDes;
//}
//- (void)setIsOpening:(BOOL)isOpening
//{
//    if (!_shouldShowMoreButton) {
//        self.isOpening = NO;
//    } else {
//        self.isOpening = isOpening;
//    }
//}
@end
