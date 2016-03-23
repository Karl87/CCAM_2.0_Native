//
//  CCEvent.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/15.
//
//

#import "CCEvent.h"
#import "Constants.h"

@implementation CCEvent

- (void)initEventWith:(NSDictionary *)dic{
    self.eventCount = GetValidString([dic objectForKey:@"count"]);
    self.eventCountDown = GetValidString([dic objectForKey:@"count_down"]);
    self.eventDescriptionCn = GetValidString([dic objectForKey:@"description"]);
    self.eventDescriptionEn = GetValidString([dic objectForKey:@"description_en"]);
    self.eventDescriptionZh = GetValidString([dic objectForKey:@"description_zh"]);
    self.eventImageURLCn = GetValidString([dic objectForKey:@"image_url"]);
    self.eventImageURLEn = GetValidString([dic objectForKey:@"image_url_en"]);
    self.eventImageURLZh = GetValidString([dic objectForKey:@"image_url_zh"]);
    self.eventIsStart = GetValidString([dic objectForKey:@"is_start"]);
    self.eventName = GetValidString([dic objectForKey:@"name"]);
    self.eventURL = GetValidString([dic objectForKey:@"url"]);
    self.shareImage = GetValidString([dic objectForKey:@"share_image"]);
    self.shareSubtitle = GetValidString([dic objectForKey:@"share_title"]);
    self.shareTitle = GetValidString([dic objectForKey:@"share_title2"]);
}
@end
