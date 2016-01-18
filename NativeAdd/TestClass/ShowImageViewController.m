//
//  ShowImageViewController.m
//  TestScrolls
//
//  Created by Karl on 2015/12/3.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "ShowImageViewController.h"
#import "iOSBindingManager.h"
@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.frame];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setImage:self.showImage];
    [self.view addSubview:image];
    
    [[iOSBindingManager sharedManager] saveCroppedImageWith:[self normalizedImage:self.showImage]];
    
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close sizeToFit];
    [close setCenter:CGPointMake(15+close.frame.size.width/2, 15+close.frame.size.height)];
    [close addTarget:self action:@selector(dismissself) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
}
- (UIImage *)normalizedImage:(UIImage*)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
- (void)dismissself{
    [self dismissViewControllerAnimated:YES completion:nil];
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
