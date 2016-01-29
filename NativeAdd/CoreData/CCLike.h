//
//  CCLike.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCTimeLine;

NS_ASSUME_NONNULL_BEGIN

@interface CCLike : NSManagedObject

- (void)initLikeWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCLike+CoreDataProperties.h"
