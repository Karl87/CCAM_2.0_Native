//
//  CCPhoto.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPhoto : NSManagedObject

- (void)initPhotoWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCPhoto+CoreDataProperties.h"
