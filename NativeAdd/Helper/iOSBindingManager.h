//
//  iOSBindingManager.h
//  Unity-iPhone
//
//  Created by Karl on 14-4-21.
//
//

#import <Foundation/Foundation.h>

@interface iOSBindingManager : NSObject

+ (iOSBindingManager*)sharedManager;

- (void)initEditScene;
- (void)homeAddNativeSurface;
- (void)homeRemoveNativeSurface;
- (void)editAddNativeSurface;
- (void)editRemoveNativeSurface;

- (void)callLightControl;
- (void)removeLightControl;
- (void)setLightStrength:(NSString*)strength;
- (void)setShadowStrength:(NSString*)strength;
- (void)setLightDirection:(NSString*)direction;

- (void)callAnimationControl;
- (void)removeAnimationControl;
- (void)setAnimationInfo:(NSString*)info;

- (void)saveCroppedImageWith:(UIImage *)image;
- (void)saveImageToAlbum:(UIImage*)image;
- (void)addStuff;
@end
