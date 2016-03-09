//
//  CCLike.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//

#import "CCLike.h"
#import "CCTimeLine.h"
#import "Constants.h"

@implementation CCLike

- (void)initLikeWith:(NSDictionary *)dic{
    self.photoID = GetValidString([dic objectForKey:@"id"]);
    self.userID = GetValidString([dic objectForKey:@"memberid"]);
    self.userName = GetValidString([dic objectForKey:@"member_name"]);
    self.dateline = GetValidString([dic objectForKey:@"dateline"]);
    self.userImage = GetValidString([dic objectForKey:@"member_head"]);
}
@end
