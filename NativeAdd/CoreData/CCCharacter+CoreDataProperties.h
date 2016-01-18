//
//  CCCharacter+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCCharacter.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCCharacter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *characterID;
@property (nullable, nonatomic, retain) NSString *serieID;
@property (nullable, nonatomic, retain) NSString *version;
@property (nullable, nonatomic, retain) NSString *assetBundle;
@property (nullable, nonatomic, retain) NSString *nameCN;
@property (nullable, nonatomic, retain) NSString *nameEN;
@property (nullable, nonatomic, retain) NSString *nameZH;
@property (nullable, nonatomic, retain) NSString *nameJP;
@property (nullable, nonatomic, retain) NSString *image_List;
@property (nullable, nonatomic, retain) NSString *image_Mini;
@property (nullable, nonatomic, retain) NSString *dateStart;
@property (nullable, nonatomic, retain) NSString *dateEnd;
@property (nullable, nonatomic, retain) NSString *allowOffline;
@property (nullable, nonatomic, retain) NSString *regionType;
@property (nullable, nonatomic, retain) NSString *regionInfo;
@property (nullable, nonatomic, retain) NSOrderedSet<CCAnimation *> *animations;
@property (nullable, nonatomic, retain) CCSerie *serie;

@end

@interface CCCharacter (CoreDataGeneratedAccessors)

- (void)insertObject:(CCAnimation *)value inAnimationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAnimationsAtIndex:(NSUInteger)idx;
- (void)insertAnimations:(NSArray<CCAnimation *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAnimationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAnimationsAtIndex:(NSUInteger)idx withObject:(CCAnimation *)value;
- (void)replaceAnimationsAtIndexes:(NSIndexSet *)indexes withAnimations:(NSArray<CCAnimation *> *)values;
- (void)addAnimationsObject:(CCAnimation *)value;
- (void)removeAnimationsObject:(CCAnimation *)value;
- (void)addAnimations:(NSOrderedSet<CCAnimation *> *)values;
- (void)removeAnimations:(NSOrderedSet<CCAnimation *> *)values;

@end

NS_ASSUME_NONNULL_END
