//
//  CCMessage.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/28.
//
//

#import "CCMessage.h"
#import "Constants.h"

@implementation CCMessage

- (void)initMessageWith:(NSDictionary *)dic{
    self.message = GetValidString([dic objectForKey:@"message"]);
    self.messageID = GetValidString([dic objectForKey:@"mid"]);
    self.messagePhoto = GetValidString([dic objectForKey:@"contest"]);
    self.messageType = GetValidString([dic objectForKey:@"type"]);
    self.messageUserImage = GetValidString([dic objectForKey:@"image_url"]);
    self.messageUserName = GetValidString([dic objectForKey:@"name"]);
    
    self.contestID = GetValidString([dic objectForKey:@"contestid"]);
    self.creatTime = GetValidString([dic objectForKey:@"createtime"]);
    self.ifRead = GetValidString([dic objectForKey:@"ifread"]);
    self.ifTop = GetValidString([dic objectForKey:@"top"]);
    self.photoID = GetValidString([dic objectForKey:@"workid"]);
    self.replyUserID = GetValidString([dic objectForKey:@"bymemberid"]);
    self.userID = GetValidString([dic objectForKey:@"memberid"]);

}
@end
