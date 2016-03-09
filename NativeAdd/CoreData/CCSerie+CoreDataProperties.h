//
//  CCSerie+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCSerie.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCSerie (CoreDataProperties)
@property (nullable, nonatomic, retain) NSString *environmentMin;
@property (nullable, nonatomic, retain) NSString *environmentMax;
@property (nullable, nonatomic, retain) NSString *mainLightMin;
@property (nullable, nonatomic, retain) NSString *mainLightMax;
@property (nullable, nonatomic, retain) NSString *hdrAdd;
@property (nullable, nonatomic, retain) NSString *addThread;
@property (nullable, nonatomic, retain) NSString *indexRecommend;
@property (nullable, nonatomic, retain) NSString *indexPopular;
@property (nullable, nonatomic, retain) NSString *indexLastest;
@property (nullable, nonatomic, retain) NSString *serieID;
@property (nullable, nonatomic, retain) NSString *nameCN;
@property (nullable, nonatomic, retain) NSString *nameEN;
@property (nullable, nonatomic, retain) NSString *nameZH;
@property (nullable, nonatomic, retain) NSString *nameJP;
@property (nullable, nonatomic, retain) NSString *image_List;
@property (nullable, nonatomic, retain) NSString *image_Inner;
@property (nullable, nonatomic, retain) NSString *image_Mini;
@property (nullable, nonatomic, retain) NSString *redirectURL;
@property (nullable, nonatomic, retain) NSString *allowSticker;
@property (nullable, nonatomic, retain) NSString *dateStart;
@property (nullable, nonatomic, retain) NSString *dateEnd;
@property (nullable, nonatomic, retain) NSString *regionType;
@property (nullable, nonatomic, retain) NSString *regionInfo;
@property (nullable, nonatomic, retain) NSString *allowMultiple;
@property (nullable, nonatomic, retain) NSString *allowErase;
@property (nullable, nonatomic, retain) NSString *allFilter;
@property (nullable, nonatomic, retain) NSString *image_Watermark;
@property (nullable, nonatomic, retain) NSString *id_Sticker;

@property (nullable, nonatomic, retain) NSOrderedSet<CCCharacter *> *characters;

@end

@interface CCSerie (CoreDataGeneratedAccessors)

- (void)insertObject:(CCCharacter *)value inCharactersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCharactersAtIndex:(NSUInteger)idx;
- (void)insertCharacters:(NSArray<CCCharacter *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCharactersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCharactersAtIndex:(NSUInteger)idx withObject:(CCCharacter *)value;
- (void)replaceCharactersAtIndexes:(NSIndexSet *)indexes withCharacters:(NSArray<CCCharacter *> *)values;
- (void)addCharactersObject:(CCCharacter *)value;
- (void)removeCharactersObject:(CCCharacter *)value;
- (void)addCharacters:(NSOrderedSet<CCCharacter *> *)values;
- (void)removeCharacters:(NSOrderedSet<CCCharacter *> *)values;

@end

NS_ASSUME_NONNULL_END
