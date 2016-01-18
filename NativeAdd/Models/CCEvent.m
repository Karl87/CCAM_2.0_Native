//
//  CCEvent.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/17.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCEvent.h"
@implementation CCEvent

-(void)initEventWithData:(NSDictionary *)dic{
    
    self.eventCountDown =[self withoutNull:[dic objectForKey:@"count_down"]];
    self.eventImageURLCn =[self withoutNull:[dic objectForKey:@"image_url"]];
    self.eventName =[self withoutNull:[dic objectForKey:@"name"]];
    self.eventURL =[self withoutNull:[dic objectForKey:@"url"]];
    self.eventCount =[self withoutNull:[dic objectForKey:@"count"]];
    self.eventIsStart =[self withoutNull:[dic objectForKey:@"is_start"]];
    self.eventImageURLEn =[self withoutNull:[dic objectForKey:@"image_url_en"]];
    self.eventImageURLZh =[self withoutNull:[dic objectForKey:@"image_url_zh"]];
}

@end
