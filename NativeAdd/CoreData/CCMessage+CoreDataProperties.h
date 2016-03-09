//
//  CCMessage+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/28.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *messageID;
@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *replyUserID;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) NSString *ifRead;
@property (nullable, nonatomic, retain) NSString *messageType;
@property (nullable, nonatomic, retain) NSString *creatTime;
@property (nullable, nonatomic, retain) NSString *ifTop;
@property (nullable, nonatomic, retain) NSString *contestID;
@property (nullable, nonatomic, retain) NSString *messageUserName;
@property (nullable, nonatomic, retain) NSString *messageUserImage;
@property (nullable, nonatomic, retain) NSString *messagePhoto;

@end

NS_ASSUME_NONNULL_END
