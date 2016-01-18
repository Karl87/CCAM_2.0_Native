//
//  NSString+KL.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/10.
//
//

#import "NSString+KL.h"

@implementation NSString (KL)

- (NSString*)stringAddHost{
    
    NSString* string = [NSString stringWithFormat:@"%@%@",CCamHost,self];
    return string;
}

- (NSString*)stringWithoutNull{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        return self;
    }
}
@end
