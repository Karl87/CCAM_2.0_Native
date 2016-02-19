//
//  CCCharacter.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import "CCCharacter.h"
#import "CCAnimation.h"
#import "CCSerie.h"
#import "Constants.h"

@implementation CCCharacter

- (void)initCharacterWith:(NSDictionary *)dic{
    
    self.characterID = GetValidString([dic objectForKey:@"character_id"]);
    self.serieID = GetValidString([dic objectForKey:@"serie_id"]);
    self.version = GetValidString([dic objectForKey:@"character_version_new"]);
    
    self.allowOffline = GetValidString([dic objectForKey:@"character_if_offline"]);
    
    self.assetBundle = GetValidString([dic objectForKey:@"character_ios_assetbundle_url"]);
    
    self.dateEnd = GetValidString([dic objectForKey:@"character_expiry_end_date"]);
    self.dateStart = GetValidString([dic objectForKey:@"character_expiry_start_date"]);
    
    self.image_List = GetValidString([dic objectForKey:@"character_list_image_url"]);
    self.image_Mini = GetValidString([dic objectForKey:@"character_mini_image_url"]);
    
    self.nameCN = GetValidString([dic objectForKey:@"character_name_cn"]);
    self.nameEN = GetValidString([dic objectForKey:@"character_name_en"]);
    self.nameJP = GetValidString([dic objectForKey:@"character_name_jp"]);
    self.nameZH = GetValidString([dic objectForKey:@"character_name_zh"]);
    
    self.regionInfo = GetValidString([dic objectForKey:@"character_access_region"]);
    self.regionType = GetValidString([dic objectForKey:@"character_access_region_type"]);
    
}
@end
