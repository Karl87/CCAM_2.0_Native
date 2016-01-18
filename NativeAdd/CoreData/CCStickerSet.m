//
//  CCStickerSet.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import "CCStickerSet.h"
#import "Constants.h"

@implementation CCStickerSet

- (void)initStickerSetWith:(NSDictionary *)dic{
    self.image_List = GetValidString([dic objectForKey:@"stickerset_list_image_url"]);
    self.image_Mini = GetValidString([dic objectForKey:@"stickerset_image_url"]);
    self.image_Res = GetValidString([dic objectForKey:@"stickerset_mini_image_url"]);
    self.nameCN = GetValidString([dic objectForKey:@"stickerset_name_cn"]);
    self.nameEN = GetValidString([dic objectForKey:@"stickerset_name_en"]);
    self.nameJP = GetValidString([dic objectForKey:@"stickerset_name_jp"]);
    self.nameZH = GetValidString([dic objectForKey:@"stickerset_name_zh"]);
    self.stickersetID = GetValidString([dic objectForKey:@"stickerset_id"]);
}
@end
