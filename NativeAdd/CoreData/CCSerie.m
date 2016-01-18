//
//  CCSerie.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import "CCSerie.h"
#import "CCCharacter.h"
#import "Constants.h"
@implementation CCSerie

-(void)initSerieWith:(NSDictionary *)dic{
    
    self.allFilter = GetValidString([dic objectForKey:@"serie_filter_flag"]);
    self.allowErase = GetValidString([dic objectForKey:@"serie_earse_flag"]);
    self.allowMultiple = GetValidString([dic objectForKey:@"serie_multiple_flag"]);
    self.allowSticker = GetValidString([dic objectForKey:@"serie_stamp_flag"]);
    
    self.dateEnd = GetValidString([dic objectForKey:@"serie_expiry_end_date"]);
    self.dateStart = GetValidString([dic objectForKey:@"serie_expiry_start_date"]);
    
    self.id_Sticker = GetValidString([dic objectForKey:@"serie_stamp_id"]);
    
    self.image_Inner = GetValidString([dic objectForKey:@"serie_inner_image_url"]);
    self.image_List = GetValidString([dic objectForKey:@"serie_list_image_url"]);
    self.image_Mini = GetValidString([dic objectForKey:@"serie_list_mini_image_url"]);
    self.image_Watermark = GetValidString([dic objectForKey:@"serie_watermark_url"]);
    
    self.indexLastest = GetValidNumber([dic objectForKey:@"dateline"]);
    self.indexPopular = GetValidNumber([dic objectForKey:@"pic_num"]);
    self.indexRecommend = GetValidNumber([dic objectForKey:@""]);
    
    self.nameCN = GetValidString([dic objectForKey:@"serie_name_cn"]);
    self.nameEN = GetValidString([dic objectForKey:@"serie_name_en"]);
    self.nameJP = GetValidString([dic objectForKey:@"serie_name_jp"]);
    self.nameZH = GetValidString([dic objectForKey:@"serie_name_zh"]);
    
    self.regionType = GetValidString([dic objectForKey:@"serie_access_type"]);
    self.regionInfo = GetValidString([dic objectForKey:@"serie_access_region"]);
    self.redirectURL = GetValidString([dic objectForKey:@"serie_redirect_url"]);
    
    self.serieID = GetValidString([dic objectForKey:@"serie_id"]);
}
- (NSComparisonResult)compareSerieWithPopular:(CCSerie*)serie{
    NSComparisonResult result = [[NSNumber numberWithInt:[serie.indexPopular intValue]] compare:[NSNumber numberWithInt:[self.indexPopular intValue]]];
    return result;
}
- (NSComparisonResult)compareSerieWithTime:(CCSerie*)serie{
    NSComparisonResult result = [[NSNumber numberWithInt:[serie.indexLastest intValue]] compare:[NSNumber numberWithInt:[self.indexLastest intValue]]];
    return result;
}
@end
