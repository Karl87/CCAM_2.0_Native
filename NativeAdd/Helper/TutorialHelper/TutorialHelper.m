//
//  TutorialHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/21.
//
//

#import "TutorialHelper.h"
#import "EraseTutorialViewController.h"
#import "LightTutorialViewController.h"
#import "ControlTutorialViewController.h"

@interface TutorialHelper()
@property (nonatomic,strong) UIWindow * eraseTutorialWindow;
@property (nonatomic,strong) EraseTutorialViewController *eraseTutorialView;
@property (nonatomic,strong) UIWindow * lightTutorialWindow;
@property (nonatomic,strong) LightTutorialViewController *lightTutorialView;
@property (nonatomic,strong) UIWindow *controlTutorialWindow;
@property (nonatomic,strong) ControlTutorialViewController *controlTutorialView;
@end


@implementation TutorialHelper
+ (TutorialHelper*)sharedManager
{
    static dispatch_once_t pred;
    static TutorialHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{ _sharedInstance = [[self alloc] init]; } );
    return _sharedInstance;
}
- (BOOL)showEraserTutorial{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"autoshowerasetutorial"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        return YES;
    }
    
    return NO;
}
- (void)setShowEraserTutorial:(NSString *)state{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:state forKey:@"autoshowerasetutorial"];
}
- (BOOL)showLightTutorial{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"autoshowlighttutorial"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        return YES;
    }
    
    return NO;
}
- (void)setShowLightTutorial:(NSString *)state{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:state forKey:@"autoshowlighttutorial"];
}
- (BOOL)showControlTutorial{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"autoshowcontroltutorial"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        return YES;
    }
    
    return NO;
}
- (void)setShowControlTutorial:(NSString *)state{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:state forKey:@"autoshowcontroltutorial"];
}
- (void)callControlTutorialView{
    if (_controlTutorialWindow == nil) {
        _controlTutorialWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_controlTutorialWindow setWindowLevel:UIWindowLevelNormal +1];
        
        ControlTutorialViewController * ani = [[ControlTutorialViewController alloc] init];
        _controlTutorialView = ani;
        [_controlTutorialWindow setRootViewController:_controlTutorialView];
    }
    [_controlTutorialWindow makeKeyAndVisible];
    _autoShowLightTutorial = NO;
}

- (void)dismissControlTutorialView{
    
    [_controlTutorialWindow setHidden:YES];
    [_controlTutorialWindow removeFromSuperview];
    [_controlTutorialWindow resignKeyWindow];
    _controlTutorialView = nil;
    _controlTutorialWindow = nil;
    NSLog(@"window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
}
- (void)callLightTutorialView{
    if (_lightTutorialWindow == nil) {
        _lightTutorialWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_lightTutorialWindow setWindowLevel:UIWindowLevelNormal +1];
        
        LightTutorialViewController * ani = [[LightTutorialViewController alloc] init];
        _lightTutorialView = ani;
        [_lightTutorialWindow setRootViewController:_lightTutorialView];
    }
    [_lightTutorialWindow makeKeyAndVisible];
    _autoShowLightTutorial = NO;
}

- (void)dismissLightTutorialView{
    
    [_lightTutorialWindow setHidden:YES];
    [_lightTutorialWindow removeFromSuperview];
    [_lightTutorialWindow resignKeyWindow];
    _lightTutorialView = nil;
    _lightTutorialWindow = nil;
    NSLog(@"window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
}

- (void)callEraseTutorialView{
    if (_eraseTutorialWindow == nil) {
        _eraseTutorialWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_eraseTutorialWindow setWindowLevel:UIWindowLevelNormal +1];
        
        EraseTutorialViewController * ani = [[EraseTutorialViewController alloc] init];
        _eraseTutorialView = ani;
        [_eraseTutorialWindow setRootViewController:_eraseTutorialView];
    }
    [_eraseTutorialWindow makeKeyAndVisible];
    _autoShowEraserTutorial = NO;
}

- (void)dismissEraseTutorialView{
    
    [_eraseTutorialWindow setHidden:YES];
    [_eraseTutorialWindow removeFromSuperview];
    [_eraseTutorialWindow resignKeyWindow];
    _eraseTutorialView = nil;
    _eraseTutorialWindow = nil;
    NSLog(@"window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
}

@end
