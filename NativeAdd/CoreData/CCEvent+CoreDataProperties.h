//
//  CCEvent+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCEvent (CoreDataProperties)
@property (nullable, nonatomic, retain) NSString *eventDescriptionEn;
@property (nullable, nonatomic, retain) NSString *eventDescriptionZh;
@property (nullable, nonatomic, retain) NSString *eventCount;
@property (nullable, nonatomic, retain) NSString *eventCountDown;
@property (nullable, nonatomic, retain) NSString *eventDescriptionCn;
@property (nullable, nonatomic, retain) NSString *eventImageURLCn;
@property (nullable, nonatomic, retain) NSString *eventImageURLEn;
@property (nullable, nonatomic, retain) NSString *eventImageURLZh;
@property (nullable, nonatomic, retain) NSString *eventIsStart;
@property (nullable, nonatomic, retain) NSString *eventName;
@property (nullable, nonatomic, retain) NSString *eventURL;
@property (nullable, nonatomic, retain) NSString *shareTitle;
@property (nullable, nonatomic, retain) NSString *shareSubtitle;
@property (nullable, nonatomic, retain) NSString *shareImage;

@end

NS_ASSUME_NONNULL_END
