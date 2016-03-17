//
//  iOSBindingManager.h
//  Unity-iPhone
//
//  Created by Karl on 14-4-21.
//
//

#import <Foundation/Foundation.h>
#import "CCSerie.h"

@interface iOSBindingManager : NSObject

@property (nonatomic,strong) CCSerie *serie;
@property (nonatomic,assign) BOOL showLauchScreen;

+ (iOSBindingManager*)sharedManager;

- (void)initEditScene;
- (void)homeAddNativeSurface;
- (void)homeRemoveNativeSurface;
- (void)editAddNativeSurface;
- (void)editRemoveNativeSurface;

- (void)setSubmitCharactersList:(NSString*)info;
- (void)setContestSerieID:(NSString *)info;
- (NSString*)getSubmitCharactersList;
- (NSString*)getContestSerieID;

- (void)callLightControl;
- (void)removeLightControl;
- (void)setLightStrength:(NSString*)strength;
- (void)setShadowStrength:(NSString*)strength;
- (void)setLightDirection:(NSString*)direction;

- (void)callAnimationControl;
- (void)removeAnimationControl;
- (void)setAnimationInfo:(NSString*)info;
- (void)setHeadDirection:(NSString *)direction;

- (void)cannotAddMoreCharacter;
- (void)cannotAddDifferentSerieCharacter;

- (void)saveCroppedImageWith:(UIImage *)image;
- (void)saveImageToAlbum:(UIImage*)image;
- (void)addStuff;

- (UIImage *)createImageWithColor:(UIColor *)color;

@end
