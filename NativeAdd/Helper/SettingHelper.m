//
//  SettingHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import "SettingHelper.h"

@implementation SettingHelper
+ (SettingHelper*)sharedManager
{
    static dispatch_once_t pred;
    static SettingHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (NSString*)getSettingAttributeWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:key]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setSettingAttributeWithKey:(NSString *)key andValue:(NSString *)value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
}
@end
