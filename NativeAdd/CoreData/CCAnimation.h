//
//  CCAnimation.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCCharacter;

NS_ASSUME_NONNULL_BEGIN

@interface CCAnimation : NSManagedObject

-(void)initAnimationWith:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCAnimation+CoreDataProperties.h"
