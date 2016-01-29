//
//  CCLike+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/21.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCLike.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCLike (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *dateline;
@property (nullable, nonatomic, retain) CCTimeLine *timeline;

@end

NS_ASSUME_NONNULL_END
