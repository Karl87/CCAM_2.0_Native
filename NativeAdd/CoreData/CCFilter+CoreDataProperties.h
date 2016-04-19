//
//  CCFilter+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2016/4/13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCFilter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name_file;
@property (nullable, nonatomic, retain) NSString *name_cn;
@property (nullable, nonatomic, retain) NSString *name_en;
@property (nullable, nonatomic, retain) NSString *name_zh;
@property (nullable, nonatomic, retain) NSString *image_mini;

@end

NS_ASSUME_NONNULL_END
