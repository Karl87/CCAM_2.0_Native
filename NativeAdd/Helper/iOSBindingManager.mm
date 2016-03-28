//
//  iOSBindingManager.m
//  Unity-iPhone
//
//  Created by Karl on 14-4-21.
//
//

#import "iOSBindingManager.h"
#import "KLImagePickerViewController.h"
#import "Constants.h"
#import "CCamHelper.h"

#import "CCCharacter.h"
#import "CCAnimation.h"

#import "CCamViewController.h"
#import "KLTabBarController.h"
#import "LaunchScreenViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import "ChangeSceneViewController.h"

void UnitySendMessage( const char * className, const char * methodName, const char * param );
void UnityPause( bool pause );

UIViewController *UnityGetGLViewController();
@interface iOSBindingManager ()

@property (nonatomic,strong) UIWindow * changeSceneTransitionWidow;
@property (nonatomic,strong) ChangeSceneViewController *changeSceneTransitionView;

@property (nonatomic,strong) KLTabBarController *tabVC;
@property (nonatomic,strong) KLImagePickerViewController *imagePicker;
@property (nonatomic,strong) UINavigationController *editSurface;
@end

@implementation iOSBindingManager

+ (iOSBindingManager*)sharedManager
{
	static dispatch_once_t pred;
	static iOSBindingManager *_sharedInstance = nil;
    
	dispatch_once( &pred, ^{ _sharedInstance = [[self alloc] init]; } );
	return _sharedInstance;
}
- (id)init{
    self = [super init];
    if (self) {
        _showLauchScreen = YES;
        _currentSerieID = @"0";
    }
    return self;
}
- (void)initEditScene{
    NSString *rectStr = [NSString stringWithFormat:@"0|%f|1|%f",CCamThinNaviHeight/CCamViewHeight,CCamViewWidth/CCamViewHeight];
    
    UnitySendMessage(UnityController.UTF8String, "InitUnityScene", rectStr.UTF8String);

}
- (void)callNativeScene{
    UnitySendMessage(UnityController.UTF8String, "CallHomeScene", "");
}
- (void)showChangeSceneTransition{
    if (_changeSceneTransitionWidow == nil) {
        _changeSceneTransitionWidow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_changeSceneTransitionWidow setWindowLevel:UIWindowLevelNormal +1];
        
        ChangeSceneViewController * ani = [[ChangeSceneViewController alloc] init];
        _changeSceneTransitionView = ani;
        [_changeSceneTransitionWidow setRootViewController:_changeSceneTransitionView];
    }
    [_changeSceneTransitionWidow makeKeyAndVisible];
    [self performSelector:@selector(callNativeScene) withObject:nil afterDelay:0.25];

}
- (void)hideChangeSceneTransition{
    [_changeSceneTransitionWidow setHidden:YES];
    [_changeSceneTransitionWidow removeFromSuperview];
    [_changeSceneTransitionWidow resignKeyWindow];
    _changeSceneTransitionView = nil;
    _changeSceneTransitionWidow = nil;
    NSLog(@"window count = %lu",(unsigned long)[UIApplication sharedApplication].windows.count);
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
}
- (void)homeAddNativeSurface{
    
    
        if (!_tabVC) {
            KLTabBarController *tab = [[KLTabBarController alloc] init];
            _tabVC = tab;
            [UnityGetGLViewController() presentViewController:tab animated:NO completion:nil];
//            if (_showLauchScreen) {
//                LaunchScreenViewController *launch = [[LaunchScreenViewController alloc] init];
//                [_tabVC presentViewController:launch animated:NO completion:^{
//                    _showLauchScreen = NO;
//                }];
//            }
        }
    
}
- (void)homeRemoveNativeSurface{
    if (_tabVC) {
        [_tabVC dismissViewControllerAnimated:NO completion:^{
            _tabVC = nil;
        }];
    }
}
- (void)editAddNativeSurface{
    
    if (_showEditNative) {
        KLImagePickerViewController *vc = [[KLImagePickerViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        [nv beginAppearanceTransition:YES animated:YES];
        [UnityGetGLViewController() addChildViewController:nv];
        [UnityGetGLViewController().view addSubview:nv.view];
        [nv didMoveToParentViewController:UnityGetGLViewController()];
        [nv endAppearanceTransition];
        _editSurface = nv;
    }else{
        _showEditNative = YES;
    }
}
- (void)editRemoveNativeSurface{
//    if (!_editSurface) {
//        return;
//    }
//    for (UIViewController *vc in _editSurface.viewControllers) {
//        [vc.view removeFromSuperview];
//        
//    }
    
    [self editAddNativeSurface];
    
    if (_editSurface) {
        [_editSurface willMoveToParentViewController:nil];
        [_editSurface.view removeFromSuperview];
        [_editSurface removeFromParentViewController];
        _editSurface =nil;
    }
    
    
}
- (void)setSubmitCharactersList:(NSString *)info{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:info forKey:@"submitcharacterlist"];
}
- (NSString*)getSubmitCharactersList{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"submitcharacterlist"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}
- (void)setContestSerieID:(NSString *)info{
    NSLog(@"超原始%@",info);
    _currentSerieID = info;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:info forKey:@"contestserieid"];
}
- (NSString*)getContestSerieID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"contestserieid"]];
    if([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]|| str == NULL||[str isEqualToString:@"(null)"]){
        str = @"";
    }
    
    return str;
}

- (void)callLightControl{
    [[DataHelper sharedManager].ccamVC SetLightControlAppear];
}
- (void)removeLightControl{
    [[DataHelper sharedManager].ccamVC SetLightControlDisappear];
}
- (void)setLightDirection:(NSString *)direction{
    NSLog(@"direction = %@",direction);
    if ([direction isEqualToString:@""]) {
        direction = @"0|0.2";
    }
    NSArray *directionArray = [direction componentsSeparatedByString:@"|"];
    CGFloat x = [[directionArray objectAtIndex:0] floatValue];
    CGFloat y = [[directionArray objectAtIndex:1] floatValue];
    [[DataHelper sharedManager].ccamVC setLightDirectionX:x andY:y];
}
- (void)setHeadDirection:(NSString *)direction{
    NSLog(@"head direction = %@",direction);
    NSError *error;
    NSDictionary *infoDic =[NSJSONSerialization JSONObjectWithData:[direction dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    BOOL hasFunction = NO;
    if ([[infoDic objectForKey:@"hasFunction"] isEqualToString:@"true"]) {
        hasFunction = YES;
    }
    CGFloat xPos = [[infoDic objectForKey:@"xPos"] floatValue];
    CGFloat yPos = [[infoDic objectForKey:@"yPos"] floatValue];
    [[DataHelper sharedManager].ccamVC setHeadDirectionAvilable:hasFunction X:xPos andY:yPos];
}
- (void)setHeadDirectionState:(NSString *)state{
    if ([state isEqualToString:@"true"]) {
        [[DataHelper sharedManager].ccamVC setHeadDirectionAvilable:YES X:0.0 andY:0.0];
    }else{
        [[DataHelper sharedManager].ccamVC setHeadDirectionAvilable:NO X:0.0 andY:0.0];
    }
}
- (void)setLightStrength:(NSString *)strength{
    NSLog(@"SetLightData first:%@",strength);
//    UnitySendMessage(UnityController.UTF8String, "GetCurrentCharactersSerieID", "");
//    _serie = [[CoreDataHelper sharedManager] getSerie:[self getContestSerieID]];
//
    if (_serie) {
        NSMutableDictionary *lightDic = [[NSMutableDictionary alloc] init];
        [lightDic setObject:_serie.environmentMin forKey:@"environmentMin"];
        [lightDic setObject:_serie.environmentMax forKey:@"environmentMax"];
        [lightDic setObject:_serie.mainLightMin forKey:@"mainLightMin"];
        [lightDic setObject:_serie.mainLightMax forKey:@"mainLightMax"];
        [lightDic setObject:_serie.hdrAdd forKey:@"hdrAdd"];
        [lightDic setObject:_serie.addThread forKey:@"addThread"];
        [lightDic setObject:_serie.reflectionMax forKey:@"reflectionMax"];
        NSLog(@"灯光参数设置：%@",lightDic);
        
        NSData*jsonData = [NSJSONSerialization dataWithJSONObject:lightDic options:0 error:nil];
        NSString *jsonString  =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        UnitySendMessage(UnityController.UTF8String, "SetLightData", jsonString.UTF8String);
        _serie = nil;
    }
    
    

    
    NSLog(@"LIGHTSTRENGTH = %@",strength);
    CGFloat strengthValue = [strength floatValue];
//    if (strengthValue == 0) {
//        strengthValue = 0.4;
//    }
//    [[DataHelper sharedManager].ccamVC setLightStrength:strengthValue*2];
    [[DataHelper sharedManager].ccamVC setLightStrength:strengthValue];

}
- (void)setShadowStrength:(NSString *)strength{
    NSLog(@"SHADOWSTRENGTH = %@",strength);
    CGFloat strengthValue = [strength floatValue];
//    if (strengthValue == 0) {
//        strengthValue = 0;
//    }
    [[DataHelper sharedManager].ccamVC setShadowStrength:strengthValue];
}
- (void)callAnimationControl{
    [[DataHelper sharedManager].ccamVC SetAnimationControlAppear];
}
- (void)removeAnimationControl{
    [[DataHelper sharedManager].ccamVC SetAnimationControlDisappear];
}
- (void)setAnimationInfo:(NSString *)info{
    NSLog(@"当前角色动画信息：%@",info);
    [[DataHelper sharedManager].ccamVC setAnimationInfo:info];
}
- (void)cannotAddDifferentSerieCharacter{
    _serie = nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[ViewHelper sharedManager] getCurrentVC].view.window animated:YES];
    [[[ViewHelper sharedManager] getCurrentVC].view.window addSubview:hud];
    hud.detailsLabelText = Babel(@"无法添加其他系列角色");
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 15.0f;
    [hud hide:YES afterDelay:1.0];
    
}
- (void)cannotAddMoreCharacter{
    _serie = nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[ViewHelper sharedManager] getCurrentVC].view.window animated:YES];
    [[[ViewHelper sharedManager] getCurrentVC].view.window addSubview:hud];
    hud.labelText = Babel(@"无法添加更多角色");
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 15.0f;
    [hud hide:YES afterDelay:1.0];
}
- (void)moveStuffOut{
    if (_imagePicker !=nil) {
        [_imagePicker.view removeFromSuperview];
        [_imagePicker removeFromParentViewController];
        _imagePicker = nil;
    }
}
- (void)touchCharacterInOtherState{
    if ([DataHelper sharedManager].ccamVC.characterTitleShaker) {
        [[DataHelper sharedManager].ccamVC.characterTitleShaker shake];
    }
}
- (void)saveCroppedImageWith:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);//UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Choosed.jpg"]; //Add the file name
    NSLog(@"filePath %@",filePath);
    [imageData writeToFile:filePath atomically:YES];
}
- (void)saveImageToAlbum:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    NSString *message = nil ;
    if(error == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Photo saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Photo cannot save!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
