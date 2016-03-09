//
//  CCMessage+CoreDataProperties.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/28.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCMessage+CoreDataProperties.h"

@implementation CCMessage (CoreDataProperties)

@dynamic messageID;
@dynamic photoID;
@dynamic userID;
@dynamic replyUserID;
@dynamic message;
@dynamic ifRead;
@dynamic messageType;
@dynamic creatTime;
@dynamic ifTop;
@dynamic contestID;
@dynamic messageUserName;
@dynamic messageUserImage;
@dynamic messagePhoto;

@end
