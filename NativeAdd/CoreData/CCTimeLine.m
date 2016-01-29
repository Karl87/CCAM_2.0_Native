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

@implementation CCTimeLine

- (void)initTimelineWith:(NSDictionary *)dic{
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
    self.timelineUserName = GetValidString([dic objectForKey:@"name"]);
    self.timelineUserImage = GetValidString([dic objectForKey:@"image_url"]);
    self.timelineContestID = GetValidString([dic objectForKey:@"contestid"]);
    self.ranking = GetValidString([dic objectForKey:@"ranking"]);
    self.countDown = GetValidString([dic objectForKey:@"countdown"]);
    self.liked = GetValidString([dic objectForKey:@"liked"]);
    self.report = GetValidString([dic objectForKey:@"Report"]);
}
@end
