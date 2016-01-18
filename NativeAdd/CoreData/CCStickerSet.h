//
//  CCStickerSet.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCStickerSet : NSManagedObject

- (void)initStickerSetWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

#import "CCStickerSet+CoreDataProperties.h"
