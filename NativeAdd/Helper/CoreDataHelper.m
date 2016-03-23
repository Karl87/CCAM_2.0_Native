//
//  CoreDataHelper.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/18.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CoreDataHelper.h"
#import "CCSerie.h"
#import "CCEvent.h"
#import "CCPhoto.h"
#import "Constants.h"
#import "CCamHelper.h"

@implementation CoreDataHelper

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataHelper*)sharedManager
{
    static dispatch_once_t pred;
    static CoreDataHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{ _sharedInstance = [[self alloc] init]; } );
    return _sharedInstance;
}

#pragma mark - Core Data support

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.icm.ccamnativekit.CCamNativeKit" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CCam" withExtension:@"momd"];
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];//[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CCam.sqlite"];
    
    //检查数据库格式
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],
                             NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES],
                             NSInferMappingModelAutomaticallyOption, nil];
    

    
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    NSString *sqlite = [NSString stringWithFormat:@"%@/CCam.sqlite",CCamDocPath];
    NSString *shm = [NSString stringWithFormat:@"%@/CCam.sqlite-shm",CCamDocPath];
    NSString *wal = [NSString stringWithFormat:@"%@/CCam.sqlite-wal",CCamDocPath];
    [[FileHelper sharedManager] addSkipBackupAttributeToItemAtPath:sqlite];
    [[FileHelper sharedManager] addSkipBackupAttributeToItemAtPath:shm];
    [[FileHelper sharedManager] addSkipBackupAttributeToItemAtPath:wal];
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = _managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data Opreations

- (void)insertCoreDataWithType:(NSString*)type andArray:(NSArray*)dataArray{
    
}
- (NSArray*)showStoreInfoWithEntity:(NSString*)entity{
    
    NSLog(@"Show all entity %@!",entity);
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityObj = [NSEntityDescription entityForName:entity
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entityObj];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Show all entity %@ *** %lu!",entity,(unsigned long)fetchedObjects.count);
    
    return fetchedObjects;
}
- (void)deleteStoreInfoWithEntity:(NSString*)entity{
    
//    NSLog(@"Delete entity %@!",entity);
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityObj = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entityObj];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
//            NSLog(@"error:%@",error);
        }
    }
}
- (void)updateStoreInfoWithEntity:(NSString*)entity attributeKey:(NSString*)key attributeValue:(NSString*)value updateValue:(NSString *)newValue{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = %@",key,value]];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if ([entity isEqualToString:@"CCUser"]) {
//        for (CCUser *info in result) {
//            [info setValue:newValue forKey:key];
//        }
    }
    //保存
    if ([context save:&error]) {
        //更新成功
//        NSLog(@"更新成功");
    }
}
- (CCSticker*)getSticker:(NSString *)stickerID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSEntityDescription *entityObj = [NSEntityDescription entityForName:@"CCSticker" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"stickerID = %@",stickerID]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entityObj];
    [request setPredicate:predicate];
    
    NSArray *datas = [context executeFetchRequest:request error:&error];
    
    if (!error && datas && [datas count])
    {
        for (CCSticker*sticker in datas) {
            return sticker;
        }
    }
    return nil;
}
- (CCSerie *)getSerie:(NSString *)serieID{
    
    if(!serieID || [serieID isEqualToString:@""]){
        return nil;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSEntityDescription *entityObj = [NSEntityDescription entityForName:@"CCSerie" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"serieID = %@",serieID]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entityObj];
    [request setPredicate:predicate];
    
    NSArray *datas = [context executeFetchRequest:request error:&error];
    
    if (!error && datas && [datas count])
    {
        for (CCSerie*serie in datas) {
            return serie;
        }
    }
    return nil;
}
- (CCCharacter*)getCharacter:(NSString *)characterID{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSEntityDescription *entityObj = [NSEntityDescription entityForName:@"CCCharacter" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"characterID = %@",characterID]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entityObj];
    [request setPredicate:predicate];
    
    NSArray *datas = [context executeFetchRequest:request error:&error];
    
    if (!error && datas && [datas count])
    {
        for (CCCharacter*character in datas) {
            return character;
        }
    }
    return nil;
}
@end