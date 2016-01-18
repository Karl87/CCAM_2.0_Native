//
//  CCPhoto.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/24.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCPhoto.h"
@implementation CCPhoto

- (void)initPhotoWithData:(NSDictionary*)dic{
    self.workid = [self withoutNull:[dic objectForKey:@"workid"]] ;
    self.middle_img =[ self withoutNull:[dic objectForKey:@"middle_img"]];
    self.big_img = [self withoutNull:[dic objectForKey:@"big_img"]];
    self.name = [self withoutNull:[dic objectForKey:@"name"]];
    self.photoDescription =[self withoutNull:[dic objectForKey:@"description"]];
    self.image_url = [self withoutNull:[dic objectForKey:@"image_url"]];
    self.like = [self withoutNull:[dic objectForKey:@"like"]];
    self.liked = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"liked"] intValue]];
}
@end
