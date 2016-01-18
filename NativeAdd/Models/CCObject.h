//
//  CCObject.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/10.
//
//

#import <Foundation/Foundation.h>

@interface CCObject : NSObject

@property (assign) int number;

- (NSString *)withoutNull:(id)info;
@end
