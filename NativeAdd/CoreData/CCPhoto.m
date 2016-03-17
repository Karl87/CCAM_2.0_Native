//
//  CCPhoto.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/15.
//
//

#import "CCPhoto.h"
#import "Constants.h"

@implementation CCPhoto

- (void)initPhotoWith:(NSDictionary *)dic{
//    NSLog(@"fuck");
    self.characterID = GetValidString([dic objectForKey:@"character_id"]);
    self.contestID = GetValidString([dic objectForKey:@"contestid"]);
    self.dateline = GetValidString([dic objectForKey:@"dateline"]);
    self.groutID = GetValidString([dic objectForKey:@"groupid"]);
    self.imageContest = GetValidString([dic objectForKey:@"contest"]);
    self.imageFullsize = GetValidString([dic objectForKey:@"big_img"]);
    self.imageMiddle = GetValidString([dic objectForKey:@"middle_img"]);
    self.imageShare = GetValidString([dic objectForKey:@"share_img"]);
    self.like = GetValidString([dic objectForKey:@"like"]);
    NSString *likeState = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"liked"] intValue]];
    self.liked = GetValidString(likeState);
    self.photoChecked = GetValidString([dic objectForKey:@"checked"]);
    self.photoClickNum = GetValidString([dic objectForKey:@"clicknum"]);
//    self.photoDataType = GetValidString([dic objectForKey:@"checked"]);
    self.photoDescription = GetValidString([dic objectForKey:@"description"]);
    self.photoID = GetValidString([dic objectForKey:@"workid"]);
    self.photoIsFinalist = GetValidString([dic objectForKey:@"isfinalist"]);
    self.photoRank = GetValidString([dic objectForKey:@"rank"]);
    self.photoReport = GetValidString([dic objectForKey:@"report"]);
    self.photoShareClickNum = GetValidString([dic objectForKey:@"share_click"]);
    self.photoType = GetValidString([dic objectForKey:@"type"]);
    self.photoWinnerStatus = GetValidString([dic objectForKey:@"winner_status"]);
    self.serieID = GetValidString([dic objectForKey:@"serieid"]);
    self.stageID = GetValidString([dic objectForKey:@"stageid"]);
    self.uploadType = GetValidString([dic objectForKey:@"upload_type"]);
    self.userID = GetValidString([dic objectForKey:@"memberid"]);
    self.userImage = GetValidString([dic objectForKey:@"image_url"]);
    self.userName = GetValidString([dic objectForKey:@"name"]);

}
@end
