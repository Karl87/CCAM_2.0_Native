//
//  CCSticker+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCSticker.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCSticker (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *stickerID;
@property (nullable, nonatomic, retain) NSString *stickersetID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *image_Preview;
@property (nullable, nonatomic, retain) NSString *image_Res;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *textFont;
@property (nullable, nonatomic, retain) NSString *textColor;
@property (nullable, nonatomic, retain) NSString *text_Coordinates;
@property (nullable, nonatomic, retain) CCStickerSet *stickerset;

@end

NS_ASSUME_NONNULL_END
