//
//  CCCharacter.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCAnimation, CCSerie;

NS_ASSUME_NONNULL_BEGIN

@interface CCCharacter : NSManagedObject

-(void)initCharacterWith:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCCharacter+CoreDataProperties.h"
