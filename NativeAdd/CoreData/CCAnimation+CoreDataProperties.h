//
//  CCAnimation+CoreDataProperties.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAnimation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *audio;
@property (nullable, nonatomic, retain) NSString *clipName;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *nameJP;
@property (nullable, nonatomic, retain) NSString *nameZH;
@property (nullable, nonatomic, retain) NSString *nameEN;
@property (nullable, nonatomic, retain) NSString *nameCN;
@property (nullable, nonatomic, retain) NSString *playType;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *characterID;
@property (nullable, nonatomic, retain) NSString *frameFirst;
@property (nullable, nonatomic, retain) NSString *frameLast;
@property (nullable, nonatomic, retain) NSString *animationID;
@property (nullable, nonatomic, retain) NSString *serieID;
@property (nullable, nonatomic, retain) NSString *poseFace;
@property (nullable, nonatomic, retain) CCCharacter *character;

@end

NS_ASSUME_NONNULL_END
