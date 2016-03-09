//
//  CCMessage.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCMessage : NSManagedObject

- (void)initMessageWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCMessage+CoreDataProperties.h"
