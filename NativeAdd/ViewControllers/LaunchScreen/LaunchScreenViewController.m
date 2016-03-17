//
//  LaunchScreenViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/14.
//
//

#import "LaunchScreenViewController.h"
#import "Constants.h"
#import "iOSBindingManager.h"
#import <pop/POP.h>

@interface LaunchScreenViewController ()
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) UIImageView *character;
@property (nonatomic,strong) UIImageView *logo;
@property (nonatomic,strong) UIImageView *name;
@property (nonatomic,strong) UIImageView *subTitle;
@property (nonatomic,strong) UILabel *copyright;
@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _images = [NSMutableArray new];
    
    for (int i = 1; i<21; i++) {
        [_images addObject:[NSString stringWithFormat:@"launch%d",i]];
    }
    
    int value =arc4random_uniform(20);
    
    self.view.backgroundColor = CCamViewBackgroundColor;
    
    _logo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_logo];
    [_logo setContentMode:UIViewContentModeScaleAspectFit];
    [_logo setImage:[[UIImage imageNamed:@"aboutLogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_logo setTintColor:CCamRedColor];
    
    _name = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_name];
    [_name setContentMode:UIViewContentModeScaleAspectFit];
    [_name setImage:[[UIImage imageNamed:@"aboutTitleCn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_name setTintColor:CCamRedColor];

    _character = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_character];
    [_character setContentMode:UIViewContentModeScaleAspectFit];
    [_character setCenter:self.view.center];
    [_character setImage:[UIImage imageNamed:[_images objectAtIndex:value]]];
    
    _subTitle = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_subTitle];
    [_subTitle setContentMode:UIViewContentModeScaleAspectFit];
    [_subTitle setImage:[[UIImage imageNamed:@"aboutTitleCn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_subTitle setTintColor:CCamRedColor];
    
    UIButton *btn = [UIButton new];
    [btn setFrame:CGRectMake(0, 0, 100, 100)];
    [btn setTitle:@"GO" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setCenter:self.view.center];
    [btn addTarget:self action:@selector(leave) forControlEvents:UIControlEventTouchUpInside];
}
- (void)leave{
//    [self dismissViewControllerAnimated:NO completion:^{
//        [[iOSBindingManager sharedManager] homeAddNativeSurface];
//    }];
    [self.view removeFromSuperview];
//    [self characterAnimation];
//    [self logoAnimation];
//    [self nameAnimation];
//    [self subtitleAnimation];
//    int value =arc4random_uniform(20);
//    [_character setImage:[UIImage imageNamed:[_images objectAtIndex:value]]];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self characterAnimation];
    [self logoAnimation];
    [self nameAnimation];
    [self subtitleAnimation];
}
- (void)characterAnimation{
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anSpring.fromValue = [NSValue valueWithCGRect:CGRectMake(CCamViewWidth/2, CCamViewHeight/2, 0, 0)];
    anSpring.toValue = [NSValue valueWithCGRect:CGRectMake(0, (CCamViewHeight-202)/2, CCamViewWidth, 202)];
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.springBounciness = 20.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_character pop_addAnimation:anSpring forKey:@"position"];
}
- (void)logoAnimation{
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anSpring.fromValue = [NSValue valueWithCGRect:CGRectMake(0, -120, CCamViewWidth, 50)];
    anSpring.toValue = [NSValue valueWithCGRect:CGRectMake(0, (CCamViewHeight-202)/2-120, CCamViewWidth, 50)];
    anSpring.beginTime = CACurrentMediaTime()+0.5;
    anSpring.springBounciness = 10.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_logo pop_addAnimation:anSpring forKey:@"position"];
}
- (void)nameAnimation{
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anSpring.fromValue = [NSValue valueWithCGRect:CGRectMake(0, -50, CCamViewWidth, 50)];
    anSpring.toValue = [NSValue valueWithCGRect:CGRectMake(0, (CCamViewHeight-202)/2-50, CCamViewWidth, 50)];
    anSpring.beginTime = CACurrentMediaTime()+0.5;
    anSpring.springBounciness = 10.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_name pop_addAnimation:anSpring forKey:@"position"];
}
- (void)subtitleAnimation{
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anSpring.fromValue = [NSValue valueWithCGRect:CGRectMake(0, CCamViewHeight+50, CCamViewWidth, 50)];
    anSpring.toValue = [NSValue valueWithCGRect:CGRectMake(0, (CCamViewHeight-202)/2+202, CCamViewWidth, 50)];
    anSpring.beginTime = CACurrentMediaTime()+0.5;
    anSpring.springBounciness = 10.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_subTitle pop_addAnimation:anSpring forKey:@"position"];
}
- (void)totleViewAnimation{
    
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
