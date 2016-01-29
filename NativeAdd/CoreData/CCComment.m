//
//  CCComment.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//

#import "CCComment.h"
#import "CCTimeLine.h"
#import "Constants.h"

@implementation CCComment

- (void)initCommentWith:(NSDictionary *)dic{
    
    self.userID = GetValidString([dic objectForKey:@"memberid"]);
    self.userName = GetValidString([dic objectForKey:@"membername"]);
    self.userImage = GetValidString([dic objectForKey:@"head_url"]);
    self.commentID = GetValidString([dic objectForKey:@"cid"]);
    self.comment = GetValidString([dic objectForKey:@"message"]);
    self.photoID = GetValidString([dic objectForKey:@"workid"]);
    self.replyID = GetValidString([dic objectForKey:@"replyid"]);
    self.dateline = GetValidString([dic objectForKey:@"dateline"]);
    
}
@end
