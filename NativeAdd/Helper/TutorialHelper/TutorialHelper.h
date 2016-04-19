//
//  TutorialHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/21.
//
//

#import <Foundation/Foundation.h>

@interface TutorialHelper : NSObject

@property (nonatomic,assign) BOOL autoShowLightTutorial;
@property (nonatomic,assign) BOOL autoShowEraserTutorial;
@property (nonatomic,assign) BOOL autoShowControlTutorial;

+ (TutorialHelper*)sharedManager;

- (BOOL)showControlTutorial;
- (void)setShowControlTutorial:(NSString*)state;

- (BOOL)showEraserTutorial;
- (void)setShowEraserTutorial:(NSString *)state;

- (BOOL)showLightTutorial;
- (void)setShowLightTutorial:(NSString *)state;

- (void)callControlTutorialView;
- (void)dismissControlTutorialView;
- (void)callEraseTutorialView;
- (void)dismissEraseTutorialView;
- (void)callLightTutorialView;
- (void)dismissLightTutorialView;
@end
