//
//  CCComment+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *commentID;
@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *dateline;
@property (nullable, nonatomic, retain) NSString *replyID;
@property (nullable, nonatomic, retain) NSString *userImage;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) CCTimeLine *timeline;

@end

NS_ASSUME_NONNULL_END
