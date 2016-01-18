//
//  CCUser.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/16.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCUser.h"

@implementation CCUser

- (void)setUser:(CCUser*)user key:(NSString*)key value:(NSString*)value{
    if ([key isEqualToString:@"userID"]) {
        user.userID = value;
    }else if ([key isEqualToString:@"userName"]) {
        user.userName = value;
    }else if ([key isEqualToString:@"userGroupID"]) {
        user.userGroupID = value;
    }else if ([key isEqualToString:@"userImageURL"]) {
        user.userImageURL = value;
    }else if ([key isEqualToString:@"userTrueName"]) {
        user.userTrueName = value;
    }else if ([key isEqualToString:@"userEmail"]) {
        user.userEmail = value;
    }else if ([key isEqualToString:@"userPhone"]) {
        user.userPhone = value;
    }else if ([key isEqualToString:@"userWechatName"]) {
        user.userWechatName = value;
    }else if ([key isEqualToString:@"userWeiboName"]) {
        user.userWeiboName = value;
    }else if ([key isEqualToString:@"userQQName"]) {
        user.userQQName = value;
    }else if ([key isEqualToString:@"userFacebookName"]) {
        user.userFacebookName = value;
    }else if ([key isEqualToString:@"userCountry"]) {
        user.userCountry = value;
    }else if ([key isEqualToString:@"userLocation"]) {
        user.userLocation = value;
    }else if ([key isEqualToString:@"userAddress"]) {
        user.userAddress = value;
    }else if ([key isEqualToString:@"userGender"]) {
        user.userGender = value;
    }else if ([key isEqualToString:@"userBirth"]) {
        user.userBirth = value;
    }else if ([key isEqualToString:@"userCSNName"]) {
        user.userCSNName = value;
    }else if ([key isEqualToString:@"userCSNPhone"]) {
        user.userCSNPhone = value;
    }else if ([key isEqualToString:@"userCSNAddress"]) {
        user.userCSNAddress = value;
    }else if ([key isEqualToString:@"userLikeURL"]) {
        user.userLikeURL = value;
    }else if ([key isEqualToString:@"userContestURL"]) {
        user.userContestURL = value;
    }else if ([key isEqualToString:@"userWorksURL"]) {
        user.userWorksURL = value;
    }else if ([key isEqualToString:@"userFollowsURL"]) {
        user.userFollowsURL = value;
    }else if ([key isEqualToString:@"userFansURL"]) {
        user.userFansURL = value;
    }else if ([key isEqualToString:@"userWorksCount"]) {
        user.userWorksCount = value;
    }else if ([key isEqualToString:@"userLikesCount"]) {
        user.userLikesCount = value;
    }else if ([key isEqualToString:@"userLikePhotoesCount"]) {
        user.userLikePhotoesCount = value;
    }else if ([key isEqualToString:@"userContestsCount"]) {
        user.userContestsCount = value;
    }else if ([key isEqualToString:@"userFansCount"]) {
        user.userFansCount = value;
    }else if ([key isEqualToString:@"userFollowsCount"]) {
        user.userFollowsCount = value;
    }
}

@end
