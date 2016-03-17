//
//  CCPhoto+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCPhoto (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *contestID;
@property (nullable, nonatomic, retain) NSString *serieID;
@property (nullable, nonatomic, retain) NSString *characterID;
@property (nullable, nonatomic, retain) NSString *stageID;
@property (nullable, nonatomic, retain) NSString *groutID;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *photoType;
@property (nullable, nonatomic, retain) NSString *photoDataType;
@property (nullable, nonatomic, retain) NSString *imageContest;
@property (nullable, nonatomic, retain) NSString *imageMiddle;
@property (nullable, nonatomic, retain) NSString *imageFullsize;
@property (nullable, nonatomic, retain) NSString *imageShare;
@property (nullable, nonatomic, retain) NSString *photoDescription;
@property (nullable, nonatomic, retain) NSString *photoRank;
@property (nullable, nonatomic, retain) NSString *photoClickNum;
@property (nullable, nonatomic, retain) NSString *photoShareClickNum;
@property (nullable, nonatomic, retain) NSString *photoChecked;
@property (nullable, nonatomic, retain) NSString *photoReport;
@property (nullable, nonatomic, retain) NSString *photoIsFinalist;
@property (nullable, nonatomic, retain) NSString *photoWinnerStatus;
@property (nullable, nonatomic, retain) NSString *dateline;
@property (nullable, nonatomic, retain) NSString *like;
@property (nullable, nonatomic, retain) NSString *uploadType;
@property (nullable, nonatomic, retain) NSString *userImage;
@property (nullable, nonatomic, retain) NSString *liked;

@end

NS_ASSUME_NONNULL_END
