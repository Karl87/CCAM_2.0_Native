//
//  CCFilter.h
//  Unity-iPhone
//
//  Created by Karl on 2016/4/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFilter : NSManagedObject

- (void)initFilterWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCFilter+CoreDataProperties.h"
