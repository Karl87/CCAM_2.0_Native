//
//  CCPhoto.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/24.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCObject.h"
@interface CCPhoto : CCObject

@property (nonatomic, copy) NSString * workid;
@property (nonatomic, copy) NSString * memberid;
@property (nonatomic, copy) NSString * contestid;
@property (nonatomic, copy) NSString * serieid;
@property (nonatomic, copy) NSString * character_id;
@property (nonatomic, copy) NSString * stageid;
@property (nonatomic, copy) NSString * groupid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * contest;
@property (nonatomic, copy) NSString * middle_img;
@property (nonatomic, copy) NSString * big_img;
@property (nonatomic, copy) NSString * share_img;
@property (nonatomic, copy) NSString * photoDescription;
@property (nonatomic, copy) NSString * upnum;
@property (nonatomic, copy) NSString * clicknum;
@property (nonatomic, copy) NSString * share_click;
@property (nonatomic, copy) NSString * checked;
@property (nonatomic, copy) NSString * report;
@property (nonatomic, copy) NSString * isfinalist;
@property (nonatomic, copy) NSString * winner_status;
@property (nonatomic, copy) NSString * dateline;
@property (nonatomic, copy) NSString * like;
@property (nonatomic, copy) NSString * upload_type;
@property (nonatomic, copy) NSString * image_url;
@property (nonatomic, copy) NSString * liked;

- (void)initPhotoWithData:(NSDictionary*)dic;


@end
