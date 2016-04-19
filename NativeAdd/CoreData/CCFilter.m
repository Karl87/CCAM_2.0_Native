//
//  CCFilter.m
//  Unity-iPhone
//
//  Created by Karl on 2016/4/13.
//
//

#import "CCFilter.h"
#import "Constants.h"

@implementation CCFilter

- (void)initFilterWith:(NSDictionary *)dic{
    self.image_mini = GetValidString([dic objectForKey:@"filter_image_mini"]);
    self.name_file = GetValidString([dic objectForKey:@"filter_file_name"]);
    self.name_cn = GetValidString([dic objectForKey:@"filter_name"]);
    self.name_en = GetValidString([dic objectForKey:@"filter_name_en"]);
    self.name_zh = GetValidString([dic objectForKey:@"filter_name_zh"]);
}
@end
