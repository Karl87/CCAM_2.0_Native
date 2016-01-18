//
//  SettingHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import <Foundation/Foundation.h>

@interface SettingHelper : NSObject
+ (SettingHelper*)sharedManager;
- (NSString*)getSettingAttributeWithKey:(NSString*)key;
- (void)setSettingAttributeWithKey:(NSString*)key andValue:(NSString*)value;
@end
