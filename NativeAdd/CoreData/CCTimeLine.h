//
//  CCTimeLine.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCComment, CCLike;

NS_ASSUME_NONNULL_BEGIN

@interface CCTimeLine : NSManagedObject

- (void)initTimelineWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCTimeLine+CoreDataProperties.h"
