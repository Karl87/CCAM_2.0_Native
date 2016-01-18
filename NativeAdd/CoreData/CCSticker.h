//
//  CCSticker.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCStickerSet;

NS_ASSUME_NONNULL_BEGIN

@interface CCSticker : NSManagedObject

- (void)initStickerWith:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END

#import "CCSticker+CoreDataProperties.h"
