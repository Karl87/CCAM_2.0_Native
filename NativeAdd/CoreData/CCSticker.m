//
//  CCSticker.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import "CCSticker.h"
#import "CCStickerSet.h"
#import "Constants.h"

@implementation CCSticker

- (void)initStickerWith:(NSDictionary *)dic{
    self.image_Preview = GetValidString([dic objectForKey:@"sticker_preview_url"]);
    self.image_Res = GetValidString([dic objectForKey:@"sticker_url"]);
    self.name = GetValidString([dic objectForKey:@"sticker_name"]);
    self.stickerID = GetValidString([dic objectForKey:@"id"]);
    self.stickersetID = GetValidString([dic objectForKey:@"stickerset_id"]);
    self.text = GetValidString([dic objectForKey:@"sticker_text"]);
    self.text_Coordinates = GetValidString([dic objectForKey:@"sticker_text_coordinates"]);
    self.textColor = GetValidString([dic objectForKey:@"sticker_text_color"]);
    self.textFont = GetValidString([dic objectForKey:@"sticker_text_font"]);
    self.textSize = GetValidString([dic objectForKey:@"sticker_text_size"]);
    self.type = GetValidString([dic objectForKey:@"sticker_type"]);
}
@end
