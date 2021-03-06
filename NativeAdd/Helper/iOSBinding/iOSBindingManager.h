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

@property (nonatomic,strong) NSString *currentSerieID;
@property (nonatomic,assign) BOOL showEditNative;
@property (nonatomic,strong) CCSerie *serie;
@property (nonatomic,assign) BOOL showLauchScreen;

+ (iOSBindingManager*)sharedManager;

- (void)initEditScene;
- (void)callNativeScene;

- (void)showChangeSceneTransition;
- (void)hideChangeSceneTransition;

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
- (void)setHeadDirectionState:(NSString *)state;

- (void)cannotAddMoreCharacter;
- (void)cannotAddDifferentSerieCharacter;

- (BOOL)saveCroppedImageWith:(UIImage *)image;
- (void)saveImageToAlbum:(UIImage*)image;
- (void)addStuff;

- (void)touchCharacterInOtherState;

- (UIImage *)createImageWithColor:(UIColor *)color;

@end
