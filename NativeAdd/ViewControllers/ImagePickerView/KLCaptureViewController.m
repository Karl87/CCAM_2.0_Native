//
//  KLCaptureViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/4/12.
//
//

#import "KLCaptureViewController.h"
#import <FastttCamera/FastttCamera.h>

@interface KLCaptureViewController ()<FastttCameraDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) FastttCamera *fastCamera;

@end

@implementation KLCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    self.fastCamera.maxScaledDimension = 600.f;
    
    [self fastttAddChildViewController:self.fastCamera];
    [self.fastCamera.view setFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    [self.fastCamera setCameraDevice:FastttCameraDeviceRear];
    [self.fastCamera setCameraFlashMode:FastttCameraFlashModeOff];
    [self.fastCamera setCameraTorchMode:FastttCameraTorchModeOff];
    
    
    UIButton *btn = [UIButton new];
    [btn setFrame:CGRectMake(10, 10, 100, 44)];
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(viewback) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton new];
    [btn1 setFrame:CGRectMake(150, 10, 100, 44)];
    [btn1 setTitle:@"Capture" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(capture) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)capture{
    [self.fastCamera takePicture];
}
//- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage
//{
//    NSLog(@"yeah");
//}
//- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImageData:(NSData *)rawJPEGData{
//    NSLog(@"yeah");
//}
- (void)viewback{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
