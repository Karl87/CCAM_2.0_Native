//
//  CCTimeLine.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/18.
//
//

#import "CCTimeLine.h"
#import "Constants.h"

@implementation CCTimeLine

- (void)initTimelineWith:(NSDictionary *)dic{
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
    self.comment = GetValidString([dic objectForKey:@"comment"]);
    self.ranking = GetValidString([dic objectForKey:@"ranking"]);
    self.lastLikeInfo = GetValidString([dic objectForKey:@"last_like"]);
    self.countDown = GetValidString([dic objectForKey:@"countdown"]);
    self.liked = GetValidString([dic objectForKey:@"liked"]);
    self.report = GetValidString([dic objectForKey:@"Report"]);
    NSLog(@"%@",self);
}

@end
