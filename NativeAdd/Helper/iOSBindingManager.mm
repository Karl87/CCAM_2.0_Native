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


void UnitySendMessage( const char * className, const char * methodName, const char * param );
void UnityPause( bool pause );

UIViewController *UnityGetGLViewController();
@interface iOSBindingManager ()
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
- (void)initEditScene{
    NSString *rectStr = [NSString stringWithFormat:@"0|%f|1|%f",CCamThinNaviHeight/CCamViewHeight,CCamViewWidth/CCamViewHeight];
    
    UnitySendMessage(UnityController.UTF8String, "InitUnityScene", rectStr.UTF8String);

}
- (void)homeAddNativeSurface{
    if (!_tabVC) {
        KLTabBarController *tab = [[KLTabBarController alloc] init];
        _tabVC = tab;
        [UnityGetGLViewController() presentViewController:tab animated:NO completion:nil];
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
    
    if (!_editSurface) {
        KLImagePickerViewController *vc = [[KLImagePickerViewController alloc] init];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        [nv beginAppearanceTransition:YES animated:YES];
        [UnityGetGLViewController() addChildViewController:nv];
        [UnityGetGLViewController().view addSubview:nv.view];
        [nv didMoveToParentViewController:UnityGetGLViewController()];
        [nv endAppearanceTransition];
//        _imagePicker = vc;
        _editSurface = nv;
    }
}
- (void)editRemoveNativeSurface{
    if (!_editSurface) {
        return;
    }
    [_editSurface willMoveToParentViewController:nil];
    [_editSurface.view removeFromSuperview];
    [_editSurface removeFromParentViewController];
    _editSurface =nil;
    [self editAddNativeSurface];
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
        direction = @"0|0";
    }
    NSArray *directionArray = [direction componentsSeparatedByString:@"|"];
    CGFloat x = [[directionArray objectAtIndex:0] floatValue];
    CGFloat y = [[directionArray objectAtIndex:1] floatValue];
    [[DataHelper sharedManager].ccamVC setLightDirectionX:x andY:y];
}
- (void)setLightStrength:(NSString *)strength{
    CGFloat strengthValue = [strength floatValue];
    [[DataHelper sharedManager].ccamVC setLightStrength:strengthValue];
}
- (void)setShadowStrength:(NSString *)strength{
    CGFloat strengthValue = [strength floatValue];
    [[DataHelper sharedManager].ccamVC setShadowStrength:strengthValue];
}
- (void)callAnimationControl{
    [[DataHelper sharedManager].ccamVC SetAnimationControlAppear];
}
- (void)removeAnimationControl{
    [[DataHelper sharedManager].ccamVC SetAnimationControlDisappear];
}
- (void)setAnimationInfo:(NSString *)info{
    
}

- (void)moveStuffOut{
    if (_imagePicker !=nil) {
        [_imagePicker.view removeFromSuperview];
        [_imagePicker removeFromParentViewController];
        _imagePicker = nil;
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
@end
