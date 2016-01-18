//
//  CCSerie.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCCharacter;

NS_ASSUME_NONNULL_BEGIN

@interface CCSerie : NSManagedObject

-(void)initSerieWith:(NSDictionary*)dic;
- (NSComparisonResult)compareSerieWithPopular:(CCSerie*)serie;
- (NSComparisonResult)compareSerieWithTime:(CCSerie*)serie;

@end

NS_ASSUME_NONNULL_END

#import "CCSerie+CoreDataProperties.h"
