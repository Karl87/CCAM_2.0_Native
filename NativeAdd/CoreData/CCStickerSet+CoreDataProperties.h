//
//  CCStickerSet+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCStickerSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCStickerSet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *stickersetID;
@property (nullable, nonatomic, retain) NSString *nameCN;
@property (nullable, nonatomic, retain) NSString *nameEN;
@property (nullable, nonatomic, retain) NSString *nameJP;
@property (nullable, nonatomic, retain) NSString *nameZH;
@property (nullable, nonatomic, retain) NSString *image_List;
@property (nullable, nonatomic, retain) NSString *image_Res;
@property (nullable, nonatomic, retain) NSString *image_Mini;
@property (nullable, nonatomic, retain) NSOrderedSet<NSManagedObject *> *stickers;

@end

@interface CCStickerSet (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inStickersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStickersAtIndex:(NSUInteger)idx;
- (void)insertStickers:(NSArray<NSManagedObject *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStickersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStickersAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceStickersAtIndexes:(NSIndexSet *)indexes withStickers:(NSArray<NSManagedObject *> *)values;
- (void)addStickersObject:(NSManagedObject *)value;
- (void)removeStickersObject:(NSManagedObject *)value;
- (void)addStickers:(NSOrderedSet<NSManagedObject *> *)values;
- (void)removeStickers:(NSOrderedSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
