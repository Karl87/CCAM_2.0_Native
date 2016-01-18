//
//  CCObject.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/10.
//
//

#import "CCObject.h"

@implementation CCObject
- (NSString *)withoutNull:(id)info{
    if ([info isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        return info;
    }
}
@end
