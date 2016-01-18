//
//  CCUser.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/16.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCObject.h"
@interface CCUser : CCObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userGroupID;
@property (nonatomic, copy) NSString *userImageURL;
@property (nonatomic, copy) NSString *userTrueName;

@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userWechatName;
@property (nonatomic, copy) NSString *userWeiboName;
@property (nonatomic, copy) NSString *userQQName;
@property (nonatomic, copy) NSString *userFacebookName;

@property (nonatomic, copy) NSString *userCountry;
@property (nonatomic, copy) NSString *userLocation;
@property (nonatomic, copy) NSString *userAddress;
@property (nonatomic, copy) NSString *userGender;
@property (nonatomic, copy) NSString *userBirth;

@property (nonatomic, copy) NSString *userCSNName;
@property (nonatomic, copy) NSString *userCSNPhone;
@property (nonatomic, copy) NSString *userCSNAddress;

@property (nonatomic, copy) NSString *userLikeURL;
@property (nonatomic, copy) NSString *userContestURL;
@property (nonatomic, copy) NSString *userWorksURL;

@property (nonatomic, copy) NSString *userFollowsURL;
@property (nonatomic, copy) NSString *userFansURL;

@property (nonatomic, copy) NSString *userWorksCount;
@property (nonatomic, copy) NSString *userLikesCount;
@property (nonatomic, copy) NSString *userLikePhotoesCount;
@property (nonatomic, copy) NSString *userContestsCount;
@property (nonatomic, copy) NSString *userFansCount;
@property (nonatomic, copy) NSString *userFollowsCount;

- (void)setUser:(CCUser*)user key:(NSString*)key value:(NSString*)value;

@end
