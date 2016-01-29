//
//  CCTimeLine+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCTimeLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCTimeLine (CoreDataProperties)
@property (nullable, nonatomic, retain) NSString *dateline;
@property (nullable, nonatomic, retain) NSString *cNameZH;
@property (nullable, nonatomic, retain) NSString *cNameCN;
@property (nullable, nonatomic, retain) NSString *cNameEN;
@property (nullable, nonatomic, retain) NSString *countDown;
@property (nullable, nonatomic, retain) NSString *image_contest;
@property (nullable, nonatomic, retain) NSString *image_fullsize;
@property (nullable, nonatomic, retain) NSString *image_share;
@property (nullable, nonatomic, retain) NSString *likeCount;
@property (nullable, nonatomic, retain) NSString *liked;
@property (nullable, nonatomic, retain) NSString *ranking;
@property (nullable, nonatomic, retain) NSString *report;
@property (nullable, nonatomic, retain) NSString *timelineContestID;
@property (nullable, nonatomic, retain) NSString *timelineDes;
@property (nullable, nonatomic, retain) NSString *timelineID;
@property (nullable, nonatomic, retain) NSString *timelineUserID;
@property (nullable, nonatomic, retain) NSString *timelineUserImage;
@property (nullable, nonatomic, retain) NSString *timelineUserName;
@property (nullable, nonatomic, retain) NSOrderedSet<CCComment *> *comments;
@property (nullable, nonatomic, retain) NSOrderedSet<CCLike *> *likes;

@end

@interface CCTimeLine (CoreDataGeneratedAccessors)

- (void)insertObject:(CCComment *)value inCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentsAtIndex:(NSUInteger)idx;
- (void)insertComments:(NSArray<CCComment *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentsAtIndex:(NSUInteger)idx withObject:(CCComment *)value;
- (void)replaceCommentsAtIndexes:(NSIndexSet *)indexes withComments:(NSArray<CCComment *> *)values;
- (void)addCommentsObject:(CCComment *)value;
- (void)removeCommentsObject:(CCComment *)value;
- (void)addComments:(NSOrderedSet<CCComment *> *)values;
- (void)removeComments:(NSOrderedSet<CCComment *> *)values;

- (void)insertObject:(CCLike *)value inLikesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLikesAtIndex:(NSUInteger)idx;
- (void)insertLikes:(NSArray<CCLike *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLikesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLikesAtIndex:(NSUInteger)idx withObject:(CCLike *)value;
- (void)replaceLikesAtIndexes:(NSIndexSet *)indexes withLikes:(NSArray<CCLike *> *)values;
- (void)addLikesObject:(CCLike *)value;
- (void)removeLikesObject:(CCLike *)value;
- (void)addLikes:(NSOrderedSet<CCLike *> *)values;
- (void)removeLikes:(NSOrderedSet<CCLike *> *)values;

@end

NS_ASSUME_NONNULL_END
