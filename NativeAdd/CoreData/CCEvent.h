//
//  CCEvent.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCEvent : NSManagedObject

-(void)initEventWith:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCEvent+CoreDataProperties.h"
