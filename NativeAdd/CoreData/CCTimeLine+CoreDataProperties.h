//
//  CCTimeLine+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/18.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCTimeLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCTimeLine (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *timelineID;
@property (nullable, nonatomic, retain) NSString *image_contest;
@property (nullable, nonatomic, retain) NSString *image_fullsize;
@property (nullable, nonatomic, retain) NSString *timelineUserID;
@property (nullable, nonatomic, retain) NSString *image_share;
@property (nullable, nonatomic, retain) NSString *timelineDes;
@property (nullable, nonatomic, retain) NSString *likeCount;
@property (nullable, nonatomic, retain) NSString *timelineUserName;
@property (nullable, nonatomic, retain) NSString *timelineUserImage;
@property (nullable, nonatomic, retain) NSString *timelineContestID;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *ranking;
@property (nullable, nonatomic, retain) NSString *lastLikeInfo;
@property (nullable, nonatomic, retain) NSString *countDown;
@property (nullable, nonatomic, retain) NSString *liked;
@property (nullable, nonatomic, retain) NSString *report;

@end

NS_ASSUME_NONNULL_END
