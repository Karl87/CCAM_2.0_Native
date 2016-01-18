//
//  CCEvent.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/17.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCObject.h"
@interface CCEvent : CCObject

//活动倒计时
@property (nonatomic, copy) NSString *eventCountDown;
//活动背景图片，简体中文
@property (nonatomic, copy) NSString *eventImageURLCn;
//活动名称
@property (nonatomic, copy) NSString *eventName;
//活动链接
@property (nonatomic, copy) NSString *eventURL;
//活动图片数量
@property (nonatomic, copy) NSString *eventCount;
//活动是否开始
@property (nonatomic, copy) NSString *eventIsStart;
//活动背景图片，英文
@property (nonatomic, copy) NSString *eventImageURLEn;
//活动背景图片，繁体中文
@property (nonatomic, copy) NSString *eventImageURLZh;
/**
 由数据初始化Activity
 */
- (void)initEventWithData:(NSDictionary*)dic;

@end
