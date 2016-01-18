//
//  CoreDataHelper.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/18.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CCCharacter.h"
#import "CCSticker.h"
@interface CoreDataHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataHelper*)sharedManager;

- (NSManagedObjectContext *)managedObjectContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (void)saveContext;

- (CCCharacter *)getCharacter:(NSString*)characterID;
- (CCSticker *)getSticker:(NSString*)stickerID;

- (NSArray*)showStoreInfoWithEntity:(NSString*)entity;
- (void)deleteStoreInfoWithEntity:(NSString*)entity;
- (void)updateStoreInfoWithEntity:(NSString*)entity attributeKey:(NSString*)key attributeValue:(NSString*)value updateValue:(NSString*)newValue;
- (void)insertCoreDataWithType:(NSString*)type andArray:(NSArray*)dataArray;

@end
