//
//  LaunchScreenViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/14.
//
//

#import "LaunchScreenViewController.h"
#import "Constants.h"
#import "CCamHelper.h"
#import "iOSBindingManager.h"
#import <pop/POP.h>

@interface LaunchScreenViewController ()
@property (nonatomic,strong) NSMutableArray *images;
//@property (nonatomic,strong) UIImageView *spotlight;
@property (nonatomic,strong) UIImageView *logo;
@property (nonatomic,strong) UIImageView *name;

@end

@implementation LaunchScreenViewController
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _images = [NSMutableArray new];
//    
//    for (int i = 1; i<21; i++) {
//        [_images addObject:[NSString stringWithFormat:@"launch%d",i]];
//    }
    
//    int value =arc4random_uniform(20);
    
    self.view.backgroundColor = CCamRedColor;
    
    _logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 311, 311)];
    [_logo setCenter:CGPointMake(CCamViewWidth/2,CCamViewHeight+150+32)];
    [self.view addSubview:_logo];
    [_logo setContentMode:UIViewContentModeScaleAspectFit];
    [_logo setImage:[UIImage imageNamed:@"launchLogo"]];
    [_logo setTintColor:CCamRedColor];
    
//    _spotlight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 82, 32)];
//    [_spotlight setCenter:CGPointMake(CCamViewWidth/2,CCamViewHeight+32)];
//    [self.view addSubview:_spotlight];
//    [_spotlight setContentMode:UIViewContentModeScaleAspectFit];
//    [_spotlight setImage:[UIImage imageNamed:@"timelineSpotlight"]];
//    [_spotlight setTintColor:CCamRedColor];
    
    _name = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 143, 59)];
    _name.alpha = 0;
    [_name setCenter:CGPointMake(CCamViewWidth/2, (CCamViewHeight-311)/2)];
    [self.view addSubview:_name];
    [_name setContentMode:UIViewContentModeScaleAspectFit];
    
    NSString*language = [[SettingHelper sharedManager] getCurrentLanguage];
    if ([language hasPrefix:@"zh-Hans"]) {
        [_name setImage:[UIImage imageNamed:@"launchNoteCn"]];
    }else{
        [_name setImage:[UIImage imageNamed:@"launchNoteZh"]];
    }
    
    

//    _character = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:_character];
//    [_character setContentMode:UIViewContentModeScaleAspectFit];
//    [_character setCenter:self.view.center];
//    [_character setImage:[UIImage imageNamed:@""]];
//    
//    _subTitle = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:_subTitle];
//    [_subTitle setContentMode:UIViewContentModeScaleAspectFit];
//    [_subTitle setImage:[[UIImage imageNamed:@"aboutTitleCn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
//    [_subTitle setTintColor:CCamRedColor];
    
//    UIButton *btn = [UIButton new];
//    [btn setFrame:CGRectMake(0, 0, 100, 100)];
//    [btn setTitle:@"GO" forState:UIControlStateNormal];
//    [self.view addSubview:btn];
//    [btn setCenter:self.view.center];
//    [btn addTarget:self action:@selector(leave) forControlEvents:UIControlEventTouchUpInside];
}
- (void)leave{
//    [self dismissViewControllerAnimated:NO completion:^{
//        [[iOSBindingManager sharedManager] homeAddNativeSurface];
//    }];
//    [self nameAnimation];
//    [self logoAnimation];
    //    [self.view removeFromSuperview];
//    [self characterAnimation];
//    [self logoAnimation];
//    [self nameAnimation];
//    [self subtitleAnimation];
//    int value =arc4random_uniform(20);
//    [_character setImage:[UIImage imageNamed:[_images objectAtIndex:value]]];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[DataHelper sharedManager] updateSeriesInfo];
    
    [self nameAnimation];
    [self logoAnimation];
//    [self spotlightAnimation];
    [self totleViewAnimation];
}
- (void)logoAnimation{
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anSpring.fromValue = [NSValue valueWithCGPoint:CGPointMake(CCamViewWidth/2,CCamViewHeight+150+32)];
    anSpring.toValue = [NSValue valueWithCGPoint:CGPointMake(CCamViewWidth/2,CCamViewHeight-150)];
    anSpring.beginTime = CACurrentMediaTime()+1.0;
    anSpring.springBounciness = 5.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_logo pop_addAnimation:anSpring forKey:@"position"];
}
- (void)spotlightAnimation{
//    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
//    anSpring.fromValue = [NSValue valueWithCGPoint:CGPointMake(CCamViewWidth/2,CCamViewHeight+32)];
//    anSpring.toValue = [NSValue valueWithCGPoint:CGPointMake(CCamViewWidth/2,CCamViewHeight-201-16)];
//    anSpring.beginTime = CACurrentMediaTime()+1.0;
//    anSpring.springBounciness = 5.0f;
//    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
//        if(finish) {
//            NSLog(@"!");
//        }
//    }];
//    [_spotlight pop_addAnimation:anSpring forKey:@"center"];
}

- (void)nameAnimation{
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anSpring.fromValue = [NSNumber numberWithFloat:0.0];//[NSValue valueWithCGRect:CGRectMake(0, -59, CCamViewWidth, 50)];
    anSpring.toValue = [NSNumber numberWithFloat:1.0];//[NSValue valueWithCGRect:CGRectMake(0, 123+59, 149, 59)];
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.duration = 1.5;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_name pop_addAnimation:anSpring forKey:@"alpha"];
}

- (void)totleViewAnimation{
    
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anSpring.fromValue = [NSNumber numberWithFloat:1.0];
    anSpring.toValue = [NSNumber numberWithFloat:0.0];
    anSpring.beginTime = CACurrentMediaTime()+2.5;
    anSpring.duration = 0.8;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [self.view removeFromSuperview];
        }
    }];
    [self.view pop_addAnimation:anSpring forKey:@"alpha"];
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
